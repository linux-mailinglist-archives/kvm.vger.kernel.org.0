Return-Path: <kvm+bounces-17770-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 65F128CA001
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 17:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E6BD41F219CC
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 15:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3DBC136E3F;
	Mon, 20 May 2024 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="haa3P3Zq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70B8524D4;
	Mon, 20 May 2024 15:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.14
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716220070; cv=fail; b=sOVpNjvogvQE5ny9FX69o55Q8VN/NFIWCJ7DABWCON+JCg5QpnTkFeT22gFN6zeSjTzgouN4IqP561SotWp9zochM10s0C6sRzcK2xIgSPbLFS2mqEZ6adxiWPfmNkiwJ7pG7fS+EopFnoanznpTNv1WiMCSxHJ/IqeO4Oc524s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716220070; c=relaxed/simple;
	bh=NW4N3gskxSL0JBIR7KpgbliKvJQBJdMJdfhYaYRzOFQ=;
	h=Message-ID:Date:Subject:To:CC:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=cQeexQtb04xo9OTR0BbnabrbwXWGviUt38IqFwNCMz7qjiDptolKBAhToUFTg1zxwM0CXixhO1v9o7abtd9clF70yKn0yShB6XXXgyAG6fAj4cZaDsj81gbFk6/U5e2ic1xc665b+03SrulqJaR2W1DZiq1EQYZaezlAVc40HYo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=haa3P3Zq; arc=fail smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716220069; x=1747756069;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NW4N3gskxSL0JBIR7KpgbliKvJQBJdMJdfhYaYRzOFQ=;
  b=haa3P3ZqWz8v/Z/S9rqEFiuxJNhLd6/bo/U9U32LAJeBBVhD65Qaizpj
   B6VxrMfMYwvi+Ce+6pLYablWxidIAhcXGwKcTiIKZuP6SJE39r1fKGeIN
   KoaKck7VfqZ9dzU1PR21Cv1O0y7oXj8mfYV1DOiWNW3NB5hc617wBx5PA
   SQeNCIpUY6qeIEvuQgsZ98Mrk6PU/n4S4eaKXj5DtYTJioN7MJidTp/ib
   891RUmB3SGHioEdFjfm9vpQLgxzSZZyLZKAfFO6FyH7VEnqz8ln3q07fK
   KM/Y1hL1cCEK7H1hoGgi4CsGCcTN6FfHSjXWgJFHccoJre7Wt0suVP/+5
   g==;
X-CSE-ConnectionGUID: 224wEVAMTh+Np/Fd0N13MA==
X-CSE-MsgGUID: tLvKNx0gTtetbHughFfv6w==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="16186776"
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="16186776"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 08:47:37 -0700
X-CSE-ConnectionGUID: tX+sSI0RRxu6rpt7Csc+rA==
X-CSE-MsgGUID: YdyLF5gUQ6i1OhhUwZf8dw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="63816204"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 08:47:35 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 08:47:35 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 08:47:34 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 08:47:34 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 08:47:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=js03vd4TUKgBLgw2Li2zPrCQlgroCknb3NVSPT8IZGldWjc0nTyKoEODEYswHpdXgo2dnLyLVlX6SUU38rFm4HRQAizTWc7qKq/R9LTQ3E2q2+UdJENUWCbsVO2uFiLjDx9WEloZ9NwmFahSrwk9ENdYTc4aw/ezHdwCXApO/PSU3s0awPEmptQON2/eERHfdktZ44i87PYOPu84g9CkJ1REM+9mNwihR+864ymRMRWjgWLRpv1Q45ofGyiikTVW1b1Q/HTCoALby/U3c/ZYHzMATF/1Zkn8DwhbM6idHtbFQDLIbd0IqGBJXLtwfW+KPSFTmD/QocHG7+77P6hDow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jHo72XSoxQOdHkKFPSiH96JDI4AtuEYv+d6qMplUKEA=;
 b=HQt9mYiyo11d+uPOCfjIcNZFFH6nxbVQzYeXZKinti1ILhJpdE5spMaGgy5rQeGpGSp4inzQ0noPWlQ4gXPSqOVgvEmrZJfF8LUF9jLrFJ/KFnqvJDvC3Qsy+gusEclBkRbk3Q3NWswG5FcK2fpeRfPHIQCySfeWZWz1RC4H/K+Ja2tUnjQbdIHXmggtM4GpiIm11IobLv0U1io1GRBa6AT1puiZeLKMdjMYurB/Blp7r6omdFHY+UMuHOE0+o3yx+ZwJ750c4+WuQZ5Hmlgd/PAPZts6X7+eFbdiuv6p+VGnD3cr3p1DGnHpSNLKWCvWG9qwmL8+Epc/s6N+dfKxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com (2603:10b6:a03:4d2::10)
 by SA3PR11MB7655.namprd11.prod.outlook.com (2603:10b6:806:307::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Mon, 20 May
 2024 15:47:32 +0000
Received: from SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf]) by SJ2PR11MB7573.namprd11.prod.outlook.com
 ([fe80::61a:aa57:1d81:a9cf%3]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 15:47:32 +0000
Message-ID: <c2baeb4b-5cad-4cb9-a48e-0540f448cb15@intel.com>
Date: Mon, 20 May 2024 08:47:29 -0700
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V6 4/4] KVM: selftests: Add test for configure of x86 APIC
 bus frequency
