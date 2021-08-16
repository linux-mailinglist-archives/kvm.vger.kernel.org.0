Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCC373ED785
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237516AbhHPNfB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:35:01 -0400
Received: from mail-mw2nam10on2066.outbound.protection.outlook.com ([40.107.94.66]:3808
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241086AbhHPNcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:32:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SuXH8od1pOgiymtiI3pjErtdIKG31cRiqvGJW2PrFPaTE1Bubt6buNJ30Ii/+vVAX9pzT3s549LISivxyF5NRxYVerZZNPkJ73gwFobehH0RoNKUhMX4v+gMwyF1OXlK3vBnhC6kkl1hczV4hVgYsL2raSazWYSWVEflQP7PbhFQK6KiCBLzmf4G6KbkOVrNzLMqOf2t6+37Jcco7xrI2ULKOXEmjufg5iPgd04iU1DHiQ4sv5s5pwIzXljhD8JBVUUMzeXZDlp5SsqFnoZ5c5lrJh3kIWtiRSsm3iG//OuBKh0DAKjejfGKMO4dqO3okC/LDB112Clx1Pus9+0J8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RK+qRyEn6iUurdQAGxrLOEHAJfm/8fA9IlCEhpWCoWY=;
 b=Vrb/XqDyiaKGWg7gTRS4Wash91QB41CGn2e3jBSdy0I7kQP1sYzTTomuxi85TypyffF3T+nt4U4URJ7mv/cjVHkHnVPnaHT6F/jhVSWymjJwZymbrof3Q3bmzrbBZSkZFqd5s+JOV3pkNEoI+AfM3StufTfXbd3UTzcklOZ4ZfhzBH4U1kaSR5DhOL8Oexxbfw/yRDqiK7CUEyOT2aybFaj0Pf6bD42K2gjO/K3p4dSw/0d8uyH1ux4HVyiCwwH0/E2RzpnOU5sQEiSQSFPlVv+L2VsiG8n2cAsJGZd9LP1xAoxXY7iP0PW86yB3ez1vZBSv6W4UpF2L217fnCUoIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RK+qRyEn6iUurdQAGxrLOEHAJfm/8fA9IlCEhpWCoWY=;
 b=yW6hc7dq11sIIjF84Kpf+FuWkAaPIm7kRyWlrofhnZRCm+2DDV5mt0RjFay8H+17B3MftJSbJh2Y50MU6As8GS/jLddow0C/9TR4A7nXsWWn6rtQ6ntvufAkTgbBm85D08CRs+cv+PlaHKCuozonXtgtK6tomgxnXFgMdAkDcLs=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB4750.namprd12.prod.outlook.com (2603:10b6:805:e3::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.17; Mon, 16 Aug
 2021 13:31:46 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:31:46 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 13/13] hw/i386/pc: reduce fw_cfg boot cpu count taking into account mirror vcpu's.
Date:   Mon, 16 Aug 2021 13:31:35 +0000
Message-Id: <1f48e6e54cac6b06b9c88d328e983fc0199ea109.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0036.namprd13.prod.outlook.com
 (2603:10b6:806:22::11) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0036.namprd13.prod.outlook.com (2603:10b6:806:22::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.9 via Frontend Transport; Mon, 16 Aug 2021 13:31:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 366700f9-2870-470d-945c-08d960ba317a
X-MS-TrafficTypeDiagnostic: SN6PR12MB4750:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB47507B632385F551AD2D8FFF8EFD9@SN6PR12MB4750.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BgBjq+E0MsU9JmcXzXS0GjDs4gXIpR3aLizxOxlQnjKoMyIXykHeVQuelQ7lk7y7BJ8EN+Mn0BWmSINRBm3oi730aUgXTvdehKyM3wSBUk9nFbIaEJArqDc96Mv04HBVzb2z6ZPQ6oh+kvhAmJ7nWrjlclYUKEUwPY9ZW8AufeJlHs737SBwPPVzCpqK/bBUThGA9H8MOE3Lj6YQP4iDKfTFVBHqR5EyGdHSfNIAzEJgvKllYAY9C7viGzCA37XBPvM03luxRXrKVzKqs27kU+iakJrbJy5ps5CZTmQtt3ce+ui41gbF7NTTJITZKm2I063ixHe9Ix4D8m9EOD5s0rA2+H0+9s7kuTPqEbzJRwY2eA593GNrhFfgMEmqXggerIzkJs7m338rtxvpOT4KEdazF5R3U6OaQ7uqGK/AHp7dCEg+uzy53xcMmqP762lNAt4wKZ5xeDumnbz4n8a8mZY9yohn7p0xAqnEAt6Okxcy8Ni4G7M26w77I3lfoJPc7k6A/3e/dZnZ+L+ws2SsycAwbSInEqDAMHnguJOKYc1h5UCCXy/vqvLT/38hz9DWm3bmP9vOw5GCMON6Fd4ICrCPgdbYoe32fBOm9FrFo/aFESeMEE9PKWnys/Dr1yTTLoOsEF+DRjF+rBTtzxh6hnaHqzz0SkaDpnqiSDp0tUUTwBNuvkEpfIAzyveyUkKpC+osy1oMpj6zfXJeGz9KuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(136003)(396003)(346002)(8676002)(52116002)(7696005)(83380400001)(8936002)(4326008)(26005)(186003)(478600001)(956004)(2616005)(86362001)(6916009)(7416002)(6486002)(66556008)(66476007)(2906002)(4744005)(15650500001)(316002)(5660300002)(38100700002)(38350700002)(36756003)(6666004)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e89qR/2z9aZPW+Ctx65esh2NSIoYuHxLQDA55XtMkhCyNScaSSvOlgRQ2ylc?=
 =?us-ascii?Q?au2lkknvL8HSxwP/XWG+YxxMgbnaSYkSIJ5EmRMHf9lvKnva60CdwKTxnk4E?=
 =?us-ascii?Q?2kERyNHPUZdpAtEgLlGYklGNbdIzFRUhGqtQ69uKPP2hf2DFy70wAF+2/eAu?=
 =?us-ascii?Q?WYTk9op18sM4pGCNbhXdE+Dw+HXdSuvtpS9EJtDN5WoJxrm3sD0LmZ2kLdY5?=
 =?us-ascii?Q?FTSC13EyTW4t9wUlIjx38fP0K/EtC4IxnEvkBel991RT1MqCO9SjPGMjXcEC?=
 =?us-ascii?Q?AFPAiLHr53C8UZeTVPXHfoSk1+R91ttcqawV0GLTZf/biT435MSBoUaloh5d?=
 =?us-ascii?Q?LJirZYehtvzca1iFYFu+no60tERik1EZwS0ObnaEFKTx2ndJy1ukybRGMLIY?=
 =?us-ascii?Q?vRkvYoGnFJ/aGM9cRxXcit3WPwX4/N5vUF4bSBFbz564gcFHA+gepEsnImTL?=
 =?us-ascii?Q?ZTWe72TtXPNMiUmyt0m4qb4vGTZFP3KRMl6RImv5nlbvHFCzpzEZukOuUtlC?=
 =?us-ascii?Q?bub5cE6/w9aZmm7gQqGEEwkbmI/Cj/+vmLIqCw9YlLr5s3KD1vbios8ZQGMF?=
 =?us-ascii?Q?HojRzdNsRRDqqTKE6LchVAS81lNk56hOjPjNxbfX465/B47KEepUARBSKsA8?=
 =?us-ascii?Q?4MNzBYfJcFLdLoBeT/MZxgd3js7LjfbR7jqfk9z87B2wz8a/V/pvK5halloh?=
 =?us-ascii?Q?cMOdMxJHNt24RiqYmwJTdq+GrXJ7LwXxsdKt6NOSQyNdA45LcC+iiJVOXfAv?=
 =?us-ascii?Q?Fz+Cb4NTvtdENYUFh9fjLg7C2kvpbUnCAT8vOKxdnS60ID3HNlbZxY9jZyoo?=
 =?us-ascii?Q?W30d3AUGTqEctyBLr2EykaQVwfINxr1VphNFv78v+UT95INt3cWgeZ9ifaUj?=
 =?us-ascii?Q?X2TJUorVyetU01cuUvAa1Y5GejnUuwInfWf/tyVTYLybHBX5orF3MV11y0++?=
 =?us-ascii?Q?KVxcKBs8/K1UcdchWfG3HzYUrRcN0B+w4ONxjAByZex/IrMeLiDpOR94U1Rd?=
 =?us-ascii?Q?hkvRyJqN+QKFuIfyvz4tU5YALgHWy6MD30064XvdgmOiNqVx0WbEDwQLNMJY?=
 =?us-ascii?Q?g545AHzdbLZTiJsUqYNVApd5jefSwLx5Dl5B6+VCfVjbZ3/aKEgGIOUhM5qg?=
 =?us-ascii?Q?yxx+i9LoPcaPSagCcsfM2W/BMBpAD7iJW0JI5owY7Yn93gzK//c3RJTHJKZG?=
 =?us-ascii?Q?2HGTXI0/kCdjrgjWwWcz3Ahe2nUDRy8RsuFIpq9BsMseO3Koy3G6gQWgRk1X?=
 =?us-ascii?Q?Xln1D9bKWWt0eU6/a62iORk/uNfwQPWAaeTZ4QA8tyR47grWfg/vh73w1vXi?=
 =?us-ascii?Q?8u+8WSLh+GbEgffzaF6OPUQJ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 366700f9-2870-470d-945c-08d960ba317a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:31:46.1965
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3TdTHo0ohoV2DKV8mpXs2EHFCVM9qQXoI1o4Hiq0XNAbFboI6WDJcWfGZqy3Onlqo6GL2XPfQyUW6TgQoUHmIA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB4750
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ashish Kalra <ashish.kalra@amd.com>

Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 hw/i386/pc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/hw/i386/pc.c b/hw/i386/pc.c
index 3856a47390..2c353becb7 100644
--- a/hw/i386/pc.c
+++ b/hw/i386/pc.c
@@ -962,6 +962,9 @@ void pc_memory_init(PCMachineState *pcms,
                                         option_rom_mr,
                                         1);
 
+    /* Reduce x86 boot cpu count taking into account mirror vcpus */
+    x86ms->boot_cpus -= machine->smp.mirror_vcpus;
+
     fw_cfg = fw_cfg_arch_create(machine,
                                 x86ms->boot_cpus, x86ms->apic_id_limit);
 
-- 
2.17.1

