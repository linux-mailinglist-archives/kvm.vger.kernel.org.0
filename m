Return-Path: <kvm+bounces-43122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 245FCA85070
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 02:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 358EF3BB040
	for <lists+kvm@lfdr.de>; Fri, 11 Apr 2025 00:09:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 837902C80;
	Fri, 11 Apr 2025 00:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FxvtLufI"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1605E36D;
	Fri, 11 Apr 2025 00:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744330189; cv=fail; b=iHZ5drI7U2tLAqPbE0Jh5Eq5l5Hy8daiud/PXQap5irBrFeeLLpVFdAO2Yz/g08K7ex0nD3ZTA7/Zk/TTDGIqhdjkBVhuSU6pLayr1T+bLQbeZ/VF4SXjapYxagKjvisJXd9wK2pDvtkcJDwMQB4ncdGELuDU0d7372vpP5owM0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744330189; c=relaxed/simple;
	bh=N6Rh9NfrhZCynL9YPEOrGLyitzrUbxjUFFMTOZkGAX0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=r86Ai5/GK0XOh9ffREYUtUR59zqLSKkeEozAnHRQqxHEFEhubDmBo4nTD8SRvpwZN05UMwRdiPYf4J84LuxOljJxPwDLNBpP9m/gW8JvWS9ft1U0SXGiiMuY8t14D1A8VNjtcw4PyC3dwPMAMnz/A/q1rAH4/ChmHBS+VFnqdaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FxvtLufI; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744330188; x=1775866188;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=N6Rh9NfrhZCynL9YPEOrGLyitzrUbxjUFFMTOZkGAX0=;
  b=FxvtLufID0i+CTHxKaiW2FlWuGlS6Gl/9UT5fRHXDvxHFVAimMFCSJqb
   79ptt/wBjGVLxqvdD0aRasW5rRlB9Pk3TR0sEGqZs9TgAgCC1dReBnMtt
   qnNNGt/c5QrBGauyTCOUWKYsgPvJW8I4wQhpedisIOiCoMEi7pqgPlXHi
   RTaXKakaQGt23JhW/xrUaf1I7DYVxyNoD/ZbFQ21u7v11Eb7y4ZO8UJIj
   dopUVdFyp/VN2Pxxdz7bU5PkLLbx69TfQd6/qCJAjcgeWo9TTd94JPX1v
   qEr7RtgkN8NPniAAQu7oZnUihB8dsjtKgrhIfmEf6G847Nn/vi95hmoGs
   Q==;
