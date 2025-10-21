Return-Path: <kvm+bounces-60735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 05ABFBF91CF
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:45:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id BD1055044DE
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5C492EFD89;
	Tue, 21 Oct 2025 22:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Hg1Vy8Rx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0093D2D0C97;
	Tue, 21 Oct 2025 22:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086591; cv=fail; b=BSOgai13/V+hJVsMux+3w62N46yQ8mvUZrmZtr2vMrVfq5GXWt6jh0TDJEtuMxOEZI6fGgv3QdSsOJbKFtjo/TYn4jk8gdL1YemZBLv7CzVEchmnmhWbNbA3xQUs0Iajr8sillpNOLLj0RgztXgOzLXVvd2qgBoepaMfgS40NAA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086591; c=relaxed/simple;
	bh=EdAXNdjWD2DIqWyeVawRBVhNvXAbGOngqttWFcfYM1U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GFiCpZvdtP2umJG/7foHWA000dDSaOTehyTUYWMfwtnOkUuJ+cFrdWyZa15B3VcdIqtAj3px9DSkQCWvLPcA4S6IhGLaG/pfP3SMP1i/nLKLFZhPJ5lgcedYjN4MySVKeGRxoYjk6vUztGM2x/ijgPWKszdaQEGJvx4UY4pmHoQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Hg1Vy8Rx; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761086586; x=1792622586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=EdAXNdjWD2DIqWyeVawRBVhNvXAbGOngqttWFcfYM1U=;
  b=Hg1Vy8RxvLqW7Cwvbgzwaul2tU2OzhMsEKVFVxvPrF5eBkVVHVN15Rsq
   XlojBlwVA6scrceI8xv0iHY1aWIZsFvfyzC9RXiqACUqEgLemS86VuYVb
   XzDhSzLpdD+yggZpuy0Sn8rze8Ua7MJNbU9rM9bkQTMNtbTb0vT2tw/6R
   PgwxUGMYNWnk4r4SHg1FBnb2TeezOlyAH9Sj+8c2TtJJ/g4Ww7UjQGf0O
   kzZerqLvoF4DaVU4jslEEb0ys+Ulfe7kobKUQ82UCi2E3eZ2FJADvNlnV
   sAVhTxJxiIikF7iGeJT5bOF1TAjoYw54R11Krii1TI5Vx+beA73c7cJh3
   Q==;
