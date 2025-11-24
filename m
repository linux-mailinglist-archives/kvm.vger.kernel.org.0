Return-Path: <kvm+bounces-64442-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 7D8BCC82C72
	for <lists+kvm@lfdr.de>; Tue, 25 Nov 2025 00:09:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id AF80A4E72E2
	for <lists+kvm@lfdr.de>; Mon, 24 Nov 2025 23:09:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E908832E157;
	Mon, 24 Nov 2025 23:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gZ5yfmml"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE2702F7ACD;
	Mon, 24 Nov 2025 23:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764025743; cv=fail; b=UsbL2+XsE+MjtyItWFKZuJ4yhg9X8CXk5NfVoDgvdyBH8j3jb1BBJFdJSTewUEFD+fB0Uqbdxo+ykRAiMjNaHaN7NHPmVocybEL8paomnrnlct8B2SnJTguoWWUiWHlKvo2pdvtON0Fyrcog+12zTYQuTsYRLN9AveLmdNIaX7g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764025743; c=relaxed/simple;
	bh=J1KYwj4+QIAssDi6uhjb5GuJJhUlO0ta35sA0vsa+To=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jTFZy+i2iDz7O3nTe0wwr28gM5xXqzP6AjrInWYRQQMM9kiXmXEYfOEP1iin320hIAphZNo1WgL7WoZW7ZDCBhViS7Z4wACm+0r/2eXh3LLN/wJsrYR+rhnEzQg9d+tZOSuZJTh1CJupg5zjXszaIW3W/Al8Z2Az0GTAd8BPvnI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gZ5yfmml; arc=fail smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1764025741; x=1795561741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=J1KYwj4+QIAssDi6uhjb5GuJJhUlO0ta35sA0vsa+To=;
  b=gZ5yfmmlIhjODnUEoNuDA7jffb2EPqDr46s+sRrblV+meHXMYyJ6WH7u
   u6fzK27qF8IGjn5RBUgrR1hZuFbseAIwDcPdxRuuh/KMyhoxJ19+HuPYD
   5TJkHZxDdYZuEAY+5b1K8voHHZnJHeZDYk6dh/XNRY/QdqDy1yr5WZlNt
   ETAvP/Og8TpYT7SO3nYzNIAhIcd4yitFCFyRJhtQdEp6pYzLi5+UlzmJ6
   guvpOAr8T973CXDUcz1wX0NDu7NTBPp3chvqK3YCObP9y3mQBURpgJZbw
   TvRNI6v61N61x+xPsZ8bTNMutQs1CiPqfWQGLxEaE+qvbz8uNkUSQUfwC
   g==;
