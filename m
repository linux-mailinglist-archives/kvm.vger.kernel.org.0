Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E607956C297
	for <lists+kvm@lfdr.de>; Sat,  9 Jul 2022 01:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237669AbiGHW70 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 18:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236471AbiGHW7Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 18:59:25 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F2A371B2
        for <kvm@vger.kernel.org>; Fri,  8 Jul 2022 15:59:25 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id x18-20020a17090a8a9200b001ef83b332f5so3306003pjn.0
        for <kvm@vger.kernel.org>; Fri, 08 Jul 2022 15:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t5EzBlTQafaLcNfbloeqnjeXuP1xFVRtM1VvoQ9j9dI=;
        b=Tqe8l8cKtheIItoulQxWWXUCFkREjoTO9NZaZungKtWApRW5l4RhHY/nn4s0xwtr0a
         NVb1JZYWxLsfUs29PMHLNivCVnjX9043SkIVcgFKbmb7t/K+GcY8rEKZjGBAIlv8LKlQ
         7840eIMYopJRUfTdck4aZeQub2eGi2A5a2dipRfmC4ZNOEd33dthFdao7/0dcOnlZIKb
         l02UACMsC7pHyGQQMIaGYmEh6lniY7d/0hsW2cqK8i+vOdrmhZN61RA5WrgtaWRHvX00
         LOnpQO7Keos+sCzPZH1x8ffWxvYM0efdflBQaVRX7TgnWxiQqW9Hw2g8w3IJoAP3R6Va
         Sb5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t5EzBlTQafaLcNfbloeqnjeXuP1xFVRtM1VvoQ9j9dI=;
        b=vRqA8ofuFvT0o3GeKRwn24hH6wj/i1cfBD6z7gw/GtJUCxK4HcgvlzNdZlp/YZgomj
         Pf8dgxE9qM5PI4t2FHG61crqgBbOgN0h7vcG6b+oSMGG5kR+lLxSq/dhBJiNRxZsRWWc
         VRf8CCpJwIDnKRDrUD9ECAsyGStv9YVE+OK03vCD4ARYReylLENfncAZ+THzAQtzUVnI
         QR8C8u8AYhZlDbZ5fLfdNVMbljDjFJfSD3jTCcmCc7W00WYhuXKGE1Bl3bWRL+YYPIKw
         pTuFP+9SJxUJ6z1yjQiB4rgf8KsRoMcwKPeq5WG8LFLqpWqEaerrriV/NTgKiZ5/dBdY
         h8Wg==
X-Gm-Message-State: AJIora/2H3Lt4Zs2tgtz9KojgkduuQPQtz0nBR4HK+MXiUIdWSIHhejY
        ytnNW5IA7xNyma6POW+8L6nptQ==
X-Google-Smtp-Source: AGRyM1v0cJOkofzSxdiipD+q9Gq92Q9vCIVSYhEM+eHl1m0uZjPfpUEEP20Wc15m9UTKJvjGPhp1UA==
X-Received: by 2002:a17:902:e946:b0:16b:d4e1:a405 with SMTP id b6-20020a170902e94600b0016bd4e1a405mr5872498pll.16.1657321164425;
        Fri, 08 Jul 2022 15:59:24 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id u7-20020a170903124700b0016bee668a5asm50117plh.161.2022.07.08.15.59.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 15:59:23 -0700 (PDT)
Date:   Fri, 8 Jul 2022 22:59:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jue Wang <juew@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Siddh Raman Pant <code@siddh.me>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Matlack <dmatlack@google.com>,
        Tony Luck <tony.luck@intel.com>, kvm@vger.kernel.org,
        Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v2 2/2] KVM: x86: Fix access to vcpu->arch.apic when the
 irqchip is not in kernel
Message-ID: <Ysi2yH+PJZe+i5DT@google.com>
References: <20220706145957.32156-1-juew@google.com>
 <20220706145957.32156-2-juew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220706145957.32156-2-juew@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 06, 2022, Jue Wang wrote:
> Fix an access to vcpu->arch.apic when KVM_X86_SETUP_MCE is called
> without KVM_CREATE_IRQCHIP called or KVM_CAP_SPLIT_IRQCHIP is
> enabled.
> 
> Reported-by: https://syzkaller.appspot.com/bug?id=10b9b238e087a6c9bef2cc48bee2375f58fabbfc
> 
> Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
> Signed-off-by: Jue Wang <juew@google.com>
> ---
>  arch/x86/kvm/x86.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4322a1365f74..5913f90ec3f2 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4820,8 +4820,9 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
>  		if (mcg_cap & MCG_CMCI_P)
>  			vcpu->arch.mci_ctl2_banks[bank] = 0;
>  	}
> -	vcpu->arch.apic->nr_lvt_entries =
> -		KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
> +	if (lapic_in_kernel(vcpu))
> +		vcpu->arch.apic->nr_lvt_entries =
> +			KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);

This is incomplete.  If there's a "new" LVT entry, then it needs to be initialized
(masked), and the APIC version needs to be updated to reflect the up-to-date number
of LVT entries.

This is what I came up with, again compile tested only, will formally post next
week.

From: Sean Christopherson <seanjc@google.com>
Date: Fri, 8 Jul 2022 15:48:10 -0700
Subject: [PATCH] KVM: x86: Fix handling of APIC LVT updates when userspace
 changes MCG_CAP

Add a helper to update KVM's in-kernel local APIC in response to MCG_CAP
being changed by userspace to fix multiple bugs.  First and foremost,
KVM needs to check that there's an in-kernel APIC prior to dereferencing
vcpu->arch.apic.  Beyond that, any "new" LVT entries need to be masked,
and the APIC version register needs to be updated as it reports out the
number of LVT entries.

Fixes: 4b903561ec49 ("KVM: x86: Add Corrected Machine Check Interrupt (CMCI) emulation to lapic.")
Reported-by: syzbot+8cdad6430c24f396f158@syzkaller.appspotmail.com
Cc: Siddh Raman Pant <code@siddh.me>
Cc: Jue Wang <juew@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/lapic.c | 19 +++++++++++++++++++
 arch/x86/kvm/lapic.h |  1 +
 arch/x86/kvm/x86.c   |  4 ++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 1540d01ecb67..50354c7a2dc1 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -433,6 +433,25 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 	kvm_lapic_set_reg(apic, APIC_LVR, v);
 }

+void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu)
+{
+	int nr_lvt_entries = kvm_apic_calc_nr_lvt_entries(vcpu);
+	struct kvm_lapic *apic = vcpu->arch.apic;
+	int i;
+
+	if (!lapic_in_kernel(vcpu) || nr_lvt_entries == apic->nr_lvt_entries)
+		return;
+
+	/* Initialize/mask any "new" LVT entries. */
+	for (i = apic->nr_lvt_entries; i < nr_lvt_entries; i++)
+		kvm_lapic_set_reg(apic, APIC_LVTx(i), APIC_LVT_MASKED);
+
+	apic->nr_lvt_entries = nr_lvt_entries;
+
+	/* The number of LVT entries is reflected in the version register. */
+	kvm_apic_set_version(vcpu);
+}
+
 static const unsigned int apic_lvt_mask[KVM_APIC_MAX_NR_LVT_ENTRIES] = {
 	[LVT_TIMER] = LVT_MASK,      /* timer mode mask added at runtime */
 	[LVT_THERMAL_MONITOR] = LVT_MASK | APIC_MODE_MASK,
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 762bf6163798..117a46df5cc1 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -99,6 +99,7 @@ void kvm_lapic_set_base(struct kvm_vcpu *vcpu, u64 value);
 u64 kvm_lapic_get_base(struct kvm_vcpu *vcpu);
 void kvm_recalculate_apic_map(struct kvm *kvm);
 void kvm_apic_set_version(struct kvm_vcpu *vcpu);
+void kvm_apic_after_set_mcg_cap(struct kvm_vcpu *vcpu);
 bool kvm_apic_match_dest(struct kvm_vcpu *vcpu, struct kvm_lapic *source,
 			   int shorthand, unsigned int dest, int dest_mode);
 int kvm_apic_compare_prio(struct kvm_vcpu *vcpu1, struct kvm_vcpu *vcpu2);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index fb37d11dec2d..801c3cfd3db5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4893,8 +4893,8 @@ static int kvm_vcpu_ioctl_x86_setup_mce(struct kvm_vcpu *vcpu,
 		if (mcg_cap & MCG_CMCI_P)
 			vcpu->arch.mci_ctl2_banks[bank] = 0;
 	}
-	vcpu->arch.apic->nr_lvt_entries =
-		KVM_APIC_MAX_NR_LVT_ENTRIES - !(mcg_cap & MCG_CMCI_P);
+
+	kvm_apic_after_set_mcg_cap(vcpu);

 	static_call(kvm_x86_setup_mce)(vcpu);
 out:

base-commit: 03d84f96890662681feee129cf92491f49247d28
--

