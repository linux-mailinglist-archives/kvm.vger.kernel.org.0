Return-Path: <kvm+bounces-48738-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5DACAD1ED6
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 15:28:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4277216BCB4
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 13:28:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7410B259C98;
	Mon,  9 Jun 2025 13:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b="fqVNvoYp"
X-Original-To: kvm@vger.kernel.org
Received: from DUZPR83CU001.outbound.protection.outlook.com (mail-northeuropeazon11022073.outbound.protection.outlook.com [52.101.66.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55492566F5
	for <kvm@vger.kernel.org>; Mon,  9 Jun 2025 13:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.66.73
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749475653; cv=fail; b=EK3y6eYObJ460P+jkbhK8feQqDgNDnH46EpczspWn/MRVlBLxgP4Q8Y1yi7bE/c/Z6GlEIM5GAZVgb56k3kdMkSGblm93kJkTU7B7izDij+WpZqEEaU968Qjhy2xvkeNcy0NfrBHfd5lhY/Z9bIFEKsLYbtxkv7wA+vLKYO4Fuw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749475653; c=relaxed/simple;
	bh=D48QFBR7eE0hqn/jv+kCrMLD5xooJq9InMYphqmCza0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=CiLszggZaNmf8yQHgIUoAw16Q0vdz/4wMXQ0g+/k3sW90wmZutt2/u5oOdbfPhRIs3VtICReTex+sfSj3l7E++L8gV7kfOakTAkaUpw/29eInJlhXOGQoccGn0rYzB6+zlJ4HlzrUS78p3LCMa98enDeu99Pq2/VC62IjRC/V8I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com; spf=pass smtp.mailfrom=virtuozzo.com; dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.b=fqVNvoYp; arc=fail smtp.client-ip=52.101.66.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=BEEuk118O0x8KVl5hbWCvcpfs57MVLb4LDknnftFy7gdp3MFhE2UVBj9cihTOKlMcggkAwXZ3I1ytqOq86keHhu9LpomUwInZNJMIrxEhm2JkBPcB/L+jSOe7Z0K97Ccdb4BzUfqbkQZAagbMP5V4BKRLGm+JJBYedYPvhy2wObIrMt24dsdCq9J1diFvp7Od0/6fadWxJsCML8HvBeEZM2CYSXmdBi8F/wWJgryEv8veKsxsSM/n8bEEfAJUf2XB+Jvl3TXA/u07/hUsAnjM3j84UqKyIjaxTO/mYfGyxaaj8t3oiMdl8ubfFXP2fZhExlTxJsJ1iErWURdV0woiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3TI9k0CCNHwxciTgvQG5k8MV0DB7WIkETfFutm2VL4=;
 b=CeOSNSI0SyoBcKuLHjM/74f/kuON9yZ2e3KAlqzWuov/yHLbcSkc2t1thuvReL5OgJBEcYl1Nop9ZnZRn99gcLx3/deZ8N6H7qo7hmcxQlWTtyA876LZbb/h0xf+hpfA81WIJeLHG/lfpPLgjdGH0UqmpqyTm0FFdLWf5L9WrGmtyS0DWmAm37H4kB/vKNmDiR7EBoqq2nRzDJsO2cQu5p0C7mfgEQ/RQMpUMBYyw3pRMefJRQ2JmVVIof7k7Pb4ikTROiqmIjwjhd4lHs/KyF81xgDwGw4VymqvMpPRxPH6DnVk0C120RM7n3lbRs5URnP/G9Z4YENDiZoOYxBVCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3TI9k0CCNHwxciTgvQG5k8MV0DB7WIkETfFutm2VL4=;
 b=fqVNvoYpKYHWVW5EFdK8e3t9a21IPFu7VojaXs3BLiyyjjNiLBCi9n8J5RWHU+EAxzBcjHTSleqy2SnJp16OOSFj3P0JUQqlrxBKV6Yms+PNidKJW1ct0T+q0R9uDLiX+JxeHkkmpNOo/hY97zltb/CEcoNoWEAD1b6s+/svNvDRozMlBHC4dmgTDTeQuVLgjBG41q8aCfgWkQZmdnm8qU881GL5RyRZlXn7hmHoRFRKKZggbNh2S8tine0v6/PjoLuDrBrlBaLUqiOBc0cQGsqQyvaORAy27FLPjeIfch2eD334yvKrb4OOnmVXv7/13/5kWXmNSrZnQZVifpvyBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=virtuozzo.com;
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com (2603:10a6:20b:1d4::16)
 by DU0PR08MB8564.eurprd08.prod.outlook.com (2603:10a6:10:403::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.27; Mon, 9 Jun
 2025 13:27:27 +0000
Received: from AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::e543:a83c:a260:602b]) by AM8PR08MB5732.eurprd08.prod.outlook.com
 ([fe80::e543:a83c:a260:602b%3]) with mapi id 15.20.8813.024; Mon, 9 Jun 2025
 13:27:27 +0000
From: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
To: pbonzini@redhat.com,
	zhao1.liu@intel.com,
	mtosatti@redhat.com
Cc: qemu-devel@nongnu.org,
	kvm@vger.kernel.org,
	den@virtuozzo.com,
	andrey.drobyshev@virtuozzo.com
Subject: [PATCH] target/i386: KVM: add hack for Windows vCPU hotplug with SGX
Date: Mon,  9 Jun 2025 15:23:48 +0200
Message-ID: <20250609132347.3254285-2-andrey.zhadchenko@virtuozzo.com>
X-Mailer: git-send-email 2.43.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: ZR0P278CA0171.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::9) To AM8PR08MB5732.eurprd08.prod.outlook.com
 (2603:10a6:20b:1d4::16)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR08MB5732:EE_|DU0PR08MB8564:EE_
