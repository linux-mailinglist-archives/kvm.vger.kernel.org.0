Return-Path: <kvm+bounces-58045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DCF48B86C1F
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 21:49:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 930A4482F72
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 19:49:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC2482E8B8F;
	Thu, 18 Sep 2025 19:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="KPosuBHV"
X-Original-To: kvm@vger.kernel.org
Received: from MW6PR02CU001.outbound.protection.outlook.com (mail-westus2azon11012043.outbound.protection.outlook.com [52.101.48.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450ED2D7DC4;
	Thu, 18 Sep 2025 19:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.48.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758224947; cv=fail; b=dh/vrlUUQIaWdfp0XC2OER8SnJdDWkjdLgZ39P728KlF4VZNEUBwCI+6Ubgn2E1ZM3haXbjfmxitPClaOz4Km3/Hgk3GG/3no352XvWBv5YvGl44SOZP0z4J/oRBMR4+3n5tGiBQlIBrUBn6WzebBHibTen9y0p/OCuuBwdBLZc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758224947; c=relaxed/simple;
	bh=qdKFyJ605flgCaLjoSpy/fUtvOtxSEmO3GJcwqz7U/k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=DQZkvKS1ykVn1KRhg1SENklU6o4V1MQtJ8ch/PbaKXRBfB8MIxW6aKJLKTBjTfDIQsgA2NS8wZkSg8nn4MgOaXJkpH3Jo2DdBvBrdI4eh3I45oD55CLEXtB+a0QOLDVLT93oiuzsefxMreFk4YaoVbxWNs3itRl9Rvg54nsRRRo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=KPosuBHV; arc=fail smtp.client-ip=52.101.48.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bSpbvaycN443E4kJxJhDPrjUJh+e2yxJJk51I0UQnzg/jD2s94Fh8h+eql71wvRG+GbZiF0EYXBmY6AmHyt1KL0V9em5IcYEYNyuk8DZB2b0SvGrM4pdP+hq75RsTtQRZk72+QGt2Cn2uCv+gjDGXuA1vc1TTZmKbT/J0KdivlI/SmhcfpL7jM75KM7VUTAb9fOAkTbNo4Y32v178dfpcNLIifVPfGT0TnxpH6eV4BnMVOhSk5TDsecgroCEO3eyMy3a/wZN/AVI5S44MRm3iVXj+ScTtEi7tfQWY9IJ+o3c1DMYLda9ocRQZXNFYz8hpL20zDL/wP0akEJhZuygmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SEZOaX8EaXZgImlycSulhNlJra8YpAvI5DCdGk3im4c=;
 b=ctNHcjfAQkGPWBTTMskwvlN9HbtC00zUy5u3XZjYEZ/f4j80M+zCA+j4l4BMEdegZnBnzcuaGHpcUJn9ilvbgDx61Xe0PvlwH/qYnm8Af+54DksnielyEH6YyimRWKjp0YSPpO8sQNNOSKz6yi2BVcdLrEfbT/D5LhjqNAsH6Wp8B2Qi1wlqhF+YmUPcZEbDAE4Ejhd40SolDh8N9RUs9wdFzl+AR9iULblnnKKYTkyQxgwFYxMINx0+BybV3bzS2khCPxCvXTTsTLobfpSD2B3Kf4mtxPR7hEXwrfQCPP1aKguyXsSwsv1oBCiAGzDQvBd42WPu9osERV2RmUHljw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SEZOaX8EaXZgImlycSulhNlJra8YpAvI5DCdGk3im4c=;
 b=KPosuBHVnh5hyX8TFu1tcU8igXlIFaZngfpBnXHVUI4k20TtNs3BxAb2befdvF/TDqLZXhjF0l0CHhV22cqyuEUJ7tvCVOKvM6p5NcXEeQbaH1hJxCiAhy2QACj4RWBtdAkrcw3NxiixJwtTlg4XcN2FIaDlhHCuzfbJF0xB2vg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by IA1PR12MB7591.namprd12.prod.outlook.com (2603:10b6:208:429::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9137.13; Thu, 18 Sep
 2025 19:49:00 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::4c66:bb63:9a92:a69d%3]) with mapi id 15.20.9137.012; Thu, 18 Sep 2025
 19:49:00 +0000
Date: Thu, 18 Sep 2025 14:48:49 -0500
From: John Allen <john.allen@amd.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Mathias Krause <minipli@grsecurity.net>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Chao Gao <chao.gao@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>,
	Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v15 29/41] KVM: SEV: Synchronize MSR_IA32_XSS from the
 GHCB when it's valid
