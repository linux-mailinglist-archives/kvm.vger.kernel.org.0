Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 561B1399645
	for <lists+kvm@lfdr.de>; Thu,  3 Jun 2021 01:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbhFBXTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Jun 2021 19:19:35 -0400
Received: from mail-mw2nam10on2053.outbound.protection.outlook.com ([40.107.94.53]:55712
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229775AbhFBXTf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Jun 2021 19:19:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DuZIQalD4s2ity89iCZkIuEYkXkHAb387e7wShWsi8cAYSL4Y+L0IT9uIXr3Wfy3GOY2/5LNG/TO0EPdkoDgY4vyp14zi77BmQPpUpKvT/taAlbxQ76U4mPs/BegebbPGhV/kPqWTPZVLdHE4Lk9UXrFt32NnzaB9EWpmFSsNXLVUf5rlquND3kcqF7iOd4Ua4g4zkHowY6MJMw/nodyt8I5Ju7l1m/nj6PvKj2NoNrqAQPsPt+eZHmubya2zFhHfuZ9C+t8CCDCLbVdqcjXwH/xNScC2oJCck2DplNApcmZtNx4qE288as3BApsw1el6gEcgV1Oc/VjWk/38pFMYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3B1J2om+Qr1X7+8bz+k8X8flFJg7wwyeziQlnjFKi4=;
 b=YYMisphoYQw4xLaGOyp0fj8ioAFhmredkR1zaUmSsUT9WjO3+IWnbIEB9U8MrdVYU+YCK8YDEEvTOdfYDFSs47iRl+w777zjydUzFFd+1fx66BN/S4kzlmPbUXR/Idj+abNtMnkrNLlpd6Azhz8t5xfUopfDmX8Dm925agicGcUO9TwFlNKs11y7buHy0+j6268k5NxqeVfvOAsNgc+2fhK7ce127znbwBtabqZpm1w4MCaRQ5GfvLp7NS51tazHJMnRtvZCDm16gNmwKtM1DTPF+Wbl/ywissu1qXxAlU0Fc5Djj9K6qv8bBlG3Yv5zVC5Men901VdiiRqg9eykZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E3B1J2om+Qr1X7+8bz+k8X8flFJg7wwyeziQlnjFKi4=;
 b=NxFZBEUrGwqbWJhgraHul3y6cm76swJp151iu2XD2+XwZKcwAfDesfCi4I7ZKWhD9oPwuVZbRvE0jItol97Pk9kYV3qJa1OL4JpUsDSBcgpT7WMDClhIa8J/PTffaVCkB0E8UDKB0H6P4iBGPG+ov25Ud2NLRyZ9UYHJPCmflDCnRluWvW0UOicBBaJkilUZ69wi7ejzkScppYqiUMtKjh5ojUnr9Ps3XAHE6/HKiD4gy5FSsBBsykly1FWTFVkAtjAdFTy9ISJksrmRl4FTxQ4sADGLlVfmZUXtbFI46/vUqTAAy/hGZXv6n4ZPAif5kyToiNi8LeB+g15VwehdrQ==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5336.namprd12.prod.outlook.com (2603:10b6:208:314::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 2 Jun
 2021 23:17:48 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%6]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 23:17:48 +0000
Date:   Wed, 2 Jun 2021 20:17:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Dave Jiang <dave.jiang@intel.com>
Cc:     alex.williamson@redhat.com, kwankhede@nvidia.com,
        tglx@linutronix.de, vkoul@kernel.org,
        Kevin Tian <kevin.tian@intel.com>,
        Ashok Raj <ashok.raj@intel.com>, megha.dey@intel.com,
        jacob.jun.pan@intel.com, yi.l.liu@intel.com, baolu.lu@intel.com,
        sanjay.k.kumar@intel.com, tony.luck@intel.com,
        dan.j.williams@intel.com, eric.auger@redhat.com,
        pbonzini@redhat.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v6 00/20] Add VFIO mediated device support and DEV-MSI
 support for the idxd driver
