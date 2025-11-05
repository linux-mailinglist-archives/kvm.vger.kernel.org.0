Return-Path: <kvm+bounces-62065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B7EB7C364BD
	for <lists+kvm@lfdr.de>; Wed, 05 Nov 2025 16:21:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CA1C1A24629
	for <lists+kvm@lfdr.de>; Wed,  5 Nov 2025 15:14:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB59335070;
	Wed,  5 Nov 2025 15:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q0TvCutY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA3333030F;
	Wed,  5 Nov 2025 15:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762355499; cv=fail; b=V7xMrI9J6Im8sqHHfRKdlooSb0F02tuBIOpnHc1ujz5sN/xtC6EgJtXRwgnFoENbipJd/P0Ts9oRkV5urPS1r1lZDdi5kQy7ZrrbTF6IoaZCtWm40kDSrK17qxfKBvGr6vTzdGXCCAjeKYQOjjRgNjEQt65SQuwavf3+2QHKPwo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762355499; c=relaxed/simple;
	bh=IIzsa+dbwkUkytyP1fyV5tjkrYuryPhh+Bw/pb726Is=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Al0Mt1U4r6ujeI4CHBwz54rFXfxLwWhZ6KrR3/xW7gnGzlA3Q33b5XgMtS8+AQw6KryWNR7uYxqzly0xzxbxtRAQWUWFyHgEw5znFk+FjBRPPQVJKpYKV2E2OCI1Klyh4kdvXWwTcgU95iZc+hpClOpJQacGu6MDj+01KaSc0+Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q0TvCutY; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762355496; x=1793891496;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=IIzsa+dbwkUkytyP1fyV5tjkrYuryPhh+Bw/pb726Is=;
  b=Q0TvCutYp4IsVTduwjmB7o+MrzzvTA2MI4lH1PVE8DlNJu2yFU6c/b5a
   uHbo2F1zM+bTOjhFdSC4TJO/WhIY5Fxr1Og315DKFOKJZy2oB1BlBbBOO
   GbNfFY06+9FRdx5WLYRlj4M4fQKaA6nAPD9vXWzOY774JyUI8BjzJ6aZ6
   s5mrSXuPZxVIw59eO846W14yr9XGDMtgwStuzOfKQaKdSC7zSGiuk2TOt
   f0FWqtIL1/4EmhqryJf9uf8biT7cc123XzrBYF96cY7JgM4szZmGDXZrQ
   WR2vrf5IdsxAtol3hNICRUfu2YeK/pYxeFaSF2u7M6wRrNnNYiYUNZ+uY
   A==;
X-CSE-ConnectionGUID: f5f0mMd0SoqopTHkGq/eNA==
X-CSE-MsgGUID: R/AiFP3LRSuyxOb0We1Ocg==
X-IronPort-AV: E=McAfee;i="6800,10657,11603"; a="75153061"
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="75153061"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:11:29 -0800
X-CSE-ConnectionGUID: YLNsiz/aRPudUI7gIyrOqg==
X-CSE-MsgGUID: RR/hm3vMRr6vjKeQNSDFgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,282,1754982000"; 
   d="scan'208";a="224725507"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa001.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2025 07:11:29 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:11:28 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Wed, 5 Nov 2025 07:11:28 -0800
