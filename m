Return-Path: <kvm+bounces-40446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF548A5739F
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 22:30:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 91BEB3AE915
	for <lists+kvm@lfdr.de>; Fri,  7 Mar 2025 21:29:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 19DDB2586C4;
	Fri,  7 Mar 2025 21:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="s7B8oBqR"
X-Original-To: kvm@vger.kernel.org
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2078.outbound.protection.outlook.com [40.107.94.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF422580C8;
	Fri,  7 Mar 2025 21:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.94.78
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741382996; cv=fail; b=tv7+Srf/BIwuWcroVuMBADUv5M/PkcwI2RLxmm1E30owTb9lTHTac4WMCxfmhdZ7MFNKZlxh6jdhEDY2Z9vwn5IErAimzlxuvCHjpMGyTJ+mBDoJxVMdPhJcmYlr65r0Q5LoPvUc24scYE8FxszDGKivtot8X/VOt782ty2XqnE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741382996; c=relaxed/simple;
	bh=5grrWFyLehr6IJpYhwSBUWzbAXYHfvlOYP2ZVkcUWrk=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=hjL8yaGy1I3yRumIZxn0A1gdZHcFac/MxXehsB9lBG+ns3aWyAHZaG25JpsL0cL56S6LmosG5C599hgMGvfOPjTXoDJlS3P2HXmzZ3TFNAVZI9llWs/WRWYfacnMyHGvWuIH8VpX+kk4rlGEx28C+OehHNAbG8CnThtWhdCC+QI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=s7B8oBqR; arc=fail smtp.client-ip=40.107.94.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=AtQDD3K6sKhh/k50ufflqE9tw0UU2XAbR0b6JRW7BSAnIxxBCFMeamwlyzMfpAU/lyO/nRT9xXDVHVyIB9v914SYqRT0M2z1U7IyvWJrN4atcnpAyI+uAKlriKCwAyX575KbmEROlfxwILbldO/LlL5InHVk0GfVmXUzV/9CishVWqsx4UFEPdtktt8sAd664OMXtbOa0lha7EKjrGU9na3AxSejm7Rd+/Sq8R00F136K/C6/DLdDJUoQ/24uqGYAhQr3GT6ebAIIqJ077hFYniVwClrXDwXlaw6N0IguBFeQyVU27nwgrf9QxFL590E2AqyuIj0R4rpcF89FtvdCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PBoxzP7xFzCS91zFg7Fzp/BBhO4dyFzHNi+/2GxFXOw=;
 b=a5e4Dfnk6JCNviTrXtoCpg+UlHnFFRMof+SUhRa2qX22lH0d0fVHv5Y8CSTfAr2D2L6hM3smJuvKBD5GS6iGqbu0GCv0NPSxiB4wKxUVwoCQeFW18m9GRc4gJjyvziRVYydldxsL3F7NQf2cDXeyIpoAvK4OnFl76nmficsL7JoFRjlQ1xaPTw/Q/E4aqD+q2YvxRVboDLQZZUyT/fJm3j/G1exydtey4C/g1bX6WlNvbePpmr4rHMvJ68Q1ge6SVSFD1lPJX0QQn/eimWmVJyuJ5CijPAA1JdNznlNq3kmg7CClS1yDr2+ea7tpt3Md3Gv8rzgJIcDB6o5/8zR8WQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBoxzP7xFzCS91zFg7Fzp/BBhO4dyFzHNi+/2GxFXOw=;
 b=s7B8oBqRpHqObPhORZDk8xVFI9onqY06YvSJ7t39UlCW2F1R390Gtmpo6nx02HkVkD/1fhCDI8XEUQDi5kkis4HJd1LQK0+MM2GjHKshQFalMCrEwUnakadNVZQ9s3KIKei95af87cQyyPyoYjUEOejtZtzvotenXXZu/6x1XSM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by CY8PR12MB8314.namprd12.prod.outlook.com (2603:10b6:930:7b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8511.22; Fri, 7 Mar
 2025 21:29:49 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%7]) with mapi id 15.20.8511.020; Fri, 7 Mar 2025
 21:29:49 +0000
Message-ID: <8d1884d7-f0a4-07b0-c674-584f9c724f89@amd.com>
Date: Fri, 7 Mar 2025 15:29:45 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v6 1/8] crypto: ccp: Abort doing SEV INIT if SNP INIT
 fails
