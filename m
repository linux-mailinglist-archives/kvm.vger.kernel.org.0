Return-Path: <kvm+bounces-35343-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D337FA0FE2C
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 02:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9695418892B7
	for <lists+kvm@lfdr.de>; Tue, 14 Jan 2025 01:38:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D08A22FE16;
	Tue, 14 Jan 2025 01:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OyVonVSx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE8CC212D70
	for <kvm@vger.kernel.org>; Tue, 14 Jan 2025 01:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736818704; cv=fail; b=YlUOjtLtiQHm2h5qiod467lYZkzobnjTePxwMb06WjXUyIzntvXNimgtcT5AMBLnkN5TYBAN3Y1W/Gt9hKb76d3GdwJxTEFq9O7yltXBDCfWqnRW0Fc7Yc2Iy+Y1uZBG5o/VGJAuemUKSJ3B4I+Mmg04fUl9k2FGjSBhh940AyM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736818704; c=relaxed/simple;
	bh=MzvqlpZCn233PPpH47SV/FIxSnrFjdvIjEEKqsiYaWs=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=tb49RXgxqwjcQcYpBUW8l1B3GatJmsdP+mLezStD+3PI5a3sM5ALJqmDLcDEHzgjEYT63tl3IuAL/B3PCsxis1V50wECaAyT0YLMBIcCuWBG95fRiX448hT3x9wu7XQTbTkksDPxC0B7+f1IVXlsutIF8bmi/fqylgn8wbe0fJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OyVonVSx; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736818703; x=1768354703;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MzvqlpZCn233PPpH47SV/FIxSnrFjdvIjEEKqsiYaWs=;
  b=OyVonVSxx6T1TxRsQeO7/ImBI+6IcEqM3nD1P9ixBZq1LtxmdFVJiB9k
   /5mjqiD1tSwrfSV2IhPXyfHnTspceq8UEY1MRznVELQBC2MEfVkH4Zh45
   1ca8hF1vPp0HaFvIMQ4FEojtV4ufc2sjn0a1x1zKtcW74bcimq4HHdN3u
   6WWPOSRrqgFUyDUihTQhPe5m9GjbSmye69uLhOgkIAGkNVLYB8Ba54BPM
   bLh8v1Wein4W1eWgA2PP/Qyf2pT8tu4LnBaDHs1Is/sZPGpuKHmrZlPan
   SfW1nSVbYpfjSkOH0UFud7+81cpXa8J6UidbfObKG3ckwB+o+r/09d3Mo
   g==;
X-CSE-ConnectionGUID: y+vJ1gasT2KZqW8PN29P3A==
X-CSE-MsgGUID: QDSUk1eiRXWO/YFgc4IF1w==
X-IronPort-AV: E=McAfee;i="6700,10204,11314"; a="39912468"
X-IronPort-AV: E=Sophos;i="6.12,312,1728975600"; 
   d="scan'208";a="39912468"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2025 17:38:22 -0800