X-CSE-ConnectionGUID: jWZy9aabQpmL4MOqTYb0wg==
X-CSE-MsgGUID: dUKgEhLJTpGvumPH6QjrPA==
X-IronPort-AV: E=McAfee;i="6700,10204,11400"; a="33485119"
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="33485119"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 17:09:47 -0700
X-CSE-ConnectionGUID: Gpinqh0/R9iJuiheyonQLw==
X-CSE-MsgGUID: SLIatIHBTbygk5ZLsLg+Ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,203,1739865600"; 
   d="scan'208";a="152233045"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 17:09:47 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 17:09:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 17:09:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 17:09:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sRNLty/M2rKw7prcmTCIUfprrI0unBYiWbsoTY4LF5aDGzq58n70Kq86DIjgvkOcK8becLH884nZM5VtdyTcpUj0vQ22aq0WOiRqkmAGLi/N1qyheslSg+p4sp/1yFaKD9IA8BMcmeyfrDjVxy+naPzEBP1VqqZJvojDzTmK7FnWrgj04NzkkHIBgBop9gbpGSQK7VTIUIUfkXbKKTLrFjcLEdjW7w3srVlO75ZkYe1hVjC9mckQ9mHMPwXaeHqhbRkF9yZh9RDzu3hJp2HQezhsI2mx+H3eTuYOfDUCb2nTCa909F6Nd4UbjfzEAzpkxnoe2DPJTL8uoVXuJkQxCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N6Rh9NfrhZCynL9YPEOrGLyitzrUbxjUFFMTOZkGAX0=;
 b=BzJVisGfPr96oAEYTioW+LtPeXHI3v7sB8qjzGkn+MpSu8b0x4/1mfjfaY7bWZ4CbwDHz9Buy7NLlZl28Kh0RCZqCM9tJDJ4SIWbR3vG/sCN5RTIhepvzJkD3hvmTduSyiLbAZr2i9+IfwDZMjOuCY2m5+0zJsYSxlHyTYshIx1cLy+3GSHxs4zIZAfQBONfP9l6t7pHK3JX3oxuKLTFTbM3n57MvbraqTrEWBMmKe/7OyMykvsF5H7qH5PnLOV4qYOvaDYWwf8mq4JFh1ScNqLddazAdHhjlRppKC7pCqPGgjolnrGNxsxcv6DKxQIpHEb7u1J/doZWmBfCWYp5nA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB7764.namprd11.prod.outlook.com (2603:10b6:610:145::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8632.23; Fri, 11 Apr
 2025 00:09:16 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Fri, 11 Apr 2025
 00:09:16 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>, Alex Williamson
	<alex.williamson@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like Xu
	<like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Subject: RE: [PATCH 7/7] irqbypass: Use xarray to track producers and
 consumers
Thread-Topic: [PATCH 7/7] irqbypass: Use xarray to track producers and
 consumers
Thread-Index: AQHbpacJ2ovkFo48akOGu44GvutTVbOcirKAgAB6P4CAAJtecA==
Date: Fri, 11 Apr 2025 00:09:15 +0000
Message-ID: <BN9PR11MB5276AF8347DAF3D1C45150728CB62@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250404211449.1443336-1-seanjc@google.com>
 <20250404211449.1443336-8-seanjc@google.com>
 <BN9PR11MB52769DDEE406798D028BC17D8CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z_fbFcT3gxNK_dWr@google.com>
In-Reply-To: <Z_fbFcT3gxNK_dWr@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB7764:EE_
x-ms-office365-filtering-correlation-id: 43b0d015-be9f-47b1-8369-08dd788d18f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?ZHQ2VjJYdWNacGh1Qk9uTEtSU21lUXNsVnJMWjBQVTJqbW03Ry9GMjRCSUdH?=
 =?utf-8?B?ZEJXYmI5Tnh0TVRzbUNwUWJ0SGpRZ1JNczRCRDV4TCtaM1hhYXpNcW00RWNm?=
 =?utf-8?B?M0YvdGE3aE5HdXJ4NnFlYkZJS0hqcGpNWitwMFZ4c2F4ZTdacnkzQnl1VXNV?=
 =?utf-8?B?dTViR0R4b3dPYjBKZFZ6c0hHWnVBc0RZOVJJQjBaaWhvUmlOMUpMdkxKNVAz?=
 =?utf-8?B?TzBWbjF3cTBCOWMyYUIvb0JYclRmVWIzRXBubTdwQVZKSHlDM0dSeXRmQlEy?=
 =?utf-8?B?bm9PMFphdDFSeFVFNFFvT0h0MWNyY1gyM1hsS2p5cFdtWWswVFN0UDhUVmI1?=
 =?utf-8?B?ZG1wWlk5V0d6RTlrSDBRTHMwYy9PeUVnTTJoL1psSHBycHhhejVHZ3Z0dzE2?=
 =?utf-8?B?amhCU2tJREgrWU1TMXJWUndIMGdJejdDU0xYNzd4cGVXMHNkOHpwdVZ3bXVl?=
 =?utf-8?B?cGtGYTBDWDJWbHpWamlMU1QxbFZvdXNpSjBWUEl1WENWT092YWZVdVlxRG5y?=
 =?utf-8?B?aGNScm5FUWxUMDkrT09JMlhMVERCZ2Q0WVdzYXNlNFZYeVVSUFVLdUtuem11?=
 =?utf-8?B?Nld2Z3pEUzhjUjUyYXhuS3h3VDY5VkcrZHFUM2lhaXZmNnh5V0t1d1ZFQnVZ?=
 =?utf-8?B?L3B1MXZZOGIzSzYvVEQ2cERHcmFsT0NwNnRla2xZRzJOMTY1TkJscStvNHhj?=
 =?utf-8?B?Sm8vUEpmRjFlUnVGSXh5MGc0OGEvdlZlMHdFWWNyTVhNZXZ0MXhKQ1VDV2wx?=
 =?utf-8?B?SDFYRFNYZ1Q3NEZuQUdzcEJDU3BZNGhqd0NPeVNHT25kOVB0R1dyOGlieW9p?=
 =?utf-8?B?Q1dsWTBqUU0rV0pIWFczSHVncVhlVm1na3I1WW1YVnJGaWRxaG10a015Ympr?=
 =?utf-8?B?QXlSWnpmM2JwTjNwNHJCc0YwWEExUm9lbGxmL2ZwYkljQnZRVzd3YVc5cFJN?=
 =?utf-8?B?WDRzZGFqUjhjZFhnclV5UEJHcWpYT1FtRjJHR1FkRUp0T1lrUFZCV3ZoM0Nk?=
 =?utf-8?B?N1hHUldwcVJFSHNxVTg5UERYYWpSUUxMR2N1R0Y2VXBtRmduTDBRelNJN3Uy?=
 =?utf-8?B?TzNuN0pwczkxbzIxbmR0Zkl4NzVGem0rbXlZcEdsaW1RcXZJcnpnN0d5L09y?=
 =?utf-8?B?OXczelJoczVVNzJaLzFCV3h5bS8xVWpYa0laN3cyNzBtbG8zYTRrMlZvZURu?=
 =?utf-8?B?VmFZdkM1NktwRmJOdUJDWW01WlRuSzA0cEdzaEpPVE5wWjZlZENDTm5SM2JH?=
 =?utf-8?B?WnBVTGoyRGxYUU40U05MVDdkWGhlTmRsMDRNUmhCV1k2R3NibENxYVE1VFhO?=
 =?utf-8?B?R3dNN3c1OFh1NHRmcDNJa0lmTVlIQzNjaVcwSGdtdFQ4ZGlJUFM3ODdDUzVN?=
 =?utf-8?B?NEg1a1pRMDlkdXpIbGc3M2JKeTZBeTJaR3BxVm5QbUUxeVhnSDY3Lzd0dGZm?=
 =?utf-8?B?bllQNUN6MGlWZ1pIdkxGTzEzR0FVNjhkZ0NiMllIb1Vmd3YzdFh2ZGlvekpV?=
 =?utf-8?B?YXRJNW9BaGdDNjJnU3hwUHV3cVpxOXZyRTRyQlRobGtmbWhhVVRIeFFVZUdS?=
 =?utf-8?B?VWs3Z1BIcVByUFBDMG1TeTFVTEhKaE1SbHI4STJIblhXQmgwYjZxb3dTMW5G?=
 =?utf-8?B?Rkw3VEpJdjFFSnZTVjdlQTF5V0JrNm8vT2dKeHFQUUNRT0ZSZ21QeWorTzdD?=
 =?utf-8?B?ejdmZTRhNHlacWFtNDFwbFZxNUx2MTlESXBsZkNOcklxd0FuUWJPRkpmYlY3?=
 =?utf-8?B?NmN1dTVVbGd6V0ZnR2dHTHJIY2tITnJ2Ui9ZbjB5SVNsQ3lDdUlKUllIc0d3?=
 =?utf-8?B?NVhJZENLR2hrcjNGSmw1bmlJT3NqMGVkSTBVMnpsTWVWOWt5eEswWlBIWU5n?=
 =?utf-8?B?RG10ekcxbFNNd0dLaXdsQlhHOTFDRHV5VDkvUnFwdWprcHFaZW1kaStRS1VB?=
 =?utf-8?B?d3I0ZkduTXhiNndEUFZLdmowZ3A3UVdkcEFvdkEzSmJLbldCRGJ3SGVnZE9o?=
 =?utf-8?B?L0xoNzdjSE1nPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVBnWkhDajRXNWJ2bU5SVlBLMDk2eDhxMStJU3htSjBiNGdUVjBjaStOTFVr?=
 =?utf-8?B?bmt4RUxsSFVCbUJHMnhURGNiWGwvbU5FYzFnS0Y4dC8yQXBkNWJQT3U3OWdM?=
 =?utf-8?B?Yng5OEhNUlpGcmlrNEhVZmtaaVFWOVg5dVkrNW9xc2JBb1FuN3FYMlJWbEUz?=
 =?utf-8?B?OU1JUzl6eC9hVXRZSWtwd0tURHVhdXdsbkRkNTdTQTZTWEtnUU5DT2hZemhZ?=
 =?utf-8?B?bnZqN1hqL0JodndXdktVSjRSMzErWnJnODRHdXhmSnNhNFBpeEJaM2F4SXkr?=
 =?utf-8?B?dlJ4djhkOGdTTHZ5YndVeWdEVlRNVmJPcG10ZnQ3OG1YclBmY2tCWkVPM2pV?=
 =?utf-8?B?YmhORXZobExEWnRna0pORS9TaHFPSUwxZ2RGUzRqVGtqSTBQd0hpR2FzVVhs?=
 =?utf-8?B?Qkt4MkF6ckJ4dVJpcHREZGRRYTBTME40RWhtc0VsN2IzcUN2eFltQktkRGFq?=
 =?utf-8?B?VzRoQXY5WFJCeElQcE9GaHNKUm9JUGVpMGpmejlZbTFrcFNnamxFV0ZsdktJ?=
 =?utf-8?B?VlRnMndxUkdTYVNSQWxCTlBUWFpGYUc5R3lyV09KUkdQK3JBNEl2V2JlRTg5?=
 =?utf-8?B?eDBtWUx1Z1RpemxCWHYxMXFPM0tFcGZydkoraXpJb0lPWlh4M0lmbmRqTzhC?=
 =?utf-8?B?Qkx4M3Y4ckRxamNWWmFkaEdPZkZlUk5SN1pFOGV6VGkvd2lnaE5kQlhNSzNt?=
 =?utf-8?B?QzBzSFhETk1WODIvK2huYW5wSG96QmRSNngyMVFxTkhpM3JRN1QwSGNoTE9k?=
 =?utf-8?B?M0sxbXNXcGNwTmNxYTlObll0eEs4NnZ3czBvK1gwcXR0aVNUMTQ2K3FvRFd3?=
 =?utf-8?B?cytNSGR2WHRKRlJralRRL0ZWanJ1Y1ZiR0h4eHc4dkx4bnhXZml5NWRkMUJH?=
 =?utf-8?B?eDVXUVRvYkh4Y1ZqV01ocmhsOVpmcml3RWRPQ1VPbm93UGQ2V0Y4S1BsdERy?=
 =?utf-8?B?bkdMSzdzbC9MSVdVRTc2MmxoVEFsY2pYWmI0Z2hsVHZpNEw0S2E4dmFJNWpT?=
 =?utf-8?B?TFA2WFRYa1AxZVBQZW4zUHVHaGdJOUtUUWRyNWlWVUFuQmpiZWh5ZjVHTGwv?=
 =?utf-8?B?MEVpbm1xaHp2OG12c2xrMjl2emF6Z0NsRzYwVkRhYUI4RHhkK2hiYVBhVUpT?=
 =?utf-8?B?REtVWWNIVC9qMUt5YlVRY285QUdWdXc1THUzeHdpTEN1NVpTekdhdzd3Mmtq?=
 =?utf-8?B?M2NOWHUvREtQd2I0eEkyRmw1ditnQ3I1WXl4K2FKRFVLTUtLdEpudDFuUHFX?=
 =?utf-8?B?VkRZMWp4MlFCbTNlbHdWVUZCU1dkNDBBakhHMm9MRnEyNjl4NWcrcXR1cmhn?=
 =?utf-8?B?UDZlc3VPd0wrbFNocVJzRTRCNUpIdUJFWERmZG1KS0pUNnM0TnhKNEFVMXd1?=
 =?utf-8?B?bGNOc0RHRmErSmNHRTBDekpRS1JRcWdYWXB1Qnk1KzdVVm9CQmxnUlNFUm51?=
 =?utf-8?B?L2wzNGRuQ2R5Ry9HWnhRRnFyZWFQaVUyVlBiVU50anIwaWVzRUhjTzl6ZW00?=
 =?utf-8?B?VmZiSEZmcUIyQ1dZbXhybzQvVUlnWG5wWEFoL1gzc3FpclNRU2pBT3pFU1U2?=
 =?utf-8?B?dHFGZktCaXRjT2RmNC91T3Mra0FMQ3puQmdEb1VxdzRYQ001WnpmWkVHamNH?=
 =?utf-8?B?K0M4Zmp2VW05aW1HR3NDbGsyU1A4N2pVNkpIanhpQ3RYamUyR3VQZlJKZ3pT?=
 =?utf-8?B?NVpFRXFJN1BLVk1DR3BZZlhaVFFHUnZ2QjVIUnI5YURGR1loSEpQWm5GcWJ6?=
 =?utf-8?B?eFVZREdiVFdCbmZveWptWW96azRmQjUxYVoxWWNaOXhtR3RHcXRweHJIUDBX?=
 =?utf-8?B?c0VFNTR3Snk5dy9iYmpaeGhtNVNHWTVKRW55SE5DRFVLVkdPQWlVbzJFRmVI?=
 =?utf-8?B?QWtiU1lBdjBEbytnVVhWM0htQkZSa0lnYytYdlRUbGxwSmZOaWpYRGFjV3hJ?=
 =?utf-8?B?VVBpS203VTg1MGxaNkhEM0REL0VmQ2xBTE5QeGJjd2tTVldTQkJlL0tZd0FR?=
 =?utf-8?B?cFNHTHZqcWhDd2Z6TlRMLzNSRG1rdCtOR290Qlp5Qkx2ZUNtb2NBdVNPaHQz?=
 =?utf-8?B?NE5lM0IvMjhDWUdNZGhnczNaVk9XbzZRYTRGeDhVbUZDRE5Yc3ZsaEJXdkd1?=
 =?utf-8?Q?wSuQgVLAJahSHzuBiaxDlou3H?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b0d015-be9f-47b1-8369-08dd788d18f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Apr 2025 00:09:15.9991
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YeWRVuOfxvFK0wG4nEJ5uGHii9WT0wsqwa2x+1jw9XpKiZmlEwFH2C1/Qu68kzfLxTFnJMVjYjlnMATK6y9UYQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7764
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
VGh1cnNkYXksIEFwcmlsIDEwLCAyMDI1IDEwOjUyIFBNDQo+IA0KPiBPbiBUaHUsIEFwciAxMCwg
MjAyNSwgS2V2aW4gVGlhbiB3cm90ZToNCj4gPiA+IEZyb206IFNlYW4gQ2hyaXN0b3BoZXJzb24g
PHNlYW5qY0Bnb29nbGUuY29tPg0KPiA+ID4gU2VudDogU2F0dXJkYXksIEFwcmlsIDUsIDIwMjUg
NToxNSBBTQ0KPiA+ID4NCj4gPiA+IFRyYWNrIElSUSBieXBhc3MgcHJvZHVzZXJzIGFuZCBjb25z
dW1lcnMgdXNpbmcgYW4geGFycmF5IHRvIGF2b2lkIHRoZQ0KPiA+ID4gTygybikNCj4gPiA+IGlu
c2VydGlvbiB0aW1lIGFzc29jaWF0ZWQgd2l0aCB3YWxraW5nIGEgbGlzdCB0byBjaGVjayBmb3Ig
ZHVwbGljYXRlDQo+ID4gPiBlbnRyaWVzLCBhbmQgdG8gc2VhcmNoIGZvciBhbiBwYXJ0bmVyLg0K
PiA+ID4NCj4gPiA+IEF0IGxvdyAodGVucyBvciBmZXcgaHVuZHJlZHMpIHRvdGFsIHByb2R1Y2Vy
L2NvbnN1bWVyIGNvdW50cywgdXNpbmcgYQ0KPiBsaXN0DQo+ID4gPiBpcyBmYXN0ZXIgZHVlIHRv
IHRoZSBuZWVkIHRvIGFsbG9jYXRlIGJhY2tpbmcgc3RvcmFnZSBmb3IgeGFycmF5LiAgQnV0IGFz
DQo+ID4gPiBjb3VudCBjcmVlcHMgaW50byB0aGUgdGhvdXNhbmRzLCB4YXJyYXkgd2lucyBlYXNp
bHksIGFuZCBjYW4gcHJvdmlkZQ0KPiA+ID4gc2V2ZXJhbCBvcmRlcnMgb2YgbWFnbml0dWRlIGJl
dHRlciBsYXRlbmN5IGF0IGhpZ2ggY291bnRzLiAgRS5nLiBodW5kcmVkcw0KPiA+ID4gb2YgbmFu
b3NlY29uZHMgdnMuIGh1bmRyZWRzIG9mIG1pbGxpc2Vjb25kcy4NCj4gPg0KPiA+IGFkZCBhIGxp
bmsgdG8gdGhlIG9yaWdpbmFsIGRhdGEgY29sbGVjdGVkIGJ5IExpa2UuDQo+ID4NCj4gPiA+DQo+
ID4gPiBDYzogT2xpdmVyIFVwdG9uIDxvbGl2ZXIudXB0b25AbGludXguZGV2Pg0KPiA+ID4gQ2M6
IERhdmlkIE1hdGxhY2sgPGRtYXRsYWNrQGdvb2dsZS5jb20+DQo+ID4gPiBDYzogTGlrZSBYdSA8
bGlrZS54dS5saW51eEBnbWFpbC5jb20+DQo+ID4gPiBSZXBvcnRlZC1ieTogWW9uZyBIZSA8YWxl
eHlvbmdoZUB0ZW5jZW50LmNvbT4NCj4gPiA+IENsb3NlczogaHR0cHM6Ly9idWd6aWxsYS5rZXJu
ZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMTczNzkNCj4gPiA+IExpbms6IGh0dHBzOi8vbG9yZS5r
ZXJuZWwub3JnL2FsbC8yMDIzMDgwMTExNTY0Ni4zMzk5MC0xLQ0KPiBsaWtleHVAdGVuY2VudC5j
b20NCj4gDQo+IEkgbGlua2VkIExpa2UncyBzdWJtaXNzaW9uIGhlcmUsIHdoaWNoIGhhcyBoaXMg
bnVtYmVycy4gIFdvdWxkIGl0IGJlIGhlbHBmdWwNCj4gdG8NCj4gZXhwbGljdGx5IGNhbGwgdGhp
cyBvdXQgaW4gdGhlIG1lYXQgb2YgdGhlIGNoYW5nZWxvZz8NCg0KTm8uIEkganVzdCBvdmVybG9v
a2VkIHRoYXQgbGluZS4g8J+Yig0K

