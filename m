Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A29D6B2332
	for <lists+kvm@lfdr.de>; Thu,  9 Mar 2023 12:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjCILiq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Mar 2023 06:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjCILio (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Mar 2023 06:38:44 -0500
Received: from gandalf.ozlabs.org (mail.ozlabs.org [IPv6:2404:9400:2221:ea00::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C276A9C0
        for <kvm@vger.kernel.org>; Thu,  9 Mar 2023 03:38:42 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4PXRyh09xkz4xDl;
        Thu,  9 Mar 2023 22:38:36 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
        s=201909; t=1678361917;
        bh=TiYrTB9e3gxSfoaCH8f+uTiFsYylfTZ4EDaBxO70Vxk=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=CBZwty3Q6WJgFrMC511xe+NTyZ9zNysV7WyQ7CuH3BgET+ooM23k3iFpIWRN/zIiI
         /QzDSMxyn29RLaAnh+fTHfaFiGagieH3JogLhvll3k2qbz2X8GBe0h8mq4YI2Q4/FO
         0k6WzZzSSqjKy5/B4fgEucTC5nOqabltDbKcM7/kgMe44oHIgq2M6I8w/G6OPEmzVd
         EJf3V49QT+0JEzXHzuN8rJsDgwHy6tcnk0AWdhDEe8D0KQdrOtYIMBPrY8x9xTcmUZ
         7kAUyxfwWA9qHdeg99Au7uXTk35i0ejSwQwLfZIkl3QTvQxBvYqJzxWwabFTNnntUr
         aXM+Is99x+NqQ==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Timothy Pearson <tpearson@raptorengineering.com>
Cc:     linuxppc-dev@lists.ozlabs.org, kvm <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 0/4] Reenable VFIO support on POWER systems
In-Reply-To: <20230306164607.1455ee81.alex.williamson@redhat.com>
References: <8398361.16996856.1678123793664.JavaMail.zimbra@raptorengineeringinc.com>
 <20230306164607.1455ee81.alex.williamson@redhat.com>
Date:   Thu, 09 Mar 2023 22:38:33 +1100
Message-ID: <87edpyyx1i.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alex Williamson <alex.williamson@redhat.com> writes:
> On Mon, 6 Mar 2023 11:29:53 -0600 (CST)
> Timothy Pearson <tpearson@raptorengineering.com> wrote:
>
>> This patch series reenables VFIO support on POWER systems.  It
>> is based on Alexey Kardashevskiys's patch series, rebased and
>> successfully tested under QEMU with a Marvell PCIe SATA controller
>> on a POWER9 Blackbird host.
>> 
>> Alexey Kardashevskiy (3):
>>   powerpc/iommu: Add "borrowing" iommu_table_group_ops
>>   powerpc/pci_64: Init pcibios subsys a bit later
>>   powerpc/iommu: Add iommu_ops to report capabilities and allow blocking
>>     domains
>> 
>> Timothy Pearson (1):
>>   Add myself to MAINTAINERS for Power VFIO support
>> 
>>  MAINTAINERS                               |   5 +
>>  arch/powerpc/include/asm/iommu.h          |   6 +-
>>  arch/powerpc/include/asm/pci-bridge.h     |   7 +
>>  arch/powerpc/kernel/iommu.c               | 246 +++++++++++++++++++++-
>>  arch/powerpc/kernel/pci_64.c              |   2 +-
>>  arch/powerpc/platforms/powernv/pci-ioda.c |  36 +++-
>>  arch/powerpc/platforms/pseries/iommu.c    |  27 +++
>>  arch/powerpc/platforms/pseries/pseries.h  |   4 +
>>  arch/powerpc/platforms/pseries/setup.c    |   3 +
>>  drivers/vfio/vfio_iommu_spapr_tce.c       |  96 ++-------
>>  10 files changed, 338 insertions(+), 94 deletions(-)
>> 
>
> For vfio and MAINTAINERS portions,
>
> Acked-by: Alex Williamson <alex.williamson@redhat.com>

Thanks.

cheers
