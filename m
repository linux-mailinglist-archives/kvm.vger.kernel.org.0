Return-Path: <kvm+bounces-68860-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aPJLO63ScWk+MgAAu9opvQ
	(envelope-from <kvm+bounces-68860-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 08:33:01 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 9309262862
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 08:33:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B2B80562C5F
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 07:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4DD480955;
	Thu, 22 Jan 2026 07:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AxDNmu6g"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363E73A63FD;
	Thu, 22 Jan 2026 07:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769067036; cv=fail; b=n4BePJ9I7S3atV7KLNWOPze1tSz7MVR9AIXSZQeE7CnrZoYXY8gdsGdnmwj4Jd5IDWMK/1CaidRU4WUlruwbUWQYrBqmauJ36S3Cri2m/liKQ/2vXauJw4Q0bMatukatMhvb/4PxavIT+4nznV2QHdLFJNWmrVBzK+oNYiFFnzs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769067036; c=relaxed/simple;
	bh=Y7lQOFB35CVbuk5tMdkSkD74gHsro81nNWC6FdH4xnU=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=C07iELpE7znOds79caaU6XMYVuTsOWPF8976P3dSRPCzGFL40pL4du5s+ZpNuK7e2C+A0q4sh1tKSlVeR7YAhvkgXC+uS3bSxHLmaMNVa0kSrxbmwXvLKjepi2na75CcqCBenx0Axi6rvmny6vuyZRbqe/NWexRDW4aWgguhML8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AxDNmu6g; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769067030; x=1800603030;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Y7lQOFB35CVbuk5tMdkSkD74gHsro81nNWC6FdH4xnU=;
  b=AxDNmu6gol7APU/WXqfLauA3Cgs/zCQeG1QXvf8Hn7nfn8LMXM4oe/uu
   VCKCUfsi8wnyvjSmGjaQf0YaBK4ntNa5X8wtdVNIuuVJMOTtshPNI3Z8Q
   ZeuzDWctSFP9L3oLJTwM6ptiq//5E7qNkMY4bl76tOuNFC+NEU5dNghQb
   Oz1f0nrOHOf4GGT+nYhEfgMHUz4eUabGBJluD1coVZuQL8UGrf9rX4yQC
   mhAMkRl78S6YCjjVgbmQlGKl27ESoRGMaHF4SMs8j2f0R/oFsPnHDtx0e
   4Mu2WC7eGj2QzUwEOVTAOmhrVaP9Rw35lHinxOQhXl7gp9JEzpZtnrEbT
   A==;
X-CSE-ConnectionGUID: g9n0BEgtQ7+0bEubsJzfRw==
X-CSE-MsgGUID: 0k/s0YDjQNaWWwd9pr+bZg==
X-IronPort-AV: E=McAfee;i="6800,10657,11678"; a="70353722"
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="70353722"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:30:25 -0800
X-CSE-ConnectionGUID: tMgM3ZXAQS+LRkXDb7f46g==
X-CSE-MsgGUID: lgDIZDb4QUeo2tJxBDg0+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,245,1763452800"; 
   d="scan'208";a="206570135"
Received: from fmsmsx902.amr.corp.intel.com ([10.18.126.91])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2026 23:30:25 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:30:24 -0800
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Wed, 21 Jan 2026 23:30:24 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.5) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Wed, 21 Jan 2026 23:30:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WEGYk/MthLcKuPRhffN40rBer/4mx8KGqIognQtTpixp2RNgS55A3qlzr8FnwPWQoinmfpmgdc82O1qKFKCg/Ict0Ig0Iy7s3VkpQ2E1rn+08A0aT/IUZYWwcMADDlv2l9V4uEBL1OC8AWWsjg+gmyulUQsSTTidz7JLUuyo3Q53zAMZuHv4pxBhH40s1BGfpd8FlSrduczeSxkYazb+sPIVjzdUFv/VR8jmsl8dNb7Lye82YLMQ+kSPSNYbg02CXvn6XN4vq6/PCWGF9sisudHrnDSjnrHqICxwjnpgM1gVVCR0pHnp/c3S6gqEe2H4l/tO1G8LXU0vJHQNjzMGBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y7lQOFB35CVbuk5tMdkSkD74gHsro81nNWC6FdH4xnU=;
 b=YrlqVq6oVmVknKDcsT82vMujgxgKEDyyPioTvefz/+tuaG0gftdpdGXkgBZClL25qBUlcHZY/KTEb2xDRQYEx9LPTWELegfyVXGUPAgxJmaDYSM3YpaRLZADoHoIzyBLQpjb2A7h4EmXw8fQds5q0Gb9VzwelAzHl+CYLi3ohR0mqvj6wt7o1QML8H11RajQlhCFfTlYBpf0YTlhjzgZSO2WE4qIdPLCT+16ZKP4znDAWwuOVw6rgBARWo9fxfFGZePQTx+DLMt2p8qgopw7ZwYaJY+bBAcGSMXGjuMfSRvDFeQiyLhCk756/q9O0k5CwSWeFGjbdWcCHtFZLZDFAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9542.10; Thu, 22 Jan
 2026 07:30:16 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::7181:6f6e:ae0e:3a4a%5]) with mapi id 15.20.9542.010; Thu, 22 Jan 2026
 07:30:16 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>
