Return-Path: <kvm+bounces-48030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA579AC8459
	for <lists+kvm@lfdr.de>; Fri, 30 May 2025 00:35:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 98DD77ABF72
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 22:34:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 630F121D3D2;
	Thu, 29 May 2025 22:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XnBS+5q0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99EB22CCC5;
	Thu, 29 May 2025 22:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748558127; cv=fail; b=piHXezrtA12c7HfRbUsa+LJX1VmBaJo9f0JJ6KrkGBcR4Er2efS+UYEerVmsvAT3GFVxaaqyzkB4VaFgU1a2AA6Y8s57m0QH6faX9nP5GBo5kXadADQenruD/BJUr8C6p/29jEhwOLEn3a69Km12wYbt9M7DHFVcqzPBiHaIooo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748558127; c=relaxed/simple;
	bh=RsaT8Ml/hc7c+NjIPaErmx/BBuWyvOxHEAz6WhAWqzM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=FlNs2iiJiJ0EsWd9t1X6ovTaC9e0enWewP03n/VlwgBsah//JiO69Tob5NjQuB8UeEKN/Vmxe+2dlngSPKXZ6vcGd5Jx81PzQT+vq0CtE4jgFm1y3EqVtiNlWILRm6MCm749Vh4bdxQHeXP5lWH/ASrK0I+jCRmO7OQCS+KTzT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XnBS+5q0; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748558125; x=1780094125;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=RsaT8Ml/hc7c+NjIPaErmx/BBuWyvOxHEAz6WhAWqzM=;
  b=XnBS+5q0lRIDManisTuRn72+vcsBQqY8iivpjIQ7EAdKgL2gwvsg524v
   cSJ2hWkPbcRkdw0OnxnmbAvhsBTjWbtPcpWWoOEi06K7faF3GD2+/ljGW
   lrtolMOQB7rrVyC3W6Q6YpD4drW7QUdqk0MfV+3zuMuHd0tBJ5hshrYHZ
   DPIIr1/XP2cL6PBhONnZfNnrnVJd4KRezDRIkPX/nLe9cJX8ML7uY5Ral
   grB6PtssOHBqfoywtvbCN4WPKJrUd6xe/GgZKpnzE6dopoj71i7wQWZYF
   I3qKc/a6dHwTPTraY0Lx5hEfM7IcQsmGtFw93n3UdaYQc53xDof9Md3u6
   g==;
