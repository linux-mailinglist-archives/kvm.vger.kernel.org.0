Return-Path: <kvm+bounces-42475-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A22CA79104
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 16:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AAFC41894B1B
	for <lists+kvm@lfdr.de>; Wed,  2 Apr 2025 14:19:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBA9723A99C;
	Wed,  2 Apr 2025 14:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="y12y9hgI"
X-Original-To: kvm@vger.kernel.org
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2085.outbound.protection.outlook.com [40.107.223.85])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D99C1F584C;
	Wed,  2 Apr 2025 14:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.223.85
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743603550; cv=fail; b=RlVfVSCOTwpsWNTH2IGitNHtCww8BVjb4QoRP9UmQ9M50oiS/peyerU95RZsY9kQs2S3rSEhdW5b+2zsKQYk3CiKlyJIZk0qzIZ9lN+SHziTY+9i65U7WFW8Ny0SbtvdAJ4kK4A6gPi6ZKXi5lu5XgPuXKHtnnEJRwK/JGpaWoU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743603550; c=relaxed/simple;
	bh=W+hetA7srLdJbeDJQNQdZx20DI3tdIhPrgeSErUdw1I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=UQ4ljV8oGJnBwJqCFLBqaqKeT2rBh0HuRYjeNF50l+9S5S2Mz4779gIwl99Qkw4idUyHxCXrAEt9X2hUM5SKDF+zjoTav5MmleSi80LU1eeacjmDtl1B47aHWsOKs8tNXTQFRCbuvtjMIvbzS/wHipL+PUCBIKBiJwC1/Mkl2KI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=y12y9hgI; arc=fail smtp.client-ip=40.107.223.85
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EstL4ZthX/Au1Du+D2fg+5Uep/vioGInswi4vPhkIjMH5bB6ElQ8Fq6O1p8fYz9JSkkMwubXmNlTKXPqUJivcrGQRU/VXVHE2omJlgkLQq3V/dB7vSG5u2UGmrpUA0c/55CQ228qoa8iU2SR01X7a5/XFVKNC6gg+eFK03eKMG8ozBa9N+ngRoLIMMWnnDFXoI+grpmq4gFwsGPw0A2tF7u4UFvGW94ni7bynVC44glvy2LAUY92RZF10dK7ie/UKDTxlwUMs6UkkzluCtx6jscTR6LWSFI3+IK4mo9QGWEijXoiAj4/uS4AcYrS3Na51UQBISxpR61Y8+BHoYOF5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W+hetA7srLdJbeDJQNQdZx20DI3tdIhPrgeSErUdw1I=;
 b=rbQ5hiZs1fulJg1jssZKK/820aJAD5yCIxdIymXhbAdhBxfNaS1g+/fE1CNosCOl2WflOZkURxxpk3Ey496aXvWw2pgrpHM7pHgLPU77HUuwKQLCsVH3Vmu+36AtVSE1CTYOvay7hX6xaiMMSdB8S4PJylgBzzDiF92t8RH+O2Na4gELXqDf5ly7aHNSDjfAV+bEVMYbN951QhsQy/89Nz8EWiKLd8ji7RoIsVoZyvxiH5EgzmY7fkTC4HAwfnb19V0wsa037BH5u2T/cydXQIr/aeQbJd2yO3jGCP5QOfbOPae+u82+aia4fccMEwYfm98Rfh3EaAY06vTs7SAvuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W+hetA7srLdJbeDJQNQdZx20DI3tdIhPrgeSErUdw1I=;
 b=y12y9hgIv5d57Tt7h4OPHyGIqFgdf9V1GOnuMZl9CkGbdVMi7bnXL2j9NSqpKZphkrwwRsb8Gk2blvoie0wQq95smD7G4m99l7oIezSjtHc9PlbyTjeFtpkPBrq9fGx7SsUXq4CMeTXbRCkyEa0pw9kgBNwgBtzYli/qZd+dEZQ=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by CH3PR12MB9281.namprd12.prod.outlook.com (2603:10b6:610:1c8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8534.47; Wed, 2 Apr
 2025 14:19:06 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%5]) with mapi id 15.20.8534.048; Wed, 2 Apr 2025
 14:19:06 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "andrew.cooper3@citrix.com"
	<andrew.cooper3@citrix.com>, "kai.huang@intel.com" <kai.huang@intel.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"daniel.sneddon@linux.intel.com" <daniel.sneddon@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "dwmw@amazon.co.uk"
	<dwmw@amazon.co.uk>, "hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "bp@alien8.de" <bp@alien8.de>, "Kaplan, David"
	<David.Kaplan@amd.com>, "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Thread-Topic: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Thread-Index:
 AQHbPFEGhO8cRc5EhkeUBgz5+C52n7LQATOAgAOr34CAAMTygIAD64+AgLiKaQCAAFMogIAAAJkA
