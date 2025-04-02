Return-Path: <kvm+bounces-42428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 32D5BA785E0
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 02:53:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DAEBF16DA01
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 00:53:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 076ED9476;
	Wed,  2 Apr 2025 00:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OBZDGdkF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2198AEAF6;
	Wed,  2 Apr 2025 00:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743555194; cv=fail; b=iFkR6aKB02iIuBISHUByAi0zEPtTOLfgkUO+aMcz6rZTssaRVaGZAJAQE8g35EjMTnOdlsEFK+VoL4G5MFjeFTixIsHtK0uj1p5bZh8rv3ll3qmx2V5l2LryH3uPrgOVrCSDPOo+671O+U7n79gVWIHz8BUpwJ0wcgC7mdYvsww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743555194; c=relaxed/simple;
	bh=lU3UHBYXX0Ehx7JqaSTI50B56NLbKHkjneNHSvTYTWM=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=fu3pYlU9Eoy2orm3wkFkSFsLSAZA7geOeNUxL6m7Wdgj7RakwPkVAu4aNkol3+a5asLxbZWMLtEpwG76iOGb9Cd9rVgt7rK1asOyjPOkX6GV7pFNk6RKYDDLNUsvp1tb2ID39lu4q2L0iUrVdkB7/1uBf21QHbmsg4DcjtLCL44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OBZDGdkF; arc=fail smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1743555192; x=1775091192;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lU3UHBYXX0Ehx7JqaSTI50B56NLbKHkjneNHSvTYTWM=;
  b=OBZDGdkF83T8qMSDZuMakUfleemkU4ulRiZToGiCLEqmlbKesExUeK5c
   E1jJBIfWTBhG8slCJ3/f36JihaLZoWciqxHdkbpypTU9nY/Gi/6VpPlfu
   hHPZnJF+qswo+lcvW3GRuiKOpfHDb4Z+njPE0Ci4xJ1M5CXa1up3Yui0T
   LManSg84eRiNp4bLBJ5XLV1CcYnsLdK+awoCCUG309uHixU1cVahCM9VD
   +zyKVfXUYUtEeMUqD6vCQoqRmFO6+4sVopwKQfo5G+w8+oyVTShF4xRQh
   6Hezt5sZQrBG5IJan5M3o7yykxCzGRdn1uJNif4J/Kh7cgyJbglWX2+PP
   A==;
