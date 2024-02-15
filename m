Return-Path: <kvm+bounces-8772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B5BA856632
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 15:44:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5724283A0C
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 14:44:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC03B132481;
	Thu, 15 Feb 2024 14:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="mhpBtryY"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2077.outbound.protection.outlook.com [40.107.93.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532D613246B;
	Thu, 15 Feb 2024 14:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.77
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708008286; cv=fail; b=Cy5BTt+Jhs6l1O6HZ2VXuHmA69BzDkHuNuwkaVOerdaCLAwqKgmnjs5KfbaWSxJxbRIyenN8UgLnZ6IG2dHwnnpNuzgjqdKnXq8P3OGMZgIKPYQIiShWVLJSbb2ucnK+TyvWtsAHz/GBTTpjm8eM5Efk57D45Ka8imKEVQR5Eno=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708008286; c=relaxed/simple;
	bh=izLqfiA7ApahZ8v1vmn72CesjnX7mwtpl6vO52Clr2g=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P9sDxoHYo4K8vpQfEdSPVg0ZC8kZeQqmUqgaBVNU2cLC2cALWMPWLUQd6u6MUz8fRuVPs6y9uucPRtmPrWpxyIO2dT9uPOM7BTYP8RJK6MCbkGs8qqXKH/mBrSlkHEM2M5vBzNkWS7dhVbtFcCWT0vVUVMfVx6YONcI32bhuibU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=mhpBtryY; arc=fail smtp.client-ip=40.107.93.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QaSQOwUNKDNhGktlxfaWNKh39rQkuOkSvTvSa8ppAXqbHK5M1BSHMwdUUi4/8s+mE/3kWq326TpUrNEADbVJED1MvoYPUcZafnOvxKx7iO08IfykKw33YnSZCOCknuxihBa4N0f1MTWNrGa1Ax2BMl0rK9ZO/45jqVM85loYRGABkLXtd/d19Wp79WFj3WKRoJmgcWCd70YS2FYKud3wk9rNVaFmhR7rqPlQxlfdIY7PlMoZUJZFVji8NTzEWXUO4/U7zqh7byjC5te8MN3JP5QvCf0p1tbkIq3QrjxMPPLWUC3c26v453RK8irg+PJKUanp5osZlVkIzReHlo/hvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8rbrcwpbZs66Lfa4r/wrPyadOPRAk8wThy6DqmnniVY=;
 b=G6dnANiSkBJsk6GYXO02kbbaSwqjFxDY+offpIq23h3+pfFMDkYsYwMF+aHqZ2R0pfwLykmgUFUEis/VpOFZtSDHoAU7MWDU3/Hge65BYD8kyUmm2kujqeJe2TB1w/ixuoIL7JYe32FrJdhSAe2Xm3Ob82F90YPQ+WVe04YdOxayo7bbT1FcLIgItOK4SLx/rgSh59BYe5pqn/L3uRPwNXq+bPF+3TUaIvVpbfOuxDfB/3ya7qE+YcS8i4A7sfiXR7PqQDnc3lzhwyyavEzCgja/SzrhFtrndiIPviqHH4fHUjqIHFDZIgJPbcKXZYM2kjgYab1LL66/PRO54w+/gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rbrcwpbZs66Lfa4r/wrPyadOPRAk8wThy6DqmnniVY=;
 b=mhpBtryYHzMR/pB4yvpZxnFoPAzAPMEmoEW07NZAyAb+lpv5Cvp1H//us0BEJ6Lqt9lrl5wY7BSs1/6SJDCtnNzN2I1YP7UUt4Sul4ipAlSNas8OTMSPRm9OnN02IJ2Keu24ML0hQjOcesJBDGhe0+N08zJwKFPGEnzkchjp240=
Received: from BN9PR03CA0663.namprd03.prod.outlook.com (2603:10b6:408:10e::8)
 by CY8PR12MB7730.namprd12.prod.outlook.com (2603:10b6:930:85::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.25; Thu, 15 Feb
 2024 14:44:40 +0000
Received: from BN1PEPF00004682.namprd03.prod.outlook.com
 (2603:10b6:408:10e:cafe::55) by BN9PR03CA0663.outlook.office365.com
 (2603:10b6:408:10e::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Thu, 15 Feb 2024 14:44:40 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004682.mail.protection.outlook.com (10.167.243.88) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 14:44:40 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 08:44:39 -0600
Date: Thu, 15 Feb 2024 08:44:22 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>,
	<thomas.lendacky@amd.com>
Subject: Re: [PATCH 09/10] KVM: SEV: introduce KVM_SEV_INIT2 operation
Message-ID: <20240215144422.st2md65quv34d4tk@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-10-pbonzini@redhat.com>
 <20240215013415.bmlsmt7tmebmgtkh@amd.com>
 <ddabdb1f-9b33-4576-a47f-f19fe5ca6b7e@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ddabdb1f-9b33-4576-a47f-f19fe5ca6b7e@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004682:EE_|CY8PR12MB7730:EE_
X-MS-Office365-Filtering-Correlation-Id: d9e82e3c-ca80-4e27-0ab2-08dc2e34a3f4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	PUmCLJsc79Cug056jHERzyDSxBDuTXS58rl6JbomBB0Dx6tRiSNMtQOKOrHXSej9HYZXsT75CKxgmAPBuId0QEU4qhYsP/2NMpYgfpxsEPnBZQYhlNndXRSt17lsxI0CvVeb+TU+2TeKHwJPmw/iCLa//b0lR4M5xqknEU6sWwy+Oawfi9n+C0TbaYBtC6Nx5cF+SHCL8HHsLgF+BxtAB1eCYYxrp2wzQ2BIPyJR72JHbGCFoAVo6nSNrASXnpKN58HSlcG9mO8vlaCCtkjqMb2w4c65rKZP5Fp3jU5E6AMWGcAQLV3h+jjyKL0nG204SBP64ydlSf4khdOb7u4GuFTzTPHYj4Dj7WMC4xy8O6tOpP356+kcQcBTvyuSF7ujCMW9rICxNiDg793in3K4ALoNUBtHFzgo/DTid82Z0+mutwAvnUYPS13bt9L0hbOWJ9wRE6b7rvjD9flvCA2mYKqJzaA499NsTU3NCZlbsPyb2ugdeEbe/KhKfcjHPg4MFVzhPnkytHc2LjV94Chy9K9s0u28ZkZkhvQZLfHwjZBGCJbgPhYE9akv8w/0l/3XkQMl/uDecDpsNXBJ2XoBsTTBYwDXkNUnhhn0cdZ9WeBki5Ol31u8vSgkks7UlzsD0mSQB7kFSkg8KdsAYY52OYmxiLpxVmS+nwpZgkIZaEA=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(136003)(346002)(396003)(230273577357003)(230922051799003)(451199024)(64100799003)(1800799012)(186009)(82310400011)(36860700004)(40470700004)(46966006)(44832011)(2906002)(53546011)(2616005)(1076003)(6916009)(83380400001)(8936002)(26005)(4326008)(70206006)(336012)(16526019)(426003)(70586007)(8676002)(5660300002)(81166007)(478600001)(41300700001)(82740400003)(86362001)(356005)(6666004)(316002)(36756003)(54906003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 14:44:40.2218
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d9e82e3c-ca80-4e27-0ab2-08dc2e34a3f4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004682.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7730

On Thu, Feb 15, 2024 at 02:44:47PM +0100, Paolo Bonzini wrote:
> On 2/15/24 02:34, Michael Roth wrote:
> > > +        struct struct kvm_sev_init {
> > Missing the vm_type param here.
> 
> It can go away in the struct actually.  Also, "struct struct".
> 
> > > +If the ``KVM_X86_SEV_VMSA_FEATURES`` attribute does not exist, the hypervisor only
> > > +supports KVM_SEV_INIT and KVM_SEV_ES_INIT.  In that case the set of VMSA features is
> > > +undefined.
> > 
> > It's hard to imagine userspace implementation support for querying
> > KVM_X86_SEV_VMSA_FEATURES but still insisting on KVM_SEV_INIT.
> 
> ... except for backwards compatibility with old kernels.  For example, the
> VMM could first invoke HAS_DEVICE_ATTR, and then fall back to KVM_SEV_INIT
> after checking that the user did not explicitly request or forbid one or
> more VMSA features.

What I mean is that if userspace is modified for these checks, it's
reasonable to also inform them that only VMSA features present in
those older kernels (i.e. debug-swap) will be available via KVM_SEV_INIT,
and for anything else they will need to use KVM_SEV_INIT.

That way we can provide clear documentation on what to expect regarding
VMSA features for KVM_SEV_INIT and not have to have the "undefined"
wording: it'll never use anything other than debug-swap depending on the
module param setting.

> 
> > Maybe it
> > would be better to just lock in that VMSA_FEATURES at what is currently
> > supported: DEBUG_SWAP=on/off depending on the kvm_amd module param, and
> > then for all other features require opt-in via KVM_SEV_INIT2, and then
> > bake that into the documentation. That way way they could still reference
> > this documentation to properly calculate measurements for older/existing
> > VMM implementations.
> 
> Thinking more about it, I think all features including debug_swap should be
> disabled with the old SEV_INIT/SEV_ES_INIT.  Because the features need to
> match between the VMM and the measurement calculation, they need to be added
> explicitly on e.g. the QEMU command line.

That seems reasonable, but the main thing I was hoping to avoid was
another round of VMSA features changing out from underneath the covers
again. The module param setting is something we've needed to convey
internally/externally a good bit due to the fallout and making this
change would lead to another repeat. Not the end of the world but would
be nice to avoid if possible.

-Mike

> 
> Paolo
> 

