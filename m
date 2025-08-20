Return-Path: <kvm+bounces-55190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A15DB2E1DB
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 18:07:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70F195E690F
	for <lists+kvm@lfdr.de>; Wed, 20 Aug 2025 16:01:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4BC93314D6;
	Wed, 20 Aug 2025 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VIrzXOrq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E80D326D58;
	Wed, 20 Aug 2025 15:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755705590; cv=fail; b=l53F5fg/UvTen1daFwPwxcwW5Lo2TCS1jInjlEJyCv+YW+b0fiWJNehqU6+bHi+qMo+e+FafUhnwwvKREBrUeGuKMlMBL5sjbLnoXrATS50Dm3Chqd2TREvteCa2zYF7l66yZ96eBiSOBYV8xPm2sy3+m18FcjDaMZxSW5g2kt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755705590; c=relaxed/simple;
	bh=W0Eo1EA9H7T2S/kcKnc/HnbDX1tI3EIrTCmsmBxuero=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=JSD+EfyameoAdSNhPW57X39xmd8LXY6RnfR5dUwNBFhz28ixbzPfCCoc5/+Z0Ml6a/UD9VG/Qa44xbVWVsLNAmokMSUXKDW/Zyjp07ye5ItxkXu/1JcZQhxgp4KRkGQBQbDVMtjSBBYcj63Vc7REhfnj45Oml8zES21Pbd7WI2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VIrzXOrq; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755705589; x=1787241589;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W0Eo1EA9H7T2S/kcKnc/HnbDX1tI3EIrTCmsmBxuero=;
  b=VIrzXOrqFvVVKd0m4CLhBMZ7osKtBdkd3CGKTLuSnyw0qKNT+JAUJtP3
   1plmKLn/PimtPVyTYPhjXc1N2eKaAV2obFoeJ3Z/t5jrBsbcgGTdicXDl
   3KFfMcUNqj8w8CRZPIaA9Yx9QldH9VDNHbL5YGLO5AnFWGyxDFyWmmtA2
   69n3fEYfUmf4UsW4ru/Fllb3b6A/LsENFBuSgK75pDlyoDV7bHeefandF
   HkYN2GqG/SH/J96ChSLvSMLacY8wrEOJIzifXBvoSA+3cYh4dcMz+adII
   /m9gSsatQ+g+WVLidfKjJxAgySYEvkF/Ec75OJAWqK8B6l6ToMuEgFK+H
   w==;
X-CSE-ConnectionGUID: wOMylKtNSLurksfavlwr0A==
X-CSE-MsgGUID: ETm3+0bxRVaPwK6ojTD++g==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57177247"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57177247"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 08:59:48 -0700
X-CSE-ConnectionGUID: aJeN5VgrQLSbg+Nme9edlw==
X-CSE-MsgGUID: poDl334RTP+wo43v6N5F0Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="205323394"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2025 08:59:47 -0700
Received: from FMSMSX901.amr.corp.intel.com (10.18.126.90) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 08:59:46 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17 via Frontend Transport; Wed, 20 Aug 2025 08:59:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.63) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 20 Aug 2025 08:59:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=I5zPAEsgowJrslVd2SanH5Aylx7yW88VCKKPI4m5Lvjg0X//9f2Cb4DS7KMLqi4OcvRzLekvGVlCcPYgI9izB6bOrWBFSZeCCJXD4yOykBhHhI7pYz33EIDU2iuBW/cjx7NWQ2d/bzG+TT/ksA9IdgDZDHeRQ14IuBAYOgM9V2E0f/sXULkeEt18k91BHWa/iAagP2py2dYK84Nedmr9839VUv64j5vbO9zF2M6CU9fNNfnkbNbvVndXSadZpmfkiWkQ75qYbdEFZ5/0nSLArchGdgkJa0+LWR42riJv7XJhBrS2CZ+WGXaZ+CVF6wq5WIq7sI5NytEdaETje54FVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ho1NaKX91KwllXZo8LlP2Ffh9Ej4luzpLpM3trulntQ=;
 b=MVxfHcRgKaW7tFEHEJyYdE/8RF7wntiqWUJa+TW8omyEEh6l8NfG2Wx5x5ItZWlWeW0gmVkiAnl8XF/NG9PwHU1q45I400TG+Yw55Mr/sVfjG916HYBIqAcvRoiD0ZjHU6riEqOYHZxs0TMuIrsgG9CF1SZSFeVj6PsNJ++pt07TZvzRBaNmd4J3nzCHGXbTlY+yShSIt002x4EvLGfHtMlAkccTlSX94k1V9NsBVnXTLj7rw79z37rKJz1YBJIpAHmOqhBkHnJa8Ti319Q5uJO6MSb+UZpEhBGDYFMuAxc3VqinOhqvm8MqNFzc7SyjN8x3NXmfmwtXhFcCvzJCJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB7198.namprd11.prod.outlook.com (2603:10b6:208:419::15)
 by SN7PR11MB6653.namprd11.prod.outlook.com (2603:10b6:806:26f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9009.21; Wed, 20 Aug
 2025 15:59:38 +0000
Received: from IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905]) by IA1PR11MB7198.namprd11.prod.outlook.com
 ([fe80::eeac:69b0:1990:4905%5]) with mapi id 15.20.9031.023; Wed, 20 Aug 2025
 15:59:38 +0000
