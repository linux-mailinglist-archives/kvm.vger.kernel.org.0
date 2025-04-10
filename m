Return-Path: <kvm+bounces-43068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9E4A83B5E
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 09:37:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E6603AE6A7
	for <lists+kvm@lfdr.de>; Thu, 10 Apr 2025 07:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61CB120459E;
	Thu, 10 Apr 2025 07:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="nRshivlX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 922BF1AA786;
	Thu, 10 Apr 2025 07:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744270337; cv=fail; b=o66lKRD+HCYbLWkSNKPnxK3RJpolvnu97EsmpMmkQEJFj7i3ukGa/pAtt4rXIwIkxoqPMxjX3ZWOexJDEesojjPD95mS1ir0NbHgkuAu22Qs5pIhrdQvwtbs6iGcflzScp82TvP8iicDpEgxEJm01ZoDm7yKSjNAdQkhVI17gAU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744270337; c=relaxed/simple;
	bh=C5SvwvXfLg2wRJDfcnQ0SoF4c+h2JuMlA3ogvk/tz+w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nIpo1+wyyNuUEYyDBvU4cn3ruZVvZhqg6UDrLrAqkgm4KlENdIkltNYaK0NeOGsndTAdojW3vX/ysEF2zdRkeZ8liuYCKx6FtW/lIYRGSBrh2WvQyY24kRWVx5qzG5QmsXxm/RXbrwGWNmptXwySj5FUFLhMQ8IbwiRZ3X+PqlQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=nRshivlX; arc=fail smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1744270335; x=1775806335;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=C5SvwvXfLg2wRJDfcnQ0SoF4c+h2JuMlA3ogvk/tz+w=;
  b=nRshivlXGgMptNU8W51bUGwRNrB8bBVX4xVPorSaGApBrPZuWYKF2ZDm
   6r4QqvHGgetm6Z62pvnGcchW18iV/qrmV77CjD4cjOI4EH65kyX/kH2lH
   6TOPQy7nsXyJ4av9Kxlbj2FeUUq4B22Q66M+VuA2AMbyN0POq37F6JD8F
   yR0CA/7fxRs0POkvFAdod1PYcrBhL8OfdUPI+tII+FssyW5VVLVT1TaYm
   Whz/K6fiQ42YaWPh5UjtFLCiIqDV1aUjjdWSQS8jhRcjga7hhtXvd+US9
   bSz6ldUyfkVq+7wLg/ginPISqoHA495NAr6PmA6dXFKDyhlLRERfE7aQ3
   Q==;
X-CSE-ConnectionGUID: 0IrYcdhuRHGJtoE3fIyxIA==
X-CSE-MsgGUID: CZyjfAl5So2Okb6QmLPOEA==
X-IronPort-AV: E=McAfee;i="6700,10204,11399"; a="56441025"
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="56441025"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:32:14 -0700
X-CSE-ConnectionGUID: YICwDo8iTEeyEJVi1xWyYg==
X-CSE-MsgGUID: EkZelf6VRQWpPgMhRA/1yA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,202,1739865600"; 
   d="scan'208";a="128563721"
