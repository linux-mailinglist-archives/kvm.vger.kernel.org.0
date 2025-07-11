Return-Path: <kvm+bounces-52075-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 1FD45B01026
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 02:25:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 06B5B1C45668
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 00:25:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5219BA33;
	Fri, 11 Jul 2025 00:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="friyDxUS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A6638B;
	Fri, 11 Jul 2025 00:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752193515; cv=fail; b=e9sSAEeN8orzyLw01DfjQN5NaW4f17tC2lyUkAmr7wI9HJTxip2fnKsECBloKXQtd008lw/p/Qfcz25e3LdpVRTOLCMs2nGE2NPviyBLM4cyB4OHmvWPQMW/IzFJlS1oFFmZJ/MkCUoVJjVf84B8DGVUuUTPGqIONjVXAOcFtVM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752193515; c=relaxed/simple;
	bh=Z9egoU5PSqkeI2cJHzgLcJr98ZkL3tjkZauVbVYC/TY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ljDKfNpD+pJ2U/LXGM3aENLm8AKsN0+2bQYVznQlL5AxoGsKB1bj+TjYNZbBXVDP+PytnJNZO5o9mUAD5EWhRjKceXXiq6uBynwU3DfDr6kKZhfWLa6hi/zVBW00gtjs9U3gRObSDcMF2OJP7OHi2tU4HFMjnBKq1ryIpbILJiI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=friyDxUS; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1752193513; x=1783729513;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Z9egoU5PSqkeI2cJHzgLcJr98ZkL3tjkZauVbVYC/TY=;
  b=friyDxUSOYewaVTvpCcQNtnXLp1WMYMiiMi9fIIx0xCo3mrNNrzQQgIz
   F7AHKiW/hXAO9P7XazZJxUC8B4B9VKBPHZhta7xZ2HLMo9VMKQdc1yMbt
   sEXa9O6iuCCRk2n0pqOwLqshDZ+3mPtWrWZMtsEhmhneNvxqyBEnA10B4
   D2fzlvwHXu/8rIpQE1OcjpYlyCGufmTwy9oJJgvQJCW4LXxE1uwEwsbpw
   u80hxl7ILnpVtgLeDFYMECPJPYj5BVRfNmbsmN2Ed0JGCgjF7l2TM+agy
   yQyUPI1AO11R0Q26s3A7//OGqjRxyW7My41IUozhjUSar1T35bZKtPBwj
   A==;
