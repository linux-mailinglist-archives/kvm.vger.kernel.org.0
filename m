Return-Path: <kvm+bounces-63840-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DE5CFC73FEE
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 13:38:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sto.lore.kernel.org (Postfix) with ESMTPS id 57C4C241D6
	for <lists+kvm@lfdr.de>; Thu, 20 Nov 2025 12:38:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E9F337B84;
	Thu, 20 Nov 2025 12:37:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Opv0DTia"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911C6337B81;
	Thu, 20 Nov 2025 12:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763642262; cv=fail; b=XJpsGjKwWMu9hZvIJd17NfzZxjLSiLoA/PGPNGRtrrP1dDkXhlXfwykv+mfltZ08bFiwZEkmISNwT1RRMXJVrNUvV12Pdz2shkzub2POrYQbsx8yM7r/h31mA/tKKay+pwJRlV6WfPArExG9GWjg7+jnJDubXFpG1fn/zHK8Apc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763642262; c=relaxed/simple;
	bh=21Ju+TexsfQrxsrlM0wLtrmPYfbgGpC5pYIz8RM4SGo=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GHbI7oItMBR9yj6qflGdca7g5rA1xUVZHsGShMDl+GbR/sCpML9Tc5qxLEb4TZ97Y7B4tvquGSsGAKZ/xGYNhOAbHCGUDeTcI0ckuELWBil0k+0C05i7MZyeM6+7fWJpwe+w63X0OyKxdJVTdk04nKq69os3sKxIKbZUODzkr2U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Opv0DTia; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763642259; x=1795178259;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=21Ju+TexsfQrxsrlM0wLtrmPYfbgGpC5pYIz8RM4SGo=;
  b=Opv0DTialo5d2cKrtYIULBOgaubEFKXx+0I3I736dC8o6sqBfCQ4NjEI
   aesywV8g1EjuJ797sXb8qt3qiDslZ3hqfn+FxXZrStUug1wTggG+yJwby
   RTu+S5/nFnEq5qjTJJ0XHHxaoY3wTnY8F7gZ3lRZkqLo7/76RJiwPE4LD
   c4BX7GYdJUNxUBRal2vYGrZUwWkgSvQI+h9L5WHNmmoR3D0CiFBasy0gx
   4TvK5E4kz9Z/o1gvQY3j1/bQ/mQNoq+06TVcmqiEhYvUy4auuejjJL0On
   Hkla+38DfjC3VCtl1j6n8lFilRherlwMogP4unh9HK/PeaipOvOsPaynX
   w==;
X-CSE-ConnectionGUID: 0hs5/r9VSjyE2/G7G/4fDA==
X-CSE-MsgGUID: XgC1F9XNSSKOGKjYJvmdUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11618"; a="69565084"
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="69565084"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:14 -0800
X-CSE-ConnectionGUID: 4bBmformQ6CaB4HIErZ1Tg==
X-CSE-MsgGUID: 66U0RZRyTt6X3cJPiSWPCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.20,213,1758610800"; 
   d="scan'208";a="196324976"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by fmviesa004.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 04:37:13 -0800
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:12 -0800
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 20 Nov 2025 04:37:12 -0800
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.36) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 20 Nov 2025 04:37:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E8mQ4d2f4VE0lBpIek03N7oMkDLUiLn6xVLPTY4uaIAMXgqlqhtke6hOAy6l19o1XpecUTI2e54q4TMOVVr+3SGXNYvLWIseC8URwThPNRKNzmWWf7ooBwjm+pp0dObCdKaG3WBK7004EIXtZSzq9gs0jFN+QhkYkg+uBubrbsSUByRXEpI7PedSKAO/dciaLcNIV2cDwwj44YMLsW1MjeLYxQqQC7R4dP5TiXu+ufUWBwJyHD7W3uqeree0KbP+gpGyDF2XZaleDVsxHCv3QAv+kYUVlhJlqjCaoBUn177+tvE3PiW7rG9o+kguG0c0oWq8LFAC8MqhRb4idx1tHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1kPmxeChkpGEMRNBkPCHYFx4TArChILyvcG1VU0j3Js=;
 b=OWjuwR+Pg1rME1xQrLjfbp3iEjyrKtBidy4UUsrOdcw2qZD2CZEuH7r/RXZ/EHETBM+DtMDo13v3UfW/TyVeeZmgdhMtMy/NWyJI02xf0pN6dUqYXoKiZ3OBbwKAjUkVjNAgNlx9K6AZSpADTVeJfi1GDqVrjHg4tdgFBhrz45eoZbdOk3i1hIOTamxRaKGFJvYjpnCgRCA6x45Udg0BXwIMLMbpIkfMs22Rc6SSde8GOghbSCTP3N4HoBuQmKC/VtcCdKV777+5LB+NGYUL65QTClqkDz11K/VWcQ5pV3knhbuE5/k0XGDcH5CHtP+pQOrMvDOTuFPms+pU/ApOPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5373.namprd11.prod.outlook.com (2603:10b6:5:394::7) by
 DM3PPFC3B7BD011.namprd11.prod.outlook.com (2603:10b6:f:fc00::f49) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9343.11; Thu, 20 Nov
 2025 12:37:09 +0000
