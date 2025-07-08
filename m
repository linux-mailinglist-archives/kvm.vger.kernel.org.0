Return-Path: <kvm+bounces-51772-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 26E92AFCD99
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:30:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 231B93A5354
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:30:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E2CC22127E;
	Tue,  8 Jul 2025 14:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="D0MePuIM"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01902B2D7;
	Tue,  8 Jul 2025 14:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751985040; cv=fail; b=X2YJoQdMr1d7gmxbmWC7tZmRigfoLg6AdkaC3ZUf5XAPwqzz5dellNZFikThwj+GMeJWAmehJiYNCkiTIdljo/usr5OhuwEnxHTxbBfu8i/A8WQjgh2TUwV1EQpyK+8/khKzBBUF/L8Fz/eA2mRbKLjSI0BO22GBJbfujxL++v8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751985040; c=relaxed/simple;
	bh=RqrWC9AV8/hA8CNdnk16cFkYHRBCq0ZK94gxbtkxh1Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Rx4LI87L4auK24rfkq5kH76K3vCwL2D2IKEIFmVtUGbTM5+HdZHI/clhZt2CpY0ijDmfz0xMVoSOFBiG2nMBF7Zc2MwfTlXXf2Ndqs8E110OlhqRVt1u19MvU9+YYtzzb27urNtJ2pTYK8gzAUE2Lk3uoDW0/S8r0umO9i1wCj0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=D0MePuIM; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751985039; x=1783521039;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RqrWC9AV8/hA8CNdnk16cFkYHRBCq0ZK94gxbtkxh1Y=;
  b=D0MePuIMnpY2Fzn8grUBD9eBwvgUd2wqq1yGeIB+44OPZZpFAu6EObZv
   URQZhZxOy8CwEFiv6KdtlmMhTwXxERegfxqxc/Pjpk6faOwYTFwsXekqq
   cCnJQW1dCJ0xRUzrlbrKRMgkjvTO29D0YNUkdb8ufo8qy1sN06wrhiKF7
   2CCZ7qFwNDlBUFiZ5LydoTC93Xug9oc5YSif/N5BG870Kw4uCJiPvu1kG
   WB+Dyf1Pc8Y69Id6L8ZefTNwlTY0GOuf70WboaaV74wel/DZWaueF6Gqt
   jPKhagtv1KsK/zPQ7qSdmhQTF/n/tMj1pTlIg//cDVwsvoL0Lyp2EbkYi
   g==;
X-CSE-ConnectionGUID: /By9FukZQYWJUXoGV4xjAA==
X-CSE-MsgGUID: pHUm5tErTrKLakeuQwzQWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11487"; a="54156997"
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="54156997"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 07:30:38 -0700
X-CSE-ConnectionGUID: wa6B6HsiTUqDVwgIyXbNGA==
X-CSE-MsgGUID: CnM5PivkQpixAxKlFrVY2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,297,1744095600"; 
   d="scan'208";a="154921832"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2025 07:30:38 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 07:30:37 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Tue, 8 Jul 2025 07:30:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (40.107.244.55)
 by edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Tue, 8 Jul 2025 07:30:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r0iq83uGCTSDNT2E3NIklIv0XHrfeM+Ln3p8Kawpo54L2itrBHqSsrRIrVsTO2zjuJgazZ6tNbluKcssMMHXt1DM6TyxpMoQjjSUjRlxe+UMV0akxWzhNbmb6hbFfW0bLt4fmJcAbFU3YqC5r/AwfZwBHaMGEi/QML/PRPdiKR/OK4ycLuEmWSZYFqEYa3HlGqw9kOQuHM2S0c/qIETcOibw9n5LE8KNVtnqgtWhnnhW2zbLQrM8Q8n957OuwwF6n46eQKCiHGy7Tveawq6JDxf5/xmn074hC9kvJJekPqjiSQ1LsZ7RCdkilG6ZMFMWTbIbXDo4yL3/SX20grgn9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RqrWC9AV8/hA8CNdnk16cFkYHRBCq0ZK94gxbtkxh1Y=;
 b=zDLLYiP7OM4NHscUpq7XAFcFdGiawEgkSZ1NZaF9OLXrteQ//xgcdGXmJRqGwNvJB9FFHTL/hvRTK33P74yhEcVurK7DgCW3vIMsRElyVDcIUVPLIOwClORVByGBsYeJlDGdu5Uqdl4453RJAPmVQCyRlqzX/ZagJs2ehPZqFCygR7LUwNQlI76tnTSloH8P903bostLJIMYfwgMkl1SMVPBH97IIsTe+SWIS7Px8iftRrdUDQ1Dvf4WQm+8gCcUenm/fRYndjfHwkhryEuOi8L8yvFBrLpCM5JFaTqD7TxG6/nWTzHZ2uILqAC0YOsoAyZVeWwuWH8gqJFEorKf1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by PH0PR11MB5016.namprd11.prod.outlook.com (2603:10b6:510:32::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.23; Tue, 8 Jul
 2025 14:29:52 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8901.023; Tue, 8 Jul 2025
 14:29:52 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Huang, Kai" <kai.huang@intel.com>, "Zhao, Yan
 Y" <yan.y.zhao@intel.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "Hunter, Adrian" <adrian.hunter@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Chatre,
 Reinette" <reinette.chatre@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "kirill.shutemov@linux.intel.com"
	<kirill.shutemov@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"hpa@zytor.com" <hpa@zytor.com>, "Lindgren, Tony" <tony.lindgren@intel.com>,
	"bp@alien8.de" <bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/2] KVM: TDX: Remove redundant definitions of
 TDX_TD_ATTR_*
