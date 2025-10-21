Return-Path: <kvm+bounces-60741-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 16A7CBF91E7
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:46:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 241873560C4
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:46:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 876522F8BF0;
	Tue, 21 Oct 2025 22:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Rz85gu2W"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC462F7AA8;
	Tue, 21 Oct 2025 22:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086617; cv=fail; b=aNFP0STSUKQzZPrPeg+xsVFr6LMDcG3LofrXd+27cVYhV7OKthVwx2MZ+GBuywheaHpPBSrRNDmN7np/RgRqtqYC9zsj0mXdGFQeZJhxhwEgDz0lu78AFqjTPTJFproDxJBhH2v6fO8Wj0nispEMZmDMoD0Mdmu2cgKHFLpIjN4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086617; c=relaxed/simple;
	bh=Tgbejy08OphQtC8W7zcbHBPINxjYHXBxlW6Jgh+9LeI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t5ZOvGJVelucsE5Sy/oEH/+a1X1Da8Tl1+DONJ5haEEE3B7wnLYpSggvM8L0c64TCA8SxtJNxUiYpOdTvVb8MjI+d86ktPBv/BVTc92uf5/mhU1ak2A3/VT7jbnwcqBYjvm4BB15JyJv5wAx/2NK73whdDaknSutrjJN3qPQ8zo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Rz85gu2W; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761086616; x=1792622616;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Tgbejy08OphQtC8W7zcbHBPINxjYHXBxlW6Jgh+9LeI=;
  b=Rz85gu2WrQP7tEk6NQh/j6WqLyx0Juh9B82LBlVVOvhlLGPRVG2CFnbY
   AA9Up9uv58JfopUd1AF9mRmszX/7evNyuT5H0WFN/dqRpaJT3Zlz5fihi
   V7FKVU3UYwA0nyvHq0THuQ8O+5Ii7Y0OnjEsZISsL716es7vCUO/J35xI
   RRTbNWO6kk6/5ujFQx/DvNoSC5Ueb0c9wmGAIGOlPC55D3DcVFQ0l+LLy
   kpcq2IdEDiX+OxJQVBtD0Z4XT5Owdg+sAoir+ocPJt7mRiBKr3VwxCeAq
   gOrxBHHIdnnThRcHGNltUTRTHGLgrCqHKfRZ/7O48RFuL2ppANVWPtjVK
   g==;
