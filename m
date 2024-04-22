Return-Path: <kvm+bounces-15531-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FA7C8AD157
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 17:56:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B04B0285283
	for <lists+kvm@lfdr.de>; Mon, 22 Apr 2024 15:56:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87388153578;
	Mon, 22 Apr 2024 15:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SHUMmVXc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217FC15350A;
	Mon, 22 Apr 2024 15:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713801383; cv=fail; b=FR/1AkTTu6ms+h7VDAe1JuGSggCe4dP2lLl7d25dFUXvxiNjEMREL89sBvBXsDS+bawb0iUdWhCwpb3Xzpd829SmABGwBr9iBZFQutnepmcUzK4OYtG2WEaCl2Mined5d1ggTkHI8fdFRYRxcQN9jgBjZT6a66eDBHPIfr6G9MI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713801383; c=relaxed/simple;
	bh=fFzT2/PxUciLylzczcAHqYeadnbprwmnT4iAKqKhwYg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=MqE3YwVKe4mRBnfRqv7C5pPxTf/fU1NcwgmpBF5W1E8IKae6am0FZ5BgxIL8XXClX3O/UEqb56Ekp5T+e32cLpQ/LAhfr1Rco9slg5UT9NWYx4esz4GUri2bXnAfkuPK9cNyXsU9uVlkMpMQloHo5n/sMrRiVFSc/UwQ4ThsMms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SHUMmVXc; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713801382; x=1745337382;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fFzT2/PxUciLylzczcAHqYeadnbprwmnT4iAKqKhwYg=;
  b=SHUMmVXcV7IyDT8wvF4qIx0RnWMNAYhIeSZTSDKFHaiDMkwOyEDt7FR3
   utLr2CYXs/iMiH4Zb7cAboM0xRWbeZOqbnYq+/xikMB37OZkHwLdOQJm2
   qGwofKM0uyl0mPNWF22ebGqncd747vdzyzwR2w5IzS9lQY0rMKWWICk3n
   UmRlJ3Y7F2uOji2DaheuBCuspEfgn+kIP+ikxZXm/Zi04qoCuih2cj+Lx
   Nf0sk/cY5h7g56Fopvc0F+1uFa+ry7vkDHr12AD/8VIxGThTWChGnd1KA
   XcmRujZYzj/whm/qvyBnv05FhSs+s2MK6Mu2MRJX0mhhPJs0WA52k/2pU
   Q==;
