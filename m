Return-Path: <kvm+bounces-35695-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 492E3A14461
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 23:11:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B638A3A1EBA
	for <lists+kvm@lfdr.de>; Thu, 16 Jan 2025 22:11:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7162222CA1E;
	Thu, 16 Jan 2025 22:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eQc686QN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BF42155756;
	Thu, 16 Jan 2025 22:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737065468; cv=fail; b=JEvvRXifq7Jx4K58XAw5DVTPxZDjR8CT+X0Kp77cUzqk+OlPTCfH1eRpwn3E+eiEF9zsOqPxMBHtWEkfV8bd9VUhurrUdhfjTOIQgVQzplJEQMB3gY8yltutLTxD6I3b/YtS1w8imjF7AHmV89/bwzPFW6OiITkf4HhzShAPE6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737065468; c=relaxed/simple;
	bh=1teQBlVPhymBY8vD5KD7bEamqfQm9BcJzHthhk9RQK4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Bn30XuPEJZd/YNt0rWec8lRWeTIwaaDg3VF6HgTRCKVSQMh4gG9C4VEX291CkQVndf01FcKgpuah5ahtwAUn6LrUOUpKt2FpRAtJOKP7u274H0DwAPNYWpG9PQuigo6339bFYNvT/KQjfyWBNmicxmJsV0CAHknYPBIuSHQvxms=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eQc686QN; arc=fail smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737065466; x=1768601466;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1teQBlVPhymBY8vD5KD7bEamqfQm9BcJzHthhk9RQK4=;
  b=eQc686QN6WX68Qkv053aJqCwjiJTzF1PeSx27Lg+RZBZNxsKEQsDeSPV
   NYbQr6Udqha3tZvhu7WnG/MtZey4OOkZ7uIb6pe/EixTaS6ymQ8zhb+VY
   mrlLs98w+e+PjI6zRo5g6T3SLSAlxoswXKJ18X80h1rDchhaOmjp+4qWr
   SayXECcgH3kHu+Mf1m5ZBmsIpGem7rKTBTnlpjbsl2LAYY2M5I9oqQqHj
   drRr+8zBJDXCk2SSsbCw/zJVS0D5/ZlKM5iLiAYnswupLApqe8L6rpo5I
   b10htCVN7ytfCSabNd1p8DMv3S74oAV5Y+B+7JWBt6H1DHzT/pD+aBORK
   Q==;
X-CSE-ConnectionGUID: f7y+UPfZRhmcKsecMUqBvw==
X-CSE-MsgGUID: 4WSUeYpyQoq73b4ZXElmhQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11317"; a="25079245"
X-IronPort-AV: E=Sophos;i="6.13,210,1732608000"; 
   d="scan'208";a="25079245"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2025 14:11:05 -0800
X-CSE-ConnectionGUID: y1N0uYnGRuye9sZ2nW0A3w==
X-CSE-MsgGUID: osUTsVtYSWyVAZY5ff01Cg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,210,1732608000"; 
   d="scan'208";a="105452502"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Jan 2025 14:11:05 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Thu, 16 Jan 2025 14:11:04 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Thu, 16 Jan 2025 14:11:04 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 16 Jan 2025 14:11:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=gXY5yZg1zFIMP5/eW0HbXmt76pScQbgPs4qOYj2Kxylin7rYvyS7t2TanPgZdkzvVvizhJAedP81rX6ApwLacybi1V0ih538iz3iwgXHoBwu6abC2IsKX2OVxmAT6C85NyE/Wf76GhhD+i6pK34uPW10K1Rchu510fch17zDzwEx1LxNn7VP8IQ4w6kkHmR0wrkbvvv196S/V9OqO89H+16a0bZ6d+wYEGvHPVoMp58YK4RU8IRywpTOnr4YzX2yYXca4FEH2CXQKDZspE3UXJm0ejMQt60CS2jZZ7xo+j95+3bCMsasXtwymRwL5WWZEL2aKoluSF4KBg7HTVnqqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1teQBlVPhymBY8vD5KD7bEamqfQm9BcJzHthhk9RQK4=;
 b=b1bNuQVdYfif2BFM6iytehOy558R/kWawfoDqmRR1ouh3HaUThWGJnTMm3hIiss1JCzMn8280knX4bCd/DkbvT2YIZR1oUVRevvlns8G5p6U4MJiXww0dypPVZ/5v6izZMYCR0BauYTMKWGcZv8QR5lssaieaU7vCPIPkDBpgENiSCYZ7SGpxCya24q+NfRWAgjL6qsccHqBaqOzxfvwY1AG6yAQm9g0OV7q1EGjt5SZRo6qh55JDiQO6QqolSFt47wUAQAQLU95SVvjqwdFGsm4QBhw4H3kzpwMD/PDhf3Ts4+545olmcXR3VdTvLDZjVeV7BUxZo5dfUcDN1wjcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB7698.namprd11.prod.outlook.com (2603:10b6:806:332::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 22:11:02 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 22:11:02 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v3 00/14] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Thread-Topic: [PATCH v3 00/14] x86/virt/tdx: Add SEAMCALL wrappers for KVM
