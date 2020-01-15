Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F407D13CBEF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 19:18:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgAOSSQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 13:18:16 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:53601 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728904AbgAOSSP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 13:18:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579112294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T1l2IaCJc8x3A4Xb+p+1AqY/vTkonHYiWw1rDR8HsKQ=;
        b=aXVDfahALIKmV8NFOkJQdAoNjfk1m8DykAyn/BCujmUFbVKrFpcdHs5TUSyLYuKd1d9g4O
        0rRmkvbHdegVTzUw0o+Qs/wfhPYHuVAqQFEoxwUREaInD928pyKSIqwD9HmXlUNQDpPcrj
        XnjSYF6yDS6ffb2Hff31laVCk78o65E=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-436-Pn2gloq5NZy7hkVWOaVcPg-1; Wed, 15 Jan 2020 13:18:13 -0500
X-MC-Unique: Pn2gloq5NZy7hkVWOaVcPg-1
Received: by mail-wm1-f69.google.com with SMTP id g26so123060wmk.6
        for <kvm@vger.kernel.org>; Wed, 15 Jan 2020 10:18:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T1l2IaCJc8x3A4Xb+p+1AqY/vTkonHYiWw1rDR8HsKQ=;
        b=PALk9XDQUezs4cCfAhXcCPRgiXPu/JKsblOp7H+5xT624MyauM4mB3fgAnnEILzsQz
         0ZMOGXJtOMm9TZBPrUUyCUik7utk1FnVEXThU98dz+626PqOJhm6MR5pzQBVZoKrKZq4
         UGvlxRdqdxYboF8NhbVpv6nTfpDcjZKH82cTLDnRzCBT4xMYIXlCU3ZtsRof77J3H8Ho
         dqj9yeBKuJ+kTF3Ai17UjYN6EjHZ8tkziwp6/gTON40O56GJNSdvipZc1rhuwbXpOB5k
         TVhqsotmxM/rjnwSsSr8Q20b92g39E23SvEW5NTs1BSs/Xayicj6DWkehW9ZgFZ1xNJv
         6tTA==
X-Gm-Message-State: APjAAAXF8HnyWs0rmB2dWBzpbHqO+7Ol6Pwcpn1HmxCzc0Sd6d2ch9H+
        DpFYxv/QG9mSwGqnexa/8I1httlo5HisDzmrSkBqgBzyN084xVV2ldJtYFlWt1j7cL/FAi8liHR
        Dq9m3s9GnOsrn
X-Received: by 2002:a1c:a382:: with SMTP id m124mr1300990wme.90.1579112291792;
        Wed, 15 Jan 2020 10:18:11 -0800 (PST)
X-Google-Smtp-Source: APXvYqxBVFhQpDtas7p6reCH+kqo20jIbm0fibecd2WNuUARhRD91nkW5xhG2OY4Crq9r+f3v1Rb3g==
X-Received: by 2002:a1c:a382:: with SMTP id m124mr1300961wme.90.1579112291587;
        Wed, 15 Jan 2020 10:18:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:436:e17d:1fd9:d92a? ([2001:b07:6468:f312:436:e17d:1fd9:d92a])
        by smtp.gmail.com with ESMTPSA id u18sm25235793wrt.26.2020.01.15.10.18.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2020 10:18:10 -0800 (PST)
Subject: Re: [PATCH v2] KVM: nVMX: vmread should not set rflags to specify
 success in case of #PF
To:     linmiaohe <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     liran.alon@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <1577514324-18362-1-git-send-email-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <10e98b1b-773f-5b8b-6e30-84b167944d12@redhat.com>
Date:   Wed, 15 Jan 2020 19:18:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <1577514324-18362-1-git-send-email-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/12/19 07:25, linmiaohe wrote:
> From: Miaohe Lin <linmiaohe@huawei.com>
> 
> In case writing to vmread destination operand result in a #PF, vmread
> should not call nested_vmx_succeed() to set rflags to specify success.
> Similar to as done in VMPTRST (See handle_vmptrst()).
> 
> Reviewed-by: Liran Alon <liran.alon@oracle.com>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
> v2:
> 	rephrase commit title & message
> ---
>  arch/x86/kvm/vmx/nested.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 8edefdc9c0cb..c1ec9f25a417 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4799,8 +4799,10 @@ static int handle_vmread(struct kvm_vcpu *vcpu)
>  					instr_info, true, len, &gva))
>  			return 1;
>  		/* _system ok, nested_vmx_check_permission has verified cpl=0 */
> -		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e))
> +		if (kvm_write_guest_virt_system(vcpu, gva, &value, len, &e)) {
>  			kvm_inject_page_fault(vcpu, &e);
> +			return 1;
> +		}
>  	}
>  
>  	return nested_vmx_succeed(vcpu);
> 

Queued, thanks.

Paolo

