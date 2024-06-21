Return-Path: <kvm+bounces-20277-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 843F79126E3
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 15:44:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F2DD1C25F02
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 13:43:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F48C12E5E;
	Fri, 21 Jun 2024 13:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="gSVlDcNm"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2059.outbound.protection.outlook.com [40.107.100.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48A35F4FA;
	Fri, 21 Jun 2024 13:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718977425; cv=fail; b=jErigkq9oLG5i4XQJuIZBgQUxNbxA8NutrztdNMQURfyCD4TRBAj8UrbcRmJH9yNYF7aMu9UEX5luiy23Ky/5vy+ofIxpoMhuqe9Ds8nB2lWQAeWBAlatAsYNzn+F8geDswoM/hhuR0Fk4LLjin3AtAp+3vL1DiL2OhmsGlHItk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718977425; c=relaxed/simple;
	bh=AxfkWUYvI5xDIiaDF5elIGu7skY5tSJVTeX/k8fWAqs=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bmDBxcWvS+OgeWJ+Alv6ysNe7i2rr5fBhex29pJdZ74MjWsuhvWcbLx1BS1MsiARCOKd9ip1rH94YqmK8A4Pucei9zMQy+QxgH0EYkzg1+g3NlpdBTI52xsH2Oeoduv4ILPYA/RZn/rvKn77ITAHzOe3rWfVLM0YjasErGm7dIQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=gSVlDcNm; arc=fail smtp.client-ip=40.107.100.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Me0uZiz9K43zoapuQUM3NQf6Jde57VxXdlhx5sS9isB0MJ7glS/gy8pNG/OZjMBCkJZUHxPVdzBrYIMxqOlTieuxw+XWOZrwi0Lq4IlgUw/w8B9OPQCDTqoWgzF+ygKMRc0Vuq/SMlmlq5NzEZOcEHl+eugRVte6/Qz8QIDE7pQCngo95zgNtOFOoR79c9SQECSNsDg2FjhkXZogt4OvZ/E04YvN5nv9NH8LVwhh+I9TyJQqaas0DCOGeNqWXPvVN7Yof4YqxOk6BQL24dXSroU1UGks0rthkWQ0QUEMBinIyXflSN/mN5FPZmnHCnZMz11VicLrhmXftgSfABryhg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xc7VXlFnatYet2hudzlkQDXFCQ2zpSBx6jVi2yZlx4U=;
 b=LlNDCHp21OFG9H6ZDGNK7yhnsBBHLuPbCBeCr2f+DRHwZT0q3ivIzfUy0FQqg8dkrPJ1fEhRt3wzPW4wXr3ZNhBhlP9wKwcOoJVblBfBO29MqNhXf+njW1FoEE+VW3oHIUfd46RQHq7mVYmi3KNSjvEK5rMJiwFeZQlzXip97wKzO2Dc76NLeAit/dWWqOQUOXPlVYinPYld0uymhbTO3Zdy9y9/ArR8fBToF+EEJwP6qwKcfjYtqPafLLtNEHJHygfgxZPovBFzcmt2fZLKtM3C3kR4DsALHCw9e+TkbPbupFXalfK257NQlN+vFTcTIhRNieAvr3/XY1ggxWWq3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xc7VXlFnatYet2hudzlkQDXFCQ2zpSBx6jVi2yZlx4U=;
 b=gSVlDcNmtRk9jOz0Xd3obvycGDAThfYUFh5D/uQtAAkF/rl/D16C8u2UrtuwOOzCsgEMy6kiP2eQbIgSaK+tBnSB7Lp/rK1MtDmG2VMGty0EAbppqgHg4YFSkkMrJHIZkySj9bNw5UwjOGR1b302RfNxXXD5CR1uNZkGfFSzDaw=
Received: from CY5PR16CA0014.namprd16.prod.outlook.com (2603:10b6:930:10::30)
 by CY5PR12MB6383.namprd12.prod.outlook.com (2603:10b6:930:3d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 13:43:37 +0000
Received: from CY4PEPF0000EE3E.namprd03.prod.outlook.com
 (2603:10b6:930:10:cafe::78) by CY5PR16CA0014.outlook.office365.com
 (2603:10b6:930:10::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7677.36 via Frontend
 Transport; Fri, 21 Jun 2024 13:43:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3E.mail.protection.outlook.com (10.167.242.16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 13:43:37 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 08:43:34 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: [PATCH v1 0/5] SEV-SNP: Add KVM support for attestation and KVM_EXIT_COCO
Date: Fri, 21 Jun 2024 08:40:36 -0500
Message-ID: <20240621134041.3170480-1-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
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
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3E:EE_|CY5PR12MB6383:EE_
X-MS-Office365-Filtering-Correlation-Id: 53c393eb-3cbd-41e0-159a-08dc91f82755
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|82310400023|36860700010|7416011|376011;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?LHT1zuWw3zEENH1GyeQH6kurBqpLPQUZc/FvaR0S/D26/iwrJJR660SAF+q2?=
 =?us-ascii?Q?JnpeWXA5ejbNxaL+e0E5ObADz0rmcbrgmAjWLH1SXTzRzItuFdA3XN/mInzF?=
 =?us-ascii?Q?Ed4kMKI9PWniNy4gy01G9iRbW4R05BZVGEXffOFAPNuty6gDQ9DjedqCBfqj?=
 =?us-ascii?Q?YfsqnpF0namxKwldBau9DTv3ft5qn1PmBzDXEJ8H3AEat7Pv0/J73/xFwUOZ?=
 =?us-ascii?Q?qAZpxN9u5AT59E1Y36ZapbPfEsn2nLaO3eU4fcEiy6oey0/v9FrUHYl00UrN?=
 =?us-ascii?Q?svybQM2yFAH1cPAWyxYW9aEnWu5DERXVz62Wr+9+QzFLAF3IKPsvBM4Dsjc/?=
 =?us-ascii?Q?Sskb2TSZaj0acF8hzp2vx0LoAkWPDh/Kb0Rio7dpQra6EQ0qC+gu+rFkyvK2?=
 =?us-ascii?Q?WuXk8xjus0qBa2+nTTkKfr5clEvUIPEeYvn5VLAteXyayjfZPu2bERmlL8Cs?=
 =?us-ascii?Q?s2DuFvNDBI6Dl4iY1ggwgeAO22nt6p7yXE/arlc156WWmb9xRaam80aQGswC?=
 =?us-ascii?Q?hxpmsglGwnmK59x1BlkgI6gaWXWBAcVQhWNlhCUUKHIJu9K8NINRyDQV/nZ4?=
 =?us-ascii?Q?+Xhielg4cVoSGeFv2i/HUxDwUoMr62x9II10fcCkUL/5DY5rqhnUeUABhGXa?=
 =?us-ascii?Q?92ih1dyyQVjsYkFkhubx5VNpdEfbUlkC4OGfqh7OnXZJ2n5PIaCIblRT8SvL?=
 =?us-ascii?Q?XO1ianBQJGumIi3/K7cei38dMPhIXi2hb261kJgeYBA+dskzdiH8Ey5R1r+Q?=
 =?us-ascii?Q?WTSq9iCDAlz9nAVKpjewgYNv7oecz15xuDxhApH5qNCKRl/s6siEJv/+uou+?=
 =?us-ascii?Q?JfNxT7KtyicQhp7PqhjtR5qOaiePu6pyYAw7xa2BqZ6UXe/KLCaUfEK/CQ1+?=
 =?us-ascii?Q?Fz+8DoAEQ6PLcVbEKrfAcALE9ft/u6GVIPFaBt5pwrFVetskezB/Wd7Kwa0S?=
 =?us-ascii?Q?GAQYTqNfvMPKCYtzgm+pkbAjDTZlcZXIAyppdIxYjpfXJuQEFDa0IH01kJAu?=
 =?us-ascii?Q?k7a3qakELbJ7WBm42d0vND/8ls0PifhZXayVseDLyqlXJ3khT25ksIBXGooE?=
 =?us-ascii?Q?RRuBBx3S8lit2YnOfvCN2p7nr+oLutjUNq6kzXk7GndQSkHB4/WhMLYEQU0R?=
 =?us-ascii?Q?EOc39sYDWD1jyUq1LZTWlAfDBVcQkKJkj/G97CVQ7AySLT0OzK/qvonq7py8?=
 =?us-ascii?Q?AXJLLPc0n07p+x1jzOf04G6euoNUBkhhEuotMdeYpUA3z1GDq6L4wFUA0owv?=
 =?us-ascii?Q?5fuFjknKJ/cJX5JlYlG75l4qlL/KVSjCazMSZG2W1GFwUCi5+sSTduO170UH?=
 =?us-ascii?Q?w8xd8INPn82cJ7SYuaCDlarJkfpQgx8Z0JbXsljvc7xiDlBRzMlTjeeANU56?=
 =?us-ascii?Q?4crS2E8=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(1800799021)(82310400023)(36860700010)(7416011)(376011);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 13:43:37.6322
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c393eb-3cbd-41e0-159a-08dc91f82755
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3E.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6383

This patchset is also available at:

  https://github.com/amdese/linux/commits/snp-guest-req-v1

and is based on top of kvm-coco-queue (ace0c64d8975):

  https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue

As discussed on the PUCK call a few weeks back, I'm re-submitting as a
separate patchset the SNP guest request support that was originally part of
the SNP KVM base support patchset that's now in kvm/next and will be in
kernel 6.11. This support is needed to ensure fully compliance with GHCB
2.0 specification and to support attestation in general, so I'm hoping it
can also make it into 6.11.

I've tried to organize things so the first 3 patches can be applied without
too much controversy and decoupled from any discussion regarding the
KVM_EXIT_COCO/KVM_EXIT_COCO_REQ_CERTS APIs, since the APIs are only needed
specifically to add optional support for userspace-provided certificate
data. That said, I have based those APIs around what was discussed during
the above-mentioned PUCK call, so I'm hoping the API bits aren't too far
off from whatever the consensus ends up being.


Overview
--------

The GHCB 2.0 specification defines 2 GHCB request types to allow SNP guests
to send encrypted messages/requests to firmware: SNP Guest Requests and SNP
Extended Guest Requests. These encrypted messages are used for things like
servicing attestation requests issued by the guest. Implementing support for
these is required to be fully GHCB-compliant.

For the most part, KVM only needs to handle forwarding these requests to
firmware (to be issued via the SNP_GUEST_REQUEST firmware command defined
in the SEV-SNP Firmware ABI), and then forwarding the encrypted response to
the guest.

However, in the case of SNP Extended Guest Requests, the host is also
able to provide the certificate data corresponding to the endorsement key
used by firmware to sign attestation report requests. This certificate data
is provided by userspace because:

  1) It allows for different keys/key types to be used for each particular
     guest with requiring any sort of KVM API to configure the certificate
     table in advance on a per-guest basis.

  2) It provides additional flexibility with how attestation requests might
     be handled during live migration where the certificate data for
     source/dest might be different.

  3) It allows all synchronization between certificates and firmware/signing
     key updates to be handled purely by userspace rather than requiring
     some in-kernel mechanism to facilitate it. [1]

To support fetching certificate data from userspace, a new KVM exit type is
used to fetch the data similarly to KVM_EXIT_MMIO/etc. Since there is
potential for more CoCo-related exits, this series implements this as a more
general KVM_EXIT_COCO exit type, where individual sub-types can be enabled
similarly to how KVM_EXIT_HYPERCALL/KVM_CAP_EXIT_HYPERCALL are handling, and
then introduces the KVM_EXIT_COCO_REQ_CERTS sub-type to implement certficate
handling.

[1] https://lore.kernel.org/kvm/ZS614OSoritrE1d2@google.com/


Patch Layout
------------

1-3: These patches provide a base implementation of SNP_GUEST_REQUEST and
     SNP_EXTENDED_GUEST_REQUEST that satisfies the requirements of the GHCB
     2.0 specification, but does not implement optional support for providing
     a certificate table for SNP_EXTENDED_GUEST_REQUEST messages
     corresponding to attestation requests.

  4: This patch introduces/documents the KVM API for KVM_EXIT_COCO along with
     it's first sub-type, KVM_EXIT_COCO_REQ_CERTS, which will be used to
     fetch certificate table data from userspace.

  5: This patch makes use of the KVM_EXIT_COCO_REQ_CERTS event to allow
     certificate table data to be fetched from userspace and provided to the
     guest when attestation requests are issued via
     SNP_EXTENDED_GUEST_REQUEST messages.


Testing
-------

For testing this via QEMU, use the following tree:

  https://github.com/amdese/qemu/commits/snp-guest-req-v1-wip1

A basic command-line invocation for SNP would be:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=
  -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd

With certificate data supplied:

 qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
  -machine q35,confidential-guest-support=sev0,memory-backend=ram1
  -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
  -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,certs-path=/home/mroth/cert.blob
  -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd

The format of the certificate blob is defined in the GHCB 2.0 specification,
but if it's not being parsed on the guest-side then random data will suffice
for testing the KVM bits.


Any feedback/review is appreciated.

Thanks!

-Mike


Changes since splitting this off from v15 SNP KVM patchset:

 * Address clang-reported warnings regarding uninitialized variables 
 * Address a memory leak of the request/response buffer pages, and refactor
   the code based on Sean's suggestions:
   https://lore.kernel.org/kvm/ZktbBRLXeOp9X6aH@google.com/
 * Fix SNP Extended Guest Request handling to only attempt to fetch
   certificates if handling MSG_REQ_REPORT (attestation) message types
 * Drop KVM_EXIT_VMGEXIT and introduce KVM_EXIT_COCO events instead
 * Refactor patch layout for easier handling/review

----------------------------------------------------------------
Brijesh Singh (1):
      KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event

Michael Roth (4):
      x86/sev: Move sev_guest.h into common SEV header
      KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
      KVM: Introduce KVM_EXIT_COCO exit type
      KVM: SEV: Add certificate support for SNP_EXTENDED_GUEST_REQUEST events

 Documentation/virt/kvm/api.rst          | 109 ++++++++++++++++++++++
 arch/x86/include/asm/kvm_host.h         |   1 +
 arch/x86/include/asm/sev.h              |  48 ++++++++++
 arch/x86/kvm/svm/sev.c                  | 158 ++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                      |  13 +++
 drivers/virt/coco/sev-guest/sev-guest.c |   2 -
 drivers/virt/coco/sev-guest/sev-guest.h |  63 -------------
 include/uapi/linux/kvm.h                |  20 ++++
 include/uapi/linux/sev-guest.h          |   9 ++
 9 files changed, 358 insertions(+), 65 deletions(-)
 delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h