X-CSE-ConnectionGUID: tPFTcX6ESL+FfqCfULihsg==
X-CSE-MsgGUID: 2SL+FEu4Ru6seMo0ToMkwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="141931892"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 Jan 2025 17:38:22 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 13 Jan 2025 17:38:21 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 13 Jan 2025 17:38:21 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 13 Jan 2025 17:38:20 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=RhrSYik35+T0QXIWdxh1AtJQli1zesn/FjKSXQSK0VfkSWEk/EOTorfpaKyPeHiyl0YSlyzoBnssF4Fzrm1JCPUblZD3DYH1jqBDetfN+/nKfo8VUCYe128z5MPX6gMDiVhHKkT2pAw8IiSzc6spaWm422sHlI2z0/C6YdES1w7OPEoTDD7Lz+uasRmQqnBEqLnbVnBtTNghSKeS5F0YnEZSgLk4TlksnqgQ024fW76jNbkVwq+2ItvXSf/8zw7ROAnTLK3yD3ABBAYH8t4uqUnANFzZQa0ApptpO4ZmKa8sK6y5hg3g5VisZYuW99x/Yeduiz2kvjnckRbaJ9atfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iQmnHzdq+CcKGpWPX8YAo43DSbo9okaDx/J1+1za9ig=;
 b=WQPL4wOu7Up+GwEIBizL12mmcu6xr2kOD4zg0TveA23mkS27pe/6tCzrxlEwmNa8ZqDm7NbMxAFxDA0stpHgtV6VOPSmPQC4P8o/ZQ/itvLdkGoyKUiOO23537//5bp6nkbBRKX4V7LIFevjjI9ppC2UeGN1N59qeK0S7WB7z1zj1WmJtcv2rW9YJJnYL3Zh1MbWCNe5R49DX8pAoNNN4H/CgAb1urE7CSyT7TxWtmigGy12MgXdJfXw62VATZ7W0Y8KXVdqVulNWk1bIAN9nBY94qWH9cLL1dYElqArasNF3Vi+JlhKqGkRsNzHN5Qqnz+GPheayYRi6ZJ4r3hpww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 DM4PR11MB7397.namprd11.prod.outlook.com (2603:10b6:8:103::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8335.17; Tue, 14 Jan 2025 01:38:17 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%5]) with mapi id 15.20.8335.017; Tue, 14 Jan 2025
 01:38:17 +0000
Message-ID: <b01003cd-c3d1-4e78-b442-a8d0ff19fb04@intel.com>
Date: Tue, 14 Jan 2025 09:38:09 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] RAMBlock: make guest_memfd require coordinate discard
To: David Hildenbrand <david@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Peter Xu <peterx@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Peng Chao P <chao.p.peng@intel.com>, Gao Chao
	<chao.gao@intel.com>, Xu Yilun <yilun.xu@intel.com>
References: <20241213070852.106092-1-chenyi.qiang@intel.com>
 <20241213070852.106092-7-chenyi.qiang@intel.com>
 <3e23b5b0-963c-4ca1-a26b-dd5f247a3a60@redhat.com>
From: Chenyi Qiang <chenyi.qiang@intel.com>
Content-Language: en-US
In-Reply-To: <3e23b5b0-963c-4ca1-a26b-dd5f247a3a60@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SGBP274CA0014.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::26)
 To DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|DM4PR11MB7397:EE_
