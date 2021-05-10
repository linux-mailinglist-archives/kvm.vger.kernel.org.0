Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F0E378FA8
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 15:54:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237171AbhEJNwb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 09:52:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238611AbhEJNoB (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:44:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620654167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rtRq9YU4jkG3/EbC6LTWA4AYqiwDLPipSg5MD3xnKqM=;
        b=DLavOTsbnVNAenm1hBRpfjfTG5AvJI4e3t6/DHW7dB8qYqCGjyBCHnfM9x56JTjc9ZQ2le
        +iW76+HpyG+gzg331rdjRNJq51xuUQGuj2jQBCAqVqiAqPBa9NzvIcfeeACbq3+3Inf/Vl
        AqDa9Jfm8z0buOTO4kvlhjBxy4fQcH8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-310-07EWzXi_OQGLQw71JbWSNA-1; Mon, 10 May 2021 09:42:46 -0400
X-MC-Unique: 07EWzXi_OQGLQw71JbWSNA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E046D107ACCD;
        Mon, 10 May 2021 13:42:43 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 424D45D9F0;
        Mon, 10 May 2021 13:42:39 +0000 (UTC)
Message-ID: <1547340661bae6ccd7c243d2a4eef65f6dbff2db.camel@redhat.com>
Subject: Re: [PATCH 1/8] KVM: VMX: Add a TSC multiplier field in VMCS12
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     ilstam@mailbox.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Date:   Mon, 10 May 2021 16:42:37 +0300
In-Reply-To: <20210506103228.67864-2-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-2-ilstam@mailbox.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> From: Ilias Stamatis <ilstam@amazon.com>
> 
> This is required for supporting nested TSC scaling.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/kvm/vmx/vmcs12.c | 1 +
>  arch/x86/kvm/vmx/vmcs12.h | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmcs12.c b/arch/x86/kvm/vmx/vmcs12.c
> index 034adb6404dc..d9f5d7c56ae3 100644
> --- a/arch/x86/kvm/vmx/vmcs12.c
> +++ b/arch/x86/kvm/vmx/vmcs12.c
> @@ -37,6 +37,7 @@ const unsigned short vmcs_field_to_offset_table[] = {
>  	FIELD64(VM_ENTRY_MSR_LOAD_ADDR, vm_entry_msr_load_addr),
>  	FIELD64(PML_ADDRESS, pml_address),
>  	FIELD64(TSC_OFFSET, tsc_offset),
> +	FIELD64(TSC_MULTIPLIER, tsc_multiplier),
>  	FIELD64(VIRTUAL_APIC_PAGE_ADDR, virtual_apic_page_addr),
>  	FIELD64(APIC_ACCESS_ADDR, apic_access_addr),
>  	FIELD64(POSTED_INTR_DESC_ADDR, posted_intr_desc_addr),
> diff --git a/arch/x86/kvm/vmx/vmcs12.h b/arch/x86/kvm/vmx/vmcs12.h
> index 13494956d0e9..bb81a23afe89 100644
> --- a/arch/x86/kvm/vmx/vmcs12.h
> +++ b/arch/x86/kvm/vmx/vmcs12.h
> @@ -70,7 +70,8 @@ struct __packed vmcs12 {
>  	u64 eptp_list_address;
>  	u64 pml_address;
>  	u64 encls_exiting_bitmap;
> -	u64 padding64[2]; /* room for future expansion */
> +	u64 tsc_multiplier;
> +	u64 padding64[1]; /* room for future expansion */

Getting low on the padding. Oh well...
>  	/*
>  	 * To allow migration of L1 (complete with its L2 guests) between
>  	 * machines of different natural widths (32 or 64 bit), we cannot have
> @@ -258,6 +259,7 @@ static inline void vmx_check_vmcs12_offsets(void)
>  	CHECK_OFFSET(eptp_list_address, 304);
>  	CHECK_OFFSET(pml_address, 312);
>  	CHECK_OFFSET(encls_exiting_bitmap, 320);
> +	CHECK_OFFSET(tsc_multiplier, 328);
>  	CHECK_OFFSET(cr0_guest_host_mask, 344);
>  	CHECK_OFFSET(cr4_guest_host_mask, 352);
>  	CHECK_OFFSET(cr0_read_shadow, 360);

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky


