Return-Path: <kvm+bounces-21646-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FEE0931792
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 17:28:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2588C282A0E
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2024 15:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DED2A18FC81;
	Mon, 15 Jul 2024 15:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VZ4AYuLd"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BA418F2FF;
	Mon, 15 Jul 2024 15:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.20
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721057282; cv=fail; b=owHo2T4W8M5R+uLAT069Rbkqz5HTAPGPlVNk0rrIwZpjiujS7CjrmPGT6P53c+Ncb/SkCryQYIT0XDmpSu4tSb8RXJSKyo8rE064q7Ar1cuP015XhHi+F+MKknuJvAMysoEvPdawgd+sL0RfXcQvo7+CeVzvY2aZV5h7ZKzQ7YI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721057282; c=relaxed/simple;
	bh=Cjex7l609TC3ib+1KGTVShwjrFpgFTDAjW4ONMoBcdw=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YCAKFka95t2JxmwzyVUp6YOT/qOS3cYowRAeiaoABsd1k8uDtOzhiGWmuJRvL2JCMh/KE1lyZS7WModrdk804y+49nUt3KMOyg/0vdPXiewhlvgHYBeF9vJiZBDlLhAhpYKhsiMGaSFAl6XSvUGZikahzR2bklgOwxVcZ8jpnjI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VZ4AYuLd; arc=fail smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721057280; x=1752593280;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Cjex7l609TC3ib+1KGTVShwjrFpgFTDAjW4ONMoBcdw=;
  b=VZ4AYuLdQNh4oymfqoEIVOO0Bw1Juil5ost8JkBGH5bicHdvxGRDmFFE
   P5Qq1YFOQXk7lNCEMsUY8qMUAKuLLHc1UANDbrHAdNCgTD8oeR5lRIkin
   7wR28Ad68QQQ4pjw8MoIUtgLESKS7vuyWLcdRQXl50rcLjaHorA6rdGO3
   IE3IfiPK2B9bbsTu3e9VZOYswP7YJ/p4xVbQMcRUVEuZo7GlMX/8GR7LQ
   aW5QiWmZMf1LEDlsy7tRJ3DYennXwvHJAa9jExePLOap6cf3UUweToG7O
   8m2NzajRp3YrE6XDk9IDqu3NLhvChD3rZ0ySPM3+hxledQ8NtfZkprk2P
   g==;
X-CSE-ConnectionGUID: xQdZ6S2hRiyN2dRKjxPqHw==
X-CSE-MsgGUID: 7ruzZfRjRhSi2D7iRsNMwA==
X-IronPort-AV: E=McAfee;i="6700,10204,11134"; a="18254157"
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="18254157"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2024 08:25:43 -0700
X-CSE-ConnectionGUID: 71n+/Qh0SnmaBd6F2U58yA==
X-CSE-MsgGUID: osDauffMSIajiXlq5lBGhA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,210,1716274800"; 
   d="scan'208";a="49746330"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa009.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 15 Jul 2024 08:25:43 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 15 Jul 2024 08:25:42 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 15 Jul 2024 08:25:42 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (104.47.74.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 15 Jul 2024 08:25:41 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c/I81VI390uuSoZNzvtiK2+d9rMvXB/OQv6vyBU5GmJMwydKJMXbuoJrx1LEu4Xq++Hjq6KpDxENU66VetFujzOuIyMnvkZo+zpm5lZ7ghyaxaoMFbVLhfl6niux3zv7bniiYG45sZrbxsSYqcIYmbEVul7+6+pGPo+FC2Hv/QFTNYrrme6s3VO/cW/wF3a0PAD6XBABoO3+p0KUQqi69pswT/weVTvht7kqob6rqY/1Y7d0TkdUSqCug+lYCEc/7fuTQ4F/hmbIcebuQMiRCQAdl+yrYU9wFXrXsIIZ/+qGdB27kLefd+sjGFUld9l9kwxEd2PfPC8n7qO86FKwgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cjex7l609TC3ib+1KGTVShwjrFpgFTDAjW4ONMoBcdw=;
 b=um00tZmXeSmHQtZEGK6f9lUwTvd/CmkJbf2i9PVghNKLetjN87rpgPwn630dEqbjOUrWXQp7VahLb4nV+M5THVa92SeLbWZEXARPtCmjnJRbG9fokidpUgWyFrQw4wzCpqgpODUqSBaHet9GjU4RQ22AA+3YTvZrjRjSfp6fGQbjYDBrBCSw/cBUiZWAXLHMeu9gIGh/cnesiSp2fK3W44Q2qDs6NovEx0wkXRkgNAhsoUYDiuZFRJmTFtRsJA6FojJdCL+gIOiaLLlAbZ1mXyO7FQCMupzaJ3oEJFhnsVDjB+UfNQ8399odWafDZoQqL6Nye7k1PQAz9AFUPg609A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 SJ2PR11MB8469.namprd11.prod.outlook.com (2603:10b6:a03:57b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7762.29; Mon, 15 Jul
 2024 15:25:36 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%3]) with mapi id 15.20.7762.027; Mon, 15 Jul 2024
 15:25:36 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: James Houghton <jthoughton@google.com>, Paolo Bonzini
	<pbonzini@redhat.com>
