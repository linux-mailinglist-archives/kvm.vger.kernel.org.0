Return-Path: <kvm+bounces-60012-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id AC6E8BD8FD9
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 13:24:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E7A5F35200B
	for <lists+kvm@lfdr.de>; Tue, 14 Oct 2025 11:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD6930BF70;
	Tue, 14 Oct 2025 11:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="m6jbfmeV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0EC2F8BDF
	for <kvm@vger.kernel.org>; Tue, 14 Oct 2025 11:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=198.175.65.11
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760441091; cv=fail; b=OrEpQ3oDPP8V/O2YBr1vAZ5Ae/D7NT0q2ZtLQqOQh/bdNrpJlE1sMy02j8ZlYC4rvj4MWtOCJAWKHT1szk7yeiVTEK2hCL0T0pWJLfcZQsTbz39I8KrrD7lalGrKK4CEpNjRpIilm2FZIUdBrY7MAr+8bYXyIZTRAvzZySdZPD4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760441091; c=relaxed/simple;
	bh=St80btAeBwcuSIfbF1s7CriUFReXwuSKpXtXqOO1s+0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=LBobYqnREJ0ov3gddywKObgsZa6M3NhJjOrm+e9gkEN8+aFv41I5KXV8l+o+ZjlHP3mD1TRHJoA+hstpwvjUmFBxYxb3Y3v59ZwtC6X3QQsdMubsg57ZcJ8T/mJOVjoWu75TjoE5JHJxqxUj9zrGB4hT2hcvnz/budWNlalWrt4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=m6jbfmeV; arc=fail smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1760441090; x=1791977090;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=St80btAeBwcuSIfbF1s7CriUFReXwuSKpXtXqOO1s+0=;
  b=m6jbfmeVSX/C1kKkOh7uZKLPzGU4MrcIDLibfW6U1kXfyHyyZwcDI5kT
   BZE2sqLWYoThZ6KKjic2qVHI+pui2ey9jr2OyVPI4O7M9Wb9wvJFkTQi4
   4vfCRCi4lDVdcrVFBfO/8vvNVNrXUe+BdahnQx1rEUCYbErMMnnHbFt0E
   hUkekzawNyXOtvnzniCMLuL7jONvDaw5PNvVZcoC6fCv5TvwJHNlJam8B
   dOEaPKJyIkPITSwQ19RwD/fbGki3XUpFZqjb5/zaEUWczcZkEV15vcyho
   S0ZxQ3v5GRpr9FkXH/3g5JbPRNLDn/grP3OIK7FX1I7Y+Km6/ZYc9cxtd
   g==;
X-CSE-ConnectionGUID: BwUWeqsZRs+OFIm8ftKlbQ==
X-CSE-MsgGUID: kIZbATZbSdqrJ2fe9fEVgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11581"; a="72867094"
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="72867094"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 04:24:44 -0700
X-CSE-ConnectionGUID: wnuTHj/cQ8Wmv5U4pcCruA==
X-CSE-MsgGUID: bBGeLnE7TsiXZF/tS5eq7Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,228,1754982000"; 
   d="scan'208";a="181407504"
Received: from orsmsx901.amr.corp.intel.com ([10.22.229.23])
  by orviesa009.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2025 04:24:44 -0700
Received: from ORSMSX902.amr.corp.intel.com (10.22.229.24) by
 ORSMSX901.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 04:24:44 -0700
Received: from ORSEDG901.ED.cps.intel.com (10.7.248.11) by
 ORSMSX902.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27 via Frontend Transport; Tue, 14 Oct 2025 04:24:44 -0700