X-MS-Office365-Filtering-Correlation-Id: afc7ba40-16ae-4408-fc5c-08dda7596017
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|366016|376014|52116014|38350700014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y7wFb3F86D3Vfi7QFGmjFRBZSh36plLGwZJX5ms3n27K+g44LeRZav7G3WDN?=
 =?us-ascii?Q?jPSR2mqIE+QhAO76YMhxPNDelDTbH+1MYoYJV1tC/Huc2Clr5BXYr0/+5S1i?=
 =?us-ascii?Q?mhlFZNOeVdU3ae4DOdLpOWzbB12Dvl9b4ofwBm0995YBoi6dtefZS1/7nrqq?=
 =?us-ascii?Q?okB6/WQSMgwrkm2RS4iL132ZjMxOUKKOszVn+I0VoJ+LUGEbJ/t9vxl3IvvM?=
 =?us-ascii?Q?QZjNda/niECeWXfBLdcT1cSgAfVTUDp/snGbYyfFYincA7C9v7pOyJEdgnu5?=
 =?us-ascii?Q?Q6AXYVmHoRMcUH1EDYCu22vnMXISWPWjQwR6eqZslGT7kmdwcpVF+7FCJYh2?=
 =?us-ascii?Q?lYVR/n6W9hbRs/dJISuu0ptwxocFjQZOM0LzvOvHLhzrwLoE9KZuIv6LXfTI?=
 =?us-ascii?Q?5PapBONxkxziKlmvbhrXjm/H/kzcdp/ayYtiGJ4qoFxFwcF3P5salbh1bqBI?=
 =?us-ascii?Q?FQDtI1EWC0saF+vFotjvA8iCqgGZcTpYUFzBW/VCSG9UZBCKu+BnSO+ywyk+?=
 =?us-ascii?Q?VY3mEY+iRWqs5T0zWt9IOkvVgrDsgth2RZrgIu8rrP1BbEK5yr30+NKDbeKn?=
 =?us-ascii?Q?kJw3JBPJqhDYQNojhgnlTkFNiEwRpwV9uQjc36Zb6vU+r5V2C+iiwbZe8Jsb?=
 =?us-ascii?Q?hVcxPd1+VyFtOYJTDU0fqFSissJ/b5yxqxmTe5WpxLGscayWzy+g7powiqay?=
 =?us-ascii?Q?TOo22onXRN3z5XIqHG2d3gBnOuWBYjqxgr/vLLL6tVjZwhERUapYuz3qTX5s?=
 =?us-ascii?Q?uYQYFTdRIvXP3xRHbzekM6BIWQqdiWaWw4J4OqvW+7S15KDO2B2SzutZaruT?=
 =?us-ascii?Q?u3CoZBoSfHOOS7TZj7DCUwvlhLeETImme+GQhs1LC8oR23ks1OJqKDR0DXgc?=
 =?us-ascii?Q?6Qugc7KvbwfVI0UOSjlsFl4C0iQjzqULjxyhj0g+rkuTbDBixWhstQY7omVZ?=
 =?us-ascii?Q?hcPLovLAiGh5J3wHzLuUaqLk3aAalK/kPVsLZNuv5VSLdKNo9cXB8sI5WxCO?=
 =?us-ascii?Q?CNTCTe4SGr9bmhZYtupev+rqYPk/6HjR25sPQgG0I3uUIgEi4biyF1BHo9ut?=
 =?us-ascii?Q?HZL2vs29ckEXG0ybHHZljhzN+NYFew+ACJDj6jM7nh7nO6OY91d3Cp+RgiNk?=
 =?us-ascii?Q?oZQVqqTDJRONHU4n3zds5boIB6U+XkUYAprutG/7ubU2H5zN43tw9kW3iyPU?=
 =?us-ascii?Q?2AMgFDnKa+Ao5QsdBRhdMoxHGvNS/+PyTiJCY/cDEn1n+iwtNTlaPZ9hsGCw?=
 =?us-ascii?Q?gKrd3BIeeS0h1hBmE1iBLP7sn7UTfJVppc9FX7PxZzTH9ZBszKOEXIeXWA7b?=
 =?us-ascii?Q?t+n6kDXcxVKjT5ywswKXBPi3HKSe6lB5j82zzIPe1PkVoF68YDdPf6r26yev?=
 =?us-ascii?Q?ufKSwXRr3wAu+4EjdCmwjt7/JgiHCW1tsb79esTASbHPqIQXvWSFPA+3OUxF?=
 =?us-ascii?Q?z8zhA1C3P1HPXrlYc6HfNAOlGJhSTYUrDT3PgqQI+sNxpd9i5Ogoaw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR08MB5732.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(52116014)(38350700014);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?+fjs/qNYRol8GgrcMEE95/dbZdpU3AfjUoU6Z5OA235c3CQ5ljjNIND8Wak1?=
 =?us-ascii?Q?9TzpjZGqNcnUmCI12Zi+lQw791/7+W2iYjbZa8jxWWjhxqGdcVTU5Hv9bh+T?=
 =?us-ascii?Q?hcR2jYEk7Z+cTgNLrnboP/Q14y/i/f01RrIOzuLhJbh2h8MhJf5ZtVjYTpjB?=
 =?us-ascii?Q?9t3vTobS+pmSZCdPNutKCVtFM1iFh33V1Cv7tQl8gdbMv5/3AAQvViJaCIeq?=
 =?us-ascii?Q?pWwzbkaGfp5D7LIwMJu8ZuHiuaIQolfq8cmy2eoGCxTekO+stNl2W0J1KJJc?=
 =?us-ascii?Q?cWKePQBSX8qVxdoxXwTIaALGJB7OnoJZt+U0388c/2BGW9rfDRP7uClBFC6k?=
 =?us-ascii?Q?HWWiWnXsTMS1/VW167GHQFHSJ5pUxEVcOkE1wCQMrSUvBzdnUFJYlJ5Qr/tK?=
 =?us-ascii?Q?lp0F1M3qFaXfep2BBTNNoVb82uXQIqEw4Vw7UjxwixD7Y7fwtqXttEeAX5Ec?=
 =?us-ascii?Q?IrtLVRsbXTbO4PJbXFg/vMqscpBngpPqIExtz2X9aeel/qfX8zLaoOwiv/Ji?=
 =?us-ascii?Q?w/Otc4tNbMfCd3t4l8Py5wOisfXFEPECjPKO10hr17tgsD/7VOpFvg4U69UO?=
 =?us-ascii?Q?K15jJG/XN2dIwjuZaMojAHlxIJjlmAVKzxhnuXxOiSExJnz02JHz8Gc06OfD?=
 =?us-ascii?Q?HhP/jumN8IM6DOsk689jKYJsTuFvRH+qGKZwxFczNEP0dXMkbZNegSbXHZ3B?=
 =?us-ascii?Q?EL+w+37cRcdnXA9KcW1d80wYoA5wOjpfFS0cFBKloExdz1oFNpd+yBySijsc?=
 =?us-ascii?Q?OUPW4q5YPC0mFODnXsA+TCLHcAsRpFtcS7R5K2ypTqmqMlp9q5iiLZrRQexY?=
 =?us-ascii?Q?f2AGdeiVGZ4HW56dW+ib0HwCGZQgVwPto+c/KugR1Bv0roJ0u7RXcINSzZ/w?=
 =?us-ascii?Q?4ssFSz5UmL0tscG3xVTp9kdiW4OwHSY5HvPx03sH/WHgZ2WyON875axZbdmL?=
 =?us-ascii?Q?OVkPKX6rvYMFOR2Z6pNQVAUNLWQaPk75dftyRjM+M00qIz9mrQlCOMcch2jz?=
 =?us-ascii?Q?nw4OOEI+CIh/22M8qAUQSS7jUkJoTldUtsvMdAQJ3vcotJTWv6aJ319odC47?=
 =?us-ascii?Q?8X2WJJvE8Ul7O9VGIgJgb0H0FeHR5/SZ5ANFcmnWaznxNWs7acmI5QyoBPMY?=
 =?us-ascii?Q?U05sbi8wo2U7+FG7iLrcu3ZMLVCDv0JZkDTFop3zRjTCpWkjLwrxXxx7Nopp?=
 =?us-ascii?Q?DrJB3pAJ5qzKvXmPxzYRQF/cuKJuJq5TfasnAVF0+HzNG5+ljFP65G0PAQ9b?=
 =?us-ascii?Q?mrzmd3MvlRguy4KqFaUPmqtQKCgWxCHIaVva7dJ04MbJSD6jBya0y47DMmXu?=
 =?us-ascii?Q?iEk4hL6MF57nuWlJiC4Rp6ZVS5hxDjZzsV7AbxXvNBi0XwVO6r0uhOaOE3AP?=
 =?us-ascii?Q?AzD1qtuLCQWpTRtMeI9kJ/eaE1f5IH+gAgErqrCO1evcwyxTcVtL++eIXYhl?=
 =?us-ascii?Q?4jscpjDCKzojLuP7uIEoapoAdN1DhVtyvPQH4OtwR4RXbcQigwzQpNBYQXvQ?=
 =?us-ascii?Q?KE/IJ9G33toSxVPQlsKT1LFTn3Gp+fPUrzPv43VnQZKdgoy9kurR6VvtKEKs?=
 =?us-ascii?Q?vNUHHmxtXZsjKg2UpkIaC8+yz+5E8gJJ+GMMswm7g6mfduCO3mTVzc+COZjT?=
 =?us-ascii?Q?Ag=3D=3D?=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afc7ba40-16ae-4408-fc5c-08dda7596017
