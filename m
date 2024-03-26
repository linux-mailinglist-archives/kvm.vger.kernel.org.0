Return-Path: <kvm+bounces-12700-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B3E188C43A
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 14:59:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6792DB22CF3
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 13:59:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5C9F535AB;
	Tue, 26 Mar 2024 13:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bm8uchuw"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0755D73B
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711461551; cv=fail; b=dBvZdRJUisszwDl+WyoITF+1NuEVAHnCLzo5CJOnBq0yFr/AJJrIi7uR0P8FaVZdzB8X5k5LjegY8AmaMMPAGWQlRuoKYASveVJu/3IPIc0xbcD5DJxqP0HsVWu9zld8U23k+8v2Pn5yH/PMshzhP/a0ixzz0/XsBEE4IIqLK9k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711461551; c=relaxed/simple;
	bh=NuUdvLVAgCPfD5SEupc2DUjvaqLmfMfEo9GvzHk9PPs=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDN8ylzc3ieMFrUp8/zSmxczim201t0eHHUPaSyTZP+oSYQq1qgZiSwQhB2QITH/NLDYa2zbwe/a6D/P0MQowG1qAB3Z/haKBFvzR3HliT5YADQuCA5t1MyI1LXSMMtnbvvqQV0MQSXyALku9XNME1s/Gx2cXhfafMBFpneEfNc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bm8uchuw; arc=fail smtp.client-ip=40.107.94.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4FgY99SjoouPCPuhRb+1PbMDB9pIJQIl11SLdOLBlvFk97MyzpraBPAGPirYMRkmM5Mjag2pv0CXTO5jIomj2RWKwnSxL+CumVWeRqeEJiip30/5WTGAzVLZD95ajFsNBbyONzVL2hK+7ZjGRPBiXu/tddLHKhYmcgs4JHG7Z0si86XlTpsXnfb0C498lmEFpFREMV7alLkyfbhPyFU3efKnjDPLHK1p929SfbLFOoW5vwcv0cmubBRAqmfksRPE0YmQNLU0P0Cmds/uuQ7csJbMN51LVgsM62Qu0oEYUOO07d59/ZFy4RSL72Y1LDbcd90Kos4SwNO4Boae7wvHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dxoV5rOiUT/kJ6EHu1ajAcpHRucwtym0ENP7E5rye5I=;
 b=Lxfa8O+tvICgx+yy4gh0VPl0GUx6c2vSi/PAmwiE516Hr+NirRolzR/0P9w/nfWq/pshqzr67qD9a3gGA/w2iU54F970PXeZs4Xanv+FUAHn3AjFz6s2WWvIGOO5ecOLwlbrKrDA6XwyttMZn5FEA3MWBlJa81lDZ3em7/4UELr2bYf/JUHqN0Pmpwk/oRqtbBWCm/UdmBUvgnEOE9C5fiKyzi/xvQmp7ofPDqZaXEAMQkMWkYYX4yY0jqjpaPBDEnH7fhFNjV2xjgHbXc/bsUsKu4VUzih0Ns5RC7pULw820Ne0YxMnSvgxW5RuiGXr2mRsxOA2rkbk0pEhArQHow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dxoV5rOiUT/kJ6EHu1ajAcpHRucwtym0ENP7E5rye5I=;
 b=bm8uchuw6B/zOmocP2WHStjESzXzPMNZblHyBQ9ObzHrpBdUSKDvmgDvjG9TPVuo4c10X1YJj3jogiSc2HNUlMAm5jGg0GfEo/BeQBiM2c1YocEh2Q5CS/rfsnk+GuJqtk7/pUJMFiIMeFytgyO4+VLXQ95jlP/mERFupp+L9B0=
Received: from DS7PR03CA0312.namprd03.prod.outlook.com (2603:10b6:8:2b::21) by
 DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7409.33; Tue, 26 Mar 2024 13:59:04 +0000
