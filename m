Return-Path: <kvm+bounces-49334-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 87989AD7F00
	for <lists+kvm@lfdr.de>; Fri, 13 Jun 2025 01:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 53DAA18981BA
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 23:39:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18692E1743;
	Thu, 12 Jun 2025 23:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Apl64pv/"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213EB2E1734;
	Thu, 12 Jun 2025 23:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749771545; cv=fail; b=QJhw5dvorASeu9n5pPVQMkXIyM2ynZUznZE86NFsBowSmIoFi9jcOEKu6KiK05xejQGLc1Qx+OapKd7PnJnwKWbNn/41t7xHwO0idRoDCZGIti1OxdjR6Xont3JkuwZ5BsKuPaIEmIIpWMpiuDUxdNjDHj8i/eLJzql8TO46u10=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749771545; c=relaxed/simple;
	bh=gUrhJi+DhBEDLP0z61zNx3hi7OVx5TLs66hkAhI8nN4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=g+u3hhMVJkk6kKQkoKTnoLgiktHb71Y2ueia7jRyoLwqUlOf5LoNmBVR3jx1PlZ+KKjZOJSMD3X82ptUsysAZQw4mi9wF4dLVY+V6mBZTcOsYNBkdlZNsQ93AbiTSXlJ0ATE6Mia9F6ublRYTlqr3KL5IVa9b/iO2bd/4xnrjpI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Apl64pv/; arc=fail smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749771544; x=1781307544;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=gUrhJi+DhBEDLP0z61zNx3hi7OVx5TLs66hkAhI8nN4=;
  b=Apl64pv/1arbjNKZhK+1bFN8kg0t1ubhINnjutNNQwoGZEbDo8ChrZKt
   EzqPPN4f6S5EeVesfP2H+BLGXuT8dNACsTO2ywHdkbUfHflVPkX+Qt2YE
   ss8Fubp9FvP8MQobZpyyUWn6MZucAkHHxZu++4Q2gyhBttJPZReqWWWg5
   FVGmMPEQJAHFvG4CQHATTh7k2rklI6GfFKeNYSD4be2D38Jh/e0tfIUzr
   A0ikaXKj+SHi/BzA6uULa3NIetdebdNXf7dPgFtWOgQXqqVT/5xnSBIEc
   7/T5IyIO9HSfzdWmCChlNRkQtYjW19EBgHSA6K8/r1Cut6incrPvA2AbU
   Q==;
X-CSE-ConnectionGUID: h1gLxMpZS4yGKCUUuEuLIQ==
X-CSE-MsgGUID: o1IMegvkQ3qJS6BHDtryHA==
X-IronPort-AV: E=McAfee;i="6800,10657,11462"; a="69417709"
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="69417709"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 16:39:04 -0700
X-CSE-ConnectionGUID: i4FnbdfRR2Gxo3N4weh/nA==
X-CSE-MsgGUID: I7BH/bDbQQCsa70CkHAPdA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,232,1744095600"; 
   d="scan'208";a="147575927"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa010.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jun 2025 16:39:04 -0700