X-CSE-ConnectionGUID: eLjmHMPDToqFTVoatxSmkw==
X-CSE-MsgGUID: Nkt3lorWT+mb7obGz2a2vA==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="67061040"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="67061040"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:43:33 -0700
X-CSE-ConnectionGUID: K5JQTEM/S6+VhZRthbYaQg==
X-CSE-MsgGUID: sPaT4PEcQ9W5e5hHR5HtLA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183410247"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa007.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:43:32 -0700
Received: from FMSMSX903.amr.corp.intel.com (10.18.126.92) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 15:43:32 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 15:43:32 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.56) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 15:43:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=ccbDY9Dt2H2+N7Zdl+7Xr5bs5cE8Xq1+69l3UPmAlgI3CbXYDMnmhNp22oSfy6RH1JUghFoFQWElxWbulmXyMbsNSx8uByL6WxvJRwPRozSsxaBCcjrSFoAkXmHbeqDtJ8ZUfEFRoH9IYXBD4AXW5aEnpa46sv0bBAJCCWmzGO7BdHbKjKcUOhzewOMxLFgVEWHD+CCVuIT8lXdX96dNaFdrgsDtFYwm4sVQfi5c85s+rrnr/JunsUHE1ZwRnfTcQhaN33qOXf9xERTg9zeUGLvV6qKyMohCuiy2zrwPDs5uJ/YlDP7XCvn+QqRRPJgaxe21KY0RYdSEd7mw8eHdvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Qa5w5T8djEhnbwB5LFCx05Nhtl7hSkFyuR5+0S92bI=;
 b=F0iVw5c8RMKF2i7Ypk7LtpqiiP+9e6t7FoMV9g5u7jb+bQ2CVvwM76WO08fDeUJbgJyOTFfY7tObPxGq19yiRo0VPCWJRSBewgMsxofxXxkF15BQrd0zG8LhJbCEce7AYRQ3prVEZTTnwbVNlytJmCVE5mRmgrHDvo6MpNQcAGYO8FuUyb//gbJld3f5/nKVRLC+ts6I9mCrBnISF/z1vBv1rKO76mKsourw/WgOIPfi+nm3PCdOJrjvAKXh0pTzTxc0B2fhwRkEOAkiYTq1Yh9VDvPhmXml0ghNzl+0KXCTYs/1meoKVvyELHRrwwrISD4TtvogJrc+l2BYUnaMiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFF28037229.namprd11.prod.outlook.com (2603:10b6:f:fc00::f5f) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.16; Tue, 21 Oct
 2025 22:43:30 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 22:43:30 +0000
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
Subject: [PATCH v2 17/26] drm/xe/pf: Handle GGTT migration data as part of PF control
Date: Wed, 22 Oct 2025 00:41:24 +0200
Message-ID: <20251021224133.577765-18-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251021224133.577765-1-michal.winiarski@intel.com>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0102CA0092.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:15::33) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFF28037229:EE_
X-MS-Office365-Filtering-Correlation-Id: da23adb0-a4ce-4133-f124-08de10f3419f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?OTNhUVpiWHlhQjU4QkZVTERWZUdwVGlYWis4aU9tSk5rckV2amRWb3pVTGs3?=
 =?utf-8?B?dTlKM3M3Z05uNCtxYTFJWVpkQWtwem45bS80VGpZcVRFb1RMTFdVd0xETy9n?=
 =?utf-8?B?SUd5RWRkNCtDY044aTlURi9nZS9oKzV3K1VENXhPSDV5OTY0cEhrNEsyS2FY?=
 =?utf-8?B?eThRZWJwakNoNktmWXc0ck8yaVJZS3EvSmpvdDVNdWt2eDN4YWlKWTlRd01X?=
 =?utf-8?B?TDJibHVTVFBPdjN0UDlUVk9BanR0VHFPNjdEdlZtK3Q1cm10MnV6MlBleS9q?=
 =?utf-8?B?b0lyVmJjdVRFWEJuVTJQZDRnUmtwcllHZTdxSUJDcXliUnRvZEluQVkrRE1R?=
 =?utf-8?B?bTN6OGhIMGFmL3ZLWS9wTzlWNG5KWmFyVGphdXMzcG95K3pQeEJJTTZnZFVO?=
 =?utf-8?B?VE9jdyt5TkwyN0JnYURLa0lGRWh5SFZFaktobkMwajdBWisxcUdKSzhhT2or?=
 =?utf-8?B?djBQY0FSN0hDTmhUUFBUaGRwNk5yVUdMK2wzTTN2ZDVWdmdQWmJkd1FsRnh6?=
 =?utf-8?B?U1dTU1lMQWdVTW9CMHpTSDZHWThWR29CTUo0NTlsSUxQV2ZJQSs3bDhMblds?=
 =?utf-8?B?TzlUQ0c3L2FmakRWNmRqWStrUk9KWVpZUTYzYUZtR2pkakNOUEUxZ05CaVBq?=
 =?utf-8?B?WUZoOHk0TWlrR1NsVWJuWDFnTEsvL0g1TGxuZ25pa3Rpb3dwL293NU5NOFA3?=
 =?utf-8?B?VkVCcFdwbEpFMitVQjZvVmxVOEI3Nk1BNkNQczFUK0htZ1dFQ2thSmx4dXZh?=
 =?utf-8?B?d2Rza0Ixd2pjU3hKM0JTRnIwL0hPUCtwMnFKT1duODdnTUlEUjEwSUZoZmJH?=
 =?utf-8?B?bFdQZGZkWHQrL2tHbFJmZmcyRjM2SEdvOEZ1RU9NWUxmRWpxVEhUWmlBbzJP?=
 =?utf-8?B?eFdnRnphWDBka2g4MHRWQk5wL2FPbzZtRjVWYmIvN0RZVVYwN0FSRUlLdExp?=
 =?utf-8?B?UUhmbXR2a2JJdWkwMWVOL3hWbDhKY0p6V0srUHJWc0dpV2ZBN0pTbzRrem9o?=
 =?utf-8?B?ckpEZEZvSFBhR3VqWjdpODJoTWtXTG1uTndjQjZ0WnYwTGZnN0lJZWJpbkV4?=
 =?utf-8?B?NjBUL0xBR1BkV3BxblpkZXJKTEZWcXRtNENXTlJUTkcwaktLMXJBektnT3R3?=
 =?utf-8?B?Zkw2SStFYXVxNFhYZzRLUDFoYkRnU0doUXFYUWsxaFVXZFIvb0VIY2owbCs1?=
 =?utf-8?B?RWN3aXNSbzRBTWc2YnlCeFJucWxwUmY2dSt1NFJtOUR6OGlINlptNlV2cXQr?=
 =?utf-8?B?NDd4ZkpaTU9tR1JDUDZHSkxacEpuQTkyOW5yK1lLRndrMEpxTWphQ0R3NHN6?=
 =?utf-8?B?ZXRyeVkyZ3RFWDE3dXRQZ2szSnZOWFVXbC9DUEwwTk93ditZUTlpSUVNb3hr?=
 =?utf-8?B?aEVkNWpqQ1Bod0pHR3VDK0p3bG9oZTZUNWw5bkhPQ3Z6TUp5K2IrbW40ZU1m?=
 =?utf-8?B?cjNkdHlLVHFlWU13N2NKeXdmUnU1Sk8xd1JqbXIwaGlFYmxTQ1Jlc2J2Y3RW?=
 =?utf-8?B?QlFScjhlcWU0T1JqN0JvSWFhZkN2YTZjUnJqSnEwM3pObjNxR2U0TFBmZHJa?=
 =?utf-8?B?eDUxSUJwZkJHNnNzZExGSXZxWW00bTFCbGF6WkJWLzdQV3REUkE5alc5WjBC?=
 =?utf-8?B?bXUyclJlaC9HZnpZRWZDVWFOeDZnLzdiNGtGc0FVOVV3OHNPYkFyYU5nNnkz?=
 =?utf-8?B?Z3YzQ2hWVmNaSFR2bkNqUzZBSk12eDE5WFUrNmYxcnplbkZqNmJyNDQzQ3A4?=
 =?utf-8?B?UXJBdjJrUjdkVmZDRUovdHoyVHRXYmhTN0RndmljZlR2WnhmU09zQVRhd2xD?=
 =?utf-8?B?MEVERUw3M21BV3hRQlpLaXR6TkhxU3dYT242Q1ZaUTVoZUZXODIza05CZ0xV?=
 =?utf-8?B?U2N3SkYzYzd3cDFkdFRkbW5rZiswaUtGUDFqbTlTY3p2MFZWZncrcmxHZExM?=
 =?utf-8?B?dkkxWDJNNHhpYnVPMXJIR0QxZTRlVFNFSVpqZWVxa0dkeHRrL254VVZoUDVX?=
 =?utf-8?Q?7niW9LUtWeMPB8VHI1XGUgkRa+lRnU=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cUJDL2dtVGxtTFB1TFR6ZGZ6N0o1NCthMXVyMGJjb0pHb1lwL0hHOVVMbEsv?=
 =?utf-8?B?M3NMMzMxcEd1L1gyMHdRN1pnWkRmdEJKQmUyZmx1MG4xc3pmWDdnZkNUeEc4?=
 =?utf-8?B?Q3FGTkt1QmViS3RGQk93UEswSjFGRFMzd3NIcFM2MXVOTzFkMmhPemVRQ1cy?=
 =?utf-8?B?cVRLUEQ1WkNtdmZyUEtjcm90UFRlMHNRUi9NRjV5cVg2eENFK3U4SGFNWnFp?=
 =?utf-8?B?OHJ6alNFNzVXSngxMlAwdkNJS0NoRlNTeDg1TGtFbTFLRmU0T1JjdjE5Vnpu?=
 =?utf-8?B?Y2JTb3BweXdNbmhPUWp2QzU4NEc5TkhzYk54KzBWZUQ4Z3JObnlFdnJUUjFz?=
 =?utf-8?B?aWl1UDhnNjFGSGk5VnkrbTRlbjM0WnczRU1NeWc1aXJ6VHBBekJTL0ZQcFpa?=
 =?utf-8?B?TTdyWHgya1RZZ0NKVVJML2dUMUtqcE9mUFc1aGp2VkE0ZEJUNS9qVm9vbDRG?=
 =?utf-8?B?Skk2OXlqdnplT3BMbGRHclQyNGdlYXgzQVVSQStwUXptelpsY1gxY0k4c3Jr?=
 =?utf-8?B?WHYyKzBJS0Z6OUdVaXJBdU1KNEVHRU9tYy9mdk5qNEdob2JYSkdqMHNUeG5k?=
 =?utf-8?B?djhmOXlrMFZrZldVQy9rWEgvbHZCM0FPNDRMR3dSaElJWlRGNlVQN3pvbjNh?=
 =?utf-8?B?L2VzbXdWWHpXd2hFZVd2bzAwTzZKYk1sNmNUL2ZHTXk5M0sxME90Z21KeGhk?=
 =?utf-8?B?SEREVFpBVzBUMjZVM0w4YWx5TTE0eFZ0S0RXN1h6UmxDUTVRZStjUlVMRWY5?=
 =?utf-8?B?SFFYKzl4NzRtblVDRjZnZE15WW1YWm1aS0NzSk5VVjRMVzZ5VU10a3NTUFhT?=
 =?utf-8?B?RU8zQnBFUU54TlkxV0VkLzFuM290eXpNQ05YczlKRWFLQlFMZ2c4Ny9mVzJv?=
 =?utf-8?B?YlJtUklqQXBFbDZvTW56ZWh4WnNXb09IQnhIcGFJd1NCdkt4NTFpMWM0c3Jj?=
 =?utf-8?B?cTRhZWNNbkJuWFdvVjhENFR0eGpZZXJ6cks0OUhaWGYvSzBtdzNlL3dSZTJ5?=
 =?utf-8?B?Z2NjYTVFK1FKaGt6UzVWQVJIWmNpZ1RxT2Y4bnp2U1I4ZXUraFFGbVEyVlpO?=
 =?utf-8?B?RnMzK2JzU1BLSkU4dU92YWZXTFZzWS8ycy9SQlBzazdpUGFkaUVVaGFXbE1D?=
 =?utf-8?B?TU1hdGxyeGxMMStTeEVoRmtySm9WenNqMlVwd2ZuTUJsY29TbDhrbmtwOUtw?=
 =?utf-8?B?TnI5d3RDdWRYckpzTDNaRzJSQXhVOGNDMlo3QXd5aFhFd2w3SUNMckFpd0lJ?=
 =?utf-8?B?U0Y4R05KMklYTmt2TFM1amhxdS9RT1UxZGRteXE1dXBsSlRTak9OcjB4Lysz?=
 =?utf-8?B?SDNWZng0cEJvTTVhYVZhaXBscmdLcW5XMHNDaXlQTXg1ekN2WHgxbGdDZm5H?=
 =?utf-8?B?Q2swajRKcmNwTTdlY1dicDZFMW5HSzBwSWVBK0dvcXJDMjJPZ2YrenpwemRS?=
 =?utf-8?B?VXFEUDcvMGQweUg5SzZMZExjWXlYTGkzR0N3RFRzalZ4Wlg5cVFpdENSZTc1?=
 =?utf-8?B?ekVpcHJDMXM5Smkvak16b1pXSlROTjhJWURXYlM2QmlFYTlCanh4Wk5wQjNz?=
 =?utf-8?B?Rk0zM054a1ZTRnNxTG5HR2hRYzQ3Zkp4ZHc0QURqTlJuNzRtODRwNGZFalYw?=
 =?utf-8?B?bjNxNmxJckI4T2JZeU9DSnpoOFNGWXNtUytyUUVPTSs2SklobnBZQVVJRktC?=
 =?utf-8?B?a0RIRFBpM3diRGtxN3FMVm9rUjV3S0huMmxLdW5SRENZcnRlR1phYmhHRFln?=
 =?utf-8?B?dVFlWG1LckpKWHEvYkRpa3ArT21xcFNINzBERUxNRFg4SFI3OHhpTHppL1p3?=
 =?utf-8?B?VC95V0JJcGwzUEUrWjVOblUrbTFnUGhYalpTSWdFQ0F4bTRPbldFMzFCRE5q?=
 =?utf-8?B?eFVZMHNldzlZUzYyOE8zNWhWTWNnN1E1SDVZN3R3V3lyNlJmNElRQU11VUZB?=
 =?utf-8?B?WVZWc21aUmtlZ0dPYlE1YmsvT1pSNmlQYVB5M0pudzZ3UHJmSnpNMFR1aW5Z?=
 =?utf-8?B?Mkkxc3I4Q0tsTk5KM3N6WlZUcEg1eUlIaUJyNVlQcmNKOHhMeGtBRk1RS1I4?=
 =?utf-8?B?cGpKdDdXZVJvT1lLMm1janhML0M1MTRnaG8vdENCMUpIYUF4OXp3L1duNTFK?=
 =?utf-8?B?bVJ1c3MrNUNhNVlQeWFKT3pDalMrNVdKVWJvSVlKZllrSkJ0ZzdqalNTMTdN?=
 =?utf-8?B?SHc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: da23adb0-a4ce-4133-f124-08de10f3419f
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 22:43:29.8969
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QPlVhjTaCtQbj/qOA2Tv66DyDfLFxcMIo8i0bg9KOZMtutGxjZ1vtdCDQ3HPhm2ZBv1INl+BeTS3bHP/bW+c1LsoO0rmU4vSh66iWUAQPrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFF28037229
X-OriginatorOrg: intel.com

