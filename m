Return-Path: <kvm+bounces-33899-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C05F9F4074
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 03:16:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 555067A2FDC
	for <lists+kvm@lfdr.de>; Tue, 17 Dec 2024 02:16:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74DCD13AA31;
	Tue, 17 Dec 2024 02:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dQOwK9er"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF8F8F9FE;
	Tue, 17 Dec 2024 02:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734401792; cv=fail; b=bsnQ9oxWpEOTp4C+PZqGxEXw3IZgGEHsuHrw/d1CtyznUh4uMyUJGCoHUUq47PS07rJl219PwmElOw3ec4U9fiQnx6veEVcQjHY/odISRQ0kpe62Tsvo4SIvDgV+Q6zdcrjV9lP3dDH9FYjOck+6QoI1G0r/tCx5y6PeEJcJF/M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734401792; c=relaxed/simple;
	bh=lyxYGj29oSp5iUOOnsWPc2DGsL3t3z9eoUONc9e/lc4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YyMMkdWFSQal3PqmhT90CiXdj6DlLTE+x/nNRUKms283/kgfHtUFgfN3dCjoFKQgSEzzg+t0La5+EbsCZAmmZMzO6U/hxX1ZPczeKrpKNo5w1nBrAQED4AtRGr9pZ0NBGE/H5p3E+7iQcvmqfsCwyE3iVlOFjY7ARtUk/95XqDM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dQOwK9er; arc=fail smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1734401790; x=1765937790;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=lyxYGj29oSp5iUOOnsWPc2DGsL3t3z9eoUONc9e/lc4=;
  b=dQOwK9erdwnBeR1xgzjYfgBIs9O41wI5WdItiZnna4ySJjkgjzMHRJM/
   Ef+jFR7lnga6GdjqwIXgRv8pLXbWZRTTICfzPwAcRamCmSsuyq5jvBD6+
   +3QpO80XSWIotwllqXNw6Czpnv45N38vK3EdkIFe4m3QjXrqDWnv9yMr4
   hbqUFZEu4/Q4XxYUCQd7RtMRYdbpk1pGnwnwSxFQh1oYPWlJ8QDyIFK8v
   MUlt0nu+3yPLbEzpmub9FgxMll17k4OJpCKrmmSpOlp+tfZHHyDVx+FlQ
   3laW9pou4PREp2PUaxOQBkohRpshmSOLYPqzf1vdYaP54Yrk8L+l2JOkW
   w==;
X-CSE-ConnectionGUID: FIMR1MqSQzSTFEyboeBi3A==
X-CSE-MsgGUID: tn/16HpxT2OIzZzDRp1PBA==
X-IronPort-AV: E=McAfee;i="6700,10204,11288"; a="34846423"
X-IronPort-AV: E=Sophos;i="6.12,240,1728975600"; 
   d="scan'208";a="34846423"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2024 18:16:30 -0800
