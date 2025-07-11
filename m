Return-Path: <kvm+bounces-52092-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F1BCB01372
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 08:23:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6B1D01C4769C
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 06:23:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4F21D63E8;
	Fri, 11 Jul 2025 06:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="NueQOndR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2081.outbound.protection.outlook.com [40.107.243.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDCEA92E;
	Fri, 11 Jul 2025 06:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.81
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752214983; cv=fail; b=ijaLhzyFOt7lOiMsGqTUH3QAn8/rtBGPKtBZV2Z23i/k6p6ON3mvffVnhz32sNdSiVUzYiu0ssvrKYgWUkNdHWkXXIDTkCohiPV7DB9DguJQCtTA/Ytzw3CakIBJjIB4gwWu6vEKZo2EIKPvqtg5HZPpHz0xxPHZ/HLpwGRkkKA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752214983; c=relaxed/simple;
	bh=40xntxtsxbUf9PvQx1VLCo/Nkeg/ZdGbL1srP3eD/jg=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=W2ocMJO+Z8nE+/+/iomK9k/SrEZOMzRySM4UGe9D1vVO+FD3M1REFBsrDryKDz5aZ3ioh9yt1Vuvp43gqXB0LDWqrJTteN4PZR5pHsHnmt5ukwqszV1geDStSGvGNXiiBQ8SY8Yre5eDgQO0WZd9CvkJEp2okIZNOrZpBhtN8q0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=NueQOndR; arc=fail smtp.client-ip=40.107.243.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Ph/leo4PQ6w0fTzB1P6uc7pCiH8r/QZXuZQ6mV99giO/5dJPGsxHDUjYZejIBpl6YHqLlA+Gch4JvZRoVlDMbujEXTAAF/cYAUpb1GCE6z92vJxsg8TERZ0GVrHb6DFEGzUBt+TeBKkJu1BasZDjChMs6akSnCVJS39F+0j7TRb2QDBlLyTTQOou25SCZppxVFQIwvGJIJFtVm6ukB76HetCPIZUH7Dm00ywGsB6C5NAP610Lh9mbTmeQdPplzG73AZFZSoQcEutUBcImynV+6qCzlBR2sXvmXo3UeX6RaSbYQPb4Gi57LFGnbVgbHa1QUu02CzButu1U9qvfF+7zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/RB7N1dVJxitvD9vGFlQ+NHYVpAN7gw0PpdY1WF27o=;
 b=NIENhWCiNoJFBQDQIohXeDQFdVHOGlhn0uHmeZX/Rg2V82tboDSX/7J8qytXNaG6GlBEcPVG2ItSG9vaqozcbOw7HNxg6/xVJxT4vb6lZIRtxKmQTuxO8xhZh86p/dFk6hDVxnE/ANGF4DYGuumaEX66fJq0DHbK7ksAMNE2QEAVXloReJ886YJdGLIxGbyNSmW5FO9j32Qy3iM2HGlonNu4PL7D7tbBV9zouxThsLqz8Ob3MMiAWBXJgem3F1LuQAGHA3S22QnDe2Jur7/jfW+wOg++iFtXMkZ6Rj0E3b0Tc8bP6a9j0XJi3QEZOb5zL1X6y4pxOrZSOFrMZ/d2gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=intel.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/RB7N1dVJxitvD9vGFlQ+NHYVpAN7gw0PpdY1WF27o=;
 b=NueQOndR7GyU9Br9vqlNALBrLJQbQOOkSj8SlDW+gpxgZYNODNdO0VoFwuOUQUaHFQwtMh8Rzew/c1UydgT8RRc9bvHPs6TR4npA5/rtwSFiUEjP082PIG2YtLM8elZjexP/Aa3Ej6b7QHKxHA9/7MTc8Tgm98m/OehCwYf8XmE=
