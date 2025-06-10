Return-Path: <kvm+bounces-48765-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62748AD2B1B
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 03:04:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1775C7A4414
	for <lists+kvm@lfdr.de>; Tue, 10 Jun 2025 01:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FA3C19D897;
	Tue, 10 Jun 2025 01:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FROizZbr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B024A06;
	Tue, 10 Jun 2025 01:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749517443; cv=fail; b=lW/GNaW009ocsc6IZJcuH5Gp/fa0iJYoIXFLVic2wa4x1D3r0ydQUAfOIvdu18gdSrfb1OYo7n4iD8DuR03zOB0zMA4Wb8ZTKzohwijbkfiHF5z7BDBVEZ7EAGEmwvnt/PztnqtUzU93XwogapABmIQ1JhoSutBj7EQlEPs2LjY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749517443; c=relaxed/simple;
	bh=Oj4vXqbXhyY3o/I1EWpQ60nRPvgTghkIBLVpQmuS1bo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JisbVJAB/VOyER1zla2qEIzKi4smbk+8KYU0NUg0WMxb/tGMA48wIuwDmMuS4BKDyRP10XCEOL2WEHQTnmWJtTYXYq+AZnkI8N7B8n1STr5ju3Uk1UnvUAlnSBhW+UStFu0o2S8HFl0XV1SBApMhx6s9rzz2dyYlu2uWo1WVocs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FROizZbr; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749517442; x=1781053442;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=Oj4vXqbXhyY3o/I1EWpQ60nRPvgTghkIBLVpQmuS1bo=;
  b=FROizZbrl8QDqDSCo0X4scanVk9p4MZ8ffVVlOM7E8LEHZnjZ+lq6cEW
   D2sqonc2w20t9XhZ0Oz0r9rQkpn6Ry1lfYmPJMyvqi+hTGl4FS979sg2F
   tYUINzxOE6HE0E8+rgdYJUdP7/S3IzIxcnrQeWWvLSKCu2bwDUYj8YhKg
   d4cgkItiQyrQTWQVcgrDk+zYQ946Xb77rV1VKFp+A4TmIv6OVOSPIsC8M
   Q+fqAfJynSOc0fpWJed7oEF+sn151n2xgrhKJC44rpnVowFYER4pCiJ6i
   /jczjWcQ5IM8RTwIT0SBUdFLRnL49Aqo0Q5frXOUADx0E8r4Rf1jLplYm
   Q==;
X-CSE-ConnectionGUID: 0L9GCjSzQSe3NGA5kcElyA==
X-CSE-MsgGUID: DUcYNJmlTWGTpdPZiVPRVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51603368"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51603368"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 18:04:01 -0700
X-CSE-ConnectionGUID: Y2bo6dpyQsy497d9tA50vg==
X-CSE-MsgGUID: Z36D3eLWSkGLCQLJQ3Z7Xw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="151555870"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by fmviesa005.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 18:03:58 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Mon, 9 Jun 2025 18:03:57 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Mon, 9 Jun 2025 18:03:57 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (40.107.212.50)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Mon, 9 Jun 2025 18:03:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eCQnuaGDaqT+CNH/NVOFoV13MGpryp/hph6lCevHkh1MV54XfAc0uPW3/wEgzSwNb6t6H4nz7HaSPKH0I1c95r7X0A6fuhezfHDomf2Yud2J0lJnNnHXb3Q1S8y/BNZ/SORTwhS6G2oRXjb3+2jyVjO8Ur06NBrn09mHwupu1LEmrzf31gLb4i+z+EXyvJqp60WiLzQDn9AlTw5AmihMZ4Nwqe7VOhQGIuUGdQvJeweifT+3D3j17k2bdBwwWldkV6J5HqqWWauvYs20tgCPzILyut+ZpXMXcefRE76HliYOcoi331u6gI/5EuZ0aVwFpmjJmWN2ynk0fccAFJmpdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M52HvZojnRq9Z7+CcEk1G76wlm28PcN65OFKjOdkFXk=;
 b=kBNZ5vGiUwuB5PCHpaZF81lug8iMOVWdV60ibOzuU5JwW9JrZDKK0PxWgMgKhLlAw7tAdlwMZek3pQX9WmZh4x99nWODA9lyDWdVlYMbAhiftVUWC9rUSloant16T+HfQ1f1SKbldtJueZFledSaA5FkpEPQXg8HYKh7DvBS2OaKs+iRiBlJpTj9Y+YyLUeFlcZK1v062whcRy93Qkh/WP+iRBz+0ETPD3LAP52815UH4ZY4x5mzjTfG4I1FXrHY5EqiAEMNCRMzFmnC+J8uwiqjkqEjVI3cW0fHm2hA6/gIGVyQxa7v/lGcX66B3Jjxo88+xxNxzkRPIHcvxY4LkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH7PR11MB8059.namprd11.prod.outlook.com (2603:10b6:510:24e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.23; Tue, 10 Jun
 2025 01:03:55 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8813.020; Tue, 10 Jun 2025
 01:03:54 +0000
Date: Tue, 10 Jun 2025 09:03:41 +0800
From: Chao Gao <chao.gao@intel.com>
To: Nikolay Borisov <nik.borisov@suse.com>
CC: <linux-coco@lists.linux.dev>, <x86@kernel.org>, <kvm@vger.kernel.org>,
	<seanjc@google.com>, <pbonzini@redhat.com>, <eddie.dong@intel.com>,
	<kirill.shutemov@intel.com>, <dave.hansen@intel.com>,
	<dan.j.williams@intel.com>, <kai.huang@intel.com>,
	<isaku.yamahata@intel.com>, <elena.reshetova@intel.com>,
	<rick.p.edgecombe@intel.com>, Farrah Chen <farrah.chen@intel.com>, "Thomas
 Gleixner" <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Borislav
 Petkov" <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, "Kirill A. Shutemov"
	<kirill.shutemov@linux.intel.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 03/20] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
