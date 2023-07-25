Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386A6761A39
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 15:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbjGYNmo (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Jul 2023 09:42:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbjGYNmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Jul 2023 09:42:35 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2042.outbound.protection.outlook.com [40.107.94.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F2B1BF9;
        Tue, 25 Jul 2023 06:42:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ar2ODkte8cR9JzaFNrIhO0PLbVjaSrkl9Hn3QLy3u1XUIkvRuz1MdU0WJQRra0EUhawje0CDNC/S9q+UlIbebLUZ9GjuGdurR7+Zuta4qHLgaz/UkzwtnCGmFb+IewFh1LxVe76vizB9wlyNADmZCaNGNqL/dwZj1G55QObsePchl/Dy6TgK1lWk/uiGvxSFmaxkM/ya55OD0az5QKpmrAbTS9ujTFZDEpbWhpr8ScEFL4/ii4/fxdta1CZ/0fnfd0drLkvoB+/opr/cJUES0wNGhd5S/9WwK2CbwdEVVh68dfjkrvRnePvNuj9/L9S5wkLAjl7Gc9i4phbysRHlaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d25jQwYyjckuTXjDCjP5HzuWDtiLjgNm0PTTXdo7NfQ=;
 b=SQwjWO+XTSdBTI7K9/QJJYzjA6S0g6iZ+LvoOFq5pjd4YKx4oGKAfe4Da9i2yjAjbzXh5S13qSgakfZ1IWkVOQy24PPtZow5+MoNiy7G4/prMBw87CtLD/ILex9FmLbRsW8wtuN63QBsG6xGYJKHatyBDhgn3YvBlRtYqGZXvKvIv/rwX1nV74lcT+f7GGeoU5pZ+zM7El7IJ+Cywmoh81mif20Y3L0RC0PPYMfgOAHpzyf7HPdqtCio1897/9vbnDOAtJ+Aq0CFHoKkAxF8cCbQkpHTkWQ4nSCY2uyn/t0XpMw9WF6/tbMB1tDeDUbogoEfv2lfNIRgtS8vyfv+uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d25jQwYyjckuTXjDCjP5HzuWDtiLjgNm0PTTXdo7NfQ=;
 b=aDcyb9XoeWw7eYEnSXEzfAbu+bqDecCYCYo5Zxydx/ohbTkIOmMT+scNJdcAmFiuBJQFmOHn2KGiX3rFQZTg/WbtfWWba67bLKFarsrUdHsT/jSFUUnQzt4DqSs1GsGXEKElNZfFdJSht6cKtBQ7XJfgkjlzYpOxYmcKdE3jJ09vq0TiWde0MSHNc1wJyyo6/r9OKyVtIXiG7n5jcTGKzVoBCAfqSJEpzLHlxCaO45FS8XsMT9PBq2fgTFszisAkOd/9IZB6x0aP9OFIQlRzJaunRwF8GfzpdlOfn5/gqXt0Ymdhv3MoDUNcWGkAbJMV1eo/I14wZXA8+3R8HRtqUw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3176.namprd12.prod.outlook.com (2603:10b6:a03:134::26)
 by PH8PR12MB7327.namprd12.prod.outlook.com (2603:10b6:510:215::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6609.33; Tue, 25 Jul
 2023 13:42:31 +0000
Received: from BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::c833:9a5c:258e:3351]) by BYAPR12MB3176.namprd12.prod.outlook.com
 ([fe80::c833:9a5c:258e:3351%4]) with mapi id 15.20.6609.032; Tue, 25 Jul 2023
 13:42:31 +0000
From:   Alistair Popple <apopple@nvidia.com>
To:     akpm@linux-foundation.org
Cc:     jgg@ziepe.ca, npiggin@gmail.com, catalin.marinas@arm.com,
        jhubbard@nvidia.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, nicolinc@nvidia.com, robin.murphy@arm.com,
        seanjc@google.com, will@kernel.org, zhi.wang.linux@gmail.com,
        mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
        rtummala@nvidia.com, kevin.tian@intel.com, iommu@lists.linux.dev,
        x86@kernel.org, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        chaitanya.kumar.borah@intel.com, tvrtko.ursulin@linux.intel.com,
        intel-gfx@lists.freedesktop.org,
        Alistair Popple <apopple@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v4 2/5] mmu_notifiers: Fixup comment in mmu_interval_read_begin()
