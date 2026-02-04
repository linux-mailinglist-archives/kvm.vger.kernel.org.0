Return-Path: <kvm+bounces-70150-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wBA/CUf5gmm2fwMAu9opvQ
	(envelope-from <kvm+bounces-70150-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:15 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9236FE2CAD
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 08:46:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3608F3040239
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 07:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 991CA385514;
	Wed,  4 Feb 2026 07:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="F7gF1XV4"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012034.outbound.protection.outlook.com [52.101.48.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81512192FA
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 07:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.34
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770191136; cv=fail; b=G6caY3fZIBuEoyKxaUlzG5c+QveI9XvopciHVQ73Juawpu2PYVGk2AteyAJWYtqIsEFklK8sW5s1mv5BNKpNpmEZMrN/HFWTtuRNlnCZd/VVbXxjChWfkYOQxVCpoNQCMqoJyzPxfsfKkKEzYsQ9JsnviUW6I5p+LvgGnzSWryE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770191136; c=relaxed/simple;
	bh=vkih4asyWZjkXjD71RW6FV7rEhhRYDDd764FsRZat5w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2X7cEdhJbeguikSc/A3yAzPh/Vo8jPDNB2QbyJPGCw4E22jJ3cvjBOdtAIlr99B9xIQ1OKfGmeXBbHFNuBNv1lp27XqWaKkjfobZyRRAxNHKTkvE/lacEsSucgx5r3Uhi8sO+1oxcYkkiJxppkeHcHcSCFebe/F0zURkXs7A5U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=F7gF1XV4; arc=fail smtp.client-ip=52.101.48.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=A2szOzwi0PwBSIwBkLKnCIPesv+LxGAimWi3tF8ZRfNoxJdtojj00rQ8vprtjSUcf8CS5mAXGB0kxLje4WVRd+W1D7E8IeDf2CGlX0X8IoPn+mBcCmbFKKGUBhUqCwy0Qr9/2l0oTN9wCQubFWe45xgJpiu6e8tiSFQe29bYIbEJAPIvnjv0wg8q1TPT8+8sWcokwV7F6++gMJWuX/Coz7LA7c9qDgKHJUC3gekMP7kjUA7d8A8aLM6Etw1mVo3DnCLrZZAVAZs6+0f9NCHkpGlh2+PWPrWw6DeGPgJyRRs9ziI3/L6UqsaWdp3AeJDb6p6XjB/nrB+s+Zd7i9wTqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Bbv1rISRmCuqYrHMQ5GM9lhJ3hD2X7PMEIFLmD+xnI=;
 b=m1uyAMvouTkuHFE31UsTkdYqsDG37aeezJjKnCXCNGSmBO+xum2wO4th7e5EpgvcVkBsQVNe7qyEQGQZoyulTabTHwahl5eyXbOK9u84h9Pv7CiDsf04WJy56l5fcxNkfCQlDBU15OfyMMwmbpOu0YhZ/slaNf1q3gHZREbvHr/T88Br9m6C+UD2FbpIn//fYB7dAc2f+/aOehABs7DU8ne+jIu3uQO4Vbt1iXaitj7vT2wVGAFCg49d634kfFClQQdu2ULAd7udzUboPWcNMkmyiY4Z02yiuNr6cVdAbvX/O+wuQEo3oozZE/Jwu2YLZYEhuu5HY9sfOsLJNcse+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Bbv1rISRmCuqYrHMQ5GM9lhJ3hD2X7PMEIFLmD+xnI=;
 b=F7gF1XV4m9ubTuYBwj2WE/X5flYHIZDLR9Lm0lGHpmzDZAqSs+dEL7jC1SYl5yhvTJmaclMvjhbtLzc02JUpFj9y3BZ46NZfMPklmQedeepBvKN+/wxFjfQqDU5Pd/Bv2zClth06loFN2uEQW3eUkfrUzCr8m4gZyWHyKiY1NgQ=
Received: from SA1PR02CA0002.namprd02.prod.outlook.com (2603:10b6:806:2cf::6)
 by SA3PR12MB9090.namprd12.prod.outlook.com (2603:10b6:806:397::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.16; Wed, 4 Feb
 2026 07:45:33 +0000
Received: from SN1PEPF0002636B.namprd02.prod.outlook.com
 (2603:10b6:806:2cf:cafe::fb) by SA1PR02CA0002.outlook.office365.com
 (2603:10b6:806:2cf::6) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9587.13 via Frontend Transport; Wed,
 4 Feb 2026 07:45:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SN1PEPF0002636B.mail.protection.outlook.com (10.167.241.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9587.10 via Frontend Transport; Wed, 4 Feb 2026 07:45:33 +0000
Received: from brahmaputra.amd.com (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Wed, 4 Feb
 2026 01:45:30 -0600
From: Manali Shukla <manali.shukla@amd.com>
To: <seanjc@google.com>, <pbonzini@redhat.com>
CC: <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<kvm@vger.kernel.org>, <x86@kernel.org>, <santosh.shukla@amd.com>,
	<nikunj.dadhania@amd.com>, <Naveen.Rao@amd.com>,
	<dapeng1.mi@linux.intel.com>, <manali.shukla@amd.com>
Subject: [PATCH v1 6/9] KVM: Add KVM_GET_LAPIC2 and KVM_SET_LAPIC2 for extended APIC
Date: Wed, 4 Feb 2026 07:44:49 +0000
Message-ID: <20260204074452.55453-7-manali.shukla@amd.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260204074452.55453-1-manali.shukla@amd.com>
References: <20260204074452.55453-1-manali.shukla@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: satlexmb07.amd.com (10.181.42.216) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF0002636B:EE_|SA3PR12MB9090:EE_
X-MS-Office365-Filtering-Correlation-Id: 119a6021-d061-4544-62b1-08de63c160da
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?v506Xiv1Q8zfOaZfowTY8f8TI4ti2SgHJKQo/60dK1QSlgBO3ZnjtFudSpDx?=
 =?us-ascii?Q?ZJlqAI2+0eIHaQ6nOBNI9rYus6qy4mx8Zg9UY3i6SqCfPCkvQYvC4615CjCd?=
 =?us-ascii?Q?pR1vj3xztNK6tSkgintx3Mn29w/wEX22vNFhhQbz4NGgbcVBlr9c0+VQRlVd?=
 =?us-ascii?Q?5jVuldrUBtzg6CipRiIpRYsBiBcxZXmjqc5uZL1QYtbPzBZ0przg63aD4F7Y?=
 =?us-ascii?Q?GpXJvU3Q5esKgPZMQG5n4qOxQaf2jdBXMynDVMMlKfaX2/y2UVY7BRIYXvds?=
 =?us-ascii?Q?PlDPF4gg+jiQoWSPFHUoI89ofqw0REzWzVru9YR+11IhIPTOLFR6iLbIY9sS?=
 =?us-ascii?Q?iu5cs/1tyIw8QU+jywQ2SYiZWJ3fcJ97Eaxo80fTIP9iBWHeWoVZiqzr+9Io?=
 =?us-ascii?Q?TrXL6v5FKOfrID1t31YNagA5+jUp3tv6r4BD6bvqF8v2E1gQBdEfA9mK3DIY?=
 =?us-ascii?Q?A/Yr5X/K8/4XWqZwTDyP8WmXbphNW9dp0KzRBOVGL4DuTaPwp0U3N7b8BedI?=
 =?us-ascii?Q?OMS78hr/AprHinHALIcGImf4lmhoCd4VpLaOWhcwBTMe4ianuCCFO5J6AwwA?=
 =?us-ascii?Q?hjCd2yMrV3kAsdwrabaz9rBJ7R94mnQMZqIj1ucBRbhdYj+pj+KWdeiDBTLf?=
 =?us-ascii?Q?KGLBEijj4L+oZjNSNu5RHMSBuDydSRIcwsabDsHuZtpbnIknZMY886R+CBQk?=
 =?us-ascii?Q?Pj5YKU0yS67YcSMbAVZz3m9MzLQkt7r1157/82yfZwDMNHMUXH0ekofdDkAO?=
 =?us-ascii?Q?27fz69YSBzqKcCwvg6tbRbi1GykLQ3eijaxNgORqntd6vFQIcA+vNGZjLVYE?=
 =?us-ascii?Q?nJS8z5w0gx9Y9xSAY4xdwqq+HqgUGQDZI9KDoGk/cU+PURNfZ6K4aKfBSsz4?=
 =?us-ascii?Q?36d3TQCXVSWhD17zU+fpgp4FyemYdXeT9qnK6f5VSuQiMrzo940rnG5hhV8a?=
 =?us-ascii?Q?+gkJcgD/IscAY1HmgV6XIza3IXCa2xcp90lQ8Zw2S2kJHaiiER69+UurrahK?=
 =?us-ascii?Q?1QN9lBiMeDPLwbKw18EaSnKKhyv6infOEQ26xYXwhpy5BAZ4l8nskR029Zsb?=
 =?us-ascii?Q?mDzE05BI7YdwYO1+bYySztvU92EMt89qZOGt3NMQZpT9prXPXt5onw6Xav+h?=
 =?us-ascii?Q?SOPNfLGo0i3nOKSKKZ221GNCT7/Jvpl4RR80NIihS8ddjirq5lxgd1WxVVXW?=
 =?us-ascii?Q?Z8O7CxOuQ6ZKl5mMzqhw3HP52s5leqUC2QCMQJ4S/y8RiKVJosWk+nDrMygq?=
 =?us-ascii?Q?z3Qxf8tLf2tmBQuJbI60VvHvSfENcFcyLS2kaek1muxNE/jD5LX4mHvpM3pC?=
 =?us-ascii?Q?ShOUPtUcyjocJQqsXDOsatI3l5bYQ8pPee3l8p0j9WALfw38IGCBw6TmzWFV?=
 =?us-ascii?Q?MFKNw5ynKpAbWpDzZTfDdpKW1j6BRFdaEKRI3Rven0G4uGko1CqsEmPXeG4H?=
 =?us-ascii?Q?8H7QEkt337zDCQ97Q/W5BH0sNZJDyAbLqvbBbYkXJEUvZ5FdRuIo0y89eipO?=
 =?us-ascii?Q?Rd+lnLG5wOxaVpjwFQ+K7HaNRalola8LRC7FmuoD9lCxWAM1KDLoAP9YfMpp?=
 =?us-ascii?Q?ZNZbVws5jd64s1K2IYpIHoJl6H2WJP7zd+Quzd7u1M+PmvQKvCBBwGCdwdpl?=
 =?us-ascii?Q?g0Z40lsAHD6ja2zJ9HLDWBVfBrRbhWnDFfvRB7fd/r4WlgiJ9Lm0ovEk9Rrp?=
 =?us-ascii?Q?MjmnhA=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	V15CTuQrvPgWupYlw9eFL0qsPf+7GlqJuJIQQxmWXwzGTebcRDgjXfT/aebY4kaFozRU/5CV6pa+7KZNv0d61K95/KooP2GHX7L+TutXM0K7PelPBwJyIXsiSQ3plHLBobJgzUk9FHlv4+vZoYp7B71QIkjboCFZ+5jAT4Cu7epYkodXSWahFu7XlVkpsyOw9Xh/xJGleVyYebHFVUqISuIipfCmV0imbggKpzNqBr62brm/CUTqxgrPRUsum3dJ/+uHNcK6ztz2sRX08XATZKM7COgDE1qLPRSnux+G81Z6vLAm8i5tZKRfxRXbGDbL/ouAYhqkU7uXYK33UORAvUl6QELK+rSkv2A1EK+f4V7VqJXBAIkQfeB0FPku/xYQHjYMXRpaBRxqH0clK5es0JOwp8zF4KiHqcJ9KjHem6b3/osz1IR9Y+l34EuKtAT4
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2026 07:45:33.7284
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 119a6021-d061-4544-62b1-08de63c160da
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF0002636B.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR12MB9090
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70150-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[amd.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[manali.shukla@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_NONE(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	DBL_BLOCKED_OPENRESOLVER(0.00)[amd.com:email,amd.com:dkim,amd.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[7]
X-Rspamd-Queue-Id: 9236FE2CAD
X-Rspamd-Action: no action

Add KVM_GET_LAPIC2 and KVM_SET_LAPIC2 ioctls to save and restore APIC
state using a 4KB buffer (kvm_lapic_state2).  The larger buffer allows
saving additional APIC registers beyond the standard APIC registers
supported by the existing 1KB KVM_GET/SET_LAPIC ioctls.

The 4KB buffer size matches the LAPIC2 capability, which enables the
full APIC register page including extended APIC registers for AMD
processors.

KVM_GET/SET_LAPIC continue to work as before for backward compatibility.
Document the new ioctls in Documentation/virt/kvm/api.rst.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Manali Shukla <manali.shukla@amd.com>
---
 Documentation/virt/kvm/api.rst  | 45 +++++++++++++++++++++++++
 arch/x86/include/uapi/asm/kvm.h |  5 +++
 arch/x86/kvm/x86.c              | 59 +++++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h        |  2 ++
 4 files changed, 111 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 71b4d24f009a..c49cf3104b2c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6517,6 +6517,51 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_GET_LAPIC2
+----------------------
+
+:Capability: KVM_CAP_LAPIC2
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_lapic_state2 (out)
+:Returns: 0 on success, negative on failure
+
+Reads the extended Local APIC registers, including both the standard APIC
+register space (offsets 0h-3FFh) and the extended APIC register space (offsets
+400h-500h and beyond).
+
+This ioctl is similar to KVM_GET_LAPIC but operates on a 4KB APIC
+register space that includes extended LVT registers available on AMD processors
+with the ExtApicSpace feature.
+
+::
+
+  #define KVM_APIC_EXT_REG_SIZE 0x1000
+  struct kvm_lapic_state2 {
+      char regs[KVM_APIC_EXT_REG_SIZE];
+  };
+
+4.145 KVM_SET_LAPIC2
+----------------------
+
+:Capability: KVM_CAP_LAPIC2
+:Architectures: x86
+:Type: vcpu ioctl
+:Parameters: struct kvm_lapic_state2 (in)
+:Returns: 0 on success, negative on failure
+
+Sets the extended Local APIC registers, including both the standard APIC
+register space and the extended APIC register space.
+
+This ioctl is similar to KVM_SET_LAPIC but operates on a 4KB APIC register space
+that includes extended LVT registers for AMD processors.
+
+::
+
+  #define KVM_APIC_EXT_REG_SIZE 0x1000
+  struct kvm_lapic_stat2 {
+      char regs[KVM_APIC_EXT_REG_SIZE];
+  };
 
 .. _kvm_run:
 
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 7ceff6583652..516d4a0be25a 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -129,6 +129,11 @@ struct kvm_lapic_state {
 	char regs[KVM_APIC_REG_SIZE];
 };
 
+#define KVM_APIC_EXT_REG_SIZE 0x1000
+struct kvm_lapic_state2 {
+	char regs[KVM_APIC_EXT_REG_SIZE];
+};
+
 struct kvm_segment {
 	__u64 base;
 	__u32 limit;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 669c894f1061..ccd16bdff56a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5331,6 +5331,17 @@ static int kvm_vcpu_ioctl_get_lapic(struct kvm_vcpu *vcpu,
 	return kvm_apic_get_state(vcpu, s->regs, sizeof(*s));
 }
 
+static int kvm_vcpu_ioctl_get_lapic2(struct kvm_vcpu *vcpu,
+				    struct kvm_lapic_state2 *s)
+{
+	if (vcpu->arch.apic->guest_apic_protected)
+		return -EINVAL;
+
+	kvm_x86_call(sync_pir_to_irr)(vcpu);
+
+	return kvm_apic_get_state(vcpu, s->regs, sizeof(*s));
+}
+
 static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 				    struct kvm_lapic_state *s)
 {
@@ -5347,6 +5358,22 @@ static int kvm_vcpu_ioctl_set_lapic(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int kvm_vcpu_ioctl_set_lapic2(struct kvm_vcpu *vcpu,
+				    struct kvm_lapic_state2 *s)
+{
+	int r;
+
+	if (vcpu->arch.apic->guest_apic_protected)
+		return -EINVAL;
+
+	r = kvm_apic_set_state(vcpu, s->regs, sizeof(*s));
+	if (r)
+		return r;
+	update_cr8_intercept(vcpu);
+
+	return 0;
+}
+
 static int kvm_cpu_accept_dm_intr(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -6203,6 +6230,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 	union {
 		struct kvm_sregs2 *sregs2;
 		struct kvm_lapic_state *lapic;
+		struct kvm_lapic_state2 *lapic2;
 		struct kvm_xsave *xsave;
 		struct kvm_xcrs *xcrs;
 		void *buffer;
@@ -6243,6 +6271,37 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 		r = kvm_vcpu_ioctl_set_lapic(vcpu, u.lapic);
 		break;
 	}
+	case KVM_GET_LAPIC2: {
+		r = -EINVAL;
+		if (!lapic_in_kernel(vcpu))
+			goto out;
+		u.lapic2 = kzalloc(sizeof(struct kvm_lapic_state2), GFP_KERNEL);
+
+		r = -ENOMEM;
+		if (!u.lapic2)
+			goto out;
+		r = kvm_vcpu_ioctl_get_lapic2(vcpu, u.lapic2);
+		if (r)
+			goto out;
+		r = -EFAULT;
+		if (copy_to_user(argp, u.lapic2, sizeof(struct kvm_lapic_state2)))
+			goto out;
+		r = 0;
+		break;
+	}
+	case KVM_SET_LAPIC2: {
+		r = -EINVAL;
+		if (!lapic_in_kernel(vcpu))
+			goto out;
+		u.lapic2 = memdup_user(argp, sizeof(*u.lapic2));
+		if (IS_ERR(u.lapic2)) {
+			r = PTR_ERR(u.lapic2);
+			goto out_nofree;
+		}
+
+		r = kvm_vcpu_ioctl_set_lapic2(vcpu, u.lapic2);
+		break;
+	}
 	case KVM_INTERRUPT: {
 		struct kvm_interrupt irq;
 
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index cb27eeb09bdb..f45d313e30ae 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1339,6 +1339,8 @@ struct kvm_vfio_spapr_tce {
 #define KVM_SET_FPU               _IOW(KVMIO,  0x8d, struct kvm_fpu)
 #define KVM_GET_LAPIC             _IOR(KVMIO,  0x8e, struct kvm_lapic_state)
 #define KVM_SET_LAPIC             _IOW(KVMIO,  0x8f, struct kvm_lapic_state)
+#define KVM_GET_LAPIC2            _IOR(KVMIO,  0x8e, struct kvm_lapic_state2)
+#define KVM_SET_LAPIC2            _IOW(KVMIO,  0x8f, struct kvm_lapic_state2)
 #define KVM_SET_CPUID2            _IOW(KVMIO,  0x90, struct kvm_cpuid2)
 #define KVM_GET_CPUID2            _IOWR(KVMIO, 0x91, struct kvm_cpuid2)
 /* Available with KVM_CAP_VAPIC */
-- 
2.43.0


