Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A56B371EAD
	for <lists+kvm@lfdr.de>; Mon,  3 May 2021 19:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhECRdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 May 2021 13:33:18 -0400
Received: from mail-dm6nam11on2083.outbound.protection.outlook.com ([40.107.223.83]:12001
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231459AbhECRdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 May 2021 13:33:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DX51UXoB7szromYUx2KW9cW+IQskacJdmTWHdAd+UhS+mKWGBo+tTspjBBJVJoYdJCHSDhqYZNoEfLSxLjlFhdTV0FnFpM7bcW0KU9coqdUU+ZaMhmAPuWymwEGHgU6u7g8I279R8aDyUn3/QL9S0Kzj8NEMIQOp7NVEB0gNbGaHELSL4PfroO2gRK4FcjWuW6Hw/NnsDITQdbWkV1qzQPjRFQGQXCoHwfnchaZnPQT8bV2YOrfJjueQ6xZljd5jSlYQ9vRNoL0JXUAgrY39NtRY8X1MuTt9HjITyRGAZTrbN/PCbeJ35B7kZNNI5jnOQze0pwyymX07QlsgXJUy6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKMqhWeArg1jmTP1AdFSd6E9H2m7pmz9Mc1Nh8fcW88=;
 b=OXKvLO3lvhTBDb2QRtko/UllC4YKJ0qWobydMBXGkmPkDpkkoezWjIjl7JR4CZTLNotjrmYPDfHTh14SdZXlJ2eBgr259/AQikH/KAJjFjcNVJCELISUx8uaOFluiMdLgtL+hWUGgu5lhNQELrJMvDDRE2+uwMbqQvFfKB2MWW3fRh9Xon6NfV39lD7sKsqFagJ7Az4VVI1Uf0E/ShTJ+2dtNXuD3rpuepwkLumO5HM8C3/uH9xIbiEne/FbrvPguaGn+85qk+6Etszky0NVmUvFccn7U/ezOSI4yVjGi2VH714w8CGHdOkJMNxPSSGDPvROVeg1b15Fb+3E8Y+9ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uKMqhWeArg1jmTP1AdFSd6E9H2m7pmz9Mc1Nh8fcW88=;
 b=nDcEzSYCEhsvXzSpz6LqSiQtJil76LlkGtzHW37XN6vT03OuCaynuAs0lwo572b1usZMBRTB1UAR6rmqAojqJgVY7QlbBJNkF85RT4I3fMkKuCgaNbv45Y7/6+5Am1rj2Wp2svzlyeL1PlSggz1o+s5ugzkTaAl0szvWLbfjUmlX7XXpDbxx4QyOB4Zc8db3oCQUMm/nzZH7Yb98z4PR7Z4JUMjULLm+R9BVOrlZ7tNRYjxWA+/StsCH3VRxMwC6mLtI/kDxsnSAFEaHlItNnPkJXLtcCpJfiYANSZTZBGH4aO/RzCGqeiPRjGZs4eQd7sVMxsPqywWQN2916EGaqw==
Authentication-Results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB2491.namprd12.prod.outlook.com (2603:10b6:3:eb::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38; Mon, 3 May
 2021 17:32:22 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::ddb4:2cbb:4589:f039%4]) with mapi id 15.20.4087.043; Mon, 3 May 2021
 17:32:21 +0000
Date:   Mon, 3 May 2021 14:32:20 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        Kirti Wankhede <kwankhede@nvidia.com>,
        linux-doc@vger.kernel.org, "Raj, Ashok" <ashok.raj@intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH v2 09/13] vfio/mdev: Remove vfio_mdev.c
Message-ID: <20210503173220.GN1370958@nvidia.com>
References: <9-v2-7667f42c9bad+935-vfio3_jgg@nvidia.com>
 <20210428060703.GA4973@lst.de>
 <YIkCVnTFmTHiX3xn@kroah.com>
 <20210428125321.GP1370958@nvidia.com>
 <20210429065315.GC2882@lst.de>
 <YIpYnz/isPaXsTYs@kroah.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YIpYnz/isPaXsTYs@kroah.com>
