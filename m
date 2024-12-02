Return-Path: <kvm+bounces-32817-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5D37B9E0043
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 12:24:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF061163D7A
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2024 11:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F07D20C473;
	Mon,  2 Dec 2024 11:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="PRXDWkFj"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2082.outbound.protection.outlook.com [40.107.243.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C35A20B81B;
	Mon,  2 Dec 2024 11:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.243.82
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733138131; cv=fail; b=PKufKA4Tq0KXInNP3UEbiT4MgD/CGgQX0CECylngFO5mjt/PBmncBBlxz9YZ/wtq9pISmxZX/b5mK81KmJ9UaDmg4zZ8c9oFDgefFsBUpsh3u91UmHfOvMlHLH3qaZbK5KAdRahbQi3p2w2av+2XiVqsjenH4JeYsjYfC55il9M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733138131; c=relaxed/simple;
	bh=VjtoDmGQdvOGsqXBi4wa7Wk1EEg4D/M35pJufAk4lwc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=YbkgTKMUdrvZhtZZrdcJWE14i0+Zf0imIBOKgSrwJkyyeQ0NKBxaopU/aP2RekokbcFW9LK+2rZVj/MTe50uDpQ436KgAHvmyP5j0UlDAXgkSiLQCFmtuBJVgnQ0KIydz/AjhysaNtMHHSqfx5+mXYfyWoi/pbqbwrPBVZ1gsLA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=PRXDWkFj; arc=fail smtp.client-ip=40.107.243.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xbq9aHcJeTCej8rZIJJcujzWlRL0YIhwnM9r/eQl1KnOSPMvjbK7WB+jlElxOumGY1OcQn7tLDRkCFkzd8GRhBPeC3+APmZfBA9jRwGImRvoGcc7UqYJK+YUqw8E+klg6r3eFpiM1K+K8SzqyJ3BADaasl4SuaEkHBR2XreTn1kGo3y+770eBGJj7fA3SMG5hxVz2O88IrGkiRvfNsH04nACNT2u11Ek1Ks/d6LJas+Q8Y17eo8b9KWb7F6Y+5pHJE9t5s2JbLeMqundY+Jyszp9K0/eQ67lnYcHssmsq2zqUFC+r8v4RcagPn0QpbwYBKO3La4iHyJUUK7+CJ7X0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VjtoDmGQdvOGsqXBi4wa7Wk1EEg4D/M35pJufAk4lwc=;
 b=QboZgm1KBeg3rqULKTtlLf23yTrkREdiLtQt6A9mqug1jXaWttAyhhUMcX1K1v1Vb4E0Za4wGQj3NuWlxIpPHedYAmwiU8PV0hT3rNcvv6bL5CTbHnfgAXcWMJmql2EHy66fXD5Md0cgCJKCpGKw4jWFs39e7uX816lBzIelO4p6wdlHI6/fw7y/B1epchHhQaZjzGD8ruvuTPqcn/PC9KqFIuJg7rSDAxYHiKQ/ag48UUBHfjJkCRtQN5PRMsKS4gf0tYwtLmTObVFGizCWeyx3hiZehlqIFw4kE+9tQRFq+JLRK5w/5xF+1oVJmCihScWIt7mt3LlLkTRx27flPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VjtoDmGQdvOGsqXBi4wa7Wk1EEg4D/M35pJufAk4lwc=;
 b=PRXDWkFjc1cFOg9EHWei3HF/XoVbpolf3KhnpLcYWdEypzj0NHDpFdu3nSbjRs5pDkMqIQDaBipIUJWi9MoaAO32qn8L5Car/dIfhzJUAt8dATiom+04PFW/IUkFvclKNK5HYVFscHIlXr0I8GYg9kjMqedB1wbAR61Ohf7dXk0=
Received: from SA1PR12MB6945.namprd12.prod.outlook.com (2603:10b6:806:24c::16)
 by MW4PR12MB6684.namprd12.prod.outlook.com (2603:10b6:303:1ee::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8207.18; Mon, 2 Dec
 2024 11:15:24 +0000
Received: from SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463]) by SA1PR12MB6945.namprd12.prod.outlook.com
 ([fe80::67ef:31cd:20f6:5463%6]) with mapi id 15.20.8207.014; Mon, 2 Dec 2024
 11:15:24 +0000
