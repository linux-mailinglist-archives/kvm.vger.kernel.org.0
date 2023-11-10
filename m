Return-Path: <kvm+bounces-1503-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 330647E869C
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:31:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 85F61B20DA9
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFAE3D980;
	Fri, 10 Nov 2023 23:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g+7t4y+r"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E2E3D969
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:31:28 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28753125;
	Fri, 10 Nov 2023 15:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699659086; x=1731195086;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Fb4mv4xckn+yg2yTLIgQ+Y0WGPVsKqJWZWQLsBf4VnE=;
  b=g+7t4y+r85DGgO8aKeBhcTj/rPa0IIZpYHtqz/U1ttzgA4Qw/XnlvHtQ
   UT7XtlN9GUZJRuIdWfQy2NtFu2UvSUVAAPOYflITXe6xnEwUkFWPB5WbD
   tH0W1uZLXku4AA81XcSYqPCFZa0Sq1uAhYVl+K3rCZH8Sv+BXz9UxVh8b
   Q/Vw1DqGuOeQ6jTwlroHAgiMEUiVgrLYiRh8b3vJ5reytnC5TqG8efd2k
   sPKeZhowDKvX9MGq+quPvAQLaUfEhCuMTC+wya42YYAtvozZRc28sUjum
   9GOc/r+VsNBjibxB7cGTuCA6ynoQfjcREhinugnDPhwBQbttMvALNJ6CI
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="8891980"
X-IronPort-AV: E=Sophos;i="6.03,293,1694761200"; 
   d="scan'208";a="8891980"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Nov 2023 15:31:26 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10890"; a="713739911"
X-IronPort-AV: E=Sophos;i="6.03,293,1694761200"; 
   d="scan'208";a="713739911"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Nov 2023 15:31:25 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 10 Nov 2023 15:31:24 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34; Fri, 10 Nov 2023 15:31:24 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.34 via Frontend Transport; Fri, 10 Nov 2023 15:31:24 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.169)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.34; Fri, 10 Nov 2023 15:31:02 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAExjjvThq5kjTWmZxJ+BhyCoaorY7xraRgSvVpjHz7igMY+/6W9U0L6BaF/BLg9nyqluqYUNG9wd83G4ZAtGKbJsjUedpZZNLH4uI2ArVNZSVV6NpCv/lwQze3zuEcEJAswSOvGooRg12bcv3lWXWK2wZ/yxXyNd/q+xWLXN5jXN6WVI60IGG+snupF4kdf+FOFW9ALdLdKs2DqCDVZR8hQecJGPCS28nncVLPbRx51ANi15tYCOLcAgOj/8vGRVUgmAuPGRKZqPSiMAyn2SrmqV1MNR6woFAv7eWePGz6O3CEWi2V3HGBuXf2/VueRR/TOn6ig98CxVytEhkt1Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gvCcxB9jr2DzmSDSC5Vcn8thAH2F7r7Fvos9UpeZZrA=;
 b=JyoI134SWhPN/P3ddgoBaWhLAGOGEbT11J7P2rnvyhf/nf0h50m6kkFMuX7Hwq8JCuj9hFD0wPQilV9hYkioWu1P7NHqTQdOihgMyt1EgmTEIZclaAcRFnFvvY2qgHv0yE9FMz84DjpktxomuR6Swmc+B0XDvrgiS+hL+7d217/XlSF8ai4YJ1uJrnywLqTXVeoVbmX8hQ6T/kOqB1Wc5zJzCtMaj6dD30OxuiRbzZ0OYt0NDIcTa2HZ56tUHUw4HjLFFgZOYcmnqkHqk5ET3qqvq3uAF70PNlmyk9e4y4K543xJzhVNT5qg8866PnzSInpu9smFqusTMxG2rKTCWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM4PR11MB5454.namprd11.prod.outlook.com (2603:10b6:5:399::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Fri, 10 Nov
 2023 23:31:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::a49a:5963:6db:77ce]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::a49a:5963:6db:77ce%5]) with mapi id 15.20.6977.019; Fri, 10 Nov 2023
 23:31:00 +0000
Date: Fri, 10 Nov 2023 15:30:57 -0800
From: Dan Williams <dan.j.williams@intel.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, Lukas Wunner
	<lukas@wunner.de>
CC: Alexey Kardashevskiy <aik@amd.com>, <linux-coco@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-pci@vger.kernel.org>, Dan Williams
	<dan.j.williams@intel.com>, Jonathan Cameron <jic23@kernel.org>,
	<suzuki.poulose@arm.com>
