Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 062366F6EF6
	for <lists+kvm@lfdr.de>; Thu,  4 May 2023 17:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjEDPfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 May 2023 11:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229638AbjEDPfA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 May 2023 11:35:00 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F52EE46
        for <kvm@vger.kernel.org>; Thu,  4 May 2023 08:34:59 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id 98e67ed59e1d1-24e00b8cc73so358016a91.0
        for <kvm@vger.kernel.org>; Thu, 04 May 2023 08:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683214498; x=1685806498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pQ9tDaHwuNjMEaIcEge2FkZR+GruLElSn+p2QqhZgdw=;
        b=lzEff1KQKCUWqah8wMan4YtymdhMXv2goOSxQeVT1Tc+G/I9KZn7PVilbar6Ibhu+l
         WUDTrRkT+iSklflz+d8+ux6Iec4EpbTfiCPCwRviUaBc5UryB8PgDKGb+I7O1Bdh/EW8
         yZaOil60zjIQn1IdFZRoJPlXZHCXE9ioihZS6YVrwaTn1ES+XECIaqq2u6Rwlj6j+icD
         9V2VsVNMHPuEZwabMOYC2J3zdwdMpjjdYBdOKkBBMtAYSWT5cbuVIm+0p3S55IoI4//l
         MLBeS79uqY6047S8jkkIIIcqQckIC2pDHqNxS0pBwiMfIwXts5aOIbaWPgJO4LVu1jzq
         Fd5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683214498; x=1685806498;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pQ9tDaHwuNjMEaIcEge2FkZR+GruLElSn+p2QqhZgdw=;
        b=B2ncp2zogr4CQBnjVled7NztZANc+ZL364+5qwvaKJDRgAehc1s7rZVK+0F60YYYnl
         eATr19w8G2TStQDvpiyKtxBpeYDGq1cO7ta6vHLGSBTYMkf3RUXB7hrw11rzOyxFuWkp
         +x2Pmk6pps5eqChNmHBwjNy5OCIBCpikUCcaWe8rl7faGp9wgKDi+Q6nBjbEMRr1b/d9
         FUowWfI2dfAKm+TEkmUmasT6F84dCp9q1DWoDKy4YKNWFQfucTIQltBLlOzzyZtkUaQm
         77CAokBZ7KX2PDXs49409+YfPuK+gwjJAOk9BKjuRNtSJC6yU+KR1/fhzuWAA3iYREP8
         Af4g==
X-Gm-Message-State: AC+VfDyuAMekiRzn739Q2H4rFGNXpdXodxs6wbt7tU2Z2syvt3qe0q8K
        z7jC1VYivNJvfPKTDmkr4gR6MNpdMTE=
X-Google-Smtp-Source: ACHHUZ5NFd7AM9dlhI6C/9eAeqToTuGykksiCoHvLDIY0QGbwAdwqx7xIMg6c3GGHzcU04fX/jWDBB7YjCw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:9dc8:b0:24e:1b1d:edd3 with SMTP id
 x8-20020a17090a9dc800b0024e1b1dedd3mr716932pjv.1.1683214498595; Thu, 04 May
 2023 08:34:58 -0700 (PDT)
Date:   Thu, 4 May 2023 08:34:57 -0700
In-Reply-To: <06715227566b520d4a445466f091dc28a0b8cd95.camel@intel.com>
Mime-Version: 1.0
References: <20230503182852.3431281-1-seanjc@google.com> <20230503182852.3431281-3-seanjc@google.com>
 <06715227566b520d4a445466f091dc28a0b8cd95.camel@intel.com>
Message-ID: <ZFPQodNs0Cn9YDXT@google.com>
Subject: Re: [PATCH 2/5] KVM: SVM: Use kvm_pat_valid() directly instead of kvm_mtrr_valid()
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "guoke@uniontech.com" <guoke@uniontech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "haiwenyao@uniontech.com" <haiwenyao@uniontech.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 03, 2023, Kai Huang wrote:
> > for better or worse, KVM doesn't apply the "zap
> > SPTEs" logic to guest PAT changes when the VM has a passthrough device
> > with non-coherent DMA.
> 
> Is it a bug?

No.  KVM's MTRR behavior is using a heuristic to try not to break the VM: if the
VM has non-coherent DMA, then honor UC mapping in the MTRRs as such mappings may
be coverage the non-coherent DMA.

From vmx_get_mt_mask():

	/* We wanted to honor guest CD/MTRR/PAT, but doing so could result in
	 * memory aliases with conflicting memory types and sometimes MCEs.
	 * We have to be careful as to what are honored and when.

The PAT is problematic because it is referenced via the guest PTEs, versus the
MTRRs being tied to the guest physical address, e.g. different virtual mappings
for the same physical address can yield different memtypes via the PAT.  My head
hurts just thinking about how that might interact with shadow paging :-)

Even the MTRRs are somewhat sketchy because they are technically per-CPU, i.e.
two vCPUs could have different memtypes for the same physical address.  But in
practice, sane software/firmware uses consistent MTRRs across all CPUs.