Received: from MW6PR02CU001.outbound.protection.outlook.com (52.101.48.65) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Wed, 5 Nov 2025 07:11:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=o3VyIGTDNyD5Ecj4uttoqp9tWmy/QPFn31jdU1wbYxZBA1OVj+jE8VSbdUTygQEnpJXZXzGxMAEEr3aE2U5hIPi14x0KHvMFjUGFjDQUwaT2x1vvQ8Juv7Oysg2aOxDP15UU1I6qk4CgT0lcDSa5ojBi7X7THvVGNvJuCMmc6VMZDiikK66AYLzG1vl3IzgVM0YWo5uVNQLGhkD7ANnFuSshTnfQwotwFXTjvouSbYSIPalljDfhVIVj3NZZRJAAGtLdYE/25LAGpDPIGAGb8LVVBDyHJaf7iCy8jZJKGze1S7hnuIJmksTiU4SSdodx+vGjoFC+wa7oiV27bEo8eA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fQ34IHwrfPrwJIzs+sRXla91IJaoIdPzYdDK/jHOoLg=;
 b=GoOqdmTB2zdYm+m2BfW01BR2eeIif4dtiEjmPMFAddhdsQlscBGm9j5LR5Nflw/VyS2dYZaWXaNdnpMZPjPo5lVGdDOpI14lYjvGlwfnByHXnHTRJJDnd/4u3mXM1utav3xQIbCujwlBHNNXvZ0MdM2HfUXyztxNH0DIPwMBPSyTfIyQTBzH8UYxxQDV+nHi9BsS5T3n58ST6feT8GSkKHP+uIUu4+Yy8A686QMjEM9rKvZMJHPNOoFwJfvHaiKKUXSTTdbkHAyHPl82PQAurYsvopVz4s4jM1d+IEl3e0EQfyNofy44Aoo4TX+gx3ssmf4UG53vg1JJy+VymCegeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 PH7PR11MB8123.namprd11.prod.outlook.com (2603:10b6:510:236::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9298.8; Wed, 5 Nov 2025 15:11:25 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9298.007; Wed, 5 Nov 2025
 15:11:25 +0000
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
Subject: [PATCH v4 08/28] drm/xe/pf: Add minimalistic migration descriptor
Date: Wed, 5 Nov 2025 16:10:06 +0100
Message-ID: <20251105151027.540712-9-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251105151027.540712-1-michal.winiarski@intel.com>
References: <20251105151027.540712-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BE1P281CA0434.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:81::10) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|PH7PR11MB8123:EE_
X-MS-Office365-Filtering-Correlation-Id: 39a59741-3c59-47fc-acb8-08de1c7d963e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?V3lwOEJxSkpFUW5xcURmZFFLWm9kdGxqcTJPNFVkaFIyY202UFJZZzNrcjRo?=
 =?utf-8?B?aUhRSWVmcGp5UW5RbXlBdEc3UXJ4djFxQkM4Yjd4eTlhd3lIQmk1dVl6c3ow?=
 =?utf-8?B?cGJZcGYybTlYVU9UNGRkQjJRaVhYb1RiWjNVOTZ1SnJSdFFtU0NJTmxtWlVy?=
 =?utf-8?B?Q0lMQjJjN053Nkl2WkJ3SmpjaHd2VHRWNXZuc1BPa0ZsTUsvaC8rdjcxSG9x?=
 =?utf-8?B?dUtNUk9vZUt6MW5PUGQ4THpiMS9pTkI0TSt6TG1OaFV1TzZhOFFKWjlqYkJ5?=
 =?utf-8?B?UnI5eGtwOVZvUEkybHNVZVM5c0NneUVwNDZYOExLYkVrOC9GbWxFTjZoS2t4?=
 =?utf-8?B?SHlzVXpzdVlqckU4UTNvK1doL2NMOUU5elFwR2hZOTZSYk54RXJRb2txMGh5?=
 =?utf-8?B?bHpuTnQwelJlQWhPNGlDVjRWSU5NU0hXVTVGODZxRVdJdG5Edk1OTGwwb25B?=
 =?utf-8?B?THd6ditXZ0Z6ell2OEdqaGlvVUJyQVRQUUF4a1BDUUxaVVMrMVBIYWlkanlY?=
 =?utf-8?B?eHV5NmEwZFJkS0p3OUEzUktSMXNxalhid0VUZERhTUhWcW04RzlRbThWUTA5?=
 =?utf-8?B?VHJJdWkvc0FhaUhOSTcxalhHNHpmQ1Q2V1lxOU1Ca0I4QjlKNnhTeDUzN2VT?=
 =?utf-8?B?YUVDdWU1Z0RkSjZFd2NlZzdsKytUdGZycjlXUlN0TEhWQUZNNFlQdHBLS1kv?=
 =?utf-8?B?OGp4UVN5U3RiQnRwbDhsbGc1TFdYOUZpMkJDNTlSRStEajNHNDcvbHZWRVFD?=
 =?utf-8?B?d2RDTmg0d3hlTDhVaUVVQ0d2b3ZiUVp2bFg5M2VlVmNvSzZOa3RwMmdnSVc1?=
 =?utf-8?B?ekcrQk9vTmQwT0FSVC9vOHp3N2d3QjBMU2VmL2svZWdwQnpjVGtyMHdWR1Nk?=
 =?utf-8?B?djQyU2VaWGp4QlZjK3ZuU1BlS0lJREJtcDlmakhrM2QyQ24vcmJHdm12dXAv?=
 =?utf-8?B?YmxHYkNUMXBROTMwZkM3bmZnOXZoL3REejlSL0xQeEFBY01jWkRSd0lqSVUy?=
 =?utf-8?B?Q09Ic2ZtWklhSEFpYytzbzJCVTBXc00vVTJNcGt4UE5VTncwQWJpa2E0VldI?=
 =?utf-8?B?RDZzaEowcVlwcXFoSzFwM3pDcC9sUmhuNnh3SVdacnFuZWh0NzUrNlFaWWRS?=
 =?utf-8?B?aldONmhhYTMrZUs3eDdydmkweUJncHdTMG1GNjFoYk5paWV0aThnc0VHWVJW?=
 =?utf-8?B?b096Q0VreXUwTTI2eWEvTXczU2FOa1ZwdDcrd29KdHVlWStsR1hncGloSEt0?=
 =?utf-8?B?bkw4SmtJRDZnZWJiUmVvaHZIMmJBL25DRVd0M1hrZEE4eXBXVGtNVGw3TW0x?=
 =?utf-8?B?NEg0UHNSUzVwWldkZHI0VzE3alpnNytjRnhlbHVKZHUyZldoS0ZZZlovV2No?=
 =?utf-8?B?Qk5pZlBrb1MycVBYK1k3cVZtYkZFbDVDMlZ0WGNaTzdYYkcra21iS1pWYVJP?=
 =?utf-8?B?bG5qTkFnMkZOc1RWdlUzUkpPcE9IVTkvTWRxSWJmZlJJbUhNZHdNVDBTeloz?=
 =?utf-8?B?ZWpyczJiWEdGSmw2U0Zyd2x4QlNVaFVJRnhQTEV1SlFMZmU1TWNwUnlBZko4?=
 =?utf-8?B?UUZYeHFaZnIza0dVM1BpUmQ2eG9ONkZNWVFlb1k4QndxSnFmWVF4V09aTnY5?=
 =?utf-8?B?RExXS3djV0pyRjRTbHlKTlFlSEpTUmRDOWY5M0tKazhtOTNxeUlIRk5DMHBo?=
 =?utf-8?B?cDVWZ2lYNFBQQkFPdE45bTFrWU5VbE8wQXlHYmpBbDB4NnN0WlpTN05JcW94?=
 =?utf-8?B?alM5b2ZaT0IraUIrVTErOWxQT1JFWk5nczE2UFp4NlBnZzR6SnFyclAvRTdL?=
 =?utf-8?B?ZVlrRGVvUzlzSGtOYkV6WHExb3ZhK1VJVXdMNEtCd2xvalFwN2xXZURPZVla?=
 =?utf-8?B?OEtzV2NqbFVOV3oyTXZUMXY0bXlqbmNjZTJpbUoybVJTeC8rTjVaUUdheWFm?=
 =?utf-8?B?UTZQa3BRUGM1ZHRKM3pCQ1VTVTZLbCtpNUVPYnZRV25iZEJHd0RRMFR2aDdh?=
 =?utf-8?Q?zpRr2p/dh3woLq62YZbIAMFkWfksEg=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ek5XWTdiL0lhYk9yVkRPbDRsZXhicG01WFdhSUZXVHpzSS9LKzlhRXBQcXlq?=
 =?utf-8?B?RnVLM2p5YlU3Z0NuTTRmMmhkNGdyTmRaRTE2WE9oSmNTZW0zRlhSOHAvVmM4?=
 =?utf-8?B?T0pXOThMaUs0cnd4NTJnaXdkWEtVVVRkSmJETS9yTUhBcjRCSFVQUWxaeTJk?=
 =?utf-8?B?WFhrK004YTQzMTVrUDB2YXlJR25xMDFMTG85R3l3Q0pvVUtnZDJkeWVqajVi?=
 =?utf-8?B?S0RFdzVYeklGbXlscmRmajZvaWo1Nktxd0xRTlpiTWJXNG80ek4xV1phVUlQ?=
 =?utf-8?B?b1dsNUhwSHU3V3JVZGJENmplUGxCTEU1RE5xZWpQYTdURXVjV0Jwc1I3enJS?=
 =?utf-8?B?ckpDZ1B1K1Zyb3UyZlhtRUhZU2ZKUExoN2pja095WVVXWFM5NWZoOWdCM2Nu?=
 =?utf-8?B?YUk4VGhPY1hwR0hNUFM4Vzk3MERzSXNYenpudGcvQkdnZmMyMXI5R3RtcEx4?=
 =?utf-8?B?b1R5bHkyeHZ2WmhDUXdidTA3ek9zcDV6N3F3Z3N0cHlLNDg2WGhreUhMRUZp?=
 =?utf-8?B?aTRoRXVobnp0cFFCbFl0NmhJTGx4d2NMUzA3d05OcWZTNVRuQ0JLOXZ1SVFU?=
 =?utf-8?B?Qm41WlcrWlB6UlJoRTk2YUN6SktGMitvb1JWNURWSm9sYzFnUy90dlRtaVo0?=
 =?utf-8?B?K0NzbC9LR2lxU1d5SDVIU0hYdlB0OENPQUxlVitlMzFhSHo1MW55bjNXRlNO?=
 =?utf-8?B?WFI2QnVTanV4UHp1bjI4blV5L3gzNEIydFhWWlE2RjlmR3I2Qmk1ZkhiZm5T?=
 =?utf-8?B?RzRSZGxTbjNBd0RCWUlkdGJEd0xBSmxaeDFNTmRQTnJuWTRoUCtIeW82ckZk?=
 =?utf-8?B?WHVTRFp2M2wvblFrV05rNGR4N3IvejQ3c1FsY1NVam9PL0xvUTdqcVFXcjRq?=
 =?utf-8?B?eFgxVlRZbVRZRGVsYnlZenE1WFBGUlhBSG1FMk0vSnZnd0VZUmpXSWxCL2Jy?=
 =?utf-8?B?ZEsxajExNTh5VEprdXd5UlNDc0J1RUM0S2E2aVRCa0kySWVacXlqNnlFSytX?=
 =?utf-8?B?ZXhEazNzaVBWblY2akk5bHcyUE1OMDNNdmEwMkd6bDVNZFM3OENjSDhENTlQ?=
 =?utf-8?B?SVU4SUtUYzE5Z0liajdrUTc3bHViZFM0aCtxVkJURVo3NjhTNHF0bTErU3NC?=
 =?utf-8?B?WVgva2l0c0Y2SmtQTmF6SmpYdEdPNUh1UktBaXVCQU5pSTIwc1h6TlAzSWhV?=
 =?utf-8?B?MVhzSmdxRTZnb1g3amo2M3I0VGJJdy9USUNNR0lFSUY0OUx0bW51TVpDNWVU?=
 =?utf-8?B?RFg5RlR4SEtQSWxzbmllMEo4eUY1RW1uZDZIWVVURHgyM1dOY1JrTEQ4REND?=
 =?utf-8?B?b3k2bGVkODVXOHlDMHA4L21UQkxLeG9GNEVXUVZjbXlWdHFkbDc1QUgwMWhL?=
 =?utf-8?B?V2NwKzVhQWtPdGdpSjJyYnpPcnZJZE9GdGd6cmVPdUJqZk1MNXArODd4Z2ZS?=
 =?utf-8?B?K1BjcmhmWDRpMmZMdXk0bkhqNVorR0NvOHpnV0Q3OEFkbi9OY1lVU2FVMjBp?=
 =?utf-8?B?RHZKbVB0MjdvNzZBZGR6VE1uaHEyZHR5S2orZjg0ZkdDR0ZSZmo5NFdIZW9U?=
 =?utf-8?B?N2tDUzdyVUtlcmQ3RXkzd0lJUDBJaFBPVXMyQmN6QStXdUZXeTNZRnViY2s3?=
 =?utf-8?B?cmR0TDFYNVNrSFJrbnA4NnZXZldDUzk4UFlvdk05bnBkcGh6eDBhVUd1TEF2?=
 =?utf-8?B?Y2pkQ09nRE9xd2NNTlVGc3doeVJvZEZVNDZjRW5lSkFCK0pJejRkWXh6bGNI?=
 =?utf-8?B?Q3Bpcm9MR013cG9PRGhNVzdtdnZzVHhXaUxBSE5qS1QvVUlOZm8xRUtUQjhG?=
 =?utf-8?B?WmtzeC9EaElZeEhVakRpbVRRMDlBWS9JZkxNTnVXODdEYTBnckQyOHFoS2pm?=
 =?utf-8?B?L0RUbDNybXhqWWY1SlljWXcxQVdhZEtlLzdzYW45UkdvQVA3ZjN1WkRyWFM2?=
 =?utf-8?B?NE51eGJCRGZ0aVJiVS91bDZqM2tnV3phNVF3NjllVC9hSGx2NHNxbi8vdi84?=
 =?utf-8?B?bXhzODhhTS9mTW9NYXJMbmpjd2RWSFdNdWZlMENkb2hZWlh0ZGtQNTVzRkRu?=
 =?utf-8?B?S3JuWTRIdnNYU3c2Sm1Hb25uVVNyWDZ4T3JOSE5PdEdiUk9NNFhlRU1QUUpB?=
 =?utf-8?B?TU5jbnZ4T2xjdVdFVk1rWXU3S1dkWDhhY1ZiKzZYZlZIRnIvL0pSNStCc0VE?=
 =?utf-8?B?Y3c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 39a59741-3c59-47fc-acb8-08de1c7d963e
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2025 15:11:25.4886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IceNFJSvMFfL3Ldq9uEUGVFZkMjOUJvmfh23yCEw+rHM924ogrZJcDUBD9mWT6iDbWie/OiI+9TP9pa2uQSaHmeCCvYVOW4OepskmG2jgoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8123
X-OriginatorOrg: intel.com

