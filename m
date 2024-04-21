Return-Path: <kvm+bounces-15425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A4348AC067
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 20:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 67728B20AF5
	for <lists+kvm@lfdr.de>; Sun, 21 Apr 2024 18:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FE103BBDF;
	Sun, 21 Apr 2024 18:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="fBYw27Qo"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2083.outbound.protection.outlook.com [40.107.243.83])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811F218637;
	Sun, 21 Apr 2024 18:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.83
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713722456; cv=fail; b=tOVPS07SLKIyGiDtZT6qOEvpkoG8NmAh/3QHa1/G/7V8RoKW8lrFQcepm2VWHdXPAnz4dCbq8pe8bXdAGgqAGbMH6sIi8L0Cb+AThspQEKhJzBtuyDrsS3i+5/v9JNU64lLmMzksP1tdxWbySwqxUrL4R/zNRbIjTryoppmsj14=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713722456; c=relaxed/simple;
	bh=S2BYcf3Ycrw4QXQs+p6fnTtj6OIgwoR1RS2asqfpcEc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=My16Z8tKt1xBVaKL9B1BRXzRQtF9YBzLX4j9YNz0J1H+0DK2Cs5i5jg55ygoyJqZyr2B2CezJgDM9HpyyxCE1PQSFOAXaum449yEgt4oYk5IUDbj13ni1jqXTzwTNAVVVvTu9AePgUphGJqFajpAUuxy+E2C8o8oYYJdSNKBwgs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=fBYw27Qo; arc=fail smtp.client-ip=40.107.243.83
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HMAGpknib90ktsE280vTjKv2rnowTvrjNpgkCAh4VAJCbq8gRnmglttytL0WHvbV0rsRLdOOgf7fkHBUkpW2x1dmaLPyPyNaMHVobN1IHcGX7RHttCBfT89DO83RbJJfnjxlWtIqFg8aRT+RRt74zRhfUC/ryUz4Sr/TNIjoIaDruArbGO/eAOjHpYgKccwwFBqFuASNzOhFWQ/MQXIr2XZFcQmqbdMtOhQ7+Yzf2R0U3oDuUX5EjCRqdFVCDtAJvHl7SMfdDTpvfYI4AeewcxmeMHf99/U1aJZ19btiaUZ0Sw3YTkm/w5kOE0Tyl3xf9trJAeyUxtYb32VCTCnlEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/FXKVFQA6zOHZXo6oO8ug+NIw2T7XITnUXP/uVqlbgA=;
 b=IUe65GywabsR1XOKnxvZNcFCUYvUunxOYJtNlAeyDm9KBWnrx0pPbbRMPe793AxpiB/ghQOVJdVlbay9C5Os/sKE6we3h7De5jHmiRbdtKEuDqpfEablKQkWur6SlPgs00AeKGZIiG5C1vN21udjj0V/VLOpEdQJxpa4oPp/eOcqn9XEiDld+jKUKIR1V9cFPb+XDGFTeBFJ5zR9s2jSH49wTAMUxC9Z1fCusOWB+Q3R3I+VSS6vkkFoLNMfjkXzyhyLPIkz/cIF25Acb8ERwX0L8z7y2a3J/EyTR/6OZe7R+958DdhTrm2T1NrPHEZdLFdNh61t60HPL+WnUU/fUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/FXKVFQA6zOHZXo6oO8ug+NIw2T7XITnUXP/uVqlbgA=;
 b=fBYw27QomlBsKtV+NjreiN4ctEkkE2EiC/FTRJDTtu2taznjNQ8N0JZpNxzv5MB8LeFnkm3wlkLzXj+h8cFBgeCOruCErMx2h9FJ/Qmlo7Wl0mVkIOzHMH9dNoLmBGRGx5NvOH7v8OeFRf+IxQPGJc9puwZct6Zhae9RNI0a6G4=