X-CSE-ConnectionGUID: 2cpEOcfqQy+jBhjk0OIq5A==
X-CSE-MsgGUID: 7xa4vAl1TbOqEgWnlb5IpA==
X-IronPort-AV: E=McAfee;i="6800,10657,11490"; a="53707599"
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="53707599"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 17:25:13 -0700
X-CSE-ConnectionGUID: BsVaFc/dSlKjVPtl32rTHA==
X-CSE-MsgGUID: L/EPQX7ySPCW2lJ42wP1ow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,302,1744095600"; 
   d="scan'208";a="156953121"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2025 17:25:12 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 17:25:11 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 10 Jul 2025 17:25:11 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (40.107.96.81) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 10 Jul 2025 17:25:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=WBI87qlIm9MsREgtJB9t1jg4sbJ9x9aH/NhBcDeiTISfGq4QiWlz69WQxAgxVSJFSBv9+2/GhMD0GiC96d29zd2uhpftsnmUhmwfZtIYzv3U+4wc7AMCmqgPdfpacTZbZ6S9o8zS6fIduojaGpqEH6oM01MZlSkumWUcEMAMrv2g+G9YmhFqc86lKGPZDtjzw/JxatEozmqneKXSWaYU9Jhtojq5Y4Am8kgrzwnc+Ud9uAzdjUVa2ZsXLd6vWWP1CtEf/ZeFEXSKNtRUFLusXB1R14PWUHiNuYr4BazIQx/cnuimv3M0IH7ctErpWch69asbIqK6Ipljwxx+qcglDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z9egoU5PSqkeI2cJHzgLcJr98ZkL3tjkZauVbVYC/TY=;
 b=orJ6Olniy0tIk0NSEfm/EWJs+taanqX4w5ji58H8/ZwGFoVcFEpyuhn8fBlKBJFU9V4AbPUtFnQHOZYHgUhfQ8s5SbTlA7zkTZuJs8lsRsUXdMZ/Jq5RkEb212QpB0fRhZ5qU+i1JQM7lxWKM8ri0uMOfNDnf2s/Ubt/LfSKZM6kI1Zow956W/KTWLLrgKUGb7DPIavxaojgnykzJ69RlbWvNIQZ9y0TwykNfBEXqLh/edbb8HWHLR1S5irSimyk1zwLS9dtiNgFSr3QUAsNqALXjHVnF1kbJ2jk9D3f89wuo7wOvk7nKBjse6pOanAtsZ06pzHq8AT8zbqHpCocyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by CH3PR11MB7723.namprd11.prod.outlook.com (2603:10b6:610:127::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8901.29; Fri, 11 Jul
 2025 00:24:26 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8901.023; Fri, 11 Jul 2025
 00:24:26 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Gao, Chao" <chao.gao@intel.com>
CC: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "bp@alien8.de"
	<bp@alien8.de>, "Li, Xiaoyao" <xiaoyao.li@intel.com>, "nikunj@amd.com"
	<nikunj@amd.com>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "Yamahata, Isaku" <isaku.yamahata@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Thread-Topic: [PATCH 2/2] KVM: x86: Reject KVM_SET_TSC_KHZ VM ioctl when vCPU
 has been created
Thread-Index: AQHb8JJNsvqII3I3Gk2c0fgebVez6LQpd12AgABZx4CAAiiBAIAAGYIA
Date: Fri, 11 Jul 2025 00:24:26 +0000
Message-ID: <2fa327b84b56c1abe00c4f713412bace722de44c.camel@intel.com>
References: <cover.1752038725.git.kai.huang@intel.com>
		 <1eaa9ba08d383a7db785491a9bdf667e780a76cc.1752038726.git.kai.huang@intel.com>
		 <aG4ph7gNK4o3+04i@intel.com> <aG501qKTDjmcLEyV@google.com>
	 <78614df5fad7b1deb291501c9b6db7be81b0a157.camel@intel.com>
In-Reply-To: <78614df5fad7b1deb291501c9b6db7be81b0a157.camel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|CH3PR11MB7723:EE_
x-ms-office365-filtering-correlation-id: 0ee57486-1cb7-4801-b0a3-08ddc0114b19
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SXovQU9VOUp4ZldrTmlzTlpmSXYxNE83Y3RTczhEMDY2V2Vndlp4ajR5Yzkv?=
 =?utf-8?B?VHlYamk0a0ErenJEK2xlbSt3OElCSVk0dE1YTlU5bTdHd3lZRmhTZFBTT1JJ?=
 =?utf-8?B?NjRVbHlBYmJ6TDRFMXR5dkZQcHVnVW12TjZPSy8xZ3NBd3AzbXEvdEtWTlJS?=
 =?utf-8?B?Mk9yN0FHTXZJdVZpOWExT1p3aVh3RmNhaXBUQUhJVFp6akFlam16dVlFaUZX?=
 =?utf-8?B?cytmVWd0RDFqN1M1MUkxOGkyWnh6N2t5UFBERzJtQkFaQ2d5dkR0YzhwZUVV?=
 =?utf-8?B?K3N4ZUtscFNyMitjZTNLNTJWcEczcC9xbzZqdkcwekl4R0tqcTVlMVROQlI2?=
 =?utf-8?B?MEE3OXpPMVNibk51d2tEM3EwaWZMWVJxWGRMWDkwWjhmRzEwenpsVWVQeTIy?=
 =?utf-8?B?NWJDTXBvTG4raW1VUEwrMnpZU0Vrd09yaEVMQXJHcy9HZVA3YjJUS3dnbHdM?=
 =?utf-8?B?NTQrSXh1dlUrMkJaeUhsc2tMME0vbFJuVFRZVHBpaGNFQ1NmaTluVm1qalNa?=
 =?utf-8?B?TnJXZDRaREc0cHNYY1ZudVZpTWJHQ3FwcCtnMHdBa3V2eS85dU85a0M1TFJ0?=
 =?utf-8?B?RW1tSzQ4K0d0MVZBRUZ4eWxCa2pIYTh1N2FhZno4NzZVQUwveVBxNDRKRlJV?=
 =?utf-8?B?ak1yRWM1MVhYQWtyOVpnVklqU2pheTRjZXJhSWFZbCtCL08rNENkTnYvVTAy?=
 =?utf-8?B?VlRsMGZ0WjQ1WE9abm9hSFVXSndkNnRpaGR4eVREUE8yUGh6bTdEU0NEQzZL?=
 =?utf-8?B?d3I4akcxeTFkNk9yb2R5OXRVQmhsdTh5dHlGVFRuVm4rWDBIeHQzMHRlOGxs?=
 =?utf-8?B?L2hsdHd3czhhekY3eGpOclJJa1VDaUlvYWxIOHRDT1NsMDRQU3Q4SVcva3hw?=
 =?utf-8?B?amFzQU4wYzJIMXZSdUNCVU9OcWc1YzZvRWdHdXBtd2UxUm9Wcm5QR2NHaFFm?=
 =?utf-8?B?OXlRekxycmozTXBwUXphcFpoa1RlUFFHejUwRVZsVWF1T2pOZlBzc3RReGpP?=
 =?utf-8?B?TlJMbU5zTmFnKzFWTitJa0lvWVdxMVVucmEwYmhEU3pIeWtxUXhZaVpRVVlJ?=
 =?utf-8?B?Mmd4cjdjQzBKUjhJdkhWK1Juc2RFNmt4aW5oN2dORXhuTUhpNkVVdVRUWkpS?=
 =?utf-8?B?OWtkYjJITXI4T1pybHZsb1lMVWVSdFJqcWx0T3BUZHBNY2JiK1dlWEtEbEhi?=
 =?utf-8?B?dFVtV0Zid2NYbG5TZk81U2txd3VGaGhqd3V0Z25QcGFCbE0yaVhhNHI1SVdS?=
 =?utf-8?B?NThtOHlOVHYza2tHZURJb1NLWDRqRzk5Y05PWFZyVmxiMkJJTk9CbitSd0g1?=
 =?utf-8?B?Y1pRMHNYTDljenc3bjgvMWRoSExDd0tGTHN1dlJkTnRuVmFLZzJ2YVJkSElo?=
 =?utf-8?B?VW5LeUZBbjQzZzJGN3V4aEJpNGxjTDZEREMxMVlSTzZjZndEbXd3VWNCcGRn?=
 =?utf-8?B?blJYT2JOR2ovcHdoeWIvbk9ZdEh2VWpkWHJ0Yk02RUpYaEhDQXpZeVZnTXdW?=
 =?utf-8?B?Z2l2NGsvaVdLaUJ0NnN2ZFpsV244bW4zRjlaODhPSWRKMkljVUJFVXBTT0hz?=
 =?utf-8?B?QjIzOWNVbzYvZ2ZDbVphZ0dMajZEenVlS3ZDRkZKRXpGM2hYQ1JINkxWZ25Z?=
 =?utf-8?B?QkFFamliMi9FdFNrSWJZRDV6ZHlGUUVvc2FITDNpbVd1cGJmZ09wOFk4SjFM?=
 =?utf-8?B?eG9vTXVoRlFwZXcvSys2M3FJUU51NGpFYXZOYWpGeUppVHdoaFVKWHZCNG5B?=
 =?utf-8?B?a20vUVJsRUJFc1dvVFIzS3dxcFIwVTN6ajJ5UGFsNGZLZW9qakREazYwelFG?=
 =?utf-8?B?bWtWZ0MxclZpTHBJSWR4L0t1VmYwV2lzYkxndlNKZXo1bjcwMUFZNDd3T1pR?=
 =?utf-8?B?SmdQL3p5ZzBMa1piaW9QVU9Rb0RHc2hZMUpESGJaLzlvQVNoSmt4QVJwcUxM?=
 =?utf-8?B?NTlVUjZyeFlvZUdIZlU2SHJGRlc0SmtGMHNkMnVidi8wWUV2QzRqa0J5Z2Vj?=
 =?utf-8?Q?0dBwk1vq1oPbIQQ0QhcPK3PfIYfrTo=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NmVvSmZQNmFYNHRmRzljb21MRnRxenFwS3dQcjB6TzZUancrWWp0OG05VFJz?=
 =?utf-8?B?RjJYUk1VNzBPVlVGYk1rdDdLMXVCV0xBQU5QSC84bVRQZHVCSVFhZ3VEVEFI?=
 =?utf-8?B?djg4aVhBSXJad0RZczlwZUxseHkyWVZjUk1TNEYzYnI0OU9kNExVTVI1Kzcz?=
 =?utf-8?B?bk4wSXcycWI0bmpPdlZhTkJ3ZG10MFc0aTg5OE1GTlQyL0txa1RBOTZDTGp3?=
 =?utf-8?B?LzNhZUdEcEh1SVJsNnBHUEtRWjdSaFQwclBxOHoxZWhkMjR0S3piVUtKWUxB?=
 =?utf-8?B?Q2V6RFJWUDQ5Y0NkNFVGaExkVVlNR1ViaUZCT1hhSnFUQXdsVUpENzdkVy9t?=
 =?utf-8?B?UTNvblZEeEE2cTVUS2NQdy9YSlNqcndJUkQvVU9QalUwZzdyZ0NKejZsOWhU?=
 =?utf-8?B?WkJ1TjkzVE1xNGUwUldqc2tQZzJpU09JeXBaZ05jUUFTTTZwM1ZIR1J3VTFS?=
 =?utf-8?B?TWJBU0JUejViSngwUVNOYks4RGxPWGRJQVpBZTgyT1UvaHExbVM0Uklkd1lV?=
 =?utf-8?B?V0ZxaXNJd281ZFlEWC9vcjdFNlpPY1FPZlVScnpOYXpNOG1tT3JpbXhubzIx?=
 =?utf-8?B?SlBXbURyNzNULy9TK2x1dGdJbXNOZUUvTmsrR09OK0pncElMZUhtNUdHYXlM?=
 =?utf-8?B?WFV0ZTA5WktSYW10SHMxdk13L0Y1QzNvTC96WmlnL1pyQ0NnazFNcU13OEgx?=
 =?utf-8?B?QXJ5Y01tTlhWRzBCYW02SGZjYVRGYXR5aHJ6d2c1cUpoT3NkOGJZS1FEbjZW?=
 =?utf-8?B?ckhINmhwSklQOEc1UjVFSnNHVTBSWjF4TEhTSFBiNW5PcXlmbWFUL2FJdFhh?=
 =?utf-8?B?aGhVYk9IQjlkSHVlMjRVekU5NlNUODJQMGFLZytnb05vWXR3cFFNWmRtc2x0?=
 =?utf-8?B?YzFBMTlBT1pibGVCU0lpUnBMWTdjalRmWHQ1ZytiWHFXN3pXbXgzQkl6d2Zh?=
 =?utf-8?B?VEg3TXl5aEdFcFY4YzVPMmwzcEpxc1kxWDRmZEpnY0VBQzVRb3k4S3hybkRx?=
 =?utf-8?B?T3lHQjNtbTFaeFlyekhCTnVJUHBkSTYwTllsOTFTL0EvWGtZUmlKYWh4RXJ6?=
 =?utf-8?B?NzhINVFodG16NUs5clprT2tsdlJoOSt1WFVTeWg3RjZkRjZ6UXV0VldrOXY3?=
 =?utf-8?B?OWFmYkdPcXFyUTVxMGRvdzB3N055cVJVdXhsYk51MnVKNjJGM2xQMjVNdTJk?=
 =?utf-8?B?K1VvNHJiVnIzeXMyKzhmNXdSY0lxbitLR3ZZSjF1blRjQzFFdTNWZkJSV2oy?=
 =?utf-8?B?bmpicXIvZDBUOGtuTjJOYVc1RzhQV2VYYW5Ublh1dit0RjNTWGk5bmVFUmY2?=
 =?utf-8?B?bkV1SHo1bnE3Z0tSWHpEQUFLUlNJS0RRbWJsN3U0VDdjSzMzQzJsS3h0NXlH?=
 =?utf-8?B?RHp2MjZqNFdNL25GclNrQU4yclFvSEFaZFdFbTZ6TDc2dTROblR5L0NBZ0hM?=
 =?utf-8?B?L1lJM1JzdG41N2VoM3NHZit6MVFxc1hTRnp4MndYTGk1Nm5GZmZpMWtPNFpo?=
 =?utf-8?B?UzE4bnJmVUVib3J6K0cxR0VNSzErT2xoTStpR3N6Um0wanV1WkkyQXZ3WHdM?=
 =?utf-8?B?bVEzSUhxN1NBQllPcjQzR0dPemVoVFhHVVp2elppc251VmkwSmpLWG8xSCtv?=
 =?utf-8?B?bmJCV24wTy9GVEdkRUpRYTFuZ1hBNTRCcWE4TXlrVUtmL0NCUmJUcXJGY2o4?=
 =?utf-8?B?Sm80am02a1NKWTBhWlhYOW80TTNGeHdTSEU4blU2SWpla2dqcXVmaVplQVJP?=
 =?utf-8?B?ZFIvNzhuSkNxTWVKZll2ZFR6dTNxQ0VpK0Fsa1dsWExYdjB1QkVjY1Bzenc1?=
 =?utf-8?B?Um96di9ZN3d2UWNxZ3h5cmVlOEtXWXZpcXVnR1RQcTA5NHVleElzbVhYVTg4?=
 =?utf-8?B?ZFZqU2ZSRzZHZXVKRjdPdWd6MzNzSXhuaUZhYzdYVERDZFlScHdQbzk2TDRw?=
 =?utf-8?B?ZDhNRWlBS2xEZG9kbVZmK2dhNW5NSi9oOUFkZ1M4Q3NIbU9DUWV4YXhxNlp4?=
 =?utf-8?B?dDBGM1RGVjhCN1UrY1F6QnZPQ25kRmpCVThvY2FTU055dTg4b21ZdzlMY0sv?=
 =?utf-8?B?VXdGYkR1QlpOSnEvelJ5M09pR3dKM3pTMFp4TU1jRnFkeFpWVE8wZi8zSkIz?=
 =?utf-8?Q?2pVsXhBVMAxaYP/OAf/79HCRE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2023E5C81A28EC4FA625DA3CDB9A39EE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ee57486-1cb7-4801-b0a3-08ddc0114b19
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2025 00:24:26.2808
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: y7TkPLPCh3aKiotTXqypwUhZDYJFoVmTIuUB8CYz0PZmRU87hsJxIDLKVj6mEeIxy3A5pNVYf9BL8ifY3HMHpA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7723
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTA3LTEwIGF0IDIyOjUzICswMDAwLCBIdWFuZywgS2FpIHdyb3RlOg0KPiBP
biBXZWQsIDIwMjUtMDctMDkgYXQgMDY6NTUgLTA3MDAsIFNlYW4gQ2hyaXN0b3BoZXJzb24gd3Jv
dGU6DQo+ID4gT24gV2VkLCBKdWwgMDksIDIwMjUsIENoYW8gR2FvIHdyb3RlOg0KPiA+ID4gT24g
V2VkLCBKdWwgMDksIDIwMjUgYXQgMDU6Mzg6MDBQTSArMTIwMCwgS2FpIEh1YW5nIHdyb3RlOg0K
PiA+ID4gPiBSZWplY3QgdGhlIEtWTV9TRVRfVFNDX0tIWiBWTSBpb2N0bCB3aGVuIHRoZXJlJ3Mg
dkNQVSBoYXMgYWxyZWFkeSBiZWVuDQo+ID4gPiA+IGNyZWF0ZWQuDQo+ID4gPiA+IA0KPiA+ID4g
PiBUaGUgVk0gc2NvcGUgS1ZNX1NFVF9UU0NfS0haIGlvY3RsIGlzIHVzZWQgdG8gc2V0IHVwIHRo
ZSBkZWZhdWx0IFRTQw0KPiA+ID4gPiBmcmVxdWVuY3kgdGhhdCBhbGwgc3Vic2VxdWVudCBjcmVh
dGVkIHZDUFVzIHVzZS4gIEl0IGlzIG9ubHkgaW50ZW5kZWQgdG8NCj4gPiA+ID4gYmUgY2FsbGVk
IGJlZm9yZSBhbnkgdkNQVSBpcyBjcmVhdGVkLiAgQWxsb3dpbmcgaXQgdG8gYmUgY2FsbGVkIGFm
dGVyDQo+ID4gPiA+IHRoYXQgb25seSByZXN1bHRzIGluIGNvbmZ1c2lvbiBidXQgbm90aGluZyBn
b29kLg0KPiA+ID4gPiANCj4gPiA+ID4gTm90ZSB0aGlzIGlzIGFuIEFCSSBjaGFuZ2UuICBCdXQg
Y3VycmVudGx5IGluIFFlbXUgKHRoZSBkZSBmYWN0bw0KPiA+ID4gPiB1c2Vyc3BhY2UgVk1NKSBv
bmx5IFREWCB1c2VzIHRoaXMgVk0gaW9jdGwsIGFuZCBpdCBpcyBvbmx5IGNhbGxlZCBvbmNlDQo+
ID4gPiA+IGJlZm9yZSBjcmVhdGluZyBhbnkgdkNQVSwgdGhlcmVmb3JlIHRoZSByaXNrIG9mIGJy
ZWFraW5nIHVzZXJzcGFjZSBpcw0KPiA+ID4gPiBwcmV0dHkgbG93Lg0KPiA+ID4gPiANCj4gPiA+
ID4gU3VnZ2VzdGVkLWJ5OiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4N
Cj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogS2FpIEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0K
PiA+ID4gPiAtLS0NCj4gPiA+ID4gYXJjaC94ODYva3ZtL3g4Ni5jIHwgNCArKysrDQo+ID4gPiA+
IDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykNCj4gPiA+ID4gDQo+ID4gPiA+IGRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rdm0veDg2LmMgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiA+ID4g
aW5kZXggNjk5Y2E1ZTc0YmJhLi5lNWU1NWQ1NDk0NjggMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL2Fy
Y2gveDg2L2t2bS94ODYuYw0KPiA+ID4gPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gPiA+
ID4gQEAgLTcxOTQsNiArNzE5NCwxMCBAQCBpbnQga3ZtX2FyY2hfdm1faW9jdGwoc3RydWN0IGZp
bGUgKmZpbHAsIHVuc2lnbmVkIGludCBpb2N0bCwgdW5zaWduZWQgbG9uZyBhcmcpDQo+ID4gPiA+
IAkJdTMyIHVzZXJfdHNjX2toejsNCj4gPiA+ID4gDQo+ID4gPiA+IAkJciA9IC1FSU5WQUw7DQo+
ID4gPiA+ICsNCj4gPiA+ID4gKwkJaWYgKGt2bS0+Y3JlYXRlZF92Y3B1cykNCj4gPiA+ID4gKwkJ
CWdvdG8gb3V0Ow0KPiA+ID4gPiArDQo+ID4gPiANCj4gPiA+IHNob3VsZG4ndCBrdm0tPmxvY2sg
YmUgaGVsZD8NCj4gPiANCj4gPiBZZXAuDQo+IA0KPiBNeSBiYWQuICBJJ2xsIGZpeHVwIGFuZCBz
ZW5kIG91dCB2MiBzb29uLCAgdG9nZXRoZXIgd2l0aCB0aGUgZG9jIHVwZGF0ZS4NCg0KU29ycnkg
Zm9yIG11bHRpcGxlIGVtYWlscywgYnV0IEkgZW5kZWQgdXAgd2l0aCBiZWxvdy4NCg0KQUZBSUNU
IHRoZSBhY3R1YWwgdXBkYXRpbmcgb2Yga3ZtLT5hcmNoLmRlZmF1bHRfdHNjX2toeiBuZWVkcyB0
byBiZSBpbiB0aGUNCmt2bS0+bG9jayBtdXRleCB0b28uICBQbGVhc2UgbGV0IG1lIGtub3cgaWYg
eW91IGZvdW5kIGFueSBpc3N1ZT8NCg0KZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vdmlydC9r
dm0vYXBpLnJzdA0KYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCmluZGV4IDQzZWQ1
N2UwNDhhOC4uODZlYTFlMmIyNzM3IDEwMDY0NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi92aXJ0L2t2
bS9hcGkucnN0DQorKysgYi9Eb2N1bWVudGF0aW9uL3ZpcnQva3ZtL2FwaS5yc3QNCkBAIC0yMDA2
LDcgKzIwMDYsNyBAQCBmcmVxdWVuY3kgaXMgS0h6Lg0KDQogSWYgdGhlIEtWTV9DQVBfVk1fVFND
X0NPTlRST0wgY2FwYWJpbGl0eSBpcyBhZHZlcnRpc2VkLCB0aGlzIGNhbiBhbHNvDQogYmUgdXNl
ZCBhcyBhIHZtIGlvY3RsIHRvIHNldCB0aGUgaW5pdGlhbCB0c2MgZnJlcXVlbmN5IG9mIHN1YnNl
cXVlbnRseQ0KLWNyZWF0ZWQgdkNQVXMuDQorY3JlYXRlZCB2Q1BVcy4gIEl0IG11c3QgYmUgY2Fs
bGVkIGJlZm9yZSBhbnkgdkNQVSBpcyBjcmVhdGVkLg0KDQogNC41NiBLVk1fR0VUX1RTQ19LSFoN
CiAtLS0tLS0tLS0tLS0tLS0tLS0tLQ0KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS94ODYuYyBi
L2FyY2gveDg2L2t2bS94ODYuYw0KaW5kZXggMjgwNmY3MTA0Mjk1Li40MDUxYzBjYWNiOTIgMTAw
NjQ0DQotLS0gYS9hcmNoL3g4Ni9rdm0veDg2LmMNCisrKyBiL2FyY2gveDg2L2t2bS94ODYuYw0K
QEAgLTcxOTksOSArNzE5OSwxMiBAQCBpbnQga3ZtX2FyY2hfdm1faW9jdGwoc3RydWN0IGZpbGUg
KmZpbHAsIHVuc2lnbmVkDQppbnQgaW9jdGwsIHVuc2lnbmVkIGxvbmcgYXJnKQ0KICAgICAgICAg
ICAgICAgIGlmICh1c2VyX3RzY19raHogPT0gMCkNCiAgICAgICAgICAgICAgICAgICAgICAgIHVz
ZXJfdHNjX2toeiA9IHRzY19raHo7DQoNCi0gICAgICAgICAgICAgICBXUklURV9PTkNFKGt2bS0+
YXJjaC5kZWZhdWx0X3RzY19raHosIHVzZXJfdHNjX2toeik7DQotICAgICAgICAgICAgICAgciA9
IDA7DQotDQorICAgICAgICAgICAgICAgbXV0ZXhfbG9jaygma3ZtLT5sb2NrKTsNCisgICAgICAg
ICAgICAgICBpZiAoIWt2bS0+Y3JlYXRlZF92Y3B1cykgew0KKyAgICAgICAgICAgICAgICAgICAg
ICAgV1JJVEVfT05DRShrdm0tPmFyY2guZGVmYXVsdF90c2Nfa2h6LA0KdXNlcl90c2Nfa2h6KTsN
CisgICAgICAgICAgICAgICAgICAgICAgIHIgPSAwOw0KKyAgICAgICAgICAgICAgIH0NCisgICAg
ICAgICAgICAgICBtdXRleF91bmxvY2soJmt2bS0+bG9jayk7DQogICAgICAgICAgICAgICAgZ290
byBvdXQ7DQogICAgICAgIH0NCiAgICAgICAgY2FzZSBLVk1fR0VUX1RTQ19LSFo6IHsNCg==

