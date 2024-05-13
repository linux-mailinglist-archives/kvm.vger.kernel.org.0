Return-Path: <kvm+bounces-17338-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B2A88C45AA
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 19:06:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D3501C21865
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 17:06:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20CBC22339;
	Mon, 13 May 2024 17:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yvlxsQW6"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2080.outbound.protection.outlook.com [40.107.223.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B3F1CD06;
	Mon, 13 May 2024 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.80
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715619995; cv=fail; b=rcL/8dyRtEpyiXrTrSvkBtX+zCWwwjWyxAXbZOvf5hvzKb+OPaisL8nCcyqxxMW5Dw1Z80U7iz2QpyZIq/kUYQ514LvDHQ7jvWdk8JroDYfaK10J0d0dYKfC4eb/u2P0gu7PlVHHL/iMDoadhrZjnrDGpNI2ZgvT+QBp5CGtPvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715619995; c=relaxed/simple;
	bh=FDuwsIcxe6g8UObrtEUApWLD5EAOx8Jm1kZwSamKDa4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FK8aNWEXKZxUJrJL/Amhcp+lQBtfPg89zNxeIrAnF239Skle/APqUYrGRlDAXlLF1MZIKKzYFdMhpWqWBF6tEnM34DjfFDfSVDh0Cwx0xp5c9NOrvahHVwhqJs9Xhtdreo90DrUaDzaPuH7t7Hc254QQ873hqWtfFcR68hpbCxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yvlxsQW6; arc=fail smtp.client-ip=40.107.223.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bb6owMWsw0yRNdAdQq/4+e4w0IEKRDNc6vNf049tr2mgtzzDhS/pNpBs0zdx9ilY8yGKWR8jt2585ywsnNyTAoNKEVFDoAxozlNUyD/8L3GmAWjU3oUaO1ljXj/rjKQCm42XALUe2XVIsMgwhEDRiw/QGvwidIYnt9FlMnVLrZdO0rXOMHHdUHAiKKa91hTG1ouMeLUVPb9RRx32p79xAiR7co9eZz5dVB3JoCaS6hHQ7n+U3Im75ZNwpQWAmj6PqFQBVEQ7uTKLv7Nfx/YSxJ2WJEyOv8V77gGwB0ysm1ER5rd3vPHRg9+xHpM3eHEEQblSpRnpqaNTZqSh5F/T7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sITzv9lcjXpILnxzlA/PBY2E3gr/u/XgDbdJUDAB/WA=;
 b=aZEpXBMkhfFipTz2VVBdJ2M+iM2tLlNxxUg7vIhBMO14rq2gqS+UJLPXFZ/LlHHbyjNI8z8+pFk3on3glsCyfa+YLsez4oFe5WhfOqC8pjrV5aALZN6vCEd26srRkCeJyqXmkL5+HBI/aNK46SS0+JHh4wg1qxmdQcmDuyCEPGnV6ExBLh7g8EvUlEWZ6+zVe3uh2EhUT7jR4+uyJMXC/YKKRT74VAAHXTyEOqbFXWf20OC6z7jmo+iHTeJbqMuco7tOiu4OCQM6UZXjRHtC8W/QS80ENPZE0BgtnJut+t8hufOU8GB8FLq383l5I9/kWf27PvAoYnunTBobipxIGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sITzv9lcjXpILnxzlA/PBY2E3gr/u/XgDbdJUDAB/WA=;
 b=yvlxsQW6JVB4In0+AmkGwN189kQXzQiv2ZNZmBjpY2xysZw9rySTsJPR2HuZKDMBv6FlLEJljBGbdcAzV/lUNH4XHQnFOjQ9sQOYHeO7wi+T9HmahISggQT3ookT4j8205JM3dbkyWsl+bS9ZWm8+22hPlEUgZWVT7YLTF/kPbU=
