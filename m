Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D54F143CA1
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 13:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729596AbgAUMRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 07:17:34 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50920 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729449AbgAUMRe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 07:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579609053;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=++aOhMKuJnCXz0lh4xlX2vreaMatcfxy2SRwFiY0O7M=;
        b=JE/hK63hum/v7nJGsONjVCH0C5u0lGAFyhZYRH7RoAlCPsSs3PcPbH7JidqZQFmYQON+N1
        VuTqlmyZQHSL/5AfxHJv0plyRjDA7LIVXBRoT4g/OYCMQXJpj/059lBbJhWyIJzIUg6VUt
        yEH3AWtmN0k7jVpnK4WIP1mZwN54zmM=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-T4o_5Zh6N1uO3zvvQCDDtQ-1; Tue, 21 Jan 2020 07:17:31 -0500
X-MC-Unique: T4o_5Zh6N1uO3zvvQCDDtQ-1
Received: by mail-wr1-f70.google.com with SMTP id r2so1227844wrp.7
        for <kvm@vger.kernel.org>; Tue, 21 Jan 2020 04:17:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=++aOhMKuJnCXz0lh4xlX2vreaMatcfxy2SRwFiY0O7M=;
        b=Aj+eGUkrU3cyeEAhyayY3MeLu/WdFJjiI7tEbQ9Mv3fYDlWjzRXKKqov3XV/To4QuJ
         6jS3iPFfc+DOuNdyRcffre4MM+YDo4fllDMl6yHnpAU9NX5kHnHE1mMwzfA6nFI8L6z4
         1A2bE3ci1djVOp6t1q5VcYUYXqCQmlHGbzI0lS3v1e8YiqWTemEplAa1s6YtqPBB6xxt
         qUIowqhdskxIVqeCHA6sBz4xN86Tiz5D7BSHQRxSnhgY8sRDANgLYKvW4oU+o+i90QVh
         OWOrAozeoQSy8m2/XJYyu+pjr0bLxDA0vEImzGPSO25Ew++REacMDlbkHqtCQ3xrlpcO
         shRw==
X-Gm-Message-State: APjAAAXq+AQmoG3xG7A8tKmaeMddbvf49rlyaWxmRFQQWz642TyW77X0
        jiWQuw2RK/bJT5ceES5qZdH6ZLJiXK3IeB74ykoFv7kKEWJgZFonL2L35HEQaxwz8hSxbmX4a7n
        DOZPqbXALoIcw
X-Received: by 2002:a1c:7d8b:: with SMTP id y133mr4172646wmc.165.1579609050523;
        Tue, 21 Jan 2020 04:17:30 -0800 (PST)
X-Google-Smtp-Source: APXvYqwh3izfydfXQQHoAxmjudVBVICUhx93cIF7FIn9lfmUPgTUiP3yymysVQ/I9JAl5sJ9yJ4zlw==
X-Received: by 2002:a1c:7d8b:: with SMTP id y133mr4172612wmc.165.1579609050230;
        Tue, 21 Jan 2020 04:17:30 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:b509:fc01:ee8a:ca8a? ([2001:b07:6468:f312:b509:fc01:ee8a:ca8a])
        by smtp.gmail.com with ESMTPSA id f1sm53644157wro.85.2020.01.21.04.17.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 04:17:29 -0800 (PST)
Subject: Re: [PATCH] KVM: VMX: remove duplicated segment cache clear
To:     Miaohe Lin <linmiaohe@huawei.com>, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org
References: <20200121151518.27530-1-linmiaohe@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c43b3126-64c8-216c-41e3-14417ced0175@redhat.com>
Date:   Tue, 21 Jan 2020 13:17:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200121151518.27530-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/20 16:15, Miaohe Lin wrote:
> vmx_set_segment() clears segment cache unconditionally, so we should not
> clear it again by calling vmx_segment_cache_clear().
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/vmx.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index b5a0c2e05825..b32236e6b513 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -2688,8 +2688,6 @@ static void enter_pmode(struct kvm_vcpu *vcpu)
>  
>  	vmx->rmode.vm86_active = 0;
>  
> -	vmx_segment_cache_clear(vmx);
> -
>  	vmx_set_segment(vcpu, &vmx->rmode.segs[VCPU_SREG_TR], VCPU_SREG_TR);
>  
>  	flags = vmcs_readl(GUEST_RFLAGS);
> 

Queued, thanks.

Paolo