X-CSE-ConnectionGUID: lObyTHGYSdqcUxm6a3EtzQ==
X-CSE-MsgGUID: J7XhCczNSxCSqb8UYL7Ung==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,240,1728975600"; 
   d="scan'208";a="102418961"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 16 Dec 2024 18:16:31 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Mon, 16 Dec 2024 18:16:29 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Mon, 16 Dec 2024 18:16:29 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Mon, 16 Dec 2024 18:16:29 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Xz8iBJAcPGDci4r8nSfoF7i9UeRBfEtrnsIYeIeVvFV6N3fadfMa/3yx9Wfjv70GzKM5Uri1LlVvB6Qg8GMHNEk5GerNsBT/j+oUaICN7N7FfPQqfh2cnbq9g44gIoouvx00JYuaPJglC8OsAHUdbM76m0tLMZT1bXc4SyW3Fswy5RXB6zGAF3oVJKUfsQxpEPJ0VtB2kTBySzL379mv+CzfkU42hzoQM6HRsSwy1qGbpwqnBUDldmK8rSEZ5Ox58y/vnFw5rqOeeZMsLftvMpKlt6Pw5DUyP9ni64jOYNojSx7vizKRkco6n6AuMLHgRWSMS+bWYss/NXhOto0gSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lyxYGj29oSp5iUOOnsWPc2DGsL3t3z9eoUONc9e/lc4=;
 b=qJBa1ayhgrtu3zNxpl371kQJ3Z4FXB+JQFU+TOAZw9OnsXYADMNviLDggjCUpk4LsBncBv9qarGX90xZJMgtV1UufbIE/2jwtTEtYZZcpRfpQhnKsVqZHmBQNwj6xFAw5KKjv/QX64mr9TGatMx7Ldv1s633+snBS5T26RHatT69pmbu/f1mq3xk15Stdhgt91D2Eu3/K49SuELULCK/kpYGwLPy456W4mPGnh7Mlmdo9Q1t5HiGkHnrk9wJT34PMWNVh7Wjn28On4iCJmuIZyhqO1sSHe+JqpqvnedrAl2T5JgUDyIiLBrnP3gqWlS3BnU9KdQcz21u2pDuHDj4Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by SA1PR11MB8255.namprd11.prod.outlook.com (2603:10b6:806:252::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8251.21; Tue, 17 Dec
 2024 02:16:08 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%3]) with mapi id 15.20.8251.015; Tue, 17 Dec 2024
 02:16:08 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "seanjc@google.com"
	<seanjc@google.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2024.12.17 *** On Tuesday the 17th!!!
 ***
Thread-Topic: [ANNOUNCE] PUCK Agenda - 2024.12.17 *** On Tuesday the 17th!!!
 ***
Thread-Index: AQHbUCmivvqoYTmb5E+CH8VvRfsE1w==
Date: Tue, 17 Dec 2024 02:16:08 +0000
Message-ID: <446cab39966cad7fc4d1824fa81d2ba25b125e69.camel@intel.com>
References: <20241213235821.2270353-1-seanjc@google.com>
	 <Z2DMtr3jdLK9cg34@google.com>
