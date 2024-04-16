Return-Path: <kvm+bounces-14780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 614228A6E7D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 16:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3CD351C229FB
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 14:37:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A969712E1F7;
	Tue, 16 Apr 2024 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Dw6xXEV6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0231E494;
	Tue, 16 Apr 2024 14:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713278199; cv=fail; b=bpbGVd09IJuGvVthZom1OXOhGKzZiSl6tOBoY/ECFHzfHvYx6rBP0BlUw7de7nsuwVhbl7kDk0xQBEQLiRuMKGJ2rZ3wWNJNbvF0e33xEoD+UG2SKIaZmL/2T9aJZeJ0GJwkjRmv01l4FpGEfKwuTPK6HGAhbrEr42x2N/tgTAQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713278199; c=relaxed/simple;
	bh=gWKvFHzpkINCGzF1fOqH4THVpo8yh1K5yld6Jjy+hhM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AJ+vIw+rzsVz90Yzoywk0QBg9VIIY5tVvGMRyup2Wqr+9TqNYRD/RNGIQeNcGUkYjN9Z2CnIpNk2E0ocJQx0D7RE8pv8BQ8HiQxWw8q9bSDQ5gFZvbUsw/RxglBdlP1EqWjpslnTjdByHEQWhUxzLysaa+qsR0R1ArnS1SIoL2s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Dw6xXEV6; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713278198; x=1744814198;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gWKvFHzpkINCGzF1fOqH4THVpo8yh1K5yld6Jjy+hhM=;
  b=Dw6xXEV6R5NjxI7VN/2TP2f9tVSL/hLIqdE+1fdz5hu87ysN4Dzbt/LQ
   saLDIArAdsus+hryQipOeCgCDYW9BWWUb3LBgtj6ONjYyGkquioaVY8m7
   ec9FZETH6/Ac57HvfRvZNEdc3MdBpL9Mt6nWUVvVopzglCiPeG98yCeMm
   xBPLtZHUnEoRL1MPMXAZ/Clg3yZCbstoQARkAdWjX/NuDr+l2MpWYy34F
   s2ZhxAJN5sEw13onTFOXbzvwd6JXGcq8m7FN704aphNWgSqTik8jGWY6C
   yE2MBGUE71aZ8vx5/2Ngg61WsOART5KvRDx8w7+elo5ucJXgyQyVw3HU7
   A==;
