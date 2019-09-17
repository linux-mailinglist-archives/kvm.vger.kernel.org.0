Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB29B4F5B
	for <lists+kvm@lfdr.de>; Tue, 17 Sep 2019 15:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728433AbfIQNd5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Sep 2019 09:33:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45948 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726131AbfIQNd4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 17 Sep 2019 09:33:56 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 06E5E5945E
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 13:33:56 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id z1so1310405wrw.21
        for <kvm@vger.kernel.org>; Tue, 17 Sep 2019 06:33:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=40YR/NqB5wwWzIKovyeLWwFjAHh78u21LsyykmnxUSs=;
        b=DZUJbBPV9b4b6HNFdxF1W0cK7HnKxRINDAILk/GYRL7LVdkhilfm/B62Dhb7X3HpJi
         cm84yWCGKCDVDe7ndYHD73tR2Pp2b4WmFJU69GQvRBUtp6vs48896TNSLIM6mldmftME
         ijDwsMPa1W9ZzL4SgK+KK1kAm3IKEru5XzU+E6D+vmLoDy/GiwsZ7RdP3byEnHzFx/GJ
         lvTE4rGvMggkU4R7zEFPfzrIoNTBcBKXr3pALzJ2kXSkT+85CYG4fmBbJVVeqwHM/PTI
         yxJC9bx6YNE3xMQx/ywFedIITI5JLSu+O9aQfn+csZOX1qky5FXpH1dLyjzA7PzcAeTV
         Gi5Q==
X-Gm-Message-State: APjAAAXF35nB5eZ9U3sZM5L+KuxcKSeMBPVoXKDz8++BfNL/k5AUUKRD
        1bFAfnNgaJrvi2Fe9HSWQ1xg8t0ws2k5w5nxtXz3FmtQhg5IW8TDWM0jwr+F5ezKgoG3XNzavhL
        UOK3va+c4Pyln
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr3628130wmj.57.1568727234524;
        Tue, 17 Sep 2019 06:33:54 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzsUMFxBPdGRNMeEL6QFpBx/vUdORE51BaSjWK6NJei9RZcM21gbeW4FWTgRxldB18oQF1f3A==
X-Received: by 2002:a1c:23d7:: with SMTP id j206mr3628104wmj.57.1568727234251;
        Tue, 17 Sep 2019 06:33:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c46c:2acb:d8d2:21d8? ([2001:b07:6468:f312:c46c:2acb:d8d2:21d8])
        by smtp.gmail.com with ESMTPSA id b184sm3823721wmg.47.2019.09.17.06.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 06:33:53 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Manually flush collapsible SPTEs only when
 toggling flags
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190911191952.31126-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <47331a39-7f74-661c-b248-266eec420efa@redhat.com>
Date:   Tue, 17 Sep 2019 15:33:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190911191952.31126-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/09/19 21:19, Sean Christopherson wrote:
> Zapping collapsible sptes, a.k.a. 4k sptes that can be promoted into a
> large page, is only necessary when changing only the dirty logging flag
> of a memory region.  If the memslot is also being moved, then all sptes
> for the memslot are zapped when it is invalidated.  When a memslot is
> being created, it is impossible for there to be existing dirty mappings,
> e.g. KVM can have MMIO sptes, but not present, and thus dirty, sptes.
> 
> Note, the comment and logic are shamelessly borrowed from MIPS's version
> of kvm_arch_commit_memory_region().
> 
> Fixes: 3ea3b7fa9af06 ("kvm: mmu: lazy collapse small sptes into large sptes")
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/x86/kvm/x86.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b4cfd786d0b6..70e82e8f5c41 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -9635,8 +9635,13 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>  	 * Scan sptes if dirty logging has been stopped, dropping those
>  	 * which can be collapsed into a single large-page spte.  Later
>  	 * page faults will create the large-page sptes.
> +	 *
> +	 * There is no need to do this in any of the following cases:
> +	 * CREATE:	No dirty mappings will already exist.
> +	 * MOVE/DELETE:	The old mappings will already have been cleaned up by
> +	 *		kvm_arch_flush_shadow_memslot()
>  	 */
> -	if ((change != KVM_MR_DELETE) &&
> +	if (change == KVM_MR_FLAGS_ONLY &&
>  		(old->flags & KVM_MEM_LOG_DIRTY_PAGES) &&
>  		!(new->flags & KVM_MEM_LOG_DIRTY_PAGES))
>  		kvm_mmu_zap_collapsible_sptes(kvm, new);
> 

Queued, thanks.

Paolo
