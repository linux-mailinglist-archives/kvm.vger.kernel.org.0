Return-Path: <kvm+bounces-17761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 21D478C9D75
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 14:38:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 452891C221C4
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 12:38:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5F1655E74;
	Mon, 20 May 2024 12:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GyPXbzvT"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2974350275;
	Mon, 20 May 2024 12:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716208706; cv=fail; b=mFFXumd9/BYCeGXO2h5cF55fzeVWAv8sIWXZwdq3+ooonve1g++hKWj22rTLdp6GoP7RZ1frWTjJn/k6nlGrtHH2vu2oxnzJtbQJNfgWUTmGrkvSUKdaSqrnRT2kjgl9FzUKDpIsHPOq9JY1gViTa+2euIhlGo2OwwyRXMGRRsI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716208706; c=relaxed/simple;
	bh=/yTN9s2SopWGfK2pA+a/V6fs5uIZItdt+deJ1XfOM1Y=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=Ekok29fAzRmkd/rRb+HVhgQ1udM63bmQFtqMiodHhRIDvfRrEMKYC3LC8r7iMFB7uLK7ZQcAPkQFPTf8CPZsnkgLXCAgcXJimt2760domM1kHnId5xNudR+e8Jh8HAdp87Ywiee/Ryqztxmu05d9EHsXrZxp1CwwYpb49vcjAq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GyPXbzvT; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716208705; x=1747744705;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/yTN9s2SopWGfK2pA+a/V6fs5uIZItdt+deJ1XfOM1Y=;
  b=GyPXbzvTyNspv+ABhPKQBY+7v5NpE5vZ/sHd6qI2Eq7ecvw/whdxiZRj
   sPEfKm8JQwA/DGVD1PLN5Q7v4nDo4vhYscwSnVWXZ7Fxv+gmyUM9hMo0f
   f2nM0se5Nfyts8HiK/Ti8CKs8sEnzJeNQlm5CYRCE20ypZVWHyOTwV0Xv
   W0c6iU4JXFqfBMb/1RK9E9rLwf0BRVW8veODvtk3gVGR4unbHIoJeKqei
   IiMR8efPbia3J0Ao5JMORuZXMfcVNEIXmQNddrarviaBjynEiKPPo1j1J
   MbaNCk9ruUY2Z0CCMfsenIzmqjUq/CwRzgFwlpD3zuxT845rv9JwvKIOa
   Q==;
X-CSE-ConnectionGUID: b5EipDmgS6C2Mp0noTgwpQ==
X-CSE-MsgGUID: N+Y97/TlQMq9MVnayK0/vA==
X-IronPort-AV: E=McAfee;i="6600,9927,11078"; a="12274772"
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="12274772"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 May 2024 05:38:25 -0700
X-CSE-ConnectionGUID: 14PU5ZCCT3CvWfC7XdvoSg==
X-CSE-MsgGUID: WiVSzbxrSGuUbpVjPjGlTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,175,1712646000"; 
   d="scan'208";a="69960678"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orviesa001.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 20 May 2024 05:38:25 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39; Mon, 20 May 2024 05:38:24 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.39 via Frontend Transport; Mon, 20 May 2024 05:38:24 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Mon, 20 May 2024 05:38:24 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OEUDcun7Bvusg/oaLfWV6wyJJrYkfml1yyTmBSDkCcFqpRmMj2cmr4zJz0vxfOC3G32zVBfBOgPVk5JlMI4SdjCN6cHR5RepWNXRsGxYj/6qnyKUYlVbqPLcio4fWOmW1Z5dSW3LS6ge//jUi0unDl7tPlMkViJgG+vGOpj9HEx4XdReLnrDKqXRRg0nDp3iFp/whCQcdZ+W5s/vzobcpUk4vBloPunCGqCMg4clp+Tz+RIWIU9FsAYBe590IhWFrOI6wliw52WGirIWT3Jvv4IMJtLV4I7+Qcl8237MuKGX245rKiXTHu3RG/6M57tHu3YYub9aW/8hiFHrF9XgdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/yTN9s2SopWGfK2pA+a/V6fs5uIZItdt+deJ1XfOM1Y=;
 b=RSLjpGoPyV332hjNP8lJowXIihx5lN6YwB4zkDh+9KzInlFpXwXRX5XGPSR2yowAGV1swlqyWDOCPLeiGguv3uyhhr/7Du5JkbCRaEYcbQvfEHACJMvUqlHlTO7z5uLrNOV/x4bPY2NPs3wRtUEkHF2OBcq1crJnRyrha1kfHR6jb8Z933XjPu3mg8ZK8VnEBSdNY3n/qdJ2ytfo389M0VH7Bb7NJHU1Uhuh+T/n5356+dfzGCufxChCFBk0ekX369TzFaSEgCRvCGqIOeywPzPirlDpuSi+hofIl48FHEm8I/Bu2pKQi3q1WfzhfYceOhduYBUYWTGmfUnHJpcgKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5978.namprd11.prod.outlook.com (2603:10b6:208:385::18)
 by SA0PR11MB4606.namprd11.prod.outlook.com (2603:10b6:806:71::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.36; Mon, 20 May
 2024 12:38:22 +0000
Received: from BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b]) by BL1PR11MB5978.namprd11.prod.outlook.com
 ([fe80::fdb:309:3df9:a06b%4]) with mapi id 15.20.7587.030; Mon, 20 May 2024
 12:38:22 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/9] KVM: x86/mmu: Use SHADOW_NONPRESENT_VALUE for atomic
 zap in TDP MMU