CC: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>, Peter Xu <peterx@redhat.org>, Axel Rasmussen
	<axelrasmussen@google.com>, David Matlack <dmatlack@google.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>
Subject: RE: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
Thread-Topic: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
Thread-Index: AQHa0yLrMREFiNTQzkGMfF5XFxrB97H3dEtw
Date: Mon, 15 Jul 2024 15:25:36 +0000
Message-ID: <DS0PR11MB637397059B5DAE2AA7B819BCDCA12@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240710234222.2333120-1-jthoughton@google.com>
In-Reply-To: <20240710234222.2333120-1-jthoughton@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|SJ2PR11MB8469:EE_
x-ms-office365-filtering-correlation-id: 4f062a21-50f1-489a-bf93-08dca4e26037
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?WVRsTHBDcjNoYzJEOFpjdVRTUVRENis1K1ZxOWRhMVA1enRRY3ZmZWVuSHBl?=
 =?utf-8?B?UnQ1WlFCMGtqeGxOemE2aU5SZkJsMUFzbXh5eitBOFhVVXYyNEdFQUxZV0JR?=
 =?utf-8?B?TFpEekIvMzJFYlZSaEE1L3pMbHRXYmVvaUI1WS9CTEtWdFd3NXVCeWwyaHdu?=
 =?utf-8?B?ZTYrQ3JqZExaTXZNRlhTOTY2bFEzTTV2Qkw3clh5UG5GOHhZMkVXdFB5a3dE?=
 =?utf-8?B?MSthZ1hnRVNBYXVVeDJWeVBWVDZsYi9aUzhCVncrbmJybFQ5TkRJSXBVaEJk?=
 =?utf-8?B?MVNHVEJ3elFLZ216V2FHTmY1T2czVFB1NmU0U0MwcnMzOHJYVzdkbVZnODE1?=
 =?utf-8?B?cGwvUStnT2tJWmlobVJCNmVLdUY3STAvdEpVdWN4NzVPMXRsSXF6ZFNkTGto?=
 =?utf-8?B?WmJUc3VpWWlJMExqMFpTekN6NzJCS1RSS1oxWE1kYkxlVnY3cHRnb3g3WWI0?=
 =?utf-8?B?SUZCMDlUZ0NBc2F2b1pQcmJXditqKzlmWEwvYU1tVWIrbU1EeUN5VEh3UERS?=
 =?utf-8?B?UXYvN1pBUHNaeit3ZlFFU0JlbXZIZVVmWVZmU3pubDNlKzVSdWtpaVZOcUtT?=
 =?utf-8?B?ZWJobU5WTVpWTWtnVVloT3FoOFJZTkJySG5pMkg3eGJWaUl1bXU2dGlkVDVV?=
 =?utf-8?B?Q3FSTEFwQ0lVclZvZHUzeWFzNU9yOG5HM3ZWbjhURUVDeS9OQmg1RHJIRHk4?=
 =?utf-8?B?ZU5IRHdvMDJYZE5jditkdUVKWDdhcG9jKzJxT0VxYnVJb0hPWHYraFFJNk9u?=
 =?utf-8?B?NjUrQzIxQ3ZBdlRORnl3Q2JYRGNENW9aZGluV2Z0S2o0RzdmWmt4ekhWUFlo?=
 =?utf-8?B?ZGZhYTllNDhIcjd1YlRZYVlLRzl1Y0xJY29EYWh5ZzBTRm56ZFdUQmpkbmVR?=
 =?utf-8?B?eXRlb1o1VTYwYmhRZHQ1bVR2K083ZEpVTXEvKzUzM0J3b1V6WWNTejVkWVlx?=
 =?utf-8?B?dUp4RFdXYlB4aVhOM2hyWGJ4MXN3NGNDcUxvYzBGc2plOEZVSU02VG04L1dG?=
 =?utf-8?B?SHFxa2tYMHpWWnQrSkFzVUZ5QUtKNkZCZmNJbVZ6bGFldzQzVDN3T3JVNEdw?=
 =?utf-8?B?QkxlSGpSQ2t2RVMya2Jka1lQVWorSUJtQmNYVjU4ZDdBTUJ4N3FoL1o0THMw?=
 =?utf-8?B?S2J1VXZSOEJDZkZycStDVXptR2ZmUnRmKzZJcnRzMi8vbkVsbGc5Uzl0Vys4?=
 =?utf-8?B?QVhzaHhid2VycXp1ZHV5NDdiNHIzUWVBWnhuUG1YR2EyeHNWRlhSeFpHV25y?=
 =?utf-8?B?elh0TnZ6dmVjYnErYUo2UTc4RW5mU1REck4vc0RvUVAxei9PRy9ac3FydTE2?=
 =?utf-8?B?QmhiWkZNSDVpbkJ1d0hkNGljeStEcndSRlQrbXpYaTJaZmhvbnJSb2h5Vm1R?=
 =?utf-8?B?bTlhWHdha0xONU5UcUh6STUyL1ZDTkZkbVdLaWtua2RnNWNkMC9lREZqMjhv?=
 =?utf-8?B?OElGU05SM21YWUFTWDFlVk1xQWNyUnhOY0ZBN0l6d2FrYXZqTjVPampDQkpV?=
 =?utf-8?B?UG0wR0VMUmIvWnhBUkRiS09UNHYzQ1BlM0lXOFVyZDNTZHRtUDBpWE50WkVG?=
 =?utf-8?B?RlBoR1Nxenp4SzltL2N0b2s0eWhnTnlFei91NGxpSTZzSWVlZGNLWnl0SkZL?=
 =?utf-8?B?eDBSU2pxdmdPZ2crS3R0MWg1azg3WmJOUDE2clh3Rkpqamh0WlM1RE5YSUNl?=
 =?utf-8?B?YW1VNWo1S2ZPejFqZW5zY0k3SnVkN1crVjJ0RjRJSWVVY2V3ZVJ5aFlsRmhh?=
 =?utf-8?B?UG9RK0ZacERkQmF3cll1eHBnVldTOHRoMllUVlNvN3J1blA4WERkNGJCWlVk?=
 =?utf-8?B?SGh5SkxlSlR0ekppMm1IZGpMMUFKcWVaVGNldzMwTytLa2k4OENkRkRBcDZY?=
 =?utf-8?B?NEQrd2xnb1o0VlZnYmR2N21NR2pTeFJ0aVZvU0tUbXZaNFE9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aGhRU0RDOE1SczFrMjdRYUUwVzZQbXphQ1hXeEw3Y09RUE1WazFvL3NRczZB?=
 =?utf-8?B?WWZKUzdUeUgvVDRKc2xDOFQ4NGh2djV1Z0xMYlBQM0FFNVZJRWhPZTlIbHpq?=
 =?utf-8?B?TUN4R0VJbXUrL3RpdndHRUc3SENvQTFBdHE5b3kxU3hnMXpXaDVDbzkyVUJX?=
 =?utf-8?B?Vm4vWWRDTnMwV2JBdDJVRzZyb0RCV2crWEhMa1pjUjN1TUdGTVE4M1k1c2RP?=
 =?utf-8?B?Q3BUbkgyaW9HY3lVSjV1TmxtWC92T2dZUTJXd0xISEVDOW5RQVlyMUJYWEFh?=
 =?utf-8?B?QlVldUVCZHVjTmQvTGVlRWN4UHljRG5GaW1WMS9GK28zT1NSR0kyOGU2UXRp?=
 =?utf-8?B?V3NKaVljZEo0dzlCM0lFN0xGNGU1V0wxc0RvenQ5N2ZlRUpVUnRiQ3ZnUFJy?=
 =?utf-8?B?OWVGQ3VHYjFWN1hKOWJDN3NMaGVhcU5abDg1YzhKdDI4UkhOOEVjNjE3MnRL?=
 =?utf-8?B?WlQyNkRpaElRd3hCLzA3ZjFMZG1zWCtRVGo1SGpUKzh1UHZNbWpDc3h0Y3R4?=
 =?utf-8?B?ejh4dHJMRXQxSUF4UlNEYzEvUjdNWHp6WEt3UlFUajZBVUVPQjFMVlg2dzFF?=
 =?utf-8?B?N1BHR3czNkJ3UTlvL3pQb1k1Q0xwVFhhMnlkSjVCU2JGbml0LzF5TFY0bXBG?=
 =?utf-8?B?a24rUk9Nb2NYVDhjbnIxcXJHODUrbFZJbkM5QVpJbWQ5MDR3dHpYeEkrOWtr?=
 =?utf-8?B?SFQ2bUl6TSsveTRVSUdhaVV0TnZzRzRlUktFeENJNDNuY3ppQjUyYUhVdzFC?=
 =?utf-8?B?Wk9jcnNJbDlNVzFLVHFFallGdE9hM2UzZ05EYXk3WTVmY21RSThtRE5Ed05J?=
 =?utf-8?B?OGtrM0dodTc5TVl3T2d0dWxubzNDWFVCZW1HMkZzakVncWFPM2hzYytEd0xL?=
 =?utf-8?B?bXNDczc0YmU4a1JRdjVoL24wcDc2MEhCOEZ1TXlGbm9USjBmVk5Wc2hBeWdY?=
 =?utf-8?B?TDM0Ui8wdGJLdjRGdkdaR3VYdlRPVllCcGp1dU9lMTRtdFRxaW01QnpDSXB3?=
 =?utf-8?B?cE80K3F6NFFjRklGclZRZHB4eDZlcklxMUEyaWdlTFdObWxzazlsalZKZCsx?=
 =?utf-8?B?UWNjUHVQV1hTMkI4ak9nZzVKTEZCQzc5ZEwvWnNTdVdVVXdXSGowWFhqYSta?=
 =?utf-8?B?S3lYWnF6KzVQNGlucFlTVUVxOWxxRVpYZzN4TXU2NGZaQ1dueWxIRis4L2Rj?=
 =?utf-8?B?WUdscUJIRHI1SE1WeVlXbHBDbkJxM3dacjh3WENMbVBoYTcwU21FbkM2NUFh?=
 =?utf-8?B?eVN6a3ozWC9TNXRybXZHcVNoTWFZVkxqMEJLNUhVMUowcWZwYVZQOFduL2Vk?=
 =?utf-8?B?a0phZFpSUWQ2TS9qMEdwcDdkOGh6aGV1QmpuQ21SSGhXNlc0WkMwRnM3Unp5?=
 =?utf-8?B?RXBTMEtCN0lNbTluTnU0YVpaSGZLZ0huQ2ZvdXJmYmVaYTBQazZJRUpyRktv?=
 =?utf-8?B?d29NK3d2eGVlbk1HUGxSUkNDL0NMTFZ2WXY2aThNS1ZNV25rR3JuYURHaTQv?=
 =?utf-8?B?Ukl0N29VZ2g1OGF0Q2VGSkFoYldDMXIvY2Y3cUU3ZmN2TUNKQlFVWVdpMENZ?=
 =?utf-8?B?TXJLem0ySFZ4L25ybjNjNWhWR2s4SEhyRzN6T2dLMDYxMUFKdGVSMUdNeWQx?=
 =?utf-8?B?UXhrSW5zNlZBQVVtVUo3VGo4Ym5QRVFNYW1WRG16b3hOWU03M2lIeEMwbjh2?=
 =?utf-8?B?RUNtb1N2d1dTaUlhcnJqb25mdzlTQzNDYkRrWmI5NmF5SjQ0SU1LaVdEWVJp?=
 =?utf-8?B?MTJEeDA4c2doM3MxaFIrVmJZUkVUVE1iVzhKYmtlb0VtRVg5ZFpMcENTd3FL?=
 =?utf-8?B?Zms4LzEvNXhCSFVFSTZ4Z042TngzUFB2Rm9rSDUxemNLZ0pxVVJFam1ZNFhJ?=
 =?utf-8?B?TUdLeEF5NnVNTXNESTdickJVZVpwc2E2aUdMcFZOQkNTUTNib0xvSDFtczBs?=
 =?utf-8?B?b2tGK0R4V3hwNzFaNTJ2YThWc01PNGdWdGZPMElVZDBoK1IyTzI0cTNKKzFZ?=
 =?utf-8?B?cWRDNWR3WDJpL3pqOEk5bGlUVUJWOWxUbTRzZHpQNDVwVHFNYklRdlV0U01s?=
 =?utf-8?B?Y2lJNnJ5S2JEcFJiTkQ3UFFmMkxQM2VlSXRlQ1NISzMwSmdlWFBOZ2ZKL1RI?=
 =?utf-8?Q?xHpR1pMPfrJYJZVSyrtcxDENS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS0PR11MB6373.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f062a21-50f1-489a-bf93-08dca4e26037
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2024 15:25:36.3490
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PQJbCne70HRhg1kGG5Q2CbDD8JDGWzh4Yi8HseIqKO1LLLhHzWMb+nqjcV72nbU9wIXHxDM7NilGGXUbOjWd0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8469
X-OriginatorOrg: intel.com

