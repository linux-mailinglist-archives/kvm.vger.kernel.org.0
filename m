Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 218D43ED747
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239997AbhHPNam (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:30:42 -0400
Received: from mail-bn7nam10on2061.outbound.protection.outlook.com ([40.107.92.61]:32336
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239012AbhHPN2l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:28:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C07LAkW8VqLrIp+cl1DwLKb96IOlwd706AHNkbpqL4gP25nK2To5FzCD3rMPMBjlQn567BqVdN4saUwRF+1kqXWakQitvHqF5WlMX05C5x8BoGjHiDyR4BMQeO5nKccb9jC3d3kDo4xqSWHsp280kke0oRmB+hyirRknqC2DyghCesdbul5Aq3kJBiwnV6qqPIcgNqZAMm6x+ouVXdz9SQ/JUEElSjTTejCH9L3JAnY5NBzMiJytvO4kQx6gVdIHoctQGRhCarGt0R4Ai/vJtIXUviykAVk3rZIde+HI1klPfGrxET24HeVvHHrAFSymlSJg6agKqbMjcHHd3G6GPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYhZhADXR/irJqMLEzDn79l4rEECURMbInEwdh9OZgk=;
 b=Q85gPhQ+CkaU6svU8Wuw7I0AfWXx4iVdVlazPYT4oWneymseFbJBZQz1AYqtse/uzGx7PqPEmZqrqtpkOG6UZCzFaPbUeuljXKPqKE6f0u57w9RrlOwmhCL5zFb702J1+uqMsmapbHkCXO1nuWehzf0IyNcv36gq/LZ1nplOBurXXc+aiqPaXjBfhCeaU70Q8vnv8Ou8GSKNJDP41QVMhhvRw0Gq4gB2pzh/tC1YxLhDOqwxg8pa5kPkkXUnOXBuD7/40II5QCAPQTcMgoeysYC6BwPGIypune6K+6vOY+tKSbWlwiaOm+kI4psDs9AihSJn4lVhS1+vreyU6Z/7qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MYhZhADXR/irJqMLEzDn79l4rEECURMbInEwdh9OZgk=;
 b=nWT02fTTnOKwq+fA0Gf0lK0+3g+H9HrEDzwal4+y4bkcRggh7f9jPPTzNlH9BxSiCkO+s6HH/JoNIeae2ken5QjHKKjv3D/FofCqYp1tx22B6+4PFiEQbutgy9zupG3kETiErTyPgTLFKRAg5+OmvY4lTd24MziEOohre7fs81o=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.21; Mon, 16 Aug
 2021 13:27:34 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:27:32 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 03/13] hw/i386: Mark mirror vcpus in possible_cpus
Date:   Mon, 16 Aug 2021 13:27:22 +0000
Message-Id: <e35c4836b2b58db61a577e3bd5a642646f90f043.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SN6PR08CA0006.namprd08.prod.outlook.com
 (2603:10b6:805:66::19) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SN6PR08CA0006.namprd08.prod.outlook.com (2603:10b6:805:66::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Mon, 16 Aug 2021 13:27:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b949c9a-94fc-41ec-2dad-08d960b99a3c
X-MS-TrafficTypeDiagnostic: SN6PR12MB2767:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR12MB276718AF644A89889A3CD7858EFD9@SN6PR12MB2767.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LgRSLS01BUQ7fcQqVDim6GFobvDCqXs4VYUHNQGsDqjhSqOH8hUC7bnzApZ4gpooR8zhIOEdzyzhNT53SKE1Lpk5yacLK3ezkSlOU3/GH9ODxPITmU97375ILg0uJukXQLmdtM8q5RmHWNwKNUkT+EnFBYy5bJIKCHTFjW4W7nNRj1z7XXrawGsOpEyhnvnd1yMlKaOqzM7GpAeTsqTl2RViIC+jRhoOpICtwIhSzDNPIwsX/Cr+MUpaERkf9d+gaZBKfA3PvFZ6Neo8p12sGTNwZnjRY7heOWfZOCElPr39yarxJC67lCJvcOOV0EcABFkgDJQ6KGg5E0LHoyj4ITANJ1i6ayrC5Ps0MVtfFrOvkGRoGYWbDH81cU46Z1mnRyQYbkbq4nYK81pWGhLCEcULNQkBGPwwI71Iksm82vq+kM+Ah1Me8cNa9q/fvLvnZzLZqC6dnc8wh++KqZPr7MCkzYi2i1dSe42TJjLDsNtWGSlffPfiMapxmMyYYxwSzt1DoiWTwlLpn7RPSWkOGridZEl50xELCXzzpQ53FSqU3H8uos3bmyn9dfOR0R9x7NJMEGyKBorH3TOYoC2iBIj9bTXSJKzS2N8Dl/XiXd4tf1QkcQu5YpB3s8fYvNuPsEjnbG3l1Lda/F/qiLmmAYypWvmsJSdhmzxqHXNJNtTy3mlOUuEnI9v5DJulOElcUS6DGJ9vbLQ48y2dl8lpZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(478600001)(2616005)(26005)(956004)(186003)(4326008)(7696005)(52116002)(36756003)(316002)(66946007)(7416002)(66556008)(66476007)(2906002)(5660300002)(38350700002)(38100700002)(6666004)(8676002)(6916009)(86362001)(6486002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RI4agYfzllDqYwz6Ltirqhu6LIqcpNwH5zbGwfj0Kom4yTQ9SWiZieWcdqA4?=
 =?us-ascii?Q?vRn//eWhpHm5ywVygW2de22iYcjk1YeUgqqQOe/NNQno8K96scBnd7I4RUrv?=
 =?us-ascii?Q?XEHDUpwELh4wU0o1qQS9ODkMRd1D4IrkiAeDbieegiP/KSvd59eQzoyUSL/J?=
 =?us-ascii?Q?0RAsoswm5JbOT0a55QPJfiw65rLWAKI/pnz2KVsw5xL5dTv9giLD1NyOyFT5?=
 =?us-ascii?Q?0fHWOrM7tohVWx6NzRj1raJW4eCm1Pv3FVREtFinr/JXDD7szsrQB/qZ/oLP?=
 =?us-ascii?Q?NpY4aobPp/IYIAdtsjeWE8UQbe2m3VqTtlZX2DQ8sPbu1lgB3RR9LXekcGm6?=
 =?us-ascii?Q?P9FEOp9GvkW8h22THy2MftjKcIR/HWU4XHJ9LXuEbVW6xVOEmSqUSa6hzM0U?=
 =?us-ascii?Q?XFczNEiVkNe7/fjaZ02Y/TwrPffYjy9ya0iHIYArFCUmbUIVByTE6bvhAZlG?=
 =?us-ascii?Q?//YGQTg7gHJJ/n5+v13Fs3QLoI6EPt6AFKnAyJnPbmafuPE7gXwhDxFMZSk6?=
 =?us-ascii?Q?HbBxlLsZxq2NmhxETDj5ZI9RdrRB14Do9hAstm2oVJJE7Dc96VoTm8yRQlt2?=
 =?us-ascii?Q?mR4BE+VStXj8+iqscxYQHR72U+uVBLOimALx9qw+eQxRZrP5vN+s1uLDMUFo?=
 =?us-ascii?Q?avW4WTRSjr4g0tw8ms5XmUqnlWQJCt9ZGf0+rDhCCakEBQkxVa/fpYrOW2D8?=
 =?us-ascii?Q?w+jmk5VB4vUm8CKwlF+oS5e992wLIfX+5KPegZk10MhtIKidaYkNHas5xx76?=
 =?us-ascii?Q?EMX1FSHVIYvanVWVpW/euMBrDK5fbc1hsyktTUV5Ms7BqrKEE9b7dNkmJTAr?=
 =?us-ascii?Q?pJTkdedlGISg44NPHkKfBxNRi+U/4eMNgEShokmDhTkUTqT6Ob2KQ5A0i935?=
 =?us-ascii?Q?xBb6w9rTV482KPhRYUg8+SAeOoMNfK0W1Ch2N0MlbgLTQFy4TK6jxYu5eodM?=
 =?us-ascii?Q?re/AiHDswybpD377Qdymz7CfJMMWt/bHFjmJtt+LKWnptpzhROU4nuPlurf4?=
 =?us-ascii?Q?SREPBP2J96XriWcRI4Qg1rPhRQWuH67+h8ppvLw0W0jEmbgingYUnJxKuftc?=
 =?us-ascii?Q?+NXLb+9Jwc8D5HV+fJVRCFo5upo3s8yrqGlwY3HQPDnqwm9HVRmha33OccMX?=
 =?us-ascii?Q?4Fptmy5v5Y0P9G+XXHqUeV/k/2nvYVrW75/qcvWWwnHR7r40SxSNwcaZqlRz?=
 =?us-ascii?Q?ykLhCtGjzi2zD+OWO42suwD+xQvqchoRh47onXTx6MKcgl67IsdS/tzih+2U?=
 =?us-ascii?Q?7d2IiuHA2DEyotoA9wCvvTWjXnqxNAzHDpcsVj0FGysXIMMfNSyeT0NHZWYz?=
 =?us-ascii?Q?RQcNTyhk6nSNP+RRm2zux6X3?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b949c9a-94fc-41ec-2dad-08d960b99a3c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:27:32.3856
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2gBk6BzZzON9oz3vzfY71G+KwizzYXFdHgh3mGH5SJ3Y7VaZrTVP3K5RQ6DPPHu2/vmo3aj00rcT8s67bBEaGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR12MB2767
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dov Murik <dovmurik@linux.vnet.ibm.com>

Mark the last mirror_vcpus vcpus in the machine state's possible_cpus as
mirror.

Signed-off-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 hw/i386/x86.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/hw/i386/x86.c b/hw/i386/x86.c
index 00448ed55a..a0103cb0aa 100644
--- a/hw/i386/x86.c
+++ b/hw/i386/x86.c
@@ -448,6 +448,7 @@ const CPUArchIdList *x86_possible_cpu_arch_ids(MachineState *ms)
 {
     X86MachineState *x86ms = X86_MACHINE(ms);
     unsigned int max_cpus = ms->smp.max_cpus;
+    unsigned int mirror_vcpus_start_at = max_cpus - ms->smp.mirror_vcpus;
     X86CPUTopoInfo topo_info;
     int i;
 
@@ -475,6 +476,7 @@ const CPUArchIdList *x86_possible_cpu_arch_ids(MachineState *ms)
             x86_cpu_apic_id_from_index(x86ms, i);
         x86_topo_ids_from_apicid(ms->possible_cpus->cpus[i].arch_id,
                                  &topo_info, &topo_ids);
+        ms->possible_cpus->cpus[i].mirror_vcpu = i >= mirror_vcpus_start_at;
         ms->possible_cpus->cpus[i].props.has_socket_id = true;
         ms->possible_cpus->cpus[i].props.socket_id = topo_ids.pkg_id;
         if (ms->smp.dies > 1) {
-- 
2.17.1

