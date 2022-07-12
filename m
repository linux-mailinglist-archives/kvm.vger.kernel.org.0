Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F54F571B75
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 15:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230230AbiGLNjZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 09:39:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiGLNjX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 09:39:23 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 617C6B5233
        for <kvm@vger.kernel.org>; Tue, 12 Jul 2022 06:39:22 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 22DD51596;
        Tue, 12 Jul 2022 06:39:22 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C1903F70D;
        Tue, 12 Jul 2022 06:39:20 -0700 (PDT)
Date:   Tue, 12 Jul 2022 14:39:50 +0100
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, andrew.jones@linux.dev, drjones@redhat.com,
        pbonzini@redhat.com, jade.alglave@arm.com, ricarkol@google.com
Subject: Re: [kvm-unit-tests PATCH v3 25/27] arm64: Add support for efi in
 Makefile
Message-ID: <Ys15pk9rhYr3BS7i@monolith.localdoman>
References: <20220630100324.3153655-1-nikos.nikoleris@arm.com>
 <20220630100324.3153655-26-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220630100324.3153655-26-nikos.nikoleris@arm.com>
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Thu, Jun 30, 2022 at 11:03:22AM +0100, Nikos Nikoleris wrote:
> Users can now build kvm-unit-tests as efi apps by supplying an extra
> argument when invoking configure:
> 
> $> ./configure --enable-efi
> 
> This patch is based on an earlier version by
> Andrew Jones <drjones@redhat.com>
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> ---
>  configure           | 15 ++++++++++++---
>  arm/Makefile.arm    |  6 ++++++
>  arm/Makefile.arm64  | 18 ++++++++++++++----
>  arm/Makefile.common | 45 ++++++++++++++++++++++++++++++++++-----------
>  4 files changed, 66 insertions(+), 18 deletions(-)
> 
> diff --git a/configure b/configure
> index 5b7daac..2ff9881 100755
> --- a/configure
> +++ b/configure
[..]
> @@ -218,6 +223,10 @@ else
>          echo "arm64 doesn't support page size of $page_size"
>          usage
>      fi
> +    if [ "$efi" = 'y' ] && [ "$page_size" != "4096" ]; then
> +        echo "efi must use 4K pages"
> +        exit 1

Why this restriction?

The Makefile compiles kvm-unit-tests to run as an UEFI app, it doesn't
compile UEFI itself. As far as I can tell, UEFI is designed to run payloads
with larger page size (it would be pretty silly to not be able to boot a
kernel built for 16k or 64k pages with UEFI).

Is there some limitation that I'm missing?

Thanks,
Alex
