Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19318369DFB
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:48:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244408AbhDXAtD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244287AbhDXAsQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:48:16 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 927A9C061348
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:20 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id e65-20020a25e7440000b02904ecfeff1ed8so14909037ybh.19
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=H46lT8DkG1h570Zv+xu7UsGwwPn89nRKlivzLO/8BXo=;
        b=owrm6gGDzwQ7FwWNwHfNIhmy9Lqo8phxgwqD6ABoLD/cJGiyhu67gPfYzx0aSg+8KF
         tVdZy/nzRqIfcXY4br9XBeoi78tHRe3ubmjQT59+rK0iYKK4LkR1s244D39i+m91gT8u
         f+sumHioWtfft0u9tpTeh6BWiOzfc1hhyPvnA7V357DF5/1Gnfj1wq1OVqzA6AsSLa1r
         mqM1r+FWCGacwM+kT0PDIzDlcmmbN6JPXkDJ8FOoEmv3182DZfKtdhhTXdYkKqIfF5+8
         guepsKVT6MArtV8J1s+UvpX+oUhkOMM3Pgp/mi4ozsj3IsviwkeKfdxzB/SjoAP54D0y
         YP2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=H46lT8DkG1h570Zv+xu7UsGwwPn89nRKlivzLO/8BXo=;
        b=I6cFARQ+dQoEU/6y8ongNmNwW8MzUXuajiRTVSkARx8yXEDtAojXncXi+REclOz3Rs
         PQOdgzXP8Zq04oQ7ohqOrXmSCCyY8BaPTpC7wcfr9CuNclL+d+xiHdRQ9PS1DlOOIr/G
         D/YMPUtTgrm7D0TMplJBMg5n9gdAQ+J2EWo+mz3RYkeoOV1VnJfviq3qaN9FnbYSrff3
         2qL7wNK35Z5fLg/uktb6dl/GAF6wuKrtzJNKo12cVef8kPoxSKWSjPtU51edNbyz1U5x
         qyZh7q+z+WXOLFRYKEr7MGq+G7F0JHsGZ/ctx+JoCxxgykrzwqUfQJBpuRTZ9rBWKhe8
         Et1w==
X-Gm-Message-State: AOAM530zycB5SGfWYKGBVF3Y5BOm4bC0EpzR/9RycaxgJO9i5HwfZVUX
        0P1AhBRtPHU7D4D23mkRb+pQC2uXQD8=
X-Google-Smtp-Source: ABdhPJxh0IUsb0ZRQ30lwpzDVONjxt/W1mIo+x+7drFrxe04MX4a5WLKSNARh2B34kk5H7MeCvQ4lxn71ec=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:ab53:: with SMTP id u77mr9566083ybi.48.1619225239877;
 Fri, 23 Apr 2021 17:47:19 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:11 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-10-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 09/43] KVM: SVM: Drop a redundant init_vmcb() from svm_create_vcpu()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop an extra init_vmcb() from svm_create_vcpu(), svm_vcpu_reset() is
guaranteed to call init_vmcb() and there are no consumers of the VMCB
data between ->vcpu_create() and ->vcpu_reset().  Keep the call to
svm_switch_vmcb() as sev_es_create_vcpu() touches the current VMCB, but
hoist it up a few lines to associate the switch with the allocation of
vmcb01.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/svm/svm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index fbea2f45de9a..6c73ea3d20c6 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1371,15 +1371,13 @@ static int svm_create_vcpu(struct kvm_vcpu *vcpu)
 
 	svm->vmcb01.ptr = page_address(vmcb01_page);
 	svm->vmcb01.pa = __sme_set(page_to_pfn(vmcb01_page) << PAGE_SHIFT);
+	svm_switch_vmcb(svm, &svm->vmcb01);
 
 	if (vmsa_page)
 		svm->vmsa = page_address(vmsa_page);
 
 	svm->guest_state_loaded = false;
 
-	svm_switch_vmcb(svm, &svm->vmcb01);
-	init_vmcb(vcpu);
-
 	svm_init_osvw(vcpu);
 	vcpu->arch.microcode_version = 0x01000065;
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

