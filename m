Return-Path: <kvm+bounces-17868-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C67A68CB583
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 23:50:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 43CC01F21C56
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 21:50:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C3C149E1A;
	Tue, 21 May 2024 21:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="IHdzH6/7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0707A487B0;
	Tue, 21 May 2024 21:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716328212; cv=fail; b=Xjh6FgbYibHBl9BGbvr0LUzoA0gJM/jNV4LEtFiCzJNLPIhXldPwfKigiFOk1qYJTvgxM8D2HBaNCIu21eqijE5fAljgvBDc0uyNomNK++7dfxI6kCiZtT9LBtgx6PiAL5Z1Fsn+f9u8l53e9nXNxg5YA61WLfoXfOdjtTGrwzE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716328212; c=relaxed/simple;
	bh=1j9HU7TKWQG+XG6DmlOPfHSMDisJOt4ywq9VOWn8i5E=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hsJqAtqhivyUPcQTn63sOTU71KH2TmYri5YUD9oLIBRSoRgh0Syfuf2/HsXzO8mbo/5y+kllmqP4IsA9OqJvaQdMhvxQK0+m2I8D8dSOBaGMpJXxjufur/4AJiJOIQKNWldofgZ86WxLD9okXSme5t8zrhXnFGX7pYVnX8+Y3RM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=IHdzH6/7; arc=fail smtp.client-ip=40.107.223.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gCccnwRW3fjLahBHYVw+c+4+kY3Y5HxYxlkL4mqKKfVGeEEWXWKv71Gro4kAHqPjgkr+1cG9lfywPjxe3FRHm6sDLI0d3a6v/ou8ss34eMa96pamzwxVoenRZBA6T0Xey5oCp1oyJv+DeSEUKuD5coksCIs+WAUy5XpDnOUgwoQwXbXovvjMVCskfKg+byRmaucKnxcXgog1iCCMQID/osYvuJ+/wINcCuE6AovVe+JykV0Jr3+U41cNufVh3+1V/kvfRSH7HF1XINtk2Tr0Pc4bP9FZ16pcyr4CJaAQwqfnJ7BhnBWIzJPTsfvzQ7kTriPPOBMNPuQpMXLYgc86DQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBQhXSIf5/bV10qJtYQEWvygY5ww87h3UADznhCFS14=;
 b=L5OXYvLuM623l8vmQ1fXIgO/xUMrGKWLQaNsCHU1JASr4VcV29IhlG/ID1M1os/zRdgQ2u5Y68dZoe0FWqiE09TRQoWU9HvXyKywWNd+6dsrIWY76yYo0avsrwEUuNXpWPsnUFDTOVGBZRhD/izPHR/vtqm5utljrjQWVCydhoVwRxvgdjO7Wroba1dykUC9GalDQONM7V18OrpvG3kBcrpVo6jZi85kLWtxKWrtQp80Ve2KESNaP8CVqlPQc2vqBChJ1sx3MJcm/fLDdqXIQPPP3z7JQ7efUr9NaFhlqFmYIR7eOCH1XXZgPrEA0XOyzD3mFhq0OlQF6WKwN3m35g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=linux.intel.com smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBQhXSIf5/bV10qJtYQEWvygY5ww87h3UADznhCFS14=;
 b=IHdzH6/7J0glGFeKrinC5LZm8/9yBbChp2cC+GCYIrqkBsOFlNsX3ZS9Hj/YJ53Y8YhFpvD6Bc1h46Eeo7evhBEwFP1n9lZVg9yt5jpck+AqEh1OpH7ofkYNWbWCPHPb9GPuEtGgPTv1C7+nIWjdixVZcDJacMl5TfrUUV/Shl8=
