Return-Path: <kvm+bounces-23471-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C0C7D949F3D
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 07:39:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DCAFC1C228FF
	for <lists+kvm@lfdr.de>; Wed,  7 Aug 2024 05:39:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FC9E19408D;
	Wed,  7 Aug 2024 05:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cAsSkht0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEED5250EC;
	Wed,  7 Aug 2024 05:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723009159; cv=fail; b=B1L6NnjUrzbRJKZRB3/MqBbhE7cP1HNWMbsPdvgcU3yXSvMrfwASA7XNagHnI+JGGy1Dwrp7rQNpx+liJ9HC5HThW97N5tqtS8EKlSoem3so+NS1KdN6TBATGpBz25VZ5taj3k+0EM9KOikC46c4kHuAZZoTuvcQ07lAfd84WXs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723009159; c=relaxed/simple;
	bh=8ckIxnmgDXK0p8kQfjyVthqgYXZTiPqXo3Vya9LV97o=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=CBtq8DIIRA6tSaJDV/SsAheYd9vGxFKx4Pmvxobm1vdilXBEDQTKpNeEiZe378R4GopN9zaMup+AnIv5lHHArO1vEtjiugZUR+sOsSw7IhNjyOZ2fCzyzgH8JYvTs6EsNl2/7j/ZDsaGw8bYujAj75qZ9KlZckG//yrxfZM08Zk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cAsSkht0; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723009158; x=1754545158;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=8ckIxnmgDXK0p8kQfjyVthqgYXZTiPqXo3Vya9LV97o=;
  b=cAsSkht0rFuZV018qzng2UpcK0K0f3LB33uDqD6vmb8EAr2mwly1T4yr
   pJhYy//OU0dQkpwW83XxgQFmAQXthhIz3QDe0xcB04P059zCa1wWgzQik
   0PMvr20Q4uOKzMNIp2WXvTvtb5VTXPrGZiB+KNO62U9Xr3kWsrtvoKsLI
   PGvFqqM7WaLI3C8eKblB6AIGr11m1iHZdiHW97LuUVinWWekxfkwhi5nO
   sgyUkVR7mJmTxDM+393F+TqNhUFreolasP5h0RKeaSm3JMpMkTv+EC5Oc
   0hi+zvzrJzMkivZaCAIzeuWRYrMs9hR3YgYiFK+b5mc3c4+EcKh86p5M9
   g==;
X-CSE-ConnectionGUID: JW9Yw8HZQ+GGeYYjnlLewg==
X-CSE-MsgGUID: VZ0BTl9TQQyJ1f7ayOi8zw==
X-IronPort-AV: E=McAfee;i="6700,10204,11156"; a="21232344"
X-IronPort-AV: E=Sophos;i="6.09,269,1716274800"; 
   d="scan'208";a="21232344"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Aug 2024 22:39:17 -0700
X-CSE-ConnectionGUID: 5JwL0zduTpmpSLu2KlsL+Q==
X-CSE-MsgGUID: k6M9ZYb1R5yL4z4zbX/NIA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,269,1716274800"; 
   d="scan'208";a="61554189"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa003.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 Aug 2024 22:39:16 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 22:39:15 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 6 Aug 2024 22:39:15 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 6 Aug 2024 22:39:15 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 6 Aug 2024 22:39:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UZWJkxcsWeNgTvYvRsGziqm6GsO8ASCxqK25CwGvvvsi8zY1ZATd2xIhyfW4wWUXIO5HYX+ybJbYo93oPns5KjwJTTHU5WOAzc4JDvkpIEb6NT79Klkx1qKCTkttD42DZ4L3ib/jcmDXjIMx0L4E8FwrRqsUC5WptNiXdraAhaleOqxUDTRLcbFfAcdDL5f7VXnfiEx8nPDlkVWFNpb+v/EtnITyV/Y3k414Uc5z2WimnIehZjZ858hdWoGLGZvh5R3EBjny5FskXsHsJnHmjWll1WlNOmwyvs/IiGaiWRsdgk8TQxuqkbqMqBNDGESifBOQ3Wr8XEiZT0ERj/Dolg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ckIxnmgDXK0p8kQfjyVthqgYXZTiPqXo3Vya9LV97o=;
 b=W6awci/2sU5MjKCXHI2fygKLP2er5YNeBzpisG3rrl7pZRxUuGFiTEMDSRE+LXseI9+B0pGtju5D1SOciO4htxdKHQcb0q0xFkMcbQf9piP82Lg00i+fmFSIz/LUBBdueGnCScQOge1ebS8+Xreeuou7OjEh7qUYBKqwcSZubatcbOuILzghcJbdsMNNiIlIhABcc5COXuptSfRlvNW86pGFRO5MhlDxlZKensJNNBZmePSbVNtdqEDe7dE4vsDz5slsIcznA7vEsTyxbAmHmO6JyS4dJc/0nVoVHB4o4tOrfcL9jGBEXdNu1SCOUBffkttrEgU44szBjX9iacshiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA1PR11MB8278.namprd11.prod.outlook.com (2603:10b6:806:25b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7807.28; Wed, 7 Aug
 2024 05:39:12 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%7]) with mapi id 15.20.7828.023; Wed, 7 Aug 2024
 05:39:12 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Clean up function comments for dirty
 logging APIs
