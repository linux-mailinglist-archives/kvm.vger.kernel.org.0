Return-Path: <kvm+bounces-1519-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E30B7E8D2C
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 23:46:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCC111F20F8A
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 22:46:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 987501DDDE;
	Sat, 11 Nov 2023 22:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hxt9JQqZ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2642D1B295
	for <kvm@vger.kernel.org>; Sat, 11 Nov 2023 22:46:03 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 221C2D8;
	Sat, 11 Nov 2023 14:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699742761; x=1731278761;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=saebH/49NP2Hdhe3OiJmpyYvdr3TGZcIIkmtojU07ko=;
  b=hxt9JQqZjJpviX+3M5zcLQV0dBsaxQpxZh2WQFD90YuOc6yr0Qbpz8nl
   tK+H2Vu0WnGvtpjqEpdyVBXBShm9Jh7RBp1H1CWQdxcNwYg+NqK8yfp3b
   R7Ntf9S3YtfTRyo2hwJf3pW/o5EhIIEtSlK5xXvto+Xd1nCKK1sV/2Q76
   VS58IIdg9biswumn99Xochb2BLxmKVWNjl+DxKwuEtA39uGm+o3/lgEvL
   xlWdbmfD3EksMxMA/8UbDPTC8V7KYyX/3s0RTQgWSy97cwWI0BuY3McYL
   hkibjBPpKFvNq4/L0v7gvHPTuMN34naRBLvc7HS3wHTeAx7cQ+naFPjhl
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="390107701"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="390107701"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2023 14:46:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10891"; a="937438576"
X-IronPort-AV: E=Sophos;i="6.03,296,1694761200"; 
   d="scan'208";a="937438576"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Nov 2023 14:46:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Sat, 11 Nov 2023 14:46:00 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Sat, 11 Nov 2023 14:46:00 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Sat, 11 Nov 2023 14:45:59 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+ewOMbWYziumSgTaKHSgTzTfzNlbczRgTg1Z9bKc9vS/4Y9TCm6CiKbyKUZM8KGSiaS8FdGfnB4jLd7gCXOjuFROsOH3iHHUKLPf1SSHX/f/WBL8NtpLkpxzdkqaHigUBl/9aKXqtJPViJzrpeN/GyNxz7yB6k4rtlu6VAfNdTnCRMAHCrB+r0UbGCvK1B5G1xFuvLvGOUAJVOxq5l1Fpghi97viy6SUJzaPWteNqcGSyXppW74eg57WUEKr2bKw9gCDhpAFAYhyh1fTVXtP1b8sGmoLtk/dyPCuU9b5lBicZYScbi8N6ucVg/7F5ezVssAvJOwGdhS5dQlEtjvwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WtLNQthtu/awFqWPDdCMHYrrh3xgGs234LZsoKqWUv4=;
 b=CbtzMkgWNWTBiVQsE/+Kk8MN9mpF7weDosQw1sQmh57/FqTxN0ONjmgrkaOcwITGyGeMHQ+051zRCtH57SjaS77/xrcmrBg7QHNb+U32Jqv3gxj+MDcoKQi3uWOhFsL0/aEfaxOmeNB/kaclQtkAcxdZ0DM+iObdPTis6TA652bIJTxTwf+VxwdKyuTR8lTfUHoTMoKvgEVLSjCgVj2t3hlwNaibfjKfJEM3aAlbTLIHpiLTcM23/sqVoQNnvoA8YpAfbhN19MfLvYxCf3DT9DfULYw1UGcJKa3ft9wxE01drR4WwTGbF6bc4qkOK1YmraHZyEJKp5QjK+n9NhdLhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DS0PR11MB7960.namprd11.prod.outlook.com (2603:10b6:8:fe::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.28; Sat, 11 Nov
 2023 22:45:57 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::a49a:5963:6db:77ce]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::a49a:5963:6db:77ce%5]) with mapi id 15.20.6977.019; Sat, 11 Nov 2023
 22:45:57 +0000
Date: Sat, 11 Nov 2023 14:45:54 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Alexey Kardashevskiy
	<aik@amd.com>
