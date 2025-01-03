Return-Path: <kvm+bounces-34537-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A160DA00D3D
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 18:51:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B78411881466
	for <lists+kvm@lfdr.de>; Fri,  3 Jan 2025 17:52:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 928171FBEA5;
	Fri,  3 Jan 2025 17:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1L8QxvE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3889F19342B;
	Fri,  3 Jan 2025 17:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735926704; cv=fail; b=DUdzEmbqVqV21PJiXf/jGwttUjCd10vnG4UEfkUieij5yuucT4AKQEVek6gGsIJawGyGOv/kb1hoaoCoRdQgoplz3CrVRiOMr/J3eT3O/XRnsroLB3pqPBA7TojVIv4RoqAlqYgz9zFSx5u95f/kaBmj8xbNyihU/+oxLfR96uY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735926704; c=relaxed/simple;
	bh=NgO2uZeV7VcBHHEYNgjpYG4cn/bAKthmQVFHudOFTr4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=RhR42NIK5xXj0MN7DQsMwfL5z/8qSPDJ0vuLhb/l+pmNI/lIINKoPSw+tYRDxqCG6rj4gU/5xAGpr9yH2wbdVlG1w22sJYLeEA+ZC4bQti5EL4LjG6GFVxOYRPNfUsOqleDGWuvDpqJyZgrYYWrM9etqfOKhksFf9UpPb9UVPkc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1L8QxvE; arc=fail smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1735926703; x=1767462703;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=NgO2uZeV7VcBHHEYNgjpYG4cn/bAKthmQVFHudOFTr4=;
  b=h1L8QxvET60P283oDdRRhgn0yTv8qqTdc8yEUR0y6ID7dV5wiUZOMWL5
   z/8rfUJmazu/hfg4fJT5oYafhFwlP5sgPu5A6j50z7x3TsoRYl/TiLTCB
   wAmP2z7ytOSpGDeY83InKWKQ9X+hcJyy0JA6yMYC5fC6Q5JaLPMFDFLwM
   yDqwXUNOZhjQ2Q0/c1ZrdS0i7L+CNkdOAeEMtZqDtp/TKXJtnwRzNWHxD
   J9fOePka5CcDLz9Vn7dwrMsY2aw0zc40QaUXBQO+neA+yMmmEPaEB7JnQ
   c/JkUCkDcX92LfIGg8IA26RvvfED4ho5igaP7xYQ7QSnCblPgMlIelx41
   g==;
X-CSE-ConnectionGUID: a3NI4TxrRpqj4IBWk2ML5w==
X-CSE-MsgGUID: EGWz3X0uRhSHbEgQC7CgSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11304"; a="36288076"
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="36288076"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2025 09:51:43 -0800
X-CSE-ConnectionGUID: e6RDENeWSV2btV1/vFzQEw==
X-CSE-MsgGUID: BhcsMarLS82DmWcaBUYKaA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,286,1728975600"; 
   d="scan'208";a="132693341"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orviesa002.jf.intel.com with ESMTP/TLS/AES256-GCM-SHA384; 03 Jan 2025 09:51:43 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44; Fri, 3 Jan 2025 09:51:42 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.44 via Frontend Transport; Fri, 3 Jan 2025 09:51:42 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.40) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.44; Fri, 3 Jan 2025 09:51:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bGF4JZIE0Grj3lPElahZTHsZayeD85DGlgIbf31TTQPgabLiiCXs/0xdu0pDzPZz373zFp3wi+LETDHm1YFYYpECP5jNGfP3yPPXW3yov298qk0+nUi3vddl8+Ql8DuZnI+paLaQ+zvahyHV3FHXLUO3NBrsx7x0SLBL4Qug+4SNvp3cpf1Be7o1ky4Q3usy+shrGEFDusdFWW/EjMWKzaRoSxR7twTcFJkYNJWOxlnwEIY63G4JxZJbiX0TIFG2fD/FU1BH7Ji+SXidvF+9JiMxO8xDYMN8tv0tSfuvM2FfPazN5INjOgdbzssb5A4ge5vOVwCtWeUR4nheCW3T8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NgO2uZeV7VcBHHEYNgjpYG4cn/bAKthmQVFHudOFTr4=;
 b=uXIYe/1SotNG7cAGLcNr+37oj7pwBUwy63HUznCjiBQhB53VXMBa4b5iJnmFDCQekcuxNSbI51qDkxp/APzr2l1kXNZMct6eYYYwSUz4CIoL5gUaXPV/zt5ppFATziYsZeYRRkIhQPJAdRUj8sZHeYQh7gkf5LRqG9MmLveiCHJm5M/Cf2iZrXxsZN5Gu2crn1BkGqt4nH2MxOwt0OuPe9GbTSEKC2to9DcfenMV/tdk0zcZMfUPoieFS21YEVzffkfM43u2tkSWRVZBkP30OPpskGSmvnZkHEMdd6rBVzt+6uIgMcy+iYDMIVrhZFZnrmCDXrqZZdtEWs+LpiQcSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MN0PR11MB5963.namprd11.prod.outlook.com (2603:10b6:208:372::10)
 by MW4PR11MB7079.namprd11.prod.outlook.com (2603:10b6:303:22b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8314.13; Fri, 3 Jan
 2025 17:51:35 +0000
Received: from MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9]) by MN0PR11MB5963.namprd11.prod.outlook.com
 ([fe80::edb2:a242:e0b8:5ac9%6]) with mapi id 15.20.8314.013; Fri, 3 Jan 2025
 17:51:35 +0000