Received: from ORSMSX903.amr.corp.intel.com (10.22.229.25) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 16:39:02 -0700
Received: from ORSEDG903.ED.cps.intel.com (10.7.248.13) by
 ORSMSX903.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25 via Frontend Transport; Thu, 12 Jun 2025 16:39:02 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (40.107.101.51)
 by edgegateway.intel.com (134.134.137.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.25; Thu, 12 Jun 2025 16:39:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=g3q7N/kBj2/7zY+Emei0L60+TnXQqev5biAI51BQT9E6oZ7TqJOVAOcWqu9U6n26vN3Xaq7I/Dvd+R7XU0tnGwrliPUVhsfX4jHExsC4c/i+wW38CBhnX5xK3PTbWaregKaAKdpHfmLD0POHEmRUGu2dCmVGO+IaqLVrGYuyuHu1DenOjUU2hE7EZ/+XuU9HgG7SNLSEtexhQV5psEEorc+Utry5UP2d0KZalW+wtiPDgAf/R6IqgMzaJctxFoaVBw0Fld045rbQqDAXraS2ADNUNtyOG1GsPctoQcGqxUSTA56tTIrDkqMv5v+XB+BFGH7pZvSFspShtTL9OIk+qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gUrhJi+DhBEDLP0z61zNx3hi7OVx5TLs66hkAhI8nN4=;
 b=l9y6Fv1W7L2R0MdKc2BpwFRzfpGBnFWVyecZYdWXePoZjTWFMt0tXs0yVdBCzzr8K2gfZT2Ph7vPb7miioKMyt8NfI4H2yNtEsCaON+VHTJC9JWV2/Hh6ntZlVdEu0Pl5IdmlT5Mfgzemy8s3YE8fBSVgFqTESLoAKQeb6knJN0pALhQJTiFt0EW3yR5v3j1WVNI+691MaGtRsdmBQmNPxSZ4dJmvdYPNG1wtDs20bvgarbKWlyGBSjbkLUwEbvdBqmQrdctAf79nVVwvuwEDFNWO4YNqjpQdEv9NIJcCx7FNSTZ1bdkAURRwpF+tux9UDbp5ENoJ9pALo3fb6o2qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by DM4PR11MB6503.namprd11.prod.outlook.com (2603:10b6:8:8c::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8813.26; Thu, 12 Jun 2025 23:39:00 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%4]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 23:39:00 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "seanjc@google.com" <seanjc@google.com>, "Huang, Kai"
	<kai.huang@intel.com>
CC: "quic_eberman@quicinc.com" <quic_eberman@quicinc.com>, "Li, Xiaoyao"
	<xiaoyao.li@intel.com>, "Du, Fan" <fan.du@intel.com>, "Hansen, Dave"
	<dave.hansen@intel.com>, "david@redhat.com" <david@redhat.com>,
	"thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "Li, Zhiquan1" <zhiquan1.li@intel.com>, "Shutemov, Kirill"
	<kirill.shutemov@intel.com>, "Zhao, Yan Y" <yan.y.zhao@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Weiny, Ira"
	<ira.weiny@intel.com>, "michael.roth@amd.com" <michael.roth@amd.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "Yamahata, Isaku"
	<isaku.yamahata@intel.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "tabba@google.com" <tabba@google.com>, "Peng, Chao
 P" <chao.p.peng@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "Annapurve, Vishal"
	<vannapurve@google.com>, "jroedel@suse.de" <jroedel@suse.de>, "Miao, Jun"
	<jun.miao@intel.com>, "pgonda@google.com" <pgonda@google.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Topic: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is
 RUNNABLE
Thread-Index: AQHbtMYisXlDVaH8LEKqVl1+c9iQ77PRHICAgAN/mYCAAIg5AIAA1+mAgAPLQICAAIwTAIABF74AgADuIICAIfsagIACKESA
Date: Thu, 12 Jun 2025 23:39:00 +0000
Message-ID: <f001881a152772b623ff9d3bb6ca5b2f72034db9.camel@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
	 <20250424030618.352-1-yan.y.zhao@intel.com>
	 <dc20a7338f615d34966757321a27de10ddcbeae6.camel@intel.com>
	 <c19b4f450d8d079131088a045c0821eeb6fcae52.camel@intel.com>
	 <aCcIrjw9B2h0YjuV@yzhao56-desk.sh.intel.com>
	 <c98cbbd0d2a164df162a3637154cf754130b3a3d.camel@intel.com>
	 <aCrsi1k4y8mGdfv7@yzhao56-desk.sh.intel.com>
	 <f9a2354f8265efb9ed99beb871e471f92adf133f.camel@intel.com>
	 <aCxMtjuvYHk2oWbc@yzhao56-desk.sh.intel.com>
	 <119e40ecb68a55bdf210377d98021683b7bda8e3.camel@intel.com>
	 <aEmVa0YjUIRKvyNy@google.com>
In-Reply-To: <aEmVa0YjUIRKvyNy@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|DM4PR11MB6503:EE_
x-ms-office365-filtering-correlation-id: 7c995839-dd21-4896-77b9-08ddaa0a4ec3
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|366016|7416014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?dnJ5RzV3TGZ3MTh0UDVpeHMzRGN3S0EvWDFNN3VSVEdFb29jY0IrYUtSaDdE?=
 =?utf-8?B?czJUN1c4eklJVjJ2RGgwamZmQzdxMjkvSGp4c1BlUkc5TEFvMUNQYkdjRjc2?=
 =?utf-8?B?RXhIUlJFLzJhZk5CZW4wSy9ZeTk1SDZQWENVWnhENUQ4U0dZRFlXa2x1TEJm?=
 =?utf-8?B?V3gzM2Y2eGprUk8zdFdPTDR5eGMyaW90aGtOZ0RvUE5rS0ZHM0tEY0RORk1M?=
 =?utf-8?B?cEdKTWIrVVkvKzQ1cXViSU9rcTZDTE5pcVpIQzVSV1hjMUx0Qi90K2xXdmFZ?=
 =?utf-8?B?VVVwSVFaazRFTkpEV0MxSXBOMlVlRE5vM0JhNW90Vmg0Q2dCbElTUmhaQVhB?=
 =?utf-8?B?dFdRckdONk9qMWhKKzJjMms5SkNqZ0oveTRVSWdybnBHU1YxR084MHpKZDhu?=
 =?utf-8?B?MjRjOVlhVW9kdkFDYTJ4eENQYlJWQjVpbjNKS1d5bHdWN1kxaEM3eDJsWVZC?=
 =?utf-8?B?M2FOdDFKUlZXU1Z3V2F1eHp6WVRoeHNyeHFTTllYN3lNbGlmSjlHNEpSUU9u?=
 =?utf-8?B?WGNTUXlmUW44WURHTDhMYWUzTzBjSVBnRkt1YjhNR2FvbmF0VWk4cVZ1NFRN?=
 =?utf-8?B?WkRCdWlBRjNXWFZtaExSVVhlNm52L0pWZ1pSU0g0a09kZ0k2NUVTWmVGZGpn?=
 =?utf-8?B?TkI2dUJWLzZTei9Dano2dFNEVjJmSHJpdDVOM0ZZdlhIYXVqdEtQSFVLZ05R?=
 =?utf-8?B?N01ZMjN0S1RNR1dtalRPN1VMMnZOSmUzYXZBR0hjVmRSTm84bUZnUHJaT3Ba?=
 =?utf-8?B?SHh5NGpOOENnSDU4Qk5wY3U5RFB6aEd1MFM2RTJVNlZlUnVpaW50dG1zQVQz?=
 =?utf-8?B?QXI0KzY3UTNqSDJmS3dtb1Fsb05DYmZJUGJxMmtUSzlNU3ZSbzhVMTZtVUtV?=
 =?utf-8?B?TmgyaUNKbGQzVCtzNG51cnAxQi92NHlHWlQxYzA2MjZmU3NxeVZlUlVvK25Y?=
 =?utf-8?B?N084S0FVMWROTW9CaXQyMUtHRzJ0Q3I0eWw3QllhcGttVVZSb0cyQ1ZXWm1p?=
 =?utf-8?B?S0thMjJER1JGbWkwRWg5YnlDRW1xSUgzeUkzaWlGMFhRbGVJbHpCazNlQ2N1?=
 =?utf-8?B?SUd4N1RMNnkyKzdoQklua3BKNnI1N3BPV1VBVDA4TmRBNmcxMnhXSWhjazV0?=
 =?utf-8?B?TXZ3UzJSYnZvaC9adnpTZVkvNG1uREU2VENDeFBEVTlKUkhBRVM1TENhdUFh?=
 =?utf-8?B?Y0ZYcGRRek16ZHFCSjFJT3NpZWZoWDNlQnRnaXphWnU1Z0FGNjg0WVFiemR6?=
 =?utf-8?B?d1QvMXkzamJVMlpmaXFmV0FkWkNxdDlVaTVrWUpKRjVyQzRSdi9IbHNuQTZT?=
 =?utf-8?B?SDZraVZVSmN0WlYxN2dOVDhSaDQ4RURmcGNtQTNMOEVZZ3lmSEIxZXN5Unlm?=
 =?utf-8?B?OUYxT0RjUTA1ZC92R0IzdThkVWZXZzdyMkpJa0diczRINlZrNmVVYlVURzli?=
 =?utf-8?B?bHA0ZzdiUVZJa3U2R1Q4cFlnaWdTOCtPQ0JxdVNQd3gzVGQ1aktKZW5TdFli?=
 =?utf-8?B?TjBjeWw5TitYVDN0Q2pYYnMvK2EzYk5iREU5NEVnYUFHWGJoR1Z4enlRdks1?=
 =?utf-8?B?UjRaVGhlSDJSRjJXdmx5TmdVTmE1K1ZMeTRUcjlYbEFoN3hhWExVaUVuYTFJ?=
 =?utf-8?B?WXdqcVFXZVpnQTRERStNNk1USjkyZ3ZyTWlhMExMc0xtTDJXUlJYRFNMbXM0?=
 =?utf-8?B?ajRUU1A0RXpNVEcrbzZKRDV4VzQ5RURsWEpkSU83RWJ5WUI5Z0E1OW1iRTY1?=
 =?utf-8?B?ZUtXU1gxbllJdmRKcS8xZk9RMGRpRGgzVFB6TUtpYlhmcnladzVnL3plODlX?=
 =?utf-8?B?S2ZtelNsVllkMWtqSFppTEJGQ0o3YnlyQlVLOWdBVHhCRHVkUzZua1IvN2J0?=
 =?utf-8?B?RThLZ2hLdDlIbUJrdG5MOTlGTThvTXRHZmxhTjRIQnhqZmtWYXk3QjcwWXh2?=
 =?utf-8?B?SG5RNmZQT1BUdnJzaFB2dm5VNGhzNzlreTRvVXJ6ZlpuWWFkR1F0NldMQVBu?=
 =?utf-8?B?U053eC9rS3J3PT0=?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(7416014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VERRVUE4NUlpU1I2YjJCQnMveWpqSENKTUJNbjR1MmJTbnFhNUxyNmtSeThP?=
 =?utf-8?B?NitrVitBYkcwZ1Z3amxCdVhhMkNtSnhiWHdiUWtUbElwVFFYWlJoT0hWYU0z?=
 =?utf-8?B?ckxXbFhWL04vWDNkZ25Mb3gwQ1hrWjNqWmtScVZIdzd5bXRKc1Fnalk3WTE5?=
 =?utf-8?B?ZTlYOHhEOE03ajNuSENlZDg3eStYK2VMVnNQUjdSMkZpaWN1SEtuZ3hYejVX?=
 =?utf-8?B?T3NOeHEzVkVDMHcyS09wdGxCYzFNalZROVJ1Z2o1K09PQkxET2R5U1VRc0pQ?=
 =?utf-8?B?cTk5YUJ5UG5qNU9lTGlVOGdVbER0QW5qUXQ2ZG8xVkJPR0lSVEtOM1FUTXdJ?=
 =?utf-8?B?ZGNDZGdidE5lS2FucnZ5dk1lNlpNZXNPbm84b3hRSkFtUmZuUThTbGtublpE?=
 =?utf-8?B?blFuV2poN29XUmxxMVpUMHJGKzlhbHJ2RnI0a3o0Y1BjbFFSVmowZTRGMGxu?=
 =?utf-8?B?NkpHelFPU1RKbm05MmZ4RTROak5jM1lHNzRxWmsxUXh5enhFQ1VUMThKR2NL?=
 =?utf-8?B?VHd1SW9NQ0xvYklReVFhbjY1NTc3d1RjN2xkdktDc3Bzb1ZuUGp1akpRK05s?=
 =?utf-8?B?RmVHcThzRUVsUVhQclFBRHdRMjl2QVN4NnI3d2pKYVQzYjNyTnpESE9KSTcz?=
 =?utf-8?B?OUYwaTZYdUZXTW95TFgrd0N3L2Exd2VoK3V1YTlNOGlBdFIrRmZIUWtvdHh4?=
 =?utf-8?B?TFFwL1ZFMTF3cGtjeVViYWI4UWhlakxjL2JBZExldndNdkNDVXd0K2tzanU3?=
 =?utf-8?B?RFFQQldRRCsyQkxLbjBhYVNmQzNyc3A0RnhyTGQwWjNyeXlyZTczdVZtUHNh?=
 =?utf-8?B?Qkh2c3VLTUtTNEp3ZTdkODZIazh2WTdMeHBqdGJMYWNPemdWUWlPZDlVQ2Va?=
 =?utf-8?B?OHZaWlpRQmFUYVRPNlRqbVJsamdoME0zanVZN0E1VmpvMm9sYkxGL2p1SG1U?=
 =?utf-8?B?dTFVaDFYcjBIQ0ZPUU5ha2pXRWtqN3pXbFUza1J6Ky8xd2VNMVd1ejhzRlo3?=
 =?utf-8?B?N3FLUkhJdEhTejF6cUpWK0s2TFltTWllNjZyMHYraURUOWNrQXFhdzVQcDN2?=
 =?utf-8?B?ZHFzVFplRmpnM3Q0d09sSTl6K2t4YjJ4WlBKOXZXU1hHUVBsSHJncFR0aXYv?=
 =?utf-8?B?c290eStoR1FBVTlrb1ZVOWR6SUJzc1JEalRBcFU3amZncTRCL2xSejRTNGtL?=
 =?utf-8?B?WnlBY2RsWmxZK3NxaFhRV3VONllqL3huS0Rhc3Q3ZHBXTCtZU2k0ZkNleXFS?=
 =?utf-8?B?eFJIaW1Zckg5YnpTREZKekpjeFVyWXpWU3o5eThkNWRYcW1xbUZmNDYzbTNk?=
 =?utf-8?B?bGlvUFFOUGZ2WkNFUXZKZ0FQM2ZRRUlSc0VVS0NRZWVESkJnL3hIOHVOOGo2?=
 =?utf-8?B?aDFkQWNWazJiNnVqUDJZdnlZM3NvMmMwWUkvTjRNNnBlTXlYdXNGSUEyYkdU?=
 =?utf-8?B?U21hc1dHakpNd1hyMFVMM1dJOTlUZnBXQXBURlU2cXZLaTl6eWwrUFR3NnRm?=
 =?utf-8?B?UDVkb2NEZGdhc0M0Y1EwNS9iSnd5cTZVWEhDVHhXN2ExYnp4ZjZwekwyVGdW?=
 =?utf-8?B?Q2xvZXJyNUxQbm5rTmNmSUVNTXYzVFRKODFVMURNOXZSZk92azVBWDFSQkow?=
 =?utf-8?B?SnBrczZKNzB0dUdnRFVUNmdzaGw2by9haGN4dG1maFgzL09nbEJFTk9iS2Zt?=
 =?utf-8?B?WkxMUkJCbHVMQ0ZxQmVQelZ0bEVsNTF3cmdMT3A1TVpWa3V1NVNkYlpIYnoy?=
 =?utf-8?B?U2t1amZJNTd5RE1pUnV3bWlRQUxwdFJ5NmpsY1VYK3pQYTEvenkzM0pxTzhv?=
 =?utf-8?B?WWptaG05d2FYZFRpR2NEaG4zRGJkbzdLQzNsQUhVRE1LTDJqVEVuZWRLRFRL?=
 =?utf-8?B?Q0pXQW5OUHBMYytGZHBtdFMvd3FIcU5mOWpxdkwvQmowZVgrdlFsUUpkS1kw?=
 =?utf-8?B?bnRIOEhxVEtGUk16UVV0NW84cHFteUJham1MRFo5N2x1cDdaQ1cwbTYzeUlj?=
 =?utf-8?B?WDZ0SytKbW5ONEJUOXlxQkU4TXArdEhhd25EMVdmeklVNEZkQUU3ZXZmUFhX?=
 =?utf-8?B?U0JwUWtYMTNGZGY4dkpnWUxkZzhqekJ0Z0tYQWZjNGI2VjVVRFMyOEpYTGZ0?=
 =?utf-8?B?MGtPaWhmVEl1WjZFNS9NWFZzUzdWY090WXJOQWF1dUZtS3I4Y2hSRklJcTRS?=
 =?utf-8?Q?suhB3VdfPXB1JQfbiLhOv68=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0321ED80D1C9C44BA3BB223E14D41C86@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c995839-dd21-4896-77b9-08ddaa0a4ec3
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jun 2025 23:39:00.4240
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XAH8P2mR0FR+SExlSdroZ2Q7rBhpKaY6QQ498s4hneGpKkQRv0f0MvRBg/zAP0cdWg4fvxFlxNrmtyBK00PkVVh/YdpuRrwJUe3RJN+f3CE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6503
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTA2LTExIGF0IDA3OjQyIC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBJZiB0aGVyZSdzIGEgKmxlZ2l0aW1hdGUqIHVzZSBjYXNlIHdoZXJlIHRoZSBndWVz
dCB3YW50cyB0byBBQ0NFUFQgYSBzdWJzZXQgb2YNCj4gbWVtb3J5LCB0aGVuIHRoZXJlIHNob3Vs
ZCBiZSBhbiBleHBsaWNpdCBURENBTEwgdG8gcmVxdWVzdCB0aGF0IHRoZSB1bndhbnRlZA0KPiBy
ZWdpb25zIG9mIG1lbW9yeSBiZSB1bm1hcHBlZC7CoCBTbXVzaGluZyBldmVyeXRoaW5nIGludG8g
aW1wbGljaXQgYmVoYXZpb3IgaGFzDQo+IG9idmlvdWxzeSBjcmVhdGVkIGEgZ2lhbnQgbWVzcy4N
Cg0KSGksIHN0aWxsIGRpZ2dpbmcgb24gaWYgdGhlcmUgaXMgYW55IHBvc3NpYmxlIHVzZS4NCg0K
SSB0aGluayB0aGlzIG1heSBuZWVkIGEgZ3Vlc3Qgb3B0LWluLCBzbyB0aGUgZ3Vlc3QgY2FuIHNh
eSBpdCBjYW4gaGFuZGxlIGVycm9ycw0KZm9yIGJvdGggc21hbGxlciBhbmQgbGFyZ2VyIHBhZ2Ug
c2l6ZSBtYXRjaGVzLiBTbyBpdCBtYXkgbm90IG1hdHRlciBpZiB0aGVyZSBpcw0KYSByYXJlIHVz
YWdlIG9yIG5vdC4gSWYgS1ZNIGZpbmRzIHRoZSBndWVzdCBvcHRzLWluIChob3cgdG8gZG8gdGhh
dCBUQkQpLCBpdCBjYW4NCnN0YXJ0IG1hcHBpbmcgYXQgdGhlIGhvc3QgbGV2ZWwuIElmIEtWTSBk
b2Vzbid0IHNlZSB0aGUgb3B0LWluLCB0aGUgZ3Vlc3QgZ2V0cw0KNGsgcGFnZXMuDQo=

