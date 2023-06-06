Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8757250CC
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 01:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240344AbjFFX15 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jun 2023 19:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233856AbjFFX1z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jun 2023 19:27:55 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2061.outbound.protection.outlook.com [40.107.243.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 128741711
        for <kvm@vger.kernel.org>; Tue,  6 Jun 2023 16:27:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPncXSeWEomplOG+x2JR2X8fUuXrYUQCHwK1po0XIkvmyn181htaYAJkTnMj0eKx6bCQfLaq4KOPPFm9JfMUiYjxMroE3etFgfdpDT0g6kqr6TKJZ9R98Bwyu5nxvR+JaLg8yXv2trqQ+DC5mbdn1nJwdB9fMmYzvOcfF2TM5ZMJYfTKdwr+SJU5NQaR4EMiabEc8X5sTi0wCW/AhgavCLD3TrUohNYHWqnA/ti1VXoRwv2oGvEYBCCsSNBjWl9dGTCnEG/xIEqJRJvbtbL+OTt/N5Dx4+e4OLif7sOmIcmDW5lo8ssqY7zbl0M1ketb9ho+EExN1JOqEcIGQz26Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QBr6SNg107xhnkpARorUO1ExybsynO1k+sfEG3s+6zQ=;
 b=X6ZhgNRBfZumoKGyFPR5rVEmoy4i0u5BgyxnpL/VZ7/DMk386poAaLU6pO/gROxavjXFlaij6HQf1jKZROn4y7aHzYDKrEeMxtJy5p1p0AHpal7L/lbl6gbdb5XAsQ6UE7svyX05tzzQu9rybfM0DH5gUDS20vGvSw8jKvnvMjOTTvwwS2x2BDQ6k0yV6anerUyAoGevVGOjvFE8IAYdSw+Do2kyRE3Ve6A9NY1nwh7SpuL5zetzSVRYM4+RUKrN/R0DjjqSRXNsL9Qjt/vYSj0eB1t7cDvTHC7/zv9jrlv8mBuwxYQalO2OCi3XS7Qqt3jEglVfK/hj31fOCkK61Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QBr6SNg107xhnkpARorUO1ExybsynO1k+sfEG3s+6zQ=;
 b=dTv/tXS2Ad6I4tpcrPD8xhp/AOz3/j3EjGLxi2cIlfh5Tk3SnLkx6s2WtUUWhYKpTf6nOO9G4o/wnpNYXSWZgqRBbgWzm7Rm2HRzPLpVbODk9vTSMy1iEz5Uo88QVlwft0E4GkHN0kwqMI9XjgRYaoo3kBes+vRaY+FcGBmW+jgq8uBEPCvO9YnSuxjSlKuoJbP03Xoz8SaSNooPd8C6CKGbZLyhYJT1iGbDi3AacxdGUNZ6vFlnsZ5pziKPUpeqkj8rdw1OBgEjMzHuZo8mOncRhIavPypyaCxHCQMNwgA+hiyU5cFWA1iNr+GtfikYhJ+aMLwNWZk9NtaNOWd1XA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5859.namprd12.prod.outlook.com (2603:10b6:208:37a::17)
 by SJ2PR12MB9242.namprd12.prod.outlook.com (2603:10b6:a03:56f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 23:27:46 +0000
Received: from MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::a03a:9b2b:92f2:ff69]) by MN0PR12MB5859.namprd12.prod.outlook.com
 ([fe80::a03a:9b2b:92f2:ff69%6]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 23:27:45 +0000
Date:   Tue, 6 Jun 2023 20:27:41 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     kvm@vger.kernel.org, clg@redhat.com, liulongfang@huawei.com,
        shameerali.kolothum.thodi@huawei.com, yishaih@nvidia.com,
        kevin.tian@intel.com
Subject: Re: [PATCH 1/3] vfio/pci: Cleanup Kconfig
Message-ID: <ZH/A7X45jJprLEHx@nvidia.com>
References: <20230602213315.2521442-1-alex.williamson@redhat.com>
 <20230602213315.2521442-2-alex.williamson@redhat.com>
 <ZH4U6ElPSC3wIp1E@nvidia.com>
 <20230605132518.2d536373.alex.williamson@redhat.com>
 <ZH9BvcgHvX7HFBAa@nvidia.com>
 <20230606155704.037a1f60.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606155704.037a1f60.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR05CA0150.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::35) To MN0PR12MB5859.namprd12.prod.outlook.com
 (2603:10b6:208:37a::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB5859:EE_|SJ2PR12MB9242:EE_
X-MS-Office365-Filtering-Correlation-Id: abe69b35-aae7-4dae-fae4-08db66e5a14a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w2Zq2DeCZCPAQil2sp7cNTGFId7uqhdfb92PQ0Wj4J4wstxFtWOdbEDsKZCWtwmCePYQveyabJFYvpZ1mdQPSPDfS5q81M98sOSKOFGu67XmdpcBl+pQ6EuGyjz3bEh4ys6g/lr2Wz/dI12nArSna7z/jAvtQxqJeeWfcj/uH220Y+TI0bqk38SWBuea4LcFipmoL9Vm0sOUhUwDnS7d1cHBILqaPMKy7DNfWVS9XXGD/wFocPgO3DJPZbNtOiGcJ/Wn6nT70nyxxDIv5IsRHs7Yd/LDLZGOfzn9kxt0QoHHWsrg+aD2G/B05XZAB7F6zXossPLMYH9dmXujfm6FwmXuvP+PoJCierYDUTjKkpzqFItn33hC+hGgNkJZ36572EO4850IVnLZkTosG8ePWIFsiHms3AsoxD+AmOPxbxVvP4ct7oF/DDCDVmbrw4+QOTlyp2lCRUOB3sdx/hGkDMYUgirZ9gA36sK84M+7SL+MBOuoE66aSIwu69C/FSrAXiFMzTOX7kw0B1nsul+xavL39ZX4p0dWXzlsUj/PU4diGatvA7h12MoMgWzXntc9
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5859.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(366004)(376002)(39860400002)(396003)(451199021)(6506007)(26005)(186003)(6512007)(2616005)(6666004)(6486002)(2906002)(36756003)(8676002)(8936002)(478600001)(6916009)(5660300002)(41300700001)(86362001)(38100700002)(66946007)(316002)(66556008)(66476007)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?egGvAWYAnPrxNwp8fJSRJEhbxw9dX31OepFJAHKbZN3vHRzImbUZ/5zetIDD?=
 =?us-ascii?Q?/eco5PDKei6ZajceuNcuVtbljrXj/ViHaz4k7eGpfBiW8dolQ/RNw7XBmAiO?=
 =?us-ascii?Q?/+A8Xdqaian+1lbFxliPm0kiWudgrtXicmWLRfJor1u01YIj72LGYBKjJTzJ?=
 =?us-ascii?Q?ONT1s5Rpz/8uVAPI7z3VFQOjzX+/VUzs+pjgdKm8NBSaTVG4UpBIpWI622Jf?=
 =?us-ascii?Q?ugxiyvZXKmjkrgsTyiEHH4/nlt0MxnSzn7SKzvO+5Uoz531SKZIMJPYHoF+U?=
 =?us-ascii?Q?CSpO3Hsn7A/EMZVv9WmHRgi9UouaQPjZR+h4D6L4qJqHgMcI/jNGP/CunjsI?=
 =?us-ascii?Q?AMhXanA6WEntd4gZitIe2xCxQQJdpAa/fBojGSMzajnCxUzY4k46s+aTpbrc?=
 =?us-ascii?Q?zKvEqUDCATitsUEaS7S5gNhSTrynv8W76AYPyjmjZu4IRfo4/5jaf8+2g/HR?=
 =?us-ascii?Q?I/0H6tvvWygHyD4Q/beM70rb+f0RoarwnA1pnL0y+8LGN4MwQPugJejwnJ+v?=
 =?us-ascii?Q?CrWnn2irCkZEWSragCxXl0Hd+eZYmfF42FzbI4nhsRzVXt2JMf1JNzsjYMvY?=
 =?us-ascii?Q?vrGAOn3UGMn1xaP19shW67TEzlD8lNQZMJEKANLt/4JCs7p1Axx7vXyHvcLN?=
 =?us-ascii?Q?00I8nrXpqsDpD0XnuZVr/EDiTDQ5lyPsG8+MEC3LGYG5zNtz0R7C194x9K+7?=
 =?us-ascii?Q?GnLg6p/SJIi8X7q0pIsDIkvbrMUWSlb4C3v5ZeFl7koyXN/5Wl80gnSh8xyE?=
 =?us-ascii?Q?08zcj/cEizxRoEu6bKgz1y6YchdENPewTkwG1ol0hojXlTXIA70/ui06TnaW?=
 =?us-ascii?Q?xBjIQDOtAbyE1k2U9WSdWeDw7+lXms4x0L5mXWsHQj0RCubC6Pg7wq1eXi7M?=
 =?us-ascii?Q?5AaTnWJPb8YxeZW8CiXk8zae7cjBBNEBXYg+rkwWFyIClHbIIMr4cHl6V7ye?=
 =?us-ascii?Q?c9SYz3eKFfNTlepBxpPWmrqbOgAD2+5VoTpWxjf6reXt2s8IMRbj45FUV7XT?=
 =?us-ascii?Q?rys+v/bhMM5to2R2Wf2LQxfNrdLqGwY5BQUqCrCtpWTIPGmuBIjYe2qIySTv?=
 =?us-ascii?Q?L++v5u4fXwroHgWvl/t9pGyrVqENf5PpTwkAjo4dOvor+pmJ+UUSg9jsVVqI?=
 =?us-ascii?Q?7UjcfFi+w1LCVuzM3DUZsv18Xl9W1NMCLMCLq3uLQdkSASQP5kS9fAFLRU/+?=
 =?us-ascii?Q?57gA5gCczWKWmfsRwA6y/xnpxqFHwP88WWzXMGgP+eBw0dqiS/raufOiI+5B?=
 =?us-ascii?Q?qfyp5SJUQJeCzX0caRgQjJM7RH2lYpm3uFRH7fgDdTP8y9eK/nOh1azAir9m?=
 =?us-ascii?Q?nMaslOpK+TiMLDwD/+o9oxO/jE4HtshlPgtazExCYEQ6j1phfWw3m0e2ibZi?=
 =?us-ascii?Q?GfW119Ha1+YcKLeyoX7GTlcWsj/jMG2m1gwqqe04m25bVnD3E/bURJYWpSlT?=
 =?us-ascii?Q?tVij9Mh2bf6M5Oh7ZZn0l3dd/wFKsDyp0EwpNxRak9oluCLWnCPCGT6Ehc6E?=
 =?us-ascii?Q?2nFnC7j2NywcdJUBbKtWgHd2J/h5UD7EeotaCicYvmC7E1ap5DOk7vsOfbsX?=
 =?us-ascii?Q?jWDQiW2oqmzCwdjprFMhia0l6hYL3JQZwJrHgH9K?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: abe69b35-aae7-4dae-fae4-08db66e5a14a
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5859.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 23:27:45.9134
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ifi2sE0s9yU7jzJRlGsHFDdOFvgg+xXC4/e45esRxYsoiOeTDEj/Sbw7uImeoBK8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9242
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

On Tue, Jun 06, 2023 at 03:57:04PM -0600, Alex Williamson wrote:
> > Not really, maybe it creates a sysfs class, but it certainly doesn't
> > do anything useful unless there is a vfio driver also selected.
> 
> Sorry, I wasn't referring to vfio "core" here, I was thinking more
> along the lines of when we include the PCI or IOMMU subsystem there's
> a degree of base functionality included there regardless of what
> additional options or drivers are selected.  

Lots of other cases are just like VFIO where it is the subsystem core
that really doesn't do anything. Look at tpm, infiniband, drm, etc

> The current state is that we cannot build vfio-pci-core.ko without
> vfio-pci.ko, so there's always an in-kernel user.  

I think I might have done that, and it wasn't done for that reason.. I
just messed it up and didn't follow the normal pattern - and this
caused these troubles with the wrong/missing depends/selects.

I view following the usual pattern as more valuable than a one off fix
for what is really a systemic issue in kconfig. Which is why I made
the patch to align with how CONFIG_VFIO works :)

Jason
