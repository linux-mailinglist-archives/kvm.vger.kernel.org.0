Return-Path: <kvm+bounces-14176-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E61558A03EA
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 01:16:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15EC21C217EC
	for <lists+kvm@lfdr.de>; Wed, 10 Apr 2024 23:16:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EB371DFC6;
	Wed, 10 Apr 2024 23:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I5/xPu4i"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD0F138E;
	Wed, 10 Apr 2024 23:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712790964; cv=fail; b=MFUBM3BhXKLcbjt6ivkJ+aut3pKRMamGtl7bWikw1Lcdl15gv5l5S2KFr7o3rnLTaRQFODDMBhqnAyUl8owni+u5SY/mKCWM+57uyyfqEZzrdFtfYS1fyd/O8Z0jUsIUkqQ/yaLDBLcY7rJMqUP+sTv4MMZyN3IAwDBkxT2djbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712790964; c=relaxed/simple;
	bh=Imra2Q2m5ZWX5R6RXhBQ9qHwmNtH+iUgubX8x/EVteo=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OWAD7QGCR7EEVBxk62wtQZmEP/JZAVFhTb+9xuGJFLybD68EZgkfrAt4Z4fgc/fje43xU1Q+1hswTTSv7gyPaUEFmKcAu9eygJvygZRSGBY8ue7xbEZ968PG6soTaaQBnVW0vTKNTWVO+GgaYo5P/rdSinfix8nExifRVTJAN/Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I5/xPu4i; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712790963; x=1744326963;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Imra2Q2m5ZWX5R6RXhBQ9qHwmNtH+iUgubX8x/EVteo=;
  b=I5/xPu4ic8gPMpZq4CQHxyUY9stVBEFrCebTvyV7aVfz9lUywMIEIUdd
   xd9mfCL35rJuNhQgwf1HtohUjXQbnwBqHfeu1mGcmtYcUirDAYSBp1Srp
   F3YiGyYXHvltdvY3uAgf5tgN+goweX2H+SftErKSC1e7v/vdTayegMhYO
   WKue6qe1QTVl0PcWPOc4c7gkHrO9gOM7x7ERv5pOv1+3PtrXOTkUy6FON
   m0Y3YZGX40DHkqQ+aMqMiWTmmgin3LBhs6fi5ZyluTES6fnYBXFzJF86K
   YHGnNIRFUGDk9HyUpxVAnUKX39Vy57/LkMNvR7lk+69ZjRSyb/OTli2//
   w==;
X-CSE-ConnectionGUID: 0Ou7g1pTSnaAtqzi5+HBRg==
X-CSE-MsgGUID: 6iGlcOsjQ7Gbls7rojjb2w==
X-IronPort-AV: E=McAfee;i="6600,9927,11039"; a="11145912"
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="11145912"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2024 16:15:58 -0700
X-CSE-ConnectionGUID: MHRLHmTkQtyNMWi3SDo4UQ==
X-CSE-MsgGUID: dSEDTcBmSiq7TzgzU023uQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,191,1708416000"; 
   d="scan'208";a="21217374"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Apr 2024 16:15:58 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 10 Apr 2024 16:15:57 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 10 Apr 2024 16:15:57 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 10 Apr 2024 16:15:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQXtg2mYaxpG/KWcAkI9xBDyyQsWq3zSeUqI+spHOn8WhbzWRr4mlHyfbN6kP+INiVsLtAFDBXm1+xUvaUZttHN4XFKuSMP/KdbQbBUgU6/KImSAeux6RNgpkPJ9SRRoSypz9F5kUnSaIZXaB9wQyrE07qDdCVFCyTf4yDr6IyDeX/6+e7SvKK0cY2ostak6ZMAtUkeuMamIX2yqte8MN+5/o7uGJfe4je42j8CXqF9ct3+PKDOHM9o8RQPuJnhYSbb/1ScjjAHvk6dm4jNTWs5By1kGeTkWroNnI9v6dDXM7BwUmwN50FocpK5laGvtlQj89VKn52GAJ/v0Q3OwzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ecFwIBU2TYa/GvMLr3MJpOuw8kVN30kWdk+fBilA0AQ=;
 b=acC64ZuRFNM33x+vjp1ACBD2jQ4+XdFeGWQQ5lOv/wNbXYevyk7XiveEp2gvSDP62A1bzKMVMKErDW3M8J9fW//YKkpX7SGUIIetCRGpz7Emm/gHy/lJMl7u4Aba7rNL3mOD9bsvof35XsdxENCJ0QlVTV/GkF2n4MEiz68aYmcqJb4EgVqldwVolEeOMbtlOyyjybO1lJiz12bzoME3Rh+pzOdqMkNgJDjsqHIDf5FlBtAcfOajGqJTMniOl62bCdgGyWZRt3+t+RroNp1IHlnfU7/hwxHT5ScQCADtML+ShrOOIyZsB2GbtpVDZqBZx0z6dyLl3COwIF+a8LUZcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by IA1PR11MB6490.namprd11.prod.outlook.com (2603:10b6:208:3a6::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Wed, 10 Apr
 2024 23:15:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7452.019; Wed, 10 Apr 2024
 23:15:54 +0000