X-CSE-ConnectionGUID: 7D5ad5FLSd2nAzOOfpb12Q==
X-CSE-MsgGUID: /7auMmmTR5Oy+zBZSeG/KQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="73895155"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="73895155"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:43:05 -0700
X-CSE-ConnectionGUID: IDPvQcuwTa25m74cTjGgJg==
X-CSE-MsgGUID: I4V4WX1NQkmjm90o4ME41g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183644417"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:43:05 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 15:43:04 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 15:43:04 -0700
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.24) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 15:43:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TO6oG3SZNs/ku6ZC1Op5X9Q83TwlRoVNa6G2zjIppBQa+yi0fMho1/5UgjJagBYIzACeLf8L8laxcDJV/Q0vizXSgbtP+zJpgxpqi17GbLw74JVUQaaNySgfhq45tCMqrs3Ul4dBvR8Pmaa+3eubRIRDs4syLcwn3nqIqG6uRRjKyFWObln85K91//v7ZgHf7MpyGcj8UX6L4b3065eCKsx0HTvh05y4n/eiZ/PCWnfFhcRFFICtkUMV6y9rX5W3AoBfpHKnaYqCXOvoG+/FiRhoobDZNDc5TIBgjyeZ/WhYgfWIxqU25V+hpr/BlJ54EEC+79A6g8obILX39WEAcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MDJoSS2XNyW8y9XAXq1ngU/Jlj+Bthok3L3e/EB1XPQ=;
 b=x3MUtNMFJ6Jrn40PSLqadTPPwoRM+hJPgTIgBE1vHtNRMPWzuAjKSuhUjeddecb7ICMPxNoZvI2eGpcEvrEr3WFSXoMLbcW2bukG7yU5hIL2JvOLBpYqXiXExefjZdB5UcjlOueTmCxoBvgcbw0rWHkvZ3T+aLA1FGHE41LLhDaq7+z6CoRcU994OzIDx7t670h7IaE1RET/mZ8CMC3WPSQAa+63L4cEp3n56V/+zqPZHTZIjt5fWr1sOTBLFGiljUCM7wIsreuaSX4BXgrv2LhEsO4UThzA0FxFy9FpgHzgCPXI8kPxk3fh02bCv43YourlKvi37KDDA39tPJSCoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 PH8PR11MB6753.namprd11.prod.outlook.com (2603:10b6:510:1c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 22:43:02 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 22:43:02 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Alex Williamson <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?q?Thomas=20Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Matthew Brost
	<matthew.brost@intel.com>, Michal Wajdeczko <michal.wajdeczko@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>, =?UTF-8?q?Micha=C5=82=20Winiarski?=
	<michal.winiarski@intel.com>
Subject: [PATCH v2 11/26] drm/xe/pf: Increase PF GuC Buffer Cache size and use it for VF migration
Date: Wed, 22 Oct 2025 00:41:18 +0200
Message-ID: <20251021224133.577765-12-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251021224133.577765-1-michal.winiarski@intel.com>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0112.eurprd04.prod.outlook.com
 (2603:10a6:803:64::47) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|PH8PR11MB6753:EE_
X-MS-Office365-Filtering-Correlation-Id: f3000140-17e6-41a6-a553-08de10f3316d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?T3VndUlMS3ZxUjZ4WEN5b0l0VzJtQzFabVU5WFpuZERJY1h2NVBUb1p6L2cx?=
 =?utf-8?B?am82aXBOdE1NQ0JwRHl3TEZaNFEyUTNHWGxtbFc4Q2ttQmVHdW9VOVhJVGhr?=
 =?utf-8?B?TUpNdUlhUm01R1A3eFlRckhINnFWRUNBSE1VNHBmNXlQK3JzcmVDU0I2VnND?=
 =?utf-8?B?bUpyaHdjeW5FS25zMUliczFOeEhsQWNrUDdKMjkrL2Z3K0xLUzJHSUNoZ0NS?=
 =?utf-8?B?enA3bDNGNll3cW92UmxBZm8yN2ttNFBYZlAzTWIySGE0MmZqc0lKV1grQ2g5?=
 =?utf-8?B?dVk5czJyUXkydlZrMCtVTVZwd2lrVm5oaXRWR2lQT1p2djcrenFBR2ptRWJp?=
 =?utf-8?B?bXNMaVEwTzkvMjV5RityR0QxTGtkWGo0aFFPbGpvcGcvY2E2Njc5YlUva1Z2?=
 =?utf-8?B?d0c2VmNoRFcwdTc1a2tXQklNYTZLNStUSTVLaFl1TU5KL1liVHNrb2NRanh2?=
 =?utf-8?B?Y0RyeUtIMGFEek1mREhLZkFiaVdZMUtIY1ZNSjlHTU1EdmxVdXhkOUtOb2pU?=
 =?utf-8?B?SmdHVjFqeFh2ZkR1c2dkT3d5cmdTWWZBZlFlOUpjS21tampWV2dwOXpOeENY?=
 =?utf-8?B?WlBqNGs3TTd0eTMwQ0czbCtiaUh2RCtDdm02SW1MSzIwVGxGeldRa3F5Qjhu?=
 =?utf-8?B?dTdoSnpZN04vYjFRY0twSitNSTlxWlRDRXMxOFdJNDBtT0MzTEdCbGlGbUtL?=
 =?utf-8?B?bWtBMHRoMC9LK1ZFT0N3clZNeXU3QVY4Z21iaTZYVUJoY2ptOHlQbzBCdFl0?=
 =?utf-8?B?bjFQK1lueVFkSWJzdUM0RkdpelpyVmZ6NDlvOVZXRldpbTVmSlJkVlFUdFMy?=
 =?utf-8?B?Zi9qazF3OHRFQWRtYWM1KzdiS21WQW9TWVBIYUNrS0FIRmlhYUhmQ2ltRkVp?=
 =?utf-8?B?MnA0Y1lJVzVBRmk4bWJFbURnVXF3dTRTaEJRN01rbVlXUjNWdDBPckQ0RXRU?=
 =?utf-8?B?Q0V5RUVpRnhVRU96MndaQzVWbWdLSFl6cDM3ZDNMKzVsMWtDejVpSys0cGRG?=
 =?utf-8?B?d2svM09mVDhuTktObHNXQkdCWmZqZUlnbE9VUXZmQmU5S2dIRzhQU1UyOU5a?=
 =?utf-8?B?L2t3QXJHNkxxMnNvTzRKM3FEWFBxT3VKSHliNGdwT1YwbThYSXVLc29pSWo1?=
 =?utf-8?B?Y0xtTktFdjNNYkI5WjVoRjJXZUlUK0J4NFhESmhQMmp6SnNudTV5RmROOUs3?=
 =?utf-8?B?SHRNeVBGVUhhWGhyR1lWQUhnTkp0NzR4QVZDU09qeVdReU5xMXkvc0lVeW1w?=
 =?utf-8?B?OFhHSmRHNWFEK0lEb25aTjRoOHg0SHY0bE5CNHl3RHJuT3orMy8yRU0xOXRP?=
 =?utf-8?B?Y1ZjNWRlTGRSUlUrRXZlc0l6RVZsVGcwcFVyYUk4clIxV1I4MnJ6TXo0Vmpo?=
 =?utf-8?B?bzBDdVBsNTdtMTAyaEtNT2xqTmJnSkx6SHQ2eEZqbjlJN0FucTV6RWNDZDlV?=
 =?utf-8?B?ZXBmRjJTbnZlUml4cS93eDF4dEJHMzhlQ3pUR0tmaGNDQThnbllrZElyOTMw?=
 =?utf-8?B?dDdTN3docW9YTGhIZEJPWUdmbUhycWE3ODlqTUZ0YjV4eVBIcWN5ZzV0Rk5T?=
 =?utf-8?B?SCtQajAzNEcvRDNkdC9HeDBKSllkRjJIQnllWDM3ZUhoeENQb2x6ekpHOTVx?=
 =?utf-8?B?clllWFJudVlOdjZTTVZkSVhOeXNlOVgwZWxVYW8rRFptc2dWOHdKK29QOXhk?=
 =?utf-8?B?bkM2OWdDUzd2SEpDMmdNY2ZTN0ozNlk2RW5ic0NTUDRRNG45ZzZmS1RCNC82?=
 =?utf-8?B?aG9obngzUG1lVE9DUU1jSE5IU1Q0M0pCQU91WmRLV1ZSV0FkR2hEbyt3QXk3?=
 =?utf-8?B?VXcvREkyY3NETzB2N2tmUkJ2UWQ4dytYQXNNNE9IbFFrWXJMMitqcW4zUUlZ?=
 =?utf-8?B?alFZR21CTmN6TU95cWU0OUJKak1kS1RWZGNzVXIyWkVFUWpEUE43YlprMlFw?=
 =?utf-8?B?ZGpLNVZRTnVxaTU4RXYzVEpFUTNsRXhIUmxIUXZYbTRvWC8vMzNPZWNtRmlj?=
 =?utf-8?Q?97T1EUNXfMfPE7rlxK3Aamyra8AtPc=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SkN2RkoxMzYwUTFEQU44aUZXQVVzd3BqTElrcXlyL3dEQStidkFOOVdTOVpv?=
 =?utf-8?B?NTA3UTVFR3FYR3dlc1dwd0VWRVBPT2VoNDVJcWxCUTU5b05PUFFZU2V4MHhX?=
 =?utf-8?B?cFVxZDZWbmVnYjYvcHM0R3NGY0xLcHZvdXpacXZJcWF2TTNkaVlkc2Z5SSt2?=
 =?utf-8?B?cmZTRExSUXI5VW4vZUNldklxTHc5UjZYZW9LUXF0NFRSWVFkMEQvc2ZFNHc4?=
 =?utf-8?B?K0lady9kVDBqbG1YVG9KamJkK1FPdTcvZURhMkMrU0lLNkJHRUVGODhxbk44?=
 =?utf-8?B?L3pZeS9CV2ZSMkdiU1lWdGhNbHJOS29TTGdOSUg5UWUycDRyLzVkWW1iV0pU?=
 =?utf-8?B?QUpaa1lYZmJDUVYwUUJrWkU3aG5lWlBYZ0lwWFByWmpHbVlveFdwTjhOeFZQ?=
 =?utf-8?B?Vnl2OHZPRFdLVXF3anIwTGs0VHdiWDZUNXZqSUdGd1ZSNTkrWHZSZkJ5T09t?=
 =?utf-8?B?STZBcklDQ0NDdTQwK2VWcXJ1VjF1NTN6VmJRQSthak1OZlRDSFNsSUtaVmx4?=
 =?utf-8?B?N2x1akgya0x5SThocm50VnlnUDlZMWhLVlVIZFA1T3NvOWpndFExai9LZkV3?=
 =?utf-8?B?Z25LS1hOUGpNaFNQTE1vVGY3a1o5VUVPOGJ0U0lqM0VLZEJYTEVhR3NyMGVx?=
 =?utf-8?B?aXJaTDhZcWphL202dGs1UTUrWGZiUkFIVnJ4TFQ1NFN3d1RlM3ZJaXNBZVgy?=
 =?utf-8?B?Z1RaaXdubG8zaFZsZVNvYlpwckltYzV0eFB1Nk5DSDFXVFBNM2NqR0pGcXg2?=
 =?utf-8?B?V1FGU3ZCOWxmYk5NMHEzTHlMc0U5aGQ1dUpqUzcwczZqdXN6Qk9zK0t6U0F1?=
 =?utf-8?B?bmk2WEFYejFrSDRwVEtLd3l4VnZFaWtGVG5Obi9wZkx3QUVRcUw0RFJyYnUz?=
 =?utf-8?B?QnpDalhsci9nRS9kaGNuZFQySjRMUzZQTUtPRlhuNktUUmU4cmZ4N1RvSitV?=
 =?utf-8?B?WXV3b3Jlb1ZENFFWVE9INDBJZDIrZWNpNDFvbnpDQ3hhU2EvZ2x3dnRqWVhE?=
 =?utf-8?B?OVNuamdoNjFiSEYzYUtEZ3NOcnJQeDN1WnNTUzdhbUFucXJCSzZoVEhUR1Q0?=
 =?utf-8?B?UzBObVdZcmFnRGFjZU5sVTNUbjJZT1VkM2tzMVBJWGNwRzFBVVB3QkNlU0sr?=
 =?utf-8?B?bTBCZWxYZGtFT3dEV0hod0trbjVid0VWVStkREZhZGFNUDRkQ3BXbk9qa0li?=
 =?utf-8?B?ODJvQVFVSEtvRnBJa2FmaGNqY01IZkh2UXJsOUUxakVkNkpXYlZGcWI4RFZv?=
 =?utf-8?B?Zm41eEZnY29xN0xvVzNqa01IWHpRVGh0VUhiOVhYQkQ0YnBicWZBbFh2NWNE?=
 =?utf-8?B?OVkwSUNPL1hQT1hrYlJPZCsyc3RQWklHaEhuV2w2ZGgrVkduNmJYSlYxY2p2?=
 =?utf-8?B?M05OVzNXc29XR25DZlhJRWdUN2pOSFZTWlQ4RUdhQUtSSk9DMmpqb1JPZmJ3?=
 =?utf-8?B?OTJjd2FyRVVBdEJ3RjlOZzI5ZC9jS2Rzcm5TSHpnLzJMUndaaWZLRnVBV2Nl?=
 =?utf-8?B?RGNwTklSNjMzK0QydmlTV2tjNHpKeTNLSklTVEQzdGc4RnZDSkR0d0VHSjB3?=
 =?utf-8?B?M2tGUFdPWlNFS2x2SXorWjA0cWlnWEFZMnREVFhkMEVGQ2FJS0RaYml0TnZv?=
 =?utf-8?B?VHFnTnpIUHM4Z0lFRUx5VHB4MURPUnFWZHpmdTZlS2JEQ0gzRXY3YWFvVEtR?=
 =?utf-8?B?aG42KzJPbk9MeVZPRk9XSzRiSXgwckRzOEpJc082VG5xZGp4SzY5TjRtcEFn?=
 =?utf-8?B?blg2NkhNZXhhb3JxdGJKUDI5WnpTQ1F6WjVxNUNrV3hYWTFOaGgxRWo5SGlG?=
 =?utf-8?B?UmlvczVLS2dXVjBld3Z4LzV1eXZnSStKM2VzK2FqT05WTUE0K01EbDUzUXd6?=
 =?utf-8?B?ZXR4TzkxVk5VQjh0aDZkRVNQUkpUQ21BZmZwbGliU0wxbWVDNk0zSzViMGNH?=
 =?utf-8?B?N01Mak0xc1EyWFU1dHhvWDNoaU16MEdYOVdqWm4xZkxnRDNkNHp3S1Rvc1Nv?=
 =?utf-8?B?R3kzeUo2UnNKdmczWGpkNG94d0FUbmM4SjF5azFFNHNxVlRpR1hFTEhvdTJi?=
 =?utf-8?B?bEl3ZW1Wd2gwZ0NNSy9LRXZaZXJPamNYaGM1RjB1Vms0VlpFbmpHS1FzSGpJ?=
 =?utf-8?B?cklxMHM0TDRVQWtPRDdWOFNCN2g3bWVFcXduVGYvMW1wdTRxYmtOQjREdndO?=
 =?utf-8?B?Qnc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: f3000140-17e6-41a6-a553-08de10f3316d
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 22:43:02.6821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V1O5O42sPvg3ZINWPbdPoPNnUNmnBqlhXLHgxIrOlUE1RwSSuZ16rwbd8aZhpERI2J8YgCyVA8TMZAQcBKVM00hWb3shJPvoi26X/TvOIio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6753
X-OriginatorOrg: intel.com

Contiguous PF GGTT VMAs can be scarce after creating VFs.
Increase the GuC buffer cache size to 4M for PF so that we can fit GuC
migration data (which currently maxes out at just under 4M) and use the
cache instead of allocating fresh BOs.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c | 46 ++++++-------------
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h |  3 ++
 drivers/gpu/drm/xe/xe_guc.c                   | 12 ++++-
 3 files changed, 28 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
index 4e26feb9c267f..04fad3126865c 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
@@ -11,7 +11,7 @@
 #include "xe_gt_sriov_pf_helpers.h"
 #include "xe_gt_sriov_pf_migration.h"
 #include "xe_gt_sriov_printk.h"
-#include "xe_guc.h"
+#include "xe_guc_buf.h"
 #include "xe_guc_ct.h"
 #include "xe_sriov.h"
 #include "xe_sriov_migration_data.h"
@@ -57,73 +57,55 @@ static int pf_send_guc_query_vf_state_size(struct xe_gt *gt, unsigned int vfid)
 
 /* Return: number of state dwords saved or a negative error code on failure */
 static int pf_send_guc_save_vf_state(struct xe_gt *gt, unsigned int vfid,
-				     void *buff, size_t size)
+				     void *dst, size_t size)
 {
 	const int ndwords = size / sizeof(u32);
-	struct xe_tile *tile = gt_to_tile(gt);
-	struct xe_device *xe = tile_to_xe(tile);
 	struct xe_guc *guc = &gt->uc.guc;
-	struct xe_bo *bo;
+	CLASS(xe_guc_buf, buf)(&guc->buf, ndwords);
 	int ret;
 
 	xe_gt_assert(gt, size % sizeof(u32) == 0);
 	xe_gt_assert(gt, size == ndwords * sizeof(u32));
 
-	bo = xe_bo_create_pin_map_novm(xe, tile,
-				       ALIGN(size, PAGE_SIZE),
-				       ttm_bo_type_kernel,
-				       XE_BO_FLAG_SYSTEM |
-				       XE_BO_FLAG_GGTT |
-				       XE_BO_FLAG_GGTT_INVALIDATE, false);
-	if (IS_ERR(bo))
-		return PTR_ERR(bo);
+	if (!xe_guc_buf_is_valid(buf))
+		return -ENOBUFS;
+
+	memset(xe_guc_buf_cpu_ptr(buf), 0, size);
 
 	ret = guc_action_vf_save_restore(guc, vfid, GUC_PF_OPCODE_VF_SAVE,
-					 xe_bo_ggtt_addr(bo), ndwords);
+					 xe_guc_buf_flush(buf), ndwords);
 	if (!ret)
 		ret = -ENODATA;
 	else if (ret > ndwords)
 		ret = -EPROTO;
 	else if (ret > 0)
