Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1266218427
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 11:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728169AbgGHJse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 05:48:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20293 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726445AbgGHJse (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jul 2020 05:48:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594201713;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s7qKIvefs+Nswt+yThb+00wqIjYx3wKhVFohWCds6UY=;
        b=MRHAeiTWB6/DtBPZqRIj1zsvji7RBVPFly0RArrkXYx0s9DkETsOVJTWvYYacBJ2IWb/M3
        gYqwJ6P/1NsVWjPvc3fJuOM7g2aPL6PFCJ62J4yZTQBa9y4aXIGUi7pADY4pdX82mxdtFU
        LaHgChYWLVudXmkkJi6LiuR5yFj4CUQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-jj-fm0w7PLaycrRX7CwCAQ-1; Wed, 08 Jul 2020 05:48:27 -0400
X-MC-Unique: jj-fm0w7PLaycrRX7CwCAQ-1
Received: by mail-wm1-f71.google.com with SMTP id f68so3970943wmf.1
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 02:48:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s7qKIvefs+Nswt+yThb+00wqIjYx3wKhVFohWCds6UY=;
        b=TG7fBeHphNbtFAT9f7dFTBvcu5tJXPak2Zyhgi5BA7LQPIf7Y23EArjmyWDs+krJ+b
         xTHzz5GjCkO3UxS2BNq4o+SKaOAYFkVyFK+lgF/Bx4go0zgNxXYam9E/HFtP1RAUvHB0
         FelFVFz2onTBSBDKbzaRtqZx7ZGhXOQikoSt4NvEGcTobSTeqKtrsqJdL19qsvJF2obW
         y3lLE383knzYeD31NaBibl8GmZQXP+gVSRjBfzUGMfCgP1XXmUAYuSHZ9VVH518GR36Z
         SSIsA6ef+dvuurP4yDtl1H9XPE9KLXwbHadOOv4p9qTLn4a9/aPJm3K34EiWx3BKEW/0
         xpjA==
X-Gm-Message-State: AOAM533SDrpZmwmiqVjMpLSwjKSTySpPXfCtKo3zmc2lKszS4GlaZ1Pl
        rU1AmW4BmX1rdyRVMxOJcTlX0BTkLgMoaL+YR15UIFtX4Aaw76ulNWdO4NZFzRdrMNqKeMvY2va
        lpLXzZDEpmXPw
X-Received: by 2002:a1c:964d:: with SMTP id y74mr8764299wmd.80.1594201706341;
        Wed, 08 Jul 2020 02:48:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfj7LMLC/Cy4bxGx7mFvcgmL+5lgb9l1+cTx9oY+aTy0fSYGL5yHj313enjlCjUhgdghsXgg==
X-Received: by 2002:a1c:964d:: with SMTP id y74mr8764290wmd.80.1594201706166;
        Wed, 08 Jul 2020 02:48:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id q4sm4974931wmc.1.2020.07.08.02.48.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 02:48:25 -0700 (PDT)
Subject: Re: [PATCH 1/3 v4] KVM: x86: Create mask for guest CR4 reserved bits
 in kvm_update_cpuid()
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>, kvm@vger.kernel.org
References: <1594168797-29444-1-git-send-email-krish.sadhukhan@oracle.com>
 <1594168797-29444-2-git-send-email-krish.sadhukhan@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <bd3f1410-bd14-6791-0d3f-ce2ec329967a@redhat.com>
Date:   Wed, 8 Jul 2020 11:48:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <1594168797-29444-2-git-send-email-krish.sadhukhan@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/07/20 02:39, Krish Sadhukhan wrote:
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 88c593f..f0335bc 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -97,6 +97,7 @@
>  #endif
>  
>  static u64 __read_mostly cr4_reserved_bits = CR4_RESERVED_BITS;
> +u64 __guest_cr4_reserved_bits;
>  
>  #define KVM_X2APIC_API_VALID_FLAGS (KVM_X2APIC_API_USE_32BIT_IDS | \
>                                      KVM_X2APIC_API_DISABLE_BROADCAST_QUIRK)

Stray line.

Paolo

