Return-Path: <kvm+bounces-16716-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 73A668BCC81
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 12:59:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DF2B01F21CEA
	for <lists+kvm@lfdr.de>; Mon,  6 May 2024 10:59:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49812142E80;
	Mon,  6 May 2024 10:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ovc0OH5q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31497142E6B;
	Mon,  6 May 2024 10:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714993161; cv=fail; b=a315ZSZCRkscKruqHf4z2rs9bQu3MgLPx39KVxPGP05DB1WAzlFhyNV9H9cC+kWhvgetQkNLoY4WC4ixer+cxwJm8u+wQR7717MptVR8R7Hoar5jT/NzZDYCjrWxuBDZl3srtG4C4NxrNNH7mkTfazaY+HGZv4M3wz4Ds9I0/8Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714993161; c=relaxed/simple;
	bh=5673EEzZe1xlVDTUtJUD/rY7HjfFs3OC3U70RY0q6RQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Q7clulwooSNteUL4xJXjaHF69HobiFy39b6DtRGLPSbILZb3uhj0CU6UurA5Jkj0A5QpG1N6HEC3qbpoOjt8uFJNA7nDgm906V5u0ilnr2y3z9QoUdS0Ql/88mPXOdBgxEmrfw9cxOC5DtG5TSyPN/ZYe1JgzV+TSgVv7Ca0Sbw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ovc0OH5q; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714993159; x=1746529159;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5673EEzZe1xlVDTUtJUD/rY7HjfFs3OC3U70RY0q6RQ=;
  b=Ovc0OH5qbuWqp4tUUL/7AojcJHbOK5VsyEo9yMGnLM8BuvxLppkEb3+L
   LsvLyUZSjNEBo7O30SakFo4DCUmXK6bBan7qawJ68sipLn/KKCpT0uym9
   byBggvny9Lye1z3d28RdRP//mo9L6ZXvMF4D8qVISU6S+aWm2QrRMjCi6
   Z3naAfZojYJxIpkZs9f7y02wx673j+xB9bOTOZEMstyG6cfHtSLUGwr9J
   IrhBwM2jUDjujZRnANPrTgk8HG/GrDTJ+UFzdJbqCedzUerf9rhwUpJl5
   SVIuGJDcgif4SX9z8IK9zMSInNZyiIUysyyKnMcl4MMLe1Df8LdQT2w12
   w==;
X-CSE-ConnectionGUID: LR7+BeVJSOmdLGKKKycjXQ==
X-CSE-MsgGUID: Ju0xfHkqR+qQxxzpC7KhNQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11064"; a="21886305"
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="21886305"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 03:59:18 -0700
X-CSE-ConnectionGUID: Xo3Csr9fTdCeLz5CdDwCPQ==
X-CSE-MsgGUID: oesI8Xw8SA25xA0QoPyBZg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,258,1708416000"; 
   d="scan'208";a="28008449"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 06 May 2024 03:59:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 6 May 2024 03:59:18 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 6 May 2024 03:59:18 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 6 May 2024 03:59:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CYVMkeOF/yaM3CwMKt30/xreukP6o1xm8bsWLtAMGpozb6yDSqM6Wv4iK1BBUHq+EIeoAXB/kr57Ohre1jYKtaTtzeKsQ0GFUJT3cfORWvIDB+FxOZa8O5k5TzFh1ENnvXuyVq7knXspAFEYdQEeZgaIVe/2wq2/fefIql/3zv03QMtINMoXqLgLSuai09C520sdLGOl2p6hMxRjlprgHyhcI31HrjwRO97yPJje3ZREUJCqP6yXNpa0jMmI1MyAifmumVyna2HRMuwpe01GRFvK3GDKDhUc4/cd9h1TlQG+KneTeOvl04R9CfHoPwK89AlulsNKzb0lua7bCrRW0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5673EEzZe1xlVDTUtJUD/rY7HjfFs3OC3U70RY0q6RQ=;
 b=J3lalaHOffWbuZdt4JETWM4he26BkZrTydyne/1qJstKUqKcW3J1//y4CdwyXfsSKcNi2qjrTHc8JnWfd2ocEO1yq84Xn4xEf8l2MKyoZ4qEv57xJwSmKKUK3naVHjQ9HlnRV40wlmE73szKVfmlCBs1uVDMP7VJprG3m/d7eaVckj76USbt8YvGv2WEJkzsHc+ty/hTBto7O6RBd5+oJB2ECxvkQG9taVdpOpbxCQihIodX5XXV7w8t7mBxhALPLEk2yE2Oga7ia9J5v6Md1J5iTc7IiI7CZQWLCcgin/iDELweZPuxh4NgcasYBMkvi8AOQejxBxonenpSla+Y0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by PH0PR11MB5949.namprd11.prod.outlook.com (2603:10b6:510:144::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.41; Mon, 6 May
 2024 10:59:16 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.041; Mon, 6 May 2024
 10:59:15 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>
