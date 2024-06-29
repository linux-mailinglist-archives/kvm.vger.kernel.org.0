Return-Path: <kvm+bounces-20717-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 891A591C9D1
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 02:48:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A206A1C20C04
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 00:48:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 009D21878;
	Sat, 29 Jun 2024 00:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bkYVe1gD"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DAAC365;
	Sat, 29 Jun 2024 00:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.59
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719622109; cv=fail; b=TkaKFn7jgl8fUIk25oQt89Jhwo7mhu6pfkJic5+n7v89E3qpRpqMWBeS90n47DXi7Hj4XbEjUvOPIZ2W9qFgP4Oel95pqWA7l2xBvC8Y9mjHshFfK5OQvPSnQcGDPTjz58sF8PNLSgxtGu85XJVJhB1fI5O5DxyLdpSUfr7OUvc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719622109; c=relaxed/simple;
	bh=5PmO1/69AN7eZyV0Nvy+dlaA89rD5vfFTeGiE4ZStOA=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YDh6qs+qeK82N9Yr2Db1i6pBlsJ5blIm1ffo2p59IZkQhzp0F20JHKuJUx5hQT3Zr8rsHi/15PTA17XaGyDoghRMXnZFNKRi87Qy42JL1ACOMuI/L6uUviuCgcMMKFEURd1qPJJ+oC0vuZZ+71aMJw9PCFF/bIpy4jjpNIvnB2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bkYVe1gD; arc=fail smtp.client-ip=40.107.220.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rpz9NaMGx95OS6yOTgY6eDNo7JfVw6QOM9TL8q9aD2ao69F1YOl2QRMbMWLpQkJ+/sbeRhCWwPdUWtDx+1Y+kODLpA9210GO6lAgMW134wxH3qA3GHOk4n17khVbbvck3YEkJTAzw08YdqbIUU4twO7DVeZYUEsNnOmWpb0wIFLeKAHMHEN+sXCLwXvnoL+Ywl2rydEJoHI9g5juoLuINdiEMgyV8EVxkCsPIBY+Svex38OC1E4uszoSrHiLTuhDCUxftsDpO8Yaey1asxbjrV5xoRYsOxBw08oHI3J7g4jYbxceoeKENiXEWymC2R3ucsVSn7PFAlfIetYmQ6UMPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DpkruMhWKVJgMc/0X04R+Lb0pxku5+QPINF8YYgiAHo=;
 b=NvIwjIc4Jr9LnKmccgullz8H+8uAhp+gGgNggWeSmhpIOB0a4BfFKlzwOfVSrCmJc+ss/uZe6nVeYUSi3EWc1OCsaeB9XbySswDzuQWIXIeHjExM6nEpLdYOdqXkyWsB4XkA8UkhlxdSma/9K4i+8kejUFUhK8YDNw7a+uG2vZdLSnHvmtPh30OgAb2w04+lTc0nwxC36iMqkI7ZchAza6L8n4QBvP5FWi6ZVx5C4K3NHCcJdKv9ZsIKlC7T2i3Da34x0lpdJKswMNQHab/WLCqs+Ck1jTAnFmS2WsMP9F22x8Vi32xqfcG3V7UNkOb4uGMQVuP552pJlfLfc1IKsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DpkruMhWKVJgMc/0X04R+Lb0pxku5+QPINF8YYgiAHo=;
 b=bkYVe1gDMJSxuQf+S9IXbVqsGEdtGg9kueHnXP8hqc6X16+yt0y6u5CL11bWkK5GNzdzZC+ESkt6Rcu3hFbi69PlyGlc0Fh1cXp6kHxNQU8w+D8wa0RuyLQ4eQ2yh8o9kQxZRP1iZflNDC8Mha/JA+hkW1iI12MfvQwlOOtTZeA=