X-Originating-IP: [206.223.160.26]
X-ClientProxiedBy: CH2PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:610:50::25) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by CH2PR16CA0015.namprd16.prod.outlook.com (2603:10b6:610:50::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.28 via Frontend Transport; Mon, 3 May 2021 17:32:21 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1ldcQe-00GYFF-5F; Mon, 03 May 2021 14:32:20 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: dd6f944f-48a6-494b-3c91-08d90e59683d
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2491:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2491B9A1F766CE3BF4F8E129C25B9@DM5PR1201MB2491.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ff7QqtV2r1pNXZ5X6jyA3auFAuuOBAbQ+u7DLMvAyEf1lQkrWbMEa5QDk3c6uMFUsmeYLmQgdjVIwj7Y1Q8pgCJCeFK3TMRlaOLxexGWH5mw0SuS6e1LJMOwBWn36424ZMRI90ZXuSnSZWUo7vmruYsbBTQ14qG14Ura6TRnCm3L4Pn1QsUAlCk8gT5mCKhDvf52p4XRlF2fwHube9vk5Zat0W7N8wWfCUrQajwhKG8GguowHFrU5BV+HGC82fZ4/POyA96UiY3B/NrHvpjuExW/SyzZyPrJXtJ+Xg5HwInw9HK/t3i0jGt1Z/KXemO/sfGnZc/ihPTX2/C9F0bJkyQs6fGc4bafcyxEhL/xBo+SLVw344GcnPRtDqVry+Leze+lMm9OIkfooz+PN6tREep71W8uDQN+vQJqWUdo4GYqQs1TwhmuTUSnAIzOev1hqYtqxiQ3GuVfymMvysUpDaDEvLsbbLiwPD7wRLcun4yuNdISF9A4QDx7M02K+HJNMr+g0BhmCXCnOh/itWcqBZixouEFmZjxMVNlZaf8X8MC9X+2727hkc5mBrVhQGbaWOwAMcbM4l02MYQf366i2OIQ3Y1cnfbp2wBD5cUqAtY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(366004)(396003)(376002)(136003)(478600001)(426003)(38100700002)(2616005)(107886003)(8676002)(33656002)(5660300002)(6916009)(4326008)(8936002)(7416002)(86362001)(66476007)(316002)(54906003)(66556008)(66946007)(2906002)(186003)(9786002)(36756003)(26005)(9746002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bfUOx2x4PP6Wca5ntGmII2WVz9ws/agqp0DjFWDqu2VJ9cbr/RQ1dym9JKbn?=
 =?us-ascii?Q?CgpLWU2BHZsEvVVkEc/iXHDdsN4CLY0QnvWePesp1ZoHpcGwTU9H1vG2V771?=
 =?us-ascii?Q?jvq10TE1YcZqmDx4I7WtbmECVrTSXXB6ZM63N8oVqIHGixplxifKerNQHwhH?=
 =?us-ascii?Q?tAM8jOYeaskMe5mvE4NSc4hQv5NO73AfUQs5wCmNhvnAwMFB43FpdEwIlq9n?=
 =?us-ascii?Q?7EQJu422OqHTgAY3Cn7J747Ns62991BbL881q19aSNX13jmqL+zCjH1Op48r?=
 =?us-ascii?Q?0dWfJUqJHy5QE5y0CGFn7KwMKjW3yxa+jygBqirbr4UcNYx29ZIptoqd/EWE?=
 =?us-ascii?Q?7rBpkgY77xXzjI50HQf2RLtqMu/UiLZjy0/AsmCEhdUbf8sTmJXDIs96Ltte?=
 =?us-ascii?Q?bwP6SuL66pimakmpceGxIFj3eXg8fzPKFcq+SeXSvr++22BrkzSz4nO7Ljnv?=
 =?us-ascii?Q?mdXnRnIO+b6F9+RSOr7DDmxVPH6s44fsx+AFdNcyyfImDn+7p04hkpt3coUT?=
 =?us-ascii?Q?il9Ks22UWbIVZVUvVIg2UIpkPR2C4gg4WY/mWEGNgNjbBFIddx5MZRYWUHKG?=
 =?us-ascii?Q?cD9XwZ+oKHMm3vaVi81Ebi4j4N/XQRWnOb3sMZEW3eA1t/Bh9m2H1Dn1oJoY?=
 =?us-ascii?Q?ruYfBi1wCZmWlx0lXFe0RPXx5nB7V+DHvqBjhgOBnDZb49/FuC6hOoHcOP1F?=
 =?us-ascii?Q?u3E87hKlLXCnC/xPmKXvBlb2MfNUWXSo+qKU6G4Gj96yS0XpBbp5w8XE+LOX?=
 =?us-ascii?Q?I6sn6+Yfj7HUCovlpUHlv0iiRDBpVK1pSdwVwWW8vA+jXGF0jWZiW9GTU4tn?=
 =?us-ascii?Q?giRmAjU3aGauw01U7y65/Kr4q8qK2b5O+GzqROHISD4DuXI7GszCOer8fD1A?=
 =?us-ascii?Q?Ca+xunFleEH/S5pXamUrtYz0Z/mro1TmjpWxdYAWSphy3v/Xy4VpVbVgafgF?=
 =?us-ascii?Q?mR1wrjFhuD/ZtD0Opk1P4JRACJrTdcly7uGx3/LcL7rxFf6YeCqajWplVzJ1?=
 =?us-ascii?Q?ZvXrrDlzG6XWI+TmDczJvn6UzNcceqbIqFL4YTXVuEIfYyprqowBzNoLIj7B?=
 =?us-ascii?Q?tV0KBIc3t3Z6EgZD+5ch7ykeCcex2YSS5bmbJhlG1ZuB/hF9PuhOvfvNYWOx?=
 =?us-ascii?Q?Tn4j39uaM4uxOtAmWoFEq4J9WeK0RT/4VARtC9nwGeOXqs2kYRzRD+uEyHLX?=
 =?us-ascii?Q?luNAEo8Xn0kJ1UzRBJ3ofOYJHyTkP4Xnyqa2wMkgryusR3nlNZoOxFcoUW5w?=
 =?us-ascii?Q?Np54nr0fhLIBw3/yCiJtxfFj0Dnspi82D++crNqPPlTZjubI6QrBxGI/z5MQ?=
 =?us-ascii?Q?keRsm+gcoOGkRUMgx+2k9fse?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd6f944f-48a6-494b-3c91-08d90e59683d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2021 17:32:21.7225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kJGY8Jr/HyZ5h6uHuCubnamosdXI6/2UM5HpjhiaShdCG7DsPelqb+07a3ln3yVV
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2491
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 29, 2021 at 08:56:31AM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 29, 2021 at 08:53:15AM +0200, Christoph Hellwig wrote:
> > On Wed, Apr 28, 2021 at 09:53:21AM -0300, Jason Gunthorpe wrote:
> > > The Linux standard is one patch one change. It is inapporiate for me
> > > to backdoor sneak revert the VFIO communities past decisions on
> > > licensing inside some unrelated cleanup patch.
> > 
> > That's not what you are doing.  You are removing weird condom code
> > that could never work, and remove the sneak attempt of an nvidia employee
> > to create a derived work that has no legal standing.
> > 
> > > Otherwise this patch changes nothing - what existed today continues to
> > > exist, and nothing new is being allowed.
> > 
> > No, it changes the existing exports, which is a complete no-go.
> 
> Agreed, Jason, please do not change the existing exports.

I respect both of your positions on this topic, but.. I can't be part
of a licensing discussion here.

This is a cleanup project from the Mellanox BU at NVIDIA to get VFIO
more in line with kernel design patterns. Mellanox is fully open
source for all our kernel work and has no stake in these licensing
topics.

As Christoph notes, it seems some other BU at NVIDIA has an interest
here. I hope you'll both understand that I can't get involved in a
licensing topic between the community and some other BU at NVIDIA.

Since none of the past discussions on EXPORT_SYMBOL resulted in any
concrete guidelines to follow, I feel the basic "don't change things"
(in the pragmatic, it worked before, so don't break it sense)
guideline should be applied here.

Since that is not agreeable I will shrink this patch series to remove
the ccw conversion that already has complex feedback and drop this
patch. I'll sadly shelve the rest of the work until something changes.

This will at least allow the coming Intel IDXD mdev driver to be
implemented more cleanly from the start.

Regards,
Jason
