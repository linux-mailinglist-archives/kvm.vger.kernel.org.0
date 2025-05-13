Return-Path: <kvm+bounces-46404-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B51DAB5FDC
	for <lists+kvm@lfdr.de>; Wed, 14 May 2025 01:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B73B8679F7
	for <lists+kvm@lfdr.de>; Tue, 13 May 2025 23:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60E76211A11;
	Tue, 13 May 2025 23:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QlN4T7/q"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BDF1A3BD8;
	Tue, 13 May 2025 23:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747178646; cv=fail; b=QQ+e4+OlWkYbC1mJ3PaFM2zxCEqy992WJ5D7gmGDNMLWEG8dlNaCDEvE/lNGUNofZtCSFZQGdxlVkSH3AfLq+gJ4u1ygOhKv85+NiYoTsnLRiAVLq6UBAJU2ZzwsHckIkXnwJj806h87XDZKSlQtYIkrfWE09n29jOjqFfuNFlw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747178646; c=relaxed/simple;
	bh=eXTr6piTHLJWF3LG2Q713dexpAuO+kdsvSJVNwsQo0M=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Fa3eWq5rlyfEasBRTuqC15X3jU80Z20fUtnlJWDLLTGYDw6PcTFpkmqGZwQf0ZPC0jN694YTCbtwb1vveGBeT5Xl+jpoYZuQfkTuVTupoMSrrLufx3acOUfg8WU/M5zwymnxfiEipMqggmS7VfcxMznOr2N1iH2Ef/ZV2xMfusI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QlN4T7/q; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747178645; x=1778714645;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=eXTr6piTHLJWF3LG2Q713dexpAuO+kdsvSJVNwsQo0M=;
  b=QlN4T7/qrnlKdK00Y5yO3JFMvOWQw1g3wcFCA+ov+0lprvavBqQr3VD9
   1odXeS55zRd7mlKWHelJUCOReVTOdHoorTZmkn5f7mYJlJuZT1I23tdPM
   LtbIpUG14xUgWXNXNGc9JYMcl8UtE3Fs/y+xG0QttO+z0PPqi7maYdXO2
   XI42407NbAZPL19HMOeGR9QpF2QK7htCXGKsVPywsVsWMf4cBjyGsb577
   gL7kZIJiaSdLIXUE14TcRyOvTsV8okNKhJ0sQsBr3iVa7M+Wyh0DfNChR
   m/Nc5RH+1K8OSkfhHbPb63aEjfjMwTzqpYxcwfhYP12wUF8Yv45+loqgT
   A==;
