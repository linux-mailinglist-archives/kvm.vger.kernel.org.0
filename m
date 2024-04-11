Return-Path: <kvm+bounces-14326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D6308A1FC3
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 21:52:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4FE7E1C23FEE
	for <lists+kvm@lfdr.de>; Thu, 11 Apr 2024 19:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 855D817C9E;
	Thu, 11 Apr 2024 19:52:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CkZBGRGY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE7217C67;
	Thu, 11 Apr 2024 19:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712865130; cv=fail; b=ea86qBtCtLqDOLgXTM6bYHYYmMxq0tDvosuKN501NE6Eri8RmazgaES843jAGjqwsstypV8nnfyl8s46v+1TxKsRNfzTK1KwcsSN6I95CyvkMSJiG69g2I6mXlItQy5XMuz8tcjRuozwRpUJNqQyZd8PzstLtQrcz7E3fkZBwfU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712865130; c=relaxed/simple;
	bh=cSdlMq6m9jhheZfhb/5yFI9X/NQhsUCRYUU9ghCiA7E=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pcy+/4pvs8JQHkieTUL0+r7U4WjZNVBfUs5HqKetO1/jF62d1z8eo+xmDvQtggFKqRAa0DgV2oYkOlM47oR7ihEiAi8tW+ZC4DrH/kedmtEstsbpueaz5WpeiQDku2sX0zoeso6qxxenq4y9u2ALPmmSMBPNEY0h2ThdD99Do3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CkZBGRGY; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712865129; x=1744401129;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cSdlMq6m9jhheZfhb/5yFI9X/NQhsUCRYUU9ghCiA7E=;
  b=CkZBGRGYCHWG7W5EhYOb/6UuADMm/oQL2ZifGylSvqR3+mUZZYsiWJ2Z
   Eu+Bki/8VirveX2lc+YeGVJliXzdlBR6p1XBWviNQO5tOYu/4s8NchFlH
   OFLs2dU+IXG+mewtFs0Un4Nf5w6KxFUGTfcI30OpyKjpX7PKiizlUQgXf
   3j4xKXAA7cj8iZMX5WfCZdvVycOaXa3SBrM2MvG0GfCP3/4rWedtlh661
   qSlBORfOOLtvzdHj17jqIbj398ycevWUBoyjSAUBTiEggAev7mjSHLYVz
   UsC+JoSSzcFOTVzDP8ODcSeJHZmTCjstrjA1JDruIDAtIcG59rdF7yYnq
   g==;
