Return-Path: <kvm+bounces-71839-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kM1AKpcMn2neYgQAu9opvQ
	(envelope-from <kvm+bounces-71839-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 15:52:07 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 63F4619900A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 15:52:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0255F306B3AA
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 14:51:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9F63D3D03;
	Wed, 25 Feb 2026 14:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="YZdC8Gnt"
X-Original-To: kvm@vger.kernel.org
Received: from PH0PR06CU001.outbound.protection.outlook.com (mail-westus3azon11011067.outbound.protection.outlook.com [40.107.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1A927FB2A;
	Wed, 25 Feb 2026 14:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.208.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772031072; cv=fail; b=bUyZ9vRW5UxDTObyEi5STJaASDHS9vMCr/oogCsgnpBCwk6Eb7cEZLAB+r+CDzEegPzuF+5PT2I0HKk1EbQBsGz1hce7X8jTimmqh0GZz0eiLYiwr3fkYff4zfT+jSj0uMZ3ltBsEsxQRObHOSNblwYO1UUbWxe/Xxagpqjdt5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772031072; c=relaxed/simple;
	bh=5VPr/Fnudir1++IWZFuFg/O4sePiAiYt52KuqTk1jvg=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=PUDNmmmtC4EyHRDOlOKphyF4QTppQwT7HklwxuylOPjErthId9GaJy2BT+gYMWHzdxubVy1Ubfe1ccM0Y4zn8gu/wcEEzbNZA4zgiLIMuuR01pW4WSWLc0uvUMePFaY0o8mv/0j51fInVyixwNq2iz2xpeEY2Nc+upAA7NQyFiE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=YZdC8Gnt; arc=fail smtp.client-ip=40.107.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JKUIa8GWG1p6ZtrAHbcI1MOcljngaLtWTF63gRSyyiPxSRkUVi0HYUuK2CjG8GANcj0vCDR0EUR+IQwtXkh87SaqBrMdBtLzCx0qDkg9IYdv5J0hE9d1aKMzvIXZWFLSLrnTLA1u/RGq/L7HuaBldEBCjkiTI7MZEHREpQ2TvqDTIWF0lYe2a/xAg64iT9NVnu2bXAqaxRQfbVGmZsEdV31qB0a+CxqwPquop4lNFV79aVRvsGySt5LyHB7M+OKRxcX2OLYPJX3HdXokCdLrmwCkBSOWnXKy8eR3Li+zGBx+yweiBUdG9s9aPXj1ZTlMSkzrP1Fp9chxV1NWbS/6MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9siqH7zFg3zFavhiSVgKlVHnyGYGKu3gNA9Uw35aD48=;
 b=xiSivMH7rhHbrPab0ZJp7MyELNjv7LGk4Z9egMzLMjH85eshQxEoPfOpQHweNQxee1FJ0qAOg6wSUkDl6uvFZPm2da1zPWMRr7YzvoO1Z9/VkUCh3Geppf+lIZ/ofbMmyqob67BePVAsB7bZ6RMrxZSqX/BcaZtJwRcSmSzEgbDMnMEd4se45L8oJjGxjP+V6SdOpC2d69CxVPZ4h31zC9AWp8ZQm5dQYhRuTNTZROxkqurwMJ6hnSyiDq/NKc1xsI5y214AFcfDwwA/0BU062U+waTHl8Vv3dHoRd2GXSlsEaSAdcP9b2MgXMN6hS38uhme7RRikznMS/qn+m6cAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=google.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9siqH7zFg3zFavhiSVgKlVHnyGYGKu3gNA9Uw35aD48=;
 b=YZdC8Gnt8LX/D6FXjW7q4wXP806WGPjsoQ/qlaY0BxM42jTm7bKsIAKRWQe2minFDSaSA+ygTSJKfdLEXeq/LbsBeAm1NFLJ0agSzI9SP+AdTgQxoYl8NIvaSAObLRvxHp19fC4GfI4qJnj4KS1CoqwgpK+X8EOyJXqiy6VD/VxVK2uw6jZpOz3zNSzRrER0tvA8ReiYSXH1KbYM8J5I9KzmqhlbNhpZ5GPTWb+bguxsAsdTEiTN7bvbUgVMtiSDiHf5wlroUn+8U80zwyDxg11Qe3OCpcLCCarEtEWxOaQ5HhSd4qAY+gwKrXtfQ3ADpVFpF4qi0zRSIwx6SYy4xw==
Received: from BY5PR17CA0034.namprd17.prod.outlook.com (2603:10b6:a03:1b8::47)
 by BY5PR12MB4035.namprd12.prod.outlook.com (2603:10b6:a03:206::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.20; Wed, 25 Feb
 2026 14:51:03 +0000
Received: from SJ5PEPF00000203.namprd05.prod.outlook.com
 (2603:10b6:a03:1b8:cafe::ac) by BY5PR17CA0034.outlook.office365.com
 (2603:10b6:a03:1b8::47) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.9632.22 via Frontend Transport; Wed,
 25 Feb 2026 14:51:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 SJ5PEPF00000203.mail.protection.outlook.com (10.167.244.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9632.12 via Frontend Transport; Wed, 25 Feb 2026 14:51:03 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 06:50:44 -0800
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.20; Wed, 25 Feb
 2026 06:50:43 -0800
Received: from vdi.nvidia.com (10.127.8.12) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.2562.20 via Frontend Transport; Wed, 25
 Feb 2026 06:50:40 -0800
From: Gal Pressman <gal@nvidia.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
	<mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
	<dave.hansen@linux.intel.com>, <x86@kernel.org>, "H. Peter Anvin"
	<hpa@zytor.com>, Naveen N Rao <naveen@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
CC: Gal Pressman <gal@nvidia.com>
Subject: [PATCH v2 0/2] KVM: x86: Fix UBSAN bool warnings in module parameters
Date: Wed, 25 Feb 2026 16:50:48 +0200
Message-ID: <20260225145050.2350278-1-gal@nvidia.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-NV-OnPremToCloud: ExternallySecured
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF00000203:EE_|BY5PR12MB4035:EE_
X-MS-Office365-Filtering-Correlation-Id: f4ed6c69-a9f3-4ecc-ea98-08de747d4cae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|376014|82310400026|7416014|1800799024|13003099007|921020;
X-Microsoft-Antispam-Message-Info:
	VndWif2XNz/RMPMD1SB07FnpEzYC1lcClfdikZDEpImmB+hvGCz8YFzmncjsfQPRLSgcRaGOzkIOCPwGCyMD7Xq9T6vmm262b5iYNzYS0GFwWpIS+8Nbb1zLamoT1fI5Aa1s0xu+bsK5NT267Bbijs4mZ/w0ojNhKT8J/UK70Atp7sGQlmTibS9fkJjqBXQGj4/O2WTB13vmw5Q82aI6eGzBPS1znU18by6Id3fmuSv0NUqVuEuCxRnfAoR6XB2dSn05giv2+sxJWTrBkGpEwspRNOMcCMOC8+k3z27igxCCZdIYkI1jO72En3Zi9bcsApzVUqzvyfSlEq+UTMRp0NI1zMAcP2prurLhCIGURgvSW4QnTq6BGILR19iBz+cjP3kGccaJCoStjtIJjoFxfN9L9gHuZcODAz5J6DtRdAQzXtH14+uPbWZTi6Ss3a1Wpgw+ICS9/3PIhglYLfm1VSK7nga5RRzaqW7YSzJ0Q5TTlUaJB+2wW6kOykeUplJ+jxbQ1+LMAkiLW/VTT5lebYK5k8dUIsPeBLUDbQgtEFZ3IzdifnV33d2Rzb02AlB2vRdfAu37DQ9/SFzmKusMzzl+68eX7eMxwM4Q9OxRicHC080Z0rj7pvFXC4PTodqm5sY7hW7to7ncm7xSMTyOJf75oBauJN/ygbHdNGfFgLoV3J9GNQuVy/VkHkPLrxFZa9wNSmD+XatazroZZ+O9EsvJVtfW3TIYm1vmXJ50f8O0fyZg6Fm4Leo51iWSKLkTawBWe6EA1guBVVm1KrJZEmdmSPq7iS4GOsEZ3x+HHYrK5KIpUNwU4tYycukUcoN6F42bCE2U3f8uzvdKiu+I5Zw2uK+K07PFn+kdsypnCgs=
X-Forefront-Antispam-Report:
	CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230040)(36860700013)(376014)(82310400026)(7416014)(1800799024)(13003099007)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	3PTKPKOL1aiH/ODUEq6lK0NGXHOrMCkQf3ec38W2LUeJKBZtIpisDnq8GnZ7Kd/+JuUb72lq6/5cGMAy67+CmPQMESXh3LZ6IJppwK0obOu/5pFGCu8tDmbw9VSAaJWMOmqLUTsD1y5QmON0Msqkz5atUqLCXL4YjDnuP4qkKPHPUwZOSxAeorevxFAGDkR6W0qYh7BNpZ08bYM8xxgZOnVf8P7cPx3VlCpCRYpSs9gGGYEeldLIqQK/0J/shN2H/jU7zi3EDCWbTVQCu3RhsP4g8usipPxTZXZ+o4OayUaUs5qDwxZDmlmzoazr3MEuHnyKUx+L08U8lrzh56tHkRMwy474GhXn/JCUEg4+m61v3P1DsruD0aaa/1+PRGomLo5hOsp5Pnj9oBKC1IebroMroJEnCn1aBF9PWsy5LpVh6YfVe6tE64nG3q9Q7Pet
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2026 14:51:03.8112
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f4ed6c69-a9f3-4ecc-ea98-08de747d4cae
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF00000203.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4035
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.34 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[nvidia.com,reject];
	R_DKIM_ALLOW(-0.20)[Nvidia.com:s=selector2];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71839-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[gal@nvidia.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[Nvidia.com:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[Nvidia.com:dkim,nvidia.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.999];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_SEVEN(0.00)[9]
X-Rspamd-Queue-Id: 63F4619900A
X-Rspamd-Action: no action

Several KVM module parameters use int to support a special -1 (auto)
value, but rely on param_get_bool() for the sysfs getter.
When userspace reads these parameters before the auto value is resolved,
param_get_bool() interprets the int as a bool, triggering UBSAN "load of
value 255 is not a valid value for type '_Bool'" warnings.

Fix both instances by implementing getter functions that handle the -1
case before falling through to param_get_bool().

Changelog -
v1->v2: https://lore.kernel.org/all/20260210064621.1902269-1-gal@nvidia.com/
* Show auto avic as 'N' (Naveen)

Gal Pressman (2):
  KVM: SVM: Fix UBSAN warning when reading avic parameter
  KVM: x86/mmu: Fix UBSAN warning when reading nx_huge_pages parameter

 arch/x86/kvm/mmu/mmu.c  |  5 +++++
 arch/x86/kvm/svm/avic.c | 13 ++++++++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

-- 
2.52.0


