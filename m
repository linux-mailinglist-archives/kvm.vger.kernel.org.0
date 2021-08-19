Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3313F1247
	for <lists+kvm@lfdr.de>; Thu, 19 Aug 2021 06:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhHSEQF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Aug 2021 00:16:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbhHSEQE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Aug 2021 00:16:04 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2715EC0613CF
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 21:15:29 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id n12so3175372plf.4
        for <kvm@vger.kernel.org>; Wed, 18 Aug 2021 21:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :in-reply-to;
        bh=w221Be1EofjnjmiRhYveteUIPXXfoWBMfLJIKwhzc6c=;
        b=fhEA6xLbFlhjCuprHe1t9zZjCHnVtAM2fFfth+B1eUBRu6EInah6dTHDMDKwsz0mV1
         65BqyoyCpNPZLSPi8XCLuuOA1+WEfawyX/VoKt1E6KGHsSqmRqLH0CYhis0m0bEyFhm6
         GxHz9MjLC+9q453UuBgVTOwQGhg8cEVz5iusw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:in-reply-to;
        bh=w221Be1EofjnjmiRhYveteUIPXXfoWBMfLJIKwhzc6c=;
        b=s0ZCQE9EfvbUg01xPzKrwV51ODuMFHQE6A3UwQcxmW7RiB3dPHYMZREHJgbferq0Uq
         Va4+6wgodsY/yNrKrTVtvua8PmwvC7R451ypVy67P/cItwPJQoKseHDeN39sXiGsKbau
         H04uouMvOGpFRTEUcozdLSFsc5p4cs6HYFpXpuSIPkA2TB82pHsDyWE25F22nvfuyJhj
         NF0i21wzkJfK6HeJRy6GqaB35Wkhkg6PEncRe/gM1BG1AN0OXwizo8wLY9x/v1WB7vcT
         EUmOAPlL8K3JcPZCCSnDq68eJ5MBP8lYZ0wuXA9GxT08u/oQJPblLWpHUCiOlqcbTdLO
         Q4dg==
X-Gm-Message-State: AOAM530ydC8RHJ/bjPcNUDtDmy8nybGNoEmILrIEku7v8tXOg9aqB1iH
        NbMHuRV6j1UczkX0+5EXzcMM4A==
X-Google-Smtp-Source: ABdhPJzUBrbcAUKyLF8ssbZuxfEH/VxtoJMLhDuWpgrTCiufrvnOHyomjO1vi21CQR+W587Vz3n2AQ==
X-Received: by 2002:a17:902:f703:b029:12c:982:c9ae with SMTP id h3-20020a170902f703b029012c0982c9aemr10078207plo.20.1629346528626;
        Wed, 18 Aug 2021 21:15:28 -0700 (PDT)
Received: from google.com ([2409:10:2e40:5100:bc71:80fb:7292:eb8e])
        by smtp.gmail.com with ESMTPSA id 141sm1421497pfv.15.2021.08.18.21.15.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 21:15:28 -0700 (PDT)
Date:   Thu, 19 Aug 2021 13:15:23 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <senozhatsky@google.com>,
        Ben Gardon <bgardon@google.com>
Subject: Re: [PATCH] KVM: x86/mmu: Complete prefetch for trailing SPTEs for
 direct, legacy MMU
Message-ID: <YR3a21l6TC/gmw3/@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210818235615.2047588-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[..]

> Make a final call to direct_pte_prefetch_many() if there are "trailing"
> SPTEs to prefetch, i.e. SPTEs for GFNs following the faulting GFN.  The
> call to direct_pte_prefetch_many() in the loop only handles the case
> where there are !PRESENT SPTEs preceding a PRESENT SPTE.
> 
> E.g. if the faulting GFN is a multiple of 8 (the prefetch size) and all
> SPTEs for the following GFNs are !PRESENT, the loop will terminate with
> "start = sptep+1" and not prefetch any SPTEs.
> 
> Prefetching trailing SPTEs as intended can drastically reduce the number
> of guest page faults, e.g. accessing the first byte of every 4kb page in
> a 6gb chunk of virtual memory, in a VM with 8gb of preallocated memory,
> the number of pf_fixed events observed in L0 drops from ~1.75M to <0.27M.
> 
> Note, this only affects memory that is backed by 4kb pages as KVM doesn't
> prefetch when installing hugepages.  Shadow paging prefetching is not
> affected as it does not batch the prefetches due to the need to process
> the corresponding guest PTE.  The TDP MMU is not affected because it
> doesn't have prefetching, yet...


Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>



I ran some tests.


- VM Boot up

From

EPT_VIOLATION    1192184    75.18%     4.40%      0.77us  18020.01us      4.32us ( +-   1.71% )

to

EPT_VIOLATION     947460    69.92%     4.64%      0.69us  34902.15us      5.06us ( +-   1.64% )



- Running test app (in VM)

From

EPT_VIOLATION    6550167    71.05%    11.76%      0.77us  32562.18us      3.51us ( +-   0.36% )

to

EPT_VIOLATION    5489904    68.32%    11.29%      0.71us  16564.19us      3.92us ( +-   0.29% )
