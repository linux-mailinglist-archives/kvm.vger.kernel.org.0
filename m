Return-Path: <kvm+bounces-60925-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B92FC039DE
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 23:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D037B4F7CF4
	for <lists+kvm@lfdr.de>; Thu, 23 Oct 2025 21:50:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B4862580D1;
	Thu, 23 Oct 2025 21:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g2ToLg4E"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 915519463;
	Thu, 23 Oct 2025 21:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761256244; cv=fail; b=gUQSwqc4yzGxJHUVstkOlLO4RoO/1c1DfvWsNZBwGcN+UrUq12tjR4og16wb9YQeR3iiz9JMEhGK2I7CDJ0Y+1/Sqe2SoF20FpbWkrkmmkEdoFuS8g7JmzgynuTs19m8YO5n9IZ9bI3kQiOBCs8u5YPs2/6aiS20P9rl9/dH9TE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761256244; c=relaxed/simple;
	bh=Xi37GdK++Fl9tSp6rQOMn393SHAx2L2A2a4Mr6YH8NI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=leYMueHvySl+FkKBfTy9p4JdH8d+zkqwkYYPFK1KD4O5svpwyqghaXd1X47u/90Vr41gSJs6bE9dLuTGXEBFCOXX/snPyMUIc3bTbaW7/vcLrFO0pTu9Lg/mOXvKqUCQRdpu+bZgB2YgXV+X7orRoc/CREmVdcAZbHRI3nVmxZk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g2ToLg4E; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761256243; x=1792792243;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Xi37GdK++Fl9tSp6rQOMn393SHAx2L2A2a4Mr6YH8NI=;
  b=g2ToLg4EbgZg5l84RqmdARdAX9p4NFXX2pmbghY1MElkbVfazA7KCpQA
   YR5LSdcUaDRjz0Pm1GLefGW95ZNntjnjzl78I/ieuiJ0RtIQHuP2ftP8k
   tbDVvOkeMY2oQVCz6c3d/SgWvrXM/kk/x80F0RxTwDHRD5XMYTPpx1Pfe
   py2dfa5FlHLq8eyxZBjPfHasAzyqCVJvAo/FPA/GIoRZkuFsUjG9cRG3S
   pmD8XSZfXqKIqStkDgI31vf3VvnaoZLBgPAOSReoNKP5pqo+7SycFVa46
   luc58pPhvctOIQkEtWZVjdVBrSn7kM6VmsU+1HO4B662b/6MoCiepZwyQ
   g==;
X-CSE-ConnectionGUID: TEEd/UFORkiJgR6MuI1lqQ==
X-CSE-MsgGUID: x6rSdrwCRuewgorK/4cb4w==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="63475558"
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="63475558"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 14:50:42 -0700
X-CSE-ConnectionGUID: 2GSYdmGZRq6JP9FwSBHVFA==
X-CSE-MsgGUID: KACSxOavQN670Enk45yIfw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,250,1754982000"; 
   d="scan'208";a="183874028"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2025 14:50:42 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 14:50:37 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Thu, 23 Oct 2025 14:50:37 -0700
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.65) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Thu, 23 Oct 2025 14:50:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=uy8fwcMWJUvtw/eWFwOBukRj0GDiOFVkW/7sdpif8rKEaXKB+kP5ZlXYx0wxW148kil+UX8AcmPNpVlDnx3s2e+Vwi3VmiUh7ObxrPdP3pCfxu7yCm8cwAcVfzAXUh7etpYOU6uIH0Zs8MwlgTVFvVji+AWdd1PYek4h48tObEPMFMo6ndLy1g5DNTWQ0IsEaQRSMB8nrRjGR2VuFo28cg/gIwkc1gCKEWPOETe6ZzhTBZCPokVX2PFyKiGBFTkOYllOzCAYp2Hmwxtc6ZQpB3qePxEMh7PhaY6XrjGufmGMfAhXKN4KnEE+DCvdzXf5X9A/xt98nq246+6LL6Tqzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XY3OJ0O/pQVJba/4UHfLV5FOn7v2EEzilSjklf3Wr40=;
 b=KrIe14As9X2dPcB4ey9DiB5WaOsPL0FJs0Zxu+3K/Xqtgk/zd1CKtfF5gl9w5NdULjX1Kao8PcfYUTYBjJiydrvqiHt33PltzMmnMkmWHXAJWX6hpRu+6IxusY48FVPwcn7DMGtKiM9RIeCJ/YEvkOU5dRRJgYobarVfrGfVeUt1/L1NSxTx8ahOEs8NrwXUkhedXy67DiSyj0n3+WFjy4eFe954pJIfGMvbl64dzEyKzDe+QALWpnaNxLgDSciEH2hnSSq4E5IGuds63vPzrqeCa9wZDMU0TeOzhFZn1cFMRrH9NjztNcQ3gZRcGt0630T5xM4qGeYtuXewSEHysA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6011.namprd11.prod.outlook.com (2603:10b6:208:372::6)
 by SA2PR11MB4811.namprd11.prod.outlook.com (2603:10b6:806:11d::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Thu, 23 Oct
 2025 21:50:34 +0000
Received: from MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267]) by MN0PR11MB6011.namprd11.prod.outlook.com
 ([fe80::bbbc:5368:4433:4267%6]) with mapi id 15.20.9253.011; Thu, 23 Oct 2025
 21:50:34 +0000
