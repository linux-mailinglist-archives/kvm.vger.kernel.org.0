Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 636956C3834
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 18:31:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230215AbjCURbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 13:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjCURbe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 13:31:34 -0400
Received: from out-43.mta0.migadu.com (out-43.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCCF1E284
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 10:31:30 -0700 (PDT)
Date:   Tue, 21 Mar 2023 18:31:26 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679419887;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ASt8/P22vzOkb9vUyH4oGSxyKiBXM/r+JlKuOSYLiVI=;
        b=E0/Tg/cf6cuM2tZ41wrGoGJ3Wpw/s/5juMwyjrGs3bqANpiNfRFrGmLyvcId+4/AYb9KTv
        rPxyMP1KZJY4XuC3Yy8U62jQM3mSc1p+upNYYK0NSSFq4EQKEqbBlUsW0cmGJHifeq5yxx
        zup3d4MWYjiIQoUp05BmtOKvCz0Dqr0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Nikos Nikoleris <nikos.nikoleris@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com,
        alexandru.elisei@arm.com, ricarkol@google.com,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v4 12/30] arm64: Add support for setting up the PSCI
 conduit through ACPI
Message-ID: <20230321173126.3yii6lla3ryve5xq@orel>
References: <20230213101759.2577077-1-nikos.nikoleris@arm.com>
 <20230213101759.2577077-13-nikos.nikoleris@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213101759.2577077-13-nikos.nikoleris@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 10:17:41AM +0000, Nikos Nikoleris wrote:
> In systems with ACPI support and when a DT is not provided, we can use
> the FADT to discover whether PSCI calls need to use smc or hvc
> calls. This change implements this but retains the default behavior;
> we check if a valid DT is provided, if not, we try to setup the PSCI
> conduit using ACPI.
> 
> Signed-off-by: Nikos Nikoleris <nikos.nikoleris@arm.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>
> Reviewed-by: Ricardo Koller <ricarkol@google.com>
> ---
>  arm/Makefile.arm64 |  4 ++++
>  lib/acpi.h         |  5 +++++
>  lib/arm/psci.c     | 37 ++++++++++++++++++++++++++++++++++++-
>  3 files changed, 45 insertions(+), 1 deletion(-)
> 
> diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
> index 42e18e77..6dff6cad 100644
> --- a/arm/Makefile.arm64
> +++ b/arm/Makefile.arm64
> @@ -25,6 +25,10 @@ cflatobjs += lib/arm64/processor.o
>  cflatobjs += lib/arm64/spinlock.o
>  cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
>  
> +ifeq ($(CONFIG_EFI),y)
> +cflatobjs += lib/acpi.o
> +endif

This is already in arm/Makefile.common due to an earlier patch in
this series. Putting it in Makefile.arm64 makes more sense, though,
so let's just drop the earlier patch.

Thanks,
drew
