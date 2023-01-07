Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E3B660C4B
	for <lists+kvm@lfdr.de>; Sat,  7 Jan 2023 04:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235567AbjAGDrz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Jan 2023 22:47:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjAGDrx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Jan 2023 22:47:53 -0500
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2061b.outbound.protection.outlook.com [IPv6:2a01:111:f400:feae::61b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3D247324;
        Fri,  6 Jan 2023 19:47:51 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EXGO5vTlkxeX6MpPRP4egP0cQq51kCsbl+H0eN45alS1Yqn+lt7llAZA20kOwpI1vQbAfbm1RETajrraN5lVL1/87mO3N2rc3Puryp7G0gOykYWTIPE/0gXy7FCeCw++WKTH2qeRKMjyhttClyE5uGMzeZ14jUnyQNap2XdoP/Ra7fUNJEAjwG6dH7PO5A7jmsvbFpsdxzuNH7+tiXgG0zW6d9OLkmV0H8P5GuUFn0/Yz7JnwGXwIGyhzXS+RgT1mISjO6acqRf0vsYmyMz9fd0oQWZBAWYG3oKJE+AB7u9iq5JCR53IacKKzNDTscOcl7acwHtmyPVK98d0LypiHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jwBstPAu7QQ6E8p5YtzgrUYFswEUqRlA4sWYvetM+3k=;
 b=lspGW77kFUes4vJfvmd7RY7kAsEsZTU0yHFEh/m85GHJ/m2EO14gAvGB8b2ouvZlbRUOqfkJheayPJwL8eOZNbcGRktsKDB5vPWq9Qr004SxrLG/qjLWXpG0Cv5IpU3jiMOvNH/jHA3v5rzuhrvXYv1yKh+OOUFEIN/2uzSkwuoh7cFrvvAeJDPmSEyXerrn997+PBBYmytPkTio9XSl7GJo7OQzKIkjsN96JOV9ezqZNMmJqIgeTolPCjj5AvpJG8PgcQEmjvdib/6Qr6aTcgDEGlF47jQJFHpfqkAbo7uQMusVeuyus960DLiGXDfqIgLFcVo99Sl6ZV0/Oc4IEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jwBstPAu7QQ6E8p5YtzgrUYFswEUqRlA4sWYvetM+3k=;
 b=ZEdhRWAtvgPy88h7qZT2wbDmEHd48jbJaEkdSyKOIp5TkHlz7f1tTcqrWJvncnQE6g2GuYQCyJf+Ep2brY1EG82MM5U8y5lxaj5RiiWVhkxo+AFXOVNvYoNzzJsx8IFpPpzV5c/ZcgEXfp1CHt8ZAW3JDY8afJNEYMAjR0q82B/avj84VQHbmAsG77TwO4HkYRPUucBTHjvARJkttJkrgDSZ4gPeWr7FVKCMBKvZRbf+VgZBuCXitZYCPvENdHWhMg09HGRUs9WriWfL0HWghIL7m7u+tQm9jMouBjVkXDw5GeIFe34aa4Vdv3qPCtTF8ui8w6oEin/RPSGaCLXoig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by KL1PR0601MB4615.apcprd06.prod.outlook.com (2603:1096:820:81::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.9; Sat, 7 Jan
 2023 03:47:42 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::6ddb:f49:dd40:1b9f]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::6ddb:f49:dd40:1b9f%4]) with mapi id 15.20.5944.019; Sat, 7 Jan 2023
 03:47:42 +0000
From:   Angus Chen <angus.chen@jaguarmicro.com>
To:     eric.auger@redhat.com, alex.williamson@redhat.com,
        cohuck@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Angus Chen <angus.chen@jaguarmicro.com>
Subject: [PATCH] vfio: platform: No need to check res again
Date:   Sat,  7 Jan 2023 11:47:20 +0800
Message-Id: <20230107034721.2127-1-angus.chen@jaguarmicro.com>
X-Mailer: git-send-email 2.33.0.windows.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG3P274CA0018.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:be::30)
 To TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TY2PR06MB3424:EE_|KL1PR0601MB4615:EE_
