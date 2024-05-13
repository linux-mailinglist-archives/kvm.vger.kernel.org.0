Return-Path: <kvm+bounces-17310-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 028C08C4107
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 14:51:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC51828803D
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 12:51:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75DD81514F2;
	Mon, 13 May 2024 12:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jrfG7Re0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E7B14F9FB;
	Mon, 13 May 2024 12:50:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.9
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715604651; cv=fail; b=fMjB6xtMJZAitsPC/h3Em6oFicw7Bq3V9RsXCJJn5amK12zswsHz/uozkQ29W77xjGwsJ2vbewkLg0OEk0fezurdZW7WIMZrYITvjEximBZoiHol6ONdLC5fRDM9partujINMZ1cJd7FKyWZUhctOhNYemCnpDO+ISYpzmXGQ3s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715604651; c=relaxed/simple;
	bh=1KodeNwLCus2kEudKljPQzcDo95l3oxYAuKpyIvC/08=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=gPMYgP8fXYcPWdI5swiHMRli8ne2d/dhjhnKDOKP9gBawar1tif26IGFmaoz3ZoIP0781fAiZ7kqsoeh3qylZ3CHeAUoIhCxc6A5q9YF+/fLaJB7VVnuCScKb3YjPCuNas5Tbjt5ycO5SC5EAaKX+amuSOEqN45pGWNKTLAtzdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jrfG7Re0; arc=fail smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715604649; x=1747140649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=1KodeNwLCus2kEudKljPQzcDo95l3oxYAuKpyIvC/08=;
  b=jrfG7Re0mmdtox4Xe3n3IgYZhACHKmSaKuMJo+q6Lsj6gCcnIquvYRMX
   OobwJ3IidcLZZyYQpxJ0injnrIaajgVgPHFChr6UmlT5akQlZlCT2BN2J
   7F8zRpQ+lTlpNPQc6jIVdRT+lS/ZPmaDp1EqP4bN0EPA8/mwJ9L22ADAi
   31w2UW3nMXdNC+7xNtOXiJzsxb/gVzqAtyMh8M9DSRG4aUHUCN8ZuE91B
   XI7tvz03xHKMXZmx1chehOUCz22l48f6andc8zayrwELe1Zlz5iCQUyky
   ObqUe48CIPbC7Km03i+HV43wfb9iW2LewxORX/NoYcg3e57gdk5+KalaI
   w==;
