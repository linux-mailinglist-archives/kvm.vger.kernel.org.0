Return-Path: <kvm+bounces-48318-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DB52ACCB3C
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 18:26:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6384618972C2
	for <lists+kvm@lfdr.de>; Tue,  3 Jun 2025 16:27:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4443D23F26A;
	Tue,  3 Jun 2025 16:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="XY8IFX/M"
X-Original-To: kvm@vger.kernel.org
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF6F23D28C;
	Tue,  3 Jun 2025 16:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.237.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748967993; cv=fail; b=tOmqoI/XRhd3XOVbWNne8wWcTb4en4O4qKb/FOt++E6ftXaDq0VJmNSvZb35ipRMvY6C1GpQYFmU+Yr9A7+376QtZMYkqv2byURYdHqfusKr0Nt00yc9/ZO2yfdyW6LbPkCQvekarcjtAwDWMgI25KrByk6rGLXPjnJ8zGUu3fQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748967993; c=relaxed/simple;
	bh=a3qCNjJPou8OEdV4sm/Oe1Acdi08FG0qM4hYwB6NOpg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Y63r6Yd+duLWz/QE/0Y3k0tcc6iKbDQiZVxzkdsybdM/dBeQqBp8FweK2l9QpD0pBaxrGEzffHbH3+p1KSrOb0vGh6s5hRX8JUlDHoMbWNLVZlbAKZG74rLP/TIFEm+txDE+XCBlqRZ5MB6HFpSWd+aniYFY4R4Fa380aJm9Gr0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=XY8IFX/M; arc=fail smtp.client-ip=40.107.237.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nU4GB5DZxB0iQp8nTojxwsI+Av1d/J8cEurMExBiTTyQhhrJKQNTCe2YRcOdvW+32Pf1gaZovoXlD1EfuFOi50uLM38DnPCDIECzn2QVn0Vn5XzTcL2mmcbp2CvmFdIJGXg1d0PzStuRHUedYnOSHS7FahUZsn1yngsoogZkKGEW0ue8DXp2oNO0a3ZIBcr43cuDnwtMm2gPfUDHa3fWipnQI1tKpGRUFluXYcRyezWM5qMugl9BbZ3gPL8CwkrORBLixUo/SdkYMYp6kUrNMas3D0eeNBx8n2AMRHHZEi4+XMqsi7i80E9nVF/+ZOGecb7LEl4NjgfVJNv8U2eOqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l0VpPDVP8HyQcf/Oc+ij6mbqVJDI9HT+eU1x57WBKhc=;
 b=J7voBG40soGH1tAETQPJd7vcESs/i/zMhetLyupeF4I9+QRiZc3F1GcXjUinyvqT+6ZbK/EM4/WoV19HXHPceDXY1a6S6eVQAjnC/QDumRPK4NDvIJXOq2Sre4IGklzl4q1q6M75HnfknjZjsA+tUsJtQ6NwWL+DqR4Pt2yEw8ZGgKPOhommzpnvsnP124b43jRbwy41whJdJ/qCHshTPPl8aSKgu42TQd9fgSeirxYaO8wvDWG+nKLhyBd+dFKEYtQ5cI3CehDjSv0s2/rjKpoAuyawCtS7Dui9Kd6M8jEQmBEIjLkOaOUu5QywKT7qN45XLV42GQCGVgxdTDF+Uw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l0VpPDVP8HyQcf/Oc+ij6mbqVJDI9HT+eU1x57WBKhc=;
 b=XY8IFX/MADYuuWzP8EqscgCZzxos+R+X91Rs1RWzsQgeM2Dss4vvi1hf6aYDvdm7BsAm9u5CfKVGaArG1YaJstZu0kBevA7m2Ag3qNcxdA0MxDCQNYEf3Wyni+XOw0Cgq+LdcrfUZDMCLhb1BtnkyoavD+6XfAISB7/raUm9JwY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by PH0PR12MB7862.namprd12.prod.outlook.com (2603:10b6:510:26d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.34; Tue, 3 Jun
 2025 16:26:26 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8792.034; Tue, 3 Jun 2025
 16:26:26 +0000
Message-ID: <a6b39023-447d-67bf-9502-4340f9d41c81@amd.com>
Date: Tue, 3 Jun 2025 11:26:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v4 5/5] KVM: SEV: Add SEV-SNP CipherTextHiding support
Content-Language: en-US
To: Ashish Kalra <Ashish.Kalra@amd.com>, corbet@lwn.net, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, herbert@gondor.apana.org.au,
 akpm@linux-foundation.org, paulmck@kernel.org, rostedt@goodmis.org