X-MS-Office365-Filtering-Correlation-Id: 77b7bf46-096a-4ad2-9188-08daf061edb0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rWLiwboBLhPlCTECsLWr/0yiNcRULqbtQpsfSbHmlRZgQL6LwM/dXq1Dx9m12oCOJL/WhqrZzn8ML97ckPraRrY89ZUMvpEBcWGJT5C4L6FctWdrmQQsDJ2ec13rDIQlvkX5LPF6YbdwIzDPFrWAGMCO6JB9c7dVNU3iMrBMY5LPnpVh4DqBfHR31Dzm6eRwaQO2wOcqY/vQm3eW076zOmikgIgqwbhoP9iAKx2wjnYcJ9yJMkpxsmZFXwJXUC4sVqODNwK6P7bP36o/9NdYIIf1IsAtUcXfuLLtNhtIyW+1aNmaFdt6BsjFrugYUGcMgG+ViirUbCg2tM0JJHuj/zzriEEAxRI+bn30lKZcrb8+m+uX8FQPvPcd0dIi29iCft1DLBnXfKWANSzOc7HhRFkZlQjqQceHVR4RCHFZRUd4SIVDHBU6tuuuC3OmFVnd6w8Sh7HGmZDsC6p4P84agUTKEXT8Btt85F+PAXXOp2Ue5f6q2Meqj67AzjBs+aIPZ4NTfQHaVFDNSfkOXlQrpGmpftOuSfM6KAlES8kMSJyn0DRm+vuAVmGezfdbK9ngnU/OGuUMB4tkysb0p/Be3i8rmaGE3Q4s/QblGxif9EeSbTkYUcmtcX1rXmAtWpC8KgpnVrNpKoCqTTE2+LpMlsVKkMDpLLrKHHfJg3LDqBu0oLfQ78StYNKS19K7cfMxpweNAkVCMDoODyPKF+xR4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(366004)(396003)(346002)(39840400004)(451199015)(36756003)(41300700001)(4326008)(66946007)(66556008)(8676002)(66476007)(316002)(38350700002)(38100700002)(86362001)(107886003)(6506007)(6666004)(186003)(6512007)(26005)(2906002)(52116002)(44832011)(2616005)(5660300002)(8936002)(4744005)(478600001)(6486002)(1076003)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?C4FAmbiW5QeNrU5j1PBozXH8aPZjQ2033oxZ7IYNLJax6XdNF/QizkR+oD3d?=
 =?us-ascii?Q?jixScKHqAgItbY9TZklBMHiC6sD+W4AlcpLzr5TMVzJmOuIHtVDeGoQ23LAf?=
 =?us-ascii?Q?jKFmWecWFUkbUDH2gbrqOzwfFwDJyW/JT47O+ilvCqu+GuXPWmTreli87m9j?=
 =?us-ascii?Q?/sqK0hxRdlg/B158prHLp1IWkjkEPjTq1L8q+yr4bl8fmIO7hEPBTr+6Iilq?=
 =?us-ascii?Q?UHsBhTCfl0NH08Nllyd0Ro9bGf7UWV6DPLrD156Jkgznu6bYgc/tLkigUAay?=
 =?us-ascii?Q?xInDkc35470UrdgukfjwOLSPw3PY0vMe5PmiY2mjNoKxaa4fswO652HjnT92?=
 =?us-ascii?Q?MRwD2N/njYRDpSEHn1+xerF6YXYGZwjkM1r0PwcXzgtnUxR6g4AwFzr9MGJQ?=
 =?us-ascii?Q?PEl7yJDXsSGA+kFdbqQMpaoKkGN/f/2BakntA1AFTKkGT4OBnzSDsbvA1d4O?=
 =?us-ascii?Q?u2FEhx/xBcUkkNJ834t7+hkspPW4PpMbqspqPiAVLGiH44PYBkSsYUpOEbOu?=
 =?us-ascii?Q?KtphzOvrOnzrOcxImTv7/yTVA64wOAYi3RyQ5vqAmJQxiEJ0BDr+E4t95OQx?=
 =?us-ascii?Q?QHn6H0rTnOlF8MxWLBd/fTT7sHYdOaW5VQBCjxzMlK28kXf4jwOFiX2nEufO?=
 =?us-ascii?Q?6fnnWJy4TSfgN4N1mYEnmBaHD9vI0azE6/uodYC7nHoUn6QCjpUb3l/YjWrr?=
 =?us-ascii?Q?NmMMx5EUwsYHOVWctNy/GMhu0SGaL7mq1+msZKWYGwyYHtoQWtz8CvCwIDr9?=
 =?us-ascii?Q?Hf8tZTlgJeC2CmlcxOUVM7YteMIen3sjVqc1IZoFJAv1iL9Td0qNC3utHU44?=
 =?us-ascii?Q?csrxMA5NYKm1K7gtZQ2LvJl2aqWwtPARWy5yrPc3YmmNEj+WMoXdqkkW9h7w?=
 =?us-ascii?Q?n2oQfkTnL1EA6PpKaHOA71Hf/7bbC7k1ygCJ6gZ7ksJm2w3c2eWq7kkThAlO?=
 =?us-ascii?Q?ewf2R9WwLlxfTA+EvcjChh+qeq90y1CaO+iBIan/VeGu69ZkwL+dr9IRmD8x?=
 =?us-ascii?Q?uLld+nf51P9uBmRPBahMIfAGTK7ijQx9ZtL2ITq/H5+A+L14EYqYg4qKtJAR?=
 =?us-ascii?Q?BxtC216rE+breszFAqAYhWd2FQ2O8qXYjC8t48a9oEHKBLNjNybZuXAqpokI?=
 =?us-ascii?Q?VVwgif5v3++c0mNirD80ZZWJnczu9OJlm3jOjQDCrBnjiYYVYiiqWrCSChZb?=
 =?us-ascii?Q?+2iBxveVhFmIGcoqbLidauL3KWlfKxuRJeF66G0GUksLY9pww5ptXmr41mc3?=
 =?us-ascii?Q?n64oJIvsA16Ffn5DryUQKGjkRBQN6CS7W7eWshaMaYCxzVuUs06ZO8+PFhW2?=
 =?us-ascii?Q?rturOFamrFanPuQnYlgsAm9wSI0LZLwTwp4fz9dPZxo5M9JiUD4Jfl6YjHdf?=
 =?us-ascii?Q?9PPVXj/ZPkTkxl7PiD6vY1V7ZjBAQxeZYDOx8lo7vgSCPkm2MtRE9zJbbJ5f?=
 =?us-ascii?Q?FkrFaF9m/rKQ4w5bo6w9Ez3wyOMEuZNLyD7KhnuXUydDcDzLE1sgNL3xW+pH?=
 =?us-ascii?Q?5jKCy3zUFBjGt+sylE5vrYINW9XNX3KbH7OgBZGIBlRzrCuYXCVTUn3gIPP+?=
 =?us-ascii?Q?5SnajFFz7j36aB7Xhdq2NMRvXyyBAPJ4KGFoDWM+KbGN5ACMN40ylp+vu5z9?=
 =?us-ascii?Q?EA=3D=3D?=
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77b7bf46-096a-4ad2-9188-08daf061edb0
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jan 2023 03:47:41.9737
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TzfYFPaIFcdJG1IZlopegqLYaRRvPPcvkAA63YXGLhDI0R6t1udytM7yjigTnPMJSSjQ6WPWiWGUHIILo+ILgT/1GUjw3n4BcHrefGWLoyA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB4615
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In function vfio_platform_regions_init(),we did check res implied
by using while loop,
so no need to check whether res be null or not again.

No functional change intended.

Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
---
 drivers/vfio/platform/vfio_platform_common.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
index 1a0a238ffa35..a9ad3f4d2613 100644
--- a/drivers/vfio/platform/vfio_platform_common.c
+++ b/drivers/vfio/platform/vfio_platform_common.c
@@ -150,9 +150,6 @@ static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
 		struct resource *res =
 			vdev->get_resource(vdev, i);
 
-		if (!res)
-			goto err;
-
 		vdev->regions[i].addr = res->start;
 		vdev->regions[i].size = resource_size(res);
 		vdev->regions[i].flags = 0;
-- 
2.25.1

