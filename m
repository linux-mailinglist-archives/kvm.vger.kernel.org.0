Return-Path: <kvm+bounces-71612-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GKmSEGOCnWlsQQQAu9opvQ
	(envelope-from <kvm+bounces-71612-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:50:11 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8297A185A4E
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 11:50:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 106C73158E9A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 10:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9752737996F;
	Tue, 24 Feb 2026 10:46:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Bd0sw7po"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB3C36AB59;
	Tue, 24 Feb 2026 10:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771930008; cv=fail; b=X0G9kfXTpDf3aJ+4tL+DgNNQueYxIFqtuMx5737uBQ59OwpjUiLk+0q8pYUU+CwLljYBWMzuB+n5R5fNSfwg/xFqt8RqdWBe9C4wDfzpxZD8VGzgFS4SwvTvE0ILmrkqEArdzQUkvVp4d951brvmNiilojhhdGujyA8psolD7II=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771930008; c=relaxed/simple;
	bh=5tBuAlP9p0dWJ7SnxzW5oeGbYc7dfhJYJ9daRSrrkxk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Wpq6eD+lxUmUvIrizsbrJbiSRQndRUSdqhs+DQ6wnETofpksTumiXsd6vJ9E3qe7c72elXFbpD+jaeUVMwIAmr8u4gdyv8DHYA/1GRaEsUVfQp+GnMSyfZIxrwiqCLeHufWXxNpJCHa1P2ZnrtHEWCubZsVsGTxI8MLHjSo1Hdo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Bd0sw7po; arc=fail smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1771930006; x=1803466006;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5tBuAlP9p0dWJ7SnxzW5oeGbYc7dfhJYJ9daRSrrkxk=;
  b=Bd0sw7powUyQuGuImJMh2kgtDO/QD9hDSxTuC85wL42WNVqXGcbFS2CN
   Bmp8YGn+wh/ot/IM/1Y4Nwj7TUsb3wFR1TrG+iRi+sirc9H5J88S3sbeu
   yrEVxOuHeg5HWLUpWAILlLoUFLp32EQ9/6L5FYiL6Dl4uILeFUwTBlq/P
   QmkNJtnlFLUM7O4uLKIID819DFjyk3JzGXMpicS1br08WDWUwqDhbGruF
   XihlKJIeOwJTcEnchJAtGNq3bLG8zdSCoTCQK5NSP2z9e7tLDG+n/FQnd
   2xXnHbY23jFxYmFgWB7f89yEDNs+5Lfxen6ugg+tk9PF4IfTunEyLbdr9
   Q==;
X-CSE-ConnectionGUID: 1otyUs5cRhWOBL3X0UvyCg==
X-CSE-MsgGUID: DAN/AGldQ9y7Bw8wEpTsrQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11710"; a="72151833"
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="72151833"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:46:45 -0800
X-CSE-ConnectionGUID: yv6QBOg6RkO8S+idn9icAg==
X-CSE-MsgGUID: eXgo0X4TTGKCN/CMcjBoYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,308,1763452800"; 
   d="scan'208";a="214113195"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa010.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Feb 2026 02:46:45 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:46:45 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35 via Frontend Transport; Tue, 24 Feb 2026 02:46:45 -0800
Received: from SA9PR02CU001.outbound.protection.outlook.com (40.93.196.1) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.35; Tue, 24 Feb 2026 02:46:45 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wVwPaWVaOLKdSx/5gOcWepJKJSHji/eLTQotbMHKllJKz8sh2hoOwYoj5tORvkQia9ZM0lzAjkDWqjlresfAS1O+xV29P/ZVWsRTAcikVGM+TYg/53VMYdszox5sCOP8b9Ulpp/ng+HUZLbuefUzpLU7gf4o6R4lhZl75bKx1NlGTMVbZhg4iooWGdY76On3k23IbeCKHDYpiJ3kjQfxAGd506bIhQFCq9kaY9xSvNLm8j7kXFZOvkCU67UpJiY+0Ykq6ciuAH9TZPDJnBokAlaW7XYvLxemZLE2vKTKXr8Uy9SXXdx7NPB7qGM2+LJKsuq8aNN9mkp4qJxFbLiOMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5tBuAlP9p0dWJ7SnxzW5oeGbYc7dfhJYJ9daRSrrkxk=;
 b=ufG7QPKKk9nCxJrtNMV4L9fajoWruCpwplJFJOR6HYavugxC8A243u1rE3C+2CJ7rKxHKAuY2obrpEZmBFZcrkCC5eHMf/t8PxdB2L73zpvsx7i+5MM2Ge3Gc1pwNhzArXnAzMN0fkQGQE5T6YCQChqJ1j1/61NV8DZ7/lPtNXdJirFbbCiTt9//CA/FA4gr94LnivckhB6PlTE+BFGYC0ImQUJs3bHaXiqc15Q5+svbUm0sboGoPbyoY3K7YO9c1Bl2sX9LOBcAsuTmelVG3AZ3PLEeQa+AWJvf8GNO6Vla8rFN4dixh2VE0f6HSBponpLO52Y9uZr5UONRUjfbJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 IA3PR11MB9110.namprd11.prod.outlook.com (2603:10b6:208:576::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.10; Tue, 24 Feb
 2026 10:46:42 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9632.017; Tue, 24 Feb 2026
 10:46:42 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "Gao, Chao" <chao.gao@intel.com>
CC: "tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "bp@alien8.de" <bp@alien8.de>,
	"kas@kernel.org" <kas@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>, "Weiny, Ira"
	<ira.weiny@intel.com>, "seanjc@google.com" <seanjc@google.com>, "Verma,
 Vishal L" <vishal.l.verma@intel.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "hpa@zytor.com" <hpa@zytor.com>, "Annapurve,
 Vishal" <vannapurve@google.com>, "sagis@google.com" <sagis@google.com>,
	"Duan, Zhenzhong" <zhenzhong.duan@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "paulmck@kernel.org" <paulmck@kernel.org>,
	"tglx@kernel.org" <tglx@kernel.org>, "yilun.xu@linux.intel.com"
	<yilun.xu@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>, "Williams, Dan
 J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v4 10/24] x86/virt/seamldr: Allocate and populate a module
 update request
