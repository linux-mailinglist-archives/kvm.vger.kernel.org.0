Return-Path: <kvm+bounces-18353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F4948D4230
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 02:07:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E53A32849C2
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 00:07:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D98D11FDA;
	Thu, 30 May 2024 00:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fdueqpe1"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 770F97F;
	Thu, 30 May 2024 00:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.8
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717027624; cv=fail; b=g57Z79502UdFLr8F//RyOZknEhp07sCpiEn3JDjlZuVXfapoeFeBrpDk4xdFs1E7jSUu3ftV0DHVl9eDXV+bgWTOvLPFN+1PZOfEIp1Wa5P3xljelVjX1HlrxSmK/zNS0hDYl0/UCXDspaPYRujDz+6gT3oCIl8nZnPYtl8sNQI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717027624; c=relaxed/simple;
	bh=0it5TnA+dcG1HHAwal8+fy0eWYCTOEanNp/Q0FGw3Qc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=oVzbKalkxMkDMCqeRVyn/gXjpha8uR4dijaGduMxvbXGDQ+D9ZzdGdsZnmW+jz0nEa5frEP2XnG16YEeO9vNobP8ofSC3fboGSlNNfIdwBxwZa5TNUkCo88YEQLXS1+LTjwVu/xogaJbU6vMx/u2Z26ED8eJAvLKPGFITslD0Fo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fdueqpe1; arc=fail smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1717027622; x=1748563622;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=0it5TnA+dcG1HHAwal8+fy0eWYCTOEanNp/Q0FGw3Qc=;
  b=Fdueqpe1au7zRCzFbSsy+rBOiUO5c4rJjY0IMxiAUuLYVYfKXhPOZdhO
   +k/aA//zmhEXiaWU417NRYyOgSwMNkuD6EKgwV3hwOOSqePbTwurh51G0
   DOFp8VBbiB1Qw8O/usS+SzvQYwYp+H3TvAeamIUrzQdj4YX2cf5hgoMAs
   aS+fYSYM8J81MEDp+R3lIXB4j4lVh6QTk/pjSUVx5o4+wvy5e6P+DrPaD
   fy1q/fpg1CSpTaRGcAgDY3RKY9XMM4trI068dBw9ffVzAvjkvcb7bBa/g
   4G7KpG/65pawQSX2iBSGcIlbHggEIr5gc0nCkK2rMa0G9WDe9xwDoDu+r
   A==;
