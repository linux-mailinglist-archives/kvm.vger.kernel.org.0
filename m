Return-Path: <kvm+bounces-30620-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF3779BC4B1
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 06:28:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A563282FDB
	for <lists+kvm@lfdr.de>; Tue,  5 Nov 2024 05:28:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 164781B85F0;
	Tue,  5 Nov 2024 05:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aUpDZUwv"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D121B0F34
	for <kvm@vger.kernel.org>; Tue,  5 Nov 2024 05:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730784527; cv=fail; b=EIFbJjzZyC/UAB17cC9N2PdoKaxEuAnwRwRGDphN9E8fLz/K54cOirxaLJOv0MxwCltc0QaIK8+PVaSMtM8hwm9Xymj/7hMfmdMlTT2WO8B5Kv5tak02KX9BxjEubCmgmf1wB309Lcd5CVl4tzUlJsVRvuK5pLXSEkwh3DbHdAo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730784527; c=relaxed/simple;
	bh=C1fTamAXPalnkQZ3yBpeEYTzeshAXMdN5AI4MOAzpOI=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=F5Ennu1F3e6AQg+iIsJ6KTsaKNJfnUBzmy1cc5/yeX5ddbAf+WkllHdDl2qYkW/ODr7YAQZ79pxo+/tIz2f8D7PDw5iqOOy0Hs7EiQKvVpQvuNa0ZsN27SoQMSZwZbcsS4a4Kgfrzw7pggC9Emh5/0Y/odhjx2mazhK+t72blxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aUpDZUwv; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730784525; x=1762320525;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C1fTamAXPalnkQZ3yBpeEYTzeshAXMdN5AI4MOAzpOI=;
  b=aUpDZUwvyVTMVKM56xdD22AYl0YcF7YOpqCzpOhvbX1pDkVr5/5jqc+N
   mVQhaCe9gMqLMKFQT08do2zVmfXaHNphUif2WXrjGdnCKH/t5bvTH/33V
   wlqM69ii6bhiUpotUs/ClRkVSPFSEpETm004GDHvcqbdH9VTQVG5tiYcz
   +DqEUdgjvdck2y69AtYVLcYcqMI2eyVFE0ueXXo1UAGtU06GnPmzYugZ4
   Xx/CELSeqtuj5SZbUcWJs4AfQhRQAZNStEncI1cMK2YEjAMHYhG60NX3j
   4jSXka737kvHScx/3pXd91P2Kaouht8XXpylgnd7DqRo7P/ndSi5Q68nG
   w==;
X-CSE-ConnectionGUID: EEf+fV9LQkyhBRf8u1Y/Wg==
X-CSE-MsgGUID: lwgqJH5HSZ+ePl+/aJXyAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11246"; a="41141510"
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="41141510"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Nov 2024 21:28:41 -0800
X-CSE-ConnectionGUID: Dm2hky3fTuWUbHBSrdDL3Q==
X-CSE-MsgGUID: ABe0+bIUREeEwkJLNzFPkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,259,1725346800"; 
   d="scan'208";a="84694099"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 04 Nov 2024 21:28:41 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 4 Nov 2024 21:28:40 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 4 Nov 2024 21:28:40 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 4 Nov 2024 21:28:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=PDAMlrYCzj5JmvRZpK9H56n/eacOq8G+xo+8mCQzh24ig23ecAnHr84TN1aOYckwIfaauOilBhcCnDgll8/KOHfVQ6+15xnl67c3qi75wfhb4i5pigi378RDck1NE66fAQ4YSJP7nwjkbCZQKafydaiWQ2y3l9YjzfUT9sI6k+vXKAsDtLk7CkUO+unzz8vF5d10Rx/Bs4+F9zStPsP/csCJWs0xQvGE45Rr5kDpjasFgRq4Yax78jTGTEZPCWQUsfNUg2rL08D2i64LIbvqckVC6hPwc9ADx0LRXKfj843MTjOCwmj2IqH2jxtPOFRfRyhaM/XJTudKKSjlIv9wmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=frD4Kot/ffSt99Hh3o2aN0ADZQOe/immTqudp1jF/uQ=;
 b=Qh2AmyfuRVFnaN7GT5fLTbwYhqMQRE3uD+la1z8/Cn55lLucy66DcqpY7Fb1T2+MirvdpIRDD4cM8ezHBNx0OKaciMtHU4O4kyTqkzk9sYMhY+7x+1vbnOLMbW5kB1IdPjpqRGCaRuE05bePsZswGUNPnUHJqg0pHNIVFuf7Az063ovT10tx7e2PpbDNSBuYuhoyhY6hLQu8rjcHMz8sjXqyd6HL8J1CiiPAx13NKQe0PDkn5Rr+lUIMfBDQZZmWXXPpIFNM69PSQFQ1NVc7nocJiWv7TLrWKpJ7XQTkpyKicVl6zx1MRan9s1nQ6RRqF101DG7dU3GNI098SDkVOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS0PR11MB7529.namprd11.prod.outlook.com (2603:10b6:8:141::20)
 by CH3PR11MB8364.namprd11.prod.outlook.com (2603:10b6:610:174::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8114.30; Tue, 5 Nov
 2024 05:28:37 +0000
Received: from DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a]) by DS0PR11MB7529.namprd11.prod.outlook.com
 ([fe80::d244:15cd:1060:941a%6]) with mapi id 15.20.8114.028; Tue, 5 Nov 2024
 05:28:37 +0000
