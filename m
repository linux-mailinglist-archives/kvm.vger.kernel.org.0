Return-Path: <kvm+bounces-1505-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 82F4D7E86A0
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:38:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 204BB280F65
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:38:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE10E3D982;
	Fri, 10 Nov 2023 23:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m6o2/LH8"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE72A20308
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:38:49 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB8F125;
	Fri, 10 Nov 2023 15:38:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699659528; x=1731195528;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=p2upYPrgqKbUUs2bQwhabeX/C52OMHNgGYfbSPWNeGs=;
  b=m6o2/LH81BotAP6PfdDjDSvyI9D3E6sRzu18ZisYxHu9QWGn9ISW84Vn
   1Xc2LUmnMh1SAiH0Yimz94OsB7J+p9hc9UGTg7f7g0LtXV8tc1GRVRLD8
   cu/rKWib4CB9qChj8ffxXwlWr7neBhs1+k7koeqeYTCJ84Q21QoC2lJnI
   sfWDkyApJvXfvgqt1ofBeWHxS9fcB8qoroIuOI+TfrXIsN8FWRk0dk+9g
   aIdP4UWwCJ1Q91TScUeZg9VxLq5ZCajb42lEiYo6AxPi7K1Fsb6xij7oW
   4/mK7ZjAM0bA3r6xYa241Mx77GafeeR0V0CtjPnsLVMC29eHSn/5bJjrX
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="476470053"
X-IronPort-AV: E=Sophos;i="6.03,293,1694761200"; 
   d="scan'208";a="476470053"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 15:38:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="740262757"
X-IronPort-AV: E=Sophos;i="6.03,293,1694761200"; 
   d="scan'208";a="740262757"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga006.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Nov 2023 15:38:47 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 10 Nov 2023 15:38:46 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 10 Nov 2023 15:38:46 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 10 Nov 2023 15:38:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JC+BeSBfjpRv4XJZ0p4c5pAEZu+dR8wfouxBQzoCLvFkvsONhUh/ngrg7eEfIKYRku2jSpsWpBk/19x7eFM8RKrs6022zZyrLDx6J7XAolLBx88ZVJtwPeEJugnzbB+dN1GwI3Mrb2G0UtpUhQfmGlnjdUi6kvzUcYZN6o8Is5nNNVhMnUPHaJvCRmgo0MmB186j62hU0Ti3whe+MeL2U48Ghjuv1kPPF+nHcRd8SYv1IhccuCkcr7fVFiZMJtv5Cw004MBxvE82Nv/WXIJ5tHwGlClwV56nHU+BfKGPTbxQ6pNQGbzn0evzQSjREV43Zdez6GpNUWmoAmqX/qTT2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNrK87Z0Mf1VRkgkvcLSKzC7zm58kdV5BkwM+X7GP3Q=;
 b=ZVTEACA7ocMTZEzL93UpUXkOChrrOlKWgPcw7Lpxr2qzeBgbqLR4S4YEThrn0M8QuWK5GWxHO3QWCK+rRVW/DnlHiQm7T+TTAbObtr/O8rBM5++jJLpU4hZfSHrj1oL7geqFglSpKO8ETmd6Ub2xGlBXJMLop8JRB/4g5a8o1fPFCZhMYWC4wX2f3FV/xm2O0TeYGPP+sGcQdRVDJz5DoyA/yEYrRMyj/TXfXTX1l72+Vaig2y6VmN4aNOazGNJxurSPCOtQh2a5WRlZFgPNoSljls3+/5JvS5F9qDoG7SUnHcguMFU2G5xh9eIfIQcyc9VnmRokGdRcubfAyGfhKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by CH0PR11MB5522.namprd11.prod.outlook.com (2603:10b6:610:d5::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.19; Fri, 10 Nov
 2023 23:38:43 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::a49a:5963:6db:77ce]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::a49a:5963:6db:77ce%5]) with mapi id 15.20.6977.019; Fri, 10 Nov 2023
 23:38:43 +0000
Date: Fri, 10 Nov 2023 15:38:41 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Alexey Kardashevskiy <aik@amd.com>, Jonathan Cameron
	<Jonathan.Cameron@huawei.com>, Lukas Wunner <lukas@wunner.de>
CC: <linux-coco@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-pci@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jic23@kernel.org>, <suzuki.poulose@arm.com>
Subject: Re: TDISP enablement
Message-ID: <654ebf012ecc0_46f0294e6@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <20231101072717.GB25863@wunner.de>
 <20231101110551.00003896@Huawei.com>
 <4cfe829f-8373-4ff4-a963-3ee74fa39efe@amd.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4cfe829f-8373-4ff4-a963-3ee74fa39efe@amd.com>
