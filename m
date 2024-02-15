Return-Path: <kvm+bounces-8810-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18A41856BAB
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 18:55:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BA3431F217BA
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:55:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7A41138497;
	Thu, 15 Feb 2024 17:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Llt8JoIT"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E151369AC;
	Thu, 15 Feb 2024 17:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708019718; cv=fail; b=sMdlnfT0Qos0i+vncKVb97c1F2lNDrm6fA2haPjhfRUVEuLn51y34VL7V6cPs23xoIlt6PC7kgl4BZVeFdycz1BcTytOK1zFYoyHrNbok/EpafNrJ1hGafvKvF/KobWOevbSPBtk0FnR1db+aisOXzr/1qWxiSaHFlkSDgfNU00=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708019718; c=relaxed/simple;
	bh=vuDi+Gi8HQfXYzLgx6B/Eo2Yma+EDSHJ5mUwPWzVw0k=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvTqi03TiG+vyjq32QTFQjyhop+PFwvXeKK+joYp5c+/kSkEu5QwHn+NJVVm5glQXGS8KrzmrkEbSWZ24SHsH/OMQjC6s0UmvLIQ6ryfXYFBJ+Jn5wt+52gUdD6GHiWdeNSA6nwfGFfPutC0aho4Md+VhW771etcZvVX6EIcvo8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Llt8JoIT; arc=fail smtp.client-ip=40.107.223.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=la3CZNaNl9xVGvMNLytpau6ZIbyHkQGUNSk5q4EuJuybbwb+sFIQXn1h0CRw5QtO/eTLsNkHYeVQzmn6mgCcg+6m8rZdy/FFG9LVOKjypwF+6SFer4+r19yHDUPyWaFQUWC3kEw1PsO5ihAFM9RJKjM7RXMyd3Tnu4RJW1Egg4JZI7ESJcANTR5FxwCVBzPx8BLPHE+e0Ixscbpr1thR4F92eFTMoh+/gJxRToR2mwF/Mtt3xuI/Q6efcwDnV9a7MAYCA2dt0uvmxeiztHyXhFKkz4VAn7S4OKbmnhgradCGpwkGtKVKisJKpFNSvkojRiMoM49q4eJd0+jHenQnNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qwhB/KzKzje75xeExOV7KpioCmnw5fXARW4w3Y2o7Y4=;
 b=nGfSM65rEWW6C8vemG0KoEAMYRr93fXXvIq3cMXQaJNag2zDeJsXmOR/MP3GohG6IhWXhEucrQdTOrjV4po2+be9UtcYF/NwqvACG0zzNnPCvKaNF1Ht59qUyfOUx+beoWHYxFGGGdySn0JLSJ3xADGdneUoD9Bo++Lnr+Zu+atg9f1qe5hLDWTx955PBiEJEiJ+ZcfFYaWsVa/m77HIQJouLv97/BYVozwp7X5Mj0c2V96FAkvPmgBekPPkzQKBfNqm1+wpntDDfV+tCL4iC69LPHOgTM380yHNuhzwTkoEIJM3qKVg6nkXXvd6bDSSyBJVOfr41mELUujdWYni3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qwhB/KzKzje75xeExOV7KpioCmnw5fXARW4w3Y2o7Y4=;
 b=Llt8JoIT8AASTlWg/kxuh1w8ld9uhN8wBiTKH1HVYR3LlHhiOaDC83ZonOkXobicgoECkPtPXQcEGERiRaTLREbKBFmh9Q1qCH6R7nTKyvEM7b3CNyxJW4uzQZpmhkoP+GIrHU0EHKJxQ7/g+kXWnvh3Uv/3Tzqr/h3rbip8C4M=
