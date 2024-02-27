Return-Path: <kvm+bounces-10136-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 46D6D86A08A
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:51:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 43595B3400C
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:26:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEEDB148FFC;
	Tue, 27 Feb 2024 19:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="aHGTH5a5"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2065.outbound.protection.outlook.com [40.107.237.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C3111CBA;
	Tue, 27 Feb 2024 19:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.65
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061934; cv=fail; b=e/CyJ5Fb200/JrwNHyNX9reKq3af/OZABRBDRlMC9eHHkP60aT4fb6vaWqEWC3cGOgZ/Y6/QpXa9B/V1YnbtgZE33KeHqRG/+LJwWw8D6LZiMXGklZS3gQi45jJl9dGVm6LxbNvnxHKSW4JszpeFPGVvTYhoYpUYjJdTKcJBtgo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061934; c=relaxed/simple;
	bh=nMJP1lwmX4zRPuduuqY+Cink/V9VlJTuipB0y8oqnSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KQHOMJbunn8B+cMiO6H08WuXKtxIpv/Zi3uSaOKR7Y4QKgaXlj02d6QmUF2UIDCLEnyFL31hiGWcG7FgLxMZtRbPZspkSdQ/XfszYwPP/ZoI4R8Cu8zcETuM/vNShZNvwwIl2lq+lpDOO8nSNnQNFc17+nYFjW4IcNc3iupTbGM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=aHGTH5a5; arc=fail smtp.client-ip=40.107.237.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xx9Rjeuz+ERQAplsqE3X1bIziQ1TUOMWTrZlMsyg1getMWjep4AzqOSCpVapJq4q1ALhfNxy6HO84QKzpCyJ1QVhKrNcIg7EF95klVjD1xrwX1DR4+LweL5U6x1wzQvIs4Z1gvPPJxIzKzZIvzVXz7Gov2z9rSK/AOlOO9Xz9POclSZgeCWYeh/lN6bnWgR6PQ8hbeSq0J/GjJKPRYy9fu9M+QRn8XLUjT8aABIrzfg6v1x5bDOHHwBrFHAuevp3QDbGC+SV2+xXqeCUsyBGC5B17ebJzGRezOZlIo3j8SJCZ+GZRNjipFpoatTcCXnd7xhVtIgOehkMYt69eG1vcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iaTDuQfSENm1F/5tJoj3HqvOH/nz9GE+5FlnsDROxUE=;
 b=nhzN/XNQh431kpc1mcqZdHH9/AvDCtU+yubZWjSi2ZcbO65wzEO/hhIXaxQoaHc5KKpJAjLnhynplbBuEnrA5H9IULlM9w/uSgxuoBcqfNhzW8tc+F9NALcvtxvqnhkvCfKiC44Cfc6myNPuFGigItKq0E0mMXOSCcb1qFmlYPVyVRUhuGtKnLSje1CvilHhx11C9Ho2kYXn7DaMPSLH1xzoMkEZ5A+U1SIwtRakRB/CIrPzPj3luoJ5epSYxMjUb15ZsKumbFG7CL5ztQkWhWfC/4GCXUlaD6PfEluGezfKK+TxLD3RJPJ8O9qfMwVek1Mh9cPCk32WRw2xwlQ1NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iaTDuQfSENm1F/5tJoj3HqvOH/nz9GE+5FlnsDROxUE=;
 b=aHGTH5a5CYK2ZFUNiyZYxRkZQ6LZlTE0+CXTnz6ZjnIsTE8AuT4QDloisDj+fOvIDxlGHjJUTlmxu2mN1Gv0prhSMYMWWr5blhlNtOM7ba/uBHn3qP7wKzfMaiVQOr46U4lT/IEj1M4ElRhfKSF8JWW9araEL/5x/ZJIzElu990=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by DS0PR12MB6535.namprd12.prod.outlook.com (2603:10b6:8:c0::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Tue, 27 Feb
 2024 19:25:29 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::319f:fe56:89b9:4638]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::319f:fe56:89b9:4638%5]) with mapi id 15.20.7316.035; Tue, 27 Feb 2024
 19:25:28 +0000
Date: Tue, 27 Feb 2024 13:25:24 -0600
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, kvm@vger.kernel.org,
	weijiang.yang@intel.com, rick.p.edgecombe@intel.com, bp@alien8.de,
	pbonzini@redhat.com, mlevitsk@redhat.com,
	linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 5/9] KVM: SVM: Rename vmplX_ssp -> plX_ssp
Message-ID: <Zd43JFPI6cTykK7t@AUS-L1-JOHALLEN.amd.com>
References: <20240226213244.18441-1-john.allen@amd.com>
 <20240226213244.18441-6-john.allen@amd.com>
 <Zd4mf5Z1N4dFjFU7@google.com>
 <1f95281e-f8a9-4ff2-8959-162a192e48bd@amd.com>
 <Zd41wDpl4K6j+iU+@AUS-L1-JOHALLEN.amd.com>
 <Zd42tc61Epo3REK0@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zd42tc61Epo3REK0@google.com>