X-CSE-ConnectionGUID: V+La/TOsRJqZgcsjLOU2Uw==
X-CSE-MsgGUID: ZQbcSJwSQSulHCVQo0pwzQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11052"; a="13132619"
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="13132619"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2024 08:56:20 -0700
X-CSE-ConnectionGUID: EHTzdDc0SeysPYnLmrSkzA==
X-CSE-MsgGUID: Q8MjDHydTPaQ8etLOh333w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,220,1708416000"; 
   d="scan'208";a="23935360"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 22 Apr 2024 08:56:20 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 22 Apr 2024 08:56:19 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 22 Apr 2024 08:56:19 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 22 Apr 2024 08:56:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fgMKm/3HaEzgNAGOdDWnPFmuHucocTL5DrHjuSiN6Os34pHk/CJCEkcgLRL/pTPToz6+LjKBEWlBB8+JxY8ztzJuyqLqgrkrfkw/2+/uUZrjDf4VCvgYlV8Fv4wvN/L4fqUPyPGCBz4bIrJL4uYfaADAOoO1UE21bj2tKhgdBPRKDsgCHPC/rUC1QaS4jAVnlcN6tXAKeCtOilcvc2suwx1DC+57ZsvCe1uf5wDxPOWwXzZv8fms+og8NiJcA7zOGNnKFXegSEG2PIpa/ef2VhAAxHDS31IFXyj18WcihKYENaaZlsIQU+kbwt5139sHitn/Q+lkgKbbrnspV71T0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fFzT2/PxUciLylzczcAHqYeadnbprwmnT4iAKqKhwYg=;
 b=VdacTaCZUMgWAw2KI8NAYKOFKUc4ViXIquwrTa+LISoGBXkppgRlX6xW8ECbatFigXozfAA9JyObcFwQnxzGFEGTNMBqzfeY70Tz11Ed78kAQNQMBSAcOO7r3fviRKY9SFeLKUrGlbhsM22x5W8RZyAXaj2Pvuf0ixwyHrCXSxZLZ7fCLZfoZIdLxEts1/a7VcHGWphVJR/AHQXn7AEW4IatqvPzNlDd/oUZcDldupWQxcEn1p7LHwVH0l7kIiNLUh8jAWnevczLBT1UumZe8Askwokft1FWbmZYM++1u9FSm0dDAOXkqFPbgoy9aGNgOG3Se1LPsbe7vSn4B0qoxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SJ2PR11MB8472.namprd11.prod.outlook.com (2603:10b6:a03:574::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.20; Mon, 22 Apr
 2024 15:56:14 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.020; Mon, 22 Apr 2024
 15:56:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "x86@kernel.org" <x86@kernel.org>, "Chen, Bo2"
	<chen.bo@intel.com>, "sagis@google.com" <sagis@google.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "Aktas, Erdem"
	<erdemaktas@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Topic: [PATCH v19 007/130] x86/virt/tdx: Export SEAMCALL functions
Thread-Index: AQHadnZ/Qf0yAsUauU2/h9YYap6ribE4BK4AgAD7XwCAKJ4bAIAJ4iGAgALItgCAAEXagIABVNMAgABY9QCABCvfgIAARcaA
Date: Mon, 22 Apr 2024 15:56:13 +0000
Message-ID: <ea77e297510c8f578005ad29c14246951cba8222.camel@intel.com>
References: <e6e8f585-b718-4f53-88f6-89832a1e4b9f@intel.com>
	 <bd21a37560d4d0695425245658a68fcc2a43f0c0.camel@intel.com>
	 <54ae3bbb-34dc-4b10-a14e-2af9e9240ef1@intel.com>
	 <ZfR4UHsW_Y1xWFF-@google.com>
	 <ay724yrnkvsuqjffsedi663iharreuu574nzc4v7fc5mqbwdyx@6ffxkqo3x5rv>
	 <39e9c5606b525f1b2e915be08cc95ac3aecc658b.camel@intel.com>
	 <m536wofeimei4wdronpl3xlr3ljcap3zazi3ffknpxzdfbrzsr@plk4veaz5d22>
	 <ZiFlw_lInUZgv3J_@google.com>
	 <7otbchwoxaaqxoxjfqmifma27dmxxo4wlczyee5pv2ussguwyw@uqr2jbmawg6b>
	 <3290ad9f91cf94c269752ccfd8fe2f2bfe6313d1.camel@intel.com>
	 <no7n57wmkm3pdkannl2m3u622icfdnof27ayukgkb7q4prnx6k@lfm5cnbie2r5>
In-Reply-To: <no7n57wmkm3pdkannl2m3u622icfdnof27ayukgkb7q4prnx6k@lfm5cnbie2r5>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SJ2PR11MB8472:EE_
x-ms-office365-filtering-correlation-id: fad84745-8369-4edb-f1f1-08dc62e4bcbc
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VDRhek9Cc0xhVFA2UEpvN1lxUVFzZFVpenJ5dW8xRlZEN2ZuQ2Z4Ky9Za1VM?=
 =?utf-8?B?aFNoeVJhRExYejRMT0s4ZmljcHVLWEdST012b0J4TVZhWXJiS3B1dFVuS29y?=
 =?utf-8?B?WGlaWDNPNDhLUE5oY2c0VGw0MzJsbVpCcVhNREM5WHA3MHNGS09UNXVoWHpp?=
 =?utf-8?B?Q1o2MUNhTHBMZnFvNHJsNTRSazBMdmI5SFBMQ0lrY0JQdlQ0Mkd0YzhQbm43?=
 =?utf-8?B?NlhPY3J5TGZrck9iYi82WHFqUElvWjZnUUVTWXd1RXBabFJueC9XWmQ4OXM1?=
 =?utf-8?B?YTl1VUNiWVdFTU5wcVVRVVRQWjlSeWlPT3FJMU92eWxRRm4za3AxV1pJdHRj?=
 =?utf-8?B?UW50R05xOGZKSTEvY2N1Z2M2a0UrQU5nbG1MNGJhenI2dFRzbjdjNm5xTE85?=
 =?utf-8?B?WmVkRHc3YmF3cHdXMUhuUnVKeFRkTDQ5YTZWKzVMQUY2dzRLOThJZEJsTjUw?=
 =?utf-8?B?NFQzMG9Ra1VOVXE3K1duaDdSQ0ZreUkwOUxDODJVYm5vc0dEV2pWUkhKTWo5?=
 =?utf-8?B?RUtXMDJYK0xlQ3c5ZE9WaU45bjcxUTcwZWhoM3F4cEViRjhtaStIQkg3WXIz?=
 =?utf-8?B?QUQ0ejdLdDYwMktLUFJPZ0hiWHNIWFBpYWxUbEtqQjI0Q0N0MytNZWxHY1VV?=
 =?utf-8?B?em9WeHMvY1BCQzF0VHI5aUdkQ2FxOUxXS2JYSC9vNXZVUEVoWU45TlFDOTN1?=
 =?utf-8?B?Y1hzeXhXclpiUTBjTlZXeGs5blBaZ1dhNERjcTVNSUZNK052b05ONnRRVmx3?=
 =?utf-8?B?S2lhLzVOZVBnUEpYcGpZeFZ6VjQ4S3FlZ0s1dlNoWGIwYzdmZHd6cStqVTNU?=
 =?utf-8?B?R0JCZXJqUStVeW5KdTN0TjdKY3ZFV3EwbURIUGZ2NXVUWFZaUUtERVVmTUs0?=
 =?utf-8?B?K1c5emk1ckUxdE9ST08vdnJSVGxiQVQ1NXBRQnRraXNlS2tITmx0NlhpUFo3?=
 =?utf-8?B?WGdIRHpPSzRWZnNlUkhseGVrOTJBdGJUa2M2MDhndHg4UHdGNEMxeEc3NGNp?=
 =?utf-8?B?bzdvcFpQR09acHd1aG1aaUFKdEczYldETWV2RzVTSmdOd2Z5SjBKSU1LaWxH?=
 =?utf-8?B?MTZWd3hTbHFxODk4ZWI3cGRzWjQyc3dYYWVwbUFtRmhZYWNhTUlmSnA4REJj?=
 =?utf-8?B?RnIvZnpvOW02YnBSNzRXL3BxbFJKamY2ZjZrTFFiRnU2Q2FkczAvK0dYREts?=
 =?utf-8?B?VnVVd1FWQnV5N1RCeFRIOHA3UHNKN0wxZmpMOGo3UURnclJUNkw4N2hRUW9l?=
 =?utf-8?B?NEViVXlqc1lqSE1Ha29tb25nQjJFem8xUUpzd3RDdmlOMWE5TFJOcHlzQVFo?=
 =?utf-8?B?THlOVGFObHEyTDA0YzJXemxPUGtiMm5LZ204eXFweEpEN25LS21ySzN5eTFu?=
 =?utf-8?B?RG5YRjNTNzVqWU55YzQrODlRNk00YTE2Ull1aGRwN2lIMDVjcUI3NmFWdkw5?=
 =?utf-8?B?NlMvVTNnYWFQSWR4TjBnaEdmYUd1UlpjM1R5TWc1R1R2MEJIaCtjcFltTndx?=
 =?utf-8?B?WSt5dEs2M1l4RmJBcFM4NjA2c3prZVpPZFh2T2RtYVlOMnpyNHBOc1lJUG9h?=
 =?utf-8?B?RzJ4V2UvbGloenNUOFM1bEkyZDM5cXNteDl4d2w5ZVhNTEN6QlkrUmZOMi9y?=
 =?utf-8?B?LzVJM0VzNUhpVjltUnhtRjYzRDh2OUVZWmhKYWIrM0ZkQys0VDZNdW9PVlZ1?=
 =?utf-8?B?WTNPYndkNDFESGFhZzRvZnFwK0JhanRsRk5sV2hxVmtHdFlCbDdLeWhhRWlt?=
 =?utf-8?B?N1o1bTEzRWJXZXVIUjJZd0hUWldqQmphTHIzLyttV3UrR3B5ZURkWWgvZngz?=
 =?utf-8?B?Vjd2S2xNKytjNVVVK0pVZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWM3cGhvem40UXJWdlo4RjJhOFFpaEJRUUExNVc4MlFqTnpnT0FGUFg5SEdH?=
 =?utf-8?B?WWtZcTRONmtxL1pqaWpvc0l2NGp2NVlKc1QrcVNHczlJRGh3ZVNTeGpmc3lF?=
 =?utf-8?B?ejI4SEdLeldRSzRxR2dDVHh1eDZzR3RLQ00vMVN4UjA4V3d1dlBhUHFudkxs?=
 =?utf-8?B?NkVtTnpHelFFQ1NES0RXUFBxTTBma1U2T3hXTWJDNnBiLzJ0WWhKM2JCNVFl?=
 =?utf-8?B?emEyN01DeDJFYTg5Vlp1OUhHVjJSUXNwRXR5bFFkSVFPNnFza1ZSWXhZTFU5?=
 =?utf-8?B?NXEvWUYxRGNXbFYwMEgyN3FHWHIxNlJjc21LOFk2bFlwejJBUUpMQndYUnRJ?=
 =?utf-8?B?VVlPMk9aWTlnSFNlVnFLSG5lcXIvaEhNZFVOak5aNDBKSlRjcFBGUGNCRk5B?=
 =?utf-8?B?STJramhaWkFYUnhWSk0zWUNadVcwWnlhNEFQbDNralBjWGhic1lDN0pmNGNB?=
 =?utf-8?B?TEpRQ0JHci9UMmVSbXQweVUzTXpDNFoydlJtcDJMTlBhTjRLYlhDcU0wd08w?=
 =?utf-8?B?a0hWYUU0eHlGNUlkNFBRRUVwa1BxdW44Q2VNTnBGdEFrQ1p0QUZzRXBzdWkv?=
 =?utf-8?B?VnNnWFo5UWlXZXNLMU5nQzF1T1JUeitiR3NkVFhFS3VydWQzQUR2aHI0akdP?=
 =?utf-8?B?ZlZDVlBBanJLam5zQmFZY2tnL0lOWm5CZW13cnRCRVRTMHFoOWIzalZqVVIy?=
 =?utf-8?B?TDhUdHFhMktqb0RmSU5QelQ0WGt5L1VBUFl5b1R6Z0htMHNQcFBrSWZrVWdr?=
 =?utf-8?B?K3lQekM0dFZONXcyeXlFVjVQTVFKUUt3MGhYMEl5dXRaNVpqVmJNNWVqMUpz?=
 =?utf-8?B?Z0tXdTMrUDllWEFiQTJOS2p5TC84WFM1QVhwNjdWZGt0Mk9FSGFjSzlYY2ZV?=
 =?utf-8?B?dVBqVmdLZVZUQ3lvZWY3SFBMbGxiN0hhK0hTZ0x1YzBWMG1JVzVOZzFxMXgv?=
 =?utf-8?B?YWNSaGZwOTY4dG5SRzlHNE5jQWdmQkJPK0JSdDhNK1M1ZWxUcXdGTTQ2Mkxz?=
 =?utf-8?B?TE1XYTJPRVQyYW50ZG80M3FuUTdIVW9pQkdSdXNRckw0T1VSRDNsbUxHVUdT?=
 =?utf-8?B?b0Z2MHVpSCtEVE51QWdMU0xtNnhSWTE4a2xiaWZuTEk1bUxHR3FUdE90VjRn?=
 =?utf-8?B?amRwVkRXY1hlTldGbnVOOHFRZm96b2k2ZGF1TVFqaTNobW0vUm1McnIrYko5?=
 =?utf-8?B?amF0VlE1S1BNV3U0YmwxRTFXaytSZ29MOURSb21VaE9QODZaMDE5NGNoMmFj?=
 =?utf-8?B?TFpJZVI0U05nMnExcEhjNWZWbyt4a3owU1pid25yOURuRG94RTNPQVNuSlh4?=
 =?utf-8?B?ODNEQXo0YzFpblh5SXRIVnFqMjhXaENjRm5VNGtlUEtNOXp0Qjl3N1RSNnA2?=
 =?utf-8?B?YWpjVUdoaFNTTzZ0RWFVOTNVaFFkSFJqM0NJU1NvR0RWRlAxK2FqRitlRUV4?=
 =?utf-8?B?UC9qemJwNnY2UVJoeXRnVGk5b2p4NDFVc041Q3h1OFNjUnNHOS9idG82bUJk?=
 =?utf-8?B?OGlLTGxBL1FmamppQWhoWWtNTjBZR1BDUkc2WEtueVo0eDNDdEkxV3doYzJT?=
 =?utf-8?B?SGZTdXZzcW1CRGthMEFrTUVxTFp6YWRheVBxODJCcGExeGFLYjV5WTJJMWYy?=
 =?utf-8?B?ODByb2RqUWp5c2NCYnBUT25ZVHZONEpTcjAwWEFRSUd0LyswR083NTJtZVdq?=
 =?utf-8?B?MzV2Wmt4TDR0NVQrT29uZHNRaGcrZEtnVnptQ3Y2NDI5U1VGTFhWM1FkVE9S?=
 =?utf-8?B?OUowbGovcUh2cW5GNW1zbXdXYjhLWnhlMFd6Z3V2WGw3WFVYRDhlWHIrR05B?=
 =?utf-8?B?c2dyck9MVm9jNzNhejNoQ1lTYU11VDlBeFNyL2JJS3IvK1hqbVB3NjNMcE1Z?=
 =?utf-8?B?QVlJbkp4b3dDQnJUbzNDUjcxejlVRDJPT0x6M0N1L3JZS2VubG1xMmliQjl1?=
 =?utf-8?B?emxycWYyQ01nVnBYRnN5NjZ3NHhnQ3ZnOFVtZ0JTZSsvOVVGaVJsc0dZaHRI?=
 =?utf-8?B?R0tkVFhTN09OT1VYdUtRNU9zQjV2S1B1bFU4bHc4ZlZmWG5wUFJ6WDhEUnVM?=
 =?utf-8?B?NG9Hai8yaTZua1psbE1zWmtNWWtIRTcvRm1ad3VENlNxeG5Vck40d3FpMDZO?=
 =?utf-8?B?VHRQb3VuaEk0Z3pDWmdJbERabGR0bDVzL1EwTUUxeXVEdjFST3FTaTFLUHhK?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66B87465D1FB834F93DB5F4995EDC12B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fad84745-8369-4edb-f1f1-08dc62e4bcbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2024 15:56:13.8073
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cllftE1m241tDXhCKnFMMyYQuly8/sc3QkJjT1WTFZEYQMeRQejrpf61Xj8gcOiYcQ1D06yJXSLEjbpqPcWNUztkJEC2PWAIzGIlL/p3XVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8472
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA0LTIyIGF0IDE0OjQ2ICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBGcmksIEFwciAxOSwgMjAyNCBhdCAwODowNDoyNlBNICsw
MDAwLCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiBPbiBGcmksIDIwMjQtMDQtMTkgYXQg
MTc6NDYgKzAzMDAsIGtpcmlsbC5zaHV0ZW1vdkBsaW51eC5pbnRlbC5jb23CoHdyb3RlOg0KPiA+
ID4gDQo+ID4gPiA+IFNpZGUgdG9waWMgIzMsIHRoZSB1ZDIgdG8gaW5kdWNlIHBhbmljIHNob3Vs
ZCBiZSBvdXQtb2YtbGluZS4NCj4gPiA+IA0KPiA+ID4gWWVhaC4gSSBzd2l0Y2hlZCB0byB0aGUg
aW5saW5lIG9uZSB3aGlsZSBkZWJ1Z2dpbmcgb25lIHNlY3Rpb24gbWlzbWF0Y2gNCj4gPiA+IGlz
c3VlIGFuZCBmb3Jnb3QgdG8gc3dpdGNoIGJhY2suDQo+ID4gDQo+ID4gU29ycnksIHdoeSBkbyB3
ZSBuZWVkIHRvIHBhbmljPw0KPiANCj4gSXQgcGFuaWNzIGluIGNhc2VzIHRoYXQgc2hvdWxkIG5l
dmVyIG9jY3VyIGlmIHRoZSBURFggbW9kdWxlIGlzDQo+IGZ1bmN0aW9uaW5nIHByb3Blcmx5LiBG
b3IgZXhhbXBsZSwgVERWTUNBTEwgaXRzZWxmIHNob3VsZCBuZXZlciBmYWlsLA0KPiBhbHRob3Vn
aCB0aGUgbGVhZiBmdW5jdGlvbiBjb3VsZC4NCg0KUGFuaWMgc2hvdWxkIG5vcm1hbGx5IGJlIGZv
ciBkZXNwZXJhdGUgc2l0dWF0aW9ucyB3aGVuIGhvcnJpYmxlIHRoaW5ncyB3aWxsDQpsaWtlbHkg
aGFwcGVuIGlmIHdlIGNvbnRpbnVlLCByaWdodD8gV2h5IGFyZSB3ZSBhZGRpbmcgYSBwYW5pYyB3
aGVuIHdlIGRpZG4ndA0KaGF2ZSBvbmUgYmVmb3JlPyBJcyBpdCBhIHNlY29uZCBjaGFuZ2UsIG9y
IGEgc2lkZSBhZmZlY3Qgb2YgdGhlIHJlZmFjdG9yPw0K

