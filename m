Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD864C1AA7
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 19:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243773AbiBWSIb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 13:08:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238559AbiBWSI3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 13:08:29 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08on2077.outbound.protection.outlook.com [40.107.102.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA11547AD5;
        Wed, 23 Feb 2022 10:08:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dkC0aavrr/txrYm1kSFZT6z+MM6GNp6VG1MtJSQVVt7Er8Pv0uWNDjXg3LE54+F/0dT81o8QgW6J9nF+wQn/wWdhPuBlm2AUieROcuxyjnqIDMKiKtJZgUCViBuEz9IBCG9WM0vMLmlL1UzyESvD+TBxZZgJ+fmFwyir3zxseZYx0PwHzCt8/zStWUbTv8jO6+gz1AcCi77utJjBWw6t5oEbfRFJCV7nLYZQWNwNmbOVtLGNCFR5cadpJ5aXP/z8YCMlMbcGHcHKbfD7FaEqWZSkVCizbFVDVH4qbigq9keeACZtnXioPOmPUsBkhkxYqcsXA5XqF8RFXTrMf0fACA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=12Hz9js7KDfbI5QSDLHQIcZLBTn7JHgz3yGlgqSjU44=;
 b=VuBhiyxBS3n7YNr46pzIIEdBN38BVre4GgzhsO3dyrI6s0884YRo/0I+QolNkX3/GlnwPiAyQtg6uaBhTc9I6mGH7encxwU2HNj/CaCyCLnwSuivqfNKspMcAFAo8Wn+GOb6/8jg1N6CWDTwgWxCoSYvFSrno9roniq6z5sjbbabyyvWAjQsE0qIV6oTU9ssE9ArcEzqKaNFeX1Ru19sM0Rv+zjjk1N6n3NRfcaNrcoq/RnNenag4rgKmcIGLF1VGha3Q0QkqhSvxqVfmLRzWSk2STUVodvKGQNTDzD/p7XOADfA2RaNtpPFcz1jrQUR1/q24KMCYWsB+RdVformNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=12Hz9js7KDfbI5QSDLHQIcZLBTn7JHgz3yGlgqSjU44=;
 b=jQNPUlSWGS7kDnOfrb3sNt9CBjL1pVIySVS1Kop4QKQ815ljYP+1Ld29cXIR1AJpd9qHHnFB4TP7nMmQrjMqhvMiZhVU9vhdNQNpsCxoYdlOFrejy0T842DSxYuJWVJebQGrbQr/nPPKcK/tF7S7WGewTr1zlWi5RCFbrzM8fIcwjU2CvuXKgloop9YkSjNQJMDw8XunYkynswTth97A8CIEAuGMhwtWbtkGF2nfRo/ZzBxNV35lntfqEVpzezq0QJ/yi72HQBl5thGWt8lQKt/y19lLagryJy9sat6L0VcMpj894HHY5lY4hMpjiV72I0z77CIyU8lPk9qRY77VZQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by LV2PR12MB5725.namprd12.prod.outlook.com (2603:10b6:408:17f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 18:07:59 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 18:07:59 +0000
Date:   Wed, 23 Feb 2022 14:07:57 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, kvm@vger.kernel.org,
        rafael@kernel.org, David Airlie <airlied@linux.ie>,
        linux-pci@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Dmitry Osipenko <digetx@gmail.com>,
        Will Deacon <will@kernel.org>,
        Stuart Yoder <stuyoder@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Cornelia Huck <cohuck@redhat.com>,
        linux-kernel@vger.kernel.org, Li Yang <leoyang.li@nxp.com>,
        iommu@lists.linux-foundation.org,
        Jacob jun Pan <jacob.jun.pan@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v5 07/14] PCI: Add driver dma ownership management
Message-ID: <20220223180757.GB390403@nvidia.com>
References: <20220104015644.2294354-8-baolu.lu@linux.intel.com>
 <20220223180056.GA140951@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220223180056.GA140951@bhelgaas>
X-ClientProxiedBy: MN2PR16CA0052.namprd16.prod.outlook.com
 (2603:10b6:208:234::21) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e020f4bc-2242-4e41-4156-08d9f6f76c8f
X-MS-TrafficTypeDiagnostic: LV2PR12MB5725:EE_
X-Microsoft-Antispam-PRVS: <LV2PR12MB572525E9478A3A3C4A7949ECC23C9@LV2PR12MB5725.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: olCHE8zc5XfLcbu6uOnuY2LCz0rqHzRBcN0nNvenC3VnvYH1UCbiT2qcRA5iKuEOCvOQtEM3B7lcKg8RL3Drmps/XR/PQjG3RXOve6rQ18RYdaokDhkp2LCzI6V1B2lnQ0M0WKYIkTIQ/QDOf0GBNWr0DsVsCl0TFYV29tsUCJmteb6B2FzZZU/xvGOIrZLvfJ7HP0pDg/Ii+1jeriwpfoOPWeHk5jOUDF3Xo2ZB+2ok/bCAfuYZi3YqMeqrZLGtM99tqNJ/SWt+68im13YfTbpeC9FYGmhzqlzdrdT1hQ/AbRa1BwKO5+iAkDrt3sYj2qNAeLBHtIr4m4/jnNSX3L23m6ZelTgLXl2MlYGKLQpubEYSqsddzt4WwbEDjdBZJwwwZXBqRDJ/3S5zqe8y3hKPXiTSXyPgau5D+Qu2WKIkgXQGceC+7G5QlgKusmM4XCjulHtUfx3k0VdaAbjcFPi4sMTy7BsYDe3Vzv/9xB3KA3gEErTMFYp8hssd6LljSRh8HmCBWQAQGgasGc8jAaChUU4CmzswO6cJ85K4nQ7bXPZGNAX+z70vLoiCqWADE+Ul29XUnTtrdbkVw50PlKCsgiknRLP9SZHrHGMI2S5NB2w1F/z15Y6n76VvY4FVZDBYwtS8viJ7MtHSE1Q9RUSeoaJUCWUj3AMPm9v5t+iHp47v+nvkYU6aNLZVFOCWmICxr+gFP3pwZ0BqABfjMoBEQty0YwYPQDN4mzN+anjL7j/85C7FhkLO0oi3hFnOjg5gckECFNB9Wmm6DmV7v+mVRUM//TYEUxxCF5+IzUE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(7416002)(66946007)(5660300002)(33656002)(66476007)(66556008)(4744005)(36756003)(8936002)(8676002)(4326008)(2906002)(86362001)(316002)(2616005)(6506007)(508600001)(6486002)(966005)(186003)(6512007)(26005)(6916009)(54906003)(1076003)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FpbtMjuatORMwTaEvelmoGxuApSepVwQVRBv44uAKW8Xz/5Zos3Pc0EtP250?=
 =?us-ascii?Q?9YYupISDh+BCK82gZtWvylaBH7HMihGcyY0y/C9oU0SWdAgZf9Xplhvp7zgs?=
 =?us-ascii?Q?9cVTpq2sm1e5hdjMoFCk8mhVk0fvh3xRTAia1nkSflhCVUCLCIII08ozkJg7?=
 =?us-ascii?Q?Nvy7IDdbH7Ic+ykhqFRIYliqJ6Fcpg4Ytf7MyKJoyOQYh51UuRaJbbWYAqXg?=
 =?us-ascii?Q?9komUfbUy6GHJKFn/6CzOegvuoZ1FpFBLroD0b1gAaYnfy4QjB6/wnbqzX/8?=
 =?us-ascii?Q?UcfuV9rX4UcsQSo6DjxOo+NrU5VVbi1M6EfjMGVqCSy+IeqnymSJlcIW5BNL?=
 =?us-ascii?Q?AyGywc7wPPAOVUSaqwdWZbuns4XznogVkQVHlccV7JLZCWTQ6XjoG/llnrhi?=
 =?us-ascii?Q?0l7JUdbiYrYPTefePoktO3mz6AF0RHto5IMFR5WFimMembNkuQu3OCOE2/ST?=
 =?us-ascii?Q?6KGIhzdj2sHM3aPrG9YIVSRhuUxc5gcq3wOwXu+xqA+OjoPEbQgtm9n8e9vH?=
 =?us-ascii?Q?9S3L7GqCMgmQPlG/3XgxRW63mMVrp1ZA+o8hze7d8acr4kTluP3Toyan0CIH?=
 =?us-ascii?Q?G1GWv7vKw3gG0t9mUsU0FBUqTErR0LwveGWeBmkoatU7nbX0UM4oZ9ifjJ1t?=
 =?us-ascii?Q?CJeuaZqJ5/ItT2AEx8z9kFIUcpnQQtNLI/8J5rXROg2DJA8xNIy2AAIw37EG?=
 =?us-ascii?Q?7Sppv0WcKgCtjNuixesWJd1l5lkAvfOhEKWIpRF24S8ubbFZSpcDwkkttYXl?=
 =?us-ascii?Q?jpYS0Hge8YDWTi1/P1vPgmzDhpKEoekg/WCbDEotszvGFa+EneMXmUMoCIhn?=
 =?us-ascii?Q?4kNC9IDucqn4iuGJtsOtAAWQIY8+bmS+LwmcQUf9a7eeMOHRQFJsd1sp3tdZ?=
 =?us-ascii?Q?ZlmJhEKSNgEp1DR6uq9z023ijFgbbVwJ0T9s+WS0aS5nQKVRcUkw9bbonvEN?=
 =?us-ascii?Q?/MM3mJ4gwSPYhxjaZo1XuM/ni2/LpHb0/iyuzQt2+qKcSUVR6/R5Jn0kfDSo?=
 =?us-ascii?Q?/iQdpg73iotuMRkA0jg7vLyNsc9dNTelOB3nSnASeNMM9j3nHu9S/j/mdBmw?=
 =?us-ascii?Q?gHGlk2StTLZUPVbVCQG0U4IeH/Go+ifsTpMTDdqHHrmO2gAHYE7/v6DS1U3e?=
 =?us-ascii?Q?YWCKDctmyLiVEkI2gyRbsAX+hcXvXTu6thW0WyyZ6r4EAoJSTFhyktUUYi2c?=
 =?us-ascii?Q?NfokRVDnm81Cjo0mNn6DHFsvzFYTblBpgFNuffzUTRRXaCGREjrN5fFUWQhE?=
 =?us-ascii?Q?KubamzMk26eDUbnf/Kw+u0SvkHRTrAVoPBD1qVt4Z6B56e+0NsTqvABI1x/8?=
 =?us-ascii?Q?Ydi5kyqh0R+cOpmpLUZbgtVZ8tmXazvbo35BpEQ/Ewnh/ISkgmtQsQhw14Nn?=
 =?us-ascii?Q?GijK1yn9VriRk3Tu5nmb0nEAUGRswuVkQRGI179TVib7ORFzanH3L6da6pnJ?=
 =?us-ascii?Q?ZMJCYGuBnD9UfFDKqAvcq+hgAOhIzWmo6Z7e86mPn/VDd8pmhhwKER2CVMCc?=
 =?us-ascii?Q?DPvgCtURiVzBr0zAWBsXTTLvjVAlxqZjtIjml+KXb2NmJXxSEq78HVszfKzv?=
 =?us-ascii?Q?RlMt2PbQnt9tAs8/tbw=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e020f4bc-2242-4e41-4156-08d9f6f76c8f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 18:07:58.9412
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GmAVWC6BLRA3EJEt028YJBmDgnrlnHE8aThiPJ7BzZ41BcfJs9flCwQqriVOKniR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5725
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 12:00:56PM -0600, Bjorn Helgaas wrote:

> >  static int pci_dma_configure(struct device *dev)
> >  {
> > +	struct pci_driver *driver = to_pci_driver(dev->driver);
> >  	struct device *bridge;
> >  	int ret = 0;
> >  
> > +	if (!driver->no_kernel_api_dma) {
> 
> Ugh.  Double negative, totally agree this needs a better name that
> reverses the sense.  Every place you use it, you negate it again.

Greg came up with driver_managed_dma which is in the v6 version:

https://lore.kernel.org/all/20220218005521.172832-5-baolu.lu@linux.intel.com/

Thanks,
Jason
