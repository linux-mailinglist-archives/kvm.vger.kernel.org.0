Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F023470CC8
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 23:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344569AbhLJWFE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 17:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239516AbhLJWFD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 17:05:03 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD01EC061746;
        Fri, 10 Dec 2021 14:01:27 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id x15so34900591edv.1;
        Fri, 10 Dec 2021 14:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Kh+HakJNeBpqwMVb3MrVyBs4dX0x84rJo+mmuBSuras=;
        b=NUS4Ke/XLUGV3FydPQUywt5UxZtkKqcDoDEPcoFKahB81mr0TsQKPdZo8QSyX0YyEU
         tqSGtqMAQsjPqpfLmEfFTVMnycpQnziKFU4f7OpPm+ZbPbMI7ERy1GPc8OdxNUD336sJ
         5ZnvjSV4hrR80UsGyQ8J/OpMHSh16VX5Aqa2X52YA63+GSILRR1vxApZZRGpw7Xzi69X
         G01TKhG5GjfT7dI1771KPkCsJSHrwRxYeCH4gj4+mg2Cee8ufmSCT0kqTtG6AMVh84oi
         5ODdVYY4OoDvUmzAqu7VvIkZuC2L9q1EdBbtFvEO1ZpeU3bBw1UXZL5xDKOrj0hTu1BZ
         Cjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Kh+HakJNeBpqwMVb3MrVyBs4dX0x84rJo+mmuBSuras=;
        b=50Q2KbzLs3wuWcPBFdi33jNpnz08oLuY6AVifuL6X7Zbk0Pwp7tdvqFP3nMFFp60JO
         qTP1m7PPhx9RhQYlYySGgGJZGHztOcC8d9Hn1rkGGM7VWWKqZ9HLH0UJBk/YdLjO95Gb
         pa+IE5E4ax29VccKI6Wdl4hRWiZCUYflO4JCu6KuLyy2/bAJGT0v6QzKmwJV93NLk08/
         d2SmHCQuwCtwXNIeHtfqFXTiXRRn90I8fJpDiwbihJGelv4iqBbJ2bffSSdVGUkUMXVx
         XIx6dkiuXRua6LO0JvG86QDbckQYkTZ2fXweBG/I+ioM5FCOeGNOjXVHdSw0N1R3VqRq
         Qy2A==
X-Gm-Message-State: AOAM532CrEFNHO3qREma2O1n5bhAuliA1VUkCxQBb0NXSeN8FPhUmabZ
        Ml/HeqMaPGpUnQk8KEVJwaM=
X-Google-Smtp-Source: ABdhPJyEvb+wqXbCQcRXNiDmDKlyVPqyu5o2rOPLd6bl+8lJLaWiiVci3ali8qnnZ7eUWrNUrL2XgA==
X-Received: by 2002:a05:6402:42d4:: with SMTP id i20mr42903713edc.281.1639173686184;
        Fri, 10 Dec 2021 14:01:26 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id jy28sm1989602ejc.118.2021.12.10.14.01.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 14:01:25 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <97814bdf-2e58-2823-ca55-30b2447af3f1@redhat.com>
Date:   Fri, 10 Dec 2021 23:01:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Content-Language: en-US
To:     Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
        dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211208000359.2853257-16-yang.zhong@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 01:03, Yang Zhong wrote:
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -219,6 +219,11 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   		kvm_apic_set_version(vcpu);
>   	}
>   
> +	/* Enable saving guest XFD_ERR */
> +	best = kvm_find_cpuid_entry(vcpu, 7, 0);
> +	if (best && cpuid_entry_has(best, X86_FEATURE_AMX_TILE))
> +		vcpu->arch.guest_fpu.xfd_err = 0;
> +

This is incorrect.  Instead it should check whether leaf 0xD includes 
any dynamic features.

Paolo
