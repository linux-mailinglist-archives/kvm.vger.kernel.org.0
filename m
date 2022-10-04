Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 779895F451E
	for <lists+kvm@lfdr.de>; Tue,  4 Oct 2022 16:05:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiJDOFh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 10:05:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbiJDOFd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 10:05:33 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2045.outbound.protection.outlook.com [40.107.100.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7C45C374;
        Tue,  4 Oct 2022 07:05:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LzTMLuFhbebQ3PVFQbrGalXleamhnjdGy67eaBs3+gaU5GZOG0km6vGguvWGfWaMiqaTTlczZHuYViEtAgA5fZGuX0NLOLHnPj1gzfa4Gxug92lKyGwM14h+q7lt6k6jiSEt2iRruLTbxIGo8a8ksYw1XtRSwEvvlntU9vmInb3bxNPtw3ax8ZN71gjwJPZ/olqQDkyt/JzHIHA+dcGAN2pXP0AqpGYP4CFdcXLdjLaLg3SdvJpycsfj9W7Dg9LoWUVHzNMKaUyYwVykhX1qSv9omyVUcVWvyZHF3j8VIFaod4kT36PVllrkINO/OPJqK9bWtY7ZKtkHfBz8/3eqPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0XEXBX3H9xx3e+6i9v/FT6F9IGiFkKHdw5Qsi+IZWo8=;
 b=YbqFJWIZv+EHSsEaGdvdPYy+5arzZNUoNkzwWQnFMF3g4D55eiNAINd4sRub8IFrrHq82iT9X6ArZnbNr00huHG9YjvmTkTzJHRGuBWMBjU9ysyZvSbPfHXhR13zZhp3KZDw9/mvMKH72+YoC9VD9CXlllnhINc8hkrL/jQNXzHeXaYA0ct6ypWlvasSuyHgE9dG8ncMj9S/nP+VZaXRvHaIb4tC38kocOkUUt7UkcTea/k26H+JI8gHlnVLvoxQr1DrSPhR0KsDByR2aXkx5NtwBDYG6556fioF1l6ddXgA9ZV76G18MEYVWw/F7C2T07Hr8Z72PQkNTtu6Q92Gog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0XEXBX3H9xx3e+6i9v/FT6F9IGiFkKHdw5Qsi+IZWo8=;
 b=p8Qec+rckRMmVhZBtUUDE7DN8vzwwegwEvAGLHjXyXt7Q4/4J2u9HbfSpHaZLU8cbKyY1ch5TbfgX2iA/GcrFZlB7O5G0+cRnDPDQpWeGQBlpR4YWfpacx+I+gZk7ZYL410qOo/s+0gtTnl+kfaWv6F/qEocMp90AAjUPGgRF1g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5874.namprd12.prod.outlook.com (2603:10b6:208:396::17)
 by CY5PR12MB6036.namprd12.prod.outlook.com (2603:10b6:930:2c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Tue, 4 Oct
 2022 14:05:28 +0000
Received: from BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649]) by BL1PR12MB5874.namprd12.prod.outlook.com
 ([fe80::ea28:b6e6:143c:8649%6]) with mapi id 15.20.5676.019; Tue, 4 Oct 2022
 14:05:26 +0000
Message-ID: <986a5886-4ddc-aa88-db52-e8781ec95aed@amd.com>
Date:   Tue, 4 Oct 2022 09:05:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     tglx@linutronix.de, bp@alien8.de, mingo@redhat.com,
        dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
        venu.busireddy@oracle.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
From:   Carlos Bilbao <carlos.bilbao@amd.com>
Cc:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>, bilbao@vt.edu
Subject: [PATCH] KVM: SVM: Fix reserved fields of struct sev_es_save_area
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR03CA0256.namprd03.prod.outlook.com
 (2603:10b6:610:e5::21) To BL1PR12MB5874.namprd12.prod.outlook.com
 (2603:10b6:208:396::17)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5874:EE_|CY5PR12MB6036:EE_
