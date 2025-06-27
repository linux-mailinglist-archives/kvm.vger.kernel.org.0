Return-Path: <kvm+bounces-50932-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F41AEAC63
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 03:48:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AA59F64086F
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 01:48:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF6AC16DEB1;
	Fri, 27 Jun 2025 01:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hB6nzAMe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81D32F1FE1;
	Fri, 27 Jun 2025 01:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750988902; cv=fail; b=tXYzug1o5VjevNYvbrpznuzWLOOskut38vvmkOGv+ZAIJHSkJVo4VisQdoz4Ll5T1Zve4PfyjlWSffXUNHJ0eqMikogQPGxivXV4Qn5ypbiI2Kk568yrwCBQkq3aj2+gqDPrqs2EVELgpyt4gVCLciaU674uOefzYVYKAqqNPvg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750988902; c=relaxed/simple;
	bh=JVR8ZqNozgoq75rAZXaW8X1PMvqCWuONRI8UrGQBDuk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ZKqeLkOWBHbmkf4LVXhV3t5WJkWrc3PDBrlXNBZ6x+JnqivmLp6v4XIEKPFupIrkqK6EDSFlXj7Vf1bzRmzGGr+rOwfZcvQJu+TtZNjXhWzN2gT7UnHRZ5TQ6mmuGQJc77MKXI0iYfu2h7bjvl5iPFceif9eM6oivjQRsNNhP5M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hB6nzAMe; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750988901; x=1782524901;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JVR8ZqNozgoq75rAZXaW8X1PMvqCWuONRI8UrGQBDuk=;
  b=hB6nzAMeUaJ7nXDmkd9Vct4XES/kAwqBYT1gW5vkuc6QimASyNBkM2UU
   cE8hUNe/5dBNQUOhfE0l1dYiB8rDVq2AkkhbwMbvJqnPxatKIq3JrSo84
   ZyA0qIlDEz4hHIvEXVMdQPXhfOgYv3b4fNzOrnWXah9T/IBkeR23sDCxT
   rLjLZRrErXHNai0US6m7cfaDmJAZvFitFPJn2CHYhH0JBQxQpsXQwoP2H
   h2TEjbXdAnY2FO0ranrokBLoZwGm+H/25hioOxZIg9aWyz59JHaMG4YBr
   QDI7sC5GtteXa5Kvq5345dJFgn9/RBoqM5uNBS9ar+08ORLbVZNE7QbY1
   Q==;
