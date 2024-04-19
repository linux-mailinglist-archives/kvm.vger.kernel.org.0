Return-Path: <kvm+bounces-15270-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A66E8AAEE9
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 14:59:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BBE6B1C21D24
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 12:59:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D864B128806;
	Fri, 19 Apr 2024 12:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KG6TWJYD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2062.outbound.protection.outlook.com [40.107.220.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9282C8614B
	for <kvm@vger.kernel.org>; Fri, 19 Apr 2024 12:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713531533; cv=fail; b=IkzRJg5ip9jmsfMI9Qb8TtSkcog8bTS1tVGlgQzeemtLRqQX/Jrkv8RkoY0/RytXDduzHnG1AIDEa3fyARmjbDU71IsoIdAEEa4ntF82NTvHLwKutMzqHQnvGwUFOqv2NrorViGZyhEBoquR+AbVGmPoUW0t9rYRtM80M1ecw+4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713531533; c=relaxed/simple;
	bh=EmQw97ZmKB7w80SRaOVJWdgNDLnX47yoYqVxPMtH0ac=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aIYO56693BXdm29POXqmBaHIFQTpAc+/7xTqNrTwXOj3OYhCqVs7b5n89AsFNqIq8RkUmx71uUpbAfP2gnotGY0kKCHHjO6bN+tPGbNEINGi98gLYH+ktrUiNZf13SuQrazbEFD1hCGt4Bsgb7rcqfMW5hCGQEBKBrL0NJJeeVY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KG6TWJYD; arc=fail smtp.client-ip=40.107.220.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PnfzJYtpNZccPOn0a5BceuO+zvcaeaaIYy+jZY58AVEmuurCZhnf8uSlVv6fPAd83yA1yS7qcMin34/Vg0Bs0iClDTZmcSL9HHgA+6qqvZXXzpEaF6VGXgKPvkfaIUlkYRtaXCbifb8OLszyf4y/njDhWVjsVeLxn0JMAb4J6YFZrCqiXAcirAT2RGzukSL5iJfeoKHNRjHr8Rek9tgutC3nQpO//fzG8cMAql7kOtrvU21q2WImvgabfDWtdqNm6gnv5DHJVHtZkyiQ9dBjHJAUW1dPJspDq3agAJVctB8V3kLJUgocMU0pFf90jU3ez349yCdnBly/k+tyGRLN7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2yxU24CPJJ09EFwR2j/K6gYXPa6xyy5vNC3SwGPiFM0=;
 b=T4nH3bk290uMkYTXeNz6d4Qt57hJ0WWZS8wjl+IqiebmMmxeLV6IFelAeqyJIx+/dKSeZqVUBRixNmMUoNoYzo1k6qE1K9luqKpey2YKL3FBTMuAOsIQi+k8jOpNUu432s9Zm3C2kSnT0vrbtGOsSrAXnVCr33hYjcplyRyJkmI69KcdHJA6C71bH3zyFjvhjbcSlq6QFn/jvwdNpzpKze13fXdl0KQnC0VknqUJiZWPXS9EWiSUyfREsN7ipHJlKR5G8T4aKm6nHvIOJO7aQowuryU8/qzjRFFpshcj4Qg3YUYGnp9rS5nNti5esgataK8f98hZJBaVhCAqzRPYnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yxU24CPJJ09EFwR2j/K6gYXPa6xyy5vNC3SwGPiFM0=;
 b=KG6TWJYDlxZEo093ZJ2R71egVtZ/rwbDIaO5XvKT31JsLqvDkNtgmK/QnhXgt7JrSzS0COyc8Dlbz6+W4ZG6NxKJR6tLMh+H1kT+t1xxPotEc7TT1hK9yJq4a7nPxH0keLhn3A9qVVjPwB5jvvh7tf0sHiVrnb/zPNWB4+7lfOU=
Received: from BYAPR01CA0021.prod.exchangelabs.com (2603:10b6:a02:80::34) by
 CY8PR12MB7265.namprd12.prod.outlook.com (2603:10b6:930:57::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.43; Fri, 19 Apr 2024 12:58:48 +0000
Received: from SN1PEPF00036F42.namprd05.prod.outlook.com
 (2603:10b6:a02:80:cafe::79) by BYAPR01CA0021.outlook.office365.com
 (2603:10b6:a02:80::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.23 via Frontend
 Transport; Fri, 19 Apr 2024 12:58:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF00036F42.mail.protection.outlook.com (10.167.248.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 12:58:46 +0000
Received: from ethanolx16dchost.amd.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 07:58:46 -0500
From: Pavan Kumar Paluri <papaluri@amd.com>
To: <kvm@vger.kernel.org>
CC: Paolo Bonzini <pbonzini@redhat.com>, Sean Christophersen
	<seanjc@google.com>, Michael Roth <michael.roth@amd.com>, Tom Lendacky
	<thomas.lendacky@amd.com>, Pavan Kumar Paluri <papaluri@amd.com>, "Kim
 Phillips" <kim.phillips@amd.com>, Vasant Karasulli <vkarasulli@suse.de>
Subject: [kvm-unit-tests RFC PATCH 03/13] x86/efi: Add support for running tests with UEFI in SEV-SNP environment
Date: Fri, 19 Apr 2024 07:57:49 -0500
Message-ID: <20240419125759.242870-4-papaluri@amd.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240419125759.242870-1-papaluri@amd.com>
References: <20240419125759.242870-1-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF00036F42:EE_|CY8PR12MB7265:EE_
X-MS-Office365-Filtering-Correlation-Id: 40e58311-33ca-43ad-34a1-08dc6070737b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?BSHu3b+7Mg4v0V/IfoVpn3BI4pfw74jSJBD9XVZl3T0x4NClEkiFhNnz2Xzi?=
 =?us-ascii?Q?pBYrNbZwlBGYHk4VBVae7BlNJw6cTWx8YECAC6q8mi+tkMe+AN/3EhUQwN5h?=
 =?us-ascii?Q?WL3kBF2n4Wr6mbZ4VX8gj9+2vgaM4d6rB9a4/U/8uNFtdzREKhWMVM8jpy2o?=
 =?us-ascii?Q?wFERC1Mlf4sNh8/QDsdFL579vqiod8fDly1c5L8IWw4mMut3olmYt7ln0nRv?=
 =?us-ascii?Q?xzCxq6fQI5e8J114emBuYb97CIZ6QONeOAlmFSkr+JvAphdv9VXvg2mK89h0?=
 =?us-ascii?Q?pWxOYfIYDv2iRiO6CePpNpmvOWjpCe8xcOp8iwMnDLGQY45RBX6A2kn4BLjX?=
 =?us-ascii?Q?A0i9rVwcXc065sjvnNWlllgoCpXH6lKSWMWp9HPls9RZqFWaIyrQAtcDRBkt?=
 =?us-ascii?Q?i3meXsHeITNrrWG1ERLeq58JPayCgkzhgEz0Do9HtzSK/NMzFffI3LTUvffJ?=
 =?us-ascii?Q?eO/GB/yZAuI6pa+WRRj5AfogPTQFah/HlTbw/U8DVHHwhafdJE19y4KghgSK?=
 =?us-ascii?Q?tyghQ1BXeuQJgqJeq19Cu2SZAEw+qeeN9eJEtFqTa6jgZdB26FYubdNUtpfs?=
 =?us-ascii?Q?0KJE9tM9UCDbF47Er6sEj0hiNVZxvbGmq/fIteWsjUyvMKkZVoW10/29WlLP?=
 =?us-ascii?Q?JxXw813WH5nOkttOkJ6pyegHy7nm0U7DYj6+7a+mza8ehX1VZysieLsl1uny?=
 =?us-ascii?Q?lreqGTlOnqjs2GaFqhHV/xLt2UWBC62HixQNVaWOvnTR+cfVAqZhnuGu6QqJ?=
 =?us-ascii?Q?Ydztk+JXCEkAfvtjLToCUgz3q2nccSaE5zuwo8AcLD+RfmhTQ44+rvUI/og4?=
 =?us-ascii?Q?qkSTxoxzmvdAhPbKBoc79n7BxkteIkaRNOjH5DPofs+GjTe5/bqPP3EE52In?=
 =?us-ascii?Q?mrWTG+8jvawu99BGfA2AmnSv2I0qw4v8Srme0fh+CMuUQI6+ztl6Z7BZ6NeP?=
 =?us-ascii?Q?wpkitvqESOu8kKrC4dHKQHCy5wqjUbKRHkAeduI/OkxrvLY5M0XEykSgsJnQ?=
 =?us-ascii?Q?Hg20NP6AAExOSzzD52x3qbZ/aAMYBZSSWkMLQt8sDpnCFP8Ob30IZEXuw++a?=
 =?us-ascii?Q?MOY7OUt3j7A8Vq8VLxUXwLWGOm0WRJ94o4BFrul9nhGzUAqcxBxIqGKxlm05?=
 =?us-ascii?Q?HlzNtceijLWrbMY7twARwNUbBoFg0CtjJyErRLl+oj/CZXwQIoVovfE4Zl+R?=
 =?us-ascii?Q?DH/XcgrDCbJG9AQ1/IcgI0q2KLA4H0717a7YUAboVruuU43u49e5ZFuPWOnG?=
 =?us-ascii?Q?iTLyLgjTAgHbON8Z14lLK7oK1fLG36IgZHZIsuDsZQP7KOiD6RREd4lQ1+WZ?=
 =?us-ascii?Q?6tzbbtmJ8C5xfntpSoiJ8oSHsNY8InM1Jhu0BKyfKJjUYWN2w5Hi17lpL0qm?=
 =?us-ascii?Q?v3L1uCwy9xtI82le0tpoZ63aoJDn?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 12:58:46.9200
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e58311-33ca-43ad-34a1-08dc6070737b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF00036F42.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7265

SEV-SNP no longer supports using pflash unit=0 for loading the OVMF bios, and
instead relies on -bios parameter. So add support for this in the runner script
(x86/efi/run).

Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
---
 x86/efi/README.md |  6 ++++++
 x86/efi/run       | 37 +++++++++++++++++++++++++++++--------
 2 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/x86/efi/README.md b/x86/efi/README.md
index af6e339c2cca..1653bf60cd13 100644
--- a/x86/efi/README.md
+++ b/x86/efi/README.md
@@ -34,6 +34,12 @@ the env variable `EFI_UEFI`:
 
     EFI_UEFI=/path/to/OVMF.fd ./x86/efi/run ./x86/msr.efi
 
+### Run test cases with UEFI in SEV-SNP environment
+
+To run a test case with UEFI and AMD SEV-SNP enabled:
+
+    EFI_SNP=y ./x86/efi/run ./x86/amd_sev.efi
+
 ## Code structure
 
 ### Code from GNU-EFI
diff --git a/x86/efi/run b/x86/efi/run
index 85aeb94fe605..2e8e29b947be 100755
--- a/x86/efi/run
+++ b/x86/efi/run
@@ -15,9 +15,11 @@ source config.mak
 
 : "${EFI_SRC:=$TEST_DIR}"
 : "${EFI_UEFI:=/usr/share/ovmf/OVMF.fd}"
+: "${EFI_VARS:=/usr/share/ovmf/OVMF_VARS.fd}"
 : "${EFI_TEST:=efi-tests}"
 : "${EFI_SMP:=1}"
 : "${EFI_CASE:=$(basename $1 .efi)}"
+: "${EFI_SNP:=n}"
 
 if [ ! -f "$EFI_UEFI" ]; then
 	echo "UEFI firmware not found: $EFI_UEFI"
@@ -43,6 +45,24 @@ fi
 mkdir -p "$EFI_CASE_DIR"
 cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 
+# SEV-SNP no longer supports using pflash unit=0 for loading the bios,
+# and instead relies on -bios parameter. pflash unit=0 will instead only
+# be used for OVMF_VARS image, if present.
+if [ "$EFI_SNP" == "y" ]; then
+	"$TEST_DIR/run" \
+	-bios "${EFI_UEFI}" \
+	-drive file="$EFI_VARS",format=raw,if=pflash,unit=0 \
+	-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+	-net none \
+	-nographic \
+	-m 512M \
+	-object memory-backend-memfd,id=ram1,size=512M,share=true,prealloc=false \
+	-machine q35,confidential-guest-support=sev0,memory-backend=ram1 \
+	-object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1 \
+	-cpu EPYC-v4
+
+	exit $?
+else
 # Run test case with 256MiB QEMU memory. QEMU default memory size is 128MiB.
 # After UEFI boot up and we call `LibMemoryMap()`, the largest consecutive
 # memory region is ~42MiB. Although this is sufficient for many test cases to
@@ -54,11 +74,12 @@ cp "$EFI_SRC/$EFI_CASE.efi" "$EFI_CASE_BINARY"
 # to x86/run. This `smp` flag overrides any previous `smp` flags (e.g.,
 # `-smp 4`). This is necessary because KVM-Unit-Tests do not currently support
 # SMP under UEFI. This last flag should be removed when this issue is resolved.
-"$TEST_DIR/run" \
-	-drive file="$EFI_UEFI",format=raw,if=pflash,readonly=on \
-	-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
-	-net none \
-	-nographic \
-	-m 256 \
-	"$@" \
-	-smp "$EFI_SMP"
+	"$TEST_DIR/run" \
+		-drive file="$EFI_UEFI",format=raw,if=pflash,readonly=on \
+		-drive file.dir="$EFI_TEST/$EFI_CASE/",file.driver=vvfat,file.rw=on,format=raw,if=virtio \
+		-net none \
+		-nographic \
+		-m 256 \
+		"$@" \
+		-smp "$EFI_SMP"
+fi
-- 
2.34.1


