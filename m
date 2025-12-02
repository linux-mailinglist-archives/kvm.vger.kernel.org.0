Return-Path: <kvm+bounces-65168-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA0B3C9CC3F
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 20:29:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A36803A90F2
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 19:29:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E00962DC788;
	Tue,  2 Dec 2025 19:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="CwxbdsaW"
X-Original-To: kvm@vger.kernel.org
Received: from DM5PR21CU001.outbound.protection.outlook.com (mail-centralusazon11011032.outbound.protection.outlook.com [52.101.62.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374232DC761;
	Tue,  2 Dec 2025 19:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.62.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764703769; cv=fail; b=E7J96IZyQwF1YnJbzvD6EK9c/CISQ38Y8JabOX8uCrY8ZHyUye/dc/POGb5AhcupOPGS9b3wtMn4FW/TghJassMRS+VoQLVnvV/EVK8ozzoZhVX/WaN5dwO+KgN0okpdru/poV2uScAuxYh6kTdLQaRPoZMq5zxcIW4tRG3k2aE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764703769; c=relaxed/simple;
	bh=0ONQIjLo9dBlSOW5nfTI1mMfdxTN4BkTfk2WSCizbeU=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=j2D7AIG29j3ZhrCuTV/m2G/IsFns3Gl/g1ru2BR05OLxvCJ2DlmoQn644lzoE5OJdTfDnfaoMcrJUUWNOcl0jBCytmODpad4NftiNyADMQ1LW4lQ9Dx2KOOeFee9s1sabTMAwf8i9PRktZ070+oifrqnqY/klbd9yuykgnxBJsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=CwxbdsaW; arc=fail smtp.client-ip=52.101.62.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=hEWsYKvEHZm5YyKYAt0/PJZpme6dmxI/XoTRYtWAe1WKYlPiCMSqv4PAjvnw2XWzKkxdvV3g+OizfC6BLYetKLjLczvk6LvVnxv/i8vR37vr16eqEqy3tgtbzh+irX1VckhyJSYBOEm9KnqCRCWix9UDhvsk0BD0enSsU7tls/KNhi6TP7PwK+FGG0Ral28q4fFM9TeMKyXHtxm5j4HESwo2orfgFXEwkKoA+hhEyLL6DLI/ijtMj7ANosNOEnzqaQQZCMSLpv1+iXn/C6MWZSEmsYwuo/USUuxDAvzdUKraEgZRjy2Ta6NLJRrEOJjTW1/CpsIIs6QYUYwnfR5qMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ziKaPpK7ywpRhoJ/CAPhtzT6BFznFssl9y7dZH7H10I=;
 b=QFYJNtxFXbXe59z4UPja6m6Q25UcK95yyyvR3bfioeHA3/DV7R+ba5NbkDly7RFsElLYWksY60AOGB9bAIEezjWcXjwTA7o22bYLCLBYnys0h9WeT4++Kt2mUhAQoOH81eX/fW6hwP8nGxv+HH3xVN+6/Mqcr1Va9Yw7bwf8hHOaYx+MxnAg7lhp3qNwusl24O05qgdxr20CMNcg6owrC4tOsr5z8OAbCSv1qqKtXzVUE+i0mhjAkn1Do6KuN59xhWgSstsp+JQ5LTPh5QxQZXRS8qa059hLNlUht0pYAUENVFcLQ75R+Q7oGXUMmmzUASCe/GpBf2a3TMzXT84NXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ziKaPpK7ywpRhoJ/CAPhtzT6BFznFssl9y7dZH7H10I=;
 b=CwxbdsaWFSqMDU36kW7q7jvQOFPbveaRiVaks5kCG5I+ItTpaVEZ1vaoFnVW/CeZftt/EU4rI3g+jmyMWzTBAk1LXaPmsODp6TSYc5y8AsaNDMmXF8CkqUF3IdS9v8CCRSnnCQwB2nmPMosd/4rxYAqsxouO92Hphy1dFR9hxbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by SJ1PR12MB6340.namprd12.prod.outlook.com (2603:10b6:a03:453::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Tue, 2 Dec
 2025 19:29:24 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%3]) with mapi id 15.20.9366.012; Tue, 2 Dec 2025
 19:29:23 +0000
Message-ID: <30242a68-25f5-4e92-b776-f3eb6f137c31@amd.com>
Date: Tue, 2 Dec 2025 13:28:53 -0600
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] KVM: SEV: Add KVM_SEV_SNP_HV_REPORT_REQ command
To: Thomas Courrege <thomas.courrege@vates.tech>, pbonzini@redhat.com,
 seanjc@google.com, corbet@lwn.net, ashish.kalra@amd.com, john.allen@amd.com,
 herbert@gondor.apana.org.au, nikunj@amd.com
