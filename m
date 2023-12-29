Return-Path: <kvm+bounces-5363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA6B1820763
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 17:31:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0F0AEB2178A
	for <lists+kvm@lfdr.de>; Sat, 30 Dec 2023 16:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A075F9C4;
	Sat, 30 Dec 2023 16:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PQwXlIjE"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2060.outbound.protection.outlook.com [40.107.94.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F68D2FF;
	Sat, 30 Dec 2023 16:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfO4WbdW6sdKH57RvpTjx7kTonwU9IbTo6k1jswQhigjdeZqzJfliV8eQinp+jVd8DVqEbEUkP6yiIY8k9KhohI9DMDJo546tMiO/S+PXqBXutJAmvrMtTvJRExUDHhVuufaQAB5YPfwA9kbE5FxkhJjAOeLX4nJ+n+LzI0tqHnaB+Z/BUbPkIuYwmcY/WR3HFvwdtxkAZTjCO1tnLXOfwlrox1wmE+gh8KjaFU5bE87z2IAYqcsjUS0+QDKZMVYw+sePo20hG3YtVzeOY1mSfBCQyQPZvvAz67rkLMbZzQASgP6UxEcNTkpCloJNQudA7Ln3BrW73EbkUJGnEtPtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+uWfdyNfgvPcp5KvXOi6ohVw02Oi+PezFcW7hS5yHyE=;
 b=CcWWcCk1bp/O6+a9IuksqpClbZhqIxopI6m2GwUXIm//T9u/ucJ/ICOA8IeV402bUV46dXv8/6FENU2yZjHfspuAdbpPIJbtFshlNmumT0NT+ByHYWJyvq4h8f/NBfePZBkmCoDeJKZ2lzr3TGGhX4vp7ZxqZk/JvNd1/jiHQo/gnDnpDlchcFFbiHiKoyBXpjPkIT07/FjhgMtsCV9tGgDhGCC/vKay0ruZuoRRZb7Ox9Io2LqD2KV20CZIThiDf5slQm40FPWqTksKeVze0RwXpr2xCm6YCvclnRZ45Mg6NCDhsrWYTVuyDwvazXanYOzzl2Ovgvc+GB0/oK/hvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uWfdyNfgvPcp5KvXOi6ohVw02Oi+PezFcW7hS5yHyE=;
 b=PQwXlIjEP4gcpzI960LQnJ2oby/TStltqhhPs4imausGSyJc0xPxgQneWwvbRoIdIA8xgFjMxKS7FVLlEIouSUeJLDnhILT5E3Otg4Of9/nss1q0Gy/BtY2TKst8aj475rKkVFKcp3xNMkr0kFXF8dS+mkJuYh+kM7ExI3Gngb0=
