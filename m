Return-Path: <kvm+bounces-21805-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 675579344EE
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 00:51:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8985A1C2138C
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 22:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1756C558BA;
	Wed, 17 Jul 2024 22:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="VlXhuPV2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C664963A;
	Wed, 17 Jul 2024 22:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.66
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721256657; cv=fail; b=CVMSAcb7rh4IlFncTBaJFsPibQ3l1VkZ8R/JAI+2RpUyuch9vg9Gw6WZTgJlCSs16r49sd5cPMNjCLEv4YC4egatZca6UtNswg55NUM37SWHPv0qVpoK35pY0q3UA+VXNhuTqbIB3y6321gXxmZKy7G8eirx4432JCctmGSxl4o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721256657; c=relaxed/simple;
	bh=UuuiZGNXnRT+OW8g7D5TYL9P8XgVY1uFcve/x4KIb/k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhY/vl4fRKTrfuUIoyveoG1NqYhc/z/JPFeHWOaxLiNxLohOhuzD0d6aJ3Z4W2PF64Tl1qu+4q0Uk+2CxBT9qFGU3awu/T1HuGEB4MopbPE7eqE0Zb8VehgN5nR06fjXAVbsY/W+IIFWm4i9U6IH+1crDTo3I/SxhgccBXBKlTU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=VlXhuPV2; arc=fail smtp.client-ip=40.107.237.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JKhxhzgiXHGVNvdy6xd22UOyNLMu13QXP0YHoeFc5QAf5LJyuVBdGuQezt9PNE0FlL2ovJa5OKnEk0s2Mmab13n3iAkk0lwZaCli/ki5LHwk4Di8WJyT1/QhGkozbhypb1vqfIVa5IDww3MeE8QVTmIGljjfAiXHw1nqreIKQg5Fdz9hiOfjlprG9LSdliMMvlQamGjOIPIw/8lvYc8p89+LDFHcNvK3xgmXzi1tU09GLauZAC2YqQYDI+qgGZ6O6CbdVWL5ABiSJYeHqmM3FIOPFALL1hVupyGDBw7AWPmuotAIipB4/3wY2cAWeO3qj4vR4Sa1XHpgjAK2El10Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m9TEyQIzKe2emYJfc4P1xd6QJsTbf844C2myIUhUDNg=;
 b=RjpMlTjeJfOLnPR03U2jHNPQ7yrZ5jLr8/5sbZpYuMhN1/lx+yzP6KHvfUsnUwZfyBJWZRYOeB8Vk2UkH7WhqNWDpSVleu/2ENXJEcSG+exlTnJIEufQ6bIGv21W9147p9ciwRkIMg/vs/g0d140AB7Xhe7ZFoJNNhW3H1wvIDuZqCAYyPGbVkcahy/gbI1tl8HDQGfzXKDnH5AE5rcMbmxFuFHpZdCYSfjiGKEUsoV8ENXMU8Vx8C7QlW5D14Sjwer9r8eZMN4PQUzNmphiffPUmNypkEOmCNDb5CpfuAdANdxtv1NVKjwsvVI5O4uEfVc15QFS4SmzHG2wW/hfLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m9TEyQIzKe2emYJfc4P1xd6QJsTbf844C2myIUhUDNg=;
 b=VlXhuPV2/xADkxzxcqV6x4q896TCXUGiWcMzTdTfMVTY8Ba8uchT+HRSIg93nhRLk8dZHpKZXuf8OgFyOsx4R0A/XzmkIDebpJQW+Fgh/2rfAI0XpdkFwh6E0zX5E9BKrz/LA9pe/CV906Rvmb89I31FB0ocvFU0s70LCphf63c=
Received: from SJ0PR13CA0067.namprd13.prod.outlook.com (2603:10b6:a03:2c4::12)
 by DM6PR12MB4185.namprd12.prod.outlook.com (2603:10b6:5:216::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14; Wed, 17 Jul
 2024 22:50:53 +0000
Received: from MWH0EPF000989E8.namprd02.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::e3) by SJ0PR13CA0067.outlook.office365.com
 (2603:10b6:a03:2c4::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14 via Frontend
 Transport; Wed, 17 Jul 2024 22:50:52 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E8.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Wed, 17 Jul 2024 22:50:52 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Jul
 2024 17:50:51 -0500
Date: Wed, 17 Jul 2024 17:49:45 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 12/12] KVM: guest_memfd: let kvm_gmem_populate() operate
 only on private gfns
