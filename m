Return-Path: <kvm+bounces-12798-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2F5B88DBD1
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E70341C27846
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA66C52F7B;
	Wed, 27 Mar 2024 11:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xhm7w3+W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642AE22065;
	Wed, 27 Mar 2024 11:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537372; cv=fail; b=rdOByxDYJIr5uMkqAcZwtPm+gYqJhWz1GAiJ6hsZ6vR9eV6uqz7H4pjDtvnjWCBN3wtsmesREq3R4GXrCb0EoDyZtO44fFbEpa4R6kQn3JXS9baAaeTl7DSK6aNSN71n15V7VeVWHcssPi1yebq4p90Njt/fybRUjbCMetUmEXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537372; c=relaxed/simple;
	bh=dJpt32gYSw9Wpow5dcun8YPXxaJyKFq/KUoddeDBsdY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=NS0I/QtcNCp56Z+uRdpfhg6v2PGar30Ko9dEKKk+oaVJ9gs3Uj6tSJ4nhwyReexbBQDdg9WyZFQDYXw8rduPNQxWmmYftPw3qKyITO+ScXd+1Wwi5ooiPJpgral7MTYxe5KR/ul51F2E9RrKFq4UmJWrXa+DdjusoBY8niUiMis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xhm7w3+W; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711537371; x=1743073371;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dJpt32gYSw9Wpow5dcun8YPXxaJyKFq/KUoddeDBsdY=;
  b=Xhm7w3+WQ1s4k/5C23qM5bcd65Rv3dfcBwbd1b3hISDiaAeOKVC3p41K
   iAT0KZ8qxfMcE6mAhK/Jsx3ojL93MbhgKRH2BMXuxkga9Hn0ah8aUUnvy
   LxO2bNifTAgXjmaS0wI0gP2WxKfTjJTRxpkhiYz+LAAEs5zJOzrkfA+eO
   S66FKQ56WCnbfzN2HvRK18Vak7m1Lk4KPKBRGfUktXDQHhCdsuJjCvfVy
   0/cszOvR1QFUEN4gqsWdn9hBhEJKBCdTpVUfO+QDqsIM/ztPjArY8AYn3
   qbgoLsynzvhUuG/a9V/rfNtCuAQ3867BOkcA8ZJkXlINSRAaaEHiVM7jt
   A==;
X-CSE-ConnectionGUID: YChae+8bSjSY4+txom32xA==
X-CSE-MsgGUID: /opRrKdQTYi6myx82sCIJg==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="6565183"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="6565183"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 04:02:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="39381383"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmviesa002.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 27 Mar 2024 04:02:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 04:02:49 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Wed, 27 Mar 2024 04:02:48 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Wed, 27 Mar 2024 04:02:48 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Wed, 27 Mar 2024 04:02:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oq0xGVb11bwaihPAQ5MP2x4zktuPe8G1e4aozG9tAL+5rmPbRQng3wYxGVyyi+rQ6RTvgCzIzVfQCXvTgyec3jyn4ceQnsa+nm3rtD4i2FJgB8UqGakrsRurynUGKeEEU06pId/w7GoxKlYKHXAXpmpfAHg5sKmqZj2kxffUVsPL9mqSWiCNqmlUpBiP0qM2V4L8dxrZGC8TIKvShDuMr8pCJN3fJh91wjspbjnp3mGL9ydj/H/KFlycANYy7y8FkMg3giD9yuUZhl6cgwopO+YJu6NZPjvF/I2kC0jX6JmspQ2Q/p6vRGxzCeg9UR9ZZCkQtvyO/ySDus8eFX+fuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dJpt32gYSw9Wpow5dcun8YPXxaJyKFq/KUoddeDBsdY=;
 b=X7uXDMp/EsWF2kS38HjcG/ce3fVk9N47JOyqYFACnvHItsspGJq49AF84fhKyz1WLhK2w2JVpDa3obW3jb4y2HCvTuHB4Xrs6mr5kzWfK1MLPUJvhFVwhR+HL065D0UHyIN/ULVpjaH+srpmhJmwbA+lvI6UcW15YysPnJGnT/FvOQqR/ZIWlj0MnYugEaJI4QQ+2GsU3jTa9rOHae0dt9SSByRR8bCOJIxaJK1KeDkyTgxR+7TP9LOyLuTP6DwIKiEtaeWKu/Kekj//7Gf8iwJiUVQr7HnXdMeDIB3qMBuF0IqjpQd+5Nd07qqZPtqcpBfNv0Izem5jG2MKJlDyWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by LV8PR11MB8512.namprd11.prod.outlook.com (2603:10b6:408:1e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Wed, 27 Mar
 2024 11:02:47 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::ef2c:d500:3461:9b92%4]) with mapi id 15.20.7409.031; Wed, 27 Mar 2024
 11:02:46 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "luto@kernel.org" <luto@kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "x86@kernel.org" <x86@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "Li, Xin3" <xin3.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Kang, Shan" <shan.kang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 9/9] KVM: nVMX: Use macros and #defines in
 vmx_restore_vmx_misc()
