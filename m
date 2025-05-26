Return-Path: <kvm+bounces-47701-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AE41AC3D36
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 11:47:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C705176654
	for <lists+kvm@lfdr.de>; Mon, 26 May 2025 09:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE181E47C7;
	Mon, 26 May 2025 09:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QI0wWsgQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA95513A3ED
	for <kvm@vger.kernel.org>; Mon, 26 May 2025 09:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748252821; cv=fail; b=u9FYC+G9uD0rSh5CIOhfnjChd8dgoGYyCBUSXuw1YqgAh3JbCCRtT2Fyj39B+6cgRMsgVTrSjNXwyJ6lTxo83//Vgm6vViicqNC/ikNVDtdyHlekCXIzpiqlFyWbjXMLPgsBj+te+ABpefbgCmK421Y2rZl50pn06vY85HgJMMk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748252821; c=relaxed/simple;
	bh=WXSCegbcQET021IEi08NwVKZqv9oTZ5wKTErIsYJ80g=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=BowIlj0ZojVPyDJhM/OkDlwbNCjpdvexRqhfPhukKEznKeud5+IxR2nn0S4cIn41+pxnr79em4Kp576Dw6UIPKd8yLJylj1QOvN5Y7lfbv4fZ0LwkxHH41ZDkf5zoImM5LQgxUBBLhKG3aGvI8M08E69JzndLQDdUfMBeAOH2CM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QI0wWsgQ; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748252819; x=1779788819;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=WXSCegbcQET021IEi08NwVKZqv9oTZ5wKTErIsYJ80g=;
  b=QI0wWsgQcGATfc/Lu0GXtIimgr11RbhJNNcqjd5sCGqZMwBwEY3w8wO+
   MS1k7yrR6ZKBgE5oE/h1L7k3CVrToGOsP+LY2d1DCqap98Xhd4B4bzunV
   MHpCTNkuQVDaqmrIjn7i7tnc6cMwH94Ma86bVhwxAy6NmirMMUmc9MTCU
   mOdsjOqG+9Xn/gTHoJWJTHEYBc5MWTLCDROEVo43hXHeSMKNJXS5cK34F
   SEtp0epe1zWlr+WI0nsp4gBGchQONPon0HGcYZ1GfwT4nhbB9MEBwF5yV
   /jtMRgzISE06L5ioqwIoSFxVe67BbEMY4zOIvIAFmbrBi95Ub2Hfd3UJK
   w==;
X-CSE-ConnectionGUID: ldxKJ5S+TYSUj0Ea69bEQw==
X-CSE-MsgGUID: 7c3evynCRpqEMCmEok6thA==
X-IronPort-AV: E=McAfee;i="6700,10204,11444"; a="60880933"
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="60880933"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 02:46:58 -0700
X-CSE-ConnectionGUID: VqQ+sJQbQhqNYEy5br3hpg==
X-CSE-MsgGUID: TzhyT2WISWCsORezVAf/Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,315,1739865600"; 
   d="scan'208";a="165494528"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 May 2025 02:46:52 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 26 May 2025 02:46:52 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 26 May 2025 02:46:52 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (40.107.93.63) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 26 May 2025 02:46:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ftXsdNIGOtJ1ra/LD8FKf9oNcz4V14xVZhHweT4hs9YbJ8vEGcg+8PwVpMQ3as9fGEBynzj1+wdFGeLx/u8KRzZm01kTtFYJlsUolOSiW+/ZZZXA5fdI3OepeC5acAKdbpqnLQbbg02gaArWegS2Q5xvIqs5WMBVL693sp8zq0/ZHPwz1WH7NmDDoWw5X+iazW7P0Jpc556h3EwDerGQqg91YHw01Zo8a4tY0fHudq3oZmafB/2At/VEk61PpghE7DIPe8AyweCvm0+eeH9Jes+omnM/dMjmjbzBi4lfLzFrs7GlOTi0mFWorDuww6t3OBK1/C5dlg4DmTyjWDuKcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0Zd2d/5+ebKQ1hMCWCKp9fO3GV+IRLgLaekjQmM/K4g=;
 b=bdoJPahf0BJz8jV8i65WSE9H6na7YR9+U7rX2lmTW5QjWyUohRHO+uge2huJCXRdo+P44l0cWPm2KM18mkGuH8LU6d4JRTjBCRbSs2Da/AFrqQKfWXgnED54LGwhl0Srm3u+5+HEMOFxTJYazHvpUbV3rubUtdIcOORpt4SfuN4iugS91bC4ah1mmEyg2fuUF7EhpFFDzwXTwyOHk94DqENmB255Ruz4su/7ctVgk1MZ73sWeVGF5hDiam6nT50Pp9oKMrHoCfnixQBSCDV7u5ug9JgN2PLO42LAImMVcZ1UfqHkdQlGURtN592uf/W1HWte/3dda2xck0M/WX8NhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM3PR11MB8735.namprd11.prod.outlook.com (2603:10b6:0:4b::20) by
 CY5PR11MB6258.namprd11.prod.outlook.com (2603:10b6:930:25::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8769.24; Mon, 26 May 2025 09:46:35 +0000
Received: from DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95]) by DM3PR11MB8735.namprd11.prod.outlook.com
 ([fe80::3225:d39b:ca64:ab95%4]) with mapi id 15.20.8769.022; Mon, 26 May 2025
 09:46:35 +0000