X-CSE-ConnectionGUID: S2S3NBb8S32FFs5f8OpskA==
X-CSE-MsgGUID: z/6NPCnqQaSq2ToXEbDdGw==
X-IronPort-AV: E=McAfee;i="6600,9927,11071"; a="22203574"
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="22203574"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2024 05:50:48 -0700
X-CSE-ConnectionGUID: o4dNhtTcTtqI71Pjcpn4Yg==
X-CSE-MsgGUID: W2t3X6PnSvWjKqGtfQNzmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,158,1712646000"; 
   d="scan'208";a="30898279"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orviesa007.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 13 May 2024 05:50:49 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 05:50:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35; Mon, 13 May 2024 05:50:47 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.35 via Frontend Transport; Mon, 13 May 2024 05:50:47 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Mon, 13 May 2024 05:50:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pq35GJ8P3jcERSTyjPhTewlotqjqoaTaDSqyRWQazQHYnJwpavWDQMaUHoNV4gndQ6FgUGhR1rRYjrF2w4AUzs8fX7ddhzdGYax+ACwH6bgjawq5YUqSTzXQKZaPcto3jiy9QIoUXnenKfMpGIuOEOZSGCyTPjOgy0Rz2nWaD/bE3VEasRI9C5HRetTJJjR5vLFv0ttOTSEpNMDzsnPWrJlDHsFgqdD/o4Y95qjtmo+RR0XiF32XjBHgUzNbVZJFc8eF/UieEN/IKdJguXEaaUif/X/uGHffT6vRdfZl4m6yfTgc1drdKZoUHReg0+2U1k8SRzfLQSC7VajtiYxbfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1KodeNwLCus2kEudKljPQzcDo95l3oxYAuKpyIvC/08=;
 b=NsnkvyKdNcoKC3QDjidIgiJiP4jbRDpRQWU9OoCVD4SZhOWSX8ldefe2XP2dtO2DcvG206SuUhlWAea4mDYph98xY0qhwARr9xsobrD6xVEToldVbBaRx71Dmk0HG8e71A9wkQHZTCcOFY2AKgZyN8DdPP4dZvKyqSMc+jIYwPUzsqmXikL2DQwljlQtBdVh6KW2nhJorMHm2GQmJ9tuj4vxFDLtuIDctQm9/LosVfxrLzcYgJkYKZELwzO9FCcRi1cg9hTZ9sJ5gHquRvsMAtxO/8vKwmcDMw9umWNqZxPTsXtV7k/GKu/M9OMgszBmlGCfuUaXDn2zV0tAntyBEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SN7PR11MB8110.namprd11.prod.outlook.com (2603:10b6:806:2e1::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 12:50:45 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 12:50:45 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
Thread-Topic: [PATCH 1/4] x86/reboot: Unconditionally define
 cpu_emergency_virt_cb typedef
Thread-Index: AQHal2nylenJIMZCB0GHU8CJed0CxLGVOYGA
Date: Mon, 13 May 2024 12:50:45 +0000
Message-ID: <5dfc9eb860a587d1864371874bbf267fa0aa7922.camel@intel.com>
References: <20240425233951.3344485-1-seanjc@google.com>
	 <20240425233951.3344485-2-seanjc@google.com>
In-Reply-To: <20240425233951.3344485-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SN7PR11MB8110:EE_
x-ms-office365-filtering-correlation-id: 9e45f38a-f77e-4aac-e93e-08dc734b4ea5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?TjVUZ3F0Ty9scmFjaUlyQUk2VlB0RjJLYS9aNXpxMGNpQ0FkcjMzaW9hbFNG?=
 =?utf-8?B?R3k1Z2Q0Y2VZTXJNZFU2RC9WLy96bDJtNDBiRDVodjJPbUJGaW1CblV6Q3ZG?=
 =?utf-8?B?RXVXQ0tXTUJJWXpCNHk2V3NMKzV6T2c1L0pvZy9jV2VkdEdvRWRWMmVhakl5?=
 =?utf-8?B?YmFSVWtlMnBlc0RNRldJSDN6MC91Q1FZSEpsdERqdk1zR0VtVXNkR3hYZktI?=
 =?utf-8?B?UDFETEFFWTNXbSswNS9GcEVYZnZHNDVYOWxZWVdENUFBTk9tSUdpWUdRNGV1?=
 =?utf-8?B?R090VmVnT1hSZk5DNEd2UXJNeENVM2J1MGVHVW4yWlJuUzBkdjZ2dHpwSGQy?=
 =?utf-8?B?eEtqcmlWMUJyQ094N0hlYkwycXArMzRtNGhWWm9JU3RZV1lZSFNjdlRybk5L?=
 =?utf-8?B?b2tFL0tpZzhUdTduNGh0cjVSaW04SENTWFIvUGJXQndoS1VlZUhtdUZ0OWtM?=
 =?utf-8?B?b1dNcUhQcnFEbVh2NVFPU2EzYVpJTFlwYTBURlB5ZXRCMTB1ZmRGWUFONzNB?=
 =?utf-8?B?K0g0blpzclFtYlVNWUtIRVRjSnNMeTBQQlpPMUZvYVBiY0JiTVdES1VpQmN3?=
 =?utf-8?B?L3p1UEhmQUxuZ3h3Q3JlYmdpYTZBaHlTcGRsYW9QTDRaUVp3UG9xMysrM3hB?=
 =?utf-8?B?QUVteHZQOTE1QUtEV2V5THgvNUUweFFLN2M1UXlUNXBkSjZ3OTBKT2ZqQkpD?=
 =?utf-8?B?TDdqQitVQzVNdVd5VkNlNFVGNWFjMFI1d0hOVmZKNzNndG93STZzSEcxTHlx?=
 =?utf-8?B?dXY2cWxPNERXbXRtblhmSDhLdWtLUVpKVEg5L2YzZkU1YVVwTEZrV0l1T1hK?=
 =?utf-8?B?aEhuY0YwS3ZBdTJaZCtONXlMc1V2UE5KN1pLZlRQNFJvM1hHcnJLWkc3WnZi?=
 =?utf-8?B?eGRaWU5Fa3R1VUZnYzFPckhWajVFU3N1V3VRY2QyUERCc2d5S25WMEV1WU9j?=
 =?utf-8?B?dUNlLzIzRWxobkkrbW1wOUEwZ2tHK1BVTWFBeTBrTENFL0RQWWJqeWpUZGhv?=
 =?utf-8?B?SjJXZm50L2E5OUw2a1VndzF3ZGllQ2w1YzRKZ0pmVzF1TXJzWnI2OFZ2b2RO?=
 =?utf-8?B?QkloZFVZWEw4MkVoVWlLRFpqZ2JHdTdYMCthWjlSNXJzK05mUFIzR2JpZkpV?=
 =?utf-8?B?azhzUjBXRmFXdXB4MGp1bWUwSEZjL2o1YXRoRlNCVEs2TUxINndjK1ByY0Fj?=
 =?utf-8?B?bzhFQTR6MUxvMExDbWhPcGNzaDFWaFJQUXloT1ZJM3lXTFJXSEZPWW1KVTVR?=
 =?utf-8?B?cWI1NllxSk83a0tYTnk2RjBlZXo5SmQ3dEYyN200bXpXd2FqQnhnVzh3dWpU?=
 =?utf-8?B?QzFOdThFZURmUncrQ2dzT1BRbDNuNnA0U0txOHFDSW5Ud2V5RkRzMS9zTjg1?=
 =?utf-8?B?VENTSTgxSnFoWi9QQ3JtelkvU0JlT2JjQXVKRUQzcGF2QzF4cVdQL1ByaTll?=
 =?utf-8?B?L3JoWEYxSXVoVUYrU3dtY09qTFV0QnY3dWVtRTd2eXJIRU9RZklwS2Nlb21N?=
 =?utf-8?B?LzdSY0ZyYjQ4L3B2L2tyUnQ5ZkVvZVg4ODJLSWtycTJxZkU2dlA1NmdkM1oy?=
 =?utf-8?B?SXB5QVRXRVN2VGJNY29pck03RWwrTWhCR1liT3Uwa2hEem9iL1VsTnZWTGl0?=
 =?utf-8?B?ZU16c0hjZFhTYWRjSEdMQ3JEd2xYcDVrWmZBV0w3emtEUnUxYS9jUS84dHBt?=
 =?utf-8?B?SjU5a0FWeUFaaXIvblprYkw5VnplUDgvbVFTVUZ6R1hnWHc1SlVUUUVWTVlZ?=
 =?utf-8?B?UFpLckJUbUFuUXNUL0ZKSU1oL2c1dXFCWmVSZlJlR3dNK0pNbEdnODl1UzdF?=
 =?utf-8?B?c2lCdGxReW16TVNNTFV4UT09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ak90VG9uNGZjTmZBUWMyS2ZXZjZOUWUxY1Q0Tnc3SXZQSnYwYzVuQVFkc0dn?=
 =?utf-8?B?L2ZYQzd0anFqSktWMkpVd25XaTdUcDZwM05GL0Z0OVpQOTB3d0kyVDFGUnpr?=
 =?utf-8?B?U2FGTG9xbWN6alBpTnRGOWFqSEhQZEVpVUticDIwUHZoMzZJaXVMVFptOTN5?=
 =?utf-8?B?ODBHQ0NSSkhlczBUYW5hdlJBK2pFMDVpdFRCRjFrdUFTRFFJMm4wRDRkMlBZ?=
 =?utf-8?B?elYvVHBrZ3dRblpDWjVYNnFOOUlJZDR4UXhRTDJkcm5KSU0wcWdQSnRoWFJo?=
 =?utf-8?B?VDh0QlkyVXhGbmNMaExNc3JKdzBTTVpXSXU0R3I1N1lISVZjRVRJVXRqQllT?=
 =?utf-8?B?akpyUXB3UXhuV3Iwbm15VEdvcHJTL004VDJNZUlISkpJL0NEUkN1dWxlZnRt?=
 =?utf-8?B?eWZRcXM3M2dxT2VpMFU3cWsxUDFXRkZjWWIrdU9oZ01MYkdsMlFNVjFQejk0?=
 =?utf-8?B?ZXlBbWFKcTNMRjU3a0x6SmsrWmlOVHJHQ1hMbFltTU9mNDhDdC9DeVByeXdq?=
 =?utf-8?B?UTFid3IyY1BjTjFNN25KZENJTW4vcXVOZ0lDMG1BWXd3Qm5mRHRmUjZFU2x1?=
 =?utf-8?B?NTFhWG1TcjVwdnk0aUJsTnVmSGVDaFh1cGJvSU8wVTYzeFFacFd2eFRBaXRw?=
 =?utf-8?B?RFo0OEVxYkU5Y0VReGI3WW5RNUNIbVliVDdLY3BpM2xjdC9sZFRCTlA5cGlJ?=
 =?utf-8?B?RUZkT3RFSEthNnM0dXNxQkU5b1RIVEhwUEY4WW81Nm94S1ZlZ0ZlWGNmN2Zx?=
 =?utf-8?B?ckN2SWZ6NkdvOFRvZFc5a0JYVjBORnQ4cVFFVDMvQ1NYaERzZmJjRDlNMHJu?=
 =?utf-8?B?VnAzWi80L3JYcXF6ZUpXMmVTbFNKYVlkWTJDYnBvS0xNT3ArS0xlZm1rdjZq?=
 =?utf-8?B?clkySTd4SGJQaTBUcSszaGU2L1d0d3JVbUpxa2lOTFVGMjJmSy9rYkU5K3E5?=
 =?utf-8?B?em0raTI4VzdaVk5Lb21jdFo0VFBTVExncjB1cS82MjhmUUQ3RURKYk5YeFZX?=
 =?utf-8?B?UGxrZ3RBZDJXL2M4QkQ0MVZ3U2FvMXRTeW5UdW0rNFlkQ3plYm5FSis1cHp5?=
 =?utf-8?B?MjExckJ5WFA3RUN2OEhFMkRsSkNxbWRzcFBTRGNkRzIyTGQzTytOR0VWQ3Vy?=
 =?utf-8?B?VnRWODFSNlltNGxRM0hBVzBpRG9pTE1rTkdEdGl6QjZXc1MxSFhLcjF2ajBH?=
 =?utf-8?B?enlZK2dnMEdoYUNVcDlVbms5VXFuaERnY1RWdU9JZGlOZllZU3ZBcVduT0po?=
 =?utf-8?B?TUtOTkw2OXc5ZnEwUHk1VFFVQUdhN3pxWE8vUzNqbUF0MzZaaGg3dnFTOUlo?=
 =?utf-8?B?R0QrbkZxRTQyVmwwR0t0WkNZa2RRNkd5NzhqSXRrSDVFSkFYTGxmd2lnbUlD?=
 =?utf-8?B?OENqWUFMOUo3RGZTYWVOdjloNTNKNk9jdXgzQ1BYK1lWK1NtR1dGbmRpWElo?=
 =?utf-8?B?T0tHOE1tZkNkcmJnQlVDQ2NXeFV3b0hCRUFORDkrY0VNTFJqclhMUE5mbW1S?=
 =?utf-8?B?Vk1TcklOWE9sZDI3WXFyalJ6YitpZGxQcnJzektIYnBYeDJqVzllZS9OUjBw?=
 =?utf-8?B?ejJEVW1nRXZraEw0Smt0U05HdjB6NXowaEZhdWZLcS9BL0xHMkNRdFlKajdW?=
 =?utf-8?B?UWEzaVdKY085L2hZNkU1ZUdWaWFscFBNS0JyaCs1eDZyaDZUOEQzZEdWTVhk?=
 =?utf-8?B?aXdkTmlFcnd0TTloa3ZRTkNNYTNZNUVmVDlKcFNUZlhVNDdNcXNGNE43Z1dr?=
 =?utf-8?B?amE3RnZzRDJjbGUzUzdYTEsxcktmWEphMUpGUjNnaUxwYzB4dkV3QnBTdE5T?=
 =?utf-8?B?RDdHWEVkRllSTVdlL1BNQmZMVEtTazRXT2IzQmxMQ0RqcFowVUJFYXVzZUY4?=
 =?utf-8?B?ck5zdHA1VTVYMnFmelkweW5RejBqL0hoS0JCMXhCTGg1MGlKLzZDQ3NFd2dt?=
 =?utf-8?B?d1REdzcyWnBLQ3ZHaEVmRm44TmNjdmdJeHFkbTNHdDNDclF6NGpPaTJsSzZX?=
 =?utf-8?B?eTcrVEt6TUgxa29KSFR3U1FKdTEyWnZRTW5haWt0MUZkd08vSDRFMG1vblRC?=
 =?utf-8?B?cnp6TUQwakpPZk44enNPbHFTWGYwbW5YTFNUY1Y5R1k4c2VoVUs0dkd5eFZK?=
 =?utf-8?Q?wm0T6DlHCO6IPdo/t4vdWX8ns?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD6752ED7120F04689060EFE5CCFBFD5@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e45f38a-f77e-4aac-e93e-08dc734b4ea5
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2024 12:50:45.8942
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wVVPp1wOixJ/ELfQOlM6lRxjAb+fVquD5wD0zjgNisS8//A4c3aNxJnejjWKSEPPT3TpFHtIrwbiB3MpNPeXQw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB8110
X-OriginatorOrg: intel.com

T24gVGh1LCAyMDI0LTA0LTI1IGF0IDE2OjM5IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEZWZpbmUgY3B1X2VtZXJnZW5jeV92aXJ0X2NiIGV2ZW4gaWYgdGhlIGtlcm5lbCBp
cyBiZWluZyBidWlsdCB3aXRob3V0IEtWTQ0KPiBzdXBwb3J0IHNvIHRoYXQgS1ZNIGNhbiByZWZl
cmVuY2UgdGhlIHR5cGVkZWYgaW4gYXNtL2t2bV9ob3N0Lmggd2l0aG91dA0KPiBuZWVkaW5nIHll
dCBtb3JlICNpZmRlZnMuDQo+IA0KPiBObyBmdW5jdGlvbmFsIGNoYW5nZSBpbnRlbmRlZC4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29t
Pg0KPiAtLS0NCj4gIGFyY2gveDg2L2luY2x1ZGUvYXNtL3JlYm9vdC5oIHwgMiArLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcmVib290LmggYi9hcmNoL3g4Ni9pbmNsdWRlL2Fz
bS9yZWJvb3QuaA0KPiBpbmRleCA2NTM2ODczZjhmYzAuLmQwZWYyYTY3OGQ2NiAxMDA2NDQNCj4g
LS0tIGEvYXJjaC94ODYvaW5jbHVkZS9hc20vcmVib290LmgNCj4gKysrIGIvYXJjaC94ODYvaW5j
bHVkZS9hc20vcmVib290LmgNCj4gQEAgLTI1LDggKzI1LDggQEAgdm9pZCBfX25vcmV0dXJuIG1h
Y2hpbmVfcmVhbF9yZXN0YXJ0KHVuc2lnbmVkIGludCB0eXBlKTsNCj4gICNkZWZpbmUgTVJSX0JJ
T1MJMA0KPiAgI2RlZmluZSBNUlJfQVBNCQkxDQo+ICANCj4gLSNpZiBJU19FTkFCTEVEKENPTkZJ
R19LVk1fSU5URUwpIHx8IElTX0VOQUJMRUQoQ09ORklHX0tWTV9BTUQpDQo+ICB0eXBlZGVmIHZv
aWQgKGNwdV9lbWVyZ2VuY3lfdmlydF9jYikodm9pZCk7DQo+ICsjaWYgSVNfRU5BQkxFRChDT05G
SUdfS1ZNX0lOVEVMKSB8fCBJU19FTkFCTEVEKENPTkZJR19LVk1fQU1EKQ0KPiAgdm9pZCBjcHVf
ZW1lcmdlbmN5X3JlZ2lzdGVyX3ZpcnRfY2FsbGJhY2soY3B1X2VtZXJnZW5jeV92aXJ0X2NiICpj
YWxsYmFjayk7DQo+ICB2b2lkIGNwdV9lbWVyZ2VuY3lfdW5yZWdpc3Rlcl92aXJ0X2NhbGxiYWNr
KGNwdV9lbWVyZ2VuY3lfdmlydF9jYiAqY2FsbGJhY2spOw0KPiAgdm9pZCBjcHVfZW1lcmdlbmN5
X2Rpc2FibGVfdmlydHVhbGl6YXRpb24odm9pZCk7DQoNCkl0IGxvb2tzIGEgbGl0dGxlIGl0IHdl
aXJkLiAgSWYgb3RoZXIgZmlsZSB3YW50cyB0byBpbmNsdWRlDQo8YXNtL2t2bV9ob3N0Lmg+IChk
aXJlY3RseSBvciB2aWEgPGxpbnV4L2t2bV9ob3N0Lmg+KSB1bmNvbmRpdGlvbmFsbHkgdGhlbg0K
aW4gZ2VuZXJhbCBJIHRoaW5rIDxhc20va3ZtX2hvc3QuaD4gb3IgPGxpbnV4L2t2bV9ob3N0Lmg+
IHNob3VsZA0KaGF2ZcKgc29tZXRoaW5nIGxpa2U6DQoNCgkjaWZkZWYgQ09ORklHX0tWTQ0KDQoJ
dm9pZCBmdW5jKHZvaWQpOw0KCS4uLg0KDQoJI2Vsc2UNCg0KCXN0YXRpYyBpbmxpbmUgdm9pZCBm
dW5jKHZvaWQpIHt9DQoNCgkjZW5kaWYNCg0KQnV0IGl0IHNlZW1zIG5laXRoZXIgPGFzbS9rdm1f
aG9zdC5oPiBub3IgPGxpbnV4L2t2bV9ob3N0Lmg+IGhhcyB0aGlzDQpwYXR0ZXJuLg0KDQpJIHRy
aWVkIHRvIGJ1aWxkIHdpdGggIUNPTkZJR19LVk0gd2l0aCBwYXRjaCAyIGluIHRoaXMgc2VyaWVz
LCBhbmQgSSBnb3QNCmJlbG93IGVycm9yOg0KDQpJbiBmaWxlIGluY2x1ZGVkIGZyb20gLi9pbmNs
dWRlL2xpbnV4L2t2bV9ob3N0Lmg6NDUsDQogICAgICAgICAgICAgICAgIGZyb20gYXJjaC94ODYv
ZXZlbnRzL2ludGVsL2NvcmUuYzoxNzoNCi4vYXJjaC94ODYvaW5jbHVkZS9hc20va3ZtX2hvc3Qu
aDoxNjE3Ojk6IGVycm9yOiB1bmtub3duIHR5cGUgbmFtZQ0K4oCYY3B1X2VtZXJnZW5jeV92aXJ0
X2Ni4oCZDQogMTYxNyB8ICAgICAgICAgY3B1X2VtZXJnZW5jeV92aXJ0X2NiICplbWVyZ2VuY3lf
ZGlzYWJsZTsNCiAgICAgIHwgICAgICAgICBefn5+fn5+fn5+fn5+fn5+fn5+fn4NCg0KDQpMb29r
aW5nIGF0IHRoZSBjb2RlLCBpdCBzZWVtcyBpdCBpcyBiZWNhdXNlIGludGVsX2d1ZXN0X2dldF9t
c3JzKCkgbmVlZHMNCidzdHJ1Y3Qga3ZtX3BtdScgKGUuZy4sIGl0IGFjY2Vzc2VzIHRoZSBtZW1i
ZXJzIG9mICdzdHJ1Y3Qga3ZtX3BtdScpLiAgQnV0DQppdCBkb2Vzbid0IGxvb2sgdGhlIHJlbGV2
YW50IGNvZGUgc2hvdWxkIGJlIGNvbXBpbGVkIHdoZW4gIUNPTkZJR19LVk0uwqANCg0KU28gbG9v
a3MgYSBiZXR0ZXIgd2F5IGlzIHRvIGV4cGxpY2l0bHkgdXNlICNpZmRlZiBDT05GSUdfS1ZNIGFy
b3VuZCB0aGUNCnJlbGV2YW50IGNvZGUgaW4gdGhlIGFyY2gveDg2L2V2ZW50cy9pbnRlbC9jb3Jl
LmM/DQoNCkFuZCBpdCBzZWVtcyB2ZmlvIGRvZXMgaXQgaW4gdmZpb19tYWluLmM6DQoNCgkjaWYg
SVNfRU5BQkxFRChDT05GSUdfS1ZNKQ0KCSNpbmNsdWRlIDxsaW51eC9rdm1faG9zdC5oPg0KCSNl
bmRpZg0KDQoJI2lmIElTX0VOQUJMRUQoQ09ORklHX0tWTSkNCgl2b2lkIHZmaW9fZGV2aWNlX2dl
dF9rdm1fc2FmZShzdHJ1Y3QgdmZpb19kZXZpY2UgKmRldmljZSzCoA0KCQkJc3RydWN0IGt2bSAq
a3ZtKQ0KCXsNCgkJLi4uDQoJfQ0KCS4uLg0KCSNlbmRpZg0KDQoNClRoZSBvbmx5IHJlbWFpbmlu
ZyB3ZWlyZCB0aGluZyBpcyAnc3RydWN0IGt2bSAqa3ZtJyBpcyBzdGlsbCB1c2VkDQp1bmNvbmRp
dGlvbmFsbHkgaW4gdmZpb19tYWluLmMsIGJ1dCBJIHRoaW5rIHRoZSByZWFzb24gaXQgYnVpbGRz
IGZpbmUgd2l0aA0KIUNPTkZJR19LVk0gaXMgYmVjYXVzZSA8bGludXgvdmZpby5oPiBkZWNsYXJl
cyBpdCBleHBsaWNpdGx5Og0KDQoJc3RydWN0IGt2bTsNCglzdHJ1Y3QgaW9tbXVmZF9jdHg7DQoJ
Li4uDQoNClNvIGl0IHNlZW1zIHRvIG1lIHRoYXQgdGhpcyBwYXRjaCBhcm91bmQgJ2NwdV9lbWVy
Z2VuY3lfdmlydF9jYicgaXMgbW9yZQ0KbGlrZSBhIHdvcmthcm91bmQgb2YgZXhpc3Rpbmcgbm9u
LXBlcmZlY3QgPGxpbnV4L2t2bV9ob3N0Lmg+IGFuZC9vcg0KPGFzbS9rdm1faG9zdC5oPj8NCg==

