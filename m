Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94492338F7C
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 15:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231808AbhCLOJs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 09:09:48 -0500
Received: from mail-bn8nam11on2072.outbound.protection.outlook.com ([40.107.236.72]:36449
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229908AbhCLOJQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 09:09:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSUt05gk7bKvLgw49B/M+/LjVUew2Oj+II8tILO/h3ve+qw4ZIGQPgCqmS26oUb4aVlYI97L9qI6Uc1ueh6X44zmbkXULRTe3N2JGaNlK+wdTAZfwymEfiObShIjb4J1Gvd+4emdE8vXB4y0su8uOzHh7k6Jh6QCV2IpMRnXcQsv2qrhPNogald06E+qqg5mvosz+sqBwyz8V5oIbe95vp/Y87evrU5m4T9X7oCSRHQuXpQvmWv4tdutpxApGqrCuQOst4V+MhFY2iub9bWdQJT4UJq8U1dxl3vPszv9x0yYTpK7yLzUD4tuJX2lSIL9GwaCAtLVwuLCU5yz5g+pGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XCJ9/FrayjQZkvPAuBAmD3tANQ+80IDghi7iP40s34=;
 b=S/UAB//S2teqw914KZ2Fuv+fEXMBR94CNzlZcz/U4VvqZ+vD2WsLzQlgs9xnyEOU1Z+Cub5lsiImdyV+ysYUnJDoJ1gkdpojbUI3tyy6Ter1i1O3i1KRrPs3DINgps0JIQgrhUW8/U6acTr8OjZrEgK0WKfzGv2YnG8ipmKoIad3K3THysN6/mId9t+HkMJrNB1WcsPuUR0YhyciAzn6AQXG7dZWlzSKPXBfdsdvjXGUfU8lHCmX5upBCqYfivGEzopS8jy7q9BFFiaB8SA8jgIyM0pMaTA6VqW7qX0LJy+QGD122OlPzypEd2+3wNEPnRxmeAaHhMmFDaUkdFYfcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6XCJ9/FrayjQZkvPAuBAmD3tANQ+80IDghi7iP40s34=;
 b=qxwPjozw0q/sKkZXpJjrCWknBkbRqQhLs1pJWFOnWCqs5SUFZNUfB9z5HIuJIF4JCvEHjN2opWMqHmrGVMMkB/IKRSfQhRGqxwi0O5S4YnZXNr0iUdrjZPn7BF1dd7kieSJgSoulJ4CzIaBzXWtSa4XQcGRxmMOQHE7LzyLXp/AhmVVdqvvHcpmsC39eNJgSBUsQqHC8zz2WTcfbZ7OQYswzTYa1wbP8z6Kl+2l/AXCe+dnezJqjv+udss7m941SQTAC/onVRktIAc05170XL7eDUIEI8iXXYCipl6RWE+lFvzbY6k8YRoVE6wlVvvtBK+X3Ym6P3e1GLjr2MAZ+UA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB4513.namprd12.prod.outlook.com (2603:10b6:5:2ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 14:09:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3933.032; Fri, 12 Mar 2021
 14:09:14 +0000
Date:   Fri, 12 Mar 2021 10:09:12 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Daniel Vetter <daniel@ffwll.ch>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leonro@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Tarun Gupta <targupta@nvidia.com>
Subject: Re: [PATCH 09/10] vfio/pci: Replace uses of vfio_device_data() with
 container_of
Message-ID: <20210312140912.GZ2356281@nvidia.com>
References: <0-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <9-v1-7355d38b9344+17481-vfio1_jgg@nvidia.com>
 <BN6PR11MB4068E9DE96B512A71BF327ECC36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN6PR11MB4068E9DE96B512A71BF327ECC36F9@BN6PR11MB4068.namprd11.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0035.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::48) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0035.namprd15.prod.outlook.com (2603:10b6:208:1b4::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Fri, 12 Mar 2021 14:09:14 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lKiTY-00Bv1J-UW; Fri, 12 Mar 2021 10:09:12 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7a9eeed-12f4-4722-7054-08d8e5606a95
X-MS-TrafficTypeDiagnostic: DM6PR12MB4513:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB4513AE4D1D85E4DDA1E2B7A3C26F9@DM6PR12MB4513.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i1pmIP8MlELZizVsJGwN0Cmm5d6sIzIQm6JNSWRIIkCyY4ooUK03i2RFL4jXFzaU2A5hhBdRcTIBzWwHRpS16Y/MJyGfnViwl6br2VKPrdobnSAVCHCrBz5Lna0GgDz8tnQK9mvwsdOCWQON0LgVvCtsxgJG17yu3mMDeDQAGef7XdAbUEu4gyvMnyW5ZGefqmtaui4pSTnePXt9MRvFCmloSmq36T2w2twL4ZvVoMR9oAZaFo0l0oFJJHIpPk7SvOTqIB3fWQc3Kv/eSDH9wYzuoq+2wf1oTaW4tO4ycqlGkzxnFva0i5t8wdwn0MpcFrOJjOQfw78OSNz1244UPu2VC2cH5L7yWzYLTRBPeHKEGqaubyo1NMYfKpMmyOFtVBPISO3WTlwN9pd+ulbeNZ3GfovOBu37Zc/95nWsBbavOkM7/EGehKQYC/3A4oyVPyjyYUnZ0xE227tl6BgMUT0+bSm9qoZX5+oYtMq/SQF5PBTkFhkelMIEJuvp26LTUtVuSgOeflzkozFAceYd1IiWZehFYxYoghdXzYnxuVOzLVuHI8mBLDxJzJO12+1p
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(346002)(136003)(396003)(6916009)(66556008)(66476007)(26005)(186003)(66946007)(86362001)(2906002)(426003)(2616005)(478600001)(33656002)(8676002)(4326008)(9746002)(9786002)(54906003)(316002)(36756003)(4744005)(83380400001)(5660300002)(107886003)(1076003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?pVb1i6kMVrkpGcWp07EpV6xg0QhZpCkFQkq25jbc1px6731QmKABfdrPMibH?=
 =?us-ascii?Q?WRXW9YFpkPSqq1elDt0LjUttXr/vTuF5BX9ikY2sGBs0StFf57O8ln/Kn6Xt?=
 =?us-ascii?Q?FhBSutDB9psljoGsoTne5eUVrGC1SazPOywJOWyA4SdzTv2lAXSI1ffFX/cO?=
 =?us-ascii?Q?knt6iJvC8V84dlLlvQXxwTnKGz+WhxA2RBMrr3WVRTQc/IdD7V3ptV7n/iqo?=
 =?us-ascii?Q?2Ri3BokxRhGUkZOWz3VAf1uY4tMoaMdtha79eDOZGtT3TRW7GXVdcyr72LDK?=
 =?us-ascii?Q?MDdx54yGeaBu1nRFKJgSO1SfoJv5eeL3goE5qdurQTcz24A/+yWjNCbqsqlQ?=
 =?us-ascii?Q?mr6riEzvavFAuCbGBhfwkh+coOUPaT0PD1KNLkwqCjhv67xfkueVd5rCB/FS?=
 =?us-ascii?Q?5S1N44fjjwDLVMWXrwcupvehuzoWx/aCRLbhP0iSfDytAUeffHit/K+eNPTM?=
 =?us-ascii?Q?U1vNQ3H83fVvYWHjBu8fgx3gel0DFiXmlayRj5oj/VRK2M1+YLBSBcmFbmni?=
 =?us-ascii?Q?D3BYtM2bC6PKlEF8SM1zkjiaqEwZLZkDolYJrzRgWSJ/F2kF5DSSEqf4If1g?=
 =?us-ascii?Q?Sew8G971nwrBZw8kzHZQjV4oSBqlSTvotHFKgnoLnDqmICKJkmUsEWU5att5?=
 =?us-ascii?Q?9rvcObc6XCN+AuuNYtNZr9XO8sCKRTp9d0Ltp6Ab7CgZXHWOaY+c7DgkOqBX?=
 =?us-ascii?Q?od4O/Fz8vpo9z1Qkg5IvrXat3snJHhoSUZyIcs/mNfI382NHRaDVgjMh3Irg?=
 =?us-ascii?Q?l3YvGQ1mdIaTRi082xNeHChzNMFXVPFpSpxxvoDaqVPgNMKpZVM+Qw0B7n87?=
 =?us-ascii?Q?vozu/TvbqMq4SPwOT6lR6G4abKA2pJeJkP5xJZyPmS8/Pd2+BGwY5WDAJI8/?=
 =?us-ascii?Q?JAG1HT7LpzE4etoxpRZlRtX7f32iCohGvYHYUTU86NDtGsSA+CB7PJ/ErUyD?=
 =?us-ascii?Q?tQfDoExsrVQSGkqulHxwMrSD5lUYZx/igeeWU+MRjew8hy9zarva1zrYCww6?=
 =?us-ascii?Q?zfUQGgq2ijqXIt5I/ctWSWs5uQHjHQeIJ+uddYdF5EfySnHNADRaHSrrfeTH?=
 =?us-ascii?Q?G5cZqbsbo3wcvsCUjyVQHZXPrbSsgviWePTrjVaFiDggiU5RfhmjCAnW+F/S?=
 =?us-ascii?Q?ZForcHVp3WJ6RgpnFlUt3dmmEnxed8euYKX+Yqe7yj6zht4KbXvw1G9qflzr?=
 =?us-ascii?Q?lJuuyjpKqAYodwGgNU5HMMfC9OeC1tJyOoNXJhTNXb7511l7IxXv5m1wUTws?=
 =?us-ascii?Q?LSsuBPRWPbSktK0TzKvGKpsmOth2SmFTRCgFlSJf/Svu+CTH6kOvtEGcNBQO?=
 =?us-ascii?Q?Ko9T8l8FTyI0UCXVRjiZhY4LeSAqAD1RZK1e/NJZ+qxtfA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7a9eeed-12f4-4722-7054-08d8e5606a95
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2021 14:09:14.2253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YL6EqwqUn99oxTezllSU27WHbF1EaFOfIpVFFdH8zeBUo6KK+elBtKlSo37L7Ol+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4513
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 12, 2021 at 01:42:44PM +0000, Liu, Yi L wrote:
> Hi Jason,
> 
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Wednesday, March 10, 2021 5:39 AM
> > 
> > This tidies a few confused places that think they can have a refcount on
> > the vfio_device but the device_data could be NULL, that isn't possible by
> > design.
> 
> I think the purpose of this patch is to use container_of in vfio_pci driver
> since patch 0008 has already let the callbacks of vfio_device_ops to pass in
> struct vfio_device, which can be used to get the vfio_pci_device easily with
> container_of. Just not quite get relationship between the above commit message.
> and the actual purpose. But I'm not a native speaker, so this is not a strong
> comment. Just FYI.

Patch 8,9,10 are a sequence with the goal to remove everything related
to vfio_device_data()

Patch 8 removes the device_data connected to the ops

Patch 9 removes the remaining vfio_device_data calls.

Patch 10 removes device_data completely

Jason
