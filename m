Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67207AB20D
	for <lists+kvm@lfdr.de>; Fri, 22 Sep 2023 14:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233897AbjIVMXA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Sep 2023 08:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231172AbjIVMW6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Sep 2023 08:22:58 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2076.outbound.protection.outlook.com [40.107.94.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7700B92
        for <kvm@vger.kernel.org>; Fri, 22 Sep 2023 05:22:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1HR0AXc1Ot2adZ4AsMjN+c1SVM5o9inA3hzpWhhURM+a+0GXT5yY7lteYCuMOtFiDRvBWYrTqTwYnXaAavDU6dYIpX59wL9qWXk0ab+08hWosoIkIZUmo14UQJQu6QHF7sQ23v+zQub4Y22v5z+kvOTXImkeDCo5e/na7j9l3jQ8OJkY9kmFjFk3r4AIffXh5iCl19K36QBp9+qlKQaGl1uSWHveApYZm/GktSYeAoQHHt03++h5zH/qyHodv09wW0z5e5LTnkxTKA1YiSOkAa46zYjx6pZt7l5okICmIXQfLj0OXqhhcWPMT98Jnxxf9N7GuAZwTV7i7mRHEmHUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V8mDK6mGRZ3wPtxQGdVjft3fQy9oU9QA5ymB+kSQ66w=;
 b=f7hrK1MNnCbh3tMQWRFI127a0ic6Uj/P6PCGyW9HUv6H2xuqdY0HRZecY8ONPfVi4gWRu0dkF/T5WtgUpRiS+7lsFW4B0GT+Z3n5PzqOIwLhe2+WQqyasCBtKonkT9VSPjR+klS7xOKrDO9ca8HkBh7T1Qt0e8nSjdYyaYH9VV9MhFVcZ7F43IRAYExXnngKrYRlmyXp7xs1DO7weVjLQ5NtoccoVqqyUZAgRyXigA+kZe6v5HgODB89dl/kknDQ86+m7ndF1K+R+rd1hqXc1jr9SnctB0iQZNNspSL+QbjfoJGrOOAKKBi/JSavYwxSychwZxQhlmfwTFeOddb9hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V8mDK6mGRZ3wPtxQGdVjft3fQy9oU9QA5ymB+kSQ66w=;
 b=VF5uPfORQ//SqbJw9Yxm4r6s+HZBAhJxEANesRfsV+0b2+i+X7+2pSjszbz3iDArUSLGMEYain8EPOrNC94+uYiwkuIlprrgQWCK29v+BJ2FYYGp90m4W0nLC7fj/IO7AMRL0PLFCDytK4eMrMUT27cr5moMsbl/L+BoYDSlfpvnRsJzAEiQT8uCEZ3AjQuMjF3MhGZEGiQ9mVxyLE3ZA0blCzrpHjAMZD0FTpq138d6XLflZ6M76XpUzOVOtrgDdi7xhk78kJC9paq5oogkOkHI8yKQhtERKxbqSCzZ5u+qO4TaBLEbfzinaR6b3AxjMwin5E/YwRAGgHEGglFCmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by SN7PR12MB8130.namprd12.prod.outlook.com (2603:10b6:806:32e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.28; Fri, 22 Sep
 2023 12:22:48 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::faf:4cd0:ae27:1073%6]) with mapi id 15.20.6792.026; Fri, 22 Sep 2023
 12:22:48 +0000
Date:   Fri, 22 Sep 2023 09:22:46 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, parav@nvidia.com,
        feliu@nvidia.com, jiri@nvidia.com, kevin.tian@intel.com,
        joao.m.martins@oracle.com, leonro@nvidia.com, maorg@nvidia.com
Subject: Re: [PATCH vfio 11/11] vfio/virtio: Introduce a vfio driver over
 virtio devices
