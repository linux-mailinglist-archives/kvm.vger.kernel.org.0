Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4016455CC0
	for <lists+kvm@lfdr.de>; Thu, 18 Nov 2021 14:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbhKRNga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Nov 2021 08:36:30 -0500
Received: from mail-mw2nam10on2084.outbound.protection.outlook.com ([40.107.94.84]:11481
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229914AbhKRNg2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Nov 2021 08:36:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Clk03WFsvmsII2I0P/bHVIgaY4EsJRr3YnR1XlIjzeVgSAonsoYUPGHoFoEwOtom3ilbdGuxQGjIQe4EU7hsOgiuu2BdXieUBVPPxxttVXKY1AttoBBHYkPwlODwE3J2WAJd5Zaqq520fzc4J0XM1p+gvKBQC05U8ZaLEFvzwzScVNQsfex7JD0ejzh5z5lVqVn0VTyv32XiYnVwnyewKsQHcC0/uRKI6KXFFJn8XpYjwufs81oGgjKzb6dCjxbsNEAXvLTVdlLcfWVgNGItpZy9AYmQBal3wr9EWXQlF3Mvr7FMeAbABi/iy8JOR7RucXHn93m9GIHnHwulc0pa3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZCIx65l7p6KxMV4p5W8gTiyzw6KMgJGOLfUIqFrms+0=;
 b=Hps3Z4gic6OTStPF1n3SFOI0Otv7ckoXXwFY7x0iMCRPXFAG9jCxwPpLRv0mMq9whCcym/5aHznhxGL7GSccAK4ss7JVapT9bZEDlxXlGU8UPSlRQg5WFdk3I41L60zEye+Fnj3w2TnshFYa6tBCcnGwNWE6nRehnNBRuA6zGrd8gGVEaKfTji5fFuC5ODcCv3N7e1AJ9PjbTKzuS5Xzk6o1bC1Xf7/az2I8SqCtnxGfb6KPBuQJYrW8ccY5pRTVLkHeTa6SVtDrhzp9ULrTjO4YpO651v8xeunp5Y2Cx8H6rJsIgl5UXAwlGiQEg7hoUVue6BJpXbpqKd/B9oI5+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZCIx65l7p6KxMV4p5W8gTiyzw6KMgJGOLfUIqFrms+0=;
 b=f5wENjpd0zdGlhdcqx5z2e4eR0Ztk/MEGzPc5HBqL69j8dEW1NQMXKAank43uTYVC2yWK9IyvqIT26cB9c5t4INFvAMmfNlcb0J8HaXExFs7p/zcgoRjxaAIViWZtfOzJYpd1m6oikCPKYLhM2nhLMvxpBS7RXPxL9Trxl2fDUMUKQQ3PdtvjZO0iY91RaZyNNWLlYF1+8PAkXId9j8ocb0Aq6WQ4bmB7ewtBmoyMVZ0wWQ5lZUHqdGBYVypwXB8U8LgAMBBI3JvTDdct0KoIm1pXLu05arBphiDlvH5uDUOfyLydQBL/UNy9GpDJKE7WB0L59dumJQsoKauWz6EkA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5362.namprd12.prod.outlook.com (2603:10b6:208:31d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Thu, 18 Nov
 2021 13:33:26 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::5897:83b2:a704:7909%7]) with mapi id 15.20.4713.022; Thu, 18 Nov 2021
 13:33:26 +0000
Date:   Thu, 18 Nov 2021 09:33:25 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Lu Baolu <baolu.lu@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Cornelia Huck <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        Diana Craciun <diana.craciun@oss.nxp.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH 01/11] iommu: Add device dma ownership set/release
 interfaces
