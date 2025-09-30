Return-Path: <kvm+bounces-59082-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 09C41BAB7FB
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 07:31:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DD57918864E5
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 05:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF033276051;
	Tue, 30 Sep 2025 05:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cjEobQRn"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D295275113;
	Tue, 30 Sep 2025 05:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759210276; cv=fail; b=BOvTvpIS8rb0AUmPpmXR8b/hEioBO2Dpx5Yy5vd6JKb+T6WiyXQjbZ0innQIATvHa5zbXCITVEpDUL9PqlImAUQ5vjbU6pCQWccx2lluxv3UJbXGWu0qNumL2mXVRm/t2szjVbCU53FP2+5NOJQCUh085eqt44fCxHNsnQPq2Cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759210276; c=relaxed/simple;
	bh=3B+4hSezd6o08zPL/SSbCsv+GHHjNW+mj4jmE6LEZOs=;
	h=Message-ID:Date:From:Subject:To:CC:Content-Type:MIME-Version; b=mJp5rvfsZpsaMGIx4tKdEoNJxeJubmQiyw+8rNpc5DzCAIqWHxoA3zY+etbxYOSF6c0GQ8NDqwbNjDiDA1j5pNXxJEhDOa9RPx3xM4BpBhC+sh1qcVuxkBnrsR0NQKHgjqP/lvK4ibfBNdnLeMzSNY0xR2+GQ5xJB0qe3bkt6+8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cjEobQRn; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759210274; x=1790746274;
  h=message-id:date:from:subject:to:cc:
   content-transfer-encoding:mime-version;
  bh=3B+4hSezd6o08zPL/SSbCsv+GHHjNW+mj4jmE6LEZOs=;
  b=cjEobQRn3F1QzyLezQynDLmarXZq5wGjKaGCtO0VoguajTTE2JnYA6IT
   kTu8MaLGMY8vePU9ogAA+9s3qmJvpAVWX/xLXVJbA5DoiNvjgm4WEv8GN
   u02cid/efLBJxkFspWK5HCfS5cYy9Gs30DjXRMTQnrAq3Gi/0hNzI5I9f
   UA2Bz5RVx9pvidRSShJWbTHa2a6Ge+4u03E8OwOHntal2C9rg+cqW7JFg
   TADNHTTMxFkgdc2060HvfVT3SNe2MGvf9u8IT278h4XYdFcA6jO+Ef6mk
   xb5hQtxEQETW3zVq69HU6XXf9w5y+6cpTLAvNub4DOyxcodOchvEKDJIg
   g==;
X-CSE-ConnectionGUID: 8FezwUWrQ/O9bDDkLfu4Tg==
X-CSE-MsgGUID: aNPewrQBQPyTXh/zZPGguw==
X-IronPort-AV: E=McAfee;i="6800,10657,11568"; a="79107976"
X-IronPort-AV: E=Sophos;i="6.18,303,1751266800"; 
   d="scan'208";a="79107976"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 22:31:13 -0700
X-CSE-ConnectionGUID: 504uqtNHRRiPL6YPvGrBFw==
X-CSE-MsgGUID: +lSMByzmRXywBzvdKAMiqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,303,1751266800"; 
   d="scan'208";a="177551375"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2025 22:31:04 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 22:31:03 -0700