Date:   Tue, 25 Jul 2023 23:42:04 +1000
Message-Id: <e7a09081b3ac82a03c189409f1262fc2df91071e.1690292440.git-series.apopple@nvidia.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1eca029b8603ef4eebe5b41eae51facfc5920c41.1690292440.git-series.apopple@nvidia.com>
References: <cover.1eca029b8603ef4eebe5b41eae51facfc5920c41.1690292440.git-series.apopple@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SY5P282CA0065.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:203::19) To BYAPR12MB3176.namprd12.prod.outlook.com
 (2603:10b6:a03:134::26)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB3176:EE_|PH8PR12MB7327:EE_
X-MS-Office365-Filtering-Correlation-Id: 45461eac-9dc9-44af-0612-08db8d14feb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /QTltbwBzGT6Eiw1N5OUupsut6cw6TdlsvuHw35bfVxylVItIKbkqL4vZqUnbXNQE5BmRJJm3FNcn2NTshUmNOGHoyJUWiRYw+ZeiRLBjhDJMbmCh/6EGXY81qTHGC8EjmBbpTjmI2qnxAR7e8S23Sq3ocDneswq3hU8SdyzXkyzaoEEw0G7O3InpBDZaMOXByyzYpMXLw4oHr/zMgY2lO7CVYZYTuUOKvSfDjV4fLjDM8vrRUCjZrV6b1f8ks9psXIp6ZThXE1VQQOIApxxVuw42RimOgmFLCHS6a71gK6zIXEUpFx6VhnITSnB4/9COvJPe66ZxT2fBht3vCqQzAGK8X4ko5cohAm5Ms1mcjTDRi5/aMdKoDmHLF6hejkO/ZvU11wkLlYNVNn8D40iUUc2RAlczaBzmolp+aV5UVg0PQiZawS3FiumsxKkUazNgHC/PeYv+KyIFPrAnnmuN9Vwm9xl/Q8RfWeef0ntiRyeOfh9pH220hLmFHjj0zUdLtgZ8yXwY9p9NuZRch1rPUnK/MKB/NTWJirFTeATZ+ggPl/fwVsEPAm2zMx/i7UA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3176.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(451199021)(6512007)(186003)(2616005)(26005)(6506007)(107886003)(316002)(41300700001)(66556008)(36756003)(6486002)(66476007)(7416002)(5660300002)(66946007)(38100700002)(2906002)(4326008)(6916009)(8676002)(8936002)(83380400001)(54906003)(478600001)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KyVClXNvWWHOCPHkUX0LInM4mOZO6KU2k5/CZPTLaBkX++ufQ3ryWSh2aaCN?=
 =?us-ascii?Q?DkqebSdA7ikRPSc72OZGh+FSuEYjii8MAClCuTFrp3puFqZWwbMdIQgCWm0d?=
 =?us-ascii?Q?VSi8TzyQsp0zarlIdhlizBC8PRmqIplkHnrXEgrB8bfYCLuRcGp1Ehij+MW8?=
 =?us-ascii?Q?aaDNvfiHFLRWvJs/I+YvHS/KUGWd3Rh0Dp/RODiab70h3e4qefv+Clgqp0eU?=
 =?us-ascii?Q?j4ltKnDXUff22EP4PPjura8zj7hBHKnxUdLVI3Dsf7SMT+Yqf+F2UhclmJyt?=
 =?us-ascii?Q?Dw1zpl/oxc2OcRthlcTvLXMn1W6hgLHjkHQrmjCZvMOcciuFdv4/BVeqGjQB?=
 =?us-ascii?Q?lPMfoNHozL+Fgx4ojE9vld/WUKnOAOvEO99LKGSyfjBCEY66tlUi41mH8HcK?=
 =?us-ascii?Q?K5S7LzMgIq35rvV62mQPNp4XGB1vHtSCTe+9q7H9anVdmAMo1YSXSsUIiu0r?=
 =?us-ascii?Q?bzwmgRcsqFwdhVLmnYRUcUN4ckDup8gO6wJ0oUwkM42JF3vWOllZ16PbuGcr?=
 =?us-ascii?Q?jvF7p6kfvjH8ypc0wQ1l9N5dnVH6Y3Q3HLQ4lNIOiGF0heqMAEQZ3n0KAB5X?=
 =?us-ascii?Q?5BZ94mXw0i5CXIO6bfxvtQszUJigxfHoZEh1b4+slKSyv/Ak8UBvb1KyDLO2?=
 =?us-ascii?Q?zKnEHXEHDa16Vu+V+1mblbAfQ7ZLoyl670k0xbRD6nnM0hu6R3pdl/2ipIrl?=
 =?us-ascii?Q?5yHDuu2cR0FrSy/D0h6vZzONbOsPr4nMa7FJ+/ckORk4nX7Sz+bgygB9biR/?=
 =?us-ascii?Q?Zt09bAhKAsxrOTilu4H8vrStkUFM6ks2UtXIx2qmpv5qYybFr8rcZdFwOqAm?=
 =?us-ascii?Q?5lf91QI9FeaRdmStBS3P5+BK35PATvPfPL/aoIxn+k1t4gOFHY06SoSTdmA3?=
 =?us-ascii?Q?A/27PxSNF0JSQKqCegtatq2iiY6+3c8ANcmcp5CzQoiOVu4jQMzIhUywjD0K?=
 =?us-ascii?Q?r/p/VH+NTxCeQidFwd1229E+Tn4zg7nNaUUZR/Km64zkLsUUU72uVjoghHJr?=
 =?us-ascii?Q?Uu+Lv1U/xxDzfxcX8FRCBxleHTl9c1Iza+m/YJ5GXMqllPqbF9nc0eoqTWgO?=
 =?us-ascii?Q?nD7byfSxwtW3KyZQGrnuFcH7hLPX2KkBJRN+wiNScR5Rtp43THcUPjqhIAg4?=
 =?us-ascii?Q?FaKT7leZ/o+SNilwUNjA8n07iAxTtvO6cf+QqpptzDPAc+pIukqpmRDpDte8?=
 =?us-ascii?Q?qVIkGz54W7qwfPqxtLxHAtV2NMHHfNUv8g4sYVaYlE74fQEXOlwWjbCNSoJW?=
 =?us-ascii?Q?Kzhyu5bVX/ZqgVCpxXgKF7BINnLaVHmytubq48eEQ96sN5K2R4ugKDCJLbZf?=
 =?us-ascii?Q?qhnFQM/+mLfnDR88mbbFx3Xt4pX6wqTeTPnA9zY+G5k85W0PrvYa+4W9OxGL?=
 =?us-ascii?Q?ma643/oUTxIm7k5btKm2kPPJc0RjSIeO1GTnSkBHbRyjebINmr1u9JPWPpFT?=
 =?us-ascii?Q?sg+p7vJ5PEEgtrBhIjYSeHp2Fe9YStlW0g3+DRy3aneXpQr5/um6o92rQ9Pm?=
 =?us-ascii?Q?5f0b2p3LdxGBk45JlQBEz6Zl8t+krjff+Am265zju38GcRhVL2KPm6osihF1?=
 =?us-ascii?Q?V7f1U+aBj2bh4Gk5nIyapjmkThqDlLdVRQeNAjxO?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45461eac-9dc9-44af-0612-08db8d14feb4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3176.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2023 13:42:31.6323
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7uLJeY37JuHD1tBlZUGAbiqeftDjLRJ9K9U0F17zN43VK654X/pQe/YRVWYluKzyy42jN8+b8a5u9SmH2mTzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7327
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

The comment in mmu_interval_read_begin() refers to a function that
doesn't exist and uses the wrong call-back name. The op for mmu
interval notifiers is mmu_interval_notifier_ops->invalidate() so fix
the comment up to reflect that.

Signed-off-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
---
 mm/mmu_notifier.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 50c0dde..b7ad155 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -199,7 +199,7 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
 	 * invalidate_start/end and is colliding.
 	 *
 	 * The locking looks broadly like this:
-	 *   mn_tree_invalidate_start():          mmu_interval_read_begin():
+	 *   mn_itree_inv_start():                 mmu_interval_read_begin():
 	 *                                         spin_lock
 	 *                                          seq = READ_ONCE(interval_sub->invalidate_seq);
 	 *                                          seq == subs->invalidate_seq
@@ -207,7 +207,7 @@ mmu_interval_read_begin(struct mmu_interval_notifier *interval_sub)
 	 *    spin_lock
 	 *     seq = ++subscriptions->invalidate_seq
 	 *    spin_unlock
-	 *     op->invalidate_range():
+	 *     op->invalidate():
 	 *       user_lock
 	 *        mmu_interval_set_seq()
 	 *         interval_sub->invalidate_seq = seq
-- 
git-series 0.9.1