Message-ID: <8178f46a-76ed-4945-a8c4-576c4ac6bc53@intel.com>
Date: Tue, 5 Nov 2024 13:33:13 +0800
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/13] iommu/vt-d: Add set_dev_pasid callback for
 nested domain
To: Baolu Lu <baolu.lu@linux.intel.com>, <joro@8bytes.org>, <jgg@nvidia.com>,
	<kevin.tian@intel.com>
CC: <alex.williamson@redhat.com>, <eric.auger@redhat.com>,
	<nicolinc@nvidia.com>, <kvm@vger.kernel.org>, <chao.p.peng@linux.intel.com>,
	<iommu@lists.linux.dev>, <zhenzhong.duan@intel.com>, <vasant.hegde@amd.com>,
	<will@kernel.org>
References: <20241104131842.13303-1-yi.l.liu@intel.com>
 <20241104131842.13303-12-yi.l.liu@intel.com>
 <1076c17a-b053-4332-8684-926842126b36@linux.intel.com>
Content-Language: en-US
From: Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <1076c17a-b053-4332-8684-926842126b36@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR02CA0045.apcprd02.prod.outlook.com
 (2603:1096:4:196::21) To DS0PR11MB7529.namprd11.prod.outlook.com
 (2603:10b6:8:141::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR11MB7529:EE_|CH3PR11MB8364:EE_
X-MS-Office365-Filtering-Correlation-Id: 3218c490-ef12-4195-444a-08dcfd5ab2ee
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?TE44MFB5RXltNWZQWGw5dnF3cWV4amlobU8vb0E0eDBXV3ZkdEJ5NUFQRFIz?=
 =?utf-8?B?WjdWeTZPY3pFT1JER2lDK0lJZVJZZ2Q3cTVrUHJJSGlOcWdIRjBTdWpMYys2?=
 =?utf-8?B?Rk11NWZzTllUaklTTVNwTnBTUGZRcVhvVFBzRzd1Rk10Rm44ZGRtZFJJbHh2?=
 =?utf-8?B?VlJMc25NL2N4Z20rMzBjVzdQRFJjNDN3VVJTZy9JbHNFek03eGlSUElZa2hQ?=
 =?utf-8?B?c1hmUUdjTW0vQkZxbUF1NFRWR3BLczhGTHozbGJWc0JsQzJlREgyQ1UyU3Vz?=
 =?utf-8?B?NlB0ZFBoSkkzS3orZnAreUVRTEFjRkVSV3FXTENzUmViUmNtUGptWm1KZHdt?=
 =?utf-8?B?Q0xNaEI2K2pLRDc0UUxuTmp4T1JQUTNKK2xlNTVOWTVFeWY4cFAxc09ldHc1?=
 =?utf-8?B?NjVwdzF1aTEyS0NnQm9FSXJtMWFUaFU1MGV4eVFyRFhGTlBZRUhUclZRRjdD?=
 =?utf-8?B?V2dEcndXT2pra05EN0xFWW9oTXM0SFloaTdlUWNGZWwreVFKSmFFRUpCZUpE?=
 =?utf-8?B?UmJFZHBxaUFtZ3BlOU5xK0FWa1drampmMUo3Smx5Wlh1bGdkNjVzN05IQmM0?=
 =?utf-8?B?UU9NbU05YnRja1dkamZ5bDI4QU5wbWRMRTNtR0VHUnJBRFNhS21ocmx5K2V2?=
 =?utf-8?B?M0czSHVCYTRlbTV0Wk1hL3owZjlQbHpiQlR5Y0UvYkYvNG53c3N4NDFhRnN1?=
 =?utf-8?B?VTl5NGNlb2lNZXl5dzZsdnlUeEhaVVJlYTV3STFEV1ZBc2tJNHJJSis2SVo4?=
 =?utf-8?B?ekp4S1l3eWxralZiY21ONmNYeXoxYWd2VnVuaVJwcXQ1UDA4ZTNvTEo1SUNU?=
 =?utf-8?B?MGFFUnNubVJ3RnBjZ1ZlakdaNDBHanNhTlNOaW9zZlRvZmRBUGIyZkM4ZjJa?=
 =?utf-8?B?c0RMekNRNUwzYXNIU0thQTJyQWEvQUdXeEZRR0M4MFZlU205eU5oYjRYNDI1?=
 =?utf-8?B?VVlZRVBGUUdBeEwvS1Z4S3hKOHpZRS9zQlVsTVh5Z0tFNlE1SzRNNlo0NGFy?=
 =?utf-8?B?NGg1WTVBOFFZRWN6cWRCM3lRY0RQd2lnWTBYeFl0ZjEzZHN3Tk9OeUp1bng3?=
 =?utf-8?B?M1VQZEpEY3lpaGpFckxIczNLak83dU56TEN3aHZidGhCTzJzSUxOYUNXTHN6?=
 =?utf-8?B?eDdBZ3dpOTZab2JFd2JVaGxEREhLRFI2Z0xyejBPYytmTlJsdy9kUFc2Uk90?=
 =?utf-8?B?OUQ1dU9Jek1YOGtmeEgwT3cxd1FQVXlZeFBBQVdxcFFheWdaY1Vib3FBNDho?=
 =?utf-8?B?Wi9nWXVLV0JiZkF6SFlaa0RXZXhvbEI2RFFaL1NkNGJMYWNNbDhkV3FDREVV?=
 =?utf-8?B?eTBxQUJxZlJFeHpOeXpzSzFOVWpJRTFJWlM5SHBWd0Zxa1JyU0s4NzBSQk1M?=
 =?utf-8?B?NldUUmhHdGhERkNsOEFwbjBqMjVSU2dLUmlpVmJlb1ppYXZUKzdlVERQalBt?=
 =?utf-8?B?MHdPUDlzbDltaEZvNllaSXR2cmFLUWQ2VVp0d2NrbGN4Zm5GN3BnZnRuWVVo?=
 =?utf-8?B?ckVyTUxVRUl1S0hwaUxEcGdUalJTU2d2bVVzcURnbUpSaG5oUTdCamYyTGVJ?=
 =?utf-8?B?QzNGT2RTaEkvMnFjVDE2aWQ0dTNQQU10aWRFRi9rY0ZZaGptM1d0bFVqREJj?=
 =?utf-8?B?T2tZSFozTFRkbkFqTXdVamlZVCtYS3hXU0tyVkF5N3hkQTVnajU5bmVhSG80?=
 =?utf-8?B?ZmZLQk1wb2dRSEJ0K3pGT2U2aDBsMXFNWWV0RG1jZlIyS2ZBV011Wm5SL09M?=
 =?utf-8?Q?cpWycMmGucu0oMNr2U=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB7529.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3htV0xpaGRHT3gxOTdUTnRiV1hNQmJGb0V3LzJYZjlPbWl5b3lEbkl0T21H?=
 =?utf-8?B?YzNQS0pDOGZzdi9VUDl1NVEvdWlyVW15ZFFzcExJbWlONERHbmdJcU92bkdk?=
 =?utf-8?B?WFBnYnN6RGxvQ0ZML3JFeDZuRzZqU2U2VDZFaGN4QnNEVHZXaE1TYlFBbXJZ?=
 =?utf-8?B?ZU1CMUhhZ0p5TUJuVFdwczFsNkR6dGN0aW1iNGs1QnpLQnU0eUp0RjA0ZERu?=
 =?utf-8?B?cC9GUFh3c3VRM1NSNnhmdjNKRWc0aU15UThpUlVwRFB1UlFFYlMwMnE5UUpn?=
 =?utf-8?B?Z2dYR1lqM0JmWERYT3Bkamp3bW5oTlA1SU9JT1JtWWFSVDdkM0Z4OEgxbzMz?=
 =?utf-8?B?V0VwTHhyS25jNWtaTnlkZlpGd2U1ejRCelNsQy9QZDR3cVJlRW44QnhSWUdB?=
 =?utf-8?B?T3dhS2pqcXVqMTdVOVM2ZDE2TldQK2kwT2pBSWxMdS9yRjNVVU5xci9UTWxO?=
 =?utf-8?B?R0I4Z3lHeEFJeDdYZUppenpoUjJPdi90ZS9kaEF0T3ZJNFE0Z0dZRGdpMVVH?=
 =?utf-8?B?Vll2aFRib1JTZkZqZnZtdEMvblJiK1ZrQldwVGdEL2R4MExSMFMyOFZuS3BE?=
 =?utf-8?B?TW03ZkJGekFwcWpoMkpwS3dJT3F4YjJRM0FPb2dZdEtzZVY4R2FQeEVnWW80?=
 =?utf-8?B?Ym41VjhYQytnaU45bDhyckpXNXFyY1IrV25kVXJTVE9lK1ZTZ2RpNGIvd3lm?=
 =?utf-8?B?NHJXNnpvamcyMUwyOTBlYWk5SGxPNGNzZWxZczNLNjVMSkFDUHhlNW1nZ25j?=
 =?utf-8?B?dVRtMFd6WURnYmFpNWJKZlJ5Zld0cWl3c2F2Q0JtUXZPSks0WkFxWWZ3QlYv?=
 =?utf-8?B?K2tRWUMrVCtDeWU4WkNEUlRBNWsrdkUzc1NPTnZiWUxYQnBZU3FvN2traDJC?=
 =?utf-8?B?M0J2ZFd1Q2FyMWhjbDNoSkxhekxIQnBVSXAzS2ltdWhieEIyRTU0T0tGK1lC?=
 =?utf-8?B?RFo4R1Q1elkrYlcvVUtNeVFHcHN6a0FramVocUx2azE0dm80eFZMNFJ5MzZx?=
 =?utf-8?B?ZlN5eGZIeUc4THBWd3RpQmxPN0RyYUpwUERqckREY2FsdkR3UzBmRy9yb0tL?=
 =?utf-8?B?YlpDMmxGL1BkdlZsa3MvaGpSZHp3ZzlCWTdiODljM0ZNU2pXN0d2Rzgyb3BQ?=
 =?utf-8?B?MWNPVi81NVc4UFQvVjJhYTV2ZDZMNGlyWTBzbTNvbVUyRjNjdWxwZGxmQ2NV?=
 =?utf-8?B?OENRQlVycDdsbWpTbmUvSHdlMnVwTTUyNVhRdzExZ0VONjN5SDcxV2JFQTYy?=
 =?utf-8?B?bENVRFVSOEt5S2Z6bGNZK1BJdzlOdWd2L1p0Ny85OW9YNFc5TEtaU1lGU1Ny?=
 =?utf-8?B?TTZSTE1Cd0d4elFMVDdMT0NndzJjRHNlMTQ0ckdJNEtVajd6eTdCVzA1S1pk?=
 =?utf-8?B?dytoSWU4M1RJeVNHYW9hWUxMMnVZV2dQYlV5blFwRmt3QVJVUjNTLzlZUVlR?=
 =?utf-8?B?eFZFVHQvTnNJQmZidGFnRlRlZkFSc1VTOXJFWTYrcHNodWk4a2s3eUVPQk1H?=
 =?utf-8?B?YnFhUmVMTlZKcDV4MzJHNDhUQkNNYVQ5V3dIVk1PbkY5ejhJaUVwZE1OQUdY?=
 =?utf-8?B?MTRURFJEQ1hhdllYRUc1M2hRQVNJQmhRaExZT3FJYjhJUm1vL1IvSUtIaDlY?=
 =?utf-8?B?aUQ0VjQzQVJwejJQeWhTck9rVEhuWGhFM3djUE5NalVsUWxwOG9RejI4R3NW?=
 =?utf-8?B?RzBMaDdXZjhDcU9ZOHk1aHkvdWR6TitjQXIrRFBDNjJnRlVIM0t2aGttVm9Q?=
 =?utf-8?B?eDR3Y0N5R3RVd2NEQm1kZ0VRVDVrRE9qZGlxQzFsM21pWDFUMTIwdDFPYzFE?=
 =?utf-8?B?TElNeVd5UlNxMGcxOU0xdHRpZDdSNndSTHZHcEF5anI2dGFKOWMrZEhnQ3JD?=
 =?utf-8?B?Y0oxMWd4UmlBMWVjbXdIWFNERUdmVDI0Y043K3k4bDdEazVGWGYrbjFGa240?=
 =?utf-8?B?UDVjLzU0RkxRMlpSU3JuRmp4RzNXMW83bEloZ09QYmpwYmlQUXM1T2orN1cv?=
 =?utf-8?B?MmxOWUVPYkZTWmJUbGpuVVZNRHNEY1pMa2lpQVpNdm1BU0ZMMEI0OUFBSG1w?=
 =?utf-8?B?V0dvaWRyR3ZFVm0wL0JKUUY2QkhSNGhpcVpzMFgyeURBaDg1VVgzMFo3QXdi?=
 =?utf-8?Q?QrvQ/1Z81mxoRDnlrgcALNSsp?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 3218c490-ef12-4195-444a-08dcfd5ab2ee
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB7529.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2024 05:28:37.3592
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QZQEwlA5ngP9r6UEnMlnUv0BSOUG3HDFq4kvJ9ycP/zv+V4aCSbJXsG1U24GW5F6F4tPxGCKiZH7igotC7NfPg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB8364
X-OriginatorOrg: intel.com

On 2024/11/5 11:38, Baolu Lu wrote:
> On 11/4/24 21:18, Yi Liu wrote:
>> From: Lu Baolu <baolu.lu@linux.intel.com>
>>
>> Add intel_nested_set_dev_pasid() to set a nested type domain to a PASID
>> of a device.
>>
> 
> Co-developed-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
>> Co-developed-by: Yi Liu <yi.l.liu@intel.com>
>> Signed-off-by: Yi Liu <yi.l.liu@intel.com>
> 
> And convert the patch author to you.

ok.

> 
>> ---
>>   drivers/iommu/intel/iommu.c  |  2 +-
>>   drivers/iommu/intel/iommu.h  |  7 ++++++
>>   drivers/iommu/intel/nested.c | 43 ++++++++++++++++++++++++++++++++++++
>>   drivers/iommu/intel/pasid.h  | 11 +++++++++
>>   4 files changed, 62 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
>> index 7e82b3a4bba7..7f1ca3c342a3 100644
>> --- a/drivers/iommu/intel/iommu.c
>> +++ b/drivers/iommu/intel/iommu.c
>> @@ -1944,7 +1944,7 @@ static int domain_setup_first_level(struct 
>> intel_iommu *iommu,
>>                            flags);
>>   }
>> -static bool dev_is_real_dma_subdevice(struct device *dev)
>> +bool dev_is_real_dma_subdevice(struct device *dev)
> 
> How about making this a static inline in the header?

