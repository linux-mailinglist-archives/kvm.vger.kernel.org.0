Return-Path: <kvm+bounces-14804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 097658A71F0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 19:08:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 872D81F241B0
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 17:08:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE959133405;
	Tue, 16 Apr 2024 17:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BiIrssXR"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A93B130E46;
	Tue, 16 Apr 2024 17:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713287305; cv=fail; b=UopoJ8/zCfj9J4DHGG8xsOA0DFgqLIFmAzGdx8IKMQU22O11OMVDnzCZEZnC97v7G4s5+LjpgJnlVZXg7/JEAosTC5ceVH50Hh5ohb2Oenw6zwFPb01FnDVS/GpZjDVmIBPTI6rvTjGPn4EgmwdDRQQtFiCp2xz9Yf/a7ZD4J/E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713287305; c=relaxed/simple;
	bh=dgr3jLCJ1JialyPwwBPXCTrHS20RvsayTaE/jFq5rsk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=TXMvlcKhHGMIzAMtddEGkLSl6b0ZCAuBUbgcBmQmighKbI64DasyGrwh5Hy1cTUpjZZtg9jwetV3qGnd6LPvrWwILxCnjy/w4DfjIyQ4YXrTnVrMOz14a7gBNAZdhRi7HqoMUTDh7m8EcfZoJsd1KKAf9nzw96m2WVctE3VwaKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BiIrssXR; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713287304; x=1744823304;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=dgr3jLCJ1JialyPwwBPXCTrHS20RvsayTaE/jFq5rsk=;
  b=BiIrssXRVxzKHj64RH97j2SHKDqcB9ScLaIiIGLgd3ZRxkkHcan2Sg6N
   SrCn3t8GUnE1MEHkmhATrbjG3ng9GC+oVACP8/KEsiEPfPehCxPSvWzLg
   qYz+WqfFRvb1eXwEhmSgdukKz8qCiDDi4jH8r6HnCO87i2U169OPsGeFu
   A+YwiZ5oJ5A4sBrrOrzvmQw6xRhn5wESoewYP+xfhTrQ7m/xY5hK947cS
   0/5h3C4wo1bdt7mOa5A3/HyfGR1scujpQs48FbYZTgxFjysYlxsRvFsiu
   tojTX+QpQUgdBVN0UQX/22pJrwqj+Rfe9PtM7gSL2NG6fprTRzLKgSMfk
   w==;
