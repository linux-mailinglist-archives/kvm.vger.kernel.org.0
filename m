Return-Path: <kvm+bounces-71385-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id puZuFBi1l2kL6wIAu9opvQ
	(envelope-from <kvm+bounces-71385-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 02:12:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AB7BC164180
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 02:12:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 4A5D930131CB
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 01:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53DD921D3E4;
	Fri, 20 Feb 2026 01:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WmG/wVXe"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1913F1DFF7;
	Fri, 20 Feb 2026 01:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771549961; cv=fail; b=gEP7i/nTTnCGNasAj5gAHj9WkFoKw0uab6y31hw/+XGyHJBqzpJS9/G3ZphZaJJiDHMRt/TJkIyyi41+hOIebhmw/e6glkxkSPJkCS3JoPp5Y2L7gRAZ8zi9vt7IvBzKjbTL2GvrOIhvGmtCIJyXuV6BnLEKIQtbriEANcHxHvI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771549961; c=relaxed/simple;
	bh=CtcxkGBxVofkB5kseeroojMUm0OhdLp9uEUHJzwzmDI=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=OlE33+BkdcJu8FJoDtl0qgeNQ8+XjQg9JAwgn2FT3IEls5dKpfOJje0c+vm6VoH5kaWsfkpjomVxT/2xTgap62u1p/W5/YN30BgTK2LQ1d2eK15/kxJxfG0HIqTpVsc3unfoVsc7ugVgCmM1q32fZ/qzdveRNTNKtYNFuLJVEBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WmG/wVXe; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771549959; x=1803085959;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=CtcxkGBxVofkB5kseeroojMUm0OhdLp9uEUHJzwzmDI=;
  b=WmG/wVXe8k2gFU6PgAVKtnJECk+TLyc8rw/SrzNrRrSeRLmCWK4bsGwX
   b9AOgJkNxAVuo/9xM37gjYzApAK5+eG5z30Xlqpw09KMLILebHQ2HJ3/1
   QajQXfek/XD/kAkKHLwv7dyJ8NpNNqls5zDoMprH8xGfqtTDXF1DOSpiq
   9utj3GlCjBYectYbZcfK0owCFhw5ix8VUR+GVZyAg93kbvEmC4CDCd4d5
   J+GBN4pUB/JlG1w+BvY7BgyEkhKE9aqr9uaAWicEwo9VUlp6yFaFQPzKB
   WjwsapDI1Nqf3PiKMZTsnJid+O7PDO/61NbeTNZFVVq2L44s0c077yYfU
   w==;
X-CSE-ConnectionGUID: gZXGH7WMS8WzZyXr332nNA==
X-CSE-MsgGUID: NVhTlRodQ2+8gLYPZbM4xg==
X-IronPort-AV: E=McAfee;i="6800,10657,11706"; a="95269691"
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="95269691"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 17:12:39 -0800
X-CSE-ConnectionGUID: EUZcDbMCQzCY903mswVDaQ==
X-CSE-MsgGUID: uuVeUk5wTcW0AZFq6wZOTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,301,1763452800"; 
   d="scan'208";a="243249774"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa001.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Feb 2026 17:12:38 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 17:12:37 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Thu, 19 Feb 2026 17:12:37 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.19) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Thu, 19 Feb 2026 17:12:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YjbzuGkmD3WaLd7U8KiTojQ0qRuw+Mmi9XZXlWfZdbQ7kSY1qixhUe4tiM7EPjvTfbmTueaNvbRuanJSAbTjGgXWCNhcR/ntN8pB3E3dkt9ec7XBFsSGEjMbEDCFjRcXf1y7bWIzZa6/5oivGETw3MWg0SDCU8XJrsc6MOie9XHaxRrzarCBaAgcqJvRaqnESFZpHJTSrjtzdYX8/SwvqRvCgyoRHH429Efgv0uPng/RiSwluI+pRYtAsBQOQI0GZJxF2+FjJHXIQpTAHrX+BO31EZZDkM1ACDPVf+Nt+GyMtP3Nwt6yFE6r5NmTH1w8tNSOL19HiEhMeZ1BSB14yA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CtcxkGBxVofkB5kseeroojMUm0OhdLp9uEUHJzwzmDI=;
 b=baONmIq9xbKz0bHFM0IaEMSZvh66BFPdNJ2ol3ApotOBkMwIax72Y/T/1FG+MXyIzBQLqsZ2Nesc7L0Rob/Yp7gSSPy589/0V6oC6XZzsp891OvslWbcxjPa5RuADKa3lb+hK4vWPZr8nyV3K1hschfkxoL8irzMocjO5nJ1ksvTfCg9W7N3wqkcNZSdqHDHgACoP9Pp92BWVaBQob7lFELvKlnSkHVVkNHCvrHhmV3tI4PuX7tgI2l3fT9ovY9gqon/hqQ7L+tMvi1g8CuXZ2buLVQleUhrsvWK81jqNrzpcqhQ4ndG513uauZ/Qsf2OtZZBlPp5wF4ZLihbfJSrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 DM3PPF7C7D8332C.namprd11.prod.outlook.com (2603:10b6:f:fc00::f31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.13; Fri, 20 Feb
 2026 01:12:29 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.010; Fri, 20 Feb 2026
 01:12:29 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "Chen, Farrah" <farrah.chen@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 04/24] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Thread-Topic: [PATCH v4 04/24] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Thread-Index: AQHcnCz5TZUFN+eNL0+dGnboZO9S27WK05qA