Cc: x86@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
References: <20251201151940.172521-1-thomas.courrege@vates.tech>
From: Tom Lendacky <thomas.lendacky@amd.com>
Content-Language: en-US
Autocrypt: addr=thomas.lendacky@amd.com; keydata=
 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
 WiyqywZI5g==
In-Reply-To: <20251201151940.172521-1-thomas.courrege@vates.tech>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0163.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::18) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|SJ1PR12MB6340:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ff04254-a0c3-4ff9-dbe2-08de31d9194b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?YjNob0ZSUTZQM1M0TUNjSjYvUUxPYUUzNWEyeG9EamFxZkxaNGJxL0Z3TktU?=
 =?utf-8?B?azlUMWtxcFRxMldTbGl0SDRqbmdaSndSNFhnNHNDS2tqaWxhcUFoV3ErMkl6?=
 =?utf-8?B?ZHJSLzBOSlEyWDR1SVZaWk9NTzVpdmRrRWQyUGZmaVlrRzFOTlRkY3VBV1FB?=
 =?utf-8?B?Y1hUekFRaWJ6Z1k0R1llbVltVnpiKzdUNzlqWmZqaE1oTUpOaFBGRS9DUlJ1?=
 =?utf-8?B?KytuQVBHbHBIZjA1cE1GZXNXa2VaMC9EaDBiejFOZWlqN1RQRzNoTmI2T3Jy?=
 =?utf-8?B?M0FiR0p1bkhoSVlQQmRzamNpOVIxRXNuVkpRY3NYTTRxd1NCTXRWU1JkRkdQ?=
 =?utf-8?B?bjdnOS9JNEZ1YW15Tndla2YyK25rc1pldjlIVGdNSlBiNWJsNUlwbkNIMzNj?=
 =?utf-8?B?Y3F6cXhJcVBwNnYxUlpkcCt4MUtnS1dJZ3E1c3dtNHhLd3FkZldOSUJTUjlH?=
 =?utf-8?B?SXNBOXJLLy9sMVk5bFR2Sk9HWEo4dVdqVXAzdHlHbzlrYWxtVURYMVI0M0ta?=
 =?utf-8?B?c1gwVE1mM1IwM2RnM3ExUEt0bmtKQ1cySjZLcnRoMzJESDVNRklTOGlHSWMx?=
 =?utf-8?B?TjZxL2R3dlpsUFB2amxleHVWTDE1eEgwK045dG92ZHBOcVJHbVo0OHc1bktG?=
 =?utf-8?B?ZFhZSXM4c01UT0ZpZlZCcDR3blRlc0VJTEFDNFRyZlZtdCtRaEFwc3JQS3NM?=
 =?utf-8?B?ZWlJb0U4Mm1ia2ZhVXlZOC8rVFcvMTVRQ3ErSHJzSnRTUGs3ODBtOHdaYTdj?=
 =?utf-8?B?anZmWmNRb0ovNUYzNk9FcDh6dmdHZC8yNDdkR0RzaFFkekFlSElsOVhtbi9G?=
 =?utf-8?B?dDVaSkFHT1VZUDVWRWZ5V2V4R2J5VVQwNS95Wkx3R3U4YkpnRnVHRGRrL1lQ?=
 =?utf-8?B?QVpReVpEeVRhYWpnTGhOem5laHh6WGV2bVVRTUsxQjNJNU1XZ2t1Y2FqVi9s?=
 =?utf-8?B?Yk4xc0xpRUl2c1hDV2J3MDllUzlqQVgwSy90ck1yanZUSzNrMEg4ZG0xc3VM?=
 =?utf-8?B?TDhhNHNtNDVDeFF0dzhDVGNUNElUZS9UZ3lzM2lNZTVaRnA4YWFPVStobmJ0?=
 =?utf-8?B?RlNMSjg1VzhlVzhERjU4YXdlVmlFLzlMazlGTUcrMTRyOHFjbzFDSlVTYnJT?=
 =?utf-8?B?b3QvbDEwY0pObGFwaEtrTk5RcUhOVXd4SjdsdUgvMFdpRVVLVWFyd0JUWGZa?=
 =?utf-8?B?dTc3SW1NNmlUd2JUWFR6aU5tdkhjSkpBMXkrRTQvVS9FMGo0QndJajE4L0RC?=
 =?utf-8?B?V1Z5ZlAxRERlUG5NMW9ISDNOV0ZETDF3SVdOMzB2RG10dDVRaVZHNkU0Y1Uy?=
 =?utf-8?B?cG96NHd4NmdSWFgycklGUTZoWktYZE5tdTdKaytHTzdtZXVWcnpRRnFrQWpD?=
 =?utf-8?B?L2ZBQkhvZjBxRmdyWEEydU1yWGJBZmVsdEE0Y3lrUkx4dkgvZ1h1YWpRbXBv?=
 =?utf-8?B?Q29JUDZSZTRrLzFockEwcUM1SG9PM2FmWm05Q0c4UTRMS0NJS0xVL29ncnFR?=
 =?utf-8?B?UmVzbFlObm03b2xnU0hWTWN0RE9yZFBqTlJlZmhKVzNVY1VvdHpMNHhRV1lo?=
 =?utf-8?B?V0dQNGt3Y1djbjNwZVA5dzUvaUxndGVSTG44RnB2Ym8rVzFxYmN4TEIwcmRm?=
 =?utf-8?B?NG9ZNEhZa1hOK2RFZGpiSW1sekFUTURVUS9ERjdya0hadFkzT2djZVliZmNi?=
 =?utf-8?B?d2pYNWp3QnFXUWwyZ2M4d0c0T1NkWnFJQngxMzl6aWhiYVJpWHNUVlByeUxV?=
 =?utf-8?B?MVpiMzB1ZlFUVi9Pd2M3N1VnVUlQd2Vxb3dnWE13dlVIV25tNDJSU3owVXlX?=
 =?utf-8?B?VFduZWhsZjBLcXlFZ3pkWGNmYmFBNEtBVDQ2ZEgvS3ZpbTEzc2RyeHloZUwr?=
 =?utf-8?B?aFpDaUJZeGoxZVBRc0ZsV1pkUEJnWHpKL3NuL2NDT1dpZElJT0pjV0Y1cm1I?=
 =?utf-8?Q?JuGMkSn2elTrHr+VxgHbFcjuVor/x1ag?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?V1YxVGdoUjc1SnRWZXExUUEyYTVCM0RnamlzT2ljVExtcnJRS0VUdlNjakQr?=
 =?utf-8?B?UjNFNWlVMUlFMWhOT1hseXlxaWpmNnhlMmFiYnBsUjNkanFSM2xqVXZvbTdv?=
 =?utf-8?B?VFVPbmoxU0NETzZZeVRvS0dxY0t1dUs3SFVjUjJNYWkxQXJWMzlCRTBZMy9B?=
 =?utf-8?B?dlpFUEkzQTc0MkI2SGxmVzJ2Q0hVb1QycllPOVFNdGp5UmNqRkFqeFF4ZzBq?=
 =?utf-8?B?eXFVRjFac0FMckp3SlgwVlNZRVh4aWp5d2dLQWFBTHRadytGd281T1lDcnpH?=
 =?utf-8?B?UmNiSjBYOHBYQnZtY0kySVdjQ3JLUU84TXVYaUFaUVkza3lJV3VNbGVkMkFC?=
 =?utf-8?B?aUJGQmx2bVVqS1BEeW1hYnczNkJsUENISmtJaHFueDZXdHBFNWlQU2ZSN05N?=
 =?utf-8?B?a08xRHJKaTlTMm9UWnJDN211S1FoeEFkZ3RRb29BVVpXcDJmejJtT0NUTVJC?=
 =?utf-8?B?b2JMcjB2N3d3ZUhscU5mazNSdzFPSWo3Q3dUb0pIMXdUQnhYOTJ3aGdIcSts?=
 =?utf-8?B?RE15RHo4eGRPU01VMUJqY2d5RFRFYjJUZnl4bExLeHJoRElXMTFNbTFuUDRT?=
 =?utf-8?B?RjN1dlIwYnZYMmpacnZZSngxZmVTeTBReDV2U1FBNEgxdW8xeU93dzdORkNL?=
 =?utf-8?B?NWQ5UlNzUTNjUGk5Q0wxSENkNk40MzVUNVVmT3JRampLUDZGYlVaanNoKzFh?=
 =?utf-8?B?OWt0Y3k1eDV5QnZ0eXJvc0xuaFlhOVkrcGdMYmFOd2hkMVdQWVV5YTV5eXNp?=
 =?utf-8?B?S1RjTGpxZ1BXdDI3cGZwS3ZDREZPRDFmblplTmJaZ2FPdzMxZEx1MXZwNDBI?=
 =?utf-8?B?bWNyQzNRQWw3WmdQZFZFZU9yVFpMbldLR3A0RFFPaDVHU3VQSUZGbmFlVGRr?=
 =?utf-8?B?Zm45SzBLNm5HaGFjZWJKTjQ1amUySEJQNDdSMnJKZ3czdC9yYXROL0RWSWRY?=
 =?utf-8?B?WmdGL050VExyN0JoSVZPSFZRZzNVWmI2TDR3WVJjRHgxYUd2SCtjSnEzR0F2?=
 =?utf-8?B?UFVPVzhwUW56cVVsVE45NXRmV1B0OUJyYXBISUsxUFhaQ2ovQVVsMUdVVlp5?=
 =?utf-8?B?YzFqbXpOcUc5ZzA3S1B1OFB6ak93cFVvb3RCUmdmK1lreG1sVHNzbmhSdVJh?=
 =?utf-8?B?a2ZzcUdtZTI2MDViZWJmaFlWWjZFZ0FTYUkvWEI2ZFU2Yk4xRTFCTTV2eW5m?=
 =?utf-8?B?SjBnb1VJN1lsdGJuaEROVlhSbDRpK1lTaWZQNXM3TGdlSllCb3M2Nzd4YmNq?=
 =?utf-8?B?em9YVWpjOVBLT0FQL2VsQ3kxVHZuMzVBL2dLUjd2bEphbTdaeEJQZjF0WnZq?=
 =?utf-8?B?NXROek92WFk2TXhyR05YQ1RBWjJ3SzlvQnVENUdsMGN6S0RlY004WlRqeGJX?=
 =?utf-8?B?Um5FWjVXQTZVMyt6dG1JY3Z3czh0V3dHL3FzMjRDL2F5czlnaFFWZ0lVVVJ4?=
 =?utf-8?B?TW1pdVhjeHkyaXV2WnArL0g3N2FHRDA3N3E2eVFqaU1CVDRpQkZiTG1ZeTJT?=
 =?utf-8?B?aXhWTEpKYjgwL0ZhRmx4N0dzb3drcTdOSWx0bjlSYkFqTzVJbGkvdWcwUi85?=
 =?utf-8?B?Z2EwblBjanZNWDhENW5nSzc1dXJydVNDZ2FXTzBtWDhrSnVzQTZqTXgwL3pi?=
 =?utf-8?B?dFlXcVFWallTSXJtMktQVzR6UU5LNHloWUJiaXg2YVArM2N5V0FsSlVtZTFu?=
 =?utf-8?B?azZHQ09ORGVSdjJLd3J1OTZ4THpwYk1COURFN3VJZ2E4WXF3aThLTzJEVk5W?=
 =?utf-8?B?d2Y2NC9NcWFSN2w0eEQydks0b1d1bWlkSE5rd3NkbEFOZTZwbDVBT292SkJQ?=
 =?utf-8?B?bGt1QXpVYXVBVlFkU2p1RHdMRmZjRmVtRWVLWndYMDdaYXBJVGwvKzJqMXNm?=
 =?utf-8?B?Sk4zeEtBU2V4S2k1TTNDZ1dHbUY4RHNwTjYvWnpNbWJVTFgwWTdidkdmWk5h?=
 =?utf-8?B?NkdRU2duZXpOaWhLYk9XZzdqRXU5cVhzTkc3Vk9KNkdlZndZbzFicnNLb3RQ?=
 =?utf-8?B?Y3BoZXllUXpMTTRhTU15eVUzOFZ3a01vM3dKclh6dXA1UjRlUnJGWk85MFlE?=
 =?utf-8?B?LzFJMEwya1lpa2xvTE1jMUc2SHh5bEtQbGh1NG9tQ1JYUE5uTjE0bWJhKys1?=
 =?utf-8?Q?MkF+XNIdv3TMsP7/5FsIhGIgA?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff04254-a0c3-4ff9-dbe2-08de31d9194b
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2025 19:29:23.7116
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NbkfQONdiJEGGwXIvYLyT8Eq+wWcRi0i+Ct6O1AqeWIxvbJSX3mjA1qSgy/soB/NIscWLLF3ERjKfQvoe1nU3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6340

