Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52FDC529767
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 04:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbiEQCfE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 22:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiEQCfC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 22:35:02 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2102.outbound.protection.outlook.com [40.107.215.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724A83388A;
        Mon, 16 May 2022 19:35:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKS9ccYFICbgl4MvOU9CIbRwkg+OifQQ81moEiKyxdbw4/5FOfHJFEfqkiSlKdrCdls0HE73r8Tjq2DZ/0lelbPZBhhhFYFTbN8o6EteGCKZF7IjvEwxQBJybe4LE5/mWvzfAC4vh09Y0R4VyAZsjeDBJxzt5KlxUeAC2XX9kjvLLitvIp2WCeOv2nDm7sK6S8xJp/kEQJnTkbpp0s4WF7vxXJPlo1hbD5ZvxFTnPZ/frhTprqrtBvRbtzlgJbno8zB9y4xmPyIgJr1r9vp5VRZROcCD7+mqEn+7yyz7WrTvyVvS1E7gA5PyJiFsPZt2u4hS5PZ0toa6IhlHNhmirQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wxRlZEzi0naP2k7nQS45uVFaSUhE5LjAXAVqQe+cA9Q=;
 b=PUmFCoC3yP9d7FTzzqBgEXE3huHj7axE0Cnls/uk7fzKyOGM3PGEChjAWcuzyQaKARrFhRi/Pc1I5acmxpH6Qy7L1kCoF6KTTnGCLPUVgRQFnTae7mVHFGNWBJboOL/UpN2UPbjqT5ZiV5VhV9eOCO1LZ9vTRqPrnAvySnej7McvGA3G12UA2WOA3MSU2jJtRYq1XusqS99dGdvUOQZh4sdFEGHT/5lsOb00CMPzExRXYFGUKMAa8ES6F7Hlszz3ImhJqtThx4fdDeTAmCR3QTQo50rYbfJyLtkub9QFoT8jdkn1DEIY/W9cmJy/oTNiAf6ZPmO5PeH0g3PlsSwfsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wxRlZEzi0naP2k7nQS45uVFaSUhE5LjAXAVqQe+cA9Q=;
 b=hpmqGBMpocKw+fxK2DRxJR0j1qwyXVrkCYI5nbP7pyLppfZ5DPbSyZmCv3CkvNTfIsYCupOm3yRKVqocvF4KyWZFR7WF4wLNpbTdasRnV0ond5qeQisNrnlFlvGgM+IsudnAfHvpDV9xNVyCb7YHXXcZk9bbMkMnwUAq95m/Zyc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 HK0PR06MB2484.apcprd06.prod.outlook.com (2603:1096:203:67::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.16; Tue, 17 May 2022 02:34:56 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::ccb7:f612:80b2:64d5]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::ccb7:f612:80b2:64d5%4]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 02:34:56 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Yi Liu <yi.l.liu@intel.com>, Kevin Tian <kevin.tian@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] kvm/vfio: Fix potential deadlock problem in vfio
Date:   Tue, 17 May 2022 10:34:41 +0800
Message-Id: <20220517023441.4258-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.36.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR03CA0128.apcprd03.prod.outlook.com
 (2603:1096:4:91::32) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d759f6cf-2a75-4ddb-5b99-08da37add415