CC: Lukas Wunner <lukas@wunner.de>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-pci@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Jonathan Cameron <jic23@kernel.org>,
	<suzuki.poulose@arm.com>
Subject: Re: TDISP enablement
Message-ID: <655004226efd8_46f029452@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <20231101072717.GB25863@wunner.de>
 <20231101110551.00003896@Huawei.com>
 <4cfe829f-8373-4ff4-a963-3ee74fa39efe@amd.com>
 <20231103164404.00006e0b@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231103164404.00006e0b@Huawei.com>
X-ClientProxiedBy: MW4PR03CA0038.namprd03.prod.outlook.com
 (2603:10b6:303:8e::13) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DS0PR11MB7960:EE_
X-MS-Office365-Filtering-Correlation-Id: 8edfa6d3-cfe0-453a-49bb-08dbe307f7e6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +Sd/yFC0nDFGT+QJD/rtIoIabjjYxgDm/OphhsBSQMKHayz4Kj66/UIH983D4VvRDnSuootuGzZrbbpJG17twhIPJ2G9nKWaF1DSm9cXfRDLLHPwM8xl6Nc+m1EW0VJSmgPtxtuHjv+suW8/RzJsh8DJHjFyria3EW9ZQRjSBnkXAgxtB63LJuckMGPQM7SadrBLFWio8tJtq3ikJDa0Kw58JKRSrTePeT8vClvywLhFT79P22ntoPvoiR+8xZIO9GGNs9bhfPpSKkjLW67QQBM+n8BYd2lW1AVyW4rgpYkvSvZVuMEQbKC+FqmXPPIPfgxD5E19NL1u51vCgKAsc1X+78kSNVOo20EGMPw0QQjwIvc0iHed/GS+fOE0aZd0N5AmxGdYOG3lSaza9YSZ3ZheSGRtDuCrKQ7LxvUoeR/5ieZq+xg2pi9kT/ddRDa6/cIsMtYrof2frQu3QRf1ys3AqfstX6/v2ONBJ13YGixOxsZajUmYIn9LdkEOYGLNl78NHOSLDa34cIa6D8PRTPzIf4nJHavw5KaFE5Cn6nhzdxhLNUdAATjjbiEBVDHJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(396003)(346002)(376002)(366004)(39860400002)(230922051799003)(451199024)(64100799003)(186009)(1800799009)(66899024)(54906003)(66476007)(66556008)(66946007)(110136005)(38100700002)(82960400001)(86362001)(316002)(3480700007)(6512007)(9686003)(83380400001)(26005)(6666004)(6506007)(2906002)(478600001)(6486002)(5660300002)(41300700001)(8936002)(8676002)(4326008)(7116003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?UVh/Pe4za+LowxxRHsWA+TZFgSJBwS/1N8gWzIbaGdXL+vtHrWrEwnYMR4QJ?=
 =?us-ascii?Q?ano7fXkWw43/O5SUSR4k4NluHPK94F/Mxr9XNBrnfh14DuU9vTAp1dPvAQ6w?=
 =?us-ascii?Q?n6UcJUMe2XpMagkjx/D4XIavQ2kLSvJWbgc1tAN1Yf/R7DF/Y66BHqiAt5o1?=
 =?us-ascii?Q?gmzMliGKKd5yxYtfIKiXxecoohz5dqPPsaXM9A/qig8whKXQAISijo+RmW8N?=
 =?us-ascii?Q?aDEPBH8rzMdhNYiz41/ZMDi00h16xrNVh0tv7R4fHjd0h5H4JEno8T+ooshF?=
 =?us-ascii?Q?bLj9uavRtSY1jr8bRFm3LJS4szmK07OaLHkvSVJCQtVD6uatwEKTBKPlcBej?=
 =?us-ascii?Q?9saEX6cMX10qTkmk4m6+h3It3Re5v0m4zhXEuN1Ev+4Pf6NpFwI2YEIMe3IR?=
 =?us-ascii?Q?RPfKSkIild+T0BLzAWbV1/KIyjoU2ovzsWM/Ep5bPLciHGam5QT1KTPPlNbN?=
 =?us-ascii?Q?krq6KAkBNORD0Gtn7l5vCWHmesLgC8X8OqQfyHYnzKMUYS8+xQB7cLX/v6zj?=
 =?us-ascii?Q?KJUjlreTDTfOICvQsOgvvLzLmyyBGBl2pqp3+4KAjSvp6NUU6UUYqHiHgcJ8?=
 =?us-ascii?Q?6ZB7jtjGctj59TK7/ZA85ZipAipN5P1Q9LcRP/Oym/ulSdNF6OSQuzA4ipua?=
 =?us-ascii?Q?bqFCC1WuyGiFUy3fso2ye/N5Yc32X2tMbg5AUq+1a4lLPsh/eSnnNNKWO+Q6?=
 =?us-ascii?Q?fifistI8hsv/mLmIe2zLbODzD9nXN/oKSDcKqcwync18nfdftpl8CvKt6s0T?=
 =?us-ascii?Q?CrBV2vL4sSa0QSeKTFn11oO5bA096VWcWcoLaMk93Fgopy1iDeK+Y9bB3x3B?=
 =?us-ascii?Q?VKQgl5vFRV75X5E2P3RlOos4DlrYZKK7jT1Kdjb5xvlrs1iaAa9Tb2y9AEAd?=
 =?us-ascii?Q?DjrBfGFB4t09v9oborFMiZLzxRM2lQFvHPWXS7fubynRrirxAweG5V/No/kb?=
 =?us-ascii?Q?hGlAnr3zZCYJoCHq/fGopebLyVJopVn9QCbZAL/dnOsgmFctM68nszoSwlyH?=
 =?us-ascii?Q?Tu/f4Z6Zai5xpzi79XFdMbiLsFgX5VqhNOEfX4sV+Rz3OyvmfOqpGD7tnzCF?=
 =?us-ascii?Q?znP8FmWKqoHJA3btycopzFhAPeF7T9IDZDvhhpkJQEQVQ+kWtvH+yofjlSqM?=
 =?us-ascii?Q?8iQu48lA+UoCdNBfMxSeTgohsfVm/Lm1yxiqIsdLh2Q5pEXV/uA632PDFD81?=
 =?us-ascii?Q?2YVP50SSg9jPCrSch+QAKu87WnUdfaX6qtzGcFNK9fSwtOFY5qrbBnvwjNLj?=
 =?us-ascii?Q?GTLKgeEt43/oZrWjIJBIIFjJCJhGrsa3G1c1JDDEQajgnj06X9nMgdTeS3QH?=
 =?us-ascii?Q?F5j6nGyYDPvmP/x5ykQcHjPpk+XgEqhbJ9iPwY9vvtSRxBAZnIqYWMUH2yhk?=
 =?us-ascii?Q?KZ/iDdg/9lerZjMF5lHijNqSShQC5n78wbPLkKnntWZsgyuk5YOIP8P6Q+ae?=
 =?us-ascii?Q?fbaJOP6z7lFSeNu26f0ayfINBMNEItQyeFDemkscs/fqCz1DVQBaydZpr8Gl?=
 =?us-ascii?Q?yyjO+chPDSKZWgelAVbPPlYWRHgkBRisIEKghd50mMQ2qnbbutRdjb+GpnpO?=
 =?us-ascii?Q?mrTAS9e6khcwU6dS4mcjvK2FklAdsiMuDlBDOqbz1l2gsw9md45krgROg8Ck?=
 =?us-ascii?Q?gg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8edfa6d3-cfe0-453a-49bb-08dbe307f7e6
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2023 22:45:56.9174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yvm4HdtroHoUm6gtnpTAys7wqG2IuYgBx+Voyxi/kjU5iFY94TlbgLIhFArVaqdJH02Hy7Evkg0uYlCm2AyFTQtK2p0y12DreJ4htodsJaY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7960
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
>  
> > >>> - tdi_info - read measurements/certs/interface report;  
> > >>
> > >> Does this return cached cert chains and measurements from the device
> > >> or does it retrieve them anew?  (Measurements might have changed if
> > >> MEAS_FRESH_CAP is supported.)
> > >>
> > >>  
> > >>> If the user wants only CMA/SPDM, the Lukas'es patched will do that without
> > >>> the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
> > >>> sessions).  
> > >>
> > >> It can co-exist if the pci_cma_claim_ownership() library call
> > >> provided by patch 12/12 is invoked upon device_connect.
> > >>
> > >> It would seem advantageous if you could delay device_connect
> > >> until a device is actually passed through.  Then the OS can
> > >> initially authenticate and measure devices and the PSP takes
> > >> over when needed.  
> > > 
> > > Would that delay mean IDE isn't up - I think that wants to be
> > > available whether or not pass through is going on.
> > > 
> > > Given potential restrictions on IDE resources, I'd expect to see an explicit
> > > opt in from userspace on the host to start that process for a given
> > > device.  (udev rule or similar might kick it off for simple setups).
> > > 
> > > Would that work for the flows described?  
> > 
> > This would work but my (likely wrong) intention was also to run 
> > necessary setup in both host and guest at the same time before drivers 
> > probe devices. And while delaying it in the host is fine (well, for us 
> > in AMD, as we are aiming for CoCo/TDISP), in the guest this means less 
> > flexibility in enlightening the PCI subsystem and the guest driver: 
> > ideally (or at least initially) the driver is supposed to probe already 
> > enabled and verified device, as otherwise it has to do SWIOTLB until the 
> > userspace does the verification and kicks the driver to go proper direct 
> > DMA (or reload the driver?).
> 
> In the case of a guest getting a VF, there probably won't be any way for
> the kernel to run any native attestation anyway, so policy would have to
> rely on the CoCo paths. Kernel stuff Lukas has would just not try to attest
> or claim anything about it. If a VF has a CMA capable DOE instance
> then that's not there for IDE stuff at all, but for the guest to get
> direct measurements etc without PSP or anything else getting involved
> in which case the guest using that directly is a reasonable thing to do.

