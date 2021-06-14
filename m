Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 961FE3A6B2B
	for <lists+kvm@lfdr.de>; Mon, 14 Jun 2021 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbhFNQDc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Jun 2021 12:03:32 -0400
Received: from mail-bn7nam10on2087.outbound.protection.outlook.com ([40.107.92.87]:24673
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234444AbhFNQDb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Jun 2021 12:03:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axgmic8ptwh+1Xru0uKQ7wXNY2DRztrC+9I4NMM9CPNUJK2bZkV8TJZaaXvJfFrCXXXncRx/WFc/9ov/PyIKlyxk0Rcz0rb4cxovzGP34aqkuwBMeyMkZYhn1FZnIvkSHusc5rT8Ut0zdS4q9EbznC05FycHvoD0PC3G7ZC5ViTFm5olR5w1xMiYrPlBWj9iBjzhaAfXEKEFh4A77NeXTbHEdfjCLXsbKulGcr4oG0vr9Sv5FmA9trToKk7OqBTYFf3o0Sr9laZlZy/sUSYXStQa11/hRpJb4X888i7WJE0WC2KPwNqCIsoUXU7iRwHyI3qM/+yKwS+c58O0VaIsFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HU6HPLvBEPe7VsjiY4cN745HvK5WWzsRChIwlYj/tFQ=;
 b=R0HEQeelXgWEbxOU0v8ES2YNf54AOiy/QQ70C6yLimtF5OggdiElXlWvYw02T73dFzxS2MRaH6XJn1A50AHncj745vjmcU8WGPo3FTQ12LVLxTE6y11E3o0XjJ/XLglOF3s9Oagq7dPVqu3IRgVn5xswlQwHaJHdNsx+Pbw2e4C7vbevBb+rtt1GxduBmF1wbEcxv8bjbmCt1YKxFFwC46g3AwLAMFlLuHgMy2jZP9emzkwoGsY5gXi9I+GSSlxxHGUtvJqgp0wB1epsLjsMAjRIqQ/0KXMqQJBdvYHXx1kJUct570MsrixnzB4MCIhcsmR+s4eWbmsZYgHWqrlLNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HU6HPLvBEPe7VsjiY4cN745HvK5WWzsRChIwlYj/tFQ=;
 b=rohn6VQOp6t40O1B/hlN6lYy19k9DFsknkvchkpTL0vkfek7SrUGL/UkgenlGLXSDY7G73ilsJVrnPN1HBtzHGZ9YJzz7CjCQu/0eDsMHlgbWFhd4iW90v+HLArasuB4z4o8oQf/w2W9ZW4azOubkJyLxG8jpP2MGPp+IdlRn2/u4/IWc9bptK8ji5mwMFbvAZI5b/ljUcbYhkMUBL0mxTZGg7jqDc6KXl+KGd7h18WcQBZauuMWr90Sub83Wi0FSmNSDkutl1lHLoTbLCMad5yjW5U9FfsmmeYVcz7oylHd2/u/0HgkpDcJSeRx+1rbnDbE1ZGPw5SLQKE6Ow//Cg==
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5318.namprd12.prod.outlook.com (2603:10b6:208:31d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Mon, 14 Jun
 2021 16:01:27 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.025; Mon, 14 Jun 2021
 16:01:27 +0000
Date:   Mon, 14 Jun 2021 13:01:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Max Gurtovoy <mgurtovoy@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        cohuck@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, aviadye@nvidia.com, oren@nvidia.com,
        shahafs@nvidia.com, parav@nvidia.com, artemp@nvidia.com,
        kwankhede@nvidia.com, ACurrid@nvidia.com, cjia@nvidia.com,
        yishaih@nvidia.com, kevin.tian@intel.com, targupta@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, liulongfang@huawei.com,
        yan.y.zhao@intel.com
Subject: Re: [PATCH 09/11] PCI: add matching checks for driver_override
 binding
Message-ID: <20210614160125.GK1002214@nvidia.com>
References: <20210603160809.15845-1-mgurtovoy@nvidia.com>
 <20210603160809.15845-10-mgurtovoy@nvidia.com>
 <20210608152643.2d3400c1.alex.williamson@redhat.com>
 <20210608224517.GQ1002214@nvidia.com>
 <20210608192711.4956cda2.alex.williamson@redhat.com>
 <117a5e68-d16e-c146-6d37-fcbfe49cb4f8@nvidia.com>
 <YMbrxP/5D4vVLE0j@infradead.org>
 <1f7ad5bc-5297-6ddd-9539-a2439f3314fa@nvidia.com>
 <YMd1ZSCZLjaE4TFb@infradead.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMd1ZSCZLjaE4TFb@infradead.org>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR06CA0008.namprd06.prod.outlook.com
 (2603:10b6:208:23d::13) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR06CA0008.namprd06.prod.outlook.com (2603:10b6:208:23d::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Mon, 14 Jun 2021 16:01:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lsp1i-006pjY-08; Mon, 14 Jun 2021 13:01:26 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d5e27681-8f62-43a5-4cea-08d92f4daa6d
X-MS-TrafficTypeDiagnostic: BL1PR12MB5318:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5318992CEA4E0EEA336A5DF2C2319@BL1PR12MB5318.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8wUbUVd2VaKQOjYnaWQL4E7POwhaRwwX7JlL3uMX/zS19CQAxM5T/yb+1KSzGiEFplsLwnAc9zm9Uu+Ut8rpu0t/VYEWsPfubA7nSe9M9c7eVooEtqjcVDvbgBB2KFyB5n+EJ1iJ0TPJOrltghi1prNjBDpL0LEEkr/Sc+gJFt+xHyPzlU3xDkrJA/Z/xzhpXP+a/zASeFqZjgHOIP1OvIs3MzSNoyYVYhL7VhHKkkla3xgOJYVcePhlSXpM42UPehAyEyIYG/d4CcJFCbkZPQ4run/vwZsZhFKnI8NXVhtJgMRJbw2uxQH0rAemxF+rJ3L2Fl8vZsHsIXJFZArPqwhxXbhM4ixIglinMLb68lDWvBM0EFxX6qPbDtefJ3gKFA4l7NwOE9jnWfmDjkNVQEA041mINYXS3u+MPIDSz3cZtRiTRH0DOhseBGnV2Wc9VkFBf8qo7GwgMkMgfDB0INUiddSr6mbWixkxOdthnedJ61H8RUqCYTeoH7w6YZkGUGJsP8+0/2S2CoclhJnN2X9qWi1HtmMdxFuGkstt193avXOEbOkcrEHKuMUw5NZBhwa4tkaxcgRnqUkR6FFc2+4d6b9h4jKzq08rITk/ntA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(478600001)(4326008)(36756003)(6916009)(426003)(2616005)(8676002)(8936002)(2906002)(9786002)(38100700002)(186003)(4744005)(5660300002)(54906003)(1076003)(316002)(86362001)(26005)(66476007)(9746002)(33656002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q2O5k/WP3nB8/UKefjeCMsRMp7tJQO24ZIiu+dkh/LR9JZPoLAdQ+QfSQYgc?=
 =?us-ascii?Q?E93JmPvZM87h/gK5RYt+vdQBzh/of9ECpzARnF+Lec6Q/Wzcq24n6avlviEr?=
 =?us-ascii?Q?KjyFkPje1hZ6TnGPLZL1i6XT2r3FKiEkoQu9ZBAVpw3bTBoUoRDTfUqSMP5P?=
 =?us-ascii?Q?2ZTDRUGbvyAtNPeAsXis0V3KIwwRoXnZk7Y7edJpITwfBf0tyC1QTN1+Inf2?=
 =?us-ascii?Q?SnOXIv9MKXucx5h7kwdDFdDSHFzM1ePkeu8PG/E1R4Wgs0Quf4Vae4K3quJo?=
 =?us-ascii?Q?5fjCDlwogp6sngUMYnbZhAReA+NyJayd82PZq8qUjK06Uh1QzsesHcI93ORW?=
 =?us-ascii?Q?R2iVAXEhn7zL+7m9THfKv/Ahgw3ZJLTQCM3ztH2WF5aUiQwQsUkkpucnke4h?=
 =?us-ascii?Q?Uekto/9XU92MEZyhyiwnryPYUsev3N8gzO+f1JoOeAuWBzRMBAWTidpgzGGI?=
 =?us-ascii?Q?qRC+OvMtOBMWPQzGZSuZb/JS58k2ppuFXXAVht2MwIY30sItV7doWUbhmmb/?=
 =?us-ascii?Q?hTDDspx7jFGa8ls/rnUo43OnRGDAvSbNKwPaMRUR1zstgajFQYffRPkxl7h+?=
 =?us-ascii?Q?veD3Z2Ar9J3if/a9IEz5O5xisF7BYtHwYLUsEwkfopX01HC+tvdvXlrjzU+w?=
 =?us-ascii?Q?o5TlqtPvCItxS7/w4/kSW4XxeD7i2PKhYjluS/0d0O/mMIWc+8Bv4MJ5lBLg?=
 =?us-ascii?Q?0y6Yvk8npBInHS9eYwJtBqpHBD2tpk+HAjxHa8dL05sslIMst6tYfsigsCbX?=
 =?us-ascii?Q?lpx2ybBy6OERM1GwQjrGP553Y1VMOHv/z2MdAc1isAs68m/i8CS970MK/z49?=
 =?us-ascii?Q?lrxpf1q7I7zp9BJgvGva6IAKqXn2dlDdasJV5Ufc4e1735mlam1mUhUTIhV8?=
 =?us-ascii?Q?zTvgo6m9GJMFSFkI78cdQZaYE0is7oxsqfNrD5f4rP3pFHBpplc8wqRpa8wL?=
 =?us-ascii?Q?PJgKHYPFFc0+TAkwKbhVZtlHA+t+SmzqMnqfnwzevnDb3G6mFNLBeA+bZrJW?=
 =?us-ascii?Q?5162+uYVZl1ysS9b/VhtF8XOcWGof0MFwexzRUGb9mazSEOye6SXb2McO7Np?=
 =?us-ascii?Q?Mf/p7RwLfR7xoschURjstw8am/KmmkMPn1kjcsgtrF6cMvEI3lPvHd6etJEH?=
 =?us-ascii?Q?Uvl533uKqcHq9broq8Ts36+KGobS4PDpmTgyTNdWP/AQoMGVUiQH3iVkbb4i?=
 =?us-ascii?Q?Yx7oOxh3BpH9zygfQDKiZ5a11v+ScOf+IkUxKF4/yhjrS/QVa06uF/H8lvWZ?=
 =?us-ascii?Q?rrB1P3V3Ue7chB3xMG+fLfIzfHcIf7eaQhPMZqbWLg49tAQjCvgM4ZIq2Xev?=
 =?us-ascii?Q?FN2+tX0Qdr253kmKJASeZdU6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5e27681-8f62-43a5-4cea-08d92f4daa6d
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2021 16:01:27.1079
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hl8MH2urncrFzEVeYhTWoie4TjJuHJ64aBvL2H58+u+ltu324mzUoRzgadwxIvrQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5318
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 14, 2021 at 04:27:33PM +0100, Christoph Hellwig wrote:
> On Mon, Jun 14, 2021 at 11:18:32AM +0300, Max Gurtovoy wrote:
> >   *			into a static list of equivalent device types,
> >   *			instead of using it as a pointer.
> > + * @flags:		PCI flags of the driver. Bitmap of pci_id_flags enum.
> >   */
> >  struct pci_device_id {
> >  	__u32 vendor, device;		/* Vendor and device ID or PCI_ANY_ID*/
> >  	__u32 subvendor, subdevice;	/* Subsystem ID's or PCI_ANY_ID */
> >  	__u32 class, class_mask;	/* (class,subclass,prog-if) triplet */
> >  	kernel_ulong_t driver_data;	/* Data private to the driver */
> > +	__u32 flags;
> >  };
> 
> Isn't struct pci_device_id a userspace ABI due to MODULE_DEVICE_TABLE()?

Not that I can find, it isn't under include/uapi and the way to find
this information is by looking for symbols starting with "__mod_"

Debian Code Search says the only place with '"__mod_"' is in
file2alias.c at least

Do you know of something? If yes this file should be moved

Jason
