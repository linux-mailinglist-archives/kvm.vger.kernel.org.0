Return-Path: <kvm+bounces-60022-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 58CBFBDAF9F
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 20:52:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C233545A5D
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 18:52:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E13A2BEFEF;
	Tue, 14 Oct 2025 18:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TTxb7xE4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FE227F736;
	Tue, 14 Oct 2025 18:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.7
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760467933; cv=fail; b=mVw6iLO6n9Acg0M1KjD6CFhyONOpmnWMdSKqAf/hHUpnz446kvXl3ipKa2rp1kkKUdb3Rjv9yDUcrjUpzBhTwn5fs3mYsfUCZWX62R4tqShB6d+RHEXeMKcjqBD9YAPD3VIzmHb/Yi3/0aXZqOvUHpDm0sQkaRqWuaKqPImlcvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760467933; c=relaxed/simple;
	bh=uYD914013hVd4WTaNjGCGN4OxKWdAbBHcYj0C5AtvgI=;
	h=From:Date:To:CC:Message-ID:In-Reply-To:References:Subject:
	 Content-Type:MIME-Version; b=jbKRAjEyyuUT4KNOOuwjHEoi7EVoZ3KL2U3KDETeyUh0pEypkSEGNFkIpwVPeira6u+F1XdOOH0W2uKPzM34r9/9I930WHtdwgD3FO2XW//iEllBpMHqakPOq4QZfVhybZDEuV+LPkHFx+6wAIZdNrNH19NNDYdPbExC0m0o0ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TTxb7xE4; arc=fail smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760467931; x=1792003931;
  h=from:date:to:cc:message-id:in-reply-to:references:
   subject:content-transfer-encoding:mime-version;
  bh=uYD914013hVd4WTaNjGCGN4OxKWdAbBHcYj0C5AtvgI=;
  b=TTxb7xE46vUj/VHxgYV0rNumUw6bqeUaxeouS7EEejo0pM9VWHPqZwjd
   xzK7+T7OmO7EbdyMqz46Fz7jCuEX1ssGu8oGz8V+LcsdzHzR19NEz8JrT
   iCCeGoDA+8ZuDptHuicU43JB/FwQhjsAm5yXpvl2VG5xUFl1Obd67H0gY
   ChuS0qvW7s7o+/XcrCQcbHVjYd/WBhEZD6mjsmBp1wKj3XPOdeh+Qaz8G
   FjLt2ZRoBDdlSsxCVlhmOQ/lgqYnfLB9T/S5tV1odxyvhRAgibwQJfKjc
   GZL7j4zaQfgmFebF2rfAUQJuBjhL4+S403GL3Tk45HPWA8tN1BwhIFjqe
   w==;
X-CSE-ConnectionGUID: 2eMjtD7oTGGFQgz2dz/bvA==
X-CSE-MsgGUID: uBRNWcxSRf6zFenDyeW+cg==
X-IronPort-AV: E=McAfee;i="6800,10657,11582"; a="88100506"
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="88100506"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 11:52:05 -0700
X-CSE-ConnectionGUID: oCBWUHJ3TzmxlgIrZo1OfA==
X-CSE-MsgGUID: 9VLWYEogRcSRdcomeVIJFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,229,1754982000"; 
   d="scan'208";a="182400791"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by fmviesa008.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 11:52:03 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 11:52:02 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 11:52:02 -0700