Is that a practical reality that VFs are going to implement CMA? My
expectation is CMA is a PF facility and the TSM retrieves measurements
for TDIs through that. At least that seems to be fundamental assumption
of the TDISP specification. Given config-cycles are always host-mediated
I expect guest CMA will always be a proxy whether it is is per-VF CMA
interface or not.

> 
> > 
> > > Next bit probably has holes...  Key is that a lot of the checks
> > > may fail, and it's up to host userspace policy to decide whether
> > > to proceed (other policy in the secure VM side of things obviously)
> > > 
> > > So my rough thinking is - for the two options (IDE / TDISP)
> > > 
> > > Comparing with Alexey's flow I think only real difference is that
> > > I call out explicit host userspace policy controls. I'd also like  
> > 
> > My imagination fails me :) What is the host supposed to do if the device 
> > verification fails/succeeds later, and how much later, and the device is 
> > a boot disk? Or is this userspace going to be limited to initramdisk? 
> > What is that thing which we are protecting against? Or it is for CUDA 
> > and such (which yeah, it can wait)?
> 
> There are a bunch of non obvious cases indeed.  Hence make it all policy.
> Though if you have a flow where verification is needed for boot disk and
> it fails (and policy says that's not acceptable) then bad luck you
> probably need to squirt a cert into your ramdisk or UEFI or similar.

It seems policy mechanisms should be incrementally added as clear need
for policy dictates, because that has ABI implications and
kernel-depedency-on-userpace expectations.

> > > to use similar interfaces to convey state to host userspace as
> > > per Lukas' existing approaches.  Sure there will also be in
> > > kernel interfaces for driver to get data if it knows what to do
> > > with it.  I'd also like to enable the non tdisp flow to handle
> > > IDE setup 'natively' if that's possible on particular hardware.
> > > 
> > > 1. Host has a go at CMA/SPDM. Policy might say that a failure here is
> > >     a failure in general so reject device - or it might decide it's up to
> > >     the PSP etc.   (userspace can see if it succeeded)
> > >     I'd argue host software can launch this at any time.  It will
> > >     be a denial of service attack but so are many other things the host
> > >     can do.  
> > 
> > Trying to visualize it in my head - policy is a kernel cmdline or module 
> > parameter?
> 
> Neither - it's bind not happening until userspace decides to kick it off.
> The module could provide it's own policy on top of this - so userspace
> could defer to that if it makes sense (so bind but rely on probe failing
> if policy not met).

udev module policy can already gate binding, its not clear new policy
mechanism is needed here.

> 
> > 
> > > 2. TDISP policy decision from host (userspace policy control)
> > >     Need to know end goal.  
> > 
> > /sys/bus/pci/devices/0000:11:22.3/tdisp ?
> 
> Maybe - I'm sure we'll bikeshed anything like that :)
> 
> > 
> > > 3. IDE opt in from userspace.  Policy decision.
> > >    - If not TDISP
> > >      - device_connect(IDE ONLY) - bunch of proxying in host OS.
> > >      - Cert chain and measurements presented to host, host can then check if
> > >        it is happy and expose for next policy decision.
> > >      - Hooks exposed for host to request more measurements, key refresh etc.
> > >        Idea being that the flow is host driven with PSP providing required
> > >        services.  If host can just do setup directly that's fine too.  
> > 
> > I'd expect the user to want IDE on from the very beginning, why wait to 
> > turn it on later? The question is rather if the user wants to panic() or 
> > warn() or block the device if IDE setup failed.
> 
> There are some concerns about being able to support enough selective IDE streams.
> Might turn out to be a false concern (I've not yet got visibility of enough
> implementations to be able to tell).
> Also (as I understand it as a software guy) IDE has a significant performance
> and power cost (and for CXL at least there are various trade offs and options
> you can enable depending on security model and device features).
> 
> There is "talk" of people turning IDE off if they can cope without it and only
> enabling for CoCo (and possibly selectively doing that as well)