Date: Wed, 2 Apr 2025 14:19:06 +0000
Message-ID: <0f09154b0ecb896a5bd4776708d8c7eeb7a0eb56.camel@amd.com>
References: <cover.1732219175.git.jpoimboe@kernel.org>
	 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
	 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
	 <20241202233521.u2bygrjg5toyziba@desk>
	 <20241203112015.GBZ07pb74AGR-TDWt7@fat_crate.local>
	 <20241205231207.ywcruocjqtyjsvxx@jpoimboe>
	 <6bfb74e5f05ab8d4cecda1c09a235ccc59c84be6.camel@amd.com>
	 <g5xe26esmtoqevdgxueapvtvojgi63z3lsdzr3jyyo3cmcb2tj@gpeofgbzjzch>
In-Reply-To: <g5xe26esmtoqevdgxueapvtvojgi63z3lsdzr3jyyo3cmcb2tj@gpeofgbzjzch>
Accept-Language: de-DE, en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|CH3PR12MB9281:EE_
x-ms-office365-filtering-correlation-id: 346a916f-0089-44e5-df05-08dd71f153bf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|7416014|366016|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?enJsRGxvL0RMVDM1U2tmMEMyUTE5VXl4QTI2TlBoYUtiVU0rdE93SVpPcUVQ?=
 =?utf-8?B?WjFjNlJvTTNWdkc3NnMzVWhKQm5naFp6cThMYnlYYkVpU29BWFRBcGFlcmg5?=
 =?utf-8?B?d1ZTQytYbjNOZ0EvYTBkci9kY3RkTUtXclZwV202aG0wT2czeDNtRlNmalRx?=
 =?utf-8?B?djNmOUNaVXpoR3pHNDk1cFVvdVhFQUNwQVNmTUtFTUpsNmViZUtySW8vTW5y?=
 =?utf-8?B?SmZTcE5RSUFVT2w2S1k0T3NmUTRnNkhlek9GVm5VM3BNVGNwczBsNmZQVzdw?=
 =?utf-8?B?UnYxcEY5amEyeFJpR2xjVGM5T1RpTnhGQmt4eHE5QVNDczVJWHNLbGtPUytj?=
 =?utf-8?B?R3JnSHJYaC9YUmpnYTI1cHBsd3lpQ0NweG84ZXlYU2pGLzJkcmxJbnAvcTFw?=
 =?utf-8?B?SE5KOThVTG0rWFFOR0lrTEErMHpERTJROEpOTCt3KzVuZCs0M3R1NnFUM2w3?=
 =?utf-8?B?NUtzd3VnNzMxMFdONjdjWUw3S3J1bDFDamxvMkdCd3JpU3NpbEUxWER2UlFq?=
 =?utf-8?B?K3llSFNCbjFacU10QmR1ayswMXBTYmZvWHVYUEQ4d2lmZVo4dXdXZUpjQnVv?=
 =?utf-8?B?WEhvQjh5NmxHSnJQWjFMNnJNMmRoWGp6VXc5dlZXaTczcStEb21rYUxPWGZp?=
 =?utf-8?B?czgxWHE5ZU44ZCs4RHU3NUFnWVp4S1paRmFXTmdZYStYY1BodENqbmhoUExu?=
 =?utf-8?B?RHNoWnZaeHgxQjNHTmNtckdGU3FsckF5NlhzWnJKSk9BRllBWVFBWnVwaEVn?=
 =?utf-8?B?OUo3OTg4R3RvODQ1Mnp2UnYyZDNsSloxR3huQWpHbzh0dEVHNDhMeUE3anI2?=
 =?utf-8?B?RFJjTk1sYVU3SUk2eXdZSVllQW9NcDk1SEtiZThOczRTaDJCbzRaTFkvOElx?=
 =?utf-8?B?OWhDTEgxZTVDanNGVmo4djlhcnhrZ0ltLzZaeFg4eENhSWxEK1Q1U1dFb1RK?=
 =?utf-8?B?N0xCYmMvUzZDQW8xRUtKUi9oSTJLMWhGMTNDcTdrdFVpb0xzRW9RQ3o2NUIr?=
 =?utf-8?B?WXNCZ1pRNXhSK0tGdGpEcStEVTRCUGJLR3RwQmEwM1RndU5OYVp6azNsWlE3?=
 =?utf-8?B?Tk1XVktxSERpMThQSzNWWUNQUHlnUksyKzkvTGxUcFpTQjc5NzR2WFF3QUE2?=
 =?utf-8?B?V05abThza2lLQ3g3ZkZEeCtwM0swYlo0VkFmWEVtNXBadDMzU3c2ZVFmVFZr?=
 =?utf-8?B?Q2RQTmlrV0FwM09SdU1oS1ZHVUg4bFBiNnpGbUVtNGNlaTFMV1FhcHdOZXl2?=
 =?utf-8?B?bHJGb0RPT25pOWtSK2lMUFJLOHVGeEYzZndMZlJUK2tJNGI4a3dZWW5WeUJY?=
 =?utf-8?B?WlVrWDgvTVg0TFllOHppb29JSVcydVZQUkVqc1l2cWFSWDdDVVlHZE9zMUxj?=
 =?utf-8?B?QTNZWXQ3dEZMNlBLZ3hpKy9qY2NBcHBzdmxkNXViMS9NSmppQ2UrQXNsQ21a?=
 =?utf-8?B?Z2RJSmErZ3c1UGt4OXoxOVlvbmNQaXIyMlVxTkM5RlczSGRpV01yeXdRdzBJ?=
 =?utf-8?B?aDJtY28wcm9qMWRiMzdvYUhzWGwrSGJRTnh1c0k2U0VyT2xsYmpRNFBjMmFE?=
 =?utf-8?B?b0pvYWVwczRGSldmVEZib0JHVVlEak9hcW1aeVNrcTFqd3ZhL2RMWjQ4aXpL?=
 =?utf-8?B?dS9TM2pXNHIvYmZHRk85MW9PU0tVTmc3bmJIRkpkRzZjSlRxQjR3MzBETG1q?=
 =?utf-8?B?bjlBZ25xU29PdmljVWVwdU1WYlFuRlNNbDFhRFB6ZHBIcXdEdzVqaE5OeE1s?=
 =?utf-8?B?dGRFS0YvMGFVb1dYdHhGV3BWM25NaTZRK3l3RjJEUncvc3BwTE9SaHdnM0E1?=
 =?utf-8?B?cnFHWlRBbVNqcE56TVFtYWlwUFc0dXUzaktJYUkwYVNYQnA0Ry9TSDladTUx?=
 =?utf-8?B?b0VjdFB2dHpFYkNha2xWcVdJYTVPKzV3eDNFN1gxUFRQOFU3Um9zRThSZjVB?=
 =?utf-8?B?NFRoNm54N2xVQVBVUktEK3dsREkraWYzVlJlVUhsVTRpVjNYMkd6VTRpL0sr?=
 =?utf-8?B?aElSVTRTNHBBPT0=?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(7416014)(366016)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?OFJveWl0eHRiSzRhdEUraXBjMWUxeFJTbFdxN2FIaU4wY096clVUYkR0Vkwr?=
 =?utf-8?B?Q1dzK1J1ZHNmK3JkbVI0RzFWQTBRY0ZWeDZLc3U2YTZhUzkrVHFqVXNiaU9n?=
 =?utf-8?B?ZFEzVEl6aTFIWFJrUjAwK0I3ZDRMdkVOenE0dmxNWmkvNDVicnNEdmtiVml1?=
 =?utf-8?B?dXV1K3BBZUFRYk9kQjIvcEZnbC9lSUhsM0tFZnViYVJVbmlHamdncjhPeU9G?=
 =?utf-8?B?SDdyaVlOc3cveGVWRU9RUFc0bnNOTzlNNGVDZ0s3NWlaM2dnb1E1NnBjZllO?=
 =?utf-8?B?dmIwOXdJUWFOSXpCd01Cd1VDRTAvbFZra3pldzNtK3dIbWhadEFNaDNuVmZl?=
 =?utf-8?B?a2FNSWhqNnMwcGJzaXZvNnk1STRDUnExV0llWTZnZlAzYzlpc1F5QWpLZ1li?=
 =?utf-8?B?RHBCTFcrVXRmSG9XMTFRZ093MkxIeXRHbGdvMUwrVTYwOFZGcTNVWVE3V2h5?=
 =?utf-8?B?WXlTZ0dkN3hybDNsQnRPUjh5T0NGbDBHeFYyM2RCbUdOOEVGeCsvVXVkdU5K?=
 =?utf-8?B?dFNic0JVTjI5R1FwcUdWZDNKV3VUV0hQNkRPbHBJL3JpQW5aNHRwQlBtU1RV?=
 =?utf-8?B?S2JjSlhCbTV0a05xZ252WHZiblJzTlk2OFBEOUR5SlVBd09pZXNIM3A1WWNU?=
 =?utf-8?B?dnNiSjMzbWhydkJOSmdPWUVnbXNaWkk2SWRhaUdIMkJOOW14Vmd1ZDhCSjZD?=
 =?utf-8?B?T1Nrc2VVek9Rem44ZllMN2tkRm4zUFpOaTkvY204QzJ3RlJCTGV6aTc4WEtH?=
 =?utf-8?B?cFU3N3VhQ1Y1SmRPTkp2U1l4Y3hxczdHNzUwN3prRjNVODZFNEJTYVFSWkli?=
 =?utf-8?B?NndxVnUzTC9Fd2VhVzNvMWFpMXVYaU5ReVUzeGc1bk5OS01td3dVNk8zYnBY?=
 =?utf-8?B?S21SRlBaeGluZzBxeEtRZWZqaFd3WFE1S2xLM3N1REZaSUFxYUx1K1BFRXV3?=
 =?utf-8?B?ZG5Fd1hFTmhnajJYWC9pam1qd0puK2dkd0JxQXhVbUFmaUZQWVJTYmJhbjNN?=
 =?utf-8?B?bDBnYVFOQ1VrejE3QnJuUStKRWNhdDdFQ3RYMW4zL0w5c0k0RXVtbjFKR0xS?=
 =?utf-8?B?Z0E2dDUxNVFnTzlGZG00RTJuTUpON21vekZiQlRyYnVyMnFFT2dyK0xUaXdO?=
 =?utf-8?B?MldGbDl1cm51Nm84cGROeWhZdFRXV0JIRFNZdTRiMzI2SEhXQmRFTmtacWNN?=
 =?utf-8?B?Mm5ub3IvbnBEQ1NxSFRiTUtiOEF0SWprYnZUYjJPaXlzODlnNWxZNnV0cGhO?=
 =?utf-8?B?ZHZSWlpKUUhrWmZDd2ZjMW5EMGRtaEU3RXpmaVNiQWJwQlhQdmhxbHJHbVhy?=
 =?utf-8?B?UFk4cmxnaE0yeVUwTHdGQ2llYXZId1Y2NGNtT0JwOFJWUW9RNXdEWkRRSlV4?=
 =?utf-8?B?M1Z1K0VsRkxYNW01UnZhTm1rWTVINk1WVERES0tVdDE4MGJCemRxbmN4eCsx?=
 =?utf-8?B?aFMyb3R5TWwwc1dwRU1IRklNdkc4T3Z1MjZ1VnhUcTdFUHY2RkRhdzE4Y2Zl?=
 =?utf-8?B?bjBVaXc0NmRmU0F1eEZtY1YvbzBUYVFnT0UvYUl4ZEsvbW94Q3dFZ1RFRDlO?=
 =?utf-8?B?S0JySE1nRWptWUQ5WXRnaVRnL1RvY0xVdHNqTUIzbWlsRFVURWZQRkRoZTRX?=
 =?utf-8?B?RGJ4eWxBVGlMVVlkM1lGUWd2SHlDaFBDV1hlVy9VbVM1d1ZaeDlBMHVGVmVG?=
 =?utf-8?B?d3dhdzBRUzNiMXEwc3lJcHkvSUREMFoyK3VHQU9pbDRNSHd3dkdUYVJDTExG?=
 =?utf-8?B?YlI0dHFRMW9hMUkveXZtUVFicnJ0c0d6VUNnVGtXZFBtRytFc0kwUm81T1Rj?=
 =?utf-8?B?blNIV2Q5bGJoWXNPazNPdTRYN2N1TnVMdFNKNENLYy9Bd0h1NkdTc3FEN0tQ?=
 =?utf-8?B?Q2FLTTBqVVZHZEtsTU1ZQkZIRUJmMHI5OS9sdDdmVnlabXduOWpQeFJEaHZB?=
 =?utf-8?B?K1FjblBGRWo3ZW92Nkx3NTRWMzljemtWQzY0TnFuMjBUY3hjTWlTaG84OHVI?=
 =?utf-8?B?WlZKRVl4Yk15VEhjclg1WlVlcDVqVEVzbmdJWVpWdERnZVFHN3doNTBzMFJJ?=
 =?utf-8?B?S1FTUEhXRHVPZjNvMnAyMm9yUFdmRWVzNzhSZVdRZlVNN2FkTHhhUTBVMThu?=
 =?utf-8?Q?JcWGgqeOLpyJ/nvI6rgxSXXWv?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE84DAC844D55A4D8BBE9B2B2CA92BE8@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR12MB6945.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 346a916f-0089-44e5-df05-08dd71f153bf
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2025 14:19:06.2146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ilrlrbw8qcAPOJAdsNWPSSIj2cwzkLBKQRluawNPtBvZKeg2HTgdNSf1f42u6BQaPX7PLrXy8zVGQJTXGZgghw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB9281