X-MS-Office365-Filtering-Correlation-Id: e656b5c0-d372-45e1-9729-08dd343c1e94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VlZMM3ViOWFzTFhXUmdBMXdCUUdGZDRrTWx0eFJQMFJ3OVpRbHVOV3hIL1RU?=
 =?utf-8?B?ZnN4QlFSZDFkWjBYbXM4Ykh4V01MNHJsUDhPM0dkQTNtdUU4MEh3RFhvVWRh?=
 =?utf-8?B?ZlBvZHpRdlkvSWNNM0dyQ0tNK0xPZWFFbGt4cTZabjNmZ3hqR2tpNnFLc1Jh?=
 =?utf-8?B?bUd0OXlkSVhaZ1E3VFZBMnlQcDJLck5wclRTUGFjREZoenRNRzNkYUwyUi9a?=
 =?utf-8?B?SWNKWk9saUxEZTkxVUIwekM0eExFQndCaGpRWFhaLzhDWGtsck1Db3BQODJK?=
 =?utf-8?B?elEydzBiZXFvQjJJOW5oRkJzSXQ1alg4ajBFbUI3VmRyd3pMT2NXeWdBKytT?=
 =?utf-8?B?Tkp6Wmk0TU9kbjNCTjEyZjNHMDZVNUJjTXNRRm9hNjRBTGZzZGdJSUZZVGRn?=
 =?utf-8?B?ZHAybGNZdk1ycUFNU0dOMENRTW5oNlR3NEVYVExKYlZoS01BUEF6QTU4TER0?=
 =?utf-8?B?TlRXTFpLbUkzdUJibmYxd1lLUmNhMDRjVUVxbFBqbzZrZjNNRTN1RjVjVlNV?=
 =?utf-8?B?Rkg3eExnM3dYdzBFWG9nSHZUYTZNbjZJa0d5b1p3S1BESGxNcG92cDFJRUJP?=
 =?utf-8?B?bkRCSkVmRXRCSW5WL1dXa2xPUE12SDZWNVliSGNISzlnN3crZytWQUF5a20x?=
 =?utf-8?B?cXA3aUZFMzQvc3ZhMTFPRDkvU2ZhdVQ2N24xMGgrNisvdmRzMG5vcWd5Q0FN?=
 =?utf-8?B?czczYkZibXBHaW1sWHcxSUVucE1xaFpuaEN0eXdpeUxObmVRWEh2eFJIYncw?=
 =?utf-8?B?dTY0azE1UUlwNTdNMkFDUXpRa0lJOFBYcjFOcVVKSXFqTEwyV0RDVWUzU2JZ?=
 =?utf-8?B?d0xGMVlkWFlSRzZpSjc0SWt5bHl6Um00TVBkU3JHU3oyS3VEaWFEMTZnODJp?=
 =?utf-8?B?TWttZFYyY0M2bWcxTUgxcjdhQUdpT253SmtWR3A3S2JuMDU3THRCMXVZRlZ2?=
 =?utf-8?B?aC9qWHNkN2thVndFVXkwVWVjemlmcExScGhSMFBZeVpPSDFpS2NORjNIeHV1?=
 =?utf-8?B?RTJNZTEwbjIwNWVhck4yK3UyVUxpSUdScEpTenczdjNtNVIwWW5VclRuVjZ3?=
 =?utf-8?B?clU1aFdSdTFXUnVCaFkrV0xQN3pZQzZsRUlEYUtRK0M2ZVUzNUZURFVITlcv?=
 =?utf-8?B?MzZQdU4yREhvdXVNdVgrMENjUmpUN25zU1dMQmVKMXVZNnZyUVBraGNDRU1J?=
 =?utf-8?B?ZktISjVNNTFOTWRHMXJHanNZVTVGYStoMEg2NEhxdmpQcEJNQm95MHZqb1pL?=
 =?utf-8?B?SXlia0xzdVo2RkRNRlJrSWthWVhkSWo1L0pjUUlVYldvOHBDZTFUak11cHFC?=
 =?utf-8?B?Z1NJSFBQMHE4Y1BXeG9YYVdpaUNzaVBVMGVvR2dDZTMrdk0xWE1GdTFUVlNs?=
 =?utf-8?B?MHJXTVd5VWVJQVFZYjRwelU0U1lZZGtXY0RwM1ZubjFNODc5bkdlNFdhK3dF?=
 =?utf-8?B?aGtzNDhFZERod2twZTFpOEJYR2NwS20zMWJkbWZLSTJkWXk5TTVkdDFUTWds?=
 =?utf-8?B?MDdDejdPTDhKblJiSWRFWFJ0cHlkSmZBWlNlT2xwMG5CdGpQTUhQNU5weGpK?=
 =?utf-8?B?alJmcWJrTTArTzhHbktDQnhwQ1RueXZsZXRuLzl3cTVxQisvN3ZoaGJOM2Vh?=
 =?utf-8?B?YmJDeUEzTnNCZzRIQWhqRnNsQmRFTnUrN29CTzVUdy9RL1dTWGJUcFNJMWUw?=
 =?utf-8?B?MGR0TU9VbzVPUHhtSDhwNjVmWnoxalU0MDdlL0lCbUd5bTdJSVhHVTBWTFEx?=
 =?utf-8?B?MythV0ZlYk5HZGNTNkhtOGdBT1lsMHZDQzBvTU52RWpESmI1TGlhdG1lZE1m?=
 =?utf-8?B?MjgxZVpGekJCZkFCUnVNMGdsWFFMbXkyWkxnK1RNZEk1NURMZUVhTDZjV24r?=
 =?utf-8?Q?4gmB93O8EjoRt?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlkyUkpMVFhIMU1WL3JLWnJjMEFCaC9CM3owZmF4NWg0c2NVT01sOG5uRlJj?=
 =?utf-8?B?TXFLQnJFcEEyQXM4ZkxlYjBSS1N4T1JRRFQvS2pqeEJ5RDNyTTRHaStQcURC?=
 =?utf-8?B?YWtlbnExeFRQRHFNMnVKYllnZkNuQ0JaT1QzN05iYkpGZTE3SG1uSWVSbUdE?=
 =?utf-8?B?Tms0QlJqT2g4RnpzVmxjTnVQK2tuVTRRSnBZUVdjR01KWDFrU09LUC9hMUdr?=
 =?utf-8?B?TWk2UUxqcVE2Q0Y4ZTdJT0haWmIrd0ZjTUs3S0tEbm9XU29WL1FiZkdFT3kw?=
 =?utf-8?B?OE8zd3RCVTdjemZkVUhvQlVOUk1UZU1QUjhOVThMTnZiRVBWd1p2enlUdm1y?=
 =?utf-8?B?RHN2RGxDUXo3WFVxSUNwVEh6QXZBc3V2OTQwa0NVOGFab1F4elk1WS9qU09D?=
 =?utf-8?B?TVNNMkg5S2N3d3p4T0NZK1ZwcWd0Wm1Uek1FQ0NQeEtFaC9CL3BtdHNaai91?=
 =?utf-8?B?dHNPeGhic0RCMDI4K2xINnFrcjZINnorb1lncVhyVVN0RjN3SE9Wa0lPbmI1?=
 =?utf-8?B?V24wb29TRVNzSFdoYWJCSUVKN0xGZEx1UG16ZmtZVXZHWlFwWU9zbkxSWUt5?=
 =?utf-8?B?RVZWZVA5OTZ0OWNYWEozWHFVMUNBdzU4bGhsMVZCbGc4dXpyMlRqcVB6ZmhR?=
 =?utf-8?B?NEk0ejdocUl0SHNnMkVaZWpYS1lIamhBQkpCZVlmbkE5WURwRktUUXpwdHEx?=
 =?utf-8?B?bHdmM1RuaVlUUDc5Z0RtcWxBSHVvanU4VWZwMkNRVDlJU1I4cnJJTi95T1dv?=
 =?utf-8?B?VmJlMWtqdVAxWXUyZ2ViZGdhSjBVUmkrRTBIZ01mM1RIY01GUnMwVGU5RWFr?=
 =?utf-8?B?L2dvVkI4WDg2a1ZxNmhkeWxPL0ZieldMVXVZNGoydFJ4N1JMOFRRQXRRTnFz?=
 =?utf-8?B?V1dDYkJYWExQSjBSTVVQQXpjWE9ZMTBabjJCbVk1WU9hWm00NXQ3aVkwbGgx?=
 =?utf-8?B?TjZ3N2pZb0VHV3RpN2RQcTU2cExJZCsvaFpiZk5lUk1XZHU3SW1FNHdlU0My?=
 =?utf-8?B?a0ZVL1JjMmhUSUMyRHJPWEM1djgxc1YwWWFmbDdhQzk1Z2pnaVF4TmRnZndu?=
 =?utf-8?B?S25HanZWMkthMHhienlJMUxIMnczTExwdDk5MDVwRFozTm1KVGd4clNxZlRo?=
 =?utf-8?B?cEViaHdCSlZDbU9iTlN0ZmlQRHhVS0VtNXZTcEhpdnAyTVZpTnZPRStkVFZV?=
 =?utf-8?B?U2JyUi9aOWZLS3FRMmR6aVFIalZ1eHVtMjBUeUQ2TGlsVWhmbmpXYWpkclll?=
 =?utf-8?B?UGdCNFIvNUVUYjlCRDhYWm5ORUZMeUx2aFQ1eG82djRhUUUyQllNYlVZa3NI?=
 =?utf-8?B?ZkJXdTV3cUxDRWJrTjdtRnU3UHlmL2h6Zys2MzBoWTNDcTlPYW5SbS9Lekxn?=
 =?utf-8?B?MU9HVjcxRExWM00vRFRRR0dmd0x1dWZJRlh6cnA1V1A4QVNOUkJoTXVzWmRV?=
 =?utf-8?B?bzMwaWJnUXJlNHA5dDlKdjhhZTdnc3phUitzTXFvMEFXaXJSUGlEZlFyaEZh?=
 =?utf-8?B?bDFHdjlIL1ZVSWNGYU5jL2E4bDJrVnYxWjlySFVEVkhDUlFSWVduTjc3Y1RP?=
 =?utf-8?B?RUdjSFpodVNmL3M0MENTM0FPYThRM1VoOFc1K2xDZ1JKTCs3SjJ5N0Z3U1o1?=
 =?utf-8?B?V3UzeE0xSzFtVFUrdW1RV2w4aGtnYVVYT1A5VHNsWjNFWmw1RTlwaXdJbFQx?=
 =?utf-8?B?Q1NIdnN4S0hWZ3Iyc0Ivd0xMbGtlMlZ5cFZuT3NUYWJTZ25Sb3ZnNjlFU1FN?=
 =?utf-8?B?d20xUFIwcC92SWNNSTdsTmllR2pGOS91YWlXOWpJNVl6MHlFcVFpSkQ4QkEz?=
 =?utf-8?B?Q1BsUnFEdHhsT0dzdlZheVdvQ2tHUXpvOGdFSHA2MHh1NGxLb21maEQxU2di?=
 =?utf-8?B?L2tFL0lvOWtCWlVXbFlFVU1oS3pNN0ZlRHdNNXZoYmd5TTY4K21ETmdOdXhF?=
 =?utf-8?B?amJETFJFdXBTUmZJdC81VXphZnBYVm0wdWE3cUJjZC9IWjZOdnZCUXNqV29y?=
 =?utf-8?B?OTZVRkt4TEdOcVo4eGJkS245MjNVOEZjNUpPVXd4OG5iMDFrU2dKb2dITnZt?=
 =?utf-8?B?WXExZG01RlorWEltdkVpZU5sQTZTWlNVbVhrVFV1Z3RTT1pQU2doZUVacW9y?=
 =?utf-8?B?akVEZHVENnNnR2N1bThqUWlkc0NIMHBkME95bThpL1ZuSDh3ZzRVSFZNOXBE?=
 =?utf-8?B?YXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e656b5c0-d372-45e1-9729-08dd343c1e94
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jan 2025 01:38:17.5411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wzc3+V0HpeQfB9CU3W/IOrwrqTsZyNIhyLMo3W68Lilyuy5c24ip1SKmo0E9zfSaDx5BdoSj8LX71PZzy9/KyA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB7397
X-OriginatorOrg: intel.com