Message-ID: <8afbb648-b105-4e04-bf90-0572f589f58c@intel.com>
Date: Thu, 11 Apr 2024 11:15:43 +1200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v19 023/130] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
To: Sean Christopherson <seanjc@google.com>
CC: "Yamahata, Isaku" <isaku.yamahata@intel.com>, "Zhang, Tina"
	<tina.zhang@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Aktas, Erdem"
	<erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
 <f028d43abeadaa3134297d28fb99f283445c0333.1708933498.git.isaku.yamahata@intel.com>
 <d45bb93fb5fc18e7cda97d587dad4a1c987496a1.camel@intel.com>
 <20240322212321.GA1994522@ls.amr.corp.intel.com>
 <461b78c38ffb3e59229caa806b6ed22e2c847b77.camel@intel.com>
 <ZhawUG0BduPVvVhN@google.com>
Content-Language: en-US
From: "Huang, Kai" <kai.huang@intel.com>
In-Reply-To: <ZhawUG0BduPVvVhN@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR04CA0214.namprd04.prod.outlook.com
 (2603:10b6:303:87::9) To BL1PR11MB5978.namprd11.prod.outlook.com
 (2603:10b6:208:385::18)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR11MB5978:EE_|IA1PR11MB6490:EE_
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fRLTELxrvjstEylR6X1gUSo2Vskuxv0/xfGERxjGxRugYfwiNQKrg69UbWQhY0YnvSfXRfZf98QOsmRRhpyVdZP3z8gdQh59+vOKC2bs3QjmdCCRNqSbY8z2RTymRFHe2sR65ipHGUrqxAA5k4ZJptxrvi0G0qD1pLh5nnWypM0SUUnTyvVkRoGq9VI3ZZeDpWOcehx/L5cOdO2qdOHpf80GXqd9+GtoI/hN/wtcZkJViISXJi6LDC16/yFiCCcEaLc+1gHAiExtRYT1Is33Iujguf+m3ERsAXyGa6qZM4SWAx/2wXCpgLmKAqR96vQ2PBKdAWfEpVBM32hDoYOxyYe+tU68MDmJha1wjzNx3cnrci2f0d6TWjv9SRb6LWp9Lx3rSskG1OGTyz2rTyB6+Vt0wB1uNoGImGZsWLhco+nZfeQHwIJ9pAcfeuZFh0C/EWth9Nx5Wvb/i4PuIj7fmi3KQwujvDTEBbD37g+dMrLrpsZs+Sg2oo8uk3LiBLHaS/5RdkouETAC+O6TXjiImOlnIrnMcM2J4S9V+sUIybuqp0wL6Bk1kj1H4eL9bsTgIqJxt7ZoEm94Yz4zRCPYpPfhhPmMkUFXr/5lB06pt52n6hsHs+ryyRT4H4td11LC31ArdL4/n43WWOl/DdiczR4/gBZ/2oQmDFxkl7nWaQQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFVEZEUxeTNvL3h1VGpkRmEzbzVKUDUreklrcjRqSDlOSjFzTjcrNkNCWHhj?=
 =?utf-8?B?NTgwUmkrZWM5Z1AxQXQzVkduY1pHNFl5eXNkMEhnMFBYZEVkK2lhSU50M0FJ?=
 =?utf-8?B?S1YwSTBudEVQaVZZYndyNzRzWmJSV0g3QzBUTThXTHpveTArWGNrQ1kvWUxl?=
 =?utf-8?B?L0NhNHZzTEVIa1Q1Q3RQa3lsM3FsS3pzSjF1Y0ZKMDNUOTdVbWt1dEpmYnRP?=
 =?utf-8?B?Wkk1VUNCSkVBQUoyYzJ4dTBVcW5vbm1kUU02aHcrZ0lDOEhudDNTb3hBSENN?=
 =?utf-8?B?bEI3WlIwOUZ3UTJ6aFlrQ0N1ZHVYSHA2c1J1dytZVDVxc1hMYkpZR3NsejlJ?=
 =?utf-8?B?WVg0WGtZbTkwejZJRXh1dzlENERkbHFqZzYxN0hRQVZxdytCdUdLZS9rYjNt?=
 =?utf-8?B?S2VYaHVqZW5yRWlqRGdxTXVPd1NUK2gwaDc5RDAvdk9OTytvMUpmOURyQWc1?=
 =?utf-8?B?dUtvYzFGTlVIY2c0SjVscEMzYXhBMDF1NTZKYzQzV1JLaHM3cEtISHloWkVO?=
 =?utf-8?B?UVUxNmdqVGd5SFM2Ty9SNnBCSFJPTlZ3STJmbFJheHZPMkJ0Lyt1TFc0SE5x?=
 =?utf-8?B?SFRFK3UyMERLejVVdmMzTjBvYXRyaU5aYk1Cb3Rhc2drNURBbWFacmozSUxh?=
 =?utf-8?B?ZHd0VUNGTm1YMm1iMHN6NjNHcVYwR1FEQVdwYW9PMVQ0RWlVdlV6cXhzMksz?=
 =?utf-8?B?c0lCM2V2YVIrLzBaeDJ1WnYwYVlLRG8yRDQ5b2d3c2FseWJ1RnZER21HcDYx?=
 =?utf-8?B?WVZ0QVkraWJjMVcwM3IwS2NFR3JESHl5YkJXd2Q5RUNvNnBTMVpjbWlhSi93?=
 =?utf-8?B?UFNxWDRtTzZxL3UxQUR5Z1NqSDNFQ1diTmg2T1QxVHladDZYUnlVekQ4NEFX?=
 =?utf-8?B?blRaZnJZdU0yVjFpZEVrK2V3UUgxL2ROZFZBT2I1WFkybDJvKzRxeGo4TjNn?=
 =?utf-8?B?OE52T0lTSXdGOWNhRmNLTzdsQ3BGb0Q2c1l6M3lhcmhzUUZjZDVBSk8vVkVC?=
 =?utf-8?B?WnhKK3E2RG5vSU1OMTRtKzZxQlRoQkQxd25WOW1ha2J5SkdmR1hNRUlkSEpn?=
 =?utf-8?B?emtBNG0wS0srclhPUzRhVnBJaUtzSGNvWU0rNEh3OEhpbDJ1UGN4ZC9kcGRZ?=
 =?utf-8?B?alJWUG8wSGs2ZjdmQVphQzR5c0ZCRnV4YUFJS3lLTGdEUnpTZk0rbHBQOFU2?=
 =?utf-8?B?Q1R3VWNkWXNrS2FmSExVRCtiK1p1ZDI2V0UraEgrcy9JQkhIVm5IVDVXSTJ1?=
 =?utf-8?B?ZUJteHcvOFNvamhkdCtzNkErVXhxQnJqL2Rmclh3TmRlaUdJa0luUWVNZ1Nm?=
 =?utf-8?B?N2xLbFRlMElTVDA4a2V5SU1FVUtWdW9GNE8zMnNNblBtTXI5MFB5RzRmMGMx?=
 =?utf-8?B?M0lKZTNnbjVUblRkenZxcS82TmgrNWVNNVRyUm83eVNFL3l0RlF6cmp5VVYw?=
 =?utf-8?B?MVhiTW1FeGxBb1R1NThsVFVmMjBDQnV4VUhwSmVGL0ZXQjllSEFCQXJqLzFE?=
 =?utf-8?B?VXVvelFDUlZ3YjZBa0RnUWxiSi96TXhBdHkrNVRuSzBoTzViL1VaY3I0VG93?=
 =?utf-8?B?cHR3SXJWMFdKdElRUXhyMFhtRHNSOERFZWN0N1JQeFlBc1pwakErSWxNbmx3?=
 =?utf-8?B?N0s4WkNUaWxxTHZSanpvVXovOU5wSjAwcTUrcUx3dUE0cU51REN1S3JBa0NP?=
 =?utf-8?B?elhTSWJjaXA3Y1pkUGVUYVgyM3ozSHR4ZCtSWXA3bHo1ZEQ0bnNHOXkvWk4v?=
 =?utf-8?B?bjIwKy8vclpSOHpVbEo3K3J0T0dKdVo0SlRQZHQ2WUdKR1Avei9tUGRRTkZL?=
 =?utf-8?B?RGlxblVtNGxpZGxIU0REaDVxaS9JUVNyWFIrUlIwbGxGV1dHRkE3Kyt3SlVC?=
 =?utf-8?B?TW8xMmhDMEVlT2JERjNZc0dTcVhTb1VxQ1BXQkdvK3dPaXFSOGNseHArVUov?=
 =?utf-8?B?ejBsSVZDZmMzOGJXRUVBbXh1Vit6bGtrRWVqZXpNOE1jdWxhWVBValh5WERT?=
 =?utf-8?B?bmNyREc4WStsbS95YWJ5S0Y5TDJvTVg1NnJwSGRLRm9GcWplWDZKczNOdWFo?=
 =?utf-8?B?WjBtaGloeElEVmRwekl2UFVJL0pld2kwc3ZHNzlHSEtUeTllS2ZKcllQZ0hV?=
 =?utf-8?Q?XOUa/dZHlRAqQeYge61bws8MX?=
