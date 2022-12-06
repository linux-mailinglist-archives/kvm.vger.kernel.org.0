Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA0E6444E4
	for <lists+kvm@lfdr.de>; Tue,  6 Dec 2022 14:48:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234493AbiLFNsT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Dec 2022 08:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiLFNsH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Dec 2022 08:48:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56393A1B7;
        Tue,  6 Dec 2022 05:48:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 698F161769;
        Tue,  6 Dec 2022 13:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A421C433D6;
        Tue,  6 Dec 2022 13:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670334481;
        bh=2JYS2naf9E4zAIWrMEAyI5LO342tnYyw1XzP6ZaY6B0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=g2omVqENBHzAwHg4smn2aRF4jnFXHRhuOxYLek0wV9y2ANZ2ICNy6r0t127kPwEV0
         UjavF360bI6edL/lh71+UcGZNDZ/DytjcFKG9VK9c51vticZtLv0+Hk0SlyHnsxjao
         lJXBTxkbA5Ll6lfiID3UUbbAzDvJggsJNUB9i+WfoPG0Dg3JfigCMu1JryIv9eRIWQ
         wZ1zQD0qSyPTbdJDBmg6qZYEyP+W8BvvuZoTlKbDN8tIsboJw0yLX2xkMyNqvfi2cr
         9lrQf4LBdD3F7C6G+EzJUFqSlBTT12XpLHzpAboz93x+CLRpIQ6JDbuLhSsF2bOuzf
         ef8Wbrq3e/8/A==
Date:   Tue, 6 Dec 2022 13:47:55 +0000
From:   Keith Busch <kbusch@kernel.org>
To:     Lei Rao <lei.rao@intel.com>
Cc:     axboe@fb.com, kch@nvidia.com, hch@lst.de, sagi@grimberg.me,
        alex.williamson@redhat.com, cohuck@redhat.com, jgg@ziepe.ca,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, mjrosato@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        kvm@vger.kernel.org, eddie.dong@intel.com, yadong.li@intel.com,
        yi.l.liu@intel.com, Konrad.wilk@oracle.com, stephen@eideticom.com,
        hang.yuan@intel.com
Subject: Re: [RFC PATCH 4/5] nvme-vfio: check if the hardware supports live
 migration
Message-ID: <Y49ICyTJ/WExT+wN@kbusch-mbp>
References: <20221206055816.292304-1-lei.rao@intel.com>
 <20221206055816.292304-5-lei.rao@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206055816.292304-5-lei.rao@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 06, 2022 at 01:58:15PM +0800, Lei Rao wrote:
> +static bool nvmevf_check_migration(struct pci_dev *pdev)
> +{
> +	struct nvme_command c = { };
> +	struct nvme_id_ctrl *id;
> +	u8 live_mig_support;
> +	int ret;
> +
> +	c.identify.opcode = nvme_admin_identify;
> +	c.identify.cns = NVME_ID_CNS_CTRL;
> +
> +	id = kmalloc(sizeof(struct nvme_id_ctrl), GFP_KERNEL);
> +	if (!id)
> +		return false;
> +
> +	ret = nvme_submit_vf_cmd(pdev, &c, NULL, id, sizeof(struct nvme_id_ctrl));
> +	if (ret) {
> +		dev_warn(&pdev->dev, "Get identify ctrl failed (ret=0x%x)\n", ret);
> +		goto out;
> +	}
> +
> +	live_mig_support = id->vs[0];

Considering this is a vendor specific region, it seems rather presumptuous to
assume this byte means "live migration supported".
