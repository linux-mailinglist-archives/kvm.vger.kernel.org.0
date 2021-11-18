Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC82456019
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 17:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhKRQIg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 11:08:36 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:30317 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230133AbhKRQIf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Nov 2021 11:08:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637251534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NoP5kE8w00obosPq8BwwxTuvnKXCJqUeOM7n6CSCB2U=;
        b=D0Mf1perBigVx4XvMImrJyxBkjthbm51v6dRyzCKB5oYHhAB22fdFE4lDCQb5T4GxZ3WJT
        GlUrp4mO+YuAnUTU2c04WwhzFrAinMGiXnTxp8qO/iOMkrI4E9EztxvCkvxXZ94OV/TZXI
        jEoR6SQwtH/y1A5ROQdpXReNRkIpvtg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-560-kiYuzqXdNU2xjVKPhKdxmw-1; Thu, 18 Nov 2021 11:05:31 -0500
X-MC-Unique: kiYuzqXdNU2xjVKPhKdxmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7624C875110;
        Thu, 18 Nov 2021 16:05:29 +0000 (UTC)
Received: from [10.39.192.245] (unknown [10.39.192.245])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5CCAA19E7E;
        Thu, 18 Nov 2021 16:05:25 +0000 (UTC)
Message-ID: <226fc242-ae46-3214-4e01-dbfdf5f7c0fb@redhat.com>
Date:   Thu, 18 Nov 2021 17:05:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 05/15] KVM: VMX: Add document to state that write to uret
 msr should always be intercepted
Content-Language: en-US
To:     Lai Jiangshan <jiangshanlai@gmail.com>,
        linux-kernel@vger.kernel.org
Cc:     kvm@vger.kernel.org, Lai Jiangshan <laijs@linux.alibaba.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211118110814.2568-1-jiangshanlai@gmail.com>
 <20211118110814.2568-6-jiangshanlai@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211118110814.2568-6-jiangshanlai@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/18/21 12:08, Lai Jiangshan wrote:
> From: Lai Jiangshan <laijs@linux.alibaba.com>
> 
> And adds a corresponding sanity check code.
> 
> Signed-off-by: Lai Jiangshan <laijs@linux.alibaba.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index e8a41fdc3c4d..cd081219b668 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -3703,13 +3703,21 @@ void vmx_disable_intercept_for_msr(struct kvm_vcpu *vcpu, u32 msr, int type)
>   	if (!cpu_has_vmx_msr_bitmap())
>   		return;
>   
> +	/*
> +	 * Write to uret msr should always be intercepted due to the mechanism
> +	 * must know the current value.  Santity check to avoid any inadvertent
> +	 * mistake in coding.
> +	 */
> +	if (WARN_ON_ONCE(vmx_find_uret_msr(vmx, msr) && (type & MSR_TYPE_W)))
> +		return;
> +

I'm not sure about this one, it's relatively expensive to call 
vmx_find_uret_msr.

User-return MSRs and disable-intercept MSRs are almost the opposite: 
uret is for MSRs that the host (not even the processor) never uses, 
disable-intercept is for MSRs that the guest reads/writes often.  As 
such it seems almost impossible that they overlap.

Paolo

