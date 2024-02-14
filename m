Return-Path: <kvm+bounces-8721-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D430F8558B2
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:21:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 49E4E1F21AD8
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92E2D79CD;
	Thu, 15 Feb 2024 01:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="lKSWunVI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2048.outbound.protection.outlook.com [40.107.94.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9ACD6FA9;
	Thu, 15 Feb 2024 01:21:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707960073; cv=fail; b=Zk6UZ44cO4Kr78FNcwBo09RV88Ayo4B2uSwf5r0ns3TQTGujnf01n+Kmq2C59/7QeTwoD8jVe/cXmMftY+P9j1k0Nre47WpxcYlxFMLgixnzy96xgtkgoMoueuCSTmZiZaJ/sJ2vn/2splck/pyan9D0BLxkIhcal69hZ61d2U0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707960073; c=relaxed/simple;
	bh=HTw7cpwIjRofsOwhMipUbZ45C6hYLyIsECHsDjRoZdk=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bg1o7cJahKhhSMV60cl8BPKRKOhpOjZXi89lsEWSNY5uN1jc8ByKps0KM79wHZJ/t9l8i44svg5bxnbYytwYPLSCNpDxp0kr57HxXRIqf5mZdmHjyqiiTaNIc8m/dQMEeXiEG4Ua41IUkT/JrdTjljWqUynsoMVnNliDXtXzI5A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=lKSWunVI; arc=fail smtp.client-ip=40.107.94.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwpKqdZ/LpfUrxRwfYBFIBm7ls2VPXnacaKxxq8uFAupGR0lFLkSzF/IRxeH+sMpCRuuii4EOpgbEARsycoQMyuzRLwHJfxsWa3+NI2WUh25gR7nFByXyuMWEjgfoLIaLkxVALSmXER/xtH7M45GenLNRpZQD0lUzfsF+OMg1jvGrAfIkBJHs2jGt5onHrlgy07UJLaqAC6rBUoNTFjM1zuhywwC3CRzkThHBFO3/+h+LDye2uHdqkzmsRKu5HZ1N4MEMQSjeMBxWM/TSfO9uyLNt3wo9syGOTIstuBcl5GFs08CdqMX0XbGadp9ZCjy/hCaPQZZUlbQHOxbvQNelA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DgSZcE9XI564hfCQhff4739QgwkSzO1yY6qHZuzYoh0=;
 b=LPzDTCVwIn6zQDW0dSSUPoFzaWnQwfjoa5fQ+UBS8k0WwetAeoe2eb+hfZnJANuW4iBWQD28ICOtOckPPNrGTonzCXEELQvX+Bi1uu7PN5YdXI0AuLjc5U1pQo5Z2KcI+zK6xoggPcuhl0/XyPP6cWSqv+TgeTpGjxkbwvzq0g2iQEytaV+NvuZ/9D9DDK+5r33UqOd15+q5lj1rwsa0iynL1T/wdU9fRYFmEL/YLX+QW1mSlsFHk1BwVddNpQ8dPQ2q5c/6SnixUz+4e1qsOA9Ze5z6gt8yXixuN0lmftR5gHBrTvlFr7iQ7jNSA+WluBVJ4Ur9nlclLEVjrzHMxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DgSZcE9XI564hfCQhff4739QgwkSzO1yY6qHZuzYoh0=;
 b=lKSWunVITTEbB77YnrwoC9DtB9Rf3CV9lWnjO7YxDYlNJjudEVxPBU2evG7AlF18gI1OomR7X6zvpoU9hT3XRsMPE6w52CaMTUEIzHDwJVsy1QTEAAQx1OgJtns5XlU2uU91LUA6XYuQB55DbDHJEnQJrLjQ7pcef6Uhulgy9b8=
