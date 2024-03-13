Return-Path: <kvm+bounces-11710-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 50C6487A0F3
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 02:48:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7371B1C221DA
	for <lists+kvm@lfdr.de>; Wed, 13 Mar 2024 01:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86B4ADF6C;
	Wed, 13 Mar 2024 01:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MSWeRuAR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AB3D26D;
	Wed, 13 Mar 2024 01:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710294528; cv=fail; b=XsxNLq+2lP0vXgW8QxJBLUF3JWuRjYDDcO+Mxnec+K7spLjsH1tzM0dO1FrwfU/nQ6t38IRrx5FnoWfFtGjLrPo4DkEsCI/fjrUywJZNDXxm1Atw536xqxTcU6IArOW4nxDm8yxI8OcOP9QzBMQrTFTg/S5xhLnQie5oFtbQKQo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710294528; c=relaxed/simple;
	bh=wfKDqgTKeUiqxgUJ4lX2t4fTgcWlYB4C809/M41xx0M=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=vErtqkZ8RNrUd0pEehoHiqFyKrhbmHC643EwpbVmN2ox6Hhu9xaRwBhN1A2/ucN9ctJLuWRswiN6yj0LevO49TZKWyUnIWIhU9b8EGiU939bjAFUwrUfgDLhk0R1/u1JAoSXaNM7rwXFfOya5gJceUNd0SCJDQPrFg5GOMwuJyk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MSWeRuAR; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710294527; x=1741830527;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=wfKDqgTKeUiqxgUJ4lX2t4fTgcWlYB4C809/M41xx0M=;
  b=MSWeRuARP/BAwPu1jny5Qo2ngWFtFY90e7vYH2bywa968ePrpnKScng9
   fgw6MXC2OHL/wfuC5FbmYH0XZpVysi+N5nwkSmnwg097lTIg8yXcPAl3y
   FwcPlljqUejivPC9beZTDJ6SxfafaBnrNspfh+V8/HCCW0jipey7jDChc
   kmwh5GCdCLelOfZioi0jRX6m/PkXNzY8bL1aD7ckcLNrZaalxTrvuKsN6
   i49HMVhm/gfgCgE4B/SdiZm4nzRczs2Y2ZeObwtIo1jiMwBJ7csBHpApV
   g9tQtMa3tHX0YiIAqUGKoDYGqyRsHfdaWapl8BEGIZhT5ccb2xxqHlnLW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11011"; a="22492247"
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="22492247"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2024 18:48:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,119,1708416000"; 
   d="scan'208";a="16389131"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 12 Mar 2024 18:48:47 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 18:48:45 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 12 Mar 2024 18:48:45 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 12 Mar 2024 18:48:45 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 12 Mar 2024 18:48:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWLw9Bi5vei90+mRyHsZwbvUCsYYGwmwxtiep0XPHvzLEsQUwU68XWW2kxChyPmkRusvXb6J4urq/vcBPORHLKY8oudjs4+DAkY3smYCbblSF1nTUOTyfo2meLHg4T0ZFz/6bB6BSHYC+q5c7deNOH+z+DLgmM2q01+cy8FYLdY3/M6u12Gf2v3oSahd2SQ+ikErPfk/xXaHPR2sDHwJ2Tm9WzC7mDNcdX1TLeIRCeb86awVzucwCEJbjuB114+9SDsX2HazznFfnyDI2uE5D//ZEQko5hwYx11UtNFGOUbTg9cufPhM8IvNpahwa3jSPQ3PRxXaM84y7f3mdA1LwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fir4yT50Swbo7ChUM3TDXkXOb1/kUiCNSp3EVw0G084=;
 b=OMFx6+AvFuieH12qR3g1jPZ2b1QExuIbbMgABl6r0V2R8IraOFryHjsW95raun4af9EwSIfHTtuntp6iCM/JpXqXNYVghKoTR1Xsq8OsOGJ4y2AnarrvzO5soxZAugxEh2otOA2ZQELuxH2pPpZ4e7aOIfIXLmR2xA591RvDvCtd0TAmWMHh1FSr2KNNHs67G90rOdCFhNuydujGNZB20JJ5FtsMz1oTr3T8GIP+lGH9EBu4FABtLums45NQwTmOmy0gZ07/tpzoJnEJhxwxgGZpI58YP7cRgpOW55DKNZgZdXTCQBUetqxMESxZAfHA1sBOlbpjRK928Vx1QDxLNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 CYYPR11MB8357.namprd11.prod.outlook.com (2603:10b6:930:c5::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7386.16; Wed, 13 Mar 2024 01:48:43 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::55f1:8d0:2fa1:c7af%5]) with mapi id 15.20.7386.016; Wed, 13 Mar 2024
 01:48:43 +0000