X-CSE-ConnectionGUID: 2j8boXEFRFGM5UlVk4q3Kw==
X-CSE-MsgGUID: rC5EL04uT1ChjWpqghtmew==
X-IronPort-AV: E=McAfee;i="6800,10657,11623"; a="65923787"
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="65923787"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 15:08:59 -0800
X-CSE-ConnectionGUID: n6rGq6MUS/qszQps4u17FQ==
X-CSE-MsgGUID: Mz32LffFQuu13Hf30OElHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,224,1758610800"; 
   d="scan'208";a="229738992"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2025 15:08:59 -0800
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 24 Nov 2025 15:08:57 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29 via Frontend Transport; Mon, 24 Nov 2025 15:08:57 -0800
Received: from CY3PR05CU001.outbound.protection.outlook.com (40.93.201.64) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Mon, 24 Nov 2025 15:08:57 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AMBSOBORIiy6wdmeDTLEPP0/CaO9f9rpk0IbIMae+NPrK2LKoMV9oZW1uLNQkmjYbro5CUZbeawqL8Sg3FwXq7uohaQiiYN1fBELAVW/SP8h4JkuHjBxcYhUM6wmCNNP3P8d8yw7Dc8ynHbYA9v4iD1WueG8XOPBroRQqDe9aNzzmFHLLXMm5NxJTsK+wVkWv4kSweYhWdk4Ifa9LZqXM+gbgeERHV7zMzf2zNHbSW+EMseMJGlUKs/HfwD9DFoTHJmdCXnS2W7xILGGnNlRSCWqb0AQZ+Yw8+q/d2evbbKXGQ4hM9u5ComacZKv86yizuuiryLRsogfrOiC1LGy1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z7SZPFtmgW7HYpXxa2YAc0lcBXh3ZUX8ym/Grhc9bk0=;
 b=jV2bQo/cr28wcIRKkRfPVPjeyRa2ALxF1QAz97q+QhIjRNd8nqBzgLVbBiEf/Z8ScNOZ+TbDaqSylFWhXiqxK1okYji3YZyuS2RgQWVCjvWU6dBrO1uXUYTeFLZk5ddH8ZeAkyuqSfeXwAnuzzpNTg7uQ/OwXagK+5Q7bqp+AQsrpT9UWrUq3CJeN7LD8y5peluIuKbvaKxiy0/6JSPvEQ9qsQ/pglAbBxeYx/QBAcDJXItkgl3oVh52jOmDeNyMpHCYgHoP3oSFFWiu/6M9cFDn0UT+wmkcen0qN6RoX5yJbL7xgQiUIl8+q5XiBTkVGjEQWTVUng0IwVJMM2t2kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPF9EFFC957B.namprd11.prod.outlook.com (2603:10b6:f:fc00::f40) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.17; Mon, 24 Nov
 2025 23:08:55 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.016; Mon, 24 Nov 2025
 23:08:55 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex@shazbot.org>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, Shameer Kolothum <skolothumtho@nvidia.com>,
	<intel-xe@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>, Matthew Brost <matthew.brost@intel.com>, "Michal
 Wajdeczko" <michal.wajdeczko@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, Christoph Hellwig <hch@infradead.org>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH v6 1/4] drm/xe/pf: Enable SR-IOV VF migration