The descriptor reuses the KLV format used by GuC and contains metadata
that can be used to quickly fail migration when source is incompatible
with destination.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
---
 drivers/gpu/drm/xe/xe_sriov_packet.c       | 92 +++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_sriov_packet.h       |  2 +
 drivers/gpu/drm/xe/xe_sriov_pf_migration.c |  6 ++
 3 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_sriov_packet.c b/drivers/gpu/drm/xe/xe_sriov_packet.c
index 220c36c52e99b..c39d9a0c5df52 100644
--- a/drivers/gpu/drm/xe/xe_sriov_packet.c
+++ b/drivers/gpu/drm/xe/xe_sriov_packet.c
@@ -5,6 +5,7 @@
 
 #include "xe_bo.h"
 #include "xe_device.h"
+#include "xe_guc_klv_helpers.h"
 #include "xe_sriov_packet.h"
 #include "xe_sriov_pf_helpers.h"
 #include "xe_sriov_pf_migration.h"
@@ -340,11 +341,19 @@ ssize_t xe_sriov_packet_write_single(struct xe_device *xe, unsigned int vfid,
 	return copied;
 }
 
-#define MIGRATION_DESCRIPTOR_DWORDS 0
+#define MIGRATION_KLV_DEVICE_DEVID_KEY	0xf001u
+#define MIGRATION_KLV_DEVICE_DEVID_LEN	1u
+#define MIGRATION_KLV_DEVICE_REVID_KEY	0xf002u
+#define MIGRATION_KLV_DEVICE_REVID_LEN	1u
+
+#define MIGRATION_DESCRIPTOR_DWORDS	(GUC_KLV_LEN_MIN + MIGRATION_KLV_DEVICE_DEVID_LEN + \
+					 GUC_KLV_LEN_MIN + MIGRATION_KLV_DEVICE_REVID_LEN)
 static size_t pf_descriptor_init(struct xe_device *xe, unsigned int vfid)
 {
 	struct xe_sriov_packet **desc = pf_pick_descriptor(xe, vfid);
 	struct xe_sriov_packet *data;
+	unsigned int len = 0;
+	u32 *klvs;
 	int ret;
 
 	data = xe_sriov_packet_alloc(xe);
@@ -358,11 +367,92 @@ static size_t pf_descriptor_init(struct xe_device *xe, unsigned int vfid)
 		return ret;
 	}
 
