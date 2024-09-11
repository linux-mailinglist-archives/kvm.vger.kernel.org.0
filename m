Return-Path: <kvm+bounces-26561-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB7E0975870
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 18:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F05681C234B6
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:30:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27A8B1B1419;
	Wed, 11 Sep 2024 16:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cITTZfcO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6D31A76D1;
	Wed, 11 Sep 2024 16:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072205; cv=fail; b=PCOWaHoHQptsntRyTovJUbRcdx0+EICOPJ4xLQz3/n2GaspEDn7UGcKigVD+bTEdchXLjvloKpW0C+G5CoKyWmnDuwUL4lcYq8Px8+inO4WUH9zbAWqd9tkz9DMV3abVcXc8kj51eXFiX5UghXenGeDD6g3YSQYutHxgLbNpbeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072205; c=relaxed/simple;
	bh=a2Zs7OkkylzpsCean7KQCXMAGQdpxMOsGdxFL+58U7s=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UR9Bi873g2/2hFiF9fswwkTOraoqhdR/iNrgUJU6/v9FRtu3U7Gg/H6Lmq74+raDm4+pYs1saPdrWRjvswj+92Vd7bAHhOt01QHbXDYThwfbJHkfAhpUTV+QO/eeDFIzQ+AUUOVamUd32mKV7i1Ic3hV9TYewXF+mTiBItgznig=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cITTZfcO; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726072204; x=1757608204;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=a2Zs7OkkylzpsCean7KQCXMAGQdpxMOsGdxFL+58U7s=;
  b=cITTZfcO2iJ9dN3IB6APfrGlNSlm2WuXw4T0a/MgShcDjHYQD6fmA+/w
   6NExAkZGy2MevRwrGIjzAljv4xKINwjgziWxKg5WUICCmVcepS5GFOqwJ
   zUfo2D3fIZexjByPOnRp6JzTN4fy+/wa165Y3NMfVQ9IYkc57fJ3MnDpA
   V1WMdr8gH7ek9QdhWlo9+1RiqK1VRNGnc15iDnyC0mXJnSqXNGdM1Atcd
   hkrl9XTmV9Bc8hqKMP0fXVTFKMZB9xoqJnlG4jzS8zhvczQQyG9mAgsJ2
   qqUU8R9j0Aj58QB2Ejs6LM8vkH0NYl73C6P4GqeJhPEtFikwp6tuadVzb
   w==;
X-CSE-ConnectionGUID: aiWs/G1AQK+BZDQN9k+Jzw==
X-CSE-MsgGUID: v39gcQjeR6aTVjikN1a3Xg==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="35455103"
X-IronPort-AV: E=Sophos;i="6.10,220,1719903600"; 
   d="scan'208";a="35455103"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 09:30:02 -0700