Received: from PH8PR06CU001.outbound.protection.outlook.com (40.107.209.64) by
 edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 11:52:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vOmW3rsVjl3Jro6yQzM4meMaa1ahPeIpPcuzmRJZKm/yIYLuvwUHIPn78EaxQ97/q3zQTMxPFipDLp35ZUqrvOPpzteYN4acDLBtYZ0g3FZrsM1qPVxM9hndCbN6rnXfF3zeOhR010rRpO+bZvy7A0cVDvgnVpX4r0Ii4/4DokehjULNsSVT2hjsaOcUx+LpTFwUJCPH0ETlr+5xbRw0z8tVGJfX4SQxclXXfOefFlJNQ6CTD+a5bMNV7/02ef33c1KVXSgOOI10kmech0LFUluXV5HUKZjrwZwg6MV+LQrDXCZPPzRMLEY85YeIyy4higwhXu5GSmwZP+aKQdGL2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rehFQzysHN6lEbNdkzdpVFyjtRoj/wf1NtVxFbFLgaA=;
 b=tjG7/NDNykTMfyLrYV7LCDix6hllVq0cdNunkLdmu0u68Xzn2KIOgAS+oERMa3QFD8rGIrGeUeL5mUPW76AldotUxURYiVab0mmI5uk+XZ7cA3h59JTh8hci9H/1CKbY9g0SQfyqSaWGG/o3ROc06c3MIGMrWgFSSLm+LBOBOuFMs7bgboJWsX/xoGIUOhvWM3PqRMaFrFUK3Ki6Ug4gKvkvwmctiXX2MPaSEe97IUk3RZ5tOUTwQqPqQMJbeql+jf0STLIrOiHnIVsP95aRtcPbgxJ1nbMIiRrd1L99jTtJgRDdxZqe7gTtimWnNpozHBjtg+iw5Sbg0N6KsjZR4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH8PR11MB8107.namprd11.prod.outlook.com (2603:10b6:510:256::6)
 by DM3PPFD3EB37DFC.namprd11.prod.outlook.com (2603:10b6:f:fc00::f52) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 18:52:00 +0000