X-ClientProxiedBy: MW4PR04CA0036.namprd04.prod.outlook.com
 (2603:10b6:303:6a::11) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|CH0PR11MB5522:EE_
X-MS-Office365-Filtering-Correlation-Id: 90988b51-005d-4f23-8039-08dbe2462cf5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3QphjPATKCinLIWTvX+Sfsg5TopcIUHUxuwC9HOGr0UDqVz05WaWtzjcP0jZxtmCveLDO2hsduqiQJ95KrLvD7Gqw4ORKDlvV8lQWAUjUxlfDRnoQ3m2JrAQlTkQMvUYwtBjNpgOhXZv0oR/mGYz/wm76sy5ToOAALmoWLcV2wNwdZsMHpeB++tvQDM9uT+gWnuEPhwGQifj/WsIKFYq6UDAwzZy9Mq7h5pQ84RZsrshr/LpqRQLBgYNmoO+Ku761xtaZx4KtlNYpsXxOjqJrtlDDul6+30z2qgqD/36QSsBL9c3IU057DEIUAt/tc4jDI3XIP/BCpQpQbElOx1Cd2bStLq5GKK8TFnk5DpS7vSTDGdCRyJvc23ay4lgdVcxRvIPmyDqnFdDAZ8TkgZWc/StK2WESkZ8+nc/rL5BXE3HK32Tv+QPlMxSQNcJr86TAs9MTNS7W6/pe/LqkF3jj4mVuKvSwFhpQvNtejVlezTOeBhAMbpat8RvJYQvGW39y6rju21lecw8JXQkWCzXeum/3xOHJFRQ3kGf79ksUqNxI5lEj7avjz0aIhTu9asv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(39860400002)(376002)(366004)(346002)(136003)(230922051799003)(186009)(1800799009)(451199024)(64100799003)(6506007)(6512007)(6486002)(478600001)(9686003)(4326008)(83380400001)(66476007)(66556008)(66946007)(5660300002)(41300700001)(54906003)(316002)(8936002)(8676002)(2906002)(7116003)(82960400001)(38100700002)(3480700007)(86362001)(110136005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GdXRR9/XFbZleaJsQnTrqVfPAIdnGDlKkztj7IJql9TZfYo+I7JK33ZidH2M?=
 =?us-ascii?Q?S5JE33uAm4+ekBxEspqzfqIZUgnW62NwK61mDGYkcpFeWZHguEqj6zd5KXr8?=
 =?us-ascii?Q?OR2Tvs8r404aJl9Rkf11c8yhs6OjoAbfXgxYfvsF3T1Ofx8e9dMUyYBD2zSQ?=
 =?us-ascii?Q?FOJuBUC110TzfvYoWENJvw5z3/UwN3/nJ5yLp+YgeUSmVRNbVoEGyTm3RkRe?=
 =?us-ascii?Q?SCADsViaewCjzMeAuMj4PawGPDHHOflfwB9VSI4tw03lSOzy83kLV5FNTpJn?=
 =?us-ascii?Q?HF/nZccp/tqnrNsKfZnkUu6AvaSj+yfzMFAtIEAHiGl9MFl+eZh4T9BWdWvY?=
 =?us-ascii?Q?+R1DWkKNI/gMZHbBkYTXKRU1/aC/bjVldtLIlKJJYCjH5aomb9z/kvfgZeqe?=
 =?us-ascii?Q?B312+XaMIMfaXXJazE3i+jro4cP0549ZGBu3TvlfBjCago/eW5LeOZl3VC2b?=
 =?us-ascii?Q?hWG1Ou0AYvcaVuN/Hovj0g33aa5ksOH5XQxJqp6Q/DVsgYfk7ipweNPCr2D0?=
 =?us-ascii?Q?pcworGKetofu48H6/RFElbjjCX0WPEB9u4Oipk4QcrHVi4RPfD3NYkpgm31R?=
 =?us-ascii?Q?j8wkV5M978oyWQbe6AiszP2/ateM2hxpiwqHA6UAyZcECscABxO+fWBI6HdC?=
 =?us-ascii?Q?A88vFNIxK9Nz6+FOFIeLaP8NkkHfv0WE5ICYrWRzE7A81D5oIpVqc49cK4xm?=
 =?us-ascii?Q?PlY5XGGX281/d6w9fb/Kh09u0N1nUYmZAEgV0jrznlvattYWw8s3jrefqN/T?=
 =?us-ascii?Q?aL3sLusE8VY2FBBQciz4ppZe6/blw9CR2m2DSR/4KLlR3CssUSANL3k1ODVU?=
 =?us-ascii?Q?sEcvJB3S4u+KVPVnYOQsO4xBbIamn9l/l/tQ1/rqutmOqqlKEbX7KQgFoev1?=
 =?us-ascii?Q?rMaw3+eYr7GUqFgnw+3jD2P91Zr6GzN6YjMxUiELTORLLHz0Uue4hDfOkVyG?=
 =?us-ascii?Q?kh8Q7NE+NwfiaxV1gRS66w4F0VKLNBHxcZF7f+qYQ4bg2Y8yeAfWrKvff+CX?=
 =?us-ascii?Q?1zmTlKLfIkdZ2+kqa4Mw/Kq30h8xhr4TzKdpHIevsPF/JYQjJB0PuptsALxZ?=
 =?us-ascii?Q?pDAWalGQwCRVNLfbJe9+Fkjl7IhxBJEh4faeS2CagFA0UO2J6ohK15rO+bZk?=
 =?us-ascii?Q?m7KYGfC/CivdczHTTwJ1yXS5DAxi6DD8hPCKC+0r+9wFKZZYbbxhslXwkRqE?=
 =?us-ascii?Q?0IyaHxy3YjhUhi6jmMW/M2tf9xXEaKXM+x6L0CaTnZMtTysfwllvoKmO9Zht?=
 =?us-ascii?Q?7eayFvenH2PMWCqhR3n6QMWVgrIMdHrG/NdxqHHabNebqfr24b3I/EslGTzU?=
 =?us-ascii?Q?/SLSBpR0TUp0BwoMMKR3EeM61ZOM2TWhJHd6enw7MsdWVVPU+vLYiue68hlq?=
 =?us-ascii?Q?kyuT00JGclH4h0bQ9y1HJoSDAn+CXG3/zqEUpfav8tFfaew5IhkQqZKcfK1l?=
 =?us-ascii?Q?RjY4qX9iSJzVi009pdIXc8HhJMyTp3WePpX0GvKc3N/MI6LvhAlsmchsUgxh?=
 =?us-ascii?Q?csrSVjQcFppM1q7/CPS8kathHZQQuAALU6rOu5LWqQ3EuICKzX48HnCtLqOH?=
 =?us-ascii?Q?oYuKAJCgyV525bC2bYc03cG7muPwDiOgPksyiBA+B7qnimacvSCWncpSL1sQ?=
 =?us-ascii?Q?fZPKz4oc18jZawrpqdP6K88c5asV2mG8booLzS3jvLFoVonkGaf26IYto0V+?=
 =?us-ascii?Q?MK6L2A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90988b51-005d-4f23-8039-08dbe2462cf5
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2023 23:38:43.5231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NYctTkWVpgTHTkMQptnc7/1nMwqev2DaUAPJsN8PgArlVSX21Xz0atUqQ1RAQGRk6LqfZd4TsOMPFQeRyYj1HNiroiVOCcQCWq72fmXbN8w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5522
X-OriginatorOrg: intel.com

Alexey Kardashevskiy wrote:
[..]
> > Next bit probably has holes...  Key is that a lot of the checks
> > may fail, and it's up to host userspace policy to decide whether
> > to proceed (other policy in the secure VM side of things obviously)
> > 
> > So my rough thinking is - for the two options (IDE / TDISP)
> > 
> > Comparing with Alexey's flow I think only real difference is that
> > I call out explicit host userspace policy controls. I'd also like
> 
> My imagination fails me :) What is the host supposed to do if the device 
> verification fails/succeeds later, and how much later, and the device is 
> a boot disk? Or is this userspace going to be limited to initramdisk? 
> What is that thing which we are protecting against? Or it is for CUDA 
> and such (which yeah, it can wait)?
> 
> > to use similar interfaces to convey state to host userspace as
> > per Lukas' existing approaches.  Sure there will also be in
> > kernel interfaces for driver to get data if it knows what to do
> > with it.  I'd also like to enable the non tdisp flow to handle
> > IDE setup 'natively' if that's possible on particular hardware.
> > 
> > 1. Host has a go at CMA/SPDM. Policy might say that a failure here is
> >     a failure in general so reject device - or it might decide it's up to
> >     the PSP etc.   (userspace can see if it succeeded)
> >     I'd argue host software can launch this at any time.  It will
> >     be a denial of service attack but so are many other things the host
> >     can do.
> 
> Trying to visualize it in my head - policy is a kernel cmdline or module 
> parameter?
> 
> > 2. TDISP policy decision from host (userspace policy control)
> >     Need to know end goal.
> 
> /sys/bus/pci/devices/0000:11:22.3/tdisp ?
> 
> > 3. IDE opt in from userspace.  Policy decision.
> >    - If not TDISP
> >      - device_connect(IDE ONLY) - bunch of proxying in host OS.
> >      - Cert chain and measurements presented to host, host can then check if
> >        it is happy and expose for next policy decision.
> >      - Hooks exposed for host to request more measurements, key refresh etc.
> >        Idea being that the flow is host driven with PSP providing required
> >        services.  If host can just do setup directly that's fine too.
> 
> I'd expect the user to want IDE on from the very beginning, why wait to 
> turn it on later? The question is rather if the user wants to panic() or 
> warn() or block the device if IDE setup failed.