From: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
CC: "Zhao, Yan Y" <yan.y.zhao@intel.com>, "yuan.yao@intel.com"
	<yuan.yao@intel.com>, "binbin.wu@linux.intel.com"
	<binbin.wu@linux.intel.com>, "sean.j.christopherson@intel.com"
	<sean.j.christopherson@intel.com>, "Huang, Kai" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Yamahata,
 Isaku" <isaku.yamahata@intel.com>
Subject: Re: [PATCH 02/13] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD
 creation
Thread-Topic: [PATCH 02/13] x86/virt/tdx: Add SEAMCALL wrappers for TDX TD
 creation
Thread-Index: AQHbXCHTA4Hofej770itHd3FzB7uKbMFV/0A
Date: Fri, 3 Jan 2025 17:51:35 +0000
Message-ID: <062f04c9b59e7dcd496cb626437580e8884ce895.camel@intel.com>
References: <20250101074959.412696-1-pbonzini@redhat.com>
	 <20250101074959.412696-3-pbonzini@redhat.com>
In-Reply-To: <20250101074959.412696-3-pbonzini@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.44.4-0ubuntu2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB5963:EE_|MW4PR11MB7079:EE_
x-ms-office365-filtering-correlation-id: 4dc7da66-0cae-48f8-339e-08dd2c1f4436
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|376014|1800799024|366016|38070700018;
x-microsoft-antispam-message-info: =?utf-8?B?MDlsZGZvdDUxUkMrOGZwUHZZSW81bG9lQnZKREs5TFdQNVF6MHVNWlIvNHgx?=
 =?utf-8?B?S0NoQzcwS1pZdmc1TlhQZE1sOExrcmFuZENTZEZLeDJxcWJHcFZYdWJQRFNK?=
 =?utf-8?B?OVJYT3NGbTh3Z3YwdUs2MnFaNFZrUTVQb3YxTWp3UGdaZmd4Yys0b09YWEc0?=
 =?utf-8?B?cExYdEd4VTU5VGVSKzdpTndnNk9WVmhyRjd1M1A3N3dZV05oOEtLNHlwVzR2?=
 =?utf-8?B?ZnAzSkdSTStKam9yME9vQ2w5Mnlwd0NSa0MwYWp3eW4zcjFiSC92Y3BMTEZo?=
 =?utf-8?B?bXNxR05ZRFN6UlBLNHlYenVEUXhlUGZNRkpXMTBVeUttQ0dMN25TS3VYUWJ4?=
 =?utf-8?B?ejYvQUkrNUpRYkt6Z00zRmZJTk1CRXRhaW8vcjNHREJreHdoREl0eVE5dUlp?=
 =?utf-8?B?Vlo4QXBEYmt2ckgrcFFxN2JnblR1TkRnajFPeXJLcno5SDR5S3YzeGxDR3ZO?=
 =?utf-8?B?dEpPUTZwVTlmcU5vbFViSUxVZGVTK3ErWkp2elFJaElIeFpKU1F0cHRvaVVC?=
 =?utf-8?B?azViZFVQQmlQeTd2bjlqWFM4ZGpzLzRObTlLSm1BNUwwMXhMRkVpM1c4UGVn?=
 =?utf-8?B?WnE0bFJqcE5xMXp1VWl1U1hRYVBrMDd2Sm9MaDIxVDBqUStSckxYemRobm9B?=
 =?utf-8?B?ZGVVUlBwRGZOSHh3ZHRuYXFSYlJ3Ny9tM1IxT2lUMXF5SHQxSzRGVTlJeGlx?=
 =?utf-8?B?elB5Q2kvRzRIWXBmZEVYeCtjN1pmZFVFL0tYL1ZnVTRKdUNzb2ZhN3Y3Ni9H?=
 =?utf-8?B?Q2o5ZVRQanNGZGJCTlZuSzE5WG5BaEhKdTVVZ3hNeVdTbGxHdFBHeUhNbHND?=
 =?utf-8?B?bCt2ZlZXb3JROVJaVndoYUFqRXdPMHZDZVZIWTlNNFg4SjEzVCtjZzBZYy82?=
 =?utf-8?B?eHlMWTEwN1RmVlNZZEY3d0VwR21oSUpRS3gydXFaUm0rSDljTm9FWVRSNEEz?=
 =?utf-8?B?aXNRQ2UzaGRTclBnTktaVGtRL2xrK1ZvT2MzS3RCakxPcjV0RmtzdzZWakYz?=
 =?utf-8?B?UUVXOCsrZFN2OU13akM5SjJTMmtqMnlLdnBqY1pGQ3JrOFBMcUxPdzgxZ1lu?=
 =?utf-8?B?bGVwSTZQUU9FdzhqK0dWdkZmeVdtRUNabHFBNk8wRllVaUNKUkQveHdmc2FJ?=
 =?utf-8?B?eGZBb2VKMWZvdEFNT3VUSk1MelJwViszdk9nS04zNElmc0hYdk16MTRCaDgr?=
 =?utf-8?B?YlFOWnZVQmlTUWRiTjhvNERZdThPajQzRUR5UXBFb0ZUb0VQUENCN080aDhh?=
 =?utf-8?B?NFVLN0JML0pVdFIzSStoa3VZSWVPdDU1RlJIQ1BqYjdGQnJIYUtkRHE1Mm1W?=
 =?utf-8?B?bG8yN1o1eWF2VEFMazJCOVJ0dWQ2OUt5WnBPN0YvU3FKWFVnOXh3TElRQTda?=
 =?utf-8?B?bitmT1F1aVA3cGRwUTdPbUlVUzNFMjdWV0l1OGYrL3FBMDdKN2szczY2VWx6?=
 =?utf-8?B?Z0FMV25QN1YySFZ0elBtZVNPdjIxODVNQks5VW9MUlBnMVpTQXo0OUEwazIy?=
 =?utf-8?B?RGVlNExkNHhXVkNkZzJDbzh6Y0U3QXpyaFJrMm90bi95dnRUMzF6dlRnYnBB?=
 =?utf-8?B?dmxpQmhOWVdPY3lOT09rZUtSRlpkalUvQnlrbzdkcUpUd29JZ0J0RHBYZFBT?=
 =?utf-8?B?NFpsOWZ2T2szejVocnp3eUsvNk1NaGpKT2hBR1N3Rzh6N2JQQXZaTkZvcmtJ?=
 =?utf-8?B?bWNiTzdYSWpBRXI1eHFYZmRQSmNzV0lnd3BpeitsUzlYOUhRY1dQNlFuMXd1?=
 =?utf-8?B?d2M5RVhkYnd6SUMvQytZUVBaakZTT0daSUhLcy91WWFySGxXMW1CMkIwM2NY?=
 =?utf-8?B?TURVMS9ybGsrNEp0QmprVHlHQ1NhNC8reE41aUhVWHNxWFV1dUF3RXNYdmYv?=
 =?utf-8?B?Y0czM0Q5enErY1VtN1B1SjhRMGV0eFM1dmFwemEzaXlybWUwNTgvZlc0V1Fo?=
 =?utf-8?Q?qUm9yqr4RKrUh4sez9dPuyeiAUuDi4OY?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB5963.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?U0FVd3RqcS9uRGt3UlpVUSt0QkRwclQ0OEJkYVJIaWc4azA5NCtodlZUZklw?=
 =?utf-8?B?QUU2WlR4ajkwWmZqcjdOeU9RS2l5cnQ5amFTTGhCUkh6dmMvUldJTDlvSVFm?=
 =?utf-8?B?OHdKQ2VheCtSRWx2TVZzMk9IVW9mRDFxQ1VSeG83TlBzeUZPcnQzS3FlZXFG?=
 =?utf-8?B?ZjFkRU96NnM2ZlI0OGtwUjk0d2t4QjJQZnpkSWNhYWJrWjJQcEVNVTN3Tk5H?=
 =?utf-8?B?Lyt4Q01wRElhUVpPdmNuZFYyWVMzRGdCWi9XdEN5K09CR0RLRU1CUk0yOHJF?=
 =?utf-8?B?R2ZtSUsrUkMySmIyOUZDRkNOTk5mK3A0UURvUE84d0dtYmgvL3A3aDQyMTJY?=
 =?utf-8?B?R1JXVFN1U1JOUWhnTWVpQ3FJMEhhcUtGUExhNXhsYktuN2hZY1oxYS9RWVp5?=
 =?utf-8?B?UjdyOTRiNWlXY1U5RHBLdGVpRHZiTDZDWnh3cTBVNitjTEZ2dVQ2QkpMMlZC?=
 =?utf-8?B?UVp0ZWF2dFhWNHNheG12YW9oaUs3dFR1Mzh3WWJXT2tsMm9CUTArY3hDVCtn?=
 =?utf-8?B?UzMyTFNhak1GU1FTUk5GR3pSd04veFpjWjBKSFZMU0cyQ3pnKzVEblIwR0Iy?=
 =?utf-8?B?eXh2WHBsL2JEZURubHNqSjBCMnFZQzJKRXNjZngzaS81TXE2MXh3Qkc5WlNC?=
 =?utf-8?B?QjY3RHNNRXowMmt6dWxKN2ZoZzRBS0xzWHMrbmh1YUFkSzI3T1c1U3h6R0Z3?=
 =?utf-8?B?QWdDTlBrVkJBRzJMbXE1cTdQY3dEUkx0UXgvNFBJREFIMVdybTJGQkNJODZr?=
 =?utf-8?B?VjBwRHlGa0I0MUx6bWd0c01BU0UrTkd4a1JUcmFqSU90TXNENE13dGRHWStq?=
 =?utf-8?B?T3JFLzltaG9BZHN1cDMzVjRGZ1U1K2dQVGFlcVJpS3JSbnA1ci9IYUJHQkRn?=
 =?utf-8?B?RWNlek9DS0c4TUxTaU4rYkV0LzJkYkpZMDcyNUNuZ0VJanpMWVZyRWt2WllU?=
 =?utf-8?B?eGZpMjc5N0IzZHdBWFJuUDJQOHY4THJSSFYxRnVGTDJvTnNwOGdPQjFBeDFx?=
 =?utf-8?B?YVdNNkswUWFDMzFTSStUbDdlaURvL09pczV0Z00wck5RR253MGdkUENwRk4x?=
 =?utf-8?B?N1lWMllzdXRSY1UxNi9janoramZOc2xBVzlNN0xYTTFMdVZlRGwwVUNVZHkv?=
 =?utf-8?B?RGVyRHRlbmV0UzJvcjE1Q0pkRGg4U3htY0UxN3VSYU40bTRZYVM3VTVJV21v?=
 =?utf-8?B?YkZ1d3M3Q0xVZ1JZc25LUU5IaTVkVG1Zc0Z2MGtEK29iRG5UVnNKSTdTd0ts?=
 =?utf-8?B?aFBjaWFXTmR6aEd1MWRUTEpkcUJ1WWV5VkRxNzJRVkdnYTFaeGtJKzhIU3h6?=
 =?utf-8?B?VXdEWHVHSGNCU0RuTzNaSHIwSWQvditsKzdDN1BnaGxwbnhYMVo5RXAxOHFF?=
 =?utf-8?B?TVg4THJKZHl1NzdrMC9INDBvenNDdVVwaGdmT1cyT2lwSnVXWEVvTkNneXlq?=
 =?utf-8?B?M1FxT0tNWUZIRFQ4aFIraDkzOGRKRHJMM1BQS1N6cFdoNTRZRy93YTdPNU1F?=
 =?utf-8?B?SDJXVVVHdU5UYXZKQ3BPWW5uU1lxYzdPT0lJVWRRM3d4RHB0aHkxcVM0aldm?=
 =?utf-8?B?VStRcDMvTzRQQVVEdnZKend1QXBoY1JqYkpHNmw4R2ZiN1FOekFWaGxaWjdD?=
 =?utf-8?B?cXdPTEhQN2RMckNvT3pka2h2RnQ5MjJzbXNUNWJ1K2FXZERrZHdlSS84akFo?=
 =?utf-8?B?L0JSZlplS0xWOWJJeVNOUjJlMStvMTBzWjU4Wng2VU8vNk81ejUwYUdVRlVD?=
 =?utf-8?B?UkZIKytPQjVNa2tZbE9qMXFjelgyWExvbUVPQ3c0UnY4bjRrUHViYVgrYSsz?=
 =?utf-8?B?NU5XUUhvYkJrMjhNeE8zVmdKVU5UV0lrNjNGWUxBdzlaVnQyQkQ3NjlrUmx3?=
 =?utf-8?B?SSs0TDAxa2IzTFBvQ2dtOHpJalc0bUdkQnhrUk5RU2ZkcWFCTDdlUkRHUlg0?=
 =?utf-8?B?NXN6TU1NcGlUekNZQW5jOTFSMjlvVGhLVURwV1VHbitPMkp1bDBiOG1hWnd4?=
 =?utf-8?B?Q3FSQzljTVJ1eUhWRTBMU0lWQ1VIbzRrcDZKTVZEVkhOdFFKYUd6Zk1RUWk1?=
 =?utf-8?B?akhCMGFIakN5NG54M1Z0RHh0TUQyNlpHaGY5MUNzMnN3UlUzQWd4cURTNUky?=
 =?utf-8?B?c04zdWFSRi9HS2xqZXZoQU9SdWcyZDRmSGlmZXhOU2o2M0ZocE44dG81b1lJ?=
 =?utf-8?B?RGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7D0641DB6EE20C4D9830B72CF31C4332@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB5963.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc7da66-0cae-48f8-339e-08dd2c1f4436
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jan 2025 17:51:35.6366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5NfQ3yWxeTbY7jUEqaAkev/6bj40QuIw/ld9he/O92aLJ9v4zUNJtwzGbRuunMOuhyjQV94C3VsisJSh+KHCmu4yDS9yt6qc9m0mkGMNhCs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB7079
X-OriginatorOrg: intel.com