To: <isaku.yamahata@intel.com>, <pbonzini@redhat.com>,
	<erdemaktas@google.com>, <vkuznets@redhat.com>, <seanjc@google.com>,
	<vannapurve@google.com>, <jmattson@google.com>, <mlevitsk@redhat.com>,
	<xiaoyao.li@intel.com>, <chao.gao@intel.com>, <rick.p.edgecombe@intel.com>,
	<yuan.yao@intel.com>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <cover.1715017765.git.reinette.chatre@intel.com>
 <a2f7013646a8a1e314744568b9baa439682cbf8a.1715017765.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Reinette Chatre <reinette.chatre@intel.com>
In-Reply-To: <a2f7013646a8a1e314744568b9baa439682cbf8a.1715017765.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4PR03CA0190.namprd03.prod.outlook.com
 (2603:10b6:303:b8::15) To SJ2PR11MB7573.namprd11.prod.outlook.com
 (2603:10b6:a03:4d2::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ2PR11MB7573:EE_|SA3PR11MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: 147d5b48-ec7e-409f-b0fc-08dc78e42943
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|921011;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?Sy8za2M1UkgxbGFUVmdqNjE2S3l2Szl6b1VFZUxmdWh6TU5wKzlLQ1R0NDAr?=
 =?utf-8?B?cUc0M0gwVUI0Q0lCNGloakFJL1c2eEVxZ3dYa090TnFWOWdZeUEvZmhsK2VX?=
 =?utf-8?B?NWhqSWdiL2JLYisrc1BZTjV3dXR4b01ETUh5SGhjSGE2eUJ5U0JmV1B5b3Zp?=
 =?utf-8?B?NWU2TjJ0NFE4cWVCSzE0ampYQzV0Z2dYZ0pxaWFZVGxuOEhZYkRabjZvRlh2?=
 =?utf-8?B?Um9FemNteTgyUjkxSGRXK2xzREpoaEltRzJpOVFwdmFxeU9KZVoycExOVkU1?=
 =?utf-8?B?RmwwVDMyVnk2TE01dGQ4SE5FUFRDU2NNdFNnMGZaQjgwdHUzUndGOE1NSjhj?=
 =?utf-8?B?T2xaQ3lpYVVZWHJUYmxSTnUySzJReWlZUzIxb3c2ZWwxNzFRQklkc3RvcWw0?=
 =?utf-8?B?Mm5mVHpZdVlac0h2YmdEUmhsaEIzbzg0aUM0WWZLV0t3TVgxT3h3bmRvTElE?=
 =?utf-8?B?YmZMWTVvN0FLTVhhcHhHL3AyTHhmTitBcDdWWlhERFNMTHV1d0FMeEJjVHF4?=
 =?utf-8?B?bjhaT2prSzFkWWVnSDB5MkhJTmJabjU5Tm14cWIrT0tVRHJVaTBiSmpHdnFl?=
 =?utf-8?B?RDI4blFQWmU1V3c1eGFwOVdrV09CWW1sK0I1bFhGV2FHdG1HVjBUL3REcDUr?=
 =?utf-8?B?cXQvTzBYVjBPb1JON0NyR1VyT200SnFwNkZ1ZEF5STdxeFc2ZjVFTEVHMDkv?=
 =?utf-8?B?ak40K09iTm5kQkwweDRQZXJLcGhJMjIrdUl2KzBqdElpeldYV3hpQlJMTlEr?=
 =?utf-8?B?QWdUODhDOGI1T2JJQmpHUXQ4WUVIVURnS2Z5MXErdjJLYlZ0b0ZYVGtadzQw?=
 =?utf-8?B?elhNWi9UeFE5Z0JjTThrb3ozaXU1Z0hwV0EvSk15Sk01TlBFRTBJaEpaWjEw?=
 =?utf-8?B?TFBFdVQwbzdISWhXOXptMTlCcG5HaXJxdm5uS2hTSC8rU0MxZnJwNmNnbmdy?=
 =?utf-8?B?bGFQREltTnJBRTRtUTdEZWUwN1dPUytXSHdIR0g5OHEycm4vWmw3OEpVeEdp?=
 =?utf-8?B?YkxkamNDWTRsalljZm83K2J2a2VYTFNVMFdybkVPMWNYMkVteEdWL0c1TWVC?=
 =?utf-8?B?NDVmR1RZc2NmTDNub05mSXN2OVVpWFJXWFIvM1E3SVR5a2NXclFsbW12dlc0?=
 =?utf-8?B?Unpzdnhjc25TTVF6R0VkVkN3WnhsTzI2clJSc0hBa3RQa2psaSs4SWw4RXlG?=
 =?utf-8?B?NkhaN0cwRHpDZUYwQVErWitHa1gvdksvMEdML0tQZmdKMXI4UG5VWndTemZI?=
 =?utf-8?B?TlEvVnl0OWg3eGhTMFlYRE5iN2tnMjRxVVdleER6QXVIdHJDemlFcXoyaUhm?=
 =?utf-8?B?QU5EVlFPNlp3bjMvNndmSWtIbTdSaFF6aEoyTE5UeS9xSk02S3dSV1d4QXBq?=
 =?utf-8?B?YjFKbWc3b056MG92MTI1Tm90MS8zMnloZDJ5c3p1STJoVDhCN254ZDVrcmNR?=
 =?utf-8?B?YkVySkc2SzJhU1p0MjNWa1B2Z21pZFhRMERvM2YwZElCdlJWTklOUlp6WnFo?=
 =?utf-8?B?UmVtRUFUWTBkUEZuaFNTL1JCMjAxRFFLdmJEZHNzUGtZdHJaUHkzRmxqeUJN?=
 =?utf-8?B?R05mMlh2dVdDcGRrMVVTa1VxN2tKaEkxMmxIWDAzc2ZpMWUydW9oa2RzeXBl?=
 =?utf-8?B?T0N0eXVIeUZkaXFGRHlNNzNITVJ0bjRsZ1FLSGRUajUwaUJENzRRVG9CVjNI?=
 =?utf-8?B?YW1OWWVmU2VURUNYcEh1M3ZCOXpvNDZTQy9oNkhraWthTFRoM05wQ0pRPT0=?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ2PR11MB7573.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(921011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aFBnNVFBcHhOT1FoSWdZdUNDOXFpR0o2VDltcEwrRms5MUJqMjJ0ZzRFTU1p?=
 =?utf-8?B?WDd6aytIMlNwU0Z1cGxWcE5RaytCM1dhU09aWStqN3pQTEtGZ0ZiejVoT2I2?=
 =?utf-8?B?VlNYbDdPRVNvdUlJNFYzN1A4Tm43T1RVTWtWd1Z5bHZveUxvd01lOHJvQmxY?=
 =?utf-8?B?OXpzL3ZodStoNi84bEJ5djZKSExwSFRBei9OZmsxY3ZndHl6UjVVd3BqcDJs?=
 =?utf-8?B?U3haUXBsMnFBTE84ak95MXNrRkZkWXhMZmRGR1YwTEp1dlB4QTJ3TmQ4cUZT?=
 =?utf-8?B?L3JDUFdzb3l2OHJTaVpCRGJvRlhOQmhFanlNSzZQQSs3d0N2ZGlEZUFpUFVE?=
 =?utf-8?B?TWY5eVdOaWZUbnREaXVpb2JUVlNiWERieFRZUG1KRVc2bXpzZUdLOWhRaWQw?=
 =?utf-8?B?L1NVdkJzVVFUVTkydGN1YTVYWXR0Ymh6cnRhdmIwSFIydDU4cVZEbTEyNlZI?=
 =?utf-8?B?MFEwbG9BNzlHTGVjaE8wMC9JL2RTTjRKS3F4U1NnbnJrMXdqWFdvVm45SzNu?=
 =?utf-8?B?VmtsZ0dzaFVOcGN3RkEwUlorWUtWVGFKQmpYUHg2a1FjOXQxdlYxQnV0Q2xv?=
 =?utf-8?B?eEw5bXNleUVpeEN4N3NmZGRZWGtaUWE0NnV6K0dkQVp3VmNrbHNQeTUyZ2tC?=
 =?utf-8?B?QVIyM0V1QlcvWnp4K0tRb0VuTTJOVXhGZ3JJZ01jSGQ0eEllWkdRbXY1N2lt?=
 =?utf-8?B?Z1duMVE2bmJHUy9DeUExQmRsTDV0OWUycmdFcDE3U0hOUTRnajFaWStSUzBh?=
 =?utf-8?B?bW54QkRGM1pTYWY3QnFIVXM4eEtqKzVscGNJK3ZScVh4dWJOWStCT2loSU9D?=
 =?utf-8?B?THhxTkNxd3NWODErZFhFVW1RSVF5S295QUNHVFdtZG10ZGZ4bkU1SUdITGxt?=
 =?utf-8?B?MzVLemRnVUxUd09PQVJWNHBERXZBc0Y3NWlHaDBMc3dYbDAvcWlnVVBrd0RQ?=
 =?utf-8?B?TVp5aWMrRTg3Y3BGaGRSdEREV2dlZTJ4eXBOd1ZRbVhLZjBCeTJiMUwvOGV0?=
 =?utf-8?B?dGZiajlTQmdWdDRyTmYreUR1RUNsUXZ4ZUYxUS92a3M5Y29sai96NFZ2OHlW?=
 =?utf-8?B?U1dCeEJRbEh2dUVlODE4T1V2bEZNZStIUVZGTmMxaVF2QUpiK0JvWThjdkhI?=
 =?utf-8?B?dHBIeUNyYXU0R3AzVTBVVnQyQS9veEUzZ2ovQ2x1MTdPUEVFVCtMVWlOMjZa?=
 =?utf-8?B?VW5OZ2xNZkZ0Y2NsWW1ZcHNzQ1JVMjNlazgvZFl0Tmw1VjJzR3h5Yk56TlBs?=
 =?utf-8?B?bkpGL3BhVTloNnZtRjFodGlkSGE5ZnpTMEJLNDB3dUw3YjBFYlpyNllaS2FO?=
 =?utf-8?B?TVJ4dFI5eVhzWWRaT0FObEpwcEFGSVN3bU44Q08xdUd4RnNQUkxkWHI3MzI0?=
 =?utf-8?B?Zk5XQzNCU1hQSXIrWFhpNEhkU3l2YnhTM2Q1WDZxcCtSUnhUMzg3eFFuNXhM?=
 =?utf-8?B?Y0tpaTlNSUhOMmJ6UHdmeEJYUWRmeUE3Ym1XZVBQYVJJc2VEU2FVdFN4OG1j?=
 =?utf-8?B?RFdHNDRwdHhabjQ1Y1JWOUZLaWRQNEMvdFMvZ2x6RHdSaFBHcCt1UEJRZ2N5?=
 =?utf-8?B?QVhueU5FbVBhMEx6cGI1SXFTYTcxR1RaVlAxTWhTQkZaNnJHcy81UFpFSmkv?=
 =?utf-8?B?Y2lSTzVBVTFtRlgzS0x4Z3Z0WUY5MSs1UmF0Y3doZ2QzQ0pqTnUwaDRHRlRD?=
 =?utf-8?B?N3cwV1V5ZFViZTdLSElXc1A0ZGVTcTdBcVFXVXlPS3c2Uk9KaDhiOGlwZmQx?=
 =?utf-8?B?NGdqb3gvQlRlZVhlL2RoSjRIUDJDM2E4eTlOTG9GcjJuVEpZV0ZQNTlHdGtT?=
 =?utf-8?B?YkgwYjdTa2hoK1NORjhVODFHWFdMOTg3WDNEODZvMVQrRFdCYVdMMFE1Q1ZS?=
 =?utf-8?B?RmxVRDdydVB2eDhxd01LSy8ydVdPTmVyVHN2OTlvOVhTY3hpc0hSMFovK0ti?=
 =?utf-8?B?aC90blNiS1JHQUMvZUdvd1ZmSG8wTHR0amVhQkVJSUVxTmgxcWdTY0NQbGk2?=
 =?utf-8?B?bVZJUy8rWnk3ZGEyS2ZocnYxd21GZHZaQVpyeGV6bEx1dUw1QnduZ1pZQ1JV?=
 =?utf-8?B?RXhkRGRDMGJnRExxUnNxY1BUNnQ3cVFoVTdUUk14VFIrVDViRlBtZGU2Y3Rr?=
 =?utf-8?B?TDVFRXM5VGl4MVczVlN1eVJSZFV6V3dFdDhISTlFajZWT2s2YkhHQ2MwVWRT?=
 =?utf-8?B?cGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 147d5b48-ec7e-409f-b0fc-08dc78e42943
X-MS-Exchange-CrossTenant-AuthSource: SJ2PR11MB7573.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2024 15:47:32.1195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WEpzxbjeMO8O2rRiRZCkFIXA6I+2dqNJCZ6TDsaq/xOEQ03AA20Ry6Z+dShtgp4s9oEIiRYg2gh8BBeeWuSkBFAL0isC/ddqCF/ezFk42+4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7655
X-OriginatorOrg: intel.com



On 5/6/2024 11:35 AM, Reinette Chatre wrote:

...

> diff --git a/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> new file mode 100644
> index 000000000000..56eb686144c6
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/x86_64/apic_bus_clock_test.c
> @@ -0,0 +1,166 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Test configure of APIC bus frequency.
> + *
> + * Copyright (c) 2024 Intel Corporation
> + *
> + * To verify if the APIC bus frequency can be configured this, test starts
> + * by setting the TSC frequency in KVM, and then:
> + * For every APIC timer frequency supported:
> + * * In the guest:
> + * * * Start the APIC timer by programming the APIC TMICT (initial count
> + *       register) to the largest value possible to guarantee that it will
> + *       not expire during the test,
> + * * * Wait for a known duration based on previously set TSC frequency,
> + * * * Stop the timer and read the APIC TMCCT (current count) register to
> + *       determine the count at that time (TMCCT is loaded from TMICT when
> + *       TMICT is programmed and then starts counting down).
> + * * In the host:
> + * * * Determine if the APIC counts close to configured APIC bus frequency
> + *     while taking into account how the APIC timer frequency was modified
> + *     using the APIC TDCR (divide configuration register).
> + */
> +#define _GNU_SOURCE /* for program_invocation_short_name */

As reported in [1] this #define is no longer needed after commit 730cfa45b5f4
("KVM: selftests: Define _GNU_SOURCE for all selftests code"). This will be
fixed in next version of this series.

Reinette

[1] https://lore.kernel.org/oe-kbuild/202405181535.WFKy4EwQ-lkp@intel.com/

