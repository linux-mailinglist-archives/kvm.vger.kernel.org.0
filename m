Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4FD4B5054
	for <lists+kvm@lfdr.de>; Mon, 14 Feb 2022 13:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353263AbiBNMi4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Feb 2022 07:38:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiBNMiz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Feb 2022 07:38:55 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519654A907;
        Mon, 14 Feb 2022 04:38:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yo4GOymmXieHNDBOiy1ir4bkar2fkvMhsRDPopX6s+P1FNmL5+FdhixNjO1IvlPZSKYC/L+bnvf+l0at5cfno4rUu/HBFMSt6CpWQf49Nrw3Ytnpei5ccICqE0LsEfq3V7WcphGsHSyKjN58bnnKG1tTa9hbQ6sSHJd/6fAHXqdbuMw3tlj050t01J9uRlKEI8nz0VnfufS8/ZmftxzKBuzrEp4c1b3jM3FDxXdxB+9KyHA+7AGtM6JQLqnafC++N+Z8l0wNmoKE7fbiqq5wOkS+oeKgYmKFzYYI32Bt3TcDJ5HwI7nTRqyvNTtNftyYNM7X4IT8oSx3zaRvpSJ08Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6UowyYfDMa5djVyTqLWTcSexa93nMb24ExQfR/9HZj8=;
 b=nuYaLrVP07gf60whA6jnclkC4MAM7Sr3BRDUBeB7LEAMcAkRJ2QwuR7doZKixkxpo3t5Ai5iV4LBQpqxEfZ+npkY8Ata1I/Gn+e6N6M/WJXJ7kWuhvB09pooMYjeGZf+tNr4i4zEOKmJPHh5/uhW4AAv0ofFUIJeOaqyltCO/iZ61suiB+hqY4QBz1NCTPdDBpu2lX/ysQhm5PrqU/a7zCX2zgJgzW8f2lIxrxUimwkdvEr2lC4sqKVR+6otZ/c+dLfYfF3YVcauVOgIXWVvhcVyjabJDc+3R3AQuPI3L4AaxnCxEQkTNJWgHYuvbalQKoIEGpC6l8TGQhudq9ueiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6UowyYfDMa5djVyTqLWTcSexa93nMb24ExQfR/9HZj8=;
 b=c239871tVJBblcZe2EMPfXSZBE17t+qQnELEdfNzTn9aOYbtBj+m20fmq+GDOK592RKlZb2NMrrh3X118uqgqMdVZNuG5SmYM3yPacBkOM2W0UaR2Q7C330XtHMZwNLYjMe3vP+qpD4Rlg4VmpCx8BUBGlk9AfNh0/eqdifp6I4WA30HP6s2lLcxkaftFKlPMGpbOjWBjk+xAwy735EV/J+Wth6RRgYOE+v2vbdvsv2TDqx7X8fZZOiVAR7ZI+thTQJj2Eu/9BZD0zhF3PDoOv4rGUifShh/A+UxFss4wVxkwAZ+EVoSX5N/+SmDiH1C8o7EZE3CLKNWMOQK5tQXrw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN8PR12MB3281.namprd12.prod.outlook.com (2603:10b6:408:6e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.17; Mon, 14 Feb
 2022 12:38:44 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.019; Mon, 14 Feb 2022
 12:38:44 +0000
Date:   Mon, 14 Feb 2022 08:38:42 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Dan Williams <dan.j.williams@intel.com>, rafael@kernel.org,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Liu Yi L <yi.l.liu@intel.com>,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Stuart Yoder <stuyoder@gmail.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Li Yang <leoyang.li@nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 07/14] PCI: Add driver dma ownership management
Message-ID: <20220214123842.GT4160@nvidia.com>
References: <20220104015644.2294354-1-baolu.lu@linux.intel.com>
 <20220104015644.2294354-8-baolu.lu@linux.intel.com>
 <Ygoo/lCt/G6tWDz9@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ygoo/lCt/G6tWDz9@kroah.com>