Received: from PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff]) by PH8PR11MB8107.namprd11.prod.outlook.com
 ([fe80::1ff:1e09:994b:21ff%4]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 18:52:00 +0000
From: <dan.j.williams@intel.com>
Date: Tue, 14 Oct 2025 11:51:59 -0700
To: Chao Gao <chao.gao@intel.com>, Sean Christopherson <seanjc@google.com>
CC: Rick P Edgecombe <rick.p.edgecombe@intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "kas@kernel.org" <kas@kernel.org>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "bp@alien8.de" <bp@alien8.de>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, Kai Huang <kai.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Dan J Williams
	<dan.j.williams@intel.com>, Adrian Hunter <adrian.hunter@intel.com>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "xin@zytor.com" <xin@zytor.com>
Message-ID: <68ee9bcf14fea_2f899100d2@dwillia2-mobl4.notmuch>
In-Reply-To: <aO4LVTvnsvt/UA+4@intel.com>
References: <20251010220403.987927-1-seanjc@google.com>
 <20251010220403.987927-4-seanjc@google.com>
 <ffc9e29aa6b9175bde23a522409a731d5de5f169.camel@intel.com>
 <aO1oKWbjeswQ-wZO@google.com>
 <aO4LVTvnsvt/UA+4@intel.com>
Subject: Re: [RFC PATCH 3/4] KVM: x86/tdx: Do VMXON and TDX-Module
 initialization during tdx_init()
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR02CA0018.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::31) To PH8PR11MB8107.namprd11.prod.outlook.com
 (2603:10b6:510:256::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR11MB8107:EE_|DM3PPFD3EB37DFC:EE_
X-MS-Office365-Filtering-Correlation-Id: de186cb7-33f3-423c-b958-08de0b52c1ac
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?VWxvcnlxa29MME01UXI3V2JWTFIraEpDTEdxZDVBckw3Y2pCZjAyMjBMTWJq?=
 =?utf-8?B?aXc3K28rRitlZWdOdWRYOTlBSTNZb1RBYnBWZGxhZ1AvTW5hRm44UElZOFJi?=
 =?utf-8?B?dWlxd2x1bTNOV2lpajZPaTNzKytTT1hSVjYxTHNvb3poajVEN09ZaEgveFRE?=
 =?utf-8?B?SUh4TEcyM0s5TXJhL1gyV3FnemdQdnVpVWg1Y1luTzRiQ3hXeCtab3UvQm1F?=
 =?utf-8?B?dlFtN1d0aGx6Z0xicW5Fb2VaK2xsdy9ETSs1bHNtMXN3eWkxUEJqOWdLNlJm?=
 =?utf-8?B?dFp2c3lGV2tKOTZXRmdwUnh6TDZvNXhrQXM1WEtPWEJISTVia092elBkUGQz?=
 =?utf-8?B?YTdTNHM0c0FZRzVTcUR0YkE4cXpwT3ZaNDhQdGJYcVNWOTJXTXUzRkV1NzVN?=
 =?utf-8?B?QU1CMFdOa2Q2aWg5L1lyMENENUUvYXVXMHk3WFIwWnBXRmNyclB4bWhWbnJU?=
 =?utf-8?B?MTAycjhzSW9tTzI2U0pSSkR1K3JPZy8zR2VYRDhiV3RDRWZVWjd3LzJFcnk0?=
 =?utf-8?B?RGt0dXAwMDVxNXNrZE9pTGx2bFlOc09heWRKVHFmeEJhNTVYcnhvZG9LeU1a?=
 =?utf-8?B?Wm4zaEMyK2JXbFhYdmR0QlZLWW91eEJUTzd6ZE54OU5nSk1VNDVDQTdNTWd4?=
 =?utf-8?B?U0s2OFZiQVVPSFVPeWlKRGV0UzFCQ01HcTFUWi9Za0JmSndtWnlGWTlxMWQ0?=
 =?utf-8?B?L1FLK0JzRUN3SEZyK1VGcmpVVjdjNEg3U2hhM1NyQ1FqaFBxZDBDK24wcFRr?=
 =?utf-8?B?WFBoZFZPSTR1YlpnWCtXVlNpYmhqS05VbXNzS3pKMVVZUDVvaE43UTZmdHox?=
 =?utf-8?B?MzV2bnVRQkUzUnNFMzN0QmlWNFA0OXhqSHVyRXhoUjkzR0tTaXFIc1pTcDE5?=
 =?utf-8?B?SHF3andkbS84ZmtLRnB3U3VRVThaQTczVGdEcjFDd0Q2QjlwZVg3V2gweUk5?=
 =?utf-8?B?UE5rSTVvTFFaOUJJa05mMVRzSnI4UWFjWHVSZ1hwOVlBcmdXMkkzODZFSzNh?=
 =?utf-8?B?UmQ4bWh5ZjMxUkoxaUYxVWZLVGRiZFlDc0NIS2lSNmttQ1pXa3Bvc3JnaUJG?=
 =?utf-8?B?UldVTnVLL0RKNjR3K0tzOHh0QmNNUzlIa3dCL3B0M3pMZ2JaN2hFeGZESm03?=
 =?utf-8?B?cWZTSi9qenRXYmFBS2FMN3FxbzZtSXlnQWIvaS9EQUZPdGVoZDVhOXpzcVky?=
 =?utf-8?B?VmpKVklkc0o5YjkxQjdGME9JdWNmZGQ5ejZvZXZPQXJRZUhnRE0wc3V4RjZw?=
 =?utf-8?B?TlNDTzkrTVZLZnFRSS81eFdjVUZGczJaNE1WVXBTY1hjQm1JV1pXMTByenlr?=
 =?utf-8?B?VG9PWisvN1N0S2Z5MlY5K1lqRGxkNXNteVJYeVJmREloRFdTeXRmdTU5SHlv?=
 =?utf-8?B?K2hHTE9UYUJwSm5FM0JHN3dleXZNWVhzcmRiQndsNWw3TjBodkRuWWpwc25s?=
 =?utf-8?B?cTQ4UFYyQno5RTY5bTdWdTBnQWJpVHpVQUdzQXJ4Ukc3dGFsRUlIVHp3clh6?=
 =?utf-8?B?aGF2eGkvSzlBazAxZkdJdDNRUWJ5U0VaQ0V4UjF5VnVHalZIRCs4TmRLd01k?=
 =?utf-8?B?S1VnbmlwWGFIWHY3MkVvdGpKdlFJa25nUzNSZGVQVWhkaFZ4RHVhazlubkxt?=
 =?utf-8?B?dERMV1JJZEJRN0FDN05HVUc4NEZGSzZPNjdMYUZYNmhheEFjc042U285dlNo?=
 =?utf-8?B?SUNhbDJyWmxRcllLODIreDhxTkErZXgyaEdVM041eFFiQUN4M3FwTngvWS9L?=
 =?utf-8?B?a1hoYWs5UDlOa3c4bzdURVNKQWZTQ0FHRXVFczhyZk5iWTNiQTFRZFYva29H?=
 =?utf-8?B?d0hCai95VXJoTi9IVUlGZEVwYTQxYUh6N3lGUU5RNjRLUDcvYzh3LzZBUW1M?=
 =?utf-8?B?U1Y4VzVJbG9yem9vWkNiNnc1RTFqeXFEcnVGRzhDTzNSaEt4QW5FTDd6bEVz?=
 =?utf-8?Q?2X4M2rNVhRKv1ZoD2Ozfvy4JuxpMaYsl?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR11MB8107.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NjBWbUhobjIzc2ZZQWZ3ZWtoeXN0M2FpOW5FbWtvMTBuaThtWWFTS21jWmNT?=
 =?utf-8?B?Qzh6aHA2TTllSG9kMWoycGJQcWdhM25YVlBuTE1HQmVlNzR0MUlmRVNnWFht?=
 =?utf-8?B?SjJFZFJPUU9uWUZ0TUVFd05LbGJUVXJHZGY1TEk3Zm5vOTlEVVBDYUVFbEhL?=
 =?utf-8?B?SmsvZFUzNlFCR1BMc2ZhaktTVjhWL2RGaXA3ZGZJNVNaTVVlUlc2aWhXQXNy?=
 =?utf-8?B?WmpTOXdCcTcxTzFiNVhVUW5oNkVoR3B3eUNsWmtyZm5JZVpJS1VKakF1V054?=
 =?utf-8?B?NFdram5qb0VmTFc4Q051dXNobjZVMXhlOVFqeGFTNkFBbEdVTnE4TFNIVTQr?=
 =?utf-8?B?TjdxWHpWamVpU2xveUVzVHFXaVFrazF3TXYxVkE5T2E5VnJndWlWQS9QUWM0?=
 =?utf-8?B?VXJ3eHVLRXJBUm5KWURmbmkralhoVXM1RmVGQzBVMmQzREVHSEFpTUpBcTI3?=
 =?utf-8?B?UGhpMGk5aGlrVkRiUmVja3UwOGZtcm83YnhKaUk1ZkFRcFp6TmkrRm1DUisy?=
 =?utf-8?B?cmtxYnJQUWd6Um92TmVDc2ZKWGRkb29ERjdpbG9TdHYwVzdGT282dG40R3F1?=
 =?utf-8?B?dWV6RWRZdTh3Ymowa2VmaTJ1QWR0Q1ErdlVXaTlueDM0ZFQzcWRvK2tmZllE?=
 =?utf-8?B?QUV2dG1PYnNGcjJtU2NMQmVkTk1BQlBmd3ZQd1JRZWIyeGJha25aZDg2LzYx?=
 =?utf-8?B?M0FFelZZZEpWZHUwTkJSblhkb1h2am5uQ2JGTENjVVpxSmFRZ1ZYYjJJaCtn?=
 =?utf-8?B?TXUwMWpRZ0NqSk5ublEzaGk2YlJTU3RURVpLc1NKRzd1ajF2TlJyeWxld2pZ?=
 =?utf-8?B?OUx0Rm53cWUyU1FWTUlzc3huNG96dzNsclBWSE9waHZ1alFLdHh5d3ljdzZr?=
 =?utf-8?B?dkhLQ3htNytFYThjMEV4U0NpcjFuV01tSkdaTHcrNVNLbDdHSWVrWHJaVUd4?=
 =?utf-8?B?dEF5TkFNYTJ4eDl3TUdHb093K3VCUHVTZ25Eb1pGb2pkTUpWSHoyTnI2QUls?=
 =?utf-8?B?OHQ2VkQwYVUyckE4M2dWU2lHL3pyVGpENnovdU9IQ043KythV3NEUGdEREMz?=
 =?utf-8?B?NXRqdlRSYzl5cnVKd1Y3VzlQTlRDaGdxbHRieUh4SWViblBvM3hTZXc2dnpw?=
 =?utf-8?B?b2k1RDV2REMwdTFwUWdWczg3ZkErektSYU1iUXVmRlpqTGx5V2QzOWpYcnl4?=
 =?utf-8?B?Vnp0Z1c5c2s3UGljTUhrcHh6dm5ZelZIcldPZmU2Sk5TSEJab0pUTlYrSm1v?=
 =?utf-8?B?T2R4ek5QTzFrclBMRjlQcVVOT0szSS9mbEduU3JyRnQzSzJmcEhjY2xZK3Q0?=
 =?utf-8?B?TEc1Y2E3K0dpN3NPOHFQRGgvZHNERy8rdVlrTVVxVG01N2tpQkZ2OFpWbHh4?=
 =?utf-8?B?cGlaVTdYbmVpRmR2cDJqZmZFdXYwMWcwMHE1QTFSbGlWeDdwWHJWMlE2aXpZ?=
 =?utf-8?B?SW1jOUFkWFUwUUdmRmFpQmVOUDBZdXpRR0N3ampYS3Uwb2c5VWdhRFdjZmE0?=
 =?utf-8?B?R3dOTTJkem9DNXd6VWtwREQwWXJDZnJBeEloQ3hUVURBRG8zY0JGZ0QzbWdL?=
 =?utf-8?B?bHl2SEExS2MvYm1COWhldGRRUUQxSjNDUDlvYzkvenpxL2Mrb3JTaTc1RHB4?=
 =?utf-8?B?WUhyR1I0N1NTa2w3eDFsZjZqUjh6cVBsZ0NoQjBqbXBVRnJyS0ZSSjcrVVJs?=
 =?utf-8?B?Z2xjSkM1R05BdlpWWmJvYjlLeW1Ld3grcTVNZzRHdmVZSmoyd1IwWHRSRzRU?=
 =?utf-8?B?QzBMSkFTbUlqVHZPdzJkRTExd3ErQzM0cU9GQXlwaGI2eVk1Z0U1clJheXhD?=
 =?utf-8?B?NHQyWmIrMlVRSnBEWU9IdXdjMVgxM3NMdjhBS253OVgzcXNTQUY2YzlOdk1R?=
 =?utf-8?B?UTRSQk9KeUdLc3E1Q0NvZ2xmZ3liM0NBbDFNa1VDd2QvWmdlckU0MjJ6ekdP?=
 =?utf-8?B?ajFYZkNnR203dG4xSnVGSlRRRFpoc2lQbWV2ZWk4WDhnU0NyUVNGRmRUNEJN?=
 =?utf-8?B?Q0tIUW43K0lHcHQxeXlXUzhEUSsrZ3VPUjl0aEc5RytVSG91cjE4UTQzU1o5?=
 =?utf-8?B?NGU4TXVxMmgwYVpIN2x5UWp6K2k1VGN2SWpEK2U2RzZpMVkrTWxDRGdhcjBD?=
 =?utf-8?B?eFpVT2NXdUlpeFkranJTNy9ITVlsL2M0dlAzLzR4bGc4RnI1cVVnVXRzOW9F?=
 =?utf-8?B?dEE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de186cb7-33f3-423c-b958-08de0b52c1ac
X-MS-Exchange-CrossTenant-AuthSource: PH8PR11MB8107.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2025 18:52:00.0712
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7TKQkU5CmnseTUJtxS5RS/jiWPoQviWVFOgUDgZkaIIGQFYAZJsyzQxyYCD0751cBoTMXIP0CzjAG9MPhtK6h1P+LFsArpQbI01IxZReo1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM3PPFD3EB37DFC
X-OriginatorOrg: intel.com

Chao Gao wrote:
> On Mon, Oct 13, 2025 at 01:59:21PM -0700, Sean Christopherson wrote:
> >On Mon, Oct 13, 2025, Rick P Edgecombe wrote:
> >> On Fri, 2025-10-10 at 15:04 -0700, Sean Christopherson wrote:
> >> > @@ -3524,34 +3453,31 @@ static int __init __tdx_bringup(void)
> >> >  	if (td_conf->max_vcpus_per_td < num_present_cpus()) {
> >> >  		pr_err("Disable TDX: MAX_VCPU_PER_TD (%u) smaller than number of logical CPUs (%u).\n",
> >> >  				td_conf->max_vcpus_per_td, num_present_cpus());
> >> > -		goto get_sysinfo_err;
> >> > +		return -EINVAL;
> >> >  	}
> >> >  
> >> >  	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
> >> > -		goto get_sysinfo_err;
> >> > +		return -EINVAL;
> >> >  
> >> >  	/*
> >> > -	 * Leave hardware virtualization enabled after TDX is enabled
> >> > -	 * successfully.  TDX CPU hotplug depends on this.
> >> > +	 * TDX-specific cpuhp callback to disallow offlining the last CPU in a
> >> > +	 * packing while KVM is running one or more TDs.  Reclaiming HKIDs
> >> > +	 * requires doing PAGE.WBINVD on every package, i.e. offlining all CPUs
> >> > +	 * of a package would prevent reclaiming the HKID.
> >> >  	 */
> >> > +	r = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "kvm/cpu/tdx:online",
> >> > +			      tdx_online_cpu, tdx_offline_cpu);
> >> 
> >> Could pass NULL instead of tdx_online_cpu() and delete this version of
> >> tdx_online_cpu().
> >
> >Oh, nice, I didn't realize (or forgot) the startup call is optional.
> > 
> >> Also could remove the error handling too.
> >
> >No.  Partly on prinicple, but also because CPUHP_AP_ONLINE_DYN can fail if the
> >kernel runs out of dynamic entries (currently limited to 40).  The kernel WARNs
> >if it runs out of entries, but KVM should still do the right thing.
> >
> >> Also, can we name the two tdx_offline_cpu()'s differently? This one is all about
> >> keyid's being in use. tdx_hkid_offline_cpu()?
> >
> >Ya.  And change the description to "kvm/cpu/tdx:hkid_packages"?  Or something
> >like that.
> >
> 
> Is it a good idea to consolidate the two tdx_offline_cpu() functions, i.e.,
> integrate KVM's version into x86 core?

