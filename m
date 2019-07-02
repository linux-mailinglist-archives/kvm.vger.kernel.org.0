Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1A15D4BE
	for <lists+kvm@lfdr.de>; Tue,  2 Jul 2019 18:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfGBQvi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Jul 2019 12:51:38 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51721 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbfGBQvi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Jul 2019 12:51:38 -0400
Received: by mail-wm1-f66.google.com with SMTP id 207so1548531wma.1
        for <kvm@vger.kernel.org>; Tue, 02 Jul 2019 09:51:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y2ul1aWT3YNbpLynjt1kG5w3TcxeoEIqkfW25uUns/E=;
        b=r3Yn42+yOVju0YDQ4QXFXwwwXNp2C/RUZQl5Ve+sM6dhfH793AavbZzhrc4dVArM7S
         74tMI1ecyCQIWyNQM9rwBmCrXIFuLrkJwwvlEULkz4KEU9sQS1OpmN2ODnWILfEIkPaF
         yotnzpIHDJt7WjaxZVAj+eOauPPYBFokhBH15qLdy/DcxVGIyyqa9jiuqLdRisSs0x6H
         fHJ5K0+MyPOpb0rxcoCzxUpnRztu0E5s6zbV7ON13rnMh4BVREEjfj8tRezDvxLfozsR
         XqDegk/1Tzbvw96QBrvHJqVURjRnQbkuf7lVwUAyRhj1d83hc+q/BbJgx58wUJoh1Bwq
         iUuA==
X-Gm-Message-State: APjAAAVnku6nYCVAsMnDr3i+LD6LMDs+ye1rtvYO1vYzaEV4Z7JCF4Jp
        nM0GlWnmaWEp717mqhxbys2pIk4Zro4=
X-Google-Smtp-Source: APXvYqzrirTBmKCJMb7myt8eMVZnuElbDJ1qX6d5GImxLoE8PQeQKPCf8fh4/MS1JCKpeFKVaWiCJw==
X-Received: by 2002:a1c:343:: with SMTP id 64mr4299469wmd.116.1562086295931;
        Tue, 02 Jul 2019 09:51:35 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:b8:794:183e:9e2a? ([2001:b07:6468:f312:b8:794:183e:9e2a])
        by smtp.gmail.com with ESMTPSA id t17sm12697204wrs.45.2019.07.02.09.51.35
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Jul 2019 09:51:35 -0700 (PDT)
Subject: Re: [PATCH] kvm: x86: Pass through AMD_STIBP_ALWAYS_ON in
 GET_SUPPORTED_CPUID
To:     Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
References: <20190627183651.130922-1-jmattson@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <57224c9f-09af-db18-24b6-ecbfa1e5fb25@redhat.com>
Date:   Tue, 2 Jul 2019 18:51:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190627183651.130922-1-jmattson@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/06/19 20:36, Jim Mattson wrote:
> This bit is purely advisory. Passing it through to the guest indicates
> that the virtual processor, like the physical processor, prefers that
> STIBP is only set once during boot and not changed.
> 
> Signed-off-by: Jim Mattson <jmattson@google.com>
> ---
>  arch/x86/kvm/cpuid.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 4992e7c99588..e52f0b20d2f0 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -377,7 +377,7 @@ static inline int __do_cpuid_ent(struct kvm_cpuid_entry2 *entry, u32 function,
>  	/* cpuid 0x80000008.ebx */
>  	const u32 kvm_cpuid_8000_0008_ebx_x86_features =
>  		F(WBNOINVD) | F(AMD_IBPB) | F(AMD_IBRS) | F(AMD_SSBD) | F(VIRT_SSBD) |
> -		F(AMD_SSB_NO) | F(AMD_STIBP);
> +		F(AMD_SSB_NO) | F(AMD_STIBP) | F(AMD_STIBP_ALWAYS_ON);
>  
>  	/* cpuid 0xC0000001.edx */
>  	const u32 kvm_cpuid_C000_0001_edx_x86_features =
> 

Queued, thanks.

Paolo