Connect the helpers to allow save and restore of GGTT migration data in
stop_copy / resume device state.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c   |  16 +++
 .../gpu/drm/xe/xe_gt_sriov_pf_control_types.h |   2 +
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c | 118 ++++++++++++++++++
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h |   4 +
 4 files changed, 140 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
index 18f6e3028d4f0..f5c215fb93c5a 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control.c
@@ -189,6 +189,7 @@ static const char *control_bit_to_string(enum xe_gt_sriov_control_bits bit)
 	CASE2STR(SAVE_PROCESS_DATA);
 	CASE2STR(SAVE_WAIT_DATA);
 	CASE2STR(SAVE_DATA_GUC);
+	CASE2STR(SAVE_DATA_GGTT);
 	CASE2STR(SAVE_DATA_DONE);
 	CASE2STR(SAVE_FAILED);
 	CASE2STR(SAVED);
@@ -827,6 +828,7 @@ static void pf_exit_vf_save_wip(struct xe_gt *gt, unsigned int vfid)
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_PROCESS_DATA);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_WAIT_DATA);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_GUC);
+		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_GGTT);
 		pf_escape_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_DONE);
 	}
 }
@@ -859,6 +861,17 @@ static int pf_handle_vf_save_data(struct xe_gt *gt, unsigned int vfid)
 		ret = xe_gt_sriov_pf_migration_guc_save(gt, vfid);
 		if (ret)
 			return ret;
