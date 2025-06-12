Return-Path: <kvm+bounces-49305-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 46317AD79D6
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 20:40:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2296318952C3
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 18:40:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 015832BEC25;
	Thu, 12 Jun 2025 18:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dVsptW4M"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E092B198851;
	Thu, 12 Jun 2025 18:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749753627; cv=fail; b=UCmCbjYs+qaOBdrgCeUP5FMoRgnrVJfJ/0sJ4ZjqkyLjLZ+NoKeJyziOEKaMEWP6f3lMb/cMx99TebCQ9L1p3uaQd0DvE3KIYhoeLTX4kwrNXnfn8Xp7dxKtb7UElbaDLaeJ307ah7mUbbvNyoNjUwsM8H0uho2BPI9fgcWox68=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749753627; c=relaxed/simple;
	bh=jBWGmI7DSWXBEQWMMhKXPNa+1kAWn/0dDk3uVw30GWE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=WK+KPqC9W+5exeMdew07iU9sjj/4L3x7biQxOpfculDFvDHEnH7Wa35szjFffnIZsV2c2fdefC+OMgpG+v5dQuykiVTdUXerrUMWFK/wmdGWHkG5P6al0PmrzTk6yUxtjWIucQBEfIiNQ8277jA+H2VgfEHws/baxg+MTzgDdRE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dVsptW4M; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749753625; x=1781289625;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jBWGmI7DSWXBEQWMMhKXPNa+1kAWn/0dDk3uVw30GWE=;
  b=dVsptW4MW5me/QblVV8hsJy8QV6cXIFG8c+7EhOHVFhG7DHTweTF+9sl
   hQvEXYjk6zA+tdORZ9+DK0tOpEDJ6A8+SZY7QCx+GRgevm+Wd2oDigHOp
   RpoGCHmGNNvzkoiarqpoRq0n3IvDLBSA1bAF7SVbVkIyFSQQGE0DVDk9A
   CbMTXp9htYzYqOCUG3hlgSECNfl/kUK5wKGD8WI6P9wMOkNgFDUVZle4Y
   c3h5m2eny8uYfo6NeyapyTmveF3D7AJ+Rw5wxVizrLH4ZABYjgMMuGGps
   yfcXRB109HI6XR7dnujzVBJ/XJwvX5qOTKAh/VPsHy30GNC6pPMS17K1P
   w==;