Thread-Topic: [PATCH v6 9/9] KVM: nVMX: Use macros and #defines in
 vmx_restore_vmx_misc()
Thread-Index: AQHaccEGppW15Pd0gUuKvLQ4fxKujrFLiRQA
Date: Wed, 27 Mar 2024 11:02:46 +0000
Message-ID: <1d06c7b9805cbca742ba76c30a0d77ca2e6b1f0f.camel@intel.com>
References: <20240309012725.1409949-1-seanjc@google.com>
	 <20240309012725.1409949-10-seanjc@google.com>
In-Reply-To: <20240309012725.1409949-10-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|LV8PR11MB8512:EE_
x-ms-office365-filtering-correlation-id: 6d05ba3d-8729-4f0a-595d-08dc4e4d6f78
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xwYvxIULN/yL4ipzGRTYcvRM+T3vdOdF3BL7HduJqy2Pb+ygGJ2CmV24F+MegagPed4pWLWn3PGINP44m3WRddb/zlkZjbmWLEvCw4NbGzGt9NtWxcJLAX/E0H8P1glJhkzbVUtxO9WskPZaHApNSqbtRuJtugz9GSmk7fHnriNwSFbfcLY0mjMsQY/AXJ5Fen8Cv3OGUeV8LtlrikDnnH0rjcGi+8/dXVV45eombtk8y0kGrx11YI9XAEwNxBE18gko+D66eRFhuNbMD/tTpsbIu9zF9SPtqBVA2OqtlMPrX8398ZroxY/OnXikXWzvtCCipeV48pi1VL5Wwzm3QbiMYd1VES29Nk8D4GgNuY+mvGWEy67mCZKDQ64VdFUDlvXxqKCPgEB1YJTLTgzMXjYq0lzyO0DXGD1rBb97kWi48IkFxBmx1Je7/5vVME394XmIjtgnXhDtlBqxX0Pf/91mLGIt62nFTokRB5uFQ6OAw589xqd61Yz16DNtFn8H/yK7ukzMzT8koRzhGoOMhgmR5S+6arD2HjlmvSBJwdP7Y7fQP6cCAvdxN6ZPkgKFwIpWoFrEpgMKHhiVVQezzd1A+EOvdIpxz4AyjJfHxp0aL8eqkKWJ3SVpfp8fIC4vVvSHFDJiF9vbHDLlTez2KcPejotH5PRlSf/TLQb6W073xm8ZcBthikoLbTPDlvyc2kkVvD//16OhtI20ucsJBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(7416005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?STZieU4yUFJtc3VqSHBiRGVoa0ZHSkdoTVhhZUlMY01ZaTZEWkU3dW11RmpW?=
 =?utf-8?B?ZDhWWU1DQ3EwMnNIQlZBZlo2U0diMTMzWlpIZUpnYmhlR2VqUm1rYWw1UW1p?=
 =?utf-8?B?UVFNa2FLcVFET3pIQVNTbGk0blJVd2dsNXBoN3JUQkE5dlhRK1o4Yjl2MmFx?=
 =?utf-8?B?bGtaeUdKb2NrZm5hVVM2a240OTJpM2x3RjJySWd1V3hGOFFJWDkySUdJSyty?=
 =?utf-8?B?dlA0QTlqOVdnM0FBS2k0bVZuL3JTcmJDM3VKQm9jZFVqSnhVdkJoLzRtRkI4?=
 =?utf-8?B?UjdrT3J6aWtFbUxDbDZFWkpvT01MbnRLdFJDenBZN0RoOXRIRmk2ekhuYlk0?=
 =?utf-8?B?REJsZUU4cFVLb3AwckM1amp3KzlFN3FWLzhtQldtM3FTMjNyemJ2UzhkK0li?=
 =?utf-8?B?VHJQZXdSSFlPNThBMStyeFRWdjdab2pMdWlGZ3RHZXFCdnlxODBnRFdVaFRY?=
 =?utf-8?B?YU84THZVNEkzZXNJa0daSjVGdmcyN1RJMmRxTU8vaW9Rd1Z5aEN1S1Jlcnhm?=
 =?utf-8?B?MmJsOGNkZHkwaW9DTjZoUVJ6M3pFeDZZaUxsbXplNUVHSnNsNW4vRjRDcTFh?=
 =?utf-8?B?ak0yOXAzUVhGbjd4VWVMbHdadkkwTjEwUmNwdTRldllaSUhqYlJBMXYwZCsy?=
 =?utf-8?B?NklGdFEzaGhqakMxM25NV0xLRWdwa0ZOaVRSSnBXTDVqZkxnZTV3anloQlNX?=
 =?utf-8?B?RXJuSllWUlNlRjdaeDZ0bjJURndRaDV3eGtRMkFucysybWdxRllYWTd4SERu?=
 =?utf-8?B?bndaZkVvOUIvbHNjeUlNc1RIYTZjODJnVk94M0Q5TENac2xHQnU4NjRGQWRK?=
 =?utf-8?B?ZGFWa3ZlbWtVRklJVGdtSTdSdUc4TlhRYjJXaEhPdXBLYTRxRFl1MWltWndy?=
 =?utf-8?B?WDhBT2g2dVFoSlM0NEN5aXI2Q3U0eXN4dGdpUW9WUW1VQVlXYktnd1JjaVU5?=
 =?utf-8?B?RHpLUkpNNnRzeHVoMnhTbk82UGtxUm41TnB5cVQvREwvbitCYjBYRStsVTBi?=
 =?utf-8?B?M3Qyck51WnM4dlZxUTFMSUpkU3VsY09TMFRoZlBFUWNqWEI0QlRCWWpQUkVk?=
 =?utf-8?B?MUR2Wmo3NkFwcEgrOTJldXpEMW43OVp0bk9sSys3R1ZUNVgvOFlyMzdmeWZ4?=
 =?utf-8?B?OEZpNFMrVWVmcDBZYjlBN21tZG5kV2xTckhodmtmTlBkYXRCenFJVE0yc1JT?=
 =?utf-8?B?a0RDT1F1Qzl1aXorM1JEOCtCRjhrTmVYWkJ4NGUyd3B3U01kM3JVUkZVRmVo?=
 =?utf-8?B?RFArOUFFWjRLWlVwakprSkRqYml0azRuZ2t6VGFvVENML3ZCNlVNQVk3T0ZI?=
 =?utf-8?B?YkpBcWVXQy9LSTdyRWVCL0ZqMS94WW9mMFNvS0xwZW9NZ0h5eGFRSVFqckt1?=
 =?utf-8?B?NElWZ3FKRmRHYUd2UjZDSEVsSHFQVngraHIyR1ZYdGpNTndNSDh6Q2ZWdlZt?=
 =?utf-8?B?TGdFQXJudkxvWTFnd0d5L2hCWmFIMWFMcWFkMHNiTmFPREF3dVBLQzVJaDZ5?=
 =?utf-8?B?UnNqdXlBakR2OTNWYXoyVmZqMmVodU9FYXh3UTJyWldFWGwzWkg2R3ppdWxs?=
 =?utf-8?B?SGlERXY0czFyZmNwVWErKzd3T1VHK0tPNmp6MGV5ek1KaDJHWlpMdnJxWkJo?=
 =?utf-8?B?VUUycVVLL2pwSzFzd0U4TXQyUmVCOUtWUURycktHNzFFbGg2OFI4NVZtbWxO?=
 =?utf-8?B?L3UwYjRrOWh3OXlEK01aWWJ2bUk3RHpLeFkwNFBOT3NvNW44aWhtVkppbFBX?=
 =?utf-8?B?SzdFZVBrZjJMSldVZ1FMZWdWeVkrcGZ1bzlJUzllYWhWaWVZZCtlcmVuNmRV?=
 =?utf-8?B?YW8vY1dTRzFmTzNaRG5kUkd1dFJZcTdvak4xR0xHT3BTbEdHUHVOZkZ4S1Q5?=
 =?utf-8?B?cnVaQU1WRThPSU0rMEpHY2R0dXd2L0tDSUp0Vk9DRlhHTEZ5RGNnYkIwTmZl?=
 =?utf-8?B?NlZRSVlMQk5tUy90a25qczljZVZVR3IwN3RGZ0lQZTlDSHVZZ0xlOFhKQzNZ?=
 =?utf-8?B?U2xvV2VEOEZLTm14eWJwRlViRm5HY1RKU0wySjZ6SUVtaWQ2cE1XRFY1ZVZK?=
 =?utf-8?B?RDEyV2ZNbUNoUW9nTTlkbFJWQXZvdW5nazNtbFJJbHdqRnIzdGkrb2dnL1Vy?=
 =?utf-8?B?VkNydkpPRGhTMzNaUlFGaG8rVXhudVpIOVhPMWdKTTlaaHVUbzBJajFick1R?=
 =?utf-8?B?RWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <09A6B748EC963E4E8195348655468BE3@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d05ba3d-8729-4f0a-595d-08dc4e4d6f78
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Mar 2024 11:02:46.9338
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g11aQarI3tE/nfCZXcWACqB8aG9wZdPSJr/MXYIFZffWeJy7jvO/gcw32Wd3w6uO0O8nEn7ZXqX+b9DBISBdLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR11MB8512
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTAzLTA4IGF0IDE3OjI3IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBYaW4gTGkgPHhpbjMubGlAaW50ZWwuY29tPg0KPiANCj4gVXNlIG1hY3Jv
cyBpbiB2bXhfcmVzdG9yZV92bXhfbWlzYygpIGluc3RlYWQgb2Ygb3BlbiBjb2RpbmcgZXZlcnl0
aGluZw0KPiB1c2luZyBCSVRfVUxMKCkgYW5kIEdFTk1BU0tfVUxMKCkuICBPcHBvcnR1bmlzdGlj
YWxseSBzcGxpdCBmZWF0dXJlIGJpdHMNCj4gYW5kIHJlc2VydmVkIGJpdHMgaW50byBzZXBhcmF0
ZSB2YXJpYWJsZXMsIGFuZCBhZGQgYSBjb21tZW50IGV4cGxhaW5pbmcNCj4gdGhlIHN1YnNldCBs
b2dpYyAoaXQncyBub3QgaW1tZWRpYXRlbHkgb2J2aW91cyB0aGF0IHRoZSBzZXQgb2YgZmVhdHVy
ZQ0KPiBiaXRzIGlzIE5PVCB0aGUgc2V0IG9mIF9zdXBwb3J0ZWRfIGZlYXR1cmUgYml0cykuDQo+
IA0KPiBDYzogU2hhbiBLYW5nIDxzaGFuLmthbmdAaW50ZWwuY29tPg0KPiBDYzogS2FpIEh1YW5n
IDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBYaW4gTGkgPHhpbjMubGlA
aW50ZWwuY29tPg0KPiBbc2Vhbjogc3BsaXQgdG8gc2VwYXJhdGUgcGF0Y2gsIHdyaXRlIGNoYW5n
ZWxvZywgZHJvcCAjZGVmaW5lc10NCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3RvcGhlcnNv
biA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IA0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWku
aHVhbmdAaW50ZWwuY29tPg0KDQo=

