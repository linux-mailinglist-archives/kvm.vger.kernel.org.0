Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899804DCEF6
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 20:41:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbiCQTmz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Mar 2022 15:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiCQTmy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Mar 2022 15:42:54 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C55D2359C3;
        Thu, 17 Mar 2022 12:41:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FCTRwy1W3LuRKGt97a9dIJst07SnrMG5rwjBHpeYUA2WmXnebuALJCXkiHGtwk2yC39NU4Cr71QE8ziPV7eLB7BeFSQtECXiJCnLgZFz8KLL6TJdrIuLtLPcoSuN8kv0aajZoic6QiLGZvhTwhdgIxPK/OHv3oTT3j3qLzyJBXE64Ds9/ZnXYT0JlWBWWPBhtZphlGA5ERJcW0uFEUb6SA/DLP9eLFscuNCRer6Wq4GJhmuBNuBxdTxixHOkuMtZVG41IAwCDMr/dwiNJKPqiQYBOPeePeqpmJCqGNd3SQguPE8CT9i8BIdsF59C3PZlk9eyASv9RliKL0Q556o50Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BoI8sNH3TpdUr8tYBodRZdHIxG7/m/iQLMpnONnADoY=;
 b=F6ovW5A4tuyAJWC4eoDuOIErohrUmJ4WzN2VmGqoS14oAf+exDtfjM8+Q3Ze5rGyBjaICU0MyHDt92PflxOhfpE7Zs8qlS8Os+2jnba99l5xS6tYpJNBlc5R19yhwFsFVii5sbvNniWrs/rBuoz9VHDb5AcTnmaYwt5Wc5nGI88naOWlDJZRXfmwaFQXU8mS3tTZEootZ5icz5nVchqyznNfOq2uhyA/RtLCtYe3dP8f0YairAe4Jt4J3QIWqxAUwxU8wZI61o+PEfos6ElC3iaT1Vh8WyO89LpdHKLWCeT3HlrsWQ5U7qoteq/2qZz6zNBwtHbCXSCjScvTdWkziQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BoI8sNH3TpdUr8tYBodRZdHIxG7/m/iQLMpnONnADoY=;
 b=KmlTmiIQdJ8lKK9mm/kOkdgutbKuuiyDrJa2VxZsgIlCH3zQQNzhuoBbYOnz/EWWkOrB8CS84IKqls4Oro9ka8EuehlAFukb3AldnJQvt+PflYKOdzseA7j2vGiv321whB4ulyITyvbMcpFNM+92gNezRXegzgpigABaSmB9lYXaTtkFzlqFm1ISiDwhwEb9/kOeQ+ycqEQo2rQsKLSiXTa7AMnT/h3ooVClCIUvpkQ/3RH7Xh74i7AZCQCdd4aVSIbw+WB7yrf4B/z7Uc5Ew8wz1up1VqD/IC/x93Xtwdv0nlr9DQIjGqjU/yPca4rvJqxqD5km3OALoxJFScXRsQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.17; Thu, 17 Mar
 2022 19:41:35 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::11a0:970a:4c24:c70c%5]) with mapi id 15.20.5081.017; Thu, 17 Mar 2022
 19:41:35 +0000
Date:   Thu, 17 Mar 2022 16:41:33 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shameerali.kolothum.thodi@huawei.com,
        kevin.tian@intel.com, yishaih@nvidia.com,
        linux-doc@vger.kernel.org, corbet@lwn.net
Subject: Re: [PATCH v3] vfio-pci: Provide reviewers and acceptance criteria
 for vendor drivers
Message-ID: <20220317194133.GE11336@nvidia.com>
References: <164728932975.54581.1235687116658126625.stgit@omen>
 <87a6drh8hy.fsf@redhat.com>
 <20220315155304.GC11336@nvidia.com>
 <20220315102200.15a86b16.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315102200.15a86b16.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1P221CA0015.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:208:2c5::34) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b5a1efc-72c0-4487-97fe-08da084e24ed
