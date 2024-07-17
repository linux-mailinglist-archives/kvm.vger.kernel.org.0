Return-Path: <kvm+bounces-21779-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 88868933F28
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 17:03:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A9B071C21B82
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 15:03:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6226181B9B;
	Wed, 17 Jul 2024 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="DgLYGXB0"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA22180A9C;
	Wed, 17 Jul 2024 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721228593; cv=fail; b=GaN6EtPdw1SRpaRZsOpBva1R9GxHPVnMnps9LrqwuIWwjf6mzCAOwQAXgyiGdyeJwK1r/rLrlvhft6bFN10ipDPwxT0s4FQpWJaOKtXvEf7ZOsdhzyAKnZgzBdriHfPMSaVAJhGYwDl9AjC36S6JjqGVCrI5LnY1e2WDl8vQpOE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721228593; c=relaxed/simple;
	bh=ud/mi5eyDv8s+6IcXieO8VaqkgMd1miV0fSbQjCoER0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nM7RfRy1U7nR/MVLvP1+FSE6kntbPzx+B6qKuQ2RvEScRSN/IBMUtMZ7VpjYEl9AMvGuJo0VgWMh9beUu4tmMzMgM0w9Csk89qybQa3xUYIhcmEMwz13xNBF/7JAERysKYoDQwFZOeYadQ3fGvQ63wGPWFALwRGD3Tug7OdxhuY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=DgLYGXB0; arc=fail smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721228591; x=1752764591;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ud/mi5eyDv8s+6IcXieO8VaqkgMd1miV0fSbQjCoER0=;
  b=DgLYGXB02Oc+5X/zdcKA1TJgWSt6CNmLzL1BbocSBGEo98EJ6JqpxCkB
   svkl02yR6s0O90dU/8juy2uL/GFGGrjH15K5Hdw7PAeUYPEfIOKJPY+JN
   R36jhTLadOxZPgr+Ane1UbEpW/SrX3Wj7ZwTqxaMSnC9hVP/vQAvDBcO4
   O2I4XhPEHEHW0mOhvOKPP2Pdk0xCgHIINSzk3v5c4hG4/UboWkazF8beo
   Idv2wfHqj8cD2hhzf3QKpaJ+2BDSZoO4PELoI5cnllYKAdt4niz/8H3cH
   Wm+KgPQkVcPIKIevaS3Vn55u0bkWfN0ul6Hs1p2k/bAER6sN3OJUwJQG3
   Q==;
X-CSE-ConnectionGUID: mBmMjaW7SGCeYrnQhYPlow==
X-CSE-MsgGUID: 5DZ+muvhSAODyqCdNc1Xgg==
X-IronPort-AV: E=McAfee;i="6700,10204,11136"; a="30151268"
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="30151268"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2024 08:03:09 -0700
X-CSE-ConnectionGUID: 8bzBq7OVQGma//SktxO0vA==
X-CSE-MsgGUID: UB29JxCBRWqlRXnBtyfKVg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,214,1716274800"; 
   d="scan'208";a="50157407"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmviesa006.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 17 Jul 2024 08:03:09 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 08:03:09 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Wed, 17 Jul 2024 08:03:08 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Wed, 17 Jul 2024 08:03:08 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Wed, 17 Jul 2024 08:03:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XyCyGSWey8FCXptlVwvJMPcSeojz2y1YgiqXMwXtpXhffPEDW1LBJ279Y8EbyGMOaYcFFJaV9k8ZeoewT31Tl3d9Htyu913clrG9sjjoNmQjD4bXwZpZpl7uX7juPOo40LWW7aDM4t4kLqvpwDayrSDTyYqhaVvWhbFngA12XpBc2axzqRu2B15LPKsmdM4qoTrvgOPhtNOtzENS2j4WgpycWRh/GhCJnfDCLeEZcF3OzM8neOhbQaJwDjevKgKqj2fv5jXEV+2KGQA2Myzk8Pt6qg6m2U21KHtEn4dOqLhkTM1cbEvQwd9RYKad3jumROAaibRda3CDx5eIpGSt2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ud/mi5eyDv8s+6IcXieO8VaqkgMd1miV0fSbQjCoER0=;
 b=xKUWFZ5kJpn63vFAiD7rOuE3qm6F8b/T3BYAhG882wrZc/0NqZb3UIOTxulXQaXjT1qbsAu0xkEc+mVp9t1OAnvJLS1Y8EqlZQNy3WmjgYTYQjlOeEpSzO53hv30naeaVvlGjIb2yL48iYJYDNht9jEb29jnPtKPrYAx/dvXY0xncdvg3Mto1HFgFLuYUM3/1OIg9cPONpvUZzMvcnDvUqWAnQ/kGoSgJL1UYsJB9zwyHpv3afIPvHjTzUdXuZ8MUSROJlYa7yyL71wxOxf2Yj/HPkhXMnDEOMwlY1LYghapNeX3+FhxMs5CJl29ya7imflKzdWPK4JC2/9TVfjhjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DS0PR11MB6373.namprd11.prod.outlook.com (2603:10b6:8:cb::20) by
 LV3PR11MB8508.namprd11.prod.outlook.com (2603:10b6:408:1b4::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.7784.17; Wed, 17 Jul 2024 15:03:04 +0000
Received: from DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e]) by DS0PR11MB6373.namprd11.prod.outlook.com
 ([fe80::2dd5:1312:cd85:e1e%3]) with mapi id 15.20.7762.027; Wed, 17 Jul 2024
 15:03:04 +0000