got it.

> 
>>   {
>>       return dev && dev_is_pci(dev) &&
>>              pci_real_dma_dev(to_pci_dev(dev)) != to_pci_dev(dev);
>> diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
>> index 8e7ffb421ac4..55478d7b64cf 100644
>> --- a/drivers/iommu/intel/iommu.h
>> +++ b/drivers/iommu/intel/iommu.h
>> @@ -818,6 +818,11 @@ domain_id_iommu(struct dmar_domain *domain, struct 
>> intel_iommu *iommu)
>>       return info->did;
>>   }
>> +static inline int domain_type_is_nested(struct dmar_domain *domain)
>> +{
>> +    return domain->domain.type == IOMMU_DOMAIN_NESTED;
>> +}
> 
> Why do you need this?

sigh, it should be dropped as we non longer share set_dev_pasid callback
with paging domain.

>> +
>>   /*
>>    * 0: readable
>>    * 1: writable
>> @@ -1225,6 +1230,8 @@ void __iommu_flush_iotlb(struct intel_iommu *iommu, 
>> u16 did, u64 addr,
>>    */
>>   #define QI_OPT_WAIT_DRAIN        BIT(0)
>> +bool dev_is_real_dma_subdevice(struct device *dev);
>> +
>>   int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu 
>> *iommu);
>>   void domain_detach_iommu(struct dmar_domain *domain, struct intel_iommu 
>> *iommu);
>>   void device_block_translation(struct device *dev);
>> diff --git a/drivers/iommu/intel/nested.c b/drivers/iommu/intel/nested.c
>> index 3ce3c4fd210e..890087f3509f 100644
>> --- a/drivers/iommu/intel/nested.c
>> +++ b/drivers/iommu/intel/nested.c
>> @@ -130,8 +130,51 @@ static int intel_nested_cache_invalidate_user(struct 
>> iommu_domain *domain,
>>       return ret;
>>   }
>> +static int intel_nested_set_dev_pasid(struct iommu_domain *domain,
>> +                      struct device *dev, ioasid_t pasid,
>> +                      struct iommu_domain *old)
>> +{
>> +    struct device_domain_info *info = dev_iommu_priv_get(dev);
>> +    struct dmar_domain *dmar_domain = to_dmar_domain(domain);
>> +    struct intel_iommu *iommu = info->iommu;
>> +    struct dev_pasid_info *dev_pasid;
>> +    int ret;
>> +
>> +    /* No SVA domain replacement usage so far */
>> +    if (old && old->type == IOMMU_DOMAIN_SVA)
>> +        return -EOPNOTSUPP;
> 
> No need for this check from driver's point of view. If there is really a
> need, it should go to the iommu core.

I'm going to drop it per the discussion in patch 10.

> 
>> +
>> +    if (!pasid_supported(iommu) || dev_is_real_dma_subdevice(dev))
>  > +        return -EOPNOTSUPP;> +
>> +    if (context_copied(iommu, info->bus, info->devfn))
>> +        return -EBUSY;
>> +
>> +    ret = prepare_domain_attach_device(&dmar_domain->s2_domain->domain,
>> +                       dev);
>> +    if (ret)
>> +        return ret;
>> +
>> +    dev_pasid = domain_add_dev_pasid(domain, dev, pasid);
>> +    if (IS_ERR(dev_pasid))
>> +        return PTR_ERR(dev_pasid);
>> +
>> +    ret = domain_setup_nested(iommu, dmar_domain, dev, pasid, old);
>> +    if (ret)
>> +        goto out_remove_dev_pasid;
>> +
>> +    domain_remove_dev_pasid(old, dev, pasid);
>> +
>> +    return 0;
>> +
>> +out_remove_dev_pasid:
>> +    domain_remove_dev_pasid(domain, dev, pasid);
>> +    return ret;
>> +}
>> +
>>   static const struct iommu_domain_ops intel_nested_domain_ops = {
>>       .attach_dev        = intel_nested_attach_dev,
>> +    .set_dev_pasid        = intel_nested_set_dev_pasid,
>>       .free            = intel_nested_domain_free,
>>       .cache_invalidate_user    = intel_nested_cache_invalidate_user,
>>   };
>> diff --git a/drivers/iommu/intel/pasid.h b/drivers/iommu/intel/pasid.h
>> index a3b5945a1812..31a4e7c01853 100644
>> --- a/drivers/iommu/intel/pasid.h
>> +++ b/drivers/iommu/intel/pasid.h
>> @@ -335,6 +335,17 @@ static inline int domain_setup_passthrough(struct 
>> intel_iommu *iommu,
>>       return intel_pasid_setup_pass_through(iommu, dev, pasid);
>>   }
>> +static inline int domain_setup_nested(struct intel_iommu *iommu,
>> +                      struct dmar_domain *domain,
>> +                      struct device *dev, ioasid_t pasid,
>> +                      struct iommu_domain *old)
>> +{
>> +    if (old)
>> +        return intel_pasid_replace_nested(iommu, dev,
>> +                          pasid, domain);
>> +    return intel_pasid_setup_nested(iommu, dev, pasid, domain);
>> +}
>> +
>>   void intel_pasid_tear_down_entry(struct intel_iommu *iommu,
>>                    struct device *dev, u32 pasid,
>>                    bool fault_ignore);
> 
> Others look good to me.
> 
> -- 
> baolu

-- 
Regards,
Yi Liu