Received: from PH8PR05CA0017.namprd05.prod.outlook.com (2603:10b6:510:2cc::29)
 by SJ0PR12MB6853.namprd12.prod.outlook.com (2603:10b6:a03:47b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.32; Sat, 29 Jun
 2024 00:48:22 +0000
Received: from SN1PEPF000252A0.namprd05.prod.outlook.com
 (2603:10b6:510:2cc:cafe::89) by PH8PR05CA0017.outlook.office365.com
 (2603:10b6:510:2cc::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7741.16 via Frontend
 Transport; Sat, 29 Jun 2024 00:48:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SN1PEPF000252A0.mail.protection.outlook.com (10.167.242.7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Sat, 29 Jun 2024 00:48:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 28 Jun
 2024 19:48:21 -0500
Date: Fri, 28 Jun 2024 19:48:03 -0500
From: Michael Roth <michael.roth@amd.com>
To: <kvm@vger.kernel.org>
CC: <linux-coco@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<x86@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <pgonda@google.com>,
	<ashish.kalra@amd.com>, <bp@alien8.de>, <pankaj.gupta@amd.com>,
	<liam.merwick@oracle.com>
Subject: Re: [PATCH v2 0/3] SEV-SNP: Add KVM support for attestation
Message-ID: <3wiz2i6rc5t2slrgvppquxe35wrirvh44jlm6qdgz3a6nj342u@il7ylsyfzq6r>
References: <20240628185244.3615928-1-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240628185244.3615928-1-michael.roth@amd.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN1PEPF000252A0:EE_|SJ0PR12MB6853:EE_
X-MS-Office365-Filtering-Correlation-Id: 66370eab-4a89-4406-219c-08dc97d52d14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|7416014|376014|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?5Cti4DRI6fbtt39dYHGcySw+s0pjIWMqqFJmw/ywuMzLKgmf/fCfuaPTLH0P?=
 =?us-ascii?Q?9jrCNKMOz7F2PceUTVG2LPyRTZ2NSjWtE9stRq9XZUmksiUya9cj6ZCdmver?=
 =?us-ascii?Q?ZdgRBwPElMq0wHDE5VAcMmxG8ztYcT4VaznLGPk0OqL1Cm8+A8SK7LmDXmWA?=
 =?us-ascii?Q?yFGIwBfBiZlg83YRvXP7/RePtDKZ0bvab4onJhTGt0A2TESjyFq9rk6VZv2M?=
 =?us-ascii?Q?b40+kSjQalKtC7hJ2zvk1ec/ZZy1HwOQTo/OZKIoLj2j9ix0Qiw/0wB6tslg?=
 =?us-ascii?Q?KNJ9vDwfQkA80JeEf0wldkF5+QFtImQ8Qemomw/ISjPVjWl8A64MLXgT6rFI?=
 =?us-ascii?Q?DVvcnX2txu++2v6BBK9RHWg+QAHpn/MlccSgO6hxw5aLY9g9UGHieJd8rJ3k?=
 =?us-ascii?Q?HW2nUkgiFhV34sxZtjyR4VEbKRB3AU75Ysehm/EDUL+x48okC8TC5RFCv3ED?=
 =?us-ascii?Q?Gq15VSrJekfaid9zrkNVWrXnD505fMtePEn2iZDbmbVIyqCebSqaxEY+fIbs?=
 =?us-ascii?Q?kSLHN/5ZTxIH7bnH0aRB95gEZxuVDAwQzirDbmHL6RI59ymklp9ignNA0OCq?=
 =?us-ascii?Q?uQdeJTW6/8y26+8UilauhfD2YpjosdDilUwcl9gCGogEB2QE7skXjNunVjxH?=
 =?us-ascii?Q?xiyHaZ1tHc832H2ixe1zYDT/onYjVODCG/yBQ+wsF616bMVSgc/sJWdJVgl4?=
 =?us-ascii?Q?iK6yVo1iZFgj6WkOx1Hkgi6jGUFymbGvru8Je1SoSTIC5kADs0FA2bjX03sH?=
 =?us-ascii?Q?f5HL7nDOlHhO1Rcex/Zga3mH2zsfEbb/n2DAsHQZ64Gk0jhr5SbJZGlGDoss?=
 =?us-ascii?Q?/OWzhZCTZ361YVA9ov61oQQcL9Ud+IwQDdY9smwNDN6hjLaVs4mLCIG3eX13?=
 =?us-ascii?Q?x07tsy4zcEER+iDlR8+tKyiSWv7YOabBqsHrC3ZDJ2rpu3pxyBSzlv3/zOCj?=
 =?us-ascii?Q?6KGe7QpVvB7aLNZKeRWVhTLjzbC52OPXka2AXYmWXDfbFUHva41Ukhs4PSiz?=
 =?us-ascii?Q?WuwGl/qSGi+Yceduyb+t2UpdPQL/3/ebbZXff7idBwTJJlTmQA8fsEjXqTjQ?=
 =?us-ascii?Q?73RI+RQ1zwVD37XzEOuinmJDKkNJk3LqtsY0mVgpTMBnnvpMe5guZDgtMoUY?=
 =?us-ascii?Q?Lu0pYCYLy9RnB6hvnJsXr8ooZMaIlv/5cjKqHKME9UXP1az6w78sXY0+Oz7Y?=
 =?us-ascii?Q?/YWfAvi03KNGhOXim+Ym0pxd9if4bmviupX7Mc1wx6QV3jYFssQInLV1hGjn?=
 =?us-ascii?Q?4+OzvYy+NbtGvEK3gWDNILB2eaEwGu8h20d1c+JvTJKMoVHdQE8N87GVYELC?=
 =?us-ascii?Q?Myl3VWHkdWTWkbKd6n7JJ6tYC0k44U4u9IiA7yjuFfkxjN9nKyfEmdyehPwk?=
 =?us-ascii?Q?jXHeBTBms217WbiV75/iaC1Yq7By9nsk3aRkHtNNt2Lpt4z3JQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(7416014)(376014)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2024 00:48:21.9109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66370eab-4a89-4406-219c-08dc97d52d14
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SN1PEPF000252A0.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB6853

On Fri, Jun 28, 2024 at 01:52:41PM -0500, Michael Roth wrote:
> Changes since v1:
> 
>  * Fix cleanup path when handling firmware error (Liam, Sean)
>  * Use bounce-pages for interacting with firmware rather than passing in the
>    guest-provided pages directly. (Sean)
>  * Drop SNP_GUEST_VMM_ERR_GENERIC and rely solely on firmware-provided error
>    code to report any firmware error to the guest. (Sean)
>  * Use kvm_clear_guest() to handle writing empty certificate table instead 
>    of kvm_write_guest() (Sean)
>  * Add additional comments in commit messages and throughout code to better
>    explain the interactions with firmware/guest. (Sean)
>  * Drop 4K-alignment restrictions on the guest-provided req/resp buffers,
>    since the GHCB-spec only specifically requires they fit within 4K,

It turns out my eyeballs were not functional when I reached that
conclusion and it's clearly documented that the pages needed to be
4K-aligned in the GHCB spec.

With the current implementation, KVM can actually handle unaligned
req/resp GPAs thanks to the bounce buffers, but it should still be
enforced. So I will resend a v3 with this change, but leave a bit more
time in case there are other review comments for v2.

Thanks,

Mike

>    not necessarily that they be 4K-aligned. Additionally, the bounce
>    pages passed to firmware will be 4K-aligned regardless.
> 
> Changes since splitting this off from v15 SNP KVM patchset:
> 
>  * Address clang-reported warnings regarding uninitialized variables 
>  * Address a memory leak of the request/response buffer pages, and refactor
>    the code based on Sean's suggestions:
>    https://lore.kernel.org/kvm/ZktbBRLXeOp9X6aH@google.com/
>  * Fix SNP Extended Guest Request handling to only attempt to fetch
>    certificates if handling MSG_REQ_REPORT (attestation) message types
>  * Drop KVM_EXIT_VMGEXIT and introduce KVM_EXIT_COCO events instead
>  * Refactor patch layout for easier handling/review
> 
> ----------------------------------------------------------------
> Brijesh Singh (1):
>       KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
> 
> Michael Roth (2):
>       x86/sev: Move sev_guest.h into common SEV header
>       KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
> 
>  arch/x86/include/asm/sev.h              |  48 ++++++++
>  arch/x86/kvm/svm/sev.c                  | 187 ++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h                  |   3 +
>  drivers/virt/coco/sev-guest/sev-guest.c |   2 -
>  drivers/virt/coco/sev-guest/sev-guest.h |  63 -----------
>  include/uapi/linux/sev-guest.h          |   3 +
>  6 files changed, 241 insertions(+), 65 deletions(-)
>  delete mode 100644 drivers/virt/coco/sev-guest/sev-guest.h
> 
> 