Message-ID: <20230922122246.GN13733@nvidia.com>
References: <20230921125348-mutt-send-email-mst@kernel.org>
 <20230921170709.GS13733@nvidia.com>
 <20230921131035-mutt-send-email-mst@kernel.org>
 <20230921174450.GT13733@nvidia.com>
 <20230921135426-mutt-send-email-mst@kernel.org>
 <20230921181637.GU13733@nvidia.com>
 <20230921152802-mutt-send-email-mst@kernel.org>
 <20230921195345.GZ13733@nvidia.com>
 <20230921155834-mutt-send-email-mst@kernel.org>
 <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACGkMEvD+cTyRtax7_7TBNECQcGPcsziK+jCBgZcLJuETbyjYw@mail.gmail.com>
X-ClientProxiedBy: BLAPR03CA0137.namprd03.prod.outlook.com
 (2603:10b6:208:32e::22) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|SN7PR12MB8130:EE_
X-MS-Office365-Filtering-Correlation-Id: 7e9316b2-9c04-42a0-e498-08dbbb66a1c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LzaONdftm7bT34D6WpalzoVR8ZPjIwhCXamQX7SJfth4TBRNRGsGYXVk1tgc0xct4qIeCJ5KpnQSLPJ+33iEDWSTDKKjDeTxrEfoqEmS1Ap3Ba81eG0typ2RUAnbs/fABPCm3LK7zBBqsoW8YTIgmXt4UEuphHyimd4NlK9ZmKt6GYRLSPLGPB2YIl9Sj9uW7uNhRXwOKYfHqcVPyLKzod55poXjghfkIW++oR2WrhKP1AilrO2Mvv39NzZ2GcVA0jC/7Lm7LXuGTuznWHb/iOFlt+LMW0473nR7RwAJJH7VQuoMrGewGRTsRIfGjLHyM8BTa0cvFdR+O2tk/5Bd2856f/XE9Th9AWc/RfyVRHmQ4SANwpTdsyyaZRh0nO/4l0oZmolvob9WopoFMCMbSB093ki9TV+ELgWQB309mYhTZGZFUzFc2ReFIfymnomEo5PbyU1i2IvODxG7nI3NxvxgANIYq53cbPMt1UlXBzA9FWL+WbxqP/McdQZIat4v9wlLP4nQBe2w4lnneeXfgVMkhvgLcCd4zjDCi4+C5nNPEqYLoqMDD3OagR1gNj74
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(396003)(366004)(136003)(346002)(1800799009)(451199024)(186009)(2906002)(4326008)(5660300002)(8936002)(8676002)(107886003)(41300700001)(1076003)(316002)(66476007)(6916009)(54906003)(6486002)(6506007)(478600001)(66556008)(26005)(6512007)(38100700002)(33656002)(86362001)(558084003)(66946007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+FV2cOc1hgKJMoUH8egnXvYSBZX0QEqeBVE6ryXnuk12IkpHU729Ig9qawIP?=
 =?us-ascii?Q?zBwIaEfE2/KIKmlPd1Lz6LMAyZa2wAuM4MPyiIJXUthAPMFLRj8LqHKJJBUD?=
 =?us-ascii?Q?r1CIqxzFr3wo58bi3F897mTtrsMNEdWAUJMxBf/tYWY7cQPWg5ISH3yOa167?=
 =?us-ascii?Q?nQi74PkgitxE8LL77ZeMvTQBH018WL18zUWDsV9FT6Xqh6+ydiZ5d67XRsbV?=
 =?us-ascii?Q?jOUEoE+C7ivjVDgEIUmSf29lavrxh6NHOHIOqOnVsqkK0rMmtn51XLNfi03e?=
 =?us-ascii?Q?y3on+XNg400eHx+8nkU0Ap8L55OGQGEZ1WZQutG1GRadJGMGMZnUuZDRCXrc?=
 =?us-ascii?Q?PJEq6pCbUjfsiXsTgzQPShducLBCsxykgDkag4uiXQDs/FJJcwFx1ZhfOk+8?=
 =?us-ascii?Q?dDGUV5JmdeGgjTvklu8vtjmm+ASrEPCgdQambCVyAKj7Wktiluvm1mY+DiR3?=
 =?us-ascii?Q?3SxF4W2/xFXKBiTnpsItHsruI0ulacRn4FEDOcMpuG28zGuZFseelFvFlVfk?=
 =?us-ascii?Q?N0XZW8vNKDvduf9wxT6gYI7ds3DcfBw4qZS4K6e0RFuUZW9ano3QJz59rtDO?=
 =?us-ascii?Q?1EiAVmJA4R0xtcakcUFpmiHTXeASzK0cj79lwrYlMuRA5XkzsERQTMfPvxRm?=
 =?us-ascii?Q?xc7J1clegutj8UJTS0pSExWmXuMtnyfuS3yHrYAmIV1Fhv8BC6Xlvz8AaiCN?=
 =?us-ascii?Q?hgn73+1ogASXD7myZga31udeKEkjw1WgsZNrgTaqmCNIdS7Rof8hRLHPjq/1?=
 =?us-ascii?Q?zZjDUhJ64KJv1wfLt97/qu/Rp0OPo9KJ3NAildvkx5ZccgzFvf4P06NKlOEb?=
 =?us-ascii?Q?232nis17BmGKwxyJs6MiqykViPmG3fJw/CZSvidTjCOs6sNOTQhZR9qjh12j?=
 =?us-ascii?Q?mUoh9gZXlNv3F6tATkOO45NDBg1DPS3axFsd81edYh0PjR1zCugtw8GHcgkH?=
 =?us-ascii?Q?nDI0xxMGJuD1cQcVFbQNRwAwNHHUTGdcwuVVrUkHq0SpC4DMZV2X8U8dVyx6?=
 =?us-ascii?Q?SVjwxgNv5cWVt2eZEd8Wue7O8f3dmCrFYJ8VovNAiOnAxbljjeSQ5el5l9CB?=
 =?us-ascii?Q?7VfDHtqa+Wd8Bx1fMS5lAT0XL9CVEIW70ZYLSX4sTGjee/raNgzzuFdCzkhc?=
 =?us-ascii?Q?3KEReO63xaz71Ml7+vwC11JEE9Uy/+6rgqSttSUF3IM77xQG9NQN4FOyn4LE?=
 =?us-ascii?Q?2Tr5AIhFQctqGtKZtuEB9qQFDMGLrGIns8LBsCz0eN74OLfOQz/Ymlc1pEaO?=
 =?us-ascii?Q?JdF0Yr2OuKHYzOsPPvZCazce51qp6xy9/8NCJXaXVcpvubudSt/U9AJtlvMo?=
 =?us-ascii?Q?FsTsNthUsJVrMWMHzT4C7C7P0JH2NiUHi2Vx5U9C/Jf7Ma34tkJomzQzTjCB?=
 =?us-ascii?Q?wZWCYlqYl6v+UQY96xEou6DFsA/8zfKMWXTzx76XqIuFKL4J0u76nWeYO8tT?=
 =?us-ascii?Q?hPHJaajb9TFCBKg4mt9vfjQvleZr18u+XmYP8+JoCaVLletuo3+JYlKxUKsI?=
 =?us-ascii?Q?C4S8YuU0CgZRhn1ptZLnNUl9V2aWQa3Cc7uUIDRfCJdbUqU+LfYoV3go6VCs?=
 =?us-ascii?Q?GPZhRODQBalet63V8LKUDTZVlv/UV+c3wnac+Xb2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e9316b2-9c04-42a0-e498-08dbbb66a1c9
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2023 12:22:47.9739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hBTGXqmxsijX2BpfO+7+/AZTa1xZbBxfHSeFVMEoN0pQFwTxWuislPyHZCVvTWPL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8130
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 22, 2023 at 11:02:21AM +0800, Jason Wang wrote:

> And what's more, using MMIO BAR0 then it can work for legacy.

Oh? How? Our team didn't think so.

Jason
