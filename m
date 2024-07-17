Return-Path: <kvm+bounces-21795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BDDF934448
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 23:54:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BF7A7B23FAF
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 21:54:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 632F5188CA4;
	Wed, 17 Jul 2024 21:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="iIWffLK9"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFC918509D;
	Wed, 17 Jul 2024 21:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721253264; cv=fail; b=j4D4gPQ1liGzXxXuuefbpVhfyLYR2jcw2jeQB3ev2qXh1UNnlDba3CmsuSUh7baQShHqAEML35crzCU+f4jGjZgoW8uUhyfNkUjjI5OamZmtag0fySXW7Xuyicc+FZnJ73Xq8kD2F1/TJZuN33Tkv8xbLDmEgVa3Fnc+eEL/E3U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721253264; c=relaxed/simple;
	bh=f3nU5ibbnYZYjX+MVl7BP9sHr0b0fU1Guy5swZMbm/k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XnataE64S1dE3DlLh74YOjbQbIEhYDC9xwtmwqsZe56o+k4bAEkyj26YRHOykCOAVfAlHeL2g5+t27vGqVt17z3bhgzI7LFPRVne3mS74/su8IgIzvJzamGBslGFFSVB31k8IHLAISmkHMqiPovF1oGXSqBvEPMZRJkNOoePROU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=iIWffLK9; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ui35AfeX+CA8vTn8Ay3WcHDiuIj7mCR+6ZYYMnBfomxNTBqiCLOnH3rzAVmgHP2c98VNUv3i9lCn2Na/d+rAoBF0S9m2SiMOeq5N1pEf82hmjm43xqL8emXI9J0nsFAtcKHFf3Iw8/D63kBhe4aPp3SQPTF/wz4SF4V7Lq1Tje3/sA2j0iAB9YauHTAgCKHGGElL4KcTQUqIDLo8NRoYyQDALQ4KP2BgnBC0PITxq8KjMJD2trWjus+nH8CTJCNsZAdMf+zyzhGqiA06g+VQW8UmOOVJD/O3Nd1119PMPCzHstolzjVBRJVJDD+PVgqwAYiyRmIDYS00wGni13tj2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=03D1tWNSQuGBozJjxeYlE62S9b1PsZTPHMJVf7NsAJY=;
 b=NyBNwhRQagyuF0uSYBmMIleLORkKlm8N2IUpy4r/FixtYpuvTpuS6L6X1XX+CkRYrtwvoX2MCMvTfcHDZR0V3DiQvhT1ZvzfS9mr55koWIpfi6mFBFsljwVt0nc9AdTfdvp1Hgcq/ubl71h/gkKDGMIB09fihN0iJTvlnMDZyxoBOJs37KBQesELsvkqqhmZCmlhzp1/AWZnq/RhawCtvPve0Fg1e5LWt3ZZg0VbTMefRgyYuz+dKhgtLwx5vHirVnJlK6PrI2m/tL5LFIVkYWyYZR7izbO8Ca7MArSeXyDOu7y7IIVNkh5YAC7QVseciuL/YZZkoWy4hYA615tLHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=03D1tWNSQuGBozJjxeYlE62S9b1PsZTPHMJVf7NsAJY=;
 b=iIWffLK9DCvimEdQG6XixwqfNh4yY3pHZld5NCHNpcBI/i3R/BOHXpsH/03JxVKb92Tdyba9Tvq1S0tK0wqHqS8FCE/T+JJZ2Nq+ARLuXGfJcDexEIRilBAsdxmsowe36FFXa6ZhpX04kRbp/v6raNZaL+4WGFaNxjP8MP0UZaA=