Thread-Topic: [PATCH 2/2] KVM: TDX: Remove redundant definitions of
 TDX_TD_ATTR_*
Thread-Index: AQHb79/kL1IMzQMDAkeaCY0EhhHzurQoQmKAgAAHY4A=
Date: Tue, 8 Jul 2025 14:29:52 +0000
Message-ID: <bdd84a04818a40dd1c7f94bb7d47c4a0116d5e5d.camel@intel.com>
References: <20250708080314.43081-1-xiaoyao.li@intel.com>
	 <20250708080314.43081-3-xiaoyao.li@intel.com> <aG0lK5MiufiTCi9x@google.com>
In-Reply-To: <aG0lK5MiufiTCi9x@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|PH0PR11MB5016:EE_
x-ms-office365-filtering-correlation-id: 20f42d08-3384-4eab-26dd-08ddbe2be70f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ekJGZ3huSy9HQ2FuWjVRN3NwaDEvaXRDdFcweDBTUmhBNS9ZZjhBa3Y0ZUJO?=
 =?utf-8?B?a2E4b2d5TWoyakNuSWZpYnpKS3RPYzNJL1Q5U1QxMWZ3TThCdXdudzduTEJQ?=
 =?utf-8?B?VHBPQ2VlV0JFa01QSHp0cTZJY3MxdktOUEs2TERPSS9uU2NyRUhYTlFiRlkz?=
 =?utf-8?B?aVo0TmpxS0ZPaHFva2tkdEp3a3pPTFY5Sy9ncjVPaitDd2pQamZ4ak5WVHJu?=
 =?utf-8?B?YXdlcldoRjR1UUtqS0NWVmdQdlJDNW9YWDQ1dHFCYkovMnVEOVFhRFg1dlV4?=
 =?utf-8?B?dnR0T0MvY285Rlk0dmhTU3NBM3hoRlBzT2xHem43ZzVBRTJidlZOWlFIQkNh?=
 =?utf-8?B?cEhmZ1ozNkVWQ2FmbE5DcHg3cGxPMUV1c3FyT255dzdzY3FmalhTN1pYczBH?=
 =?utf-8?B?MXUrMDg4QWJTcFdnM3RDbzNLYXMyK2h2TGc1YW1CYVNxZ3NFL2NXUVhGSVJ3?=
 =?utf-8?B?UG9rS0tHcUZ6Ylp2eitXZ1BKb2lkak5WNjNKZ1JObjM5OWRQcmJsQjltSXds?=
 =?utf-8?B?dkdPWVB5b1ROWi93TlkyVXBzdVhhWU9UTjQvbEhLUDRzNVIwczBvU2h2cGtJ?=
 =?utf-8?B?dWZQUEhoUnhwczdLOHlGVkQ5Vk1GN2pXSFZwRTJkYWk2eGwwMlR0MGxBUEg4?=
 =?utf-8?B?cUtaMDBLTWdGbkFEUUVXdnJtYjVHVmVmVVdLakN4RXBQcWU2bVgvZzhPNXJF?=
 =?utf-8?B?WC9XNXdYSVpTUE9mYkFGb09MdTJzOVNjRmdkd1JuMGMrenZzTFl1YkphRm14?=
 =?utf-8?B?N0wxRThxWXJMQno4STZLNDdjcDVES1Nac2RqaER5UUlnUlV3RjJJdEVlVDlB?=
 =?utf-8?B?ZHp6cTBZVVZBY2J1MDhRMXptMXdYd3Jad3JNYW5hSHN5OUVJanNVZVhhWk5X?=
 =?utf-8?B?NnZOZFVJVWRIcW92WEVLMmxZUENRVXFFRFpLbG9ibFZvMkN2VWNnYUJxSE8r?=
 =?utf-8?B?eFljSzZDT3UvTkFhVGY0QWxGcDVMVS94cWdrRTJlWi9EbkU5V2tHQ3Zmb0li?=
 =?utf-8?B?Tkp5TWROa2RyNFp4NG94ZVpkQSsyemFjWHdUYm1IRkdSQ2h0NWZzaktPcDBh?=
 =?utf-8?B?M2J6S3RtZU0vVDJxOXZ5TVNYeEFrc0pnbWp4QStSMUZuR1JnV2kwa1FWS1JG?=
 =?utf-8?B?bDNON1BrWlUwelFldWp5YkZoSlpvRnpBb3c0dHVRRHRqSDc1Z2QrcTFFa3Fl?=
 =?utf-8?B?RWtjbUNCODJqNUwrZ1hOU3RublI1dG44cmZ3dzVHOWJwcG1ham1xa1JzQ0ox?=
 =?utf-8?B?aUU1YVVLc1g2ejJadWlITXd6UFBhSWlRSWRnd01uMWpKVzRyODJjd1d3djE1?=
 =?utf-8?B?VW9SOFFmZVpPZkdiaW84YlZYcWhBQTQwd0llUGpjWTZ5Ulo2S3p1NkFXTDYw?=
 =?utf-8?B?TE5IbWorT2R1OGcveGVkUGs0Ym03VDlPMGUwWVh0VnBSR1cwWXROR2ZpMm42?=
 =?utf-8?B?L1hEVU5UMXJzelhxQW12K2dLYkNrcTk3NTlibFVrRXZkaVA5UWRuWFVYVU1h?=
 =?utf-8?B?dGo2Y1h4aytwQmFKcHlCVzNiYTFJNVVUWTdTTXIrVkFTNEI4VllCZ1lJblp3?=
 =?utf-8?B?bkZib2pnbWRsTnd6Z0U0MU9zYU40Vlh3aW5iMnZwZkJjaldPOWFiZTBjTUhm?=
 =?utf-8?B?OEJESVc1WjNISFZybkNodlYwUkRjaWhTbE5wZHM1VW5uZ0RYV09CczN0SU9Q?=
 =?utf-8?B?dnRNMW82SVZmSlpCT1NsMlBndUI2WVhYUnlEVisrVlBTS1ZFN0RuWDF6V1R2?=
 =?utf-8?B?MGo3VThPVXFiSGk3MGlOZTNxeE1uNDVubEVIZUxnR1cyVDBnSUZnNTlEaDZJ?=
 =?utf-8?B?ekpsMDZZVS9WWjROVmhwdDFjdlhoVUlNNTlCSkxGWE1nUnNaMEcydWJvQWJY?=
 =?utf-8?B?UzNaaEVCU3BSZHlmeG5Sc21KOFloNUdZeU5sUXZyT04yYmRTaXJDTEVidGlm?=
 =?utf-8?B?Y3dmaWdnOEk5RlIxY0w2Nzg1cVZscHk0ZlZ5bDVGOVc1cUZRdm40c3E5Rm9R?=
 =?utf-8?B?R3FTdEM2Sm5nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qi9RU1dLTjFueHQ3S1pXVjFjdjU4Tzg1cllFdlRLeWZYbDBjZE4vdGxSZkp0?=
 =?utf-8?B?OVRLQ0dDWWZIa2ExN0d6V3FWOWVjR2wxcDcyZjdTSFkzQkd4S1c3cDRYODUy?=
 =?utf-8?B?c3FzRWZseURIV3NTbUZRMmVvZG9LUERodldyaVNlOUlLVkNOclJ1SjRHTC9o?=
 =?utf-8?B?QjhTN3RHMWd6UXFJS0lyMExpTFNVNEdyOVFCRDdRMkZpRHcrSWU3aytkQ2ha?=
 =?utf-8?B?L21YUWVYQjZYZkg0allBM1Y2QnRndzBTRFRRd0JoeWJBWk0wODhqb3NlKzV2?=
 =?utf-8?B?TGlYVHBtR3NVNnBHTXNVVlE5NUc2WitDMm1FOTRRUStJTGwwOGlOZUgxQkRa?=
 =?utf-8?B?U0Rib256WjY3NVZEeXNkUmZQNURDbW5ENGtRclJtcEZFZDQweTFxZzM5NGp6?=
 =?utf-8?B?T2QxdWVHZE5nOXU0cm40WUNVUUNESW1xNmtQWXpKVEhsVVZ5cFpzMTR5dVE0?=
 =?utf-8?B?WU00YVM3c244UFRqenBQRHMyNzczM1d2REpZWU95YkhHRFJ6eDFGdDR6VXds?=
 =?utf-8?B?Q0tlTkZoM1FJVk44QllaMXRjSnUrdjBLWVBieGNaSjVyaTJPNjhDUTlaZVBO?=
 =?utf-8?B?c29OY3ZuSmFLaVR2VTlDMmFjcFcxbWRITG5GYkpoaEhFVkZYbGR6QWdRdDNC?=
 =?utf-8?B?aWt6d3U0M0phaHpRRWdyeSs5aTlpd0plMDdFbTl4TXFpSnhLZUlYT293THlT?=
 =?utf-8?B?S0RMQU1SaWUxdWs5Y0ZULy96YVRwNUZhNHhIZjNOSTRtMVZ2cVdDck5rNnZ6?=
 =?utf-8?B?MmZDTTRUaXRRUUw4SzZaaWpZV1AxNmZZN3lkT2ZrQVdSWlFVU2M5ZW1Zc25N?=
 =?utf-8?B?Vmk0OXdoS2xOZmNRbmpGMFRrOVJRN25GWlo0dGNvZ1kzZHkrS2pzY0N3WWNt?=
 =?utf-8?B?WWplQU1CUEJLZlB4a1puUnFpNEJId1EvRE5YNXh4OTViNXlhRVlPWUZmSVFs?=
 =?utf-8?B?QWVEd0hvNVZiMFNWdUQzUWZqcFRYZGcvRU9SSXgzUE1BczYxcXZLU0FaWnE4?=
 =?utf-8?B?b3VYUklQZml0Ylk0bEpxUEpuelo1VkNzUnEwWnB1UnJNZFB5T01WZFE3MjNm?=
 =?utf-8?B?TG02VmRXMFN6c21XQ3EvajZvR2h1U2dlZ2dndDFXem1xUnU2SnM1VUQvc0F5?=
 =?utf-8?B?eHR6dk54S3JRN0xuZmc4enNyblQwZWw1ZGExZjNxVHNGUXNuNlU3WHZwcWxH?=
 =?utf-8?B?Smt6UmtjMGJrbjhBbGUzVDdWVExSMWpiTk4yVHg5bjJBSkM0cXdvOXMyRlJk?=
 =?utf-8?B?Q1drR3Yrczh3N0wvOStOVjFaU0VxTHJvcjdFaFF5ZjR0bUFudDZsa2dCOFRL?=
 =?utf-8?B?Z1YyaGthUVpnQjlEWUV5WlRhSUVHMzdxUFlidnJrNHBLWDRLcVNtT3JrbVB1?=
 =?utf-8?B?c1dFb0lyQ0dMUS9xZEs2Q1d2eXVGTmRMWEtMZHR3KzR2ZUxuL3NwRWlmVEZl?=
 =?utf-8?B?T3h1SG8rWGdOV2F0T2NIc0dqLy9lZHluVzRLeEluRmVIeVBLL0MzSmliZkEx?=
 =?utf-8?B?ZVJhOW90aE16Y3daWCtqUnB3WllsOEhJYUtsaysvK2RwVHcrOWVUc0hvOUw5?=
 =?utf-8?B?SmR2ZlEwR3ZGS3ZZSWZaTFQrZGgwNzJpeUtzU1p6TmdnOTAxcGJubFRpbWNs?=
 =?utf-8?B?UW1LT0QxVGZxN0ZpeGNDanh0b0pXN09oQ2w3NEZ5Y0hyaDl5RGFnL1N1bTRL?=
 =?utf-8?B?UUxHaFJOcDJtc2d1MnN3c0hIWDJUbTViUmJ5SDV4OHhuaU5VVlN2NjB5cWdl?=
 =?utf-8?B?NUxPSzBnZ2lpNGxXdnVndEpCWEVmK3dPdExCZHJDdWNsOFhuZEpCZjE0dy91?=
 =?utf-8?B?YUVWNmdCRlFXKzlhMVNLdjVKQVBoOTFQWktBVHlnbS9zVjFhOUVCTGNMY29z?=
 =?utf-8?B?ZU5rN29Sc2JObHZEVFZQLzY5RzZEMHIwNmpYcHhDR2pzemtXdy9RcksyYW9B?=
 =?utf-8?B?aGtMbktEa0lJSmxFRUk5WlFqWks3N1c0U1FralNkd0t6SFY0OFVqKzNPV3R2?=
 =?utf-8?B?UHg0RmwxQTVBcnNJNjcxaE43MVU5a2tKbXJDcXRvYTNnVmd4YmpEM3BvdkJQ?=
 =?utf-8?B?OHpETTQzeUJEcEYySTRBOHJpVFI2QThhNXVHd3NyUmJGOFIrdkk2V3kwWWhv?=
 =?utf-8?B?TTFwOHpuKzRFS050UW1HaTJUaXRvUlV2SVAwS2VuaEkyZTVTSFhRRnN6ck9M?=
 =?utf-8?B?dEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <41A74119046A6C488DB881D48212132A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20f42d08-3384-4eab-26dd-08ddbe2be70f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2025 14:29:52.5438
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ueKbQu7A3pS3KiSSITz+12Q0efqRLRnHZU8VFH8BODzlKtaBU66TfxkTp7DPtFZCOIb8SmpnkRLE0fXJmDy7gJqmYzLxIYu/Vec5SpRPaMQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5016
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI1LTA3LTA4IGF0IDA3OjAzIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IGRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rdm0vdm14L3RkeC5jIGIvYXJjaC94ODYv
a3ZtL3ZteC90ZHguYw0KPiA+IGluZGV4IGM1MzljMmU2MTA5Zi4uZWZiN2Q1ODliNjcyIDEwMDY0
NA0KPiA+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gPiArKysgYi9hcmNoL3g4Ni9r
dm0vdm14L3RkeC5jDQo+ID4gQEAgLTYyLDcgKzYyLDcgQEAgdm9pZCB0ZGhfdnBfd3JfZmFpbGVk
KHN0cnVjdCB2Y3B1X3RkeCAqdGR4LCBjaGFyICp1Y2xhc3MsDQo+ID4gY2hhciAqb3AsIHUzMiBm
aWVsZCwNCj4gPiDCoMKgCXByX2VycigiVERIX1ZQX1dSWyVzLjB4JXhdJXMweCVsbHggZmFpbGVk
OiAweCVsbHhcbiIsIHVjbGFzcywNCj4gPiBmaWVsZCwgb3AsIHZhbCwgZXJyKTsNCj4gPiDCoCB9
DQo+ID4gwqAgDQo+ID4gLSNkZWZpbmUgS1ZNX1NVUFBPUlRFRF9URF9BVFRSUyAoVERYX1REX0FU
VFJfU0VQVF9WRV9ESVNBQkxFKQ0KPiA+ICsjZGVmaW5lIEtWTV9TVVBQT1JURURfVERfQVRUUlMg
KFREWF9BVFRSX1NFUFRfVkVfRElTQUJMRSkNCj4gDQo+IFdvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8g
cmVuYW1lIEtWTV9TVVBQT1JURURfVERfQVRUUlMgdG8NCj4gS1ZNX1NVUFBPUlRFRF9URFhfQVRU
UlM/DQo+IFRoZSBuYW1lcyBmcm9tIGNvbW1vbiBjb2RlIGxhY2sgdGhlIFREIHF1YWxpZmllciwg
YW5kIEkgdGhpbmsgaXQnZCBiZSBoZWxwZnVsDQo+IGZvcg0KPiByZWFkZXJzIHRvIGhhdmUgaGF2
ZSBURFggaW4gdGhlIG5hbWUgKGV2ZW4gdGhvdWdoIEkgYWdyZWUgIlREIiBpcyBtb3JlDQo+IHBy
ZWNpc2UpLg0KDQpJdCdzIHVzZWZ1bCB0byBrbm93IHRoYXQgdGhlc2UgYXJlIHBlci1URCBhdHRy
aWJ1dGVzIGFuZCBub3QgcGVyLVREWCBtb2R1bGUuDQpFc3BlY2lhbGx5IGZvciBURFhfVERfQVRU
Ul9ERUJVRy4gSSBraW5kIG9mIHByZWZlciB0aGUgS1ZNIG5hbWluZyBzY2hlbWUgdGhhdCBpcw0K
cmVtb3ZlZCBpbiB0aGlzIHBhdGNoLg0K

