Return-Path: <kvm+bounces-72758-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mM5cMo67qGlbwwAAu9opvQ
	(envelope-from <kvm+bounces-72758-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:09:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id C9637208DD6
	for <lists+kvm@lfdr.de>; Thu, 05 Mar 2026 00:09:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 10E5A3024A17
	for <lists+kvm@lfdr.de>; Wed,  4 Mar 2026 23:08:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A36D390CBA;
	Wed,  4 Mar 2026 23:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PdrP2q6C"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3272F38C2C8;
	Wed,  4 Mar 2026 23:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=192.198.163.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772665729; cv=fail; b=om/L2BxA39RtLUriImIYXa96H3Vct1eQlSPG+Tst+Ors9U0fg6fDomX1ES0wN/iAgh03WCqjaKtcEtYJezJVk4B1YUDt4IDJLT9MY217RQvIxD+sV4uKLTt5mnAuabyUGeIMYvkqlsIxelcmjn1Ai4AyasHRJkETRrPS/LIQwwg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772665729; c=relaxed/simple;
	bh=TSd3kQG+zNXBsDGVhGXZvkXYXe1XImDLtY5lamlE1gY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=dIdfQx0dY7Ti0sJW1jJndjDyCuo0epDrA7keEMYKDEawxMOMTEgBfYQzQOgHua8WR8i0BswuEbap/O8koC4Z75a4IJtxKbDFLe18FHuIr9jtCbe1fSt4NcMUehq6BmQtFcEQg2O0vAd7JOg3SoIz5RXJYP+cEYmUxUlhvDeWdGI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PdrP2q6C; arc=fail smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772665728; x=1804201728;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=TSd3kQG+zNXBsDGVhGXZvkXYXe1XImDLtY5lamlE1gY=;
  b=PdrP2q6CKJqe8IHOae0qWWXZmlceV/RxArHYydMF99yd6b99xLtQbfSx
   BbR/kZR932IaJe+u6uLGMg8qwi3WOgSZRJTYPqUoADRV3qAZpXqXkvcb/
   02EDjnXAdm25GFd59CdAz/It9f0AFwa9hSTmoteMlpnxNHL9qH7+EytvE
   kVQcQ+uluPeh/cweo/PEdQ7Kbk/+DthA6yHOBEgxIF63rZTCp2PFa9yxL
   9ieMJfUeKKhd2gtkZM+pQlxynoQtxOXA7PtrBP5TYVuhMqg6Eshnq9bPu
   J6CDHz/PF4Ys7AngisJOn3NWCFW8yXYTHc3xQGsyAow8K2tlE8xG2jj88
   Q==;
X-CSE-ConnectionGUID: sShDjxdCR3WkEWcGBuovfA==
X-CSE-MsgGUID: qVvsSfY3R6ybakj8LvPohw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="73864108"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="73864108"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:08:47 -0800
X-CSE-ConnectionGUID: K+maiobSQzmygBMfXqp5EQ==
X-CSE-MsgGUID: wvdFRICdRpmPB3/4G6MGjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="215371749"
Received: from fmsmsx903.amr.corp.intel.com ([10.18.126.92])
  by fmviesa006.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 15:08:48 -0800
Received: from FMSMSX902.amr.corp.intel.com (10.18.126.91) by
 fmsmsx903.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:08:47 -0800
Received: from fmsedg902.ED.cps.intel.com (10.1.192.144) by
 FMSMSX902.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37 via Frontend Transport; Wed, 4 Mar 2026 15:08:47 -0800
Received: from PH0PR06CU001.outbound.protection.outlook.com (40.107.208.59) by
 edgegateway.intel.com (192.55.55.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.37; Wed, 4 Mar 2026 15:08:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JBvof6mI2qUrMX/S/pVMpe2q906qb/IbYil61D2VSO77+OZWnanrAFrUjPt55bybOsy6VvkarFC3tmTTvEQFQc7oVEnUgmmLz+yJYqB3XrckZAIMdSpEpUoOzSY9+wkUcPDkT6V7DVphbXnN2YjyHcB4676KeuDWU6yT4K7p6gmP+RaAtUT9Yt8tg9EnsFovUbOZrP2xv3gjot1vAV+A+TWZFV2W/L/ubhAFdDxVZtnxI8c7jyequmfoUdVbku3MoNZmjTrqpPKAfCrHfVZ7McanW74cglt8msFGOYP2RZK2xuMvbMZmMbpjC8qYZBmMTQ/vGBxdQLPM+hwrj8+yNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TSd3kQG+zNXBsDGVhGXZvkXYXe1XImDLtY5lamlE1gY=;
 b=S1gOF/LEioBnDAe7LdQmw70sUvPQn/fkxwpN3XfsE7lTix2dTNJtlbbwDIkzq9r3tTLveyuTtZ82tFCxA88w+sbrkx1FOC/1EYYjwd+xCG2ZeAbHEcekmEEOuVhouTAv/2ALHy9pcgGURdOWlnRukos8MGeYuyFxqtPMRc8k5EKTRgYVpVKT2tmSXt4vPpz+mvr5cEZpDmck+y2CQZPMjxCVV8MKt60v8YHN73GPk29THCJjMfznbDIzRUNyNaF5SzKOvAM+HUrEJSpiUIpOEephk7xOtgyChyymHbNk9SLg+kNY2nUVTjv2ibJISn/KJ9gPsDoMuLVNOnSsG0rv+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB2650.namprd11.prod.outlook.com (2603:10b6:5:c4::18) by
 DM4PR11MB5296.namprd11.prod.outlook.com (2603:10b6:5:393::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9678.17; Wed, 4 Mar 2026 23:08:43 +0000
Received: from DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86]) by DM6PR11MB2650.namprd11.prod.outlook.com
 ([fe80::ec1e:bdbd:ecd8:4c86%6]) with mapi id 15.20.9678.016; Wed, 4 Mar 2026
 23:08:43 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-coco@lists.linux.dev"
	<linux-coco@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Gao, Chao" <chao.gao@intel.com>,
	"x86@kernel.org" <x86@kernel.org>
CC: "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>,
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, "seanjc@google.com"
	<seanjc@google.com>, "kas@kernel.org" <kas@kernel.org>, "Chatre, Reinette"
	<reinette.chatre@intel.com>, "Verma, Vishal L" <vishal.l.verma@intel.com>,
	"nik.borisov@suse.com" <nik.borisov@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, "hpa@zytor.com"
	<hpa@zytor.com>, "Annapurve, Vishal" <vannapurve@google.com>,
	"sagis@google.com" <sagis@google.com>, "Duan, Zhenzhong"
	<zhenzhong.duan@intel.com>, "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"paulmck@kernel.org" <paulmck@kernel.org>, "tglx@kernel.org"
	<tglx@kernel.org>, "yilun.xu@linux.intel.com" <yilun.xu@linux.intel.com>,
	"Williams, Dan J" <dan.j.williams@intel.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 15/24] x86/virt/seamldr: Log TDX Module update failures