Message-ID: <aMxiIRrDzIqNj2Do@AUSJOHALLEN.amd.com>
References: <20250912232319.429659-1-seanjc@google.com>
 <20250912232319.429659-30-seanjc@google.com>
 <aMmynhOnU/VkcXwI@AUSJOHALLEN.amd.com>
 <aMnAVtWhxQipw9Er@google.com>
 <aMnJYWKf63Ay+pIA@AUSJOHALLEN.amd.com>
 <aMnY7NqhhnMYqu7m@google.com>
 <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMnq5ceM3l340UPH@AUSJOHALLEN.amd.com>
X-ClientProxiedBy: SJ0PR03CA0220.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::15) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|IA1PR12MB7591:EE_
X-MS-Office365-Filtering-Correlation-Id: b1fbe02e-0ab7-436e-62e0-08ddf6ec6985
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?704OMH63aF6v6r5JzsdAo5PNqL/0aqi17Fxeo68eKoyyuLLXIlbUiibJrE2v?=
 =?us-ascii?Q?KHz325MIgdxvA4mc7XchyyzmDGnpSvd7uS26YyNblKSK/abC8nRm1xJXuCv5?=
 =?us-ascii?Q?lxGAsVo7vgjO8btCGxvWSgAKGJOij1+j3MVbgRrUzsavlMIpDk8QprhgJwa0?=
 =?us-ascii?Q?o5te+YyBzvgxYwocSQTGVuMJV7oMwmPmp95Lc+I5AhTcsr8ncDH92pOglgka?=
 =?us-ascii?Q?IiSohYqfwGvUPRJ008jEsXc7JnBzOHr/GOl+HQKnVoq5y/ftW83NIN6cAwR4?=
 =?us-ascii?Q?TnFsS7oy0rFIKyZjQbN1aXtmTSKirB4Op/2sDCG2584XwF3A5uRiB7DiDK06?=
 =?us-ascii?Q?oCBTYY9bfq+vBqC4udg0Bn8JB8WiO0A9sj+SbD9zuhjoBzEamRMXTGRPcEzX?=
 =?us-ascii?Q?V+h2HdIpC0iM4DvEo+cn9ZRvMFcdsI6IofsVVnXvBo+/uy0wsCInqlAdKROP?=
 =?us-ascii?Q?vyiQjcxGC4mX9LQEND8tMrWK4vuHCbmZBe3t/1Lf+YZ70rqAy/lbe51fWsyq?=
 =?us-ascii?Q?2Y3wFixpOO9xDSd4qCroNQQYB6vUJLT+imFajq6FU7QJh7KnlNWguTotDfwH?=
 =?us-ascii?Q?opyDHUvK9B9zqXhseBWv8QzLnOAhCpuYt6D90RqI70Z2r6wSqebreV6jlOVm?=
 =?us-ascii?Q?neYuQyi3oHVrL8BaM1S6bF2f60288SoKstirznqlDM5QktQ6RXGsfSmGdzSW?=
 =?us-ascii?Q?IyI8tw1m7L0aT6hqJFTl2/lf/+JxmkJjC+dfjepSu0Oh+8ZCuFfZOVOICS04?=
 =?us-ascii?Q?hJqOQ3iG9qO2aS5ez14hT98T2zP49WanBCmthqfR0bDsi/oi0ZxzMz7vQ3cU?=
 =?us-ascii?Q?S3v7UkqnUKiTMPTUTgFENQXmgDkC1CTYqal03YU45M+nDP7bXJbsQ/HAkmCg?=
 =?us-ascii?Q?IV8Ek69f+XLOBmJkX4p4yAHiwQaAIwLdh2zSFE+Rc063MiQkzIMiBqdPAb39?=
 =?us-ascii?Q?KIQIKX7okZOCgfGKerDJRBrwvQRK9jaqNzWgFC+5XQbUIq4DCUFfyHwgqT2k?=
 =?us-ascii?Q?GbflvJJLZp522wyGoLl2XKGwT3vAk+NomtEp3wYMfGeX+ug+UgSj/clczqkX?=
 =?us-ascii?Q?CMDTvMJ/n0xej89c0ZfNOqEvK28amILbEsTDnRNLnCRfuM/RLJHiY6eGIZ2E?=
 =?us-ascii?Q?sAAI/wzamz+fTEvrFXfFXfMwDFV+px7E42UT5W5cNl2YAJoZuj0v4+4gfPXf?=
 =?us-ascii?Q?UJaRa6p7K+AHdATUoZx/L7sE2TXBFw+LzYpn701me1vtqM++FoT9OE2AVIpb?=
 =?us-ascii?Q?Pc68qzvIiDNp07Mk+YCTPBnreUpjZni9GVhG/x+Cs53+r3QwRVqMzbgttH4j?=
 =?us-ascii?Q?KTQL3AdOxfVx8jtZaBY5atqPCwd4uxr+JVjmPh8xrd2cZkvRo/mRhxl9YplT?=
 =?us-ascii?Q?XQm1q4xZFxZjZlIxtotEr3GOWqu5VINMEyMnIeUwpaBS+I1ZT4rMBWk7iyT+?=
 =?us-ascii?Q?r0aO9rCZ9QM=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nH+GZg2C+ie0uBplW2Fo9bD50QWfEL9kG0sDwCQ7VNtKTSSQMCHeQUjGZVYa?=
 =?us-ascii?Q?YPmusdqmJSj9fGZl2IeGc1+LPwuTjKCukiySgSJSb3S/aC5QamYj/npzLMDR?=
 =?us-ascii?Q?AeFmZzKPhbjqdJt5uJbXEao//DvZABH0MEDI9QEHfQC76qmXVgYZmLJFVU2b?=
 =?us-ascii?Q?i9uO4WtKqnL3KuPqb7pfPZgwdl6EZ5ZJZXDQnE42qf6vVkoYTvYGJgZzM7aC?=
 =?us-ascii?Q?jfkVvT/z1wBGNRd6KV1Hvh+G12VG/Bubgi3dGQC/tiqyaUAbccet9Y5n46qr?=
 =?us-ascii?Q?5i7CMtRazHvOAyL5wY8iUO96SBqdgH/N0y/0/OgwdQm9As9Lo4N/zoc/OU5g?=
 =?us-ascii?Q?zX2c+T0YYanZeUnD1p0NgyzWFUPZ2JI22/0aqrVy5GjfYpnpUVB0QqrJmqme?=
 =?us-ascii?Q?yxRSz189NW+7auO2tGI/5wepYKU3m0CWS7Ra4SHGrNK3j6SpjTf+lBgNy+H8?=
 =?us-ascii?Q?4icoV0Qdz3ND4dXx8b3b1+LrMVdc1nXO4WJAShnmhEknz1L72OQMs0X+rD9X?=
 =?us-ascii?Q?FdnbqquqNCSadAoVuUd4e5MxChFGbbU2Ug+zA7teLlK9IYcJd3TvCfqwlB95?=
 =?us-ascii?Q?DKEFAt/j2fdTKpnBoV7+yb36VZ48dqgPlniYdUmry9zRgRvBd0Zn/Tl9ZsF9?=
 =?us-ascii?Q?VboXIa0MEJ2SR8ZCxNDfNyh8KhoT6hoPXdmGlExcgZb0V4YyHaZRRtv9hfDj?=
 =?us-ascii?Q?bsj5VndyctsbWeRvzN7ONuxLyrkPLxEIckMYu8NYjtseZypo/GsmmQwSZ8MA?=
 =?us-ascii?Q?pCMBJKjjKCDHz4my58PbadzsfedJ1TzsEnYb8E8/9mw7FeQZlRANGEarNBmV?=
 =?us-ascii?Q?moMPd7Sqw6tfnPtWgdTp1Dbm4GhzgKgwN2TfHFNyQwwQF/aIdJfG2glulAmW?=
 =?us-ascii?Q?TZk2KMrWd0QzEKc2P0oJET8cSSnTEix/zhlDSR2Mk5jIh1Am4FkKhI4E+xYR?=
 =?us-ascii?Q?leZZCnsI0pmHT/6EGSPxK/ChFX+rDX1vz+JdcvBY8rO58JSSLMBj8LAFsBVR?=
 =?us-ascii?Q?HUBZ0bbtus8M0uTedT9kEf/WhjGFqjISRZvD6VZ3d8VcqaS8lrd/0wlzfRxT?=
 =?us-ascii?Q?iHqtlqeQ786VPblC85FoWubsXUls2x9enD/HvVrHweamIaoWXqXQjG94wNI5?=
 =?us-ascii?Q?Nl5/I43i4OErpVBYh3IFg9Ak7jaGGuAEiJNX6olipelzXVoWiN0GdlBouF+Z?=
 =?us-ascii?Q?dNxMjDkBXuTkMGB7iasNC6YbGsn6eIEQrxUJikjIbmOf1UbSfZsIM8+2ASMo?=
 =?us-ascii?Q?Fpl0ik0IJWxNGQy+F208r82nQwXfkNghPCNTBfbNQZ9eVzE4wSxCLjamNylB?=
 =?us-ascii?Q?8QuOnh2ARzawlua2Vs8FXYO71N5Ng7e19ORgJaSsZOThJfcEKISttTzfdnb2?=
 =?us-ascii?Q?N+Gr7JeYsmLcnF9SwDgXl+UcHBl2t7VxdMMvOu7uQQo6ufG4V8iellS1qglh?=
 =?us-ascii?Q?J1ekmXAYqkVZMPfxYCGhOxvOAuoxjYY393rpMLL7EIyxkp+Lo+LwxIm7f7rR?=
 =?us-ascii?Q?UPQQjKRgVTiZXGHgnNcHPm6qZkfsOCSaLgjCN7siOa1zvlVr3h071DZyHcNM?=
 =?us-ascii?Q?BqrbLHjVmIV4QHGHYQdKZ5IWSahe6OV/X5IGK7VM?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b1fbe02e-0ab7-436e-62e0-08ddf6ec6985
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2025 19:49:00.2372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zK7wLyIxHxHP2S40LQwmZTmn+hH1R9xS+BUcI9nHw/pm6hRpVsWPMowgWUc/irGedfVEE4+rvRZIfdQGh5aAZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB7591

