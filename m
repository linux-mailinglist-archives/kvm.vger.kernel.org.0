Return-Path: <kvm+bounces-17191-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 014188C27F5
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 17:37:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 50216B24FEE
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 15:37:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C4EC171676;
	Fri, 10 May 2024 15:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="izNtDMXn"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2075.outbound.protection.outlook.com [40.107.94.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B2E171644;
	Fri, 10 May 2024 15:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.75
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715355410; cv=fail; b=eEoDTaeZST2e9y/wi3QBGLqw8iciniH5pH4uevGiksInB7F5rt9kIYO+L+iCRA2xuSbuQQd84gvItOEgnZXLNp+ykeeGT2hcrtgt8DIVcslAs6wD02Q0jwPtzhP2vDyRjX8YUHb4p/xe9n+Sjy/eYQvQKcZV0zbyRRaDGLgGmVc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715355410; c=relaxed/simple;
	bh=JtOhC9PVA9acv/hp6TjLzEtv5h1aJ4R/7CJyIvA8w6I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ea/3+IPL413AjQV/gawZJwy0OFh71f0qFgDGyat02q96pYGIdAGH78q/Sew+F4q/DhdluAn441ZpFC4qC5DQyyHV7KKdYt2X3RryIx/E8ZyilMYV9w7ekDiCfFMwVwmuzDu9pO2w1ltxjLi+Ux5Hn8MH7U5da9lnOVV9OhfnyiQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=izNtDMXn; arc=fail smtp.client-ip=40.107.94.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fq+ggxnoWG/0re/Uv+ZTwI4tdEvsOP17/mo/U6ruYcRD2zCeClq0rsh+lZB2kaeQ3IUu1mJYG+6wIGA2SL+GehYAb8JVYTYPzXiRl3fSnDGmFPMOd+I/AbXLlzjC1WL4UOtZ7vuvFXjybTeSSbGW/+1H4v9bs7U0oU6Pvxd6SaURZ2lPvcPuRlCgEGI4tykH/GttoXGXLqfCW4gM2dW/iMdPa2oowegnsLrKxtR3uui430iVvYIZ80/snnAWhd2fh/swBeu0Huy3HVjrd/+pVKbGiZkAjP/hZPPY4SdKpQXZUj3VxrwnuS5//GIA2tVBzwvzuTT2+WgeBjfcs6TWDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9v1NUhgy7v28NYCbrl2oFFgykGV0CXeYKhCn0kQe7w8=;
 b=ljfobDOROPc5FKe6H/AbEe0fMbgSRmHjsvToDv40em2GCvHDxpVvOAAy1zf9w2r1VuUszvh/mhlaOYpKl7GevbpcKcXr9uweSe4GPWASJj0juhxFCRFNfgG20zZmOa1gJUeSFMERN4FvV3b0InMQgpED/OXfJxupnbyNz+l2Ld59L3/1GLP4chXNHlaYHrqybcQQ9Ji6i3+0dF7/81+8AQ47ilY5ACzWG7M43gqAWztqxw1wRT++AUIU+a0G9sKBSzGP1nph7x9mjsSaeq8XBE8L73ZywqXh/ugoJ04W/OrcRnTzrwfPVD6KRdhOYUFsP9dEhobzAelMlZYr2W1wgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9v1NUhgy7v28NYCbrl2oFFgykGV0CXeYKhCn0kQe7w8=;
 b=izNtDMXny/TuccUaQhb6+2fIIH5iHVpiMFL6nkmHgq6CycRd9n3v7GtiaJ8Z/VDlG3E+xvpCkfQRSchpFd8fwiDlKFk0XpT7u1g9d2g0ga4dpG5nz2vYnL50LpfVhXcMqkB90aSj82YMLMYQT6jXvdrBQeiJt6ICoIpHVo2Enns=
Received: from CH0PR03CA0384.namprd03.prod.outlook.com (2603:10b6:610:119::26)
 by PH8PR12MB6770.namprd12.prod.outlook.com (2603:10b6:510:1c5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.48; Fri, 10 May
 2024 15:36:41 +0000
Received: from CH3PEPF00000013.namprd21.prod.outlook.com
 (2603:10b6:610:119:cafe::a6) by CH0PR03CA0384.outlook.office365.com
 (2603:10b6:610:119::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.34 via Frontend
 Transport; Fri, 10 May 2024 15:36:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH3PEPF00000013.mail.protection.outlook.com (10.167.244.118) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7587.0 via Frontend Transport; Fri, 10 May 2024 15:36:41 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 10:36:27 -0500
Date: Fri, 10 May 2024 10:27:44 -0500
From: Michael Roth <michael.roth@amd.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <vkuznets@redhat.com>, <jmattson@google.com>,
	<luto@kernel.org>, <dave.hansen@linux.intel.com>, <slp@redhat.com>,
	<pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>, "Isaku
 Yamahata" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v15 21/23] KVM: MMU: Disable fast path for private
 memslots
Message-ID: <20240510152744.ejdy4jqawc2zd2dt@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
 <Zj4lebCMsRvGn7ws@google.com>
 <CABgObfboqrSw8=+yZMDi_k9d6L3AoiU5o8d-sRb9Y5AXDTmp5w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfboqrSw8=+yZMDi_k9d6L3AoiU5o8d-sRb9Y5AXDTmp5w@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PEPF00000013:EE_|PH8PR12MB6770:EE_
X-MS-Office365-Filtering-Correlation-Id: d33baa99-1a35-4382-7863-08dc7106fd97
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|1800799015|36860700004|7416005|82310400017|376005;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?elZtYXpYYnlBRGE5ckNtK0dVTzlva0JOWnQyYllnMkZoWVd2NklPRFlUUGRm?=
 =?utf-8?B?YUhhYnJLMWdTcVpIMUFqeTYwZFF2cjljeU05azlLc0g0NDMxM2RhQkFPc2gw?=
 =?utf-8?B?K1dhcjVDV3EwSGpVa2xseDVsK1QxdTAyYXhPQ1Z6dHpjVVdWdFFXUmlvRlR3?=
 =?utf-8?B?VHJSZzMyR1VmL2FjUGp6MUJDWHA0a3Jadk9HQTVRNm1RRytONWRjNW1CTzcr?=
 =?utf-8?B?NW9PSHZHTldPUGN4UXZXVEh2L3A2aDIyVFRRNTJ2SWpFOWZoMEtteWovN1Fm?=
 =?utf-8?B?RzdxMXJKUDBDNGc2d2FnRmFVRDcxeGdBYmlBeDJ5Z0tuSWpjc1NmaytJc2JR?=
 =?utf-8?B?MlhGZXNzaXc3Z01UUzlwWkF6WUZmK2wyZGQzbWYweHN5clViVisvRGlJVUJ6?=
 =?utf-8?B?OHRVa21qNXRuSVk4T3NlT3FONG93TS8waFhpQ3J4RjROclYxcVVrWjd1bkJX?=
 =?utf-8?B?ZzZWLzJCK3Z4MmphQmdabGNYMnBadXpFRWZRS1ovaHEwdjgwV1B3L21hVldE?=
 =?utf-8?B?QVlSU0pWRlNTaGtNU2IwcEozbE5GZVpodWkvWmlBMyttb09kejhUZG9MWnZF?=
 =?utf-8?B?dGc0N3V5c0JzazVXQWNkQ1RUb3BraEl4NTJDUExrRHF6WVA4dGY1cHBQY0tQ?=
 =?utf-8?B?aTFCNTE2UmRnTndUY3ZjYzFFL3BRWFk3SjZPRFFMWmVNYkhKVzIvRGd3S2lz?=
 =?utf-8?B?YktPTy8yYzVtZlJxRDNBM3Uyb1RFa05zZFJnQSs0Z3R3cEhxV3lqWVVuZmFp?=
 =?utf-8?B?c2d2eUZIMW1tWFB3NmJvNCt3UndHd0ZUTEZGUGVlVHRWSFZQenE1aXZGRDBZ?=
 =?utf-8?B?WmVtSGZDalZhWWRkWnRLVGZ5bFh5eTErbmphYlpCWDd6NVZvTm91ckxCZHdM?=
 =?utf-8?B?dUs0NENneU9jaGdlLzBpSHhnUXBudThRcGFRZ01ycCtVOFgwRWRBcHBva2pv?=
 =?utf-8?B?VjROaUh4VWRXY1JVWkVpMU1iWVlvMTBxNjBMNjJOdE9zY1VocHc2QlJxaVhm?=
 =?utf-8?B?N0tFbldPWWhkaHdvQjIwcEtPZE1FaFFCSlg3MWpqUExTK01rbjl5akdZY0xG?=
 =?utf-8?B?NG0wZkMyVk1hM3lNakUwUUVsNUFZSFpqako3WHA4cy9zMjdLcERqbU0rajZ0?=
 =?utf-8?B?WnZDOTJFdjBKU0ovU2xranVlTk5zOExoRmJ6UHFBRXc0UERHY2lhdjZVa1dB?=
 =?utf-8?B?NFFOMDBEbTZQT2R3WUhBUjdqd0FYSTZWU0lPYXBSVk5mSEhNZnQ3VVNha2hL?=
 =?utf-8?B?NTI5UnRnN1gwOHRIaGhybHF0YjNkUWRtSjNSRytWMTZlVHU3VFVlUkpMVTRD?=
 =?utf-8?B?WGJOOVYwaFFjeXYxeEdaVk9jbnpqekhUQTdaTW83RVZ1aEIrNEhyUTZTZXNO?=
 =?utf-8?B?UkkvOHd4MDFJV2NJT2luTFc2dHRJbU9jWGtuQXpXb2pHU1JRd1B5YnJXN1Rm?=
 =?utf-8?B?ZklXemdqWkhPNFEwVG4xVTNRYmJEU1A5YmNoN0psNHJncDlmK05NVnNndHMr?=
 =?utf-8?B?d3BSQlBORjZ2NDlKNFlvTW9lUnJrSzVWbm42OHVESHU2V3F2NHJxL1NySFZN?=
 =?utf-8?B?Z283YmcxWGhDM0lEUEF1TVkvVXIxeEhYekw5SjVSVHlRSWxsTlBDQ3dxZnFm?=
 =?utf-8?B?bURxRmlBRTFpdGR5b2NGRkk4OE1KUGZCT0E4WFp2dmJSOGNjSXRvUU9mcmRu?=
 =?utf-8?B?N0hnb0hybU9CdkVaVnhmaWtvS2UxWFZJdGEyVkNvN0RXUEI5TVBzdVBKRzQ1?=
 =?utf-8?B?SSsrRWZ0NXhnVmR2S1pOUmxoRjgwSWRwVVNla3BaM1IrN3QzOHJIME93dDVU?=
 =?utf-8?B?a0ExdWlpbk5PUnAvZUZldz09?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(36860700004)(7416005)(82310400017)(376005);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 15:36:41.6353
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d33baa99-1a35-4382-7863-08dc7106fd97
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH3PEPF00000013.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB6770

On Fri, May 10, 2024 at 03:50:26PM +0200, Paolo Bonzini wrote:
> On Fri, May 10, 2024 at 3:47 PM Sean Christopherson <seanjc@google.com> wrote:
> >
> > > +      * Since software-protected VMs don't have a notion of a shared vs.
> > > +      * private that's separate from what KVM is tracking, the above
> > > +      * KVM_EXIT_MEMORY_FAULT condition wouldn't occur, so avoid the
> > > +      * special handling for that case for now.
> >
> > Very technically, it can occur if userspace _just_ modified the attributes.  And
> > as I've said multiple times, at least for now, I want to avoid special casing
> > SW-protected VMs unless it is *absolutely* necessary, because their sole purpose
> > is to allow testing flows that are impossible to excercise without SNP/TDX hardware.
> 
> Yep, it is not like they have to be optimized.

Ok, I thought there were maybe some future plans to use sw-protected VMs
to get some added protections from userspace. But even then there'd
probably still be extra considerations for how to handle access tracking
so white-listing them probably isn't right anyway.

I was also partly tempted to take this route because it would cover this
TDX patch as well:

  https://lore.kernel.org/lkml/91c797997b57056224571e22362321a23947172f.1705965635.git.isaku.yamahata@intel.com/

and avoid any weirdness about checking kvm_mem_is_private() without
checking mmu_invalidate_seq, but I think those cases all end up
resolving themselves eventually and added some comments around that.

> 
> > > +      */
> > > +     if (kvm_slot_can_be_private(fault->slot) &&
> > > +         !(IS_ENABLED(CONFIG_KVM_SW_PROTECTED_VM) &&
> > > +           vcpu->kvm->arch.vm_type == KVM_X86_SW_PROTECTED_VM))
> >
> > Heh, !(x && y) kills me, I misread this like 4 times.
> >
> > Anyways, I don't like the heuristic.  It doesn't tie the restriction back to the
> > cause in any reasonable way.  Can't this simply be?
> >
> >         if (fault->is_private != kvm_mem_is_private(vcpu->kvm, fault->gfn)
> >                 return false;
> 
> You beat me to it by seconds. And it can also be guarded by a check on
> kvm->arch.has_private_mem to avoid the attributes lookup.

I re-tested with things implemented this way and everything seems to
look good. It's not clear to me whether this would cover the cases the
above-mentioned TDX patch handles, but no biggie if that's still needed.

The new version of the patch is here:

  https://github.com/mdroth/linux/commit/39643f9f6da6265d39d633a703c53997985c1208

And I've updated my branches with to replace the old patch and also
incorporate Sean's suggestions for patch 22:

  https://github.com/mdroth/linux/commits/snp-host-v15c3-unsquashed

and have them here with things already squashed in/relocated:

  https://github.com/mdroth/linux/commits/snp-host-v15c3

Thanks for the feedback Sean, Paolo.

-Mike
  
> 
> > Which is much, much more self-explanatory.
> 
> Both more self-explanatory and more correct.
> 
> Paolo
> 
> 