X-CSE-ConnectionGUID: O+HpwbUQQOmvj4bmRvg8bQ==
X-CSE-MsgGUID: MREmKva8SyS9VXDmF39P9A==
X-IronPort-AV: E=McAfee;i="6700,10204,11432"; a="66601574"
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="66601574"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 16:24:04 -0700
X-CSE-ConnectionGUID: Pvi5ligSQh63iErNKmlnfQ==
X-CSE-MsgGUID: SlzRVA8+QP6DQyaFoZaQXQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,286,1739865600"; 
   d="scan'208";a="161154571"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2025 16:24:04 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 13 May 2025 16:24:03 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 13 May 2025 16:24:03 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 13 May 2025 16:24:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EeygoW0/ewrW1cQfGCLWq6PwOGtcjrS33SxmcowgQEdKIJv2jm+DZ2THs0bYrfCvozxhK7eC/h8U4m4esw4yr2kJq/f04f1IqY+BW88LFbWdq5vbMazUo+JhbwA8+m97bqUsPB/n94EAW/bUM+SPbwzR7P6ry1cnUyuGXrnK16YHdwd4WO4lbuYJ3oDBB3cedmyjneNPvw+RLBq2+Y0+ps/B6VhdXX29mKTZLl5AVzjO3Bnw+1CgXRIuHQhfyegRv5bm7jU31lKgW/1s108nT+61ZauAx2eS9N1+4Ca5LNdROupaO1eI0Tm8smWLO4ZbCW3O1/1N/KBubUy0k+ZKcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eXTr6piTHLJWF3LG2Q713dexpAuO+kdsvSJVNwsQo0M=;
 b=kHYVjfb5+EvOPnvTfIlujkAGIFYVqghn5LsHlRPMf3XjuRaCGf6PWQAxhhrixGoZR7SaG520ykwnJ8chHfZPQeCGtTwO3xwJJU9LsY4Dtmi0HUaS6l16VEN4yyYG5uVndMvW2AHn1BpLSxdMXCtTewGdlgIfYJ4PKdwsrAUCqgFcNBFQVRDOePNKg+vfzZ2LXt9hOZHZHEmgSL0CyySNg2fq7fcnTfCbhQHm3pc3LxPiZfPYspcSUbynnt7x6JyzohcHdVtuItfw4Fk9IIPymH7DTRPEuRDxRU4E/L+rsRi8W5uORtWxG+/Otb3N25iPRHXjVw41aauXdKzc8o+5ow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3303.namprd11.prod.outlook.com (2603:10b6:a03:18::15)
 by IA3PR11MB9040.namprd11.prod.outlook.com (2603:10b6:208:576::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8722.30; Tue, 13 May
 2025 23:24:01 +0000
Received: from BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c]) by BYAPR11MB3303.namprd11.prod.outlook.com
 ([fe80::c67e:581f:46f5:f79c%6]) with mapi id 15.20.8722.027; Tue, 13 May 2025
 23:24:01 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Topic: [RFC, PATCH 02/12] x86/virt/tdx: Allocate reference counters for
 PAMT memory
Thread-Index: AQHbu2NcKKP5MHJtMUaG74su/aJ+/7PD5FsAgATYIICAAMnMAIAFSmUAgAJ0u4A=
Date: Tue, 13 May 2025 23:24:01 +0000
Message-ID: <59918204553304585345bffdf9816859ca60f0cb.camel@intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
	 <20250502130828.4071412-3-kirill.shutemov@linux.intel.com>
	 <1e939e994d4f1f36d0a15a18dd66c5fe9864f2e2.camel@intel.com>
	 <zyqk4zyxpcde7sjzu5xgo7yyntk3w6opoqdspvff4tyud4p6qn@wcnzwwq7d3b6>
	 <e3f91c2cac772b58603bf4831e1b25cd261edeaa.camel@intel.com>
	 <pboxqhwxvrm3llyhqtmemvlci5g7xjr5cgbi7ixjtl5gzoafoo@bwcxtpz4nq4o>
