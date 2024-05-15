Return-Path: <kvm+bounces-17476-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 553C68C6F1D
	for <lists+kvm@lfdr.de>; Thu, 16 May 2024 01:22:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0945B2815B3
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 23:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95E844EB3D;
	Wed, 15 May 2024 23:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="duQ++Wfi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724503C48E;
	Wed, 15 May 2024 23:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715815323; cv=fail; b=X13aiJq3IrEwonf/MBHrtH5+8q6BH5h5t3eJTIaSi+iYe7xDxhgUY9HJPr55YbxugPF9YNmV2jYs3YK8T8UNMR5fw+nbLTeMtx8R4OKEAaVJyu/Qt+rALcdbMscDSENIcYM7c2r0xSRABzBdVmy1mTzQdYILmy0xgeqjMhlYDBM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715815323; c=relaxed/simple;
	bh=qWLoxtH3cdj9qh6HEnoIJqLsbKnLxS909tC4XIJ8gL8=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HEQfw2GaStgOFkM4/+NRNUZSvq+LEc4V8LlXVAn/8rOjBesooAWNLYj6ZH06zk/kLEF06OpFnJAoXalEpIG8ogLdLHszaOf0Up2VNMTrIEfPgNmnpfB5ZPDVRqB1150/QLwBHcYhGs4pwBRcWwkzA4NYshXhaWGjFp6B6dOvIYs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=duQ++Wfi; arc=fail smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715815322; x=1747351322;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=qWLoxtH3cdj9qh6HEnoIJqLsbKnLxS909tC4XIJ8gL8=;
  b=duQ++WfilGYpq85BZ55Ee457AcIWL5SuaBvizXjvkZCdkcev9lWT4V8I
   t8QG9PpVAvwqPh9dFRrBbOkJdCaw6h4ZxrPtgAaqF0RAedT6AkMUYSQDO
   1u5VN1PcMhZ7ZagOVh0aItwCS+EvMVEJ5R1aXJNk+CCXZzPfIPI2MdUvL
   xMOCYcneMxCQxOkKKqNpZR7cUXfo9AiFcw6IabS2xM7SE1tbWAjmQIEhR
   wX2bz/GccGruXU1kLw7W/l2KEM+lqjLvtnxaIddVVB4GU3SlkQg+Pe0+I
   2HDUcl+linND1rHNSU+kiE9Ooqyv/w/+jKtn3bgAGuMtmqB9AMApy7wBI
   A==;