Subject: Re: TDISP enablement
Message-ID: <654ebd31be94a_46f0294a5@dwillia2-mobl3.amr.corp.intel.com.notmuch>
References: <e05eafd8-04b3-4953-8bca-dc321c1a60b9@amd.com>
 <20231101072717.GB25863@wunner.de>
 <20231101110551.00003896@Huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20231101110551.00003896@Huawei.com>
X-ClientProxiedBy: MW4PR04CA0340.namprd04.prod.outlook.com
 (2603:10b6:303:8a::15) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM4PR11MB5454:EE_
X-MS-Office365-Filtering-Correlation-Id: cdaf16e9-387d-4a93-1640-08dbe24518ca
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CXWK+ft9LgVU/zXd6aA6A0jtU5cX7KP4+nmRzbhTY+S8vragNpXQAGnQNGtlo//UjJp/N+zoohrkj4eSUG8QqIHRYOpEFJ+gqp0YTOVDtFXYJ9drSANb/XUbKJ0dud1Z/NOklMTpdN1nwux32+7y1c2S/EawZFnNNkOlnlPF6lD7al55V/xBWv5h0bUmkO7M8b4TjC/GkFFYIj4boS/JqEgsVmAg6ImXovL9VdaT0wdp/oQnnzBOgXpKyK2ES3MYJJ/jVmU9BGpFRproxOQQTLEtSl70EV5kj0SFA4vg1nlxWECgWwgXoduYRv4x2oEXF7kXnSwQra07mXAu1rnNuw7iPuY94fOQDPak0X6pn70FbMk3zsREyA6gkhKkEGRHpJdT6vIazHJoxyxiBTG+QRSgKoJ7Jb5gl24IF9GKI/5MGYo1h4vALbArmAZ7KUbdj2+YTw3WkEiNoWP+TaTWImfn5ALHJXCj8AMjGsFgQLUq2m1vYe+DDKncCvWJeFwjqVxqbGBNr0Ix0Wln6xVZB3SraAxbDuG5FPOEsxnrZ+GTNzronbaVG9RPVspuuKKO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(366004)(39860400002)(346002)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(9686003)(2906002)(3480700007)(110136005)(66476007)(66556008)(66946007)(316002)(6486002)(4326008)(8936002)(478600001)(7116003)(6512007)(54906003)(83380400001)(8676002)(41300700001)(86362001)(82960400001)(38100700002)(6506007)(5660300002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z3niiK4mVwi0RlbAC1EXpZAIWmsEUdFW/KMIPkOAkL6+5fQbJLU1jBA6992q?=
 =?us-ascii?Q?O2Ayq08QPxf05KhKI2kiJGtb5hPGmqmyc1voLx4tcS/Y2n8IoVMhqxNqt/Bx?=
 =?us-ascii?Q?SynSWzKmkAu69kmh2mCruD8DBd8vMtcOtIS++2dj+1uxgnICUAttaFxfuHvk?=
 =?us-ascii?Q?FrU68rZHfjRUGOd8xr9F56d8XZKMOyKTp1xqvRfOswPH7gJp701N2jl6vCrZ?=
 =?us-ascii?Q?PMp4DpJkgNx9OPnYgVR4xpohYsT8a+961g5Pdul0rfn1ct/c/fD/uXgGWsUl?=
 =?us-ascii?Q?4zOwU8NOtv/W0NosCwyC2IM14/SPJ/rx/tVPvPQIWbrr6ysFNkfW0EGewkKW?=
 =?us-ascii?Q?uoOSHJZzpweTh28+kRYMSxeISG8RylrPhF2eILTrftD10vNKtQAKIbAVU1kl?=
 =?us-ascii?Q?lcD4w9fvQSdKTAh+KYC86jqT/RKTkQ6jJCMbxOB7ts1yeM6H7nluOi7qYQd1?=
 =?us-ascii?Q?tru4lQJ+Oovda0s90DEcfCeZ6gL4+hTP27n8qmvcMWiWB5ANiz6UlvwletEp?=
 =?us-ascii?Q?89iiWvfW8ORgwOqIdrBBjtC+ESqJ9QRkJBJhbQalx3wqNJl2WofCjCEnGehn?=
 =?us-ascii?Q?sYCCdas9jhsh4qAe9BhOeOdRZ8S2PHjOzi+gpXqeZx8sTaSrJl6Jxh1lDcCq?=
 =?us-ascii?Q?b7+eFWE7sODhz1HlUUSs4IqVRnLebwfspbb6j+lSNQhSxDjN3s5TXpjtR8HX?=
 =?us-ascii?Q?hrYTmbtYw1LFI87AEyTitdGHtlPmbUuyaWtfm/sAO36gmgwFUoUm68KuofcD?=
 =?us-ascii?Q?aTLbJos6GEwRxzIF1k4FZaa2HRld5jWc/EwAcHgx0DAbFZxI1YQOKXmtnVt+?=
 =?us-ascii?Q?7ZePvkaEP/VT7OzBBd5X6sQzUnbde0gI5wT2ukRUwb3/vJW0BOv3NGHdHV/K?=
 =?us-ascii?Q?+zcBJ/6CNgi0Hw5WrtNgXnUYfpe5s2kgDSDhvuaLoMnbaAvOs4R1cVMIBw1k?=
 =?us-ascii?Q?Cxbl0UgqMxKzadhimtvhos8fvI0jMbXR1ULUUmnd5NGLaW7NQDTVuxKbjBGG?=
 =?us-ascii?Q?iUpgBlxnVLHj9RTt9zGiACczqEB9EKVZP7L822raGj6MAvhIMVtU6Z990XCB?=
 =?us-ascii?Q?OW+hchxzGveyGwOUbnRN6yqpNHpIs2sbeiIuT3W2eac1Xti7TXb8z2+vZO9/?=
 =?us-ascii?Q?oTRMBY0d/iCsQpK9EvNangtndzw0fPRX1z1GbdKFM0ZUvG/YDbz2pBkUyz68?=
 =?us-ascii?Q?HVvvMC1oI18DKdDpgORueYIq8UtmBtIGzrGU97nopkSNaHJmodgxAv9FQ3tJ?=
 =?us-ascii?Q?3cQD6eTBkIbqP99Zae6LI4cy8nvCSqq3QNS5DB3O9ld2QGzqRwDK3JgFFwtj?=
 =?us-ascii?Q?LjrxHBbzm6ZXSGNQZVNsdFnHBp+2fqHK7EAaj7nJKN3/RAvlV0OUL40GQOzM?=
 =?us-ascii?Q?l37pIlkafyOSt46XvRf01ozm7wmsCy5Mx6FhdZiyUvljjqUXgWIPcogCCjab?=
 =?us-ascii?Q?M3aUdYe8pYJUsMNYrUmXG002rCFcVBVgV+UQHGysjahAtG7pmb5g94danLfe?=
 =?us-ascii?Q?sXQoTAmPCb8/EtO7hVI32eMEf1f1emFrb32YZ5Yr1Pvmbx1Ng3E+OAjGfAni?=
 =?us-ascii?Q?p4z9Wl80PEh6rGzVBm4XAlqXAmz18kYoSfKXpzR0ZH0J0Uhjzmx6/p92Pk6S?=
 =?us-ascii?Q?RaMuUTEts2Ia31v/zdlWSw7nGSX9GbzFqUIJUNLRMgmpQOzSq5xbdHqfmyES?=
 =?us-ascii?Q?QhBmDg=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cdaf16e9-387d-4a93-1640-08dbe24518ca
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2023 23:31:00.1066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YJYqkc0t82ijQa4u8sZYEYaSFiNk9EPoLBfILuy/r5TptoAWeYBahV1Eb6F9zDV1iWfiz1lxmU4YWuCNx9e4TB4GqgzQb0dOOoxr64FPYzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5454
X-OriginatorOrg: intel.com