Thread-Index: AQHbZ2fdmbRdWBZ26kOkd1tFP4ljTrMYNK6AgAAF+oCAAb2VgA==
Date: Thu, 16 Jan 2025 22:11:02 +0000
Message-ID: <90fdbf67cd7d7207d0fe6eaa8339cdb4449a227f.camel@intel.com>
References: <20250115160912.617654-1-pbonzini@redhat.com>
	 <00ff9b4e7ff1a67ca43d4ecd7e46aa59d259733f.camel@intel.com>
	 <e4b2c596-a2a9-496b-8875-4f73ddcfcf26@redhat.com>
In-Reply-To: <e4b2c596-a2a9-496b-8875-4f73ddcfcf26@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB7698:EE_
x-ms-office365-filtering-correlation-id: 6b831ab5-6747-488d-a12f-08dd367aa9e0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SS9nUU9uQkdQbVg4VWJPTk9abzRCZ2gvdEtqUlBVeWZ6bDBJYXkzZnNUU25n?=
 =?utf-8?B?bnhORXdMS3Q2bjBWK2dOZjJ0aTFubTUvYjIrenFpcGRkV2YrcmZ6Z0N4YUI1?=
 =?utf-8?B?TWFUYWhDam5GY1AwQkErN3pxdEJzRTI1K2lOcVVCemsxUytkNkI2VTE3OUNQ?=
 =?utf-8?B?OEQ4STZsVXo1dzRMaUcxVmovUHAvcm9kNERoN2tkQ3BVN1grQVFBbjV2R1BL?=
 =?utf-8?B?V0YxUmN0TzEzVEFUZk9ZNUx3bTBBRXJVaDZ6cmZWeFJzTmRmRWNqRWlVMFJa?=
 =?utf-8?B?ZTFwMlRNNFIvK25vWWFKMElObURBWUhYdjYxYlBDRStXbjBSa21hc3BmYjNq?=
 =?utf-8?B?ODJrMXdXZ0ZjSS9mcVgvdHRhRmFjeTZPMm5ObnVXN05IajdwTGZQeVQwSXlF?=
 =?utf-8?B?WVZPc2dtczVoMDJWUmRYTGVjL3BkclQ3R3VYdlR3T2FJVkttd1dYNnBjWVNG?=
 =?utf-8?B?QjNPZURTWDRPVHNXeGJmRE1PNUdwT3BlZW0yejBhaTFXaDF5NFVXbWtZV3ln?=
 =?utf-8?B?VXp2a1VNL2FyY0ozSXI4bkxqeHhSRnhCMEtGQ2laSUZZL0MrdkpNcmx4U3Y5?=
 =?utf-8?B?M283K1JXUm83emIxWGtyR3J1elc3SmNEY054VDNIR3pQS0xjNUxaaDgvNU02?=
 =?utf-8?B?aHN2VW9iRUZqbUpkMU04RlRTc2dDOEY5bm1veldUTmNwSUhPc2h3ajNEc2ZN?=
 =?utf-8?B?Q0hDTGIwWDRiQThSd0xHNkFjTm96MGlUdWZ2bjZOY2dYMFpwQWQvRWRKN1V5?=
 =?utf-8?B?UjVmNU1zeE15bDhNeG92UDdOY25VVEhxU3hTZlN4eVhUMm93ZmdCTmx0ZFlJ?=
 =?utf-8?B?ZkJsenhyYnZDYkk4emtybm9VQmpNbnh5WERiUDJyMXBNejM0eXl2aFRNMmJJ?=
 =?utf-8?B?Vk10dUdLWTdiZjNxZitYenJhMDhXWXQvTTJzaFkzZS96WnVGTW1MYysyeXZz?=
 =?utf-8?B?RndEUlZKVDIwRWcvdmlsdkUySk9NR3VFRFEvM1gwOFFvVE1PL1V0V0Z4VUVO?=
 =?utf-8?B?bDExbkc2QWRlSVFxTjBpUEVENnpRRWNwOG8vRXBZcndsemVhK3pOSFFHY3BW?=
 =?utf-8?B?TkV5RC9Sd1pLZmt2YVFxaExBV0FpYWdES1Jtd1RGNWpDbWE4cGJtTHdZc1U3?=
 =?utf-8?B?K3M4NjFHWUkwVjlOTFZ6VGZjcDNjT3Zpc1hzMTVERzhDN2FuRW1LQXhWY0Fm?=
 =?utf-8?B?YWdITk9hb2tKYmJBSXJsSWNJaExSUU1BOHhuVUQwc1hndndvb0ZPNmtPY1E3?=
 =?utf-8?B?ZzZBMkNmTjZYeU1IbW8rWks0dDl6cXZHaUcyaks1bTRkQllTcHpoankxU0Vi?=
 =?utf-8?B?Q1EwYjRGcTBIcjVrQzZFVG0vOWs1ZUcrbytNMUQ3ay83WUppV3pVL1lPaVM3?=
 =?utf-8?B?OWpKVU9RM242TElJeGQxMTdSUG5FK21Jd2NJOUUySVJVRy91MHZIVmg4THNG?=
 =?utf-8?B?VnhRNU1iaXgrQjhxUitXdElXQkJZM05OWlZLcUM1MVY3YWpweDkvN1BVWVN6?=
 =?utf-8?B?Sk5PTjlXYlVpN0FEL0xVODcrcSt4OS9vQ2wwQlBkbHdneFg0cnNhRnNEOVNq?=
 =?utf-8?B?S0FLQ2ZxOUkwT2YzR1dEWWgxMDVDeWVPZEZPYkdRaXBZZFRCci9ydnU0NnUv?=
 =?utf-8?B?eTluU0lDRVBWYzFpU3JyalhxWnJCeHB0UURGMmQ3QWhIVVJla1FrOEp2Ynh4?=
 =?utf-8?B?WEpQenF1dHlqaXZpN1FiUzhGUk9WMkpBL2piMk4wZHp3eks2b0hhM1d4SzFD?=
 =?utf-8?B?VldOQ1E1NFkwbVF1MTJQbHFoejR6VktranBqbGNZcngwVjI3YUV4clFIMWZu?=
 =?utf-8?B?NU9iOG8xVzU3a3ViMWF5TC9kb2VQR2lMbFlJQWhLNXhtNyttUFEwY1BQYWg2?=
 =?utf-8?B?SDhrSHJZRy80OTY1ZU1tR1ZwUjJONzA5Q1V4ZXByczZYK3c9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzU4VzZOTlVUek5sTGhBUkszQW9pNmxWN0laWHBGSzhadEdjYm5KRWxPcFVu?=
 =?utf-8?B?VUhuRDdXYUtSSEVTTHFuNHJIWTF0dTRNbXp5MmdoTU44Um16TlZZZkdmV2cw?=
 =?utf-8?B?N1dHb04vRFRuYzQzYmJqaFpmbFZxeDh0VXZYZDhpNTIrSU8xMnVUamFtSFE1?=
 =?utf-8?B?SGFlRVdDcHQ1c09KcnVPcnVrVkR2K2xsWXJHZTRPMTlJSnZZbUhUcHdyemQv?=
 =?utf-8?B?RGc0MmxyYW5TUDFyc3J0Z0ZZQmxlbVJqTkhMaldQc2VuT0dYeHkwTEJlMlRK?=
 =?utf-8?B?cU0wR3FUMGcvcWN5ZGQ0empLSGQ4VVRydzh0WC9TZTJnZHVMcDBUeFVJeWlC?=
 =?utf-8?B?SWo5UGxSdE81Z0FxeDZiUlNZb1M2SUd4S0QxRTdLT0xDRWR6ZERlZkIzdlly?=
 =?utf-8?B?WFZLTmVwMTVNUjRtbmdHMSt3N3pKQ2VSa3RIbUdtcFBxZWhGMUFDTkFIanE1?=
 =?utf-8?B?VWpudHp3U0J3ZmhBL2t4Mk96T3dBT3NWT3ZKTUM4cjBBVm9FdGFqV3BtTUhi?=
 =?utf-8?B?bllTMUF5TDlreU9QMHYrQ3V1d01sQ3JETCtzOXQrQ0dyeE0ydzdZZ29jcHlk?=
 =?utf-8?B?Q0tHZ1NMRCtnR2JveDRCdS9EMVVzdW9GTXhVYnlidHVrWFpKcTl1RnNmQ0t0?=
 =?utf-8?B?YktTZzZFNVgrdjlJeDNHZFFSUTZVR2dnZnNYQ0Q3ZnJrdnVzUDlwZTRKTGpv?=
 =?utf-8?B?U0FINFFocVExZWtaQjBmQkNxUitzcUw2Vlg1cmJDaFlQZytXWVh1ZHFma3l4?=
 =?utf-8?B?RFdOVHRXaktuK1k2QXdxZ0NsS1BWS1F6T2QyaVNNRURWZHRPZnlzMjA3a1Jn?=
 =?utf-8?B?cFUzVlhuSk9yblBDTFowTDR3Vk10UFNvdU10YnpRM1VZYjZTelBjQWNoMlBK?=
 =?utf-8?B?ekdhWE5MWGNPeDlBM3BOb0tkNU1GTTZPMTNTM1FIWUZwY0lzODVnTEY4RUsw?=
 =?utf-8?B?TmVZdGwydVdqQTI2ZngzYXA2V3kycC9mQUJjV3VsTDd2SWRUM01neG0wOVYr?=
 =?utf-8?B?RjM0KzQxL0s4Um9QcWJENTJKZnNQeHczSCtneW5MVnZKckRyaUQ1Mlg2bVZC?=
 =?utf-8?B?RDBLc2J5RzNSQWFhNUxNaFMyT3RkM1F1d2JwWTVQY3NDQmNCZEFJYUl3NkNK?=
 =?utf-8?B?bll5YnlDUEQ5T1p2SzFWWXNwbDY4Q1VDZjgwL2JtUVpTeWFSdzlIOG9lV1ZU?=
 =?utf-8?B?bThTbjI0VmtmM3RxeUZkNFFiYWNWSnIzSU5zcVpyaUJ6Wkx1cU5YQ3lHSjh5?=
 =?utf-8?B?dVExRmhEaFlhZGxISktRdXJTMk1RbllYTXZhR1lQTlp5dW43RGQxUWs2aWlY?=
 =?utf-8?B?cDRSNnVTemo4VXdPT1NiaEsvdXViaGZPVGJKM1M2cm1YYnVLNVI5cmV6SHAv?=
 =?utf-8?B?NUllVCtrOUJhNGpZWnMxSE1HdHJnayt6cmJJSDc2TkxjVEVWb3FjbHk3bVQ3?=
 =?utf-8?B?cXY5MG5mR0dUVUFpZlk2YSt5WGRocmxZN3lkUW1WNDVTb1NwYTVQRjhCQU55?=
 =?utf-8?B?VHZvUmNWclJmZkRsZlZVSU5xUmMzNXVYUnI0L2ErMWlXNTBVRHJDeWlzK0ZB?=
 =?utf-8?B?VHZDMFAxWUNrSE50endNRXJOOXdYb1IxRk03cFZpdlUvNTV4ZFRSYTUvazd4?=
 =?utf-8?B?M3F3R1ZaSzJYNTR1cFlPZC9HM0VrNXlwN3dzUXBNZHNDcmVBZXVKdXJRdzl1?=
 =?utf-8?B?QjcvV0M1SjFqTnJ6TUZEQzRjTjNDaEtidUFFTDByN1pVYlJTUUNmOE90MWxS?=
 =?utf-8?B?SkhVbVFZeFgwTlVWUGhteWNyaTFpVlVIMWtwMDJkWWxuZ01adGlUZ3RUOTZr?=
 =?utf-8?B?Mnd2WlVoYmJxQUxGRmltajM0dVE3YTh2Nk5pVVQ0WE1BNGY0WHlYREZ4SkpS?=
 =?utf-8?B?MldjRGs2L1p5LzluV0szbmRjK0Rua21BMnhVaTA4bktwWHIrVmRNZTVud0VF?=
 =?utf-8?B?ekRpWUtDTU1MQzBxWEgwbjFxcGcrQXRPai9tNkV0L3dzWjN5YzU2NjFKa0NC?=
 =?utf-8?B?YjdxY1pZd0xjQkZuNVpuRDlITy9RYnJ1UFRqenpPSHM2UU9KcXZsNVJBZzhi?=
 =?utf-8?B?b1dVdEVwS1FlRzJVRUVaQWRiMHBXejFvNzduTGhYOXFnMmJMTklOVzB5b3lC?=
 =?utf-8?B?NGcyRWNkbzVXSXFUeXJwZ3U4MjNCVVIzVWJzdjFMOHhJOTNBRUROM1dSTVNh?=
 =?utf-8?B?aVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <19704DB0CF45804A89851F44F550B5F7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b831ab5-6747-488d-a12f-08dd367aa9e0
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2025 22:11:02.0232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Gjgq0ZiirHMd2NXwNQNFNWEg1QipTltacW7ni8ULLQ7F5VvfimYT9XS5a0QgyhCIv/uwgq+niwjDgV5803sNNqtKs4gmXCsyuZMqLvMWwo4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7698
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTE1IGF0IDIwOjM2ICswMTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiBPbiAxLzE1LzI1IDIwOjE0LCBFZGdlY29tYmUsIFJpY2sgUCB3cm90ZToNCj4gPiBJdCBsb29r
cyBsaWtlIHlvdSBtaXNzZWQgdGhlc2UgYnVpbGQgaXNzdWVzIGFuZCBidWdzIGZyb20gdjI6DQo+
ID4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvwqANCj4gPiBrdm0vNjM0NTI3MjUwNmM1YmM3MDdm
MTFiNmY1NGM0YmQ1MDE1Y2VkY2Q5NS5jYW1lbEBpbnRlbC5jb20vDQo+ID4gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvwqANCj4gPiBrdm0vM2Y4ZmE4ZmM5OGI1MzJhZGQxZmYxNDAzNGMwYzg2OGNk
YmVjYTdmOC5jYW1lbEBpbnRlbC5jb20vDQo+IA0KPiBJIGRpZCwgSSdsbCB1cGRhdGUgdG9tb3Jy
b3cgYW5kIHJlcG9zdC4NCg0KSGV5LCBvbmUgbW9yZSB0aGluZywgd2UndmUgYmVlbiBzZWVpbmcg
c29tZSBjb21waWxlciBzZW5zaXRpdmUgd2FybmluZ3MgYWJvdXQNCnN0YWNrIGZyYW1lIHNpemUg
aW4gaW5pdF90ZHhfbW9kdWxlKCkgaW4gdGhlIGxhdGVzdCBrdm0tY29jby1xdWV1ZS4gVGhlIHN0
cnVjdA0KdGR4X3N5c19pbmZvIGlzIHRoZSBtYWluIHN0YWNrIGFsbG9jYXRlZCB2YXJpYWJsZSBp
biB0aGF0IGZ1bmN0aW9uLg0KDQpJbiB0aGlzIGNvbW1pdCAoeDg2L3ZpcnQvdGR4OiBSZWFkIGVz
c2VudGlhbCBnbG9iYWwgbWV0YWRhdGEgZm9yIEtWTSksIHN0cnVjdA0KdGR4X3N5c19pbmZvIGdl
dHMgZXhwYW5kZWQgYSBodWdlIGFtb3VudDoNCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3Nj
bS92aXJ0L2t2bS9rdm0uZ2l0L2NvbW1pdC8/aD1rdm0tY29jby1xdWV1ZSZpZD02NjkxYTQyYTI2
ODQ0MjQ3NTI2ZWQwOGFhMjFlZTc0OGE5NDljNDA4DQoNCg0KQW5kIGluIHRoaXMgbGF0ZXIgY29t
bWl0KEtWTTogVk1YOiBJbml0aWFsaXplIFREWCBkdXJpbmcgS1ZNIG1vZHVsZSBsb2FkKSwgdGhl
DQpzdGFjayBhbGxvY2F0ZWQgdmFyaWFibGUgaXMgbW92ZWQgdG8gYSBzdGF0aWMgYWxsb2NhdGlv
bjoNCmh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS92aXJ0L2t2bS9rdm0uZ2l0L2NvbW1p
dC8/aD1rdm0tY29jby1xdWV1ZSZpZD0zNGY3ODY2OTdiMzgyNzUwNzM5ZjhjNGUxM2ViYjNkYTM0
OGMzMDdjDQoNClNvIHRoZSBtb3ZlIG9mIHRoZSBhcmNoL3g4NiBwYXRjaGVzIGVhcmxpZXIgb3Bl
bnMgdXAgYSB3aW5kb3cgd2hlcmUsIGRlcGVuZGluZw0Kb24gY29tcGlsZXIgb3B0aW1pemF0aW9u
cywgdGhlIHN0YWNrIHNpemUgbWF5IGJlIDMzMDQgYW5kIHRyaWdnZXINCkNPTkZJR19GUkFNRV9X
QVJOIHJlbGF0ZWQgZXJyb3JzLg0KDQpUaGUgc29sdXRpb24gY291bGQgYmUgdG8gbW92ZSB0aGUg
ImFyY2gveDg2L3ZpcnQvdm14L3RkeC90ZHguYyIgcmVsYXRlZCBjaGFuZ2VzDQppbiB0aGUgc2Vj
b25kIHBhdGNoIHRvIGEgc2VwYXJhdGUgcGF0Y2ggYW5kIHB1dCBpdCBiZWZvcmUgdGhlIGZpcnN0
IG9uZSwgb3Igc3dhcA0KdGhlIG9yZGVyIG9mIHRoZSB0d28gcGF0Y2hlcy4gVGhlc2UgY2hhbmdl
cyBhcmUgYmVmb3JlIHRoZSBWTS92Q1BVIGNyZWF0aW9uDQpwYXRjaGVzLCBzbyBJIHRoaW5rIHRo
YXQgd291bGQgYmUgeW91ciBhcmVhLiBCdXQgbGV0IG1lIGtub3cgaWYgeW91IHdhbnQgdG8gZ2V0
DQphIGJpZ2dlciBwb3N0aW5nIGJhY2sgZnJvbSB1cyB0byBpbmNsdWRlIGl0IGFsbC4NCg==