Received: from MW4PR04CA0348.namprd04.prod.outlook.com (2603:10b6:303:8a::23)
 by LV9PR12MB9830.namprd12.prod.outlook.com (2603:10b6:408:2ec::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.25; Fri, 11 Jul
 2025 06:22:57 +0000
Received: from SJ1PEPF00001CDE.namprd05.prod.outlook.com
 (2603:10b6:303:8a:cafe::9e) by MW4PR04CA0348.outlook.office365.com
 (2603:10b6:303:8a::23) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8922.23 via Frontend Transport; Fri,
 11 Jul 2025 06:22:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 SJ1PEPF00001CDE.mail.protection.outlook.com (10.167.242.6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8922.22 via Frontend Transport; Fri, 11 Jul 2025 06:22:56 +0000
Received: from BLR-L1-NDADHANI (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 11 Jul
 2025 01:22:52 -0500
From: Nikunj A Dadhania <nikunj@amd.com>
To: "Huang, Kai" <kai.huang@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/2] KVM: x86: Reject KVM_SET_TSC_KHZ vCPU ioctl for TSC
 protected guest
In-Reply-To: <9b2e872b1948df129e5f893c2fbd9b11d0920696.camel@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
 <8aebb276ab413f2e4a6512286bd8b6def3596dfe.1752038725.git.kai.huang@intel.com>
 <e3da1c7e-fa47-415f-99bf-f372057f0a75@amd.com>
 <9b2e872b1948df129e5f893c2fbd9b11d0920696.camel@intel.com>
Date: Fri, 11 Jul 2025 06:22:44 +0000
Message-ID: <85ms9btfez.fsf@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PEPF00001CDE:EE_|LV9PR12MB9830:EE_
X-MS-Office365-Filtering-Correlation-Id: 74317033-1bc3-4828-fd88-08ddc043604b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|36860700013|82310400026|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?VYFfP575HFs7NY4qaT0YWdt3CCR/wqWpJNge+JsSqV1dBstxpWee1wGKO/98?=
 =?us-ascii?Q?UZZau8klhY+AovjmvuWx3QKW/kOgxeLfHny3Hu2sLVgIHJIBzNi2FtQ0nT8O?=
 =?us-ascii?Q?YUZD2OnNLjz92UgZo1LorBuyIHD7i05NhWFVOE4UGqoIEi1Y1Od4LjuslA95?=
 =?us-ascii?Q?w54S6m9Ftk04wUgKzlr0g0efR/e1M+xctCd/6YmUZuos4AXYY19vnjoe7y+G?=
 =?us-ascii?Q?H17qik/b76g1uUgzurgdU7Yz/AFWjqWDzn/q9sfYBIdQFmuoakUsX+fHg+rE?=
 =?us-ascii?Q?o3H+uezqQldre6GVoGZ03qjs3PF83+JBfHKoAHcZ4sEkQYcfn8nYUfI5HhBO?=
 =?us-ascii?Q?es+eAM6YYaY/9uohfxFCEzVyV19uaXe7bQWHWUkTAU/kR8AgAr+bL8i4xR36?=
 =?us-ascii?Q?iLJcu48e+uKPgn1nNNI4o+qNzb8OtKHYZf6kdKZ/VpdWHHmxzmhigoinuNJz?=
 =?us-ascii?Q?OvOA3zGpgjTb7QVZCLxW+wBBh0v4XO00pTCdYfIY1UEPOEvOUw0qaJqdMso5?=
 =?us-ascii?Q?/4GJuLVuFnjsEaDeEB/C+tyq7CQoXro5Hk1Zby4Af8RxwLS1bGAxiVqcrqwy?=
 =?us-ascii?Q?xgVyHBHw38LJe84gLQGFB5eSITtLPrT8OuFzkPFcmEEid54Q26Y+8YUP4DNs?=
 =?us-ascii?Q?2tTvucdklAdOIGzYXWv1HD80J1AAZMotjZ6HC/nU/1KE2OIUp6yyOnFJx6av?=
 =?us-ascii?Q?5/EozqPnIEFmnXRDwoe2BvTE7UYlBtw7FrPJDn2tQWRwFDtbaYlU7yl5FczR?=
 =?us-ascii?Q?94/QDhtsHvHJdad0AReFU+gh+gWmf8Hf/rCwJ9v70l8q+TKq2rAJkdgisbai?=
 =?us-ascii?Q?Sd7dsGOcuMaHg6iY4TWcfWa5OFthZqtlJ/UK+DLkxduMZpLDgasq7YYMtvN2?=
 =?us-ascii?Q?2X0hfve7+GgFmcJ6Ry8zx/HOqPmhyddgWpTsu823kV55av/IxjXgdYqp96v/?=
 =?us-ascii?Q?KXGA+Jw+9R+ybaBwxp02wfSRZhrcAsqrF4X8VuFGb0pZmguJSKYBbEN/7Bwg?=
 =?us-ascii?Q?8gjAB8LSECItGaQUODJKJKzfVfnWc4QZQH6NcFdrd35HJFksnWQWrQTtp5g+?=
 =?us-ascii?Q?5GHgK7OmPkfjBX6alYBlPP17Hdjb/AueFzlSb8V+DcDjBRa77nB7pdEWjZpe?=
 =?us-ascii?Q?K8gaUU6RQ57VSCaRirMWQ5jGfH2nHKWjattlMxLqGUiwCnkmy59fQhH/clSt?=
 =?us-ascii?Q?rx8GzbKA0vSRpWz/E8puBQK6DqJWuuOutwtiUJbodOHCGkG8GvHuRd/SunhN?=
 =?us-ascii?Q?9hsbNdHHPmqDCukiflnB3HFA6ZBd9Ovule0Tf3CZbkXzPY80kHgRpHG8nAkE?=
 =?us-ascii?Q?bdVSMwo4UakXZuWwRPynSD0UwuXmfdLdJaOBzRt3X7lf7c/Jkx1OSoPZHbxn?=
 =?us-ascii?Q?bw3gQt4OCbnc4eRD7axpt9MSpKIScyu8DPPcTBbHxql2kFwR2oM3BkG3xtJB?=
 =?us-ascii?Q?IX/Bjudt8abIax2vlUUvxvRGKCAhAP49SjiOdKXMb44P9ZXAazfo0vJp9nr9?=
 =?us-ascii?Q?Tcm5tvSBQf/geLJDnHP/Mp+d2njZCdMRhALU?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(1800799024)(36860700013)(82310400026)(376014);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2025 06:22:56.6078
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74317033-1bc3-4828-fd88-08ddc043604b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SJ1PEPF00001CDE.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV9PR12MB9830

"Huang, Kai" <kai.huang@intel.com> writes:

> On Wed, 2025-07-09 at 14:09 +0530, Nikunj A. Dadhania wrote:
>> 
>> On 7/9/2025 11:07 AM, Kai Huang wrote:
>> > Reject KVM_SET_TSC_KHZ vCPU ioctl if guest's TSC is protected and not
>> > changeable by KVM.
>> > 
>> > For such TSC protected guests, e.g. TDX guests, typically the TSC is
>> > configured once at VM level before any vCPU are created and remains
>> > unchanged during VM's lifetime.  KVM provides the KVM_SET_TSC_KHZ VM
>> > scope ioctl to allow the userspace VMM to configure the TSC of such VM.
>> > After that the userspace VMM is not supposed to call the KVM_SET_TSC_KHZ
>> > vCPU scope ioctl anymore when creating the vCPU.
>> > 
>> > The de facto userspace VMM Qemu does this for TDX guests.  The upcoming
>> > SEV-SNP guests with Secure TSC should follow.
>> > 
>> > Note this could be a break of ABI.  But for now only TDX guests are TSC
>> > protected and only Qemu supports TDX, thus in practice this should not
>> > break any existing userspace.
>> > 
>> > Suggested-by: Sean Christopherson <seanjc@google.com>
>> > Signed-off-by: Kai Huang <kai.huang@intel.com>
>> 
>> Need to add this in Documentation/virt/kvm/api.rst as well, saying that
>> for TDX and SecureTSC enabled SNP guests, KVM_SET_TSC_KHZ vCPU ioctl is
>> not valid.
>> 
>> 
>
> Good point.  Thanks for bringing it up.
>
> I will add below to the doc unless someone has comments?
>
> I'll probably split the doc diff into two parts and merge each to the
> respective code change patch, since the change to the doc contains change
> to both vm ioctl and vcpu ioctl.
>
> Btw, I think I'll not mention Secure TSC enabled SEV-SNP guests for now
> because it is not in upstream yet.  But I tried to make the text in a way
> that could be easily extended to cover Secure TSC guests.

Sure, I can add that later.

>
> diff --git a/Documentation/virt/kvm/api.rst
> b/Documentation/virt/kvm/api.rst
> index 43ed57e048a8..ad61bcba3791 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -2006,7 +2006,13 @@ frequency is KHz.
>  
>  If the KVM_CAP_VM_TSC_CONTROL capability is advertised, this can also
>  be used as a vm ioctl to set the initial tsc frequency of subsequently
> -created vCPUs.
> +created vCPUs.  It must be called before any vCPU is created.

s/It/The VM Scope ioctl/

> +
> +For TSC protected CoCo VMs where TSC is configured once at VM scope
> and

s/CoCo/Confidential Computing (CoCo)/
s/TSC is/TSC frequency is/

> +remains unchanged during VM's lifetime, the VM ioctl should be used to
> +configure the TSC and the vCPU ioctl fails.

s/TSC/TSC frequency/

s/vcpu ioctl fails/vcpu ioctl is not supported/

> +
> +
> +Example of such CoCo VMs: TDX guests.

Regards
Nikunj

