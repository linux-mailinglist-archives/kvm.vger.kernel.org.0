Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FC941D0C06
	for <lists+kvm@lfdr.de>; Wed, 13 May 2020 11:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732467AbgEMJYM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 May 2020 05:24:12 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:57756 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728224AbgEMJYM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 May 2020 05:24:12 -0400
Received: from mxbackcorp2j.mail.yandex.net (mxbackcorp2j.mail.yandex.net [IPv6:2a02:6b8:0:1619::119])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id BED4A2E151A;
        Wed, 13 May 2020 12:24:08 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by mxbackcorp2j.mail.yandex.net (mxbackcorp/Yandex) with ESMTP id gMz7KUcFuC-O5oO2V9K;
        Wed, 13 May 2020 12:24:08 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1589361848; bh=PpfB+ATh0dUjhkQFoWNNsq69AtPWNpiiGZAi5l8NWMU=;
        h=In-Reply-To:Message-ID:Subject:To:From:References:Date:Cc;
        b=kV2yWTOKwEjkxPnietQjwptUb8gE4qZWMztmKOwNtz9NsWxdccVMyQ7govd3WTVXJ
         lHEsEFqp3FbpqJlsMxuXtcnDhWgrjyZgE2xotPjNE8M0G/e6Y3xX/c4QyHxT+Y4u6d
         xgTzXIHH0c8VVSXCH68bzcE9+zCWCkDXZmu1gTgU=
Authentication-Results: mxbackcorp2j.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from dynamic-iva.dhcp.yndx.net (dynamic-iva.dhcp.yndx.net [2a02:6b8:b080:9009::1:1])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id ZRgRUqyTun-O5XaL2sR;
        Wed, 13 May 2020 12:24:05 +0300
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (Client certificate not present)
Date:   Wed, 13 May 2020 12:24:04 +0300
From:   Roman Kagan <rvkagan@yandex-team.ru>
To:     Jon Doron <arilou@gmail.com>
Cc:     kvm@vger.kernel.org, linux-hyperv@vger.kernel.org,
        vkuznets@redhat.com
Subject: Re: [PATCH v11 2/7] x86/kvm/hyper-v: Simplify addition for custom
 cpuid leafs
Message-ID: <20200513092404.GB29650@rvkaganb.lan>
Mail-Followup-To: Roman Kagan <rvkagan@yandex-team.ru>,
        Jon Doron <arilou@gmail.com>, kvm@vger.kernel.org,
        linux-hyperv@vger.kernel.org, vkuznets@redhat.com
References: <20200424113746.3473563-1-arilou@gmail.com>
 <20200424113746.3473563-3-arilou@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424113746.3473563-3-arilou@gmail.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 24, 2020 at 02:37:41PM +0300, Jon Doron wrote:
> Simlify the code to define a new cpuid leaf group by enabled feature.
> 
> This also fixes a bug in which the max cpuid leaf was always set to
> HYPERV_CPUID_NESTED_FEATURES regardless if nesting is supported or not.

I'm not sure the bug is there.  My understanding is that
HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS is supposed to provide the range
of leaves that return meaningful information.
HYPERV_CPUID_NESTED_FEATURES *can* return meaningful information
regardless of whether nested virt is active.

So I'd rather skip reducing the returned set if !evmcs_ver.  The
returned set is sparse in .function anyway; anything that isn't there
will just return zeros to the guest.

Changing the cpuid is also guest-visible so care must be taken with
this.

> Any new CPUID group needs to consider the max leaf and be added in the
> correct order, in this method there are two rules:
> 1. Each cpuid leaf group must be order in an ascending order
> 2. The appending for the cpuid leafs by features also needs to happen by
>    ascending order.

It looks like unnecessary complication.  I think all you need to do to
simplify adding new leaves is to add a macro to hyperv-tlfs.h, say,
HYPERV_CPUID_MAX_PRESENT_LEAF, define it to
HYPERV_CPUID_NESTED_FEATURES, and redefine once another leaf is added
(compat may need to be taken care of).