Received: from DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39]) by DM4PR11MB5373.namprd11.prod.outlook.com
 ([fe80::927a:9c08:26f7:5b39%5]) with mapi id 15.20.9343.011; Thu, 20 Nov 2025
 12:37:09 +0000
From: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Alex Williamson <alex@shazbot.org>, "Kevin
 Tian" <kevin.tian@intel.com>, Yishai Hadas <yishaih@nvidia.com>, Longfang Liu
	<liulongfang@huawei.com>, Shameer Kolothum <skolothumtho@nvidia.com>, "Brett
 Creeley" <brett.creeley@amd.com>, Giovanni Cabiddu
	<giovanni.cabiddu@intel.com>, <kvm@vger.kernel.org>, <qat-linux@intel.com>,
	<virtualization@lists.linux.dev>, <linux-kernel@vger.kernel.org>
CC: =?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>
Subject: [PATCH 1/6] vfio: Introduce .migration_reset_state() callback
Date: Thu, 20 Nov 2025 13:36:42 +0100
Message-ID: <20251120123647.3522082-2-michal.winiarski@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251120123647.3522082-1-michal.winiarski@intel.com>
References: <20251120123647.3522082-1-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR04CA0104.eurprd04.prod.outlook.com
 (2603:10a6:803:64::39) To DM4PR11MB5373.namprd11.prod.outlook.com
 (2603:10b6:5:394::7)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5373:EE_|DM3PPFC3B7BD011:EE_