X-CSE-ConnectionGUID: WU4kClqwQU+RCLPWw4o+wA==
X-CSE-MsgGUID: o4inSlMsRIKJhXT/+oaynQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8857218"
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="8857218"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2024 10:08:23 -0700
X-CSE-ConnectionGUID: VAHUP3tQTpmsSwY3l/SvZQ==
X-CSE-MsgGUID: I4Oz/ZrfTC2E9ZWPRtTihQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,206,1708416000"; 
   d="scan'208";a="27119885"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Apr 2024 10:08:23 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 10:08:22 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 16 Apr 2024 10:08:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 16 Apr 2024 10:08:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 16 Apr 2024 10:08:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATmo9qldlWpqWMFS1hC5t6AbXjF+lAZ76laS4TYqrRMMNVX8mdexViFO4/a4Rq6SwBgveYpLhKHRpOmhdOxQyK9tUAyZ+t/natsJwXfy/x2z3g+vAUK3z6udKG93AwaYmiAQPzrb79yPk+L/6bik5El32dMgXXhUBhGyaSWIF6/LwLsPOPQv6+pHt7ht0bp55wbQMBMANTHgXkHEcXKM9fosfR2XfZ/qV1d+/zPCYR9bZW4OsX+79RtviwPFIeQ2krbx1YYI7O9vfde4EhKH0RdP90sj638RoLnea1mpO5cDZuocOpvUw1g5eUB6xbVysIXlbzg+dKITV4pZB4JdQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dgr3jLCJ1JialyPwwBPXCTrHS20RvsayTaE/jFq5rsk=;
 b=ahYDADwEDWMK5wQD1UAHVwP7zd5MRHDyOvxNld0CAbu5i78SX/Xk14bsI5aGbQizE2x0v8wtb+k7ctU1WpInUm9rL9QV4Wn8J9SKAlyp3rDZKNyNvtiBWeDWJ/knPCw+MX5hg3/eIQ+xpI5tZMjPd4FBCQgUMkBMNFQGY88u5fT8hNA07uY/O13IONUkkD76oPdP5zFqlYx9CPQZGEfSqjePdso93oXygC5XQptrYJvKMHNiiGDtI2gmGU0py+xv6+8A4y+ARCrrsUU5Z9i8gp/WcygSB6J5BSqWJVIF6N4CTHyg7reC+NUX1L4Vxvc6lYrctu2fW7SKyUum5qeXtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY5PR11MB6115.namprd11.prod.outlook.com (2603:10b6:930:2c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.26; Tue, 16 Apr
 2024 17:08:19 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7472.027; Tue, 16 Apr 2024
 17:08:19 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "jmattson@google.com" <jmattson@google.com>, "Gao, Chao"
	<chao.gao@intel.com>, "seanjc@google.com" <seanjc@google.com>,
	"vkuznets@redhat.com" <vkuznets@redhat.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "Chatre, Reinette" <reinette.chatre@intel.com>, "Li,
 Xiaoyao" <xiaoyao.li@intel.com>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 3/4] KVM: x86: Add a capability to configure bus
 frequency for APIC timer
Thread-Topic: [PATCH V4 3/4] KVM: x86: Add a capability to configure bus
 frequency for APIC timer
Thread-Index: AQHae64zgCZdFXjd0kq0cKzbJnMZ7rFrSf0A
Date: Tue, 16 Apr 2024 17:08:19 +0000
Message-ID: <7b9651b233e43af66be47bd5a20297ca2d7c7e4a.camel@intel.com>
References: <cover.1711035400.git.reinette.chatre@intel.com>
	 <6146ef9f9e5a17a1940b0efb571c5143b0e9ef8f.1711035400.git.reinette.chatre@intel.com>
In-Reply-To: <6146ef9f9e5a17a1940b0efb571c5143b0e9ef8f.1711035400.git.reinette.chatre@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY5PR11MB6115:EE_
x-ms-office365-filtering-correlation-id: c94fb4d9-c1ab-4a7c-b18d-08dc5e37d056
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1krZlV23ZNi5blS8fq5Dw1xrU25SyMxwNKHzsgXYUo0SHvnXOTNSPvIZDcAyZxLMs26dFq3KxxpotM2l35wjPUS6F7AaiVe9iqzb4+lFyVHbDPmcpuJN+Vla/aMbUImtnavQX45j8ImjogETlhE2xPsarwyUbp5HCBgO1e2gX6pivucM0iEgolftyB9cuFdUviLFxR7/bWSho+g+I28U89KIeogExrv1dmNmLQoKP6uf+vpK2TZN1NTuxe8G+cZWuYX/luqnFuB8Oh4c3aTl2dvcqoe6mhENVfnldt3DmoD9VSz4Ax5AJ0JMLIHFO29V3mWTcmxcbzvD0GVX0n2ahmJwpA9cweCFFTXQyk5Hec6LJKD6tvjHWxtnRGt69DZBILZGUQ33UGOt0bMKy9GJ1z/5IjDjbiW79+yKjuecqndw0+1rxaXrSR5OOex9lgp6uwYLssodCiEK79oDtsVUVZFpM7Ywl2/+PM/goee11zLeZ/KLE3+JzUz40d9pJbZZKCr4KmGrH1bscOCBHyjeSoZEKgCvTu2g0jYyd41Tt+xaA+sGBEY7553JBC3bpLdho3hH6fb+vKcC6PUb27vxJa8qwWBsB5AUG2cVXzf8rQ9lEAEP9IGj5XSr6S+FaUaKlhwomrSk5jLNvc7jeLzl5a3GbBKyizXFFPc1I3zj8qXJhao5JswAxLHfWS0dpMEKvYyeZtjIe8JaqdyelbTILpvFZoJlhxH+1DkIwFRMg+8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015)(921011)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cnlpWXptQmNCcnpoRlN6R25VZVJMK21SWGpxVXMyMmhJUEp4SGwxTC9Za01B?=
 =?utf-8?B?dmZqSzZ6aGxEQ2tCbTZOeDR5K2U1czFWVkFxK1pYckVDekNlWHNqRzQzdVBp?=
 =?utf-8?B?Vyt1VXVLVlJpeERSMmJYWFRoZ2VxVXg2NG5SUWtXa0JqOHhSdkZjV3dYSUg2?=
 =?utf-8?B?cnNid01PWXVBL3d6aElvNWUvbUIxaUQvZS91TDl4T1BsSUZnemVrS09jSjBX?=
 =?utf-8?B?cGdpR2J0ZDlCd1RzcDF6QUtEaG9qbExFV3dER0ZFMVo3cUpJYzJ4VGxjMklI?=
 =?utf-8?B?WjVQU2UxOGprN203ZTBvTEx0N0F1Rno4eDYwVWw0MXc2bUhDSzh6M1BodWdD?=
 =?utf-8?B?dE5OMFd6bHY3dWpieFcwdkJBelZ6ZlE3UXBPaVI0ekkwZU00bCtnODc0SUVj?=
 =?utf-8?B?cjZyUFppdFhxMmhDRFd2WVE5aDhZeGhiekhKUTVQMk5USFV3NVRyKzJ4dllX?=
 =?utf-8?B?VVBKTWU4UUoxTjhjeGpGS1ZvZzZQeThzSlo2TldiVm9oN2kxVU9QMGYxZDIz?=
 =?utf-8?B?Ym45Q1RhWWFVdkJqc1E2VGRWa0s3UDlQTjBZalRqdGd2dndHOGtUaFppbEw1?=
 =?utf-8?B?elRLbkR4MnRpa0IvOVRVc3FQUEhSc3R3ZkxBc3VaWlE2RmR3Zm1EemloSnRY?=
 =?utf-8?B?em92cUZvbVByQnJ3dEZnbk95cDRlMTVWb3JCd0ptbjRGVzRxZ1o2dUpFTWZ1?=
 =?utf-8?B?VHBKVHAwOSs0S0RFSWkxbHhyb3ByUGVCN1JQVXkvWUcvaUh2eVUyazdtWGcv?=
 =?utf-8?B?V21KUmk3cStSSVJTU2VudjAzdFYxSGZ4K3JRNzZJQ3JIdGJIZ0wzVUx3L09S?=
 =?utf-8?B?V2pORWhjVHhCdWVtSUt6WDBSL25La0w0MnNYQmdRUlpqSzFhd3g4RWc3akgw?=
 =?utf-8?B?Qzcvak54SGkxWEVhK0R4dDBZTUFNNEdXem1JN1Y3dEVlSFdVT2I3MXMvYnFV?=
 =?utf-8?B?MkMrVTVvRE1MdWl6OXZwdmxvRHI3WDBHRU1saVIyRVVQRWovalNQbGtvSk5H?=
 =?utf-8?B?N3BtWGVxcHdNSXh2RHBtWkZBbTFkRWM3YW5CcThNUTdwSDRiUnJHcnVzQ1h3?=
 =?utf-8?B?MXVVREtjc1QreFZZYUNnaU4ycnRiLzI3SDVxSWdaMjExd0FrUFhYZGlJdjVl?=
 =?utf-8?B?L0FUaklQTHhrTlJMUHhPQmE5V3lrZ21UQzllZWlUenJReVJuZlZ3cFNRUDZU?=
 =?utf-8?B?OXJrN00zYzFBd3JsVEdJamF1d0FlNHZBcXd1ZDBFVlFSZkRlTjJFNW1Sdk12?=
 =?utf-8?B?R0pQV1A1b2RoWWFaR01EQjFPMko0ZzJUV01WRlBiRllmUmpvSGFSdEhUUVB0?=
 =?utf-8?B?bU1pNXJpVElyOE1PNVVKN3A2eFFhTFRpaGtrU05OTVIydldXMjc2ZElvSndF?=
 =?utf-8?B?Qk9tYWJySjczRldVMmIzb1Yzbno1a0dZcDZEQ3V3ZkgyNnlFVVRyUGQrR1hL?=
 =?utf-8?B?cDN6NTQ3NGdFM2FjZElGZnpjYkVnZG8rblNaQXNLTG5NY3A1ODJXSG5hSzJT?=
 =?utf-8?B?TWMxcWF4NlF3bUEvM1hOTFQyRTJXY0RzeGZ6Sjd6OG5zdkEvUHkzV2J0U2No?=
 =?utf-8?B?ZXJwNkhsNUR4Q09nL0F3T0lzREgyKzcyeCtRSjIwbGdrUmQ2YW1qUHpNN0tE?=
 =?utf-8?B?OEhpaG05bkNObmgwU1Y1d3pjRDJ3NmcrV0pGQ1MvUFJyMnJtblViVGlEL0Z4?=
 =?utf-8?B?aFkrNU5UQ0F0N2pUQXJxcWNjUjNaWmxRUnJ3elVqVnNmTWhZK3lwQ3F6RU9L?=
 =?utf-8?B?NWp4Y1E3bjh2TzZRWUFtOVQyRFBPQ1Rjb2Z3KzhkT2NXMlBJYnBtcFhGcWxp?=
 =?utf-8?B?VmViYXBNOUhMVGd0YVY5dGo0dW16L3FheHhoMnYySG1UcXpCN3JVTkhlMDRy?=
 =?utf-8?B?T3FtSGdKR05XNmZNTnhrRGR6eERmaVlNZ0J0NlNmeWtHUlFERjNGNUEyV0hk?=
 =?utf-8?B?U3NKd3ZqQ1BZbW9wYkJiSEg1WEdIVC9xN2dTZGJyQ3FadjdtQTNwaWRYTmpB?=
 =?utf-8?B?cHR5c0N1cmh6Qm9SNTFwS1hTNlhJLy9jSFNwRy9DemlNY2RVSkp1MkptM083?=
 =?utf-8?B?L0ttZlBZeUNYeFJxWlIwN2ViT29CbHV3Qk1ZdDhNbkpDL1h3TTl6VUxFaGNk?=
 =?utf-8?B?bVpUZUtHOS9xSU9ZMzZONEtoN1YwL3FVbFhrRExGWXZBMWVralhLcjRNc1dP?=
 =?utf-8?Q?HZxINFKPX63PspAFSGM+9Y0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4AA8000FC3819F4ABA96DD39C0CF30AA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c94fb4d9-c1ab-4a7c-b18d-08dc5e37d056
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Apr 2024 17:08:19.0786
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GyKKyraqporDQOE7KleNUTqRFjHJ21jT6xCrloqqP81kVO9bORkjrPb88i36JUSpW8ilqKmdDONa/qtyYmbIcFJNPx7KXw0I+msxs8kxKFY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6115
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTAzLTIxIGF0IDA5OjM3IC0wNzAwLCBSZWluZXR0ZSBDaGF0cmUgd3JvdGU6
DQo+IEZyb206IElzYWt1IFlhbWFoYXRhIDxpc2FrdS55YW1haGF0YUBpbnRlbC5jb20+DQo+IA0K
PiBBZGQgS1ZNX0NBUF9YODZfQVBJQ19CVVNfRlJFUVVFTkNZIGNhcGFiaWxpdHkgdG8gY29uZmln
dXJlIHRoZSBBUElDDQo+IGJ1cyBjbG9jayBmcmVxdWVuY3kgZm9yIEFQSUMgdGltZXIgZW11bGF0
aW9uLg0KPiBBbGxvdyBLVk1fRU5BQkxFX0NBUEFCSUxJVFkoS1ZNX0NBUF9YODZfQVBJQ19CVVNf
RlJFUVVFTkNZKSB0byBzZXQgdGhlDQo+IGZyZXF1ZW5jeSBpbiBuYW5vc2Vjb25kcy4gV2hlbiB1
c2luZyB0aGlzIGNhcGFiaWxpdHksIHRoZSB1c2VyIHNwYWNlDQo+IFZNTSBzaG91bGQgY29uZmln
dXJlIENQVUlEIGxlYWYgMHgxNSB0byBhZHZlcnRpc2UgdGhlIGZyZXF1ZW5jeS4NCj4gDQo+IFZp
c2hhbCByZXBvcnRlZCB0aGF0IHRoZSBURFggZ3Vlc3Qga2VybmVsIGV4cGVjdHMgYSAyNU1IeiBB
UElDIGJ1cw0KPiBmcmVxdWVuY3kgYnV0IGVuZHMgdXAgZ2V0dGluZyBpbnRlcnJ1cHRzIGF0IGEg
c2lnbmlmaWNhbnRseSBoaWdoZXIgcmF0ZS4NCj4gDQo+IFRoZSBURFggYXJjaGl0ZWN0dXJlIGhh
cmQtY29kZXMgdGhlIGNvcmUgY3J5c3RhbCBjbG9jayBmcmVxdWVuY3kgdG8NCj4gMjVNSHogYW5k
IG1hbmRhdGVzIGV4cG9zaW5nIGl0IHZpYSBDUFVJRCBsZWFmIDB4MTUuIFRoZSBURFggYXJjaGl0
ZWN0dXJlDQo+IGRvZXMgbm90IGFsbG93IHRoZSBWTU0gdG8gb3ZlcnJpZGUgdGhlIHZhbHVlLg0K
PiANCj4gSW4gYWRkaXRpb24sIHBlciBJbnRlbCBTRE06DQo+IMKgwqDCoCAiVGhlIEFQSUMgdGlt
ZXIgZnJlcXVlbmN5IHdpbGwgYmUgdGhlIHByb2Nlc3NvcuKAmXMgYnVzIGNsb2NrIG9yIGNvcmUN
Cj4gwqDCoMKgwqAgY3J5c3RhbCBjbG9jayBmcmVxdWVuY3kgKHdoZW4gVFNDL2NvcmUgY3J5c3Rh
bCBjbG9jayByYXRpbyBpcw0KPiDCoMKgwqDCoCBlbnVtZXJhdGVkIGluIENQVUlEIGxlYWYgMHgx
NSkgZGl2aWRlZCBieSB0aGUgdmFsdWUgc3BlY2lmaWVkIGluDQo+IMKgwqDCoMKgIHRoZSBkaXZp
ZGUgY29uZmlndXJhdGlvbiByZWdpc3Rlci4iDQo+IA0KPiBUaGUgcmVzdWx0aW5nIDI1TUh6IEFQ
SUMgYnVzIGZyZXF1ZW5jeSBjb25mbGljdHMgd2l0aCB0aGUgS1ZNIGhhcmRjb2RlZA0KPiBBUElD
IGJ1cyBmcmVxdWVuY3kgb2YgMUdIei4NCj4gDQo+IFRoZSBLVk0gZG9lc24ndCBlbnVtZXJhdGUg
Q1BVSUQgbGVhZiAweDE1IHRvIHRoZSBndWVzdCB1bmxlc3MgdGhlIHVzZXINCj4gc3BhY2UgVk1N
IHNldHMgaXQgdXNpbmcgS1ZNX1NFVF9DUFVJRC4gSWYgdGhlIENQVUlEIGxlYWYgMHgxNSBpcw0K
PiBlbnVtZXJhdGVkLCB0aGUgZ3Vlc3Qga2VybmVsIHVzZXMgaXQgYXMgdGhlIEFQSUMgYnVzIGZy
ZXF1ZW5jeS4gSWYgbm90LA0KPiB0aGUgZ3Vlc3Qga2VybmVsIG1lYXN1cmVzIHRoZSBmcmVxdWVu
Y3kgYmFzZWQgb24gb3RoZXIga25vd24gdGltZXJzIGxpa2UNCj4gdGhlIEFDUEkgdGltZXIgb3Ig
dGhlIGxlZ2FjeSBQSVQuIEFzIHJlcG9ydGVkIGJ5IFZpc2hhbCB0aGUgVERYIGd1ZXN0DQo+IGtl
cm5lbCBleHBlY3RzIGEgMjVNSHogdGltZXIgZnJlcXVlbmN5IGJ1dCBnZXRzIHRpbWVyIGludGVy
cnVwdCBtb3JlDQo+IGZyZXF1ZW50bHkgZHVlIHRvIHRoZSAxR0h6IGZyZXF1ZW5jeSB1c2VkIGJ5
IEtWTS4NCj4gDQo+IFRvIGVuc3VyZSB0aGF0IHRoZSBndWVzdCBkb2Vzbid0IGhhdmUgYSBjb25m
bGljdGluZyB2aWV3IG9mIHRoZSBBUElDIGJ1cw0KPiBmcmVxdWVuY3ksIGFsbG93IHRoZSB1c2Vy
c3BhY2UgdG8gdGVsbCBLVk0gdG8gdXNlIHRoZSBzYW1lIGZyZXF1ZW5jeSB0aGF0DQo+IFREWCBt
YW5kYXRlcyBpbnN0ZWFkIG9mIHRoZSBkZWZhdWx0IDFHaHouDQo+IA0KPiBUaGVyZSBhcmUgc2V2
ZXJhbCBvcHRpb25zIHRvIGFkZHJlc3MgdGhpczoNCj4gMS4gTWFrZSB0aGUgS1ZNIGFibGUgdG8g
Y29uZmlndXJlIEFQSUMgYnVzIGZyZXF1ZW5jeSAodGhpcyBzZXJpZXMpLg0KPiDCoMKgIFBybzog
SXQgcmVzZW1ibGVzIHRoZSBleGlzdGluZyBoYXJkd2FyZS7CoCBUaGUgcmVjZW50IEludGVsIENQ
VXMNCj4gwqDCoMKgwqDCoMKgwqAgYWRhcHRzIDI1TUh6Lg0KPiDCoMKgIENvbjogUmVxdWlyZSB0
aGUgVk1NIHRvIGVtdWxhdGUgdGhlIEFQSUMgdGltZXIgYXQgMjVNSHouDQo+IDIuIE1ha2UgdGhl
IFREWCBhcmNoaXRlY3R1cmUgZW51bWVyYXRlIENQVUlEIGxlYWYgMHgxNSB0byBjb25maWd1cmFi
bGUNCj4gwqDCoCBmcmVxdWVuY3kgb3Igbm90IGVudW1lcmF0ZSBpdC4NCj4gwqDCoCBQcm86IEFu
eSBBUElDIGJ1cyBmcmVxdWVuY3kgaXMgYWxsb3dlZC4NCj4gwqDCoCBDb246IERldmlhdGVzIGZy
b20gVERYIGFyY2hpdGVjdHVyZS4NCj4gMy4gTWFrZSB0aGUgVERYIGd1ZXN0IGtlcm5lbCB1c2Ug
MUdIeiB3aGVuIGl0J3MgcnVubmluZyBvbiBLVk0uDQo+IMKgwqAgQ29uOiBUaGUga2VybmVsIGln
bm9yZXMgQ1BVSUQgbGVhZiAweDE1Lg0KPiA0LiBDaGFuZ2UgQ1BVSUQgbGVhZiAweDE1IHVuZGVy
IFREWCB0byByZXBvcnQgdGhlIGNyeXN0YWwgY2xvY2sgZnJlcXVlbmN5DQo+IMKgwqAgYXMgMSBH
SHouDQo+IMKgwqAgUHJvOiBUaGlzIGhhcyBiZWVuIHRoZSB2aXJ0dWFsIEFQSUMgZnJlcXVlbmN5
IGZvciBLVk0gZ3Vlc3RzIGZvciAxMw0KPiDCoMKgwqDCoMKgwqDCoCB5ZWFycy4NCj4gwqDCoCBQ
cm86IFRoaXMgcmVxdWlyZXMgY2hhbmdpbmcgb25seSBvbmUgaGFyZC1jb2RlZCBjb25zdGFudCBp
biBURFguDQo+IMKgwqAgQ29uOiBJdCBkb2Vzbid0IHdvcmsgd2l0aCBvdGhlciBWTU1zIGFzIFRE
WCBpc24ndCBzcGVjaWZpYyB0byBLVk0uDQo+IMKgwqAgQ29uOiBDb3JlIGNyeXN0YWwgY2xvY2sg
ZnJlcXVlbmN5IGlzIGFsc28gdXNlZCB0byBjYWxjdWxhdGUgVFNDDQo+IMKgwqDCoMKgwqDCoMKg
IGZyZXF1ZW5jeS4NCj4gwqDCoCBDb246IElmIGl0IGlzIGNvbmZpZ3VyZWQgdG8gdmFsdWUgZGlm
ZmVyZW50IGZyb20gaGFyZHdhcmUsIGl0IHdpbGwNCj4gwqDCoMKgwqDCoMKgwqAgYnJlYWsgdGhl
IGNvcnJlY3RuZXNzIG9mIElOVEVMLVBUIE1pbmkgVGltZSBDb3VudCAoTVRDKSBwYWNrZXRzDQo+
IMKgwqDCoMKgwqDCoMKgIGluIFREcy4NCj4gDQo+IFJlcG9ydGVkLWJ5OiBWaXNoYWwgQW5uYXB1
cnZlIDx2YW5uYXB1cnZlQGdvb2dsZS5jb20+DQo+IENsb3NlczoNCj4gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvbGttbC8yMDIzMTAwNjAxMTI1NS40MTYzODg0LTEtdmFubmFwdXJ2ZUBnb29nbGUu
Y29tLw0KDQpJcyBDbG9zZXMgYXBwcm9wcmlhdGUsIGdpdmVuIHRoZSBpc3N1ZSBWaXNoYWwgaGl0
IHdhcyBvbiBub24tdXBzdHJlYW0gY29kZT8NCg0KPiBTaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1h
aGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0KPiBDby1kZXZlbG9wZWQtYnk6IFJlaW5l
dHRlIENoYXRyZSA8cmVpbmV0dGUuY2hhdHJlQGludGVsLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
UmVpbmV0dGUgQ2hhdHJlIDxyZWluZXR0ZS5jaGF0cmVAaW50ZWwuY29tPg0KDQpSZXZpZXdlZC1i
eTogUmljayBFZGdlY29tYmUgPHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPg0KDQo=