Received: from DS1PEPF00017092.namprd03.prod.outlook.com
 (2603:10b6:8:2b:cafe::8e) by DS7PR03CA0312.outlook.office365.com
 (2603:10b6:8:2b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Tue, 26 Mar 2024 13:59:04 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017092.mail.protection.outlook.com (10.167.17.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 26 Mar 2024 13:59:04 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 26 Mar
 2024 08:59:04 -0500
Date: Tue, 26 Mar 2024 08:58:26 -0500
From: Michael Roth <michael.roth@amd.com>
To: "Paluri, PavanKumar" <papaluri@amd.com>
CC: <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <andrew.jones@linux.dev>,
	<nikos.nikoleris@arm.com>, <thomas.lendacky@amd.com>, <amit.shah@amd.com>
Subject: Re: [kvm-unit-tests RFC PATCH 2/3] x86/efi: Retry call to efi exit
 boot services
Message-ID: <20240326135826.yjqxnijdoynaw2xw@amd.com>
References: <20240325213623.747590-1-papaluri@amd.com>
 <20240325213623.747590-2-papaluri@amd.com>
 <20240326133801.p4eqegjor54mn3h5@amd.com>
 <4c2c7598-2c07-0cd6-620c-1a603bcb1f0f@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4c2c7598-2c07-0cd6-620c-1a603bcb1f0f@amd.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017092:EE_|DS7PR12MB6008:EE_
X-MS-Office365-Filtering-Correlation-Id: dda3f352-6e29-4e0e-bd78-08dc4d9ce5fe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	pO+brOYBpMvhtuHSKNWJREsYRvs5+hrleDYyA0Y/O479sGX6qTIywEl2A3qxOt9KO/42SNTu8j5MicXok6jqBtx+5oXojJ2w/k9Jhm8zCEdL93MDnzaGt4fE+WHh1Fow1G7ojCIqp5ZiBWDNv/a94pnPoZ72JQ49t977gyx0gQ6RqeuxKF6u6GWs/k05wgw5JLV9DHtAbAfUWV7yrcIguyNx8Jn+w0zYWYP19iKd05PN+7uPMwHEG9vqFovEIRdaXlE2rIbw5jYc/QQlE6BnZtPeNn6VwJqhfv1ho3WPWtASfBynt85lK5vjzDERIb89AJF7q3x4EfRu1uiHzJvjsgV6aYlBt9qswcuXwRTDKK3PXIruSGZ4OdCvmZih9+pD8o/q9M5sn9BqZ4OTUpvsnaDRPgN7HRcSwqkzpufSJqWyVT4VHLFTqbtq87GtOjE4cni0LvK8xwea/4+URHGYc6htu/dyILdd7AAwrq6v8PA2bZt5UzXWwGfLUsqRAMiQLB+SaMfhYbhXteNrypSkBMXJ4IeVgThYMfdjhsTeIrX/1x+5wP5SdA4kyhLelzmQGApDq7DpuO7oCZXT+ZFzVshdWu2sCluxXcTSaRSrxfwwgGi87Sn3DPMPWNwOb3PTqQj9AJtdiZjevLtAMzgIBZzQMvOazBBBbSESMWu/bX7m6hbxQlafMZr1biSsjzGV/B+9LKKIPB3iWXDKNw+EjeahdyenIo3ExBoK8Lc0EGZJOGMbnXL2IPD/N6WdXEKX
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(36860700004)(82310400014)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:59:04.7900
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: dda3f352-6e29-4e0e-bd78-08dc4d9ce5fe
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017092.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6008

On Tue, Mar 26, 2024 at 08:45:53AM -0500, Paluri, PavanKumar wrote:
> Hi Mike,
> 
> On 3/26/2024 8:38 AM, Michael Roth wrote:
> > On Mon, Mar 25, 2024 at 04:36:22PM -0500, Pavan Kumar Paluri wrote:
> >> In some cases, KUT guest might fail to exit boot services due to a
> >> possible memory map update that might have taken place between
> >> efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
> >> spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
> >> to update the memory map and retry call to exit boot
> >> services.
> >>
> >> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> >> ---
> >>  lib/efi.c | 23 ++++++++++++++++++-----
> >>  1 file changed, 18 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/lib/efi.c b/lib/efi.c
> >> index 124e77685230..9d066bfad0b6 100644
> >> --- a/lib/efi.c
> >> +++ b/lib/efi.c
> >> @@ -458,14 +458,27 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
> >>  	}
> >>  #endif
> >>  
> >> -	/* 
> >> +	/*
> >>  	 * Exit EFI boot services, let kvm-unit-tests take full control of the
> >> -	 * guest
> >> +	 * guest.
> >>  	 */
> >>  	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> >> -	if (status != EFI_SUCCESS) {
> >> -		printf("Failed to exit boot services\n");
> >> -		goto efi_main_error;
> > 
> > With this change, error codes other than EFI_INVALID_PARAMETER are only
> > handled if the first failure is EFI_INVALID_PARAMETER. Need to to re-add
> > the previous handling for when the first EBS failure is something other
> > than EFI_INVALID_PARAMETER.
> > 
> But the status codes that could be returned from
> efi_exit_boot_services() are only EFI_INVALID_PARAMETER/EFI_SUCCESS [1].
> 
> [1] UEFI 2.10 Section 7.4.6.

New error codes can be added over time. Also, the block you added handles
!EFI_SUCCESS generally for the 2nd call, so for consistency it makes sense
to continue handling it similarly for the 1st call as well.

-Mike

> 
> Thanks,
> Pavan
> 
> > -Mike
> > 
> >> +
> >> +	/*
> >> +	 * There is a possibility that memory map might have changed
> >> +	 * between efi_get_memory_map() and efi_exit_boot_services in
> >> +	 * which case status is EFI_INVALID_PARAMETER. As per UEFI spec
> >> +	 * 2.10, we need to get the updated memory map and try again.
> >> +	 */
> >> +	if (status == EFI_INVALID_PARAMETER) {
> >> +		efi_get_memory_map(&efi_bootinfo.mem_map);
> >> +
> >> +		status = efi_exit_boot_services(handle,
> >> +						&efi_bootinfo.mem_map);
> >> +		if (status != EFI_SUCCESS) {
> >> +			printf("Failed to exit boot services\n");
> >> +			goto efi_main_error;
> >> +		}
> >>  	}
> >>  
> >>  	/* Set up arch-specific resources */
> >> -- 
> >> 2.34.1
> >>

