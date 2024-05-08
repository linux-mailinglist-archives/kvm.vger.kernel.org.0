Return-Path: <kvm+bounces-17003-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 91A2C8BFEB0
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 15:25:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 483D22874FA
	for <lists+kvm@lfdr.de>; Wed,  8 May 2024 13:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9C197A13A;
	Wed,  8 May 2024 13:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="URx3yHuK"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2138.outbound.protection.outlook.com [40.107.127.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450696E5FE;
	Wed,  8 May 2024 13:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.127.138
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715174733; cv=fail; b=o+AAqBq0xl08Qlso7SVToZJ381vukhLi4zzMZsA4AH1dNtQQkcjwMya9lbWB5VODOx1dAG2N29x5cjQs588EKuCq27L1oF3h5ZOJMBOr8wRdeix8tehJpAEH4XMmnFu00vKKISfQd/lxznD+XdDjMAL23WD49NfySSoOyIL38w4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715174733; c=relaxed/simple;
	bh=5CgWbz/0tjPl8chy+2VXaGvySyVKSEU74VOqQ2DBv30=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=kcd87GyIN9QyFRrQ6f89cVXxCreKJRM+Ha8qpQDVBDYhzvR9S5MxV6WzSMRU9FcgR0oa8ywrteYWjaC3Zo9ypKL9Pn5H8iK300nwK+uiGQxRfskXcdO2PlxWQWFFuiBIDoWJabYKu6HSJPcmefL0IWYKnhN7N0R4k+8vCQFRDiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=URx3yHuK; arc=fail smtp.client-ip=40.107.127.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZK0Bqs5vciz3x1bP7lk/PyIET8i3eDeVMztfuMvFo6RiE5SMRGRmos5j7YNk9BkPf58xQg0EgAJhslUpxZb+5//rVVQoAhEsOHXQFuzhtQ5ml1oIKIQxIF14iWBY2pwFiMaQXPMTU5k0A4LxSqfgXqUYnzG4lB6W3NEfuosx7v9J/DKpAOIb8zRiS1kfSA8j+0SxudKpKGdMr4weIDhgb+lvRB0yyzOKGTlNkdxMcSuaEjAeCUNSfn5R569TvVto1N5+9kXfe/jm+BgyiFwnTtEH0TwjWeGiKTZtEvRYsvWTVhFTc5T8AiACPqSxzdVrv+aZRHi4r/xhSkE/Vwpwng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qgwgEhVqqg2Q/zoj2y9pbbQ6twB5Hk34jv8tGlwQY3E=;
 b=TtWnyazgp0NXXte6hufylErRhyvTnGfMIm6mTBTZh5UTHuCQpEEP401GhXJrokQt/J65/VpXy9AHTOKMQyIYsYYPsmv/F64JLYIfoOkaYErs9HgP39/6gV4JlCOvkEg6eBcn+lIwDfHluHI1uvcvqmvuWVQWxT+HKn9/5VeQI62jcPs4nYhgzLh6AaokVLjm4rDGvvsDpNkqqSlUK5Z7YxRnFpC/s1P0OBxjFBWpgJuEtC0KM3MNllifcnmBQbkC20wY7Zcm7LokrSX30QIjUtOVBctuWog0CXe9hKugwBoHMVZl+ZkSO3o9ymtnUJERrqCQk82CALn9ek+3FzT0hg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgwgEhVqqg2Q/zoj2y9pbbQ6twB5Hk34jv8tGlwQY3E=;
 b=URx3yHuKf9a94S8A2ix19GXcjs1E6JNcJLw1dtXAsCtelGiT4yn4MihDTOTxUiYpQ9MGE/x7r46BIkofjd+xtpRBimESzRPer2TJ04tIJVKZQVJEuYcVF8a6xWMGHdYE6KWeQ/CFpNDPQmDUe9nlew2/AvUL1KtnR7cMSAD8AqDMY1hrD4XeChBpCgexzRufxGr6OqHDMUx+CyJW9WBGML4j1Tgt1ULykCGyhYv58c61anQ+YTI82Z4DsrC8WOoGLcdPpVjK8ficzakQG+Bmsn6RZL5vYheSkWNOHwcoobPp6geBiUh49W2MThJsB0Mk9sOvy3EF3V4Rk1fI8v6o7g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 FR5P281MB4522.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:11f::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7544.45; Wed, 8 May 2024 13:25:27 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::bf0d:16fc:a18c:c423%5]) with mapi id 15.20.7544.041; Wed, 8 May 2024
 13:25:27 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Prescher <thomas.prescher@cyberus-technology.de>,
	Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	kvm@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] KVM: x86: add KVM_RUN_X86_GUEST_MODE kvm_run flag