Agree, IDE stream resource allocation is something an admin needs to be
able to reason about.

> > >    - If TDISP (technically you can run tdisp from host, but lets assume
> > >      for now no one wants to do that? (yet)).
> > >      - device_connect(TDISP) - bunch of proxying in host OS.
> > >      - Cert chain and measurements presented to host, host can then check if
> > >        it is happy and expose for next policy decision.  
> > 
> > On AMD SEV TIO the TDISP setup happens in "tdi_bind" when the device is 
> > about to be passed through which is when QEMU (==userspace) starts.
> Ah. Ok.
> 
> > 
> > > 
> > > 4. Flow after this depends on early or late binding (lockdown)
> > >     but could load driver at this point.  Userspace policy.
> > >     tdi-bind etc.  
> > 
> > Not sure I follow this. A host or guest driver?
> 
> Hmm - I confess I'm confusing myself now.
> 
> At this stage we just have enough info to load a driver for the PF because
> to get to state we want locked prior to VF assignment the PF driver may
> have some configuration to do.
> 
> If all that goes well and the TDI can be moved to locked state, and assigned
> to a TVM which then has to decide to issue tdi_validate before binding
> the guest driver (which I assume is the TDISP START_INTERFACE_REQUEST
> bit of the state machine).

Locked before assignment is valid, but lock after assignment (upon guest
wanting to transition a TDI or recover a TDI after an error) is likely
one of the first incremental features to add after a baseline is
established.

> Or is the guest driver ever needed before this
> transition? (I see you called it out as not, but is it always a one time
> thing on driver load or can that decision change without unbind/bind
> of driver?)

For whole device passthrough it may be the case that the guest needs to
do some operations with the device in shared mode before taking it
private.

> I know this gets more complex for the PF pass through cases where the
> driver needs to load and do some setup before you can lock down the device
> but do people have that requirement for VFs? If they do it feels like
> device was designed wrong to me...

Agree, because in the full device passthrough case I expect the PF
driver to just be generic vfio-pci.

> Too many specs (some of which provide too many ways you 'could' do it)
> so I may well have a bunch of this wrong :(

This is why I think we pick one painfully simple use case to enable
first and then incrementally build on it with concrete rationales.

