Return-Path: <kvm+bounces-34722-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EE45BA0508F
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 03:22:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB0A5165791
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:22:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5708D15DBBA;
	Wed,  8 Jan 2025 02:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WFfrwtgH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED7C31DFFD;
	Wed,  8 Jan 2025 02:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.21
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736302947; cv=fail; b=iThImtwHNfCjzOuMy8H/jRqoVMjiQ5fT9xBvzaJj+eYrPqLaG40mzw4ZFJ2xhyCgWhI92i8U4f02/imMrlF8wGu25Y+tBr9kjTdzMm1USJm5Wxr9JHHYYmfro+zyTxA9dn2IlhHdbxEq2Abub0AkbrdJcu6NvOKcIkeZNAu6YYw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736302947; c=relaxed/simple;
	bh=Yp3vcgpehKqZzTrUADm4Uk7i0/YZBdxsQAACrgyCf/A=;
	h=Date:From:To:CC:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=prn9ap+6ZWNcLkgkhhGSpLzif5u47U6E70Kzug95ZOw0CXg0coIwI+FEt1zDz5zkuu54JtLJ5W3Bf5wVKXxmhdQ/SNvqJNEVM/vP7t6P/sNmOTdai3TcR3AYb2Bn4UZYjA58k4+3VkKf10ozjJwTJbpM2dPxWuZLt7+yDkbWbfk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WFfrwtgH; arc=fail smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736302946; x=1767838946;
  h=date:from:to:cc:subject:message-id:reply-to:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=Yp3vcgpehKqZzTrUADm4Uk7i0/YZBdxsQAACrgyCf/A=;
  b=WFfrwtgHhPh/hawB0RF5Na6QXQxdlXGlqD2A1eDExqEvW8tnC7OD2xvO
   VnnqPEHOrnWrxY6H1pVaPq9pzclNomNDYARbDUpLdMCpik5C6A+Nishgq
   DTu+niCm690/nZrBemo/EW+fQqCuRL3Qb1UFKCtP/0La2zcWhYel8/FRe
   1ZXLHDPMhk/3p9xchv85c0aXjK6XbW5x+zWCsRBA2pjM3JBOe6iYOJrfL
   cdXvWMuPwZuOCfdovJ/GT0hrEeXcbQ9Pmq+vwibClwpeRIOCWTcJ0OZOK
   UgLeHRMpSG6U9T4RG6JRws1UavdZkkruNKRrBcFMb/yhgoZWpwVgvzYJr
   g==;
X-CSE-ConnectionGUID: 72wWKP1JQ26H2bQaxyp31Q==
X-CSE-MsgGUID: IoIaxRBcTHumv7MaisO80g==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="36395352"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="36395352"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 18:22:25 -0800
X-CSE-ConnectionGUID: tWCqD1plT3OFtpW6MEOByQ==
X-CSE-MsgGUID: JVygiZzuRLKcnUBC4brbwA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="133839837"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmviesa001.fm.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 07 Jan 2025 18:22:25 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Tue, 7 Jan 2025 18:22:24 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Tue, 7 Jan 2025 18:22:24 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Tue, 7 Jan 2025 18:22:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=GdFbGy7sfVTcmyRNht8CWP1oQ4UYeVHKldgwLkpUfZZeeSAtxtAbJ+J+Ew+m+y7E339gb2ZF9IPaOkZ4JWrSAMAFPzqWiNW71OsAjLpY01LyZ2rpuBvKwCf1IhlSuQ8mq3Vy6ldeOgjWWDkKl0rDfxjCamBmx1H3A/S/dhY/pArlvE/GHRmk8tfiMUh3cfLBvnsO7jnioEms3mwlTv9w2MX+R0TZnw8jXNAW/ORCFmSvorB80iETyTW4YLkb5/7DIzDfHNenvQno3xff9SL6bDOJgd/dICQGC0G/uN1PGIV+woOPZzet8SP8kH7I7oZhI+U3GuW1dLO0SkH29K07uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joYRtT1OZLLz0DlWs9sFhV3jm9a+r36h88z785KZEFY=;
 b=tJmJd1VKoX76V7LZKJPFYgbxCI/g4UoQJ0MHuej8LRQT3e9gaTcfdMzEbSYkjLcUQ068knt2KvxEr4N898UoGGgsrgCygCTnCNOCsPKnHXGrdvnEXNeUj/SKm6CPboTEpnEI2Npwbs2+bXwNoI5ZUkxpHBbuTpkS0N/MaUcSvqKS8mv8kWMI8aQz7eGeK9Z62uX6qgfpB77JI65JdSxhu8eq76K2dI4dsridbzB2pO8kzy9YXRgHGvHEFLE8hj921LwmLzYyZ+QqPvPZ9Ri05hTYyimxU5RLER3fnn2U2py4cLnlWasJpEJanHKN86f2YyTLQnkE/SpN9sclH3/ZmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DS7PR11MB5966.namprd11.prod.outlook.com (2603:10b6:8:71::6) by
 SA1PR11MB8860.namprd11.prod.outlook.com (2603:10b6:806:468::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8335.10; Wed, 8 Jan
 2025 02:22:22 +0000
Received: from DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca]) by DS7PR11MB5966.namprd11.prod.outlook.com
 ([fe80::e971:d8f4:66c4:12ca%4]) with mapi id 15.20.8335.010; Wed, 8 Jan 2025
 02:22:22 +0000
