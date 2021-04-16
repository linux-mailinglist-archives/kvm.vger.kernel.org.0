Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37696361BE2
	for <lists+kvm@lfdr.de>; Fri, 16 Apr 2021 11:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239038AbhDPIkl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Apr 2021 04:40:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56121 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236538AbhDPIkj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Apr 2021 04:40:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618562415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E/21KtrUJDrIPwXoawNEtFcajhDHUfFH4h+ED/BPh0I=;
        b=VVK1Qu+j2n1Qavq9i6cWb2qbytZFCE1y64zdFyu9vZlEFRWcJuYEqY/1Rk0LypUwifiGX+
        K6v18a2aXFx8MVChuXtuxwO8FaDwJpM6mpeSUD1QkvyiD9ECpmaqTlGbscjIzh/7Fe2bxv
        7VkujnV7lNc8JzrSgHMKzWfU13z/97A=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-224-utcNFdFuPaSNkhK9H20LAw-1; Fri, 16 Apr 2021 04:40:11 -0400
X-MC-Unique: utcNFdFuPaSNkhK9H20LAw-1
Received: by mail-ed1-f72.google.com with SMTP id b9-20020a05640202c9b029038276b571ddso6618945edx.11
        for <kvm@vger.kernel.org>; Fri, 16 Apr 2021 01:40:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/21KtrUJDrIPwXoawNEtFcajhDHUfFH4h+ED/BPh0I=;
        b=pbfQgW722X5fnXoD05WKAynyjNXMGKKBT8HCJRGowOUVArk9rlonWKMNQTS/PSuUwm
         WV7enEyH8GLLs0Ewhl0K5hHImAPWq6AAhGxxN9vGX+Wg9lepR5InXMq6JJxc/jxEHOp8
         m0Jh64O+pDkhfhHvjD/xZYuOs3Mztb8wsLWC8jgyeFYbMbJc/+RwXpaLtjtyOSdo+Eyt
         d6u4JIBS7wDtt4IcB/OQg2NZ6pzBMB2D3TCOhEGqMZIjtUKeKTBhKCSU2qGIPBve2FH1
         EAbNKR92B0Ty7x3U4Xg1MleOfbyreIbSVyh6ExeUBSNwYGIc3zFMCLp6uV6xVVjLjCHH
         zNAw==
X-Gm-Message-State: AOAM531cM/JRiuX7ewOUkuRKh9B8pIeTGnluzdjZEoOXqNjVp7dvpCkx
        /pD6iuXF+KUdueqxVOVxHlEMn+DUuXATuAVVN/Z3ROXYkuGAEgJOuRCwiyIPphd2IFjCV12PSqQ
        oHZgyOuJS/9SH
X-Received: by 2002:a17:906:2596:: with SMTP id m22mr7477027ejb.175.1618562410231;
        Fri, 16 Apr 2021 01:40:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyzNJnhs14GfiKHmwxiwSXkMkIYSx3t9HmyGiPAFsuoDS423ZgZVJAbSWmQrlHtBpNbXS2xKA==
X-Received: by 2002:a17:906:2596:: with SMTP id m22mr7477008ejb.175.1618562410070;
        Fri, 16 Apr 2021 01:40:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id b14sm4764203edx.39.2021.04.16.01.40.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 01:40:09 -0700 (PDT)
Subject: Re: [PATCH v2 3/7] KVM: x86: hyper-v: Move the remote TLB flush logic
 out of vmx
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vineeth Pillai <viremana@linux.microsoft.com>
Cc:     "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "K. Y. Srinivasan" <kys@microsoft.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hyperv@vger.kernel.org,
        Lan Tianyu <Tianyu.Lan@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, Wei Liu <wei.liu@kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
References: <cover.1618492553.git.viremana@linux.microsoft.com>
 <92207433d0784e123347caaa955c04fbec51eaa7.1618492553.git.viremana@linux.microsoft.com>
 <87y2di7hiz.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <8a83b571-5c19-603e-193f-666b99a96461@redhat.com>
Date:   Fri, 16 Apr 2021 10:40:07 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <87y2di7hiz.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/04/21 10:36, Vitaly Kuznetsov wrote:
> - Create a dedicated set of files, e.g. 'kvmonhyperv.[ch]' (I also
> thought about 'hyperv_host.[ch]' but then I realized it's equally
> misleading as one can read this as 'KVM is acting as Hyper-V host').
> 
> Personally, I'd vote for the later. Besides eliminating confusion, the
> benefit of having dedicated files is that we can avoid compiling them
> completely when !IS_ENABLED(CONFIG_HYPERV) (#ifdefs in C are ugly).

Indeed.  For the file, kvm-on-hv.[ch] can do.

Paolo