Thread-Topic: [PATCH 1/9] KVM: x86/mmu: Use SHADOW_NONPRESENT_VALUE for atomic
 zap in TDP MMU
Thread-Index: AQHaqLcNBYtzreen5UuUT4L9qEegW7GgE8IA
Date: Mon, 20 May 2024 12:38:22 +0000
Message-ID: <a4042eaae0f207d6b329b6d91888e3e6b4befe51.camel@intel.com>
References: <20240518000430.1118488-1-seanjc@google.com>
	 <20240518000430.1118488-2-seanjc@google.com>
In-Reply-To: <20240518000430.1118488-2-seanjc@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.50.3 (3.50.3-1.fc39) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5978:EE_|SA0PR11MB4606:EE_
x-ms-office365-filtering-correlation-id: dac93ff0-c78b-4fbd-bcbf-08dc78c9bc50
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230031|1800799015|376005|366007|38070700009;
x-microsoft-antispam-message-info: =?utf-8?B?NnYwaStPaENDalFjVlZGd25nLzBKM05BTXNvaEZibWkxVlZOMCtpRU8wMUVH?=
 =?utf-8?B?VkVIZFo5SUFWTXp1UmdTSnRnOE1TRDlGT254eXdlckdHT2lvTHVCMVdYTkhp?=
 =?utf-8?B?b3NrRE5DZE96aHhoRm9qREZ2MUdTOXJrd3hGSW8weG5FN3MrbVRFZW92aFRP?=
 =?utf-8?B?NjNXMEdLemt2OEdISEpMalNkNEprY1ltZGZ3bGtpZUhNM1N2VDZpdHJRd2VH?=
 =?utf-8?B?bEs0akVDT1RJaXZaUElFUXV4ampxcFRxTkt6aEcxU1F3RVFTM2F4WVZqVW5j?=
 =?utf-8?B?R2dTYW1DZjJQbzRlWmp5QUwwMWlaOUo3M24wTUZaVTdXMk5OV3ZacmduRHlq?=
 =?utf-8?B?YWdkUnh5UzhpR2VwcjBkV2NRdmViMm9MV2ZhK0Y3K3JLeFZWM1A0dWV5cHRZ?=
 =?utf-8?B?ZkNEbWJMSXFsdlpRU2NaNnJQL29JQUw1TTFEOEoyY1JlRWdNb1Q4QURxc2JB?=
 =?utf-8?B?bEs2NUFoRGJMb2NaNGMwK0VERnJ1SVVTRmt1OXNmS3huNERsSFZiTG5DYm85?=
 =?utf-8?B?UWVGdUdEYzQvTlBOcHlmK0I0bTJ6TXFkcDhXVVpkK3RvL3dMNU94emZPUkp1?=
 =?utf-8?B?ZTdKRUdSOTkwbkU0cFgyWlM5QTBOcEh2NWhxdjVBZ1IvQS9yaXlSeTl0OVdY?=
 =?utf-8?B?SWVGZ2VHUkNDSEVGaXQ2U0xsbVQ2K2hra2k4OSs2T1FIVUpWMHpVaDJ0V3hR?=
 =?utf-8?B?ZDZhSjFKRkZ5bTdDenV5KzU5MXJ2Qmh6cFpkaisvaS9weU9XdHZuVzlua2Q2?=
 =?utf-8?B?ZFZ4d1grTC9icElnM05vOVRZaDM5dVNtcS9hVXBFNEo4LzBUS2hZUTJlaFFI?=
 =?utf-8?B?dytqTDRlSnVVbHgrdE1KQVNadERZbXprMHc0TjdwWXhnT2QweVA2VTBjaGdy?=
 =?utf-8?B?NFNFY1owc1FSbFJPRGxZMVlBNUtvRGxiS21yQUp6aEtyMVFUdG54ZklPbzh3?=
 =?utf-8?B?SDBlK29VMEljelNhckcwZ0dNSTVTSjdFekdDOFBVOE9ZZXUrY2hCRDhzb0V4?=
 =?utf-8?B?ZGtuL1V6ZXlWR3ZsZktpV2oyRy83ckZKZzhrc25iRWhzRTIzOGRoZ20zeHpo?=
 =?utf-8?B?QmpudmwrdGMwY0xJWm1WelFveVZ0QW5iTklwWG95amQwVVFETGhYc281eHdq?=
 =?utf-8?B?bjdUekJnWGVabHlrRUZod1hrdC9YVUM4djM1RnorZHZVWENySkxNTTNHSndD?=
 =?utf-8?B?K2had0p4eGpOc05ZRDF4bjI2U0wyb3doTWRlUkVoS3VGTGFwa2ZoRWhrb0Q4?=
 =?utf-8?B?ZG1ncmo5ZFRRU1MxTlR1aG0yRytoRzJNTXdnT0hKTU5rVk5oYkl1aHRYL25p?=
 =?utf-8?B?WXFIc1dsQ2pNb25pdG1GeGc4cmJkRzJTRGZkelBiRHlGSjN3THQvSGxrbDF4?=
 =?utf-8?B?T1ZBVkRkeGpCZDRVUklseEpCdTN6SEhGb014RnVyQ1Nhbm9McW9FaUp2Kzkw?=
 =?utf-8?B?NHcrTldNY1U3VlloWE84VFZFMFVZV2UvN05tbkgvV2VoMlRyN1J1aU5lY2hX?=
 =?utf-8?B?NDYreDZSY3ZMb3BxdHZxUm54a3VWVWpTdFR3Q1NLaUtjMkJkaUc0M0UzUXRz?=
 =?utf-8?B?K1U0UjV2U3JzWnBHUW41aGY2OXEwb1hGUlFZdzlrK3lyMzY1cExhNUUrcVhG?=
 =?utf-8?B?VTFnZUF1QU5OTkxIQ0dhYW1YLzNRYk9takdUSVdURitxYW1pWDlZb1lOTlpI?=
 =?utf-8?B?Zm4xNWtld0hlZFQ4WVFWb3E4a2xZK1hlMUtNbllrekFUOE5FWVV6Y212U2tp?=
 =?utf-8?B?TlJTS1VxZm5QRS9oV1ZrV3FsdEIvdUt0V3N6T2hpV3BrdWZ1OGJsYWRSWWJU?=
 =?utf-8?B?KzZUUlJJV3dmY1Qzd1F2dz09?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5978.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(376005)(366007)(38070700009);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1A3MU1NZWUxdWpQQ0xTTnJOTkJ0eHV2NUgrdnZjeHZwVFZDbGpCRkRHbEdl?=
 =?utf-8?B?eUc5eFE2ODNDaWhscnh5V2VvM2hXVDB6QWlBSzVjTWlINVpPNDlCRGMwUm9t?=
 =?utf-8?B?Z0V2bmFxZHIxUEhpaTB0SnFzcllHTVV6NkhZTXA3L0VrbDlkb1dySGpyeENK?=
 =?utf-8?B?aUhuRUl3ZUdOQzRTTzZaQ0N0a21CMDY1N3F0RzZjU2tJZkNKRGp3Ui9vSmRp?=
 =?utf-8?B?VEtVbDVlNHBBR2pGdE9nK1laRi9UTnMzaVhNcm4vRWZ5UGpOT3Q0QVJ2M012?=
 =?utf-8?B?L29ucDM4U3NRdDh6NmVsL3A5Y0EvTTc3bTNUaTRqUDVxUE1vSXBWQUJ5dU1M?=
 =?utf-8?B?aUtpR3FqQWl0NjJHWFNoWDRNbEpZTW4wWnpCVUdzTHg0K1lzaUhWV2F2SWxq?=
 =?utf-8?B?QnBuQ2FGd0Y5Z0o2d1ZkY2wxNG5NWlJlUk01ZDdYVE5ZUTQ2VVY3a0FzYnd2?=
 =?utf-8?B?TzFBemtHUmlNMWVGZkpqM1RNSnQ2TFk3Y2lQYzc4OW5pN2FlQ3VMckpndUdh?=
 =?utf-8?B?L3gvbS9WbnFkMURCOUI0TWxHVU1nbXVCdEpzc05kTG9FcXdJemtmVi9FMlA3?=
 =?utf-8?B?bStuT3dMUzgxSVFtOWhoL3FnYkxhd1BZcnh3cWR6aFlSZjJZUDJhWWQ4bWNT?=
 =?utf-8?B?QUtHWEpCOE5QY0tiZWZhOXg5T3NGVnNIUnFTZVZEcmVnYS81enJYMXdUeHNO?=
 =?utf-8?B?M1Z3Y3VXT0k3MjlEOHpzQ0JMSHJJc1JhcklpM0lna20ycUx3YXBMVytaS0xF?=
 =?utf-8?B?Mm1tdnhib3VnMk1SbDdOZUxPTi91TWd5MDM0UGtmaWxZbXBPRStwSVg4QThE?=
 =?utf-8?B?K1NabUduUHVuc2JLV0p2NGE4azFpdml6am1MZnFyRGpGZGoyaGlyRVdTNCtx?=
 =?utf-8?B?dE51VGs4aFFOZldMTzdzMzZSVUR3d282bG45U0FFdzhXblM0S3NKNkVNSERl?=
 =?utf-8?B?OGNpbDhaWnVxbS96YmtFQTZoNm1UMHJIUVk1SlJqYXc0OTh0QnB0S3l2MG5E?=
 =?utf-8?B?L05pU3NrWnMxc0F6RjB4aDlsd3cyRDRQY3RVeFpQb3RlVmovamRDL0t1M0ZE?=
 =?utf-8?B?ek5JdzQzS1prdFpCaFI4RnVZQWpYUm5ISGhqZm1lYWRGT1pXaTVUS2tPTEgy?=
 =?utf-8?B?T1BiaHlQV3VBVVlTcVBTZElaL0x1K0FaSGFlMS9acjNTQ0U5QnlrUlQwNCtr?=
 =?utf-8?B?VWlMSFJnQ0JBSkpYcVJoVGE5aFJyV0RDbmU1R0hiSEhUNkR0c1V5cTk5SVB4?=
 =?utf-8?B?QUtoM0Jwc25jMHAwemRrbjdwMUZYdzU0clp3TDE4bEtyZkRSdnNJek9RTjhl?=
 =?utf-8?B?T0twYkU3OTgvQ2lrY3JueS9MakhaeCthZlRtWkNEMGh2NUhEcElBdlVEa2NR?=
 =?utf-8?B?dUtWVndhaU5IUkVNLzl1bHUxZmwxanQwSUc0QkgrOVRlTmpLdnI2OFlxdSs5?=
 =?utf-8?B?cTRrbk9IYXB2U3VjY2dtYTZ5VGM3dFlBejN4UmJpQkRIY3VOTlFxeGFHK0dG?=
 =?utf-8?B?Z2VydGE2S25MTGlVQjExSTArYU9jTUs2d1pkQUpJYUg4M0o5dzB6RDN0NzEv?=
 =?utf-8?B?bndkdzhJalVyalRTc2RtVXhxUy9qZSsxV0dRcndSTjhaSE4rUTRSSVBBdUtv?=
 =?utf-8?B?VUlZL25hRFF5MjJwdVlSQmR4UDlYMDBPT3ByYnNXMmpqZDhySlVWR3dwdjdq?=
 =?utf-8?B?ZTVGaVRDWTgyb2txRm1TVkVndWdKVlgzZEd4MzZoa2p4S0ZtYldCc3BmVlBO?=
 =?utf-8?B?TE1tMWlVZVMzbkJzbE1vSDlmNDZjeEZzQkZFeTIwMTNmTXZSWTM3WW9ZRnlQ?=
 =?utf-8?B?dFpwejgxMEQ1cjZtK004QUtuR3NKaFNHUzVYemp1Vk4yUWJOelRaRlZrUUFT?=
 =?utf-8?B?bWpIMDc1VStoQy9Tc2xLWkJodkV3VC9ENkNvMS9DN21YMGZYWGRvakw3a1JK?=
 =?utf-8?B?cnVPMjJ1OUtTcXRnK1VtTmdOOTBhOFhoMjBmZWZqMktiTmFlS2txVWRlRUpP?=
 =?utf-8?B?aXZLZmV0VUgrMmd6c3NVMnc0dmptc1krN0RoT2NlM0U5YTBxR0JDMHgxbFN3?=
 =?utf-8?B?emY1REhrczRWRDYvVE10SjFvWDFRS21tYkV2b1JDV3ErL2xBM1U4YXQwQWNx?=
 =?utf-8?Q?s5YPvNojnj7t5dNldDDaeioSi?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E95D3FD5A7E4884284D4FCCF22DA5C9C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5978.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dac93ff0-c78b-4fbd-bcbf-08dc78c9bc50
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 May 2024 12:38:22.2667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j16tSM8oXPZU8X1EIIWL62CDV+8jq9Va6gZ7pLBiwV5qhRPckal/k57cdZvsptIlkuyUu8v2iBINGoDjnjM64w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4606
X-OriginatorOrg: intel.com