Date: Tue, 25 Nov 2025 00:08:38 +0100
Message-ID: <20251124230841.613894-2-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251124230841.613894-1-michal.winiarski@intel.com>
References: <20251124230841.613894-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0102CA0006.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::19) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPF9EFFC957B:EE_
X-MS-Office365-Filtering-Correlation-Id: e7c774bd-d5d9-4b51-fd83-08de2bae7124
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?aWNWV0RiTHdPN0pKditTWUtZRDY2bVc2bGNkdENmL3dzYlNHOFRLb0owYm5x?=
 =?utf-8?B?K2JFL2hWZkZCNUROTVhkZU9wa3FSSkxsaFhDMGp4cGp3SGdPaHBKL25DUXBX?=
 =?utf-8?B?bkZvRVFDUWN2QnBWcm5tOTJESUZzeHlXZFYyWkdtYUNsa010dEZkYWN2d3R2?=
 =?utf-8?B?WDVndERwdFJHMU1xN2k3cXB4L0tLdDVmcUI4OGsrL2tJRkdRc0srWnNJQ0pU?=
 =?utf-8?B?TnYzcmtpMmJ2UHc1MTZoalFMSEtUU2FEb1FWb215clk2SmVCNUtybVZSNWZp?=
 =?utf-8?B?U05MYU1wRUQ4RFNCN2dTMjA3ZmZEVXZEZEdmK3g1L1hhV0FrVVgyTzFVQTYv?=
 =?utf-8?B?ZEZtdnovSzV1RFBmNjZVWWR5SkVhdjZ4RHhEc2kvdUtZZHdacjlrMldzcjBC?=
 =?utf-8?B?TVRUdzQrRG9GdVNLRXd1ZGdVUHQ4cXFRVzVxVW50S1BjbjQwSDZ5QUxGdDNP?=
 =?utf-8?B?a05RWHZvazMwMVlnejVaZnA0OUNRdmpwVHdxZGxvbGlkUU9kQ1YydEVxREFH?=
 =?utf-8?B?Z00xRWVDNXFVZFVWOVIzd0REOEZ1K2thd2IyQkxqZ2tEckxnT3ZvVVR5TjN6?=
 =?utf-8?B?eDl5bzZFN3lGQXVRa2VudWN2QUUxUWVEeC9KTEZXdkJwdTNUS3VZbm5ZbXBX?=
 =?utf-8?B?ZTJCeVJhOGR0c1YvMHNiSldOdFdxUVdyWXFaV3hWdkV4RXY5YkpVZ0pOTDZ2?=
 =?utf-8?B?SW1oY3AvdFdDQXQ5bXRsc1BVcGovRm1tZFRpVk5jTU9uWjc5TmNEdCt3OWJR?=
 =?utf-8?B?S3Y3bzZOaVhLWVg4ZG4zNTFsL2lsSHRyRWl6M0hiSDN2YnFhSDBBTmUzSFl2?=
 =?utf-8?B?Ym9NUGhVSWQrbDFZREJVSElza0F4d3hIbWx5Qm1BNjh4bmYvSno3TkZTdkI0?=
 =?utf-8?B?akVJMkFGNjlBV2RXQk1KTkNtOTBuczFXaGFDZXpEQVNUZWNkQUFDaElFZUlM?=
 =?utf-8?B?anBrY2xkQ3EyN0x0SEVwaTRKdmlIZVN4VmV2NnkrbnZuTnNzcGJJUUxwZHVa?=
 =?utf-8?B?bnBZbjUreUlTREdOTzljL2xBcFV2aFpnNkxVbHNHdk5MTlg3OThpWkJyNDNh?=
 =?utf-8?B?b1JqWFFWZlBQZGd0NVQrOS82MEMxM0wxTmZsYnpuTy95WkxXTmpQRXlIL0VI?=
 =?utf-8?B?VkI3Z3ppYVoreUNKM3ZUS1NnSHhzWjhycWtTL1RxL2w0M1ZJRVFrTm5uOEhP?=
 =?utf-8?B?L25uVk4reXkxaisrS0JpblBDZkEwNlJ2S0VObklPMkRSamJxZTl3NEdwMjNG?=
 =?utf-8?B?czdhM3hKb3JycUxBeU9QVlpNZHlMM0puMUNtYWNaWVVxb3ZzbTEyOG5SdEdC?=
 =?utf-8?B?cStMNmRlRnF4dTc0bWltUW55SUF5YlJrRXdzZkR4bVcwdHBXaHdoWTVENzBK?=
 =?utf-8?B?UEVYckFRYVBkZWE2Q2srWXR2ZVFvM3VzcnRvbDA2YnVtbkJ4cDlxNFE4a3pS?=
 =?utf-8?B?TjJwcHhCTUlxdXdCZVJTM0lBbDFqcmY4YTFoZXlqNG5BNmhGVHNackRBeW94?=
 =?utf-8?B?OTF2dHVTdjJWR2F2a3ZJRWZjODBjMlg3blV0d0w5ckVadGtCb3pwRlAxWE94?=
 =?utf-8?B?NjJvaEZTRGx2U0xaWEFzTUpxcklWNzFGOEp6S1hvUkVLYlVDamFhL05reUhK?=
 =?utf-8?B?MFRnaVB5RnJRRU5ScUIzSHZFbVFUUHN2MjlEOWRWRUkyQ0xUVjlocFVkUHpV?=
 =?utf-8?B?STF2bTJNalRuYkpTeTNBSElxWjJNdXV5dHlySVkwM1ErcHlRRG5DblhGS1Fw?=
 =?utf-8?B?ak5EMEEySDNnTS9ERmZseGJEOTBJUWY3dHdpU1ZCQmxWbjFGdSt2SElQdnVs?=
 =?utf-8?B?aXUwZnlFdThmejF6bGpsbkZjSW5NNGdhQlJNMFJKYS83Y0ZKQU5SanI5K3JB?=
 =?utf-8?B?Yk9DWXF0a2E0QUo0dmxCeWVVbWRlY3NOamk1dzFSamdSMklKT0JXYjRlSmls?=
 =?utf-8?B?LzFremdybnV5RmRmT1N1QjRZejdSWDJ0TzlQL0Z1azVROGhXTE9yRHoxK0pH?=
 =?utf-8?Q?eQKowwZW/CHUcyXwvFTlK3lP/pwbzg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L0ZJWU42NzRKN2xQT1RHTTM3akh3ZEJxZmhtM1M3QUpvaE9iT0h1S3FXQmJM?=
 =?utf-8?B?OHMxZ1RQOFJ5UW5MdEVHcWprWjFwYkhWakhrY0JlZ0FqangwL2VqaVRYZUt6?=
 =?utf-8?B?MzRaZHhXT0dTbVVZMFVla2NKVDNMVlp4YVJQckFJVjBOc3VSam15d3JucHJ5?=
 =?utf-8?B?YnNaRmRhVU52dDRYRVdPUSsvenAyQm4vb0RERXI0VlZjSzhLaDE0bmJlelAy?=
 =?utf-8?B?aVJtS05vcTR3VXZKNjFxQzRjR0FuR0Zzdm1CbWpYZzFZU1d2YzhQeUE5QmhV?=
 =?utf-8?B?ZUp3aDdKTHlMNysvendrNHN3OGlSaVNCWVZ0VnVRbUxVMlBKSmNmaVBzdUFT?=
 =?utf-8?B?SkYzZWR3bi9pYTVMVDlUbnhrODY3K2JDV2V3dTMvK0I4OTd6OWdkbHdsTGdK?=
 =?utf-8?B?R0lrSkJWcVczRkFqbmlzeVlXamZLNFovZzc0S2tvVGdYUlJjaDg2VVl4MnBG?=
 =?utf-8?B?RjdQLzdRYXg3Tk93UlVHUFJNZTU3WFoxRVJybWlxOUQ4bXl0Y01hbXI0MUdW?=
 =?utf-8?B?TEE1R0ZzaXJCQU5EYXFRS3VlOTdDUTlZczVOeHgxMzlUWU1EOFRaN0RLWm1S?=
 =?utf-8?B?Ukt6S0lGcXhKcGxRa05NRkRKNTBOREl2WnkzQVNnczlJUWpMR3QxYU5jRk95?=
 =?utf-8?B?RUlzT2N2TVNjOWlXZVNHZlJYT09ZL3F0dmRVVDZqckxxT1pZR2pXWGxUU2Q0?=
 =?utf-8?B?S29tRXNCOUpXcGJLU3R4eFZ1b1YyQ3R4NTREMXFxeDlXamtGN3VkcFpHSjFk?=
 =?utf-8?B?QTRRQUE2WDQvMCtjbTlVTE8wRVR3NEFYRHI2a2psdVF2S1JCUFRpLzZEb2th?=
 =?utf-8?B?R21PY2tCdVRzZUtxYytnR0pTaXd1WFBUbjJhTytsYVdJTllCWExsY1JrNVJB?=
 =?utf-8?B?T3EwTjVMd0R5UkZWeTJtK0YvOG03dnZJakFBQW1CM3lpcll1SlVjb1RCMElG?=
 =?utf-8?B?N1VSS3N5Sm5JOEdWRS9BOUNuazh5T2pUTFFldExtSEVvMUxrNmsyMVMwTnBv?=
 =?utf-8?B?bUJsWmppeGhVM2dSSjh6ZHhnb0NsVC90LzROVlpRS0QxOU1zY3BRWm9RZ1h1?=
 =?utf-8?B?YW5WU1YyQW1WNlhpS2R5QUxLeU9xZ0ZiYXM1YU9aU1NsWm9BM0FiVFhLQUY0?=
 =?utf-8?B?SUtWNVN4ZFhEYkRTNnlMVE9aREVtb0VMeVdDbTBqaHBsZ1ArV1RsNHNvM21s?=
 =?utf-8?B?clg0WGc1TFZ0bjI3RVVTb04waEJTckdET1RmbEZuR0wvTlhBd1dZKzFVTkNv?=
 =?utf-8?B?RXFqNDA4MGh4MWJEL2lTaWZmM2taTFliQ2pMZk54MlZDUGR4NFZwL1ZKTngw?=
 =?utf-8?B?eWw0cHZHOW9jYlFFOHNnSkc0TE5GL2huSnE1VkRwVEd1Y01GZHhpZWladjU5?=
 =?utf-8?B?ZGdEOHlrMUFybmRCVGQvUU1rbk9pMVR4bitpVExpSHhQS2xBTzNnVHhsUjVi?=
 =?utf-8?B?UnpjMmo0N29DVXFZc29CN0U3RXFRdHBYNmZmc29mamtXMExub0NUenRrSm9x?=
 =?utf-8?B?UE1YZHVDQlpxK3lvWHZrWGdZWHd0S01VL1ZucXNVZkxYUkpGaTBENUNuZ213?=
 =?utf-8?B?MWZzd3gzanY0VDZaNGRpWmswSE4wY3BORnAxQnBidmNuNHNIdHB3NGYrMTFG?=
 =?utf-8?B?clFka0dzYnRJQ3lXSEovbzNzYm96d2pFbDcwTC9HV1FvMTdrRkV1WnQ4UXc1?=
 =?utf-8?B?Y3lMd05wbDQwcUZGNjkxS1h2cVNpY2RneEdQVE9xVnhZdVdCMXJJTVNpeHNJ?=
 =?utf-8?B?YWxEb012VTczbVdtY1AvaHBqL05yT0RkVktLQ3lCRzBYR3RUQ0VaOWZjRkZj?=
 =?utf-8?B?MW84cm9ISXdqYjNGbnI5bmxJVThYS2lIdElVYVdjOURyejVCNW84dUpOOGdz?=
 =?utf-8?B?REE5MGpsTlFtOU1VVGNOR2Q0dzJQOGlOWW1aSEZndjBKTnY1TDJVajFBeEZ2?=
 =?utf-8?B?K1pNTDlTQWUyWUh2T05jNHBRQ3owZmx1dE9IeWdqREJZNGdVUmtVUDdmdGU0?=
 =?utf-8?B?QWxZejJQZUpvNmszVTd4UUpYU1l1MFlYaGhLenlqWE5NUENmSmdiMXM4cFFz?=
 =?utf-8?B?Mm9veTdEdG05Skk0Uk51OVlRWGFqK2k2eWJIWEs4ZnQ3ekErVCtxdkhXZlE2?=
 =?utf-8?B?TmJuM1FxNXJZeUcrN2sxWFRLaXpCVXoxWm5pL1NXUWhRYm9YYlVEcnA4UDF3?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c774bd-d5d9-4b51-fd83-08de2bae7124
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2025 23:08:55.8012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ju2xCxzYfA/VbGEd3utjo9LzYb1FKdd00SWuuWhKZwt/hgV9GTkpr4mj2s2DvHMDwkOkUxJhUqb2O5kxjxun+ZrAkySXyX2KuNOPj9/wFzw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPF9EFFC957B
X-OriginatorOrg: intel.com

