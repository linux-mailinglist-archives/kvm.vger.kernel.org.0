Return-Path: <kvm+bounces-60734-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 82600BF91A5
	for <lists+kvm@lfdr.de>; Wed, 22 Oct 2025 00:44:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id EA952355D30
	for <lists+kvm@lfdr.de>; Tue, 21 Oct 2025 22:44:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5228C2EC080;
	Tue, 21 Oct 2025 22:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dIZPiwg5"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2310A2D0283;
	Tue, 21 Oct 2025 22:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761086583; cv=fail; b=Ju2GKuygpEKvuzuf63jZcG13wkt+DgL72hrDzSqUeGuH5mD+Ze1mfW28sD7Qelsey+DnscpDmDPpoj+KfMjTaPEHDAQkyOqyyD3LQyDPH8bXYQ4px4jS4eAdjnQdHmKPo2h+FUBGP4yX/w6dVkRjpWMb9ZF+TI6TLMz83QomlY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761086583; c=relaxed/simple;
	bh=r54gz1Rvs5CWCJ+65dpLASOMQmIIFF/HkXwqMJlhBMs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=IuKvjTwxIEAxnv4Fol1fQ3HziLr+z5akCdr7W5TFDosJpm0mySMD9IUXJK3wRN+XsGmh6KRibA7L2srHBolFi9OvWJl4nbpwfEtCCOulEjtqf4Y1wS7oRZEVI0nd/M9bIpyWX3SisML9xOppnI2ti6hSD7aN+QnmacubK6bD8ks=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dIZPiwg5; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761086581; x=1792622581;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=r54gz1Rvs5CWCJ+65dpLASOMQmIIFF/HkXwqMJlhBMs=;
  b=dIZPiwg5iz0UyM0njLsNYCripsozx0pUvptXQ7ZyeaP5y+61N7fxg1dK
   1FhjYDVgMQ0CvWgXIdX2uzPaz6vxbCAuYrghfM5CPPLdi+CQvu89WSHNm
   gpsEKAhBcaeDMD3T8JRu3m5/MsNVFmp+jICPUtsXHp2EWtmfQkaLVpgTY
   pxA6eSjm2jPgAuSdR3U9sv7Z51VPLOk8TWIYbPonL+z6wkSkQcyOUs8Rn
   3yBPaTyLOoD0RX3nLNkakNciVk74kA1VPYZKf8YI8/bpJylUElRdExJem
   vLyLlfHk95GCqFOvZd8GSdKfG6cYTdswKBcIG5xZ31gFBucYCKzaMrMaz
   w==;
