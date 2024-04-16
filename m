Return-Path: <kvm+bounces-14760-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 071748A6B2B
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:37:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B2A802824D0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 12:37:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5A6312A166;
	Tue, 16 Apr 2024 12:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b="H57J/a7b"
X-Original-To: kvm@vger.kernel.org
Received: from DEU01-BE0-obe.outbound.protection.outlook.com (mail-be0deu01on2104.outbound.protection.outlook.com [40.107.127.104])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E409B101D4;
	Tue, 16 Apr 2024 12:36:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.127.104
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713271005; cv=fail; b=kgatMyPFPX0I1k+69jVNKp4y0BxCFlUFzJIo4sgJ0SZxT/gzKMroyygxbqkZwVOTLFiP7wKTRjuwkEuWwL/TN+IbqKty6WgkjoZ5blZJsn5YsnkxHmwQfoAX5cU9RDKvy6zHN1W3OmtbGKixykhlLsccYkco77W5mNXY9I7pheY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713271005; c=relaxed/simple;
	bh=PaQi7Kdg+bSprtejyY3NaMGR8af5tS/cAE59T4HAdv0=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=uqkMquYot1HBWCiGD2gbhJ/NKJjiENfLhpw506Mb2oUGwzZlPahfAvj8C5LyWQNBLoi8G6PHDKRVKvaMaxceJqpKSrHMrURWKg5fDD3IKQWhACbVTz28NKv/eXogYyXWoeaG9A0e15jDltpau+xzbxIP9MRuKC7FI5wrWNWwvXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de; spf=pass smtp.mailfrom=cyberus-technology.de; dkim=pass (2048-bit key) header.d=cyberus-technology.de header.i=@cyberus-technology.de header.b=H57J/a7b; arc=fail smtp.client-ip=40.107.127.104
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cyberus-technology.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cyberus-technology.de
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M72vljV2SBTYQZs/FehW4F5hLnfLlCqc/cuHGn2aFd2YrnACDgwQWdFFTLcLBHqq3RuLWoCuYgXXoAiYJGBQ+nRSBoxXC3+El0TFLivpOLi2WO4B5CJSMhjgpGxZ75Yf0L8VhQcPLyOfbO95m7HgALJKr5jSsVta2tGrgDTroRxl8QZ1VT2l01UdP2M0IEt4ll6/HxG9WrjaiumY3rSTYMKz49dSwng4sGFU/yjfUBMsNWAPVW04mb2kp4Sn8byOxfVc4TP265F8JOGhGMybqoi4eaMCZacLP9W+T4FwJXRWqDFSnfCxau+58j6f/gKInkQ7XEeRWbJh1FroJqZQrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RaaYZ/Ezw21a6jN9N1MR606d2UFF0BBp5iTDn6vPHc=;
 b=jGTCmTy3noxTU0mtvBf6Dbv91BCvIlHf0cAGZFeSzfipizR6yeUuPhj7WFKlRhKZSQt6a1LM7H3aLEt8VTxUkERRUEwsdjChyoPPM/lxaHny6/oFLDCSRRyJIlz+74lv4vjUExMeXDY7+RkBY4lAnMi9b442k21dE+svZU9SxYIuNpHpRJ0PSnpet/dT5fUwgp29fILGfzN5NtzAJJtv+UNQIgvW+QPyOxH+k+MtzBh0CmhWVbzO5RTkwe+jqUp2KKWtGoBHnHRT6O1mrG+OYfEI3llbTehMIH++crOEYv1CCHWVWr7szWsxsxnX33P+TW3QCEFpTQtpYR9NsnPJiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cyberus-technology.de; dmarc=pass action=none
 header.from=cyberus-technology.de; dkim=pass header.d=cyberus-technology.de;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyberus-technology.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RaaYZ/Ezw21a6jN9N1MR606d2UFF0BBp5iTDn6vPHc=;
 b=H57J/a7bh5xJ80fvXfIIpf426yVugwWUbDXNH48s/wIEu/FnUXfP8ZcIuFpG7CCCbDJiuEiaFVYhmlkFJrbYsS2gfKeZQvTZs086oB5m8grQbbPApTNRjqBk6Pwm+JrisY8vV9guQTpIyYDiQV2YSxJhEfoJInMC3QsrULyzBJPWOBAJTK8ilzhkSogwUcogxaW8sF/f/kUXQBPwYYYnlz7B5c7oWl12Mwl/4xKQ14dEYAsmPl8IDdveAQ+S7BQ95JiY257JWG/j2qibkD1ooWbljWAw0PwxzM45Q3RNuK0/RvXV830RsYlJSGI7ySGZ/npsKrsnrHYqa4MQq98ndw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cyberus-technology.de;
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:38::7) by
 FR2P281MB1543.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:90::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7452.50; Tue, 16 Apr 2024 12:36:38 +0000