Received: from BN1PR04CU002.outbound.protection.outlook.com (52.101.56.38) by
 edgegateway.intel.com (134.134.137.111) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.27; Tue, 14 Oct 2025 04:24:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=TG6xrh1CihfRRoSU3Nu6Xdo6EH8QNr/MF/4f3q6AxPBPMLiFAMHR8fpMPBVPGbUu1yVI+WpQFgJwaZUoF007A9uBKr6vaPnc6HYAwmrClnPlLOda7fonHIG8ny57W8uSaw8hEgt3iB7kq2caTYt9ZPK3qlnQFVPMymHlXRUaZqc872QESgJoYvj/ykylVL6mK+k6ZEj+a6YpTBoDHuitc6f+TETi5AJTbjqussr6W/UyIHhON/5t1eQwMMFqi23GYuFMC88Bougs4RmlQgbzvpyINuyTr/WYFneXFM/sL4B1Vzhfyfe1EYI7seun8JzSUEYt1rqBool82kWu9bdYLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=St80btAeBwcuSIfbF1s7CriUFReXwuSKpXtXqOO1s+0=;
 b=Fdp6e2RTO/eQFFS2emAzy2w33zJ2GGNo9xH6W6Xg21nwTT6IB0YIxr1MF4I/ZsRmqJ/awUEQX5fF1jfEPertx4NV1mjSgiZMBsFplC4qbBYN72c5n06b8XNY6aQxoR8Ed7YBZAwKeT1UOkuS0n4ohL9JRYySBU6ByMTMXPCLjwu2O1gwU21v4BZDLFlkcXp56K3D+HjbMyBxhHdiHdt1yz7BQdq7fs/HPD5shSiOfmy0r1zNMz5C1uZEPMvt9A+6/1T5mgho1XlIcgcwL/swrEj6+SGGNMzV4uxvNUuC0GtRfdctRckzVNTOPH9vnA6NFsaSkAdqFlAHXG7A5/L0sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL1PR11MB5525.namprd11.prod.outlook.com (2603:10b6:208:31f::10)
 by SA0PR11MB4544.namprd11.prod.outlook.com (2603:10b6:806:92::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9228.10; Tue, 14 Oct
 2025 11:24:42 +0000
Received: from BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66]) by BL1PR11MB5525.namprd11.prod.outlook.com
 ([fe80::1a2f:c489:24a5:da66%6]) with mapi id 15.20.9228.009; Tue, 14 Oct 2025
 11:24:41 +0000
From: "Huang, Kai" <kai.huang@intel.com>
To: "pbonzini@redhat.com" <pbonzini@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>, "nikunj@amd.com" <nikunj@amd.com>
CC: "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "joao.m.martins@oracle.com"
	<joao.m.martins@oracle.com>, "santosh.shukla@amd.com"
	<santosh.shukla@amd.com>, "bp@alien8.de" <bp@alien8.de>
Subject: Re: [PATCH v4 3/7] KVM: x86: Move enable_pml variable to common x86
 code
Thread-Topic: [PATCH v4 3/7] KVM: x86: Move enable_pml variable to common x86
 code
Thread-Index: AQHcPApCIgnK1em+RkOZgv/5nL4CYLTBgiqA
Date: Tue, 14 Oct 2025 11:24:41 +0000
Message-ID: <c6d0df58437e0f76ce9bdf0c3b7f5b53c81989a9.camel@intel.com>
References: <20251013062515.3712430-1-nikunj@amd.com>
	 <20251013062515.3712430-4-nikunj@amd.com>
