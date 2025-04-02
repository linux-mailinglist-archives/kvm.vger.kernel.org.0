Return-Path: <kvm+bounces-42431-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAE75A7864B
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 03:56:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66DC67A31A1
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 01:55:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8ECE438FAD;
	Wed,  2 Apr 2025 01:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="R6X2VZaW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB5033C9;
	Wed,  2 Apr 2025 01:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.16
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743559004; cv=fail; b=Loz7CeovIupgGS4fmY1hBcTLQgJ5pEmsVwQL7neDHxb8Rm2lR9iTdQxYuaGUZftN75hgXUSw0w+4xD+gIDgdbIpJTfckKWkWvJH/jU48GmSWHS8JgCkwzvXT3ra7FWrTLD6hWzyG429U6Lr0TdYfxzuOtF+/kyCXslZh+bJPkHE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743559004; c=relaxed/simple;
	bh=I9c7h/rRhXIjw81CkbiyV7TzDixrkrPDdY+ektCAPZo=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JA7GsNUq2DH4ojB7JSzBlqoCQx5q5DUrY3GOIWZTa0dEZUhiAks5HgJWn0xhq7wUpnzw4b5JwiG0JzDPi0pNr1+v70nIxzTICL804VDEIpxm+onYB+NHSOwvqs8P33hrSrtcQfPvWJsXc1hNfyTHEQohtJhE+C5/KiloS2TtOGk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=R6X2VZaW; arc=fail smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743559003; x=1775095003;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=I9c7h/rRhXIjw81CkbiyV7TzDixrkrPDdY+ektCAPZo=;
  b=R6X2VZaWeq4jOVXI9nhwADXYwVlNTnhkvrnJeKloz9sR4ndgTHngNSaW
   1LqSz8Kl6ui30cFQ1ElXiSabxYpRe7k2ZXcO9mc2X5JWDwKeHkSVvWybf
   bPnpFKGZaBcg/784RP4eTzqv7v1gYq7EF57tOTFSAYIn6LjB3P0jj6PaE
   8Pg9lbT0zdSUK76f7k3u0kERbka7hruIMxwo1Ypms5p9QwZYoRIcW8veF
   HFmut+NSnX94cdFn06RQSsQ8VFb3Qn8YBNcLZfzIbFRetjb0wqx1vlv4q
   p98MFkKjchiHj8gqvHWSFPPEzUkkiUHdpKgDAsE/mUwTrxdPQxmSqg1Ru
   A==;
X-CSE-ConnectionGUID: DYkSHQsfS2mG7Z8fA0oOBA==
X-CSE-MsgGUID: Du8jbmlWRZm/CLFL3YrzDQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="45003602"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="45003602"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 18:56:43 -0700
X-CSE-ConnectionGUID: x+zPkgxWQ9eudogLsBXZ5w==
X-CSE-MsgGUID: qCHybrBvSl+j+WLsggG9Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="126508339"
Received: from orsmsx903.amr.corp.intel.com ([10.22.229.25])
  by orviesa006.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 18:56:42 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Tue, 1 Apr 2025 18:56:41 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Tue, 1 Apr 2025 18:56:41 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.40) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 18:56:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XRJwH3LWbtXPTxUl4U0psYngRq+93VFOycl0qmMilltEAFo4m94HTtMltDav3ZTwFRnYzIWOST509Wgwqtjna8BGnOt/HVkcVwyXGxovYpxZ+3pKu+UhlnkBZ8ds7lVDReC8YrmAeQ9piUyubYTfPXHZLSm49kasKwLiJUS1vyTLrifZCS4D538byu4009QQuNnlmU8BeggUORfkmb3ns9Xg7afH0uatogA90NFnxXLlwbYyxmSob0g2gm5evhK2F9LORubPKQ+mRiyNToZtIflaM7/6jCyjJhgX9n4j+/GhDT2frXSjqDaCvIQAezddu/lnFtjts27LgTqsknLeyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ImGkH/UGEpco17nPX0oaMQQ005iX4gwm6oLdz9SvIOU=;
 b=qQjBB6CHjIbv+O6mf80Kd2byEA21Wzsx0sd82ge4+mOiZQgveTSh2q1yOtgtXEvU4DIikDAeZXBdwiTpWT91uw5lBZ5NDRdtN2J6G8a3u0UD4eTbqKvsZjONWQb90W1T0B3rpwBGpt1QptOH00IARjc9AhaDdhV/gX6aN8vTjLdIyvBl11iOmZDIjBi3cE8a2xhFAnCJ/jncmNfC8r9gtdTD7+KJrh32GfWxD2bgMlRNjZIu1+eC5n/V2vGD/fUKZIFrok5ZowGxCxGvy2Y6KdGHfZ+JmbI9/ZQlh6q8pZSrIZAtswM9n6xYRlqGSElrQH7Z4PP/pI5rz45GXlVhZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 01:56:36 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::cfad:add4:daad:fb9b%5]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 01:56:35 +0000
