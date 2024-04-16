Return-Path: <kvm+bounces-14781-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 927628A6E9D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 27ABA281A52
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:41:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 271E612F37F;
	Tue, 16 Apr 2024 14:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EfLJ8jrh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F97B12DDAE;
	Tue, 16 Apr 2024 14:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713278451; cv=fail; b=EQSBoBZF34JFuL45cI/IEcTY9wfvIBAm/Hvhhz3c16YL24lLZme2LnD/fOH38H+sNSKQeJDJhbT6MBmocQqy+SPA0CJTC7WEmFbn0PdOx+EhhQTjKf0W8W/78hYvriEjtOvDhEj5uy+CrK1Q8BZJEhKfqWryfxbFlWmKrCwy5GY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713278451; c=relaxed/simple;
	bh=koqOMukx9N+sWjbaGJYuIsquiCcJ/PWQ2BkQEyxpDAw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dPAzq89FHYHvrwJDSiJfAIVHwh8eL3117yoHo63GhHUseR/2mP1+xw+5MqY+TMl+Zltw03iDooQ1bH6wH5ryGppKDIVWki57h+B3S7G/gLCA/20MeSs/ni6FXQ/pyS3jRfHqEe/6J3gBFI9ucUHnID7WWXyQ63sm8/n0SzoUBRs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EfLJ8jrh; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713278450; x=1744814450;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=koqOMukx9N+sWjbaGJYuIsquiCcJ/PWQ2BkQEyxpDAw=;
  b=EfLJ8jrhL9ZpLIpdeH29bRLVsC8fpU6OL9sUlKeLKzSOHsshU/KZUvgI
   cRNKMsnIa6lympbqOEo63Wif9kqLcyunD/iK1H51dJMR3XHucdU0zAPdE
   1kv9dJWoojX1AjpXKbEnM6n+WVSblHj9lyI1nZ2mMhadbskF68jfoN2cn
   xKcnXbskgKrKtDHRY5fK617V0N/8v49c4giMcyjd1TDjDCMFWp5YQr3pK
   +a9+qQ1xx6O3QIOBu/cJMMbO+jAasn9dE6AtFBN1bycrs7nYjfjxrYRsL
   NRBRQo2/RjJxS0x6sVLk3Z6gbJFLejvAY3RZVhRAYOfwBh47WHxaEsAD3
   A==;
X-CSE-ConnectionGUID: UXGa2RzPSvmEs+awF+b5wA==
X-CSE-MsgGUID: TDyxXinPSQ6nNtS2upQO6A==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="11667111"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="11667111"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 07:40:43 -0700
X-CSE-ConnectionGUID: 0cTPvFjVSvSno9FDOSNLRQ==
X-CSE-MsgGUID: le0V2O2fQ8WThNMJqISBXw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22874885"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 07:40:43 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 07:40:42 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 07:40:42 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 07:40:42 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 07:40:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=keu5ROiOVVuZ0G1xgQFjJb3W3K8rgP5ViRUHNFY7Emokt2sxMRS+YP36iUkQiwlDcZel0qdoC+CXhkk6F4SJgnU6DD2ZxERKwjJugpzxOjJKACb1svM46ZjhQeVsOJAxzoV0mB7WwSfT30uiQ6BDD/Kv+Ktke+1V0X4ucjLf8+jgjohY5ykwJgY0zgMf8E0FOOLgr5X2xaogVZxoINtgTqK76ihkeTPBAlUFtA/vDXZ+SGi7kOOgFMO3fEQ6sR3+r+v6/TH7uAlhO9j74ZSVwtie7FNLBm1NWW/tLXqHKPVAsGeqi1yFmnYDxklTD4tNPISh4+RjthQz1RKIxdulaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=koqOMukx9N+sWjbaGJYuIsquiCcJ/PWQ2BkQEyxpDAw=;
 b=BnpJJOpE237aE6AGzF38K1SljjL9DpBOB9DY1QFNadLQDV9JPiK9sTow/EzbibxmJWv7XlQ/t5qHzhh5mrcWUCGpt6bIMa//2cPm+oKIb1RaOzHU9mXTpNKmHAY6IB3ZkO9c9ol/GP9VQy2qnwPIZWbg1tHnYi/jpAKbJTXeIDsSnUa63uZEU34mb+kzkwF49wd6Sf8A8Pyge38STlus6TM7hYCMI8v7JOT6jITcPIri9Din7rNHs3Q8OksDDRdQ6/B2vbW7/yKfc/HvcvMhgQElT/39Kg6Ih64er3g1871FkEYncCrTh3kPYPt6hdshJhmSlK6l89N51yLEkawx4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by IA1PR11MB8200.namprd11.prod.outlook.com (2603:10b6:208:454::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.49; Tue, 16 Apr
 2024 14:40:40 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 14:40:39 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "federico.parola@polito.it"
	<federico.parola@polito.it>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"michael.roth@amd.com" <michael.roth@amd.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>
Subject: Re: [PATCH v2 04/10] KVM: x86/mmu: Make __kvm_mmu_do_page_fault()
 return mapped level
