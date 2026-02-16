Return-Path: <kvm+bounces-71134-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id eCzdCuVuk2ku4wEAu9opvQ
	(envelope-from <kvm+bounces-71134-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 20:24:21 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C470114747A
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 20:24:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E89153008C3C
	for <lists+kvm@lfdr.de>; Mon, 16 Feb 2026 19:24:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CE9D2F6907;
	Mon, 16 Feb 2026 19:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="tJ42hjgk"
X-Original-To: kvm@vger.kernel.org
Received: from CH5PR02CU005.outbound.protection.outlook.com (mail-northcentralusazon11012056.outbound.protection.outlook.com [40.107.200.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D03282C0F79;
	Mon, 16 Feb 2026 19:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.200.56
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771269855; cv=fail; b=jazzT78kHs9WISK0IzrEvQU6Bspiyun6B9eQtmtRRjHtWeRGmOt6KVegB0xF/6bS3dENzbKLFp2MolIAPzzPPcslkJ3mdJ1T5f1axLQkGiqLdCi5XWBpogYMRkTZy1ROdCB2WJ+anKDWRNhC+xlxcYJqrrkpeREQtfCJnRC4EOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771269855; c=relaxed/simple;
	bh=lXjk6AbbuZ+GSxBhFHfEZaWR43orssvecQr+6ZZmA10=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=FzRYprbZNUMF9QSdKekrZea6FmyyNUa6QiMxHqIbYJqGzDEqmKTJO9T5woK1e+O3/hOBMeZmriFf0Ziq61M5qRTuWdsiVgrF3jn+adOrOyJo7OqEYJIi8StFkTyPpJCsUHNPtVpcPUh2PRiie8Mcjr4tzcLgnf6DlGSkXup8Ky8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=tJ42hjgk; arc=fail smtp.client-ip=40.107.200.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yNOf3BoKNUkLBQgubU7esyhbVwobnBXCm1ERM1xht66AfpZRcXWyH02sbD0vdfXApqRxbiWYqsSfiBG8S66s86C4XQC4y2gn+8nXZjv3zaPsPzgOlIDvf+notWqJeInLyuj+aVjbYOfFsodLoaVXBVwn0JsxYFhY2Wpmy3YpfyLOi88V3EICJoxDro6lqlPqMrdS3jYSThUExMZZIkzuR69+YIzhzVFeXbW9JR2xfU8QrN5qXWvbVC6pKLJrj0PLuo8SNqmz35DsmzS551m7WaToBzyuwgIp3haprYBgW0XFny1K1s9xkBHu/GbUxnE21M5h2qDoEXdJCSEhA3bNmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nx2DvzsMuqT4KinbXxO8TM0i2RIuYgO8jdMIdksoEc4=;
 b=rhoTK/xdL2MDf7JSJ0JTdL5ePqaTEMvACZouhah9zDGeR0z+2swOhvUKoIHsOkXr0Eqv+wW7yGQ14qhqgu8Tmi29EH8d4K1Rgzs+PKW2iib+t7j4KJuCCx+n7uuI+/FhfQRxD4oBm4ZUbcEQysZzuBb1Vy+puZpujSsvHpm1IcCI47cqWzx0JwcK2m9/7xGzc2y7gFBOOnX/i/3+DpfavAOgFush9RTvp8HPgUdkwOzId1FaFxqYy7qPOQuCgYc+uytTFi49rEuuU9XMoYtLdmRiEnpxJfRRhLnbNtw33bOvslueBb+jGSooHz5ohuXzezY9g23ypxhmSNivlHy0mQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nx2DvzsMuqT4KinbXxO8TM0i2RIuYgO8jdMIdksoEc4=;
 b=tJ42hjgkbu1AcapTLgGQ62yUbz8RG9dsx5qwDySX/j1Kucn6gb+FCpdNosuR1T5D/clvxvZhXgJsTSLnslt84uaKP41HTWJK+bRhXb/2760xj+H2TLnUnCCbiO4Zy6+otdehDZkl2mkZJUpBG1wsw9Ydi1vaqiOE9zbeHdzmfYY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by SN7PR12MB6838.namprd12.prod.outlook.com
 (2603:10b6:806:266::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9611.16; Mon, 16 Feb
 2026 19:24:10 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9611.008; Mon, 16 Feb 2026
 19:24:10 +0000
Message-ID: <4904a6e7-9f6f-43ae-b591-1b9672ddac6e@amd.com>
Date: Mon, 16 Feb 2026 13:24:05 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
To: "Luck, Tony" <tony.luck@intel.com>, "Moger, Babu" <bmoger@amd.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
 "corbet@lwn.net" <corbet@lwn.net>, "Dave.Martin@arm.com"
 <Dave.Martin@arm.com>, "james.morse@arm.com" <james.morse@arm.com>,
 "tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
 "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
 "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
 "dietmar.eggemann@arm.com" <dietmar.eggemann@arm.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de"
 <mgorman@suse.de>, "vschneid@redhat.com" <vschneid@redhat.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
 "pmladek@suse.com" <pmladek@suse.com>,
 "feng.tang@linux.alibaba.com" <feng.tang@linux.alibaba.com>,
 "kees@kernel.org" <kees@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>,
 "fvdl@google.com" <fvdl@google.com>,
 "lirongqing@baidu.com" <lirongqing@baidu.com>,
 "bhelgaas@google.com" <bhelgaas@google.com>,
 "seanjc@google.com" <seanjc@google.com>, "xin@zytor.com" <xin@zytor.com>,
 "Shukla, Manali" <Manali.Shukla@amd.com>,
 "dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
 "chang.seok.bae@intel.com" <chang.seok.bae@intel.com>,
 "Limonciello, Mario" <Mario.Limonciello@amd.com>,
 "naveen@kernel.org" <naveen@kernel.org>,
 "elena.reshetova@intel.com" <elena.reshetova@intel.com>,
 "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "peternewman@google.com" <peternewman@google.com>,
 "eranian@google.com" <eranian@google.com>,
 "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
 <bbe80a9a-70f0-4cd1-bd6a-4a45212aa80b@amd.com>
 <7a4ea07d-88e6-4f0f-a3ce-4fd97388cec4@intel.com>
 <abb049fa-3a3d-4601-9ae3-61eeb7fd8fcf@amd.com>
 <aY9ZH9YXAfnIKTL-@agluck-desk3>
Content-Language: en-US
From: Babu Moger <babu.moger@amd.com>
In-Reply-To: <aY9ZH9YXAfnIKTL-@agluck-desk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA1P222CA0094.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:35e::14) To IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PPF9A76BB3A6:EE_|SN7PR12MB6838:EE_
X-MS-Office365-Filtering-Correlation-Id: ea1dabfc-57a4-49c3-45dc-08de6d90f5aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016|7416014;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?bHZLWGZHVEl2U0tRbEN1eEZ4Z0ozRG4rVWtwYXBtQ2tXYld0dkpPOWFVc3Ju?=
 =?utf-8?B?dmorbUw4Vkk5WmswcE4wcmdtUmZsV2I1ZGlUYjhOM2gvdGc3Q2JxUSs4WElN?=
 =?utf-8?B?Mkx2ckgrZ2VrWHdaRjBzOUxEM3RpT1U4T2c2M2ZybG11NDA4UWw1d004Ynpv?=
 =?utf-8?B?cWsxOXEzQ3UwbjVVMGM0RG01LzlyUE5pRnFnRHVIeXZGR2NEajlqTjV5TlZH?=
 =?utf-8?B?UDUwN256cHNNOHlWc1RNbHdmU0hnMGd1MUFQOTdMbEZwSjVBbE8vM0ptcEg1?=
 =?utf-8?B?emtIaEc5cWdISmEzSkNRK3BaOUZHZHAvN3J4SlVwM2trMnV6OTlnZHZGUC81?=
 =?utf-8?B?eGhVam5mN3NnZ09ZNFFBOWErSVpOZ1hVaC9pSkswK1lTMDhseERTR3pXUU1S?=
 =?utf-8?B?Mnlta0tCZFptdXAxYnpMb3h6UzloTjNBWFJJZmxQNTMwWVBqMGtzM3Q2dTA4?=
 =?utf-8?B?S2dPNzh4WGhzbk10WU80QlpNaFFUN3pYRkhKeHV4THl2aEtuR1NRWFdYU0wx?=
 =?utf-8?B?NzRqelRrZEhBNnRUOFlyTUptOVdyRFFpRCtseFQ4ckNVaUNGc1krV2t3Si9h?=
 =?utf-8?B?Kytua1NwMTZMWjhhWHN0M01JOWlGbXUvOWkwSWhicm1UaXVzMTRnV3FxL0Jp?=
 =?utf-8?B?S0N5eDZVV0xRMG9yT0VrMjByYlVKL2l1Yy9KQVUwUmdQWUFadmxvK2w5L25F?=
 =?utf-8?B?bmwzQ0diUzY5NEZwOGFFZmt2S0hEdDA5M3QzZDlBVlo4cU9odlJ5YVk3TDNH?=
 =?utf-8?B?ZjM5RnlvMmtDcURKQTJvKzNJbmM1akduTnFyZnE1SFQ5aVBaOU1jaXl3WWpz?=
 =?utf-8?B?Y0RXOU1KTW54bkJyQkJVMWthajgyNnJQQ0J5WUZBNTJ5czVsL3d6ZmNOOXpZ?=
 =?utf-8?B?ZHVOcnY5M0R3SmwwWHlxL0EzYXJGdXpvYll5TUhtNVZtQkF5ZGwzYzZHeEZ2?=
 =?utf-8?B?SERtUDBRUlhsWWgrMDNiNm5KOUZKL1NaU1ArMWlVdFRIa0g3TTNvNWV2QmEy?=
 =?utf-8?B?SGcxd0xvVC9uVWdWYlpOK0liVlpDTDdRQXVzbmZlWHJ0eG1mVktWR2M1OXZs?=
 =?utf-8?B?UTFDWDlUN1pTamFxb0JTRGM5cDJZQlBJRkdKbWF4NnBYVHNWanRIWVlzUU9l?=
 =?utf-8?B?UDg3M3FyM05zalA2Ly9Xc1FYcjQyV2tmZjYrRGFEU29MOTF5eStuRGpXSUFl?=
 =?utf-8?B?bjBuUG50YzhXZStwdVVDRm9RSzJRM2hSRk1jZVZqbVJhR1RVanQ3N09BMzkz?=
 =?utf-8?B?K2ExNi9HY3hXT2xTdnpFN2RnRmRJOHhaUHdzL1ZlcXFtZVRHU2p0RThnbnZs?=
 =?utf-8?B?NmlldmRYQXVNNkFlaDNIWUNuUFpNWHpHWlV6QmlpOU41N2g3VEdEbzN4RTFZ?=
 =?utf-8?B?WWRhd1JmeWY3M0xlb1FXSzRiSTVGdjJKM3RuQ2NJQUxnM1hqT1JwZTdObHlu?=
 =?utf-8?B?OVpadUNaR0dlNWZGRU5hSlFsRDc1U0xTNGN4VElCMXEzUm0ycXlhSk90a1Y0?=
 =?utf-8?B?SHJkQzRkdnZRWERQWFd1cjY3Z0ZXdVZzR0FuQnpVUWhoa2R0VVdyS29aOWpW?=
 =?utf-8?B?N0lGNXlKSlRwOUZEOUF0d0M2L0VaUFZTaitBNWcrTEtCc0xJNm9ETUdSclZl?=
 =?utf-8?B?THRYZDI1MmpvWS91ektQdklIRmhJSlVoclUvZ1RlamRnNmJhQ2JMTUVYUXE1?=
 =?utf-8?B?blUyY1EvMitub3RuR2dvS21ZTWt6cmx1aXlWOVNJZFBYZWluQmlzTEd4dGFt?=
 =?utf-8?B?a3dCYWY3dHE0M1BBeU04cS9PZzE2Vjdpa1NONENkSG9UMFQ1NUtNVW5nRSs0?=
 =?utf-8?B?TU0va2NlZjdWamtRaVRqdlZIcndxaFlONXlWOGlWY3NFSktiUi9vS0ZjMW1V?=
 =?utf-8?B?K2lBYkxKelpyL25oeHZUQm1YanBOcUdJWG0vVjNqdzFtNHY1U2tvM2ltc1BQ?=
 =?utf-8?B?WDdXenpxU01WZ1QxbnhxU0J2RjBubGJyUGY4dVVnWEtibnpyOFhKT1hJeGdn?=
 =?utf-8?B?U3RuZDIwV1RBVm1udzdWRXNaR093WDBPdVVEUFdTeFZYY0l6UUdJOGZtWTMx?=
 =?utf-8?B?dy9uOUxGUnEydmV5M2lTc1VsdHZxaGZyTjc0MzdwY1orTkVnanRWYVhDR1hQ?=
 =?utf-8?Q?ewJA=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?bVNPTW9KRGx2N2FZcjlHdVdUSnVnTWJFOGE3Qys4WDlrQ0NtOE5uZFJoWFN2?=
 =?utf-8?B?WTVBeWdJWWtCV3RsWHRhYUhWc25UVThDZzN2ZmtySWJlV0thbWo5elZlem5p?=
 =?utf-8?B?U29reUpMVG5ROWFSZXZXWHo4bVE3TUY3R2JRNFI3ZTl1eUQ3alhZMTIyTFRU?=
 =?utf-8?B?VHByNlROV3VSR3VsTU9xTzlQbS9xYTZEWDIrZjBQZmVRYktqK0lONmM1ZlpV?=
 =?utf-8?B?NUQ0RHBjLzQ5QUhSM0R4UDBnVDdONDU3RHUxcTlQVGxsU25hRnhLa0lVZHdH?=
 =?utf-8?B?bmpkUFRubTRnWjk1dlNjSkt4ODVDcnJudnlrNHFtV0o4UnAwNTdMb3FwMW03?=
 =?utf-8?B?QkMzbUNUNW04NXk3ek8zdzNLZ1dTNTNzZTNxTE1ZcEVJOFhFZExXa0x3SXNy?=
 =?utf-8?B?UG9HN2FXdVI4Z3IvbDhqNEFSbGVDYmtFU2U4L0VLOHc5SXM3ZVpTWEJHUG9F?=
 =?utf-8?B?VDZLRzBKdkN6dG44WG9HcVZCclhwSjhLL21kN2hzNGgwUjFEazVTR3RrRWxv?=
 =?utf-8?B?NDIwRlRja0NlZjdpaUNpckhhY0Qvd2VCc2RBYVdmVDBvQzBWbmdkaElNZTNj?=
 =?utf-8?B?WU1rVi9mcElUNWM2RS92WUtKaWs3ckFZb2hNYjVXTFJjV3QzaTFwR0hvUzJX?=
 =?utf-8?B?UUdRd3dCZjBQaUdwNzZ4OHd1Z1M2NlFXcUFWU1B3dlVxVFF0SjZRWk9pRzZ4?=
 =?utf-8?B?Y3BqVjhLdGI2Y1ZFMVlLVVdKZUhHR3h3TmtzV2ZUYzY5cHFJRnRqOVBrVmJE?=
 =?utf-8?B?OExFQjdEczZmR2pxNmZZVzJMc3VudmVRbGgzYXQrdHZhVWpOdjVyak1WUUNz?=
 =?utf-8?B?THFrTnNRYmhsTlphZDNxRk00UDF3MDJuYTRyejZOTklxUjhYS2lyanZVTnVz?=
 =?utf-8?B?eG41dWdGUmpvZlhjRERQS3QwSWhkSm9zT3FZYjJzL3JiWEl5UEV1WDRCNTNJ?=
 =?utf-8?B?TjIvWDJQR1NRNXZIQVpqVEh0bWg5ZnF2dDVIK0hZQytzNXY3dHpIaXRVK2o2?=
 =?utf-8?B?aWZBZ214cUgyelVBN0lPSUMwRVBEcWZmL0x5L21qMzQxY1NFSmg5U0hpVnRD?=
 =?utf-8?B?SXB0Y2pYUWRSZEdJNWNxYTBuZVY1OTByK0JrREk3VjAzeEhOU3dKcEFHZkE5?=
 =?utf-8?B?VXNOTXFIS0ROUkNTOGdTY2FqNWZEV2RyK2pNNG1zRU5PeWtWV01PUUZWTkNB?=
 =?utf-8?B?eGZzK0oyM0dHeHRXc0xFbmdqSVlncTJQSWxjaUZ1SVBPRjZSK3djK0FhRnZr?=
 =?utf-8?B?S2pJcFRMM3gwYlVNUHRLOFdaNlA3MEQrak01OTNnR2N0MUNUK3NSN3RJdGND?=
 =?utf-8?B?azVOMFJsSm1xUFdvVTVBTjN5bzhqM2l2ZDZQbW1wY0lIYTA5S2hkMUV1cFk5?=
 =?utf-8?B?NHVIRklhd21nRndSZ1FRS3p3K0FqMDlRRnRiM2hBRzhRR0FNRmo4NG1oaXF5?=
 =?utf-8?B?S0xIR2Jud3dmVXJWQ01mMDNYTjVYT01OdHlrRXFoZnZjM0tKelRIaWtsclJi?=
 =?utf-8?B?KzlXRURjN3B0ZWhsTTBwRktOWlk4UUpIWmZqdEJrd1Y4Nlc1SVdnM3I1WUNO?=
 =?utf-8?B?bERuc0c5bXdEajkrRTNiWGN5bVVOb09TVmU2NjEyYVhpRHByVENmT3hSeXVx?=
 =?utf-8?B?YnBtdXdscW1pVHEwY2FyOVFsSHdudlFybHpaM2ZDZWRYZ0loVlh2VEZxK1o4?=
 =?utf-8?B?M0VCeWhXd3BpZmNVMWZLU0JsVHhtTjl1eDBieE1VRWI4ck5mWDBIS2c1djNr?=
 =?utf-8?B?dHI2YUY4NFA2TERzckdOQjllYW8xN2Q1Qi93bm82Ulhha1NWQVZKZFJpSk02?=
 =?utf-8?B?NVBDNitjUmw0R2d2T0t1aHN3c2FKL3dWU3ZtWnRoQ0dnL0x5Zjg4Q1BmY3pO?=
 =?utf-8?B?SitxRE9IWlMzRzJVNUpON0RzdFduV1ZBSTkxeGQycVlVQ2RMS2dPUkNObHhP?=
 =?utf-8?B?K0dRZ1JLaWx6TGM5a1BnOTVYcUYxN05xUDh1YlEwMkRvazNFeFdEdHJ3eUVm?=
 =?utf-8?B?bEx0MUVwbkIrOHA1TVhDYzJoblZ1TUhrRHlvV0hjeGtWQVJZQzdrY0ZtN3hH?=
 =?utf-8?B?bFM4dllsUzJackdvdldKQWRRZnI0dUtwbjFENFgxbGdkTkhjbk1SWk12MFBh?=
 =?utf-8?B?eEtWVUZGV1ZsQlRPTjBxSC9tc04rdXFMelNRWitpaG5YVGlQRkRpMzArQ0Jn?=
 =?utf-8?B?NzRLSnFrNlM4OVQ3Q0wwdENVM3JpRjg2aHd1eTFlemFJZkJOVlNHbVQ0dlRV?=
 =?utf-8?B?bm1MWGFWT0V6T09XdjRjeHcyelkwcTFTejJ6Z0xuSGhsRDA0cHYzcnJQTU1V?=
 =?utf-8?Q?S/Cr2CbhouxBuR7iL9?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea1dabfc-57a4-49c3-45dc-08de6d90f5aa
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2026 19:24:09.9371
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GJFkKjYtJdZ63GjZvoy+zOJ5TQ9ppFmLHME21nT/t1zJbctDOVvqJNHxMFFATSYP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6838
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[babu.moger@amd.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	TAGGED_FROM(0.00)[bounces-71134-lists,kvm=lfdr.de];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[amd.com:+]
X-Rspamd-Queue-Id: C470114747A
X-Rspamd-Action: no action

Hi Tony,

On 2/13/26 11:02, Luck, Tony wrote:
> On Fri, Feb 13, 2026 at 10:37:48AM -0600, Moger, Babu wrote:
>> Hi Reinette,
>>
>> On 2/10/2026 10:17 AM, Reinette Chatre wrote:
>>> Hi Babu,
>>>
>>> On 1/28/26 9:44 AM, Moger, Babu wrote:
>>>>
>>>> On 1/28/2026 11:41 AM, Moger, Babu wrote:
>>>>>> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
>>>>>>> On 1/27/2026 4:30 PM, Luck, Tony wrote:
>>>>>> Babu,
>>>>>>
>>>>>> I've read a bit more of the code now and I think I understand more.
>>>>>>
>>>>>> Some useful additions to your explanation.
>>>>>>
>>>>>> 1) Only one CTRL group can be marked as PLZA
>>>>> Yes. Correct.
>>> Why limit it to one CTRL_MON group and why not support it for MON groups?
>> There can be only one PLZA configuration in a system. The values in the
>> MSR_IA32_PQR_PLZA_ASSOC register (RMID, RMID_EN, CLOSID, CLOSID_EN) must be
>> identical across all logical processors. The only field that may differ is
>> PLZA_EN.
>>
>> I was initially unsure which RMID should be used when PLZA is enabled on MON
>> groups.
>>
>> After re-evaluating, enabling PLZA on MON groups is still feasible:
>>
>> 1. Only one group in the system can have PLZA enabled.
>> 2. If PLZA is enabled on CTRL_MON group then we cannot enable PLZA on MON
>> group.
>> 3. If PLZA is enabled on the CTRL_MON group, then the CLOSID and RMID of the
>> CTRL_MON group can be written.
>> 4. If PLZA is enabled on a MON group, then the CLOSID of the CTRL_MON group
>> can be used, while the RMID of the MON group can be written.
>>
>> I am thinking this approach should work.
> I can see why a user might want to accumulate all kerrnel resource usage
> in one RMID, separately from application resource usage. But wanting to
> subdivide that between different tasks seems a stretch.
>
> Remember that there are 3 main reasons why the kernel may be entered
> while an application is running:
>
> 1) Application makes a system call
> 2) A trap or fault (most common = pagefault?)
> 3) An interrupt
>
> The application has some limited control over 1 & 2. None at
> all over 3.
>
> So I'd like to hear some real use cases before resctrl commits
> to adding this complexity.
>
Imagine you have a strongly throttled thread going into the kernel and 
grabbing a global lock in kernel. At the same time, an unthrottled high 
priority  thread
enters the kernel on any other CPU and tries to acquire the same lock. 
Because the lock holder is slowed down, it runs slow inside the
critical section protected by  the lock. The high priority thread is now 
slowed down causing the priority inversion. We have seen this happening 
in certain workloads.