Received: from CH2PR08CA0007.namprd08.prod.outlook.com (2603:10b6:610:5a::17)
 by SJ2PR12MB9210.namprd12.prod.outlook.com (2603:10b6:a03:561::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 17:06:28 +0000
Received: from DS2PEPF00003439.namprd02.prod.outlook.com
 (2603:10b6:610:5a:cafe::9f) by CH2PR08CA0007.outlook.office365.com
 (2603:10b6:610:5a::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55 via Frontend
 Transport; Mon, 13 May 2024 17:06:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS2PEPF00003439.mail.protection.outlook.com (10.167.18.36) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7587.21 via Frontend Transport; Mon, 13 May 2024 17:06:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Mon, 13 May
 2024 12:06:27 -0500
Date: Mon, 13 May 2024 12:05:35 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Nathan Chancellor <nathan@kernel.org>, <kvm@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, Sean Christopherson <seanjc@google.com>,
	<llvm@lists.linux.dev>
Subject: Re: [PULL 18/19] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
Message-ID: <20240513170535.je74yhujxpogijga@amd.com>
References: <20240510211024.556136-1-michael.roth@amd.com>
 <20240510211024.556136-19-michael.roth@amd.com>
 <20240513151920.GA3061950@thelio-3990X>
 <0ceafce9-0e08-4d47-813d-6b3f52ac5fd6@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0ceafce9-0e08-4d47-813d-6b3f52ac5fd6@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS2PEPF00003439:EE_|SJ2PR12MB9210:EE_
X-MS-Office365-Filtering-Correlation-Id: f6dfc88a-fb7d-40c0-28c5-08dc736f077b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|36860700004|376005|82310400017;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?E+1dH+vRN/5LXO7UOeCESPrx8+9JfVPki8rdh1XcQ2Y023hiJXEhU6orah8N?=
 =?us-ascii?Q?TVMQZPYmkVak/ugt6srw6bau21KgLB4D/Roh9sS2kA3WBti2udesd2DoscQL?=
 =?us-ascii?Q?h3KhHNyks6sCcYgFFik9JE+fo0H82UBML5bS+civqrzUeB2bPYRKSOawOcNt?=
 =?us-ascii?Q?oyixFsvrujs5wHg2JwizncvhaeJnk42JTkZ0YiWvyao+wFzici/pI+tMwddT?=
 =?us-ascii?Q?/E4APJ8oON0uxSYMD56X9wgZdsvkB5mWJ5m7WfLrET7HS5KQyW1r7CNKfrre?=
 =?us-ascii?Q?xbfns/JvlKz5B4wGCgs31kjkUk2s/8POjbVycDr4k2k72ERO4dmirMqn54lE?=
 =?us-ascii?Q?6dcA5O0b8n7/U7FE0paPkN6TsVqzGdC3eTTp/Iuj0DePUylwrPOyM24Om/UN?=
 =?us-ascii?Q?IgveMm//HKYjE3hafumyJU/QRDg2CSPfn9k3g3589GIeriMEOnXJdIZdSUmH?=
 =?us-ascii?Q?IOgcHK2o1mm70FHrbXH0ZAhI3bj3PdXkI1HEDgho4sZ2GkRUrAi57lS6jok2?=
 =?us-ascii?Q?3Xp79VralGriS35QM3W+dkjOuU96Yvsi36Aw0k56pszzcm8ClNpXeBky02eU?=
 =?us-ascii?Q?DWsRH9Sztk2OPqnL8YHx+arjHbNADQppbtAfU2JBcw06VHPeYP6GJHzo4c8x?=
 =?us-ascii?Q?Q/CuMykYIDfqhe2wqG8Z6WYiqw/rTeSTWBBy75q/72nNyyb3uRF6rMXof4hw?=
 =?us-ascii?Q?xKSUby7ov7LNkcRiXvzygMzW9UuwPaVfm7eZP0hhpTZDGzXYhXGcT9fLYKjt?=
 =?us-ascii?Q?rZLYeTsSZsqbzdjTEmMnF7r7PQVOWnaHoCKBi1rULoYm2cZ2Lwcj2RRxkE1m?=
 =?us-ascii?Q?U6ljvRZbSrdpLWij9moMtGxT6PNnjldqdQPI6JecmgJ5yQnzG8MsI15ySwDQ?=
 =?us-ascii?Q?b8Y2vgQqgYVRFXQNkPxsxWVrEoWSMT7a8ucmkvzd6KHxqiftVgqOrHDkmcWL?=
 =?us-ascii?Q?XDfoQkgaH//7HfKZq4PObAd56AWSwDQoju7f6hWtwvd+auuONAa3R2Uex+BI?=
 =?us-ascii?Q?ka7SaJjvnFnK1J7RCDi7y7Ty9SCLDup6BumMwsCTZ6N0mgSz6VQuVtolnT5F?=
 =?us-ascii?Q?3DXSdfh2HgREiZI2yLFNqn/fIEu/5/bjT8qZVZZzIDFFIqfQL2KkmVwoGA/T?=
 =?us-ascii?Q?HvI5YSimOQBKzzS9WgswrWCT1zqhdnR3s47OcbpoRSnSKC56oLubfz1SWeXu?=
 =?us-ascii?Q?9yGXiAIw1unNB2nzLXMvyrhLFU8By2xbLsRj0lJmICSOmCKDKwSIGn+xHnZW?=
 =?us-ascii?Q?a1YenqGtRIVUohO34fVs+ATYK5Elcjt47AnA/e0onapabq9FxPFCL9ZyjecZ?=
 =?us-ascii?Q?nUdHKAsBWeolMvKktRDRJS31?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(376005)(82310400017);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 17:06:28.3062
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6dfc88a-fb7d-40c0-28c5-08dc736f077b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS2PEPF00003439.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9210

On Mon, May 13, 2024 at 06:53:24PM +0200, Paolo Bonzini wrote:
> On 5/13/24 17:19, Nathan Chancellor wrote:
> > > +static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
> > > +{
> > > +	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
> > > +	struct vcpu_svm *svm = to_svm(vcpu);
> > > +	unsigned long data_npages;
> > > +	sev_ret_code fw_err;
> > > +	gpa_t data_gpa;
> > > +
> > > +	if (!sev_snp_guest(vcpu->kvm))
> > > +		goto abort_request;
> > > +
> > > +	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> > > +	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> > > +
> > > +	if (!IS_ALIGNED(data_gpa, PAGE_SIZE))
> > > +		goto abort_request;
> > 
> > [...]
> > 
> > > +abort_request:
> > > +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
> > > +	return 1; /* resume guest */
> > > +}
> > 
> > This patch is now in -next as commit 32fde9e18b3f ("KVM: SEV: Provide
> > support for SNP_EXTENDED_GUEST_REQUEST NAE event"), where it causes a
> > clang warning (or hard error when CONFIG_WERROR is enabled) [...]
> > Seems legitimate to me. What was the intention here?
> 
> Mike, I think this should just be 0?

Hi Paolo,

Yes, I was just about to submit a patch that does just that:

  https://github.com/mdroth/linux/commit/df55e9c5b97542fe037f5b5293c11a49f7c658ef

Sorry for the breakage,

Mike

> 
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index c7a0971149f2..affb4fb47f91 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -3911,7 +3911,6 @@ static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
>  	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
>  	struct vcpu_svm *svm = to_svm(vcpu);
>  	unsigned long data_npages;
> -	sev_ret_code fw_err;
>  	gpa_t data_gpa;
>  	if (!sev_snp_guest(vcpu->kvm))
> @@ -3938,7 +3937,7 @@ static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
>  	return 0; /* forward request to userspace */
>  abort_request:
> -	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
> +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, 0));
>  	return 1; /* resume guest */
>  }
> Paolo
> 
> 

