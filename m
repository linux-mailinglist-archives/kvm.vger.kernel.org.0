Return-Path: <kvm+bounces-16073-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 070708B3EC2
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 19:58:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2C6521C219D7
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 17:58:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B258616F289;
	Fri, 26 Apr 2024 17:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZHZAhGnM"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2053.outbound.protection.outlook.com [40.107.243.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335CA16DEB2;
	Fri, 26 Apr 2024 17:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714154282; cv=fail; b=ojA8e7fKoYxrWSQNazRvyK4EvKoIRFMKKGFOwA8G4Idfat4+IKuxSc22HTMZBz9/v8cPJb0PcSQzRTtudK9FRYL4DpSZqppNz9T5roaWfMG7GPuilUuyb4Saf/kLJEF8lfZY3wC/lxpNKtcHY6icrtIv/nFwT8OSk5vGcW7qkws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714154282; c=relaxed/simple;
	bh=Qg0psVOeueLQ0ruqD9DANG29f8eaFRD4ygCp0h9wk/Q=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QtwYGaZaN2a3rf33rK4J29hj0cstkBQ65PyMDMjcYmkPzgZyyj+NAcI80QMJ8asuMGiVrjUOQpCFrFbOG3O99YKA8998IngBAfe4n4UjvYOYd3ArSYJzbzZvk4nFvRNKRX4i99rLjZDzAUK4v4+L9DNjq08Z54TtyTTVdbjNwFs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZHZAhGnM; arc=fail smtp.client-ip=40.107.243.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcPZ5FN5E1Ts09+m3nsf73vZGnRnMg8mAcbibWIN0XabGdJPkIR3oEsxXU54+ANAhnz+vUkPmW1eWOxtlPCb+QJSsGnU48VUnbfqLwO0B038BKyTwhAdzhdEUv3nnU5K+ekwxIXnKyL1kEi6juCf3fDN4UqK4+oRQ9opGfL+wMxtNmJfHYQScexI3OyfnLaVWQ+Kn02oqIaimnjuCSHOWV12UL4TIB+aB0M3BnlAutt00y+QgFstRqjPzG4CjD7JfTM9tvqlQX6ALz4Pfd5BUrjiE4iUDCubpssz5xa3ywxu6esgvlGOGKCKG+OKHgRYmj9jsGXrCmmnm5u6ebFBug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5UJtW8Ae5PZdv1XXt0O5XE/S3fK87MmNLyq27/9ywVQ=;
 b=j+UQnC0AKJnlfhR9nyvDZ8fFhAdfh30KAb5vAbpzYaal4vNBC9AVzH4Nv48tqwvJYDey/sfhQ75/l8Uldg6/gJvcxIVFpY7Ngbn/G/akxeloaKnWf2uDsqRaBXDkvRlzK2NnNNMPTHK8O80NM5gxaGujRbwD3F06zL3JqZijtdIbN3pm1S2r5yHoUR+GdzfnzeXhF8Q0UKOxOSWHC5vCiSeG0j+wRpmkbqOWh2QI7zir1fGc9qhdJo41CmZbtQ3ud/SiaMYL7uZYCsc1EI4GFBM1GNWq8KcA4iu2okBO+2Cl4Olp+5pfLsHMxAwGYrK6pKN9KADUM2IOL+97No/i7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5UJtW8Ae5PZdv1XXt0O5XE/S3fK87MmNLyq27/9ywVQ=;
 b=ZHZAhGnMENCtgXn0iBw2sFKZVd1+BIfd7NiLPDyYPYh9KPkMhcDquBqhy3EWNPQmznZBFipOrasnWyrc43MsQrXPN40cCZtVKPw9mbDQHOI14rGrRi6ONDV/l2lJJkbWKBJXP/OE7PmjQBionxHX/ldfiiNzuDXfhn1hS3tj3SA=
