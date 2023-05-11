Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6446FF8AE
	for <lists+kvm@lfdr.de>; Thu, 11 May 2023 19:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbjEKRry (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 May 2023 13:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238737AbjEKRrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 May 2023 13:47:53 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2071.outbound.protection.outlook.com [40.107.243.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE0D31BEC;
        Thu, 11 May 2023 10:47:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fomJMLOEtNXUnUseKOBeWJrM151ulpIaTWpat3QivrEZKhlXz4NFOS1Yi84ALdwfmEJbN3wj9joaPN+lg77l33AEyRZpqP70mzBjnwwnBe0tmnJ9WXtElKIUEnUZo3mIe+EMyQlJgywEgQT7gJEQXW3UVoBL/teGp/XXI3ZqCm+n3n3+XWmcZnMG6jabi1yH/s2CYaaLELfjzLc6zxniftOvAghlehHjlQUu2G09MuSIcp5Ebx+Ttk/hpqm8A10RKOIrOTFBFSo5j97gcOBaEHNokjwDPubTitTwFDazTB0GAcKyfrPkjWMF31rpvYFmZiYJPMllJ7ZzOMlgPr3qSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QDVpxH42YijfZJcYLUUDi10obarGOHqBDUoE2cHdBDQ=;
 b=TotiyMZHrZ/nzWjSkCPXLCOfi6u8P2a9HhHUUiGse948lb+2/hskNTSBvDQ5uc4aFglhpIkKfuZb+uyt2HdxE7Kp5HkPygnFWwy2HGi3TJms58wuRlKq7YtxL2XYvcxUrHMgXUd46khXfgHW0dlU8hXE/7D6Q4+BRJc5ZPhTk2RI0WxKbTcU/rn1/szfsydYaH6wAdxvgV2wrS+TjAvJRUnkJpvuTPUECxFwgwfAgVws92BiW9NB9OytrphnMkpMHW4u1ud4p2DfdJq3oQzKJSgkzq6vX3TX9eIHFtAfDTrsbEfqzOdcB37KGRrNG5JoqTHgRTpg2pNKMLWNIXNDIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QDVpxH42YijfZJcYLUUDi10obarGOHqBDUoE2cHdBDQ=;
 b=WKIJg/KQBLFS25VLQX2s+i95aKNFDA4MScTH3da0ETXD3mbosMP96Zzx2Sq737RGMxgtT+FjRI1KkMjlMPVWsyk31Vw8JsRI/uWLAaU62hvwte69vQ2nbdqOpmJXxVl0Ur6OnQnreN0rKOsdjQuV2MSkXjitfueZ+hqFIc3+mCRdlattjO5VLgW2N8JjzwmtSZdaKplwLE6Xc8aYSgdlAmfanujokVMapGxFVU6WdHxusCDgtJZOjJabSquJqxnwoX+zmJl375GvP02/D6M3JDHaEdeY+TdcW6GD8Z5qPlkp6rlKMV+JVBQBapFHog3S7qGFOissutWWwbGOu7Dcgw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM4PR12MB6301.namprd12.prod.outlook.com (2603:10b6:8:a5::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Thu, 11 May
 2023 17:47:50 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%6]) with mapi id 15.20.6387.021; Thu, 11 May 2023
 17:47:49 +0000
Date:   Thu, 11 May 2023 14:47:48 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yan Zhao <yan.y.zhao@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.tian@intel.com,
        yishaih@nvidia.com, shameerali.kolothum.thodi@huawei.com,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@redhat.com>
Subject: Re: [PATCH] vfio/pci: take mmap write lock for io_remap_pfn_range
Message-ID: <ZF0qRLtteE4mtRdT@nvidia.com>
References: <20230508125842.28193-1-yan.y.zhao@intel.com>
 <ZFkn3q45RUJXMS+P@nvidia.com>
 <20230508145715.630fe3ae.alex.williamson@redhat.com>
 <ZFwBYtjL1V0r5WW3@nvidia.com>
 <20230511100706.63d420db.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511100706.63d420db.alex.williamson@redhat.com>
X-ClientProxiedBy: SJ0PR03CA0342.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::17) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM4PR12MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: f6147bd2-ddf1-4601-6523-08db5247d672
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rHo69usaUg/wOc+KRI5CaV7Hzopym7T5Wxmx9pCQNHrQ7LDlIIeF3YNLzacATfFZ4PuPwVkwT/HmARrRPbYjeu/ZKLLxmMXsW/ulOlu5W7ugHa6ERiSePkddAKuCQmOjugJbaYi1PtMJzmYUqn4BGuNt2titePoLpNdZ6ZxylChFV97s6QCUGim+DDwy4AyYt55hdUOPV9th5uoTc73xxAKKgzAgy/18mkrb7poVW/byU2otv1DONTmwLJn1tRx3Vl/sesYFJsXO/5nP7jTr+6XPZBvaQqZrNJzErq+RBCOEGxZZmdj/59sffwV1CbSTjV+CAdqKeakRvdZ1ezPlDargxcyCJISzRjnKd55VdopXzpQg9SPUsjuoQ0+0igbQV/wH5Sdy73Ef39szI43tCsoPE49rxZ9qHcsuNCU7sPGhvbwSzhqMCZWdBUyDSStapWvjTnImOUD3u5kVPjX/bvgnvAJadXwQFDWTuW99tHaWguQkbW1d3UyPxm8p9px4hp6n1tRN0tGMc6Xs9u9yB/gncAcJW8Iej5WaVq15hkKB2H+hOUMK+gIsbPgp6jIs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(451199021)(38100700002)(5660300002)(6486002)(8676002)(8936002)(478600001)(54906003)(316002)(6916009)(4326008)(66476007)(36756003)(66946007)(66556008)(2616005)(86362001)(2906002)(186003)(83380400001)(4744005)(41300700001)(26005)(6512007)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2jVkcj34JvADKYr1THERsXc0Hp8kodl1//nSpDdm7q3iiTvYYu5wl6aPEKlQ?=
 =?us-ascii?Q?panmtYWACjuYirYmxLFE2UkS7r9iYajZTMQvRp0NJzyfgDPiCMd8bZsBgcwT?=
 =?us-ascii?Q?TtGHHkJtxVtPxPGUdD4/YCFOYGZfYeNFcdkFint1UGAKBWnfd41Y0XkFTZZ1?=
 =?us-ascii?Q?o/QnMw7eAmdxN0/Hvr6d+dnsRL+d57AybTJxMIJ5iSN52yk5KKZxxYWWx3TT?=
 =?us-ascii?Q?Hd7sza8aVRkxZvZG2J11PvsUy+6dgT5REe9yY/W0MuybJGpGtJR2yKBC+ngP?=
 =?us-ascii?Q?aIq0kSgookvnNrLofB0WogY4xEi6V+OBkCyCagh5GDjD5MQty2C6JJfQqkoB?=
 =?us-ascii?Q?C0vPnidUxOeI8IZPxSal8YNKL1n9fMJirMACdRKa0o0QxSyiRi6onrHS5j2o?=
 =?us-ascii?Q?aomcapuYl5jA3cpMYFme1RyteB9zo49RiGRDKheqTloXY9A8xEot4huD2Svi?=
 =?us-ascii?Q?uE3owO0N152sp8RJBxgmev+I6ty8nK9oa8HVt9+xvvY4/N+jGDRofxfIiUIC?=
 =?us-ascii?Q?i9XK6H9J8hFe83IXBiOdWMd03D+mSKy2OPVkR70EwWXoEp9FLwtDXHkNKktM?=
 =?us-ascii?Q?lKYMyW7pZDHF2AEaKhfkKLpRAqoB8YrlrIUZcNUBDp11X/JGHMClCpCIrhn4?=
 =?us-ascii?Q?s32k/zBuJjC5Hm4kAnKANtOp8c6mfMys/ElZ2Gis39nrzgPCL4nMnk/9X54f?=
 =?us-ascii?Q?WpoWM3XvfBe9XWme5gXbFfKhMSMPIJsnXndN90++/xwbiov9tG/S6nonv+HH?=
 =?us-ascii?Q?fa8qRB5iSSQjy1G1+0waqrbO8xv++bydMW1O6rtiT4mTPspLmWzSU8VagHSY?=
 =?us-ascii?Q?69lh3Dkb3zy/OEN9fk9A5Qx5EzfbEe4rBN2Tqe6UmHzikEHeypj2TJHqfIiA?=
 =?us-ascii?Q?TqGXYUry0/7Y7zLO39Q/cMSxSBLhOvvdbTLuOJexINd7p2qmKU1ahvJNFy/Z?=
 =?us-ascii?Q?nRn17bVGpIkLpnMm6soSgck1kNeitMsAOVqxPs/zqhgmPpeQzZbR8tPtPWQj?=
 =?us-ascii?Q?HHcDyu1kGKGt9yrNGuBrLgMJYfA5dBFjkY3tResDP9mY+r7MvTNUWykScwcL?=
 =?us-ascii?Q?6kfb7Yc49umNX9eO5vO9l5BKt1bcLjnsDMVJZ/e30N99hyV83MTnNe5ZN1Jo?=
 =?us-ascii?Q?Z02FTsihm5JYYIrbvcVXdXjDX2RBicz2Vu37R6u5ZY2Qaso9G0/ScWuYlObe?=
 =?us-ascii?Q?x58hCf+2vx8Q96yHm3uoyLwbPhP9fj0AWOA5PpWFflKKppKl61P3efbH5XIb?=
 =?us-ascii?Q?2SP4kf8RIpjQw4D+qTE3JlCsNITD/Hv/ghtuanecDF8xoZRI2bSgGsqXzvw+?=
 =?us-ascii?Q?880ttUqyA4kwxbMGKAmdsR4v5tzZ1kMd5jUqaZhuNy9Kxu446gNjkj1BsEy3?=
 =?us-ascii?Q?4gQM2rCn4D93+613IxIZTn4sz5tuHBMnV/2ocuWGujr4owFIfggVP33etk+A?=
 =?us-ascii?Q?Hxf8MyKotMPQc2QkGHg5+SEL5rSMH6FOgfWBOoXlTrms7AJCuiFw7K9Z7fD+?=
 =?us-ascii?Q?do0BOiww57t2AHaEA6NlVxZRKZuBgD50kiifgMQugDZwM5+PdPXaGCFIVSyu?=
 =?us-ascii?Q?o/vZjHCbPzV8W9xxQiep4rRCWwJkWjCSlLX3zZnY?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6147bd2-ddf1-4601-6523-08db5247d672
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2023 17:47:49.8866
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPmX9rAsI7Rzja+9+an7RbqOB8Q2sdtqBztmXd5Q2zIA2mPNCRWBRM/9rVH46A+R
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6301
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 11, 2023 at 10:07:06AM -0600, Alex Williamson wrote:

> > I vaugely remember the address_space conversion might help remove the
> > fault handler?
> 
> Yes, this did remove the fault handler entirely, it's (obviously)
> dropped off my radar, but perhaps in the interim we could switch to
> vmf_insert_pfn() and revive the address space series to eventually
> remove the fault handling and vma list altogether.

vmf_insert_pfn() technically isn't supposed to be used for MMIO..

Eg it doesn't do the PAT stuff on x86 that is causing this problem in
the first place.

So doing the address space removing series seems like the best fix. It
has been mislocked for a long time, I suspect there isn't a real
urgent problem beyond we actually have lockdep annoations to catch the
mislocking now.

Jason