Received: from FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::cd58:a187:5d01:55f5]) by FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
 ([fe80::cd58:a187:5d01:55f5%6]) with mapi id 15.20.7452.049; Tue, 16 Apr 2024
 12:36:38 +0000
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
Subject: [PATCH 1/2] KVM: nVMX: fix CR4_READ_SHADOW when L0 updates CR4 during a signal
Date: Tue, 16 Apr 2024 14:35:56 +0200
Message-ID: <20240416123558.212040-1-julian.stecklina@cyberus-technology.de>
X-Mailer: git-send-email 2.43.2
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
X-MS-Office365-Filtering-Correlation-Id: 5a5f1b05-de4c-4a1e-a355-08dc5e11dc72
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?+vNTtfVdsVui/hQRR+5jU8gWU03ea8Z4GjDhqthOoQg/jD7QRtGbOvzVqHGc?=
 =?us-ascii?Q?H3D+EfgNBroMmZgOgJMWS7IriCmo+2kAtTjf5MhoapyYu6aV2q+79afM6cl2?=
 =?us-ascii?Q?DuB2Yfl/rc570Fm1WDFUFUeepNyPvMlWXfYZn0gCT7pry6aQI5iY9rG9y5RD?=
 =?us-ascii?Q?xdVXTOV5MB+LJmJdzTQUq5085eZ7Ksd43wQTMEUm6r6q9h0iulZhPMvm+lnm?=
 =?us-ascii?Q?r3NslvMoZWy5gouiwCkTW4lFf9VuUyktP9d2M2kwZk8v7sboh3P7oNql0/d5?=
 =?us-ascii?Q?ceWwuP2WlId7zyETlNUh9IFkKLheEJKhDW5QQzbXLCcSg8+lBdXW+94GmtRL?=
 =?us-ascii?Q?a5w+JomdCzsYjyrBc48gowmlK1sdPKSFs77mOh1RE8OMr2DfEIbSCnX2BHpk?=
 =?us-ascii?Q?rEynZZPLTIqoWksyrcF2g3J3KZwdau1zlob0PiTChCon08J3Z5OOy/3cGSJv?=
 =?us-ascii?Q?P5wA2xKB5eaGt1QiAMw/Iq4RAsocoYXyNgaYzW21RMZAIdqctAkDqNNR8wmU?=
 =?us-ascii?Q?oC9hf0dddX2Bm48Inx1nbUR2vYClYBs/R30jiocwrQbIw5sDg7uyyf8E+w6d?=
 =?us-ascii?Q?eQIEVxmE4SYa+Nqknbo9qA8XES35LmDXXT1Kpi4TP37cJ+OXUH7Ex7jNyub3?=
 =?us-ascii?Q?7+DUt8gm5JpN/IHKb50WbFMZfx7wzyZtT5EohkafaarGfHY6Ro7s2BJuZ+fV?=
 =?us-ascii?Q?Dzyo7OtT2hlKlL4vWfxW9oygOV96K/be8H1uiJweQ58uU2hCz2g77LVpzfmQ?=
 =?us-ascii?Q?OUsNYkTjZjgg6NEUYxC1VwZ5j0lfZmdXFLGL79V9Cm6ZaO1bcZkegAd2U63S?=
 =?us-ascii?Q?dOx4J6BfB39uu1GCZ7MLE5ZEgNi7r/1DnFmUkx6NOgsMx+QjKP6/KDykwIkL?=
 =?us-ascii?Q?RvXFKNcI3hAhMH46Lw0GcaTadbiAF94+W8RTuXn26rrsQ9abO1uDfstpfeF5?=
 =?us-ascii?Q?JlnhwJhZBT4MVdeWNSovsNc14QTKt5BhOCGieX8gBJKVDMoR7waLZWn1ZMVX?=
 =?us-ascii?Q?P+P2dT5MJNCZ/avLZ6DQbp9Sg4mW7O6n14nSuNMuCyiZK8YDPECcFVUiIEO4?=
 =?us-ascii?Q?uoqp3xThvj5JbafppUGeMx++OVWiHO0TcYbfkIvXGGTU/Zo68y63KQje4aBb?=
 =?us-ascii?Q?xnjwoH1dAop3NcaAa4UlYHbsf8FJkqJliDnxFsikNcnbd+i6H2cTc++KKjtK?=
 =?us-ascii?Q?VqBvMUDyJB92jncmLuAupWgvUMcKahgknElpxqM1z1vqFYhIrHNhQIVbxLyk?=
 =?us-ascii?Q?ivGhZdGLU65FxOw8DP5kTkS4AyFdlyER6ZpkuIpNSA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(7416005)(376005)(1800799015)(366007)(52116005)(38350700005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mUYSpRUs8SNZuhhpPdAO4waLeoDnjYiZ1xTRSDM7fGp2cbyY+akneOaGj80g?=
 =?us-ascii?Q?yqcw6837IcIlkhtwF+iGniJUTQAecVSBTKGwnUiktjH+eZimM0VwhX/FkYTP?=
 =?us-ascii?Q?NMXW2lY375+daOSmAGEISDGCjZlwz08kAYwCrVkuS/Tr7pKfcF7/8xEg/r1h?=
 =?us-ascii?Q?vd2doLzzLjcIUCCraSTGfxBsMqkkr2HRTEPa/bdMBuAQca7QOGUW4CsrY9l+?=
 =?us-ascii?Q?SWqxrIw8HW505kGru2E4N2O+GnH/2jAuLQiUzXA+ZT37HRt9JT9oneCfqpqi?=
 =?us-ascii?Q?aqEdrjVr2bINhPMEFRpxhS1TWgsb30PAlcXXTMdbGOxS+VOCeHw6jsKlXQSq?=
 =?us-ascii?Q?Cid6YlkMDXz2AfCvgvZSBZ5DI0Iz7lZrKEO9fYAGbMxYx1xchBPivfEXdHbX?=
 =?us-ascii?Q?WXspvIrivysdXHllwlKJ+luqv7wM4iPkIxaEmVpKylwlXjlUYBEuC+PmvAQw?=
 =?us-ascii?Q?ggXpma4QO58FN85paGkTOPA/DBBsWZsKww/HDFme70WmlTw2l8ThKVzDjcG8?=
 =?us-ascii?Q?jq9+pv+uK1QzYBl5K14Dop2N+ERN74FOIVm74NnnwkPJz+62X4C3ZUvxAwx1?=
 =?us-ascii?Q?u20rFogiTZiUSvCxxF9j/oxWi7sezzrYpimeJg4EzjwexjOWDAEMSWGVt+oW?=
 =?us-ascii?Q?QX9KRZhSsgItE5zJBCbFlJ7TBpme1kcKkztJmpIMckW5Yco+ZJF3ta/fvqxJ?=
 =?us-ascii?Q?tXoUdH+8LOjp1KHkEOT/wmUYi0H8kapHLHTxzirEc1VNHTvLq/OT0ZCtjaAR?=
 =?us-ascii?Q?2G0hdL4DXm6BvlS7sVZm6e6vycl+vk8YLfUQXTv/WgHm3DKRnWBhsOlPTTKB?=
 =?us-ascii?Q?dOiWDdl2ANhOyvBFN5CLw451HvRVyIJJApp4sLzpfuvnYF3UQcGqNgkPmx9N?=
 =?us-ascii?Q?FZ0F9iC53EcbVAYKMaU7Nl6VEyaLbp9UOXNU9tlupy6eP/PmSV5aEHbyQfdl?=
 =?us-ascii?Q?TBrMOfMtZMKld5fvdUrVxMOgPNHI48Bilz4dlPXRll6k//w56ttnCQ4dZmBR?=
 =?us-ascii?Q?s2VDEgyp3soBsLChLRtBsszqsCf8KFV/9J6LvRYEl/niZde3fnFzc+aIjana?=
 =?us-ascii?Q?0YjjoPT3ki2aMwaYQJFAK8mywZ5Q6/NY2dMcJCrR2/csGaUOeOzeQgcBIin5?=
 =?us-ascii?Q?wlOIH8DPq6F7U0dqaGPFaOqEH2iKGBK4Ko6QhdCxzp+4vkP+z6OrjzMlmrHX?=
 =?us-ascii?Q?qCzWIR3MRw33kbezAeFOZZU3MUF9+ZOQr2gTkiBVHSn+vcbgqF31HadycrDt?=
 =?us-ascii?Q?iS9PWLYPCK/ox5Z4stSg/eUMx3JwwXA7siYZS/3MMtv14oKX27jcHYNgsLXj?=
 =?us-ascii?Q?iiMBQuHKTu7A4SqhL8YZI1XfqmOZInJxu+Xla/WbJSZyEhEXlasS2WkJBpUM?=
 =?us-ascii?Q?ozLXgriE55tiTrLZr58zsdHiKmfXUfFcZUM96xhJKxhRUidKENWp+/UFsY5I?=
 =?us-ascii?Q?/s36TygwDTbnGBWfEWem61nhp8pWVT5EXeLJqTCZEE4N1gH6mSwvgUIVTqVk?=
 =?us-ascii?Q?Qh4ci+euVvJIdfWc83NhNqv8ZHXinHzpIOnbWjqwZpms0edB4BZzn2ZJkdBx?=
 =?us-ascii?Q?8o9eIN8pPD8M0rm+wyoZ+8xXvT7Zl1or8x8FMqXgPhgwvrcnG5Vwcsz+XLaU?=
 =?us-ascii?Q?Szilt6Th9n0CklZ+SpUxHcU=3D?=
X-OriginatorOrg: cyberus-technology.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a5f1b05-de4c-4a1e-a355-08dc5e11dc72
X-MS-Exchange-CrossTenant-AuthSource: FR2P281MB2329.DEUP281.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2024 12:36:38.7138
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f4e0f4e0-9d68-4bd6-a95b-0cba36dbac2e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Ve3BSVMTG8EUL5E8/sY+Agm/CBL0j4mQ8Kl+N6YSXyWuqbDaNw8t1m+xXwnKU0lN3/QlRKm0vQ0kmf5Rx0hCMYXNChJWj0xmN1CMWF47/vo3RkdvUY7Vt5kxYyk8iGU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: FR2P281MB1543

From: Thomas Prescher <thomas.prescher@cyberus-technology.de>

This issue occurs when the kernel is interrupted by a signal while
running a L2 guest. If the signal is meant to be delivered to the L0
VMM, and L0 updates CR4 for L1, i.e. when the VMM sets
KVM_SYNC_X86_SREGS in kvm_run->kvm_dirty_regs, the kernel programs an
incorrect read shadow value for L2's CR4.

The result is that the guest can read a value for CR4 where bits from
L1 have leaked into L2.

We found this issue by running uXen [1] as L2 in VirtualBox/KVM [2].
The issue can also easily be reproduced in Qemu/KVM if we force a sreg
sync on each call to KVM_RUN [3]. The issue can also be reproduced by
running a L2 Windows 10. In the Windows case, CR4.VMXE leaks from L1
to L2 causing the OS to blue-screen with a kernel thread exception
during TLB invalidation where the following code sequence triggers the
issue:

mov rax, cr4 <--- L2 reads CR4 with contents from L1
mov rcx, cr4
btc 0x7, rax <--- L2 toggles CR4.PGE
mov cr4, rax <--- #GP because L2 writes CR4 with reserved bits set
mov cr4, rcx

The existing code seems to fixup CR4_READ_SHADOW after calling
vmx_set_cr4 except in __set_sregs_common. While we could fix it there
as well, it's easier to just handle it centrally.

There might be a similar issue with CR0.

[1] https://github.com/OpenXT/uxen
[2] https://github.com/cyberus-technology/virtualbox-kvm
[3] https://github.com/tpressure/qemu/commit/d64c9d5e76f3f3b747bea7653d677bd61e13aafe

Signed-off-by: Julian Stecklina <julian.stecklina@cyberus-technology.de>
Signed-off-by: Thomas Prescher <thomas.prescher@cyberus-technology.de>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 6780313914f8..0d4af00245f3 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -3474,7 +3474,11 @@ void vmx_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
 			hw_cr4 &= ~(X86_CR4_SMEP | X86_CR4_SMAP | X86_CR4_PKE);
 	}
 
-	vmcs_writel(CR4_READ_SHADOW, cr4);
+	if (is_guest_mode(vcpu))
+		vmcs_writel(CR4_READ_SHADOW, nested_read_cr4(get_vmcs12(vcpu)));
+	else
+		vmcs_writel(CR4_READ_SHADOW, cr4);
+
 	vmcs_writel(GUEST_CR4, hw_cr4);
 
 	if ((cr4 ^ old_cr4) & (X86_CR4_OSXSAVE | X86_CR4_PKE))
-- 
2.43.2


