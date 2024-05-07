Return-Path: <kvm+bounces-16915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 452EF8BEB71
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 20:20:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 77365B292BE
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 18:15:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C88A16D4D2;
	Tue,  7 May 2024 18:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="qvYlQiun"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2041.outbound.protection.outlook.com [40.107.100.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F250316C85B;
	Tue,  7 May 2024 18:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715105690; cv=fail; b=osrnyVD+ZrIXZLDwU8Y3P+9cNEyq3UHPRxmNMBjpvPJV0DpJwllkuoJDyXIR1O3vJsKdkQnE4BFbr/J2vbk5N9xGOwGlKc76PNcYzqqasrV2bW5Ap8MK/ok39O5J+6F9mM7z16j2AAIdPM1DW8blynSF2/XlDSJZiYrfCzC7s64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715105690; c=relaxed/simple;
	bh=rltPwjkF6vOIgBX4yohgsqyMrQDEirZOFL2JEGlO8Is=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eFEvAO+xIU5GBaJsGwtT24u0K7zbso4c/G/4oy31ygxEEj5384Dpfw7y0Heip1vUftub+efLWysZy8/DfGgI8YVxoX/r8/85JNZAJLNddws1x+a+YyPhkQ6WZ+p+egjY/0ZzUqbKIPgJIt2MGNMsTVMizhjklo47Qbm7F6pnPdM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=qvYlQiun; arc=fail smtp.client-ip=40.107.100.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ht3eYCVWalQM19L0PGMIqnOo+R8+zL3naj8rnF4Aj0F1enCVrfZ8IYmomYHT8xu4o3FF3KdzQCmpSxhL0iZd9KMho2kj+2MPxCBxHG6C0d79CU+w3RrX30nfg2glXrOMminSGi7z843KmvPLqQ4qQUo1+t6JcZ+C0UO7rPc4Ycg/i0+p8qnXhEiMtzAZ3ZQMhOL0pxz4sKa1CzRH564pXdyr3W0bRHoHx+01kBS06xj82F5GdorTONAEPm3GawPc6D+2f/OSI2cBPYjFJJQyt6CPYf5UYIqRzxV0qPLr9JbqpFKsvGwD99g0m3KLzeX+Gx+20Qj8tWK2HEkV8oFstw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jLwvueRnGTIdWxtEDAUjwYk+kPEScTuEONmCZRwE3ic=;
 b=jxnjOW+5XtjoZm8nCbnkpthB5vP2nLM10rvxDqVbsddwE2SpQG6PGvl4xbmD99TRyjwU7MR1oxzhRmSHAJG8gYj2ZeQ+w5s3GXKw2ctldb2+/rz1d5CGmepB+kN45Xd5jjZ4VB7wy0dMWW3leHlk0a8fa9ggg6cjGHyG6t+i46PWEPeu8t0n8AMOjRhFTA0WtwKgPcc7gac9BKKQvmEpF9dNvWi/gtRvOUe6wDvTtO2fRO4XfhgDviBvrI7PoGmBkC0zy+F00zulVHzwGC/RG9epsiWhY1RfB1MOMhqQicaQmFa9wgD6/cASKHQ7FPGchuCzATDuD2yL3mZ7Ki+inw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jLwvueRnGTIdWxtEDAUjwYk+kPEScTuEONmCZRwE3ic=;
 b=qvYlQiun2OwMc33Mc/JLl/+RJvsIEI5TQuEJSuVbzGoi+yGmoHquSwwrG8Kgln+lwcv/RLYTOMWYWExLMvu3UvLrIGKAwqOyT9dUTW2wCjCwBNWF74SWxPyx4MrBEQ6AuSKPSCTF3HC46g2jtg0VYFTa+xmk9p/EcTjTKMfOSBg=
Received: from BN9P222CA0004.NAMP222.PROD.OUTLOOK.COM (2603:10b6:408:10c::9)
 by MN2PR12MB4407.namprd12.prod.outlook.com (2603:10b6:208:260::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.42; Tue, 7 May
 2024 18:14:43 +0000
Received: from BN1PEPF00004680.namprd03.prod.outlook.com
 (2603:10b6:408:10c:cafe::61) by BN9P222CA0004.outlook.office365.com
 (2603:10b6:408:10c::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.39 via Frontend
 Transport; Tue, 7 May 2024 18:14:43 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN1PEPF00004680.mail.protection.outlook.com (10.167.243.85) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Tue, 7 May 2024 18:14:43 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Tue, 7 May
 2024 13:14:41 -0500
Date: Tue, 7 May 2024 13:14:24 -0500
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
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v15 00/20] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <20240507181424.agek6zqdv6mu2eq5@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <CABgObfbvAU-hGzO59x1ucjOGqx0Yor0HovQBNBR2sysngmk4=Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfbvAU-hGzO59x1ucjOGqx0Yor0HovQBNBR2sysngmk4=Q@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN1PEPF00004680:EE_|MN2PR12MB4407:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a4efa29-8d9e-4c6f-4592-08dc6ec191ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|82310400017|36860700004|1800799015|376005|7416005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?NW1iakViNU5ROEhKc2xCQUJ6bEYvYUNUUThXelBYTUtneVRCWjFwWENjMTFP?=
 =?utf-8?B?WlJsUTlRM1J6di95ZW5uaDkyaFBXSE1HVFZuWDBKam9Sdm5vRmNGM3p3VGRE?=
 =?utf-8?B?ZWV5ZFRRZ1hlUUJjbXRmOXlDYXVXbVBRWlg2TnpDRW5QNnJnVFR0VEY3cERm?=
 =?utf-8?B?cGhqTmkvWFJVWkIwZGZYL3g2VGRjN3RTc2hzbXhVYXFsQ0dOQXlrbGJ0cXpp?=
 =?utf-8?B?eStuMEQxbG1FTWxKRi9lQ2FPNzBhNFg2NFY5WnYya0ovdG5BSlRaamFzMUNS?=
 =?utf-8?B?L0o5MDdsQVpSbTZ4Qm1mbUNFaHRjZGF1b0FrdmdmMWw1eitUbzVyYnpaYVFC?=
 =?utf-8?B?Q044dEE5MlVlN3hqWjcwaHArbUYyclJxdExuYWJJYllLNnBEMFZLL0wzWkhN?=
 =?utf-8?B?UzdVWmMvR2w5U3pQVWRWMVRDem1UNysvbW9SQ0FlVkN4bzIrQzZhd0h4Ukgw?=
 =?utf-8?B?a1pmYUZudnROWjF5alA5WFU3SWNQRUdoUVZEMVh3TkJUaUZXbUpVR3Y5Q0NS?=
 =?utf-8?B?b1lTQkg5SlpXQURsSFNrQkdZbnFnanFGa0dMSEp5Z2tGNVNsd3p6bFYvMmx0?=
 =?utf-8?B?bnNNSmdSR1pKZnRhazYxMCt5dlUrcVV5eWxvWlRNR25iamU3OGw5TGp4VEQ0?=
 =?utf-8?B?NGZlRnE2bldtSkZLQW4vYTIvVXlmakRiSG1LS2JtVjF0N0JyaHFRMndVaUh2?=
 =?utf-8?B?bFdvYjhVNEhFbHRyOVJnbHlGZ0MzazN2eGJsakM0K25JQ3pMTFpzQTlIdmZ6?=
 =?utf-8?B?Q25Id29SdlpCQ2FmSUpVVThTZFcya01NYkhtb1RtaWtoL0ZybXFYa25OSm1P?=
 =?utf-8?B?blNLMHhGeG0yK1pzazUvUmNkVXZEMmNYSG5qZnYvNXRCbyswR2d1cFNPL3VG?=
 =?utf-8?B?bU1EOWdVR0diNytnK2RONGxqdjlaS1Yza0I4bk1YanZ4REVOalRTWVUyeWdS?=
 =?utf-8?B?NWJTWmFoQWNQck1tOVJKKzh6bkFnQm9FWmNaUkRmOUFDbFFnNTV0cHRrMEtJ?=
 =?utf-8?B?bWZuUStJVFd2S2lXeDE4Mlh4akdlUTZFVFhwd002RWZWdTJhSk1pZjRZbHpy?=
 =?utf-8?B?VGJjSyswQzdQS0NvRmlXb3hRSHBLdTBKcWpveWxCUk03WXpwM2ZGMzBibXR5?=
 =?utf-8?B?VUVMSlRwQytLNlU4eWFuQjNkQWJ2d2tVSjFPeDdmUnVsa0Fwcms5RUxZZkRK?=
 =?utf-8?B?K0lOQUlOUWljY3Q5WndtN08ybzF4aGdiSFIzWDl2YmNaZm54SndRckVzK1N6?=
 =?utf-8?B?U2xmamt4Z0NaTzN2WUkvOG0wNWJRSzdWNzVGVENMWkhjaUhFYUN6N2E3b1F6?=
 =?utf-8?B?Mk82Y1UyaEY3b1QwZXVCU3c5ZVVwbSsyUVJiTTVZSTNsNjlPdG5ScU9HQTFR?=
 =?utf-8?B?Q1ZscUh1aGNPaU9VK1k3VU1STjlVTnV3ZWJMR1B6alladXduMkdScmpVNHZJ?=
 =?utf-8?B?VWZ6T1V1b2hUajBGZURKOVE2Q2czUlR6SEZUUGEyU0ZLRk5YTFRncEg5TDls?=
 =?utf-8?B?RjQ0ZksrbkNpSE9yMVFRZytFa2tXWExjUDYvVEtCQ3dIQWozeHRHSjMxWXBn?=
 =?utf-8?B?S3dGQVIvSEVtbmhNL3JYU0crNDQ2ZmgzcWQ3WnN4R245Y0RIMDlVSTdhcTgr?=
 =?utf-8?B?MWlEMGlUUGo2UW5KQmlTYWlxSTlpSGFmcFM1UWQ3aVJ5VTNSYXI4ZmVZc0tD?=
 =?utf-8?B?UDJQcFpNbjBVdVludGlCWGJGOGhhSzhxYVdyMk1tZ2FPZ0k1aHJJTDM0WEM3?=
 =?utf-8?B?K1o5bDAwaFQvdUd0K3RMODZCeTIveFIzTmtmSndVNmhqWTNPVzBOZ29qVCtS?=
 =?utf-8?B?VXJVWjQrUkFkRGI1Z2NVQT09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(82310400017)(36860700004)(1800799015)(376005)(7416005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 18:14:43.5132
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a4efa29-8d9e-4c6f-4592-08dc6ec191ed
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BN1PEPF00004680.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4407

On Tue, May 07, 2024 at 08:04:50PM +0200, Paolo Bonzini wrote:
> On Wed, May 1, 2024 at 11:03 AM Michael Roth <michael.roth@amd.com> wrote:
> >
> > This patchset is also available at:
> >
> >   https://github.com/amdese/linux/commits/snp-host-v15
> >
> > and is based on top of the series:
> >
> >   "Add SEV-ES hypervisor support for GHCB protocol version 2"
> >   https://lore.kernel.org/kvm/20240501071048.2208265-1-michael.roth@amd.com/
> >   https://github.com/amdese/linux/commits/sev-init2-ghcb-v1
> >
> > which in turn is based on commit 20cc50a0410f (just before v14 SNP patches):
> >
> >   https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue
> 
> I have mostly reviewed this, with the exception of the
> snp_begin/complete_psc parts.

Thanks Paolo. We actually recently uncovered some issues with
snp_begin/complete_psc using some internal kvm-unit-tests that exercise
some edge cases, so I would hold off on reviewing that. Will send a
fix-up patch today after a bit more testing.

> 
> I am not sure about removing all the pr_debug() - I am sure it will be
> a bit more painful for userspace developers to figure out what exactly
> has gone wrong in some cases. But we can add them later, if needed -
> I'm certainly not going to make a fuss about it.

Yah, they do tend to be useful for that purpose. I think if we do add
them back we can consolidate the information a little better versus what
I had previously.

-Mike

> 
> Paolo
> 
> 
> > Patch Layout
> > ------------
> >
> > 01-02: These patches revert+replace the existing .gmem_validate_fault hook
> >        with a similar .private_max_mapping_level as suggested by Sean[1]
> >
> > 03-04: These patches add some basic infrastructure and introduces a new
> >        KVM_X86_SNP_VM vm_type to handle differences verses the existing
> >        KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
> >
> > 05-07: These implement the KVM API to handle the creation of a
> >        cryptographic launch context, encrypt/measure the initial image
> >        into guest memory, and finalize it before launching it.
> >
> > 08-12: These implement handling for various guest-generated events such
> >        as page state changes, onlining of additional vCPUs, etc.
> >
> > 13-16: These implement the gmem/mmu hooks needed to prepare gmem-allocated
> >        pages before mapping them into guest private memory ranges as
> >        well as cleaning them up prior to returning them to the host for
> >        use as normal memory. Because this supplants certain activities
> >        like issued WBINVDs during KVM MMU invalidations, there's also
> >        a patch to avoid duplicating that work to avoid unecessary
> >        overhead.
> >
> > 17:    With all the core support in place, the patch adds a kvm_amd module
> >        parameter to enable SNP support.
> >
> > 18-20: These patches all deal with the servicing of guest requests to handle
> >        things like attestation, as well as some related host-management
> >        interfaces.
> >
> > [1] https://lore.kernel.org/kvm/ZimnngU7hn7sKoSc@google.com/#t
> >
> >
> > Testing
> > -------
> >
> > For testing this via QEMU, use the following tree:
> >
> >   https://github.com/amdese/qemu/commits/snp-v4-wip3c
> >
> > A patched OVMF is also needed due to upstream KVM no longer supporting MMIO
> > ranges that are mapped as private. It is recommended you build the AmdSevX64
> > variant as it provides the kernel-hashing support present in this series:
> >
> >   https://github.com/amdese/ovmf/commits/apic-mmio-fix1d
> >
> > A basic command-line invocation for SNP would be:
> >
> >  qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
> >   -machine q35,confidential-guest-support=sev0,memory-backend=ram1
> >   -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
> >   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=
> >   -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd
> >
> > With kernel-hashing and certificate data supplied:
> >
> >  qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
> >   -machine q35,confidential-guest-support=sev0,memory-backend=ram1
> >   -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
> >   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=,certs-path=/home/mroth/cert.blob,kernel-hashes=on
> >   -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d-AmdSevX64.fd
> >   -kernel /boot/vmlinuz-$ver
> >   -initrd /boot/initrd.img-$ver
> >   -append "root=UUID=d72a6d1c-06cf-4b79-af43-f1bac4f620f9 ro console=ttyS0,115200n8"
> >
> > With standard X64 OVMF package with separate image for persistent NVRAM:
> >
> >  qemu-system-x86_64 -smp 32,maxcpus=255 -cpu EPYC-Milan-v2
> >   -machine q35,confidential-guest-support=sev0,memory-backend=ram1
> >   -object memory-backend-memfd,id=ram1,size=4G,share=true,reserve=false
> >   -object sev-snp-guest,id=sev0,cbitpos=51,reduced-phys-bits=1,id-auth=
> >   -bios OVMF_CODE-upstream-20240410-apic-mmio-fix1d.fd
> >   -drive if=pflash,format=raw,unit=0,file=OVMF_VARS-upstream-20240410-apic-mmio-fix1d.fd,readonly=off
> >
> >
> > Known issues / TODOs
> > --------------------
> >
> >  * Base tree in some cases reports "Unpatched return thunk in use. This should
> >    not happen!" the first time it runs an SVM/SEV/SNP guests. This a recent
> >    regression upstream and unrelated to this series:
> >
> >      https://lore.kernel.org/linux-kernel/CANpmjNOcKzEvLHoGGeL-boWDHJobwfwyVxUqMq2kWeka3N4tXA@mail.gmail.com/T/
> >
> >  * 2MB hugepage support has been dropped pending discussion on how we plan to
> >    re-enable it in gmem.
> >
> >  * Host kexec should work, but there is a known issue with host kdump support
> >    while SNP guests are running that will be addressed as a follow-up.
> >
> >  * SNP kselftests are currently a WIP and will be included as part of SNP
> >    upstreaming efforts in the near-term.
> >
> >
> > SEV-SNP Overview
> > ----------------
> >
> > This part of the Secure Encrypted Paging (SEV-SNP) series focuses on the
> > changes required to add KVM support for SEV-SNP. This series builds upon
> > SEV-SNP guest support, which is now in mainline, and and SEV-SNP host
> > initialization support, which is now in linux-next.
> >
> > While series provides the basic building blocks to support booting the
> > SEV-SNP VMs, it does not cover all the security enhancement introduced by
> > the SEV-SNP such as interrupt protection, which will added in the future.
> >
> > With SNP, when pages are marked as guest-owned in the RMP table, they are
> > assigned to a specific guest/ASID, as well as a specific GFN with in the
> > guest. Any attempts to map it in the RMP table to a different guest/ASID,
> > or a different GFN within a guest/ASID, will result in an RMP nested page
> > fault.
> >
> > Prior to accessing a guest-owned page, the guest must validate it with a
> > special PVALIDATE instruction which will set a special bit in the RMP table
> > for the guest. This is the only way to set the validated bit outside of the
> > initial pre-encrypted guest payload/image; any attempts outside the guest to
> > modify the RMP entry from that point forward will result in the validated
> > bit being cleared, at which point the guest will trigger an exception if it
> > attempts to access that page so it can be made aware of possible tampering.
> >
> > One exception to this is the initial guest payload, which is pre-validated
> > by the firmware prior to launching. The guest can use Guest Message requests
> > to fetch an attestation report which will include the measurement of the
> > initial image so that the guest can verify it was booted with the expected
> > image/environment.
> >
> > After boot, guests can use Page State Change requests to switch pages
> > between shared/hypervisor-owned and private/guest-owned to share data for
> > things like DMA, virtio buffers, and other GHCB requests.
> >
> > In this implementation of SEV-SNP, private guest memory is managed by a new
> > kernel framework called guest_memfd (gmem). With gmem, a new
> > KVM_SET_MEMORY_ATTRIBUTES KVM ioctl has been added to tell the KVM
> > MMU whether a particular GFN should be backed by shared (normal) memory or
> > private (gmem-allocated) memory. To tie into this, Page State Change
> > requests are forward to userspace via KVM_EXIT_VMGEXIT exits, which will
> > then issue the corresponding KVM_SET_MEMORY_ATTRIBUTES call to set the
> > private/shared state in the KVM MMU.
> >
> > The gmem / KVM MMU hooks implemented in this series will then update the RMP
> > table entries for the backing PFNs to set them to guest-owned/private when
> > mapping private pages into the guest via KVM MMU, or use the normal KVM MMU
> > handling in the case of shared pages where the corresponding RMP table
> > entries are left in the default shared/hypervisor-owned state.
> >
> > Feedback/review is very much appreciated!
> >
> > -Mike
> >
> >
> > Changes since v14:
> >
> >  * switch to vendor-agnostic KVM_HC_MAP_GPA_RANGE exit for forwarding
> >    page-state change requests to userspace instead of an SNP-specific exit
> >    (Sean)
> >  * drop SNP_PAUSE_ATTESTATION/SNP_RESUME_ATTESTATION interfaces, instead
> >    add handling in KVM_EXIT_VMGEXIT so that VMMs can implement their own
> >    mechanisms for keeping userspace-supplied certificates in-sync with
> >    firmware's TCB/endorsement key (Sean)
> >  * carve out SEV-ES-specific handling for GHCB protocol 2, add control of
> >    the protocol version, and post as a separate prereq patchset (Sean)
> >  * use more consistent error-handling in snp_launch_{start,update,finish},
> >    simplify logic based on review comments (Sean)
> >  * rename .gmem_validate_fault to .private_max_mapping_level and rework
> >    logic based on review suggestions (Sean)
> >  * reduce number of pr_debug()'s in series, avoid multiple WARN's in
> >    succession (Sean)
> >  * improve documentation and comments throughout
> >
> > Changes since v13:
> >
> >  * rebase to new kvm-coco-queue and wire up to PFERR_PRIVATE_ACCESS (Paolo)
> >  * handle setting kvm->arch.has_private_mem in same location as
> >    kvm->arch.has_protected_state (Paolo)
> >  * add flags and additional padding fields to
> >    snp_launch{start,update,finish} APIs to address alignment and
> >    expandability (Paolo)
> >  * update snp_launch_update() to update input struct values to reflect
> >    current progress of command in situations where mulitple calls are
> >    needed (Paolo)
> >  * update snp_launch_update() to avoid copying/accessing 'src' parameter
> >    when dealing with zero pages. (Paolo)
> >  * update snp_launch_update() to use u64 as length input parameter instead
> >    of u32 and adjust padding accordingly
> >  * modify ordering of SNP_POLICY_MASK_* definitions to be consistent with
> >    bit order of corresponding flags
> >  * let firmware handle enforcement of policy bits corresponding to
> >    user-specified minimum API version
> >  * add missing "0x" prefixs in pr_debug()'s for snp_launch_start()
> >  * fix handling of VMSAs during in-place migration (Paolo)
> >
> > Changes since v12:
> >
> >  * rebased to latest kvm-coco-queue branch (commit 4d2deb62185f)
> >  * add more input validation for SNP_LAUNCH_START, especially for handling
> >    things like MBO/MBZ policy bits, and API major/minor minimums. (Paolo)
> >  * block SNP KVM instances from being able to run legacy SEV commands (Paolo)
> >  * don't attempt to measure VMSA for vcpu 0/BSP before the others, let
> >    userspace deal with the ordering just like with SEV-ES (Paolo)
> >  * fix up docs for SNP_LAUNCH_FINISH (Paolo)
> >  * introduce svm->sev_es.snp_has_guest_vmsa flag to better distinguish
> >    handling for guest-mapped vs non-guest-mapped VMSAs, rename
> >    'snp_ap_create' flag to 'snp_ap_waiting_for_reset' (Paolo)
> >  * drop "KVM: SEV: Use a VMSA physical address variable for populating VMCB"
> >    as it is no longer needed due to above VMSA rework
> >  * replace pr_debug_ratelimited() messages for RMP #NPFs with a single trace
> >    event
> >  * handle transient PSMASH_FAIL_INUSE return codes in kvm_gmem_invalidate(),
> >    switch to WARN_ON*()'s to indicate remaining error cases are not expected
> >    and should not be seen in practice. (Paolo)
> >  * add a cond_resched() in kvm_gmem_invalidate() to avoid soft lock-ups when
> >    cleaning up large guest memory ranges.
> >  * rename VLEK_REQUIRED to VCEK_DISABLE. it's be more applicable if another
> >    key type ever gets added.
> >  * don't allow attestation to be paused while an attestation request is
> >    being processed by firmware (Tom)
> >  * add missing Documentation entry for SNP_VLEK_LOAD
> >  * collect Reviewed-by's from Paolo and Tom
> >
> >
> > ----------------------------------------------------------------
> > Ashish Kalra (1):
> >       KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
> >
> > Brijesh Singh (8):
> >       KVM: SEV: Add initial SEV-SNP support
> >       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
> >       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
> >       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
> >       KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
> >       KVM: SEV: Add support to handle RMP nested page faults
> >       KVM: SVM: Add module parameter to enable SEV-SNP
> >       KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
> >
> > Michael Roth (10):
> >       Revert "KVM: x86: Add gmem hook for determining max NPT mapping level"
> >       KVM: x86: Add hook for determining max NPT mapping level
> >       KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
> >       KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
> >       KVM: SEV: Add support to handle Page State Change VMGEXIT
> >       KVM: SEV: Implement gmem hook for initializing private pages
> >       KVM: SEV: Implement gmem hook for invalidating private pages
> >       KVM: x86: Implement hook for determining max NPT mapping level
> >       KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
> >       crypto: ccp: Add the SNP_VLEK_LOAD command
> >
> > Tom Lendacky (1):
> >       KVM: SEV: Support SEV-SNP AP Creation NAE event
> >
> >  Documentation/virt/coco/sev-guest.rst              |   19 +
> >  Documentation/virt/kvm/api.rst                     |   87 ++
> >  .../virt/kvm/x86/amd-memory-encryption.rst         |  110 +-
> >  arch/x86/include/asm/kvm-x86-ops.h                 |    2 +-
> >  arch/x86/include/asm/kvm_host.h                    |    5 +-
> >  arch/x86/include/asm/sev-common.h                  |   25 +
> >  arch/x86/include/asm/sev.h                         |    3 +
> >  arch/x86/include/asm/svm.h                         |    9 +-
> >  arch/x86/include/uapi/asm/kvm.h                    |   48 +
> >  arch/x86/kvm/Kconfig                               |    3 +
> >  arch/x86/kvm/mmu.h                                 |    2 -
> >  arch/x86/kvm/mmu/mmu.c                             |   27 +-
> >  arch/x86/kvm/svm/sev.c                             | 1538 +++++++++++++++++++-
> >  arch/x86/kvm/svm/svm.c                             |   44 +-
> >  arch/x86/kvm/svm/svm.h                             |   52 +
> >  arch/x86/kvm/trace.h                               |   31 +
> >  arch/x86/kvm/x86.c                                 |   17 +
> >  drivers/crypto/ccp/sev-dev.c                       |   36 +
> >  include/linux/psp-sev.h                            |    4 +-
> >  include/uapi/linux/kvm.h                           |   23 +
> >  include/uapi/linux/psp-sev.h                       |   27 +
> >  include/uapi/linux/sev-guest.h                     |    9 +
> >  virt/kvm/guest_memfd.c                             |    4 +-
> >  23 files changed, 2081 insertions(+), 44 deletions(-)
> >
> 
> 