Received: from fmsedg903.ED.cps.intel.com (10.1.192.145) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Mon, 29 Sep 2025 22:31:03 -0700
Received: from CH1PR05CU001.outbound.protection.outlook.com (52.101.193.28) by
 edgegateway.intel.com (192.55.55.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 29 Sep 2025 22:31:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=si7e3E1gHhClCGPpVvrhfmgk8n/OZOLa8IZU5EGPXaitvnKGeElVV202bFLn219TEijHlHDfl5bn7zjy6FuPGvEMgEPvd7pklTILITVvrwXu5cNzqK9ymJdmrQZ/chhkY76wou02n/oUCHttCF1if5rXHkkiLo4ROof2ID/XKlgsVji7L+Eb+FHUjdaDYxQkAmMA6EgeeONQESGyfrIYqTTXKXTKxQ1fWlZm9W06As4L9JGhusMAqw/62wFFMeJHOVvU6wf6AlbdN8dTsuYkYA8idmHbgRcKc0wnqIRZjIjB37FrZbsrbBzPoXNqmRsSXJ6yaVt2yGfjYuw+ULHY6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CpypOLPnLf3mYpFLD2x6bvSML8i0ivbgzNhEhsBj0bE=;
 b=dlPZY8Voj+TkQ8bHthQ9luPLc9+zkEjaC88IwVQ+DfNQ32vsTvWrGVegywwgJNzjrtTtpxBkJ5PPdGVW49T9qY16pc8WxUdcDrmuGldWS2OdTyHlGNVlVdM8c4+Njn/PITo3bpCYNTwfhyBbY21XWohJN9O3XeekEEP2aVe8SnaeRPF7cy5zLHy/urSoTbwi5lSsKHp8y1q0jMoELKCZZi64rkA9b/IHG89du42nZCdDxF58z16sy4XunsQ/SCv5Ramn7VN4Dgv+S1vepx6/MPUoFwG5tIaGQFW3lZbpck+mMviqRHofaZYIIKrnc++0hPsPVeGt8vq8k4cYQobTDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ1PR11MB6129.namprd11.prod.outlook.com (2603:10b6:a03:488::12)
 by CO1PR11MB5203.namprd11.prod.outlook.com (2603:10b6:303:98::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.15; Tue, 30 Sep
 2025 05:31:00 +0000
Received: from SJ1PR11MB6129.namprd11.prod.outlook.com
 ([fe80::21c3:4b36:8cc5:b525]) by SJ1PR11MB6129.namprd11.prod.outlook.com
 ([fe80::21c3:4b36:8cc5:b525%7]) with mapi id 15.20.9160.015; Tue, 30 Sep 2025
 05:31:00 +0000
Message-ID: <70b64347-2aca-4511-af78-a767d5fa8226@intel.com>
Date: Tue, 30 Sep 2025 11:00:53 +0530
User-Agent: Mozilla Thunderbird
From: "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>
Subject: REGRESSION on linux-next (next-20250919)
Content-Language: en-GB
To: <seanjc@google.com>
CC: "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	"intel-xe@lists.freedesktop.org" <intel-xe@lists.freedesktop.org>, "Kurmi,
 Suresh Kumar" <suresh.kumar.kurmi@intel.com>, "Saarinen, Jani"
	<jani.saarinen@intel.com>, <lucas.demarchi@intel.com>,
	<linux-perf-users@vger.kernel.org>, <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA5P287CA0005.INDP287.PROD.OUTLOOK.COM
 (2603:1096:a01:176::14) To SJ1PR11MB6129.namprd11.prod.outlook.com
 (2603:10b6:a03:488::12)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ1PR11MB6129:EE_|CO1PR11MB5203:EE_
X-MS-Office365-Filtering-Correlation-Id: 90fcfa5c-97d0-47ca-a04c-08ddffe289d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dVpuYjRJL0JSWDl5ek9KeDM0eU8yYXJNOFVSdFpHemZIOTg4OXZKRnlrcCtV?=
 =?utf-8?B?bjNFV0xMTXpHMkxBdXd0bUxiZmVHR3JPT3RVQVJjMGRBclRKWVp4OGJPQ0Jk?=
 =?utf-8?B?anE2N0ZiSnB5aW5CT0xiM2NucTlmeVdTdm1zTUUwMVMzQmkvWUtOYnFmY0dh?=
 =?utf-8?B?REM0akZSNHhaMzM1dnVpdEdpVkt5Z0RqMVNnYzNoQSthYUlPWWRXbU45enVU?=
 =?utf-8?B?QzlJUlEwOTNBZlZDWk5CcXQ3YWl1bTk0RTlmZXhud0tuZWhiMGtGeFlTZGp2?=
 =?utf-8?B?UEM2NzNGVFY2MWdjNDNwbGx2R2dkRERMSVF6VE1CNXFQcm9Za016MUZ0a3dK?=
 =?utf-8?B?NDQ0TEN5OXJ5eU8vVEZqeVBYUWxKOFZCVU5ESTBSaGN0TVhPK0ROZ1Y5dTdD?=
 =?utf-8?B?Ni82cXlUTXVYRHFIanZvTXZPYmJ1VXZsS2dCY0tlNSttcThjYzNMb1hsWGM1?=
 =?utf-8?B?QkJkZ2loZXErS3AwSHMxNnBpU3ZVSG9kVTd1amxkYUllZUZQRVorYVZSdlV4?=
 =?utf-8?B?TXpYbUs3dklLY1ZGWGxlVEVvSFhDS3JHWXBHSDZ5NjFBVElKVDNJZ2VpVURw?=
 =?utf-8?B?UFFRL1BpQ0FxVFhoaU5YQnpMcGFWek5qb1ZWRkJPTUZsSDd0TXA4bjN0VXd0?=
 =?utf-8?B?OFlBR3Q4VkpHd29TSURLN3N1QzdiWmFTaDcxT1NHemJ4UFpVMTV0QlYvU2l2?=
 =?utf-8?B?UWRGZTVoWTh1STdOQTNYK0JJcjlscmlLNE5ObGZBeUJPYTQxWTB1aUZ2UjQ5?=
 =?utf-8?B?cnhlOHVvcHZKeDM2SEpMWHlScUJZS0dmcERrZk9XNnJYN0N6ZWRhbXBHcWFu?=
 =?utf-8?B?TXl5RmxzeVZCZXRUMjJoY1pOSTZRaENSTmRXOG1yaVFqVFBDNk9vTitHNWtV?=
 =?utf-8?B?eHBwS3dEMGxFYlRWSVQxRHMxWVRZeVNwR2hyRlJ6MXNSR254U3V4eGVrNEd5?=
 =?utf-8?B?bWtZc2IxSEJybTFhWnBaOGZYZ0lEclJoZVZ6MjhmYTcrNkY2WXZMT0kvK0Nm?=
 =?utf-8?B?VU5MZTFtUS9JS2lidG1DRVZjZTRFUWVubUtoOEVYc0V6T202UHFwa29YWk9U?=
 =?utf-8?B?eWRDUHZDQTRUaVlZcC80QWVtaEM3TURBRUFNcXVhM2NFc1pORDdsQmFGRnZZ?=
 =?utf-8?B?cnorMzlLOFRqMklqQ0grYWt6TmcvTDR2NnYrR1BDY0phZG14aUY4aExBM0V2?=
 =?utf-8?B?YkN6SmJJb0RQdTUvQjlOU2hVbXl3Sm1ZN21WbDJwRzltZFZ6enFvKzBZNHJz?=
 =?utf-8?B?ejRiUDNJa1QxaUFJbWZDaHBlbnRnSnZvNnFpWFFSNGhsNHNFbGJURFEvZGVC?=
 =?utf-8?B?WTUyVko1djk0Rlk2eXMyRjdYc3V6UDZzRXhWQWNWcnkwdkNCZGxKU2JhMjI2?=
 =?utf-8?B?bVIvcFN6dFNtOUN0T250VnRhQkR2SGVpYTFWbmRMbFRZTVhMUVJxSy9iclAx?=
 =?utf-8?B?cTRja05VRW9ROVBIREtrK01PL2lDYjg2dk9KS2pxd1ViTExQS2ppNnFadFVp?=
 =?utf-8?B?ZEp4VmVyZmRDVFJjcjVSQ1MrTmZ4OTVRS21JcmJKY3dPM0RTakVyWHM3OUtk?=
 =?utf-8?B?T1JERE1BOGk4ajFXYjdKZUc2Q1NvZEtLeTZWanpBejJtbWVzd0tzQ0V3N2hB?=
 =?utf-8?B?U0paT3NObTJmZG9ITHFPU1oxZGdmcEJaWkdsUW1nMVdCV1F2SEpCd2c3MzJE?=
 =?utf-8?B?NHc2WXpENklUeUdkTDhibHh5QmkzSkIvTkhCTjNwemdTZ2lDVWk3M2Rjbzlt?=
 =?utf-8?B?MHhtTkVmL2haU1BKV2ZOQlU5NndXNkpKb2dhaGNlVUZtWU04aVp1cXZzYms0?=
 =?utf-8?B?bkxPSXJCeFhoWHM0NnloWUpJUGFheldvbG9xWTdGV3orZzNrYWpQeUgvVDZ1?=
 =?utf-8?B?WjRrQVBlVEVQNEo5MXQ1Z205YjQxYm5aVmsreEVUYTVCRlE9PQ==?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ1PR11MB6129.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OCtNalloNVpSK3hZVkN4OXp0by9uWS9CMzE5V2lhLytCOGM2ZklGQ3VVUzg5?=
 =?utf-8?B?SEVMOEJMZ3Rra2hTam5nb0puK2Z4KzU0bHMwTGVEMHRmbHY1Mk9NSlVuNVdN?=
 =?utf-8?B?V21ta3ZITVJvdlFJb2o5VWY3cGo4b292MlErYkg0eHQvblNjTlVjWGdwcUtV?=
 =?utf-8?B?ZXFyaTlQU1l1bElzdW00a2xQS040SXRHb1U2cDNxUE1tUWtEcmlUcGVOMmpi?=
 =?utf-8?B?aVM4Zlh6aWJCaWhoR3lFaklTUVZZY2tmMEZTMVhkeE9rYWd0dG1CR2E2ZE5L?=
 =?utf-8?B?STZWT2tkWDVSVytwUVZFR3p3Y0ZpZC9MZG5Qbzc3d3NFR3NDL2pTamhLUmtX?=
 =?utf-8?B?NlgzS2RyMi9ZNC9uakRrWjBxQ2orYm5iMnQyd3NlWFg3S2VlMjduaXpLUFRF?=
 =?utf-8?B?UUJvV1BlTmtMem5HdGNpUHQrREdrSWtxM0pCWGFOL0RXajNOU3ltcnc1a2dl?=
 =?utf-8?B?TTByeU9ScUlqUm1VeGRpbUoxQndQWW0waWZObXBhRlUwK0owQmptTG11RUh1?=
 =?utf-8?B?WGE5cCtPWkUvcDNnQ0FiNW9RdmhLUG1sUnhOMFE0ZlorWTcwczZQbHJIb1Fz?=
 =?utf-8?B?c0lOdU1yZWdiNGQwQks3RkJ6VzBGTGUrdEQxZXlFejVtUDBHWmRTTnloZVli?=
 =?utf-8?B?bU0xM1V3RWd2T3E1Vm50VjIwV3l2aExObHZldERkTnZnSThZNUQ1NHVhTzlq?=
 =?utf-8?B?ZFROV2lndGU2aFBybDllNG9TVDcyQlRML2RwQ200MENpRHdBc1VGMUc3MmRk?=
 =?utf-8?B?MjBWT0Eydk85WVFSZEdMQ3EvWlE4bzR1MlV3MmV1MnMwMFF2bHo0TjUrRVkw?=
 =?utf-8?B?SEptK01WZFEzbTBJelFlL0dyUlhsMngrT2J0ZkNyempJZnVTMHlOOVN2RGdx?=
 =?utf-8?B?eXdYbDRQZDV3b2lBZFN1UHVXUU1mRTR3dmdQK3RmUU1pRWRlNnJ2NUhXRExS?=
 =?utf-8?B?dVVzRWVkQnpNVHNEUG0vOW1OdHd4M2dEaUlxTTI5MmsvK0FTeEc5MkVzN1cy?=
 =?utf-8?B?bHFSNVFDc1FKcVM3VFNOd0ZoZTJXa01GS0VJbHFZMTFjR2ErSmpBVWEyR281?=
 =?utf-8?B?WitBQ3k0Z0lTNHRDV1hld3VRamRDcW53Uk54dzVLM1czbDBRMStib3ZSYkVB?=
 =?utf-8?B?Y3MvSGtQMmNTY2ZDZFUyZnhuVytyeDZoUmoya2hqaHpwNHVMMkp3clkvb01D?=
 =?utf-8?B?VWdpYm9OMEJmbGN4czNxeE10Y3hSUjZva3cvMDFRY1ZibXMxN05qTmx6YjdY?=
 =?utf-8?B?ei9OakxXRGwyZmVtZU1ocmtOU201QUJ5SFFjT2sweXovZHdHUHNEeUJ0emZt?=
 =?utf-8?B?dGxKSVFVa1JyYjRmd0ZQNXlYMjlhL0tpYjIxVjlNMkNoWmNqaFRRQWFhTFdK?=
 =?utf-8?B?QStENHVzSXhReGQ4VDErWkNUOWNKS1NRS2NIOHRSOURJekVZclgvOURSblZY?=
 =?utf-8?B?NmFXc0J6RGdhcUlKRkFDL3ZjUjBWR0tJYjVxR3QyaVZGc3pxR0lPSFBYdVUw?=
 =?utf-8?B?K2NKbzNiZTVrTFFOMVVDUUR6TEUxVDRyQkNkSFd1LzNoYWkyUVJKckFrQkw4?=
 =?utf-8?B?dFVDMloxajVUQ2t6Y3dlN0N4b0VSY1U3NUFRaTVwSGpQVzZMYjhFMVBjVE5u?=
 =?utf-8?B?S1VqRFVQczlMT29sdEhWLzVVWlFhV0xpMzY2OXlVZ1c5c1BaMzBSRWVrdllK?=
 =?utf-8?B?OG5JTmJiZGI5bmQ4aDJsTVg1MmNsZk9nUUZnaDV1RGV1eTMrclJDemRPbjV0?=
 =?utf-8?B?YnpOQmZ3L2lndHRaYXBOQnppZlVxNUFWVW11V3lWRUo2TVF3ZnhJY0tLR3V5?=
 =?utf-8?B?bW1iUFVUYkJ0N0JKWDVFMjRqME1NR0hBdFNuR1dtNWpmRS96VkRqU0hKMjh1?=
 =?utf-8?B?dXY2OVZJOW5QMlB0Nzh5REc3T2VEb0cwT1FWVmt6RHVIeXpuUCtDZjNYaW1l?=
 =?utf-8?B?OTJadDNKbHpvUW1NbHVJYVBic3phVGVUVEhiZ1pGZVkxQmNkSE1jYzl4WGhW?=
 =?utf-8?B?QXhiQ05yTCtza1RaeWY3SjhJc2oxTUhLYlR2emJoZ3FVb2RvSllsdm1TVU9x?=
 =?utf-8?B?cVdXWHJVVDQwWFdvT2FkaDMzZ1FiUlZxZnd6ZTk2a002YXVVcW1wcjhKUVRL?=
 =?utf-8?B?VjFqeWVBN0JZZkkvdnVHa3dBaTRKWVFrOSszUUhRemlCRFg4dG5WRjFTd08y?=
 =?utf-8?Q?qqVCYVAGJ0C+yEj3AGknkjA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 90fcfa5c-97d0-47ca-a04c-08ddffe289d6
X-MS-Exchange-CrossTenant-AuthSource: SJ1PR11MB6129.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2025 05:31:00.0286
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZxxObAqA2yCB0zo5RGkT0myYgjH+QUrwxvz98zZk3ySUoAXrGynpT4n10hmz+6Zydgja+NnekUUsFIkpwgZ6sB3XPxyNEqFxzX94oAPHU4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB5203
X-OriginatorOrg: intel.com

Hello Sean,

Hope you are doing well. I am Chaitanya from the linux graphics team in 
Intel.

This mail is regarding a regression we are seeing in our CI runs[1] on
linux-next repository.

Since the version next-20250919 [2], we are seeing the following regression

`````````````````````````````````````````````````````````````````````````````````
<4>[   10.973827] ------------[ cut here ]------------
<4>[   10.973841] WARNING: arch/x86/events/core.c:3089 at 
perf_get_x86_pmu_capability+0xd/0xc0, CPU#15: (udev-worker)/386
...
<4>[   10.974028] Call Trace:
<4>[   10.974030]  <TASK>
<4>[   10.974033]  ? kvm_init_pmu_capability+0x2b/0x190 [kvm]
<4>[   10.974154]  kvm_x86_vendor_init+0x1b0/0x1a40 [kvm]
<4>[   10.974248]  vmx_init+0xdb/0x260 [kvm_intel]
<4>[   10.974278]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
<4>[   10.974296]  vt_init+0x12/0x9d0 [kvm_intel]
<4>[   10.974309]  ? __pfx_vt_init+0x10/0x10 [kvm_intel]
<4>[   10.974322]  do_one_initcall+0x60/0x3f0
<4>[   10.974335]  do_init_module+0x97/0x2b0
<4>[   10.974345]  load_module+0x2d08/0x2e30
<4>[   10.974349]  ? __kernel_read+0x158/0x2f0
<4>[   10.974370]  ? kernel_read_file+0x2b1/0x320
<4>[   10.974381]  init_module_from_file+0x96/0xe0
<4>[   10.974384]  ? init_module_from_file+0x96/0xe0
<4>[   10.974399]  idempotent_init_module+0x117/0x330
<4>[   10.974415]  __x64_sys_finit_module+0x73/0xe0
...
`````````````````````````````````````````````````````````````````````````````````
Details log can be found in [3].

After bisecting the tree, the following patch [4] seems to be the first 
"bad" commit

`````````````````````````````````````````````````````````````````````````````````````````````````````````
 From 51f34b1e650fc5843530266cea4341750bd1ae37 Mon Sep 17 00:00:00 2001

From: Sean Christopherson <seanjc@google.com>

Date: Wed, 6 Aug 2025 12:56:39 -0700

Subject: KVM: x86/pmu: Snapshot host (i.e. perf's) reported PMU capabilities

Take a snapshot of the unadulterated PMU capabilities provided by perf so
that KVM can compare guest vPMU capabilities against hardware capabilities
when determining whether or not to intercept PMU MSRs (and RDPMC).
`````````````````````````````````````````````````````````````````````````````````````````````````````````

We also verified that if we revert the patch the issue is not seen.

Could you please check why the patch causes this regression and provide 
a fix if necessary?

Thank you.

Regards

Chaitanya

[1]
https://intel-gfx-ci.01.org/tree/linux-next/combined-alt.html?
[2] 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20250919
[3]
https://intel-gfx-ci.01.org/tree/linux-next/next-20250919/bat-arlh-2/boot0.txt
[4] 
https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?h=next-20250919&id=51f34b1e650fc5843530266cea4341750bd1ae37

