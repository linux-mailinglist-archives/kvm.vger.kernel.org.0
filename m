Return-Path: <kvm+bounces-26303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 974C9973D37
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 18:28:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B9BCEB23248
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 16:28:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5321E1A2550;
	Tue, 10 Sep 2024 16:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DyniRLQC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0B38191F96;
	Tue, 10 Sep 2024 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725985701; cv=fail; b=cRDTkmqNuUXFISHvCyZMZ2AVYThRKaW17r603kC2ziTWyotZLgTNRuSpVKd56v5ZhfXx4oyLJAkYy/ooIpKnw55uOjzvBJnNb4C4dnAJ9AqzzjjspcDQe9NAsd9lV6YQUAhnc/MAFixLeMWelVLkE4NzhlDV7DnJ/h/YGdUK8WE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725985701; c=relaxed/simple;
	bh=ES4xjPADBgOcF26b4egwUV5t5HXszobIakPCfNOYAjQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HDMV2wbgxvfyZ328o3n9V08t+ZgKesJzsp1wW5WgKW+kglXfV3MGbyriLa3Stk/uHvVZauH8DLQMTzlRexBvO2YqVW/e2N+uc/7el9eK7YFfFwdr0Fa9rsSefYLFlPnVpmkBboil2dAVQEnoF5Jr1FvbOY/Vf3RJ/BI4X8fqs1I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DyniRLQC; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725985700; x=1757521700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ES4xjPADBgOcF26b4egwUV5t5HXszobIakPCfNOYAjQ=;
  b=DyniRLQCZ9pq2ku8IDUDlysDICuDDPqdk7eczlSmNhrWNbVJvKA3jPVL
   ubZ5s/9/vYWuotqZuoZmcwXOW4E7VqLI/SdmgQEwB8UYJ/1uj1m7zBQOE
   BG67HDKm7r2lcc079/Yyd3H+tOwoD1Jp9rql1CWr1scc7NEFpyh1bJGyM
   pBPc36ui44A0R29XcD/D+zsO2GMah2DNIcJo9GhCN4lr41GfTWUPjGFcT
   y0FXA8pMmtlckTg0HcKV4F2YQRSCxTj6KVfFv5N/OtCg8Qf5E19jCwZ13
   Z1NN0h/SbDyTW5Rs1TNzGdFlF/acaH3NPKDZZ3Bc0qaZtu9FOraiYucTY
   g==;
X-CSE-ConnectionGUID: WeTtJ2ZjTwWIxTUyHjfqrA==
X-CSE-MsgGUID: Mg6nAcE8R2y+LBM7wTgwuw==
X-IronPort-AV: E=McAfee;i="6700,10204,11191"; a="50160477"
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="50160477"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2024 09:28:19 -0700
X-CSE-ConnectionGUID: fOBHWkZ1RsKWfVoNDsoxmw==
X-CSE-MsgGUID: MEGmUxdJQTWgdgn18bAHPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,217,1719903600"; 
   d="scan'208";a="66917565"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa010.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 10 Sep 2024 09:28:19 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 09:28:18 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Tue, 10 Sep 2024 09:28:18 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Tue, 10 Sep 2024 09:28:18 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Tue, 10 Sep 2024 09:28:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XSOZfx/7UD1GMmhg+SfB39CiR9X2y65HilRh6+G8n4t+1Po8jmgsrMMY9Z4ucpcUgICjBJI+NSoK9muJhR1Jw61oZdQLhB2k1jCQZiJhyNxTVocwk4zuHSLXuPO7BFt7HhGZ6AdImtO4zbfMThqkxTrA+OkztkJfB4Der50wZS2GvoADH53lDlWUKlT8VACaFWpWodglFhEAFo/lRR0FuKlPrQVkHmqndy5RM4hfh28gRVN5FJ6M0M9aXP83dEpGkCgR1dXzkOhoSDiscy12U9QibuXYbUfCjTABhPB0VbLv/S9yF7AAn9zyE6jAYnT+v8vBEnHmxbtizY/UQC9wvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ES4xjPADBgOcF26b4egwUV5t5HXszobIakPCfNOYAjQ=;
 b=VIIFHVgW4eIvsj5W1ynFdsYj/i1vtZma1ZNgYIBkcuLTJ36uFJDfszDvni2lrZY0kDHms4I/d9nPGCe2miLjXuzi76OPyAxf6Q4j8RmQsxl0MbkUh3Q0FPnFlg6/dr3fURw0z2AwAMUAb0EBb6DC2OojGguM/QBxzWSGmKnVSpDln8u3ODTVA9LHe09GcXp3CZXESSXjDYSqRBccfxHNzuduR2qtZVMSx9vBdHPuk7w2nBMuLhNj9YNutyHTVQAYNLymL7uWOcDtyeoNpuiRidfUgKKQc5/VE0MegWM5/1qZ43DL9qxOVLfNIW62OWweIy8y3nchQ20+L/sy/YGOnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by CYXPR11MB8712.namprd11.prod.outlook.com (2603:10b6:930:df::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.21; Tue, 10 Sep
 2024 16:28:13 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%5]) with mapi id 15.20.7939.017; Tue, 10 Sep 2024
 16:28:13 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Yao, Yuan" <yuan.yao@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Zhao, Yan Y"
	<yan.y.zhao@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"dmatlack@google.com" <dmatlack@google.com>, "nik.borisov@suse.com"
	<nik.borisov@suse.com>
