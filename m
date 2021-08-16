Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A489F3ED74C
	for <lists+kvm@lfdr.de>; Mon, 16 Aug 2021 15:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240540AbhHPNa7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Aug 2021 09:30:59 -0400
Received: from mail-dm6nam12on2052.outbound.protection.outlook.com ([40.107.243.52]:54272
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240863AbhHPN2z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Aug 2021 09:28:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OqxpuU98vEVwm/RuW80Wrq0F90Xf8OvwH/j8+Ezm/B82EZuJlnlHLC1PDXiFkASvaFcdmdT5mtjYLr0sfJdH20X9c6e+JvaNwiTsCrlDUZnNQbIYLXMwv3tcIYuuPt9LnCN6wnAT3Wx9e0aHC60m5SYTySeFfHNDxnXLxefk3V0A6A4gEHdfIbVSwZdy4lvU/x8/riMv+qj2uPypTr2lKn5C24Udt8uiUmv+Z638JnBTq1bpoQkvHJszCi7wbQjA1sp14Z90Xy1xO7S9xfZUGwd3UVd16n9Dp9pWG5MDUVLyuTg+RGbe00E4C+0Dw/dJTVr+Vffzi9z5S1m+nTSO0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fa3o1BM3eiT1R/L3CWJkvhGyU1P4SYCHUKP/SZzLdGs=;
 b=ACD8XSDsAKy4XZfbdVbMwkuwAabGvc5nun1cY9XaWt7LKa8ufVWAFakf5azsQCHLrOExhBO71l5AAOyQJk+AuqEe+HosIKMKzNN587ncWKvfFmeVpKa+NTek5HkuE9H2hjNpaBRq8RAu9biM1t/Nceb92yT1K9LtncewcRiD29UDXvLGLVv2/CKSn/QeYy8jeI0wv3ha8JlukYScwv7qCG2Jo2Gq4CCc5fw95f3YkI9PS9qDa2+GyErHwNEXVzajCYIccVSAWGS6YHWdmgCG9QpB3o4TZbHs2GmBHIznc1QVtRCGQl7yVMdXI8585vPJYagAKkmdH3rqJXUUEtWyyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fa3o1BM3eiT1R/L3CWJkvhGyU1P4SYCHUKP/SZzLdGs=;
 b=z2jmEOhqPGUwbD4MlhpPkX40rclGz7V2rQRX1wXoYZ4ySUR1HQklP24pbsA2g1F5Fd314GZkvIZZDzOYRdIKySlpqoT0agpX9gLowTfzfvzub7sD0Fpi82wuJMMmwWkLxFLJGCvKXgNn/20D6Ew0vty4m51joCebbIw/vRXEPyU=
Authentication-Results: nongnu.org; dkim=none (message not signed)
 header.d=none;nongnu.org; dmarc=none action=none header.from=amd.com;
Received: from SN6PR12MB2767.namprd12.prod.outlook.com (2603:10b6:805:75::23)
 by SN1PR12MB2366.namprd12.prod.outlook.com (2603:10b6:802:25::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.19; Mon, 16 Aug
 2021 13:28:21 +0000
Received: from SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73]) by SN6PR12MB2767.namprd12.prod.outlook.com
 ([fe80::491e:2642:bae2:8b73%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 13:28:21 +0000
From:   Ashish Kalra <Ashish.Kalra@amd.com>
To:     qemu-devel@nongnu.org
Cc:     pbonzini@redhat.com, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
Subject: [RFC PATCH 05/13] cpu: Add boolean mirror_vcpu field to CPUState
Date:   Mon, 16 Aug 2021 13:28:10 +0000
Message-Id: <eeae2e7593c7ab5771158f9552d6c08a0823c115.1629118207.git.ashish.kalra@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1629118207.git.ashish.kalra@amd.com>
References: <cover.1629118207.git.ashish.kalra@amd.com>
Content-Type: text/plain
X-ClientProxiedBy: SA9PR13CA0152.namprd13.prod.outlook.com
 (2603:10b6:806:28::7) To SN6PR12MB2767.namprd12.prod.outlook.com
 (2603:10b6:805:75::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ashkalra_ubuntu_server.amd.com (165.204.77.1) by SA9PR13CA0152.namprd13.prod.outlook.com (2603:10b6:806:28::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.12 via Frontend Transport; Mon, 16 Aug 2021 13:28:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9372f728-d3fa-40fe-6f48-08d960b9b79f
X-MS-TrafficTypeDiagnostic: SN1PR12MB2366:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN1PR12MB23660BB7DC677201FA4544378EFD9@SN1PR12MB2366.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:118;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6QpERTbdahWFaRc7aCjzrznw/HPt+5FrK7Y/iKe/uSCp4ZJWqZcor6PVi1CTdwwVTSpGWp+nFkS2Zr8T5aXBrXU+TzRjiN84tTzcTWUjX2s4kbkAq1jVURRI7OqOsjUphmopftLsyu0XbKZA8XaHjRD31oOwIl8atoXDoTmvfCxKd1LezmPFhtY9My4/m5gxImDYdCxaR3UmKb2usig42OsKVb1PveJhq87NvxsRHECFno5oL3YeGVIb63EYgNiGIlx/4IGKeKDIne+qde5SrzW9/YhLDiuCLDQpIGgi6bAJnyx+82oK9Iu3L+5LNhezxxvmWfEP42kFnu9yuxQ0qFJ+njoVQZFCoqB8Bc3Ghmb57Mw4rbBWy9IiJwkl0RQ0Z1nWlFdCXH+19/X4a26qu/2Exe5ugqmwVynXjoUq2T567+gB1tXYpr0sIEM4il78eSwsCFRRlGti/fQGUv1/sVqfVs5a41MwWNoQWypI+Zif6v7n0vHDDNYQbixZ+jKyvjvsEqNAS6Ovz9xLI2ZciQ/dn6Z9XUTvTS7Y1JOrAozUB8LD94sqcPF417ySR3DGgd8x8Y4aNvd3G2abmkowPjZ955ojNmSOfOQ0BDxR4OYMsIzSS1aq8H6wvpkulBbeVFNsRBkzA3kPz0WoMhs0uk8ZpGDnYKb4Eyezq78NxtPxfuRtf1Sa2jsqdiALLmUUMqgL2y6H4RqPXjXWNhhXHg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2767.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(7696005)(38350700002)(316002)(38100700002)(956004)(2616005)(6486002)(2906002)(6916009)(52116002)(26005)(5660300002)(508600001)(8936002)(36756003)(66476007)(4326008)(6666004)(66556008)(66946007)(186003)(86362001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DD5Ll4dDxikEbGgrmiU7eT+qiIVog15iA8tnbk4P+BfUK6WjvorTWkk8/Z3M?=
 =?us-ascii?Q?IB69/FMvjOmZA8nAXrBVdQp5aNVlX3yE6n6fpHgOQZjcB8jrQPPpiouVdPeD?=
 =?us-ascii?Q?Y2wre+aCW/aRnLxN2VxFXrZCOLiXNI0NrAi3ieelRbbuqAIbmIJGH8ESvtCv?=
 =?us-ascii?Q?OB4O4Bzgo9ufXd59T8fR0I8jqa2z4sQBgNZ5dWiFkkUANfTJo/MaorjmQZCD?=
 =?us-ascii?Q?tlKoYKO3wfIKgDW21Z1SeWNHZYNepVd6B2gUL6aNmJSDOuVogxhTi9QuCVZ/?=
 =?us-ascii?Q?KRHXnMhR2smDu4IU4ZOdXiO8vnbe88BTlUQU8lp7Yek1SMAylzz3CxjuX4uv?=
 =?us-ascii?Q?l+M3XH99i3ct7iAl4kH/uEYHHBDOMeCH1yv8Yta8224ukX/yJsjWQW8qZx+a?=
 =?us-ascii?Q?UiUwTwgF2MEev3Fkc488F4gflzsohWnY0DlykzsHLF1rcLpNTybNCARAd062?=
 =?us-ascii?Q?LW0L4Csv4aZF8QlkE3EwaYMV9bY8nQaOPbTxBGyAVgz9RNhoNnvfoVLNw9XC?=
 =?us-ascii?Q?4Fb7ctpUBkZR8scdo+41t4vqjoC0JUVP+U36D0NtWFetNpVCpg16llvynvZd?=
 =?us-ascii?Q?90kITYOH8uyUHuvBaGE0h+YN8fx2dyNyYRH7HTTt/6UZWfE6DkdtV2IBkhCR?=
 =?us-ascii?Q?aL+7eJTGuhZ1PFYYwN3XDU34k6GJ5d9ucgF0sQ8hR5aLD6UctccGPgh+SYnr?=
 =?us-ascii?Q?pbyvFQaJ8YGvZzkbn2edQn6YVLeX2l+WgDMGC9jvQrtn5RMIfrT3T02ErHfA?=
 =?us-ascii?Q?TPx//K35dnjl+HvSURRPlUraRuECzpauoSoYiDcLKNIDW82kzOtCRfQL9oag?=
 =?us-ascii?Q?131n1oXx8OlFw7whaZHtdp5B6SB/ZQiudx36nwKfbTnzr4kmGXQZfzgUkDar?=
 =?us-ascii?Q?B+6wSm3OLoCiW85Gnl72q0x9MLTyPdHCrz6t2+fByJ8YuTyoL1UFtdRph+EM?=
 =?us-ascii?Q?VJKMA88KOW+DxSxWE9sdscIrZhb6kWJ2r42iLQ2xODBUY5bQLZPFwQHJd0sH?=
 =?us-ascii?Q?Qu7HDwJgkfNJvZyMYapeoe6OLEnss3MixmxIh8kzgbF/zalFo9TT4cF3a8BP?=
 =?us-ascii?Q?OMoq1ALAleRrX0ZR5JmsPQSCdxgSpqHZuY1T9HKpA9c00EQ3NKwUsTPWaNAx?=
 =?us-ascii?Q?1IdAicZxcZ26IeqqWd9B2uavCZ/7bl9uHHPc/84lPLLd8S8IePOmt/vRpd/z?=
 =?us-ascii?Q?lNr5kLdhT+Kw2gubhGO8Ys8Qg7C5rGzoW35hCVQ4Qg356uSkfBqWKft4gD9i?=
 =?us-ascii?Q?sceLejjUJ1EoS8hYlUsocYXfjOJZFMJ0elqHTg7Am1j43BduYm+4ed6SFWoL?=
 =?us-ascii?Q?2g26lZTNjW5k+eVtWLIPcQn7?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9372f728-d3fa-40fe-6f48-08d960b9b79f
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2767.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Aug 2021 13:28:21.7010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: W3Qk0cGk107Epz9QlSf3qzPeIFD3+IupYxhB4oQAEih+ZI9EjF4xLxspxYEmf7mcvd0ri+hBQbMymk3lj1IigA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2366
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Dov Murik <dovmurik@linux.vnet.ibm.com>

The mirror field indicates mirror VCPUs.  This will allow QEMU to act
differently on mirror VCPUs.

Signed-off-by: Dov Murik <dovmurik@linux.vnet.ibm.com>
Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
---
 hw/core/cpu-common.c  | 1 +
 include/hw/core/cpu.h | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/hw/core/cpu-common.c b/hw/core/cpu-common.c
index e2f5a64604..99298f3a79 100644
--- a/hw/core/cpu-common.c
+++ b/hw/core/cpu-common.c
@@ -269,6 +269,7 @@ static Property cpu_common_props[] = {
                      MemoryRegion *),
 #endif
     DEFINE_PROP_BOOL("start-powered-off", CPUState, start_powered_off, false),
+    DEFINE_PROP_BOOL("mirror_vcpu", CPUState, mirror_vcpu, false),
     DEFINE_PROP_END_OF_LIST(),
 };
 
diff --git a/include/hw/core/cpu.h b/include/hw/core/cpu.h
index bc864564ce..a8f5f7862d 100644
--- a/include/hw/core/cpu.h
+++ b/include/hw/core/cpu.h
@@ -402,6 +402,9 @@ struct CPUState {
     /* shared by kvm, hax and hvf */
     bool vcpu_dirty;
 
+    /* does this cpu belong to mirror VM */
+    bool mirror_vcpu;
+
     /* Used to keep track of an outstanding cpu throttle thread for migration
      * autoconverge
      */
-- 
2.17.1

