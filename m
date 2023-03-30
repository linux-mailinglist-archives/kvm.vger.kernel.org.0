Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AD96D13B1
	for <lists+kvm@lfdr.de>; Fri, 31 Mar 2023 01:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbjC3XuN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Mar 2023 19:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231915AbjC3Xtw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Mar 2023 19:49:52 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2042.outbound.protection.outlook.com [40.107.223.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD98D51E;
        Thu, 30 Mar 2023 16:49:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tn87OFhE5vs+jro7sfb8ZV9SgTCq7ebPsmAeo3nStCSVqHt1UykZVehEP9YtoFOkJd6Lbs255VjG9IhmhBQtXh5PX2nORNZ/j5wZkceyfd50wIutqRnUQJwgDxYoqWGBj5bKDEmWz9t9BDBNhoG4wEgmFe5i3sLjR9OUnKJp4aYh/qBq7hpdT6WBiuYfkWFwGZTJw5rGP5qT648agQK5rnpyqWyMQRaQXLXv8hG0TbUJF6FlAC9P7SSWtOMa3IFN+zl+NJEHN5HnERYdmgCldUIxq1gpuqsrHJl9XLvT45hH8kgF6kEjFveR5n6/xDo3ZRg+L8tlcCrFfZ5hbdvkSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3G5JEdv/qHuTSwc2alZDF1Jvxw8es0nhKNOXCD9Gum0=;
 b=lacYkGVSgp0XGiTpAOzhw20QQSVKZlhZ5+kl4MTsT04uCPn0/7VI9Dl3+weXr5Qroe64ZM8j+cyt64/un/lp0yxjrL80GSdwcCeYXjwXQMnX1Y4fZJghCnLlm6qjh1VqV9yjFhRshSs2hZs/ASICOvw2pER5cd3rEMMsYgCyj8ngKA1KDYh6Jb64CqQhwPxY5IdLg5DcmISYhxZMfGJMkR/Ht4XpfFIxbwQUNYt7zaZHWLioJ8Gj2n00kMSEblYYmZXt+WT47xNXnrxbZs5xTMAcNuZlo0ABiHCjey5vxwWQ6WJ4800FGF05Wl4wcqDnUUFZGw7tcRnNLORdOL6SeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3G5JEdv/qHuTSwc2alZDF1Jvxw8es0nhKNOXCD9Gum0=;
 b=Zp23wEUzZpiKcorU4jsXU3JXT4H0dkFyuPQ2cAmwewjqTVp7Urf1TA2lZtUc8iDA2KFZFaQNlhlrXP1L3U17r/WPpAJD5BaDVINNjddnIup2NeZ2iFcmwTVB3g4woE6kp+SeMfy2BNlTEFbDfgMKKmYL+LmQWiDiKuylQfoaiODM23MvV7HhnrzQ1F3p64XYbDir/goWX7bJJIyXSARAd66iPnDlGb34CX8G6qY3SP3Non8qSgi8JoFg5EAALw/41/DK5ifV5qK9D++KWPTO8QkBb7Lte54BiGPSSpboG/VT5u1G61yAC94xvpd5heKJja3OI2pGKjBHiGxCrxmh0w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by MW4PR12MB5641.namprd12.prod.outlook.com (2603:10b6:303:186::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.33; Thu, 30 Mar
 2023 23:49:07 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::ef6d:fdf6:352f:efd1%3]) with mapi id 15.20.6178.037; Thu, 30 Mar 2023
 23:49:07 +0000
Date:   Thu, 30 Mar 2023 20:49:05 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yi Liu <yi.l.liu@intel.com>
Cc:     alex.williamson@redhat.com, kevin.tian@intel.com, joro@8bytes.org,
        robin.murphy@arm.com, cohuck@redhat.com, eric.auger@redhat.com,
        nicolinc@nvidia.com, kvm@vger.kernel.org, mjrosato@linux.ibm.com,
        chao.p.peng@linux.intel.com, yi.y.sun@linux.intel.com,
        peterx@redhat.com, jasowang@redhat.com,
        shameerali.kolothum.thodi@huawei.com, lulu@redhat.com,
        suravee.suthikulpanit@amd.com, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-s390@vger.kernel.org,
        xudong.hao@intel.com, yan.y.zhao@intel.com, terrence.xu@intel.com,
        yanting.jiang@intel.com