Received: from CH2PR11CA0030.namprd11.prod.outlook.com (2603:10b6:610:54::40)
 by PH7PR12MB8826.namprd12.prod.outlook.com (2603:10b6:510:26a::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.24; Thu, 15 Feb
 2024 01:21:08 +0000
Received: from CH2PEPF00000099.namprd02.prod.outlook.com
 (2603:10b6:610:54:cafe::74) by CH2PR11CA0030.outlook.office365.com
 (2603:10b6:610:54::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.38 via Frontend
 Transport; Thu, 15 Feb 2024 01:21:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000099.mail.protection.outlook.com (10.167.244.20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 01:21:08 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 14 Feb
 2024 19:21:07 -0600
Date: Wed, 14 Feb 2024 17:23:10 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 03/10] Documentation: kvm/sev: separate description of
 firmware
Message-ID: <20240214232310.nawo4dljp2kaddrs@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-4-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240209183743.22030-4-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000099:EE_|PH7PR12MB8826:EE_
X-MS-Office365-Filtering-Correlation-Id: ee741c9a-2a75-4213-7779-08dc2dc4634d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	dHhK5rlenKpZlsQRftFmHniPyffrpmel8JWsP8DTzMHGPahGYrM4U1HJiVZgRcJyOOc/sNlcu/s2ea5BJcv4ejBorSCl9an1ETwcuyM5KDUNsvKhBqJ1U7G9DLAY8xG9urrhwOHdRH/qqG0Bi6kMeBZeVq1FFarDmS+aqgJZHz0A2asuVxxIk6FLxrIXxj+o9tBZBN2WcTiIxFxlyl1BaWE7fLpwjS5fbCgVm9oMqJzXVf+XRoxilRxx2K23R23tRWOhgQ8zfeYlR6kD1yDJtAC6hbEJqTIrJ7XBcrfkau74sLmVD4UVOyTo7h2EBIIMFqRlSw+wc8s//svKRwfLB/5sZsRAV60zVcF1avCUUV8TLCwF/VGZNzRC3dG32rLp0/N9hNc5IiOqcLMcXPcXZUQDjMalaTffpPq2xfbVz/4zhezw+IE4HhCDiOUCXAlVovWcwuc0TzzVRZIAqXXf8SOey/pPrvesUWTDVMgq56O63aAEB83I3ipQcabwURymZJmH701IH6hO+J0aZ4E9BV1q2buHZC84Njed1DCQVdjwTwj/mmZqxeZRn9tPujwbuMYWxIcpp90cjW5IQWrl+oxifjWjuGXzVYR8eGTDT2K3hdy7zn6RIsEPgy48ZM+MW1tr+q968H0E/WGv4wo4TIVzrcDHmOBUgM/qPemnbHY=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(136003)(396003)(39860400002)(230922051799003)(64100799003)(82310400011)(451199024)(186009)(1800799012)(36860700004)(46966006)(40470700004)(41300700001)(86362001)(16526019)(70206006)(83380400001)(5660300002)(6916009)(2616005)(316002)(6666004)(36756003)(26005)(478600001)(70586007)(2906002)(426003)(4326008)(336012)(8676002)(1076003)(44832011)(8936002)(54906003)(82740400003)(81166007)(356005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 01:21:08.1847
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ee741c9a-2a75-4213-7779-08dc2dc4634d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000099.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8826

On Fri, Feb 09, 2024 at 01:37:35PM -0500, Paolo Bonzini wrote:
> The description of firmware is included part under the "SEV Key Management"
> header, part under the KVM_SEV_INIT ioctl.  Put these two bits together and
> and rename "SEV Key Management" to what it actually is, namely a description
> of the KVM_MEMORY_ENCRYPT_OP API.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 29 +++++++++++--------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 995780088eb2..37c5c37f4f6e 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -46,14 +46,8 @@ SEV hardware uses ASIDs to associate a memory encryption key with a VM.
>  Hence, the ASID for the SEV-enabled guests must be from 1 to a maximum value
>  defined in the CPUID 0x8000001f[ecx] field.
>  
> -SEV Key Management
> -==================
> -
> -The SEV guest key management is handled by a separate processor called the AMD
> -Secure Processor (AMD-SP). Firmware running inside the AMD-SP provides a secure
> -key management interface to perform common hypervisor activities such as
> -encrypting bootstrap code, snapshot, migrating and debugging the guest. For more
> -information, see the SEV Key Management spec [api-spec]_
> +``KVM_MEMORY_ENCRYPT_OP`` API
> +=============================
>  
>  The main ioctl to access SEV is KVM_MEMORY_ENCRYPT_OP.  If the argument
>  to KVM_MEMORY_ENCRYPT_OP is NULL, the ioctl returns 0 if SEV is enabled
> @@ -87,10 +81,6 @@ guests, such as launching, running, snapshotting, migrating and decommissioning.
>  The KVM_SEV_INIT command is used by the hypervisor to initialize the SEV platform
>  context. In a typical workflow, this command should be the first command issued.
>  
> -The firmware can be initialized either by using its own non-volatile storage or
> -the OS can manage the NV storage for the firmware using the module parameter
> -``init_ex_path``. If the file specified by ``init_ex_path`` does not exist or
> -is invalid, the OS will create or override the file with output from PSP.
>  
>  Returns: 0 on success, -negative on error
>  
> @@ -434,6 +424,21 @@ issued by the hypervisor to make the guest ready for execution.
>  
>  Returns: 0 on success, -negative on error
>  
> +Firmware Management
> +===================
> +
> +The SEV guest key management is handled by a separate processor called the AMD
> +Secure Processor (AMD-SP). Firmware running inside the AMD-SP provides a secure
> +key management interface to perform common hypervisor activities such as
> +encrypting bootstrap code, snapshot, migrating and debugging the guest. For more
> +information, see the SEV Key Management spec [api-spec]_
> +
> +The AMD-SP firmware can be initialized either by using its own non-volatile
> +storage or the OS can manage the NV storage for the firmware using
> +parameter ``init_ex_path`` of the ``ccp`` module. If the file specified
> +by ``init_ex_path`` does not exist or is invalid, the OS will create or
> +override the file with PSP non-volatile storage.
> +
>  References
>  ==========
>  
> -- 
> 2.39.0
> 
> 
> 

