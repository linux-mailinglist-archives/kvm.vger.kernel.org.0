Return-Path: <kvm+bounces-21673-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 886C2931E02
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:15:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA5541C21858
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:15:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C516136A;
	Tue, 16 Jul 2024 00:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="UA/POCN8"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2055.outbound.protection.outlook.com [40.107.220.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B386AB6;
	Tue, 16 Jul 2024 00:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.55
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721088879; cv=fail; b=a/nUVIUxSr1UAppmYpOt7T3+nm5dSFZAr9EmgCo5SYLPUDx7qYce9UUWj4Af45sLQVEOxVCRCFx93rqo2eBG+sW7iqDgOSu2FLjBVpw33n2eKXUUNxYfsQOd2FX7YABWWAlOVFIJwkiRZD+q8IHX56FbNjMrnU1EODEUrH5AQtw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721088879; c=relaxed/simple;
	bh=dPDMh+KLhiAeK5CwhXA9SHnH7ivLBiZ5EwWWi6FugsE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N9lPEpsVlPXQOcA71dZMfwzIOlHu+tgxNGjhoradHnIAchfmH1tfhoO81I9HgH/rIdp+n7NeNkhrfNEzJHHW7U/Uv8ubek0vorcGdQNnnStDIJB5n9PD4PMRYT70LBRBKlahQYIGZMRGAocu/Rm0ImXEFg6PgqsxPlzuxAJfd7g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=UA/POCN8; arc=fail smtp.client-ip=40.107.220.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=czZ0JOQH7f8GS9tecZTEpyXf+dUmkl8TqAqjRRvagtcdSIbAk2QgIhiiT8F8J3W1XBSgcDyq/MPckNh7U9C7oOrkVnhyen3xjya1u7w2V9CR0QyfHISwFvC6ZYQcwAwKVFzvmjU/FOblYbR7NxWyTTikQyg6raBrxzEnLkPm8LGICE+1VdZ1G6rS9WJTegmvdXU5fSzVMnkjZaz/xSrnNOMp86m5mRsBN+edhjvoc3RyKyASKe8nj1NUfbE2GI/4Fy7thTvfchUU/KM88PkL7Qv5LTZnZaPcuWE55CqaU9r6ThOHZ8zQ2cHp0VKe9yXPJz0ASMGcTvZPeyyfTbn4aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EoLQheYUnOEyIP1HEe8zzALgG3vMDoZIF606dX9nApA=;
 b=n5QIPVVmW/eQS9gSYXuS+06HM5G/cIeBbdUZCTbms1jum3B4691eC7nEucaH29OLkoEprSCk4+cpPjuWDC4LNOB2f7C2h6hUsmDrK/cmdW84Vef/8Kh8XyAwMl02MaVrK8yirLCcEkt6nxV7fZbpX3K4TKodFzCj5KSfNgy49+hl7THK2n0nJaUWxYgE8EWazxvWEc3qnbHUDooA79DAvoNw35TGrEReS439lXuY7gKYEmFqS+hl5lqSqT6lvLxAJ5jx8YYII2NgIMXdMMVD3sVq3BTGWv1X3ofl7iswmBatCPYJCOJq9WBsMW8gsoKsGbQZhPNnuK7IHDGwM/5foQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EoLQheYUnOEyIP1HEe8zzALgG3vMDoZIF606dX9nApA=;
 b=UA/POCN8nOzwMBx/HHPgORI7IWLuZ7/hH5fFoX9I1SisqV2LNJgX9vN2S1Sb9+5Uz4NsHwO3t6KuH0jSeXHozWn7M0XFLuBDHZUOUTrGU8UVIIX1GxiLfs4cUgivortrVR+u1Vv9LOliBcYrq2DO8+2eLi2PO+kkvYUP9cZGAYk=
Received: from BL1PR13CA0381.namprd13.prod.outlook.com (2603:10b6:208:2c0::26)
 by PH7PR12MB6694.namprd12.prod.outlook.com (2603:10b6:510:1b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 00:14:35 +0000
Received: from BN3PEPF0000B077.namprd04.prod.outlook.com
 (2603:10b6:208:2c0:cafe::34) by BL1PR13CA0381.outlook.office365.com
 (2603:10b6:208:2c0::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.14 via Frontend
 Transport; Tue, 16 Jul 2024 00:14:34 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B077.mail.protection.outlook.com (10.167.243.122) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Tue, 16 Jul 2024 00:14:34 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 15 Jul
 2024 19:14:33 -0500
Date: Mon, 15 Jul 2024 17:40:46 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 04/12] KVM: rename CONFIG_HAVE_KVM_GMEM_* to
 CONFIG_HAVE_KVM_ARCH_GMEM_*
Message-ID: <454jqn3elzubby3hiwxxyf7t3h6lm42ssw4hvcvrgwwwvdavae@lhlxme37efpc>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-5-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-5-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B077:EE_|PH7PR12MB6694:EE_
X-MS-Office365-Filtering-Correlation-Id: 5aab6d56-c4ad-4a20-9c04-08dca52c45c9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?Y0xodcxpidLMcm8bz0oYZJgjYpUqgP/8SJwVnHZ7981vwJX3jYS1lDL1iABQ?=
 =?us-ascii?Q?wBSsFkTi4ZlitbKhTomJYZevbsw/GE+Cu4jKFmrOKl/DTS1zSGaenCiKQgo5?=
 =?us-ascii?Q?++QWUldJWWoQX3YhS2z6xu4I3PT6frXX9Ysdn8ey+V6OpXOcsG6EKAcGDR0+?=
 =?us-ascii?Q?s02FAENDTl9ueJS5i6MFbrjPFRgR33a21yRNUJhoWH+M7KHB8FQLiGfEJO+P?=
 =?us-ascii?Q?2Q+v5L6PIxzjbwz2qCeSa6ii8HwfkKpga47px3yksbqyqsKyVWvM2S/Z6bVs?=
 =?us-ascii?Q?6R2TDY0l396hwIQ2ePZJztQZ3PBj7rFuw2tRtk+pcVHTKv1TOHf5+FUstECR?=
 =?us-ascii?Q?nxnaOm07g0xkpUa9aUg6JQX4L1YGi4t4MgVOVcfaUEKEu3aVRyOj0Zr43HSt?=
 =?us-ascii?Q?e+0EGnJo49judwr3IIW0Bz0eG6T9ycpx9CVKerQ09WAqkyTYen5YDVcT7PVL?=
 =?us-ascii?Q?UYyrE1xP6yqP2/ZJ9D4w9ho9fhZ/lMWACSEcWwhWwK+bK/W5RiocFKzk5ERJ?=
 =?us-ascii?Q?RQQyUECAw1XOayDc9EqPaTyISZ83drZThzOARheVWliy+D0gQbTCVsj1M2DB?=
 =?us-ascii?Q?uf0F9QK/LuFkKcKvSh/Wrv+bjUCzukDbbIHLynwsTUveNlcrU2sywr+UY/fe?=
 =?us-ascii?Q?NWt77WPg/ZUpB8CTLSuVQz7rtwGZAdSmYZaONTsHz+iu1Zf13o0qT5M/i3Bo?=
 =?us-ascii?Q?37hR8PiYFNQ/mYJk9vlQJbm9PWWfsAKY+o20IvI/JCuGHKYzqajim/18fuFd?=
 =?us-ascii?Q?AWmNjM8H5VDZ0xLufybANxL43dCr/TGOCK3LUp+dFpJr3kEwXsPWD0ieJ0ow?=
 =?us-ascii?Q?TbiAE8SbJZwg4DwcVz4I6GJ84EDKB9R/wsdghZ+KawDK7w8L80Pg8KrlPGUN?=
 =?us-ascii?Q?Yq2a1COXOpS68AW1AC/fekNddM4cXWrSFAfWv2Hlfjl4K8JYpVS6xxpyxvp5?=
 =?us-ascii?Q?gfZFgAuypZS/xYN5WJdUAnZjykUZeONm8kJGvn2hCDgH08XTnxOfNh91Mu+c?=
 =?us-ascii?Q?dRQRovYoT0DQu9fUrwPZOLWR6K6YPGgSl/5YQ2xyMpXEaV2rNlX5xcsCZKB5?=
 =?us-ascii?Q?3M6s1Iw3O/w3yJtiF2lc6eldT8rdnEKosapcmru6nTLTTzlS4upLwm6xm41J?=
 =?us-ascii?Q?NJTWJmpYFZ2XaehluH7H8yD58rcuHrnv9pWiInPJBXyZWS24E/ggkct89i4j?=
 =?us-ascii?Q?SeuXorZRmW32UfuNNcBH6805hn+P/QfV6z1PtKJ0vu5Y0HD/TTDZA1XjCfVh?=
 =?us-ascii?Q?iYr4Pwcj+iD7FVfZ2FMb/nAz9YtnzL1uhDNkgycHQgDKHYpt5NDR9xg5Lf0w?=
 =?us-ascii?Q?IFDG78IbKNsmSnPc7Gjn/2qjdSBZ+NTkFEswoH83CVtZBiVzFvRCrmf85wLS?=
 =?us-ascii?Q?Kd26we+oPWFV5zWCZ3t2zLrECB0S7ncOSMm2wAeBUkI+3TfPUitL4uFRSMs8?=
 =?us-ascii?Q?pIbi3/slFNaor7RBE80QfpM4SrBRN1gK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 00:14:34.6971
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5aab6d56-c4ad-4a20-9c04-08dca52c45c9
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B077.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6694

On Thu, Jul 11, 2024 at 06:27:47PM -0400, Paolo Bonzini wrote:
> Add "ARCH" to the symbols; shortly, the "prepare" phase will include both
> the arch-independent step to clear out contents left in the page by the
> host, and the arch-dependent step enabled by CONFIG_HAVE_KVM_GMEM_PREPARE.
> For consistency do the same for CONFIG_HAVE_KVM_GMEM_INVALIDATE as well.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>