T24gRnJpLCAyMDI0LTA1LTE3IGF0IDE3OjA0IC0wNzAwLCBTZWFuIENocmlzdG9waGVyc29uIHdy
b3RlOg0KPiBGcm9tOiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29tPg0K
PiANCj4gVXNlIFNIQURPV19OT05QUkVTRU5UX1ZBTFVFIHdoZW4gemFwcGluZyBURFAgTU1VIFNQ
VEVzIHdpdGggbW11X2xvY2sgaGVsZA0KPiBmb3IgcmVhZCwgdGRwX21tdV96YXBfc3B0ZV9hdG9t
aWMoKSB3YXMgc2ltcGx5IG1pc3NlZCBkdXJpbmcgdGhlIGluaXRpYWwNCj4gZGV2ZWxvcG1lbnQu
DQo+IA0KPiBGaXhlczogN2YwMWNhYjg0OTI4ICgiS1ZNOiB4ODYvbW11OiBBbGxvdyBub24temVy
byB2YWx1ZSBmb3Igbm9uLXByZXNlbnQgU1BURSBhbmQgcmVtb3ZlZCBTUFRFIikNCj4gTm90LXll
dC1zaWduZWQtb2ZmLWJ5OiBJc2FrdSBZYW1haGF0YSA8aXNha3UueWFtYWhhdGFAaW50ZWwuY29t
Pg0KPiBbc2Vhbjogd3JpdGUgY2hhbmdlbG9nXQ0KPiBTaWduZWQtb2ZmLWJ5OiBTZWFuIENocmlz
dG9waGVyc29uIDxzZWFuamNAZ29vZ2xlLmNvbT4NCj4gLS0tDQo+ICBhcmNoL3g4Ni9rdm0vbW11
L3RkcF9tbXUuYyB8IDIgKy0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5j
IGIvYXJjaC94ODYva3ZtL21tdS90ZHBfbW11LmMNCj4gaW5kZXggMTI1OWRkNjNkZWZjLi4zNjUz
OWMxYjM2Y2QgMTAwNjQ0DQo+IC0tLSBhL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQo+ICsr
KyBiL2FyY2gveDg2L2t2bS9tbXUvdGRwX21tdS5jDQo+IEBAIC02MjYsNyArNjI2LDcgQEAgc3Rh
dGljIGlubGluZSBpbnQgdGRwX21tdV96YXBfc3B0ZV9hdG9taWMoc3RydWN0IGt2bSAqa3ZtLA0K
PiAgCSAqIFNQVEVzLg0KPiAgCSAqLw0KPiAgCWhhbmRsZV9jaGFuZ2VkX3NwdGUoa3ZtLCBpdGVy
LT5hc19pZCwgaXRlci0+Z2ZuLCBpdGVyLT5vbGRfc3B0ZSwNCj4gLQkJCSAgICAwLCBpdGVyLT5s
ZXZlbCwgdHJ1ZSk7DQo+ICsJCQkgICAgU0hBRE9XX05PTlBSRVNFTlRfVkFMVUUsIGl0ZXItPmxl
dmVsLCB0cnVlKTsNCj4gIA0KPiAgCXJldHVybiAwOw0KPiAgfQ0KDQpSZXZpZXdlZC1ieTogS2Fp
IEh1YW5nIDxrYWkuaHVhbmdAaW50ZWwuY29tPg0KDQo=