X-CSE-ConnectionGUID: A6yP5RUCQQmBEK+xxRS3jw==
X-CSE-MsgGUID: taTGSvwYR9yM6UgTLQ2hfg==
X-IronPort-AV: E=McAfee;i="6600,9927,11041"; a="12087866"
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="12087866"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Apr 2024 12:52:08 -0700
X-CSE-ConnectionGUID: Itnk48vdTImxGoG2tUz3Dw==
X-CSE-MsgGUID: cGmRmoUjQxKL7F/V7834xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,193,1708416000"; 
   d="scan'208";a="21086136"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Apr 2024 12:52:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 12:52:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 11 Apr 2024 12:52:06 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 11 Apr 2024 12:52:06 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 11 Apr 2024 12:52:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/nQ/+vcBzH70dfZvgD8UDcEm1jEIxP22xhE9jLiHxHroWw7FBKW5iGG3Lm+PtkjquQUEJTmJvB0Dgl+MD0u7N1cgYMqehjCnEeHVxQL3PeQAy7pDMktrqqKZjHQyhxnpW5nfbopr3vr5pXUpFlTBLhcQT1amSBqrHexOqfjdkCOGIyoOfDjgAzmkHrU+T2m0oJQZp79EA6iSJ1GmIUpHr2VVMJGwM2pmRchGcn4d1ezNhugNIsw5mT7cQuc3MDRZGKpxBjpfYzEWaVmlNh4+CZTuv4uUAOYeVrBC31V6iOVKL0SVTfBdH1RdQN/O1Ko+K+mByH3ZtwnuUQuKCOmzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cSdlMq6m9jhheZfhb/5yFI9X/NQhsUCRYUU9ghCiA7E=;
 b=hSBDKXosdJ/z14zaGCssPiDezylogWeq5mtEcL8N3+3zTABt8tzUomsjhohmmmLcc8446BUue4P3LYhk5KII7GMVcHYzPqYKw4EgH+YAWX+6NnwxgGID/H5WIcq1qPDPRhdmmt8HQ5zz6981ojsUJiZ6YkwhAyjlGpVcjm0QW50I0HASKgupNCEoSSIye76y97qZRSx6GvRbcD+LW2Y6L7mGQDEvm4z6xq6SpMiijnXiroSs5JHfuM8NUxaSfaL2OHGiu44/Fa5vE3RjFt8qqBkiT967odpD7h5EIkN085RZjAK815SLLBopwkmNBXuc9Fm/oZC16Kr8B9o3kaw/2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB5311.namprd11.prod.outlook.com (2603:10b6:5:392::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.10; Thu, 11 Apr
 2024 19:51:55 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Thu, 11 Apr 2024
 19:51:55 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Yuan, Hang" <hang.yuan@intel.com>, "Aktas,
 Erdem" <erdemaktas@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>
Subject: Re: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Topic: [PATCH v19 039/130] KVM: TDX: initialize VM with TDX specific
 parameters
Thread-Index: AQHadnqikJftpAPTRECy6a/NFCG2mbFe2xEAgATEWoCAAAcHAA==
Date: Thu, 11 Apr 2024 19:51:55 +0000
Message-ID: <54f933223d904871d6e10ef8a6c7c5e9c3ab0122.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <5eca97e6a3978cf4dcf1cff21be6ec8b639a66b9.1708933498.git.isaku.yamahata@intel.com>
	 <c11cd64487f8971f9cfa880bface2076eb5b8b6d.camel@intel.com>
	 <20240411192645.GE3039520@ls.amr.corp.intel.com>
In-Reply-To: <20240411192645.GE3039520@ls.amr.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB5311:EE_
x-ms-office365-filtering-correlation-id: b4eb633a-90d3-4bd8-d50f-08dc5a60d779
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wVajuVluAvHwl4GMpFCYoRgOc0+cLt1kEwLtw/Z/hj+M0L4gi/XevDFyNDzn5hPMFIsXqN4V5btZ3idz8ilTsH7N26y6pjyMBB4FBYakrSx6cf0dXqElW7lL7V7LhvlCa1yYW+mbBwGEIOQ6K+LPLOUVDSrReyffGOCMnpnMaugQ40Akj0rlf53FfOesrVFZhS9ndRl46BE0rV3l+0GzWHshzM5rizvV18a8imBAQMxkuET4afanYN1SfWhgrXNyC6beYGe+Akluz9x9ESOja1fD6nYXO9sHahwGzwvImlUUegTC71APuzANXrCirhkRxdqzG7WPBCHaHHNYiB4KrWSY5KNP4YaLiS8OQ35GF7gd02OrdBao0S9eeAXB4x7XbGTt8SSi2yfUMeOObzZOHpivz7d4igZuCHmnnevap1mM7DLEN0Uc2UZN1B0BV4ibNzGQ7pJDtfrpCL9IvlUDy1GMnlJi8aivFJViQEdEkfVa4um+SGnZWxmx7sQ2KxA6YMKmfITvT93FWTP8hHo0fSy1kbhPGmrUdVhlWNeTGsePFjTfCEh8h6mOPyw7GCge9+LOikNj9qq2FO0HO6FTmjTFmmDtBcsu5BvURdrwfyR4VEZrpz3gTRkWQzJeXQXG7oO910vyJ2LXWV4LFfAXUNd3sVqvePc3B1IOSprtPL7rb/nsWAzFXYrndcNygOTISbvyttHlykQe77dtxyEsUu/RsugM6MpFfrh5cZVc2Ew=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eHM3SUFhSXBBTExoaWlzcitpNWNlRjJ0dS9zVk9CQUNPSUtWN1F5SE9mNVVC?=
 =?utf-8?B?aUtobit0WUlTaHVWOXNCTjE1eWVPeVplZzFqVjhXTWxIUnFnUitDMElUSTln?=
 =?utf-8?B?N0ljOVMrTjh5Tk01OWdCRXpjc0t1Nkl4OVFXaEo5RFMrUFVoUk9sU2ZhZWcz?=
 =?utf-8?B?RVRwa0ZyVS9NeDVTeW5jRnJVTGNuSXhrc2JjTjM0bkVoRWc0a25hZDBYYzB0?=
 =?utf-8?B?LzhNcUVCWXhOMml0K3c2UnA0azhzMXlmWTFOY1c2K0EzaUVlZklDSWVwUERz?=
 =?utf-8?B?Y2JrVnJ6SkJ0N1cwaW9HNnFaYzhUY2h1VXJvTWlrWUUyUU9IRG5teFZrMHlm?=
 =?utf-8?B?ZnNvdGJ0RnpjaEc3aGZJRFJJcTJnMTNhckpvd29DbUs5OXVObzJKYmNLVk9s?=
 =?utf-8?B?Y1FlVThsSDdnUTB2Vzc2YVVIeU5NN0lhdU1CYXhlRUxua3hlRHhiMU9CMTM4?=
 =?utf-8?B?L1ZSalBZVElYNlBNTjZ4ejhseFFWWmVMVFRBZmdoMFY0WjJYR29qSUYyV1VL?=
 =?utf-8?B?QkxOSjNvWmN1RndLc3o2aFp1bXB2aEpHSlJTcFZrZnBETGZxZDYwMFMrRE1v?=
 =?utf-8?B?M0tycmxGTEIxZzdNYzducXJMUDNRNW1yRnNwQjFsWldwR2RTazNLZGJxcUs5?=
 =?utf-8?B?cXZwZ3drYUdOZEpEOEZOSlV3dldOaGUrdlVVVXdWejUyaHpvUk5EREJ3aFRZ?=
 =?utf-8?B?VTRSdldSNnorSERMaUZuR1BNS1pPejJaYzNkcGMzTERSK0paVHcvK0lYb3BN?=
 =?utf-8?B?UjRzeTZmWG01YlJoUUp4YlFhajhnUVFlTStoSGNSdFViUGlhTmNHbm5yVEF5?=
 =?utf-8?B?bU9xZndqYytUV1R6K1BXdVl4NjdsUFFpVHlKY2w2clA4K1YyNVlSVXNRYXdZ?=
 =?utf-8?B?TTV5OUNoeUtMRDFoWGJXM2xxMDRSRHZnaFRpcWtGZTFmREU2OWsxY0NQQWs2?=
 =?utf-8?B?Uys3c1hiODJ5TDlwVHN0dmdXRGl3UWhQbkxrS1poNmVOYksrWWdIVWdSdFVD?=
 =?utf-8?B?clhHSWVuczN5V2RaQ0pXdTQ0Z0l2MDdDU3p5K0kvdlR1SG1hNFhNT3MzUSsz?=
 =?utf-8?B?amN0elNnQi9rVFJFc3M2OSs4MkNDck5ia2VHeHU5Nmp6NEEzWjF6TDErV3J5?=
 =?utf-8?B?dVpWSllBbk5zbkVPZHVZc29yU0FXK3B4dlJDSmthQ3BwL003VWFaUzA2MXhr?=
 =?utf-8?B?bTFWVHRySEpxK1ZMeWduRC9ld0JON2l4SFJHUzFqNXpqd3YwMnMydytwN2dj?=
 =?utf-8?B?bkthaWZIRWdkMzJsVkVMTGVpYXB0cDFkeVhSRkRsd01iS0hlUW4zWkRsUzRD?=
 =?utf-8?B?dFVlWnZTMVQrcjJVaUZ1cThpckdVdHBIWGphTHJBUFpoOEY5ejVMTXd5SXdq?=
 =?utf-8?B?ZTFSTkxxdFFIR1FWN2FLc1F6Q2NtUkNhM3VGd3VocGVaTHliZmUrdEVJY0Zv?=
 =?utf-8?B?SzZBbk5FZVVnaEd1ZkdmOURCQ1dSV3dtdTRHQlEwdUNoVzBkMjJTM0d5MFJQ?=
 =?utf-8?B?VEE1QnI2SFJCalRCL05hZ1ExY3BKdUN2WUl0R0lvZmp2QVBaR0hvYVNtZnEz?=
 =?utf-8?B?YVc4YnlWZVJJVWt1NzBLZk1lSnQxbGZYejlkSElJSk41WGd0ZmRJUkJhQ3pS?=
 =?utf-8?B?NEhDY0lUWnNBeFJ0WlMyODEyQ2hReVg1RGJhWkpYUDMwZmJZV2ZVUmVVSTlX?=
 =?utf-8?B?empoc1BiR0o4T1lHWW0wRC9USE50bExici9Ja08zUHVVY0tObFpaUnIzU2My?=
 =?utf-8?B?TTZVUnd1bElTem01aCtBeXpaanplbmUxeHdzcGZtZnFJNHN4NnU4VGloQjJP?=
 =?utf-8?B?SFNZM0J3WWlGalhaNTV5Y2pRamt4SWVMdUo2bzYxZ0FXVjdNMEtqNnl6V3BT?=
 =?utf-8?B?N3ZVTXcyZW1lZnJzT1RXNVBEcExVK3oxMHVDMHlSZkExaGhvV2t4ODBIVThB?=
 =?utf-8?B?WjRDeFdic0RValhoam9QZGxpcUlLcXFuRE9zN1FuRE8yVjAzQnhTd25LWldn?=
 =?utf-8?B?aHVZVTA5bzdtQXYrQkxnVGVEd3pEL21wVmQrUC9GSzdvc1JoSDRUV24wTkxG?=
 =?utf-8?B?dDkrQUJxbkxiU3FDK2hhT09sZk9TaDB3Zis0UWQ5NGNmemhvZmlhY01QNHRL?=
 =?utf-8?B?Yk5tazluWW1mR00wYVhGRnlKQkZvOW8yY2ZGVTNEa2tlOUxuRGVucHhISWZI?=
 =?utf-8?Q?9fuacrCPEFtdQCnoRUgC9+k=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6923FB44591B284A8E4FD52648A57094@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4eb633a-90d3-4bd8-d50f-08dc5a60d779
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2024 19:51:55.8012
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r//oEgWb4lEyOlUV7HKi00Br4CXH7aLwdcBv5C+gIdxnfuaAHjimRBjEDi5qNp52aXC0wyOdE+hHyA63gm2JeHltr/mE7b9USz3IYQ7H+/8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5311
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTExIGF0IDEyOjI2IC0wNzAwLCBJc2FrdSBZYW1haGF0YSB3cm90ZToN
Cj4gPiANCj4gPiBTbyB0aGlzIGVuYWJsZXMgZmVhdHVyZXMgYmFzZWQgb24geHNzIHN1cHBvcnQg
aW4gdGhlIHBhc3NlZCBDUFVJRCwgYnV0IHRoZXNlDQo+ID4gZmVhdHVyZXMgYXJlIG5vdA0KPiA+
IGRlcGVuZGVudCB4c2F2ZS4gWW91IGNvdWxkIGhhdmUgQ0VUIHdpdGhvdXQgeHNhdmUgc3VwcG9y
dC4gQW5kIGluIGZhY3QNCj4gPiBLZXJuZWwgSUJUIGRvZXNuJ3QgdXNlIGl0LiBUbw0KPiA+IHV0
aWxpemUgQ1BVSUQgbGVhZnMgdG8gY29uZmlndXJlIGZlYXR1cmVzLCBidXQgZGl2ZXJnZSBmcm9t
IHRoZSBIVyBtZWFuaW5nDQo+ID4gc2VlbXMgbGlrZSBhc2tpbmcgZm9yDQo+ID4gdHJvdWJsZS4N
Cj4gDQo+IFREWCBtb2R1bGUgY2hlY2tzIHRoZSBjb25zaXN0ZW5jeS7CoCBLVk0gY2FuIHJlbHkg
b24gaXQgbm90IHRvIHJlLWltcGxlbWVudCBpdC4NCj4gVGhlIFREWCBCYXNlIEFyY2hpdGVjdHVy
ZSBzcGVjaWZpY2F0aW9uIGRlc2NyaWJlcyB3aGF0IGNoZWNrIGlzIGRvbmUuDQo+IFRhYmxlIDEx
LjQ6IEV4dGVuZGVkIEZlYXR1cmVzIEVudW1lcmF0aW9uIGFuZCBFeGVjdXRpb24gQ29udHJvbA0K
DQpUaGUgcG9pbnQgaXMgdGhhdCBpdCBpcyBhbiBzdHJhbmdlIGludGVyZmFjZS4gV2h5IG5vdCB0
YWtlIFhGQU0gYXMgYSBzcGVjaWZpYw0KZmllbGQgaW4gc3RydWN0IGt2bV90ZHhfaW5pdF92bT8N
Cg==

