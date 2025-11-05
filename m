Return-Path: <kvm+bounces-62068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B426C364E6
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 16:24:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id CC29F500D5D
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 15:15:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AE39330B2E;
	Wed,  5 Nov 2025 15:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="I2BIUHQb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31EF330B34;
	Wed,  5 Nov 2025 15:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355512; cv=fail; b=l5mEuIAGKOsIp90isgTbZ/RlPQ7LIHM6QzIVyl8S5o589qohb0x8YuRb83ZP8ox3Xs1WeOuqzIWkoZ7eB32SuIVghXIiRGdwmd21fc7Atf31qhdXeW8lk68nUTlsn0/8i3dvyElEUaTCvOcAicUJfpb6HiL7aV8mI3MPZ1aCbLY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355512; c=relaxed/simple;
	bh=SA3j3Vb1q9YxeiVO1ICzJ1G0CIhUHY1HpX8fdasO8jU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oYgo9d8QUq/oWN3qT79vW+TUIu3MmrfwkypjeJTM0WC6tZFDXbORUoZs1D1ee18HTwMOniIGyE3IFMzwzX3RkhRDIQgs8zw1NnONYKeEv6zYsJGTePcRvM9+VB79Ka0+OdsdOjiQ98gMztG7Q1KGGHlAirU/kYD5zTozlzeFPXw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=I2BIUHQb; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762355511; x=1793891511;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=SA3j3Vb1q9YxeiVO1ICzJ1G0CIhUHY1HpX8fdasO8jU=;
  b=I2BIUHQb8KaTdewgjiNRClJi5pW1m324WHTDCOgWsS2+91J5iTizuQt/
   XUNns66zG+xrdI29nkG5DXDR2j9wjDpQddrnRz4UKp4zhVqDL+X9D6dZ1
   i29DmkQC80JdefIgukWqHbYiuOZlLAe92xwyRgcPatuRt4sfajlPA1WXj
   yKeZ6hJBP9uvGnK8xErIqmvMADpmNMo5TgyDcq8FR1D3vkSCfSaYCEPM+
   V0tDlh6K9PPXlfw4yTqmIH+jON5C8hHDfB3cTEDtT5bIDqlv+SPwp22WB
   C1ApdKDybS9YfcCCKmW3XvmshSytl/NZy/W33Yc0blWMJr/oxHSgwbKrG
   Q==;
