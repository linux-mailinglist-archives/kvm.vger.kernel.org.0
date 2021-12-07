Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1027E46BFEB
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 16:51:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239120AbhLGPzT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 10:55:19 -0500
Received: from mail-mw2nam10on2083.outbound.protection.outlook.com ([40.107.94.83]:6002
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229630AbhLGPzS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 10:55:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIZd4kD4zmfpyO4sSrd9PPLR6FYz2XF78sfonhZxGJWt6uu3QC8NLq+DzOdqGs+0LRBA96YcMC/rlqnaFafGq3VO+k2Yq2LRFMs2B3FdxVR/R18CWpcPTSfZrrUFSJTjpMXr6x4gTvyAeQtozADXpIhial99KmlFqeu0AsPScHz9518SP7H52xRFBZQgwPnjfUlOxGzlEvlFAt7TleVRJkDdM6zvWTwwH5TtQWCHkJQBVg8LuxexLVLqaWVq7xhg8b9t/THhW094CbkixPESM+GyTDeJjUyBnTRYqlUPgAjz0KPD09VdxpQQD29TsvkSy8MIYwQ6Ak1SKqP+Ld8uYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0oDvTryPCLkHR38yrTuA7g7nhVCyUb8KhEZxr40r/JI=;
 b=T0MjgvS0TxLlKhsF3VwqwlXmSLaroFGhHZVwtywZ1HUqtu9aqJtuVyiStx9q+34kw6DW8KK3/6AgZ4YmliyRF48BFYJIqsMCUXvHkb+QlU9n1jo/yydRxsZ7a2zx7XW/tCvpr/k4shGlsaDzY6kAgzLy9C9J0rqjyIpB5ftb9l366gBevGRZZNdWqtkKXSGwJuAcnxj52MP/7bZSkd7RaKlXHnzPcqdegNLndcVvJSGS29KZ/s5NT5/ipIYXSRJfCkK1Vh1tbCGVv+LtrswrWiCzEvELwOm+KVhFZnE5M2V9+1nSrhZhq94Kd2p5PnDNzxO6U79Yq8+P5U6jUExLLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0oDvTryPCLkHR38yrTuA7g7nhVCyUb8KhEZxr40r/JI=;
 b=XFNmVqUvy722aMr8OBLeu/g46s02ochu5TyKhfrjI3P7A2sSSpbxsVFzKCNjAzlSPuA1YmqER38MgfcYLGJtT2sxj6ju+9EXnsPtmtqziR44SfR/TR3QYDR9R9MQfgmwIuvAHzxUEXlNJsVtm+J73EvESH4BTvlAQ2cQoHXhP/KUrK/fsHcOzDGBjo5ME47rqsLb3hT+mvsy6x1WO68bxCyc7Pt7M8HSJOIdXXKn+kpI9xgdAb3E8xaz6VUxewZEKsWJ4Wwq0huPHa4x7fthPeA5/k80WeWrFotlasU5EDqFq3x6KkvZD0hqb1HW+PzX8xN1z6bJoZoz5xqcn2H01g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5078.namprd12.prod.outlook.com (2603:10b6:208:313::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20; Tue, 7 Dec
 2021 15:51:47 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::d8be:e4e4:ce53:6d11%5]) with mapi id 15.20.4755.022; Tue, 7 Dec 2021
 15:51:46 +0000
Date:   Tue, 7 Dec 2021 11:51:45 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        kvm@vger.kernel.org, Kirti Wankhede <kwankhede@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>
Subject: Re: [PATCH RFC v2] vfio: Documentation for the migration region
Message-ID: <20211207155145.GD6385@nvidia.com>
References: <20211130153541.131c9729.alex.williamson@redhat.com>
 <20211201031407.GG4670@nvidia.com>
 <20211201130314.69ed679c@omen>
 <20211201232502.GO4670@nvidia.com>
 <20211203110619.1835e584.alex.williamson@redhat.com>
 <87zgpdu3ez.fsf@redhat.com>
 <20211206173422.GK4670@nvidia.com>
 <87tufltxp0.fsf@redhat.com>
 <20211206191933.GM4670@nvidia.com>
 <87o85su0kv.fsf@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87o85su0kv.fsf@redhat.com>
