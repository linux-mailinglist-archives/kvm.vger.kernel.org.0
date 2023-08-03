Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82B6C76E32C
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 10:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234670AbjHCIck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Aug 2023 04:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234666AbjHCIcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Aug 2023 04:32:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18F1735A2
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 01:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 650C661CBE
        for <kvm@vger.kernel.org>; Thu,  3 Aug 2023 08:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0CAC433C7;
        Thu,  3 Aug 2023 08:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691051340;
        bh=oZ7UXI6jDjaUy2oIbNV8s1eUqa5XVQxIUZMcNTD4msQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n9FmrG/CNl5iIWVefeSS0+9fO5mGho2xlZQ4SeWfa8U5eum5dXPmqLQSV1rFSGfTB
         w9HVMxZEiVD1/gTiGnMgF/y9L8stSkQBbq1Qryr2Ht017rrQzzZ4QIBLU5CoKEE4ja
         GACKTQIcqDMxNhyPVT8mxgZBP62xaGjSu0PuBS7FIpE2KwFy3QzTf73MIQEYAbGHDB
         QdKme3HkOd7h18MlcyNA2/rLaK9fjyC/s575HUiGh0cRmPE4dUNRfbkSfIECaOmllA
         vHTxgY5vjESGxPkymRcwuP0pyv6VS+gbhUndNOwB89Y0xK9wxA+Nbe/yOtLpZRB6KO
         hUytJCSej7FdQ==
Date:   Thu, 3 Aug 2023 10:28:55 +0200
From:   Simon Horman <horms@kernel.org>
To:     Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, jgg@nvidia.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        simon.horman@corigine.com, shannon.nelson@amd.com
Subject: Re: [PATCH v13 vfio 0/7] pds-vfio-pci driver
Message-ID: <ZMtlR/IlHjGGdMTl@kernel.org>
References: <20230725214025.9288-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230725214025.9288-1-brett.creeley@amd.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25, 2023 at 02:40:18PM -0700, Brett Creeley wrote:
> This is a patchset for a new vendor specific VFIO driver
> (pds-vfio-pci) for use with the AMD/Pensando Distributed Services
> Card (DSC). This driver makes use of the pds_core driver.
> 
> This driver will use the pds_core device's adminq as the VFIO
> control path to the DSC. In order to make adminq calls, the VFIO
> instance makes use of functions exported by the pds_core driver.
> 
> In order to receive events from pds_core, the pds-vfio-pci driver
> registers to a private notifier. This is needed for various events
> that come from the device.
> 
> An ASCII diagram of a VFIO instance looks something like this and can
> be used with the VFIO subsystem to provide the VF device VFIO and live
> migration support.
> 
>                                .------.  .-----------------------.
>                                | QEMU |--|  VM  .-------------.  |
>                                '......'  |      |   Eth VF    |  |
>                                   |      |      .-------------.  |
>                                   |      |      |  SR-IOV VF  |  |
>                                   |      |      '-------------'  |
>                                   |      '------------||---------'
>                                .--------------.       ||
>                                |/dev/<vfio_fd>|       ||
>                                '--------------'       ||
> Host Userspace                         |              ||
> ===================================================   ||
> Host Kernel                            |              ||
>                                   .--------.          ||
>                                   |vfio-pci|          ||
>                                   '--------'          ||
>        .------------------.           ||              ||
>        |   | exported API |<----+     ||              ||
>        |   '--------------|     |     ||              ||
>        |                  |    .--------------.       ||
>        |     pds_core     |--->| pds-vfio-pci |       ||
>        '------------------' |  '--------------'       ||
>                ||           |         ||              ||
>              09:00.0     notifier    09:00.1          ||
> == PCI ===============================================||=====
>                ||                     ||              ||
>           .----------.          .----------.          ||
>     ,-----|    PF    |----------|    VF    |-------------------,
>     |     '----------'         |'----------'         VF        |
>     |                     DSC  |                 data/control  |
>     |                          |                     path      |
>     -----------------------------------------------------------
> 
> The pds-vfio-pci driver is targeted to reside in drivers/vfio/pci/pds.
> It makes use of and introduces new files in the common include/linux/pds
> include directory.
> 
> Note: This series is based on the latest linux-next tree. I did not base
> it on the Alex Williamson's vfio/next because it has not yet pulled in
> the latest changes which include the pds_vdpa driver. The pds_vdpa
> driver has conflicts with the pds-vfio-pci driver that needed to be
> resolved, which is why this series is based on the latest linux-next
> tree.

For series,

Reviewed-by: Simon Horman <horms@kernel.org>