X-CSE-ConnectionGUID: 0zHReJ2sT5SZDE4IDZnAgQ==
X-CSE-MsgGUID: yCHt4fFaSt6+E3oDIrGsLA==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="88693472"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="88693472"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:43:01 -0700
X-CSE-ConnectionGUID: 80yML68LTsO7zf1uCJPESw==
X-CSE-MsgGUID: GdgBHurlSv+KLFMhC+AiFQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="214345564"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa002.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Oct 2025 15:43:00 -0700
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 15:43:00 -0700
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 21 Oct 2025 15:43:00 -0700
Received: from BL2PR02CU003.outbound.protection.outlook.com (52.101.52.19) by
 edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 21 Oct 2025 15:43:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=k+zIgYe3ZMAni83/W35RxfRGyJXb+IOcz6SdK91fJ93WN78l6aQ+RQQYaUfqQHeP5D88Vy+lcRutLi9XMbGiQgbdgFSp7PmFZq6O98aSaSPis6PaNtILSa/LSA+qO418RKjyafxl4w36VIf7htCJ6Q80p3/V8hjikWOh5O9Kg9sCUlrGvfsW03mdLv55T7rQfjZRboGSJjgA7Oc7Rb91WPOGUF1b+XR6M+FvHiFHJpbBoiRYrkRpcA0l2ZCpVLkka7EROVR9yydbSbCfjH/w4D+ET2C4f1ljmkcjbZlAvUVpTHKLgPwU29GjOFIVJMoO66c7cYjgx3YB6Gp9/DsOTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xu96fzvSEInF/VB3Dm+ovxTZGoj+tlhFivBjat5ebpE=;
 b=t+05vVFhBqs5FRx89vPk/r1s2nf17u7CGV99mgyAvvB/v3eD3Gu2m+joze/PPzsoeQE3uJp3AdEc4y8/oxsxyO1nPJgfZMbPItg3UKrHUYN6+/3Um0K9ivpGW8kExHhtMI60+QzQ1PecUuJpiqLtxEoQiKDPckhBmvKv/e7vwGTpUcOrzEEkJta8uqsSNDp8xINCLz4RQ+3rryhjNeTHihse6w1uat8iSDJ9870MVfhBMSPptfX9QYUxCpMeYfTVN+STfqRWnFQSrinqkWxdpTngZJ9QaPSAyO28saOktrHEGXYHBxKULeGJB9rHrFkT0ldLHPxJKLZHUTwPe3QD+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 PH8PR11MB6753.namprd11.prod.outlook.com (2603:10b6:510:1c8::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.12; Tue, 21 Oct
 2025 22:42:58 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9253.011; Tue, 21 Oct 2025
 22:42:57 +0000
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
Subject: [PATCH v2 10/26] drm/xe: Allow the caller to pass guc_buf_cache size
Date: Wed, 22 Oct 2025 00:41:17 +0200
Message-ID: <20251021224133.577765-11-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251021224133.577765-1-michal.winiarski@intel.com>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0502CA0008.eurprd05.prod.outlook.com
 (2603:10a6:803:1::21) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|PH8PR11MB6753:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a096cc8-1acc-4ba4-6175-08de10f32e6b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?cDZxQnBuQjg2M2xuWm41WUVWcUdpWVBpVUFqZnd0Znc3dnZyZE51QW9LcFVY?=
 =?utf-8?B?MkFYZVZFUGZqUncrUUxjdGxaNmhXUFFTczJ3N2pQR2laZjlMeFVsUTBzbkxU?=
 =?utf-8?B?U0lRS3V4bnA4aFQ0QTkrZ3FGeWFmeDZPMXkydUx5bGRkVWpuYVJ5L1FOdHgy?=
 =?utf-8?B?V0ZqTWtVT3F1R3dlN3ZXQWp5STVhYVdOcGxycVhMUlFZdHR0d2E3MlZMMGhR?=
 =?utf-8?B?NzdhR0lKem04UkJZMWgwcVVsQkNGV3pYM3BJWVJQZkVFWDhnVk1uRm9VcmJX?=
 =?utf-8?B?NVRKSjhxT0RvaWtvVVlUOWxwNzNid2Vyd3IwRk42NCs0KzBJdDZTbWViQTdQ?=
 =?utf-8?B?d2hiT3Z0T291MEM4WllFcHZrOFhBcWxTVDVneGNwcmQwaGRIVWZ3L2NDZHZi?=
 =?utf-8?B?aHRxRGlQMXBnYnJxVkplL0k0d1lsN29HbE5IUENhVWtMNlhSUFBrWEE2b3Nx?=
 =?utf-8?B?ZkdFZFBaUnI0d2hES252ZmNaVVJzQmJKcHFuN0JhU0VFNGUwVjZlamE4bFg3?=
 =?utf-8?B?SEpYREZYNllVWVJ3ZFgvRDZMdFVZeUU4UEZUcG1haDZCSEdzY1IzNDUzVWZM?=
 =?utf-8?B?S1JVb3Q5ZUszSm1BT2xnQ2x5YWY4V0xEY1FrdGJSbUp1NkkySDNvNXFSa0l6?=
 =?utf-8?B?bDJML3hMTDhGMUc4TXJ3cmw2cDNnMTUxK3JpVDBFK1dTaDFhZEVlc05taHR0?=
 =?utf-8?B?dmszbjFSV1FPbUdpVmpySFlXRTNZTGxBamR3Q1VEMFhxT3plU0ppMWlGWFQx?=
 =?utf-8?B?a0dvWXVxTktmWkgyUTV2WHl5dkxhWjZOM0tpMXVyUm9sSS9oNjl2SWpFbTh5?=
 =?utf-8?B?KzViS0ZSWTN3MXRkemdUQ3FsZHNZNGNaQ1M2S2hkYU1SSHZsT0ZWRUtSblY2?=
 =?utf-8?B?dmJrb2FXeFB3dkVSRldkNmY2Z2pOZnptcVhOVE1YZldCNzFPdk5HZjNQejND?=
 =?utf-8?B?OTZqVjdudktpSDdtUlhNSUptZWJsZ2c5TDZta1lKSUNoMzdUczZGRlE3d2c5?=
 =?utf-8?B?dnBYa2hMSGRJRWNOcWFXQTRWMGtHSWZKNk1TeE4ydVA1TkhUTEM4UGxjZHBH?=
 =?utf-8?B?K2JsSStOTUlHc1pGcmRPT0lTalpTVWFweDN6THl5YWdDQ3pYNUx3TmNXaUlC?=
 =?utf-8?B?djlzZE1DcDhja2JFQVRNZEJuNzJqUWd4c00wUmpsWmNta3FWTXFPNk1aWTBY?=
 =?utf-8?B?VmJKdFFhMGlZL3VEeWFLWldWcW9OaHhvUTNVWVBWdGlsTUtzVTN2ejc1NzRt?=
 =?utf-8?B?enU2T0o1eW5vclczdDZXYlJKcGpVTWFhdFdBRmFTcmRjTGhvVkk1elkrb0ow?=
 =?utf-8?B?NXlqMDZBaHJYNVRGT0N1cU1TMDBvNy95NEdPTUVkaUFUWWFMZEZXSWVtRzhi?=
 =?utf-8?B?ZVphOUV6dUxQMWJmUWd2c1BQNE9UOFV1Y3NlY0JxclBrVWN5U2w0NnpTQ1Zy?=
 =?utf-8?B?TDM4SzRYMmMyYmZkQjkxTEkwZVpYVHZ0RmkrUXowM3J3d09SQkczbWxIRjdV?=
 =?utf-8?B?YjkvbkxlM3Y1akVvV0t5b2pvcEVtMDdNczZMYWJRUk1OdXU4L0gyR0hXVVRa?=
 =?utf-8?B?eVVaTURDTUhXZTRtV2RBOTFEeXJJWURjc1RMcVdmZy9pUUpqMnNtRFMxWUgr?=
 =?utf-8?B?aFBoMEZ2SThrbnlxR3BjWXROckNkeG9BSThpSnRQQkp0Vk1qRGhhR1FRY0x6?=
 =?utf-8?B?b3NKTE1ueUtBZGxvM3RjTWVnbGRDVmxqNjgvZmR4eldjSVA5clI1dXEvbmJT?=
 =?utf-8?B?dHFadENyeE8rNW1HT3F4UjdTTGpXT29qZ1VXZExQcWp2anI5WXJnQWkyQjVl?=
 =?utf-8?B?OHJJdmhqL2YzUTlhWjJpYmlha2lhTmtYSXY4R21sK3ViVEM5ekdhL1RTb3lP?=
 =?utf-8?B?WkZpNHF0Ly9ZSXJNTytKdUdmWUNPbUZoSDkvdkRTZEtDbDFGMXJVQWJDblFX?=
 =?utf-8?B?RCtnNG5mTDVxbjhIZmdpUDQranZoWVlGZUdBbGM0M1Qyd3ZDU2lKRWxPWk9F?=
 =?utf-8?Q?mw52GsLiyoQH0orbc1yF0aubcy4rXw=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S0xiNGFiSFNsU21McDdzbzl3Y0dzRjVoeXQrUk1wVHdTbU1ndk9PbjRuY2xn?=
 =?utf-8?B?eGIzbFl6T1hlVDBlYkNYVFZxM2hoWkJNeVl4M3BuMVFwUlRRazN1eStnUGd6?=
 =?utf-8?B?aVRiaFNMR0NTK3pWQ0ZWTUkyT0tNYUV1OFFUbjc2ZGMvOE1ZQWFPWnBMUjU2?=
 =?utf-8?B?YkcvNDJreU9CcmNkY290ck52YkNad1Z3czhwQUxjdEtXaWtKUHJHVktSZ2Zq?=
 =?utf-8?B?Y1c2ZC8xQ2xwUTZIVGNTaHVIUUtBb0tZWnBlVFVqNzhYMDVyamtMcmZzQTk5?=
 =?utf-8?B?VGtJaXRhTWlRWEppcTRDT0hMSURCY1NEbVRpM2ZLRk41cmFoa2dtN0QvQ1J2?=
 =?utf-8?B?WDFENjZzMXNDTFoyTHF4RzNSN0FlRjljdUVmYklxUS91N0Uva0J2Z1ZvMXBs?=
 =?utf-8?B?cnhSTWJzVGZzRElQMHNqRG5qQTYvZzk0YlAxYWExWXpTd1V4NEVTOFFkWFhz?=
 =?utf-8?B?OWFKWW14blZVak80dzV5WHVQYjlZcG5Db0dMWitwVVo4bkt4NGNJVGt6ZlF3?=
 =?utf-8?B?dWRrQU43czA3SzRwcVY1MGM2a2o4NmNqTVVvK3VubmR2aUt2R2RYVG5Ickk4?=
 =?utf-8?B?T0M3MUg2U0VvUDRJQkt5N3AvSlpyQ2YzYVBZTkR1WGhmc3FPelpCQUxYdGxL?=
 =?utf-8?B?N0lqV29nT09CWVVEZWdRellDK3RCcVhueDgwalVEbEFlYndFRXFiV3hOWWZv?=
 =?utf-8?B?RTBTQzNKTTVyVjQ5U201aEtTeDNkaTR5dGx3RG4reWhydTRhdVRvKzJpZ2JP?=
 =?utf-8?B?TEVmUnlBN0doY2ZrZWk3OS9lam4wZGVIeFl6dEtMZkhIZm1rNCtOc0ttWlFK?=
 =?utf-8?B?c2p2WlpPNjd0QmxueklyUzZxK0pQQUlGdnhicHZCRnNKeldJMU51OWswWkhv?=
 =?utf-8?B?MjRtcENGWGgxNmRsR0RzQjhMS0hoM0pZRFhoMWgrY09iSTNxVS84em40SjJH?=
 =?utf-8?B?S3RKMVozYW5JY09ucXVyOWJtZ0pxa0JmZnhBRUVWaUcwT0xLV3N1V1dMbEtP?=
 =?utf-8?B?eE03bWwxZnhlQTRGMVN3bDN5VUw0OGJxNjU2S1BMdTRIdSt3N2FxamlPYlNQ?=
 =?utf-8?B?L0hSYnBsMDZ5c09uSnVzOW9sUGFyTVNTeDZhblI2MUFSYkxMV29RbXgraXFr?=
 =?utf-8?B?byt5ZVlBTjkrY3hYcUFvV1EybEtWbEpmcnduTzlKQVpEV2FzR3lpS0dOd1BB?=
 =?utf-8?B?YVAyRXdENVVQZU5qdjdhSFJVMEhUV0I4WWd3L3k1bzVhOXU2eXRHWE5rSzVX?=
 =?utf-8?B?UGZJMlFZQnMvR2JQSmVRbzBxTWhKMHdweUdobDVSZHJ2cDd2YkJ2MzFLRzJn?=
 =?utf-8?B?S0pzb1djeEFJZjFLQ1BvT2p4a3ZoMktFZjRoK1dHN0l6eEJxTWJaQmpnRDZt?=
 =?utf-8?B?aWdNYzRPRllLaFNZN1lBekx6NEVpWkhmZGV1WmFlakJ3a3dDU0dnMEpTMkZh?=
 =?utf-8?B?ZWgwdUNqYkRpazJ5NXRoQmEremNEcmhpNnFhTEs5M2lWNm1JTEJkVnErZ09S?=
 =?utf-8?B?Q1pET1k0VldwWnZ6ZlRKWmE0aE5kb3ZaYzI3ckd3Zk9jMWtkMTdnWHFCQ1Jt?=
 =?utf-8?B?NHVBQWExejAyVll3NXFnQ3M4L1hkVlYyRmY4c1JiaHBRUzZXcUZUb1Ircm1G?=
 =?utf-8?B?cUFRSm9HLzJ1Z1h2NXVSUC9zRndpOGxsOWJXcjVyRzFGZndVS0hpTGNpMnUv?=
 =?utf-8?B?VXczaUxWUU96cUZMbFVqTUt3ZjkydE1pOEhSK2Z4enBuVTcxbEhRb3dGdXVu?=
 =?utf-8?B?WjhKY3paQXY2MzZuSVBBYUZrVzRMTnpJc2FkcDZaWTdnT0dYdkdvYTR4S0Zu?=
 =?utf-8?B?a3hqWFBSRVdYMDF0WHhrOHdSS1JRZ2pkUVQyNlNTcWpET3BscTFIZWk5bnNh?=
 =?utf-8?B?OE1xSm0rWWhGN1dqekd1eG4rOVJFREdNV3pmVUJLays0eGx4ZEQ4NjJ1QTVN?=
 =?utf-8?B?MHNJNVRzRXU5SEpwNEQ1N0R4TDFVMEJWZm5iM2UvSmUxekh1Skw1SSs0emh4?=
 =?utf-8?B?NVoxeDZsWldVWGxPN1ZNdkxmUkx2NGJSOXRpZWNyOVNYU1V0R1JsZHlESFhS?=
 =?utf-8?B?T3F0di81ZU1BNGRLdHZzRldIelV1WEJmNUJIN2VIQy9iaGJpZ1paVXVJNC9R?=
 =?utf-8?B?c3Z1dVg4bVVYbG4rL2tqeC8zSnhuWDB0SkM1WVQwTmlVU2NMaFRIRkdoem5G?=
 =?utf-8?B?UlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a096cc8-1acc-4ba4-6175-08de10f32e6b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Oct 2025 22:42:57.8810
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: o8tTzIjgKQORu1LowkzbZLDZwOhTE23XQrHRy+icvYyc0sSajaXLnnLhYOzsQQdnYSpsve5RsfJ+VJjBLzXYwe1vOkYx8/7hLizpyXqHUtI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6753
X-OriginatorOrg: intel.com

An upcoming change will use GuC buffer cache as a place where GuC
migration data will be stored, and the memory requirement for that is
larger than indirect data.
Allow the caller to pass the size based on the intended usecase.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/gpu/drm/xe/tests/xe_guc_buf_kunit.c | 2 +-
 drivers/gpu/drm/xe/xe_guc.c                 | 4 ++--
 drivers/gpu/drm/xe/xe_guc_buf.c             | 6 +++---
 drivers/gpu/drm/xe/xe_guc_buf.h             | 4 +++-
 4 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/tests/xe_guc_buf_kunit.c b/drivers/gpu/drm/xe/tests/xe_guc_buf_kunit.c
index d266882adc0e0..485e7a70e6bb7 100644
--- a/drivers/gpu/drm/xe/tests/xe_guc_buf_kunit.c
+++ b/drivers/gpu/drm/xe/tests/xe_guc_buf_kunit.c
@@ -72,7 +72,7 @@ static int guc_buf_test_init(struct kunit *test)
 	kunit_activate_static_stub(test, xe_managed_bo_create_pin_map,
 				   replacement_xe_managed_bo_create_pin_map);
 
-	KUNIT_ASSERT_EQ(test, 0, xe_guc_buf_cache_init(&guc->buf));
+	KUNIT_ASSERT_EQ(test, 0, xe_guc_buf_cache_init(&guc->buf, XE_GUC_BUF_CACHE_DEFAULT_SIZE));
 
 	test->priv = &guc->buf;
 	return 0;
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index ecc3e091b89e6..7c65528859ecb 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -812,7 +812,7 @@ static int vf_guc_init_post_hwconfig(struct xe_guc *guc)
 	if (err)
 		return err;
 
-	err = xe_guc_buf_cache_init(&guc->buf);
+	err = xe_guc_buf_cache_init(&guc->buf, XE_GUC_BUF_CACHE_DEFAULT_SIZE);
 	if (err)
 		return err;
 
@@ -860,7 +860,7 @@ int xe_guc_init_post_hwconfig(struct xe_guc *guc)
 	if (ret)
 		return ret;
 
-	ret = xe_guc_buf_cache_init(&guc->buf);
+	ret = xe_guc_buf_cache_init(&guc->buf, XE_GUC_BUF_CACHE_DEFAULT_SIZE);
 	if (ret)
 		return ret;
 
diff --git a/drivers/gpu/drm/xe/xe_guc_buf.c b/drivers/gpu/drm/xe/xe_guc_buf.c
index 4d8a4712309f4..ed096a0331244 100644
--- a/drivers/gpu/drm/xe/xe_guc_buf.c
+++ b/drivers/gpu/drm/xe/xe_guc_buf.c
@@ -28,16 +28,16 @@ static struct xe_gt *cache_to_gt(struct xe_guc_buf_cache *cache)
  * @cache: the &xe_guc_buf_cache to initialize
  *
  * The Buffer Cache allows to obtain a reusable buffer that can be used to pass
- * indirect H2G data to GuC without a need to create a ad-hoc allocation.
+ * data to GuC or read data from GuC without a need to create a ad-hoc allocation.
  *
  * Return: 0 on success or a negative error code on failure.
  */
-int xe_guc_buf_cache_init(struct xe_guc_buf_cache *cache)
+int xe_guc_buf_cache_init(struct xe_guc_buf_cache *cache, u32 size)
 {
 	struct xe_gt *gt = cache_to_gt(cache);
 	struct xe_sa_manager *sam;
 
-	sam = __xe_sa_bo_manager_init(gt_to_tile(gt), SZ_8K, 0, sizeof(u32));
+	sam = __xe_sa_bo_manager_init(gt_to_tile(gt), size, 0, sizeof(u32));
 	if (IS_ERR(sam))
 		return PTR_ERR(sam);
 	cache->sam = sam;
diff --git a/drivers/gpu/drm/xe/xe_guc_buf.h b/drivers/gpu/drm/xe/xe_guc_buf.h
index c5e0f1fd24d74..5210703309e81 100644
--- a/drivers/gpu/drm/xe/xe_guc_buf.h
+++ b/drivers/gpu/drm/xe/xe_guc_buf.h
@@ -11,7 +11,9 @@
 
 #include "xe_guc_buf_types.h"
 
-int xe_guc_buf_cache_init(struct xe_guc_buf_cache *cache);
+#define XE_GUC_BUF_CACHE_DEFAULT_SIZE SZ_8K
+
+int xe_guc_buf_cache_init(struct xe_guc_buf_cache *cache, u32 size);
 u32 xe_guc_buf_cache_dwords(struct xe_guc_buf_cache *cache);
 struct xe_guc_buf xe_guc_buf_reserve(struct xe_guc_buf_cache *cache, u32 dwords);
 struct xe_guc_buf xe_guc_buf_from_data(struct xe_guc_buf_cache *cache,
-- 
2.50.1


