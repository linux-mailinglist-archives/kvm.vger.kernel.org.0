Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE061C8CD7
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 15:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbgEGNqR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 09:46:17 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55896 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725879AbgEGNqQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 May 2020 09:46:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588859175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DGmeNlAT2Tpja07VB0b+14eYJ13Gy9SOk4Jv5Ofw8q0=;
        b=dkgJ5kTx7eflNFRY1Yoeqg0MSEpdjwBFsPYRZswWK6wOuOL26s8zP6wYuPmhnA0UB39PE0
        UrvfS20Shn0sMcf6heThRdido58Hqey92jg393Axa+QxZ3Ieyc8uQcCd9/Bv0IhPE2KiMz
        xTtqP9Tu1HZJuPsx56lWreWTSB6ajGU=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-514-HB9v4dCXOFGA_zsq4C0tPA-1; Thu, 07 May 2020 09:46:13 -0400
X-MC-Unique: HB9v4dCXOFGA_zsq4C0tPA-1
Received: by mail-wr1-f69.google.com with SMTP id q13so3467173wrn.14
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 06:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DGmeNlAT2Tpja07VB0b+14eYJ13Gy9SOk4Jv5Ofw8q0=;
        b=dN8fnkH5JRGQo8EXtOcLQXAKQS+HCMmmqczlS5/+IwELTScf9Piz+l/cWv2nfsT+uT
         5EWK5PbyhPrbndsvc1KKrQ8wlScRiwjWyVvsAAsbGcBXw6agydt2F0rxzpbD6UnoHuZR
         mnpWIclYY9zrIwCRATvUuiHDr3zMAspjj6DXT3WmfoCS++Q106niz/Aw+N5iqZmQtfmg
         VbuBohs8rhQeAiVpqH/Hy6B4UBe1gHKUyY/ZDH1ciyRkTUbplCLzc9uXNhr8QORzlDRQ
         81e1DnfJcynCkLr2IA4WDlSyUECmH016a/tP4fsmjpFVLNRUynRkjxVegD1f8WCXhw+I
         ogbA==
X-Gm-Message-State: AGi0PuZDy3QUAUcLQRfQrDQ/oKbv0+z0ExZT8NXbfpFVwoTYc9x0OOZ+
        Sl+ueMAXBLDiSO0Lg6O2jaXqzNENfUoWkfFDTvz0ciIwqU2xHMWDWO0iyWTm1+F4QpYj5ZNHvbq
        dJRJuhaEpb94B
X-Received: by 2002:a7b:c3d4:: with SMTP id t20mr10931687wmj.170.1588859171946;
        Thu, 07 May 2020 06:46:11 -0700 (PDT)
X-Google-Smtp-Source: APiQypJbx06UMPSuVoCTfzSmaWfd73H+Wgu8lr0gOB9Q94WZ+0p0Ewh2qBzXnS0J3hAUvG35EApplA==
X-Received: by 2002:a7b:c3d4:: with SMTP id t20mr10931643wmj.170.1588859171365;
        Thu, 07 May 2020 06:46:11 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:8d3e:39e5:cd88:13cc? ([2001:b07:6468:f312:8d3e:39e5:cd88:13cc])
        by smtp.gmail.com with ESMTPSA id a8sm8171159wrg.85.2020.05.07.06.46.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 06:46:10 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not
 set on vmrun of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org,
        Wei Huang <wei.huang2@amd.com>
References: <20200504223523.7166-1-krish.sadhukhan@oracle.com>
 <20200504223523.7166-2-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bb452b34-9bcd-d3f7-18db-c8bff02da698@redhat.com>
Date:   Thu, 7 May 2020 15:46:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200504223523.7166-2-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/05/20 00:35, Krish Sadhukhan wrote:
> +	if (!(vmcb->save.efer & EFER_LMA)) {
> +		if (vmcb->save.cr4 & X86_CR4_PAE) {
> +			if (vmcb->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
> +				return false;
> +		} else {
> +			if (vmcb->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
> +				return false;
> +		}
> +		if (vmcb->save.cr4 & MSR_CR4_LEGACY_RESERVED_MASK)
> +			return false;
> +	} else {
> +		if ((vmcb->save.cr4 & X86_CR4_PAE) &&
> +		    (vmcb->save.cr3 & MSR_CR3_LONG_RESERVED_MASK))
> +			return false;
> +		if (vmcb->save.cr4 & MSR_CR4_RESERVED_MASK)
> +			return false;
> +	}
> +
>  	if ((vmcb->control.intercept & (1ULL << INTERCEPT_VMRUN)) == 0)
>  		return false;
>  

I think checking LMA from the guest state is incorrect, the number of
bits in CR3 and CR4 remains 64 as long as the host processor is 64-bits.
 This of course is unless you have reproduced on bare metal that a
hypervisor running in 32-bit mode ignores the top 32 bits.

Also, the checks for CR4 must use the guest's reserved bits, using
kvm_valid_cr4.  However this can be a bit slow so it is probably a good
idea to cache the bits in kvm_update_cpuid.

Thanks,

Paolo

> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index df3474f..796c083 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -354,7 +354,12 @@ static inline bool gif_set(struct vcpu_svm *svm)
>  }
>  
>  /* svm.c */
> -#define MSR_INVALID			0xffffffffU
> +#define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
> +#define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
> +#define MSR_CR3_LONG_RESERVED_MASK		0xfff0000000000fe7U
> +#define MSR_CR4_LEGACY_RESERVED_MASK		0xffbaf000U
> +#define MSR_CR4_RESERVED_MASK			0xffffffffffbaf000U
> +#define MSR_INVALID				0xffffffffU
>  

