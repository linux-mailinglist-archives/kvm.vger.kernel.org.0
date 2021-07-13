Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006273C7973
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 00:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236158AbhGMWPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 18:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbhGMWPr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 18:15:47 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD3AC0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:12:57 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d12so74166pfj.2
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j68Vg8JAk/DXfpZmo3qhmVL+R64WqjblQlTWOBouqH8=;
        b=Zq9rf7UE1v3HVgiI5AwVMY+vEWQd1f73YRsIZENDV1gx525H7BqmqTc5lB4s4U9UFM
         zMB0H/nFgNI0h1gayu3s0mgM63FBr+1PEKCdOda5WoAC3dZ+xoc0u1xM1WRWwOFYdSah
         X2wDVVoYvtrCVSC8xBvbUG9Ri9n5T5YtuRvBwrwxqfxwS0RSuJcy0hAjW7ojXobc9YlU
         XAEgY7jCe8qPrlsJzTM9fBBiOMNpZ/WhiSS87movxaE6D2I86es8EPibRSRHosHOGCdv
         PsABqxnJdcVH08qewgtjA7E1VcfCoKp5Enoe5PKpdH6700zpdzJh4hOl9BbLghliOgzl
         8rxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j68Vg8JAk/DXfpZmo3qhmVL+R64WqjblQlTWOBouqH8=;
        b=DmQbKWwHvVfHn1HrRMEdl0eOXCoVCcd0mRwxBnlVNqHmUXPfzFUheUfIEmOVxAyC8a
         hWF8YUhR/acWsmuC95ISDRl581faiU3ecJQp9hBsf+iVSP+Va42Dmkq4FYDEj5AiwO7A
         qLaCtYct5hOLp8JUJwp+W7uI6M0r3gNitq2TGSLlH8/xuB148MBEi+ZNZyCBO1C/jvUE
         V3HVzVVwDBbprkBdY1Ma4nSASJ84RbRazTDNaL8gdB4rjP8mJ6RHCBaupbnYCGYvEQ8R
         OZBl8egEaRH2RvQGkj3MLpi/rUc/70TY96xox4NHRaMsV75HYZUjy3bOtTfajwbug3tp
         pckw==
X-Gm-Message-State: AOAM5334M4vf05Uog2X4UlDXT2fI3d5MCrDdjV8ixxoECRjB5kRQ1obA
        c4W+z6ses0aC/gvmFPdP5DUL/Q==
X-Google-Smtp-Source: ABdhPJw9MMXw+96emsvst3hTape+HpKWcIpBioqhQgzjyI/y325QXFOJqjKI91PZ6xw1yfyYwEUZNg==
X-Received: by 2002:a65:6412:: with SMTP id a18mr6086932pgv.445.1626214376546;
        Tue, 13 Jul 2021 15:12:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id c136sm150428pfc.201.2021.07.13.15.12.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 15:12:55 -0700 (PDT)
Date:   Tue, 13 Jul 2021 22:12:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Lars Bull <larsbull@google.com>,
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
Subject: Re: [PATCH 2/3] KVM, SEV: Add support for SEV local migration
Message-ID: <YO4P5Ao3FiL+rllg@google.com>
References: <20210621163118.1040170-1-pgonda@google.com>
 <20210621163118.1040170-3-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621163118.1040170-3-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021, Peter Gonda wrote:
> Local migration provides a low-cost mechanism for userspace VMM upgrades.
> It is an alternative to traditional (i.e., remote) live migration. Whereas
> remote migration handles move a guest to a new host, local migration only
> handles moving a guest to a new userspace VMM within a host.

Maybe use intra-host vs. inter-host instead of local vs. remote?  That'll save
having to define local and remote.  KVM_SEV_INTRA_HOST_{SEND,RECEIVE} is a bit
wordy, but also very specific.

> For SEV to work with local migration, contents of the SEV info struct
> such as the ASID (used to index the encryption key in the AMD SP) and
> the list
> of memory regions need to be transferred to the target VM. Adds
> commands for sending and receiving the sev info.
> 
> To avoid exposing this internal state to userspace and prevent other
> processes from importing state they shouldn't have access to, the send
> returns a token to userspace that is handed off to the target VM. The
> target passes in this token to receive the sent state. The token is only
> valid for one-time use. Functionality on the source becomes limited
> after
> send has been performed. If the source is destroyed before the target
> has
> received, the token becomes invalid.