X-CSE-ConnectionGUID: b6O6v4uITk2vVdUVv+0soA==
X-CSE-MsgGUID: wItEQLc8S4+lwvapKRTlEQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11391"; a="45074020"
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="45074020"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:53:12 -0700
X-CSE-ConnectionGUID: zfcy8QqXR+a6sGL5tkJHLg==
X-CSE-MsgGUID: IgfDM3EhQS+tVWZY1R5EEg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,294,1736841600"; 
   d="scan'208";a="127060112"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa007.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2025 17:53:11 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.1544.14; Tue, 1 Apr 2025 17:53:10 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 1 Apr 2025 17:53:10 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 1 Apr 2025 17:53:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=YV0fG9JX25dj6u4By3j+jj47aseNHNVA1GSv6s0Ts4R/dXZ47fQS7Ykg8bWgZfw8TwUbmE6nYEgWu6u6v5H3Ml9BRlCcgmwtHjs25PGRHBFOd6xIphKDeUvmJ+IGwm0mfT9Nw2zLPBCv5csifWH5+8n4dZ3ezRquAOYgE4ENGPhoRS1QE19AovDMSxgT0na80lnp34APieHLdHiSN931Aep4oNChi9mwL0u9h5xqMQmQOjgLSH1LioViTHRWJTKacJZ+Nx4NQFINZxVwKwIUFKXupHDhRdVVaD16mmbIMiIChdMOzbewO9LK6nPjY3r78B9NSWMx+uhl/M4vQQvZ9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lU3UHBYXX0Ehx7JqaSTI50B56NLbKHkjneNHSvTYTWM=;
 b=gf+aNtwmXEk83QhDa+432TI32D3CnsNflbpJQ4tYjR6RSiXbEeZTkAwFYZ86JLFcfgyvHwjyhF7gn5DwB/V6usZDOr+ECJYG+PNZIM5LOxk8v40y84Jwn15LpTcnX30fpLCR0KaV1mGN99oy3y3ad+3wXs7nax0S5Ff2TvoISfvfczbqlSYlV16i7zXKm2QcNExWoK3rTFAXQk9ADc8tNPA/C8lVjXNbDPXxKr9muPPpzH2NdUvVeLz3FbXdsj+M7wyKbZCOIq0+T7VH1MKFsC8s9C6rRP9ESBMAtlojPoddJD0gorgia7+BlGqPyLZeLbPPu3IJuYFEXSJ2m0levQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MW3PR11MB4634.namprd11.prod.outlook.com (2603:10b6:303:54::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.44; Wed, 2 Apr
 2025 00:53:06 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8534.045; Wed, 2 Apr 2025
 00:53:06 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>
CC: "Gao, Chao" <chao.gao@intel.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "mikko.ylinen@linux.intel.com"
	<mikko.ylinen@linux.intel.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"Lindgren, Tony" <tony.lindgren@intel.com>, "Hunter, Adrian"
	<adrian.hunter@intel.com>, "Chatre, Reinette" <reinette.chatre@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Topic: [PATCH 1/2] KVM: TDX: Handle TDG.VP.VMCALL<GetQuote>
Thread-Index: AQHbo2Q+reE/k3eiXkm8HRe31hfG0LOPjGSA
Date: Wed, 2 Apr 2025 00:53:05 +0000
Message-ID: <40f3dcc964bfb5d922cf09ddf080d53c97d82273.camel@intel.com>
References: <20250402001557.173586-1-binbin.wu@linux.intel.com>
	 <20250402001557.173586-2-binbin.wu@linux.intel.com>
In-Reply-To: <20250402001557.173586-2-binbin.wu@linux.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MW3PR11MB4634:EE_
x-ms-office365-filtering-correlation-id: 37c6baa2-7560-4806-f9be-08dd7180babc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?THVqckFZcXNEbE9LV2JBUGRhK01Gb0NTLzIyMW1XOTAvdC9sWkdjNytCdm90?=
 =?utf-8?B?UnozTTdPeGhCc1NuSktYa1o1OVFIRmZ6SkV6c2NYM2JmcTdYdHJIejROWk42?=
 =?utf-8?B?aTZMa05acitoamV1WG10b08xOXQvV3F6ME5mWDdqOGlleEtqVUhaYWcwV2xr?=
 =?utf-8?B?S1M2UlRhSUp0MmRNdFo2elBiZVNoSDY2ZGZtWlg2a0VIdm93TEQwMWswUTNK?=
 =?utf-8?B?SFdDZFFmU1A1aU5JSTZsQXJMaURUMUZDSlJON2tSNEhWdEo0QWF2K1FFTlRJ?=
 =?utf-8?B?cWp4UGdmZUVNamllcU55bmN2Wjc0N0RwN0l4YUk5VHAvb2E5aGI4Rm1xOVJK?=
 =?utf-8?B?T0tYUzRUYW4zZWUrQ1B5NjU1Zzh0ZlVSVFBRcDMwYnlvalFFM3dJMW42TUpp?=
 =?utf-8?B?aHRPT0RzTVIyTzhabldmd2ttdDdTNzVnZ1Z3VzR0Ymo5bFFpVk5TZlhjWHlp?=
 =?utf-8?B?ZUlsd0N3dlpBandCbXBCNm5HK3VGc1B3eU95MUJ1YjJ2RUlVZG5JNlJtRCtN?=
 =?utf-8?B?Yk1XVGNnMHpiSDVMU2V2OThtQ0d0cUVjcGNLQjd3QmxzYmdwVkZNUE1sNlFK?=
 =?utf-8?B?ZjcyRFV2Rkljb0VvYStHZ291MGN5WXl3bzdUaDVNcWZ5YitBenFucWNoY0c2?=
 =?utf-8?B?Y0pUcmI3MlovY0U0NTFVRUZUL2hCSEg4V2VZR2VEcDZzWHpWZldXOW1tYmpq?=
 =?utf-8?B?ZTR5TmpreGliZG9vSW51cTUreFVJdDZ5L0RKcVVLMVNua3hSLytZaUhhT0Mr?=
 =?utf-8?B?ZU5kcnlxRWxFWWU2bWNuZGpBMDNXU2hmR21BbVAvTnpXRG4xUEZUbVRxb0FC?=
 =?utf-8?B?M3lDdmVhcElkZHcrU3VHRHFOSGwveEx6VmVsY0owcytRMXlTS2xrQUhIbTdS?=
 =?utf-8?B?MUl3cWozTWllYjN1NnNKTTR2c3JLWjVOYW56eVNpNk04VUwybDZVYmJZVFJz?=
 =?utf-8?B?UGV6b3gwMDVhTW1OdGw3cklhL1UwNUM3cFk0YXlPVXgwV1dxK3VXT2pQcTJY?=
 =?utf-8?B?anNmMm5TREtXWHJmYjl5WkRzUTFPdVkxcG5hK2J2K3dhVTB5aDhDRnB5WHE1?=
 =?utf-8?B?YXBvK09WWTk3QlhqNjJTdGRlWWpPbCtabE9yL3RrZXJFVStBQzZ6SXZvdDlo?=
 =?utf-8?B?d1pjakxLN0RnOTU3SitROTRPdmVBV1VhQ0tDc2crTlU1YkRtZTRUNkUzcFpG?=
 =?utf-8?B?T0Z2L0U5TWV1aUVjYW5jNy9rT1FKWHdranY1ZUlWYWhkUUJCRFZFY1dBL1RC?=
 =?utf-8?B?aTNnMDZ1UkpkbXM5NllMMWRTK0o4NlVQRjQ2Z2twdzlRbjMxMFgxY2NGZ0Fj?=
 =?utf-8?B?SzdZOFp3VnF1eVpLbDZsRVN4Vm1mVnU5VzVHNkFLelBnNTVNMFFQb01CVFF0?=
 =?utf-8?B?SVNyYWdxWHRXbGZyS2pEdjl1VEpRZ05lMzNjaCs1OW5vUllRTUxvaE16RVVT?=
 =?utf-8?B?K2NYWVhYNzAxcG94bW5zd293V2o2ZmF0emViUEdKRVpzdGN2OXZ1NkRhdWoz?=
 =?utf-8?B?SCt1Q2c2WGdCUzI3ODJVSURtYkdzMVR6SHRleGJwT21oVUlmQVJTU0FJb09Y?=
 =?utf-8?B?YndUc1l1dnVxWHdOakIwK1NrZjhJS3dQaUwvMU5DUkl1aVA5UXZKODZudUw4?=
 =?utf-8?B?SXNuSDkxdzNFQmUvRzduZ21GZGRyeGlqbUwxQk5YTFQ4SHNMYTMvWGtvYjhQ?=
 =?utf-8?B?TmlzUEhHYll4MGZUWXh3OTJzOFhjS3BWYXRTOXZ1aWpIOVJ1NjFPV1MxTVla?=
 =?utf-8?B?c0ZqSDNWQnk3SHhZOHk4MytCM04xY2NFNzRBRVlWZy9zcXFHd3NNalI4Y3cy?=
 =?utf-8?B?OGdzMTZYYVNxMXpBekdVMFo1YzhUbXFhUTZOOGpVZk1GZWZ3REYra2Iza1pz?=
 =?utf-8?B?MmNPM1h2RVlqTGdhdHNDZG9oaUN3UEF5azlKOTNsNWc4QTZZNjJOeEJyQWNr?=
 =?utf-8?B?Nzl2c2N3UmExOFp4Q215Y0NJcGdyaUJHMEQzelhEaVlIb0pYTFQ3YitVL0xv?=
 =?utf-8?B?KzRPVEltREVnPT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZUVxQkg0dmtOM3dhc2lXWTVERVNzSU5QMzJMMXdldXVHTWcrT0I3ejlDQ21F?=
 =?utf-8?B?UW5tTHNXSERNbHFoWmFCa0RraXNjN080eUZpZnorQnppazN3OFRuR3Q0ek8v?=
 =?utf-8?B?bnFkNzIvNDVkY1lXU1doeTNTWW82MStFOUhZOGxwQlpqMEZwdEVvVzR5SDIw?=
 =?utf-8?B?TjlhRm1DV2s3cWo0RkNER2tONTkxTFlvMFVhelBQOXlPOEJNMXA1VG1JN3Va?=
 =?utf-8?B?VVlkekV2SnpSQVhVTHlPY1diZWRTYUg3bU9rdWwvZFl2a2FVVW9IRDlUblZP?=
 =?utf-8?B?dmd2czdhZ0xNbkN6RXExMThTc2tOdENhWW14b2dZSnBVOUFlZ1lUK2tJUDNN?=
 =?utf-8?B?d0dXbVp1T1kyR3pMUzBsOUt0VlBKN3k0L0Vib2ZiTFdsRzEwMllCcFdaRXRT?=
 =?utf-8?B?TzIrSkRxOVJxdVgrOW5GNGxka1BORmZOZDhHWVREckI1c1ZuZXRTTVlWSzhj?=
 =?utf-8?B?UnBVelE0VUxDTjlPUzZuTkFxWk9ldDY3WmM5NEtuenBsTXo2VlJobWpNUW1M?=
 =?utf-8?B?RVRrTHpGZDlwekZlbWduTHNNcG5hWmVFTExVYnNSc0ExRmhVbS9oNTRRUElx?=
 =?utf-8?B?c0JnRitXOVdJdTFzb2JVUkZRR0YzZ1FiUWtvWjBqUnloSm9DUGRtU1lkMDNl?=
 =?utf-8?B?QnJMYTJzK2VLMjg0YnJja2FnTDBQS0hwL1loeUJvdWlGQmRudkhyNWhFUUJJ?=
 =?utf-8?B?TEpOWWNDVlVDNWhQd2IxejNVSWxjbTdxNHpVLzRwSGw3N08zYmhrcmhEaEs2?=
 =?utf-8?B?QjdCMGM0SDdzVS8vVktqeXMvS2RMb0JHcjNQUkxhWXNnUXRrVWIxTE1SV2Zl?=
 =?utf-8?B?MktRVkdQNEg0RFkwMXoyVndmTVQ2SW0wSWFKUStXM1NRbFVaNVdiT2krdjYw?=
 =?utf-8?B?SEgrUGhvZURGOGZ1YlFrc1ZVTStKaWIyUmVBaWdPV1lqYm5QM2FERHJRQzBk?=
 =?utf-8?B?ZHU2N1NmcjJNUzhIYnovV284SXN6TmtCYWJaUXZVQWhCZUVtMnVNK2VBcGhD?=
 =?utf-8?B?OGlCaFg4cVE2UXY2UDVySS9NdHZHclJieGRNa2xnNnZXNnphN1VZbjVETlFt?=
 =?utf-8?B?UmE1eFIxQStIVGFEdFZyRCsvbzRMbFBjdUxFb2w3N2Zva2dpT29IWG1UOHJG?=
 =?utf-8?B?aTNzV1grTlVWU0JBcUJRSEI2em1zLzc1d2tYZk5XRlB5V0RZaCsrUUw4VStM?=
 =?utf-8?B?bFl1ZnVwQ2MrY25lN1JPelphenE1NlJKWDFCcDAyb2pQaXA0cHFEd05aZ1dk?=
 =?utf-8?B?c2t4RDFjd0JDK2J2Y3B2Y2VaaDQ0Q1ZKL3NoSDhtRjc1YnJLcXZsd1phNyt6?=
 =?utf-8?B?eEV0SzFjNldxVEFtaEVzUXBVOGE2N2ZFTUprUGVDWUZMMmhuODF6QVFyUVB3?=
 =?utf-8?B?c242OVhYTHRSVlRES1dMN3pUNGllVCtORW1CNnNpUld5K2hFY0ROUHl4STc3?=
 =?utf-8?B?amZtMFZOcmRYUXNjdEdSSDdJa0h5T040N3V6bjRobytYT2NzMC96YjhOdWJR?=
 =?utf-8?B?THU1Sk1BcEFoWFdKenZHdWc3d3VYU3NhQkt2eGNNdG0yUmxsamQ3T0hkcmlz?=
 =?utf-8?B?UnRWbUxwQnhoVzZpWjlGYStzZk5pTWJXdHVGL3FucG91K3ZLWW5NWDdwSjQ0?=
 =?utf-8?B?MitSL01scjU0elhpUG41ak8wMjIvenQ2bmIza2EvWE9qWERSdWRXR24yMjNk?=
 =?utf-8?B?bVlpUW9QTU1HWjQxaXdvSmIrZ0JtMEtaSFNvdERaQms4dnAwQ0hTUUlMUVFk?=
 =?utf-8?B?amRrZkZWS1lrbVk2cUc4THBhWnBEbGVpSlByK3dReGVJcFZXd0RaUkhRdk1B?=
 =?utf-8?B?WVZHTmJ5N2Q5ejdVSGJHMjNQWTRpVFZWNlZubFNjWEx2Nnd1NmlJZm1peE1W?=
 =?utf-8?B?SFpFaVVVNXFrdkdCeVhQTWdoUkhOdzF4eUNBcXlyMVdXaTZUNVc1SGxnNU1h?=
 =?utf-8?B?a2gwbzB6TDFDVjhaelE2L0FxbzFyUUFYQkNQd0RraWNsOGRoZWJ3M0hwNVNo?=
 =?utf-8?B?RTdrM2o3Vnh5V0dHa2M2SjlteEQ0RzlNcEVDZlowOFBDeUUrRGw4b1U5Tytl?=
 =?utf-8?B?alZEU2ZYNnV4REdNUG1YTXJPaTZ6cWFpRkpudnVFUm9NeUF5U3FhQ2dsN0VG?=
 =?utf-8?B?S2dJbmIzb1Z4LzBiUElWcllibEpZcWJMSCtCNHZWZDN6VkxEbWdUS00yaGRM?=
 =?utf-8?B?bnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A604C44FB3AC854AAB23A855DD45AF00@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37c6baa2-7560-4806-f9be-08dd7180babc
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 00:53:05.9059
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1swL2DLKbIYFuhymlrmzQ5gLm6rsMEA4sS6/TRpr7xuj+LWP8t5UYFhWe5flAqrqNr55skqcTRlk4XAPHuu80g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4634
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA0LTAyIGF0IDA4OjE1ICswODAwLCBCaW5iaW4gV3Ugd3JvdGU6DQo+IEhh
bmRsZSBURFZNQ0FMTCBmb3IgR2V0UXVvdGUgdG8gZ2VuZXJhdGUgYSBURC1RdW90ZS4NCj4gDQo+
IEdldFF1b3RlIGlzIGEgZG9vcmJlbGwtbGlrZSBpbnRlcmZhY2UgdXNlZCBieSBURFggZ3Vlc3Rz
IHRvIHJlcXVlc3QgVk1NDQo+IHRvIGdlbmVyYXRlIGEgVEQtUXVvdGUgc2lnbmVkIGJ5IGEgc2Vy
dmljZSBob3N0aW5nIFRELVF1b3RpbmcgRW5jbGF2ZQ0KPiBvcGVyYXRpbmcgb24gdGhlIGhvc3Qu
ICBBIFREWCBndWVzdCBwYXNzZXMgYSBURCBSZXBvcnQgKFREUkVQT1JUX1NUUlVDVCkgaW4NCj4g
YSBzaGFyZWQtbWVtb3J5IGFyZWEgYXMgcGFyYW1ldGVyLiAgSG9zdCBWTU0gY2FuIGFjY2VzcyBp
dCBhbmQgcXVldWUgdGhlDQo+IG9wZXJhdGlvbiBmb3IgYSBzZXJ2aWNlIGhvc3RpbmcgVEQtUXVv
dGluZyBlbmNsYXZlLiAgV2hlbiBjb21wbGV0ZWQsIHRoZQ0KPiBRdW90ZSBpcyByZXR1cm5lZCB2
aWEgdGhlIHNhbWUgc2hhcmVkLW1lbW9yeSBhcmVhLg0KPiANCj4gS1ZNIGZvcndhcmRzIHRoZSBy
ZXF1ZXN0IHRvIHVzZXJzcGFjZSBWTU0gKGUuZy4sIFFFTVUpIGFuZCB1c2Vyc3BhY2UgVk1NDQo+
IHF1ZXVlcyB0aGUgb3BlcmF0aW9uIGFzeW5jaHJvbm91c2x5LiDCoA0KPiANCg0KSSB0aGluayB0
aGUga2V5IGlzIEdldFF1b3RlIGlzIGFzeW5jaHJvbm91cyB0aGVyZWZvcmUgS1ZNIHdpbGwgcmV0
dXJuIHRvIGd1ZXN0DQppbW1lZGlhdGVseSBhZnRlciBmb3J3YXJkaW5nIHRvIHVzZXJzcGFjZS4g
IFdoZXRoZXIgKnVzZXJzcGFjZSogcXVldWVzIHRoZQ0Kb3BlcmF0aW9uIGFzeW5jaHJvbm91c2x5
IGRvZXNuJ3QgbWF0dGVyLg0KDQo+IEFmdGVyIHRoZSBURFZNQ0FMTCBpcyByZXR1cm5lZCBhbmQN
Cj4gYmFjayB0byBURFggZ3Vlc3QsIFREWCBndWVzdCBjYW4gcG9sbCB0aGUgc3RhdHVzIGZpZWxk
IG9mIHRoZSBzaGFyZWQtbWVtb3J5DQo+IGFyZWEuDQoNCkhvdyBhYm91dCBjb21iaW5nIHRoZSBh
Ym92ZSB0d28gcGFyYWdyYXBocyBpbnRvOg0KDQpHZXRRdW90ZSBpcyBhbiBhc3luY2hyb25vdXMg
cmVxdWVzdC4gIEtWTSByZXR1cm5zIHRvIHVzZXJzcGFjZSBpbW1lZGlhdGVseSBhZnRlcg0KZm9y
d2FyZGluZyB0aGUgcmVxdWVzdCB0byB1c2Vyc3BhY2UuICBUaGUgVERYIGd1ZXN0IHRoZW4gbmVl
ZHMgdG8gcG9sbCB0aGUNCnN0YXR1cyBmaWVsZCBvZiB0aGUgc2hhcmVkIGJ1ZmZlciAob3Igd2Fp
dCBmb3Igbm90aWZpY2F0aW9uIGlmIGVuYWJsZWQpIHRvIHRlbGwNCndoZXRoZXIgdGhlIFF1b3Rl
IGlzIHJlYWR5Lg0KDQo+IA0KPiBBZGQgS1ZNX0VYSVRfVERYX0dFVF9RVU9URSBhcyBhIG5ldyBl
eGl0IHJlYXNvbiB0byB1c2Vyc3BhY2UgYW5kIGZvcndhcmQNCj4gdGhlIHJlcXVlc3QgYWZ0ZXIg
c29tZSBzYW5pdHkgY2hlY2tzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmluYmluIFd1IDxiaW5i
aW4ud3VAbGludXguaW50ZWwuY29tPg0KPiBUZXN0ZWQtYnk6IE1pa2tvIFlsaW5lbiA8bWlra28u
eWxpbmVuQGxpbnV4LmludGVsLmNvbT4NCj4gLS0tDQo+ICBEb2N1bWVudGF0aW9uL3ZpcnQva3Zt
L2FwaS5yc3QgfCAxOSArKysrKysrKysrKysrKysrKysNCj4gIGFyY2gveDg2L2t2bS92bXgvdGR4
LmMgICAgICAgICB8IDM1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4gIGlu
Y2x1ZGUvdWFwaS9saW51eC9rdm0uaCAgICAgICB8ICA3ICsrKysrKysNCj4gIDMgZmlsZXMgY2hh
bmdlZCwgNjEgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24v
dmlydC9rdm0vYXBpLnJzdCBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJzdA0KPiBpbmRl
eCBiNjEzNzFmNDVlNzguLjkwYWE3YTMyOGRjOCAxMDA2NDQNCj4gLS0tIGEvRG9jdW1lbnRhdGlv
bi92aXJ0L2t2bS9hcGkucnN0DQo+ICsrKyBiL0RvY3VtZW50YXRpb24vdmlydC9rdm0vYXBpLnJz
dA0KPiBAQCAtNzE2Miw2ICs3MTYyLDI1IEBAIFRoZSB2YWxpZCB2YWx1ZSBmb3IgJ2ZsYWdzJyBp
czoNCj4gICAgLSBLVk1fTk9USUZZX0NPTlRFWFRfSU5WQUxJRCAtLSB0aGUgVk0gY29udGV4dCBp
cyBjb3JydXB0ZWQgYW5kIG5vdCB2YWxpZA0KPiAgICAgIGluIFZNQ1MuIEl0IHdvdWxkIHJ1biBp
bnRvIHVua25vd24gcmVzdWx0IGlmIHJlc3VtZSB0aGUgdGFyZ2V0IFZNLg0KPiAgDQo+ICs6Og0K
PiArDQo+ICsJCS8qIEtWTV9FWElUX1REWF9HRVRfUVVPVEUgKi8NCj4gKwkJc3RydWN0IHRkeF9n
ZXRfcXVvdGUgew0KPiArCQkJX191NjQgcmV0Ow0KPiArCQkJX191NjQgZ3BhOw0KPiArCQkJX191
NjQgc2l6ZTsNCj4gKwkJfTsNCj4gKw0KPiArSWYgdGhlIGV4aXQgcmVhc29uIGlzIEtWTV9FWElU
X1REWF9HRVRfUVVPVEUsIHRoZW4gaXQgaW5kaWNhdGVzIHRoYXQgYSBURFgNCj4gK2d1ZXN0IGhh
cyByZXF1ZXN0ZWQgdG8gZ2VuZXJhdGUgYSBURC1RdW90ZSBzaWduZWQgYnkgYSBzZXJ2aWNlIGhv
c3RpbmcNCj4gK1RELVF1b3RpbmcgRW5jbGF2ZSBvcGVyYXRpbmcgb24gdGhlIGhvc3QuIFRoZSAn
Z3BhJyBmaWVsZCBhbmQgJ3NpemUnIHNwZWNpZnkNCj4gK3RoZSBndWVzdCBwaHlzaWNhbCBhZGRy
ZXNzIGFuZCBzaXplIG9mIGEgc2hhcmVkLW1lbW9yeSBidWZmZXIsIGluIHdoaWNoIHRoZQ0KPiAr
VERYIGd1ZXN0IHBhc3NlcyBhIFREIHJlcG9ydC7CoA0KPiANCg0KIlREIHJlcG9ydCIgLT4gIlRE
IFJlcG9ydCI/ICBUaGUgY2hhbmdlbG9nIHVzZXMgdGhlIGxhdHRlci4NCg0KPiBXaGVuIGNvbXBs
ZXRlZCwgdGhlIGdlbmVyYXRlZCBxdW90ZSBpcyByZXR1cm5lZA0KDQoicXVvdGUiIC0+ICJRdW90
ZSI/DQoNCj4gK3ZpYSB0aGUgc2FtZSBidWZmZXIuIFRoZSAncmV0JyBmaWVsZCByZXByZXNlbnRz
IHRoZSByZXR1cm4gdmFsdWUuwqANCj4gDQoNCnJldHVybiB2YWx1ZSBvZiB0aGUgR2V0UXVvdGUg
VERWTUNBTEw/DQoNCj4gVGhlIHVzZXJzcGFjZQ0KPiArc2hvdWxkIHVwZGF0ZSB0aGUgcmV0dXJu
IHZhbHVlIGJlZm9yZSByZXN1bWluZyB0aGUgdkNQVSBhY2NvcmRpbmcgdG8gVERYIEdIQ0kNCj4g
K3NwZWMuwqANCj4gDQoNCkkgZG9uJ3QgcXVpdGUgZm9sbG93LiAgV2h5IHVzZXJzcGFjZSBzaG91
bGQgInVwZGF0ZSIgdGhlIHJldHVybiB2YWx1ZT8NCg0KPiBJdCdzIGFuIGFzeW5jaHJvbm91cyBy
ZXF1ZXN0LiBBZnRlciB0aGUgVERWTUNBTEwgaXMgcmV0dXJuZWQgYW5kIGJhY2sgdG8NCj4gK1RE
WCBndWVzdCwgVERYIGd1ZXN0IGNhbiBwb2xsIHRoZSBzdGF0dXMgZmllbGQgb2YgdGhlIHNoYXJl
ZC1tZW1vcnkgYXJlYS4NCj4gKw0KPiAgOjoNCj4gIA0KPiAgCQkvKiBGaXggdGhlIHNpemUgb2Yg
dGhlIHVuaW9uLiAqLw0KPiBkaWZmIC0tZ2l0IGEvYXJjaC94ODYva3ZtL3ZteC90ZHguYyBiL2Fy
Y2gveDg2L2t2bS92bXgvdGR4LmMNCj4gaW5kZXggYjk1MmJjNjczMjcxLi41MzUyMDA0NDZjMjEg
MTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS92bXgvdGR4LmMNCj4gKysrIGIvYXJjaC94ODYv
a3ZtL3ZteC90ZHguYw0KPiBAQCAtMTQ2Myw2ICsxNDYzLDM5IEBAIHN0YXRpYyBpbnQgdGR4X2dl
dF90ZF92bV9jYWxsX2luZm8oc3RydWN0IGt2bV92Y3B1ICp2Y3B1KQ0KPiAgCXJldHVybiAxOw0K
PiAgfQ0KPiAgDQo+ICtzdGF0aWMgaW50IHRkeF9jb21wbGV0ZV9nZXRfcXVvdGUoc3RydWN0IGt2
bV92Y3B1ICp2Y3B1KQ0KPiArew0KPiArCXRkdm1jYWxsX3NldF9yZXR1cm5fY29kZSh2Y3B1LCB2
Y3B1LT5ydW4tPnRkeF9nZXRfcXVvdGUucmV0KTsNCj4gKwlyZXR1cm4gMTsNCj4gK30NCj4gKw0K
PiArc3RhdGljIGludCB0ZHhfZ2V0X3F1b3RlKHN0cnVjdCBrdm1fdmNwdSAqdmNwdSkNCj4gK3sN
Cj4gKwlzdHJ1Y3QgdmNwdV90ZHggKnRkeCA9IHRvX3RkeCh2Y3B1KTsNCj4gKw0KPiArCXU2NCBn
cGEgPSB0ZHgtPnZwX2VudGVyX2FyZ3MucjEyOw0KPiArCXU2NCBzaXplID0gdGR4LT52cF9lbnRl
cl9hcmdzLnIxMzsNCj4gKw0KPiArCS8qIFRoZSBidWZmZXIgbXVzdCBiZSBzaGFyZWQgbWVtb3J5
LiAqLw0KPiArCWlmICh2dF9pc190ZHhfcHJpdmF0ZV9ncGEodmNwdS0+a3ZtLCBncGEpIHx8IHNp
emUgPT0gMCkgew0KPiArCQl0ZHZtY2FsbF9zZXRfcmV0dXJuX2NvZGUodmNwdSwgVERWTUNBTExf
U1RBVFVTX0lOVkFMSURfT1BFUkFORCk7DQo+ICsJCXJldHVybiAxOw0KPiArCX0NCg0KSXQgaXMg
YSBsaXR0bGUgYml0IGNvbmZ1c2luZyBhYm91dCB0aGUgc2hhcmVkIGJ1ZmZlciBjaGVjayBoZXJl
LiAgVGhlcmUgYXJlIHR3bw0KcGVyc3BlY3RpdmVzIGhlcmU6DQoNCjEpIHRoZSBidWZmZXIgaGFz
IGFscmVhZHkgYmVlbiBjb252ZXJ0ZWQgdG8gc2hhcmVkLCBpLmUuLCB0aGUgYXR0cmlidXRlcyBh
cmUNCnN0b3JlZCBpbiB0aGUgWGFycmF5Lg0KMikgdGhlIEdQQSBwYXNzZWQgaW4gdGhlIEdldFF1
b3RlIG11c3QgaGF2ZSB0aGUgc2hhcmVkIGJpdCBzZXQuDQoNClRoZSBrZXkgaXMgd2UgbmVlZCAx
KSBoZXJlLiAgRnJvbSB0aGUgc3BlYywgd2UgbmVlZCB0aGUgMikgYXMgd2VsbCBiZWNhdXNlIGl0
DQoqc2VlbXMqIHRoYXQgdGhlIHNwZWMgcmVxdWlyZXMgR2V0UXVvdGUgdG8gcHJvdmlkZSB0aGUg
R1BBIHdpdGggc2hhcmVkIGJpdCBzZXQsDQphcyBpdCBzYXlzICJTaGFyZWQgR1BBIGFzIGlucHV0
Ii4gwqANCg0KVGhlIGFib3ZlIGNoZWNrIG9ubHkgZG9lcyAyKS4gIEkgdGhpbmsgd2UgbmVlZCB0
byBjaGVjayAxKSBhcyB3ZWxsLCBiZWNhdXNlIG9uY2UNCnlvdSBmb3J3YXJkIHRoaXMgR2V0UXVv
dGUgdG8gdXNlcnNwYWNlLCB1c2Vyc3BhY2UgaXMgYWJsZSB0byBhY2Nlc3MgaXQgZnJlZWx5Lg0K
DQpBcyBhIHJlc3VsdCwgdGhlIGNvbW1lbnQgDQoNCiAgLyogVGhlIGJ1ZmZlciBtdXN0IGJlIHNo
YXJlZCBtZW1vcnkuICovDQoNCnNob3VsZCBhbHNvIGJlIHVwZGF0ZWQgdG8gc29tZXRoaW5nIGxp
a2U6DQoNCiAgLyoNCiAgICogVGhlIGJ1ZmZlciBtdXN0IGJlIHNoYXJlZC4gR2V0UXVvdGUgcmVx
dWlyZXMgdGhlIEdQQSB0byBoYXZlDQogICAqIHNoYXJlZCBiaXQgc2V0Lg0KICAgKi8NCg0KPiAr
DQo+ICsJaWYgKCFQQUdFX0FMSUdORUQoZ3BhKSB8fCAhUEFHRV9BTElHTkVEKHNpemUpKSB7DQo+
ICsJCXRkdm1jYWxsX3NldF9yZXR1cm5fY29kZSh2Y3B1LCBURFZNQ0FMTF9TVEFUVVNfQUxJR05f
RVJST1IpOw0KPiArCQlyZXR1cm4gMTsNCj4gKwl9DQo+ICsNCj4gKwl2Y3B1LT5ydW4tPmV4aXRf
cmVhc29uID0gS1ZNX0VYSVRfVERYX0dFVF9RVU9URTsNCj4gKwl2Y3B1LT5ydW4tPnRkeF9nZXRf
cXVvdGUuZ3BhID0gZ3BhOw0KPiArCXZjcHUtPnJ1bi0+dGR4X2dldF9xdW90ZS5zaXplID0gc2l6
ZTsNCj4gKw0KPiArCXZjcHUtPmFyY2guY29tcGxldGVfdXNlcnNwYWNlX2lvID0gdGR4X2NvbXBs
ZXRlX2dldF9xdW90ZTsNCj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMg
aW50IGhhbmRsZV90ZHZtY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICB7DQo+ICAJc3dp
dGNoICh0ZHZtY2FsbF9sZWFmKHZjcHUpKSB7DQo+IEBAIC0xNDcyLDYgKzE1MDUsOCBAQCBzdGF0
aWMgaW50IGhhbmRsZV90ZHZtY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAJCXJldHVy
biB0ZHhfcmVwb3J0X2ZhdGFsX2Vycm9yKHZjcHUpOw0KPiAgCWNhc2UgVERWTUNBTExfR0VUX1RE
X1ZNX0NBTExfSU5GTzoNCj4gIAkJcmV0dXJuIHRkeF9nZXRfdGRfdm1fY2FsbF9pbmZvKHZjcHUp
Ow0KPiArCWNhc2UgVERWTUNBTExfR0VUX1FVT1RFOg0KPiArCQlyZXR1cm4gdGR4X2dldF9xdW90
ZSh2Y3B1KTsNCj4gIAlkZWZhdWx0Og0KPiAgCQlicmVhazsNCj4gIAl9DQo+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmggYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCj4g
aW5kZXggYzY5ODhlMmM2OGQ1Li5lY2E4NmI3ZjBjYmMgMTAwNjQ0DQo+IC0tLSBhL2luY2x1ZGUv
dWFwaS9saW51eC9rdm0uaA0KPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgva3ZtLmgNCj4gQEAg
LTE3OCw2ICsxNzgsNyBAQCBzdHJ1Y3Qga3ZtX3hlbl9leGl0IHsNCj4gICNkZWZpbmUgS1ZNX0VY
SVRfTk9USUZZICAgICAgICAgICAzNw0KPiAgI2RlZmluZSBLVk1fRVhJVF9MT09OR0FSQ0hfSU9D
U1IgIDM4DQo+ICAjZGVmaW5lIEtWTV9FWElUX01FTU9SWV9GQVVMVCAgICAgMzkNCj4gKyNkZWZp
bmUgS1ZNX0VYSVRfVERYX0dFVF9RVU9URSAgICA0MQ0KPiAgDQo+ICAvKiBGb3IgS1ZNX0VYSVRf
SU5URVJOQUxfRVJST1IgKi8NCj4gIC8qIEVtdWxhdGUgaW5zdHJ1Y3Rpb24gZmFpbGVkLiAqLw0K
PiBAQCAtNDQ3LDYgKzQ0OCwxMiBAQCBzdHJ1Y3Qga3ZtX3J1biB7DQo+ICAJCQlfX3U2NCBncGE7
DQo+ICAJCQlfX3U2NCBzaXplOw0KPiAgCQl9IG1lbW9yeV9mYXVsdDsNCj4gKwkJLyogS1ZNX0VY
SVRfVERYX0dFVF9RVU9URSAqLw0KPiArCQlzdHJ1Y3Qgew0KPiArCQkJX191NjQgcmV0Ow0KPiAr
CQkJX191NjQgZ3BhOw0KPiArCQkJX191NjQgc2l6ZTsNCj4gKwkJfSB0ZHhfZ2V0X3F1b3RlOw0K
PiAgCQkvKiBGaXggdGhlIHNpemUgb2YgdGhlIHVuaW9uLiAqLw0KPiAgCQljaGFyIHBhZGRpbmdb
MjU2XTsNCj4gIAl9Ow0KDQo=