In-Reply-To: <20251013062515.3712430-4-nikunj@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.56.2 (3.56.2-2.fc42) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL1PR11MB5525:EE_|SA0PR11MB4544:EE_
x-ms-office365-filtering-correlation-id: 7d0744e7-2e5e-4691-bdec-08de0b144505
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|366016|376014|1800799024|38070700021;
x-microsoft-antispam-message-info: =?utf-8?B?bXJZQ1VZeFhsaFJhRGNsMUJzdDM2RVczaVNnd3hNVDN5ODNvbndrcE5ybm1R?=
 =?utf-8?B?c0xGWTlIN3liSEJ3ajRqTm9EcUE2Y0tkSklPU0tReWh4UVJocy9YYUphUFR5?=
 =?utf-8?B?OU1QTGpGbHZLVVlXM1F0YW9SOHp5SFI0N3lxTVpBZSt0aUgza3k4dTJyd2dK?=
 =?utf-8?B?MDhYTWRxbmlEckRNUTNqUU5velVSajdUYU0zNTd3emtaQTJmVWdTSy9KOXVM?=
 =?utf-8?B?eGVKL2dFRlF0SjdjaXRBeFJyTGF2WGc5ZXY4OE1GNEhoejJjVGkvUjhtT3l1?=
 =?utf-8?B?ZmN1Y09OVjdkNTRnMUpnV0lwUFBFNm5YUlgvcU1iRUtGVWRPcWpBVUl1UFpw?=
 =?utf-8?B?dTlIMTN4RjdOL21CTlM2K1BHcGhqUkMvU0FGSzE4SzBJQ0h6Tkwwa2Y1ZGRG?=
 =?utf-8?B?SFBOSWR0d1NhbGc4bHMwYlp6OEtTYXlIWkkwaC82bDhMRW9EbjVEem45TXBk?=
 =?utf-8?B?WXV2dlduc290UW5RVHNCamVpTjJURnRTQWt0MCtTZTVCTm45cnF4QzBFOUhG?=
 =?utf-8?B?V3RUN05hRXF4TXo1TFdxQ2FPUEhjOXVOMEhFL3BNSXp6VEVZQTJVdFF2d3pQ?=
 =?utf-8?B?MDFoTmhiS3d4SGI4MDFPY3ZpY0VJTForVGRCaVY0SmRNYkNaK05oQVBiUGlh?=
 =?utf-8?B?QmR4SExDeGRLNUJEaS9Nb3VPalJ2MHhvUmYydmx5Tm9HcHZmcHFnaWNLaXFj?=
 =?utf-8?B?MTR0OXVEczdNTkw3MkM1TjZISHFramwvUlR2bHBNZ3NYZEFHN1h1bGJMYVVn?=
 =?utf-8?B?bU9hY3dFRFIyaVJLM0paRmJRcFBiQUFLSXAzVDRQQURTcko0T3BMWEZSbkw3?=
 =?utf-8?B?UE0wcEZHek9mZGxZL3FmbFFqL0JkU0hCY1VYWTM0TXRjcXBlL2x6bHhqOXBu?=
 =?utf-8?B?TEZiNHhmZmF0SUFQWDUvNEtmaWh6akZmQlJZRWZNNk12cDVYandPZExLNXh5?=
 =?utf-8?B?SGR4dHdzVmtkVUdiZGVKU0hmK01xazRwbjkwR1FMa3VwcHZGdVYyUk8vUTF3?=
 =?utf-8?B?WnlFenl0THIrNm5zWnBSNmxPUVFEeWlFU3M2WTBXQlp0U3ZNNnBMb3V0ZDhK?=
 =?utf-8?B?aGlxenc4TE1ERFIvbklhc0xaV0dxSG1mN2p4ZENFNFAvRHlodFJ1aXJ2Rng3?=
 =?utf-8?B?UW8vWERMZjR0UUtFNzdqOFNOdXNPa3lLZ1htUTF2WGJsV0xVOHRrSGhEZFJN?=
 =?utf-8?B?MkNwUzNnZDdaWDUxbFBMb01jQ0M3M3NCdFFYTkd4NXZ2ZXMwT2VpRXBUT3Z2?=
 =?utf-8?B?cHV0OVRCOHJBL1didlN0NEdhbTRwMFZ1R1VtVkt6cmtYdHBLanBLK3Jpcm5p?=
 =?utf-8?B?akJFSFhueFR1MTZBeXl0Y1M2UFBaU3k0NVNjM3I1b1lmZ1lGS1ZqWjRZenI3?=
 =?utf-8?B?K2ZhY0pkM2dtcGwwNlZsK3NTdnB2Uy8zSUFpSi9rUlBYa210dTI0VGlob1Rh?=
 =?utf-8?B?bThVa2RTRGFROEMybkFLSkVGdXJNUWdpMFhzbXVrZko3eTJ4a3JIL2JTeTRi?=
 =?utf-8?B?aDBlNE9jQVVYcmVKSldJc1ZXb293ZTE3eXAySit6YlVxcE9WajBHc3A5RlBI?=
 =?utf-8?B?dVUwV29hbmRXUW9MbGxEN1h6MVpaTGxtaVEyMys5MVZKTFZPVEZKblJ6REtV?=
 =?utf-8?B?eGhQRnRKZXNlNTQ5VXdtY29YSUhvaGszZ0ZhMURwR29mV3pnQ2YyZE5vbXZO?=
 =?utf-8?B?Yy9aeXh6enVjb3R5aVh3K0JuL2hiQm1YUENrZXg5Y3E4dnBiVS96c3VVc0V0?=
 =?utf-8?B?NWs0azg5VWJ0UWhPZm5taGFncTU0OEI3UjUrbjBDWTRsNHhpRHVjN1JWU1Jz?=
 =?utf-8?B?bmpza0ZnYndvbmFYN3RlUjUzRVZjSnpqNjc0MEZvTE9wQVhHUklYNTNBOUlY?=
 =?utf-8?B?R0x2K2hzajU0amR0S3NtbDlCSGhPNFljWEhKQUpZVUhhdmJOekdxcXhPM0xF?=
 =?utf-8?B?OTF3azMvbzV3bUR3R2ZzZDVkNlBZbVZGVkwyT0haUVZNMVBoREZTQS9uazcx?=
 =?utf-8?B?YXlHcCtSSTdTck1Oang0VEtvQ1JaWEl2SVQvVEVmWWpPay83WHR2YXZJY1BG?=
 =?utf-8?Q?Xsvk4c?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR11MB5525.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(38070700021);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SXZvVHdsT21GeDNSeC9PakxMdks1RHFFanVkQU1rVkRqdnRYRGt6cENkblVL?=
 =?utf-8?B?QVNtbUREN2ZhWHp1TVZNdUNlVUhnazRJZEVKYzdlZnZDM0g0ZHJnT0R3MnZR?=
 =?utf-8?B?S1dkeXFZeldMWTJrMG45TWZHMUFFSkp1OFBFaVNScE0yYkVSVVMxNjhtaFZp?=
 =?utf-8?B?M1BPTWpVU2dBbTJsYzB5SUlLemx5OGhDSjR3UWNMTzE1eUVURlBsdjBBNTFR?=
 =?utf-8?B?em9CeWVjQk5TTktHMTBxSWhrSzRwYXIvUnd3RkJ5OGxPVkU5S1lCT0VrT0NU?=
 =?utf-8?B?OVg4c2U1QmQ1VnBlbjI1cUp1ZnFhN3hDQTAycDR3aE1zZW0vVWlmR0NCQ1ZK?=
 =?utf-8?B?VFo1QUJLNCtnWlN4Qjg5aFFWSlN2aGcwMUtqMTlZTlhaaUVSaHNnNzZiM2hj?=
 =?utf-8?B?Y1B0cXR4ZnVnQ3BmVDh6NXF6aGJaWFpFblV1MGZIcDZQWUpJdm5hMUozUncx?=
 =?utf-8?B?TEFjZkRyamRTWlhJZnNFNjRuc0x4ZmtCd2xGZkJYR0FsdmpjOWxBZURPR0lk?=
 =?utf-8?B?TURjSVlDUXZ0ZlN0a2ZXVWJiS2I2czBQSCtxTnc3WU9aRzE5dTM4V1QxejZD?=
 =?utf-8?B?WVlPaTRQZW5xeWQ2SFZkQnlGQ0lCSlJqeWtXMnNXQ1pEQ05QcGlpK0drajBi?=
 =?utf-8?B?NTBNRVRKNzNRYWVXbUppRVRmVnV1T2w2RHlTMVgycjNzREh4TjZDUDlrN1lK?=
 =?utf-8?B?RlR2VDRpbDBmbzg4TU83by93ZVBPMXlJZHdaSEcyNk1lSGFuRktaaWs5NXRt?=
 =?utf-8?B?VzhZTi90SGZhZVJ2cStOQkNSWC81VmN0SUtpKzZubmV6OWFOb2FUKy96YTFi?=
 =?utf-8?B?djFGYk9YRWZOQzNWb0hDd1dETWFsSE13dmlkTWNrWFhqYmUwdW5TeXN5eG5V?=
 =?utf-8?B?bDJXWitYeTcyNFNGdXlFMTI5aXovaDhhaTRpN2lKc3dMVS8wQktxVHBFRTJ4?=
 =?utf-8?B?cnVzeTZRQmdFcFdnTjFrbHFFcko2YzNLbVZHUHFRZXcwOXlrM1VmNDV2ME9S?=
 =?utf-8?B?cVJUaHZkZ1hhb2xEcWNwRjYvSUkzS2M0REZDK01ROUFZQXZrNTdEb081ekRO?=
 =?utf-8?B?L0dHOGhBQjZvamlSa2xIaXF6UDNMTUJwZDNHZ0prYWRvb1lUcDdWZ1k4MlZ4?=
 =?utf-8?B?dHJYbnpXbzVPcU03U2svZFFqY2FiZERjZC9YbkR1NmxpdUNvckw1cWtnK2F5?=
 =?utf-8?B?Y1NKeTUxZkdsSEFtbmZqQnMxbnkvcHRXV0JzS1ZIUUdLZGNuZWdrYmdSR0tN?=
 =?utf-8?B?Um42OTJiOGRwbmg3ME5IdnpTOGhDZ2piZzNXQ055S1NJdERBWUxpdDdtMEtS?=
 =?utf-8?B?S1ZEQ3d3Mk45c2REREl3R0NEK1BZZ2UvN0hiNWNabEVTbzR6TVhUa3grRE1y?=
 =?utf-8?B?T2VCYXZJallGRWlmYUdqSXBUalNQRzNXaEtPb2tTSVM3YzRFSUNkTUdqM0Jr?=
 =?utf-8?B?OUVMbVE5ZSs0dFVSUzhXTkNWNURCcnBUN2V1TEo1WjZMMzhjN3h1N2ZCOTVK?=
 =?utf-8?B?dDdKcnc5M0thL1QvS204a1A1RGNxcG03ZSsvaWN5dU11Q1VpdWVjSGszMk9R?=
 =?utf-8?B?bzNvNkIzODhBS0hpZFBOVmpVME1HbHdMaUZWSzdZTVI3K2RVN2tXUndRMWJx?=
 =?utf-8?B?R2VaYzVTcGtFeWR5SzJmUy9WRnJham5XWW5kbllIUGNEd2w5UWN6c2doaUsr?=
 =?utf-8?B?K2tnQ1lYNWlQWTJFMDZKWkcyRlgwdmdZSENxQXUzYkxDSWorejNTaGhTc3FP?=
 =?utf-8?B?QWY3bE9XL1VQNUNGZnczU3dvUXgyOXIzdGlFd1ZBZmc2emJOTmVVWGwwNWRM?=
 =?utf-8?B?dHBLNDFwMjU2VWxVMzhBN0pkREowUjJzM0hzZVZ1bVpSM3pDTDMybGFReTRy?=
 =?utf-8?B?SVU4UERseDZCS0VZRnJWU0tzN0tiOUQ0QTZ6VkxNS2hxZGhOS1ZZOTc4R1do?=
 =?utf-8?B?bDlCcGF5MTlLU2d1WCtWT0xOVkszMXNOTW1IUFh4NHF0MUZXSmMvelZsSll3?=
 =?utf-8?B?VHZ2bmVENTNMSFRCMnAyRmdqazBnWCtkUFNqRUdMUSt5YVRzR2VqV3U3QXBU?=
 =?utf-8?B?R3ZZdWV6WU5UdC9BZXYrMmVUM0VNclJqVG5DV3h0MGNhL1R5NUFMc1FvMlY2?=
 =?utf-8?Q?NZzjwCLqk8yyQW/xnvvnw06wC?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C931E2E3642F92459A56EBA7BA2941CE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR11MB5525.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d0744e7-2e5e-4691-bdec-08de0b144505
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Oct 2025 11:24:41.8035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0KnD/jUwJdvYf8w92mX9nhHD2J/w03wqcSpRSy/MHCJzREkNLQekZdvw/pb7g6gYD+Ez6N4zf1N+EwIrpJjt4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4544
X-OriginatorOrg: intel.com