X-MS-Exchange-CrossTenant-AuthSource: AM8PR08MB5732.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2025 13:27:27.1161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M+1X6bCN/O0Kr09eoSmdWoKQ67EDMdxjgzIzyQcrs9cz2WKPa58WbaAKf5Fsj4v5Fwv1pm89Sz5ZK4fpul+76b1sGAw2jhJ0xVDEBCpq6fg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB8564

When hotplugging vCPUs to the Windows vms, we observed strange instance
crash on Intel(R) Xeon(R) CPU E3-1230 v6:
panic hyper-v: arg1='0x3e', arg2='0x46d359bbdff', arg3='0x56d359bbdff', arg4='0x0', arg5='0x0'

Presumably, Windows thinks that hotplugged CPU is not "equivalent enough"
to the previous ones. The problem lies within msr 3a. During the startup,
Windows assigns some value to this register. During the hotplug it
expects similar value on the new vCPU in msr 3a. But by default it
is zero.

   CPU 0/KVM-16856   [007] .......   380.398695: kvm_msr: msr_read 3a = 0x0        <debug_before_write>
   CPU 0/KVM-16856   [007] .......   380.398696: kvm_msr: msr_write 3a = 0x40005
   CPU 3/KVM-16859   [001] .......   380.398914: kvm_msr: msr_read 3a = 0x0        <debug_before_write>
   CPU 3/KVM-16859   [001] .......   380.398914: kvm_msr: msr_write 3a = 0x40005
   CPU 2/KVM-16858   [006] .......   380.398963: kvm_msr: msr_read 3a = 0x0        <debug_before_write>
   CPU 2/KVM-16858   [006] .......   380.398964: kvm_msr: msr_write 3a = 0x40005
   CPU 1/KVM-16857   [004] .......   380.399007: kvm_msr: msr_read 3a = 0x0        <debug_before_write>
   CPU 1/KVM-16857   [004] .......   380.399007: kvm_msr: msr_write 3a = 0x40005
   CPU 0/KVM-16856   [001] .......   384.497714: kvm_msr: msr_read 3a = 0x40005
   CPU 0/KVM-16856   [001] .......   384.497716: kvm_msr: msr_read 3a = 0x40005
   CPU 1/KVM-16857   [007] .......   384.934791: kvm_msr: msr_read 3a = 0x40005
   CPU 1/KVM-16857   [007] .......   384.934793: kvm_msr: msr_read 3a = 0x40005
   CPU 2/KVM-16858   [002] .......   384.977871: kvm_msr: msr_read 3a = 0x40005
   CPU 2/KVM-16858   [002] .......   384.977873: kvm_msr: msr_read 3a = 0x40005
   CPU 3/KVM-16859   [006] .......   385.021217: kvm_msr: msr_read 3a = 0x40005
   CPU 3/KVM-16859   [006] .......   385.021220: kvm_msr: msr_read 3a = 0x40005
   CPU 4/KVM-17500   [002] .......   453.733743: kvm_msr: msr_read 3a = 0x0        <- new vcpu, Windows wants to see 0x40005 here instead of default value>
   CPU 4/KVM-17500   [002] .......   453.733745: kvm_msr: msr_read 3a = 0x0