T24gV2VkLCAyMDI1LTA0LTAyIGF0IDA3OjE2IC0wNzAwLCBKb3NoIFBvaW1ib2V1ZiB3cm90ZToN
Cj4gT24gV2VkLCBBcHIgMDIsIDIwMjUgYXQgMDk6MTk6MTlBTSArMDAwMCwgU2hhaCwgQW1pdCB3
cm90ZToNCj4gDQoNClsuLi5dDQoNCj4gPiBIZXkgSm9zaCwNCj4gPiANCj4gPiBEbyB5b3UgcGxh
biB0byBzdWJtaXQgYSB2MyB3aXRoIHRoZSBjaGFuZ2VzPw0KPiANCj4gVGhhbmtzIGZvciB0aGUg
cmVtaW5kZXIsIEkgYWN0dWFsbHkgaGFkIHRoZSBwYXRjaGVzIHJlYWR5IHRvIGdvIGEgZmV3DQo+
IG1vbnRocyBhZ28gKHdpdGggYSBmYW5jeSBuZXcgZG9jKSBhbmQgdGhlbiBmb3Jnb3QgdG8gcG9z
dC7CoCBMZXQgbWUNCj4gZHVzdA0KPiBvZmYgdGhlIGNvYndlYnMuDQoNCkV4Y2VsbGVudCwgdGhh
bmtzIQ0KDQoJCUFtaXQNCg==