Received: from BN8PR16CA0025.namprd16.prod.outlook.com (2603:10b6:408:4c::38)
 by IA1PR12MB7734.namprd12.prod.outlook.com (2603:10b6:208:422::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14; Wed, 17 Jul
 2024 21:54:18 +0000
Received: from BN1PEPF00006003.namprd05.prod.outlook.com
 (2603:10b6:408:4c:cafe::62) by BN8PR16CA0025.outlook.office365.com
 (2603:10b6:408:4c::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14 via Frontend
 Transport; Wed, 17 Jul 2024 21:54:18 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00006003.mail.protection.outlook.com (10.167.243.235) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Wed, 17 Jul 2024 21:54:18 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Jul
 2024 16:54:18 -0500
Date: Wed, 17 Jul 2024 16:34:41 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 07/12] KVM: guest_memfd: make kvm_gmem_prepare_folio()
 operate on a single struct kvm
Message-ID: <20240717213441.aanzz2aa7322mvja@amd.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-8-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-8-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00006003:EE_|IA1PR12MB7734:EE_
X-MS-Office365-Filtering-Correlation-Id: e7faf492-3cd2-4f6b-4576-08dca6ab024a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|82310400026|36860700013|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6G87svE5+mKSg1p2j3X/fMz5MsJMv4/M4yLqu7kr3nAUfLrYbe080WjASk+4?=
 =?us-ascii?Q?BveXlkF6Pn2P5ZCampXkpixGBJuh6nfA2N1d6b5QKpTVXgt72pPAqbhmmp+s?=
 =?us-ascii?Q?q9sfKYBRdm7n16E3ubMQgWGgBBEo7sz8gh0AAEltbNmaFmMSxyBLalKU0Q5w?=
 =?us-ascii?Q?g98WYpB4TKqs9iFG/9w9ZSIkm7KGdxnkw9z6fR6MopOSt4VyPs74OWRDozYg?=
 =?us-ascii?Q?kcdKrflHvB2S1nnOl+ZgqU+mBobl7ExOz0jhzC0/qylPSSiEoerGlccO2LEp?=
 =?us-ascii?Q?le1lgXQXClHVfDXl2npHPVkMX9QRd1Lz1gmleHpbA8cRBvg1MQsyojcedGRM?=
 =?us-ascii?Q?XG4f7+R2M25DV2+DbQVp0ll87F+N7/eoID+HBFJW/ylUzCS/V0rcpv2Nrs6f?=
 =?us-ascii?Q?xpZrmM/LfwL8L9cgLflxrOkkmYtf1zU/3XTGj8xWljt79qMF+GozEOAorSrP?=
 =?us-ascii?Q?bGUtaMlOAyqXOfqpy1ZRKTDYp4rBtzotdg1bOi6BRGg92KNQNBWpttQXwL9y?=
 =?us-ascii?Q?PsR2B2tw40ISoUB2aAmk0t7xb/Q1JHBmKL7drjvc8wxk0dLQfXp+p/jLvBbk?=
 =?us-ascii?Q?HyHxIUdbrP4ymUSbZx4h7zTGiYgBKwHYFobSLXic+iHZ0P9EhNReMEwyb/Fj?=
 =?us-ascii?Q?S19/2SbU1MhQGs1TeLNYLpcu7AnA6LuEoE9GlCLHn1+wM5I4ZPsnALGFDFzo?=
 =?us-ascii?Q?zLFl4/zMU42RHfrleYF1tlty9rPmLV2XnPeANMOcxwJd/yxBTvrod4AFEI0R?=
 =?us-ascii?Q?+otCcyk1CrOohfUODoxy8KNm8eRO5CI26nRjYRIX3rWiLvmDoEaNAfFq8FV2?=
 =?us-ascii?Q?k329qHmnrYqUieJ9JAd58Dhecs9l3Yx1in9yx+3A4NVPMqWPzBwjq20nUl5d?=
 =?us-ascii?Q?X9UkwElAVZvZPxxA+QgrYXPokxifMURpzIgfEJACgjkzX1lwymbdby04zAY3?=
 =?us-ascii?Q?QqIg4IfSR0/TR9wmJJ2XDoVLC/Zt4NBcnbUnrDPN/rSlsfD05ngcVBIBQrEX?=
 =?us-ascii?Q?DSI3o5c/x+VFop95HrOXitrDa/zyL/fsc4MxBYH3iDw1MRtBRh5PDUywyFrh?=
 =?us-ascii?Q?X5Yxo2TZyD28mjMp4Si67ecXshy6TgtKpIFe60oEJF/cswdo8MnH1s/xU7kb?=
 =?us-ascii?Q?Ia5ZD8hfFZa6wZPGk2M33ahAqOTOQmEjcNfjzbvKSTSGS4UdKrxRwiIv5X0m?=
 =?us-ascii?Q?SAQPgrTXXoh8QJbLorjLI2FaIsCC//eGvbbORTZD2BzF7A/xVDyPVGJVy+Ux?=
 =?us-ascii?Q?ss4QaUZiDB7ADQ4WC8f3mEWsMi2bibRRdy58B62mqVIG/82o3x7kzRog2TF+?=
 =?us-ascii?Q?GIxrnlyHuaVJf/UtdE06ifBHKVvnO/7HAfWhPqt+RZhXL+78oap4otfI8MjN?=
 =?us-ascii?Q?EhC6XXkCa5s62EwxHfmqxfeFIaZQX1CsS7EnZx5UoOodf4ZkXPcS52S9wlQB?=
 =?us-ascii?Q?9j8bxCWWjN1Q3olR2qITc5tR3WsQEeI3?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(82310400026)(36860700013)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 21:54:18.7183
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e7faf492-3cd2-4f6b-4576-08dca6ab024a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00006003.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7734

On Thu, Jul 11, 2024 at 06:27:50PM -0400, Paolo Bonzini wrote:
> This is now possible because preparation is done by kvm_gmem_get_pfn()
> instead of fallocate().  In practice this is not a limitation, because
> even though guest_memfd can be bound to multiple struct kvm, for
> hardware implementations of confidential computing only one guest
> (identified by an ASID on SEV-SNP, or an HKID on TDX) will be able
> to access it.
> 
> In the case of intra-host migration (not implemented yet for SEV-SNP,
> but we can use SEV-ES as an idea of how it will work), the new struct
> kvm inherits the same ASID and preparation need not be repeated.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