From: "Shah, Amit" <Amit.Shah@amd.com>
To: "jpoimboe@kernel.org" <jpoimboe@kernel.org>, "bp@alien8.de" <bp@alien8.de>
CC: "corbet@lwn.net" <corbet@lwn.net>, "pawan.kumar.gupta@linux.intel.com"
	<pawan.kumar.gupta@linux.intel.com>, "kai.huang@intel.com"
	<kai.huang@intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"andrew.cooper3@citrix.com" <andrew.cooper3@citrix.com>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "Lendacky,
 Thomas" <Thomas.Lendacky@amd.com>, "daniel.sneddon@linux.intel.com"
	<daniel.sneddon@linux.intel.com>, "boris.ostrovsky@oracle.com"
	<boris.ostrovsky@oracle.com>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"mingo@redhat.com" <mingo@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "Moger,
 Babu" <Babu.Moger@amd.com>, "Das1, Sandipan" <Sandipan.Das@amd.com>,
	"dwmw@amazon.co.uk" <dwmw@amazon.co.uk>, "amit@kernel.org" <amit@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "Kaplan, David" <David.Kaplan@amd.com>,
	"x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Thread-Topic: [PATCH v2 1/2] x86/bugs: Don't fill RSB on VMEXIT with
 eIBRS+retpoline
Thread-Index: AQHbPFEGhO8cRc5EhkeUBgz5+C52n7LQATOAgALdIIA=
Date: Mon, 2 Dec 2024 11:15:24 +0000
Message-ID: <f43ebdd781d821d7fabdd85f1eebf8acd980566f.camel@amd.com>
References: <cover.1732219175.git.jpoimboe@kernel.org>
	 <9bd7809697fc6e53c7c52c6c324697b99a894013.1732219175.git.jpoimboe@kernel.org>
	 <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
