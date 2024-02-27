Return-Path: <kvm+bounces-10114-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E45C86A003
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 20:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 04E1E1F244D3
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 19:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A80B51C4D;
	Tue, 27 Feb 2024 19:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="bdy8JbF4"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8B1EEDD;
	Tue, 27 Feb 2024 19:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.93.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709061578; cv=fail; b=Bh+CGphq1wekkNg1rpAYqAWVID+NtpHcWEBoklUOHYSz7vt3FHK8k3lq6L9Rml3UeSK8icmZU8ea6fH/YZ1mIWp2DmKFcrBTfZoULr8GADclRjH91vEOGFV4m4GMAJ0leklJSgIpsNkrcgGGHUwBxjpaD1Esbkdg71uG/c0RF/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709061578; c=relaxed/simple;
	bh=5YqG3YBaJx4o41YOAMST7PLu2vDq0ghvS1BWsN8GuFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=MVe0dAyabbO1E4V0dM6QwM2GgzbhZVKAXSMoilAPdVCFziet07/ovfJXAHOeiXacaKUTESV7FU8vjfPtlgq7o/5vPy6diWWyP0pQNt1m7Z583mdjdfUDze5lGNDBXW7QB73m05Kv/Xng8hcG84xjXcJNOwUb09P6uQ1nUxPoCFY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=bdy8JbF4; arc=fail smtp.client-ip=40.107.93.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vx3oGOfNAef46LD4E5VjSheRq/Q/fWjHZ+c7AHoPGx80sU5CZlFFl5wSN++DQld2G0+gVzC3EOiCOPh3ccFCcRumXZoIYL0EFM375iiU5QiBiekF0Z1F2cOCqew0kmVenT5LHvu/Fy9dJw1rQLU9p4AKVKBM3D/8dw0k+yvjOhvHl5xoqoTt7FX+F2VpOWhTR28LgE9s4WJ8BOHRPDpnRf9quGzz5OddFUwXQnDfWMUJIzVh7TONQh/opp/XbXIkG/TQowfuKlPY03jPDMGKv5NWuTdVgI0sOeGvcvaAiUxdaDON40ssPanvfBC6F6mkczOJm5I6Tzc31C0zYctejQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j+EKj1iqixDzqi2fza+ltuoqHPN4ilxD6c50jUklnyI=;
 b=ZTTWJdmuhpZddQ3Ltq0hubi6znMpSncTtt/V1aQSAt8CdIHqus0+VsHbxJZSusOVVLk/0sRE74RQZIYN/15w9LEzI0Jkn+um+e3etER5UFuckePbrQ3jvrQ2pF+w9imrr+BrvhqIjKj5oBOkd8NllLYvo5NrkNLfnyIm2Ske5Bma2P7iiO0JqKCXni3gD3yBto2lr3LlwsV56uJU4JUt52Ctzbzo6spZTZLgRy340MgIFPhsKIOY+1jUU0jIHCAJN9jBg1qP1qO22aM6FjQsEfwzutckFtf7PZWdWewpsGl18HakuqXdopkoP3e6KgzrP3khZIOYJO8sGYiz0tmRgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j+EKj1iqixDzqi2fza+ltuoqHPN4ilxD6c50jUklnyI=;
 b=bdy8JbF4XPQKFXRs3I90Vg03jtoi+8SFI+ajxxl7vDQcL0Cs3dsZzLJgUEayX5MI91SLddWOUsLJeGaId00in1CIP+FvqQq3h9y1M55++2T2o9o+kqX2dNVrTTZMcvjSB05brv0WCxEUxnFNxWn+PnYZDFTsCKskyj2Uu2QdCwQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by SN7PR12MB8145.namprd12.prod.outlook.com (2603:10b6:806:350::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.34; Tue, 27 Feb
 2024 19:19:33 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::319f:fe56:89b9:4638]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::319f:fe56:89b9:4638%5]) with mapi id 15.20.7316.035; Tue, 27 Feb 2024
 19:19:33 +0000
Date: Tue, 27 Feb 2024 13:19:28 -0600
From: John Allen <john.allen@amd.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
	weijiang.yang@intel.com, rick.p.edgecombe@intel.com, bp@alien8.de,
	pbonzini@redhat.com, mlevitsk@redhat.com,
	linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH v2 5/9] KVM: SVM: Rename vmplX_ssp -> plX_ssp
Message-ID: <Zd41wDpl4K6j+iU+@AUS-L1-JOHALLEN.amd.com>
References: <20240226213244.18441-1-john.allen@amd.com>
 <20240226213244.18441-6-john.allen@amd.com>
 <Zd4mf5Z1N4dFjFU7@google.com>
 <1f95281e-f8a9-4ff2-8959-162a192e48bd@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f95281e-f8a9-4ff2-8959-162a192e48bd@amd.com>
