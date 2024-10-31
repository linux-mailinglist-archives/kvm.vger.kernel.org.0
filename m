Return-Path: <kvm+bounces-30138-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FCCF9B7150
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 01:49:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 637A91C2107E
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 00:49:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CA4428379;
	Thu, 31 Oct 2024 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lwkkAlt7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA3817991;
	Thu, 31 Oct 2024 00:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730335773; cv=fail; b=IDKnIz2eoRKchayhGAoJ0fn95fBp8BxdT2qi8H3pTwcky7CKd8YUkVn2RnDvmYirJ64+XNrfdFUQlFhEaqnZf54xU2fdc//MOoOOUVRi4Pfup7hXZxGygMI5gn6ZDKP6zGJc2agYZATMy2zk+JMPEm7EHZ7Zqtkoeu1c3iQKaOg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730335773; c=relaxed/simple;
	bh=9HwS0zpAKQ551xcwPTvEIZxjRC2WRGfe7+Ywk0c1hxs=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=B9VBMHSAPXoonDpy37EQWhtedScqjDBwDKqDN8cUoxIdUAlwY4CCYKNbKODmK47x2HsFK7ryh5w1Z4jA/pItczo1UWb2lgj0DQRXvv+xFe+OnlJoqhEPITb88Z993JqvPb/CGU7joPi+JXotOhRoHQ5qR62nxezO8P0q1eHXIaA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lwkkAlt7; arc=fail smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730335771; x=1761871771;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=9HwS0zpAKQ551xcwPTvEIZxjRC2WRGfe7+Ywk0c1hxs=;
  b=lwkkAlt7DoMz+NobkfOS99mkR6YznhWeGYWPm1Fcg4IKXkYw+RjS8Pc+
   o7+8dyASK4hJ4E+t/6ButCXbU6KAwjQGa9IXqbi/Hx32J7yux9xR7eI3y
   cfWkmX46LA6i+e5m5GxhNrILep15AymJTUEE/OQgGxW+g1jvy4JfePePL
   FLPkHlRU0mTrNDWfw3LdY/Jfz7uZklD5roCxwIs3kNHcKe9daf2Y7edee
   wy+fKQCRuvMNxzY9U9WIovM3GbvM8YRnH8Ig5ATaZ+hb1z/MZM+P0Osgh
   +L1g9YzA4/wIKT7i2WLhN87n2zlZWk7ErMWYKS22aVdlMGK38cWt0Lrin
   Q==;
X-CSE-ConnectionGUID: 1yVgztNBSIip/tmZbXJWAA==
X-CSE-MsgGUID: rmzTgDh/TH+Z/mOlSdCeAw==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="33987508"
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="33987508"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 17:49:30 -0700
X-CSE-ConnectionGUID: rd/LoAs9TDa6c8ImtfEZLg==
X-CSE-MsgGUID: KQRD6qxaQWa88EFCaD+mmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,246,1725346800"; 
   d="scan'208";a="87621917"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orviesa004.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 30 Oct 2024 17:49:30 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 30 Oct 2024 17:49:29 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 30 Oct 2024 17:49:29 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.43) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 30 Oct 2024 17:49:29 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=sQ+uKXznWVQEy0yQh8C+8AEK4tGuh8jdm5YVDbHed7BG1StRX4LTdDGLTWWsbzNzkHujFkWTdgbhGn3C4IJQwyAkVImIZjPQPTwpgto5pQiESTrEWyEgqwcf0LhclZsD7hPUK/+VF6dtw8KYPCuI+HTe+RIPssZ9BaCui0mdElW6szylDOnj3lkAinwGEyh42A6qkNcWdvQcY9mhTPyPp4v+jRj67guuqS0Ri1L86qgu/u+DWN3U8YLxvnbPSziek90GFxxpJ0mdr2wVDo7QyANqbZ9/Xbgy+KJhhopvQQgKS2GfGoP+7Qu4n2PCZaMuF0J9teIpbaHhnWWxLYIy4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9HwS0zpAKQ551xcwPTvEIZxjRC2WRGfe7+Ywk0c1hxs=;
 b=i+yC04Ph+J1iAyydFs6UrqOMCDOvpKbz0MbWLsv9T6rXQOWDaozzGYAA0MP5iglXsYZHPKdwEgqM0MpoG4WQk87RzM1oZWio/CYOnR2PxtmwS8N6X+8hyQBdWRja4vb4g19flj+g0Wr2n66GyM7BsmIr70YYr/EHkZatumTb4outQTz5LAwbr2dkq2t6RaOynCUYiqpz9oiUXWpUHA7wJXx+7SFRijVlhQ9BFagHjrSuu9EB1KPbbM2RZT1X2W6ba5H2QZ1upoJmeCsZUcdO83sy9/WFi/+w4xyECBDK49HMm+116XmiSoZBAAd+W+M5GxD+NP/8F2DF1k3wwqtS0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8093.32; Thu, 31 Oct
 2024 00:49:27 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.8093.027; Thu, 31 Oct 2024
 00:49:27 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>