In-Reply-To: <20241130153125.GBZ0svzaVIMOHBOBS2@fat_crate.local>
Accept-Language: en-DE, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA1PR12MB6945:EE_|MW4PR12MB6684:EE_
x-ms-office365-filtering-correlation-id: c50113a0-76d3-4a09-afec-08dd12c29e6d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|366016|1800799024|7416014|376014|38070700018;
x-microsoft-antispam-message-info:
 =?utf-8?B?djRmcWlSbFR2OGczejkwQXdiK1FPMmthV0NNVHN2UzVmTmJFS21Ob1lQd1h3?=
 =?utf-8?B?bFVabjdBT3NIMzZqMmdDMnlNRkVtZW9HbVR2Y21uMjB0NGhsRFRJZjRzemMw?=
 =?utf-8?B?M041TWZ5cjFzQnpOK25SU0ozUGZpMklLV2l2SUpMVE82NFVaSEVScHZNSDNY?=
 =?utf-8?B?MjFPT29Vajhjc0JjeVpTc1VxbkxVZnhVUXhtcnZka0JYalVQVVdqRkFPdDZG?=
 =?utf-8?B?MjZYa0g2RTJrS2krVVNWZjZXTWU4WVNxZlNxOTNOY0E5VlkwbE9KenNnb2Fs?=
 =?utf-8?B?SnpxeGtkZW8xUFZhVkdMNy8rYy9iOGNhZkpYd1ZOdzEvdStVV29wRC9wMnp6?=
 =?utf-8?B?UGNrSklpVzRISSsyREswRFFaL2R6Mm1YR2tuWE1RYmY1NjUwczNLZUsxZU5Y?=
 =?utf-8?B?M2pXR2ZZWlczUXBGcWpUZksrNWJFWVNzRGxtZzZGZHdyalRYY0s4NzdWWnYv?=
 =?utf-8?B?MDdtcmNIY3dlSFd6QlR6WXRPVlFhSEpIQTNJR00rQWhxWmtSVldMRHkzNzlk?=
 =?utf-8?B?M2t5S3NVU3M5K29CeXVINUdPcXlOZDF5Q2FJdWMrZDNVTSsxdEtWUGpBYXUw?=
 =?utf-8?B?TzVSQTBtSk5NZEZGcG5DT0RlcTRSZWV5aWJSSm5SbUsvc3R4d0FtS2hNU3lY?=
 =?utf-8?B?VDZ2bTlaUjF2Yk9ORGNzY1dtcFppOGNhQ0lVMWgzQVdST3dpVk45Y09pZXpi?=
 =?utf-8?B?eE5rblBaQXdwM3RFN0MrTk83TEpqcmlZNXVuNDVNQ2FsakdINGZ1eHQrTHFI?=
 =?utf-8?B?RmVmL0NwOWVDcTdZSmQ5UmVvME1oaGFkQnBwaFZnTFZtbTU4bXpIVERVenpa?=
 =?utf-8?B?ZGNNZG1SU1g4cVIxRDRMN3dNRGcyK09zMG5BY2x4Y1pqRHdTUWMxakR6NkpT?=
 =?utf-8?B?eTByVlJGWC91VG43VC9rd1pxS1FLb2dUdjZGV3VQNlVYTWhDNzJXZjd4RmR1?=
 =?utf-8?B?YVBiVCtSTmVaQzd4UTk0b3BSdXgyOWxrNGFoTkxiNlFUanJIRkNOOXdtWExY?=
 =?utf-8?B?am52QXJZOUwyMW5LRXAzRjFqdnBnYm1sTDk3UUhCRHF6MzI3dmVNSVJZSzlT?=
 =?utf-8?B?NkdINEJSTkR0TEU0SkVSdVBVeU5qVVhHYmwzWG1oZ3lXMEVvSFlNSVlRTW9M?=
 =?utf-8?B?NXVkVHFjR3h2a3ZiVzVJVDlmb3Z6Y21kVk5ERCtkTHNBMnFlSWR4SjAxdW4w?=
 =?utf-8?B?eWhlTmNneFNZbHBlOS9OQXorcExnRXlWVGRXNTBmdUZveFpzSWR4ekJRODNT?=
 =?utf-8?B?ZExwcEluR2Y4bUtqSnd2WTE4SFlPSDUwbVJOS05TdUd2eUNHUTlWUS9PN25y?=
 =?utf-8?B?U1QwWHNsNHkxTFJibUx5MXUyb3ZOY2hLMkFXNXkrc3lQNmhEa0ozVTZiR1g2?=
 =?utf-8?B?TldncFhmc0ZJWlNpOWRjdTR3VVp0d3Zld3NNNWxLWGsyZGNINENsaGtnazRs?=
 =?utf-8?B?MUZKREcxS3p0RHFqRGxXbzRqSFU1blF1NlZxQk9iZXpkOVpPK2pwaldOaCtS?=
 =?utf-8?B?MlZsZ0w4YWwyNGFSb3NVSHhYRkM0WmlSZVNOUTFmek05UFVURDZvbTl5bkN2?=
 =?utf-8?B?Y0pmaTVXcElJa2tzcXhPTnFkUUdGUktSMzZ1dThlL0NMUURidjM0eHpMa3A4?=
 =?utf-8?B?NzRHZlFZUEcrYmlOaXhDdmRERjFoNHV6WjZrMGxyK1VteGpwTGZnVWVzWTFN?=
 =?utf-8?B?bDU1WGdXcE96VHluN1dQTVpvcVlvZERmdmFjSHVoTlNDU2pKaDgwUVJLVDVF?=
 =?utf-8?B?OVZOZnhZMjZQems4b2dYY1RwNUgyY2RrcVpOUExEZWZKakUySHMyYW1UNlZ6?=
 =?utf-8?B?cXN0cHZMTWNKVURIbkhBV01GRndKZlhYeEtLQzNhdEExSkhKRVJIZ1BzbXFs?=
 =?utf-8?B?NEQwZ25LZ1c3dWE4M0x3aUNHYjJ4NkR0RWpiS1hhQXRvWHc9PQ==?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR12MB6945.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?UXVzN3JUQUU2Sk5iTnpUcWp0dnRvQkZDY0huWHFqY2xVZGF1OTdqTFkzbkU5?=
 =?utf-8?B?MkhTczhqZEF2T28vaWIyL1cwa3FhSW9lQk1KTVgycnI2dktiUmRTQitIdTVD?=
 =?utf-8?B?TTlLN0x4SkFjZUlPcXdSclNQMVhkd09VVml5ZWVVYjlTZzNFd3FWdFhnWFpY?=
 =?utf-8?B?ZUVSRE1mS1Q0RlI2dVMvdmJVQVpVb1dkejMxTG81elpVT29temc0Y212RHBH?=
 =?utf-8?B?S0trVnhUZUFLbWlKd2tPVmJ4bjB6TVZuMWdOZ2s4WklEeUZCdjQ1dDJaOVd0?=
 =?utf-8?B?enpIUjU5NThzSDVpY2Q0L2NIdVRPRXAyekRERE14dlFXNnpmSllCRUxpU0dZ?=
 =?utf-8?B?Vzk0Mm9kU2h6OC9qSlRBUDhnOTduRzNHT0ZEMVd4K2xsVGdSRDRkdnV1U2pp?=
 =?utf-8?B?dzMrYWJobm9VdTFOcUZtbGs5SndDSUR0cGxJd3hwVkVEdUh1SXZuVlQ1bkEv?=
 =?utf-8?B?YjFqR2UwcUpUVDB5Qnd1STJiY1c1RnJ3YzBZeDIzT1dyVDRUbDg2Y0g3UmNs?=
 =?utf-8?B?WStRNEVCcDdtalUvNE1XYnJrRnZEcGtoaFBDUjl6OW1LdE40Q215dnUzNXpM?=
 =?utf-8?B?TC8wNGQ4S3ExV3VMUHZqSkk4cTQ2VW9TOFhHbTJyNit5UlhlMTJWL1pyV1Ju?=
 =?utf-8?B?NFl1Z091S2NLdkQyb1ZTNFdLUUJzN0xZMDNuNHJKSklxV25zNHZMelN4OXpq?=
 =?utf-8?B?MGFHNXc0ZFRycG5BeFpCOGkwZ01KSEo5NCs5RWFuVG4zT3BzaU9wMFFSME5Y?=
 =?utf-8?B?Y3REZ3MrTWdxWS8wYTNoenlaT2NqQllhRGlHbUxvQlJGOUNFN1ZzSjkxaFBZ?=
 =?utf-8?B?bUpid1BGOCtSbEZrcEgwYS8raDVWTEFkVUI2V2JST2Mwd1JFbFVsU0k1cHdE?=
 =?utf-8?B?TlZkNW9UbFIydkZLTXBDZ2VvZEt2YnhDNzFDUmpGLzB5cmZzUHdOL09CMXBr?=
 =?utf-8?B?MExpRVk2NjFNbE1HT011OHhUR3Y2NGFGTDlHSmEvWDNNZXgydFFaYnRqek1n?=
 =?utf-8?B?bDg3a3J5WGdmSEhDaU44YnVaakdxR3IzZmlDVVMwaWNvMlhYWitGMGhGbm9Q?=
 =?utf-8?B?dzUzVlVtOEFzTHQrUi92bUo0UGR3cmdRZmdKN250WW0rNkEzd0pYZW1RRXQw?=
 =?utf-8?B?eG5CWWZQZE5sU3RWOEZSUVJObHpSY0M1ZWt0Wm9YNmwvODJlOHA1emRWQXVQ?=
 =?utf-8?B?N0ZVNWJHWmpydVVnOXptTVpxZy9pbEZvbVdpa1ZRMTN6NkQzRXp6ZTkwS2R6?=
 =?utf-8?B?bEhjdFNoaGxETmgyaytJZ3hVcEpjSEJzcjBRRStSWlZ1ZHRsKytyWEdZTEJM?=
 =?utf-8?B?cFkwUlVJZDBPRE1qeGQwbnFSZmxjOEFOYjhIUHkvM3pPc2RTNTlndklKRW5E?=
 =?utf-8?B?MXJHTm02dHNRMzNkY213UHBlRFp6ZVkvQUg2aVc4TTI2blE0NC9VdHYxbHhZ?=
 =?utf-8?B?dURBRVhJM05LRm56VDhrem1UMEVrZGV1dVp5TUlCd1VaTU9Tbm5RdCthc1VX?=
 =?utf-8?B?dU9KZ21uQ1BDTEtlWVlXRXRHMnJXdGMwMFNVTml5R28zOGdvSW91MDlOVHZH?=
 =?utf-8?B?djdYUElXZzE4SmtNRS9lcERpZlJITFp4NDg4ZEl3Q3hBVFRvT0tUYndnT1B3?=
 =?utf-8?B?dmpwKzRndDFQM2dqVkdsNEZlQjdGK0F3bGQvSGU5R2ZINmNZYng5SitMOSs2?=
 =?utf-8?B?WEhnZjRVMTlYdTc0NnV5Wk1LZ2JpajdqMGd2eXJZSWtwN2dnYmpNaXU5ekdy?=
 =?utf-8?B?a1BteFFzSzJxN282U2FOZkMyaCtEbGZkRm8zTzFTVDNuS1FCeCttSWlsS0JT?=
 =?utf-8?B?TCtEb0RvcEd1MDdCNEZXU01PMmNCampYYUlCcWNNNE00eGVJTTl5cHBoYktX?=
 =?utf-8?B?TnltaFdPR1FvaUMxT0ZvcVRGdWZVYnR3RVBNSFBLYVBjclN0UENrZ21WeEZL?=
 =?utf-8?B?ZmxCazhuaExZVkdETEt4OGtnRTJTeXFjRTNBK0lPYjdSZzZOc3ZlMk9WRzBn?=
 =?utf-8?B?UXNXaWUxbGEzWENzUVBsQzdCQk5OY1VabmZhRkZ2UThKdGtFTHJwLy9tOTdO?=
 =?utf-8?B?OVZRWk9KcUMwOTJZamhYNXQwbWNRS1BuMU12YXVsdFd1VFJYbzZRSkV5OGtI?=
 =?utf-8?Q?H3IJRK6905O2oN8eqw3WIYacY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9613A2A7952BF40A9D7E51B3080476A@namprd12.prod.outlook.com>
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
X-MS-Exchange-CrossTenant-Network-Message-Id: c50113a0-76d3-4a09-afec-08dd12c29e6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2024 11:15:24.7368
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: upE0Lu6+wcHTOEi63MfEVM7tSAX1EaAblLfaddrQ0JldSYLa+Dn2XCXAxQQqFO4KU/CSI5ZZeAeTq+uxMFT3dQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6684

