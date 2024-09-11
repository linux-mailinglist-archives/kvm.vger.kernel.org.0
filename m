Return-Path: <kvm+bounces-26562-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 06F2C975899
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 18:36:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 274D31C25BBE
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 16:36:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 782C21AE873;
	Wed, 11 Sep 2024 16:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MKB47R8z"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBEF157A5C;
	Wed, 11 Sep 2024 16:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072589; cv=fail; b=Qc8AzE+iZP/S+VumeaNuPtaEw4EbSnagx+//SsJin3+1fRak8Jp9WtctYfje8bhT4VR1JUf/YCWdZwgH+kiKdsVwWDT/oCoz7qGnB11v6pWt8wae340Wo++xz3PJdSbFT0kzVwPrPYEaFgm4xak97C2R4DPOzKF5TZB4Dey4RHw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072589; c=relaxed/simple;
	bh=3zV0chMfjpahQHRXzX+n+TGdqVsOuh4cRXJ3EtDXaHM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=av3S6p5K4/Eatt4WPvikDpAMcngesXNj4341GIVxJGbCAhJ9IQ0dqs8EPamJMFjxaF5qVnwfZB2W2De2ikWCx/1opnzcBlo43QqRYELIj6cKms3DPWSGkudwVHDwH8Be+IYsdQTd7R/rzd7e6A4OoKHZNjft+dpRh8+azzW3Erw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MKB47R8z; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1726072588; x=1757608588;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=3zV0chMfjpahQHRXzX+n+TGdqVsOuh4cRXJ3EtDXaHM=;
  b=MKB47R8zv8B2nl9e5s7ltWFl7gMsI0iENrSOvFw8NdVC7juQbySWBLMy
   WPzrGp40h8ShYWvs+L52ZE8jlMDz8y4A7GwZBRIHsoOILpq4kyCfRkxwo
   c28A/Jy/5SCRYC94n1TjCwPssQ0tM3YI6iJ3EvuNqXmKDSDZIuUSVsn0g
   bWkKx8l1gq0VQe/Ky7p6Rv7hCBZdjIRN4X5QdgAmfck2HTw8k0y2raDkx
   D5cwUdwOZVKvkIP8I9AhKzTI/11Xo16drOZhHhCks8GoaioB8fR3wqNCn
   D040wqeWwpe7raOL5oxEEe9wa1S4pUhpAkvpxcC+miBpnUmkOY8XGWb8s
   Q==;
X-CSE-ConnectionGUID: YfPnoBDoRtO5fVswpZZ9qg==
X-CSE-MsgGUID: x3O3ffzkQwWDIu3Et8ozDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11192"; a="24760985"
X-IronPort-AV: E=Sophos;i="6.10,220,1719903600"; 
   d="scan'208";a="24760985"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Sep 2024 09:36:27 -0700
