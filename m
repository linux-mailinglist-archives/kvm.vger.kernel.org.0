Return-Path: <kvm+bounces-26152-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AEBD697238C
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 22:22:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E6426B20C4F
	for <lists+kvm@lfdr.de>; Mon,  9 Sep 2024 20:22:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19EE18A6A8;
	Mon,  9 Sep 2024 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HopVkdOI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98C2118C31;
	Mon,  9 Sep 2024 20:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725913347; cv=fail; b=X20FYwQ8fqh/FY/zVbEuz30GVUvp/BK3h/s0p5/hF5D9ZtCQHGXAOvLywy+/GCTWeuwji8h2y0srXgF+kWPmV87eSYljE8ATQJ1nfuBNpo+rDGbHNq/TnXTe6vpCU2gpGW1eueIeFduv/5vES37a9IyKKKsbzjwNZxn4cKqtkJk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725913347; c=relaxed/simple;
	bh=rhYkp22C2wrwGBD/UCNv8wXS9V44ehNDlJsjafK/8FE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=hAO8v1xRJkUrxTe5KA/hyWZWv5rPrSwykWeo+AC/79YnWOdpq8XneQtZV1BCWML93+6+Vt7lnpkYEKLlAY0g81vcpu6JPCouvvsgbNevYCiZ2VDWdIVjn5xgZHqouz1EehvITai0o9vL72p/DtbwJfDsrkqz9h55pTcx3pwTtaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HopVkdOI; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725913346; x=1757449346;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=rhYkp22C2wrwGBD/UCNv8wXS9V44ehNDlJsjafK/8FE=;
  b=HopVkdOI1/g8P12V6FBi9EBpculSGwyoAn3iSuORIldAPH7T7XpwFWoT
   yDWU4OQRMcjtiDI96oH/UUlIqjpGQ3KX4q4yi3X/zG7D/JgtbHiJk1XrG
   Doop9vDDk2vIGMxrFfFIJrdHpGqJ/ZvDOtdJvW+y/dZ8fVFyix4j+cv+Z
   KoZc1F5/jFvTfGO073mab4d5PJr4D61lBfJfIIyVnE+frhzr0N2+FPjNS
   8to3aD3k7/PuMlqHOXSy/HbRDWp5ig/uhFsKYEUHTp0+ckCIF+8bsT9Tl
   1C9luLuC3W4qimqiUdyiHCDS8ZEl+V4MAfYIM8CDlFnaBqKuKNG7L7zjN
   w==;
X-CSE-ConnectionGUID: zvdCGRVHSBusuSTQc2Oehg==
X-CSE-MsgGUID: soCIFL9lRMWZ4zR8iwqnHA==
X-IronPort-AV: E=McAfee;i="6700,10204,11190"; a="24445699"
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="24445699"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Sep 2024 13:22:26 -0700
X-CSE-ConnectionGUID: +gXvQgBZSAaowc0cWVvt+g==
X-CSE-MsgGUID: RfyXhOn+TaKlgMVjyNvklA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,215,1719903600"; 
   d="scan'208";a="71565147"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa005.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 09 Sep 2024 13:22:25 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 9 Sep 2024 13:22:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 9 Sep 2024 13:22:24 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 9 Sep 2024 13:22:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nI4C1rSBjSAUDTmAl8rr6YHXrunbI8TJMacPi+c7mH1MOCeTgdd68a+iFYV0ixX1Pp4b8/6imPTqrw0OBGen8d4DGAzYCklyu7iGM6wtJ6sbE5mkZh6fWwT5fiXKUud1dDGQxBWzG1JC5pHEwqs4xUNe0r07yVt/i8lIlMWDLeQMzM5JWBja2GYRbh/xG1U6RiclyoH683EpMCFjrZBZe7Ov+zgL1XHvPBVkkxJyFIi+ae+6NH8CiX6l3PP3gBRPbj9Ua/m9Yv8fKvA/gslWN8beWPPbfl+oNQ47/LP+WOrHUUB4m8N8PtOsmOL63ZSC7YL82Lv1KE4NYX4eEmehJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rhYkp22C2wrwGBD/UCNv8wXS9V44ehNDlJsjafK/8FE=;
 b=frZ4LOMHQ1lRX+d8TaU2599A60WOzl1z8WvdeQz6G/PeexXxXt9uMNN/iiL0vgf7e7NGqOKM//awoOA9M55FnXjIGu8uE4Z5JWjG9mn58TQCgxlhDx6w4IFhQssxrJY/weffve5LqfS6gJ01lu9bbgWCTNFNjEJ5/V8Xkn3facc2O8i7caDPnE+qzFfOf6z6fDJr9NUb6RH9tjleMlDBhDBkwXA0CSl3ONIHV/g6p/kBFTfAgbIUeg8Dv/+x3N0iNE6Ji0SvTs20MpHjtTI7PG4zqhthpAbelnA9nyO3Np+im79jN+F4fJc1mPLeLTMOj1S41krwuSYeG8yWrG9LKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB6572.namprd11.prod.outlook.com (2603:10b6:303:1ee::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7918.24; Mon, 9 Sep
 2024 20:22:20 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Mon, 9 Sep 2024
 20:22:20 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Yao, Yuan" <yuan.yao@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "dmatlack@google.com"
	<dmatlack@google.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34A=
