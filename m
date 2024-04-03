Return-Path: <kvm+bounces-13486-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D71A897765
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 19:53:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04A791F32687
	for <lists+kvm@lfdr.de>; Wed,  3 Apr 2024 17:53:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0656B15575A;
	Wed,  3 Apr 2024 17:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="4jcHm1Wk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2084.outbound.protection.outlook.com [40.107.93.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE46152188;
	Wed,  3 Apr 2024 17:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712166026; cv=fail; b=owFRXa0i7hvIguwn3qKXDMtvFEfDbo83L7lM+FcWgmnkFdy2GcdMBnBin8yTpjwL2WhCtTYtuHBj0n4wSMiT7vSedJEBr3uhefj+rmSjZE1VE25O+y6mvZ55CJ0ea1stTK5H4RDG2YvLvegyv9vfs944akRPaoxYWT5wYekHjnQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712166026; c=relaxed/simple;
	bh=/TYwUjVm0Uy206LdCg+39hMPYZ4p8N78LwK04UxatYE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXiuc+HixPoE0UP7SLQAjirkrzO62JF2DiPmyivdOUdV/V+DWfWHa2J9kQKvDUeiC+H20Kke08jcztIAeeLHcwrJNfuhedXGYgF/tPU70nGx/7OX0KTko1+31g4+LWffC19IOQGmAd7Av2AIKtDSfu9CJcRkIxvWFCfdrA4amqg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=4jcHm1Wk; arc=fail smtp.client-ip=40.107.93.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WIw1hxUvkv6AK66+q0fyCcWxlmvOrI0bmpRkVwiIyghZgKIIOz5UJOp5Qlr5fOTz5BZDl3ucdqdhOTOWV4OgpJPXcMDWb+3JbazvmAkgF0YtemOErn8nkw90HH+6vw4hhSMQ3WHuGWn+//au9gvIjMHjYabfbHmj71ciFU1JaL9TClB1mk46PTz252WaeQfa9m17hWs2kOJpAA1bHwVmvAM+JFH89e76Kj4S+lnfqpmmiVfjeRBC7aNC+I3jQ3oVf0B9ysFJiGMe3frPmHgMcZilyMhmH8Iy+aVipvhxI+Kj/TUyXO70MV4jH9Cg9snvqBzTOV2lo7Aa4Af96ET6uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+oOR3ua1OkafKJbj+8tdMSqJxQ+lFTLsSvptohKYCB0=;
 b=MplWqDfRUvKFzX4VETLJaA689AaQX//V5h2a1Nl1U0h79ZweHeUwjn1klwVYgNQ8qOTVeGv+mkV/MAmgsHTpFyotAbs3c6B9rty9hPNniTB0Uk33CX3XR5DhF9IB97SXoOAjj91zqS669bHKz94QloQ4dJZPfYSPazDE7a6hIZT0OQlGWSB1p5WW1ccZvjiH5N4C7vYa7QJbV8lMgz1aQuhgH4lSmMHhrA20t2v0yJjWOtrKC7DEpxjIuHoKgfb9kJAt87QLs3x6mrHFIgGobMI2ldn6X0freuUYG5p/JAl7NBdYgqOBWdkYEwpVdvszMxE4uNN1SbCag2D/bjG18w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+oOR3ua1OkafKJbj+8tdMSqJxQ+lFTLsSvptohKYCB0=;
 b=4jcHm1Wk6AK7Undb48jn7Y35XitoC92qW66EAfbUcBqeHQVTU8/D2oVFnhc15N0q/K0MstlZ7eIeDrrzW7pdW1Zh/wwIdeKrqEZzu4zdWu0h5jlVkh8WaQoqND6TJOAixA29+bEfp4aOLd6tFrlVdlupmXh8a/p492Qh9PRdDLc=