T24gU2F0LCAyMDI0LTExLTMwIGF0IDE2OjMxICswMTAwLCBCb3Jpc2xhdiBQZXRrb3Ygd3JvdGU6
DQo+IE9uIFRodSwgTm92IDIxLCAyMDI0IGF0IDEyOjA3OjE4UE0gLTA4MDAsIEpvc2ggUG9pbWJv
ZXVmIHdyb3RlOg0KPiA+IGVJQlJTIHByb3RlY3RzIGFnYWluc3QgUlNCIHVuZGVyZmxvdy9wb2lz
b25pbmcgYXR0YWNrcy7CoCBBZGRpbmcNCj4gPiByZXRwb2xpbmUgdG8gdGhlIG1peCBkb2Vzbid0
IGNoYW5nZSB0aGF0LsKgIFJldHBvbGluZSBoYXMgYSBiYWxhbmNlZA0KPiA+IENBTEwvUkVUIGFu
eXdheS4NCj4gDQo+IFRoaXMgaXMgZXhhY3RseSB3aHkgSSd2ZSBiZWVuIHdhbnRpbmcgZm9yIHVz
IHRvIGRvY3VtZW50IG91cg0KPiBtaXRpZ2F0aW9ucyBmb3INCj4gYSBsb25nIHRpbWUgbm93Lg0K
DQpGV0lXLCBJJ2Qgc2F5IHdlIGhhdmUgZmFpcmx5IGRlY2VudCBkb2N1bWVudGF0aW9uIHdpdGgg
Y29tbWl0IG1lc3NhZ2VzDQorIGNvZGUgKyBjb21tZW50cyBpbiBjb2RlLg0KDQo+IEEgYnVuY2gg
b2Ygc3RhdGVtZW50cyBhYm92ZSBmb3Igd2hpY2ggSSBjYW4gb25seSByaHltZSB1cCB0aGV5J3Jl
DQo+IGNvcnJlY3QgaWYNCj4gSSBzZWFyY2ggZm9yIHRoZSB2ZW5kb3IgZG9jcy4gT24gdGhlIEFN
RCBzaWRlIEkndmUgZm91bmQ6DQoNClsuLi5dDQoNCj4gSW4gYW55IGNhc2UsIEknZCBsaWtlIGZv
ciB1cyB0byBkbyBoYXZlIGEgcGllY2Ugb2YgdGV4dCBhY2NvbXBhbnlpbmcNCj4gc3VjaA0KPiBw
YXRjaGVzLCBwZXJoYXBzIGhlcmU6DQo+IA0KPiBEb2N1bWVudGF0aW9uL2FkbWluLWd1aWRlL2h3
LXZ1bG4vc3BlY3RyZS5yc3QNCj4gDQo+IHdoaWNoIHF1b3RlcyB0aGUgdmVuZG9yIGRvY3MuDQoN
CklmIHlvdSdyZSBzYXlpbmcgdGhhdCB3ZSBuZWVkICphZGRpdGlvbmFsKiBkb2N1bWVudGF0aW9u
IHRoYXQNCnJlcGxpY2F0ZXMgaHcgbWFudWFscyBhbmQgdGhlIGtub3dsZWRnZSB3ZSBoYXZlIGlu
IG91ciBjb21taXQgKyBjb2RlICsNCmNvbW1lbnRzLCB0aGF0IEkgYWdyZWUgd2l0aC4NCg0KSSBn
b3QgdGhlIGZlZWxpbmcgZWFybGllciwgdGhvdWdoLCB0aGF0IHlvdSB3ZXJlIHNheWluZyB3ZSBu
ZWVkIHRoYXQNCmRvY3VtZW50YXRpb24gKmluc3RlYWQgb2YqIHRoZSBjdXJyZW50IGNvbW1lbnRz
LXdpdGhpbi1jb2RlLCBhbmQgdGhhdA0KZGlkbid0IHNvdW5kIGxpa2UgdGhlIHJpZ2h0IHRoaW5n
IHRvIGRvLg0KDQo+IFRoZSBjdXJyZW50IHRocmVhZChzKSBvbiB0aGUgbWF0dGVyIGFscmVhZHkg
c2hvdyBob3cgbXVjaCBjb25mdXNlZCB3ZQ0KPiBhbGwgYXJlDQo+IGJ5IGFsbCB0aGUgcG9zc2li
bGUgbWl0aWdhdGlvbiBvcHRpb25zLCB1YXJjaCBzcGVjdWxhdGl2ZSBkYW5jZXMgZXRjDQo+IGV0
Yy4NCg0KLi4uIGFuZCB0aGUgY29kZSBmbG93cyBhbmQgbG9va3MgbXVjaCBiZXR0ZXIgYWZ0ZXIg
dGhpcyBjb21taXQgKGZvcg0KU3BlY3RyZVJTQiBhdCBsZWFzdCksIHdoaWNoIGlzIGEgaHVnZSBw
bHVzLg0KDQpJdCdzIGltcG9ydGFudCB0byBub3RlIHRoYXQgYXQgc29tZSBwb2ludCBpbiB0aGUg
cGFzdCB3ZSBnb3QNCnZ1bG5lcmFiaWxpdGllcyBhbmQgaHcgZmVhdHVyZXMvcXVpcmtzIG9uZSBh
ZnRlciB0aGUgb3RoZXIsIGFuZCB3ZSBrZXB0DQp0YWNraW5nIG1pdGlnYXRpb24gY29kZSBvbiB0
b3Agb2YgdGhlIGV4aXN0aW5nIG9uZSAtLSBiZWNhdXNlIHRoYXQncw0Kd2hhdCB5b3UgbmVlZCB0
byBkbyBkdXJpbmcgYW4gZW1iYXJnbyBwZXJpb2QuICBOb3cncyB0aGUgbW9tZW50IHdoZW4NCndl
J3JlIGNvbnNvbGlkYXRpbmcgaXQgYWxsIHdoaWxlIHRha2luZyBzdG9jayBvZiB0aGUgb3ZlcmFs
bCBzaXR1YXRpb24uDQpUaGlzIGxvb2tzIGxpa2UgYSBzb3VuZCB3YXkgdG8gZ28gYWJvdXQgdGFr
aW5nIGEgaGlnaGVyLWxldmVsIHZpZXcgYW5kDQpzaW1wbGlmeWluZyB0aGUgY29kZS4NCg0KSSBk
b3VidCB3ZSdkIHdhbnQgdG8gZG8gdGhpbmdzIGFueSBvdGhlciB3YXk7IGFuZCBtdWNoIGxlc3Mg
ZG9pbmcgdGhpcw0Ka2luZCBvZiBhbiBleGVyY2lzZSBkdXJpbmcgYW4gZW1iYXJnby4gIE1vdmlu
ZyBjb21tZW50cyBvdXQgb2YgdGhlIGNvZGUNCndpbGwgb25seSBhZGQgdG8gZnJ1c3RyYXRpb24g
ZHVyaW5nIGVtYmFyZ28gcGVyaW9kcy4NCg0KSnVzdCBteSAyYw0KDQoJCUFtaXQNCg==