In-Reply-To: <Z2DMtr3jdLK9cg34@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|SA1PR11MB8255:EE_
x-ms-office365-filtering-correlation-id: 7f7c80fd-8a70-44d9-18b2-08dd1e40c4bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?SSs4MWZyemdPUUlTMTJDSm1uSnBtS0FVZHRMaUNLOEZNbDY5U3hBMlE5aitx?=
 =?utf-8?B?WHJGOFFUVkRWdjFoUnVPd0ZjdkFoVFpVL2ZJWFozNi83MWk0R3R1Q3FLMHIz?=
 =?utf-8?B?a2JmWXd1SDRGNWNuQktRQ291dnQyb055d0c2M0kxMEVkRnluM0ZGYnNaTmFD?=
 =?utf-8?B?RkhEM2lNbVFvZXlrNjlSUldYOUFyMXVjVVdZblJlUWtUZ2FsWUxhR0JkcVIv?=
 =?utf-8?B?KzBjMEg5Uzk1T3pqaFhnMXhCWk9Tam9xdSs1WXhHMXNneWtTYytJaU5LeHlK?=
 =?utf-8?B?cmxVZXhLa2ZMOTcxVjN4cGZSVWFtUzZBNVRoTnpTbE1qcEI0eCsyY3NEcjly?=
 =?utf-8?B?ZDJRNXROZC9DbjY1VEdFOWUwZSs3WGZ0QTUzR2ptNkRpYkFvUmp6a3N2WWli?=
 =?utf-8?B?TWtzMkkyc0xWeWk3eDR0RWp1SjlLSkVCNDBJeXF0WTJUbmxHZC9xVzZwQWh6?=
 =?utf-8?B?ckNwUk1BeFd5QUhWcW1xSTdkT0pRMEdlNzZCa1pMMGZKNjYrZVYySmZ0OHRZ?=
 =?utf-8?B?NWVDZko5Sk82YWV0bmxLZ0YzQ0o1QTE0cGZsSUZXV0ZwTWk5MDBJOER2eERC?=
 =?utf-8?B?OXl6aWMzRG1YSnhKeXNWUDkvdnZDVjJEeE43M0JrKzNLbC9oZ3c3Mno3TE9X?=
 =?utf-8?B?YWlCWDJJL1M0Vlc5aEhzckdBNHMyanREaWZ6bUJqKzBuQndmMjVkYnZsTlpF?=
 =?utf-8?B?NGcvcmQwMUNTeDlVRDVkMGdaMlZCMXYrRzYwenNjbEdlR2dyYzVadm1nT01m?=
 =?utf-8?B?YUdNMnY0Y25Yb0hSaC9zU3dyNDhFdUQ4bURtVmdwK09yTzF2QkI4ZkszOTZW?=
 =?utf-8?B?Si96dC9mdnlPMG9mYXZidmFRSFlQUVl2V09xZkRGcGhrSFVNdjNXdE0ycE5N?=
 =?utf-8?B?ZEs1Z0taNjZqVGlTVHlMY20ydjZrcTVGeDRtMGNiQ1Fzc0FPeDRlSGlZNko4?=
 =?utf-8?B?NVMwQ1dFRlRMYUNpT0ZkRW1WS1hsSll1a0l5Q3ZZam01MGJ1ektTRDRKbk5l?=
 =?utf-8?B?TG1ZRFB2M3Nyc3N2ZDFJaGNLU2JwSUU5VkkvOXlMNUNGT0NQR3BDdnFaUUky?=
 =?utf-8?B?ajhLTW80N0piN1p2bTlpTm5BVkhXNXMwa1l3WXNMc3M2c3VwYkVZNFpCRisw?=
 =?utf-8?B?WTZPQWliVi9SanFEQkViYlBtSnF0RGJBWmRGUUxzeUorWFhpRVduZ0V0MVp6?=
 =?utf-8?B?SEhaZGZPUFV0cWJCcDJPd3RVRTVwU3I1NlhTZjJLRVg3QmsxeFRvOWV4RXJi?=
 =?utf-8?B?OGNDMmxEZWxab1ZlWEZCUnBtcFVyNjFXS0xCL05ZQk5UcklXU1E0a001UlRT?=
 =?utf-8?B?RjhBMVEzNWM0d01iOVd3UncrdG9GWUQrNU03RTBDeGRrVEwrRHhDdDM0eVJo?=
 =?utf-8?B?OGwxVWNjNG55L2EyeFFoMUsxV1JkaEtuS0JRcitFbG5BZC82RlF6YkV2TmVJ?=
 =?utf-8?B?OWI3RmlnQlZ1WG02WmFFdXZTTklHZnloTnJ6VkJNdzJrU3pSUkdHQmJoenpp?=
 =?utf-8?B?WkhGMG5LdUdNay81c1I4TFVmNTdnd3VRaWF0UzJvaFUxOGN0allQNmIyTGpr?=
 =?utf-8?B?L0lGTGE5cExHTnhpbXpIc3RpRGZYOFMwa3orWWdsTSt1RzBkUXJPN2Z4ZVF5?=
 =?utf-8?B?Q0JzUEY2UkNYZGc3TVFwMmVGTHpjSGxSRzlCV0g1ZndNUEkwVndOdHloYmhD?=
 =?utf-8?B?NExvMmhodDltTUo4aGtpeWg2NVVFUmlsK2w2cHNnbHdya2w1SnZ0Y3dSMmhR?=
 =?utf-8?B?Q0NtNURHeE5ZdXNWRXBlbUVoVlJXc3pybWkwcTIzckJKS0lWRGpwVjhMOGV0?=
 =?utf-8?B?TjB2SkRmRCtXcWVpV1VtMUIvZUo5eFAzaHNrRlhDaVIyZUg4bStPK1YxOTdj?=
 =?utf-8?B?Um5NZ2pvaTV5Y01DNm1WTFRuT2ZNUnVpdU9lRnJPdnI1Q0YwUE9KZzdqOHk5?=
 =?utf-8?Q?LP0L1S4mzU9KcGdxe0urVc+j/c7y/7bz?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUkzeVNKSlVMS0gzV2VqNEJOR0hlZ0dCY1FxcjhBK2F4SGNzeHlDZzlWZlhE?=
 =?utf-8?B?MjhQK25yRnJER3l2b2lzdlFMWjEzSG5tT2p0Qmtrc2IyS2IrdXdXcDhmSGhC?=
 =?utf-8?B?V1pqdU01cmpyQVFPVS9iem9LZWNhb01FTWM2UndycHdyamh3eTl5bml2NUln?=
 =?utf-8?B?OHk5Yml4ZC9JREJrYVNiQ1puNkp3Q1VJV3BDV0NtYTBhMFVKZlRLWEtaQTNo?=
 =?utf-8?B?WHZCaTFzN0Uycm5TaFRXK3JqWUVsamZlQ1Qvd21HZFU0NldWVHVPUTFOQWNM?=
 =?utf-8?B?VGlxdzc5OHlvTjVac0o1Q0dwL0FEbDNVNEZ5VEZmbHM0WFFpSjN0elVMUDBv?=
 =?utf-8?B?MVlNbkk5dkRHaFlKRmt4dXZYQnRzK0Q4a0hFditnZnE2MHpnQmNqdVVsQksv?=
 =?utf-8?B?QTdzOWJJZCtZeDNEZGpLb1FMWlVVMitRZ1JqMmdGV0IrdUdzM2dZaFRLSjZo?=
 =?utf-8?B?QmFjcHNHUnVuNjZveE1qa09OUTI1ZWoyb1NOTXFNWlo4VmNZL3J2WjFFeE5M?=
 =?utf-8?B?SHNMblRRYStFNmRUOXRMNC9uZWoxSE1ydmJGUUM2Q3V4R1Qxb1VOVHd3cXY0?=
 =?utf-8?B?ejhjL3RIZFhpM1pZdXBRb0pmNlNTUkNDZG9wbjlMc3A2WU1Fb0FDc1JuVnVE?=
 =?utf-8?B?MzY3ZjlHcjFLL2Jpek9saTg1N0hvRklSQnBFTTQyeUNNR1J2RnZSRlE3WUly?=
 =?utf-8?B?N2t1V3prd0pRWlJTSklYVERGODFMb1c2VGxzNittajB6Q0kvRUc4QXVEZUUv?=
 =?utf-8?B?SmM0R3M2eFljNERLNXZMZHBoZnQ4U1dlVDlPSnRtSWMwS3hPVWJBaGEwWTM2?=
 =?utf-8?B?eXFuOFNlNXlkUkY3NXpRN3AxYnJUT0JFTUptUmNKTC9ranhjM0plR0xyQjBn?=
 =?utf-8?B?YU8rSzV5Ui90dHlseEV5ZnRkNlJLc1MvZ3VvLzl4bWpjVTAxdGhwemROL3dF?=
 =?utf-8?B?cXoyL01EVlZPZjQrbDNvRFRrdXNUNU1pUFNNQk1ueWdWQTRCTENKQlAvU2xp?=
 =?utf-8?B?K1ZtZi9wVHUxTlU1ZC9OTFdFbnRFT09JR0hVWU1Xb21sM3ZYb2JEdEJuL25O?=
 =?utf-8?B?WFpBQmFIWXRoOWJaaVRtRUdvWTdOMnJ0T08xbC80ejlxd1g5QlJ5OGpGTm8r?=
 =?utf-8?B?bVMxNVZZY1R1S3JZUS9WeFJZQk9SakhNNmd6ZFZKUkdxZy92NlRwWUsrcnBo?=
 =?utf-8?B?M0JvbWVMblp4blk0bFYwS2MxRTBXK1ExVHMxSzhPUUNPRGFuM2dVbHZEbmhj?=
 =?utf-8?B?aHB2VTg1VnQrMmRKRUNkQVlJaUhXTE5GSERMMlRIWHN0QzNHaXIwL01ZM3JE?=
 =?utf-8?B?eXBjTFpkQnRPK0tHSnJIWWhPOTMxZDR4U3JWeXV4WnR4T0Jlcnltc1lZMGJt?=
 =?utf-8?B?bUZxL0U5OHV0d3pkenhkMU9yQnpwK0M0VmpQSGNpMHdsKzQ5OWpGb3FCQVph?=
 =?utf-8?B?b2dFN0Q3a2VwK3pkZjhodlpJVHkrVG5oY0RkYnR2QlhwazZvTktXdjYwRGRk?=
 =?utf-8?B?dnRjaFRVcVdDTkNoNkVFTWRKZkRjMVhvQWE2TzNBdXBjci9GQklid1oyTGZQ?=
 =?utf-8?B?MUZVSURSWDE5ZGVmdFVkeTJzZHRCcTc4R3VhbUdKZHB3djZOYTVETGFybmN3?=
 =?utf-8?B?TEhid0dXbkV1YitCU1QzK3JHYllaUzZrMjlOVlYrZ2FzWmZzMUI0dmc4alY0?=
 =?utf-8?B?NXNVc3hyMUlvbldjVjZZOVk0TEhUbTRzZ0lPaGxPSGwwV28zVS9WeFBPL2hR?=
 =?utf-8?B?Q1pHUW04QUtTZk9tdnY5Q1V1cmZvenptL0Q3d0xZSXNnNjFMQ1FlemtlRDRw?=
 =?utf-8?B?eVZRYlkzNUZGNkdzOFRmdjBmM29rU0RiTnd0NzFQQmVxMjVlLzViSWhSSjZL?=
 =?utf-8?B?TWhqUmpTY2U1S2tOSkhwbUR5ZEM0SCtyWUxYM09ZU1dkQTNMZnhveURGZE5u?=
 =?utf-8?B?cmpPSy9kWkVSMGZwTm8yWndFMnFYMUp2YXk0eldEemR3Y3RPa1FMUjBndThv?=
 =?utf-8?B?Z0NLZFA4KzRmMjNJUGlYVHFiTEYreFFpdVhPc2ppYjloMndoSFRtczJnajR5?=
 =?utf-8?B?aUk2bFpEQXYzVHhSNjFqRnBwTytyOHZxWUc5N2czWHdRUjY2eTl0MktTenhZ?=
 =?utf-8?B?MzI0eXBqM0F1ZW9mK204c1BkU2d1cVhpeEpWVEd6TkFvNXF0K3Z3cDZBNnk1?=
 =?utf-8?B?VEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <049D5DEE879C7A46A24C03F3DAA4BE77@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7f7c80fd-8a70-44d9-18b2-08dd1e40c4bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2024 02:16:08.3853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vhPI6S2C+ZTfnb1bMOV/Cz+xxzuyW39u5SrYZodQs0mpOKljr+LEtO3AuXDOtehD3qEpfKq0iEu2z/6jUGjlLjbwfLVcnCjDfpH1exyHuEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8255
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI0LTEyLTE2IGF0IDE2OjU4IC0wODAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IEZ1dHVyZSBTY2hlZHVsZToNCj4gPiBEZWMgMTd0aCAtIE5vIHRvcGljDQoNCklz
IHByb2JhYmx5IGEgbGl0dGxlIGxhdGUgaWYgbm8gb25lIGhhcyBoYWQgdGhlIGNoYW5jZSB0byBs
b29rIGF0IGl0IHlldCwgYnV0DQpob3Bpbmcgd2UgY2FuIGRpc2N1c3MgdGhpcyAoW1JGQyBQQVRD
SCAwLzJdIFNFUFQgU0VBTUNBTEwgcmV0cnkgcHJvcG9zYWwpOg0KaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcva3ZtLzIwMjQxMTIxMTE1MTM5LjI2MzM4LTEteWFuLnkuemhhb0BpbnRlbC5jb20vDQoN
Cg0K