Received: from orsmsx902.amr.corp.intel.com ([10.22.229.24])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2025 00:32:15 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14; Thu, 10 Apr 2025 00:32:14 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.14 via Frontend Transport; Thu, 10 Apr 2025 00:32:14 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Thu, 10 Apr 2025 00:32:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iaGHx7wX9ZA5oDuuX3tqWXweK/6Fnm5lVm8HbxXnbwqhdf9VO9EQEmphDMer4sSme+Sy+WuuAGgNOmCfN3ArbtMRbKPgmNqyeXIDlL28Vg0joDG+nFovJ6ouOJ1H2lgSJqiXesafx2T03n/o3/3e8g8SHyMSakKbWXbE3J9jBP01PyQBfzap8PL9tyzzrF8eW5pZBuhJJLO/xQr0O+Zq+IRutY7Jn7Lt5XqvKFmrTgt7IYtwW30Sct3lblUnhtmq654bX9n+zW4jQRwefjJYoqupmL7ay0eNxb35Cz3tngyYeT1QOPilj9JCBGG+YsUFxZNJtoyixuHfIenDm7iwdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5SvwvXfLg2wRJDfcnQ0SoF4c+h2JuMlA3ogvk/tz+w=;
 b=Vi27UbEcQt0fWtGyFwIeTB4FDfG+bn/vtBak+as3rd6KfoKu1Rs69RqDVF8Vc96XrC0ml0q2DmlygwfhgmqWalMrxWVz89Rwq2ugQdgv3HwjFUifV3D81ZT6fsq3bgpsMaNVHEjhVhW+OUGPB4y1f0GHdwui6d8crt86Nw4aiyEog9Yr+AddHPC3HW4D1v4OQB2jB8vGZPYrZnD9PZQV7mun4mQEfB8vHga5YdeBRTaZR5rUVZNuDvgZhTovH6i4wXmsBdtzHV6sVOJLGbAlcOb360vXeBg5l3GfUls5lTo5qvMVxvRwNImyc3f8G3cMlsX2UxqSALiFzWKJj0YDqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SJ2PR11MB8585.namprd11.prod.outlook.com (2603:10b6:a03:56b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.33; Thu, 10 Apr
 2025 07:32:11 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::b576:d3bd:c8e0:4bc1%5]) with mapi id 15.20.8606.033; Thu, 10 Apr 2025
 07:32:11 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Sean Christopherson <seanjc@google.com>, "Michael S. Tsirkin"
	<mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini
	<pbonzini@redhat.com>, Alex Williamson <alex.williamson@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"virtualization@lists.linux.dev" <virtualization@lists.linux.dev>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Oliver Upton
	<oliver.upton@linux.dev>, David Matlack <dmatlack@google.com>, Like Xu
	<like.xu.linux@gmail.com>, Yong He <alexyonghe@tencent.com>
Subject: RE: [PATCH 4/7] irqbypass: Explicitly track producer and consumer
 bindings
Thread-Topic: [PATCH 4/7] irqbypass: Explicitly track producer and consumer
 bindings
Thread-Index: AQHbpabkqaJ2EVGXOk++MtlgpyIMgLOcifew
Date: Thu, 10 Apr 2025 07:32:11 +0000
Message-ID: <BN9PR11MB5276D82AF8ED0923638D7D888CB72@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20250404211449.1443336-1-seanjc@google.com>
 <20250404211449.1443336-5-seanjc@google.com>