X-CSE-ConnectionGUID: l3NKBkhJQ6iaTtpKGoPDlA==
X-CSE-MsgGUID: /1cjKqsrTBKF/OdjKJ5G3A==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="63898377"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="63898377"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 18:47:54 -0700
X-CSE-ConnectionGUID: hPrH0B4PSBSvBrhwxtzonQ==
X-CSE-MsgGUID: +Xaad2ndS8CeIiku5ZqLug==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="156712637"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 18:47:11 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 18:47:10 -0700
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 26 Jun 2025 18:47:10 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.88)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 26 Jun 2025 18:47:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=CiHlxbhXpqBHIv6rS8VBR9NUcMDaIvYuEDV52S/VQWC1hcDCwi4CJOQHBMQOfaZGMw7gKCzx/b8L/ct/9w5CGQZ7ZPCA5PvIainXlB7HhIxa2Y1AuC6AX2jpshTV9zkcFs6u0fUIJQ9U8xL/sWYvLTchnib+V+RBEjZKyZgOoC3vcjeHiddk8idDvm/FsHH4ccWj85YzpIanFfMPOVj6EjXDYm3A2V8Nkt96o3E6pIbaecCys9+54zy+RwujGbrEW29MKghjr2eorRYbuwRYmzYeaHDLAjLfl1ewGW3phqPuZoL+zaJRHXfOvEawCLS3OQRUPep5huoRrxv0Ow26VQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JVR8ZqNozgoq75rAZXaW8X1PMvqCWuONRI8UrGQBDuk=;
 b=WsTUvxgNRJiaF3S7celSeclETBCbEl0PNG33wlEJGAPX3ihKivQL09rPh+aDqxuC+qfDZHV/rsHhFcFG49eaD6BV5Qvrhe4Bv6/VSz94FBXOJSG674fZG9ugGizhWweepcbjmaWOlGQcd3SuGZGJ/7OSqNBqtGao/TR8MNI3seTStrc/8kj70E4H8o60NckggzED2ST1cCXMz5pGinWWCp3BV+erlheNX2sdMDbwDJibEy1sB+r8zjScIx9UKXUu3lOX3wFlKRx4N04tqMI9cyiq1aDkA658xiQniYMb2zqps6P8ilwVn7upoAWoskfhpG0fke8ugNkKpRfo82t5kA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH7PR11MB7498.namprd11.prod.outlook.com (2603:10b6:510:276::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8857.26; Fri, 27 Jun
 2025 01:47:05 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8857.026; Fri, 27 Jun 2025
 01:47:05 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Hansen, Dave" <dave.hansen@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"peterz@infradead.org" <peterz@infradead.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>
CC: "seanjc@google.com" <seanjc@google.com>, "x86@kernel.org"
	<x86@kernel.org>, "sagis@google.com" <sagis@google.com>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "Williams, Dan J"
	<dan.j.williams@intel.com>, "ashish.kalra@amd.com" <ashish.kalra@amd.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "Chen,
 Farrah" <farrah.chen@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 2/6] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Topic: [PATCH v3 2/6] x86/virt/tdx: Mark memory cache state incoherent
 when making SEAMCALL
Thread-Index: AQHb5ob0DIdF1IdedUu3tc4rNu0nBLQVxaGAgABTdICAABVYAIAAD0QA
Date: Fri, 27 Jun 2025 01:47:05 +0000
Message-ID: <987f7623c48c89b4c76c046efdaef546293a8fcc.camel@intel.com>
References: <cover.1750934177.git.kai.huang@intel.com>
		 <323dc9e1de6a2576ca21b9c446480e5b6c6a3116.1750934177.git.kai.huang@intel.com>
		 <554c46b80d9cc6c6dce651f839ac3998e9e605e1.camel@intel.com>
		 <0d32d58cb9086906897dada577d9473b04531673.camel@intel.com>
	 <5049e63e22c66aa0a97912417c29eff007468ab4.camel@intel.com>
In-Reply-To: <5049e63e22c66aa0a97912417c29eff007468ab4.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH7PR11MB7498:EE_
x-ms-office365-filtering-correlation-id: 181e1872-45e1-44f5-acd9-08ddb51c8548
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|13003099007|38070700018|921020;
x-microsoft-antispam-message-info: =?utf-8?B?aGZyc0VkNS9LaGZ5TmxtU3FSWjR3SytGN01NVXl4MzlDQkswNjl5V2RkN3pM?=
 =?utf-8?B?Y2huL2xtNnBYKzdxd1p4aVJRcG1kdzluZkZiN1ByVGlhV0tqRjJ5b0V0Umht?=
 =?utf-8?B?dDZRb1dYeG9nYlBmRlF6UDJwTGdOQmV1U0ZqTHMrODdDUEo2bHBjN05nTWps?=
 =?utf-8?B?aDFOT0tjV2l5VWZXUWpnMFh4SHVxU1ZPQVg1SmlaRDczbVJiSVB2aFg4SnlF?=
 =?utf-8?B?Y0ticXZhZnNubSt4M3BZeGdaS0FLc1FCRTNlbzFRTmsrem1LSWo3TnErOGQ1?=
 =?utf-8?B?aDBwZC9CcVZxbm1IaEc3MFUzOFBpZ00rVUpyMUxxRTZDTEFKNVAwUTRuUTBS?=
 =?utf-8?B?VFN3eDZWQVd5ZENjTC9WemMwbTdGTGRCZlVIOUZlMUNnMElmbGJvcFJRNWtG?=
 =?utf-8?B?UXhDd1JocXJ0bDVIeUJxQzg5Y0E0Uk53ZU5oRnZzNFUycnRhSmZycjBYS1pl?=
 =?utf-8?B?dVdpWDY4Q3JhMFh1Y0J6Q3J2eUNsc0tHS3pUV0FIS2hNVWNsdVV2djVJbVY1?=
 =?utf-8?B?OHlMeXNtVUdTVkdwSjBKQWNITkpSd3hNRUtueG5OM0Q0SUFaZXFvQmJ4VDh3?=
 =?utf-8?B?U09IdFVSVjVwRVM0UGJ5V1dRRENjZnhuZlNWd2tVdEVTRGY5VGhFV2hBTExw?=
 =?utf-8?B?Zk13cDlWSDRqTTM2dzNidkg5dXlhTnJEWElLOGZVRzNmaXR6OS90VUp0S3RF?=
 =?utf-8?B?QXR4R080T3hoMzhOVVdKYlQ5WXZVLzQrQzBsdlhXR2FOWlpYWFhNdEVFL2ZW?=
 =?utf-8?B?RldzOU0rV1FwWHdlZ2tLb2JhZkQyYTI0RG8rTTE3WGZEeU9HYzBSaE8vdFJR?=
 =?utf-8?B?elk4ZGNMSWxHSVdGV0ZUNG9VS3NoT0Fpa3hJSGphUm9ReVZiZmNVQUI4M3Nk?=
 =?utf-8?B?M0JaY1Q2NWZxNEIvU2ZmZFJsQWdyK1JTbXNIVFZ3Slh5dUFoNUZxUkpMZW1J?=
 =?utf-8?B?c2ZwZS95RmpobzhxeHdEcUMrTXBVYStQM0VhdzNtQ3FIOTJHYVptNWhMY2JI?=
 =?utf-8?B?Q2RBWk9xTHVkL2REaDlCdm9ESTduNlMzaklsT2dTaHFCWGNrQllPT0E0aUtX?=
 =?utf-8?B?aUI1QXNvTWNZTlhwRHZuQWE3UDYwd2ljV0tHVWdnQzU2WHdGWGVxZWF5VXRh?=
 =?utf-8?B?RFYzZ3NBSXVCSnlMdGR6NG16OGRvNnFnT0s0TzVMMG43WXV5SHpkTzlkN3NL?=
 =?utf-8?B?YTZ0VGVmOEo3K1ZEZ3VXdGFJYWZ2MVNhemFOQnFoVVVZWU92dFNTSzRyYWpl?=
 =?utf-8?B?cEdNaXNqR0h1VGg3Y2dLbHBjRUxybGNmV2haZ1lGazZIVlAxQ1Fkc1hQTUUx?=
 =?utf-8?B?T1hnOVM2K0ZZR3E0cHE0T2plbzRVWlM4R25talM0VEJRSDVUS00vLzdJd1M5?=
 =?utf-8?B?aWxHTEFtMUdZNHBraVVpbXc1UFZxR0RrbzFzOGVQNk9sbkpXV0VCSS9YVzNa?=
 =?utf-8?B?cEJZTXJXU1RmTWFZUWhLS09VckRwVjNxUVVuT2lyTE1pK0UzdW9LL0RneHJD?=
 =?utf-8?B?QThtemF4R2FEUzltV0lsVkhTODAxakY3T1FoU1JoTkhqMWdoWmd0NGFvUHFD?=
 =?utf-8?B?cTlrdm9jaEJxbGh0UVNTbHVCNnVEdU9icmpoRDJIbTZCTnhHVW1FbEpKZkNp?=
 =?utf-8?B?d0tKdUM2Y0x1MU5ibnpaQUlMSkc5TDFqNGtyNThXclNBd1BvcFBnQmwwbzZz?=
 =?utf-8?B?NTBFTzRZKzQvSWZiL0Z1cWJhQzhoZW5kbStyNHh6N2hSSG5sNWJiS0RGWmhZ?=
 =?utf-8?B?b0RkV20zUGdjN3NUMEtzV0xMb1JBbDlLdnNiRUJONjV1eVV2djQ0eWo5ZDdx?=
 =?utf-8?B?TmJvc0RibWw2bGVncWdaNERNWXRuOHFFaEJrQjNRUW9menVHWGIzWkw1MjB3?=
 =?utf-8?B?UlJGY0ZDUTdrTDVhdGVKQVN1MnE2d3pWZGR0a2JMcWRGOVVyb1gvbkNYcDNz?=
 =?utf-8?B?Q2pqM3RCa25qUUNjN0NCczR0RlRhblBBMzlZcWV2TzVtdU9udlZZZGhZT09S?=
 =?utf-8?B?RHRja0Y5Q3UrblhsWWpSelZvZjVoS2J0S3I0eGFWeFdhVkw4MW0vbnVFOENU?=
 =?utf-8?Q?rv5Jbp?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(13003099007)(38070700018)(921020);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2MvVTR1NzRQRTA1dlFrbktLSWpzK2NOZ3BJTGtrZ0h6d1c1TktIZldxNUN3?=
 =?utf-8?B?ZXVvNGRYYjI5emlvOFZaV0lhM2cxNjBpMElnUlQ4M1ppMk9tS1lackhrK2pw?=
 =?utf-8?B?Zkl0UllKVXF1S0MxaHg0R0gzUElBemwvUUxaMVBCQUNOQk5jOThPd2FrZlht?=
 =?utf-8?B?dlIzTno3a0lHQzhmbjh4Rm93dkVQYzdIck9MK0ZxaUhhWGV0RmpiU2UxM3Y5?=
 =?utf-8?B?S3VNUURmbXhXeEowM1JzU1JJOXVkVEFXRjRNRTNQbTRHRTE2ZDBscTMrckFn?=
 =?utf-8?B?MExaWWFtWE5hSXVrSXhCNWFkOGJRRG9kWW5wYUVLOE1ZODN4b21jbCs5Rnp3?=
 =?utf-8?B?dUwwQmJISjlQNmx2TXVkaVBQcWs3empvSHhDM0EvMzU5VHEyRVFsWUNaSi9C?=
 =?utf-8?B?c1k5dkdHb2ZoTTdQV2lITDcraXgwOUpJRzh5aGttVTB1STRLVEUrUUtqbWdH?=
 =?utf-8?B?RDJ1Y1ZhdFp6NkRsN0ozRXhSUEZia3hPczU2WWNyM3lteUxrenUvTFJLaDVj?=
 =?utf-8?B?Z2MxY0VGUWRJa3hBQVZtTTVrVDJNN0ZQYVhaUUVCaFZQNmtnVDJPSzUrc2s1?=
 =?utf-8?B?WUJLSmR0aFZEVmRKWnRrNVU4SjBsY2R2YVFkSFB5Ujc1VWNNV253aVZnMDVV?=
 =?utf-8?B?TlMzZlRDVHFib3I2aGo4NXY2NFVuVHZidVY4cmtUdlk0aGg0VG4vYTZFYkM0?=
 =?utf-8?B?S0xlbUd5NDBySUJ6N3psbXNVbGo3T3JoQTY1QlFLSUVoL1kwWDNHdVJua1kv?=
 =?utf-8?B?TGQ0QmRQa1BQZXRpRHczclVKamVVbGx2dXlWSU1MWFMwRHU2dEdyc3ZxT2dD?=
 =?utf-8?B?cWVHY0g1QVhKOWVZdHEvTUc2eG1rR0hKYi9NNDdMQ3VoZVZxTENRaC93WFZN?=
 =?utf-8?B?clA5RktQMktTYUd6ZUsyZkx6a0lDZjB4VTE2bFkxekM1NmxaOWVoTUl0WHdz?=
 =?utf-8?B?cjZ5bHY5UUJJSlU1T2RnL29Ob2RRb0ZOYXZseGNtWFc0dW5pKzY0d2pHMzR6?=
 =?utf-8?B?SWxicFBOakhFYW9kYkpWZUdjQlZpZDBvWmNoc1ozMDBoSk9ucWN0aVVGU2JN?=
 =?utf-8?B?ZWdTVUtrdlVIbnVwejNuaUJBdFZPT2NtRENBUHdGQ0hEN1Q3cFJIVHloN2JJ?=
 =?utf-8?B?cFRZRmljS2xYUmt4dWVYSkRmdi9KTnM3UFh0SlI5Z09pR3FvYTBoTTVVUzg1?=
 =?utf-8?B?aVVsSm5vODNyaUdLSFlHVGxWV0RPSDE3RXVqelNUUmcvendVOU1ORk5Wc2Ez?=
 =?utf-8?B?Ylk4bmRUVmt3QU5SbTdOUnhOa3VqcjNIMnpMWXY0QlRhS1l4Wkdkb0VHNHdW?=
 =?utf-8?B?dktQQ056andLMmxnak1zeVRxSjZRL0I5RlRuNUV1eCtZRFhsa2ZFRU5VY25O?=
 =?utf-8?B?TUwrV05kUkVaeCtQZDhTSWNHRmgzZnZTYXQ4NFJwanlCZVFtTGYyQytBWmVs?=
 =?utf-8?B?NEtINTAxdzJEeGJSbFNYRGxNTW5OYmpNNXhPNzdWdkl6dWtLTzQ3dUxRNXZv?=
 =?utf-8?B?N3JVOVB6KzdERkhERGFmKzNLZ0QyODJZTlp4QXdSdHQxUDhNSFJYTFdVcG5G?=
 =?utf-8?B?UUI4TDh2Uld6MlA2eUhOY1JscDN0emY5MGlzcUJ6K21nbW1tQnI2LzdqQmph?=
 =?utf-8?B?bnBJRVduWU9Fcmg0Z1NXZGtUZld5U1dtbno5aENVSkV3WXhwZ3B0a3hxc1Zm?=
 =?utf-8?B?ZHgweEV0YlYrZk5pVDJUakh3cmNGL3l1UU93cDl0cUVsRHlURXBxWDZIaGM5?=
 =?utf-8?B?dVB3cjdTdTRneGlEKzFod1hQWlZ6cDZQb3hVWnhlYS9WVTZYckVZTmdIbVJa?=
 =?utf-8?B?YlpOSzh1R3ZWUENWVmZFSE5ZamRjdEZYNGNnYUN2WHB0Tys0TUxzVDBSamE4?=
 =?utf-8?B?cDV1ckhlNkdCenFOZ1VwMldZd0dqNzU2aUh3Q0NXVkIvcjFrNThSNzFvUjN5?=
 =?utf-8?B?YlhIVEJ5WFVSLzcrY1ZBY1ArWDF1TkpQaVRuNTFUakZjM1I5eTFuWjVLQ0xB?=
 =?utf-8?B?R0FwN055WVdpNytmUnBBUStlUEtUZjRqLzZDNG83bUljaUhOaml4YXpxeG9K?=
 =?utf-8?B?Q3ZCcitlbEtJdGhObFV2eGZ6WllCRkljb251UTJmWHZYZTRKS01nMXpmbnVY?=
 =?utf-8?B?WUZNOEN6bjZ3NEdOUUU1SjhuazlVQ3JTc01LV2hUUmVjZWtISDZSTG8vbDl2?=
 =?utf-8?B?bHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F516661F012D7D4FB9E0E18603EC5765@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181e1872-45e1-44f5-acd9-08ddb51c8548
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2025 01:47:05.6051
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmD5i5M4nKopfuqBrUxatfTTJS2y8lbr+TOIDYSRwSEWsXIQnXCjtzDcJ0SX1mzdmYEfp0z6Rvc4tpvt3LP76Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7498
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI1LTA2LTI3IGF0IDAwOjUyICswMDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90
ZToNCj4gT24gVGh1LCAyMDI1LTA2LTI2IGF0IDIzOjM2ICswMDAwLCBIdWFuZywgS2FpIHdyb3Rl
Og0KPiA+IChJJ2xsIGZpeCBhbGwgd29yZGluZyBjb21tZW50cyBhYm92ZSkNCj4gPiANCj4gPiA+
ID4gDQo+ID4gPiA+IHYyIC0+IHYzOg0KPiA+ID4gPiAgLSBDaGFuZ2UgdG8gdXNlIF9fYWx3YXlz
X2lubGluZSBmb3IgZG9fc2VhbWNhbGwoKSB0byBhdm9pZCBpbmRpcmVjdA0KPiA+ID4gPiAgICBj
YWxsIGluc3RydWN0aW9ucyBvZiBtYWtpbmcgU0VBTUNBTEwuDQo+ID4gPiANCj4gPiA+IEhvdyBk
aWQgdGhpcyBjb21lIGFib3V0Pw0KPiA+IA0KPiA+IFdlIGhhZCBhICJtaXNzaW5nIEVOREJSIiBi
dWlsZCB3YXJuaW5nIHJlY2VudGx5IGdvdCBmaXhlZCwgd2hpY2ggd2FzIGNhdXNlZA0KPiA+IGJ5
IGNvbXBpbGVyIGZhaWxzIHRvIGlubGluZSB0aGUgJ3N0YXRpYyBpbmxpbmUgc2NfcmV0cnkoKScu
ICBJdCBnb3QgZml4ZWQgYnkNCj4gPiBjaGFuZ2luZyB0byBfX2Fsd2F5c19pbmxpbmUsIHNvIHdl
IG5lZWQgdG8gdXNlIF9fYWx3YXlzX2lubGluZSBoZXJlIHRvbw0KPiA+IG90aGVyd2lzZSB0aGUg
Y29tcGlsZXIgbWF5IHN0aWxsIHJlZnVzZSB0byBpbmxpbmUgaXQuDQo+IA0KPiBPaCwgcmlnaHQu
DQo+ID4gDQo+ID4gU2VlIGNvbW1pdCAwYjNiYzAxOGU4NmEgKCJ4ODYvdmlydC90ZHg6IEF2b2lk
IGluZGlyZWN0IGNhbGxzIHRvIFREWCBhc3NlbWJseQ0KPiA+IGZ1bmN0aW9ucyIpDQo+ID4gIA0K
PiA+ID4gDQo+ID4gPiA+ICAtIFJlbW92ZSB0aGUgc2Vuc3RlbmNlICJub3QgYWxsIFNFQU1DQUxM
cyBnZW5lcmF0ZSBkaXJ0eSBjYWNoZWxpbmVzIG9mDQo+ID4gPiA+ICAgIFREWCBwcml2YXRlIG1l
bW9yeSBidXQganVzdCB0cmVhdCBhbGwgb2YgdGhlbSBkby4iIGluIGNoYW5nZWxvZyBhbmQNCj4g
PiA+ID4gICAgdGhlIGNvZGUgY29tbWVudC4gLS0gRGF2ZQ0KPiA+ID4gPiANCj4gPiA+ID4gLS0t
DQo+ID4gPiA+ICBhcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaCB8IDI5ICsrKysrKysrKysrKysr
KysrKysrKysrKysrKystDQo+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMjggaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPiA+ID4gPiANCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2FyY2gveDg2
L2luY2x1ZGUvYXNtL3RkeC5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmgNCj4gPiA+ID4g
aW5kZXggN2RkZWYzYTY5ODY2Li5kNGM2MjRjNjlkN2YgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2Fy
Y2gveDg2L2luY2x1ZGUvYXNtL3RkeC5oDQo+ID4gPiA+ICsrKyBiL2FyY2gveDg2L2luY2x1ZGUv
YXNtL3RkeC5oDQo+ID4gPiA+IEBAIC0xMDIsMTAgKzEwMiwzNyBAQCB1NjQgX19zZWFtY2FsbF9y
ZXQodTY0IGZuLCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKTsNCj4gPiA+ID4gIHU2NCBf
X3NlYW1jYWxsX3NhdmVkX3JldCh1NjQgZm4sIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZ3Mp
Ow0KPiA+ID4gPiAgdm9pZCB0ZHhfaW5pdCh2b2lkKTsNCj4gPiA+ID4gIA0KPiA+ID4gPiArI2lu
Y2x1ZGUgPGxpbnV4L3ByZWVtcHQuaD4NCj4gPiA+ID4gICNpbmNsdWRlIDxhc20vYXJjaHJhbmRv
bS5oPg0KPiA+ID4gPiArI2luY2x1ZGUgPGFzbS9wcm9jZXNzb3IuaD4NCj4gPiA+ID4gIA0KPiA+
ID4gPiAgdHlwZWRlZiB1NjQgKCpzY19mdW5jX3QpKHU2NCBmbiwgc3RydWN0IHRkeF9tb2R1bGVf
YXJncyAqYXJncyk7DQo+ID4gPiA+ICANCj4gPiA+ID4gK3N0YXRpYyBfX2Fsd2F5c19pbmxpbmUg
dTY0IGRvX3NlYW1jYWxsKHNjX2Z1bmNfdCBmdW5jLCB1NjQgZm4sDQo+ID4gPiA+ICsJCQkJICAg
ICAgIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgKmFyZ3MpDQo+ID4gPiA+ICt7DQo+ID4gPiANCj4g
PiA+IFNvIG5vdyB3ZSBoYXZlOg0KPiA+ID4gDQo+ID4gPiBzZWFtY2FsbCgpDQo+ID4gPiAJc2Nf
cmV0cnkoKQ0KPiA+ID4gCQlkb19zZWFtY2FsbCgpDQo+ID4gPiAJCQlfX3NlYW1jYWxsKCkNCj4g
PiA+IA0KPiA+ID4gDQo+ID4gPiBkb19zZWFtY2FsbCgpIGlzIG9ubHkgY2FsbGVkIGZyb20gc2Nf
cmV0cnkoKS4gV2h5IGFkZCB5ZXQgYW5vdGhlciBoZWxwZXIgaW4gdGhlDQo+ID4gPiBzdGFjaz8g
WW91IGNvdWxkIGp1c3QgYnVpbGQgaXQgaW50byBzY19yZXRyeSgpLg0KPiA+IA0KPiA+IEl0J3Mg
anVzdCBtb3JlIHJlYWRhYmxlIGlmIHdlIGhhdmUgdGhlIGRvX3NlYW1jYWxsKCkuICBJdCdzIGFs
d2F5cyBpbmxpbmVkDQo+ID4gYW55d2F5Lg0KPiANCj4gRG9uJ3QgeW91IHRoaW5rIHRoYXQgaXMg
YSBxdWVzdGlvbmFibGUgY2hhaW4gb2YgbmFtZXM/IEkgd2FzIHRoaW5raW5nIHRoYXQgd2UNCj4g
bWlnaHQgd2FudCB0byBkbyBhIGZ1dHVyZSBjbGVhbnVwIG9mIGFsbCB0aGVzZSB3cmFwcGVycy4g
QnV0IEkgd29uZGVyZWQgaWYgaXQNCj4gd2FzIG9uZSBvZiB0aG9zZSAibGVhc3Qgd29yc2UiIG9w
dGlvbnMga2luZCBvZiB0aGluZ3MsIGFuZCB5b3UgYWxyZWFkeSB0cmllZA0KPiBzb21ldGhpbmcg
YW5kIHRocmV3IHlvdXIgaGFuZHMgdXAuIEkgdGhpbmsgdGhlIGV4aXN0aW5nIGxheWVycyBhcmUg
YWxyZWFkeQ0KPiBxdWVzdGlvbmFibGUuIFdoaWNoIHdlIGRvbid0IG5lZWQgdG8gY2xlYW51cCBm
b3IgdGhpcyBzZXJpZXMuDQoNCkkgYWdyZWUgd2Ugc2hvdWxkIHJldmlzaXQgdGhpcyBpbiB0aGUg
ZnV0dXJlLg0KDQo+IA0KPiA+IA0KPiA+ID4gDQo+ID4gPiBPaCwgYW5kIF9fc2VhbWNhbGxfKigp
IHZhcmlldHkgaXMgY2FsbGVkIGRpcmVjdGx5IHRvbywgc28gc2tpcHMgdGhlDQo+ID4gPiBkb19z
ZWFtY2FsbCgpIHBlci1jcHUgdmFyIGxvZ2ljIGluIHRob3NlIGNhc2VzLiBTbywgbWF5YmUgZG9f
c2VhbWNhbGwoKSBpcw0KPiA+ID4gbmVlZGVkLCBidXQgaXQgbmVlZHMgYSBiZXR0ZXIgbmFtZSBj
b25zaWRlcmluZyB3aGVyZSBpdCB3b3VsZCBnZXQgY2FsbGVkIGZyb20uDQo+ID4gPiANCj4gPiA+
IFRoZXNlIHdyYXBwZXJzIG5lZWQgYW4gb3ZlcmhhdWwgSSB0aGluaywgYnV0IG1heWJlIGZvciBu
b3cganVzdCBoYXZlDQo+ID4gPiBkb19kaXJ0eV9zZWFtY2FsbCgpIHdoaWNoIGlzIGNhbGxlZCBm
cm9tIHRkaF92cF9lbnRlcigpIGFuZCBzY19yZXRyeSgpLg0KPiA+IA0KPiA+IFJpZ2h0LiAgSSBm
b3Jnb3QgVERILlZQLkVOVEVSIGFuZCBUREhfUEhZTUVNX1BBR0VfUkRNRCBhcmUgY2FsbGVkIGRp
cmVjdGx5DQo+ID4gdXNpbmcgX19zZWFtY2FsbCooKS4NCj4gPiANCj4gPiBXZSBjYW4gbW92ZSBw
cmVlbXB0X2Rpc2FibGUoKS9lbmFibGUoKSBvdXQgb2YgZG9fc2VhbWNhbGwoKSB0byBzY19yZXRy
eSgpDQo+ID4gYW5kIGluc3RlYWQgYWRkIGEgbG9ja2RlcF9hc3NlcnRfcHJlZW1wdGlvbl9kaXNh
YmxlZCgpIHRoZXJlLCBhbmQgdGhlbg0KPiA+IGNoYW5nZSB0ZGhfdnBfZW50ZXIoKSBhbmQgcGFk
ZHJfaXNfdGR4X3ByaXZhdGUoKSB0byBjYWxsIGRvX3NlYW1jYWxsKCkNCj4gPiBpbnN0ZWFkLg0K
PiANCj4gQ2FuIHlvdSBwbGF5IGFyb3VuZCB3aXRoIGl0IGFuZCBmaW5kIGEgZ29vZCBmaXg/IEl0
IG5lZWRzIHRvIG1hcmsgdGhlIHBlci1jcHUNCj4gdmFyIGFuZCBub3QgY2F1c2UgdGhlIGlubGlu
ZSB3YXJuaW5ncyBmb3IgdGRoX3ZwX2VudGVyKCkuDQoNClllYWggYWxyZWFkeSBkaWQuICBUaGUg
YmVsb3cgZGlmZiBbKl0gZG9lc24ndCB0cmlnZ2VyIHdhcm5pbmcgZm9yDQp0ZGhfdnBfZW50ZXIo
KSAgZm9yIGJvdGggZ2NjIGFuZCBjbGFuZyB3aXRoIHRoZSBLY29uZmlnIHRoYXQgY2FuIHRyaWdn
ZXIgdGhlDQp3YXJuaW5nIGZpeGVkIGJ5IHRoZSBwYXRjaCBoZXJlOg0KDQpodHRwczovL2xvcmUu
a2VybmVsLm9yZy9sa21sLzIwMjUwNjI0MTAxMzUxLjgwMTktMS1rYWkuaHVhbmdAaW50ZWwuY29t
Lw0KDQpJJ2xsIHNlZSB3aGV0aGVyIEkgY2FuIGRvIG1vcmUuDQoNCj4gDQo+ID4gDQo+ID4gPiAN
Cj4gPiA+IE9oIG5vLCBhY3R1YWxseSBzY3JhdGNoIHRoYXQhIFRoZSBpbmxpbmUvZmxhdHRlbiBp
c3N1ZSB3aWxsIGhhcHBlbiBhZ2FpbiBpZiB3ZQ0KPiA+ID4gYWRkIHRoZSBwZXItY3B1IHZhcnMg
dG8gdGRoX3ZwX2VudGVyKCkuLi7CoFdoaWNoIG1lYW5zIHdlIHByb2JhYmx5IG5lZWQgdG8gc2V0
DQo+ID4gPiB0aGUgcGVyLWNwdSB2YXIgaW4gdGR4X3ZjcHVfZW50ZXJfZXhpdCgpLiBBbmQgdGhl
IG90aGVyIF9fc2VhbWNhbGwoKSBjYWxsZXIgaXMNCj4gPiA+IHRoZSBtYWNoaW5lIGNoZWNrIGhh
bmRsZXIuLi4NCj4gPiANCj4gPiB0aGlzX2NwdV93cml0ZSgpIGl0c2VsZiB3b24ndCBkbyBhbnkg
ZnVuY3Rpb24gY2FsbCBzbyBpdCdzIGZpbmUuDQo+ID4gDQo+ID4gV2VsbCwgbG9ja2RlcF9hc3Nl
cnRfcHJlZW1wdGlvbl9kaXNhYmxlZCgpIGRvZXMgaGF2ZSBhIFdBUk5fT05fT05DRSgpLCBidXQN
Cj4gPiBBRkFJQ1QgdXNpbmcgaXQgaW4gbm9pbnN0ciBjb2RlIGlzIGZpbmU6DQo+IA0KPiBJIHdh
cyBsb29raW5nIGF0IHByZWVtcHRfbGF0ZW5jeV9zdGFydCgpLiBCdXQgeWVhLCBpdCBsb29rZWQg
bGlrZSB0aGVyZSB3ZXJlIGENCj4gZmV3IHRoYXQgKnNob3VsZG4ndCogYmUgbm9uLWlubGluZWQs
IGJ1dCBhcyB3ZSBzYXcgcmVjZW50bHkuLi4NCg0KTm90ZSB3aXRoIHRoZSBkaWZmIFsqXSB0ZGhf
dnBfZW50ZXIoKSB3aWxsIG9ubHkgY2FsbA0KbG9ja2RlcF9hc3NlcnRfcHJlZW1wdGlvbl9kaXNh
YmxlZCgpIHdoaWNoIGRvZXNuJ3QgY2FsbA0KcHJlZW1wdF9sYXRlbmN5X3N0YXJ0KCkuDQoNCj4g
DQo+ID4gDQo+ID4gLyogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgDQo+ID4gICogVGhpcyBpbnN0cnVtZW50YXRp
b25fYmVnaW4oKSBpcyBzdHJpY3RseSBzcGVha2luZyBpbmNvcnJlY3Q7IGJ1dCBpdCAgICAgDQo+
ID4gICogc3VwcHJlc3NlcyB0aGUgY29tcGxhaW50cyBmcm9tIFdBUk4oKXMgaW4gbm9pbnN0ciBj
b2RlLiBJZiBzdWNoIGEgV0FSTigpDQo+ID4gICogd2VyZSB0byB0cmlnZ2VyLCB3ZSdkIHJhdGhl
ciB3cmVjayB0aGUgbWFjaGluZSBpbiBhbiBhdHRlbXB0IHRvIGdldCB0aGUgDQo+ID4gICogbWVz
c2FnZSBvdXQgdGhhbiBub3Qga25vdyBhYm91dCBpdC4NCj4gPiAgKi8gICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAN
Cj4gPiAjZGVmaW5lIF9fV0FSTl9GTEFHUyhjb25kX3N0ciwgZmxhZ3MpICAgICAgICAgICAgICAg
ICAgICAgICAgICAgXCAgICAgICAgICANCj4gPiBkbyB7ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXCAgICAgICAgICANCj4gPiAgICAg
ICAgIF9fYXV0b190eXBlIF9fZmxhZ3MgPSBCVUdGTEFHX1dBUk5JTkd8KGZsYWdzKTsgICAgICAg
ICAgXCAgICAgICAgICANCj4gPiAgICAgICAgIGluc3RydW1lbnRhdGlvbl9iZWdpbigpOyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXCAgICAgICAgICANCj4gPiAgICAgICAgIF9CVUdf
RkxBR1MoY29uZF9zdHIsIEFTTV9VRDIsIF9fZmxhZ3MsIEFOTk9UQVRFX1JFQUNIQUJMRSgxYikp
OyBcICANCj4gPiAgICAgICAgIGluc3RydW1lbnRhdGlvbl9lbmQoKTsgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXCAgICAgICAgICANCj4gPiB9IHdoaWxlICgwKSAgDQo+ID4gDQo+
ID4gV2UgY2FuIGFsc28ganVzdCByZW1vdmUgdGhlIGxvY2tkZXBfYXNzZXJ0X3ByZWVtcHRpb25f
ZGlzYWJsZWQoKSBpbg0KPiA+IGRvX3NlYW1jYWxsKCkgaWYgdGhpcyBpcyByZWFsbHkgYSBjb25j
ZXJuLg0KPiANCj4gVGhlIGNvbmNlcm4gaXMgd2VpcmQgY29tcGlsZXIvY29uZmlnIGdlbmVyYXRl
cyBhIHByb2JsZW0gbGlrZSB0aGlzOg0KPiBodHRwczovL2xvcmUua2VybmVsLm9yZy9sa21sLzIw
MjUwNjI0MTAxMzUxLjgwMTktMS1rYWkuaHVhbmdAaW50ZWwuY29tLw0KPiANCj4gRG8geW91IHRo
aW5rIGl0J3Mgbm90IHZhbGlkPw0KDQpJIGFic29sdXRlbHkgZG8uDQoNCkhvd2V2ZXIgV0FSTl9P
Tl9PTkNFKCkgaW4gbm9pbnN0ciBpcyBmaW5lIHNpbmNlIHRoZXJlJ3MNCmluc3RydW1lbnRhdGlv
bl9iZWdpbigpL2VuZCgpIGluc2lkZS4NCg0KPiANCj4gPiANCj4gPiA+IA0KPiA+ID4gQW0gSSBt
aXNzaW5nIHNvbWV0aGluZz8gSXQgc2VlbXMgdGhpcyBwYXRjaCBpcyBpbmNvbXBsZXRlLiBJZiBz
b21lIG9mIHRoZXNlDQo+ID4gPiBtaXNzZWQgU0VBTUNBTExzIGRvbid0IGRpcnR5IGEgY2FjaGVs
aW5lLCB0aGVuIHRoZSBqdXN0aWZpY2F0aW9uIHRoYXQgaXQgd29ya3MNCj4gPiA+IGJ5IGp1c3Qg
Y292ZXJpbmcgYWxsIHNlYW1jYWxscyBuZWVkcyB0byBiZSB1cGRhdGVkLg0KPiA+IA0KPiA+IEkg
dGhpbmsgd2UganVzdCB3YW50IHRvIHRyZWF0IGFsbCBTRUFNQ0FMTHMgY2FuIGRpcnR5IGNhY2hl
bGluZXMuDQo+IA0KPiBSaWdodCwgdGhhdCB3YXMgdGhlIGlkZWEuIEkgd2FzIGxlYXZpbmcgb3Bl
biB0aGUgb3B0aW9uIHRoYXQgaXQgd2FzIG9uIHB1cnBvc2UNCj4gdG8gYXZvaWQgdGhlc2Ugb3Ro
ZXIgcHJvYmxlbXMuIEJ1dCwgeWVzLCBsZXQncyBzdGljayB3aXRoIHRoZSAoaG9wZWZ1bGx5KQ0K
PiBzaW1wbGVyIHN5c3RlbS4NCj4gDQo+ID4gDQo+ID4gPiANCj4gPiA+IA0KPiA+ID4gU2lkZSB0
b3BpYy4gRG8gYWxsIHRoZSBTRUFNQ0FMTCB3cmFwcGVycyBjYWxsaW5nIGludG8gdGhlIHNlYW1j
YWxsXyooKSB2YXJpZXR5DQo+ID4gPiBvZiB3cmFwcGVycyBuZWVkIHRoZSBlbnRyb3B5IHJldHJ5
IGxvZ2ljP8KgDQo+ID4gPiANCj4gPiANCj4gPiBUaGUgcHVycG9zZSBvZiBkb2luZyBpdCBpbiBj
b21tb24gY29kZSBpcyB0aGF0IHdlIGRvbid0IG5lZWQgdG8gaGF2ZQ0KPiA+IGR1cGxpY2F0ZWQg
Y29kZSB0byBoYW5kbGUgcnVubmluZyBvdXQgb2YgZW50cm9weSBmb3IgZGlmZmVyZW50IFNFQU1D
QUxMcy4NCj4gPiANCj4gPiA+IEkgdGhpbmsgbm8sIGFuZCBzb21lIGNhbGxlcnMgYWN0dWFsbHkN
Cj4gPiA+IGRlcGVuZCBvbiBpdCBub3QgaGFwcGVuaW5nLg0KPiA+IA0KPiA+IEJlc2lkZXMgVERI
LlZQLkVOVEVSIFRESC5QSFlNRU0uUEFHRS5SRE1ELCB3aGljaCB3ZSBrbm93IHJ1bm5pbmcgb3V0
IG9mDQo+ID4gZW50cm9weSBjYW5ub3QgaGFwcGVuLCBJIGFtIG5vdCBhd2FyZSB3ZSBoYXZlIGFu
eSBTRUFNQ0FMTCB0aGF0ICJkZXBlbmRzIG9uIg0KPiA+IGl0IG5vdCBoYXBwZW5pbmcuICBDb3Vs
ZCB5b3UgZWxhYm9yYXRlPw0KPiANCj4gU29tZSBTRUFNQ0FMTHMgYXJlIGV4cGVjdGVkIHRvIHN1
Y2NlZWQsIGxpa2UgaW4gdGhlIEJVU1kgZXJyb3IgY29kZSBicmVha2luZw0KPiBzY2hlbWVzIGZv
ciB0aGUgUy1FUFQgb25lcy4NCg0KSWYgdGhleSBzdWNjZWVkIHRoZW4gdGhlIHNjX3JldHJ5KCkg
d2lsbCBqdXN0IGNhbGwgU0VBTUNBTEwgb25jZS4gIElmIHdlDQpyZWFsbHkgd2FudCBzb21lIFNF
QU1DQUxMIG5vdCB0byBoYW5kbGUgcnVubmluZyBvdXQgb2YgZW50cm9weSBhdCBhbGwsIGUuZy4s
DQp0aGV5IGNhbiBiZSBjYWxsZWQgaW4gY3JpdGljYWwgcGF0aCwgdGhlbiB3ZSBjYW4gY2hhbmdl
IHRoYXQgdG8NCmRvX3NlYW1jYWxsKCkgaW5zdGVhZC4NCg0KWypdIHRoZSBpbmNyZW1lbnRhbCBk
aWZmOg0KDQpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vdGR4LmggYi9hcmNoL3g4
Ni9pbmNsdWRlL2FzbS90ZHguaA0KaW5kZXggZDRjNjI0YzY5ZDdmLi42ODY1ZjYyNDM2YWQgMTAw
NjQ0DQotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS90ZHguaA0KKysrIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vdGR4LmgNCkBAIC0xMTMsNyArMTEzLDcgQEAgc3RhdGljIF9fYWx3YXlzX2lubGlu
ZSB1NjQgZG9fc2VhbWNhbGwoc2NfZnVuY190IGZ1bmMsDQp1NjQgZm4sDQogew0KICAgICAgICB1
NjQgcmV0Ow0KIA0KLSAgICAgICBwcmVlbXB0X2Rpc2FibGUoKTsNCisgICAgICAgbG9ja2RlcF9h
c3NlcnRfcHJlZW1wdGlvbl9kaXNhYmxlZCgpOw0KIA0KICAgICAgICAvKg0KICAgICAgICAgKiBT
RUFNQ0FMTHMgYXJlIG1hZGUgdG8gdGhlIFREWCBtb2R1bGUgYW5kIGNhbiBnZW5lcmF0ZSBkaXJ0
eQ0KQEAgLTEyOCw4ICsxMjgsNiBAQCBzdGF0aWMgX19hbHdheXNfaW5saW5lIHU2NCBkb19zZWFt
Y2FsbChzY19mdW5jX3QgZnVuYywNCnU2NCBmbiwNCiANCiAgICAgICAgcmV0ID0gZnVuYyhmbiwg
YXJncyk7DQogDQotICAgICAgIHByZWVtcHRfZW5hYmxlKCk7DQotDQogICAgICAgIHJldHVybiBy
ZXQ7DQogfQ0KIA0KQEAgLTE0MCw3ICsxMzgsOSBAQCBzdGF0aWMgX19hbHdheXNfaW5saW5lIHU2
NCBzY19yZXRyeShzY19mdW5jX3QgZnVuYywgdTY0DQpmbiwNCiAgICAgICAgdTY0IHJldDsNCiAN
CiAgICAgICAgZG8gew0KKyAgICAgICAgICAgICAgIHByZWVtcHRfZGlzYWJsZSgpOw0KICAgICAg
ICAgICAgICAgIHJldCA9IGRvX3NlYW1jYWxsKGZ1bmMsIGZuLCBhcmdzKTsNCisgICAgICAgICAg
ICAgICBwcmVlbXB0X2VuYWJsZSgpOw0KICAgICAgICB9IHdoaWxlIChyZXQgPT0gVERYX1JORF9O
T19FTlRST1BZICYmIC0tcmV0cnkpOw0KIA0KICAgICAgICByZXR1cm4gcmV0Ow0KZGlmZiAtLWdp
dCBhL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90
ZHguYw0KaW5kZXggYzdhOWEwODdjY2FmLi5kNmVlNGU1YTc1ZDIgMTAwNjQ0DQotLS0gYS9hcmNo
L3g4Ni92aXJ0L3ZteC90ZHgvdGR4LmMNCisrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHgu
Yw0KQEAgLTEyNjYsNyArMTI2Niw3IEBAIHN0YXRpYyBib29sIHBhZGRyX2lzX3RkeF9wcml2YXRl
KHVuc2lnbmVkIGxvbmcgcGh5cykNCiAgICAgICAgICAgICAgICByZXR1cm4gZmFsc2U7DQogDQog
ICAgICAgIC8qIEdldCBwYWdlIHR5cGUgZnJvbSB0aGUgVERYIG1vZHVsZSAqLw0KLSAgICAgICBz
cmV0ID0gX19zZWFtY2FsbF9yZXQoVERIX1BIWU1FTV9QQUdFX1JETUQsICZhcmdzKTsNCisgICAg
ICAgc3JldCA9IGRvX3NlYW1jYWxsKF9fc2VhbWNhbGxfcmV0LCBUREhfUEhZTUVNX1BBR0VfUkRN
RCwgJmFyZ3MpOw0KIA0KICAgICAgICAvKg0KICAgICAgICAgKiBUaGUgU0VBTUNBTEwgd2lsbCBu
b3QgcmV0dXJuIHN1Y2Nlc3MgdW5sZXNzIHRoZXJlIGlzIGENCkBAIC0xNTIyLDcgKzE1MjIsNyBA
QCBub2luc3RyIF9fZmxhdHRlbiB1NjQgdGRoX3ZwX2VudGVyKHN0cnVjdCB0ZHhfdnAgKnRkLA0K
c3RydWN0IHRkeF9tb2R1bGVfYXJncyAqYXINCiB7DQogICAgICAgIGFyZ3MtPnJjeCA9IHRkeF90
ZHZwcl9wYSh0ZCk7DQogDQotICAgICAgIHJldHVybiBfX3NlYW1jYWxsX3NhdmVkX3JldChUREhf
VlBfRU5URVIsIGFyZ3MpOw0KKyAgICAgICByZXR1cm4gZG9fc2VhbWNhbGwoX19zZWFtY2FsbF9z
YXZlZF9yZXQsIFRESF9WUF9FTlRFUiwgYXJncyk7DQogfQ0KIEVYUE9SVF9TWU1CT0xfR1BMKHRk
aF92cF9lbnRlcik7DQoNCg==

