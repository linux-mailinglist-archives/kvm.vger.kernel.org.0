Return-Path: <kvm+bounces-22692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E8C68942043
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 21:04:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 77C4C1F23FA9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 19:04:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3BF0F18C92D;
	Tue, 30 Jul 2024 19:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="0Wr7k3yf"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2048.outbound.protection.outlook.com [40.107.220.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023311AA3FA;
	Tue, 30 Jul 2024 19:04:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722366257; cv=fail; b=K0A9Z0jMENMG0J5UEwbbc2w4RshWDC445URbkCKqJuKJsRyL7Igxm21gynDCM90Me6ayNNjPbd8ADUMv0Ut2xMqui0wqDyaA/QKKE9y64hqnlLQfRdbCRNzr09TJTUqu2XnEvSZY5Y0jbhty9IcklOO3ws/xkBswGhrfJPmkVIQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722366257; c=relaxed/simple;
	bh=VNs2yPsZPh2bN66DEMn3N8RQDn6D5fQj32C2HCC2ueM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=QyF+vB76rx7HP9eW5lOfYlqKv1/A4InS1P4VzE1Lg2Ye4TLDxy8vxZM5iZZCW6iajUSSYgn7WFqVJ1xh4fwEWFY3GQXWfYUpTl1PFAr0Imwv415M+pzYU3L9C4a3Y1jWg6WRFTPmUMaq4Vd0XF/FDQT802nHtWLTNDejysg/OpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=0Wr7k3yf; arc=fail smtp.client-ip=40.107.220.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=apSFNu8BFcKF0UfaJMgMlQdaSQ7IoSlAPhPyzNl7xwViU+FAoLHLtBaOdP82ZaIjb76ss16dueQtmLaRv5N5aiGPYdFXyGl68eE3RQUYJgtG+HVFjAzrtu/pVDEdGho097UIaT1Q+5Hd79+3PlU9MnkxWVGxd4qXwDzbeD2chu3pm2F/G5PjcVCWEtXIfa6MuOApKDogOjf22SEtopGOdpfG7Zhrlg8MAWkqzufS2iobal9JQ0aD3M3jHYMyWvIBV/SRwfmXWT1A76wl579ScDmbhFFR6D2jl0+35cgB5RLXr0sZBrhnbi1DP+1hHWPTam1666EB2oJA+QBYZa3mgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lQkSkIpJCPwAhh11rCCh1W8+aPr/aGC3P+zLx9oWPjY=;
 b=THhrvoCRaIzEVD+k24bvbG7kgDAet7khuw4Qat5pg2lYQngtxGdoBf9obA9eJFtufpkYnpm7hOee4gLWPoBDKKz/JlrIxbIMG4EIE/NkfcrnWBvMQ1w8jDsAaZLFqEhlaU9ARgK1SO8trAQalkOfeD9PQBJPa46uR6sGoSq4V0OCd0h2j7j2ojRc14AfnGBGBCY5wMbAN6uubJGBvsg7vwAK4RyJIcNzcJQn4QhgcYQCZDp6GH9hwAjH3wMO4JwVE4WmYa++tZIIilkDY07Z/wNS7tjToALrWBXMuNgaXiMouGEw+vcJWsf8rBOQ0+osijwUNU4C1mhrc3V/DL2uQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lQkSkIpJCPwAhh11rCCh1W8+aPr/aGC3P+zLx9oWPjY=;
 b=0Wr7k3yf4ibxctBPa4JXN2EJMQwHZgg9RoS8P/MhpQIszMvvd1zyd/gEYSzxOVb4hPgWXIN1MgSlXl7TC6gkIfpOTh6cUO8nf3rJcoEqAQY5ZPSvDO2BcJLWD8CGTaS5GfI4mdVdJDzHBbwPjb1yhAZniVpEaqoedTqrCmJdwaE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by LV8PR12MB9207.namprd12.prod.outlook.com (2603:10b6:408:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.27; Tue, 30 Jul
 2024 19:04:09 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::7298:510:d37d:fa92%5]) with mapi id 15.20.7807.026; Tue, 30 Jul 2024
 19:04:09 +0000
Date: Tue, 30 Jul 2024 14:04:02 -0500
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com,
	bp@alien8.de, mlevitsk@redhat.com, linux-kernel@vger.kernel.org,
	x86@kernel.org, yazen.ghannam@amd.com