Message-ID: <20211118133325.GO2105516@nvidia.com>
References: <20211115020552.2378167-1-baolu.lu@linux.intel.com>
 <20211115020552.2378167-2-baolu.lu@linux.intel.com>
 <YZJdJH4AS+vm0j06@infradead.org>
 <cc7ce6f4-b1ec-49ef-e245-ab6c330154c2@linux.intel.com>
 <20211116134603.GA2105516@nvidia.com>
 <BN9PR11MB5433639E43C37C5D2462BD718C9B9@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5433639E43C37C5D2462BD718C9B9@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: BLAPR03CA0093.namprd03.prod.outlook.com
 (2603:10b6:208:32a::8) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0093.namprd03.prod.outlook.com (2603:10b6:208:32a::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Thu, 18 Nov 2021 13:33:25 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mnhXZ-00BmtB-0Z; Thu, 18 Nov 2021 09:33:25 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c205d97-ee9d-4c96-abad-08d9aa97ffd8
X-MS-TrafficTypeDiagnostic: BL1PR12MB5362:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5362A920B7859BA1B7F61EA0C29B9@BL1PR12MB5362.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DFceW+opftToJIT8FHDWhi3l5YsUm/+BQiisO+J5j02nP3yDYv/Qdez51xoj8kYpP8dFte8ABkspZbs7BxHmPK78WMCuoFdK6NCGVpU9QFqTzoDa4u/QptwGAALNbcs0D/0ir3NhlFmYYcDpIznoF3R5KZMfstRkE1Arg2+nctxL1mP5oJia1De3hcufW2kJNL5dAZxvk7UCCk9mkj+fZLMvxTsMJFibK+R8WDBMiIGtDCM28jSyRqVnWNXMubtWS9ZfmYfZ8Ghr3xrCWUKKWFkVYRK5c8BPV7sREN0F5C96DqUA97aF0EvfUwUY4YVdlh6Y2Y2VZ5bLq4qQ/W0al/+Ir+99YEQadkbHuV7Z8JrsckAGupN9o2C1SZwCTNDE4yWELmMgIGtUkSBz+4m90SbcM9ZHiThPVXp7bcWJsrdfUEVdTp03aOwsxveX4ZQrNodBS7V63oPwvIRwopGl21X+OehRiaxqo6PoBq7QtVk2J3RwM+fx6pJ45f4rCR+WMUVKq4VrehzqouYrHnfQ0iakTrKhMBCSJfFRlXGwmcnasBWoUgbipDyf6Krl9qwQu1oWC9Lqmzy/y8cUeUiwvq874C0QraLYXBWFEhOiyY8n8imYZqTL5139H8YL1Og9Nuspa0UcJsO1Z9A2uJOW/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(36756003)(86362001)(4326008)(8676002)(9786002)(9746002)(83380400001)(7416002)(2906002)(5660300002)(53546011)(66946007)(66476007)(1076003)(508600001)(8936002)(6916009)(316002)(426003)(2616005)(26005)(66556008)(186003)(33656002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GFAyChHKmDj0XMSmzvPXIhSG3A08vV0zlGs69SHgwctJ7yNZkqotk6UuAFkN?=
 =?us-ascii?Q?dNVgXDjcYvYLq02eEfAplXRIDw16Lsa2/3eyqep9Qk7KolthrPouEAsf3FhY?=
 =?us-ascii?Q?SZ8UBs2+oDSCNijCNz+cxAzoPUZJmaoc0YBwsokYVeyLDzJ028HSeONM5XTE?=
 =?us-ascii?Q?KTKkKXXgU1pacGbTUTlVlGHcCj4GW0LsAaRRwD+wjnChL1V9g9ZzhdFGkEOi?=
 =?us-ascii?Q?LI6APbsRCFtsPtrF0hlRLzDVuuA+xTyViVvWalF8GDE3YKY9hbz0Vs7l4BFI?=
 =?us-ascii?Q?OyQQ5V49VPFfX+9yduT8HMgbuinNNbZgXvF5HeVgMVbeX3W3Hv8GUjcefjjc?=
 =?us-ascii?Q?Yo+s4vA+vbveLFv8C0CWeVl2S/kLHtYZ50bo1IpJMdGA2XgdAmcIgOyEc4Ti?=
 =?us-ascii?Q?VPoxOH2XbJiiQ9YhP7j5mseb5o2jcKHblsA8/jHDR0lTzAMasSkazwgoiuIR?=
 =?us-ascii?Q?64OW829xCmHwQmgogYyxEV5bmZafvoIKA7RaORFL5rtVUTSUofWMm3ZZXkR3?=
 =?us-ascii?Q?UwwyDromTpBPnZ/NLFcGeddEz+fPoTmGXlkyNauKT0fgZuSJZgplVQ9eR3TC?=
 =?us-ascii?Q?JEuzsA1l3Ae8dTs/g2bOwMDlH6/4y2xDGXMgapzuHry855lZe03RvQsUvU1s?=
 =?us-ascii?Q?ogD2UdHAzwsjSRvWDbL92b5p6PxiiUclNXsyXo4Vv6Ml7A8B9Uh4QT84WZpL?=
 =?us-ascii?Q?8ezhzAgcHvXsaVM493VFGiDXI47fs4Qpcbt//wKt+8bHnl+keVZn26AKjjKd?=
 =?us-ascii?Q?q3zhacjACym95Ng/yn7oV6aowR5olmjmSKNOr32mBte8+0Ri0eLQCfe5fnBi?=
 =?us-ascii?Q?5hAM8QuxJvRwNS9euH19APSg77Cz9TP1uRAzjNfHF/GDg9FHQ+gebEcmhp87?=
 =?us-ascii?Q?vyBn2Xv7uBne33z3cMdwcM4rcvSBqKkw6btViI8zfHn84jLTrVXyAsfbIr0d?=
 =?us-ascii?Q?24jtL3u3upi+jkuveEmE8WqwH/W7j1+v5ynLRfGKedJWeQEArq+M/czCLCl/?=
 =?us-ascii?Q?1SdBc9RwHSBFmWVNK4PfRNB+LVGUYJ7JpRyp1hEjtZ9+9aKwACcLkrJ4WqhM?=
 =?us-ascii?Q?lz+vOyy+Ij9pgGxCruJbQi3LgzpbHolCcFfdPojR0cvtqxtfLbF0oCf4is+Z?=
 =?us-ascii?Q?Hl9ZOz0FM3PW8MKf/vmgFGTeg1VDRZZQniwhFuHBP9JJhm049DKYIiXHqdYd?=
 =?us-ascii?Q?jiEc2mIsidD4cHpbmdRMzDAme3reSlsHoYpIIvUFGKveAuATR98FCM4Awan3?=
 =?us-ascii?Q?aT396TQDM94/GVEnG2pFwki20UxP2yLZkO2t46+ISS8hsih1seYnr06jBAuN?=
 =?us-ascii?Q?tvtgG+/TfNO3Ft5wdHDn7gzSnfAGD1L25Hzg1aet9YMY9vdFvrKaQ50UDqDI?=
 =?us-ascii?Q?6y1Nw2Yd29jwrBMByyTsaMd/b0Yn2oKrxsN9rQtnbTXwlLKX3EhFoGu3SJsQ?=
 =?us-ascii?Q?1zEKuVQIUd5zArvy6tw4gEFwM/E1//GgkzvbWLBqWsRYF26UO3WTVgzW+O7k?=
 =?us-ascii?Q?FwyeOXa3rtCNU8GBGU/tSQB8ctJXV60F5CqmZllB0wOln0RtiyLu1zjzUlKq?=
 =?us-ascii?Q?3KZ4P3fiVB06cVxuy+Q=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c205d97-ee9d-4c96-abad-08d9aa97ffd8
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Nov 2021 13:33:26.1716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eYvLubJL/EmilPm/bregIgK8u6YBTCNgKV2+pFNDTDFAwDpDOyG25nXkLhRVvafN
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5362
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 18, 2021 at 02:39:45AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Tuesday, November 16, 2021 9:46 PM
> > 
> > On Tue, Nov 16, 2021 at 09:57:30AM +0800, Lu Baolu wrote:
> > > Hi Christoph,
> > >
> > > On 11/15/21 9:14 PM, Christoph Hellwig wrote:
> > > > On Mon, Nov 15, 2021 at 10:05:42AM +0800, Lu Baolu wrote:
> > > > > +enum iommu_dma_owner {
> > > > > +	DMA_OWNER_NONE,
> > > > > +	DMA_OWNER_KERNEL,
> > > > > +	DMA_OWNER_USER,
> > > > > +};
> > > > > +
> > > >
> > > > > +	enum iommu_dma_owner dma_owner;
> > > > > +	refcount_t owner_cnt;
> > > > > +	struct file *owner_user_file;
> > > >
> > > > I'd just overload the ownership into owner_user_file,
> > > >
> > > >   NULL			-> no owner
> > > >   (struct file *)1UL)	-> kernel
> > > >   real pointer		-> user
> > > >
> > > > Which could simplify a lot of the code dealing with the owner.
> > > >
> > >
> > > Yeah! Sounds reasonable. I will make this in the next version.
> > 
> > It would be good to figure out how to make iommu_attach_device()
> > enforce no other driver binding as a kernel user without a file *, as
> > Robin pointed to, before optimizing this.
> > 
> > This fixes an existing bug where iommu_attach_device() only checks the
> > group size and is vunerable to a hot plug increasing the group size
> > after it returns. That check should be replaced by this series's logic
> > instead.
> > 
> 
> I think this existing bug in iommu_attach_devce() is different from 
> what this series is attempting to solve. To avoid breaking singleton
> group assumption there the ideal band-aid is to fail device hotplug.
> Otherwise some IOVA ranges which are supposed to go upstream 
> to IOMMU may be considered as p2p and routed to the hotplugged
> device instead.

Yes, but the instability of the reserved regions during hotplug with
!ACS seems like an entirely different problem. It affects everything,
including VFIO, and multi-device groups. Certainly it is nothing to do
with this series.

> In concept a singleton group is different from a
> multi-devices group which has only one device bound to driver...

Really? Why? I don't see it that way..

A singleton group is just a multi-device group that hasn't been
hotplugged yet.

We don't seem to have the concept of a "true" singleton group which is
permanently single due to HW features.

> This series aims to avoid conflict having both user and kernel drivers
> mixed in a multi-devices group.

I see this series about bringing order to all the places that want to
use a non-default domain - in-kernel or user doesn't really matter.

ie why shouldn't iommu_attach_device() work in a group that has a PCI
bridge, just like VFIO does?

The only thing that is special about VFIO vs a kernel driver is we
want a little help to track userspace ownership and VFIO opens
userspace to do the P2P attack.

The way I see it the num device == 1 test in iommu_attach_device() is
an imperfect way of controlling driver binding, and we can do better
by using the mechanism in this series.

Jason