Received: from BLAPR03CA0176.namprd03.prod.outlook.com (2603:10b6:208:32f::26)
 by CY5PR12MB6204.namprd12.prod.outlook.com (2603:10b6:930:23::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.44; Fri, 26 Apr
 2024 17:57:58 +0000
Received: from BL6PEPF0001AB4E.namprd04.prod.outlook.com
 (2603:10b6:208:32f:cafe::5b) by BLAPR03CA0176.outlook.office365.com
 (2603:10b6:208:32f::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.31 via Frontend
 Transport; Fri, 26 Apr 2024 17:57:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL6PEPF0001AB4E.mail.protection.outlook.com (10.167.242.72) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Fri, 26 Apr 2024 17:57:58 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 26 Apr
 2024 12:57:57 -0500
Date: Fri, 26 Apr 2024 12:57:43 -0500
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <vkuznets@redhat.com>,
	<jmattson@google.com>, <luto@kernel.org>, <dave.hansen@linux.intel.com>,
	<slp@redhat.com>, <pgonda@google.com>, <peterz@infradead.org>,
	<srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
	<dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>, <vbabka@suse.cz>,
	<kirill@shutemov.name>, <ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v14 22/22] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
Message-ID: <20240426175743.t4cocerwwhaevieh@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-23-michael.roth@amd.com>
 <Zimfdyhq3U2HVX0N@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zimfdyhq3U2HVX0N@google.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL6PEPF0001AB4E:EE_|CY5PR12MB6204:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b1c03f4-4510-41a5-ef68-08dc661a686a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?1Pke6fct7jOcDDw66vilmdbrBV/g9Ga3uX/3yVbRjFFsgA3UrDhm3UFLKadS?=
 =?us-ascii?Q?lYZ8V9LbfT0wrAi8gMr+VkHpeGbpCWqE5RUxmADF/RxtwctaTxRLB6UMdCH9?=
 =?us-ascii?Q?v+G5spRzak342NcGvDaBEOSkitBOt5bjIAouEkBnLaC5EIHcb4+mP51/hitv?=
 =?us-ascii?Q?5XPY5IrP55vBTciqwMiGfzBzfHaLKGfop9T23ctA3bCs7Fz6DFMsucmVhn78?=
 =?us-ascii?Q?Esf91WHWipOyZC66RX23VFfk61TNMeXLLxfMIUVR0BXOT90o6jMnKV47NWg3?=
 =?us-ascii?Q?6t3UG8/jDw28+vv9RaXjwm2MjooIspvPaUB6RjYjA5UTSctU9H/XhvXP7N2X?=
 =?us-ascii?Q?dIAn0Da4m1A51+1k115cktrUJvOpmyodIeBeX7RIOdd+aefdHxJzQ7iay/ly?=
 =?us-ascii?Q?o9e68GLFMNEWnIHqNRZq+fQ0IuB8bpAO0aev4rrHs44s1UBg/TiGzNj9LqV4?=
 =?us-ascii?Q?3bZNbSolSmIB+HD+MVE9dFsEIn4H1uV7STshHVSdf0yC7SzS3JFdGuN5SKEo?=
 =?us-ascii?Q?+ZkJ/ncYszQQmIAL5zCIp1Jzbt7/LYsKq0lX8iSZxZw2US860s0kjyONCaNg?=
 =?us-ascii?Q?nlpSFZGzkDzHlYtSVU5ti508OK8L+Z0iwyTmDATvRZQZPe/0++y6/Td3/soo?=
 =?us-ascii?Q?+SSF5yMcUeFEk2ANfhnkDzWiXNDrTBEPoAB08FfRRteOMEHSzGns+NJ8kjju?=
 =?us-ascii?Q?b2Ufl9Xe/BbVspAdJJ3YTKevoPsIOKdtnyBHUZ37SI+H6/JBFBSGZSiIZA1o?=
 =?us-ascii?Q?4J7co0pDxtEvb12f4VCEc5wVgrCeEqCukWriKM+a9kfLkw08I8t6OgmfMdlP?=
 =?us-ascii?Q?2OzjYszYQMrlHPYlQfn4XgYUhbL88+/OFuisOFuWJ1rBgq6XmUkrjhD3M6Ml?=
 =?us-ascii?Q?wcBbCPeP7F/4zOXdra1lMe08l29UDYL8e1pTYxvUYzdt1YfC2mrh2uZ+C/6a?=
 =?us-ascii?Q?NzhotJlruIxiAysRPd5Tw2Moq+iRmlN1RgDvabX5+hcc1uxg+5POCrLCfkIE?=
 =?us-ascii?Q?lhKA+YvwlU0bdEQKuI7uhuh1PeTrI1SX9q9Y3iTiTCShmb6Oz+EyagezA5yH?=
 =?us-ascii?Q?uXnU+dk3QCqWgswUyYVJu5kXFPTczscehdYLq41Ch1gJoUgeYI88EEF5vPtu?=
 =?us-ascii?Q?mBPbo1ekSykSZliCTwz/p+ca6oB9lzruOo9W3clhu80FPWR9fDyVeT2lPOiZ?=
 =?us-ascii?Q?STWIV4t9trxZ1NsVrSf5anAmeotqhUqSngHUzWbzATEcYxWPLZG5/trieUfb?=
 =?us-ascii?Q?gsRtQqTTNed7TKvA8IUw1qqipsEv+bsmMnUPNoqk8jQ8vZh0U9VsZNw3vt1i?=
 =?us-ascii?Q?Il5relc/62EQlFha2vepXbPrazbTM8ldkmbKASuGw3G872j5DXW/An5eiyN7?=
 =?us-ascii?Q?gLRM6VpN20p6cqlUOldd4KttYlcD?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(82310400014)(376005)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2024 17:57:58.5695
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b1c03f4-4510-41a5-ef68-08dc661a686a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	BL6PEPF0001AB4E.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6204

On Wed, Apr 24, 2024 at 05:10:31PM -0700, Sean Christopherson wrote:
> On Sun, Apr 21, 2024, Michael Roth wrote:
> > diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> > index 85099198a10f..6cf186ed8f66 100644
> > --- a/Documentation/virt/kvm/api.rst
> > +++ b/Documentation/virt/kvm/api.rst
> > @@ -7066,6 +7066,7 @@ values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
> >  		struct kvm_user_vmgexit {
> >  		#define KVM_USER_VMGEXIT_PSC_MSR	1
> >  		#define KVM_USER_VMGEXIT_PSC		2
> > +		#define KVM_USER_VMGEXIT_EXT_GUEST_REQ	3
> 
> Assuming we can't get massage this into a vendor agnostic exit, there's gotta be
> a better name than EXT_GUEST_REQ, which is completely meaningless to me and probably
> most other people that aren't intimately familar with the specs.  Request what?

EXT_CERT_REQ maybe? That's effectively all it boils down to, fetching
the GHCB-defined certificate blob from userspace.

> 
> >  			__u32 type; /* KVM_USER_VMGEXIT_* type */
> >  			union {
> >  				struct {
> > @@ -3812,6 +3813,84 @@ static void snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp
> >  	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
> >  }
> >  
> > +static int snp_complete_ext_guest_req(struct kvm_vcpu *vcpu)
> > +{
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +	struct vmcb_control_area *control;
> > +	struct kvm *kvm = vcpu->kvm;
> > +	sev_ret_code fw_err = 0;
> > +	int vmm_ret;
> > +
> > +	vmm_ret = vcpu->run->vmgexit.ext_guest_req.ret;
> > +	if (vmm_ret) {
> > +		if (vmm_ret == SNP_GUEST_VMM_ERR_INVALID_LEN)
> > +			vcpu->arch.regs[VCPU_REGS_RBX] =
> > +				vcpu->run->vmgexit.ext_guest_req.data_npages;
> > +		goto abort_request;
> > +	}
> > +
> > +	control = &svm->vmcb->control;
> > +
> > +	/*
> > +	 * To avoid the message sequence number getting out of sync between the
> > +	 * actual value seen by firmware verses the value expected by the guest,
> > +	 * make sure attestations can't get paused on the write-side at this
> > +	 * point by holding the lock for the entire duration of the firmware
> > +	 * request so that there is no situation where SNP_GUEST_VMM_ERR_BUSY
> > +	 * would need to be returned after firmware sees the request.
> > +	 */
> > +	mutex_lock(&snp_pause_attestation_lock);
> 
> Why is this in KVM?  IIUC, KVM only needs to get involved to translate GFNs to
> PFNs, the rest can go in the sev-dev driver, no?  The whole split is weird,
> seemingly due to KVM "needing" to take this lock.  E.g. why is core kernel code
> in arch/x86/virt/svm/sev.c at all dealing with attestation goo, when pretty much
> all of the actual usage is (or can be) in sev-dev.c

It would be very tempting to have all this locking tucked away in sev-dev
driver, but KVM is a part of that sequence because it needs to handle fetching
the certificate that will be returned to the guest as part of the
attestation request. The transaction ID updates from PAUSE/RESUME
commands is technically enough satisfy this requirement, in which case
KVM wouldn't need to take the lock directly, only check that the
transaction ID isn't stale and report -EBUSY/-EAGAIN to the guest if it
is.

But if the request actually gets sent to firmware, and then we decide
after that the transaction is stale and thus the attestation response
and certificate might not be in sync, then reporting -EBUSY/-EAGAIN will
permanently hose the guest because the message seq fields will be out of
sync between firmware and guest kernel. That's why we need to hold the
lock to actually block a transaction ID update from occuring once we've
committed to sending the attestation request to firmware.

> 
> > +
> > +	if (__snp_transaction_is_stale(svm->snp_transaction_id))
> > +		vmm_ret = SNP_GUEST_VMM_ERR_BUSY;
> > +	else if (!__snp_handle_guest_req(kvm, control->exit_info_1,
> > +					 control->exit_info_2, &fw_err))
> > +		vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
> > +
> > +	mutex_unlock(&snp_pause_attestation_lock);
> > +
> > +abort_request:
> > +	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, SNP_GUEST_ERR(vmm_ret, fw_err));
> > +
> > +	return 1; /* resume guest */
> > +}
> > +
> > +static int snp_begin_ext_guest_req(struct kvm_vcpu *vcpu)
> > +{
> > +	int vmm_ret = SNP_GUEST_VMM_ERR_GENERIC;
> > +	struct vcpu_svm *svm = to_svm(vcpu);
> > +	unsigned long data_npages;
> > +	sev_ret_code fw_err;
> > +	gpa_t data_gpa;
> > +
> > +	if (!sev_snp_guest(vcpu->kvm))
> > +		goto abort_request;
> > +
> > +	data_gpa = vcpu->arch.regs[VCPU_REGS_RAX];
> > +	data_npages = vcpu->arch.regs[VCPU_REGS_RBX];
> > +
> > +	if (!IS_ALIGNED(data_gpa, PAGE_SIZE))
> > +		goto abort_request;
> > +
> > +	svm->snp_transaction_id = snp_transaction_get_id();
> > +	if (snp_transaction_is_stale(svm->snp_transaction_id)) {
> 
> Why bother?  I assume this is rare, so why not handle it on the backend, i.e.
> after userspace does its thing?  Then KVM doesn't even have to care about
> checking for stale IDs, I think?

That's true, it's little more than a very minor performance optimization
to do it here rather than on the return path, so could definitely be
dropped.

> 
> None of this makes much sense to my eyes, e.g. AFAICT, the only thing that can
> pause attestation is userspace, yet the kernel is responsible for tracking whether
> or not a transaction is fresh?

Pausing is essentially the start of an update transaction initiated by
userspace. So the kernel is tracking whether there's a potential
transaction that has been started or completed since it first started
servicing the attestation request, otherwise there could be a mismatch
between the endorsement key used for the attestation report versus the
certificate for the endorsement key that was fetched from userspace.

-Mike

