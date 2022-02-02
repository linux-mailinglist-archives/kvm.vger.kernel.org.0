Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 688AC4A7667
	for <lists+kvm@lfdr.de>; Wed,  2 Feb 2022 18:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346052AbiBBRDd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Feb 2022 12:03:33 -0500
Received: from mail-mw2nam10on2054.outbound.protection.outlook.com ([40.107.94.54]:63585
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230295AbiBBRDc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Feb 2022 12:03:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUXwt7pVf7/VQSOvglHhkmeyTD/RjyA7gA1ZjNQh3tJzV1G0v1YSQ+wgkyYuBgIduQSHVGsmihij43EMwmUUqpiNvE2XjyE980eaXoOaCw/avNBbKsH/lJvONQlxL6VI57M04k9lKOIheU+CWIS4jt8n7lZwcujpK9+4BEzaxGiDAAR+4DwQnwnZ5now9VBB6V0B2P5kPMcIbXHPUMYWz4CeFnhXkXKRyVAy+cAbFpFJZcZWcwjaqMNc3wN3iPtOiOSsOWi4fWRqbaViVafGpJSLdQ6/Dfb/ihAKIIiVvmhSA+9eqCAov2nxSclPFoJDgs3nLsRgB1dTwrvs+RT8OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=epBc2tteNGh0vzlRLVshclqH8oMzjYABJhTAxoh1+sE=;
 b=CUhhfiu/ZLvvPbQJfNUni/jS+2XgKvxAPxucSOsPV3JvO7CKOgrouQckTrq6kbLi8TeXLviuQURO4ZCJEPI36rL/RcghaAD5WcROHs8b3bz7Hn/RLv3HIXDP1q8iQUrrJGlXNTkaEXAoXBbG4dR09gx4s4D/nxvVvRTMPlWmVHNBfjqMLaWD2hmFMVdbZEFDdPI3l8rXSzLLxjeFl1otPiiuTmV+TqA9x2gw+re5mX7T+tZ160zqW/ZNHI0+XFzF4ko+0kc7Uhx3lmsF21t6yXuzifWh94jP/W+rrTFCNyQ12wAPAXhzhBpT+o+qD5JB8eIrH8SZqFbFviCOIDsySA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=epBc2tteNGh0vzlRLVshclqH8oMzjYABJhTAxoh1+sE=;
 b=nUJdkax0iXPc/RO6pw6XGTG498hA1K9NW8vc8fnc2Tcp1CpqN8xZbw/lcn+KxzG0AVVN/vRppZmthogsJIOrqMTmH7/UOS6l+pD5X44za0lMOmJx978EotZWL5n+/S4OR5JtNoHON7jaR/jLjLDaI0ELwkP+LZYGf+s6ishg4cYLW0dO/GXgbaFnR/WCik0FcgDkwTbh4y7Qlaz+P2viLyT63mJf2OzWSQCxrLW+1uyRjx4UPKd7vdFivahYtonRCq7xTUhcv3xpOua6dh0pxy6WEPbaJwAPkqxAdWk92ai2glO+E0ibhVv6BEJdHyHGNEv59BIO6cO0DY+DHaqilw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BN6PR12MB1266.namprd12.prod.outlook.com (2603:10b6:404:14::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.11; Wed, 2 Feb
 2022 17:03:30 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4951.012; Wed, 2 Feb 2022
 17:03:30 +0000
Date:   Wed, 2 Feb 2022 13:03:29 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        Linuxarm <linuxarm@huawei.com>,
        liulongfang <liulongfang@huawei.com>,
        "Zengtao (B)" <prime.zeng@hisilicon.com>,
        yuzenghui <yuzenghui@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        "Wangzhou (B)" <wangzhou1@hisilicon.com>
Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
Message-ID: <20220202170329.GV1786498@nvidia.com>
References: <20210702095849.1610-1-shameerali.kolothum.thodi@huawei.com>
 <20220202131448.GA2538420@nvidia.com>
 <a29ae3ea51344e18b9659424772a4b42@huawei.com>
 <20220202153945.GT1786498@nvidia.com>
 <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8a0731c589e49068a78afcc73d66bfa@huawei.com>
X-ClientProxiedBy: MN2PR17CA0015.namprd17.prod.outlook.com
 (2603:10b6:208:15e::28) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e4b07c1-771c-44bf-e5f2-08d9e66df056
X-MS-TrafficTypeDiagnostic: BN6PR12MB1266:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB126674BABB1FE23513C7C22BC2279@BN6PR12MB1266.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uMtE83WUgOxNF1eRxkc50/r3CXsT2CfXejOwT3Qouh8NH5K2GjGb/X8TCdnzoeb95ADncw1B3X2NrggOXvXjK1O9nMRk8wENmTv5P/kPM2Ci6f87HppUYCr2J65c/Od8pWRVZKtWaKMxjOO32GWNIY5nL5VPICTedQad1DzB+xCHiQCQklo1urfbWKwAf/bwQK18wPv7HD1wX7GRpNVx5T3wC70BYhoPlbx5QQFzLGZQVmbf1+GzT7X+Ee8ts3R/07DCw13yKcp34HsFMcxWZ+oL758pbe3auxBS/q0eT5Bo1DKsxw5whQtQf3HZFElBqXS/MNG1g6IxxXMX7RJJ81ghM59/XJLbaWQFbTE0Ldn6N+kwUz8WZhm77DWFzfZFdiC0PQ7kXtPAGZoyP5/NJzBHVm6HK264CZIkgDyWRtGRhnKgwWSbith5FGW7LG3Pjzz+mIeHzKUaRQZd/snFybIWqLoSzzyorhROiZ3YS9VxaQvPxr8XyyNL8WB5fHAL7IWXgYHarPlcCSZPkFm1XzH/GPDFvsyVeORAx0WNKXDn2E0DVRO6dFG1Zy+8U/p9OIYUPatk68lY1XENfCwpeJ8FzMzy9PslqlM6c8tK50gcdChnTIVgzwYLTATuHaszNYSCfmihTQ+kv5bUv+11/KGtaMWFjL9hB8U+NLY+bmzjAFx75VlGJB9Ti+c2KLIJ7GunVCfiw4BlxSO9HWNTEq4fVBpQV0hg2XQ5Wxa265s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(8676002)(8936002)(6512007)(33656002)(4326008)(508600001)(66946007)(26005)(6916009)(316002)(66476007)(54906003)(66556008)(186003)(966005)(6486002)(86362001)(1076003)(2906002)(5660300002)(38100700002)(7416002)(2616005)(36756003)(53546011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P7M0ncOeA70D4lK72BS4NK1NDq0iN0drfN94af/uxa2YOAxm/+Bz5fLQWpg1?=
 =?us-ascii?Q?uKw8KrbCiA4OotQtDE3SMKMb7WTJBMEYJS1c8icneLMu6xVAz7i6utkIi3KR?=
 =?us-ascii?Q?yj7EHfSVMto3AlcS7h+Br6P0Q1BdsgHJemOsv69vkG1j3NYM8t4JWePFK998?=
 =?us-ascii?Q?VpYDyEh9NB28qEUPSsIr3+j7sxj3v5bR5p77vUCek4eHOhl0kJZub6KdCmPh?=
 =?us-ascii?Q?l0bSNY/Gn5Tv2OodDXHH6X05bAun3RVL+sfVKMsDjOv0J5KcIqwT9pNdVaNE?=
 =?us-ascii?Q?oCcunbj7kPU5AQqzTMVjqI9XO0heHiKEZBPN1AVK8nMxAA+3NTVT13kQEEK0?=
 =?us-ascii?Q?rNc3ljJIkIdMJvS6SIdjrllU6ME0wvuvId11oaECQyzDcK/ECM0ZeijIQ3Yz?=
 =?us-ascii?Q?DST/oSROfd7yhQv3+luyxQGBtpfckltrXx/bV9EbZDQGpZKRS9D2DULsP06D?=
 =?us-ascii?Q?pE+LqM9hzFhIzbkPOAAfFteVBZOkPdyDTHPso6LlH7ZHxhqqCTLwr4OCCgBo?=
 =?us-ascii?Q?u9Cq7sbBpkSusU75UhxIcz6Il5alN0uoKaVeoSo9Fswr7Wq9fqTHuF/sAhkd?=
 =?us-ascii?Q?tY6NTfGmpeZIk+V38U5uQAe1HNfB4/KIl/vYqUxytpu2vq4MEo/ND17Ioi63?=
 =?us-ascii?Q?gxpOVmy+Cp5cltSwKVbbkqnaOh/5yeCFUTBTyIpIzrNmBNFWL5WaPrUbpgfr?=
 =?us-ascii?Q?YGVm52YJg2kInxj3/gpd2vX5BChje3l7grBPM7afHdukIAVf6vCvM5YBc8Lh?=
 =?us-ascii?Q?y0sXkCJlgG3uAshs3yrf8GIKz+7ePhSCzdJiP/OVAeriF2MypWDGOA1yQHsH?=
 =?us-ascii?Q?wtRK9CWigROaUdc1ySxi5rjrFLqw5T1RXPY1PPVNM505PPUeCYXOLMSuTYjh?=
 =?us-ascii?Q?4RdKxfUoE/2OHZogULTrmx2mr9qaG/GjsWKto3ZHg/PNNpNRU7ZqMQbx0Osm?=
 =?us-ascii?Q?ZCkdAXcoDczR5TC20xWHTCqkLeNQGB1Y2LpMh043+lwwdQ3dI6o13+JAK4tB?=
 =?us-ascii?Q?EnX9QSvpgx2GN9SGMU2wVaZ8PKYUhcOKUvX7+i1y9TpdqE0dkaofoJ7KN63F?=
 =?us-ascii?Q?xVRCaHaafMsqjq+3I3O/b/LfQRi8lihzd+sysXPe94YR9y0fOaJbNb2XR7YI?=
 =?us-ascii?Q?uhkx26B5xNfmsdq299P5D+Er7Ftrdd6JviRbsssa6PxtCDURC0EqpekGdeFS?=
 =?us-ascii?Q?1NJl6LBEgurVgJkWjaOdJWIuDpE7H1iU953qVGVF9Uh2RHWwAbWrVdAvnBrs?=
 =?us-ascii?Q?5DYx3OHUfOEpZv+6Ffj39GLbVUd5VFor0hLLpufy1taz3cjMBBSY2a6Dsdvy?=
 =?us-ascii?Q?a5CRElBNpGYCu3nd4zFaqMZUwG/x8sWwo9rhA1ighzSz9aZrKlFJ160Qt0X4?=
 =?us-ascii?Q?rso1lx/HXUsiUrJjWBx3OrHXIsFIQyjIJoWLuF/1M+XZ+CkgfXVcOFn7yT7v?=
 =?us-ascii?Q?/6lJxkl2gmNRZOYnEQVnQ+mtt8dLxDKxn58vs1ZRWFECQwE1+SjjeT4ySvDO?=
 =?us-ascii?Q?MVnCW0ymiX2fAyTUW327f8fwu5nBfcTTHWkcxEN0ZQ5g+8l9MFkMRF8XQDXM?=
 =?us-ascii?Q?pwHr+x/IWHz0BooPhYA=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e4b07c1-771c-44bf-e5f2-08d9e66df056
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2022 17:03:30.8623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: viesGuCtsMA005hdNLhoSbxV3LaezBdId+bdsonbnW/CLn8if/mi/DeeBlQjD46b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1266
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 02, 2022 at 04:10:06PM +0000, Shameerali Kolothum Thodi wrote:
> 
> 
> > From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> > Sent: 02 February 2022 15:40
> > To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
> > Cc: kvm@vger.kernel.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org; alex.williamson@redhat.com;
> > mgurtovoy@nvidia.com; Linuxarm <linuxarm@huawei.com>; liulongfang
> > <liulongfang@huawei.com>; Zengtao (B) <prime.zeng@hisilicon.com>;
> > yuzenghui <yuzenghui@huawei.com>; Jonathan Cameron
> > <jonathan.cameron@huawei.com>; Wangzhou (B) <wangzhou1@hisilicon.com>
> > Subject: Re: [RFC v2 0/4] vfio/hisilicon: add acc live migration driver
> > 
> > On Wed, Feb 02, 2022 at 02:34:52PM +0000, Shameerali Kolothum Thodi
> > wrote:
> > 
> > > > There are few topics to consider:
> > > >  - Which of the three feature sets (STOP_COPY, P2P and PRECOPY) make
> > > >    sense for this driver?
> > >
> > > I think it will be STOP_COPY only for now. We might have PRECOPY
> > > feature once we have the SMMUv3 HTTU support in future.
> > 
> > HTTU is the dirty tracking feature? To be clear VFIO migration support for
> > PRECOPY has nothing to do with IOMMU based dirty page tracking.
> 
> Yes, it is based on the IOMMU hardware dirty bit management support.
> A RFC was posted sometime back,
> https://lore.kernel.org/kvm/20210507103608.39440-1-zhukeqian1@huawei.com/

Yes, I saw that. I was hoping to have a discussion on this soon about
how to integrate that with the iommufd work, which I hope will allow
that series, and the other IOMMU drivers that can support this to be
merged..

Jason
