Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFF977B6C0C
	for <lists+kvm@lfdr.de>; Tue,  3 Oct 2023 16:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240158AbjJCOsA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Oct 2023 10:48:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjJCOr7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Oct 2023 10:47:59 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCDCAC;
        Tue,  3 Oct 2023 07:47:56 -0700 (PDT)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4S0LG135ykz6HJbr;
        Tue,  3 Oct 2023 22:45:13 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.31; Tue, 3 Oct
 2023 15:47:53 +0100
Date:   Tue, 3 Oct 2023 15:47:51 +0100
From:   Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To:     Lukas Wunner <lukas@wunner.de>
CC:     Bjorn Helgaas <helgaas@kernel.org>,
        David Howells <dhowells@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Williamson <alex.williamson@redhat.com>,
        <linux-pci@vger.kernel.org>, <linux-cxl@vger.kernel.org>,
        <linux-coco@lists.linux.dev>, <keyrings@vger.kernel.org>,
        <linux-crypto@vger.kernel.org>, <kvm@vger.kernel.org>,
        <linuxarm@huawei.com>, David Box <david.e.box@intel.com>,
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
Message-ID: <20231003154751.00004de7@Huawei.com>
In-Reply-To: <7721bfa3b4f8a99a111f7808ad8890c3c13df56d.1695921657.git.lukas@wunner.de>
References: <cover.1695921656.git.lukas@wunner.de>
        <7721bfa3b4f8a99a111f7808ad8890c3c13df56d.1695921657.git.lukas@wunner.de>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 28 Sep 2023 19:32:38 +0200
Lukas Wunner <lukas@wunner.de> wrote:

> From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> 
> Component Measurement and Authentication (CMA, PCIe r6.1 sec 6.31)
> allows for measurement and authentication of PCIe devices.  It is
> based on the Security Protocol and Data Model specification (SPDM,
> https://www.dmtf.org/dsp/DSP0274).
> 
> CMA-SPDM in turn forms the basis for Integrity and Data Encryption
> (IDE, PCIe r6.1 sec 6.33) because the key material used by IDE is
> exchanged over a CMA-SPDM session.
> 
> As a first step, authenticate CMA-capable devices on enumeration.
> A subsequent commit will expose the result in sysfs.
> 
> When allocating SPDM session state with spdm_create(), the maximum SPDM
> message length needs to be passed.  Make the PCI_DOE_MAX_LENGTH macro
> public and calculate the maximum payload length from it.
> 
> Credits:  Jonathan wrote a proof-of-concept of this CMA implementation.
> Lukas reworked it for upstream.  Wilfred contributed fixes for issues
> discovered during testing.
> 
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Wilfred Mallawa <wilfred.mallawa@wdc.com>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
Hi Lukas,

A few things inline. Biggest of which is making this one build
warning free by pulling forward the cma_capable flag from
patch 10.

>  
> diff --git a/drivers/pci/cma.c b/drivers/pci/cma.c
> new file mode 100644
> index 000000000000..06e5846325e3
> --- /dev/null
> +++ b/drivers/pci/cma.c


> +void pci_cma_init(struct pci_dev *pdev)
> +{
> +	struct pci_doe_mb *doe;
> +	int rc;
> +
> +	if (!pci_cma_keyring) {
> +		return;
> +	}
> +
> +	if (!pci_is_pcie(pdev))
> +		return;
> +
> +	doe = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
> +				   PCI_DOE_PROTOCOL_CMA);
> +	if (!doe)
> +		return;
> +
> +	pdev->spdm_state = spdm_create(&pdev->dev, pci_doe_transport, doe,
> +				       PCI_DOE_MAX_PAYLOAD, pci_cma_keyring);
> +	if (!pdev->spdm_state) {
> +		return;
> +	}

Brackets not needed.

> +
> +	rc = spdm_authenticate(pdev->spdm_state);

Hanging rc?  There is a blob in patch 10 that uses it, but odd to keep it around
in meantime.  Perhaps just add the flag in this patch and set it even
though no one cares about it yet.


> +}
> +
> +void pci_cma_destroy(struct pci_dev *pdev)
> +{
> +	if (pdev->spdm_state)
> +		spdm_destroy(pdev->spdm_state);
> +}
> +
> +__init static int pci_cma_keyring_init(void)
> +{
> +	pci_cma_keyring = keyring_alloc(".cma", KUIDT_INIT(0), KGIDT_INIT(0),
> +					current_cred(),
> +					(KEY_POS_ALL & ~KEY_POS_SETATTR) |
> +					KEY_USR_VIEW | KEY_USR_READ |
> +					KEY_USR_WRITE | KEY_USR_SEARCH,
> +					KEY_ALLOC_NOT_IN_QUOTA |
> +					KEY_ALLOC_SET_KEEP, NULL, NULL);
> +	if (IS_ERR(pci_cma_keyring)) {
> +		pr_err("Could not allocate keyring\n");
> +		return PTR_ERR(pci_cma_keyring);
> +	}
> +
> +	return 0;
> +}
> +arch_initcall(pci_cma_keyring_init);