T24gV2VkLCAyMDI1LTAxLTAxIGF0IDAyOjQ5IC0wNTAwLCBQYW9sbyBCb256aW5pIHdyb3RlOg0K
PiArLyoNCj4gKyAqIFRoZSBURFggbW9kdWxlIGV4cG9zZXMgYSBDTEZMVVNIX0JFRk9SRV9BTExP
QyBiaXQgdG8gc3BlY2lmeSB3aGV0aGVyDQo+ICsgKiBhIENMRkxVU0ggb2YgcGFnZXMgaXMgcmVx
dWlyZWQgYmVmb3JlIGhhbmRpbmcgdGhlbSB0byB0aGUgVERYIG1vZHVsZS4NCj4gKyAqIEJlIGNv
bnNlcnZhdGl2ZSBhbmQgbWFrZSB0aGUgY29kZSBzaW1wbGVyIGJ5IGRvaW5nIHRoZSBDTEZMVVNI
DQo+ICsgKiB1bmNvbmRpdGlvbmFsbHkuDQo+ICsgKi8NCj4gK3N0YXRpYyB2b2lkIHRkeF9jbGZs
dXNoX3BhZ2Uoc3RydWN0IHBhZ2UgKnRkcikNCg0KdGRyIGNvdWxkIGJlICJwYWdlIiBoZXJlLCBh
cyBpdCBsYXRlciBpcyB1c2VkIGZvciBub24tdGRyIHBhZ2VzLg0KDQo+ICt7DQo+ICsJY2xmbHVz
aF9jYWNoZV9yYW5nZShwYWdlX3RvX3ZpcnQodGRyKSwgUEFHRV9TSVpFKTsNCj4gK30NCj4gKw0K
DQo=