Date: Fri, 20 Feb 2026 01:12:29 +0000
Message-ID: <2683dff7a7950c57aa7a73584d86cf1b34bcfc07.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-5-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-5-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|DM3PPF7C7D8332C:EE_
x-ms-office365-filtering-correlation-id: cf631573-ecff-41d8-d3c9-08de701d1e3a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|7416014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?R01xb0J0dlk0Y3NtY1U2SW5nNS9aN282UVdHZFRBa0MrRDEzenNpSFRsbG5k?=
 =?utf-8?B?bWgvbHJFYkt4ZmFYemcwRzFTQjljV1VJSFIvZUxGQVMvNWlIUFVGd01yK3Fz?=
 =?utf-8?B?dVZNN0xDY002NDRaNEJId0N5UjlBS0lVNTBMejdEQlhudWtBd3JUUktGdlht?=
 =?utf-8?B?aWVZZkxiNEE4c2lKQVBMazhveUwzMHlUb1pnYlpyT0dWYWxYczdVM20rSzFQ?=
 =?utf-8?B?ZVB3WU1Xb0J1VDRIMEE1OHdZWlBJa0c2bTNMekNFUmRNaGtCUUlLdVFkU1pp?=
 =?utf-8?B?ZGpjM2R5WnZidU94bUFuKzA4YTZRbkRwelkzVDBmaHZGenJyTFQzZGpmVGlz?=
 =?utf-8?B?cHhGL3E0aEllS3laYzJUOTFZLzRJRE1mVTdmeXU3M3ZzUG83NHI3MVBaMVBa?=
 =?utf-8?B?dFRaOWxCMUlRTncxZ01ZZjZmT0VlVUFIZytIdWhPOXVneSs5L3M5bXVsYmdY?=
 =?utf-8?B?YXhERnlQNWoyUFdZaFovcE55S2o3QzAzczB5QWpDYUd0TzdHRmUrTDgzRno2?=
 =?utf-8?B?RjFZMVo0ZWRiRjZsbEJnT0JPYXl5cXM0MWhQQUJqdC85OC9BejlmL05KaFp0?=
 =?utf-8?B?RXRzeXh0RWgrMnRaWSt5OWtUWldLdUhYMEZwbEFEdlA2STI2YlhkdjFhNkhM?=
 =?utf-8?B?NXdrdThya3BtdklLeTNPNVgveUZ0RlpCb3QvM2RaTmVpbk44bkFsZ3lYL0lS?=
 =?utf-8?B?dEZtbUdZang3LzhNTDJER3lla1dMVTlVUXhWNUd0dWREYzdMUjFjMXFuMkk4?=
 =?utf-8?B?SWhnaDUwMzU0enVoZndnbStIcE9nOVBKZ29iTkoyVmRhTElaV0dnRCtwMUJa?=
 =?utf-8?B?Z1RLSVU1aXJUcUtTMHdWNDM1UFlXK05rOFF1WEl4Szg1dTlnTC9QdHZEc3cv?=
 =?utf-8?B?ekYyL2RjRFVNeWFqMWY4Lyt4dnp2WGwrQU9wYmV2QzVjK2EvbE5TbHNYZklP?=
 =?utf-8?B?U08vb3lNMmo4dndhbWJFdi9EREFqVEJsQWZ6ZTE1VTVlaEp0ZkNweGppN2Zx?=
 =?utf-8?B?Nmp3dVZsM0hkRWVvNUVjRGJiMUNabXRWSldVYlJRVVk1cmg1K3ZMOEFnRjFm?=
 =?utf-8?B?eDNZV0RpaHNlc3JQSzJ4cDFhT0lNT3lIdXVLWE9HZGtMQWhyT0p6Q0RPajB6?=
 =?utf-8?B?bC9memd5WHJ4ajQ5TnNOMXFDTlVSeUgyMHRjemFWazNHM05mcFFUenU4UHJJ?=
 =?utf-8?B?d0VuQkE5R0FYeld1NTBYbjhVS0luQWRSOUJuWUV0L2ozOE5VWkROUlN3UFFm?=
 =?utf-8?B?WFV2RVFoOUxPZFNGWmIrckpDaGJmRjhkZG5qb0cwMlp5Ylhrem1kYXFPV3NI?=
 =?utf-8?B?RExDL1lFbGthTy83SGQxL0N3VGlwQTVvbDVMYU5vODNNbzVBRXhpVTFHb1Ur?=
 =?utf-8?B?YWt5eEpzUTVvY1V0VVV0OHUzRy9tUDV3TlMvbHN6d0RQaVFPNWUwOXhyVFVM?=
 =?utf-8?B?djZkVWFCemx5TS9EOUZkUGZWMm9ZYnJCVkQ1WnVnUTd4dmlGdnkvUXlhNy9F?=
 =?utf-8?B?MGtyRzdqUVpiMGovMkhlWHlUZ3g5NmlpWVRPQTRXNlBGQkR5MHVCRU14blBu?=
 =?utf-8?B?YThOVzFNNHVkdEJyV3I5Szh4VHcvQ2k0bm0yRkJvcCtnK3hFeU1XMmRSWjdN?=
 =?utf-8?B?ZGYzaHFRc3kydDlvWU9BeFViRGhBQnhuOW5KWEpEZGVaeWdhbmlhbjArdmxq?=
 =?utf-8?B?N29ucEtDbk4rcHpuOE9FdG5RVjIrbW1aUGI1VzZhaTRDQjFMOFNKMk5mS2d6?=
 =?utf-8?B?MzZuL0VyTGJNeUJGVGJ3STRMT1FTR3JDYk1zamxpK2QxYWcwUXdhbndVUDha?=
 =?utf-8?B?NHllT00wUmV2aFpYVXZ5c2tnL1I5djRma0svNXg1bWJSSlRYbUJ0cmdWWHlV?=
 =?utf-8?B?bVgxS0lKZ2IrSEVCYnZHK2orUVZkNDBESDNhSzFFbEU3bjZTTXFzdVY3RXI3?=
 =?utf-8?B?cElEV3kxT1luYnpxaVdpTWdXZy9ZMEJkOFMzQWoxZmwzNWdodFdEUFI4MktY?=
 =?utf-8?B?NnlTcUs5bnRGakxKbWh5cWl1OFlpZDU3MElSNWNkOXl6WnpRQTJVY1FKbEJk?=
 =?utf-8?B?dFpPVW9zZzZieExBdVhOZkRYOFVQN0U4M2RjaFgrd1d1M24rSzkwTExzSGFY?=
 =?utf-8?B?b0FFZGFDUittYkR2QXVBV2ZhTHk2V3J2SG9WbC8xQXR0bFFoWWpDSWRmY3l4?=
 =?utf-8?Q?GhSzY3izT/nQzdcamraRHAo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nm5haDRQcU4xaEZhTElwcGN3M1ppcWtTdlJFZUMyNkt1RjUxTFVkdVlNM1Vi?=
 =?utf-8?B?SGFMTk5LVmFpS0o1djdPSFNTOTNPMlpuRWhSNkxtS0gwNUdOaVFYTmRIRk5W?=
 =?utf-8?B?L2hhelZTUlFsV1pvNGpkK1JCWGRzL0tJbGlvdG1rOEs1bnVtd3c3YVRsdUJq?=
 =?utf-8?B?alNSVG1za2ZoVTJhT3dKN0o4bHN3TTY2RUxzNGJFUElqTzBXWUtvdTE5aFVo?=
 =?utf-8?B?Zk5kSVBSZllrcm8rUE9XaG1uY0M5QmJaL1U2VUd2L0FhQ1JOUDVKRGY2SHBK?=
 =?utf-8?B?UFNkRHh6clNMVlo1WTRkZnVZdGdvRUFQNEdCdHY2eFRGWVg3WFNrQkNZeFdn?=
 =?utf-8?B?dHViNTdtYVdDMGNRT3JIczU3dm5NS3NYNDJGcHhBYmFWYVZHaUQvTE9INnVk?=
 =?utf-8?B?Y3RuTnVmWDRPOE8zTGMyNUdRTktvRnVtS0duL1R3cEZVUHU5S1QweDJ1VVJZ?=
 =?utf-8?B?ZFNDWFhwNlZrcmE2TEtTUCtaaEM3ZEZLSVExRm16alB2T1dzbEljZklNUHRr?=
 =?utf-8?B?ZVpOQXRYbHdmV3FYV2d4bHc5YnFUa1NhYkdmNWdyMzMxcjZiRGFXM1FEc3JU?=
 =?utf-8?B?YTRLNm4zbmc0L05yanFhdjZGNDRGbEpJRVlUelNJdjMwa3JSNFFZakhzRHgw?=
 =?utf-8?B?U3FZNGZ5RW0zKytSL1gxR3NqZklHaFdPWUducDArK3VkeVJNeUdPa0c5eFlX?=
 =?utf-8?B?bTZDczlHalJSaE5ubWU2SE5nMFJpVzIrbUVvcTJpTEpIUFdML05oNG11OG1z?=
 =?utf-8?B?eEJnMGNvZmFmRUhKOGU3U291bU1ibEsvRUVOTWtQdnkxQmIrbnlSV3llb3JN?=
 =?utf-8?B?OGpFeDh6Z3JDR1N5bWZWQWg2N0hqQXMyekcyTHUwUkxBMDk0T240cWRydk1U?=
 =?utf-8?B?TnFHckMwQmFxbTFRbVV5emNLa1hybHNtdGdaTUJGbUtBYTdOUGlwUXJVNDNJ?=
 =?utf-8?B?dUNESTRmVkxWL3Q1WFZIeWlLZlViK3EvNDV0aE43Wnp0OUtEU3dMWXBBdnBx?=
 =?utf-8?B?ZUVYeU1mUXpBUE42OGx3U3AwZ1RTNFJtQkc3N0xodDFLNFgzZGw2ZHB2ZkxO?=
 =?utf-8?B?d0MxQTBlSTQxV1hjWWhCWEpBRXVZVkM0RDM5YnQ3WXJab1oxZEJVaytuM2dP?=
 =?utf-8?B?Um15NlVMd05RZVZNc2VzbXBOZXFxTUNCeGlsZERTYTB5YlpTWFkzMUJDRGNl?=
 =?utf-8?B?M09hd0MyS0R2Q1ZrWTZHUlAyRm5udXJZbnBkVEdnQzlCdHhuUW1BM1NnVkJJ?=
 =?utf-8?B?WHJreHUrY2d5VFhvNngzeS8rNGx0c0dVNFVZSTNRckJQVEJ6bXRjdmN0NUsx?=
 =?utf-8?B?OXhUb2dCTmdKZDZUQ1FjaUN4NGpUcCt3UW1iK2VlOXhqODVUR0k2Z2hYNHVU?=
 =?utf-8?B?ZWp2RjBBRThpY3NIcFVhdE03K3I5YzhkVG9meENhcTUvc0Rta29sUkJ2SWI4?=
 =?utf-8?B?REVDc3FyK0M0U3hVQ041NS9yY2xFenhZNG5FeWJ1QThrakRUbVRQTTVSMVpy?=
 =?utf-8?B?L1J0RDRiYTVrZThjWlRNZ1Q4RjJGL0FZSFJDc21QdXJMUEd1aHFDbUVXSGdi?=
 =?utf-8?B?K2FaaGhvOEVGdXhhZnUwdkhHU2R1QjM3cHp2c1JpbXIxTkZNS3l0SzF4emM4?=
 =?utf-8?B?M3crb3hseG1OZ2UxTDhhVWNUbUNHNW9Ra0VvdzdwMGg4TzFqTWRDSkp0Z2No?=
 =?utf-8?B?cmRYL05pTU5sa25CZGd0b0NJa2xxRU5UbUo4SXFhOXY1S0NqUG9EY1QyWGc0?=
 =?utf-8?B?OWdlanVtNy9EZDJ1UVhKOWYwbDJ5SmllWWR0VmFEWFlkZGtEQ2kzelh1bWRv?=
 =?utf-8?B?U0VWZHpjWUhsNnRtbTRhMi9GUEhpTkU0WGlDUHlFZWZzSy9CbjVFRDdNRmli?=
 =?utf-8?B?WlA2S3hYM0JXeHpqbndLY3VYL0FYMmNyNHdjRHlsN3RFOFJmYVZjNkNHRFV3?=
 =?utf-8?B?Q3NBQS9WaUF3RjlGcXMyTEs3YVc3QnhCMkhrRHU3aWYyc2Z6RXRucUNkWE9x?=
 =?utf-8?B?RlQ2bTQvSExMbmR2bGNUanZ5Q1pPb2sxRzNMOFRpQ1NmU05uci80OTdPck00?=
 =?utf-8?B?emNVVHBPNkhhdnJyR2tCWER5NWdyMXdSYnpxTlF5bzlNMTJxNE1XWEo1VjdH?=
 =?utf-8?B?RzIycjNGZGgycEdKYWQ0K1pOaFZsSXo4NEVBZnRIZGdNL0xvbHpER1JpMWht?=
 =?utf-8?B?d2FSVXhEeDlDYjh5bzRrMTBaaGNKZGRMZkVrT3BGRDFBQU15eTV6RzAxL1px?=
 =?utf-8?B?UG5OZVRSZU0vcHA1elRzcGRWWWluZzZLYzFvUlVzb1dDcDFWaVY1Tlk4OThk?=
 =?utf-8?B?Mng3TDMrU0Z1eVJJdzdQcEJMNnUrdmFOSFhVeThIMnZ2VTRvS0IvZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC87D954694B154C97E22A8913753FF2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cf631573-ecff-41d8-d3c9-08de701d1e3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Feb 2026 01:12:29.6551
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: R2CfJ6WGaEDUBYx6ykJrMWsq3Q/S/6xxNaXF030bnjCEMpChXWTgUnDc8aT31t9q69sJbTfXVG5lEcViTstXkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF7C7D8332C
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71385-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:mid,intel.com:dkim,intel.com:url,intel.com:email];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.996];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: AB7BC164180
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gVGhl
IFREWCBhcmNoaXRlY3R1cmUgdXNlcyB0aGUgIlNFQU1DQUxMIiBpbnN0cnVjdGlvbiB0byBjb21t
dW5pY2F0ZSB3aXRoDQo+IFNFQU0gbW9kZSBzb2Z0d2FyZS4gUmlnaHQgbm93LCB0aGUgb25seSBT
RUFNIG1vZGUgc29mdHdhcmUgdGhhdCB0aGUga2VybmVsDQo+IGNvbW11bmljYXRlcyB3aXRoIGlz
IHRoZSBURFggbW9kdWxlLiBCdXQsIHRoZXJlIGlzIGFjdHVhbGx5IGFub3RoZXINCj4gY29tcG9u
ZW50IHRoYXQgcnVucyBpbiBTRUFNIG1vZGUgYnV0IGl0IGlzIHNlcGFyYXRlIGZyb20gdGhlIFRE
WCBtb2R1bGU6DQo+IHRoZSBwZXJzaXN0ZW50IFNFQU0gbG9hZGVyIG9yICJQLVNFQU1MRFIiLiBS
aWdodCBub3csIHRoZSBvbmx5IGNvbXBvbmVudA0KPiB0aGF0IGNvbW11bmljYXRlcyB3aXRoIGl0
IGlzIHRoZSBCSU9TIHdoaWNoIGxvYWRzIHRoZSBURFggbW9kdWxlIGl0c2VsZiBhdA0KPiBib290
LiBCdXQsIHRvIHN1cHBvcnQgdXBkYXRpbmcgdGhlIFREWCBtb2R1bGUsIHRoZSBrZXJuZWwgbm93
IG5lZWRzIHRvIGJlDQo+IGFibGUgdG8gdGFsayB0byBpdC4NCj4gDQo+IFAtU0VBTUxEUiBTRUFN
Q0FMTHMgZGlmZmVyIGZyb20gVERYIE1vZHVsZSBTRUFNQ0FMTHMgaW4gYXJlYXMgc3VjaCBhcw0K
PiBjb25jdXJyZW5jeSByZXF1aXJlbWVudHMuIEFkZCBhIFAtU0VBTUxEUiB3cmFwcGVyIHRvIGhh
bmRsZSB0aGVzZQ0KPiBkaWZmZXJlbmNlcyBhbmQgcHJlcGFyZSBmb3IgaW1wbGVtZW50aW5nIGNv
bmNyZXRlIGZ1bmN0aW9ucy4NCj4gDQo+IE5vdGUgdGhhdCB1bmxpa2UgUC1TRUFNTERSLCB0aGVy
ZSBpcyBhbHNvIGEgbm9uLXBlcnNpc3RlbnQgU0VBTSBsb2FkZXINCj4gKCJOUC1TRUFNTERSIiku
IFRoaXMgaXMgYW4gYXV0aGVudGljYXRlZCBjb2RlIG1vZHVsZSAoQUNNKSB0aGF0IGlzIG5vdA0K
PiBjYWxsYWJsZSBhdCBydW50aW1lLiBPbmx5IEJJT1MgbGF1bmNoZXMgaXQgdG8gbG9hZCBQLVNF
QU1MRFIgYXQgYm9vdDsNCg0KWy4uLl0NCg0KPiB0aGUga2VybmVsIGRvZXMgbm90IGludGVyYWN0
IHdpdGggaXQuDQoNCk5pdDoNCg0KQWdhaW4sIHRvIG1lIHRoaXMgb25seSBkZXNjcmliZXMgd2hh
dCBkb2VzIHRoZSBrZXJuZWwgZG8gdG9kYXkuICBJdCBkb2Vzbid0DQpkZXNjcmliZSB3aGF0IHRo
ZSBrZXJuZWwgbmVlZHMgdG8gZG8gZm9yIHJ1bnRpbWUgdXBkYXRpbmcuDQoNCk1heWJlIGl0IGNh
biBqdXN0IGJlIHNvbWV0aGluZyBsaWtlOg0KDQogIFRoZSBrZXJuZWwgZG9lcyBub3QgbmVlZCB0
byBpbnRlcmFjdCB3aXRoIGl0IGZvciBydW50aW1lIHVwZGF0ZS4NCg0KQnV0IEkgZG9uJ3Qga25v
dyB3aHkgZG8geW91IGV2ZW4gbmVlZCB0byB0YWxrIGFib3V0IE5QLVNFQU1MRFIuDQoNCj4gDQo+
IEZvciBkZXRhaWxzIG9mIFAtU0VBTUxEUiBTRUFNQ0FMTHMsIHNlZSBJbnRlbMKuIFRydXN0IERv
bWFpbiBDUFUNCj4gQXJjaGl0ZWN0dXJhbCBFeHRlbnNpb25zLCBSZXZpc2lvbiAzNDM3NTQtMDAy
LCBDaGFwdGVyIDIuMyAiSU5TVFJVQ1RJT04NCj4gU0VUIFJFRkVSRU5DRSIuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiBUZXN0ZWQtYnk6IEZh
cnJhaCBDaGVuIDxmYXJyYWguY2hlbkBpbnRlbC5jb20+DQo+IExpbms6IGh0dHBzOi8vY2RyZHYy
LmludGVsLmNvbS92MS9kbC9nZXRDb250ZW50LzczMzU4MiAjIFsxXQ0KPiANCg0KWy4uLl0NCg0K
PiArICogU2VyaWFsaXplIFAtU0VBTUxEUiBjYWxscyBzaW5jZSB0aGUgaGFyZHdhcmUgb25seSBh
bGxvd3MgYSBzaW5nbGUgQ1BVIHRvDQo+ICsgKiBpbnRlcmFjdCB3aXRoIFAtU0VBTUxEUiBzaW11
bHRhbmVvdXNseS4NCj4gKyAqLw0KPiArc3RhdGljIERFRklORV9SQVdfU1BJTkxPQ0soc2VhbWxk
cl9sb2NrKTsNCj4gKw0KPiArc3RhdGljIF9fbWF5YmVfdW51c2VkIGludCBzZWFtbGRyX2NhbGwo
dTY0IGZuLCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICphcmdzKQ0KPiArew0KPiArCS8qDQo+ICsJ
ICogU2VyaWFsaXplIFAtU0VBTUxEUiBjYWxscyBhbmQgZGlzYWJsZSBpbnRlcnJ1cHRzIGFzIHRo
ZSBjYWxscw0KPiArCSAqIGNhbiBiZSBtYWRlIGZyb20gSVJRIGNvbnRleHQuDQo+ICsJICovDQo+
ICsJZ3VhcmQocmF3X3NwaW5sb2NrX2lycXNhdmUpKCZzZWFtbGRyX2xvY2spOw0KDQpXaHkgZG8g
eW91IG5lZWQgdG8gZGlzYWJsZSBJUlE/ICBBIHBsYWluIHJhd19zcGlubG9jayBzaG91bGQgd29y
ayB3aXRoIGJvdGgNCmNhc2VzIHdoZXJlIHNlYW1sZHJfY2FsbCgpIGlzIGNhbGxlZCBmcm9tIElS
USBkaXNhYmxlZCBjb250ZXh0IGFuZCBub3JtYWwNCnRhc2sgY29udGV4dD8gDQoNCj4gKwlyZXR1
cm4gc2VhbWNhbGxfcHJlcnIoZm4sIGFyZ3MpOw0KPiArfQ0K

