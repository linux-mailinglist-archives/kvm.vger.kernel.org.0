Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 360B4349594
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 16:32:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbhCYPcN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 11:32:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37535 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231162AbhCYPbk (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 11:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616686299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9lOheegThOe4f6tto8O/gDarjNWvBXusi2vH5rKfbyc=;
        b=ciA0hffLLoKU5fGaJiY/Y0Gyk+gmMKH5mOrk9PLwfcwyZPNFVc05NcabSNgwd9FW7rxqHW
        eoLrplv3ljqFw7wEESGy0xhXsi+QpY78y+xK0+yXhi3mnhb5EacYZxsvZppkzyllOU2tq8
        8mEF0NSA7Yi1c3pYXQHUZ9oYmDLYlBQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-17YbFbogPT-bI07iPINu9w-1; Thu, 25 Mar 2021 11:31:35 -0400
X-MC-Unique: 17YbFbogPT-bI07iPINu9w-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3DF2B8EDBE1;
        Thu, 25 Mar 2021 15:31:34 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.194.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B6AF010013D7;
        Thu, 25 Mar 2021 15:31:32 +0000 (UTC)
Date:   Thu, 25 Mar 2021 16:31:29 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        andre.przywara@arm.com
Subject: Re: [kvm-unit-tests PATCH v2 0/6] Misc assembly fixes and cleanups
Message-ID: <20210325153129.lgeffmlqfrrkinra@kamzik.brq.redhat.com>
References: <20210322150641.58878-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322150641.58878-1-alexandru.elisei@arm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 22, 2021 at 03:06:35PM +0000, Alexandru Elisei wrote:
> This series is mostly fixes and cleanups for things I found when playing
> with EFI support. Most of them I hope are fairly self-explanatory.
> 
> What is clearly aimed at running on baremetal is patch #2 ("arm/arm64:
> Remove dcache_line_size global variable"), which is needed because the
> startup environment is different for EFI apps and we're going to need to do
> cache maintenance before setup() is run.
> 
> Patch #4 ("lib: arm64: Consolidate register definitions to sysreg.h") is
> there to make importing register definitions and other header files from
> Linux (like el2_setup.h) easier by switching to the same layout. And arm
> is already using sysreg.h for SCTLR fields.
> 
> Changes in v2:
> * Gathered Reviewed-by tags, thank you!
> * For patch #2 ("arm/arm64: Remove dcache_line_size global variable"), I've
>   modified the commit message to mention the change in parameters for
>   dcache_by_line_op, I've added the proper header guards to
>   lib/arm/asm/assembler.h and I've changed raw_dcache_line_size to use ubfx
>   instead of ubfm.
> 
> Alexandru Elisei (6):
>   arm64: Remove unnecessary ISB when writing to SPSel
>   arm/arm64: Remove dcache_line_size global variable
>   arm/arm64: Remove unnecessary ISB when doing dcache maintenance
>   lib: arm64: Consolidate register definitions to sysreg.h
>   arm64: Configure SCTLR_EL1 at boot
>   arm64: Disable TTBR1_EL1 translation table walks
> 
>  lib/arm/asm/assembler.h       | 53 ++++++++++++++++++++++++++++++++++
>  lib/arm/asm/processor.h       |  7 -----
>  lib/arm64/asm/arch_gicv3.h    |  6 ----
>  lib/arm64/asm/assembler.h     | 54 +++++++++++++++++++++++++++++++++++
>  lib/arm64/asm/pgtable-hwdef.h |  1 +
>  lib/arm64/asm/processor.h     | 17 -----------
>  lib/arm64/asm/sysreg.h        | 24 ++++++++++++++++
>  lib/arm/setup.c               |  7 -----
>  arm/cstart.S                  | 19 ++----------
>  arm/cstart64.S                | 28 +++++++-----------
>  10 files changed, 145 insertions(+), 71 deletions(-)
>  create mode 100644 lib/arm/asm/assembler.h
>  create mode 100644 lib/arm64/asm/assembler.h
> 
> -- 
> 2.31.0
>

Applied to arm/queue

https://gitlab.com/rhdrjones/kvm-unit-tests/-/commits/arm/queue

Thanks,
drew

