Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60F165EF824
	for <lists+kvm@lfdr.de>; Thu, 29 Sep 2022 16:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235316AbiI2O7b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Sep 2022 10:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbiI2O73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 29 Sep 2022 10:59:29 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2070.outbound.protection.outlook.com [40.107.243.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3D213F2A8
        for <kvm@vger.kernel.org>; Thu, 29 Sep 2022 07:59:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TSoQjr4CSFyvXvnggJmmxgPSdVlQw4c1fhO4f1m9+4eGKD8dbQNqxxF455tXnBZsLrwKAM0xTxaLE3OWD63qWZB8kAqg7IpfnMr5julLzX3Cknn35jVmxLRXojBOZBsIWfQCycB+/6xax/415nkup1m+6Hjd0uEVF/uDxC493tXexJxW1gmZdcE+GjjSlIHNTw1SeUkSueKrFpMxrVtBUm5Vm5QJX3TNDj5+6pVFOJ2rNweA/5mrk76i/OmghF8bXdXkPun00+m86ZRs658RbarscwcutqByQrVrvkPLNOPMJ5Oi7EgYlwITPlh8ddhwLuIyTkbvU6iGpvFoFleHbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SrCvQEs48NdGmAqTWFGWSLOHthuoIU/VUHtQHMOSlRU=;
 b=kXtnR80w1bn/bObAIESXQz1zeYiCFj/MB2+i167oNmHsx4EJLdX3E6iUOil+R0LAoX47E2blaQ/RDPWPZoe2dTYKg++rik6UPWKhl79oAibOrpDgQolTgnFiVLD/brZZeDAd4QbBIU0NtOJFE4SOKZQrWzvF+kVHEQAO7dRF/LH8+epjhQfLg1LykRHufcJ7NDzXZ+41Ca+oxBa0lZWLJvHgTrhREUKOPdcFiwaBTxyPmfrwTL5Dg7XTodbfEkuL67toEj1/TIy+mjVvAoHYNyiNdcWpuhNcpKl9HKJNGbjytCR/iQCHM5SPRVlvx/n92cwAtk25V7R0iZbAiObryA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SrCvQEs48NdGmAqTWFGWSLOHthuoIU/VUHtQHMOSlRU=;
 b=H4YGWU87uM/Z3LL0sPq1EGLVe+glaGHux+j6fp/kv07c4n8wzlATO0a0d0KiBCr0kk/d27Sg5N67mefXBHgcjgFsKGKaYy0CP8GS3geHe/exonIAnngGEMqXw2wYFdPm/kTWnMlEbIm2bgfv4gLocqghkqfpX0B/0dPTE3a7acEgcSU4M1nMAbjJeDthuDdeZa71v5cOj/MGcNRdDjTTQKbvQ7ooP+jPHLEXGxUuSjn0N3hCGE+M3rA3kXl42LwCaoSl819/eS7kopbEWL2FWFLjldaapLgYBnYkn6KIBFv+j3Tuhmvg8lvjyiThQ5OHrIbY6j4cvlNUmhVcXkG80w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DS0PR12MB6389.namprd12.prod.outlook.com (2603:10b6:8:cf::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.17; Thu, 29 Sep 2022 14:59:26 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::f0c0:3a28:55e9:e99c%5]) with mapi id 15.20.5676.019; Thu, 29 Sep 2022
 14:59:26 +0000
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 0/2] Simplify some of the locking in vfio_group
Date:   Thu, 29 Sep 2022 11:59:23 -0300
Message-Id: <0-v1-917e3647f123+b1a-vfio_group_users_jgg@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BLAP220CA0030.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:208:32c::35) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4192:EE_|DS0PR12MB6389:EE_
X-MS-Office365-Filtering-Correlation-Id: 18114b4c-40d1-4c3a-2743-08daa22b33d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i7Shg8XdktiorVK6n5cSX+zAOcOHf+y/mY2wzIhcCWa1VNnANlnUOgUNLZ4Q5Vg+JwEn2fXdAFbeN7uV6mAqIfMpT4xKUMa/TacOwq13DF8TTD6GHkvl7I3BC3V1ye+ZZAzx/eWt+z0cHcAd49ImdahSSY4pbGnwtVwVcOYsknVmQ0/JOUh2riCzMPfJUkLeIQGaI0dGMwvZxUkNNlCBdVv3NqIcwS05TvN2LdvEBuv5GvddmQmICYL0g4RLNbPo0400NalT5xD1sLcX74Qc4VteqXre3SNTltPYqciGNL3vv86/zOS+bkj1YVWovldwPcMSiNpKctyjrgXSfXxkw93iVgfFzrt8OiWKdKkJC+REg2c41cU5tQUWP77Y0r7s2hRbsK+crGhKdmjtkZm43WZ2SIUxOm3dz4JJdcJpf30rC+ynBH4ikWPkcQaPDT6gr+OgRnmLAC8je77a5cMN0PEAZ5SlgpjryeEGKpY99Y/smXhd5runcArO+OUVgubTKSlvUcAeKIyJBMbgh1oWZdom5yv34bf6DTDv5Atb/KjEDImT3540zmCMRhn6GVBxMmezSJXZs0B3/BFAKskMddvmx092I4KB5OExgeqIhF/FpgHzcO/iYDTM/D3uyjLT0EaRMgu2hVgYOwghpmPYOdJ7JYoyAvoeyKbgJeG9ZbINtvDInVzjHWcXgFtWAuhPN9AwBo6myg/jvnRkqs9fPmnJw1fIh6tibWWydUqQ5vpIgTTI/mBQLpqy4+l1aVI6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(376002)(39860400002)(366004)(396003)(451199015)(6506007)(478600001)(110136005)(6486002)(26005)(316002)(38100700002)(86362001)(2616005)(186003)(83380400001)(6666004)(6512007)(2906002)(4744005)(8936002)(66476007)(41300700001)(36756003)(8676002)(66556008)(66946007)(5660300002)(4216001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mNvdkMwFbRo2C3u0iDSlDX0znCYjg9iZOE7b7s1IMLVB67RmUznyLK/fP8R9?=
 =?us-ascii?Q?iSh3qFP+DVljch05MHUg3KiF5gH5Kw2bnKQAsgTcncOc/sox4ymjB7iS9u2e?=
 =?us-ascii?Q?NvmS+KuVf/Zvf7w2hteZw5oZ1stOUlibG3dHy4UwCtpYyoXhRXy1MeriO1yv?=
 =?us-ascii?Q?r8g2AV5nyqAcR9U7wzlyAMKekMXaYyxd9RzOMyDVI85ISBTWfnrplTGpNAeV?=
 =?us-ascii?Q?P8/5PI1IvWKQjs3bhHvMQIHwSAMFuu+A0P3JwMKGBfk36p6n5hJS/7FYZtmT?=
 =?us-ascii?Q?Vv5WeTGHrrZan1bZl8jb69+Y9pUt/5e1z3tCo+0ckPzBGTjK4TRHuYVXhNkK?=
 =?us-ascii?Q?/Ity6qNJU7vkTbhGd46ZCgImi9JYO53jxTtFKyJFeygLESxbRpvUFmOrukY6?=
 =?us-ascii?Q?NjwX1S+vr5/Fomi+AYdW5z+pQD4ULyCOrQC/kDhDFzCjkt5GMJpvKxzoMhbK?=
 =?us-ascii?Q?h4AfELz/HIKiFqMDCgiOtmofeArUvC6igpTmj5YLxvZ1XbvLOVKHfuZtYtE9?=
 =?us-ascii?Q?vFh5GqhrJx0n8+IA/DdcNj7FNPe8dhOEVaSWCnMBrgX47mX/4Zf1a++iOziQ?=
 =?us-ascii?Q?7qVh0bO8NsVvbGDECCLmahaiFggBEsS9gKC+kSHLOmlekpaQiO65GpXZ78JC?=
 =?us-ascii?Q?wV5jaMmNdct1Jsz0HXyg7flgyaanghVf6FfBej2B/w8xIFWncWkEWDFz/7LG?=
 =?us-ascii?Q?KeEVPe1SVrV9O2BISruGdUHgeS2I3/ro57J9vd9RYAkDmDb6ic8LOMqKSruT?=
 =?us-ascii?Q?nKaNhWFujL+FBXOb50JckR3ts74B8LlObAzLMQIf7XFLlVYkpPCApPAPP1Ls?=
 =?us-ascii?Q?vYXQL1qmYrTb1i/S69+I5JsT2hlIz8PUts5mqKtONuiKRkqiNNpu7Khu7gPC?=
 =?us-ascii?Q?ksJ4sZhOQ3k2lrBA0gGTsGYQ5gB1WnEIj2vjmdBgVaeSkr61KhaRy98I7KcS?=
 =?us-ascii?Q?O2yp7sHN2k5upi+SqLvTa09QTEXe5jDEVBD6oRCjBBiYTUeEcFDMqF0fW/Sg?=
 =?us-ascii?Q?iNp2LKB7wP+I7NvDNdeAjtude3GFFOkASmE6iRxnKPoE0+4jh1eR39aEp3cW?=
 =?us-ascii?Q?Vh2FjanCdcyCRrUFfL1EI1KNKfQAL9d32V2UqnXhIcylaD0HlmfX3v7wB8Nb?=
 =?us-ascii?Q?VDVDEMi4rGz5FKvN+RrFVHdDepGK7Cd/HbzggaLKYahA2C5+4h2xA+79gbPg?=
 =?us-ascii?Q?bpyuyxdgojQtFExdZLYy1nyJ/6F8oZJEWEB62keSZstXbkMfz7kmSh2/JYUs?=
 =?us-ascii?Q?1cOSN4a3wCDpIW10KsBlvi08wz/HpUaNG5e24mEjgyOQRb1y3lgk+MB0qP/t?=
 =?us-ascii?Q?+5eEvlEvRXQKBhoe9d8sbZafrIZsjOhVvXazCDaMzTuZaPHSgcjKMgY1kDaW?=
 =?us-ascii?Q?yihtiCW6hm3ddAxwtaiGT6YHdgNl2Ih5GXv4bTHTNGVZzTG39p3VnRe2oD8O?=
 =?us-ascii?Q?SMGRP2t0hh+wQ9owHnBrsbZKOrMO8C00Lb+aGqy3J5VTZl4beA4S8dckMc2f?=
 =?us-ascii?Q?8qcOb6hreDl8TGsZx2l+5nd4p41EEaZJ8/OxFr2UXDWiF7Oij0mbpcNlLSYb?=
 =?us-ascii?Q?kYHpnHwlMBG9j190Qx4=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18114b4c-40d1-4c3a-2743-08daa22b33d1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 14:59:26.4078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VB2vYAhumjMzaUCvXaG/qW9x/RK9ZH+ooEcRNvfEvmXtgz9aTZSV1JrJmpRaaNhE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6389
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Kevin points out that the vfio_group->users doesn't really need to exist
now, and some other inspection shows that the group_rwsem has outlived its
utility as well. Replace both with simpler constructs.

Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Jason Gunthorpe (2):
  vfio: Remove the vfio_group->users and users_comp
  vfio: Change vfio_group->group_rwsem to a mutex

 drivers/vfio/container.c | 10 ++---
 drivers/vfio/vfio.h      |  5 +--
 drivers/vfio/vfio_main.c | 92 +++++++++++++++++++---------------------
 3 files changed, 50 insertions(+), 57 deletions(-)


base-commit: 42e1d1eed20a17c6cbb1d600c77a6ca69a632d4c
-- 
2.37.3

