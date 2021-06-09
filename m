Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 724733A14A3
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 14:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233739AbhFIMlR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 08:41:17 -0400
Received: from mail-mw2nam12on2054.outbound.protection.outlook.com ([40.107.244.54]:31107
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233488AbhFIMlR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 08:41:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAT+8FBaqui5CjMdCMyBQhzM/eCe+5wD7CTQMYgftpwEZP/xznGD0xRqpiGOSZG4jKPDvkbdVFF/2Wk2a+hgxF6APSurUuHgb6/wgliLmmICiKrumpoeMt/xcOjOTTDiLJ0lqvuDk9xANZy/kXhXPEhLJKGAj67MA+/4TqWrCwkywYCAP7n42tHC/3XhpnPjc4kSONcaqtqFF6H9srs0fmHyfjRRtrIHcZe9et6OC9uQj0GlooDURnhR0OMdqPqv0l79ESbnOtOum2FBxVdSAe5R+ymrOGFeinhmxIWK++/vMxQHalVzTktPWvb1t8LYGn3S2O9o0uLP6gDhy46t8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zwj1Avnetk6RkYWNvFYOeup0374u0tgyFNkucQkz95U=;
 b=UIObTzQA8qKuDqYrZ6gfrg5HMDFU926OCFax+Dvn757xbrc97efgNg81Z+kbuxC3DLXO6tcekxQPVW6Sb+70DJy2F2nUppT4PrgqXrPsHOJxGna6Y72WRr5rpqkMZnjz8Kl5DTCfCGY64iCHNQhNcVL3DlKDQHEMKCehrUM5rwnkcgR4qIF0+4J48cftDV2TpO+DRQAOIc/JRrhcENIXEzuQJ3e8ZfBesa7R1nrdaQdTUCL2fwYI6GJi8GHqK0bOohtYuwUrXYRV/3PTBTSwFhMcx1Pq03Ro3Cc2qqLRIcUgGgY3beye4Bp3ocizHEZyOrXS92hj5740LS/8XqzcyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zwj1Avnetk6RkYWNvFYOeup0374u0tgyFNkucQkz95U=;
 b=LgVQqCnGunwnKXWhB5MOEfcTd/WotU3LHJUGhAmjrw9b5WhNjoFTn9tmg9INPy8rTRdq7v0SQplpiFMRqZArNxIVDuP3xxhzL5dXmAVYkGcWc5bIUHLYKWFME6ZEv+6TB0hSfPCP0vd1Bh6ohhT+W+Sv8KWHzlirDoZm1Be4VM2qXbBlYMoenJDDf6sUnBmJhJcZOgsJHogoDSTizg7cbQVLYmYxEsNSYPMI5d+Xq7QaYbFURjzn9S03MPAKP9SRUmMcH4knWLC69I/G85urQgO/Ppvien9KWfX07giAfJv2WXWMp44nHDfmOKk+V+amXR7jxRPn1AbEVbgc6dfRIw==
Authentication-Results: 8bytes.org; dkim=none (message not signed)
 header.d=none;8bytes.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5110.namprd12.prod.outlook.com (2603:10b6:208:312::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Wed, 9 Jun
 2021 12:39:20 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 12:39:20 +0000
Date:   Wed, 9 Jun 2021 09:39:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Joerg Roedel <joro@8bytes.org>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Alex Williamson (alex.williamson@redhat.com)" 
        <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Jason Wang <jasowang@redhat.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Shenming Lu <lushenming@huawei.com>,
        Eric Auger <eric.auger@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: Re: Plan for /dev/ioasid RFC v2
Message-ID: <20210609123919.GA1002214@nvidia.com>
References: <MWHPR11MB188699D0B9C10EB51686C4138C389@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YMCy48Xnt/aphfh3@8bytes.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMCy48Xnt/aphfh3@8bytes.org>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: BL1PR13CA0368.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::13) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by BL1PR13CA0368.namprd13.prod.outlook.com (2603:10b6:208:2c0::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.12 via Frontend Transport; Wed, 9 Jun 2021 12:39:20 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqxUN-004bv1-D4; Wed, 09 Jun 2021 09:39:19 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 42b3fe8c-48ad-4c84-0aa5-08d92b439a82
X-MS-TrafficTypeDiagnostic: BL1PR12MB5110:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB51108A00954157D202B09CECC2369@BL1PR12MB5110.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eEWCZl/4HPvkf0L2gIVjMmr9wx3Lt5oOPRHsFCClBY0PjKndXsXGRhWAUAQO/YK+n9XaUhtrHZIHRdaUCMNDQOVxvtfSobKITaTg4LKA6QigjA1+v/v9rYpg3fbVz4BbWgEOoSqtqlq4i2BogOdGHmkY4v5h5wmqHxU43H4mYxn5+PW9kdzGlcGweJSDTPoJEqlO/Z4fEA//MSO9LzX/MdBkamFW3GzjRIyRFTFRQuYM1kNQO0XyjcLKIHFcg7JKOpAMwv3QRAWqnmMnIOjN4txAEY9Aq5fnUZVPsRDGahaPrAByDxviyWJulePw62DWIsK1o/MelvQqsINPAEe9eMeNJ9XuJluoKSqDwg42nvJx80PpmTRWvjKyrctlOhKSnwW1ztZhX9V0AY4Cf7hsQGs/inT/LNVW5Gw583M4h6yhkTtAW4PbG7U8in1kQZJhyGOeL39IwDrOhrP0JCxXZQYPM+5QSdom7/jJO9bhFfty3F8uYNJAw2XBcENQUCE45W7danyqer8D5mmWJcvukBo59ZHTG8ueOZP4//nKpTNZsjEDIIg86YdvSq81HmtAQRy18RTTbN8Soi8MfwBRwWQXTfnYD/Ac7Z4GWu57+9Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39860400002)(376002)(396003)(26005)(186003)(2906002)(2616005)(1076003)(66556008)(66476007)(66946007)(9746002)(4326008)(54906003)(86362001)(6916009)(478600001)(38100700002)(9786002)(8936002)(8676002)(316002)(36756003)(5660300002)(7416002)(33656002)(426003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?XoodICnufil7P34oPBAQzOv9QjagiTQOhRVvT1p5GIF48eYIq2ybdz6UFbod?=
 =?us-ascii?Q?oUQOkuc9AUYXwI16WAhZGZlewQz+sKqdsld3x/0YcQzi0wW4o4G+xYYkPvsJ?=
 =?us-ascii?Q?R8pwcV980CExlqV5S9JylXZhZRNRnM0rc/mrdY8Z509hZGU4SLBKqThJL+0O?=
 =?us-ascii?Q?/hg7kdYn/7VaYuglGI15ZEGgtSBl4iR1Mfg/WYxz5oMSNSDF6N7sgK7Wgmc5?=
 =?us-ascii?Q?TOGKfymaSUX1pH4Pv/SHrMayMXaZ0SwV7QxZpc2LtOEgOXRzyt1XnVu3px/l?=
 =?us-ascii?Q?e0YqQrIXIjhrjmY9L5mInqkASqz0XW2gNOW/cxYZuIFfgphEE/IMaT5ZfI+I?=
 =?us-ascii?Q?uPnn64tHNoN7HNn564zHkSuU12eh5tB8inhoCKSxCR8RbO7PEaVl7UrxuGC5?=
 =?us-ascii?Q?mOw7nN3hQYhfbQ1TKxZOnXmBIPoy9aMrg6txYUIizB9Zz8LPfXz6PXA4kMg/?=
 =?us-ascii?Q?zrzJ3fQiThONtaG2e3ws/Fy1eiMGsDZlq6/EsJmQf+TehmaWs/Jck6/OsyKQ?=
 =?us-ascii?Q?cLdONobJdldVg9Q5lUtKOiZqee44Hz2a9iJGCPtvqMy6iMdio3QeRBT8EL+h?=
 =?us-ascii?Q?E1pRGzaCu5UIPOfS1uOZptEAXglZDvw3bhaA+w/Khw52DnRxiOguzSlrGYgr?=
 =?us-ascii?Q?yJlcutOIn4N7QRx/EOLUE6zvMNDnQb5NNfzGQmUiC5hK4HrSi2feY+p2y4mL?=
 =?us-ascii?Q?arUaDm//rXMuDYP4avZ7895COsicJMM+pBnbA9fWG/sHdafgqOvEjT4eFYoH?=
 =?us-ascii?Q?lchUZr1RbtturZGf6gCwpyIlU77ye9RQPRNrjKbtKhw1DCdrH3pKawXNnSlv?=
 =?us-ascii?Q?0WLZDkN8WHxqcxPibqyPBht8tYhHZLFM3Ak9d9b4df7sMmsWw9kiYOZO8Wwz?=
 =?us-ascii?Q?R0YCsZgpvBcCpNLRcKcfE6lghg98kjJPrDgg717cI11NaGexp+B1UKw+pN8Q?=
 =?us-ascii?Q?3wKgQtYTK0p3xGjKb39O7P/+da9Yy9AqUKEvmq4MESPxUOLcLUBe+Gr7SaGD?=
 =?us-ascii?Q?nT0GISAaXz2c7+oGQkRMdhVXWndPm04xooGUtn53FpttsXn1m4H6FHqOwaMQ?=
 =?us-ascii?Q?Vi1H7xUQwL5CQNQCqiWP1KXcQ2pOI9rHRs7OMJeCpopGFQ2iK/SnEaRSSCEj?=
 =?us-ascii?Q?RBcgprUsKShqNMoDC3xKp1R03OWhTKD7lxqJGRy0XObKn6OFIvTUo4aZSFFq?=
 =?us-ascii?Q?6i3fEENVXQbPv972yK6p2S2lp8xFv8Gpmqx8+xnJtCC4R5Yc5pVf2zjdmFwQ?=
 =?us-ascii?Q?x7v7FlUEIxi5qEpoGwHJsanhTUlB9vh6P3GAAIV/S8OPaPuV1mPeibZsfnk3?=
 =?us-ascii?Q?o0ScSLPf6UgtrgPNeZAZ96p7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42b3fe8c-48ad-4c84-0aa5-08d92b439a82
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 12:39:20.7191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7H29M5qMvliK+NMCagORSUp2UARKKkoNxTEab+fHKpAXEcu2EeudflIFSSu+MnaJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 02:24:03PM +0200, Joerg Roedel wrote:
> On Mon, Jun 07, 2021 at 02:58:18AM +0000, Tian, Kevin wrote:
> > -   Device-centric (Jason) vs. group-centric (David) uAPI. David is not fully
> >     convinced yet. Based on discussion v2 will continue to have ioasid uAPI
> >     being device-centric (but it's fine for vfio to be group-centric). A new
> >     section will be added to elaborate this part;
> 
> I would vote for group-centric here. Or do the reasons for which VFIO is
> group-centric not apply to IOASID? If so, why?

VFIO being group centric has made it very ugly/difficult to inject
device driver specific knowledge into the scheme.

The device driver is the only thing that knows to ask:
 - I need a SW table for this ioasid because I am like a mdev
 - I will issue TLPs with PASID
 - I need a IOASID linked to a PASID
 - I am a devices that uses ENQCMD and vPASID
 - etc in future

The current approach has the group try to guess the device driver
intention in the vfio type 1 code.

I want to see this be clean and have the device driver directly tell
the iommu layer what kind of DMA it plans to do, and thus how it needs
the IOMMU and IOASID configured.

This is the source of the ugly symbol_get and the very, very hacky 'if
you are a mdev *and* a iommu then you must want a single PASID' stuff
in type1.

The group is causing all this mess because the group knows nothing
about what the device drivers contained in the group actually want.

Further being group centric eliminates the possibility of working in
cases like !ACS. How do I use PASID functionality of a device behind a
!ACS switch if the uAPI forces all IOASID's to be linked to a group,
not a device?

Device centric with an report that "all devices in the group must use
the same IOASID" covers all the new functionality, keep the old, and
has a better chance to keep going as a uAPI into the future.

Jason