All of the necessary building blocks are now in place to support SR-IOV
VF migration.
Flip the enable/disable logic to match VF code and disable the feature
only for platforms that don't meet the necessary prerequisites.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c |  9 +++++
 drivers/gpu/drm/xe/xe_sriov_pf_migration.c    | 35 ++++++++++++++++---
 drivers/gpu/drm/xe/xe_sriov_pf_migration.h    |  1 +
 .../gpu/drm/xe/xe_sriov_pf_migration_types.h  |  4 +--
 4 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
index d5d918ddce4fe..3174a8dee779e 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
@@ -17,6 +17,7 @@
 #include "xe_gt_sriov_pf_helpers.h"
 #include "xe_gt_sriov_pf_migration.h"
 #include "xe_gt_sriov_printk.h"
+#include "xe_guc.h"
 #include "xe_guc_buf.h"
 #include "xe_guc_ct.h"
 #include "xe_migrate.h"
@@ -1023,6 +1024,12 @@ static void action_ring_cleanup(void *arg)
 	ptr_ring_cleanup(r, destroy_pf_packet);
 }
 
+static void pf_gt_migration_check_support(struct xe_gt *gt)
+{
+	if (GUC_FIRMWARE_VER(&gt->uc.guc) < MAKE_GUC_VER(70, 54, 0))
+		xe_sriov_pf_migration_disable(gt_to_xe(gt), "requires GuC version >= 70.54.0");
+}
+
 /**
  * xe_gt_sriov_pf_migration_init() - Initialize support for VF migration.
  * @gt: the &xe_gt
@@ -1039,6 +1046,8 @@ int xe_gt_sriov_pf_migration_init(struct xe_gt *gt)
 
 	xe_gt_assert(gt, IS_SRIOV_PF(xe));
 
+	pf_gt_migration_check_support(gt);
+
 	if (!pf_migration_supported(gt))
 		return 0;
 
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
index de06cc690fc81..6c4b16409cc9a 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
@@ -46,13 +46,37 @@ bool xe_sriov_pf_migration_supported(struct xe_device *xe)
 {
 	xe_assert(xe, IS_SRIOV_PF(xe));
 
-	return xe->sriov.pf.migration.supported;
+	return IS_ENABLED(CONFIG_DRM_XE_DEBUG) || !xe->sriov.pf.migration.disabled;
 }
 
-static bool pf_check_migration_support(struct xe_device *xe)
+/**
+ * xe_sriov_pf_migration_disable() - Turn off SR-IOV VF migration support on PF.
+ * @xe: the &xe_device instance.
+ * @fmt: format string for the log message, to be combined with following VAs.
+ */
+void xe_sriov_pf_migration_disable(struct xe_device *xe, const char *fmt, ...)
+{
+	struct va_format vaf;
+	va_list va_args;
+
+	xe_assert(xe, IS_SRIOV_PF(xe));
+
+	va_start(va_args, fmt);
+	vaf.fmt = fmt;
+	vaf.va  = &va_args;
+	xe_sriov_notice(xe, "migration %s: %pV\n",
+			IS_ENABLED(CONFIG_DRM_XE_DEBUG) ?
+			"missing prerequisite" : "disabled",
+			&vaf);
+	va_end(va_args);
+
+	xe->sriov.pf.migration.disabled = true;
+}
+
+static void pf_migration_check_support(struct xe_device *xe)
 {
-	/* XXX: for now this is for feature enabling only */
-	return IS_ENABLED(CONFIG_DRM_XE_DEBUG);
+	if (!xe_device_has_memirq(xe))
+		xe_sriov_pf_migration_disable(xe, "requires memory-based IRQ support");
 }
 
 static void pf_migration_cleanup(void *arg)
