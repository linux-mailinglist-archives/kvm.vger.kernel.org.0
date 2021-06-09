Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A1B3A174C
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 16:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236484AbhFIOee (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 10:34:34 -0400
Received: from mail-co1nam11on2044.outbound.protection.outlook.com ([40.107.220.44]:11413
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234873AbhFIOed (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 10:34:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itA5Xx+bEb0JZBbu48zTvXQUmxtAJmv8YeI98shBlkRbUAtEecBUXIi1hzM7xBtCd2qLKutI/VF5jzxd3Sh18oj6AShljQ4MefJEbzuTH9nqiLMNLDJCYBDd2l9L2cnKXS2vR/3eH9BIRb40NLzXbstmMElda1j8U5ckFtXc/0i283sEk0DhB6rYopz4ZBl7WTuk3EEByjP/J+K22gCVybO4o6bZCjw3EEK90Arr+ONpW2DdfqxM8ARZPvP0MW/KCIOhSPiwUptOXlWTSapdIT55GUnGeeEKfpFh/L7of7iWPvR3VOZgrxgOcas2w2d/O1b9DK3HUbMEYBBedBbiTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9ujo6grGhvk6fEeF9OsQXJBilH2WWhZo5ApaxwCM0g=;
 b=NL9OOawuXB1fRrCEe1OdXmwii/T8m5zcUW6nlRjSuJi0dh35iYJ2WXILPS1eZYRzO3q48ZJyZ2iYUim/ZvmOYTEZN42wwFRbT/pF0bWV8SzmSbmMF4MyuKATYCeldp6QxhH9eMq8/kyY2FFxqef/IqsaLYtGHBRZb6Tx2oS4iPp7QjvNOP0tztPM0YX+MkytW7AT/l2wc3dPEbo1YD/EyVX3KBcSv7aTd+FMA3pHLAo8pPaA7DjxFY2LMDQV1NpmASzxfnW4WeVta8TAEaQW9i5XilVXxOIrNhZa7wfJS4wA55azR5lpfM7dLCT5n5/Er0E/pqoV7Eo490V1maTv0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f9ujo6grGhvk6fEeF9OsQXJBilH2WWhZo5ApaxwCM0g=;
 b=R3xMLbz4sju8KtcKqBGIX6Pe+4OGU5Ke/tLzCD6RV6tmiRRJ4lA+T7rHzmYc4AfXPEMqkG+TtefZYxK3bmdF15K8SZuErdQYeMRopx+LfUyzOc8uNas+9uhSTBsdNQ72Ir2O884M8RL6k6sMb7lEIfbxJ6ecP+P6+0Sl8VEdEXjh6T5IZuAqqWdLG1FBUVCMb3PQcdXSu/mq9R1lZmol80wtUAGY5nc4jEbIb+mQ1rKAVOvgNCjxBM4DmCbxr73B8YJRVp8hU0CKpm1TPsbDNjX+ZDnz69MveIBl6eEUzXL+o5vv5hzFrZzlMbAHs5viryZXGXHDXYKVZye/x8AFgA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5078.namprd12.prod.outlook.com (2603:10b6:208:313::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Wed, 9 Jun
 2021 14:32:37 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::3d51:a3b9:8611:684e%7]) with mapi id 15.20.4219.021; Wed, 9 Jun 2021
 14:32:37 +0000
Date:   Wed, 9 Jun 2021 11:32:35 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        "Jiang, Dave" <dave.jiang@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Robin Murphy <robin.murphy@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [RFC] /dev/ioasid uAPI proposal
Message-ID: <20210609143235.GC1002214@nvidia.com>
References: <20210607175926.GJ1002214@nvidia.com>
 <fdb2f38c-da1f-9c12-af44-22df039fcfea@redhat.com>
 <20210608131547.GE1002214@nvidia.com>
 <89d30977-119c-49f3-3bf6-d3f7104e07d8@redhat.com>
 <20210608124700.7b9aa5a6.alex.williamson@redhat.com>
 <MWHPR11MB18861A89FE6620921E7A7CAC8C369@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210609115759.GY1002214@nvidia.com>
 <086ca28f-42e5-a432-8bef-ac47a0a6df45@redhat.com>
 <20210609124742.GB1002214@nvidia.com>
 <8433033c-daf2-c9b7-56f7-e354320dc5b5@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8433033c-daf2-c9b7-56f7-e354320dc5b5@redhat.com>
X-Originating-IP: [47.55.113.94]
X-ClientProxiedBy: MN2PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:208:23a::13) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (47.55.113.94) by MN2PR03CA0008.namprd03.prod.outlook.com (2603:10b6:208:23a::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.20 via Frontend Transport; Wed, 9 Jun 2021 14:32:36 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lqzFz-004eE5-Q0; Wed, 09 Jun 2021 11:32:35 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fcb15f8e-f681-403b-bd43-08d92b536d6e
X-MS-TrafficTypeDiagnostic: BL1PR12MB5078:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL1PR12MB5078BC1D582E055CE49C2B88C2369@BL1PR12MB5078.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XZS3/eMBUqNowgRwWkv+h2ktKcoY7g2toM6beDD+VOqDW0Zi0tOYIVc499E1clYK7tM3ZOc/noWPO+Jh2HQuSHCIk2I8yQQlasWeWCfR6wjytBwbG7BfgqeoPSVW1F9t2sveu596olk4uaWWdNorqA9MFc1JWHfvLMhMihnS1qSCAOTxfr1hwyU2GMIW+IIcWhv5y9d4c9pCdJzxJNgUBiP8xAuotI8TvIbMeysnZN3lCGU4aA+VbzjsZPqiscJLczCcWvMIAHaFhsGR56PbtSD94GXBrJ7lacRLFjkz4spt+wGUIRBLcbJt4UPtGKxRZ7Cgcw9iCOdBM7bkaAtjXiZtUActcPVlxjJ5gyo+1Y4zmTZyjhsHTv1ztInsArK00dA+HmruXvnh8y8j5refM57sUOeQuhng2zaL26RqP2KBdZy+dUf9p9Db0epYbX3LflgsAYNIsT+v/giedPSBqouUYXEm4U5mb3Y7O4iJdG7NcFuZuGI2GYhe5tH+g2qB9+TQABxRt+m+ofuCFBSarenCtAfGbdXf2ugkkC0Z9Cx98fISgmUYLdkOUj0jeuJBT1avn0/9P3sYq8Ye72mx7B9EXMMHrH5HfbdAGC8/3Rw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(366004)(136003)(39860400002)(426003)(33656002)(316002)(86362001)(53546011)(6916009)(2616005)(186003)(54906003)(8676002)(1076003)(478600001)(9786002)(4326008)(9746002)(26005)(83380400001)(38100700002)(5660300002)(66556008)(66476007)(66946007)(8936002)(36756003)(7416002)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DwglDnvoSpRNnPIlTa9DyymHpnFcmBceRtVfh8I8lG3ykHvO6JgrX7EAi3gf?=
 =?us-ascii?Q?guq+VqRIuo8k9klJKvnfmhZVUX9jVqVlUdNWrwLaxq4iVxy8d3x1ijT3ElIe?=
 =?us-ascii?Q?BWPRaz/8Gg7KH/m10090XIMjWyUnhzeTGbWo2BEP64Pn9DHh3Y9k8Ocn+/Mc?=
 =?us-ascii?Q?GbUAQw99Z1mRU3zKWjq7pv0cVmjzJM2aOwUmPp7aJiGyiFlHzRwmRcPoY/L7?=
 =?us-ascii?Q?zsJeazjqFqY5cBY66bfUElokFz3co0/z9ngRXGAf+jYNeSXXxzIBhwTFMctz?=
 =?us-ascii?Q?zJrB5Pg37xFpMELDmTh/96Gcx1orrzSZLVeGXXDqLvqeDTchjPuJDVaCweBp?=
 =?us-ascii?Q?NqeXpiJ30tUwl/mzSPGV3ZxPMlwEYb51sFDgeTAbna82tK2FrxT8FRVTvxuR?=
 =?us-ascii?Q?G95p9taAEneWSmo/ZAN+yNmEnpOYtQQwcnfx3Pslm+M6RD+O5Bwd3W6/MwIk?=
 =?us-ascii?Q?dD/ays62wsDfrqVgc4+lEHaTknqeawqTsDI+ShEZTAPiLbhQJwmKdkVb81AV?=
 =?us-ascii?Q?iJfRICpvVIS3lXZ83MlELAdiqJ/aRfTINNcIfin7pP1bvy7tMc/A96DJb27a?=
 =?us-ascii?Q?1fktD6BgXqrwjqKpux4VPh3jAbCQOVknOK3TH9un4BZknJoZCjmukfua3Ae1?=
 =?us-ascii?Q?kTgwVQK4mpf50dYTHoXeWuYo1DLIqdlfkM3b1Vckut3+empKIAyjYjtCXtH4?=
 =?us-ascii?Q?aFnzZJ+M1grti7ZZchVD/gN1eTr7y/C3ejeI3UHQEsC4CcjVZgZUWUJvtdN1?=
 =?us-ascii?Q?ImVpjCfF423xoRnd0JHXGrovsK5D/brbjMZP4fiFgqm4ELlIPtl9YWTx1+MK?=
 =?us-ascii?Q?3sVKasFqkh7x3tzhR2PrQxa9VXvGyqopniILsuQDrpgIGFlXbEy7AhFiMSFt?=
 =?us-ascii?Q?8zsiPu8voGai3tiLXWM+gXmk+jUn+ULJlH3wEV6MhU8Z4R9oKmKVqrt5VagK?=
 =?us-ascii?Q?a1JNRYWKy3ZaAdV9Y8VVKLdOmPcLY6Jx1lVaeCidZif8QNQ/oufG+cJkHpoG?=
 =?us-ascii?Q?cqpJLxZIZc5W2ItVYB0okmNmWxKxyGo8zLaMJwz01fUmMEplOuU+IiqcJ33m?=
 =?us-ascii?Q?NktUFKe8pzEijrXnC0jQwXMCWr3NcUJq4Lb6VE7gHNJwuggRg6Ywu70XipMp?=
 =?us-ascii?Q?bGtmRsqMmm2iGkQ9zc3AsF9uFpGGFyXfhxW3zwyFG2uBZr6DhdSHL9L54PFP?=
 =?us-ascii?Q?wJ3U+AtBJgnsexTMCTCQiEp3WeNgP3h0b5un2ZEy5W4Sq6haGXfIGoUS7ASm?=
 =?us-ascii?Q?+Uv2hYjdVahNI2rsqvJTxn2C6G+KF2x2f51wgymhcCBdXaC0REYehhCPVvQt?=
 =?us-ascii?Q?5CnLgEabr0FQrv0gnkcx68SR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb15f8e-f681-403b-bd43-08d92b536d6e
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2021 14:32:36.9622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WRL+8dncT3qnj+45JYub6/A5bQrSNm/ywsyTM47UYVAVnFuNSSLNQx27P/SxCruE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 09, 2021 at 03:24:11PM +0200, Paolo Bonzini wrote:
> On 09/06/21 14:47, Jason Gunthorpe wrote:
> > On Wed, Jun 09, 2021 at 02:46:05PM +0200, Paolo Bonzini wrote:
> > > On 09/06/21 13:57, Jason Gunthorpe wrote:
> > > > On Wed, Jun 09, 2021 at 02:49:32AM +0000, Tian, Kevin wrote:
> > > > 
> > > > > Last unclosed open. Jason, you dislike symbol_get in this contract per
> > > > > earlier comment. As Alex explained, looks it's more about module
> > > > > dependency which is orthogonal to how this contract is designed. What
> > > > > is your opinion now?
> > > > 
> > > > Generally when you see symbol_get like this it suggests something is
> > > > wrong in the layering..
> > > > 
> > > > Why shouldn't kvm have a normal module dependency on drivers/iommu?
> > > 
> > > It allows KVM to load even if there's an "install /bin/false" for vfio
> > > (typically used together with the blacklist directive) in modprobe.conf.
> > > This rationale should apply to iommu as well.
> > 
> > I can vaugely understand this rational for vfio, but not at all for
> > the platform's iommu driver, sorry.
> 
> Sorry, should apply to ioasid, not iommu (assuming that /dev/ioasid support
> would be modular).

/dev/ioasid and drivers/iommu are tightly coupled things, I we can put
a key symbol or two in a place where it will not be a problem to
depend on.

Jason
