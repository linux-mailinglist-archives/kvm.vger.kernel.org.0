Return-Path: <kvm+bounces-16838-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 04CC98BE5CD
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 16:25:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B5B2728DBB8
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 14:25:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D2F715FA6D;
	Tue,  7 May 2024 14:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="cJAH8BtB"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E98C156678
	for <kvm@vger.kernel.org>; Tue,  7 May 2024 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715091790; cv=fail; b=tYExifY1/a0QMiiTA5TVmkzVf4foBVAg6VR8ct1UMVtuvioYBWC8qRRNo7lpyIus9WCxtSaO/FLmL4SljvavfxhV4Ywg2wDclOm4HdeSahA0l8beecfsxtH1RWznKTnANWyizXl4us6i0gqSqSxYkw9Ov06OvrxiVCPUdx9SX3c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715091790; c=relaxed/simple;
	bh=3UdHqmB+9JSE/CRaciPUUDeDFfo3XqUTuHrjxLk1J9I=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=o/4CKCkTgeXm5I4Czs/jLuEgOR0a0c0/2Ibvi6n/gTxWVav5WMw9TyJi/a3m5JF8aS3PbfugSiiDPheKfne4QYA5KAofcS9xx1ulemHeJ8YzZiipF4uDTawQDCtn6ULBAmDNZEa0q7W6LFXccXK31owA4bEqDVBi4SJhGJmBxMg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=cJAH8BtB; arc=fail smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715091788; x=1746627788;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=3UdHqmB+9JSE/CRaciPUUDeDFfo3XqUTuHrjxLk1J9I=;
  b=cJAH8BtB7Y45WHXk4pb6iIYss9xTCEqQG3DVX/HRpYtWOCJcOYKyk/xX
   kpIzT8JpUmSxgojp0ICc3EGZSyQe0TFms1Zsb2PDsKF39uWxiBoQtcX+J
   cDMONXbXlAzpl5F6ITteDKPUqhYFraKtU2VQR+6HBBN0BwBVsISJOO0dq
   +xUzjdEiIz05AizJgVGSMeYcPa+1aQLL6FafmsxZV30e3wNnoLHKdCGSX
   aSKdomcDOfVVDgsbJKBLYgCd0KzCRgs0aZwZmcMw1LG4vAdmAETUWnQv1
   FuJM6BlHkEIBeJ1W5jzqlquKz/rZN5k3wi6ybJrD2886F6NXwEG02q8Qj
   w==;
X-CSE-ConnectionGUID: 6XH8z1tlQ6yDCy+DCGU42Q==
X-CSE-MsgGUID: ApCySkTXRoWe8b4eEeJukQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="10757745"
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="10757745"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 07:23:07 -0700
X-CSE-ConnectionGUID: 0bmE+ofaR6mUHKRYcfP8Pg==
X-CSE-MsgGUID: tFNtR9dnT6irNPikWtYMwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="29120101"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orviesa008.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 May 2024 07:23:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Tue, 7 May 2024 07:23:06 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Tue, 7 May 2024 07:23:06 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Tue, 7 May 2024 07:23:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ezI9vkL05vSkbOKRY0AiqAtpPX5OBeV48VevkbhtN/zzK9iZYHjRgzs0aIKNfEq5jO6+7bAjVXzfYDZgsV20SM8kfKBJLblu/ZPLcfbeyZqzTptmMCOZvp6csngoTfhYpiJYDiYX5nBryCBuqAHuAiwyfJzNTzi1xOT6C7rSA1Dl41NCJ8aFRI/VBt5S6GpFZygFv3sffQCA1wQhYcAA8zX1+TzVD0AWsD5VZdLFTQfAwmTvNo+60tZVS4prDZHb0BhlKnWDuyePQBe+EuzcCbEkySr1N5Av70aRIpAiz8HdbLhx83paophsLAHOIajcN1PFquUqVqSvifnKoGQ35g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3UdHqmB+9JSE/CRaciPUUDeDFfo3XqUTuHrjxLk1J9I=;
 b=gAYx1xMDxElQAazHS5gNNFE4RrzQqw72Zq64IAOsxYfvoUCAJ3bLSbwHNYKum7S2AYLIWhXrYXLfdKz2mg0bbEQiXEBCHl5lcmxL5sDAtHA7QAsXonP5wZNKsp2DofCz3Mp8lwMVww+4vvKppkCKsO2kNSxKZK/06h0Wgn4CKHw03t+teBtDC5RPm8mrU+CM5KYHwxET9MEut69AqivTEAJ++707kEVANZtuUJE790zjVoMI5bTWBVxZCwcS6jPuJGHUcsvffeYv/uaE4jPv82a4gws03cFMWE0wDFpBD2jHGuQrRw2h/PCQZAWIjrIRZRvApEygPC4g4oMZ2YAyJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CH3PR11MB8660.namprd11.prod.outlook.com (2603:10b6:610:1ce::13)
 by SN7PR11MB6680.namprd11.prod.outlook.com (2603:10b6:806:268::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.39; Tue, 7 May
 2024 14:23:04 +0000
Received: from CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e]) by CH3PR11MB8660.namprd11.prod.outlook.com
 ([fe80::5135:2255:52ba:c64e%4]) with mapi id 15.20.7544.041; Tue, 7 May 2024
 14:23:04 +0000
