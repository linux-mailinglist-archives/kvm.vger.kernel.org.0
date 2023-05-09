Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA026FD1A5
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 23:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235377AbjEIVtB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 May 2023 17:49:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236109AbjEIVs6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 May 2023 17:48:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3792B5FF2;
        Tue,  9 May 2023 14:48:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC83B62F2A;
        Tue,  9 May 2023 21:48:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0416C433EF;
        Tue,  9 May 2023 21:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683668932;
        bh=aGVn1Bb8EN0xVHHb7dzroGsVo8/flhCFZO4CFZWHcik=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=tkJpRcU+UpwjTdZQRc3cNQ8tasr/HuQGKVAD5vOXgft97gjXJgDHENRfSwF+lM4P4
         gYJG+tKkqYAldsu1NpXO9IezE/FFk1Szw+YGCeKSafMDv++VjJB8Y0lSf0mh4UsZKg
         +/5vdKBAWJnepY31oKiFtrgB1ubCBe6ZsZaaAUiOfj/Id6N5Y+ZQDcC86hYyUq4ANi
         tZ9tdzDiSiR22Olmx01Da8IaGDDEL+6uZko5i6Z2i9MMKXTadL3VwHCX/MyupibrBi
         qMh0WSlMECtcfAOvoTthfxi6n6yJKCtstd8OrkmEAp/0WgW18by/lSt036undmn6h7
         XqOBEEXUwE82w==
Date:   Tue, 9 May 2023 16:48:51 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Mike Pastore <mike@oobak.org>
Cc:     linux-pci@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH] PCI: Apply Intel NVMe quirk to Solidigm P44 Pro
Message-ID: <20230509214851.GA1277116@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230507073519.9737-1-mike@oobak.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

[+cc Alex, kvm list]

On Sun, May 07, 2023 at 02:35:19AM -0500, Mike Pastore wrote:
> Prevent KVM hang when a Solidgm P44 Pro NVMe is passed through to a
> guest via IOMMU and the guest is subsequently rebooted.
> 
> A similar issue was identified and patched in commit 51ba09452d11b
> ("PCI: Delay after FLR of Intel DC P3700 NVMe") and the same fix can be
> aplied for this case. (Intel spun off their NAND and SSD business as
> Solidigm and sold it to SK Hynix in late 2021.)
> 
> Signed-off-by: Mike Pastore <mike@oobak.org>

Applied with subject:

  PCI: Delay after FLR of Solidigm P44 Pro NVMe

to my virtualization branch for v6.5.  I also moved
PCI_VENDOR_ID_SOLIDIGM to keep pci_ids.h sorted.

> ---
>  drivers/pci/quirks.c    | 10 ++++++----
>  include/linux/pci_ids.h |  2 ++
>  2 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 44cab813bf95..b47844d0e574 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -3980,10 +3980,11 @@ static int nvme_disable_and_flr(struct pci_dev *dev, bool probe)
>  }
>  
>  /*
> - * Intel DC P3700 NVMe controller will timeout waiting for ready status
> - * to change after NVMe enable if the driver starts interacting with the
> - * device too soon after FLR.  A 250ms delay after FLR has heuristically
> - * proven to produce reliably working results for device assignment cases.
> + * Some NVMe controllers such as Intel DC P3700 and Solidigm P44 Pro will
> + * timeout waiting for ready status to change after NVMe enable if the driver
> + * starts interacting with the device too soon after FLR.  A 250ms delay after
> + * FLR has heuristically proven to produce reliably working results for device
> + * assignment cases.
>   */
>  static int delay_250ms_after_flr(struct pci_dev *dev, bool probe)
>  {
> @@ -4070,6 +4071,7 @@ static const struct pci_dev_reset_methods pci_dev_reset_methods[] = {
>  	{ PCI_VENDOR_ID_SAMSUNG, 0xa804, nvme_disable_and_flr },
>  	{ PCI_VENDOR_ID_INTEL, 0x0953, delay_250ms_after_flr },
>  	{ PCI_VENDOR_ID_INTEL, 0x0a54, delay_250ms_after_flr },
> +	{ PCI_VENDOR_ID_SOLIDIGM, 0xf1ac, delay_250ms_after_flr },
>  	{ PCI_VENDOR_ID_CHELSIO, PCI_ANY_ID,
>  		reset_chelsio_generic_dev },
>  	{ PCI_VENDOR_ID_HUAWEI, PCI_DEVICE_ID_HINIC_VF,
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 45c3d62e616d..6105eddf41bf 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -3119,4 +3119,6 @@
>  
>  #define PCI_VENDOR_ID_NCUBE		0x10ff
>  
> +#define PCI_VENDOR_ID_SOLIDIGM		0x025e
> +
>  #endif /* _LINUX_PCI_IDS_H */
> 
> base-commit: 63355b9884b3d1677de6bd1517cd2b8a9bf53978
> -- 
> 2.39.2
> 
