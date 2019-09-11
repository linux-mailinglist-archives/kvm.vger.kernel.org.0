Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C66B0024
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2019 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbfIKPe3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Sep 2019 11:34:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46738 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728555AbfIKPe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Sep 2019 11:34:29 -0400
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 438A27E428
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 15:34:28 +0000 (UTC)
Received: by mail-wm1-f70.google.com with SMTP id f10so1388054wmh.8
        for <kvm@vger.kernel.org>; Wed, 11 Sep 2019 08:34:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=doOgwhqpGJ6h2kDCt8VV25zYE+uHv9a72Mxi7Wlmd0E=;
        b=MZnS2qhSV9YdnRGf+XLj27znUOL1pjUzN7xcF2Uk1aGZo9p7vDUPrMOqeUCC/qyVx8
         caXMYc2BjYTWgAxkH/5pvxIsnJ1y3Og6JmGxQ1VRaB/XGiRnMnPvLKF5sp7psvQrpdxp
         bRx6kaxAQdfurgQwLmkJ5vOaOTLLTNgkWbg3vbFk0Ar60nyhAa9yXCtlKPvVNAMy3YYM
         C/PrYgA5WYpDr2VyxAW0WnWRNGVgdbTkX7Jb8I6P4CTPdqUfNhTmjmT7pTgxprkvXLbD
         Jq/fo0MQ47DFmFDyxlWWaOtJ9LIURYVmT1CXGKk8qpbJtPEea0oo1Tnus9pHFFlY5BgG
         Pekw==
X-Gm-Message-State: APjAAAWsX+Cx59sfMl6p1IcCClq9Wdwp0uRSe6yx7VKQrHmOaRsuGNIk
        eCju52Ef5wYsTlXZrrvQpVYEctQ1x/i0JC732dwW0M4KA43woAKoV59cDrDCA75GpuZWawXCsxK
        cW/yyjMXJC3CC
X-Received: by 2002:a1c:7406:: with SMTP id p6mr4392504wmc.30.1568216066804;
        Wed, 11 Sep 2019 08:34:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzNPAY5Ask35xXOydsH2uP+v4bBIL3vHASVSD3rPvWjqEPhzVpPf81scJaZWc5yvPe7FBEjYA==
X-Received: by 2002:a1c:7406:: with SMTP id p6mr4392482wmc.30.1568216066530;
        Wed, 11 Sep 2019 08:34:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:102b:3795:6714:7df6? ([2001:b07:6468:f312:102b:3795:6714:7df6])
        by smtp.gmail.com with ESMTPSA id i26sm2911551wmd.37.2019.09.11.08.34.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Sep 2019 08:34:25 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] KVM: nVMX: add tracepoints for nested VM-Enter
 failures
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org
References: <20190711155830.15178-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <7745e928-da33-fcee-0c26-63862675ec71@redhat.com>
Date:   Wed, 11 Sep 2019 17:34:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190711155830.15178-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/07/19 17:58, Sean Christopherson wrote:
> Debugging VM-Enter failures has been the bane of my existence for years.
> Seeing KVM's VMCS dump format pop up on a console triggers a Pavlovian
> response of swear words and sighs.  As KVM's coverage of VM-Enter checks
> improve, so too do the odds of being able to triage/debug a KVM (or any
> other hypervisor) bug by running the bad KVM build as an L1 guest.
> 
> Improve support for using KVM to debug a buggy VMM by adding tracepoints
> to capture the basic gist of a VM-Enter failure so that extracting said
> information from KVM doesn't require attaching a debugger or modifying
> L0 KVM to manually log failures.
> 
> The captured information is by no means complete or perfect, e.g. I'd
> love to capture *exactly* why a consistency check failed, but logging
> that level of detail would require invasive code changes and might even
> act as a deterrent to adding more checks in KVM.
> 
> v3: Fix a minor snafu in the v2 rebase, and re-rebase to kvm/next
>     (a45ff5994c9c, "Merge tag 'kvm-arm-for-5.3'...")
> 
> v2: Rebase to kvm/queue.
> 
> Sean Christopherson (2):
>   KVM: nVMX: add tracepoint for failed nested VM-Enter
>   KVM: nVMX: trace nested VM-Enter failures detected by H/W
> 
>  arch/x86/include/asm/vmx.h |  14 ++
>  arch/x86/kvm/trace.h       |  22 +++
>  arch/x86/kvm/vmx/nested.c  | 269 ++++++++++++++++++++-----------------
>  arch/x86/kvm/x86.c         |   1 +
>  4 files changed, 179 insertions(+), 127 deletions(-)
> 

Queued, thanks.

Paolo