Date: Wed,  8 May 2024 15:25:01 +0200
Message-ID: <20240508132502.184428-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.44.0
Reply-To: <ZiFmNmlUxfQnXIua@google.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA2P292CA0015.ESPP292.PROD.OUTLOOK.COM
 (2603:10a6:250:1::12) To FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:38::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR2P281MB2329:EE_|FR5P281MB4522:EE_
X-MS-Office365-Filtering-Correlation-Id: 07dcb821-65b5-449e-fece-08dc6f625338
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|52116005|7416005|376005|366007|38350700005;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?9sY2o3Doy3MqH82b7EfiPdbqsZ8qJtvFclEEgq7LZzv2GYdNd5PMbkNvSc7x?=
 =?us-ascii?Q?gvZlYChUFM8s/jRyXEeyFs3rzhrNUzgNl6NVYlDkW/J/wH//GElERURgb+xF?=
 =?us-ascii?Q?J99apbonVjovb0D0IKXPSWMv2lRYnIPktK9UeM86szdZ55/BERquGa92BCBR?=
 =?us-ascii?Q?xBqEQsePwdiySMkB64EUO1c2g1QJ1EurjpuCuu9yJMLmlqYD7Ta3tLo4XunQ?=
 =?us-ascii?Q?sLf95j6KellCdKg20rPC1+rGshq4lJnVurfTseTgjZrAMzioSdc6Zxgno1u2?=
 =?us-ascii?Q?ErvmvVNExemuYGIRx0NxVE+M/urIrL17dGOteqMAKQQQMdUYb97qwYLixzf6?=
 =?us-ascii?Q?wZLQj+154VioWjBhpN8tzgWhqroJDHbSLNAv3Y/P5Qy6HPEvX3cBXnZyXnW5?=
 =?us-ascii?Q?LzWyhwTgX+o5TVHkiCvLHtS55D/tzPd/DSVw/WqO1Hdqdh/14qYfhyyu0OVZ?=
 =?us-ascii?Q?99mRZqJcbV8TK6G4q8DeZVWsj8XTgJ1aMrwcB/8iUzUOQOt9FE8Y/tGbI1Fd?=
 =?us-ascii?Q?2nhMHnItu1bGoONWLtTQoODiqNHDSQakALQiHQMav3Z440kFkxj74kGB5NTn?=
 =?us-ascii?Q?wNj3fC91Dw7Y5jaWSwyQYVjX7Bnjjgb8hcp3WX+MSNDVMNAKvALge/J2eymJ?=
 =?us-ascii?Q?vzQ0UIFbW+4UuVnjevtspnyc1d3w+ssKbOpMRO0cpZTnFOv9M+5+J+5yHXG3?=
 =?us-ascii?Q?cQr0+q6BFLhjEOum+Ujgt58HVBjVbis00aYbR4foGWClT1f6ihIIpSSWTmUY?=
 =?us-ascii?Q?SqbKmyCvAkDl7Qbcc6khiEgShVUCM/jiF9lTy3i474R6nFCiq4YjhCc5d7bJ?=
 =?us-ascii?Q?V52ltQz+Yl7XLV4ZxLWHkLTrj59E0XORrClVB+QCsLF6keu8FMuXWUXkStxp?=
 =?us-ascii?Q?EfO021z7KuWi+cfCrKZQ22sNm8hBvhecHqYyf2zZ7B1uFLM8PxWxuMJs364g?=
 =?us-ascii?Q?jRj/GxchMH7WyEwwKyuq32olEAQ6PLk2w6B3W+5pUCe4sZO4zcf/WD/hOk8d?=
 =?us-ascii?Q?G2fa4m/4OH2Empcm5AnMiMnekYjU1TRm4l1d0a+WC4cZrJHomJrbaxq6jY3N?=
 =?us-ascii?Q?YZyfNJJ+5nZoYjli2c/n7fUqIIX6GN6xLowYG8sYR31at6+IS23cm8t5Rcyk?=
 =?us-ascii?Q?2/NFH4CRatVY07R1PtPz3JNOS4O9EKMDqaoOFRxfQEV0ADIw/oFGzBwKUxIA?=
 =?us-ascii?Q?AUbhvFNfCYCIfmEDusG1+xsdj4en/VY8l4xyWqsyjWBW27DtOG+5oPz6vhio?=
 =?us-ascii?Q?PESEFBB7eMHEoFRAnw3aBd+XLEvm7L8i5jmMdNV6gA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(52116005)(7416005)(376005)(366007)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZLwhE37KXhY0JdZaSdAD7qQJ0XklPZrMkamMJRgKOahDe+aowE9y5VD0dtrj?=
 =?us-ascii?Q?fCDFVOCiHBVaDGdIMabBOMfbaQF1JkkvD/0gicNhagMs8qYPw9RhRYWaqvDZ?=
 =?us-ascii?Q?NjpsbIkvG5P9D6iRbkbF7Jyznqy7gRZCLJB273aSsiQKAhFWuWXWXJgx8Cet?=
 =?us-ascii?Q?hDlsHkIzYFvUWEN7mliRvXIU3HQLKB7m4OZ8Y4UIazWaUwyj/HfEhoUZnyas?=
 =?us-ascii?Q?k5FIDYpG2fGG2jTKXz++h0XWV+vwUt6m2ZZv+HUk3NqgszqXFBrXmE4583xu?=
 =?us-ascii?Q?j9Y7bRMHkj5TIy9JRAR97fbcgy6FvqTIfgcuUAk7JA30QzAMmnG+0sODABeU?=
 =?us-ascii?Q?RYd2czIzsd/EBbsRWfbneIM40RSNSKzZYEgyyxB2K8SYuie3DB//LzT2u71K?=
 =?us-ascii?Q?I/tlhu0UfJBW3o515+/0VVx62pwfvYHq6gVAZzl2HRAa6RMklnjsEsCD5jyn?=
 =?us-ascii?Q?c+/gfMw6kMljZOEI2FykSjg1T5I+fg9bbQZoS1ANzDnm8zld7UVCbD4FZg1J?=
 =?us-ascii?Q?jmojlEThOhg3XR6rPyqU0/g9+yKnFvITFzuEYQ8ACyQm3JHHr0NpHRV/qrIj?=
 =?us-ascii?Q?/1p45c4TaTA2AXURRdOv89LwElnpIZylUWdnSJ5gcgmeWznLWRo1qZWeDHul?=
 =?us-ascii?Q?zEKtdowM36fI3WV/QaUKO3lW9qWf8+Aam63u9gdlQL+/yAh2OyasTUxF62mj?=
 =?us-ascii?Q?HEVGYNfxcS3OehV6hoGcYSeCm6ttWYvH7eEff6JGOHJoJxX/8K/3kGLuLPGz?=
 =?us-ascii?Q?A8bLvIZctkKBTjiGrMMX4OSLa9HCN/DD8mvokBKYT1GNhzQ6MH4C6sPTIGT0?=
 =?us-ascii?Q?ZrJPLA2n/tbIsfTsk7YqDDONaxkl5JOks1/Itdbxce3aSQQiVlcKRLFWcLPH?=
 =?us-ascii?Q?Wf3QTzt8DpcpC5AONCCGDzB87AsXWYRG6TFfWbufLOcX1qS4+zOzyajLARW2?=
 =?us-ascii?Q?RXu+AIYEvvCyL0u1lq0UfLsue9dvkOTEOtSTvxTWmPSxPoz1FHJRchZPH/rY?=
 =?us-ascii?Q?1DCKGQgDnxAu4qvGStVz+Yakf+czxQQ4FgZ1hk8EgmOGGWIA6f2XMUMpsiGE?=
 =?us-ascii?Q?6oASgbD/ENMzqJ6wfznUSK5/0P1+JxDYkpE55BdJ8uICVGXTq+3xb29akPE/?=
 =?us-ascii?Q?5MDDeCMUksMwvNbaFM+2NGEI2BU7Gxn6Lm64zDW9DMWMZwAJ15xewwFbbu2K?=
 =?us-ascii?Q?m2jfllbMZlCANUWajP88kKC1ZSqdDWGtUf+Zdk9FwmrDlZh2XmcxPDA/9o9u?=
 =?us-ascii?Q?kBGsZ6lT4npCgBdGeQd+rMXWB2dckaa3ruFFbTAtEqLDpvqm+w2uE/MtnJrc?=
 =?us-ascii?Q?Mr/r0xIn9oO772X/EWT9+3f1dMrrQdp+qY6K+ha7mnWv90t+1ZmAhWu4U0+G?=
 =?us-ascii?Q?VJ58aAvKUFGE7KeXuHmisYkIRxYjMh20lukGybxwUBAp5qN0zWg6XyDiPhNK?=
 =?us-ascii?Q?OY8DE1WMW+6NROYkGo0Gy4t5xgjO36W4O9OnuPtfsJAoKjswlvApwzBc2Zuo?=
 =?us-ascii?Q?T76Vzn900TX7c8k7S1t+vqyqIiOtcCRi2+NfkQvgK3o10C0HGfumGqKI0blu?=
 =?us-ascii?Q?Zhsxz5EZGdpO/YyrLuBhGzDr8oloLEn2Eptj6z6xYGi5PgekifYS7Hn3cOa4?=
 =?us-ascii?Q?1JGGvhDcSKkVU3OIPBWOHsM=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 07dcb821-65b5-449e-fece-08dc6f625338
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2024 13:25:27.5434
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dPG8q+gQyhlecBho6M4v1baOTfQHFa7tyr5Fncq1Aln5I9Wv3CAUvCxaG9u5cWxjOUWfEgi4Uz5yOa61zOoTxLEmO4I2SgbZ42U+Ap28HxDt6J4gxPha5mhx+diDdPPv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR5P281MB4522

