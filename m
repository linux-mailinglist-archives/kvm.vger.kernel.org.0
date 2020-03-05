Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4501A17A790
	for <lists+kvm@lfdr.de>; Thu,  5 Mar 2020 15:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgCEOfw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Mar 2020 09:35:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:22065 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726141AbgCEOfw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Mar 2020 09:35:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583418951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m+FJnm7Fm4V1rR1qQ4GNpZknpP4SxNgpuyciDKENuMo=;
        b=Ae379LLnTj3qGgS/ioXLxjOE2wWBctklqcvmdX1OpsC0jTbIQRi5nlVNmKKRWGSUs6czVU
        iDR57KWLuVbd3YIX48Eeg6wieyy9VYD75EfaKX8lkRWn32F3GTC8GVYQPIuRSpfoPtKTBz
        sXkDfWlqd4octjS+YqQd8fTGWkRSz0Y=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-194-to6uf-dVMO6324wnTAkUOw-1; Thu, 05 Mar 2020 09:35:49 -0500
X-MC-Unique: to6uf-dVMO6324wnTAkUOw-1
Received: by mail-wm1-f70.google.com with SMTP id c5so2154431wmd.8
        for <kvm@vger.kernel.org>; Thu, 05 Mar 2020 06:35:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m+FJnm7Fm4V1rR1qQ4GNpZknpP4SxNgpuyciDKENuMo=;
        b=fdIFzGkJCcTuTDmd2zoRxMwVYZ5kVtYQJRFYTBzDlNbEmTYAT9NZNQYAdPezgis+5p
         5tTr+n+EbhV57dXc+2niH7tpWjqt/WZ3gjDTy6gp4+hOjBcAq76J0bRYblvxMdzjFtrb
         ArmHjYuTJX+E8auglFJR2g2Ea7px10YWtc4cyZLOH7NUIpqkduJ3CctLvGkziNPvcKuF
         ebGMY50vmkwR0x2xYq5e3GpdXz62IwpGoopuzeMtv3mUALUXSOutxtXM9Ne6RcwUERGg
         Xn1EhouCPYgdRk5PUskfctVqdn69OKgZmVFdfw551F+LDu1Ikqc1VHXxxhBp8QIp0WlP
         ne4g==
X-Gm-Message-State: ANhLgQ06WLBHyiIKHtgIC263ARRu7RgB5M4jeifvIjipPrJip1mSXRlY
        NuXMlH8LmINUrFu/po5KW+YrujhLIMcty9uWgdvff3p2OZPEFvzo97dw8tm6kSURKfBCkt1YIhm
        3wqL+QXYf5zrO
X-Received: by 2002:a1c:df45:: with SMTP id w66mr9864501wmg.171.1583418947818;
        Thu, 05 Mar 2020 06:35:47 -0800 (PST)
X-Google-Smtp-Source: ADFU+vsXRoDPOxh+lCD/rkrCx71ZIw8ngiGyWWdgfROAkX9kpjzShuavDX/8KrTgguqrRQ1r1TPNtA==
X-Received: by 2002:a1c:df45:: with SMTP id w66mr9864473wmg.171.1583418947539;
        Thu, 05 Mar 2020 06:35:47 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:9def:34a0:b68d:9993? ([2001:b07:6468:f312:9def:34a0:b68d:9993])
        by smtp.gmail.com with ESMTPSA id h20sm23970095wrc.47.2020.03.05.06.35.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 06:35:46 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: small optimization for is_mtrr_mask calculation
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <1583376535-27255-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2b678644-fcc0-e853-a53c-2651c1f6a327@redhat.com>
Date:   Thu, 5 Mar 2020 15:35:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <1583376535-27255-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/03/20 03:48, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> We can get is_mtrr_mask by calculating (msr - 0x200) % 2 directly.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/mtrr.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
> index 7f0059aa30e1..a98701d9f2bf 100644
> --- a/arch/x86/kvm/mtrr.c
> +++ b/arch/x86/kvm/mtrr.c
> @@ -348,7 +348,7 @@ static void set_var_mtrr_msr(struct kvm_vcpu *vcpu, u32 msr, u64 data)
>  	int index, is_mtrr_mask;
>  
>  	index = (msr - 0x200) / 2;
> -	is_mtrr_mask = msr - 0x200 - 2 * index;
> +	is_mtrr_mask = (msr - 0x200) % 2;
>  	cur = &mtrr_state->var_ranges[index];
>  
>  	/* remove the entry if it's in the list. */
> @@ -424,7 +424,7 @@ int kvm_mtrr_get_msr(struct kvm_vcpu *vcpu, u32 msr, u64 *pdata)
>  		int is_mtrr_mask;
>  
>  		index = (msr - 0x200) / 2;
> -		is_mtrr_mask = msr - 0x200 - 2 * index;
> +		is_mtrr_mask = (msr - 0x200) % 2;
>  		if (!is_mtrr_mask)
>  			*pdata = vcpu->arch.mtrr_state.var_ranges[index].base;
>  		else
> 

If you're going to do that, might as well use ">> 1" for index instead
of "/ 2", and "msr & 1" for is_mtrr_mask.

Paolo

