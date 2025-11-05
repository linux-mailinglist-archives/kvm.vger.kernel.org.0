Return-Path: <kvm+bounces-62069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3DD05C364F2
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 16:24:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6CC6188B079
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 15:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5965333859E;
	Wed,  5 Nov 2025 15:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jS6617Sf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E8B337B8A;
	Wed,  5 Nov 2025 15:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355517; cv=fail; b=jCMfTlHjWNJgNULrpubgK4/79EA5yVTzWxbGqx9a978kGN53cWu4yZdNQIqkH9KqX01+sH3pohI5noz2RHarAjIuEBcGonAdWiqeyC1RAn/qnpp+BXVr/xw5btlm23pHhFGpek5CRnA74NSuYskiv+py1/T43rUexzsZBt+FfrY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355517; c=relaxed/simple;
	bh=lk+65UU4VBbKG1L0noYI3cutbxJHfo80+io+HruK/S8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VVqzRDnOL6uP+1wp7AVfeNlEo+lkq5przIlSemstp6o/mC4C6E3cx6QBuWyz72wNF1l7jfGb0RvLymGaCf1f8WqdSD6C/pzbKEIdyQskNJnAz0hdN2L0D2ozGng0eySMeAZX5T+2Mq7DTDZjYRhLpM6DImkrD2q9dVklzRspSus=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jS6617Sf; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762355515; x=1793891515;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=lk+65UU4VBbKG1L0noYI3cutbxJHfo80+io+HruK/S8=;
  b=jS6617Sf4WtOSP1bvWYFFt5Wt8WZxppgrUr/IvViUBFDzmwOxpQUMcsh
   2XmfPT79FTPJvzfgUyYWWbtHlyRcGczAhSB8lmQPFP10jjCYc8aqyARX7
   X33pWERJe+jf8JD1KNNIhxbxal65ZeNgOvMhRg5lr+j01oM2CKObsxGfk
   QgpjMY1KmTqIk5mfKxQ2LsFdHo9i26nFgQ95DgkEFhCP1kfUfzoZ4faQ/
   iwM3aE8peMTLIp9ayEKc3LXUzC1p1PnOBP9qJjgQaNyvshSCCKQ7zko1s
   EX1SsQPI3D883z9r5mhsRo67F7eVDs/Y97ps1DndHEhRLDq/Myw61ScBH
   w==;
