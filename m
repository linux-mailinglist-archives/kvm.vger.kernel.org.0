Return-Path: <kvm+bounces-12190-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D8182880826
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 00:24:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FBA31F22C6B
	for <lists+kvm@lfdr.de>; Tue, 19 Mar 2024 23:24:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0E1C5FDB5;
	Tue, 19 Mar 2024 23:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W1Jcpkp4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 108E35FDA1;
	Tue, 19 Mar 2024 23:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710890685; cv=fail; b=Td7eJaqn4VYXU3+nJdmQQcccKSN8+p/DogQUdGLm8qk08xM4laY+gl3dARalZXcKhh1v4XS0iqGDXsmUinzDfQOckwFzeiFr/szw3Y9J70OuhtViHUmrBMuBkGcL7M6TfaU+GjbY9xUJ3+Fk2FE2zstcP3yQFc1NFeAK+0LoTmE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710890685; c=relaxed/simple;
	bh=83tNj3IS6/ULwbobB+yWSGsY2ywawdYgZkuU+YIMxIw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=a2c0eH5SqXhNSrcblXdt1XfDewsUC5grIvLal2kouX0LJFFwsArRFl9GsDFDnqQb2VJG7oYp5SdNUEykCOnaQf6cO7DMyemAdLdmih8NtshILIRs14H6xjSRNor3dwgQhNuyne4RiK2fhoyr7Z9s1OXf+4Uv+dOJb+KRqqgaWkw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W1Jcpkp4; arc=fail smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710890684; x=1742426684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=83tNj3IS6/ULwbobB+yWSGsY2ywawdYgZkuU+YIMxIw=;
  b=W1Jcpkp4R9RtnZMlARTQau0NzzFvM5LzdISodlS1GaDGv7HX0IXT4FBh
   1EdJb9bl7KD6VJCnslcr9Am4fomj749vHRU/9b4YdKabQT/Wzupe1yuhD
   JvPh3iLt4NwaPjZBJ8l/jv65G6QIeOgB8k/+rsPb2vVNSWlsiR7OHgGtt
   gcWClUk8NNV3ErftfB1OLXwgcL1Z+a5vZ0Z+WUudz5+r+/7+PBO2vo+4U
   HN0XL5jUcbDWAFuw3s2AHjOw976SeUs++88xgKutYn9zqwC4pVhNtJ77c
   Qg64vyh77sZ1jB8xkLPKKe7VJi3D78F7vfe2zGJ77DvHZiDMgWVhlNSVp
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11018"; a="9589236"
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="9589236"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2024 16:24:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,138,1708416000"; 
   d="scan'208";a="13973607"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa009.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 19 Mar 2024 16:24:41 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 16:24:40 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 19 Mar 2024 16:24:40 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 19 Mar 2024 16:24:40 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 19 Mar 2024 16:24:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HFip3h66Of11xCBXtKB0zpHjdlFjBiwXW5Ik9gOamh3Flpv57zfr2BWPMMCCrsHg9KmbhdPcmm7UC/nbSMUDaX4eTlRAh5ioCocFJo5x4NxvhvbyfN/6fNsnimOn8A5Mj3gCPznycpP25JK+9Q2aU3WniIB3k8kWUdaUQ/IzdQynKUPusuKzGWHtuOhj3Y3jgEM6/mlg7MxKN7mgpjzk/ThH/8N7OeuB/+nWclJWakC9uRdMBdzVxOvHwy9HJlj3qt+jjNrqrrVpLpF6DmGm9H3Z/yN+wUS1a4aNnoFQNNmiN1qANL/DtrXCHlmvsGAkbQyBdoOx2lfXbFD/kUjWng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83tNj3IS6/ULwbobB+yWSGsY2ywawdYgZkuU+YIMxIw=;
 b=C76OBQEpE32z5siDGUHMRKd53z2wT7Wg5NV9dY0l28IDEvQlbuXkxpqjuMrQjGew/VmdoADHfCgbeXZNaXeflYBDfyLp9nASgO0z/px124OH4ZFdhib7o1y5ER2Wbxo8rGMZkM8C36RYBV/VBo/TZGuryR6Wn4vloVhATtXgSdkQWeAC3CuRLnnkv+4H09qp67i6XuH+F8Mib5/h7HVyvjt+GXHsfZtunAkZ2Ib1dYboZEiDPIZgOxqrym8ZNrVlHkrhSlp8vZWMDgR4xzkLsjDFocBnShV27Pg4QWDZfMaugN/4bFOPI79kDRcY5kihzres/rQea0VmmYXKkjkn9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by BN9PR11MB5307.namprd11.prod.outlook.com (2603:10b6:408:118::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.12; Tue, 19 Mar
 2024 23:24:38 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7409.010; Tue, 19 Mar 2024
 23:24:38 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "Yuan, Hang" <hang.yuan@intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Chen, Bo2" <chen.bo@intel.com>, "sagis@google.com"
	<sagis@google.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"Aktas, Erdem" <erdemaktas@google.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Yao, Yuan" <yuan.yao@intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
Subject: Re: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Topic: [PATCH v19 029/130] KVM: TDX: Add C wrapper functions for
 SEAMCALLs to the TDX module
Thread-Index: AQHadnqew2ceoSLqG0SnDLEWlzYIqrE/vEEA
Date: Tue, 19 Mar 2024 23:24:37 +0000
Message-ID: <3370738d1f6d0335e82adf81ebd2d1b2868e517d.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
In-Reply-To: <7cfd33d896fce7b49bcf4b7179d0ded22c06b8c2.1708933498.git.isaku.yamahata@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|BN9PR11MB5307:EE_
x-ms-office365-filtering-correlation-id: 8ea3c40a-98bf-4c10-9b86-08dc486bbeda
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ByUYfktRpXke4ojPOqvybbFdRQEiMdJ+Ox/aFBXHYTnIqsoSWX/yMEd7ONmKCcg95aFgBe+9MKoy6caPNZWBIuoAtxQdx33AxRU0zf3612+rYDlmkhWFagWMXFWCh6l8uu6ZUkLNCLRA8hR1ql//rOKzg2PkOIyc2EU1xZsxcxGPfrXPtvP93e4av/nha1F3b/J1igci3Ns/kHsEjnxZIiNhP9abCb0klvp5oNZrFwuMyRu14nwvn4sgoR6gHPpUqrkA0iS/5NS7nNZxMkhtC2W8jazK5NhoUXoOjBFPic5QqONnFkpa5zJGbR5X3N5Vuy85fe43PaV7KD+buVu8xlsONuLND0acSw0qTM7etjkY4TIcfKcV7QIe3K3hhzDRxdwIeg55No/3eg5eLJWEMOD9r78Ep66Y2G1FhiiTFkEHS5AOicdONppgtpaAG2qkou47C1jI0kbmDr50VRotABR7k7TcCa+26MGOmMWSunoXBJwBc/8t+ic88Px+FRNF397zgak6dcXfZE4RCthJnhpDTvesIdQycEWSU7rzWlDPTmCqWzYrhhhf9YnzcSFqdCmJ7uSZb06DL1zZOXhtn/dS/CHMQ9Qtg3Hn8GAMU1EUELCX3arnpsYrtRcznv/Ftr7Vwn6p8zY7YMO4gzVz9vAchEfEdw60ZGVIhBYN1r0doU7WEIZmUoOpiJep8qhnf/DGGw2KA5WU0hiDPqLXGz5lknkGeKtxCMJ9/HvbYU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXdJbm15bUltcS9qWUFvdmV2eElkUEZCbHlIZ3pwNDlXMGZvNmM3R1ZiQ1hO?=
 =?utf-8?B?bWxVdnRvQjBFcjlqajBndGo1MGYrZGM5akswRHdydmlvSnRvVGtlc2ZFOWE5?=
 =?utf-8?B?aE91QlpJb3NBelV1L3JONmJEZ0VBaWd2VmIxSE1jWERmTEVMcURSK1lGVity?=
 =?utf-8?B?THM0aWs5N1lzUFQ5d1hDZWFZdU5ncGlWK3k1Q0pacXJGYWJUc3BGWHJRazRE?=
 =?utf-8?B?N1Evalh2RGxaTmVLb2VTaE5UdGNxcko0TXpaUVRMeVJaRXNtQnI1TlNUK3pZ?=
 =?utf-8?B?dEZxd2k2WVBsa2tUdWVYdnk2bWhRS2tsWEtGdTNiUVBVWFhDWTRKVGlJUHZC?=
 =?utf-8?B?UGlQTCtQZWlTRHA0N29RVEp5aDdaUG1ST25yR3pZUXQ4dU9JMVl0dmM5Z1E0?=
 =?utf-8?B?azNjL291UXkrY3RSYkJ0V3lCOVlRcEdBZ0hkUDVpZzlLNmRLTHJ6UWc5MFIw?=
 =?utf-8?B?S1lQNzNXTFJiNEJDdDNPSFliWFYvZTNhMHFaeFI5MS9uMWRLaHdWdFJpaGgr?=
 =?utf-8?B?blY5cWZ4VlBzZ3FuS1djZ2RRMzBTK2Y5Z0NmNUNYYW96UlpZT1UzQmZBa0Za?=
 =?utf-8?B?NjVYY1hMYngxRDkxbzFMNVpKaTJQYUdoWmxDMm5VcGJXaXJTaEZpKzBGdHJa?=
 =?utf-8?B?c3dXbFg1RXVmYkJEWm1jRUhvUU5rckxJczVzWUZDSHJxWXloeDFaYjRZdUww?=
 =?utf-8?B?UEw3WWRFUkJ6ZUNKeHVMMWx5SUdMU3k0Y1FiSDJWTE5vbUVFb1pTa0ZJZVp0?=
 =?utf-8?B?NWNWTC9JcHlaR3p4UkFHRHFhd0VteDFmOUtkUUJob3h1eGR0NWRhLzd6Z29v?=
 =?utf-8?B?MHdiQ2RheTZFWHBabngzTVdIMjhkYjVQRFZoOWNBV0dJYldZclFYQjdEdjdw?=
 =?utf-8?B?MEVLTCtQenE1SmtSSW9PbEJjbEJFS0V3VXIyNEhnc2JLd3BtS2E3NkhmN3U3?=
 =?utf-8?B?d2x0OUFuQ0VISXc4QlU5ODNHSGtCNzJCblhSbGJXVE1IYzg0bGc5cHRabloy?=
 =?utf-8?B?anF1YXpoVFA3dzkrcGJ5WWVuSnl0SlRBUkNaMm9tbVhXSHYvNGxsRFA2bUFU?=
 =?utf-8?B?Qktjc0NBWUFQaFJVSzZlN3Y1cklHUUIwSXEzRTdyQ3g5WFB5MGFQK2NuMEFQ?=
 =?utf-8?B?MVNpUG9SKzl6bW9QMUFtZHdCUDZ4czQ2d0NlZDh4TngxbFVHNzJWWVlMWWdN?=
 =?utf-8?B?NXpxdkp0WTJUWFNLZFdYaXdYTTFuV2dTYmY4NmhqMkM1V1NNUVM3bmhmNVp1?=
 =?utf-8?B?ek01Umw0UE1ta1NFcmRuNmFqQnBtR2p5QnBNdzJZT0xxYk1LeEhMR0taaHJu?=
 =?utf-8?B?eGJqaWJtL0ZjaFF5UFFjckw5a1MzMjJpUjl6eUFLajVzTHU2QUJtc0djaGxp?=
 =?utf-8?B?dFBRQ3VDcitsOW8xd2Y3TGMwYjZMOVc3YWtSSHNNYXpEaWNXelUzNDkrUDYy?=
 =?utf-8?B?b0RPWnhKejBjenBESTRzcWxRV2tqcy9IUVRGRzFkNnA2OHphMFViK0NJYUZD?=
 =?utf-8?B?RFB6SzVzNlduVjMzVWdiUGxRQ21WNCtQaGJCTjY2WDVXeUhidkNJMHBidkpi?=
 =?utf-8?B?eTQ2WXFoSVgvSmw4SEZMc1FwajM5U3NIMUNoZnRpQUVrVmhHTU53L2Y0N0FG?=
 =?utf-8?B?TTFqcjk4QjgremJ0ZzBLQkdQRG4xUjZqMzRGMnhpd01reFJ2Nm1NdXBtUTlP?=
 =?utf-8?B?SElmWk9GWVIyanNqTHliTmh3Rm5sRm8xcHh2NzlHR1hUQVdESVZYU09OZlFm?=
 =?utf-8?B?U1VnOU5ta2FUTEZWT2N4RGpTOWxjVXdtN1ZMdzdoNGplNm9jTG1TWkFlTmlO?=
 =?utf-8?B?cXJ5S2QwS1dlV1JxZDh1ZlIrK0JscVdnczl6Q2tiTHg0SkhwR2wwY1VrdmZp?=
 =?utf-8?B?dDRQYjhHbnduZ3pDTlA3T0k5NlVXT29oYVdoSWtZbnBuSVVPUGt2Y29rRE1k?=
 =?utf-8?B?VmZDSU9JSS9QSnd2S1RKTXZyRUpxUERHTzA4R203dTdmK25oWXVGQjFGa3ZK?=
 =?utf-8?B?QkRuNzg5VUhwY1ZMRkR1TnM0NW5kK3k2MCtXbmFRUjBZS1FNVjFxcW1Mb0Iw?=
 =?utf-8?B?ZFBxZkdxRjcyWjRXUG52K0Zhak93WXNTTDJXS2RKc1NzRHgxdWdQemxxcWMr?=
 =?utf-8?B?cmtsbm9uM0Jzbi9ncHZGaGVNY2ZZK0xYWDBob1NoYUI3ZERpWlMwZXRlSGcw?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A3E4B04C38E0847A6C862EDDB1E12AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ea3c40a-98bf-4c10-9b86-08dc486bbeda
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Mar 2024 23:24:38.0114
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kZA3/4ZGWnSokehBJ9W5kbM0+QPVQHk961zDq199yw2pnuDZdU3dD2SBV3S8uKo5Tn2WJx2/ClIu7K6pDxjhxadw734IA1VAXpoiAJ66d3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5307
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTAyLTI2IGF0IDAwOjI1IC0wODAwLCBpc2FrdS55YW1haGF0YUBpbnRlbC5j
b20gd3JvdGU6DQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgdTY0IHRkaF9tZW1fc2VwdF9hZGQoaHBh
X3QgdGRyLCBncGFfdCBncGEsIGludCBsZXZlbCwNCj4gaHBhX3QgcGFnZSwNCj4gK8KgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBzdHJ1Y3QgdGR4X21vZHVsZV9hcmdzICpvdXQpDQo+ICt7DQo+ICvCoMKgwqDCoMKgwqDCoHN0
cnVjdCB0ZHhfbW9kdWxlX2FyZ3MgaW4gPSB7DQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAucmN4ID0gZ3BhIHwgbGV2ZWwsDQo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqAucmR4ID0gdGRyLA0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLnI4ID0gcGFn
ZSwNCj4gK8KgwqDCoMKgwqDCoMKgfTsNCj4gKw0KPiArwqDCoMKgwqDCoMKgwqBjbGZsdXNoX2Nh
Y2hlX3JhbmdlKF9fdmEocGFnZSksIFBBR0VfU0laRSk7DQo+ICvCoMKgwqDCoMKgwqDCoHJldHVy
biB0ZHhfc2VhbWNhbGwoVERIX01FTV9TRVBUX0FERCwgJmluLCBvdXQpOw0KPiArfQ0KDQpUaGUg
Y2FsbGVyIG9mIHRoaXMgbGF0ZXIgaW4gdGhlIHNlcmllcyBsb29rcyBsaWtlIHRoaXM6DQoNCgll
cnIgPSB0ZGhfbWVtX3NlcHRfYWRkKGt2bV90ZHgsIGdwYSwgdGR4X2xldmVsLCBocGEsICZvdXQp
Ow0KCWlmICh1bmxpa2VseShlcnIgPT0gVERYX0VSUk9SX1NFUFRfQlVTWSkpDQoJCXJldHVybiAt
RUFHQUlOOw0KCWlmICh1bmxpa2VseShlcnIgPT0gKFREWF9FUFRfRU5UUllfU1RBVEVfSU5DT1JS
RUNUIHwNClREWF9PUEVSQU5EX0lEX1JDWCkpKSB7DQoJCXVuaW9uIHRkeF9zZXB0X2VudHJ5IGVu
dHJ5ID0gew0KCQkJLnJhdyA9IG91dC5yY3gsDQoJCX07DQoJCXVuaW9uIHRkeF9zZXB0X2xldmVs
X3N0YXRlIGxldmVsX3N0YXRlID0gew0KCQkJLnJhdyA9IG91dC5yZHgsDQoJCX07DQoNCgkJLyog
c29tZW9uZSB1cGRhdGVkIHRoZSBlbnRyeSB3aXRoIHNhbWUgdmFsdWUuICovDQoJCWlmIChsZXZl
bF9zdGF0ZS5sZXZlbCA9PSB0ZHhfbGV2ZWwgJiYNCgkJICAgIGxldmVsX3N0YXRlLnN0YXRlID09
IFREWF9TRVBUX1BSRVNFTlQgJiYNCgkJICAgICFlbnRyeS5sZWFmICYmIGVudHJ5LnBmbiA9PSAo
aHBhID4+IFBBR0VfU0hJRlQpKQ0KCQkJcmV0dXJuIC1FQUdBSU47DQoJfQ0KDQpUaGUgaGVscGVy
IGFic3RyYWN0cyBzZXR0aW5nIHRoZSBhcmd1bWVudHMgaW50byB0aGUgcHJvcGVyIHJlZ2lzdGVy
cw0KZmllbGRzIHBhc3NlZCBpbiwgYnV0IGRvZXNuJ3QgYWJzdHJhY3QgcHVsbGluZyB0aGUgcmVz
dWx0IG91dCBmcm9tIHRoZQ0KcmVnaXN0ZXIgZmllbGRzLiBUaGVuIHRoZSBjYWxsZXIgaGFzIHRv
IG1hbnVhbGx5IGV4dHJhY3QgdGhlbSBpbiB0aGlzDQp2ZXJib3NlIHdheS4gV2h5IG5vdCBoYXZl
IHRoZSBoZWxwZXIgZG8gYm90aD8NCg==

