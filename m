Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 699BC52633F
	for <lists+kvm@lfdr.de>; Fri, 13 May 2022 15:52:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380936AbiEMNjM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 May 2022 09:39:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbiEMN3O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 May 2022 09:29:14 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2067.outbound.protection.outlook.com [40.107.220.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DC481EC7F
        for <kvm@vger.kernel.org>; Fri, 13 May 2022 06:29:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TIgf0C1fFQbUCecJ1Htpn7w3d/jHvsUXUUWsa9M2HmZxapNJkrRYUcrjpxTFVxAcfWpphRzgeZYU46v9whuTSgs7EN8X+K0u/fxw04BuaVc2aw4ZS/mELsfeTq0/AhB2mGJBxnH8Tn5x2vEVYTiz7U1DxzF0neFK8LSICH+O3FfqKLWTtGnkGQrqN7NypJ1PWb7qh9fzHpKMoxR4dsXR3IPgqG2qgkavvoBFfEj329jKrDFZ+6IRxl6z4ylwSK0SXD4dAtEdG6nuMR1lxVqLijZtno/vB8i5f+8bXYqBP6G91WYa5wZHkJEiZ40VclUOKrvLkqnpn1Q+9AAtSo8DNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TmbyqER928X3r9het9buAzQXiT7ccA8coL0TzdkL/Mo=;
 b=cG12kSSkJWJWptj4IgQNtrGGk1YsJ6s7xHmtbFgvV1+aqLMNxLJPOyKIXvuWqWA58zRSqdsjbWuwfLZI7tLOC1592sDTXobSELL8wHTc9ZtJScVNdZ1knHGQOfJqzJJn5znyCzb/QU+E9EZzsbsbxJGSlPq5L9Vqzmbkn2ygmjCDWDGWDMgNDWTA2b8AN6hbr7ExknTUr3IgctNq1/PSivbrtl7l1yf96+VHzdgzP1rlvmsQUQqmK6ytNwS/sBITakF13DqMwqYMbiTSE4wsRuHsJNbLdEwpVVAiuNIXFMPpORMkpPVvWhyQXJCT8wyw1yUD5yY5OS37lVvTtqOdWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TmbyqER928X3r9het9buAzQXiT7ccA8coL0TzdkL/Mo=;
 b=NCvcIqkb/0+Gs+vJKtLEb4srthzdoMfBZtzP8SwXL0zRsguzaZ2Kf/bfDPnQ8gbCAehfxxC9A6gklVyiRS2Zr901jtqqkEeEp3KQMBMk+cIikH4bbZfp3MZFlPKswOqazwr5YF8onwPvM1ydKqMJK/An5veuZHf/YJFkNrEAJcCsvNM5AqKE9ddWrnRR/ap+RpBMFRdSymbin+OqgFfpCm1SPPmygAu0UAmbimhtr3PrA3oyLto2ZwYmb1v4RhvXWg2tqqAOLvW2VM6gmomrCuF1kWS3p6/zun8wbifyrLxdMYI75J2pJ30rFgoJ6VY+FWQq/i8SdDR1EYv+9ztnsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM4PR12MB5818.namprd12.prod.outlook.com (2603:10b6:8:62::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Fri, 13 May
 2022 13:29:11 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::ec2d:9167:1b47:2db2%5]) with mapi id 15.20.5250.013; Fri, 13 May 2022
 13:29:11 +0000
Date:   Fri, 13 May 2022 10:29:10 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Xiao Guangrong <guangrong.xiao@linux.intel.com>,
        Jike Song <jike.song@intel.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Nicolin Chen <nicolinc@nvidia.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 4/6] vfio: Fully lock struct vfio_group::container
Message-ID: <20220513132910.GB1457796@nvidia.com>
References: <0-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <4-v1-c1d14aae2e8f+2f4-vfio_group_locking_jgg@nvidia.com>
 <BN9PR11MB5276CE4C4C01A3D34F8DC48F8CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN9PR11MB5276CE4C4C01A3D34F8DC48F8CCA9@BN9PR11MB5276.namprd11.prod.outlook.com>
X-ClientProxiedBy: BL1PR13CA0250.namprd13.prod.outlook.com
 (2603:10b6:208:2ba::15) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7944aa32-8ae5-44f9-a6ca-08da34e490cd