X-MS-Office365-Filtering-Correlation-Id: 94d74692-ae19-44a8-0333-08de2831859c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?NFFNc2w3ZEZLaHhFN2wxaUdGQU5xOHZoKzFlMnpBeHZBbkpQZlBqeWVXSnBy?=
 =?utf-8?B?QlVSWnhqRFNMa3dZQTVobnN6MkZOLytNSjNueXJvZG9ER2RtUG9adU9Wd0Js?=
 =?utf-8?B?WTF1MmhYbTN5RzlzTXZYQlN5VWgxU1RrTytHYm9nbVd0QWtXSEdaejdhVjdr?=
 =?utf-8?B?MkhWTmhOOUF5YXFNNzFsYXJVUkZqUldYcmtpWlZXQ1dndXM2VHp0NWhWeEZY?=
 =?utf-8?B?aklNZDM2SnlXT28rWUJkTGNhd0ROb1NvZ00vL3VLanlWb2pVenJLcXpGM1ov?=
 =?utf-8?B?WEx0czlranEzSHBkMHBHaHdYbEVTQVNEWWVpc3hvcncvMVpMeStHV3FRUWxJ?=
 =?utf-8?B?d2ZlQjBrWWdOOUhGdnBPdGpGWmZpenZKMjg0RlFZRG45T2lzT0l5K0pJSDFj?=
 =?utf-8?B?OXA5NmNseVZqcHMvZUJkbzYzbkdkNUJlS3VYb2UxQzRHczNCancySk95NHRN?=
 =?utf-8?B?eVZoeE5rN1NnMTczdUI0b01ZUnFkT3djbE5hcHdPRXcwV0k0SGZHRjNMVmpB?=
 =?utf-8?B?MzZYTHhOZENPRXBoMWsvOWhISXExL0RvSnlEV2VDZjMrU0FlbWgxMU5Sb0h4?=
 =?utf-8?B?Smt3MEQxYnd6UmJkbGU0N3NtK2o3dG5Nays4U0tiRFEvUFdkQ3NIYlBRbFF4?=
 =?utf-8?B?dy9jSlFhOXY5aU1ZakdYdVZuS2w3OVYxRk1EZDRLdE9yK1RpS0E0QkQ5STdj?=
 =?utf-8?B?OWI4VjNYdEdKSFAyZWptc1hNZVcxZXVkMkh5Y2NlNnNrSFZGZFFjb3dlaGx6?=
 =?utf-8?B?STVBYTJEWUkrZHBrcjBvWXBoL1FRSk9qd2c1bUpINnl6S3VGSnF4U0NsblF0?=
 =?utf-8?B?VmczT1oyeVNsUGlaODByN2NEMjgxZnd3VjliZ3VYdHVKcHJGVUxzV29jZWpG?=
 =?utf-8?B?Z2lUeGdRUzZjdEVKa2N4QnlySDVBdnFYT0N6aW9oelNUSU1uNlZFeVJMVjlZ?=
 =?utf-8?B?am5nN2NLUjZTQ2lGNGFhSlRZWHJhUmFLSVROU3g4eFQ0ek5lWDl6aVgyb0pm?=
 =?utf-8?B?WXlJY0VTOG53MjhiL0lML3RuY28zUGVvbGFFV3NQRXFWUk5EcDJnQU0xVXp5?=
 =?utf-8?B?VTZnU3dVZFkrTEZqZjFaWlJHdTFTdko4ZFpPOEhackNSbmFVYXpzemJBU2Fk?=
 =?utf-8?B?ekszRXdXZm4yZW5kWWIvMlNxZDNhbWF5R3BJZmZOMVBPOGJCMFcrN1Uza0hi?=
 =?utf-8?B?WTg2UW1FMzROL1dYOFUvNU5mWFF0TkJjS2JlSlp6VE9jTTFBTUJzMzh6VVFy?=
 =?utf-8?B?UGJ6dytWUkJVWkRIQXZzNlJTdDJJRFRDM09UVUlCNFoyNFAvdFBHWm4yZXJQ?=
 =?utf-8?B?V2JwK0xobVpDUDFMYkkyazM5aWg3akFEZkdqK09ldlpYSVhXQ1BzRTdZRS9k?=
 =?utf-8?B?eDhYbXJaNzdjVnFkQ2tjNnRDSEhlNllDWldVd0VwOUxhMlFFcDlDdDV2aGxz?=
 =?utf-8?B?cE1iQjdJbVN4TU54OVZTcmxXUHhjbG5NT3lZRVZXRmUrVU5MQzBCajU1VU15?=
 =?utf-8?B?TFJJYlFtSEFXV0tWdE1OWDdUcnhlRUZsQVBsUmc0cVF1cnRhQkp4RWl2RW9K?=
 =?utf-8?B?aHRDWk1KS1lCKy9iczBNdUxjSWY4RXBMQkZTYlZTbUg4ZTBoVnYxVG82MTZJ?=
 =?utf-8?B?aG1ib0NOUWRzZ2lTWGE1UzZPdXVuRllkR0hvVnZVTVdraVpOWUxKenNYRjZk?=
 =?utf-8?B?RW14OERsdWhYZmhDSm1HMVM1QnpBNkZwbWlEdUFjenJyY0FRK29zbWNPd2hO?=
 =?utf-8?B?WE9LY3krbXcyclRjQkRHR0tqY1hQWnZ0dUwrV2wzYUVWcndVWjlIblNvZHMz?=
 =?utf-8?B?cWx0Y01maDJ2WmRCSjd4cHM5ZUZxajBobzJ6dTYrQlp0NS9FSitSaDNycG5x?=
 =?utf-8?B?N3JqY0pDRExXR1JEU0hFc3Jkb2daTVN5b1FSVW4zdFc3eW4rK1FVQXhIWGVl?=
 =?utf-8?B?ckR1anFOcnR6dFVBVlZ0WnRnL2V3VVlremRaT2RCdnUxNDVtNldZRFF6czlj?=
 =?utf-8?B?UEYza1pHVC9jTU9jYlJ5S0F3SDc0b3BqLzRSNC9QZkhYUHRmTlhmbVdvZThp?=
 =?utf-8?Q?t++k3L?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlE0dk1vbXZveE5SUVlpY3owWEJONGNYUGkrd3hOMEFQcVQxRHlLWEtiRXlY?=
 =?utf-8?B?QTVXZXByT0p2c2FFRStpMWNnVm50cC83N2dUZjQ5R29hdElFL09qYWVWUHlY?=
 =?utf-8?B?NnVIUndjODlyZ2wzSmpJc3ZHYk9VSWNZeWJoT2QzMWZxajd1VHF3WWk2VU5s?=
 =?utf-8?B?S1FUSG1YYkgrWGdkVWZybVBjMFA3VDdTeHE1bVBKUkhlRFpiVU9BMitNQ0gx?=
 =?utf-8?B?R1B1MUJkejE0ZURhYTVTakVWMFUydjZwOHY4RkczdSs4VnlPbVNhUXcya216?=
 =?utf-8?B?RFd5MTFieGF1OFJSa21tRDRGa2s2R3M5OFFTOXFBSU5xZ0RTUW1xNjd5aWpz?=
 =?utf-8?B?ZXQ4R1ozZUZ4c3JxcnU3bnJSd2ltM0s4WkowcnEyeEZUc2xDcWpmYzRRMFJH?=
 =?utf-8?B?MlRndDcrdEcvNVpqdGpPd2Q4STZUZHBhNnpVajFJTUZmTFV6cS9EaGtLV0xa?=
 =?utf-8?B?SG1JZnlYN25ZUDROQTBoaEZDdkJ2QmtwNCsyeDUwZ2pPN1N1MS9zeTdYMWVM?=
 =?utf-8?B?dE04TFJTeGhNNGR2RzFNb3k5dU1lVGIvS0N1bHl6RkcrSXllbkpYbVpYbjVj?=
 =?utf-8?B?Q3R0bEFyT1BMMUdpMTMxY3pVMzJiemMvK1RPZTdkT1FqVm1uK1N4NFYzT0hk?=
 =?utf-8?B?aVM2bFJIdUVKYmphWnhRdUpUdnNIZmdLb0diQ09zN2F3RERPSDZvRUdVWXla?=
 =?utf-8?B?NEovU2t6WUhjNlN5RzQ4RTI5QWVCUGxkY2JJTHE0QjJvVDFCMEJEOGk2ek1t?=
 =?utf-8?B?S2VmbHlPMFFkMTNabFZTMmhIUlNsTU1yUC80dU9iT3Q0ZURwMjZGSjd2Z09i?=
 =?utf-8?B?K250WGdTQTYvekxhZmRsdTBBTjVUclRJMHQwK3JsTGpubFBXcXZYM1dIU1ZU?=
 =?utf-8?B?U0hnTktsdmZjQmFmZndSQTBmOG9uZzJYakNFTk0xeVlPQnFnU0ZueXBaeGM5?=
 =?utf-8?B?L2VRakFwRjJGVkdjQWJ3Z2cvb0w0dy9oaWIzZDJ3NGR2b3NaRk9INlhBNStz?=
 =?utf-8?B?SGowSEN3c3pJc01kWmRNK1FOS3BjbVFETmpPQU5jaEtsdVladGp2K1RCS2k0?=
 =?utf-8?B?K2NwRStpTHVLMGw1bHQyYW5ObXpra0syQyswT2s2cHJWSFdoMkhPZ0VubmNj?=
 =?utf-8?B?VE1RN2VDbkZLbVkxaXBkTHVCcWxqZ3BHTDdtK1lpS1VudWRnNnhmSEtiQ0FW?=
 =?utf-8?B?MFJ3Rjc1Umw0Z2ZYaTlnU0ZjZWphVEdoSzV4UktrdStDaVp5MmtGdXM3SU94?=
 =?utf-8?B?dFFRRU9LSllCL3NIYzBVUk1QWUpFeUlIRkFHYUE4NGdHSS8zUVkxVVBRWEpk?=
 =?utf-8?B?blc1S2NLTUgwd0I1T0g5d2NtODN1M081QzJoV1V0bWJ4QzJydklOUXJ1cHVG?=
 =?utf-8?B?b0lkdWVzY0JPSndsbXVzcllxK2NTZ2FBM1RHRzg1d2crb2tqZmVrZlRqZkdl?=
 =?utf-8?B?UXRaOU9zUWsrQUVwenF2c1ZMZEVFcTJIMXUzY3laVVYrQnZWM0hiZXpNUXQ3?=
 =?utf-8?B?MjFlMXRNYTllNVVHOVlJalh5ODRWVXZma0Zoa2NueHRsaGwwUDJzNncxWWJv?=
 =?utf-8?B?M3NjNHgrdzlMSW1mQTc4czRrMUtPWVBNNEp2d2Y3OVlwQ0ZoYlBnYUtHWmh4?=
 =?utf-8?B?amFVa09XTVl4dFlxd1hBazMwaDBISlF1dERidWtNM0VRVVhTby80N3VRaHB2?=
 =?utf-8?B?WGMrcmJUbWdWUEIzdVFManViSE84eVVBUXVQZnRzL2x1S09QRjRvTmlmZ3hC?=
 =?utf-8?B?NkhNM1JIM09ISDJMblZRTllRTEpFaGNoOUZpbFRQcmVNYzBWdU1DbjFtRlY1?=
 =?utf-8?B?MllYUDZGRDJ4U3RRMHZNd3phaWtodmFrcDF3Q2pTV0YxNEJlcXA1RFo5U1Rw?=
 =?utf-8?B?UTdlVUhKbGUwa1UxYUhNbTNmdFlYVkJ6aTJEY3l1N3ZqU1AvTktwZW9McDBM?=
 =?utf-8?B?VHpuc1hSeUJrSDNwMWdlR3h5WkdWTkV5S1dYSXViWTNPQTVzdDZCaE9wMVl0?=
 =?utf-8?B?c1AxKzZmVFFJWUV4UHM1T1lGaGNqWGN1bXJMdGVOenJpVEFzUUNpdi9WbUFo?=
 =?utf-8?B?amZKNG00SlRDbnZ2NzNWTWtJdFlNUmRFQjZtNzJYdy9WQlA0RkF2NE5sQUdl?=
 =?utf-8?B?cXJNR1ZrL01lZGlrUmxSRDVyY2N4TmxJUjEyWnBVeFZUQzZnVkdubm4wb09u?=
 =?utf-8?B?clE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 94d74692-ae19-44a8-0333-08de2831859c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2025 12:37:09.6005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sSdTgKt7wX2qKUubCSesnE/xmkt7ThzG7dPqVRG+uvOuQEAk4syC/i7UHnWCXdYCE9sTzwoCybL25p75fT0jssW/qMk7LsVOHUomfHkM3zA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFC3B7BD011