Date: Wed, 13 Mar 2024 09:18:50 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Sean Christopherson <seanjc@google.com>, <jgg@nvidia.com>
CC: Kevin Tian <kevin.tian@intel.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, "Paul E. McKenney"
	<paulmck@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "rcu@vger.kernel.org"
	<rcu@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, Yiwei Zhang <zzyiwei@google.com>
Subject: Re: [PATCH 5/5] KVM: VMX: Always honor guest PAT on CPUs that
 support self-snoop
Message-ID: <ZfD++pl/3pvyi0xD@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20240309010929.1403984-1-seanjc@google.com>
 <20240309010929.1403984-6-seanjc@google.com>
 <Ze5bee/qJ41IESdk@yzhao56-desk.sh.intel.com>
 <Ze-hC8NozVbOQQIT@google.com>
 <BN9PR11MB527600EC915D668127B97E3C8C2B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZfB9rzqOWmbaOeHd@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZfB9rzqOWmbaOeHd@google.com>
X-ClientProxiedBy: SI2PR01CA0023.apcprd01.prod.exchangelabs.com
 (2603:1096:4:192::17) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|CYYPR11MB8357:EE_
X-MS-Office365-Filtering-Correlation-Id: cf88d365-7526-4963-5a07-08dc42ffb6ed
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XkzJ5/ww2GYoXGLAPSaq7HCx3lnR0X4rwY0ZGr/9vdQ50Tgfw6J+clGuSntF4jZjkz7aoDFCcS9K7ZaJcS41zdprZvw7/tA3HvR/PdGKk4uTMt3tjDtlQ/whYGWRw59rRiKkH6unx6/sJdisbMtsFYSz7dh/MySJHDhD/bg2R+3vTSBM7J4DuQHxJ/I5z7rvlMT7e3Rr+OBVQR6xGAdmFdNYy1CSl+Sg+IhaCH1J0OPnNzE0Aaeqq2DevjwsUYkHSDR9ioxNbKAQyCQLzYgPU32mJLDGVBPTPiR+zg6kJWiPShCUISjtCicPNnDjv1jOb1wjKiAlFDLEh404238yf7351wKffq48BWIVH+5kPQHkFX0bKSr1Qq4WW4QXmDtUUE9kkbp+Lsw0zh9uQsEtJeo5SpjnL3y6bqkvx/epJhxMI3IEPCxD1tCsX7byP2hCleCRL9QTXOHTEIRisaAvvF007FYWWYlwUGRO/08L2RLB3aws0Hr4AdALzY9x8mcYycP0nhYJOkcyJls3ka4vTNgijOX1ZFAf1WRK147Pj0mWsVtXlKSj+xCMjdDcpZ8CLN0fslg4h7tiXKOCjaclzHYbS7PuV8fghGRFcXE51Nq0T9aNujzYSrEbOGxT1fhi
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(7416005)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VXpQcmRiZnlOZzVOdldvYjh6UERmTHFuTEFEU2F2ZjdRSWxadGpWUlZYUitq?=
 =?utf-8?B?eFFXbllyMUVMRVEzMzVqeWhXeFlMMDN3TGhvUDVCajc4TlpxNWRpM3k2aExi?=
 =?utf-8?B?cHQyd0pudzdlNy82OVJpQWtvSnRtOFRXUnRkZXVIMzZZQk1RbUdnWVgwTXla?=
 =?utf-8?B?eG5QTkJBdVk4eDNxejJFVVM0dTdUSmVZRVVLdnFDdVFZK2RRSDZST1VPZlVr?=
 =?utf-8?B?ZHJUZ2RQL2h0cVdwTXkwRTg2dThad3M1WkpTY2lBMlZoMFY4RnJBSFhjR2Zr?=
 =?utf-8?B?MzRQZ1VkbURrb0w4LzB6aDlXT0I2QlUzQ1puanFXcmVxUGhyU1BNcGtiUUNj?=
 =?utf-8?B?eko5WUR5SlFCaWljOG9HWG1nZ1gvekp6YjRxL05wR2xoOEpDUUJxM3A1ZmFa?=
 =?utf-8?B?WGp4NGoxSDFET2M3VkpiUXpyTkR0TDlvVUF4RGlRbHFmMCthNVMwMFJVbE8r?=
 =?utf-8?B?WXdVcXY0V2ZqRWJveitSOHYrbE1YVWNhYUE2M2k5aEJjTEMvNEZUd3IvTGZQ?=
 =?utf-8?B?NzNMWWpzWWM3UU1Id2s2cTg0NWQ1ZDRJVzBNeFQwcEJ2QjlzSjNadFVOQU1U?=
 =?utf-8?B?c09qV05MczJDbWtTNEZGM1FhRXJpNWpGbG5GVnlhN2VYSFFFVkVaWkc3V3Zq?=
 =?utf-8?B?VlBRT1JHSTdUMGE2bU1VS3JvSklRWVl0aTJoeC85VVR4TzZUMmd0cWxZWDhk?=
 =?utf-8?B?UkthMDUydW1pV0xpeEgwc21aQnJ3MXhZMG9ZeHh3cXd4YUtWVFpSaXZMNkkx?=
 =?utf-8?B?ZW44WldFMWlsd1FXbGZNcFlQNzN3akJmcS9mWHp5dXptZFBla21LRFVyZzNW?=
 =?utf-8?B?SkdKUFNPdFhKZVE4azJwMi9RT0gyK0dWODJJYTZSbG5iQUxXSm1vWEFsaGow?=
 =?utf-8?B?SjRpYzYwZnhPMEcydVcxbm9kNEhGM3NnK0hLWU5IYTdNNnV6citsbFJvSzJH?=
 =?utf-8?B?b2h0TE43dzVLc3JpcVhTZzFhVEhDVjhvZGRUVlViMG9PRjNjOFBPNHR6bHVw?=
 =?utf-8?B?ekpEVUJaZnVvNFpLMVE1ZVNZMGFpd1VtRzRldi9lNEZ1UUcwbE5TaEkySVhE?=
 =?utf-8?B?M3JyOTAzdUJqK0JpRjMzUFpDRXl0Y1VhQkExUGRYa0ZTUjlOT1BzbDRYY01r?=
 =?utf-8?B?Vk9JM3RIUitaOWtXWmdrK05PTmluMjczWWZJNXdFdnIzYlpUUmJweUZaRk1j?=
 =?utf-8?B?SzNoazFWcUZ5SmpSTUVnN2pSekQxUGdPNUFTKzdJWnM3ZWZzVmVTdWl6QjQv?=
 =?utf-8?B?RGhCM2p4WFUycTJsQ3lNLzV1VWY5MzhiY2NrNFdhVTBHUUFNYnNOTnhUUnVi?=
 =?utf-8?B?R21ZRDlnUElHRzN0dVUrNDZZbmxKY2pkYUZBOER5dEtZTVpWMmh5cXF4V0lx?=
 =?utf-8?B?K2hGeU13a0xlUjhTb3FlTU4xbXdkQW52dnB1MW9xYmNqQ3lOS1hjeFh4aXNZ?=
 =?utf-8?B?dHQ1Y2V1TUZtS0FsZXpsdXZ2TkhLQ0pQOWUvTWgrVnpjdDdaRVF4WWZhNVZU?=
 =?utf-8?B?ZVgxNHJkR1ZpL1ZSM0hiTnR4QXBhdlJFcVRUL0k1UVFsbmJVTUxaWTlXMGF6?=
 =?utf-8?B?ZzdLS3RvZlppR24rOWhrSWU0RjE4eENzdTJ2ckZUUTZoZlNkVEg3VlBKcTBr?=
 =?utf-8?B?aHNaSDNHZ2U1dEdSMStSOVlBeWZpZzR0MUNETHJxeUplcWZHRGdaSTJaRlU5?=
 =?utf-8?B?cG9ITUxnZ3NZUXZYUTM4YTZOTG5HYzY1ck43cCtpanBtYUxiYVNsM05zREJn?=
 =?utf-8?B?M3VCWVRlSmo0aFNwaUlFN0lDeDhYdDZ5L2pCT3ZzS2lBVGsxTkRaNGoxRFJu?=
 =?utf-8?B?dHBlaWtUQXdEbkJYTVFBajJncXhTUG8yMGtVbzNwd2dnUWE4OXpiQ2RiNm8y?=
 =?utf-8?B?ZDJ3anlkRlRUeWprYzlhK3Jha0N0bkt3d05vNHdVS2trdTliRy9GbFJ3Zk9m?=
 =?utf-8?B?ZldZUjdxaXNRMStIZVk1bElhRElkRnpYd0JOcFFIWGJYY3dEdTVXYnk2NUlv?=
 =?utf-8?B?bnVMdzk2NXlPcEV1cElLL054Uno0c3FGMWRNblRQakRacXBWOTc4V0RTdXdi?=
 =?utf-8?B?Yytnejl3UzJ5eS95QnV1WDMraTN3dVVDZVFZMzdmM3cyQm9uang5RXhCVnpa?=
 =?utf-8?Q?zJZ6J76OFaFlzbrmC13k+4Ml1?=
