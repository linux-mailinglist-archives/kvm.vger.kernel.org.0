Return-Path: <kvm+bounces-12067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 858A387F55E
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 03:20:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B59EC1C2165C
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 02:20:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B53856518E;
	Tue, 19 Mar 2024 02:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Da6vR1Q2"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2062.outbound.protection.outlook.com [40.107.102.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD922F22;
	Tue, 19 Mar 2024 02:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.102.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710814845; cv=fail; b=s2Bxz63zUIkFhR9efNSqMl0keyMYisz4fPlO54lmOhBWK7VEYbBsMkopvIsKjB+XFPiQM2/Df/x/QSo+EHnIQYfVtkkqFGzfJRyUeUAPtYTQUcOlWVzm0qERKiuuK/Px6HMzyhlJQx81WwhGqI7PJj5ziwnNpiaBXP4hEu8Tmqk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710814845; c=relaxed/simple;
	bh=+khUKGfXQen+a38sKPctDDxPM9ezfjgPgJEdG5pt5ek=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mlv5lw30cBOAEy2yq3ln9Dm3NmfLgDMmEF7pahW3vT6lG+zRXlZ4srSx1Cy1Kc/up1LfafYgDa5hdQGRc29D2Iiv6SVMzHGRp43k0DWVcWHXiKECxvayD8gjOzg+1l27uPf3JHrf0ScFa7zhsWOQZobu071zaQ3FwF/KdzFZ5TA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Da6vR1Q2; arc=fail smtp.client-ip=40.107.102.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jbZ3B7pH0VxTcRxc+pPHa/pMDLqSNSZNdWJ5dCu/qyGFHtCze3X4iA3IA0cHkWckrl02HvsDZqBQtAHUFakeRsP181tb8GdN0ivfDz3dorVRXnEBIwW2r4DLA41Ahl0TqtWbYqI6K2d8erXMvLaf59EB7JPD/fLF90nn9EWlI/N17PSX2vZOwh2dUTnnDGrYNqlY6k6Grcsinf3QSgm09TxIPBC+RizSTsNwFzjK8VHZbZwJtZBSrf9LGFKjEgu1f7lzyqEZISQ1mA2rwIQSS0lyTmFf9VpH6fiFSqlVFWi63d+sjyKuz1ucY3MSmqMAPP2Z9SNd5OBebK911mNecA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pCGBWhaJLTQIcgHtad4SNj/ZQjLSHt2y3C8uKyVIVXI=;
 b=hLgxJCiwlhf4XY2Ps+2QLK3Y/kIoFWRDpIYKRjjBraWDmxX7oZ0sFvPcIzO6tfws90LR+YBH7DmtUlqZr7PXt/ejRSWRpJ1u8nCwqAV/6wWkbb4EQ+wpPoNlbPL5jb4GPuPopppC2H6qtct/u2USLmh031DTISsC29RQTEg6O42tiF1Rmp3A4+gG51v9bq/wVeosLu5FV99nBumXPNqky9SvDVmdpsHdXzkzATc5Tr4YAhnh9xWLpkqUXIRhT6FrQBNAN4VC8R2mbbChyKkUwWqljP0OK/Q9PCV1IlOm8BX63BNyZU8HctKXatGoc9NQ5eVEwoZnZx85dkx/XIJRQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pCGBWhaJLTQIcgHtad4SNj/ZQjLSHt2y3C8uKyVIVXI=;
 b=Da6vR1Q25kaPgfnXZZlpKAhtFtFOMMBzk2q4iSfsO2ngd8SfwAmn7NShLrXoOZMcBEGpM9EnYbNoLw/7tYfRcBdIIuVfUwTz1xGmSx52sdIgC2eeN6BH/7e4eh1+3GWn41Id79fBhFwbs5qopsdFNJdyrzgOB9rbHpRzwqDJmm4=
Received: from CH2PR19CA0025.namprd19.prod.outlook.com (2603:10b6:610:4d::35)
 by PH0PR12MB8799.namprd12.prod.outlook.com (2603:10b6:510:28e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.27; Tue, 19 Mar
 2024 02:20:39 +0000
Received: from DS2PEPF0000343F.namprd02.prod.outlook.com
 (2603:10b6:610:4d:cafe::d6) by CH2PR19CA0025.outlook.office365.com
 (2603:10b6:610:4d::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.26 via Frontend
 Transport; Tue, 19 Mar 2024 02:20:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF0000343F.mail.protection.outlook.com (10.167.18.42) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 19 Mar 2024 02:20:38 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 18 Mar
 2024 21:20:37 -0500
Date: Mon, 18 Mar 2024 21:20:20 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<isaku.yamahata@intel.com>, <seanjc@google.com>, Dave Hansen
	<dave.hansen@linux.intel.com>
Subject: Re: [PATCH v4 00/15] KVM: SEV: allow customizing VMSA features
Message-ID: <20240319022020.jrhlpovgwwqu5dzj@amd.com>
References: <20240318233352.2728327-1-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240318233352.2728327-1-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF0000343F:EE_|PH0PR12MB8799:EE_
X-MS-Office365-Filtering-Correlation-Id: 30c82c0d-0cdf-4f36-edc1-08dc47bb2b47
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	YDqeST5hQCCcAurz2Klwqz47OA0VCX2dYaTEKDFQlNN7HxyncbPUCQYfc6vtfg6WW51A9ZfibJ9m+PHrC/LgcJOCYk6wOSNTzZbvINMjItQ9g9mRtkV/X23AK1eNJ2r1JKOcXGortuDpBFwWrbORsKo1YGLkvMgwJxMytNODKplZ+hI/CiWqbWYZ37GKATTeqLO+dYz1d0ua445Qlga4MrRYtpyPGbljo8TmDbf7OnxZOZG5CZoi2j+0USk4Uq2y6Ohn29SphXTdItN56g/Ex51L8wZYEQYVwmxfA/XHcnbagIkr53yDEgWI2a+4Z/LWj+tRYLPS02k0L2nzvva0usSylXmKt+h8gpld/XGcLbz2757VAakQKw2l2CcjSb4xdbBBQmzp9Y+QGo70w2EWmIz2LTWF1IYfhRlV1af0Cp3He8sQFPGa520pvEoLtbgCNjE2sGWH/fPf+PoT0EPkgxoPxPX3ELpacTqZwyp110XMkiASJh3qDfAvyiAbwqKvpyHSl8crMl56lAbg12Lu4OzqMyo3TtD4WWmWG5pJeto99hQlT8vsnemSOYKHEL3kMrFcR7+WbREjDaf3olYKqvXpM5aLDrrjmtQV0OUaR82YyYKnqUq7NPwZVGRmzR5RbI3dHdI7/VAcKxaz6lfGBHo3KYY99Q87aA9NSjMvlGttLY6aqdztoriOXOvcz4kVLhCZY99VaF4dt7l6CRx3dg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400014)(36860700004)(376005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2024 02:20:38.7546
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 30c82c0d-0cdf-4f36-edc1-08dc47bb2b47
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF0000343F.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8799

On Mon, Mar 18, 2024 at 07:33:37PM -0400, Paolo Bonzini wrote:
> 
> The idea is that SEV SNP will only ever support KVM_SEV_INIT2.  I have
> placed patches for QEMU to support this new API at branch sevinit2 of
> https://gitlab.com/bonzini/qemu.

I don't see any references to KVM_SEV_INIT2 in the sevinit2 branch. Has
everything been pushed already?

-Mike

