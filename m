Return-Path: <kvm+bounces-15974-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5287A8B2A2C
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 22:53:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8704528179F
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:53:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C6BC154C05;
	Thu, 25 Apr 2024 20:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ZMKleomv"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2053.outbound.protection.outlook.com [40.107.93.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB1612BF28;
	Thu, 25 Apr 2024 20:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714078387; cv=fail; b=Dg1bOWnckOUUCI9sMOi85ITmWhDq0QLiixIqMZC6M56nw0v4fs33ZKecG58dkwLPUAPxIQdv+hizjVXuVd6lseC7t/H7ZIkha8Nt20+bJlPetd3TDApuldzDm7Bszh8cRZpOsIT21k4H3VhY8q25hFPi34F+TTnDT87apMuMVkA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714078387; c=relaxed/simple;
	bh=y7O2n8GFxaZIKlv023zL+gW93ZBCvk+DO9oidVloYyw=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ex+ya9egVZwhCPJqtUjoCUfYkfBe7L7Nh4MbXbq2QCWng6wjz8V4ZbAn5T+TBjAB/onBsiMFkvbbYX0gcZCIqBLPfVFdCS1Nn5Wmkql+6wYQu61TOLoul5lTn0nm2ndz9dLW4eBn8eurmrUFwxlnPu3yyIW5Gq+x30dXRVqEdXQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ZMKleomv; arc=fail smtp.client-ip=40.107.93.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpjkFaXqMSR7mnB6l81qNkEuVlNRi+Py257V/+nIA9DWiGm+XjXNraw6TsRYoo1zp/8ibGVl8Mut8w4v92okbY52yLWTstzX7icqPOrP+81E48rvyv+BOjlI8FEnPra3w3CdaJojiijjnNaUW/l3ItF2YXc3G6Bp4gnfY+YFbg55o7DyC5R39QN+3WXmMHI3QOe89FmLxYe1IUJ2JGi194PPt+d+RoQJ+Scw5j3++dJoVE34/KYBqkfmqSx0IU5pPCcSksUNqywFbzxASIpQxvVZ2O8+9nMf7vo+dtGH33jKXjxie9Or+vlcCBAHBw2gnKk0/STgcP9cOaqJ/2JW2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tl4SuDZKIAbWp3eQAISq0lFtevVWthP2D44SsRivvZU=;
 b=CzA1fMNemCEFt1qwMsRD7cMkcIX5fIJ36MQhsI4A/Zhk46o3mCmRpS+zSvOQMp4kQn/vRxlOjWVxkChkd0XZw4h2NbrU7OyX7Y4nh/J5K0eyMlqqYxont8zkMwNMrKwGZxvGQtc2rRSatCzQqHRobkFxwBHAGWzO+8W/fli8cCu/Gd7kFimjcbhQy2QsAYwl7FqIdqG3PCFlHZS2sLA4IOqnJOJynNjx+6rMVHAsG96wEfg1sJ3BjSrni3A0ZSiV23xPvMHa6KEZY06hVIMtvorQYFBU8WWMeud852KzNn1pAGX0KjqsylACTjfAsQHQonm2yG0VMT11eZQZtWOCVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=google.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tl4SuDZKIAbWp3eQAISq0lFtevVWthP2D44SsRivvZU=;
 b=ZMKleomvuaQlOfRurjeojp1YQQ90iZFjxsSHD6DnL5cUYjPQ8zOwzlY8mQ+m3/ua6ashL6abm0Gq1UzOk8q1YgDTAIAKtIl4T9BlRPVjOnu6hQwnCfG/0VkgGtRuOqqS8nrb3QvOgl0xMNiz/73/aFFyol0m5nr/UxNoMdb0TvE=
