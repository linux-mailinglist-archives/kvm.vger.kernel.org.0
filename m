Return-Path: <kvm+bounces-11613-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E36D878C58
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 02:36:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 82951B21A54
	for <lists+kvm@lfdr.de>; Tue, 12 Mar 2024 01:36:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE48317F7;
	Tue, 12 Mar 2024 01:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FcWAqBk4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CE7E79C0;
	Tue, 12 Mar 2024 01:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710207356; cv=fail; b=qIkbUZFeoLvEKUbZGD+Tl5Xzcc7nHuZGLAqfCUrnU9V3sciRB/KzqlGZ3ia6ynskYZB8xX2XKEKi20t6M1W0dkobH9SIVMViQ9DwYP/6/WPrvyzM+xiD9FH/0PyjV9F4KsyQNyN/eJp8BrqW2rnst3GmQ/y5uHe7wq/fE1di0CI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710207356; c=relaxed/simple;
	bh=d4DmxvoDi5GGt17+L4OnlKaA/10cOvctPPmzZn+D8So=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Ohc0/EmdeHiUyqnqI1lNQvjYUGoTJOfAYgmJur1Gv0F6CQ5ssNsz0QFgA7BzO7R1FaTdxjgEM7DYwvxI5/vyuBJl7VBk1YKX7UgvaVGT86SoOBheJgV4urKZ+Jeak8e5oClNXXFN/KS3yzrl0VpONwm7HnRe5b02ufATSOU7aww=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FcWAqBk4; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710207355; x=1741743355;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d4DmxvoDi5GGt17+L4OnlKaA/10cOvctPPmzZn+D8So=;
  b=FcWAqBk4ZA8OyArQsVr8RGFFFWTxzz53t4u0ovtk5PtOcGjm52xInrUn
   s/rZKY8EnXBsLILJ53eZenA6OoEQ8hECHwE8MEi8JIh37MFDyDCYtS4Kg
   u1ZXMfG93t7MoEHAX4OOng5CWfiSo9CwPnoyse4X5Pr56jXqQWEw7F+k3
   J6F1G3hDxQmR3anjfyBg+sZWOA5b3s/SEQDVxKLMcdeCCKOuL/krkO6ly
   aKjY6MiSNaWeIu8df2zS9brWMOvuca2o36Opiky3XwtZ8vL11uEw7+yKu
   XJiA7P7EVeKRbgrHY/6ZjRW2fcKGdqCNSca1Ps6die9JTvSgzAuN5sbeN
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11010"; a="5033779"
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="5033779"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 18:35:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,118,1708416000"; 
   d="scan'208";a="11432559"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Mar 2024 18:35:53 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 18:35:52 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 11 Mar 2024 18:35:52 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 11 Mar 2024 18:35:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 11 Mar 2024 18:35:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwCh7lgZOhRwX/b5rmd1TjQlwyfwiBr50pcR+s7eOrM72ov4OeSfWgcX/x90ppFjhtLvJ59u1b6tWUV1RrLXRosfqERsVTq+o3k7GXxJ+ry6R8GHLR8/gzkQDHpCwXw5C9tDroPZ+Hkm+924SFguG+YRiuDARndX9v8fYF9XRtj2QZ9xJFveArkLxTSlozsTJOg6zMtIyCz6JUz10Pp0EVXppW6m96lZHlf7s2d9T81CDGN6nFy2Be76m6d/BGtCHpKTpf9WNv/jhEMBY3LryaHlLDHhazqoNJwSzUY4yP1qAftHvsXly/SfN2bLjJja4d/yjvcGI94zVyjk9pIjSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zDO24NsJUfBqUixYmOvKo4zDlJlewMukfLTyWkVnk+c=;
 b=Yj7IH1pXSZmxaHPKbhf/IIal5X0HSJhN/mwVdrcX2BK5r+yaq08rQYc8z/pzyWjaimk4jRN9vu2hG0mNeGaxRsrjNHExRU1qvOS44wpeVOQGB7+st0R6uy8iulEAfbzUrjDqfZ60M2LF4VHoZ3Jh8ntYNOr0/yLaM0RX5siICQcO8aWtn6EQgk4cvNYt09HwuT7dY4AEG62Sf01Tm1DnRJxRBY/TyExf2vOpVsh9Gy8tut+9B+Hn5iH8aYrlD+OFtIjyvmjL7HHahdWhHjdA4KNIcMNbcVgvG4FE4nHhVIFN6/UGNfecvEdSb1jCdgdc50vtcjhuIXmLl0G8zkHL9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB4950.namprd11.prod.outlook.com (2603:10b6:510:33::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7386.17; Tue, 12 Mar
 2024 01:35:50 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7386.015; Tue, 12 Mar 2024
 01:35:50 +0000
Message-ID: <6d0f2392-bc93-445d-9169-65221fb55329@intel.com>
Date: Tue, 12 Mar 2024 14:35:41 +1300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/21] KVM: VMX: Introduce test mode related to EPT
 violation VE
