Return-Path: <kvm+bounces-38588-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D9C9A3C651
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 18:37:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4583F17985D
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 17:37:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AE652144A2;
	Wed, 19 Feb 2025 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="FjpOdZTg"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2045.outbound.protection.outlook.com [40.107.93.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E400B1FE461;
	Wed, 19 Feb 2025 17:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739986638; cv=fail; b=HTSepjqC3H7P+f0TVcX0N3fJT7NECWBfiUeiRNgyUrMmqtB/Lumtg6dtoXwTpW28yLsDP3frwvrE76B7ioNkPFilRIHHAAU8GFJN6eBKKm5otfTYQ/4+iYR2EDf3rCQjuKq5QMw1C1AjgdKNI1TiY+gnZD2gayFDLE6tqnJJbto=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739986638; c=relaxed/simple;
	bh=37KxNiMk/cSrishMa+r4rdhYan1/It9t8v3haO+VLlg=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QTUnHIthWzDH0ecm+sjNagXcy+Tfo6XJ7VaEOq9dJkUblD637nwVmnKhO+XujlSsrZjLePztuWy5OMXdjCEyrNmXRzaKVDwmMXEmgSjynhvL4t2/nfXEJe2gf91Z1536g0R0Pj0xaGpX51ltUJ+saqTJvwWtwKCKT9iUDkiwH/4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=FjpOdZTg; arc=fail smtp.client-ip=40.107.93.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gRpwcAaHZA0kELymkbdKmZPfoE0z5gy4slFDbUxfvkMAlIOFQ71Co1ffr6sAGFDPZasXO/BFvPmh3skW6rf4ym/BuvB9a+Ty6C0xHriNmwFQU0d5Jnk+IGRphTGxpcjgMsouEQ8u/2hHDAoOEjcuy+TXt5H3E/aFpQ99D79vcrkT+lSqJ3QjKOY0U3WVB29pNu1jLR0TKzWt1zXnayPtx/ssxWFYM+wXv/H5OMPeluIhzYKbCJH+EsHPEi4uA6218OkfVQgI5DbuprSc/x6y3+MF8qVDP+VqGA19hInC0/kyLOJdz0a9uBX+1R9ZvpRzghxeGNoEavUmrUfyqbsiwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8RA+Pm2HcasB0WHbTIIyshrS+6rdB1b78i91EnpXnb8=;
 b=tMBK+0iSJwcroxN4TbAJHkJGiaNspVqctfqblj1TUZ4PHZ3asorr7cbNuzWLemCFuG61Y0G+TPF8Z0f/4qtJ3uU4+VEJHWz6REx4Ksdx8qSYIIUJKhr8iep+PNoT/M6vn1MjvOpnOMlfgvK8KxwQhy9yDwNMc+rxh9W6VWvnCvoiy0+IwfJ6nPLYcuQxZ/DydLnO5+xneIfdrNMwHYWbwDe+NzHRc4zN9mi6uE0DJHk1NBosP+w5YxW6EwpaCqJmCRasKoM+ME4A1G73tGXCHGXW+eqXkFsGgzAoCE7GwwQ4QXrPQM/unvmEp96lt0XJPBs1PYiBFhl0IPlF0jl6FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8RA+Pm2HcasB0WHbTIIyshrS+6rdB1b78i91EnpXnb8=;
 b=FjpOdZTgw80pDczbAQUp/lVJWer9cDIiozkZfxc5SyFOFpD1EVsX/PfVCHSWfTu/ZPlPAMKQ2eNn7O9RmoLr733zsuMYf72grCVWTihydY7KkuPo216Xih3O8tpAD1gXVP4bQIY6hB5Zp2EIhfYtcLGWTShWnrK6oBMAkuEF3s0=
Received: from PH1PEPF000132E6.NAMP220.PROD.OUTLOOK.COM (2603:10b6:518:1::26)
 by SJ0PR12MB8140.namprd12.prod.outlook.com (2603:10b6:a03:4e3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8445.19; Wed, 19 Feb
 2025 17:37:12 +0000
Received: from CY4PEPF0000EDD0.namprd03.prod.outlook.com
 (2a01:111:f403:f912::1) by PH1PEPF000132E6.outlook.office365.com
 (2603:1036:903:47::3) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.20.8466.14 via Frontend Transport; Wed,
 19 Feb 2025 17:37:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EDD0.mail.protection.outlook.com (10.167.241.196) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.8466.11 via Frontend Transport; Wed, 19 Feb 2025 17:37:11 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Wed, 19 Feb
 2025 11:37:09 -0600
Date: Wed, 19 Feb 2025 11:36:28 -0600
From: Michael Roth <michael.roth@amd.com>
To: Dionna Amalie Glaze <dionnaglaze@google.com>
CC: Sean Christopherson <seanjc@google.com>, Melody Wang <huibo.wang@amd.com>,
	<kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	<roedel@suse.de>, Tom Lendacky <thomas.lendacky@amd.com>,
	<ashish.kalra@amd.com>, <liam.merwick@oracle.com>, <pankaj.gupta@amd.com>
Subject: Re: [PATCH v4 1/1] KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP
 certificate-fetching
Message-ID: <20250219173628.hlbrp4c7uf3wtv4r@amd.com>
References: <20250120215818.522175-1-huibo.wang@amd.com>
 <20250120215818.522175-2-huibo.wang@amd.com>
 <CAAH4kHZL-9R+MLLvArcwQ2Zpk+gtqYTvVMR01WA1kVJ9goq_sw@mail.gmail.com>
 <Z4_Qs2mAXK28IwJa@google.com>
 <CAAH4kHaCTGxQ_D+KbhJQ+RYL4n5qeG4UnDNu5FK9+3KJLpNw0Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAH4kHaCTGxQ_D+KbhJQ+RYL4n5qeG4UnDNu5FK9+3KJLpNw0Q@mail.gmail.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EDD0:EE_|SJ0PR12MB8140:EE_
X-MS-Office365-Filtering-Correlation-Id: 6c882517-582f-4a01-fec6-08dd510c0ac4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|82310400026|376014|1800799024|36860700013|13003099007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?N2VXaTlMVVJnZWVpZUlFVlFyQmJUb0JrQnVyZWRPTEhGTmtnSG9YWmg4UmJi?=
 =?utf-8?B?UnQ1VDBsRWJrK2FxTTVPRDdkc3pRRWE3cTdXMzZMc1NsQ2V3SzFkMUtPRXpk?=
 =?utf-8?B?N3NBMDRGRm1VRjkwSzlYMXVzOTd2SEsrMHQrSHZDdXRmR3N1OG44VStqZ1p6?=
 =?utf-8?B?Zkg5WUpheC9jbkFKakZzYk5oa0pkRGNsQ2dYNzUxQ3NqTjlxSnNUMDhkMy9l?=
 =?utf-8?B?bFE2S2VXam9ieWo1ZjRGNlQ0TzhmdTdkN3dsODVRNi9tRjNPTTRsQmEzMUdw?=
 =?utf-8?B?cWxOaEpldmlsVUpEc0RHZFFVbU9xM09FekJkZmRuRmN0MXNjclBHbVUyci8v?=
 =?utf-8?B?dm5iUFRrU3VaczE0dXBLWXEwUE5iamE4VXdLSkxJSTNmVWJhMmJ3YllVbFdH?=
 =?utf-8?B?c2pxQ2lacXYvVjFaRGtRUUx3SVhnS3JvWmFSNUNjOTVMenV0YVUzaERMNFYr?=
 =?utf-8?B?RVJRT1l4Z2wzU0VDek1GeS9kdjBCaDVvYzMrZFBReUx6NVJDRzVuMnU5M2tN?=
 =?utf-8?B?dWQ0SDNtM0xGVXVmcTkwOGMrbkxOZ29BOWs3ZTI5SHE2Lzhsc1dobXR2VU5J?=
 =?utf-8?B?Nkd2WkhML3g0NnBIa3ZYeC9ralJubXdKSDE1TGhpK1JHQUc3amFJME9rTW0y?=
 =?utf-8?B?eVlod2RnYk44ZG1CK0I0MEEzaVNPTUwxb1VYYmtTb3lFc2YxNU1ZRVFrcjRu?=
 =?utf-8?B?MkhnZS9BdVpzTk8wZWdlN2JMcGRYSThHaWVPVnNDbEVJVFY1THJKa2JpYUpr?=
 =?utf-8?B?eGpYdm9oL2xiSmw4NDVNaUxRSnRJSEJRamdodFVQRmN6TEV5RWo4THRwb25a?=
 =?utf-8?B?eGtoQmVRQXBwczh0UzBkZXNBOEhhODRad3paUy9OeXU1VUZMU3JVUG9MMk1J?=
 =?utf-8?B?R1ZTOHBxK1RzcldCTzBqVUgyQlZRL0pweEFYbkhnUnBhb2tQUzVnNFUvV1JF?=
 =?utf-8?B?VzkrbkhUTTkyODdHclk3WE9wTGNxem5JVFEzdFpOOVFrMnQ5c092ZTZQRWg2?=
 =?utf-8?B?TlM5dHQrMXcybndhUHdoNUJzekUzMUhVcUlTS1dwcmF1SXNVWUk4Y1JaaVUw?=
 =?utf-8?B?YWtzYWZhQmVJbDZ4OXI0SFo5a1doN3dCUTBNclVhek94dGZnU3VMRllBV29a?=
 =?utf-8?B?Y3F2bTVUQUo0Z2t6Z1Z1QldvL1ZKNXpzMy9OU0VpM1lGWDljTTk3WUc2SDdo?=
 =?utf-8?B?MVVkckR4QVZlaEhiTDZBekoxaE1YSUQ3VHp3TWxBL2tsdVE1eUVneWpYZGpM?=
 =?utf-8?B?WHRYWWVvVFdseWhhamJMUjB0VGVnUzFFdTM2WWN5YVF0ZmhaZ1JFZDk4KzlZ?=
 =?utf-8?B?YkxudVg1aGhwQmNaZXIzWUt1ZGl1ZXV0ZFQyL2JYTEtvZUhjUDkyY2o3MStK?=
 =?utf-8?B?TVNybHN1TlZ3NXVnR0VtaU1vYUpsYXJzT0ZNbjIyUmJocDdNNHNNQ2UwZmpC?=
 =?utf-8?B?Mnl1VTdjUlp6ZGh1SGtGU1JlYnpDSTZvaXVzcHdHRUl1d1pBa1ZyOWFKZ2Jq?=
 =?utf-8?B?TEkvK21IdjVoUE81dmhhY3kvN2EwZGxIRWRvL05Ca0piRkt5NHY5U05sU1N2?=
 =?utf-8?B?WVdXUkkwK25sWFNpU05hUERldjdNQno0clIrQmprTXdVeS9sMWU3Z1ZQd21L?=
 =?utf-8?B?L05YTm5YSnUyd2JGZlNnWjdESEwvZWFkSjh1RGtrNU80ZkN0dFNESW9abXNu?=
 =?utf-8?B?U0hRVFpBWitoYUNlNXFMOXBvTm1sSXZ3TGxxczduQnlDU1hFQVdqY0l0R1JO?=
 =?utf-8?B?NjhEOUF5aEtObHEwRXM5MkpyOFppTGZML2dNTTlwTm1UVUpBMkNFQ1Vpdmxz?=
 =?utf-8?B?a0IxOHoyKzFFbXVmdFErVFhnRXk3a3BaTlNpMkRoWUFmRlRZWFhoK1k0blR4?=
 =?utf-8?B?YXJHa1FDQ0dVYmlBVk44S2FhV1BXcXg5cmpMNi9ISnBEbzJwVjVHU01zSlNW?=
 =?utf-8?B?RVdYSkV4STFCcVJzV3EyRExLZU4wc0IwdW1xVmE1S0JudjEzWWJ1cEdQYmpL?=
 =?utf-8?B?a21HKzhnTE12aEpldzdtcWw5dFo1MWdERS9MOWNDV3BTcmo2MXBLZEt2bHM2?=
 =?utf-8?Q?ZhNJbr?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(82310400026)(376014)(1800799024)(36860700013)(13003099007);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2025 17:37:11.7055
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c882517-582f-4a01-fec6-08dd510c0ac4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EDD0.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB8140

On Tue, Jan 21, 2025 at 09:19:08AM -0800, Dionna Amalie Glaze wrote:
> On Tue, Jan 21, 2025 at 8:52 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > On Tue, Jan 21, 2025, Dionna Amalie Glaze wrote:
> > > On Mon, Jan 20, 2025 at 1:58 PM Melody Wang <huibo.wang@amd.com> wrote:
> > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > index 943bd074a5d3..4896c34ed318 100644
> > > > --- a/arch/x86/kvm/svm/sev.c
> > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > @@ -4064,6 +4064,30 @@ static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_
> > > >         return ret;
> > > >  }
> > > >
> > > > +static int snp_complete_req_certs(struct kvm_vcpu *vcpu)
> > > > +{
> > > > +       struct vcpu_svm *svm = to_svm(vcpu);
> > > > +       struct vmcb_control_area *control = &svm->vmcb->control;
> > > > +
> > > > +       if (vcpu->run->snp_req_certs.ret) {
> > > > +               if (vcpu->run->snp_req_certs.ret == ENOSPC) {
> > > > +                       vcpu->arch.regs[VCPU_REGS_RBX] = vcpu->run->snp_req_certs.npages;
> > > > +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > > > +                                               SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_INVALID_LEN, 0));
> > > > +               } else if (vcpu->run->snp_req_certs.ret == EAGAIN) {
> > > > +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > > > +                                               SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_BUSY, 0));
> > >
> > > Discussion, not a change request: given that my proposed patch [1] to
> > > add rate-limiting for guest messages to the PSP generally was
> > > rejected,
> >
> > For the record, it wasn't rejected outright.  I pointed out flaws in the proposed
> > behavior[*], and AFAICT no one ever responded.  If I fully reject something, I
> > promise I will make it abundantly clear :-)
> >
> 
> Okay, well it was a no to the implementation strategy I had chosen and
> did not have bandwidth to change. Your suggestion to exit to userspace
> is more aligned with the topic of discussion now.
> 
> > [*] https://lore.kernel.org/all/Y8rEFpbMV58yJIKy@google.com
> >
> > > do we think it'd be proper to add a KVM_EXIT_SNP_REQ_MSG or
> > > some such for the VMM to decide if the guest should have access to the
> > > globally shared resource (PSP) via EAGAIN or 0?
> >
> > Can you elaborate?  I don't quite understand what you're suggesting.
> >
> 
> I just mean that instead of only exiting to the VMM on an extended
> guest request and this capability enabled, all guest requests exit to
> the VMM to make the decision to permit access to the device. EAGAIN
> means busy, try again later, and 0 means permit the request. That
> allows for implementation-specific throttling policies to be
> implemented.