Bit #18 probably means that Intel SGX is supported, because disabling
it via CPU arguments results is successfull hotplug (and msr value 0x5).

At least Win2k16, Win2k19, Win2k22 are affected. This a Windows bug, but
in my opinion, given the broad range of affected OSes, it is worth to
have a hack.

This patch introduces new CPU option: QEMU will copy msr 3a value from
the first vCPU during the hotplug. This problem may not be limited to
SGX feature, so the whole register is copied.
By default the option is set to auto and hyper-v is used as Windows
indicator to enable this new feature.

Resolves: #2669
Signed-off-by: Andrey Zhadchenko <andrey.zhadchenko@virtuozzo.com>
---
 target/i386/cpu.c     |  2 ++
 target/i386/cpu.h     |  3 +++
 target/i386/kvm/kvm.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 48 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 40aefb38f6..5c02f0962d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -9389,6 +9389,8 @@ static const Property x86_cpu_properties[] = {
     DEFINE_PROP_BOOL("x-intel-pt-auto-level", X86CPU, intel_pt_auto_level,
                      true),
     DEFINE_PROP_BOOL("x-l1-cache-per-thread", X86CPU, l1_cache_per_core, true),
+    DEFINE_PROP_ON_OFF_AUTO("kvm-win-hack-sgx-cpu-hotplug", X86CPU,
+                            kvm_win_hack_sgx_cpu_hotplug, ON_OFF_AUTO_AUTO),
 };
 
 #ifndef CONFIG_USER_ONLY
