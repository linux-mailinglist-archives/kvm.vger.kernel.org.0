Return-Path: <kvm+bounces-15306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5963C8AB165
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 17:11:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DB1EC1F23E68
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 15:11:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AD3312F5A4;
	Fri, 19 Apr 2024 15:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="Lwy9C1xR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641A912E1D2;
	Fri, 19 Apr 2024 15:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.86
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713539476; cv=fail; b=GyPZ2RyDt0CUR2WEuYFclyLqQpjswjhBLkRG2zOYDMIUTXIYqZKYTPUihecsuQcMLXMz0HzM3TRg8PPXUTZpCCFq0aKkyYBZ7JVGmP8MGXb68o6gH96SUUOSue1HALdBCAUVqoLqm98HtNn9ANouEMR1nSxXYMhk6XFt9EqdpqY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713539476; c=relaxed/simple;
	bh=v9J70aGyBGgGJXGFNR48Z4WndwkG7puOXl4FXXuIZ5g=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dEfag/xQpvaXCn4GNUd0n4fgo5hxFO261Vp5byShf8Lh2jjaduLoJ78d1YjQu3p6rxqUovKNxrDfjmqJsnhmzmz2Ifib0Y0w4Xo9jHUtz4RL/0gDI17Fp1jo2mbMWKKqrSnjuWCysZJNMXKnXdCEjcVtt+l13d2hGSvmvj7qJVU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=Lwy9C1xR; arc=fail smtp.client-ip=40.107.93.86
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iGglFsMezYIvPja6laEvVLvSTpYRXcOQZOYjSCRFE2AOzHUu04vz4/hvPNLqvUuK/f0i2vL6wt8q1wx7l2VgexiXWF9b552cCJX7yapSbBmmiCmVKajtViUQveLDfsi17bUGObPJaVJkpR2hoYAzHcpTaxmdt2ellWs8MvKx7/k+xnH+enTUDBAEEJCX3r7vrU9YEI3vudWUDzkMyGnr6shMg4zqgN0+bA6z1HifTZxwj/C2CmKOWCCCX6Zc30p8TWyc3drURexESAoeJi35qWDvh1LZtKnmV+KKpRQbxxt5QNH0QZqNb+UBtmtOyJIs8cYwMfuj6nEHa5ddjFVv2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qSeQz0enh3nAACey1JKcfgjxc5ZS1pjRYCYrOLMTs4=;
 b=gmnxAfuw71cwuJQIaUmunjmR29KdQiW4tVzSfRsMGQuNd4hNJYIm+QgsGnMseYfmTSJBv7yKVTpnP/yzcPdaujpzg2O6aMj0ExQCSOd6hF6+eL7IjsgyYrn2LkOyYUDmVD6vz4WZZ6jHHTE+AlG96+TWpr5tAcu1egvo7RWsb0pubNyPOh9AhRRZBctCyq3oI4hkd6CLG8kcfR21EfIEVesnjHxhkxdv5+8LH1JNMO+d94XbnYpFB+3IIikazgWsOelmt8Ega/OFTqTDN2FXHB+xkW4Xrgmc5DJFxApXfZ1sHLS6vRujDDgf6rV16CN/2TqhVrO505MiR6G3LHyGYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qSeQz0enh3nAACey1JKcfgjxc5ZS1pjRYCYrOLMTs4=;
 b=Lwy9C1xRLLYn38lSawithV5dB0Yb5+GmGWmbBq8bAcBq1nmBJ8ZvU2xOazICg0cN8KiEm6873XgOpZn2gDETGcaFoK3Uro71xKXkbGi5gw3UFlLDwfRNfA4+GcxbSO9MQw8sI7iFci8bgq6AYYRmB+KvaZrTE6dWtEQhsxJXcog=
