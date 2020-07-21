Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA7AB228514
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 18:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbgGUQNy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 12:13:54 -0400
Received: from mail-eopbgr80052.outbound.protection.outlook.com ([40.107.8.52]:42734
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726890AbgGUQNx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 12:13:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ae8gwc4qM/EBY6br9YPuHX9UKyJ7XDSHv5ZSQaYb0sv/AsTDCwf4poWWMOKxzrPWSAwSpW4HLm/MHApFkYcAwYDV3nFuip0AKlJl+pDT51edwvkXVaVSOhju2TdHkfkF+GT/e2Z0nCb70x1gGxbgAuBT0L5/2eW1XVXThju27r+8jDdrniuTaMZLmSiOBqNOEopBnhfyN8pJoYmIYQYYLY5hAo/k++EONSK2dQ45xAarjU/uMU0HyaxquPHCdgBivripn5C1wHEcz3jN0Q0NFETMRYnH2HH7qLC2LObKd5OzttZ5L3XoanmwKb5VCMJC9DnZ44IwmB6GMGQVfOpwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DndAM0VfJowljsP4EZn4OOXmaYDIl0HMeThu0Ch4IqE=;
 b=HxmbsZgi10IyV1LKT8bahMw5CSkv6rROcaleGKqjiGSailXx+TFtsOm5WQvyUw7eN9cUaNXVF8DXntyi40ChYyOo8D2Hqq3UDVRgnQ38D0fMxOEhfE1KjnFvLP2MvEN3Mc8sfvDpKIMQTrmoDH6VPEc0w15gw9BgcAD9jKmhXsqAO3hM/1GaWOWCwxoYXoiqNvfMGacVPi/9XuP1syy7kujv8DJ0VSbcVIef+20OEA2WM7kf/A8f2crTkKuLcV1pVtlvjSfPDJY7Xb8Mak8U+kcmMn4/s2Knj3lp8qUcnduzz+snbI5DQ9t5SRZZuXOurpWyql/ZiWA0/qA65vB4iA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DndAM0VfJowljsP4EZn4OOXmaYDIl0HMeThu0Ch4IqE=;
 b=lWa3kTOc9jM20fDN/gN3gVyZsIff96QJGrfnAPeJ3wnK3sU+opRe1lCAw6B/oRNJxa3jHXeDneaeyso743pVsEt94Uxa5/AXul2TeVBOkQdeZLTrhjWvI7ufLNrGcEeQB5216kHAVbFoW8oZwt8bWuiLe937YDz+RxnjUTC6/ug=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB6142.eurprd05.prod.outlook.com (2603:10a6:803:e7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.24; Tue, 21 Jul
 2020 16:13:48 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::252e:52c7:170b:35d%5]) with mapi id 15.20.3195.026; Tue, 21 Jul 2020
 16:13:48 +0000
Date:   Tue, 21 Jul 2020 13:13:44 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     vkoul@kernel.org, megha.dey@intel.com, maz@kernel.org,
        bhelgaas@google.com, rafael@kernel.org, gregkh@linuxfoundation.org,
        tglx@linutronix.de, hpa@zytor.com, alex.williamson@redhat.com,
        jacob.jun.pan@intel.com, ashok.raj@intel.com, yi.l.liu@intel.com,
        baolu.lu@intel.com, kevin.tian@intel.com, sanjay.k.kumar@intel.com,
        tony.luck@intel.com, jing.lin@intel.com, dan.j.williams@intel.com,
        kwankhede@nvidia.com, eric.auger@redhat.com, parav@mellanox.com,
        dave.hansen@intel.com, netanelg@mellanox.com, shahafs@mellanox.com,
        yan.y.zhao@linux.intel.com, pbonzini@redhat.com,
        samuel.ortiz@intel.com, mona.hossain@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH RFC v2 02/18] irq/dev-msi: Add support for a new DEV_MSI
 irq domain
Message-ID: <20200721161344.GA2021248@mellanox.com>
References: <159534667974.28840.2045034360240786644.stgit@djiang5-desk3.ch.intel.com>
 <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159534734833.28840.10067945890695808535.stgit@djiang5-desk3.ch.intel.com>
X-ClientProxiedBy: BL0PR02CA0068.namprd02.prod.outlook.com
 (2603:10b6:207:3d::45) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR02CA0068.namprd02.prod.outlook.com (2603:10b6:207:3d::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.19 via Frontend Transport; Tue, 21 Jul 2020 16:13:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@mellanox.com>)      id 1jxutk-00DGOe-BE; Tue, 21 Jul 2020 13:13:44 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 99e3e0c5-8b85-45da-e7bf-08d82d910ce4