Received: from CH0PR03CA0292.namprd03.prod.outlook.com (2603:10b6:610:e6::27)
 by DM6PR12MB4267.namprd12.prod.outlook.com (2603:10b6:5:21e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 20:53:00 +0000
Received: from CH1PEPF0000A34B.namprd04.prod.outlook.com
 (2603:10b6:610:e6:cafe::d6) by CH0PR03CA0292.outlook.office365.com
 (2603:10b6:610:e6::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.25 via Frontend
 Transport; Thu, 25 Apr 2024 20:53:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CH1PEPF0000A34B.mail.protection.outlook.com (10.167.244.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7519.19 via Frontend Transport; Thu, 25 Apr 2024 20:53:00 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Thu, 25 Apr
 2024 15:52:59 -0500
Date: Thu, 25 Apr 2024 15:52:45 -0500
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
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>, Brijesh Singh
	<brijesh.singh@amd.com>
Subject: Re: [PATCH v14 03/22] KVM: SEV: Add GHCB handling for Hypervisor
 Feature Support requests
Message-ID: <20240425205245.aga3cyo5qa5xfnee@amd.com>
References: <20240421180122.1650812-1-michael.roth@amd.com>
 <20240421180122.1650812-4-michael.roth@amd.com>
 <Zilp3Sp5S-sljoQE@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Zilp3Sp5S-sljoQE@google.com>
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH1PEPF0000A34B:EE_|DM6PR12MB4267:EE_
X-MS-Office365-Filtering-Correlation-Id: c7a4f6af-6154-47c6-9fcc-08dc6569b154
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230031|36860700004|82310400014|376005|7416005|1800799015;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?0NX9a4xDVhMcRhakdMkydHDRkoC/mWeNBDDAfTF2XgiEPsLB8cIaVBx8cYCN?=
 =?us-ascii?Q?DDNELqhUJNjJ7RpU2reZ/44keS2EnCFG4q8I8GOE1kAoSZ0g/tKEB5v3h68F?=
 =?us-ascii?Q?9OuiiplAduyMua3WiNLdy4TFb9b89iZUB2+YC9GtdLELYpBjSkYDn9PtLW09?=
 =?us-ascii?Q?hFTTwVzm6pVeBDe6UzI6gYQnBBlD5ZRrfeI14VaFgyT+buhKiTBOD3wZesc1?=
 =?us-ascii?Q?6fPOI5R6gjmk1tk4Q+X6/WsP/2Q4UPcl6VRjbRIzKy8VKcBBWFBbVnYxdNLM?=
 =?us-ascii?Q?Y0BXwEJz1Tbc7GSk1rt1zfwYUBl4mln5oZTO8AzCLGuXw75AS6oWcrLwBigd?=
 =?us-ascii?Q?6dTB/RoF29iyrg0oM26HFqRui7NKrR8Nkytx4p3OBZRu1GBezD72QXGPtEDb?=
 =?us-ascii?Q?wrNTTxc3TY9SbMxJzenClURDZBr83UhoPDKM92EMZ0yEwpb7eFIMgAEa/IVb?=
 =?us-ascii?Q?0XX1YtyaEf1LhLWs2asE0YzdWi2HkccGcQH8FmwobMRWUpik6471FZU9VUCG?=
 =?us-ascii?Q?G0jLH7lcRMvZA296W5wZihnOH4RxtHcGrj+TI80DiiHnJI4QOfZz4VznT0uL?=
 =?us-ascii?Q?L+ZpVaB1XGhKsCDaspk56B1EjdCqFfBlKpAl3KOO5Fl/dcXix0BJOmq1juYO?=
 =?us-ascii?Q?3CZx0rQAtZLRzkvR7vPDJCBc93JuItU+ssJeJPrt93W8NpJA4nA15zVu8+85?=
 =?us-ascii?Q?5sy8bRUUQAj0+QA9W+vPFtL9dHv3sK+ehQuYKGwxY40EBh5UqbDg/KwVQCAG?=
 =?us-ascii?Q?VaUIWEz5hK3UPowSjV/K+QDooD6D+Owvd5jUEJC/C1r2OOc259U+d1v59UHf?=
 =?us-ascii?Q?JMrO+sqFJUhCmRoS3KaWOlMY79LP9Weg9iEWFMU1NjXToh+t7/rmgKQ4mltf?=
 =?us-ascii?Q?r+oaWVMq8mlF9yVRASTsCQvCh7rz6BNw3biTtuSSv6G8GKhno5IvASZRM5CJ?=
 =?us-ascii?Q?/OtmQIp78EKNGRQxm2ynrJHI02ztTQBIgtugZ6pA75Q/OAKtlRCp+XL8Tf8m?=
 =?us-ascii?Q?f9VxBwm98H/RRgWXSw514QPw1aSy3l7tdkukS5uYfkuDEIGrtNSg4ovh736l?=
 =?us-ascii?Q?JPubmJK7VUttMDKCzcAkiACzuHAzOGTjF0+bB9x9nggkXIT+mZlbAQkZ0ZRm?=
 =?us-ascii?Q?AkWCxV/jQl0Wru/4JtfGApALWdkdTauzgXeGYmuSef/Jx9ascXzKJo4Dz306?=
 =?us-ascii?Q?EDbucYClH8sdEa6bEOoVcPS17PT54L3JYNqBQrwxr7EopnayAe0ckMbpYAic?=
 =?us-ascii?Q?uPm/V502k0JTAuneR93AqtQd1ipoyYBkFFkrhw8qU/yYbr5HBMR+l035pruC?=
 =?us-ascii?Q?+mdZzTYkiSGR+jV1Rf7nS1pH?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(36860700004)(82310400014)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2024 20:53:00.0071
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c7a4f6af-6154-47c6-9fcc-08dc6569b154
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CH1PEPF0000A34B.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4267

On Wed, Apr 24, 2024 at 01:21:49PM -0700, Sean Christopherson wrote:
> On Sun, Apr 21, 2024, Michael Roth wrote:
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 6e31cb408dd8..1d2264e93afe 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -33,9 +33,11 @@
> >  #include "cpuid.h"
> >  #include "trace.h"
> >  
> > -#define GHCB_VERSION_MAX	1ULL
> > +#define GHCB_VERSION_MAX	2ULL
> >  #define GHCB_VERSION_MIN	1ULL
> 
> This needs a userspace control.  Being unable to limit the GHCB version advertised
> to the guest is going to break live migration of SEV-ES VMs, e.g. if a pool of
> hosts has some kernels running this flavor of KVM, and some hosts running an
> older KVM that doesn't support v2.
> 

The requirements for implementing the non-SNP aspects of the GHCB
version 2 protocol are fairly minimal, and KVM_SEV_INIT2 is already
migration incompatible with older kernels running KVM_SEV_ES_INIT (e.g.
migrate to newer host, shutdown, start -> measurement failure). There
are QEMU patches here that allow for controlling this via QEMU versioned
machine types to handle this [1]

So I think it makes sense to go ahead move to GHCB version 2 as the base
version for all SEV-ES/SNP guests created via KVM_SEV_INIT2, and leave
KVM_SEV_ES_INIT restricted to GHCB version 1.

This could be done in a pretty self-contained way for SEV-ES by applying
the following patches from this series which are the version 2 protocol
interfaces also applicable to SEV-ES:

  KVM: SEV: Add GHCB handling for Hypervisor Feature Support requests
  KVM: SEV: Add support to handle AP reset MSR protocol
  KVM: SEV: Add support for GHCB-based termination requests

And then applying the below patch on top to set GHCB version 1 or 2
accordingly for SEV-ES. (and relocating the GHCB_VERSION_MAX bump to the
below patch as well, although it's not really used at that point so
could also just be dropped completely).

Then in the future we can extend KVM_SEV_INIT2 to allow specifying
specific/newer versions of the GHCB protocol when that becomes needed.

If that sounds appropriate I can submit as a separate standalone patchset
for SEV-ES and then make that a prereq for the remaining SNP-specific bits.

-Mike

[1] https://lore.kernel.org/kvm/20240409230743.962513-1-michael.roth@amd.com/


commit 114da695c065595f74fe8aa0e9203f3c65175a95
Author: Michael Roth <michael.roth@amd.com>
Date:   Thu Apr 25 14:42:17 2024 -0500

    KVM: SEV: Allow per-instance tracking of GHCB protocol version
    
    The GHCB protocol version may be different from one guest to the next.
    Add a field to track it and initialize it accordingly when KVM_SEV_INIT,
    KVM_SEV_ES_INIT, and KVM_SEV_INIT2 are called.
    
    Signed-off-by: Michael Roth <michael.roth@amd.com>

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 1137a7f4136b..5c16abc47541 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -310,7 +310,7 @@ static void sev_unbind_asid(struct kvm *kvm, unsigned int handle)
 
 static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 			    struct kvm_sev_init *data,
-			    unsigned long vm_type)
+			    unsigned long vm_type, u16 ghcb_version)
 {
 	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
 	struct sev_platform_init_args init_args = {0};
@@ -333,6 +333,7 @@ static int __sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp,
 	sev->active = true;
 	sev->es_active = es_active;
 	sev->vmsa_features = data->vmsa_features;
+	sev->ghcb_version = ghcb_version;
 
 	if (vm_type == KVM_X86_SNP_VM)
 		sev->vmsa_features |= SVM_SEV_FEAT_SNP_ACTIVE;
@@ -376,7 +377,13 @@ static int sev_guest_init(struct kvm *kvm, struct kvm_sev_cmd *argp)
 		return -EINVAL;
 
 	vm_type = (argp->id == KVM_SEV_INIT ? KVM_X86_SEV_VM : KVM_X86_SEV_ES_VM);
-	return __sev_guest_init(kvm, argp, &data, vm_type);
+
+	/*
+	 * KVM_SEV_ES_INIT has been deprecated by KVM_SEV_INIT2, so it will
+	 * continue to only ever support the minimal GHCB protocol version.
+	 */
+	return __sev_guest_init(kvm, argp, &data, vm_type,
+				vm_type == KVM_X86_SEV_ES_VM ? GHCB_VERSION_MIN : 0);
 }
 
 static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
@@ -395,7 +402,15 @@ static int sev_guest_init2(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	if (copy_from_user(&data, u64_to_user_ptr(argp->data), sizeof(data)))
 		return -EFAULT;
 
-	return __sev_guest_init(kvm, argp, &data, kvm->arch.vm_type);
+	/*
+	 * Currently KVM supports the full range of mandatory features defined by
+	 * version 2 of the GHCB protocol, so default to that for SEV/SNP guests
+	 * created via KVM_SEV_INIT2. Care should be taken that support for future
+	 * versions of the GHCB protocol are configurable via KVM_SEV_INIT2 to
+	 * allow limiting the guests to a particular version to support things
+	 * like live migration.
+	 */
+	return __sev_guest_init(kvm, argp, &data, kvm->arch.vm_type, 2);
 }
 
 static int sev_bind_asid(struct kvm *kvm, unsigned int handle, int *error)
@@ -3906,6 +3921,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 {
 	struct vmcb_control_area *control = &svm->vmcb->control;
 	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
 	u64 ghcb_info;
 	int ret = 1;
 
@@ -3916,7 +3932,7 @@ static int sev_handle_vmgexit_msr_protocol(struct vcpu_svm *svm)
 
 	switch (ghcb_info) {
 	case GHCB_MSR_SEV_INFO_REQ:
-		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
+		set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(sev->ghcb_version,
 						    GHCB_VERSION_MIN,
 						    sev_enc_bit));
 		break;
@@ -4341,11 +4357,14 @@ void sev_init_vmcb(struct vcpu_svm *svm)
 
 void sev_es_vcpu_reset(struct vcpu_svm *svm)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
+	struct kvm_sev_info *sev = &to_kvm_svm(vcpu->kvm)->sev_info;
+
 	/*
 	 * Set the GHCB MSR value as per the GHCB specification when emulating
 	 * vCPU RESET for an SEV-ES guest.
 	 */
-	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(GHCB_VERSION_MAX,
+	set_ghcb_msr(svm, GHCB_MSR_SEV_INFO(sev->ghcb_version,
 					    GHCB_VERSION_MIN,
 					    sev_enc_bit));
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 28140bc8af27..229cb630b540 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -87,6 +87,7 @@ struct kvm_sev_info {
 	struct list_head regions_list;  /* List of registered regions */
 	u64 ap_jump_table;	/* SEV-ES AP Jump Table address */
 	u64 vmsa_features;
+	u64 ghcb_version;	/* Highest guest GHCB protocol version allowed */
 	struct kvm *enc_context_owner; /* Owner of copied encryption context */
 	struct list_head mirror_vms; /* List of VMs mirroring */
 	struct list_head mirror_entry; /* Use as a list entry of mirrors */