X-CSE-ConnectionGUID: 8ceCDuazRYe9BdzI4DRJyg==
X-CSE-MsgGUID: oCQZgqR1RTKYRfRxD38NYg==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="63677353"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="63677353"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:11:55 -0800
X-CSE-ConnectionGUID: QOp5pKBiRZOXu7AekQTMmw==
X-CSE-MsgGUID: pfTlpRErSRa4AyZW8uiHfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="210957218"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa002.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:11:55 -0800
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:11:54 -0800
Received: from ORSEDG902.ED.cps.intel.com (10.7.248.12) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 07:11:54 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.56)
 by edgegateway.intel.com (134.134.137.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:11:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=y8BbN+7nNm3dTgiWktGPhI9CIE/98ga8V9piLNBLacLLaLSF9SiBlIN8JvJfxmnrwlkMu7TAaMYPEXbS55/GYjRMTEamVY6A0Uiv6esq8H2BYl/wtx6jic9Crisv3vfp3g6GUDmlrIU8ZnAeL68KySkeqLyxVDG2dLGKYvEhWBCMe7xt81V8lhP6tv0LQscha/nG0+K9KPdrdBJr07aNQjMJ1GLAVpfvTtcbKDh/v9PTFsNTr+4dYi5jkOAEsnNwSWE6TzStN1/RGor03DZ9WW2WmCc1DAzKi7TJgCm1DiNCU9ksPcvGYHzCUmILeuGrKPFyDtVuVE15prtfL5IbPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukotbZUfho/Muy5LocCZz85Giiw4AHi5xE9w0QXcURM=;
 b=iXY7BQKc1TfXYa0yqTOhROHiWEE/RsE7Ya9xzyDivhiXvrrVDjtaA09Ji1fiCv+ZRqrA0FA5LQDHVG6Q1/STYuB9IfmpreH8nMe1OanuAMXHR2xWXHNTLxjZ1J8yfquZpqmXghibDT+guLac68HWf53pKuPTT50SgJTzL+W51XfAZiJNkNhfOcFSn5pgzij3lpqt9feIH7VDwjQwcTGRv7IuNU3mft9JT4JrUAij0kFTOwROfMUue/tTWKSdce8ZmyiTIp19qLv3cEyKIkq4HEZbEITFuo5iHB7sbaLpMnh5QNTUmnscDjbyw+4EO1MBvHgKdbh4IHefXKZFB+aCMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 PH7PR11MB8123.namprd11.prod.outlook.com (2603:10b6:510:236::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.8; Wed, 5 Nov 2025 15:11:51 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9298.007; Wed, 5 Nov 2025
 15:11:51 +0000
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
Subject: [PATCH v4 13/28] drm/xe/pf: Remove GuC migration data save/restore from GT debugfs
Date: Wed, 5 Nov 2025 16:10:11 +0100
Message-ID: <20251105151027.540712-14-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251105151027.540712-1-michal.winiarski@intel.com>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0116.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::6) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|PH7PR11MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 750c5eb2-d29b-4fac-c224-08de1c7da61d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?MnpmeGFCOVFJNXkrRnRyRGVmbGFHUXZiQ3V6bG8rdVFoeC9xdXkvcDZRK2Nr?=
 =?utf-8?B?cDJYeHZmOVV5d0F4WGg4WlRYZ0RJejdMUzhrQndCd3JGQS93NTB2b21pTFY1?=
 =?utf-8?B?TFJlb1I0UTdIT0pXaVdnKzZiS0tNMGVjZmhBOGl4dUtGaUQvN1lvZzAybk44?=
 =?utf-8?B?ZEFDSTBDcXI4ZEYyTzl3K3UvcFRkbHM1Z2EzTitCdEpTWHNYbVJIRlV3RU5t?=
 =?utf-8?B?WFMwV1F5cnZiSThKbkx0a0lFdkh4QlZLU1ZrT0RyNnprVjJ4ZityNkdzZ0VE?=
 =?utf-8?B?bytMR3RQa05lUnc3ZXZLMFNMK3RvK0lSZ1I1R3p4NmtzYXhlR1RKcDRSQWt4?=
 =?utf-8?B?cHltdWZKSzNzNWI3dlRabjhTRXZwZ3poS0ZBWU9SOEZyRVVkZDB1OTNpSE9W?=
 =?utf-8?B?U0I4MjdkTzFFZnZneGprZlA1OWl0NXpTM1U5c1BYeWsrN2ovOHdjaFNkTHYx?=
 =?utf-8?B?OURBb3BlRy8rSEowRi91M1dkY3dXalpyVTh5K3NPYVh5OWlTLzY1NWQrL3ZI?=
 =?utf-8?B?a242V0xTWms5UHRuY25PK2s4WEtpNlh0NVJ2MVV0UFJjZVR6T1BCNlFqMXh2?=
 =?utf-8?B?U1BVbS9Wa1FCMFN0aWhvdzJqc0luemZWMVU0OEc0ZW1NamJ3ZUNabklNdm5O?=
 =?utf-8?B?U2UrNXh6d0hSZU9nSENkcERuWUtPQWNKUGRsRWNRSll2bWk4MU1WcHRCYVlV?=
 =?utf-8?B?blo0NVFWTEpWT055K01HaXgvajhjNDVwRzMveVY0amsxdFBXZHp4RjduT1Bj?=
 =?utf-8?B?TXh2dVZVQW1tWWlwNGVWVFZMbWloc2UxZ3RJUVVXTXZYejlGdmJYT0k5eEo1?=
 =?utf-8?B?UGltNWQydDViR1NndFZqcWpzVDFoZWh1S3M4cGd3UUtTTHZXeGJVRHd1WTUr?=
 =?utf-8?B?QzNWZHVTTjNSWTR1dU9ac0hMcFZQbGNIRitUbElvQkppVkZzTDZ2N2RTaStT?=
 =?utf-8?B?SXlJaHR2VURsU1JzbnVGS25VQS8xRWQ3TFFxTFA2Z2VackR4TG42L205ZjVo?=
 =?utf-8?B?TW5SQkdIV2ROT3I2WVBOTnpIdjlxY3duazltS2lqbHp3T2hrOGZKK3BIdG8r?=
 =?utf-8?B?eHI0Vm5mVEthUDhHVktlWlJWdStzbjNEa1M1UzZTQXJTTGo2T0x0cjNHQ0Ri?=
 =?utf-8?B?anM5Si9KaXpaNkpubkIwcDUza2FNZXRtV1NubmZKVVYwa3BNUm02RXZGcVRV?=
 =?utf-8?B?UEZ5c3d1bElMVkIybDgrY0NHRE9wWExPUkZhSDBFVkdtaTBJaVR5cm0rRHVJ?=
 =?utf-8?B?TlM2MGJ0SWlaL2c3YkFEajVHbEF4TEtnSTF2bjkrL0pRMExORXd1M0w4RFJh?=
 =?utf-8?B?cVlkeVk2RHJrQng4UTRrd3BaVWk4WTN1YzJlcEVCREQxSXdRR3ByRlc1bUIz?=
 =?utf-8?B?NGQ2ckRaaFZXRUZFNytJTDBCMFB5aTJmVVN3MmZzNVQwKzBzMHQ1S0xaUWtp?=
 =?utf-8?B?b2k4SVNhWVpkZmZYVVRNUUVZTG41L2pReG5LeXo5VHdhbTMxc3g2R2NNczlk?=
 =?utf-8?B?eUoyb3pRa0pLRlpSOVYzc0FPQU1pbXRTYmpEcGtMbTRaNHFzbmpRenJ0NG5t?=
 =?utf-8?B?WFJBelVHKytyL0JZUDBYSDVCNFlSMTc4ZUhmY3hLc0ZuQW5VWUt6UEtkM1Uy?=
 =?utf-8?B?UVM1WHRnSks5d3FZQTdKbmZtS3Z3L09WeVBscTB0T2ZYZCtxaVUrNlZIY1pT?=
 =?utf-8?B?MVpIOHhZNnJyR0d2YmRSYWM2M3M3S2NsUDZZaFlwVUc1QTczay8yTDY2VDdv?=
 =?utf-8?B?dXhNTlEyRElrRmFMUi93ZHBBT0s2ZkRrQnQ0ZThVd01JNGpMVXhNaW1MOGxy?=
 =?utf-8?B?Z0NiN1Q4eEJkeUI4R0J2MzB5QjMxbzIzTExzek00emZ4Y0NSY1RSK3gwRzk4?=
 =?utf-8?B?NUJjbVRGOEdUWFp5NndCS3YxR243NmtUZ3JvYU5wUFhQR1lHcnh3TEp1WTFF?=
 =?utf-8?B?QWdrWVJqb3laeXZoZkkzR2lBbHNkeGJUVGhxMkQwMkphdHMvZ0M0SkRNNjJT?=
 =?utf-8?Q?/3mQBV9Fnq2BvpdsYqwPcOZeHIQmtA=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z1FrS1M0bThaajRTN0hkOC94TzBtQXZpY0daSnU5YUwzTyswdi95dXZEM3hX?=
 =?utf-8?B?b3E4NEhRRWYxbWFpejNXYnV4K0pHM3Z4NVlQeVZRdEdZZE4rSUppcE9MMGo3?=
 =?utf-8?B?NGQ4NEltWVJBN2lpbEZwbkhIem03SUduS25OODVMVGxEczBwajFUUnYzS0Nq?=
 =?utf-8?B?ckt4V3VzWG8vM0RWRDluMHFEMjRkMjNSOFRkZ00rbnFTc2xWUXdyR2daanhI?=
 =?utf-8?B?UmhOSkZkb3ZlMlBDN3FjWVowWk16RWN2QzVxczdCZTd6cnUxMmo4b1NVWHFP?=
 =?utf-8?B?V3hBMHhYVlhWaExpNjVGdzYxNGV0eUI0b1A3ZnhqeFJEUU1WR0pSMHpia1BN?=
 =?utf-8?B?Ui9RZjE4MUt1STMremxkWmhBdWpzYldrVlBNdGplTHZoZ3lNNEFLdXBtZVha?=
 =?utf-8?B?akVuMWFmZ0RJUmxTWld3NTZmY0lyMC9UakZ5dkswNjhySUl6dXlwbDFCY0d4?=
 =?utf-8?B?ckJOMHhTYVRLTWFGcHBOWWJDT1crWktNZlZRUHJrRjU0NDE5S2wzUW1UcUVN?=
 =?utf-8?B?L3NPK1ErMHNhakIvOVhPVFBvaUV6V2pNNzd3UkVYdzcxdkkxSmVOZm5uMDFy?=
 =?utf-8?B?OWN6TkZXZUYzVXVwbzEycExFRGlCSmRVSmFpNThFSjcweVErM3NwT0o4MWU2?=
 =?utf-8?B?emdhY1BZdGlMQzdnMWZ3RG5SWmNidjBRc1EvWTdRazlvUkxzTGo5enhleGRy?=
 =?utf-8?B?U29hZmNMTisvSS9nYnordFkzK2tMQjNmc2lJTEJ6M1N3Qjg3cW9nQjV6ZzFy?=
 =?utf-8?B?NTNxOUZ1L29MMm4xT21nL3pNUTFtV21zbWhHRm1EV3dUbURKWGN0QlJGUmsw?=
 =?utf-8?B?ZWxrc2gvcjlMaUZJMEtVdDZjaVpReFdNSmUzUVZlS1AxenlsK3o4WGNJRE9w?=
 =?utf-8?B?cCtkQVo4V3VLeUVRblI4SklHZGlaM3A1Tkt5aXR3d2EyNWR4dER3VTlQWjVM?=
 =?utf-8?B?R0FzSHUvemt4djY1WEw0bVJmTVd6SnQzc1V5SWNkeHM4Q2orRHB3ZUxwZG5m?=
 =?utf-8?B?b1RuQks1VGd2MWROc2IySlRITDNTWWIrUVFOaUxGVW1CS0tCSzE1ZE53cHRX?=
 =?utf-8?B?Zm5tQlBBMlFNOUFKTksvMWxjYjlocEduWDVnVTRCQTVSa2pFSmdUZVpJLzZD?=
 =?utf-8?B?TEN4c1oyYmVDZ0RLS0F6ZUpraVFSU1hiM3Vhd3FMcXFES05lenVqa0g1cmVy?=
 =?utf-8?B?Rm9LWkZuRXdOTVRZZHdGSW9ObCtRMTVORlpSZHY4LzljUUpYTDVrRGQ4WHZZ?=
 =?utf-8?B?cWM2MmgrcC9YTHN6dnYwWjcxSE5sM1hGVWtvajd1VEVhc3pxN1BhbXRGa09w?=
 =?utf-8?B?cWdyQVlpSWE3L3hzVzE2dlYxTC9SUWpiUG16Nkl3L0NLT0lWbWpjcWFxWGhH?=
 =?utf-8?B?L0ZuancvN1ptZEFOSmNvQVhjNm5PSHFDYjEzRlF5OG0vQk11azU3dDVHWGFR?=
 =?utf-8?B?QVFzKzlVOUExV2lZd1FxRGJ2YjhWVGMybTRsWXRuMGZ2L1NNREZrMmFpSWFG?=
 =?utf-8?B?cnVOdnpzZkVubCt2RXZ0em9qbERVVkp2WWwvc0svQk9KUXE1Y1cxcnlxbDhy?=
 =?utf-8?B?RGlKOHJ6Uk84MzkyRVJYVmlxQmdtTndFYmtXRzhJVERYOWlENjdDOXZzTVZU?=
 =?utf-8?B?emc2V2FFNkhVbU1XKzJjV3g1dHZ3dzBhWmxYeDlJOEpEaVdybGlJNlhYay9L?=
 =?utf-8?B?TWs1TkxjMUlYaXlrZGZXcXh2aS9tTGQ1K1ZwSVIwMnJBaHhlaEIxNjVDUXlx?=
 =?utf-8?B?RkVZTlZsZXRWSjNKVXZUQ3k2bjNxa0R3WXVnajd6VHhWRTdQTUx4VFNxeFpq?=
 =?utf-8?B?QU1hcFdCRUZwWGU4RGpGb2hIcjN6OURiMFNWaHA0eUVnS2d3TTh4T2hjMVFu?=
 =?utf-8?B?QzdmdXpQZTNNQnBYcmg0MFcvWU0xNU4waVJLS3lXaGwxdVJOWFRYSC9VbU1h?=
 =?utf-8?B?YzRxVjlmRThNL0xsU09oa2tZZ0xLbmV4KzRsTnY2QXJYUUF2QUc0R2RPc21J?=
 =?utf-8?B?TnFacmNSTmRPdGxLZ05zajU5d0FLazNNaTVhSHBNeXBWbW1qWnE0NnA2UXBG?=
 =?utf-8?B?NXZMdXJuY1NoRU45c3ZiNU5zQS9XR2VYeVVVaDR6M0dGOEJmbkRzVWVRM1VG?=
 =?utf-8?B?L01oRGtYTzRDd1pTMVRzeW4vYTJtRG5STktnbnVtTkp6MVkvYVBJZ0tjSU1O?=
 =?utf-8?B?bHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 750c5eb2-d29b-4fac-c224-08de1c7da61d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 15:11:51.8428
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Me5JflxYrcnuQoyTaxb8y+Xty+13ed3IFdPfQ0xEQOD77f48BqOAGzLJFVsmMDi/FRgsGePXay2wplc9Yc+gNOGUnBjV3AHlSqN0TNUPmsg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8123
X-OriginatorOrg: intel.com

In upcoming changes, SR-IOV VF migration data will be extended beyond
GuC data and exported to userspace using VFIO interface (with a
vendor-specific variant driver) and a device-level debugfs interface.
Remove the GT-level debugfs.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_debugfs.c | 47 ---------------------
 1 file changed, 47 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_debugfs.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_debugfs.c
index 838beb7f6327f..5278ea4fd6552 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_debugfs.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_debugfs.c
@@ -327,9 +327,6 @@ static const struct {
 	{ "stop", xe_gt_sriov_pf_control_stop_vf },
 	{ "pause", xe_gt_sriov_pf_control_pause_vf },
 	{ "resume", xe_gt_sriov_pf_control_resume_vf },
-#ifdef CONFIG_DRM_XE_DEBUG_SRIOV
-	{ "restore!", xe_gt_sriov_pf_migration_restore_guc_state },
-#endif
 };
 
 static ssize_t control_write(struct file *file, const char __user *buf, size_t count, loff_t *pos)
@@ -393,47 +390,6 @@ static const struct file_operations control_ops = {
 	.llseek		= default_llseek,
 };
 
-/*
- *      /sys/kernel/debug/dri/BDF/
- *      ├── sriov
- *      :   ├── vf1
- *          :   ├── tile0
- *              :   ├── gt0
- *                  :   ├── guc_state
- */
-
-static ssize_t guc_state_read(struct file *file, char __user *buf,
-			      size_t count, loff_t *pos)
-{
-	struct dentry *dent = file_dentry(file);
-	struct dentry *parent = dent->d_parent;
-	struct xe_gt *gt = extract_gt(parent);
-	unsigned int vfid = extract_vfid(parent);
-
-	return xe_gt_sriov_pf_migration_read_guc_state(gt, vfid, buf, count, pos);
-}
-
-static ssize_t guc_state_write(struct file *file, const char __user *buf,
-			       size_t count, loff_t *pos)
-{
-	struct dentry *dent = file_dentry(file);
-	struct dentry *parent = dent->d_parent;
-	struct xe_gt *gt = extract_gt(parent);
-	unsigned int vfid = extract_vfid(parent);
-
-	if (*pos)
-		return -EINVAL;
-
-	return xe_gt_sriov_pf_migration_write_guc_state(gt, vfid, buf, count);
-}
-
-static const struct file_operations guc_state_ops = {
-	.owner		= THIS_MODULE,
-	.read		= guc_state_read,
-	.write		= guc_state_write,
-	.llseek		= default_llseek,
-};
-
 /*
  *      /sys/kernel/debug/dri/BDF/
  *      ├── sriov
@@ -568,9 +524,6 @@ static void pf_populate_gt(struct xe_gt *gt, struct dentry *dent, unsigned int v
 
 		/* for testing/debugging purposes only! */
 		if (IS_ENABLED(CONFIG_DRM_XE_DEBUG)) {
-			debugfs_create_file("guc_state",
-					    IS_ENABLED(CONFIG_DRM_XE_DEBUG_SRIOV) ? 0600 : 0400,
-					    dent, NULL, &guc_state_ops);
 			debugfs_create_file("config_blob",
 					    IS_ENABLED(CONFIG_DRM_XE_DEBUG_SRIOV) ? 0600 : 0400,
 					    dent, NULL, &config_blob_ops);
-- 
2.51.2