Date: Tue, 7 May 2024 22:22:56 +0800
From: Chao Gao <chao.gao@intel.com>
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
CC: "seanjc@google.com" <seanjc@google.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>
Subject: Re: [RFC] TDX module configurability of 0x80000008
Message-ID: <Zjo5QBVXjO2/wLE6@chao-email>
References: <bd6a294eaa0e39c2c5749657e0d98f07320b9159.camel@intel.com>
 <ZiqL4G-d8fk0Rb-c@google.com>
 <7856925dde37b841568619e41070ea6fd2ff1bbb.camel@intel.com>
 <ZirNfel6-9RcusQC@google.com>
 <5bde4c96c26c6af1699f1922ea176daac61ab279.camel@intel.com>
 <Zire2UuF9lR2cmnQ@google.com>
 <f01c6dc3087161353331538732edc4c5715b49ed.camel@intel.com>
 <ZirnOf10fJh3vWJ-@google.com>
 <3a3d4ef275e0b98149be3831c15b8233bd32c6ea.camel@intel.com>
 <322e67ab6e965a70a7365da441179a7fa65f2314.camel@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <322e67ab6e965a70a7365da441179a7fa65f2314.camel@intel.com>
X-ClientProxiedBy: KL1PR01CA0096.apcprd01.prod.exchangelabs.com
 (2603:1096:820:2::36) To CH3PR11MB8660.namprd11.prod.outlook.com
 (2603:10b6:610:1ce::13)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH3PR11MB8660:EE_|SN7PR11MB6680:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e821cda-da2e-440d-5f5c-08dc6ea13567
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: =?us-ascii?Q?TomO+036Si9kT0jJ9jeH67NguoJl3PMUYEOv89dV6KPQeveSuDfC68K/bAw9?=
 =?us-ascii?Q?3c/MymJHws7fYb4vcZDZPNClB2Te4mxlFnz/+sHAQxgQUMsREiqrL7tA3eEl?=
 =?us-ascii?Q?7zZrEWcwp49qWo3kSwiZVF1qH5rsE5U8XFQmSMRbatsAnfqKm3wbgNUzac1l?=
 =?us-ascii?Q?pbe2gvWZbdjB08HxHb3KujjfmuX4a/2CJBS+LiiVaH+7/wN2hIsHMbftdAGr?=
 =?us-ascii?Q?/4P/cWNZKMswK6k7OmwtQoD5j46sr8ZWXmdjDSSraZgbBDWhc31+WCok/uWB?=
 =?us-ascii?Q?6Bl4puv+biRwsmU527mpx2KEXVJsS6XBtSW1vh+SVz192+3HdMPpmGx9edAr?=
 =?us-ascii?Q?MITWyv5ViRPehQgiUXuNpMfV721QpdO1mhVjkDkixGpK2Tymg0q0Q1XMUqCB?=
 =?us-ascii?Q?NnszgSUN98R6+TTH6o/yBeVKAktFgDxcV1PAwgWPvEfGJHVb80xL+yS324Se?=
 =?us-ascii?Q?ajzcTXWj40A9LB/KqkP2w3Wm0AEXQcCZlodd4ZurU1/VEMJtqm+QRHllssFm?=
 =?us-ascii?Q?19800WIWk/vh+qnnXHSmID/Z+/L1iH6X7y2MRN0ByNy8srJ8MEzRXEgNODtg?=
 =?us-ascii?Q?bX8OMDnIThoLszLR3bo+J092oEWSJe52EjDYlTmKu//Q36SlMtoWybZ7nbV/?=
 =?us-ascii?Q?nGUls7G0CzTNoRjCwX+nGx2JfRoiqw7KxAoFFog/mj8lkxtPTHTVexFNXgVv?=
 =?us-ascii?Q?GYDI0dtJwO28WnN/kD0RyhCNunafHrcC79slGoLknTL+pwMbe4Lhnc7epQZo?=
 =?us-ascii?Q?xl45eurUi2+mgbcuOFIP91/KDpIpKkUy97cyWj29ZAIzC/dRVMdw8hRHHqdH?=
 =?us-ascii?Q?4VaghZuQu3uNhkFoBVi/rh9SQxb5WBnxXp9UTkV0ntAQFEZlFG+mhN1gwnAH?=
 =?us-ascii?Q?DRRG86X2jY+iZUG0hNtqMrghaglZbejk6woIUfsaLLu99q4AO0lJHkbEHHfG?=
 =?us-ascii?Q?TUTDXLYVT8y4hxV01o6NnZHDrqBQCDKi/tg/OEdT8cXv/IZXUeL5Gk/nRkrn?=
 =?us-ascii?Q?C+BNxQ94/kcZwxrvmAIwCVv7fxCoZzIJpzsoQw8zBvvrMKtAzrC0UEVuZJyY?=
 =?us-ascii?Q?mxfCMja/kdqzmbqg+A7ihzJ/adgBEeBvyScd1tSPOnVzcY+okb/G2oqgoGM4?=
 =?us-ascii?Q?1+bX+Nsh8Y99qWCevME1DtUyh6lpiXWCry09MQLRu+Tpz6X8ivGnsAgoMtOs?=
 =?us-ascii?Q?GR4iteenozuWt8H/N5UD5yUy2LllpQWfOmHrAB2JBbqyFR0wT+jypGeU8nOX?=
 =?us-ascii?Q?CIEyOVZPsvQn5Jo88nInM+1IOgcBYw36C+kS6SHXdA=3D=3D?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH3PR11MB8660.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?gTS5MMKeEVIwphCpMQybOo8W3ziUVXNRFMMytEXPlnNMPcmD1Il4Ue4fyrLP?=
 =?us-ascii?Q?fXeqeCfcPi3OBy8Bm5BVglyrR/n6gBwBIiQv84Xw9cTzNOLp8jUHUKlmhcKO?=
 =?us-ascii?Q?r3jtSTBtihAqW4/bv9mzcEDZSoimxNlDj8UazvtiPHinZHbSJzrFYEb9r00C?=
 =?us-ascii?Q?Py3vCLNM2Ma4+sBOcnI955Kpb+mzjb9s94m/kgCxmwDow7Duvls7aBcHamxk?=
 =?us-ascii?Q?Vbb8hyC7O8Bxr+h+pAUZgz2A/vJ+4Ja/NjScBApBNt6ZEEPYmJL5K/U9/j1m?=
 =?us-ascii?Q?zkcZcoDsYRmj6ZH+L+3UN5IybxaOFuvuuFrs68BvdhjWI+ZykjcsF+/Q/9iz?=
 =?us-ascii?Q?DPKd2pSemcR4cQ0QPegdStTVIiYWg3nxmjPHxw68mXZDrNdStLdpQhDN6xJ4?=
 =?us-ascii?Q?lOSZKEb5nBI49EdYQ+wuT7AD2APPGUjPr6Vjritq7MIv30h6LlF/YjhrQ9Gm?=
 =?us-ascii?Q?tz0drnlZTC/qIM+Lcm7EEbe7vd/Cv0MPQhGbAEXge9DsPEjUtbOwFOOO2qi9?=
 =?us-ascii?Q?uu9n8F8N+BL/woC3IV6Fp86G1qRg2kEhLpDx9mIv+UTcVh3MySMIKNZdhHxq?=
 =?us-ascii?Q?xmk9PgeGrIzcNtsVoy9N8+aEuzyukflv3jiYxwIEjZN0JeYC95F7n94Ym7o5?=
 =?us-ascii?Q?z0Tfum9MzUkZQjvqBpQpLTx7LRHQ6Mun8eVDburbrMHbcsWnAoeWT7d73ykx?=
 =?us-ascii?Q?UC2qjiX/gd1IMgs+iGfuu+QfaGZGiFs2SezueGlHbzIGPkj7wWRaXFYGgCjT?=
 =?us-ascii?Q?3Fhc1vTz0wsjXShL8xWWZoBKtzpbXcsbqlhMGq9oqfAufuiCyiU2ia0RWVu5?=
 =?us-ascii?Q?WX2JjOt2rkAIwP75YhAdp+tPTrjXcjtYTcZfb4V7cvyEkmsCumby/vjhpkFH?=
 =?us-ascii?Q?EDZfLISgQ6USbjaknwsfXIIEceNbDifI7d/wdaGwJgoR7i3fSoR1ZChtdvJM?=
 =?us-ascii?Q?Yi7LjkDBCRLE/IUtCyIcYEDJ3xfKxqtkFavPugwNHGdmLiP+2KbOcsemqRJS?=
 =?us-ascii?Q?4XQfzE5rpxbzd1hx0Dxm2ckF/ShQj4cauUlvrdnhTzyPV/1vHd1j0ioH39Xj?=
 =?us-ascii?Q?ll4NYycn1eD62ooyy5W9bXRGdhnzkwHIskxoiIQsLBdN0cDiTqo/Z9q5JsmY?=
 =?us-ascii?Q?ZnHDAkvueavWnvyTLV2KeDEF6QZb+mcg3jMuWwJz5SZzsUXGwey/pHWxCaah?=
 =?us-ascii?Q?ITxkTBQY0pGgOKVSzW7317W3dT0/y/f+8qydeONEu1A7oNzZsy2guXbPkQTh?=
 =?us-ascii?Q?AAekrSPBBIT6AJyjFRGaePSp7SrLhnGNepdkvdYCPu75xO1db7Xnw1FB7IEV?=
 =?us-ascii?Q?zG8fExNIynclGScO+Ju9s7VIuqcYrRjOnq0NEWOp87UYaZWLZ/cgGBihfHG7?=
 =?us-ascii?Q?ckZNvdXvsn+QU4Us1Nh94/aogE4czqd4zo2GNMEu3OQs02on2oM9gRWi7zTO?=
 =?us-ascii?Q?Fphy3CBfNmxyqnco9bEhgl7dqndn+50JltSMFDNlZlS6ieT5oOUPEXNb7K2Z?=
 =?us-ascii?Q?XmHT9CxGG0eE8rntLGB2GEPd5vrAZRiJuLlmDIsMUKsV80NaKBm+QketHewv?=
 =?us-ascii?Q?UBIh1G+qJVkHLO9iSphvuVTx2zLDOBaf2t9TzNzy?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e821cda-da2e-440d-5f5c-08dc6ea13567
