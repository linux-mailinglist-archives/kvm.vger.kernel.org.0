Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B80936E5122
	for <lists+kvm@lfdr.de>; Mon, 17 Apr 2023 21:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbjDQTqC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Apr 2023 15:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjDQTqB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Apr 2023 15:46:01 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F88128;
        Mon, 17 Apr 2023 12:45:59 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2a8a4cbe473so224001fa.1;
        Mon, 17 Apr 2023 12:45:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681760757; x=1684352757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D/oSd11M1/DeKW+VmnRVEUHBAvD0YQ+O/weH1jrtyyQ=;
        b=FPmDRqu+gB2j/IjjexFZo0zt3n/Qy3Klbee55/oOUnkPpIXhsQsCnM71Pf0+WApNXw
         iw1iHscLc/g6gIYX8GWv57EBCelxK411XZ/S8kjBVMAmJ1puW1aGcV92cflnr6q4Qpwc
         L87II9qPIBb9trCxx9p4fNF2w8TgRRRvxj7/6P4T463+NSs0kwu9R5zvSSBx7UZKAZZl
         F9seck2SvB7tOh5BxuG1HgP0M4EOwQMLcVfklzBZ95Cq1GLTOPXB4y3z5wkDO6708Ep3
         UXeNhxMEfw+iDlG8M2DzRJh08JOP3mmVPXqNnHoreVHqTYxbLNu3vJYc3h7xqM+j0N8K
         ezeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681760757; x=1684352757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D/oSd11M1/DeKW+VmnRVEUHBAvD0YQ+O/weH1jrtyyQ=;
        b=KzFxQEkl3w29zND5oR2akPErhO/1tbguGsp8OwFfTyA1DLTtL9rFd/VNSxfhbxyRcY
         5FjaksxV5g8pdN3L7SoVOV0rHNAhfveoZJEed37d2EMDWJKNxg0GEZXJ495FH7e1PsXl
         pl7duHh7KLdoIadqEhW9yP94SgY+JG0mjiYu+jWEfugLHEWakffN9FIiCWbw0FrKLtM/
         do6P9S7XzxcOuXkv67KQIwwqvpa4X+0y1m6lAd3TJhZTWVdj+AsPSoV5bL3KyCaJHjO8
         TNfsdmuIbrLp5P2rAzQdSZbMrK26MQhdT4LlJ70f9T1ryII3NQ8N3Qw9E13YAyooBp0P
         2jHQ==
X-Gm-Message-State: AAQBX9enUhjRsR+VXHWr/HCaBv3W7hxGcGSTLRhX7RmK5ZpjBJRYq2Ae
        vJiYuUfxyQ5W08GBIfaCnIM=
X-Google-Smtp-Source: AKy350aOqIwcSPJgjx53pipipsDFJOS4KedcyPscHdqyxTFKeldsx8LZt5/HYKaOiDgvaBpMWdtSVQ==
X-Received: by 2002:a05:651c:2126:b0:2a7:81c5:2d19 with SMTP id a38-20020a05651c212600b002a781c52d19mr3565573ljq.2.1681760757227;
        Mon, 17 Apr 2023 12:45:57 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id m26-20020ac2425a000000b004cc9042c9cfsm2118142lfl.158.2023.04.17.12.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 12:45:57 -0700 (PDT)
Date:   Mon, 17 Apr 2023 22:45:46 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sagi Shahar <sagis@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [RFC PATCH 2/5] KVM: SEV: Refactor common code out of
 sev_vm_move_enc_context_from
Message-ID: <20230417224546.00001f73.zhi.wang.linux@gmail.com>
In-Reply-To: <20230407201921.2703758-3-sagis@google.com>
References: <20230407201921.2703758-1-sagis@google.com>
        <20230407201921.2703758-3-sagis@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri,  7 Apr 2023 20:19:18 +0000
Sagi Shahar <sagis@google.com> wrote:

> Both SEV and TDX are going to use similar flows for intra-host
> migration. This change moves some of the code which will be used by both
> architecture into shared code in x86.h
> 
> Signed-off-by: Sagi Shahar <sagis@google.com>
> ---
>  arch/x86/kvm/svm/sev.c | 175 +++++------------------------------------
>  arch/x86/kvm/x86.c     | 166 ++++++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/x86.h     |  16 ++++
>  3 files changed, 201 insertions(+), 156 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c25aeb550cd97..18831a0b7734e 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1553,116 +1553,6 @@ static bool is_cmd_allowed_from_mirror(u32 cmd_id)
>  	return false;
>  }
>  
> -static int sev_lock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
> -{
> -	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
> -	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
> -	int r = -EBUSY;
> -
> -	if (dst_kvm == src_kvm)
> -		return -EINVAL;
> -
> -	/*
> -	 * Bail if these VMs are already involved in a migration to avoid
> -	 * deadlock between two VMs trying to migrate to/from each other.
> -	 */
> -	if (atomic_cmpxchg_acquire(&dst_sev->migration_in_progress, 0, 1))
> -		return -EBUSY;
> -
> -	if (atomic_cmpxchg_acquire(&src_sev->migration_in_progress, 0, 1))
> -		goto release_dst;
> -
> -	r = -EINTR;
> -	if (mutex_lock_killable(&dst_kvm->lock))
> -		goto release_src;
> -	if (mutex_lock_killable_nested(&src_kvm->lock, SINGLE_DEPTH_NESTING))
> -		goto unlock_dst;
> -	return 0;
> -
> -unlock_dst:
> -	mutex_unlock(&dst_kvm->lock);
> -release_src:
> -	atomic_set_release(&src_sev->migration_in_progress, 0);
> -release_dst:
> -	atomic_set_release(&dst_sev->migration_in_progress, 0);
> -	return r;
> -}
> -
> -static void sev_unlock_two_vms(struct kvm *dst_kvm, struct kvm *src_kvm)
> -{
> -	struct kvm_sev_info *dst_sev = &to_kvm_svm(dst_kvm)->sev_info;
> -	struct kvm_sev_info *src_sev = &to_kvm_svm(src_kvm)->sev_info;
> -
> -	mutex_unlock(&dst_kvm->lock);
> -	mutex_unlock(&src_kvm->lock);
> -	atomic_set_release(&dst_sev->migration_in_progress, 0);
> -	atomic_set_release(&src_sev->migration_in_progress, 0);
> -}
> -
> -/* vCPU mutex subclasses.  */
> -enum sev_migration_role {
> -	SEV_MIGRATION_SOURCE = 0,
> -	SEV_MIGRATION_TARGET,
> -	SEV_NR_MIGRATION_ROLES,
> -};
> -
> -static int sev_lock_vcpus_for_migration(struct kvm *kvm,
> -					enum sev_migration_role role)
> -{
> -	struct kvm_vcpu *vcpu;
> -	unsigned long i, j;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (mutex_lock_killable_nested(&vcpu->mutex, role))
> -			goto out_unlock;
> -
> -#ifdef CONFIG_PROVE_LOCKING
> -		if (!i)
> -			/*
> -			 * Reset the role to one that avoids colliding with
> -			 * the role used for the first vcpu mutex.
> -			 */
> -			role = SEV_NR_MIGRATION_ROLES;
> -		else
> -			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> -#endif
> -	}
> -
> -	return 0;
> -
> -out_unlock:
> -
> -	kvm_for_each_vcpu(j, vcpu, kvm) {
> -		if (i == j)
> -			break;
> -
> -#ifdef CONFIG_PROVE_LOCKING
> -		if (j)
> -			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
> -#endif
> -
> -		mutex_unlock(&vcpu->mutex);
> -	}
> -	return -EINTR;
> -}
> -
> -static void sev_unlock_vcpus_for_migration(struct kvm *kvm)
> -{
> -	struct kvm_vcpu *vcpu;
> -	unsigned long i;
> -	bool first = true;
> -
> -	kvm_for_each_vcpu(i, vcpu, kvm) {
> -		if (first)
> -			first = false;
> -		else
> -			mutex_acquire(&vcpu->mutex.dep_map,
> -				      SEV_NR_MIGRATION_ROLES, 0, _THIS_IP_);
> -
> -		mutex_unlock(&vcpu->mutex);
> -	}
> -}
> -
>  static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>  {
>  	struct kvm_sev_info *dst = &to_kvm_svm(dst_kvm)->sev_info;
> @@ -1744,25 +1634,6 @@ static void sev_migrate_from(struct kvm *dst_kvm, struct kvm *src_kvm)
>  	}
>  }
>  
> -static int sev_check_source_vcpus(struct kvm *dst, struct kvm *src)
> -{
> -	struct kvm_vcpu *src_vcpu;
> -	unsigned long i;
> -
> -	if (!sev_es_guest(src))
> -		return 0;
> -
> -	if (atomic_read(&src->online_vcpus) != atomic_read(&dst->online_vcpus))
> -		return -EINVAL;
> -
> -	kvm_for_each_vcpu(i, src_vcpu, src) {
> -		if (!src_vcpu->arch.guest_state_protected)
> -			return -EINVAL;
> -	}
> -
> -	return 0;
> -}
> -
>  int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  {
>  	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1777,19 +1648,20 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  		ret = -EBADF;
>  		goto out_fput;
>  	}
> -
>  	source_kvm = source_kvm_file->private_data;
> -	ret = sev_lock_two_vms(kvm, source_kvm);
> +	src_sev = &to_kvm_svm(source_kvm)->sev_info;
> +
> +	ret = pre_move_enc_context_from(kvm, source_kvm,
> +					&dst_sev->migration_in_progress,
> +					&src_sev->migration_in_progress);
>  	if (ret)
>  		goto out_fput;
>  
> -	if (sev_guest(kvm) || !sev_guest(source_kvm)) {
> +	if (sev_guest(kvm) || !sev_es_guest(source_kvm)) {
>  		ret = -EINVAL;
> -		goto out_unlock;
> +		goto out_post;
>  	}
>  
> -	src_sev = &to_kvm_svm(source_kvm)->sev_info;
> -
>  	dst_sev->misc_cg = get_current_misc_cg();
>  	cg_cleanup_sev = dst_sev;
>  	if (dst_sev->misc_cg != src_sev->misc_cg) {
> @@ -1799,34 +1671,21 @@ int sev_vm_move_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  		charged = true;
>  	}
>  
> -	ret = sev_lock_vcpus_for_migration(kvm, SEV_MIGRATION_SOURCE);
> -	if (ret)
> -		goto out_dst_cgroup;
> -	ret = sev_lock_vcpus_for_migration(source_kvm, SEV_MIGRATION_TARGET);
> -	if (ret)
> -		goto out_dst_vcpu;
> -
> -	ret = sev_check_source_vcpus(kvm, source_kvm);
> -	if (ret)
> -		goto out_source_vcpu;
> -
>  	sev_migrate_from(kvm, source_kvm);
>  	kvm_vm_dead(source_kvm);
>  	cg_cleanup_sev = src_sev;
>  	ret = 0;
>  
> -out_source_vcpu:
> -	sev_unlock_vcpus_for_migration(source_kvm);
> -out_dst_vcpu:
> -	sev_unlock_vcpus_for_migration(kvm);
>  out_dst_cgroup:
>  	/* Operates on the source on success, on the destination on failure.  */
>  	if (charged)
>  		sev_misc_cg_uncharge(cg_cleanup_sev);
>  	put_misc_cg(cg_cleanup_sev->misc_cg);
>  	cg_cleanup_sev->misc_cg = NULL;
> -out_unlock:
> -	sev_unlock_two_vms(kvm, source_kvm);
> +out_post:
> +	post_move_enc_context_from(kvm, source_kvm,
> +				   &dst_sev->migration_in_progress,
> +				   &src_sev->migration_in_progress);
>  out_fput:
>  	if (source_kvm_file)
>  		fput(source_kvm_file);
> @@ -2058,7 +1917,11 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	}
>  
>  	source_kvm = source_kvm_file->private_data;
> -	ret = sev_lock_two_vms(kvm, source_kvm);
> +	source_sev = &to_kvm_svm(source_kvm)->sev_info;
> +	mirror_sev = &to_kvm_svm(kvm)->sev_info;
> +	ret = lock_two_vms_for_migration(kvm, source_kvm,
> +					 &mirror_sev->migration_in_progress,
> +					 &source_sev->migration_in_progress);
>  	if (ret)
>  		goto e_source_fput;
>  
> @@ -2078,9 +1941,7 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	 * The mirror kvm holds an enc_context_owner ref so its asid can't
>  	 * disappear until we're done with it
>  	 */
> -	source_sev = &to_kvm_svm(source_kvm)->sev_info;
>  	kvm_get_kvm(source_kvm);
> -	mirror_sev = &to_kvm_svm(kvm)->sev_info;
>  	list_add_tail(&mirror_sev->mirror_entry, &source_sev->mirror_vms);
>  
>  	/* Set enc_context_owner and copy its encryption context over */
> @@ -2101,7 +1962,9 @@ int sev_vm_copy_enc_context_from(struct kvm *kvm, unsigned int source_fd)
>  	 */
>  
>  e_unlock:
> -	sev_unlock_two_vms(kvm, source_kvm);
> +	unlock_two_vms_for_migration(kvm, source_kvm,
> +				     &mirror_sev->migration_in_progress,
> +				     &source_sev->migration_in_progress);
>  e_source_fput:
>  	if (source_kvm_file)
>  		fput(source_kvm_file);
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 870041887ed91..865c434a94899 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -13596,6 +13596,172 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  }
>  EXPORT_SYMBOL_GPL(kvm_sev_es_string_io);
>  
> +/* vCPU mutex subclasses.  */
> +enum migration_role {
> +	MIGRATION_SOURCE = 0,
> +	MIGRATION_TARGET,
> +	NR_MIGRATION_ROLES,
> +};
> +