X-CSE-ConnectionGUID: Qz37KgKKQVGUr2+zLN5bPA==
X-CSE-MsgGUID: 17uSxRyOQP2X9t26Yy7hsQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11087"; a="30998975"
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="30998975"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2024 17:07:01 -0700
X-CSE-ConnectionGUID: bAh5OvDJQmSuyB5ISPSTIA==
X-CSE-MsgGUID: C06TXTrmR2Kedp8p4VX5og==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,199,1712646000"; 
   d="scan'208";a="73079788"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 29 May 2024 17:07:02 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 17:07:01 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 29 May 2024 17:07:00 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 29 May 2024 17:07:00 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 29 May 2024 17:07:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axmPC7lkdkl+bediOLA8FLmluKHn9a8x4rhQuEn6t8cqmAUjlo5K61pRnO6ymCEyHMx+O3KjtjZzGxOj8KO7xP7l0yuRiW69rrkV9dBfnJ3C3wi5LXEgN200slJnkI8027LiuBUCf1xs9CYJHSaL8rHluUEZAcefDGunBS9TxlEBXsr5oSe0KOuALvgvbGYdhbUToFmlVKpphUSZnN6kodrCVqXE97Z2n9WjUJk0Q1akyNy3/EKfp+i/+0fh2uIm/5/ugbwIYJONiPLhdRDMMMUy+pCpxc1hke1bQ8ro2vF2ou3EERhWryjMff9nGHrrTBPWnOR4vr/mvBHapPzLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0it5TnA+dcG1HHAwal8+fy0eWYCTOEanNp/Q0FGw3Qc=;
 b=Bd6FzjfQIS1yZ1uEBPTyaTtNrSI+hW70VQeET4nWuDA2T8YW5W17AZMto0Vfrs/oiAl2KrUVoq0aGsdut8zEseXBPXp2CMABDlyYNjgseKhXp3GMyMI/kKXc9oPKElqg3u7XmSPo5Y4AnqsrmrqdCB8sQzkpyUI966Dh4yfBrT07Wky/1vIx1VZ7dBKMsMESZthrO7vIPcHzlq0Umfdhu3WOMaHh2qeeUso05Elh9S3Q9rOhDPECGR23fc+q1qxxUh1yeOI2VheGVOiPbSyRlAlkQHIyGFE9XlIJ8Cqg18+bsXJNfUHC8/yVAAfN8fwFRJe7KSIsvKXy+t6Le30+vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SJ0PR11MB5133.namprd11.prod.outlook.com (2603:10b6:a03:2ac::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7611.30; Thu, 30 May
 2024 00:06:51 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7611.030; Thu, 30 May 2024
 00:06:51 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>
Subject: Re: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Topic: [PATCH v2 3/6] KVM: Add a module param to allow enabling
 virtualization when KVM is loaded
Thread-Index: AQHaq+/EabXqSDrB20SW6NZi8wYleLGj1rKAgABjVICAATs5gIAAOfIAgAYFfoCAAqWmgIAAgYYAgAAGXACAABBvgA==
Date: Thu, 30 May 2024 00:06:50 +0000
Message-ID: <4f5d14617752046939ada24b288d41220b097c84.camel@intel.com>
References: <20240522022827.1690416-1-seanjc@google.com>
	 <20240522022827.1690416-4-seanjc@google.com>
	 <8b344a16-b28a-4f75-9c1a-a4edf2aa4a11@intel.com>
	 <Zk7Eu0WS0j6/mmZT@chao-email>
	 <c4fa17ca-d361-4cb7-a897-9812571aa75f@intel.com>
	 <Zk/9xMepBqAXEItK@chao-email>
	 <e39b652c-ba0e-4c54-971e-8df9a2a5d0be@intel.com>
	 <ZldDUUf_47T7HsAr@google.com>
	 <291ecb3e791606c3437fc415343eb4a25e531cc3.camel@intel.com>
	 <Zle1TrfeJDeXLtLk@google.com>
In-Reply-To: <Zle1TrfeJDeXLtLk@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SJ0PR11MB5133:EE_
x-ms-office365-filtering-correlation-id: a9246116-1be9-4c7f-a37b-08dc803c67f6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|366007|376005|1800799015|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NnAxWTUwNi9yT2pPZklKLzJ0TnRoZGVUdnZyc3NDNGFBa2QrVTJ3RW5VWm13?=
 =?utf-8?B?YmhvbHpGL1lhVlptUVRsdlpDajhreDRHajcydEZNTmZJWTFCVDN2bnBTUE5M?=
 =?utf-8?B?Wi91VzdET0xJekFYRDNVWkp3MlRJNHVkd1BaSVNKQXRNTkJtanRaeXFKZkQ3?=
 =?utf-8?B?MTdQUHhzY0t1UlpwbE40SGdRc0tqVkFZbnVPcVViaEpJZUZEQmZ5b3FnTHZt?=
 =?utf-8?B?djFvbUxZQ094eGhkQ21NUklMMkJ3L1BtMmJZaVZZMzRiYnJkZlRrZnRMaElM?=
 =?utf-8?B?dGNUUDZuMGg1N0lWV2J6Q1NMUUtFd2lPc2NGdUt0d1dxeGcyMVRQUDlxdzZX?=
 =?utf-8?B?MHQ4V2JJNmRRZGtPYjlxbHdiek0zTWNvSThGNkdtNG1yZ2o4cWZ5OElhNUpm?=
 =?utf-8?B?L2EzTWVTbnVKeHNqQjBDY0RpMjR5bHVVMThxYlJkRStNRGZjNWExYXJtMlly?=
 =?utf-8?B?WjA5ZUhkNDdxUjk3U3JFSHJQcjN2ZEhXVEpvRXZtMUEzS0p1MkZabzJuYllr?=
 =?utf-8?B?Rm1mK0xEYVVZeE1YWng3R2FnU1Q0aER6SVRSdHVTaWJueDNTeVkyd3F4emlX?=
 =?utf-8?B?UFZyZ1JYYlNieXRDTGFyeHdGcURhVnlOUlgyZ1Qxb1hOMVRHUUNEcDVoWkV4?=
 =?utf-8?B?VzVFd0tUcVpJVmpXTmlVazNsZ1lMTGZKMlVjVTdzc1ZsNm45dSt3YW1kcVdF?=
 =?utf-8?B?cmlnZnBhOEVpTVhzZXJKUEhvdk9zU0krVjFkQndqVEdXRWxicVhYOFVoeW5N?=
 =?utf-8?B?OUpCaDl0eHJ6T2FpUnZ6c1I1dE1UYzRVejdDb1Q0SitCOU5pc0I2RlE2WEhR?=
 =?utf-8?B?MUQyMDFqUUtuU05CSXhXS3dIZ201Tnh0SjJYa3RZYW5yT3laZEhKUkE4RjJn?=
 =?utf-8?B?L29FZ1NMRk9nSjIrcTc4NCtqRGtMT3pDdEVIRUVIRXAzS29NeHBOam82Ujd2?=
 =?utf-8?B?ejEvclZiOGV4SktTcnVISlh0THczck44bHJmbGw1WGt6R202dTFCZlF4enc5?=
 =?utf-8?B?dlJDeGMzemRhYVZtOUJ4VVlTcm5PSk9Nb2NpclBJNkJqbmt4WVhZTFo4L092?=
 =?utf-8?B?UjV3dlpIeXZiOHRrRlVJUEdhTzZ0WUJaQmxUNGtRbnlJczJ4UG1yeEh6Q2Mx?=
 =?utf-8?B?OEVKdy9TZmVqQU5EckRTMHorVFVCOXhkc05PZFNkTmhRbXFZK0F5WDhNUVRu?=
 =?utf-8?B?a2JuVU9ncURlbXhNMHBYY0RlNW92K2hDQjkvRkU3KzFMcG1YYW1PMUtuUWxk?=
 =?utf-8?B?TzQvSDdxcDcvWm9wVFZrZzFOSVBBWklDWjlKZ2w0QmtEMGNWQXhxTTFtMEhM?=
 =?utf-8?B?UFlGZVRCdkRSRTdodUc3OE5CT1Mvayt5UHJxWXlyOEJmd1JaaWR6TzZZbExs?=
 =?utf-8?B?UWNITnhjc1d3cjZuaEhWYzl6YWpuSXMvL25qWTQxazBBMXpxT2l3Sk1Ra3Q2?=
 =?utf-8?B?aCs3R2UyemdGRWRjdmtFR1dOM205eUpTMTVmU3RXR2hiazVsbVZlczZJT3ho?=
 =?utf-8?B?elV2YUtlT3k0SFR5K0RweXpIYjZNYWRpWG54aGIyeXJidktXbkw4cExrcEtG?=
 =?utf-8?B?WXYvTHVlUFRKeTAvSkU3TElJTlpQbGJBRGVlcUU1SUdZbjMvaTdJUmVJMVZE?=
 =?utf-8?B?UGVWL2lQckpoUU91ei9OMWVQVUlCMnd6d3hmS28xek1CVmI0QmhOWTBMb0tr?=
 =?utf-8?B?VXlsT2tFWEVTTm5MNzZNZDcvREtUSWZHTzBsR2dicWhBWGtWWktnbk9hMnk0?=
 =?utf-8?B?TzB1SVJzdmFuN2VZYS9WWnlTSXJ3S3o2eUowQWFxRG5UOXVVSlJDdk1OMmpt?=
 =?utf-8?B?bDE2emR3RWwyNkFPS2NnZz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eTNTZjA0dFFPRmFad2NYOENZck40V0tHRnZkRS83V0FaZkUvcWNJSWM5TzRV?=
 =?utf-8?B?OVk1aFhKb3NabXJ5L0JROEhKVUNyMmdhb1ZGNTdrUVI2T1VLeWNoRUVZZHNX?=
 =?utf-8?B?U1BuK3FOVlFLQUtxejhRK0dmTFU2RDcwTGplMmtBZHdIZUU0Z3BXcW9LaUlh?=
 =?utf-8?B?UnVLMmJmbVFsWWJvMzNuT3kzSkowczRreEliU0UremtTc0JJZXpBc3RzdUpr?=
 =?utf-8?B?cmpjRXlNSWplR1diTVVnTzlzc3AzYzQ2T29qK3FJZnZrWnUzNUp5UzlkdUZp?=
 =?utf-8?B?QmIwVWxNQktBOWVIMU5tLzdMRnFYVzhMUW1MYlNLa0p2OVpPUUJRd25ZdnI1?=
 =?utf-8?B?Y2RRTU9GbUFqaG1iT0FxVE1wZkZ2Z21adjBEKzRUS2V5WVZScjR6dnVYZWdq?=
 =?utf-8?B?cUxNQmIzUEVvL05PNzVkSFJwK3UyMFZTb3ZlcUI3aytDeTlKQnJvZHY4Nkp2?=
 =?utf-8?B?dDhxSncxQmM1eFFuS01POVdPMjI5N0U1eE1oSzRiUlBBdWRJVVhWcnRaa0tR?=
 =?utf-8?B?cnN1Mmd3T2JUUUMxcFVCYnhpc2ViK3BMV055TjYzc3R5K3RCM1QydXdUNnN0?=
 =?utf-8?B?dDJONG9vMmtqdmpLMDUvOEgraytBZ1YrZEJMY3NFdmROLzloUVhjckx4endr?=
 =?utf-8?B?UnNUQ0ZuaGtmNmpvUFF0ZGdzQmJuV3V5dzVFbUdjbmhuTGFWS01reHZIRWU3?=
 =?utf-8?B?ay9oVlRkOVpZT0NLWlhSVUdJQ1NpSkNlVWFqc2tZU1VrcnpyU2JPTnYvdVV5?=
 =?utf-8?B?b05mQW8yaytxbStkenBzb3R1ekJmSFNlNEwzdG84RlpqeGR1MHR5VmpmZElo?=
 =?utf-8?B?dTdvVWtPdHNnUFM0di96eUtTaURhVStiMythS01aTGc1SkZWS245aTJUR3hh?=
 =?utf-8?B?WHNrdzlIbmwzOTRxa0ZrOG94Ni9ZVlJ1T0JXQWRIekFtUFZCaWZQUnZEM21G?=
 =?utf-8?B?REdMb0FFZkZlaUNORHZRek80NHo4VWpUSjN2RFRuVi9MUDBIT1VUejgrMDAz?=
 =?utf-8?B?ZWZKVTU5aDViZVVuaU90SEZtZnNadHRMS2hhdHBsUG4wc2xZVklVOXNOZ2Rt?=
 =?utf-8?B?bFlkVW1nR2xaODludVFORWg0NHVVTVJZSHNLeXFvSkRwdkY2alZtbmRGcjdV?=
 =?utf-8?B?cHk4L1NpYnRRakVvTWxEOWlxTThtaGpQWWdCYjJxbFN3eXN3TGYrRmtJRWRr?=
 =?utf-8?B?eWMxTXNLZUFVRzlmRFg0eUJWSGxtdFY1ZEsxamgzOHI2cTlqK3lQNFZNSWVQ?=
 =?utf-8?B?TUpVbm0xTWIwb3Q4ZGZPcDZVVWsxUndKUWZYcCtMY2hGL0ZMMVA5WkJoVHZ2?=
 =?utf-8?B?dFM1ME1iVU5YTTVLcEVDaTcvblJNVUpoUzhFcXF5ZmVwUldjTmh1YVo0K2k4?=
 =?utf-8?B?WFVsa01aSmh3YUt5SDBkSGluR0Y4WHA5bk5FQWhQbXBGWEN2YVRDaG5YMjlK?=
 =?utf-8?B?R2hzM1hhK29tVm14OE9ET2IyZm82MjdzRkV4SXlXdkNpMitSM3doYi9vbFRr?=
 =?utf-8?B?WGhEdVF0R2VhUVdjME01eWJON2lCaU5HSHVXcTBpZXR1VU9hZU9xVnNSUWlF?=
 =?utf-8?B?SHdsVFBhZVhUb0xWYzBiOCtZSWFuRlpuSW00N05kSnZxR2NjLzRPbjlVKzJy?=
 =?utf-8?B?SDZtYXJweDVTUno0c1I0V2RUTVVGYzNadncrdS9adFFjUmFDZGVRYzJPaHZh?=
 =?utf-8?B?NUkxTUYvNEx1SldRbUM5aVpSbzVlMG12RTlMbEIxUkVveEJ0MVd6RFQwZHBG?=
 =?utf-8?B?L0RDQVlzSHR2aTJkUUJMdzJBV2Q2RmowMWp0TW5xQTRrbVI0alA4aDFLZkRi?=
 =?utf-8?B?NnJ6TDhSeXhlL0l0TFdhYVBQY3pPU3hwUlZOMksrUnlWODV0cEEycXBTQVpO?=
 =?utf-8?B?aGpYZXF1Qm1SYkppcjhqUEtmUEdDMWQ0RUIzdDZaRWlmcjNSSHpSeW5zRlNG?=
 =?utf-8?B?dEVia2RuNnFSMFp2dHFFaVNnYk5IUUk2cUtKNTJQTGY0UjV2VVBCNWs5QTVQ?=
 =?utf-8?B?T2Jad1JhV25VeDdJMW9XMlJxa3VDTjhmdDNxWGZzay9IcHR0RE5pbVZ5OHMr?=
 =?utf-8?B?UitwdjRJNzRtbXN3R0xNeTRpRUIxZklqQ212R3N6M2c4K25ydlRMOTlXZUty?=
 =?utf-8?Q?IMV6DWbJaz7pbwa09Mc30Aylb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <181E3030017FA3418A0A8725D9DA5BB8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9246116-1be9-4c7f-a37b-08dc803c67f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 May 2024 00:06:50.9768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0AeMdXLoTLXNKvSdEuLBQ0nNQZZQI/WRHSnOosl399i+DAu553CAzPEfVJsJbMWjmc/5x9gyRdHkWNTVAD4+dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5133
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI0LTA1LTI5IGF0IDE2OjA3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBPbiBXZWQsIE1heSAyOSwgMjAyNCwgS2FpIEh1YW5nIHdyb3RlOg0KPiA+IE9uIFdl
ZCwgMjAyNC0wNS0yOSBhdCAwODowMSAtMDcwMCwgU2VhbiBDaHJpc3RvcGhlcnNvbiB3cm90ZToN
Cj4gPiA+IEVuYWJsaW5nIHZpcnR1YWxpemF0aW9uIHNob3VsZCBiZSBlbnRpcmVseSB0cmFuc3Bh
cmVudCB0byB1c2Vyc3BhY2UsDQo+ID4gPiBhdCBsZWFzdCBmcm9tIGEgZnVuY3Rpb25hbCBwZXJz
cGVjdGl2ZTsgaWYgY2hhbmdpbmcgaG93IEtWTSBlbmFibGVzIHZpcnR1YWxpemF0aW9uDQo+ID4g
PiBicmVha3MgdXNlcnNwYWNlIHRoZW4gd2UgbGlrZWx5IGhhdmUgYmlnZ2VyIHByb2JsZW1zLg0K
PiA+IA0KPiA+IEkgYW0gbm90IHN1cmUgaG93IHNob3VsZCBJIGludGVycHJldCB0aGlzPw0KPiA+
IA0KPiA+ICJoYXZpbmcgYSBtb2R1bGUgcGFyYW0iIGRvZXNuJ3QgbmVjZXNzYXJpbHkgbWVhbiAi
ZW50aXJlbHkgdHJhbnNwYXJlbnQgdG8NCj4gPiB1c2Vyc3BhY2UiLCByaWdodD8gOi0pDQo+IA0K
PiBBaCwgc29ycnksIHRoYXQgd2FzIHVuY2xlYXIuICBCeSAidHJhbnNwYXJlbnQgdG8gdXNlcnNw
YWNlIiBJIG1lYW50IHRoZQ0KPiBmdW5jdGlvbmFsaXR5IG9mIHVzZXJzcGFjZSBWTU1zIHdvdWxk
bid0IGJlIGFmZmVjdGVkIGlmIHdlIGFkZCAob3IgZGVsZXRlKSBhDQo+IG1vZHVsZSBwYXJhbS4g
IEUuZy4gUUVNVSBzaG91bGQgd29yayBleGFjdGx5IHRoZSBzYW1lIHJlZ2FyZGxlc3Mgb2Ygd2hl
biBLVk0NCj4gZW5hYmxlcyB2aXJ0dWFsaXphdGlvbi4NCj4gDQo+ID4gPiBQZXJmb3JtYW5jZSBp
cyBzZWNvbmRhcnkgZm9yIG1lLCB0aGUgcHJpbWFyeSBtb3RpdmF0aW9uIGlzIHNpbXBsaWZ5aW5n
IHRoZSBvdmVyYWxsDQo+ID4gPiBLVk0gY29kZSBiYXNlLiAgWWVzLCB3ZSBfY291bGRfIHVzZSBv
bl9lYWNoX2NwdSgpIGFuZCBlbmFibGUgdmlydHVhbGl6YXRpb24NCj4gPiA+IG9uLWRlbWFuZCBm
b3IgVERYLCBidXQgYXMgYWJvdmUsIGl0J3MgZXh0cmEgY29tcGxleGl0eSB3aXRob3V0IGFueSBt
ZWFuaW5nZnVsDQo+ID4gPiBiZW5lZml0LCBhdCBsZWFzdCBBRkFJQ1QuDQo+ID4gDQo+ID4gRWl0
aGVyIHdheSB3b3JrcyBmb3IgbWUuDQo+ID4gDQo+ID4gSSBqdXN0IHRoaW5rIHVzaW5nIGEgbW9k
dWxlIHBhcmFtIHRvIHJlc29sdmUgc29tZSBwcm9ibGVtIHdoaWxlIHRoZXJlIGNhbg0KPiA+IGJl
IHNvbHV0aW9uIGNvbXBsZXRlbHkgaW4gdGhlIGtlcm5lbCBzZWVtcyBvdmVya2lsbCA6LSkNCj4g
DQo+IFRoZSBtb2R1bGUgcGFyYW0gZG9lc24ndCBzb2x2ZSB0aGUgcHJvYmxlbSwgZS5nLiB3ZSBj
b3VsZCBzb2x2ZSB0aGlzIGVudGlyZWx5DQo+IGluLWtlcm5lbCBzaW1wbHkgYnkgaGF2aW5nIEtW
TSB1bmNvbmRpdGlvbmFsbHkgZW5hYmxlIHZpcnR1YWxpemF0aW9uIGR1cmluZw0KPiBpbml0aWFs
aXphdGlvbi4gIFRoZSBtb2R1bGUgcGFyYW0gaXMgbW9zdGx5IHRoZXJlIHRvIGNvbnRpbnVlIHBs
YXlpbmcgbmljZSB3aXRoDQo+IG91dC1vZi10cmVlIGh5cGVydmlzb3JzLCBhbmQgdG8gYSBsZXNz
ZXIgZXh0ZW50IHRvIGdpdmUgdXMgYSAiYnJlYWsgaW4gY2FzZSBvZg0KPiBmaXJlIiBrbm9iLg0K
DQpPSy4gIE5vdyBJIHVuZGVyc3RhbmQgeW91IHdhbnQgdG8gbWFrZSBlbmFibGluZyB2aXJ0dWFs
aXphdGlvbiBhdCBsb2FkaW5nDQp0aW1lIGFzIGRlZmF1bHQgYmVoYXZpb3VyLCBidXQgbWFrZSB0
aGUgbW9kdWxlIHBhcmFtIGFzIGEgd2F5IHRvIGRlZmVyIHRvDQplbmFibGUgdmlydCB3aGVuIGNy
ZWF0aW5nIHRoZSBmaXJzdCBWTS4NCg==