Cc: x86@kernel.org, thuth@redhat.com, ardb@kernel.org,
 gregkh@linuxfoundation.org, john.allen@amd.com, davem@davemloft.net,
 michael.roth@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
References: <cover.1747696092.git.ashish.kalra@amd.com>
 <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <e663930ca516aadbd71422af66e6939dd77e7b06.1747696092.git.ashish.kalra@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA1PR05CA0011.namprd05.prod.outlook.com
 (2603:10b6:806:2d2::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|PH0PR12MB7862:EE_
X-MS-Office365-Filtering-Correlation-Id: 1045002b-8655-413e-285f-08dda2bb62fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|7416014|376014|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dkZJRFFXczc3NXRrL2RSeDZxbGQxeUFLc3lnOTJleE5yaDRGNDZCVlZYWTN6?=
 =?utf-8?B?RnUzSXpMdEVQb2pSTUhNODc0S2JBR2ppYnk5UEt0T1ZaYnVuQzVuQmpWQnVU?=
 =?utf-8?B?ZkM2U0NjdWNqbE0xYUtBbXpKTlJTVnBweWdkNkpZQWJHL2E0bnhjM0poMDZE?=
 =?utf-8?B?cmZIbnIrUkRpcWNHSnl5MGtNT3hWbkk4V1dMWGg2ZUdvejA4aEVDWCs3azZE?=
 =?utf-8?B?M0NONVRVcU1UaTNDcXdHMXFzZFJlamNNOC9UZ2FGTlRIUHFZV2NWRU1JT2Nt?=
 =?utf-8?B?SHJlaXVhZ1Bld3dKS3RVKyt0TGgxdGtyZG5PMVA2eWw3UFlQNXBJVndDWkhR?=
 =?utf-8?B?R1BUb0xCM2hWY1BWUXVTZlNKTExMTE1qWllad2RadHQvVXZzUERteFROT3Fh?=
 =?utf-8?B?UmFlYWFSRWtxdmNzMmVBV0xNTGZlYnRqQ1FJWUYvS0hGekJYdEtDTzJDMWh3?=
 =?utf-8?B?TUZJTkxjaktvUHJPVEdKeXZBWWJNdmg2Q2QrN0pCQ1ZyaS9DTTRTT2RBbzJN?=
 =?utf-8?B?b29xNnBTTFBMdjlKZ2FJUThPSUNVcVdjRmN1VUFCZ0laMkZCem9FLzlTazJy?=
 =?utf-8?B?Y09qc0F4bUtvZkV2RXZaY1hSNnZlSVMyZjdQdCtuN0Z4OXljcU0vYzYyRzJV?=
 =?utf-8?B?OGRxWk9JV2V6VnpjU1JNTno1cHhLNzdsS2p0K29KaUFGcGtSQmxUaSsva2hy?=
 =?utf-8?B?N3ExMitvck5FQVBxV1MwQTZFYWoxaUVSVmR3QTVSMmJ0RGFVcHZCYVhUVytz?=
 =?utf-8?B?anEwakdKbEFHWUQyaWNXcXhjN21lMk0vL1F3VmZnUzh6d24rREJBOFZpa3E3?=
 =?utf-8?B?TTlodHA0KzhzN0tNMVdhQ3ZySktuU0dWblcyRks3ZENDa1JkdnAvdGEzOW9k?=
 =?utf-8?B?d0JXWHVUMzd2VWlrME0zM3dzdHZvUzNsbnJnSm5HdHpNT2ZuRTJhdUcxdW9Q?=
 =?utf-8?B?WDJkSmtpRmRDWTFHSDZ1NU4yQkNaUWFlU0p5aE85dU9YK281Z2ZCWkg3NWph?=
 =?utf-8?B?L3BIRzNEekk3VEVudkRHb2dSeU9WV0NDNzJmaHV2S1I4YTNuWXZMTGdjREFs?=
 =?utf-8?B?ZnhWWnB4WEhmVFhqdnVqSVZ3dkFlaXhzRkxvRzkxNWlqOWlZNUd5ZXB2OXV0?=
 =?utf-8?B?TnlTYURlcTV5L1A2WElPKzByblZGc3U3ckNFWFFrRVI0YlMwY1FyUVZ1TmJG?=
 =?utf-8?B?MDNSQTk2Rk1yVTBUdDNIQVpLaUl5b1IyTDJBVTRRWjl1UnJzTnd5TXJBWG03?=
 =?utf-8?B?d3hhZTh1OHNYeTJYTWg5Lzh2Wk1DWkZSTmlWYkNQcGxPZkVXR0R1bmU3MVVt?=
 =?utf-8?B?cGtPSXJQLy9qTWJjaVkwT3M2eklDeFZnalY5WXlMVVh3am5ETU5NMW1Ed3Vl?=
 =?utf-8?B?Mit3bHh2TzRSVGlrV0xlR3NDcXJYTXozUWxnVElWdDFuMS9HbndJek5TQnFw?=
 =?utf-8?B?aVlBSk90R1pLYll3bHA2NFNFZmRCY3FoRTk4QktsdkhMeWYrY2k4bmdkYlUx?=
 =?utf-8?B?Z0hEWkRKT2RqVGxQZ0ZhOUtkd3J1b1JrclJSeW1BNWZYOEhvMFVzalJJd0lx?=
 =?utf-8?B?VzAzZ3BzNFRhNU1RVmZYMW5QS0lXV0JkVG5LeWVGakUyeUNGbWlPc3NTd3hB?=
 =?utf-8?B?ZEtEMmRTUGw3c1pmTmt5MnFSSGplMUVObytvb2M5Z1FMS0R0T0ZxWXdsb21T?=
 =?utf-8?B?K0tpUkZtYis1UVBuMWYwNER0ZWM3V1kvN014SDZtMlRrWUk0VW96bWNpNllw?=
 =?utf-8?B?TzEwcExCWEw0MkpPczJZTUNjOEJwaE5mWEhXMkNHQXVPV2tkQnJLWEZ1Sldo?=
 =?utf-8?B?RFZhaUxXWURYMytBVENtMWdLdzVuL1BjOWMrN09zdFFlTlhhUys1dUJxWXQ1?=
 =?utf-8?B?MlJzNG5qRVBENnBjdmVoOFdJRC95OHF5VytWZkxLZTBLU241SmUrMUk4Ymda?=
 =?utf-8?B?Yk9aQ281NkdYbGtEeG5kVllmdkxzN2tBeVhTVzNlUThGL3VRRHpxMzNINkI4?=
 =?utf-8?B?c2swcjA0NlZnPT0=?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(7416014)(376014)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?Yy85UHo1UXRybXhiVW92bmc4cmFDRVJxV1F4V2djcmdvdmhEUW9jU3grNExn?=
 =?utf-8?B?eXBqb1BjSWt0VVdaZFRwTWUwaHdkOUJYbEFOSFpYek0yZmwxWlNIdEw3TCtp?=
 =?utf-8?B?aHJoaTBMVWRRUHJlRnVIcEpWOWx3aTM2TzdocXQ1RURHMWgydS9scTI3R00r?=
 =?utf-8?B?R1d2eTc1RWhsUVptSm84NDk0MXd3QkdBOVhxWE8yeXZZTVFGU01IN3FCRnRv?=
 =?utf-8?B?b3owMGthbUpnRktuaFdqSUR4blg1Qmd6ajlJRTdJa01SQU1SV3F3ckZVSk0y?=
 =?utf-8?B?NFNjYzg0MU5TeERJeXlNeFFNSDZzaFlGcjU3aDhNc1FNYTFtbHc0R1Vhdmkr?=
 =?utf-8?B?NGYrVVBHWDFWeFIrbXZtTUVyNWpmTDgzNkdodWxIV0JUaFhVZFRhazV0RG15?=
 =?utf-8?B?ZTZJdUhBOFRnQ1I2SWJRakxYUWlPZHBmdU9rQ3dWMCs0Q3N5Mmh2THM5Qkxt?=
 =?utf-8?B?UXBGU1BZNjFmelNhUEtoelVTVzVaVXJMUmxTWjlsUnptaEszUmlmNm9hOEZK?=
 =?utf-8?B?eklSQXd2VlZ2Sm1yUVUzN0g0K3Q0U1o5dDlndVdVcW9rSFNyOGNWTTh3Q2du?=
 =?utf-8?B?RVpocUhEd1Y3Y3prU0FJRmZrbXgzczNDT1BmQWd6NFJZQ1pTU1RTTVhYdm5C?=
 =?utf-8?B?dllnR1A2c1VIUGZLTTNWY0w5eW1WYWxnSEZqL1dzbllteDdsa1IyUW01czd4?=
 =?utf-8?B?NTBTTG1NbzlkVHhzTlRERHpSSmNyOXFuTjdNKzY4NFhCbVJ3M201SURFWmxC?=
 =?utf-8?B?OGFRMEFPcUpDU3lOcU9RUzN0QU5LcThyNjM2UndOZlM0ckVhK3JlR2cwVkti?=
 =?utf-8?B?S2F6NnhrSVVzTU5kckFmTmZ3djFpTXRza0d0ZjdnNmtkN3gwazlQVUhZYkw1?=
 =?utf-8?B?bmpaS2R6NitSNnAvTHU2QzVocjV5WmxpTVBUbno0emtuSWYwQU1IditrcURL?=
 =?utf-8?B?dXlkU1U0cUo3QlRURXpIaTM3cUFTcnhoWDlELzJwUko4b0RzVHRMUmE1MVYy?=
 =?utf-8?B?aDZONFJKY015MXNDK0VPWDR0aDRBVzQ2dXNFQ0wyc2pyakFlNVF1bCtKOVdP?=
 =?utf-8?B?bUMvb092eGkyRDloeGxaK3djL0MyOVhPaW4zeGN5VHgvajNtV0Fnb2Fzb1pn?=
 =?utf-8?B?YldUVk5LeXhoV01mUDBLZUZjSC8wKytqbmVXOVZNank1c1BzWkJ1WTBBNE5L?=
 =?utf-8?B?SVBjbTNXOS9sZ3YrQUIyVlVKd002WFdlc09uMHRPa0dhYW1WOS8xeUpwM0Q5?=
 =?utf-8?B?NFBocVZMemVBUTZUQVhwcHpJSVBCcGMzZUExOE0wL0xhUUJFYTdweVUrSEtv?=
 =?utf-8?B?R0tvYjBXNEhoM1FnQXlBdzZHVkZjNFVkNXV6dTRJUkxBcUg5TytjTTlrK0N0?=
 =?utf-8?B?eFU5UmUxZmppcTdaRjkzcTNIOUpVVXdkOU5lSVNOYWNrOFVKZy9MQzlsdENa?=
 =?utf-8?B?aThBN0owYTdoYnJzSkpGUTdrR3BTcHVZdUNxeWtKYk8xcWw0UHBkL2lySm5x?=
 =?utf-8?B?RjRFVFpjRDRrSCt1SzJ4YjJkaUM0d2R4UGpKL3g0MFBwb1dIRmpPRVlXcmRJ?=
 =?utf-8?B?b0w5eHd3dGZZVDhsUXdPajF2RlRWRkExY0h5c1d4RGRzZitTNVM1QXY1WkVP?=
 =?utf-8?B?MVEwaWlwK1JSUkxzeWtUdDFJaExQaXRLbDhsczZEbkI3MWcyNWJaZUNOSmlU?=
 =?utf-8?B?S0VQL0lJQTBsWm9IUm0zUlFDRUMxYStQQys4eE9FV00ybkFKZWgzNGd1TnJz?=
 =?utf-8?B?MmlQTE9la05yRThuQjVFS0NPaVNyWWxKUVo3Rm9hQzlBMXZPLzR4dHpTSkUx?=
 =?utf-8?B?bnM0a29NMmFNK0hyeHJydFl5QUZKZ0tVdDhUYVFOQlBPKzNENHExWG1HTVRq?=
 =?utf-8?B?Y0swQUJid05LMzJvSldKNVNDQWpCQURlWDlFZHpqSmVEL2p1d0JjRDJzUjlu?=
 =?utf-8?B?SUorWUFvcnNPUGtDOUc1OVFSWDV5ajI4WFVzRmJFQ3d3ZTF1ZER4ODBZbHZy?=
 =?utf-8?B?K2pkb0FXemlhamdrZGVtenlhOGFNL29adlNHOGpQQW4xZFFYQUdST1N0OWdT?=
 =?utf-8?B?WEpQaEN3eGlKbmx6ZlNxYmZJbXhEMDBZbXYrd1diNzJWY1BzTEhzOXc0b3Ew?=
 =?utf-8?Q?znQM9Mv1vMKUZQhBbEAiXfqFx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1045002b-8655-413e-285f-08dda2bb62fd
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2025 16:26:26.1258
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g4uzoPIGFEIfN3ErEKgNZLZ0Y7uqjWcdetp/Ba1SflDjac4ZsOxMeYAWtfe8jvl4FcVWjAgQ6RvqbZ8DJk2qPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7862

On 5/19/25 19:02, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Ciphertext hiding prevents host accesses from reading the ciphertext of
> SNP guest private memory. Instead of reading ciphertext, the host reads
> will see constant default values (0xff).
> 
> The SEV ASID space is basically split into legacy SEV and SEV-ES+.
> CipherTextHiding further partitions the SEV-ES+ ASID space into SEV-ES

s/CipherTextHiding/Ciphertext hiding/

> and SEV-SNP.
> 
> Add new module parameter to the KVM module to enable CipherTextHiding

Ditto.

> support and a user configurable system-wide maximum SNP ASID value. If
> the module parameter value is -1 then the ASID space is equally
> divided between SEV-SNP and SEV-ES guests.
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  .../admin-guide/kernel-parameters.txt         | 10 ++++++
>  arch/x86/kvm/svm/sev.c                        | 31 +++++++++++++++++++
>  2 files changed, 41 insertions(+)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 1e5e76bba9da..2cddb2b5c59d 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2891,6 +2891,16 @@
>  			(enabled). Disable by KVM if hardware lacks support
>  			for NPT.
>  
> +	kvm-amd.ciphertext_hiding_nr_asids=

s/ns_asids/asids/

I'm not sure that the "nr" adds anything here.

> +			[KVM,AMD] Enables SEV-SNP CipherTextHiding feature and
> +			controls show many ASIDs are available for SEV-SNP guests.
> +			The ASID space is basically split into legacy SEV and
> +			SEV-ES+. CipherTextHiding feature further splits the
> +			SEV-ES+ ASID space into SEV-ES and SEV-SNP.
> +			If the value is -1, then it is used as an auto flag
> +			and splits the ASID space equally between SEV-ES and
> +			SEV-SNP ASIDs.
> +

Ditto on Dave's comments.

>  	kvm-arm.mode=
>  			[KVM,ARM,EARLY] Select one of KVM/arm64's modes of
>  			operation.
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 383db1da8699..68dcb13d98f2 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -59,6 +59,10 @@ static bool sev_es_debug_swap_enabled = true;
>  module_param_named(debug_swap, sev_es_debug_swap_enabled, bool, 0444);
>  static u64 sev_supported_vmsa_features;
>  
> +static int ciphertext_hiding_nr_asids;
> +module_param(ciphertext_hiding_nr_asids, int, 0444);
> +MODULE_PARM_DESC(max_snp_asid, "  Number of ASIDs available for SEV-SNP guests when CipherTextHiding is enabled");
> +
>  #define AP_RESET_HOLD_NONE		0
>  #define AP_RESET_HOLD_NAE_EVENT		1
>  #define AP_RESET_HOLD_MSR_PROTO		2
> @@ -200,6 +204,9 @@ static int sev_asid_new(struct kvm_sev_info *sev, unsigned long vm_type)
>  	/*
>  	 * The min ASID can end up larger than the max if basic SEV support is
>  	 * effectively disabled by disallowing use of ASIDs for SEV guests.
> +	 * Similarly for SEV-ES guests the min ASID can end up larger than the
> +	 * max when CipherTextHiding is enabled, effectively disabling SEV-ES
> +	 * support.
>  	 */
>  
>  	if (min_asid > max_asid)
> @@ -2955,6 +2962,7 @@ void __init sev_hardware_setup(void)
>  {
>  	unsigned int eax, ebx, ecx, edx, sev_asid_count, sev_es_asid_count;
>  	struct sev_platform_init_args init_args = {0};
> +	bool snp_cipher_text_hiding = false;
>  	bool sev_snp_supported = false;
>  	bool sev_es_supported = false;
>  	bool sev_supported = false;
> @@ -3052,6 +3060,27 @@ void __init sev_hardware_setup(void)
>  	if (min_sev_asid == 1)
>  		goto out;
>  
> +	/*
> +	 * The ASID space is basically split into legacy SEV and SEV-ES+.
> +	 * CipherTextHiding feature further partitions the SEV-ES+ ASID space
> +	 * into ASIDs for SEV-ES and SEV-SNP guests.

I think it is already understood that the ASID space is split between SEV
and SEV-ES/SEV-SNP guests. So something like this maybe?

The ciphertext hiding feature partions the joint SEV-ES/SEV-SNP ASID range
into separate SEV-ES and SEV-SNP ASID ranges with teh SEV-SNP ASID range
starting at 1.

> +	 */
> +	if (ciphertext_hiding_nr_asids && sev_is_snp_ciphertext_hiding_supported()) {
> +		/* Do sanity checks on user-defined ciphertext_hiding_nr_asids */
> +		if (ciphertext_hiding_nr_asids != -1 &&
> +		    ciphertext_hiding_nr_asids >= min_sev_asid) {
> +			pr_info("ciphertext_hiding_nr_asids module parameter invalid, limiting SEV-SNP ASIDs to %d\n",
> +				 min_sev_asid);
> +			ciphertext_hiding_nr_asids = min_sev_asid - 1;

So specifying a number greater than min_sev_asid will result in enabling
ciphertext hiding and no SEV-ES guests allowed even though you report that
the number is invalid?

I think the message can be worded better to convey what happens.

"Requested ciphertext hiding ASIDs (%u) exceeds minimum SEV ASID (%u), setting ciphertext hiding ASID range to the maximum value (%u)\n"

Or something a little more concise.

> +		}
> +
> +		min_sev_es_asid = ciphertext_hiding_nr_asids == -1 ? (min_sev_asid - 1) / 2 :

Should this be (min_sev_asid - 1) / 2 + 1 ?

Take min_sev_asid = 3, that means min_sev_es_asid would be 2 and
max_snp_asid would be 1, right?

And if you set min_sev_es_asid before first you favor SEV-ES.

So should you do:

max_snp_asid = ciphertext_hiding_asids != -1 ? : (min_sev_asid - 1) / 2 + 1;
min_sev_es_asid = max_snp_asid + 1;


> +				  ciphertext_hiding_nr_asids + 1;
> +		max_snp_asid = min_sev_es_asid - 1;
> +		snp_cipher_text_hiding = true;
> +		pr_info("SEV-SNP CipherTextHiding feature support enabled\n");

"SEV-SNP ciphertext hiding enabled\n"

No need to use the CipherTextHiding nomenclature everywhere.

Thanks,
Tom

> +	}
> +
>  	sev_es_asid_count = min_sev_asid - 1;
>  	WARN_ON_ONCE(misc_cg_set_capacity(MISC_CG_RES_SEV_ES, sev_es_asid_count));
>  	sev_es_supported = true;
> @@ -3092,6 +3121,8 @@ void __init sev_hardware_setup(void)
>  	 * Do both SNP and SEV initialization at KVM module load.
>  	 */
>  	init_args.probe = true;
> +	if (snp_cipher_text_hiding)
> +		init_args.snp_max_snp_asid = max_snp_asid;
>  	sev_platform_init(&init_args);
>  }
>  