From: "Wang, Wei W" <wei.w.wang@intel.com>
To: James Houghton <jthoughton@google.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
	"Oliver Upton" <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
	"Suzuki K Poulose" <suzuki.poulose@arm.com>, Zenghui Yu
	<yuzenghui@huawei.com>, "Sean Christopherson" <seanjc@google.com>, Shuah Khan
	<shuah@kernel.org>, "Axel Rasmussen" <axelrasmussen@google.com>, David
 Matlack <dmatlack@google.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, Peter Xu <peterx@redhat.com>
Subject: RE: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
Thread-Topic: [RFC PATCH 00/18] KVM: Post-copy live migration for guest_memfd
Thread-Index: AQHa0yLrMREFiNTQzkGMfF5XFxrB97H3dEtwgAIrioCAAIlR8A==
Date: Wed, 17 Jul 2024 15:03:04 +0000
Message-ID: <DS0PR11MB63735DAF7F168405D120A5C6DCA32@DS0PR11MB6373.namprd11.prod.outlook.com>
References: <20240710234222.2333120-1-jthoughton@google.com>
 <DS0PR11MB637397059B5DAE2AA7B819BCDCA12@DS0PR11MB6373.namprd11.prod.outlook.com>
 <CADrL8HUv+RvazbOyx+NJ1oNd8FdMGd_T61Kjtia1cqJsN=WiOA@mail.gmail.com>
