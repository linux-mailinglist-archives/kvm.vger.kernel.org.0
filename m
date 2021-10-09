Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16E2A427641
	for <lists+kvm@lfdr.de>; Sat,  9 Oct 2021 04:16:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244451AbhJICRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Oct 2021 22:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244497AbhJICRX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Oct 2021 22:17:23 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75B1C061788
        for <kvm@vger.kernel.org>; Fri,  8 Oct 2021 19:13:56 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id j193-20020a2523ca000000b005b789d71d9aso14936001ybj.21
        for <kvm@vger.kernel.org>; Fri, 08 Oct 2021 19:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=BSxRZmRXQvTOhREE9VGZ+Ow0Eb/sKeyruI9O693O544=;
        b=Nq6mAzMn8lDyB3Y76plThgBUM5+lzQFzvcnH6nf4492bBrVyn9ck7GKbYqiO0fPX1k
         RtO6Tbh+fVA8kKKB5dfSn40puADaw1AZTWHfUhXRqDCPxkpaLN/jW7P8wDCNf5O+ZN2W
         o20t3D7+BvjahIP2EWoNGDpuq75LRMnoeyo+2e07rHfheQBVKmrV3GR1iNU5W+dWkxdx
         q3sbYxMcvibv82b/Gn150GZhBkJ6/ximka4nAWWizGZ/RcYQl+xqLlKkBDXDFmHazy20
         mn7+XEIvuuwdQeI+uMO7ytk/Gxh9aFkTHmGL9NUGs5Tnak8RvnSPI5FeOcxYuto9C6rq
         7/XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=BSxRZmRXQvTOhREE9VGZ+Ow0Eb/sKeyruI9O693O544=;
        b=5hUCPs0Id9lFqQS9xDjI+wJ+FbQjrWSOCHTeQK+imJftCGTqUMa5OcFHypOSPpmuTz
         ml04hdF5ZqxnzCQ2jnxZoaYRE1JlE6ZgK4Q+ZbahjNdKLHgO2W8MXEzW3RWYtCc0vtxN
         mYMyFIsbz+vWmcn31J8VeJXJa2elRUQjk+nQ3aHXcaLyJ36HQturJRxOWyxwMJ1eBzM4
         qZ9SBDFumzLDchb3EyQsZdPyu5U9S0sd+vjSIlmCEILKnbyfJ9yrg3fcUTRok11zseXy
         /B5/X3Fx8KjkHKxvem6tN8nYbDTfsY09DKBgv50P0MlnhM8QqYH0/mEeW2JvLdfTDygX
         J0UA==
X-Gm-Message-State: AOAM532KEZBXwnWy5WBzWi4qHXGBndq0xdyVSY8Iy39o9N1Oksp1mDiS
        rrtNPIKmaYQMvMsC8wUJiIc6j/gw6os=
X-Google-Smtp-Source: ABdhPJwWmIgGATZaEFLCpRZX3pSkHkB9RK0xc5KzmBhnfa/imJ82wP/Pf1l0pMZYT2dHdA6zyBMoRuy25Io=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:e39b:6333:b001:cb])
 (user=seanjc job=sendgmr) by 2002:a25:5402:: with SMTP id i2mr7429080ybb.312.1633745635912;
 Fri, 08 Oct 2021 19:13:55 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri,  8 Oct 2021 19:12:23 -0700
In-Reply-To: <20211009021236.4122790-1-seanjc@google.com>
Message-Id: <20211009021236.4122790-31-seanjc@google.com>
Mime-Version: 1.0
References: <20211009021236.4122790-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v2 30/43] KVM: Drop unused kvm_vcpu.pre_pcpu field
From:   Sean Christopherson <seanjc@google.com>
To:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Paul Mackerras <paulus@ozlabs.org>,
        Anup Patel <anup.patel@wdc.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Atish Patra <atish.patra@wdc.com>,
        David Hildenbrand <david@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Matlack <dmatlack@google.com>,
        Oliver Upton <oupton@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Remove kvm_vcpu.pre_pcpu as it no longer has any users.  No functional
change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/kvm_host.h | 1 -
 virt/kvm/kvm_main.c      | 1 -
 2 files changed, 2 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 1fa38dc00b87..87996b22e681 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -304,7 +304,6 @@ struct kvm_vcpu {
 	u64 requests;
 	unsigned long guest_debug;
 
-	int pre_pcpu;
 	struct list_head blocked_vcpu_list;
 
 	struct mutex mutex;
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c870cae7e776..2bbf5c9d410f 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -426,7 +426,6 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 #endif
 	kvm_async_pf_vcpu_init(vcpu);
 
-	vcpu->pre_pcpu = -1;
 	INIT_LIST_HEAD(&vcpu->blocked_vcpu_list);
 
 	kvm_vcpu_set_in_spin_loop(vcpu, false);
-- 
2.33.0.882.g93a45727a2-goog

