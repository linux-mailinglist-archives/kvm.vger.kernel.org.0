Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39841789248
	for <lists+kvm@lfdr.de>; Sat, 26 Aug 2023 01:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjHYXRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Aug 2023 19:17:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231249AbjHYXRU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Aug 2023 19:17:20 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BCC2129
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 16:17:11 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d74829dd58fso1827592276.1
        for <kvm@vger.kernel.org>; Fri, 25 Aug 2023 16:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693005431; x=1693610231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IbA16e4G5FTrEyMeWKj8UXENnQA5tEiZF2o6wpVFWAU=;
        b=thv0HRAWuOFftasB16yDDl3uAPY9b/6f559qheYS39Vin0ldCLBOm9TytR75fPnHwS
         hgw6yLwxviL95z7V8ENoLLLiyBOPpoO3JmalTMAFuQeCXbwGT/cr7mMbNhjmr9fZCwt/
         rOgwb2f41MmlkyLyrua2Fpbxrjmg1RPRwjlhTLHQahs8M7eGLe9x7pnGMmH1pqbShlA4
         v+pD8MH2FbC8A5MrFfqimysQJwLMF6xsV32nrBuj/xve+niPujxhadsqCgZSIZTuQ+vk
         Iedeud8IqCtHnBax1ms32mQmqrfFY/XLLH1QNoS3zgltqJOdprJk9uNZ9BtvWNFUW3wx
         wlsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693005431; x=1693610231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IbA16e4G5FTrEyMeWKj8UXENnQA5tEiZF2o6wpVFWAU=;
        b=dTCBGf6gulkUh0jx6mQIV2jjxkXrSG/N7QbFzatb03biElETwN5cX5ODLqq2nrHyQZ
         5qqyxwVgWQ0MJ6MzqVNBI6jxkoIRcl9qRm5F96eMDLAD/ugpM+sks87yJQWRNjpThJj1
         Ir4zFOJCw6E7rN+kzg93EXY4mf2H1ZOKqpu+DDItAwa5g7PgJalkQimgROUeddAvwO4S
         d+pMHKNeNiT2MP/9iJVnKjU8gWhLg8ooilNV9IDxLjWqkLu+aUH+qspKr4EmGG2GtO1L
         VBmtj/0Bu0DpU+IhAJOU4Y/I5LOTLBT3DP5B9WbiqI8JZvK0EBPm7cbIaHZnseRDHrQl
         b3YQ==
X-Gm-Message-State: AOJu0YzV4OKGaYtqpVYf+2KV8sIsjLQhX5G4KmztUwMSUxtGSocpl0Xi
        oKegRI7w8P2A/lz26BePS6hAnLtAgMU=
X-Google-Smtp-Source: AGHT+IFTiUVRDswF1MCfPVgkxj0gqCmd6KaPLl8CBqEY/4jKQt6W6PXso8zzm5KnsMxtD2+p2IzF0da1OQc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:106:b0:d77:984e:c770 with SMTP id
 o6-20020a056902010600b00d77984ec770mr425695ybh.5.1693005431047; Fri, 25 Aug
 2023 16:17:11 -0700 (PDT)
Date:   Fri, 25 Aug 2023 16:17:09 -0700
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
Message-ID: <ZOk2dSCdc693YOKe@google.com>
Subject: Re: [PATCH v4 00/12] KVM: x86/mmu: refine memtype related mmu zap
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023, Yan Zhao wrote:
> This series refines mmu zap caused by EPT memory type update when guest
> MTRRs are honored.
> 
> Patches 1-5 revolve around utilizing helper functions to check if
> KVM TDP honors guest MTRRs, TDP zaps and page fault max_level reduction
> are now only targeted to TDPs that honor guest MTRRs.
> 
> -The 5th patch will trigger zapping of TDP leaf entries if non-coherent
>  DMA devices count goes from 0 to 1 or from 1 to 0.
> 
> Patches 6-7 are fixes and patches 9-12 are optimizations for mmu zaps
> when guest MTRRs are honored.
> Those mmu zaps are intended to remove stale memtypes of TDP entries
> caused by changes of guest MTRRs and CR0.CD and are usually triggered from
> all vCPUs in bursts.

Sorry for the delayed review, especially with respect to patches 1-5.  I completely
forgot there were cleanups at the beginning of this series.  I'll make to grab
1-5 early in the 6.7 cycle, even if you haven't sent a new version before then.