From: Thomas Prescher <thomas.prescher@cyberus-technology.de>

When a vCPU is interrupted by a signal while running a nested guest,
KVM will exit to userspace with L2 state. However, userspace has no
way to know whether it sees L1 or L2 state (besides calling
KVM_GET_STATS_FD, which does not have a stable ABI).

This causes multiple problems:

The simplest one is L2 state corruption when userspace marks the sregs
as dirty. See this mailing list thread [1] for a complete discussion.

Another problem is that if userspace decides to continue by emulating
instructions, it will unknowingly emulate with L2 state as if L1
doesn't exist, which can be considered a weird guest escape.

This patch introduces a new flag KVM_RUN_X86_GUEST_MODE in the kvm_run
data structure, which is set when the vCPU exited while running a
nested guest. Userspace can then handle this situation.

To see whether this functionality is available, this patch also
introduces a new capability KVM_CAP_X86_GUEST_MODE.

[1] https://lore.kernel.org/kvm/20240416123558.212040-1-julian.stecklina@cyberus-technology.de/T/#m280aadcb2e10ae02c191a7dc4ed4b711a74b1f55

Signed-off-by: Thomas Prescher <thomas.prescher@cyberus-technology.de>
Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
---
 Documentation/virt/kvm/api.rst  | 17 +++++++++++++++++
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/x86.c              |  3 +++
 include/uapi/linux/kvm.h        |  1 +
 4 files changed, 22 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 0b5a33ee71ee..7748c3eb98e0 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6419,6 +6419,9 @@ affect the device's behavior. Current defined flags::
   #define KVM_RUN_X86_SMM     (1 << 0)
   /* x86, set if bus lock detected in VM */
   #define KVM_RUN_BUS_LOCK    (1 << 1)