CC: "yuan.yao@linux.intel.com" <yuan.yao@linux.intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Li, Xiaoyao" <xiaoyao.li@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Edgecombe,
 Rick P" <rick.p.edgecombe@intel.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>
Subject: Re: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Topic: [PATCH v3 1/2] KVM: x86: Check hypercall's exit to userspace
 generically
Thread-Index: AQHa916mLjHQn3A27kaE3wVAzihpyrKgK5iAgABDH4A=
Date: Thu, 31 Oct 2024 00:49:27 +0000
Message-ID: <3f158732a66829faaeb527a94b8df78d6173befa.camel@intel.com>
References: <20240826022255.361406-1-binbin.wu@linux.intel.com>
	 <20240826022255.361406-2-binbin.wu@linux.intel.com>
	 <ZyKbxTWBZUdqRvca@google.com>
In-Reply-To: <ZyKbxTWBZUdqRvca@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.52.4 (3.52.4-1.fc40) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|MN0PR11MB6088:EE_
x-ms-office365-filtering-correlation-id: 4e0b4391-02e3-4776-0e28-08dcf945df6d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?Q3RyK3NkR3dwSllWaklsRDFaTUxhd2hveEUxSldRYXRPOWtMNzBPcHA3Zmlx?=
 =?utf-8?B?UWdZQVgyOEpIWDV4dFlrNmZRL1JEVk9mYVY4WGNlNlM0cHdKejU4SWtRa2NL?=
 =?utf-8?B?blFLVGtVVWdFQkVxbTkwMzZHZ0FTeHlpcDhXa2pKRmxYU0pmQlUrS2J3OUgx?=
 =?utf-8?B?RmJjZWhBbkNIbDJOSWtQc0hqcmVsMHJLMG1YRnZoYnFWM1U2OHQrTUg0VHdH?=
 =?utf-8?B?U1BvS1kvbkZ0eWFGMFV2Ti9VZWtPKys4V29xNmdvbDdNM09BT09nazZpVytN?=
 =?utf-8?B?aFNoZDhMSDZKektXcEE4VXRJcU44SjlVV1R1cWJLczg4NThicjh3eGJKeFNV?=
 =?utf-8?B?eUlUR0ZNYitvY2dlL00yNmhudndRYnJDRDd0SWZWWFhQdnEvQVlLWklLRmlF?=
 =?utf-8?B?TDJicGwweE8wWnFYcWpFbXprUVpUa1VjMFdXa0VNdTRvK0VuTHA0S2JuNVZi?=
 =?utf-8?B?MmthcVpzeDFlNkpzdzlEUmx4c0tZTGJjd3ZPcWc1OVpEVEZQNkZlT2V4eXB4?=
 =?utf-8?B?UmJVQVNFc3E1VTNZRS9ta1lIZFNIVmhtQjZKL2JwMUtGM1ZDNC9WbzZxUXcw?=
 =?utf-8?B?RURrenRqRis3UDVYY1VMTUJoUGMvSE9rZGtXdzFtNVNDaW80cmNndUhUck9V?=
 =?utf-8?B?dm9zSDdCczR1TzNtVk42WERQdytTN0xyMTduRVcyRlNlRDhDTXgwa3BHNGVD?=
 =?utf-8?B?L0IvT25mL3gzTjBjS01ZZEtzeXhMbDVEVFB2UGZmdTV3QWRTNG41SzVMdnQ1?=
 =?utf-8?B?YjQ5bUREN1dGeFEzYitwSlVpYmpXR0pPb0hZN3UzK2xBQnN1U2ZWZU1BeTdn?=
 =?utf-8?B?Rml4N0hEUlM1Z1NENmhvbzFIcGdyNVFoZjd6QzlQLzhUSXg4MGNvMFlGNjA3?=
 =?utf-8?B?N3EzMUdCMEVqc2ZodFJZV28zWVptaHcvektMdUlNZDdPUjhEZStOU0dodDgv?=
 =?utf-8?B?cVFsR3NRSHM4RS9sT20ycjhEcm9jb3hlK0JuTExLZ2ROZmxUQmhiRGZWaVlE?=
 =?utf-8?B?MXF3aGtHSldoRVlwamx4UWRHcTBXTGFnaThkQTZzRU9ocllkZDNYMjErOEhU?=
 =?utf-8?B?VldMNzlsTXFDTjg3S3VRNlJzUFpVZHFTMFpIcm1ybWNwb05SRW1NQ0JvV0Za?=
 =?utf-8?B?VUlTV0g3WVdkZDRpaFdCMmRqbmF6SkljcDZMYzZEbkExU2JTT3F2Q1IzaWxR?=
 =?utf-8?B?RW1mQlhYbWJlQTBjVW9GYlU1dkFNOHYwQmJTZzFaNzI5aHVlWERNalVtQVFr?=
 =?utf-8?B?UUQraGVId3JSK2JmU01xUGFCaEhnTW92SW02NkpHVkxVNTJ0U3Npa3dIK3Zy?=
 =?utf-8?B?VnNsQ2lncnRiSmlUS29SY1g0KzZTeEMyUzE5cUFYenpJd2pZREs4R3c4bThj?=
 =?utf-8?B?MkRhNUs0UWxmTnJ5UDlMbXY1UHFZZmNMc1gvM1FRd2IveXF3elB0V3licXdj?=
 =?utf-8?B?azA3WlRTY25PRkx1UFM3SUNBSm9tTWlaTEJqTVJzaDNVTFd0U3pBT2V0ZGdK?=
 =?utf-8?B?cmJDWDVlS1FNYURncmFKcVNVUjl2R0FMa2QrRmdnZnhVSmM4OHBXWHlWMnht?=
 =?utf-8?B?UE9DcnQ2ajgxL28rSUMrdDlXeXpvUXFaTjNXNjBhRmYva0RVNjg3eVQ2T09t?=
 =?utf-8?B?clVERFRFdXo0SW9HZkFwdTBveUhnSTBkVTZ4am1qT3A0VXdZVkdQVHpUL093?=
 =?utf-8?B?QjU3TENlUlJHVGp1MzB5TnE3QXcwS0JzUjJmS2RzeStsZHZOM1libkE3eDN3?=
 =?utf-8?B?RU5JS3JtbmQyN1pzK1FNdDBIUUkyK2RBMXA2ZGt6a1daRmI5dXp0dmdJVUow?=
 =?utf-8?Q?2VHpzHlDy2Z+qanfD20svpxwEvNG6wioAk/Pg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WGFKNFpFY0VjekNMcGZmblVsKzdod050eVVNRUVnSmQyTWhnV3dHY3dQZElo?=
 =?utf-8?B?NjUxUmtoNFBSV3ZBYWZicGFxNnYyWE9UQjdhQ0FzS2xMZTErc01mL1VFaHNp?=
 =?utf-8?B?QjVBVCtaZSt0OEorL2RuT3FHVHZ1NkxqZnFvQk5Rb2Mrc2g3WmJFdjFlVmZB?=
 =?utf-8?B?ZEtOU3dPM0hUMlAwM0JEN3ZXem5xNngyQXlxSGlDTUdvcUJ5V2JURVJBcktn?=
 =?utf-8?B?dkJmZ3RIOXZIMlF6Mk1OWlhjTlRxUTBONHBSc1YzRWJtcEJab0d4cHVzY1VU?=
 =?utf-8?B?T0pyTCs4Sy9UOW1hcmhUdlB5OW92QUNKdVJpd1VwWWFTT0dldVhyU3N3TWdi?=
 =?utf-8?B?Tkd5ZGYxb095UE1BcDNCSXVBa2RZS1hLcnFMcWhtK0lpcXNZM0RKZmlpdFRG?=
 =?utf-8?B?Rnhqd083b3pMNS81eHRFcC83OFVtSUwwdThOTVVXRm9EcEE3NisyOVFXdTd0?=
 =?utf-8?B?QVBiSVFRVDBuNU41ZHR2Wm9DdS9pTWI1bEk5S1NpWUpsSWEzZ1MxTWgyd1J5?=
 =?utf-8?B?dTJHTWhWQ2FKdFJidDdsS01OVGZtbkUwRWcwclNiaEVsckM2UE54dGphQlVE?=
 =?utf-8?B?U0h0L3k0WmllWDZmNTkwNkl3MjlCWEdKZ3daOWY5dlBWdUNPUmJudEpuR240?=
 =?utf-8?B?YzVtQktNcjhuUmd1eTZwVXRYa2xOeTEweUowY3JyS0JwcGF4NmwxQjFVRGJR?=
 =?utf-8?B?M0NYR0lvc1ZkWlNuKzlqRU8yQVFVWUFmVlpZQjBPd2FxUkJlcXpFN1JoOHpo?=
 =?utf-8?B?NDNKNXpYWUYrdk5IVGZ1WTVVRlFCeTJETlhuK0FkbTVmWHJyWWk3NGJmQXZp?=
 =?utf-8?B?NVlzakZTV0lwcjFqNzU3MHJISFN6ZmRhUDhGWlB0Kys3ZWtma3ZjNjhxNlhz?=
 =?utf-8?B?dGJTV0duVmg3aWpVYXRnWFhjRnVYZXorQmgvUEtSZk1IU0pJcmV5bHc5eG11?=
 =?utf-8?B?NjB6cE9samVxNHNqQ0hBUTBneFRHWlZVWWt3SXVuTGtOMXBZWVlMZGNQd3VY?=
 =?utf-8?B?cjlYTVd1U1ZTenAvL09iYTAxZzNZc2s4ZGZWQTlzalF3YlV4aGIxcGl3dE01?=
 =?utf-8?B?ZHNFbjR4RU9Pa1EvcmxwSE5mTUgrdzFpWmVhUGk2MzVYWWRNekQxSms4WVZv?=
 =?utf-8?B?aVNDUFFXaHZiVDJ0NkdTbDUzZjZIOEdPTVJuaThxVDJsUkFHenZMaldVcjZX?=
 =?utf-8?B?YXFZdnV3eHhjbXpxVjV1NnJ3eVdTbkdSS0sxTzkxdDRweXlkd2NRa29tSzZl?=
 =?utf-8?B?bmt6Vm5KSERHdU91aXVaNzlmM2NZUWh0dXp5VnVpcDFUUzF3cjBTZkNJQlFZ?=
 =?utf-8?B?NXdQbTJWellQMjErQ2E4M2oxUDdzM0Z2a25QcGlKR2swN3hWV3QrZjk0RzA5?=
 =?utf-8?B?b1V6VFBVdWoxNlBXL0RCbGZXRHlEUXZWVUJCUVVPVjEyOVNXWmVBM3BWaEE5?=
 =?utf-8?B?SG15d3Y3Smw4RGtrTTJzelo3UGhwUEkyeWJ1elJzcE5DaXhnbUpNWisrT0lm?=
 =?utf-8?B?MXNFYm1SVFg1MkpXcEpRQWF2bGhrdHN3UlF4bjVqQUlnTklKclNUYXl4NWlu?=
 =?utf-8?B?M2tVUEV3U0Z0bko5UWx2MUROcDAyS1pQcFdDSTBjbU5EUkdibFZhMDNsVzR1?=
 =?utf-8?B?Y2ZpdDN2TmY5T3pPa1dNeDBrbzRKQzk1cUtDQk5nSUN2dkE2NVFCNjAxZ2xI?=
 =?utf-8?B?S3FOVnh6cTUzMXVVYjNDcVoyVXpVTGpua2NCdGtCYngzcmV0M1dmcFlwVGxO?=
 =?utf-8?B?Zk5wdmwwcVpIOG5ob0hIRjJqdzF3MmNUVUlvdlJEWUd0dTlSaWEvSTIwT1dk?=
 =?utf-8?B?Q1E4cEZ0bk1ZMzQxcmtmMGFKbTVTTFY3WE1MQW9LbU93ZTJBMHhLaVcwZ2JL?=
 =?utf-8?B?M25SYkY3Tjl5YTZGY1lzekMyN0hUWWNjNUNXYThuNk1tNDRoRExYRWpiK3Ru?=
 =?utf-8?B?UGdjK2ZXbEc2OUNxNlYyOUQ1ZG9GcXc4ZnUwczFRV21pUUkwRUR5YndEaFZR?=
 =?utf-8?B?L3RIazl0WGRqYzkrRVl1NHlVQ2Flb0NNQ1NRZUF1R2Fyb3gvZjlFT28ra21u?=
 =?utf-8?B?WW5CQkdYbEZHNWsvRnY4aXhPUGZUQ3RkWTBON1l2c2dNd0tDQ0IxbDVHUlY3?=
 =?utf-8?Q?o4j+kFTuSllixBwl/U40kViuw?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B65EBBD5A7D7334FA207FA1B8572E80B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e0b4391-02e3-4776-0e28-08dcf945df6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2024 00:49:27.6079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z15kgX1aELQQ3Rshxy3FnOyvYiG1C4hxwFgxMgvryJaMXxvPz0T7znsiph5KAuAyn2VUl1Me/1HzBWn7ea2EqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6088
