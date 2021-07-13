Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C8C13C74C9
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235322AbhGMQh3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234944AbhGMQhL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 12:37:11 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F77C0613B7
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:16 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id o12-20020a5b050c0000b02904f4a117bd74so27729545ybp.17
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 09:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=SpdLdjXPNNhl9wZEIGsluiDA75HnwRkDLJ0hyfNw524=;
        b=t4kjJYieQpw4LJJALxZZ4yV76kGvq8sra8kEjcnQ/7a5lTzX7A6+wiG8ekpz7CQX4a
         Pe8S7iB37i6ptXkE42k3LXAaLtO59dWKm6lWAgzAzJB9Cwpm+MF5RAVjdSF2xMGyCurH
         +W1b6lpnT6MyT431QmjSyogeY4Ezs/g+qK3dauIgzmvURYHnLgZarQrl6yx3DSNggXLS
         QcUq9U0GDoourspKZfcRadoHXEinNe53UcM0w7SIfjoXA38Zmvv0DYsnr3obTK1vwDPQ
         IIgTUoWgr0/h2/iqv+qcKbqvInG1NJ5XTRFDd1SHKRbh+UPSQu4KgYhJ+hb0JbNQPAE9
         Rnng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=SpdLdjXPNNhl9wZEIGsluiDA75HnwRkDLJ0hyfNw524=;
        b=PDKgWJfOaqmWhKFQb2wDGeCqAd/B/b8PmkhA/yINsrfF2wr1NGZdU7QWLX6BqlwCwO
         DNrrNpySpxiMkjDhRhWsLDI5FD95kdyO6/v1ESAPhnqS9moB3+8I4EkJt+q9cpty8lta
         ef44tjop5hktFoUDeiJQREQxYImJNiAmGnam6DEIBrwRt2Is07LaVOwCV0UnK58C7IDT
         jtH8LBL0wkd9gQbObXxCWMqpWAzvE+MMWeO/Nm+oZj0jPQ75B+F3rWj2Kxc1sHE4LUKq
         jeYjJHLc9sz4l54b8I4rGp5Jb+Cl6qYW0Y+77E4VN36jknmXtVJz5hwZPGXBTgMb437J
         ujqA==
X-Gm-Message-State: AOAM533R+yjRO0YQLm7oHQLHwbbKLkks4u+OIDBMpZFCQG93r4b386rj
        Gybh45s5MvdtsDc/M7f+wNBvsghYegw=
X-Google-Smtp-Source: ABdhPJz0YhX1hkBr0YJh3SNPRM0IKCsv7wp5ZfOtSE+e0NjzuKVwEpYI/kv5sNqlISvMSKALs+bCp5wCQg4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:825e:11a1:364b:8109])
 (user=seanjc job=sendgmr) by 2002:a25:ae25:: with SMTP id a37mr7393055ybj.253.1626194055577;
 Tue, 13 Jul 2021 09:34:15 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 13 Jul 2021 09:33:00 -0700
In-Reply-To: <20210713163324.627647-1-seanjc@google.com>
Message-Id: <20210713163324.627647-23-seanjc@google.com>
Mime-Version: 1.0
References: <20210713163324.627647-1-seanjc@google.com>
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v2 22/46] KVM: VMX: Remove direct write to vcpu->arch.cr0
 during vCPU RESET/INIT
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove a bogus write to vcpu->arch.cr0 that immediately precedes
vmx_set_cr0() during vCPU RESET/INIT.  For RESET, this is a nop since
the "old" CR0 value is meaningless.  But for INIT, if the vCPU is coming
from paging enabled mode, crushing vcpu->arch.cr0 will cause the various
is_paging() checks in vmx_set_cr0() to get false negatives.

For the exit_lmode() case, the false negative is benign as vmx_set_efer()
is called immediately after vmx_set_cr0().

For EPT without unrestricted guest, the false negative will cause KVM to
unnecessarily run with CR3 load/store exiting.  But again, this is
benign, albeit sub-optimal.

Reviewed-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/vmx.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 02aec75ec6f6..ed631564c651 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4383,7 +4383,6 @@ static void init_vmcs(struct vcpu_vmx *vmx)
 static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
-	u64 cr0;
 
 	if (!init_event)
 		init_vmcs(vmx);
@@ -4454,9 +4453,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
-	cr0 = X86_CR0_NW | X86_CR0_CD | X86_CR0_ET;
-	vmx->vcpu.arch.cr0 = cr0;
-	vmx_set_cr0(vcpu, cr0); /* enter rmode */
+	vmx_set_cr0(vcpu, X86_CR0_NW | X86_CR0_CD | X86_CR0_ET);
 	vmx_set_cr4(vcpu, 0);
 	vmx_set_efer(vcpu, 0);
 
-- 
2.32.0.93.g670b81a890-goog

