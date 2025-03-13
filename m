Return-Path: <kvm+bounces-40913-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 012F0A5F060
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 11:14:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2993017CD7B
	for <lists+kvm@lfdr.de>; Thu, 13 Mar 2025 10:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DE43264FBF;
	Thu, 13 Mar 2025 10:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fjOgfPH8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7911B261583;
	Thu, 13 Mar 2025 10:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741860860; cv=fail; b=CVc3lcLU04GwrzRUeZdI9vGoFSvHJ//xv2IlvuJSDVqrsFKVK3adCgmzCSxKuglFbdQwP/xfdpON0CSVx4H2ytmmRRaFSH+gM0H62AcDBTgGopx2qEsCKmDz76H7LaIx3/jYapgm19DOsS1AzQac9aC1w74z6i0CrCSGlvFZMhE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741860860; c=relaxed/simple;
	bh=xIwm0s7cOIxL2drL34UYAUIL1a8tI81Ja7YOTHKmB50=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oSf3eqIbbrlLG2TJjaQ24bF6umDHBjsOLAMMKV9ITjebaSFJfCxMGEylVEPxXBxp96bOFAPWFSVNxXplfUZ0A8i5jeBDyZXhGj45jGuk74Kid1Owug5n0dCSH4OjWVPyIU2VM4CBc4YjXck1jlzxKKqyHZUw8mZl/B3AcPLgWGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fjOgfPH8; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741860858; x=1773396858;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=xIwm0s7cOIxL2drL34UYAUIL1a8tI81Ja7YOTHKmB50=;
  b=fjOgfPH8QWZYh1ZGJpaofCWBz9RpiQPabrcwsF2neiwSB2DanqiYiABy
   ulUcSh6NP7tF1rAisDz1a3b/A/rU8tvvDpqW+fbMRYE18vy/rtpb4+zKj
   KrlBULN+UOiTqbC3/8l0OLCZ4oSoAS222jcc4og8sq0mQriWjg24zcmrr
   kZVqIu4kdAGqBseLKqTVqEbyZ4OLjEMw65JOkJLdO0OiwPl3363GD8BKA
   ArIqauPND7fhjzhqzeFofIi7hGKVVSzQBJt5rAQK/2+T9OuxCQ9GLhtDC
   mRbb6iaUVg1br+xi5ELIdx2fZxkccrZyuQxtHIpW1lpQC0F+DoJxi7Elw
   Q==;
X-CSE-ConnectionGUID: 1bDoN/yXQ0i2Xo3ZTCWg6Q==
X-CSE-MsgGUID: 0NzHUxDDSW6NTMGlmw9E6w==
X-IronPort-AV: E=McAfee;i="6700,10204,11371"; a="53963670"
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="53963670"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 03:14:17 -0700
X-CSE-ConnectionGUID: i4sSIfqpTkO4SKU6ZydxrA==
X-CSE-MsgGUID: EYm/Bx9iRhqAI2rDxXpygQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,244,1736841600"; 
   d="scan'208";a="121832761"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa008.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Mar 2025 03:14:17 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 13 Mar 2025 03:14:16 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 13 Mar 2025 03:14:16 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 13 Mar 2025 03:14:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sSWyDuadNt4783LveB1b4bkwgseHCwN6vARDYXdfD813LtJPaEkBi7D5JNHJ9r/rAXhq1jpxJd1y4I4bmKuhlN3LgVaJSvql50mPMxK/Sc4PbtH9Wlh9NUN4JRPNomK1+FKd3yx1ZP0ustf0VZcF0e99/fAN0pK/mxKXg8HeMv3wYW79zw8bfS4MgZCy7AH8PEuDGylH8B0H2Gp7H4RkzZKrKr2AyOfIzOZs04akdmV9xbFK8PqIPdbSkqVeLN7ZZ1E3fTIWpIvycBeQP81lRYmanQBTu/fdMPcd9cilJe7KgfIg9FBpQkHjKdOSKV11+Vjwz73V8bUfJ+H7hVN2NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xIwm0s7cOIxL2drL34UYAUIL1a8tI81Ja7YOTHKmB50=;
 b=sd7xPhs+5oycGMeruX0PHjnZ035Laic1WYj3RcNwYIXQvan0pZPpsoECPr+nmWaqHEgjl7kAtK8Kv7S5yNqhDNyF3MsAKpDCiNmkDXK9fZ7asPmL1Gu+pN6NToLMhVUPBV+6Dt9C6dRwPwfZRBVq7/XNzDgVqYnHYmiCGipIp+X++uxd7egA3sGfcLrg0fPl8nHRh4R9nHtoCi4wozH9pCNHfGjnbhCZphrVPvD1m0Tu7L8q/l0g5alE38yX+upxwrj7e9KV727A+uft9WSPx0QUJtdP1GgBYD779T3uYkN5D/6uWUPbYqQSqxD8N0kKa31nayUsrHmiNlD25lQjdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by CH3PR11MB7391.namprd11.prod.outlook.com (2603:10b6:610:151::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.28; Thu, 13 Mar
 2025 10:13:54 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%6]) with mapi id 15.20.8511.026; Thu, 13 Mar 2025
 10:13:53 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "tglx@linutronix.de" <tglx@linutronix.de>, "x86@kernel.org"
	<x86@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>