Subject: Re: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY with
 operand SEPT
Thread-Topic: [PATCH 09/21] KVM: TDX: Retry seamcall when TDX_OPERAND_BUSY
 with operand SEPT
Thread-Index: AQHa/newpsWgW6BkgUyDF9VgqodFjrJPnCEAgABS34CAAA3agIABDTgAgAAL3ACAABXhgIAAC2gAgAAItQA=
Date: Tue, 10 Sep 2024 16:28:13 +0000
Message-ID: <655170f6a09ad892200cd033efe5498a26504fec.camel@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
	 <20240904030751.117579-10-rick.p.edgecombe@intel.com>
	 <6449047b-2783-46e1-b2a9-2043d192824c@redhat.com>
	 <b012360b4d14c0389bcb77fc8e9e5d739c6cc93d.camel@intel.com>
	 <Zt9kmVe1nkjVjoEg@google.com>
	 <1bbe3a78-8746-4db9-a96c-9dc5f1190f16@redhat.com>
	 <ZuBQYvY6Ib4ZYBgx@google.com>
	 <CABgObfayLGyWKERXkU+0gjeUg=Sp3r7GEQU=+13sUMpo36weWg@mail.gmail.com>
	 <ZuBsTlbrlD6NHyv1@google.com>
In-Reply-To: <ZuBsTlbrlD6NHyv1@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|CYXPR11MB8712:EE_
x-ms-office365-filtering-correlation-id: 9049fe10-9de3-40b1-7157-08dcd1b5912d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?T21hMG1VNjFMTXRpVW1tM1RHSVdaTzJTQmN6VCtLZWdNendxY1JZT3NnOHY4?=
 =?utf-8?B?Um1ydlNXdktEMmQ1MUpQeTg2TGRtTWFDbHJvZEZDaFNobUdTWmNJN3Vvb2pr?=
 =?utf-8?B?Rys1RE5IenRrdVRDSHNJRWprSGVYdktJQnNhQ293bU1pR1RzenlvWDJ2R0sv?=
 =?utf-8?B?YTdxVjJlc2NPRzQydEY4YWlNT2dQNVg3VGoyVUpBc3JJUXNQK2FBcTJ3Uzcr?=
 =?utf-8?B?QTVqT1lBUVJBb1NXOGkrWENJT1RRUnJmdm5SQ3RURnRrUitBRlVyb2YzSHFh?=
 =?utf-8?B?L3hOTlpOSjZlL0poVWJ1ZFZINU5SdituZU9QeE9PRlVMN0xiMXozMDhtdjdB?=
 =?utf-8?B?Y2tkVGZCWFR5NDQxb3VKTTNyOVJTaVhrZVB1b1FQNTN1SmxPSExIWWMxRkN2?=
 =?utf-8?B?WlVpdW9DTGg5RUZQVzBSQU1wWFJ4SDAzZ1Y2cFlyak5ZVEUzQ3RNZ1J2ckZk?=
 =?utf-8?B?Ykl5ZHljNy9ONmNYbTBHZG5sWnU0YWlnVUlDazJhZEpUNTZUWHNKSldBczc5?=
 =?utf-8?B?VU1BemlwcjAyVExYc3prbmd0bE0rbE94ejdKcUFtaVN1R2trS2VwU25DZ0tY?=
 =?utf-8?B?VENlUUx6MkZ4Nit2QUladjgyRWNIWUlSUDJieC9jeDZ1ZTNCRktmVnd6SjE4?=
 =?utf-8?B?WTdVSklYdGkyaEcrQmIzaiszSk9FWm9ObldKVmRFeUZPeFJ3VEw3TlRYTXAw?=
 =?utf-8?B?cy9NdFladWVuZ3RGblZzZk5CaTZQQzl6cytmRDRwb2VxS1FTNDV6WlJINlpP?=
 =?utf-8?B?c1RnbXhrMG91c3NBUy9SVW1lbS82THR6Nytwam1tVE0wTmFxZHlrUUhmNzh1?=
 =?utf-8?B?NVZzeFI0Q1J3aUIrU1hJU1pKY3htMTFQQlREK0hzSUdUcjlyNmMyZ1lYcVJS?=
 =?utf-8?B?N2JUcnJ6NHRsMHVVUHNBSDVvbVJOSHowaE8wZWVVbTRra0lsdXdCUlRCTlhU?=
 =?utf-8?B?RXdWdFRzcXYwTDBjZDVjWGtkZm1vVUpFajVXZytIWXZMMC9hMFJ5WDB4a3FJ?=
 =?utf-8?B?L1FnNkx1WUJjeWpLZ0tSYlYvTkpwdXlQMStqRVg1Z29ERWJsaGNWRDkwTzBM?=
 =?utf-8?B?Nkt6aG1HdEZOYlVOYzJmWUo2TmRkYjNWdkZjdUpHRGhYYldDRFpVMCtXREkx?=
 =?utf-8?B?MVRwTzR5VVA5dTZrTTVzMDJzS1I5bW1FeURHdHY0T3lRY2JpTkpMVE1weVhF?=
 =?utf-8?B?dlIvKzFxWFFGL1FMdStwY2laOWYvOUt6OFZWNjcrUWJCNXBzN2RxQSsyaW8w?=
 =?utf-8?B?Q04rZE9PaXNPeGhSQyt0RmNvYUwvWGRXSHlnckloSk1Fdk15TkVtdnpkb3JW?=
 =?utf-8?B?ckNNd2pHengvNVFjN25LNW5mb29LdW5TY1FrUTFCMDRqWmdsRThBSHppZ1pN?=
 =?utf-8?B?UGc4dkRtSWQ3aGpmNGI4eTNEcUFSSk5HWndzb1JhY3RiZzA3MzNvaElYQ0Zw?=
 =?utf-8?B?aUZQNEJMWCtRT3Y0ME9WbWNtd0hBU0VSdys0ZSthNGE3TU1TN0Jka2lyVFJI?=
 =?utf-8?B?UmNDejgrVGFOVmpuSFJJdjY5dzlmZ0NZamo5bENETmt5Mk01S2M4RUJBNkVF?=
 =?utf-8?B?eG51cW41Q0x3ZXNkaEtsamxiYVdUWG1MNnQ5cTlMUEcwNEJ2NHIxV0xEUFRk?=
 =?utf-8?B?SDl0REJaUG95VFdJZnIxdlpMYVBtUjJWNHZ3YlI0QjgwYWtacXRqVkEyVWJj?=
 =?utf-8?B?dnlBNGlRQ0NFSVNqZlFiQlRBR2pjRE9rK3FVTWNTbllWc2twMGlORXZpTGVS?=
 =?utf-8?B?WEVrcWVuM1JFaEFZZ3pUdkhERlV5T0FTWm13U3NtTEJrTy9HcU1JdndtWG9x?=
 =?utf-8?Q?J9bI9OfT6nfETx+Sj2MKwfbwfpQQFVtFcAwCw=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?anZyWVpxcGRYcDg4bGxXb3pWODE3MlBmajRWRWpiZ3lJN2tZcVBRSkF0SG9L?=
 =?utf-8?B?ZmNUaXpBekRqbThIU0ppSFNjU2dwZGpXZ3NVQzVoZ1dnQmRkZGtPcEl5R0gr?=
 =?utf-8?B?c0JNNzU2SU9NMGZqaGh5TjdKYW1PcWtUa3ZWeFlMWXJaUFNCaHd5a2R0UFJk?=
 =?utf-8?B?NHhXNGFvbkZmYnVDU0xxd0VlT0xJVHdOSkVpQWRsTXoreTE3OGlWRDJCWm5N?=
 =?utf-8?B?N0lqK0FaMHhmU0hRdG45ZFdDMGtZWjBjdnFRZjkyTkR5RnU2ZVU3d0NtWDlm?=
 =?utf-8?B?S1hZMGJKNDAwNnRleFE0WmVtb0liRFJrMVZJRXRveHYyUGt0OVFpVGZFNVJv?=
 =?utf-8?B?ZzE0WUt3dzQ3b24xNlEzVTdzWTdOaEl0cWlhMVFtK3AvNzM5RThxaTBXK3p4?=
 =?utf-8?B?TEZ2N1NydXZ2ZUF6SnBObzk0TkZtKzFoZEhQZGw3VXMzcTRHUUZ5OWV5dWth?=
 =?utf-8?B?Q1NtOFIvdldqei9KNHVmRHdVQnFXbDNiVXdaV3diZnV4QnRBVmxucFlhTUVl?=
 =?utf-8?B?aXhBMHJrYWtaTVNDRkRqRWF4bnZlVGtaWXBiM0xYL2VzZ3NJZ0ZpOXBZRmx0?=
 =?utf-8?B?ZVhMN1NXRTMzb3U2ay9JNVgrUkZYUHQrenBOVlVaNnNnbUp2QU5DMjlicE50?=
 =?utf-8?B?WFViRlcwN01vd0xwQUY5czM0djBFZ1NsRXJDMzBhaVgzSzhjUGJ3c0lqOUpv?=
 =?utf-8?B?bmQvanRLc1BqMWtqazUyQVBma0VLamtWYkNRcFZuYUNpR0Nva0xPTzQzVGZs?=
 =?utf-8?B?VTdrUHFuUldOS0pGL1lkcFcrMTI0SUJjcXEzRFVib1RwY1JlSkdUMjc4Z1dY?=
 =?utf-8?B?UFg1V1lweThvTHRxdTNWRVo2c3FaOTZFNW44SkNoY0J4Y1RsMHBqYWRYUEpt?=
 =?utf-8?B?bVhPZ0I5VnR4K0UvMUlMZC9rSXhNMnpvWXArazZ3S2RpWGN0bXV2TDdMSjVN?=
 =?utf-8?B?K25Kck9FMGx5MzBNWHJYSmhIcHJibDdKbXpLSmhUNWJkQnQ4THN6Rzc5UFB6?=
 =?utf-8?B?MU5qWGtYSWRha1NoWnZRQTNnY2FxUXJMQ3lycmQrWEpZTnBoMXZMTWZsVWUr?=
 =?utf-8?B?QTRmVDgrVjR6bDZuUGdpdkdFbkIzYXFBa2h4TGRYY1dWOGVSNFMvMDNDdHNq?=
 =?utf-8?B?OEx4cEpEa0Fuemp3a3IyQ3Vwa2NKd0FBWjBvOU0xa0ZDYWZtQUd1TzJZNm1w?=
 =?utf-8?B?NC81Mmx0Z1B5YlhXVnYwMjFMT25rYk44anhIenc2TDJiSkNTdWQyV0QrYTJG?=
 =?utf-8?B?ZWhDemV5RlM1VFVZZ20vK1MzRnZjeTc4R0xDMzErQnhtMEJRZnpTWlNoYkNq?=
 =?utf-8?B?VzVNdHd0bi95SHZ5WGxZZ25oaTJwN1hLNzVVRW1KVXpBSXdBaTRJcStFTFZo?=
 =?utf-8?B?RlVzLzZ1WVJ2WTlpOVFjeEdtUW9xakY0YVZycTU5MTg4blF0U2NCbCswcXJX?=
 =?utf-8?B?ZEdpa2UvQUhBNlE1ZGlqL0ZKbExJSzMzM0V0TlpuS2E5WHZVMmkxbW5xUXpE?=
 =?utf-8?B?V2RvVGJXcE1kZHRBY3pLT2VXS2UyZ2haaFFnNUp5R0pwNW9EVmIyWUFOaVhJ?=
 =?utf-8?B?bUdlVVBCR0hmSE9FSlZtelhjeHAxd1pTK3FjeG80aW1RZ0N4eGtTemZYRzBG?=
 =?utf-8?B?SmxuOE1DQ00yTkRjME1HN0tvSHNCVFdaZEVmSUtpSkVOa1czUTJ4ZmxCY3hr?=
 =?utf-8?B?bUdudmtBaWxWeTJ5SHMwcUd6TERkbUpJM3UxVEE3OVN3SlREUmpXU0dwS2hB?=
 =?utf-8?B?TVNVOWpwdkVXTDJLQjFncG9GaVZiT1JmUTQ4djVLaFdKd0VyeVlNMUJDSCtL?=
 =?utf-8?B?bGc0U2VHQnljc0hmUlVLU1BjMkdweDdPaTRvVkoyZ2ZDeSsyTkhFSGNBRlZE?=
 =?utf-8?B?RUw0dFhzVDMwNUlNVng2TTRybGtyRFFnRGZqY2RCTUxFdGkvTHRyS1FCQ0Z2?=
 =?utf-8?B?WlJBU25PR3VURENNc2JZd2xYWVBrbTl3QWNqbERNLzhCRlgza2EwdUIva0NW?=
 =?utf-8?B?dnl4K2xYTmhDZXdKWTVsVFYvNXVLeWV0STNITDJYOGJaNGxkcFZvN21vV2lF?=
 =?utf-8?B?VVk4cUxMN1ZUcU5pbm1GdzBGNW9nM2ZCUzB3WGtEb3dBbnI5d0U3ZWpiSDBq?=
 =?utf-8?B?OFNnVGp6SDJRUk5vc0UzZ29ycFYycjJDY3FLeUtqNG4wOXkwOXNYdnJucElm?=
 =?utf-8?Q?Lp6tvYaEAZPec6kf490/8dY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8CEA53493290E94E86283BFCEE6BA57A@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9049fe10-9de3-40b1-7157-08dcd1b5912d
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2024 16:28:13.4147
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aqkCQ0Bl0LKxahYFpUOSxArFIFDfEEV7Rjr0BlDW8Q2zzxpFK/yXEGHM5d/SgBOHn5WbHO7oL69vIgLdRXinkmBvByZ9Fivf5TY6vmiJzAw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CYXPR11MB8712
X-OriginatorOrg: intel.com