In-Reply-To: <CADrL8HUv+RvazbOyx+NJ1oNd8FdMGd_T61Kjtia1cqJsN=WiOA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DS0PR11MB6373:EE_|LV3PR11MB8508:EE_
x-ms-office365-filtering-correlation-id: 50c65047-0c77-4161-2afa-08dca6718f34
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?RnpvUHF1K2xIZHJSdkpuSmJIaVdJelVac3N2Zzd1ZUF3R1JJS0t2SEkydDVK?=
 =?utf-8?B?Z0M3RENOZ0YrTUN5WEpJY1hvY29YdGtuaDVYOFJ1KzAyMXRqVkl4ejFJcWRP?=
 =?utf-8?B?RVIyNHFhWlhQTjRqYUs4cHdJdzN1YjQ5Qjg5ZjlwaUZKRGFpTlZYUXo2NXlB?=
 =?utf-8?B?SzhqSG9qUStRNGZ1NEdaVWxXNjRqRUVDRlNwTG1DZ2phaVJaS1pUc3hJbmhL?=
 =?utf-8?B?ZXRFSXdweTRrcVJPTEdlWE9GSjVTUkhtOXpRZEh6UG5GWm9RU28wZUJPYmxS?=
 =?utf-8?B?QTl4UGZpcVZRanNqZU9Kd2lycEhlNGVFeVhSY09WcFM1WDZsNHpoSEtpb1hr?=
 =?utf-8?B?ckR0MG1scllyV3JZWnlOVWlaRHZvMW05NWxNQkVBZkc4Mm43S1BVMHJxRDFs?=
 =?utf-8?B?Z2VBTDZxVE5SVVZBeUpNMVhNMk12Z1NZWDlVSTF3Wkp0OUNSMFh5RDFZNFZZ?=
 =?utf-8?B?VEdkY1orLzI3RlNnaGtxZ3lTcmpMOHlKRHI4enUvTk54c281RWFXTDIvczNU?=
 =?utf-8?B?STg0NXZYbnoySWlGS2R3TDRicUdHV3VremNkZkV4aUNJdFg4ZEZONnN2d1NH?=
 =?utf-8?B?SG5PbldwdnBNWHh6WFQwNUY0eUxkQzVJbHQ1T2ZVdXJPZ2xCVUR0eEJrN3dr?=
 =?utf-8?B?dlRoYXAwaFN4aFBRM0FFSjBKRnNIa2Rpc0pHdUFJOGlyL2ZYRStwODFhYjhO?=
 =?utf-8?B?cDd5d0ZWbkI5RytiejExRTVpcjVIZEhERmYxVjd5L25HRnlaRlQ5U25PaDZt?=
 =?utf-8?B?YXkrS2ZMdkhibkpDU2pwZS9RTi9scTRIU3dnSzdrRU5ybXRVWXhhM0YxODRH?=
 =?utf-8?B?MDVNeEx5KytUSElHYXQyQXUzQ3pKWnNadWIxOXJpdlZNaTZrdWluNXNWTkNz?=
 =?utf-8?B?Qjk1Z3lsSkNnQ1Bzb0s5NzZSUVlvRHFkNmFSQjFBUDVhSDlpa1V0b0pJaEtL?=
 =?utf-8?B?OWM4RE9sN1pmRnZKQ2JucFVJUlZlbDdjNDZJSkRDZGt2SWpHVHpzdXhyMWVj?=
 =?utf-8?B?WXhDZ0pyWWlldmpSUlpRQ0RsM0FDL2hjK3hNUHF5czRwc0dhY01mS2RFN3Yy?=
 =?utf-8?B?WXIwSUFZSi9WUXFLTXpuRzNGN1FzUkRSd093ckdaTWhjY1owcVFJUGRSME9k?=
 =?utf-8?B?K3YrQ0N3YUF2TGI0ZlBOR1dVeTg1L2lkRzZKZXR3cnNWMUQ5SWhKWjlHUW9Z?=
 =?utf-8?B?M0ltUmdNMHNwbFJST3dJRkZTdXcrQ0J3SkRwOXhZWUppSnlHeFhRa05oREdL?=
 =?utf-8?B?QTdxT3BYVVZmMU9VQmhBWEtuYmkyN1p1ZGc2TUZ5NDF1ZkQxYjBoUHNVb01R?=
 =?utf-8?B?em93YVhkOXJ5V3REaDcxYjZhaHMzWVhXUTRwNXowdStxWTZtcXdybVFrQkJj?=
 =?utf-8?B?c0JLcEdMR3BxSDJjTG5tL3QramY1c0dkdjNvK25zRjNXTy9Xd094aGxxQjkz?=
 =?utf-8?B?ODVsSVJ6WHBoem92LzZxMlJKVGdTV2FNSUY5NlY3Y3FsRHIwZ1gxUEVObHVC?=
 =?utf-8?B?ZENYNFl4bHNjM1NUMVM0QW9pbmk5QmZlNGZKMmVOZklSRTlvZWNybUJpRjhT?=
 =?utf-8?B?MTVOQklQTm1OSTE4ZHBGWDgxYmRjOFBRbkh6UGtwWW1YV2NoYVgzejEzOWRQ?=
 =?utf-8?B?dUFaRTEyTWlESzIvUWZyalREdTN2dEpaNVhoL3NhNC9JQ0RzM0h3VXdQSC9q?=
 =?utf-8?B?UE1WTXU0SnlXT3cxSE5ETno4bTI4OWlWOUlkdDhJZnNOeXR2TVJIeklnclRn?=
 =?utf-8?B?SUdrQVV1MnNWMERWTlpLbG1GbThuWUlEN0FxZlhNVFFyRVV1am96SDdzb25j?=
 =?utf-8?B?Uk5nNVFEVEhBSHFRUCtKK0pWMTU3dXdIMnY4ZXE0b3dObzJmcDBHZ09LLzhG?=
 =?utf-8?B?S1pHNW1XVFR3Y0xGZ2dCMUpMa3A4Q09OWmJMN3ZVN1N4eWc9PQ==?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR11MB6373.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?b2trc3IxYnJPUHJnL3NNRGlWbHB2WlpkTndhWHJueUozcEpmbUdyUTdsaVhv?=
 =?utf-8?B?azg4QjBxNHF5bHB2TFhQNGRpQWxLVUJJZkV4RlRpbnVsRzU3VFh2VzJWMDJk?=
 =?utf-8?B?ZkFPQ3ZrbXROcElrSEFzY1dLR3AxSmt3M0pYWDBoS2tJVHhldkNMa20wazJt?=
 =?utf-8?B?QTVuL0ZTb0lmbWRWcG1EOUlZL1psb3dCYWlqVGNDazdBOFJPOGRzT01Db3cv?=
 =?utf-8?B?OVRTUDhVM2NKUEpvclpSSnJkQ1RHVnpCYkhwWkFjU0NsOVhjUjlsUnh4Mnl2?=
 =?utf-8?B?MEhZTWJrazNHL3BUdDFMVi9xRCtObzc5MWhJZ0xlVDlRUCtJRXJvK1FUY1BS?=
 =?utf-8?B?ZnU1aTNzZm41eFRQUGpBRlpBNnVNSnV1L2NkQUM4dUp5SERsMEtpenptSzJ5?=
 =?utf-8?B?Q2V6ZmFwSnRlNDFUWE9odUdiR2NzTjIyZnNvSUtXbFhtaTBGZ0tPQW1wUmJy?=
 =?utf-8?B?ZlN4S3ByWW9jNnZIdGF1MjdKN1dmTmRqR1lxRHVzL2ZyY2hNSkFiMmhJdHo1?=
 =?utf-8?B?NGxpZXFDa0VneElVU2F1RytCQkhNeTJrNHBGcGEvTGVCV0FlVUtpSVR2dU5u?=
 =?utf-8?B?Q2ZmeU5XNjRjN2ZqdUdyRzBVY1dPcFRSdGtBQVgweXp6NWoxS0h0SkZZbUxY?=
 =?utf-8?B?TUx4cmNhQjVYM2xjVm1hb21PcTRhZy9XTmR6RzJRYXM2clRyVHZzZ09XTVJ4?=
 =?utf-8?B?YVoxTXFaQkNsVFRnK2pIdDZYOUVIL1hwRDFQWlVwM1ovZVpBNmR4cENpRVZN?=
 =?utf-8?B?OWlTK3JVamlqSEpLbzlKWHVGS0FKNUZ1eFFYM3Nwc1BiakplTDcvMGlCNjZX?=
 =?utf-8?B?bW54VUJCcThoVGVaZ1dpUlc4Y0s5dTE4NWc0bVkyWklHMUp4V1NuOGV3TkVC?=
 =?utf-8?B?Z3l0U2VsQzhBV3B6TGhXTUlheWV1K2g0WkRjczBROWRIbldqMkV6U3IvRkdz?=
 =?utf-8?B?ZGNZejdYMGhZcWM2cWFTbzUrTkp6UjE2MnJJR2xSMm1nTXNqcGJBVHlGSXJt?=
 =?utf-8?B?bUNOREdhRUxvRTAyRExVMTF2c1RoeC9IMTJLUThXcWY4UnovelZFWWpSM3VS?=
 =?utf-8?B?bktwc3htRjFtTTYrbExHVHNyMHVmeUQvOFphOGpkOWJ2TFFkSW5YZVRkejNS?=
 =?utf-8?B?Nm9ZM2hoN0tiMG1LWmlSL1lJaGZKZzFGNlpWTW1lVDdNcjBuRy9UZFJaNXBt?=
 =?utf-8?B?VTF2R0dZY0Z2QldkR2xIcEpwaWlCZzNOSzYzMWd3d2JzVkJxL25LMXYxV1Zq?=
 =?utf-8?B?UVZCcWpMK0ptcHBaM1RYMzJ6UGxhOG9KanZ6TkpvQmF2UlNhOCt1NmhKdFdv?=
 =?utf-8?B?dk10RTNaOTZXbTg4ZkN1SVFrR0c5TU1Uc3V3dkg4MHEwLyswOGpUOVFhRXNK?=
 =?utf-8?B?c3NFK3dNclRjSkpGZG9GWWl4TWUvbDdIcS9iblY2cUQxYVFWdlVQVkhEdnNR?=
 =?utf-8?B?a09SOEZ4dDhRQkVMWXJ4eXJnRzZoQVNHV2p1bThZNHZVL01BdFM4ZktqdEhv?=
 =?utf-8?B?Z09xS0hwMi9SUGRZNzF2Y3RvcmJ4VGUvRVE1WmpLQWRHcklxUVlNcTFlSlRi?=
 =?utf-8?B?TTQ0cm5jUlJYT3NKd0VJbHZlVG55SzRCLzIwMFp5OTJMVExBbXIrMzQxTG1X?=
 =?utf-8?B?VzZsZFhWV3dhOHNZYWNsOFNoeXBZWTRxMVlKZGFBZnV6Sk83OXJiN0pDS1ZE?=
 =?utf-8?B?ZEVOWHNhc0lVMTZWcm5ub1BYTG44NmN0bnQxSmhnZE01NVlhZzJMV3laQzg4?=
 =?utf-8?B?azJROEJackhzRjVBRmpLWVcvd09iQWo4VWFtVkI1TzYveWN5VGQ2WVhtSlZp?=
 =?utf-8?B?U2Y0YVVqV0xOZlhXdVlFL2tkNWlNSnA5VHZrVzVYc3lvNlIvOGF1cWJwVGpI?=
 =?utf-8?B?ZlZkS3RmU0JHWHZPTm92TnlxYkl6OG85dUdKMG1RTHNlQSszcjRld1I2alA5?=
 =?utf-8?B?ampxV0crcklHUDJXVTRNbkVDMWN2NTBReXhIUWM1TTNTT3BodmtwTk16bHZD?=
 =?utf-8?B?OC9HL01TVitHb3gvV1ZZWTVldEZvS2hGKzRPKysxaGdOeVJkNkxUY2ZSNUx5?=
 =?utf-8?B?dzVHWHdpSTNkcGMxaWRnK3A3NkoxeGdJejd6UUt6WG5raFMxUXlGbjdkY1N0?=
 =?utf-8?Q?A/CinaR2a+/OF7oJMg6o7c4Au?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c65047-0c77-4161-2afa-08dca6718f34
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jul 2024 15:03:04.3444
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GekOydOK1mHm5PK/0/EwQeMsWsSreb8Cj+ggEHvotq3BoQCAumndQkS1yXQk2Vz5pnXyHtDAHQ6dr1/ig3FqWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV3PR11MB8508
X-OriginatorOrg: intel.com

