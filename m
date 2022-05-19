Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6166A52D9C5
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241698AbiESQG6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238931AbiESQG5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:06:57 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3492F386
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:06:56 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id c2so5222829plh.2
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 09:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vb5Fnrc6nvtN1QtPGNOnSmpxdHdQwhzVPVW+3aY5wHk=;
        b=bthLWmgwcikyZgGW6rfnkIduMLxplP+DXLV0jYgCgLPYDUYOnSFxunRjjtmbMLvTsh
         Sb07SOOLIEr7jmCPXtgmCs1nkY1OAOhbqJj5++OYyW8VQlTC7ix0RDfar6BjM6SQozbU
         CGXT6au5xsfjXj5ZIcMDlpYS2QrDsL+YHg2fxz0By7UbglWG+i0ixwv3IqN+8tepzyzR
         WJSJbjhM8rYadb/PQ+66UpxzMkLvCkqr6aAcJkM/sKJAgqbAZHh1s6d+Qjgo44MK4vnd
         bnMCRhYyAEOQHd0ecCPLdXij7An1AfrHImdoL9qP+DlwZhbKZqm3fxXKQzq1VxefDRit
         EIEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vb5Fnrc6nvtN1QtPGNOnSmpxdHdQwhzVPVW+3aY5wHk=;
        b=wlWCI8hWIneBXwyxTMOwm9tU8iLisLN2UPSsvlruHh7sCyz4+qokWdSwWjAUiIKdtR
         z9EPGMZnps/NEk1uInhDZZOWCS8NPEJPQYqR7S8JywESiCcHtK+uBnsITrBNuCamP2Y3
         Br1mjUg6riafdxab5FZcydiKFSsRGeQBCtbd6aSSwuOVjEbGOq2Nvbr4j+7GEKWn26bA
         KCzW4Zc/IZDrCQ1fQZ6uCk5c/uput0dsfl3YPvB6Crg9RbFmFAwFXz4pmkiUdESIiz1w
         LCvpCC4SvRJMPopOh5hnb5TERifBNaRgvXzWUhSJb+lwv0fIBoZibAUFIjaEk6VVOT0U
         2vrg==
X-Gm-Message-State: AOAM53049i07xTK/HL5zF3j7x5KdNxjSL8YaTDxc03+T2j6hsGTawjr/
        aF+0RPMonLw5oTV4lCbOk7KRnA==
X-Google-Smtp-Source: ABdhPJyeLc4AGyvXKd1KpG/Rm0x8OTOUXyvVlK/e3r152D9+knL3BxE9xzM0Up4sV2KRWTCnHP/A4A==
X-Received: by 2002:a17:90b:1c82:b0:1dd:1b46:5aa9 with SMTP id oo2-20020a17090b1c8200b001dd1b465aa9mr5954557pjb.158.1652976415612;
        Thu, 19 May 2022 09:06:55 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b2-20020a621b02000000b005182d0a3d5csm4029858pfb.7.2022.05.19.09.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 09:06:55 -0700 (PDT)
Date:   Thu, 19 May 2022 16:06:51 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Ingo Molnar <mingo@redhat.com>,
        David Airlie <airlied@linux.ie>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        intel-gfx@lists.freedesktop.org, Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [RFC PATCH v3 02/19] KVM: x86: inhibit APICv/AVIC when the guest
 and/or host changes apic id/base from the defaults.
Message-ID: <YoZrG3n5fgMp4LQl@google.com>
References: <20220427200314.276673-1-mlevitsk@redhat.com>
 <20220427200314.276673-3-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220427200314.276673-3-mlevitsk@redhat.com>
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

On Wed, Apr 27, 2022, Maxim Levitsky wrote:
> Neither of these settings should be changed by the guest and it is
> a burden to support it in the acceleration code, so just inhibit
> it instead.
> 
> Also add a boolean 'apic_id_changed' to indicate if apic id ever changed.
> 
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 +++
>  arch/x86/kvm/lapic.c            | 25 ++++++++++++++++++++++---
>  arch/x86/kvm/lapic.h            |  8 ++++++++
>  3 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 63eae00625bda..636df87542555 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1070,6 +1070,8 @@ enum kvm_apicv_inhibit {
>  	APICV_INHIBIT_REASON_ABSENT,
>  	/* AVIC is disabled because SEV doesn't support it */
>  	APICV_INHIBIT_REASON_SEV,
> +	/* APIC ID and/or APIC base was changed by the guest */

I don't see any reason to inhibit APICv if the APIC base is changed.  KVM has
never supported that, and disabling APICv won't "fix" anything.

Ignoring that is a minor simplification, but also allows for a more intuitive
name, e.g.

	APICV_INHIBIT_REASON_APIC_ID_MODIFIED,

The inhibit also needs to be added avic_check_apicv_inhibit_reasons() and
vmx_check_apicv_inhibit_reasons().

> +	APICV_INHIBIT_REASON_RO_SETTINGS,
>  };
>  
>  struct kvm_arch {
> @@ -1258,6 +1260,7 @@ struct kvm_arch {
>  	hpa_t	hv_root_tdp;
>  	spinlock_t hv_root_tdp_lock;
>  #endif
> +	bool apic_id_changed;
>  };
>  
>  struct kvm_vm_stat {
> diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
> index 66b0eb0bda94e..8996675b3ef4c 100644
> --- a/arch/x86/kvm/lapic.c
> +++ b/arch/x86/kvm/lapic.c
> @@ -2038,6 +2038,19 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
>  	}
>  }
>  
> +static void kvm_lapic_check_initial_apic_id(struct kvm_lapic *apic)

