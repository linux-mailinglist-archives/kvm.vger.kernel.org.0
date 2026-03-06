Return-Path: <kvm+bounces-73004-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aOM/M2WgqmlLUgEAu9opvQ
	(envelope-from <kvm+bounces-73004-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:37:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6019A21E116
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 10:37:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2648530429B2
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 09:36:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C49AB346A01;
	Fri,  6 Mar 2026 09:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m3RIaFmE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BAE34572F;
	Fri,  6 Mar 2026 09:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772789771; cv=fail; b=SyVYyjXSegABV0YDszj2PF2pp26Ds1cNVzfxwj1SPs545xcJbFs0I2oO/2qV7suqyG+I6VChxAsjKDJOmzGsdXFb7bAlFlO8lOKeeaMPHi4bIUdyHgPsanY53gxeLG7Qmudi+zQfYtOFfEeXYDTMPeUxgLlwJM42vTU3EJZbGMA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772789771; c=relaxed/simple;
	bh=1D0cgXTYZYoTtNIcKhRNHA4Yrr5JrVNeNUwLsOJddE0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Jw4UakSHD3R73uaQIYl8iH1LgbDZ9DmUnbB8CEyE9Fid7e4MsmE5FI407BW4xNhdGNGIBEuWFsmzImtOJX1FDZ0QubhUSTlp+E0891vFan2VdsUezyqIwAJdnPcptyqvzp9br3YeDjGZMLev4099cWJfBOL42IepD3dE9ju0MVg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m3RIaFmE; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772789769; x=1804325769;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1D0cgXTYZYoTtNIcKhRNHA4Yrr5JrVNeNUwLsOJddE0=;
  b=m3RIaFmE7VlnLj+7cLZb66A9J7HhYs5WXJL4BgrKKrGExEORMsijhrQk
   K81+JxI2IPnszcGyr6iI6CnrB7Ffgda3P2kvuamwZpjiD0MObo68/A28U
   cC8XCtpR4WStdNz8y/WxZD62RQ2PWBUKoK1uBEB+E1wcX2lGywF1XUjSb
   G0B/XLeyDpao+bdN5SmA27hEAmzgvbPh7XN8OSSrDKyjcX9pO2cuSNu1h
   bRDaj6M3evghFmglMbSJcngSK0PJW2g0TN+b4hPkCsT0e7ma7uyYVL5x2
   hHNoV6IzzOLewK9QMjK3dKFG2PvL5iJ6SecJwKfxo3efLT52bVOPM4eae
   A==;
X-CSE-ConnectionGUID: C/kbCaVATTGmF1xX+rsEqA==
X-CSE-MsgGUID: p+FWb12TRRi8CoVicuWP/A==
X-IronPort-AV: E=McAfee;i="6800,10657,11720"; a="77765360"
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="77765360"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 01:36:08 -0800
X-CSE-ConnectionGUID: UHH2MZgNQgOZ7BsaGx5EQw==
X-CSE-MsgGUID: mcAy9s13R+yFoJYMDrnLYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,104,1770624000"; 
   d="scan'208";a="219095047"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 01:36:08 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 01:36:07 -0800
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Fri, 6 Mar 2026 01:36:07 -0800
Received: from CO1PR03CU002.outbound.protection.outlook.com (52.101.46.35) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Fri, 6 Mar 2026 01:36:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MWniZ7t0Pl4rjQHdZrjdRPhH5YobsgSAUFHdFp/bPwFRaEojGyyNTUhIfNHsR4FLaaI5YIC3BoOmL/1lDfgOiS36xnlJElRH+VGkr2bSqMBLSBYmPAVDe5yE9pCWqfLj8fcD2kTDgb5mlkXNrfltoh8KO8F4FO2xOTAkOyRLvlpiacB8+x+QrcGJHh59N7wxrDsgrqnwwc62zjSR6u0C0tW2eWNPu1OQQ+tOr9DQ2zUYRUyTkk+da3FxYbvCPtd3xVwYV5dIp2sToyctVcOm8CjpMVEoQm8s2j4eE5rgwmx8aOOjBdmQvTFSvDR78j+APG1gCMM09qyJReyIx24GiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1D0cgXTYZYoTtNIcKhRNHA4Yrr5JrVNeNUwLsOJddE0=;
 b=isqk5iBhGJ0iO1Gv8Mmj+n5oza8Rki1/rLwykMRMX2oWB1VisCldva+Y+h9q5S5WJBOVzLHjSngaqi5c8DQzMfwilKKpLTgeuwhJJjIshI6r1ekbDzjIYbFmnpjiV5UfLirxtpjOLRsi2cSLAT+tMYKQYUpfmBTOd0P4yG+Sw54gvj+3IgoBLX4mVOhwdFp57jHaLCn0XR9kkeJ/SDwasRNCR3/kRh21KLXtaQzR0bJfiIxuCBxG6rPUFLV68tjo19W+fX9bcWnvgQ5xSqT1OqUh02OAkXpDmNi6EHVzpt5DVUPQhgbk/3pZsjbyyhqy945kdy9zoRM5sDeh3V2U5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 IA4PR11MB9108.namprd11.prod.outlook.com (2603:10b6:208:567::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9654.22; Fri, 6 Mar
 2026 09:35:59 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Fri, 6 Mar 2026
 09:35:59 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "sagis@google.com" <sagis@google.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 19/24] x86/virt/tdx: Update tdx_sysinfo and check
 features post-update
Thread-Topic: [PATCH v4 19/24] x86/virt/tdx: Update tdx_sysinfo and check
 features post-update
Thread-Index: AQHcnCz/59I787sNd0S3uZ9h/pol27WfKC2AgAInIYCAABGYgA==
Date: Fri, 6 Mar 2026 09:35:59 +0000
Message-ID: <f1f6b9b60aba8274c36d0da0da66dccf24c713c4.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-20-chao.gao@intel.com>
	 <1aaa74b61001b45261701aa73fc085a14473919d.camel@intel.com>
	 <aaqRN62xGuOwkvGN@intel.com>
In-Reply-To: <aaqRN62xGuOwkvGN@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|IA4PR11MB9108:EE_
x-ms-office365-filtering-correlation-id: 64553a72-8e8c-4daa-6f09-08de7b63c664
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700021;
x-microsoft-antispam-message-info: R2Ip5t54riiZ9oTkwnjS4XIg5N83ZD0BysSREG/s5C9HAE2k5UQZe36bNfFgS7YYYY1e/B/yCPGrGU+f09HQ0OGAKz/ZZOS5vChzBxdARdFPRWZN0R1ZGsx9EG9Hb5PNrHiSrxwtUtxJlrbmXCCI7R/Fa5v1ty4OJmBYtTxi4I2uSdaHLJC//B92JZw2+nAqz6OFiY+GMQJ32x5yww/svcsvtdDMdkXRuxADvPBbCZP0rRb1IOyw4psQuE3xCLoc4G3jyi+ExCU5SIdVI01rXp2sGJgDgGvaDLR6k1ymgv6rJwjodlTQbMQjcne5Nwxbwv4lgFyS+OjHqlDhY4X8Q6BEERxD+r/lMufH0BpwHdrIWmQdNNEd8b3+BM2NMXmTDh6xx48H7JKO5xaN+SwS5DIGYKjl/3qIBHQ10vNpJrm6uTzNZXrVBXgh6jyuD03bOgLkugTATrvGP9en4WcxSUjoBEuvqkYyof+3iJe6wzl7xkS1M2Zdqo3IVHL39elTOPboLNQXmFrx0DgTqEHOD4IDiXstVfnkjP45HkEVKC5wR9VRUCFuE6dFIfCgjLY8n0gBHfUrW6DB3ONPDrvMcJW7lrA0dK1jwpa1LOjZgJY1dXKxUKKEby1eGHWzWEgvCndNzUErpIFEzbo0MIxLB6JO9f9LIydTO3uVv72Mdca6KKKeZ/6WmUmr82FIlF0fvmGaZpkjRkY8AmEIYr33SS5gmZ+MZbOFuZw7ssiPJB0aTsOHOH+C6vSZLzB499DSE66z6g3B7a7IB06QrgfRObo7mDtbM/zgGh4Q1ZhXAtE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YmNPTGZsbnBvak53Sm1zNUdrMFJYR2ZEK2tJNVJxODZ5bFBZNzM5d254YkdL?=
 =?utf-8?B?bWJ6OHdaM0tpRllNaDQ0TVBZVTYxcHUxVXJpa1EvNTVJa0tLelJMZ2MrZmlO?=
 =?utf-8?B?a0RCTEdzYU96aU5pUGllYWxpeHE1NHM5R2lsOHBKZGZJb1BuajdhUlpYc2hR?=
 =?utf-8?B?UC9Vc2FaWjJ0SFA1M05VVW1scEtpN1ZBcWNvUmdRejhXWDUvdWtBWWd1enlh?=
 =?utf-8?B?WHZuaHlpTW9LM0JZcXgvTFcxdzZBeGNUeE5OL25EOUJmYUlFMVNkTEg2MlJ6?=
 =?utf-8?B?QndqV2ZscVpLMFZKWGdhSGkxOUR0UFk3bXp5bVdFQkFReFU5Mnc5aHRweE1H?=
 =?utf-8?B?dW8xTFFtSXVtNkh5bjNEd3BVVUpDRmgrR1lWZThIdmIwQlg2clFDR0tqYlpB?=
 =?utf-8?B?RFFRVWpGUEgxQUsvaVR3SzAyajNONDZ4REswZ2hhNlJ0Q01uMmNTYjk5Tmpw?=
 =?utf-8?B?dWU1dUMweFZuWi9KS01hbzJYVlBabDRjL3pxbzhzSHlJeGs1akxuZFlpclN3?=
 =?utf-8?B?d1B1bVk1eEJFNGFiOExraUdFbllHUW81a3Z1Q2hYRG9lNWIyUXREdjd1VmVk?=
 =?utf-8?B?aG1MblhSM3hkc21QZURhTUJ5eDcyRi8rdVpBc2pTTC93dDhDSGovM0ZjdmZY?=
 =?utf-8?B?eEcwRWJuUktyMy95b1VHY2tKL3JyNUx6dldZSjI5Q211QW1PS0pSSkVGbEsv?=
 =?utf-8?B?cVZWNldlTkthQVhOM3VYK2FFVU8rbVRNSDNUNjJaMDZ3ZENkbXI4bXNQMVZY?=
 =?utf-8?B?K0h5K1pjMWkvUytBVkM2V1hJOFJXa3JCZEIzcFFHcWwvaStxeWZyL08yUVJJ?=
 =?utf-8?B?S3k3T21LTVpMaTRGSmxHd0MxV2JVcEVhTnVla0dPYzMxTFkxTHFpSmd5eG5Z?=
 =?utf-8?B?NjNlNjF4aFl0cWxYT0pKVTA5aldPZ2d3VnJsdVVtamtCSlRVRWZNMHB0Sm9P?=
 =?utf-8?B?TnRUQU5sLzN0dHpUOFpPekl3cCtHdHZPVTNzMHJ1K0ZTb0lHakpjZFJuRnBF?=
 =?utf-8?B?alJ0QUdUWjU2UzMvQkRaNUJIc1JOMkF1eWpNT0NEMWt2UUFDSE13Qmp6dURq?=
 =?utf-8?B?cVpwWFphc0U4aGo2RVFrbmZKMUNxdGxYb3RmTkNUb2paN216TCtGdEJhUnpw?=
 =?utf-8?B?bHdzNjcrcDBtSVdicFJ4NkQ1LzBvOTlmak1HTWdhTmx5VGNXYVI2L3ZvTmxw?=
 =?utf-8?B?V0FBT09OVkx6V0VlVUwzeC9hUDFaaXFMNzFlUGhKbnpkOWRKcUtZK2dlQzZM?=
 =?utf-8?B?eTZMVVZ5TXpxQXdCZ2QvV0tpZmt4c0lEWHVtQ1YwODlhVmp4Y25McEd4ZXJ3?=
 =?utf-8?B?Y1lMT3R5ZGJOVHJXZWc5SGdDL1JDNDJEY0VSV0JXbmowS2o5UHB3b2dXSTNz?=
 =?utf-8?B?WThyS3UrTmREQkRPZnN1Q2cwQzV0aHBaMUNCYzI1eTV0MnVSRk9yMFVLNkpy?=
 =?utf-8?B?QkhaRVA0aFNFNDkzVGdVcmdudHVNcXdQWldLN1RxaElRMXZPMm0vQjY5eUFJ?=
 =?utf-8?B?UmcrSzgyeWlWUUUwRGsyTmc1emhML2RNMUp5NVFDaGd6bXY2cTdSNVhrSWR2?=
 =?utf-8?B?ZGpkR2p1TG1uYnFDTk5wR3dWMEZzN2JvWkRGeURjWGhaN2tpVkdUUUhJSG1F?=
 =?utf-8?B?TDIybjh3MG9GODE3NVMzUFpWZ3lWYTQ2N29sN1BUdnF5ZG96WDVSaHFqQnJ1?=
 =?utf-8?B?VXFZYmpMRDYxNEFoaFFmU081UmZYMlBuL29KMHYzNlAxUUlYcmQyY2J1UFRU?=
 =?utf-8?B?LzRYWFRSbGRsWjNTU3QzTk5yMm8vVHNCdzlNeE5ZcEtCeUdiUnFVRmxDQnJ0?=
 =?utf-8?B?aDFsL1dzVXB0NFZ0SkVmRS9KRmFYbnVTdjVKNzBRVXlSN3phOWRvVzU0MlN4?=
 =?utf-8?B?T0FTc1N0MHBJRWtQWWFDano3OXpOK0dRUzFkT2xEWStOWjZ0NTdHTkc5cnpq?=
 =?utf-8?B?VG1ld2s0RGh3NGs0R1M1LzMyVTI4blkxMG1jZHZxRUV5TjlldUxxa0dTZEd5?=
 =?utf-8?B?K3lCVXhlQ3djQksxeUdiTUJoUzlxSjlxZU9iQXNEeS9yZ3NnN2Nlak9TakEz?=
 =?utf-8?B?eVBmRlRaTlo5SXdQWXh5ajdyVDNBRlZKYnBMeEFDM1dxRmYxVFViY09KcEV2?=
 =?utf-8?B?azFjNDJGeGFMM1dzdU1ZUE0vcDZ6VXE1V3hudWZmWjZCQ0tvMldSTnBGUW12?=
 =?utf-8?B?S1ZXRnBMUGFVeWVucVQzbG1oZUlRYXNWK0dnT004Y2dycWNlSzQ0WDhBSTMw?=
 =?utf-8?B?RmlySENDdCtrNTdMVm5taGlyUThwZDBuTUxtQkFGOGY4dVBobEhuZzBIakNZ?=
 =?utf-8?B?elF4ZmlIZW40Y2JzUkJYRDh2aTcxbWNBZmE0cUFrOFFVR1BOV25Fdz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <97BE1373DBC9114882848CEA9E5C633E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked: YOq3XPZ6auH2mDlfcP66aeN6kO+mMBZllxwJkoAbE0dvRSJNRSswdDACY/3uVaZsCO51/tJrmcJX0jb2JNDCFBxkmwLdVkGcbO6Am1jZPcf3sz3MorEPrRMWkdpZNOEfD9xxl1qaodbWLIp/EL4kzLioxPT073t51d9UipeYVsTVyIFS22eCsQhG8oIELitU4B82Aih8UDl9e0vA6HQbeSVhl6gvlYbccNX3FWg7MF2UQYjSf5SaO5rsHLQmG1j1sboN08AlOUNgBBcEXAVP+tYhr8Tmv/QIDMxZvcFbJFRrdwkIP66Xj9SxHLnxVrOMgPDWmESzcM22fRDeF8Nj5g==
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64553a72-8e8c-4daa-6f09-08de7b63c664
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Mar 2026 09:35:59.3294
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wUOkaPMkoglmRBEWTp4sciHyZjIQf7XF41OelTzHmno7WBraHiYG5Y/DPH+6p3Nmt54SpgfOc238djvRvnvx7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR11MB9108
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: 6019A21E116
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73004-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,intel.com:dkim,intel.com:mid];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