X-MS-Exchange-CrossTenant-Network-Message-Id: fdfe53ce-8752-474e-e23c-08dc59b42b85
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2024 23:15:54.1243
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fkXOmBLO9Rl7SK8oqS/iWRraz4exxs0vECW5Iy4s4WIOq2ek8KJjodey6IR1RgySV0457jEfnvfuiEyYEtyfSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6490
X-OriginatorOrg: intel.com



On 11/04/2024 3:29 am, Sean Christopherson wrote:
> On Wed, Apr 10, 2024, Kai Huang wrote:
>> On Fri, 2024-03-22 at 14:23 -0700, Isaku Yamahata wrote:
>>>>> +	r = atomic_read(&enable.err);
>>>>> +	if (!r)
>>>>> +		r = tdx_module_setup();
>>>>> +	else
>>>>> +		r = -EIO;
>>>>> +	on_each_cpu(vmx_off, &enable.enabled, true);
>>>>> +	cpus_read_unlock();
>>>>> +	free_cpumask_var(enable.enabled);
>>>>> +
>>>>> +out:
>>>>> +	return r;
>>>>> +}
>>>>
>>>> At last, I think there's one problem here:
>>>>
>>>> KVM actually only registers CPU hotplug callback in kvm_init(), which happens
>>>> way after tdx_hardware_setup().
>>>>
>>>> What happens if any CPU goes online *BETWEEN* tdx_hardware_setup() and
>>>> kvm_init()?
>>>>
>>>> Looks we have two options:
>>>>
>>>> 1) move registering CPU hotplug callback before tdx_hardware_setup(), or
>>>> 2) we need to disable CPU hotplug until callbacks have been registered.
> 
> This is all so dumb (not TDX, the current state of KVM).  All of the hardware
> enabling crud is pointless complex inherited from misguided, decade old paranoia
> that led to the decision to enable VMX if and only if VMs are running.  Enabling
> VMX doesn't make the system less secure, and the insane dances we are doing to
> do VMXON on-demand makes everything *more* fragile.
> 
> And all of this complexity really was driven by VMX, enabling virtualization for
> every other vendor, including AMD/SVM, is completely uninteresting.  Forcing other
> architectures/vendors to take on yet more complexity doesn't make any sense.

Ah, I actually preferred this solution, but I was trying to follow your 
suggestion here:

https://lore.kernel.org/lkml/ZW6FRBnOwYV-UCkY@google.com/

form which I interpreted you didn't like always having VMX enabled when 
KVM is present. :-)

> 
> Barely tested, and other architectures would need to be converted, but I don't
> see any obvious reasons why we can't simply enable virtualization when the module
> is loaded.
> 
> The diffstat pretty much says it all.

Thanks a lot for the code!

I can certainly follow up with this and generate a reviewable patchset 
if I can confirm with you that this is what you want?