X-CSE-ConnectionGUID: /S5VhSioQB+CGkKSAnvsAw==
X-CSE-MsgGUID: 2RMrApLzRWSpXxN3J63klQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8597190"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="8597190"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 07:36:37 -0700
X-CSE-ConnectionGUID: d5LDOJB9RLubXJP1AgHPeQ==
X-CSE-MsgGUID: ZzYfRV7sQRSwV5SjMvbRdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="22346436"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 07:36:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 07:36:36 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 07:36:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 07:36:36 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 07:36:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dru0XMNI2wm6wN7uDYw0iMtrzLBPeyxwGQ15I6ishjyilS9VQmUgG3/DCOtuHLvBgnPvdg+hoVo6vPrR66zSfNqyHIt+sR0iEB1PSecV67M58pJB7toFtkAf5wNqoxfIPEvS9u2ZflHusTAwKus1rQiXFvMsCEQg2O6X2WgFgt9QzGqfXjpcPfbmlw5hCIhe+aQzEVv1XhoCd2yj7YOfW7KkXOcxUv0j7lZ9wBOyIQLhTFpP+x+i+/43/pfAcYRj3X/OcWLnkNGNv0onX333qJgQ0GeveOF2QFN6BMhRHgnY7KSe6C071+zaRudytMY97eKgp3B3fP8A+9OvYe2fCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gWKvFHzpkINCGzF1fOqH4THVpo8yh1K5yld6Jjy+hhM=;
 b=I7PHcad79uBPnJeiKLyywJupgAbIy9AnfsuPe/a6itlE9yfIzwfJ1Enp+WAUxYAKBdNOsHk18yJXXVYTPWBJsAuFajffoTMUwnyrY+kUOptBX7xqTPyPdCgxSZcA2iGpfOCuqnayA1SEsiAwQKta1ZxRv8eoVvwHrxwsF15Eg7adKS1glAPimihnIDiL5sdjdXfk+QdQOFPhH1vSsnnkjrGE9CjTC6V6QjcEe+Tsyx42FTyPsTPhLt+64GXmwhOAWh9D7koxMP8RTqZT6ZpLeWr9q4kk+9dYk7oZu0qkqMTxiCmWOD/gwVdsj8Oe3o71zn7qpXJd5DRYJrMiTHvj2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB5890.namprd11.prod.outlook.com (2603:10b6:303:188::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.29; Tue, 16 Apr
 2024 14:36:32 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 14:36:31 +0000
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
Subject: Re: [PATCH v2 03/10] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
Thread-Topic: [PATCH v2 03/10] KVM: x86/mmu: Extract __kvm_mmu_do_page_fault()
Thread-Index: AQHaj4x9MM2Dpk9SIU+jskAL42XDprFq99cA
Date: Tue, 16 Apr 2024 14:36:31 +0000
Message-ID: <621c260399a05338ba6d034e275e19714ad3665c.camel@intel.com>
References: <cover.1712785629.git.isaku.yamahata@intel.com>
	 <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
In-Reply-To: <ddf1d98420f562707b11e12c416cce8fdb986bb1.1712785629.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB5890:EE_
x-ms-office365-filtering-correlation-id: 627bbb8b-b06a-4650-19f3-08dc5e229c00
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HfV/avzMUHYYg6CbOsf2hqTPP0AJpO0HT3HOBPpWxBt6nKNSGgJ90bsS2sXrzVi4RkUWnwfeDCK1cOrtfStbgkLrtOPbPWoI21LymmONLC+1FZhqOIFuodMJKBr6iHULvV73g99taH/l6KAnCNbyPNpYPiAuG1/nN1VlSw39CQFv74CKcKIaZanj1VEuQSzTHC4d1CgNN6T1btbEhEoPID6KUlSIgnDXOzzbrzgO25Gsr7T9p4YpfOP0fQRain+zRufcI/m3/M2pU/z1ZOEUzN89+eDZXB98Wn0vmGORrre2gmNoqnxZZUeTPzQ2nYY2TEQqG5hKFUXYgwRSyZ3Yz+0l/tJQnJR1/b81v+VuYYVXUyKbg/6R58LSZoF6rUfrIg/3Y+L/cGCsAqUVziOZWcKLSs0ZXN6KN0ZkVwS4aD1nAvqeYCmE21v/BnmlsMVbBnrQfT0oycC89XpBZ35tOgA/I09A1gkKapN9Wrdr3czMXangymnr66DrUu2GTg37o9mqYslOH+ns5X/O8VqIiFXl92v8N2GHPzVR9LPrh1pmEPtuGdwLzbed7K4hSf+odJ/Tmwayfs8luQOeYHVrfrj5kV5LJmW7fOtk6N7rEpjspu8FSbzzrKOFEReMDT5A99za32f+n81rSBZl3WqjIBVrnrSMYHHeYcoEFMEhb7gRzjcQnOQPfahhagZ8x4UN/C5CiddSEEpj9eRITa0k+aFRd5r2w66onKAzel+uYtc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWNNMitQRHNncURnMVB2RFlwMnc4ditYRUlDZEpnQXRIZFB5N0tDK2JtK3lY?=
 =?utf-8?B?RHRzZ3ZrS2dCbXJEVjFXZncwR2J3SFpPaXV2OTJHeVgzV2hUNUd1ZUZ5YXFs?=
 =?utf-8?B?ZjlJck9aYnZSU29ucHhMeW5Ea0lXVm05ZjlMWmxTeUtra3NTTHRySUcrQUZw?=
 =?utf-8?B?dlBYL3UxbGpXekx5Wk5xUVNENVZRei9jdmRwMytwRnN0Z2RJNE5mcHhhSjZU?=
 =?utf-8?B?T1QxTjJmYyttdjdJMW9YcWhZc2dzRVhBUWZIdTV4T1JwQUZjSG00dGJWYXVq?=
 =?utf-8?B?SnFHb3N4TnpuVlpLd2Ewd3BLTG93R3Y5TEliR1lBYTZzNHhPaUdkeXBtUU8y?=
 =?utf-8?B?TU00ZElEWWExZ2pDSmxnMnNEa0dOdnEvVFluZTJ6cTBYVGltdUtXNUtkZFlS?=
 =?utf-8?B?OUlSczBMYW9XVjRpaGZsUUJ5dVQ0ZXJIUWoxYzJlWHN2Z205bW9rdDQ3eFlH?=
 =?utf-8?B?Y21BWGNvcHh2Skp0azJPeE04SzRNcUNwL2MxQ09sRlBmMndRMnc0Z081ZW4v?=
 =?utf-8?B?TjlrM1N4SkN6MVV0eU04d010NXE3V2x3aHYzV0R6MkZnaFgwSmR6QUIwYVhz?=
 =?utf-8?B?b2k2bm45YXJuZ0lRNGFxdTVmYVh0c21lY0U4ZTNnMzZoVnZHK005YWNPUDRX?=
 =?utf-8?B?ZjJWdXBTeEMxb3o5NUx5M3VKK3lac1czb1IwOHpBMHpCdXcvaVlkZ2ZXVW5I?=
 =?utf-8?B?ZGRMN0ZYUnhEbkV6SnlOaS9ZeW1VK0hvQzZjTkVORkxGU0N0WmZ4S2pwWml4?=
 =?utf-8?B?TGc5OTFWOWU3ZkhKeXhYb1ZFVlZWb3N4MjN6ejA1TFRBdDcrK1FPTHRoUlh3?=
 =?utf-8?B?Q0ppOFcwaUFqem9lQjUxNW9GSkxSWnVEZk1Kd1hURGlpRzlFZk85ZWZLWHJv?=
 =?utf-8?B?K0ZqTEY5WDNNbVJaWjRSODhCb1hIMXVRZGRwcDQ2UTNFUUZVRTRnTHJiUFdn?=
 =?utf-8?B?ZGNKUk0waDVaR1NjVXJyQkQrUkRaZTBiZUhzNzZiL0g0aVVmNDBSSmNibktV?=
 =?utf-8?B?RU9yRTdZSUJJYTB3Ni9IeERGR2NvQ1dCbnRNZTA5VkIwbjZHREZLTitaalBY?=
 =?utf-8?B?TDRXYThadUlyaHNGdlFUakFnRHN3SHJNaXVHdENvSkE5SkF5SW1ncTh4Wldw?=
 =?utf-8?B?cFJPSFVWQTVodU1nUk1IN1NmbnByOHhoMzlraGc5ajB3Vm1ncC9IRitMakhQ?=
 =?utf-8?B?NTRYdWhYbXBKTkE0QmppdllNcXdUODBHWVYzdzhZMUt4Tkt1cXNzekVFNFlU?=
 =?utf-8?B?UDlnVWdKQkt4SHoxZTJjK1c2YzVhRGlEb1RkVVBPRU1SbEM4MWFZMzVFUWh0?=
 =?utf-8?B?OHZUd29wRlQwR1cyeEV1RTU1c2dtcHUwYmhNVmlSQ2ZUVHFDTW5tc1BmUWx3?=
 =?utf-8?B?bTRlQ21MK211ODdQb1lkekE2UmR4d0tqS3FmaFN6dzBJUVRHdVZhdWJUa3pM?=
 =?utf-8?B?OXZVRHNTQmpyRkpPd0drWWlwYmtLWElnQnJmR3EvSnpmSzdpa1VnZEtJSU1N?=
 =?utf-8?B?MXZKV0J0eXIzYlp1WWNmMFA2QnVQS3N4T2tqTWVYQW41VmlIakltM2RkYjZr?=
 =?utf-8?B?UytBcUpSblluUDVCZ0hzRzR5M3MyTGNUMW1MckE2ZU85RUdaTWhXKytSWi9M?=
 =?utf-8?B?ZHEzQmp4bTlINHRXQU9QQ1lLbXNjYzFNQmJEcWVENUdLa0J0M2JmYmlWRFBW?=
 =?utf-8?B?UnJxZ243YjBvZDN4YzdJaUorNVV1bFZTc1cvNVJ4cDQzbEVvQ0kwb1JDMHBF?=
 =?utf-8?B?UWRPL0xMQ1QyY1F0elBCSHluWU4vTkRlU0VVcFlwQVZnZURoNFJhZ3lneHlH?=
 =?utf-8?B?YWRObEtobzdsUVNRVlhMVEV1OFM2citKR2FMbXlFbUFDMHFHOFY2VXY1WXZu?=
 =?utf-8?B?U2ZSMUIxRmR1cEt3NXdNdW9KMmFpdW9PUUJ0QmZwOVhWRE1UUTU0cnpMVXhU?=
 =?utf-8?B?QmxUT1d2eXY2d2JMZ2puTkFaMjN1ZjhFNUtGcHlKS2owaHBQY2k4ZmZ1WTRR?=
 =?utf-8?B?bGtFK0VvcFVkWG8zR1NDOFVZQktrSzNMNXZXSjVLV3RqOWFLWmJ1bFEzN1hG?=
 =?utf-8?B?L0xHSUgyeksxZWhSWTljTXcxT3p3UW81aGRmMGJ3MWoyUmRMeW9rWlhVcGt6?=
 =?utf-8?B?cWZ3VmVUanJGZlNQNWs1aEJBQlVTdE9KUkk4TExHMHhDYkJKSVNPcGp0REtB?=
 =?utf-8?B?SkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8FBC21001282A74CB4A428E3BBF30742@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 627bbb8b-b06a-4650-19f3-08dc5e229c00
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 14:36:31.8324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kOOkww6L/WQOdmnE/B2mu9M7Rg9MA8M1AWUabmoDO7DustDyg7MIROZRhYC2yMHMPJPEBdyz6kz2i9EhFHakSvE17Bv4j98vDnUCuCEaVU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5890
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA0LTEwIGF0IDE1OjA3IC0wNzAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6Cj4gRnJvbTogSXNha3UgWWFtYWhhdGEgPGlzYWt1LnlhbWFoYXRhQGludGVsLmNv
bT4KPiAKPiBFeHRyYWN0IG91dCBfX2t2bV9tbXVfZG9fcGFnZV9mYXVsdCgpIGZyb20ga3ZtX21t
dV9kb19wYWdlX2ZhdWx0KCkuwqAgVGhlCj4gaW5uZXIgZnVuY3Rpb24gaXMgdG8gaW5pdGlhbGl6
ZSBzdHJ1Y3Qga3ZtX3BhZ2VfZmF1bHQgYW5kIHRvIGNhbGwgdGhlIGZhdWx0Cj4gaGFuZGxlciwg
YW5kIHRoZSBvdXRlciBmdW5jdGlvbiBoYW5kbGVzIHVwZGF0aW5nIHN0YXRzIGFuZCBjb252ZXJ0
aW5nCj4gcmV0dXJuIGNvZGUuwqAgS1ZNX01BUF9NRU1PUlkgd2lsbCBjYWxsIHRoZSBLVk0gcGFn
ZSBmYXVsdCBoYW5kbGVyLgo+IAo+IFRoaXMgcGF0Y2ggbWFrZXMgdGhlIGVtdWxhdGlvbl90eXBl
IGFsd2F5cyBzZXQgaXJyZWxldmFudCB0byB0aGUgcmV0dXJuCiAgICAgICAgICAgYSBjb21tYSB3
b3VsZCBoZWxwIHBhcnNlIHRoaXMgYmV0dGVyIF4KPiBjb2RlLgoKPiDCoCBrdm1fbW11X3BhZ2Vf
ZmF1bHQoKSBpcyB0aGUgb25seSBjYWxsZXIgb2Yga3ZtX21tdV9kb19wYWdlX2ZhdWx0KCksCgpO
b3QgdGVjaG5pY2FsbHkgY29ycmVjdCwgdGhlcmUgYXJlIG90aGVyIGNhbGxlcnMgdGhhdCBwYXNz
IE5VTEwgZm9yCmVtdWxhdGlvbl90eXBlLgoKPiBhbmQgcmVmZXJlbmNlcyB0aGUgdmFsdWUgb25s
eSB3aGVuIFBGX1JFVF9FTVVMQVRFIGlzIHJldHVybmVkLsKgIFRoZXJlZm9yZSwKPiB0aGlzIGFk
anVzdG1lbnQgZG9lc24ndCBhZmZlY3QgZnVuY3Rpb25hbGl0eS4KCklzIHRoZXJlIGEgcHJvYmxl
bSB3aXRoIGRyb3BwaW5nIHRoZSBhcmd1bWVudCB0aGVuPwoKPiAKPiBObyBmdW5jdGlvbmFsIGNo
YW5nZSBpbnRlbmRlZC4KCkNhbiB3ZSBub3QgdXNlIHRoZSAiaW50ZW5kZWQiPyBJdCBzb3VuZHMg
bGlrZSBoZWRnaW5nIGZvciBleGN1c2VzLgoKPiAKPiBTdWdnZXN0ZWQtYnk6IFNlYW4gQ2hyaXN0
b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPgo+IFNpZ25lZC1vZmYtYnk6IElzYWt1IFlhbWFo
YXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+Cj4gLS0tCj4gdjI6Cj4gLSBOZXdseSBpbnRy
b2R1Y2VkLiAoU2VhbikKPiAtLS0KPiDCoGFyY2gveDg2L2t2bS9tbXUvbW11X2ludGVybmFsLmgg
fCAzMiArKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQo+IMKgMSBmaWxlIGNoYW5nZWQs
IDIxIGluc2VydGlvbnMoKyksIDExIGRlbGV0aW9ucygtKQo+IAo+IGRpZmYgLS1naXQgYS9hcmNo
L3g4Ni9rdm0vbW11L21tdV9pbnRlcm5hbC5oIGIvYXJjaC94ODYva3ZtL21tdS9tbXVfaW50ZXJu
YWwuaAo+IGluZGV4IGU2OGE2MDk3NGNmNC4uOWJhYWU2YzIyM2VlIDEwMDY0NAo+IC0tLSBhL2Fy
Y2gveDg2L2t2bS9tbXUvbW11X2ludGVybmFsLmgKPiArKysgYi9hcmNoL3g4Ni9rdm0vbW11L21t
dV9pbnRlcm5hbC5oCj4gQEAgLTI4Nyw4ICsyODcsOCBAQCBzdGF0aWMgaW5saW5lIHZvaWQKPiBr
dm1fbW11X3ByZXBhcmVfbWVtb3J5X2ZhdWx0X2V4aXQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LAo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgIGZhdWx0LT5pc19wcml2YXRlKTsKPiDCoH0KPiDCoAo+IC1zdGF0
aWMgaW5saW5lIGludCBrdm1fbW11X2RvX3BhZ2VfZmF1bHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1
LCBncGFfdAo+IGNyMl9vcl9ncGEsCj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHU2NCBlcnIsIGJv
b2wgcHJlZmV0Y2gsIGludAo+ICplbXVsYXRpb25fdHlwZSkKPiArc3RhdGljIGlubGluZSBpbnQg
X19rdm1fbW11X2RvX3BhZ2VfZmF1bHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBncGFfdAo+IGNy
Ml9vcl9ncGEsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHU2NCBlcnIsIGJvb2wgcHJlZmV0
Y2gsIGludAo+ICplbXVsYXRpb25fdHlwZSkKPiDCoHsKPiDCoMKgwqDCoMKgwqDCoMKgc3RydWN0
IGt2bV9wYWdlX2ZhdWx0IGZhdWx0ID0gewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgLmFkZHIgPSBjcjJfb3JfZ3BhLAo+IEBAIC0zMTgsMTQgKzMxOCw2IEBAIHN0YXRpYyBpbmxp
bmUgaW50IGt2bV9tbXVfZG9fcGFnZV9mYXVsdChzdHJ1Y3Qga3ZtX3ZjcHUKPiAqdmNwdSwgZ3Bh
X3QgY3IyX29yX2dwYSwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGZhdWx0LnNs
b3QgPSBrdm1fdmNwdV9nZm5fdG9fbWVtc2xvdCh2Y3B1LCBmYXVsdC5nZm4pOwo+IMKgwqDCoMKg
wqDCoMKgwqB9Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqAvKgo+IC3CoMKgwqDCoMKgwqDCoCAqIEFz
eW5jICNQRiAiZmF1bHRzIiwgYS5rLmEuIHByZWZldGNoIGZhdWx0cywgYXJlIG5vdCBmYXVsdHMg
ZnJvbSB0aGUKPiAtwqDCoMKgwqDCoMKgwqAgKiBndWVzdCBwZXJzcGVjdGl2ZSBhbmQgaGF2ZSBh
bHJlYWR5IGJlZW4gY291bnRlZCBhdCB0aGUgdGltZSBvZiB0aGUKPiAtwqDCoMKgwqDCoMKgwqAg
KiBvcmlnaW5hbCBmYXVsdC4KPiAtwqDCoMKgwqDCoMKgwqAgKi8KPiAtwqDCoMKgwqDCoMKgwqBp
ZiAoIXByZWZldGNoKQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB2Y3B1LT5zdGF0
LnBmX3Rha2VuKys7Cj4gLQo+IMKgwqDCoMKgwqDCoMKgwqBpZiAoSVNfRU5BQkxFRChDT05GSUdf
TUlUSUdBVElPTl9SRVRQT0xJTkUpICYmIGZhdWx0LmlzX3RkcCkKPiDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoHIgPSBrdm1fdGRwX3BhZ2VfZmF1bHQodmNwdSwgJmZhdWx0KTsKPiDC
oMKgwqDCoMKgwqDCoMKgZWxzZQo+IEBAIC0zMzMsMTIgKzMyNSwzMCBAQCBzdGF0aWMgaW5saW5l
IGludCBrdm1fbW11X2RvX3BhZ2VfZmF1bHQoc3RydWN0IGt2bV92Y3B1Cj4gKnZjcHUsIGdwYV90
IGNyMl9vcl9ncGEsCj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHIgPT0gUkVUX1BGX0VNVUxB
VEUgJiYgZmF1bHQuaXNfcHJpdmF0ZSkgewo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKga3ZtX21tdV9wcmVwYXJlX21lbW9yeV9mYXVsdF9leGl0KHZjcHUsICZmYXVsdCk7Cj4gLcKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHJldHVybiAtRUZBVUxUOwo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqByID0gLUVGQVVMVDsKPiDCoMKgwqDCoMKgwqDCoMKgfQo+IMKg
Cj4gwqDCoMKgwqDCoMKgwqDCoGlmIChmYXVsdC53cml0ZV9mYXVsdF90b19zaGFkb3dfcGd0YWJs
ZSAmJiBlbXVsYXRpb25fdHlwZSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCpl
bXVsYXRpb25fdHlwZSB8PSBFTVVMVFlQRV9XUklURV9QRl9UT19TUDsKPiDCoAo+ICvCoMKgwqDC
oMKgwqDCoHJldHVybiByOwo+ICt9Cj4gKwo+ICtzdGF0aWMgaW5saW5lIGludCBrdm1fbW11X2Rv
X3BhZ2VfZmF1bHQoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCBncGFfdAo+IGNyMl9vcl9ncGEsCj4g
K8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoHU2NCBlcnIsIGJvb2wgcHJlZmV0Y2gsIGludAo+ICplbXVs
YXRpb25fdHlwZSkKPiArewo+ICvCoMKgwqDCoMKgwqDCoGludCByOwo+ICsKPiArwqDCoMKgwqDC
oMKgwqAvKgo+ICvCoMKgwqDCoMKgwqDCoCAqIEFzeW5jICNQRiAiZmF1bHRzIiwgYS5rLmEuIHBy
ZWZldGNoIGZhdWx0cywgYXJlIG5vdCBmYXVsdHMgZnJvbSB0aGUKPiArwqDCoMKgwqDCoMKgwqAg
KiBndWVzdCBwZXJzcGVjdGl2ZSBhbmQgaGF2ZSBhbHJlYWR5IGJlZW4gY291bnRlZCBhdCB0aGUg
dGltZSBvZiB0aGUKPiArwqDCoMKgwqDCoMKgwqAgKiBvcmlnaW5hbCBmYXVsdC4KPiArwqDCoMKg
wqDCoMKgwqAgKi8KPiArwqDCoMKgwqDCoMKgwqBpZiAoIXByZWZldGNoKQo+ICvCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqB2Y3B1LT5zdGF0LnBmX3Rha2VuKys7CgpGcm9tIHRoZSBuYW1l
LCBpdCBtYWtlcyBzZW5zZSB0byBub3QgY291bnQgS1ZNX01BUF9NRU1PUlkgYXMgYSBwZl90YWtl
bi4gQnV0Cmt2bV9hcmNoX2FzeW5jX3BhZ2VfcmVhZHkoKSBpbmNyZW1lbnRzIGl0IGFzIHdlbGwu
IFdoaWNoIG1ha2VzIGl0IG1vcmUgbGlrZSBhCiJmYXVsdGVkLWluIiBjb3VudC4gSSB0aGluayB0
aGUgY29kZSBpbiB0aGlzIHBhdGNoIGlzIG9rLgoKPiArCj4gK8KgwqDCoMKgwqDCoMKgciA9IF9f
a3ZtX21tdV9kb19wYWdlX2ZhdWx0KHZjcHUsIGNyMl9vcl9ncGEsIGVyciwgcHJlZmV0Y2gsCj4g
ZW11bGF0aW9uX3R5cGUpOwo+ICsKPiDCoMKgwqDCoMKgwqDCoMKgLyoKPiDCoMKgwqDCoMKgwqDC
oMKgICogU2ltaWxhciB0byBhYm92ZSwgcHJlZmV0Y2ggZmF1bHRzIGFyZW4ndCB0cnVseSBzcHVy
aW91cywgYW5kIHRoZQo+IMKgwqDCoMKgwqDCoMKgwqAgKiBhc3luYyAjUEYgcGF0aCBkb2Vzbid0
IGRvIGVtdWxhdGlvbi7CoCBEbyBjb3VudCBmYXVsdHMgdGhhdCBhcmUKPiBmaXhlZAoK

