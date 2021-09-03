Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C75AD400613
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 21:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbhICTta (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 15:49:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49974 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233514AbhICTt3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Sep 2021 15:49:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630698508;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DW68GxV6Lb0qE4ekh0Ivx+87OsRzETRMBE0QJs6OocI=;
        b=L060QxMNPEFMY3hqmNeLmRxpF1/0AJoikeGUi99ofOSc0voDXT1gLSajhuVNi1b1NUosPG
        +RQyXaJJCTgRNcf8DksijuPT2Sk24vkxk2qdTsvx0S9udYuyqkbajNpjm8wMqRqtf9Ji57
        IFuTYU/3nDgIoMDPJRoaAvdBXFP0+fM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-2HDgqUOzOZWN2NPx5sx4EA-1; Fri, 03 Sep 2021 15:48:27 -0400
X-MC-Unique: 2HDgqUOzOZWN2NPx5sx4EA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E2058042D6;
        Fri,  3 Sep 2021 19:48:25 +0000 (UTC)
Received: from localhost (unknown [10.22.8.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A27675C1C5;
        Fri,  3 Sep 2021 19:48:24 +0000 (UTC)
Date:   Fri, 3 Sep 2021 15:48:24 -0400
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     Juergen Gross <jgross@suse.com>
Cc:     kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, maz@kernel.org,
        Jonathan Corbet <corbet@lwn.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v2 2/6] x86/kvm: add boot parameter for adding vcpu-id
 bits
Message-ID: <20210903194824.lfjzeaab6ct72pxn@habkost.net>
References: <20210903130808.30142-1-jgross@suse.com>
 <20210903130808.30142-3-jgross@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210903130808.30142-3-jgross@suse.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 03, 2021 at 03:08:03PM +0200, Juergen Gross wrote:
> Today the maximum vcpu-id of a kvm guest's vcpu on x86 systems is set
> via a #define in a header file.
> 
> In order to support higher vcpu-ids without generally increasing the
> memory consumption of guests on the host (some guest structures contain
> arrays sized by KVM_MAX_VCPU_ID) add a boot parameter for adding some
> bits to the vcpu-id. Additional bits are needed as the vcpu-id is
> constructed via bit-wise concatenation of socket-id, core-id, etc.
> As those ids maximum values are not always a power of 2, the vcpu-ids
> are sparse.
> 
> The additional number of bits needed is basically the number of
> topology levels with a non-power-of-2 maximum value, excluding the top
> most level.
> 
> The default value of the new parameter will be to take the correct
> setting from the host's topology.

Having the default depend on the host topology makes the host
behaviour unpredictable (which might be a problem when migrating
VMs from another host with a different topology).  Can't we just
default to 2?

> 
> Calculating the maximum vcpu-id dynamically requires to allocate the
> arrays using KVM_MAX_VCPU_ID as the size dynamically.
> 
> Signed-of-by: Juergen Gross <jgross@suse.com>
> ---
> V2:
> - switch to specifying additional bits (based on comment by Vitaly
>   Kuznetsov)
> 
> Signed-off-by: Juergen Gross <jgross@suse.com>
> ---
[...]
>  #define KVM_MAX_VCPUS 288
>  #define KVM_SOFT_MAX_VCPUS 240
> -#define KVM_MAX_VCPU_ID 1023
> +#define KVM_MAX_VCPU_ID kvm_max_vcpu_id()
[...]
> +unsigned int kvm_max_vcpu_id(void)
> +{
> +	int n_bits = fls(KVM_MAX_VCPUS - 1);
> +
> +	if (vcpu_id_add_bits < -1 || vcpu_id_add_bits > (32 - n_bits)) {
> +		pr_err("Invalid value of vcpu_id_add_bits=%d parameter!\n",
> +		       vcpu_id_add_bits);
> +		vcpu_id_add_bits = -1;
> +	}
> +
> +	if (vcpu_id_add_bits >= 0) {
> +		n_bits += vcpu_id_add_bits;
> +	} else {
> +		n_bits++;		/* One additional bit for core level. */
> +		if (topology_max_die_per_package() > 1)
> +			n_bits++;	/* One additional bit for die level. */
> +	}
> +
> +	if (!n_bits)
> +		n_bits = 1;
> +
> +	return (1U << n_bits) - 1;

The largest possible VCPU ID is not KVM_MAX_VCPU_ID,
it's (KVM_MAX_VCPU_ID - 1).  This is enforced by
kvm_vm_ioctl_create_vcpu().

That would mean KVM_MAX_VCPU_ID should be (1 << n_bits) instead
of ((1 << n_bits) - 1), wouldn't it?


> +}
> +EXPORT_SYMBOL_GPL(kvm_max_vcpu_id);
> +
>  /*
>   * Restoring the host value for MSRs that are only consumed when running in
>   * usermode, e.g. SYSCALL MSRs and TSC_AUX, can be deferred until the CPU
> -- 
> 2.26.2
> 

-- 
Eduardo

