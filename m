Return-Path: <kvm+bounces-13900-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 534BF89C861
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 17:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A3F5286795
	for <lists+kvm@lfdr.de>; Mon,  8 Apr 2024 15:33:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 157471419B3;
	Mon,  8 Apr 2024 15:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q+JCdmJU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34598140E37;
	Mon,  8 Apr 2024 15:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712590368; cv=fail; b=KNxW9Q+kdF9f4vfvDbTboNyFcRBpmA8N8o75sPlVf4/1YmzgVhiNT8c6A0wgvdyeuARDY03oz04Mh4RKTFC39Hxu3sgw/E1pzXsgZJOwRQu2w7u/or5mJWuviteJxOe33TSZd1rP41hxA67aMepcmbcwTeF+6mQF60NvW+f6ti0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712590368; c=relaxed/simple;
	bh=9LI73XGDCxA6keieUvPY7JSX0vVR8wquhQ69Ksm9xXQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=naa8PLFNQ22uRLd58HEAqO7OlEQZ4wQU2nepa9A9ZGb7o01HuKVBKnTiWoFsGgEyTGYl1dVBRLBzLvwKIVSQKEpz+k6Kk5th86PEgSJgiQtPdTc7Cmzzs+y6FM7g4IqyMqGHdAkX+7Is9HZDt3dJTyXPHx82SyYXVRHSFxOrams=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q+JCdmJU; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712590366; x=1744126366;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9LI73XGDCxA6keieUvPY7JSX0vVR8wquhQ69Ksm9xXQ=;
  b=Q+JCdmJU+VAnQyiQJQ1aAH2RNW8oNAdlOJVvaC6QLvnD6RE37jsBEQBU
   SygsrC/8Nnm/OksvuU+gzg3c8tQ088WyHSb/2VyUmyUG9JMGQvdiXhkZA
   thrYuvyj3SrIfsAZMgy6Sqp9nUod64Ufw7uxDmsy4HzqX0nmIHod+gsL8
   try3rFyJm368RvPY1m8AYLu8j3UI3X3dyLUzrv0Qyp7leegifwyV7PjfE
   c5opUVzm8+txppWR6OFd0F7GXtyzUyMuNHvGmLv5IVQgHjPfFhD7Suu5A
   SZUb7MAgoZHFrEXECJNAN+EJ9mbxBbYLYsEqb6diAUFLBkf35tdwlJocN
   g==;
