Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9ED3C7992
	for <lists+kvm@lfdr.de>; Wed, 14 Jul 2021 00:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhGMWYt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 18:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235973AbhGMWYt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jul 2021 18:24:49 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F289C0613E9
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:21:58 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso142581pjp.2
        for <kvm@vger.kernel.org>; Tue, 13 Jul 2021 15:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NRZUGlSQxELBktwEt/k7qMLhHgHPpSVIp1xfpZkDFtI=;
        b=c/KMCALyx3thmuzG/vP7s34yWbO2c+usFQ1Uid80TZgPjn0hY/bhzDGnD0nFKFLWEH
         IMnzMSCdf1QjRSy0VRmDeZ924Y5UnIidPDWLXgU9fyqT6p9s65PIgjCgfwSsiTncSdb7
         jInT7ol/ohUAR1YMIqlWboqFtRFCCYjZeYmLRUrKRhGnxg3VaU177ACb9dsC0UNl45+e
         lPlYqR17/9PZhd+dTW5+q1nNTn0P0gDDHGiz5sZmpy4s/wDAbpROygUyTrvueYf+RdmT
         +dXpUzOq921wIWIPNAlTxEa+6yz5JVitm7n/aTyfaB5ryqjuNWJXN1bq6H6dVzFyRxQ1
         JEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NRZUGlSQxELBktwEt/k7qMLhHgHPpSVIp1xfpZkDFtI=;
        b=QJ26u+LMcsFTY0meOQ6LegSgqocwc349SZ4ukptpKjpqkjAtydPW0JSplV2YMxc0+O
         X7Gj3/vy/rZtzTDbTUCIDFMGd4IP8o1m9HW6SlDZmQ1kX3ZDYbjXuDaarCiBuTB5TXPI
         y7P2JLn0q4q4550Wtuo0cWHR90+kDf4RgP0ha+urqHRA3zzr2AtydrbXdOfj7xxkkUjF
         G2oa+aES2w06pCO7qjuXQI9y2j0L/Sw+GLmOM94hUMYBFjl7bvkEBnRfwfxq3ei2CxyI
         MQKRKDpvl9oy5ghpx/D1p/h1znhXypL1g0SAL8N7/+6/xJckJ1xHAmRWXw2RHQsq7uSN
         YXIg==
X-Gm-Message-State: AOAM5308moJ6uT2KRbEvaYP8h9ZOVbq/wnxYZR1EMTLV64vpKtKxBJ9M
        1Fb5lVmkIkqvIwbZcJlXzcFoCA==
X-Google-Smtp-Source: ABdhPJyL6ACnKBcWKU0Ek7jnIjThnmCrAvHpT+7xZ5GQoLYfDmG/qBO9Df1Aaq9oJCxFq9La2KRgEA==
X-Received: by 2002:a17:903:89:b029:12a:ee95:42df with SMTP id o9-20020a1709030089b029012aee9542dfmr5128828pld.77.1626214917950;
        Tue, 13 Jul 2021 15:21:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d3sm150696pjo.31.2021.07.13.15.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jul 2021 15:21:57 -0700 (PDT)
Date:   Tue, 13 Jul 2021 22:21:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Gonda <pgonda@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
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
Subject: Re: [PATCH 3/3] KVM, SEV: Add support for SEV-ES local migration
Message-ID: <YO4SAZiEIgzjQ5b3@google.com>
References: <20210621163118.1040170-1-pgonda@google.com>
 <20210621163118.1040170-4-pgonda@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210621163118.1040170-4-pgonda@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 21, 2021, Peter Gonda wrote:
> +static int process_vmsa_list(struct kvm *kvm, struct list_head *vmsa_list)
> +{
> +	struct vmsa_node *vmsa_node, *q;
> +	struct kvm_vcpu *vcpu;
> +	struct vcpu_svm *svm;
> +
> +	lockdep_assert_held(&kvm->lock);
> +
> +	if (!vmsa_list)

This is pointless, all callers pass in a list, i.e. it's mandatory.

> +		return 0;
> +
> +	list_for_each_entry(vmsa_node, vmsa_list, list) {
> +		if (!kvm_get_vcpu_by_id(kvm, vmsa_node->vcpu_id)) {
> +			WARN(1,
> +			     "Failed to find VCPU with ID %d despite presence in VMSA list.\n",
> +			     vmsa_node->vcpu_id);
> +			return -1;
> +		}
> +	}
> +
> +	/*
> +	 * Move any stashed VMSAs back to their respective VMCBs and delete
> +	 * those nodes.
> +	 */
> +	list_for_each_entry_safe(vmsa_node, q, vmsa_list, list) {
> +		vcpu = kvm_get_vcpu_by_id(kvm, vmsa_node->vcpu_id);

Barring a KVM bug, is it even theoretically possible for vcpu to be NULL?  If not,
I'd simply drop the above sanity check.  If this can only be true if there's a
KVM bug and you really want to keep it the WARN, just do:

		if (WARN_ON(!vcpu))
			continue;

since a KVM bug this egregious means all bets are off anyways.  That should also
allow you to make this a void returning helper and avoid pointless checking.

> +		svm = to_svm(vcpu);
> +		svm->vmsa = vmsa_node->vmsa;
> +		svm->ghcb = vmsa_node->ghcb;
> +		svm->vmcb->control.ghcb_gpa = vmsa_node->ghcb_gpa;
> +		svm->vcpu.arch.guest_state_protected = true;
> +		svm->vmcb->control.vmsa_pa = __pa(svm->vmsa);
> +		svm->ghcb_sa = vmsa_node->ghcb_sa;
> +		svm->ghcb_sa_len = vmsa_node->ghcb_sa_len;
> +		svm->ghcb_sa_sync = vmsa_node->ghcb_sa_sync;
> +		svm->ghcb_sa_free = vmsa_node->ghcb_sa_free;
> +
> +		list_del(&vmsa_node->list);
> +		kfree(vmsa_node);
> +	}
> +
> +	return 0;
> +}
> +
> +static int create_vmsa_list(struct kvm *kvm,
> +			    struct sev_info_migration_node *entry)
> +{
> +	int i;
> +	const int num_vcpus = atomic_read(&kvm->online_vcpus);
> +	struct vmsa_node *node;
> +	struct kvm_vcpu *vcpu;
> +	struct vcpu_svm *svm;
> +
> +	INIT_LIST_HEAD(&entry->vmsa_list);
> +	for (i = 0; i < num_vcpus; ++i) {
> +		node = kzalloc(sizeof(*node), GFP_KERNEL);
> +		if (!node)
> +			goto e_freelist;
> +
> +		vcpu = kvm->vcpus[i];
> +		node->vcpu_id = vcpu->vcpu_id;
> +
> +		svm = to_svm(vcpu);
> +		node->vmsa = svm->vmsa;
> +		svm->vmsa = NULL;
> +		node->ghcb = svm->ghcb;
> +		svm->ghcb = NULL;
> +		node->ghcb_gpa = svm->vmcb->control.ghcb_gpa;
> +		node->ghcb_sa = svm->ghcb_sa;
> +		svm->ghcb_sa = NULL;
> +		node->ghcb_sa_len = svm->ghcb_sa_len;
> +		svm->ghcb_sa_len = 0;
> +		node->ghcb_sa_sync = svm->ghcb_sa_sync;
> +		svm->ghcb_sa_sync = false;
> +		node->ghcb_sa_free = svm->ghcb_sa_free;
> +		svm->ghcb_sa_free = false;
> +
> +		list_add_tail(&node->list, &entry->vmsa_list);
> +	}
> +
> +	return 0;
> +
> +e_freelist:
> +	if (process_vmsa_list(kvm, &entry->vmsa_list))
> +		WARN(1, "Unable to move VMSA list back to source VM. Guest is in a broken state now.");

Same comments about err_freelist and using WARN_ON().  Though if process_vmsa_list()
can't return an error, this goes away entirely.

> +	return -1;
> +}
> +
>  static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  {
>  	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
> @@ -1174,9 +1280,6 @@ static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
>  
> -	if (sev->es_active)
> -		return -EPERM;
> -
>  	if (sev->info_token != 0)
>  		return -EEXIST;
>  
> @@ -1196,8 +1299,19 @@ static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	INIT_LIST_HEAD(&entry->regions_list);
>  	list_replace_init(&sev->regions_list, &entry->regions_list);
>  
> +	if (sev_es_guest(kvm)) {
> +		/*
> +		 * If this is an ES guest, we need to move each VMCB's VMSA into a
> +		 * list for migration.
> +		 */
> +		entry->es_enabled = true;
> +		entry->ap_jump_table = sev->ap_jump_table;
> +		if (create_vmsa_list(kvm, entry))
> +			goto e_listdel;
> +	}
> +
>  	if (place_migration_node(entry))
> -		goto e_listdel;
> +		goto e_vmsadel;
>  
>  	token = entry->token;
>  
> @@ -1215,6 +1329,11 @@ static int sev_local_send(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	hash_del(&entry->hnode);
>  	spin_unlock(&sev_info_migration_hash_lock);
>  
> +e_vmsadel:
> +	if (sev_es_guest(kvm) && process_vmsa_list(kvm, &entry->vmsa_list))
> +		WARN(1,
> +		     "Unable to move VMSA list back to source VM. Guest is in a broken state now.");

Guess what today's Final Jeopardy answer is? :-D

> +
>  e_listdel:
>  	list_replace_init(&entry->regions_list, &sev->regions_list);
>  
> @@ -1233,9 +1352,6 @@ static int sev_local_receive(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	if (!sev_guest(kvm))
>  		return -ENOTTY;
>  
> -	if (sev->es_active)
> -		return -EPERM;
> -
>  	if (sev->handle != 0)
>  		return -EPERM;
>  
> @@ -1254,6 +1370,14 @@ static int sev_local_receive(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  
>  	memcpy(&old_info, sev, sizeof(old_info));
>  
> +	if (entry->es_enabled) {
> +		if (process_vmsa_list(kvm, &entry->vmsa_list))
> +			goto err_unlock;
> +
> +		sev->es_active = true;
> +		sev->ap_jump_table = entry->ap_jump_table;
> +	}
> +
>  	/*
>  	 * The source VM always frees @entry On the target we simply
>  	 * mark the token as invalid to notify the source the sev info
> @@ -2046,12 +2170,22 @@ void sev_vm_destroy(struct kvm *kvm)
>  		__unregister_region_list_locked(kvm, &sev->regions_list);
>  	}
>  
> -	/*
> -	 * If userspace was terminated before unregistering the memory
> -	 * regions then lets unpin all the registered memory.
> -	 */
> -	if (entry)
> +	if (entry) {
> +		/*
> +		 * If there are any saved VMSAs, restore them so they can be
> +		 * destructed through the normal path.
> +		 */
> +		if (entry->es_enabled)
> +			if (process_vmsa_list(kvm, &entry->vmsa_list))
> +				WARN(1,
> +				     "Unable to clean up vmsa_list");

More code that can be zapped if process_vmsa_list() is less of a zealot.

> +
> +		/*
> +		 * If userspace was terminated before unregistering the memory
> +		 * regions then lets unpin all the registered memory.
> +		 */
>  		__unregister_region_list_locked(kvm, &entry->regions_list);
> +	}
>  
>  	mutex_unlock(&kvm->lock);
>  
> @@ -2243,9 +2377,11 @@ void sev_free_vcpu(struct kvm_vcpu *vcpu)
>  
>  	svm = to_svm(vcpu);
>  
> -	if (vcpu->arch.guest_state_protected)
> +	if (svm->ghcb && vcpu->arch.guest_state_protected)
>  		sev_flush_guest_memory(svm, svm->vmsa, PAGE_SIZE);
> -	__free_page(virt_to_page(svm->vmsa));
> +
> +	if (svm->vmsa)
> +		__free_page(virt_to_page(svm->vmsa));
>  
>  	if (svm->ghcb_sa_free)
>  		kfree(svm->ghcb_sa);
> -- 
> 2.32.0.288.g62a8d224e6-goog
> 
