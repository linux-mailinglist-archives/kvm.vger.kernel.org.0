Return-Path: <kvm+bounces-14761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42D658A6B2E
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:37:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C614E1F21B6B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 12:37:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF35112BF1D;
	Tue, 16 Apr 2024 12:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="OVp/Yu12"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2104.outbound.protection.outlook.com [40.107.127.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F357A42059;
	Tue, 16 Apr 2024 12:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.127.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713271007; cv=fail; b=FDUcrlYWPde3qdavFJ7HU6YtKE+iF+giz4AOHCYVJZfj3MkfAMRX2aBm6uF+uBcy1u1VCabLL3O+A6ewn9TxD2/WOHNG+Z8ktJOeOB3OAaNcRaejZuT2G+mxTMN9bzxbShB0db+rFfEIicOxF5TtDmGS4kwKXpMwpTsn7NdqIa4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713271007; c=relaxed/simple;
	bh=aUYVOjc6Vc5BHwVUVDe3y3bHM4F0WyVoIq8DE38Y+V8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=FurCmmUluZOAWPy0Tk7PcLWOG1LEoAyi67GWQCZp76ZF3PvzgU8vDHrvs7VFNmsVEPKY1+YRyaUpY2yWHySE2jO8gLfE8IxiUQPhjPZTKMj5B5Ij3JCt4G1tkPpzu7pm0wboyGfnNMOJWH6+W6Ut18wYUOBjyzNnJTUjEMfDYf8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=OVp/Yu12; arc=fail smtp.client-ip=40.107.127.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mwfgsefvV8kD+tzgqhOOHIS3edApzmfVvgmpe49s4bSLYslRW8UX40YxsLVqVIdq2SJy3vzFavI5JYsSE85fAaPh7MyPVv0xk4IUkc74ACVHoeE6ed/6HD7h158XKZDWfTa5dVvPzJWFYCuAW0yF5/th2afPAfcxm+EoTwUI+e73RGNCxjtIsrDmUTmH37Be25xSak1WwQ3lq2t5XqpufpxGz7leEiaLRXlo5oonzzHtJfCsC9G7X60TGmbqag9TQVPrTCzvCbzYt+WzrkHaomHDtrZzoFeH+fh2BqbzZRwP/Nia0gVQULQcWLjKSFAQWSS/bxpZdMo6OvEFhfY3OQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3KIei3UMKdcBvkO9uGMBgk4HTS/AsvarqcqWzTFqpcU=;
 b=OUaVyB7LPEryeYPm0xPPxxNZPBszuOi+hfp4D20Kz4CVeybjH0TPZitqv1ByShJjyK8ozT5a9OnS2EsiC6pNfSZzXji4v4qDXbBjbjkmRHkTEpwBKcD3/BtTHqyk4NGqlRgIEQx7XakK6/Z/JxnUn7KMZsryVXXrHhW1lxbQyCC/CAi1+2oDFLYMflJEdu6XuRDSQqcGp/sLSGPQmrsJj6qRvAdMT+Mg0ajbxo6llADBYHabeZYxrbSeXABqAnvURPyITB/pQ9RpaZgAp3bWRorb9xRNaTt75JJEo5h05IcEqKasR7GeUxT6swpmxOe9qguSM1B7U7c+Nnwivuoy3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3KIei3UMKdcBvkO9uGMBgk4HTS/AsvarqcqWzTFqpcU=;
 b=OVp/Yu12BBYWjkZh9ZlDBT/3ekL7EiOI0hlV1goBrTmizpoUFpb3v468AjGk0Bn1Qk6vxnQaJWFqV9KgpstzUdkMlfvbcZSiQ2ckWICP91GmJ/HkgulN5X7kD+3rqGiC6502C5uyIXRIOKeBhnIL3NTCIt6AIuwV4O8YD0vlE9nosE/E4XGFPYRZdnPj82n5o627JnwWecNQ+a5OKuZ+raUUGmZwtJ98U3w8Oi2zdZrxdXO9d3fuAfH6yrZ/LkRpWhjLDA6NduOLLQVit7tbNM+0hzV54I8mj/JDVBuOUANmSnp7ZscHOxiZkBei0rmOCbFkKvxDTB86foL9LCyTmQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 FR2P281MB1543.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:90::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Tue, 16 Apr 2024 12:36:39 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::cd58:a187:5d01:55f5]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::cd58:a187:5d01:55f5%6]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 12:36:39 +0000