On 1/13/2025 6:56 PM, David Hildenbrand wrote:
> On 13.12.24 08:08, Chenyi Qiang wrote:
>> As guest_memfd is now managed by guest_memfd_manager with
>> RamDiscardManager, only block uncoordinated discard.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>>   system/physmem.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/system/physmem.c b/system/physmem.c
>> index 532182a6dd..585090b063 100644
>> --- a/system/physmem.c
>> +++ b/system/physmem.c
>> @@ -1872,7 +1872,7 @@ static void ram_block_add(RAMBlock *new_block,
>> Error **errp)
>>           assert(kvm_enabled());
>>           assert(new_block->guest_memfd < 0);
>>   -        ret = ram_block_discard_require(true);
>> +        ret = ram_block_coordinated_discard_require(true);
>>           if (ret < 0) {
>>               error_setg_errno(errp, -ret,
>>                                "cannot set up private guest memory:
>> discard currently blocked");
> 
> Would that also unlock virtio-mem by accident?

Hum, that's true. At present, the rdm in MR can only point to one
instance, thus if we unlock virtio-mem and try to use it with
guest_memfd, it would trigger assert in
memory_region_set_ram_discard_manager().

Maybe we need to add some explicit check in virtio-mem to exclude it
with guest_memfd at present?

> 


