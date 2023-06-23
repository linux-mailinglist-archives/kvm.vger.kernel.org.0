Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7306173BD2C
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 18:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbjFWQvG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 12:51:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232576AbjFWQuu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 12:50:50 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2047.outbound.protection.outlook.com [40.107.237.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4992D5B;
        Fri, 23 Jun 2023 09:49:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiAQLzzDbaNfIn3u7SjzCkiB3TseBaXAVct7v/hNqsUb3ZjJJIqsTLYGUk4lUXwtdOI/nF4GnpyiicgmFqNxHOAbiHKRk+nE1cWhjWiRo6vx1Z29uiSaSTlwQTI6WtCvxeV6pX5XriKSH4aToKpqJlUi/mBaoHxuiS9Rh5qVDVerM65qMdVGPOJuxqzBtDicXVsHAJ65Reld3yQWX3rqR1hcOq1r4tcu+K/l4XXMByKPLYq7bIH31xcAyywoLrZqM6+bvvZYQnEXupi4g6PGcIBixlQ4rKlraDkqUxIvIeLjlCVuABNKo8LuzRSMjIi/AZpW3oRNVECcVGPc/AbMBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ou9d1DBUZqiY4jzQdw/UMbOTDBETljbxIVenyrL3j7s=;
 b=XZqVBJIttrDVv9owGqscZiEYakWt6BBqLWRsjsTuBlwjb1PI6mhSRd+EYCNmy/P2ELI+S4L9hDAPjHx8Dd60MZzjOqv4iXSyv90i7GSGhMrtHKCFwIrQMrcZ+JUnoHzNuVhKlC9nXkEeQw1alCX0a1tniVIA4UQPRpwspMBvu73gIQ9UZaDwtPqIqPO9VNmZQCdlF8fXCQ/vdc+jZSdF9Dq/PVPwetGPT2g28mmTUmxwN484CPTpadjeUtxc4uqjNqaxQ/PAP5dKoksh5eD8ent+CgAoJT27EAbyjqYE0MIdeFmjrFDf6KMkf9nAP3o5i7pGhrifyWoyOl35Y+duSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ou9d1DBUZqiY4jzQdw/UMbOTDBETljbxIVenyrL3j7s=;
 b=gZvErHkqbOjWql4lQ2My1sE6wSKvmzjJL0r3OTe3m4M1IXwXCfFArO1uDm9hcJYdt4lXT/Zagw7ZSo7AzlyR3dftV1hlO6EFnRd1csT1jvN6c7cYbhvANnutHFy7qLLPgjl1RAImlLHUOj6+i8ZmrZXbw7mZL8kXa4ayZl1vIoJzA3S+DLwMDjiV+l5NH/n3Hoyy28+FE7Q2Ki+qIRIGGX6PcX5YGjrjwJuwFIQk5issleVTntC6ocppa0gYlHqL0zebK2L0YpeM6WW8QnpBF5uND3C/SUoUpyVKeTnv7Ud/hBbB2XOc30xzhuGHF+/NYocdmFvwXzXaRhUA2tjbWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DS0PR12MB7584.namprd12.prod.outlook.com (2603:10b6:8:13b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Fri, 23 Jun
 2023 16:49:38 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%7]) with mapi id 15.20.6521.024; Fri, 23 Jun 2023
 16:49:38 +0000
Date:   Fri, 23 Jun 2023 13:49:37 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     Kevin Tian <kevin.tian@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Nicolin Chen <nicolinc@nvidia.com>, iommu@lists.linux.dev,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iommu/vt-d: Remove rmrr check in domain attaching
 device path
Message-ID: <ZJXNIYJnpA5VfoF4@nvidia.com>
References: <20230607035145.343698-1-baolu.lu@linux.intel.com>
 <20230607035145.343698-3-baolu.lu@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607035145.343698-3-baolu.lu@linux.intel.com>
X-ClientProxiedBy: YT1P288CA0003.CANP288.PROD.OUTLOOK.COM (2603:10b6:b01::16)
 To LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DS0PR12MB7584:EE_
