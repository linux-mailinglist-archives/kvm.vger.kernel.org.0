Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E67454FFCD
	for <lists+kvm@lfdr.de>; Sat, 18 Jun 2022 00:20:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240952AbiFQWUB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 18:20:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbiFQWT7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 18:19:59 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBF660D98
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 15:19:58 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f65so5127482pgc.7
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 15:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y4NHgUg9WpFHNCRb+agzIiQQzsx+4mBHzK/+oNn7d6g=;
        b=RfN4KU0jVEQKDvQTiuFWwY4goDFGm3D/RyCojWYKCi67pzOqYOiC6r2XOV9md4whw7
         NDBf8LmdKo3PbX8cbMekXZ2UihRItmDBR0Ht4UwGwLt2o2dWr72Chu36i3AbVmIObVni
         tF+Z2DDiD8TMNrEFrZaipVqVC/9HDskPDP2j3KwPU7MCqzv6ijclWSVleWVqlu7ZqfZz
         kXksVD6cwot8cBY8KFEIkA/erGEwqRAfetES5Lo75YPO1eP9dOqGR4ajiu8ReeH9SZtS
         hAZRGFaT2/qnzYiOo+Z9Q1KoREAf1DfK7L+hMUqE87KLDGnXvM7in0z2wlt9AiSB1a8W
         7Cng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=y4NHgUg9WpFHNCRb+agzIiQQzsx+4mBHzK/+oNn7d6g=;
        b=YZn6kAvUn6zVC+zfc2o2N+2Kkl+HEoQ7GAc4uroO8RaE2rQaZKNeeBvqRwrckb5u5i
         DXtgQsbD+ADeSk7pGE/YSbWvevH2rJHBYNSlPwV1M3PPaZ+5r/v07MsDK9FQRlNMgC5e
         Xiwi5Oj5wANxNpFkBXPtSBc2I0J3foKZOGHw0MbhyPndefzU8CH2vfbkOK77vW7WhCrg
         jZqa+mwwdhPyW8W8mPkROVW4uPBpS00FvObhMKRqVhlrX8gclD3DN6tm0nhoD+3Wak3r
         NBsvhHxGRxJPoV2gCTcxM1cz6l+AXXWpaVVsSLCx+YvmxFTjrRmD64jfNZvVTA058QxU
         4rbA==
X-Gm-Message-State: AJIora+K2gpLwUSx6L2/0FSYnud76ZagstBV8pjK1O/DdYJwmGl5mU4/
        xN6TTuwEyHDdqOFLvv8JV0V2j/DN3yls7g==
X-Google-Smtp-Source: AGRyM1u58z4nj7/dF8PdoIPsV7W3Gcn9ao2II7+rRYdrWFEBoFhFxD2eH/q6ieN6aE+p441nFrTSfw==
X-Received: by 2002:a63:894a:0:b0:3fc:a724:578c with SMTP id v71-20020a63894a000000b003fca724578cmr11065712pgd.499.1655504397759;
        Fri, 17 Jun 2022 15:19:57 -0700 (PDT)
Received: from google.com (123.65.230.35.bc.googleusercontent.com. [35.230.65.123])
        by smtp.gmail.com with ESMTPSA id m14-20020a170902bb8e00b00168a651316csm4024462pls.270.2022.06.17.15.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 15:19:57 -0700 (PDT)
Date:   Fri, 17 Jun 2022 22:19:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SEV: Init target VMCBs in sev_migrate_from
Message-ID: <Yqz+CZlGCoQo7lMQ@google.com>
References: <20220617195141.2866706-1-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617195141.2866706-1-pgonda@google.com>
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