The "check" part is misleading/confusing.  "check" helpers usually query and return
state.  I assume you avoided "changed" because the ID may or may not actually be
changing.  Maybe kvm_apic_id_updated()?  Ah, better idea.  What about
kvm_lapic_xapic_id_updated()?  See below for reasoning.

> +{
> +	if (kvm_apic_has_initial_apic_id(apic))

Rather than add a single-use helper, invoke the helper from kvm_apic_state_fixup()
in the !x2APIC path, then this can KVM_BUG_ON() x2APIC to help document that KVM
should never allow the ID to change for x2APIC.

> +		return;
> +
> +	pr_warn_once("APIC ID change is unsupported by KVM");

It's supported (modulo x2APIC shenanigans), otherwise KVM wouldn't need to disable
APICv.

> +	kvm_set_apicv_inhibit(apic->vcpu->kvm,
> +			APICV_INHIBIT_REASON_RO_SETTINGS);
> +
> +	apic->vcpu->kvm->arch.apic_id_changed = true;
> +}
> +
>  static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  {
>  	int ret = 0;
> @@ -2046,9 +2059,11 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
>  
>  	switch (reg) {
>  	case APIC_ID:		/* Local APIC ID */
> -		if (!apic_x2apic_mode(apic))
> +		if (!apic_x2apic_mode(apic)) {
> +

Spurious newline.

>  			kvm_apic_set_xapic_id(apic, val >> 24);
> -		else
> +			kvm_lapic_check_initial_apic_id(apic);
> +		} else

Needs curly braces for both paths.

>  			ret = 1;
>  		break;
>  

E.g.

---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            | 21 +++++++++++++++++++--
 arch/x86/kvm/svm/avic.c         |  3 ++-
 arch/x86/kvm/vmx/vmx.c          |  3 ++-
 4 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index d895d25c5b2f..d888fa1bae77 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1071,6 +1071,7 @@ enum kvm_apicv_inhibit {
 	APICV_INHIBIT_REASON_BLOCKIRQ,
 	APICV_INHIBIT_REASON_ABSENT,
 	APICV_INHIBIT_REASON_SEV,
+	APICV_INHIBIT_REASON_APIC_ID_MODIFIED,
 };

 struct kvm_arch {
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 5fd678c90288..6fe8f20f03d8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2039,6 +2039,19 @@ static void apic_manage_nmi_watchdog(struct kvm_lapic *apic, u32 lvt0_val)
 	}
 }

+static void kvm_lapic_xapic_id_updated(struct kvm_lapic *apic)
+{
+	struct kvm *kvm = apic->vcpu->kvm;
+
+	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
+		return;
+
+	if (kvm_xapic_id(apic) == apic->vcpu->vcpu_id)
+		return;
+
+	kvm_set_apicv_inhibit(kvm, APICV_INHIBIT_REASON_APIC_ID_MODIFIED);
+}
+
 static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 {
 	int ret = 0;
@@ -2047,10 +2060,12 @@ static int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)

 	switch (reg) {
 	case APIC_ID:		/* Local APIC ID */
-		if (!apic_x2apic_mode(apic))
+		if (!apic_x2apic_mode(apic)) {
 			kvm_apic_set_xapic_id(apic, val >> 24);
-		else
+			kvm_lapic_xapic_id_updated(apic);
+		} else {
 			ret = 1;
+		}
 		break;

 	case APIC_TASKPRI:
@@ -2665,6 +2680,8 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
 			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 		}
+	} else {
+		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
 	}

 	return 0;
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index 54fe03714f8a..239c3e8b1f3f 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -910,7 +910,8 @@ bool avic_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 			  BIT(APICV_INHIBIT_REASON_PIT_REINJ) |
 			  BIT(APICV_INHIBIT_REASON_X2APIC) |
 			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
-			  BIT(APICV_INHIBIT_REASON_SEV);
+			  BIT(APICV_INHIBIT_REASON_SEV) |
+			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED);

 	return supported & BIT(reason);
 }
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index b06eafa5884d..941adade21ea 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7818,7 +7818,8 @@ static bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason)
 	ulong supported = BIT(APICV_INHIBIT_REASON_DISABLE) |
 			  BIT(APICV_INHIBIT_REASON_ABSENT) |
 			  BIT(APICV_INHIBIT_REASON_HYPERV) |
-			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ);
+			  BIT(APICV_INHIBIT_REASON_BLOCKIRQ) |
+			  BIT(APICV_INHIBIT_REASON_APIC_ID_MODIFIED);

 	return supported & BIT(reason);
 }

base-commit: 6ab6e3842d18e4529fa524fb6c668ae8a8bf54f4
--