On 12/1/25 09:19, Thomas Courrege wrote:
> Add support for retrieving the SEV-SNP attestation report via the
> SNP_HV_REPORT_REQ firmware command and expose it through a new KVM
> ioctl for SNP guests.
> 
> Signed-off-by: Thomas Courrege <thomas.courrege@vates.tech>
> ---
>  .../virt/kvm/x86/amd-memory-encryption.rst    | 25 ++++++++
>  arch/x86/include/uapi/asm/kvm.h               |  7 +++
>  arch/x86/kvm/svm/sev.c                        | 61 +++++++++++++++++++
>  drivers/crypto/ccp/sev-dev.c                  |  1 +
>  include/linux/psp-sev.h                       | 31 ++++++++++
>  5 files changed, 125 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/x86/amd-memory-encryption.rst b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> index 1ddb6a86ce7f..b3ee25718938 100644
> --- a/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> +++ b/Documentation/virt/kvm/x86/amd-memory-encryption.rst
> @@ -572,6 +572,31 @@ Returns: 0 on success, -negative on error
>  See SNP_LAUNCH_FINISH in the SEV-SNP specification [snp-fw-abi]_ for further
>  details on the input parameters in ``struct kvm_sev_snp_launch_finish``.
>  
> +21. KVM_SEV_SNP_HV_REPORT_REQ
> +-----------------------------
> +
> +The KVM_SEV_SNP_HV_REPORT_REQ command requests the hypervisor-generated
> +SNP attestation report. This report is produced by the PSP using the
> +HV-SIGNED key selected by the caller.
> +
> +The ``key_sel`` field indicates which key the platform will use to sign the
> +report:
> +  * ``0``: If VLEK is installed, sign with VLEK. Otherwise, sign with VCEK.
> +  * ``1``: Sign with VCEK.
> +  * ``2``: Sign with VLEK.
> +  * Other values are reserved.
> +
> +Parameters (in): struct kvm_sev_snp_hv_report_req
> +
> +Returns:  0 on success, -negative on error
> +
> +::
> +        struct kvm_sev_snp_hv_report_req {
> +                __u8 key_sel;
> +                __u64 report_uaddr;
> +                __u64 report_len;
> +        };
> +
>  Device attribute API
>  ====================
>  
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index d420c9c066d4..ff034668cac4 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -742,6 +742,7 @@ enum sev_cmd_id {
>  	KVM_SEV_SNP_LAUNCH_START = 100,
>  	KVM_SEV_SNP_LAUNCH_UPDATE,
>  	KVM_SEV_SNP_LAUNCH_FINISH,
> +	KVM_SEV_SNP_HV_REPORT_REQ,
>  
>  	KVM_SEV_NR_MAX,
>  };
> @@ -870,6 +871,12 @@ struct kvm_sev_receive_update_data {
>  	__u32 pad2;
>  };
>  
> +struct kvm_sev_snp_hv_report_req {
> +	__u8 key_sel;

You should add 7 bytes of padding here.

> +	__u64 report_uaddr;
> +	__u64 report_len;

Additionally, there should be some padding at the end of the struct for
future expansion/use (see the other structs for examples).

> +};
> +
>  struct kvm_sev_snp_launch_start {
>  	__u64 policy;
>  	__u8 gosvw[16];
> diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> index 0835c664fbfd..62f17f4eab42 100644
> --- a/arch/x86/kvm/svm/sev.c
> +++ b/arch/x86/kvm/svm/sev.c
> @@ -2253,6 +2253,64 @@ static int snp_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>  	return rc;
>  }
>  
> +static int sev_snp_hv_report_request(struct kvm *kvm, struct kvm_sev_cmd *argp)
> +{
> +	struct sev_data_snp_msg_report_rsp *report_rsp = NULL;
> +	struct sev_data_snp_hv_report_req data;
> +	struct kvm_sev_snp_hv_report_req params;
> +	struct kvm_sev_info *sev = to_kvm_sev_info(kvm);
> +	void __user *u_report;
> +	void __user *u_params = u64_to_user_ptr(argp->data);
> +	int ret;
> +
> +	if (!sev_snp_guest(kvm))
> +		return -ENOTTY;
> +
> +	if (copy_from_user(&params, u_params, sizeof(params)))
> +		return -EFAULT;
> +
> +	if (params.report_len < SEV_SNP_ATTESTATION_REPORT_SIZE)
> +		return -ENOSPC;

See my comment below after the SEV_SNP_ATTESTATION_REPORT_SIZE #define.
Here you should check that report_len is at least the size of the report
response struct without the report, e.g., sizeof(*report_rsp).

> +
> +	memset(&data, 0, sizeof(data));

Should be able to do '= {0}' in the declaration and eliminate the memset.

> +
> +	u_report = u64_to_user_ptr(params.report_uaddr);
> +	if (!u_report)
> +		return -EINVAL;
> +
> +	report_rsp = snp_alloc_firmware_page(GFP_KERNEL_ACCOUNT | __GFP_ZERO);
> +	if (!report_rsp)
> +		return -ENOMEM;
> +
> +	data.len = sizeof(data);
> +	data.hv_report_paddr = __psp_pa(report_rsp);
> +	data.key_sel = params.key_sel;
> +
> +	data.gctx_addr = __psp_pa(sev->snp_context);

Just set these in the order they are in the struct and without blank
lines in between them, e.g.:

	data.len = ...
	data.key_sel = ...
	data.gctx_paddr = ...
	data.hv_report_paddr = ...

> +	ret = sev_issue_cmd(kvm, SEV_CMD_SNP_HV_REPORT_REQ, &data,
> +			    &argp->error);
> +

Remove the blank line.

> +	if (ret)
> +		goto e_free_rsp;
> +
> +	params.report_len = report_rsp->report_size;
> +	if (copy_to_user(u_params, &params, sizeof(params)))
> +		ret = -EFAULT;

Rather than updating the report_len, you should just include the full
MSG_REPORT_RSP structure. The spec doesn't indicate if all failures will
be reported via the command return code vs being in the status field of
the response struct.

The length check and copy size would then be:
	sizeof(*report_rsp) + report_rsp->report_size

Then if there isn't enough room you copy the 32 bytes of the report
response struct that will indicate how much memory is needed.

> +
> +	if (params.report_len < report_rsp->report_size) {
> +		ret = -ENOSPC;
> +	} else if (copy_to_user(u_report, report_rsp + 1, report_rsp->report_size)) {
> +		/* report is located right after rsp */
> +		ret = -EFAULT;
> +	}

	rsp_size = sizeof(*report_rsp);
	if (!report_rsp->status)
		rsp_size += report_rsp->report_size;

	if (params.report_len < rsp_size) {
		rsp_size = sizeof(*report_rsp);
		ret = -ENOSPC;
	}

	if (copy_to_user(u_report, report_rsp, rsp_size))
		ret = -EFAULT;

> +
> +e_free_rsp:
> +	/* contains sensitive data */
> +	memzero_explicit(report_rsp, PAGE_SIZE);

Does it? What is sensitive that needs to be cleared?

> +	snp_free_firmware_page(report_rsp);
> +	return ret;
> +}
> +
>  struct sev_gmem_populate_args {
>  	__u8 type;
>  	int sev_fd;
> @@ -2664,6 +2722,9 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
>  	case KVM_SEV_SNP_LAUNCH_FINISH:
>  		r = snp_launch_finish(kvm, &sev_cmd);
>  		break;
> +	case KVM_SEV_SNP_HV_REPORT_REQ:
> +		r = sev_snp_hv_report_request(kvm, &sev_cmd);
> +		break;
>  	default:
>  		r = -EINVAL;
>  		goto out;
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 0d13d47c164b..5236d5ee19ac 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -251,6 +251,7 @@ static int sev_cmd_buffer_len(int cmd)
>  	case SEV_CMD_SNP_COMMIT:		return sizeof(struct sev_data_snp_commit);
>  	case SEV_CMD_SNP_FEATURE_INFO:		return sizeof(struct sev_data_snp_feature_info);
>  	case SEV_CMD_SNP_VLEK_LOAD:		return sizeof(struct sev_user_data_snp_vlek_load);
> +	case SEV_CMD_SNP_HV_REPORT_REQ:		return sizeof(struct sev_data_snp_hv_report_req);
>  	default:				return 0;
>  	}
>  
> diff --git a/include/linux/psp-sev.h b/include/linux/psp-sev.h
> index e0dbcb4b4fd9..0e635feb7671 100644
> --- a/include/linux/psp-sev.h
> +++ b/include/linux/psp-sev.h
> @@ -91,6 +91,7 @@ enum sev_cmd {
>  	SEV_CMD_SNP_GCTX_CREATE		= 0x093,
>  	SEV_CMD_SNP_GUEST_REQUEST	= 0x094,
>  	SEV_CMD_SNP_ACTIVATE_EX		= 0x095,
> +	SEV_CMD_SNP_HV_REPORT_REQ	= 0x096,
>  	SEV_CMD_SNP_LAUNCH_START	= 0x0A0,
>  	SEV_CMD_SNP_LAUNCH_UPDATE	= 0x0A1,
>  	SEV_CMD_SNP_LAUNCH_FINISH	= 0x0A2,
> @@ -554,6 +555,36 @@ struct sev_data_attestation_report {
>  	u32 len;				/* In/Out */
>  } __packed;
>  
> +/**
> + * struct sev_data_snp_hv_report_req - SNP_HV_REPORT_REQ command params
> + *
> + * @len: length of the command buffer in bytes
> + * @key_sel: Selects which key to use for generating the signature.
> + * @gctx_addr: System physical address of guest context page
> + * @hv_report_paddr: System physical address where MSG_EXPORT_RSP will be written
> + */
> +struct sev_data_snp_hv_report_req {
> +	u32 len;		/* In */
> +	u32 key_sel:2;		/* In */
> +	u32 rsvd:30;

Please use the following format for bitfields:

	u32 key_sel	:2,
	    rsvd	:30;

It makes it easier to read/understand.

> +	u64 gctx_addr;		/* In */
> +	u64 hv_report_paddr;	/* In */
> +} __packed;
> +
> +#define SEV_SNP_ATTESTATION_REPORT_SIZE 1184

I don't think this should be specified as such in case anything changes
in the future. Plan on just allocating a page like you already do. The
SNP ABI does imply that the response can't cross a 4K boundary (similar
to how the guest attestation response explicitly states that the
response can't cross a 4K boundary). Only upon return of the report, do
you then check the size and see if userspace has allocated enough memory.

> +
> +/**
> + * struct sev_data_snp_msg_export_rsp
> + *
> + * @status: Status : 0h: Success. 16h: Invalid parameters.
> + * @report_size: Size in bytes of the attestation report
> + */
> +struct sev_data_snp_msg_report_rsp {
> +	u32 status;			/* Out */
> +	u32 report_size;		/* Out */
> +	u8 rsvd[24];

You could add a u8 report[]; here to show that a variable size report
follows.

Thanks,
Tom

> +} __packed;
> +
>  /**
>   * struct sev_data_snp_download_firmware - SNP_DOWNLOAD_FIRMWARE command params
>   *