Content-Language: en-US
To: "Kalra, Ashish" <ashish.kalra@amd.com>, seanjc@google.com,
 pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 john.allen@amd.com, herbert@gondor.apana.org.au
Cc: michael.roth@amd.com, dionnaglaze@google.com, nikunj@amd.com,
 ardb@kernel.org, kevinloughlin@google.com, Neeraj.Upadhyay@amd.com,
 aik@amd.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-coco@lists.linux.dev
References: <cover.1741300901.git.ashish.kalra@amd.com>
 <9d8cae623934489b46dc5abdf65a3034800351d9.1741300901.git.ashish.kalra@amd.com>
 <2cfbc885-f699-d434-2207-7772d203f455@amd.com>
 <fefc1f1f-fc06-a69b-3820-0180a1e597ce@amd.com>
 <151f5519-c827-4c55-b0e0-9fb3101f35d4@amd.com>
From: Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <151f5519-c827-4c55-b0e0-9fb3101f35d4@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0128.namprd11.prod.outlook.com
 (2603:10b6:806:131::13) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|CY8PR12MB8314:EE_
X-MS-Office365-Filtering-Correlation-Id: 252e7142-393d-46c9-f123-08dd5dbf30b8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|376014|7416014|1800799024|366016|921020;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?RHNFQTJ2aWdQR2JXRUlqRkpmTTQyakQ4TWNnbHBjbmRPaWtvYUpUMjVxQ0FT?=
 =?utf-8?B?WnpGUE5CcG9TWVQ3RHdmNm5qanNBUE8vMFZrMGF2WmNhQ2pmbzIyZ1VXdThj?=
 =?utf-8?B?bDYraVFmWDd1VWJnNndJUDNwb3owSFdZMy96L3dYbUF6WnVaRzB5T1pwR2hn?=
 =?utf-8?B?TXpneHhkUTl0bGF4UlBCaDNoak1vRXduMHkyWDg1RGRxWFdHNGhkaHNnNmht?=
 =?utf-8?B?NDNtMHVNNW1CWUh3SDByd1ZLd29HQlNQL041N3p1WlUwamg4eEFhVVNpb0Ry?=
 =?utf-8?B?SWJHRERZNmxBRHZGSE1kWG4randJU3M0RGo5cnI1ZE9JVkhRVnBkRm1UNmxR?=
 =?utf-8?B?TjZ5K2Fndi9VZm5DOXJva3lHYkcrNUYrMnN6MVVweURONnJRekhqaEpyZXFX?=
 =?utf-8?B?Vk5hK3I5dm9XUjdNZUFUbE95OEpOb2lnQ2lHcDFvb2plZUlONFRUTDkwaG4r?=
 =?utf-8?B?TzdLa2JadTFJWmdHdDNmbmsyVXJLVjVpczFKbStKOENSRlcvd3oxV1FoNDZD?=
 =?utf-8?B?M2VkK3psUzJnZm56YStyNWR1V3dEbGZzQ3JISHI4V0tyTXBuWm4zTEdQVDFr?=
 =?utf-8?B?T2UwZHVDRlFabW9IbWJNV3NZazU2YU5sQTArVFVtKzRHUXoxUHByNXIxRGp2?=
 =?utf-8?B?MXg3NkFsbjU2bFFWYVU0aVQ0cDU1T01JcXZDdi9rNEt3aVcrY1FqT0tZOTRH?=
 =?utf-8?B?MUlHU1djYXRMNHBMQ1RLV2g0RWJxcHluR0pEdjNWUzZUZ3dqdHhOZ1dwTWY5?=
 =?utf-8?B?ZkVRcGZsMU9MWDB5VE5GUmJIQ2hIMWpWK3BHQW1YRXhTNU5JWkhOMTQ4ZWhN?=
 =?utf-8?B?N0ZQUGtPYXRXWmxoM0pKY09nS0lDRlJtR2RCVHVONVBoaDg0K2FkOUQvZHgy?=
 =?utf-8?B?Vk8relNsZXQ2aHFGUUZIeTRyT2h1ZWNuZDJzVEpTZjhWOWlSVWFMMGxTNXZU?=
 =?utf-8?B?bVdBNTJPaWJkQ1hRUGFFNTFja0QyYjRpU3grRnFxVU9hZW9XLzZSTFV0NUxJ?=
 =?utf-8?B?RTEvYXZMSW1LVlpSYm03QVpyc01VblpyK0hzcWo3SndUT2FBK1RlaWFYOUx2?=
 =?utf-8?B?eFRLajNEQm40ZEluZ0NWa1JKTk9PK3hpc0hnd1JiTUhqK0pMQVV1VnZRRlgz?=
 =?utf-8?B?UGlrUlk0SDdYeXJOODhOTVhiR1FGaHFHYWs1NE4yZkhPYTdnbWg4ZTM5bmdK?=
 =?utf-8?B?LzI0YmgxeFpJeDV1NzFVM3E5TC9MalQ5T29VNkhwTUhwaThpa0R5bTRhWUMx?=
 =?utf-8?B?RDNZbmNEbW5DemlibGVqdmt2WWx5Z1pxNWNjZjhVclhVRVAxRk9jY3YrNkpa?=
 =?utf-8?B?ZlN5RTJnRis1WWlKQkZRWlVqeXFDNkN4aWhCbk9Sa1Z6aW5MSFBaVndvOHBm?=
 =?utf-8?B?Q2d5K2grQWV3VVFVWHRnU3FaRUwvQnpFVmdqYllzVHJVTlR3ZGJZdzhjOENu?=
 =?utf-8?B?ZlZ2TDJOcXVDWm9HRTBobkpjNEVVTDZ4bDg1S0Z4bFZpOWRPSk9Rc1lNbS9B?=
 =?utf-8?B?aG9aaHQ4Q1A2V2tQVUMrWE1rTGtoYkRUR214ZzEyeFFuSWxzb0dyZmZ0QlhN?=
 =?utf-8?B?blJsa2Iva1lydkJ1VVByKzlEMzlhVmZYVG52UDZ0Uy85Nis1RkJzUzZ3b2dS?=
 =?utf-8?B?bmsxeDRrZkcxenNHOWFyaGJ1eWpiVzIwUmNyLzJIY292YTkxakdNOEdLZ1pQ?=
 =?utf-8?B?UC9iY0hhMWxKdHlvR2dEaDh6T3VmdWNHTm1CdHRYamFWOWQ4ai8vNXFWM2Fn?=
 =?utf-8?B?VDVha0g4SFJlQzJDRkhqMEkrMW5QSWZGb1hiTndobStUbFI0dVNSK2dWaytH?=
 =?utf-8?B?QzM2T0ZVKzM1eUMySEtrZ09maFUvTUsreCtLN2V6Q1UxeXZES2xIcGE2aFJJ?=
 =?utf-8?B?MUNTRlZqQlVONldzZW1oOVhYVWNicE1GdHNVZDBqZHM3QXYvTm0zQWc0MTNl?=
 =?utf-8?Q?rx6d26naUfU=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016)(921020);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?YTFqdE1IUWtiNzhOSEFhUGlDb2RBQUI0Uk0rbVdNajRyalNnS1MxMFZBZDY0?=
 =?utf-8?B?aEtuQm1DZTQ1UnZ3UkUyMjBybGhKSDBWUW85YStFZTdQbXBUYkNkbldoZVhv?=
 =?utf-8?B?N0U2MHkrZS85SGxGb1ZsSjRMSUlEUDlJUHFVK1RlZFhpUThJUUxqWm5EN3Jj?=
 =?utf-8?B?cnVIRG93QmUyV2VjcnAxYmhlcG1yZWVOSHZXSmxrUFhVc2Y5SHVDbCs1Rmkw?=
 =?utf-8?B?NnRHVjlPZHYvM0FvZzBRa1haU1BzWGhDVC9oSXdBT2dXbUFuckV2alo2RnJ0?=
 =?utf-8?B?K21aUEVhOTNqd0VHN29ZSC9xU3Mycmc0akhyVlBRZVVLT1N3NzFOVzdJR2FN?=
 =?utf-8?B?Yy9abjZQdE9aTnEzYkM5QnprTmJTVTRvbW9wenRxS3AwV2dhRnNHV2hWWFhu?=
 =?utf-8?B?SE0ycllBd2lsWldBeWhHSHRzdkwvdm9BeDRwZkRQekRqdzBDVzE3eXN4NG9M?=
 =?utf-8?B?RTY0YTZsOW9DMVMvVW0rWlRzbVZra2VHYUswSEUwbjArNm1PeWJYdnhPTGlU?=
 =?utf-8?B?L2ZtSjJEclpRYURndE4xSUxwV1VKQ1BQZ0g1OExmNGZ4U252dTlEbURyYndv?=
 =?utf-8?B?VnRIcktzbVJmUjB3TnpBNytaVGRaMjFad3hiYUsrTDUxQXpJUHE2amxXT2Fx?=
 =?utf-8?B?aGtkT0N0QXorVnVpZThsbFR0dmZNemdONkJDZnVuOVcxa1AxYzZjSmJyeHlj?=
 =?utf-8?B?TktQWUgvWExtMXdaZS9waU1pMUxRWkRnZEpnWXVrQk0wOWQzaUNDVThFR0N6?=
 =?utf-8?B?bE5GSlhhcXdCQ1F2TkdXZU5wci9lWHlSTkZYUXFhL3RQRDBnZzh6RUMreFZz?=
 =?utf-8?B?SU1YSG5LZU5aRGdHa1lEMUlLK1Q0OXB5dkRvbGxkTHpWTnRFaTJwQWErVUZq?=
 =?utf-8?B?bWpZUmo1MHFxNUlTWEZjODFrcWtZZjJXRktPWFJ5aU5qTXdZcjlPMFRmUTJW?=
 =?utf-8?B?THBsdEFTWEFxTWhqVVlFNkpkZVBibUxXMG82cFhWTGttSExmRVV5K1NWNjFB?=
 =?utf-8?B?REs5N2ZJVGE1S0JLeVl4UWlOOS8xbWl2VXRFS3NkS1hWUkNTVjVuRkROVGZF?=
 =?utf-8?B?NzJoK1Zic0l1WWwzc1JiTDMwd05GRFRuUlRRczNVVVBWZDdRRGVjcWwzcjdF?=
 =?utf-8?B?MXg4QmtFSlN0QUw0MmgzQlFWd1VSMUMwejA4blg4NThNQ3hwOEU3MHd4OW9Z?=
 =?utf-8?B?S3BCU050TllBZHpkSDB0a0E2YURMYjJ1UVJKeFhhS0lzeTVyUmZjeGl1eU4r?=
 =?utf-8?B?NmQyVDIrc2tKT0JCSytQeXo0QkM0NXZPUGJ5MGlWVm1pM1pQNWFLY05VQUdB?=
 =?utf-8?B?QnJRNFI5SUZlS1gxSngvRVB3Q25lWU13ZTNZMENtMExCL2FjL2dkZnVZSzBV?=
 =?utf-8?B?aVk2Y0tpYnJEWWNFSmN0Z1NMdUJDTlFHVXgwWWhNbHlGOGZvM2c1NTEzU1dw?=
 =?utf-8?B?NmZxYzd3RkE1QU9jK3R1REpDWHV4WVQ5STZkMFYwVW5uQ1JzdFZ0dlFpV3Rw?=
 =?utf-8?B?OTAzWWJyNG1QYnpGOXNzOEZPckZaR2dVcytwVUdORDNGaW51WmhYZXVnTkhB?=
 =?utf-8?B?Qml1TVJrRzhvMXlOeFlORnpoeFgzUkhjTS9CUC9vVm4vcGRLYm9Ob0hmdkta?=
 =?utf-8?B?ZnJXdVI4MlhqS0k3STNSVU5GUlBST3FOdXpjU2liak43OG5hSEx0MmpKS01m?=
 =?utf-8?B?dlRtRWRlcGU3KzMxdVlBQ1NuaFFnNWdUc0ZsaU9uS2xRZTRpM3BnWXg5MlFT?=
 =?utf-8?B?RnVXU0daODI1YnFEL3VYNXhZSFZUWHhYL1A5d09CRGp4NVI3elJVQ1ZYQS9u?=
 =?utf-8?B?L2UwTXJwUk5mRE9CWGJYbGx6VEpCMWZRWHRIdHpWVkh1SzVRUmphaVY5U2Ux?=
 =?utf-8?B?OFAyYys5T1hsVDZkeVhCYWtQRU5Iam5HbURsL3VsaVFPSERMdDI1MjBEQ0Uw?=
 =?utf-8?B?YWdkOVVVYUpYYzJmaU5tTytMWHlwdE9vazFDR3RTeGsvb1BLakpzRDZHZHB0?=
 =?utf-8?B?aWU2TmJOUzFCUWtsN1FHU3EzZm1jMDR5aUNNSFRWM0NVTUN5NGp4akNZbnRF?=
 =?utf-8?B?NFJqNzgvQW1EQTNuMWh0Y21SYjdOWjZBcGlpY1N6Z0ZOVFIyYUJldHYzZUs0?=
 =?utf-8?Q?h67+9nVw2CBAwPMgBOujyczRD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 252e7142-393d-46c9-f123-08dd5dbf30b8
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2025 21:29:49.5595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6TUo9SIvsVHKZoHQ623K+K2V3DnFYZI9d+A3uBDfZroA1EOmPL0UZosC+UF2DEzNNRJrNT4KgM7OZ2ghEDAEew==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8314