The only way to avoid this problem is to ensure that any thread entering 
the kernel operates with the same throttling level.
Only viable option is unlimited bandwidth in kernel for all the threads. 
This means the kernel needs to either run on a different CLOSID or the 
setting of the CLOSID
needs to change on kernel entry and exit at each entry point (syscall, 
trap, fault, ...). We have tried manually changing the CLOSID during 
kernel entry and exit and found it very expensive.
The only sensible way of doing this is via hardware support and that is 
what PLZA enables.

Thanks
Babu



>>> Limiting it to a single CTRL group seems restrictive in a few ways:
>>> 1) It requires that the "PLZA" group has a dedicated CLOSID. This reduces the
>>>      number of use cases that can be supported. Consider, for example, an existing
>>>      "high priority" resource group and a "low priority" resource group. The user may
>>>      just want to let the tasks in the "low priority" resource group run as "high priority"
>>>      when in CPL0. This of course may depend on what resources are allocated, for example
>>>      cache may need more care, but if, for example, user is only interested in memory
>>>      bandwidth allocation this seems a reasonable use case?
>>> 2) Similar to what Tony [1] mentioned this does not enable what the hardware is
>>>      capable of in terms of number of different control groups/CLOSID that can be
>>>      assigned to MSR_IA32_PQR_PLZA_ASSOC. Why limit PLZA to one CLOSID?
>>> 3) The feature seems to support RMID in MSR_IA32_PQR_PLZA_ASSOC similar to
>>>      MSR_IA32_PQR_ASSOC. With this, it should be possible for user space to, for
>>>      example, create a resource group that contains tasks of interest and create
>>>      a monitor group within it that monitors all tasks' bandwidth usage when in CPL0.
>>>      This will give user space better insight into system behavior and from what I can
>>>      tell is supported by the feature but not enabled?
>>
>> Yes, as long as PLZA is enabled on only one group in the entire system
>>
>>>>>> 2) It can't be the root/default group
>>>>> This is something I added to keep the default group in a un-disturbed,
>>> Why was this needed?
>>>
>> With the new approach mentioned about we can enable in default group also.
>>
>>>>>> 3) It can't have sub monitor groups
>>> Why not?
>> Ditto. With the new approach mentioned about we can enable in default group
>> also.
>>
>>>>>> 4) It can't be pseudo-locked
>>>>> Yes.
>>>>>
>>>>>> Would a potential use case involve putting *all* tasks into the PLZA group? That
>>>>>> would avoid any additional context switch overhead as the PLZA MSR would never
>>>>>> need to change.
>>>>> Yes. That can be one use case.
>>>>>
>>>>>> If that is the case, maybe for the PLZA group we should allow user to
>>>>>> do:
>>>>>>
>>>>>> # echo '*' > tasks
>>> Dedicating a resource group to "PLZA" seems restrictive while also adding many
>>> complications since this designation makes resource group behave differently and
>>> thus the files need to get extra "treatments" to handle this "PLZA" designation.
>>>
>>> I am wondering if it will not be simpler to introduce just one new file, for example
>>> "tasks_cpl0" in both CTRL_MON and MON groups. When user space writes a task ID to the
>>> file it "enables" PLZA for this task and that group's CLOSID and RMID is the associated
>>> task's "PLZA" CLOSID and RMID. This gives user space the flexibility to use the same
>>> resource group to manage user space and kernel space allocations while also supporting
>>> various monitoring use cases. This still supports the "dedicate a resource group to PLZA"
>>> use case where user space can create a new resource group with certain allocations but the
>>> "tasks" file will be empty and "tasks_cpl0" contains the tasks needing to run with
>>> the resource group's allocations when in CPL0.
>> Yes. We should be able do that. We need both tasks_cpl0 and cpus_cpl0.
>>
>> We need make sure only one group can configured in the system and not allow
>> in other groups when it is already enabled.
>>
>> Thanks
>> Babu
>>
>>> Reinette
>>>
>>> [1] https://lore.kernel.org/lkml/aXpgragcLS2L8ROe@agluck-desk3/
>>>
> -Tony
>