X-CSE-ConnectionGUID: upqqYvLpRqCH8lzWap6suQ==
X-CSE-MsgGUID: UX77ePCuRbK5MCDEc+j5UQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11448"; a="76033942"
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="76033942"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 15:35:23 -0700
X-CSE-ConnectionGUID: EjBp/+waRLi1IATqXGsOsg==
X-CSE-MsgGUID: e/0ew/wIRi29LmYcC6zYBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,194,1744095600"; 
   d="scan'208";a="144681112"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 15:35:23 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 15:35:22 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 15:35:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.84)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 15:35:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FuP7f8MvCjLbor349AKd2knVm82cGwZb9WnjuoTENP53h8FsEghNNOw+fj85h7HTDO9XUX29ABdLsv0WLp1S8WPXhWoJCHwCIPohzWU20WhCMF6yo10uL5HtZGjOFHKDPaxMnBLbsY62zY9SZdb9jGePKudcZGpKJz219GrySYlVNamZHFqZNjxreHq8RTVQXiIXtjWFVXiNWorI44Xwoc17EoTOdhh0JKrI0vw1zJaghoMyekXadVvCgnqYbbSCdOazM56TTqN1OEP0DvdnX+E9oAX/DYR6baeO+J97hDwTUnskwA4L5eQU+YRwigxB1Fdg0HFWcfWq3pTk3yztdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RsaT8Ml/hc7c+NjIPaErmx/BBuWyvOxHEAz6WhAWqzM=;
 b=pz58UhQRXADEV3S96ZibEaM4bPjRY5gOzMGAxmjTGtTBy2get/5iFNU9J5pLJ9nbdaj2pptiWHQ1DC46uwEAR9gZqH4ryP5WrzdfbUC547RkIBHbmhtt/KfrQU1LLFHJCJrieWjsDtouR1bkb/pALl6+kmtnCNDBXqsLsXmX6bzSJE4NPUDE4cL8BTbhuTYd6ECCqFJDd1sPabusC2UfDXeHVr8QkQ5VvUh/VPXQElkkV09JC7JbjyxvzMlLPQTlnCKL8ZHoEMqr2zPYxZ6lwiTz4DtQAmOQf6DS1NfEP8RgsboU6vn7I4g+ouhf8IeQOP6trYco5TjN6OAdYMwedg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by DS7PR11MB8807.namprd11.prod.outlook.com (2603:10b6:8:255::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.27; Thu, 29 May
 2025 22:34:49 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.029; Thu, 29 May 2025
 22:34:49 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "vkuznets@redhat.com" <vkuznets@redhat.com>
Subject: Re: [PATCH 04/15] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
Thread-Topic: [PATCH 04/15] KVM: x86: Drop superfluous kvm_hv_set_sint() =>
 kvm_hv_synic_set_irq() wrapper
Thread-Index: AQHbyRXr46ysaQvN7Eq9mIGEm2qtCLPpigeAgAAytACAAITbAA==
Date: Thu, 29 May 2025 22:34:49 +0000
Message-ID: <9385b67be52925e52ac023e1f1d046d345514c5d.camel@intel.com>
References: <20250519232808.2745331-1-seanjc@google.com>
	 <20250519232808.2745331-5-seanjc@google.com>
	 <100ec82b37b7ce523a12b81623613b71e72c8ba0.camel@intel.com>
	 <aDhxlH3yT9XzFyDT@google.com>
In-Reply-To: <aDhxlH3yT9XzFyDT@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|DS7PR11MB8807:EE_
x-ms-office365-filtering-correlation-id: b9f622e2-ce90-4273-3d72-08dd9f0105dd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|366016|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ejZxUEFHOHRQd2hEOUVYQngxd1VWYVNCcnBtSUVUdDNyUHBIWFRaNDI0U09p?=
 =?utf-8?B?V0U4bnFEL3cvK1cxN0ZyUFlCL0pkOFhZS25MbTMvU3kxaXhtdmhRUmVkcE9z?=
 =?utf-8?B?T3Y0cXY4MmFkS1hFb203UlRWR1IwSXlZdDB5anJ5MWoyd056WWJ3NkVhM0Fr?=
 =?utf-8?B?TVVEWCtkcXFFZFFEWkNjWC9xUFpwcXZURFNId0wybEoydUg0N3RJT3lUVmo5?=
 =?utf-8?B?VngzcnB5NG5uSWFEaE1kbkxWQS9rKysxQU5pNUlsMkZBK0N2Z2Z2bmVDQWFq?=
 =?utf-8?B?bE9NSHVVRno5SW9sSWpUWHdFZzZsMjZhams2YVQ5bE8ydk9VTGRib2JxT1RG?=
 =?utf-8?B?V2VZRnJPNjREK2xUUmVNOFhDc2lzK1hoWDErMTNNSHhEWGFWb2RJTk9yNVdu?=
 =?utf-8?B?OFA2eTNmM3V5bFYxYTRibkI5MW5QQnNCWTdlclJ1SGFCY3hiNzhxMlhmYmVV?=
 =?utf-8?B?aHBMU1FSZXpaWklldEV5WS9qYzRZVHRJQkpnRHEzVmxsbFJETzFUR3JTMlVU?=
 =?utf-8?B?UFREZjE0T3Y0c0JUM0Ftd2huQXpQdU9QZGZjcU5zS0lxVzkvR2NJSCtmT2pP?=
 =?utf-8?B?dHNSdXlXRHorYVBPeWxmUEJQajh1MklTaWFCMUVQQVlWdmY3Z3ByaFlyYXpx?=
 =?utf-8?B?WUk0L3AxWVdtbnlsMDlXMVAvYzNkbCtxemdRRWtmL2dvNDBOYnBOSmJwRVJT?=
 =?utf-8?B?TlhFSFZPU3RjTVhoZUg2MnVVNWZLMVBJYStoRHVyMUFsNmVRaG9IR1pNVGtr?=
 =?utf-8?B?OEZRVUJkTVdtcDFveHB2M05KRlUyZ1NtMXppYkV5anRzUjR5Q1RwTExRdmpJ?=
 =?utf-8?B?NTNGQVFOdjM0b3FOUFVQSE9FNVZWMGhxMjQ1UyszUGdEQmtkL01XNm8yajJO?=
 =?utf-8?B?RnZUVTFnYmJTS25uMU0yL1ZTQ1EwWG5GWWhkMzJvdlRKMFh0eG4vc3hxM1Q3?=
 =?utf-8?B?UGRPNk9oOG1SNGNSMUpEVEJHQTZBM3pnYlpNa00rTGZlVVJRdlZSWUUrSEVw?=
 =?utf-8?B?T1FZTWg0aWRMMThIMStUN2w5S3hrRTdKbmltL2dXaEsrMU4wemhod0NRUGxQ?=
 =?utf-8?B?K2krWkNWUmdCWVlVWUdQWXNZdjlpY0RMekVsWXRQM1dOSkY1RmZ5YUNudzgr?=
 =?utf-8?B?czRCbGhiRE5lL2ZuVTUwa1dVL0txNU5UK01FOXZNcmZ6cWFxYUlnUHUwNmN4?=
 =?utf-8?B?Z0dkVjRiU3BWVjB1Rm9PUzg0TDdEL0ZORDVqVzQvUUhKNGpvZDZkUE4rL1gz?=
 =?utf-8?B?VHBaMEhUZ3YzYnlRTDZmVmtOd2tScGpXUlAyNi83NHZtTitxdEhuNVNKbjZh?=
 =?utf-8?B?ZGpJT2E0WXdoYjdiQkcrcXc4LzNxSXY1Q2FCZmxCMFhXWGFQMitxV2xRZnNz?=
 =?utf-8?B?Z2JyK2ZydkJIaWNVVzRIK3g4L2h0Tm42clNDWWtwcExibG95SzFVOWtTTnNF?=
 =?utf-8?B?SGdFVVQvcHc1eWtybHJhY3NqTGRPRDVaNjBZZk5oM1c3UktsaStUSnloa3Fu?=
 =?utf-8?B?VmVqQUxpWjRScTA1R0h4ekVRaXRiZEsxTTBCTVMzS2hHTmdDQXZFN2tCeGpH?=
 =?utf-8?B?NCtNd0ZFbllhVHFmTU5kTkRadHhPbHk1S2FQVStxQ1h4VmJRd3c2b1RSb1l3?=
 =?utf-8?B?TlhyVGhTU3VWbWE4dDI2eEUrcXpLZUthVVlqQ1FTaWYwRGtpbU53ZjNKYVBx?=
 =?utf-8?B?VG5lVzBORmJuRmJtSTNxMmFzVkRyVGpjZnVsR1FRZi9SOUNpcFE3MHFjMGtr?=
 =?utf-8?B?a1JFdE9HRGthbWQwQUxKdlZGVFg5bGVjMGNWV1BacGZPTkY2WHdMekRkRy9H?=
 =?utf-8?B?TlVMR0xYNnNvekFxVkVJV3cvR0dWd0hWRHpJN1kxQkUwRDZNdjFrTXh2dGFZ?=
 =?utf-8?B?YUtFaGEyeDgxSGlsYUdjazZDQTZnK3EvWmw2bGhDanA3TGxSeFVaM0tNN3BR?=
 =?utf-8?B?a2txSjZyZFprS2JUM2U5R3BpZk9WaWFEcW14Z25JaWxmUldMbHpwd1RHRGtW?=
 =?utf-8?B?UFRqa0gzejVBPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bEw4bzR2SEVXaC83MkxMY3BGYjlXbDJUK0xSZWxOUDNzck01OWpXclBWS0o2?=
 =?utf-8?B?NVRnaUVwNy8xamRwWXlNdnl5eVA4TVpUTzlCcWpTUEh4ODhBMWlmSDBIT1Vo?=
 =?utf-8?B?a2ZtVDBMa1pFS1RLNVZSeUR0dWRnL1B6MncxeUxjaC9DUlhRdGZTTVlVdXlS?=
 =?utf-8?B?NUkwNFh1cnJ5SUtURklPWWRWUjlDUFBSQmp4MjBMLzh1cC8ySU9peE5EazBl?=
 =?utf-8?B?aVhHWGdaK21GbzdDemo1SkJxR2NNaUN3U0d4bUEvOFRRbnluYUVaUm9qZkNz?=
 =?utf-8?B?ZWlRWWVnRkpKcjlkbmE2aU9kNFM4Y2tsaUEzeU0wczRYQ212WmtPaEpWVVlJ?=
 =?utf-8?B?UXl0UDJtVkY1aTZtdzJpVEJaTmgyR2tqQmd0VTRwbFRXdFhvaXpDZHEwRm5v?=
 =?utf-8?B?eEFQMFZGazVwNFBKcTQ1NXNKb2RuTndzUEMyRjFLUzk4aG5rNGx1Mzh5eHQz?=
 =?utf-8?B?anloZ255aXVmWGU2anhEQm9Eb0lCMFJPYjhTYXN2YlNVckZkZk42dDJ0ZUQ1?=
 =?utf-8?B?aXNxWFQydWdTaEJHU3REWkhXcEdGc1VPaEswbG50WEFZV2pYanhackZ5WENa?=
 =?utf-8?B?YmpzSFhGRkFVQi9temlsbitxZnRndS8wZ0hpWTU2b2QxN0xaRkpIUG1BNTcx?=
 =?utf-8?B?cEF4SEZQYzM1VXRiQWFuRGc4bjRWay9wWTFnYzNOQkdSZE10RHphRGVxdzRX?=
 =?utf-8?B?MHJGVnZBWEE1eXpiN290TDdwZS9RYXpFL3R3YVVsRlcvbkVnWGJzdUtUNzhu?=
 =?utf-8?B?SEJLQWNEM1JIeFptK2RSZmd2VXZqWUpOMUZ5S2J3THNoR1dQa0hxQlM1dmxU?=
 =?utf-8?B?WCtjRVlOVk56cnlaYk8wVjFTcVp2R2Mwb25NeVZ1K0tLTjI5aWRjMGVtcnpK?=
 =?utf-8?B?VlNycTd5U0ZYUzdpQ1BZdEl4SFRpbXpCcGpVSFB5ZEt1V0xIQTVLUDFzU1E4?=
 =?utf-8?B?c1ljVXAwZTA4U0N4Mk02RHNQbzBKenIvOUVnWS90SkRnbEgrYXF2SUVzbkl2?=
 =?utf-8?B?TEg3OHZROHdzaEk0QnhlQ25FTWhhQXVBKzMxUWdaOGJEa2FqK1lST2R5aE9y?=
 =?utf-8?B?cE5sVGdGQTczOGJFRGhUeE1UZUFYb0xxanY2NUZvenJIVjh5dSs0b1lwTjJK?=
 =?utf-8?B?Z2hkTURyYjVMTVZWSnNxbTdZSzJYSStKekw3VGk4eEtDcFA5am5YV1R2R3hx?=
 =?utf-8?B?UllJNmNIMU9peUFrVVZsNHkwd2VIbGh1dDI5Q2JySEdnL2RibzRnenNHNndr?=
 =?utf-8?B?eXpYV3RCZGtRczRmSmNrdUE3RmJKTm91R01tczdTbHI1cWtkMGxHV0dmNGpB?=
 =?utf-8?B?KytDd2h1L0lUNDBPcFFnbDM1Y1lxY0lLam5naFBvSnBMdTBZeEFRWHdvWUpN?=
 =?utf-8?B?TThWZlpCK3BvejRKbDNGVUdUbmE0NDd0UE8waW9pMHlpUndiblNoaHNEY1RZ?=
 =?utf-8?B?TFpsY0Q2YWM1R3JkNlNWMlZuRVVDT3dqTjVvbEYwUTQwMWRsOFJhVzd4UWtV?=
 =?utf-8?B?TlVGQjBuRVB5NEw3RmlaalRPQWFnTS9BdHRhbHIwOTNhMUI0N3VvOVY5SlB4?=
 =?utf-8?B?RFJQUHNyczhpeEZXRUdIdTBFUzZ3ZE1oenpFamhYVFRMVmhNTmRLM3hjQmhl?=
 =?utf-8?B?SHNETG9qMUtxanJPMHcyM0srRVhnN1ZqcDdqTlZ1ZTdBelcvellxOXEzUFdE?=
 =?utf-8?B?eGlpQXROTUh3ZGtHL25LL1hlelNVa3Z2Rjl2cGJDQ3lmaUdjSDAzcjZ0MkJS?=
 =?utf-8?B?VGRCaUZDbnJzN0RncjJQYk5oWkxDdllFVjJMZ3lHNXl0U1hRS1F2ZTdpWWdu?=
 =?utf-8?B?Uk15QUEwaFdYR1hwaDRjeE9UVEhYWjg5amxCK2haa1Nsam5UNU5pczdZNnNh?=
 =?utf-8?B?ekljSWZBazVlNVdSMk9DR0ZGM2RPdW0ycWlROUVTODVKaGxkL0ZQT0VaeFBK?=
 =?utf-8?B?Ukl0REZPM2lwTUNmRDRaaUtsdFZ5ZnVaVkdsTkF5ZFF3S1NhUHQxYjlYQzNK?=
 =?utf-8?B?SWw1aGUyRkE3bzV3TnRUSFJkWmVza1FLT3dLQm5PQzhtU1RkOWhxZHRaeUV1?=
 =?utf-8?B?dGRQYkhYTHF4c3B6Sk9KL3lRK2F0MVlTTTVoSmlPVW1BaHZWckIrMWlqL0ZK?=
 =?utf-8?Q?Wj8+JXKhaYhGEGDVqhhXK5HVZ?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <18B0C84837684D4DAB8B259D2D85AB47@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9f622e2-ce90-4273-3d72-08dd9f0105dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 22:34:49.8441
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SEAh/V4UAI28dfZliR1Y3yfLhq2fMFlDaeClGN2zYR+Tl3PfJ9OLhymwliI/RyvK5M/Bv36IFX07KL4z7ir/wA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB8807
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA1LTI5IGF0IDA3OjM5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBUaHUsIE1heSAyOSwgMjAyNSwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIE1v
biwgMjAyNS0wNS0xOSBhdCAxNjoyNyAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IERyb3AgdGhlIHN1cGVyZmx1b3VzIGt2bV9odl9zZXRfc2ludCgpIGFuZCBpbnN0ZWFk
IHdpcmUgdXAgLT5zZXQoKSBkaXJlY3RseQ0KPiA+ID4gdG8gaXRzIGZpbmFsIGRlc3RpbmF0aW9u
Lg0KPiA+IA0KPiA+IGt2bV9odl9zZXRfc2ludCgpIGlzIHN0aWxsIHRoZXJlIGFmdGVyIHRoaXMg
cGF0Y2guICBEaWQgeW91IG1lYW4gInN1cGVyZmx1b3VzDQo+ID4ga3ZtX2h2X3N5bmljX3NldF9p
cnEoKSI/IDotKQ0KPiANCj4gVWdoLCB5ZWFoLCBiYWQgY2hhbmdlbG9nLiAgTWF5YmUgdGhpcz8N
Cj4gDQo+ICAgUmVuYW1lIGt2bV9odl9zeW5pY19zZXRfaXJxKCkgdG8ga3ZtX2h2X3NldF9zaW50
KCkgYW5kIGRyb3AgdGhlIHByZXZpb3VzDQo+ICAgaW5jYXJuYXRpb24gb2Yga3ZtX2h2X3NldF9z
aW50KCkgcHJvdmlkZWQgYnkgaXJxX2NvbW0uYywgd2hpY2ggaXMganVzdCBhDQo+ICAgd3JhcHBl
ciB0byB0aGUgaHlwZXJ2LmMgY29kZS4NCj4gDQo+IFRoYXQgc2FpZCwgZ2l2ZW4gdGhhdCB0aGUg
dHJhY2Vwb2ludCBpcyB0cmFjZV9rdm1faHZfc3luaWNfc2V0X2lycSgpLCBhbmQgdGhhdA0KPiB0
aGUgSU9BUElDIGFuZCBQSUMgdmVyc2lvbnMgYXJlIGt2bV9pb2FwaWNfc2V0X2lycSgpIGFuZCBr
dm1fcGljX3NldF9pcnEoKQ0KPiByZXNwZWN0aXZlbHksIEknbSBsZWFuaW5nIHRvd2FyZHMgYSBz
dHJhaWdodCBkcm9wIG9mIGt2bV9odl9zZXRfc2ludCgpLCBpLmUuIGtlZXANCj4ga3ZtX2h2X3N5
bmljX3NldF9pcnEoKS4NCg0KWWVhaCBMR1RNLiAgVGhhbmtzLg0K

