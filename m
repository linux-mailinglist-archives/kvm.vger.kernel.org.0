Return-Path: <kvm+bounces-8719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3320C8558A6
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 02:20:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6113EB2614E
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 01:20:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94AC91378;
	Thu, 15 Feb 2024 01:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="5YDzy3l5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACD6FEC7;
	Thu, 15 Feb 2024 01:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.92.58
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707960017; cv=fail; b=LZPqJ8zIZm1jpFhL54YRZesNh5ZD9IY1p2XqwlcbWoqXQjGiAqRDDr6olFrSY+cxOyITrBL2eH2vD3pj07N+PiXhavsVe/U8NYzvrYYhM1EhnZL3lD3cTV2uYoSWIyA014kaWeYwsRVlYVScaHcxbjc6ee9Hc+MnAX8S2sa+Z8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707960017; c=relaxed/simple;
	bh=alLSF8u/6wuDJod/Bf0sy6BQHnQlfJuKIGDmR7oVKwo=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RNnUmkhNxgb/4p1mTbREzQBjmxofsEAqirHVEYXaEwx//I5iQz9ex3IZSnHKbLYMLtdPHwaBW2p4L25OvDRhrjqqpicpmIpyqqdVIvY7QZqJ+j+BiSuCAMQhKOUlrnzTupHHuK/P+JUUo4jWc3P+KmGY3H1Zf/My4tPCn26Zw94=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=5YDzy3l5; arc=fail smtp.client-ip=40.107.92.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZbdJVqLUCu7Ab4MfeRiSyUHCGRhZ4sSxIQ42HDEc+KPJA7XVu6vdYJlh5Z8H0791CwtmiKSo1RhLo046mgHfM7vIGfZj9v54uZLlH0oOyIhA0olUhczQf1McJyS/4lmjRhx81OGp5E3pvo9igcaQUjI5MAdtRAEIvvNgn4gMX21+nVF8Lc0qBNTPUZVtVZg725gDwIhVY7NfsBZX/Wqbm0QjDi0I0Clr2i2CQgPUnzzCrcnJPueN7xZSBNjIhIthm8PEFVxdCeWMOoDIdZeA+AyQEWqGpdcnmMTOgNhTAbrJBcPLsMrirQsyYsUcXy5JiBK5lSHO+KhNqX8PJhI3LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xgKL/hXOOAZgcNkaNwZlop53mA2YCOO0SKALl4M78uM=;
 b=Q3UVZ8dyY/X4hsbP7njt6VVAQVdyDJz1vffGRL+9sF2x/uQ0awaAq6QXNi/cGKmQ+DFCBLNwCl+000VmNck849vSA20l/S92o9IZlXqngB3doM4WrYZ3cNcRy5DE21RDUXbGeXdLesuTF4cJAnSiuyz/s+D9YJ45kL0MvY/011/MucQCmY2uQGBtzO+mni1Bq2+ii2C6fOt7wdEZZps0MYJTNwUAe46C5Kz9mWM2RyS3uWqIGsQC4nD8BaXV6pmoW4lFYuSXIFUzXb3HCpYYhywrvB7/UvWz7j+vJDMgUqCUMcuU+eW5HgKi7/RrsxjGX7T1RXYBopiY1WoTmNELvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xgKL/hXOOAZgcNkaNwZlop53mA2YCOO0SKALl4M78uM=;
 b=5YDzy3l5dkShcRBAoSQoU5Z1dYBwcrR2Of3EYOW/NxKofIxuLRfQMq0qY/SKXDs8Z80+jpXKlW0oGPN/iOo9zdlvB1fr6yrQgM0dM4U3PF94EsIOHT5SP0W2nR0MXHKmdsmEVpLCCdFlYmcVyggiAn8H1eq1tkDWyyw6wgN7t4c=
