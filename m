Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFBED414B64
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 16:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235001AbhIVOKt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 10:10:49 -0400
Received: from mail-bn8nam11hn2244.outbound.protection.outlook.com ([52.100.171.244]:29153
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234515AbhIVOKs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Sep 2021 10:10:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxeUmoOVjTiQ6LNRX8ZPnTohaKQnrIVqXkANCbSk/RscqBCh6cbl1UdXzCZwsFOeKfx6aijcbp/pFRALWSxI5ksshXSRlLXyFtaOISdvxVw22OMMvIIyGsVzJlxXPhJipx4388f1mXe8UUn2WOV+XBzAvl5NdAemIYPVd9mboZd3g6LsrPPTHJZkQ2yjZn7ty67J9bIfELWCLzhBUiP4vPYaUTmtAflI5H4Q5WVxCL8eWVZZo11HbWhjxOfivItv3VrBd9EIJGkxEmNOOGLCZyQ9pzl8eAkGlG9vLtNjgG1dId5t0cOHbdRtMZ8S+RCkuWXiYIhfQOvFN3vdG0ybdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=JZzDL5X+pTCfKIz7vVOsV5X0ebbvy+5ogNG+qERjul8=;
 b=kDOgyU3Rn5xBwkU203raxm3085yNvgzTvPlVYTWwd3yokCX7xa2J1lW82xEUpeelwGHRM6aMMpiT0dceTHFTNCygPc680TDLNF5EFtBklwTmr0LjD0Fln5JesTydtdfQlCyj7On+ZHb8On21OVhNFRtqnn6XG9TzwpIx47mXCsHk83pnYqab7ABaBI7iEdthCIzqS8yl764zc8Me4REycOeeQbfRGYVa6G337MLOhMowejWisMb5gXcogr0B8L7SYeIXZ6KAnAFvkTexcNv47WXBAEVj7rstn2ziMXUBIcaiki0mp58p7wkJ4S3wqZIJhV4Mw85ltp3yx70+yKntcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JZzDL5X+pTCfKIz7vVOsV5X0ebbvy+5ogNG+qERjul8=;
 b=Y52NCVTOtV8qxcvczD16kFUInrJxPurGbf38HiLkRoH9DIzIrJFr7By9EXQLrWvc6bvVfJyQ4EsiMAIB9Sw6ZkbQo0E0kF1wZGR0yQ47HrbsSv3OYh61fqctS+A6uJk/n74PAHiNP9pTTGk4drIlnJ4XVVEV/2IddoVfQ8i8xjqzrgBqt4mDA4zkzpVMjCNqPKxEqayir5lgBw5karlH8Nl94j/cKVBEbcrxloENSbimwIb6tsnGtJWcMt+gENp63Fw7yh8EPgdGVzopJWKA/kTmuuXyadane1IUSi2yEiS4qwqFwApRpOUynpXzplKvF02/F5kCb9YYtze5Jzm9GA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5111.namprd12.prod.outlook.com (2603:10b6:208:31b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15; Wed, 22 Sep
 2021 14:09:13 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4544.013; Wed, 22 Sep 2021
 14:09:13 +0000
Date:   Wed, 22 Sep 2021 11:09:11 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     "Liu, Yi L" <yi.l.liu@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "hch@lst.de" <hch@lst.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "lkml@metux.net" <lkml@metux.net>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "lushenming@huawei.com" <lushenming@huawei.com>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "yi.l.liu@linux.intel.com" <yi.l.liu@linux.intel.com>,
        "Tian, Jun J" <jun.j.tian@intel.com>, "Wu, Hao" <hao.wu@intel.com>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>,
        "david@gibson.dropbear.id.au" <david@gibson.dropbear.id.au>,
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 11/20] iommu/iommufd: Add IOMMU_IOASID_ALLOC/FREE
Message-ID: <20210922140911.GT327412@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-12-yi.l.liu@intel.com>
 <20210921174438.GW327412@nvidia.com>
 <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB543362CEBDAD02DA9F06D8ED8CA29@BN9PR11MB5433.namprd11.prod.outlook.com>
X-ClientProxiedBy: MN2PR04CA0011.namprd04.prod.outlook.com
 (2603:10b6:208:d4::24) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by MN2PR04CA0011.namprd04.prod.outlook.com (2603:10b6:208:d4::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Wed, 22 Sep 2021 14:09:12 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mT2vv-003yWY-DV; Wed, 22 Sep 2021 11:09:11 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a829c095-f988-4bd1-04ed-08d97dd28dee
X-MS-TrafficTypeDiagnostic: BL1PR12MB5111:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB511166F4BF50523C5582227CC2A29@BL1PR12MB5111.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?WGRFafFL2RXBqTLUwWRs9rv0DdWcm8In4FKWigJKzE7+VWlQLz2od25OtAdo?=
 =?us-ascii?Q?NNpkpFezKViJlo/ND9E4fLgjqJwhi6P4ggs3XBC2eC72W4UtfIWpUDpS0xqh?=
 =?us-ascii?Q?ddgMq1z0dkwHYjFRE0i/xpSbEGaGn+yQ0p+vFIyjOUp5e3Itj8Xg50YWpZ2w?=
 =?us-ascii?Q?eXuass/mfdhewxdf6aC0H+h6eJzojX2tL5esF0/ioFiLdiXALSgRmWcLa5JY?=
 =?us-ascii?Q?LtnBIwdxemeHd+BbSvrDtvYGQNdjENl2eZP34gUpCr4ColTEJuQRR7rVRmZU?=
 =?us-ascii?Q?/MYYgpvsCaBTDU44s8WF0s3lrS5C0c6oDng42lSJ5C0rUWUEdCVyoaX5xxUt?=
 =?us-ascii?Q?pAW9hjc/aQ3DMM4EJTce8biLTsgAfCOOZSzUm52j9USgEhT91jD3mpdCudpc?=
 =?us-ascii?Q?/YEKBdPbpX6yqPy3Y9EXi+UzZwqmYJNogNuu5fIymFtEfcDDQ3fzQNZ+ss9J?=
 =?us-ascii?Q?SCiA0Vug/E8abwUxTtQnqnTrwhUntMXRRJEQxancIdtAhyxuku/S0IgIklUU?=
 =?us-ascii?Q?TbQZhQgmc+/8BUessI5aBdWQQU5nV7nQPv7zS9Q9pqQdNrWGbn+OG4EKOUYv?=
 =?us-ascii?Q?qq0wVpHCXefAAu1/9URV5Rscc5OPHTsUXZIooDKVu2I6r5y3DMuLCmUhmVQp?=
 =?us-ascii?Q?G1tVujUVsPD7P3w3vNgno7yP9G8g+FyxKB5WHHUp4eYBOYox4N+Yr5GnU65O?=
 =?us-ascii?Q?d3Hz4oDziNYRthzHAtuKIuHzsu4Xceme0/uI/nDcK/w287mWAw4MvWsKfgIY?=
 =?us-ascii?Q?yBq1TuIZc6wjoTmybUuK0PRceI5JroM8RUNJoAgKwhaueu2f2h8dQZvHaJtT?=
 =?us-ascii?Q?+hzGAbizFfawrY3nOv5bDGUXHEMpAp2a9E9FlI6HE5bXeXUhmnB3D7tZuZmL?=
 =?us-ascii?Q?nV/B6R0j9YjfJ5bwfr0H90Uek1VLkB1yxxj13JZ5EFrXmViYsbXB3oFeC8c6?=
 =?us-ascii?Q?r2s52rHf7gV46DrQgkVhtWCywvXgPNuQej8SPvtxEww7gOWM4uVPB80K1v7e?=
 =?us-ascii?Q?FLXbOdC8j5sl3ZUPD02RYLo5fDeQ3ei1e2u3tfem3NA6t5IfIR7Zk5jRrk+M?=
 =?us-ascii?Q?8h9960R7aycNmsQgI7U8QiEffAAy0udvG416ZJKWO9Mu4aWRhDXiLYcT49CC?=
 =?us-ascii?Q?t3d9Dzs1Sirwh9ir30o0l0K0UIJYHg5XkWwhtc3aSpEJQOPuGrqrhW4=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:5;SRV:;IPV:NLI;SFV:SPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:OSPM;SFS:(4636009)(366004)(83380400001)(1076003)(508600001)(26005)(8676002)(426003)(38100700002)(9746002)(9786002)(186003)(8936002)(966005)(86362001)(7416002)(2616005)(2906002)(6916009)(36756003)(66476007)(107886003)(66946007)(66556008)(5660300002)(33656002)(54906003)(316002)(4326008)(27376004)(21314003)(84603001);DIR:OUT;SFP:1501;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z1GPiksh4D+KJRJp1DDwm90P8iHuwfwUlkqlODVWm+CKBfpuI8DhQlKve9pw?=
 =?us-ascii?Q?6oNpMXaqrJilrym+08Lfq1k5aHf+5lE/rCTsun16e7l5Pv8fs+w/+aXUKo7W?=
 =?us-ascii?Q?b9SrQhjVC472e4WDrfGM7KqE4Sc44iNCdAUkQDt1Bcf0gh/moGqKqcHIMsML?=
 =?us-ascii?Q?+I/GgNf8o7AxhTm/TidwGcCSnRCUE+0MSbC72sF9f2kDfW2ZxRZeSk1Lykeo?=
 =?us-ascii?Q?7BMM/BiKQo0NQOnwUKF6mdsZksOVNA3l0QnjewYXl1RhtWJyNa6yeuqkiWx1?=
 =?us-ascii?Q?cJTzCwm3yf19Zsoh7k6ItBLcUfgDAC7ewwSW1B5FulkzC42I+NaSac9sdvwF?=
 =?us-ascii?Q?OGB+URb8lDXQFc0/vPaYDoX6Dy4F0BI0Q8llLqEiGJlyrztDuKKGlMvvPeJH?=
 =?us-ascii?Q?FOJQtxFw/DgE7TbnSCQprcqSLIwyzi6nJMmCaS0X6NsK50fCIVPNZD921sfA?=
 =?us-ascii?Q?uZCTbxtQ5hXyMhNSLjchHCRznK89KeTWyyDp7Y5vcHTp4Ji0FXQv0tO0jbQi?=
 =?us-ascii?Q?w9lxzuW1JNBC51aj01ZWeOovG1MJ0Mq34itbmyM1kMMm5q9qE4PFxCRAncTC?=
 =?us-ascii?Q?kq1u7dVpDKsQiqBcbLjuKx5Ms+GA4IDyUs6sWiS3BSb05VzT1pUoGNl+phvk?=
 =?us-ascii?Q?xKFQu0F7Di8Qsjn/TdXw+e5JhIoeR34C3tAW4bDc6gOJCeWqgiUoj4yr3zhh?=
 =?us-ascii?Q?hO+ZozqcKexbd830iAWebjHw/o5Em/PGVo6sM+y/PNbRSngjY7aXSe00oQha?=
 =?us-ascii?Q?Qhf1DoPfDD0yOkfhs0TDbQA8XenzifE99oIO+eha5YHsKS1Y0shY7xBQRlQ3?=
 =?us-ascii?Q?Jgt/th7WSNDS45d0pwmfjzMmycHNrqX4OrWQ9VT3iQCxzjAHo8oGr9O8LNlZ?=
 =?us-ascii?Q?d1p4tekdamuOaRiriVa2uJWZpOxsjTvpjuTKIsjjWM2iih4UzTVGW6iZHKC2?=
 =?us-ascii?Q?sAB/3iR9mluPihmN97VEg3tJqMetJOnr0sdNrQ+ESiqWpC8vf1qm8gkKlBs0?=
 =?us-ascii?Q?FgukA29XEbeA5JlhvcjijdtnqvOceE2YdY/Fsv1j5WvH+5lWqvZmUFf1Z66n?=
 =?us-ascii?Q?bcXXbhGvLV3XF7VfTkcNhGXeQZaDye82rYj9S5VG+bXXVe6KgoEpNVZmd7QC?=
 =?us-ascii?Q?eo9K9ChFRR+3Z/JGCQxr2VoRFFmorNMxkOwuAEetaJoq/n4rPEDDjJrs7sar?=
 =?us-ascii?Q?wr1FI4A8RoRZkOVW9qv9P553PTrmqFGUipWPTWbpX0esXRdcd3ihHtF0Bbbn?=
 =?us-ascii?Q?/KKpnBFMiE22nkeEg0HM9bpCtdGzovVjyDchqE2ROsTVl59b4QqCfk3ZAOVw?=
 =?us-ascii?Q?QhnAEWSSoE+sn0a/KGYdBxjD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a829c095-f988-4bd1-04ed-08d97dd28dee
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 14:09:12.9965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qHU9lKcbSQxAWV8O8RwCTWRbEhlsK0s5ycFM+8ZqGDhE+FCwSyQcGzLO0a7aHcym
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 22, 2021 at 03:40:25AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, September 22, 2021 1:45 AM
> > 
> > On Sun, Sep 19, 2021 at 02:38:39PM +0800, Liu Yi L wrote:
> > > This patch adds IOASID allocation/free interface per iommufd. When
> > > allocating an IOASID, userspace is expected to specify the type and
> > > format information for the target I/O page table.
> > >
> > > This RFC supports only one type (IOMMU_IOASID_TYPE_KERNEL_TYPE1V2),
> > > implying a kernel-managed I/O page table with vfio type1v2 mapping
> > > semantics. For this type the user should specify the addr_width of
> > > the I/O address space and whether the I/O page table is created in
> > > an iommu enfore_snoop format. enforce_snoop must be true at this point,
> > > as the false setting requires additional contract with KVM on handling
> > > WBINVD emulation, which can be added later.
> > >
> > > Userspace is expected to call IOMMU_CHECK_EXTENSION (see next patch)
> > > for what formats can be specified when allocating an IOASID.
> > >
> > > Open:
> > > - Devices on PPC platform currently use a different iommu driver in vfio.
> > >   Per previous discussion they can also use vfio type1v2 as long as there
> > >   is a way to claim a specific iova range from a system-wide address space.
> > >   This requirement doesn't sound PPC specific, as addr_width for pci
> > devices
> > >   can be also represented by a range [0, 2^addr_width-1]. This RFC hasn't
> > >   adopted this design yet. We hope to have formal alignment in v1
> > discussion
> > >   and then decide how to incorporate it in v2.
> > 
> > I think the request was to include a start/end IO address hint when
> > creating the ios. When the kernel creates it then it can return the
> 
> is the hint single-range or could be multiple-ranges?

David explained it here:

https://lore.kernel.org/kvm/YMrKksUeNW%2FPEGPM@yekko/

qeumu needs to be able to chooose if it gets the 32 bit range or 64
bit range.

So a 'range hint' will do the job

David also suggested this:

https://lore.kernel.org/kvm/YL6%2FbjHyuHJTn4Rd@yekko/

So I like this better:

struct iommu_ioasid_alloc {
	__u32	argsz;

	__u32	flags;
#define IOMMU_IOASID_ENFORCE_SNOOP	(1 << 0)
#define IOMMU_IOASID_HINT_BASE_IOVA	(1 << 1)

	__aligned_u64 max_iova_hint;
	__aligned_u64 base_iova_hint; // Used only if IOMMU_IOASID_HINT_BASE_IOVA

	// For creating nested page tables
	__u32 parent_ios_id;
	__u32 format;
#define IOMMU_FORMAT_KERNEL 0
#define IOMMU_FORMAT_PPC_XXX 2
#define IOMMU_FORMAT_[..]
	u32 format_flags; // Layout depends on format above

	__aligned_u64 user_page_directory;  // Used if parent_ios_id != 0
};

Again 'type' as an overall API indicator should not exist, feature
flags need to have clear narrow meanings.

This does both of David's suggestions at once. If quemu wants the 1G
limited region it could specify max_iova_hint = 1G, if it wants the
extend 64bit region with the hole it can give either the high base or
a large max_iova_hint. format/format_flags allows a further
device-specific escape if more specific customization is needed and is
needed to specify user space page tables anyhow.

> > ioas works well here I think. Use ioas_id to refer to the xarray
> > index.
> 
> What about when introducing pasid to this uAPI? Then use ioas_id
> for the xarray index

Yes, ioas_id should always be the xarray index.

PASID needs to be called out as PASID or as a generic "hw description"
blob.

kvm's API to program the vPASID translation table should probably take
in a (iommufd,ioas_id,device_id) tuple and extract the IOMMU side
information using an in-kernel API. Userspace shouldn't have to
shuttle it around.

I'm starting to feel like the struct approach for describing this uAPI
might not scale well, but lets see..

Jason
