Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B012A331ECB
	for <lists+kvm@lfdr.de>; Tue,  9 Mar 2021 06:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbhCIFwH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Mar 2021 00:52:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45469 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229840AbhCIFv5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 9 Mar 2021 00:51:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615269116;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jenfHKSYYf4klmcOIdM69Sy7rgrW9908589vTI22JGs=;
        b=VuH8QbDNfhkCm0HJgsVo595JlPm28Kd8RK3/OfyUcNzePQs9yli8pkqht6aT2K/1OrbYni
        UrSciHdECeBKX3vfgE4dQScW69ZBTf6OF6A252ewfofkR+xbXw4SbXo3m/RFl30OSc7eyO
        F0DO9fqFZGv1QYgxoL4xH3ar+ooz51o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-523-NauLqWzpP9amaUfOzvWX1w-1; Tue, 09 Mar 2021 00:51:54 -0500
X-MC-Unique: NauLqWzpP9amaUfOzvWX1w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6FC3788EF00;
        Tue,  9 Mar 2021 05:51:53 +0000 (UTC)
Received: from wangxiaodeMacBook-Air.local (ovpn-12-195.pek2.redhat.com [10.72.12.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4C21D5D72F;
        Tue,  9 Mar 2021 05:51:42 +0000 (UTC)
Subject: Re: [RFC v3 2/5] KVM: x86: add support for ioregionfd signal handling
To:     Elena Afanasova <eafanasova@gmail.com>, kvm@vger.kernel.org
Cc:     stefanha@redhat.com, jag.raman@oracle.com,
        elena.ufimtseva@oracle.com, pbonzini@redhat.com, mst@redhat.com,
        cohuck@redhat.com, john.levon@nutanix.com
References: <cover.1613828726.git.eafanasova@gmail.com>
 <575df1656277c55f26e660b7274a7c570b448636.1613828727.git.eafanasova@gmail.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e276b54a-b2c0-c12e-fdae-22f54824ee6f@redhat.com>
Date:   Tue, 9 Mar 2021 13:51:40 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <575df1656277c55f26e660b7274a7c570b448636.1613828727.git.eafanasova@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 2021/2/21 8:04 下午, Elena Afanasova wrote:
> The vCPU thread may receive a signal during ioregionfd communication,
> ioctl(KVM_RUN) needs to return to userspace and then ioctl(KVM_RUN)
> must resume ioregionfd.


After a glance at the patch, I wonder can we split the patch into two?

1) sleepable iodevice which is not supported currently, probably with a 
new cap?
2) ioregionfd specific codes (I wonder if it has any)

Then the sleepable iodevice could be reused by future features.


>
> Signed-off-by: Elena Afanasova <eafanasova@gmail.com>
> ---
> v3:
>   - add FAST_MMIO bus support
>   - move ioregion_interrupted flag to ioregion_ctx
>   - reorder ioregion_ctx fields
>   - rework complete_ioregion operations
>   - add signal handling support for crossing a page boundary case
>   - fix kvm_arch_vcpu_ioctl_run() should return -EINTR in case ioregionfd
>     is interrupted
>
>   arch/x86/kvm/vmx/vmx.c   |  40 +++++-
>   arch/x86/kvm/x86.c       | 272 +++++++++++++++++++++++++++++++++++++--
>   include/linux/kvm_host.h |  10 ++
>   virt/kvm/kvm_main.c      |  16 ++-
>   4 files changed, 317 insertions(+), 21 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 47b8357b9751..39db31afd27e 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -5357,19 +5357,51 @@ static int handle_ept_violation(struct kvm_vcpu *vcpu)
>   	return kvm_mmu_page_fault(vcpu, gpa, error_code, NULL, 0);
>   }
>   
> +#ifdef CONFIG_KVM_IOREGION
> +static int complete_ioregion_fast_mmio(struct kvm_vcpu *vcpu)
> +{
> +	int ret, idx;
> +
> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> +	ret = kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS,
> +			       vcpu->ioregion_ctx.addr, 0, NULL);
> +	if (ret) {
> +		ret = kvm_mmu_page_fault(vcpu, vcpu->ioregion_ctx.addr,
> +					 PFERR_RSVD_MASK, NULL, 0);
> +		srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +		return ret;
> +	}
> +
> +	srcu_read_unlock(&vcpu->kvm->srcu, idx);
> +	return kvm_skip_emulated_instruction(vcpu);
> +}
> +#endif
> +
>   static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>   {
>   	gpa_t gpa;
> +	int ret;
>   
>   	/*
>   	 * A nested guest cannot optimize MMIO vmexits, because we have an
>   	 * nGPA here instead of the required GPA.
>   	 */
>   	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> -	if (!is_guest_mode(vcpu) &&
> -	    !kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
> -		trace_kvm_fast_mmio(gpa);
> -		return kvm_skip_emulated_instruction(vcpu);
> +	if (!is_guest_mode(vcpu)) {
> +		ret = kvm_io_bus_write(vcpu, KVM_FAST_MMIO_BUS, gpa, 0, NULL);
> +		if (!ret) {
> +			trace_kvm_fast_mmio(gpa);
> +			return kvm_skip_emulated_instruction(vcpu);
> +		}
> +
> +#ifdef CONFIG_KVM_IOREGION
> +		if (unlikely(vcpu->ioregion_ctx.is_interrupted && ret == -EINTR)) {


So the question still, EINTR looks wrong which means the syscall can't 
be restarted. Not that the syscal doesn't mean KVM_RUN but actually the 
kernel_read|write() you want to do with the ioregion fd.

Also do we need to treat differently for EINTR and ERESTARTSYS since 
EINTR means the kernel_read()|write() can't be resumed.

Thanks