Received: from CH2PR19CA0027.namprd19.prod.outlook.com (2603:10b6:610:4d::37)
 by DS7PR12MB5742.namprd12.prod.outlook.com (2603:10b6:8:71::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.27; Thu, 15 Feb
 2024 01:20:12 +0000
Received: from CH2PEPF000000A0.namprd02.prod.outlook.com
 (2603:10b6:610:4d:cafe::8) by CH2PR19CA0027.outlook.office365.com
 (2603:10b6:610:4d::37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7292.26 via Frontend
 Transport; Thu, 15 Feb 2024 01:20:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF000000A0.mail.protection.outlook.com (10.167.244.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7292.25 via Frontend Transport; Thu, 15 Feb 2024 01:20:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 14 Feb
 2024 19:20:11 -0600
Date: Wed, 14 Feb 2024 16:50:41 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <aik@amd.com>, <isaku.yamahata@intel.com>
Subject: Re: [PATCH 01/10] KVM: SEV: fix compat ABI for KVM_MEMORY_ENCRYPT_OP
Message-ID: <20240214225041.lmlgchx76eapcx2o@amd.com>
References: <20240209183743.22030-1-pbonzini@redhat.com>
 <20240209183743.22030-2-pbonzini@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240209183743.22030-2-pbonzini@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF000000A0:EE_|DS7PR12MB5742:EE_
X-MS-Office365-Filtering-Correlation-Id: fbea498f-351d-4392-0628-08dc2dc441f6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	eedbkjyBTSQwz/RQiCLPjCXYk+i5o4fFsCsQ4y7oFiNi6dwUe3ci7rnG7sDKKCBLy/J768imA/I64Or3u6swKcJ2dsJUluk88pngtIKAKpWFUw2+KaYLfY+siNoqJWtb4+DY/+fbDu6V7vH76+TrI6KHJHmCXXaYQguiImHc+pCNTw6WBFt8fHUh99iMEf6JNgy6TYoCAM6qio/Yy8hBkufXw1zN7X8Qxf1/MZML3ptDFhHjr4Dn+87sqLy1KBvYEL1uT8mehPkycWkes6VdwWQ2Qw9mk78UIeUQykc8gATY7JurhTHzxXkvR3odnm1e6SmLT0I4zBaN8s8HOHzHMq8y5JwVJaIEaKeMcg3P1wO0+elWTCuDjSp/VdyDflanqmmjtEvykAvLnzCHgDtiNPSbF9VdXVPlI2z9lFt8A+i/FuHf8GDP/bY8T0izqgbdZFYE+JNEJdYSqLHaM2Vs3UNo3WnCJdNf/ilQPYUdtVrgpcSqREXoPTC6g+kHNZW8BI3ReDsbltOf1opAcWamdx2kDAsj5MOeSJe1BTU8aRkdeDiTGL2Ofk/zT9wdFOIxljv0hTmMPpNiNU+yMiGaB8Zty07Lh6CLwKSSN1M4yz9h0Y+c4UxFovWbnzZo3yHBPL0aEiV5HvUT1Tn9Qj6j24JGzpTtpG9CRvK1xz0WA6g=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(136003)(376002)(346002)(396003)(39860400002)(230922051799003)(82310400011)(64100799003)(451199024)(1800799012)(186009)(36860700004)(46966006)(40470700004)(336012)(83380400001)(86362001)(316002)(2616005)(70586007)(6916009)(6666004)(82740400003)(478600001)(44832011)(5660300002)(426003)(54906003)(81166007)(2906002)(70206006)(1076003)(26005)(8676002)(4326008)(16526019)(8936002)(36756003)(356005)(41300700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 01:20:12.2625
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fbea498f-351d-4392-0628-08dc2dc441f6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF000000A0.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5742

On Fri, Feb 09, 2024 at 01:37:33PM -0500, Paolo Bonzini wrote:
> The data structs for KVM_MEMORY_ENCRYPT_OP have different sizes for 32- and 64-bit
> kernels, but they do not make any attempt to convert from one ABI to the other.
> Fix this by adding the appropriate padding.
> 
> No functional change intended for 64-bit userspace.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Reviewed-by: Michael Roth <michael.roth@amd.com>

> ---
>  arch/x86/include/uapi/asm/kvm.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 0ad6bda1fc39..b305daff056e 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -687,6 +687,7 @@ enum sev_cmd_id {
>  
>  struct kvm_sev_cmd {
>  	__u32 id;
> +	__u32 pad0;
>  	__u64 data;
>  	__u32 error;
>  	__u32 sev_fd;
> @@ -697,28 +698,35 @@ struct kvm_sev_launch_start {
>  	__u32 policy;
>  	__u64 dh_uaddr;
>  	__u32 dh_len;
> +	__u32 pad0;
>  	__u64 session_uaddr;
>  	__u32 session_len;
> +	__u32 pad1;
>  };
>  
>  struct kvm_sev_launch_update_data {
>  	__u64 uaddr;
>  	__u32 len;
> +	__u32 pad0;
>  };
>  
>  
>  struct kvm_sev_launch_secret {
>  	__u64 hdr_uaddr;
>  	__u32 hdr_len;
> +	__u32 pad0;
>  	__u64 guest_uaddr;
>  	__u32 guest_len;
> +	__u32 pad1;
>  	__u64 trans_uaddr;
>  	__u32 trans_len;
> +	__u32 pad2;
>  };
>  
>  struct kvm_sev_launch_measure {
>  	__u64 uaddr;
>  	__u32 len;
> +	__u32 pad0;
>  };
>  
>  struct kvm_sev_guest_status {
> @@ -731,33 +739,43 @@ struct kvm_sev_dbg {
>  	__u64 src_uaddr;
>  	__u64 dst_uaddr;
>  	__u32 len;
> +	__u32 pad0;
>  };
>  
>  struct kvm_sev_attestation_report {
>  	__u8 mnonce[16];
>  	__u64 uaddr;
>  	__u32 len;
> +	__u32 pad0;
>  };
>  
>  struct kvm_sev_send_start {
>  	__u32 policy;
> +	__u32 pad0;
>  	__u64 pdh_cert_uaddr;
>  	__u32 pdh_cert_len;
> +	__u32 pad1;
>  	__u64 plat_certs_uaddr;
>  	__u32 plat_certs_len;
> +	__u32 pad2;
>  	__u64 amd_certs_uaddr;
>  	__u32 amd_certs_len;
> +	__u32 pad3;
>  	__u64 session_uaddr;
>  	__u32 session_len;
> +	__u32 pad4;
>  };
>  
>  struct kvm_sev_send_update_data {
>  	__u64 hdr_uaddr;
>  	__u32 hdr_len;
> +	__u32 pad0;
>  	__u64 guest_uaddr;
>  	__u32 guest_len;
> +	__u32 pad1;
>  	__u64 trans_uaddr;
>  	__u32 trans_len;
> +	__u32 pad2;
>  };
>  
>  struct kvm_sev_receive_start {
> @@ -765,17 +783,22 @@ struct kvm_sev_receive_start {
>  	__u32 policy;
>  	__u64 pdh_uaddr;
>  	__u32 pdh_len;
> +	__u32 pad0;
>  	__u64 session_uaddr;
>  	__u32 session_len;
> +	__u32 pad1;
>  };
>  
>  struct kvm_sev_receive_update_data {
>  	__u64 hdr_uaddr;
>  	__u32 hdr_len;
> +	__u32 pad0;
>  	__u64 guest_uaddr;
>  	__u32 guest_len;
> +	__u32 pad1;
>  	__u64 trans_uaddr;
>  	__u32 trans_len;
> +	__u32 pad2;
>  };
>  
>  #define KVM_X2APIC_API_USE_32BIT_IDS            (1ULL << 0)
> -- 
> 2.39.0
> 
> 