On Fri, Jun 17, 2022, Peter Gonda wrote:
> @@ -1681,6 +1683,10 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>  
>  	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
>  
> +	kvm_for_each_vcpu(i, vcpu, dst_kvm) {
> +		sev_init_vmcb(to_svm(vcpu));

Curly braces are unnecessary.

> +	}
> +
>  	/*
>  	 * If this VM has mirrors, "transfer" each mirror's refcount of the
>  	 * source to the destination (this KVM).  The caller holds a reference
> @@ -1739,6 +1745,8 @@ static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
>  		src_svm->vmcb->control.ghcb_gpa = INVALID_PAGE;
>  		src_svm->vmcb->control.vmsa_pa = INVALID_PAGE;
>  		src_vcpu->arch.guest_state_protected = false;
> +
> +		sev_es_init_vmcb(dst_svm);
>  	}
>  	to_kvm_svm(src)->sev_info.es_active = false;
>  	to_kvm_svm(dst)->sev_info.es_active = true;
> @@ -2914,6 +2922,12 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
>  				    count, in);
>  }
>  
> +void sev_init_vmcb(struct vcpu_svm *svm)
> +{
> +	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
> +	clr_exception_intercept(svm, UD_VECTOR);

I don't love separating SEV and SEV-ES VMCB initialization, especially since they're
both doing RMW operations and not straight writes.  E.g. migration ends up reversing
the order between the two relatively to init_vmcb().  That's just asking for a subtle
bug to be introduced that affects only due to the ordering difference.

What about using common top-level flows for SEV and SEV-ES so that the sequencing
between SEV and SEV-ES is more rigid?  The resulting sev_migrate_from() is a little
gross, but IMO it's worth having a fixed sequence, and the flip side to the ugliness
it that it documents some of the differences between SEV and SEV-ES migration.

---
 arch/x86/kvm/svm/sev.c | 75 +++++++++++++++++++++++++++---------------
 arch/x86/kvm/svm/svm.c | 11 ++-----
 arch/x86/kvm/svm/svm.h |  2 +-
 3 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 51fd985cf21d..9efb679d89d1 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1665,7 +1665,10 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 {
 	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
 	struct kvm_sev_info *src = &to_kvm_svm(src_kvm)->sev_info;
+	struct kvm_vcpu *dst_vcpu, *src_vcpu;
+	struct vcpu_svm *dst_svm, *src_svm;
 	struct kvm_sev_info *mirror;
+	unsigned long i;

 	dst->active = true;
 	dst->asid = src->asid;
@@ -1704,27 +1707,22 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
 		list_del(&src->mirror_entry);
 		list_add_tail(&dst->mirror_entry, &owner_sev_info->mirror_vms);
 	}
-}

-static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
-{
-	unsigned long i;
-	struct kvm_vcpu *dst_vcpu, *src_vcpu;
-	struct vcpu_svm *dst_svm, *src_svm;
-
-	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
-		return -EINVAL;
-
-	kvm_for_each_vcpu(i, src_vcpu, src) {
-		if (!src_vcpu->arch.guest_state_protected)
-			return -EINVAL;
-	}
-
-	kvm_for_each_vcpu(i, src_vcpu, src) {
-		src_svm = to_svm(src_vcpu);
-		dst_vcpu = kvm_get_vcpu(dst, i);
+	kvm_for_each_vcpu(i, dst_vcpu, dst_kvm) {
 		dst_svm = to_svm(dst_vcpu);

+		sev_init_vmcb(dst_svm);
+
+		if (!src->es_active)
+			continue;
+
+		/*
+		 * Note, the source is not required to have the same number of
+		 * vCPUs as the destination when migrating a vanilla SEV VM.
+		 */
+		src_vcpu = kvm_get_vcpu(dst_kvm, i);
+		src_svm = to_svm(src_vcpu);
+
 		/*
 		 * Transfer VMSA and GHCB state to the destination.  Nullify and
 		 * clear source fields as appropriate, the state now belongs to
@@ -1740,8 +1738,26 @@ static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
 		src_svm->vmcb->control.vmsa_pa = INVALID_PAGE;
 		src_vcpu->arch.guest_state_protected = false;
 	}
-	to_kvm_svm(src)->sev_info.es_active = false;
-	to_kvm_svm(dst)->sev_info.es_active = true;
+
+	dst->es_active = src->es_active;
+	src->es_active = false;
+}
+
+static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
+{
+	struct kvm_vcpu *src_vcpu;
+	unsigned long i;
+
+	if (!sev_es_guest(src))
+		return 0;
+
+	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
+		return -EINVAL;
+
+	kvm_for_each_vcpu(i, src_vcpu, src) {
+		if (!src_vcpu->arch.guest_state_protected)
+			return -EINVAL;
+	}

 	return 0;
 }
@@ -1789,11 +1805,9 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
 	if (ret)
 		goto out_dst_vcpu;

-	if (sev_es_guest(source_kvm)) {
-		ret = sev_es_migrate_from(kvm, source_kvm);
-		if (ret)
-			goto out_source_vcpu;
-	}
+	ret = sev_check_source_vcpus(kvm, source_kvm);
+	if (ret)
+		goto out_source_vcpu;

 	sev_migrate_from(kvm, source_kvm);
 	kvm_vm_dead(source_kvm);
@@ -2914,7 +2928,7 @@ int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in)
 				    count, in);
 }

-void sev_es_init_vmcb(struct vcpu_svm *svm)
+static void sev_es_init_vmcb(struct vcpu_svm *svm)
 {
 	struct kvm_vcpu *vcpu = &svm->vcpu;

@@ -2967,6 +2981,15 @@ void sev_es_init_vmcb(struct vcpu_svm *svm)
 	}
 }

+void sev_init_vmcb(struct vcpu_svm *svm)
+{
+	svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
+	clr_exception_intercept(svm, UD_VECTOR);
+
+	if (sev_es_guest(svm->vcpu.kvm))
+		sev_es_init_vmcb(svm);
+}
+
 void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
 	/*
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index c6cca0ce127b..a6bb67738005 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1259,15 +1259,8 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
 		svm->vmcb->control.int_ctl |= V_GIF_ENABLE_MASK;
 	}

-	if (sev_guest(vcpu->kvm)) {
-		svm->vmcb->control.nested_ctl |= SVM_NESTED_CTL_SEV_ENABLE;
-		clr_exception_intercept(svm, UD_VECTOR);
-
-		if (sev_es_guest(vcpu->kvm)) {
-			/* Perform SEV-ES specific VMCB updates */
-			sev_es_init_vmcb(svm);
-		}
-	}
+	if (sev_guest(vcpu->kvm))
+		sev_init_vmcb(svm);

 	svm_hv_init_vmcb(vmcb);
 	init_vmcb_after_set_cpuid(vcpu);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 128993feb4c6..444a7a67122a 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -653,10 +653,10 @@ void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
 void sev_hardware_unsetup(void);
 int sev_cpu_init(struct svm_cpu_data *sd);
+void sev_init_vmcb(struct vcpu_svm *svm);
 void sev_free_vcpu(struct kvm_vcpu *vcpu);
 int sev_handle_vmgexit(struct kvm_vcpu *vcpu);
 int sev_es_string_io(struct vcpu_svm *svm, int size, unsigned int port, int in);
-void sev_es_init_vmcb(struct vcpu_svm *svm);
 void sev_es_vcpu_reset(struct vcpu_svm *svm);
 void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector);
 void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa);

base-commit: 8baacf67c76c560fed954ac972b63e6e59a6fba0
--