X-CSE-ConnectionGUID: V3+p1FWiToKxC4NWuChpkw==
X-CSE-MsgGUID: i5hRsLsbReis7xiLi25Bcg==
X-IronPort-AV: E=McAfee;i="6600,9927,11074"; a="34409437"
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="34409437"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2024 16:22:01 -0700
X-CSE-ConnectionGUID: 8TicXuqeRm2DI1JvhmFntw==
X-CSE-MsgGUID: w/hd7koBSyeQyONQSaDxgA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,162,1712646000"; 
   d="scan'208";a="31321656"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmviesa010.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 May 2024 16:22:00 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 15 May 2024 16:22:00 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 15 May 2024 16:22:00 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 15 May 2024 16:21:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lAQc06FlUDLvR54/99y5jV0UZyauDTap4EpgA7/1k/X1i/aMHWeyPjbsjg09+PjNJc3nEGjfcT48EPqb2eC7C+FmWt8Koqw1G5PvoAv812g80PJevzJw2VaI9oirYRbvUVmjJ60yCFq52Y/IzpLcH5Rzs2SlAGMR1MkmkLWI6rfWQx8Cadwp3emRib3EwvFZ/VdfSqUH+yw6opRBpdC/pUMyO97LZYp4hsrGCuU8bRCqY9T878XG2e5uxhlZdyl2fsheNHtChwQ/nm5g/PA9zDI71mJ/Ic1Qkg/juMEh9qrOnKszKebjXpObSEKx9wCbIcpq07lvIOpZPV+XMzlN1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWLoxtH3cdj9qh6HEnoIJqLsbKnLxS909tC4XIJ8gL8=;
 b=iDdr9kJ6LxQ746+GvZhSeFOrZhqA5mpXa94VqyTcZHjKNlL1A/ZMQouoNOLJrtk0eAGfHNlJ+7s8ivjSjA/ZwyhjlhjzLFSbdzjKf1A63b21Ekqsndyge+tjT5/7s2j8cmB59d8LegRWJ7nvnghNQDigkeNPdZXSjFVFdE7jVdaGTmaQ/pNa366IfUAnhGGdLQ9EgZlN1m32TUfq25aAGG1IEKfJu6D0yyjAL02pQ5LJgC7zSQ/UUxEFDawtG2AEZOsL5G97x4JjGfStIOT7JRsPtc6CX1L5lpngWDh5fccuXMsvRR1yCpQmwLeT566mu/4Qs9QuhxlEU7b93cf1bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH7PR11MB8124.namprd11.prod.outlook.com (2603:10b6:510:237::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Wed, 15 May
 2024 23:21:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7587.028; Wed, 15 May 2024
 23:21:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "sagis@google.com" <sagis@google.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>
Subject: Re: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Topic: [PATCH 04/16] KVM: x86/mmu: Add address conversion functions for
 TDX shared bit of GPA
Thread-Index: AQHapmNYuPeG3HmbBEy5jvfA/OKCRLGY42KAgAANMgA=
Date: Wed, 15 May 2024 23:21:57 +0000
Message-ID: <307f2360707e5c7377a898b544fabc7d72421572.camel@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
	 <20240515005952.3410568-5-rick.p.edgecombe@intel.com>
	 <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
In-Reply-To: <9f315b56-7da8-428d-bc19-224e19f557e0@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH7PR11MB8124:EE_
x-ms-office365-filtering-correlation-id: 97bdec58-a0e3-4d66-7749-08dc7535d0cd
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|366007|376005|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?QjN1TEFyeGpjZ2hEVlcwS1RmUzcreW1uY0hRWG03WFgrakE4V1BNZjBrRnNO?=
 =?utf-8?B?R3REbW5KeTZOK1k2UTg4cCtMRnNoUC9FRkc5SnloamtWdE9OVSs5T1k0WFQ3?=
 =?utf-8?B?c1VMTVZhY0svSHJWOGdqb1AwdzBjanl1OE5rdCtzUHB5ZW1sTXgwcUVNUmZW?=
 =?utf-8?B?NnZlYlpMYTRtcUtsWXY4OUdHMUIzYUlUMEFUTzJhR1NIbTN1cHNNL2VpUStQ?=
 =?utf-8?B?SmtLU3didUpCM1pZekd3M3VwUmp5V1c0dk80WlUyamt0VnBxbnpBUlNUMDI0?=
 =?utf-8?B?MjFFM3B4U0Q0aDZLS1M5bmxmZ0t2SXBvZWxNQVNENklCNHdoaTZiNGVIMG1Q?=
 =?utf-8?B?cXlqM2lVdkFMQ3YzWjBHa1R3RXVTT3FlMWJFdThlRmNLSWg4YTl1QjU4ZEx5?=
 =?utf-8?B?ZUtQNU50MkZhTlhzb0cxVHNxL1czQnJJcW5NV29NK3piMnl5KzhCbHBDOFpi?=
 =?utf-8?B?ajhhejZ1dDBFUE1MRGwwekxhWk94Y0RvSmtTUEVkZjk1VWMvMU1ZWmJzYzZj?=
 =?utf-8?B?ZHRHZnRsaEdRV0lhc1FEaDEyZVo1K2FCNG5Wd2gwRzlZcnVNdG8rZVV6MGo0?=
 =?utf-8?B?dDR2ZFRvb0t1REtDdDZnbmZ2RG9UOThZOTJZSFo0ZUk2WXhkb2w1Y044eGYx?=
 =?utf-8?B?UWxyUUV2MVZRaElGUmJZcGowMi9vb1R4VXFsNUxxMDZKRTViMjdSRWFrMVh4?=
 =?utf-8?B?SmR1Vm1JZTdxdEFqN3F2cUZHSDIxMDk3MFBvVHdXNUw2SWhXeWFiM1RlMkho?=
 =?utf-8?B?czJtTWlrR3ZzNnZFQzBFZGlFcHVmMXhjR24xY2swMHhYdVFOb3c5STF6OW9U?=
 =?utf-8?B?ZTk0bEV4Mml6TVFQVUxyY25kMm9aL1dBUXlFSXdpVG4xTXRSYjF4aHg0VlB6?=
 =?utf-8?B?R250dXJ6Yk9SUHhlNHJqQmY1L2RnUzJiMmE3Mzdldk9mV3hMWms2NGtEYXR1?=
 =?utf-8?B?Tm5OMzVTQXpVVDFtQzAwamxFN0FYclJHNU94clozT3NIZEZxMXZxbDQvSlVJ?=
 =?utf-8?B?K1BsTjV0ZnlsZlZTc2g2U2d1VURBallteHdtRUJMRTQ2N2JNc1lIM0hlYnJq?=
 =?utf-8?B?SnQwYkZQK1l0NjhuQWFNcS9WcVRsU3V3U0hrR09TaWNLU2MrZ3F6eUxUSnRD?=
 =?utf-8?B?d2xsSEg1TkhEck84ZmJrSWEvWEJJd1U4Y2xEWnoyOTROWTFGNm02aVU4RE1H?=
 =?utf-8?B?b0VZM1F1bWlmUVA3V1E4blJJRTNrRkR0cWhWS0RxYUhXMWxZWW4xVTRBdm5K?=
 =?utf-8?B?RDNWbmNIeXZLVGk4TVd6Z1gxSDlaQjZESmhiVDhwbmdIT1llWkM0cTdwUHVL?=
 =?utf-8?B?WkJDN29HSjRsOGliSlVEaSsxU2ZXaVJNc1dJL0NJa2YrQ0ZGRGZta2xMOFcy?=
 =?utf-8?B?a25rWnlqZUVHNE5jVHV0d0RscVlCZlB5c0pYbXI4SThqRWlaei93ZGdCMmh0?=
 =?utf-8?B?K2pWWHJLa0pwMjYzOTVaODROM24wa1UzanRaUWJLMUd3bzEzUWdUVEtLbHZ2?=
 =?utf-8?B?dUFrVnJFdkF4S2dQaW9pKzE4R1NYTTJTd3FaWDhTL1EvYWtZbHVBSkxvN2lt?=
 =?utf-8?B?Qjg1eU42Q0grbmpCS2cxSzJubnhQS01LRFhlY0swajU1K2lpNFkrOEFWcDQ4?=
 =?utf-8?B?enE2UksxQ2N1THJOVFdyOGNQeEFwZ01MV0x1T2RXZWcvRnlrOTNNcCtiMTBa?=
 =?utf-8?B?a2JmQ1h3ZlRpeUd4Z1p2bDdpWXFza1hPb2ZpVzFCMkhSYm9pRUszTzJvZlNU?=
 =?utf-8?B?OTZTMzF6VE04ZmxoOHhPVEtaeTlDb0I0MmFHSUlzREhLVEtJbytmcHE0Z0Vp?=
 =?utf-8?B?MFRQSXB4WVhoVlkxQmRldz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(366007)(376005)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ejE5K1RBUWNMZ3RsRUQ5Yk9KSE9sNW1JQS9jUjRac0RpUmtmWXFmSmNmNEZJ?=
 =?utf-8?B?L0wyZHVoMFpySzREa2pPZk1FZ1FWZnIybTdTOGV4dnpzdWRnZkthSWJTckxv?=
 =?utf-8?B?SlhLV1pDZzdyRGpodXZXaENBajhiUHIvWTJqZGxqQ090SG9EMDZ6N2dIZ0Fq?=
 =?utf-8?B?dU1Pb3hxRDE0dnhLMm1tcXJwaTRJRktQRlFlbWliajB5RVVqWWdyNXl3TFVs?=
 =?utf-8?B?V1VwVUlkYWVYM2FDWjhyOFAyMVJXbnZqVnJtWnZTUzJkT0x5WSswQWVBM25t?=
 =?utf-8?B?dG1QNUpPUVZJS2g0ZlZkUEgzcU0xMDdDbituQWw1QTJMYnJZVUY3WkpRMlIx?=
 =?utf-8?B?Y1JrRklmeENTTlBBdDZFc0VjUUJEaVJPNVFVNnhUaXNhRkwxNUtUNmN4bmQz?=
 =?utf-8?B?TUtrVUo3cDFnOHhYR3Y5MVplSno3cFhVMVViRjMvNVI0QW51a0hqN3F1Ylpk?=
 =?utf-8?B?dTFvMWFMNWhSblc1MkVDODNzbDkxTUNLdkh0azNVbG1hVERKeVd5TGJ2UmFY?=
 =?utf-8?B?L2d5ZnUzM3V6aTBRMnpobjdsTko1TUdxVS9ZRmpoMjNSR1RGN3BYMlhWM2h2?=
 =?utf-8?B?NzBVWkN4aUZXa2RVbGRDYUZHSnhRMTVBUUg2OVZPREtORjBkTm5icUlSNWVt?=
 =?utf-8?B?QWgybGtlSGpmZHhSRHdCVDhTN3M3SXc2UzlsL3paVjdJa1k1aHlzTkFIcU04?=
 =?utf-8?B?UEVIME9pUFVONkdHUzZvYThoakg4Z2ozQTYxTkc0YjZOdEd4T2lnOGFUNDFq?=
 =?utf-8?B?UmRzY0pqN2JXeWhhaHZSSXNIRy80Q0V1REdYbGVwd2lzK3pBMytyUHprMnNk?=
 =?utf-8?B?bTBxWXFrV3VsZlRuSllRL093WDEzcHMxbU04Zm5lVFRkVmNwWnBZaU5LcWtW?=
 =?utf-8?B?TmhldWFOdmRUNTNGUlVLQXRvdVJWb0pFOUM3V1kxUHpmZjdLQjY5QTRQRUN4?=
 =?utf-8?B?ZktxTU4xcXJValZadmlsM3JmU1Ftb1BtVm9BRU1ud1ZIRkdqRVNtSmVFTU5z?=
 =?utf-8?B?MVg3K2FPZUFoSmZSWDdDL2R0SFI0dXVSV1dTaWpSNTlUenMvVlplM0hKRmcx?=
 =?utf-8?B?a1dQc2ZuRC9iQjNSanlaSGZWd1pEcTZyN3pLeTFZWnhNdm52N3hKVnE5TElO?=
 =?utf-8?B?dTlGNVREVnFOcXFZWkRPWlQ5MjJ6MmpPcC9aUHM1YWx3aWJxOUZXdjlqOWJy?=
 =?utf-8?B?WWw5Z1lrUnNuMk5uNWdFQVhiRU9hczNKak55WTRqQ0Nzdk9jSlRkUTJXTnJL?=
 =?utf-8?B?dnMrVjRwRmxCZGxhMGx2L1hBUjRwNk9OY1VNSTdxcEFIWkUvcnFJK2ZJL1JF?=
 =?utf-8?B?MkdqOExVUHdUWFFSMElnYmJ1WmZQbm51YWx0eUF5WnExOTk1eXJXODMxVitk?=
 =?utf-8?B?RnRTZnh6cHFWNGY0MWg5NzdyZVp1RDYrelNxMi9NMjAwM01sdG9YUTVzUEVF?=
 =?utf-8?B?cmptY2ZMVFliUExQbEpsNGl6OGF0b0lNOWRuc2RqMjVMZG9qRWl1QUFva3Yz?=
 =?utf-8?B?QStCMk5qVVc2N0pMc0YzQWhreHc5WUZGNjNOTXZkelBzQzFJUG1LTVY5cExN?=
 =?utf-8?B?Z2VuNnEvcXQyQkVZdEJEbDZXbVhJa0RPaERSRWFEOHU4Z3p3TFFXRDVnTk5q?=
 =?utf-8?B?RlBocmxZbGJPekE5U3hYdmdnNnMyRk1wa1VFT0tXUEN0QzJ6alJWUm16Q0d2?=
 =?utf-8?B?MGltUE4xQ0FKSEJSRk1oSHlCdlo3TnY5VnBUdE5OdnFmQnh3ZmlzeUNiOTZw?=
 =?utf-8?B?WWlta2dqWnlEVk1tMnpGSlBRQjFmT3JFcGNhcFphcGQreDRSbWVMWEttQ2wy?=
 =?utf-8?B?ejI5NlE3NHpjcmhwWDJWVWp2ZVFpdFJablJZT0NWRmhxUUNVR0pUNm5hcW1u?=
 =?utf-8?B?eHVxclZnQWIzd0NEN2RzejVuWUJ5ckN2RjkyMnV2MWVNUFFZbDk2c1EzZ1Ex?=
 =?utf-8?B?YTBLRnprSlpXRTgveVJuQ29UREVLUkEyTkVmYmV5aGpuZG5DRk9wSU8rMFhU?=
 =?utf-8?B?NUdVS3dacXFTMGtrT0twYy9ta0RQbldhUzE2dnZ4L0tGWEx6bnFtOUtjVitN?=
 =?utf-8?B?aVZXQ09Gb2lUTkJETjErcGMyWWVJbllqTmlxd2czcytvUi9IMFNFRzNSbGFT?=
 =?utf-8?B?aDBLYlpuVGZXdzN2bW9qTUE3b083VHBKSmhNYUkvdUJ4cVV5NGQ1L1hBUTdZ?=
 =?utf-8?Q?blxxSn7JNUyKEPVwgXOfP7Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C55F2BE06C51184D9D5543990CD7F66C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97bdec58-a0e3-4d66-7749-08dc7535d0cd
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2024 23:21:57.6417
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WlAYWGBig2czj3uLhM4ALeJ8uCUnAs6HHyI6uMPqqnoxQVWHcwzx0hJXqLFHPSFzgc82U1O0qyD9K+1RQ2oHy3bxF8ZavBc3oxxdVMyfaYQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8124
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA1LTE2IGF0IDEwOjM0ICsxMjAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiAN
Cj4gDQo+IE9uIDE1LzA1LzIwMjQgMTI6NTkgcG0sIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+
IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+ID4gDQo+
ID4gSW50cm9kdWNlIGEgImdmbl9zaGFyZWRfbWFzayIgZmllbGQgaW4gdGhlIGt2bV9hcmNoIHN0
cnVjdHVyZSB0byByZWNvcmQgR1BBDQo+ID4gc2hhcmVkIGJpdCBhbmQgcHJvdmlkZSBhZGRyZXNz
IGNvbnZlcnNpb24gaGVscGVycyBmb3IgVERYIHNoYXJlZCBiaXQgb2YNCj4gPiBHUEEuDQo+ID4g
DQo+ID4gVERYIGRlc2lnbmF0ZXMgYSBzcGVjaWZpYyBHUEEgYml0IGFzIHRoZSBzaGFyZWQgYml0
LCB3aGljaCBjYW4gYmUgZWl0aGVyDQo+ID4gYml0IDUxIG9yIGJpdCA0NyBiYXNlZCBvbiBjb25m
aWd1cmF0aW9uLg0KPiA+IA0KPiA+IFRoaXMgR1BBIHNoYXJlZCBiaXQgaW5kaWNhdGVzIHdoZXRo
ZXIgdGhlIGNvcnJlc3BvbmRpbmcgcGh5c2ljYWwgcGFnZSBpcw0KPiA+IHNoYXJlZCAoaWYgc2hh
cmVkIGJpdCBzZXQpIG9yIHByaXZhdGUgKGlmIHNoYXJlZCBiaXQgY2xlYXJlZCkuDQo+ID4gDQo+
ID4gLSBHUEFzIHdpdGggc2hhcmVkIGJpdCBzZXQgd2lsbCBiZSBtYXBwZWQgYnkgVk1NIGludG8g
Y29udmVudGlvbmFsIEVQVCwNCj4gPiDCoMKgwqAgd2hpY2ggaXMgcG9pbnRlZCBieSBzaGFyZWQg
RVBUUCBpbiBURFZNQ1MsIHJlc2lkZXMgaW4gaG9zdCBWTU0gbWVtb3J5DQo+ID4gwqDCoMKgIGFu
ZCBpcyBtYW5hZ2VkIGJ5IFZNTS4NCj4gPiAtIEdQQXMgd2l0aCBzaGFyZWQgYml0IGNsZWFyZWQg
d2lsbCBiZSBtYXBwZWQgYnkgVk1NIGZpcnN0bHkgaW50byBhDQo+ID4gwqDCoMKgIG1pcnJvcmVk
IEVQVCwgd2hpY2ggcmVzaWRlcyBpbiBob3N0IFZNTSBtZW1vcnkuIENoYW5nZXMgb2YgdGhlIG1p
cnJvcmVkDQo+ID4gwqDCoMKgIEVQVCBhcmUgdGhlbiBwcm9wYWdhdGVkIGludG8gYSBwcml2YXRl
IEVQVCwgd2hpY2ggcmVzaWRlcyBvdXRzaWRlIG9mDQo+ID4gaG9zdA0KPiA+IMKgwqDCoCBWTU0g
bWVtb3J5IGFuZCBpcyBtYW5hZ2VkIGJ5IFREWCBtb2R1bGUuDQo+ID4gDQo+ID4gQWRkIHRoZSAi
Z2ZuX3NoYXJlZF9tYXNrIiBmaWVsZCB0byB0aGUga3ZtX2FyY2ggc3RydWN0dXJlIGZvciBlYWNo
IFZNIHdpdGgNCj4gPiBhIGRlZmF1bHQgdmFsdWUgb2YgMC4gSXQgd2lsbCBiZSBzZXQgdG8gdGhl
IHBvc2l0aW9uIG9mIHRoZSBHUEEgc2hhcmVkIGJpdA0KPiA+IGluIEdGTiB0aHJvdWdoIFREIHNw
ZWNpZmljIGluaXRpYWxpemF0aW9uIGNvZGUuDQo+ID4gDQo+ID4gUHJvdmlkZSBoZWxwZXJzIHRv
IHV0aWxpemUgdGhlIGdmbl9zaGFyZWRfbWFzayB0byBkZXRlcm1pbmUgd2hldGhlciBhIEdQQQ0K
PiA+IGlzIHNoYXJlZCBvciBwcml2YXRlLCByZXRyaWV2ZSB0aGUgR1BBIHNoYXJlZCBiaXQgdmFs
dWUsIGFuZCBpbnNlcnQvc3RyaXANCj4gPiBzaGFyZWQgYml0IHRvL2Zyb20gYSBHUEEuDQo+IA0K
PiBJIGFtIHNlcmlvdXNseSB0aGlua2luZyB3aGV0aGVyIHdlIHNob3VsZCBqdXN0IGFiYW5kb24g
dGhpcyB3aG9sZSANCj4ga3ZtX2dmbl9zaGFyZWRfbWFzaygpIHRoaW5nLg0KPiANCj4gV2UgYWxy
ZWFkeSBoYXZlIGVub3VnaCBtZWNoYW5pc21zIGFyb3VuZCBwcml2YXRlIG1lbW9yeSBhbmQgdGhl
IG1hcHBpbmcgDQo+IG9mIGl0Og0KPiANCj4gMSkgWGFycmF5IHRvIHF1ZXJ5IHdoZXRoZXIgYSBn
aXZlbiBHRk4gaXMgcHJpdmF0ZSBvciBzaGFyZWQ7DQo+IDIpIGZhdWx0LT5pc19wcml2YXRlIHRv
IGluZGljYXRlIHdoZXRoZXIgYSBmYXVsdGluZyBhZGRyZXNzIGlzIHByaXZhdGUgDQo+IG9yIHNo
YXJlZDsNCj4gMykgc3AtPmlzX3ByaXZhdGUgdG8gaW5kaWNhdGUgd2hldGhlciBhICJwYWdlIHRh
YmxlIiBpcyBvbmx5IGZvciBwcml2YXRlIA0KPiBtYXBwaW5nOw0KDQpZb3UgbWVhbiBkcm9wIHRo
ZSBoZWxwZXJzLCBvciB0aGUgc3RydWN0IGt2bSBtZW1iZXI/IEkgdGhpbmsgd2Ugc3RpbGwgbmVl
ZCB0aGUNCnNoYXJlZCBiaXQgcG9zaXRpb24gc3RvcmVkIHNvbWV3aGVyZS4gbWVtc2xvdHMsIFhh
cnJheSwgZXRjIG5lZWQgdG8gb3BlcmF0ZSBvbg0KdGhlIEdGTiB3aXRob3V0IHRoZSBzaGFyZWQg
aXQuDQo=

