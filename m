Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41647406057
	for <lists+kvm@lfdr.de>; Fri, 10 Sep 2021 02:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbhIJAMn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 20:12:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhIJAMn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 20:12:43 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E459CC061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 17:11:32 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id bb10so20215plb.2
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 17:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=llclJQfTdy0DutAA/POV20L5BXhuUdNNHscF47502uw=;
        b=arrikypm7FMQHJNO+MMHj7r/UZn2uEEwEsUEvSZBmsv484Vob7fvITbMxiMvJWWkEK
         QjyrbglXAE9f9ucU3kXuvYvLriWFjEQYgoWK374TqvQ+IVXBZuy3+7haSX5NVD9Jhyid
         EBM2Mq1X9rHBpsg9J1oeAulYrNGyOyrFKjz9XcNFEajMZO30+uwHDG+dg2/7ua4Y+HW+
         LwLNis3WpX7ztOaDcla69d683GUTGpWccMN86VLuL2NOK5jTU4HdWeWYr2c4auRsvE5k
         FcSPs2cawfiSLpAJf/PKIejRFYtSMaWI2boe+vdZGCgLQ/3AUpORLQPfTGEpfFhy5k/u
         KPqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=llclJQfTdy0DutAA/POV20L5BXhuUdNNHscF47502uw=;
        b=j3Rg0ui0qVvEQo4Gk/hdGqZvK926dsbwqBZhz/pFzSzgkaq6waRraR+syzDXVow0MO
         aJDeynUdbETywDqlJ+mlR3PWw8vYEppJV9RwkvhjC3x3WE9KHL0T9CCrxCw//37pT+/F
         jOcoVLdZVjVIinJ++Mz24aYIbOyahApBJDOU5rN9iKQIkxY4c5B3dut5woQ1yf7fyRb1
         C0bpFGVI7MXDWFoEFla0EB+tq//2+yi2+0EoHo/tuCDGLjuUqx80HLXuhWzONvDM7Yga
         x7Tuph1J2gp+RcYcc5sOafqDwtl2MTMUKESVGszgd2rHrzU5hEMaje6ufXLcNRGB9cQR
         lKbg==
X-Gm-Message-State: AOAM533aeXbO3yEhIWKg2//3hMUwBwEbWKsE/cyubop1+AfcPrp7yv6F
        1jB4ZN++izmmoxIuw6z3OQ6UHQ==
X-Google-Smtp-Source: ABdhPJwW8gKxoPCfhLI++WbmUF0njySHSLgkUmtSr58LvyDcJhAtRKypIWUSW2/AAWBpVZXv3gtekQ==
X-Received: by 2002:a17:90a:4d4e:: with SMTP id l14mr6185192pjh.4.1631232692195;
        Thu, 09 Sep 2021 17:11:32 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b5sm3353491pfr.26.2021.09.09.17.11.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Sep 2021 17:11:31 -0700 (PDT)
Date:   Fri, 10 Sep 2021 00:11:27 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Marc Orr <marcorr@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 V7] KVM, SEV: Add support for SEV intra host migration
Message-ID: <YTqirwnu0rOcfDCq@google.com>
References: <20210902181751.252227-1-pgonda@google.com>
 <20210902181751.252227-2-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210902181751.252227-2-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Nit, preferred shortlog scope is "KVM: SEV:"

On Thu, Sep 02, 2021, Peter Gonda wrote:
> For SEV to work with intra host migration, contents of the SEV info struct
> such as the ASID (used to index the encryption key in the AMD SP) and
> the list of memory regions need to be transferred to the target VM.
> This change adds a commands for a target VMM to get a source SEV VM's sev
> info.
> 
> The target is expected to be initialized (sev_guest_init), but not
> launched state (sev_launch_start) when performing receive. Once the
> target has received, it will be in a launched state and will not
> need to perform the typical SEV launch commands.
> 
> Signed-off-by: Peter Gonda <pgonda@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Reviewed-by: Marc Orr <marcorr@google.com>
> Cc: Marc Orr <marcorr@google.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Sean Christopherson <seanjc@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Dr. David Alan Gilbert <dgilbert@redhat.com>
> Cc: Brijesh Singh <brijesh.singh@amd.com>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  Documentation/virt/kvm/api.rst  |  15 +++++
>  arch/x86/include/asm/kvm_host.h |   1 +
>  arch/x86/kvm/svm/sev.c          | 101 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.c          |   1 +
>  arch/x86/kvm/svm/svm.h          |   2 +
>  arch/x86/kvm/x86.c              |   5 ++
>  include/uapi/linux/kvm.h        |   1 +
>  7 files changed, 126 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index 4ea1bb28297b..e8cecc024649 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -6702,6 +6702,21 @@ MAP_SHARED mmap will result in an -EINVAL return.
>  When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
>  perform a bulk copy of tags to/from the guest.
>  
> +7.29 KVM_CAP_VM_MIGRATE_ENC_CONTEXT_FROM
> +-------------------------------------