diff --git a/target/i386/cpu.h b/target/i386/cpu.h
index 545851cbde..0505d3d1cd 100644
--- a/target/i386/cpu.h
+++ b/target/i386/cpu.h
@@ -2301,6 +2301,9 @@ struct ArchCPU {
     /* Forcefully disable KVM PV features not exposed in guest CPUIDs */
     bool kvm_pv_enforce_cpuid;
 
+    /* Copy msr 3a on cpu hotplug */
+    OnOffAuto kvm_win_hack_sgx_cpu_hotplug;
+
     /* Number of physical address bits supported */
     uint32_t phys_bits;
 
diff --git a/target/i386/kvm/kvm.c b/target/i386/kvm/kvm.c
index 56a6b9b638..c1e7d15e2e 100644
--- a/target/i386/kvm/kvm.c
+++ b/target/i386/kvm/kvm.c
@@ -5266,6 +5266,42 @@ static int kvm_get_nested_state(X86CPU *cpu)
     return ret;
 }
 
+static int kvm_win_hack_hotplug_with_sgx(CPUState *cs)
+{
+    DeviceState *dev = DEVICE(cs);
+    X86CPU *cpu = X86_CPU(cs);
+    int ret;
+
+    /*
+     * If CPU supports Intel SGX, Windows guests expect readmsr 0x3a after
+     * hotplug to have some bits set, just like on other vCPUs. Unfortunately
+     * by default it is zero and other vCPUs registers are filled by Windows
+     * itself during startup.
+     * Just copy the value from another vCPU.
+     */
+
+    if (cpu->kvm_win_hack_sgx_cpu_hotplug == ON_OFF_AUTO_OFF ||
+        (cpu->kvm_win_hack_sgx_cpu_hotplug == ON_OFF_AUTO_AUTO &&
+        !hyperv_enabled(cpu))) {
+        return 0;
+    }
+
+    if (cpu->env.msr_ia32_feature_control) {
+        return 0;
+    }
+
+    if (IS_INTEL_CPU(&cpu->env) && dev->hotplugged && first_cpu) {
+        ret = kvm_get_one_msr(X86_CPU(first_cpu),
+                              MSR_IA32_FEATURE_CONTROL,
+                              &cpu->env.msr_ia32_feature_control);
+        if (ret != 1) {
+            return ret;
+        }
+    }
+
+    return 0;
+}
+
 int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp)
 {
     X86CPU *x86_cpu = X86_CPU(cpu);
@@ -5273,6 +5309,13 @@ int kvm_arch_put_registers(CPUState *cpu, int level, Error **errp)
 
     assert(cpu_is_stopped(cpu) || qemu_cpu_is_self(cpu));
 
+    if (level == KVM_PUT_FULL_STATE) {
+        ret = kvm_win_hack_hotplug_with_sgx(cpu);
+        if (ret < 0) {
+            return ret;
+        }
+    }
+
     /*
      * Put MSR_IA32_FEATURE_CONTROL first, this ensures the VM gets out of VMX
      * root operation upon vCPU reset. kvm_put_msr_feature_control() should also
-- 
2.43.0