This looks good to me, some additional cleanup opportunities below:

> From 97165f9933f48d588f5390e2d543d9880c03532d Mon Sep 17 00:00:00 2001
> From: Chao Gao <chao.gao@intel.com>
> Date: Tue, 14 Oct 2025 01:00:06 -0700
> Subject: [PATCH] x86/virt/tdx: Consolidate TDX CPU hotplug handling
> 
> The core kernel registers a CPU hotplug callback to do VMX and TDX init
> and deinit while KVM registers a separate CPU offline callback to block
> offlining the last online CPU in a socket.
> 
> Splitting TDX-related CPU hotplug handling across two components is odd
> and adds unnecessary complexity.
> 
> Consolidate TDX-related CPU hotplug handling by integrating KVM's
> tdx_offline_cpu() to the one in the core kernel.
> 
> Also move nr_configured_hkid to the core kernel because tdx_offline_cpu()
> references it. Since HKID allocation and free are handled in the core
> kernel, it's more natural to track used HKIDs there.
> 
> Signed-off-by: Chao Gao <chao.gao@intel.com>
> ---
>  arch/x86/kvm/vmx/tdx.c      | 67 +------------------------------------
>  arch/x86/virt/vmx/tdx/tdx.c | 49 +++++++++++++++++++++++++--
>  2 files changed, 47 insertions(+), 69 deletions(-)
> 
[..]
> +	 */
> +#define MSG_ALLPKG_ONLINE \
> +	"TDX requires all packages to have an online CPU. Delete all TDs in order to offline all CPUs of a package.\n"
> +	pr_warn_ratelimited(MSG_ALLPKG_ONLINE);

Why the define?

> +	return -EBUSY;
> +
> +done:
> 	x86_virt_put_cpu(X86_FEATURE_VMX);
> 	return 0;
>  }
> @@ -1505,15 +1541,22 @@ EXPORT_SYMBOL_GPL(tdx_get_nr_guest_keyids);
>  
>  int tdx_guest_keyid_alloc(void)
>  {
> -	return ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
> -			       tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
> -			       GFP_KERNEL);
> +	int ret;
> +
> +	ret = ida_alloc_range(&tdx_guest_keyid_pool, tdx_guest_keyid_start,
> +			      tdx_guest_keyid_start + tdx_nr_guest_keyids - 1,
> +			      GFP_KERNEL);
> +	if (ret >= 0)
> +		atomic_inc(&nr_configured_hkid);
> +
> +	return ret;
>  }
>  EXPORT_SYMBOL_GPL(tdx_guest_keyid_alloc);
>  
>  void tdx_guest_keyid_free(unsigned int keyid)
>  {
> 	ida_free(&tdx_guest_keyid_pool, keyid);
> +	atomic_dec(&nr_configured_hkid);

So, ida has an ida_is_empty() helper. I believe you can just use that
in the offline helper and delete @nr_configured_hkid.