X-MS-Exchange-CrossTenant-Network-Message-Id: cf88d365-7526-4963-5a07-08dc42ffb6ed
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2024 01:48:43.4192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pfj+iCn6pcuOKcWkLUfzN0DteQ3wLTkVtRJ2CE7DgClS2qiKVZRl6rjbsTy8Z+rqwOUJiJYVfR99v8E3si/aDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYYPR11MB8357
X-OriginatorOrg: intel.com

On Tue, Mar 12, 2024 at 09:07:11AM -0700, Sean Christopherson wrote:
> On Tue, Mar 12, 2024, Kevin Tian wrote:
> > > From: Sean Christopherson <seanjc@google.com>
> > > Sent: Tuesday, March 12, 2024 8:26 AM
> > > 
> > > On Mon, Mar 11, 2024, Yan Zhao wrote:
> > > > For the case of !static_cpu_has(X86_FEATURE_SELFSNOOP) &&
> > > > kvm_arch_has_noncoherent_dma(vcpu->kvm), I think we at least should warn
> > > > about unsafe before honoring guest memory type.
> > > 
> > > I don't think it gains us enough to offset the potential pain such a
> > > message would bring.  Assuming the warning isn't outright ignored, the most
> > > likely scenario is that the warning will cause random end users to worry
> > > that the setup they've been running for years is broken, when in reality
> > > it's probably just fine for their
> > > use case.
> > 
> > Isn't the 'worry' necessary to allow end users evaluate whether "it's
> > probably just fine for their use case"?
> 
> Realistically, outside of large scale deployments, no end user is going to be able
> to make that evaluation, because practically speaking it requires someone with
> quite low-level hardware knowledge to be able to make that judgment call.  And
> counting by number of human end users (as opposed to number of VMs being run), I
> am willing to bet that the overwhelming majority of KVM users aren't kernel or
> systems engineers.
> 
> Understandably, users tend to be alarmed by (or suspicious of) new warnings that
> show up.  E.g. see the ancient KVM_SET_TSS_ADDR pr_warn[*].  And recently, we had
> an internal bug report filed against KVM because they observed a performance
> regression when booting a KVM guest, and saw a new message about some CPU
> vulnerability being mitigated on VM-Exit that showed up in their *guest* kernel.
> 
> In short, my concern is that adding a new pr_warn() will generate noise for end
> users *and* for KVM developers/maintainers, because even if we phrase the message
> to talk specifically about "untrusted workloads", the majority of affected users
> will not have the necessary knowledge to make an informed decision.
> 
> [*] https://lore.kernel.org/all/f1afa6c0-cde2-ab8b-ea71-bfa62a45b956@tarent.de
> 
> > I saw the old comment already mentioned that doing so may lead to unexpected
> > behaviors. But I'm not sure whether such code-level caveat has been visible
> > enough to end users.
>
What about add a new module parameter to turn on honoring guest for
non-coherent DMAs on CPUs without self-snoop?
A previous example is VFIO's "allow_unsafe_interrupts" parameter.