Date: Wed, 8 Jan 2025 10:21:27 +0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>
CC: Sean Christopherson <seanjc@google.com>, <rick.p.edgecombe@intel.com>,
	<binbin.wu@linux.intel.com>, <linux-kernel@vger.kernel.org>,
	<kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86/mmu: Only zap valid non-mirror roots in
 kvm_zap_gfn_range()
Message-ID: <Z33hJ8mcnu6xKnvL@yzhao56-desk.sh.intel.com>
Reply-To: Yan Zhao <yan.y.zhao@intel.com>
References: <20241115084600.12174-1-yan.y.zhao@intel.com>
 <CABgObfbukWu5srwDGA-orsd35VRk-ZGmqbMzoCfwQvN-HMHDnw@mail.gmail.com>
 <Z2kp11RuI1zJe2t0@yzhao56-desk.sh.intel.com>
 <Z3xsE_ixvNiSC4ij@google.com>
 <CABgObfa=t1dGR5cEhbUqVWTD03vZR4QrzEUgHxq+3JJ7YsA9pA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABgObfa=t1dGR5cEhbUqVWTD03vZR4QrzEUgHxq+3JJ7YsA9pA@mail.gmail.com>
X-ClientProxiedBy: SI2PR04CA0005.apcprd04.prod.outlook.com
 (2603:1096:4:197::16) To DS7PR11MB5966.namprd11.prod.outlook.com
 (2603:10b6:8:71::6)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR11MB5966:EE_|SA1PR11MB8860:EE_
