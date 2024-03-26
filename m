Return-Path: <kvm+bounces-12698-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C87688C395
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 14:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C74C62E4F3F
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 13:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3140174BFB;
	Tue, 26 Mar 2024 13:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="E86UjM0N"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2065.outbound.protection.outlook.com [40.107.94.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74C7D74437
	for <kvm@vger.kernel.org>; Tue, 26 Mar 2024 13:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711460306; cv=fail; b=qp+CDZtXh2qRNDuFUcREihrA5wbE2gDQR8YBZn2C4IrKnxh1ihJLrwh0t0VHd6I0DvZBDDkHhBl4gzegYtSYenVXI9Ft2f4/SfZL+CsL9pa3akQYGa3he9Uruj+MRqhFkbGelj5FThyPpQxqjWUbpRl6ZGfGKyCkn0iDs6+2OUU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711460306; c=relaxed/simple;
	bh=8WkJ0UPK9Fzv+56O3kWp+ENUGMvx664FTwubJpUpDrI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MBvTcprda8d9VVtgAfHHDkpNW8TgjwV4TUVUkAHxjPN8hG6y4RtxNqFGd/0vL41WLSjIYf8DjIG3qHzbEFwDUSnlCMRivZuswVNNWWbNToGvwibNxXolEnU1anT0GTB7nT93gJQySfjfDkB5UL3/ixQrPM3g6ps1qhtD/w/Ytv8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=E86UjM0N; arc=fail smtp.client-ip=40.107.94.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwyyxdZ9RRiCya16DLyS8/kc3EqQkHIKyBVWFYQXiBkYMCKblcC4Oh/bilJ98Xy99Qfxhog7hN1RHLyTTdF358sVfk9QHjim7dyEzrvC60XmiSlnL36iYoQqXKcv4R6rGwF/qrwwzOD28lR1IeEr/VrYXyJDadhr6y9EIodJy7YcVoh3eDbcfJvIeKoIz/0N2EdBxSmWfv9W6XMJLQTQGYz7/a2DQcV0tI/ztYlI6vBC0WgMNe4OV4oO1KyuzcyfgBdbvbvo8diI0wwlDKgDmad5QmmG4FRmdgOih+Ejj00s45KmObyLN0phvm7/Sa44GCmFaSdzVgHzwg3qYeOF2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BKrXazrXbSDiPIUIpfywRUT+WnjyvFoq+ufiMQ+ppcE=;
 b=KQh6ycDWT6D3ta3WA02/T4SPC8Q7dTVnBRwU5FeeZsKYGXjFNgRaJxv3udiFbxoSyCJcRsYaUmwFPp4oHpHjai7tMOhDTKIYoUeVZqT8NCyWltMvpHj9Al+00IR0bCj/iPuQSdrdmaKkv/9/pZwrhjfF29X4ZTeJIyqPXrT5/WvJhURteDUCa/tEudsmvSVlAee3F3fVxSMICU/KqvOetmTtnehrIBFDNSYX7t0gcZ8o5q376d0tVH8uEHsBJQkl4lXb8t6Y10LBHZw9qakWglnZZXeTjCvmUkRfuV66yD43e1OA1HD4SBjjaK14+bmHQLXOs6/S7JZMYOtJmTDSnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BKrXazrXbSDiPIUIpfywRUT+WnjyvFoq+ufiMQ+ppcE=;
 b=E86UjM0NPih3A6YiecIyK8bGsR3hhE1/L02xO5Mr5sqrIu+4Ki7PVQNDN4a0nh7SsXOLRTiC9On+1pYzM5hIow/Y9UaekdY0kDkOFBU3p+4i4Pxe9UQSjIAFjdfunNRhtE50s2+CzghgezaAicLImKzKILgUy4dOfXx0Ju1rG4U=
Received: from SA1P222CA0066.NAMP222.PROD.OUTLOOK.COM (2603:10b6:806:2c1::21)
 by IA1PR12MB6577.namprd12.prod.outlook.com (2603:10b6:208:3a3::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.31; Tue, 26 Mar
 2024 13:38:20 +0000
Received: from SA2PEPF00001506.namprd04.prod.outlook.com
 (2603:10b6:806:2c1:cafe::d4) by SA1P222CA0066.outlook.office365.com
 (2603:10b6:806:2c1::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.13 via Frontend
 Transport; Tue, 26 Mar 2024 13:38:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SA2PEPF00001506.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7409.10 via Frontend Transport; Tue, 26 Mar 2024 13:38:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 26 Mar
 2024 08:38:19 -0500
Date: Tue, 26 Mar 2024 08:38:01 -0500
From: Michael Roth <michael.roth@amd.com>
To: Pavan Kumar Paluri <papaluri@amd.com>
CC: <kvm@vger.kernel.org>, <pbonzini@redhat.com>, <andrew.jones@linux.dev>,
	<nikos.nikoleris@arm.com>, <thomas.lendacky@amd.com>, <amit.shah@amd.com>
Subject: Re: [kvm-unit-tests RFC PATCH 2/3] x86/efi: Retry call to efi exit
 boot services
Message-ID: <20240326133801.p4eqegjor54mn3h5@amd.com>
References: <20240325213623.747590-1-papaluri@amd.com>
 <20240325213623.747590-2-papaluri@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240325213623.747590-2-papaluri@amd.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00001506:EE_|IA1PR12MB6577:EE_
X-MS-Office365-Filtering-Correlation-Id: 92318105-d609-488f-a6cb-08dc4d9a0033
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	tgtBn73ci2Vbx2Ph9GxZXtHxV1EPIUAJJlHG6X4hiKbmuc6TidciPhyGgJjBTNXjSDrmgdUhK0nE3CMYCkaI3ESP+PuomB1JgI8TTw7d2tNmjWzX8yXf8iB//dEvlmNw2mJuDk2X8Ro6aiTxE4bI1lgagqBeuBJWkHKQ1ss8gkveUwg+ITp2Gh/21KmeSeSq+VeCjzqSYT2cKi8dOs3xYhnxL6h6PQhc7QEwjyB8hLHclRBqVDSbj7zDHXz7c+tK+x18IavCqYYUkHRcbcAy9f8yYPpOvChGXMunAiA+GMjBLbFt2p52Ek7IKKpnG9M+4SByeQ0BWIhUngPN6gqT9uiH9RBMpD9pCcUKwEizxhzrNa4Lex+TgLUSxA1Ue33Kegv06QWI7BYuXndsBMGQ/+dz9txyzFGKyYskdZYtIS5Ge8va21bjgmnKuE/6IOWfj+GxG8vxRso2cZ01ntOLIaoDh/85rSATa7vcsB6oPFlxjM4+w/svsRTsUUEn59g+Jhj3vW1fJTZun1Y+AoFmoa5l1xGUdUYKUj7OxfvFhDQp6tHBoS1k8NV/PH5v8ZAFgRCmdzl8Kk7W+zCQY/r098SNgEuy0eOSMtPjg+/wJ0qMaPzwcl86L5eZsBjefxrVOlGWTyloKs3c+E7WNuU6/Q+uE5zUvcRT3aPhuyG4xsvCtPc1QjSf2Khy3uNcnNdHN1IzuUBXcaIIeYyEcAKz8IDdsjsh1RiUWt6b5MB2j8w+Rh9fWECStFtzRkZROmTz
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(82310400014)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2024 13:38:20.2831
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92318105-d609-488f-a6cb-08dc4d9a0033
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00001506.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6577

On Mon, Mar 25, 2024 at 04:36:22PM -0500, Pavan Kumar Paluri wrote:
> In some cases, KUT guest might fail to exit boot services due to a
> possible memory map update that might have taken place between
> efi_get_memory_map() and efi_exit_boot_services() calls. As per UEFI
> spec 2.10 (Section 7.4.6 EFI_BOOT_SERVICES.ExitBootServices()), we need
> to update the memory map and retry call to exit boot
> services.
> 
> Signed-off-by: Pavan Kumar Paluri <papaluri@amd.com>
> ---
>  lib/efi.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/lib/efi.c b/lib/efi.c
> index 124e77685230..9d066bfad0b6 100644
> --- a/lib/efi.c
> +++ b/lib/efi.c
> @@ -458,14 +458,27 @@ efi_status_t efi_main(efi_handle_t handle, efi_system_table_t *sys_tab)
>  	}
>  #endif
>  
> -	/* 
> +	/*
>  	 * Exit EFI boot services, let kvm-unit-tests take full control of the
> -	 * guest
> +	 * guest.
>  	 */
>  	status = efi_exit_boot_services(handle, &efi_bootinfo.mem_map);
> -	if (status != EFI_SUCCESS) {
> -		printf("Failed to exit boot services\n");
> -		goto efi_main_error;

With this change, error codes other than EFI_INVALID_PARAMETER are only
handled if the first failure is EFI_INVALID_PARAMETER. Need to to re-add
the previous handling for when the first EBS failure is something other
than EFI_INVALID_PARAMETER.

-Mike

> +
> +	/*
> +	 * There is a possibility that memory map might have changed
> +	 * between efi_get_memory_map() and efi_exit_boot_services in
> +	 * which case status is EFI_INVALID_PARAMETER. As per UEFI spec
> +	 * 2.10, we need to get the updated memory map and try again.
> +	 */
> +	if (status == EFI_INVALID_PARAMETER) {
> +		efi_get_memory_map(&efi_bootinfo.mem_map);
> +
> +		status = efi_exit_boot_services(handle,
> +						&efi_bootinfo.mem_map);
> +		if (status != EFI_SUCCESS) {
> +			printf("Failed to exit boot services\n");
> +			goto efi_main_error;
> +		}
>  	}
>  
>  	/* Set up arch-specific resources */
> -- 
> 2.34.1
> 

