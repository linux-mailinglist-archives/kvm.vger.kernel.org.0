Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 091BBC0912
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 18:02:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727824AbfI0QCK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Sep 2019 12:02:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727334AbfI0QCK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Sep 2019 12:02:10 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E5D43C0578F8
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 16:02:09 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id n3so1300941wrt.9
        for <kvm@vger.kernel.org>; Fri, 27 Sep 2019 09:02:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u4PbefLzpSAtONZJJIIROFydpszw7sXdei5rCTJaRwY=;
        b=k4gfTob+Y3dd/8ttfZOnsQ+d6IR5Boz2kNbXdW/VwbzBy3274I+9VA1PVXW6Au7Ba6
         4cvhAl1zC/OyC5CiOGtYzzCKlU1eEqkmflrY4OOPS326Q+4XutWD8rooufhZyLLRNvpw
         camir/wcMPTChXhg2e0b9Nb0j4AfQNItgQyUv/bowYZodgCVTPXWNWn00y6uFERRBVA4
         1tFCksKKEbV+svEMepN1WGL7Uj6+BDM65fJsOpQI//bvIsI9u6Bt8b4R63zk7RYHK0v4
         ZUB6KIvHNDQ28vHjgq8bMSIjV/vo9ketLnIoIGIxl3Ss82z+9QUikpdJPFoFEKRhKoSk
         AYHA==
X-Gm-Message-State: APjAAAVHmy606cAIUXUHzu1urpV79qjTUnBY9OpKgwtw5pzQpl4fPp1k
        vDrw2fSYAyqBiRuwyTidudOPZw3kIn//jPE2J34WOawh5MwUxi0+80fZpIS0EkGQ+mxCdRNoJwf
        hBHYKZ0bDYFNV
X-Received: by 2002:adf:e410:: with SMTP id g16mr3318119wrm.297.1569600128544;
        Fri, 27 Sep 2019 09:02:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzEKYsKgnVro8P+Ze/5n9ou5KpdYkn8SFSZf8bABTUb0f2m8lV6wdSqvHKlpEei/5C0k1VI0w==
X-Received: by 2002:adf:e410:: with SMTP id g16mr3318092wrm.297.1569600128295;
        Fri, 27 Sep 2019 09:02:08 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id w18sm6277327wmc.9.2019.09.27.09.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Sep 2019 09:02:07 -0700 (PDT)
Subject: Re: [PATCH] KVM: VMX: Set VMENTER_L1D_FLUSH_NOT_REQUIRED if
 !X86_BUG_L1TF
To:     Waiman Long <longman@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190826193023.23293-1-longman@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <3f639295-9597-c644-f3bb-90c6d606689b@redhat.com>
Date:   Fri, 27 Sep 2019 18:02:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826193023.23293-1-longman@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 26/08/19 21:30, Waiman Long wrote:
> The l1tf_vmx_mitigation is only set to VMENTER_L1D_FLUSH_NOT_REQUIRED
> when the ARCH_CAPABILITIES MSR indicates that L1D flush is not required.
> However, if the CPU is not affected by L1TF, l1tf_vmx_mitigation will
> still be set to VMENTER_L1D_FLUSH_AUTO. This is certainly not the best
> option for a !X86_BUG_L1TF CPU.
> 
> So force l1tf_vmx_mitigation to VMENTER_L1D_FLUSH_NOT_REQUIRED to make it
> more explicit in case users are checking the vmentry_l1d_flush parameter.
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 42ed3faa6af8..a00ce3d6bbfd 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7896,6 +7896,8 @@ static int __init vmx_init(void)
>  			vmx_exit();
>  			return r;
>  		}
> +	} else {
> +		l1tf_vmx_mitigation = VMENTER_L1D_FLUSH_NOT_REQUIRED;
>  	}
>  
>  #ifdef CONFIG_KEXEC_CORE
> 

Queued (for -rc2), thanks.

Paolo