Message-ID: <20240717224945.pg2hegox6si4cqrm@amd.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-13-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-13-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E8:EE_|DM6PR12MB4185:EE_
X-MS-Office365-Filtering-Correlation-Id: f35d5640-cffb-4d25-b7ac-08dca6b2e940
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|36860700013|1800799024|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OGSaGsG/T+UgqYsG6xHz2BRc1YfovZdkQULH5I0vJuwksBZPV74hrr6YXh4u?=
 =?us-ascii?Q?a5tedXsxA6GTgMTseOqosR96r5t5zcr6Lpo+rgSxFF9Q+ZkZPYS0WwuriEHU?=
 =?us-ascii?Q?Q/ZHXNGEtme0vr/+3Mtcsak4IKwXw9ukywwkqklG2aIVtuRPqGmyuc58EFK5?=
 =?us-ascii?Q?8FyNVJN+Om1ufyDlSPPa/5NXegPwM0KH4Ke7RcMlv4jmmSApcZWrcmQZGmnB?=
 =?us-ascii?Q?XgUwtIdwcLd0mp6v00rRKB2bppj0YUJqFXgNsv2eMqv/buiXag2MJYMMmiXL?=
 =?us-ascii?Q?uCmCTT2aNDLnBwLKo+NocmzRAP2cNuX7b2lDRfXYq6EQAoQVr0sA3MpyYr1p?=
 =?us-ascii?Q?mx+g6S1Jvr7D0IdNBLz1bLFUGD9hnq+PedezenoFJ7bvPI0wzt1OTh9d5z/t?=
 =?us-ascii?Q?6wZ+9XCjvPhoP70bXWuvS78VIy20dMNN53RydwJPS4Uj+T84Wbqr3AWhn64D?=
 =?us-ascii?Q?fniT1wtDvxPTur0lgYlRR+5Kt4KNGJXP+3NgyKMq/hqS/RFIE/b2i0T/7Cu0?=
 =?us-ascii?Q?M5WjUm8RU4MNrQvQwU1qa5kBbqHyn526CI9TScUVM2LNRmYCvmnackZwkMKF?=
 =?us-ascii?Q?Kn3hhIgOukXMWKE3RBVlsIgnvCZYk2qFdJC9cfC04vCQKfyDcD16btlmpOJB?=
 =?us-ascii?Q?WjEXestQs6blH2Ngl2dMzvIr4Rp13VfGrMFiJ6JcCbVzhpdOFXmz3eMcYVZA?=
 =?us-ascii?Q?MNdIFlCAsZrjDmNEiDtowVD+ct7CzxFl1syPeWKHnfIFU+vQDYHR4lOjqTEj?=
 =?us-ascii?Q?Y8CtVjOpGeR2L1qRKLeSv1hINmN3aFgR5raKZZ1SfarcJegyAfp58FLQuTmQ?=
 =?us-ascii?Q?lWe8ncSYhcZEE0BEZDC+CBzW3xtKC+O6FVXqXQZylHGZI1C5MzhPEhm1fwZN?=
 =?us-ascii?Q?AOCOdhEk8RR9hWHt7PLUuyzpHtHJU1vCYnHXG/81VGRvsTKchdW56C/aU9QV?=
 =?us-ascii?Q?tqoHDxUGwSEsXhUUWhinKv0uaLn2BC6VWR1UNQbZGn4OnN2XbsvnCHgUt0Jx?=
 =?us-ascii?Q?QA6wDdzosd62Dh40/hNGOZexxB+rHufqJw9Cq16PTBFDoPTyi6jwRlR5hOjC?=
 =?us-ascii?Q?U2T++yQy6CJvGNe2lpu7R8u7IQ/yb9NAGDkfePS1org2Mvvs1bu+dCDAj84L?=
 =?us-ascii?Q?JHcnBvj1QxLZ0dRIctNWBD//Fv5lIu/oW03BTPRCx/w+ROFDUzaQTy++WUT/?=
 =?us-ascii?Q?TftoTJi4snthXomhOdyWKYur3lfCswljbca/WoYrMI63SD/R3eOXkCoQZts7?=
 =?us-ascii?Q?+IdPLyHSUwR1qLvNFdErvc2smSw4GUiB4LICDwWSNw1h7TQuT/S1YP3nGNSt?=
 =?us-ascii?Q?Y2+9alqiO/vt+xWAGMPmDeBZehKFrVH/duIDrhfXLh3JRIgsU2Fsn95y0DOx?=
 =?us-ascii?Q?xXgFJakjKQEosa3gQSjb/GAD0s8hbaWPtutei/SW4+RSY0KP3yWsmfMJZG/Q?=
 =?us-ascii?Q?YwdHEpYyfE6Mz2FaUbGuUz7SoRT58J8A?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(36860700013)(1800799024)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 22:50:52.5614
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f35d5640-cffb-4d25-b7ac-08dca6b2e940
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4185

On Thu, Jul 11, 2024 at 06:27:55PM -0400, Paolo Bonzini wrote:
> This check is currently performed by sev_gmem_post_populate(), but it
> applies to all callers of kvm_gmem_populate(): the point of the function
> is that the memory is being encrypted and some work has to be done
> on all the gfns in order to encrypt them.
> 
> Therefore, check the KVM_MEMORY_ATTRIBUTE_PRIVATE attribute prior
> to invoking the callback, and stop the operation if a shared page
> is encountered.  Because CONFIG_KVM_PRIVATE_MEM in principle does
> not require attributes, this makes kvm_gmem_populate() depend on
> CONFIG_KVM_GENERIC_PRIVATE_MEM (which does require them).
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