X-CSE-ConnectionGUID: RhtWDx7+Qiq3OeDZ+XJ7Dg==
X-CSE-MsgGUID: YqqwcXCBQjyxbpCmLQ55Kg==
X-IronPort-AV: E=McAfee;i="6600,9927,11038"; a="7740243"
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="7740243"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Apr 2024 08:32:46 -0700
X-CSE-ConnectionGUID: 0YrDQ2Y4TFOwISFxQF7kOA==
X-CSE-MsgGUID: AO/rB+o2QAO+JjFknf85Dg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,187,1708416000"; 
   d="scan'208";a="20484527"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 08 Apr 2024 08:32:45 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 08:32:45 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 8 Apr 2024 08:32:44 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 8 Apr 2024 08:32:44 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.40) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 8 Apr 2024 08:32:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b71UMRnfW46UvfDTsWQBB7MoMH3ZOeDL/r2K/Fo6puimrwSnGa5ya5OR7SOR2oWqsHJR3iaX9+CEZJW8PtCl02Gv3eBX4FJoSha+TsBcFZsqaQb8OxrvmPSZV4GrX4qwZlhh2OtKQz5Bj91JiRQMA9gUMifW6H/eqWVneVjy1DGzLGlhRsMbUP4LxG4q2aPnWBv9NoNW/uAlFGXk1KPsSTXOafBXLCGfi/Xeu3U7nG5iwhnZELFQxHQQ22EGSB/91KY/PIaM07RFaJnP9hD+lHky9GS8ppqpObV6Jf5ukgU52FCpbVSwy0qOg2F5UESBdmQ5BDo+jUxfSqijjo4e3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9LI73XGDCxA6keieUvPY7JSX0vVR8wquhQ69Ksm9xXQ=;
 b=REEGDnok8qb/1Pb5smqa7iWAJmkX7lM9lzInW0WyRLbV932WnahoLnXMrTOvAsW9do9k7QAqZ29YK8vF6iY4XQXdrBt2Kvdu3ph3BaNIAYHSU6/0RoQ9uShvBy+4NnG25qgTS3tCWzx1XCyPr+PGzMRP2haltwL1cNLLLUeCHHC7HOhWqZB5UoYvQPwwy4btvr+Wspk39zbLOlhrB7IR5HjkqksgEkjxoExx/aR4cpD4+kN7d/g9uSSHKGrlUq4rceaK/HJLkMiM0DfpDnQHMWYKG4QG07mHRA/E3aOhNi7lOwc0vLRQjvhkbKXXL5EoIVIOwAfJKlsa3c9Os0kYXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CO1PR11MB5153.namprd11.prod.outlook.com (2603:10b6:303:95::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7452.26; Mon, 8 Apr
 2024 15:32:42 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7452.019; Mon, 8 Apr 2024
 15:32:42 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Huang, Kai"
	<kai.huang@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
CC: "Zhang, Tina" <tina.zhang@intel.com>, "isaku.yamahata@gmail.com"
	<isaku.yamahata@gmail.com>, "seanjc@google.com" <seanjc@google.com>, "Yuan,
 Hang" <hang.yuan@intel.com>, "Chen, Bo2" <chen.bo@intel.com>,
	"sagis@google.com" <sagis@google.com>, "isaku.yamahata@linux.intel.com"
	<isaku.yamahata@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Aktas, Erdem" <erdemaktas@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>,
	"sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
Thread-Topic: [PATCH v19 067/130] KVM: TDX: Add load_mmu_pgd method for TDX
Thread-Index: AQHadnqtEwBbn0F4FEyYzDQ1ZvXcVLFajiWAgAGb0ICAAn0RAA==
Date: Mon, 8 Apr 2024 15:32:41 +0000
Message-ID: <78b1024ec3f5868e228baf797c6be98c5397bd49.camel@intel.com>
References: <cover.1708933498.git.isaku.yamahata@intel.com>
	 <bef7033b687e75c5436c0aee07691327d36734ea.1708933498.git.isaku.yamahata@intel.com>
	 <331fbd0d-f560-4bde-858f-e05678b42ff0@linux.intel.com>
	 <20240403173344.GF2444378@ls.amr.corp.intel.com>
	 <a2386cbfc8a4e091f86840df491fb4d999478f44.camel@intel.com>
	 <f61bb57eba91c68e7cf50c4e806de94c2341ad16.camel@intel.com>
	 <3b2c4f57-c58b-4ccb-82fe-4e89e6d21a7a@linux.intel.com>
In-Reply-To: <3b2c4f57-c58b-4ccb-82fe-4e89e6d21a7a@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CO1PR11MB5153:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fSnlw24irnvjqAAIxdvB+DTafzCX62a85SXXYon9A5zYhFjs78Q9YoEExLpTZTWc0DewdDUn6PNUy8OMFszBCeKFftzRw0O9QX+ypallMZXsGbmPfP3X1nLhp44rW1718+pWI5eLZ4adGC4CLoCqU9dVf6GzXDRoySohwz78M1PzgAjY82EJsksUuAkGMq4/8qBSUB4UhBGAf1KeTrY75kSWHJz9E2QK/U+QoukA0lfjmRfd3fgljbjFT5Uywp5JtcpqQjU4pzNakcTBRhRhQvgQL0X2syuVOGj5r0sXvVGqTBijKnKlQK48V55KOwuv+oAHq8zVlETOXK0CBhvh9416g2Uq2Jwix0np5rd5VlV1RI8Q1wHP8Za1M2ssHcHOuO2G/eP/IWUUZ7G4vHjhaaVHGZld56SJPqENU6Kf73bFsJ6jjpeCLja2XD3sURzgBeOQsHTWcCc/o0XrIWHs6tKfbGaR+LTPI+ZrFuIqrMjRprVWlVH/9+URePVlfNFVEhaMDSgX3MQgac75+RMHjI1twD8rZVKWaeap7cANO/SUJBwCaY+z4WbNsZ+SkdzACk0+d8ry2+0Qld0Nm9+xuWOVlbXp+GlU623yE+J56VPbKirgxtWr/iReV+3h9UocDh5Z61zNQvWvr0t5ES4co2jFVb5fVBmuzlqEMSIOQM8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Q0Rha1NIUStZY1NmZmlxWnJiZ0V5LzdjU2RDQmxDTzZUZ2RrenpXTGxLMkoz?=
 =?utf-8?B?NWlCaXdpdmhnUXJuNGF3aUNhdWRQZ1dlRzhYeVRaZW9TMDRaMWRFTWlPWWZn?=
 =?utf-8?B?RElEYXB3eUgxRGlObUk0alRMVTE3Nld5bWNITmZZQWxkS3JBdXgxZjRRcENj?=
 =?utf-8?B?bnlkVlBQRlhnVU40dlV2bDQ4RGc1VERzYzFtdFRRV3pXa3dFa2NRQWVkdVFB?=
 =?utf-8?B?dG1hTFVPRC82dldhcmQ0R1BvU0lnWW9XNlFGQ2RIWG82NFJ0MDFvcWtQcU9D?=
 =?utf-8?B?ZjI1d2hST3RIVHByeW1HMW1maHdSTTMyZTJncWM5Z2s5QXNEaE13ck5Nd3dX?=
 =?utf-8?B?WWU3cjJHL0FEczJaTEpXUmEzaXhsS0Q0LzFwLzhDcEF3enQ1VXhsM3VsdXE3?=
 =?utf-8?B?ZUdGSGo4V2xvbFdZVjltQndqWXkvL2VXSUNiMHREMFpaRWlNdzh4ZVNMRmxr?=
 =?utf-8?B?N3MwR0ZLUndkZGg1aCtlM1N2NVJkUHZGTEx4OG1OcWJOR20vWUhqc1NFeWQ3?=
 =?utf-8?B?TVJYbkZTZmt5NlFXeWVnVFBjT1RQTDkvMHlvOVprSXphM3NDVUVsTGFtM05W?=
 =?utf-8?B?eFJaT0orekxwdmpVcDFFQUJCLzJpbDRUUFQyTy9IdTNxUlhwVFk1bEFLcTRD?=
 =?utf-8?B?ZUNIRnB6bWs1WnF4UGd2Yjcrb0xVZ3BKbHBZTExxVGNHZCt1b2dnU20vbDli?=
 =?utf-8?B?UzM3Mk1idWd0M0NYRncwYUJ1bDVlZ1NPYmw0Tk41TXpmYVBJVkVUVHZXd25D?=
 =?utf-8?B?UzhFbkJjaGxXR1AyQnU2MUpKcFVZdEx1enNRV2NyOXhWSWVDd0gxNVJxbHpy?=
 =?utf-8?B?T1B6R1NScDJoS1pDRmxyOWlVT2s0UHAyL2V2NFN0MVZHRFFzUG4xR2tzdnFV?=
 =?utf-8?B?SnF2MzBVbVZjcWdpb0h3TTVtbnFibVZubjUvbEVHdHEwVnArV0ZkbUVWcnpY?=
 =?utf-8?B?MFBUUi9BWDROaWJUZk5BRnk2aWNEYy9VenIxMVJ5ZGNYTVRFN25jQTNRQmdF?=
 =?utf-8?B?QlJ1UDZ6SHR2WmEwRk0wSGF3TUtXdzJlRXlGQlJxaXg0bnlGM2xVQS9LWHY5?=
 =?utf-8?B?Y2ZVTlNKY25JWnpxcFRhS2VZQTdwT2p5ejlObW5xR043S2VqNjNCcUdWZi9p?=
 =?utf-8?B?MTFUTU54d1NBNkZTZkQ2UEZtcXRLRDduSFh4R0x6eFpiMWw2S08wOHV2WEtI?=
 =?utf-8?B?OHRFSDM3N3RTc1RzSU9nSXJBdVdmSUVzQXdhV1ZwSkhyZUcyZzBsd1oxdjJZ?=
 =?utf-8?B?QmtpdmZOOXlXN1VIUlNLOGZlWW5NTllCa1lHcFM0WlVHTmRNcGVSODlvbWNo?=
 =?utf-8?B?d04rcytXeTUvMHR3UUZPKzBqVXpLVFZGU0ZLVkNRNmlmeTRLYTllMHErWHhu?=
 =?utf-8?B?UFBvVlo1M29lZlhlcGhvazN5Uy9ybEtIc1YwUzZoVGN4d1l0TkVieGFmeThQ?=
 =?utf-8?B?V2VIL0I1bTUxSjgxa0VwalJhWm5PMGNRR0JlWXY0UC82RDlQMjQxMzQwQ2ZP?=
 =?utf-8?B?SG5pcndneVQrRlJRbU56Y2dmaGFzaUtaMVJMUW5ia25mUG80dnZHOEowcWdS?=
 =?utf-8?B?L1paOTBaUTRCQXE5aGdJT1BLcnVhRjIzR2dDdlhqQXVIWVI2NEN3OElZQnBv?=
 =?utf-8?B?VU9keC9helNlNVA1aGwyNENLa1FzZWZKcVlXQUo4QTNjT2tvL3c4NWdxN1Rv?=
 =?utf-8?B?UXlCVHM2WG4rdjAxbGZBbDh4bVRnSXN4MXZmanZ4QXFsdTZMVDhnVTFsV1ln?=
 =?utf-8?B?dU1JbktWMTdpR1pEVmhoQWpmMkh1U0Jya2krb2srMmpNSC8rL29nYk9EZDNY?=
 =?utf-8?B?UzFST3J1NitUKzBuc1MvUzhmMTNZTFFuTFNEUGJZaUFnNDRER25udVRlY3pS?=
 =?utf-8?B?ZXIybkxZWDdSbVAvalIvRGNWNGR6a1FkN0dXZVJtZ1dGNEIvVmNnNlBVR0JO?=
 =?utf-8?B?NTRUZXQydGlQSDdJWlhkUjNjQ0RGOEpwZEhuMkpkb2hsYnJwNGMwZGdwa3Br?=
 =?utf-8?B?VGRPekgvSTlzVVBGNFhYMXpkSmJyNjd0YnFuQmVJWW1TblpUdm8vam1SeXI3?=
 =?utf-8?B?VDdyZkR3b1BOVlg5aHcvUldGV0FDNmRvNHlLSWY0N1BKanI1UDJhQ29SNlBT?=
 =?utf-8?B?YisvNTRmT0lweXJkZThFeitzYm1xTWw0amFMeU5RdnpoVUcyL3l6bEpWdkNh?=
 =?utf-8?B?cEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C4C8E6F1555B024085CFC26D928815FD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5758db68-c6ba-4739-0e9c-08dc57e1216d
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2024 15:32:41.9699
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: U7DQIVp4SVX3LKalMXqGw6NIyv7vaIQypO+XgrJhURGLI6sdGF6SAIz8LYlQ4Zuaq8jYX4bi/BWPG+spWT+6AZiqil1rRlTjt9TiD+s4qbs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5153
X-OriginatorOrg: intel.com

T24gU3VuLCAyMDI0LTA0LTA3IGF0IDA5OjMyICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+ID4g
TG9va3MgZ29vZC7CoCBTb21lIG5pdHMgdGhvdWdoOg0KPiA+IA0KPiA+ID4gS1ZNOiBURFg6IEFk
ZCBsb2FkX21tdV9wZ2QgbWV0aG9kIGZvciBURFgNCj4gPiA+IA0KPiA+ID4gVERYIGhhcyB1c2Vz
IHR3byBFUFQgcG9pbnRlcnMsIG9uZSBmb3IgdGhlIHByaXZhdGUgaGFsZiBvZiB0aGUgR1BBDQo+
ID4gIlREWCB1c2VzIg0KPiA+IA0KPiA+ID4gc3BhY2UgYW5kIG9uZSBmb3IgdGhlIHNoYXJlZCBo
YWxmLiBUaGUgcHJpdmF0ZSBoYWxmIHVzZWQgdGhlIG5vcm1hbA0KPiA+ICJ1c2VkIiAtPiAidXNl
cyINCj4gPiANCj4gPiA+IEVQVF9QT0lOVEVSIHZtY3MgZmllbGQgYW5kIGlzIG1hbmFnZWQgaW4g
YSBzcGVjaWFsIHdheSBieSB0aGUgVERYIG1vZHVsZS4NCj4gPiBQZXJoYXBzIGFkZDoNCj4gPiAN
Cj4gPiBLVk0gaXMgbm90IGFsbG93ZWQgdG8gb3BlcmF0ZSBvbiB0aGUgRVBUX1BPSU5URVIgZGly
ZWN0bHkuDQo+ID4gDQo+ID4gPiBUaGUgc2hhcmVkIGhhbGYgdXNlcyBhIG5ldyBTSEFSRURfRVBU
X1BPSU5URVIgZmllbGQgYW5kIHdpbGwgYmUgbWFuYWdlZCBieQ0KPiA+ID4gdGhlIGNvbnZlbnRp
b25hbCBNTVUgbWFuYWdlbWVudCBvcGVyYXRpb25zIHRoYXQgb3BlcmF0ZSBkaXJlY3RseSBvbiB0
aGUNCj4gPiA+IEVQVCB0YWJsZXMuDQo+ID4gPiANCj4gPiBJIHdvdWxkIGxpa2UgdG8gZXhwbGlj
aXRseSBjYWxsIG91dCBLVk0gY2FuIHVwZGF0ZSBTSEFSRURfRVBUX1BPSU5URVIgZGlyZWN0bHk6
DQo+ID4gDQo+ID4gVGhlIHNoYXJlZCBoYWxmIHVzZXMgYSBuZXcgU0hBUkVEX0VQVF9QT0lOVEVS
IGZpZWxkLsKgIEtWTSBpcyBhbGxvd2VkIHRvIHNldCBpdA0KPiA+IGRpcmVjdGx5IGJ5IHRoZSBp
bnRlcmZhY2UgcHJvdmlkZWQgYnkgdGhlIFREWCBtb2R1bGUsIGFuZCBLVk0gaXMgZXhwZWN0ZWQg
dG8NCj4gPiBtYW5hZ2UgdGhlIHNoYXJlZCBoYWxmIGp1c3QgbGlrZSBpdCBtYW5hZ2VzIHRoZSBl
eGlzdGluZyBFUFQgcGFnZSB0YWJsZSB0b2RheS4NCj4gPiANCj4gPiANCj4gPiA+IFRoaXMgbWVh
bnMgZm9yIFREWCB0aGUgLmxvYWRfbW11X3BnZCgpIG9wZXJhdGlvbiB3aWxsIG5lZWQgdG8NCj4g
PiA+IGtub3cgdG8gdXNlIHRoZSBTSEFSRURfRVBUX1BPSU5URVIgZmllbGQgaW5zdGVhZCBvZiB0
aGUgbm9ybWFsIG9uZS4gQWRkIGENCj4gPiA+IG5ldyB3cmFwcGVyIGluIHg4NiBvcHMgZm9yIGxv
YWRfbW11X3BnZCgpIHRoYXQgZWl0aGVyIGRpcmVjdHMgdGhlIHdyaXRlIHRvDQo+ID4gPiB0aGUg
ZXhpc3Rpbmcgdm14IGltcGxlbWVudGF0aW9uIG9yIGEgVERYIG9uZS4NCj4gPiA+IA0KPiA+ID4g
Rm9yIHRoZSBURFggb3BlcmF0aW9uLCBFUFQgd2lsbCBhbHdheXMgYmUgdXNlZCwgc28gaXQgY2Fu
IHNpbXB5IHdyaXRlIHRvDQo+IA0KPiANCj4gTWF5YmUgcmVtb3ZlICJzbyI/wqAgSU1PLCB0aGVy
ZSBpcyBubyBjYXVzYWwgcmVsYXRpb25zaGlwIGJldHdlZW4gdGhlIA0KPiBmaXJzdCBhbmQgc2Vj
b25kIGhhbGYgb2YgdGhlIHNlbnRlbmNlLg0KPiANCg0KSSB3YXMgdHJ5aW5nIHRvIG5vZCBhdCB3
aHkgdGR4X2xvYWRfbW11X3BnZCgpIGlzIHNvIG11Y2ggc2ltcGxlciB0aGFuIHZteF9sb2FkX21t
dV9wZ2QoKS4gSGVyZSBpcyBhDQpuZXcgdmVyc2lvbiB3aXRoIGFsbCB0aGUgZmVlZGJhY2s6DQoN
CktWTTogVERYOiBBZGQgbG9hZF9tbXVfcGdkIG1ldGhvZCBmb3IgVERYDQoNClREWCB1c2VzIHR3
byBFUFQgcG9pbnRlcnMsIG9uZSBmb3IgdGhlIHByaXZhdGUgaGFsZiBvZiB0aGUgR1BBIHNwYWNl
IGFuZCBvbmUgZm9yIHRoZSBzaGFyZWQgaGFsZi4NClRoZSBwcml2YXRlIGhhbGYgdXNlcyB0aGUg
bm9ybWFsIEVQVF9QT0lOVEVSIHZtY3MgZmllbGQsIHdoaWNoIGlzIG1hbmFnZWQgaW4gYSBzcGVj
aWFsIHdheSBieSB0aGUNClREWCBtb2R1bGUuIEZvciBURFgsIEtWTSBpcyBub3QgYWxsb3dlZCB0
byBvcGVyYXRlIG9uIGl0IGRpcmVjdGx5LiBUaGUgc2hhcmVkIGhhbGYgdXNlcyBhIG5ldw0KU0hB
UkVEX0VQVF9QT0lOVEVSIGZpZWxkIGFuZCB3aWxsIGJlIG1hbmFnZWQgYnkgdGhlIGNvbnZlbnRp
b25hbCBNTVUgbWFuYWdlbWVudCBvcGVyYXRpb25zIHRoYXQNCm9wZXJhdGUgZGlyZWN0bHkgb24g
dGhlIEVQVCByb290LiBUaGlzIG1lYW5zIGZvciBURFggdGhlIC5sb2FkX21tdV9wZ2QoKSBvcGVy
YXRpb24gd2lsbCBuZWVkIHRvIGtub3cNCnRvIHVzZSB0aGUgU0hBUkVEX0VQVF9QT0lOVEVSIGZp
ZWxkIGluc3RlYWQgb2YgdGhlIG5vcm1hbCBvbmUuIEFkZCBhIG5ldyB3cmFwcGVyIGluIHg4NiBv
cHMgZm9yDQpsb2FkX21tdV9wZ2QoKSB0aGF0IGVpdGhlciBkaXJlY3RzIHRoZSB3cml0ZSB0byB0
aGUgZXhpc3Rpbmcgdm14IGltcGxlbWVudGF0aW9uIG9yIGEgVERYIG9uZS4NCg0KRm9yIHRoZSBU
RFggbW9kZSBvZiBvcGVyYXRpb24sIEVQVCB3aWxsIGFsd2F5cyBiZSB1c2VkIGFuZCBLVk0gZG9l
cyBub3QgbmVlZCB0byBiZSBpbnZvbHZlZCBpbg0KdmlydHVhbGl6YXRpb24gb2YgQ1IzIGJlaGF2
aW9yLiBTbyB0ZHhfbG9hZF9tbXVfcGdkKCkgY2FuIHNpbXBseSB3cml0ZSB0byBTSEFSRURfRVBU
X1BPSU5URVIuDQo=