T24gVHVlLCAyMDI0LTA5LTEwIGF0IDA4OjU3IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiA+IE9ubHkgaWYgdGhlIFREWCBtb2R1bGUgcmV0dXJucyBCVVNZIHBlci1TUFRFIChh
cyBzdWdnZXN0ZWQgYnkgMTguMS4zLA0KPiA+IHdoaWNoIGRvY3VtZW50cyB0aGF0IHRoZSBURFgg
bW9kdWxlIHJldHVybnMgVERYX09QRVJBTkRfQlVTWSBvbiBhDQo+ID4gQ01QWENIRyBmYWlsdXJl
KS4gSWYgaXQgcmV0dXJucyBCVVNZIHBlci1WTSwgRlJPWkVOX1NQVEUgaXMgbm90IGVub3VnaA0K
PiA+IHRvIHByZXZlbnQgY29udGVudGlvbiBpbiB0aGUgVERYIG1vZHVsZS4NCj4gDQo+IExvb2tp
bmcgYXQgdGhlIFREWCBtb2R1bGUgY29kZSwgdGhpbmdzIGxpa2UgKFVOKUJMT0NLIGFuZCBSRU1P
VkUgdGFrZSBhIHBlci1WTQ0KPiBsb2NrIGluIHdyaXRlIG1vZGUsIGJ1dCBBREQsIEFVRywgYW5k
IFBST01PVEUvREVNT1RFIHRha2UgdGhlIGxvY2sgaW4gcmVhZA0KPiBtb2RlLg0KDQpBVUcgZG9l
cyB0YWtlIG90aGVyIGxvY2tzIGFzIGV4Y2x1c2l2ZToNCmh0dHBzOi8vZ2l0aHViLmNvbS9pbnRl
bC90ZHgtbW9kdWxlL2Jsb2IvdGR4XzEuNS9zcmMvdm1tX2Rpc3BhdGNoZXIvYXBpX2NhbGxzL3Rk
aF9tZW1fcGFnZV9hdWcuYw0KDQpJIGNvdW50IDUgbG9ja3MgaW4gdG90YWwgYXMgd2VsbC4gSSB0
aGluayB0cnlpbmcgdG8gbWlycm9yIHRoZSBsb2NraW5nIGluIEtWTQ0Kd2lsbCBiZSBhbiB1cGhp
bGwgYmF0dGxlLg0KDQo+IA0KPiBTbyBmb3IgdGhlIG9wZXJhdGlvbnMgdGhhdCBLVk0gY2FuIGRv
IGluIHBhcmFsbGVsLCB0aGUgbG9ja2luZyBzaG91bGQNCj4gZWZmZWN0aXZlbHkNCj4gYmUgcGVy
LWVudHJ5LsKgIEJlY2F1c2UgS1ZNIHdpbGwgbmV2ZXIgdGhyb3cgYXdheSBhbiBlbnRpcmUgUy1F
UFQgcm9vdCwgemFwcGluZw0KPiBTUFRFcyB3aWxsIG5lZWQgdG8gYmUgZG9uZSB3aGlsZSBob2xk
aW5nIG1tdV9sb2NrIGZvciB3cml0ZSwgaS5lLiBLVk0NCj4gc2hvdWxkbid0DQo+IGhhdmUgcHJv
YmxlbXMgd2l0aCBob3N0IHRhc2tzIGNvbXBldGluZyBmb3IgdGhlIFREWCBtb2R1bGUncyBWTS13
aWRlIGxvY2suDQo+IA0KPiA+IElmIHdlIHdhbnQgdG8gYmUgYSBiaXQgbW9yZSBvcHRpbWlzdGlj
LCBsZXQncyBkbyBzb21ldGhpbmcgbW9yZQ0KPiA+IHNvcGhpc3RpY2F0ZWQsIGxpa2Ugb25seSB0
YWtlIHRoZSBsb2NrIGFmdGVyIHRoZSBmaXJzdCBidXN5IHJlcGx5LiBCdXQNCj4gPiB0aGUgc3Bp
bmxvY2sgaXMgdGhlIGVhc2llc3Qgd2F5IHRvIGNvbXBsZXRlbHkgcmVtb3ZlIGhvc3QtaW5kdWNl
ZA0KPiA+IFREWF9PUEVSQU5EX0JVU1ksIGFuZCBvbmx5IGhhdmUgdG8gZGVhbCB3aXRoIGd1ZXN0
LWluZHVjZWQgb25lcy4NCj4gDQo+IEkgYW0gbm90IGNvbnZpbmNlZCB0aGF0J3MgbmVjZXNzYXJ5
IG9yIGEgZ29vZCBpZGVhLsKgIEkgd29ycnkgdGhhdCBkb2luZyBzbw0KPiB3b3VsZA0KPiBqdXN0
IGtpY2sgdGhlIGNhbiBkb3duIHRoZSByb2FkLCBhbmQgcG90ZW50aWFsbHkgbWFrZSB0aGUgcHJv
YmxlbXMgaGFyZGVyIHRvDQo+IHNvbHZlLA0KPiBlLmcuIGJlY2F1c2Ugd2UnZCBoYXZlIHRvIHdv
cnJ5IGFib3V0IHJlZ3Jlc3NpbmcgZXhpc3Rpbmcgc2V0dXBzLg0KPiANCj4gPiA+ID4gSXQgaXMg
c3RpbGwga2luZGEgYmFkIHRoYXQgZ3Vlc3RzIGNhbiBmb3JjZSB0aGUgVk1NIHRvIGxvb3AsIGJ1
dCB0aGUgVk1NDQo+ID4gPiA+IGNhbg0KPiA+ID4gPiBhbHdheXMgc2F5IGVub3VnaCBpcyBlbm91
Z2guwqAgSW4gb3RoZXIgd29yZHMsIGxldCdzIGFzc3VtZSB0aGF0IGEgbGltaXQNCj4gPiA+ID4g
b2YNCj4gPiA+ID4gMTYgaXMgcHJvYmFibHkgYXBwcm9wcmlhdGUgYnV0IHdlIGNhbiBhbHNvIGlu
Y3JlYXNlIHRoZSBsaW1pdCBhbmQgY3Jhc2gNCj4gPiA+ID4gdGhlDQo+ID4gPiA+IFZNIGlmIHRo
aW5ncyBiZWNvbWUgcmlkaWN1bG91cy4NCj4gPiA+IA0KPiA+ID4gMiA6LSkNCj4gPiA+IA0KPiA+
ID4gT25lIHRyeSB0aGF0IGd1YXJhbnRlZXMgbm8gb3RoZXIgaG9zdCB0YXNrIGlzIGFjY2Vzc2lu
ZyB0aGUgUy1FUFQgZW50cnksDQo+ID4gPiBhbmQgYQ0KPiA+ID4gc2Vjb25kIHRyeSBhZnRlciBi
bGFzdGluZyBJUEkgdG8ga2ljayB2Q1BVcyB0byBlbnN1cmUgbm8gZ3Vlc3Qtc2lkZSB0YXNrDQo+
ID4gPiBoYXMNCj4gPiA+IGxvY2tlZCB0aGUgUy1FUFQgZW50cnkuDQo+ID4gDQo+ID4gRmFpciBl
bm91Z2guIFRob3VnaCBpbiBwcmluY2lwbGUgaXQgaXMgcG9zc2libGUgdG8gcmFjZSBhbmQgaGF2
ZSB0aGUNCj4gPiB2Q1BVIHJlLXJ1biBhbmQgcmUtaXNzdWUgYSBUREcgY2FsbCBiZWZvcmUgS1ZN
IHJlLWlzc3VlcyB0aGUgVERIIGNhbGwuDQo+IA0KPiBNeSBsaW1pdCBvZiAnMicgaXMgcHJlZGlj
YXRlZCBvbiB0aGUgbG9jayBiZWluZyBhICJob3N0IHByaW9yaXR5IiBsb2NrLCBpLmUuDQo+IHRo
YXQNCj4ga2lja2luZyB2Q1BVcyB3b3VsZCBlbnN1cmUgdGhlIGxvY2sgaGFzIGJlZW4gZHJvcHBl
ZCBhbmQgY2FuJ3QgYmUgcmUtYWNxdWlyZWQNCj4gYnkNCj4gdGhlIGd1ZXN0Lg0KDQpTbyBraWNr
aW5nIHdvdWxkIGJlIHRvIHRyeSB0byBicmVhayBsb29zZSBhbnkgZGVhZGxvY2sgd2UgZW5jb3Vu
dGVyZWQ/IEl0IHNvdW5kcw0KbGlrZSB0aGUga2luZCBvZiBrbHVkZ2UgdGhhdCBjb3VsZCBiZSBo
YXJkIHRvIHJlbW92ZS4NCg0KPiANCj4gPiBTbyBJIHdvdWxkIG1ha2UgaXQgNSBvciBzbyBqdXN0
IHRvIGJlIHNhZmUuDQo+ID4gDQo+ID4gPiBNeSBjb25jZXJuIHdpdGggYW4gYXJiaXRyYXJ5IHJl
dHJ5IGxvb3AgaXMgdGhhdCB3ZSdsbCBlc3NlbnRpYWxseQ0KPiA+ID4gcHJvcGFnYXRlIHRoZQ0K
PiA+ID4gVERYIG1vZHVsZSBpc3N1ZXMgdG8gdGhlIGJyb2FkZXIga2VybmVsLsKgIEVhY2ggb2Yg
dGhvc2UgU0VBTUNBTExzIGlzDQo+ID4gPiBzbG9vb3csIHNvDQo+ID4gPiByZXRyeWluZyBldmVu
IH4yMCB0aW1lcyBjb3VsZCBleGNlZWQgdGhlIHN5c3RlbSdzIHRvbGVyYW5jZXMgZm9yDQo+ID4g
PiBzY2hlZHVsaW5nLCBSQ1UsDQo+ID4gPiBldGMuLi4NCj4gPiANCj4gPiBIb3cgc2xvdyBhcmUg
dGhlIGZhaWxlZCBvbmVzPyBUaGUgbnVtYmVyIG9mIHJldHJpZXMgaXMgZXNzZW50aWFsbHkgdGhl
DQo+ID4gY29zdCBvZiBzdWNjZXNzZnVsIHNlYW1jYWxsIC8gY29zdCBvZiBidXN5IHNlYW1jYWxs
Lg0KPiANCj4gSSBoYXZlbid0IG1lYXN1cmVkLCBidXQgd291bGQgYmUgc3VycHJpc2VkIGlmIGl0
J3MgbGVzcyB0aGFuIDIwMDAgY3ljbGVzLg0KPiANCj4gPiBJZiBIT1NUX1BSSU9SSVRZIHdvcmtz
LCBldmVuIGEgbm90LXNtYWxsLWJ1dC1ub3QtaHVnZSBudW1iZXIgb2YNCj4gPiByZXRyaWVzIHdv
dWxkIGJlIGJldHRlciB0aGFuIHRoZSBJUElzLiBJUElzIGFyZSBub3QgY2hlYXAgZWl0aGVyLg0K
PiANCj4gQWdyZWVkLCBidXQgd2UgYWxzbyBuZWVkIHRvIGFjY291bnQgZm9yIHRoZSBvcGVyYXRp
b25zIHRoYXQgYXJlIGNvbmZsaWN0aW5nLg0KPiBFLmcuIGlmIEtWTSBpcyB0cnlpbmcgdG8gemFw
IGEgUy1FUFQgdGhhdCB0aGUgZ3Vlc3QgaXMgYWNjZXNzaW5nLCB0aGVuIGJ1c3kNCj4gd2FpdGlu
Zw0KPiBmb3IgdGhlIHRvLWJlLXphcHBlZCBTLUVQVCBlbnRyeSB0byBiZSBhdmFpbGFibGUgZG9l
c24ndCBtYWtlIG11Y2ggc2Vuc2UuDQo+IA0KPiA+ID4gPiBGb3IgemVybyBzdGVwIGRldGVjdGlv
biwgbXkgcmVhZGluZyBpcyB0aGF0IGl0J3MgVERILlZQLkVOVEVSIHRoYXQNCj4gPiA+ID4gZmFp
bHM7DQo+ID4gPiA+IG5vdCBhbnkgb2YgdGhlIE1FTSBzZWFtY2FsbHMuwqAgRm9yIHRoYXQgb25l
IHRvIGJlIHJlc29sdmVkLCBpdCBzaG91bGQgYmUNCj4gPiA+ID4gZW5vdWdoIHRvIGRvIHRha2Ug
YW5kIHJlbGVhc2UgdGhlIG1tdV9sb2NrIGJhY2sgdG8gYmFjaywgd2hpY2ggZW5zdXJlcw0KPiA+
ID4gPiB0aGF0DQo+ID4gPiA+IGFsbCBwZW5kaW5nIGNyaXRpY2FsIHNlY3Rpb25zIGhhdmUgY29t
cGxldGVkICh0aGF0IGlzLA0KPiA+ID4gPiAid3JpdGVfbG9jaygma3ZtLT5tbXVfbG9jayk7IHdy
aXRlX3VubG9jaygma3ZtLT5tbXVfbG9jayk7IikuwqAgQW5kIHRoZW4NCj4gPiA+ID4gbG9vcC7C
oCBBZGRpbmcgYSB2Q1BVIHN0YXQgZm9yIHRoYXQgb25lIGlzIGEgZ29vZCBpZGVhLCB0b28uDQo+
ID4gPiANCj4gPiA+IEFzIGFib3ZlIGFuZCBpbiBteSBkaXNjdXNzaW9uIHdpdGggUmljaywgSSB3
b3VsZCBwcmVmZXIgdG8ga2ljayB2Q1BVcyB0bw0KPiA+ID4gZm9yY2UNCj4gPiA+IGZvcndhcmQg
cHJvZ3Jlc3MsIGVzcGVjaWFsbHkgZm9yIHRoZSB6ZXJvLXN0ZXAgY2FzZS7CoCBJZiBLVk0gZ2V0
cyB0byB0aGUNCj4gPiA+IHBvaW50DQo+ID4gPiB3aGVyZSBpdCBoYXMgcmV0cmllZCBUREguVlAu
RU5URVIgb24gdGhlIHNhbWUgZmF1bHQgc28gbWFueSB0aW1lcyB0aGF0DQo+ID4gPiB6ZXJvLXN0
ZXANCj4gPiA+IGtpY2tzIGluLCB0aGVuIGl0J3MgdGltZSB0byBraWNrIGFuZCB3YWl0LCBub3Qg
a2VlcCByZXRyeWluZyBibGluZGx5Lg0KPiA+IA0KPiA+IFdhaXQsIHplcm8tc3RlcCBkZXRlY3Rp
b24gc2hvdWxkIF9ub3RfIGFmZmVjdCBUREguTUVNIGxhdGVuY3kuIE9ubHkNCj4gPiBUREguVlAu
RU5URVIgaXMgZGVsYXllZC4NCj4gDQo+IEJsb2NrZWQsIG5vdCBkZWxheWVkLsKgIFllcywgaXQn
cyBUREguVlAuRU5URVIgdGhhdCAiZmFpbHMiLCBidXQgdG8gZ2V0IHBhc3QNCj4gVERILlZQLkVO
VEVSLCBLVk0gbmVlZHMgdG8gcmVzb2x2ZSB0aGUgdW5kZXJseWluZyBmYXVsdCwgaS5lLiBuZWVk
cyB0bw0KPiBndWFyYW50ZWUNCj4gZm9yd2FyZCBwcm9ncmVzcyBmb3IgVERILk1FTSAob3Igd2hh
dGV2ZXIgdGhlIG9wZXJhdGlvbnMgYXJlIGNhbGxlZCkuDQo+IA0KPiBUaG91Z2ggSSB3b25kZXIs
IGFyZSB0aGVyZSBhbnkgb3BlcmF0aW9ucyBndWVzdC9ob3N0IG9wZXJhdGlvbnMgdGhhdCBjYW4N
Cj4gY29uZmxpY3QNCj4gaWYgdGhlIHZDUFUgaXMgZmF1bHRpbmc/wqAgTWF5YmUgdGhpcyBwYXJ0
aWN1bGFyIHNjZW5hcmlvIGlzIGEgY29tcGxldGUgbm9uLQ0KPiBpc3N1ZS4NCj4gDQo+ID4gSWYg
aXQgaXMgZGVsYXllZCB0byB0aGUgcG9pbnQgb2YgZmFpbGluZywgd2UgY2FuIGRvDQo+ID4gd3Jp
dGVfbG9jay93cml0ZV91bmxvY2soKQ0KPiA+IGluIHRoZSB2Q1BVIGVudHJ5IHBhdGguDQo+IA0K
PiBJIHdhcyB0aGlua2luZyB0aGF0IEtWTSBjb3VsZCBzZXQgYSBmbGFnIChhbm90aGVyIHN5bnRo
ZXRpYyBlcnJvciBjb2RlIGJpdD8pDQo+IHRvDQo+IHRlbGwgdGhlIHBhZ2UgZmF1bHQgaGFuZGxl
ciB0aGF0IGl0IG5lZWRzIHRvIGtpY2sgdkNQVXMuwqAgQnV0IGFzIGFib3ZlLCBpdA0KPiBtaWdo
dA0KPiBiZSB1bm5lY2Vzc2FyeS4NCj4gDQo+ID4gTXkgaXNzdWUgaXMgdGhhdCwgZXZlbiBpZiB3
ZSBjb3VsZCBtYWtlIGl0IGEgYml0IGJldHRlciBieSBsb29raW5nIGF0DQo+ID4gdGhlIFREWCBt
b2R1bGUgc291cmNlIGNvZGUsIHdlIGRvbid0IGhhdmUgZW5vdWdoIGluZm9ybWF0aW9uIHRvIG1h
a2UgYQ0KPiA+IGdvb2QgY2hvaWNlLsKgIEZvciBub3cgd2Ugc2hvdWxkIHN0YXJ0IHdpdGggc29t
ZXRoaW5nIF9lYXN5XywgZXZlbiBpZg0KPiA+IGl0IG1heSBub3QgYmUgdGhlIGdyZWF0ZXN0Lg0K
PiANCj4gSSBhbSBub3Qgb3Bwb3NlZCB0byBhbiBlYXN5L3NpbXBsZSBzb2x1dGlvbiwgYnV0IEkg
YW0gdmVyeSBtdWNoIG9wcG9zZWQgdG8NCj4gaW1wbGVtZW50aW5nIGEgcmV0cnkgbG9vcCB3aXRo
b3V0IHVuZGVyc3RhbmRpbmcgX2V4YWN0bHlfIHdoZW4gYW5kIHdoeSBpdCdzDQo+IG5lZWRlZC4N
Cg0KSSdkIGxpa2UgdG8gZXhwbG9yZSBsZXR0aW5nIEtWTSBkbyB0aGUgcmV0cmllcyAoaS5lLiBF
UFQgZmF1bHQgbG9vcCkgYSBiaXQgbW9yZS4NCldlIGNhbiB2ZXJpZnkgdGhhdCB3ZSBjYW4gc3Vy
dml2ZSB6ZXJvLXN0ZXAgaW4gdGhpcyBjYXNlLiBBZnRlciBhbGwsIHplcm8tc3RlcA0KZG9lc24n
dCBraWxsIHRoZSBURCwganVzdCBnZW5lcmF0ZXMgYW4gRVBUIHZpb2xhdGlvbiBleGl0LiBTbyB3
ZSB3b3VsZCBqdXN0IG5lZWQNCnRvIHZlcmlmeSB0aGF0IHRoZSBFUFQgdmlvbGF0aW9uIGdldHRp
bmcgZ2VuZXJhdGVkIHdvdWxkIHJlc3VsdCBpbiBLVk0NCmV2ZW50dWFsbHkgZml4aW5nIHdoYXRl
dmVyIHplcm8tc3RlcCBpcyByZXF1aXJpbmcuDQoNClRoZW4gd2Ugd291bGQgaGF2ZSB0byBoYW5k
bGUgQlVTWSBpbiBlYWNoIFNFQU1DQUxMIGNhbGwgY2hhaW4sIHdoaWNoIGN1cnJlbnRseQ0Kd2Ug
ZG9uJ3QuIExpa2UgdGhlIHphcHBpbmcgY2FzZS4gSWYgd2UgZW5kZWQgdXAgbmVlZGluZyBhIHJl
dHJ5IGxvb3AgZm9yIGxpbWl0ZWQNCmNhc2VzIGxpa2UgdGhhdCwgYXQgbGVhc3QgaXQgd291bGQg
YmUgbW9yZSBsaW1pdGVkLg0K

