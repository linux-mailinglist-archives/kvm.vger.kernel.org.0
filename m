Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342E7663636
	for <lists+kvm@lfdr.de>; Tue, 10 Jan 2023 01:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234359AbjAJA3q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 19:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbjAJA3o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 19:29:44 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2072.outbound.protection.outlook.com [40.107.220.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B3443E0CB
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 16:29:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jgV9Jk/bYrF0MR/XnRR4BsGjXlWinByizGwXBe6kXIQdjHSFt38oWAvcnqACrcZglywKxi00FLb3LDeoSja7tbSbxNKRz803N5M1hEKDK7ffjXBBZLa6ey0Hh8udsDCKVJtANS5RzovKh+PpiHDObEs51Ctwl6JPFNMV3NxHlYnKtadXwks8YYRUbnmzdlHWd0AnQWgLHyr3wxfabwcVZ2WyQKdzuIfLP3ZdJFEPJxQamqWn8hs2fKcinBvvJCMhSXI1wTfYbYNxPv95cwJgrKX+gqplgT9B80fIcwBeF3TZ4Vma/ltSnDgixhtfagKCc/SON868kmEDqKNg/mlY0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R5SWzlYl4kw416YpdxlVmyGyVkuETe2c1I39D7OQiP8=;
 b=lYO8YmJIzhDKis4jdzpS9jGPuK3XcppNp96FuHGtpnMFk+TGF+BtHA4PlpxdkQ3/crxPS+HzWJrdZVZ91jnG/v+mIVIP/5o7PhpWFpGabwj7UiN0hKkYaEoO7LUFUnvoo3meSV6LWU2r+id23EWIIHaaNJgcIzBvTzS3TRFlvOH2CGmoaruKoBAqc61NJRKfS6V3HLMd1ty1TnCQeYjRy2UAaRt6C6rDOxdzCg9p91kuU+xQCzO8gCpcO2s53d/rHhQNFZJW/bWEU198T7ybLKyda2mXDGPNQujQ+E3ijVU91d7sKmN1a9NPsCE4gbKnMtttc9oJ3rmu9nKZJE0Qww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R5SWzlYl4kw416YpdxlVmyGyVkuETe2c1I39D7OQiP8=;
 b=jToDrbwIlNFLBKP5rnBs4Qc7w1LhqoqY4m6jdY3JnWYXXy0XkOBcuaKZCGGOMwh3T1Td7qVwPAvSV7FqJUSvxp3v7I+/hap8Zhp76p2EI72EyP6SsiwuLfoDeSsDydfJ2sGOvfwtdc7/uix0LvA0i3VttVb4bEKeGBRS8zCZ9KRW23LF/9FFrckaTWs9SnrY9GLTezYMXGuYuO8G+KGoZT0xRMN/kSWiFv/5//zB+GldFLdewvHI8+9PWfQww642YFDNIp3QyS1QXiTHPoPEcZsdEJuzl6Px+M90doQEJivJBY3GbymGgQ/U82TlxrfHQsDNcmQNNyAPmcNjEq3iXg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by DM8PR12MB5480.namprd12.prod.outlook.com (2603:10b6:8:24::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 00:29:42 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f8b0:df13:5f8d:12a%8]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 00:29:41 +0000
Date:   Mon, 9 Jan 2023 20:29:40 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, iommu@lists.linux.dev,
        Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
        Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH] vfio: Support VFIO_NOIOMMU with iommufd
Message-ID: <Y7yxdCleyk3wpRm5@nvidia.com>
References: <0-v1-5cde901db21d+661fe-iommufd_noiommu_jgg@nvidia.com>
 <20230109163434.6311b4a6.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109163434.6311b4a6.alex.williamson@redhat.com>
X-ClientProxiedBy: MN2PR19CA0033.namprd19.prod.outlook.com
 (2603:10b6:208:178::46) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|DM8PR12MB5480:EE_