-		xe_map_memcpy_from(xe, buff, &bo->vmap, 0, ret * sizeof(u32));
+		memcpy(dst, xe_guc_buf_sync_read(buf), ret * sizeof(u32));
 
-	xe_bo_unpin_map_no_vm(bo);
 	return ret;
 }
 
 /* Return: number of state dwords restored or a negative error code on failure */
 static int pf_send_guc_restore_vf_state(struct xe_gt *gt, unsigned int vfid,
-					const void *buff, size_t size)
+					const void *src, size_t size)
 {
 	const int ndwords = size / sizeof(u32);
-	struct xe_tile *tile = gt_to_tile(gt);
-	struct xe_device *xe = tile_to_xe(tile);
 	struct xe_guc *guc = &gt->uc.guc;
-	struct xe_bo *bo;
+	CLASS(xe_guc_buf_from_data, buf)(&guc->buf, src, size);
 	int ret;
 
 	xe_gt_assert(gt, size % sizeof(u32) == 0);
 	xe_gt_assert(gt, size == ndwords * sizeof(u32));
 
-	bo = xe_bo_create_pin_map_novm(xe, tile,
-				       ALIGN(size, PAGE_SIZE),
-				       ttm_bo_type_kernel,
-				       XE_BO_FLAG_SYSTEM |
-				       XE_BO_FLAG_GGTT |
-				       XE_BO_FLAG_GGTT_INVALIDATE, false);
-	if (IS_ERR(bo))
-		return PTR_ERR(bo);
-
-	xe_map_memcpy_to(xe, &bo->vmap, 0, buff, size);
+	if (!xe_guc_buf_is_valid(buf))
+		return -ENOBUFS;
 
 	ret = guc_action_vf_save_restore(guc, vfid, GUC_PF_OPCODE_VF_RESTORE,
-					 xe_bo_ggtt_addr(bo), ndwords);
+					 xe_guc_buf_flush(buf), ndwords);
 	if (!ret)
 		ret = -ENODATA;
 	else if (ret > ndwords)
 		ret = -EPROTO;
 