Subject: Re: [PATCH v2 07/10] vfio: Accpet device file from vfio PCI hot
 reset path
Message-ID: <ZCYf8Q/oe8LYbh5W@nvidia.com>
References: <20230327093458.44939-1-yi.l.liu@intel.com>
 <20230327093458.44939-8-yi.l.liu@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327093458.44939-8-yi.l.liu@intel.com>
X-ClientProxiedBy: MN2PR19CA0036.namprd19.prod.outlook.com
 (2603:10b6:208:178::49) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|MW4PR12MB5641:EE_
X-MS-Office365-Filtering-Correlation-Id: 3a73a5d6-b5df-4eb0-c448-08db317959a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2m5gkrjbQAQrRyz5uM4wBOSbfaP2tToqfykGgHvJitQ0/t2bdzOm+LUavti/pDXrqxoceSLUMG7jyqZj2VzTQ46jitznUgSyCl/r84Y18QvEAyi6P0CAdqro6wvCw/Lva4X9NUUmd68V+fcJrrjY0qx2Z7oiKCp6/GzFN8B6KSGsZK8CZxLdw94LbD9MI9iF6GTfz3r4UKsXyJtHtnpob7Crpa7l9XwMO42ZtV5FbIkX8G2A+aB5HHp3BBdK3tXbYi5sU14pR9usAalt4blZQ/3/skBmgxO6+TtR6leIXelxx6lTFNpRvyvGKq7AQ1MEjlqJquYqxCaTQ4TVLXLTbriTtp1L648zmPSVHZsLCsy9D3kLxlt5vj8AOtUhVbCYTAfpiI6C1rotueU5sxJKJdGSCdBhfdFg05N72v7Wue+3OOVJ5tdrrNq23bj8EXy8nlJ7FFe3tAyphOlnP056MLImqkRv6ZcsfUYPmw0g9MTYBeMcLtJKvrDM78QcLkGVmkCNfJfnQbuCGNg1wrPH/szp+iDF+kLRCOcudmm/kJ3bF1am6zbFFCb8iGr0Tf0Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(451199021)(36756003)(186003)(6506007)(6512007)(26005)(41300700001)(7416002)(5660300002)(4744005)(8936002)(4326008)(38100700002)(66476007)(6486002)(316002)(478600001)(66946007)(8676002)(6916009)(66556008)(86362001)(2616005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QW4resp0ykk3YuXYIydRruX0/7KHMrJk94tpunEAQDoTugb4Vs077Ycj1Ceo?=
 =?us-ascii?Q?IUL4Fe6TVqWGxBrtM/ic932tRRWYGcT0FCWwCBr+SaIkXRZCPdbSoMg71Mgo?=
 =?us-ascii?Q?GZrqoFn0n8r///NG70XeGprentq1Vrw0PmIyh5l/2oKDQcRlYlg7E8Hy7obv?=
 =?us-ascii?Q?+HM8AczlA3WTBLEzmOq8tlxlUmQkojYkEdk1Ti8X5mHlVbzl5HNjjUasAFUT?=
 =?us-ascii?Q?C2Uv2HN8XyZKO3VyolJcY1xoqy06LAtEDmALvVUReD52mGnIDBngu5yo5cxP?=
 =?us-ascii?Q?5HYEx7g0HlM6sXR0s012/4KW0i5Ud9J2pn8bcMTZAqZXhWGL4HSnjZVMdnOA?=
 =?us-ascii?Q?U+j1KYLH3W16+rsIVwzWFz2voxXLeqXLiWoqKZzbt/fUORo1FMqxeIWzagjn?=
 =?us-ascii?Q?qxZrvQ35chNMlrSJkGxek9uJPf+vP2wyhdR9auhhL+Ai6ypMYmqvEINYJGP7?=
 =?us-ascii?Q?vcmOsBEU+1hCE7FXT6e/3vy4SAl4xTFPLdPYQY7u6ZSFCA/fntZ1jI6IF9sF?=
 =?us-ascii?Q?6UFz3mKiux6nh5T+Wrmigp6XsdX+b/dNENXgBvtSPhgoMC7LE/zvB0jQW8Vo?=
 =?us-ascii?Q?Q6O/hlV4iaDoAXj8Apgc9YK5cV6XeIy9oN9IZgKirr0D6zOmC9hGFIkFqf77?=
 =?us-ascii?Q?BovtxoHCrHKyidfPVMYnj441RStXYm38aPc8L0Qqvw9FNlHVd9V/zmCMGyLN?=
 =?us-ascii?Q?vwp5LNhnz+vvif13NYnqU6UPi0XVFUp3XKCQ+j8THPQGwZbObtwx7tK+ke9f?=
 =?us-ascii?Q?5tl3O6Mq7UmUChPR44sQji0cZiFB4p8vYI499U3zqjQ0ue1efVk1QBtBTULJ?=
 =?us-ascii?Q?aURN4A0nJo/2lurrhDXra20o2F1gHUi3QRfWwiLCoqXXx5npurC/cezDsAwq?=
 =?us-ascii?Q?nXMOjOziC9+baOk6xifA15QigV0MBaUdNLO/hxUw15Ma7nuL8qIlqmELYHuR?=
 =?us-ascii?Q?YomECnH3+KZv5kKauEJ96gT4Zw7PG0vhzRVuuUNYt1xYdltUq5od9sdAHnHE?=
 =?us-ascii?Q?Yp7ChrOiIsf+NY0yQz0VIuwZ1Af2UBIxmc9JWQqOe2vr+9/qzHWsaK4MYft/?=
 =?us-ascii?Q?wsli9W0lfpgVABhJXXtLn9T6BU1kLG3YXfGC2krAmbNza3roeOvq0V0aUkSO?=
 =?us-ascii?Q?8K2YfFvMOVXGFfGDBZ7uDK97goBsVdcjDNs0T8G3QEXGzAZ+QI6vf9mL+e57?=
 =?us-ascii?Q?dVljDiXbabhjYS09hcVG0U78rZK91t/pGfN1Ber/D/eY2e3sEoXa/bUH1q4N?=
 =?us-ascii?Q?etbKrGL2U2IAUf6ofHXwD3j+OBbYvEWxlbpIb9nmrb2toEBMnobK12V75QOD?=
 =?us-ascii?Q?6ehBztrBhfTfUWkav3T2z7piQdX3xZqMcfUS2mLnQSvBNM4poXN0UpjFJBMO?=
 =?us-ascii?Q?79zB5cGj4d2CRZYe2eP/gcN7LMoPpki7zcIxOdiQ7YMcP7dFXHBdF16PPqvC?=
 =?us-ascii?Q?aqyOlL89rh8WDEcZsGsIRQ4/Axll7zI4vmIXcEQhrYDh7IhY5bgWkZ31934u?=
 =?us-ascii?Q?6fsg2x/zQFyRFVKaiATse/j2QN2fvEDNlQDgB3kPYtccrK1elIPULYg4dabo?=
 =?us-ascii?Q?Usjlo9WOAobhlmD6igYqNg5gs7aFn6qf4RCw2TCz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a73a5d6-b5df-4eb0-c448-08db317959a7
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:49:06.9278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1Tkq1Ot6O6AFoNNEWKMAAsoOd9XrpUNAiQby561q2ipBFwNYD4jnIZz54qOM5uJp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB5641
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 27, 2023 at 02:34:55AM -0700, Yi Liu wrote:
> This extends both vfio_file_is_valid() and vfio_file_has_dev() to accept
> device file from the vfio PCI hot reset.
> 
> Reviewed-by: Kevin Tian <kevin.tian@intel.com>
> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> ---
>  drivers/vfio/vfio_main.c | 23 +++++++++++++++++++----
>  1 file changed, 19 insertions(+), 4 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