X-MS-Exchange-CrossTenant-AuthSource: CH3PR11MB8660.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2024 14:23:04.5914
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6OqW/H/vR0pCWHSuTORtZdG4aiaamtce4m0YRidz8z50QgoEDhdXWFwquRShe2QerG+cO/ADDuI8hRltj/W9/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6680
X-OriginatorOrg: intel.com

On Mon, May 06, 2024 at 06:40:03PM +0000, Edgecombe, Rick P wrote:
>Follow up on this:
>
>1. The plan is to just always inject the #VEs for private and shared GPAs that
>exceed GPAW. (i.e. not pass the subset of EPT violations that could be handled
>by the VMM by clearing suppress #VE)
>
>
>2. There was some concern that exposing non-zero bits in [23:16] could confuse
>existing TDs. Of course KVM doesn't support any TDs today, but if this feature
>comes after initial KVM support for TDX and KVM wants to set it by default, then
>it could be an issue.

Do you mean some TDs may assert that [23:16] are 0s? A future-proof design
won't have this assertion. And this case (i.e., some CPUID bits become non-zero)
happens on every new generation of CPUs and doesn't confuse existing OSes. I
don't understand why it would be a problem for TDs.

>
>For normal VMs, is there any concern that guests might not be masking the bits
>correctly?
>
>TDX module folks were pushing for a guest opt-in out of concern some breakages
>could result. Of course it requires additional enabling in the guest OS and
>vBIOS then. I was thinking it should be a host opt-in without guest control. If
>there was a problem it could be a host userspace opt-in. Any concerns there?
>
>Thanks,
>
>Rick

