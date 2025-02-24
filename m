Return-Path: <kvm+bounces-38990-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7634EA41E24
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 13:02:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DCE4A3A18F5
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 11:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F270260A5E;
	Mon, 24 Feb 2025 11:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="U8Qh68+b"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB472192E5;
	Mon, 24 Feb 2025 11:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740397139; cv=fail; b=beVxiU1GKH7GZ2B56OsALsdAY2O2HJ2shmK8zeXBArM3FffURLehiBQ81p1K2y87gyEFxFd4LIR9xklMPA9qfrrWF8afPvmgXBOJ0CUlgJHkpiEhx/X0ySPvM5oJPwcfwLtmt4CtRYqC53AoJEx11v234L5XFFjur+zaBDoWRgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740397139; c=relaxed/simple;
	bh=Qqvf+6NSqAOmk4TvJhqQleULmwBqIs0qxxIC14EHGl0=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=fec5YGGMwqZ+20uScgUPaCxf5QBYYOz+kjUFDW54ztm52ubel6XyDFEudjV2lTjnHvqW3NXtK1ZJtArpZ7hKaBpQi0M5e1I0C6aA97fNCcNAWzzuXhfcfRykgtfTgM2oel3HtFvAtpNcvWYb1xXtwqMUwIQkwj35HqTqsQ/9l5I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=U8Qh68+b; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740397137; x=1771933137;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qqvf+6NSqAOmk4TvJhqQleULmwBqIs0qxxIC14EHGl0=;
  b=U8Qh68+bSzzPsONNYDSTKACTrHwEdieOSOmC7BoEBOshUUDhGMfmzcFs
   4t3N0z+tGVQ/6TrvrG22uiRunuBIHBcwHjCuiCmNMDWKZi1Ynppm/6dcL
   NDFy0ErJBKXNyFaBShSKr1zryWze+uG3o/Whef8aUF5OPJEnvqCmh5WMK
   LAlJrROaIUV/YhbpEMg+JoCwBbZyU35wqUlm8BZ8KmqqYhcG0uJtHp8NF
   FsS4mv09QNTHB7AeQbFH3uCyQwctI4+UuZkrpj0ro6vsj/GHmQ1ixHZ21
   S867RxxKuOX8XALwphPhFzIujl26LNOCUaFcEJm3++wiz9KsIZrxK/35b
   A==;
X-CSE-ConnectionGUID: jDikmv9AT2erkX2fqiehHQ==
X-CSE-MsgGUID: mN+pmVeiQTmWkeyEeicOfg==
X-IronPort-AV: E=McAfee;i="6700,10204,11354"; a="66519034"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="66519034"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2025 03:38:54 -0800
X-CSE-ConnectionGUID: r6NXd4NCQmuXH44bBohxJA==
X-CSE-MsgGUID: Y8ixK9M6RKOriJwdvT6X+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="146885631"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 24 Feb 2025 03:38:55 -0800
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 24 Feb 2025 03:38:54 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Mon, 24 Feb 2025 03:38:54 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.47) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 24 Feb 2025 03:38:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=dvpaByVWJJQ3dvj6fHS7UaeROdvwZxbaWGAdvbsr72dxBhI17ql8Hz+LTGeV0ob4YAAVsE04gFwc1c5iNku8rCzz7Sd8un1zYoB+mLy4gMd3Ri5/CTM/a477J8mDBsCZnObPTuiZ4aycvMwPrTBz/Ownydi33De6g5yJlUOumPLVPvJhr3k1XGT2kLlc+opmNYPCC8ZKUyr9bNClDsIh6dZaoQSgiHmnVY2PSrvTUDbstp3MKy7hZPsi+ACyKyChkzhKC5REX263WU5P3Mw/4CPT1v7tPrPmvPCIMCDMphqO2EfmJpDis9bYfCKpdJDa3lBL1y7dp6TJIytAybfgaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sxtaGZGmA+uSSvDl6sSffrAhbZp44puzW/udaPFupi0=;
 b=PfXf8AXuWTsLBMXtXdfasPS4h4DD13nJhiGgz7R4Lwvt1BwtJ+860jKA6qyW0DXoEixrjQHCyZzCMZPtOELQVtZnrXVC7I8PeV/bXPF9CLwL6LuMImG4HaJCoRpHEOVPXOEKh+ieHXf5COGvZIylrq7Jb8rt7k/8zsuAQ99YVMfbS28qSp86i6OMlIUOgH/EwjmOs0FYk2+j1GrUvw96/UuTzApncc+0kLnuq3BDlgltg3dCe10a+7baI+vjYwv8PV+l1kDkZMAUxkrwU0wl+GVXeGgMXvSHH2ByT+lHsvpDtRWJkXca0kQ/foTBcksN+sAnlAI2F5MSznhceilz9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3605.namprd11.prod.outlook.com (2603:10b6:a03:f5::33)
 by DS7PR11MB6150.namprd11.prod.outlook.com (2603:10b6:8:9d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.20; Mon, 24 Feb
 2025 11:38:47 +0000
Received: from BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89]) by BYAPR11MB3605.namprd11.prod.outlook.com
 ([fe80::1c0:cc01:1bf0:fb89%5]) with mapi id 15.20.8466.016; Mon, 24 Feb 2025
 11:38:47 +0000