X-MS-TrafficTypeDiagnostic: SA0PR12MB4384:EE_
X-Microsoft-Antispam-PRVS: <SA0PR12MB4384FAC3528C7349D8A91C08C2129@SA0PR12MB4384.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L4PfJXvzU9uHseNphPfz0wWCfPgv6spdy5zjQ8cGRw1+CyVsvtvpP8HO2jH6e+3oas+mYASosMYCFwKpvjH9aTtodf1xcIOlD7+AFVkNqc4dzwQ23U9L7WxP4S9TWnGOlYoTpaZKNPikzvcozr0b3Lu1sKBD7A81tAW5luORj4xu+uZ9PnhUTm5Fc46SZLgfMgmcnFuYTqFMGRHp4n3zeb1YRWSVR3teBxw2eNr104FHPHhrgdRhMnHjiW3pPTJ0uz5ic+ZMf5ABqhDfFCoJljOjKcu3xrawZQ+LYKCNmwnjgg48pTq3ijpH8MJwqJ5fvyNy2tBVFfDTX3PN+JsJxG84q7mAvP/XnFDacud1g4GA006yj3aZlQLPvHD7J59dDZUf2lKAUlIWpp/5ZG4qA8zUvn+ERSZHvT0xKjzoxQ7boqj2b3ID9OZ2+9To2jY8Ca96Z84nw9LKIYXHqWfzm4Ovvm+ug134+0avFWwvb+g3ZhKE+udkz0Dl/kMS7XVebeyCrVwzK39wgQnP5ITJ8kKPYqqp4oea3319rxUXn9rHUypxJJDeCDH2v6uVcidEaOCHFZpUxBTys3N/m1Fvr4aD27BaZ3Iy1XGb0eq9BrOxHKb3LNxHJN54xUB6BTkHllrUFddJ9kgPyriy6IvHww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(8676002)(66476007)(86362001)(316002)(66556008)(6916009)(508600001)(6486002)(6512007)(6506007)(186003)(1076003)(26005)(2616005)(38100700002)(5660300002)(33656002)(8936002)(36756003)(4744005)(2906002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?A7KJelQ9J3YkPI93/HqA5TfxKlGnmdCxapFSPNA/KY2fn9Eu8A/fGlkNYk1v?=
 =?us-ascii?Q?bgfkSx4apD7S/IpRmCzxnaQZRehYMjXf44yL7/kK9HGMsoktG1l4nVQAKpcX?=
 =?us-ascii?Q?au15YbcD/IaHZ/FSlr7V3toBf4Oi5tk23D94WsuTmJ84CUwlADvoVmP80QVB?=
 =?us-ascii?Q?zIokbAvHJ6Fm+QJHjpgCL5nKtk0QPSvD8ma7LjalJ2r4VIGKblkqPwwgxj+j?=
 =?us-ascii?Q?1FUzWe2i7MMSu7GxxLmjnmaxPuOWJITX5qZ+3r+Vy8IQMjJXIhv8WKY1DXuE?=
 =?us-ascii?Q?GpNJVs6N1mVECYu5xaUvzVsGLpzHmHH3mznN/uBicEWRHySj7H+O2UCjKYwR?=
 =?us-ascii?Q?kxdrctxnUvtm2cYZJoUgiMp3yI499NNm39ugHlwj5x89DjdcQhirFPgChcQs?=
 =?us-ascii?Q?ilj6Vv6HXHBfpTOmXOPDn0KhTVxUkMhI0+ZcdXiwJOpafC0WNpWTkxbelwQD?=
 =?us-ascii?Q?xFDTvDs1duxX3q0miuem1CC6F0pNy8Pifu8KPJ97cdWC0RbSkVa3Flrwrc76?=
 =?us-ascii?Q?X3a/q/iHBSOim2aWoSmQ+O1rloCRoHrYAwyraj/KvSRKqno8y8N8LxAKcN4M?=
 =?us-ascii?Q?dKJFeOw6ThzlsDHwjvDUWWgk7TxZ160X0p0V3r5ejP6Q8BY6Rnxb/6T+rF9N?=
 =?us-ascii?Q?j4T890wXuvtrGKWGzIxfDNWe8ns1fy9Kl2Sab/2HajNflvhJ4qFilEgcqyQU?=
 =?us-ascii?Q?9FOEZ3MSb43A/wzyXloxvTW3Kf4THvw2bP+rVEGH0ZiWGRjRAsqQgOAkG0QF?=
 =?us-ascii?Q?Hhqy4anl330IZHzsut5U9SqScIFQTx8Y2JV/0dJdHichLmM4bgtrXVnN9wa7?=
 =?us-ascii?Q?GYz+Bu2Mader+StTp4VwGYnpmbaR0xZLsHw3F5QXx+bOjgJQVhZrQm7FYrJt?=
 =?us-ascii?Q?lFwqOuJQ1A29j1lO9JC9oj61TgWIOiCA5QSPDC9Dr5Jrd6jVWNdXKUtIZUWo?=
 =?us-ascii?Q?zungvoDcgZ9fhhyJ09v18ttA+zbLDg/Rut1B0s2wo6q9r7lzQkH2KeGE56al?=
 =?us-ascii?Q?d0G95CF+a3mS9ebuJJKMGDb/CIbNCMqspf7of5/c/7nHkoZSSgrNmm2NCFV/?=
 =?us-ascii?Q?JELxTh+rQfkJMGOu0OvnUVuXhZV9uwTf9nmyRLoWibvL8NL3CA3KowJu4gKD?=
 =?us-ascii?Q?28mtZUIZZXN94jsM/5TRLNq/SxQdFIWNEuv5wmjnWGdP1aqMLAYVZjcqNcvI?=
 =?us-ascii?Q?HHwXjkSE8NABlCb4sx65R1kzbgf2Wjhegs8X3DE2v55MEbBTVOwc/8NGlckM?=
 =?us-ascii?Q?wcVd44y7FWDXK2tjJX4chqY63Cu4JZeiUCRNnfuBHCgElGhOVqNLWNUlBsOH?=
 =?us-ascii?Q?oSo7aesTOeZm+E7/0OYdVuRmUXv7kuNgGG1J92Rj/juumzPibva+O82xVOiU?=
 =?us-ascii?Q?t4mi6UxB6qDz/HTbFJC2elyfmmhL8d3jk7V46DHXa3tIH19+sfFzmFLJUyk4?=
 =?us-ascii?Q?OEx+kbyzgXbWDD5fTPAL3YVPk+Q185g2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b5a1efc-72c0-4487-97fe-08da084e24ed
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2022 19:41:35.1512
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mJCHGRsxepuEIhiixIBbhuNjxShQ03B0q06Yo0Cu2WZ3kxnxQmTqA6Ulo2SKEo8N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 15, 2022 at 10:22:00AM -0600, Alex Williamson wrote:
> On Tue, 15 Mar 2022 12:53:04 -0300

> > I agree we should not use the vendor name
> > 
> > In general I wonder if this is a bit too specific to PCI, really this
> > is just review criteria for any driver making a struct vfio_device_ops
> > implementation, and we have some specific guidance for migration here
> > as well.
> > 
> > Like if IBM makes s390 migration drivers all of this applies just as
> > well even though they are not PCI.
> 
> Are you volunteering to be a reviewer under drivers/vfio/?  Careful,
> I'll add you ;)

Haha, sure you can do that if it helps

We still have a quite a ways to go before all the iommu features are
exposed and we get dirty tracking done.

Thanks,
Jason