X-MS-TrafficTypeDiagnostic: DM4PR12MB5818:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB5818EEE7A0663F6C70F0E72FC2CA9@DM4PR12MB5818.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9S+NcQl22WLCnLZhNnz2ELgxI2InMRe7AcfKk7DGCba4WfwZHduxrOVmhuLcB7kYia1M3cRIJ3ZOJHRv+vM+i97Or5EjneFFbaZ8Ti8BdD/wvkBhW2qGIsmiaCd1jLBt5jpPqxKQfWSWyIgcyi/wFc0Rx+cMyte+ve5fttiyVs6nF6I9AwK49Ip5krckeHtQYhs6E7BEnvp8ho4+GC7C+Qa+6uji4ttWECYBLh6Ff5lhR9Bo6/sM0oerucNwqAF8vabmpm+A/lhsYaWet/7J8+3ZleK2awNf/vWzD3Ntm5e0JvrtqbQqf6CMv24JBFy/4TJ+jvCAIvNCeO5HxN+a9XllalR3JS3YR19grcHXpjLfWqNltZQT5EtyTdaFw8c3DN4e1//B1T5L2hSVMibZRrl2RdKelaEfjLb5CS1mdA+7oOdX2jMHDEgGjPLPbAKoMxJDNxe2qTURHHUZpH1gF30KcCwW7YFrBzWj7DVqtDE0lcTwltqnQ5okfq9dUjdGjqhMYlquI97prZvHEKVebnNMTyYKvUTNFnMW8JyNYIZV8od2vnSJw4pe5a75AcIHp76kkpUUnwRU5pu/cd/fhkLlU3KcFNWyNCxpREYAhec1tQ1Afge6jCXdT3WKovVLbAhWYw+GF8k/7TyOUhbSbQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(6486002)(86362001)(6512007)(26005)(36756003)(6916009)(316002)(2616005)(1076003)(54906003)(186003)(6506007)(8676002)(66476007)(4326008)(66556008)(66946007)(508600001)(5660300002)(8936002)(38100700002)(33656002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CgT0y9i5sXQAUIPdPg/lTAnJgwRbL4rDewVvsVEUszkArMMTI4vpSZCRdyIr?=
 =?us-ascii?Q?HFUFD3nM4SON7G5KRO/fQmgYDZBgo37S2vJZ9kWtrAdRnV8Sz3UxTKNFCehR?=
 =?us-ascii?Q?MIwdbYDIP73EU9ho/Hg8kYbKCnbhf3PGAIq5mpWeARtx0Vd1EoiEs6maUIQn?=
 =?us-ascii?Q?TqlFWK6D2TPz8KH1rLgVfAsO2RWxopaQEw0nlIbrka1eKJSUwnTJ2uznZp1j?=
 =?us-ascii?Q?x/DxWbBJ5L3FFRedH2hZ4gAXESvlmvLKLKkxjgYx1xvTEFtm+zOf/ed/rrfs?=
 =?us-ascii?Q?v6rELFriiGMroJKSXl1HQ3SI+TDyVhbwibn19R7hHzj0NZQo2C/NNzjmnd3j?=
 =?us-ascii?Q?NrpX7fS3cdtm0Quw0k6XyaU3SmTIFvsTR8fs983MCp9jMcT2hDuNW6slMXq4?=
 =?us-ascii?Q?2WI3ww+ZhwfZz7hj3P919hwp0jP19cjbb1uudU75PTeIvoEUB/zntrhTmVVc?=
 =?us-ascii?Q?T8SEsgvzHaY9gaNfuxmuU1C5Ev62bCyave0+LAPVvvu23GlbROC3aX0vjHhR?=
 =?us-ascii?Q?zUB4h/wPYXjkNxUBLlwN3MBusveV1hI7NAzqNLe5rvGdl1D+898koqptkfya?=
 =?us-ascii?Q?zs0xcmSEP4NDSHhOMjbTqHKOnPd5iJgkfwW+soVf0V+zkfzZzeJ0qtpnYJYJ?=
 =?us-ascii?Q?zEjW8zm8CnRl2R81ywQ5ETqmtm7KgK9JHGgEUwcPQ7cjcDzV48yz3eS17fnV?=
 =?us-ascii?Q?Cq8sBtkH22QQaAveGuA0FO6rOtnCfc5Ql+frEwro5MlkLgb4wcrvTHcq/Q3U?=
 =?us-ascii?Q?cO6o+okZ2l4LqCCMQ3PEt+qH65TrqtORgEC+r6MmkevIp9+5TIenrV+sAU2S?=
 =?us-ascii?Q?lePdE/uyMos0rCPTaVjNrbkhLd487GfnmEovcia0w5Vxr22FCPjc4UrQ/hx/?=
 =?us-ascii?Q?UNs5rADhDLlElqYSbq2tr8fowCmYhZrbiAHfDk8ir0HTahmK3sFjT/mSpRB5?=
 =?us-ascii?Q?k6i+UX06R6Jg9MHPQSpJ/UlinV2dy0DOZLDlN0LwwY7xzDxkuKdjJaHgS3q9?=
 =?us-ascii?Q?yiaKRsrdWcguI0oNVnJbEvH3we21NyO1JjxtiUOhTZeT0dT4rjr/QfQlwj1A?=
 =?us-ascii?Q?OtdlXIH+8hoV9gAX2xLOBWbZW/1rT/b/dH9qKLMcXB0gA3XvhEvn6uvW9sMm?=
 =?us-ascii?Q?QhN4XK+RZ1v2BtKUM37tXlh9gEKHKkPPkJv3sRAS9DSNAaTknTQzls8INhk0?=
 =?us-ascii?Q?dCBnXlHEAJw/d7eimLSBNf4mH7/bSFZGhRdjRZwYqkDKXN8F0s3Xw2xihC0c?=
 =?us-ascii?Q?z2GjmYaneEop5DKrJZsndLA9e9B49i6K4/QSLi2RFUUZ9Zfdd2P8d4ZG2fVM?=
 =?us-ascii?Q?8D1GYwt6l0AOYQeN2IFCm4pbTcKneeW1gDk6bgr2epTaLM+ti1e+GvL6/uAe?=
 =?us-ascii?Q?a71zjAYQlSFaYj5OAB6uuHZoIlB8l8VYGl5LGHRZRahZVQqQr5n35eDG8/3u?=
 =?us-ascii?Q?LKvbRKt0ZfmgEoMGNcEsypmD582UzrSKwS0Q1XmwKoYxKfq4zSGi3vX1OQSp?=
 =?us-ascii?Q?PEXdv9Iz9+F3emVytVwmYoWSEQ+wnOnCvJENsIcyG7ReNJWqkVzO6awWEqal?=
 =?us-ascii?Q?7NOQRWkVsoj7fGhybjdcn2E3jN5/sMj247K+RktWknao6iZ+zgHUbV5XfSJN?=
 =?us-ascii?Q?qp4fEl9JsgKSGyxuATjfrmpw/QKL2dbvn+3pfZyrB5YV3uLzK9RzcU9T3IEt?=
 =?us-ascii?Q?ecoWhMzBfXCkLCesgzfSQXl9TyYFLkVv1ldhgBFyHXUn18rSPTd/Hdd0Sy1k?=
 =?us-ascii?Q?wopyetvyiA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7944aa32-8ae5-44f9-a6ca-08da34e490cd
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2022 13:29:11.4805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GyPxKMKRcRLEasmCoCzikPGdUoOk98vMWimwty+VNnVWUUpIAd9+2HEUmZg7i9qE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5818
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 13, 2022 at 09:53:05AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@nvidia.com>
> > Sent: Friday, May 6, 2022 8:25 AM
> > 
> > This is necessary to avoid various user triggerable races, for instance
> > racing SET_CONTAINER/UNSET_CONTAINER:
> > 
> >                                   ioctl(VFIO_GROUP_SET_CONTAINER)
> > ioctl(VFIO_GROUP_UNSET_CONTAINER)
> >  vfio_group_unset_container
> >     int users = atomic_cmpxchg(&group->container_users, 1, 0);
> >     // users == 1 container_users == 0
> >     __vfio_group_unset_container(group);
> > 
> >                                     vfio_group_set_container()
> > 	                              if (atomic_read(&group->container_users))
> 
> 	                       if (!atomic_read(...))
> 
> > 				        down_write(&container->group_lock);
> > 				        group->container = container;
> > 				        up_write(&container->group_lock);
> > 
> 
> It'd be clearer to add below step here:
> 
>        container = group->container;
> 
> otherwise if this assignment is done before above race then the
> original container is not leaked.

Not quite, it is the assignment to NULL that is trouble:

> >       down_write(&container->group_lock);
> >       group->container = NULL;
> >       up_write(&container->group_lock);

Either we leaked the original container or we leaked the new
container, and now the atomics are out of sync with the state of
group->container.

But sure, it is a touch clearer to focus only one scenario, I picked
the one where group->container is read early and we leak the new
container.

Thanks,
Jason
