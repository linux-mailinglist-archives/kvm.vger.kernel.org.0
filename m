Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3A272E940
	for <lists+kvm@lfdr.de>; Tue, 13 Jun 2023 19:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238243AbjFMRTc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jun 2023 13:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238578AbjFMRTZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Jun 2023 13:19:25 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A30C1BD7;
        Tue, 13 Jun 2023 10:19:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S5Ze9vq5fdzUEMtEMQUmHsmWLyaWoWR6hx++4ntrrpdlYAwvF1spFYtsRNhZd+1zsWnez6Av3Zo30iVq7slgoUEM11+1xik/ZDPWTM0VpJgxHksEvgwreDgzVaiJTZRFG9NHtPB++spfdN0TZ45TX3BWwRPd965LLR27yFBSU6WLH4FkTYUjUf9VIFBmhzjv79B188Afm04eMCnjg812Bf9SX98TJoPSCOQK4UpIhAQv4ipNoeTlWdEIRYxcvVlpTpqSBkxnpnriwAKRKnXFGr7JAnU9j1JfVMFzB7JjwIBfvwFy0XJDZYDc8581XSun8fnF4gNwnckEhLmhcfrrgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MiHpt4wGrwxfPLRKG9n1lxQlm1FUR5bXALPlMSwo0oE=;
 b=YGPnmaZ3NphcA1gxRk4zCfayCSJJhs1n2AbYNDpBmpba8Wg7OZ0Vgxv99PABE3nPvXlqqEZLTiZcM0aUvHq2u3N9lNKSfdSFZI2blkUKquMzhBfUqJbfKM8KauLUrOEbGKFyZwIZyXlt+qKYqHJf1wIvHei3Bkg9+soDA3vlFjumbtZoZr0KxJGCBVodlzf6OB7qfE5CbXTVYZjeJUSU+bh5wmN4nUwrEzqUsn+pimcu90TrKGcN1GXyKc9w48gzC75v/dw3wYF4wPgMaisOb0jjODijae9FQV4EEaSNrsnXeduiPOqXzZXMWUjFw/IUCQAzpv5O3WSfdUD4PPSq/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MiHpt4wGrwxfPLRKG9n1lxQlm1FUR5bXALPlMSwo0oE=;
 b=eDXpRaoSjDCofJpHhkgMQVycfZYArDdSC3Yboi06R8Hipf4xqhHC77MJiV7Pko+d5K7oQYbXeB/+onUsOpTl0Sm24qLdT9DGPRZhQ26lQljybe40+Rw5VR9Gi0I7axiIWH+3kjJXujFBZNF6qpwz/LW6xMAx0VT+zT5Lokp2qnJOxbRPXGglM/UjlfM7Du1ccvpMnr90reSnT/sVNJwnXUV25U7CSJkCJ1+JgcxuM1fHhAi23G6QRJfi3PxDpZ2/rvzKjHgt8KDfgliINB+8vF1jB/lYVEzLs5hrVx6AnHDjcu4zYmxN4UIUq5Ei7SRyXVgucBiWRx7XlYCgJO7jnw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by CH2PR12MB4860.namprd12.prod.outlook.com (2603:10b6:610:6c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 17:19:19 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6455.030; Tue, 13 Jun 2023
 17:19:19 +0000
Date:   Tue, 13 Jun 2023 14:19:17 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mjrosato@linux.ibm.com" <mjrosato@linux.ibm.com>,
        "chao.p.peng@linux.intel.com" <chao.p.peng@linux.intel.com>,
        "yi.y.sun@linux.intel.com" <yi.y.sun@linux.intel.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "suravee.suthikulpanit@amd.com" <suravee.suthikulpanit@amd.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "Hao, Xudong" <xudong.hao@intel.com>,
        "Zhao, Yan Y" <yan.y.zhao@intel.com>,
        "Xu, Terrence" <terrence.xu@intel.com>,
        "Jiang, Yanting" <yanting.jiang@intel.com>,
        "Duan, Zhenzhong" <zhenzhong.duan@intel.com>,
        "clegoate@redhat.com" <clegoate@redhat.com>
Subject: Re: [PATCH v12 07/24] vfio: Block device access via device fd until
 device is opened
Message-ID: <ZIilFVb3sKnBgH2F@nvidia.com>
References: <20230602121653.80017-1-yi.l.liu@intel.com>
 <20230602121653.80017-8-yi.l.liu@intel.com>
 <20230612155210.5fd3579f.alex.williamson@redhat.com>
 <DS0PR11MB75293327BDE6D268996FFFCCC355A@DS0PR11MB7529.namprd11.prod.outlook.com>
 <20230613081647.740f5217.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613081647.740f5217.alex.williamson@redhat.com>
X-ClientProxiedBy: CH0P223CA0023.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:610:116::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|CH2PR12MB4860:EE_
X-MS-Office365-Filtering-Correlation-Id: b28267c3-500d-41cc-5c53-08db6c325297
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sVjSneo+Qj83b8YdVa0wRRB5ab+ea6ee/Kxq0qVKorYK2wVE4+s5j49PSf9OQ1aJUjck+TrxT9r0QvhTQD5NpCY+7iaHbNs2bpbTMNuuWW8Hy8PO+arYQDBnHeGy0dX1gpw26eRb975KyRUmwbjJEB9fF85jnTLBRdczWWuxmUG31zEXV6Y7UQJFiF0HDUI917hSQt0HNSFisZGrvzVqaHvHCfOCUr9dexAkI/pJivpMrxlz0GAp70IDZxWv6qnTEzltxzNAlxTwPZ6qtCCyi7t6LfvapordvHI8PLYjEQdhtImZQUKFIBp7aUbP6Xxj41uX3b3K1OP73uoiC9Umfq+dQuIPzFCXl8IxKT2LGQj1ED0X1wV0eCQ1kw7A7/+bGvJw+jWkg2XEPX02JiPmOixdNsxqfGxuSACUygMhIwbGKGOyu+uo1OQYzPrhYSM9ljZhnvpjHqWwIeQfgHhFZYJNRKFg1XseZ/GKOktZGL6TKwQpL1fBMvPjz0v5ZrryPifADVUJfEuVyv5gesPoQZRecLM3jKFA9urDqmZ0lxGVQPhj1o5ROUcF6dQBuj4y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(7416002)(5660300002)(8676002)(4744005)(2906002)(8936002)(66556008)(66476007)(66946007)(54906003)(6486002)(4326008)(26005)(6506007)(6512007)(41300700001)(186003)(316002)(6916009)(83380400001)(2616005)(478600001)(36756003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yy8ZFNp5CMPkyri3cVVYik9Jdq/gq/bfVUzgZoOT3z+9wGC+Fh+Unr2HOXI2?=
 =?us-ascii?Q?v8KcwK/VAvZgTyVelMdVooLtlu0eUyZKQ9J7B8lShLM1DWgurSwjyF00CeCB?=
 =?us-ascii?Q?IAn6sJ1UvmCRzvnf6m1+S5RX0eQpdmGXK8scOebG6ZlFVywA/icUtleLXD5z?=
 =?us-ascii?Q?rWPbZPRY0IFeyi/RiP2v9VuuJdm5pMIRo48lxUe+D0i76Yf1vFnl2BdyrWrr?=
 =?us-ascii?Q?Yu7WM2OW2N4TnBrN07H5BAcDSg0oJql2TOKXt5iHTYXKJgK5buow2MUqkTK/?=
 =?us-ascii?Q?bc6+2Kl+SEh6Hy94tl8qjhCVJSbNKCQRuOI28GBYl6R+OKpCe2tGnhuAbe3+?=
 =?us-ascii?Q?3m6nkT0fjd2ABEiU8jlKcneFIzmXQvtV2fm/d9u4RDXMBHta4pJKVi1urVz+?=
 =?us-ascii?Q?D5Mo7xoXP0H4f83KdfB+m6mROLM3zGvSTovdCZiRp/W8mooV2uosJZjfZ7Xu?=
 =?us-ascii?Q?pTP9rikJYu6dHm+dk6yUsIL+rnX9ywxoZYXR2FOCrZavtKNE5SQtjUxcs/cr?=
 =?us-ascii?Q?r6DFqAJRCiPqWAqw49ejDCKiEo+R/MHgtAtjSY5bNj6G1rsSDoU84cL9vh1x?=
 =?us-ascii?Q?bla/8kQ1lC/DbMGHCqFEkUfLG1elx8BhSd+aKfO55V+SKFLjtZqmAE5KhWVN?=
 =?us-ascii?Q?AuYcKfMggXHdvThFKrwZ4NPDeF7sBwSTBGcKVm8GUlRiC38X3vv4gpoyDd9L?=
 =?us-ascii?Q?/45VuOdLH8Umygn52HsiaDSo7m2AzX3AjRP93y1nAnCEAOwQvx1MzK03iM5y?=
 =?us-ascii?Q?L138j5UYBHs/cxV/nDSWevepzn0AUU0Sd4snLwC0ytGuJiAbxnUypvj55c1H?=
 =?us-ascii?Q?B9j9Vgr5OUKTXaE4e++CjRi/HHGGj2XJLBcOnsGNWCmtRch+e55qfrDnhjQe?=
 =?us-ascii?Q?zwiY3ghiqNKG/RvNHnQFwrear7iVdkL+kFyBVhJY+/R5NMQ+KxYktcAqAQL8?=
 =?us-ascii?Q?hlCaCbY3YDgBj/fWGENkxbNfxWlRJvH5CEDWJwQklCldeI7Q2O16bz16T+Z4?=
 =?us-ascii?Q?E7P0b0dKq+uzwLKiNQejNVpW1fx4qoPaSieX8A/Z2zmRTL6bkCaitYkDRaTf?=
 =?us-ascii?Q?AbXeixdwxU12jx1mlTXqGcTCNJ+lw0RC2nfycXuJYY0ApjQh7ZWjkTpx4agL?=
 =?us-ascii?Q?G76grBIb01wY5O1SlKTJ1mVdniIEWEnKBnc4xVDh7bQ8E7fdgHE+po7HvG6V?=
 =?us-ascii?Q?Ot1+Y53LpUp3MnneAOX2fFQVqvai+BLVyD+VPMn80NY5zbZXEZFPxWbvpKVX?=
 =?us-ascii?Q?YhY1WLk7zMZXh2LlLBGgAvFQEGIdSOSjWBbt14cCJhGNKHwSWGhDz08iytpK?=
 =?us-ascii?Q?fNAt+jLZI2xiuNQUaj5DV7vYb7Q+nl0vCaNFdaSOt6wIcI6gfM+spqG6kEGl?=
 =?us-ascii?Q?q92TKVoyvSeqMEQQSPU+C+3qnqixE9Hakf+Wh8zSPMBryHSI0Ub0s/lnO6Qn?=
 =?us-ascii?Q?8lZS1sDZ70c84hz4GHoXK73/Pm1kbshaASRElH3zs2v920REhcD6Pp4NpHHa?=
 =?us-ascii?Q?D2ZUq67XkqLZFzsN+dGCVDAj2oPxlfo4QjjjVKaHcsMIidONb0yrV1orGkao?=
 =?us-ascii?Q?vd9cocJlSkhDmS858S53RXqCjZFZo0uvb4llhEgd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b28267c3-500d-41cc-5c53-08db6c325297
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 17:19:19.6731
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fMlUgCqIaqNVRwlF8a+N5fIe5o+EEN9I/y8rCnm5K0UxQamQr58Sazmj9XoKeNAG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4860
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 13, 2023 at 08:16:47AM -0600, Alex Williamson wrote:

> > Not quite get why bit field is going to be incompatible with smp
> > lockless operations. Could you elaborate a bit? And should I define
> > the access_granted as u8 or "u8:1"?
> 
> Perhaps FUD on my part, but load-acquire type operations have specific
> semantics and it's not clear to me that they interest with compiler
> generated bit operations.  Thanks,

They won't compile if you target bit ops, you can't take the address
of a bitfield.

Jason
