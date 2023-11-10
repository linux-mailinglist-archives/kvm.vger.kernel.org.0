Return-Path: <kvm+bounces-1501-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 862747E8550
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:08:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AEB5D1C20A8B
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 22:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68253C6BF;
	Fri, 10 Nov 2023 22:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Ets9i2x0"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A913C697;
	Fri, 10 Nov 2023 22:08:17 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2079.outbound.protection.outlook.com [40.107.94.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0374205;
	Fri, 10 Nov 2023 14:08:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtTV5tuSrQmacUVva3gQgEPlITnlswwmezhuONTzXoTTI8pI0NaWIyeZ6runTvLDab+3mm2PQ/5I0F6mT3S12woLvSOrkJhiIGLZIqRu62lrnT0PHb5pzHP40Pay3Vq+O6Z+fg7L6qHHCkrKDlOULqd0clAXXiwkMxDDvndMdNHUwbjtu8rUn2Fj34Ws1gr5rEw9u8RY+NtELBG+xwCVkfqJYgP3JV8MJy/JFBubLFN2wPOAqGbnHmFi3uO3jbGbc2LSK7Ym64DTK8mimgKkBpxGHgIpYByt2pCAdBAqW84kMLUq6lwnOeudhK+bmtKp0ac1/gFZZjxu9v1eEVVwOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Qa3PqD4sOPR/HFdOo2x936pkipuYUXli9vflwTmetfw=;
 b=OJTYiXFQkm5rjRjqYW3aCxREDyMcC7GiR/hGfZvLWDJV4jLC0D3Au6auy87PKmcpQYVskY1sGBlIk4AaYcDOc1yEyee+apbR46A8GLK5OUNPbtJEKcuWzBwqr/nD7z7eFRr8IUGXgoV/Taley5rhlxl9wlhmdHsa3Sd5GF+zgYJBl6EmUgTGgO+1l66M+eIYSjdN+RSyTY/tgVJXzfpn3js6dqlojYrR1SAlmpSHBa53owtlRJ4/gSJ+MpN0puV4YJvljaHgp+J7oc7MgUZD5ytgJdk9qJw8LhgQSq44hS+XdJ/wq6oa6hmd7VRpf9KC0bS/sn1yQKTl9kT/2qghqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qa3PqD4sOPR/HFdOo2x936pkipuYUXli9vflwTmetfw=;
 b=Ets9i2x0ODGncJohlvy4ilibYmZB/E+lEAFH3XVwlvkFi8+ud3SdciGy+wh8YVlReIwXyzpRCseFrTKmoRqCsucGJN/b8G/bYQwF5xNyEd/Z8gzFXfliChKO7javE/5jMG+MuemmLn5AWsLKnkCDcioMO8K4lZi0iBrMalbzwxA=
Received: from CY5PR03CA0029.namprd03.prod.outlook.com (2603:10b6:930:8::30)
 by CY8PR12MB7196.namprd12.prod.outlook.com (2603:10b6:930:58::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.19; Fri, 10 Nov
 2023 22:08:13 +0000
Received: from CY4PEPF0000EE3B.namprd03.prod.outlook.com
 (2603:10b6:930:8:cafe::22) by CY5PR03CA0029.outlook.office365.com
 (2603:10b6:930:8::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.19 via Frontend
 Transport; Fri, 10 Nov 2023 22:08:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE3B.mail.protection.outlook.com (10.167.242.15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6977.21 via Frontend Transport; Fri, 10 Nov 2023 22:08:12 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.32; Fri, 10 Nov
 2023 16:08:12 -0600
Date: Fri, 10 Nov 2023 16:07:56 -0600
From: Michael Roth <michael.roth@amd.com>
To: Sean Christopherson <seanjc@google.com>
CC: Alexey Kardashevskiy <aik@amd.com>, Dionna Amalie Glaze
	<dionnaglaze@google.com>, <kvm@vger.kernel.org>,
	<linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, <zhi.a.wang@intel.com>,
	Brijesh Singh <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 48/50] KVM: SEV: Provide support for
 SNP_GUEST_REQUEST NAE event
Message-ID: <20231110220756.7hhiy36jc6jiu7nm@amd.com>
References: <20231016132819.1002933-1-michael.roth@amd.com>
 <20231016132819.1002933-49-michael.roth@amd.com>
 <CAAH4kHb=hNH88poYw-fj+ewYgt8F-hseZcRuLDdvbgpSQ5FDZQ@mail.gmail.com>
 <ZS614OSoritrE1d2@google.com>
 <b9da2fed-b527-4242-a588-7fc3ee6c9070@amd.com>
 <ZS_iS4UOgBbssp7Z@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZS_iS4UOgBbssp7Z@google.com>
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE3B:EE_|CY8PR12MB7196:EE_
X-MS-Office365-Filtering-Correlation-Id: 74160f65-08e6-4019-9370-08dbe2398842
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	1xpUF3nGWUErzC/4Un2J4zzu+1i3Q1dcMo1MGqVFf2IPWgXgdQdqk9+CLGeHDioH9D9KNuoFGXbXujCPyn149MjS8s7BPIyj/qvU23hhBfPdOPrUcgAHxSDkUaUXy7NHTwS/QvT9SlY49Ay7kX+YC8DdfPdEK1gOeHf47vDadSXPf3mwTM3gZYsgrZDV6Z/p7k1NR5DuCvABB6nXpmQJgJGuDXHrbP3MMqbxfxKjEracfEBCA3odA75c3M+jeqRftEcONhpp4WdIcfL3aua7uupBVHO/9KSDLwO3wojh9zby023Ik+DUQu+2BfTOn5A+iBgT/rWrkf+1BwuMhodcGQdOKxHIy+412MIi7SoVxLciwX8GYI5kykTp5HFhPPZdC6Plte9BM8KB/CrnGRMaCKqbb2+ruyKMv+N5a8R3EvrF9tvCc+DsYMRk27R3ZH9MRuw5C+PUzSYGEujZq3CHx9W1BI7mv6PT388CDMJ3ouAPi7B4dS2DCMTfZJRqTJ1KBlM+Cd5Ni/qJbMB53P8npXYichVe1KL1BT5kxL66k+CAPySJMjNlO2jXDwA5ODtb6qspwP2SKSlYDjhoVCt0Sc2Uu6GC8SrR2s+FsHbJR2QPZ6UzCdLR4ImKyFMHtULUTbxX0QQ+kcdfGXotyZXz75JbMxQQbS1rnrz0K+ky2QrY1IOeT6lu6bnXNMJplvkMxxJTy/cyI47K2C2zNLhG6EtbzCvyFqqH7uZBy+7coe3XZlwDCNQuSH1hsuNg1owEjTH8PiubDhaIdHZ6pcBBIg==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(4636009)(376002)(39860400002)(346002)(396003)(136003)(230922051799003)(1800799009)(451199024)(64100799003)(82310400011)(186009)(46966006)(36840700001)(40470700004)(36860700001)(478600001)(53546011)(6666004)(47076005)(26005)(16526019)(83380400001)(426003)(54906003)(316002)(40480700001)(70586007)(6916009)(70206006)(2616005)(1076003)(7406005)(5660300002)(82740400003)(40460700003)(44832011)(8676002)(66899024)(4326008)(8936002)(336012)(7416002)(41300700001)(36756003)(86362001)(2906002)(356005)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2023 22:08:12.8728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74160f65-08e6-4019-9370-08dbe2398842
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE3B.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7196

On Wed, Oct 18, 2023 at 06:48:59AM -0700, Sean Christopherson wrote:
> On Wed, Oct 18, 2023, Alexey Kardashevskiy wrote:
> > 
> > On 18/10/23 03:27, Sean Christopherson wrote:
> > > On Mon, Oct 16, 2023, Dionna Amalie Glaze wrote:
> > > > > +
> > > > > +       /*
> > > > > +        * If a VMM-specific certificate blob hasn't been provided, grab the
> > > > > +        * host-wide one.
> > > > > +        */
> > > > > +       snp_certs = sev_snp_certs_get(sev->snp_certs);
> > > > > +       if (!snp_certs)
> > > > > +               snp_certs = sev_snp_global_certs_get();
> > > > > +
> > > > 
> > > > This is where the generation I suggested adding would get checked. If
> > > > the instance certs' generation is not the global generation, then I
> > > > think we need a way to return to the VMM to make that right before
> > > > continuing to provide outdated certificates.
> > > > This might be an unreasonable request, but the fact that the certs and
> > > > reported_tcb can be set while a VM is running makes this an issue.
> > > 
> > > Before we get that far, the changelogs need to explain why the kernel is storing
> > > userspace blobs in the first place.  The whole thing is a bit of a mess.
> > > 
> > > sev_snp_global_certs_get() has data races that could lead to variations of TOCTOU
> > > bugs: sev_ioctl_snp_set_config() can overwrite psp_master->sev_data->snp_certs
> > > while sev_snp_global_certs_get() is running.  If the compiler reloads snp_certs
> > > between bumping the refcount and grabbing the pointer, KVM will end up leaking a
> > > refcount and consuming a pointer without a refcount.
> > > 
> > > 	if (!kref_get_unless_zero(&certs->kref))
> > > 		return NULL;
> > > 
> > > 	return certs;
> > 
> > I'm missing something here. The @certs pointer is on the stack,
> 
> No, nothing guarantees that @certs is on the stack and will never be reloaded.
> sev_snp_certs_get() is in full view of sev_snp_global_certs_get(), so it's entirely
> possible that it can be inlined.  Then you end up with:
> 
> 	struct sev_device *sev;
> 
> 	if (!psp_master || !psp_master->sev_data)
> 		return NULL;
> 
> 	sev = psp_master->sev_data;
> 	if (!sev->snp_initialized)
> 		return NULL;
> 
> 	if (!sev->snp_certs)
> 		return NULL;
> 
> 	if (!kref_get_unless_zero(&sev->snp_certs->kref))
> 		return NULL;
> 
> 	return sev->snp_certs;
> 
> At which point the compiler could choose to omit a local variable entirely, it
> could store @certs in a register and reload after kref_get_unless_zero(), etc.
> If psp_master->sev_data->snp_certs is changed at any point, odd thing can happen.
> 
> That atomic operation in kref_get_unless_zero() might prevent a reload between
> getting the kref and the return, but it wouldn't prevent a reload between the
> !NULL check and kref_get_unless_zero().
> 
> > > If userspace wants to provide garbage to the guest, so be it, not KVM's problem.
> > > That way, whether the VM gets the global cert or a per-VM cert is purely a userspace
> > > concern.
> > 
> > The global cert lives in CCP (/dev/sev), the per VM cert lives in kvmvm_fd.
> > "A la vcpu->run" is fine for the latter but for the former we need something
> > else.
> 
> Why?  The cert ultimately comes from userspace, no?  Make userspace deal with it.
> 
> > And there is scenario when one global certs blob is what is needed and
> > copying it over multiple VMs seems suboptimal.
> 
> That's a solvable problem.  I'm not sure I like the most obvious solution, but it
> is a solution: let userspace define a KVM-wide blob pointer, either via .mmap()
> or via an ioctl().
> 
> FWIW, there's no need to do .mmap() shenanigans, e.g. an ioctl() to set the
> userspace pointer would suffice.  The benefit of a kernel controlled pointer is
> that it doesn't require copying to a kernel buffer (or special code to copy from
> userspace into guest).
> 
> Actually, looking at the flow again, AFAICT there's nothing special about the
> target DATA_PAGE.  It must be SHARED *before* SVM_VMGEXIT_EXT_GUEST_REQUEST, i.e.
> KVM doesn't need to do conversions, there's no kernel priveleges required, etc.
> And the GHCB doesn't dictate ordering between storing the certificates and doing
> the request.  That means the certificate stuff can be punted entirely to usersepace.
> 
> Heh, typing up the below, there's another bug: KVM will incorrectly "return" '0'
> for non-SNP guests:

Thanks for the catch, will fix that up.

> 
> 	unsigned long exitcode = 0;
> 	u64 data_gpa;
> 	int err, rc;
> 
> 	if (!sev_snp_guest(vcpu->kvm)) {
> 		rc = SEV_RET_INVALID_GUEST; <= sets "rc", not "exitcode"
> 		goto e_fail;
> 	}
> 
> e_fail:
> 	ghcb_set_sw_exit_info_2(svm->sev_es.ghcb, exitcode);
> 
> Which really highlights that we need to get test infrastructure up and running
> for SEV-ES, SNP, and TDX.
> 
> Anyways, back to punting to userspace.  Here's a rough sketch.  The only new uAPI
> is the definition of KVM_HC_SNP_GET_CERTS and its arguments.

This sketch seems like a good, flexible way to handle per-VM certs, but
it does complicate things from a userspace perspective. As a basic
requirement, all userspaces will need to provide a way to specify the
initial blob (either a very verbose base64-encoded userspace cmdline param,
or a filepatch that needs additional management to store and handle
permissions/etc.), and also a means to update it (e.g. a HMP/QMP command
for QEMU, some libvirt wrappers, etc.).

That's all well and good if you want to make use of per-VM certs, but we
don't necessarily expect that most deployments will necessarily want to deal
with per-VM certs, and would be happy with a system-wide one where they could
simply issue the /dev/sev ioctl to inject one automatically for all guests.

So we're sort of complicating the more common case to support a more niche
one (as far as userspace is concerned anyway; as far as kernel goes, your
approach is certainly simplest :)).

Instead, maybe a compromise is warranted so the requirements on userspace
side are less complicated for a more basic deployment:

  1) If /dev/sev is used to set a global certificate, then that will be
     used unconditionally by KVM, protected by simple dumb mutex during
     usage/update.
  2) If /dev/sev is not used to set the global certificate is the value
     is NULL, we assume userspace wants full responsibility for managing
     certificates and exit to userspace to request the certs in the manner
     you suggested.

Sean, Dionna, would this cover your concerns and address the certificate
update use-case?

-Mike