Message-ID: <aEeEbXZglywwo1Rm@intel.com>
References: <20250523095322.88774-1-chao.gao@intel.com>
 <20250523095322.88774-4-chao.gao@intel.com>
 <d1ec91ad-b368-4993-aadb-18af489ea87e@suse.com>
 <aEaS3i5JhgFX2MCh@intel.com>
 <175eedc5-d82a-4b3a-bce6-2caf625597ca@suse.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <175eedc5-d82a-4b3a-bce6-2caf625597ca@suse.com>
X-ClientProxiedBy: KU2P306CA0016.MYSP306.PROD.OUTLOOK.COM
 (2603:1096:d10:3b::14) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH7PR11MB8059:EE_
X-MS-Office365-Filtering-Correlation-Id: 1bcb1445-df42-4fe0-3fd1-08dda7baab8a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?f6A1n8KuFEeWxsAgHSIo7PVZKIv+98Mvr0DqzfWQIa111qslN00LvO/JczSE?=
 =?us-ascii?Q?UrikiNA6X9+waOQGvO2tcDeGWFsVFCcj1O8FD9xQ4joVCR2NG45/0lB4DH9S?=
 =?us-ascii?Q?yoTdvpk8bXbFP0F/5SMcB7qSz0n7lCuFH1TL8XYmvXRT3E4u88w7YDCIQaFd?=
 =?us-ascii?Q?20W6P4JhYmRPzKQFYF8e9PCLOAZJvFdQdi6ln2R4aSHnNlZ3hXKE3PW0FErp?=
 =?us-ascii?Q?ErTpU4iUzqPDPCgMKVZplWCwy7cV5kodKNRmfsauwZACWcmrkYnSdInmsFmt?=
 =?us-ascii?Q?STZxsBkRuC7OadgAm+z0HbDit7du60HnoM1MU8GrN3I+cy2WGv7uksehND8r?=
 =?us-ascii?Q?byM1wyGFqIJC+BmbDgFpLBibQ9mN+tk3cZeI/etPIfEGu/YJ7eU2m7CE70Rm?=
 =?us-ascii?Q?j58fQaJXPhzzQz2N3VeNxIhjl2tWtO5AAD1MqKdSquE/YNEF+wPH6D/iRwis?=
 =?us-ascii?Q?+jfujFKOMTvcRAfelcBglY1XoSaTAF35VqD8P8AOCyMe1ZvgLTqcMiJj98SK?=
 =?us-ascii?Q?YMy1Q26zob1WkIX6F3d/zqZSZb8z3uPFULOuL0nGmvQFUZny0Sw63M99G6Kc?=
 =?us-ascii?Q?hh/PRQxLmWb3w0Tilhm2cAiO/gx8F71HY/8cvQCEP2mvx52T56nEVgqTimy8?=
 =?us-ascii?Q?Pg9kdCbVP5qO+3x4FPSknp0eoVgHXwEFNmskAhnp6c6qHbEWWIh+AWqkkXxL?=
 =?us-ascii?Q?qfpBr9iysB8lqqN5IomJwLiQ6trsf3NEbhExfi3m6Di+71ibXvTIjelUssRv?=
 =?us-ascii?Q?FJ1VAP3U39THNUOHRH+4HHTUPV0f21e7Sa40mJiKSFQLCnqDAeOPHDAPRBk2?=
 =?us-ascii?Q?gnlQQrgD0T7UqzIkme8Nc76D/g805S0DHjSSVndEO/JjFYwE7jYpU9Ksn4pc?=
 =?us-ascii?Q?7dksVgyhE5W5lrUgecZu5l+yDaFKcgML1SiT3IQ7lc+KlDdngZ79BGH1uD88?=
 =?us-ascii?Q?K4Po/Xbsd2c5lVb3xm0pbYUEsuQtljhX1q+eHqF/0vYMtB9B/YXSS0qGwHOJ?=
 =?us-ascii?Q?ENzXPSfqanyVAXicGg6CokxQxTWGvQp4eiFhHF55Ur/MPZRsmF/VYduzVmg7?=
 =?us-ascii?Q?Nakx4Pqmaiyu25tlWj2vjWiIBz7TIFcpGTVr/6DKQnnyQjJj/fRgpmOWUkbQ?=
 =?us-ascii?Q?FcMGQvJuvsApFX14Nnocg23xR5QAMlinEIqR5MKeBMVj/J1j7JUEbBzbAGxw?=
 =?us-ascii?Q?4iDgT2jZT3GzdbEIi7MMEkCDaOqpp0nqpWz+p0oUCKvtSP/bc9+50gugj1ww?=
 =?us-ascii?Q?LMU4hzDoK3a2GxbzdU2/4UFgXcZxelcxGfdHO0c0jjaXvxWApHUyyxpmeakw?=
 =?us-ascii?Q?pdGoteygcazNlCoBYibo6EEvPcd7txy5VfBEX6AYIlWxq8kNyQzdQZJVZj48?=
 =?us-ascii?Q?oCye89+547tUXHpxpb/StxEB26V2l5e1ePzXb+CrCgG+KIYBdG3dsUUKv066?=
 =?us-ascii?Q?hUd+voKQJYM=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?guw5AlT/DTmwLxDtfHbw2iE/72Vsi0TzD/xE7PSvt918mZz0tGZ6xAl52jKD?=
 =?us-ascii?Q?0j8p76Xau/gAD9phMVCkgZLhAA434eVFseCX9ut8CxJdkQmf6PTDtnj+T8od?=
 =?us-ascii?Q?vsouEJrJzsluaZMYtwMy5PXuT9wpSe4G3XoR/cRRE71+HojvXBOg0uLyOXGR?=
 =?us-ascii?Q?c25W0jjNWXG5Usbhf8jRcv+IlAuUfeTqJqSrf51aZWOiDZO/bVuYGHZi61Kf?=
 =?us-ascii?Q?rZNEq1dGmmsdBsXOJwNJ2EHFQff7M8BlW6KcBSLcJA42FDfWOHV5dMUonVmW?=
 =?us-ascii?Q?q9c8QJx5f39MKMcgFCxB2+ZVyP0xKAhpfgL9Y7iZhYOXSPwuRa4C5jH3dS6a?=
 =?us-ascii?Q?QWtoOwjtAfx1yXAk5RPaI/xRc/FW//jTJ0CiRbDYb0evseyrShLsOzQxQ/ii?=
 =?us-ascii?Q?mB5C8fkuJFoIft3CwgxZutLLIlbBqQku2+k44IThNs8oVQMaIgpI0cPnWwDa?=
 =?us-ascii?Q?l+W4RrF9Y/bSQ+Cswq5n5hmjTDMQwRW8oEKgGL1zZOF/x/D6HhDLAbYHnris?=
 =?us-ascii?Q?xPw62++PJa4Vn2kOKfYkzxg7UgU2xUbn2h3D7vtLb0AEkzN4r9mawrNu5pEM?=
 =?us-ascii?Q?/fuu7HhH8djkvg92V9v7mUNxODk1QEMjSidM4er7wSQ9MQL0m2RjdZLEuHHJ?=
 =?us-ascii?Q?HTHfbzSb612XJz8xXb2538ObuFIgxnSMKiorKC5Qg16WZJ4L8SYsCzYkkFEc?=
 =?us-ascii?Q?KWPHd0LTpzQir8h/JX6fSyx1uwnkY9vs0r5wHtxYzEZJq0K+ubCgL7xYkuuP?=
 =?us-ascii?Q?xlP7P7fWLpKsSmwBUCbNfZN31vXrL8WrVRA1Hc2gFSSqYhOOEHiwzSm3Tfyc?=
 =?us-ascii?Q?awplgeTXL1fDF/Vm2io4grOVPZXLIemJNraR8qO/2TbR5v5JvQ9k0ZaeWY+7?=
 =?us-ascii?Q?nA+Na7G/Ri1fVde6ZuiFLP3YrVkIS9pyXZngOgEjOtNt9s6Vg2fXVmBS8oFC?=
 =?us-ascii?Q?/EDEveX59qreLyIBSKUkJeJLXkLE+AIpoGrUhS1zs8ADo0rniQSODuPuu82q?=
 =?us-ascii?Q?7PdPe6AA/+TJ9tDoG4jnPz/TC2Q8VkzcfJE3opPMERQ1R+0FUXcMfTxmeyFj?=
 =?us-ascii?Q?Bqd1SYF/Qy40qOzrYrvzdP4RthBcZ/IKgfgem9VDMSkFxzSgSC2W1zpCI4lG?=
 =?us-ascii?Q?ioji/sT0WVP4XCaRdHqjjZ/ehCVdmOZdC8sFqlUUZ6BcIvo48UxoxvgmvfKm?=
 =?us-ascii?Q?vj8C9/cy43x4scidpVimpJD8ww2FPFMXnBDcMjQUocI4bgtkMI3bn0OICs07?=
 =?us-ascii?Q?XJ4HDl29WnCVgCoBHEHAeq16oEFWhF3yZapfCm0QHGH7t4jaq794A79RWIoD?=
 =?us-ascii?Q?qBqaqIxjt3M0y93j5F/JAYkpeKCDwUNKBdD5x2MQtLr//7+DHaNEm2+qZONY?=
 =?us-ascii?Q?haFl4NSLdSHhCW2Tr5QCFSIF1yvZzHT6N25n3clzwp5dnyfqoMVXFVXzKQNR?=
 =?us-ascii?Q?V0tt5uUrU0Ho+GltPNTrexK82Jnz7USbpnP8f88nkcB9sjIS+5VOYRfLpvWD?=
 =?us-ascii?Q?Q/I4WJyOLwIGoNasRfXEE3juxbTxfQ66zrpJ/RdgbihJgBrtZuS+zRhcMfyK?=
 =?us-ascii?Q?UUSz/qkRTOdLrO/tRApGzuTP7T0BFg2aIve5YD3U?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bcb1445-df42-4fe0-3fd1-08dda7baab8a
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2025 01:03:54.5352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilr2RQ5UEgkJAzXDqUl/iaqV+9yN6db3vFGnrx2WTq3DyJPAPwD6Bkfr0DBdL4e+CX+qdhNASLdRHwPQxbgvJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB8059
X-OriginatorOrg: intel.com