On 3/7/25 15:06, Kalra, Ashish wrote:
> On 3/7/2025 2:57 PM, Tom Lendacky wrote:
>> On 3/7/25 14:54, Tom Lendacky wrote:
>>> On 3/6/25 17:09, Ashish Kalra wrote:
>>>> From: Ashish Kalra <ashish.kalra@amd.com>
>>>>
>>>> If SNP host support (SYSCFG.SNPEn) is set, then RMP table must be
>>>
>>> s/RMP/the RMP/
>>>
>>>> initialized up before calling SEV INIT.
>>>
>>> s/up//
>>>
>>>>
>>>> In other words, if SNP_INIT(_EX) is not issued or fails then
>>>> SEV INIT will fail once SNP host support (SYSCFG.SNPEn) is enabled.
>>>
>>> s/once/if/
>>>
>>>>
>>>> Fixes: 1ca5614b84eed ("crypto: ccp: Add support to initialize the AMD-SP for SEV-SNP")
>>>> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
>>>> ---
>>>>  drivers/crypto/ccp/sev-dev.c | 7 ++-----
>>>>  1 file changed, 2 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
>>>> index 2e87ca0e292a..a0e3de94704e 100644
>>>> --- a/drivers/crypto/ccp/sev-dev.c
>>>> +++ b/drivers/crypto/ccp/sev-dev.c
>>>> @@ -1112,7 +1112,7 @@ static int __sev_snp_init_locked(int *error)
>>>>  	if (!sev_version_greater_or_equal(SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR)) {
>>>>  		dev_dbg(sev->dev, "SEV-SNP support requires firmware version >= %d:%d\n",
>>>>  			SNP_MIN_API_MAJOR, SNP_MIN_API_MINOR);
>>>> -		return 0;
>>>> +		return -EOPNOTSUPP;
>>>>  	}
>>>>  
>>>>  	/* SNP_INIT requires MSR_VM_HSAVE_PA to be cleared on all CPUs. */
>>>> @@ -1325,12 +1325,9 @@ static int _sev_platform_init_locked(struct sev_platform_init_args *args)
>>>>  	 */
>>>>  	rc = __sev_snp_init_locked(&args->error);
>>>>  	if (rc && rc != -ENODEV) {
>>>
>>> Can we get ride of this extra -ENODEV check? It can only be returned
>>> because of the same check that is made earlier in this function so it
>>> doesn't really serve any purpose from what I can tell.
>>>
>>> Just make this "if (rc) {"
>>
>> My bad... -ENODEV is returned if cc_platform_has(CC_ATTR_HOST_SEV_SNP) is
>> false, never mind.
> 
> Yes, that's what i was going to reply with ... we want to continue with
> SEV INIT if SNP host support is not enabled.

Although we could get rid of that awkward if statement by doing...

	if (cc_platform_has(CC_ATTR_HOST_SEV_SNP)) {
		rc = __sev_snp_init_locked(&args->error);
		if (rc) {
			dev_err(sev->dev, ...
			return rc;
		}
	}

And deleting the cc_platform_has() check from __sev_snp_init_locked().

Thanks,
Tom

> 
> Thanks,
> Ashish
> 
>>
>> Thanks,
>> Tom
>>
>>>
>>> Thanks,
>>> Tom
>>>
>>>> -		/*
>>>> -		 * Don't abort the probe if SNP INIT failed,
>>>> -		 * continue to initialize the legacy SEV firmware.
>>>> -		 */
>>>>  		dev_err(sev->dev, "SEV-SNP: failed to INIT rc %d, error %#x\n",
>>>>  			rc, args->error);
>>>> +		return rc;
>>>>  	}
>>>>  
>>>>  	/* Defer legacy SEV/SEV-ES support if allowed by caller/module. */
> 

