Return-Path: <kvm+bounces-61672-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id DA280C245ED
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 11:11:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 60EE934FE0D
	for <lists+kvm@lfdr.de>; Fri, 31 Oct 2025 10:11:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3FD233A010;
	Fri, 31 Oct 2025 10:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="W/WqGz6D"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5580334C34;
	Fri, 31 Oct 2025 10:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761905462; cv=fail; b=EQcRoAEpr2XBgM2+xKJhAQ9+qNXwPFcDe8FygcXkKJTxGy/IQYSmw3GfOnLVZhLd936Xz5fqJJQBr6CeikMg5M+Yh4smMal7x3yz6Ex+o68tyl9x4FY4MPcRSfUBPkD9CdOrEo0DiLgQM6EPEbD2XMG4CJMpV1IkM3FYBOzdqZQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761905462; c=relaxed/simple;
	bh=U+GcdRleVC6OlI1xJRSw+riyzcyblhZqDvSmu+dOcxk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Pa/Ee99yWhTvtfN0OFqAXEb+cHsv59arjRlcdHzswPj8qIKXrz7Htce8Ieqwl2qOq366dl3gPOP0nolfh4I72z9bXluG22YHBY/dnG3Y2zNJuf0k4WgFvTkvrsElss0mjzr3yFjdsndDAW3EHkePx1Uvjqa5N/unVtkygqVRoKw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=W/WqGz6D; arc=fail smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761905459; x=1793441459;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=U+GcdRleVC6OlI1xJRSw+riyzcyblhZqDvSmu+dOcxk=;
  b=W/WqGz6DwX2x+80Wyq7s/li3qKSJNO/qr8UNnrr+VnEnTGmWHWGNOXLb
   rPMydWT4UqKGLSOmvCDHTD8R4gDQqbATotG27RA2AmJKEJbuLWHgCvvPl
   hk9kFjqhOKxgk3KvLA2PE7S4MF3h4WVdhbZtzhkuD6y83JxSnXLW3q5NM
   sPNBHV2/lhUHYhN/awRaDShFCmk8XydkN7JfQ3svodeSdU8w2+fK2TyRK
   G8/LLxaSc1QCqUXibjKXuoelzTIoFhQvTe2CYGCkx2JBW4W90R94yP2dI
   tyXTtsNuWwdVCGUnOJsruVGqjfTsEsskImlFIP642v976BHaLBaBuspmA
   Q==;
X-CSE-ConnectionGUID: V2iGnt3ASS2TrIiVRn8cAw==
X-CSE-MsgGUID: Y12UmTp3TxmdzDBM97UEJw==
X-IronPort-AV: E=McAfee;i="6800,10657,11598"; a="66677906"
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="66677906"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 03:10:56 -0700
X-CSE-ConnectionGUID: bcQDCE9WTzyj1enqgzudCQ==
X-CSE-MsgGUID: riUPWyieRo6MsQSMuZ7KUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,269,1754982000"; 
   d="scan'208";a="191348641"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa005.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2025 03:10:55 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 03:10:55 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Fri, 31 Oct 2025 03:10:55 -0700