Message-ID: <96cc48a7-157b-4c42-a7d4-79181f55eed8@intel.com>
Date: Mon, 24 Feb 2025 13:38:36 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 02/12] KVM: x86: Allow the use of
 kvm_load_host_xsave_state() with guest_state_protected
To: Xiaoyao Li <xiaoyao.li@intel.com>, <pbonzini@redhat.com>,
	<seanjc@google.com>
CC: <kvm@vger.kernel.org>, <rick.p.edgecombe@intel.com>,
	<kai.huang@intel.com>, <reinette.chatre@intel.com>,
	<tony.lindgren@linux.intel.com>, <binbin.wu@linux.intel.com>,
	<dmatlack@google.com>, <isaku.yamahata@intel.com>, <nik.borisov@suse.com>,
	<linux-kernel@vger.kernel.org>, <yan.y.zhao@intel.com>, <chao.gao@intel.com>,
	<weijiang.yang@intel.com>
References: <20250129095902.16391-1-adrian.hunter@intel.com>
 <20250129095902.16391-3-adrian.hunter@intel.com>
 <01e85b96-db63-4de2-9f49-322919e054ec@intel.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <01e85b96-db63-4de2-9f49-322919e054ec@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VE1PR03CA0002.eurprd03.prod.outlook.com
 (2603:10a6:802:a0::14) To BYAPR11MB3605.namprd11.prod.outlook.com
 (2603:10b6:a03:f5::33)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3605:EE_|DS7PR11MB6150:EE_