Right, but when you run out of streams where is the policy to decide who
wins. That's why I was thinking lazy IDE when it is explicitly requested 
> 
> >    - If TDISP (technically you can run tdisp from host, but lets assume
> >      for now no one wants to do that? (yet)).
> >      - device_connect(TDISP) - bunch of proxying in host OS.
> >      - Cert chain and measurements presented to host, host can then check if
> >        it is happy and expose for next policy decision.
> 
> On AMD SEV TIO the TDISP setup happens in "tdi_bind" when the device is 
> about to be passed through which is when QEMU (==userspace) starts.
> 
> > 
> > 4. Flow after this depends on early or late binding (lockdown)
> >     but could load driver at this point.  Userspace policy.
> >     tdi-bind etc.
> 
> Not sure I follow this. A host or guest driver?
> 
> 
> >>
> >>> If the user wants only IDE, the AMD PSP's device_connect needs to be called
> >>> and the host OS does not get to know the IDE keys. Other vendors allow
> >>> programming IDE keys to the RC on the baremetal, and this also may co-exist
> >>> with a TSM running outside of Linux - the host still manages trafic classes
> >>> and streams.
> >>
> >> I'm wondering if your implementation is spec compliant:
> >>
> >> PCIe r6.1 sec 6.33.3 says that "It is permitted for a Root Complex
> >> to [...] use implementation specific key management."  But "For
> >> Endpoint Functions, [...] Function 0 must implement [...]
> >> the IDE key management (IDE_KM) protocol as a Responder."
> >>
> >> So the keys need to be programmed into the endpoint using IDE_KM
> >> but for the Root Port it's permitted to use implementation-specific
> >> means.
> >>
> >> The keys for the endpoint and Root Port are the same because this
> >> is symmetric encryption.
> >>
> >> If the keys are internal to the PSP, the kernel can't program the
> >> keys into the endpoint using IDE_KM.  So your implementation precludes
> >> IDE setup by the host OS kernel.
> > 
> > Proxy the CMA messages through the host OS. Doesn't mean host has
> > visibility of the keys or certs.  So indeed, the actual setup isn't being done
> > by the host kernel, but rather by it requesting the 'blob' to send
> > to the CMA DOE from PSP.
> > 
> > By my reading that's a bit inelegant but I don't see it being a break
> > with the specification.
> > 
> >>
> >> device_connect is meant to be used for TDISP, i.e. with devices which
> >> have the TEE-IO Supported bit set in the Device Capabilities Register.
> >>
> >> What are you going to do with IDE-capable devices which have that bit
> >> cleared?  Are they unsupported by your implementation?
> >>
> >> It seems to me an architecture cannot claim IDE compliance if it's
> >> limited to TEE-IO capable devices, which might only be a subset of
> >> the available products.
> > 
> > Agreed.  If can request the PSP does a non TDISP IDE setup then
> > I think we are fine.  If not then indeed usecases are limited and
> > meh, it might be a spec compliance issue but I suspect not as
> > TDISP has a note at the top that says:
> > 
> > "Although it is permitted (and generally expected) that TDIs will
> > be implemented such that they can be assigned to Legacy VMs, such
> > use is not the focus of TDISP."
> > 
> > Which rather implies that devices that don't support other usecases
> > are allowed.
> > 
> >>
> >>
> >>> The next steps:
> >>> - expose blobs via configfs (like Dan did configfs-tsm);
> >>> - s/tdisp.ko/coco.ko/;
q> >>> - ask the audience - what is missing to make it reusable for other vendors
> >>> and uses?
> >>
> >> I intend to expose measurements in sysfs in a measurements/ directory
> >> below each CMA-capable device's directory.  There are products coming
> >> to the market which support only CMA and are not interested in IDE or
> >> TISP.  When bringing up TDISP, measurements received as part of an
> >> interface report must be exposed in the same way so that user space
> >> tooling which evaluates the measurememt works both with TEE-IO capable
> >> and incapable products.  This could be achieved by fetching measurements
> >> from the interface report instead of via SPDM when TDISP is in use.
> > 
> > Absolutely agree on this and superficially it feels like this should not
> > be hard to hook up.
> 
> True. sysfs it is then. Thanks,
> 
> > 
> > There will also be paths where a driver wants to see the measurement report
> > but that should also be easy enough to enable.
> > 
> > Jonathan
> >>
> >> Thanks,
> >>
> >> Lukas
> >>
> > 
> 
> -- 
> Alexey
> 
> 