X-ClientProxiedBy: SJ0PR05CA0040.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::15) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|DS0PR12MB6535:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fca5778-5a75-494d-afd8-08dc37c9daff
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	IyjTgU/RGWcUc/TbgWoiHBEI52eSSR7Lyf1msC22+5EyCrxF/AHVAGWaVqu6Dcww/bd4XSPQoFLYa4r9X6AThlnx/38l/Gl4Xzc8qcfTgcUG+Qw2T9+KQqFnMxeCKid3jdfdhkz+M7QBQ8IXCq6RHju7sypq+fVCGzoHni0grMfZZayiB9o3GA70plHo1z/3BiINt3N0u7tRSphKATr50h+v748SeA1euBTWX5UD/JjfVsPanKHWwp4/vJ+OBhTrac9IqVeDAgkDmkwdCTCbtdu7WSYJm4lvS2M5ilY1Ir6NagMr8ctpQEyf4Ip+wUFlbfy5Pz3L9+vs3E9ctyTQTmX42yewnH+DxkbvkDLJkeylAtz5Oz7XyH0D4QM5p9uUYWdaKeHPWJHIL0BUVsZADuEn8hUnNSp4bQfV3rPcsaSfTbnRgCkz90VwjlEoBBUekU8uCUaVuVsfY6nj0nLKy9R0bPekkCaXid2vGdQOX1ag9DjCAr83S/nobNF8yeU4Bpx136b7Tp4c+95OSnwByF90pb3N4ZgXiH0zbXTNIhz+Kj007bjlR87guisBeO3JnH9J2t9+xnBAGS9ynoj8g8nA/dhMVoWttin37T6p2zYvfCMDadCYGIgGfyF6rSjbanZ/zohNyq8UYNr5BaypdA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?caT1T+W+2E2nUpHcB3ATQe1KIj+14anoOc6SFaT6TlmZ5oN5D0uJqUatMmNW?=
 =?us-ascii?Q?FC8zuMJygeF+dUOcvwOA5WlDSV6L1ySxjMcuJhaO0XwpRpOtyc9+TBS5q/cO?=
 =?us-ascii?Q?kxqbgGtNtfekbtAXSv+4V5XhBcCCYO6gKiApAPk1zDR382go5bJvlTw8eBxg?=
 =?us-ascii?Q?ngVeTEc9GZUL4SAJ3iOWdAnqJIyjDAawtETR5YUbRPRikfiDX93veQud10yn?=
 =?us-ascii?Q?K/1ewGTjnxUQQOyaaf0UiW2oChc3o8LLru/elNGI2rt8v3pYhXlYuNd/v2jg?=
 =?us-ascii?Q?7sUF2gqjgAzS8WBN5j36k9oUU+egPRgMY91NDA6NruxoqUUraL+wwfiL7pF8?=
 =?us-ascii?Q?/bIHXvGOtPVxaiilBKKZ7B1u8gykw0aUgtHFyRw9fNGTGehgvOdt+bDmWd0M?=
 =?us-ascii?Q?/QebAIVZQDmfi+JTCIATZbR/SxSNp63d9MuKU6y8X1kW8edI5zHhV5GtOPm/?=
 =?us-ascii?Q?YgJj0kEoEnM04+t8cgPLwGhWlqgNnVKni2TZ2U19cd3T8FvkH9mMlZpv/jQC?=
 =?us-ascii?Q?4gu4AP1M1mGMNrE7NrFjAMF/26tKCgD9rmuApEObaiYwtDi4hETm6qpAvZix?=
 =?us-ascii?Q?+sxc55794/OUiHX8TaTpauEWyClL/Zo5HwCpREihzSdPdIH2LM62S0R5k6Uy?=
 =?us-ascii?Q?BN9lmAcpgL5TdLw+5whqwG63fql3VUy5CkFg2+WSD/C8WDguGc8yoxE0z0Ca?=
 =?us-ascii?Q?gliD3Fv9nNnwgkpJ7QxUIEjOzyCdg6AQu926vibY12iTYt1qe3A3m6bHu6gV?=
 =?us-ascii?Q?0f4uk0rRfAlz6WYJfzjc57FUoIx8AR2C3jv0v/MQbUJT0sUQSBTs+nw7HdGZ?=
 =?us-ascii?Q?P3jBfLt6s7XBD+JHOasHBHzJKgNOxo4K59NOuxS2qUHZTn2/QYu9qUUn9VRZ?=
 =?us-ascii?Q?nFTzWLfDlduDr8s/llHTq9OxUn9PQdTmDiB5xuy3VNVGa3D6HMNA5FYOUx3j?=
 =?us-ascii?Q?hq9DZOe8FqQ24pcUGVVcDMo5UszOxI6KjocLtnWM1iye+/SMI4bg2CS4IUbC?=
 =?us-ascii?Q?EHleNKbkviijqtp+q3rYaLxkzO4aXJpkB+WE7R3T8iXD4OM8yBqi0lQS2sGp?=
 =?us-ascii?Q?7qHKc7VsCZHr9CU3a+dsBKPCOpr1nfJ31EfDEkEQUQfuEVXOblv9qih1/5QY?=
 =?us-ascii?Q?k93SIUaYncM+FrWbfwKMTP33c/JQar+Djh/YL1guKFuXZKT4nbi01Y17W1W+?=
 =?us-ascii?Q?C0FBphH56yf+7LwAUjcf3IXSf2i7PD9pzTok+uSRLMbn2v57lGU4Rw2awX1f?=
 =?us-ascii?Q?f1efkfXw4vOsQ0ZGOIAhbedgxUiV24H1Y9wyw2Qs31YIUjCL+ovTU7wm8GD+?=
 =?us-ascii?Q?BBT1FWKpS8wgCOjtB9KJife0JtSyBvABzPhna8xQFt0SpfGkqEflKDzpPMpY?=
 =?us-ascii?Q?v8ZMBV/Bv6i3FBmbAnZaImj+eqjdMTovBjWPrYNWu9ckjbB1U24CCPzwQA3S?=
 =?us-ascii?Q?WmmqT0Ng9tlGkehtTCGFm+/zRAG+zuvqzLYT+SGCrJveSiuOULp7D3oIbaWR?=
 =?us-ascii?Q?gZBnRjhf0nvdesvo6fT1B+dQdY4rYk4h1Ic67ZR/Q0opc8Z2lLAEi/dQYJi8?=
 =?us-ascii?Q?7G16szNhNBmZIaD41e4iIdMlX49LdUDMwZAjULYZ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fca5778-5a75-494d-afd8-08dc37c9daff
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 19:25:28.3363
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: phhoZvpgMj9eEcVEzwlVcfkYm5e42ixkxuMormoxHylQMfrnM9tNpTWeWLe3+8ZBNqezCsWMGzeHM21+RqzUxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6535