PiA+IA0KPiA+IEkgd291bGQganVzdCByZW1vdmUgdGhpcyBjb21tZW50IHNpbmNlIEkgZG9uJ3Qg
c2VlIGl0IHNheXMgbW9yZSB0aGFuIGp1c3QNCj4gPiByZXBlYXRpbmcgdGhlIGNvZGUgYmVsb3cg
KHdoaWNoIGFsc28gaGFzIGNvbW1lbnRzIHNheWluZyB0aGUgc2FtZSB0aGluZywgaW4NCj4gPiBh
IG1vcmUgZWxhYm9yYXRlZCB3YXkpLg0KPiANCj4gSSBhZGRlZCB0aGUgY29tbWVudCBiZWNhdXNl
IHRoZSBmdW5jdGlvbiBuYW1lIGlzbid0IGltbWVkaWF0ZWx5IGNsZWFyIGFib3V0DQo+IHdoYXQg
aXQgZG9lcy7CoA0KPiANCg0KSXQgc2F5cyAicG9zdF91cGRhdGUiLCBzbyBpdCBpcyBjbGVhciB0
byBtZSB0aGF0IGl0IGlzIGZvciAiYWxsIGxhc3Qgc3RlcHMiDQpuZWVkIHRvIGJlIGRvbmUgaW4g
dGhlIGtlcm5lbCBhZnRlciBtb2R1bGUgaXMgdXBkYXRlZC4NCg0KPiBJJ2QgbGlrZSBwZW9wbGUg
dG8gdW5kZXJzdGFuZCB0aGUgZnVuY3Rpb24ncyBwdXJwb3NlIHdpdGhvdXQNCj4gcmVhZGluZyB0
aGUgaW1wbGVtZW50YXRpb24gKEkgYWxzbyBjb3VsZG4ndCBmaW5kIGEgc2VsZi1leHBsYW5hdG9y
eSBuYW1lIGZvcg0KPiB0aGUgZnVuY3Rpb24pLiBTbyBJJ2QgcHJlZmVyIHRvIHJldmlzZSB0aGUg
Y29tbWVudCByYXRoZXIgdGhhbiByZW1vdmUgaXQuDQo+IA0KDQpXZSBjYW4gc2VlIGV4YWN0bHkg
d2hhdCBpcyBkb25lIGFzICJwb3N0IHVwZGF0ZSIgaW4gdGhlIGNvZGUuDQoNCkFuZCBpZiB5b3Ug
YWRkIG1vcmUgZnVuY3Rpb25hbGl0aWVzIGluIHRoZSBmdXR1cmUgdG8gdGhpcyBmdW5jdGlvbiwg
eW91DQpkb24ndCBoYXZlIHRvIG1vZGlmeSB0aGUgY29tbWVudCBvZiB0aGUgZnVuY3Rpb24gdG8g
ZXhwYW5kLg0KDQpBbnl3YXksIHVwIHRvIHlvdSA6LSkNCg==

