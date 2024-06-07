Return-Path: <kvm+bounces-19098-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 70FDC900E17
	for <lists+kvm@lfdr.de>; Sat,  8 Jun 2024 00:31:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 157BD285C13
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2024 22:31:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58F86155723;
	Fri,  7 Jun 2024 22:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FPbtadeI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25EA114900C;
	Fri,  7 Jun 2024 22:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717799496; cv=fail; b=MqCC8tY6zq8khYtzralVCxEFKaBDOrxyJr7vP4Jn6I8cwH/a5dxT7DccW5hSwuIleqSNUFh62rGfsKS9U4glwMWOnqiTCBhTq4+hoG53W7FxCa6JQeOM+3plj7tOWIGEKxQvoQFo2xhvtrFTJXAwzAtwFLoF8sINRbemraqdEyY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717799496; c=relaxed/simple;
	bh=kz67uE7DldrY6eQ5+Z8tjiWapAUc9fYrBLVZdsFnKsU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=k7gZ9nzxfpDUz4smnstDCgQEKlaZYHBTHd5vtNcXzXkpzz64g+N+vsH+8+QRouJi+ZIDzfdOPT3yogEJ5NMKfoX2csrrDJd4vRq22Pn0fftjMdyJPOvsEnPB5ft18C98LLOF5H9RFN92OdpHrTtsr6Gx/OnI6fzFaafiSi04H6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FPbtadeI; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717799494; x=1749335494;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kz67uE7DldrY6eQ5+Z8tjiWapAUc9fYrBLVZdsFnKsU=;
  b=FPbtadeIFGpYd36h0B9SWtWnyb0cQmyHwu2wPmw4feppFFgEbjZE6C/3
   PCjdWOKaAo/qPOdGbd2ehUsJ5amLaHf/no6x6BGA1u4jiVJdIrYCrDIwB
   V3jgozBkfjYFJVGYxxzQVahWmZOE5IpP8k/McTO968AvCjWM/Xpo6QNqv
   YTqwgTVQRScOP7fFkhRHxHjqOXK00ccWMbgvomVTvSnE0G744cIlE4wA1
   ixcjGVtWQAEPUffE6X3hdMrvqVQzupMuGO27i1qEaADZ+9v718T+uEvKv
   8zVI6rDRfjWFam8Vitv9WzYqHWMp7xGSn7DEs/2LgX6BlOsrLv/T7T1OK
   w==;