+  /* x86, set if the VCPU exited from a nested (L2) guest */
+  #define KVM_RUN_X86_GUEST_MODE (1 << 2)
+
   /* arm64, set for KVM_EXIT_DEBUG */
   #define KVM_DEBUG_ARCH_HSR_HIGH_VALID  (1 << 0)
 
@@ -8063,6 +8066,20 @@ error/annotated fault.
 
 See KVM_EXIT_MEMORY_FAULT for more information.
 
+7.34 KVM_CAP_X86_GUEST_MODE
+------------------------------
+
+:Architectures: x86
+:Returns: Informational only, -EINVAL on direct KVM_ENABLE_CAP.
+
+The presence of this capability indicates that KVM_RUN will update the
+KVM_RUN_X86_GUEST_MODE bit in kvm_run.flags to indicate whether the
+vCPU was executing nested guest code when it exited.
+
+KVM exits with the register state of either the L1 or L2 guest
+depending on which executed at the time of an exit. Userspace must
+take care to differentiate between these cases.
+
 8. Other capabilities.
 ======================
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index ef11aa4cab42..ff4ed82a2d06 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_ioapic_state {
 
 #define KVM_RUN_X86_SMM		 (1 << 0)
 #define KVM_RUN_X86_BUS_LOCK     (1 << 1)
+#define KVM_RUN_X86_GUEST_MODE   (1 << 2)
 
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 91478b769af0..64f2cba9345e 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -4714,6 +4714,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_VM_DISABLE_NX_HUGE_PAGES:
 	case KVM_CAP_IRQFD_RESAMPLE:
 	case KVM_CAP_MEMORY_FAULT_INFO:
+	case KVM_CAP_X86_GUEST_MODE:
 		r = 1;
 		break;
 	case KVM_CAP_EXIT_HYPERCALL:
@@ -10200,6 +10201,8 @@ static void post_kvm_run_save(struct kvm_vcpu *vcpu)
 
 	if (is_smm(vcpu))
 		kvm_run->flags |= KVM_RUN_X86_SMM;
+	if (is_guest_mode(vcpu))
+		kvm_run->flags |= KVM_RUN_X86_GUEST_MODE;
 }
 
 static void update_cr8_intercept(struct kvm_vcpu *vcpu)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 2190adbe3002..ccb12f6a656d 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -917,6 +917,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_MEMORY_ATTRIBUTES 233
 #define KVM_CAP_GUEST_MEMFD 234
 #define KVM_CAP_VM_TYPES 235
+#define KVM_CAP_X86_GUEST_MODE 236
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.42.0