Subject: Re: [PATCH] KVM: x86: Advertise SUCCOR and OVERFLOW_RECOV cpuid bits
Message-ID: <Zqk5IqoQBnQbbuCK@AUS-L1-JOHALLEN.amd.com>
References: <20240730174751.15824-1-john.allen@amd.com>
 <ZqkqWTCa6GdeVykw@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZqkqWTCa6GdeVykw@google.com>
X-ClientProxiedBy: SA0PR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:806:d2::30) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|LV8PR12MB9207:EE_
X-MS-Office365-Filtering-Correlation-Id: 559d1faa-e571-431c-ba0f-08dcb0ca6481
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t8GlLkjdqjnRZzo2XaTiSA2d9dR4G8qjlymBS8N6FHTRwzBYik8G3aQevkoR?=
 =?us-ascii?Q?A/kmVnGeejPovsfYwxzGeAdlgXOb1o0iFgeNKOrddlbM9xnAwCmUMymx3ZRp?=
 =?us-ascii?Q?pxbiPeqscN/P4MCDUt4/vUNpC+9sD4W3gQ3UDjuzfpkGyKN5331n1yEjfOnZ?=
 =?us-ascii?Q?u4lZoZvasJvFKQF3eBVW+kNuX81Hhb99rOca19S2PMghJKxULV8KJOC6ytIQ?=
 =?us-ascii?Q?tk2+KvISyhn9N2Q6UbDCYip87S3IhCy1ynaIU3qxVZfkqNgnt9RwFin7LHfI?=
 =?us-ascii?Q?nmEd69zRQSpMywOihK78qBub8IIb9Jek0egNcLZGlAdxNPSnNakUSRKwWLSN?=
 =?us-ascii?Q?Ub2Z9ckSeVIsXv7qg3Q2D95BiU6ShoyFFaHyMr3j91IaZvJCzL4CwFvrpUGp?=
 =?us-ascii?Q?CbVtPoZI4cO7Kadr5n9Y/uCDU/iVPcfeWzYHgR9txVx7153XbSuhbL8LbM47?=
 =?us-ascii?Q?6JTPGOn9ks7C+Ly92z/O3/BYASqPF60JdSZqZPTioCRwxX4gwV+Js9h59Ebv?=
 =?us-ascii?Q?2ZMU+RYeKubLewl+JQ6TcysMt02R3IqiCoAAZSOI+rxgA0n3zMvTVQyoYcgm?=
 =?us-ascii?Q?Ol3qse7aK+35P9RE0nepImdjSF90ygCnT+PaXYSHV0yRBDEG8JAEM7Ja5Ulm?=
 =?us-ascii?Q?QUK2TydixB8DKZyXwgZp5Dx5Vy4On5bRtssxxK6tgEM3QmexSIwwA/eNOXub?=
 =?us-ascii?Q?QLBcGTwKCXVEbW3U40ar9y+yx/d1CUJTyZC41c40lk+3biXAHDw1ktUvbDtP?=
 =?us-ascii?Q?bCXCSfBu+XF4E1V6vw3QXGUE/IIAEkBTgh4y8lspXCPKI1mvrsJdJClEo6Zz?=
 =?us-ascii?Q?T5rABkHy2ITHVETWF5wd7eThp0pr59zs0bgegjaWNMsx5wsBRfvoIMxRKahj?=
 =?us-ascii?Q?XDpodidSRb0UkU+uPoTad4Q2NZccxwenHoPETtnlyQkIz894Q4wYK81nTzpf?=
 =?us-ascii?Q?f2V6+z+ILCyx/gd8FUNO5YrG8qk4oXU357XYjDwZXZXXTlDPbJYxOqddN8sk?=
 =?us-ascii?Q?K+2TF5wd06OJ27ZlxcHxMz9Mx9IT+lfx1WGOhYVZ9/nqB9RJ9a1AgWnNJW6H?=
 =?us-ascii?Q?Rjc0INftH3ReFQkMZ87oBGC6GpznIhUyI0luRdhFnNKucjTQ8rZfLsi7H3Du?=
 =?us-ascii?Q?FlqCwbL/q+2t7I10Mqg0O6qZ5io1oQQGpDuTReSILV93WEY64FuGdOKwbpvD?=
 =?us-ascii?Q?COh79m7LLGF+dUiksNWuTPpZebQcYt3cHdglhiB5cUsezPFiKY+fpM39l5ZP?=
 =?us-ascii?Q?GxYvonaGpDhMHgfzfWH0UcX66Xejin0RPx/EnZ4OqgfW2xVhxjc6eb+LpZRf?=
 =?us-ascii?Q?LrQ=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mnfFsZoV9NvH5jZBoLDUd31uS/4B/HtfG18uJFkegR4rpfdJdn/kxEUlFA+G?=
 =?us-ascii?Q?ci7fNF7+u9NzptIS+TsztCRjxTW54qvTGkw0wFKeB1mxdE/w0hEvKD9SlMkj?=
 =?us-ascii?Q?MXwtXQhsK1wZ9z12icjU2BSfhDcSi7oEu00oLqCjdUFWjYeAcobyMGqCf486?=
 =?us-ascii?Q?Z+6JJPI8zKqV+H+n9fANXUyKdn0DNxYuMrxn+KHFM5JF19n7g0SaDv4UUikL?=
 =?us-ascii?Q?vh1JLSsizFb8RNYskHkiZ5VAcn2PwUShW5xsVB+ZEYKQIVbQbuB1isOdNI/Y?=
 =?us-ascii?Q?TnwAuCGOlZ2JQP2fqaU9r3hdwFH7CQ+tGTEJFISytFOyqakNmb40WeN6chtH?=
 =?us-ascii?Q?HpNN/Ezujfd5AT/eVm0uD1q6ZWrN3+Ui1dQI1k/KJReAz0UOUc/7Ykfz+qPG?=
 =?us-ascii?Q?j1FYnWU5wz2zeNbbSXLY5reC/kzIA15OmCxJo/zpkSWmCJBa2niOQg/L35uI?=
 =?us-ascii?Q?5w86GxQM5P7iVOu5yD7rX1Pc82y8gInMS71P1pNLpGXl7PM/SOh+I2LiJPOY?=
 =?us-ascii?Q?F9mOkaR5GcAVSGc7VLvFxOwomWHaCaxzDBSDssVc5b2Jyt9ugP49UJlDrlx5?=
 =?us-ascii?Q?qVPOKoF7UNX1QDMGM0SpA1yS76kAtzhvz45EG4s/QtHeFCEIE3C7jI3DUZ4E?=
 =?us-ascii?Q?+b2QrP3k/i1QS1tl/U2WEZ0Nqb+uWuh5IGjQAXP+rRG7ixND05cvQ2o5O24e?=
 =?us-ascii?Q?FG9FyPXjyAUS1RzxCcBtI0N3bblp3gTSA7cDdgPM9yc3ZGqlXLnG3LXCvMzJ?=
 =?us-ascii?Q?eTz5Gxo0W9xmyDyTqxWaLStdQd61BSlsjR+2NzvLguGSrT3C9LUrYftSUQzi?=
 =?us-ascii?Q?P+Pdy8gEt9i8E3zWZHYNASxu7PxCiDJFS48GP7I5G2/lkaD+cQqaKtQYYPCO?=
 =?us-ascii?Q?be8miTy5iTYDb/8ZgEBCfNj0Q35/8cNIIvt8ESOr9J8lbzvPVOE8dCWWQZCk?=
 =?us-ascii?Q?cQ8PgNSyrdeOXqDr+e/wNxr6yOlp8VZjJBdD24duHhLcUIHWI63jfzIctI3K?=
 =?us-ascii?Q?+C/uiqBNS/ZMocxoW2rX+aAXkqcnRoC3MDhmjxAii/bFBHAy4fh3n/myboXu?=
 =?us-ascii?Q?Vj5YVRI9rQMvvEXtZY5sUVLHUccli6m+0YiccpA0sLZtTKON7hvJ6n5fkzwV?=
 =?us-ascii?Q?OmeVWMxeWyfQkT6nV4K/Hk23o7ZT3SMvpOSxpsunJ6uwA0vJmN15CrJMZ9M7?=
 =?us-ascii?Q?RCDkVqrqzdXbME4pwjG5gnfKs37Nw5gpg/DrPoF9LlM0vCP5lfC9yubv5bQh?=
 =?us-ascii?Q?CTI4SCb8MJ6UWV01LUkWJ7rCNKRtv2Woac/NWbDzi59lFja3ZZ8juBX7Olm3?=
 =?us-ascii?Q?OTKs81Honq8FjsnSCXmtJoWmSfZ3fbmnlAqqafz5Ba/R1EeLsa98A55jfQ4f?=
 =?us-ascii?Q?iXflxkndiA4UzPrnyJHtvZaRB2LL5Vi3Vdi/17zrl50VMT3lborUu/VykyUG?=
 =?us-ascii?Q?ILr9Hbgil1pl9aATbcWLWUiy2QPlKRqsLDU2VoUXPBcwtYNFWzeund6nH1O6?=
 =?us-ascii?Q?3Zh0rfpP0x5plvg5kbIqY53nkA540UbdDTj1JqdjWr3srYbWU3C/Z0Rkpx7V?=
 =?us-ascii?Q?S4K6+Uef4qIvwYAhuTefcm65kstWrK68FasCho+x?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 559d1faa-e571-431c-ba0f-08dcb0ca6481
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jul 2024 19:04:09.7059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: asPPG7dEp2YbCojeT47ityOlYbJ36I3EKpkMqC6C5+qYdm+AbUsh5JdiQ6lZ/r4HWoqadzSOpPtvTqmwkkSe1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR12MB9207

