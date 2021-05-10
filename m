Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5BBD37900F
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 16:07:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236221AbhEJOCQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 10:02:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:31643 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235491AbhEJN6H (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 09:58:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620655006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YmSE5Q2o5cDSvHYzCrBJZQG3gEE6PIoQILQOfWWCPoI=;
        b=WE5N87Rg+5X9w8OxLzk5Mg85bIMZx7fXlmNYjUgzUSDlbtVFr/ED8m1M1rcoaBZC8THtG8
        v3Q+sUC73FHgCb6fNVnyflnEOwqK+4rIDMUWGg1V9YXydQKQ9gtkIuVDePs/+2WzT3OtJC
        v5SN8S+nOebvTu2d3+2dPs3tYlKYiUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-VLE2wWhNP1qxC2KyzVHpDQ-1; Mon, 10 May 2021 09:56:45 -0400
X-MC-Unique: VLE2wWhNP1qxC2KyzVHpDQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BA23A1083AA1;
        Mon, 10 May 2021 13:56:43 +0000 (UTC)
Received: from starship (unknown [10.40.194.86])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BBB5060D54;
        Mon, 10 May 2021 13:56:39 +0000 (UTC)
Message-ID: <a6bb045bde7068c29a9103ccada57076bb39bd50.camel@redhat.com>
Subject: Re: [PATCH 7/8] KVM: VMX: Expose TSC scaling to L2
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     ilstam@mailbox.org, kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     ilstam@amazon.com, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        haozhong.zhang@intel.com, zamsden@gmail.com, mtosatti@redhat.com,
        dplotnikov@virtuozzo.com, dwmw@amazon.co.uk
Date:   Mon, 10 May 2021 16:56:38 +0300
In-Reply-To: <20210506103228.67864-8-ilstam@mailbox.org>
References: <20210506103228.67864-1-ilstam@mailbox.org>
         <20210506103228.67864-8-ilstam@mailbox.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2021-05-06 at 10:32 +0000, ilstam@mailbox.org wrote:
> From: Ilias Stamatis <ilstam@amazon.com>
> 
> Expose the TSC scaling feature to nested guests.
> 
> Signed-off-by: Ilias Stamatis <ilstam@amazon.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index a1bf28f33837..639cb9462103 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -2277,7 +2277,8 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
>  				  SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE |
>  				  SECONDARY_EXEC_VIRTUAL_INTR_DELIVERY |
>  				  SECONDARY_EXEC_APIC_REGISTER_VIRT |
> -				  SECONDARY_EXEC_ENABLE_VMFUNC);
> +				  SECONDARY_EXEC_ENABLE_VMFUNC |
> +				  SECONDARY_EXEC_TSC_SCALING);
>  		if (nested_cpu_has(vmcs12,
>  				   CPU_BASED_ACTIVATE_SECONDARY_CONTROLS))
>  			exec_control |= vmcs12->secondary_vm_exec_control;
> @@ -6483,7 +6484,8 @@ void nested_vmx_setup_ctls_msrs(struct nested_vmx_msrs *msrs, u32 ept_caps)
>  		SECONDARY_EXEC_RDRAND_EXITING |
>  		SECONDARY_EXEC_ENABLE_INVPCID |
>  		SECONDARY_EXEC_RDSEED_EXITING |
> -		SECONDARY_EXEC_XSAVES;
> +		SECONDARY_EXEC_XSAVES |
> +		SECONDARY_EXEC_TSC_SCALING;
>  
>  	/*
>  	 * We can emulate "VMCS shadowing," even if the hardware


Seems to be correct. I don't yet have experience with how VMX does the VMX capablity
msrs and primary/secondary/entry/exit/pinbased control fitering for features that are not supported on the host,
but after digging through it this seems to be OK.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