On Tue, Sep 16, 2025 at 05:55:33PM -0500, John Allen wrote:
> On Tue, Sep 16, 2025 at 02:38:52PM -0700, Sean Christopherson wrote:
> > On Tue, Sep 16, 2025, John Allen wrote:
> > > On Tue, Sep 16, 2025 at 12:53:58PM -0700, Sean Christopherson wrote:
> > > > On Tue, Sep 16, 2025, John Allen wrote:
> > > > > On Fri, Sep 12, 2025 at 04:23:07PM -0700, Sean Christopherson wrote:
> > > > > > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > > > > > index 0cd77a87dd84..0cd32df7b9b6 100644
> > > > > > --- a/arch/x86/kvm/svm/sev.c
> > > > > > +++ b/arch/x86/kvm/svm/sev.c
> > > > > > @@ -3306,6 +3306,9 @@ static void sev_es_sync_from_ghcb(struct vcpu_svm *svm)
> > > > > >  	if (kvm_ghcb_xcr0_is_valid(svm))
> > > > > >  		__kvm_set_xcr(vcpu, 0, kvm_ghcb_get_xcr0(ghcb));
> > > > > >  
> > > > > > +	if (kvm_ghcb_xss_is_valid(svm))
> > > > > > +		__kvm_emulate_msr_write(vcpu, MSR_IA32_XSS, kvm_ghcb_get_xss(ghcb));
> > > > > > +
> > > > > 
> > > > > It looks like this is the change that caused the selftest regression
> > > > > with sev-es. It's not yet clear to me what the problem is though.
> > > > 
> > > > Do you see any WARNs in the guest kernel log?
> > > > 
> > > > The most obvious potential bug is that KVM is missing a CPUID update, e.g. due
> > > > to dropping an XSS write, consuming stale data, not setting cpuid_dynamic_bits_dirty,
> > > > etc.  But AFAICT, CPUID.0xD.1.EBX (only thing that consumes the current XSS) is
> > > > only used by init_xstate_size(), and I would expect the guest kernel's sanity
> > > > checks in paranoid_xstate_size_valid() to yell if KVM botches CPUID emulation.
> > > 
> > > Yes, actually that looks to be the case:
> > > 
> > > [    0.463504] ------------[ cut here ]------------
> > > [    0.464443] XSAVE consistency problem: size 880 != kernel_size 840
> > > [    0.465445] WARNING: CPU: 0 PID: 0 at arch/x86/kernel/fpu/xstate.c:638 paranoid_xstate_size_valid+0x101/0x140
> > 
> > Can you run with the below printk tracing in the host (and optionally tracing in
> > the guest for its updates)?  Compile tested only.
> 
> Interesting, I see "Guest CPUID doesn't have XSAVES" times the number of
> cpus followed by "XSS already set to val = 0, eliding updates" times the
> number of cpus. This is with host tracing only. I can try with guest
> tracing too in the morning.

Ok, I think I see the problem. The cases above where we were seeing the
added print statements from kvm_set_msr_common were not situations where
we were going through the __kvm_emulate_msr_write via
sev_es_sync_from_ghcb. When we call __kvm_emulate_msr_write from this
context, we never end up getting to kvm_set_msr_common because we hit
the following statement at the top of svm_set_msr:

if (sev_es_prevent_msr_access(vcpu, msr))
	return vcpu->kvm->arch.has_protected_state ? -EINVAL : 0;

So I'm not sure if this would force using the original method of
directly setting arch.ia32_xss or if there's some additional handling
here that we need in this scenario to allow the msr access.

Thanks,
John