On Tue, Jul 30, 2024 at 11:00:57AM -0700, Sean Christopherson wrote:
> On Tue, Jul 30, 2024, John Allen wrote:
> > Handling deferred, uncorrected MCEs on AMD guests is now possible with
> > additional support in qemu. Ensure that the SUCCOR and OVERFLOW_RECOV
> > bits are advertised to the guest in KVM.
> > 
> > Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> >  arch/x86/kvm/cpuid.c   | 2 +-
> >  arch/x86/kvm/svm/svm.c | 7 +++++++
> >  2 files changed, 8 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > index 2617be544480..4745098416c3 100644
> > --- a/arch/x86/kvm/cpuid.c
> > +++ b/arch/x86/kvm/cpuid.c
> > @@ -1241,7 +1241,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
> >  
> >  		/* mask against host */
> >  		entry->edx &= boot_cpu_data.x86_power;
> > -		entry->eax = entry->ebx = entry->ecx = 0;
> > +		entry->eax = entry->ecx = 0;
> 
> Needs an override to prevent reporting all of EBX to userspace.
> 
> 		cpuid_entry_override(entry, CPUID_8000_0007_EBX);

Right, I see what you mean. We just want to expose these specific bits
and not all of EBX. I think with the patch as it is along with the
change you suggest below, this should resolve this as the above case
already has the cpuid_entry_override just above where it cuts off. Or is
there another place we need it?

