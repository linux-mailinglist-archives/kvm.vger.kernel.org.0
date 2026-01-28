Return-Path: <kvm+bounces-69361-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0ASdGqZKemkp5AEAu9opvQ
	(envelope-from <kvm+bounces-69361-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:43:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id E40BFA710D
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 18:43:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 642363039CA8
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 17:41:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 620A436BCE6;
	Wed, 28 Jan 2026 17:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="ak5EUn2+"
X-Original-To: kvm@vger.kernel.org
Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013062.outbound.protection.outlook.com [40.93.201.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C07C31579B;
	Wed, 28 Jan 2026 17:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769622091; cv=fail; b=fOPMKX919VTfzAY9S7v6mOmUTM8KFEjZ1RDkc1c7G8VkUsY6g1QAPUsCEh2CBpDRBjRm3cmlOTLRrBcGTQpJ3xioIUz0WzpKN0w97fg3erLNM87c76IyQ3fo1dPY24maUHndPWqCpbkP0JoxVQt5ejJQHzHOhYDCbdfXVs7Ys8I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769622091; c=relaxed/simple;
	bh=z45R3Y2/lmUhp2woTMWwt6mgkBaRPBCaTTyh9tGYhL4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dt4PUFpZOO6ccUfP1tIXubpG1etao1oX3sFWhzgQARQj9qw9+Ks6lV6FgKQeUl7ji3Q5Qv3iNXD1Ic2TAK2Ylv7lMscywf/49b/Nk5S5pvKlobDUgYchxg+/MooLik4fSajmy99TzB2+4lihat17LmAJCDof30cYHEJtOk5RH4k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=ak5EUn2+; arc=fail smtp.client-ip=40.93.201.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=Im4G+fEwtEr3aEtQUrgkiSgQEb2JB8jjpipfNw2H5ohXwlk/cg8s8x4PaHqtcCo1xFhCO8fPt6NG6J9bG/4FqT/EK47IH4+q+v3Ko7amPYxLJhmfb87v4GjLWAs80WGiwEbcqoWlU/2CU82G4DMg/UHzsZCcuygmYPA+XhRsGXte2dQslOeEZhuAaPaaKQHMAwhnpuo7vnLN8eazITP6qomj+WbQRb+WoQog10qaV1Try/CEk6mmE/vKm6v713r1L3sxbXBVInZUFKRcQVblWrl23wWQ+mx2Mi94G9gCx5JuCLZjsw1CuYLqkkbcWy5Y9BO8q8QxdzJ1P47yYzAJJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GcQL/f9Svck/8aIRyZVVzeRWZ78pBDiNuZTUPwlxkJQ=;
 b=ADv6z98ZEjqc7QrmaRtDRg0VkMXkKTtXFbrNnprzA1aAdTTDUwqyqTJDYWETiW2rY+eW2Crci59gXGU+/3ilOaiiByCuSsuzpM8ViNNJDzymLj2B3jpgwNCc/vbikg8iyxJ/8h5tP/XxJCWbp2drE2E6RX9voX+Qz8G7E1/O7CO5ALTbFk/dRuhx/YsUPy6Rw9OfQVrQxCQApyWNzBzeICQ6ZLEYgmPIgOBPbyDqm1uU0KIhziRaiuEikZ3ajUAogqtjptKv7cWYiyV0YtB1QifYihCR50URb0vPCL9uRwE6q68QyqAm2X5TmOPAGGf6WXjB5mzEzrQkGh9Jnz13MQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GcQL/f9Svck/8aIRyZVVzeRWZ78pBDiNuZTUPwlxkJQ=;
 b=ak5EUn2+9RmPxiHs2iZC1k0iSde/v7Yjufy6TyyZ5UY9laJ5I7M6ebBVjTJrLasEdS0H41eMQ+lPcW3M3pGb0dL+FSN1lU7MtqJwXGQRoxSTBnTEiA0kNKOFGFyEN+Rve7MrRqbCVLYh++9LTtxtu9ztDTHaqlpzOv0+b/w7j8A=
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 (2603:10b6:20f:fc04::bdc) by MW4PR12MB7438.namprd12.prod.outlook.com
 (2603:10b6:303:219::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9564.7; Wed, 28 Jan
 2026 17:41:25 +0000
Received: from IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0]) by IA0PPF9A76BB3A6.namprd12.prod.outlook.com
 ([fe80::4d0e:603a:42fc:7c0%3]) with mapi id 15.20.9542.015; Wed, 28 Jan 2026
 17:41:25 +0000
From: "Moger, Babu" <Babu.Moger@amd.com>
To: "Luck, Tony" <tony.luck@intel.com>, "Moger, Babu" <Babu.Moger@amd.com>
CC: "corbet@lwn.net" <corbet@lwn.net>, "reinette.chatre@intel.com"
	<reinette.chatre@intel.com>, "Dave.Martin@arm.com" <Dave.Martin@arm.com>,
	"james.morse@arm.com" <james.morse@arm.com>, "tglx@kernel.org"
	<tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"peterz@infradead.org" <peterz@infradead.org>, "juri.lelli@redhat.com"
	<juri.lelli@redhat.com>, "vincent.guittot@linaro.org"
	<vincent.guittot@linaro.org>, "dietmar.eggemann@arm.com"
	<dietmar.eggemann@arm.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
	"bsegall@google.com" <bsegall@google.com>, "mgorman@suse.de"
	<mgorman@suse.de>, "vschneid@redhat.com" <vschneid@redhat.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"pawan.kumar.gupta@linux.intel.com" <pawan.kumar.gupta@linux.intel.com>,
	"pmladek@suse.com" <pmladek@suse.com>, "feng.tang@linux.alibaba.com"
	<feng.tang@linux.alibaba.com>, "kees@kernel.org" <kees@kernel.org>,
	"arnd@arndb.de" <arnd@arndb.de>, "fvdl@google.com" <fvdl@google.com>,
	"lirongqing@baidu.com" <lirongqing@baidu.com>, "bhelgaas@google.com"
	<bhelgaas@google.com>, "seanjc@google.com" <seanjc@google.com>,
	"xin@zytor.com" <xin@zytor.com>, "Shukla, Manali" <Manali.Shukla@amd.com>,
	"dapeng1.mi@linux.intel.com" <dapeng1.mi@linux.intel.com>,
	"chang.seok.bae@intel.com" <chang.seok.bae@intel.com>, "Limonciello, Mario"
	<Mario.Limonciello@amd.com>, "naveen@kernel.org" <naveen@kernel.org>,
	"elena.reshetova@intel.com" <elena.reshetova@intel.com>, "Lendacky, Thomas"
	<Thomas.Lendacky@amd.com>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"peternewman@google.com" <peternewman@google.com>, "eranian@google.com"
	<eranian@google.com>, "Shenoy, Gautham Ranjal" <gautham.shenoy@amd.com>
Subject: RE: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Thread-Topic: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and
 context switch handling
Thread-Index: AQHcixsWS5siCa4mREmJKi+gYe8F37Vmot6AgAElsYCAABPBgIAACB3g
Date: Wed, 28 Jan 2026 17:41:24 +0000
Message-ID:
 <IA0PPF9A76BB3A655A28E9695C8AD1CC59F9591A@IA0PPF9A76BB3A6.namprd12.prod.outlook.com>
References: <cover.1769029977.git.babu.moger@amd.com>
 <17c9c0c252dcfe707dffe5986e7c98cd121f7cef.1769029977.git.babu.moger@amd.com>
 <aXk8hRtv6ATEjW8A@agluck-desk3>
 <5ec19557-6a62-4158-af82-c70bac75226f@amd.com>
 <aXpDdUQHCnQyhcL3@agluck-desk3>
In-Reply-To: <aXpDdUQHCnQyhcL3@agluck-desk3>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Enabled=True;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_SetDate=2026-01-28T17:34:47.0000000Z;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Name=AMD
 Internal Distribution
 Only;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_ContentBits=3;MSIP_Label_dce362fe-1558-4fb5-9f64-8a6240d76441_Method=Standard
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA0PPF9A76BB3A6:EE_|MW4PR12MB7438:EE_
x-ms-office365-filtering-correlation-id: 6dc37668-8143-4941-0eb8-08de5e947553
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|7416014|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?RCMh7w1OQyLJAyC5wqeWiIUc0K7g+EQvnHrI7OiL9OFR27iD+6IahVKsxlEf?=
 =?us-ascii?Q?789ytKmn80IgBes625+wvOOurEUEkdmF84/y5swHeZozxpTmSja5CjEOPSt+?=
 =?us-ascii?Q?DqaDW9v4FUV7yxP2ZFg7EYNIIHU3rzwrvOZtsaG1k7diU1K7tr2X2tXiqJ4g?=
 =?us-ascii?Q?5RRzgG/GidPeH7XRmpUrn4Ac4ZjEjjqjBCz/x3dq/XFTYCPn8RhaxhXlu/F3?=
 =?us-ascii?Q?o30+3n2ZsHkKanIyWxrSanOPYw5ZNS8r4woHxfH5fbFkP3i3/apLl695N/22?=
 =?us-ascii?Q?hf/VEEFswz1g37vRbD7aBmlOAqmYpYeSiH+I0cG1/7ZGW114pzgTE0eJwjrZ?=
 =?us-ascii?Q?8rOhVmOECotDVjAh1ekzDcEuHYNO/nAZhiaJVxsx95bUrQjOh07ECg22gVQQ?=
 =?us-ascii?Q?I9NFFtcSWWPr82EoZsjoaUjCOmrEkhZQBV4btdVkZM4ASIe14CuVeuJH7RfZ?=
 =?us-ascii?Q?QGFeSsc0YoRX97aIjcDVCuvvruxNxe2d3ja4NIa6VKGXH3yEZQYE7/jlqLzl?=
 =?us-ascii?Q?0zmyD33cFMjXQQBS3by7dctk8BkVFcNBWj3rKvc/ErnjLVJIxi6ihsvAfu8C?=
 =?us-ascii?Q?BUfmjZVLvbob2fw79pE6U16EfC8BeYhzF3Pzk89iLB73FCMp4xbod/XP3MFi?=
 =?us-ascii?Q?Ht71mit36h9QJwcSMQ7g17IpjLX9YUJqvvID+dFuyVJ6uS3A/ZArLwVqGR/Q?=
 =?us-ascii?Q?pndpdVYR9BRUXEwvj+sUSf8hE5cE1sb6GffS/kx7ss6cPx45IB25gwrxr6ho?=
 =?us-ascii?Q?gQZViDDi13mg3Wv4p3CNNX9L7BUcT2cxketJ6z1aNiQUr08495n5rLA6H9E8?=
 =?us-ascii?Q?g2LguVJXB+Og8qzTD6YcoWSJhG1hnql2QW2h9DHQYoekQRdc4g8dS7C9xbR+?=
 =?us-ascii?Q?03+I8ReLBnu4+IkJynsaQ0F9PEvslJJJNbWfOEJiAH6kjr/hjKmXs7L16JQA?=
 =?us-ascii?Q?pPk4OC5XFN+y8P6arqC4cH7gQQ9dV+X74pEi/xw1QbX5e4S8shzrtoFwYbiE?=
 =?us-ascii?Q?ALe+GDDAPMHPo7Z8MSD/vAfj/aZIIqsQhUZW56JbThdUjHknOvGXpnRjVqkC?=
 =?us-ascii?Q?K4SYCpYPLcX+I/X2vW108oSL2sJelrwL7MiLePiso/gSggsv3TvHfMaLsl94?=
 =?us-ascii?Q?Iyt3y8nL31WNq9zhUMsrdXmmhk94lLGR5B3Mx8Ge1jtmlQ+vEqB21wVe0bSR?=
 =?us-ascii?Q?sXecV6XNzw8r0ylnMZTs4gJrkrrgw1ARGiZJlRsNWcCCMsOUVDGjcUBhLczZ?=
 =?us-ascii?Q?t93uRxW3q52uGqgnrTbL8Wy29h6tnDcATL9pxKE3deZKXzzYtazr5omxrucq?=
 =?us-ascii?Q?MHRz7MqWXiV4cqtw9CuyvwXWXO19tKC/yPXH+QLRTsSMEoR8Su9Q7fyVK95+?=
 =?us-ascii?Q?d7r/YXxKBRyBYOnFj5TRTUPPHtWAk+6SDL9pS/qT+aTa0s0UyPlQxXvBZgQB?=
 =?us-ascii?Q?I2RoKiHK321DOVaz8O7djg3BfK1xZnaOT1V+fk5obDBjojKT/jnuskfSGfIK?=
 =?us-ascii?Q?elirtbo8CouC/OW0PJgAXA3C/En07zX3wbvzIwXzIUVSdrZnio1cpT8XBrkI?=
 =?us-ascii?Q?4/LPTDMF+CQHMpvKWIhlBUUJeaFlUiudcXaUWZmXppO6L7Af2QihFDqNB7Sp?=
 =?us-ascii?Q?oUFCaEHKA6pb/IkfgMw36rM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PPF9A76BB3A6.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(7416014)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?4UsQayMpgNwtLTCl8HFPmF9GJ97JmMqbORdqThEGPvZOVnyJPZeVyjlNe8IE?=
 =?us-ascii?Q?auCMyP0RZza26pA/S1rulWwpvuTHNZYkBQQuF6BguAMEA9jg7H/sgOovcYV9?=
 =?us-ascii?Q?b0F/jAr8iSvOIsI2yBLecInyM8mQhxPjjE70ubPcouWs2fnqdVLHCZmwbjCY?=
 =?us-ascii?Q?Hf70cLlUUAmYYvvrIdltpK/ydOrJ3pWQ/mh7xZV1SKIVRgbF95eXJX4j6AMw?=
 =?us-ascii?Q?8iNPp7NzouM1mOjARUqeQDqNjwzliSrTaP6twFX4n6C5b+CKpCvEoBTjy/0k?=
 =?us-ascii?Q?WreWEaIOwBTDbGWrr3Gpuhi05Gu420PAbRxjJEGHjn7zUX43VQRxK73uLMsr?=
 =?us-ascii?Q?e3t8YcpEikETUyPtKLKH7+pmqayeeTqRCWmYOvvvSq+jo99yM8U/iFfbo67E?=
 =?us-ascii?Q?T8R36ncn6YVxFJDRC6frN8IOnDF0PKdfSAtbqhcoilXStGnXKlpaci/a8I50?=
 =?us-ascii?Q?hyum/rwLhXuncHYEoX/3dIaxvF6BOUbK8Yab5sW8JnbYdTyVmUX416d4J9m4?=
 =?us-ascii?Q?rNNfZPvOTOe3i+l3mkBdYfZktf7V9ZEH632DcKv5hHkx2bI2+9dQGP8k2yWJ?=
 =?us-ascii?Q?4j+tMqI+FyS+xXbMNFMDPPqtFFtZm5kZaZrhRYPJwDyGPhH+d06ZQF8+4gEq?=
 =?us-ascii?Q?bjIiMZHMrwJp4w4heA8jR0TQg6YQuCIJ64zZUTmA9DnG1ntufasP/DqsmIWb?=
 =?us-ascii?Q?oMxBwjj/Q8YSkxlHRKysGQvrPse7F1InRYHWzIl6o657x3dPTMlVRK0ylBGm?=
 =?us-ascii?Q?oDG+q071hSNO0pZHSMIF+imBpvnihmVPNpS+DvHq2PhKTEus4ALpf7fGxiHM?=
 =?us-ascii?Q?YdyQdzwhPSVRUBukQ3+vdsIMTyLYElbgYfNaK2Z/N0jtBOZHgWwHoKUAQixD?=
 =?us-ascii?Q?E6waptqRpf4mslluo3Qyh8iHFZTmxI0ZOs1uVfzmPCSTeSdybScUFvqB4n9H?=
 =?us-ascii?Q?F+cTnsMqgyLqQSjKZYBq5AQOho5JNwS6h6NQ/Hik/L3WAuEivDgHoQ+PtohC?=
 =?us-ascii?Q?RT77OqtWt3PFYPxoV9US/EbGq/UPAWDOoULpLksvdBDgIqtB+qR5hnmIG4bU?=
 =?us-ascii?Q?o0Ufy/8k0PrXUl3nMoqGyFrBY2flmFvzGsxuPUxvxT4Ypnwtvw+Lu6NomuLi?=
 =?us-ascii?Q?vvHdwVGBkfN44/vd/gRxfPfFnWhwlvX/MifyUO0kIOovLxtdJCjh8iJ5uwgc?=
 =?us-ascii?Q?XCP5AoSNiy4OzkzZ8gY00kH9srQXL1arDhqp4wVgjJZ3Mb6pBdmBsecuWRCf?=
 =?us-ascii?Q?PNOMh3y2ITDkWl4LjBuznFdbuuqf7pLG9+kV/Z25u/s6KQnTibsf4r2FdaCi?=
 =?us-ascii?Q?6JhXb0sC88JJwpW5FF8Q9FpKXDJC0kRdqSLCJ3cxREYnJ4JsVgYXfMYDIQvj?=
 =?us-ascii?Q?yS7h6XwEmt/32ltxwfuNYzVwOEHbaQITZktcprZVkltN1KkcGAf5Iew3sa7o?=
 =?us-ascii?Q?SqT3MWJ5VBtwQ9XemRRj1niDa29uf7uI15bGBUBTJX+tbj9BifA2EjMuaT+c?=
 =?us-ascii?Q?nwlX3scGp7QeN8zGrDueGarOPeNE60X+7dWpQBagc+lMkFJ289qenpLfCwb/?=
 =?us-ascii?Q?Q2T26yYaToC4X2PMKQueJ5dBvJ27k9PQR/5FOYcb1MlJDIJuOcJ+lYPuobuW?=
 =?us-ascii?Q?O0AOXaThJXsgWT/Lz++kT1HkywKz/nTgdjtXLrkhynuPH9GICUGRS8bJDcL+?=
 =?us-ascii?Q?OCNKu2fFJTLM09OjpGfw/7c2AGYhtuY5WW7R5apZMYefo73m?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA0PPF9A76BB3A6.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc37668-8143-4941-0eb8-08de5e947553
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jan 2026 17:41:24.9561
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cXCAkkXDn8xUDlDv5+5eQ5o9wuB2oCL+c1Wll2pBRdqrctRtSTqeaQcfW/22rZA6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7438
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[amd.com,quarantine];
	R_DKIM_ALLOW(-0.20)[amd.com:s=selector1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-69361-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[44];
	DKIM_TRACE(0.00)[amd.com:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[Babu.Moger@amd.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: E40BFA710D
X-Rspamd-Action: no action

[AMD Official Use Only - AMD Internal Distribution Only]

> -----Original Message-----
> From: Luck, Tony <tony.luck@intel.com>
> Sent: Wednesday, January 28, 2026 11:12 AM
> To: Moger, Babu <bmoger@amd.com>
> Cc: Babu Moger <babu.moger@amd.com>; corbet@lwn.net;
> reinette.chatre@intel.com; Dave.Martin@arm.com; james.morse@arm.com;
> tglx@kernel.org; mingo@redhat.com; bp@alien8.de; dave.hansen@linux.intel.=
com;
> x86@kernel.org; hpa@zytor.com; peterz@infradead.org; juri.lelli@redhat.co=
m;
> vincent.guittot@linaro.org; dietmar.eggemann@arm.com; rostedt@goodmis.org=
;
> bsegall@google.com; mgorman@suse.de; vschneid@redhat.com; akpm@linux-
> foundation.org; pawan.kumar.gupta@linux.intel.com; pmladek@suse.com;
> feng.tang@linux.alibaba.com; kees@kernel.org; arnd@arndb.de; fvdl@google.=
com;
> lirongqing@baidu.com; bhelgaas@google.com; seanjc@google.com;
> xin@zytor.com; manali.shukla@amd.com; dapeng1.mi@linux.intel.com;
> chang.seok.bae@intel.com; mario.limonciello@amd.com; naveen@kernel.org;
> elena.reshetova@intel.com; thomas.lendacky@amd.com; linux-
> doc@vger.kernel.org; linux-kernel@vger.kernel.org; kvm@vger.kernel.org;
> peternewman@google.com; eranian@google.com; gautham.shenoy@amd.com
> Subject: Re: [RFC PATCH 13/19] x86/resctrl: Add PLZA state tracking and c=
ontext
> switch handling
>
> On Wed, Jan 28, 2026 at 10:01:39AM -0600, Moger, Babu wrote:
> > Hi Tony,
> >
> > Thanks for the comment.
> >
> > On 1/27/2026 4:30 PM, Luck, Tony wrote:
> > > On Wed, Jan 21, 2026 at 03:12:51PM -0600, Babu Moger wrote:
> > > > @@ -138,6 +143,20 @@ static inline void __resctrl_sched_in(struct
> task_struct *tsk)
> > > >                 state->cur_rmid =3D rmid;
> > > >                 wrmsr(MSR_IA32_PQR_ASSOC, rmid, closid);
> > > >         }
> > > > +
> > > > +       if (static_branch_likely(&rdt_plza_enable_key)) {
> > > > +               tmp =3D READ_ONCE(tsk->plza);
> > > > +               if (tmp)
> > > > +                       plza =3D tmp;
> > > > +
> > > > +               if (plza !=3D state->cur_plza) {
> > > > +                       state->cur_plza =3D plza;
> > > > +                       wrmsr(MSR_IA32_PQR_PLZA_ASSOC,
> > > > +                             RMID_EN | state->plza_rmid,
> > > > +                             (plza ? PLZA_EN : 0) | CLOSID_EN | st=
ate-
> >plza_closid);
> > > > +               }
> > > > +       }
> > > > +
> > >
> > > Babu,
> > >
> > > This addition to the context switch code surprised me. After your
> > > talk at LPC I had imagined that PLZA would be a single global
> > > setting so that every syscall/page-fault/interrupt would run with a
> > > different CLOSID (presumably one configured with more cache and memor=
y
> bandwidth).
> > >
> > > But this patch series looks like things are more flexible with the
> > > ability to set different values (of RMID as well as CLOSID) per group=
.
> >
> > Yes. this similar what we have with MSR_IA32_PQR_ASSOC. The
> > association can be done either thru CPUs (just one MSR write) or task
> > based association(more MSR write as task moves around).
> > >
> > > It looks like it is possible to have some resctrl group with very
> > > limited resources just bump up a bit when in ring0, while other
> > > groups may get some different amount.
> > >
> > > The additions for plza to the Documentation aren't helping me
> > > understand how users will apply this.
> > >
> > > Do you have some more examples?
> >
> > Group creation is similar to what we have currently.
> >
> > 1. create a regular group and setup the limits.
> >    # mkdir /sys/fs/resctrl/group
> >
> > 2. Assign tasks or CPUs.
> >    # echo 1234 > /sys/fs/resctrl/group/tasks
> >
> >    This is a regular group.
> >
> > 3. Now you figured that you need to change things in CPL0 for this task=
.
> >
> > 4. Now create a PLZA group now and tweek the limits,
> >
> >    # mkdir /sys/fs/resctrl/group1
> >
> >    # echo 1 > /sys/fs/resctrl/group1/plza
> >
> >    # echo "MB:0=3D100" > /sys/fs/resctrl/group1/schemata
> >
> > 5. Assign the same task to the plza group.
> >
> >    # echo 1234 > /sys/fs/resctrl/group1/tasks
> >
> >
> > Now the task 1234 will be using the limits from group1 when running in =
CPL0.
> >
> > I will add few more details in my next revision.
> >
>
> Babu,
>
> I've read a bit more of the code now and I think I understand more.
>
> Some useful additions to your explanation.
>
> 1) Only one CTRL group can be marked as PLZA

Yes. Correct.

> 2) It can't be the root/default group

This is something I added to keep the default group in a un-disturbed,

> 3) It can't have sub monitor groups
> 4) It can't be pseudo-locked

Yes.

>
> Would a potential use case involve putting *all* tasks into the PLZA grou=
p? That
> would avoid any additional context switch overhead as the PLZA MSR would =
never
> need to change.

Yes. That can be one use case.

>
> If that is the case, maybe for the PLZA group we should allow user to
> do:
>
> # echo '*' > tasks

Yea. It can be done.

Thanks
Babu