Thread-Topic: [PATCH v4 10/24] x86/virt/seamldr: Allocate and populate a
 module update request
Thread-Index: AQHcnCz7Hw4x5dVNOEG5CoBzcugQtbWKppgAgAa6XoCAAFxlgA==
Date: Tue, 24 Feb 2026 10:46:41 +0000
Message-ID: <1d33d50fde5beeb35805e1b8ae269113e6b08998.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-11-chao.gao@intel.com>
	 <1aa733f9066dd85c1d4f880c5c48b40c76d518c7.camel@intel.com>
	 <aZ00DQ2YwcwfgQtP@intel.com>
In-Reply-To: <aZ00DQ2YwcwfgQtP@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|IA3PR11MB9110:EE_
x-ms-office365-filtering-correlation-id: 3162f678-7c7f-4cce-efca-08de7391ff14
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?UEl1VDVGSzZxMEh6SFBCajM4Nm96a3dSeHhUUkpxSENUWTVKSHRsSW54cFJX?=
 =?utf-8?B?a0dzRmN3cks3ODlGc2F4YlhqakhER1Ezb1o3YVA5RTlFVHFwcDRLZ0xFbmhN?=
 =?utf-8?B?Q1J4ejMzYWFLOWM0ZzlaajdvekVFUmZDMEM0M3c5RU5KLytkaU5WZ0FycDhS?=
 =?utf-8?B?VURZWFptQTVaM2NWS1g5WU5LRXRtbHVWbVpFUUN2SG41ZGFyelhhcUhUbkRh?=
 =?utf-8?B?bFFieHdldHhuRVBPSHd4SU1NZHlQTmZHam1GdzlsNlQ2cEx2aGFzUHE3Mzd6?=
 =?utf-8?B?M3hWTnlUZDBZNUxET0I0Z081KzJIblBHZ1crR085ZDNrdkUxSkd6T0dLZ0xn?=
 =?utf-8?B?V0RVbkI2a01hZ3QxYU95eExaa0FyOVFOaGk0WSswcXArWERwY2JCemJMajBR?=
 =?utf-8?B?RG1nUGgzOFR4d2YrV0VYQTFCODhBTnJtd0RPcTVDaEdLemMrT28xQkR4ampM?=
 =?utf-8?B?K3lKM1hldGlIaTl5b0ZMNGRFNWJaU2lQMG5UaUpFUFZWbVZmM254K2J3NGJk?=
 =?utf-8?B?UjRXbEIrK0FRbTRoT3FqeHpnc0ZxV01aQmVtRkd1K1JwZDBTTkg5M3hUYUM3?=
 =?utf-8?B?Tnh5dHFpZjRjYnRmM2ZJdWRYcHdGeDE2UmZNbllxRTZCMVkyTnk5aVhUU1hq?=
 =?utf-8?B?dDl6QWdRRit0WkhIUmZZY0xvdDA5REc2VGZ5S295MjFaN1k1QzltdVhQRVBX?=
 =?utf-8?B?MjVRY3ZKNGcva05sWXVIcUdzMEl4SW5wQUQ3Y0tzbk9Dd01PNEdZdHFHRDRh?=
 =?utf-8?B?SEh6cThpZzVUenFzbHcrbXJFY01wRDNaeHhuRi9VSHYvUFN3UlYwQkIwTGw4?=
 =?utf-8?B?MCt4bUdVZjE1UC9oMytZZlRzSzNvSzF5czBWMFJxYmRHWUs4a1FPVk5WYk9B?=
 =?utf-8?B?R21qR0FNSjJUaUZzbjFUUUc3WjVURDc1dTVYdkhnenN1ZmZjZCtTUWNPeEI4?=
 =?utf-8?B?WEFjblVWMmlEbmNXRXJRWVlPeXRBR3c2Z1RKdjNvdUVXZmM5MEdhZmhFckZa?=
 =?utf-8?B?UnByMVp0cy9SV3d3UW9oN1NWNU9sUEhKWll1OHdCUkFxdmFwWXFBdllyRHRN?=
 =?utf-8?B?S0YvYWhrKzBIdGxiL2Fza3I2dWNySTI5dnpZQlVvdXRid2hqSnVEeFVZdkYz?=
 =?utf-8?B?b3hmb1pQK1R4WEcwMmpUZmJENi9HVFBvYVc1WVVVdnEvQldPVmRqTVlVUFFa?=
 =?utf-8?B?RVpzdUwzY1EzSkdJTnNHTHhxclh1akFJNWNEVWJydHFZQXpmK3RmcXp1OFRK?=
 =?utf-8?B?Vm55akR6eGMyNWpFMjlMTUNoZmM3QVZvTjNRV3J4em00aytMdGJheTlReHQ1?=
 =?utf-8?B?Y01uT09MNGtyRXpTOTA4RVliNi9uV1U1Q3lXd3F0eStxbU5QdjRIN3YrTis0?=
 =?utf-8?B?TWFIZGw0cGZZVXBwV0JtWWoyWWsycDFoZG43U1FCY2xENDZsYkNvMEJvbGY4?=
 =?utf-8?B?cmFQb0JEbmNMdU8vNHZ2YlNEVzNGTU53SWhFdURxTjJOUGV1TFBTS2JLUGha?=
 =?utf-8?B?UGRHUXBZalRxelFMRDVJYVFEaEFwMWwxYzBVcXAyamFVWTJJTUdCQXJ2UW5x?=
 =?utf-8?B?dTF5UGhMMTRoM1dQSW5pUENlZElLL2dGVk1MdE9Cb09teW9ycFRZUktxMHIx?=
 =?utf-8?B?OHNuVkl0UndXRFliNmdHei9jVWJLV1Z6TVRFeFhpUmVoMEYxME5Ya2tyQWNJ?=
 =?utf-8?B?enZRTXJTKytYN1dtbE9qSmhpZWl1azhLc1pteWdXVEk0SllncDFBNVhDNUhn?=
 =?utf-8?B?bkhiK2hQV0dXczQ0S2RUNnBuOEd5Ym9ldlZrUTVvejdBVCtaWEdBZ0pGSnhH?=
 =?utf-8?B?OFAvTTZqL3p1YUUxK1RDWndmZDQvalhSdi9WdjB1V3lGbXRyazFSZWMxMlV6?=
 =?utf-8?B?aXNOdnJ0SkdMK1E0VHZRdmRyS2R2VTNXNUM4N3M3ZUYweld3VUNkQy9xeERh?=
 =?utf-8?B?c1pKdGhKVjM4WXlzeWY3WTAzenNPRG44V0taTjRRTGpaeWdPQmdyZlZveFEv?=
 =?utf-8?B?WVVKbW1OMWUrcWw4ekhldkM4YzYrUE5iTlRscGxDYW9kRENzTURGMGVQZ3hG?=
 =?utf-8?B?VldOWUZaQXBOMUZVTHpxNXBzN2Z4Kytaa0c3eUlzazkwUWp2cGluZE00Y0lO?=
 =?utf-8?B?NHdnSUMwTUtlL3NCMWZGOER4cTlaY3IvMnlPQ0tQZHNmRDhMVlljRE5tSVk5?=
 =?utf-8?Q?VTzBPvAAfmpdho6mUBwrS8/0GdBPE9bPgUgEfP1U9oiJ?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UGtlN21vM3pKTkIxTWhoQnN5VFUxRGRrbEliSDdRWmlMSS8zS3V6VFd6M3pY?=
 =?utf-8?B?OE1PV2NsQ3ZEYkY3bTBTOHNHNE9SNDF2cTB6c21VajdIMDZPNHZyTndJNEw0?=
 =?utf-8?B?VFc3Mk1mRjMvNFJTRWRVSHZlTzhHbTJJVGI4SVQxcHF5WFhSQlBjSFR0N0pZ?=
 =?utf-8?B?MVhPSFVldkN6WVpRYkd3Q0FlSnNSMkhXK0RMVzd2VVlzUkFVU0RramlrMnlx?=
 =?utf-8?B?QUV1STNxQ1kwaFJiTDhESWx6Wkdnc1dsTnh3Z3FFSU5PS0ErMzdWbmJ5N2ln?=
 =?utf-8?B?QlU0TEpCeDVKeDJ2ZlNRNi9MRzFDK2F3UEt2QjBldHpxWG83NlRnSFRjNUpU?=
 =?utf-8?B?Y0RsYU14ODdhUmlFb0FYbmJrVzZydlNwcTQvL2V5RlhON2pwakJYUFB2YWtI?=
 =?utf-8?B?dEpPZGVva3YrTS8rSFMxR2IxeGxFcmVPd2hqcnJTU00wTVpKNVE4OWNUZFRp?=
 =?utf-8?B?NnprYjBlOWdXZUV1WXJpeUd1RndiSGJTczlINGszL1RUZmUwT0pSdDMyZHAv?=
 =?utf-8?B?Zml4ODU2M1RyT1lOdXNYWEJRcVl5Uk9IRGw2S3NuVkIxbDJweEZNTnpWNVBR?=
 =?utf-8?B?d0tnNFBlMUozTGI1WUZsZjlpclY2TnlNdVVzMllFQ1ZXbnowY1gzeXcwNUdB?=
 =?utf-8?B?cWlIK01JclptbEtYUzQ5cGF1VFlCc2RhMmNXaGpFUEVQQjQrS1JVN2pZV0RX?=
 =?utf-8?B?ZjJTUzlFNmdva3ozUXI1Q1NQM2VoeEJ3ckVBR2o2U1BkN3lONDA4MVVZQXI3?=
 =?utf-8?B?V0x3aUU3VEhHZ2R3MWVHYlNRQ0FQT2tsQm9pVzZhaWVLaUkveGRSV2FPUFBW?=
 =?utf-8?B?cGgwRGx1U1dqUWd5c1JHbmorQXB4cGljeFZqcjdtLy8rRmE5YlRuVE8yQ2xD?=
 =?utf-8?B?blpFQldmeXErNUpxL29jdU5yaEF6SVZNZzhxbVdWZDY4V3RKR0VBbklUd2pi?=
 =?utf-8?B?eFFtZUFUQ1J4MWNCN3FLdm1JdXJ2VW9KUkhMODA2QlBoR1ZtVUlFVnRFZklM?=
 =?utf-8?B?WnpaMWwxVi9INWw0ZHJuQ01sa0pmeXZFaFo3Qm5HekpRcllmeFBVd3o0UVp1?=
 =?utf-8?B?WHhMaXpGTGtxTkx5eXByZDNYMzhjU21kK1kzUVFoMjg4Q1d6NkJ0NDlKYnhy?=
 =?utf-8?B?SlhXb2R4SFhScnl2TEZmaVV0dDg1WVFuN0hXcGtFSEp2K09yS3pQemx0MUps?=
 =?utf-8?B?RUVSWStSUCtLbnNibzZQYzJzSFBMNWxpUTNvMWE5UkVqeXhVbHJOOTd3R1RB?=
 =?utf-8?B?TlQ3ajhvQVRmYnA0VHlkZ1FoUXhpUDkzck9WbTQ0N2VmbkJLbStaWGsvN1dS?=
 =?utf-8?B?RmdHNGVKL3Mxc0V3dURIa3ZEcVhJNmZneXJ0YjZjMUdaWmFHelRFbW5XeFpu?=
 =?utf-8?B?dFZBUmVqbmZ5dUlBQnQ2RHQ1WTg5T2dFR2FGZ0xOZkdwblh6SGhSejh5aWt4?=
 =?utf-8?B?cmZlRDF0WjRFbmxwaVlYMlZRekF0MXhXYWM1UXdraWZrT0orV0NrbUVUY1h2?=
 =?utf-8?B?Vmp3endiSUI5Zko4b2ZhY0MvV3haaHNmTEJjaVp1UkxibHEycGYxUXBWZTQx?=
 =?utf-8?B?VGxWYll3T1RvdkkyNGYwTEdJdnpXVVBmOElKellPVFp6K1lNMi9Va0ZxSXp2?=
 =?utf-8?B?VjlPQ3pnWWlPZVErTXJ4NDVTVG1mcUFRanN3bm1DUS9OSXRFUnE0QXM4RGtB?=
 =?utf-8?B?Nmh2dlNXY0NWZWsvWEYzakdQWFJWaVpJUCtYbE0vTnV0eDF1L3FTejFqUXFK?=
 =?utf-8?B?L0hsTTluYVM2V280aDN3RVpsZEx6MC9HZHl0SFdjZTdvaGtaZ05MQW1rL3My?=
 =?utf-8?B?OVh6UHA1dEw1SHdCYVdsYkdDejBBS01pKzFNZnIwWjZLM2pDN3I3MHQ3UWFP?=
 =?utf-8?B?R3VxNTJKYlh3clh5VzVDSEVQcGFqZU1lN0xnVnNYcEJhNzZTSjRzTXZJQ0R4?=
 =?utf-8?B?REpwWTA3dmdscFMzay9tU3VrZy9ldUdCSGZwN1ZMRnlwSXpmN2ZjVEJEaXZn?=
 =?utf-8?B?V3ovNnRTMC9ZQVdNY1Z5c01JakRkNzNqSWR1Vk5scE9ibmlvclFKbWNGcDEr?=
 =?utf-8?B?Nkp3NVVQNERxSmhSUWFmNGUvVSt3UzNsZnQ0NnQxbjJlcVJZSnBTaHBvSEZl?=
 =?utf-8?B?TWVkSm9kdmpQU3hCV0h0MDlOS0UxWG9KWG1lcGdlc2NJejRLLzdCRFZqcVJ3?=
 =?utf-8?B?REtJWHZDaHdOVldHNnp2NDlFclNCSEY1LzBSc3lJY05DZmN1bDRIbVdjZlNR?=
 =?utf-8?B?OTMvblUrYWkrWEdDOWIxMnEzNXZjb3E4ZjN2WDdtVkZTL05HZmVOSW96eTN0?=
 =?utf-8?B?YVR6WFJOeVpFckM2MkM5b2M4c0o3a1h0UllCaU9WZ3p3VjhuWHVzQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0ABA95EC0B9ED340A4A306D93ED9BC40@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3162f678-7c7f-4cce-efca-08de7391ff14
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2026 10:46:42.0132
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LJRwX3Vm8hJotmrOMZLTCoGlsX/qJSxtuyDwwbsEeDlLkx0qCF2i5NejcCjPfQLoLpv5R6rUMlVq+RoXwmozSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9110
X-OriginatorOrg: intel.com
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.06 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71612-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim,intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[intel.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Queue-Id: 8297A185A4E
X-Rspamd-Action: no action

T24gVHVlLCAyMDI2LTAyLTI0IGF0IDEzOjE1ICswODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gT24g
RnJpLCBGZWIgMjAsIDIwMjYgYXQgMDY6MzE6MjRBTSArMDgwMCwgSHVhbmcsIEthaSB3cm90ZToN
Cj4gPiBPbiBUaHUsIDIwMjYtMDItMTIgYXQgMDY6MzUgLTA4MDAsIENoYW8gR2FvIHdyb3RlOg0K
PiA+ID4gUC1TRUFNTERSIHVzZXMgdGhlIFNFQU1MRFJfUEFSQU1TIHN0cnVjdHVyZSB0byBkZXNj
cmliZSBURFggTW9kdWxlDQo+ID4gPiB1cGRhdGUgcmVxdWVzdHMuIFRoaXMgc3RydWN0dXJlIGNv
bnRhaW5zIHBoeXNpY2FsIGFkZHJlc3NlcyBwb2ludGluZyB0bw0KPiA+ID4gdGhlIG1vZHVsZSBi
aW5hcnkgYW5kIGl0cyBzaWduYXR1cmUgZmlsZSAob3Igc2lnc3RydWN0KSwgYWxvbmcgd2l0aCBh
bg0KPiA+ID4gdXBkYXRlIHNjZW5hcmlvIGZpZWxkLg0KPiA+ID4gDQo+ID4gPiBURFggTW9kdWxl
cyBhcmUgZGlzdHJpYnV0ZWQgaW4gdGhlIHRkeF9ibG9iIGZvcm1hdCBkZWZpbmVkIGF0IFsxXS4g
QQ0KPiA+ID4gdGR4X2Jsb2IgY29udGFpbnMgYSBoZWFkZXIsIHNpZ3N0cnVjdCwgYW5kIG1vZHVs
ZSBiaW5hcnkuIFRoaXMgaXMgYWxzbw0KPiA+ID4gdGhlIGZvcm1hdCBzdXBwbGllZCBieSB0aGUg
dXNlcnNwYWNlIHRvIHRoZSBrZXJuZWwuDQo+ID4gPiANCj4gPiA+IFBhcnNlIHRoZSB0ZHhfYmxv
YiBmb3JtYXQgYW5kIHBvcHVsYXRlIGEgU0VBTUxEUl9QQVJBTVMgc3RydWN0dXJlDQo+ID4gPiBh
Y2NvcmRpbmdseS4gVGhpcyBzdHJ1Y3R1cmUgd2lsbCBiZSBwYXNzZWQgdG8gUC1TRUFNTERSIHRv
IGluaXRpYXRlIHRoZQ0KPiA+ID4gdXBkYXRlLg0KPiA+ID4gDQo+ID4gPiBOb3RlIHRoYXQgdGhl
IHNpZ3N0cnVjdF9wYSBmaWVsZCBpbiBTRUFNTERSX1BBUkFNUyBoYXMgYmVlbiBleHRlbmRlZCB0
bw0KPiA+ID4gYSA0LWVsZW1lbnQgYXJyYXkuIFRoZSB1cGRhdGVkICJTRUFNIExvYWRlciAoU0VB
TUxEUikgSW50ZXJmYWNlDQo+ID4gPiBTcGVjaWZpY2F0aW9uIiB3aWxsIGJlIHB1Ymxpc2hlZCBz
ZXBhcmF0ZWx5LiBUaGUga2VybmVsIGRvZXMgbm90DQo+ID4gPiB2YWxpZGF0ZSBQLVNFQU1MRFIg
Y29tcGF0aWJpbGl0eSAoZm9yIGV4YW1wbGUsIHdoZXRoZXIgaXQgc3VwcG9ydHMgNEtCDQo+ID4g
PiBvciAxNktCIHNpZ3N0cnVjdCk7wqANCj4gPiA+IA0KPiA+IA0KPiA+IE5pdDoNCj4gPiANCj4g
PiBUaGlzIHNvdW5kcyBsaWtlIHRoZSBrZXJuZWwgY2FuIHZhbGlkYXRlIGJ1dCBjaG9vc2VzIG5v
dCB0by4gIEJ1dCBJIHRob3VnaHQNCj4gPiB0aGUgZmFjdCBpcyB0aGUga2VybmVsIGNhbm5vdCB2
YWxpZGF0ZSBiZWNhdXNlIHRoZXJlJ3Mgbm8gUC1TRUFNTERSIEFCSSB0bw0KPiA+IGVudW1lcmF0
ZSBzdWNoIGNvbXBhdGliaWxpdHk/DQo+IA0KPiBFbW0sIHRoZSBrZXJuZWwgY291bGQgdmFsaWRh
dGUgdGhpcyBieSBwYXJzaW5nIG1hcHBpbmdfZmlsZS5qc29uLCBidXQgdGhlDQo+IGNvbXBsZXhp
dHkgd291bGRuJ3QgYmUgd29ydGggaXQuDQoNCk9oIG1ha2luZyBrZXJuZWwgcGFyc2UgSlNPTiBm
aWxlIGlzIGJleW9uZCBteSBpbWFnaW5hdGlvbiwgYnV0IEkgc2VlIHlvdQ0KaGF2ZSBhIHBvaW50
IGhlcmUgOi0pDQoNCkkgdGhpbmsgbXkgcmVhbCBjb21tZW50IGlzIHRoZSBzZW50ZW5jZSANCg0K
ICBUaGUga2VybmVsIGRvZXMgbm90IHZhbGlkYXRlIC4uLg0KDQpvbmx5IGRlc2NyaWJlcyB3aGF0
IGRvZXMgdGhlIGtlcm5lbCBkbyB0b2RheSwgd2hpY2ggaXMgbm90IHRoZSBjYXNlIGhlcmUuDQoN
Ckluc3RlYWQsIHdlIGFyZSBtYWtpbmcgYSBkZXNpZ24gY2hvaWNlIGhlcmUsIHNvIEkgdGhpbmsg
dGhlIHNlbnRlbmNlIHNob3VsZA0KYXQgbGVhc3QgYmUgc29tZXRoaW5nIGxpa2U6DQoNCiAgRG9u
J3QgbWFrZSB0aGUga2VybmVsIHZhbGlkYXRlIC4uLg0KDQo+IA0KPiA+IA0KPiA+ID4gdXNlcnNw
YWNlIG11c3QgZW5zdXJlIHRoZSBQLVNFQU1MRFIgdmVyc2lvbiBpcw0KPiA+ID4gY29tcGF0aWJs
ZSB3aXRoIHRoZSBzZWxlY3RlZCBURFggTW9kdWxlIGJ5IGNoZWNraW5nIHRoZSBtaW5pbXVtDQo+
ID4gPiBQLVNFQU1MRFIgdmVyc2lvbiByZXF1aXJlbWVudHMgYXQgWzJdLg0KPiA+ID4gDQo+ID4g
PiBTaWduZWQtb2ZmLWJ5OiBDaGFvIEdhbyA8Y2hhby5nYW9AaW50ZWwuY29tPg0KPiA+ID4gUmV2
aWV3ZWQtYnk6IFRvbnkgTGluZGdyZW4gPHRvbnkubGluZGdyZW5AbGludXguaW50ZWwuY29tPg0K
PiA+ID4gTGluazogaHR0cHM6Ly9naXRodWIuY29tL2ludGVsL2NvbmZpZGVudGlhbC1jb21wdXRp
bmcudGR4LnRkeC1tb2R1bGUuYmluYXJpZXMvYmxvYi9tYWluL2Jsb2Jfc3RydWN0dXJlLnR4dCAj
IFsxXQ0KPiA+ID4gTGluazogaHR0cHM6Ly9naXRodWIuY29tL2ludGVsL2NvbmZpZGVudGlhbC1j
b21wdXRpbmcudGR4LnRkeC1tb2R1bGUuYmluYXJpZXMvYmxvYi9tYWluL21hcHBpbmdfZmlsZS5q
c29uICMgWzJdDQo+ID4gPiANCj4gPiANCj4gPiBOaXQ6DQo+ID4gDQo+ID4gQXMgbWVudGlvbmVk
IGluIHYzLCBjYW4gdGhlIGxpbmsgYmUgY29uc2lkZXJlZCBhcyAic3RhYmxlIiwgZS5nLiwgd29u
J3QNCj4gPiBkaXNhcHBlYXIgY291cGxlIG9mIHllYXJzIGxhdGVyPw0KPiANCj4gSSdtIG5vdCBz
dXJlIHdoZW4gdGhpcyBsaW5rIHdpbGwgYmUgb3V0ZGF0ZWQsIGJ1dCB3ZSdsbCBkZWZpbml0ZWx5
IGhhdmUgYSBURFgNCj4gTW9kdWxlIHJlbGVhc2UgcmVwb3NpdG9yeSB3aXRoIGEgYmxvYl9zdHJ1
Y3R1cmUudHh0IGZpbGUgZGVzY3JpYmluZyB0aGUgZm9ybWF0Lg0KPiANCj4gPiANCj4gPiBOb3Qg
c3VyZSB3ZSBzaG91bGQganVzdCBoYXZlIGEgZG9jdW1lbnRhdGlvbiBwYXRjaCBmb3IgJ3RkeF9i
bG9iJyBsYXlvdXQuICBJDQo+ID4gc3VzcGVjdCB0aGUgY29udGVudCB3b24ndCBiZSBjaGFuZ2Vk
IGluIHRoZSBmdXR1cmUgYW55d2F5LCBhdCBsZWFzdCBmb3INCj4gPiBmb3Jlc2VlYWJsZSBmdXR1
cmUsIGdpdmVuIHlvdSBoYXZlIGFscmVhZHkgdXBkYXRlZCB0aGUgc2lnc3RydWN0IHBhcnQuDQo+
ID4gDQo+ID4gV2UgY2FuIGluY2x1ZGUgdGhlIGxpbmtzIHRvIHRoZSBhY3R1YWwgZG9jIHRvbywg
YW5kIGlmIG5lY2Vzc2FyaWx5LCBwb2ludA0KPiA+IG91dCB0aGUgbGlua3MgbWF5IGdldCB1cGRh
dGVkIGluIHRoZSBmdXR1cmUuICBXZSBjYW4gYWN0dWFsbHkgdXBkYXRlIHRoZQ0KPiA+IGxpbmtz
IGlmIHRoZXkgYXJlIGluIHNvbWUgZG9jLg0KPiANCj4gUmVnYXJkaW5nIHRoZSBkb2N1bWVudGF0
aW9uIHBhdGNoLCBJIGRvbid0IHNlZSB0aGUgdmFsdWUgaW4gYWRkaW5nIG9uZS4gSXQNCj4gd291
bGQganVzdCBtaXJyb3IgdGhlIGNvZGUgYW5kIGJlY29tZSBvdXRkYXRlZCB3aGVuICd0ZHhfYmxv
YicgbGF5b3V0IGlzDQo+IHVwZGF0ZWQuDQoNClN1cmUuDQoNCj4gDQo+IElmIHRoZSBjb25jZXJu
IGlzIHRoYXQgdGR4X2Jsb2IgbGF5b3V0IGNoYW5nZXMgY291bGQgY2F1c2UgaW5jb21wYXRpYmls
aXRpZXMsDQo+IHRoYXQncyBub3QgdGhlIGtlcm5lbCdzIHJlc3BvbnNpYmlsaXR5IHRvIHByZXZl
bnQ7IHRoZSBrZXJuZWwgaGFzIG5vIGNvbnRyb2wNCj4gb3ZlciBleHRlcm5hbCBmb3JtYXQgY2hh
bmdlcy4NCg0KTm8gdGhhdCdzIG5vdCB0aGUgbWFpbiBjb25jZXJuLg0KDQo+IA0KPiBJZiB0aGUg
aXNzdWUgaXMgc2ltcGx5IHRoYXQgbGlua3MgbWF5IGJlY29tZSBvdXRkYXRlZCwgdGhhdCdzIGEg
Y29tbW9uIHByb2JsZW0uDQo+IFdlIGNhbiBhZGRyZXNzIHRoaXMgYnkgcmVmZXJyaW5nIHRvIGJs
b2Jfc3RydWN0dXJlLnR4dCBpbiB0aGUgIkludGVsIFREWCBNb2R1bGUNCj4gQmluYXJpZXMgUmVw
b3NpdG9yeSIgYW5kIGRyb3BwaW5nIHRoZSBzcGVjaWZpYyBsaW5rLiBGb3IgZXhhbXBsZToNCj4g
DQo+ICAgVERYIE1vZHVsZXMgYXJlIGRpc3RyaWJ1dGVkIGluIHRoZSB0ZHhfYmxvYiBmb3JtYXQg
ZGVmaW5lZCBpbg0KPiAgIGJsb2Jfc3RydWN0dXJlLnR4dCBmcm9tIHRoZSAiSW50ZWwgVERYIE1v
ZHVsZSBCaW5hcmllcyBSZXBvc2l0b3J5Ii4gQQ0KPiAgIHRkeF9ibG9iIGNvbnRhaW5zIGEgaGVh
ZGVyLCBzaWdzdHJ1Y3QsIGFuZCBtb2R1bGUgYmluYXJ5LiBUaGlzIGlzIGFsc28gdGhlDQo+ICAg
Zm9ybWF0IHN1cHBsaWVkIGJ5IHRoZSB1c2Vyc3BhY2UgdG8gdGhlIGtlcm5lbC4NCg0KSSB0aGlu
ayBJIHByZWZlciB0aGlzIGluc3RlYWQgb2YgdXNpbmcgdGhlIExpbmtzLg0KDQpNeSBjb25jZXJu
IGlzIHRoZSBsaW5rcyBpbiB0aGUgY2hhbmdlbG9nIHdvbid0IGJlIHN0YWJsZS4gIElmIHRoYXQg
aXMNCmFjY2VwdGFibGUsIHRoZW4gdGhhdCdzIGZpbmUgdG9vLg0KDQpCdXQgaW4gdGhlIHBhdGNo
IDIzLCB5b3Ugd2lsbCB1cGRhdGUgdGhlIGRvYyBhbnl3YXksIHNvIEkgdGhpbmsgd2UgY2FuIGp1
c3QNCnByb3ZpZGUgdGhlIGxpbmsgdGhlcmUgKHlvdSBhbHJlYWR5IG1lbnRpb25lZCB0aGUgcmVw
byBsaW5rIHRoZXJlIGFueXdheSkuDQoNCj4gDQo+ID4gDQo+ID4gWy4uLl0NCj4gPiANCj4gPiA+
ICsvKg0KPiA+ID4gKyAqIEludGVsIFREWCBNb2R1bGUgYmxvYi4gSXRzIGZvcm1hdCBpcyBkZWZp
bmVkIGF0Og0KPiA+ID4gKyAqIGh0dHBzOi8vZ2l0aHViLmNvbS9pbnRlbC90ZHgtbW9kdWxlLWJp
bmFyaWVzL2Jsb2IvbWFpbi9ibG9iX3N0cnVjdHVyZS50eHQNCj4gDQo+IEkgd2lsbCBkcm9wIHRo
aXMgbGluayBhcyB3ZWxsLg0KPiANCg0KSSBhbSBmaW5lIGtlZXBpbmcgaXQgaGVyZS4gIFdlIG5l
ZWQgYSBsaW5rICJzb21ld2hlcmUgaW4gX3RoaXNfIHBhdGNoIiB0bw0KcmV2aWV3IHRoZSBjb2Rl
IEkgdGhpbmsuDQoNCkl0J3MgaW4gdGhlIGNvbW1lbnQgc28gd2UgY2FuIGNoYW5nZSBpbiB0aGUg
ZnV0dXJlIGlmIGl0IGNoYW5nZXMuDQo=