Discussed this with Sean on the PUCK call last week and our thinking was
that tying throttling support to a new KVM_EXIT_* type would not be
compatible with existing userspaces unless it is opt-in, and requiring
userspace to opt-in would not be ideal if DoS on the part of guest-owner is
a concern.

So most likely the more generalized exit-to-userspace throttling behavior
would be tied to something pre-existing, like existing EAGAIN/EINTR handling
for the KVM_RUN ioctl or something along that line.

And if the throttling occurs as part of this particular path, we still have
the option of using the SNP_GUEST_VMM_ERR_BUSY response to guest to force a
retry while still giving userspace the immediate_exit-triggered exit it
needs to release the lock and complete things on its end.

So, since throttling support doesn't seem like a blocker for this series, I
went ahead and sent a v5 with some minor documentation updates:

  https://lore.kernel.org/kvm/20250219151505.3538323-1-michael.roth@amd.com/

Thanks!

-Mike

> 
> > > [1] https://patchwork.kernel.org/project/kvm/cover/20230119213426.379312-1-dionnaglaze@google.com/
> > >
> > > > +               } else {
> > > > +                       ghcb_set_sw_exit_info_2(svm->sev_es.ghcb,
> > > > +                                               SNP_GUEST_ERR(SNP_GUEST_VMM_ERR_GENERIC, 0));
> > > > +               }
> > > > +
> > > > +               return 1; /* resume guest */
> > > > +       }
> > > > +
> > > > +       return snp_handle_guest_req(svm, control->exit_info_1, control->exit_info_2);
> > > > +}
> 
> 
> 
> -- 
> -Dionna Glaze, PhD, CISSP, CCSP (she/her)
> 