X-ClientProxiedBy: BLAPR03CA0012.namprd03.prod.outlook.com
 (2603:10b6:208:32b::17) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BLAPR03CA0012.namprd03.prod.outlook.com (2603:10b6:208:32b::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21 via Frontend Transport; Tue, 7 Dec 2021 15:51:46 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1muckr-0004Rp-AA; Tue, 07 Dec 2021 11:51:45 -0400
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: be3613dd-d3b6-4612-959a-08d9b9997969
X-MS-TrafficTypeDiagnostic: BL1PR12MB5078:EE_
X-Microsoft-Antispam-PRVS: <BL1PR12MB50780497D26D0E5CFA941FC6C26E9@BL1PR12MB5078.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tXAH70kpfb90YRhylUgkiDhG+2Kz9M7nh+yzhUcNkf/JDY5Bm5/xiS9kgX5oleI04pWASkW/5giBFhAppzzJX1PjWBFalIxjzyTRvD70Ury+xbVbEl/Ngx5dK0MCA7WwzL2UkobhJNPNDnX7gmxh9YofWrA1cqUq9qQnvQ/FFH+ym4mopLeaCh1un2V9bC+05Utk5/P+/oept874Zgdz+ggRZ8CMnHrobITPg+VVbMq+VTsRNWNfZtfQPsZNGxpzECaB98GXP20RUmJPmWLWS+QKZnYy7keyMPYsxzTDsh1aRlR3QeKhlHVpIWcuH5F+SDqIuB8I2N+GPX1sTMW3pffEjLKtdc726o1ictO54cyDZE5Xqyrx8Lx6AHMGClWSg8OPtWwE4ZJlAvXB09A92hgV1Ny326MRT4R3SEqz0rcWt7B4b8PRWmBjU4KDqCvI8g4mLFrRcTgICm2LJd6+VZ9iuNB0BWCUpXx8Qb0AfeW9gvFhPZ4+ZzxmDiQzbjP2VTCB+Bl52alD2MZYTO4UZBd+N4rMnyLX9WuZAKdusRiUSIxgaONGD2xrYA8mfuhcuFGyWxxVEL9fmyOxrigezMAGtmg32c2mI7WuEwM0Kx0h+wm2PAA2Gl9SLisbBbTx8FRSQvzycilJYTdjFChEog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(83380400001)(36756003)(2906002)(33656002)(508600001)(4326008)(316002)(8936002)(9786002)(8676002)(186003)(86362001)(2616005)(9746002)(426003)(107886003)(66476007)(66556008)(54906003)(6916009)(1076003)(66946007)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D0Zxkv3LEzgspSpzaXSGEU7QgALQ86Wx8UYTxu5N6d78eg2QQb3ZJV+Or0Xf?=
 =?us-ascii?Q?6qghSuGucPE5BkKwV59EkDkmcGbQIHE0ZtXsarfTr3Q6GWlRK2VuOqmYroax?=
 =?us-ascii?Q?AbgVTU5jW2dmbxkB+n4FP0BMcGnPb0qYyDp/hW9CtquHGPcpVMK7ilTay2DT?=
 =?us-ascii?Q?Q9g3odugzlKTaJBI8c/EW0SRMRjtFkUOgSjEXgwnjbg02Ay/PkpzRaim6bjs?=
 =?us-ascii?Q?AHoyzaXUnmtSqvAA/JKmcr82GLR89oN6fIBNPqRLuAvx+vce4eQSDtxszB3r?=
 =?us-ascii?Q?f4GqQMXWsYCvNLzxsMGrA3S5ES/Brtf2/mzs2EqCaJyM2QYShDB2W0gP/8CC?=
 =?us-ascii?Q?sid3xDEN5P7HoVHgWVZehpO30auUKnHeJvrvrI13t4sbuT9zTxhFYKku04Zh?=
 =?us-ascii?Q?/QFzEqZS17R2NHWMpsmb1l2ij7jGCCcGanHVd9sbfLtacsKSaU54erfn5vkR?=
 =?us-ascii?Q?BTPIpdG8womojRn/aZiUScDgFNcat//oh1BI+BXIyZW4yJSsa+QhNEJMK+pH?=
 =?us-ascii?Q?dE9s+PuPwC1sWKmX1cJy5yrVFflhGYA7IMj98HePWoh6sTT9LyWmK1VlJFn/?=
 =?us-ascii?Q?ePdSNFE/tIUjEU+F+qh+DGZkBYa3Vh3hwFXwQnnSL6KowfgIhT+5z38V5NYu?=
 =?us-ascii?Q?ax6vHOwX93iVljGI0TsCgNy9uxfSu4X1tiNVBL/bRmed0STeN7zjQF6RcuCw?=
 =?us-ascii?Q?MxcIf8dKfvjRm7F+nIJAXvqGOW7YpZDNnttOQ5+xrDxmI4EaFwEM/DuJunLz?=
 =?us-ascii?Q?l7iUBaVFx633Pk6dNf9aXfz3NnoNwWxbyEVUvxDqUk637xIqtsxnErvJeUxP?=
 =?us-ascii?Q?kRV8FMHOxjZfrUUyTQIdBSYqWEskbmHyPoW8itY/1+67d2AMTO/KFsHSy5Qd?=
 =?us-ascii?Q?TgN8A7hSp7wHelGQ5lVk6IyLD2ocIGpaQPVx3XWcKLu4WHbVRtcaDsqNiUx5?=
 =?us-ascii?Q?nBKXQqeGUAcgTxYDgtZGWNbTCt0YEw6q5a34QuOGfXQon1cWSTcSZzZ/flqq?=
 =?us-ascii?Q?cNb3gmjzMOzjJ1G7OEMPh8PxpI+N+y4TFT4p9oIcNIOg24m0KZiUkV1RjjBl?=
 =?us-ascii?Q?Og6ki7b/vdrNIYS5uskfe5pCYpe51O0BFFLQH5Ud+3nGrDEB0Q5fetBsrVWR?=
 =?us-ascii?Q?iOR2qv0/MtNZT98cM1XUeq+hbbtK0Wg58L/qP+TSXtctZw2fJjBCn9rDTIfT?=
 =?us-ascii?Q?KW7ok/GgrJHQYu+lcvBmK4c5KYekrmarSI34j3zZXPmbBhcJpaneSSDOBJ+8?=
 =?us-ascii?Q?Wbdaj6eNZl3kAHB/Q2lw/WxbfnG2PcUJDq2KdHd19VsKHFirJcuv2+HVYYC2?=
 =?us-ascii?Q?7BYfIuSyb2eNY1dwz/NkOxZwxhdzm/HiNA7QrLBwvKQAB2lNWNhHu5ZnrY+e?=
 =?us-ascii?Q?27fqxoDyfKS3Z3jbBsdSu9bdn+dfHs0CiANewSRFQ0eJmPrQ7F5xb23324/3?=
 =?us-ascii?Q?/bklNgF+C+Ec7v8hsaZiAVkrnCUbcRRCHAAopAm2AR/6yUovNQX/BFSQATWH?=
 =?us-ascii?Q?OEmMUPfpQZpdgl70F8EwqfylwfiW8QxCTdKkw0G3VugaPgcFziHxrUKbVXRd?=
 =?us-ascii?Q?YdQTsxWhSDiXy5JvNB0=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be3613dd-d3b6-4612-959a-08d9b9997969
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2021 15:51:46.8826
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OGNSUm/kDeCN7k2IvxDafOTuRe0A/xKlzD/sITfb9WpSjpk3A5KvDIcXo+uipqwD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5078
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 07, 2021 at 12:16:32PM +0100, Cornelia Huck wrote:
> On Mon, Dec 06 2021, Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > On Mon, Dec 06, 2021 at 07:06:35PM +0100, Cornelia Huck wrote:
> >
> >> We're discussing a complex topic here, and we really don't want to
> >> perpetuate an unclear uAPI. This is where my push for more precise
> >> statements is coming from.
> >
> > I appreciate that, and I think we've made a big effort toward that
> > direction.
> >
> > Can we have some crisp feedback which statements need SHOULD/MUST/MUST
> > NOT and come to something?
> 
> I'm not sure what I should actually comment on, some general remarks:

You should comment on the paragraphs that prevent you from adding a
reviewed-by.

> - If we consider a possible vfio-ccw implementation that will quiesce
>   the device and not rely on tracking I/O, we need to make the parts
>   that talk about tracking non-mandatory.

I'm not sure what you mean by 'tracking I/O'?

I thought we were good on ccw?

> - NDMA sounds like something that needs to be non-mandatory as well.

I agree, Alex are we agreed now ?

> - The discussion regarding bit group changes has me confused. You seem
>   to be saying that mlx5 needs that, so it needs to have some mandatory
>   component; but are actually all devices able to deal with those bits
>   changing as a group?

Yes, all devices can support this as written.

If you think of the device_state as initiating some action pre bit
group then we have multiple bit group that can change at once and thus
multiple actions that can be triggered.

All devices must support userspace initiating actions one by one in a
manner that supports the reference flow. 

Thus, every driver can decompose a request for multiple actions into
an ordered list of single actions and execute those actions exactly as
if userspace had issued single actions.

The precedence follows the reference flow so that any conflicts
resolve along the path that already has defined behaviors.

I honestly don't know why this is such a discussion point, beyond
being a big oversight of the original design.

> - In particular, the flow needs definitive markings about what is
>   mandatory to implement, what is strongly suggested, and what is
>   optional. It is unclear to me what is really expected, and what is
>   simply one way to implement it.

I'm not sure either, this hasn't been clear at all to me. Alex has
asked for things to be general and left undefined, but we need some
minimum definition to actually implement driver/VMM interoperability
for what we need to do.

Really what qemu does will set the mandatory to implement.

> > The world needs to move forward, we can't debate this endlessly
> > forever. It is already another 6 weeks past since the last mlx5 driver
> > posting.
> 
> 6 weeks is already blazingly fast in any vfio migration discussion. /s

We've invested a lot of engineer months in this project, it is
disrespectful to all of this effort to leave us hanging with no clear
path forward and no actionable review comments after so much
time. This is another kernel cycle lost.

> Remember that we have other things to do as well, not all of which will
> be visible to you.

As do we all, but your name is in the maintainer file, and that comes
with some responsibility.

Jason
