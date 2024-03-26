Return-Path: <kvm+bounces-12640-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1707888B789
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 03:42:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 738561F3A602
	for <lists+kvm@lfdr.de>; Tue, 26 Mar 2024 02:42:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C6A712838E;
	Tue, 26 Mar 2024 02:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="k5I+Z3Hl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155DF57314;
	Tue, 26 Mar 2024 02:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711420963; cv=fail; b=S94Pbolu/0VpNllqjpSiNUwq93ibtR1kzBZDcOMZiU1thfo23jpuIAfTGQI0BVuA2byRWOxkhMOgT9ojsR/q1flkJEF0LMBaPz7RTLNj68n5ATpF2h3RLp7SOKoYqE8f/ZJTITYRe2lKpybKw7RqW7lPSWtvh6DlRdgtqsDQZI0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711420963; c=relaxed/simple;
	bh=BdK3X3LJ8v94Q7BYfRdbVz9+/riHYdaOuUypl/THTgc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Dtv+t21E1vg1TfUplWE6xawiMn0DX/6fvlenYwliWWqBiaF1GCaEELdll+cXctXmfe2tUUfN8Mm8IruINIfBeLbWh9+Fhwvpkr+oCkc1PtW+ABU1b9REcY1dTz7F/fnZ42sQyFMed1HTD8YoHaYvnvTwJiDreUHrafWkz8XudXI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=k5I+Z3Hl; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711420962; x=1742956962;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=BdK3X3LJ8v94Q7BYfRdbVz9+/riHYdaOuUypl/THTgc=;
  b=k5I+Z3Hl3MQSEUOkeeNuzKnDnqZoVEGoAFP2ExTmG8gZsfczYRH8ZEeD
   Ddk/pBIGTLD1rYr2defXmqKkEJyFg5EZfRlbMXZu5myBopMyZ32zknLet
   /pHRiZh4kUYMswMcN6uNTQgO5KxWAtJQ18KMzTo4wz0v1J/QCGmIQKir1
   HZ6SlAq/rxt+9vfZHSdwGAYq+3SbXKSkHxteqwVa3b4XT1LjaLUHh3DUa
   3Ab9xMLmErLd2xZfzs65x+m1Va9N4NYM6AjXK7p59DZlSqIATGiIDDZjl
   Ljk0zQpgVaNU1Yd8R2OodfJoT4QFwWNWSjOGB9zvXNFKik4zafB2+etbX
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,11024"; a="6563940"
X-IronPort-AV: E=Sophos;i="6.07,155,1708416000"; 
   d="scan'208";a="6563940"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Mar 2024 19:42:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,155,1708416000"; 
   d="scan'208";a="15688422"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Mar 2024 19:42:41 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 19:42:40 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 25 Mar 2024 19:42:39 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 25 Mar 2024 19:42:39 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 25 Mar 2024 19:42:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZ9DGlYaBdv0LMOdr+tPvKc5GZoLd3qqEPOkxdByZNGR3lj8g+NmKjrQaGspwtWJ54rt1T30P56hhAckGSQixEVdFPdqiZOaQk5lKGP69haoyRV6z9m+HJGsjIoZeRlif+xLbBo+YZ5S7ygVBMgwpIKb1RfLjAie1dd14yg+PR5F6/7ogpkdPJnudo/elQQBXcMAw1P/Rl5xhjZ++D58YTDR1RQL9SI59paY1ntinYD5JYMwoQkgSM2ciwHCZ0f2c5K9d9CyuaypPmDNVMKQ7H3eEr3bVfQ8HEZP8XvGmdRQLT8euAoof871pW/MqbAPc7xWkk0mkVMRQgrPRX7PSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BdK3X3LJ8v94Q7BYfRdbVz9+/riHYdaOuUypl/THTgc=;
 b=fAFqqGe/nY1R2OfGk+SUa/w/3vKNjYUGlRZuiPddnYmOc0lj4fghTrYEYfF9ZH4FTiSOoTxrT8vHaTnBoc/bwej8NLmx20buja6f+CPva3RSGXWs59wLUTQwCyS/uFWoonm3Xj+K6LsE03XTY6L+T+WqwifO7M1BxHQNCX/+M9QvT8PFgFfkVTQPrzLIOfeEsAZhSks8HHGNFqvF5NN2sw5Phpirvgu2dP7BbB3W+hAJ1D0yb5zYCKZUNqKL4LK1u30LiXJeSrvIR2RRYRRX0aBlXhKmTxkIRwjhyw2uEzPgLOFbtN98qfID0TugSAqZbGRIpnXwsOrrDz7uuuF5sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DS7PR11MB6063.namprd11.prod.outlook.com (2603:10b6:8:76::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.32; Tue, 26 Mar
 2024 02:42:36 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.028; Tue, 26 Mar 2024
 02:42:36 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"Huang, Kai" <kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Yuan, Hang" <hang.yuan@intel.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages for
 unsupported cases
Thread-Topic: [PATCH v19 059/130] KVM: x86/tdp_mmu: Don't zap private pages
 for unsupported cases
Thread-Index: AQHadnqpCkdQcpy1UEaf8e2/el3pBrE+L/IAgAGVVQCAABCvgIABmDGAgAFrqACAABw5gIAF68uAgAAN3oCAACgcAIAADqEAgAAC4oCAAAP3AIAAMXQAgAAC04A=
Date: Tue, 26 Mar 2024 02:42:36 +0000
Message-ID: <20db87741e356e22a72fadeda8ab982260f26705.camel@intel.com>
References: <1c2283aab681bd882111d14e8e71b4b35549e345.camel@intel.com>
	 <f63d19a8fe6d14186aecc8fcf777284879441ef6.camel@intel.com>
	 <20240321225910.GU1994522@ls.amr.corp.intel.com>
	 <96fcb59cd53ece2c0d269f39c424d087876b3c73.camel@intel.com>
	 <20240325190525.GG2357401@ls.amr.corp.intel.com>
	 <5917c0ee26cf2bb82a4ff14d35e46c219b40a13f.camel@intel.com>
	 <20240325221836.GO2357401@ls.amr.corp.intel.com>
	 <20240325231058.GP2357401@ls.amr.corp.intel.com>
	 <edcfc04cf358e6f885f65d881ef2f2165e059d7e.camel@intel.com>
	 <20240325233528.GQ2357401@ls.amr.corp.intel.com>
	 <ZgIzvHKobT2K8LZb@chao-email>
In-Reply-To: <ZgIzvHKobT2K8LZb@chao-email>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DS7PR11MB6063:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dXik9eCcpZ4bDy/Sw3xWsDc9cBWN4va3kIKUdY4jQ9xL2V1mmJrCRh2DTenTmwp2QxR9LVmcaSKjdxKup4zkB0hik40kaaWh6yj5lXP5kY1KrdFrSnWxyvse/Ov+fNXr9rs+qSYv0y5kDComGc4oz5u3g7UmCkILQkqO2xt4DUXa6svZHB7kQQD3quE09lf+dAR+Nhieen++bHbugjAlYUr6DJFw8Wmkjj2tgvRGVMzgKwPyyVlYEJ+y7bOPumideKyEY8TPpozcdIeEYmp8C5nRbpD4b8tIU16aTaO4JXXXlSEWCJxpVQhIemfGMDiIBZZvaG9Z4FBhdeFG2gcH46hS2SvgtWzXOFk8GLZa1fIU/DPUHRde49lzl1Xn83uiMDpy0iVyGOK3tYlMwUuR4QUewwr6J9NJR+fUBgHGHM0+0TmrZ/eHDD3bXgIOieJihI6yMolWCk5sFyBNE3BdmpqwanXiUzAUc/X9SffHd3byOgB3U/dngWldcY/m+b4WP0uzOsDQM7Y98kNeyadMGQJnB9XGo6hlRuVGJUPN5eIC4W0t/OMfy/4yxp6lQ2AEdXdhAuEHmwNR+0WYivmJJfKwuXTUqj68NW+AfjhT3Pn/DJwTybclnntEkK38OPa6dZpCVwI0SfIj7pL8nVdDr8C9o9Suxbg51oFcu/EzmoI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bCtxNjhob1FBditLVktTMHh1YXpKTkJPdFpNeG10YTVvcWVOSVlISTgzaVpH?=
 =?utf-8?B?VnNuYTF5Q2xPZFZhRTVCRUQ4dlBJYWtrUnltbFVtN1NSMDg4dElDODhNaXlu?=
 =?utf-8?B?VlNieU5pbmw2bjZZMmdlMDBvMVZnUzBJR1hjTit1NTUvV09DN1BKM0RsNXNB?=
 =?utf-8?B?OEZEZ3EyYTdyWjRJcHJQZmxXb0tuelBzQTNxRDc0aW1YQ3EzTEluais4YlFr?=
 =?utf-8?B?ZkppUjdDUHdteU1TUmRVbnJyNVVIS0hKV3hVOXI3Vzc3RnFxd0hpdGJacVh6?=
 =?utf-8?B?SllRQ0FDMzhkd2Y4d3NCQTFHRnp1M0I5OXJ0ZGlqVHJJV2c0QkpEcm80SllC?=
 =?utf-8?B?eTRVbWxXQVdpanZNSk55dithRmdSNUZINmx5cFhkbnBKUDViMFNyQU1DVVpi?=
 =?utf-8?B?WUkzdFk0OGFWTGZnYjNVS05XN0NTVWEyZzlDSFV4eWhlZUdSMW1vNm05MlFL?=
 =?utf-8?B?Y1V5MmpwR0J1WnlEUldTRmV3OEhENFJQN2QyK0xnSDZNYnllZUJBc1NrMzA5?=
 =?utf-8?B?QlVKb0hxZHN3SmxxLzdEcStlc2pXcUcxRksrbG9JZFIzSXdjbko5czZaQ3E1?=
 =?utf-8?B?UjlhQ3lpbEdYQzBXb3k3QWo3d1hBT053Tngvd1QyKzZNQmx5OE1hY01Hb0gy?=
 =?utf-8?B?NjBJay9zTEhrZU9NcXZNWmZpeGNhOURhSHoyYXB5bjFsK3lZQ0l3amFaQVRx?=
 =?utf-8?B?VTMrYlU2YVl6Wi9OL2U0RTB6OWNSMnpiRHoydlhKMXVyM0RGdS9SYkNKOXJp?=
 =?utf-8?B?bEtreExpVmNpdHNTUER0Z21SbHRJM0l3MW5VWDkvTGJwdjh0RnZsK0ZsYk1M?=
 =?utf-8?B?VDhkOTRtczhidmJvM1lRbnllZUFGZWZ2NG9XTDVPSG9TbDhiSEJ0NDlaNmF6?=
 =?utf-8?B?QUZEM2lRbmRNQU9uT3EvMVdob1kzbnVmUzhzWURiVXhrMEdkZFgrVHVIMEtR?=
 =?utf-8?B?SzZsUXBSbXZjMnhDczR5QWhZU0t5U0dTOWlza3B0YTZtQ1YvL2FKS2s0UkFu?=
 =?utf-8?B?cFpHR2JxVXkrYnNYbmNkVEpGelhEQkxEWExvakN2OTlFVTAwdGZGcVM4VUNy?=
 =?utf-8?B?eHZ4blNsdWxIVVpPS1ZhMmxmd1hCRVdaekY4Z1h1NXVob1JTZ1BmNVh2elJE?=
 =?utf-8?B?dHpTaHBTY3p2bC9sUHFZaXY0QkVPeVNKUWxWcFNuZXZjK0lVRFBYVDZ1cHRG?=
 =?utf-8?B?UUhjU2RvaHlkZUZlM2J1ZU45TFJLbzVaalc2OVh5bnViY280d3B0NllveXV5?=
 =?utf-8?B?YWthSzRabE14M01ZZTlnbFkzaWpBUGhKZnVFTXNwQmhEckV6RTFETWNLUmd0?=
 =?utf-8?B?TTNwMkhHbzE0UzkwTE04SGNjS3lkSlNFMDRjUHk4RXV4K3UrV1ZWaEJFWGdO?=
 =?utf-8?B?c2tqampJcnF0WFBYRitoMUxOdjBIUjBJTERod1lacDJhbll4YmJzSGVtaEsv?=
 =?utf-8?B?NTdiNVp5TEZuWmUwSElvSytoUUsxa3RzNEp6djZOY0xYWElLT3czU1RoUG1V?=
 =?utf-8?B?c1dIdEZLYVNUTmx3OTYvdDVic0VXbmhWS05nZ0Q4c214RW40cllpNy9WcnE2?=
 =?utf-8?B?Yi90RCtZdC82ckt4MS9HcjAvNm1vSS9BMWJrL3IzbnNRd0I2amV6ZGR1SHh6?=
 =?utf-8?B?OC9UNHV3ZlhDM1JKN2dPTFEzWGFXczduZ3dmYTNrL0c4di9mNmhJQjBGMENu?=
 =?utf-8?B?VEZsQTZHNS9yM3BPLzlTV1REZzN3QTZZMmxwYko5QkZObUlDU0hDOXVkSkNp?=
 =?utf-8?B?MHdMbHM1ZUZ1SXJGRUpkenJqc0Z0SGdGbHRpSUlVSW12VXhRQzRpWjJIaEpI?=
 =?utf-8?B?R1lKWEVwQjhiaUNjbXo0dngvTy9mSWNoYTV4c1pnczNVQVFHR281dG1kd090?=
 =?utf-8?B?VGxLeWpvM05PbmoyVWFvZ0IwcXZrTHhjTnpzYlRpRS9zSjZiakZxL3lwNnJo?=
 =?utf-8?B?VUJyY1RINVZ4a1BVcVFETW05ODY2c3R5WkpyM1grTzQyVHEvd0s4OWdWRWVZ?=
 =?utf-8?B?S0VzVFJ1RGRRbGtLbTV1OStnbHRXMUNOZlNzVlJ3TWtVd1h6bG11UmNnUStJ?=
 =?utf-8?B?UjF6ek9SbWRhMVZnb0t5dVZNZWcwYWlwWjBYSG9tVklDOHVvZVhBZG4zN0tk?=
 =?utf-8?B?YmlQYkY4SGJidmdqQ29UTFpuYlBvUk1VWEppdElRa3FrcUhLeG9aN1QvOVBD?=
 =?utf-8?Q?C1q6OkKTZxknszDlg7mSjYw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <35169B42822E924CA9EE9B169B49AAF1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9d1406b7-5987-44a6-b4f1-08dc4d3e653f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2024 02:42:36.1266
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3LWVlsh71VsrmpReI7+p+XV0Wj2y9CykOCp/9Bfb5UpcNct4fuMwqadfp9jxylnJk8H+oFDmvsWx0zu9f/vw+89i0eXypMCdyoILcfC8FfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6063
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTAzLTI2IGF0IDEwOjMyICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gPiA+
ID4gU29tZXRoaW5nIGxpa2UgdGhpcyBmb3IgIjExMi8xMzAgS1ZNOiBURFg6IEhhbmRsZSBURFgg
UFYgcmRtc3Ivd3Jtc3IgaHlwZXJjYWxsIg0KPiA+ID4gPiBDb21waWxlIG9ubHkgdGVzdGVkIGF0
IHRoaXMgcG9pbnQuDQo+ID4gPiANCj4gPiA+IFNlZW1zIHJlYXNvbmFibGUgdG8gbWUuIERvZXMg
UUVNVSBjb25maWd1cmUgYSBzcGVjaWFsIHNldCBvZiBNU1JzIHRvIGZpbHRlciBmb3IgVERYIGN1
cnJlbnRseT8NCj4gPiANCj4gPiBObyBmb3IgVERYIGF0IHRoZSBtb21lbnQuwqAgV2UgbmVlZCB0
byBhZGQgc3VjaCBsb2dpYy4NCj4gDQo+IFdoYXQgaWYgUUVNVSBkb2Vzbid0IGNvbmZpZ3VyZSB0
aGUgc2V0IG9mIE1TUnMgdG8gZmlsdGVyPyBJbiB0aGlzIGNhc2UsIEtWTQ0KPiBzdGlsbCBuZWVk
cyB0byBoYW5kbGUgdGhlIE1TUiBhY2Nlc3Nlcy4NCg0KRG8geW91IHNlZSBhIHByb2JsZW0gZm9y
IHRoZSBrZXJuZWw/IEkgdGhpbmsgaWYgYW55IGlzc3VlcyBhcmUgbGltaXRlZCB0byBvbmx5IHRo
ZSBndWVzdCwgdGhlbiB3ZQ0Kc2hvdWxkIGNvdW50IG9uIHVzZXJzcGFjZSB0byBjb25maWd1cmUg
dGhlIG1zciBsaXN0Lg0KDQpUb2RheSBpZiB0aGUgTVNSIGFjY2VzcyBpcyBub3QgYWxsb3dlZCBi
eSB0aGUgZmlsdGVyLCBvciB0aGUgTVNSIGFjY2VzcyBvdGhlcndpc2UgZmFpbHMsIGFuIGVycm9y
IGlzDQpyZXR1cm5lZCB0byB0aGUgZ3Vlc3QuIEkgdGhpbmsgSXNha3UncyBwcm9wb3NhbCBpcyB0
byByZXR1cm4gdG8gdXNlcnNwYWNlIGlmIHRoZSBmaWx0ZXIgbGlzdCBmYWlscywNCmFuZCByZXR1
cm4gYW4gZXJyb3IgdG8gdGhlIGd1ZXN0IGlmIHRoZSBhY2Nlc3Mgb3RoZXJ3aXNlIGZhaWxzLiBT
byB0aGUgYWNjZXNzaWJsZSBNU1JzIGFyZSB0aGUgc2FtZS4NCkl0J3MganVzdCBjaGFuZ2UgaW4g
aG93IGVycm9yIGlzIHJlcG9ydGVkLg0KDQo=

