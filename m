Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48D86431840
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 13:56:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbhJRL6O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 07:58:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231621AbhJRL6I (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 07:58:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634558157;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fCM/GUGbXTstduw5A7ZtGYQzITbTV7AQFdkBboCynIE=;
        b=fatAZExHlkYvjov0gS602mfrLcbtAWjSCRMszS/Y814ERwhnT9Yt4LdLP85Lh4PVChBkJZ
        XcZbMu5UZhqYK3zl/JJY3k1SgcbYYwGz6YoQboekVBLlDxA5KebRhUcec46gck5Q41aYDn
        zoI/Dr0RJGnGCFNTxsWdIuYWTG85HIA=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-pS-igpeXPwinKCTvbBbGBA-1; Mon, 18 Oct 2021 07:55:56 -0400
X-MC-Unique: pS-igpeXPwinKCTvbBbGBA-1
Received: by mail-wr1-f71.google.com with SMTP id j19-20020adfb313000000b00160a9de13b3so8761425wrd.8
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 04:55:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fCM/GUGbXTstduw5A7ZtGYQzITbTV7AQFdkBboCynIE=;
        b=QOcCtLa5WI+p9Gp8otRjmmFf3sSknAsT+UsQf87+qBootRwUZ00ChNL/rXD+vt69a/
         VUGEl91msIqnHoguE/G6WmYiu2gf/JSIOwGa8MdUAqpqSJo6e3VkNp8i5boN8dE17r2M
         mtEf/3bKWYp4UWWQzPlPpoJce++xeqDNEIq05qvce1aI219y92vlUQlbJ+svQkx65Q/D
         YPM/ETBVDA9BvQCVAaghNSLQ3rREeD5yUc2phpvFAQpnvTGNJWC2T5Vu+0z4i6fvZhte
         KfUOmwdwWm8+eVrrC9rwlMrNlnh6Bmpam4qkEgcF5n9lsQsdGh1/M68iDCKoa6wqqsJB
         EXzA==
X-Gm-Message-State: AOAM531ISeH9HwFNjRsSJFiJwjRzHYomkhr0kQpKXlfv/deoWfg5quKa
        HYtQVJUS84Q90vaLIllvXdaWoxAa/WdPHZrzAj/pYKZgjSip6BLFdBSybeqVA/M4JyJVB3hnFzd
        XCFjZsYF+PQJF
X-Received: by 2002:a5d:598a:: with SMTP id n10mr34535603wri.93.1634558155063;
        Mon, 18 Oct 2021 04:55:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiVA0bTdZn/OFUfGqxOypsZ4ysp85b1Jd23TcQIsqU26rnc4Y3pUGQXL9xTCEja8xMGZgAYg==
X-Received: by 2002:a5d:598a:: with SMTP id n10mr34535587wri.93.1634558154877;
        Mon, 18 Oct 2021 04:55:54 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id x7sm12108195wrq.69.2021.10.18.04.55.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 04:55:54 -0700 (PDT)
Message-ID: <b1c49069-437c-7aa6-531d-6651dad72015@redhat.com>
Date:   Mon, 18 Oct 2021 13:55:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [patch 3/4] x86/kvm: Convert FPU handling to a single swap buffer
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, "Liu, Jing2" <jing2.liu@intel.com>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        kvm@vger.kernel.org, "Nakajima, Jun" <jun.nakajima@intel.com>,
        Sean Christopherson <seanjc@google.com>
References: <20211017151447.829495362@linutronix.de>
 <20211017152048.666354328@linutronix.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211017152048.666354328@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/10/21 19:03, Thomas Gleixner wrote:
>   	 */
> -	fpu_swap_kvm_fpu(vcpu->arch.user_fpu, vcpu->arch.guest_fpu,
> -			 ~XFEATURE_MASK_PKRU);
> +	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, true, ~XFEATURE_MASK_PKRU);
>   	trace_kvm_fpu(1);
>   }
>   
>   /* When vcpu_run ends, restore user space FPU context. */
>   static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
>   {
> -	/*
> -	 * Guests with protected state have guest_fpu == NULL which makes
> -	 * swap only restore the host state.
> -	 */
> -	fpu_swap_kvm_fpu(vcpu->arch.guest_fpu, vcpu->arch.user_fpu, ~0ULL);
> +	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, false, ~0ULL);

The restore mask can be ~XFEATURE_MASK_PKRU in this case tool this way 
it's constant and you can drop the third argument to the function.

Also perhaps it could be useful to add an

if (WARN_ON_ONCE(cur_fps->is_guest == enter_guest))
	return;

at the top of fpu_swap_kvm_fpstate, since the is_guest member (at least 
for now?) is only used for such kind of assertion.

Paolo