Thread-Topic: [PATCH v2] KVM: x86/mmu: Clean up function comments for dirty
 logging APIs
Thread-Index: AQHa5RlxRJmAlLgzgEeFWCdKG32ojrIbTgsA
Date: Wed, 7 Aug 2024 05:39:12 +0000
Message-ID: <a718181481f73f0210b55c0e8333b86f8f5f2052.camel@intel.com>
References: <20240802202006.340854-1-seanjc@google.com>
In-Reply-To: <20240802202006.340854-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.3 (3.52.3-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA1PR11MB8278:EE_
x-ms-office365-filtering-correlation-id: e58713cd-180a-4437-824b-08dcb6a34468
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?VVROcDZBTjR1NVFrR1lQOCtETUFwRVR6L3RGcGJLWDRUcWJLdDZTeVpFYWdy?=
 =?utf-8?B?R3U1NjMzSWpBUnFNdk4wemZ3OEtlSWREc09WMDFta3FOTCtKUTRFb2VZRVpC?=
 =?utf-8?B?UHhIVlV0WUtNZ3RIblAvenVuM1RKZDlyVUJ2dTJOczRIZXNmQzJ4V3ZWT3Jm?=
 =?utf-8?B?UU5EZlNYcWtySXNWOFhscGJUeTV1N0xwVjYxMlplMkV5WEF0UGJTQkxEcTRS?=
 =?utf-8?B?OUdhUmJoYnVKOVdlV2NHTjgzdEJaTktBeE9HNHVNTm90UTI5WmgySkt1amFv?=
 =?utf-8?B?alFJdkczeU44MGFmTy9TN28zOWptdW9KSjJqMHVNWTNkYmN4ZGE3K2QzUWY0?=
 =?utf-8?B?TUhKc3cwZEdRQjdncTgyT0FJZ085VXJvRGdRTExQNkd1ZTdsYTlMUk4wTWNH?=
 =?utf-8?B?OUpCdnJLOElZOWFaV2VUQWpRTmlDelZBRmhQRThaYWtwT096VnhZbno0N0l0?=
 =?utf-8?B?akpOWGpINEZ6SWFXbmtrT1B1YzhqQkt2VUVpQ0h0bUhUVG1waldWMWVSa01y?=
 =?utf-8?B?TDRySTEyczhjMVlWTEVmOU5JQmo5czVsdEVYTmxhWGlicXJScHkyZXJONStO?=
 =?utf-8?B?OENDdUp3Qm9RblcxT2lIa2dOTXllUy90ZXU1RWZXdHVVQ2t3YytMdlFYMklj?=
 =?utf-8?B?Mm9pK1VHOFQwaklZazNpUVVXMnR6aEx4K1VEcktoQjNKYi9FbjhRQ0I3TGN5?=
 =?utf-8?B?b2p4akJyeHB4aU1zNmNxNU05V0dHRmExQTJwUFBMTXd3Y3c1SUQ5UVVMb2Rm?=
 =?utf-8?B?elhDcm9Pc3I4TW1uN0F4c0FFTk52VUYvWG14aE55Snp2M2ZpK2NzY0EzWi9x?=
 =?utf-8?B?UzBWYTNZSjIvRlRNNWtGYjAvVCtaQVhMZUszUTNFakdud0hNWmkzZklqU200?=
 =?utf-8?B?WGtaRUtkUnhaSHlBMlNrdTBXV0syMUdkbVFKT3dzT2VOMHN4dEdCSDNuUVRw?=
 =?utf-8?B?V3ZFRmxsbXAvam84VC9ZaWdXaXFaZWxZUzNZa2xHOGxqV1lKMEpZWW96S2tx?=
 =?utf-8?B?UERTWGpZVk1IYXVHNWZVQ0dIdHdhbklJTUh6U3ZzaVlReXFiOEltREY2bUI2?=
 =?utf-8?B?OTNDZW5oU3IrWlk1Mzh3VDFnZ2tadkRibnNZZ0laQ2E5ZjFFaGZ2aVJKU2pR?=
 =?utf-8?B?R1l4K1NadzhybXE2a2NCa25RakpZVDg0SWNSbEQvSXdPejZzM1VRRnA4TEE5?=
 =?utf-8?B?em5KbkEwbWV5MGdHV2NESWtkeVpBTVVjY0NiNng2TTNWMTdnd0VhdFRrVzB4?=
 =?utf-8?B?ZEx2UThwTXlnamFwL0k4MUJ6aFlSMHpWK2hzRmwxdFdmUmlKZlZDMml3MHFl?=
 =?utf-8?B?TnZ1aFlKelZwWEpYN2ZqS1JjQXlOVFlHTjJmd09qcm5oZ2haMEdUcDJCL09Y?=
 =?utf-8?B?Q2FPVmhYNTJrV01MYXNnbG5RUU9IODJBMURHSmxiYzdqL0FpdndjQm41U1hM?=
 =?utf-8?B?cnhWRExqemRMb2JyMG8zaEpreU9FbFQzR3UxRENWeUNTdFgwWGYrbkR2dEFU?=
 =?utf-8?B?QVRxaW9wLzdXSXhOdDB1YkEzdFJ4cXlTdStVYlIvcGtnKzlxTTZKaGVnZ2xI?=
 =?utf-8?B?eFluMktVaTdPRlA1SVMvTUtYODNVV1dJZGJXYWhnRndHZEFPZFh3SlM3enVY?=
 =?utf-8?B?cklFb0RpRXJvVDQranE3Qm13R0lpNE1Ta1BPRTROeDUwa1pNNTBmT2ZTa2Y4?=
 =?utf-8?B?ME1tNXp4b0JFVTlKbWwvKytZOE5JMmhpSW9pYVh2ZHJjRnhEQUlyNkJLNjNO?=
 =?utf-8?B?TjlwNGkrcVp6dDNWZXVQbS9aK01yRjV5d3E4NkVMb2NIUWY0OER0bE13TUFB?=
 =?utf-8?B?ZzBLREpCQXN0d2svOFNKR2Ftb2F6K0c5aE1KWEVqUXNzT1UzY2JPS0lCVVY1?=
 =?utf-8?B?UXhlWllKejQzYTRnSHZwdjZmVjYva3h3RlFFRy9SbHltcGc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SEgxT1NhdklSRlVjOUdMeERyeldySE5scERadUZIMEh2aUZqbk1xbW44bUl2?=
 =?utf-8?B?YldRY3pRZ1RuT0dseFNsbVArQ3k5cmRNUTBhOWtXWVlKSWY1OStJQVZRajli?=
 =?utf-8?B?WmRMT0szZUhOa2tadkdaTllKeFhLbm84TThxaXhsVUZjUVhZWnk3QjFoWWdC?=
 =?utf-8?B?dm9CY3pTRlFwMStxRG1EY2YvWUx3Qlg4elZLbDhla2hnR1lqeDlxUmY0Y0tM?=
 =?utf-8?B?V0VDT0ZZdURGR2h5cjRXdVZ5U0Rob1E2ZTU1T3NlNzhIeDJNTEE4SjFZSnhX?=
 =?utf-8?B?VEdHTHh0Zll1NEpMcXdHSnlhb2FjbzNvTzRFdG1TcGxaczc3SENhenpkVVV5?=
 =?utf-8?B?dHZnUTlBTHErWC91UnVMUHE4S3d2NE03TkdvbDJSZmJtamRMaURQZkFhVlZ3?=
 =?utf-8?B?ckVLaDJJRzdyQ2JEY096UjFpRHlyNis0K3lxRElOclRRUFNvdVdJM284VHhn?=
 =?utf-8?B?cDV0NUFmNnRKQ1hSUExhTkwvaXQzcUhoa2JLaVdWMk4yOEorRGpTTFVsWk9I?=
 =?utf-8?B?eFZVOEhoSjdUQWY5UXVQVUwyUzZML0NNejlDbWo0QVJGejlldW8vb1RjV1p5?=
 =?utf-8?B?Sm9iMzNuWGVQVDlKbTQ4Vm5xNjRZQkVWa0xUSXN4VDlQSEdSUjZWVjFrd1cx?=
 =?utf-8?B?VC9qL3RGcG1KbERPSU1XQVhHbENZb0o1cmNnZzdhUE5qNUFhbVpaOUVQdE5M?=
 =?utf-8?B?bHRmZ0hTbTB5M0FOcWNYKzdpZklTOGFERk8wR1BETkVFVTVsTFpwR0hUYnZo?=
 =?utf-8?B?b1Q0QnBYTEhEQzlLR3FVQzB5cTF6bEpraVNGRzM1czlUQ3MzOTVBKzdHODdz?=
 =?utf-8?B?UDR2TlVOWVllemE1WjRDa1pVTyszWENqeWltTVlIaks3eHdPcXB1bWtaM2Zt?=
 =?utf-8?B?Y1A2ZG0xbDVhZG5SWHBEdnN1N2tTamRzWWhLQm5JeHplQWVoekcvNUJPMVQy?=
 =?utf-8?B?TXM0Z2tHMFFUZ2NFa0ZqRjYwTW5oSmgyNGlqRUp3T3VXM3Y5NzM4N3ZqLzFI?=
 =?utf-8?B?T1hsZC9VWEdray9WWHNjOVlTaUdCdXJseVBrcFR2M1NzMExCV2F0SHE2MDQz?=
 =?utf-8?B?SzdXWG14Vk9xQndOZk44L2J0VXRWNmlzRkkwQU8yczZiRW1kRzBmKzZ4dWpt?=
 =?utf-8?B?N2lUcXNhZ05NdGFTL3dnV1FIRXpzVStJZ0ZMYlFRZFRSTHpPbDFTVDE5ODNq?=
 =?utf-8?B?am9aU0RtVHlxNnJPUmRyb3dXalMwU09Jbzl6dHFpSkVsSWdHc09kU0lsZHZE?=
 =?utf-8?B?OFJUK2dURjEvQzNGVndzZXorUHJCTUtodHN2WXhSR214SmhqQS8zOWtyQzIw?=
 =?utf-8?B?eVpJMU1PWTVNbFJPRDg2aDVLVDBxeXB6M0g2Z0Z6dHF5Wm9Dd21WUW5XYUth?=
 =?utf-8?B?a0NCeEpwTEx2dk83Z096Z2xFc0xNQzN2WmN3Wmw5MlBzMm1maDRNbWFQMXlR?=
 =?utf-8?B?WFpUT21NYWtxR0hydGZyUTRKNmhNaitYSFdxd3BIVTVRSlhYSkkzdm5rSkww?=
 =?utf-8?B?UWJCVThQaVUyd096eUo4MFNCME9Ta0VsK1VlNWl3c1U3a1lmclVqNUZPeDBr?=
 =?utf-8?B?bFVVVkh3MjFqQ2FYWkJ3MjY2SnVzUE1zZjRSbi9IclUwUW5RV0l1QUd3djNQ?=
 =?utf-8?B?S0M1V0ZsZm5YZDd6TGRBOVU0UmxRcmNLQ3BLZTFoWkN0Z1dsY3QrN3ZrTWlO?=
 =?utf-8?B?cWNwZWFBWEFZbjdzZDlsWFM5dmEzZExQN2UrWHIrRC9VTzNHbDBJNmd3MHVF?=
 =?utf-8?B?Z0VMeHF6UlE2ZUxxMzFDNDBabWc1bkpmaG5EUEQ1SzIxbVZYd1dOUDFBNzlx?=
 =?utf-8?B?MmFUcisxQXFUZ0Z6bTArbmFnYWN5c3d1L3ROQ0ErTVhqbXZvZzk2SzJVWXow?=
 =?utf-8?B?Zng0YmRMQ0lNUTdqNDEvZTU3WW10K1BWbWhhZjEvYzJZTXpTSTJmVVBPTS9p?=
 =?utf-8?B?S1VPbFJWUjZsNVRyTEZXVU41c3VHZTB6SzhNSlV1SGVHWENPVkp5RnFHSGJk?=
 =?utf-8?B?N1gyeXA1RUdhcFBKQ2cwdEFiZGJ2eHdPSWxRY0ZhSDZIMmJMUEFlU1ovRjcv?=
 =?utf-8?B?L1hQaVlCNi9EOWlKa3o1Y2NFUWRXZ1FLYnBJSnh0WTQrdmsrdXVIR3hISGlp?=
 =?utf-8?Q?v7cPBvH0MQ6p+aRvQWjP2fJb8?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2E1216962CD6374A9223E8A4492B76EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e58713cd-180a-4437-824b-08dcb6a34468
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Aug 2024 05:39:12.2835
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CtwDcux9hzacfxr0QposvOh+aAKlpRyFgBW6cyByIic0iVsSqv8foxcPzuJDRnf5DQwTmIF097d8Zuy0BdKzuA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8278
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA4LTAyIGF0IDEzOjIwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBSZXdvcmsgdGhlIGZ1bmN0aW9uIGNvbW1lbnQgZm9yIGt2bV9hcmNoX21tdV9lbmFi
bGVfbG9nX2RpcnR5X3B0X21hc2tlZCgpDQo+IGludG8gdGhlIGJvZHkgb2YgdGhlIGZ1bmN0aW9u
LCBhcyBpdCBoYXMgZ290dGVuIGEgYml0IHN0YWxlLCBpcyBoYXJkZXIgdG8NCj4gcmVhZCB3aXRo
b3V0IHRoZSBjb2RlIGNvbnRleHQsIGFuZCBpcyB0aGUgbGFzdCBzb3VyY2Ugb2Ygd2FybmluZ3Mg
Zm9yIFc9MQ0KPiBidWlsZHMgaW4gS1ZNIHg4NiBkdWUgdG8gdXNpbmcgYSBrZXJuZWwtZG9jIGNv
bW1lbnQgd2l0aG91dCBkb2N1bWVudGluZw0KPiBhbGwgcGFyYW1ldGVycy4NCj4gDQo+IE9wcG9y
dHVuaXN0aWNhbGx5IHN1YnN1bWUgdGhlIGZ1bmN0aW9ucyBjb21tZW50cyBmb3INCj4ga3ZtX21t
dV93cml0ZV9wcm90ZWN0X3B0X21hc2tlZCgpIGFuZCBrdm1fbW11X2NsZWFyX2RpcnR5X3B0X21h
c2tlZCgpLCBhcw0KPiB0aGVyZSBpcyBubyB2YWx1ZSBpbiByZWd1cmdpdGF0aW5nIHNpbWlsYXIg
aW5mb3JtYXRpb24gYXQgYSBoaWdoZXIgbGV2ZWwsDQo+IGFuZCBjYXB0dXJpbmcgdGhlIGRpZmZl
cmVuY2VzIGJldHdlZW4gd3JpdGUtcHJvdGVjdGlvbiBhbmQgUE1MLWJhc2VkIGRpcnR5DQo+IGxv
Z2dpbmcgaXMgYmVzdCBkb25lIGluIGEgY29tbW9uIGxvY2F0aW9uLg0KPiANCj4gTm8gZnVuY3Rp
b25hbCBjaGFuZ2UgaW50ZW5kZWQuDQo+IA0KPiBDYzogRGF2aWQgTWF0bGFjayA8ZG1hdGxhY2tA
Z29vZ2xlLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNvbiA8c2Vhbmpj
QGdvb2dsZS5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50
ZWwuY29tPg0KDQpbLi4uXQ0KDQo+ICANCj4gLQkvKiBOb3cgaGFuZGxlIDRLIFBURXMuICAqLw0K
PiArCS8qDQo+ICsJICogKFJlKUVuYWJsZSBkaXJ0eSBsb2dnaW5nIGZvciBhbGwgNEtpQiBTUFRF
cyB0aGF0IG1hcCB0aGUgR0ZOcyBpbg0KPiArCSAqIG1hc2suICBJZiBQTUwgaXMgZW5hYmxlZCBh
bmQgdGhlIGFuZCB0aGUgR0ZOIGRvZXNuJ3QgbmVlZCB0byBiZQ0KCQkJCSAgICAgICAgICAgIF4N
CgkJCQkJZG91YmxlICJhbmQgdGhlIg0KDQo=