Jonathan Cameron wrote:
> On Wed, 1 Nov 2023 08:27:17 +0100
> Lukas Wunner <lukas@wunner.de> wrote:
> 
> Thanks Alexy, this is a great discussion to kick off.
> 
> > On Wed, Nov 01, 2023 at 09:56:11AM +1100, Alexey Kardashevskiy wrote:
> > > - device_connect - starts CMA/SPDM session, returns measurements/certs,
> > > runs IDE_KM to program the keys;  
> > 
> > Does the PSP have a set of trusted root certificates?
> > If so, where does it get them from?
> > 
> > If not, does the PSP just blindly trust the validity of the cert chain?
> > Who validates the cert chain, and when?
> > Which slot do you use?
> > Do you return only the cert chain of that single slot or of all slots?
> > Does the PSP read out all measurements available?  This may take a while
> > if the measurements are large and there are a lot of them.
> 
> I'd definitely like their to be a path for certs and measurement to be
> checked by the Host OS (for the non TDISP path). Whether the
> policy setup cares about result is different question ;)
> 
> > 
> > 
> > > - tdi_info - read measurements/certs/interface report;  
> > 
> > Does this return cached cert chains and measurements from the device
> > or does it retrieve them anew?  (Measurements might have changed if
> > MEAS_FRESH_CAP is supported.)
> > 
> > 
> > > If the user wants only CMA/SPDM, the Lukas'es patched will do that without
> > > the PSP. This may co-exist with the AMD PSP (if the endpoint allows multiple
> > > sessions).  
> > 
> > It can co-exist if the pci_cma_claim_ownership() library call
> > provided by patch 12/12 is invoked upon device_connect.
> > 
> > It would seem advantageous if you could delay device_connect
> > until a device is actually passed through.  Then the OS can
> > initially authenticate and measure devices and the PSP takes
> > over when needed.
> 
> Would that delay mean IDE isn't up - I think that wants to be
> available whether or not pass through is going on.
> 
> Given potential restrictions on IDE resources, I'd expect to see an explicit
> opt in from userspace on the host to start that process for a given
> device.  (udev rule or similar might kick it off for simple setups).
> 
> Would that work for the flows described?  
> 
> Next bit probably has holes...  Key is that a lot of the checks
> may fail, and it's up to host userspace policy to decide whether
> to proceed (other policy in the secure VM side of things obviously)
> 
> So my rough thinking is - for the two options (IDE / TDISP)
> 
> Comparing with Alexey's flow I think only real difference is that
> I call out explicit host userspace policy controls. I'd also like
> to use similar interfaces to convey state to host userspace as
> per Lukas' existing approaches.  Sure there will also be in
> kernel interfaces for driver to get data if it knows what to do
> with it.  I'd also like to enable the non tdisp flow to handle
> IDE setup 'natively' if that's possible on particular hardware.

