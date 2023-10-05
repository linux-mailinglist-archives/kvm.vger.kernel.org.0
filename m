Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF7A67BAB42
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 22:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230436AbjJEUKa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 16:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjJEUK3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 16:10:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4256BE4;
        Thu,  5 Oct 2023 13:10:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9484EC433C7;
        Thu,  5 Oct 2023 20:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696536627;
        bh=kOtDZyN8W/OVpOi7epksuraFOFD3cHQ5EafKpD9MeJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:From;
        b=mviExf4NRlegLwrNCAv0i84ZpFFF+N3iPOe4Lo1C9bTC9M5EUm6Lgyi0ff880nnVM
         P5IK0+VEsqCmnIL7m+wfunoRRMc4jFdIuMk3HVRZZJo3MDoMkeXZl/SDBt3jxRF9fC
         SxfiDJnF762XuY92yCY1n+kr5jEsI8SKFhi514tXrv0aucwEL+Zj2JQtFqQUbcHn8p
         9o8sSPyaCG3oXGixb8LLbf3zngRK6iGRLTcreiXVa28ItYFjd5XlK8AWymEbnrgN4t
         c0NJvz3ihzYjs7XUmMnnT4WS1Vbru1dodeBnPJchRlpdKbC/iTE3MttWSf8HOy6EUr
         mJXwMHWWBuk9Q==
Date:   Thu, 5 Oct 2023 15:10:26 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pci@vger.kernel.org, linux-cxl@vger.kernel.org,
        linux-coco@lists.linux.dev, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, kvm@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        linuxarm@huawei.com, David Box <david.e.box@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        "Li, Ming" <ming4.li@intel.com>, Zhi Wang <zhi.a.wang@intel.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Wilfred Mallawa <wilfred.mallawa@wdc.com>,
        Alexey Kardashevskiy <aik@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <seanjc@google.com>,
        Alexander Graf <graf@amazon.com>
Subject: Re: [PATCH 08/12] PCI/CMA: Authenticate devices on enumeration
Message-ID: <20231005201026.GA789128@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7721bfa3b4f8a99a111f7808ad8890c3c13df56d.1695921657.git.lukas@wunner.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 28, 2023 at 07:32:38PM +0200, Lukas Wunner wrote:
> From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> Component Measurement and Authentication (CMA, PCIe r6.1 sec 6.31)
> allows for measurement and authentication of PCIe devices.  It is
> based on the Security Protocol and Data Model specification (SPDM,
> https://www.dmtf.org/dsp/DSP0274).

> +#define dev_fmt(fmt) "CMA: " fmt

> +void pci_cma_init(struct pci_dev *pdev)
> +{
> +	struct pci_doe_mb *doe;
> +	int rc;
> +
> +	if (!pci_cma_keyring) {
> +		return;
> +	}

Jonathan mentioned the extra brackets below; here's another.

> +	if (!pdev->spdm_state) {
> +		return;
> +	}

> +	if (IS_ERR(pci_cma_keyring)) {
> +		pr_err("Could not allocate keyring\n");

There's a #define dev_fmt(fmt) above, but I don't think it's used in
this patch.  I think this would need something like:

  #define pr_fmt(fmt) "PCI: CMA: " fmt
