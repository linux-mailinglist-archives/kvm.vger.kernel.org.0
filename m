Return-Path: <kvm+bounces-15968-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EC918B2820
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 20:21:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C23A11C21342
	for <lists+kvm@lfdr.de>; Thu, 25 Apr 2024 18:21:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F148A14F13A;
	Thu, 25 Apr 2024 18:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BVqNIEm6"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63E8C37152
	for <kvm@vger.kernel.org>; Thu, 25 Apr 2024 18:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714069265; cv=fail; b=QxF0tN1ZqYJLPZsJLoW6QCUsMMqjL3dNTLSzzCyGr4kqIJmpFx5C22bO7qfh6heLJvEFgVTdFS8dYy4oEKYKk4ukIQoUJs7DzQLnxl90VdC9E49Lu3WFeibXf7tizxpaKbAeh8tTfI9VWMrIVcoFZLEEZGSV1afElNNrxshzJIs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714069265; c=relaxed/simple;
	bh=NJDojViHEfYPk7olNmCLaWMbhd0IpT+MkSt+MCwfQJA=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Zl7F5+eePiD6iMSj9/bCd06R+qT2TVtU4adl1NkLz4BsShrjwRXkPt3t1fl92QphKuTDGYxHguEtqCiUYOae05riEoMnFh0De6evOxPWfbNjsr/IdR0xwbP+qEutWdFlaREKDu29+sB2emfBA13MJtEYW8XguCSxfghliGNjrYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=BVqNIEm6; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714069263; x=1745605263;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NJDojViHEfYPk7olNmCLaWMbhd0IpT+MkSt+MCwfQJA=;
  b=BVqNIEm6oBY4Cqp33MRrEC94s215uXTdxk9BakxjHFnBWyx2QdJ2NbWp
   rLOWHbeeccL9/JfTIKWXl6ii0c0oyQ27ui+0lbKqxAHv4XZVkjRCNOMSv
   upb0B1NpSUP9sQ2oiMm8TRGZphwLUapSIDtokZUberlqwQnCE4NjI1nT6
   fHx6NPXo3/s4icWKRuGS+3OwPAHWjjoumZHQCH5SwDmmNU7F4O/ScorYH
   8ms1ceYJYIcKOEeMqhI15P/OZmLJaqVQFcmhpmtvrP2Jo/d2zlKCBUP9e
   1hN6C7MxWDlisS50chWSOPqnZW1KDODEN6mVD2hn/lHyO5XpuZWdKVbpL
   g==;
X-CSE-ConnectionGUID: C2PJ6oQfQyyoOOzBm7Dsow==
X-CSE-MsgGUID: zM3PeTYzTzathfhHXHb8vg==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="9995301"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="9995301"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 11:21:02 -0700
X-CSE-ConnectionGUID: jjYyqU3MSsKxfJOzAe7P3Q==
X-CSE-MsgGUID: JxkIhVsHSJezOEIxvxmqMw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25213517"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa008.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 25 Apr 2024 11:21:02 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 11:21:01 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Thu, 25 Apr 2024 11:21:01 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Thu, 25 Apr 2024 11:21:01 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Thu, 25 Apr 2024 11:21:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eAH/3rEEhF/EW235Q1gY3W27Gfh5ZJYldud9zA1wDK2y3CJI9TDHpqoY0jBpQlM20Vy4Y9/GHnCKLx+J3pdVKemxqzsAj4rFgVCAT1MQE+yTEi0Y8Pc2dkZc/scU19h0o5nQroNuYOcaPbs/9/YKGNSS2PEeAiJtizc6wvYe1nf8ESMd4tGYZzphGb4jYCpl+RoTqb8/11eIV/N6v2pMh9vumKl3GoPToVwNoZDIxQsRZwokJy5UPc6nShvFg94YujJkmISm1LS8s/SEvPeXFJc8T5N2VQHtIpmZnjnEo0bdlPnnlIAezStWTps3uVN833RIHlyjqEQcEK2zMua6Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NJDojViHEfYPk7olNmCLaWMbhd0IpT+MkSt+MCwfQJA=;
 b=Y+T6QtbuDAdRAIA6jQ3btYHvRkK73vISXgFVvspyXe5/Twb6h+XTIVvEJxKpzzRzxPJnmzqW8/7FQE//eCDXef6LffL3/rRliAejUkOqTo4LxN1CzLT169dlrUNS1yzCzmNUqe0omoy8cObXZNP9uTASPzh3ymnhDjVi9fPVPZA9D3bjiVPnRUY6eCTEQhl5I1rK6HK7NnVSvlY4KxyY7+JKQaDO131UnYm4FhDK0W1fVCGjzUoN6cT5xYylvaW1pZv9fF0ve7l0djmF+DYD5NA4xf3hIl3LHnd2zHy631QZHxgF2lTdDtHJOkVQpj9Z/EyDCVOgoUdFUOwn6btPOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CY8PR11MB7337.namprd11.prod.outlook.com (2603:10b6:930:9d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7519.22; Thu, 25 Apr
 2024 18:20:57 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::1761:33ae:729c:a795%5]) with mapi id 15.20.7519.023; Thu, 25 Apr 2024
 18:20:57 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "Li, Xiaoyao" <xiaoyao.li@intel.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