T24gVGh1cnNkYXksIEp1bHkgMTEsIDIwMjQgNzo0MiBBTSwgSmFtZXMgSG91Z2h0b24gd3JvdGU6
DQo+IFRoaXMgcGF0Y2ggc2VyaWVzIGltcGxlbWVudHMgdGhlIEtWTS1iYXNlZCBkZW1hbmQgcGFn
aW5nIHN5c3RlbSB0aGF0IHdhcw0KPiBmaXJzdCBpbnRyb2R1Y2VkIGJhY2sgaW4gTm92ZW1iZXJb
MV0gYnkgRGF2aWQgTWF0bGFjay4NCj4gDQo+IFRoZSB3b3JraW5nIG5hbWUgZm9yIHRoaXMgbmV3
IHN5c3RlbSBpcyBLVk0gVXNlcmZhdWx0LCBidXQgdGhhdCBuYW1lIGlzIHZlcnkNCj4gY29uZnVz
aW5nIHNvIGl0IHdpbGwgbm90IGJlIHRoZSBmaW5hbCBuYW1lLg0KPiANCkhpIEphbWVzLA0KSSBo
YWQgaW1wbGVtZW50ZWQgYSBzaW1pbGFyIGFwcHJvYWNoIGZvciBURFggcG9zdC1jb3B5IG1pZ3Jh
dGlvbiwgdGhlcmUgYXJlIHF1aXRlDQpzb21lIGRpZmZlcmVuY2VzIHRob3VnaC4gR290IHNvbWUg
cXVlc3Rpb25zIGFib3V0IHlvdXIgZGVzaWduIGJlbG93Lg0KDQo+IFByb2JsZW06IHBvc3QtY29w
eSB3aXRoIGd1ZXN0X21lbWZkDQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
DQo+IA0KPiBQb3N0LWNvcHkgbGl2ZSBtaWdyYXRpb24gbWFrZXMgaXQgcG9zc2libGUgdG8gbWln
cmF0ZSBWTXMgZnJvbSBvbmUgaG9zdCB0bw0KPiBhbm90aGVyIG5vIG1hdHRlciBob3cgZmFzdCB0
aGV5IGFyZSB3cml0aW5nIHRvIG1lbW9yeSB3aGlsZSBrZWVwaW5nIHRoZSBWTQ0KPiBwYXVzZWQg
Zm9yIGEgbWluaW1hbCBhbW91bnQgb2YgdGltZS4gRm9yIHBvc3QtY29weSB0byB3b3JrLCB3ZQ0K
PiBuZWVkOg0KPiAgMS4gdG8gYmUgYWJsZSB0byBwcmV2ZW50IEtWTSBmcm9tIGJlaW5nIGFibGUg
dG8gYWNjZXNzIHBhcnRpY3VsYXIgcGFnZXMNCj4gICAgIG9mIGd1ZXN0IG1lbW9yeSB1bnRpbCB3
ZSBoYXZlIHBvcHVsYXRlZCBpdCAgMi4gZm9yIHVzZXJzcGFjZSB0byBrbm93IHdoZW4NCj4gS1ZN
IGlzIHRyeWluZyB0byBhY2Nlc3MgYSBwYXJ0aWN1bGFyDQo+ICAgICBwYWdlLg0KPiAgMy4gYSB3
YXkgdG8gYWxsb3cgdGhlIGFjY2VzcyB0byBwcm9jZWVkLg0KPiANCj4gVHJhZGl0aW9uYWxseSwg
cG9zdC1jb3B5IGxpdmUgbWlncmF0aW9uIGlzIGltcGxlbWVudGVkIHVzaW5nIHVzZXJmYXVsdGZk
LCB3aGljaA0KPiBob29rcyBpbnRvIHRoZSBtYWluIG1tIGZhdWx0IHBhdGguIEtWTSBoaXRzIHRo
aXMgcGF0aCB3aGVuIGl0IGlzIGRvaW5nIEhWQSAtPg0KPiBQRk4gdHJhbnNsYXRpb25zICh3aXRo
IEdVUCkgb3Igd2hlbiBpdCBpdHNlbGYgYXR0ZW1wdHMgdG8gYWNjZXNzIGd1ZXN0IG1lbW9yeS4N
Cj4gVXNlcmZhdWx0ZmQgc2VuZHMgYSBwYWdlIGZhdWx0IG5vdGlmaWNhdGlvbiB0byB1c2Vyc3Bh
Y2UsIGFuZCBLVk0gZ29lcyB0byBzbGVlcC4NCj4gDQo+IFVzZXJmYXVsdGZkIHdvcmtzIHdlbGws
IGFzIGl0IGlzIG5vdCBzcGVjaWZpYyB0byBLVk07IGV2ZXJ5b25lIHdobyBhdHRlbXB0cyB0bw0K
PiBhY2Nlc3MgZ3Vlc3QgbWVtb3J5IHdpbGwgYmxvY2sgdGhlIHNhbWUgd2F5Lg0KPiANCj4gSG93
ZXZlciwgd2l0aCBndWVzdF9tZW1mZCwgd2UgZG8gbm90IHVzZSBHVVAgdG8gdHJhbnNsYXRlIGZy
b20gR0ZOIHRvIEhQQQ0KPiAobm9yIGlzIHRoZXJlIGFuIGludGVybWVkaWF0ZSBIVkEpLg0KPiAN
Cj4gU28gdXNlcmZhdWx0ZmQgaW4gaXRzIGN1cnJlbnQgZm9ybSBjYW5ub3QgYmUgdXNlZCB0byBz
dXBwb3J0IHBvc3QtY29weSBsaXZlDQo+IG1pZ3JhdGlvbiB3aXRoIGd1ZXN0X21lbWZkLWJhY2tl
ZCBWTXMuDQo+IA0KPiBTb2x1dGlvbjogaG9vayBpbnRvIHRoZSBnZm4gLT4gcGZuIHRyYW5zbGF0
aW9uDQo+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4g
DQo+IFRoZSBvbmx5IHdheSB0byBpbXBsZW1lbnQgcG9zdC1jb3B5IHdpdGggYSBub24tS1ZNLXNw
ZWNpZmljIHVzZXJmYXVsdGZkLWxpa2UNCj4gc3lzdGVtIHdvdWxkIGJlIHRvIGludHJvZHVjZSB0
aGUgY29uY2VwdCBvZiBhIGZpbGUtdXNlcmZhdWx0WzJdIHRvIGludGVyY2VwdA0KPiBmYXVsdHMg
b24gYSBndWVzdF9tZW1mZC4NCj4gDQo+IEluc3RlYWQsIHdlIHRha2UgdGhlIHNpbXBsZXIgYXBw
cm9hY2ggb2YgYWRkaW5nIGEgS1ZNLXNwZWNpZmljIEFQSSwgYW5kIHdlDQo+IGhvb2sgaW50byB0
aGUgR0ZOIC0+IEhWQSBvciBHRk4gLT4gUEZOIHRyYW5zbGF0aW9uIHN0ZXBzIChmb3IgdHJhZGl0
aW9uYWwNCj4gbWVtc2xvdHMgYW5kIGZvciBndWVzdF9tZW1mZCByZXNwZWN0aXZlbHkpLg0KDQoN
CldoeSB0YWtpbmcgS1ZNX0VYSVRfTUVNT1JZX0ZBVUxUIGZhdWx0cyBmb3IgdGhlIHRyYWRpdGlv
bmFsIHNoYXJlZA0KcGFnZXMgKGkuZS4gR0ZOIC0+IEhWQSk/IA0KSXQgc2VlbXMgc2ltcGxlciBp
ZiB3ZSB1c2UgS1ZNX0VYSVRfTUVNT1JZX0ZBVUxUIGZvciBwcml2YXRlIHBhZ2VzIG9ubHksIGxl
YXZpbmcNCnNoYXJlZCBwYWdlcyB0byBnbyB0aHJvdWdoIHRoZSBleGlzdGluZyB1c2VyZmF1bHRm
ZCBtZWNoYW5pc206DQotIFRoZSBuZWVkIGZvciDigJxhc3luY2hyb25vdXMgdXNlcmZhdWx0cyzi
gJ0gaW50cm9kdWNlZCBieSBwYXRjaCAxNCwgY291bGQgYmUgZWxpbWluYXRlZC4NCi0gVGhlIGFk
ZGl0aW9uYWwgc3VwcG9ydCAoZS5nLiwgS1ZNX01FTU9SWV9FWElUX0ZMQUdfVVNFUkZBVUxUKSBm
b3IgcHJpdmF0ZSBwYWdlDQogIGZhdWx0cyBleGl0aW5nIHRvIHVzZXJzcGFjZSBmb3IgcG9zdGNv
cHkgbWlnaHQgbm90IGJlIG5lY2Vzc2FyeSwgYmVjYXVzZSBhbGwgcGFnZXMgb24gdGhlDQogIGRl
c3RpbmF0aW9uIHNpZGUgYXJlIGluaXRpYWxseSDigJxzaGFyZWQs4oCdIGFuZCB0aGUgZ3Vlc3Ti
gJlzIGZpcnN0IGFjY2VzcyB3aWxsIGFsd2F5cyBjYXVzZSBhbg0KICBleGl0IHRvIHVzZXJzcGFj
ZSBmb3Igc2hhcmVkLT5wcml2YXRlIGNvbnZlcnNpb24uIFNvIFZNTSBpcyBhYmxlIHRvIGxldmVy
YWdlIHRoZSBleGl0IHRvDQogIGZldGNoIHRoZSBwYWdlIGRhdGEgZnJvbSB0aGUgc291cmNlIChW
TU0gY2FuIGtub3cgaWYgYSBwYWdlIGRhdGEgaGFzIGJlZW4gZmV0Y2hlZA0KICBmcm9tIHRoZSBz
b3VyY2Ugb3Igbm90KS4NCg0KPiANCj4gSSBoYXZlIGludGVudGlvbmFsbHkgYWRkZWQgc3VwcG9y
dCBmb3IgdHJhZGl0aW9uYWwgbWVtc2xvdHMsIGFzIHRoZSBjb21wbGV4aXR5DQo+IHRoYXQgaXQg
YWRkcyBpcyBtaW5pbWFsLCBhbmQgaXQgaXMgdXNlZnVsIGZvciBzb21lIFZNTXMsIGFzIGl0IGNh
biBiZSB1c2VkIHRvDQo+IGZ1bGx5IGltcGxlbWVudCBwb3N0LWNvcHkgbGl2ZSBtaWdyYXRpb24u
DQo+IA0KPiBJbXBsZW1lbnRhdGlvbiBEZXRhaWxzDQo+ID09PT09PT09PT09PT09PT09PT09PT0N
Cj4gDQo+IExldCdzIGJyZWFrIGRvd24gaG93IEtWTSBpbXBsZW1lbnRzIGVhY2ggb2YgdGhlIHRo
cmVlIGNvcmUgcmVxdWlyZW1lbnRzDQo+IGZvciBpbXBsZW1lbnRpbmcgcG9zdC1jb3B5IGFzIGxh
aWQgb3V0IGFib3ZlOg0KPiANCj4gLS0tIFByZXZlbnRpbmcgYWNjZXNzOiBLVk1fTUVNT1JZX0FU
VFJJQlVURV9VU0VSRkFVTFQgLS0tDQo+IA0KPiBUaGUgbW9zdCBzdHJhaWdodGZvcndhcmQgd2F5
IHRvIGluZm9ybSBLVk0gb2YgdXNlcmZhdWx0LWVuYWJsZWQgcGFnZXMgaXMgdG8NCj4gdXNlIGEg
bmV3IG1lbW9yeSBhdHRyaWJ1dGUsIHNheSBLVk1fTUVNT1JZX0FUVFJJQlVURV9VU0VSRkFVTFQu
DQo+IA0KPiBUaGVyZSBpcyBhbHJlYWR5IGluZnJhc3RydWN0dXJlIGluIHBsYWNlIGZvciBtb2Rp
ZnlpbmcgYW5kIGNoZWNraW5nIG1lbW9yeQ0KPiBhdHRyaWJ1dGVzLiBVc2luZyB0aGlzIGludGVy
ZmFjZSBpcyBzbGlnaHRseSBjaGFsbGVuZ2luZywgYXMgdGhlcmUgaXMgbm8gVUFQSSBmb3INCj4g
c2V0dGluZy9jbGVhcmluZyBwYXJ0aWN1bGFyIGF0dHJpYnV0ZXM7IHdlIG11c3Qgc2V0IHRoZSBl
eGFjdCBhdHRyaWJ1dGVzIHdlIHdhbnQuDQo+IA0KPiBUaGUgc3luY2hyb25pemF0aW9uIHRoYXQg
aXMgaW4gcGxhY2UgZm9yIHVwZGF0aW5nIG1lbW9yeSBhdHRyaWJ1dGVzIGlzIG5vdA0KPiBzdWl0
YWJsZSBmb3IgcG9zdC1jb3B5IGxpdmUgbWlncmF0aW9uIGVpdGhlciwgd2hpY2ggd2lsbCByZXF1
aXJlIHVwZGF0aW5nDQo+IG1lbW9yeSBhdHRyaWJ1dGVzIChmcm9tIHVzZXJmYXVsdCB0byBuby11
c2VyZmF1bHQpIHZlcnkgZnJlcXVlbnRseS4NCj4gDQo+IEFub3RoZXIgcG90ZW50aWFsIGludGVy
ZmFjZSBjb3VsZCBiZSB0byB1c2Ugc29tZXRoaW5nIGFraW4gdG8gYSBkaXJ0eSBiaXRtYXAsDQo+
IHdoZXJlIGEgYml0bWFwIGRlc2NyaWJlcyB3aGljaCBwYWdlcyB3aXRoaW4gYSBtZW1zbG90IChv
ciBWTSkgc2hvdWxkIHRyaWdnZXINCj4gdXNlcmZhdWx0cy4gVGhpcyB3YXksIGl0IGlzIHN0cmFp
Z2h0Zm9yd2FyZCB0byBtYWtlIHVwZGF0ZXMgdG8gdGhlIHVzZXJmYXVsdA0KPiBzdGF0dXMgb2Yg
YSBwYWdlIGNoZWFwLg0KPiANCj4gV2hlbiBLVk0gVXNlcmZhdWx0IGlzIGVuYWJsZWQsIHdlIG5l
ZWQgdG8gYmUgY2FyZWZ1bCBub3QgdG8gbWFwIGEgdXNlcmZhdWx0DQo+IHBhZ2UgaW4gcmVzcG9u
c2UgdG8gYSBmYXVsdCBvbiBhIG5vbi11c2VyZmF1bHQgcGFnZS4gSW4gdGhpcyBSRkMsIEkndmUg
dGFrZW4gdGhlDQo+IHNpbXBsZXN0IGFwcHJvYWNoOiBmb3JjZSBuZXcgUFRFcyB0byBiZSBQQUdF
X1NJWkUuDQo+IA0KPiAtLS0gUGFnZSBmYXVsdCBub3RpZmljYXRpb25zIC0tLQ0KPiANCj4gRm9y
IHBhZ2UgZmF1bHRzIGdlbmVyYXRlZCBieSB2Q1BVcyBydW5uaW5nIGluIGd1ZXN0IG1vZGUsIGlm
IHRoZSBwYWdlIHRoZQ0KPiB2Q1BVIGlzIHRyeWluZyB0byBhY2Nlc3MgaXMgYSB1c2VyZmF1bHQt
ZW5hYmxlZCBwYWdlLCB3ZSB1c2UNCg0KV2h5IGlzIGl0IG5lY2Vzc2FyeSB0byBhZGQgdGhlIHBl
ci1wYWdlIGNvbnRyb2wgKHdpdGggdUFQSXMgZm9yIFZNTSB0byBzZXQvY2xlYXIpPw0KQW55IGZ1
bmN0aW9uYWwgaXNzdWVzIGlmIHdlIGp1c3QgaGF2ZSBhbGwgdGhlIHBhZ2UgZmF1bHRzIGV4aXQg
dG8gdXNlcnNwYWNlIGR1cmluZyB0aGUNCnBvc3QtY29weSBwZXJpb2Q/DQotIEFzIGFsc28gbWVu
dGlvbmVkIGFib3ZlLCB1c2Vyc3BhY2UgY2FuIGVhc2lseSBrbm93IGlmIGEgcGFnZSBuZWVkcyB0
byBiZQ0KICBmZXRjaGVkIGZyb20gdGhlIHNvdXJjZSBvciBub3QsIHNvIHVwb24gYSBmYXVsdCBl
eGl0IHRvIHVzZXJzcGFjZSwgVk1NIGNhbg0KICBkZWNpZGUgdG8gYmxvY2sgdGhlIGZhdWx0aW5n
IHZjcHUgdGhyZWFkIG9yIHJldHVybiBiYWNrIHRvIEtWTSBpbW1lZGlhdGVseS4NCi0gSWYgaW1w
cm92ZW1lbnQgaXMgcmVhbGx5IG5lZWRlZCAod291bGQgbmVlZCBwcm9maWxpbmcgZmlyc3QpIHRv
IHJlZHVjZSBudW1iZXINCiAgb2YgZXhpdHMgdG8gdXNlcnNwYWNlLCBhICBLVk0gaW50ZXJuYWwg
c3RhdHVzIChiaXRtYXAgb3IgeGFycmF5KSBzZWVtcyBzdWZmaWNpZW50Lg0KICBFYWNoIHBhZ2Ug
b25seSBuZWVkcyB0byBleGl0IHRvIHVzZXJzcGFjZSBvbmNlIGZvciB0aGUgcHVycG9zZSBvZiBm
ZXRjaGluZyBpdHMgZGF0YQ0KICBmcm9tIHRoZSBzb3VyY2UgaW4gcG9zdGNvcHkuIEl0IGRvZXNu
J3Qgc2VlbSB0byBuZWVkIHVzZXJzcGFjZSB0byBlbmFibGUgdGhlIGV4aXQNCiAgYWdhaW4gZm9y
IHRoZSBwYWdlICh2aWEgYSBuZXcgdUFQSSksIHJpZ2h0Pw0K