> Another point to consider: KVM is _always_ potentially broken on such CPUs, as
> KVM forces WB for guest accesses.  I.e. KVM will create memory aliasing if the
> host has guest memory mapped as non-WB in the PAT, without non-coherent DMA
> exposed to the guest.
In this case, memory aliasing may only lead to guest not function well, since
guest is not using WC/UC (which can bypass host initialization data in cache).
But if guest has any chance to read information not intended to it, I believe
we need to fix it as well.


> > > I would be quite surprised if there are people running untrusted workloads
> > > on 10+ year old silicon *and* have passthrough devices and non-coherent
> > > IOMMUs/DMA.
What if the guest is a totally malicious one?
Previously we trust the guest in the case of noncoherent DMA is because
we believe a malicious guest will only meet data corruption and shoot his own
foot.

But as Jason raised the security problem in another mail thread [1],
this will expose security hole if CPUs have no self-snoop. So, we need
to fix it, right?
+ Jason, in case I didn't understand this problem correctly.

[1] https://lore.kernel.org/all/20240108153818.GK50406@nvidia.com/

> > this is probably true.
> > 
> > > And anyone exposing a device directly to an untrusted workload really
> > > should have done their homework.
> > 
> > or they run trusted workloads which might be tampered by virus to
> > exceed the scope of their homework. 😊
> 
> If a workload is being run in a KVM guest for host isolation/security purposes,
> and a device was exposed to said workload, then I would firmly consider analyzing
> the impact of a compromised guest to be part of their homework.
> 
> > > And it's not like we're going to change KVM's historical behavior at this point.
> > 
> > I agree with your point of not breaking userspace. But still think a warning
> > might be informative to let users evaluate their setup against a newly
> > identified "unexpected behavior"  which has security implication beyond
> > the guest, while the previous interpretation of "unexpected behavior" 
> > might be that the guest can at most shoot its own foot...
> 
> If this issue weren't limited to 10+ year old hardware, I would be more inclined
> to add a message.  But at this point, realistically the only thing KVM would be
> saying is "you're running old hardware, that might be unsafe in today's world".
> 
> For users that care about security, we'd be telling them something they already
> know (and if they don't know, they've got bigger problems).  And for everyone
> else, it'd be scary noise without any meaningful benefit.