CC: "Hansen, Dave" <dave.hansen@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>, "x86@kernel.org"
	<x86@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "jgross@suse.com" <jgross@suse.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Topic: [PATCH 4/5] x86/virt/tdx: Support global metadata read for all
 element sizes
Thread-Index: AQHaa8JL7v9VUJLZkEWqE5TMIeieHbGFB4kAgAAPaACAALc+gIAABIUAgABmXoCABDhEAA==
Date: Mon, 6 May 2024 10:59:15 +0000
Message-ID: <0c72ebbaa1add993bad258153304a4d6eac59456.camel@intel.com>
References: <cover.1709288433.git.kai.huang@intel.com>
	 <17f1c66ae6360b14f175c45aa486f4bdcf6e0a20.1709288433.git.kai.huang@intel.com>
	 <c4f63ccb75dea5f8d62ec0fef928c08e5d4d632e.camel@intel.com>
	 <45eb11ba-8868-4a92-9d02-a33f4279d705@intel.com>
	 <16a8d8dc15b9afd6948a4f3913be568caeff074b.camel@intel.com>
	 <fb829c94a45f246eac0dd869478e0dcfc965232b.camel@intel.com>
	 <ba2b0efa804c26034118c61f1eb6f335fc4cf02d.camel@intel.com>