Message-ID: <a76dca84-335f-40d1-8e1b-0cf43d84b7d9@intel.com>
Date: Mon, 26 May 2025 17:46:23 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 06/10] memory: Attach RamBlockAttribute to
 guest_memfd-backed RAMBlocks
To: David Hildenbrand <david@redhat.com>, Alexey Kardashevskiy <aik@amd.com>,
	Peter Xu <peterx@redhat.com>, Gupta Pankaj <pankaj.gupta@amd.com>, "Paolo
 Bonzini" <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
	<philmd@linaro.org>, Michael Roth <michael.roth@amd.com>
CC: <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>, Williams Dan J
	<dan.j.williams@intel.com>, Zhao Liu <zhao1.liu@intel.com>, Baolu Lu
	<baolu.lu@linux.intel.com>, Gao Chao <chao.gao@intel.com>, Xu Yilun
	<yilun.xu@intel.com>, Li Xiaoyao <xiaoyao.li@intel.com>
References: <20250520102856.132417-1-chenyi.qiang@intel.com>
 <20250520102856.132417-7-chenyi.qiang@intel.com>
 <d22512b9-d5f0-4e0f-9a4c-530767953f3c@redhat.com>
Content-Language: en-US
From: Chenyi Qiang <chenyi.qiang@intel.com>
In-Reply-To: <d22512b9-d5f0-4e0f-9a4c-530767953f3c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: KL1PR0401CA0005.apcprd04.prod.outlook.com
 (2603:1096:820:f::10) To DM3PR11MB8735.namprd11.prod.outlook.com
 (2603:10b6:0:4b::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PR11MB8735:EE_|CY5PR11MB6258:EE_
X-MS-Office365-Filtering-Correlation-Id: 2a474fe0-b070-4dd9-3375-08dd9c3a33c6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cFNpMFMweGhqRXJLeEdLdkVtd3llbWdOT1QvbElMdVAvSEl0VWQwMmEwYmhR?=
 =?utf-8?B?TW5CbmxJemovWUZ4QUJLS3EzUEFQN3JpY2s0UVVFeHZlbVg2YVprMGMxbU4v?=
 =?utf-8?B?OUx5bG9vNU1zTWd2SmZTZU1EZFhNTUNYUGk5cktsckZYS2hPNHlTWXVDV3ZK?=
 =?utf-8?B?UFVCbU12NFg3MTgxV2xuTXFaSDBaZERuOVhVVWRNdzNGaTZ4NnRDTGN6elA0?=
 =?utf-8?B?SkZ6YlVHVmJLNzRWZ1RlMXZvV0duaVh4WjhQRVl5N1FlZEErMTZCWnlJTDBI?=
 =?utf-8?B?VkJmbHk3Z2VwbkZVRmVxc1kxRFU3dmk3YXBaZUtoNTFGZmRiMDgzOFlqQkFC?=
 =?utf-8?B?VTZLMlZsNDJEUjd5a2dOUXkvQnREVFdnVXBDZGxGZlQ3TDJ0NTA0Z1dkSG82?=
 =?utf-8?B?T1h1RDI1UU0wQjVYSmZta3NKbWhpZktBQnRVZ2U3RHVLZ1RTZUVFelVOQkU4?=
 =?utf-8?B?d2lHSld2K3U1YURKcytmRDhZaDRVK25QWjhDT1EzL08zZTdPTU1XQUJ3RnBl?=
 =?utf-8?B?Ym5peHU1QzBiOGNPU3RocTBQL2J2MW9NRkIwT0xwSzhRVkN6SjdnQXdNTnBu?=
 =?utf-8?B?Q3lGblUwMFRLRkNRU01jTU1iZHFjbmZ3cTVTKzgzM0pjZDFoUzBFSXMvWllj?=
 =?utf-8?B?ZkRhdm1YVVRXUjNDRnhaMVkvSDFySXN0R1lSQWdkNTU2L2lyRTMraDhkUnFa?=
 =?utf-8?B?djVvSUg5ZnJrMVJKWHlENGVIa2xKZ282WFllb2gwR3dORnBIZHRNZXhqRjdv?=
 =?utf-8?B?SnY5SFZCaEJTZ1k5Lzl4NXZyYzRDdS85NDVRem9CNlBnUDFpV2VhK3NkTmNu?=
 =?utf-8?B?L1d0aWNvQmpQQ2orK2VFRExGODBDeGtSWHVZWWUrV1d3aEliWllHMUk4bTZy?=
 =?utf-8?B?aU4xSWRCVm1UQklaNW9STVNQQk1zZFNCWGIyUG81Nno4Y2V6eEc2T0hmc25K?=
 =?utf-8?B?eWFpcE5ZRzQ2OUpCajZZV0VJY0dZQ25lT1M1WHRzMjJHbTdKWGRYeGx3ZHJF?=
 =?utf-8?B?T1dtZ2JtRlUxQU84VGpXV1g4MFByYWpQOUp3eXJyNGJEaWlGM2s1Wnh1VXU4?=
 =?utf-8?B?SDdDWW5mdDdzdTh1RmMyL1lYODVWOU1DVVdNRnlBWlhScDU0K3FkRnpod3o3?=
 =?utf-8?B?UmQ3aDJuOUgzZEZleHgvbWNCcVk0akRFSjdTYmw4bDJVQzdCc0VrWXlrQ3Bu?=
 =?utf-8?B?WDA4OG1WRE92MmoyS2hLVVFBcjJERFg1VFFtMy9tNUJDZC9xckl6YVkwb091?=
 =?utf-8?B?bDFqWDdxdDB5VXZ3ckxmYVhZNkREM1p4NXJTQzMrSnVpRnVScDNUU1Y2RUxX?=
 =?utf-8?B?ZU9RemZwRkllMU5lQUVGdkhWZm5IYUhJUm1ZbUtmdUE1TU9pT0RSL2pNK2NR?=
 =?utf-8?B?ZjJqOWxXU1VCaHhuNmtQZFgzRVlNK3pueGRqUDlsZmU1cXhkNm1wQlJWRDR4?=
 =?utf-8?B?NnBjSXhhNElpV3VjaHpzZVJURC9kWXpXTWR0M1Bud3RablFlL3NpYUFhdmZ4?=
 =?utf-8?B?ZXN0TWNFalBJYnRCV0lwS1I4ZlJGQ2F5Y0NVZ3E3STFEWHp5MXhVNENiUVNY?=
 =?utf-8?B?eUZpNnpBMlpsc0svMVdxWXhKd1ljblZaK2ZSaGJuV2JVN2JFbHRlMVF4U3pP?=
 =?utf-8?B?cFhta1IxUU9XeEtKZ255NEpHbG9SdjZYaU5US1lLNDA0V1pDVjN3Q2NJdnNa?=
 =?utf-8?B?VzFJeGpKKzNiTEJKZnJraVJQbURFRDJES3hkeXp4QnpkNmRaVUcwZzk3OGtL?=
 =?utf-8?B?ZlBpRTFVWGlIM1ZQMWhOK0tSMzJjWW1WT0V0UHM0K1BQMWp2cUF5eDArWTBm?=
 =?utf-8?B?RE5QSmU5dElWTENHcDAzYit0YTY0OUJwdzIySGQwbUlPa2xJaXErYTc3Q1E1?=
 =?utf-8?B?c0JjOXdPWmluMWE3UFYwYXpUZmh6Lzl3eEg4ME0vNnQzdm9ERU5JbE1kbEFo?=
 =?utf-8?Q?OtLC/A9O5rg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PR11MB8735.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZFVLZTNucDhFNldGWWVLWWJXOWZUN2tsWFB6WnR2a01hSXVGNXhZNHBybFZJ?=
 =?utf-8?B?T3ZZeGczS1BwMExrbWRTZzJFNFJ3ZFJHMTY5SjR0dStXbGxIN0RMMjNDMzgr?=
 =?utf-8?B?bkF6YnFCeUNuTUxDMHF5S2IxaUpLckxCZ3BvVy9pZVpZTTFhWEpFbi9KRm90?=
 =?utf-8?B?VTJVSms0L3BpN3VWUjhsSVBqWUM5enB6enRJYzNaRGc4cjVuTklIQkRVSE1C?=
 =?utf-8?B?NHFMRlZwRk5CNmZtWmN1R05UdVNkRGx2OFFlZDhRMEkvanBSVmtvVUJzelNw?=
 =?utf-8?B?VUREWFZFRmZZSzNaRlAvY2ZXcVcyU0dLYzVLcDFOZmsxTFovYnVyU3NUdHJl?=
 =?utf-8?B?SGNjTFcyd3hDRkY5R0FrZENic1RNMC8yUjgzaER2N0xoQ0FrRm9SbGgvZ0px?=
 =?utf-8?B?cHlJbjhqcjNVdThmbjNVSENIbitMS0tSYW1rVzd4Z3Q0NmV1c2tOVENrYkx1?=
 =?utf-8?B?bTZJQ2dpYkRhVjVVVnV0NS9vT25vWkVBeVFoUXk0c0g3YVdBMVNzUUh5bGZH?=
 =?utf-8?B?NDlrVTNkWXVzNUQ5S01vdFpCWUIvNmN5ZVBOZDU3R0NHdHVSdGdISWRFOHdq?=
 =?utf-8?B?UlMrR25mR093cDZoRU9qa3JKbVNqMUdxUzlsYjBWSmowVWhwRXVjZHA2R0VI?=
 =?utf-8?B?MFc1c2lISGQ5QTZQNkJlYmhaR1NheXRFSlhmRmdIU3U1bFFmQWEwUDErZyt3?=
 =?utf-8?B?R3Uxcjh6NWhvdnpLOWZzWHdMVWx4dEc3L3RiYlFBanJVVW45TFBCUzhYM1gy?=
 =?utf-8?B?QmJWdjJkekFBZEFrblpkU3VBSDhjNHlkOXBOUnU0OHFiQ1JxUHYwc3FCTVN3?=
 =?utf-8?B?ZkkzUzVXS2RaRUg1OHQrSXptVi9iV3NQUlpXbUNxOG44Z29Pd053UTFCejdi?=
 =?utf-8?B?RmFDS1FnSXRRSTN1T21ST3ByNFBhWG9oQUoyd1BucVNEaFAvSGN2L21RN3Rm?=
 =?utf-8?B?SHJRNHB2R09hcGMzVnkxcndUTS8rYjd1bU96UDJ6NlU3a0hUVlFzZGpOS2xj?=
 =?utf-8?B?MTlFdDM4ZnJpb1pyYmtQUnBEWUdoQmtYYm1FQ0xHbWVNSzNJZitNMStOT1dB?=
 =?utf-8?B?MjIvZ1g4UU4wYnZCNU5IQnZlL1BNMmV2UGVIZ1ptWENFRDdxOFkvb3BhQmxX?=
 =?utf-8?B?M3RQMWJhVytJNWhiYzVPdm5TQ3h4RU9DL2ZmSkp0ZnJQUEpCTVpCUllTajVJ?=
 =?utf-8?B?bEMxbXVsRlFidW1EdlhObHJFTWJFZmFFK0wya1pvZjRvZWthRlV6bWlQR2hN?=
 =?utf-8?B?aDQyeFpkc3YzbDRWZHY3aTg2VkhjUHZaUGdkWERuckNGOC8rczJidy9GbldN?=
 =?utf-8?B?ZU1mcGdQYU13aCtLQmt5RXFFRXF6TXRDQ3lUK1dmMjE1ZkRwKzFSenNkZWgv?=
 =?utf-8?B?WmNFR1JNek41MGVibDJUTHNJblV6czN4YXhGVjVWR0xBeVZtc0xSa3RKcG5i?=
 =?utf-8?B?WFFNMGpwMHlva2tWSm4xNHVKTHBUWXgvSWJkYThNbCtIVTRnLzR5M2REUklu?=
 =?utf-8?B?Zk5Mc2pEUm9USHc5S0FOQ3pvMWgvTGRHQmVzR1RaeFRqNytxL1IyVzZpcGFo?=
 =?utf-8?B?SmRMeVpBNUVpdWtESnVoRTRPVUtIWmpKbXVodENFSHVoOGg5Tmp5OUJtQWNa?=
 =?utf-8?B?V21SVFh2K2QwK2ZBK0I3RzNBNWlLMEN0OVRFcVVtNUs5bnFzdlcxdml3TlRt?=
 =?utf-8?B?bk1BczZSY0VXbmxIaTBKSHRyQ1d5TkNiL2wzbUlmRE1PS2tPbFJrQk1rZnhI?=
 =?utf-8?B?cWRuOUI0QUlFOFVUK1NVR2tTYmY2Yi9ZdkJ1QnpPaDg5aWNERlptcjVSbmRn?=
 =?utf-8?B?aVNXSmhqMCs3Ukc0dTByYlVtWHVWQ01lVGRXQlF0bXpkQVpiQzV6YlVZcnBY?=
 =?utf-8?B?UWxDWnkrdUt0M0VmV2xTalNMbDl6TmtPTm0wVjBNd0JITG96a0NzVDQxNkVL?=
 =?utf-8?B?VUhOYXFNK05hUHlPRE1vb2RaT0RVZTI3aWd0OFZSbVdTZHNXVmJudVZEQmN6?=
 =?utf-8?B?ZjVXeU44U0VRaXpPRWdFNjl5YlVScFQ1NjhBbmluRzFvcXVBVDYzeEdySVdU?=
 =?utf-8?B?bG9nVkI3TmN3aU5wWUxZVEV1V281cEtWNDhNUGxGeHNtRHk2ZE1OZVo2WnJz?=
 =?utf-8?B?ZDdYUXRzZXY3aGhPNi9JSGx0Nnl1c2J2ZFljdW82TVI2RjVWTWg5REZiZGJL?=
 =?utf-8?B?REE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a474fe0-b070-4dd9-3375-08dd9c3a33c6
X-MS-Exchange-CrossTenant-AuthSource: DM3PR11MB8735.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2025 09:46:35.0400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hbglWMcEJtFUctE7fxyltarlZItBCFCSVYBwiDueM1Un5T0P3U8W38ZcfqYD1FPyQBpa2BjjSZ7xz4LBxAtwEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6258
X-OriginatorOrg: intel.com



On 5/26/2025 5:06 PM, David Hildenbrand wrote:
> On 20.05.25 12:28, Chenyi Qiang wrote:
>> A new field, ram_shared, was introduced in RAMBlock to link to a
>> RamBlockAttribute object, which centralizes all guest_memfd state
>> information (such as fd and shared_bitmap) within a RAMBlock.
>>
>> Create and initialize the RamBlockAttribute object upon ram_block_add().
>> Meanwhile, register the object in the target RAMBlock's MemoryRegion.
>> After that, guest_memfd-backed RAMBlock is associated with the
>> RamDiscardManager interface, and the users will execute
>> RamDiscardManager specific handling. For example, VFIO will register the
>> RamDiscardListener as expected. The live migration path needs to be
>> avoided since it is not supported yet in confidential VMs.
>>
>> Additionally, use the ram_block_attribute_state_change() helper to
>> notify the registered RamDiscardListener of these changes.
>>
>> Signed-off-by: Chenyi Qiang <chenyi.qiang@intel.com>
>> ---
>> Changes in v5:
>>      - Revert to use RamDiscardManager interface.
>>      - Move the object_new() into the ram_block_attribute_create()
>>        helper.
>>      - Add some check in migration path.
>>
>> Changes in v4:
>>      - Remove the replay operations for attribute changes which will be
>>        handled in a listener in following patches.
>>      - Add some comment in the error path of realize() to remind the
>>        future development of the unified error path.
>>
>> Changes in v3:
>>      - Use ram_discard_manager_reply_populated/discarded() to set the
>>        memory attribute and add the undo support if state_change()
>>        failed.
>>      - Didn't add Reviewed-by from Alexey due to the new changes in this
>>        commit.
>>
>> Changes in v2:
>>      - Introduce a new field memory_attribute_manager in RAMBlock.
>>      - Move the state_change() handling during page conversion in this
>> patch.
>>      - Undo what we did if it fails to set.
>>      - Change the order of close(guest_memfd) and
>> memory_attribute_manager cleanup.
>> ---
>>   accel/kvm/kvm-all.c |  9 +++++++++
>>   migration/ram.c     | 28 ++++++++++++++++++++++++++++
>>   system/physmem.c    | 14 ++++++++++++++
>>   3 files changed, 51 insertions(+)
>>
>> diff --git a/accel/kvm/kvm-all.c b/accel/kvm/kvm-all.c
>> index 51526d301b..2d7ecaeb6a 100644
>> --- a/accel/kvm/kvm-all.c
>> +++ b/accel/kvm/kvm-all.c
>> @@ -3089,6 +3089,15 @@ int kvm_convert_memory(hwaddr start, hwaddr
>> size, bool to_private)
>>       addr = memory_region_get_ram_ptr(mr) +
>> section.offset_within_region;
>>       rb = qemu_ram_block_from_host(addr, false, &offset);
>>   +    ret = ram_block_attribute_state_change(RAM_BLOCK_ATTRIBUTE(mr-
>> >rdm),
>> +                                           offset, size, to_private);
>> +    if (ret) {
>> +        error_report("Failed to notify the listener the state change
>> of "
>> +                     "(0x%"HWADDR_PRIx" + 0x%"HWADDR_PRIx") to %s",
>> +                     start, size, to_private ? "private" : "shared");
>> +        goto out_unref;
>> +    }
>> +
>>       if (to_private) {
>>           if (rb->page_size != qemu_real_host_page_size()) {
>>               /*
>> diff --git a/migration/ram.c b/migration/ram.c
>> index c004f37060..69c9a42f16 100644
>> --- a/migration/ram.c
>> +++ b/migration/ram.c
>> @@ -890,6 +890,13 @@ static uint64_t
>> ramblock_dirty_bitmap_clear_discarded_pages(RAMBlock *rb)
>>         if (rb->mr && rb->bmap &&
>> memory_region_has_ram_discard_manager(rb->mr)) {
>>           RamDiscardManager *rdm =
>> memory_region_get_ram_discard_manager(rb->mr);
>> +
>> +        if (object_dynamic_cast(OBJECT(rdm),
>> TYPE_RAM_BLOCK_ATTRIBUTE)) {
>> +            error_report("%s: Live migration for confidential VM is
>> not "
>> +                         "supported yet.", __func__);
>> +            exit(1);
>> +        }
>>
> 
> These checks seem conceptually wrong.
> 
> I think if we were to special-case specific implementations, we should
> do so using a different callback.
> 
> But why should we bother at all checking basic live migration handling
> ("unsupported for confidential VMs") on this level, and even just
> exit()'ing the process?

I thought these checks can act as some placeholder and provide
notifications when someone is trying to implement live migration in
Coco-VM. (As this series brought some confusion when developing the
related live migration handling internally). It is perfectly OK to drop
them. Sorry for confusion.

> 
> All these object_dynamic_cast() checks in this patch should be dropped.

Will do. Thanks!

> 