Date: Wed, 2 Apr 2025 09:56:21 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Chang S. Bae" <chang.seok.bae@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
	<tglx@linutronix.de>, <dave.hansen@intel.com>, <seanjc@google.com>,
	<pbonzini@redhat.com>, <peterz@infradead.org>, <rick.p.edgecombe@intel.com>,
	<weijiang.yang@intel.com>, <john.allen@amd.com>, <bp@alien8.de>,
	<xin3.li@intel.com>, Maxim Levitsky <mlevitsk@redhat.com>, Ingo Molnar
	<mingo@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter
 Anvin" <hpa@zytor.com>, Samuel Holland <samuel.holland@sifive.com>, "Mitchell
 Levy" <levymitchell0@gmail.com>, Stanislav Spassov <stanspas@amazon.de>,
	"Eric Biggers" <ebiggers@google.com>, Uros Bizjak <ubizjak@gmail.com>
Subject: Re: [PATCH v4 2/8] x86/fpu: Drop @perm from guest pseudo FPU
 container
Message-ID: <Z+yZRSxgj6iwdVTe@intel.com>
References: <20250318153316.1970147-1-chao.gao@intel.com>
 <20250318153316.1970147-3-chao.gao@intel.com>
 <e7ef5294-26da-4a4b-9c6b-f5c0f293a56b@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <e7ef5294-26da-4a4b-9c6b-f5c0f293a56b@intel.com>
X-ClientProxiedBy: SI2PR02CA0054.apcprd02.prod.outlook.com
 (2603:1096:4:196::13) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|PH8PR11MB8107:EE_