-	xe_bo_unpin_map_no_vm(bo);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
index e2d41750f863c..4f2f2783339c3 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
@@ -11,6 +11,9 @@
 struct xe_gt;
 struct xe_sriov_migration_data;
 
+/* TODO: get this information by querying GuC in the future */
+#define XE_GT_SRIOV_PF_MIGRATION_GUC_DATA_MAX_SIZE SZ_8M
+
 int xe_gt_sriov_pf_migration_init(struct xe_gt *gt);
 int xe_gt_sriov_pf_migration_save_guc_state(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_migration_restore_guc_state(struct xe_gt *gt, unsigned int vfid);
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 7c65528859ecb..cd6ab277a7876 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -24,6 +24,7 @@
 #include "xe_gt_printk.h"
 #include "xe_gt_sriov_vf.h"
 #include "xe_gt_throttle.h"
+#include "xe_gt_sriov_pf_migration.h"
 #include "xe_guc_ads.h"
 #include "xe_guc_buf.h"
 #include "xe_guc_capture.h"
@@ -40,6 +41,7 @@
 #include "xe_mmio.h"
 #include "xe_platform_types.h"
 #include "xe_sriov.h"
+#include "xe_sriov_pf_migration.h"
 #include "xe_uc.h"
 #include "xe_uc_fw.h"
 #include "xe_wa.h"
@@ -821,6 +823,14 @@ static int vf_guc_init_post_hwconfig(struct xe_guc *guc)
 	return 0;
 }
 
+static u32 guc_buf_cache_size(struct xe_guc *guc)
+{
+	if (IS_SRIOV_PF(guc_to_xe(guc)) && xe_sriov_pf_migration_supported(guc_to_xe(guc)))
+		return XE_GT_SRIOV_PF_MIGRATION_GUC_DATA_MAX_SIZE;
+	else
+		return XE_GUC_BUF_CACHE_DEFAULT_SIZE;
+}
+
 /**
  * xe_guc_init_post_hwconfig - initialize GuC post hwconfig load
  * @guc: The GuC object
@@ -860,7 +870,7 @@ int xe_guc_init_post_hwconfig(struct xe_guc *guc)
 	if (ret)
 		return ret;
 
-	ret = xe_guc_buf_cache_init(&guc->buf, XE_GUC_BUF_CACHE_DEFAULT_SIZE);
+	ret = xe_guc_buf_cache_init(&guc->buf, guc_buf_cache_size(guc));
 	if (ret)
 		return ret;
 
-- 
2.50.1