Received: from MW4P220CA0010.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::15)
 by SA1PR12MB7296.namprd12.prod.outlook.com (2603:10b6:806:2ba::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Sun, 21 Apr
 2024 18:00:50 +0000
Received: from MWH0EPF000A6734.namprd04.prod.outlook.com
 (2603:10b6:303:115:cafe::2a) by MW4P220CA0010.outlook.office365.com
 (2603:10b6:303:115::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7495.33 via Frontend
 Transport; Sun, 21 Apr 2024 18:00:50 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6734.mail.protection.outlook.com (10.167.249.26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Sun, 21 Apr 2024 18:00:50 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Sun, 21 Apr
 2024 13:00:49 -0500
Date: Sun, 21 Apr 2024 13:00:42 -0500
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
Subject: Re: [PATCH v13 00/26] Add AMD Secure Nested Paging (SEV-SNP)
 Hypervisor Support
Message-ID: <20240421180042.mg4dxnar7xnroiku@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <CABgObfZsY_0-DbPbOSLQ8uSbaWSh-PJZfBKc2TbHiKb2YYJh+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfZsY_0-DbPbOSLQ8uSbaWSh-PJZfBKc2TbHiKb2YYJh+w@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6734:EE_|SA1PR12MB7296:EE_
X-MS-Office365-Filtering-Correlation-Id: 2d797410-f096-4c36-e250-08dc622cfa94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?cGpTZHVaRzNMNWVlVXRYMFlxNjZDWk1pWE9aeGhKNUNrZlFjTDUyaHE0TmRa?=
 =?utf-8?B?eGdiWHc2TGdSeENFS1pzRVJDVzN5SFlseDRMUWFNWWFEdnEwMkpWYVVQQldJ?=
 =?utf-8?B?RnZLZjhDc21WeWIzdnNyUldVTkF4dytXdk1MeGZsa2lYZFBxN1FrS2U5TnRB?=
 =?utf-8?B?Vkp6RUszNkJYWVU5aDloWmNiSDV0Qno5T3QrYm1DZ25hS2sxK3daVHNrNldl?=
 =?utf-8?B?d2VGYjgyV0QxTDZtVG1iQ3NCUXBHS1RzQklFTGhyb3VDOHZaK09aaGVyemdW?=
 =?utf-8?B?enM1M2xubmYvaUtQaGZLbUFGR05VTmJPNHJ2MUdxRVBKOUN5czI2SExFbldM?=
 =?utf-8?B?WXFJWnUxMW9QcXVzbitTQ0NZZm16MlQrdUpiWHBOVThDZ0JodXNTY1VRYkwy?=
 =?utf-8?B?NjNtUmYzWjF1cndsV0JMZDUrdUpZMEJvQm9idGNMZzViQUhWRFhHUE9sQkdD?=
 =?utf-8?B?aFhKdEF3RUhjNHE0WGo4WHo0RmMvVVBBNzVpMjg5U2hTeDlwekpiaUkwbnZP?=
 =?utf-8?B?QXBHR3R2OVcybjlFNGY1MXFla2RFdVljR3Y4by9yOEVZUThtZ0hNVGlzQzZm?=
 =?utf-8?B?VERWdmora3VBMVV3cXVJbnJlQTdkczkzRHl3ZHdlL2Urb0RLUEJiT1ZHc29M?=
 =?utf-8?B?N3AxNTRrQzc4cUJSc3dEK2xTZ01DV3RkVmVyYUZOK2k2MzFkaitEQ3ZIM0ZC?=
 =?utf-8?B?NDNhNlNLL3puNkVPSXhrTG5zeVk2dE1vQzZpR2w0dkFTODk0MGhmVFNxT0JP?=
 =?utf-8?B?cThYK3lmbEU5QTBOcVF1UHB4ajFNUll4R29Gc3V0Y1Njd3QrUk1MOElDVUxy?=
 =?utf-8?B?MWJEdzRQcEZVTUpzd2tmMmRuWWFXZFBDR1duaitmdVB6WWRRNE5Bd1pmeURX?=
 =?utf-8?B?aU53RkxCMzFFUFFOTTQ3MHZ0ZlRuZU9qeXd4NUVRZ0pINmNkRFJJSGJNTGFY?=
 =?utf-8?B?Zy9MZEZhdDJ1TGRvMzhkc005SlR2RFN6VjIxWms1MnFQMG5ibVlNemdsMDhm?=
 =?utf-8?B?djZwNnpMVW5pcVBDVlVIRFhaZUxTOUU2NVhJTlYvdHRTdWVwMm1FbFdRSXdT?=
 =?utf-8?B?d1ZWNXhrVitDTlpRNGRBOUM4cjN3YkZlcW1IRW0wUWtUSlYzZ2lHNXZlcHhF?=
 =?utf-8?B?amdDVFZFc2syMDZoaVZ2Qm9nVGY0aHBocTdsYmhYR1VPanFaQ0xoMEo2TFZj?=
 =?utf-8?B?MTZGQmtoemRUdENhTm4zZmFUWTY4YTA2Ukh6QTlNbUE4UGZZSDh1U2wrZFpT?=
 =?utf-8?B?TnprdG0wRTlnQVplT0QrTi9mbVFudVdXMGtySmlqa1pxVGZZZUN5Yy8zMzlJ?=
 =?utf-8?B?bjNPdHU4NS85cDRUY3k0YWNTcVkzdnQzZzkzM2dkRWk1bkVCdEFJc0QrL1Ey?=
 =?utf-8?B?N1BoN2I5aGoxNEI5elF5UjNMdnBvakFJMTFUNVVXMktwVnA4aEFPZ0dZVS9K?=
 =?utf-8?B?VDl5djZ6TWt6dWZlREJqVEJiajB5MHRIbk5kMGZ0VDBjTHppcUlqUmZCYVlp?=
 =?utf-8?B?eW5hZTlNdE5iaGxxOTdiN2xJc1NUckUvdmhGQUVsUTlOUWljOXhmVFRnd011?=
 =?utf-8?B?akhQN2FvSkhVKy9HNnpTS0p2TXVrZXRhMys3d01wWUdHSGdxSFpYeHZsYlpp?=
 =?utf-8?B?RFlRRXkyYWUwZ1JZMmxzbUJlU3BlM3g1UUJOaU9ENVgzWWx3SzRyQkg2SnZu?=
 =?utf-8?B?V2c1cVZKU2dGZUFwMFk4R3FBNDFOZ3RlTTF5VTJkSTY5MytqVmZCSmM3WjV0?=
 =?utf-8?B?RzRnMzBZV25udGlSaExwdEVyUDZQTlZ3Z0JGdXgyREpXTVRJMWN2Y1JkbHBO?=
 =?utf-8?B?bUJESU5LN1pwRVpBR3J5K3QyRktiejRrNk5yajZNQzEvUmtDMTl4SjdpWEV2?=
 =?utf-8?Q?Uc+Pdvk5VRprp?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(376005)(7416005)(82310400014)(36860700004)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2024 18:00:50.0193
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d797410-f096-4c36-e250-08dc622cfa94
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6734.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7296

On Fri, Apr 19, 2024 at 02:04:54PM +0200, Paolo Bonzini wrote:
> On Thu, Apr 18, 2024 at 9:42 PM Michael Roth <michael.roth@amd.com> wrote:
> >
> > This patchset is also available at:
> >
> >   https://github.com/amdese/linux/commits/snp-host-v13
> >
> > and is based on commit 4d2deb62185f (as suggested by Paolo) from:
> >
> >   https://git.kernel.org/pub/scm/virt/kvm/kvm.git/log/?h=kvm-coco-queue
> 
> This is pretty much ready to go into kvm-coco-queue. Let me know if
> you want to do a quick v14 with the few changes I suggested, or I can
> do them too.

Submitted v14 based on 20cc50a0410f from latest kvm-coco-queue
(bf1390326099). Hoping that way you can easily replace v13 with v14 and
force-push, but let me know if you wanted to go about it a different way.

> 
> Then the next steps are:
> 
> 1) get the mm acks
> 
> 2) figure out the state of patches 1-3

With latest kvm-coco-queue these patches are now in the base tree so
I've dropped them from the series.

> 
> 3) wait for more reviews of course
> 
> 4) merge everything into kvm/next.
> 
> Seems in good shape for a 6.10 target.