X-ClientProxiedBy: BL1PR13CA0157.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::12) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56129559-4e88-49a7-4b32-08d9efb6efce
X-MS-TrafficTypeDiagnostic: BN8PR12MB3281:EE_
X-Microsoft-Antispam-PRVS: <BN8PR12MB3281AC13E08B83DF5F1E8F74C2339@BN8PR12MB3281.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ToTogupOe/bL6wQ4YSMGlc5GISR43WD00Ws6GpprMVg43+K677AvmVVLA5zdqUfYQ+V1JmeJJNzGEX5OHwDSqu73F6tulWqEn5VZmQh5NNiW2IREQEu+bmslEhfTC3gZkXosO674ou3UAB4mthpPhkfqU3FmGv5E7FVWm+vTqbjh5e7ASx4cUMK4OlyK7eaab4QqTZhoko6Rl0e31FUF7aIovtDs9e0IXYaNb9SOcUrUjSAamX5N2OrLP7FnIA7cQp52ZdtfN6tw2TDCyvbTt199AwxK+nU1G9PCJYDA5d4xVlesm3Rw288TtRgNK9f4V6htcRMfxKtiilIebGtGBh2GkDCf/vQ83OXBKKldXKLGLu7dPjnmkGODLp1cjqbzezkExe7OfZri3jPvv79QSRY/CjIItY+moY9PyZW6+6S5XtxChimiCJGdtKtqeJgbpGm74UNqVuB8qImLALmzHa+sZFBhTDvPCjQav6wGLzUysX4PJvVhJeSHySqGWjxolrCeHnLB5uFalSFcsaQ2LkriEDoIig0ujm8hMr0QcWIaqPvqLOVmwnnOqgfVKlRGfP2ObRSRK7H/JIZJKj8Clh+hY4xS8qHTnmEe3apWYxexP/rfjXsd5Wq9Z+TgKiA+FxkkG1k/73KZ73S+EnMN2Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(316002)(38100700002)(36756003)(2616005)(6486002)(66556008)(66476007)(4326008)(6916009)(33656002)(186003)(1076003)(26005)(7416002)(6512007)(2906002)(86362001)(54906003)(508600001)(83380400001)(5660300002)(8936002)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tpo9Ob3LOddrzZFjC6Sh7G7U13aG2tiUlrhnesoXuMnS7m2PyKfbizFQC91S?=
 =?us-ascii?Q?OlPWqBVt/nxrnY4EvUURqJEqbYyhesXCrHkz5Ab/9Sdvrb/v+Xnzgtf7Dm/q?=
 =?us-ascii?Q?ONXEBUqUFQDDSEEuhWq+JlrACZxZl/HkQ0amRr14Fl7tIr5/CVieuRWFkD98?=
 =?us-ascii?Q?bkUv9d3Rn0OnmGu8xJagXsKo+KHs1ztYypPNucC8cXa9Tc9BGXisYedWRU5w?=
 =?us-ascii?Q?8Ol2LiUzRn0VO7wLxdozkf0cSA6GwC5Ul21Z00ubkOYjFmPOrYbm+wdKEXUC?=
 =?us-ascii?Q?DivPuO5keeKNWKF0SGdkikdlqxOgHV5L6OkpXbXKGS6TjSkfar5AVRL5HEsd?=
 =?us-ascii?Q?WtvNCEnD/17Jnf4NlTC2Ee8dJtjx8ev/ux4cgf68btwEAbK0SZWn6RP2pM9f?=
 =?us-ascii?Q?wH58eaALSlUlHrXopc9lvi1U+vedwFRZ62gQ06wrqg0777916anMsvnj7i2A?=
 =?us-ascii?Q?JmqFmYVolRg/jZ6/HWm+UCcUDQjhTNHxSSemaxFuXG4BfMp52D7KoTrKsg/0?=
 =?us-ascii?Q?hj7PdphzlVQcCsGXj6BCNpJg0bBCyYToBcV3X7IcBRD3NmUkokR+aMgEQIE3?=
 =?us-ascii?Q?ffaE6bCGc18uGT3XZLhLj8+4aFUxUbxuPfJYHNGY5M8Y6KNBd79u0wDHkCsC?=
 =?us-ascii?Q?pqPqDoQBY5vMevV2MG2ximK/hU764HdR+ignbn0AxBnnfRyZr8oPaRqFTIbC?=
 =?us-ascii?Q?hUK0DCNHhX0w11Ui+lb6MEMOa3jkzTlpAa7dyCcYToN2O3I3DYSI669OyRKn?=
 =?us-ascii?Q?FkDt0sleSZCqb3/MzvEXlbDQpp0QcOfDui51Gc0tY+HOXpaC870PA5uJST3k?=
 =?us-ascii?Q?kR8cA84K/kEu28m8sjF2NqbX0Jx/mOFm5bigZQE85Wl6XnqNYGr2Z/MUYdWB?=
 =?us-ascii?Q?yjEOeSh4Cogu2o2xFvn7QeyYnoJpOUdD+87aXQsiM0IyE74dmLa00p1N1AdS?=
 =?us-ascii?Q?jowHMOpITe7OWfb895/tozwLRcUfXhuzqpppgSQP52mAN/VhSAjFICMXPgM9?=
 =?us-ascii?Q?J1oPrfr5hFnHJJdf3InMbzOCr9bJWZz44BjN1znPLtxcrj0fRJ217Pa/VL+H?=
 =?us-ascii?Q?MFxm6kh4oXBsEKkmD692OniIAasyNvRFlwoGmfz0W6yAupAN5Sw4lJW3pE5T?=
 =?us-ascii?Q?e8BQHe0hd1Ej2yROF6v+OO8s+COWt7rtJR3iu/ZC5VzUdKqVtSDPAZBfEyJz?=
 =?us-ascii?Q?UAX8zhu+X+vhegj4SuizckBEyt6tOIE2ugpQohuC9+Qj6oBxf8yVx/QDlbXa?=
 =?us-ascii?Q?laxHI2jjIb6OUOMc2SCwnixTpkUVK5EAHoDrOWJkOOUlXBTY34eySo1yDCbt?=
 =?us-ascii?Q?ly+5GaH19ocZWt45CnLhYwfxSRlpg36s0IzOeh9igo9tOp0VNL/HhI18uwbJ?=
 =?us-ascii?Q?2AVwqxxLalVUNFUFOsgFGoPJXsCg6CzyzXAR/K9bxcB3Z+CHt14ayHTXil+T?=
 =?us-ascii?Q?mJk/DtOgmN2oRx70AQ70bMGi6Klzdpx546npGOtwNtfmjnlwIgiut5rjLIOO?=
 =?us-ascii?Q?L0zS22nmXwV0NxzWCAIWjVdT4Hbv4+pqFqjRB5hMgzq5WyfubBYsC08Y2Ui7?=
 =?us-ascii?Q?7MuF1zrtm9EMWiHYwGE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56129559-4e88-49a7-4b32-08d9efb6efce
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 12:38:44.0214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s7YFnp60sVvc6xrFUvaDXnspeYKWVJrVHx5Ux6YZCcyySQEex0XcWUua+HbBL1dM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3281
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 14, 2022 at 11:03:42AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 04, 2022 at 09:56:37AM +0800, Lu Baolu wrote:
> > Multiple PCI devices may be placed in the same IOMMU group because
> > they cannot be isolated from each other. These devices must either be
> > entirely under kernel control or userspace control, never a mixture. This
> > checks and sets DMA ownership during driver binding, and release the
> > ownership during driver unbinding.
> > 
> > The device driver may set a new flag (no_kernel_api_dma) to skip calling
> > iommu_device_use_dma_api() during the binding process. For instance, the
> > userspace framework drivers (vfio etc.) which need to manually claim
> > their own dma ownership when assigning the device to userspace.
> > 
> > Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> >  include/linux/pci.h      |  5 +++++
> >  drivers/pci/pci-driver.c | 21 +++++++++++++++++++++
> >  2 files changed, 26 insertions(+)
> > 
> > diff --git a/include/linux/pci.h b/include/linux/pci.h
> > index 18a75c8e615c..d29a990e3f02 100644
> > +++ b/include/linux/pci.h
> > @@ -882,6 +882,10 @@ struct module;
> >   *              created once it is bound to the driver.
> >   * @driver:	Driver model structure.
> >   * @dynids:	List of dynamically added device IDs.
> > + * @no_kernel_api_dma: Device driver doesn't use kernel DMA API for DMA.
> > + *		Drivers which don't require DMA or want to manually claim the
> > + *		owner type (e.g. userspace driver frameworks) could set this
> > + *		flag.
> 
> Again with the bikeshedding, but this name is a bit odd.  Of course it's
> in the kernel, this is all kernel code, so you can drop that.  And
> again, "negative" flags are rough.  So maybe just "prevent_dma"?

That is misleading too, it is not that DMA is prevented, but that the
kernel's dma_api has not been setup.

Though I agree the name as-is isn't great, I think the comment is good.

Jason
