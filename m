Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC664C149A
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 14:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240070AbiBWNrj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 08:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiBWNr2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 08:47:28 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2079.outbound.protection.outlook.com [40.107.93.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C3539164;
        Wed, 23 Feb 2022 05:46:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJUGSOnWXMqEzx4OXideF9+ZgNeb00LzfMdFm5scf9oFJ6kFdtFrjKLx3V3D09/RrYy8YSSOu6nOj8Q6LxSL1BThjm8ycGitJTyXn18NfdmvRHwZ62i4R+iPu1awl3oz1no29u57fZEkJ3cvdrPwoQiAgKdsX5E2BmMWXXIfv60PZKt5w6Uq6FahtFxCPr98iK4RYemPqtxVt5EXin1m+aBm3n5zsYRLZBBL5z1ae4bT/Q1O2Fc8pdh+H4f+bSd1Ul8al8tMtgjFROFEq+N4t9iHBNUF3V7A+BZMtfzWl+iK8nii41jtn9sxxokzpJB+pOGY1MtDhHtVmtjsAmitRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=thEHpirLVEQ0YwdRNhWoYkoqnfDeqNSncBKrAQj6pE0=;
 b=M4xFCybJ3NnBw79XOVmsU24LnXkwmS2MX441G/3kBw/78QoBONZJ24wXOTJ32qPo8y7OC2Eem1lvzj5WtZ/Cg+/23M51I0y068EeI+qSt84YHqWKketQV8fPwnMTCX6jZwAdb+Fh4RnwHImjRspXyqwzptlLXdCRJRr5LnT9zanw84mxmuY9zV9EZ9EYfSHDDewKradlJw4bh9rqixl8l7r6TkbdTIGNrR87J90diQWDVkfgzTtqu2VbCx6a5Cb7h0hI1lIINHS9jWdZjzcikuyRDCrS3aWikCs+dlec4e/V2+EowhikyeCDqcTH0hKAIgRaIVvgHZaWUyiBPzK1pQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=thEHpirLVEQ0YwdRNhWoYkoqnfDeqNSncBKrAQj6pE0=;
 b=hpqr4DSKXhgTJGr4WX6bNjAXnmlogaO8iq0L8a+X/7dDXryTB4t1+lxVm0ZKlyymJHwLq0E2CckN5tfGKL1Hohkp5+ej2Mbef8xv1lrfmu1xk3BWQxRzOd1S84QV4GlF65JAMa0l9UMYnghS1bc/2/JCGBqPboDOTEibQ5UpvaIMYZc6HZWO1++dQ6sEUpt/gfpr6sDZjE2lzIJSxfq+hVuBMZkwAbg2qdPx+cdC+lAC0O+BUGGPdiXAXEywZCZZmRP1si5SO72VcwiYr56fU5f7lBNzOPNOEkySQ0KSMY9jqF0GT4ARk+Az6S7YkkXTvmbI9+PxYj1zsBmKdxSvhg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1393.namprd12.prod.outlook.com (2603:10b6:404:18::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 13:46:28 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 13:46:28 +0000
Date:   Wed, 23 Feb 2022 09:46:27 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Robin Murphy <robin.murphy@arm.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
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
        Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH v6 02/11] driver core: Add dma_cleanup callback in
 bus_type
Message-ID: <20220223134627.GO10061@nvidia.com>
References: <20220218005521.172832-3-baolu.lu@linux.intel.com>
 <YhCdEmC2lYStmUSL@infradead.org>
 <1d8004d3-1887-4fc7-08d2-0e2ee6b5fdcb@arm.com>
 <20220221234837.GA10061@nvidia.com>
 <1acb8748-8d44-688d-2380-f39ec820776f@arm.com>
 <20220222151632.GB10061@nvidia.com>
 <3d4c3bf1-fed6-f640-dc20-36d667de7461@arm.com>
 <20220222235353.GF10061@nvidia.com>
 <171bec90-5ea6-b35b-f027-1b5e961f5ddf@linux.intel.com>
 <880a269d-d39d-bab3-8d19-b493e874ec99@arm.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <880a269d-d39d-bab3-8d19-b493e874ec99@arm.com>
X-ClientProxiedBy: BL0PR1501CA0003.namprd15.prod.outlook.com
 (2603:10b6:207:17::16) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 371784ef-3f27-468f-901e-08d9f6d2e43c
X-MS-TrafficTypeDiagnostic: BN6PR12MB1393:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1393CC335CC6BC8E4D0D28C4C23C9@BN6PR12MB1393.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j6NtqY99AvgsgRFN+6YGQZJv48EuS546aAWCuTsS0Jd3lYrqJUv42sADRFbi/bzBXUQ7Fe4BGBNchbMJqmGSm59HCp9JgH+tszYdOgbTuvPtX0fXy1LodPviP8pc2DduyMLYs6GVFpXO5FVFSbn6rx4/j+pAvF8mnEahmpn7PAM0fzt3sq4PG7LvBHglAUl3b7kfdwpVmf7sDcRhcyOAs3gaHw86yvz9SGcMTriBxuQncDSROmGnD26IchB3oqh232PNtgqilwGJodTSto+Vr68PVQrlCJVHWioMoKJzgnH+ebtJ/3uInBNpqCSv2Z4itQhQuPN53QItynq/47b9NBNAxaQoUMfHDby9fbQleyO95tuH6JD8veT+oEoy7iPLfFzPs8rvDfBfD9x8RfSTjvBWQ+vnJMJ0ATbfX527ihuxp1W2jlGvEXsycxV7CimeT1p8XqNIgjmkLUJDAVATiaGIyvR5c3Rz8njEwU03d+hn5MNeAO22fWun5+yQ+EJq2gGF/4pBhe0kDlJixYPNjI72+wto14DmvLCONCz103aVbDSyblE71bFpiWHXmpAnvjDf/YDHFBk2pC4CysoEEWQupgfvD1SF4A+B5vqOFT2ocHa0lLi69pShIk/i5GGjHvg46K6PZkRMNyDQUAMF5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(83380400001)(6916009)(4326008)(33656002)(26005)(36756003)(54906003)(6486002)(66556008)(186003)(6506007)(2906002)(66946007)(66476007)(316002)(8936002)(7416002)(508600001)(1076003)(5660300002)(2616005)(38100700002)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BBqOusNyKIjVn5wGeZhNHqaI+gOxqKkC0bOStJ+pX+/hgl54kywWBtutUipr?=
 =?us-ascii?Q?HQTuJhvIegh+XItYPg8sU+k8gfL7EXyAg1SDenI4RhL5Tzqh7DPvKMi7s1sg?=
 =?us-ascii?Q?6voMgOrzfqg14St1++MvX6/Qh0K4Im17i1kswxcgJTWcIyfWQZITsKyu3XnS?=
 =?us-ascii?Q?k6MPBF33xCjO8Rqd8qvukVPhnldqtQCUtBndUHvnFc0ip58tPmX1dZm4cLC1?=
 =?us-ascii?Q?7M6zO5q7EHTRBSUiIMVX8H8eAu3qe7g0LWKNly/gsFP7Ql6nQ9uiMhdjPTwq?=
 =?us-ascii?Q?/aydQ2yHcM9wp366EuUcYCKXHnusQm+3iKnihSofPucV0GOCRxLvkdzUWhve?=
 =?us-ascii?Q?BgBzqXmDcQYkPPe5UzM6Qns72AESqNEPGpAxdFTxLkUPt/wZBUxOyh60jMkh?=
 =?us-ascii?Q?ZNFGfEZqco7btYUAg0/CN8YkTbXIpdVvqvsbZZQVVz41wNffrP7MrACtf/mo?=
 =?us-ascii?Q?EkhyXmIuStiZkYMy7ywh8eF0WR6/44ekxnZZD2BH1HjS51mzrI4PYVVhFl8x?=
 =?us-ascii?Q?xT6plv89tdQ1+CMHygPq7vhuLDjmWpIDOmie87EUv57ylHt7AJhzgmpq88ou?=
 =?us-ascii?Q?vA/DqF0SrhlwOwV7CbKa5x4SEuOzw62uj4h+UGxNSUfwyfBlx+dkO1T/M+g0?=
 =?us-ascii?Q?okrKw+WLGH6sGoqBdx/R/OFYZEnqIb/fpvda1NBI6YB8aw6M1Ym/HGLYgQrN?=
 =?us-ascii?Q?0HvFnxqLt1IbzceeZEWNnrVtCgFCzDxpaIoyH6SHV7KQOHVw6b5XaCsqtWAi?=
 =?us-ascii?Q?VSv4NTLr8q5+TFNMuTSwcFPNiYyOKzarmndlf51TR9oo5kV1Q4+zty1zY12L?=
 =?us-ascii?Q?P6JJ4I/0mHW1NNgXKzuxhRC/4SR7ZZrAxPXm1adskAU0cQP/GpyCJ1xGf4v3?=
 =?us-ascii?Q?M3hyJcFrNBGMOWzYUsVZ9BSorsqIYpsQVXddbuVfU33GwC1t347zN2pSOl26?=
 =?us-ascii?Q?PNUrG4fr8hSOIuy7TVVlzFWngwsKkyDsPk107YQJL7j08/wOZF8N1ltHkCJq?=
 =?us-ascii?Q?1sU7rdgYKwW0z0CK9K3V9Zfani05qrxQwkgLZRtcFyXS2rfS5siU85SX6Srx?=
 =?us-ascii?Q?C68ubpEBcXfwXYLHr5zhEbz2WK5vNcoeRPi/tvdIDJxyyWqya2cluxPGGpgC?=
 =?us-ascii?Q?/N4ZXb/bcBjM1wT+uHoEpP6TkupwU6VHIvc7bI+yoxp1kltbJKzlTchaRk1F?=
 =?us-ascii?Q?ZnrZIBacR60HiGfv5WLAeKVr4cvWEd+c/ETIUc0cAqReKQI5WvFkrzP+Yxbl?=
 =?us-ascii?Q?1RfQOTJlVZlgiSBtY70emGvsYLXKjyQJ/EayBPid5TIGnRRFZasWxj19d3HY?=
 =?us-ascii?Q?5EJoRp0u06tQhKQnoDpYSbg7tnAapBEvU5Y74rIV/3UIbDNSQKUhmgdodRko?=
 =?us-ascii?Q?rcJYb7C6eLNK3MJ0Lmmy9K9BdYb5taI2j0MAOBF/8wf8X7msYHkQIx4jImq8?=
 =?us-ascii?Q?DTthm1kyujHDVyFQwmSq57c4XwshGHmYlqGUmMEE8AI3hVetuDpvFMyHxwvz?=
 =?us-ascii?Q?tL+2JYf66L7XrqqjiMsM+pHBc5b5o9w/+YMcW6mBdKSUlolrI3j/Gf0VyAbl?=
 =?us-ascii?Q?PlChhpiCGnB6/kejAg0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 371784ef-3f27-468f-901e-08d9f6d2e43c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 13:46:28.3937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LrSPRliWMzY3ImFRfN3I8iuS30wsgJo1FtvgH5M7wSkmbJa8OAWja9w1T8EFeiIB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1393
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 23, 2022 at 01:04:00PM +0000, Robin Murphy wrote:

> 1 - tmp->driver is non-NULL because tmp is already bound.
>   1.a - If tmp->driver->driver_managed_dma == 0, the group must currently be
> DMA-API-owned as a whole. Regardless of what driver dev has unbound from,
> its removal does not release someone else's DMA API (co-)ownership.

This is an uncommon locking pattern, but it does work. It relies on
the mutex being an effective synchronization barrier for an unlocked
store:

				      WRITE_ONCE(dev->driver, NULL)

 mutex_lock(&group->lock)
 READ_ONCE(dev->driver) != NULL and no UAF
 mutex_unlock(&group->lock)

				      mutex_lock(&group->lock)
				      tmp = READ_ONCE(dev1->driver);
				      if (tmp && tmp->blah) [..]
				      mutex_unlock(&group->lock)
 mutex_lock(&group->lock)
 READ_ONCE(dev->driver) == NULL
 mutex_unlock(&group->lock)

				      /* No other CPU can UAF dev->driver */
                                      kfree(driver)

Ie the CPU setting driver cannot pass to the next step without all
other CPUs observing the new value because of the release/acquire built
into the mutex_lock.

It is tricky, and can work in this instance, but the pattern's unlocked
design relies on ordering between the WRITE_ONCE and the locks - and
that ordering in dd.c isn't like that today.

Jason