X-CSE-ConnectionGUID: VPKllEerTVmMjdn2g66lUw==
X-CSE-MsgGUID: MylO5VThTC+Z8Vfa8Ai8yw==
X-IronPort-AV: E=McAfee;i="6600,9927,11096"; a="14280877"
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="14280877"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2024 15:31:33 -0700
X-CSE-ConnectionGUID: V8TuV/qbRTimpwH6pdvIWQ==
X-CSE-MsgGUID: 1EzOYmMETOeAmyTzKghb5g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,221,1712646000"; 
   d="scan'208";a="42904650"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa003.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jun 2024 15:31:35 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 15:31:33 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Fri, 7 Jun 2024 15:31:32 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Fri, 7 Jun 2024 15:31:32 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.45) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Fri, 7 Jun 2024 15:31:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a2U/4OHcUMuiJQckXvIc7Jkw7LIG28aiKpua53hup4rKarCXSdPrfRBcZnX3AK/O/A0Znbb6+fVZmMpn0iWlwN0sopTIJBwZOWpDTMBMYE8+J3xTMzneAz83OJKL2TQK3cbKG38HniPoNYEtgR+E/E+PY49/l6NMNyk2isLrnBS8yJZ6fMei4epSYugtOP7BUVM1wDXJ5cNQCabManQSeF1avosvTfrjueSWt4ofbI0FsFtxztcl31xlJ7o67QkmxovLGXteRpwlYoDNqVUwI7WyjzczigcizlqBglg0TV+w72gxuk1Rbr0TQkXDzGs3Xx0TLAc8Kkvaui+sJWu+Xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kz67uE7DldrY6eQ5+Z8tjiWapAUc9fYrBLVZdsFnKsU=;
 b=Oal/iI05vRCvKfWwDKU3S8JGMt9Ds4aJWv5+mHYMtDA/oUVtBuzRt1CkKI4HIB6EJbxkWj7DSRlpd/6w9FoP9o7I6aWnyKuz9sE2UmrAtjGQbV0FfYg9te2ciBOlRZLniFIW6HfXLpObyl62Pmf/HT46ml7C0tvJpsY5WJGUx7QD9mJ1MDdn976DquVhA3fketaOCTh7yeJXupYy+oUUBLvSXyqIST+tJbA7S+G3OB91ilmvp+i3ipoZ/m0lSxwsHTLdFPZzm81LTId6JFL7eMcjy4fmt4VLU/27sdc+pOJXzhDbcp2DfRAYRZ8eBH4kGGLeNcVeHr1krdABHYD2dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB5923.namprd11.prod.outlook.com (2603:10b6:806:23a::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.27; Fri, 7 Jun
 2024 22:31:30 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.7633.021; Fri, 7 Jun 2024
 22:31:29 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"seanjc@google.com" <seanjc@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"sagis@google.com" <sagis@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"Zhao, Yan Y" <yan.y.zhao@intel.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Yamahata, Isaku" <isaku.yamahata@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>
Subject: Re: [PATCH v2 14/15] KVM: x86/tdp_mmu: Invalidate correct roots
Thread-Topic: [PATCH v2 14/15] KVM: x86/tdp_mmu: Invalidate correct roots
Thread-Index: AQHastVtceP+irQAIE+yFKrHNk6O/rG8DXCAgADhxQA=
Date: Fri, 7 Jun 2024 22:31:29 +0000
Message-ID: <a6ae4f708482a91ab058a88754ab2ed2a8e0d5fe.camel@intel.com>
References: <20240530210714.364118-1-rick.p.edgecombe@intel.com>
	 <20240530210714.364118-15-rick.p.edgecombe@intel.com>
	 <CABgObfYL9uujoLTmSBW0LqoQbOGKpfZsB50BZqMo5_WOChrZ-A@mail.gmail.com>
In-Reply-To: <CABgObfYL9uujoLTmSBW0LqoQbOGKpfZsB50BZqMo5_WOChrZ-A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB5923:EE_
x-ms-office365-filtering-correlation-id: a5c79095-87cb-4e5f-6431-08dc8741934c
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?T21xMWNJZy9tYy9oRklKcXJqNFhlZW5zcUtvY2duUUNTOTJ5bUdqLzBxQnpM?=
 =?utf-8?B?eUZYNm5DRzhscyt6OFdJRzh5cmgxckpoNjMxeVJRc2pkME1DN0dRd3l1aUZ4?=
 =?utf-8?B?QzBReGNuS05BcVI4d0o3ME1MaHRBLytxQUJuMHprSElqZUtQZEpqSmVhcm9i?=
 =?utf-8?B?dHducEgrQVhsNnNmam90SjhBYzArYVY4OWJ2YlBoVmxyNEN5WHhBZ29iUk9R?=
 =?utf-8?B?djUyWkpoU2lxNWNrdzgwMHdmYkpmOE5sdmpscFNUVkU5b1lrODFZVHdZNCty?=
 =?utf-8?B?dkNIblNIcHZtaTJOSGVxUFFDREx3N2pWQTVIT293VStjbGQ4aU5qS0xtYmsy?=
 =?utf-8?B?cmN5OHNxWVp0dXFQYnNxVjRaaDNFek9ZUDd1aU5XK1BhY01SSTR2UG1xTGZw?=
 =?utf-8?B?VE1jYnhEbzNsaW91TE9QbFNOUHRUOVZwWDlEQTVFSFM0TXBkMStEdWVTRzBF?=
 =?utf-8?B?RG9wSC9XcXFKZDAwVUFSS2RJOW9xYitpdTVoeWRudFpwbDhuTkJNc0xwUGpi?=
 =?utf-8?B?eVpkNDZmRXZxQ2NLLzlSRWVPSVMrcHFFWDhEN1daNC96RXNvaFBRWi9WMXhK?=
 =?utf-8?B?L1JySmFzMHpESFYxTzJXTzM1QWI1aVFSN1RtTUhNMW9vU2FKQTNld1E0eUpP?=
 =?utf-8?B?TjkwL2QxWmxXbXU1amNycU80UnM5Y3UvbmRLS1NBYWVpNTYvb29sS0Y2NCtK?=
 =?utf-8?B?dWlZeGV6TmFjTkpYK2prbXRqeTlwd2ZhWko3TlJPT3BMOTlaSW5xUUtlTHNp?=
 =?utf-8?B?SG45NUpLa2Z2UlZhOEg4T0duMzhxZWlTUHZtUDFGLzR4M05KUUd3MWhndEpw?=
 =?utf-8?B?WEhQT1Yrdmwwak5ZUUJhOXdLL2l4UklsRlBKbXdTSUtCNjY0VjdIMkxuRTRt?=
 =?utf-8?B?RzNMaXJpZmtWL1BibGdudUNMeVFUTmJTQzdnN0ZDWW5acWxzeW5DVDdQZXht?=
 =?utf-8?B?MnZaWW1YYXRyckFRQWw3czZHRXlHZVZLOVh3S3FVc0l6all4cFY4Y3pkT2tQ?=
 =?utf-8?B?anRSN3djUHlKMnVjbU1LYktxTEdGTE0xdXBtNWRMTmxhODArRDRDUDZiOE1E?=
 =?utf-8?B?MUtsNVpsWGVmUmNBTVpZY1FSZlY0bXAwYmF4QVV6SlYxSVQ1NmIyOC9nNzdO?=
 =?utf-8?B?d2x3RlgwSGFkYk1jYXg1UDdHK0FZVEdienFMb2xlQnZIQ0xQWXhjMEtUUVgy?=
 =?utf-8?B?YTVEUFU2Y2dIRW5wMDdydVg3NzZiNHhTUXJWS0xkNitKRFBxWGtVN3JHRXlr?=
 =?utf-8?B?dU9Wekd6Sm9BN3N2bTN3U3VTMjhGaFZGYlRKSHJ0Qkc4c0NYY0k3NGp5d201?=
 =?utf-8?B?SDRjakVidDgwTG40MlRXY1VPVUxjS3FpTUk5MFRnWUZzdC9zOUZSWUwzS2tI?=
 =?utf-8?B?OHFjMlhVY1l5ZmF6RTdkcm1DbkM4UVcxa0U5djdSRWhEVllFcUR0NWtxWFhH?=
 =?utf-8?B?VGtiaXV3bCtxcDdaNkg2TUdpUFdmQ25mWTYwQmV6NHY0K3krR1ZFK3NTZFJE?=
 =?utf-8?B?T3dtNHV6R0c5Qk9rMk5tWVZnSWN3MGZSNFdKMXZWcGtoK25hZDFkbVd2VzlX?=
 =?utf-8?B?NkVoRFNscEY1SDJTMWwxalRmZWVUNTI1RHNHMTZJcnloaVF1dVhubFpQL0dQ?=
 =?utf-8?B?NGU3OWxJU2xFWFhHNklmbjlJWXI1ZXJHQzNBSnlrQ2JVc05qMndlWk50eTdz?=
 =?utf-8?B?RldXajc5SDRDVGxSR0gyaStsOHlpMUZzaUdXQ1J3bzdwWDFqbzJvczJZcm5T?=
 =?utf-8?B?NzEyODVhN2FIazUvbGdURlh6ZXZpbjRBaURsOTVLZHBJK2lrbFhqWW1sT2pF?=
 =?utf-8?Q?XoarBpi4mXcsh9M5Tyae3Kt95X8Stf9LWMGKs=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bHVXUmd6em1WUVhGaVRRN1BMblNMNDNONDlIQnhRZGtwejBpejFpQzJ5azBL?=
 =?utf-8?B?bGR5RFVjc3ovaVZTNTNyaDNPcVllalRvN25CUElCc0FsRFB1cGVYSXZmS2dY?=
 =?utf-8?B?MEhwNVNOeU9hTW0rT2NqZmpWK1hRRnpYcWx6bG1xRGdIZlZCRzJ4SElQM1dz?=
 =?utf-8?B?ZzFFNFZ1WEw2VjA5alFGSDNGUExsZ243bEd2OGJVdlZ3bERSTHVZZThMZVBK?=
 =?utf-8?B?LzlnaXBwQThicnRmby84eEhQWW9EYVBKdkwrMG5jNmNXVXRVbzFwZ2VoKzlw?=
 =?utf-8?B?WHd2bjI3QWVOSE1DMHVkMDdXZ3ljeWtiUFJFckZ6bGVUQk82OFZMUXZHV0E3?=
 =?utf-8?B?cDhQcnBwWlJQM2MxcmszcW96V0s0R3p6a2RodVZTQ29kYkljQS9YbElVTlFM?=
 =?utf-8?B?Y2R5dkVldmE5MjAyQ3ZzNUV1eC9LWndGeEhUMkQ4L09WNWU4SjQyS1JVN2xX?=
 =?utf-8?B?QU83Q0hLZUI0aXFSZGUyUlFhRFdYdnZyTG5HVXhkdXN0MDNnYTJXeUMvbzll?=
 =?utf-8?B?M0dodkhHbEhKY3g3bXZaVnBIdDVXYlNkWmRBR01ST0pBeE4rY2lOUkxDL2VB?=
 =?utf-8?B?cmJoTFo0c2RreklCSTJnZHZlcHhFWTdpd09QaDRiVnN6cHI5R1dadkhUUG5n?=
 =?utf-8?B?UmpqR1hHVkduUXFNbGhNaWhYYlQ0SmZacWFLOGsvekM5cytqeXJuZXdPcVZU?=
 =?utf-8?B?RHNJV3NpSUoyaEdLMHRkdTdHeUtLSUZ3cC9JSTh6Mm9BYUFHN0pEVDRlbG9P?=
 =?utf-8?B?N1NZcjNFU3BneGg2WHorSERrM2tzQzFDNEdaTUpVQU5BVC9OaTAvd2wxdi8v?=
 =?utf-8?B?UmpJOHBmS3dpcFZzQXBoeTE4Q2xlUmNpaEk0M3J4c3A5aDJONHhYQVY3WS8z?=
 =?utf-8?B?OFJsdEdnMUFqRFBQRVV1dUNmN2RIZnhhRkMxMERpSUoxTkZzZVBvaWpZMmxH?=
 =?utf-8?B?VDN0QjdlUG5rbXdoN3FlREVYMXFicE9qc1FlbVprcXZ6c0JMeGt1QU5HbzZ1?=
 =?utf-8?B?SmdxZHFJU2V5N1IrWjh3N3ptdnRpSDFmbHg1UzdUeDJOc1VXTVpEWUtmSjVW?=
 =?utf-8?B?cVRxWEVpQW9aTzhuODVCbEd4SS9DV241YVg1dGlUbWx0emZpR3NseEpFTHgy?=
 =?utf-8?B?cG40OWZBTzZQeW9PWWpmOEEvY2RqSUZwU0xISVNmcmlhYXNBMmM3dFljanJY?=
 =?utf-8?B?K1BYaUovTmJSbEZPaEFzcDZEQXRpMklXakVYR1ErSnN1QVJIWUpNa1pJNElJ?=
 =?utf-8?B?UzVBelVqeU9vdVdhbDE5dHoxbXdaV1d0SCtZOXZqK3ZwemxCakE1dU1zTG9w?=
 =?utf-8?B?MDVBbXNHeW5UcjlVNDRhMzVtNDBvbU5RMFBvcllqcHZMVXNHN2JCR3dMYVVq?=
 =?utf-8?B?Zm5PRE0zNjJUaE5rR1JxSURySXZqNzgyUWRhZkpqQXhiZ3piTTVCVTFlanJV?=
 =?utf-8?B?MDUyQ2lnNjFEUUpRdXM1NHBPOU9ESHRvenNTTitieEs0aEY3N3lSOEpsMW05?=
 =?utf-8?B?RzdHTnEzeEdJbUFWbHFsOWtZcEhwaTJuSS9WYzk2RE9GZW4xa3Z5SWM1Y1lK?=
 =?utf-8?B?TWxLelVnQzUvL0ZiLy84VkpnenN1bjdBMTlJRnVGM2tORGJQYm1OaWIzelFG?=
 =?utf-8?B?N3pndXpDN2dSMlVrMGRUYnZiSlpER3JmcEJxNE85Q0RaZDdqLzc3N003UitH?=
 =?utf-8?B?UElNYnhoSFVNWSs1L0JwTDBKSVBRZkpKYXU2RHNreEtERUJJTWN5WDQxVGpO?=
 =?utf-8?B?b0Evb1d0QjZZR0lrSkJWZnI1QUJPOW5ST0ZOZjdMRjdRTmtlako1ZWQzNm55?=
 =?utf-8?B?d2NjRTVpZjFXeS9DM3ZtbzcxV2hBZzNWMjRoUkRPQWNHOHJCc1FWRUxTTmJU?=
 =?utf-8?B?QVpaYm5YQzdRWkV3bWlWdFJTeDgzNnM4V3dwVC8xcTJrSDNhbkZvS3M2VEp0?=
 =?utf-8?B?ZXFXOVlsRk9KUUJaT25ySkFUMVF4eTlRL3pzZUc4VExNTnBFVC9RcTgxWWFw?=
 =?utf-8?B?MGVnMXRReitDQjk5Y2xvU1RnanJHempMaDJGWEdrS0c1d25nRDIvODhRS25V?=
 =?utf-8?B?bmp0MU13c1lXWHpWMjFJRWJweE9MWHVaTDdtaG9Yd080ZWhjSisyeFB5dVVi?=
 =?utf-8?B?dEtXK3lnTnJBM0hSblRISytKWmJVeUl0VXpkTm8xS09jcXpPWG1VZjFoQjhQ?=
 =?utf-8?Q?kZoiyIWQsdBCVfJtRY0MxIk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <12FFD9E1224F24469B9F59E7B84009AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5c79095-87cb-4e5f-6431-08dc8741934c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2024 22:31:29.3190
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1MOMsGBv6MZuyXl7u/hvQo1uF7lTljwPhoab8uBylHbsRMFhjIfbmU1wcgbdONupDgFP05s9vUdzMZTsBSh5zs4Yg2Xl5DRQORFF+n/QUoE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB5923
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA2LTA3IGF0IDExOjAzICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiBUaHUsIE1heSAzMCwgMjAyNCBhdCAxMTowN+KAr1BNIFJpY2sgRWRnZWNvbWJlDQo+IDxy
aWNrLnAuZWRnZWNvbWJlQGludGVsLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gRnJvbTogU2VhbiBD
aHJpc3RvcGhlcnNvbiA8c2Vhbi5qLmNocmlzdG9waGVyc29uQGludGVsLmNvbT4NCj4gPiANCj4g
PiBXaGVuIGludmFsaWRhdGluZyByb290cywgcmVzcGVjdCB0aGUgcm9vdCB0eXBlIHBhc3NlZC4N
Cj4gPiANCj4gPiBrdm1fdGRwX21tdV9pbnZhbGlkYXRlX3Jvb3RzKCkgaXMgY2FsbGVkIHdpdGgg
ZGlmZmVyZW50IHJvb3QgdHlwZXMuIEZvcg0KPiA+IGt2bV9tbXVfemFwX2FsbF9mYXN0KCkgaXQg
b25seSBvcGVyYXRlcyBvbiBzaGFyZWQgcm9vdHMuIEJ1dCB3aGVuIHRlYXJpbmcNCj4gPiBkb3du
IGEgVk0gaXQgbmVlZHMgdG8gaW52YWxpZGF0ZSBhbGwgcm9vdHMuIENoZWNrIHRoZSByb290IHR5
cGUgaW4gcm9vdA0KPiA+IGl0ZXJhdG9yLg0KPiANCj4gVGhpcyBwYXRjaCBhbmQgcGF0Y2ggMTIg
YXJlIHNtYWxsIGVub3VnaCB0aGF0IHRoZXkgY2FuIGJlIG1lcmdlZC4NCg0KU3VyZS4NCg0KPiAN
Cj4gPiBAQCAtMTEzNSw2ICsxMTM1LDcgQEAgdm9pZCBrdm1fdGRwX21tdV96YXBfaW52YWxpZGF0
ZWRfcm9vdHMoc3RydWN0IGt2bQ0KPiA+ICprdm0pDQo+ID4gwqAgdm9pZCBrdm1fdGRwX21tdV9p
bnZhbGlkYXRlX3Jvb3RzKHN0cnVjdCBrdm0gKmt2bSwNCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBlbnVtIGt2
bV9wcm9jZXNzIHByb2Nlc3NfdHlwZXMpDQo+ID4gwqAgew0KPiA+ICvCoMKgwqDCoMKgwqAgZW51
bSBrdm1fdGRwX21tdV9yb290X3R5cGVzIHJvb3RfdHlwZXMgPQ0KPiA+IGt2bV9wcm9jZXNzX3Rv
X3Jvb3RfdHlwZXMoa3ZtLCBwcm9jZXNzX3R5cGVzKTsNCj4gDQo+IE1heWJlIHBhc3MgZGlyZWN0
bHkgZW51bSBrdm1fdGRwX21tdV9yb290X3R5cGVzPw0KPiANCj4gTG9va2luZyBhdCBwYXRjaCAx
MjoNCj4gDQo+ICsgLyoNCj4gKyAqIFRoZSBwcml2YXRlIHBhZ2UgdGFibGVzIGRvZXNuJ3Qgc3Vw
cG9ydCBmYXN0IHphcHBpbmcuwqAgVGhlDQo+ICsgKiBjYWxsZXIgc2hvdWxkIGhhbmRsZSBpdCBi
eSBvdGhlciB3YXkuDQo+ICsgKi8NCj4gKyBrdm1fdGRwX21tdV9pbnZhbGlkYXRlX3Jvb3RzKGt2
bSwgS1ZNX1BST0NFU1NfU0hBUkVEKTsNCj4gDQo+IG5vdyB0aGF0IHdlIGhhdmUgc2VwYXJhdGVk
IHByaXZhdGUtbmVzcyBhbmQgZXh0ZXJuYWwtbmVzcywgaXQgc291bmRzDQo+IG11Y2ggYmV0dGVy
IHRvIHdyaXRlOg0KPiANCj4gLyoNCj4gwqAqIEV4dGVybmFsIHBhZ2UgdGFibGVzIGRvbid0IHN1
cHBvcnQgZmFzdCB6YXBwaW5nLCB0aGVyZWZvcmUNCj4gwqAqIHRoZWlyIG1pcnJvcnMgbXVzdCBi
ZSBpbnZhbGlkYXRlZCBzZXBhcmF0ZWx5IGJ5IHRoZSBjYWxsZXIuDQo+IMKgKi8NCj4ga3ZtX3Rk
cF9tbXVfaW52YWxpZGF0ZV9yb290cyhrdm0sIEtWTV9ESVJFQ1RfUk9PVFMpOw0KPiANCj4gd2hp
bGUga3ZtX21tdV91bmluaXRfdGRwX21tdSgpIGNhbiBwYXNzIEtWTV9BTllfUk9PVFMuIEl0IG1h
eSBhbHNvIGJlDQo+IHdvcnRoIGFkZGluZyBhbg0KPiANCj4gaWYgKFdBUk5fT05fT05DRShyb290
X3R5cGVzICYgS1ZNX0lOVkFMSURfUk9PVFMpKQ0KPiDCoCByb290X3R5cGVzICY9IH5LVk1fSU5W
QUxJRF9ST09UUzsNCj4gDQo+IHRvIGRvY3VtZW50IHRoZSBpbnZhcmlhbnRzLg0KDQpZZXMsIEkg
YWdyZWUgdGFraW5nIHRoZSBrdm1fdGRwX21tdV9yb290X3R5cGVzIGVudW0gaGVyZSBtYWtlcyBt
b3JlIHNlbnNlLg0KRXNwZWNpYWxseSB3aXRoIHRoYXQgY29tbWVudCB5b3Ugd3JvdGUuDQoNClRo
YW5rcy4NCg==