In-Reply-To: <20250404211449.1443336-5-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|SJ2PR11MB8585:EE_
x-ms-office365-filtering-correlation-id: 9765c74a-1c43-4686-7ea8-08dd7801cedc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?bnpDaUdrTDdubkN2UzNLOFVRdTd6UkZsLzVBZlFwRWRYUnVyRmQ5K0R3RDRP?=
 =?utf-8?B?dXVKVnluOFJFSFdoOFc2TE5NWnh5VFNIWW9BSFd3MU1iUHlpQ0pWaGxWVUx5?=
 =?utf-8?B?bkRBcEUvemp5eWlhdXBJM0N5QS9hRCtuRmRTL0hmaW9lTjJxeVhPOHZlejZx?=
 =?utf-8?B?OUZIY2VnUm9mQ3ZlbWR4bFc2YlJwMnVPSHhRN05RMEdMOEtCTTY2NXlDWllh?=
 =?utf-8?B?dEZTRTNJdWFaeURzejNFWnZyTXY0RlFvMXBEMjlvcHBkd3I5TTUwZGVoZlFq?=
 =?utf-8?B?MkFod2xkSzU4U0szVXE1YVJBNXZveXVDUHdPNFYrd0VIWjZRM3p1bmtjR0hl?=
 =?utf-8?B?R0JiZzdCTlNpNjJJRlJhbWlmdjRQYUtnUjBRN1RoMFhrTXloWnRnSHFTV3li?=
 =?utf-8?B?SENoQjU1NDkvQ1RRY1hGUE4zOU9SNzlQeC93am1WVHcwYzM2K2t0SjByVjNp?=
 =?utf-8?B?ZmVCL2d2SER4U2U5aWErSTg1TjJkVUlHbzJlandGRkIvT0VFSDJUZFJEU2JB?=
 =?utf-8?B?VE9mSGM2ZllaQkFjbkRoVktzQTV6dDRaSE1vWW9PdHJBQkZxMDZpMGp4aHc2?=
 =?utf-8?B?aVF2UFNBODlabjdiVXl2Q0Jtc2FLb08va216L3g0SWFPbDBRanN5OG1UdHBR?=
 =?utf-8?B?dFU1WFB3RjZiOE1KSFRaTmVJbGl1TGhLWmNFVEhvazl6RTIzcm9ZSEhIcTEy?=
 =?utf-8?B?K1BZVDU1RnZHZUVrSW90WHUwM3Urakp5d0hjRFh4OWJ0M1BnZW56UWpCaVBv?=
 =?utf-8?B?ODBqZjBaTGxVZVlhNjZrSURNWG1UQXJQaUV2Yy8vWGkvMUhJNTV1VHhPMDRR?=
 =?utf-8?B?T09nZi8vYVkycFE3S1VtbWlKVHczY1llbDUxeXQvenMxYjNibTFuMFBnOWpo?=
 =?utf-8?B?VktiQkNDbzM4eVhlK05CTTNYL08rV2krd252K2JzK09zdEJwUWgrS2tVZTRR?=
 =?utf-8?B?dmZla0NHL0Z5a2EzRk5ralpzaGJiZ0MyYzRuaDNPeEovYmVxMXFqZHd1ak9q?=
 =?utf-8?B?NHRRSWprUnNCZVZPcGZJeTE4dGNhL29lTzVGUlJ0eGdGalZuYlVvUDdJOEVz?=
 =?utf-8?B?U1JxWkk0akJTTkdJbXhpVW54NjdTaDBIL3NEdlU4L0FlOHY4V0UreUt3UW9P?=
 =?utf-8?B?L2I1R3ZBbjJ5Um14S0dWYkNLaEhvU0EraTF1VXo4am9Ca0p4VXhoUm1NRnAy?=
 =?utf-8?B?a3VoTGxXOWsyVWFSUGc2d3NxcHlQQVc3UlBHa280RkNkY3h0RmJqQytEUklR?=
 =?utf-8?B?MDdZM0d1bHJGMlZtbE5GNWdxQmthWGtwd1RXajI3dVpxTllwMUZRT0d5bDlm?=
 =?utf-8?B?K3pIdkQ4MThzdS9PTkNvZlhtUkFHMVp6dzlsa2JQVXp3UE80emxzWk1yNVla?=
 =?utf-8?B?OEcrTXlEZWt4dGFXeWRLNVFSQjBjZzU3YXJUSGU5RzlHU2pkZ0VLVklNV21Y?=
 =?utf-8?B?eDdSb1JhdGFoaTFsV2ExMHU0N0VheVQxeG9sNlFsbm00ZWJlQVQ2YzB3Q1VD?=
 =?utf-8?B?UEYxUFZ0RmtYSGdBVGs0NSszZk9UZndQMk9mTW5iVzZmYnJWUXdubmlCZmtJ?=
 =?utf-8?B?N1VSWjU4SjVoSVQzUDY4YmpFdXlwcmt2ekFXTm5qaEFzRHYvUGV0NVJuejBE?=
 =?utf-8?B?aGlxTjBxaWxveTN0cm9yR2hjZnAzd0E3eE1SMVlHMENBak5jendaU1daOTU3?=
 =?utf-8?B?TlNLQkt6NjEwcDg2RUhHUUxQZUdoaVJwMWkzQUVCSVI5a1dKSUVSb1hybjRs?=
 =?utf-8?B?ZFVTTFZLSXNWSXRIZmJMcW9mcU0vOTBwZXZYK0ZFSHhLSnlRKzlpejlodWJi?=
 =?utf-8?B?VzN0U1FTdXM1bjg2QURRUWJ4Sk5WZG5pYjNmTnRTWm1tQk80M0dhUDczclg1?=
 =?utf-8?B?THc4aTdMbnlRd2VWYUtMaW02RVZDSHNjdHUveXJwRkxCQWdTK21sbWxQUWlX?=
 =?utf-8?Q?e7CwyFa7dh0xsVSifswfqkGacboUMmR4?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGx1K2l6V3EyM2E4Zm1SYVdsRDRKbnRoU3JiRlVZN09yeFVFWHo0TlJXVm55?=
 =?utf-8?B?N2FYbWc5RVhEMXNkWG0xYWJLTzVtZmlDSnNlSGtVaW1YQUhaSythNkdNZnlM?=
 =?utf-8?B?Ny8vL1o4VCsxck9NNFZxQlg0QTZtRFdraFNyaFJ4K2VOUjF4M1djUGg2cGxi?=
 =?utf-8?B?aUEzbnNyb0F0a01GRDVML3duZEFnWEtEOFZRd05KZjFKUUZsbXJXeHhoazUx?=
 =?utf-8?B?MnlDR2pWZTNqZldkRXNBKzhReC9GU3ZHUkw0TWRKeUs5WUlrbmRTcWV3WEtH?=
 =?utf-8?B?ZG1BUkRWZ1M1Y1B6akw2d0xMWXUxZHI2dmcyNnZiUlhXMWF3alZSUVlWMGtl?=
 =?utf-8?B?ZkZmZWNyZ1RkWTh6K2tnZ1FTYUw0bHpkTS9sTWFXb0FOcUlReURKM21jeE0x?=
 =?utf-8?B?RGhZMG9mK3dwUXl1eVM3MzNxUUh3VWozY05PeDFLdlFNUkhQcWdHbHVnKzho?=
 =?utf-8?B?TjNZNDBQcEtBcnhub2lBZnl4OUdHRUdKMWcwb1I1ZEFyUi9ZZkRudkNJQk1p?=
 =?utf-8?B?SWtDanBVeDJKNUNFeE5rYUdoenNmdDhEK3pBNkpZdkQzVFpyKzNXWGdCeDY1?=
 =?utf-8?B?T0c1aU1CbXdQZnpmNEltY2IxbHNxbjlBS1hGbWhwTjZhZENYMWMxSk52ZlRU?=
 =?utf-8?B?YXhwV0R3RG5WSFJiWnR4S1dDbm5oUVMrcGRydEh1N1FQRGNjdTdWM0RlaTNG?=
 =?utf-8?B?SUlJdjRoT1QwQSs2dUlmSkxCVmNvVEYxU0VvZ2VZRzIvbnNQWmw1Y1NzT0Ev?=
 =?utf-8?B?UnpvZHJ6S2FjZnRqMlZpS3pYUWlVNmxVTTNrYStiMU4yaE9aRzhLYWZnelBl?=
 =?utf-8?B?R0ZDU2Y2ZXhHZHlYR0IralVqSkgvdS83bUd0WjN0clVSSWE1OHRvSGNqSjJZ?=
 =?utf-8?B?azhpcGdGTW1vY0NNSm1MR0owbUI1eVIwdWZwRk16UmJTa2J2cERWTldSbExZ?=
 =?utf-8?B?TzRSVWVBdWYydjRtenR3MFRLWlhYbFFGaFJGL0R6MEIrcnRaMmp0SVFOcCsw?=
 =?utf-8?B?eU5zZTNkNG00WTYrZGlZckQrQzZIbldCTHFsc2ZSdkpYTmZXTkRVVUxvZE1D?=
 =?utf-8?B?ODluc3owdXZyaTB6MzBMb0FRODRrNU45Z0dpU2lqUXBoZnVDaHFzdC9UblFF?=
 =?utf-8?B?TDJhNkdXWG9jVldQTHE4OVA0d2tIZFloclYrbHExcDY1dWhLaW1uMUZYenQz?=
 =?utf-8?B?RkxwZFFYZFBKZlkyS0dUbThDT0g3UkJCeTAvMVFJUDhzMm1RMzhlNGtnZDhu?=
 =?utf-8?B?ME83SkVxMnc1R09Xb28zdnUwRHhIUzhtQ0NNODBJV205SlJ0bGk0aGNIYVlZ?=
 =?utf-8?B?cHFFRFlwRHBoRExmMDdQcVFJY2FQVkhkbVpyS05XSXkwa1l5d2Rvb2pxVHpk?=
 =?utf-8?B?U2lYZGsxN1kwdkg4ZnQwZHBBYWcyVFBpY2czdng5TTJ5bk50VmVZSkUzKysv?=
 =?utf-8?B?Mjc4NzJKa3MvaUdmRVlUNFR1RWUxQ1ZpN2F4UUdrbmx1K1FyZUFRZlpZQ05s?=
 =?utf-8?B?ZkNaOHBrQmZ2enFSWlZ6OTA0U2tabUF2KytQS081eFRpOW40S3hJY3hPbkNh?=
 =?utf-8?B?UkFZT2FrWjl5RTJUTll0ZWNLMWQ2dG1oSFJJK0RZaG5IUHlrVTVTK3dkRlFG?=
 =?utf-8?B?clhSRnFjbG0zdy9ucFBxR2FseTJOTExoZnl6UFRVcytpcjhxZGovQWdpaC8y?=
 =?utf-8?B?Zi9IWGVqaVNvdEtycTZDUEJrTXZCMWRQODUrN3dnVkdrcGNBdWNqY0RJN0p5?=
 =?utf-8?B?THhmRkdxa1l1cFN3bzRxa0xRL2RnNUxsQ1VudVpjZG00MVppZEdpdTlmanFt?=
 =?utf-8?B?U3dKcnlXMS9KbzN1bU5YNGQ4RS8zM3hCQmlYS3h4L1NBRUJhMHJTVE5ONGdm?=
 =?utf-8?B?OWg1MEJiNmJkYzI3QjdEKzVYaGZBR21sek5DZVE0eWkzeVo1bk9oVXY1VVYy?=
 =?utf-8?B?LzVYOER5UWYwMUI5U2dRSzdEYTNwdEZpcDhzS0R1Q2c1aTZjcUsxUFEvYjlG?=
 =?utf-8?B?L2dKL3p4YjFaNW5HZml2VS9uTklzV3JLSU5ib0E4YmY4aE9Sd0t0VmtyVDMz?=
 =?utf-8?B?bklKb3ByKzRlbFpDakRYWXM2cUNFWWkrWTMzZWlsd0pNWXJmVE16bzBjWjJ3?=
 =?utf-8?Q?6Awpwfqsg9kEB6ymZCrfNJUMe?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9765c74a-1c43-4686-7ea8-08dd7801cedc
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Apr 2025 07:32:11.7282
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JTRJI/nYIufUFeHIZQYe4z9NkyGke7fFVaYni8Ngs6btFC/zJkHyilGqfPHKeyUbzcRbDdiDeZycHY6/3W/4Cw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR11MB8585
X-OriginatorOrg: intel.com

PiBGcm9tOiBTZWFuIENocmlzdG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gU2VudDog
U2F0dXJkYXksIEFwcmlsIDUsIDIwMjUgNToxNSBBTQ0KPiANCj4gRXhwbGljaXRseSB0cmFjayBJ
UlEgYnlwYXNzIHByb2R1Y2VyOmNvbnN1bWVyIGJpbmRpbmdzLiAgVGhpcyB3aWxsIGFsbG93DQo+
IG1ha2luZyByZW1vdmFsIGFuIE8oMSkgb3BlcmF0aW9uOyBzZWFyY2hpbmcgdGhyb3VnaCB0aGUg
bGlzdCB0byBmaW5kDQo+IGluZm9ybWF0aW9uIHRoYXQgaXMgdHJpdmlhbGx5IHRyYWNrZWQgKGFu
ZCB1c2VmdWwgZm9yIGRlYnVnKSBpcyB3YXN0ZWZ1bC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNl
YW4gQ2hyaXN0b3BoZXJzb24gPHNlYW5qY0Bnb29nbGUuY29tPg0KDQpSZXZpZXdlZC1ieTogS2V2
aW4gVGlhbiA8a2V2aW4udGlhbkBpbnRlbC5jb20+DQo=