X-MS-Office365-Filtering-Correlation-Id: 1aa428b6-6ed9-436d-6df4-08db7409d533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AdyvQkeyQ1rWOAr0LbP5Si7uWLj06uVo47np4nvRCDPQc5u2OBJBhsyb5AjbbMfO4RAmUJscsRfTLH3LT53RawWLGYYyOOgmgkuDHmozQjoG1h2TUERssWv2U27NduprQKOaAmiKpd5dUQNswTQfy8XRMWEMRNtqoKhljME+6gk4fB0vu4UwzauoQPwKKWJ26K9EC0WlrPg2njSUjjWeeyxlnkdnDa+WWmCazbbFntooM4aIZe0tlMJago1P36RpY8dLHBCpcaWq479By1a6QHpHZLSWC7X7LmPatGHfskFUok0Y0gNQiIea2z9ZigZhWK27HoV3E6OrQyA/6DubK5yh1ByRvOG4G53ix1Qu1mWZ7cAW6B1wHnrbB6GDV0T766Rr9LJtUKaPg7dQ9YGkkC/KaTtOKqxGCTfQvDegXrrCcPOuF6Mm+Bmj1uHxsTzIRRc1hjHh4QWIAjKrgtLaZTShmtijvRqT7uIKmcclQRWqmBWOVSy665a60XHzwyKSLO3keOdJbnCxmNyJaahilhEh+YGYMetmtP3DYhx/EubHoae5iz4CCCwN0s31XvJ2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(451199021)(5660300002)(2906002)(4744005)(38100700002)(86362001)(36756003)(478600001)(54906003)(6486002)(316002)(8676002)(41300700001)(8936002)(66946007)(66556008)(66476007)(6916009)(4326008)(6512007)(186003)(26005)(6506007)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vtXFLfDBckr80T7R3L7l8XPtLx+DPo7rTyv+revp/Pg8xGPgvuU6ofjUrFEi?=
 =?us-ascii?Q?sRmcuz8NGLLrKFrK1L1bC+Ov6ceyUvydsIq85Lg2N/fG05BmD+ZX9VRAZIO4?=
 =?us-ascii?Q?YzGPQHn+OQhw3vDNLLXEUFJpRSpsQCihfTVeUyuLcEkZj7SURL7beD2NHGdl?=
 =?us-ascii?Q?yChTHB8w4VdZojMT0drqVSnJWlJAyVwk63Vo028GcgBIdIiPwtGxDtcDra/R?=
 =?us-ascii?Q?iFYrWK9s8QWtKAFXem/zKIcEC08P3kHaW6cZNdMiQvwEg/yn4IkRIFceSt/5?=
 =?us-ascii?Q?Kn6ghylN7ZDF5j8qVd+iW4rgZ+H+GXqB9VeWHsawB/NYyIOIR0Ws05E6jSFh?=
 =?us-ascii?Q?hlYzNe+bsQpp8L3MDHVsgJW2WgSuYJ404kB4/tNOuY/Qd4BiCSOFIisWop3z?=
 =?us-ascii?Q?i+Aynrfm8gK9YpP+rubMNo7UnoWOdQ2LhRhcki+uEYLAa3WeKQHlIvM/0f2E?=
 =?us-ascii?Q?wz0gLzLlJQVX63LNVdLBP0ehxvkjjILWaXO/hdpwZe0yRYX5sbHczqxZRiyR?=
 =?us-ascii?Q?A4ydYZ7lAlXlO1OWo8Sj6//FE7xPzM513Cac/IetdFytvtgxMC3wovQnHlhf?=
 =?us-ascii?Q?Vx2GnwrA7FJ/9aHXioL6uMYgGFzdBYzH/OvzAw0jDxuy414qqCMwwAHen/nv?=
 =?us-ascii?Q?XwkaVS9Xvdgai6WdGdgKAwy2cm60kl27ln9PoJTFUPg3pQIvIPFuS6nJbRWH?=
 =?us-ascii?Q?cScLa8gPfspIgVdCarDbqTrlxpqPOwwB4tpkmxdabSJVeic4PHHcgk+7G85f?=
 =?us-ascii?Q?oSbdWQT9k1p0AKHbqU2e7y7sfe+1KYRMMZOYdYZGWwmjZb+jJLxt5GHtBcbg?=
 =?us-ascii?Q?+u0OUo0iMSpYi/hZ7tNXUUKrUXANNwvbl3OpTGR6RbFUVt1hQFDkrdKkwDMI?=
 =?us-ascii?Q?B5YgB5r+4lWBF9AKACUUkDwcTEixPx8t2RT6yHse8r9VvehsvgJQmjmPQGhN?=
 =?us-ascii?Q?fxR+T3KbCu4iLPqXa3Mos0vPICszx+evUn+J+6FuLKIPd8zAyvz8b6IsH51B?=
 =?us-ascii?Q?r4vrTLzgdtbhh+1i2kHJdK0FanIG6k9CP+oNSbDrO0M9K4NMrmLfOj47F/iv?=
 =?us-ascii?Q?KYjMBm2wpfZbVckx9psZdvRQZXikey2X2qztQFAtgxPcKqPqU1wL6gQw+xy4?=
 =?us-ascii?Q?JYZdcr5z8oHbFCS7jRgUnofxBFxpqqNpI1EstHBMSI6lPuGWxFLBi9KZesWt?=
 =?us-ascii?Q?va8UuAep9VmCQuyDWuG8r1CGfy2niayF+LC8dqGQy6PTc7y/T0Hssrxulnzt?=
 =?us-ascii?Q?jWM7QKDsQgONtQqBKTgArvjsj0Pu34H5EpY9t+eR5kCSuezcMIxVVQLv4G/1?=
 =?us-ascii?Q?1cLWyHDfUFtdjD7rfHvueXvrvNp23lyPHLukm0nn5GofKBTYkEAfw4Yc5h4P?=
 =?us-ascii?Q?jdfmbelBgNoALYw5bjiYHBTjWYdPMxO9ZGUVr8Ej0WWcNl5OqttfirlqPrKM?=
 =?us-ascii?Q?HWy1NWvLxITWSbeyg1DeZ9e9xlBeKpuv+fLGQUa2qJDfusuSWbXhzu2KrdFY?=
 =?us-ascii?Q?iAGV3B94plooGxerk/jSEWCt20rarPk41aNWKHKOhbdaQEYvksvhvSyduELG?=
 =?us-ascii?Q?W5Wo2IECbWyLCfumjsyyM1ED/d6+9MqOFM8LKum6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aa428b6-6ed9-436d-6df4-08db7409d533
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2023 16:49:38.5122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wf/hgTnYZwtymyBh8pJ8fDgUQ1a1ErzmfpjkrDcHyyXgPOgjY7ZEnM7bAJ3HtA3b
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7584
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 07, 2023 at 11:51:45AM +0800, Lu Baolu wrote:
> The core code now prevents devices with RMRR regions from being assigned
> to user space. There is no need to check for this condition in individual
> drivers. Remove it to avoid duplicate code.
> 
> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
> ---
>  drivers/iommu/intel/iommu.c | 58 -------------------------------------
>  1 file changed, 58 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

I'm happy to see this leave drive code!

Jason