X-OriginatorOrg: intel.com

Resetting the migration device state is typically delegated to PCI
.reset_done() callback.
With VFIO, reset is usually called under vdev->memory_lock, which causes
lockdep to report a following circular locking dependency scenario:

0: set_device_state
driver->state_mutex -> migf->lock
1: data_read
migf->lock -> mm->mmap_lock
2: vfio_pin_dma
mm->mmap_lock -> vdev->memory_lock
3: vfio_pci_ioctl_reset
vdev->memory_lock -> driver->state_mutex

Introduce a .migration_reset_state() callback called outside of
vdev->memory_lock to break the dependency chain.

Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
---
 drivers/vfio/pci/vfio_pci_core.c | 25 ++++++++++++++++++++++---
 include/linux/vfio.h             |  4 ++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 7dcf5439dedc9..d919636558ec8 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -553,6 +553,16 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 }
 EXPORT_SYMBOL_GPL(vfio_pci_core_enable);
 
+static void vfio_pci_dev_migration_reset_state(struct vfio_pci_core_device *vdev)
+{
+	lockdep_assert_not_held(&vdev->memory_lock);
+
+	if (!vdev->vdev.mig_ops->migration_reset_state)
+		return;
+
+	vdev->vdev.mig_ops->migration_reset_state(&vdev->vdev);
+}
+
 void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 {
 	struct pci_dev *pdev = vdev->pdev;
@@ -662,8 +672,10 @@ void vfio_pci_core_disable(struct vfio_pci_core_device *vdev)
 	 * overwrite the previously restored configuration information.
 	 */
 	if (vdev->reset_works && pci_dev_trylock(pdev)) {
-		if (!__pci_reset_function_locked(pdev))
+		if (!__pci_reset_function_locked(pdev)) {
 			vdev->needs_reset = false;
+			vfio_pci_dev_migration_reset_state(vdev);
+		}
 		pci_dev_unlock(pdev);
 	}
 
@@ -1230,6 +1242,8 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 	ret = pci_try_reset_function(vdev->pdev);
 	up_write(&vdev->memory_lock);
 
+	vfio_pci_dev_migration_reset_state(vdev);
+
 	return ret;
 }
 