X-MS-Office365-Filtering-Correlation-Id: 42f4309b-725a-474a-9161-08dd54c7cd1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?eVg1c1dJSmZoREZPNXNxd3hrZ0d2NHpjb2pyV3ZyNmhPVnI0bjVXVWtZNGt1?=
 =?utf-8?B?UEtXankwQzRXQWFKRE4ycWFzaHB6Mk9McDVDaEkzalpVcmR2SmJuakYzUFEr?=
 =?utf-8?B?WnhESXU0cWdvTkRWa29XU1hXKys2TkN1eGhxRGZ4SVpGVUhtakJWK3QrMFhr?=
 =?utf-8?B?WVEwKzJMSTNXYnFWRXljZjRWUDFUbG1zSGJHb0tEbWZLYjdKU1dZM09XWk9O?=
 =?utf-8?B?UExvWGxERjZEWE8vclpKcnpPSVFoZTd4M3g2L2pJSDVkZzY4d1R5eW05aWZQ?=
 =?utf-8?B?T0tOaFhBd2d2Mm9HK2V6Mk1tWUR6WERrZkpZQjZuR2liOFkyZnQ2VWt0Zml6?=
 =?utf-8?B?M1pOZXppekpTTXRYd2QwMEFnRzJEUVJMNTN0dVhNMnArT1YzT3k3QkRCMTV4?=
 =?utf-8?B?T3J6MzhiSEo4MGVIMmVRNkYzNGFYV3d4K3QvSTE2V2NuSHVwVUF0YnFRRE1a?=
 =?utf-8?B?VWpIaU9ZOUxicHgzQlU0dWFwVHdSVE9SK0ZGTmoreXVzVkpIUS9QWFAzNHky?=
 =?utf-8?B?MFJhSFpaRmlSNEhTK3A5RmdaMmJwTG5tbG1JeUFnUmsvWUlyUURabUY2eDli?=
 =?utf-8?B?dnE3a3RDOGVieWt6NXZab1U5RElZMFhJaDdCbFBZUEt3RE96alN6SFBHR2Vn?=
 =?utf-8?B?bDZjSFV3eko4Z3ZxMTZNNzhiWFN3VWpiNDkvbzVFSW51ck9nak5Ta3R3TTR6?=
 =?utf-8?B?ck1pYVJqNHFmUElMRXZ1KzIrYjlBNG1CZVBzVlBNenNLNTdYY3BqWmxpK2hD?=
 =?utf-8?B?dUo1Mm5WeDA3SzBZcUt6NUQxdlozV3J2UXZKbVV5bHRHR21kLzRPNkJPU3kz?=
 =?utf-8?B?QkU4NGRmSFRVaXBFWkJGWlpQczVHUnFTUTdlRGhNTzNoV2JrRU40TG5qdjZr?=
 =?utf-8?B?bURMcjJOTHJPemcrQjVaK2szMSt6Q1Z3aG5vc0VBTVlaaWRzZVBsZFpaNWtS?=
 =?utf-8?B?bGpreVlxNUdxcnVEUStnVFN2ZVhvTWplR003K2RBL2NBdGJjWGVmbEpsUjlh?=
 =?utf-8?B?VzE4Kzd3NWZUTVg1T05pWlBDVVhuOFlIaDlrU2ZQZ21hOHZjdk4rUGxqZUdE?=
 =?utf-8?B?M2M3eVJ4TUFiWmcvRUFqRTQ4VFBFNEp5RlJLb1p3Z1JGYWxEcXVPQUNRQXp0?=
 =?utf-8?B?V3ZQYVo1QUpBWlJsRjZxYTlGTHJWbDlyalRxRmtMSFI1NUtPdnJKc0pSbnIv?=
 =?utf-8?B?dXJJZ1FqcTJiZUZhVzIxL05Ed3NjWHRodzI2c3o2dHpSNmtkQTZRYUp2TGts?=
 =?utf-8?B?ZDFqK25vRmZqc3MvZllvVXNJNU9GZXpCT2tXNjdnRW9BKy9Dem8wdWp3ZzVH?=
 =?utf-8?B?L0czV2poNStCbGhyOUliN2xqSVFaMzQ0NXhmb3AydG9Eb2hLUjluRFVRTkdT?=
 =?utf-8?B?YXpMWlFHT2YvbXRnaW5JclJaUVN0dmh6K0plR0VoMi9DTXFXQi91VzlNTWE0?=
 =?utf-8?B?OHNQeS9qS1J2R00rTEoxSXNMMGgxOXllcCt3VGhRQVpJeFY2NktQbkVkUkVm?=
 =?utf-8?B?Z3ArZXhobXRrRFNWaG9kSTZYNGQ5VzYyWlFzKzFDWWUwbFc4Sll2Y1U3YkZw?=
 =?utf-8?B?NkRIdEFSOU1jQ3NBWlFQdE91WXFEelAyRnVmRGV1aXdtREVSdkdjUDBKYWQ5?=
 =?utf-8?B?akdqOEZkZVd2KzJmMHdLMzNkdXlaWW5VblA3UTVpOW5SRkJEaUhuSGM1OXVn?=
 =?utf-8?B?dEtkaVI4eWFuQjJSbmhmWkJFWjRjdE91aEFicExOU1k5Nm9JZC9USjV5RlF5?=
 =?utf-8?B?U0ZMM3MxRzB4VHJCZ3daUWk2RzhjT0dEcUF5NTFVU2M2OFE2QzZlNE1SZG81?=
 =?utf-8?B?RXFpVGxCUlMrdWpYbGRKamdjc1RXUUVqN0NVdXYwUm9mL1FGVDhBRTZuN1lZ?=
 =?utf-8?B?R3krYy9BNnhROWN3WVIvY051V2hVZ0tiRUlYdGczQ3dnUkE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3605.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MWVQZnNPUUgyVUpVSjYvRnplV3h4eTlrbTNFOGFPc0ZMaFRmVWE2UWdmOXZO?=
 =?utf-8?B?OE4wMXB2M0tzN0JkTFJBSzB5WU9tNndUazBoLzg2L2t6MGJoVStaNW1RM1FJ?=
 =?utf-8?B?Tk5XSE1DTXYvZ3ROUklQaS9hOHpYc05KTk96TGUxY3dYazBHaUhxa2tXUGpJ?=
 =?utf-8?B?N0dHUUNGYU4zTTBsM0I3Z1lsNEQrWU1QQ0YxOFkzdi9PRmxMWDJSeE1Xb0xO?=
 =?utf-8?B?akJKMy9PNnF1Wkt2SStESkVBeWh5VHJNN09JT0V1MFdUVm9oaDR0Tm1JOHZY?=
 =?utf-8?B?akR3L01sOHBlOTBVb2xNQmpXOWFKQjdzM09IaFBaRXJ5ZlUvNm55YVR0YTBi?=
 =?utf-8?B?UmZ2N2xTQXZtUUdLMnFNVk1RblA2MEozTFh6TTcweGpTTi9nZng3WFE2VnNH?=
 =?utf-8?B?UGk1QjNPRnJaQkdwNFF0Ty9kakFsR2NBSzIzU0k1YmNHK08wOEowUlRJU3Vx?=
 =?utf-8?B?aW1OMEtpNjVwRGV4TUNHVGFjazhrZzJtZDIyR2s0amx6SlJGZzd0RzFENndi?=
 =?utf-8?B?RWF1ZTBpQ1VyV0NGWFg5enhHdXhra0Yya0x2WXNmYWp0R2FuWCtqcGF3Wmc3?=
 =?utf-8?B?dVgrZk1hcXQrTnVxaVFvbnM0MFBacEFUTDVBVVVLdUNNNW1aQlZZSW5rQ0c0?=
 =?utf-8?B?MVB4NS9VTmJsb1ZNRFR4OXJ3aXpZZzIyT0JleTFtMzVQaDNJaTh5djRWMk5o?=
 =?utf-8?B?eWV1ZGpFWkJjTnQ2WGlINCtsL0M3TjF2MUtaS3NWTUR0WE5BcEZ5bTVueTIv?=
 =?utf-8?B?cG9SR3I5T1Azd1JJV1Z0YTFONTlDT3VpT0NSYTJKdDdQWm5GQnZIUTVPeG9X?=
 =?utf-8?B?M1N3T04yNGY4TFowY1lydERENFFDYUFlZy9MWjduN2xMSGttVVBRU24xb2RN?=
 =?utf-8?B?WFVZRFU0eXV3R3FIM2c4bldCQTZ2RFNhL1IzKzBHNmE1NTFqYUJja1VWUlFp?=
 =?utf-8?B?d3hEYzJiUDdneWxzMlJtQVJlUTV4TG1ZanlBOGk5SVdRWXE2aGE3amd4cmli?=
 =?utf-8?B?eWRqbXgzb2JNOFFpU2NUbkIvcEZQVGovYXMxUzVEcnhXMkNuR2hMRTJVcUk5?=
 =?utf-8?B?eGlxWG8xbW55QWRWK0piRVpQM0JhZFRoSmNjYk85KzJDMTROM0xUUlZyWGdD?=
 =?utf-8?B?U2NUc3Q2SldnZHZVUUZsMHB6ZTVoVTh0MkVHdWY5WndKZHI1c2VGNkRBbEFQ?=
 =?utf-8?B?ZytScm1JWXYvNVFISlNYZVlUSGI2dlhBMStEcCtDM2U5TEFQcW9YUmdPVUoy?=
 =?utf-8?B?cUd4OVBpWU5RdzdWT3VRSXFEYmRpSkdCL3dFcFZ1bW1hZkhGVHloVFJ3YlNF?=
 =?utf-8?B?SFNwbHJ2M0JZbHZraVVhQlNvWVhzS0NMRHErd0YxV1B4NFc4OXhaYkQ3bDZi?=
 =?utf-8?B?RWZTWmU3MmFXWTZlVDdnc2tKN0xIcVJFNmVZT0ZzemI1dVVoL25kRVh3L2lq?=
 =?utf-8?B?T2xpTXpIenpjNGpiWWNFaDVMazJVMk1rdVQ3aHlYelRQT1JzT29oUUE2MFlB?=
 =?utf-8?B?Ty8vR3RIZGxoOEwvcm5RcVo5Q0lGbmxkWUZYRElUeDE4Mlk4Y2NvWG1ZVTdO?=
 =?utf-8?B?eDB6eFBod05ITm44akF2SDRlUDg2d2ZJVnJlelNrRCtheUN5YmVkWjNLYTNt?=
 =?utf-8?B?Nnk1MFg4VEZjQXRpWnFWd2JIYmQ0c2ozbFFuQ2p3cVp3bWZhTjcxZGRPZFZM?=
 =?utf-8?B?cVdUM3lFODhab25YWjd6OStqbFlSN3J3SjVoL2U4S2JOWjRYMzhEN2hlMGJr?=
 =?utf-8?B?Zk9VYmQ4WDJNbFVOUnEydGJCS0lXejZUc1VqaEtreklDcEJIRXhta1dWZTJJ?=
 =?utf-8?B?VUVRSWhId05tUGszcmhrNkM5bkd2blU2d3dacWVQOFk0dWd0RDNVOXNjdFB3?=
 =?utf-8?B?QnNGd3h3Z2RMd0o2WHVuOFh5Qm9EOG15MXluL3RDRUR3L3lEVGNLRHdCY1N3?=
 =?utf-8?B?NFpZZnVKMnVKOHd2YlhEdDdLK3lKRnhBWmtIelViY0t3V25BWHdZWGlGT1VO?=
 =?utf-8?B?OWRKSXAydE5OVHFWVThBNTZwZGsyVWRMV1ZjYVk2YXV6K0tySTNEUjhoOUF2?=
 =?utf-8?B?MGxPYnlpZVhNQVFFMnpydUhweHUrdTJaK3BFK29jUDIvbWVacERRNDI5L2tE?=
 =?utf-8?B?REs1WVpjdWVpN3huN0hSbUpwTTBvMWNKcVI1TDNXN1ZJRXhaSk5FZUFEVTBo?=
 =?utf-8?B?M1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f4309b-725a-474a-9161-08dd54c7cd1e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3605.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2025 11:38:47.6725
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZZgXG2tLjQJRvKeTScVli2YxP1nyapdLR9rTiaZ7NuUgZJQtyya9UjrD0u7F+2WxHwWMmLFT2PyaczGhT7bVDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6150
X-OriginatorOrg: intel.com