Awesome! If anything needs attention just let me know.

Thanks,

Mike

> 
> Paolo
> 
> >
> > Patch Layout
> > ------------
> >
> > 01-03: These patches are minor dependencies for this series and are already
> >        included in both tip/master and mainline, so are only included here
> >        as a stop-gap until merged from one of those trees. These are needed
> >        by patch #8 in this series which makes use of CC_ATTR_HOST_SEV_SNP
> >
> > 04:    This is a small general fix-up for guest_memfd that can be applied
> >        independently of this series.
> >
> > 05-08: These patches add some basic infrastructure and introduces a new
> >        KVM_X86_SNP_VM vm_type to handle differences verses the existing
> >        KVM_X86_SEV_VM and KVM_X86_SEV_ES_VM types.
> >
> > 09-11: These implement the KVM API to handle the creation of a
> >        cryptographic launch context, encrypt/measure the initial image
> >        into guest memory, and finalize it before launching it.
> >
> > 12-17: These implement handling for various guest-generated events such
> >        as page state changes, onlining of additional vCPUs, etc.
> >
> > 18-21: These implement the gmem hooks needed to prepare gmem-allocated
> >        pages before mapping them into guest private memory ranges as
> >        well as cleaning them up prior to returning them to the host for
> >        use as normal memory. Because this supplants certain activities
> >        like issued WBINVDs during KVM MMU invalidations, there's also
> >        a patch to avoid duplicating that work to avoid unecessary
> >        overhead.
> >
> > 22:    With all the core support in place, the patch adds a kvm_amd module
> >        parameter to enable SNP support.
> >
> > 23-26: These patches all deal with the servicing of guest requests to handle
> >        things like attestation, as well as some related host-management
> >        interfaces.
> >
> >
> > Testing
> > -------
> >
> > For testing this via QEMU, use the following tree:
> >
> >   https://github.com/amdese/qemu/commits/snp-v4-wip3
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
> >  * SEV-ES guests may trigger the following warning:
> >
> >      WARNING: CPU: 151 PID: 4003 at arch/x86/kvm/mmu/mmu.c:5855 kvm_mmu_page_fault+0x33b/0x860 [kvm]
> >
> >    It is assumed here that these will be resolved once the transition to
> >    PFERR_PRIVATE_ACCESS is fully completed, but if that's not the case let me
> >    know and will investigate further.
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
> > Changes since v11:
> >
> >  * Rebase series on kvm-coco-queue and re-work to leverage more
> >    infrastructure between SNP/TDX series.
> >  * Drop KVM_SNP_INIT in favor of the new KVM_SEV_INIT2 interface introduced
> >    here (Paolo):
> >      https://lore.kernel.org/lkml/20240318233352.2728327-1-pbonzini@redhat.com/
> >  * Drop exposure API fields related to things like VMPL levels, migration
> >    agents, etc., until they are actually supported/used (Sean)
> >  * Rework KVM_SEV_SNP_LAUNCH_UPDATE handling to use a new
> >    kvm_gmem_populate() interface instead of copying data directly into
> >    gmem-allocated pages (Sean)
> >  * Add support for SNP_LOAD_VLEK, rework the SNP_SET_CONFIG_{START,END} to
> >    have simpler semantics that are applicable to management of SNP_LOAD_VLEK
> >    updates as well, rename interfaces to the now more appropriate
> >    SNP_{PAUSE,RESUME}_ATTESTATION
> >  * Fix up documentation wording and do print warnings for
> >    userspace-triggerable failures (Peter, Sean)
> >  * Fix a race with AP_CREATION wake-up events (Jacob, Sean)
> >  * Fix a memory leak with VMSA pages (Sean)
> >  * Tighten up handling of RMP page faults to better distinguish between real
> >    and spurious cases (Tom)
> >  * Various patch/documentation rewording, cleanups, etc.
> >
> >
> > ----------------------------------------------------------------
> > Ashish Kalra (1):
> >       KVM: SEV: Avoid WBINVD for HVA-based MMU notifications for SNP
> >
> > Borislav Petkov (AMD) (3):
> >       [TEMP] x86/kvm/Kconfig: Have KVM_AMD_SEV select ARCH_HAS_CC_PLATFORM
> >       [TEMP] x86/cc: Add cc_platform_set/_clear() helpers
> >       [TEMP] x86/CPU/AMD: Track SNP host status with cc_platform_*()
> >
> > Brijesh Singh (10):
> >       KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
> >       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_START command
> >       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_UPDATE command
> >       KVM: SEV: Add KVM_SEV_SNP_LAUNCH_FINISH command
> >       KVM: SEV: Add support to handle GHCB GPA register VMGEXIT
> >       KVM: SEV: Add support to handle MSR based Page State Change VMGEXIT
> >       KVM: SEV: Add support to handle Page State Change VMGEXIT
> >       KVM: SEV: Add support to handle RMP nested page faults
> >       KVM: SVM: Add module parameter to enable SEV-SNP
> >       KVM: SEV: Provide support for SNP_GUEST_REQUEST NAE event
> >
> > Michael Roth (10):
> >       KVM: guest_memfd: Fix PTR_ERR() handling in __kvm_gmem_get_pfn()
> >       KVM: SEV: Select KVM_GENERIC_PRIVATE_MEM when CONFIG_KVM_AMD_SEV=y
> >       KVM: SEV: Add initial SEV-SNP support
> >       KVM: SEV: Add support for GHCB-based termination requests
> >       KVM: SEV: Implement gmem hook for initializing private pages
> >       KVM: SEV: Implement gmem hook for invalidating private pages
> >       KVM: x86: Implement gmem hook for determining max NPT mapping level
> >       crypto: ccp: Add the SNP_VLEK_LOAD command
> >       crypto: ccp: Add the SNP_{PAUSE,RESUME}_ATTESTATION commands
> >       KVM: SEV: Provide support for SNP_EXTENDED_GUEST_REQUEST NAE event
> >
> > Tom Lendacky (2):
> >       KVM: SEV: Add support to handle AP reset MSR protocol
> >       KVM: SEV: Support SEV-SNP AP Creation NAE event
> >
> >  Documentation/virt/coco/sev-guest.rst              |   69 +-
> >  Documentation/virt/kvm/api.rst                     |   73 +
> >  .../virt/kvm/x86/amd-memory-encryption.rst         |   88 +-
> >  arch/x86/coco/core.c                               |   52 +
> >  arch/x86/include/asm/kvm_host.h                    |    2 +
> >  arch/x86/include/asm/sev-common.h                  |   22 +-
> >  arch/x86/include/asm/sev.h                         |   19 +-
> >  arch/x86/include/asm/svm.h                         |    9 +-
> >  arch/x86/include/uapi/asm/kvm.h                    |   39 +
> >  arch/x86/kernel/cpu/amd.c                          |   38 +-
> >  arch/x86/kernel/cpu/mtrr/generic.c                 |    2 +-
> >  arch/x86/kernel/sev.c                              |   10 -
> >  arch/x86/kvm/Kconfig                               |    4 +
> >  arch/x86/kvm/mmu.h                                 |    2 -
> >  arch/x86/kvm/mmu/mmu.c                             |    1 +
> >  arch/x86/kvm/svm/sev.c                             | 1444 +++++++++++++++++++-
> >  arch/x86/kvm/svm/svm.c                             |   39 +-
> >  arch/x86/kvm/svm/svm.h                             |   50 +
> >  arch/x86/kvm/trace.h                               |   31 +
> >  arch/x86/kvm/x86.c                                 |   19 +-
> >  arch/x86/virt/svm/sev.c                            |  106 +-
> >  drivers/crypto/ccp/sev-dev.c                       |   85 +-
> >  drivers/iommu/amd/init.c                           |    4 +-
> >  include/linux/cc_platform.h                        |   12 +
> >  include/linux/psp-sev.h                            |    4 +-
> >  include/uapi/linux/kvm.h                           |   28 +
> >  include/uapi/linux/psp-sev.h                       |   39 +
> >  include/uapi/linux/sev-guest.h                     |    9 +
> >  virt/kvm/guest_memfd.c                             |    8 +-
> >  29 files changed, 2229 insertions(+), 79 deletions(-)
> >
> >
> 

