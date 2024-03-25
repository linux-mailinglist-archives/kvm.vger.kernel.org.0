Return-Path: <kvm+bounces-12633-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E518688B52D
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 00:21:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 140E01C39315
	for <lists+kvm@lfdr.de>; Mon, 25 Mar 2024 23:21:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88A56839F1;
	Mon, 25 Mar 2024 23:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TV6GbFp3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38A7382D74;
	Mon, 25 Mar 2024 23:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711408883; cv=fail; b=gYewfMiSyAcnBpsTMhxFkST2hhxh9n9wMpXlF+/HyzJuSngNkjrDTeB1RUTee28YY9spZe7G1t2Wv4w5VBzLM6JL3+ZVpjL9sfslXoveK3ojK2DZGnShgmmLzJDUiaqGyK0JQloiD/RrQmd30mkT3KoIU+B1JPMrZtWXBfCvouM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711408883; c=relaxed/simple;
	bh=g2O4z4AIg81Z43r2phqjIqXZIlAXvAT15J2yVHUb5GA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ByfYR1CeCuLfa6KrUM4KxDT6FnoLtRA1REssR7DvVEa9n3j8diF98zQe9+YFXhPVcnBWzgDgAw8D8k6BoxYPtppv42c/pZqos7x6q8LvMkYQezuan6NGqIv5dmQxOtfTRiddp7sumyUdu6q8WDNHhrIKSCrbg+pka7ov+Sr+4A4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TV6GbFp3; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711408882; x=1742944882;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g2O4z4AIg81Z43r2phqjIqXZIlAXvAT15J2yVHUb5GA=;
  b=TV6GbFp3B72uEkSWp6RewhQr1KkwpBUMujqttAimrPAXNeNacveF4smd
   xnWnnkkEW6qx9+JqyTJMiWmOEkCynK4/qYxetnjmneeoBfTwpkj28qCHU
   IKDA9J20Gk0WQdNqB9olNuClC/iCFFZj0sZcdUPs8TviZ44jvL43R3gTT
   +Pp/H6XPlsZH4U92cI11YJkrJjuvPcfQcSzFjrqCyY8JnpFarcWbJ3ik3
   HpssuUG53M2OXaIeOWvt5D7AG2pIyQHlOWdJRfN6asLDrFC7YScknyi0D
   Cq+0UPU2ZKrqw8LJRJNVzFdEYEpAKC1yVecu83a6JyWFDOHmlwD7R/C+Q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6650278"
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="6650278"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 16:21:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,154,1708416000"; 
   d="scan'208";a="16439909"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 16:21:21 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 16:21:21 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 16:21:21 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 16:21:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nzzcH/+AOxeCdYF86vPfWZTmW4twRR1o/9QRdiGN3kdA5cZTTBfDivte0Fx8WB7SL+Pabj2Dv269E4RvYtbyhgEY2/0HLq7GgglU1kRfmY/GqJUbdUxsgdELTi8mSYWT0E8BuqdP+wWZZy0beEWOxOjzrW3yxTJBUsUc7WShpsNMHqJvnhyfppBu0jSUdPPPgVca61t5P8B94yFrzQQee+vfHkKfhdqSLTQi7oslbuX8ygU+HpRM+008RgE/JJ2o7bYrMLqzZaqcEnTV3Dz5h9S8EiYId3v/KtmDlkcwXB7XB9kDdfLyuYr364Zjxq/vHtv8U700FSGgnzni4lDVXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2O4z4AIg81Z43r2phqjIqXZIlAXvAT15J2yVHUb5GA=;
 b=PMqq40M14TjZA692TsOuhR7wbkTaXRshxjA2yTcCD3eHrdky3BuZ4W5pGXa2Yz3MrbWiyP6PdUnhkxKfh7HjHNWc3Vc/sxqpmSX5pjS8cYoftHOzn7FV+j8AkT5oUOdVdhbrTRRPasfNKS+KW8mIpuk2o0hBC4aoXUYBjsVlqioGLu+hPf2YsFRH8WC5ztw3JQ2NwLEYh0P/LVvhUdkVF5HafimGP4slVQeDFQ+lAT7UFPVpZhZha5Lq7WFel8m3+1j8yhJ+MMvZdIxhNiymicRGhgsC4if7nzriPTa6tPxbf/pj7r2k5kxtMZm1F/zmuNmV3lhoDLG9YyhSsgWCDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA2PR11MB4939.namprd11.prod.outlook.com (2603:10b6:806:115::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Mon, 25 Mar
 2024 23:21:18 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Mon, 25 Mar 2024
 23:21:17 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>, "Yuan,
 Hang" <hang.yuan@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGAgAFrqACAABw5gIAF68uAgAAN3oCAACgcAIAADqEAgAAC4oA=
Date: Mon, 25 Mar 2024 23:21:17 +0000
Message-ID: <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
References: <1ed955a44cd81738b498fe52823766622d8ad57f.1708933498.git.isaku.yamahata@intel.com>
	 <618614fa6c62a232d95da55546137251e1847f48.camel@intel.com>
	 <20240319235654.GC1994522@ls.amr.corp.intel.com>
	 <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
	 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
	 <20240321225910.GU1994522@ls.amr.corp.intel.com>
	 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
	 <20240325190525.GG2357401@ls.amr.corp.intel.com>
	 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
	 <20240325221836.GO2357401@ls.amr.corp.intel.com>
	 <20240325231058.GP2357401@ls.amr.corp.intel.com>
In-Reply-To: <20240325231058.GP2357401@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA2PR11MB4939:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: d/ckCMjff29LgPJ7k09A2bIPcO51Aj7haKkUotGYIsjoVabTKkbuivODuz1eo9fdVRspv+INWmn2W789JgHO2g6cBa4rN6sBuCnjk4gXhp78CpE3MoAE7rgoy5UhJMEmN/NPeD2c54QM5rjmGL5LE80CCZ5rYQ1VNWjSGN4ZTZWq4iG6rvbUPR93drHdI52UCtcB7n3jYaDceLnYYr9k+0ZTXbJOsfH06z1AsKtTY47EPYGxlM1CE3mrFoZQNllAaELL8VBALwpsXmMD2iIRvGW0X4pthx1ZiQhXB9Lczpf2HnHAw4HeYFlV+GJIvCA5oRtM0Q30Pd2pLMRyDx8+pQrRM/3SAIISQ8kkQh3JyPJP+3CxmPnDeiTG3TsBIFw1PZwKDjjI642HrRUnNTxz2LtfYegWkC1zPMKuGijXsNTzcKW6Q+LWh+jB6E8+Fq4W9WdQBlDXv/Hr8YPPQxQU86ZUDpoz7B9YheGIflAW9LoAll/2JqxM61eYqSibtVlWKbBQuV2ikm2MpB31ByPFraUVU+ZWqgbBl6ZwJa26SOhsOc/hPNH68KeeuN5+GVO64S0snVgDBk9kwkWouiHz+3cFk4SYNYtJpk1RVlQmA+qyDI9ZwnkBAe1ZwUt8T+zi+o3gaWqRNFjHxkwwxDSlQTrW6Qr830n4zAVCslPAbnM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDhDZ2U1MXgydFYwNlByUmIzcGUxZmZ4eXhjM2NZL2pZQWpvK1hUM29oSk1i?=
 =?utf-8?B?dTR5K1B0MWxpUGxxMGpXSC85VXpMMmhKOVAvelVUM3ZEblg1RmRESlhqLytG?=
 =?utf-8?B?OEtVcm95OWFoM2EyNDZoK0ltRjZQVjNuK3NqUlFMN0lJL1AzV1V1WmlISnFQ?=
 =?utf-8?B?ZlgzNFNsanVLejVaOTl2eFNOSnZ2Y0NNQTVkeXhkNlhEeDI2d1o4OHdxdTMx?=
 =?utf-8?B?YmFEYmhMbW82Ynhvb3VVY0N0cE1RUWxvV25QWm5aeG5YTE5HTUZvai9MbU5s?=
 =?utf-8?B?R21vQ0ZxM0ptQ0ZCRWlhUXU5Ylk4bDRlTDgyaFdlZ1FuSFI5VmZpdWVJQm5M?=
 =?utf-8?B?VGFDM0trdHhROEY5bW0zQWFNLyt6MmhyOG9OcE9zVjA0OUUxOU16d1BtUmFS?=
 =?utf-8?B?YUlVSUhJNTNnS3Y3SE5TWVpvaDNUUDc0NCt3ZXI5SlVqN3Zoa2FxWklyN2ZT?=
 =?utf-8?B?QU1TRDFJZDBRbmpHZ0dreTNrTnhWTitlOWNTVzA3U3dPaUpqV1ZLRFRzSXZ0?=
 =?utf-8?B?ellEa3FQZUhsdjhEYmllSGlhZlM2VW96SnlvSEp0c2pJRzM1bEVnc2d0azc0?=
 =?utf-8?B?OW9XYWh3Y0QrcVV0QnNCa3lQeWtidGx0aE5sMTlaVE9kNE1YcGZDckFXRVRj?=
 =?utf-8?B?ZGE1N2N2eTUzMDdsTmtMZDJiVzJZMEcyekMyZmtOa1FEYVpvR0kzaHJtdk50?=
 =?utf-8?B?dlVFR1c2RVpKdGN6L1I5eFY5VFpGKy9Db1lCOFVmWERWem9ITkhWTUVMVEN0?=
 =?utf-8?B?K1RnZit5VDg3bmdnMFFZZGhBOW13QWFidW04eHVGZEJscERHSC9PbzdoRjNC?=
 =?utf-8?B?K1M2OEtFMGRNbjJ3K0NJUVExNG1kcS9aQnhJNEVQWDVUV1ZQODlCVWZsdUhT?=
 =?utf-8?B?dFRWYjdwWFFlR2JFdTBSZEpKQzlkQmZnWWZOZDMyWjhLaTJJZG9KZU5IOG9M?=
 =?utf-8?B?UWdYdXVSalp1TGtDMXl0T0lUVUNFalNuNFZJZzdramorNlRzUDhCMlhxaGJh?=
 =?utf-8?B?b08rTzl5NVVkaXdRcXhpVkFKYXFwcTV4ZHM1Z2t2dzlGQ3lwN3pvYUpCRFFK?=
 =?utf-8?B?ZHlWQndKSE9uN0sya3ZKNW1SUXNFTVB5eDNicjhXbTNYU0VQRkJncVNBd3NY?=
 =?utf-8?B?SDNna1dNSkxIbDBHRFA3TlBRNXFkUll3SnE0OXFtTGMvTTdFMXJqQS9mam5J?=
 =?utf-8?B?RGt4VXpKeWNmS3VHTTlmK3liem1hS2p5MTZ6clVhQU9iUlZxZ1ZDam9sQzhv?=
 =?utf-8?B?cURiSlhEU3RZRnZxS0E5N1BlQTRpM1hzaEhucXpDelIra1lhQzhVUnhhTXBT?=
 =?utf-8?B?WjBzNXBOanBXeXhlWGJ3cnc4QjY1SG53dTJVNlltMG02YTNZQjBDaWNTSXZL?=
 =?utf-8?B?S24rdzQxa3RVREVQV0RBbnhOYnVML2paRlMwM3lRdlB0NFNOa04yUlR4bXpD?=
 =?utf-8?B?NVQwNVExVi9SNjNLemJwTVMzZnBpZis5cEM4QlVFTzdSaks4RFBXMUQwRFZZ?=
 =?utf-8?B?d1JRTVQ1NjhLd2xkWkRYbTlqOTZmWWJFZkVTWDVTVEtZY2VWbGlGTjlITVVT?=
 =?utf-8?B?ZmNlQklRdWorTTRrclZ3NFFSYWpkS0ZuamduUUNmamY4U20xQU5XRUE1dUxs?=
 =?utf-8?B?ZEtMUGpaZGF3ZmZzaTh0UU40MXUySUFUUmlqdW5pamJsckczZjhSZTFUODdS?=
 =?utf-8?B?elJSejdHcy9KanNWYlZWYjZqQUFhRUdMMlBFaEJyZjl4ZEQxYTNDU2sxUlhH?=
 =?utf-8?B?NTNGcjVJVVd5Sk56ZnVDcXQyMlFCZ3prZ2tqL1lmYjZ0NWxFbk9Lclc0dU9T?=
 =?utf-8?B?Wm1rZmRZeUtlL002alpydWJuMXFzWHZRUFp5b0VHVi9hai9IWnp3cmlQRU1G?=
 =?utf-8?B?WXc2cDI4WG5vRTZ6WDZLbk13TnFJQlVWWUd1UlptVGl0UFc3NGpveWx0ekxw?=
 =?utf-8?B?dXdMdG56KzZzZWF4RVpwSjQyYllvdzdVTDc4US9WRWphUmNteEI0aXVTNUJ3?=
 =?utf-8?B?RWJvU3lWalZOdVdXYnZHeVgwWHFJTjRZZGhTQTZ1UlZyRHY4Tm1GMVdpVmZi?=
 =?utf-8?B?YWZvS0JuTnkrYURhL0o2NVRXWGEySTNFMHVrUCtwa1hqeWVXc0ZLbTNNSlBB?=
 =?utf-8?B?SFRlSW12SHRJaEpwSHZqbklmL3JmOS9PUEU3aE5wTzYzR1V5ckN5VjlLYmVv?=
 =?utf-8?Q?VX7vb9RNM9JPDufHQPDUjo4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DA9B26792ABA3F4A9E81E1BD5E73DED8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 77f7a0f8-bb05-475b-5b00-08dc4d22460f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Mar 2024 23:21:17.9190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OFsWT4iShbYcq1dq5Pca5gomGKdm1r76R8D73fdeh0GGHBbCNYB2NLYSp7OJ0pjFIzdfJDyhs9V2b0zluRfBaCTSz4zQiEEulhNFvuTOjQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4939
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAzLTI1IGF0IDE2OjEwIC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiA+IE15IHVuZGVyc3RhbmRpbmcgaXMgdGhhdCBTZWFuIHByZWZlcnMgdG8gZXhpdCB0byB1
c2Vyc3BhY2Ugd2hlbiBLVk0gY2FuJ3QgaGFuZGxlIHNvbWV0aGluZywNCj4gPiA+IHZlcnN1cw0K
PiA+ID4gbWFraW5nIHVwIGJlaGF2aW9yIHRoYXQga2VlcHMga25vd24gZ3Vlc3RzIGFsaXZlLiBT
byBJIHdvdWxkIHRoaW5rIHdlIHNob3VsZCBjaGFuZ2UgdGhpcyBwYXRjaA0KPiA+ID4gdG8NCj4g
PiA+IG9ubHkgYmUgYWJvdXQgbm90IHVzaW5nIHRoZSB6YXBwaW5nIHJvb3RzIG9wdGltaXphdGlv
bi4gVGhlbiBhIHNlcGFyYXRlIHBhdGNoIHNob3VsZCBleGl0IHRvDQo+ID4gPiB1c2Vyc3BhY2Ug
b24gYXR0ZW1wdCB0byB1c2UgTVRSUnMuIEFuZCB3ZSBpZ25vcmUgdGhlIEFQSUMgb25lLg0KPiA+
ID4gDQo+ID4gPiBUaGlzIGlzIHRyeWluZyB0byBndWVzcyB3aGF0IG1haW50YWluZXJzIHdvdWxk
IHdhbnQgaGVyZS4gSSdtIGxlc3Mgc3VyZSB3aGF0IFBhb2xvIHByZWZlcnMuDQo+ID4gDQo+ID4g
V2hlbiB3ZSBoaXQgS1ZNX01TUl9GSUxURVIsIHRoZSBjdXJyZW50IGltcGxlbWVudGF0aW9uIGln
bm9yZXMgaXQgYW5kIG1ha2VzIGl0DQo+ID4gZXJyb3IgdG8gZ3Vlc3QuwqAgU3VyZWx5IHdlIHNo
b3VsZCBtYWtlIGl0IEtWTV9FWElUX1g4Nl97UkRNU1IsIFdSTVNSfSwgaW5zdGVhZC4NCj4gPiBJ
dCdzIGFsaWducyB3aXRoIHRoZSBleGlzdGluZyBpbXBsZW1lbnRhdGlvbihkZWZhdWx0IFZNIGFu
ZCBTVy1wcm90ZWN0ZWQpIGFuZA0KPiA+IG1vcmUgZmxleGlibGUuDQo+IA0KPiBTb21ldGhpbmcg
bGlrZSB0aGlzIGZvciAiMTEyLzEzMCBLVk06IFREWDogSGFuZGxlIFREWCBQViByZG1zci93cm1z
ciBoeXBlcmNhbGwiDQo+IENvbXBpbGUgb25seSB0ZXN0ZWQgYXQgdGhpcyBwb2ludC4NCg0KU2Vl
bXMgcmVhc29uYWJsZSB0byBtZS4gRG9lcyBRRU1VIGNvbmZpZ3VyZSBhIHNwZWNpYWwgc2V0IG9m
IE1TUnMgdG8gZmlsdGVyIGZvciBURFggY3VycmVudGx5Pw0K

