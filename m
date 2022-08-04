Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F8D158953D
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 02:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237100AbiHDARm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 20:17:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240980AbiHDAQy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 20:16:54 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B476E17E33
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 17:16:52 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id g12so17925393pfb.3
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 17:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=OwwKALsnNZGHXS5uAQdLbs0BkUXfWVuRe9TMpcy12j0=;
        b=AB9uM0DJMUFK/SdbngnGLeR1FojbEFIefdFjsjpNolnva+3Kc9zYNPMr7x+TFRyXEN
         r9mZzpaNPUdeIgUimUWES3DSN55fGypwbBbzMr02CEwvKHwMa5K4kxb7n/qImZ/ss9cH
         faF+2cgQYB7MppMABsJeYkIFsVBbITwd7adosX1oyHPJK3H9ShtTuu34GYfLfT4YD8gs
         qNPlxdlfYgWhSDdJ+Kj7NJk1HfirRSPVLKIxfGLDBdBv6vsxvbWWN2omF6Dgr5vdUwVP
         22G8DX1AZnuastiAyZVYjVdcoBMH07dM/t4EEssFgHswWKXUPG/xrB4htKdRSMfvyGvH
         Oftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=OwwKALsnNZGHXS5uAQdLbs0BkUXfWVuRe9TMpcy12j0=;
        b=s8Nj5dL4ebWx+EnehMS0Xjwsn02GVSv7S15+DGw7oLyeP1SLl7QAfepUBHAlYpsI15
         zHGjLmfiyw8DB3OF4Pu26wDVzqf6xREC8HfBWZ/25ZvkjVB2wcClaonrU8cYY63mPFvS
         GsihovvtZe2mPP9rOFWtmEfHQUYy9wy2pHJVdekM149lIQL1TOXbxK7Vf+7iSdkowbfa
         MRe7pClsLKj8RWhUofPkQSUivYBVmjV3/Av8H24Kdo73gxollOnBH3RxQk2JbhUbzDs1
         SZy9+w66NNBRVbHBuZbmcS5IgLT1Pe9xymWit2Vs7GmlP4nWcIhlRJQiqru6dqmx+xpo
         zelA==
X-Gm-Message-State: AJIora8nLqE46C0Vo+NeAtUfilcd3Ejo6SxFwBenIYYff1SvnipcLl5a
        2Yg+ngJklwR57MUFymY+B6dGhw==
X-Google-Smtp-Source: AGRyM1vL+zuPWK2CKM04SaYVYPFGcmL+OMGCft1CxMQMlG88EDJw/0dmCqJs2TS3zrFemwQLnAoNTA==
X-Received: by 2002:a63:f143:0:b0:41a:3744:8639 with SMTP id o3-20020a63f143000000b0041a37448639mr22940854pgk.254.1659572212150;
        Wed, 03 Aug 2022 17:16:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 139-20020a621991000000b0050dc76281e0sm13612933pfz.186.2022.08.03.17.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 17:16:51 -0700 (PDT)
Date:   Thu, 4 Aug 2022 00:16:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 2/3] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
Message-ID: <YusP8FaOCLvq3VFE@google.com>
References: <20220803224957.1285926-1-seanjc@google.com>
 <20220803224957.1285926-3-seanjc@google.com>
 <d924ec235d9b0fb27f80cb03b02b5c7d8466fec1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d924ec235d9b0fb27f80cb03b02b5c7d8466fec1.camel@intel.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 04, 2022, Kai Huang wrote:
> On Wed, 2022-08-03 at 22:49 +0000, Sean Christopherson wrote:
> > +void __init kvm_mmu_spte_module_init(void)
> > +{
> > +	/*
> > +	 * Snapshot userspace's desire to allow MMIO caching.  Whether or not
> > +	 * KVM can actually enable MMIO caching depends on vendor-specific
> > +	 * hardware capabilities and other module params that can't be resolved
> > +	 * until the vendor module is loaded, i.e. enable_mmio_caching can and
> > +	 * will change when the vendor module is (re)loaded.
> > +	 */
> > +	allow_mmio_caching = enable_mmio_caching;
> 
> ... Perhaps 'use_mmio_caching' or 'want_mmio_caching' is better as it reflects
> userspace's desire? Anyway let you decide.

Part of me likes "want_mmio_caching", but the module param really is only for
testing, i.e. any sane configuration always wants MMIO caching, but sometimes it's
explicitly disallowed purely so that KVM can mimic hardware that doesn't support
MMIO caching.