Thanks,
John

> 
> >  		break;
> >  	case 0x80000008: {
> >  		/*
> > diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> > index c115d26844f7..a6820b0915db 100644
> > --- a/arch/x86/kvm/svm/svm.c
> > +++ b/arch/x86/kvm/svm/svm.c
> > @@ -5199,6 +5199,13 @@ static __init void svm_set_cpu_caps(void)
> >  		kvm_cpu_cap_set(X86_FEATURE_SVME_ADDR_CHK);
> >  	}
> >  
> > +	/* CPUID 0x80000007 */
> > +	if (boot_cpu_has(X86_FEATURE_SUCCOR))
> > +		kvm_cpu_cap_set(X86_FEATURE_SUCCOR);
> > +
> > +	if (boot_cpu_has(X86_FEATURE_OVERFLOW_RECOV))
> > +		kvm_cpu_cap_set(X86_FEATURE_OVERFLOW_RECOV);
> 
> This _could_ use kvm_cpu_cap_check_and_set(), but given that this an AMD specific
> leaf and unlikely to ever be used by Intel, I'm inclined to handle this in cpuid.c,
> with an opporunustic "conversion" to one feature per line[*]:
> 
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 2617be544480..ea11a7e45174 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -743,6 +743,11 @@ void kvm_set_cpu_caps(void)
>         if (!tdp_enabled && IS_ENABLED(CONFIG_X86_64))
>                 kvm_cpu_cap_set(X86_FEATURE_GBPAGES);
>  
> +       kvm_cpu_cap_mask(CPUID_8000_0007_EBX,
> +               F(OVERFLOW_RECOV) |
> +               F(SUCCOR)
> +       );
> +
>         kvm_cpu_cap_init_kvm_defined(CPUID_8000_0007_EDX,
>                 SF(CONSTANT_TSC)
>         );
> 
> 
> [*] https://lore.kernel.org/all/ZoxooTvO5vIEnS5V@google.com

