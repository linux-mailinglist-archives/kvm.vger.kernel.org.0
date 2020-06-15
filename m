Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F601F9CB8
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 18:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730557AbgFOQM0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 12:12:26 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28086 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730476AbgFOQMZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 12:12:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592237543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCMW+zRQoRVexmB9YumbelsaE73MORmWmoo3AK75EJM=;
        b=f1bTx08DFxUTytjQh3P5NWubui/LapjB9xZQjipY4nHT42voomxK8Mwk/533BH0OqF9K+0
        ExnwNJMzdkMgIMYxy1Yf4GKoAijcpUneAg6hCpZjMTSgxUzHVCKlt+rgmMLVI1Dpm/A7ET
        6UbrouHid7GMMc5uz1qKgt1wfpy9TmA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-1-kXhvdiqBMzyBhKnB7UQZFA-1; Mon, 15 Jun 2020 12:12:22 -0400
X-MC-Unique: kXhvdiqBMzyBhKnB7UQZFA-1
Received: by mail-wm1-f70.google.com with SMTP id p24so21348wma.4
        for <kvm@vger.kernel.org>; Mon, 15 Jun 2020 09:12:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OCMW+zRQoRVexmB9YumbelsaE73MORmWmoo3AK75EJM=;
        b=JixuTrBGeNbZW2f5JdrDY0rEdkxn7wv+Cq7TSLf9Hgi0BRVV1MM2Kkn1PS9adAtkA4
         H11eBKerqWyQKH+J9fna1T8oOkxlfRfOE5N3A5JbYUIGCm7+V53R8fsH6uHi4WgqFlEU
         fC8wNG6OJQGdAkosEaBcrP6Gv9bkabwl6z2IHh59VNeqEawIYcIMdoinnAxFDCMxPW0k
         ExSHOTl76+sE8tUTf6kkHIYCdFvOz6ce2POWU18cDH34cpyYnbX8vibs7Q3Guw/yeYb5
         LaPMc21TKJNcHdCPfku/RuvEWsNe4tWbIMpSwd5yT6cHX2mG8X48pUZ8e6uFP2rkgbrm
         /tQQ==
X-Gm-Message-State: AOAM532t4VGc9pwYlyACl72pgtG0lZDREqldlY1Fj40Fyq+UarWgiXU3
        XMmyTUmH2NdMFbrkQjr0q2pbVSSPQo2gMd47LEgdbl8mslI9CKCNfdsAVzCz/3MMb/xW7mI61P6
        CxnMJw7h9VxLC
X-Received: by 2002:a1c:32c4:: with SMTP id y187mr39636wmy.79.1592237540168;
        Mon, 15 Jun 2020 09:12:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw8Y9ZHqBEI7bzfblm4iLOhDq9lfZaf/VKMwnn+u0PM4fHGUPY+jVCFzxXzFMmrb8W7SSKvWA==
X-Received: by 2002:a1c:32c4:: with SMTP id y187mr39604wmy.79.1592237539927;
        Mon, 15 Jun 2020 09:12:19 -0700 (PDT)
Received: from [192.168.178.58] ([151.48.99.33])
        by smtp.gmail.com with ESMTPSA id f16sm30924wmh.27.2020.06.15.09.12.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2020 09:12:19 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Add helpers to identify interrupt type from
 intr_info
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200609014518.26756-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <9ee673cd-29b5-3e9a-ce34-9314c736df59@redhat.com>
Date:   Mon, 15 Jun 2020 18:12:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200609014518.26756-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/06/20 03:45, Sean Christopherson wrote:
> Add is_intr_type() and is_intr_type_n() to consolidate the boilerplate
> code for querying a specific type of interrupt given an encoded value
> from VMCS.VM_{ENTER,EXIT}_INTR_INFO, with and without an associated
> vector respectively.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
> 
> I wrote and proposed a version of this patch a while back[*], but AFAICT
> never posted it as a formal patch.
> 
> [*] https://lkml.kernel.org/r/20190819233537.GG1916@linux.intel.com
> 
>  arch/x86/kvm/vmx/vmcs.h | 32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmcs.h b/arch/x86/kvm/vmx/vmcs.h
> index 5c0ff80b85c0..7a3675fddec2 100644
> --- a/arch/x86/kvm/vmx/vmcs.h
> +++ b/arch/x86/kvm/vmx/vmcs.h
> @@ -72,11 +72,24 @@ struct loaded_vmcs {
>  	struct vmcs_controls_shadow controls_shadow;
>  };
>  
> +static inline bool is_intr_type(u32 intr_info, u32 type)
> +{
> +	const u32 mask = INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK;
> +
> +	return (intr_info & mask) == (INTR_INFO_VALID_MASK | type);
> +}
> +
> +static inline bool is_intr_type_n(u32 intr_info, u32 type, u8 vector)
> +{
> +	const u32 mask = INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK |
> +			 INTR_INFO_VECTOR_MASK;
> +
> +	return (intr_info & mask) == (INTR_INFO_VALID_MASK | type | vector);
> +}
> +
>  static inline bool is_exception_n(u32 intr_info, u8 vector)
>  {
> -	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
> -			     INTR_INFO_VALID_MASK)) ==
> -		(INTR_TYPE_HARD_EXCEPTION | vector | INTR_INFO_VALID_MASK);
> +	return is_intr_type_n(intr_info, INTR_TYPE_HARD_EXCEPTION, vector);
>  }
>  
>  static inline bool is_debug(u32 intr_info)
> @@ -106,28 +119,23 @@ static inline bool is_gp_fault(u32 intr_info)
>  
>  static inline bool is_machine_check(u32 intr_info)
>  {
> -	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VECTOR_MASK |
> -			     INTR_INFO_VALID_MASK)) ==
> -		(INTR_TYPE_HARD_EXCEPTION | MC_VECTOR | INTR_INFO_VALID_MASK);
> +	return is_exception_n(intr_info, MC_VECTOR);
>  }
>  
>  /* Undocumented: icebp/int1 */
>  static inline bool is_icebp(u32 intr_info)
>  {
> -	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
> -		== (INTR_TYPE_PRIV_SW_EXCEPTION | INTR_INFO_VALID_MASK);
> +	return is_intr_type(intr_info, INTR_TYPE_PRIV_SW_EXCEPTION);
>  }
>  
>  static inline bool is_nmi(u32 intr_info)
>  {
> -	return (intr_info & (INTR_INFO_INTR_TYPE_MASK | INTR_INFO_VALID_MASK))
> -		== (INTR_TYPE_NMI_INTR | INTR_INFO_VALID_MASK);
> +	return is_intr_type(intr_info, INTR_TYPE_NMI_INTR);
>  }
>  
>  static inline bool is_external_intr(u32 intr_info)
>  {
> -	return (intr_info & (INTR_INFO_VALID_MASK | INTR_INFO_INTR_TYPE_MASK))
> -		== (INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR);
> +	return is_intr_type(intr_info, INTR_TYPE_EXT_INTR);
>  }
>  
>  enum vmcs_field_width {
> 

Queued, thnkas.

Paolo

