Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21791446125
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 10:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231890AbhKEJK5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 05:10:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22098 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229923AbhKEJK4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 5 Nov 2021 05:10:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636103297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9RnbKgFe+rSKHY36srJ1aoAiwQRKbM9Dlp4WWP49cUg=;
        b=gss3vxJMr/2dJoI/RNpK8oQv83HmbhpZA+qm2gDslEglVU/tfgtcvRmam5zZoe/EmqBi1T
        a88m7Z9LmcxMnT50qiX+hj01MVIhhDVzFa4CE14HbdLBAYU0wal6p5QLZeLD540UpZ1EQG
        xEBFFFSjHiNnOJOzE/PIvZ30D7tMjMw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-274-UR9QrfBtPriAD0KWSC15vQ-1; Fri, 05 Nov 2021 05:08:16 -0400
X-MC-Unique: UR9QrfBtPriAD0KWSC15vQ-1
Received: by mail-wr1-f69.google.com with SMTP id q17-20020adfcd91000000b0017bcb12ad4fso2088174wrj.12
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 02:08:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9RnbKgFe+rSKHY36srJ1aoAiwQRKbM9Dlp4WWP49cUg=;
        b=gjuHJfh0b4uEQjH+/RW9ug19cvEy0DoMPKnfgvrT8QQIF1CtSbWUwSEEtVAcWgr63V
         41fdqezxwMtTwAeZl47PN6XzKvdc77J8UU39OyTN4zDu25gCaUXQ8Fd2dCmAyQOOauTs
         N5FeYX5vo0qepACNCxNF6onBIhO9DvupwPSTSdZWC3KpsEm/FUMdpAHSJCU/Lv4Mi00D
         bzGinb5Z3bQqQfGmlTVJazNQ2N8bBv1m6junu9LH2JdsUAqwjqUQ0GAx/LQ6xGRxDQ0/
         JankxXbzOPbqeEfNtn6HaBW/Wwsjyk4CpFwTdBeP+gZOdsT5ouK3/8ePIooG4AKDVSaS
         gQyw==
X-Gm-Message-State: AOAM530uHnaOG3QWYszzLKAaWFgiuMW7ZCj1Ze2ttS6RuG1mO4UCcjM3
        k3zijR3imhbvFBUplkpen+rmrO4Tq6tUgLHRkFPv5uEZt1PxDHLLV7H2VY0gvpqAhlmKJa/o3u4
        v0wLBE6wA7qOS
X-Received: by 2002:a5d:598c:: with SMTP id n12mr51878496wri.250.1636103295105;
        Fri, 05 Nov 2021 02:08:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwTJqYEZVPBgYpfgpO+zjGDBDWDUvmpjmRZWzpVkG2YSDJV3pF23+CjRwaf+lnNOZKHr5wxfg==
X-Received: by 2002:a5d:598c:: with SMTP id n12mr51878468wri.250.1636103294840;
        Fri, 05 Nov 2021 02:08:14 -0700 (PDT)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id r10sm7605990wrl.92.2021.11.05.02.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 02:08:14 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Li RongQing <lirongqing@baidu.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com,
        lirongqing@baidu.com
Subject: Re: [PATCH] KVM: x86: disable pv eoi if guest gives a wrong address
In-Reply-To: <1636078404-48617-1-git-send-email-lirongqing@baidu.com>
References: <1636078404-48617-1-git-send-email-lirongqing@baidu.com>
Date:   Fri, 05 Nov 2021 10:08:13 +0100
Message-ID: <87v917km0y.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Li RongQing <lirongqing@baidu.com> writes:

> disable pv eoi if guest gives a wrong address, this can reduces
> the attacked possibility for a malicious guest, and can avoid
> unnecessary write/read pv eoi memory
>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  arch/x86/kvm/lapic.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index b1de23e..0f37a8d 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2853,6 +2853,7 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
>  	u64 addr = data & ~KVM_MSR_ENABLED;
>  	struct gfn_to_hva_cache *ghc = &vcpu->arch.pv_eoi.data;
>  	unsigned long new_len;
> +	int ret;
>  
>  	if (!IS_ALIGNED(addr, 4))
>  		return 1;
> @@ -2866,7 +2867,13 @@ int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
>  	else
>  		new_len = len;
>  
> -	return kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
> +	ret = kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
> +
> +	if (ret && (vcpu->arch.pv_eoi.msr_val & KVM_MSR_ENABLED)) {
> +		vcpu->arch.pv_eoi.msr_val &= ~KVM_MSR_ENABLED;
> +		pr_warn_once("Disabled PV EOI during wrong address\n");

Personally, I see little value in this message: it's not easy to say
which particular guest triggered it so it's unclear what system
administrator is supposed to do upon seeing this message. 

Also, while on it, I think kvm_lapic_enable_pv_eoi() is misnamed: it is
also used for *disabling* PV EOI.

Instead of dropping KVM_MSR_ENABLED bit, I'd suggest we only set
vcpu->arch.pv_eoi.msr_val in case of success. In case
kvm_gfn_to_hva_cache_init() fails, we inject #GP so it's reasonable to
expect that MSR's value didn't change.

Completely untested:

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index 1cdcf3ad5684..9fe5e2a2df25 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1472,7 +1472,7 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 
 		if (!(data & HV_X64_MSR_VP_ASSIST_PAGE_ENABLE)) {
 			hv_vcpu->hv_vapic = data;
-			if (kvm_lapic_enable_pv_eoi(vcpu, 0, 0))
+			if (kvm_lapic_set_pv_eoi(vcpu, 0, 0))
 				return 1;
 			break;
 		}
@@ -1490,9 +1490,9 @@ static int kvm_hv_set_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data, bool host)
 			return 1;
 		hv_vcpu->hv_vapic = data;
 		kvm_vcpu_mark_page_dirty(vcpu, gfn);
-		if (kvm_lapic_enable_pv_eoi(vcpu,
-					    gfn_to_gpa(gfn) | KVM_MSR_ENABLED,
-					    sizeof(struct hv_vp_assist_page)))
+		if (kvm_lapic_set_pv_eoi(vcpu,
+					 gfn_to_gpa(gfn) | KVM_MSR_ENABLED,
+					 sizeof(struct hv_vp_assist_page)))
 			return 1;
 		break;
 	}
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 4da5db83736f..38b9cb26a81d 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2851,25 +2851,31 @@ int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 reg, u64 *data)
 	return 0;
 }
 
-int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
+int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len)
 {
 	u64 addr = data & ~KVM_MSR_ENABLED;
 	struct gfn_to_hva_cache *ghc = &vcpu->arch.pv_eoi.data;
 	unsigned long new_len;
+	int ret;
 
 	if (!IS_ALIGNED(addr, 4))
 		return 1;
 
-	vcpu->arch.pv_eoi.msr_val = data;
-	if (!pv_eoi_enabled(vcpu))
-		return 0;
+	if (data & KVM_MSR_ENABLED) {
+		if (addr == ghc->gpa && len <= ghc->len)
+			new_len = ghc->len;
+		else
+			new_len = len;
 
-	if (addr == ghc->gpa && len <= ghc->len)
-		new_len = ghc->len;
-	else
-		new_len = len;
+		ret = kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
 
-	return kvm_gfn_to_hva_cache_init(vcpu->kvm, ghc, addr, new_len);
+		if (ret)
+			return ret;
+	}
+
+	vcpu->arch.pv_eoi.msr_val = data;
+
+	return 0;
 }
 
 int kvm_apic_accept_events(struct kvm_vcpu *vcpu)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index d7c25d0c1354..2b44e533fc8d 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -127,7 +127,7 @@ int kvm_x2apic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 int kvm_hv_vapic_msr_write(struct kvm_vcpu *vcpu, u32 msr, u64 data);
 int kvm_hv_vapic_msr_read(struct kvm_vcpu *vcpu, u32 msr, u64 *data);
 
-int kvm_lapic_enable_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
+int kvm_lapic_set_pv_eoi(struct kvm_vcpu *vcpu, u64 data, unsigned long len);
 void kvm_lapic_exit(void);
 
 #define VEC_POS(v) ((v) & (32 - 1))
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dccf927baa4d..7d9bc8c185da 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3517,7 +3517,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		if (!guest_pv_has(vcpu, KVM_FEATURE_PV_EOI))
 			return 1;
 
-		if (kvm_lapic_enable_pv_eoi(vcpu, data, sizeof(u8)))
+		if (kvm_lapic_set_pv_eoi(vcpu, data, sizeof(u8)))
 			return 1;
 		break;
 

> +	}
> +	return ret;
>  }
>  
>  int kvm_apic_accept_events(struct kvm_vcpu *vcpu)

-- 
Vitaly