X-CSE-ConnectionGUID: sqFx2B/2QDW7bjHCUOGuRg==
X-CSE-MsgGUID: E9VwmrwTTNWd73GXO6gaBw==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="63677341"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="63677341"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:11:50 -0800
X-CSE-ConnectionGUID: SfT/KcpTQ/irUcLjPnnSHA==
X-CSE-MsgGUID: ZJBk51PpTs+0kmC4XzgljQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="186766426"
Received: from fmsmsx901.amr.corp.intel.com ([10.18.126.90])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:11:50 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx901.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:11:49 -0800
Received: from fmsedg901.ED.cps.intel.com (10.1.192.143) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 07:11:49 -0800
Received: from SN4PR2101CU001.outbound.protection.outlook.com (40.93.195.34)
 by edgegateway.intel.com (192.55.55.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:11:49 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lM65onmg6n9GvcpZsnAj5pxys7CaDarzfP6hdfoNtS7QhSjF+wkHfU2dx8KHgM8/8EQEBEzqqf63RKif4mQMd2WIMtInYBUUk9Gj8qM3lve0WJSNy+NRa1XEl/hQMFxtcz04m9rI1BI+s2x6dVxxL+Hj6idoMx2OGuyRNP+QJ/4APiQSvNiHUD2Ov2GSRJz4XHT9OiGcL9APsi1SaVdsymwgZef6O0E+x0VNvGiuppNIUwoaokXk+pw4Xh0ohNGC5vOEsJjYVsqoky3D1Gx4qUaBaItV5mkGjYRRgDS+tVBrr5CT1bdTwIOhfIihXD0B4KEtMO7638wTQ6jOh5gmuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ws1ix986qSEmRc8j1MxC9ZwHETCxlDj9nlCCxVAy8Ow=;
 b=e/GzWjtx6kug9PscTzL60HTUzql59rs2sjyd/QhKZzrXJsAi2SrEWmD+NPJEoR8DwBeWza0269ZgPqEfvmATD7CDWQX8DJdQ6kZs1J1VZjjCBVNrjSaBsCxjuBmBgDPeJBZOC/LqRv53VkJeXN6M2OoILJu6/zCVeR6HEUsvEC8r9G3AOlRwOIgWNfPqfwSmGY0zZ7FQC0FT6ap9djdQ77JcFH1DluOiAD3CmUj2qFVaIBohB3JvfSpnqFBEWEIMIDa9sl2+yf8sxPP/h0S1LhpjvS1lrA7/ZBGZ8wQp1+3OibegxyALlOmmvbLgvgZylk3Y5gR0nRX4Su4z9pzbEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 PH7PR11MB8123.namprd11.prod.outlook.com (2603:10b6:510:236::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.8; Wed, 5 Nov 2025 15:11:47 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9298.007; Wed, 5 Nov 2025
 15:11:47 +0000
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
Subject: [PATCH v4 12/28] drm/xe/pf: Increase PF GuC Buffer Cache size and use it for VF migration
Date: Wed, 5 Nov 2025 16:10:10 +0100
Message-ID: <20251105151027.540712-13-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251105151027.540712-1-michal.winiarski@intel.com>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0023.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:15::10) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|PH7PR11MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 78f0425c-694b-4fbe-019a-08de1c7da377
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?amVVTktNckE2QlhPU3RsMWpuNUlwc2xSWGNScy9RUnFWNHNieVV4Rm9td0U5?=
 =?utf-8?B?WWo2dXJBRThzWXdzUmFGYUsxaS9CTlNRajF1QzVNVDR1Y3dZeUdwc0F4c0s2?=
 =?utf-8?B?b0RzQ0ppcHZzc2d0Uzc3cXZweHZxM0xRK1N1L1N3UlRSTGtQUGMwMjJ3ZjRu?=
 =?utf-8?B?cGg3NkdTM3Y2SW1EVFloV1dQenpmKzhTWHFoNUQ4R1B2YlI4bVU1NndDdUtq?=
 =?utf-8?B?VEozbEZLVG9wbVcyL2xTS1htcGpkQjNjZHo5WUxPTHdFVXYyNXA0My9STzJT?=
 =?utf-8?B?RG9LNXhiZWczd3pJQjVXQXhaMGNLaEt0MEdlK0lxTXdqL21wd2RSWURpR1N5?=
 =?utf-8?B?WWdHaUthQyt3ekV2cjhWbUxRZnpRanpSYUp1bHFxK1FCdzY1d0Q3ZXR2NlZE?=
 =?utf-8?B?SjBKWDVzZEJhQmtnZFNybkdqTjZPelJabHVhQW9sV1V6Ly9MY21NV2NLMndi?=
 =?utf-8?B?bS9uL0U3YldPdGs0czRGK2d3SVZma0dKbnpGMGV1Nk5SVitVUVh2TS9na0o1?=
 =?utf-8?B?OVVqQkVEVU1mbmNESHdXa1Ircy91QjltaktQOEtQSzZESExHQ1BvQnVHcjdu?=
 =?utf-8?B?TG9VRVRidXJPeXYwOEhOS3pmVWtZbG44dGttQi81YlV2NlU2Tm5BbXdEV3Q5?=
 =?utf-8?B?cmtMVmFWMDRpd29aakZwV0JKWHlrcDN0dmxWVTE1WmZqZHBQQ1dLRVVQN05N?=
 =?utf-8?B?dXB0QkV4RWJkUWFTMDBJZkE2ODJwdDRleU1PQkNDbnlicU1HT1llWkFHZGF5?=
 =?utf-8?B?RnFYMWdzbnVyWG5OTndqc1ZEbEhWSWl2N1FQb0ZQcDFxZVpRRGNXcUxVM1o4?=
 =?utf-8?B?ZjBoeWREeGFqOFc3a0sxWm5WZ1lPZ254Z3VDNmNUYy9YcHp3SW11NHI1UXY0?=
 =?utf-8?B?cWxQTkFVZnBtYmQxQmRQTUZKeHYyWWdpWnlzdFI1dm5XOUtEQ0pQelNBL2F6?=
 =?utf-8?B?SmpsVS9RVkNGQnhFNzFYUThwV2dhWWxjTDdCa05yaGpPWTRCRGJZVHNRZDZ2?=
 =?utf-8?B?YW8xRXp5SHpPQTZ3NEYzSTBySmpnR2hGdml0RmdYaGpsditqUjIrRkhBeUUw?=
 =?utf-8?B?emQyRjFDRWdxN3pyRjRJcS9TajN5WjN5cTJ4V0VlZE9PMGphbEhoUll2ZjVL?=
 =?utf-8?B?akZwWHBQMEx6SHZ2dFpsQ0hoVVkwbGk1WWRXemVOcWJHM01OM05Jcmp3MVEx?=
 =?utf-8?B?T3JNbGpZZnBLV2FBTG43ZXk3Nm9VT1hvK0dkMkVHSWhjTlluZlVSWThBQmRZ?=
 =?utf-8?B?dXpSY3dnRTAvS0k4K2xVM1RsdkcvQnQ3cFpxajA2RlFUdzlmWGtra1h5QVpm?=
 =?utf-8?B?Q3VCdUFzVUVJTmdob3FWL3Jac3dzY0lEOGJWR0VVbVhlTUR5a3lIOWxNQ3Y4?=
 =?utf-8?B?ZkkwVGNxekRXTksxaUF0TS95OUhwV1ZoNnJFcVR4eFV3d0doenczMzREWWRo?=
 =?utf-8?B?ajZVT2RTWmhVWDFuODN5Vm1QTFN2RDdVNjh4OVJIMHpWdmExdjBPQ2JYaEUw?=
 =?utf-8?B?SnFDZlpMN3V5R2RuWE9JUDNKaFBLbm9aNENjblhKL21acjFPY05ZWGRvTStt?=
 =?utf-8?B?cmFUTUZZdmpkMUdNWmgzVllPYm1vMlhWYTF1alBvTUFuMGJ6MlUwMEU5U0hT?=
 =?utf-8?B?emRNSXM2QmhzamVOb1V5Vm5HUk01blVvRDZCbm56RFhEaEpWMlRLckMxSTVW?=
 =?utf-8?B?Ly8wWnlIKzUvSU8wVHJWNG81L3ZDSm03UUsydzNRNCtsSFR4N2htWkxERk5H?=
 =?utf-8?B?WmQrOHZUNmJEVmZSWTh3WWtVU1VaSjNVRmp6T3R1UW9ISlo2VzJYVXVoR2JR?=
 =?utf-8?B?Mmhxc3dpNldJbVczWU5GQnVBcUFrajJ1VkZDcmJyMmVjbEdiTlhpbmFOQ2FK?=
 =?utf-8?B?ZTk3V2l1QXpXLytaaE1TeGpkci9iZUwzZ2g4SmovRFlHalJWckpFWCtRSUh5?=
 =?utf-8?B?ZlRRdkdDbHVrV1Bkakx5QWI0Nnp2UGdNbnJld0NqQWhBOENoMEJNSk4wY05i?=
 =?utf-8?Q?FPF1U/WVxASLXTpaAsOvUGqMN0Uxyo=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1RjQVpvWnNyZmNteFd2eGUxUFBuelZhcWhZelZ1Wk1zejhBV2hsZ2ptTktX?=
 =?utf-8?B?Z2FLSDVnSmFzV0s3em1PM1N0emc0SjlVL0hvUnlsQ3RUS0drdlpzdEtkaHg2?=
 =?utf-8?B?VVJ4cEFuUmtmcGxjd1FKaExzcTd0elB3QnV2Q3RBcjQ0S3JDMnhNZUsvTW5h?=
 =?utf-8?B?cDdhWDhvSkMzZTlWd1pyVnFrUnM1aVNhbE5PdnExa1FHK3pJYkw2UmxvdERz?=
 =?utf-8?B?OGNHd0VUK3hKbm9Qc1lBc1pqb254M29SUExEbHkxd2FiT1RFdU9INHFrT0Q2?=
 =?utf-8?B?NUxqWHFnK29KVWVlak5OeEhFd3JSN3ZaSWZwTXB4M09DUGNaR2p6NW10VzZG?=
 =?utf-8?B?L1dsU3JoaWJaR3RFUEhIWDJDanh6UGZMTUIyS2xrS1YycGFSMlBkYkFTVU9n?=
 =?utf-8?B?dHA3WktoWU5scW9SeEJXUUFaVXN2MmRRSVJtdjJxaTJyQkIrakZmdWd3NS9D?=
 =?utf-8?B?aXk2bnNZZ1cyaWdIRWgwN3pMTHVGVHhOWmM0TGJMZlFvTTdrVk9VRTNFWVM2?=
 =?utf-8?B?a0s2OGRQYTFicDg4M1JFNWxQOWZoY21LVjdOd0RMRzNtZm80amxOVzIzVi9I?=
 =?utf-8?B?ejk1aGZkUEpSUDlIRGVIaUxvak0rU05ZNktPL2w3SlNDOENtWUx1NmFKdWVE?=
 =?utf-8?B?ZWN1TFZpZGFoMWxBWGd5YTFHY3JHSkxlVitOMUQwazFxTmpFQUdMd0VwZFJU?=
 =?utf-8?B?VE05UlRHOUE4S0lFOUsyUzRGakFlQ3E4YVFsSVdRTzFMYXhhb244QmViWTZp?=
 =?utf-8?B?N1c0MkNnQWtRcGRiekoxTXpRaVkzSitxV1JQZHRLT0h2Y2xkSmQzRk43NE9O?=
 =?utf-8?B?TStRcEFxd1UzN1JSKzBFTUhIWEZLajIvdmpqczA3S3pjazlSUTlxSWlDSUpB?=
 =?utf-8?B?UUl5Z1JkaFJMUUFVYXFWaXJZTFZJakFzSUpzR1VpNVZJeFpxVGZ3YXFNRjRw?=
 =?utf-8?B?d1I5Wm1EcXBlQ3ltQUNpUUxvOHNEcE5rbUdNL1A4QUh0Q0VHRk1mZFlYUnpT?=
 =?utf-8?B?NUpXbVcyT3F5dnArT3BvZ2VaVkZkS0cwT3NGNHVHTFJ4UHFmcFhTd1kwRHZR?=
 =?utf-8?B?aXVMSWpvVHdGbVMwdDhLVFRsUUpEUjVscnJ5RFJQbENoZmlQVkJvaitYUlB4?=
 =?utf-8?B?cDNSYXR2aTFaTkg3Y1BwVHd4aHRwTjZqSmtCM1FFTXFkMjFlUjE3Kys0bW9h?=
 =?utf-8?B?eTczQXJPeUEwL3NRQXB0VWdHOGg4RkJJS1d5WFZkVCszZm9GRlhBVC8xQjhR?=
 =?utf-8?B?S3dSalU5MGJyZkwxeFRMMzIxLzFKQzRnUDF5K2tGZG15WjIwblpXVXlUaWhS?=
 =?utf-8?B?TS9VaDQ0ZVE1K0FrK0xXYXdtRTN5bit1QUN3eGFqYVVHb0srRWxudVY0V0Rn?=
 =?utf-8?B?L2t6N3MzTkdMOWF3bTZBOHlJMUkvaUxYOTFZUkVHSjkxN1dFQ0RTR2ljODVP?=
 =?utf-8?B?ZVRveVBoWnR5V0VsSS8vVVBGTHlLeTZoalZveGtqeFZadHpRbVR6Y2EySGZK?=
 =?utf-8?B?UjZOeEtjQWg0dzlrRnNremdseFpvK2ZxblhndlA1ekZocExsYjlsbHRWeHl5?=
 =?utf-8?B?WHQ0Y1hJVjA0OGIwZmI1bXhVTmFrazNqdGpCa1FiT1YzaDlteDJsZjBwa0pB?=
 =?utf-8?B?dTkvS3RtYklJVkhEMWNENDg1Z0x2eW5FYldKcm5PRE1WR3FuU3VvcCtLQzFr?=
 =?utf-8?B?VVlHMWdVMkNoOFBad1ZWQUdHM3dCeUZtME44MUF4dk5qdndjVXMvTEJJdUJ3?=
 =?utf-8?B?S2lrQlpxRm9kTEJoUG0zRDlRY3dCS04xVnBKd3Q0QjFGaEVodjZCaEFLelBK?=
 =?utf-8?B?TTVlZXZ6QU1Oa3RFOGYvUjJOV1BqdFJmWmRlbFFUMnoyVDlLR3ZOd3hBYnpy?=
 =?utf-8?B?TFB4WmtLclcwdVArZTRETnoxQTZxU0NySUUzMEtrZmpGRGNncVNGWGhmRUEz?=
 =?utf-8?B?Qkl5S0tjVGNCSTNxQzY3Z3pveTNwK29xL0Nwb0tySVBWdDA5UzdOZDFyV2pL?=
 =?utf-8?B?ZHl1dUpuVTlnd2dlTVFIanhjMVE3NUJ4NTRPYlNvcXVKNS9rZEtTU1RqV1B1?=
 =?utf-8?B?QTEwR1VUVkI2WXhQSDVTTVpVWm1OOXY4S3lhQlBTM2o2dnByU3luNUx6Z2JR?=
 =?utf-8?B?SGxxcHVUVTFKUFZPUHMzYWIzbFRLekVTWXFmR1ZaRkY0c0Z2dDNNQWVaRjBZ?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f0425c-694b-4fbe-019a-08de1c7da377
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 15:11:47.3486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UJ2l2+z0clDEEpVLt9ixO7o4xDr8ve9dNlo6Lk5CKFCywo3A5g0M0HJeozLleuySFY/SlCiNzPn5bmh6sg2JqOFqNuhgna7QlVOeCHXxJLA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8123
X-OriginatorOrg: intel.com

Contiguous PF GGTT VMAs can be scarce after creating VFs.
Increase the GuC buffer cache size to 8M for PF so that we can fit GuC
migration data (which currently maxes out at just over 4M) and use the
cache instead of allocating fresh BOs.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c | 47 ++++++-------------
 drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h |  3 ++
 drivers/gpu/drm/xe/xe_guc.c                   | 13 ++++-
 3 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.c
index 0f56dbc04865d..88371c205add7 100644
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
 #include "xe_sriov_packet.h"
@@ -57,73 +57,56 @@ static int pf_send_guc_query_vf_state_size(struct xe_gt *gt, unsigned int vfid)
 
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
+	/* FW expects this buffer to be zero-initialized */
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
index 3ad3c3609b415..148ee07dd23a9 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_migration.h
@@ -11,6 +11,9 @@
 struct xe_gt;
 struct xe_sriov_packet;
 
+/* TODO: get this information by querying GuC in the future */
+#define XE_GT_SRIOV_PF_MIGRATION_GUC_DATA_MAX_SIZE SZ_8M
+
 int xe_gt_sriov_pf_migration_init(struct xe_gt *gt);
 int xe_gt_sriov_pf_migration_save_guc_state(struct xe_gt *gt, unsigned int vfid);
 int xe_gt_sriov_pf_migration_restore_guc_state(struct xe_gt *gt, unsigned int vfid);
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index ecc3e091b89e6..a686b04879d64 100644
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
 
+static u32 guc_additional_cache_size(struct xe_device *xe)
+{
+	if (IS_SRIOV_PF(xe) && xe_sriov_pf_migration_supported(xe))
+		return XE_GT_SRIOV_PF_MIGRATION_GUC_DATA_MAX_SIZE;
+	else
+		return 0; /* Fallback to default size */
+}
+
 /**
  * xe_guc_init_post_hwconfig - initialize GuC post hwconfig load
  * @guc: The GuC object
@@ -860,7 +870,8 @@ int xe_guc_init_post_hwconfig(struct xe_guc *guc)
 	if (ret)
 		return ret;
 
-	ret = xe_guc_buf_cache_init(&guc->buf);
+	ret = xe_guc_buf_cache_init_with_size(&guc->buf,
+					      guc_additional_cache_size(guc_to_xe(guc)));
 	if (ret)
 		return ret;
 
-- 
2.51.2