Something appears to be mangling the changelogs, or maybe you have a cat that
likes stepping on the Enter key? :-D

> The target is expected to be initialized (sev_guest_init), but not
> launched
> state (sev_launch_start) when performing receive. Once the target has
> received, it will be in a launched state and will not need to perform
> the
> typical SEV launch commands.

...

> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 5af46ff6ec48..7c33ad2b910d 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -14,6 +14,7 @@
>  #include <linux/psp-sev.h>
>  #include <linux/pagemap.h>
>  #include <linux/swap.h>
> +#include <linux/random.h>
>  #include <linux/misc_cgroup.h>
>  #include <linux/processor.h>
>  #include <linux/trace_events.h>
> @@ -57,6 +58,8 @@ module_param_named(sev_es, sev_es_enabled, bool, 0444);
>  #define sev_es_enabled false
>  #endif /* CONFIG_KVM_AMD_SEV */
>  
> +#define MAX_RAND_RETRY    3
> +
>  static u8 sev_enc_bit;
>  static DECLARE_RWSEM(sev_deactivate_lock);
>  static DEFINE_MUTEX(sev_bitmap_lock);
> @@ -74,6 +77,22 @@ struct enc_region {
>  	unsigned long size;
>  };
>  
> +struct sev_info_migration_node {
> +	struct hlist_node hnode;
> +	u64 token;
> +	bool valid;
> +
> +	unsigned int asid;
> +	unsigned int handle;
> +	unsigned long pages_locked;
> +	struct list_head regions_list;
> +	struct misc_cg *misc_cg;
> +};
> +
> +#define SEV_INFO_MIGRATION_HASH_BITS    7
> +static DEFINE_HASHTABLE(sev_info_migration_hash, SEV_INFO_MIGRATION_HASH_BITS);
> +static DEFINE_SPINLOCK(sev_info_migration_hash_lock);
> +
>  /* Called with the sev_bitmap_lock held, or on shutdown  */
>  static int sev_flush_asids(int min_asid, int max_asid)
>  {
> @@ -1094,6 +1113,185 @@ static int sev_get_attestation_report(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return ret;
>  }
>  
> +static struct sev_info_migration_node *find_migration_info(unsigned long token)
> +{
> +	struct sev_info_migration_node *entry;
> +
> +	hash_for_each_possible(sev_info_migration_hash, entry, hnode, token) {
> +		if (entry->token == token)
> +			return entry;
> +	}
> +
> +	return NULL;
> +}
> +
> +/*
> + * Places @entry into the |sev_info_migration_hash|. Returns 0 if successful
> + * and ownership of @entry is transferred to the hashmap.
> + */
> +static int place_migration_node(struct sev_info_migration_node *entry)
> +{
> +	u64 token = 0;
> +	unsigned int retries;
> +	int ret = -EFAULT;
> +
> +	/*
> +	 * Generate a token associated with this VM's SEV info that userspace
> +	 * can use to import on the other side. We use 0 to indicate a not-
> +	 * present token. The token cannot collide with other existing ones, so
> +	 * reroll a few times until we get a valid token. In the unlikely event
> +	 * we're having trouble generating a unique token, give up and let
> +	 * userspace retry if it needs to.
> +	 */
> +	spin_lock(&sev_info_migration_hash_lock);
> +	for (retries = 0; retries < MAX_RAND_RETRY; retries++)  {
> +		get_random_bytes((void *)&token, sizeof(token));

Why is the kernel responsible for generating the token?  IIUC, the purpose of
the random generation is to make the token difficult to guess by a process other
than the intended recipient, e.g. by a malicious process.  But that's a userspace
problem that can be better solved by the sender.

> +
> +		if (find_migration_info(token))
> +			continue;
> +
> +		entry->token = token;
> +		entry->valid = true;
> +
> +		hash_add(sev_info_migration_hash, &entry->hnode, token);
> +		ret = 0;
> +		goto out;
> +	}
> +
> +out:
> +	spin_unlock(&sev_info_migration_hash_lock);
> +	return ret;
> +}
> +
> +static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_info_migration_node *entry;
> +	struct kvm_sev_local_send params;
> +	u64 token;
> +	int ret = -EFAULT;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (sev->es_active)
> +		return -EPERM;
> +
> +	if (sev->info_token != 0)
> +		return -EEXIST;
> +
> +	if (copy_from_user(&params, (void __user *)(uintptr_t)argp->data,
> +			   sizeof(params)))
> +		return -EFAULT;
> +
> +	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
> +	if (!entry)
> +		return -ENOMEM;
> +
> +	entry->asid = sev->asid;
> +	entry->handle = sev->handle;
> +	entry->pages_locked = sev->pages_locked;
> +	entry->misc_cg = sev->misc_cg;
> +
> +	INIT_LIST_HEAD(&entry->regions_list);
> +	list_replace_init(&sev->regions_list, &entry->regions_list);
> +
> +	if (place_migration_node(entry))
> +		goto e_listdel;
> +
> +	token = entry->token;
> +
> +	params.info_token = token;
> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> +			 sizeof(params)))
> +		goto e_hashdel;
> +
> +	sev->info_token = token;
> +
> +	return 0;
> +
> +e_hashdel:

err_<name> is the more standard label for this sort of thing.

> +	spin_lock(&sev_info_migration_hash_lock);
> +	hash_del(&entry->hnode);
> +	spin_unlock(&sev_info_migration_hash_lock);
> +
> +e_listdel:

listdel is a bit of an odd name, though I can't think of a better one.

> +	list_replace_init(&entry->regions_list, &sev->regions_list);
> +
> +	kfree(entry);
> +
> +	return ret;
> +}
> +
> +static int sev_local_receive(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_info_migration_node *entry;
> +	struct kvm_sev_local_receive params;
> +	struct kvm_sev_info old_info;
> +
> +	if (!sev_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (sev->es_active)
> +		return -EPERM;
> +
> +	if (sev->handle != 0)
> +		return -EPERM;
> +
> +	if (!list_empty(&sev->regions_list))
> +		return -EPERM;
> +
> +	if (copy_from_user(&params,
> +			   (void __user *)(uintptr_t)argp->data,

If you capture argp in a local var, this ugly cast can be done once and you'll
save lines overall, e.g.

	void __user *udata = (void __user *)(uintptr_t)argp->data;

	if (copy_from_user(&params, udata, sizeof(params))
		return -EFAULT;

	...

	if (copy_to_user(udata, &params, sizeof(params)))
		return -EFAULT;


> +			   sizeof(params)))
> +		return -EFAULT;
> +
> +	spin_lock(&sev_info_migration_hash_lock);
> +	entry = find_migration_info(params.info_token);
> +	if (!entry || !entry->valid)
> +		goto err_unlock;
> +
> +	memcpy(&old_info, sev, sizeof(old_info));
> +
> +	/*
> +	 * The source VM always frees @entry On the target we simply
> +	 * mark the token as invalid to notify the source the sev info
> +	 * has been moved successfully.
> +	 */
> +	entry->valid = false;
> +	sev->active = true;
> +	sev->asid = entry->asid;
> +	sev->handle = entry->handle;
> +	sev->pages_locked = entry->pages_locked;
> +	sev->misc_cg = entry->misc_cg;
> +
> +	INIT_LIST_HEAD(&sev->regions_list);
> +	list_replace_init(&entry->regions_list, &sev->regions_list);
> +
> +	spin_unlock(&sev_info_migration_hash_lock);
> +
> +	params.handle = sev->handle;
> +
> +	if (copy_to_user((void __user *)(uintptr_t)argp->data, &params,
> +			 sizeof(params)))
> +		goto err_unwind;
> +
> +	sev_asid_free(&old_info);
> +	return 0;
> +
> +err_unwind:
> +	spin_lock(&sev_info_migration_hash_lock);

Why does the lock need to be reacquired, and can anything go sideways if something
else grabbed the lock while it was dropped?

> +	list_replace_init(&sev->regions_list, &entry->regions_list);
> +	entry->valid = true;
> +	memcpy(sev, &old_info, sizeof(*sev));
> +
> +err_unlock:
> +	spin_unlock(&sev_info_migration_hash_lock);
> +
> +	return -EFAULT;
> +}
> +

...

> @@ -1553,6 +1763,12 @@ int svm_mem_enc_op(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_GET_ATTESTATION_REPORT:
>  		r = sev_get_attestation_report(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_LOCAL_SEND:



> +		r = sev_local_send(kvm, &sev_cmd);
> +		break;
> +	case KVM_SEV_LOCAL_RECEIVE:
> +		r = sev_local_receive(kvm, &sev_cmd);
> +		break;
>  	case KVM_SEV_SEND_START:
>  		r = sev_send_start(kvm, &sev_cmd);
>  		break;
> @@ -1786,6 +2002,8 @@ static void __unregister_region_list_locked(struct kvm *kvm,
>  void sev_vm_destroy(struct kvm *kvm)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> +	struct sev_info_migration_node *entry = NULL;
> +	bool info_migrated = false;
>  
>  	if (!sev_guest(kvm))
>  		return;
> @@ -1796,25 +2014,59 @@ void sev_vm_destroy(struct kvm *kvm)
>  		return;
>  	}
>  
> +	/*
> +	 * If userspace has requested that we migrate the SEV info to a new VM,
> +	 * then we own and must remove an entry node in the tracking data
> +	 * structure. Whether we clean up the data in our SEV info struct and
> +	 * entry node depends on whether userspace has done the migration,
> +	 * which transfers ownership to a new VM. We can identify that
> +	 * migration has occurred by checking if the node is marked invalid.
> +	 */
> +	if (sev->info_token != 0) {
> +		spin_lock(&sev_info_migration_hash_lock);
> +		entry = find_migration_info(sev->info_token);
> +		if (entry) {
> +			info_migrated = !entry->valid;
> +			hash_del(&entry->hnode);

Isn't info_migrated unnecessary?  Grabbing ->valid under the lock is a bit
misleading because it's unnecessary, e.g. once the entry is deleted from the
list then this flow owns it.

If you do s/entry/migration_entry (or mig_entry), then I think the code will be
sufficiently self-documenting.

> +		} else

Needs curly braces.

> +			WARN(1,
> +			     "SEV VM was marked for export, but does not have associated export node.\n");

But an even better way to write this (IMO the msg isn't necessary, the issue is
quite obvious at a quick glance):

		if (!WARN_ON(!entry))
			hash_del(&entry->node);

> +		spin_unlock(&sev_info_migration_hash_lock);
> +	}
> +
>  	mutex_lock(&kvm->lock);
>  
>  	/*
> -	 * Ensure that all guest tagged cache entries are flushed before
> -	 * releasing the pages back to the system for use. CLFLUSH will
> -	 * not do this, so issue a WBINVD.
> +	 * Adding memory regions after a local send has started
> +	 * is dangerous.
>  	 */
> -	wbinvd_on_all_cpus();
> +	if (sev->info_token != 0 && !list_empty(&sev->regions_list)) {

Kernel style usually omits the "!= 0".

> +		WARN(1,

Similarly, WARN(1, ...) in an if statement is usually a sign that you're doing
things backwards:

	if (WARN_ON(sev->info_token && !list_empty(&sev->regions_list)))
		unregister_enc_regions(kvm, &sev->regions_list);

In addition to saving code, the WARN will display the failing condition, which
obviates the need for a free form message in most cases (including this one).

Oh, and I think you've got a bug here.  If info_token is '0', won't regions_list
be leaked?  I.e. shouldn't this be (the helper gracefully handles the empty case):

	WARN_ON(sev->info_token && !list_empty(&sev->regions_list));
	unregister_enc_regions(kvm, &sev->regions_list);

That will generate a smaller diff, since the exiting call for regions_list will
be unchanged.

> +		     "Source SEV regions list non-empty after export request. List is not expected to be modified after export request.\n");
> +		__unregister_region_list_locked(kvm, &sev->regions_list);
> +	}
>  
>  	/*
> -	 * if userspace was terminated before unregistering the memory regions
> -	 * then lets unpin all the registered memory.
> +	 * If userspace was terminated before unregistering the memory

Unnecessary new newline.  That said, this comment also appears to be stale?

> +	 * regions then lets unpin all the registered memory.
>  	 */
> -	__unregister_region_list_locked(kvm, &sev->regions_list);
> +	if (entry)
> +		__unregister_region_list_locked(kvm, &entry->regions_list);
>  
>  	mutex_unlock(&kvm->lock);
>  
> -	sev_unbind_asid(kvm, sev->handle);
> -	sev_asid_free(sev);
> +	/*
> +	 * Ensure that all guest tagged cache entries are flushed before
> +	 * releasing the pages back to the system for use. CLFLUSH will
> +	 * not do this, so issue a WBINVD.
> +	 */
> +	wbinvd_on_all_cpus();
> +	if (!info_migrated) {

As above, this can be:

	if (!migration_entry || !migration_entry->valid) {

> +		sev_unbind_asid(kvm, sev->handle);
> +		sev_asid_free(sev);
> +	}
> +
> +	kfree(entry);
>  }