Do we really want to bury this under KVM_CAP?  Even KVM_CAP_VM_COPY_ENC_CONTEXT_FROM
is a bit of a stretch, but at least that's a one-way "enabling", whereas this
migration routine should be able to handle multiple migrations, e.g. migrate A->B
and B->A.  Peeking at your selftest, it should be fairly easy to add in this edge
case.

This is probably a Paolo question, I've no idea if there's a desire to expand
KVM_CAP versus adding a new ioctl().

> +Architectures: x86 SEV enabled
> +Type: vm
> +Parameters: args[0] is the fd of the source vm
> +Returns: 0 on success

It'd be helpful to provide a brief description of the error cases.  Looks like
-EINVAL is the only possible error?

> +This capability enables userspace to migrate the encryption context

I would prefer to scope this beyond "encryption context".  Even for SEV, it
copies more than just the "context", which was an abstraction of SEV's ASID,
e.g. this also hands off the set of encrypted memory regions.  Looking toward
the future, if TDX wants to support this it's going to need to hand over a ton
of stuff, e.g. S-EPT tables.

Not sure on a name, maybe MIGRATE_PROTECTED_VM_FROM?

> from the vm

Capitalize VM in the description, if only to be consistent within these two
paragraphs.  If it helps, oretend all the terrible examples in this file don't
exist ;-)

> +indicated by the fd to the vm this is called on.
> +
> +This is intended to support intra-host migration of VMs between userspace VMMs.
> +in-guest workloads scheduled by the host. This allows for upgrading the VMMg

This snippet (and the lowercase "vm") looks like it was left behind after a
copy-paste from KVM_CAP_VM_COPY_ENC_CONTEXT_FROM.