X-MS-Office365-Filtering-Correlation-Id: f1088a4e-dfef-4e0d-0364-08daf2a1c3c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TJAFAY4WSD4ls/vkYQj51D2szZ5Ot9wXJP3E5sq8ei7H91u5/+vkVHrCRjR733bI14i47ztvPHjsqAlZbWAf5VQvtvRW0sg91eBsQsuRPsXImoJmLOo1CtJaHigBOY1kqYn9TNIfBi24ui/ZtvnRIq1B4Ta2idB3Imc2oZXp3bCmu9IHc1n2olAlWyrN9ae8co6s6Ez5jrkq3E10Svmp+Og4cTIvhr9hCMJLy5NK0/c/IIoypiCEAAmQd9dStJVPdofjSgy5ON8d4Gja+CQaGxX3herpzzG7cr8bat75YTMvnEnDqFcjRJWAIZnr4h60EWReB02SJu3hqon/0Ylv2iH/WlA/Z/pQ36mYP5eFqJ/tE6JoLgj5XhGNZvVboq+Huk9AbIMsagtlxjK2RZkocRa2lZKJ6+V0lLawsaoDNZQeT63R3DxqNlfBQ5FyCdOgTaoCjK8lMpzezVnM7VpRBYTHS7ONmUqZf9hoCxbNymkPrxK5sTmsPdyr7Qg7nD54iZ4Kd40WwSPiEuQT0gx8fCGbV8Jjr7oqmudmcqMKdHge46ktL33P1DkT8wC2/LbLnp1EhZwL/mkLz0P2wgH1bSth8KRQo9CmdFiKPsMqEcgZZcD8Sk3y9uYaCMJzn75z4+YaD9NS200HgsYvNWjj0A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(346002)(136003)(366004)(451199015)(83380400001)(2906002)(54906003)(2616005)(66476007)(66556008)(5660300002)(66946007)(26005)(186003)(36756003)(8936002)(6506007)(6512007)(478600001)(38100700002)(8676002)(41300700001)(6486002)(86362001)(4326008)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?BiGTZmTJzwL5EkMe0UWY8/a3NpRkZLsFECOS1KoNGNA60MX/5utJXHFokBnX?=
 =?us-ascii?Q?gKrDHz0BKYX0pspQABgWaLmGykEJE1MQvYgNe/xh9yAqb0VyYqT7kRx+Z7Vn?=
 =?us-ascii?Q?+BVWblr1VAN7pzXVNugQ3Cpvks4CkTRVTMVNsfntr3b/P1hEK10IyT2CpLM3?=
 =?us-ascii?Q?evweSKgm+YjBzj3DUTkyFUtkMUWYHWH0cJidkdnb0TtnFlZOqJ7TnDnFKRui?=
 =?us-ascii?Q?m9dtFoBi2j2qLEh4byodhU3Ku6t2jeks7G1gKApISs3h3/xXsh2BrpS5FSaX?=
 =?us-ascii?Q?+FZcdwzpxKr3CW/xFuBQwY6vIHomQO05VKGfPO5DgJ+uFDcIoUE/wO/B9cDy?=
 =?us-ascii?Q?Aj1HZSuXZ8TGzumYli0jQc7VfkdtHPq3BDdWAuOyMkYWbPdz7Ecu1uYxgu+4?=
 =?us-ascii?Q?zm+/5HHtRjl6NLn1KLcE70MVoqu4zTC6wstEAr/aKwpvVKdSdLs27FbJP5YV?=
 =?us-ascii?Q?PBNrYQgY2QpDBxzC1hebiQ2xrL7g1eVV3uOQwtPmdeMSgcZGgbsDG4leIQ5M?=
 =?us-ascii?Q?jkAW7YNcvQLNe7GYV/BGjlBN79BXQN6BxXnAQ/uLTD8aH+cpn10wxKSMfOV0?=
 =?us-ascii?Q?qM5yGUTJFnQpda/DMoia6K04+GVIXrBmbErC/4M+Rozn6SkafVuRGqpVUkOr?=
 =?us-ascii?Q?a2EM0iqyM1am/voRTQhxkcbjHFyBSim9k3QCSNXh125EwF8I4f1whu3AQQEm?=
 =?us-ascii?Q?AMfjhN6xih9AVom7YMM09R18U+RTssHocHtCMpUVTQQDbjUaCdEFfoL1hftz?=
 =?us-ascii?Q?v09XALXqNrnCKbnBcdipW6cUJHgT2Fk49JK/PLN4vExfyZKWKcp9zhBW/HJp?=
 =?us-ascii?Q?yJp+fup51zrbzi1+QTrvY+Jez6Y/xvOdpnEq+V97AcVX1MExSHZK2Gr78jKP?=
 =?us-ascii?Q?CJVZNyderrwFCB6zENttHOm9MdGQsnPbzYzpbqZCDJFzVyrrWF98NRGT3fWe?=
 =?us-ascii?Q?PwJ6rP+AwZKOozjpiIDPVXttq96uYwM0PqU2AZKv8ptAIQNF0zt+Qz/uFnIh?=
 =?us-ascii?Q?iddSHiGaNcvZ8RYM3ucglnV9F3P2hSnNFVb/vEb+O9nKGxjdeYikfOwjnHRL?=
 =?us-ascii?Q?ejCCL6HVJf9/a+5qu3vnLO72rPr+f9Ol2bPBsccT4ddYpjkuQjjHd2TNzROs?=
 =?us-ascii?Q?qW+XMKQyhfow+ANt3XlXqOoDfsqlNfSmdsH9cC5Ib0jofM60Hnxfs0/8h/+A?=
 =?us-ascii?Q?W1pyxsFWUlCOBSmcfY2u2F7l59PgMi6PlNJFxZLl6H0RSeKu7oUQaq/A8Izz?=
 =?us-ascii?Q?zEjG/jKGyXu3XOGDoO2S/3UDLrerxl24yW0DTnGtddoCKkYOvXW/Tnz86VYU?=
 =?us-ascii?Q?zpvfqSkASlBR29i4hHaCXEAz5kaQ4/5uop62y37LQL/0APxx/jKXUW1KjUXv?=
 =?us-ascii?Q?XTXW6tzKvfMd+cJu64OaKf4n0mCLrUcZX2Nnyzefoot4qD1t9rrimCX1u7ps?=
 =?us-ascii?Q?XwQi1p7AiOZJPEqJ7jULp2oSIHLDPSYfPVdiNzBpGO2Ehy4D/qGXSOLIXYl+?=
 =?us-ascii?Q?pmyhF3wFjdGxsiu2Wx2KxNP8oNNbZbMTTPJZCmGhtR8RhZcr4kYGkXlHr8P6?=
 =?us-ascii?Q?V8BZRwV6wJI6f/pPU6EPs3sOGc9opsIiJSR/ZiHQ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1088a4e-dfef-4e0d-0364-08daf2a1c3c1
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 00:29:41.4990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k4GZq56KGEwtNCOTtArn6DtMyPWfwWMihJKuqDsfh5bxwmDaNJxiDAf8AamdL7+V
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5480
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 04:34:34PM -0700, Alex Williamson wrote:
> On Mon,  9 Jan 2023 10:22:59 -0400
> Jason Gunthorpe <jgg@nvidia.com> wrote:
> 
> > Add a small amount of emulation to vfio_compat to accept the SET_IOMMU
> > to VFIO_NOIOMMU_IOMMU and have vfio just ignore iommufd if it is working
> > on a no-iommu enabled device.
> >
> > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > ---
> >  drivers/iommu/iommufd/Kconfig       |  2 +-
> >  drivers/iommu/iommufd/vfio_compat.c | 46 ++++++++++++++++++++++++-----
> >  drivers/vfio/group.c                | 13 ++++----
> >  drivers/vfio/iommufd.c              | 21 ++++++++++++-
> >  include/linux/iommufd.h             |  6 ++--
> >  5 files changed, 70 insertions(+), 18 deletions(-)
> > 
> > This needs a testing confirmation with dpdk to go forward, thanks
> 
> How do we create a noiommu group w/o the vfio_noiommu flag that's
> provided by container.c?

Ah, the module option is now in the wrong place, I'll move it to
vfio_main.c

> Even without dpdk, you should be able to turn off the system IOMMU
> and get something bound to vfio-pci that still taints the kernel and
> provides a noiommu-%d group under /dev/vfio/.  There's a rudimentary
> unit test for noiommu here[1].  Thanks,

Thanks, I'll check it

Jason