X-MS-Office365-Filtering-Correlation-Id: 023372c5-2b5f-411d-8d9c-08dd2f8b489a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info: =?utf-8?B?dUVlV3FXdS9UUDdrQmFyVU5FV2ViT1U3RnNIdGkzT3ZkOCtWaUNSL2tiTnE0?=
 =?utf-8?B?cDJQL2ZzS0VYSzBYeFZpNEF3aldJYTU5U09jUmZLZmNGVGYwbHRvRGpHZkhB?=
 =?utf-8?B?OGIxZ0pkVUdaZjRnZjhpc0QyVW8wYkRLNkJ6Mkh5UUJkbW5sWGROK255T3BI?=
 =?utf-8?B?Z240ak1pV1Y3dUpSbVBDYmtpeXpIZEJZM1V4NUpEUmIrTVo1bitVT2syY3Zs?=
 =?utf-8?B?MTIzVlp1OStleU5QbEhTSE5JUHpYOU1JWW1KS0tjZGFrY2hzbnM3U01UM1h0?=
 =?utf-8?B?cVRBMDJwWXZxczlTekthZzVGVHkxcFNscGl6bTF1RFNhR0FTVElCdlBWdmRm?=
 =?utf-8?B?WTIzelVTUUJRRU1hYTNrNk9RNWtxWVhtR3ZWa0xsRWNkZit0ZjZVekJVRDA1?=
 =?utf-8?B?ZEh5WDE0dWM5b1dZa093ZkxWdWFsZUhsZW5sWS9VYW53bEoxWGt5cFp5bjVx?=
 =?utf-8?B?MkltZmtpWWdmUCtOeVJJeDJrZHBMelY1QjVDNGdEK1RRMEltTkNLUFlTYXpa?=
 =?utf-8?B?ckQ4dTI2Q0VMbXpkb1I5OW1xcDdKUjlFZWR6NVJmdy84VnNrS1hIRWkycldL?=
 =?utf-8?B?elBKNlhnQWxtc1A5NUZ1dkxoKzFWc0FGYW1yZXhkOVZIbkNhd3VlTlErVVBP?=
 =?utf-8?B?Rkg1VXhQUmtscW95KzdLVCsrRCtrb0ZObU1oZXNkVmYxdEpkVnVrMkY2NTZO?=
 =?utf-8?B?dnZ6c3lRamZUNE5mdWpmMUlhZW5RdkdPT2s4bjN1TlZmN3kyTHlBbDI5MWxt?=
 =?utf-8?B?dmVPVmJhKy9aMHpOVHRMam03S0dyZ0hMTkJQTEJOSnBvc0tpSjh0eVdjUWs1?=
 =?utf-8?B?bkZaRVdQZDc2eVVjZWNDUURLbS9lZWU4Q0FmVEVpSVlXKzNOMGkwS2NJTHRF?=
 =?utf-8?B?eEdxbjQvaSsvc2FocTF5WGlUNGlMKzNoa0tjNXljbDJzZ3FxNEphSVN5WXkr?=
 =?utf-8?B?RFIwMmFVc0VubFA1TFI0WDhPK244MXJQMzQ0MS9ZVmRKbkx6ME4rb2NDK3ln?=
 =?utf-8?B?TC9aTFBZcHdvS3FRVmpRdGtQQVZDNlJ2NXFiSGtJQlIrbzNHSXRQWFZ4cUky?=
 =?utf-8?B?dHE1UjlTbGJ3V1dQVXRTL1kvaU5GaVNlYXYvTkhMQTVFeDdHMk83M3RUdmV3?=
 =?utf-8?B?OWhPdDRHUWQ5Unp3cURFMUtwa1NFQlRidmduNHhpc1MxTDJ1ZHhlbktkU1Fp?=
 =?utf-8?B?V2IxQ1F4d1l6cDJpRmprRUNXTHBJSllmU1ZUcGU0MGZqTmJZWU9mWmpEVUlD?=
 =?utf-8?B?aEVhdHRQbFQ0Vi9raFJ3UDZWV3pIOCt2aEc1amtCb21JSEVrUWMzcVQ3RFdP?=
 =?utf-8?B?eUN1ZHR5VERSV3Z2OTNNR1dBR2c1akVDZm1TNzRqK0o2ak1kdEVCR3pzcDkr?=
 =?utf-8?B?VlVIQmdIdmxIVHVNTFV5dHUxOUxvSWg1UkVTY1pvOFM5bHhrbDR1UmkrQVdT?=
 =?utf-8?B?K2dPS1htengxV3AyVGJxZkRORG5RZ24ra1dHbjd6ZnNuOFdDMVRlSjI1VkUr?=
 =?utf-8?B?MFVoNy9MUHA2WVZ6VzZwNjVSOGgySEdORVpnTlR1YnpCMWpjVG04VGdTM2Yw?=
 =?utf-8?B?Qkc1Y1FBeDBreHo1Skt5NXhhbnpTZmVRcUQ2cXVCZkkrSkIydSt5NEFPY2I2?=
 =?utf-8?B?cUxuM2tnR1oreFdjaUdkRTlScXJxOGV5Y0dXeWdzaVhrZGV5bVJ3cXROa3hQ?=
 =?utf-8?B?UnQzazVFaXVySTFJZFQwblFXSkNsc0E5cFdzcXZGN0hWa0F4MVNWbkMyUElP?=
 =?utf-8?B?RlUrMDRzUWpFZmlXVC94MDI1VmF5dnZ6RExMZmwyWnRKQmdnSXo3dVlDYTRm?=
 =?utf-8?B?azhaaDZFeVV4K1Z6TlgxYkNTeTFUak8zYnQyOHNiK0srOFV6NE4zSkw2WEcx?=
 =?utf-8?Q?FmeSCffzdZxXo?=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR11MB5966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmlHNTI0ZU03ZDRpd09kd0ptTFcyVy90QWFNT3NXZkxMbXRGYk4rZ0s1eFFX?=
 =?utf-8?B?a1lJTXBWZElSRUtxaDl0L1I0NStZSWVUSnBTdG1qeGREUDh6REtyd3FaaWJv?=
 =?utf-8?B?aUxmQ3R4QmVDTENhM2lsR3dRSmdvOFQxK1BrWVBmVWxDSEhHemZ6MTd0NTNM?=
 =?utf-8?B?QWM2TE1wQWpVM2lTNktzMkpmZy8ycWd0YVcvUHJuN3BVdTlJVGZiVXlFeHkr?=
 =?utf-8?B?VERNTGptTkdXQjFyTExKY2ZuS3JMUkdsNlIyWE1hcjUvcDlVQmF1V3B0cDIr?=
 =?utf-8?B?cWozY0xRcnlTaFBkTjlYSVYvTDhLL2xOV1M5dmZoS0JBUCt6cExGeFpTUkhm?=
 =?utf-8?B?RVlpRGhCZllOY3kvNURhaVRzalpCVjlIcnRURytjOVk1bTZSeUJwZENqdGRI?=
 =?utf-8?B?c1g1L3JBVmhLY29mSXhtNGp0dStvL3dzWUdTRDBpa0lXK0tuTnNmdHhzdFZF?=
 =?utf-8?B?cjRIY0cvNUhZK0VNL2hjNXFLVXpIWnZvSE5ibzdUVWo0M2ZKK1JiOXhhSHd2?=
 =?utf-8?B?WmExV1RROU9jb1VtV1BETjBoaEsvT3hBY01IRDlsRXBqc2c5VzZmNlgyMVU3?=
 =?utf-8?B?VHVhRkl6alpoMWttcXF6Uk54R3RNbjY3ZFRNbXdMVXFRRnliSGRJN0xIZHFQ?=
 =?utf-8?B?K0RVeEJIOXYrcUt4RWwvcUttZnNjQk00RFE5cjVhem1EWHZ2Z2FFUDVBaUs1?=
 =?utf-8?B?Y0RZeDFkZGRya1VzTnBtSEh4eTJDeFlxeGlTbGpWVFJUTHl5L3lIYWFiZmd3?=
 =?utf-8?B?Q3ByNTN3WkZweWpQeWkzU0ZHcW1BbFlWRkErbUdiVlQ2cldDTDdzRGdVUmw1?=
 =?utf-8?B?RS92cDFuN0FuQ2M2aU5wVSt5NFpPZWxtcWRXcWtiY1dQenpzaTFVd25sK3lk?=
 =?utf-8?B?aEw4akJtR0lZc2N2WitKdEZ1blBpd0xtalFjR1lmOW84MGtIU20rTDR3RmZa?=
 =?utf-8?B?NFJXU0piS3VlbzI2bU83RXVrb2p3QnQwM0l0di9MV3JmbFVESjFqckZBNElt?=
 =?utf-8?B?MXNEN3BkR2ZRcjFlcTRMS0NUVHVucUlFeGJ3YzdPOVg5amE1dTNhRlRxSTkz?=
 =?utf-8?B?aW9wbjkvZEVHK3NQNFRDOFYyQ0dxNzR6M21FZExCdVVrWDVqV3NRNVp4MzBP?=
 =?utf-8?B?a0U4MVI0c0hWdW10cG1uMkxsQlZzelBaVnlMa3lOdHVLNVlkdjhjTjNlV3da?=
 =?utf-8?B?elJIUG9rZTZKb1NPamhqZk5VU2I1MWsvVUJWK0JDTG5ReUdmWWJkSTl4MC9p?=
 =?utf-8?B?SG9UVUVQTnVXdWhTdDRLN3c1Y0JPQVlRSFc1aDJxNUIyQjBaa004aStISFE2?=
 =?utf-8?B?aHdpS29aekdxc3RYdC9SenJDK2ErL25YeHNqcU4wWlN4anhiaVdmckY2aW4z?=
 =?utf-8?B?NnNXRk1oZklqckhWdmlocWFpWUxCZzdWNzdYd1VweHhHTjl4dittcTA3WERX?=
 =?utf-8?B?YU5KMnM3VzhSWnVueDVvRS9MeWlNem9kMWtMYWZKOXZzN2hjMDhLbzZxRWNL?=
 =?utf-8?B?ZVZqQWJYRURNMXA1YjB2TmFvQkJneFZkVHFFMXpVSlIwZW9vbmRLRXV6RW5a?=
 =?utf-8?B?YzJZTGNwcytwRGJvRUJ5VTEzeUp4U25ZYzdDWGlNWFRVZGc1ZTljd2hsaDZu?=
 =?utf-8?B?K3p6bFpXSEhpQXNwTEhqT00vTEhiSmtlVFFQRXZ2Zm9Xc1VUZUhYZGJTblJj?=
 =?utf-8?B?R2MzNlJua3RIa1lnNmwxV3VWblRMS1BlWDNnMTlxL1JLN09sVGV6NjRISHFR?=
 =?utf-8?B?WE5GVTRWOVgwZTZpYi9Jc0dZVWN0RkV4cGxYTmIwNkU0blhuYktEbStoK1Er?=
 =?utf-8?B?dHZWUDlzb0poUS9ZVk1GdGxFSlFudHhaN2haRnllTDZwVW1JMUhyVGhPMWhO?=
 =?utf-8?B?Z1BFU0xod0QzRmZpNkI2MkNqVHBhNjdscG9ndkhGRjJVUkIvNTUzdEh4bXRx?=
 =?utf-8?B?MFdwelRGYi82aWllMHlLbVBxS3QyYWZqOSt2US9tZ0N5akdvYzZaeHhKaFhW?=
 =?utf-8?B?QWZsTStKbW9xSC80RUVzTkhWeE1ZTHRsNGRGVFplbHgvTXVnYkJwZ01KUlp3?=
 =?utf-8?B?Z3pnYVp3T1p0dzhmanZweFBSbkJhUzNFdzhjZzVDVVpWaEV2RHNEVFVnYzkz?=
 =?utf-8?B?eTMwK2pjaHljZXp1STdpVGxpR2Y0WWVYLzluaThESUZPOWdsTjBRQ1BHVzNX?=
 =?utf-8?B?c2c9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 023372c5-2b5f-411d-8d9c-08dd2f8b489a