> +process without interrupting the guest.
> +
>  8. Other capabilities.
>  ======================
>  
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 09b256db394a..f06d87a85654 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1456,6 +1456,7 @@ struct kvm_x86_ops {
>  	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
>  	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
> +	int (*vm_migrate_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
>  
>  	int (*get_msr_feature)(struct kvm_msr_entry *entry);
>  
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 46eb1ba62d3d..8db666a362d4 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -1501,6 +1501,107 @@ static int sev_receive_finish(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return sev_issue_cmd(kvm, SEV_CMD_RECEIVE_FINISH, &data, &argp->error);
>  }
>  
> +static int svm_sev_lock_for_migration(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	/*
> +	 * Bail if this VM is already involved in a migration to avoid deadlock
> +	 * between two VMs trying to migrate to/from each other.
> +	 */
> +	if (atomic_cmpxchg_acquire(&sev->migration_in_progress, 0, 1))
> +		return -EBUSY;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	return 0;
> +}
> +
> +static void svm_unlock_after_migration(struct kvm *kvm)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +
> +	mutex_unlock(&kvm->lock);
> +	atomic_set_release(&sev->migration_in_progress, 0);
> +}
> +
> +static void migrate_info_from(struct kvm_sev_info *dst,
> +			      struct kvm_sev_info *src)
> +{
> +	sev_asid_free(dst);

Ooh, this brings up a potential shortcoming of requiring @dst to be SEV-enabled.
If every SEV{-ES} ASID is allocated, then there won't be an available ASID to
(temporarily) allocate for the intra-host migration.  But that temporary ASID
isn't actually necessary, i.e. there's no reason intra-host migration should fail
if all ASIDs are in-use.

I don't see any harm in requiring the @dst to _not_ be SEV-enabled.  sev_info
is not dynamically allocated, i.e. migration_in_progress is accessible either
way.  That would also simplify some of the checks, e.g. the regions_list check
goes away because svm_register_enc_region() fails on non-SEV guests.

I believe this will also fix multiple bugs in the next patch (SEV-ES support).

Bug #1, SEV-ES support changes the checks to:

	if (!sev_guest(kvm)) {
		ret = -EINVAL;
		pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");
		goto out_unlock;
	}

	...

	if (!sev_guest(source_kvm)) {
		ret = -EINVAL;
		pr_warn_ratelimited(
			"Source VM must be SEV enabled to migrate from.\n");
		goto out_source;
	}

	if (sev_es_guest(kvm)) {
		ret = migrate_vmsa_from(kvm, source_kvm);
		if (ret)
			goto out_source;
	}

and fails to handle the scenario where dst.SEV_ES != src.SEV_ES.  If @dst is
SEV_ES-enabled and @src has created vCPUs, migrate_vmsa_from() will still fail
due to guest_state_protected being false, but the reverse won't hold true and
KVM will "successfully" migrate an SEV-ES guest to an SEV guest.  I'm guessing
fireworks will ensue, e.g. due to running with the wrong ASID.

Bug #2, migrate_vmsa_from() leaks dst->vmsa, as this

		dst_svm->vmsa = src_svm->vmsa;
		src_svm->vmsa = NULL;

overwrites dst_svm->vmsa that was allocated by svm_create_vcpu().

AFAICT, there isn't anything that will break by forcing @dst to be !SEV (except
stuff that's already broken, see below).  For SEV{-ES} specific stuff, anything
that is allocated/set vCPU creation likely needs to be migrated, e.g. VMSA and
the GHCB MSR value.  The only missing action is kvm_free_guest_fpu().

Side topic, the VMSA really should be allocated in sev_es_create_vcpu(), and
guest_fpu should never be allocated for SEV-ES guests (though that doesn't change
the need for kvm_free_guest_fpu() in this case).  I'll send patches for that.

> +	dst->asid = src->asid;
> +	dst->misc_cg = src->misc_cg;
> +	dst->handle = src->handle;
> +	dst->pages_locked = src->pages_locked;
> +
> +	src->asid = 0;
> +	src->active = false;
> +	src->handle = 0;
> +	src->pages_locked = 0;
> +	src->misc_cg = NULL;
> +
> +	INIT_LIST_HEAD(&dst->regions_list);
> +	list_replace_init(&src->regions_list, &dst->regions_list);
> +}
> +
> +int svm_vm_migrate_from(struct kvm *kvm, unsigned int source_fd)
> +{
> +	struct kvm_sev_info *dst_sev = &to_kvm_svm(kvm)->sev_info;
> +	struct file *source_kvm_file;
> +	struct kvm *source_kvm;
> +	int ret;
> +
> +	ret = svm_sev_lock_for_migration(kvm);
> +	if (ret)
> +		return ret;
> +
> +	if (!sev_guest(kvm) || sev_es_guest(kvm)) {
> +		ret = -EINVAL;
> +		pr_warn_ratelimited("VM must be SEV enabled to migrate to.\n");

Linux generally doesn't log user errors to dmesg.  They can be helpful during
development, but aren't actionable and thus are of limited use in production.

> +		goto out_unlock;
> +	}

Hmm, I was going to say that migration should be rejected if @dst has created
vCPUs, but the SEV-ES support migrates VMSA state and so must run after vCPUs
are created.  Holding kvm->lock does not prevent invoking per-vCPU ioctls(),
including KVM_RUN.  Modifying vCPU SEV{-ES} state while a vCPU is actively running
is bound to cause explosions.

One option for this patch would be to check kvm->created_vcpus and then add
different logic for SEV-ES, but that's probably not desirable for userspace as
it will mean triggering intra-host migration at different points for SEV vs. SEV-ES.

So I think the only option is to take vcpu->mutex for all vCPUs in both @src and
@dst.  Adding that after acquiring kvm->lock in svm_sev_lock_for_migration()
should Just Work.  Unless userspace is misbehaving, the lock won't be contended
since all vCPUs need to be quiesced, though it's probably worth using the
mutex_lock_killable() variant just to be safe.

> +	if (!list_empty(&dst_sev->regions_list)) {
> +		ret = -EINVAL;
> +		pr_warn_ratelimited(
> +			"VM must not have encrypted regions to migrate to.\n");
> +		goto out_unlock;
> +	}
> +
> +	source_kvm_file = fget(source_fd);
> +	if (!file_is_kvm(source_kvm_file)) {
> +		ret = -EBADF;
> +		pr_warn_ratelimited(
> +				"Source VM must be SEV enabled to migrate from.\n");

Case in point for not logging errors, this is arguably inaccurate as the source
"VM" isn't a VM.

> +		goto out_fput;
> +	}
> +
> +	source_kvm = source_kvm_file->private_data;
> +	ret = svm_sev_lock_for_migration(source_kvm);
> +	if (ret)
> +		goto out_fput;
> +
> +	if (!sev_guest(source_kvm) || sev_es_guest(source_kvm)) {
> +		ret = -EINVAL;
> +		pr_warn_ratelimited(
> +			"Source VM must be SEV enabled to migrate from.\n");
> +		goto out_source;
> +	}
> +
> +	migrate_info_from(dst_sev, &to_kvm_svm(source_kvm)->sev_info);
> +	ret = 0;
> +
> +out_source:
> +	svm_unlock_after_migration(source_kvm);
> +out_fput:
> +	if (source_kvm_file)
> +		fput(source_kvm_file);
> +out_unlock:
> +	svm_unlock_after_migration(kvm);
> +	return ret;
> +}
