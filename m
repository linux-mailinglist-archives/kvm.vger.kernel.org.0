Return-Path: <kvm+bounces-71613-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sBkTD22CnWlsQQQAu9opvQ
	(envelope-from <kvm+bounces-71613-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:50:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id AD6D6185A64
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:50:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 54FAF301F793
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:50:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 613BB3793C1;
	Tue, 24 Feb 2026 10:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="c9mH6PTE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C719E378839;
	Tue, 24 Feb 2026 10:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771930197; cv=fail; b=JmLQbNoUM27BUzq96mwEYJvSc+hIRKUDjmXFD+Ynv7aU2uXa8oUcuLWLGSqZPIOP5VznCPH5ipkEWwxhxlOiojXnFiCR8h6zB5ZuyShWEOQJIppzqquiPzLCIpEFRODB62noVjH9uK/M5ZvhuYNZDenwvEUEiiyEKwzbxO0KsNk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771930197; c=relaxed/simple;
	bh=9mpbg+b94MbQUtwfHqSfoNPAT9GUje0nSAKTGIgojt0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oBjTUtqsoizthQqCzZphlZZRo19YvDk4SeaXoItVZ0PyhpOwcbbyZ/HzMhe5mRlw3Ae2DDTAkgZWrRaqBjoNzEzMSWsSzbrWB7OtyGDjd1JV1Q2fLHio8ARvFurAS5bvr7+lk4envCXcYZgFRYa3I9L0D4XdErhM7nOIqH9SP9Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=c9mH6PTE; arc=fail smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771930196; x=1803466196;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9mpbg+b94MbQUtwfHqSfoNPAT9GUje0nSAKTGIgojt0=;
  b=c9mH6PTE4A1O4wGMtIi1CaP4ralg8lLDzbCAUCZqNufAQR3SiH8V2sVp
   5dQlhoCB9tZDlpgc5yaCyod1UmyxepwveKLR7Bnl4MINyiH3h3NYsB8XW
   f08RpSOJ5efIh5+6OmicOATIui/tZuGZWxl+PAOyw3o5HoVsFXvhUSyxH
   V/smM8Uwl++dMkZf+BDgou6LpGTPmTWGD9B+f8Onc7QUQAfWKvG8kqr2+
   vIxxH1KOBiwKaqjXhB6JZBqtCok9FEQBfLUhF6elqShd6Wclsa//3kEeS
   m5cLW3VhUxtGAEd58/oyc3hFhDJwtQ7dNh8ck82TGki0fE2SF1AvQL5wy
   A==;
X-CSE-ConnectionGUID: WNsLdcqERfKPc2cqKRVIDQ==
X-CSE-MsgGUID: cFZFliXrRjmTR8dZYq9v7w==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72852590"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="72852590"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:49:55 -0800
X-CSE-ConnectionGUID: upWmnCcaTgmWI6gXTJ9iLQ==
X-CSE-MsgGUID: 9InW+XLFQP6nzkykXxa0/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="246446899"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:49:55 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:49:54 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 02:49:54 -0800
Received: from PH7PR06CU001.outbound.protection.outlook.com (52.101.201.36) by
 edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:49:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=mMzR5kMuOq4LPEAIuv9OfszL9xIKNuwV96PjMwi+PXnpCQNqL9Pt5opdu3mMI9KDaQSktPvpdeNLxMBsXReqnbHqD785coX8wYsK/UyP5KgPHhgbfK4HQAPZKrTuytyFQqNhATHcl4MyhEvFtY7sRfqW8DKKhuKCvH0Vkn+h1OsiRpjyOUAaJyFJH6eP710wMTIAfXzIXkheZo2A7UIDInoQJexsrCzS1hmO1GrvqCcE+BFELNnz3LYuwMvXkljVLHaed9VE0ptrleLbgogzcttnjtlTiMSepl0NQiud80bOMuCV49GRPaXv4ROdUemB91ACppVZuqrutVeuHFASNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9mpbg+b94MbQUtwfHqSfoNPAT9GUje0nSAKTGIgojt0=;
 b=NsAExWn6mNl8VAHalYik0R6yNn9YAZLtQzbrgE98264mnEe4MI78H9PhWIaoLVOQWR/oXV6MuUkuO0hDeWGEBXYtlh+hTIzah9Xjv9b57oYi9DoFxyTeMsKzcPvrY4iySEt988nX53p+5QDpwLnadeW8gySDl4hLDKzdXke6+Rm8SZkTzv0di5pC9TXm/Yu38jkAXJif67aBBfQf71q5TTVslFjUcMu6UHwPU3IseIHE18z97p23E4S+MrpixV/qWaDHfrTnTP1Fm9gv3gJmZLmbGASUYpxH/8eIgH4u7uIvSRg54RiCEzplWHjJKkw0FL00/prtC+FmqPjI81+Eiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 IA3PR11MB9110.namprd11.prod.outlook.com (2603:10b6:208:576::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Tue, 24 Feb
 2026 10:49:51 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 10:49:51 +0000
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
Subject: Re: [PATCH v4 11/24] x86/virt/seamldr: Introduce skeleton for TDX
 Module updates
Thread-Topic: [PATCH v4 11/24] x86/virt/seamldr: Introduce skeleton for TDX
 Module updates
Thread-Index: AQHcnCz7pXAAYWHOTkqjqq+NZZbXy7WQFHOAgAFZCYCAAFDCgA==
Date: Tue, 24 Feb 2026 10:49:51 +0000
Message-ID: <ebb586b5c61381dbb35e6f56adf5ee3a5d568f58.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-12-chao.gao@intel.com>
	 <14ee337df2983edb3677e3929d31e54374a1762e.camel@intel.com>
	 <aZ0+j0ohYdJlCACn@intel.com>
In-Reply-To: <aZ0+j0ohYdJlCACn@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|IA3PR11MB9110:EE_
x-ms-office365-filtering-correlation-id: ba7e4b42-3f0d-40a4-7d8f-08de73926ff8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UHVQZzRibGI4YmNBRlRSTnFLa3JCNU4vQmtNME5NSmJQNGF6L3llOHEzTTRt?=
 =?utf-8?B?clAzWFJFbjZ6Z1ByUmU0NnFtWk5xUEVHWHpnWU1oZzM2bG83VzJTTS9YaHJD?=
 =?utf-8?B?VnpudXJQNjhtLytyUi80TlMrdVRORVRiSUVmSmJVeTFobENqMUhRd0VUYWRh?=
 =?utf-8?B?alVvVmZlclNjS1QzYTFiL2JrRHhMN0t6U0IzWk9XYkpLdHY4WlA5aFpmRVcv?=
 =?utf-8?B?aGNPY1MwVEVJeVMzWmkzeHZXQkNpWnFvZ1dOWVF4SkkxdGxYUXZSSUx0MUJD?=
 =?utf-8?B?WWZ0QitRTjJFZnVGNU5rT1pjWThRc1g3bTh4V3JCd0x2RlMyVzBZUVN4U1hu?=
 =?utf-8?B?bzJsQlNaWDZQRW5XYTZsQVFOUDU2SnlBZGdPRURhUzhkOEFLc1JHUHJwTTVD?=
 =?utf-8?B?am9EYzJndVNWU0VzdGdWUitUeTJsdVdGQ3Z0TFZNTzY1RTA0TlFlUFIxaEhE?=
 =?utf-8?B?TXhmNXlyUFptNm1tYm5aanN2eHl0RW9EUHpJdzNocXVRdHh4cjU3ZkJIMlEr?=
 =?utf-8?B?dDNMNEtrRmpTSERMRXpWdHlPU0RHd29lRVJkZmsrbjJoeGU1MG5DQ3BnNnpk?=
 =?utf-8?B?NmRkMnA1M0N1Z1JXTlJPdEFsRXlHZ0N5dHE0ZVRJSk45blpYU1h2VFZXaXA4?=
 =?utf-8?B?aUwyVHVybEVVK0JhWFVHbXFVS2I2WHR3Rzd0NUJZd2JGRFZnTmd5Y1JmK2Ev?=
 =?utf-8?B?RC9TbGRuU2VDaG4wNWtyYUxZVGNqUFVGczZqZUU5MitJOHM4RWVrRDRPbmdq?=
 =?utf-8?B?Yms2VDZXSWdCd1hrZWs1cStRRElUYnIzdEVCakV2K0cybUNTbU9VcDM5TkFG?=
 =?utf-8?B?anRUeWdNNUljSS9hNXlRTUZRMW1uQnU4aXh2UFZKL2d0WnhYbUM1RVR3a3NU?=
 =?utf-8?B?dzRGbnNadXFyVkN3V0cxckZTc0NKZGNRSXMzd28xaGNjK056aFRjQXJtYVEr?=
 =?utf-8?B?UmoybUJiZUNyZDJTdmJZSzFlRjVEMDFNcktQUURhN0t6VjVZK3hvWFhXMnlV?=
 =?utf-8?B?Y2dTZFk5TVY5dHBTcTJvODhwK2NiYm1ydXJlb3FsT3RubWhFdGNZTGRZbWRI?=
 =?utf-8?B?cGVQZG0wZW5kRDg4TUJ6NWRZMVJZbjI5RUxrOWxJN0dOWTVtT1Q3MlRBYjEw?=
 =?utf-8?B?N29JeG9sTnlPamRHY1ROandoS20xOUUzaEdUMm51QUFRWmVyWXRNUlBndjhy?=
 =?utf-8?B?d3FoOEUwc05nMjZPT01BN01uL0JVR3ZIUFpLTnNOeEFzc3JtZGpsL2xmUW52?=
 =?utf-8?B?VDFKS2dGZkg5U2p5Z1ZDVzhzWUFQM2gvMXYvcTNsdTZiNUlLVW80c3Urb2VX?=
 =?utf-8?B?T1lLK01HMzFFbFB2VTU2d1RrV3NRcGd0RW1GaGRwWExjQzNyWG9HM1RUM050?=
 =?utf-8?B?ZG9ibVU4SFhzbVhtZzhrMU9vQXFBdGJZSFVrU0VpdzAyT1pSc1Q3VFFlRllK?=
 =?utf-8?B?NlppRk90K1U1bTlwY3paQVVsWGMxU3FCeXRDZnFBZXBUN3JSUWd5R3FJSGJh?=
 =?utf-8?B?QXlUV1BvN0UzeVptb2FSM1FpS0w0NVRFY2lYd1NORXc0aEtEOVF2ZkZDeTQv?=
 =?utf-8?B?UlVDV0ZFSDlzWUhuVVJCdEQwL043Ykg3OTZteUZUV05lYkUzM3NuLzhNTGN4?=
 =?utf-8?B?eDR1ZVdWMlBSdTZuRXU4OVM4T3lMcUJCS0Q3SWV1NzB2amtuZ1gzTjJmZTlz?=
 =?utf-8?B?MzQ3eW43KzJrcithS0luK0Q5bGlMRDFUQ2J6QitaUFV5cEVpRzdZV3hRV1Z2?=
 =?utf-8?B?ejlacXlldU9YS0xXc3BSRzlpZUtGbmdvSnladXBpUUx3T0VxRzJXSnkyUmc4?=
 =?utf-8?B?dUpod0JGVTZBTmdrUTR4Wm5pN01CMlF4dERLOVorbk9PMFhJOEc4NnZ3UHZV?=
 =?utf-8?B?a1V3OWZ3SDdUZHRIcFY2Mys3V0gzR1VtWkpNajAyY1gyOFA0ZmlFR0RPcW1P?=
 =?utf-8?B?aE5DZUluVkRvUkVDZmR6T2JpenRWcVgzL0ZVbVY3eHhGVTUwSUR0Wm1WaFB6?=
 =?utf-8?B?NHE1Q2pRQ2xRZDNPWUJRdlpiekJVNCtUSDJGRnI1UFBFVldxeFR3VGNFZGFi?=
 =?utf-8?B?YmFXZ0FQQmtoUXhVdUpnR0gzZ2xPMFc5UjUyS2JZZlpSRDN0UHJWRXh4Lzgz?=
 =?utf-8?B?ZUQrbWFlQlV2VW1jVjRqdko1NUtQbDlmMVpueTJ0eHQ1bWdkZnNpd1hGWFpM?=
 =?utf-8?Q?HElJY2p6xgPdT9vIKs+oBEg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VkkzWEZwQ1FEK1c5RmNlSmFVOGhaT0JiQ1FxOVl5dHpFVUVpV3ZQcG9pUWdJ?=
 =?utf-8?B?OGpSeHhpd1NwSlJqSTNqODVXbTdaWi9qNWFVUk5qUUVWRkRuZzd2Y3d6OEF1?=
 =?utf-8?B?N25DaG44NFRZRk1RSmRkZmE2eVBKQlQ2LytPaXlqU1YyTzdqcFlhem9tbzlq?=
 =?utf-8?B?dlJ5MEN1TXptRHZXY0FMNU1JZURNL1hvRTZLY0w1MGI0SW1EczR3d2tKQnhr?=
 =?utf-8?B?NjlQWDVoK0gwT2llSlBxM0g5V3FreXpldlVRV2pmUjVPNGFvZG5kY3FVQ3N0?=
 =?utf-8?B?MUQyQ2hBS2xvRmJLY0gvV0pNSlgwMk1JcC9JUmlDM2RIODFvcnFCYkRzMUU3?=
 =?utf-8?B?aUpCbU5pZlRteGljSmZyR3htcGJ6cytzc0xPdGtSS0ZSMmZWV2ZncVlFSmpa?=
 =?utf-8?B?U0NQbXZNcGduUHQ4V3NTM05jNnhMNjVwWlc1Sm4wMjRuTDhpNnNaZGJ4MnVa?=
 =?utf-8?B?QjIzazJISEx3MFVlWDd4T3luRkdIeCtGR0VycWFkSVBobDZTVzU4RmpJVHVC?=
 =?utf-8?B?SnZaMTBqcDJtZ1RxdDBUUFVkV0s4dmFTc0VRZG41TGZFUVdQaTJzUWJ0ZG1j?=
 =?utf-8?B?S0ZxY3Y0SHZudGF3OUlqZkJQRjdNSkVHaklOQytvRzRFMmRTOXBOdmRGVXcw?=
 =?utf-8?B?VW9Ra3B0SjA3VjIwOE44SDY2WGwrc3JhTHJ1TVNPWlFBU2w1SUZxZUMyYWcv?=
 =?utf-8?B?cHJpcUF4VXNPQkFFS1JrcTVkRDV4L3FOdmsvVTQwVUpwVHU1QTE5K200d1J3?=
 =?utf-8?B?TFk3Q0pYVmVnckZYZnQxbEFqczRpcTZBTXppVWxTdnF6VlNhbTBmUVY2NG12?=
 =?utf-8?B?c1ltUDR1YzVMcjdMVTlTWDN2V3FKaDBYZ1daN0U3OXFtdk4rd2kxZVpla3h6?=
 =?utf-8?B?ZngydzNkR1lURGw2cjN1VVpOYjRWLzZjc1NNQ2l5Tmk5MnRJWm14YUlxSE54?=
 =?utf-8?B?d2VGMzZiSWVLUnZuTTZkZG9CUHRYa3N4dE9ZOU1WcjdEN09Bb0pwb2VkMEFD?=
 =?utf-8?B?WHVvTCt0c25HQlZaK0kvb3dtS2hzZlJFM2RGOElXU3EzOUZzRWpTT2JpYWM3?=
 =?utf-8?B?UnUyOEpjazdFYkRqUHVBVlk5bk9oZGlLTmhySVoyMlRLV0tyLzIzcGJjUVFo?=
 =?utf-8?B?Y2JMZ2dFOWNKZk1CQnp1emxiQXA1dWtiVW4zT2lTWHNNK2JPMGNqVkVyU1NQ?=
 =?utf-8?B?V3p6c2psNXI4U2FlOU1wRmwvUTlhOGthcHhFNDZuT1hVWUZob3dRWlhVb3Mx?=
 =?utf-8?B?SkZEeUprYkpJSlhCaDZaOUxGRFlPODFLUHN5TkNIYXhOQWhkL1pTek9kSkJO?=
 =?utf-8?B?bUtVSlNaelpjL0lXbUtpZXE5My9ENzFrYjBLbGtnR0NzaGxUSkJvaDV2RlhR?=
 =?utf-8?B?NkRISElGeVdlSmM3cTNGNmVkRnFINUNlSEppUHphc0JpYWNUVWFld1NoNHd6?=
 =?utf-8?B?bDh2OW1QeDhhdVN5QStCckl0S1JORUlrTW45bU5mKzZpWVU5U3FKZ1VLWWlh?=
 =?utf-8?B?UVhzMEVQRkJ1aXBYS2NoT0VJR3BQY3NqekdlSk9NY2tUSlIyUXFTM1BpQ3lD?=
 =?utf-8?B?MUVUZXc0N1kwOHB2bGJUbEZUZlJ1RFF4N0pxd3pyMmJGRjhyTXV6bEgvK3Ez?=
 =?utf-8?B?RC9scHJRKzBralBLTXc2RXl2OWZHU0hsalVZbHdLKzBMaHFYY0JheWtnZzFT?=
 =?utf-8?B?Wmd5WHhFSHdTMUZmSWt0NWVyNlAvYS9jNVMvWWtTZXM1SUNsejBpL3VQUjRM?=
 =?utf-8?B?M3JPY0Rpa1FIWGRsZml3T0p3eU1ST2d3TXh4Wi9iWEFlb0ZsUnVTUmhoMk03?=
 =?utf-8?B?ckNQQW9UaDd6Ykl1NG15cVNoNyswYldGSnNmQTBSeldxQnE2SHJoWnVUVCtD?=
 =?utf-8?B?VFhTcFc3OFJvTXJoQnlBVDI5dUNoZXBuTmtjMVdPOGxSU3F2OVJLR2VHRmVp?=
 =?utf-8?B?QlJCVytKSU00MXVJTzB3dlRpclpjc1N4Q1hxWUtWOTdUdjQxTTBJQytmMVdH?=
 =?utf-8?B?V3RnYThCUWZsRWptTlcya0VxTFhNWlJCTWhVQlJjb3ZqOFhyeWNVbndacFRz?=
 =?utf-8?B?NW5iMXpnbVpDOEd3UWxMTE5VbVFRclhUZERnaUZQMndCU3F2VDdEcm9oNGlU?=
 =?utf-8?B?Vzc2eEJ0QTl3R3hXdkZQWTBYSkdNSDQ2Szd2di9YUGpFMlowS0NETFdoNGxQ?=
 =?utf-8?B?UFYzSmoveEVnYk9FWlp1TFhGbDR3VmU1Ym1ZS3QrVHRPRUhVVERDWmpFVTZX?=
 =?utf-8?B?SWhDaVJCUnJheHB1SnkzbmY4d2x6bjVBdi9TR3VwdUJTL2Z0bEhKSmJCKzZI?=
 =?utf-8?B?WE9hRERoVnhBMGw2ZEYwdlRCVjJzdHFhdWF6NDJBWUZpTDdzOHhDQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CE10976FCE8CD2438A76A16ABE853DE7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba7e4b42-3f0d-40a4-7d8f-08de73926ff8
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 10:49:51.4123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p/7QDXWEoAhmZR7PY+m+aDbUF5NB/lam7GyR/Gz7lYpNcOzxYJSrnFMa8kE1qw/3XyCh+YwsWxfzzUzJkav+0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9110
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71613-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: AD6D6185A64
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDE0OjAwICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
TW9uLCBGZWIgMjMsIDIwMjYgYXQgMDU6MjU6NTNQTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiANCj4gPiA+ICANCj4gPiA+ICsvKg0KPiA+ID4gKyAqIER1cmluZyBhIFREWCBNb2R1bGUg
dXBkYXRlLCBhbGwgQ1BVcyBzdGFydCBmcm9tIFREUF9TVEFSVCBhbmQgcHJvZ3Jlc3MNCj4gPiAN
Cj4gPiBOaXQ6ICBzdGFydCBmcm9tIFREUF9TVEFSVCBvciBURFBfU1RBUlQgKyAxID8NCj4gDQo+
IFREUF9TVEFSVC4gU2VlOg0KPiANCj4gK3N0YXRpYyBpbnQgZG9fc2VhbWxkcl9pbnN0YWxsX21v
ZHVsZSh2b2lkICpwYXJhbXMpDQo+ICt7DQo+ICsgICAgICAgZW51bSB0ZHBfc3RhdGUgbmV3c3Rh
dGUsIGN1cnN0YXRlID0gVERQX1NUQVJUOw0KPiAJCQkJIF5eXl5eXl5eXl5eXl5eXl5eXl5eDQo+
IA0KPiA+IA0KPiA+IFRoZSBjb2RlIGJlbG93IHNheXM6DQo+ID4gDQo+ID4gKwlzZXRfdGFyZ2V0
X3N0YXRlKFREUF9TVEFSVCArIDEpOw0KPiANCj4gc2V0X3RhcmdldF9zdGF0ZSgpIHNldHMgYSBn
bG9iYWwgdGFyZ2V0IChvciBuZXh0KSBzdGF0ZSBmb3IgYWxsIENQVXMuIEVhY2ggQ1BVDQo+IGNv
bXBhcmVzIGl0cyBjdXJyZW50IHN0YXRlIHRvIHRoZSB0YXJnZXQuIElmIHRoZXkgZG9uJ3QgbWF0
Y2gsIHRoZSBDUFUgcGVyZm9ybXMNCj4gdGhlIHJlcXVpcmVkIHRhc2sgYW5kIHRoZW4gYWNrcyB0
aGUgc3RhdGUuDQo+IA0KPiBUaGUgZ2xvYmFsIHRhcmdldCBzdGF0ZSBtdXN0IGJlIHJlc2V0IGF0
IHRoZSBzdGFydCBvZiBlYWNoIHVwZGF0ZSB0byB0cmlnZ2VyDQo+IHRoZSBkby13aGlsZSBsb29w
IGluIGRvX3NlYW1sZHJfaW5zdGFsbF9tb2R1bGUoKS4NCg0KT0sgdGhhbmtzIGZvciBjbGFyaWZp
Y2F0aW9uLg0KDQo+IA0KPiA+ICsJcmV0ID0gc3RvcF9tYWNoaW5lX2NwdXNsb2NrZWQoZG9fc2Vh
bWxkcl9pbnN0YWxsX21vZHVsZSwgcGFyYW1zLA0KPiA+IGNwdV9vbmxpbmVfbWFzayk7DQo+ID4g
DQo+ID4gPiArICogdG8gVERQX0RPTkUuIEVhY2ggc3RhdGUgaXMgYXNzb2NpYXRlZCB3aXRoIGNl
cnRhaW4gd29yay4gRm9yIHNvbWUNCj4gPiA+ICsgKiBzdGF0ZXMsIGp1c3Qgb25lIENQVSBuZWVk
cyB0byBwZXJmb3JtIHRoZSB3b3JrLCB3aGlsZSBvdGhlciBDUFVzIGp1c3QNCj4gPiA+ICsgKiB3
YWl0IGR1cmluZyB0aG9zZSBzdGF0ZXMuDQo+ID4gPiArICovDQo+ID4gPiArZW51bSB0ZHBfc3Rh
dGUgew0KPiA+ID4gKwlURFBfU1RBUlQsDQo+ID4gPiArCVREUF9ET05FLA0KPiA+ID4gK307DQo+
ID4gDQo+ID4gTml0OiAganVzdCBjdXJpb3VzLCB3aGF0IGRvZXMgIlREUCIgbWVhbj8NCj4gPiAN
Cj4gPiBNYXliZSBzb21ldGhpbmcgbW9yZSBvYnZpb3VzPw0KPiANCj4gSXQgc3RhbmRzIGZvciBU
RCBQcmVzZXJ2aW5nLiBTaW5jZSB0aGlzIHRlcm0gaXNuJ3QgY29tbW9ubHkgdXNlZCBvdXRzaWRl
DQo+IEludGVsLCAiVERYIE1vZHVsZSB1cGRhdGVzIiBpcyBjbGVhcmVyLiBJJ2xsIGNoYW5nZSB0
aGlzIGVudW0gdG86DQo+IA0KPiBlbnVtIG1vZHVsZV91cGRhdGVfc3RhdGUgew0KPiAJTU9EVUxF
X1VQREFURV9TVEFSVCwNCj4gCU1PRFVMRV9VUERBVEVfU0hVVERPV04sDQo+IAlNT0RVTEVfVVBE
QVRFX0NQVV9JTlNUQUxMLA0KPiAJTU9EVUxFX1VQREFURV9DUFVfSU5JVCwNCj4gCU1PRFVMRV9V
UERBVEVfUlVOX1VQREFURSwNCj4gCU1PRFVMRV9VUERBVEVfRE9ORSwNCj4gfTsNCg0KVGhhbmtz
Lg0KDQo+IA0KPiA+IA0KPiA+ID4gKw0KPiA+ID4gK3N0YXRpYyBzdHJ1Y3Qgew0KPiA+ID4gKwll
bnVtIHRkcF9zdGF0ZSBzdGF0ZTsNCj4gPiA+ICsJYXRvbWljX3QgdGhyZWFkX2FjazsNCj4gPiA+
ICt9IHRkcF9kYXRhOw0KPiA+ID4gKw0KPiA+ID4gK3N0YXRpYyB2b2lkIHNldF90YXJnZXRfc3Rh
dGUoZW51bSB0ZHBfc3RhdGUgc3RhdGUpDQo+ID4gPiArew0KPiA+ID4gKwkvKiBSZXNldCBhY2sg
Y291bnRlci4gKi8NCj4gPiA+ICsJYXRvbWljX3NldCgmdGRwX2RhdGEudGhyZWFkX2FjaywgbnVt
X29ubGluZV9jcHVzKCkpOw0KPiA+ID4gKwkvKiBFbnN1cmUgdGhyZWFkX2FjayBpcyB1cGRhdGVk
IGJlZm9yZSB0aGUgbmV3IHN0YXRlICovDQo+ID4gDQo+ID4gTml0OiAgcGVyaGFwcyBhZGQgInNv
IHRoYXQgLi4uIiBwYXJ0IHRvIHRoZSBjb21tZW50Pw0KPiANCj4gaG93IGFib3V0Og0KPiANCj4g
CS8qDQo+IAkgKiBFbnN1cmUgdGhyZWFkX2FjayBpcyB1cGRhdGVkIGJlZm9yZSB0aGUgbmV3IHN0
YXRlLg0KPiAJICogT3RoZXJ3aXNlLCBvdGhlciBDUFVzIG1heSBzZWUgdGhlIG5ldyBzdGF0ZSBh
bmQgYWNrDQo+IAkgKiBpdCBiZWZvcmUgdGhyZWFkX2FjayBpcyByZXNldC4gQW4gYWNrIGJlZm9y
ZSByZXNldA0KPiAJICogaXMgZWZmZWN0aXZlbHkgbG9zdCwgY2F1c2luZyB0aGUgc3lzdGVtIHRv
IHdhaXQNCj4gCSAqIGZvcmV2ZXIgZm9yIHRocmVhZF9hY2sgdG8gYmVjb21lIHplcm8uDQo+IAkg
Ki8NCj4gCQ0KDQpMR1RNLg0KDQo+ID4gDQo+ID4gPiArCXNtcF93bWIoKTsNCj4gPiA+ICsJV1JJ
VEVfT05DRSh0ZHBfZGF0YS5zdGF0ZSwgc3RhdGUpOw0KPiA+ID4gK30NCg==