Received: from DS7PR06CA0038.namprd06.prod.outlook.com (2603:10b6:8:54::19) by
 SJ2PR12MB9139.namprd12.prod.outlook.com (2603:10b6:a03:564::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7472.44; Fri, 19 Apr 2024 15:11:09 +0000
Received: from CY4PEPF0000EE32.namprd05.prod.outlook.com
 (2603:10b6:8:54:cafe::eb) by DS7PR06CA0038.outlook.office365.com
 (2603:10b6:8:54::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.33 via Frontend
 Transport; Fri, 19 Apr 2024 15:11:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CY4PEPF0000EE32.mail.protection.outlook.com (10.167.242.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.7452.22 via Frontend Transport; Fri, 19 Apr 2024 15:11:09 +0000
Received: from localhost (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Fri, 19 Apr
 2024 10:11:07 -0500
Date: Fri, 19 Apr 2024 10:11:09 -0500
From: Michael Roth <michael.roth@amd.com>
To: David Hildenbrand <david@redhat.com>
CC: <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-crypto@vger.kernel.org>, <x86@kernel.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<jroedel@suse.de>, <thomas.lendacky@amd.com>, <hpa@zytor.com>,
	<ardb@kernel.org>, <pbonzini@redhat.com>, <seanjc@google.com>,
	<vkuznets@redhat.com>, <jmattson@google.com>, <luto@kernel.org>,
	<dave.hansen@linux.intel.com>, <slp@redhat.com>, <pgonda@google.com>,
	<peterz@infradead.org>, <srinivas.pandruvada@linux.intel.com>,
	<rientjes@google.com>, <dovmurik@linux.ibm.com>, <tobin@ibm.com>,
	<bp@alien8.de>, <vbabka@suse.cz>, <kirill@shutemov.name>,
	<ak@linux.intel.com>, <tony.luck@intel.com>,
	<sathyanarayanan.kuppuswamy@linux.intel.com>, <alpergun@google.com>,
	<jarkko@kernel.org>, <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
	<pankaj.gupta@amd.com>, <liam.merwick@oracle.com>
Subject: Re: [PATCH v13 04/26] KVM: guest_memfd: Fix PTR_ERR() handling in
 __kvm_gmem_get_pfn()
Message-ID: <20240419151109.bo6kz4s24jgrmaj4@amd.com>
References: <20240418194133.1452059-1-michael.roth@amd.com>
 <20240418194133.1452059-5-michael.roth@amd.com>
 <a6086ba5-6137-44a0-9e51-ce4df5eb6ce4@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <a6086ba5-6137-44a0-9e51-ce4df5eb6ce4@redhat.com>
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY4PEPF0000EE32:EE_|SJ2PR12MB9139:EE_
X-MS-Office365-Filtering-Correlation-Id: f21d702e-2189-412d-a4ec-08dc6082f18d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	iunGVMZpDu9mmJf9+rNqettYlXiVIlnxFFBNycGuCOBsltobTMrWMJkFNMcmeGL27PuOg9ToDLyrJJWNOxLeuo0Wb43m7KnJpPsR9uVIIARMEBoDOnw+tLOTlNF2t+0jLhBD7ZKduQYR992RTyasB3OI4f/z6qcxIlk++by+mjedc90GRwRyHwtiWqdm92qLWTi+Rjr6THEWQHe9C78+1DYuV2VLQETWFVE07wSzuYVAwd8QHs5JsV8w3eiwntXSfn1PDrThFKzXt026Vp/PbQt51/OjuZ3f/Be7HoW1CcOpbys1ZFfZb1rTj6ISppynBGA9wgfp9ms5y2qX643eWarbQmCj0mRv/u9HtLeAQjtNc+oVFxhEmgdY/QjlpsXBCpC+NgncZR9ytlLAa0UdBR0ZgS4+61o9pTGlB426wyjVaXbdv3qLPrn6XZLwNaEpOyXFGMZWSlFfye3nYXR0DnglixQEqS2ubob7AWu5SHOzLvrTTdPf2hv4LFh/04fsWsBMKVOUtLFSs3VNBrUO0y0FrKKXldEoi3MT1sCDzuF8eMw6KFSGB4nxmSe4tmqBOjRMwB/1Dh3ZKEWSMCo1ePPeFYm5uLsy5wxXtE1cvRKksZVQFYqVaZ6F/NrT900WiPI/PbvY6riEKdodD7oBUqsHNGoPu/grhLrCA98bkIYBBBI9YMRcLv3u/QaLR/chu9QruKaPTG2HTVfZfmuu0coWAVaYs7jM21lm6xRhzoo9LHzZ5T/Q9EpFlnyoZMgm
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230031)(7416005)(376005)(82310400014)(1800799015)(36860700004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 15:11:09.2923
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f21d702e-2189-412d-a4ec-08dc6082f18d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CY4PEPF0000EE32.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB9139

On Fri, Apr 19, 2024 at 02:58:43PM +0200, David Hildenbrand wrote:
> On 18.04.24 21:41, Michael Roth wrote:
> > kvm_gmem_get_folio() may return a PTR_ERR() rather than just NULL. In
> > particular, for cases where EEXISTS is returned when FGP_CREAT_ONLY
> > flag is used. Handle this properly in __kvm_gmem_get_pfn().
> > 
> > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > ---
> >   virt/kvm/guest_memfd.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> > index ccf22e44f387..9d7c6a70c547 100644
> > --- a/virt/kvm/guest_memfd.c
> > +++ b/virt/kvm/guest_memfd.c
> > @@ -580,8 +580,8 @@ static int __kvm_gmem_get_pfn(struct file *file, struct kvm_memory_slot *slot,
> >   	}
> >   	folio = kvm_gmem_get_folio(file_inode(file), index, prepare);
> > -	if (!folio)
> > -		return -ENOMEM;
> > +	if (IS_ERR_OR_NULL(folio))
> > +		return folio ? PTR_ERR(folio) : -ENOMEM;
> 
> Will it even return NULL?  Staring at other filemap_grab_folio() users, they
> all check for IS_ERR().

Looks like the NULL case is handled with PTR_ERR(-ENOENT), so IS_ERR()
would be sufficient. I think in the past kvm_gmem_get_folio() itself
would return NULL in some cases, but as of commit 2b01b7e994e95 that's
no longer the case.

I'll fix this up to expect only PTR_ERR() when I re-spin v14, and also
address the other kvm_gmem_get_folio() / __filemap_get_folio() call
sites.

> 
> >   	if (folio_test_hwpoison(folio)) {
> >   		r = -EHWPOISON;
> 
> Do we have a Fixes: tag?

Fixes: 2b01b7e994e95 ("KVM: guest_memfd: pass error up from filemap_grab_folio")

Will add that in the re-spin as well.

Thanks!

-Mike

> 
> -- 
> Cheers,
> 
> David / dhildenb
> 