Message-ID: <92122385-b328-4e96-8f2f-525dff69e3f2@intel.com>
Date: Thu, 23 Oct 2025 23:50:28 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 16/26] drm/xe/pf: Add helpers for VF GGTT migration
 data handling
To: =?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, "Alex
 Williamson" <alex.williamson@redhat.com>, Lucas De Marchi
	<lucas.demarchi@intel.com>, =?UTF-8?Q?Thomas_Hellstr=C3=B6m?=
	<thomas.hellstrom@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Yishai Hadas <yishaih@nvidia.com>, Kevin Tian
	<kevin.tian@intel.com>, <intel-xe@lists.freedesktop.org>,
	<linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>, Matthew Brost
	<matthew.brost@intel.com>
CC: <dri-devel@lists.freedesktop.org>, Jani Nikula
	<jani.nikula@linux.intel.com>, Joonas Lahtinen
	<joonas.lahtinen@linux.intel.com>, Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, "Lukasz
 Laguna" <lukasz.laguna@intel.com>
References: <20251021224133.577765-1-michal.winiarski@intel.com>
 <20251021224133.577765-17-michal.winiarski@intel.com>
Content-Language: en-US
From: Michal Wajdeczko <michal.wajdeczko@intel.com>
In-Reply-To: <20251021224133.577765-17-michal.winiarski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: VI1PR0902CA0060.eurprd09.prod.outlook.com
 (2603:10a6:802:1::49) To MN0PR11MB6011.namprd11.prod.outlook.com
 (2603:10b6:208:372::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6011:EE_|SA2PR11MB4811:EE_
X-MS-Office365-Filtering-Correlation-Id: 497962d2-2022-4c8a-ccfc-08de127e31d1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|7416014|376014|366016|921020;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?L0REYlE1RGN0RXJhc1B3c3hFK0E2a3A3QW16NkVNc2tkRnRLc0RXVmNZSTFL?=
 =?utf-8?B?ZHE0b25BUUhGYmtiUmFiV3c2clRIOFNtcndURDdkY0RoemxLQW93WUdWRC9J?=
 =?utf-8?B?Q0pVdEJyYmFFNXRacGRybUNaNnNnVFhwSkpqS0dEcEUrVzdGT1lqN3RQUUN2?=
 =?utf-8?B?RjVpSjBQTGV4ZXlCWUppR3QxQWI0b1VSRWtXKytvelN2UEVnSlpFejJLOGNQ?=
 =?utf-8?B?TUNmTWxxR2xQeHNIRXRYRFJHdG0zcGNnSURncXpBMk16QnowQTRUdzNXRE1J?=
 =?utf-8?B?VW9UVXY4bmc2d1FtbVdGbUNkUzNORjh0dTNWcnhXL3hadlZ6ZGw1czJQNmdC?=
 =?utf-8?B?encrc2ZvQlBKTlB4TUJmblIyYnhqbzBwcXVhQ011bnozWDl1YnI3UUpWNzhz?=
 =?utf-8?B?Qjh4a1RMMmhMdjYrOFI0WHg2QnBvZWV5cTNCallwdlcrNXdRdE5TNE1GZ2ly?=
 =?utf-8?B?c3hnSXhUUzVLYjIycjloRW84S25xbzcvQmo5QnJDZm9aUzlhNEVHTUpMdWEv?=
 =?utf-8?B?K0VYQlB1bDZvaVpZdVJwM2J2NEk2QnRBNFc1QS9xK01LSnlIazBIcEc4MzB5?=
 =?utf-8?B?TVRkTlEzcUZ2bmVRR0d0U2lWbzZtZlVyK25NY0lKcFVHWi9SQXIrN0ROWVVI?=
 =?utf-8?B?cll3QVhKaFZFa08yeUkrZk5NZnNkaks5aUpBZXFCRzNZbjMvdkg3NmJWYitH?=
 =?utf-8?B?Nm0vWVR4TGMzVVQwamdSWXVlYkRpL2VUZ1hQUlZoL1VrdDZnQ2RqaHlra3VQ?=
 =?utf-8?B?dmNsUmg2Y3NSR2wxQ2lMSTB0clN4NFRTcnhXbmFvZ2xrakxUNFJFbHk2N2FD?=
 =?utf-8?B?dzVISkFGU28vZ0o3c2UwTzh1YUR5elF0dmdqZlhrcTVRWnVxVS9HOGxiTWUv?=
 =?utf-8?B?cGl5N1owYmJlTDBRTlZBRDVoVXZ5NVBNZGwrVS9OUDhlUmpGa0VCcjZDclZ2?=
 =?utf-8?B?S1JtNGR1cVYvQ25YSGxPd0JMWldyZnBhUEtxYzJTOUtETVFUcmFTb3Q3em4w?=
 =?utf-8?B?V3ZjTmhUbnpXNlZRcHhrb2RZNzJqLzIzbXluem9POHorNHhlK3Nwa2xBQ0lw?=
 =?utf-8?B?RjNOZGtwTlpvNzVmWlhJZndmNlJvYmtlUjN3d2JYTkRmdnVwTTA3K3UrOVdt?=
 =?utf-8?B?MWtVVDhTdDQ0RDF1YlE2eG4xNlN5Q2VHNGtrbTJpdHdLeXRrWHA1aE0wWUpQ?=
 =?utf-8?B?OFJTYnBqRUdVMGJGQnc5NXJoK290TElTLzJRZDVLTGZPUERiaU01WWowSmtF?=
 =?utf-8?B?RDNtQ1YvaDZMTm9VSy8veEFBditDYnNiN2RrdWxEYTh1emFqUHNmUTZDaVhi?=
 =?utf-8?B?K1F0WlZ5UnJYTkM0NWpOMERlQ2RhaGdkcmFtT2E3N0MyN2I2bEw2YXVLcjVO?=
 =?utf-8?B?ZTJRTnZ0Tmt3cEorZmpyWXNxTWZMVHk2R0VsMTBKTC9FejhUOGgwS3FrRFFR?=
 =?utf-8?B?QmhmUnJxUkhUdTVqYmd2biswcFpnTTkvc1k3NEI1WVA0Q0IwRkZoU2VSTlhC?=
 =?utf-8?B?a2MwT0I3TzVyMEtoTi83dXVhdHFoRFBGdkJSSnJtODZ0Sk9BSGVITzcvbElJ?=
 =?utf-8?B?R3ZNQjVybERLcDZyYTUwZE8yMFVXMXFxaHdLamJKdmZzZDhXdEpQRERmalpW?=
 =?utf-8?B?MVd4VzFoZHBVU0dKL3Fob0hwWDB1c1VYb015aU9LY2l6UU1RamxYQjZLMzl2?=
 =?utf-8?B?SnVXbWk3ZDFhQm5WVzRVZ2VaTlJneU9XYzhTRzVLT2lOdkNFMVp5RG5OVFMx?=
 =?utf-8?B?RnBKUTJiTFEvalMxZVVzV1d1ZS9WQmRvazNCZTNZcmtYTUJlaFdlK0pkbnV5?=
 =?utf-8?B?QktqL0lmaFl6dGFQYW5JTmk2UjkvVzVSU1gxZFFUQlZtMnFHY0VFS3lBRmhK?=
 =?utf-8?B?azZQTit6ekw4UCtmbVcvdHJXbTBEV0tmczNWUXpCR1dRUVNXMWdYRkY0L1JF?=
 =?utf-8?B?MFFtSnN1TnZra3VrRng4NjE2czIvMTlOSmI2UUppeFluKzNjaFEyNFlxbkRU?=
 =?utf-8?Q?ubFgh5BErgjCzhHPBlxNnCZ5nACux0=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6011.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(7416014)(376014)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bk1rR2ZxNVlpNDNSTEdrNWNlQ1VzT25NN2NRNHlTRUx1Vk1rOXpjUVVwU3gz?=
 =?utf-8?B?TGdIU1dCRTM4dUxSbTMyRGtnNUxlT2FxaVJYZ3FhLzdGYVh5ajZUNVNnelU5?=
 =?utf-8?B?dWc5cFo3aEVDcncrWnlqMHU1OEFRU0xtczZ0bDBEQXdsZUpLZUx5VTFuTXVI?=
 =?utf-8?B?K3FBMDVqQnNTdjVLNnF3eHl1dnhKV1dNMnQ4Mk5FQVU2SmtlZnVtUElNOERq?=
 =?utf-8?B?Z0VCcUtKYkJBeXI0Q2FlSjRJeC9DZW5JZnBUZEV4REptUWVGQXlaZTlHQllP?=
 =?utf-8?B?aGJ0cGNxRngyQTF0Y1NJK1pSdkN6ajMxYzRXZWNVK2ZRSHNDRzFRc21IU1kx?=
 =?utf-8?B?djZuUjRHNE1YN3RPUWp4V1pRRkR2dXNWeEhaRjY0bHEzSC9RVFhkc2R6cU9z?=
 =?utf-8?B?RVB3bEl1SXl6ZGhLdkNwNjhadkNQV3JLRjZOeHUzcHh3MFRsUzVRVGxQNkho?=
 =?utf-8?B?YTVZNUE2T0NoNmhRR0hZYVFQOE43MW1acjBNa1V2VHg2S0VKWFJFV0hkZmR5?=
 =?utf-8?B?UHA4dVVFbEVOSEVoQlJzSVVwOVd6N1dZc0xRTFdETTh2UFpJS3Baa0dYMW9a?=
 =?utf-8?B?d3RvMm0wZVhCT00yUWZxdDBZTE1hTTJYMnM1TVVkN0RhMm9HaytucUlsUDJ0?=
 =?utf-8?B?RWhGV1BLWmg5eTZQT2QxZE5DaGlRaytyem5LYW5Mc3pWZ2FNWkViNDQxK1hT?=
 =?utf-8?B?NFhWdXErS202bE9BNHNndGV1ZlhKNTZKUnRFQkFNZkVDdXo5VU9IYUtYeDZ1?=
 =?utf-8?B?L3htZnhiSERhYkNWYit6V0dQM2pFajJjU3UrZE1ZaWVVbGJsekRzSUpVUndk?=
 =?utf-8?B?cXJyaTAvWG1FU1FiT2FvSHJadU9pYk9NTjdYQ2M5Zy9JZmVBMCs2QWRtTlJY?=
 =?utf-8?B?RjZoem05UkZ6VjJXTFdFeS9NWUdZVFh3cEJXVCttYURrZHhKUjRRUU9Zd1Y2?=
 =?utf-8?B?aUZQejFQK2ZiQmJ4ZzZlaUNtbDFWWUlXQkFJTng3cVJmZG5QYStpU055UDZE?=
 =?utf-8?B?clc0UW1QOUhRSFRxRGJLSk9iQm4yQTEzaFRlenU0ME5PVnZvbm0rdjNkVlpF?=
 =?utf-8?B?a2F6YXJPN0RvWlpxUmp5NWtMcnNERWZ4QWdwMkYvbXhCMC9PbXFDK3VSNzZ0?=
 =?utf-8?B?dnEvWXhWZ0o2U0ZWTlJzVGhZWWRSVjBCM0hEZlY1eVY1M0JRSzlUK0tTY0No?=
 =?utf-8?B?bUFmTmpYeHRFaHFRcGQ2aEd0OFZ5UlFlUUg0d0hrQWVBTi83RlZVbnZVbXRO?=
 =?utf-8?B?eStpQnBweWxBZGdYMUE5dHEzbCtHa3NhRU92NGtLK2RkYmZ0MHV1VUhxb1lp?=
 =?utf-8?B?R1d5TmlUUnIzemRkUGVoUXEwUktHQklkRTJHQkFHSUNMeVJTK2U1aFdVTml3?=
 =?utf-8?B?K0M1bTFXQU5vVFBRQkE5QzNIMkFLMjMwTzVnNmhKYktudDdyWGRuVUNyeGx5?=
 =?utf-8?B?MWZNamJTY3FIcFdHaFhLcTFleURRMVhDalJXOThJYnlNVmkrUndPWFJ5VGlY?=
 =?utf-8?B?MDYyU2tVNUg1UU05M3VVMUdPYWFZZGJ3UEZ0WHRPTXlvQThTUmhwUXhTZnpT?=
 =?utf-8?B?UHhCNEY1aU93b3RWQ1pLT1k4RzM2TUhjd3BsUG5ldStZWE95b1VVVE11aG94?=
 =?utf-8?B?SldEb1JNL2tBZUc5OXFuUU5EaUhGRTFwN1VLZkhPSDFZYTJjK3RqOThPZjN4?=
 =?utf-8?B?K0Fwc2JXaU0wSXhiOFVaS0JJcjZ4T2U3S0pJMGllNnRkMWpYRjhIWVpVdCsw?=
 =?utf-8?B?VWs4UlFrR0tuKzk2R0IxWkdmc3JXL3FsTWxIdlRjZnNYNFh0WGhQWjhDaTJ1?=
 =?utf-8?B?ejVZQWFHODVJNFd0aFRTS3dmajFwdXpFN25RSnRWcmVvQTc3ZDh2bnl3aUJQ?=
 =?utf-8?B?NEhDd0pRTjRGSWV0NndITDdiU1Q2M1JjZEh1c2pPQktqU0J2SVg1d0RjaUk4?=
 =?utf-8?B?NGhjbnhjeG9UdHRqWkY4NEhMSUtGaFVVTmlZZk90Ym1lQWUvTkxteExIdDdI?=
 =?utf-8?B?Qlh5TS9rYkRXU2xlOFRiWVVCL1FmT3hzaTZRYm8wTU50MTYzd1Q4T2REYXNv?=
 =?utf-8?B?ZFdBYkEyU1FTQ2hndXdIZ0RxRk9EM0pLVFJYSHhkODBSQXhtOTYwTk1QbGF1?=
 =?utf-8?B?T0hpTXFXZzhnWEdzWC9tS0I5RTVzN3prSlRUT0RjdDMrYk92b3ppY0hHRStH?=
 =?utf-8?B?Y1E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 497962d2-2022-4c8a-ccfc-08de127e31d1
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6011.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2025 21:50:34.6955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BHHi2rLctKWUDxuitfef9Gw7oOFpLBvFRoLEPmPkqA3vdYRJhOJwgDB9V5iDN/a42R72KageuTN5+XSVxLJEMFG9TxREFLahq72hHFrrGl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4811
X-OriginatorOrg: intel.com



On 10/22/2025 12:41 AM, Michał Winiarski wrote:
> In an upcoming change, the VF GGTT migration data will be handled as
> part of VF control state machine. Add the necessary helpers to allow the
> migration data transfer to/from the HW GGTT resource.
> 
> Signed-off-by: Michał Winiarski <michal.winiarski@intel.com>
> ---
>  drivers/gpu/drm/xe/xe_ggtt.c               | 100 +++++++++++++++++++++
>  drivers/gpu/drm/xe/xe_ggtt.h               |   3 +
>  drivers/gpu/drm/xe/xe_ggtt_types.h         |   2 +
>  drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c |  44 +++++++++
>  drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h |   5 ++
>  5 files changed, 154 insertions(+)
> 
> diff --git a/drivers/gpu/drm/xe/xe_ggtt.c b/drivers/gpu/drm/xe/xe_ggtt.c
> index 40680f0c49a17..99fe891c7939e 100644
> --- a/drivers/gpu/drm/xe/xe_ggtt.c
> +++ b/drivers/gpu/drm/xe/xe_ggtt.c
> @@ -151,6 +151,14 @@ static void xe_ggtt_set_pte_and_flush(struct xe_ggtt *ggtt, u64 addr, u64 pte)
>  	ggtt_update_access_counter(ggtt);
>  }
>  
> +static u64 xe_ggtt_get_pte(struct xe_ggtt *ggtt, u64 addr)
> +{
> +	xe_tile_assert(ggtt->tile, !(addr & XE_PTE_MASK));
> +	xe_tile_assert(ggtt->tile, addr < ggtt->size);
> +
> +	return readq(&ggtt->gsm[addr >> XE_PTE_SHIFT]);
> +}
> +
>  static void xe_ggtt_clear(struct xe_ggtt *ggtt, u64 start, u64 size)
>  {
>  	u16 pat_index = tile_to_xe(ggtt->tile)->pat.idx[XE_CACHE_WB];
> @@ -233,16 +241,19 @@ void xe_ggtt_might_lock(struct xe_ggtt *ggtt)
>  static const struct xe_ggtt_pt_ops xelp_pt_ops = {
>  	.pte_encode_flags = xelp_ggtt_pte_flags,
>  	.ggtt_set_pte = xe_ggtt_set_pte,
> +	.ggtt_get_pte = xe_ggtt_get_pte,
>  };
>  
>  static const struct xe_ggtt_pt_ops xelpg_pt_ops = {
>  	.pte_encode_flags = xelpg_ggtt_pte_flags,
>  	.ggtt_set_pte = xe_ggtt_set_pte,
> +	.ggtt_get_pte = xe_ggtt_get_pte,
>  };
>  
>  static const struct xe_ggtt_pt_ops xelpg_pt_wa_ops = {
>  	.pte_encode_flags = xelpg_ggtt_pte_flags,
>  	.ggtt_set_pte = xe_ggtt_set_pte_and_flush,
> +	.ggtt_get_pte = xe_ggtt_get_pte,
>  };
>  
>  static void __xe_ggtt_init_early(struct xe_ggtt *ggtt, u32 reserved)
> @@ -912,6 +923,22 @@ static void xe_ggtt_assign_locked(struct xe_ggtt *ggtt, const struct drm_mm_node
>  	xe_ggtt_invalidate(ggtt);
>  }
>  
> +/**
> + * xe_ggtt_pte_size() - Convert GGTT VMA size to page table entries size.
> + * @ggtt: the &xe_ggtt
> + * @size: GGTT VMA size in bytes
> + *
> + * Return: GGTT page table entries size in bytes.
> + */
> +size_t xe_ggtt_pte_size(struct xe_ggtt *ggtt, size_t size)

passing ggtt just for assert seems overkill

> +{
> +	struct xe_device __maybe_unused *xe = tile_to_xe(ggtt->tile);

we try to avoid __maybe_unused 

if you need xe/tile/gt just in the assert, then put to_xe/tile/gt inside it

> +
> +	xe_assert(xe, size % XE_PAGE_SIZE == 0);
> +
> +	return size / XE_PAGE_SIZE * sizeof(u64);
> +}
> +
>  /**
>   * xe_ggtt_assign - assign a GGTT region to the VF
>   * @node: the &xe_ggtt_node to update
> @@ -927,6 +954,79 @@ void xe_ggtt_assign(const struct xe_ggtt_node *node, u16 vfid)
>  	xe_ggtt_assign_locked(node->ggtt, &node->base, vfid);
>  	mutex_unlock(&node->ggtt->lock);
>  }
> +
> +/**
> + * xe_ggtt_node_save() - Save a &xe_ggtt_node to a buffer.
> + * @node: the &xe_ggtt_node to be saved
> + * @dst: destination buffer
> + * @size: destination buffer size in bytes
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
> +int xe_ggtt_node_save(struct xe_ggtt_node *node, void *dst, size_t size)
> +{
> +	struct xe_ggtt *ggtt;
> +	u64 start, end;
> +	u64 *buf = dst;
> +
> +	if (!node)
> +		return -ENOENT;
> +
> +	guard(mutex)(&node->ggtt->lock);
> +
> +	ggtt = node->ggtt;
> +	start = node->base.start;
> +	end = start + node->base.size - 1;
> +
> +	if (xe_ggtt_pte_size(ggtt, node->base.size) > size)
> +		return -EINVAL;
> +
> +	while (start < end) {
> +		*buf++ = ggtt->pt_ops->ggtt_get_pte(ggtt, start) & ~GGTT_PTE_VFID;

up to this point function is generic, non-IOV, so maybe leave PTEs as-is and do not sanitize VFID ?

or, similar to node_load(), also pass vfid to enforce additional checks ?

	pte = ggtt->pt_ops->ggtt_get_pte(ggtt, start);
	if (vfid != u64_get_bits(pte, GGTT_PTE_VFID))
		return -EPERM;

then optionally sanitize using:

	*buf++ = u64_replace_bits(pte, 0, GGTT_PTE_VFID);



> +		start += XE_PAGE_SIZE;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * xe_ggtt_node_load() - Load a &xe_ggtt_node from a buffer.
> + * @node: the &xe_ggtt_node to be loaded
> + * @src: source buffer
> + * @size: source buffer size in bytes
> + * @vfid: VF identifier
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
> +int xe_ggtt_node_load(struct xe_ggtt_node *node, const void *src, size_t size, u16 vfid)
> +{
> +	u64 vfid_pte = xe_encode_vfid_pte(vfid);
> +	const u64 *buf = src;
> +	struct xe_ggtt *ggtt;
> +	u64 start, end;
> +
> +	if (!node)
> +		return -ENOENT;
> +
> +	guard(mutex)(&node->ggtt->lock);
> +
> +	ggtt = node->ggtt;
> +	start = node->base.start;
> +	end = start + size - 1;
> +
> +	if (xe_ggtt_pte_size(ggtt, node->base.size) != size)
> +		return -EINVAL;
> +
> +	while (start < end) {
> +		ggtt->pt_ops->ggtt_set_pte(ggtt, start, (*buf & ~GGTT_PTE_VFID) | vfid_pte);

		pte = u64_replace_bits(*buf++, vfid, GGTT_PTE_VFID));
		ggtt_set_pte(ggtt, start, pte);

> +		start += XE_PAGE_SIZE;
> +		buf++;
> +	}
> +	xe_ggtt_invalidate(ggtt);
> +
> +	return 0;
> +}
> +
>  #endif
>  
>  /**
> diff --git a/drivers/gpu/drm/xe/xe_ggtt.h b/drivers/gpu/drm/xe/xe_ggtt.h
> index 75fc7a1efea76..5f55f80fe3adc 100644
> --- a/drivers/gpu/drm/xe/xe_ggtt.h
> +++ b/drivers/gpu/drm/xe/xe_ggtt.h
> @@ -42,7 +42,10 @@ int xe_ggtt_dump(struct xe_ggtt *ggtt, struct drm_printer *p);
>  u64 xe_ggtt_print_holes(struct xe_ggtt *ggtt, u64 alignment, struct drm_printer *p);
>  
>  #ifdef CONFIG_PCI_IOV
> +size_t xe_ggtt_pte_size(struct xe_ggtt *ggtt, size_t size);

this could be generic (non PCI-IOV only) inline helper or macro here or in .c

	size_t to_xe_ggtt_pt_size(size_t size);

and then more elegant solution would be to expose

	size_t xe_ggtt_node_pt_size(const struct xe_ggtt_node *node);

and yes, that would require to additionally expose something from gt_sriov_pf_config
as migration code doesn't have access to this node,

but maybe xe_gt_sriov_pf_config_ggtt_save() can be updated to also support 'query' mode?

	size_t xe_gt_sriov_pf_config_ggtt_save(gt, vfid, buf, size) -> bytes saved
	size_t xe_gt_sriov_pf_config_ggtt_save(gt, vfid, NULL, 0) -> size to be saved


>  void xe_ggtt_assign(const struct xe_ggtt_node *node, u16 vfid);
> +int xe_ggtt_node_save(struct xe_ggtt_node *node, void *dst, size_t size);
> +int xe_ggtt_node_load(struct xe_ggtt_node *node, const void *src, size_t size, u16 vfid);
>  #endif
>  
>  #ifndef CONFIG_LOCKDEP
> diff --git a/drivers/gpu/drm/xe/xe_ggtt_types.h b/drivers/gpu/drm/xe/xe_ggtt_types.h
> index c5e999d58ff2a..dacd796f81844 100644
> --- a/drivers/gpu/drm/xe/xe_ggtt_types.h
> +++ b/drivers/gpu/drm/xe/xe_ggtt_types.h
> @@ -78,6 +78,8 @@ struct xe_ggtt_pt_ops {
>  	u64 (*pte_encode_flags)(struct xe_bo *bo, u16 pat_index);
>  	/** @ggtt_set_pte: Directly write into GGTT's PTE */
>  	void (*ggtt_set_pte)(struct xe_ggtt *ggtt, u64 addr, u64 pte);
> +	/** @ggtt_get_pte: Directly read from GGTT's PTE */
> +	u64 (*ggtt_get_pte)(struct xe_ggtt *ggtt, u64 addr);
>  };
>  
>  #endif
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
> index c0c0215c07036..c857879e28fe5 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.c
> @@ -726,6 +726,50 @@ int xe_gt_sriov_pf_config_set_fair_ggtt(struct xe_gt *gt, unsigned int vfid,
>  	return xe_gt_sriov_pf_config_bulk_set_ggtt(gt, vfid, num_vfs, fair);
>  }
>  
> +/**
> + * xe_gt_sriov_pf_config_ggtt_save() - Save a VF provisioned GGTT data into a buffer.
> + * @gt: the &xe_gt
> + * @vfid: VF identifier (can't be 0)
> + * @buf: the GGTT data destination buffer
> + * @size: the size of the buffer
> + *
> + * This function can only be called on PF.
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
> +int xe_gt_sriov_pf_config_ggtt_save(struct xe_gt *gt, unsigned int vfid,
> +				    void *buf, size_t size)
> +{
> +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> +	xe_gt_assert(gt, vfid);
> +
> +	guard(mutex)(xe_gt_sriov_pf_master_mutex(gt));
> +
> +	return xe_ggtt_node_save(pf_pick_vf_config(gt, vfid)->ggtt_region, buf, size);
> +}
> +
> +/**
> + * xe_gt_sriov_pf_config_ggtt_restore() - Restore a VF provisioned GGTT data from a buffer.
> + * @gt: the &xe_gt
> + * @vfid: VF identifier (can't be 0)
> + * @buf: the GGTT data source buffer
> + * @size: the size of the buffer
> + *
> + * This function can only be called on PF.
> + *
> + * Return: 0 on success or a negative error code on failure.
> + */
> +int xe_gt_sriov_pf_config_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
> +				       const void *buf, size_t size)
> +{
> +	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
> +	xe_gt_assert(gt, vfid);
> +
> +	guard(mutex)(xe_gt_sriov_pf_master_mutex(gt));
> +
> +	return xe_ggtt_node_load(pf_pick_vf_config(gt, vfid)->ggtt_region, buf, size, vfid);
> +}
> +
>  static u32 pf_get_min_spare_ctxs(struct xe_gt *gt)
>  {
>  	/* XXX: preliminary */
> diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
> index 513e6512a575b..6916b8f58ebf2 100644
> --- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
> +++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_config.h
> @@ -61,6 +61,11 @@ ssize_t xe_gt_sriov_pf_config_save(struct xe_gt *gt, unsigned int vfid, void *bu
>  int xe_gt_sriov_pf_config_restore(struct xe_gt *gt, unsigned int vfid,
>  				  const void *buf, size_t size);
>  
> +int xe_gt_sriov_pf_config_ggtt_save(struct xe_gt *gt, unsigned int vfid,
> +				    void *buf, size_t size);
> +int xe_gt_sriov_pf_config_ggtt_restore(struct xe_gt *gt, unsigned int vfid,
> +				       const void *buf, size_t size);
> +
>  bool xe_gt_sriov_pf_config_is_empty(struct xe_gt *gt, unsigned int vfid);
>  
>  int xe_gt_sriov_pf_config_init(struct xe_gt *gt);