From: Julian Stecklina <julian.stecklina@cyberus-technology.de>
To: Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Prescher <thomas.prescher@cyberus-technology.de>,
	Julian Stecklina <julian.stecklina@cyberus-technology.de>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: nVMX: remove unnecessary CR4_READ_SHADOW write
Date: Tue, 16 Apr 2024 14:35:57 +0200
Message-ID: <20240416123558.212040-2-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
References: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA2P292CA0026.ESPP292.PROD.OUTLOOK.COM (2603:10a6:250::12)
 To FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: FR2P281MB2329:EE_|FR2P281MB1543:EE_
X-MS-Office365-Filtering-Correlation-Id: f4dee769-aa7d-4890-8267-08dc5e11dd0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1VWeVcC+YKjgl7oc98xwdalfxOseo7lIN32aet2FtEVs5eKpc1xrmw1jnn/L?=
 =?us-ascii?Q?1OOFqhoQRXGgluGiVCH8supY5CP/aDtCLnSUeUeddlxuOtuUNypaf8ZiKVOJ?=
 =?us-ascii?Q?dCOHHa/iS5eBz990okYidl8kMOI44x8VaQu94+RvrkpTNzrwkzennMxWJE5q?=
 =?us-ascii?Q?0jAf//ryNKVgwCVVDT7l98Z/cZOxe0zhWdQ7IHxCm79/lbdrc1LOut+J5+Yr?=
 =?us-ascii?Q?A51d19V2UHGvaWD1vHXwVlE7ljEeB4PMmZuj2WC84lypV0pn+JFc+gAd9bzM?=
 =?us-ascii?Q?iErczKWEPvmvXotXJdQho6M4+/4ysjsdXcz11kH9OvGnd3aKy4ln8gaKIaqK?=
 =?us-ascii?Q?YLkbkG6+2/DEU8+W3hCtKUDsN+7vmJPL948T9MFnkPlKmkVIrg40jqLRp1Bi?=
 =?us-ascii?Q?PMCtLq8V4usCBIOHI75wWYSoDfb6g3RdVne+wyyFm1JTYT1e5iTk7aSTcopf?=
 =?us-ascii?Q?pblgbsGV5y6MztMPCGgWE9F8j7L02QkCvxb6kI1wT+l2Y5St3fWzHArqyjrZ?=
 =?us-ascii?Q?Njw43i9R1ZrlbdD0sQJJiBxAnAmgK4/EFwOyUNIobeCEGEFymwvjGqg3TTqa?=
 =?us-ascii?Q?Gn2x2V5YpJXfwMgW9CZKVkmsJ77+jn0v/DBKcJLO5oRziK2GH0MQeLnE7TKz?=
 =?us-ascii?Q?GdwrI+Oy1OAJlpjdZ68lmW4Q6gXzXsvuxBvBf+U86IqL4s1p9YPTSZxE9WOs?=
 =?us-ascii?Q?cAFthmCNCaSTrsvgJkiDLFLMeBoB8hxwDcGO4mnx3R36gbePUQMe+CQKiEwR?=
 =?us-ascii?Q?Mjjye6HhTTJFSGSNytrQ0sFbyZbEsKdgQ0IOaZ8/rEU/zoiQJdeHcS6s7C3n?=
 =?us-ascii?Q?YuDnfRs31MO9gSxQd9BtYmdQ8MCzKABz7rYpbqDDqNUw4y0QN3VMiq+npdiB?=
 =?us-ascii?Q?JEKNTTcKT5FgE4PlLy9Dg4gkW/WCEXgu54B1eSXyoiJ1A0DVYjix0bQ51nZm?=
 =?us-ascii?Q?pdLAjWnJ4WrTJRgk5lQ2q4SHul11QFfyrWY7SrtaUNcFe/Ng8/fwKug9FBoL?=
 =?us-ascii?Q?NkFKoNKdVAhYLyhSvwjTsyEBtKaU0MnsRg1PK4noJkkWKUa7UgREW7j0PpL4?=
 =?us-ascii?Q?5xfa9ffOoU8tm9lzeWkO8DY0B/KocjdHuwnkLEw0DEjJPqN3YFbgiZQM70dk?=
 =?us-ascii?Q?yc9vsW2uSN8x/FgyRVAjgglyYpPr9rKTK9pfnv/pMHWgEpL47VR7tU0Cnb/j?=
 =?us-ascii?Q?e0yGId3BK30jTVPIKY7Y3Otuk81vbQJTGCYIIjpE7RtdWy+/6pmqJScfW7om?=
 =?us-ascii?Q?FOLU4dOfcq8HznJPPFbrGIz1yi++EiQT54Oo3TL4c+rDiTm657XYcPzmeqfy?=
 =?us-ascii?Q?EbVM0M4pbo7hF44gJLXoA4I9oOR3zCoZcfMNEzNGFcTgVA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(52116005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?7qKqF0IADGO/IznKZXCMkvvC3Y4AcLA/EgfSS0DPQWnlZItl8iy7dPt4PLQZ?=
 =?us-ascii?Q?SyMsOCiprEB1iP/AM96csJXswDYE+lDIeWUd0jSuafev8gJRbl27b4nlnvri?=
 =?us-ascii?Q?z2p7+yO/jIXw4s9zjkOsAHIchRWw7YXQxiLfsoVxMQw+09FxZA01oC5XYIYy?=
 =?us-ascii?Q?NLhPJMqQ4Qicv2mihIfDNWfGK8gRCQdypKq2psoORRD7ntRo3zXU9aFZ99kg?=
 =?us-ascii?Q?Jb/KiWMDLvUjNWilUBT5rlwDVQ3q2AgpScZI2r+cX4CRoGcRuyD8QEKG/c92?=
 =?us-ascii?Q?g/x3Rfz3i8ZIbwZBEqTN+GaSejeaOmhXfUNKrkQ8eZEG8tukMMBhgzrlX/u6?=
 =?us-ascii?Q?O0/y+pL1J1+IOEQhJvq6c0bwRrAXq6JNr7PShXSR+0M2Sbcy1j6PKkvDzO/U?=
 =?us-ascii?Q?s66AkfH0w5VMXcRPDgx/qR683OnQv2cGxmn2ZBBXfSaGa0BTVCPttddhHYzU?=
 =?us-ascii?Q?hHn+lZj2b1VsAPc7IYNuuIO4ziivRy3hu04NN9In4oqZQ7cxT7aR7MM3RUD8?=
 =?us-ascii?Q?xvvM5/A7k1wM3qkUfVdnCxwTWfcUPx9XCx5ugKSOe72bfZeLGhE08xTZkTht?=
 =?us-ascii?Q?6T0N+7NOfGmzUpyLt36UR8ckex/JQRVlxEDUXo4N5lC3yaQkE8OEztj+Peml?=
 =?us-ascii?Q?Wl2DvrJrDSSRkrZ8/px9RXkJtuPRi+J3gHhzQ0/KLcBoczzomx06ukxBm3S+?=
 =?us-ascii?Q?zl8UDkw8imniDPJGR5BkZfK1u1v4DksHfS2j4ek9wocELp9XkiCX5mITysRW?=
 =?us-ascii?Q?8CXAVA0P2PKmtMR84Dfy+XkokG5g9WsuTHHFbE5PuN39tyC2Apblg+DZ0gnE?=
 =?us-ascii?Q?QswFsKB9x933QVdMiEGGB4iVxULbI2oq5ws3qNkJ2OydmpdQSlEQ/FZdBXQv?=
 =?us-ascii?Q?ZCzhCQ9LNHwGLMrjjJndXjXyHAEu+Ca13Sts0Ig30SksBzrXj4xrXBwRcwZx?=
 =?us-ascii?Q?SmXORYb25pHqPiclG4PHEaf+OXXSwqb9/6jTieDq0pPc7MADbbrSguufAYKd?=
 =?us-ascii?Q?W5oqGiJF2mmEIDSeY0uqQnCEqNQonXKOMEj0B7ZNnhmonlgivGrjqOQNHzJi?=
 =?us-ascii?Q?uhOtcz1ziW0wTL5UjvXSN8dIMyV2TcOTnSOVXtNgixXf91E3Q5FHX4yay9d0?=
 =?us-ascii?Q?Mxo5r6RraEbQI62UoA86QqgCLGnQnpkvaLMndfM78TpkkGKkezLrYfGfH0AL?=
 =?us-ascii?Q?oSi6Kiq5bgGqO1tc0stJ7/zxnEOr9MAP28+bez+PVh3enqZFcqa4guewlc75?=
 =?us-ascii?Q?7T0YQJLdby1bDhtXlWrKsNsxTKRwqo7A9xTNK63+b9No4mk58ontYajua/hw?=
 =?us-ascii?Q?EHGm3AOE+jOK2nGRjHBHF5PwQTUa9Ap9ICL68ZeTfmhhNWYUiqinJ/a1BlJe?=
 =?us-ascii?Q?S6NdBFBzM4hNwYBqEzmsbvNJ5MqA7mQK/p94ydIUROEwiU+jKfcTuiGEzuHU?=
 =?us-ascii?Q?U1ClkLLZOGfyWWtHa6fbYC/nrL7Jd568/vkpdAL9rngPZ8uRlwVmYATsGMXa?=
 =?us-ascii?Q?hOPFQmklJjp4mo/LyOqnlYajHV4RP7IKXz3xtLDWyAyoOXx7TzZoRzgkPePS?=
 =?us-ascii?Q?9huLDU43qUAG4G0xPTElepTZeoMwMyziYsJyu9KVc45Oge8SVX3Y6R16AHP8?=
 =?us-ascii?Q?fvC9HTRbZtiITnt4i2H4DrU=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: f4dee769-aa7d-4890-8267-08dc5e11dd0f
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 12:36:39.8804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /7UhVMmMGVk53/UTLYCOyASftyk+feDu5rUB4BGJXhyvJsQlXuLNKV5g7uuUNUzgXSBWKmjnwfQeTKtm8b4ot9osGUdSxHAS0Iytc8UYy5n6piYQVjXpHp3LLfvF0Nng
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1543

From: Thomas Prescher <thomas.prescher@cyberus-technology.de>

This explicit change of CR4_READ_SHADOW is no longer necessary because
it is now handled in vmx_set_cr4.

Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
Signed-off-by: Thomas Prescher <thomas.prescher@cyberus-technology.de>
---
 arch/x86/kvm/vmx/nested.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d05ddf751491..e191bf5d4831 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2639,7 +2639,6 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	vmcs_writel(CR0_READ_SHADOW, nested_read_cr0(vmcs12));
 
 	vmx_set_cr4(vcpu, vmcs12->guest_cr4);
-	vmcs_writel(CR4_READ_SHADOW, nested_read_cr4(vmcs12));
 
 	vcpu->arch.efer = nested_vmx_calc_efer(vmx, vmcs12);
 	/* Note: may modify VM_ENTRY/EXIT_CONTROLS and GUEST/HOST_IA32_EFER */
-- 
2.43.2