X-CSE-ConnectionGUID: 8ynLOesCRrmJ2D8mQbc5zA==
X-CSE-MsgGUID: 3TWHR8p+TbSxyU1oEHIwOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,220,1719903600"; 
   d="scan'208";a="98248939"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 09:30:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 09:30:00 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 09:30:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 09:30:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JqhPppoUhEKdexH5AxxlTuGjHcKbcFC6FRqhDX+szmLAg9xO/PTB4ASKH9PCB8wnteh/FMHFLCRNzS0UA1pv5Hgj2pPK1Rn1slvGO5z198+6PO2UBfrOjszJMWnh8vh6vjkIiJQXv84sWqH14Vuu2wmyvmIlPGmRFh/E+2lzTPM4XOu/ER1qmNi2KZeXeYgYpT8G2z7lyH/6gGnDiFFuHe1iQanpL4mbm73GTxniVs7Zbo+l7EiqQ2KQAYIKR8yGlnGbWwQd3uZA602eujdDIr5xSHjJ7OnopWX9a6QQhBafl+ARZ268Q7gG0BR3qi+Yf6TNfGbvQUzN8TqA+AWrVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a2Zs7OkkylzpsCean7KQCXMAGQdpxMOsGdxFL+58U7s=;
 b=P7t7Px8aZSXsLjck0Rkw10YIFToqBbMrGpxwDaSxtq0vyvi9P81GitOcMrWOL3v1k0lo/j+7hHQ1Wm8uKUZMCinFnJFT/dxaW95lLxsID3RKulFHcZlS1xryxEoS+rhjXjdIBugqA35awzXY5pQDqV00Q2vadSNbNt0Li/KdIa1rlWOOPJhoeGhx61RE8fKKnlLveXkYImvkavyyrbObbjE8JWd/C0uN2W+mqjruSRtGfkYNqG4xFYTsJGKe2K4XlSkx9wxN8VSPDA/fRrz0cI8Bktak2b4yRELvlBZ2209EbAfS8BwrLovwcm7JTikGuyNHV3D1ZBTlJ5j7XL+YIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6569.namprd11.prod.outlook.com (2603:10b6:303:1e1::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7962.17; Wed, 11 Sep
 2024 16:29:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 16:29:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private
 mem
Thread-Topic: [PATCH 05/21] KVM: VMX: Teach EPT violation helper about private
 mem
Thread-Index: AQHa/ne3O2iijDNUfE6b9PGncB+dfLJSUuaAgAB/1wA=
Date: Wed, 11 Sep 2024 16:29:57 +0000
Message-ID: <3936872ab5bd396051a67f46b92a44e4b35fba45.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-6-rick.p.edgecombe@intel.com>
	 <ZuFaR0xiGITjy0km@intel.com>
In-Reply-To: <ZuFaR0xiGITjy0km@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6569:EE_
x-ms-office365-filtering-correlation-id: 5695096e-f29f-4e4d-3340-08dcd27ef959
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?K0t6RlVTaXB6YW1rWGFIQ2k1SjlpZmUvcGdVZ1hNOXRHZVQxVSt3NjNxc0JF?=
 =?utf-8?B?UGJJaFRzNXpuTm5vU1dBck1GaFNCbEY2ZjNxVnE0MlJVQzhrbElYTHRUMDV1?=
 =?utf-8?B?NjlodTdkeVdGeUZncG5VT0lGOEpmYkZCSGN1NFBHMTBZYlAvU2VaR05EL2g4?=
 =?utf-8?B?OU9qU1lEeGxFOUR1VjEvZ0ROSGNreDdzZUpmL1pqU1lubDFjTmdsV0ovVWZM?=
 =?utf-8?B?WThQNmtFVVkxUXhJR05UcTliMDdxSHFyYzlYTmJuWS9VWXBtVjlxTlBuSVBI?=
 =?utf-8?B?aitYK1AyL3FUWWNDQjlzRHZoMmVKRCtpNlI3aitGbi9MMDg4TmZGTE9HYVVJ?=
 =?utf-8?B?T0FuQyt1SWZQR05NVjZSY3NWaGc4aDQ1Zm9SUGRCRW8yajVKRGR5a3YycVFH?=
 =?utf-8?B?OVYycmg5cldBcE1hblRpanRnQWZSb2pSUGErU2JwQ3NjRUZJWERsdEZuUlFH?=
 =?utf-8?B?cGxYamI2VG5ZRittT3hXKy9EK0lUdVNZVDNwTVJMa1JRZy94dWpsVWF4eGlF?=
 =?utf-8?B?TEprTlJUWHBGa0NVRHU5STZJR0VYNXh2K1NUdGxVYm9PY0RySHU5L29PdE91?=
 =?utf-8?B?d0hKZFNOd0NYK01UZ0JjTS9EOFFodVNacklBeVpUcTA5MUJvTjF5dDU4L3VT?=
 =?utf-8?B?OUpSTzBac2JVMHY0UXc0Vmp3LzFZeEhRd3dtaWxBU2FPQ0FjQUhvZjBwamxI?=
 =?utf-8?B?YlJuRHIybzdGK2F0czBxMENpRC9wTHhibS85TXZhT09HR1h4U05LeXR1Y0U1?=
 =?utf-8?B?cnh6a2RNU3hGZE9LUW1ibEdaSFZXM01uMGF3WGt5Z3M2d2NNdnEvVjlzR0xl?=
 =?utf-8?B?NDNzcVhXbnArWlo5S3BBMktiK2xwK1dGY091bFBxOGNYa2dEbzZ0UkRvb0xn?=
 =?utf-8?B?aVFBREU5ZDdiU0krSXp6MmsvZkFCOHNwQU9naHFBUFJGaDE1RmprR1lHejJu?=
 =?utf-8?B?eUkycDhYbDNOT2ZGTmdJWEdyVFoyK2xJYWRIcDdXSUliY3U2Mzl5WlFxaThZ?=
 =?utf-8?B?WS81b20wSVlWZEFkNUVBdC9FQ0dqNmVxZktVNDNhcitlRkZuaHpscUtSYWQw?=
 =?utf-8?B?SE04RTVIbnBqOGN3b2RJQTU1cXFDdWNOQ05LUVZlOTNiWmdFYi9XWFdtWTRB?=
 =?utf-8?B?ZmYzbWpBbnlibXcwdjJjbjNGbnFxZlByaldwbStYWEpUcW1SV2YxbklUM1pD?=
 =?utf-8?B?T3dDSEJ3VlJjMENtbG5rTEQ5YXVpSTFNZHdOWGROZG1LVUR4NDRmNWtHVEJy?=
 =?utf-8?B?VmpOT2FYK3F2ZldoMm5leWd0M2ZuUVRHUm83QlRBZGxyQjZ5d1Y3eE5wZXlT?=
 =?utf-8?B?V1pQc28yYm5Pd0crcFArd3VObzJndGJYcXVrc3NiUTVhTUdoR1BYdWFFeldJ?=
 =?utf-8?B?L1VlYkRPT3M5SEtQZkorR2l6WlRSdXJ0dlZVd1N5WGVEWkdUdFZhZ1NOQmI0?=
 =?utf-8?B?UlhMRW5RSTYyS1liekdnUSsrMVJPRmp3elBrSGhXK1V2Y2FEZ2hXeU1DaHVu?=
 =?utf-8?B?M0JGU2NSVlcxbEsrdndTNE5wWVpJdEl4S3dPUFdlM1N0NnlWREg3Qy9uVVQ1?=
 =?utf-8?B?U1RwaXRoZXZucUlzUXoxUXllZTUxL0VKWmZOVVljRjBXYzMrUlFac2RSQ0k5?=
 =?utf-8?B?c2FnWGl1anNzdVZvZlViQzhWK3JYaXA4QmJVSVRsT3BSUTZZU0dOek5JQkNF?=
 =?utf-8?B?STJpMStDVmNqS1NCbUJYenlPenBsd1BYQVl4ZC91UDQzS0FYdXJlQy9LclNX?=
 =?utf-8?B?RG5LTCtYWXhMWjBFWm94VWt5T0tSRGl2VVlnRCtTcUZ5SThKWlBmZGFlZFZ6?=
 =?utf-8?B?L0VHNGl0blhtNkl6bVlCOG5ENUpHdXkwUW9ZL0doVSt0bVRaNUMvam93SS8r?=
 =?utf-8?B?UWM3ZnNUdC9SRFZxZ2VTcUdaV09mZFFRQWZrTUYyTDRZUHc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2ZLWWNQWTFPSE9IN2Evby9YUmlYSnNUdDdhWFhTRnBtVld4ZlVTY2JLNjhq?=
 =?utf-8?B?T0FDWnEyaXEzd0c0TXJ2TVJNNmFUallHSXVvaERyNVNrcnkydXpndTR4V21C?=
 =?utf-8?B?ODBCbzB3eEJha0s5OTUvMTFleFVmRDlaRjZRTnNEbXF4WHVqSytCekpDMW9y?=
 =?utf-8?B?SnZSUnp1dXFvTkU4a1lNU1NhOG4yOUxhZWRESnF0OXhlb2JOSWdzVC9kdXF5?=
 =?utf-8?B?V2lCSmhEMkZpU2hmaXJXZlF0QWFWcm5CQnRWR3o3ODZnWVc3ZzR3dUgwZ1Uv?=
 =?utf-8?B?LzVuMEtWazdRNDYvMGhrcWNwRVczbTBUb1M2dGVkTk1pa1BxckJ5TmIwUml3?=
 =?utf-8?B?VHdHRGhOM3A5TEJZT1dkNDNRemRpQ0tPckJGcjRuKzdTT1ppOWVFREhMc1Bv?=
 =?utf-8?B?WFVrd0trNDVwVThHd0RiSEtDT25zNkJFTWYrQURuVk5zOFRaSENVdlgvSm5q?=
 =?utf-8?B?YjNmNENIOEluQTZxb2V5aXoycVBjckV1aTF1WWNaU2k1Y3pveFVpdUdTUXR2?=
 =?utf-8?B?SkxVR0lLWCt1UnVqcXFXUzN1eTBGeGNTcThkN0FJY043MTFyRjBDT0ZXM2tz?=
 =?utf-8?B?cUlES0FHb0ZXcnh3RHFCS1ZUQ0NqSy9tWWQxY3JMYmJNdURNVFh0TEl2UkZw?=
 =?utf-8?B?dWdRTk5NUWhpZnZ6UzhWUDE3UG9jMTBFZWJHSEoxSGFTUDVyZnc4M1c3MWpW?=
 =?utf-8?B?bUdOWTQxUXRDZWdoQVhUbWlxS1lEYkxkL2I5NTZrOEsreVNrOEh1a0Z0ZUIw?=
 =?utf-8?B?blBjSHJoMFFUbHJ1enFhRjVtK1hrbEVteFYybDVjVjhjM2FiZ1RjcUhwWkda?=
 =?utf-8?B?bTdRRmZzUGQyLzBMWWQ4eExNeE1VSks2L2hHa3cwWnk1Z2ZNbjJyYlNYWjd2?=
 =?utf-8?B?RlU5MEJOVFovYmEwVHJDRzh0aTh4WjFQZG9ocVNSM3VpZkRCQTFwdFVmZUNZ?=
 =?utf-8?B?Y1MvcVM4N0p1bXBtNzI5Tkl2dUVTeXg4eC95aXNiS0hMOFZtWk02UHBlSnFm?=
 =?utf-8?B?TFNPZzg4R2pra0duTnozbjZsa3pmM3hPS1duYXk5d2dvSDBWbmNIbzJ0bmZT?=
 =?utf-8?B?NklodEZ0Q3M5N21uRmo2UzYrTVlOekZJYWtaeGUrUEkwOEZUSTN3UmVIRUcw?=
 =?utf-8?B?Q0VIM2pDWmJ3NFJYeWNDR3I4N0x3Mk90ekhxYnJGNUJKUExJNU9GTytCdVZ0?=
 =?utf-8?B?OCtldGg4ZCtRZFFYZ3VpWG5tdGV6VmhvODNVYU9qbGYxd0tGZDc3UXM3QnZy?=
 =?utf-8?B?dDlLMG8xV3ZxVUczVTdIZVBRU2V2Nm4vNTg1ZjRXMFd6RGJmc0NSdG15OXdE?=
 =?utf-8?B?WEtkUDVjaEF4NW5BU0ZLZWwvNm1MbkVWaVJodHdJN2Y2d1l3cjBhRm5rQVpM?=
 =?utf-8?B?SDZWektvd2U2RHJ5YXhKSms0bjhlWTJrK1NweEJyOENMUlR2dkgxeW1RSGVr?=
 =?utf-8?B?dGJ4WEprV3VPS0tLMm05YTBTU2VZcTJoNzZubmI3YWcrWjRMZ0ZLTW0wQnBZ?=
 =?utf-8?B?OFlmZGxCL3JqdStHRlgwY2dtTk5HbHJGUmVPK25EYUJVRW1RWGlnc2xZR2hY?=
 =?utf-8?B?c0RUUWJHS2ZucGJob3VTTGNyWlp0V3F6Szhhbk5UYjBRbU9pbjRzemtpS3dI?=
 =?utf-8?B?K2xINnEwbE1Lcm1teWs2bElVZ29hZUE1ZzJwK0F2d1RLUTdtay9pT20yMEZ2?=
 =?utf-8?B?MUFRUXJhNmplZklhdGRmcUVMS21Ud2l6VW9xSzJYd0phRTErWE1uTWtTTkw1?=
 =?utf-8?B?blFxeEFoMmdzRlBXenNuQmtnUk0zRFlCWU5NSTh3b1dSVjl6RE12TzFGMnNp?=
 =?utf-8?B?UWxCS050cnlHelcxN0tkYXp3UWdKTEloSmJGbUllKy9CS2pEOXdzSnY2VThm?=
 =?utf-8?B?ZW4rUU1ULzUwaXRkUWZodm9UV2o2YUVxSmlKRW1BRi85bTdmMTh0WmRmdkIx?=
 =?utf-8?B?Z1dLTE5qcEg2Uk1SaXdqOFBHc2dWaVhIdEVJWnI1c2lrdkF1enBuMXl0VW5H?=
 =?utf-8?B?OStZRHFXWVNWNStkR1dabXdBQ3kzMlJmbmZMOCtJTHVMWTJyNktKeVpNOE8v?=
 =?utf-8?B?bUFGWHpxSlUvYUJBNjUwZnRHU0NMeWVYVmk1QTMrRDFBV3FTTytidlpZNW1w?=
 =?utf-8?B?NE9CUWVKWnJaRDUyTFdUK250UkFMMi9oLzdZcmxGRGxaZm55eG5vQnM4M1ND?=
 =?utf-8?B?cVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A829DAC3F7ABA44BBD782487245F05CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5695096e-f29f-4e4d-3340-08dcd27ef959
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 16:29:57.0337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8JXtgFJvjpxdMbe8UDxwQOOoGtTA5E5yAbGOx9S7AW5SIsTvx0VS91Ga43O+tTjMBx2VP0VOmsbh1HCbIa9OxXmIf/vhghZB7CW1akhca44=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6569
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA5LTExIGF0IDE2OjUyICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiAr
wqDCoMKgwqDCoMKgwqAvKg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIERvbid0IHJlbHkgb24gR0ZO
J3MgYXR0cmlidXRlIHRyYWNraW5nIHhhcnJheSB0byBwcmV2ZW50IEVQVA0KPiA+IHZpb2xhdGlv
bg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqIGxvb3BzLg0KPiA+ICvCoMKgwqDCoMKgwqDCoCAqLw0K
PiANCj4gVGhlIGNvbW1lbnQgc2VlbXMgYSBiaXQgb2RkIHRvIG1lLiBXZSBjYW5ub3QgdXNlIHRo
ZSBnZm4gYXR0cmlidXRlIGZyb20gdGhlDQo+IGF0dHJpYnV0ZSB4YXJyYXkgc2ltcGx5IGJlY2F1
c2UgaGVyZSB3ZSBuZWVkIHRvIGRldGVybWluZSBpZiAqdGhpcyBhY2Nlc3MqIGlzDQo+IHRvIHBy
aXZhdGUgbWVtb3J5LCB3aGljaCBtYXkgbm90IG1hdGNoIHRoZSBnZm4gYXR0cmlidXRlLiBFdmVu
IGlmIHRoZXJlIGFyZQ0KPiBvdGhlciB3YXlzIHRvIHByZXZlbnQgYW4gaW5maW5pdGUgRVBUIHZp
b2xhdGlvbiBsb29wLCB3ZSBzdGlsbCBuZWVkIHRvIGNoZWNrDQo+IHRoZSBzaGFyZWQgYml0IGlu
IHRoZSBmYXVsdGluZyBHUEEuDQoNClllYSB0aGlzIGNvbW1lbnQgaXMgbm90IHN1cGVyIGluZm9y
bWF0aXZlLiBXZSBjYW4gcHJvYmFibHkganVzdCBkcm9wIGl0Lg0K

