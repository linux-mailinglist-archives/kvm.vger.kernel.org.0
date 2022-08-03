Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE07B589486
	for <lists+kvm@lfdr.de>; Thu,  4 Aug 2022 00:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237159AbiHCWt2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Aug 2022 18:49:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236637AbiHCWtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 Aug 2022 18:49:25 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD8922B29
        for <kvm@vger.kernel.org>; Wed,  3 Aug 2022 15:49:24 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id f11so16367283pgj.7
        for <kvm@vger.kernel.org>; Wed, 03 Aug 2022 15:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=1BxpsamUUhc+oDoAp2dc++aXjCc5DZvHk2oG33loPcU=;
        b=JBoHWU2120zTexjAsT7PmeWUqmxQ02GyiAnAppkYJ4nq4lJO3pgP4vDtVbztybQ9Vi
         timpynQe4PJTFgh2kzC88KJHuwQ26mJ/nDcgF4QYvJ1NHNCFBrudswCIt45PrWF7OtvQ
         dMwWESRQyM303XbXBDUoTlBwUcOy2hWaVnFgjEi0gzOOUohkSPu95oa9VG/jtq+NrCLh
         sfm1Jb64hJLcSl+AemAmXy7xs1NWS02+evHn/Zd/ZeSxsu5cTKxLZiEGOoNBp5IlRUQd
         hX+HFTqn84lJ9jVDojLqJ+UNGAb38zxa6Cs7lYOCCZ5ReQ2DNFjdJpNVt2ilW+eEWmIT
         FHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1BxpsamUUhc+oDoAp2dc++aXjCc5DZvHk2oG33loPcU=;
        b=VnJc/y0DYyjmn3Dj6WSufGMfiqpq0ceW3bPggJ5e2W3fjGgBiCnCSpWrQYWkgd2wM9
         VXE9LJ8xsloFzEhlzAEYOPjoD0hlkuMBAcqQK1qwVX8CpXocIdWL3MbFpQkZwNw5bvDX
         dWQUvfys2vkCVuVmQNuXSzlX407eftWqcFvCMkflU+H/K6QPaeLbNYWmrLgThVufMOTa
         5kuyo7oXaHE+6B4VkJ3D6JD/glwXVxq7v75p3tke8iNEw+2dHaPBLmMXa9HO4h8a+rpx
         Y2j60Ll3tNuSLNNydbAYhyZ4R1KJXq1y4k+zBTQSzNNePmWsSaP/MOQIxSXL0SygWDfA
         sGnw==
X-Gm-Message-State: ACgBeo1llwfvxPyn1XN0lQ1wB8uUNyRNdOqSCwLGf13+iwj5qzdX5mfB
        G74z6DFkngt2el8g8vJK1lxbDOd4EZPa0A==
X-Google-Smtp-Source: AA6agR43o51+/1qGwupcZlAEZg68WvjfmprQ123VTOtSyp8ZmdbU4+ohLj2PnVXHV+s9B91Tk+G6nw==
X-Received: by 2002:a63:ec04:0:b0:41c:1149:4523 with SMTP id j4-20020a63ec04000000b0041c11494523mr13383085pgh.62.1659566964272;
        Wed, 03 Aug 2022 15:49:24 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p2-20020a625b02000000b0052d63fb109asm7762271pfb.20.2022.08.03.15.49.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 15:49:23 -0700 (PDT)
Date:   Wed, 3 Aug 2022 22:49:20 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Add sanity check that MMIO SPTE mask
 doesn't overlap gen
Message-ID: <Yur7cGigN3MIrQO9@google.com>
References: <20220803213354.951376-1-seanjc@google.com>
 <be0767a74a80cf8d749003cc73a9aa316ab49821.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be0767a74a80cf8d749003cc73a9aa316ab49821.camel@intel.com>
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
> On Wed, 2022-08-03 at 21:33 +0000, Sean Christopherson wrote:
> > Add compile-time and init-time sanity checks to ensure that the MMIO SPTE
> > mask doesn't overlap the MMIO SPTE generation.  The generation currently
> > avoids using bit 63, but that's as much coincidence as it is strictly
> > necessarly.  That will change in the future, as TDX support will require
> > setting bit 63 (SUPPRESS_VE) in the mask.  Explicitly carve out the bits
> > that are allowed in the mask so that any future shuffling of SPTE MMIO
> > bits doesn't silently break MMIO caching.
> 
> Reviwed-by: Kai Huang <kai.huang@intel.com>
> 
> Btw, should you also check SPTE_MMU_PRESENT_MASK (or in another patch)?

Rats, I thought we already checked that, but it's only the MMIO generation that
checks for overlap.  I'll send a v2.
