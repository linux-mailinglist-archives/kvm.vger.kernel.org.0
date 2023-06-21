Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4395B73887F
	for <lists+kvm@lfdr.de>; Wed, 21 Jun 2023 17:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbjFUPLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Jun 2023 11:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233165AbjFUPKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Jun 2023 11:10:55 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469F5212E
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 08:06:17 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id 5614622812f47-3a0423ea749so1008374b6e.0
        for <kvm@vger.kernel.org>; Wed, 21 Jun 2023 08:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1687359976; x=1689951976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i8mvm0Ua7VheRBgm3SyS2f+CUs+ip4U1HTEOUVIIBZg=;
        b=HeF1k6bjWFVW0gS1DrVZ7s5steRsGaEzzCs8cnUdWlatT2bkDGzEeLpNR3LkgWjlpq
         p8HL6SDTUDdeVvXm/6cwQSYiMFo2ig6zdYWYZYRvcIt2OdonMAxt6whMEOgcmqg7p0BF
         dPU6Z0XeeHzgXZA77Wy350iWlPXC/mrJ8FHlhhSWLKa6+lBZeHznH//y9z4bAY3LGV0j
         zqvGppwU1sAIn/juqALMn/DhUwL6ZEkKrFnYtinNlAhJCmQGQR3Y1kWid35u5o7SNQd+
         RVdAghyucYBDYSFRI+E/A+VSJknTFyRKCufCH+0LtDTFImNCr4Kq/m4V+SxH4tzdMDdM
         dZCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687359976; x=1689951976;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i8mvm0Ua7VheRBgm3SyS2f+CUs+ip4U1HTEOUVIIBZg=;
        b=TRFcpJCp+ZeZAfw6WqlV8pqKGQSLjCssD30u3hxLUFRpJsYWbaBObaG4AaKRPFl3TX
         3W/a5Ps0WDRXjf2qdTKTT9VX/kgU/QzCIQQDlO8plG1VbYLLpEAvEtlyAjSspt8FgTnp
         9Khh0NzcEJGpO6vf2BFMyTHyqEnslZ4gWRZ/hFw4nSlFu0Y/VX6oBikKLUMysohyyNQQ
         DrgzSdUKGLm0qvtpDEVbswWRP8HGH3YnfaImmwIYdMPrnVzZ1fsdc9cwCtvknpbD5SDg
         4/Nvay6fns8Sho4S0mAbTWxT9QICFNcmuof8Fy7UZkIJOA8FrZNcNOfSdba3gVVG3ArC
         J5Mw==
X-Gm-Message-State: AC+VfDwb522xOyx2HEdTigeVWaJaWHQYEJvs9jDIVpSvIGMrXPBwrPlo
        bpE+u+o5+x462Yt+vUYbSGSzrDsCmBqKqZzVlSQ=
X-Google-Smtp-Source: ACHHUZ636NWZSijMUe4oI3fgGZIHT/qTk8OtX3ic1/cT2sn7NBvatb98BNnqEYBTRAhrHhPIPOOMUg==
X-Received: by 2002:a05:6808:1814:b0:39b:f558:8cab with SMTP id bh20-20020a056808181400b0039bf5588cabmr19969218oib.26.1687359976039;
        Wed, 21 Jun 2023 08:06:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id gl12-20020a17090b120c00b0025e7f7b46c3sm9142110pjb.25.2023.06.21.08.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 08:06:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1qBzPR-007dQ6-Os;
        Wed, 21 Jun 2023 12:06:13 -0300
Date:   Wed, 21 Jun 2023 12:06:13 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Alistair Popple <apopple@nvidia.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Robin Murphy <robin.murphy@arm.com>, will@kernel.org,
        catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
        nicolinc@nvidia.com, linux-arm-kernel@lists.infradead.org,
        kvm@vger.kernel.org, John Hubbard <jhubbard@nvidia.com>,
        zhi.wang.linux@gmail.com, Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH 0/2] Invalidate secondary IOMMU TLB on permission
 upgrade
Message-ID: <ZJMR5bw8l+BbzdJ7@ziepe.ca>
References: <cover.063f3dc2100ae7cbe3a6527689589646ea787216.1687259597.git-series.apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.063f3dc2100ae7cbe3a6527689589646ea787216.1687259597.git-series.apopple@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 20, 2023 at 09:18:24PM +1000, Alistair Popple wrote:

> 1. Add a call to mmu_notifier_invalidate_secondary_tlbs() to the arm64
>    version of ptep_set_access_flags().

I prefer we modify the whole thing to only call
mmu_notifier_arch_invalidate_secondary_tlbs() (note the arch in the
name) directly beside the arch's existing tlb invalidation, and we
only need to define this for x86 and ARM arches that have secondary
TLB using drivers - eg it is very much not a generic general purpose
mmu notifier that has any meaning outside arch code.

> This is what this RFC series does as it is the simplest
> solution. Arguably this call should be made by generic kernel code
> though to catch other platforms that need it.

But that is the whole point, the generic kernel cannot and does not
know the rules for TLB invalidation the platform model requires.

> It is unclear if mmu_notifier_invalidate_secondary_tlbs() should be
> called from mmu_notifier_range_end(). Currently it is, as an analysis
> of existing code shows most code doesn't explicitly invalidate
> secondary TLBs and relies on it being called as part of the end()
> call.

If you do the above we don't need to answer this question. Calling it
unconditionally at the arches tlbi points is always correct.

> To solve that we could add secondary TLB invalidation calls to the TLB
> batching code, but that adds complexity so I'm not sure it's worth it
> but would appreciate feedback.

It sounds like the right direction to me.. Batching is going to be
important, we don't need to different verions of batching logic. We
already call the notifier from the batch infrastructure anyhow.

This still fits with the above as batching goes down to the arch's
flush_tlb_range()/etc which can carry the batch to the notifier. We
can decide if we leave the notifier call in the core code and let the
arch elide it or push it to the arch so it the call is more
consistently placed.

eg we have arch_tlbbatch_flush() on x86 too that looks kind of
suspicious that is already really funky to figure out where the
notifier is actually called from. Calling from arch code closer to the
actual TLB flush would be alot easier to reason about.

Jason