CC: "Du, Fan" <fan.du@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"Li, Xiaoyao" <xiaoyao.li@intel.com>, "Hansen, Dave" <dave.hansen@intel.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "tabba@google.com"
	<tabba@google.com>, "vbabka@suse.cz" <vbabka@suse.cz>, "david@kernel.org"
	<david@kernel.org>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Peng, Chao P"
	<chao.p.peng@intel.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"kas@kernel.org" <kas@kernel.org>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "Weiny, Ira" <ira.weiny@intel.com>,
	"francescolavra.fl@gmail.com" <francescolavra.fl@gmail.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>, "sagis@google.com" <sagis@google.com>,
	"Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "Miao, Jun" <jun.miao@intel.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "jgross@suse.com" <jgross@suse.com>,
	"pgonda@google.com" <pgonda@google.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Topic: [PATCH v3 19/24] KVM: x86: Introduce per-VM external cache for
 splitting
Thread-Index: AQHcfvbSydlt/e/FU0SaQnkHllxJ3bVb88AAgAEFlwCAAOMVAIAAB4kA
Date: Thu, 22 Jan 2026 07:30:16 +0000
Message-ID: <8e025ab571eadb2a046e2dc1b53a92de6506ea01.camel@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
	 <20260106102331.25244-1-yan.y.zhao@intel.com>
	 <b9487eba19c134c1801a536945e8ae57ea93032f.camel@intel.com>
	 <aXENNKjAKTM9UJNH@google.com> <aXHLsorSWHRslpZh@yzhao56-desk.sh.intel.com>