On Mon, Jun 09, 2025 at 11:02:49AM +0300, Nikolay Borisov wrote:
>
>
>On 6/9/25 10:53, Chao Gao wrote:
>> > > +config INTEL_TDX_MODULE_UPDATE
>> > > +	bool "Intel TDX module runtime update"
>> > > +	depends on INTEL_TDX_HOST
>> > > +	help
>> > > +	  This enables the kernel to support TDX module runtime update. This allows
>> > > +	  the admin to upgrade the TDX module to a newer one without the need to
>> > > +	  terminate running TDX guests.
>> > > +
>> > > +	  If unsure, say N.
>> > > +
>> > 
>> > WHy should this be conditional?
>> > 
>> 
>> Good question. I don't have a strong reason, but here are my considerations:
>> 
>> 1. Runtime updates aren't strictly necessary for TDX functionalities. Users can
>>     update the TDX module via BIOS updates and reboot if service downtime isn't
>>     a concern.
>> 
>> 2. Selecting TDX module updates requires selecting FW_UPLOAD and FW_LOADER,
>>     which I think will significantly increase the kernel size if FW_UPLOAD/LOADER
>>     won't otherwise be selected.
>
>If size is a consideration (but given the size of machines that are likely to
>run CoCo guests I'd say it's not) then don't make this a user-configurable
>option but rather make it depend on TDX being selected and
>FW_UPLOAD/FW_LOADER being selected.

But in almost all existing cases, 'select FW_UPLOAD/LOADER' is used rather than
'depends on FW_UPLOAD/LOADER'. You can verify this by running

	find . -name 'Kconfig' -exec grep -E 'FW_UPLOAD|FW_LOADER$' {} +

>
>I'd rather keep the user visible options to a minimum, especially something
>such as this update functionality.
>
>But in any case I'd like to hear other opinions as well.

Yeah, let's see what others think.

<snip>