X-MS-Office365-Filtering-Correlation-Id: 479efe3a-9676-4c27-5f2d-08daa6117cd3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fv19PbL6Pp02R2O5oBbTlWmoqoIvsEvxPF4BTNXyPACQnNhndMjit1LAhTFCtVpyP+CTJd5WDulo+3a4bPwfZAt9aeSrp2OocrG74cPoNm7bnPttIqHr+3+UbfpD8FS7X4rDonlJ1RYKjSP6Z14frJcm3eDystJAjK7As7JdYXefHr3w1K1Bf/Qo4dsWZ8OQILqeidhtsd1lsvDtgSpaz/HzFpwdI9mlkj7wzxrIWkTo7OP8bl1YMARzAhv2Wfq08W7U66UUNpkLdiQTxVK+k24rabEd9fAJt/AwWMZ6qT9hPhkRUQUC2Fgao3biWCL4ZZDiJlJVlm1F1qIcYpkorx681go7+kFyt7Wz+cYuDsTF2P7tLAIboo6zkncDqWBT5qcgEdGImqOROCbBW0CfB3GhpwV54z1l8Gatv2YdmLmTxvcG+0nT6f2NQ/MBuGs/aUo9SAGu+XYhRyo5+8CPzyrXPo14gpGhtyXjzngGajs6xtJEgY2hxYHuwjWdPSYnWw9uts4NhQQ9CXVyBtVC+WsQLIlZWJL5Gd6vFhmU0p1dAD+Q3XTcpaXJeIg79tj4ZGek1HPhinQLW2nYps0lzsihZppo1ZKgTL6QwSr5CUMrmaBSUI3+bzD05L0pM3RTzHANDYyp1L+DosUeB1LHL5h7dlmOJjxrTEoXw5UwUVEVYUh/PUQmb7BRsmsouiJvYsKiu/ZAt9DPdOlaPINaQqG6Yq41wbBLKYxTFwkvpztZHQ752PXgcDBGmsBqIeX//8WEdFv1Jc0l0jZcB7N/TLIbNWdPcqktkZPekIayeLA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5874.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(451199015)(66476007)(8676002)(4326008)(36756003)(2906002)(66556008)(31696002)(86362001)(41300700001)(316002)(6512007)(26005)(38100700002)(83380400001)(186003)(2616005)(6486002)(6506007)(478600001)(66946007)(7416002)(31686004)(8936002)(5660300002)(44832011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXc3ZE81ckc1Y0JtNGFBRm1Lb1BzaUdkL2QyYkRrdldZUU1DcnEyNjRkMTMr?=
 =?utf-8?B?TkxKWk43cFhDSU5SdGdZRkszcVArZVdqbGovbHo2WHRENXpPQ0ZOQjdSd0w3?=
 =?utf-8?B?NlM4V3Q1MmptM0Zjb1d6QVg1ck1QM3NaWENJUERnQ24yUlVUZmlxVWd2WjRV?=
 =?utf-8?B?YzB2bDFUNE1LNU1jY0JpRTBYbDU2ZlMrZFJBR0xiREdIZGU5RUdpeThadzZw?=
 =?utf-8?B?bjdMK0Y1K3V2Y0xFUnBlOTRQejRtTS9UN0QzMW9tSnN0SWkzSEJBMEJlZVpW?=
 =?utf-8?B?MXd1ZEhzSFFGdUhUV2FadXY3bEJEc1k3eEtDRnVlMXpBdzFkK2hYdG1Ec3FF?=
 =?utf-8?B?YllZSGRma0FucTlCai9jR092b1ZidzBUZUxjR0l3M3k3Sk9sclRKb2s0d0pq?=
 =?utf-8?B?NlE3aFBBVFlFd2FYVlF1M3g3ejliVlRueGFCcjBzRGFIMStuZ0dFckVpdzB5?=
 =?utf-8?B?Y3h5ZFJseW9RU1NSS2FkY0VHVDBSQUQxalRXU0t0NUF0SEIwN2tlOVlKamZa?=
 =?utf-8?B?cHlNUHI5T0JTdmFGekxJM3dOR0poTDJ1TkhKN2dJZCtzRkwrZkkvQXhvNVh6?=
 =?utf-8?B?ajAzcU5WdFh4NDByRzh3N254V0ZIOVJBVWJ1SGUvb2daNWp2bEllRUxHTXY1?=
 =?utf-8?B?YUl5MkhqWXRGMmpjVVo2Y0pYNUdld3lYWU9qOVNpcmN5QkVOSWx2czNVWm05?=
 =?utf-8?B?b29YbUxpNjMxZW0vUzd2ME5FazJOcUxZQlcxTVd6ZzBLa3ZMeHVza1pFSE1K?=
 =?utf-8?B?VnZuUVhVUm43ZGluZ2RMRFhGYWFjWjUxWG5ZMGFuYktSK0FFL2x1Tmd3SFRK?=
 =?utf-8?B?Q00rbWVLTkEwMzg5cEQ4bGZYL3lzcXdIZDdlMlJKUjRZR3VIZlhRMFpHWkdE?=
 =?utf-8?B?Uy9GN0xxanhmSzkyWkVNMTNiYjJ0MzJFamNKZ1ZaZnFIaGpNQW8vYUFRd1B6?=
 =?utf-8?B?WE13OVpRV09ZcU1KKzNCdzNZN1VNRXlDSmg4YnRWbytxanJrQks5MzZhQmY4?=
 =?utf-8?B?bDdESXB5L1FxdHpnMkFuaEFEQ3BjVjRGanYxTVg4WTVYalI3U3UxSTM2VlJB?=
 =?utf-8?B?NDlWN0x4eHBRU1hnNjRqeEZzN1Vvd2M1alhabGlOT2t1WldIV0U1NmI3aCtX?=
 =?utf-8?B?dVpFMjV1MzF5MUVPdmZIVFBjcU0wb05VYmhjV3NPTXEvT09YRGloK3h5TWND?=
 =?utf-8?B?Y3czaHNHYUlTZW04WW14TmFGOHpsRGV3c1gzaXc2d0JnUVpTNEVEb2FUN2ll?=
 =?utf-8?B?clJWMjl1d3gyR3k3OUNaTnV5YnpLK05VRWV4clgwejlMTWZHT0VkT2ZRdzg0?=
 =?utf-8?B?RW9NSkRhYWQ2dmEycHExeGI0S2JEVjR1OGU0S2k0SnBvL0hPZGFkNkM2SUxQ?=
 =?utf-8?B?R2hUQ1NqR3VLa2U3N1BMeGN1dHFSaG9IY2RGbUFuWnRRcUJFNGZHbVEvWDA5?=
 =?utf-8?B?T3BRSzdOSkRsSm5iSGNGOXA2endJSzNhRDdtWUI2dDB2M3J0cS9xN0JwTlZs?=
 =?utf-8?B?SWNFbmlnNDNZS0Zud2tqTFFhQ0RQUXNuUkdpSWR6dlA3bnd6VWQzRkJucUcr?=
 =?utf-8?B?SDdFMFFFMlk4R2Ftb1FwUk14N0ZYSjhLTWQ4NlBHdkkrNW9UamNGYzYzVXZk?=
 =?utf-8?B?NWhGbVNvejMwcGZ6VytqUkZFZEd0UnU5dHo3NmxnTTlxSURWWGluZ2QwZVVk?=
 =?utf-8?B?UHFsV1dOdm16MERkQXVRMTdremc1cHFlR1d4NzBmckRUY0dNVjd0cGtlQ01r?=
 =?utf-8?B?Njh2QWZjUllhbUFGZHc1dFVWMnJVbm1oczNDRjlsTHAxSXdhdzFrQ2tmaVFN?=
 =?utf-8?B?UkNwc2N2TEJyQnd4TWVkbWQwNzRHV0hCRVk3QVIwQzNUNjYzcWljaDVqYUIv?=
 =?utf-8?B?cFJCOWdCa0RyUUxvQmJlKzNoOE1HMGJpc01QTWNDOHZEVE51S2xUeWx6VjJo?=
 =?utf-8?B?VytGSDVSY09GSzZZeENwNndWaGEvMktkLzB3RGwvV0kzVHRTZDJiamRuNkxa?=
 =?utf-8?B?QkVnRGQ2c29JcVdoQnFZbHpWOWgrZDQ2aWxKYk9xQmtZNTF4Y2c3QndpSG5k?=
 =?utf-8?B?NGVJNkJUUzNjeU4yYUJxQmVYMFRXcVJwQTAxQmhHQWZPYW8wczBxMmdrV2VO?=
 =?utf-8?Q?AAnNE/4x4Hmf92RM2IWvfsLJU?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479efe3a-9676-4c27-5f2d-08daa6117cd3
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5874.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2022 14:05:26.6634
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5EtV4p3xptCkF7/GukRykM4mMAzebk6h4liUqM3fuiCo99DSnRDHW0A38elbG6cpQFzlUGu0wYC7ioFe/hvRiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6036
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Reserved fields of struct sev_es_save_area are named by their order of
appearance, but right now they jump from reserved_5 to reserved_7. Rename
them with the correct order.