On Tue, Feb 27, 2024 at 11:23:33AM -0800, Sean Christopherson wrote:
> On Tue, Feb 27, 2024, John Allen wrote:
> > On Tue, Feb 27, 2024 at 01:15:09PM -0600, Tom Lendacky wrote:
> > > On 2/27/24 12:14, Sean Christopherson wrote:
> > > > On Mon, Feb 26, 2024, John Allen wrote:
> > > > > Rename SEV-ES save area SSP fields to be consistent with the APM.
> > > > > 
> > > > > Signed-off-by: John Allen <john.allen@amd.com>
> > > > > ---
> > > > >   arch/x86/include/asm/svm.h | 8 ++++----
> > > > >   1 file changed, 4 insertions(+), 4 deletions(-)
> > > > > 
> > > > > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > > > > index 87a7b917d30e..728c98175b9c 100644
> > > > > --- a/arch/x86/include/asm/svm.h
> > > > > +++ b/arch/x86/include/asm/svm.h
> > > > > @@ -358,10 +358,10 @@ struct sev_es_save_area {
> > > > >   	struct vmcb_seg ldtr;
> > > > >   	struct vmcb_seg idtr;
> > > > >   	struct vmcb_seg tr;
> > > > > -	u64 vmpl0_ssp;
> > > > > -	u64 vmpl1_ssp;
> > > > > -	u64 vmpl2_ssp;
> > > > > -	u64 vmpl3_ssp;
> > > > > +	u64 pl0_ssp;
> > > > > +	u64 pl1_ssp;
> > > > > +	u64 pl2_ssp;
> > > > > +	u64 pl3_ssp;
> > > > 
> > > > Are these CPL fields, or VMPL fields?  Presumably it's the former since this is
> > > > a single save area.  If so, the changelog should call that out, i.e. make it clear
> > > > that the current names are outright bugs.  If these somehow really are VMPL fields,
> > > > I would prefer to diverge from the APM, because pl[0..3] is way to ambiguous in
> > > > that case.
> > > 
> > > Definitely not VMPL fields...  I guess I had VMPL levels on my mind when I
> > > was typing those names.
> > 
> > FWIW, the patch that accessed these fields has been omitted in this
> > version so if we just want to correct the names of these fields, this
> > patch can be pulled in separately from this series.
> 
> Nice!  Can you post this as a standalone patch, with a massage changelog to
> explain that the vmpl prefix was just a braino?
> 
> Thanks!

Will do.

Thanks,
John

