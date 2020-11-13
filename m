Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2922B1AC2
	for <lists+kvm@lfdr.de>; Fri, 13 Nov 2020 13:05:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbgKMMFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Nov 2020 07:05:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:42468 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgKML0b (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Nov 2020 06:26:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605266785;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8Jz+qn6L2dKOdzkMNeYJ7i10uOGTnka7jGpACGkgmZc=;
        b=IG4lTBmx8LR5smq1hHHZyUNd9qnLVJOvd1JlfScJvJK4VNKqXGMS4SAI1z/Vwxcp8PNyyJ
        TooZj+dU8iyGjhIzr65RHcsEMe9TL7PkmYyqbn0/vskJYJI3A6Rzwbq5eSR410AstlerTb
        bDi+RSGv4ndgEiG3Yv51MjxYogyFGgs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252--8R_mPW3MYCcTMr8w0Aakw-1; Fri, 13 Nov 2020 06:26:23 -0500
X-MC-Unique: -8R_mPW3MYCcTMr8w0Aakw-1
Received: by mail-wm1-f72.google.com with SMTP id e15so3062587wme.4
        for <kvm@vger.kernel.org>; Fri, 13 Nov 2020 03:26:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Jz+qn6L2dKOdzkMNeYJ7i10uOGTnka7jGpACGkgmZc=;
        b=sptNDXqTjVexhs2+9OGf/yszF/rS/HCnPO12VlJln6zV564Lq8K2fHBEAKaWa5pGPR
         rk/zg0G6rfXxF+OT0jcHD74htWEkmdoMrJ2VK+fiU78mX8q/1A5+yW8Zx4wVFaTJbC6O
         0mVRLm5aechwdX03oL1mhOSEBjcOcMVJnQsysXFU1ditvFjC5XA4v8vjSNntLdD2l9CF
         V+p70QFoiKdxQZXOis/kSA1uRW1RrG6HZ3cV6O+brmnSFz6QUiEqMKwZFotPlvfWRKhs
         60EnwTOJLQnjGh8dnE9y1qx74Ej2CAL/HdguYIVTm78rnxIidFeAFNRDpc4D+chSgYU5
         +Xxg==
X-Gm-Message-State: AOAM532JrzENq6Ht7QXYyv6klxVxSeFYxqlq3tFBnjTyZrX1+1cws+HT
        KoR5aDAhSBiPUkgTHH7JbkYGxNwkUV3ea8aPXPlH3gfD/dqgbIlgM+fpcz3XQrKB0QU9pUj0zzp
        JMw7dLw9cr780
X-Received: by 2002:adf:f9c4:: with SMTP id w4mr2968126wrr.64.1605266782278;
        Fri, 13 Nov 2020 03:26:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmXD55VKOmbBrRbr3PNsC5EHvRtkKPqQGlAQnXcj1shncjQCtuO5fjUnS9Cwmq5oQpi6qGqw==
X-Received: by 2002:adf:f9c4:: with SMTP id w4mr2968095wrr.64.1605266782064;
        Fri, 13 Nov 2020 03:26:22 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g186sm19977226wma.1.2020.11.13.03.26.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2020 03:26:21 -0800 (PST)
Subject: Re: [PATCH] KVM: x86: clflushopt should be treated as a no-op by
 emulation
To:     David Edmondson <david.edmondson@oracle.com>,
        linux-kernel@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Nadav Amit <namit@cs.technion.ac.il>, x86@kernel.org,
        Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>
References: <20201103120400.240882-1-david.edmondson@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <72b96832-634a-56f0-95aa-f9a282d8fbf8@redhat.com>
Date:   Fri, 13 Nov 2020 12:26:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103120400.240882-1-david.edmondson@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/11/20 13:04, David Edmondson wrote:
> The instruction emulator ignores clflush instructions, yet fails to
> support clflushopt. Treat both similarly.
> 
> Fixes: 13e457e0eebf ("KVM: x86: Emulator does not decode clflush well")
> Signed-off-by: David Edmondson <david.edmondson@oracle.com>
> ---
>   arch/x86/kvm/emulate.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
> index 0d917eb70319..56cae1ff9e3f 100644
> --- a/arch/x86/kvm/emulate.c
> +++ b/arch/x86/kvm/emulate.c
> @@ -4046,6 +4046,12 @@ static int em_clflush(struct x86_emulate_ctxt *ctxt)
>   	return X86EMUL_CONTINUE;
>   }
>   
> +static int em_clflushopt(struct x86_emulate_ctxt *ctxt)
> +{
> +	/* emulating clflushopt regardless of cpuid */
> +	return X86EMUL_CONTINUE;
> +}
> +
>   static int em_movsxd(struct x86_emulate_ctxt *ctxt)
>   {
>   	ctxt->dst.val = (s32) ctxt->src.val;
> @@ -4585,7 +4591,7 @@ static const struct opcode group11[] = {
>   };
>   
>   static const struct gprefix pfx_0f_ae_7 = {
> -	I(SrcMem | ByteOp, em_clflush), N, N, N,
> +	I(SrcMem | ByteOp, em_clflush), I(SrcMem | ByteOp, em_clflushopt), N, N,
>   };
>   
>   static const struct group_dual group15 = { {
> 

Queued, thanks.

Paolo

