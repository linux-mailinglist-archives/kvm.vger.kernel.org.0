Return-Path: <kvm+bounces-21804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 078D69344EB
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 00:50:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3417E1C21603
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 22:50:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75C18558A5;
	Wed, 17 Jul 2024 22:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="j77I5uEC"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2046.outbound.protection.outlook.com [40.107.223.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9EA51016;
	Wed, 17 Jul 2024 22:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721256636; cv=fail; b=h1ANKI9+aTJ5JWTDAMU9msmJR9gA/cPayZNbXKPu0Xu3VNJKiX3Uk4s9YeqDvH4yzKXvs4yDUH7X1RE6uev+MOWVXLcFbUJPqjzx0JHffh79uazgmgfNKJMcsQIAlCewAU7MF61ocquKiyOTZCI9dLtE7XVfW4RyTueAUw6gpJw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721256636; c=relaxed/simple;
	bh=zZSlTR43/YIpSIAui7zR3HxNAJhJO8oaPjdYnYwq5kg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ULMjeOUqoom1hjt5yonaumtERm/+J/XRmjsYh+m2lAqnkCk7FUXI2tH6GfGuZKxnQsadEx47kbgks0pkAcqwNDn/Fmo840Ej4i9IYJ5skVB1N6Qi+7VLFS86xHbwpHMJGUNUFq7ZnulPZ0bJqe0KltcU7zviDPH8UhFmPIOe9A0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=j77I5uEC; arc=fail smtp.client-ip=40.107.223.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GP60237fftCBnvoTS5EJaQLX7NMlxlVwAAqad+Qyo3z2zjwfQ16/KDSQ05JyC5gjKb0T5zAMoXsbO5aCe6+7TgK/hCYaNXjs7YW1MrEEv44CCfiRjbTctgpMEDZ/Es1TqzngnhOLTBHd1QnXAF1Xz/nLH9lQU99wOEFR8Rqa2gLEathcPKTwep6LlqBiE3VdMR50BJS9Wflj2NKg707wYWHYsGlnp9baxv4D3p/M4IH7qpwnwRHttCFA1V/6jlzG5SZFfe3AtlPInVAjUXyOeOarZ4TiBIUdpNzoA7nXuqNn8/AxcJI0755b4eHAxsG0VnvfSxPHjQWDBmIsSRmHsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=18bv92qzYgjvG1XjgbGBEG0ISHZ9GXoEj2mSoF4xdoE=;
 b=EZUS8JkH47MZpNKwnZucm7DDLBX2JGf+ld9RfrshL581Dk7sPHF314pflXmyN+2X/CQhg4rKR1iIme1I6/MzgzH3EeHI+mnXylKtOdCPJ0skUSRqQce/Q4ED/y6UtG8WUpTcMs1IWzFi/czollRwSoYKFfeuMoyqzHxXRmv3BUjl2Mlv52co+Eq4oidYmU6qCTecYrjXYQbdRuYHh8tGDi3A9nR3vc9J6i/VukkmnlRvFQtBWXLxR6zlfkOMrEF+phv3rwOHgsZnk6AWMf5w2RiY5+J65wLmmzbW+moEfhUZvCrqmr/J562tZFBuQTADRhZKLR5dbkyMpAhoo9dXaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=18bv92qzYgjvG1XjgbGBEG0ISHZ9GXoEj2mSoF4xdoE=;
 b=j77I5uECqKtu4KtsthphRE1e4nSYQc8NGa5O3K+V4N1NXAW6dI900qgmPoV+7h88pKhSvq/9mJm0b2qnphV/nvKPa5i5ys16+Q5WTYb2LB0tMHLAraFW0E7p4ywMYBYKeLf6lbOhi/MOmBXqVhoNPJWji7IwBs0uAexwdTHILZ0=
Received: from SJ0PR13CA0080.namprd13.prod.outlook.com (2603:10b6:a03:2c4::25)
 by SN7PR12MB7227.namprd12.prod.outlook.com (2603:10b6:806:2aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28; Wed, 17 Jul
 2024 22:50:32 +0000
Received: from MWH0EPF000989E8.namprd02.prod.outlook.com
 (2603:10b6:a03:2c4:cafe::d5) by SJ0PR13CA0080.outlook.office365.com
 (2603:10b6:a03:2c4::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.15 via Frontend
 Transport; Wed, 17 Jul 2024 22:50:32 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000989E8.mail.protection.outlook.com (10.167.241.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Wed, 17 Jul 2024 22:50:31 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 17 Jul
 2024 17:50:30 -0500
Date: Wed, 17 Jul 2024 17:32:18 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 11/12] KVM: extend kvm_range_has_memory_attributes() to
 check subset of attributes
Message-ID: <20240717223218.nmgpx5u3asjdmqbj@amd.com>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-12-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-12-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000989E8:EE_|SN7PR12MB7227:EE_
X-MS-Office365-Filtering-Correlation-Id: 992c1783-340f-4d4b-7fc9-08dca6b2dce2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|36860700013|82310400026;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?N1sxlpI7gLSI/jsTrJ75aXAsmBJj+4GtT2uF0grYNpaEfE+cC68eER71yU9P?=
 =?us-ascii?Q?haTylzhom+Qe2d6WLF/BrhP5DxawVExJXgUGKmhz6nQCYvUEClqSfEdOhwLT?=
 =?us-ascii?Q?mT7a3WKi8tpUq0i9GA18zT6z2rfZcmjhx5Gw6LcCxwbDWTnB2T7Yaxzb8jdE?=
 =?us-ascii?Q?2EEoXt3FlkJX60KxT5Ro7N4W4FKWL5qo4Eu9jQNQ4cUx0/SBu9/CgjOJjAkj?=
 =?us-ascii?Q?cnJ8eOwJW3hm8ClUdVcz6uvARTznyVfl9W+pwA3O4FCyd1oK9gSgnB3L8JP2?=
 =?us-ascii?Q?6oyiAAYBUzYzTpJcKeiYkpXAHWA2SrInJyHj7QhHP3hWyvakba3+z7Q0OGAw?=
 =?us-ascii?Q?Fq8HNRj8aZYXgwJcCUCUYOAO6c0z6CJfrFwmG1QaZbxAmRukRFbOTH7TAkUY?=
 =?us-ascii?Q?q/cN412s1mJBR4wsT7t0DSt36667GrZ4PWwfpuP46vD+xFv+jixjqwUdqmLv?=
 =?us-ascii?Q?7vGjK76PfLDZjHIREmx33CkykeNFWeoN+Oaf7hASpV9OoB7f98D6aLqbnzXR?=
 =?us-ascii?Q?NYkGxcjtqHsDxGdy5dEcynRvYsDPrKA0rLQVM9BpjD+ZaCVtFCr37hYIpVPm?=
 =?us-ascii?Q?uyjI/ZxrqGKw6TTpjlFIreuAguFvFpH4tjI5z0zVx0k+FtAqY64ok8lGGf7F?=
 =?us-ascii?Q?OEkJlSG41DW3x6DRzYX3qG2MkBb5W7PvHftKZkjV746t+GOQ52ailecZ64db?=
 =?us-ascii?Q?/kBBmdmQ8sGV2kyCp1hr1wwN12YBgEfSmsywTTyyoWHs9GG1YjwiRJbgCcVl?=
 =?us-ascii?Q?0PT7haDFeizBflmO4mqCbt4GjvZlnfrnrUhw9XLYxC1KNdxfeJXwFF30nX6c?=
 =?us-ascii?Q?9H6WdAPcg/LzW7RoGfkA3j4eppd9haepXcONyVTwFwVtNruIF9XpdcHnx7j9?=
 =?us-ascii?Q?koZAjoUBjL+YEqpzECWL0dtxoET7ILvJo+1sXfP8BMmlCjb6KylckCBfnS2O?=
 =?us-ascii?Q?P6PejyiBS+uZL9YdkhaXZd/Vtfyn5ezg2ze19K6X/fle2Mu9z0HwzCl/Zyg0?=
 =?us-ascii?Q?IQDs/6or1nY2yJ7wmTLwzPImS3pyQj06LyhK3ImouqeGAcExiNAqvLpZE9or?=
 =?us-ascii?Q?bgQ4uLjUDxkOGg7iCcpInC1qnMCkHe22RkKuqG0LBEj+eTVfXY0HdnbRh8MU?=
 =?us-ascii?Q?fmzp6QFswD8nMljoAE+l/wNdoXPDACEPkN16cIOYPtkiaGPG7GE7gdySaRL7?=
 =?us-ascii?Q?OojNDb7a7WSbyubfyiQ68FhKMzUhhu/c+zqpA7F6HpKD1mbc6ydwJUwVF1rD?=
 =?us-ascii?Q?S85xIbyTgRrTfBNr6WXMIfbD3MYPvNwv7FBvHIT7rIcEFLoaBwcWeeUBS5n/?=
 =?us-ascii?Q?Mi+d0lAs12WEQOPMlqSCnQdLx9z/NbDWM2l34sSbTbCUVcMGLnoLMchvkZtH?=
 =?us-ascii?Q?O/ItDxCwMF5z9WScrlNV53WWA1HLI25cU4QVoEjwzjuB/TpGRkirjLptpwGm?=
 =?us-ascii?Q?i1Jc1uRCxe8KL4g+bLJbFsnf2H0lNRGv?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(376014)(36860700013)(82310400026);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2024 22:50:31.8113
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 992c1783-340f-4d4b-7fc9-08dca6b2dce2
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000989E8.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7227

On Thu, Jul 11, 2024 at 06:27:54PM -0400, Paolo Bonzini wrote:
> While currently there is no other attribute than KVM_MEMORY_ATTRIBUTE_PRIVATE,
> KVM code such as kvm_mem_is_private() is written to expect their existence.
> Allow using kvm_range_has_memory_attributes() as a multi-page version of
> kvm_mem_is_private(), without it breaking later when more attributes are
> introduced.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