X-CSE-ConnectionGUID: o5YoLgwiSRa4CSHiP9Udgg==
X-CSE-MsgGUID: mUkoQGn6T7KeitQVeWvbuQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="51177072"
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="51177072"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 11:40:24 -0700
X-CSE-ConnectionGUID: lAbLIsIYSEaVwLFXrZ4jzA==
X-CSE-MsgGUID: FoiUs02uSamtbhBWPwR4QQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,231,1744095600"; 
   d="scan'208";a="147955433"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 11:40:24 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 11:40:23 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 11:40:23 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (40.107.94.44) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 11:40:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Th033QRfJnEqK2+e5peNkU7Gyu9lk8bncvJIun6Y2o9Suj8LUn+wmpJEPqqEM3xMHnz16vTw3VF2IA6D9NWElJbG2s8FqAkEa3IqCeBzP9IwaVBl+UjSdlrn3WCeeJS/+wcylFemfXdR/78l5VFGQo1DPvV6JirZ1z0N3vxMSWzfqHu75L7i1Xh6jfvHRpcfARi+I/9vCGnCTZdp+TC86SG1Tk3WdATaJ8qnMyLZWL1i2P/a/uryVSCJEIiQCFQbrgwmfJuMKzt6BBzNRUaHzD1DVGvIasv2uuPLg+ElL1BWLX+UNRYze0dCaaKRMJ8ZoPVhGMTyra/A/imE7SD9xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jBWGmI7DSWXBEQWMMhKXPNa+1kAWn/0dDk3uVw30GWE=;
 b=lu3O/GeLJ3hDtm8rkHtm1pQLpA27rJxk17acEpnA7EvWcnHV98Ex7qaKw9jsWlP/FW49qHk7TFvX/csaZqxTozCK2Ug64ZvackQ7PrmZNBCafnX0mHIrzyted+Qp70gR4hZjAJWIRsonarxoZo6QAOdY+T+2BcbWpUOv150iLCmLY+OP/VBc+Wj6IHx34BnMFb/APBaT9ZhuSQIzWWq4fouCEOxVZkhiEyCdjVEpUc5Vq63StsTaZTIuvHdR33rAfZyZl5ljzBSXO93/INyoMuqJmKWvC/HvCq0kAY7TIf2tyUZGowFpPtSrIAKf3OrZ02E0FK51IZ6hn6hK7qTzPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5260.namprd11.prod.outlook.com (2603:10b6:408:135::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8835.25; Thu, 12 Jun
 2025 18:40:07 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 18:40:07 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Huang, Kai" <kai.huang@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "tony.lindgren@linux.intel.com"
	<tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Topic: [PATCH] KVM: x86/mmu: Embed direct bits into gpa for
 KVM_PRE_FAULT_MEMORY
Thread-Index: AQHb2mYn9dWQDgvWTEqusObPtA6y57P+Q2SAgAEwtACAAGnwAA==
Date: Thu, 12 Jun 2025 18:40:07 +0000
Message-ID: <02ee52259c7c6b342d9c6ddf303fbf27004bf4ef.camel@intel.com>
References: <20250611001018.2179964-1-xiaoyao.li@intel.com>
	 <aEnGjQE3AmPB3wxk@google.com> <aErGKAHKA1VENLK0@yzhao56-desk.sh.intel.com>
In-Reply-To: <aErGKAHKA1VENLK0@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5260:EE_
x-ms-office365-filtering-correlation-id: 9a6e0ce2-b917-442a-0f79-08dda9e08e14
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dUp3QjR3WnJqSi9Sa0xreXRFNFJaQ0Qwc2RaTzlneDNyb2Juc3R6NWFDSkhI?=
 =?utf-8?B?VFBybWpkUGtPclNrcEVtUzJQS3I4Yzk4MGxvaDJ1MmRySDRwYVZSd2c1V1lT?=
 =?utf-8?B?TXhpL0l4dUtmdXNIaERheGd1SUY2NGF4OXg1dzVaOEZzUEZGNkc3S0VJV2xl?=
 =?utf-8?B?K29zQkNGeG91bzl1TFAycUJRZTdlOWR5RllMYnZlc0M4blF1Z2Yyc21CZFY1?=
 =?utf-8?B?MlpzSFRUK1gxcG1SazJDeTJGbmsyTjJnWUI5bTJ1ZnZnYjltd0tGc0VIckZ5?=
 =?utf-8?B?QVJBV0pwWEhPanRJbUJSTlpsZytXZkR0SVB6cXFVeHpHbWZoZm10SStkTkE2?=
 =?utf-8?B?ZHlyUzhtQXZJWTFuTUYxdzlSUS9aam1ZaUt2YUg0eXd0MnZrVUVVNzI2Vzg5?=
 =?utf-8?B?Q3dwYWVONkRsdUpLdnRFMmFibERpLzN5TTFidTd0THlXcjdUN3BZazRMRTFm?=
 =?utf-8?B?MXp0bXF3UGNvS3I5c3V1ZHB0Q0FhUVlrc3MwcWd3dVBicTVSaWl3VDdhYXJy?=
 =?utf-8?B?UTNiMVE0VUdnTkZ4WHhIWTh0QjRQTEd3UGErcDBGaEZ6TWdiMU9TYjRQVW10?=
 =?utf-8?B?UTdUYUdSRGszUlpScU9YTnJHR2Y3NDNKOHZtS3RIV0lqRHc5aW8xNjIyQ1lR?=
 =?utf-8?B?Z3A1QS9Vdi9UQktwT3Y2bmk5RUlPZW41TGU4ZzhkcVRwWjRvSFFxc0U0K1gz?=
 =?utf-8?B?dTlYWWNzSnYrTkxLNjNoek5Tb0U4SytsTk5yT1o0QXNOTjB0SnhLN2JabHZY?=
 =?utf-8?B?RE40QnlZak5RRGdpVnA2Umw3OU1aY3MvVUJGanRZMTU5TlJMS1dRVEJYRE1v?=
 =?utf-8?B?ajY5VXBOM25GWFZPcmYyM01uRHRtTEVrbkJuUTliQlBsMzdYdmVLQ2M3eXA5?=
 =?utf-8?B?Njk0VHhsYUErcGNhTnNYWm1MeXZYQVJkMlkyUDROb0E4Ujl1L2NyemJjeURI?=
 =?utf-8?B?S1JEN0pRcTErbEpHR2JvQzhoTkJVV1RQSnQ2QjdPQ25VYU9jYVgxVEJhT3FC?=
 =?utf-8?B?WnVjZ3ZJUzl4ZE8wdEkzbkRyaWxGYkdpRTFGTmZ6dXhHQUUrdTc4NzdTaGRu?=
 =?utf-8?B?MWlySlJZUWhaZlphVWJOZ2pESXdZZE1WRTQxV1d6Y0ROemRFL3BERzZ6cUg2?=
 =?utf-8?B?b3ZEWGhmYUc1dHp1c09GNkxvbXJwcTdpdmYxRysxYWREYjNRdjlqbTdBR0Za?=
 =?utf-8?B?TzBlek03bUgyY1ZldFRkT2JCWWZic2MveUFCOFVJSE9ZZ3g3YTE3and2UFNy?=
 =?utf-8?B?TFJHeUxiVUcyakJxT0FyWHplMTlWVEJkNDNYTTNvVFIybDQ3SFJzRS95NWF0?=
 =?utf-8?B?WEU0dm5wYlN5a1M1aW5PYmJaKzNyeFBOQVVNOFFhTDRMakJBbThFVXhmZWVW?=
 =?utf-8?B?V21xUnhIL1FJQnptK3VIZlBFc2pDc0dmZGZVU0dxMHdGRlA5UnFUYjlsNThl?=
 =?utf-8?B?dVNMRnI2WHdtVGZYN1dyNXhsemk1bXF5bU4xVVo4OVdCREJyUVNPdStyMmpE?=
 =?utf-8?B?ckRJSGZ3MHEvWXBZVFQ1M0VibUdYdlBPOWRTOXhSeTFMcDRCc2JZVkVBd1F1?=
 =?utf-8?B?aEhtNXlPOGNJOFkrUHJ1RUJucW9aQ1o3bkZ2NUJEV3JwcktTTnVWMlY2NWMr?=
 =?utf-8?B?Ujk3MXJjdGxuSFBoOTdsM1QvRUF2cnN2cDVQTys0eGlFMmFZZVgrSVhiWlF3?=
 =?utf-8?B?K1Rxc1d5a1N4dDZxcWxwalJNeFJrRmgrMWJGTFBZd21qS2FzOTZEVVo4elhW?=
 =?utf-8?B?cnJzb0gyMWszbHFRUWZqaGlpaGRzKzQ5a0MxRVpVQ1BIajhDU1hwM2NhdTdx?=
 =?utf-8?B?ZlZRb3pySE5XY2xUSThMcXFXVkEra1JudFJkK1lCR2krcXYyZGdwbHQxSlJy?=
 =?utf-8?B?c0pEMU1sUVZ6QVBOaCs1aFNBOE1aL0RZeldLUUhPRm02Y0JydnR4WEswU3k5?=
 =?utf-8?B?bkdaQWNmN2x2YzErWVY0WlFra3hqaVEzLzdHSnF0Y3ZzbEhJS3B3ZTFlQU1W?=
 =?utf-8?Q?775bqQYMmuPUXwg3PZdBgFtHhxcNeQ=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V2w0TFdCZmZHNWZtVC9NV1hDa2VvSHIwMmVrRzU5ZWpMckRPZ3NOOUhyQUNy?=
 =?utf-8?B?U3ova0k0aHE0dWVadTJMc2tVU0xDZGhwNVgySld3eHArcmxXWEJtd3JDWm1s?=
 =?utf-8?B?Wkt2OWdwKzFocllKQzdseW1yQStldTAvdE9FRGozUGg2V3I4YjQ0ZmpsWENZ?=
 =?utf-8?B?dVJ5cldheDl6Q2twTmZpcTRvNldWUmduZG1adGZkOGhrMi8xaWU1VzZUcS9W?=
 =?utf-8?B?N1Nha2ROL29KaDZGZjRvOGdnMDJiTE85SHg1d0NYQlA2T0k4QTMxU2ptZ0N2?=
 =?utf-8?B?YW55eXlaZk1yRVdkelFxd1hLRnJQdjlPRWgyTkJSZWUxRHpXbTZLSDYyYkd6?=
 =?utf-8?B?SVVPSDRBSmRsc0FOMFNaUlZtNGJqbVN4NUVKZWhwakpGbFhSWWxUWGVMbk5V?=
 =?utf-8?B?R2VwcE90NjhRV3JFMThUeVNNeURqQytVNEhuMUFKTENIZVVoL3FETFBjWmtU?=
 =?utf-8?B?T0poQWZwZzBxNjIwUmxXelVicklia2VZcmpqaHZQeG04U1hHL3RXT0xRTVh4?=
 =?utf-8?B?M2JFQkwvSFhJOGtiVzNQbFFSQytFZmw0RDBza09zY2NYQXpUOGlrOVl2bDNI?=
 =?utf-8?B?MEFkenpBUDExczMzNEoxZ0RXVm4vdXVJRlZRM2VTRFg4QXF6U2dRTlFSMWM0?=
 =?utf-8?B?dmxKOXJFeHV4VmRWSXB0NEhwTHloWlB1Q2k5ZjBiWEw5UjdJbnpoMm1ZOWw2?=
 =?utf-8?B?SExEY0E2dUFwZWp1b250dE95L2F1S0NzZ2cyMk1Kc3BmYTFCVGM0NXhvVkNC?=
 =?utf-8?B?eDc2RTNsVW5qSDdrOUxRUGJYYmtYN0x2UmE3TTI2SlJKSjFibTdsNllsZG5j?=
 =?utf-8?B?eUg5bzlMS1pWYURlc2h4dHRBbmdRbVllaHhjYzc5VGlnN204ZjJtbjlIREQ4?=
 =?utf-8?B?eGR5azNodHJxSWt6d1VlL0o0L3U4ckxZaUpJanlDQ1dzZ2ZibENNMXJMVUJn?=
 =?utf-8?B?NDk5b2ZKWFVINy9lZ2VUU1luQ1JaeldBbml4eFk0WEFqNFFRbU1XeXlnZHU4?=
 =?utf-8?B?R3BjUmwya2dZSytTcjJCMjc1MkhGUFcwYjRVU2JkMXE3QUlWa011WFlaOEpU?=
 =?utf-8?B?SHZHTXNaWHNBNldjZjQ3NjhEdFpNcVhyTG5idE12UmxkL1NWNW5CU1ZRbzd0?=
 =?utf-8?B?ZnEwM09NQmRKazdsWDVlaEpPZ1pteEt6SVBKSTBWazgyOEljQmNsampuZG9h?=
 =?utf-8?B?MkdaVjVsN0FwMSt4eXhtbmZEZDI2d0tZcisxVVE5d1RveWordmFHcVdPQVI5?=
 =?utf-8?B?TERmanFOS01yNzhHQ1lNamtiT010RWNESlg2RVkwWjBwQk5zNTRMUVdsdGhK?=
 =?utf-8?B?UFJvOU05N3BpazNKcU9hM01Nb0EzdGJPV1VER1hvZjN5UUtrVjk2OTVqZEov?=
 =?utf-8?B?ODdvbEFZcjQxazFWN2VhVTJoVEp3V0ZkQ004TGhBZUMzRWVjM2dQY05xMTRS?=
 =?utf-8?B?TnNJc3hxOUtxUExDUUpDNU5VZDFSTUJ6TXBiWWlmaE1LSnljanNuUlIzY3pl?=
 =?utf-8?B?RjE1N3NSb3Y5TjBkdHFpTnFObTg2SFdzTGJsdmdnVmxaamhSRldUdWxteWV5?=
 =?utf-8?B?NG0yNlRjdU96OE5OK01ncWRPdWFsVnFTQUU4Ymtta1N5YnZoOUJQWmpTMnBw?=
 =?utf-8?B?ODMrQ1VMSlRiMG11SjFSUVpNTmNJckdxMmIrWGNIbGQ1Zmd6RmtnODdZUVRo?=
 =?utf-8?B?U1ZmUkJTcVlaWXJHMmdCNDE2c3Q2a0R3NXl6djcyblVQN3lKQzR4VTkwNzNk?=
 =?utf-8?B?a2pxQmlBOXYxR3pDaDdid0pkTVJqSGpkYXhFQ0hrYnQ3a09RQmU1cno2dTFh?=
 =?utf-8?B?eXlzUDZqWFZnYVZyM1V2VU5VYkh4QVpKVHFwUmtBd1VNbHJPYjYwWVA1cGl3?=
 =?utf-8?B?VzJwNXN1UzNpbk9WNDZaaW5vMVF3RVFMOHkyTjNOMGdkUXVwdlMvUnNiME1l?=
 =?utf-8?B?Uzl6M2xyaUNyNG5GVC9nZ0hXM203aHdIb0cxVTNQeGIvNFY4aUl5b3NLRHR3?=
 =?utf-8?B?a3FaSlRyVkJreElMbGFBdEQ4a3lRSXE1akNyZThXT01KUy9vS1BaZmJORVVv?=
 =?utf-8?B?emFQZkd1UGE4Uy9kYjhiY1J1aG10YnFuK2ZPejNoenNtUmw5eUVzcEJHYmti?=
 =?utf-8?B?bktmMklJMWRuS2JmYU5IeTlSWXRzeUZaT29HTDN6M2tCZXFtRkxhQVB1OTFa?=
 =?utf-8?Q?9ABM81NE8Of92iNwo+kinvc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A05738E0225DD346B653780C5607E1EF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a6e0ce2-b917-442a-0f79-08dda9e08e14
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 18:40:07.7673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZZlV/4PVPl/o5kKLmgZgr2x6gK1y4vzETWNfh4zrOGmtvZD+MKLyz0BYoQVHlg1LyYdF2QV1o/K5Ffwr1G54bwFw0wHXxLWeHN/vsZjzVi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5260
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA2LTEyIGF0IDIwOjIwICswODAwLCBZYW4gWmhhbyB3cm90ZToNCj4gV2hh
dCBhYm91dCBwYXNzaW5nIGlzIGlzX3ByaXZhdGUgaW5zdGVhZD/CoCANCj4gDQo+IHN0YXRpYyBp
bmxpbmUgYm9vbCBrdm1faXNfbWlycm9yX2ZhdWx0KHN0cnVjdCBrdm0gKmt2bSwgYm9vbCBpc19w
cml2YXRlKQ0KPiB7DQo+IMKgCXJldHVybiBrdm1faGFzX21pcnJvcmVkX3RkcChrdm0pICYmIGlz
X3ByaXZhdGU7DQo+IH0NCj4gDQo+IHRkcF9tbXVfZ2V0X3Jvb3RfZm9yX2ZhdWx0KCkgYW5kIGt2
bV90ZHBfbW11X2dwYV9pc19tYXBwZWQoKSBjYW4gcGFzcyBpbg0KPiBmYXVsLT5pc19wcml2YXRl
IG9yIGlzX3ByaXZhdGUgZGlyZWN0bHksIGxlYXZpbmcgdGhlIHBhcnNpbmcgb2YgZXJyb3JfY29k
ZSAmDQo+IFBGRVJSX1BSSVZBVEVfQUNDRVNTIG9ubHkgaW4ga3ZtX21tdV9kb19wYWdlX2ZhdWx0
KCkuDQoNCkdlbmVyYWwgcXVlc3Rpb24gYWJvdXQgdGhlIGV4aXN0aW5nIGNvZGUuLi4NCg0KV2h5
IGRvIHdlIGhhdmUgdGhlIGVycm9yIGNvZGUgYml0cyBzZXBhcmF0ZWQgb3V0IGludG8gYm9vbHMg
aW4gc3RydWN0DQprdm1fcGFnZV9mYXVsdD8gSXQgdHJhbnNpdGlvbnMgYmV0d2VlbjoNCjEuIE5h
dGl2ZSBleGl0IGluZm8gKGV4aXQgcXVhbGlmaWNhdGlvbiwgQU1EIGVycm9yIGNvZGUsIGV0YykN
CjIuIFN5bnRoZXRpYyBlcnJvciBjb2Rlcw0KMy4gc3RydWN0IGt2bV9wYWdlX2ZhdWx0IGJvb2xz
ICphbmQqIHN5bnRoZXRpYyBlcnJvciBjb2RlLg0KDQpXaHkgZG9uJ3Qgd2UgZ28gcmlnaHQgdG8g
c3RydWN0IGt2bV9wYWdlX2ZhdWx0IGJvb2xzPyBPciBqdXN0IGxlYXZlIHRoZQ0Kc3ludGhldGlj
IGVycm9yIGNvZGUgaW4gc3RydWN0IGt2bV9wYWdlX2ZhdWx0IGFuZCByZWZlciB0byBpdD8gSGF2
aW5nIGJvdGggaW4NCnN0cnVjdCBrdm1fcGFnZV9mYXVsdCBzZWVtcyB3cm9uZywgYXQgbGVhc3Qu
DQo=

