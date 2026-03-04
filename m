Return-Path: <kvm+bounces-72759-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id XYbUApG9qGmXwwAAu9opvQ
	(envelope-from <kvm+bounces-72759-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:17:37 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 62C16208EAE
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:17:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1A2FE301875B
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:17:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D158366572;
	Wed,  4 Mar 2026 23:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MhfT9+kl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A722364936;
	Wed,  4 Mar 2026 23:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772666240; cv=fail; b=W2zAtxPkXpxEhh0ZjLe5sddRQneQqmVbyclyFDMChusZC9PYE21lYFjsej3IwAkeAMHmSQgxC+wBUaAhA6oUUFSEfv1tO28Qi+qppgdPrPFxGksdwYeXWJwrLV0UQGtvNjDUw6XjvTD79UCs+BUEjfYE/5QnO3A+rg4D08Ep7C8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772666240; c=relaxed/simple;
	bh=lJepOg6f03BkvbeF9iAxXVb/1Z7RODPs13NcGfQsf7g=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=bOiBUDf2hKq7pHAX8VHiTUvY2O+J8Z0SEbfWksRAtY8pyHQQKA6e+bSTa9zxI3NaJyDwKR/OpYNG1u2XPq57m16B7GEYBCuD4JqDTAcrhr16u+2ONF+nEvHkaf4LGPGVGJ/CBdjD73mB7TgljA7Tk3LKaTTdRuzdL8FkvdAZ0jQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MhfT9+kl; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772666239; x=1804202239;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lJepOg6f03BkvbeF9iAxXVb/1Z7RODPs13NcGfQsf7g=;
  b=MhfT9+klQJJlt7ECkEfzbY4flx1jDHsS2+RKdlrJJFRXVNDRFuDt6A6w
   GOqyJFBiiG2aGZcyi6O7HR9VedKFyBK9DHUSthb08QX/Ow/0Oh4cJHfHS
   jStXzsYoL8g2wr08X6YJOmP+Sv8z4wqLeWGp9AhePjr0Sp7cOosH0LLUJ
   ivPYiBRE9ysl9+WAIyiVl4fVQS6pNEotd8yOoux5iUHtt6CyGg5TWsxLy
   sF0FWafSDkJWb0um4GYHZGFgvz5/kIuV9ySLl8KNJUd+XqJCbAR6q2vO+
   +32RAQeUmVqS35a/MkvSjVQ0Ge+3tR1JHWtzDSZpjm0hIHuV9fBum+4tt
   A==;
X-CSE-ConnectionGUID: FfkqaIXkQPGRRjQmqGlidg==
X-CSE-MsgGUID: RG7FqSRFSp+/5wt9n+g6+Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="61313940"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="61313940"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:17:18 -0800
X-CSE-ConnectionGUID: Zw0k1mRXT5mF7EMwqS0bgA==
X-CSE-MsgGUID: 4BcK/I0wS4qAdC6c7E4aaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="221409738"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:17:18 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:17:17 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 15:17:17 -0800
Received: from CY7PR03CU001.outbound.protection.outlook.com (40.93.198.37) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:17:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=X4HUn8H9lnR8tcjuM425FUn0JPtx7LS0RDXXjhfGOsr2GzoRstgzoID4a2S7wSIJGKjgYVr2EEiPm5rRTHb5N/8acEPFXYc+uBXlE8SUI0DtJLhAaq8sL3v/3AIKNAAErY0ReKGOZdYB0ML/xf5U8y5/1t5NCEn6mET7PT7uzV9AZIJz3vJGZhNlHoZMn9dgjs5ABTbV14hINl6jdc8zQPEIOQUYB3O8js7HEwXinn2w6V9FGD6VEuYXONo/OG4MHPY07mvAPeerWhzT3D6y7a5dKqwyRwdWoySaWXaY8Bc8rj/v6js7lC88TtDWfYRmt6FvKOUQvFfGJrPSG2pmrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lJepOg6f03BkvbeF9iAxXVb/1Z7RODPs13NcGfQsf7g=;
 b=Zsgr29J7pwTpsnw+WDtJ6sJT+2FnAw7qEX9jqwwQl86vWsu5OaahJxfCfTNowbv9syKxD2ySaXI4rSyLvHYNvAxdAfn5rV3/E2IAxIZa2IfGvYI83z8fmvOv74rNYXvlhDi/3WfwYrPpt0PWbkzQfYb9GZ2a/ax4+ki6I08X7Q9bLjg0ymTfyEJtBggPUK/Z8BE3zeK+mCW6+UkPAf+uoTjW2HH59rwOfBCwgwpao1L8Bxv9JYobj6Sirs/D1U02wK/PV68lk/OGZe2FHSDb+3hGIUMPrcpEImeJTvdwPMW9/CjVtsbOFm8ECoDr3deI0kxRYgLUUt/PqJFZDx0rFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 DM6PR11MB4546.namprd11.prod.outlook.com (2603:10b6:5:2a7::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.17; Wed, 4 Mar 2026 23:17:11 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 23:17:11 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 16/24] x86/virt/seamldr: Install a new TDX Module
Thread-Topic: [PATCH v4 16/24] x86/virt/seamldr: Install a new TDX Module
Thread-Index: AQHcnCz/bb/7GH6mRkmkVPgk+ba4gbWfIaiA
Date: Wed, 4 Mar 2026 23:17:11 +0000
Message-ID: <6f1f835e27bef3462ae419906e25bd887eb8577b.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-17-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-17-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|DM6PR11MB4546:EE_
x-ms-office365-filtering-correlation-id: 8166f82c-fed4-4c04-3bce-08de7a442a3a
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: SOCMRXKLhnEwEuZZdlhGECU7fUgxE/3BY/7RS7LB6NeqYMtl5S2yT5U7lxEdxsU/rnBSyGV6CH3lDqyRj9+fHrTWjqTvHPz2juQl41E453jdXP3hUcdlC9tMikpeKZc3BVy0DRLwFjlbVPnbX3S7joUYVvGpD877VZp3ytNMo1tVBWekGX+z6qeR2EginTFBXmMezAnfAnlCezstbh3kgP+Fp0cri6IAnXzrBc3Z5bzpTLufGgZrDKGT2/IajjGpbZSCaRxv3J3NwOLoerdoADrG2ONo0rYaA3Hsnp5B5RmlSQ1en+GfyFWpmPz9vWCTBGo9p2VDgL377LWhpKo1fXMZUt2Rc7JXuR6jPefXERugcgsrl2ZVyd1DjFSYNqDbQLILwM5T8mIxcLaBQvwPYXEIntmt1NYKStWtcL35/L1kNOEdH2blGaMegafuDdlobUWsgVrQ95jDvD72kBG7MHysFjrsyUbsuMPlhMyRSeHWhFzciM778l+rzMnVlZvqnIZPhD929jqIF+ixCDi9R8cPDAnhj7ckAfIszNCueZJBOpyh5Nqwvg2YTLiMaMnk1fI9sbCZ8hK4NmfiWVY7kflFzP1YSj7R+l+xkYuRVRmbd6Wd0bdGf28o3JHMgCMO8V+2jzMMb7c1WQjVr952BA7oi7R+kHiwcA5JikoKezI6IYqoO9M7Fi7c/mKvgxaIK9zkgrHitsSHRqfAkliz3Y4GOoiDBllFZVKP4JOnEnRelFmATSBvThBYq5SnUjJsaQiqnkKIg28/gqMB2XacHb2GlTtqciqSDeKZs1ipsg0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OEdhRktoVE03N0E0RExZVldVVlFwUHNqZFBpcUFvc3dPWHg1SmZqQStQN1Fa?=
 =?utf-8?B?VFBNdTRYM21rV3hXMDhtaHhhdmI5SFIxaUtzNlJLTndTMTdCbXhDYTRDMTlx?=
 =?utf-8?B?M21TL0g2Z0IwZWN4WHhjZVNDcTNCNkp6elhaRlVxdE1YbWNTN29uL2w2N3Ju?=
 =?utf-8?B?dUFCdTdQbDQ3Q3ZMRW5Wb0ZDamVpR1JFc0pBck9XVEhCVFkxVDJFWEdaY2Rx?=
 =?utf-8?B?bmx6YkdRTE9DcEtKUWNEZkVKTmhCeFZXcmhGVSsxeXFsYTg0dWxQTkhiYkJR?=
 =?utf-8?B?TFNoeGdUTU00Y3BDY2MyRnBkUzIwNHRyQmQyRCsvTE8rMkV1bEwrUUNNWW9J?=
 =?utf-8?B?TTUyTnVuR1lBS1I5aGRoaGVmYWd0dnFZNkNJaVc0cGxkVmh4Yy9lbEVrMXc0?=
 =?utf-8?B?USthTW5xaVRZOUVrL3pWTjdMRGJUL3UwZWViVDJrb0RvcWxCb01xUVZUZUpy?=
 =?utf-8?B?UjdBQ1E2a3NRTDY0cllIM1JmalQxbDdmNy9seThDbDc5Q0tMSWZyLzVKWkUr?=
 =?utf-8?B?SmF2U200T2R1UnR0UGEzUWtoNGJ5RmNGNE0zbVdpRmVNdFc5SWVyNlpTQmNw?=
 =?utf-8?B?L3pQa3o0a2haQnFEM1V5T04wUHVoZVNHblMvMFhJdTJBeC93amNTZHAxeXMz?=
 =?utf-8?B?aG1NampDWDg0OC9LakZIYXc4d0Y3SHZMRFRQYTA2cmRmUUxPYkYwU2dWYUJn?=
 =?utf-8?B?d0tBbWEyR2ovdzFMUEdoc05pbklrRmVkVnZkWkJNSVFoV2kxdUNKS3p3OWVT?=
 =?utf-8?B?ZEdMazNSOFBNZFFibTA2OTFjVC94MGsxamkxRDJTa0FYRUpzdWZFeXp6ZWpP?=
 =?utf-8?B?MXBYRW9PL2REejZFWjdIbTcxa1ZobW1scUs4V25ldGd2RzZoZU12M3RBbG9C?=
 =?utf-8?B?Y3hSSm9GdWN6bTNMZVFTaVYvenhobldKR3V4VlEyNko1ZThnUDhvNUlCekEy?=
 =?utf-8?B?eGJ0ZXdPYUxiQWNjbFlOSE5oVHhSMVQ3Rzd2WGxzOUExSEJmUzhkUGhmL0k3?=
 =?utf-8?B?NCsxeCszVjNyWHFseXc3OEpxYTdYVVdlOFNidWdvV1BWWFN0RWFHb3FzUTJL?=
 =?utf-8?B?M2h3a3M2RUFXQ1MzMjFUdGloSU1mRnJoT0dNdWNHR2JQeUUwOTAwekRYd0xi?=
 =?utf-8?B?Z3l6Q1JadGR2Zy9Pa0xiTzlwczZKcmlGY2xVVDltdnZjaDl3RE5ZL1hmRFlW?=
 =?utf-8?B?cDFFckQ0d21VRm5hMDVhRitYSG9qZ0Y3Q2o3UWgwMTZ3Vm5Zd1NrR0ZFRFlJ?=
 =?utf-8?B?WTFFb1FHQUpIRkt5N0lYWFpCZzVnOXNqV2RuQUJoVEsrbnJlYzN5NHdkdWxM?=
 =?utf-8?B?QVBZMzhpZXU3SlM5QWxpelVGZ0I4MnEwMllZYkxNRWtGdUwzL1RsRzBTeUxn?=
 =?utf-8?B?a0J3d0xnNkwzS2pmN01wL0luMGo3S1pjb2hmTWZ1am9ROVJ5d3VTbDczUFZ4?=
 =?utf-8?B?eTU2L0J4bUEvSjNIbzB1b0hyN3Jhcy9JbjJ5U2huY0E1RlFlK1M0U1htS0Fm?=
 =?utf-8?B?aEh1TU00ZnMrOXhWTWlNM0cxUVZSN0h3ek5GcGtXa3pQWHlrWDNxWVdIRVlk?=
 =?utf-8?B?bzNWRkpPdlRVQkUvUEgyM1dxeEkyT3BGZE5BWWtSUmh5NjJZZStnZ1B5Y1Vr?=
 =?utf-8?B?UlVIdUFndDJRRWJSWFhvdXIzY1dNb1lJKzlkWjU3ZVYrRlZYTjRsVkNLMjU3?=
 =?utf-8?B?cEEyRk5RWEFDSkJhQkkwMFF3QWYzeW1Takw2dHpmOVd1Z04wYmFJZlJiK0pY?=
 =?utf-8?B?NkxJb2hiSUFML0t5eFZxSWNhNVZqREJWd3BiMmc2S2ZlV25TbFJ6allqYzJ2?=
 =?utf-8?B?UGsvcURtVlJUR2FqZEZLbXpuRHlQTlNBbVhoRGFxaHkrT1lTWXVsUFZaOW1S?=
 =?utf-8?B?a056ZkUzVVdJMm9Mc3B2cWVrK3ZTdFhNN3J6NXRiYUpncGdBUzRsZFhjQ3ho?=
 =?utf-8?B?Tm5Hb3lvOWhxUUlISXVlWnlmSzkxZEpCNFFVajVObzN3K3ZzTUdUWWlOWWpG?=
 =?utf-8?B?OTlaWm84RGd1UHBUZ2VFMGprNGxveEllRnM5SWpWeVFFUVFpd1FmMEIwRWpk?=
 =?utf-8?B?YWxGdUY0RlVWVGJKR1pqOFVUMHU5VEh3U285TjVVYnF2azNlbms4Q0QvZlA4?=
 =?utf-8?B?RWtkK3ZFYVF6NisyREFmV21NaW5kMUM4L010VTBnT1FJT0J4Zkdpem5LakVn?=
 =?utf-8?B?NVo2Vm54L1BkYSszSk51ckNjdGJDN2tXS1k4bVcvVkxYd3dNQlV6T0Z6d2pD?=
 =?utf-8?B?RlJwZXhhb1B4cklUUDNTT2dCb3MwRlpKdzJGZnlhMTlLdXlISVZzTU9ZZU5x?=
 =?utf-8?B?SGQ5YVlKbGlwUklody9ZWk1FY08yNXIzWlIrTVg5cHFUdk50MUtQZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC4A72B63723194B916779AF3008689A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: Ey9GeKYUFAB6GjOfihkA4vlmAqiXdqGXW5uxHyo89soaXKxXxtQdzpTjUPGXJChN2Dw3qpTSQXZtlfEG1WciJQJuV8/itb5rQmYb+0Zcxotq2GWFEOIm9bHV7WKicN42tGYvBq44CwOiDiStd4MymIMfFyRf/WdBmMqZYPowIShRkNTLAkrjncjl++UDpAp25wzY7Uc4GbyYq+1TEg8K+KBHwh8dQhLDvy930VT7tM4s4T54vXdKzg+ZxqCMync71Kdn+aMj/NZ6iuPFMkXud52GNAFgHMe82AMdD7t+KABcz9sn3aH0XRIAn2p6ztSyOxNpUmJd504Eb0A1IFOp6g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8166f82c-fed4-4c04-3bce-08de7a442a3a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 23:17:11.7830
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yE4xWvSsIH2q74RnHkQL7um5aAVR9c0UnqR4LwppRgIrezoXGq0UfPvq+JifEpLc8JfZuGBOIfE/1nZpUwMl/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4546
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 62C16208EAE
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	TAGGED_FROM(0.00)[bounces-72759-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,intel.com:dkim,intel.com:email,intel.com:mid];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gRm9s
bG93aW5nIHRoZSBzaHV0ZG93biBvZiB0aGUgZXhpc3RpbmcgVERYIE1vZHVsZSwgdGhlIHVwZGF0
ZSBwcm9jZXNzDQo+IGNvbnRpbnVlcyB3aXRoIGluc3RhbGxpbmcgdGhlIG5ldyBtb2R1bGUuIFAt
U0VBTUxEUiBwcm92aWRlcyB0aGUNCj4gU0VBTUxEUi5JTlNUQUxMIFNFQU1DQUxMIHRvIHBlcmZv
cm0gdGhpcyBpbnN0YWxsYXRpb24sIHdoaWNoIG11c3QgYmUNCj4gZXhlY3V0ZWQgc2VyaWFsbHkg
YWNyb3NzIGFsbCBDUFVzLg0KDQpOaXQ6DQoNClNpbmNlIHlvdSBtZW50aW9uZWQgInNlcmlhbGx5
IiBoZXJlLCBwZXJoYXBzIGp1c3QgYWRkIGEgc2VudGVuY2UgdG8gbWVudGlvbg0KdGhhdCBpdCBp
cyBndWFyYW50ZWVkIGJ5IHRoZSByYXcgc3BpbmxvY2sgaW5zaWRlIHNlYW1sZHJfY2FsbCgpPw0K
DQo+IA0KPiBJbXBsZW1lbnQgU0VBTUxEUi5JTlNUQUxMIGFuZCBleGVjdXRlIGl0IG9uIGV2ZXJ5
IENQVS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENoYW8gR2FvIDxjaGFvLmdhb0BpbnRlbC5jb20+
DQo+IFJldmlld2VkLWJ5OiBUb255IExpbmRncmVuIDx0b255LmxpbmRncmVuQGxpbnV4LmludGVs
LmNvbT4NCg0KUmV2aWV3ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0K
QWxzbyBhIG5pdCBiZWxvdyAuLi4NCg0KPiAtLS0NCj4gIGFyY2gveDg2L3ZpcnQvdm14L3RkeC9z
ZWFtbGRyLmMgfCA5ICsrKysrKysrLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDggaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L3ZpcnQvdm14L3Rk
eC9zZWFtbGRyLmMgYi9hcmNoL3g4Ni92aXJ0L3ZteC90ZHgvc2VhbWxkci5jDQo+IGluZGV4IDRl
MGE5ODQwNGM3Zi4uNDUzNzMxMTc4MGIxIDEwMDY0NA0KPiAtLS0gYS9hcmNoL3g4Ni92aXJ0L3Zt
eC90ZHgvc2VhbWxkci5jDQo+ICsrKyBiL2FyY2gveDg2L3ZpcnQvdm14L3RkeC9zZWFtbGRyLmMN
Cj4gQEAgLTIyLDYgKzIyLDcgQEANCj4gIA0KPiAgLyogUC1TRUFNTERSIFNFQU1DQUxMIGxlYWYg
ZnVuY3Rpb24gKi8NCj4gICNkZWZpbmUgUF9TRUFNTERSX0lORk8JCQkweDgwMDAwMDAwMDAwMDAw
MDANCj4gKyNkZWZpbmUgUF9TRUFNTERSX0lOU1RBTEwJCTB4ODAwMDAwMDAwMDAwMDAwMQ0KPiAg
DQo+ICAjZGVmaW5lIFNFQU1MRFJfTUFYX05SX01PRFVMRV80S0JfUEFHRVMJNDk2DQo+ICAjZGVm
aW5lIFNFQU1MRFJfTUFYX05SX1NJR180S0JfUEFHRVMJNA0KPiBAQCAtMTk4LDYgKzE5OSw3IEBA
IHN0YXRpYyBzdHJ1Y3Qgc2VhbWxkcl9wYXJhbXMgKmluaXRfc2VhbWxkcl9wYXJhbXMoY29uc3Qg
dTggKmRhdGEsIHUzMiBzaXplKQ0KPiAgZW51bSB0ZHBfc3RhdGUgew0KPiAgCVREUF9TVEFSVCwN
Cj4gIAlURFBfU0hVVERPV04sDQo+ICsJVERQX0NQVV9JTlNUQUxMLA0KPiAgCVREUF9ET05FLA0K
PiAgfTsNCj4gIA0KPiBAQCAtMjMyLDkgKzIzNCwxMCBAQCBzdGF0aWMgdm9pZCBwcmludF91cGRh
dGVfZmFpbHVyZV9tZXNzYWdlKHZvaWQpDQo+ICAgKiBTZWUgbXVsdGlfY3B1X3N0b3AoKSBmcm9t
IHdoZXJlIHRoaXMgbXVsdGktY3B1IHN0YXRlLW1hY2hpbmUgd2FzDQo+ICAgKiBhZG9wdGVkLCBh
bmQgdGhlIHJhdGlvbmFsZSBmb3IgdG91Y2hfbm1pX3dhdGNoZG9nKCkNCj4gICAqLw0KPiAtc3Rh
dGljIGludCBkb19zZWFtbGRyX2luc3RhbGxfbW9kdWxlKHZvaWQgKnBhcmFtcykNCj4gK3N0YXRp
YyBpbnQgZG9fc2VhbWxkcl9pbnN0YWxsX21vZHVsZSh2b2lkICpzZWFtbGRyX3BhcmFtcykNCg0K
Tml0Og0KDQpJTUhPIHN1Y2ggcmVuYW1pbmcgaXMganVzdCBhIG5vaXNlIHRvIHRoaXMgcGF0Y2gs
IHNpbmNlIGluIHBhdGNoIDEwLzExIGl0J3MNCmNsZWFyIHRoYXQgdGhlICdwYXJhbXMnIHlvdSBw
YXNzZWQgaW4gaXMgc2VhbWxkcl9wYXJhbXMuICBObz8NCg0KUGVyaGFwcyBqdXN0IG5hbWUgaXQg
J3NlYW1sZHJfcGFyYW1zJyBhdCBwYXRjaCAxMT8NCg0KPiAgew0KPiAgCWVudW0gdGRwX3N0YXRl
IG5ld3N0YXRlLCBjdXJzdGF0ZSA9IFREUF9TVEFSVDsNCj4gKwlzdHJ1Y3QgdGR4X21vZHVsZV9h
cmdzIGFyZ3MgPSB7fTsNCj4gIAlpbnQgY3B1ID0gc21wX3Byb2Nlc3Nvcl9pZCgpOw0KPiAgCWJv
b2wgcHJpbWFyeTsNCj4gIAlpbnQgcmV0ID0gMDsNCj4gQEAgLTI1Myw2ICsyNTYsMTAgQEAgc3Rh
dGljIGludCBkb19zZWFtbGRyX2luc3RhbGxfbW9kdWxlKHZvaWQgKnBhcmFtcykNCj4gIAkJCQlp
ZiAocHJpbWFyeSkNCj4gIAkJCQkJcmV0ID0gdGR4X21vZHVsZV9zaHV0ZG93bigpOw0KPiAgCQkJ
CWJyZWFrOw0KPiArCQkJY2FzZSBURFBfQ1BVX0lOU1RBTEw6DQo+ICsJCQkJYXJncy5yY3ggPSBf
X3BhKHNlYW1sZHJfcGFyYW1zKTsNCj4gKwkJCQlyZXQgPSBzZWFtbGRyX2NhbGwoUF9TRUFNTERS
X0lOU1RBTEwsICZhcmdzKTsNCj4gKwkJCQlicmVhazsNCj4gIAkJCWRlZmF1bHQ6DQo+ICAJCQkJ
YnJlYWs7DQo+ICAJCQl9DQo=