Content-Language: en-US
To: Paolo Bonzini <pbonzini@redhat.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
CC: <seanjc@google.com>, <michael.roth@amd.com>, <isaku.yamahata@intel.com>,
	<thomas.lendacky@amd.com>
References: <20240227232100.478238-1-pbonzini@redhat.com>
 <20240227232100.478238-8-pbonzini@redhat.com>
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <20240227232100.478238-8-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P221CA0008.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:303:8b::13) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|PH0PR11MB4950:EE_
X-MS-Office365-Filtering-Correlation-Id: 607cd037-4454-40db-7e47-08dc4234bf8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P1I50Qifp7xv3718XQRlkZqkiKgrBlvZLwt2KsbPnBVGEqEI7xwUCzMUf5JJrfJoK91lK83KcsfCl8S8Qhal/O/fgwc2hzqYKOipsWjrTHCroT+CnYh3bI/Xc/f2OBnEn2CkKm33O2Vq/Kpe1AGPrb18Vo870gUZmyiM9V1pEu8PQ++ZF6GRpspMeJzIkT+L1JBWoefmNz6dY79z8i3psBagwEx4BEYwnjK7/2tIdEbSxkFKFDOFCnvgKkIuJyPrzlxXzxnG5dWlJftM3mj7Qqij1noNE8k/B9vcL75larnJyBwQ37YqC0SkB8V9o/oDTyqDnyHHlbCCf5OJI4FiYKEgL9T8pfMUKjIYpotYQ/5wAAL20c34j9dlHRZ8MUEMljqDKivurmJGRE2DX8+6B/wSYrZnB/Plc41VGP3pVjZabfg/fzaPMC2Z22Vobq8iAd51LtWxDWriYKLkTEM2dDV/m3yX0z27rFpmOwXeURR1+0ojgcJAzSfDCKJIuilbi3QY3JxaL34jCRkFVR4V5Trl6naFnMJ0XZJ0j8fBc7m9VdETL9+izdmP00XwVbH0ej0dNBNkOuyyOgMZK8gy8kox/GmN4T8SjjX1sDrDOYQiU0i0qoZCCvWVLdDN8p5PGGNqKpKc0bD4bZmofp13DbskbAz6c3IeQhiiCokwjdU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUdOTFBVN3V4a1I2ZlY2RWJGODVya0NCZUxHRHZrSmxaSEFLYThPdVhOZUp3?=
 =?utf-8?B?MWV2aEpVN0pvcTA4WFlqMFZ1aThVc2dKUHl3WmdBUzd4bzUrN3ZSUkZnTDRU?=
 =?utf-8?B?c3FMajh6VnhvdGxrUy9hN205c21HazNmeDBOaVJ0TlpERzM4VzhyU1E3RTh2?=
 =?utf-8?B?Q04vMWFiRHh5b1pHWjFXOHA2clZvTExjRmMwdjcrNUU0eUdBb1h1SlBTbHp0?=
 =?utf-8?B?eDk2RVV2cjc3SFhkblloMTdDaWpHMkFGT3gxbUo2c0JLd3dyN214bk5JRzFa?=
 =?utf-8?B?eWV3a2l0WlhMbU16SUhrWlFoVFFncFJ5UmRLOFREa3pJZ2JNQmFFcmVkbC9u?=
 =?utf-8?B?b25iYWtQaTkrbUVMd2RtZGdxLzZWSXhWMGNwbDdrK3VRczdJTXAzQk8vT1Zi?=
 =?utf-8?B?OE42TjBJQkIrcFNkQThEQzR5RFZidlkxNDBoa1dkZzVCcU1PTkp0V2xmcEFQ?=
 =?utf-8?B?VHVvbms3bFdFenBhM0h3bXZ6anlVbG15NzlTRnhISVF4bUNURWJxb1Rmcldt?=
 =?utf-8?B?QlphbWh6M2p3Q1o4ekkvUG85VmdWU2NVYjNIK1NKUEhIVlZ4YnF1M0dRNjdM?=
 =?utf-8?B?UXB5MUloRHZIR2VOVkxlZUxCbklkNGtTSy9VMHJUdkM1WEp4cFJyV3YwQ09r?=
 =?utf-8?B?VE1MS2RMVnd1bndYK3o5NnF0Zjd6ODZFZkYxU0R6bmJaRHVwY2hRMFVCU1NQ?=
 =?utf-8?B?TEh6aDNCMVpWWURPN2wxRU9RSjZwcmpzc2VwRGRMUHNvL1AxeXh6RXJETCtK?=
 =?utf-8?B?SEZGakUzV0ZueW1ROU9DUkJ3WURxL01wN0xzRzU3alNzUHZzWTl3QXFtWksv?=
 =?utf-8?B?RExINEFOWVhlZmlnU3JJQzdyWW5pZGpBUisrVDk2azFLTjRLNTdCeEorMmtE?=
 =?utf-8?B?SUNqaFRCS0JOL1dLSFdpZGpOTE4zT0pMUUdOVi9HWUd1NTlwU081dDVyMHFn?=
 =?utf-8?B?dzBLSUNKYVcwNjBUQmFtOHRzTEhneEtHREQzRGpIRTkvUzduSlBWaWJpNklt?=
 =?utf-8?B?UXRZUTNsWDc3RlR2V2R6bmdXK0E5QndQQkJSeFZGL2gxVUh0NVRyb3lwTk4y?=
 =?utf-8?B?Qi9DWWtwZ1dERFZXN3gzK0FjeFdwTWNqcGlIRFY1NFRjSS9XWnJzbmQrZjNZ?=
 =?utf-8?B?bTNZTEgvSmFPK3JuZHRHOWY2Nlk1M1FhNTZrUk1mYnRncS9TSDRlNzNFWWg1?=
 =?utf-8?B?dmdIb2ZvcXhGamU0STR3bGxrdDhGNjBaVjB1KzN2UFVUU1p3UXV4ZE1tSUNr?=
 =?utf-8?B?QzNQOFY0cytDMnNIT3RoV1VqNGdvRnZZaWZJL0x5RHhvVmdLNUg0M3dLOGpy?=
 =?utf-8?B?MmxuOXFURTRlYmc1aXVmRFNqODRwY2hOVHhsL3RqUnFsYVNmdzUvZGFKS3V6?=
 =?utf-8?B?b3RNcUlPeVRBU3V1S090VGNuUGwyS0o2Q050bFQvYWpKU21yMlloUSttOElK?=
 =?utf-8?B?NW1LODJlV1NucUdWWGczandlMUZ5VHdoeFJxZDE2dXN2Uk1nTFhMb0ZyTDQx?=
 =?utf-8?B?TjhjVWNJQXI0Z0pVNGtzaXU3T1JCUkgrc3J3K3J6VGtielpCMjNGZS9GK0pk?=
 =?utf-8?B?dnVFQlRRVWw5ajlrbk1UZ3p4dysvRnRobjVpRnU2RVJhY1RyTENWUnRzTmxN?=
 =?utf-8?B?RGttR0lKVmxrRmlZejM2Y0NBRVNrNUErbGN2YkE4YXpnV1k0TjZReEpJcENS?=
 =?utf-8?B?QW5hcXp5eDZ1OGNtVnpHV2hQa1pQeGNOT2tudCtqbmtqZDNUUTBLUVNNSTZF?=
 =?utf-8?B?TCtBUzNrNEdLUDl1SEVxa2FaNjR1QWRCZU1BVW5CaHluajJucDVwVm9leHpa?=
 =?utf-8?B?WUZnaEpNWVNHVFdxWlNyZVphMTUreWZBNGlYSnV3SE9WZDRvNVRjdXNUZytN?=
 =?utf-8?B?SFFhV0JtSlBIQzhxSVM5dHNCSzEyQXE1TWczOUJYV0tuSkZOdXhhakJCQ1lr?=
 =?utf-8?B?YmhrblBaaFlFTW5aVUFmUWJWenpvRlFIYVh1dzNzN01FY0dnUElNRnR0NDlZ?=
 =?utf-8?B?OXlIRjZKTTErd01MUFovUzhIdXg4b3BUTmkwcFJOU3pzV1ZFMml0YXd2aE5r?=
 =?utf-8?B?MkJXZkJsOW1Yc3NJeG0ramlzTjJvcG5rTS95a2p3TGFla1ZteFlqR1JRdW4w?=
 =?utf-8?Q?vkVYHt2Qcp3koX2E+VlpSR4T6?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 607cd037-4454-40db-7e47-08dc4234bf8a
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Mar 2024 01:35:50.1222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I0wajLY92KCMSe+Z8VkahsHg1XK1QCRGt8NYkhoUGxr/6f6OO6PosdtTxu+GSjMcR3d41DVqEDJ5iQ9upXK5cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4950
X-OriginatorOrg: intel.com



On 28/02/2024 12:20 pm, Paolo Bonzini wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM uses the
> suppress #VE bit in EPT entries selectively, in order to be able to trap
> non-present conditions.  However, #VE isn't used for VMX and it's a bug
> if it happens.  To be defensive and test that VMX case isn't broken
> introduce an option ept_violation_ve_test and when it's set, BUG the vm.

I am wondering from HW's point of view, is it OK for the kernel to 
explicitly send #VE IPI, in which case, IIUC, the guest can legally get 
the #VE w/o being a TDX guest?

