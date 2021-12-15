Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96A5B475E78
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 18:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245240AbhLORUi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Dec 2021 12:20:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245248AbhLORUh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Dec 2021 12:20:37 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B89C06173E;
        Wed, 15 Dec 2021 09:20:37 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id az34-20020a05600c602200b0033bf8662572so16474548wmb.0;
        Wed, 15 Dec 2021 09:20:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gBnmKSGLNuMvymhhy5hZJRhuWEJ7BIugf8vR/bIuOqM=;
        b=KCLZaZDQQvg018ER4RJ25YN2zuBW58lZWc7tx1pn54BQ/20m/VK0Ijoz1tOwebSdBx
         61/TRUIdYuw7flDNY3/SJCmbW67ZvpJORo3h16tmnm57ZJZCnRVebHhMb98aFx7DRz/P
         pmbJRHpRfkyz5USGQHyhHRsyoHyFNmfgEv2pVfsUuGSmhPF2vMqwNo31YgulJdBfqMB6
         qAzMVustltXloIf1FsU/KgxEPNX66be95DgH9/Y3+oPPqOIYsnED574cOm75t0TMvS8F
         goDrf+aIt8x3oZyChAFBAgD9x2qO6TDvxWzQ2PYMqjWghPSDXFd6mC/wkFddawMfyNaI
         kEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gBnmKSGLNuMvymhhy5hZJRhuWEJ7BIugf8vR/bIuOqM=;
        b=OrwHLjcxpxSlp4XW/v1WmfKZ34dTtSiqGLWv4fy7xMjX3p3oWz/6qAAJDXAL094s1X
         SkwWoh+Ha9nEhh96jeoOs8w/0ylIlVDg/adEI+rXCLiPeKZurQTmuphTVNPZeLmshyPN
         gmjkuvvuT8SB7u5Z+YCcMEd/xNe0WCLuaXW7qFvEv0vQ6mYy2kZGLxM+7RzuP2AkuW69
         BVhOpMclMETR+T/253dVjD4IVEJ6pw9fL/DEf+Sj1VMZDgPIqT+HhmjmIy2fvxxdRWQh
         WHPlGMQTzO2Hvo997MS7y30U6qZHzLCHMARzSzMpEgcfhW8ijV505cpoCZhat+9UFwn/
         f05A==
X-Gm-Message-State: AOAM532S7jP6HwBofhNFIA9+gYAGlbGhKzPktOYxWI60oj41iQnDklEn
        zuxjrU+Wqn7ljXxpfFvbg8g=
X-Google-Smtp-Source: ABdhPJwojD9YKCPuESlm+kt+n4P3cUJuGJ1Uccelxcnq8snmgdS+pH9okyrfRk3HN7t/yeFBxs6XXg==
X-Received: by 2002:a05:600c:1f17:: with SMTP id bd23mr913120wmb.57.1639588835923;
        Wed, 15 Dec 2021 09:20:35 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id d2sm2535828wra.61.2021.12.15.09.20.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Dec 2021 09:20:35 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <b4295e77-aaf1-f0f5-cfd5-2a4fda923fb4@redhat.com>
Date:   Wed, 15 Dec 2021 18:20:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/4] KVM: x86/mmu: Zap invalid TDP MMU roots when
 unmapping
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20211215011557.399940-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211215011557.399940-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/15/21 02:15, Sean Christopherson wrote:
> Patches 01-03 implement a bug fix by ensuring KVM zaps both valid and
> invalid roots when unmapping a gfn range (including the magic "all" range).
> Failure to zap invalid roots means KVM doesn't honor the mmu_notifier's
> requirement that all references are dropped.
> 
> set_nx_huge_pages() is the most blatant offender, as it doesn't elevate
> mm_users and so a VM's entire mm can be released, but the same underlying
> bug exists for any "unmap" command from the mmu_notifier in combination
> with a memslot update.  E.g. if KVM is deleting a memslot, and a
> mmu_notifier hook acquires mmu_lock while it's dropped by
> kvm_mmu_zap_all_fast(), the mmu_notifier hook will see the to-be-deleted
> memslot but won't zap entries from the invalid roots.
> 
> Patch 04 is cleanup to reuse the common iterator for walking _only_
> invalid roots.
> 
> Sean Christopherson (4):
>    KVM: x86/mmu: Use common TDP MMU zap helper for MMU notifier unmap
>      hook
>    KVM: x86/mmu: Move "invalid" check out of kvm_tdp_mmu_get_root()
>    KVM: x86/mmu: Zap _all_ roots when unmapping gfn range in TDP MMU
>    KVM: x86/mmu: Use common iterator for walking invalid TDP MMU roots
> 
>   arch/x86/kvm/mmu/tdp_mmu.c | 116 +++++++++++++++++--------------------
>   arch/x86/kvm/mmu/tdp_mmu.h |   3 -
>   2 files changed, 53 insertions(+), 66 deletions(-)
> 

Queued 1-3 for 5.16 and 4 for 5.17.

Paolo
