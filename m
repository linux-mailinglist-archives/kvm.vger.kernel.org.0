Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77826B2338
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 12:40:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbjCILkK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 06:40:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231580AbjCILkG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 06:40:06 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EE24E38B0
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 03:40:02 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PXS0K4FJTz4xDq;
        Thu,  9 Mar 2023 22:40:01 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1678362001;
        bh=lEFs2mXOoYv/1nHa+J0wMk77rUOAPbtxErIAgCOmt6Q=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QL7WH7FteinOGlbW/AhWNceQii5xASJNpO6UM1twJtj2IWR63uvzNVCmvQ8xjfG1Q
         cI+XmSX/mjSz8IvF8HjkcyX2LjO8tN3pHa9lXYY6MfvQEvFOMctC0hH47VqsdNQY5k
         s0LMcxiyRgLJY69rG95Oo/XQC+PTb/8iGoEQRhcdiwf53BTjjWtu84zdMfXvZsSdbU
         fQdqVs1Kzdk+MzV48qLh6u3j/ZCjv3JeEgSUSOrpsUJj1KmzUOJh6Y+Z5f5QSxZ3FX
         tVL2rJDSJU3cjxIbzBtlNu7ilJzkUSx7UCcmt6SYLDnuDxm9nfbb+1hbGlapmNlEpD
         GSebo8W8Fnx1w==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Timothy Pearson <tpearson@raptorengineering.com>,
        kvm <kvm@vger.kernel.org>
Cc:     linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
In-Reply-To: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
References: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
Date:   Thu, 09 Mar 2023 22:40:01 +1100
Message-ID: <87bkl2ywz2.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Timothy Pearson <tpearson@raptorengineering.com> writes:
> This patch series reenables VFIO support on POWER systems.  It
> is based on Alexey Kardashevskiys's patch series, rebased and
> successfully tested under QEMU with a Marvell PCIe SATA controller
> on a POWER9 Blackbird host.
>
> Alexey Kardashevskiy (3):
>   powerpc/iommu: Add "borrowing" iommu_table_group_ops
>   powerpc/pci_64: Init pcibios subsys a bit later
>   powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
>     domains

As sent the patches had lost Alexey's authorship (no From: line), I
fixed it up when applying so the first 3 are authored by Alexey.

cheers

> Timothy Pearson (1):
>   Add myself to MAINTAINERS for Power VFIO support
>
>  MAINTAINERS                               |   5 +
>  arch/powerpc/include/asm/iommu.h          |   6 +-
>  arch/powerpc/include/asm/pci-bridge.h     |   7 +
>  arch/powerpc/kernel/iommu.c               | 246 +++++++++++++++++++++-
>  arch/powerpc/kernel/pci_64.c              |   2 +-
>  arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
>  arch/powerpc/platforms/pseries/iommu.c    |  27 +++
>  arch/powerpc/platforms/pseries/pseries.h  |   4 +
>  arch/powerpc/platforms/pseries/setup.c    |   3 +
>  drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
>  10 files changed, 338 insertions(+), 94 deletions(-)
>
> -- 
> 2.30.2