In-Reply-To: <pboxqhwxvrm3llyhqtmemvlci5g7xjr5cgbi7ixjtl5gzoafoo@bwcxtpz4nq4o>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3303:EE_|IA3PR11MB9040:EE_
x-ms-office365-filtering-correlation-id: 14a5c02f-1fe4-456d-bd56-08dd92753e5a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|7053199007|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bERBYlNGREtMMzBhZHdRZnkyOXJCRWxlU3FTbURPRUtGTkNOY0Q0S1NhZlpS?=
 =?utf-8?B?ZFdPSGx5SEhjMDIxZkxjYnM0Nks4QlB0NUhpNFNHaXNWRGo2blM5b1A3WGJh?=
 =?utf-8?B?M1AzQy8wNmlKUjl6RDJQV1lXa1hCdnNocDZNbWphMHRiQWtZalRHTGJDaXM4?=
 =?utf-8?B?WTRCeTZUMWVGcGw2QzRKdjczWDBTMk05WUZYbDlQamJlNE5veWtRaTlQdWg0?=
 =?utf-8?B?ZW1OSzhtWnR0a0xJUGRWZlR2c21iN1RQRFRqbS92Nm5NcnBMdVdrQW1BK0xz?=
 =?utf-8?B?emh4N1pJeGcrL1o3S2lJTlhNSEdHaFZTVThvWkNCK3Y2WW1Rb1QzNXdhVm4z?=
 =?utf-8?B?WVBCRGo2SXhWUTVCL3ZjZ0xZTFZkdzQ1ZUZocXBZVmhrZE9nWHljNk5QWnZl?=
 =?utf-8?B?ZEtlOFlmVFFOUlQ3UnJiTTJyLzFFV2xKUm5vK3BDc1ViQjdDSEZYamhvN00y?=
 =?utf-8?B?YlZXTTFoc295N2VhREJneUhNVG51YXMwNjJJWHBGVUl1eWZmM1JFa1ExV0F0?=
 =?utf-8?B?d091VjZJMnZ1ZUcwVVo3NGlsSDBkUFZyWTdXSjVNWTNjbXNmMXRqVVdHNkJU?=
 =?utf-8?B?a2ZuOEZSSTJVcXdIK3FjNDZ5VWx2QzZCZ2xESkRzSmhTMEN1ZEtNeXFDT2x1?=
 =?utf-8?B?WmVySVBJdGlvTGxJdlRCZktPMVZQNGRpUGpmS0lnMkEzcSt1RzJmVTdicTcr?=
 =?utf-8?B?S1ZmODRnall4c0F4RFExRnhuU2NPZHhZa1VxbGs3WUtkdFloczQ5ak81QWdl?=
 =?utf-8?B?eWVxZnZud25IaG9oSTN3bFJvY2xWOVo4WFk3YStMbmw2WlFjTjBBVENRZkxn?=
 =?utf-8?B?bDg1OVJneUh5TFcrTjhoRjRXTStId2FXN2dlSG9SWmxCQjBPQkxwTWEzUkxD?=
 =?utf-8?B?aTQrTDk3cmVCZm4rMjFFWHZVcHNrTzBlOW1TNE1tM2twUmZocmJlYk1DaHVG?=
 =?utf-8?B?cEEyS1dsRWVHL3c2VVRMSnB4UFk5eG5CODN2STFyb3RWZTNIYi91MDgvcGFv?=
 =?utf-8?B?eVFEb1lOS1lZRnVaRHh4M21QRzFDSGl6NjNtS051aU9HdkJxV29EZ1ZrbUV4?=
 =?utf-8?B?UnRCcFh3NDU3M1dZd0J4MmRrMGdoKy9sTG80TlBGUUF4MThtZmlLd3RyQzI0?=
 =?utf-8?B?RTlDc2piWGhZclBVRGpOVVF4aXZjVXZ4Umo3RDljT2ZsVDV3Y0FLb1h4M1dy?=
 =?utf-8?B?TnZ0blNPMzVPMkxXcm5PdGJsQlpRckxUMzN4L1ovTHI2MU9UUzYwU0ZQQXFE?=
 =?utf-8?B?ZXdYQWp6QTVqczBieFNqdXNVWkFGdTNjYnRzU2FTeXV6YnVENkVtbC8xTHlh?=
 =?utf-8?B?ejlKMDUrSGRmVW9MWnFnL1hEWDN3K0VXQ0dwT2NZeFg4b2NQbTJLWmtoNWta?=
 =?utf-8?B?Skg5RG1kNmJxUngvVVZhWWZHWU5tOW42YzIxTnd0UFN6SnZJeUsya1duZ1BV?=
 =?utf-8?B?d0pPNEFCSXBpaUx4TEVWUGNSam9pQ1dFY1AwcHE3L2JrcE9EL3lYY1BxTWxn?=
 =?utf-8?B?NFY0eDNoTit3b3JNTG5YVUxoNHlYeUVUY3laWU5qY3Z2V1JMTDVEeTB2RUZH?=
 =?utf-8?B?NjYzTU55bWEvdWdWejVvNHgyUjYzS3pzblcyb2RPRTA5bS9iN2w1bVN6UWZE?=
 =?utf-8?B?aUh3VStwaHpGR0Y4eHZUdFh5MzlQLzUvY3JrL3BaemFHZU9Sdjhmc2ljNHlY?=
 =?utf-8?B?dE5XREhWZDVQOWp3OC80dURXSTRjVjhQZXN1aXZGQzhUWTQyNG41WkQvdHlK?=
 =?utf-8?B?K3FmSGJ3U2VJMG84OXIrQlpYVGh1cWl4VmdmOGVOYjBXaXVGRHU1aG1vNks5?=
 =?utf-8?B?Nk1lUkdnN0o3Y2RSdlg1N0N0M2gzcVVldVliSEhBdkZHc3pFdExSV0VNT0JO?=
 =?utf-8?B?ZmJ4SlBGa0NWcmx4NHdhKzJZT2JidmRsSXd5WjBXZTFpVmdOanVic1EwVWw5?=
 =?utf-8?B?cjJpcExYT1k3UzRucW9xZ2d1RDNXckdzS2M0a0FPSk5pU2I1QmhRRXdyemc1?=
 =?utf-8?Q?CbON7c64J4PQf+tvmoLu4ZVtwRJy2Q=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3303.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(7053199007)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Sll2QUpEOGIxNnlUWktDMU14QkpFY3FnYlNiTmk2ZzVUeGM1Q0tRbUpZSUt2?=
 =?utf-8?B?S0JEdStVN0pDWW82UXhzM2NxakRyT0JaVWFPOUlVVmFKakxWUTl0NG9RcU1h?=
 =?utf-8?B?UGNuOUs5Z2pycGpRd3o2WWtJYzFJVTFoa1J6bnhlSCtrbExtV0N1THVGRldX?=
 =?utf-8?B?OGhjNnRzTEZsN1F5UVgwTUw0d3hwSUhQNjdvQ3lyelNPeE5YaTNpb3dqaitG?=
 =?utf-8?B?TU9YRWw5NHd5dkh2RHgyQXVtbXd2bE5LTnFZeWtNTnVUcUQ3aldGQ3dtL3BT?=
 =?utf-8?B?R0V6VldOY1M3MmVnME1sTDBDa0cxa0dYRWlYREJBbVZXNWdZcGpobGFQdkE1?=
 =?utf-8?B?aFFTR3N5Zlc0NEpMUjZ0RE1EeER1czJaclQvSFI3UFNMRmYyMERLKysxdnVj?=
 =?utf-8?B?eTZPK0xpcHo1K1lzSEpGUWdGelBxeitMSGhwbFN6YUhRNkcyQUh6Y0trV0VV?=
 =?utf-8?B?bmlyeFRBdFZITjNHN3ZnU2xpeWN4ZzJlbWQ0VncrRTFCcWZRdSsvbHFIYi9N?=
 =?utf-8?B?RFBnYlJvQlBObkRHa3VlQjRzSWR1ZVBqc0d0Y0luOExWNHBOcFVFSlc1eEtR?=
 =?utf-8?B?b055NXJpanlZcklnWDVZZGgvYytnQi9JOXgvVy8vSE41ZXVnaWVVU3VLM0M4?=
 =?utf-8?B?Njc5Rmo5cmwvRFNUakdJM3pFcDE3Qjd1NUIyRUx1Z3g1bFg5bWJMYWhMU3Bo?=
 =?utf-8?B?cG04aGZSaFVGazVCRU9MTkxBYlV2WUNPOTdUM0ZteGF1ZXMzTGw2UjZJOXJp?=
 =?utf-8?B?QkVVSllMek4yZW5ENFVIWXE1dFl2VUR2NjFnaFl4MDBBTUtuSXI5U3NFR1Q4?=
 =?utf-8?B?QkZ0WVIwcG8vZStZS3V0RGJQbzJ3SWlsUFVKbzh2eHU4M2lWbzdxZFFMeW5q?=
 =?utf-8?B?S3gzMVdnVmF4Y2NkTVJwek5zV3lFd3RnSE9hOGNaSVhpY0k4dVEzaU15d1BB?=
 =?utf-8?B?L3l1VTh4dE15dkxqNWpTdndEMnhqdGJ1MFU4c3dpN2lhRlpHL0wxZkhhWmQ3?=
 =?utf-8?B?QkNDdDIvYXM3KzBVWGRtMWt0RlV5VEE0dklPLzRnaGxuMkZOSWJVbWFJc2po?=
 =?utf-8?B?YU5rTVlTcmMrdy9RNUhPQnduUXZHMHNRK1RPRy9RbGZXYXlBQWM3ZFpMUkVN?=
 =?utf-8?B?TUk4VDJhUDZhYVhaQWJtc0FtVUZUVUlRK2JkY3JsU0pZZTBoRTFKbWNaYjlt?=
 =?utf-8?B?VW0vVWV3a2tEbHNDUVRvR3VHUlNNS1VzeG93b2xxWVVOSEZpby9vb1RGVXY1?=
 =?utf-8?B?WnJpYTg2YVAzVEF1bmo3VVNtWndoRXFWU3lOSXNPTUV6V3lpY0NJNGdoZHhv?=
 =?utf-8?B?VGJycEVmTzI2em8yOCs0MmtUYWwxalREK3VXOWlzOUU3d1FPcElPd21FMVVQ?=
 =?utf-8?B?N2VlQ0pNRit4eittOE9YSHJQdWU1c0lMeHkvYm0rZzdJODdxbEx5MGMyM1g4?=
 =?utf-8?B?dUdJeXd0dnFSQXZCbjllWjAwemxaTFY4YnRuWjNMYTFiNmhIb0FLek41WkIw?=
 =?utf-8?B?aDY3bkdqNllNdy9TUFpYcWcwMDh0c1owS3dod1BnL2x5TW9Id1ZCdC9NTzJT?=
 =?utf-8?B?bU9MNElTS2VBYnpERzJ6UldaMUQyWnZ2ZElQSUxFV0d4MGpqa2lDaHFuZkdv?=
 =?utf-8?B?d3lPckhjazh2SFUvQm81MzBVbEVYNEdaWXFLNGlWY1hWMytJT21NM2gvTExl?=
 =?utf-8?B?RTNtNWNzSDZrOVhDT09jS213S1V4YzlxSXozWE14NGlTanU0VEg2SmlFQkFy?=
 =?utf-8?B?UW9td3FtZjlKSkphTFJsZUdFaWV4V2RRQ3phQ1JEV01GLzQ2OTI0TUVSMmpq?=
 =?utf-8?B?QmtmaVFzQTJuTlBjMThxV2JLMUxNZXdsaDZvYWxvb3dCNzBpb2IrQ003eEpQ?=
 =?utf-8?B?V2pTMzVlZXpNR2R0TGg0dm1Lc25TOTczcmVJdkg0aERKTzRIcW53STBWTmxR?=
 =?utf-8?B?a0N0b1Z4aUgvdjVCSkFSQTN5R1NoMEp5V1R3Yis4TWxMNTZkcVU5c0QwV2Jw?=
 =?utf-8?B?bnIwckJYNW5yR0ZFazlyS2hPMUpGZzJTM3FDOXhma1JyNkhIZ0JTSUdDK1JS?=
 =?utf-8?B?RVRaK0pBb1haTnAwL3JuaFNhTXBsNGtnY2lmODBLcWF0YTI2cloyQXZrWkJr?=
 =?utf-8?Q?eL5gRFs9M9rQDNktY8tz4rpsM?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8D1099E3D4AB0D488590DBBC2215F8BA@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3303.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14a5c02f-1fe4-456d-bd56-08dd92753e5a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2025 23:24:01.1067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6AMGCMpEnQ6xeaITPfNO6/eV1qsa51ZyejdXtgYqc3Ygex9BtPLQbVmUNrbA7NKK3L3SCpj2mtnCX7c/PaSGfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9040
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTEyIGF0IDEyOjUzICswMzAwLCBraXJpbGwuc2h1dGVtb3ZAbGludXgu
aW50ZWwuY29tIHdyb3RlOg0KPiBPbiBGcmksIE1heSAwOSwgMjAyNSBhdCAwMTowNjowNUFNICsw
MDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiA+IE9uIFRodSwgMjAyNS0wNS0wOCBhdCAxNjowMyAr
MDMwMCwga2lyaWxsLnNodXRlbW92QGxpbnV4LmludGVsLmNvbSB3cm90ZToNCj4gPiA+IE9uIE1v
biwgTWF5IDA1LCAyMDI1IGF0IDExOjA1OjEyQU0gKzAwMDAsIEh1YW5nLCBLYWkgd3JvdGU6DQo+
ID4gPiA+IA0KPiA+ID4gPiA+ICtzdGF0aWMgYXRvbWljX3QgKnBhbXRfcmVmY291bnRzOw0KPiA+
ID4gPiA+ICsNCj4gPiA+ID4gPiDCoCBzdGF0aWMgZW51bSB0ZHhfbW9kdWxlX3N0YXR1c190IHRk
eF9tb2R1bGVfc3RhdHVzOw0KPiA+ID4gPiA+IMKgIHN0YXRpYyBERUZJTkVfTVVURVgodGR4X21v
ZHVsZV9sb2NrKTsNCj4gPiA+ID4gPiDCoCANCj4gPiA+ID4gPiBAQCAtMTAzNSw5ICsxMDM4LDEw
OCBAQCBzdGF0aWMgaW50IGNvbmZpZ19nbG9iYWxfa2V5aWQodm9pZCkNCj4gPiA+ID4gPiDCoMKg
CXJldHVybiByZXQ7DQo+ID4gPiA+ID4gwqAgfQ0KPiA+ID4gPiA+IMKgIA0KPiA+ID4gPiA+ICth
dG9taWNfdCAqdGR4X2dldF9wYW10X3JlZmNvdW50KHVuc2lnbmVkIGxvbmcgaHBhKQ0KPiA+ID4g
PiA+ICt7DQo+ID4gPiA+ID4gKwlyZXR1cm4gJnBhbXRfcmVmY291bnRzW2hwYSAvIFBNRF9TSVpF
XTsNCj4gPiA+ID4gPiArfQ0KPiA+ID4gPiA+ICtFWFBPUlRfU1lNQk9MX0dQTCh0ZHhfZ2V0X3Bh
bXRfcmVmY291bnQpOw0KPiA+ID4gPiANCj4gPiA+ID4gSXQncyBub3QgcXVpdGUgY2xlYXIgd2h5
IHRoaXMgZnVuY3Rpb24gbmVlZHMgdG8gYmUgZXhwb3J0ZWQgaW4gdGhpcyBwYXRjaC7CoCBJTU8N
Cj4gPiA+ID4gaXQncyBiZXR0ZXIgdG8gbW92ZSB0aGUgZXhwb3J0IHRvIHRoZSBwYXRjaCB3aGlj
aCBhY3R1YWxseSBuZWVkcyBpdC4NCj4gPiA+ID4gDQo+ID4gPiA+IExvb2tpbmcgYXQgcGF0Y2gg
NSwgdGR4X3BhbXRfZ2V0KCkvcHV0KCkgdXNlIGl0LCBhbmQgdGhleSBhcmUgaW4gS1ZNIGNvZGUu
wqAgQnV0DQo+ID4gPiA+IEkgdGhpbmsgd2Ugc2hvdWxkIGp1c3QgcHV0IHRoZW0gaGVyZSBpbiB0
aGlzIGZpbGUuwqAgdGR4X2FsbG9jX3BhZ2UoKSBhbmQNCj4gPiA+ID4gdGR4X2ZyZWVfcGFnZSgp
IHNob3VsZCBiZSBpbiB0aGlzIGZpbGUgdG9vLg0KPiA+ID4gPiANCj4gPiA+ID4gQW5kIGluc3Rl
YWQgb2YgZXhwb3J0aW5nIHRkeF9nZXRfcGFtdF9yZWZjb3VudCgpLCB0aGUgVERYIGNvcmUgY29k
ZSBoZXJlIGNhbg0KPiA+ID4gPiBleHBvcnQgdGR4X2FsbG9jX3BhZ2UoKSBhbmQgdGR4X2ZyZWVf
cGFnZSgpLCBwcm92aWRpbmcgdHdvIGhpZ2ggbGV2ZWwgaGVscGVycyB0bw0KPiA+ID4gPiBhbGxv
dyB0aGUgVERYIHVzZXJzIChlLmcuLCBLVk0pIHRvIGFsbG9jYXRlL2ZyZWUgVERYIHByaXZhdGUg
cGFnZXMuwqAgSG93IFBBTVQNCj4gPiA+ID4gcGFnZXMgYXJlIGFsbG9jYXRlZCBpcyB0aGVuIGhp
ZGRlbiBpbiB0aGUgY29yZSBURFggY29kZS4NCj4gPiA+IA0KPiA+ID4gV2Ugd291bGQgc3RpbGwg
bmVlZCB0ZHhfZ2V0X3BhbXRfcmVmY291bnQoKSB0byBoYW5kbGUgY2FzZSB3aGVuIHdlIG5lZWQg
dG8NCj4gPiA+IGJ1bXAgcmVmY291bnQgZm9yIHBhZ2UgYWxsb2NhdGVkIGVsc2V3aGVyZS4NCj4g
PiANCj4gPiBIbW0gSSBhbSBub3Qgc3VyZSBJIGFtIGZvbGxvd2luZyB0aGlzLiAgV2hhdCAicGFn
ZSBhbGxvY2F0ZWQiIGFyZSB5b3UgcmVmZXJyaW5nDQo+ID4gdG8/ICBJIGFtIHByb2JhYmx5IG1p
c3Npbmcgc29tZXRoaW5nLCBidXQgaWYgdGhlIGNhbGxlciB3YW50cyBhIFREWCBwYWdlIHRoZW4g
aXQNCj4gPiBzaG91bGQganVzdCBjYWxsIHRkeF9hbGxvY19wYWdlKCkgd2hpY2ggaGFuZGxlcyBy
ZWZjb3VudCBidW1waW5nIGludGVybmFsbHkuIA0KPiA+IE5vPw0KPiANCj4gUGFnZXMgdGhhdCBn
ZXQgbWFwcGVkIHRvIHRoZSBndWVzdCBpcyBhbGxvY2F0ZWQgZXh0ZXJuYWxseSB2aWENCj4gZ3Vl
c3RfbWVtZmQgYW5kIHdlIG5lZWQgYnVtcCByZWZjb3VudCBmb3IgdGhlbS4NCg0KT2ggcmlnaHQu
ICBURFggcHJpdmF0ZSBwYWdlcyBjYW4gYWxzbyBiZSBpbiBwYWdlIGNhY2hlLg0KDQpJdCdzIGJl
dHRlciB0byBoYXZlIGEgd2F5IHRvIGNvbnNvbGlkYXRlIHBhZ2UgYWxsb2NhdGlvbiBmb3IgVERY
IGJ1dCB3aXRoIHBhZ2UNCmNhY2hlIEkgZG9uJ3Qgc2VlIGEgc2ltcGxlIHN0cmFpZ2h0Zm9yd2Fy
ZCB3YXkgdG8gZG8gdGhhdC4NCg0KRm9yIG5vdywgSSB0aGluayB3ZSBjYW4ganVzdCBleHBvcnQg
dGR4X3BhbXRfe2dldHxwdXR9KCkgaW4gdGhlIGNvcmUgVERYIGNvZGUuDQpXZSBjYW4gYWxzbyBw
cm92aWRlIHRkeF97YWxsb2N8ZnJlZX1fcGFnZSgpIHdyYXBwZXJzIChlLmcuLCBzdGF0aWMgaW5s
aW5lIGluDQo8YXNtL3RkeC5oPikgZm9yIGtlcm5lbCBURFggbWVtb3J5IGFsbG9jYXRpb24gc28g
dGhhdCB0aGV5IGNhbiBiZSB1c2VkIGZvciBURFgNCkNvbm5lY3QgdG9vLg0K