+	klvs = data->vaddr;
+	klvs[len++] = PREP_GUC_KLV_CONST(MIGRATION_KLV_DEVICE_DEVID_KEY,
+					 MIGRATION_KLV_DEVICE_DEVID_LEN);
+	klvs[len++] = xe->info.devid;
+	klvs[len++] = PREP_GUC_KLV_CONST(MIGRATION_KLV_DEVICE_REVID_KEY,
+					 MIGRATION_KLV_DEVICE_REVID_LEN);
+	klvs[len++] = xe->info.revid;
+
+	xe_assert(xe, len == MIGRATION_DESCRIPTOR_DWORDS);
+
 	*desc = data;
 
 	return 0;
 }
 
+/**
+ * xe_sriov_packet_process_descriptor() - Process migration data descriptor packet.
+ * @xe: the &xe_device
+ * @vfid: the VF identifier
+ * @data: the &xe_sriov_packet containing the descriptor
+ *
+ * The descriptor uses the same KLV format as GuC, and contains metadata used for
+ * checking migration data compatibility.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int xe_sriov_packet_process_descriptor(struct xe_device *xe, unsigned int vfid,
+				       struct xe_sriov_packet *data)
+{
+	u32 num_dwords = data->size / sizeof(u32);
+	u32 *klvs = data->vaddr;
+
+	xe_assert(xe, data->type == XE_SRIOV_PACKET_TYPE_DESCRIPTOR);
+
+	if (data->size % sizeof(u32)) {
+		xe_sriov_warn(xe, "Aborting migration, descriptor not in KLV format (size=%llu)\n",
+			      data->size);
+		return -EINVAL;
+	}
+
+	while (num_dwords >= GUC_KLV_LEN_MIN) {
+		u32 key = FIELD_GET(GUC_KLV_0_KEY, klvs[0]);
+		u32 len = FIELD_GET(GUC_KLV_0_LEN, klvs[0]);
+
+		klvs += GUC_KLV_LEN_MIN;
+		num_dwords -= GUC_KLV_LEN_MIN;
+
+		if (len > num_dwords) {
+			xe_sriov_warn(xe, "Aborting migration, truncated KLV %#x, len %u\n",
+				      key, len);
+			return -EINVAL;
+		}
+
+		switch (key) {
+		case MIGRATION_KLV_DEVICE_DEVID_KEY:
+			if (*klvs != xe->info.devid) {
+				xe_sriov_warn(xe,
+					      "Aborting migration, devid mismatch %#06x!=%#06x\n",
+					      *klvs, xe->info.devid);
+				return -ENODEV;
+			}
+			break;
+		case MIGRATION_KLV_DEVICE_REVID_KEY:
+			if (*klvs != xe->info.revid) {
+				xe_sriov_warn(xe,
+					      "Aborting migration, revid mismatch %#06x!=%#06x\n",
+					      *klvs, xe->info.revid);
+				return -ENODEV;
+			}
+			break;
+		default:
+			xe_sriov_dbg(xe,
+				     "Skipping unknown migration KLV %#x, len=%u\n",
+				     key, len);
+			print_hex_dump_bytes("desc: ", DUMP_PREFIX_OFFSET, klvs,
+					     min(SZ_64, len * sizeof(u32)));
+			break;
+		}
+
+		klvs += len;
+		num_dwords -= len;
+	}
+
+	return 0;
+}
+
 static void pf_pending_init(struct xe_device *xe, unsigned int vfid)
 {
 	struct xe_sriov_packet **data = pf_pick_pending(xe, vfid);
diff --git a/drivers/gpu/drm/xe/xe_sriov_packet.h b/drivers/gpu/drm/xe/xe_sriov_packet.h
index 03ab8edd99374..6cd0918f2bc33 100644
--- a/drivers/gpu/drm/xe/xe_sriov_packet.h
+++ b/drivers/gpu/drm/xe/xe_sriov_packet.h
@@ -32,5 +32,7 @@ ssize_t xe_sriov_packet_read_single(struct xe_device *xe, unsigned int vfid,
 ssize_t xe_sriov_packet_write_single(struct xe_device *xe, unsigned int vfid,
 				     const char __user *buf, size_t len);
 int xe_sriov_packet_save_init(struct xe_device *xe, unsigned int vfid);
+int xe_sriov_packet_process_descriptor(struct xe_device *xe, unsigned int vfid,
+				       struct xe_sriov_packet *data);
 
 #endif
diff --git a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
index 4e0ca2fd7fd77..54a2c0f9d5933 100644
--- a/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
+++ b/drivers/gpu/drm/xe/xe_sriov_pf_migration.c
@@ -176,9 +176,15 @@ xe_sriov_pf_migration_save_consume(struct xe_device *xe, unsigned int vfid)
 static int pf_handle_descriptor(struct xe_device *xe, unsigned int vfid,
 				struct xe_sriov_packet *data)
 {
+	int ret;
+
 	if (data->tile != 0 || data->gt != 0)
 		return -EINVAL;
 
+	ret = xe_sriov_packet_process_descriptor(xe, vfid, data);
+	if (ret)
+		return ret;
+
 	xe_sriov_packet_free(data);
 
 	return 0;
-- 
2.51.2