T24gTW9uLCAyMDI1LTEwLTEzIGF0IDA2OjI1ICswMDAwLCBOaWt1bmogQSBEYWRoYW5pYSB3cm90
ZToNCj4gTW92ZSB0aGUgZW5hYmxlX3BtbCBtb2R1bGUgcGFyYW1ldGVyIGZyb20gVk1YLXNwZWNp
ZmljIGNvZGUgdG8gY29tbW9uIHg4Ng0KPiBLVk0gY29kZS4gVGhpcyBhbGxvd3MgYm90aCBWTVgg
YW5kIFNWTSBpbXBsZW1lbnRhdGlvbnMgdG8gYWNjZXNzIHRoZSBzYW1lDQo+IFBNTCBlbmFibGUv
ZGlzYWJsZSBjb250cm9sLg0KPiANCj4gTm8gZnVuY3Rpb25hbCBjaGFuZ2UsIGp1c3QgY29kZSBy
ZW9yZ2FuaXphdGlvbiB0byBzdXBwb3J0IHNoYXJlZCBQTUwNCj4gaW5mcmFzdHJ1Y3R1cmUuDQo+
IA0KPiBTdWdnZXN0ZWQtYnk6IEthaSBIdWFuZyA8a2FpLmh1YW5nQGludGVsLmNvbT4NCg0KRm9y
IHRoZSByZWNvcmQgOi0pDQoNCldoZW4gSSBtb3ZlZCB0aGUgJ2VuYWJsZV9wbWwnIGZyb20gVk1Y
IHRvIHg4NiBpbiB0aGUgZGlmZiBJIGF0dGFjaGVkIHRvIHY2DQp3YXMgcHVyZWx5IGJlY2F1c2Ug
dm14X3VwZGF0ZV9jcHVfZGlydHlfbG9nZ2luZygpIGNoZWNrcyAnZW5hYmxlX3BtbCcgYW5kDQph
ZnRlciBpdCBnb3QgbW92ZWQgdG8geDg2IHRoZSBuZXcga3ZtX3ZjcHVfdXBkYXRlX2NwdV9kaXJ0
eV9sb2dnaW5nKCkgYWxzbw0KbmVlZGVkIHRvIHVzZSBpdCAoZm9yIHRoZSBzYWtlIG9mIGp1c3Qg
bW92aW5nIGNvZGUpLg0KDQpJIGRpZG4ndCBtZWFuIHRvIHN1Z2dlc3QgdG8gdXNlIGEgY29tbW9u
IGJvb2xlYW4gaW4geDg2IGFuZCBsZXQgU1ZNL1ZNWA0KY29kZSB0byBhY2Nlc3MgaXQsIHNpbmNl
IHRoZSBkb3duc2lkZSBpcyB3ZSBuZWVkIHRvIGV4cG9ydCBpdC4gIEJ1dCBJDQp0aGluayBpdCdz
IG5vdCBhIGJhZCBpZGVhIGVpdGhlci4NCg0KPiBTaWduZWQtb2ZmLWJ5OiBOaWt1bmogQSBEYWRo
YW5pYSA8bmlrdW5qQGFtZC5jb20+DQo+IA0KDQpbLi4uXQ0KDQo+IC0tLSBhL2FyY2gveDg2L2t2
bS94ODYuYw0KPiArKysgYi9hcmNoL3g4Ni9rdm0veDg2LmMNCj4gQEAgLTI0MSw2ICsyNDEsOSBA
QCBFWFBPUlRfU1lNQk9MX0ZPUl9LVk1fSU5URVJOQUwoZW5hYmxlX2lwaXYpOw0KPiAgYm9vbCBf
X3JlYWRfbW9zdGx5IGVuYWJsZV9kZXZpY2VfcG9zdGVkX2lycXMgPSB0cnVlOw0KPiAgRVhQT1JU
X1NZTUJPTF9GT1JfS1ZNX0lOVEVSTkFMKGVuYWJsZV9kZXZpY2VfcG9zdGVkX2lycXMpOw0KPiAg
DQo+ICtib29sIF9fcmVhZF9tb3N0bHkgZW5hYmxlX3BtbCA9IHRydWU7DQo+ICtFWFBPUlRfU1lN
Qk9MX0dQTChlbmFibGVfcG1sKTsNCg0KTm93IHlvdSBuZWVkIHRvIHVzZSBFWFBPUlRfU1lNQk9M
X0ZPUl9LVk1fSU5URVJOQUwoKSBpbnN0ZWFkLg0K