+
+		pf_enter_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_GGTT);
+		return -EAGAIN;
+	}
+
+	if (pf_exit_vf_state(gt, vfid, XE_GT_SRIOV_STATE_SAVE_DATA_GGTT)) {
+		if (xe_gt_sriov_pf_migration_ggtt_size(gt, vfid) > 0) {
+			ret = xe_gt_sriov_pf_migration_ggtt_save(gt, vfid);
+			if (ret)
+				return ret;
+		}
 	}
 
 	return 0;
@@ -1065,6 +1078,9 @@ pf_handle_vf_restore_data(struct xe_gt *gt, unsigned int vfid)
 	xe_gt_assert(gt, data);
 
 	switch (data->type) {
+	case XE_SRIOV_MIGRATION_DATA_TYPE_GGTT:
+		ret = xe_gt_sriov_pf_migration_ggtt_restore(gt, vfid, data);
+		break;
 	case XE_SRIOV_MIGRATION_DATA_TYPE_GUC:
 		ret = xe_gt_sriov_pf_migration_guc_restore(gt, vfid, data);
 		break;
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
index 8b951ee8a24fe..1e8fa3f8f9be8 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_control_types.h
@@ -34,6 +34,7 @@
  * @XE_GT_SRIOV_STATE_SAVE_PROCESS_DATA: indicates that VF migration data is being produced.
  * @XE_GT_SRIOV_STATE_SAVE_WAIT_DATA: indicates that PF awaits for space in migration data ring.
  * @XE_GT_SRIOV_STATE_SAVE_DATA_GUC: indicates PF needs to save VF GuC migration data.
+ * @XE_GT_SRIOV_STATE_SAVE_DATA_GGTT: indicates PF needs to save VF GGTT migration data.
  * @XE_GT_SRIOV_STATE_SAVE_DATA_DONE: indicates that all migration data was produced by Xe.
  * @XE_GT_SRIOV_STATE_SAVE_FAILED: indicates that VF save operation has failed.
  * @XE_GT_SRIOV_STATE_SAVED: indicates that VF data is saved.
@@ -78,6 +79,7 @@ enum xe_gt_sriov_control_bits {
 	XE_GT_SRIOV_STATE_SAVE_PROCESS_DATA,
 	XE_GT_SRIOV_STATE_SAVE_WAIT_DATA,
 	XE_GT_SRIOV_STATE_SAVE_DATA_GUC,
+	XE_GT_SRIOV_STATE_SAVE_DATA_GGTT,
 	XE_GT_SRIOV_STATE_SAVE_DATA_DONE,
 	XE_GT_SRIOV_STATE_SAVE_FAILED,
 	XE_GT_SRIOV_STATE_SAVED,
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
index 594178fbe36d0..75e965f75f6a7 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
@@ -7,6 +7,9 @@
 
 #include "abi/guc_actions_sriov_abi.h"
 #include "xe_bo.h"
+#include "xe_ggtt.h"
+#include "xe_gt.h"
+#include "xe_gt_sriov_pf_config.h"
 #include "xe_gt_sriov_pf_control.h"
 #include "xe_gt_sriov_pf_helpers.h"
 #include "xe_gt_sriov_pf_migration.h"
@@ -37,6 +40,114 @@ static void pf_dump_mig_data(struct xe_gt *gt, unsigned int vfid,
 	}
 }
 
+/**
+ * xe_gt_sriov_pf_migration_ggtt_size() - Get the size of VF GGTT migration data.
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier
+ *
+ * This function is for PF only.
+ *
+ * Return: size in bytes or a negative error code on failure.
+ */
+ssize_t xe_gt_sriov_pf_migration_ggtt_size(struct xe_gt *gt, unsigned int vfid)
+{
+	if (!xe_gt_is_main_type(gt))
+		return 0;
+
+	return xe_ggtt_pte_size(gt->tile->mem.ggtt, xe_gt_sriov_pf_config_get_ggtt(gt, vfid));
+}
+
+static int pf_save_vf_ggtt_mig_data(struct xe_gt *gt, unsigned int vfid)
+{
+	struct xe_sriov_migration_data *data;
+	size_t size;
+	int ret;
+
+	size = xe_gt_sriov_pf_migration_ggtt_size(gt, vfid);
+	if (size == 0)
+		return 0;
+
+	data = xe_sriov_migration_data_alloc(gt_to_xe(gt));
+	if (!data)
+		return -ENOMEM;
+
+	ret = xe_sriov_migration_data_init(data, gt->tile->id, gt->info.id,
+					   XE_SRIOV_MIGRATION_DATA_TYPE_GGTT, 0, size);
+	if (ret)
+		goto fail;
+
+	ret = xe_gt_sriov_pf_config_ggtt_save(gt, vfid, data->vaddr, size);
+	if (ret)
+		goto fail;
+
+	pf_dump_mig_data(gt, vfid, data);
+
+	ret = xe_gt_sriov_pf_migration_save_produce(gt, vfid, data);
+	if (ret)
+		goto fail;
+
+	return 0;
+
+fail:
+	xe_sriov_migration_data_free(data);
+	xe_gt_sriov_err(gt, "Failed to save VF%u GGTT data (%pe)\n", vfid, ERR_PTR(ret));
+	return ret;
+}
+
+static int pf_restore_vf_ggtt_mig_data(struct xe_gt *gt, unsigned int vfid,
+				       struct xe_sriov_migration_data *data)
+{
+	int ret;
+
+	pf_dump_mig_data(gt, vfid, data);
+
+	ret = xe_gt_sriov_pf_config_ggtt_restore(gt, vfid, data->vaddr, data->size);
+	if (ret) {
+		xe_gt_sriov_err(gt, "Failed to restore VF%u GGTT data (%pe)\n",
+				vfid, ERR_PTR(ret));
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * xe_gt_sriov_pf_migration_ggtt_save() - Save VF GGTT migration data.
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier (can't be 0)
+ *
+ * This function is for PF only.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_gt_sriov_pf_migration_ggtt_save(struct xe_gt *gt, unsigned int vfid)
+{
+	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
+	xe_gt_assert(gt, vfid != PFID);
+	xe_gt_assert(gt, vfid <= xe_sriov_pf_get_totalvfs(gt_to_xe(gt)));
+
+	return pf_save_vf_ggtt_mig_data(gt, vfid);
+}
+
+/**
+ * xe_gt_sriov_pf_migration_ggtt_restore() - Restore VF GGTT migration data.
+ * @gt: the &xe_gt
+ * @vfid: the VF identifier (can't be 0)
+ *
+ * This function is for PF only.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_gt_sriov_pf_migration_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
+					  struct xe_sriov_migration_data *data)
+{
+	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
+	xe_gt_assert(gt, vfid != PFID);
+	xe_gt_assert(gt, vfid <= xe_sriov_pf_get_totalvfs(gt_to_xe(gt)));
+
+	return pf_restore_vf_ggtt_mig_data(gt, vfid, data);
+}
+
 /* Return: number of dwords saved/restored/required or a negative error code on failure */
 static int guc_action_vf_save_restore(struct xe_guc *guc, u32 vfid, u32 opcode,
 				      u64 addr, u32 ndwords)
@@ -290,6 +401,13 @@ ssize_t xe_gt_sriov_pf_migration_size(struct xe_gt *gt, unsigned int vfid)
 		size += sizeof(struct xe_sriov_pf_migration_hdr);
 	total += size;
 
+	size = xe_gt_sriov_pf_migration_ggtt_size(gt, vfid);
+	if (size < 0)
+		return size;
+	else if (size > 0)
+		size += sizeof(struct xe_sriov_pf_migration_hdr);
+	total += size;
+
 	return total;
 }
 
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
index b3c18e369df79..09abdd9e82e10 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
@@ -19,6 +19,10 @@ ssize_t xe_gt_sriov_pf_migration_guc_size(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_migration_guc_save(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_migration_guc_restore(struct xe_gt *gt, unsigned int vfid,
 					 struct xe_sriov_migration_data *data);
+ssize_t xe_gt_sriov_pf_migration_ggtt_size(struct xe_gt *gt, unsigned int vfid);
+int xe_gt_sriov_pf_migration_ggtt_save(struct xe_gt *gt, unsigned int vfid);
+int xe_gt_sriov_pf_migration_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
+					  struct xe_sriov_migration_data *data);
 
 ssize_t xe_gt_sriov_pf_migration_size(struct xe_gt *gt, unsigned int vfid);
 
-- 
2.50.1