Received: from SJ0PR13CA0020.namprd13.prod.outlook.com (2603:10b6:a03:2c0::25)
 by DM4PR12MB6302.namprd12.prod.outlook.com (2603:10b6:8:a4::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.23; Sat, 30 Dec
 2023 16:28:22 +0000
Received: from DS1PEPF00017099.namprd05.prod.outlook.com
 (2603:10b6:a03:2c0:cafe::38) by SJ0PR13CA0020.outlook.office365.com
 (2603:10b6:a03:2c0::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7159.7 via Frontend
 Transport; Sat, 30 Dec 2023 16:28:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF00017099.mail.protection.outlook.com (10.167.18.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7159.9 via Frontend Transport; Sat, 30 Dec 2023 16:28:21 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.34; Sat, 30 Dec
 2023 10:28:21 -0600
Date: Fri, 29 Dec 2023 15:41:39 -0600
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<marcorr@google.com>, <sathyanarayanan.kuppuswamy@linux.intel.com>,
	<alpergun@google.com>, <jarkko@kernel.org>, <ashish.kalra@amd.com>,
	<nikunj.dadhania@amd.com>, <pankaj.gupta@amd.com>, <liam.merwick@oracle.com>,
	<zhi.a.wang@intel.com>
Subject: Re: [PATCH v10 20/50] KVM: SEV: Select CONFIG_KVM_SW_PROTECTED_VM
 when CONFIG_KVM_AMD_SEV=y
Message-ID: <20231229214139.fctfgl5n2zjac2hb@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-21-michael.roth@amd.com>
 <cc97bfdf-ac46-4616-be68-d251304f81af@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cc97bfdf-ac46-4616-be68-d251304f81af@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF00017099:EE_|DM4PR12MB6302:EE_
X-MS-Office365-Filtering-Correlation-Id: 87801c02-df6d-442f-4309-08dc095456f1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zsYkD9h3zQ7UAjP2OjAfFl7jXmkvRhBE7Cz6BO1Ijq303bv6CL0atloj+rG7gRrd7H/ku8je1C1dKP7fTfKAar/q327P4dxZPKa2Dfd5hZH3MnZOsgRj5ehxgEC1Mo+BQqrfMiIgbnWPuQ6HegXmwzISUBPDjL6BnnSIgt5FM/+zx9mHzTnE9gtULT3b0hniiYD8PEaHDieT/QnmWMqyUFE5ERhCpoflDBtUQvwgP3enSoYEkKaAduyKb2WqP6irExP5AcmD08Evn6kLBAt5XrIFI5hhsTQe2WVla0XvxAheG781dFP7oBj5B/7d/fIqtmDhuy48EXQdwmQ1mLRpXzbL85p41Qn9A4D/TDMJud2rfrfzMNyFEZR4H2muk55jId43zhGPTcw1qc6KdeBj3BWT1Q7wRcd+LDAo4k0ArfasMHg6K70uTDHih1ZvvPxQgGHVhnRdQ9s6wfzgATyokGmU31GmQi3DWb9iSXJM0ohte6eTzpX8sAQ7nQJyq8KLMQWYDBtlVZUNTHzDLYKtxaNPXDLlBJFfFNVATtVmdyHpAMfZwrU1qgCgyesJ8HCYM0fJotmv7bGGmuC5csK4muHpJLtuR7LnrtMpV8aswJo1sfeg7eQJFMFyauFO7Z6KtbLkewhBVE1WlpeRtSbnMITX3T3sPnM6aenlN21LYPXS7PKBpT9RNPF+pAPf+yIt3N9uHN/k7/Xs9NtMbvYSRz0WxCVP51wMpO1mO9PiHY0OwtpVmldbTudBKfghNutOY/32CBPpwDVjYYBFh66oow==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(346002)(39860400002)(396003)(136003)(230922051799003)(82310400011)(451199024)(186009)(1800799012)(64100799003)(46966006)(36840700001)(40470700004)(336012)(426003)(53546011)(1076003)(26005)(16526019)(2616005)(47076005)(36860700001)(5660300002)(44832011)(8936002)(4326008)(8676002)(41300700001)(7406005)(7416002)(4744005)(2906002)(478600001)(6666004)(316002)(6916009)(54906003)(70206006)(70586007)(36756003)(82740400003)(356005)(81166007)(86362001)(40480700001)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2023 16:28:21.9385
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 87801c02-df6d-442f-4309-08dc095456f1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DS1PEPF00017099.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6302

On Wed, Dec 13, 2023 at 01:54:55PM +0100, Paolo Bonzini wrote:
> On 10/16/23 15:27, Michael Roth wrote:
> > SEV-SNP relies on the restricted/protected memory support to run guests,
> > so make sure to enable that support with the
> > CONFIG_KVM_SW_PROTECTED_VM build option.
> > 
> > Signed-off-by: Michael Roth<michael.roth@amd.com>
> > ---
> 
> Why select KVM_SW_PROTECTED_VM and not KVM_GENERIC_PRIVATE_MEM?

I'm not sure, maybe there were previous iterations where it made sense
but KVM_GENERIC_PRIVATE_MEM definitely seems more appropriate now. I've
changed it accordingly.

-Mike

> 
> Paolo
> 
> 

