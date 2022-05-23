Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D00325314D1
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 18:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237158AbiEWOm5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 10:42:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbiEWOmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 10:42:54 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 32FFE25C42
        for <kvm@vger.kernel.org>; Mon, 23 May 2022 07:42:53 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA1B8139F;
        Mon, 23 May 2022 07:42:52 -0700 (PDT)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 136693F70D;
        Mon, 23 May 2022 07:42:51 -0700 (PDT)
Date:   Mon, 23 May 2022 15:42:49 +0100
From:   Andre Przywara <andre.przywara@arm.com>
To:     Will Deacon <will@kernel.org>
Cc:     kvm@vger.kernel.org, Keir Fraser <keirf@google.com>,
        catalin.marinas@arm.com, kernel-team@android.com,
        Alexandru Elisei <Alexandru.Elisei@arm.com>
Subject: Re: [PATCH kvmtool 0/2] Fixes for virtio_balloon stats printing
Message-ID: <20220523154249.2fa6db09@donnerap.cambridge.arm.com>
In-Reply-To: <165307799681.1660071.7738890533857118660.b4-ty@kernel.org>
References: <20220520143706.550169-1-keirf@google.com>
        <165307799681.1660071.7738890533857118660.b4-ty@kernel.org>
Organization: ARM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 May 2022 21:51:07 +0100
Will Deacon <will@kernel.org> wrote:

Hi,

> On Fri, 20 May 2022 14:37:04 +0000, Keir Fraser wrote:
> > While playing with kvmtool's virtio_balloon device I found a couple of
> > niggling issues with the printing of memory stats. Please consider
> > these fairly trivial fixes.

Unfortunately patch 2/2 breaks compilation on userland with older kernel
headers, like Ubuntu 18.04:
...
  CC       builtin-stat.o
builtin-stat.c: In function 'do_memstat':
builtin-stat.c:86:8: error: 'VIRTIO_BALLOON_S_HTLB_PGALLOC' undeclared (first use in this function); did you mean 'VIRTIO_BALLOON_S_AVAIL'?
   case VIRTIO_BALLOON_S_HTLB_PGALLOC:
        ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
        VIRTIO_BALLOON_S_AVAIL
(repeated for VIRTIO_BALLOON_S_HTLB_PGFAIL and VIRTIO_BALLOON_S_CACHES).

I don't quite remember what we did here in the past in those cases,
conditionally redefine the symbols in a local header, or protect the
new code with an #ifdef?

I would lean towards the former (and hacking this in works), but then we
would need to redefine VIRTIO_BALLOON_S_NR, to encompass the new symbols,
which sounds fragile.

Happy to send a patch if we agree on an approach.

Cheers,
Andre

> > 
> > Keir Fraser (2):
> >   virtio/balloon: Fix a crash when collecting stats
> >   stat: Add descriptions for new virtio_balloon stat types
> > 
> > [...]  
> 
> Applied to kvmtool (master), thanks!
> 
> [1/2] virtio/balloon: Fix a crash when collecting stats
>       https://git.kernel.org/will/kvmtool/c/3a13530ae99a
> [2/2] stat: Add descriptions for new virtio_balloon stat types
>       https://git.kernel.org/will/kvmtool/c/bc77bf49df6e
> 
> Cheers,