X-ClientProxiedBy: PH8PR21CA0011.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::19) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5995:EE_|SN7PR12MB8145:EE_
X-MS-Office365-Filtering-Correlation-Id: 0d232936-8686-47b4-1c36-08dc37c90761
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	hqvduF0MFKroogw1vFylbZACAJy1cKTVHYiqT0/0fEhZIa/PUY1Pkgv7Zyc4OdLU6eyi9FQeLpB/ksosnOUn6GNuHw4XU10UYbeXhR4iYFbe4PFyccSaBs0R7jAHsrjVX62FHBgvcsxtUjpVtgxtaCsdqXwJInMhCmdLS7d6FR9tOtTX23vcg8s2HfqcLG0OQG/VY2xYn5856EH3qhX1rBOI8PK9I4z/VYOOPlHD5B8J1KLBkRfeapnFfvJV1XE4SMqnl2uNhqc5dPTLXjLVNV1I3YN+mxS2j71Yx2NDUJdBzk7UmL8BJxgVeBVN2HH+TgYDqF+EA0LETpkWvtiSUXod7f9yMgsAJ6NBxUGmOgyX79Zp5Ti7SJDSEyhWKllyvsYRSMk7KQ4UPGgJSY8A6bWCWObhl3hyia+5p/MlOossDFHi/SkyVijUno8zQono8pSj6NaIW+Jb4MmVmEqIV/LjLuO/fVvfIkNUTKM4q1JfC3PLKllhoLp9Tc+WvxPiTkMDnhVUT9+37JJo+1/57XKMmyvBsaMuQYpeePcEn2v/7TCA+hxkxDkHGlPIjmlpgY9ggd8hM+LWIa0GsJIMDwTklovG0xj9xdIr3SsUYzVrwAho/eLVX1lSQIsSesIfSAUpcukIiOPZv+qHgKTW6A==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?9DEQ72yCnlM8Jzsv8wBJjVj/0fCrvDSdKB7T+eK2v7Yl1fUxiX/cSs8Llsny?=
 =?us-ascii?Q?W1HyRAEw06JDvhNccux0zWhjhhK7Vx+nAm1ZMiFi943MFV0a9YB4V81cBPsI?=
 =?us-ascii?Q?PEaquOxf+wJXLrEjI6+sgRLDzVnviG++Pbw1SY97O1ap6IgTaEZCTE7KHiQD?=
 =?us-ascii?Q?6OfObixwayeqhSm+CUdASMtA+ET1T5xht6Hmb1BHQ3ML89sirLzO1RUwokmF?=
 =?us-ascii?Q?rR1GZ2yZE4m2qg5zJxVj4LkgPQTy/Ro2Xm+Jwpcs4TH4/AynGOR4IAy4LVCK?=
 =?us-ascii?Q?PNCwDykRy3prL8FuSGfXI3XQMhpotPDVjZtkHRlo+D/KC83fCPcIcuLQL/PH?=
 =?us-ascii?Q?PThzYdCglKnX+QFigJv3/JUBKBatH1zcoYkf7w0ojDn3nucM7uwQYVH1/7eX?=
 =?us-ascii?Q?ek6ukJCE062uLVrUJC248I3MEa8hstMLCn9DBJ68t6MlUm1jR2zGBZgZjrl5?=
 =?us-ascii?Q?7W39MLuDTzqBv3YOW275A/kqNtQNH4RsyGtGmm5RTn1hV2O2XxF3GnxiAMDQ?=
 =?us-ascii?Q?2C0vgGbUo97o1t+ZZwumNgoBWRL9tcnd3/1kg2TNn2PT7SrtObFfjYB0v2ai?=
 =?us-ascii?Q?7F17tktnfAAczixnQ97XvVbkddWaaJ9qVnZl5SWLwmuRfxMTzoNbK2NNRwUA?=
 =?us-ascii?Q?HocTdcBzvyUKCLFIAnxyCkOEW3Gs7O/7LA0FHBnStydO+gcaqlWnJOgV0VWC?=
 =?us-ascii?Q?2TvkIpeQqwh/XzZP/7L+2dL/k4rwC4im4mKgL1WYgUpRnle4wo66+S7Mlm1k?=
 =?us-ascii?Q?zkltYmwLI+5JWbPGoU4FDCg/xW/vRrix1Jm8XDXdt/jn47yxRW7dT6yG+voR?=
 =?us-ascii?Q?ol8lPuZbINEPmKHE+DrO6FKQAxN9WvFlbHeBLOhtMgenbLGlQRsPFEG6IIOM?=
 =?us-ascii?Q?eUAnurVZWcyRH5FgFNTBwbo8fel+uDPjvOSoO63SwucMzLDiVn6JnjTCLj43?=
 =?us-ascii?Q?22A9JbVlv/UIssOssYkMfmPHZiMQTGgP2ijUHcYcD6W4yZ1VlFUBJk7jwSRF?=
 =?us-ascii?Q?s7dbUcpkUZMNxPV9NH8od6xSxB4gSthnqbzRncQa77P1ffxpqIyE0Mvp6xXS?=
 =?us-ascii?Q?kGyOrq2TLWwLLiW80CETK8CLRikVsnlAaCM2Y8xdJy5xCBPuBgVeohQ/KQXK?=
 =?us-ascii?Q?HtT97VmhlOPwq76/WCqeRTf1Z7CXDXdCgo0qyQW1fJWHBfaYoi7mc42Qy/Mn?=
 =?us-ascii?Q?hJli6lZCGiBUnFnVXKIFgZcoDq3QJwvb/Dse0J/+MSSD0Z8hEBKHVahDRuv6?=
 =?us-ascii?Q?rqdeqa9cfbu4ZgmUIyNm+DGY8yl/aSYFSCOUalMPl9xAVSVcL/ElZEltaOvB?=
 =?us-ascii?Q?NOxcFAx7cTeYdjMNU7YFPlFVCJ8IDvBTOqsyXiTCSv1cBzjC7woTkh7gaY1v?=
 =?us-ascii?Q?nuGgq+BUP5s08PwyhDpFQKNFWRsGatqRmyZD6jcaDANDm6AAaBm9HC7meFbe?=
 =?us-ascii?Q?Os0I+/fhyQh9ZipEd82qogriSWtyrsHP8v+Wg6qv2r325LsQKI3pVG+rgD7m?=
 =?us-ascii?Q?VRswrhwG9ZyH8fUv0oRHvLYKyVPXS0TLxzwT87d/MECFZIjDUJ2VqA6RI6Jo?=
 =?us-ascii?Q?xijrhCNzLqVsAvxsKV737bkJS5GSZWnSktsVHSJf?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d232936-8686-47b4-1c36-08dc37c90761
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 19:19:33.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Jo6fevhOetkZq4KurIg+K+9c1WXOXJ9ICAd2wuIxxe4MmxFX1cmXpc2Hs9jQZAfyZAsUfqBReiJSR5xhrxfeWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB8145

