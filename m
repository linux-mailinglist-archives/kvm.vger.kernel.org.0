Return-Path: <kvm+bounces-21671-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8359F931DFE
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 02:14:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7776B21DE6
	for <lists+kvm@lfdr.de>; Tue, 16 Jul 2024 00:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 523BB33EA;
	Tue, 16 Jul 2024 00:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="b7kF2sUQ"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2067.outbound.protection.outlook.com [40.107.244.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162F74C74;
	Tue, 16 Jul 2024 00:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.67
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721088836; cv=fail; b=H4CWHLrqWOdBPFEpLBRg+Mvq4mA97S8khI+Xc+Esb1ltHry8Evybn0+02Lr4mNw53+ocLUpYgM5i8ILx9S8f9hciiGSnL636WX/XNaH6C167nFNl9Lm/ZqrQmHX4o0VoHtXKCdpAqKQ6GjeBhThDU5Th6CFfTMOdVv5FdBR2R1E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721088836; c=relaxed/simple;
	bh=CzR0cfQxAw2IiXwprszf9xsTgng+C/sfF3l1GS5Togc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LeqI6Q6Zh+XEU3iMsJhjpACOpmkrAeueQUGIwiVIs0w4hUZDYOgXnWTet/hob3y1V+QBZJVjjqOGJ3ef/783lHH37kpszNYauVf271fQ3RH0YO9cdtXoC6SEUNc0l4wfY5AYmwNjdTsh5dv22LoleD0mWwSqIiVZ9de5QJLBP5c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=b7kF2sUQ; arc=fail smtp.client-ip=40.107.244.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=rlFKt8q20iHYSU/Z0gcm9lxu/CsCGwvUJ5oA6L0RrWWdp17kKcUD4PcMNoRPhN0x+IdxmdDdeFO6Etd+b/W04GK8gOFvYHljzcBk3yTlpkR9AdYvrWuQ8+O5WixEgKvCQI7K87/h38VT1tIcrat7RbIOrKwMPCnAAUR7QmYHvQ1l9MMvo/qMFbzTe0b7DaSGTmr07F7TP/BrTy3zY/v2zV+uAxLRdHgA3ZA1DgrUrB32K4SWb1IV3w7oSsSATLZ4FsWKAIZxGKIpipCpgOVELKr4bomIgLwIEmA5F0fJBGq/zLBgBpuGstNPWLJBWy4umQ6BO0ISgDvh2+8PgYes7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/e3WeqG7HZUKqCqABEXjHRZqmUm91ZFYROk9bF19hxs=;
 b=GBzSKn4kglWLwpQFNFj+OarRKd1X6SqQVR5EixYdiRMQGc75xKU5a2bhopMVaVm4AOxWPqC5yhPjMbblq0o9eApQtntRnV5uRvtjyFOl13R6LAo+CnKIwRpK/KlcUP6z4CqUx4ttRCU/UJNCfYpyP/xGijWdJ2YkElU1SCcBpcSj3kJFiuAdIIGXuXJcbWEJjQnnT8+f/09LljAb2hpSXWZH5XcgWo1R1MDLyjtYCDjDDuwQVIv/2pNj78CqfpPr/9iwdYFjxTnofF4XC7x+/v2GVWS2j5zWxpL8I3rjEs4SOOG15nuVCn7PNAAOfcxFsWiHlDGR8RvWBSQoxf5/8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/e3WeqG7HZUKqCqABEXjHRZqmUm91ZFYROk9bF19hxs=;
 b=b7kF2sUQH8qS1vN5j2nZrdoU/vR1oxly5Oa9A00cnNAPGOcLHOvDRx2Nlo+2IiVHV/afkiNwsGGuNbTaolpfG8VjV8YDTVwK94Mzxm1nPftMpfZ+ODCOTeFFEHgK0A0m/kgqZqMwjOsZ8k/bRDZdTx8UwGC/PMyEOaNriZCA6tY=
Received: from BN9PR03CA0933.namprd03.prod.outlook.com (2603:10b6:408:108::8)
 by CYYPR12MB8704.namprd12.prod.outlook.com (2603:10b6:930:c2::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Tue, 16 Jul
 2024 00:13:52 +0000
Received: from BN3PEPF0000B072.namprd04.prod.outlook.com
 (2603:10b6:408:108:cafe::ef) by BN9PR03CA0933.outlook.office365.com
 (2603:10b6:408:108::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.28 via Frontend
 Transport; Tue, 16 Jul 2024 00:13:51 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN3PEPF0000B072.mail.protection.outlook.com (10.167.243.117) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7784.11 via Frontend Transport; Tue, 16 Jul 2024 00:13:51 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Mon, 15 Jul
 2024 19:13:50 -0500
Date: Mon, 15 Jul 2024 17:32:43 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, <seanjc@google.com>
Subject: Re: [PATCH 02/12] KVM: guest_memfd: delay folio_mark_uptodate()
 until after successful preparation
Message-ID: <udv7injfppiz2zyvo2ta2dvit3tczyfis7kbbumhgxhdfjtslp@xbexiz6iqevt>
References: <20240711222755.57476-1-pbonzini@redhat.com>
 <20240711222755.57476-3-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240711222755.57476-3-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN3PEPF0000B072:EE_|CYYPR12MB8704:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b135d85-58ce-4997-2d6f-08dca52c2c1b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|82310400026|1800799024|36860700013;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?zvOYrgbdi+nWsjlf0fyuNhRvJmO3GZakNpJzC6y45fLBztMYc6ReYGWCYvRx?=
 =?us-ascii?Q?E5zFRgpuo0DeEpDtRb1Txibpu7aPDrSxmlRYATPl9+NdR8jZuoQSvOZiPxHj?=
 =?us-ascii?Q?5t4yvZLFtoig1hahgp7NfKUsB2XIBew7CFZbDnhqf1t6vhACg731LI++HRt8?=
 =?us-ascii?Q?5UemWTHIwu4qfL8BcBrD1/HQAnzVDnrFjVShNbHcKAo6H83L/R+a8CMCrPWA?=
 =?us-ascii?Q?ah6cOjzrRkocXRMzvOYAODLEgVA0QXxpcj9sDyT8rneAIOrJtSwMVLKus9O3?=
 =?us-ascii?Q?cSJ8YF6K+HDTW/2cezzBb7LbdLs4uxUaFS6MA2C9qBwsXwAlitpcCgw27A4F?=
 =?us-ascii?Q?iUy2Kl7jlYk2NpM0rU6OxKL4hpjaLIZU2B9Y3TcFeYlU2Br/LKRBnUKfyWg7?=
 =?us-ascii?Q?bSrmHRKrdFe6XpgOAC+q0PWW+C28N18NgkiNt1nObJTr5fd2GxQJrYAFjA3g?=
 =?us-ascii?Q?m/GuWLp10MXckJHvb04HKLBBRtkkjv7Q33gR5bREmIDaWcaYmCefYsZ2hg6h?=
 =?us-ascii?Q?ci5biU/pXaMl4jWqGoh9AMXCPwEvkdsvtrxnqoDjFFCnKmLfrbTXvnHeM0Ix?=
 =?us-ascii?Q?7jY6Y96HO5FWodL9GMRb5RNUYF2O3Qruoj2Nb5FICiYcqP7EX9xqXaUYPVFL?=
 =?us-ascii?Q?xwP8ksFwBSMHQltFnh99tTJJzDqVaaPczr/GyLD9pnvBoxsoJfKw62mWWDn2?=
 =?us-ascii?Q?Bt94SPTzMbDhL5yur1HHifU/ksDjm8Jt35umJf7Oa8V2tMOxJpkA5HHWAkBU?=
 =?us-ascii?Q?TNm9F7aFC37izwCuib2r5bq4atIUaWoOrwhd7hQsNb3HW0mwjp0sH+Q7j+k8?=
 =?us-ascii?Q?rzsG53zc5wAS7tCayv50TngBThOiEVzL6QFdyiKhJFIW64vwWUjSGRFABsW3?=
 =?us-ascii?Q?zMEDpf4lo29+V92UReEMI8wh2WjyLd0n2aP1f2P9MdB2N1w2PKEvjIVXsXYT?=
 =?us-ascii?Q?PYYFIIha2lR2VS6vG8h7QJ/tcQL3ps7Axa7ZY6VfVVsI+eskcXLqov3462pJ?=
 =?us-ascii?Q?qnqXAYvAhjdAVNOD0bGNX/AneeKDQe3GVpq+qEWKsXxTZzmrxWmn1JVrA0Ur?=
 =?us-ascii?Q?xWX26nhtAWh6IuHlGl3xmABlYV+mVK/hwLf+YhxfDEwndE5sKbYgs+3kLgtI?=
 =?us-ascii?Q?TUrBgYszRnNudbGP5jRJUUbergsBPjMW5hnWbOZcEMdysZAKUAC9VXXLu0n8?=
 =?us-ascii?Q?5AOfblxL/EIWPGymclZ6HEEZcKOpxwJDjuqAmbDK2D92wnz2vqhxcr2zFMge?=
 =?us-ascii?Q?u51+jUL0uEAQR8tJMK13t8H/YPZhuBgdkPmChWbCf0d8l2nEzA8xtzaicKbs?=
 =?us-ascii?Q?wxHPzTDXuHYMU2uLhNOmNH90EtkmrNKiFfSVDazFzhAx06uwOcUMmSugkHIN?=
 =?us-ascii?Q?luKLebD77lCan7c7ilU0fPTWW8NjxSEhuomwtjbpKPNp8yI7jfK6Iq+/K8+2?=
 =?us-ascii?Q?lBWTj1waCc+RV0flLVO/S28x60DiL2TH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(376014)(82310400026)(1800799024)(36860700013);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2024 00:13:51.6109
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b135d85-58ce-4997-2d6f-08dca52c2c1b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN3PEPF0000B072.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR12MB8704

On Thu, Jul 11, 2024 at 06:27:45PM -0400, Paolo Bonzini wrote:
> The up-to-date flag as is now is not too useful; it tells guest_memfd not
> to overwrite the contents of a folio, but it doesn't say that the page
> is ready to be mapped into the guest.  For encrypted guests, mapping
> a private page requires that the "preparation" phase has succeeded,
> and at the same time the same page cannot be prepared twice.
> 
> So, ensure that folio_mark_uptodate() is only called on a prepared page.  If
> kvm_gmem_prepare_folio() or the post_populate callback fail, the folio
> will not be marked up-to-date; it's not a problem to call clear_highpage()
> again on such a page prior to the next preparation attempt.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