Received: from CH0PR03CA0247.namprd03.prod.outlook.com (2603:10b6:610:e5::12)
 by MW4PR12MB6828.namprd12.prod.outlook.com (2603:10b6:303:209::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Tue, 21 May
 2024 21:50:08 +0000
Received: from CH2PEPF00000141.namprd02.prod.outlook.com
 (2603:10b6:610:e5:cafe::8f) by CH0PR03CA0247.outlook.office365.com
 (2603:10b6:610:e5::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.19 via Frontend
 Transport; Tue, 21 May 2024 21:50:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH2PEPF00000141.mail.protection.outlook.com (10.167.244.74) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7611.14 via Frontend Transport; Tue, 21 May 2024 21:50:07 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 21 May
 2024 16:50:07 -0500
Date: Tue, 21 May 2024 16:49:52 -0500
From: Michael Roth <michael.roth@amd.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <seanjc@google.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v15 09/20] KVM: SEV: Add support to handle MSR based Page
 State Change VMGEXIT
Message-ID: <rczrxq3lhqguarwh4cwxwa35j5riiagbilcw32oaxd7aqpyaq7@6bqrqn6ontba>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240501085210.2213060-10-michael.roth@amd.com>
 <84e8460d-f8e7-46d7-a274-90ea7aec2203@linux.intel.com>
 <CABgObfaXmMUYHEuK+D+2E9pybKMJqGZsKB033X1aOSQHSEqqVA@mail.gmail.com>
 <7d6a4320-89f5-48ce-95ff-54b00e7e9597@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7d6a4320-89f5-48ce-95ff-54b00e7e9597@linux.intel.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH2PEPF00000141:EE_|MW4PR12MB6828:EE_
X-MS-Office365-Filtering-Correlation-Id: a71eca91-3d01-41f5-8e37-08dc79dffb2e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|82310400017|1800799015|36860700004|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?aVk2K0VhTVZ0OHN5WFExYWFuVlRySFRrZHdCa0g2VmthZk84SXNFSTdxVE9N?=
 =?utf-8?B?MW5PUzZhek5rTzA4MHJKU1Raclp6bzdNc0l1c3hjUjlFZFdMa0lUS0szTXo5?=
 =?utf-8?B?c3NXVmxja0NDdnF5TDhuc1A3SlhJdys1cFlhNS9EZ0pOTk9aSzY2UzIreDZE?=
 =?utf-8?B?VVM1S3BMaGZJbEVhbGVFbVkwRERtQmJMQXFtUnRtSTFvQmZkZmplN2g5UmRH?=
 =?utf-8?B?L2E2dWZ2QmZaN0NaSGZEVnJaRC80RzdRc3YyT3cxemZRS2MrOE1LdTJ2RU9Y?=
 =?utf-8?B?cC9WMmgwc1JOelg3NVpTdGhQa25LdGVGTFI5TXBmdy9VaDZsOWFjZUZ2NnNm?=
 =?utf-8?B?cFpaZmNlT0pLSitsSWlPM1hDRlVwdVY3MCs5VVorWEVicTd2anYrQ1owYXM5?=
 =?utf-8?B?anRTWlBPV2ZNV2hRYlB0Vkc4QXRoSDM2SlFpMWFqOTFEZ2JFYitKenBCRDVk?=
 =?utf-8?B?ZDBST1VSa0hXS2hXcTNFS2tOZ3FyNmhpUXo1U2l3WGpodmhvRExYTWtyNUtO?=
 =?utf-8?B?aGFlbTBMVTdTeXlnRkhQSUFrV1hlZkNlUGxuUE8wOE1PY0ZDSFNRSzRlSnRQ?=
 =?utf-8?B?U0JDREFLRWJSYXR6cjgzenZBU0NzMHArSEtZTkdSdUhvaXNoWFYvN3Bva1ZX?=
 =?utf-8?B?WGlQRmhHWi9GVGJtTTB4V243YW9tb3NkU0QxWGFDVFRPRjFMSjBMM3VQakdx?=
 =?utf-8?B?MU42N2R2b0pVdG5vTUgvMHZmYjlZK0xCanorWmlBcjI2YTA4RGxHcUdZZ3Vl?=
 =?utf-8?B?eFhBejFGaGJHd1c2Y2RQd2g2cU9waGYyTlAxSWtaZGRsamdROWt3cWNick5x?=
 =?utf-8?B?SjhDZnhDalQwRHFtQVZxMWpDR3JDZzI2UTZSeGFvOThtRk8xMEQ0Uk1hb1dy?=
 =?utf-8?B?clIzTjYxS0FvVG1qdGpjTkptdVJma3NUY2lyaW1obTJyZmtPdTJrTUF3Mk9x?=
 =?utf-8?B?N2RMY2pVOWJ4elI5Wnh3Ty9mUWJnMHJUM2V3YjlvUkN3QzRSN0xYd0JHSVk3?=
 =?utf-8?B?K3Bqczg1Yll3SXR1YUhnWkVaV2NFYXRmemZpeEpBSTNaanNPSHdaalZ3dEtC?=
 =?utf-8?B?WE9XbW5nVkV2dDkrOWNLc1YvRnBNRE1UYnoyWmFtdXV2OXZYMWFPaDQzbEFE?=
 =?utf-8?B?K2ZvZllBT1ZLbWZ1WnhkVFhNYmxwZ2pEeWtMQmxYVFVBWFdoWlFUWGVOY2pq?=
 =?utf-8?B?QjRUMEw5WC9hUGZvc1N3TGVFaVN6NWRVbXFhczdsaVM3Yy96Sks3Wml0ZXM4?=
 =?utf-8?B?NWFCMkVISmVvdlprYmZRQncxdFRCTEE0bmo3Z2YzWTZtNmtqdVJNWUxTc2hV?=
 =?utf-8?B?aWRmQmlBMXJkaHBXTkVRNW94c00rOUtzalVDOWYxSytCUUFDWDUxcWhESkJN?=
 =?utf-8?B?ZjRIa1ZZUnFzd2pybXpsTUVZL1cwbmRxVlE3OFEvSHoyVTJ2TXM2aTIraEJm?=
 =?utf-8?B?aG5RRGNEZ1VTbHJPUWNCbUc1eUVWQTUwVmY2SU5uOW5OMlM3MEhFRUVzWU1x?=
 =?utf-8?B?RWdXcUNCcXhQbUlMRzR4dnZZYmpKbmx5dmt6a0pKVUt2VnJXVVBQRzNMdTMz?=
 =?utf-8?B?dS83SW9IZGVSeFJqYTdHZFJEYTArU2EwVkVjRU9JZnJRZHE2Zk4vYyt4Nlo4?=
 =?utf-8?B?cUR2SUUvaHlSbm9GSzVXbVdpZ0hPcXpUd2VCQkw4d0hnU1A3NlpKcFNYU2Vm?=
 =?utf-8?B?dWphb2hIcnRrbDRYYndrTm91TW8wYU9zbFk0SDV4TloyeUs5SEF6QnhLWXVp?=
 =?utf-8?Q?ZhXQ+PGBq9xymVsVG098wwA48OAASNKBs4YIBdK?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(82310400017)(1800799015)(36860700004)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 21:50:07.7943
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a71eca91-3d01-41f5-8e37-08dc79dffb2e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH2PEPF00000141.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6828

On Tue, May 21, 2024 at 08:49:59AM +0800, Binbin Wu wrote:
> 
> 
> On 5/17/2024 1:23 AM, Paolo Bonzini wrote:
> > On Thu, May 16, 2024 at 10:29 AM Binbin Wu <binbin.wu@linux.intel.com> wrote:
> > > 
> > > 
> > > On 5/1/2024 4:51 PM, Michael Roth wrote:
> > > > SEV-SNP VMs can ask the hypervisor to change the page state in the RMP
> > > > table to be private or shared using the Page State Change MSR protocol
> > > > as defined in the GHCB specification.
> > > > 
> > > > When using gmem, private/shared memory is allocated through separate
> > > > pools, and KVM relies on userspace issuing a KVM_SET_MEMORY_ATTRIBUTES
> > > > KVM ioctl to tell the KVM MMU whether or not a particular GFN should be
> > > > backed by private memory or not.
> > > > 
> > > > Forward these page state change requests to userspace so that it can
> > > > issue the expected KVM ioctls. The KVM MMU will handle updating the RMP
> > > > entries when it is ready to map a private page into a guest.
> > > > 
> > > > Use the existing KVM_HC_MAP_GPA_RANGE hypercall format to deliver these
> > > > requests to userspace via KVM_EXIT_HYPERCALL.
> > > > 
> > > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > > Co-developed-by: Brijesh Singh <brijesh.singh@amd.com>
> > > > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > > > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > > > ---
> > > >    arch/x86/include/asm/sev-common.h |  6 ++++
> > > >    arch/x86/kvm/svm/sev.c            | 48 +++++++++++++++++++++++++++++++
> > > >    2 files changed, 54 insertions(+)
> > > > 
> > > > diff --git a/arch/x86/include/asm/sev-common.h b/arch/x86/include/asm/sev-common.h
> > > > index 1006bfffe07a..6d68db812de1 100644
> > > > --- a/arch/x86/include/asm/sev-common.h
> > > > +++ b/arch/x86/include/asm/sev-common.h
> > > > @@ -101,11 +101,17 @@ enum psc_op {
> > > >        /* GHCBData[11:0] */                            \
> > > >        GHCB_MSR_PSC_REQ)
> > > > 
> > > > +#define GHCB_MSR_PSC_REQ_TO_GFN(msr) (((msr) & GENMASK_ULL(51, 12)) >> 12)
> > > > +#define GHCB_MSR_PSC_REQ_TO_OP(msr) (((msr) & GENMASK_ULL(55, 52)) >> 52)
> > > > +
> > > >    #define GHCB_MSR_PSC_RESP           0x015
> > > >    #define GHCB_MSR_PSC_RESP_VAL(val)                  \
> > > >        /* GHCBData[63:32] */                           \
> > > >        (((u64)(val) & GENMASK_ULL(63, 32)) >> 32)
> > > > 
> > > > +/* Set highest bit as a generic error response */
> > > > +#define GHCB_MSR_PSC_RESP_ERROR (BIT_ULL(63) | GHCB_MSR_PSC_RESP)
> > > > +
> > > >    /* GHCB Hypervisor Feature Request/Response */
> > > >    #define GHCB_MSR_HV_FT_REQ          0x080
> > > >    #define GHCB_MSR_HV_FT_RESP         0x081
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index e1ac5af4cb74..720775c9d0b8 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -3461,6 +3461,48 @@ static void set_ghcb_msr(struct vcpu_svm *svm, u64 value)
> > > >        svm->vmcb->control.ghcb_gpa = value;
> > > >    }
> > > > 
> > > > +static int snp_complete_psc_msr(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +     struct vcpu_svm *svm = to_svm(vcpu);
> > > > +
> > > > +     if (vcpu->run->hypercall.ret)
> > > Do we have definition of ret? I didn't find clear documentation about it.
> > > According to the code, 0 means succssful. Is there any other error codes
> > > need to or can be interpreted?
> > They are defined in include/uapi/linux/kvm_para.h
> > 
> > #define KVM_ENOSYS        1000
> > #define KVM_EFAULT        EFAULT /* 14 */
> > #define KVM_EINVAL        EINVAL /* 22 */
> > #define KVM_E2BIG        E2BIG /* 7 */
> > #define KVM_EPERM        EPERM /* 1*/
> > #define KVM_EOPNOTSUPP        95
> > 
> > Linux however does not expect the hypercall to fail for SEV/SEV-ES; and
> > it will terminate the guest if the PSC operation fails for SEV-SNP.  So
> > it's best for userspace if the hypercall always succeeds. :)
> Thanks for the info.
> 
> For TDX, it wants to restrict the size of memory range for conversion in one
> hypercall to avoid a too long latency.
> Previously, in TDX QEMU patchset v5, the limitation is in userspace and  if
> the size is too big, the status_code will set to TDG_VP_VMCALL_RETRY and the
> failed GPA for guest to retry is updated.
> https://lore.kernel.org/all/20240229063726.610065-51-xiaoyao.li@intel.com/
> 
> When TDX converts TDVMCALL_MAP_GPA to KVM_HC_MAP_GPA_RANGE, do you think
> which is more reasonable to set the restriction? In KVM (TDX specific code)
> or userspace?
> If userspace is preferred, then the interface needs to  be extended to
> support it.

With SNP we might get a batch of requests in a single GHCB request, and
potentially each of those requests need to get set out to userspace as 
a single KVM_HC_MAP_GPA_RANGE. The subsequent patch here handles that in
a loop by issuing a new KVM_HC_MAP_GPA_RANGE via the completion handler.
So we also sort of need to split large requests into multiple userspace
requests in some cases.

It seems like TDX should be able to do something similar by limiting the
size of each KVM_HC_MAP_GPA_RANGE to TDX_MAP_GPA_MAX_LEN, and then
returning TDG_VP_VMCALL_RETRY to guest if the original size was greater
than TDX_MAP_GPA_MAX_LEN. But at that point you're effectively done with
the entire request and can return to guest, so it actually seems a little
more straightforward than the SNP case above. E.g. TDX has a 1:1 mapping
between TDG_VP_VMCALL_MAP_GPA and KVM_HC_MAP_GPA_RANGE events. (And even
similar names :))

So doesn't seem like there's a good reason to expose any of these
throttling details to userspace, in which case existing
KVM_HC_MAP_GPA_RANGE interface seems like it should be sufficient.

-Mike

> 
> 
> > 
> > > For TDX, it may also want to use KVM_HC_MAP_GPA_RANGE hypercall  to
> > > userspace via KVM_EXIT_HYPERCALL.
> > Yes, definitely.
> > 
> > Paolo
> > 
> 