CC: "szy0127@sjtu.edu.cn" <szy0127@sjtu.edu.cn>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhang,
 Mingwei" <mizhang@google.com>, "kevinloughlin@google.com"
	<kevinloughlin@google.com>
Subject: Re: [PATCH 3/7] x86, lib: Add WBNOINVD helper functions
Thread-Topic: [PATCH 3/7] x86, lib: Add WBNOINVD helper functions
Thread-Index: AQHbiLpczdF4IZzJl0KbxlGfpndoHrNw78eA
Date: Thu, 13 Mar 2025 10:13:53 +0000
Message-ID: <71fb365773bdc6a38120f81c1177cb27cd2bb914.camel@intel.com>
References: <20250227014858.3244505-1-seanjc@google.com>
	 <20250227014858.3244505-4-seanjc@google.com>
In-Reply-To: <20250227014858.3244505-4-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.54.3 (3.54.3-1.fc41) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|CH3PR11MB7391:EE_
x-ms-office365-filtering-correlation-id: b8d8cc59-9dfb-4452-e8c3-08dd6217c241
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?azc3UU5aNTB1dGFVenF1eTM2R05ESFo5SFJYekNEU1pPWFhjekkvTWlRRGUw?=
 =?utf-8?B?aVJVaUtmM0Z5aUxUUmUyRHBEcE80NjV0MzJieXJOQUhBbFVnYkdPRXNac1hR?=
 =?utf-8?B?Sk9SUC9BNFhoYTFQZ2Nub3MrSVFZMXJoKzVoeWsrRzRrK1BBb1FLNU05WENW?=
 =?utf-8?B?cno1V0g2NVdjeU8ySERJTGpSRlprTndqTXlpN2t3Y0lENWo3MHI2dTN0eTBD?=
 =?utf-8?B?bE1Lc0N6TU1XQ3lXa0hlMHBybVpUSi95ZTZwcmZmUVFlZmFtMHhWK1A2Q1Zv?=
 =?utf-8?B?eG4zeFk3ZXhGUU5oa0pVeGJMYlY5cFc2eUwvWUpZeTdaNXZXQXVRRm5lWXVv?=
 =?utf-8?B?MHBhYnVWTmdOKzBaNzI1dzh3WU9rZHprQVBjRCtTVkFqVG1rM2xoUGVjWm5E?=
 =?utf-8?B?RUFPRHVkaVlJQUZTbkh0VjBZQmRUajNJMmR0VGpFVWpadWFYTUFxS0FhREw0?=
 =?utf-8?B?UEMwWnk2amY2bXVFTGhNOWhqcE9PTDVWUUx6Sys3TWd1QW9Ydmp0VG02VVNW?=
 =?utf-8?B?SitObkZNRm5sa21xejVqbjlnYzFMY1JLZjE5TVZEVmRwUHhtMGYzNHJBZFdJ?=
 =?utf-8?B?c2M2bG1RLzYwNWhVaHBUWUJIOTVuMHRBK1FxTXdGZmV4YkxUclJ4VFpCVExD?=
 =?utf-8?B?Q2t1enkwT1NZOTZNeWRTcG82YUNiSXFCNzFwU3kwRGNBY0pGWEs5K3lhamZB?=
 =?utf-8?B?L2ZxQzN0eXp5SFdpUEhNUnFQazViVTA2aDlxT2pFR0hobC94Vmh6Vm8rVy9D?=
 =?utf-8?B?K21uVFhMamQ1a0VLcDY5K3VBOFVBYmxCYmZDZlJlZ0todXErUVRNcURaUGM2?=
 =?utf-8?B?Q2pLakxXSHc4RFAzTHB3YXRLaW13SkN5d0NKdVMzbVJrZGtIbk1ubHNzMGha?=
 =?utf-8?B?WnFXVWJUWW1YVW9jVXE5Yk9RdkRuZVY3aUVSWXBSOC9hSTZnSkxCRXFhU28x?=
 =?utf-8?B?ZXdQQnNRbS91b0xZelBaS3llTkxkU2ticlZWSzZGSGFxZys4UGc2NTJxNlM1?=
 =?utf-8?B?Wk5Cem5JRVZSRmd5UHh0Z3JsWEorbHczVkIyZ1dMM1lwb2d1VVcvSFdjYlNP?=
 =?utf-8?B?cGhFNVp6MS9Xd2NwZ1g5N2tJME9MbHFsbGJrRmN2ZTAyTDRNRWZJaGlUSGR6?=
 =?utf-8?B?aXk3aFFpaWc1SytFUzBOYXFkYjBHYU5wSmNITlZlcEZtYWI3NnZpODhxQkdQ?=
 =?utf-8?B?TGgyS1dsZzZhdFYxbmhhQXY5UFVUS1RkZEFGWTdMZjE4bjN4Q1RaMjQzY1Zq?=
 =?utf-8?B?NjZIa0ZOdkU2K2FRQkE4aHRiMlRkK3hrQnBhV2xaMStWZ1dMbjhET0YveXFD?=
 =?utf-8?B?TTZBZWxESE1pOWdoeFNJTUVMM20zczlqeHJKVHF2MFJFcmRRcHhsNHR2QWhw?=
 =?utf-8?B?UXo1UmlEWUpRMDc0RUlOelN2TEltNHZZRnRDTWwrMys3UlEzai9CNnc1WkVD?=
 =?utf-8?B?M3FKdmZOeXIyQ2JwTGI4YXJNbHQ1YTlldTB3TVZ3VVBQUy9IeGp0RXBaTjc3?=
 =?utf-8?B?MlhJcGFML0tDR09Ib2RBaDFOVlFvaFVqc3hRUFJBbGdyUzIyMHFZRUVkRGYv?=
 =?utf-8?B?bUROZDlDcTN5c2dsSDFNMlhCVHc1bStTREdIeUVHbHlFYlpkZUNpLzhlM3Za?=
 =?utf-8?B?N0Q2ZmEyUEtpdjliOUVLcXVueTNGYkIvcmJVNmF0RVBWOFJxRm53YVVESTN2?=
 =?utf-8?B?QXIzb3FISjJRN2UrTm5OQllENzZsZzJqbUVlcmx1T1k1STdObnQ3dGpkek9r?=
 =?utf-8?B?LzVhWEZzWStyellDUTQ2ZEpHS2F5R2ptbkdxRUZyNkhxOUN4TDdldWF4SkZI?=
 =?utf-8?B?WXZLano0SkswWG1SZ3cycjBQQ1hLYlE5d3BnMk05dVBWRXZHbDlBb05VQ0VF?=
 =?utf-8?B?SkloVHgzWk16aXFXYklRaDdZNjBMWnRNZGV2SnVlN280aG8wMjhFL3hLWHYx?=
 =?utf-8?Q?9WyYHDjzaXLht9LGBK5dTcAk08y1v1TW?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eWR1bGZ3bkhpQjhOdVJmY2NoZ2V5ajBXMVRzWnBXM2hra1pCZGc4YWplYU9L?=
 =?utf-8?B?bU1zNW9wWEZSVjZTS21neUNWbmFRbjF2K2UrLzZhYjJ1aE9LSEgxQkJOUEdr?=
 =?utf-8?B?UzJOeFl6RlpHVmlYWjJ4czhFa1hNNGhoWGh2c3JrUkczRDdIeW5qZVc1ejB1?=
 =?utf-8?B?QmM1QktNVVJGc2hGWUJDN1RCSENESW8xVzFVdUFVejgyeTVDQkhPSGhWVUJP?=
 =?utf-8?B?dHBRdDFWbjNYb2h6NlZnam5iM0t1aEJBOHpPdHFoMC9BT0hsVHB1bHBwV3lG?=
 =?utf-8?B?bWljUFJQQVkydHFFMkdzMlloOFFSUmUvMk82dDJUZUFaWlVHMUlnZTk1QXd5?=
 =?utf-8?B?Y09mN1h0R1Z1RFlkT2xxcUgzcVVHaTJaeEpzREVrVzVqTWwxYWozZHpYcVZx?=
 =?utf-8?B?LzJLZ3BKb3pzUFhSVmdzVlZ6ajdVc1o5M2VOTGtnZUFxdVNTaDdVSWNTZzB5?=
 =?utf-8?B?Y2p2Q1IzV2c3Rm1wTWV2ZEtYWUFyL01LdVFUQjdyc0NjR09VMHMyY1N5aGE0?=
 =?utf-8?B?eG5mc3VvVk5ZYkJxcGN0MHBnSUtaQzNDc0RXTENIMVFJeTdmZ0JFWi9pcXNv?=
 =?utf-8?B?ZThuQXNvRnIrTEUySVR3MFRETGNNaWxSc3JvaWJjb2U5VEtYNmJMSCtZZWxF?=
 =?utf-8?B?SUo0U0tablpvYXVjbElFNks4MU00SUpuNUlUQ0pVQVdkVlhaS3ovV1NZaHQv?=
 =?utf-8?B?TmNzN3dyVG1kN2lYeTBxKzdLcjJoN05odjZrUGhhdDR4R215WHpWZlExM0J2?=
 =?utf-8?B?OWVrZlYzRHFFUU1xVjlkOTJsNWN1dmkwMzNKSkU4L1JMRm5XL3VOMjlpS2ZB?=
 =?utf-8?B?dzhDTUk0Nkp3alQ1MGxhcjJhbG53NjVFNmFKNmxxZDBHcGczSGdXOTZGeVhF?=
 =?utf-8?B?VUt2eHkwcC9uN2VDUnRJNXFWWnRkOThCcEtwU2M4OCsxVGJabE9TTzZvUFlI?=
 =?utf-8?B?M1VmcERaMFNZQWJsdTdTcWdzMzFvWmZkay83bURSTWZsWVRnV2pMNVpvbkVu?=
 =?utf-8?B?S1AzMUdrNlZxRmJxM0w0dklFRFFBYXh1bUJOR05SQmdjOXFPQm9hMjczRXJO?=
 =?utf-8?B?dVh5YnZRcjQ3WGtnN1lWTk9lVDhDQTEyMlYyRmhZS0RzbjdXek9kMnp0Nnlj?=
 =?utf-8?B?SUVNa3IzNm44NWtkWEJ4WDA3cldXRFljSFhVbFQ5WFNIQTlHZG9qQzFIK1Nz?=
 =?utf-8?B?d1AxRGtJWml5RFNNZFhvOTdycXh3OFpyV0JmY2U4WW9XWWtTTkRocFA3TXhr?=
 =?utf-8?B?RXM2eE5sRG9WOTVXQlpOak5leDdpZFYveDFyUFphSnYwRGdHMWRTU3RVVzZj?=
 =?utf-8?B?SjNGSDZycEViM1Zhd2c5VWpUWWpTRjFyVERmVTdIUmFVTkU3QzBVNWVibmRa?=
 =?utf-8?B?dkNVU2ZSQXoxVGwwRWkrdUZmU2orYThKZXBBMjd0Wmcyb0dCTWJmaFowbG4w?=
 =?utf-8?B?VjZLZU5QWE93TDl6Z0VEclhkNXZTK0tCTEFTWUNDNC9VQm5jdlFjOTdzeTdw?=
 =?utf-8?B?MW5jNlg1QzNPQS80N0dPdTM1cHBFWGVYU1l2eEtKczhvVzNNU1k1bnFQR1h4?=
 =?utf-8?B?aisxclRCNzV2R0drb1JNQ1B3ZmZlTENYSEJnL3h6WDRPMUNzWUNYVEI5ZlQ2?=
 =?utf-8?B?OU1qS2tweTIwQW5HNVZtejBiVSt5eHN2N3lBSjI1bVJoa0h0bWVHeDJxUU9z?=
 =?utf-8?B?TlF1NjNPMVg2MkNiSk5WVmZsamszVVl3YUpOajNnVVpWdytOVW9Ka1d2dTZ3?=
 =?utf-8?B?eUZPUDVURjlGbTlSY0NwaFBSd1JYbmZLTmJJNWNEbDBwd0JWSXRHMFdMWm9C?=
 =?utf-8?B?anpXcHh1ZTBaVjZ5WnR6WXBOTW16TVFEK1o5akJKZnByWi9lZGxlMUFVMTNQ?=
 =?utf-8?B?ZWp1WnNVRlVDMVJxcmM1YXNZbW56aEl0UHJCN3h6c1BzRjJuQUl4SC9DZ1Ex?=
 =?utf-8?B?aS9SeWVyMlFwUHBRbnd1VGlNK3lyNTVxUTM2c2V3RXFPcEVFcUNQbHRmcVJ1?=
 =?utf-8?B?cUFacmlvK1lydkxtcHpkNVp2S056ZU95Nm0wZ1FuRXdLRktpTVVGZXdXdUd3?=
 =?utf-8?B?WjdZVVp0dXdtWnB4QlpQUTNYQzdJdlZRQWd5Y2tYcC94VmFxbFNucFdkWGt1?=
 =?utf-8?Q?a206KOUtF0bVYvO+xJvBMygei?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F45687FD77B05943A58A2007E7E2B605@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8d8cc59-9dfb-4452-e8c3-08dd6217c241
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2025 10:13:53.8776
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KI9gDNSyXDf8wMbDEfN5N3t8giNrYb9bqp/53tF4uaHDN8WxWcFVTdmQ3vSa8/EnlrdIF9KvbiL0kLsboQgFsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7391
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAyLTI2IGF0IDE3OjQ4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBLZXZpbiBMb3VnaGxpbiA8a2V2aW5sb3VnaGxpbkBnb29nbGUuY29tPg0K
PiANCj4gSW4gbGluZSB3aXRoIFdCSU5WRCB1c2FnZSwgYWRkIFdCT05JTlZEIGhlbHBlciBmdW5j
dGlvbnMuICBGYWxsIGJhY2sgdG8NCj4gV0JJTlZEICh2aWEgYWx0ZXJuYXRpdmUoKSkgaWYgV0JO
T0lOVkQgaXNuJ3Qgc3VwcG9ydGVkLCBhcyBXQklOVkQgcHJvdmlkZXMNCj4gYSBzdXBlcnNldCBv
ZiBmdW5jdGlvbmFsaXR5LCBqdXN0IG1vcmUgc2xvd2x5Lg0KPiANCj4gTm90ZSwgYWx0ZXJuYXRp
dmUoKSBlbnN1cmVzIGNvbXBhdGliaWxpdHkgd2l0aCBlYXJseSBib290IGNvZGUgYXMgbmVlZGVk
Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTogS2V2aW4gTG91Z2hsaW4gPGtldmlubG91Z2hsaW5AZ29v
Z2xlLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFRvbSBMZW5kYWNreSA8dGhvbWFzLmxlbmRhY2t5QGFt
ZC5jb20+DQo+IFtzZWFuOiBtYXNzYWdlIGNoYW5nZWxvZyBhbmQgY29tbWVudHMsIHVzZSBBU01f
V0JOT0lOVkQgYW5kIF9BU01fQllURVNdDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3Bo
ZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogS2FpIEh1YW5nIDxrYWku
aHVhbmdAaW50ZWwuY29tPg0KDQpbLi4uXQ0KDQo+ICBzdGF0aWMgX19hbHdheXNfaW5saW5lIHZv
aWQgd2JpbnZkKHZvaWQpDQo+ICB7DQo+IC0JYXNtIHZvbGF0aWxlKCJ3YmludmQiOiA6IDoibWVt
b3J5Iik7DQo+ICsJYXNtIHZvbGF0aWxlKCJ3YmludmQiIDogOiA6ICJtZW1vcnkiKTsNCj4gK30N
Cj4gDQoNCk5pdDogdGhpcyBpcyBub3QgcmVsYXRlZCwgdGhvdWdoLg0K