Thread-Topic: [RFC] TDX module configurability of 0x80000008
Thread-Index: AQHalmgoAfxgxP49QEefWZUch1OWdLF5GFQAgAAXAoCAAAekAIAAFtYA
Date: Thu, 25 Apr 2024 18:20:57 +0000
Message-ID: <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
References: <f9f1da5dc94ad6b776490008dceee5963b451cda.camel@intel.com>
	 <baec691c-cb3f-4b0b-96d2-cbbe82276ccb@intel.com>
	 <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
	 <ZiqL4G-d8fk0Rb-c@google.com>
In-Reply-To: <ZiqL4G-d8fk0Rb-c@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CY8PR11MB7337:EE_
x-ms-office365-filtering-correlation-id: 9f42bca0-31fa-45eb-f662-08dc655473fd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?VXVtVVRVZndZZkJ0RVcwaldLR1U3N2hKRC84d2Z1TnV2OEVDYlJQNk9vUHZM?=
 =?utf-8?B?MUgwWFh5dzhwQ0dENU5LRi9uOFRVWnhTQW95SzhDaXExTjRFWlR6RVI0RVpa?=
 =?utf-8?B?MG1aTCtLWG03eklDTnJ1TmlHK3hQdHo3TkJqZ3NqWUFlMTRJNWpJSnFBdlhN?=
 =?utf-8?B?cWZ3czUweFErbFpHRE9FRTRJMVZ5YmRBL0FkSEY5VmhjTkxRcHM3OHk3M0R0?=
 =?utf-8?B?YXl0MjFiY0dxRmdmaFJUTkVkbjFzVjJrMHF5aFYyTjNPRlhnMTRONzg4aXNZ?=
 =?utf-8?B?WWlPNXJHbCsrWGZkYVBBYklLZThWenk4eGxEWGo5WEpzbllGVmpMcld5ZCt0?=
 =?utf-8?B?MTdZbERyK3dxUFhLaTFzZEV6c1dORnd1dGkrakdMenQyM0JKRWE4cjR6cW9h?=
 =?utf-8?B?TjlyQWpVNlUxMWc2ZnhBMC9qb1hOWUwva3VndHk2S1FiOVkrQ1V4WGRjb05n?=
 =?utf-8?B?WFhFYmFPa2N2cXhyTm9sWExSay94c3lwRDh5aTVUcVp5bDlBZlFibDN1dDBp?=
 =?utf-8?B?aWFJcjhUY0Q1aktMY29Ka2ZuV3A3V2FiSmNnMThNU2ExYUdyOEE0T29uOXov?=
 =?utf-8?B?K3FQRDdMaGx0RW9ObDR6N3V4aWg5Q3VMdWhpMmltdGVPQkd4NkFxRURUa1JU?=
 =?utf-8?B?bWRpWUxUQ09taUtqOTNTUVlQNDMyN0R0OVM0R09FQ05HVEZHSFhZZHppcm95?=
 =?utf-8?B?bS85akpBbmtsL3ZleXlISmlEMlhNRW1McHkyc3RjR3p5MmNxeS9EK3pOSXZk?=
 =?utf-8?B?UGZadTNnZHFLOC93NWN4cnNTazRpTlE5bHJKbHhXTGRRL0Qrc0hkcFlzQkFK?=
 =?utf-8?B?dGs3K1F6bEJvYlBFQWljUmp2K2ljNVh5SEtINWlMU2pyM25nSllmbVNucThS?=
 =?utf-8?B?VW5nZ2FMRFBIWDhLVjM3Z0x5dGtUcFM5d2syM1puOVRkWDM4aXZuMm10eitj?=
 =?utf-8?B?OUp1M2xlNk9GY000Wi85NkpqQkErTUVDN2h3YjYwWmVtL1V0eXZNWDBsWTBT?=
 =?utf-8?B?UW5Vd091S3VhY1ZhYTFlRVJlL21YRDE3dFFFZ0xtS1I2NW9PUmd3UlRHYlVN?=
 =?utf-8?B?ZThZSC9LTE5MK3RLUUh2em9qVmo2T2FyMmZVY09Hc0x5cUtjaUlvZTVVRlpP?=
 =?utf-8?B?cURVZ01FaTdlY21kdVJwclZ1Sk1iRVRKMlBkbHZGWGgxdFB2QktGa0ppYVhL?=
 =?utf-8?B?Ui9DbTQxZ09EU0cvZ0NmdGtyL2VYUVdQV1RETUhyU1N5ZG5kMlFTK2lHeDI5?=
 =?utf-8?B?NGhVNmVFTndkZkUvdjhyVmNQeHV6ZWRLd0lncGVlNGlCV3NDd25NSENVVHdr?=
 =?utf-8?B?eTZLcTNnZEFFZHpOUUtJbHByQVJaWmxPeStMTEs2cy9ZbGl3eHlzaUt0eU9C?=
 =?utf-8?B?cDE1Q3IzUkd3RVZFazRCQlNBWWxaai9ZUXd5ZkZqOGtJWDhmNm0rVTdkZktm?=
 =?utf-8?B?Tk9RTkZjcFdNOEhRRCt2Mkd4SWp1TURYeVJWYUd2b0sxQi9PMHFSODZIU1dC?=
 =?utf-8?B?ajlrRmsvNXFyRTByd003NTkvbXdUK0F4YlpHSHkyM3FDSlBYVW53M3plT1k0?=
 =?utf-8?B?bEgxbUJIcndlRGxZS2crZDA4MGZKWjV4cU5UQ25LeGZGd2xUTk1idFNoTWwx?=
 =?utf-8?B?dHpueFFMVCtPRFk5ZlFMV21sbVI0cDlFUGN4d0VxK2YyTWljNmNZMm5IU3p3?=
 =?utf-8?B?ZmsvTGRyaS82d29pSUFqQS9xVFQ3eDVOdDJZZ2RkQy9GRkNjT2NieHV6OERP?=
 =?utf-8?B?d1Y5a2dKdE5tc1BHQlJHa0FQOUgzSmtaZi9mZTNFZTVhTFdmNlVtNGg5THgv?=
 =?utf-8?B?YSsySXNHeVRFalZ0anh4dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V0FsR2dvK2JQTkl5VlVzUjRqSVZ0cHlubmVMOWtUUklheXFkYXVpYkUzTHZU?=
 =?utf-8?B?Qzd1ODNXcG1LYTdOWXlHbHZFdmlOZks2dUNJOUZFN3hiOXgzSGU5cUdOVlJH?=
 =?utf-8?B?OTFLNHJWbDljRXFaZWprMXpOWEIrdW02dkVxMk5qQ0p5ZkxRQ2tXWGR1V1o4?=
 =?utf-8?B?TlpCQ21waFB0b0tKc3VNMjBhSmpZV1hHN3NxZ1ZXUzE0c09YRGllV2R2Y1Z4?=
 =?utf-8?B?ejFOUUN4aDNFc1V4eTM5bTZtbEs5WVczYXBSbHhLSm0rN3JHYVlja21PZjVs?=
 =?utf-8?B?R2lhSExDRHFGUE01MmwraHNjaEw5M1VESGxKUTJJMllTUnBUbXQrVHQzRzdQ?=
 =?utf-8?B?OVJYckRIeDNjQlg2NTRNbHlBaWRqRzBDVzlKTCs5bVg5b2FJbjZScWVzbFk4?=
 =?utf-8?B?QUVJdkF5V2IvdVlLa0M4ZlJxazdsdnFhd0svVXFKVEloMmc1YzJDVDdrd0Yw?=
 =?utf-8?B?VHVxRURaeUhhcTlIbnZmWG5PRXVjRVhPbVUzaW5pcDBPRC9rMzh2ckdpMjI5?=
 =?utf-8?B?YXlxcndHalFGVkZIZkQwNkR2V3ZTcmpkcUErVmdxVVVuOHpHM0lQUEFuSGJz?=
 =?utf-8?B?azJWUmpxdWxIVnplSHNtM1VOdW1valFjRG9vV3VEUWlhTVJnUndjVTdCNDJ4?=
 =?utf-8?B?VTA3aFptMThOMXZ4aFp4d09VMVl2Qi9QU3lVckZqaEZyL2VHd3h2K1ZIV3U5?=
 =?utf-8?B?WXBwbks2VW1GMjdrT1RLc1VVdElXTHVlY2d4eXdhYTNVNElHakpWYU16d3Vi?=
 =?utf-8?B?d1liS1cwNjNSSnJMMkJXMzlSUDVPNXAzQzVwUGpncnVLMGF6R1IyQ2JXdjd4?=
 =?utf-8?B?R2dkNTVMWVhFcFVpSm8zWTZSSjhyYmV3THZ4RDRzWmNXeEp4d0hMdDVsSU5u?=
 =?utf-8?B?aGtEZUhPa1dlR1FDOVdPR0JnRFpBZk8rQVNER1o1dXlsOVFjRlVHMUdlVlFZ?=
 =?utf-8?B?VjZjYmVyeHNjZUdKeWVzN294eEJMYkFUdjJDcDhsK0FZZEJlZy83YTVJS0dC?=
 =?utf-8?B?MCsxZnVvaU9XbFk1bC8rMnVZbm9oeUoxQVY0aTd5bnJNL2VVUWNxU3pvYlc5?=
 =?utf-8?B?ZVpEQVhQbDQ1RE9MVTNkNDMzN1lpVWJtc1dFTmcvSllhL3ZZUXJqYmlVY21N?=
 =?utf-8?B?c0lsL1JZSmVYVldTeTMweGVSTE8xVERuNTQzWFhQdXZRSW5YNUxHZ2xtN3FL?=
 =?utf-8?B?ejhFR2s0Tkx2M291TXBrNXZnNXJoUjVHdzRyYWVHY3k4ekhLdExxa0kzNWhC?=
 =?utf-8?B?R0ppbzM2dWpQWGdLRGx1cTFFT1dKTDV0bElzSVJBRVlMQTg4Y0JVNEVuclp5?=
 =?utf-8?B?T3Q2TXkwQ0pDRzhTVU82QTJjWnRZWm9FWWJzbFBoNmhMWE9hUzNXZE5KckdN?=
 =?utf-8?B?U21uQzdJREtHY0J4TFlJZ3JoL3hnNG92T0diLzZHM2xwUXlOSzdtWHVmWTl4?=
 =?utf-8?B?YVVkTzViNERlWVpTakVsb3FQSzVrUUliMXAzT1VhVVF4QjZzMlJrOUJWaU1s?=
 =?utf-8?B?S0VTdTIrRHE3NEtVNm0vR2M4TldYVnZTRG1tR1ZINEZZZ1F0OXVyWFFBQnZl?=
 =?utf-8?B?bEhZSitTQitNNXg3Ym5RU0tXL2lrRVpOeGkreEZOMDR3NkR3RjFrdG1DcG9u?=
 =?utf-8?B?N092WlE5V2tybEN5NE10RjVzN0dWY1I0YW16eStSNXozVTFoemJlWjdLdnBW?=
 =?utf-8?B?QUpxdCs4cHN2QmNOWnpJOGVwdkl5N1BHa0ttZ2JlSFc3eURuRnlLZ1BxWDVQ?=
 =?utf-8?B?QmNSbUIvQXJXdHE2SmdIYmNKdWpjeUpQY3Y3VkhLVEw5ZWJzMlhPQU90QjI5?=
 =?utf-8?B?V1ZWdVZGMVI2MzhzdTZKanlOUU9jdWE1czBhcXVBNWlJakkxaGFkUmdVdzNH?=
 =?utf-8?B?dHh3KzZpVUh6cGdzMlpmbmdEdGlXN0JMcGYrZVVTeC9XZ3NRNEl5VDl5WFJW?=
 =?utf-8?B?OTNnQUpvaTZkTTlDcGJZdytsTUpDYlRpY2xBZjExVkc4WkxLRWp1clMzaGp6?=
 =?utf-8?B?QU5aTExJdXRSYUZZL0Q1L2QwaGRmajRQMk80c1AzbGpUbENOb3IvNzhyU2JJ?=
 =?utf-8?B?Szhha1c5d0c3S2ZXWnV1UmdYYnFISmpHZjkyTktyQytPSWRveTVwaGpQT0RP?=
 =?utf-8?B?SnBmbFNFcGhwaGR1Q2pRMDlHV3lpK2NGS0RaeFVZYkJSNloreWlBczA5d1NB?=
 =?utf-8?Q?5bZLrWAyFpaQbDERctzlDvk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <66E7EBCA8EBB664E804E7A7022F92208@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f42bca0-31fa-45eb-f662-08dc655473fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2024 18:20:57.7368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: m1XOoolPt7blPCtoAqi21jawjInrDFOOBfoGLqMaqi9PJzaLIaMkDUbsK4sHyZghTHWhobkDOlS1ajcnmVYKJFH/OCm6nyWdPZZ86gxnBJo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7337
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDA5OjU5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IElmIHdlIGxpbWl0IG91cnNlbHZlcyB0byB3b3JyeWluZyBhYm91dCB2YWxpZCBj
b25maWd1cmF0aW9ucywNCj4gDQo+IERlZmluZSAidmFsaWQgY29uZmlndXJhdGlvbnMiLsKgIA0K
DQpJIG1lYW50IGNvbmZpZ3VyYXRpb25zIHdpdGggbm8gbWVtc2xvdHMgYWJvdmUgZ3Vlc3QgbWF4
IHBhLiBJZiB0aGVyZSBhcmUNCm1lbXNsb3RzIGluIHRoYXQgcmVnaW9uLCBJIGRvbid0IGtub3cu
IE1heWJlIHZhbGlkIGlzIHRoZSB3cm9uZyB3b3JkLg0KDQo+IA0KPiA+IGFjY2Vzc2luZyBhIEdQ
QSBiZXlvbmQgWzIzOjE2XSBpcyBzaW1pbGFyIHRvIGFjY2Vzc2luZyBhIEdQQSB3aXRoIG5vDQo+
ID4gbWVtc2xvdC4NCj4gDQo+IE5vLCBpdCdzIG5vdC7CoCBBIEdQQSB3aXRob3V0IGEgbWVtc2xv
dCBoYXMgKnZlcnkqIHdlbGwtZGVmaW5lZCBzZW1hbnRpY3MgaW4NCj4gS1ZNLA0KPiBhbmQgS1ZN
IGNhbiBwcm92aWRlIHRob3NlIHNlbWFudGljcyBmb3IgYWxsIGd1ZXN0LWxlZ2FsIEdQQXMgcmVn
YXJkbGVzcyBvZg0KPiBoYXJkd2FyZSBFUFQvTlBUIHN1cHBvcnQuDQoNClNvcnJ5LCBub3QgZm9s
bG93aW5nLiBBcmUgd2UgZXhwZWN0aW5nIHRoZXJlIHRvIGJlIG1lbXNsb3RzIGFib3ZlIHRoZSBn
dWVzdA0KbWF4cGEgMjM6MTY/IElmIHRoZXJlIGFyZSBubyBtZW1zbG90cyBpbiB0aGF0IHJlZ2lv
biwgaXQgc2VlbXMgZXhhY3RseSBsaWtlDQphY2Nlc3NpbmcgYSBHUEEgd2l0aCBubyBtZW1zbG90
cy4gV2hhdCBpcyB0aGUgZGlmZmVyZW5jZSBiZXR3ZWVuIGJlZm9yZSBhbmQNCmFmdGVyIHRoZSBp
bnRyb2R1Y3Rpb24gb2YgZ3Vlc3QgTUFYUEE/ICh0aGVyZSB3aWxsIGJlIG5vcm1hbCBWTXMgYW5k
IFREWA0KZGlmZmVyZW5jZXMgb2YgY291cnNlKS4NCg0KPiANCj4gPiBMaWtlIHlvdSBzYXksIFsy
MzoxNl0gaXMgYSBoaW50LCBzbyB0aGVyZSBpcyByZWFsbHkgbm8gY2hhbmdlIGZyb20gS1ZNJ3MN
Cj4gPiBwZXJzcGVjdGl2ZS4gSXQgYmVoYXZlcyBsaWtlIG5vcm1hbCBiYXNlZCBvbiB0aGUgWzc6
MF0gTUFYUEEuDQo+ID4gDQo+ID4gV2hhdCBkbyB5b3UgdGhpbmsgc2hvdWxkIGhhcHBlbiBpbiB0
aGUgY2FzZSBhIFREIGFjY2Vzc2VzIGEgR1BBIHdpdGggbm8NCj4gPiBtZW1zbG90Pw0KPiDCoA0K
PiBTeW50aGVzaXplIGEgI1ZFIGludG8gdGhlIGd1ZXN0LsKgIFRoZSBHUEEgaXNuJ3QgYSB2aW9s
YXRpb24gb2YgdGhlICJyZWFsIg0KPiBNQVhQSFlBRERSLA0KPiBzbyBraWxsaW5nIHRoZSBndWVz
dCBpc24ndCB3YXJyYW50ZWQuwqAgQW5kIHRoYXQgYWxzbyBtZWFucyB0aGUgVk1NIGNvdWxkDQo+
IGxlZ2l0aW1hdGVseQ0KPiB3YW50IHRvIHB1dCBlbXVsYXRlZCBNTUlPIGFib3ZlIHRoZSBtYXgg
YWRkcmVzc2FibGUgR1BBLsKgIFN5bnRoZXNpemluZyBhICNWRQ0KPiBpcw0KPiBhbHNvIGFsaWdu
ZWQgd2l0aCBLVk0ncyBub24tbWVtc2xvdCBiZWhhdmlvciBmb3IgVERYIChjb25maWd1cmVkIHRv
IHRyaWdnZXINCj4gI1ZFKS4NCj4gDQo+IEFuZCBtb3N0IGltcG9ydGFudGx5LCBhcyB5b3Ugbm90
ZSBhYm92ZSwgdGhlIFZNTSAqY2FuJ3QqIHJlc29sdmUgdGhlIHByb2JsZW0uwqANCj4gT24NCj4g
dGhlIG90aGVyIGhhbmQsIHRoZSBndWVzdCAqbWlnaHQqIGJlIGFibGUgdG8gcmVzb2x2ZSB0aGUg
aXNzdWUsIGUuZy4gaXQgY291bGQNCj4gcmVxdWVzdCBNTUlPLCB3aGljaCBtYXkgb3IgbWF5IG5v
dCBzdWNjZWVkLsKgIEV2ZW4gaWYgdGhlIGd1ZXN0IHBhbmljcywgdGhhdCdzDQo+IGZhciBiZXR0
ZXIgdGhhbiBpdCBiZWluZyB0ZXJtaW5hdGVkIGJ5IHRoZSBob3N0IGFzIGl0IGdpdmVzIHRoZSBn
dWVzdCBhIGNoYW5jZQ0KPiB0byBjYXB0dXJlIHdoYXQgbGVkIHRvIHRoZSBwYW5pYy9jcmFzaC4N
Cj4gDQo+IFRoZSBvbmx5IGRvd25zaWRlIGlzIHRoYXQgdGhlIFZNTSBkb2Vzbid0IGhhdmUgYSBj
aGFuY2UgdG8gImJsZXNzIiB0aGUgI1ZFLA0KPiBidXQNCj4gc2luY2UgdGhlIFZNTSBsaXRlcmFs
bHkgY2Fubm90IGhhbmRsZSB0aGUgImJhZCIgYWNjZXNzIGluIGFueSBvdGhlciB0aGFuDQo+IGtp
bGxpbmcNCj4gdGhlIGd1ZXN0LCBJIGRvbid0IHNlZSB0aGF0IGFzIGEgbWFqb3IgcHJvYmxlbS4N
Cg0KT2ssIHNvIHdlIHdhbnQgdGhlIFREWCBtb2R1bGUgdG8gZXhwZWN0IHRoZSBURCB0byBjb250
aW51ZSB0byBsaXZlLiBUaGVuIHdlIG5lZWQNCnRvIGhhbmRsZSB0d28gdGhpbmdzOg0KMS4gVHJp
Z2dlciAjVkUgZm9yIGEgR1BBIHRoYXQgaXMgbWFwcGFibGUgYnkgdGhlIEVQVCBsZXZlbCAod2Ug
Y2FuIGFscmVhZHkgZG8NCnRoaXMpDQoyLiBUcmlnZ2VyICNWRSBmb3IgYSBHUEEgdGhhdCBpcyBu
b3QgbWFwcGFibGUgYnkgdGhlIEVQVCBsZXZlbA0KDQpXZSBjb3VsZCBhc2sgdGhlIFREWCBtb2R1
bGUgdG8ganVzdCBoYW5kbGUgYm90aCBvZiB0aGVzZSBjYXNlcy4gQnV0IHRoaXMgbWVhbnMNCktW
TSBsb3NlcyBhIGJpdCBvZiBjb250cm9sIGFuZCBkZWJ1Zy1hYmlsaXR5IGZyb20gdGhlIGhvc3Qg
c2lkZS4gQWxzbywgaXQgYWRkcw0KY29tcGxleGl0eSBmb3IgY2FzZXMgd2hlcmUgS1ZNIG1hcHMg
R1BBcyBhYm92ZSBndWVzdCBtYXhwYSBhbnl3YXkuIFNvIG1heWJlIHdlDQp3YW50IGl0IHRvIGp1
c3QgaGFuZGxlIDI/IEl0IG1pZ2h0IGhhdmUgc29tZSBudWFuY2VzIHN0aWxsLg0KDQpBbm90aGVy
IHF1ZXN0aW9uLCBzaG91bGQgd2UganVzdCB0aWUgZ3Vlc3QgbWF4cGEgdG8gR1BBVz8gRWl0aGVy
IGVuZm9yY2UgdGhleQ0KYXJlIHRoZSBzYW1lLCBvciBleHBvc2UgMjM6MTYgYmFzZWQgb24gR1BB
Vy4NCg0K

