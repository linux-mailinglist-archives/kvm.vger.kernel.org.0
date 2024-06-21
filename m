Return-Path: <kvm+bounces-20293-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6191F912B26
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 18:17:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D41E51F2974E
	for <lists+kvm@lfdr.de>; Fri, 21 Jun 2024 16:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 554A015FCFE;
	Fri, 21 Jun 2024 16:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="yyyZVVL7"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B28A10A39;
	Fri, 21 Jun 2024 16:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718986654; cv=fail; b=rqq5Y3RPg4YirLCwVJF06ezivtCH79WUoU/70eVtug50fmL1nQcf1xLNGx0YYdX7+jDiyuS1zCeZdqY50CouDdBgPMJy4FUekp1aoCJxVFDxXHfFr0wO9NurNeoAPCXWSjbnorGD1itYeLgRiVTjYs3ENDgIUQPF53dRNMCsB9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718986654; c=relaxed/simple;
	bh=hfGMAjyRU3recA5WoFfP9paDJGcLo+RI7ydcApH34bU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OzDg3uqlT2nN1bxLiKK0JWBH95GxvCi05mwD8l3Koz97vL1vn87I5otJ/DuVci67IyUR4IUsWeXPZ7kyH51q5OI66tCU2w+CEeQBZB5azq4X65TlP9hx+kupGzVKdLhNXp3OIZElXY5o/QYFM7kH+4BqEzFAYha8OcWOVz1G8lE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=yyyZVVL7; arc=fail smtp.client-ip=40.107.100.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYoiow/ep9H62d1zLJyg81wONt/4ljn0WgyqSLUSnXXzkIl2jqgUnjkcovgdeG/YP8Z0rgzcExzLkqelWm3vFpCi0vtpGelrFDqaYq+J3t+fDDjURPTYxWgr/JfuDHGA+HjbVGvtfO8cGwtijXr3NVT7O7u+gy4zRhqNBkvRfiBHMvXHLiwsOhpwBE3UaXvNg/dpROvDmBLYiACn1kDwSKASkXU+1jQt8Ex2dn5MMXLyTfcreijWKtmO7V1ULTS/O/0JTF9sRAogVgfKl/Hcn0ww/ZUhxCeJKoI8LLwl202ngyQqG3zpkY9D5fGKzoY0pXXH6bprsv+nMlPW0h1Qjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KJPedQgxHiyx4W5hKuJdCgq7p/PCIPpXP0gO1yHhR9g=;
 b=X0Tkb/dq7MNTlQxibDIAbsXvwU6geH1zjLVfRJ7JT7GfjUNotqRY/7LRAGaklV1bMjE/0DZDIH8vlSvwyo9aYX7vmTcqPZQtbkta7r3Y2hEETMpbEM7ELyl0X8wQ7U2h7mrvQn9w0fDFLfmw0SjzaovDhRz7pMb4+2Ues91WXnbiEnDHZedRB1gBMUrgs76ZetAQ9ydj1su5ezlDBaLXY3IihDkrChgNZHls58mhhHMC0d1Rc94tyNvvq807JGUxtrslfQ4TYRZloMKWcMZd23tG3MTUtntTjfVM9GUTsy8WO2TLs1PAPC78bfx1WYfx9uZO5AknUmxDzsEuuKf5aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=oracle.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KJPedQgxHiyx4W5hKuJdCgq7p/PCIPpXP0gO1yHhR9g=;
 b=yyyZVVL73FwNqfTqYWxomsvpZLL89ygCNGX+viO+vbbVW6wLaYaavcRjKo1WK/V+siHRGg1ei8oJVQv0TRgpbz7OldMiWhR/Zol+k1Kx4pcYeWO+5SS2TTzEnnXq2yUoEYXnrbde/yTeSBAAcT8L67lbyykCwuzNzm0GSd/40zg=
