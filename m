Return-Path: <kvm+bounces-47967-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B4282AC7D4C
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 13:41:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C4258A41895
	for <lists+kvm@lfdr.de>; Thu, 29 May 2025 11:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4824F28EA4F;
	Thu, 29 May 2025 11:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GiR1tjBT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BDD1632C8;
	Thu, 29 May 2025 11:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.13
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748518875; cv=fail; b=NsAzYjSe0+CV0JYuz4KQipsBjxbhkK/QidEEGdX6lIxMJS3Jp1CaVeJEo4t1sMDHW1IjiPpLCC79hxpzz/E10ZGRjWSInyO18hi2S64FFFTevSoVn14gWzbGpHQsH7+xXziwGXTuRpPGX3FZJfMITr3ENu2W8MttnvxnjObDsfg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748518875; c=relaxed/simple;
	bh=Lexq8tInr8j2063kpC3PjioX+H/6rP4T1YDoQgbqtbY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=llRadY2ISw5SeYirWRSOAdD/FYVeWTFHeN3X/WinrQ892Xi1pQZWOyYglAUQiNmzEMh6BuBH1+PjlsWG+vJfdc0zpShI3c/9Yf+DNiYJy7mPQOwRTkNsbLp1FBSiWEl7ARTsUHvj992CKDfq6JsXFWlQlsWlYdXUscUcHx45UIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GiR1tjBT; arc=fail smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1748518874; x=1780054874;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Lexq8tInr8j2063kpC3PjioX+H/6rP4T1YDoQgbqtbY=;
  b=GiR1tjBTK0prii2a/+c7O+cihlfDjEUvdy5pTjIMHcpT8KseBYLk/Fr6
   AkbjpqhpQzg2GthqTeCB9Kv7JQRoQYdnLCkuQeFlSQDRewVYU2MclMYME
   +6MyRLordmi40ib/DQ8SlFjZG77kurqKVz638WD04BlVmKz+/Jh+nN4l9
   x/01OfOMsRYs5LVuoVDrItEmcyhHvv+T/jwO2xdF7gb6+aahgp4PN+T5L
   RJ3MNB2gmO8RMR4hITqwt5jdgDtkDt7HIBjwoWVNc6lXr55q9YGGs4v8o
   ic0Umrd04zuJ78/q1DQhO+jQxWm+QaPCZPXwrijZYwsEbkicsKFq0cCYA
   A==;
X-CSE-ConnectionGUID: HP3pJYDsSu+HeTCIpK7VbA==
X-CSE-MsgGUID: 6xpHdh0ZRTqYqWyVnedw8Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11447"; a="61629027"
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="61629027"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:41:13 -0700
X-CSE-ConnectionGUID: j3pmXfOhSOO+7Cs/m2BmUw==
X-CSE-MsgGUID: aZDNkf0cT3ittH0HimrsEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,192,1744095600"; 
   d="scan'208";a="147431725"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa003.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2025 04:41:13 -0700
Received: from ORSMSX901.amr.corp.intel.com (10.22.229.23) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 29 May 2025 04:41:12 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 29 May 2025 04:41:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (40.107.223.78)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.55; Thu, 29 May 2025 04:41:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=IuwsYQMsL+xUI6gsakoaUiR0zFkL8et6cSY+vNXG4iz/OgaCDV10+i/kXkIo/nC3UVuF0ghCJFlk5IzTDRgRT+WMbalkGghWqK/u3R1vTiMO+8b/peCX3QPLidA2DQwEnAXw5PPYRmberaKLtMi4TI7FEC67mSRDp00cXjphmcKnzjFYLCiadW2i8l4RBy2/cxr0o5167wN8bCKOEheP5+WmekrbbvVcqpRBgHRJqYlUuGohUqfbR6oQX2o4DOaMKtVp91Bl6L8IauyaXK2k9jLReAwH/KCTrKlVZTQchbzNf9aKBNeba1zg9RfiqrNTMrdIIe6tJKzTHPuKRcUuVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lexq8tInr8j2063kpC3PjioX+H/6rP4T1YDoQgbqtbY=;
 b=b7jR+g8OJxIUPjaHypisiBzFy+hM5UhnEJ+emMZoivWsUrESoZ6mJgB7XLayhcatQxiw7a61+fTAwPcRGweVt7WdTBqB7hEBrhnm4QQOpp6dPYpRaxsRL7Am1nOSza5eA65Yj5Kw71HYQGQk88ecaQ2RKDv9d1wkpCV4Lb2S46UVpcSTDOkyT0XQ5Ru41egr+WiFMQSJrRskdG7qyjlxGjf+7fanWyh0/s6ZRBPtUszrEmOiPDll9F8PKBJ8BFeXIunTBukYFU78eeX2iXPFAp33xFgjY3G3gL7Z4Nu9+Cor3k6ottwOCZGB8eLWjMJezhhrdrjFqyshi91vNtzDmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by IA1PR11MB6538.namprd11.prod.outlook.com (2603:10b6:208:3a2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8769.26; Thu, 29 May
 2025 11:41:10 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%5]) with mapi id 15.20.8769.029; Thu, 29 May 2025
 11:41:09 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "vkuznets@redhat.com" <vkuznets@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/15] KVM: x86: Don't clear PIT's IRQ line status when
 destroying PIT