Message-ID: <2b86c458-f63b-4f74-8fcd-1456ddad4d7a@intel.com>
Date: Wed, 20 Aug 2025 18:59:32 +0300
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND V2 1/2] x86/mce: Fix missing address mask in
 recovery for errors in TDX/SEAM non-root mode
To: "Luck, Tony" <tony.luck@intel.com>, Yazen Ghannam <yazen.ghannam@amd.com>
CC: Dave Hansen <dave.hansen@linux.intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, Borislav Petkov <bp@alien8.de>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	"x86@kernel.org" <x86@kernel.org>, H Peter Anvin <hpa@zytor.com>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Huang, Kai" <kai.huang@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Du,
 Fan" <fan.du@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Gao, Chao"
	<chao.gao@intel.com>
References: <20250819162436.137625-1-adrian.hunter@intel.com>
 <20250819162436.137625-2-adrian.hunter@intel.com>
 <20250819172846.GA578379@yaz-khff2.amd.com> <aKS5ixhgtCYIvErL@agluck-desk3>
 <4b8b5c89-e8b7-4eec-91eb-1fe43a68cf9c@intel.com>
 <SJ1PR11MB60833C7AE2FA8D8200EA3645FC30A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park,
 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 -
 4, Domiciled in Helsinki
In-Reply-To: <SJ1PR11MB60833C7AE2FA8D8200EA3645FC30A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DUZPR01CA0310.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:4ba::10) To IA1PR11MB7198.namprd11.prod.outlook.com
 (2603:10b6:208:419::15)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB7198:EE_|SN7PR11MB6653:EE_