@@ -77,7 +101,8 @@ int xe_sriov_pf_migration_init(struct xe_device *xe)
 
 	xe_assert(xe, IS_SRIOV_PF(xe));
 
-	xe->sriov.pf.migration.supported = pf_check_migration_support(xe);
+	pf_migration_check_support(xe);
+
 	if (!xe_sriov_pf_migration_supported(xe))
 		return 0;
 
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration.h b/drivers/gpu/drm/xe/xe_sriov_pf_migration.h
index b806298a0bb62..f8f408df84813 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_migration.h
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration.h
@@ -14,6 +14,7 @@ struct xe_sriov_packet;
 
 int xe_sriov_pf_migration_init(struct xe_device *xe);
 bool xe_sriov_pf_migration_supported(struct xe_device *xe);
+void xe_sriov_pf_migration_disable(struct xe_device *xe, const char *fmt, ...);
 int xe_sriov_pf_migration_restore_produce(struct xe_device *xe, unsigned int vfid,
 					  struct xe_sriov_packet *data);
 struct xe_sriov_packet *
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h b/drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h
index 363d673ee1dd5..7d9a8a278d915 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration_types.h
@@ -14,8 +14,8 @@
  * struct xe_sriov_pf_migration - Xe device level VF migration data
  */
 struct xe_sriov_pf_migration {
-	/** @supported: indicates whether VF migration feature is supported */
-	bool supported;
+	/** @disabled: indicates whether VF migration feature is disabled */
+	bool disabled;
 };
 
 /**
-- 
2.51.2