X-OriginatorOrg: intel.com

DQo+IEBAIC0xMDAyNCw3ICsxMDAyNCw3IEBAIHVuc2lnbmVkIGxvbmcgX19rdm1fZW11bGF0ZV9o
eXBlcmNhbGwoc3RydWN0IGt2bV92Y3B1ICp2Y3B1LCB1bnNpZ25lZCBsb25nIG5yLA0KPiAgDQo+
ICAJc3dpdGNoIChucikgew0KPiAgCWNhc2UgS1ZNX0hDX1ZBUElDX1BPTExfSVJROg0KPiAtCQly
ZXQgPSAwOw0KPiArCQlyZXQgPSAxOw0KPiAgCQlicmVhazsNCj4gIAljYXNlIEtWTV9IQ19LSUNL
X0NQVToNCj4gIAkJaWYgKCFndWVzdF9wdl9oYXModmNwdSwgS1ZNX0ZFQVRVUkVfUFZfVU5IQUxU
KSkNCj4gQEAgLTEwMDMyLDcgKzEwMDMyLDcgQEAgdW5zaWduZWQgbG9uZyBfX2t2bV9lbXVsYXRl
X2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVuc2lnbmVkIGxvbmcgbnIsDQo+ICAN
Cj4gIAkJa3ZtX3B2X2tpY2tfY3B1X29wKHZjcHUtPmt2bSwgYTEpOw0KPiAgCQlrdm1fc2NoZWRf
eWllbGQodmNwdSwgYTEpOw0KPiAtCQlyZXQgPSAwOw0KPiArCQlyZXQgPSAxOw0KPiAgCQlicmVh
azsNCj4gICNpZmRlZiBDT05GSUdfWDg2XzY0DQo+ICAJY2FzZSBLVk1fSENfQ0xPQ0tfUEFJUklO
RzoNCj4gQEAgLTEwMDUwLDcgKzEwMDUwLDcgQEAgdW5zaWduZWQgbG9uZyBfX2t2bV9lbXVsYXRl
X2h5cGVyY2FsbChzdHJ1Y3Qga3ZtX3ZjcHUgKnZjcHUsIHVuc2lnbmVkIGxvbmcgbnIsDQo+ICAJ
CQlicmVhazsNCj4gIA0KPiAgCQlrdm1fc2NoZWRfeWllbGQodmNwdSwgYTApOw0KPiAtCQlyZXQg
PSAwOw0KPiArCQlyZXQgPSAxOw0KPiAgCQlicmVhazsNCj4gIAljYXNlIEtWTV9IQ19NQVBfR1BB
X1JBTkdFOiB7DQo+ICAJCXU2NCBncGEgPSBhMCwgbnBhZ2VzID0gYTEsIGF0dHJzID0gYTI7DQo+
IEBAIC0xMDExMSwxMiArMTAxMTEsMjEgQEAgaW50IGt2bV9lbXVsYXRlX2h5cGVyY2FsbChzdHJ1
Y3Qga3ZtX3ZjcHUgKnZjcHUpDQo+ICAJY3BsID0ga3ZtX3g4Nl9jYWxsKGdldF9jcGwpKHZjcHUp
Ow0KPiAgDQo+ICAJcmV0ID0gX19rdm1fZW11bGF0ZV9oeXBlcmNhbGwodmNwdSwgbnIsIGEwLCBh
MSwgYTIsIGEzLCBvcF82NF9iaXQsIGNwbCk7DQo+IC0JaWYgKG5yID09IEtWTV9IQ19NQVBfR1BB
X1JBTkdFICYmICFyZXQpDQo+IC0JCS8qIE1BUF9HUEEgdG9zc2VzIHRoZSByZXF1ZXN0IHRvIHRo
ZSB1c2VyIHNwYWNlLiAqLw0KPiArCWlmICghcmV0KQ0KPiAgCQlyZXR1cm4gMDsNCj4gIA0KPiAt
CWlmICghb3BfNjRfYml0KQ0KPiArCS8qDQo+ICsJICogS1ZNJ3MgQUJJIHdpdGggdGhlIGd1ZXN0
IGlzIHRoYXQgJzAnIGlzIHN1Y2Nlc3MsIGFuZCBhbnkgb3RoZXIgdmFsdWUNCj4gKwkgKiBpcyBh
biBlcnJvciBjb2RlLiAgSW50ZXJuYWxseSwgJzAnID09IGV4aXQgdG8gdXNlcnNwYWNlIChzZWUg
YWJvdmUpDQo+ICsJICogYW5kICcxJyA9PSBzdWNjZXNzLCBhcyBLVk0ncyBkZSBmYWN0byBzdGFu
ZGFyZCByZXR1cm4gY29kZXMgYXJlIHRoYXQNCj4gKwkgKiBwbHVzIC1lcnJubyA9PSBmYWlsdXJl
LiAgRXhwbGljaXRseSBjaGVjayBmb3IgJzEnIGFzIHNvbWUgUFYgZXJyb3INCj4gKwkgKiBjb2Rl
cyBhcmUgcG9zaXRpdmUgdmFsdWVzLg0KPiArCSAqLw0KPiArCWlmIChyZXQgPT0gMSkNCj4gKwkJ
cmV0ID0gMDsNCj4gKwllbHNlIGlmICghb3BfNjRfYml0KQ0KPiAgCQlyZXQgPSAodTMyKXJldDsN
Cj4gKw0KPiAgCWt2bV9yYXhfd3JpdGUodmNwdSwgcmV0KTsNCj4gIA0KPiAgCXJldHVybiBrdm1f
c2tpcF9lbXVsYXRlZF9pbnN0cnVjdGlvbih2Y3B1KTsNCj4gDQoNCkl0IGFwcGVhcnMgYmVsb3cg
dHdvIGNhc2VzIGFyZSBub3QgY292ZXJlZCBjb3JyZWN0bHk/DQoNCiNpZmRlZiBDT05GSUdfWDg2
XzY0ICAgIA0KICAgICAgICBjYXNlIEtWTV9IQ19DTE9DS19QQUlSSU5HOg0KICAgICAgICAgICAg
ICAgIHJldCA9IGt2bV9wdl9jbG9ja19wYWlyaW5nKHZjcHUsIGEwLCBhMSk7DQogICAgICAgICAg
ICAgICAgYnJlYWs7DQojZW5kaWYNCiAgICAgICAgY2FzZSBLVk1fSENfU0VORF9JUEk6DQogICAg
ICAgICAgICAgICAgaWYgKCFndWVzdF9wdl9oYXModmNwdSwgS1ZNX0ZFQVRVUkVfUFZfU0VORF9J
UEkpKQ0KICAgICAgICAgICAgICAgICAgICAgICAgYnJlYWs7DQoNCiAgICAgICAgICAgICAgICBy
ZXQgPSBrdm1fcHZfc2VuZF9pcGkodmNwdS0+a3ZtLCBhMCwgYTEsIGEyLCBhMywgb3BfNjRfYml0
KTsNCiAgICAgICAgICAgICAgICBicmVhazsgDQoNCkxvb2tpbmcgYXQgdGhlIGNvZGUsIHNlZW1z
IGF0IGxlYXN0IGZvciBLVk1fSENfQ0xPQ0tfUEFJUklORywNCmt2bV9wdl9jbG9ja19wYWlyaW5n
KCkgcmV0dXJucyAwIG9uIHN1Y2Nlc3MsIGFuZCB0aGUgdXBzdHJlYW0gYmVoYXZpb3VyIGlzIG5v
dA0Kcm91dGluZyB0byB1c2Vyc3BhY2UgYnV0IHdyaXRpbmcgMCB0byB2Y3B1J3MgUkFYIGFuZCBy
ZXR1cm5pbmcgdG8gZ3Vlc3QuICBXaXRoDQp0aGUgY2hhbmdlIGFib3ZlLCBpdCBpbW1lZGlhdGVs
eSByZXR1cm5zIHRvIHVzZXJzcGFjZSB3L28gd3JpdGluZyAwIHRvIFJBWC4NCg0KRm9yIEtWTV9I
Q19TRU5EX0lQSSwgc2VlbXMgdGhlIHVwc3RyZWFtIGJlaGF2aW91ciBpcyB0aGUgcmV0dXJuIHZh
bHVlIG9mDQprdm1fcHZfc2VuZF9pcGkoKSBpcyBhbHdheXMgd3JpdHRlbiB0byB2Y3B1J3MgUkFY
IHJlZywgYW5kIHdlIGFsd2F5cyBqdXN0IGdvDQpiYWNrIHRvIGd1ZXN0LiAgV2l0aCB5b3VyIGNo
YW5nZSwgdGhlIGJlaGF2aW91ciB3aWxsIGJlIGNoYW5nZWQgdG86DQoNCiAgMSkgd2hlbiByZXQg
PT0gMCwgZXhpdCB0byB1c2Vyc3BhY2Ugdy9vIHdyaXRpbmcgIDAgdG8gdmNwdSdzIFJBWCwNCiAg
Mikgd2hlbiByZXQgPT0gMSwgaXQgaXMgY29udmVydGVkIHRvIDAgYW5kIHRoZW4gd3JpdHRlbiB0
byBSQVguDQoNClRoaXMgZG9lc24ndCBsb29rIGxpa2Ugc2FmZS4NCg==

