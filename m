Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE4A375846
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 18:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbhEFQOI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 12:14:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235281AbhEFQOG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 May 2021 12:14:06 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55066C061574
        for <kvm@vger.kernel.org>; Thu,  6 May 2021 09:13:08 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id i14so5053976pgk.5
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 09:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pC08hOC2AN+wyK5mT1AdQmyJCQNj6SPdVWaqp3QAEAg=;
        b=VavpFO4sdqGbiT15AYtOAtQVcxe9b0IGKDipvgr5a/C+HFLmKIhSG9gCPQ0wzAT9D8
         pnepDUGhdDmWqe91ldWolYVkoEmCWAavFRK6F2B0ihLnLjD3Yu040DUd2Z/tMyWGyWj/
         duIGX2uqIFX4wtqWI0Lk4z1OoymowQZUSiewkBHaLqI8Xy4te1yeWt8n823TGnYohdfS
         bHC8EwuvYj6IVL4UcrdX+tRSFSGuW5GuqoBJ77d9RqfhvlzNAWhh8Gh79i+JrzF/q/EG
         kFASKvpNv7pO0ffLBF9EQ27YEiJ2JDWqDjopEg9sWNbKPQigMWqON8/dW1lEL7m4YLvn
         7/zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pC08hOC2AN+wyK5mT1AdQmyJCQNj6SPdVWaqp3QAEAg=;
        b=A32SkRujFw7BbeRoH7uPkCI1pCYNQUBx1nDLOSuZL/T7EMS7d6T2PdwZK74o3o2XiR
         eYv8+qISGpTPKWL6ibhmlUp3jEYgtptVMDJ9WmfofvJ19bl8IlQUsxWw9Xp13BoIl9EP
         BYjPoQ3yoE8yX/1qE3HA4M2P1EkSNhJSVw1SxwY+ynO5KxXa8mWqcCwI40FnStQV1wny
         SmdyBrJYfa/ZWDAsD9nP5kyKnPGkj7u/nkgBZ77bm2NQDnlGJ03d7srI2mB3rWFQP0CB
         E9kZ5C6ZLQy34BGm0w2nuxRV955K0nJ6i4RO7z6L1oe7xMMGJI4AVquHVKxgsIGnQOtt
         RkTw==
X-Gm-Message-State: AOAM530XqQojYwV3PDudZeLnvpOMDHox/bchHOlUmxUbLQ7CdlWHwLc0
        oQz+kw9ZL+x5swGrCYWJwUyfkQ==
X-Google-Smtp-Source: ABdhPJwatxlV+xfhhtH4nBHRMsVEoFU/nkaoLTy/GTPXvWvDJ8Q4h5fqvy+ymq2otmghJ543Ed+C1g==
X-Received: by 2002:a63:1903:: with SMTP id z3mr4998123pgl.185.1620317587643;
        Thu, 06 May 2021 09:13:07 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id g1sm2190963pgi.64.2021.05.06.09.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 09:13:06 -0700 (PDT)
Date:   Thu, 6 May 2021 16:13:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Venkatesh Srinivas <venkateshs@chromium.org>
Cc:     kvm@vger.kernel.org, dmatlack@google.com, pbonzini@redhat.com
Subject: Re: [PATCH] kvm: Cap halt polling at kvm->max_halt_poll_ns
Message-ID: <YJQVj3GaVp9tvWog@google.com>
References: <20210506152442.4010298-1-venkateshs@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210506152442.4010298-1-venkateshs@chromium.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Prefer capitalizing KVM in the shortlog, if only because I'm lazy with grep :-)

On Thu, May 06, 2021, Venkatesh Srinivas wrote:
> From: David Matlack <dmatlack@google.com>
> 
> When growing halt-polling, there is no check that the poll time exceeds
> the per-VM limit. It's possible for vcpu->halt_poll_ns to grow past
> kvm->max_halt_poll_ns and stay there until a halt which takes longer
> than kvm->halt_poll_ns.
> 

Fixes: acd05785e48c ("kvm: add capability for halt polling")

and probably Cc: stable@ too.


> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Venkatesh Srinivas <venkateshs@chromium.org>
> ---
>  virt/kvm/kvm_main.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 2799c6660cce..120817c5f271 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2893,8 +2893,8 @@ static void grow_halt_poll_ns(struct kvm_vcpu *vcpu)
>  	if (val < grow_start)
>  		val = grow_start;
>  
> -	if (val > halt_poll_ns)
> -		val = halt_poll_ns;
> +	if (val > vcpu->kvm->max_halt_poll_ns)
> +		val = vcpu->kvm->max_halt_poll_ns;

Hmm, I would argue that the introduction of the capability broke halt_poll_ns.
The halt_poll_ns module param is writable after KVM is loaded.  Prior to the
capability, that meant the admin could adjust the param on the fly and all vCPUs
would honor the new value as it was changed.

By snapshotting the module param at VM creation, those semantics were lost.
That's not necessarily wrong/bad, but I don't see anything in the changelog for
the capability that suggests killing the old behavior was intentional/desirable.

>  
>  	vcpu->halt_poll_ns = val;
>  out:
> -- 
> 2.31.1.607.g51e8a6a459-goog
> 