On Tue, Feb 27, 2024 at 01:15:09PM -0600, Tom Lendacky wrote:
> On 2/27/24 12:14, Sean Christopherson wrote:
> > On Mon, Feb 26, 2024, John Allen wrote:
> > > Rename SEV-ES save area SSP fields to be consistent with the APM.
> > > 
> > > Signed-off-by: John Allen <john.allen@amd.com>
> > > ---
> > >   arch/x86/include/asm/svm.h | 8 ++++----
> > >   1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > > index 87a7b917d30e..728c98175b9c 100644
> > > --- a/arch/x86/include/asm/svm.h
> > > +++ b/arch/x86/include/asm/svm.h
> > > @@ -358,10 +358,10 @@ struct sev_es_save_area {
> > >   	struct vmcb_seg ldtr;
> > >   	struct vmcb_seg idtr;
> > >   	struct vmcb_seg tr;
> > > -	u64 vmpl0_ssp;
> > > -	u64 vmpl1_ssp;
> > > -	u64 vmpl2_ssp;
> > > -	u64 vmpl3_ssp;
> > > +	u64 pl0_ssp;
> > > +	u64 pl1_ssp;
> > > +	u64 pl2_ssp;
> > > +	u64 pl3_ssp;
> > 
> > Are these CPL fields, or VMPL fields?  Presumably it's the former since this is
> > a single save area.  If so, the changelog should call that out, i.e. make it clear
> > that the current names are outright bugs.  If these somehow really are VMPL fields,
> > I would prefer to diverge from the APM, because pl[0..3] is way to ambiguous in
> > that case.
> 
> Definitely not VMPL fields...  I guess I had VMPL levels on my mind when I
> was typing those names.

FWIW, the patch that accessed these fields has been omitted in this
version so if we just want to correct the names of these fields, this
patch can be pulled in separately from this series.

Thanks,
John

> 
> Thanks,
> Tom
> 
> > 
> > It's borderline if they're CPL fields, but Intel calls them PL[0..3]_SSP, so I'm
> > much less inclined to diverge from two other things in that case.