Thread-Topic: [PATCH v2 04/10] KVM: x86/mmu: Make __kvm_mmu_do_page_fault()
 return mapped level
Thread-Index: AQHaj4x+DdIUu3O04EOlwxlv8TM4m7Fq+QCA
Date: Tue, 16 Apr 2024 14:40:39 +0000
Message-ID: <567468a068fb160b724a7fa1fa8c36767d9155ac.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <eabc3f3e5eb03b370cadf6e1901ea34d7a020adc.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <eabc3f3e5eb03b370cadf6e1901ea34d7a020adc.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|IA1PR11MB8200:EE_
x-ms-office365-filtering-correlation-id: 3965d635-d434-4809-c5be-08dc5e232fcf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 81v3GxXxuFeLQ3xDZrmKYzInuQ1w1QxzXbaRibemAson5M1GOPCiAnWbciHsuGZy2yrHu41TdCtVz/6Yfuor9PG3lVpMnLQy4Bfk0VcaZmipo9aAWbp4qe0ENuj8noiD2WBOERZls4p921pkGxdCxN86r8y8nbODp8uNN92PHW/cWKUZ0GwRYflb9gyPC4tSqgsv+Gf64yE7qve3zjAo9RDOmWLA4QqixGhbNEVpnuZoL+JS5fGmd8mXH/2DtJwsIjxiVxRxmh2vbEOTzzKvlGGypi7sBfeMcbVGifENvKQfY6pt3Q0kkwajHwHUSBc+dWf2+bn0Gyk7tfO+jbjaL4aWk7Ve8GDWUKedRjsRXW4peI83K7/hyMCvCaUmXVaFfV88ZIL+D6m5IjdAQ4u95iJDgjR/SExHEWXD57LD2rbSJaVN/7BkdK8Rkxox8EglQEi01OQeXjwhU6d0nEVFrTvvSElB96MQsUJqjvrMjYcX4Iu1rGM7RVfqgvT/+cn5g8SFGFXmv/PBL75tZumTTOfJMbDsmo+e1vxJp+M/BgnS95TfzeW8VpHt/potpiWpVYgVtSw5mV0+XjXcwaruz+qhLSJbglk5ObL4YAEQp/M5Qe5FoI9VMBuqQt/GuBWKqt5bHoBFxGv711kLhPc9SFKbQFIk9hsaw3xRZJLHfhZsKggE6M2pM++pUjQ0O0QY2TiD+ELVazd93io8FedX++WoMqaQQR5+NXldIuitSv0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1BtZ0VSSU93dXVUZHFJMGV3VUlrcVE3Y0s5TlJROWVsWUgrSjBlM0hlMm1W?=
 =?utf-8?B?ZHNweEMyNzQ1d3RVbDU5ZktVTlFWUkNGeUs4WkhiaXJOSXZIaXd2YXZWMlZi?=
 =?utf-8?B?blROVDZYYVBDaFRLR2N1ejJrR1BWMXQybXNtelE4VWo0RjcycnZHSlVrd2pq?=
 =?utf-8?B?WDBJWE8rcXRUOVRJWW03VHl6R2h1NmtSWmdjRXM0S05scEVIdVNaQklldElO?=
 =?utf-8?B?MGtvRHp5QjhqWW9sQ2pNT1ZRYmxwcEgwa1FaQWlqTCtPSG5YRENyZWFJK0lD?=
 =?utf-8?B?aVFXNTBvWjRQbElXRjNycnlBZWNtRFJPMEdpU1Rmd2dkKzlwTWRIZUVHd0lC?=
 =?utf-8?B?bjJVK0hER09DZ1pmRDl4Z3lkN2lJaWpFT1Zrb3pkeTlod1d2d3JwU1RpdzFh?=
 =?utf-8?B?eFR3ek41REk1dGdVYllra2RjcVg0K3pkUE1aTlh1VStxU3FVR2pNS3U4M3F3?=
 =?utf-8?B?WVVhK3grdGJYcTR1Z3dGTC95M1J5ZkZBem5saXpKV0lRUHVvbzRCY3lXSCt1?=
 =?utf-8?B?Q1hQeW1reWRCUmpoR0hFbFJ5Z0pCUEJUUk5oQzJsN25kTCtvaFh5MExoZTB3?=
 =?utf-8?B?eTJCbHpsWkhGUGtZb3BmT3hNWVhCSXc0d1VWV3NySnlXcEtGVmdhM3N4T05W?=
 =?utf-8?B?Uk5FRERaWVQ2WFR6ZnBSRlFaNzc1ck8vREMxa3huYS8xWU4zblpQbHM0dXMr?=
 =?utf-8?B?dEtwM0Z3NW50Tm1MaElRRmF1M3B4K2E5YXJES0xxV2JGM296VWwzOXRLUSsy?=
 =?utf-8?B?T3VhditTVk9GRmxjT09Ta0kwOXM1T1NWcXB4U3pIV3pNR0hzMmt0ZW1JMzZJ?=
 =?utf-8?B?U0l4SktlVmt3ZGM4aEVXQ3h0d2d1YjZqUnY4ZGlpb3BvUUZPK0VOL3YzdUgr?=
 =?utf-8?B?SXljcHFXc2RhVld2RmlZL0h4UTFZeU4reTRzWXNXUXdaTzl3UEpUeU1UcFJH?=
 =?utf-8?B?dlVsL2JId0xhNlFTNUs4QnVQUUpZN0RrRkhJd3RZbzk1RnBxS1JCYmdBSnJN?=
 =?utf-8?B?SEl4MkxmdUtVQmRzRVF0RFNmNXFCVk9HdW8rUk1ndUhsTVJ6ZDFZU2VRQ20y?=
 =?utf-8?B?bUdESldwdlJqbTVZSTIyUXlwVjc2Yk52cFdVZk94MjFLcWl0L1I3SnNXVnZi?=
 =?utf-8?B?REpNZS8vRVZPcitjUnZINThoc2xGSVJWM2tKVFArZDRjQ1B4TnJyTkFNejlT?=
 =?utf-8?B?WHB0WEljZmhtTkhHSGFyNTlUUVU2SnN4UFpydlhmRUhjZDRVZGRrSnZSMnFE?=
 =?utf-8?B?R2ZMVG9FaWlGNDd2MFo2K1RWbnp6UjhsaWFlNXZsNVlGNHJyckVOK1ZoSm8x?=
 =?utf-8?B?b2JhUUZKT0VVbi9RY1NnV2JBc0V5QkJ4UWtRYnYzNEF3REZZL3luaFhPMEEv?=
 =?utf-8?B?UkRFcCtBUXpjaUg4dzF4K1UwQ2FvOUNDbUNvdS84ZzZGUHhXYVBIL0JjNC9o?=
 =?utf-8?B?TWFOazZrNml4cm1lVGt3ZlROcjR6MXhyTHRRbEdnanM4cEVpeXpsUnhkTkFz?=
 =?utf-8?B?Mi9EeVFwWE05c3QzVWJ1cUJPYzdyNHF1Yk9qKzlybzhySmlEaGF6WllUcWZK?=
 =?utf-8?B?bWROa0pmVG13ZHRJclAxcTVWakZxeTRZN3Q3bDZYNVhDS2xLVThmTlk0d1o0?=
 =?utf-8?B?Zi84N05JZE4zQTB3RGZIVUNrN0lTZ1pvYjZrTkN1a1lKWm4zNnVaTitKUnpm?=
 =?utf-8?B?VmZTdTA0bUUyK1dCbXdlWE5vZmdTYTg5a25JeUN2b3pXcUV2MlNYQnFac0Fz?=
 =?utf-8?B?UmNnWFFFYUt1Z2l1WEZlOURWRUF1UDE3RE80cFlmZ3RORjk0M0k5WDlBM2ox?=
 =?utf-8?B?d01hdjA5dkVIRmVTNngyZW5sYUxLTVc2Sk9QQ3ZBVUxQNE1kSHJ2U1VNSFMw?=
 =?utf-8?B?V0F1QWs2Y3BxNksrUjFZZjBXT21JSVNicVVyamRiT1BZcmU2R1N3NURFQ3hX?=
 =?utf-8?B?N0F3dmM1YXBnRTA5MkpjbHJneFJLNmZ3b1NnbEpGTHZCV1B3SVNoU1BMRlRw?=
 =?utf-8?B?bjh6YmFXcFlMOWRQWDhlU0ZESUNmVE9ML2hKT1NWZmwzdWFlWGEraUJPcnJr?=
 =?utf-8?B?Z2VLR0lHQ2hNcjE0VjdJOGtOS0d6TEhvL0dsWlgwa05PbExpZjJ1QjFtcHZx?=
 =?utf-8?B?MkFPd2RiYmFEbmZUWC9SVVV3ZjBmd1Y0YWdNaitMMTlnUUlSNkd5eGJKbXNr?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BD66A915BCF204D8C32215C50A3C321@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3965d635-d434-4809-c5be-08dc5e232fcf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 14:40:39.8674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zi31kMkpkcu/OmlxncjBVLkJ91khNr/nPxtLNauigxJP7H5UHth+oETIUWeA758LMgJya/kx0XUauL4spRtXhqOsel4SNb4D4YJmLEoCn3U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8200
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDE1OjA3IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20+DQo+IA0KPiBUaGUgZ3Vlc3QgbWVtb3J5IHBvcHVsYXRpb24gbG9naWMgd2lsbCBuZWVkIHRv
IGtub3cgd2hhdCBwYWdlIHNpemUgb3IgbGV2ZWwNCj4gKDRLLCAyTSwgLi4uKSBpcyBtYXBwZWQu
DQoNClREWCBuZWVkcyB0aGlzLCBidXQgZG8gdGhlIG5vcm1hbCBWTSB1c2VycyBuZWVkIHRvIGhh
dmUgaXQgZml4ZWQgdG8gNGs/IElzIGl0DQphY3R1YWxseSBnb29kPw0KDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KDQoNCg==

