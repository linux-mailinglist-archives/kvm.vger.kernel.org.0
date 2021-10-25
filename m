Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57C384395CA
	for <lists+kvm@lfdr.de>; Mon, 25 Oct 2021 14:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhJYMQg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 Oct 2021 08:16:36 -0400
Received: from mail-bn8nam08on2067.outbound.protection.outlook.com ([40.107.100.67]:46011
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232975AbhJYMQg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 Oct 2021 08:16:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKkbIn3GWF3cXNqRYAyoKncVcdN7j2s8lIFUqNPXNEwGHDA4h8TQNfE66yJHZNZAj9TMsTVsqpGrjFtKpz5akCXwpu3jf+T4M0//xQjknJE3u6uTg+VlWjmLePSCdxeVV0+2iXk1UGPpqUGob07CMftSV1nYbUzjLHB4KC58+iPhmdTxLochNGI9pUZqbr13VFjaTQirOY1N4xG/5JEC6k3WZ/lXTl8T046mABcU16Rn6TEcDSC9130ZAWxW4OtQ257C2d6w12QaMVV0v/tkpUjjmP/2yZ7BAIqMbC+O+tVqdJCzqdvSSg8uD9X22P2jEuXoYXzJswi3sXS8xCLj1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7FC77gi2tXEYa3Z7GYpSgPXbayFszcC6nEjwT7Klf6Q=;
 b=JYoe8aXOSc0bRkYAtVIrxI6DKj4ZQYyoQ+5v+r1HtRZn9VF99zX0xsddo/u3+EXqch1TO2Kov8usasno+qmKwiB+q9Wss/8qipX8qg4li+Oe7Lk4efO5woFjS9vhNTrAOhQCYDjQ4HNn88d0eZqMC7s+1s9Tz636Dhev3MxUrpK9mDTeJxGCGIpF86MddojbSd5Pci6/8x3Wtg1V2o8YpkqW4TTUTnKnmTml2PgihtHhsRLCiYUOSTEywXFHuXqGFlEMFx3Uy338HGzx/ox09kezcCewv3+9nK3QjtgPFl10+WZDp87YfbtJ+arPy5hHiGgYz1B6/DG83r8CamhiPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7FC77gi2tXEYa3Z7GYpSgPXbayFszcC6nEjwT7Klf6Q=;
 b=Kd7jOwP+58QSDCdr7znjjRjlrmhukNgMNG9R8l6wjFeCLXOZ/QQTdUXheAAuVP9o4E4v4snyk1PR1X/6Xr01oA1UzuTMkEnxJzIomTpC/THkwJ/PaMkQnPlNohbXIrBbbPs2hsr6JrFlLk52yi1z2DBloqinFHN8cKcAz5RBTByxM7VAEfcyh9k4Nm9YAnHuR53dbWZ/OsEaWjh3fYaoNYP6oEBfKuqE6aR24JE6NO+4jJsBc/uzyZ0IeinmWbAxiNkxrYdHI/6hXHGVrZRKxexcrpEn+JtE/5/XrZknqPeqShLok+7mqAeAp4HG4GDk/wCA6gEflB2XVcd8nKKasg==
Authentication-Results: gibson.dropbear.id.au; dkim=none (message not signed)
 header.d=none;gibson.dropbear.id.au; dmarc=none action=none
 header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5255.namprd12.prod.outlook.com (2603:10b6:208:315::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Mon, 25 Oct
 2021 12:14:11 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 12:14:11 +0000
Date:   Mon, 25 Oct 2021 09:14:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
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
        "nicolinc@nvidia.com" <nicolinc@nvidia.com>
Subject: Re: [RFC 13/20] iommu: Extend iommu_at[de]tach_device() for multiple
 devices group
Message-ID: <20211025121410.GQ2744544@nvidia.com>
References: <20210919063848.1476776-1-yi.l.liu@intel.com>
 <20210919063848.1476776-14-yi.l.liu@intel.com>
 <YWe+88sfCbxgMYPN@yekko>
 <BN9PR11MB54337A8E65C789D038D875C68CB89@BN9PR11MB5433.namprd11.prod.outlook.com>
 <YWzwmAQDB9Qwu2uQ@yekko>
 <20211018163238.GO2744544@nvidia.com>
 <YXY9UIKDlQpNDGax@yekko>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXY9UIKDlQpNDGax@yekko>
X-ClientProxiedBy: BLAPR03CA0085.namprd03.prod.outlook.com
 (2603:10b6:208:329::30) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0085.namprd03.prod.outlook.com (2603:10b6:208:329::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Mon, 25 Oct 2021 12:14:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1meyri-001RN4-5U; Mon, 25 Oct 2021 09:14:10 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ad5ea8cf-4524-4acc-d38f-08d997b0f3cc
X-MS-TrafficTypeDiagnostic: BL1PR12MB5255:
X-Microsoft-Antispam-PRVS: <BL1PR12MB52557108727597B0DC6CBF62C2839@BL1PR12MB5255.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhKtA1ltV9UJrTGTtIcfOfXvIPrv4xYqClUGx9h4eDUmZcwtwT8aMP7VTUgjFEHPpS6lCb4MXGaI4jbECjB1rEtdrBFwBM2tPukPtYPn8RC/kPSO0URHu2qsc2Lsi+lEFTh+MHfhqtjfJ47EMuj94eynzGPFtZAw0tIPwKAkaN3UPUPOm+Pp+ByCWQ0hH7Vi+WukKE1qMFR7DMgIMPkhUbJRz3mocsMTg0mJQW7HAwmES0Ot6sVZD8sQA0FmlLYST/IMN+Ew8lIjEGHrwFwBChd4LdZE34lHpAoOyY7O3Ms3TSC3/uY9OQGNX1oezROS8K3FkzB5OS/VeSN4P+F8nmh/mk/FqyGPqgkvTph8gobmPIS1zKkNM1OOQ2girzG+x4iLfh0TY/Vxuu57LtR7T7R0o9jbQiLsEx3Bf/woM/u14mHba6QRRH6Q0EiIReDVfmBp+l1qF3ILlxPyFz8jxOzK+7AvFVTBLAga6lJgsiCRuMp+eJIAToxPWi0mkSwzoBeNFmWFBmqobf8Z/PMYMNHpbpwdbfBvEJgvducQcdvfbwaCa/9FGCZUI/oerFnItDbMykBLzKPFnSsebXoTxCyqSyRXpRSaTedvlax4SuLWvHd462v4YaZgWTzw+k729Z55OjvVeoyWSwmX9AEDFA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(66556008)(2906002)(66476007)(54906003)(26005)(186003)(4326008)(1076003)(33656002)(86362001)(6916009)(107886003)(8936002)(7416002)(8676002)(316002)(83380400001)(5660300002)(36756003)(426003)(9786002)(508600001)(38100700002)(2616005)(9746002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?149/SIIFdsjWNWxXnTfwTcZ22UIvzaZY/jgf3sATLkZ/eaCvkKsJ9+CvYHf/?=
 =?us-ascii?Q?mGucGt3V2JeeqN4RiJC3bWjcrUgts2b9Y05pTQe+/hvakVk8uuFSUI1Iqv5v?=
 =?us-ascii?Q?MwocmqHMoYR6tuH6PeehXBKP09+O6mtoKdE7ewiP+VCgmBdWOQIYwDW85O9R?=
 =?us-ascii?Q?igxuRbq07aS0cJk1DOi4HEJYQeqfBiWUovEdzKC4iZo8cycfXV31hHF1LEmu?=
 =?us-ascii?Q?zYp6JUP0bI/Zv/YvZy8xaapLuUx3ps8EBF7eQUV21G7kfEvB13GqQF7ewGq+?=
 =?us-ascii?Q?Sb5Wim09eex2IMIl77cX7NaUISFi7Jr5O7V5QbcSGHFMq7b5IAOM9I7KZkHC?=
 =?us-ascii?Q?JVsjnx9pn6e6hoWF+1l12U4fuukYpAeFZDEEDZyDvtwtxXDB5UmZQ1gQp8bp?=
 =?us-ascii?Q?NVr+6cfwwXtG4UJ9+ovTvZO/07x8Gziuwa/9bQvpwbJWoVw3a23Nt16eG65E?=
 =?us-ascii?Q?jiczz2u5Jqm+SrJa73P5lapN2hyNje5i0WQPuJc+LJXPicJTgfCJr25WhpMD?=
 =?us-ascii?Q?pQVwlqI3qM3xhcWK70uZSOXXd2a+sbqvny3odDqOCOuhc3w448UmOkIzO06G?=
 =?us-ascii?Q?TxyVg7q29vz820dF5zx5o+09924pqlXXTP37ljUbY0ft6B/FTs7s25/ZNMje?=
 =?us-ascii?Q?F18b2Np4tOVQU5bZKxVwW0hZRsVoebKl2GMhByVVCV59CKIiWaRO0VgBVWBH?=
 =?us-ascii?Q?4baNfdnyPHck86WOOc8JRIwdRCc4aSVaNnx13VIJLyRpTKA/qoh4byEXifeZ?=
 =?us-ascii?Q?yL8Uysdyx0su60nEgY5Cv/wQwXQbwpBZSsZkQDdQC1ANuKU9h1fFrm2oOzvp?=
 =?us-ascii?Q?YW7x14NKECOsobnK8yDnUSVdEHVCp/Bvryyq/kmyZm0RSlO08+PUU98uVLzv?=
 =?us-ascii?Q?rb8J1wg2fcmMid+P2KpdnO2aqN5up26imnkMt1CATZ3X2X/GhuNoB+BYmzir?=
 =?us-ascii?Q?G/tZCzZyv+M81s8XbAVAnqns8zyKItouOpUG66XywOQoUnMbLv3bBpIKgGan?=
 =?us-ascii?Q?UQ5DZwBwKjCM78VI/f6/ORFlRahpgkjNULBM7GRu8Bc8BPyCmY2oG8QHhpYd?=
 =?us-ascii?Q?7B4AEyuKRMN8DQbBC7mku+ugohmwo9cwA5zCG5GfSWzJj3DlgW2wg/zwBkSq?=
 =?us-ascii?Q?ajv5/ki4xO11Fken+uYmlxH4FxtFJnCT7qTc0sejLse9PTixUdho3BMvXpNu?=
 =?us-ascii?Q?VuDsYLAKz1ML7Hi7Oui/TG2xfJHpdhvAa0tK93VwmoHFkykx5xP0VJoeovcY?=
 =?us-ascii?Q?3bu9tMsSsEcoYBYWV0fAeJ8A5hse1ra7ZHk6Ry1wP+GPg8TcCGcfR7BfcQPX?=
 =?us-ascii?Q?rONF7jM2ozGhsw3qMB/J86bEzJfRGGlKOyXm3db4XXWUvG9mkgjLXoT6KXXz?=
 =?us-ascii?Q?3ly4VbSnw3B0koXg3+ZdbXgRro/3b26JHkiSfoWgGoDD8H0E0m9zMZejahYX?=
 =?us-ascii?Q?50o7VfWEDaSOsmrvWT2bcecVQBBRQ5X56s55FM8kai2hpIuy6r5Syxwo5j6J?=
 =?us-ascii?Q?rC33ZMhRRomVXPhti/mKSE7/VjSyxYorXTLLSrKRTpLnjvSCj6Gc51SPfmZB?=
 =?us-ascii?Q?RS2rzG6UW1G7GsKrgE4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ad5ea8cf-4524-4acc-d38f-08d997b0f3cc
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 12:14:11.4371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /MLFMp9Eg5KPvXk5z3gTW3INznkaqzGVc2r4HCXFXp1rEQ92XmPryXSrBNObEdXB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5255
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 25, 2021 at 04:14:56PM +1100, David Gibson wrote:
> On Mon, Oct 18, 2021 at 01:32:38PM -0300, Jason Gunthorpe wrote:
> > On Mon, Oct 18, 2021 at 02:57:12PM +1100, David Gibson wrote:
> > 
> > > The first user might read this.  Subsequent users are likely to just
> > > copy paste examples from earlier things without fully understanding
> > > them.  In general documenting restrictions somewhere is never as
> > > effective as making those restrictions part of the interface signature
> > > itself.
> > 
> > I'd think this argument would hold more water if you could point to
> > someplace in existing userspace that cares about the VFIO grouping.
> 
> My whole point here is that the proposed semantics mean that we have
> weird side effects even if the app doesn't think it cares about
> groups.
> 
> e.g. App's input is a bunch of PCI addresses for NICs.  It attaches
> each one to a separate IOAS and bridges packets between them all.  As
> far as the app is concerned, it doesn't care about groups, as you say.
> 
> Except that it breaks if any two of the devices are in the same group.
> Worse, it has a completely horrible failure mode: no syscall returns

Huh? If an app requests an IOAS attach that is not possible then the
attachment IOCTL will fail.

The kernel must track groups and know that group A is on IOAS A and
any further attach of a group A device must specify IOAS A or receive
a failure.

The kernel should never blindly acknowledge a failed attachment.

Jason