In-Reply-To: <ba2b0efa804c26034118c61f1eb6f335fc4cf02d.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|PH0PR11MB5949:EE_
x-ms-office365-filtering-correlation-id: 38f259b0-92d2-438f-1c69-08dc6dbb9204
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|7416005|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NDlYQVo4STlJdUlMeUlDWXN2M3VWdWhsZ3ZmVXR2RHZySU1oVG5oMVY5MFB6?=
 =?utf-8?B?TWFGNkJQM01UQ0cvRlhBdGVLU1FMamc2UTNBMHdpaW1hL09MZkltMS96K3pN?=
 =?utf-8?B?UmZINGVLQU9KOEFlUllnT3BFWXFrRHB6NDE4c1JHOXY2c045RXg3cm5kZ2ls?=
 =?utf-8?B?T0x6M0ptQkFzTXVHVlhlb05EVzN1ZFpIaVR1Vmw5Sk5rc1ZndDl5MkgxTHFJ?=
 =?utf-8?B?eUYxaGZPbzYvaHBWZ24zOXJzMVFxOW16UVFuU05LOFo4ZVNPSjhLeEk4SGs1?=
 =?utf-8?B?ZjVaYzF4MUh3NGEwTVoxZnNwdElCMExUUVVJbEhVZU4xUFNMWGw0Q09vVkFa?=
 =?utf-8?B?TWF3dVEySk5kZXdPdmJjMGozWWR4T0NjNVpsNXVCZHBWaGM0ejcva0lScEln?=
 =?utf-8?B?QUJGaTJzMlJhcnVvM0tHSjJLRWx1bDRUcnVOeldlbC9HaVV6SU16a0xrNDRq?=
 =?utf-8?B?TUJGMStsaWpMME5Ra1RhLyt6RDFrLzBpS3JWbXBuREFtRVVSWkxEQll5WnJH?=
 =?utf-8?B?dWg3ZGIxSmFWcXU4cTdKSnY5YVZ1aENhWlU3U1BLYWZHWi9FbXkzNTlkWWsx?=
 =?utf-8?B?SlBDbXpzOXdLNVJQcnBheE5GbTV2S2dQMXZjSHJLa3I3ejNhd3doS3hvUyt5?=
 =?utf-8?B?Q1VsWUZML0IwQ1BqOU9qdk9VbVBudU9nNDNCbkxyclJLQzJWUXlyZGRLWi9D?=
 =?utf-8?B?LzlRdDB1eEFWSEZha1FFU3AxWlhuMW9ZNlhYWSt1c0p4SjZZUmpUa2lmSVd1?=
 =?utf-8?B?b2hDTmdBalAwUXVhZi9BVVV4d1FHa3BnL1pmSUlDS1pZenNBaUxsS2Z2V09x?=
 =?utf-8?B?OWxySVE3blo5YXI0SkxvRlZaNkk1RExwVFFHTWU1WWR5d0tlRmJENXFhNy90?=
 =?utf-8?B?SEVydTBodCtmbWhkSGxhakhFZFhraG1pbXFqZHZWWEQrazNCcVZoTS9Ybklm?=
 =?utf-8?B?cUtyOXY3K3hQeENWUTNhaVkrbXcyZThCeWR5ZzN1d1NPMHJKUktMVW44THg3?=
 =?utf-8?B?UlczVDFFeTU0cDlKVVA1L1FnSUY2M0taMitpSURUQjM4YllZaTJKZTk5dWxl?=
 =?utf-8?B?TEF2cFpCTXZFeE9ZVDlodjRqc1NnaFA0SHpaREg5QU8zdHVqRHQvbVJmTE9P?=
 =?utf-8?B?TUVSaXNDckgwblJsQ2VYSllFYjBjWVE4ZGdPRCtQaFhUK0ViMFpTbHVjeWV2?=
 =?utf-8?B?S1BhV0dIRlhIMnlaOHI5cDA1WENlaHhRNnpqZGhGaG1kZm9leTEycTBuVEdW?=
 =?utf-8?B?WWFiQi9mMWRuTzZtd3pNUGRUSFQ4U00vanNNeTl2aVdmTjhqOEZOQVYvY2Ns?=
 =?utf-8?B?YXM5ZGV2M3Y5SHk1c2JQSHhjeW03c2ZZcTk5TWFkNFdvdGJiNkh2dDRBZGNK?=
 =?utf-8?B?b0N2Z0IrME9UeEFMbjZiZUhlenE2NjI2NW1oN3l0UlF2MW9LK3ltYUJ2NGh5?=
 =?utf-8?B?ZkpNTFhKOGNxN0tWeTZWRFM4Yk5KUnhEUERXdmhsQzVzVGN3d25aTmRvKzd0?=
 =?utf-8?B?VCtXRGh6RHhwcTdOay9KUnFpaW1XZnVzL0hrWWNWdzFzNXk4L3EyVmZ5eFlR?=
 =?utf-8?B?Wm9ITHRQUjdrbm42dkdZd29aRFVlYzFoNmZ0WXY0L2JlbnlmS3cvdVlNaWpk?=
 =?utf-8?B?N3gwOFlsbys2SUpTOHNxQWJNaTJpU3dkQ1hGU1Fzc09VaG9TUWZ1b0lkaUla?=
 =?utf-8?B?YkRUN1dNSzBBeHlNQnJMQjM4WnJrakFseFlWa2lmVDZIMFlnY281MXd0U0pJ?=
 =?utf-8?B?SzJ1OHJ6VU1Ta3BuRE9ZSy8rSXE0WlBQTEdaTjB5SjlFU2FZNGZqRHkzdzNV?=
 =?utf-8?B?bkp6TnNMQ1FLM3VmdWxVUT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(7416005)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eXJUdWk0SlFuRGZnM296bm10eDh3SUtuSXErKzJEeWJwM3lFWDhaTldYeC9S?=
 =?utf-8?B?Rk4wUGtha1VZSnM5Wk9ENUFWbEp0d2d3NkZnRGoya3BRRlFpbi9NRWJOd0F3?=
 =?utf-8?B?ZWZ4OERBMlg1NU9PMXVQNGNTQUZ4RGF0aEU2cCtUMk9MZTd3MGdGVUc2cHda?=
 =?utf-8?B?UmU0cjQwQXI1UHY5ZUsweW5VNkFBbFFsa05PN0g0TjlsYlAxaFFiNTgwMWk3?=
 =?utf-8?B?QzZ2Q3VnYTVKMG40MFNJckFTNzFsM0NUUmZ5RUVRNjQ4NnRlT2ZFUDlqL0F4?=
 =?utf-8?B?d0dBeElya3R3cUYyc3ZmbW42SHVUZVRsenkxdzFFT0NhK1U3ZmdudzBmWlQy?=
 =?utf-8?B?Y3MvMnRBcGJlbTZZR0F6em9CdEFpODJzK3Q5N2xvdXlWS2ZXQllYWiszOFdN?=
 =?utf-8?B?L1JrUDZGNkdjQkgwc2o4WjBJKzBmRzMxbTEweElXcEo2bUdpemRwK0lsSkVS?=
 =?utf-8?B?MzZyMnVCRnpWK0UvY1R3NlFvM09QMEFjODZCbi92dmQwc0JJWklwRWpmd0VZ?=
 =?utf-8?B?REk3dm5Nb05NSTRjWk1hTVBpWld5dUU3NUM2blFzcnpUWUtIcXN0N0pDcUhS?=
 =?utf-8?B?OTF2TStxZDFpRkFKVWRTb041OWVCREJmeUJSNzA2U1dNNHJRa3B6azdjOGpV?=
 =?utf-8?B?VEJoTnlJdXE4ZVdRczNHcnU2OUZRMEZJWFU2WmhiQnFqVFl2NXVHK0Mva2Vt?=
 =?utf-8?B?ME1WeVZXUzVicFgxSXh0SFFZbmZxcXlRaTlLMkZjbUdTMFhnbFZFVjV4S0la?=
 =?utf-8?B?WDRiR0NpQzhYM0c1L3p0QzdmMi9lbzkvVEtNbS9vcWZGb0NrOXpFZW1YL09I?=
 =?utf-8?B?MmxPUC9mcXFySGNUZXMwYnBuaXlLd0l1ZEtjbi9XemNnZHVoVGV2TDBEVkMz?=
 =?utf-8?B?cHN1d3QwNDd5MEdEY3dVWWVkMm01U0ZzSkpKNHZJSzdYeVFXbmY2cG9GbXNn?=
 =?utf-8?B?UFk1dFJITmQ1ejZNTUQvbVRCME9CTWhFT2VsbFc1T0NseDR2VlJVb3dZSS9M?=
 =?utf-8?B?dS9CVDRvYlFaeG9UNmpYTXVWSjgzSW5IeXI5VW5rRW9sR0psSk1NaHV4RXhr?=
 =?utf-8?B?eVRvc3NTQnFTME9QUG1jdkg2YWZhby93enVBOUJZL2lQQXVHQ2tmZnNWWGU5?=
 =?utf-8?B?aUM5SHlHSEdoZGZFM3BGd1RyQ1hEVHZvZHV5dVBNbTZnc0pyRWxTNnBISVQ5?=
 =?utf-8?B?Wi9pQUNrT0tucmNtYis1dEdadEE3eWNUNXVNcTFEM0MzbHRVczRYdHNPOWNr?=
 =?utf-8?B?YXlsNHZUWDhFZ2w3Y2pMUWZ3aERYTFpLVHYzb0RMY05NTVE0WTNXV2JyL0Iz?=
 =?utf-8?B?THRheFNzSjhxNTlTZFJKY1RYbzd4T1FRTHJUZnBuY0RVQUgrUVcrdFhFVTNY?=
 =?utf-8?B?dlZabFdkaWY2UnVteHQ3aCtGamtNZ3pKUnErNDI5TVBFTHA0STFmNHU3S3dC?=
 =?utf-8?B?L3QzeHRjckR0eTBJNGpobnpRazNHRVRsWUxMYnR2WW5jeXFndEFlN1ExN2xu?=
 =?utf-8?B?VGdhRlg5NFJDc09tdzNvdUVYd0RNYzdNL25MNndBUEJoS3BYZURZWTRzYnU5?=
 =?utf-8?B?MkZSV0V2UjFhSHJCTXlwVjhjZE1JU0pwRUVQdTlQcFJnOUg0WFZJWFdzRUtI?=
 =?utf-8?B?SVlTTUdVeENRTk5lSEFmUFNwQ3pObkJBMWl4UFFlMXhVSEsra0JueUVxZFNs?=
 =?utf-8?B?d0pVYithY3VhUDZMT25NLzI4SFZFUWF0dVlGaXUvVGl1UENzUEoyMVRxMVU4?=
 =?utf-8?B?NkR5Y2ZXNEp6Y1ZwOEFvbjg3US9wUmp2UURMc0xubUIvNXhHcHNITzl1ODRq?=
 =?utf-8?B?bzNmRnNscWdROUYwQ2xOaXBGYVQrcWdEVFF3YkRMbVJSM091YXZ0M0FiTG15?=
 =?utf-8?B?NVhWd01HOTlacXlmUFVGclZVWE9IWEhvVVlMcDF0S2dDeUFSOElzWjVWdGFC?=
 =?utf-8?B?K0o2Q2pGU09heUhKVm1tRm1yczlpNGFqbjVQWTNUMmhVaGNuVVVHRFp1aFhC?=
 =?utf-8?B?aC84Rk1aYmxRdWxwSHBmMG4xMTRBSW12QU90QWNQZ1J1MWY3WHJCdDBubk5G?=
 =?utf-8?B?M3o0S2pBTW9UL0xvUFVUQnVsazAySjBIWlpkM2ZHVkZvdmsvVVpaTFZRcFV3?=
 =?utf-8?Q?Ee7aaKpNp8QXSFQAK/XxuAFDq?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5D964C66A9A95C4FAB1A723F4D902C68@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38f259b0-92d2-438f-1c69-08dc6dbb9204
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2024 10:59:15.5433
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GPXfU5TgGjzOl/TW3SKGw9Vbfph8lOQuJ6nlyRz4cDDa2v/z9SzJ8ugo1MRTrglb39XYTmQ7t1vm9z917fDxEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5949
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTAzIGF0IDE4OjMyICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gRnJpLCAyMDI0LTA1LTAzIGF0IDEyOjI2ICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+IA0KPiA+IFRvIHJlc29sdmUgdGhpcyBvbmNlIGZvciBhbGwsIGV4dGVuZCB0aGUgZXhp
c3RpbmcgbWV0YWRhdGEgcmVhZGluZyBjb2RlDQo+ID4gdG8gcHJvdmlkZSBhIGdlbmVyaWMgbWV0
YWRhdGEgcmVhZCBpbmZyYXN0cnVjdHVyZSB3aGljaCBzdXBwb3J0cyByZWFkaW5nDQo+ID4gYWxs
IDgvMTYvMzIvNjQgYml0cyBlbGVtZW50IHNpemVzLg0KPiANCj4gSSB0aGluayB0aGUga2V5IHBv
aW50IGlzIHRoYXQgaXQgaXMgYWN0dWFsbHkgc2ltcGxlciB0byBzdXBwb3J0IGFsbCBmaWVsZCB0
eXBlcw0KPiB0aGVuIG9ubHkgMTYgYW5kIDY0Lg0KDQpIb3cgYWJvdXQgYWRkIGJlbG93IHRvIHRo
ZSBlbmQgb2YgdGhlIGNoYW5nZWxvZzoNCg0KVGhlIG1ldGFkYXRhIGZpZWxkIElEIGVuY29kZXMg
dGhlIGVsZW1lbnQgc2l6ZS4gIFRoZSBUREguU1lTLlJEIFNFQU1DQUxMDQphbHdheXMgcmV0dXJu
cyA2NC1iaXQgbWV0YWRhdGEgZGF0YSByZWdhcmRsZXNzIG9mIHRoZSB0cnVlIGVsZW1lbnQgc2l6
ZSBvZg0KdGhlIG1ldGFkYXRhIGZpZWxkLiAgVGhlIGN1cnJlbnQgZnVuY3Rpb24gdG8gcmVhZCAx
Ni1iaXQgbWV0YWRhdGEgZmllbGRzDQpjaGVja3MgdGhlIGVsZW1lbnQgc2l6ZSBlbmNvZGVkIGlu
IHRoZSBmaWVsZCBJRCBpcyBpbmRlZWQgMTYtYml0cy4NCg0KQ2hhbmdlIHRoYXQgZnVuY3Rpb24g
dG8ganVzdCBjb3ZlcnQgdGhlIGRhdGEgZnJvbSB0aGUgU0VBTUNBTEwgdG8gdGhlIHNpemUNCmVu
Y29kZWQgaW4gdGhlIG1ldGFkYXRhIGZpZWxkIElEIHRvIHByb3ZpZGUgYSBmdW5jdGlvbiB3aGlj
aCBzdXBwb3J0cyBhbGwNCmVsZW1lbnQgc2l6ZXMuICBJdCdzIGFjdHVhbGx5IHNpbXBsZXIgdG8g
c3VwcG9ydCByZWFkaW5nIGFsbCBlbGVtZW50IHNpemVzDQppbiBvbmUgZnVuY3Rpb24gcmF0aGVy
IHRoYW4gcHJvdmlkaW5nIHR3byBmdW5jdGlvbnMgdG8gcmVhZCAxNiBhbmQgNjQgYml0cw0KZWxl
bWVudHMgcmVzcGVjdGl2ZWx5LiANCg==