Received: from CY5P221CA0013.NAMP221.PROD.OUTLOOK.COM (2603:10b6:930:b::29) by
 CH0PR12MB8508.namprd12.prod.outlook.com (2603:10b6:610:18c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.19; Fri, 21 Jun
 2024 16:17:28 +0000
Received: from CY4PEPF0000FCC1.namprd03.prod.outlook.com
 (2603:10b6:930:b:cafe::63) by CY5P221CA0013.outlook.office365.com
 (2603:10b6:930:b::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7656.33 via Frontend
 Transport; Fri, 21 Jun 2024 16:17:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000FCC1.mail.protection.outlook.com (10.167.242.103) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7677.15 via Frontend Transport; Fri, 21 Jun 2024 16:17:28 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.39; Fri, 21 Jun
 2024 11:17:27 -0500
Date: Fri, 21 Jun 2024 11:17:11 -0500
From: Michael Roth <michael.roth@amd.com>
To: Liam Merwick <liam.merwick@oracle.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "jroedel@suse.de" <jroedel@suse.de>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "pgonda@google.com"
	<pgonda@google.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"bp@alien8.de" <bp@alien8.de>, "pankaj.gupta@amd.com" <pankaj.gupta@amd.com>,
	Brijesh Singh <brijesh.singh@amd.com>, Alexey Kardashevskiy <aik@amd.com>
Subject: Re: [PATCH v1 1/5] KVM: SEV: Provide support for SNP_GUEST_REQUEST
 NAE event
Message-ID: <20240621161711.fvx5kjugfdhl2r3p@amd.com>
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-2-michael.roth@amd.com>
 <8ac2b281-9aca-40ba-b094-165d18a08230@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8ac2b281-9aca-40ba-b094-165d18a08230@oracle.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000FCC1:EE_|CH0PR12MB8508:EE_
X-MS-Office365-Filtering-Correlation-Id: eac194d9-fae3-47e5-cd4c-08dc920da55e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230037|1800799021|7416011|376011|82310400023|36860700010;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?pqP80boCRG921ZSN6RT1Ia2FWBnEzTK46xCOzkg+T+LW1MLaQUescSdwnTXV?=
 =?us-ascii?Q?4fjJE6KZ9QpNBqg0LrPTim+SzEiCAafNJz4FwMll69+mDKGU6+bRWTDVaJ0g?=
 =?us-ascii?Q?o8BedKrzKrTWdTiC68XB0+Tq0uj0DLA6ue+iWp7sfQzG5I2QQdwPlmAAW85A?=
 =?us-ascii?Q?LtyrBlRlfoVNQgJIsiIt/31WavTl/XA7nWyoRajeTCe45+FEgojrj6ptuMim?=
 =?us-ascii?Q?UbdvTeXtw5MM8uiptb/uiwNYnVSpkVhXN8j8e5mKJT+PyAjCZc9tIGz3RW8A?=
 =?us-ascii?Q?0M02LvR9lwLK5moN9VIMRwSwGx9WKRbyAanuIyt148NmoXcRnn8ZSDHhlnq3?=
 =?us-ascii?Q?APdeV+x81zdsOWJWGXJ1hpZx3otaSbscmXzyg5oWZu079XFAwfgeRVlMtMZ/?=
 =?us-ascii?Q?bhhWDhyI3biMFXEJMCrKwTbHJlxjiYDGVHJq7dZI9210XwZUVarmVZf+0CgL?=
 =?us-ascii?Q?khLVG+gbVSxfKjcgAoXnBiXzvEw0SaGDg4LIA3Nj6g6XYdd2Q6VmNl9GV1cB?=
 =?us-ascii?Q?mPdXk77o9IGHaRuima76gX0Aj7Yy6EFRusmgBHjMqv/OWP8rq4c/xiIYPXZl?=
 =?us-ascii?Q?4Dz/5JRNAvSs3XjOUN4u1dI7MQI7xgZTwdKpKClLAGpnkOqG4mb3eIQrm0Ti?=
 =?us-ascii?Q?VSz3BPpFWIc+7A9M7wiuGrJGitCF8vv+E0sNMcTilmPxzFxVdhjDOIJoRt7R?=
 =?us-ascii?Q?Z+KH+fpVnOJCoTXK00cRsbyF1CK2eMRBi06fcmzeeLJgQ7aLwWVOB+7yESjb?=
 =?us-ascii?Q?wdVwE8CT1vL+dJ2TKcppvJ6YRCrgyijD5w4RWCl16kV8NitqPgtYLHweUMPG?=
 =?us-ascii?Q?1eueZgooGVrgxs2krktTlSk434IYqHohcxFniqNmWNj1vDBPvg0UTGFnjQdz?=
 =?us-ascii?Q?j0Rhu6y1X5+WUZWHVeyRbpfJC6ID7fau2mLodPjrJPBDIBxqyMQIBSA5cUtd?=
 =?us-ascii?Q?8ogdUOLAHc/055Qxrd8HgoiTmVc2fXM+tXVPDVcGDOsGO+Ex3bA48NjEcz3S?=
 =?us-ascii?Q?TM3ZJti5yLAB/xgp6oIBLAj5n7VSKQkp3DCx8lOORIDNqrW55e+sb9aBNoXd?=
 =?us-ascii?Q?KIXNeNrsZrb7muPJ78kL51mLf6CkTuy6uI6DJSqWXfiAYJhioEfsFV+N10/9?=
 =?us-ascii?Q?NYcM4UDNEnu+hD94E14H59Pu2noxS98q1VuMustwXcjwrqdTY6nva6oVY6GI?=
 =?us-ascii?Q?+S8OS6yVzAB5pUBNFzUj3PWgWvDen2avzOGeL5gIMKfyJBRhQtn7t/wa01Co?=
 =?us-ascii?Q?OjGsP8MxCtgpRhA//D4K9keajlIKy/B5cjyLt/BmXswAFhexbmva70Tuai19?=
 =?us-ascii?Q?R+Oh3gMa4VVu5f/4/FuylZU7mgSBCbIBfuttMsGI0j/qG0kN5DURxHUegZoY?=
 =?us-ascii?Q?fXZ0iKXw+BdfPy1kRLerIsqrAmJV+yvrHiCgv0fJZFH3tG3LfQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230037)(1800799021)(7416011)(376011)(82310400023)(36860700010);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2024 16:17:28.5201
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: eac194d9-fae3-47e5-cd4c-08dc920da55e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000FCC1.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB8508

On Fri, Jun 21, 2024 at 03:52:35PM +0000, Liam Merwick wrote:
> On 21/06/2024 14:40, Michael Roth wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > Version 2 of GHCB specification added support for the SNP Guest Request
> > Message NAE event. The event allows for an SEV-SNP guest to make
> > requests to the SEV-SNP firmware through hypervisor using the
> > SNP_GUEST_REQUEST API defined in the SEV-SNP firmware specification.
> > 
> > This is used by guests primarily to request attestation reports from
> > firmware. There are other request types are available as well, but the
> > specifics of what guest requests are being made are opaque to the
> > hypervisor, which only serves as a proxy for the guest requests and
> > firmware responses.
> > 
> > Implement handling for these events.
> > 
> > Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
> > Co-developed-by: Alexey Kardashevskiy <aik@amd.com>
> > Signed-off-by: Alexey Kardashevskiy <aik@amd.com>
> > Co-developed-by: Ashish Kalra <ashish.kalra@amd.com>
> > Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> > Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> > [mdr: ensure FW command failures are indicated to guest, drop extended
> >   request handling to be re-written as separate patch, massage commit]
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > Message-ID: <20240501085210.2213060-19-michael.roth@amd.com>
> > Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> > ---
> >   arch/x86/kvm/svm/sev.c         | 69 ++++++++++++++++++++++++++++++++++
> >   include/uapi/linux/sev-guest.h |  9 +++++
> >   2 files changed, 78 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index df8818759698..7338b987cadd 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -19,6 +19,7 @@
> >   #include <linux/misc_cgroup.h>
> >   #include <linux/processor.h>
> >   #include <linux/trace_events.h>
> > +#include <uapi/linux/sev-guest.h>
> >   
> >   #include <asm/pkru.h>
> >   #include <asm/trapnr.h>
> > @@ -3321,6 +3322,10 @@ static int sev_es_validate_vmgexit(struct vcpu_svm *svm)
> >   		if (!sev_snp_guest(vcpu->kvm) || !kvm_ghcb_sw_scratch_is_valid(svm))
> >   			goto vmgexit_err;
> >   		break;
> > +	case SVM_VMGEXIT_GUEST_REQUEST:
> > +		if (!sev_snp_guest(vcpu->kvm))
> > +			goto vmgexit_err;
> > +		break;
> >   	default:
> >   		reason = GHCB_ERR_INVALID_EVENT;
> >   		goto vmgexit_err;
> > @@ -3939,6 +3944,67 @@ static int sev_snp_ap_creation(struct vcpu_svm *svm)
> >   	return ret;
> >   }
> >   
> > +static int snp_handle_guest_req(struct vcpu_svm *svm, gpa_t req_gpa, gpa_t resp_gpa)
> > +{
> > +	struct sev_data_snp_guest_request data = {0};
> > +	struct kvm *kvm = svm->vcpu.kvm;
> > +	kvm_pfn_t req_pfn, resp_pfn;
> > +	sev_ret_code fw_err = 0;
> > +	int ret;
> > +
> > +	if (!sev_snp_guest(kvm) || !PAGE_ALIGNED(req_gpa) || !PAGE_ALIGNED(resp_gpa))
> > +		return -EINVAL;
> > +
> > +	req_pfn = gfn_to_pfn(kvm, gpa_to_gfn(req_gpa));
> > +	if (is_error_noslot_pfn(req_pfn))
> > +		return -EINVAL;
> > +
> > +	resp_pfn = gfn_to_pfn(kvm, gpa_to_gfn(resp_gpa));
> > +	if (is_error_noslot_pfn(resp_pfn)) {
> > +		ret = EINVAL;
> > +		goto release_req;
> > +	}
> > +
> > +	if (rmp_make_private(resp_pfn, 0, PG_LEVEL_4K, 0, true)) {
> > +		ret = -EINVAL;
> > +		kvm_release_pfn_clean(resp_pfn);
> > +		goto release_req;
> > +	}
> > +
> > +	data.gctx_paddr = __psp_pa(to_kvm_sev_info(kvm)->snp_context);
> > +	data.req_paddr = __sme_set(req_pfn << PAGE_SHIFT);
> > +	data.res_paddr = __sme_set(resp_pfn << PAGE_SHIFT);
> > +
> > +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_GUEST_REQUEST, &data, &fw_err);
> > +	if (ret)
> > +		return ret;
> 
> 
> Should this be goto release_req; ?
> Does resp_pfn need to be dealt with as well?

Argh... yes. I folded some helper functions into here and missed updating
some of the return sites. I'll respond to this patch with a revised version.
Sorry for the noise.

-Mike

