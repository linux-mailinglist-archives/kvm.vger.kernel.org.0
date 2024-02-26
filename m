Return-Path: <kvm+bounces-9946-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A9C5867D96
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 18:10:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82162B32867
	for <lists+kvm@lfdr.de>; Mon, 26 Feb 2024 17:08:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C14F130AC8;
	Mon, 26 Feb 2024 16:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="asMLSm+y"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2076.outbound.protection.outlook.com [40.107.101.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D4012C7E1;
	Mon, 26 Feb 2024 16:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.101.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708966587; cv=fail; b=lsLoGCwMV4EyROThs0r+OvCQ/xFY7A6NcIj5tFI5jT2U90N//QmDHBmUP0wt3utgPoeTEkTTMg70eF08J5GUT2QtFol2xMRTrqY8nqk49TXWxsv965d3S3nwa6Qa7yL+UrLHCl6jCC0uZ+kC0fbfPa1jf42LC9u9BO+XOaiSUBg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708966587; c=relaxed/simple;
	bh=agP427VU0KJFWslSK2zjlZ8nN7GqdscWOwDmM9mW+HM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GI7TQqMMI2F3lj+vMQQBMOxmVrO0C+gSqpoij6eV5mYQNnkEiOMu9t5SGqwhS+V1QkwLTicynmTQL9HqTbN9AIKqaOsShsAgR0p0Qp5vQyQAj8QNNcZl06lHK/o4ZHGvWnGotRJAC9IJBCuAM1OO8ZsjvWeE4Vs+oaz1SJr0B0g=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=asMLSm+y; arc=fail smtp.client-ip=40.107.101.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFSYfiaV6pN9a9JaZi3U44ISLmnZ1BfDN95Jg1ZD/+q5BjUc5B0gtrfh4YMWtIahGKmPe5NQX4Djme6mYUcwRPO8Rg5Hab3yFuPcZ45Kk9ASQCrNPoEQekchegxWUADTOGM4tpy1gBPW/jXgT854mQ5CsaQ7qrZ7eoHl9wub+U2T504YxNu7/8bo9kgDjp8sSzle4n9NDih5OLIBkTMuuORA6JA39W57MAHiTOOtaFYVBda1vMBwbs4YZF/dvHzOVfN1Ix3mP4yhE1jPqs5KRwlFjQ+8veV0CsCIjviTIYaH7v5upURWPMtaRN/YXOxFZUlkQ0Vb1aqhFh4Ew7A1og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oz9+c0iG/QRKw+wZUW0Ufo3fRayrTPQ1dwd5sr5Yeuk=;
 b=RYAhxCz4svLkcUcVxF06jSW9OmWsB5OLhsGXy+o+GOFCkKSACqhBtxvUenP/ZnSA7fg8s8t1AF0SzcjPq9znOd9zWzn65Qx+MlF1cItJn3+uzSu3OXHa57/X2eKKcSwpZZzLhs8IsZBxmRImpy1Q2BZWVieWUq376KPJjJb2PGGqC7npFWdorCqi+QqURLO3yujrvSHRQ4ieW6Uq/6+L1ULg6cVvnRy9np4VN1Mjr3xuTXVJFj+woCVuTmTy47tgnmTn8nAJILk5QbvIRQoCHU95njt9QrxYo8+efMh+LU6DSCXwYfMdGavo+sUReHuAKxKQUpa97FgWi/lo/XvoCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oz9+c0iG/QRKw+wZUW0Ufo3fRayrTPQ1dwd5sr5Yeuk=;
 b=asMLSm+yf1w/pGfjCtDCa/z1ZxQD94VdJKw5srt0ETLqQKinsuZZegE911682iRR44/ZsSS679zYIJAMCEgVucjUiZxw2gmkuIeenvNOcxdjCOsN/Q3i0XZs1SnZA6s4xH7Qm1YJ5K/pb2CRwsf2WfC2txY1RvxURtMvK7+uHKQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS7PR12MB6008.namprd12.prod.outlook.com (2603:10b6:8:7f::15) by
 DM4PR12MB8572.namprd12.prod.outlook.com (2603:10b6:8:17d::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7316.34; Mon, 26 Feb 2024 16:56:22 +0000
Received: from DS7PR12MB6008.namprd12.prod.outlook.com
 ([fe80::3f8e:6ab2:87a6:c681]) by DS7PR12MB6008.namprd12.prod.outlook.com
 ([fe80::3f8e:6ab2:87a6:c681%5]) with mapi id 15.20.7316.034; Mon, 26 Feb 2024
 16:56:22 +0000
Date: Mon, 26 Feb 2024 10:56:13 -0600
From: John Allen <john.allen@amd.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com,
	weijiang.yang@intel.com, rick.p.edgecombe@intel.com,
	seanjc@google.com, x86@kernel.org, thomas.lendacky@amd.com,
	bp@alien8.de
Subject: Re: [PATCH 5/9] KVM: SVM: Save shadow stack host state on VMRUN
Message-ID: <ZdzCrTUWicugQXCj@AUS-L1-JOHALLEN.amd.com>
References: <20231010200220.897953-1-john.allen@amd.com>
 <20231010200220.897953-6-john.allen@amd.com>
 <cc44a4a7e7a4cabacad76c875e50cc5ff19c6e23.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc44a4a7e7a4cabacad76c875e50cc5ff19c6e23.camel@redhat.com>
X-ClientProxiedBy: PH8PR02CA0033.namprd02.prod.outlook.com
 (2603:10b6:510:2da::6) To DS7PR12MB6008.namprd12.prod.outlook.com
 (2603:10b6:8:7f::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6008:EE_|DM4PR12MB8572:EE_
X-MS-Office365-Filtering-Correlation-Id: 8593f820-d11b-4f1b-493a-08dc36ebdc14
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Dbiv0vTfdcO/xMHnoAktl1VUhk6jvcl7LOU7GTlcAlTgMvNslkiaRP+bzxO+z/NwsgDQo2fH5em+1yglJCQcbievCw8hAAHQtbFKWSJCEk1Z8hUqXWBiuMw6+yZNZm5ceY79AToTY9xSj84wCn8pDXyJa04wfUVxITnX/MsABavpnjsbsAFY0VmUYcaaRKdcaMWQ5dbFiZJVZS7l9W53hDEUKZd55rUHOcAutzWnOpPUm9AsvcO4ENOFXm+gvYRwzpEQ2lvY6P6Eeu5NzV6Raxr063aeD9lSL4ucCOzWoj0oydhCkZAIN4migWw8RNrOkviNTDkab7dnkfB3W3fsjz6CDvEx0dMara+5JQDYvZMvkV8t9a9TcSF2Qf26DkfDOSgx/tDcqweigBdkNOh5atqZDKkmgYqUo5TrGTAqEs+iSZes8nsV0RMkUD/fLw80HDap2r11Ke1vDsfqGY26FPJ0s0PfSX+HztnWPyc+6JkqA6EVttQ+QiAYm0sSPhFqIc3r1ykk055rLAfG8eX3rCYTtwb9emwdSZROv4vgHJwpJSP0dgN6wv+KPmqOFdFHnzg3HbIL6+XI4PXMLQjiBcLjKmLNZVzbJTy8+70ZsJ870ZwAaGrimQeouwIVdMiB
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6008.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?irxOe6KHHVJv6nanYJt4c8S4G0dKiu1Mk3TnRJ6Z+2aKBvuMqwiUT+apw10f?=
 =?us-ascii?Q?XlKzym3NqFukV23OZexIcsdJ2L83DT5UEs3XkXf/yn5v3DNRzalDb0Uijzzv?=
 =?us-ascii?Q?IFYO6Xq00V+tMEIXwOxqE/RyWhr/pxob+P6qvOey8iTQ5MfhGKhmEqhhuUgb?=
 =?us-ascii?Q?SI91btWWVP/R9NH9VC5iEYCrZY/Vnu1BNMT5j8l+DT4qvjt5rECHL5u/WohJ?=
 =?us-ascii?Q?g0tU7K2AeTBZEVOwq36/TEhm9UzO8CBpVfMLMlvg7Almg8d08wRYnG/jQi2N?=
 =?us-ascii?Q?53sLStC5CyKLKAu/ijUKNo7axVyOLsA1C98jWreVo6pb7MlMhJ+zpYYz9SRe?=
 =?us-ascii?Q?p98SMbMvMWeu9JfNoxMLVqhY75yjRKbR9YN3QdwHD6Rr/NwxrAQgJRKR6+td?=
 =?us-ascii?Q?PuFq1F/Ko68FQDdDkWozy3sATXfDYXJVUlpmBz3OGU1Z6oTPseNoz0evZTj6?=
 =?us-ascii?Q?P4TgRQfGpS1TBRZ33ElL8ty7dNVQwxJXYtnMDvFnLNUmew/TXRlbp8nUsGfI?=
 =?us-ascii?Q?+q1Y5Ryu8oY4C2KoQCFMl8a+FpuI3IVM6AAsJqR4qB/SGsVD5X/1sRmhgQi5?=
 =?us-ascii?Q?YiMwU5H7athlwaSRU5DR3WUp4UJ7pOmLS/STvik/fwPlfGHge0FSXn1jbKmc?=
 =?us-ascii?Q?K/28uLaj7u4Uyj7kaxR2a2n64QHaUpieB3VFyi10/TBowZY02qqmM987H1++?=
 =?us-ascii?Q?8oV/6yVHDdfFl+98rvLrFMIf2UmJnFyaH1lcvqYN4VM8XKzdIQQM1nNinDxG?=
 =?us-ascii?Q?XWJlm7x6o7B8QM7fTmvu6YUOtucJW/5wfan/Rymr5J2ZPlFyeApD5lCRR5TT?=
 =?us-ascii?Q?JiJ9PU/JkEGPQHVyemZ8RAuzJcuiqL0FTnUZA2fVX6a69Dqq2UAJh+LTmyL1?=
 =?us-ascii?Q?3PaIvel4PKQWyXRIDv0o8chIDON5Vfk5IgwjqxrBpyg55MG2L7SuGYJnU3vR?=
 =?us-ascii?Q?JeZy4Kxr0ZrD6U1/KfwGYzURNWIPunr/pwJlLGHblfaAFwSlSsKfZb6bemQ9?=
 =?us-ascii?Q?RfAkZW2bhQmPbBb5aHqDX0gmbi/YpY1d6RmrsnUeIZvpULQO2xdw54MC4u40?=
 =?us-ascii?Q?DYc9di7czg7qQKvUU+m4bzuOXysuAXB4sh0hyfUTMh7Qm6Rs/UyrutWCR8gO?=
 =?us-ascii?Q?EYyd1gSFZIu5+pDrxN/ugb0BbRsHCzCIS6Q2UP/j1ik/nkKu2Am+EN/M4QFW?=
 =?us-ascii?Q?TtRzXWq6eE8UqILBlQtmRo/caB17v6dO9vWIAb8gQzW7bhGRmT4+U9SHv4R3?=
 =?us-ascii?Q?WDC6IOLvuTrD8s0wAQdk+GfMqByRO2cLIdou0I9bYv4QMmX913Ef5N7ick4G?=
 =?us-ascii?Q?4Egj79rkabNJHDniiMb+xqzU43YxWaE1WWJUlJEC8a4Pxtcc4DNwXHvuqp1m?=
 =?us-ascii?Q?OADHBbMv2b4P1U9eGgi7Jz2V+mw6mtBC4bx6LMyMV14pbutQNvbf2hQ05M34?=
 =?us-ascii?Q?eAyD3iulelcsxQpb7XPWwYbb03BGPmzgu8eDYyQQMJuvuAHf+wklbuo2abr+?=
 =?us-ascii?Q?TjsD7kRkX0XGxEb3tBpEi03AgkthhSTHBbsWgB/wa0TrKUxl104WlH+T+OTL?=
 =?us-ascii?Q?Wa+xobuhqsJvn2uMYGiD5JsVg7+qskeVGEUIOqP0?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8593f820-d11b-4f1b-493a-08dc36ebdc14
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6008.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2024 16:56:22.0315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Fi2KvkSe/sfRGBVgPioEY6uMAyCq1SCOXOTKv5AZmelcLmYXVYSm/xDOGS0osdwrYBUl3I/9xATVsvyXeW6vTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB8572

On Thu, Nov 02, 2023 at 08:07:20PM +0200, Maxim Levitsky wrote:
> On Tue, 2023-10-10 at 20:02 +0000, John Allen wrote:
> > When running as an SEV-ES guest, the PL0_SSP, PL1_SSP, PL2_SSP, PL3_SSP,
> > and U_CET fields in the VMCB save area are type B, meaning the host
> > state is automatically loaded on a VMEXIT, but is not saved on a VMRUN.
> > The other shadow stack MSRs, S_CET, SSP, and ISST_ADDR are type A,
> > meaning they are loaded on VMEXIT and saved on VMRUN. PL0_SSP, PL1_SSP,
> > and PL2_SSP are currently unused. Manually save the other type B host
> > MSR values before VMRUN.
> > 
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> >  arch/x86/kvm/svm/sev.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index b9a0a939d59f..bb4b18baa6f7 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -3098,6 +3098,15 @@ void sev_es_prepare_switch_to_guest(struct sev_es_save_area *hostsa)
> >  		hostsa->dr2_addr_mask = amd_get_dr_addr_mask(2);
> >  		hostsa->dr3_addr_mask = amd_get_dr_addr_mask(3);
> >  	}
> > +
> > +	if (boot_cpu_has(X86_FEATURE_SHSTK)) {
> > +		/*
> > +		 * MSR_IA32_U_CET and MSR_IA32_PL3_SSP are restored on VMEXIT,
> > +		 * save the current host values.
> > +		 */
> > +		rdmsrl(MSR_IA32_U_CET, hostsa->u_cet);
> > +		rdmsrl(MSR_IA32_PL3_SSP, hostsa->pl3_ssp);
> > +	}
> >  }
> 
> 
> Do we actually need this patch?
> 
> Host FPU state is not encrypted, and as far as I understood from the common CET patch series,
> that on return to userspace these msrs will be restored.

Hi Maxim,

I think you're right on this. My next version omits the patch and
testing seems to confirm that it's not needed.

> 
> Best regards,
> 	Maxim Levitsky
> 
> 
> PS: AMD's APM is silent on how 'S_CET, SSP, and ISST_ADDR' are saved/restored for non encrypted guests.
> Are they also type A?
> 
> Can the VMSA table be trusted in general to provide the same swap type as for the non encrypted guests?

From what I gather, for a non-SEV-ES guest using the save area that is part
of the VMCB as opposed to the separate VMCB/VMSA for SEV-ES and SEV-SNP,
anything listed in that save area will effectively be swap type A. Does that
answer your question?

Thanks,
John

> 
> 
> >  
> >  void sev_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)
> 
> 