X-MS-TrafficTypeDiagnostic: VI1PR05MB6142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB61429A243FCADEDF427D72CBCF780@VI1PR05MB6142.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V10WLAvlWhTCWteYGaNvz24krl8EvUILWV6xrONmzf7nOsav+j1ouofr5gjTKIB4q4uK9GM+Ghb/8pS3IJQxrDZJI46ksLiiBluQFzt263jc6KHzV4wbRFh/TNMNiOFFmXMll4el+I9gIO/chEajp+qswQGx4LAVcXVQ7kODxLW7lZIKjGvwKUccjJUcDQLkw5MSziwhpNwYfIuSwStJSDCaZh9No+LTp2s6pRrZK5N3xr3LiZkY6rkVx4sCKL97N0+dORqSdHu1Utex0DeiAByxd5x+mRFRC8OrjvLqT2qGfciIo271qPMOhWOFZcS4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39840400004)(346002)(376002)(136003)(83380400001)(36756003)(1076003)(9786002)(8936002)(7406005)(9746002)(4326008)(186003)(86362001)(2906002)(7416002)(6916009)(5660300002)(33656002)(2616005)(478600001)(8676002)(316002)(66946007)(66476007)(26005)(426003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: RZmmyMRBq1LQ3lvR/42x1t3qnw1DfZevNkl3YyPWLCexBBek/dmuFm5GHiWyY24PthMzsG5H5x0VyaxVluBOtL4UXpZ+DXhlil3jjk+lbBp/OoHmfP3uV5L32g4q17uROtsiQvYS+CIgeG782UBEBZaACfWEmsVUXj2kmYtQYZ2gq6fr6a2vpTmAphbH3tOuv6iSqbUAw8mSGZsYrsW47uyyqvKmVcTUXIKfltRBn2T4fjLtea95wMduyAvQioEfUOsaYDFLY1ot8J7obOxKhxPiiYmCyDB1s5UfIA2RsTm0yQ295dtwQnyth7gRj/7HGnIF7is9zohuGjEtcPOHMKrk5RQ9U4CDJKHfWE93C5g4QMcPyuiXAJ/M+sW5TFX4w5sBFSIw+1D9PTcrKN9ixGtCK9cUxFwtgko0V8wd3LKV230yETL6ZTqTKy7k4VjaL0hnufmnlZkHzcXlNXYtjaUqOoVZdp3ouct78EEtd9A=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99e3e0c5-8b85-45da-e7bf-08d82d910ce4
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB4141.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2020 16:13:48.4899
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AXK0Zr0eONepUsZTA1AYoECCFR3WfZ4elaJzkamlIJseOfiJx6wYYH1katxku2iXzsaQkf6Wi/rIA2cfsFjzQA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6142
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 21, 2020 at 09:02:28AM -0700, Dave Jiang wrote:
> From: Megha Dey <megha.dey@intel.com>
> 
> Add support for the creation of a new DEV_MSI irq domain. It creates a
> new irq chip associated with the DEV_MSI domain and adds the necessary
> domain operations to it.
> 
> Add a new config option DEV_MSI which must be enabled by any
> driver that wants to support device-specific message-signaled-interrupts
> outside of PCI-MSI(-X).
> 
> Lastly, add device specific mask/unmask callbacks in addition to a write
> function to the platform_msi_ops.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Megha Dey <megha.dey@intel.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>  arch/x86/include/asm/hw_irq.h |    5 ++
>  drivers/base/Kconfig          |    7 +++
>  drivers/base/Makefile         |    1 
>  drivers/base/dev-msi.c        |   95 +++++++++++++++++++++++++++++++++++++++++
>  drivers/base/platform-msi.c   |   45 +++++++++++++------
>  drivers/base/platform-msi.h   |   23 ++++++++++
>  include/linux/msi.h           |    8 +++
>  7 files changed, 168 insertions(+), 16 deletions(-)
>  create mode 100644 drivers/base/dev-msi.c
>  create mode 100644 drivers/base/platform-msi.h
> 
> diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
> index 74c12437401e..8ecd7570589d 100644
> +++ b/arch/x86/include/asm/hw_irq.h
> @@ -61,6 +61,11 @@ struct irq_alloc_info {
>  			irq_hw_number_t	msi_hwirq;
>  		};
>  #endif
> +#ifdef CONFIG_DEV_MSI
> +		struct {
> +			irq_hw_number_t hwirq;
> +		};
> +#endif

Why is this in this patch? I didn't see an obvious place where it is
used?
>  
> +static void __platform_msi_desc_mask_unmask_irq(struct msi_desc *desc, u32 mask)
> +{
> +	const struct platform_msi_ops *ops;
> +
> +	ops = desc->platform.msi_priv_data->ops;
> +	if (!ops)
> +		return;
> +
> +	if (mask) {
> +		if (ops->irq_mask)
> +			ops->irq_mask(desc);
> +	} else {
> +		if (ops->irq_unmask)
> +			ops->irq_unmask(desc);
> +	}
> +}
> +
> +void platform_msi_mask_irq(struct irq_data *data)
> +{
> +	__platform_msi_desc_mask_unmask_irq(irq_data_get_msi_desc(data), 1);
> +}
> +
> +void platform_msi_unmask_irq(struct irq_data *data)
> +{
> +	__platform_msi_desc_mask_unmask_irq(irq_data_get_msi_desc(data), 0);
> +}

This is a bit convoluted, just call the op directly:

void platform_msi_unmask_irq(struct irq_data *data)
{
	const struct platform_msi_ops *ops = desc->platform.msi_priv_data->ops;

	if (ops->irq_unmask)
		ops->irq_unmask(desc);
}

> diff --git a/include/linux/msi.h b/include/linux/msi.h
> index 7f6a8eb51aca..1da97f905720 100644
> +++ b/include/linux/msi.h
> @@ -323,9 +323,13 @@ enum {
>  
>  /*
>   * platform_msi_ops - Callbacks for platform MSI ops
> + * @irq_mask:   mask an interrupt source
> + * @irq_unmask: unmask an interrupt source
>   * @write_msg:	write message content
>   */
>  struct platform_msi_ops {
> +	unsigned int            (*irq_mask)(struct msi_desc *desc);
> +	unsigned int            (*irq_unmask)(struct msi_desc *desc);

Why do these functions return things if the only call site throws it
away?

Jason