Date: Mon, 9 Sep 2024 20:22:20 +0000
Message-ID: <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
	 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
In-Reply-To: <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB6572:EE_
x-ms-office365-filtering-correlation-id: 2694728e-5e99-46dd-0cee-08dcd10d1b61
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?V0ZaYUpVakpKei90clJJRUg0TFFGSVFPMDRHc2NDbGNCWEpzMlIxTUtuTERC?=
 =?utf-8?B?eEN6VHR6dUxzL1BTS1FGMDJOZE5EdHVZN1BEK3VJNHBvay9VcHVSc0RkUHB3?=
 =?utf-8?B?OFNvMmJYUGcyN3Fqb0E4MjM1d1pkQTlQU25xcTFLRWVxR3NPU3RVY0FGaXc3?=
 =?utf-8?B?cG9LYmoyUldNQzlTMTZXMThMbVFhNzJzWmNmSWJlMkhOTGVaemdKZWhsNVRh?=
 =?utf-8?B?SkkyUXRKU1Y0ZVp5b2FGSmJpRVVSWEtRN3k5ODNrc0hCOU1kenZDRDRkeTdl?=
 =?utf-8?B?djdGWWE4QXRNMTJMeFd2alIxci9UUldoNWorOWVtaXhKMFZEQU1MOEpWOC9h?=
 =?utf-8?B?cGJmNXF2a0ZQY2ZOQWFWMDFtd2llc2FLaUpsOVpXdFo4My9RNUdxdFJRQlBX?=
 =?utf-8?B?amt6QmllN0tHMitDbWViMU9GOTFkSUtSaUhUbUFJdVI5ZE5WeXJleVpCdkRF?=
 =?utf-8?B?bFVnbzNpakpUZHczZTBSV3oyS3ZVdFFwMXdCaWtWZGVoOVFESWM0VE45ZUdR?=
 =?utf-8?B?bExiVlNnWXlmak14cS9HeGVDODJ2MVJYdUUwa1RvRGFuV0NyaXZmWW1ONCtM?=
 =?utf-8?B?eVlEc1NrdllKdk1kOUg3L0NobjZEUmUyRWVRQXY3ZTdhL2Y3MUxrQ2tKYjZN?=
 =?utf-8?B?Q1NUMitiVlJOb200dU5SN1VTK1pQdXZuZUE0dzloZXVzVGphNk1VajJrbGNn?=
 =?utf-8?B?OElBd1hrbVNJSm9WWjlNbWpvWVFpTDU2NWtodmFwOEE4L0xOcWpubFAwQlRQ?=
 =?utf-8?B?VUJBblQ3bkQ3VFh3b3lxUWg4OFQ5bzVKZW5maHpabUk4ZU1wREFENXhKMGYz?=
 =?utf-8?B?T3ZGbU90dGxWVGpwWWpqZU9CU1hhbitrQzg1TDhqK3J0V29mWGFEcFlQK2o0?=
 =?utf-8?B?eHhNVnZ3L1c3SmFEME9WSlI1NHc5aVlNUk1POVRIRGs2S0dIQUxpcERFQVVz?=
 =?utf-8?B?ejVJeGZwVitnNkpjYWNwVVNEZVJoOXI4aDNBQ3crbVdJcG0yZWQzNFZSU09X?=
 =?utf-8?B?QjJoVjVMQUlqWG1UR1FnOHlDUWRVbmZ0VXd1R0RhVmZNKzhXVlA4WGNrQTQ1?=
 =?utf-8?B?cWVqTzNsUEw5YVJMUlJpS0czazJWbU1KeVVMZnFnWEQ4ZEorQ1hVb1FaTFRk?=
 =?utf-8?B?WW5sN0tlZU1RTC9iQ0dHa2JpUzFrV0hhYmVKWEVtRkJucS9YRE5VRGFZT1lE?=
 =?utf-8?B?MlhDYTMzYzR5WnNRdG0zdWN2bFhqNjA3S0ZBVUhRUWc4RVFpNGNQQXFyaWVT?=
 =?utf-8?B?NDZrVm1vSTNTT2cyUHhNY3lDVmVnNUtqb2JkK1ExdzE2TVlpeUxCdWp0TEl4?=
 =?utf-8?B?WUxqRmNCVm5ORHVEQUF3V1c0Rm1lWXUrcHlvT1FROEVzcE5VaWtjM2d4Sk5t?=
 =?utf-8?B?eFgzWmdRTm9hWEtCdWw1RnduN2d4N2VkcmZEYmY0c3lnVDJva2VJZWdIdXZj?=
 =?utf-8?B?UWVxZ1hQR1VPdDN3Y2ZmRG1udDN5YkRiM3JMRlFRdVhSbGk4TEM4cVQ5TmUy?=
 =?utf-8?B?ZFNqdG4zSWZySE93QXJRS2JwbUxvRU8wWlk1L3duLzJBeDJmdm1mdElTUHB5?=
 =?utf-8?B?eENFdHY1NXNpYnFzZGxqbmx4QkFsbTFpekJ5eGEyRTAzVGhvUTcwRHFUdWsy?=
 =?utf-8?B?c1VDdGNPWDF6MEN4NlgvT2VReHVJU3RIbHI3Z0VZa0htU1hCR3NUVHloUTB2?=
 =?utf-8?B?TjR4REFLaTN5UTIzdlFTcUFvdWVmWkxYU2VNaFpZN2N2U0VuV2R0bUxqVm93?=
 =?utf-8?B?bWQ5LzAySVRnMmRlMG9YN1N1bElIK044OWhsTitnNkpWRTFRUXo5MEZjM0FG?=
 =?utf-8?B?TGp1ay9CM3hFM0FLaVV4WnRINS9jeEVtN3c4TDZGVEtLQjdiL0pCNnYvak12?=
 =?utf-8?B?cVFGeVk1VXRkN3c5WDZ3NHVhTFhwcHRnMllZaUxWaStQdEE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aVRkczV1OTZOUEMrdG1DT3ZPamhVQlNQWkNpU0s2L282WEhZY3hkTUZmT3BK?=
 =?utf-8?B?UFFXa1MrZDJkT2dyRE91dEduYzkzdSszVDB0MkZSTGF6ckg4NktxNGhOYWI0?=
 =?utf-8?B?QmkvYXlTWXZyaHNyMVdGdENzVXNvR0lzL1N5VTJ3SkVCWVdpaUZJS1ZTNHIz?=
 =?utf-8?B?VGF3dnFtQ1duNXJDQlovS3ZoZVB0RVBwZ1ovTEExa0dXam9RUVkrTUxuTGxu?=
 =?utf-8?B?QzkrQkorNHJDQUQ1WWV4d2FYdFNWN3FqcVpTbTBSUktrWEt5cTZUQ0RjLzlX?=
 =?utf-8?B?cG9pVHQrUG5SdzAxM0ZTY2IxdG40V0cwSmp5ZlZldGNMRUszV0VwVHVtT25G?=
 =?utf-8?B?dHE2V2xCK3hkdy91TXlqNGs4WWFNd0MyNWJXdzVSLzZacXNueCtZenJwdXpX?=
 =?utf-8?B?WkphdjZvdUNmTmcxSkRmbXpyekRZeWZBL0cwWmwwQTNWYVNrVjBZYWN2Z2Ji?=
 =?utf-8?B?VUdlakgzS0Q1VmNCZkJWZnhlOXlTbHlyS3NqSHZqS0R0amg4d0VhbnZCSW9t?=
 =?utf-8?B?b2N5QTROZ1JNWnVFN1dYVHRLelNYMG4ySkJqVktHb2dLVjNOL2RISUZCcGYx?=
 =?utf-8?B?cmhyRk9wY3RvYTNjNy9HN2xpdFQ2QlFUVmJOSmY3c0hqNmlIMzArNk9sVGE0?=
 =?utf-8?B?ZmplZUFLZjROTzBaNVBYbytkUFJCMHptdUZLVEFnamNxbXVuSEN3WGFjbkZ5?=
 =?utf-8?B?UC8vaGlud3NhbGkwb3ozNE1NT2VxQmpwd0dxZjE0bXZxaWt3aHhIWEhXRmFF?=
 =?utf-8?B?by9Yb3lsazFXam9nZW8yUnlVaUNRUlU1STFEdG5WejFrQ0NHZU5Ed1lXUU0v?=
 =?utf-8?B?cFJNWWJ6OFpnby8ySEQzNlROTzRqbEliMDh5anlCMW5zUWsyT2N1VE8rZ2ZJ?=
 =?utf-8?B?QkdLMXE0QW9TTzF3cjdIUS9BVFFvbktsRStXdEh0UjYxRW5BQVRRNkxobWF2?=
 =?utf-8?B?anlKTlV2cm9wZFlTNHVjZ2kyOW5tcnIrcGxnUW9Za1RmUDFvYk5WRm1ydTFz?=
 =?utf-8?B?SG42S2NydlhWdExlTGtaVmhvQitROHUvYysxT29Dbm1Dbm1MV2lsVlptTjFz?=
 =?utf-8?B?Z2w4eFFDZjhrK1BFTXcrbURHY3VzRWJGbFlkZlg5SWVFQm5yd2piU2tnR1pS?=
 =?utf-8?B?dzdXRCtZQnQxeDQ4cit1cWlrOENCRU1kb1UzVXZXeUNzeHVYWkxmVUU1WE5y?=
 =?utf-8?B?dENyc3docEJHYWRqZTV3VFdwL3VvK2dmRjFWRDBWamlremFxNnc3M2ZxdGJD?=
 =?utf-8?B?eGJCZ20wdVN5THV1Mys5VlA1SHIvR25yM3pUS1FxUTJvNzZaRFZVa1g5ak81?=
 =?utf-8?B?U21WamNOcGsyZ1dlRlZsNWJxRXBPYlJia3U1bzhFSisrNXZwTHI5c0s4L1Vk?=
 =?utf-8?B?VUU5YlNtMEp6MWdBQ3R3UE9iQ20rUmpLREo3MEZmZ2dyZnRqaTZmWGowWGNK?=
 =?utf-8?B?UUdMQ3l1T3ZoWGp3ZTBpUFFRbmtOL2JPNWVRdS9nYkRwWHkzemczUFd0V1Ra?=
 =?utf-8?B?N2ZzOGc3WldGQ2UxVXpmL3AvWU9tanRzUzVyR0YyR2pBR1NEUkM0SzlQS3JZ?=
 =?utf-8?B?MW1xOFVQdFpOQWVmOVBBeW5nWEJPREQ3TGtVOFBIV080UXJpNG9RY2tsR1Vu?=
 =?utf-8?B?SzZ3QlZWTzJrV0tTT1k5cVpaWHoxUklYWEZxU3BqWnFaeG1iTWsvNVBZdng2?=
 =?utf-8?B?a3dsN1k2NFNpUGhIRURyZDN2a05Vc3czd1UvVWMwVWRUdVBEbHVqaGNTRG5Z?=
 =?utf-8?B?UUszT29MWVRLUHQvNnFJZThlaTZYODB6NUJoTnZWSUREdG5pLy8rSWdsUEFN?=
 =?utf-8?B?ZnlrWWlTL3htS3hjbTgwTm5MYzZ4Uk51MC9iLzBtNnVGZ0FudGtTcVpmL09Y?=
 =?utf-8?B?VzRqakxCbEREcDNlTVIzZ3p4Y0dYeDc1cmxYdnFRWk5wNTRQT0VPZDNMVjUr?=
 =?utf-8?B?SUFDQWhkcitYOTdwOGdtTWdlMzNZdUhvcExDTDZHODRTY1ZibXB1aHJCczRI?=
 =?utf-8?B?QUhBbi9YZit3bjRydXdsdzgrL1V5Sm5YSU1jZWRXRnBGZHZSaUFka3ZqZWpN?=
 =?utf-8?B?NlZjejU0TXFJWk9EVS9nQTE5REhRcnB4eXIwUk5uTnZ2bVNFSEhLb0RZMTRG?=
 =?utf-8?B?ejl0ODdsN0VDK1crV0N6L29MWCtDQlgrWXlpVS9QS3hDaFZXei9oL0JYWlB2?=
 =?utf-8?B?SHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3568BE5C58B88247A37C42286290A7A6@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2694728e-5e99-46dd-0cee-08dcd10d1b61
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Sep 2024 20:22:20.3371
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fwkWCvYKC6NUHai9Mbpw+qqxAx/rqRrN7fYuilxEbJegMDWVFru8TdXcbjuSKjviHoxxtk0YuuffIOM+hdAK3xvZ3zZs2tt8MR+f3YZxPp4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6572
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTA5LTA5IGF0IDE3OjI1ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiA5LzQvMjQgMDU6MDcsIFJpY2sgRWRnZWNvbWJlIHdyb3RlOg0KPiA+ICtzdGF0aWMgaW5s
aW5lIHU2NCB0ZHhfc2VhbWNhbGxfc2VwdCh1NjQgb3AsIHN0cnVjdCB0ZHhfbW9kdWxlX2FyZ3Mg
KmluKQ0KPiA+ICt7DQo+ID4gKyNkZWZpbmUgU0VBTUNBTExfUkVUUllfTUFYwqDCoMKgwqAgMTYN
Cj4gDQo+IEhvdyBpcyB0aGUgMTYgZGV0ZXJtaW5lZD/CoCBBbHNvLCBpcyB0aGUgbG9jayBwZXIt
Vk0gb3IgZ2xvYmFsPw0KDQpUaGUgbG9jayBiZWluZyBjb25zaWRlcmVkIGhlcmUgaXMgcGVyLVRE
LCBidXQgVERYX09QRVJBTkRfQlVTWSBpbiBnZW5lcmFsIGNhbiBiZQ0KZm9yIG90aGVyIGxvY2tz
LiBJJ20gbm90IHN1cmUgd2hlcmUgdGhlIDE2IGNhbWUgZnJvbSwgbWF5YmUgWXVhbiBvciBJc2Fr
dSBjYW4NCnNoYXJlIHRoZSBoaXN0b3J5LiBJbiBhbnkgY2FzZSwgdGhlcmUgc2VlbXMgdG8gYmUg
c29tZSBwcm9ibGVtcyB3aXRoIHRoaXMgcGF0Y2gNCm9yIGp1c3RpZmljYXRpb24uDQoNClJlZ2Fy
ZGluZyB0aGUgemVyby1zdGVwIG1pdGlnYXRpb24sIHRoZSBURFggTW9kdWxlIGhhcyBhIG1pdGln
YXRpb24gZm9yIGFuDQphdHRhY2sgd2hlcmUgYSBtYWxpY2lvdXMgVk1NIGNhdXNlcyByZXBlYXRl
ZCBwcml2YXRlIEVQVCB2aW9sYXRpb25zIGZvciB0aGUgc2FtZQ0KR1BBLiBXaGVuIHRoaXMgaGFw
cGVucyBUREguVlAuRU5URVIgd2lsbCBmYWlsIHRvIGVudGVyIHRoZSBndWVzdC4gUmVnYXJkbGVz
cyBvZg0KemVyby1zdGVwIGRldGVjdGlvbiwgdGhlc2UgU0VQVCByZWxhdGVkIFNFQU1DQUxMcyB3
aWxsIGV4aXQgd2l0aCB0aGUgY2hlY2tlZA0KZXJyb3IgY29kZSBpZiB0aGV5IGNvbnRlbmQgdGhl
IG1lbnRpb25lZCBsb2NrLiBJZiB0aGVyZSB3YXMgc29tZSBvdGhlciAobm9uLQ0KemVyby1zdGVw
IHJlbGF0ZWQpIGNvbnRlbnRpb24gZm9yIHRoaXMgbG9jayBhbmQgS1ZNIHRyaWVzIHRvIHJlLWVu
dGVyIHRoZSBURCB0b28NCm1hbnkgdGltZXMgd2l0aG91dCByZXNvbHZpbmcgYW4gRVBUIHZpb2xh
dGlvbiwgaXQgbWlnaHQgaW5hZHZlcnRlbnRseSB0cmlnZ2VyDQp0aGUgemVyby1zdGVwIG1pdGln
YXRpb24uwqBJICp0aGluayogdGhpcyBwYXRjaCBpcyB0cnlpbmcgdG8gc2F5IG5vdCB0byB3b3Jy
eQ0KYWJvdXQgdGhpcyBjYXNlLCBhbmQgZG8gYSBzaW1wbGUgcmV0cnkgbG9vcCBpbnN0ZWFkIHRv
IGhhbmRsZSB0aGUgY29udGVudGlvbi4NCg0KQnV0IHdoeSAxNiByZXRyaWVzIHdvdWxkIGJlIHN1
ZmZpY2llbnQsIEkgY2FuJ3QgZmluZCBhIHJlYXNvbiBmb3IuIEdldHRpbmcgdGhpcw0KcmVxdWly
ZWQgcmV0cnkgbG9naWMgcmlnaHQgaXMgaW1wb3J0YW50IGJlY2F1c2Ugc29tZSBmYWlsdXJlcw0K
KFRESC5NRU0uUkFOR0UuQkxPQ0spIGNhbiBsZWFkIHRvIEtWTV9CVUdfT04oKXMuDQoNClBlciB0
aGUgZG9jcywgaW4gZ2VuZXJhbCB0aGUgVk1NIGlzIHN1cHBvc2VkIHRvIHJldHJ5IFNFQU1DQUxM
cyB0aGF0IHJldHVybg0KVERYX09QRVJBTkRfQlVTWS4gSSB0aGluayB3ZSBuZWVkIHRvIHJldmlz
aXQgdGhlIGdlbmVyYWwgcXVlc3Rpb24gb2Ygd2hpY2gNClNFQU1DQUxMcyB3ZSBzaG91bGQgYmUg
cmV0cnlpbmcgYW5kIGhvdyBtYW55IHRpbWVzL2hvdyBsb25nLiBUaGUgb3RoZXINCmNvbnNpZGVy
YXRpb24gaXMgdGhhdCBLVk0gYWxyZWFkeSBoYXMgcGVyLVZNIGxvY2tpbmcsIHRoYXQgd291bGQg
cHJldmVudA0KY29udGVudGlvbiBmb3Igc29tZSBvZiB0aGUgbG9ja3MuIFNvIGRlcGVuZGluZyBv
biBpbnRlcm5hbCBkZXRhaWxzIEtWTSBtYXkgbm90DQpuZWVkIHRvIGRvIGFueSByZXRyaWVzIGlu
IHNvbWUgY2FzZXMuDQoNCg0K