In-Reply-To: <aXHLsorSWHRslpZh@yzhao56-desk.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|PH0PR11MB5175:EE_
x-ms-office365-filtering-correlation-id: ea4bc45e-0033-45ac-e13b-08de598816b8
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?SWpQbGQwd3lUWUo2RzM1dGhvbzd6d0Q1VURseUM3Z2Z3SVBvN09ndTEyZ2p6?=
 =?utf-8?B?V3ZlZmJZdENrL0kycEdvc3k3dmZxby9sWFZXMXJ5NWF2TUI4WTJ3UUFhYllO?=
 =?utf-8?B?TlA2RW9TWHRwcUpUcVhYWXBubnhzVmluTHoyV2xOWW5XZUdjaXdhZ2FHZm5P?=
 =?utf-8?B?R1RpWlZvOGlHTk5NWlROcmdmTlZwenVBdmpVeWZGZlVQZUxqenVNUkpYLzZz?=
 =?utf-8?B?a1RvNVExK3hSRUFoajlkd2dLb0MwajQ1WUd0emJIZnYzbUJWa3l6bjRXRlZ0?=
 =?utf-8?B?cHRxUWJGdDZCOWRINEhDb2hyS05Oc0hpaHdtMWRNZU9SYm5relEyNXNDVGZa?=
 =?utf-8?B?a3FFaDE5QythVy8vVnhtVVNBcHBwbGtiekczQWhUMlBvKzErV1VISHdUd1Fw?=
 =?utf-8?B?UGRxSmxiaCtDOXB4R2RYd1ZWS09MZkdQbWxqT0RIcjBuRGM0YnZqNGZjMitL?=
 =?utf-8?B?ZWFLL2t3RXRRVUtORmtvNWwxU0p0ZFFpYXZoc0RvL2tYbHVoSHJRTkNuMitK?=
 =?utf-8?B?Tm5uWlgrTVhoQWtLSEEzclVLWEZ0Z0VJeFc1MjgvRzdCbGVRdVVLV2lEd1lH?=
 =?utf-8?B?M0VQakdJenQ1V2ZmSDdtdy92d2J2eEk4TmNORkJ4N01qbndENXpnNnFZQlJF?=
 =?utf-8?B?ODR0NTNXdWo3UjRUTDMwbnZybWUrUVhXc3dwL05DMERyWlR4a3BnWnVpL0Yw?=
 =?utf-8?B?TWlmOG02NVZNeFJkc2loZXNiRlduUnVPOEdTSEVodmJJVWJiK1lTL2lhdkw2?=
 =?utf-8?B?TXJWd0Npam1STlZkcWdPMTU0QlYyS3piMUpadVF3RXdTd2hMMERMMVlycHFy?=
 =?utf-8?B?Tml6VU1DdDFuUWVGMFJjSkN3ZDNCRXVHb0xRTkI2SkdSd0I3eGFsdzZ4V2JR?=
 =?utf-8?B?MVZZT2ZER1dhQitGdXlrTmRmQUx5b2JTWHhlWEFaV1NIUDllZm0zQnp4SnJa?=
 =?utf-8?B?ejZHcFlHeVBJK09hU3hSQkxkZVQ5NkxyUVFxWmQwbUZURlkrbWUwVHZCWVVy?=
 =?utf-8?B?cExyL1lkckxaQjhJaitacGFCQ091YjM5NVQ3QU1qQVN3VDRWRU1JeE90aUxs?=
 =?utf-8?B?MHhrelU0UUpKTVRYaGJCdXh0SkRjL3J6bFB2YVlqNytMc0xSMVJ3aDN6WU9v?=
 =?utf-8?B?K0FtQ2pOSk14QlQ5clFTZlNmVTVSZ1JBUFE4SkpKZ3UyS1VGcElzdEtseVNU?=
 =?utf-8?B?WVl3OUdpQ2xMYkZtUjBTeVRKb2FwT1d5SXNGUVhXemdzN2lrdUpLd0QxcXpx?=
 =?utf-8?B?azIrQTI3SEFQR2ZNUGUxZm80bTlUdGJ0K01sMlhqdmEzcG01T2wvZkdLcEpV?=
 =?utf-8?B?bmcxVkZaUjdrQ2lzdzU2b1Nod2hmRXJPRjVISDU2RERKY3ltTFBSN1V4YUl0?=
 =?utf-8?B?cnFiRG9qOFZpc243aTRrQy9RaFVzNS9TaGFxL1lQeE5LcUJlTU1lZFp2WmZH?=
 =?utf-8?B?ZGRxdjJ2d3BLK0RqazJsUGcrN21RSHlLR243clJQRHc0T0UwMTFkLzYyRFdk?=
 =?utf-8?B?elduSndLY0szaTVWeFF5cE42S3V2ZTNwM001SFVvY1pUM3piMmx0bHBWWXpT?=
 =?utf-8?B?RCs2MkUrbzJYcFBXTytudVJNelNrZlBpNUdnN0hBSlFmOS9uSTU3c2pBbU0x?=
 =?utf-8?B?RGw4MXBlSmlyRE1qY2E1NFhWU2xZVTQyT3RpZVU1eVF0aFJWU2dJdlpmTEJr?=
 =?utf-8?B?SHcvQ2Y1eDI2N1RsNzVHcDZNcUN4M1pSZ0EyM3BJbWdsVkY0L2JLSjU5L3pC?=
 =?utf-8?B?b1huem5hTnhCc2dFTnBMVnNGZVVmeVExZlF5ODdWMW85VWR3VGlnVWk0R3pL?=
 =?utf-8?B?eVdjSzlRcENLeGc5aHJSOUdwMUp3UUFZZzU0bzg4UnVLRndLcWRwSENHZnA5?=
 =?utf-8?B?NVhEZ0RTdlp3V1JLWTJoMXJOaWZqL1FTaUhndFNhYy9YdW5iQnlaQjFUV1Bj?=
 =?utf-8?B?OWNGRWJMZ3BGdGdMOStpZDVOMTNBOHhBRlBTb1graGEwK1BEelVnSnp4Qk1K?=
 =?utf-8?B?c2xIZm5JVUtnbm9MV0p2MVNEYWQ4aml6dExtK2EyTC9STm5jeTFDaG5Ec0sy?=
 =?utf-8?B?bzN2eFd0dFR5U2M0YkdYcmE4MW14bW1SdlQySDExaUNWK2tWT2RYd2F1UDBV?=
 =?utf-8?B?Yk5vTVZTa2V3NkUvNVVnUlRwejE3Nyt5Wm1wZFg2dWI5bi91NVB4bkFYY2l5?=
 =?utf-8?Q?ogAHp8CXcHqplLeNAuI2gNc=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWxkV1lyempybmU3VU0ySHBlWTJ0a3hVYjlGYlo1TzFDMEh3cmMvWjRvbC9V?=
 =?utf-8?B?VlNIL2JaRnBNM1Q5bmVHK1NxdkxObkUwTHFIU1dNQnQwMnJrbWc0bkw0YlFM?=
 =?utf-8?B?K3RvYkcxRVM3S2l6U3Z6SHJiUFNMTE1QKzRDcERrdVpWR2U1Ulo1MC83NU16?=
 =?utf-8?B?MlBLRnkrdldoYllleWtUc0tBMlEwUTdmS0NWZit3S2pqOGladkV4aWNzWGJV?=
 =?utf-8?B?Vjh1bWV5MG90U0ZIa296cTRwaUZuS3EvbjVSd1VHZGRiRUorMW1CbVdnb3VB?=
 =?utf-8?B?U2NRSVJ4UlNTVVN2d1B1amhtSUpnZjU3MzZkdC9lR3NNUGdBWVVpaU45alNH?=
 =?utf-8?B?NjJ2SDV0QTBpUzlYQjNjZnNYRnhhNWtrajE0L2s1a1VaOE9TdWRaczlaVnVn?=
 =?utf-8?B?aVdhQXlSU3hVcVJ1MW0wdFBtc3NqeCtoejd6ZVBqRksrbUNOMGVsdS9zNVlp?=
 =?utf-8?B?ZGM3NzZEUVlGZnpTLzJLQ2JMbU1JZ1pjRnc3ODdFYzRyK0dpZ1ZoSExXb2M1?=
 =?utf-8?B?OXozTXExSjRtZGRzL3ZlVEkyT015ZUcvQVY3VDN6UU1sMFhyVzBaWTlBTkRR?=
 =?utf-8?B?azZ4cjB1ei9oUW5keEpPN1JHbUtUa0JMVHFTd1psL3pkNklTdUpBbXNtdmQy?=
 =?utf-8?B?ZWR1N0g1SVMrc1ArSlZJanRadEJYSU1CTW1VdzRuQUhlOFlyVWNsbktncDB5?=
 =?utf-8?B?V2YwOWo1SDhTTVVmNUdwaVJvcFljaTNwMnNSUUxHaXJhOEM1ckc5N29SMDlj?=
 =?utf-8?B?RVRqK0xxdUJqU3pXYTVYTHl4ekROZWxIc1EwVjZvbGh2ajRDYlc4TUF5ZWpK?=
 =?utf-8?B?REh0dFJvWkdiejR0YnZNZjlIVnBJbEhHeVlLVjY3WXM5U2srZ004NXIzYkhv?=
 =?utf-8?B?UncrYWI5ZjZNSUdBL0hYWWhhcjdNUE5LQUk1RWpIQ0hsTmNDRk0rWGkraksr?=
 =?utf-8?B?ZmZXVUIyUWJxZUJqSWppMXlPVG83QnlXbkhkS2JGVmVTM2ZCdk5xYmFDdGdX?=
 =?utf-8?B?NzFxWFBoRUsxbzBuUTN4ZThheDVBQkRCUzBFOFJpbWNYVk5meUJFMy9HOERh?=
 =?utf-8?B?U3g2dnRRbEZZajlLa0JzdlZNckRaRjM0VGJVaE5mc3FEM2lkSnRrODR3UUpQ?=
 =?utf-8?B?Mzc0UFBmZlZRTXBwd21BdlVBWXlhRCtmNHBVc0t5eWJmeUdpNlR5WEN6RUlv?=
 =?utf-8?B?Z1NRVFFtNlJrWjNXYk93aUN1RzdvVHlsSk5xajN6a0t0OW40aVgwVVdROVRF?=
 =?utf-8?B?cndpSHIwMUEzNDl0OXVSZG5xUk5hNk1SNUFiSGFINWJZUGdycTVwdHZDYitM?=
 =?utf-8?B?OUdzZnpVVHZMeDhIVlc0dS9vLzNsZmZvT0pOR1lqV3I3eGJxYVF6dFNjM2E4?=
 =?utf-8?B?ZWl1Qm9qTTJ3dXBTVE1kaUJva21LN3dMbEUzeWQvMFRHTGN2aC9idVNzd3Zx?=
 =?utf-8?B?VVR5ajdkTE13K3N6RDdLbGhnSGVOV2Z3ekk1c29CMkFpdFJGRFplSDUyQnha?=
 =?utf-8?B?ZXd1RkRqdVBLMkhlZmcvTU9VWTBGQkloS3htUlJFZFRCbjNPTU10RDNuYnNJ?=
 =?utf-8?B?b0VjYjFwZ1BqMTJFZlJCSFV4TW12TkxEaUlZOC9RVUJZcXNmOFlQQkRVdjZB?=
 =?utf-8?B?T2xRanhYRzRrSGFKa1lRaEk3Y0ZBZ3NaK1B6d3lQQnI4OW9lSk5vSzRkcTBv?=
 =?utf-8?B?ZlJ5NTNQUU5ZaTJ5UEI2VzJjZ3l6ckI0aEN1TDA3U2JOV1FNMXNBbDYzS1lw?=
 =?utf-8?B?eUNoNVM0VXJTbUxYZkZ1MWRKc3pzU2YxNFVYcSttWGZyaFFCbG5uSlB5UlBo?=
 =?utf-8?B?M1RKS0lCQS9lOHRIdmlhZjJ3Qmp1SnpXWldwL0s1bmtBWUdUcVJWT3dsK0F3?=
 =?utf-8?B?NFpOZ1ArOW9OaThYN2NzbitPUHVCb2IyVldKaWZZK3lGREMzbjhSaUM2Ui9a?=
 =?utf-8?B?MEJYK0p4Vk5KbmdYYkxFcUlvQkp1Mk5kZDh6YU5zeWNTSSs0YU9lU3g0VUJT?=
 =?utf-8?B?dXBIQWplTGJ0c1pDSnQrTCsyaVUyUXlOTHJLU0tGczRaZ3h2eUV6K2t3a3c5?=
 =?utf-8?B?blBvTlJLN1Y5dktjV20rY0k1TTdDbGtEVzFESFVyR1BpbXNEZXF3cy9wd2hE?=
 =?utf-8?B?OWF5RlBVK3ltc28zSmREVFVCaE1yNmZNVHJ4cllIUmt4OFpNYzNtYU5pelF1?=
 =?utf-8?B?NzdmNWxUY3A4SU9XNTJvTEVZSkNqN3RTSUNNUmMxNGlCdmhzTGcrR3BDUVBy?=
 =?utf-8?B?cSt0REJLZC95TlZIMGErd1BPRFZVRFJ2MFdFSmRvazFrUkZFbEFWaGlIYXJ3?=
 =?utf-8?B?RnpRZ2lZdFFkYlZOb0JRNTdPVWZpZWNEWElidEJjWFI2elhDQTk0Zz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <47154A6A8BEE68419674885B1281FDD4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea4bc45e-0033-45ac-e13b-08de598816b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jan 2026 07:30:16.4495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4zZW33zyxVhTcNO+huu2ADBtAZMXI7cJrE/JpTKvzZI7cjM3EXc3pkvcC0vE8mBOqsggNuXrqp0Y+q5b3RA14w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5175
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [2.64 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	DMARC_POLICY_ALLOW_WITH_FAILURES(-0.50)[];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-68860-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,ams.mirrors.kernel.org:helo,ams.mirrors.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[29];
	FREEMAIL_CC(0.00)[intel.com,vger.kernel.org,amd.com,google.com,suse.cz,kernel.org,linux.intel.com,redhat.com,suse.com,gmail.com];
	DKIM_TRACE(0.00)[intel.com:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DMARC_POLICY_ALLOW(0.00)[intel.com,none];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:7979, ipnet:2a01:60a::/32, country:US];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 9309262862
X-Rspamd-Action: no action

PiA+IA0KPiA+ID4gVGhlbiB3ZSBjYW4gZGVmaW5lIGEgc3RydWN0dXJlIHdoaWNoIGNvbnRhaW5z
IERQQU1UIHBhZ2VzIGZvciBhIGdpdmVuIDJNDQo+ID4gPiByYW5nZToNCj4gPiA+IA0KPiA+ID4g
CXN0cnVjdCB0ZHhfZG1hcHRfbWV0YWRhdGEgew0KPiA+ID4gCQlzdHJ1Y3QgcGFnZSAqcGFnZTE7
DQo+ID4gPiAJCXN0cnVjdCBwYWdlICpwYWdlMjsNCj4gPiA+IAl9Ow0KPiANCj4gTm90ZTogd2Ug
bmVlZCA0IHBhZ2VzIHRvIHNwbGl0IGEgMk1CIHJhbmdlLCAyIGZvciB0aGUgbmV3IFMtRVBUIHBh
Z2UsIDIgZm9yIHRoZQ0KPiAyTUIgZ3Vlc3QgbWVtb3J5IHJhbmdlLg0KDQpJbiB0aGlzIHByb3Bv
c2FsIHRoZSBwYWlyIGZvciBTLUVQVCBpcyBhbHJlYWR5IGhhbmRsZWQgYnkgdGR4X2FsbG9jX3Bh
Z2UoKQ0KKG9yIHRkeF9hbGxvY19jb250cm9sX3BhZ2UoKSk6DQoNCiAgc3AtPmV4dGVybmFsX3Nw
dCA9IHRkeF9hbGxvY19wYWdlKCk7DQo=