Received: from BL0PR03CU003.outbound.protection.outlook.com (52.101.53.69) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Fri, 31 Oct 2025 03:10:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=fpO3L1cVbRg1H8UyzZIDkB8LXPuc+3KC818ryS5TvQnEpKa3hSNzVtnWkpxOgAhcHoNBEHv8sANvuynn2v1wVbjasPcaHu1liQ1Vy+CeHB5DKe+HRHOHEVcC82KRHqcQlpZGLnomqvvzvhUDKWhByDUVMGxOE3xmwGBTsBZ6Z+X2HY3Qaws9W0YuGrAKqTCaR3JvTfAJeKDM43UkFnTXANzvsnWZ/abRHiPkzwtW3LxqnFYio5JAdGQXFZT+PAVtiS/+N+HHe7DdT6OJgeMsokEZXKZB90Jin6SOmMxLghTRXmxg+reknZchdiy+fQugVkzmusrEgL1BAUYhbP3btA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U+GcdRleVC6OlI1xJRSw+riyzcyblhZqDvSmu+dOcxk=;
 b=d2OdUhGYlN+1G0quyMyg7OOgr+2NdgB/G2YH/QnJ33vWHbYvzGTYuasEXL9D6SrU03Da+HowcLj53AqKp6E1b+pIyXt8hajadBKUxGC3i7xuMl/irL05wUcKMbFibj2TZCFI5zBoTq5bneadbuScj7D4zK3pzwk6sXRNsInuswxxMybICmegHkJHd5zawY0YO0ghLNwBYylk+aC6PrI3howytsgNfSoJjSL9ctIAeBr3lGH7LtxKXBEgrXnGKyMsh+chOW+VTynlGhpgB7Ot/2ARYDmRCaGUPcF7RtxT2lauallh7n5PgWJc6WNXFcwQPpB5bHhf0D/WCqoe9VXlOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA3PR11MB9158.namprd11.prod.outlook.com (2603:10b6:208:57d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9275.13; Fri, 31 Oct
 2025 10:10:53 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9275.013; Fri, 31 Oct 2025
 10:10:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled
 VM-Exits
Thread-Topic: [PATCH] KVM: x86: Add a helper to dedup reporting of unhandled
 VM-Exits
Thread-Index: AQHcSc4QHrBk6H+LAEizHpjRKKRKp7TcCacA
Date: Fri, 31 Oct 2025 10:10:53 +0000
Message-ID: <79757e164fce19095bef0ce84071ebc25f3e855d.camel@intel.com>
References: <20251030185004.3372256-1-seanjc@google.com>
In-Reply-To: <20251030185004.3372256-1-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA3PR11MB9158:EE_
x-ms-office365-filtering-correlation-id: 99ecaf49-68fb-4d8a-a426-08de1865c671
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?TzR5c3hkYTVnR2pYK2lvdnhEeFp6WHVDaVRiM0NlYk4xUzBidmp6OGV6bkcx?=
 =?utf-8?B?em5lbWNpdlFWdkVhWkRPa3VnOU1NbjkzRnFMd1loRFJGVXdCNmNuVzJIVG5n?=
 =?utf-8?B?ekMyYjJsd1NaZTJ4eEpMU2hPM01nMzNhRGdCSk52T3UzblloMS8zQllPNlQ4?=
 =?utf-8?B?OGh2dmJTcFJ6MWNoamJkWjVZR3BWcGcvTXJhWVJERDZ2ZGZOaTFsZmQ3bC80?=
 =?utf-8?B?SlhWUGdwMm8vRmR3dG1lOXYyNFBQbGx6cHV6dGNReWpIV2lSS3ZURDRPaEFR?=
 =?utf-8?B?M2dDL0lncVQzU0ZkRjNQSkJFanVLRk5tdUlqUXQyR0hjdFEzWS8zOFloaFdt?=
 =?utf-8?B?SDhNcVphc3d2VGdXaS9ubjZSeVEwY2NhcnFtV25ZM2h0b0R0NGlXUEdCR2E4?=
 =?utf-8?B?NnQ5dldVaHl5Wlp3Z3ZLT0M2enp4RUF0emJwcFpkMUhQbTFxeXFGQWRxZkJX?=
 =?utf-8?B?cy9lOHdLL0J5L3E4cnNpbFZ6dUd6bzVJdjdUTXV4T3p2MENVSGdLT0JlS1hE?=
 =?utf-8?B?bUNhdHkyN29sRGdJTVRRMC9IMHQ4bmFKZVpzMCsyclR0V3RBMGFCN3NESjdZ?=
 =?utf-8?B?Y1cvMHpVMDVKejF0eWtZVS81RWZqeEp1MG9ZYTNYSVYrYURxdkFvbS8rdmNW?=
 =?utf-8?B?RVJ1Q1JOS0luUnV0dFAzU1I0SzdMcitGZWdGeDEwd1VDdnJ5Zm9BS0VuemIz?=
 =?utf-8?B?NVBENjlLenZDTHRnNTVleEdyTTAvTVZLMjZyUkZPVGk5VGJucWJEVDRqaGNi?=
 =?utf-8?B?NHdydDV0c2NYUE1jKzJ4MjZPak1wM2MwZXlRdXM3Q0FnWTFhQTg2OFpJZzd1?=
 =?utf-8?B?RFVJOVV5QVFYcHRNd1FKbXpHUzBOa0dzZ0FjdUgrUkdKMGM1Y1p6SWFmRU5I?=
 =?utf-8?B?ZUtBaVE1ZmptSzMvTEpZNkcveDNlc0dZTjhuSC8rZy9aMTJ6YU1qZWpWeGQ1?=
 =?utf-8?B?VjhmMnM3aUpqdjc0aXNWQ1p1TGdUM0Qvb2tPd253T2hXdG9RT1oraWpldk5Z?=
 =?utf-8?B?alprLzk3OTFaNGswNWNaL0lLb1JaS2JqV0pBbks5K1BhU1ltaHJlNnFQWTRm?=
 =?utf-8?B?SjJXdTNlTWtVYUFoN1FWa0NCRkpUUUJpM0VTOERsNEY4VTJTZ3JVYkUvTnc5?=
 =?utf-8?B?YTNPSnJrRGlGSVZra2pyeFVMWERHNWxUYmF4dnE0dUcyaWhmeTBXY21YRkFP?=
 =?utf-8?B?RjBhN0wyMmV3R1M2aFBjT2oxUVFVcUlKeXk3eU81NVI4VWpEWlJrWjZNN2Nh?=
 =?utf-8?B?WXMwVXpVWUhlQU5aKzBORWtoZEFVVHkrMllMYmlGeVA5eVZGQVJBUXE1bmVD?=
 =?utf-8?B?QzNSS3RIS2dqK1pBUkxUNytuYUVsdTZBR1pJWllsT2tkU2JjaCtlSzhqWmdh?=
 =?utf-8?B?alpoYTlGNytGd0dLZzg0bTlNVFhTUUFIdktJRlZNZTN6VTlnQXpOdjlIRXJO?=
 =?utf-8?B?Qms3SEw2SGdXckt4SHNXQXR1UzZlU285S3hYUVh5TkpkMkpjNVE4M3hVbWFJ?=
 =?utf-8?B?d2FHMmREdnJxOTdBNTk5SlRjMEQvdzlTNjd4eTJ4UEpFSk8yWitsMUFXdVZq?=
 =?utf-8?B?T1lTR2lhLzl4eTRoS21HWTB4OTVYdGZCYWpsRHp6QlIzUit5MWVZOTdhYlg2?=
 =?utf-8?B?MU5sWmNEK2MvL2sreVVFTmM4ZHY4YWpmT1pnTVFZVFhLcWU5MDR6VVdKbmVu?=
 =?utf-8?B?cERoYXY5VFU4NjZEc3JCSEVCUDhrT2RrZG1rSFNVa05Vd3ptc2hyU3hsSXdJ?=
 =?utf-8?B?QzRqY3V5MXVKRSt3dksxMWpvR2xNVkdvRkFQaVNCYVZxQWpJTEs0OHQrZFpH?=
 =?utf-8?B?MnZGRFVoaS9pYzQ3MjJTUkxEV1NLQ2c3UC9hdlJPbCtmMUVCZkFGaFBzNzlL?=
 =?utf-8?B?TVl0blU2YVVvMUh1bUNaU2dRNlp1dm1Xc3ZTVXNqbm41elFONlo0UGhWOXZw?=
 =?utf-8?B?YkJJY2Q4bjNvUU1vUHAwQlRkcW1NQVdnQjZ6YVE0VDhHc3JONm5kZ1Z5bDhY?=
 =?utf-8?B?Y3krcHF5NDUrY0tVeGhueXErUEZWOTBXcFFUVnZ6SFY4Yi9mL1o4WjFkSjNz?=
 =?utf-8?Q?Zk1axN?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Snl4Mm0zWnJZTXZiNzJaaVVSeFE5bTBMWnlleURnWGlnTnZhNW02amlYZHdE?=
 =?utf-8?B?bUxoSmxJU0VsMElUWWlYbFlCc0w2QVl6VUpKdW9qUWtIc2FHODUvSERzQWdv?=
 =?utf-8?B?TU1laWVZYUM5WFllR0pkZWtrSWJyN1VURkljNE5ocUduSHZJZ1NMM1NxRnhS?=
 =?utf-8?B?akRBTWdGeVZsUFhhMndkVmc0cTQ4N1ZXeDAzRm83MWk2T0U2NUhtN0h2YnRV?=
 =?utf-8?B?QmpOaXNndkl4QXBJUG9vR0JIaWpNdlZSTExBV3kzRm85MVo2cmdNRlhiNFFY?=
 =?utf-8?B?eVdkcXdyUExUN2dwTGdENlJmM2c0djBVUlNGa0RuamNJK1FUNEVWU2JkK3FY?=
 =?utf-8?B?Yzc2a1lhR0MzM0xCeUpxb1VGVUZmYnZHT29aMi9tN1I4WFp3VmZ3TU00TllV?=
 =?utf-8?B?MTBKWGhyQmNKb044YlVzLzR2YXVRYnpLLzIrRFFwSENPSWNWRUtEdjBrQnM2?=
 =?utf-8?B?Y05GWXRHQXJDLytMalVybjErZTViRVdScFBSWm1BR1R6L0JBVU5zTUM3QUZC?=
 =?utf-8?B?NEVjNlBPWlp4RGxpalNCdWd4b3NhbXFWbEdRVzE2cTd2ZENlVEpJK0thZW51?=
 =?utf-8?B?Y3UwNlBnZ1B0aEVSUnUwaDBDRitVVFBxdTB0OWV4MDNIdFA2U1JlNUV3Q2Q3?=
 =?utf-8?B?WERqSTdNeFZISkVLMjlDNTdXRTBrNEt6RkRtMHRnbS9KeFdZb1dGQU1SdDNw?=
 =?utf-8?B?enQyWlV4TXYwT0RnenpZbFZMSi9XMTF4akN3cE5vTUh6ZXJVSzNwU3NMRklK?=
 =?utf-8?B?ay9zRmJBMzl6c3BhZHpzNUVRUnpFc2ZJclExV2lGVCtXeFMrY0djT1l5MEFv?=
 =?utf-8?B?UWVVU3ZFckM5ZjZLUmQweG1RS3l0a0ZGRHJtSyt0R0t0bjZvRVR5d2pjTUY4?=
 =?utf-8?B?RDMveW91SzdqQTlGTWZHLzA4T1YrWElJWUErTW1TZUlKTVNDbEhhYkxWWHB0?=
 =?utf-8?B?c29qcGdKSHVSS2tFbS91OGhPNG9EbGRYanJHNnZZK1U0QnY2cTRRdUg0VDJn?=
 =?utf-8?B?UldhaTdSSmg3UzBPdW82STVkWUQ4QXo4YUFNa1lNaVVnVFlXdDh3N09oelhx?=
 =?utf-8?B?SnpNalkvMU9LNTE2TGlmMFdqT05RS05kbnVyZVMvNEcyU0NOM0RpOXd2T1lq?=
 =?utf-8?B?cWkrQ3ZBaDZxaHA4VlJjQ2toMmdrRzBOR3JtU2crTVJBc3UwT3RyRkM5WXEr?=
 =?utf-8?B?eE5GNGR2MHRhNTQ5Q2pqeFVQRHE2QjRaUGwzdEVZWHkyLyt4UDFXbHdRN1dB?=
 =?utf-8?B?dGtyS0pET0RRTEkxTS9reFdybVlRYUYrbUZuR0poNm9EUVN4WmVCWURGVzE1?=
 =?utf-8?B?Zk9GUHVNRlRDeElYQ3Z6QTZsZy81WEQ3MUZXVUJuUTA4TEJoUEZhNnZrUXhD?=
 =?utf-8?B?Vi9ISzd5SW5YYUFkNWUwaUQ2RHZNSzRiOWxuTGNGMHZ5T0RIaXBycnNMZDhY?=
 =?utf-8?B?R2ticlFMaU05a1dpcDNpZStENjNxNmRCVy9TYXhodWxxeG83WitobjRxQWxv?=
 =?utf-8?B?aVlEaDQ5aVR4a29RU21LUktpdStXdUgyaDFsSHE1S2ViZmFjRVNmNVNaV0lG?=
 =?utf-8?B?YXVnSGZFV2h3YVUwbWdNM3Z3cjM1eVRFOGloM2FTOWhoc2p5SWlyZFZ2M0lG?=
 =?utf-8?B?dmpqRnJrU2RwTUJsMGhLSE13OThwbExlSCtGczRwSkpJdGZWMnBJZ2NRdWRk?=
 =?utf-8?B?SnZHeCtsc2oycXV3ZUd0R1B4NU0xQ2RLc3pZcVNEV0hRS0piKzVpTWRhT0FG?=
 =?utf-8?B?QkUyWVA4MmFsbGRBWTFqMGxBbFJoVDVReUx3MC8wZHNPY1hES1BHU0YxY1hm?=
 =?utf-8?B?RzhYekVYc0NZTitnTDRXRlh3cExtZEpuMk42NW90N0N4YnBtalIwY3NORm16?=
 =?utf-8?B?Z05YR0NONWtpN3VEM01UVUN2bnZDYXNnWUJZbkpnSEcrQkNkQXFDOGl3VFNt?=
 =?utf-8?B?NC9EbkptWit1OG05OWlNcGZQdS83aXJBWmo0TUtzRDB1K1k4MXNyU1czU2Ni?=
 =?utf-8?B?dTZKZXhDSi9WVXJ2ZXI2VGRSOUkvdTlraFRoTDdnaXlkZ0ZhOFlqNnpZbkgr?=
 =?utf-8?B?ZSsyeVFLYWY4d0g4WUozYWlTMzYwK0xUNENUVUU5bThGWDVxOS9kc2lEVGlk?=
 =?utf-8?B?ZzRLZjBqY3U0T3dhOFd3WnBIVjh5VDFaQURyNnR5VXJpWkIwbXA3eERGMGdm?=
 =?utf-8?B?TGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <68FC77D5A14BA749BB6D330F1922FDD4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 99ecaf49-68fb-4d8a-a426-08de1865c671
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2025 10:10:53.2967
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: whjnqKY7+Ml3Daet5gACLWonde2KrPSO3HdcdAh6au5Otc/loHr+QWBa4oZxfn0l0wSRF5I5UJhHgyBv2TokDg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA3PR11MB9158
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI1LTEwLTMwIGF0IDExOjUwIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBBZGQgYW5kIHVzZSBhIGhlbHBlciwga3ZtX3ByZXBhcmVfdW5leHBlY3RlZF9yZWFz
b25fZXhpdCgpLCB0byBkZWR1cCB0aGUNCj4gY29kZSB0aGF0IGZpbGxzIHRoZSBleGl0IHJlYXNv
biBhbmQgQ1BVIHdoZW4gS1ZNIGVuY291bnRlcnMgYSBWTS1FeGl0IHRoYXQNCj4gS1ZNIGRvZXNu
J3Qga25vdyBob3cgdG8gaGFuZGxlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogU2VhbiBDaHJpc3Rv
cGhlcnNvbiA8c2VhbmpjQGdvb2dsZS5jb20+DQo+IA0KDQpBY2tlZC1ieTogS2FpIEh1YW5nIDxr
YWkuaHVhbmdAaW50ZWwuY29tPg0K