Thanks,
Roman.

> Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> Signed-off-by: Jon Doron <arilou@gmail.com>
> ---
>  arch/x86/kvm/hyperv.c | 46 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 32 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index bcefa9d4e57e..ab3e9dbcabbe 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1785,27 +1785,45 @@ int kvm_vm_ioctl_hv_eventfd(struct kvm *kvm, struct kvm_hyperv_eventfd *args)
>  	return kvm_hv_eventfd_assign(kvm, args->conn_id, args->fd);
>  }
>  
> +/* Must be sorted in ascending order by function */
> +static struct kvm_cpuid_entry2 core_cpuid_entries[] = {
> +	{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
> +	{ .function = HYPERV_CPUID_INTERFACE },
> +	{ .function = HYPERV_CPUID_VERSION },
> +	{ .function = HYPERV_CPUID_FEATURES },
> +	{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
> +	{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
> +};
> +
> +static struct kvm_cpuid_entry2 evmcs_cpuid_entries[] = {
> +	{ .function = HYPERV_CPUID_NESTED_FEATURES },
> +};
> +
> +#define HV_MAX_CPUID_ENTRIES \
> +	(ARRAY_SIZE(core_cpuid_entries) +\
> +	 ARRAY_SIZE(evmcs_cpuid_entries))
> +
>  int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  				struct kvm_cpuid_entry2 __user *entries)
>  {
>  	uint16_t evmcs_ver = 0;
> -	struct kvm_cpuid_entry2 cpuid_entries[] = {
> -		{ .function = HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS },
> -		{ .function = HYPERV_CPUID_INTERFACE },
> -		{ .function = HYPERV_CPUID_VERSION },
> -		{ .function = HYPERV_CPUID_FEATURES },
> -		{ .function = HYPERV_CPUID_ENLIGHTMENT_INFO },
> -		{ .function = HYPERV_CPUID_IMPLEMENT_LIMITS },
> -		{ .function = HYPERV_CPUID_NESTED_FEATURES },
> -	};
> -	int i, nent = ARRAY_SIZE(cpuid_entries);
> +	struct kvm_cpuid_entry2 cpuid_entries[HV_MAX_CPUID_ENTRIES];
> +	int i, nent = 0;
> +
> +	/* Set the core cpuid entries required for Hyper-V */
> +	memcpy(&cpuid_entries[nent], &core_cpuid_entries,
> +	       sizeof(core_cpuid_entries));
> +	nent = ARRAY_SIZE(core_cpuid_entries);
>  
>  	if (kvm_x86_ops.nested_get_evmcs_version)
>  		evmcs_ver = kvm_x86_ops.nested_get_evmcs_version(vcpu);
>  
> -	/* Skip NESTED_FEATURES if eVMCS is not supported */
> -	if (!evmcs_ver)
> -		--nent;
> +	if (evmcs_ver) {
> +		/* EVMCS is enabled, add the required EVMCS CPUID leafs */
> +		memcpy(&cpuid_entries[nent], &evmcs_cpuid_entries,
> +		       sizeof(evmcs_cpuid_entries));
> +		nent += ARRAY_SIZE(evmcs_cpuid_entries);
> +	}
>  
>  	if (cpuid->nent < nent)
>  		return -E2BIG;
> @@ -1821,7 +1839,7 @@ int kvm_vcpu_ioctl_get_hv_cpuid(struct kvm_vcpu *vcpu, struct kvm_cpuid2 *cpuid,
>  		case HYPERV_CPUID_VENDOR_AND_MAX_FUNCTIONS:
>  			memcpy(signature, "Linux KVM Hv", 12);
>  
> -			ent->eax = HYPERV_CPUID_NESTED_FEATURES;
> +			ent->eax = cpuid_entries[nent - 1].function;
>  			ent->ebx = signature[0];
>  			ent->ecx = signature[1];
>  			ent->edx = signature[2];
> -- 
> 2.24.1
> 