X-MS-Office365-Filtering-Correlation-Id: 4a5782a6-83b3-45eb-82dd-08dd71899926
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014|7416014;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?BDYv409F7pJ2KngnPShIeyF+YEdLeOuZREcx9mypwM49PFVkO6BRY0mF+vvq?=
 =?us-ascii?Q?aB1Xa8zZsGl/xQyJxeVbhM9IIVqHMzN4bpV1C95L7ENLVg7ICx9o4Y9cVPsw?=
 =?us-ascii?Q?J/mf0hkoIiGQt4ubgUNhjG+Cxjc1NQ6VlppVALgbxCt6llqkFtjHMmCADu9W?=
 =?us-ascii?Q?W+bupztnhvRZRpeLrP7ert3hCKMPGt+zr0GkrqMRx1+Taxj4H2HAnld1KD4H?=
 =?us-ascii?Q?GVBPOZd7qLpoUfXYfM2zG/As235nKQkdDWlknxKFducpPWIJvx7iF87xOplb?=
 =?us-ascii?Q?+OzTtFu/UVyePnBqnLc2AZLGXU5BgyxBgN+Pa4ApRkpSBFs8bRixMxY6e4+3?=
 =?us-ascii?Q?4felKM24XG15PCm7DdUAy0NE7prenACHDSdKiz0XACL9K9xEUOH0SKdd6sCk?=
 =?us-ascii?Q?XGpiNdUn2KFrqkX4t10s5DiyT5dZcY2aQbOyDwOLxzNmJp+FfRUo/5LHN5GY?=
 =?us-ascii?Q?Kaz86gvaRbSxBTPrCBvw91D4vdNzmMmtOhQByzp/ahShVeW26jdmGQ3kQz2H?=
 =?us-ascii?Q?D/zc3zLj98P2U3xw+zPOI48A3hdgbNsvcpVakUqNB3PFUBcdvTHYp1qux8Uk?=
 =?us-ascii?Q?SKSlaHSz8AY9iccpLgF2afX210l+jPHVAHTQpucO2aIg4Zs8xhCNYOx7UufJ?=
 =?us-ascii?Q?/0LWpP3v2zm5RJ+xAM40OUIFrRVofu/0CrXkQz+Cm/9BnvXSx5Ji60+f7J8L?=
 =?us-ascii?Q?qnHVmAVZN3AyNIQO76oMekOCxwScZ7RXZ+mTTBl4rYoO8CqzZg112BCPaLVb?=
 =?us-ascii?Q?cbREOZXxHl7EBjCV1nhcgsJ2EqQK/3rLN6DDhubJUF2f43jpIPBbKFRmaLSy?=
 =?us-ascii?Q?15bGlw7xhGrFsxI+l+hrR7gqK/BK3ywo0JTsXG6Aqfxzv3opRRFQvHaMtpTJ?=
 =?us-ascii?Q?Opp56RcO2mEwUOgqybO01Jgfz4Hvl9OBQZD+HAPZ9s+QtFkJEdvIYoz69s5m?=
 =?us-ascii?Q?iY+lmZPD01nYFu50/zhAvOXMMeirTnmCGLz9N4mgwqfEEeaqkipEPfoNZThq?=
 =?us-ascii?Q?0E+iNkIbA5MjYsrROYy7JxCrrW94OVN/1A6kitUN8IbwlkQMsK84HHcMWNHb?=
 =?us-ascii?Q?xCaQ+BEZzFqWpamOTMzjgnh0uGUjiFEg/T6Peqsla/20CSDfHyUpM20J3Vgo?=
 =?us-ascii?Q?6q6tnmQqRMQvilxYLRPavHnzpq68z8aqcFthDXGLtXtSjV14YtVrZ7SMtu4A?=
 =?us-ascii?Q?DcKE7lFSZ2LITaZzAF2I4zDtfXkB5HFBXD/ha/2j4XtiNFA+F7GOx7iCgZES?=
 =?us-ascii?Q?V/sJ8g6Qo8PkCXONCZiAjPNdNvUT0SejODgAJTP2VuHeWkS9bwiNhf4DJpPA?=
 =?us-ascii?Q?LgrBI+1CVIc5QQFF/SLS4XCwkRTk64hlAM0QUsxunSu1PBb/QZqzB83CJvpl?=
 =?us-ascii?Q?stRnWZkX9eDYTHuhWfgtqm06yNTj?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eEJayQ9jY2IFNpSPBRCAII1s8c2emBeKrOacR+dMEKn/QCbKO7NsUzfftNEf?=
 =?us-ascii?Q?opQmb6A/TzFH0q3NzKln73t52xTixsK85fWm2PAfYjSSaFje1SvTSwGiJ2f2?=
 =?us-ascii?Q?TLxGpUcZnBBw6SrYUo1CTSv3Jic7YXDt3T6Cmw5K30qJppG58zHLJBW0axNj?=
 =?us-ascii?Q?cGD89Yv8nGhPbNpCAyJ5/alWDjLXd2W/pjJRRt0CYj8QVMKeJkclnVEe9lJN?=
 =?us-ascii?Q?wH/NPu0SSSifOkrKhHRYE6NTL+DolQy3j+C5BNbEJjfrEWc+YBQz5bVaOLoF?=
 =?us-ascii?Q?N2ywOj+lv84cRWh4V3JfNnka78QaNG99CV960TTB5ulQDCDLjP8cXK34O7W0?=
 =?us-ascii?Q?TDifmF3eFdGgRTi3IRalAguu8FTxXCowrZqaQN9SHeVInFkxKa5HRXgqXHzC?=
 =?us-ascii?Q?Cdvm7t69Edeq4wOFRfkHSEIshL925oj1Osq3yLyxwPhVkKk0xkZYoxhdHH+k?=
 =?us-ascii?Q?FJ99i5FXh6Q5NMKJdNbzdv9CMaRj3OBM7epTqM+E7VsH1sSnrYuGS4skzIbk?=
 =?us-ascii?Q?47YNYWi9Is7lx3Ec2WGKtlo75Yleo8Ops9XWh3KFhgf8Jd0qA/+Feyl0b/pd?=
 =?us-ascii?Q?QQB0cwYcgpNI0PLTf+ZFAqvOG+xUbKkATihf+Qfesv1ekGyBI393D1U+N+UC?=
 =?us-ascii?Q?pJ4VXVt4zVHcfK01lxtP45msGpb0QoPKPdH+Vi+TZ2kMyjSE2OrkwVaOxXit?=
 =?us-ascii?Q?j6FMTof2P1wT1RNtM5o8y/DAOoJya+GmheJJpRaDIjni7gdL3Ti+R/Qf9c61?=
 =?us-ascii?Q?TxLPeDfPgFnmu3X78jHuCigy5ug+xZRVvxoZDprs4QRdFFWOaAaNn3yCeeyF?=
 =?us-ascii?Q?SlXcCU+wiBeyEsomJDpBbRLsDKpjp89QCqkvI/W0vEmhnnPJM9EFwU0SWsLl?=
 =?us-ascii?Q?4YCQKWVWOJNr19OO1KYoD8WrybVEQT4VOUcYXJv3LArlC2adxb4QlN6/TobL?=
 =?us-ascii?Q?14YlQuQHW1tiCGNZIs+UJNbhDtlMTQdL/ja8UksXLTc3sdY+WcLk/zPGHd11?=
 =?us-ascii?Q?p5f51WHOnR5k1WGiLkjHtps11rz5q8wqFNBYPQWTDwVp+HCEY7xmZ4ob/saH?=
 =?us-ascii?Q?kEyPitsed4lZW6oMkzMFJXPDCKtmBeH76+CrnP5gCYD1CkinystuXHJdqlUR?=
 =?us-ascii?Q?TrwXtO0VkbwlYnePWaLfE6Dv7QKODft3F4DYboHJmn4uDfXX/IoUnoovFBSb?=
 =?us-ascii?Q?fiQSxOzypNyeI+aMjQrjXjHQY/jIG0gCF0tdON2q1uIOQAl2TL6fDAILuA+w?=
 =?us-ascii?Q?YBWlVxs/kQPGf1z//mD8WOrrLwtepBv1ZxR+X289XigM4RxtwRH2Umg/ElO1?=
 =?us-ascii?Q?axALbtL2bulQzpY4JaSxA3p6dAntKx+st+DImY0s5Q3mEv2LlWHM7joUtlfZ?=
 =?us-ascii?Q?ixf76/6PKElp96Pv4RSMz8Ju+VJOqhAWt+PHPXS0rsrXZ4oYmtAvT4sPw4hd?=
 =?us-ascii?Q?EJNaVfH6i1SSZ5FVwKgBrBIvpoFkOt0NER3duFVCuquRFPnWWVxHypud9MCU?=
 =?us-ascii?Q?2Cv6v56RAM8IAnHVOxsqiGbnB7S+ce7HWL031s22awIcMjmm9Hi99wyvujy9?=
 =?us-ascii?Q?FTfVXzGxY5LoqjxG5o26eEi6/VS1+JXjW5D01W0z?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4a5782a6-83b3-45eb-82dd-08dd71899926
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2025 01:56:35.4068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WtGbMeVbLk8yhNsu92w9cNLRAmFty6P7IZJuYGDzPV70+eVp7xY8Hkh9x2zmeYev2ehKJS05ynMHMXvAqnI7wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8107
X-OriginatorOrg: intel.com

On Tue, Apr 01, 2025 at 10:16:47AM -0700, Chang S. Bae wrote:
>On 3/18/2025 8:31 AM, Chao Gao wrote:
>> -static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>> +static void fpu_lock_guest_permissions(struct fpu_guest *gfpu)
>>   {
>>   	struct fpu_state_perm *fpuperm;
>>   	u64 perm;
>> @@ -218,8 +218,6 @@ static void fpu_init_guest_permissions(struct fpu_guest *gfpu)
>>   	WRITE_ONCE(fpuperm->__state_perm, perm | FPU_GUEST_PERM_LOCKED);
>>   	spin_unlock_irq(&current->sighand->siglock);
>> -
>> -	gfpu->perm = perm & ~FPU_GUEST_PERM_LOCKED;
>>   }
>
>With the removal, the function no longer requires a struct fpu_guest argument
>as it now operates solely on the group leader's FPU state.

Good catch! I will drop the fpu_guest argument.

>
>Thanks,
>Chang