X-MS-TrafficTypeDiagnostic: HK0PR06MB2484:EE_
X-Microsoft-Antispam-PRVS: <HK0PR06MB24845885F75FE525418CB8FEABCE9@HK0PR06MB2484.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UXlgygh8gAFaUmLQ4NPm5vBzCiMmEYMtUhPNG/zVuI2EQ7O3tblg4T5APmQP0zmqHkMRnOIpxH9tBMDlVGv3nhuh/X+DpKZWoh646ruwdDmWzOFjAFh/6jeaz9Zn87mFoME7sf1nZCz0DucGw/jRJsd8gX90Zg5631GRutZ/gppuWYMmc7T28qQen4N8odKepHc7rFrIheBK0+QtaF9n7z1GOZz60ykpV0eNk6hVvGrKE38eTkdtKjhH6g+Cjirph+/KQZ/v1V6Q7WccivUZI72oON86jyXf6uEnxvIqAZhMHSIXUwyi0VBuQanYAita4eqd9QGkIT7yE0kYziy2Ru69aetrm3K//I7LBm2ZAAQSMHp+M0UiRsW6LwcV57vl7hJU8LR83/ev/a/YFLYvOMWe5K9CwV7iqm6g57NhjdMAowT2ELnc28kNlfY7cal2XT5y3Oa/8AGTxFozhhCcWvPDNkaJIVLETQ1m/TslKxrh3WXijU/D08Z3w8GlFHiOpc4zz7B57KlQgzu3nJNwdbILRGshkDZeJhfEdk0QB2ABp5SFGwzDOoE7e6tvmrOo+zitVFR+1nTeLHXat40UI0nzo4qBK7JZXQx5mct/7KTT2KxrpokbWK4ypPb3JkTvhW41RiRt2oBD8GrFhxOmzdPEgZi9Xlh/mWGbwhVqlMXavkccfaikDaqNdRn2eQg+74Ei+cYcFCtXV3WE9NbITg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(52116002)(4326008)(2906002)(107886003)(38350700002)(6506007)(6666004)(66476007)(4744005)(66556008)(66946007)(5660300002)(8936002)(38100700002)(110136005)(6486002)(86362001)(508600001)(26005)(6512007)(1076003)(316002)(36756003)(2616005)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0Qx+e1kGuwsokmvN+WDaacX22Gp9GUeOG0AiiJrnUaT+DbBnHOOp70zN6/bz?=
 =?us-ascii?Q?naw002PFHCAklHxs9C/ugs9HQLxo8vLWD54CfR7K7efX+MfO6EsGYrZtN6I7?=
 =?us-ascii?Q?jnQppKJLLX7OohPuJ6znuWPuumzZQagxY8rUjiI0qDh3meBP490klVmN6pZr?=
 =?us-ascii?Q?IsInh+HXbsWkBEcB4g8xnffYHrsCGG/1gBoftdcZ6vcyq9Bfl9wSRFvWrXl/?=
 =?us-ascii?Q?RuHtAk8uddRL0eB6QzsP7bzi+hVRlld/if8eXAk6FM7o9zjAnfX0HzdBCERb?=
 =?us-ascii?Q?kw83noDlJy/FfR73+AnlfwWCxcYJlk3wxmgRggCfwXdIZR073hU8W7glbYvj?=
 =?us-ascii?Q?kjCpG7LWr6akfRvB4umllgLqAXd0ycqC/DOu72y+X26EgYp6+gkWmxj2NV8e?=
 =?us-ascii?Q?pl4jyHtrlnQBfHSst8bVms9EhQvUY5DZnS9j8syan4sISQT2ArQyzoKgrTQG?=
 =?us-ascii?Q?PQfoh6IVme8vQvhTwQKAO5rWpj5JuFX1vnpae5lnygUB5vNvRk2Jsv1GN29r?=
 =?us-ascii?Q?yBx+gIOCAB9zU6MZByWt6oU/sS8DUd/1AAEGY5xg9MizdMjQ4kqSdK7K0O1S?=
 =?us-ascii?Q?aq0aGch3qojAueWiZ/EZRnl2Ahx72qdVh9uZi9Tzu90axzbG6tIJx8o9PVNx?=
 =?us-ascii?Q?qar3+FwYl7xYCdcgZnI5SnqgRSz+qLvqIY9oXXvgFoBSXaKpzrZY9Vy7Wor5?=
 =?us-ascii?Q?MFix2ItATDhM0KSs/tX35/PGZlMpqZp4Pkn3Afqgu/vkecuf3t7jUxbrxHei?=
 =?us-ascii?Q?1pnSERoEwIygEAFgVjIgRrenzwIuL36qFPzReovURskJTBlcAhUUx79Ly2y9?=
 =?us-ascii?Q?PrRTFxU2lBkA1L6cS0W3beI1L3gjPMIv5OQiXOa7CP4vFkJPGBVwPRXyojsm?=
 =?us-ascii?Q?hwIAsCKyBcJoj6eFmHE+lB6rEF83ThKilRLUCf0xYIOVt49PaRnpljLCaD+M?=
 =?us-ascii?Q?1qrmJL5yuOa4nLn4wkXKuNB1vekabUt/vg5pha0JwreA+sW72NVR/VykLSq2?=
 =?us-ascii?Q?mytkx3Yo0VQWcjpsN1uHzsBVXsGRS9RUtEG36UPwb/XI0zwJMQ/VuQ0cmbUK?=
 =?us-ascii?Q?kWBAhJnIrHZoO0tEAw/gbelGCtO/FQp1B2U6cMHDz/Vxh4fKzYktpCsLUPdp?=
 =?us-ascii?Q?wwxFEnCxgIjk/VC/UexiK7pAAB2nczlHuPiMx9oEeLntIOTW+dnMvpKOueDE?=
 =?us-ascii?Q?JZo1wIinJ+DMGWn9ERYIDHWjvpoe0ZVGlQXATLanKrvFczFV+IL1IsyOVQOc?=
 =?us-ascii?Q?JvlsP2tEWpJRqyqfnlx/W2nHke7ueGT6k+60+RrjTE2HW0jvwSMmgElpYB25?=
 =?us-ascii?Q?J2PZEV+TP4mpyeyXbPRmUDYGrljWMJ7iYFk500oTt8XW4Mg0M6Mcsg6XEEu+?=
 =?us-ascii?Q?Rm+FqSHiwTptSN4jBzd/gxB0gcxsYiuQtmTHedgKLJy6AHycahmBROIDQbEa?=
 =?us-ascii?Q?iGVWgHSnlt95gcVBtzPULwGjRkh075YEYte+FyqoGFkTrR2+EJoy3j0T5y20?=
 =?us-ascii?Q?2qGvYRpYRFuBlhL/xpk5YxvEa7MayqFOrcxUzJoOJVDrBYy1W61eWiEO9F3F?=
 =?us-ascii?Q?TtBnOPtH06Otrg6aQkZiMgYtekk7ydXJP2g77rppmMQQgR+mI6BNRaWW1uUf?=
 =?us-ascii?Q?zCgzRvl42rzhbBE4xiIzMwhfsOLSugU4ERlKFC/WDilMtVGNAcO4e3beX6C9?=
 =?us-ascii?Q?BdXQx/KHNYX+iLVNaySHOFTeWAcxsmoCjp4N9jjWCVH3o6mHxwMKSpm6TKmH?=
 =?us-ascii?Q?qe7MUGSBEQ=3D=3D?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d759f6cf-2a75-4ddb-5b99-08da37add415
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 02:34:55.7135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G7N3YJBaUD64SlKjNJX3fbg46etrK2vuLrfT41LN95HoicN4LJFgjC8ZMNoxrISZ73igZoN3LLY1LFHa2G2Gmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB2484
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RCVD_IN_VALIDITY_RPBL,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix following coccicheck warning:
./virt/kvm/vfio.c:258:1-7: preceding lock on line 236

If kvm_vfio_file_iommu_group() failed, code would goto err_fdput with
mutex_lock acquired and then return ret. It might cause potential
deadlock. Move mutex_unlock bellow err_fdput tag to fix it. 

Fixes: d55d9e7a45721 ("kvm/vfio: Store the struct file in the kvm_vfio_group")
Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 virt/kvm/vfio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/vfio.c b/virt/kvm/vfio.c
index 8f9f7fffb96a..ce1b01d02c51 100644
--- a/virt/kvm/vfio.c
+++ b/virt/kvm/vfio.c
@@ -252,8 +252,8 @@ static int kvm_vfio_group_set_spapr_tce(struct kvm_device *dev,
 		break;
 	}
 
-	mutex_unlock(&kv->lock);
 err_fdput:
+	mutex_unlock(&kv->lock);
 	fdput(f);
 	return ret;
 }
-- 
2.36.1