> +static int lock_vcpus_for_migration(struct kvm *kvm, enum migration_role role)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i, j;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (mutex_lock_killable_nested(&vcpu->mutex, role))
> +			goto out_unlock;
> +
> +#ifdef CONFIG_PROVE_LOCKING
> +		if (!i)
> +			/*
> +			 * Reset the role to one that avoids colliding with
> +			 * the role used for the first vcpu mutex.
> +			 */
> +			role = NR_MIGRATION_ROLES;
> +		else
> +			mutex_release(&vcpu->mutex.dep_map, _THIS_IP_);
> +#endif
> +	}
> +
> +	return 0;
> +
> +out_unlock:
> +
> +	kvm_for_each_vcpu(j, vcpu, kvm) {
> +		if (i == j)
> +			break;
> +
> +#ifdef CONFIG_PROVE_LOCKING
> +		if (j)
> +			mutex_acquire(&vcpu->mutex.dep_map, role, 0, _THIS_IP_);
> +#endif
> +
> +		mutex_unlock(&vcpu->mutex);
> +	}
> +	return -EINTR;
> +}
> +
> +static void unlock_vcpus_for_migration(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	unsigned long i;
> +	bool first = true;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm) {
> +		if (first)
> +			first = false;
> +		else
> +			mutex_acquire(&vcpu->mutex.dep_map, NR_MIGRATION_ROLES,
> +				      0, _THIS_IP_);
> +
> +		mutex_unlock(&vcpu->mutex);
> +	}
> +}
> +
> +int lock_two_vms_for_migration(struct kvm *dst_kvm, struct kvm *src_kvm,
> +			       atomic_t *dst_migration_in_progress,
> +			       atomic_t *src_migration_in_progress)
> +{
> +	int r = -EBUSY;
> +
> +	if (dst_kvm == src_kvm)
> +		return -EINVAL;
> +
> +	/*
> +	 * Bail if these VMs are already involved in a migration to avoid
> +	 * deadlock between two VMs trying to migrate to/from each other.
> +	 */
> +	if (atomic_cmpxchg_acquire(dst_migration_in_progress, 0, 1))
> +		return -EBUSY;
> +
> +	if (atomic_cmpxchg_acquire(src_migration_in_progress, 0, 1))
> +		goto release_dst;
> +
> +	r = -EINTR;
> +	if (mutex_lock_killable(&dst_kvm->lock))
> +		goto release_src;
> +	if (mutex_lock_killable_nested(&src_kvm->lock, SINGLE_DEPTH_NESTING))
> +		goto unlock_dst;
> +	return 0;
> +
> +unlock_dst:
> +	mutex_unlock(&dst_kvm->lock);
> +release_src:
> +	atomic_set_release(src_migration_in_progress, 0);
> +release_dst:
> +	atomic_set_release(dst_migration_in_progress, 0);
> +	return r;
> +}
> +EXPORT_SYMBOL_GPL(lock_two_vms_for_migration);
> +
> +void unlock_two_vms_for_migration(struct kvm *dst_kvm, struct kvm *src_kvm,
> +				  atomic_t *dst_migration_in_progress,
> +				  atomic_t *src_migration_in_progress)
> +{
> +	mutex_unlock(&dst_kvm->lock);
> +	mutex_unlock(&src_kvm->lock);
> +	atomic_set_release(dst_migration_in_progress, 0);
> +	atomic_set_release(src_migration_in_progress, 0);
> +}
> +EXPORT_SYMBOL_GPL(unlock_two_vms_for_migration);
> +
> +int pre_move_enc_context_from(struct kvm *dst_kvm, struct kvm *src_kvm,
> +			      atomic_t *dst_migration_in_progress,
> +			      atomic_t *src_migration_in_progress)
> +{
> +	struct kvm_vcpu *src_vcpu;
> +	unsigned long i;
> +	int ret = -EINVAL;
> +
> +	ret = lock_two_vms_for_migration(dst_kvm, src_kvm,
> +					 dst_migration_in_progress,
> +					 src_migration_in_progress);
> +	if (ret)
> +		return ret;
> +
> +	ret = lock_vcpus_for_migration(dst_kvm, MIGRATION_TARGET);
> +	if (ret)
> +		goto unlock_vms;
> +
> +	ret = lock_vcpus_for_migration(src_kvm, MIGRATION_SOURCE);
> +	if (ret)
> +		goto unlock_dst_vcpu;
> +
> +	if (atomic_read(&dst_kvm->online_vcpus) !=
> +	    atomic_read(&src_kvm->online_vcpus))
> +		goto unlock_dst_vcpu;
> +
> +	kvm_for_each_vcpu(i, src_vcpu, src_kvm) {
> +		if (!src_vcpu->arch.guest_state_protected)
> +			goto unlock_dst_vcpu;
> +	}
> +
> +	return 0;
> +
> +unlock_dst_vcpu:
> +	unlock_vcpus_for_migration(dst_kvm);
> +unlock_vms:
> +	unlock_two_vms_for_migration(dst_kvm, src_kvm,
> +				     dst_migration_in_progress,
> +				     src_migration_in_progress);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(pre_move_enc_context_from);
> +
> +void post_move_enc_context_from(struct kvm *dst_kvm, struct kvm *src_kvm,
> +				atomic_t *dst_migration_in_progress,
> +				atomic_t *src_migration_in_progress)
> +{
> +	unlock_vcpus_for_migration(src_kvm);
> +	unlock_vcpus_for_migration(dst_kvm);
> +	unlock_two_vms_for_migration(dst_kvm, src_kvm,
> +				     dst_migration_in_progress,
> +				     src_migration_in_progress);
> +}
> +EXPORT_SYMBOL_GPL(post_move_enc_context_from);
> +

It would be nice to have kvm_ prefix for the functions exported.

>  bool kvm_arch_dirty_log_supported(struct kvm *kvm)
>  {
>  	return kvm->arch.vm_type != KVM_X86_PROTECTED_VM;
> diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
> index 33a1a5341e788..554c797184994 100644
> --- a/arch/x86/kvm/x86.h
> +++ b/arch/x86/kvm/x86.h
> @@ -502,4 +502,20 @@ int kvm_sev_es_string_io(struct kvm_vcpu *vcpu, unsigned int size,
>  			 unsigned int port, void *data,  unsigned int count,
>  			 int in);
>  
> +int lock_two_vms_for_migration(struct kvm *dst_kvm, struct kvm *src_kvm,
> +			       atomic_t *dst_migration_in_progress,
> +			       atomic_t *src_migration_in_progress);
> +
> +void unlock_two_vms_for_migration(struct kvm *dst_kvm, struct kvm *src_kvm,
> +				  atomic_t *dst_migration_in_progress,
> +				  atomic_t *src_migration_in_progress);
> +
> +int pre_move_enc_context_from(struct kvm *dst_kvm, struct kvm *src_kvm,
> +			      atomic_t *dst_migration_in_progress,
> +			      atomic_t *src_migration_in_progress);
> +
> +void post_move_enc_context_from(struct kvm *dst_kvm, struct kvm *src_kvm,
> +				atomic_t *dst_migration_in_progress,
> +				atomic_t *src_migration_in_progress);
> +
>  #endif