Thread-Topic: [PATCH 08/15] KVM: x86: Don't clear PIT's IRQ line status when
 destroying PIT
Thread-Index: AQHbyRYQW5twOwO4BkKx3eSFSO/bw7PpivWA
Date: Thu, 29 May 2025 11:41:09 +0000
Message-ID: <8c17bd811a533a062a9dd33f39f5183a306df3e9.camel@intel.com>
References: <20250519232808.2745331-1-seanjc@google.com>
	 <20250519232808.2745331-9-seanjc@google.com>
In-Reply-To: <20250519232808.2745331-9-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.1 (3.56.1-1.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|IA1PR11MB6538:EE_
x-ms-office365-filtering-correlation-id: 638ebe9b-d072-426f-50c5-08dd9ea5b4fb
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|1800799024|376014|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RWt4Yk1QSkpVL1QvSENUWXZLT1Y3K1FYTXZHa1R3VUhhOHhvMVQxcU1DSkcv?=
 =?utf-8?B?WHJpcUZkR2Z2bUhGV0V0ZUMwVmp1Wk5FVm1SS09QUktQT25pZFE2eTVDb3Jp?=
 =?utf-8?B?NTh0MFh0NDlMVDRrODdKdWQxcThjNzc5eXhBRUFwVjNwZ3dIcWtEc01FYmxh?=
 =?utf-8?B?ZVZ5Zmw3MjBZRWhrVVlnd0RLSkxGMDM3RjZRV2luR3BVbCs4YUQ4R3hVOUF1?=
 =?utf-8?B?eXh3ZjUyRy9XZ2pkYzBLY09pd1IwL3d5SFpPSG5BWUNlT3JtcmR2K0szeGZU?=
 =?utf-8?B?SmE3WkxzK2hmcHkvQiszWUV6dS9sTEU3U3J4c2FlM0l1aG9KdGJtTTU5RUlj?=
 =?utf-8?B?NmI1MFcrOGMwdDhyTVg0WXNxL3FMaGNPVDlTaGh5UzdXcGV0Z2ZsRUU5aGVv?=
 =?utf-8?B?TCttT1BGUWJvdk9WRTl4RHNQcXQrZTZIV2xKZGJXVTJXcHRQNnBaK1MySDZG?=
 =?utf-8?B?d0YxZFJtRHFYdHp5bjd6SkJGbTJqY0hFM1ZwYWptNk5oRXhUUHVuRE5QK1Rt?=
 =?utf-8?B?cG9UVGJ0UkpPVUFGNS9ZVEE3ck9QTnVjVldzZ0gwSi95dldaNHFVRThIQnR3?=
 =?utf-8?B?Q2F2TXRHeW4yUENzQWpaVTV3dnFZdTczaDQxeWdvWlY5QTZ5L1pDbk5zbDlh?=
 =?utf-8?B?SVJSVzBvQTVzWHVCMHFsK0VLSlNRM3pSRnNJWFJtRE8zTG5PaysyVVRYcnh4?=
 =?utf-8?B?VGtWUDBVUnJLTHhlemEzQTBjNS9PRkJwZGVzbzlnMVk1YlgwRlh5VTZkWXRh?=
 =?utf-8?B?b3B6VUVTOUJ0QjV4b2E2WjB5azAyUE0xeWxNcFB6ZEo5MHJycFR1eEJNNkhw?=
 =?utf-8?B?RTVEREpjMzZxQ0NNdHVRaDFlaWpvcnJ5emY5OHNPZ0ZrdUV0RmM4K0NsNXd4?=
 =?utf-8?B?NDBVRm5tRFBVeGtmTjhaSzRNeVFSbXFQMVFqTjNWbFJLbnpIc0MzWmp5aVdx?=
 =?utf-8?B?dWtYY2NQdm9QOVgwQUNGZzJETy9KVWdRVFB2SEQ1KzNBM1BQVTh0RDE4ZjIr?=
 =?utf-8?B?ejkxemt4cHYzU25rUU1hVHNpTUlQcXF5amRmeVRMcjgxKytvUWg0NlRIa1Nt?=
 =?utf-8?B?RE1wQ3FuN1hRQk1Gd1VyWVN3UVFNakkwYytTSUVGR2lmTU9MM3ptQUpUaFI3?=
 =?utf-8?B?c0EzQ0hCVlFGYkhIQThYck9PelVLSTdzcUJVenMwOC9oK1o0blFEcU82T1ha?=
 =?utf-8?B?LzRVUTVCQzRIVHIxZHovQkZlZlpQcW8wUWZPTEluUXhQN2RySWRqVDJZMWZ3?=
 =?utf-8?B?WUpvY0lYb2V5bk5WS2xrQ2tMM05iL0pCU1pmdFpGQTl4TnVjWlJwaDBhNmVX?=
 =?utf-8?B?M2JjNVR1YkxpMm41ckxmVFVVNVoxYksrTnM4eHVaMWliK2c5UVpFY3B5VTYw?=
 =?utf-8?B?cTY0UXZQaTVCbmtqM0xtNmppMVFackUvSVFzb2EyMWJXUDZHUEJTV1BQakVu?=
 =?utf-8?B?cHhGZFRhTyttSVZXdDlHZmt6TzlKbE9FMWoxYXgwWmZScnRIa0FyM2I5bXAw?=
 =?utf-8?B?dURQVU56Z1dtOWJxQmV3aHZab2VNSm1vRUlWNGNTQmJKNmhrNjhtcy8yZUZU?=
 =?utf-8?B?OTJiMXNFUWwyd1VyOXBkWTh0N2VKbjltVTgyQVdFU1F1RzRGS2o0N2FtSnlp?=
 =?utf-8?B?YnJNbmo3SlhDMThGUlBhTk4wVDZrMTA3d3dMS3lrNE9aczRBSHhSZEhYalhF?=
 =?utf-8?B?T2tMZ2ZvVm9rNDNJa2tOQUE0RmsvSGFXS1o2MTYzTWN1STEvcnNuS3k3dWdM?=
 =?utf-8?B?RUR5QUZScHVVb3NCbVFxdnl6U1E5RWVBQmN5MHA0bnRwa2l2OUhMWWk1Vzk1?=
 =?utf-8?B?R1F1VGY0UTFNM05USmNqT1hvSEtYVkI3RC9OSGJhZWR6OUZBY1c0ZDlobzQx?=
 =?utf-8?B?U1dqRDdTZzV2SHVtczkrMjA3S2Q0R2pKdktJMC8vLzdBNjdHbnlEZnlvQ2ZZ?=
 =?utf-8?B?UDVNZUt2MTRNK0QwMGlDa3VoVjNWcnFCWXNZWCsycmZvZWxFTjlaWEd2VENP?=
 =?utf-8?Q?P5o5MkEZVdRwzdypGOjBVhpTG0XIcg=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MGdNbUlaNTR4eFE0UWJXenI0WUZZNWgyZjJ0ejEwcXpHclN2c2F4bkdtSW1X?=
 =?utf-8?B?RWxHT2hwWEpGUEZCRE1ROUpkUnNrcWM4NnRwVGZVWlhkaEpSL2t1UE1CRkF2?=
 =?utf-8?B?TW5UOERxcTRHL2JyckVDNENaaWZscFlmZXRvdzdQdUJ5bUFjcTZMZEdFczBR?=
 =?utf-8?B?aWdUQko2alJEMEVkd09xdVFVYW5iUmZVWG9VQzFReTluY1ZVb1RVRkZoS243?=
 =?utf-8?B?MEFPMWxZd2RLUnZualVMMnRkT2tJanpZWTBXRm1lQ2o4aVh4RFd2VzR5VW5B?=
 =?utf-8?B?Njg4QTVIQ3FCbFlvLzBCRUsveUZ1a3Ztc3JOc0ZLUGg5RlF4QVZLQ3hyL21M?=
 =?utf-8?B?eW52UlA2MVFibWdXK1J3VXkzYm9SZG5KeElHVmFoUTh6YkwrSGhzbXE5QXNU?=
 =?utf-8?B?SDFNMEIzaCtKSUJLSjhTNkplYjdMalRzNmZQMEhTN3dmUCs2MjEzQVZCMW5H?=
 =?utf-8?B?WGVZa25Sc2RUVklOUm9YWTR2bmlUamN6QnppTnBRdnlVcmlFa1dzaFV4WVhp?=
 =?utf-8?B?aFV2TGJvY2tLRkxyL2NiVWcyTkJ1WjlNODR5aWIzZzkrWDdzOEM0eWZqWVMy?=
 =?utf-8?B?WFVNUkM0L3lDYVR1elRzOGxCQWFYT0RaZUtmeU9WMDFCbzVCTDBQT2FqK3Zm?=
 =?utf-8?B?T21EMXAwSDJ4NWJYMUphS3pFYVdOYUNYRjM4ZnFMUEJoMlJuZytkcGt0d0tM?=
 =?utf-8?B?czM4UytxY0wyK2ZFaDBOUEk1QmZsZHcwM3AycTFIUElsZm5pZmdzOWt5K1Nj?=
 =?utf-8?B?aUZ3VmdzRk91NmZYRUZvWnNmM3BHa050VjVRUzg1dy9PazAxMzJ2UUN0dlk2?=
 =?utf-8?B?L2JxZ1pSTUQvOWpUU1lUSXRFK1pMODFkR2NUT3Q5akJrSERtTjFmYXBNWENx?=
 =?utf-8?B?U0FDdnlEaW1RQy9PWnJWYXNRRU01cmorTUNPeGdmeERnMXI3Mjd2OC9ERHZP?=
 =?utf-8?B?RmJCMEZ5SzdCTkJoeFhENUFYUWdRWERZbnJ1TWFIV3JLcDJMRXNXME1QV2NU?=
 =?utf-8?B?S1lTQ3pyQWdGOW5iKzc0N05KZGNBUFEwV0VTTnozbXhqWUlhZSsrQTlWNkxB?=
 =?utf-8?B?eWU2c283WWloZmN4SjY2TXRaTm82RmJtYldUYndiZHZtVC81U3kxNS80dG1o?=
 =?utf-8?B?dkhDbitCeUFtbTBzNyt3V1B0THVPd2JleEN0UEFYUW9NVTUrQUpDMGFoVGla?=
 =?utf-8?B?cFB4NFh2TGx2OElLRWR4OEpLZmorR1IrcFp5NUFVQyt1UEw5RS9PVWk5Y1hh?=
 =?utf-8?B?Vm1yMWhyK3lxbVVSZWRsZGtHdWVnbE1mcXhGbzdTZm5TeUlqU0VCNzVQQ0lQ?=
 =?utf-8?B?V2U0cXJsWktXOGM0b05FUGlrYXVpWktReGxIOFEzUXArSkhGQWg0emE1RHNI?=
 =?utf-8?B?VThQZWtEdnc4K0g3S3BFSlhXVDVaS1RiZytibkNHdXIzSGRMNHlGZng4U25D?=
 =?utf-8?B?RkdoL3dQTmxhTVdacSs5N1NNeFQyYzNsbFlGMkxNU0VzOGpwK05rampvTHhE?=
 =?utf-8?B?bkNBUHBMYUJFaW9TMEFuc3BTZkhDY3Z0UVRzQ1g4M1RQcFZsVWRsby9kZVVq?=
 =?utf-8?B?QmI0anpMNkFXVnVaa0JobmxHUWthNkU1aE5rWWFoSHI4cWdXYUc3QXNwOUlT?=
 =?utf-8?B?UWxNTzJOQTBnbjcwb2hiVkcwRDhlbkhyNUVKOCt4bWU1RjF0OENTTzZ4SVQ4?=
 =?utf-8?B?c2VDY1ZLeloyRDdwRWVsdzNUS3lVb0d5UlY5Nk5La0hMUi9Wc0ljZnVDRnMx?=
 =?utf-8?B?SjBWRXNMSVpqTFlWOVpwYkFTYkEvWi9NTlhYWjZrdEFvM0pDOFpGUXdMcmJa?=
 =?utf-8?B?SDhEY0toT0xPWjEwZTVBbHNiaEZVdHN4RGw2S2tFclNMSmU1MlJBeGVCY2pi?=
 =?utf-8?B?L2FhaFB4K0R6Vkh5ZUd5YlJXM0pzZTJIRkVBaElpdU0rdE9OekJjL0g1Q0oz?=
 =?utf-8?B?QTlmS0NrdTF5bi84MVFjb0lpakNZakNpRmF6U2JSaEFrc1IzRzVjY0Fza2Rz?=
 =?utf-8?B?bW1wc09TKzh1K0dQand6bjNLeG0zVFFVczhEUDVtK1p0MWJZZnNGQTNXeEdM?=
 =?utf-8?B?TjNyK1YvUk1ydWViYW9uK05JMmlXTUtnRlE3dE5pYXJhTkc5K3cwV3E3V2Jj?=
 =?utf-8?Q?MVLL02uMrfkoXtA/a24mCn3kt?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D42C25BC3D1B6B4C9AE8B815326619BF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 638ebe9b-d072-426f-50c5-08dd9ea5b4fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2025 11:41:09.9168
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: alEgQAhzNstJMsY/fEKm3DjqNwKHj6Tf62owQTbiMSdtzjx4sGZQh2Dhrv0j1f4tM/MDRLywZynIEoBbTHyL8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6538
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTA1LTE5IGF0IDE2OjI4IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBEb24ndCBib3RoZXIgY2xlYXJpbmcgdGhlIFBJVCdzIElSUSBsaW5lIHN0YXR1cyB3
aGVuIGRlc3Ryb3lpbmcgdGhlIFBJVCwNCj4gYXMgdXNlcnNwYWNlIGNhbid0IHBvc3NpYmx5IHJl
bHkgb24gS1ZNIHRvIGxvd2VyIHRoZSBJUlEgbGluZSBpbiBhbnkgc2FuZQ0KPiB1c2UgY2FzZSwg
YW5kIGl0J3Mgbm90IGF0IGFsbCBvYnZpb3VzIHRoYXQgY2xlYXJpbmcgdGhlIFBJVCdzIElSUSBs
aW5lIGlzDQo+IGNvcnJlY3QvZGVzaXJhYmxlIGluIGt2bV9jcmVhdGVfcGl0KCkncyBlcnJvciBw
YXRoLg0KPiANCj4gV2hlbiBjYWxsZWQgZnJvbSBrdm1fYXJjaF9wcmVfZGVzdHJveV92bSgpLCB0
aGUgZW50aXJlIFZNIGlzIGJlaW5nIHRvcm4NCj4gZG93biBhbmQgdGh1cyB7a3ZtX3BpYyxrdm1f
aW9hcGljfS5pcnFfc3RhdGVzIGFyZSB1bnJlYWNoYWJsZS4NCj4gDQo+IEFzIGZvciB0aGUgZXJy
b3IgcGF0aCBpbiBrdm1fY3JlYXRlX3BpdCgpLCB0aGUgb25seSB3YXkgdGhlIFBJVCdzIGJpdCBp
bg0KPiBpcnFfc3RhdGVzIGNhbiBiZSBzZXQgaXMgaWYgdXNlcnNwYWNlIHJhaXNlcyB0aGUgYXNz
b2NpYXRlZCBJUlEgYmVmb3JlDQo+IEtWTV9DUkVBVEVfUElUezJ9IGNvbXBsZXRlcy4gIEZvcmNl
ZnVsbHkgY2xlYXJpbmcgdGhlIGJpdCB3b3VsZCBjbG9iYmVyJ3MNCgkJCQkJCQkJICBeDQoJCQkJ
CQkJCSAgY2xvYmJlcg0KDQo+IHVzZXJzcGFjZSdzIGlucHV0LCBub25zZW5zaWNhbCB0aG91Z2gg
dGhhdCBpbnB1dCBtYXkgYmUuICBOb3QgdG8gbWVudGlvbg0KPiB0aGF0IG5vIGtub3duIFZNTSB3
aWxsIGNvbnRpbnVlIG9uIGlmIFBJVCBjcmVhdGlvbiBmYWlscy4NCg==

