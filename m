Return-Path: <kvm+bounces-17198-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 02B8C8C28D4
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 18:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25A441C21BD5
	for <lists+kvm@lfdr.de>; Fri, 10 May 2024 16:39:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983BB15E86;
	Fri, 10 May 2024 16:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="WtfGqVyk"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2053.outbound.protection.outlook.com [40.107.244.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153CBEAF6;
	Fri, 10 May 2024 16:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.244.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715359150; cv=fail; b=AJHDZ7pfP42KjF7MiLgr7RfNGZPS/RQAXCQtw3Qnng3/JCe3TQff/R1XnPG1CWFv87IhJ84/PwSUaAsxdG+rzITkA9l9pNmDFMmDSl9ixy2eLtfXQIrMqMxsdeg1zqE2x8kVXvsJmpXLVlQTuULe/X/jbStD9AGtA2Ri95xfmvQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715359150; c=relaxed/simple;
	bh=jVY8gObdPoNTdgCrmt5KhZWmbZiYvYLKGfKXTIcznUw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dXIG5CyxJHrPjzQvb9ddA/pg/nUs1wuzwC+qsOoFXKwPZhMOS3PnLyOUMTF3ciOv5P2YAF+hwKFDRmV2C+enQoHTnvVjJwi+EKvI1NTA5OY8K0Y1CYWa/6fEchLUXhtQQPjdtme6R+7oUuocYLWA0cka3SznnIWUQUYg/ksTBBs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=WtfGqVyk; arc=fail smtp.client-ip=40.107.244.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KXsr8dqfSOk8po+QbK2KvCJTwGQ2NnrfnaVBVAkbz5vPipbGXwGUE8aq6X+j2cA/RB8CpVN2JZlV2fBFwNaqGpbZ9SSkzepQfFRT8wL5anyqc/BNVl91dYgF4RomnTNiKNpTE/RGw4aXctd8/LLBPjfNgbMESb714fawD+QQqZwVyl4YRfqCEkDLRwwpVXJSu1rcHB2wm8FWcB5qsZP5bUnEgDaVxn34UaNkb8wbrkivoz9ud8G7UnUt8AtbXPQXLY1Ni4y/EOrQBjxExbRxr9MYYRgJ4AGIRPVNcq6VEM+OBYfvlcuxeIukYhpCMoueeNAb6Vlnbt009n0URKDPjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PtheikfdM3MiWCRRCEQVVcbQm28faHRKtu63rAf8K3w=;
 b=n0hSIWrGPkGNaSs2Hlux/1FuMoG9aDRdywefOyyCqbqVyk9/fiRbPam63DjXTS3QPFWTJD13oRsbwZ+QBELaaKocCESk1eg6IYPBFaKMoy7HBl11RT3ly6r+FE7qckrZCpX5xZEcAn43SFFBDvo/eb//S+WE4V2894KkCX72XHxvNshGwNNJ/IsYIYQqj7lb/HZUA03IbUNK9ZZ1fUHL8HhQ0NpFkQa9FLuHC0lw24fa/gIOEITjEqB/sQtD3c3cWZBIhSk8etvGhTUZCht09YOuL/VY4m3+Ho+u62CmIYAjFS7z63DDBKPDGT+9zRbMXJMhRXUGttlLl3G0mZMkgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PtheikfdM3MiWCRRCEQVVcbQm28faHRKtu63rAf8K3w=;
 b=WtfGqVykfgCwnMV0dqwh/8KXUXrCgvAV9NhXVhc3ZAzSkVyNtCOhgymX6pFanEKZLVImmrdZLv3iDZQMUoHXawM+Yxw8Jj9RUhVJpd+vORDS3DyjgNzfomoUz1FseXD+WL881ZUNe5r/WdRq+zbpWC1iXl48OQVEMNKGYl4rrj4=
Received: from PH7P220CA0112.NAMP220.PROD.OUTLOOK.COM (2603:10b6:510:32d::33)
 by CH2PR12MB4328.namprd12.prod.outlook.com (2603:10b6:610:a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.49; Fri, 10 May
 2024 16:39:06 +0000
Received: from MWH0EPF000A6735.namprd04.prod.outlook.com
 (2603:10b6:510:32d:cafe::d7) by PH7P220CA0112.outlook.office365.com
 (2603:10b6:510:32d::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.51 via Frontend
 Transport; Fri, 10 May 2024 16:39:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 MWH0EPF000A6735.mail.protection.outlook.com (10.167.249.27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7544.18 via Frontend Transport; Fri, 10 May 2024 16:39:05 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 10 May
 2024 11:39:05 -0500
Date: Fri, 10 May 2024 11:37:19 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <papaluri@amd.com>
Subject: Re: [PATCH v15 22/23] KVM: SEV: Fix return code interpretation for
 RMP nested page faults
Message-ID: <20240510163719.pnwdwarsbgmcop3h@amd.com>
References: <20240501085210.2213060-1-michael.roth@amd.com>
 <20240510015822.503071-1-michael.roth@amd.com>
 <20240510015822.503071-2-michael.roth@amd.com>
 <Zj4oFffc7OQivyV-@google.com>
 <566b57c0-27cd-4591-bded-9a397a1d44d5@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <566b57c0-27cd-4591-bded-9a397a1d44d5@redhat.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWH0EPF000A6735:EE_|CH2PR12MB4328:EE_
X-MS-Office365-Filtering-Correlation-Id: 8e7bc636-5ecd-4e24-5cd3-08dc710fb55f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|7416005|376005|82310400017|1800799015|36860700004;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?A7U+XZ7d9Ba4y7DOgiPUBJ+ZZ8YY5YcU60dCmM5v7KLhKfz6zG6HI0oiTc7P?=
 =?us-ascii?Q?4uTLsRAFpI0VukWIHci2MeHmHa3x+2+WmYWahEJXw0uXSUoxHCiWB7SN1XQm?=
 =?us-ascii?Q?huVyxzm0zrefCYfQic/MV+z2yZnlEg7yBO2QSkv3+8xQiVTnVqy/WPrx93b0?=
 =?us-ascii?Q?itvf5pL7RGqkk4eIS0OUrINi8psoEn72XiYZeCNODGZHQ+hHVlWX5xcGagKD?=
 =?us-ascii?Q?skFG1dpVw8MaORvkv1Fs+uoCsziTlWsyZCJ54AG2jGQv3v4EsZj+vQu7fCVk?=
 =?us-ascii?Q?qp4n097MCOAVTcmOKgSyJlv7kHwc28SfvGp/bfF/abfRcocN7QHOwNRlJHYy?=
 =?us-ascii?Q?4+SoGBrjO5pqB2hohQnRjkfprAg8R6tUmf82E/cXUgmMhv3MPYWh7jV6Z3KM?=
 =?us-ascii?Q?cGPt8pEscAKTVOPd5GYJBpm89ylcgxLKxNrk+YQNM1XtuLSbk64YbmG+5CVu?=
 =?us-ascii?Q?RPGljD4+6RfUew6prlNUdYxLehASuIatAksdM2hDc5+KbKLx3K48KGNotICv?=
 =?us-ascii?Q?ktBEq97KIwghFlnN98e+oud39+iLy34HaIW4qX4Cd7EQwaqRz4XhsAWajUTe?=
 =?us-ascii?Q?UHCWzRv1Jo6W5KrnUpbGXEeevjOMYL3OJMVr51Gua81UMVouDFsdK2irQrey?=
 =?us-ascii?Q?ujJIX+Q+Dt6SmgXN3K5WZsaFcS6Jlgr3HSU75ATFV61FyF0drYjQTX5dzqmF?=
 =?us-ascii?Q?hl7fjWgABPsolMEqUjJpcAtsqo6t4lIe4pzr1RU76NoitZpRSYL4iYlYmMV2?=
 =?us-ascii?Q?/2zaX5erQkYLiNPV+/qQiyVn9V9wK6+MSYn/ZkVBleYHflIPBsmuqlHECsiX?=
 =?us-ascii?Q?/0XzU6tPeazqnoUPJbBfEqkgYVK47UsfddcT3kpBLThrpUOGt2pCmLzEIFvr?=
 =?us-ascii?Q?pz8ko68MYwzpgi+QK7tHBc1izrD3TQTiA7ATB3uyqYQKOFMdWs3luiigv0mT?=
 =?us-ascii?Q?ve7azumfNzLM9SFSyxof5enlIFIIrf3QSFbyBSQOycD7ukEJkPfW8xYEOnwj?=
 =?us-ascii?Q?1XlCXwlTtTIzj9MHW+MppEcXTaq5jjkCiT5Tj7x09Zah0uqL7H6F3JEw83OO?=
 =?us-ascii?Q?GESryAd0ioBqJn1c2YRNtJrGawcGAnjfXx3Zu0nW5WUBf5BnMYX50k8gwLII?=
 =?us-ascii?Q?ZRcu6Vc/ZOVYIRpE3ScFX7rXS1Lj6NDNlHbv527uHNuyp98CymVxpQBw3/Xx?=
 =?us-ascii?Q?AaX4JIxUcx4BTpypxz6w3ImAVngYe1IJ7iIdHY3Rf9xSTUzY2Ae7NEutVa80?=
 =?us-ascii?Q?QApNNmRdIkxzojVmqRhHhyh9F+nRbztLzFPlXkBWSURh3ywxnHq+2cZwYwCL?=
 =?us-ascii?Q?vA2Vk6mD5qykT+x5XB6lmtqlqZytS8RBspeGOb6SRNcqFKQLVIEu4rRnBosY?=
 =?us-ascii?Q?+87soXMrZyWZlV+4oOyCdu9bKHAr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(82310400017)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2024 16:39:05.9735
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e7bc636-5ecd-4e24-5cd3-08dc710fb55f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	MWH0EPF000A6735.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4328

On Fri, May 10, 2024 at 06:01:52PM +0200, Paolo Bonzini wrote:
> On 5/10/24 15:58, Sean Christopherson wrote:
> > On Thu, May 09, 2024, Michael Roth wrote:
> > > The intended logic when handling #NPFs with the RMP bit set (31) is to
> > > first check to see if the #NPF requires a shared<->private transition
> > > and, if so, to go ahead and let the corresponding KVM_EXIT_MEMORY_FAULT
> > > get forwarded on to userspace before proceeding with any handling of
> > > other potential RMP fault conditions like needing to PSMASH the RMP
> > > entry/etc (which will be done later if the guest still re-faults after
> > > the KVM_EXIT_MEMORY_FAULT is processed by userspace).
> > > 
> > > The determination of whether any userspace handling of
> > > KVM_EXIT_MEMORY_FAULT is needed is done by interpreting the return code
> > > of kvm_mmu_page_fault(). However, the current code misinterprets the
> > > return code, expecting 0 to indicate a userspace exit rather than less
> > > than 0 (-EFAULT). This leads to the following unexpected behavior:
> > > 
> > >    - for KVM_EXIT_MEMORY_FAULTs resulting for implicit shared->private
> > >      conversions, warnings get printed from sev_handle_rmp_fault()
> > >      because it does not expect to be called for GPAs where
> > >      KVM_MEMORY_ATTRIBUTE_PRIVATE is not set. Standard linux guests don't
> > >      generally do this, but it is allowed and should be handled
> > >      similarly to private->shared conversions rather than triggering any
> > >      sort of warnings
> > > 
> > >    - if gmem support for 2MB folios is enabled (via currently out-of-tree
> > >      code), implicit shared<->private conversions will always result in
> > >      a PSMASH being attempted, even if it's not actually needed to
> > >      resolve the RMP fault. This doesn't cause any harm, but results in a
> > >      needless PSMASH and zapping of the sPTE
> > > 
> > > Resolve these issues by calling sev_handle_rmp_fault() only when
> > > kvm_mmu_page_fault()'s return code is greater than or equal to 0,
> > > indicating a KVM_MEMORY_EXIT_FAULT/-EFAULT isn't needed. While here,
> > > simplify the code slightly and fix up the associated comments for better
> > > clarity.
> > > 
> > > Fixes: ccc9d836c5c3 ("KVM: SEV: Add support to handle RMP nested page faults")
> > > 
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >   arch/x86/kvm/svm/svm.c | 10 ++++------
> > >   1 file changed, 4 insertions(+), 6 deletions(-)
> > > 
> > > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > > index 426ad49325d7..9431ce74c7d4 100644
> > > --- a/arch/x86/kvm/svm/svm.c
> > > +++ b/arch/x86/kvm/svm/svm.c
> > > @@ -2070,14 +2070,12 @@ static int npf_interception(struct kvm_vcpu *vcpu)
> > >   				svm->vmcb->control.insn_len);
> > >   	/*
> > > -	 * rc == 0 indicates a userspace exit is needed to handle page
> > > -	 * transitions, so do that first before updating the RMP table.
> > > +	 * rc < 0 indicates a userspace exit may be needed to handle page
> > > +	 * attribute updates, so deal with that first before handling other
> > > +	 * potential RMP fault conditions.
> > >   	 */
> > > -	if (error_code & PFERR_GUEST_RMP_MASK) {
> > > -		if (rc == 0)
> > > -			return rc;
> > > +	if (rc >= 0 && error_code & PFERR_GUEST_RMP_MASK)
> > 
> > This isn't correct either.  A return of '0' also indiciates "exit to userspace",
> > it just doesn't happen with SNP because '0' is returned only when KVM attempts
> > emulation, and that too gets short-circuited by svm_check_emulate_instruction().
> > 
> > And I would honestly drop the comment, KVM's less-than-pleasant 1/0/-errno return
> > values overload is ubiquitous enough that it should be relatively self-explanatory.
> > 
> > Or if you prefer to keep a comment, drop the part that specifically calls out
> > attributes updates, because that incorrectly implies that's the _only_ reason
> > why KVM checks the return.  But my vote is to drop the comment, because it
> > essentially becomes "don't proceed to step 2 if step 1 failed", which kind of
> > makes the reader go "well, yeah".
> 
> So IIUC you're suggesting
> 
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 426ad49325d7..c39eaeb21981 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -2068,16 +2068,11 @@ static int npf_interception(struct kvm_vcpu *vcpu)
>  				static_cpu_has(X86_FEATURE_DECODEASSISTS) ?
>  				svm->vmcb->control.insn_bytes : NULL,
>  				svm->vmcb->control.insn_len);
> +	if (rc <= 0)
> +		return rc;
> -	/*
> -	 * rc == 0 indicates a userspace exit is needed to handle page
> -	 * transitions, so do that first before updating the RMP table.
> -	 */
> -	if (error_code & PFERR_GUEST_RMP_MASK) {
> -		if (rc == 0)
> -			return rc;
> +	if (error_code & PFERR_GUEST_RMP_MASK)
>  		sev_handle_rmp_fault(vcpu, fault_address, error_code);
> -	}
>  	return rc;
>  }
> 
> ?
> 
> So, we're... a bit tight for 6.10 to include SNP and that is an
> understatement.  My plan is to merge it for 6.11, but do so
> immediately after the merge window ends.  In other words, it
> is a delay in terms of release but not in terms of time.  I
> don't want QEMU and kvm-unit-tests work to be delayed any
> further, in particular.

That's unfortunate, I'd thought from the PUCK call that we still had
some time to stabilize things before merge window. But whatever you
think is best.

> 
> Once we sort out the loose ends of patches 21-23, you could send
> it as a pull request.

Ok, as a pull request against kvm/next, or kvm/queue?

Thanks,

Mike

> 
> Paolo
> 
> 