Received: from SJ0PR03CA0155.namprd03.prod.outlook.com (2603:10b6:a03:338::10)
 by MW4PR12MB7438.namprd12.prod.outlook.com (2603:10b6:303:219::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.33; Wed, 3 Apr
 2024 17:40:21 +0000
Received: from SJ5PEPF000001D6.namprd05.prod.outlook.com
 (2603:10b6:a03:338:cafe::9d) by SJ0PR03CA0155.outlook.office365.com
 (2603:10b6:a03:338::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46 via Frontend
 Transport; Wed, 3 Apr 2024 17:40:20 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ5PEPF000001D6.mail.protection.outlook.com (10.167.242.58) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Wed, 3 Apr 2024 17:40:20 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 3 Apr
 2024 12:40:18 -0500
Date: Wed, 3 Apr 2024 12:40:03 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>, David Hildenbrand
	<david@redhat.com>, David Stevens <stevensd@chromium.org>, Paolo Bonzini
	<pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, Suzuki K Poulose
	<suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Huacai Chen
	<chenhuacai@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao
	<maobibo@loongson.cn>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
	<npiggin@gmail.com>, Anup Patel <anup@brainfault.org>, Christian Borntraeger
	<borntraeger@linux.ibm.com>, Janosch Frank <frankja@linux.ibm.com>, Claudio
 Imbrenda <imbrenda@linux.ibm.com>, Xiaoyao Li <xiaoyao.li@intel.com>, Xu
 Yilun <yilun.xu@intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, Fuad
 Tabba <tabba@google.com>, Jim Mattson <jmattson@google.com>, Jarkko Sakkinen
	<jarkko@kernel.org>, Maxim Levitsky <mlevitsk@redhat.com>, Anish Moorthy
	<amoorthy@google.com>, David Matlack <dmatlack@google.com>, Yu Zhang
	<yu.c.zhang@linux.intel.com>, Isaku Yamahata <isaku.yamahata@intel.com>,
	<Edgecombe@google.com>, Rick P <rick.p.edgecombe@intel.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, Vlastimil Babka
	<vbabka@suse.cz>, Vishal Annapurve <vannapurve@google.com>, Ackerley Tng
	<ackerleytng@google.com>, Maciej Szmigiero <mail@maciej.szmigiero.name>,
	Quentin Perret <qperret@google.com>, Wei Wang <wei.w.wang@intel.com>, Liam
 Merwick <liam.merwick@oracle.com>, Isaku Yamahata <isaku.yamahata@gmail.com>,
	Kirill Shutemov <kirill.shutemov@linux.intel.com>, Lai Jiangshan
	<jiangshan.ljs@antgroup.com>, Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, Jinrong Liang
	<ljr.kernel@gmail.com>, Like Xu <like.xu.linux@gmail.com>, Mingwei Zhang
	<mizhang@google.com>, Dapeng Mi <dapeng1.mi@intel.com>
Subject: Re: [ANNOUNCE] KVM Microconference at LPC 2024
Message-ID: <20240403174003.damh4vq7xh53e6vw@amd.com>
References: <20240402190652.310373-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20240402190652.310373-1-seanjc@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ5PEPF000001D6:EE_|MW4PR12MB7438:EE_
X-MS-Office365-Filtering-Correlation-Id: 443cf007-eff0-4aab-215c-08dc5405225c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	b9IhaiAbxyZJor7wRBpJRKx88StThpyzWFXiiLmVEsJoJDSSf5pHZnufmlXcnHqRPa4MlctrQABsdD63lkQIQ6LGOviEvKHCbo13qmu67mJHrZhWG56DwEVsRgizAn066uO67hAYKKhuPKP08dbfch5vVYiGPERH43Mp8Sl2z4w0EL81yeirbxkB8Av+UOq+z94+hjtRVcT2WgkNg6I1pdZIQOh0JE2w5Hrmxewi5AoOEXO4EPSlUa0zLIczRi5CSKFCzO+nXhWX8X/qEIftK9gSlbNPZYVE5WDI89nUdNxQYTJyVhr7ESvxaQeLq5pgNUiPAV3rrj0DBvUUcC1hZDfV1rx0jk0JR28MTZ6MqzN9Iibr56mXxYgUo/qxnAKZAprZkaQ3DFk6KnDNvPtjuwrWbXzpL3zbriKP+ueT5CZeQdOCQDlQPEm5wwZ/8csMQaqHkML6qGqYlRQfSbBfdYx+a8E0wpIgt5ZYq2aD68hL3jsT8jXm4k7ExPXntoYP+gX8LQSCqCJX3ANdvv0EuMpfOb7cuECuzyg/2JBFxokXlhvD9Hni7noU5u6UgqBAVLSRhbGfyO2dSp18NubMtyHOXXs7y3nnxoNozC9UFgtgY4TbQ4lJ1fbpJkKstouJuJVvBjtNmhe67YS7lWD9rGkMRAQzSwR7mYyLscCOH5/i5ugAhsd3CeqJ7lRxxfsZTFP5SKOrCvAiUzspljK3VA==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015)(82310400014)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2024 17:40:20.6238
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 443cf007-eff0-4aab-215c-08dc5405225c
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ5PEPF000001D6.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7438

On Tue, Apr 02, 2024 at 12:06:52PM -0700, Sean Christopherson wrote:
> We are planning on submitting a CFP to host a second annual KVM Microconference
> at Linux Plumbers Conference 2024 (https://lpc.events/event/18).  To help make
> our submission as strong as possible, please respond if you will likely attend,
> and/or have a potential topic that you would like to include in the proposal.
> The tentative submission is below.
> 
> Note!  This is extremely time sensitive, as the deadline for submitting is
> April 4th (yeah, we completely missed the initial announcement).
> 
> Sorry for the super short notice. :-(
> 
> P.S. The Cc list is very ad hoc, please forward at will.
> 
> ===================
> KVM Microconference
> ===================
> 
> KVM (Kernel-based Virtual Machine) enables the use of hardware features to
> improve the efficiency, performance, and security of virtual machines (VMs)
> created and managed by userspace.  KVM was originally developed to accelerate
> VMs running a traditional kernel and operating system, in a world where the
> host kernel and userspace are part of the VM's trusted computing base (TCB).
> 
> KVM has long since expanded to cover a wide (and growing) array of use cases,
> e.g. sandboxing untrusted workloads, deprivileging third party code, reducing
> the TCB of security sensitive workloads, etc.  The expectations placed on KVM
> have also matured accordingly, e.g. functionality that once was "good enough"
> no longer meets the needs and demands of KVM users.
> 
> The KVM Microconference will focus on how to evolve KVM and adjacent subsystems
> in order to satisfy new and upcoming requirements.  Of particular interest is
> extending and enhancing guest_memfd, a guest-first memory API that was heavily
> discussed at the 2023 KVM Microconference, and merged in v6.8.
> 
> Potential Topics:
>    - Removing guest memory from the host kernel's direct map[1]
>    - Mapping guest_memfd into host userspace[2]
>    - Hugepage support for guest_memfd[3]
>    - Eliminating "struct page" for guest_memfd

Another gmem proposal we were considering was:

  - Scalability/Performance Analysis of guest_memfd

Mainly looking at things like points of contention during lazy acceptance for
large guests, page-conversion latency increases, impact of discard/realloc
(prealloc?) of gmem pages from userspace, etc.

Thanks,

Mike

>    - Passthrough/mediated PMU virtualization[4]
>    - Pagetable-based Virtual Machine (PVM)[5]
>    - Optimizing/hardening KVM usage of GUP[6][7]
>    - Defining KVM requirements for hardware vendors
>    - Utilizing "fault" injection to increase test coverage of edge cases
> 
> [1] https://lore.kernel.org/all/cc1bb8e9bc3e1ab637700a4d3defeec95b55060a.camel@amazon.com
> [2] https://lore.kernel.org/all/20240222161047.402609-1-tabba@google.com
> [3] https://lore.kernel.org/all/CABgObfa=DH7FySBviF63OS9sVog_wt-AqYgtUAGKqnY5Bizivw@mail.gmail.com
> [4] https://lore.kernel.org/all/20240126085444.324918-1-xiong.y.zhang@linux.intel.com
> [5] https://lore.kernel.org/all/20240226143630.33643-1-jiangshanlai@gmail.com
> [6] https://lore.kernel.org/all/CABgObfZCay5-zaZd9mCYGMeS106L055CxsdOWWvRTUk2TPYycg@mail.gmail.com
> [7] https://lore.kernel.org/all/20240320005024.3216282-1-seanjc@google.com