Thread-Topic: [PATCH v4 15/24] x86/virt/seamldr: Log TDX Module update
 failures
Thread-Index: AQHcnCz+259Z+kR/QkiV7CNY4ILrYLWfH0wA
Date: Wed, 4 Mar 2026 23:08:43 +0000
Message-ID: <24638970b6121011589e3e30968d926ca472d935.camel@intel.com>
References: <20260212143606.534586-1-chao.gao@intel.com>
	 <20260212143606.534586-16-chao.gao@intel.com>
In-Reply-To: <20260212143606.534586-16-chao.gao@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB2650:EE_|DM4PR11MB5296:EE_
x-ms-office365-filtering-correlation-id: d05d3305-f142-40da-0fef-08de7a42fb68
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016|38070700021;
x-microsoft-antispam-message-info: zMxse5xYUUlDWRWmFLwTQW/0TiwYgXMuU/iILCbmZYrgrAS/SrJsBPIwI2WySifo/9uU3j6a2vIWPaJMNS0+BE0T7WO1a+djxn1t6Mvh+U4OwI/2Q7OeGJwc1FwP09lSL/Uk+g+453s/vmnjzZGgss0/i0CSnsGS1BVLvJCrxN7qfDL/ibbSKvEj0YNnhgXrNHN1po0D2fJws6uIVQl+0q9byhTcyfrNiMMNrWXqLmzGaW6jUEaYTQFzDyD5xv/DSYwluZk5ivZoC6zr17c2a0PaW4JiBj2pXIPPd3eU1U5UiWJavIhQNnMPXjAVhjfp4rnNzMS5M3ZRH7l74EhhLzEwmi6haDlJxS8l9vVL4KU5P0++yhkxlknLw2WP53KFC+5ncDjhEfiBs7gtRW4wvQUoSckX7AOds//hG23jnTf/eLwsTyBQoEuY4ypKBr+m5Zwoji8U9s/Kt6mgl2FPAM1uk6br1F7XRVoxkWk3AiLKA3O2qOgJZWacXmewyC+pdWx2s+I+MaC8OjtOFtRA6Ts72PD6/dLaQLJUfN/hVfryomvadPCCRNFFck220F5zetakAbr0QtoAIDh5wHJVCFicWLuIKRyu/oj7WxLkhrdzVVCRrz7eRbVd6oACyw8QadahEWBDGKJBLtBuMg4qgUKYHrT0aY01Ev+bJBvZJMboFYz+n0bMEHy2OGYzj3Ph3wcPimfEoYomjzFxRvx4BlA2/sXoPW9vGzdsn4a8W/EwRbOVGZ5G2ykgHhLajHVIAnp3fnG7M1vix6vYL+yUz//GQEZHs0Ku0iaE8F4a1Bw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2650.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VUtXTlNTU1NhRCsvNVh1MTZleUdyVzJUL1I5SVRZb0tWcE91NStLSGRqaUxp?=
 =?utf-8?B?aENFTU9BbE0xQ2llMDZuNm9Rdk5WbGVTK2xQaFFHOUZCb25ScmVDeURENXBj?=
 =?utf-8?B?VENDQ2RmR2JVRjNqSmZXME1pSlpNNEVCZXJVYzhwZVFYVitJZDhSRUh2eDJa?=
 =?utf-8?B?VHQ1OXJkVTlFVGdhcVRRczZ4cmdXWmh3WksrNUJjNUhPS0ZReldOTjFQSVZQ?=
 =?utf-8?B?YU02dHd6Vy9aVnFXU3daeUJrWTJxaU40bzh6VnhxWGt0NWF6SlRQS2pGSWYx?=
 =?utf-8?B?YVB3OFZIZlhCODZvSDNUcmpPdVVKS3Nob2NPOTFKQ1lmczVHNGJmMnBWTWVy?=
 =?utf-8?B?cS8rTUZscFd3NGI5YW15TGMyK3ZLdE5aN2dLMWZVTjZYWkZEUEdNRWlhWGQz?=
 =?utf-8?B?OWMvQ2xMNExueDh0RVVXeUExSEhIKzBkZ01JQ2srbi9nbUV5YXdNeW80L0xC?=
 =?utf-8?B?MUxTbXZ2MFY2Q01ZZmVpZjA3a0QyYnRLeVJzT0tENC85V1RyRzhLa0xYNHVD?=
 =?utf-8?B?aUgzdVVpUkRWU3duV08rUWhmdGlyM2t2YlJaeTRkWjJzNTZGNzJWbW9jNHFy?=
 =?utf-8?B?M0MvZ3lLTGJZN1NIVUhUUGhLRk4rd0NQS1hlTkt1YjZIeGpQaTd0ODVEUzRL?=
 =?utf-8?B?cFZNTUljS0lyakVKVlBnVE5zSGh1VXhkZ2dieWVDSzdNK0ZCOFFiN0taMjhC?=
 =?utf-8?B?VlMydVJXODBYd25XRjN0akF1K3lFNXFHbngzMW9DTWVBcW83KzBlek9IVjc4?=
 =?utf-8?B?NDJHV0tGQmhoeWJVYWw0UjloQy9nSG5kMUlrU2VxK2YxYmNBbnA1Y09SYWxM?=
 =?utf-8?B?QXlXTVU5VzhyMXlTYjBCczIwSlF5YlJIN0cvYlNESHRBWXRaYWlpNE5HdzJQ?=
 =?utf-8?B?aWRxVTczZFIzWkNvcmtHL0w0OHI4bnBsa0VRbml1VTBGYWM2NGs1Vy9sWSs5?=
 =?utf-8?B?V2M3WEpTRGk3UmtSYkRvclFoc3N1NlI3M1BPbUl3Y0huejVXeFZxcGdoMEdM?=
 =?utf-8?B?anFFSk80R2gyY3V3UUd3L2szYytiSHllU2NwS0Z0dmY3NTZOenRRak42emFp?=
 =?utf-8?B?bFlZaE9BRUpsL0h5eEZKOEpacHZoT1JWeDg2eGZwSW0vKzRaS1JYQ29odlUv?=
 =?utf-8?B?UFFiTllwUXFkZDRocG9JeURqaEpoQVlkeE5qdFpqMzFqSUViZ2dFRjFFdmpj?=
 =?utf-8?B?WmU4TmpWaGswcmdxTDZQWEpyd1RkTks2LzdKM2pWNFRzekFYQjc4WW9wYXVS?=
 =?utf-8?B?N1Z1VjZ2UW5PZ2JpZzNCc3hnakFuMzMyYmVFVFhOcGt2MUhVNW1LQWp0TGZq?=
 =?utf-8?B?TlBaeEMxcFE5LzNtSUJlbEdpRHdvTlkrWEtSRHBhUDdvYzZRemwyWVl6WGhP?=
 =?utf-8?B?c0dQc2NzanR0ejZvclBybnk2d0Y3VksrMCtoTERBdDRtYS9LNHo1VGhmUk9l?=
 =?utf-8?B?MmxDZUJRd0VsL2ZEYTRJSjRoYnBzRTZaY2NMejhKR3ZHaWxFbTQ0UmIvdzd1?=
 =?utf-8?B?bXBLREx6K0JNREIxdnBScGQyS1FXRlJHWGNlbHQzQUlaY0hQSTdBaVNaSGRy?=
 =?utf-8?B?WDFtbUFWbE8vcHhpa3dURHR2NlVzWWE5NHArcUtiUE5FcEZSR3J3WGVBaVV4?=
 =?utf-8?B?WCtvMW5WSE00VjRVTjVEQTQxZk5ybXlUMGF5MEhEUDQ0UlZBQWJGdXg0bjdw?=
 =?utf-8?B?MlJRanZkOTAzcHN6K3NOLzZOR2xqbEZaN2p0R3d3WDV5L045bm54NGJxOHRB?=
 =?utf-8?B?ZXU1dlZ2NXViTlhpNDV6K2x6emZCMzAwaGF2Y3BKZWtRSzl4L3UzSDQ1YnEv?=
 =?utf-8?B?d201Tnh5S0x6UVVYYi94a1VmMGtTTFkzcld2cEJCVmhBZ2dkZFZQem5iTU1N?=
 =?utf-8?B?Ums2dTAwaGN6Z0RpTnpDNVJtbkV1eW5qMzVFUWdxWDZDeTM4NE5QYXlxY3lK?=
 =?utf-8?B?QlBZNFZyNitWZjhGTXJSMVl1aDB5ZnZnaXgydlZBOUVkUWZRQldiaW9ySkRI?=
 =?utf-8?B?cHEwQXB1aGgyV2g1RitMRlN2WXcwbUUvK3dGVTZKeGtYU2R5cFA4T1dvN1Vz?=
 =?utf-8?B?MjNIUjU2ajdvQkFkejVHYm92TXZQdStqVXBoalFCdEFzVU9pZC9UTmVaZzRO?=
 =?utf-8?B?ME9HV25MVHgrSko2dnYwM0p5dUN2L2RBVnowWXVBc1Yya3c2bmtzVXdyNGJw?=
 =?utf-8?B?Q0ZoZld0ZWVDWWpSSUxzSG5oV3VodE9BZDNoZzJyY1l1ejVuS25jN1E5QWt4?=
 =?utf-8?B?VndzR3AyQ28ralErSW8zU2lzTVJJSVNNeW1OcGczLzBCSkJFcHlSeVhaVTVo?=
 =?utf-8?B?d1g4MXplMmlLSVFlV3VDdERRbTl1b2c2NUxMSDJzMlkrOGtNWXhTQT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EB3C5825086C524E91CA6F2FB4F2CC88@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2650.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d05d3305-f142-40da-0fef-08de7a42fb68
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Mar 2026 23:08:43.6984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 16FBOTpUrNSY8BFh2aReCG37l3ZpuVhlTEX5F2FBB+BIF6yjR7ajN685MDPO8ur1svftRUjkQ65uXpKK8WzqCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5296
X-OriginatorOrg: intel.com
X-Rspamd-Queue-Id: C9637208DD6
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.94 / 15.00];
	MIME_BASE64_TEXT_BOGUS(1.00)[];
	ARC_REJECT(1.00)[cv is fail on i=2];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	MIME_BASE64_TEXT(0.10)[];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72758-lists,kvm=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[25];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:dkim,intel.com:email,intel.com:mid,sin.lore.kernel.org:rdns,sin.lore.kernel.org:helo];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[kai.huang@intel.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[intel.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[10]
X-Rspamd-Action: no action

T24gVGh1LCAyMDI2LTAyLTEyIGF0IDA2OjM1IC0wODAwLCBDaGFvIEdhbyB3cm90ZToNCj4gQ3Vy
cmVudGx5LCB0aGVyZSBpcyBubyB3YXkgdG8gcmVzdG9yZSBhIFREWCBNb2R1bGUgZnJvbSBzaHV0
ZG93biBzdGF0ZSB0bw0KPiBydW5uaW5nIHN0YXRlLiBUaGlzIG1lYW5zIGlmIGVycm9ycyBvY2N1
ciBhZnRlciBhIHN1Y2Nlc3NmdWwgbW9kdWxlDQo+IHNodXRkb3duLCB0aGV5IGFyZSB1bnJlY292
ZXJhYmxlIHNpbmNlIHRoZSBvbGQgbW9kdWxlIGlzIGdvbmUgYnV0IHRoZSBuZXcNCj4gbW9kdWxl
IGlzbid0IGluc3RhbGxlZC4gQWxsIHN1YnNlcXVlbnQgU0VBTUNBTExzIHRvIHRoZSBURFggTW9k
dWxlIHdpbGwNCj4gZmFpbCwgc28gVERzIHdpbGwgYmUga2lsbGVkIGR1ZSB0byBTRUFNQ0FMTCBm
YWlsdXJlcy4NCj4gDQo+IExvZyBhIG1lc3NhZ2UgdG8gY2xhcmlmeSB0aGF0IFNFQU1DQUxMIGVy
cm9ycyBhcmUgZXhwZWN0ZWQgaW4gdGhpcw0KPiBzY2VuYXJpby4gVGhpcyBlbnN1cmVzIHRoYXQg
YWZ0ZXIgdXBkYXRlIGZhaWx1cmVzLCB0aGUgZmlyc3QgbWVzc2FnZSBpbg0KPiBkbWVzZyBleHBs
YWlucyB0aGUgc2l0dWF0aW9uIHJhdGhlciB0aGFuIHNob3dpbmcgY29uZnVzaW5nIGNhbGwgdHJh
Y2VzIGZyb20NCj4gdmFyaW91cyBjb2RlIHBhdGhzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ2hh
byBHYW8gPGNoYW8uZ2FvQGludGVsLmNvbT4NCj4gUmV2aWV3ZWQtYnk6IFRvbnkgTGluZGdyZW4g
PHRvbnkubGluZGdyZW5AbGludXguaW50ZWwuY29tPg0KDQpBY2tlZC1ieTogS2FpIEh1YW5nIDxr
YWkuaHVhbmdAaW50ZWwuY29tPg0K