Message-ID: <20210602231747.GK1002214@nvidia.com>
References: <162164243591.261970.3439987543338120797.stgit@djiang5-desk3.ch.intel.com>
 <20210523232219.GG1002214@nvidia.com>
 <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86cde154-37c7-c00d-b0c6-06b15b50dbf7@intel.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR13CA0031.namprd13.prod.outlook.com
 (2603:10b6:208:160::44) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR13CA0031.namprd13.prod.outlook.com (2603:10b6:208:160::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.10 via Frontend Transport; Wed, 2 Jun 2021 23:17:47 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1loa7P-000nBs-1q; Wed, 02 Jun 2021 20:17:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d33e01e7-18a6-4364-fa71-08d9261ca2af
X-MS-TrafficTypeDiagnostic: BL1PR12MB5336:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5336AC5264644576D97048A2C23D9@BL1PR12MB5336.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g4NQc4Lygi68Au9cwMkPpRMz0zHNA2bvj35pGFxYSkfKXYnj4AYV5snGOAgE8X3HnoB0y3B+/TWhQIsED7uKZPCn1Q9gfrm9+k6zrArStDzBZ9CFGs38r6cZjpPs9VUWJVyWn3gb8qWWxOFFSRLQAqJGqbWq/oV3TaAvqBKxePOWUbm5vDUeqp1Gx0LtW2VqvbQ1Fqm7xNtg1YlBi0eEkUztnARTFzAp+MBWpNdPh2/caey3t8QFtbPOPYnS6RgmD9DfldXyuohifFuEPbNnewQpNYJ0uu5h51lf+EeGB/nEYTlYCUo7NlX6KUERoEVi7qy9SwRsB+OqutyZKHOFqcJE1Qo4qsVzn/jjL1GoMWG+1a9yxMGFbzzz+YM4bBxrcYb/6jK79i5ptC9Ml7W6zZLHr0rj8900q9wvhCzdlmxE8OTiaGWaKtwDsAtN7wR2hpsS53vPkm9CURnGsKDRxf1rqco2aQS//BJcvgh+RQUZ8dziTrEd5jkdYo/mHixY+7WYWsKIi7PTSm6ioxuv9DplqSV+TDkXt4x2PBUINoI8VuNMT8kuBmyC1PAldt8WTr7mc8bJmS8N9Q/HugBYHzxMXU2d6rSFHvF7TtwYO/0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(39860400002)(346002)(66556008)(66476007)(66946007)(33656002)(8676002)(8936002)(5660300002)(186003)(426003)(2616005)(54906003)(4326008)(1076003)(478600001)(26005)(6916009)(86362001)(36756003)(7416002)(9786002)(9746002)(53546011)(2906002)(316002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?amdYeUwxcmg4Z0luTm9naGY0UFRHcVM2Nk41NkpUNGRoRWZTQjg4MGZKUytz?=
 =?utf-8?B?MTVDU2xyUUtnY2V2UW53dSticU9ya0FENkhqeGZDWm4vb0lsM0Z0Sk13em5a?=
 =?utf-8?B?K0JyTWVBKy9yUkFVQnd1b2N5ZGVnRHV0ZzIza0x1ekJ6Wlp0dTFFTndlV1Va?=
 =?utf-8?B?V1l0MExuVk5FeDArMS9UcEFpWHBMREsvL05zcHhrMEhSdHNveHUrOUlsVDdX?=
 =?utf-8?B?QnVHU0N5bXJNZVRIaFI3TEpKSlJydEFsbWUvNm9RbkVubi84WEEzR1RyVE40?=
 =?utf-8?B?T1JtQy9BVkdpTE5MNWx1dElpb2ZFK1plV3d1dUtQUWsyYmVacUZqRTZxZTI4?=
 =?utf-8?B?Z1kvT0tmMWRHWWZ2R1UzVHltNVNlL1cvR2Q4RVJZQ2dWanBVQ3B1SWlQaDIv?=
 =?utf-8?B?N0xiNzV4R0R2L1YvVjc0QlAzSXBFak5EaHAyeFY5WDRGQkZjWW1YUE9mOXFk?=
 =?utf-8?B?NnhSWHhWdWh3OHM0dmloR1NPQXFmclkxRnRaSFAwamVPeXZiYTJ3cm8wc2Rs?=
 =?utf-8?B?RWVtYkpFL2ZMOEF2TmphWURvM3dYNkYzQ3FqUGN3b2NGWHNSeklGNnhTK2VZ?=
 =?utf-8?B?R2pVcnF4emlQRmhVd2l1b2ZoRTBES2tJQ1hKQ1Jsb2VCeDdxbjN4OG1uSnpr?=
 =?utf-8?B?cWtubktXL1V1aU9WYjVqMXl4cndoUzd3Y1ZpUWRUb0wxL2ZKaDl2R2VyTmhl?=
 =?utf-8?B?b2t2Q3loczIxVGVtZUw4ODJ3QkMybUR5WFAvZ25TblpMbUltR2NOekJxdVVx?=
 =?utf-8?B?ZzdyR0RmT21EZldQRUI2SmhLOHFsTWdGVHFUcmVvNGJNMVBMR0NaMVNWbG9l?=
 =?utf-8?B?ZEl5MTVYb1dIdlNtbldNR0VaVzVEek4wT3RhQjZrakJKWm1sRWdOUnNQb1JQ?=
 =?utf-8?B?WFJ6cDY4TUU5N3pBWUp0WlZxK29vM0tlYTJOMXNPb3pYcHZwSEZ4M2F3Q3k2?=
 =?utf-8?B?SGl4dEkrb1lmQTFtMWNpeGZTVnA5R1lHQ3NkMk42WmdVWUQxTDBkMHVrQlc0?=
 =?utf-8?B?anZGTmtRSHlFMFdKdTVaaHBiS1NldWpwVVJGRUdPSUxBV1lEbVFsN29JNkpq?=
 =?utf-8?B?M3pzVmJZOFU1S3c4VGxHb1crYmhkWlVBY1NmbEdLcWFmem04ZWNudmlYRVBI?=
 =?utf-8?B?Y3lydGE2dGIwYTRwMkI3QlJrSWhhakxiOEV6MVVvZ3IwRDA0ZCtPUEdIMVM2?=
 =?utf-8?B?YnJFTUYrdFF1ZEZIZUFSeWc0eUY3NDQwdXROVUdMNUo0TWpEK3BYYUJic1Bu?=
 =?utf-8?B?aE16aENQOTFNTWZuTEFiYUN2NTZWc0tzbm1mWWhKcENZRjByemtRU1Y4Rmpp?=
 =?utf-8?B?S1VhNVpwdDNPZEdVUys3YU9BSm9yWWdERkVvdHpMd2dseXV6WGYrYnE3Z0Mw?=
 =?utf-8?B?Um9USnMwamkrM0FldzhYcE1tZlM3N2dSWWF2R1VHNjduYzR6TWcvQm9WZ28y?=
 =?utf-8?B?MlluM1hjaE1UTys4TXg3dFZVbVlLQXN6eDVGZk9USUdvM21UNUtoMXdmVzdt?=
 =?utf-8?B?djhzNUViWGxEcjRYREIraXlqaW05L25KcEdlZHlLTkdMN0NTMVV4cUdmNGRv?=
 =?utf-8?B?bWNOc24vZFNYUXkydTF2MHBaNHB1azh3K2Jwd01NbzNUeUsva0xuM0xsZmlU?=
 =?utf-8?B?ZTZkQTM3OHE0VmFvdE1IVHI1OWRSdzdRV080VWNCd29TVGwyYlYwNGprUGs1?=
 =?utf-8?B?SjRZRHI5T2VrMGRtM09MWXBRUFc0MjZzZWRZYktJdGluRmRtL3ZJc3pCaTQ1?=
 =?utf-8?Q?QAE3Uxyh2Y6n7TBq5Bsaw2LeADsJ3Rc0pULoUcd?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d33e01e7-18a6-4364-fa71-08d9261ca2af
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2021 23:17:48.2098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3VGqe2JFOCffkFbr8J1ZHbTQjiI7dIHw2nZ1eyS/J53RdKLyubyPTxY9bwL+24aA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5336
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 02, 2021 at 08:40:51AM -0700, Dave Jiang wrote:
> 
> On 5/23/2021 4:22 PM, Jason Gunthorpe wrote:
> > On Fri, May 21, 2021 at 05:19:05PM -0700, Dave Jiang wrote:
> > > Introducing mdev types “1dwq-v1” type. This mdev type allows
> > > allocation of a single dedicated wq from available dedicated wqs. After
> > > a workqueue (wq) is enabled, the user will generate an uuid. On mdev
> > > creation, the mdev driver code will find a dwq depending on the mdev
> > > type. When the create operation is successful, the user generated uuid
> > > can be passed to qemu. When the guest boots up, it should discover a
> > > DSA device when doing PCI discovery.
> > > 
> > > For example of “1dwq-v1” type:
> > > 1. Enable wq with “mdev” wq type
> > > 2. A user generated uuid.
> > > 3. The uuid is written to the mdev class sysfs path:
> > > echo $UUID > /sys/class/mdev_bus/0000\:00\:0a.0/mdev_supported_types/idxd-1dwq-v1/create
> > > 4. Pass the following parameter to qemu:
> > > "-device vfio-pci,sysfsdev=/sys/bus/pci/devices/0000:00:0a.0/$UUID"
> > So the idxd core driver knows to create a "vfio" wq with its own much
> > machinery but you still want to involve the horrible mdev guid stuff?
> > 
> > Why??
> 
> Are you referring to calling mdev_device_create() directly in the mdev
> idxd_driver probe? 

No, just call vfio_register_group_dev and forget about mdev.

> I think this would work with our dedicated wq where a single mdev
> can be assigned to a wq.

Ok, sounds great

> However, later on when we need to support shared wq where we can
> create multiple mdev per wq, we'll need an entry point to do so. In
> the name of making things consistent from user perspective, going
> through sysfs seems the way to do it.

Why not use your already very complicated idxd sysfs to do this?

Jason