X-MS-Exchange-CrossTenant-AuthSource: DS7PR11MB5966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jan 2025 02:22:22.3144
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2tNWYPIX+n+otN6YgV0rAForOMsTuu7UbFbIg7y7qvza8kikzTYcM3snuiCK24iPKoSaGZ/4Mo58aDp+xLjNgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB8860
X-OriginatorOrg: intel.com

On Tue, Jan 07, 2025 at 03:01:05PM +0100, Paolo Bonzini wrote:
> On Tue, Jan 7, 2025 at 12:49 AM Sean Christopherson <seanjc@google.com> wrote:
> > On Mon, Dec 23, 2024, Yan Zhao wrote:
> > > On Sun, Dec 22, 2024 at 08:28:56PM +0100, Paolo Bonzini wrote:
> > > > I think we should treat honoring of guest PAT like zap-memslot-only,
> > > > and make it a quirk that TDX disables.  Making it a quirk adds a bit of
> > > > complexity, but it documents why the code exists and it makes it easy for
> > > > TDX to disable it.
> >
> > Belated +1.  Adding a quirk for honoring guest PAT was on my todo list.  A quirk
> > also allows setups that don't provide a Bochs device to honor guest PAT, which
> > IIRC is needed for virtio-gpu with a non-snooping graphics device.
> >
> > > Thanks! Will do in this way after the new year.
> >
> > Nice!  One oddity to keep in mind when documenting the quirk is that KVM always
> > honors guest PAT when running on AMD.  :-/
> 
> And also when implementing it - the quirk should be absent on AMD.
Got it!

