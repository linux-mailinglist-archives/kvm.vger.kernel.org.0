Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 238F2446538
	for <lists+kvm@lfdr.de>; Fri,  5 Nov 2021 15:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbhKEOwn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 Nov 2021 10:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbhKEOwm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 Nov 2021 10:52:42 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 791EAC061714
        for <kvm@vger.kernel.org>; Fri,  5 Nov 2021 07:50:02 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id k2so9050715pff.11
        for <kvm@vger.kernel.org>; Fri, 05 Nov 2021 07:50:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZlK7YTT985O4M+opuoeF3giYxNoBTymwdWlIEsVVWuA=;
        b=ShJBqpgpg6+unQtvJMrQ8Fhfuh8RSFlYfOI4A0mlmDFM6ugOfGg3IQLd+q9qcWRnso
         iNzLK3UyTPJ71KvYGe6BZBTvH0SEXptWx01FRS2yFQYl4KcBZ+k6Dk51ZfJKjnFKaAmN
         /fmi+llUzQBKl6jDjhfzpzDwYW41NxGNPzpAN6jV/pbbDX5gEasvr+F1LYQyNrETVLXp
         mvs43Y7m/in2ATV7c3ZNMf5qLZAcvQJa6B/jj5OnKXHqhzx9lcYXPJbJe8V7SSeoPT+z
         HcupYq++82NTKY+KiQr+htPcYxN6s2jIS/ur749qRJr9ILPaMsamtK5wybH1QE2qqe8l
         3BOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZlK7YTT985O4M+opuoeF3giYxNoBTymwdWlIEsVVWuA=;
        b=FRq9ChwCy/sn+pS9pOxkFYEmNKuWTTCPdLakGVQ3uiAfMY+ZTqkdV/Q8ptINYTz1dv
         EOrTGBVYBC3rVkBUvLg90KJ/v1vk/bXq22gTnNZSybR7HGok88FObaoQdRTLUFKMaZnU
         OTJA/DpdVGLZSkaAl1mqfPplP5gE+67wvqt/Ks8V4FNjpoLOvG36GdXpJ7NCPgL9NzsF
         6UhCJFa0meED5jETwoZgagesX3O1cVg4ZlgATmrpBiVJArmOFIn/j0v9Wa6gwzRt2U4m
         FKtFbUKnMdGJCN0r01KFU25bySGjYamaJv749loe8KI7YeCs/7kw6N4K/yo7ZT8Fta8v
         yYsQ==
X-Gm-Message-State: AOAM530qIy5yIhTDP0qZ8eN0lGwJOUfsbxOwedqyvTw8oeRFBobzsQ24
        ydxAsnRAHOvaxEQv3D+RNalu9A==
X-Google-Smtp-Source: ABdhPJz9IWo1xPiB6N2+RPTVp6A5NpQUzdaQiipdBeFMIU2yLkoLwsxHBecmtwNqfmGtNyxHhoUidQ==
X-Received: by 2002:a63:8ac2:: with SMTP id y185mr30739749pgd.205.1636123801792;
        Fri, 05 Nov 2021 07:50:01 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id b2sm6333032pgh.33.2021.11.05.07.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Nov 2021 07:50:00 -0700 (PDT)
Date:   Fri, 5 Nov 2021 14:49:57 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH] KVM: move struct kvm_vcpu * array to the bottom of
 struct kvm
Message-ID: <YYVElU6u22qxgQIz@google.com>
References: <20211105034949.1397997-1-npiggin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211105034949.1397997-1-npiggin@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Juergen and Marc

On Fri, Nov 05, 2021, Nicholas Piggin wrote:
> Increasing the max VCPUs on powerpc makes the kvm_arch member offset
> great enough that some assembly breaks due to addressing constants
> overflowing field widths.
> 
> Moving the vcpus array to the end of struct kvm prevents this from
> happening. It has the side benefit that moving the large array out
> from the middle of the structure should help keep other commonly
> accessed fields in the same or adjacent cache lines.
> 
> Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
> ---
> 
> It would next be possible to now make this a dynamically sized array,
> and make the KVM_MAX_VCPUS more dynamic

Marc has a mostly-baked series to use an xarray[1][2] that AFAICT would be well
received.  That has my vote, assuming it can get into 5.16.  Marc or Juergen,
are either of you actively working on that?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git/log/?h=kvm-arm64/vcpu-xarray
[2] https://lkml.kernel.org/r/871r65wwk7.wl-maz@kernel.org

> however x86 kvm_svm uses its own scheme rather than kvm_arch for some reason.

What's the problem in kvm_svm?

> Thanks,
> Nick
> 
>  include/linux/kvm_host.h | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0f18df7fe874..78cd9b63a6a5 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -553,7 +553,6 @@ struct kvm {
>  	struct mutex slots_arch_lock;
>  	struct mm_struct *mm; /* userspace tied to this vm */
>  	struct kvm_memslots __rcu *memslots[KVM_ADDRESS_SPACE_NUM];
> -	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>  
>  	/* Used to wait for completion of MMU notifiers.  */
>  	spinlock_t mn_invalidate_lock;
> @@ -623,6 +622,9 @@ struct kvm {
>  	struct notifier_block pm_notifier;
>  #endif
>  	char stats_id[KVM_STATS_NAME_SIZE];
> +
> +	/* This array can be very large, so keep it at the bottom */
> +	struct kvm_vcpu *vcpus[KVM_MAX_VCPUS];
>  };
>  
>  #define kvm_err(fmt, ...) \
> -- 
> 2.23.0
> 