Fixes: 6d3b3d34e39eb ("KVM: SVM: Update the SEV-ES save area mapping")

Signed-off-by: Carlos Bilbao <carlos.bilbao@amd.com>
---
  arch/x86/include/asm/svm.h | 12 ++++++------
  1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index 0361626841bc..6ab45a0389dc 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -393,14 +393,14 @@ struct sev_es_save_area {
      u64 br_to;
      u64 last_excp_from;
      u64 last_excp_to;
-    u8 reserved_7[80];
+    u8 reserved_6[80];
      u32 pkru;
-    u8 reserved_8[20];
-    u64 reserved_9;        /* rax already available at 0x01f8 */
+    u8 reserved_7[20];
+    u64 reserved_8;        /* rax already available at 0x01f8 */
      u64 rcx;
      u64 rdx;
      u64 rbx;
-    u64 reserved_10;    /* rsp already available at 0x01d8 */
+    u64 reserved_9;    /* rsp already available at 0x01d8 */
      u64 rbp;
      u64 rsi;
      u64 rdi;
@@ -412,7 +412,7 @@ struct sev_es_save_area {
      u64 r13;
      u64 r14;
      u64 r15;
-    u8 reserved_11[16];
+    u8 reserved_10[16];
      u64 guest_exit_info_1;
      u64 guest_exit_info_2;
      u64 guest_exit_int_info;
@@ -425,7 +425,7 @@ struct sev_es_save_area {
      u64 pcpu_id;
      u64 event_inj;
      u64 xcr0;
-    u8 reserved_12[16];
+    u8 reserved_11[16];

      /* Floating point area */
      u64 x87_dp;
-- 
2.37.0 (Apple Git-136)