On 20/02/25 12:50, Xiaoyao Li wrote:
> On 1/29/2025 5:58 PM, Adrian Hunter wrote:
>> From: Sean Christopherson <seanjc@google.com>
>>
>> Allow the use of kvm_load_host_xsave_state() with
>> vcpu->arch.guest_state_protected == true. This will allow TDX to reuse
>> kvm_load_host_xsave_state() instead of creating its own version.
>>
>> For consistency, amend kvm_load_guest_xsave_state() also.
>>
>> Ensure that guest state that kvm_load_host_xsave_state() depends upon,
>> such as MSR_IA32_XSS, cannot be changed by user space, if
>> guest_state_protected.
>>
>> [Adrian: wrote commit message]
>>
>> Link: https://lore.kernel.org/r/Z2GiQS_RmYeHU09L@google.com
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
>> ---
>> TD vcpu enter/exit v2:
>>   - New patch
>> ---
>>   arch/x86/kvm/svm/svm.c |  7 +++++--
>>   arch/x86/kvm/x86.c     | 18 +++++++++++-------
>>   2 files changed, 16 insertions(+), 9 deletions(-)
>>
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index 7640a84e554a..b4bcfe15ad5e 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -4253,7 +4253,9 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>>           svm_set_dr6(svm, DR6_ACTIVE_LOW);
>>         clgi();
>> -    kvm_load_guest_xsave_state(vcpu);
>> +
>> +    if (!vcpu->arch.guest_state_protected)
>> +        kvm_load_guest_xsave_state(vcpu);
>>         kvm_wait_lapic_expire(vcpu);
>>   @@ -4282,7 +4284,8 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
>>       if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
>>           kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
>>   -    kvm_load_host_xsave_state(vcpu);
>> +    if (!vcpu->arch.guest_state_protected)
>> +        kvm_load_host_xsave_state(vcpu);
>>       stgi();
>>         /* Any pending NMI will happen here */
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index bbb6b7f40b3a..5cf9f023fd4b 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -1169,11 +1169,9 @@ EXPORT_SYMBOL_GPL(kvm_lmsw);
>>     void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
>>   {
>> -    if (vcpu->arch.guest_state_protected)
>> -        return;
>> +    WARN_ON_ONCE(vcpu->arch.guest_state_protected);
>>         if (kvm_is_cr4_bit_set(vcpu, X86_CR4_OSXSAVE)) {
>> -
>>           if (vcpu->arch.xcr0 != kvm_host.xcr0)
>>               xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
>>   @@ -1192,13 +1190,11 @@ EXPORT_SYMBOL_GPL(kvm_load_guest_xsave_state);
>>     void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
>>   {
>> -    if (vcpu->arch.guest_state_protected)
>> -        return;
>> -
>>       if (cpu_feature_enabled(X86_FEATURE_PKU) &&
>>           ((vcpu->arch.xcr0 & XFEATURE_MASK_PKRU) ||
>>            kvm_is_cr4_bit_set(vcpu, X86_CR4_PKE))) {
>> -        vcpu->arch.pkru = rdpkru();
>> +        if (!vcpu->arch.guest_state_protected)
>> +            vcpu->arch.pkru = rdpkru();
> 
> this needs justification.

It was proposed by Sean here:

	https://lore.kernel.org/all/Z2WZ091z8GmGjSbC@google.com/

which is part of the email thread referenced by the "Link:" tag above

> 
>>           if (vcpu->arch.pkru != vcpu->arch.host_pkru)
>>               wrpkru(vcpu->arch.host_pkru);
>>       }
> 
> 
>> @@ -3916,6 +3912,10 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>           if (!msr_info->host_initiated &&
>>               !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>               return 1;
>> +
>> +        if (vcpu->arch.guest_state_protected)
>> +            return 1;
>> +
> 
> this and below change need to be a separate patch. So that we can discuss independently.
> 
> I see no reason to make MSR_IA32_XSS special than other MSRs. When guest_state_protected, most of the MSRs that aren't emulated by KVM are inaccessible by KVM.

Yes, TDX will block access to MSR_IA32_XSS anyway because
tdx_has_emulated_msr() will return false for MSR_IA32_XSS.

However kvm_load_host_xsave_state() is not TDX-specific code and it
relies upon vcpu->arch.ia32_xss, so there is reason to block
access to it when vcpu->arch.guest_state_protected is true.

> 
>>           /*
>>            * KVM supports exposing PT to the guest, but does not support
>>            * IA32_XSS[bit 8]. Guests have to use RDMSR/WRMSR rather than
>> @@ -4375,6 +4375,10 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
>>           if (!msr_info->host_initiated &&
>>               !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
>>               return 1;
>> +
>> +        if (vcpu->arch.guest_state_protected)
>> +            return 1;
>> +
>>           msr_info->data = vcpu->arch.ia32_xss;
>>           break;
>>       case MSR_K7_CLK_CTL:
> 