X-MS-Office365-Filtering-Correlation-Id: 5521c132-2fef-4af3-1b02-08dde00290ff
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?YkkvNXJjWHdJaTB3TnZRTlg2V0sxditEU0ZBOWRKcHRKdlNmNFIwN29TcWpt?=
 =?utf-8?B?VFBQZ1laa1ZWMmZGdFBjaTc0NFpqbXh5S3lYNzNYMHhrcXB4VDFhQWxmK0ZU?=
 =?utf-8?B?U2VhWVB3aTArNEZiNExXSkhudWpzZHJVb3JITml2K0tNRm00eW5rSzVpS09W?=
 =?utf-8?B?UStRN2Y2SnVsRVFubVQrVlhFRDJjNVlGeFk5VXBkb0d6QzJpNjhJWlU3ODZO?=
 =?utf-8?B?WDZLZDFUK3NmcDFNL2E1b3YzT3k5djEvUzh3T1VyWjZROEIycVBaRG1ab3Yr?=
 =?utf-8?B?T1A4ejloZDM3RDdJS2FSS0poSkJ1eDZZOHRqaEJiWnJycHZpLzZab1RzcjFZ?=
 =?utf-8?B?Q0RJNmh5amVLenpNZzNwSEI3eFIzRmJ5TVdXajJhb05XOEE0aHBQUlZIVVdm?=
 =?utf-8?B?Q1kyb2cvYSsxcWJIM0paOEQvNGpSYWlUc0NxVVZIK0pTMy9obmQ0ZzVSMitn?=
 =?utf-8?B?U0VCc2V2Z05OanB6T1FzbnpoRFE4VnVkcUV6NmJKRUxsblV4OWRGekIzY082?=
 =?utf-8?B?R0dId1FFQnEwbkEvL1g3d3JxUFo4TUxhYkRTKzg0T1JEcUsrd2FKNW50NlNl?=
 =?utf-8?B?SWlnUndkSEZ0Z2VyVDhWeUhPbFdXM3Viczh5aFJyc2xXZUsyTHBrZkxsKzdz?=
 =?utf-8?B?dVd3SFBJSllEUnZRZVNjdlhYSkoreVR2REN5dEdyQmwyaXhEaFNNTmJyR3Fx?=
 =?utf-8?B?c0NvTVdRL3dkSDZ1MUMyNTlyakhmazZaR1VRaGJXVWlXT0I0ZjNuTVEvdHlY?=
 =?utf-8?B?RERCM1VkdmdWU2JuWVhLVk5tV1ZpYlZFSWdSQmY3VHdwUmE5VFloeEhkY1cy?=
 =?utf-8?B?RHFXV0RDbHhDQmI1TlE4VEJZcmN2Wkt5eVF0TEhYVDhYZTVQdVJLZk85NnV5?=
 =?utf-8?B?NDNvMWlWYUxLaktwZTFwbG5DOFRmOEUvMzNkU2swNTQvWDM0VkVuRmFsNGJx?=
 =?utf-8?B?NnNEekRMenU3RXMvL2hrZkNXZDk4VElSZXBEQXUrdFFsQURXN09OVyszR3di?=
 =?utf-8?B?aVR5ZmtUUmtsZmZMbC80d2lMWUtQRGFsc056bUFSSWx4NmhoNnpQZWxpamtQ?=
 =?utf-8?B?OW10UkJLSjVnUm1IMHU4dEY0cFpBeGlpS2lQRXowRzhnbGk5ekV0U3RyekJI?=
 =?utf-8?B?QlRreVIxSHBrZ3N4TWxEdzVab1ZBMTBQL2ViS2Q3Z0RGM0E0ZzFob3BwRDY3?=
 =?utf-8?B?TElnVUVZTGdnQUR6cGhVN3JPODlBNno0VytMU2N1Y09LOGdMbWNiSGVFRDlX?=
 =?utf-8?B?Q01xMGxGeDBzYUlQZ0lPeGFwdWZub05HOHlHdjRjbnNJci95RWRYQ1RkSUY1?=
 =?utf-8?B?LzJnOG5naS9JejlPZ0NweDNVQSsvL1AzdmNwQVpOUlFQNHVMK3lwL29OQmFX?=
 =?utf-8?B?SzhsaHNRbGtKMWQ1L01JVWVaSDZUbEtMWWFkOWpJaVlET2FWVDY5aUlreHNr?=
 =?utf-8?B?NjdYZlF6MCtMelpGU215LzdKTnUzQS93NC8vcHh4b3MwUmdBTmNiQWVyVFhT?=
 =?utf-8?B?RTF2VXZzMTMzdHFpdmhVM1ljeGVVMk5SNnhjc09VdW1uVC9YMlEvWFNYemRv?=
 =?utf-8?B?U2dHbmdSZSt1SW5pd0hUS3BseVdoN0xrTTdTdU1qZk1LaTR3bFpNTmk2b0hM?=
 =?utf-8?B?bWtBWGNBUHNkSWFTSFgwYnJqVW9YRGJuSnBWUUxjc2FBWmpkR212MUY2TkNq?=
 =?utf-8?B?OGJXVnd4aGo5eG5PVkpEQUZLbzhyQnV1UVY2REtHRTIwaWlVMHNaQ29vaDNW?=
 =?utf-8?B?M0ZhR1JvZ0xla0hQUnBxVXZveUdZVTA1dzg4T1Zxb0x3REhlOExlRmV6S0J6?=
 =?utf-8?B?bmNJWUFLeUo2Wi8ySUozd0h2eThHYTJrNEo0QldURkkxYW1xcU1STndOdzBZ?=
 =?utf-8?B?TEdabHgyZDBFSldDc3RxQ1djZHpkMExvc1R3ckliSmhFMTJXeU5RRGlxTk9X?=
 =?utf-8?Q?wkshYImgQas=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB7198.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YzFxSWd5QWNnem5JTTNCaGl6SFZ4UUhVMXZGWWp2NWpQWE43Uks5NlJqMHJJ?=
 =?utf-8?B?QW5CczhlandvZDFtQWMwMXM5anpBaVcxU3N0RlRVMnJrR3pXNUdueG9tdW8y?=
 =?utf-8?B?SCtnSTBXVm93N3pkY0o0emF3SHc5em9SamVrVVF2SWhGRHc3MzVxMXJFM016?=
 =?utf-8?B?V3BkbDlnOWlZaW15UDRESEV2SVdhMFR2NHh0Zml6bXZKZGl1dzBuSDY5aVlU?=
 =?utf-8?B?ZG5adkF5dFJ4VVFkV0hEVTE1Zk5kT2JxZUpMOHVjMVFXbzVmTjlraHVlTkFW?=
 =?utf-8?B?S1h1QTJGV1lhK0ZWZk9jZ3F1MmtoWHc4SThOUjBBSnNxVm02cnpyS1VBMHFJ?=
 =?utf-8?B?NzBGTm5OdHFoVTg3WEpKVEtZU1JhMFRtclZJZGZvR1RvWHV4WThvZ3U4SVdZ?=
 =?utf-8?B?ZDZFQkxJSlBVOE1seWUrUjUvZGNqR3JDd2pRNDZTQkVTNWtFZm5WeGVXVDh6?=
 =?utf-8?B?dkVRSVlXVHBJL0Z1UXYxR0RoOXdmQkpXMnEvekhaeU1sUDN5U1dWbUhCTEgw?=
 =?utf-8?B?WWFZZUhCcE9ZQmlVWXFSRktTQ0pNVENHK1A4d29rNzRFaHJydHN2c1U1SStQ?=
 =?utf-8?B?d2piSDRoWHd5K1MvaWRBYjdrL3JEai9ZR3I1ZXNtZFViREZ6cGQwWlIwcVJW?=
 =?utf-8?B?UWNQTzdFcFB4eWVPNk54TmUvK2hpNW5MbW9sd09QYnN6T05QYVlFbnRCREd3?=
 =?utf-8?B?WEluSGd6ZGk4bXhQS1hDL2UrTndqZTh6Ymx5NmN5OVlyOEU3T0hRSzMxOUFi?=
 =?utf-8?B?eEwrOXpvb1ZLRzJVZ3NvaGJaNUtmUGF2RUpnV0RQQ3liNkx2c2MyWlZSUTd0?=
 =?utf-8?B?cnVOcWNqOW9BbzRLbjFOTDZHK29VOEw3S01VTFBHNkM0MDJNSDdZNzNTMjJB?=
 =?utf-8?B?QVM4cjc0Y2krU2I0bHJ2TFdDSE45Ung2eFdjMmtRTjFQb01XdCs3T3BOUGQ4?=
 =?utf-8?B?OXNuRGNkUmlxRGJoRzhjTlQ0dkZqaHFXUjRsYTRyVTBZK1ZpODF0Ri90K0tW?=
 =?utf-8?B?N2N3cXI0d20zWGtmZ2VsdTBMRkM5WDBWU05qY2w1YjVzeTBmdU9MWExmUTF1?=
 =?utf-8?B?TGNVMEdXenppSGlsVTI0TVd0QzBoVDZVRFFmK3dsTWdZcUl1SVU0elBrb3Fi?=
 =?utf-8?B?bHBzZERDd05LaXVQNkMySnhvYWZKc2ZMT0RXN005SFhnWGdXNzZLUUxpRzVX?=
 =?utf-8?B?NG1lVmg0cFJ5VzY2dmF0eG5RN3Q1UVFaWnBRcDRsWk0vRjhjVjBTVThRTnN0?=
 =?utf-8?B?SjJ6ZWR0Q0F3eU4rYmhHbEtuUS9nUGMzNExQWGk5ZSt0Nk5wUVA4TTRZaUxa?=
 =?utf-8?B?SzZVL28wUkErYWNpOExpZ3FQMU95ZDU4aU03ME5RMllCVUNIbSs0eGZ2Rnlw?=
 =?utf-8?B?TjlOQzFWZVZUMlROSjJneU1aTEs3S1pYWGtxZ3RmTnJIaTIza2lPTnFGN3Vz?=
 =?utf-8?B?TzFZaEFZam9zUGEzWGxRTDJvSFBqc3NScVpXV1o2UGkvNWRuSnZ4YW8zYzF6?=
 =?utf-8?B?ZlFjcmR3SXdaejN0ZHNDMUFkZWVTS3ljWmc2SjNMOFFzZWxBdTRkYzhvb1ZZ?=
 =?utf-8?B?ZmloSHYwS0QxRysyYjBocUVaRktRUnh1MWhQb0ZRWnArR3JZaUtOOTRpT0t0?=
 =?utf-8?B?d2lTOVJhTDJSQXR6NW1hSDhkS1JpemhsU0Qxa3BzTnR3cCtNNnpldm9lOFRP?=
 =?utf-8?B?MkVJdTVXM0d0WVpqVm5OZVQ4Tlk1alhienJ5Zkw0L0RxcEZSbUp0R01OdkVp?=
 =?utf-8?B?MjFaam5wN01GS3JZT0wyWnE5RDhYc0N5L3BOcWNnSXdWYzRGVE4zVDFndzlo?=
 =?utf-8?B?SG84WCswb3RCb1o1a1htUkorZEhIMmRDVFdWYnRad3NrUm1rN0xkaHBlaUVK?=
 =?utf-8?B?OUV5SGJBTUh5dzVHQzNCY0ZtZXpXTlhhNWNNelR6WWQ3bE5lT2RtVkdoSEdh?=
 =?utf-8?B?Y0Mza04ybStoNjIwdEdsYlVrK0x4ZmF3SHU5bGFzYWthVlhzOW9QY2txL0xo?=
 =?utf-8?B?SXVmWVdJNkNzSGJWUWI5S2plc1hSY01TNGs1WEg5SC9BTHd0Rmg2K2JEKzA5?=
 =?utf-8?B?Z1JieEtrK09xcWU3a1FDbzhqTHB4a00wdndqWjFCcUh1LzlIU0ExQ0lITzE5?=
 =?utf-8?B?bGRUblJTZHIwbEJ5ZUdIaWZnam5sZFkwemNvOFRWRVRwb2ZyK0xRU0t5eXR6?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5521c132-2fef-4af3-1b02-08dde00290ff
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB7198.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Aug 2025 15:59:38.6058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UxJn7iEZSRi7Y1py8/PhddoKyaa7TtqBplX6SaDi2/hqxC4nxZC/AWsshCIdlE/o8nn16xhGshh+u3tEe9BCRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6653
X-OriginatorOrg: intel.com

On 19/08/2025 21:03, Luck, Tony wrote:
>> For struct mce?  Maybe that should be 2 new fields:
>>
>> 	__u64 addr;		/* Deprecated */
>> 	...
>> 	__u64 mci_addr;		/* Bank's MCi_ADDR MSR */
>> 	__u64 phys_addr;	/* Physical address */
> 
> Would "addr" keep the current (low bits masked, high bits preserved) value?

Yeah, it wouldn't make much sense if phys_addr was the same as addr anyway.
Not really thinking