@@ -2129,6 +2143,7 @@ int vfio_pci_core_register_device(struct vfio_pci_core_device *vdev)
 	if (vdev->vdev.mig_ops) {
 		if (!(vdev->vdev.mig_ops->migration_get_state &&
 		      vdev->vdev.mig_ops->migration_set_state &&
+		      vdev->vdev.mig_ops->migration_reset_state &&
 		      vdev->vdev.mig_ops->migration_get_data_size) ||
 		    !(vdev->vdev.migration_flags & VFIO_MIGRATION_STOP_COPY))
 			return -EINVAL;
@@ -2486,8 +2501,10 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 
 err_undo:
 	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
-					 vdev.dev_set_list)
+					 vdev.dev_set_list) {
 		up_write(&vdev->memory_lock);
+		vfio_pci_dev_migration_reset_state(vdev);
+	}
 
 	list_for_each_entry(vdev, &dev_set->device_list, vdev.dev_set_list)
 		pm_runtime_put(&vdev->pdev->dev);
@@ -2543,8 +2560,10 @@ static void vfio_pci_dev_set_try_reset(struct vfio_device_set *dev_set)
 		reset_done = true;
 
 	list_for_each_entry(cur, &dev_set->device_list, vdev.dev_set_list) {
-		if (reset_done)
+		if (reset_done) {
 			cur->needs_reset = false;
+			vfio_pci_dev_migration_reset_state(cur);
+		}
 
 		if (!disable_idle_d3)
 			pm_runtime_put(&cur->pdev->dev);
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index eb563f538dee5..36aab2df40700 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -213,6 +213,9 @@ static inline bool vfio_device_cdev_opened(struct vfio_device *device)
  * @migration_get_state: Optional callback to get the migration state for
  *         devices that support migration. It's mandatory for
  *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
+ * @migration_reset_state: Optional callback to reset the migration state for
+ *         devices that support migration. It's mandatory for
+ *         VFIO_DEVICE_FEATURE_MIGRATION migration support.
  * @migration_get_data_size: Optional callback to get the estimated data
  *          length that will be required to complete stop copy. It's mandatory for
  *          VFIO_DEVICE_FEATURE_MIGRATION migration support.
@@ -223,6 +226,7 @@ struct vfio_migration_ops {
 		enum vfio_device_mig_state new_state);
 	int (*migration_get_state)(struct vfio_device *device,
 				   enum vfio_device_mig_state *curr_state);
+	void (*migration_reset_state)(struct vfio_device *device);
 	int (*migration_get_data_size)(struct vfio_device *device,
 				       unsigned long *stop_copy_length);
 };
-- 
2.51.2