Received: from CY5PR20CA0027.namprd20.prod.outlook.com (2603:10b6:930:3::21)
 by BY5PR12MB4067.namprd12.prod.outlook.com (2603:10b6:a03:212::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.29; Thu, 15 Feb
 2024 17:55:13 +0000
Received: from CY4PEPF0000EE34.namprd05.prod.outlook.com
 (2603:10b6:930:3:cafe::cf) by CY5PR20CA0027.outlook.office365.com
 (2603:10b6:930:3::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Thu, 15 Feb 2024 17:55:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE34.mail.protection.outlook.com (10.167.242.40) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 17:55:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 15 Feb
 2024 11:55:12 -0600
Date: Thu, 15 Feb 2024 11:54:56 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>,
	<thomas.lendacky@amd.com>
Subject: Re: [PATCH 09/10] KVM: SEV: introduce KVM_SEV_INIT2 operation
Message-ID: <20240215175456.yg3rck76t2k77ttg@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-10-pbonzini@redhat.com>
 <20240215013415.bmlsmt7tmebmgtkh@amd.com>
 <ddabdb1f-9b33-4576-a47f-f19fe5ca6b7e@redhat.com>
 <20240215144422.st2md65quv34d4tk@amd.com>
 <CABgObfb1YSa0KrxsFJmCoCSEDZ7OGgSyDuCpn1Bpo__My-ZxAg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfb1YSa0KrxsFJmCoCSEDZ7OGgSyDuCpn1Bpo__My-ZxAg@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE34:EE_|BY5PR12MB4067:EE_
X-MS-Office365-Filtering-Correlation-Id: af432c91-c438-4350-e05d-08dc2e4f4253
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Ep2/RK9YrVexWHfeNcK/zJ7vMKkYu89SCy6zDwy8+h/LYcmAEVDJSzgtosjme8XLRW4Z4bR3LtktqhylX1sd+YRU3Cz5iPm6XRS44q81iNLzps0SYRbOH108/wiTtn3gDzLW8C7KE9ltkma5SoUJXcvX8M+OCvMEJRLACw53KnpU3f/CPAkVs6oCj7dz9aeVN6hHj/R9PN/CfyCzkvJQRoTDAby9NJDGU/UkQcMrGmvDWEuz7AqAMd/4RFyeNZzsPzl7TIC556JQa1vZeW2nwGyKGQjbft/w5DMwY66CeDoc5f8e5I4oK9/jOX44f4gzyLAqVwNhCjHKCix/uRJpVTxG4YItOf/9Y9EBnAgre1bRBiXH7yYkt62yrocMdHbxmh3QITt/Z8tPW3YdkNdNjb248Ep9dGmevdTKD+NXOq62PyXxNvumrvxC/o5RQDMk2qeIZInXwehFRd4Z+iX9hnf1ljoKlRvvleHy3IeXj1mKmDeLqzzE1TAjf+1urD194DC/Bq2I0n2Rv8qrJmmB1Iyd4OGeKezBThhWGBeMPtZEugbtqz4E012EERm7mMTymkb2EbL8hYlEf1HMf/8BB8oDnwEyIK+9Jw3wDl3RGi64JUHjkO62X/wzPjgxkBOvLkfgHYPT80b4PbYMV4W+SNFZiAI0otSv5LEnj9eZfcQ=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(346002)(376002)(39860400002)(396003)(136003)(230273577357003)(230922051799003)(64100799003)(451199024)(36860700004)(186009)(82310400011)(1800799012)(46966006)(40470700004)(36756003)(8936002)(8676002)(16526019)(4326008)(356005)(26005)(41300700001)(426003)(83380400001)(2906002)(86362001)(336012)(81166007)(44832011)(5660300002)(1076003)(2616005)(70586007)(316002)(70206006)(6666004)(6916009)(478600001)(54906003)(53546011)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 17:55:12.8761
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: af432c91-c438-4350-e05d-08dc2e4f4253
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE34.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4067

On Thu, Feb 15, 2024 at 06:28:18PM +0100, Paolo Bonzini wrote:
> On Thu, Feb 15, 2024 at 3:44 PM Michael Roth <michael.roth@amd.com> wrote:
> > What I mean is that if userspace is modified for these checks, it's
> > reasonable to also inform them that only VMSA features present in
> > those older kernels (i.e. debug-swap) will be available via KVM_SEV_INIT,
> > and for anything else they will need to use KVM_SEV_INIT.
> >
> > That way we can provide clear documentation on what to expect regarding
> > VMSA features for KVM_SEV_INIT and not have to have the "undefined"
> > wording: it'll never use anything other than debug-swap depending on the
> > module param setting.
> 
> Ah, I agree.
> 
> > That seems reasonable, but the main thing I was hoping to avoid was
> > another round of VMSA features changing out from underneath the covers
> > again. The module param setting is something we've needed to convey
> > internally/externally a good bit due to the fallout and making this
> > change would lead to another repeat. Not the end of the world but would
> > be nice to avoid if possible.
> 
> The fallout was caused by old kernels not supporting debug-swap and
> now by failing measurements. As far as I know there is no downside of
> leaving it disabled by default, and it will fix booting old guest
> kernels.

Yah, agreed on older guest kernels, but it's the measurement side of things
where we'd expect some additional fallout. The guidance was essentially that
if you run a newer host kernel with debug-swap support, you need either need
to:

  a) update your measurements to account for the additional VMSA feature
  b) disable debug-swap param to maintain previous behavior/measurement

So those who'd taken approach a) would see another unexpected measurement
change when they eventually update to a newer kernel.

-Mike

> 
> Paolo
> 