T24gV2VkbmVzZGF5LCBKdWx5IDE3LCAyMDI0IDE6MTAgQU0sIEphbWVzIEhvdWdodG9uIHdyb3Rl
Og0KPiBZb3UncmUgcmlnaHQgdGhhdCwgdG9kYXksIGluY2x1ZGluZyBzdXBwb3J0IGZvciBndWVz
dC1wcml2YXRlIG1lbW9yeQ0KPiAqb25seSogaW5kZWVkIHNpbXBsaWZpZXMgdGhpbmdzIChubyBh
c3luYyB1c2VyZmF1bHRzKS4gSSB0aGluayB5b3VyIHN0cmF0ZWd5IGZvcg0KPiBpbXBsZW1lbnRp
bmcgcG9zdC1jb3B5IHdvdWxkIHdvcmsgKHNvLCBzaGFyZWQtPnByaXZhdGUgY29udmVyc2lvbiBm
YXVsdHMgZm9yDQo+IHZDUFUgYWNjZXNzZXMgdG8gcHJpdmF0ZSBtZW1vcnksIGFuZCB1c2VyZmF1
bHRmZCBmb3IgZXZlcnl0aGluZyBlbHNlKS4NCg0KWWVzLCBpdCB3b3JrcyBhbmQgaGFzIGJlZW4g
dXNlZCBmb3Igb3VyIGludGVybmFsIHRlc3RzLg0KDQo+IA0KPiBJJ20gbm90IDEwMCUgc3VyZSB3
aGF0IHNob3VsZCBoYXBwZW4gaW4gdGhlIGNhc2Ugb2YgYSBub24tdkNQVSBhY2Nlc3MgdG8NCj4g
c2hvdWxkLWJlLXByaXZhdGUgbWVtb3J5OyB0b2RheSBpdCBzZWVtcyBsaWtlIEtWTSBqdXN0IHBy
b3ZpZGVzIHRoZSBzaGFyZWQNCj4gdmVyc2lvbiBvZiB0aGUgcGFnZSwgc28gY29udmVudGlvbmFs
IHVzZSBvZiB1c2VyZmF1bHRmZCBzaG91bGRuJ3QgYnJlYWsNCj4gYW55dGhpbmcuDQoNClRoaXMg
c2VlbXMgdG8gYmUgdGhlIHRydXN0ZWQgSU8gdXNhZ2UgKG5vdCBhd2FyZSBvZiBvdGhlciB1c2Fn
ZXMsIGVtdWxhdGVkIGRldmljZQ0KYmFja2VuZHMsIHN1Y2ggYXMgdmhvc3QsIHdvcmsgd2l0aCBz
aGFyZWQgcGFnZXMpLiBNaWdyYXRpb24gc3VwcG9ydCBmb3IgdHJ1c3RlZCBkZXZpY2UNCnBhc3N0
aHJvdWdoIGRvZXNuJ3Qgc2VlbSB0byBiZSBhcmNoaXRlY3R1cmFsbHkgcmVhZHkgeWV0LiBFc3Bl
Y2lhbGx5IGZvciBwb3N0Y29weSwNCkFGQUlLLCBldmVuIHRoZSBsZWdhY3kgVk0gY2FzZSBsYWNr
cyB0aGUgc3VwcG9ydCBmb3IgZGV2aWNlIHBhc3N0aHJvdWdoIChub3Qgc3VyZSBpZg0KeW91J3Zl
IG1hZGUgaXQgaW50ZXJuYWxseSkuIFNvIGl0IHNlZW1zIHRvbyBlYXJseSB0byBkaXNjdXNzIHRo
aXMgaW4gZGV0YWlsLg0KDQoNCj4gDQo+IEJ1dCBldmVudHVhbGx5IGd1ZXN0X21lbWZkIGl0c2Vs
ZiB3aWxsIHN1cHBvcnQgInNoYXJlZCIgbWVtb3J5LCANCg0KT0ssIEkgdGhvdWdodCBvZiB0aGlz
LiBOb3Qgc3VyZSBob3cgZmVhc2libGUgaXQgd291bGQgYmUgdG8gZXh0ZW5kIGdtZW0gZm9yDQpz
aGFyZWQgbWVtb3J5LiBJIHRoaW5rIHF1ZXN0aW9ucyBsaWtlIGJlbG93IG5lZWQgdG8gYmUgaW52
ZXN0aWdhdGVkOg0KIzEgd2hhdCBhcmUgdGhlIHRhbmdpYmxlIGJlbmVmaXRzIG9mIGdtZW0gYmFz
ZWQgc2hhcmVkIG1lbW9yeSwgY29tcGFyZWQgdG8gdGhlDQogICAgIGxlZ2FjeSBzaGFyZWQgbWVt
b3J5IHRoYXQgd2UgaGF2ZSBub3c/DQojMiBUaGVyZSB3b3VsZCBiZSBzb21lIGdhcHMgdG8gbWFr
ZSBnbWVtIHVzYWJsZSBmb3Igc2hhcmVkIHBhZ2VzLiBGb3INCiAgICAgIGV4YW1wbGUsIHdvdWxk
IGl0IHN1cHBvcnQgdXNlcnNwYWNlIHRvIG1hcCAod2l0aG91dCBzZWN1cml0eSBjb25jZXJucyk/
DQojMyBpZiBnbWVtIGdldHMgZXh0ZW5kZWQgdG8gYmUgc29tZXRoaW5nIGxpa2UgaHVnZXRsYiAo
ZS5nLiAxR0IpLCB3b3VsZCBpdCByZXN1bHQNCiAgICAgaW4gdGhlIHNhbWUgaXNzdWUgYXMgaHVn
ZXRsYj8gDQoNClRoZSBzdXBwb3J0IG9mIHVzaW5nIGdtZW0gZm9yIHNoYXJlZCBtZW1vcnkgaXNu
J3QgaW4gcGxhY2UgeWV0LCBhbmQgdGhpcyBzZWVtcw0KdG8gYmUgYSBkZXBlbmRlbmN5IGZvciB0
aGUgc3VwcG9ydCBiZWluZyBhZGRlZCBoZXJlLg0KDQo+IGFuZA0KPiAoSUlVQykgaXQgd29uJ3Qg
dXNlIFZNQXMsIHNvIHVzZXJmYXVsdGZkIHdvbid0IGJlIHVzYWJsZSAod2l0aG91dCBjaGFuZ2Vz
DQo+IGFueXdheSkuIEZvciBhIG5vbi1jb25maWRlbnRpYWwgVk0sIGFsbCBtZW1vcnkgd2lsbCBi
ZSAic2hhcmVkIiwgc28gc2hhcmVkLQ0KPiA+cHJpdmF0ZSBjb252ZXJzaW9ucyBjYW4ndCBoZWxw
IHVzIHRoZXJlIGVpdGhlci4NCj4gU3RhcnRpbmcgZXZlcnl0aGluZyBhcyBwcml2YXRlIGFsbW9z
dCB3b3JrcyAoc28gdXNpbmcgcHJpdmF0ZS0+c2hhcmVkDQo+IGNvbnZlcnNpb25zIGFzIGEgbm90
aWZpY2F0aW9uIG1lY2hhbmlzbSksIGJ1dCBpZiB0aGUgZmlyc3QgdGltZSBLVk0gYXR0ZW1wdHMg
dG8NCj4gdXNlIGEgcGFnZSBpcyBub3QgZnJvbSBhIHZDUFUgKGFuZCBpcyBmcm9tIGEgcGxhY2Ug
d2hlcmUgd2UgY2Fubm90IGVhc2lseQ0KPiByZXR1cm4gdG8gdXNlcnNwYWNlKSwgdGhlIG5lZWQg
Zm9yICJhc3luYyB1c2VyZmF1bHRzIg0KPiBjb21lcyBiYWNrLg0KDQpZZWFoLCB0aGlzIG5lZWRz
IHRvIGJlIHJlc29sdmVkIGZvciBLVk0gdXNlcmZhdWx0cy4gSWYgZ21lbSBpcyB1c2VkIGZvciBw
cml2YXRlDQpwYWdlcyBvbmx5LCB0aGlzIHdvdWxkbid0IGJlIGFuIGlzc3VlIChpdCB3aWxsIGJl
IGNvdmVyZWQgYnkgdXNlcmZhdWx0ZmQpLg0KDQoNCj4gDQo+IEZvciB0aGlzIHVzZSBjYXNlLCBp
dCBzZWVtcyBjbGVhbmVyIHRvIGhhdmUgYSBuZXcgaW50ZXJmYWNlLiAoQW5kLCBhcyBmYXIgYXMg
SSBjYW4NCj4gdGVsbCwgd2Ugd291bGQgYXQgbGVhc3QgbmVlZCBzb21lIGtpbmQgb2YgImFzeW5j
IHVzZXJmYXVsdCItbGlrZSBtZWNoYW5pc20uKQ0KPiANCj4gQW5vdGhlciByZWFzb24gd2h5LCB0
b2RheSwgS1ZNIFVzZXJmYXVsdCBpcyBoZWxwZnVsIGlzIHRoYXQgdXNlcmZhdWx0ZmQgaGFzIGEN
Cj4gY291cGxlIGRyYXdiYWNrcy4gVXNlcmZhdWx0ZmQgbWlncmF0aW9uIHdpdGggSHVnZVRMQi0x
RyBpcyBiYXNpY2FsbHkNCj4gdW51c2FibGUsIGFzIEh1Z2VUTEIgcGFnZXMgY2Fubm90IGJlIG1h
cHBlZCBhdCBQQUdFX1NJWkUuIFNvbWUgZGlzY3Vzc2lvbg0KPiBoZXJlWzFdWzJdLg0KPiANCj4g
TW92aW5nIHRoZSBpbXBsZW1lbnRhdGlvbiBvZiBwb3N0LWNvcHkgdG8gS1ZNIG1lYW5zIHRoYXQs
IHRocm91Z2hvdXQNCj4gcG9zdC1jb3B5LCB3ZSBjYW4gYXZvaWQgY2hhbmdlcyB0byB0aGUgbWFp
biBtbSBwYWdlIHRhYmxlcywgYW5kIHdlIG9ubHkNCj4gbmVlZCB0byBtb2RpZnkgdGhlIHNlY29u
ZCBzdGFnZSBwYWdlIHRhYmxlcy4gVGhpcyBzYXZlcyB0aGUgbWVtb3J5IG5lZWRlZA0KPiB0byBz
dG9yZSB0aGUgZXh0cmEgc2V0IG9mIHNoYXR0ZXJlZCBwYWdlIHRhYmxlcywgYW5kIHdlIHNhdmUg
dGhlIHBlcmZvcm1hbmNlDQo+IG92ZXJoZWFkIG9mIHRoZSBwYWdlIHRhYmxlIG1vZGlmaWNhdGlv
bnMgYW5kIGFjY291bnRpbmcgdGhhdCBtbSBkb2VzLg0KDQpJdCB3b3VsZCBiZSBuaWNlIHRvIHNl
ZSBzb21lIGRhdGEgZm9yIGNvbXBhcmlzb25zIGJldHdlZW4ga3ZtIGZhdWx0cyBhbmQgdXNlcmZh
dWx0ZmQNCmUuZy4sIGVuZCB0byBlbmQgbGF0ZW5jeSBvZiBoYW5kbGluZyBhIHBhZ2UgZmF1bHQg
dmlhIGdldHRpbmcgZGF0YSBmcm9tIHRoZSBzb3VyY2UuDQooSSBkaWRuJ3QgZmluZCBkYXRhIGZy
b20gdGhlIGxpbmsgeW91IHNoYXJlZC4gUGxlYXNlIGNvcnJlY3QgbWUgaWYgSSBtaXNzZWQgaXQp
DQoNCg0KPiBXZSBkb24ndCBuZWNlc3NhcmlseSBuZWVkIGEgd2F5IHRvIGdvIGZyb20gbm8tZmF1
bHQgLT4gZmF1bHQgZm9yIGEgcGFnZSwgdGhhdCdzDQo+IHJpZ2h0WzRdLiBCdXQgd2UgZG8gbmVl
ZCBhIHdheSBmb3IgS1ZNIHRvIGJlIGFibGUgdG8gYWxsb3cgdGhlIGFjY2VzcyB0bw0KPiBwcm9j
ZWVkIChpLmUuLCBnbyBmcm9tIGZhdWx0IC0+IG5vLWZhdWx0KS4gSU9XLCBpZiB3ZSBnZXQgYSBm
YXVsdCBhbmQgY29tZSBvdXQgdG8NCj4gdXNlcnNwYWNlLCB3ZSBuZWVkIGEgd2F5IHRvIHRlbGwg
S1ZNIG5vdCB0byBkbyB0aGF0IGFnYWluLg0KPiBJbiB0aGUgY2FzZSBvZiBzaGFyZWQtPnByaXZh
dGUgY29udmVyc2lvbnMsIHRoYXQgbWVjaGFuaXNtIGlzIHRvZ2dsaW5nIHRoZSBtZW1vcnkNCj4g
YXR0cmlidXRlcyBmb3IgYSBnZm4uICBGb3IgY29udmVudGlvbmFsIHVzZXJmYXVsdGZkLCB0aGF0
J3MgdXNpbmcNCj4gVUZGRElPX0NPUFkvQ09OVElOVUUvUE9JU09OLg0KPiBNYXliZSBJJ20gbWlz
dW5kZXJzdGFuZGluZyB5b3VyIHF1ZXN0aW9uLg0KDQpXZSBjYW4gY29tZSBiYWNrIHRvIHRoaXMg
YWZ0ZXIgdGhlIGRlcGVuZGVuY3kgZGlzY3Vzc2lvbiBhYm92ZSBpcyBkb25lLiAoSWYgZ21lbSBp
cyBvbmx5DQp1c2VkIGZvciBwcml2YXRlIHBhZ2VzLCB0aGUgc3VwcG9ydCBmb3IgcG9zdGNvcHks
IGluY2x1ZGluZyBjaGFuZ2VzIHJlcXVpcmVkIGZvciBWTU1zLCB3b3VsZA0KYmUgc2ltcGxlcikN
Cg==