Are there any platforms that have IDE host capability that are not also
shipping a TSM. I know that some platform allow for either the TSM or
the OS to own that setup, but there are no standards there. I am not
opposed to the native path, but given a cross-vendor "TSM" concept is
needed and that a TSM is likely available on all IDE capable platforms
it seems reasonable for Linux to rely on TSM managed IDE for the near
term if not the long term as well.

> 
> 1. Host has a go at CMA/SPDM. Policy might say that a failure here is
>    a failure in general so reject device - or it might decide it's up to
>    the PSP etc.   (userspace can see if it succeeded)
>    I'd argue host software can launch this at any time.  It will
>    be a denial of service attack but so are many other things the host
>    can do.
> 2. TDISP policy decision from host (userspace policy control)
>    Need to know end goal.

If the TSM owns the TDISP state what this policy decision rely comes
down to is IDE stream resource management, I otherwise struggle to
conceptualize "TDISP policy".

The policy is userspace deciding to assign an interface to a TVM, and
that TVM requests that the assigned interface be allowed to access
private memory. So it's not necessarily TDISP policy, its assigned
interface is allowed to transition to private operation.

> 3. IDE opt in from userspace.  Policy decision.
>   - If not TDISP 
>     - device_connect(IDE ONLY) - bunch of proxying in host OS.
>     - Cert chain and measurements presented to host, host can then check if
>       it is happy and expose for next policy decision.
>     - Hooks exposed for host to request more measurements, key refresh etc.
>       Idea being that the flow is host driven with PSP providing required
>       services.  If host can just do setup directly that's fine too.
>   - If TDISP (technically you can run tdisp from host, but lets assume
>     for now no one wants to do that? (yet)).
>     - device_connect(TDISP) - bunch of proxying in host OS.
>     - Cert chain and measurements presented to host, host can then check if
>       it is happy and expose for next policy decision.
> 
> 4. Flow after this depends on early or late binding (lockdown)
>    but could load driver at this point.  Userspace policy.
>    tdi-bind etc.

It is valid to load the driver and operate the device in shared mode, so
I am not sure that acceptance should gate driver loading. It also seems
like something that could be managed with module policy if someone
wanted to prevent shared operation before acceptance.

[..]
> > > The next steps:
> > > - expose blobs via configfs (like Dan did configfs-tsm);

I am missing the context here, but for measurements I think those are
better in sysfs. configs was only to allow for multiple containers to grab
attestation reports, measurements are device local and containers can
all see the same measurements.

> > > - s/tdisp.ko/coco.ko/;

My bikeshed contribution, perhaps tsm.ko? I am still not someone who can
say "coco" for confidential computing with a straight face.

> > > - ask the audience - what is missing to make it reusable for other vendors
> > > and uses?  
> > 
> > I intend to expose measurements in sysfs in a measurements/ directory
> > below each CMA-capable device's directory.  There are products coming
> > to the market which support only CMA and are not interested in IDE or
> > TISP.  When bringing up TDISP, measurements received as part of an
> > interface report must be exposed in the same way so that user space
> > tooling which evaluates the measurememt works both with TEE-IO capable
> > and incapable products.  This could be achieved by fetching measurements
> > from the interface report instead of via SPDM when TDISP is in use.
> 
> Absolutely agree on this and superficially it feels like this should not
> be hard to hook up.
> 
> There will also be paths where a driver wants to see the measurement report
> but that should also be easy enough to enable.

Agree.