X-CSE-ConnectionGUID: kC5WqMTSSE2L1la7dSYVJA==
X-CSE-MsgGUID: etj+5ZF+SpCPYiyW5MirSw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,220,1719903600"; 
   d="scan'208";a="71803669"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa005.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 11 Sep 2024 09:36:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 09:36:26 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 11 Sep 2024 09:36:25 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 11 Sep 2024 09:36:25 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 11 Sep 2024 09:36:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zQtF3clA/wfnISgbvJmcEghJhL8FMxT9g/IWI0eJOaPC43P67Ov2hgtMAbrVWro5gP8gOYZW1Y/nJZAIZiKysmZKaccDmvidMGkooD8qv9wOiT7V1SLBWVwG9xNr+0Nr07r7sJyn+YH0tu3F4gdWS4faVzMZPvIB3mltsJx1NL+dkrTIRtRhkAFSAx01ojYYMAl5RQ9oylaubEc4RoSRqjMf0G67Paz3cCFLVgJokUZH7kuvgOEnxIbfA/rfnJYjmqYQTvhFcFOfL8T8fBb47DfTAXg2EfVu58ulNiZHLMpl7KHczE6kTWFIR/SXDJCmYIMF6dYJ+MljoOX1iJbj2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3zV0chMfjpahQHRXzX+n+TGdqVsOuh4cRXJ3EtDXaHM=;
 b=W6crcklI3I+mM+ZJjWsCmnWkiRSdbAAydwnh6i8+uYFWOvdMGJ2RbTYwDhJbnJtnmJMXlV6U/LvPwPZ23RVyhRQsHXlVdkrsJvhbmKw4l4cafIMX2hpmXguVUQ69oOLQjB92yGZHv1I6VSI7AqN9ytpYLyxwNtM6KUJB0PceeYonCSMEo1ro8jA9slRid9FiNXUYeM/6toL+Mvd4G+oEPeH90GD/++zQG3IeZsvfRV+OxiDD13/V82XZwMSayJdZkyR7Krnnqzo1XUFTVzmYD89+7PvnCNhD5Loz4ouR7zLDQ8xMqoly0Nd/MYN0qTBSNpYXlMZ1HgNGN8X4ZJF8kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MN6PR11MB8219.namprd11.prod.outlook.com (2603:10b6:208:471::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7939.24; Wed, 11 Sep
 2024 16:36:22 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Wed, 11 Sep 2024
 16:36:22 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>, "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "dmatlack@google.com" <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH 16/21] KVM: TDX: Premap initial guest memory
Thread-Topic: [PATCH 16/21] KVM: TDX: Premap initial guest memory
Thread-Index: AQHa/neylxoaYrTILUWaulhlDyL5EbJQ4UMAgADldQCAAKoFgIAAY8uA
Date: Wed, 11 Sep 2024 16:36:22 +0000
Message-ID: <e69406690a063874f72267cd656dbb8f393c6e47.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-17-rick.p.edgecombe@intel.com>
	 <09df9848-b425-4f8b-8fb5-dcd6929478de@redhat.com>
	 <2f311f763092f6e462061f6cd55b8633379486bc.camel@intel.com>
	 <CABgObfYiMWrq2GgxO4vvcPzhJFKFGsgR11V52nokdbcHCknzNw@mail.gmail.com>
In-Reply-To: <CABgObfYiMWrq2GgxO4vvcPzhJFKFGsgR11V52nokdbcHCknzNw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MN6PR11MB8219:EE_
x-ms-office365-filtering-correlation-id: ec47936c-06d5-4bc4-855c-08dcd27fdf19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SW5vM3lBN3FCa1ZtV3hTZ1BDRW1pSnVoVzh0TWRNNmV4K205QlZEcDhMYTRY?=
 =?utf-8?B?eW8vZ1hvS1VmQzI0MmhJNG5RUjYyd2VRejNBZGd1Zit5cjYraHpxaEcxa0sx?=
 =?utf-8?B?VXdXa0lDYW0rOEMwV1ArV2IrNzI2UWlGVXVwYVVmd2IwTHF5QVd1ZUtJblp6?=
 =?utf-8?B?c1Y5cE5zOG82ZFhsZHcyWFh1VlJRWHgvdjBFM3FsS0xuQnFNRUVwLzBUSEhT?=
 =?utf-8?B?cUM4ZTV3SU1tSEZta0YvNmtLRFFGRHZEU3BiR3JVZi9maXNxVS84MlpEME5s?=
 =?utf-8?B?NXFRa0VHMXhiRjJaeW5HK3hBditSRVQvbmhObU5zcVVHR2FIaWZrMENtQlZZ?=
 =?utf-8?B?OFpBRUplVFNHQ0lQdjZTVnh4MzlxM2ZmZnZLZzlkVnV2YjNkcUhpMnN1Mkc3?=
 =?utf-8?B?Q2g3Ty9ZREVadWZ0Q2MwZ2VJNWVqdzNZalp2OVlydnBjalJKOVptNjNVZ2Nx?=
 =?utf-8?B?TXZSUE5qeVJpa2Q2ZkRQS1FSczkxNVloNE16TGNzMXFITHpHRWcyU3RhaVRM?=
 =?utf-8?B?UHE2YUdZUnVNZU8zUFp5cnc0OFlIS21IN2dyenk1Yi9nY3VhRVFJcWoyNVZK?=
 =?utf-8?B?N1d1eG1SUzh1RWM2ZWl5MW53eWdhYTZSbDBUbUNObnZxbUZSOHdvdXZteG9h?=
 =?utf-8?B?Wk5HRk5YUkJJcFVlNnFteTFPbjJZN2RjL20vZXY0TEp1bTBCOWxyMm43eGpG?=
 =?utf-8?B?NXY3Q2xrbDdRNVVYMEdrdHowcjhCOWJ4OHR3ajBNaW9RREZ1cHBnUU5kUWJU?=
 =?utf-8?B?Wlh3dzJSZHVhWE9wNHV5eEFWbEFhOWtidHBpcTRPUzhTSGFMbEFWa1Z0WDYw?=
 =?utf-8?B?VkFuL1krSmp4Nk93eXNMeXBCR1gyeGttdXV2STFzSGI1b0kxTVQrSkVadlpN?=
 =?utf-8?B?YVFRRytjT3V6SkkrRnVaKys4N1RzK0xqQU02ZVRFOTNlVmQyeHlTYTh4TVR6?=
 =?utf-8?B?WXkrV2R5ZWVwdnlzQUNITkc0RWZCVGZNZElvQ1JGSG55eGdabFErWFlUQk9D?=
 =?utf-8?B?aERrckxXcUU1d0pmWThuRGdyVzdlaDRjVytVZWUwQzQxV0YzQTlYQzJXVFBC?=
 =?utf-8?B?bXRSSWViTmUvSUo3ZmZvVGJsNGdxQzNlcUlDNjNEV0lqM0lFejYrMmNuam5i?=
 =?utf-8?B?c1lhUURKUStKc29BUW9vVk03aGM4RVRxaFIyN3M0L1dPTUcwbmxRVHZ2ZS9z?=
 =?utf-8?B?SDBMamxDMU9HVHNTdk9ic2ZJSnR1eFRUejl0UHRvU0JLdDZnemxlVS9LWlZ2?=
 =?utf-8?B?NEQ5UmtFZ0hKY1hreGF0NlNHb2pxTkx6R2JzbW1MaXJ6dnlkbFpmQ1dSalB0?=
 =?utf-8?B?cTM3M2J3dk9VSFpQRXo0QjltQjd4VkZTNVYxWmpZVlRVcmJERDFHZzA5RFIw?=
 =?utf-8?B?eWRycjh0NWhIczZmSXcrZmpQWFJhT3M0K1dBY2pkOVZEYlRzYVlhaGtlT01C?=
 =?utf-8?B?QjZJdlJwaSs1ejIra0FxODJiZlF2dUJkTm10bVFVR2VWYU1wMFZQdUVvcHpL?=
 =?utf-8?B?REFzVzFIWFJCMjA0RzlqMFc5bDdnZ2V5WHdja05US3hlMURXMHNQL1lhQU45?=
 =?utf-8?B?alppMHBJaXVnR1NEZi85dUtKQW1ocWw2Wk55eU50S2M5dVp3WkdyVFlocW9t?=
 =?utf-8?B?S05ndWlEQ216cEQzS3h1S3JIbTZWc2cycDVjbjdPY0NMc0o1U0pBbWNLcXkz?=
 =?utf-8?B?MHFELzVwem5NM3djdzlpVkVUWUxvQXBIMlppczhFQ3FTZ2xYc0dmRUxXV25t?=
 =?utf-8?B?V2EvK0t1bzZDOE8vRWJmeG5iZHJwdURUVlNvZjlEU3k0dzY3TDBTWHNwdm1B?=
 =?utf-8?B?Y2FyV1RNeXUwWnJtWVhwaVNQLys4T3ZMVThQUm8yUFdiKzBGS2h0bFhoR2p1?=
 =?utf-8?B?SWRiRHpEYmNuVEZUR3VwRTVERDhzSnVYMGVmNHVkVVBUR3c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1o1REdlV3VOdGVTbEgwU1B0YjRDZzZJNjFibEg2bDBvSXoxYU54WHVaWUxJ?=
 =?utf-8?B?M2hHMG9XRnZkTnl6bE54SENHb3R2YklVWFNrVStIL1dxZElVVXZqb0lJNUFM?=
 =?utf-8?B?TjRxN1FQa3ZWNGYyV0Z4WUJmWFc3NGdMZEtnNFlWR1NyOGRYQ0k0SXdqbEpa?=
 =?utf-8?B?R1h5b0YwbWVFQ21UVUJTdlNCRjhXWHV2YWh6L3hWS1hCcFNEWHdqS3A2N0Fj?=
 =?utf-8?B?MGp3VDhqdVArZE0zMTQyN2U0c250Tmo2NkFyWlpJSGVFQm1kRldOalRJZzQ1?=
 =?utf-8?B?b2FxMHJwWEdrM2lOZGFidXFId291UkxHUngxeDdTUzRUOUJGZmEvZFNDZDRB?=
 =?utf-8?B?NS9iVU9oclQ5Qys3UXIwQjB0NHEvTG1EVEFRejNsZkh5bkt4SzNwbGVzd2Fx?=
 =?utf-8?B?NFVDMFU0QXdpOXIzQU9LV3RnbU4yWUM5YUdqcXFCZzZFU1dzemt3bXkwRVZT?=
 =?utf-8?B?SFlQVEc2ck4vOU5NU1ZVcmtmQ3gzOXdXWnFuZnB5amM0YTJGOVQ4U3pyZ2Jo?=
 =?utf-8?B?M1hISHdMNXBxUC8vOE1SQXpuTVRwcFk3Zkh0UWxCclovaEJHZFJQZnRZbUwx?=
 =?utf-8?B?b21jRHJOaFIzcHhCY0UrM1U4ajBRcmVkdzhtRXZkaThWcVIzaFcyUWVoaXpu?=
 =?utf-8?B?UGxBTllHRmR4eHZvdDRlU3pBYVRkQzVvYW0vaHhpY25hcm1ScitZNkk4WlNi?=
 =?utf-8?B?MElRbzdxcjlQVHlyWEEzU0VnYi9LVjNucm5yZnFiN0JxOXlNZ3UvdlZFKys3?=
 =?utf-8?B?TSt4ejBKY0ViZWlXQm1NNEhwMWJXY1dJeDZDSmMvVDd0Tk40a2ZBaVlIQ0ZB?=
 =?utf-8?B?alloZlg0RVZxK0FOUXVxbXpQTVdrYXljUmMrazZZeVgxdUNEdHdGWXRDSGlM?=
 =?utf-8?B?VGRJMGdDSGVId0phek1yQW9tY0VkN1FzSWFsQStra2UxWUdYcjFrVXFyb01w?=
 =?utf-8?B?NjhsUnowRWlsSzczMC9IbzdOQ0dnN0dORVRiQWx4Sm43MVVRUndHcGRSRnJx?=
 =?utf-8?B?ZVhsNU8xSC93K1g3YnJFQzQwdHZWYllmVzV3YlhYSllVMS9nbkp2U21Rclhs?=
 =?utf-8?B?KzNHUEs3N3NiTEhQNllZZUJtdERyMm10d0VwN1hiZ3k1VFhrckh5ME93WGgr?=
 =?utf-8?B?ZEJEanFXc3R6UUtaRGs5bXZ4MkdjYlI5QkMwU1ZJdUg3Z1E4bjduRHIrQ3Bx?=
 =?utf-8?B?RDdhNC9vQmo1VHlqaHYxMnRxSUQrNU56R2hlRlpmRE41TnFvZHc1SXBINFNi?=
 =?utf-8?B?RXl6L01jYml5YWVkYmVQdnpiNzY5UWk3TyttOHE2NDVwTFkveitGOWtORzA0?=
 =?utf-8?B?SCtGb3MxcGpocVMzRDdza0hmekhvVHI5dzFSVGFFQW5IOTBlWUlYUnFmQ0gx?=
 =?utf-8?B?QWkrcVJxcmFyb3BWSzVjdTJqeHd4OExxY1VKWksyRkJiKyt3TytjOG9MYXZ1?=
 =?utf-8?B?YlEzS0pUM1FnK0lzSVVVblV2WlRFNUl4cno1WkFQR1hncVN1VWVmZ1V2dUhy?=
 =?utf-8?B?ZmdyVmhEYmMrTENOU2lwNVpvMEZMc3dBVHY4VHVrNFdteE1lZnAzeHl4Sm51?=
 =?utf-8?B?ZWpDNTRkakk4d1dvZHVGcFd4cEl1dDQ2a1ZqZy9KcXJjcVVYM0MwcmpkNEZP?=
 =?utf-8?B?Zjd3REdtdDBWSDBYY0dLaC9hbm1vMFBhT0g2L3ZSdVltVWRmSWd4WTNlenZM?=
 =?utf-8?B?SkpIeTU4YTNqKzc0WlEvdFhWcFpjMUZBc3Q3WlBpb2tiK1VkQU1nd0dpRFZR?=
 =?utf-8?B?Q295THBaK2V0UGdiQzFxamMwRFFXdGM0QXY3Zy9DQ1FpOTNWaTFsQSswdC9U?=
 =?utf-8?B?TkFkSUUwKzlrcEQwczEzUHlaU0tlMFlKd3YrT2RQVUhSeDIxODUyVnJWb25j?=
 =?utf-8?B?elJqV1dYZ2ZBSVJMTXFrc3hmU3NYNlJLSG5WWURaUGg1Ni85alZhcEc1Tmt4?=
 =?utf-8?B?RHFNYy9yU1NZMjc5VTgwVTBOUHVpZDVPeHVwMStNdFFOU1VBTFk2UlJ6Nmk5?=
 =?utf-8?B?NVdTMGJ0NkFjSWZ4UkNoblpGZkFTN1dLU1AwcnJGTk10OTZ4bmQvaEZRRXN1?=
 =?utf-8?B?MWVmbEdGSm1zRExjQTFTT2Zsd0RLSTV0WmRoTzJUdDFURk1Fb1N2V2p3bVFF?=
 =?utf-8?B?NG44aFI2cG4yemtmWEh6aWpEdEs2R0N3Nk1YOUd1dHl4MzVUMDZjWDRld0V4?=
 =?utf-8?B?Mnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE140D0CF00CF944A65713D95A5D5F67@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec47936c-06d5-4bc4-855c-08dcd27fdf19
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2024 16:36:22.4971
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vSCcBHgE5bIopGE6fGuzr42/pVLtptJhnGNtoB/2qQ20FjeLSqGPPGXPBrDPGnqFJGzvBntoT05dEtZppDdzBxCm0DyhA8oXcdYlXzoenRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN6PR11MB8219
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA5LTExIGF0IDEyOjM5ICswMjAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiBXZWQsIFNlcCAxMSwgMjAyNCBhdCAyOjMw4oCvQU0gRWRnZWNvbWJlLCBSaWNrIFANCj4g
PHJpY2sucC5lZGdlY29tYmVAaW50ZWwuY29tPiB3cm90ZToNCj4gPiBBcmgsIHllcyB0aGlzIGhh
cyBkZXRhaWxzIHRoYXQgYXJlIG5vdCByZWxldmFudCB0byB0aGUgcGF0Y2guDQo+ID4gDQo+ID4g
U3F1YXNoaW5nIGl0IHNlZW1zIGZpbmUsIGJ1dCBJIHdhc24ndCBzdXJlIGFib3V0IHdoZXRoZXIg
d2UgYWN0dWFsbHkgbmVlZGVkDQo+ID4gdGhpcw0KPiA+IG5yX3ByZW1hcHBlZC4gSXQgd2FzIG9u
ZSBvZiB0aGUgdGhpbmdzIHdlIGRlY2lkZWQgdG8gcHVudCBhIGRlY2lzaW9uIG9uIGluDQo+ID4g
b3JkZXINCj4gPiB0byBjb250aW51ZSBvdXIgZGViYXRlcyBvbiB0aGUgbGlzdC4gU28gd2UgbmVl
ZCB0byBwaWNrIHVwIHRoZSBkZWJhdGUgYWdhaW4uDQo+IA0KPiBJIHRoaW5rIGtlZXBpbmcgbnJf
cHJlbWFwcGVkIGlzIHNhZmVyLg0KDQpIZWgsIHdlbGwgaXQncyBub3QgaHVydGluZyBhbnl0aGlu
ZyBleGNlcHQgYWRkaW5nIGEgc21hbGwgYW1vdW50IG9mIGNvbXBsZXhpdHksDQpzbyBJIGd1ZXNz
IHdlIGNhbiBjYW5jZWwgdGhlIGRlYmF0ZS4gVGhhbmtzLg0K

