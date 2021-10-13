Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F214242C08B
	for <lists+kvm@lfdr.de>; Wed, 13 Oct 2021 14:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbhJMMv2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Oct 2021 08:51:28 -0400
Received: from mail-dm6nam12on2065.outbound.protection.outlook.com ([40.107.243.65]:28578
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231294AbhJMMv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Oct 2021 08:51:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WsQ8740uEYBlmAjYoqTYIEzCMqG8WEWY46/PCa7Z7W5gfBqFn7WPMO92ZJ2rprOHb/oY6nyiToVO2VqTakaUgPk0IlhoOcWfKGGy4Uz153LLbuK9ZZD9po7nj+6f3LSJ1ZUh2l4A4RXv757MEoe/QOE0E3KaO6QOpAar8MmqkQ3ftlpWYaOO4ZCIudWVLlVmUwFJQghUYC5m1rarN1DAsWKoHn+SWFt8Qvg5SNhq+WjkizfQpfEPSt4Y8YlhYJLpyuoUGABW0BraZldrzEgwStrXRXYyy4s8g1Ey/MGcS0+Kc37uqrU/So8BFK/ExZwHOQ+xXP8XQsPcepqyVtPU9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8SAA7psH31qz/KOe82c/Qtn/vGaBK+GfJQVFSYMrdiE=;
 b=m9ZS1M+e7MpG7hzLKiJJYnkj/gbrQvUte3BbyvDnYL7Xe4AQkTn6VlCXDf2hKyz6abrLiE0d+WBELPzr7HEGE6z08EHmgZEvBJJp1ywKMqIdJzztABF7RR3/TD2pSeluyC3kKqd2yzMaGvkumJAE4fGTuqdkLrCji/xCxcxFsQ0fgYN39/Y9uCNhpZzKp93hkUU9a8CsRAmiS1HS1b+8bg1WWU7zuWFBAh3+/qeIXImZqoSZUsLV4ivAhLn9PPFbYIbC+tHcpIJUO1GHf77Bqk0QT3ehoi+Bs/l9qF+SuL868GjWVh+xaoqSkwFEi6KaOWvSRKqKYCJZDX/q5CvmLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8SAA7psH31qz/KOe82c/Qtn/vGaBK+GfJQVFSYMrdiE=;
 b=M7j4F1guJ+9ZMqmXgvFOhxaruzEQlFKO00PnqxRNkhuWCbIgDks2Ifzi7QrBU8rlT+zmsLrzoWrx1D0ctTdw8tsF5U2K9sgPtSmeoz++6AhRxFSpmwWdwcoLxUqsj5yftaV/wwHuf6CuP6f2z8g+iUaPUSz4bcpid5j7uIdUuPWX1uF7qw/MgozJJh3cqRjyVk4rP22LicLYMKz5VKOBO6/QVmhToQihofIJJJuK6u1xQ0myxturHlHLjV1Obi+ZI9y2OVkVjNIOd+ziHvXKELLd3wPqSEbQj7C/TOis2EiZsZg2p6OqhIJc4mL2WHxPXe6a7Ina5ET6k53BhP4ZXA==
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5061.namprd12.prod.outlook.com (2603:10b6:208:310::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Wed, 13 Oct
 2021 12:49:22 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.016; Wed, 13 Oct 2021
 12:49:22 +0000
Date:   Wed, 13 Oct 2021 09:49:21 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Liu, Yi L" <yi.l.liu@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Tian, Kevin" <kevin.tian@intel.com>
Subject: Re: [PATCH 5/5] vfio: Use cdev_device_add() instead of
 device_create()
Message-ID: <20211013124921.GB2744544@nvidia.com>
References: <0-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <5-v1-fba989159158+2f9b-vfio_group_cdev_jgg@nvidia.com>
 <PH0PR11MB56589648466D3F7F899F9F5FC3B69@PH0PR11MB5658.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH0PR11MB56589648466D3F7F899F9F5FC3B69@PH0PR11MB5658.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0105.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::20) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0105.namprd13.prod.outlook.com (2603:10b6:208:2b9::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.4 via Frontend Transport; Wed, 13 Oct 2021 12:49:22 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1madhB-00ETPq-A1; Wed, 13 Oct 2021 09:49:21 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 184a6497-d421-490c-1602-08d98e47e157
X-MS-TrafficTypeDiagnostic: BL1PR12MB5061:
X-Microsoft-Antispam-PRVS: <BL1PR12MB506168796110F39C942BC6C9C2B79@BL1PR12MB5061.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2DhuK3ZafRWuFcdLgh66WxhYrWhqy6Jmet72RaInUU0jLcRLHVxaLj3WYhSW9oYNhJiSfvvDeS/pmlu08Yd2WVXlewalOyqfMGH9foz/FRoALD4UAwbjSHTID5wNelZ/gIX0qk0ONIn8k7U7DknQiMndBjTUVxsX34Hm8XQQ1TknCDcNOoqriRJgy0zqOz0nH6e3YVVuHzPnQHATosbeSlUJGaXe4Bewp9UppKFBmac7+XCcAvn8uCt4HxMqThmJtflct51TEgdjKjTlK9mTvi5gTGYt5y3veuTDyc1I2CAoMobLeCjWP43Cl4f0lSFPkxSmsDSBdaFEsgQ3C0H8GGtcILMLzah8jkqv+15nZ5hNjKpQaYQ7OdWCe3NNVN9NFS6syCmUXuhW6l+xsulxsprr8Yb5YsWPAje40GP7PorjhFfrw3I1Qo1s9dREGS4dZyM75PwsMbPA4f9LYCU2GZy641P+KXGFMUzExsvAbnZKta5G3zILoYmVcURIub0mvPSir4DTe8Uyd810MOD9Eg2o+/dgQOjY2fho1ANrLNBsBehkbfw9xIz27nVmZWRPxI/RtgZbsdw68yt7jeXm3Zky28AFop7XtTlTxnUPr1AArngUbRkNyKxLDe1BfCief3ebRgPURAaVXR7KVKt39w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(6916009)(66556008)(26005)(8936002)(54906003)(4744005)(66476007)(2906002)(66946007)(38100700002)(83380400001)(316002)(33656002)(5660300002)(426003)(9746002)(9786002)(86362001)(8676002)(36756003)(508600001)(1076003)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bNm4OoV+lY/cPzMOn+WsThpHp7BjIONYZAofwVfD9ApQ2uXXSLehFVaMwHUx?=
 =?us-ascii?Q?DRptG3y9debzuRYjoT0GeKsZjtIe6yr0xg2S+lAUtUIms69wsxHHsRfTw8Tj?=
 =?us-ascii?Q?ZINgqZfGVLaQz9P9VrSfYzvuSK8TGy6q3pTvfMHAFIQHnOn7yCnRVzCLh6sG?=
 =?us-ascii?Q?q623ZrUhlF92jsPlVvdg5LewTX6TDUugkuDk/yTPnXdWvPPkQpXY//N77NbA?=
 =?us-ascii?Q?GlM3BxrHVnItNIQv6AF7QsVz+Fe4SXCSwtmHPvswz5D970tPRFZSBR20WWFv?=
 =?us-ascii?Q?BwpiZKBYap4/u9gqw0yyFs08H1/eQsutH57NJzDc24aA/eiBR1kpZyBYy6z0?=
 =?us-ascii?Q?dgO2VYa3Yaqz6UB8xPN3iF48frtT/pmZANJWh3oXjyL3criJOF15VsN1n70/?=
 =?us-ascii?Q?PLdKvrEGVm45Mj1oO91XC4jbNRoI2nQqERVKEDTpoLDsPge22E+FAVPM4sFU?=
 =?us-ascii?Q?oAUlmw3b1vCRSuKjS9o+dWIkMGhaA1c6D6IK+AUMRhZxqoMJqmrOgOwHfiZD?=
 =?us-ascii?Q?E1n1NIeJQSP4rl68PqwuutnXt8RoolmTxa+Emo2501taFdSNhvYw4x0gnMBK?=
 =?us-ascii?Q?YPbMScnKCaGE8I4hWb9EnDdDHRWS9xlST+XDHzeSpBFCNaq534xp5hI9HTKf?=
 =?us-ascii?Q?OIlRVDN+QkIOk/C7oRlcUzAAiS/hpBeoKCmpCMkLUqQ2D2jih5HmqN9otNg/?=
 =?us-ascii?Q?p3xkw87Uwd9c8+Ah27kqOtIwd1SB4DNy3mMVWhVN6Rsl9M/h3AXzal5cu3cY?=
 =?us-ascii?Q?X7hT+8GCZsAO2UGzofG0hl3eeGgWekKelqwmDjSPnH9U6eg+xURlf/vJqbZv?=
 =?us-ascii?Q?3GCy+bppzYK2Xs9amxofT9tsx7CRl2YXSeA0G0ducEXLInI4Qaf7+ttwXxus?=
 =?us-ascii?Q?QZn25kxopHR7WAAsNu3FZwuPOY6VN7v2rOWOuOtRSWxUpoka8AzN0ocoZwrd?=
 =?us-ascii?Q?Px8T3q5GVrjmkdjQ9anhh6KOQtq8x9VrqsVAlmFy0WhKGX/ycg8pl39CNefP?=
 =?us-ascii?Q?PKPgKhK0RM0uHV74gD2+TwTl2T/WQ3lApha2BHYYFHqUBgSBdu2OLB9N0u+6?=
 =?us-ascii?Q?cna+uagh7G1q++BfvMmmzDe3iez5mtcLiBDo5kuGXOlSJuU+asbUQGXu8rog?=
 =?us-ascii?Q?MMR0fUwCsL/fU3bVxWP953VyPCPhZ/OZM0OjMqicgrvAvPrH+CA6zSZqkQdJ?=
 =?us-ascii?Q?tCvXkgHIzv73KWyLKv2Qo38Adc9nuaUZPaENrgr3W0y4ct2spG+aW7jslRhq?=
 =?us-ascii?Q?QGlqRAc87OB7otKNZeqgLZw9JqPpOWDoET9qgtyG5J5vFUPoESyTf8HbXaZs?=
 =?us-ascii?Q?cPq/LyhrCMgeHwFO2g9wuAeiCJ2HKLGmrV+4p0HWGAvsPA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 184a6497-d421-490c-1602-08d98e47e157
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 12:49:22.6796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sz6PAgDJd2wNRNTLjBqrsZmXSOzQCHhVjbaMXo9+Rjpgk4NTZJNZyfx1NUXTO+ad
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 12, 2021 at 08:57:22AM +0000, Liu, Yi L wrote:
> > +	ret = __vfio_group_get_from_iommu(iommu_group);
> > +	if (ret)
> > +		goto err_unlock;
> > 
> > -	minor = vfio_alloc_group_minor(group);
> > -	if (minor < 0) {
> > -		vfio_group_unlock_and_free(group);
> > -		return ERR_PTR(minor);
> > +	err = cdev_device_add(&group->cdev, &group->dev);
> > +	if (err) {
> > +		ret = ERR_PTR(err);
> > +		goto err_unlock;
> 
> should this err branch put the vfio_group reference acquired
> in above __vfio_group_get_from_iommu(iommu_group);?

No, if ret was !NULL then the reference is returned to the caller via
the err_unlock

This path to cdev_device_add has ret = NULL so there is no reference
to put back.

Jason
