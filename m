Return-Path: <kvm+bounces-47034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 770DEABC9B1
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 23:34:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B35957A755B
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 21:32:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACC2323817E;
	Mon, 19 May 2025 21:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="niJDXWhV"
X-Original-To: kvm@vger.kernel.org
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2069.outbound.protection.outlook.com [40.107.100.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8471B237164;
	Mon, 19 May 2025 21:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.100.69
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689780; cv=fail; b=B9v9cm8eXOKh0O0c3XkE00NUbw9am9ti3sh5JDJ16rWIAFWnaswzFcFH4jHyzmg/vFVQi+cmb2pW2hi9tMEsb5yHcMaC8HnjYWunjaQphvA3zbI4FnKTxv/KN9LOyjyvKAApl7OhahFJ0HrkfSbqvEmF1SS7WyvvMol3Mo3AnEA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689780; c=relaxed/simple;
	bh=M75mC6rBp3/EqCOSVQeT1vk8fgIkgZE4whBOCRr9wXM=;
	h=Message-ID:Date:To:Cc:References:From:Subject:In-Reply-To:
	 Content-Type:MIME-Version; b=hP0AO+TVkRU5aBBQ4HbbjBMJ9bZbuDzleUuOoJXB5xvNKaNpjYSQSBAK+F3u3QzCPmtV0GNlvWQbQTmA79P9PxTugz4eVJDDj6VQwBrpBZP2bc0dvZIdEGW9n5WH1zHLt+t73yR9DNAQrlDQ6cS8MPSo57QWXI6+sVYdjC9ZtCI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=niJDXWhV; arc=fail smtp.client-ip=40.107.100.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lmXDGGCInKfgv5NxqC2MZnfbvmPdnEg0HK6I0Jd44Sa0PXLc9tgyRjiW5vVHO30LvTn56QUiG70hDwH9zTTABRiDT9jw/7ty6QcXVY8vOdAFDhR66W3epzM6khybJezzYHSWxhG3pvfQlac8NvhmQPrHIxriu6H2oZ2ybZWLol8q2tfzF40+vLQkUybiGRIfMIbX5WZVwgoicDnuuxhUsfisBKYaPe/XwHipbkF+PufVXlr9XowJIfFyDqU5rleyeM6kQ7iuV3TBpijEVh5BHS/UuIQlhW7pCyc0XIJOhXhwOnxxBsLJTXsxKBUe2E0cUtdZs9sApCh0Uj9r0kgXlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HBoaM9+6RK4kbXz8ZjQmslMLrjv5o3R+bvQZk/0/Uyo=;
 b=lkw2oxTyB6cw6gECH4u2cqdHo7HGspx0IRiqedOz4/jvnHC5ZfnADszm87bbCplGdacZjrfAjCsbD8hQ0f+H+sR0AclTmf/gVjzpBqQKUC4UA6nh3hW2wfW39bO8JfrE4pp4m4jO8sFqJguzA6+9ayRAn2BeuVmheocM3aqXHzgQpuG2xjW38IJlYsMMxLLt7tI1F7GvExej8aWkzNcrKaZP9sYv2KMvZZcbPJhEa1H/gk7eA1igYB8OukehFeG9IVJ/p70Vn3ZuO92MvnXVbIgq0VD0KOBa5XJUMZXJpGpE13jCiFzlfpVOglsBsH3iN0viT8Yi6FGG6hy1+2GFiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBoaM9+6RK4kbXz8ZjQmslMLrjv5o3R+bvQZk/0/Uyo=;
 b=niJDXWhVYS9/qlGDRvP1+aDlChTmFJshpJsNvwwCK5Ty4DSJhYrS0h1Mcpas3Y+A86KT1Y6vSrs/N0OUJjejreM9uBYn3sCKjM/1dtTHTR8s3wGDa/gMa7oDJE/wES4Ki7/V8tlkMPVmfXjUomKxMav7g+8g83qcTcq9Kjrf3UU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5070.namprd12.prod.outlook.com (2603:10b6:5:389::22)
 by DS0PR12MB7701.namprd12.prod.outlook.com (2603:10b6:8:133::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8746.30; Mon, 19 May
 2025 21:22:54 +0000
Received: from DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e]) by DM4PR12MB5070.namprd12.prod.outlook.com
 ([fe80::20a9:919e:fd6b:5a6e%5]) with mapi id 15.20.8746.030; Mon, 19 May 2025
 21:22:54 +0000
Message-ID: <43bbb306-782b-401d-ac96-cc8ca550af7d@amd.com>
Date: Mon, 19 May 2025 16:22:51 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Content-Language: en-US
To: Amit Shah <amit@kernel.org>, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org, x86@kernel.org, linux-doc@vger.kernel.org
Cc: amit.shah@amd.com, bp@alien8.de, tglx@linutronix.de,
 peterz@infradead.org, jpoimboe@kernel.org,
 pawan.kumar.gupta@linux.intel.com, corbet@lwn.net, mingo@redhat.com,
 dave.hansen@linux.intel.com, hpa@zytor.com, seanjc@google.com,
 pbonzini@redhat.com, daniel.sneddon@linux.intel.com, kai.huang@intel.com,
 sandipan.das@amd.com, boris.ostrovsky@oracle.com, Babu.Moger@amd.com,
 david.kaplan@amd.com, dwmw@amazon.co.uk, andrew.cooper3@citrix.com
References: <20250515152621.50648-1-amit@kernel.org>
 <20250515152621.50648-2-amit@kernel.org>
From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v5 1/1] x86: kvm: svm: set up ERAPS support for guests
In-Reply-To: <20250515152621.50648-2-amit@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR08CA0034.namprd08.prod.outlook.com
 (2603:10b6:805:66::47) To DM4PR12MB5070.namprd12.prod.outlook.com
 (2603:10b6:5:389::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR12MB5070:EE_|DS0PR12MB7701:EE_
X-MS-Office365-Filtering-Correlation-Id: b32d5864-bddb-419c-99ee-08dd971b516c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?utf-8?B?dWFsVVdDMDRaQi9HV0Vpb1NibDRUb0ljNWNmZExibzJMdXFGNXNCekJQU0xD?=
 =?utf-8?B?a0tIaEpIS3JtcE54bjVvOWlyZG8yeWFNdUZzNkcwelF1cmxObTV1b2txblNk?=
 =?utf-8?B?WmFrdlNDTW9ERzd0SkNhSzh4Mko0TDRjM21ralpQcWFSdkMwVUJLU2dyZXlH?=
 =?utf-8?B?cDZ5cUNxbnFOSXIyRnZtMVQzRThSV2haNVBkMzRLalRjcWwyU1ZBemI5dEho?=
 =?utf-8?B?T0dzRzNJYzJjUk10RlFvc1d3QVcwMnZyb09NSlBiUjhiWUxRUStubEozNU1Z?=
 =?utf-8?B?SkZPdUc1Sjh5Z2RJRE9qRkpGc1YvOFA3SkNrUEd6L2dqNVRHUHVrblgveUpG?=
 =?utf-8?B?aFJXcEdmZHVmNUZBbkxvcmhqTWZQdEl6b21mL1JCb2MzMVozSC94cCtyb3ha?=
 =?utf-8?B?cjBoYUw1QTNsNU5ob3ZMOTAwUkpFTVlzQm5FVXdyL0hIV25MbFI0czJYdWtE?=
 =?utf-8?B?UTEzbU9vdmx1Mlh1bzkvUEV1d3MrNi9VM0d5QmNlMXRUTEJSaDVveUg3QUpG?=
 =?utf-8?B?c0NlemZjMkxZVERyaUc4bXZVSG9aZlJPTjJCSTRYYUJoY2FsK3p6TVR0Si9E?=
 =?utf-8?B?SWM2YlM2OTZPZkFaYTNCaWJrYThkb1J5TGk1bDRpNGh6Uk9tNjM3bm5TOHdU?=
 =?utf-8?B?aytwSEI0bjRST2RCaks2RXBLbkwyY2NOdnF0OUNWR1FVYTdBRlVUUTlodjF6?=
 =?utf-8?B?eXRBaFNtVDMwRG0yYnJPeGpuUFdmdnd1QTJFT2NUaU9xYmNhNG12M1hxcEla?=
 =?utf-8?B?Z2VuNXAxRVZqc1kvaGJUSFZBUXBoTjVuQjhWclR6NzM0SXNia1pDb3hOaUc2?=
 =?utf-8?B?TFkzbkR6eXNFcDVYa09PVlZ6U0lCV3U4aHNENm9ydTE3WW9tOUlVNnV6RlF1?=
 =?utf-8?B?a29HQ2ZKWUZnNVdNQzl5NklQeGRpNkI3WGtaMTViU3JpaGUyQXk5UXpUWWh3?=
 =?utf-8?B?OXpwOFRuckhQY1g3MXlrYndpelIvTmQ2VDFrZzFWMUNEZjNqNVA2WmpLamYx?=
 =?utf-8?B?YzUvekpnZnU3ZjgraW1lRktsQjYySDJZa0hRSWtzVkVTL0xLK2N1ZkxRd3VB?=
 =?utf-8?B?TmE4bHMyUEE2eXV0blp2aENvWHQzTVNBaE5OdFhSZS9wZEhEckpIRi9HbHJr?=
 =?utf-8?B?SktITG9SbHBSd05ZQm1RamorcTFoaFhqNXA1eWtOTXJudU13RkVXQy9tSmF6?=
 =?utf-8?B?aDMrQjVaVjlBeTQyZTczaldUV0J4VENaZzB6aFFocHVuOGVXa1hpNHUzRXEx?=
 =?utf-8?B?LzY3YnpuWUxtUzI4ajFWU092TkdrQ0xtdzczSlFFd3VpQ3Q0dXZwQ1hyL000?=
 =?utf-8?B?ZHpGWXRYMThmN3dlM2wwcndtTUxLcmdEZXIvMWx2RDNHMEFTM0FteFZOdkZs?=
 =?utf-8?B?ZmJ2MzR6bTJodWowWXVKOWNkM0dwanFCWUlDVFZUL3hPVnd5UFlaQjVZb0RV?=
 =?utf-8?B?MjRGNHpiNS9ONXRna0kwcG5oQnJpb2RrRmlEcVRCbWZXOUNIQVpqWjlrTHNm?=
 =?utf-8?B?VzBleWs1RWF1TDUyKzQ2aEVTb3pwaWV4ejFzb20zZ3ZhZ3BjbCthMXpjMVlT?=
 =?utf-8?B?Tnd0cUV6S2xrUDdHSlJucC9Nb0ozZWZDU2xCRlRuMWZFUmVJV0VXRGYxTnNl?=
 =?utf-8?B?RnBrVlFCZDlad0grbnpuOFpNMDN4V0dQeW5kQ1VENjgyUkY1VXhBaHFEdTln?=
 =?utf-8?B?b054SHloOEpRSDF1VStuNjNxT01POWxrUmNHVzNmdlRqUDJMNXU5OHV4OFFj?=
 =?utf-8?B?OUc3cE1lcGM0YXQ5MEZ6QTNtVnhMSkNLcVNQWHQzY1psQlU2TDdTZlRnSHNy?=
 =?utf-8?B?NXRYVlBwb3hMdjlPNkhlb1RtSTZIUVFCU09IVWI5ekExVVByaUFEdFRUbU1y?=
 =?utf-8?B?Rzl6WloreE84UW5QZlhaNDNDVXIxbW1wWldkTHd2Yis1ZXk1MXdnYUtMb1RP?=
 =?utf-8?Q?abp3vaq23OE=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5070.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?TFRMODVEZkEyYjM0Wno0eVpvZi9nckNFQjMvc3N3YUU4SHZPOW1yKzd6dkZO?=
 =?utf-8?B?UnpTM2t6K2RJRHgwWEhBZkM4NGJYVThBK1VRaXp2a3cvaW9iUzVndVp0YU0y?=
 =?utf-8?B?WlJ4MEpva2tlK29yRDhhSitFOU5vYjd2WXdMRXhxOTBJK3o5dzczaVZHSUE1?=
 =?utf-8?B?dkU2Q3l5WW1HREJqUUF6MjhKRG5oUS9UeUJ6QVF6T1I4UlZaZmREZ0ZnRjBz?=
 =?utf-8?B?c1VGNEl1RWxSblNrYmdjVXF0YmIyQS9MNk5RZmNaTFVvTUZZZC9IcmxNNFZF?=
 =?utf-8?B?alFsNXppRlNOUVF3Q2wxc0ZiRllIcnZBendIUjl3NE5jRDdkNlp1UnRwc0F2?=
 =?utf-8?B?UUpGSHdzYjVyQURvOVk3SmtsMERqd2dZNHZEVmxXTTN0OUU2N3hPQnhEUEVz?=
 =?utf-8?B?K0hLUXMxb0VYbjBBb3I4Y29WbmdFRURCN3F3VmZRS2RRcGVpZ3A3cG5hR3Rr?=
 =?utf-8?B?OW1JOS9ZNGpraUo3MU1pZkplVlpnelpka1llK1BhVG92TThjaDRoUkI4dEZ2?=
 =?utf-8?B?cHJFL0ptUXVQQldPOUU5NmVGNXYwajZtV1YvVlhUQjlOZzkrSmJkWXZveUNP?=
 =?utf-8?B?VWtwbFRHVnVWcjN3RUhNeUk0bExGblcvMDNLbEFxa0p1MlBONjZHelpLa0FR?=
 =?utf-8?B?bTZrZGdONzhBVXpXZ2hBY2VtMDhYektjUmJmNjRQYjRZN2JoLzJWdVRsRzdZ?=
 =?utf-8?B?Y1lEb2dQS3FJYjFsL2NIaHVSUkxSTFhubVlGWDBTbW85elUwcEZIQmZTdXpC?=
 =?utf-8?B?TWJ2WVByRXArWkkyLy9hWEoyZktpd29zWkIwMmpBSW9obGY3WUVHK3oreklj?=
 =?utf-8?B?VklzWWF3Y0ZEUjVQRElaNStwemx6M1FYb0ZmeUlxTi9sOVlKUHRmTTBUblo1?=
 =?utf-8?B?MVRVQ0xpOVNRR3ZuOW45RXRrU0Q5dUxUZk9DNm5BT3N2eDFxd0c5UCtQY3dY?=
 =?utf-8?B?V1VaVEplWVEvTmhvdmt4M2hsVExWV005dXZlNUhaNkdWY1pxYjdSOVZNN0pt?=
 =?utf-8?B?RzVDRFJzaXp1WTk1bTIwR1QxTzVFWTAzVjR4eHM4aldTTG1WSVhpQmtWKzJS?=
 =?utf-8?B?SEVXNEJKSlc2TWFSMjZxK1p6R1Zaa1kzaUhtNTZvZ0Y1dlN0aWdyRFVENVFI?=
 =?utf-8?B?WVNsOWx3cW82NjhwNkFYaGo4dkVzRlhTeXpwQmdVVnk2ZHFvczFLRGFBelE1?=
 =?utf-8?B?UkNMWnNqM2cwejd6bFcyUCt4Zk5YTDViODh1UHkzanhIeHA4UzNBdmVuOEY2?=
 =?utf-8?B?NHlaamEvQUZ3QkZWSk9HNi9MQThaVWRIZVV3aUJmMllIYVhiMTFSRjJXcVZ4?=
 =?utf-8?B?T0FqV3pYOGVFUjFXWUNWVjU1UzlveGlWTGtFSU53QlJJUWFHNDMzZzEyKzRQ?=
 =?utf-8?B?MkR0aHZJYXozaHRNNCtOVDFLWHl6QTZQK21HelhvWlV6Tjd0dUQ3K2F6bEFh?=
 =?utf-8?B?b2lzYTFOb1A2WFMrSHJBZjhKQWVyejdQTnBiZHBkclZqZ3Z0azJ6U3B5UVBj?=
 =?utf-8?B?RSthaWdUbFU0bCtIa2dmOTJRWTZENUtEZnNHQUlZQllBejR0dFJQNjB6dVNL?=
 =?utf-8?B?cW1NZTBKeVVRVFVmUnZqbWNPK1htVlVpaldENHljdm1NaWV4R2ZWRHgydU43?=
 =?utf-8?B?bERGZkk0NkF4RTB4eXduekFybzZRQnFIa0JCLzZ0UkYwT2xPSWpKZlZvWC84?=
 =?utf-8?B?Qk9yYkMyb0R0dVdjbVVnSTU3WFlGczF4QUIyL2pIMVJBUzI4QzNTTkRaYThT?=
 =?utf-8?B?MGsxOG5IQlJKYXlRbjc4cUdDbmFOUzFSYWpHQ0UrOGw4VWlDVnJLMno1cFNs?=
 =?utf-8?B?LzV3aDdLYW9vY0hnK01ocldaa3laVmdMTEZaaVBpQU5yY28xZlVsekJSUGYv?=
 =?utf-8?B?a2I3dWgvSXdkNDZnejhCc0Q0ODJsSVh5NjYxbHhURVF2VDhubTNyTEorc1Ux?=
 =?utf-8?B?dEhwR016N2FKZFBRM05BM0cvSmZ4QVNrcUtzUWUyTzFJaUlrVDF5U1d3L1Mr?=
 =?utf-8?B?YS8rZ1NsNDJML1grNEcycmtSUWJBejI0ZFhWek5MS080QlI5cERqMTRocWxO?=
 =?utf-8?B?WUpvNHdRNzVMT2g0aHUzOE9FTU9RSnF2RGJBMGJ6RHRQbWJYclowL2ROWUN0?=
 =?utf-8?Q?ahAlJTOaUxLEWdkzCbnBOnnDD?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b32d5864-bddb-419c-99ee-08dd971b516c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5070.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2025 21:22:54.5252
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZrHiPTcZy/4053Q9eY7cJq3WKVJVjAhogtaYX1oaF3Iy0VS5k6GnbrDmVLuIILC3UxysqnvBQc+nUAzIK+GfQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7701

On 5/15/25 10:26, Amit Shah wrote:
> From: Amit Shah <amit.shah@amd.com>
> 
> AMD CPUs with the Enhanced Return Address Predictor (ERAPS) feature
> Zen5+) obviate the need for FILL_RETURN_BUFFER sequences right after
> VMEXITs.  The feature adds guest/host tags to entries in the RSB (a.k.a.
> RAP).  This helps with speculation protection across the VM boundary,
> and it also preserves host and guest entries in the RSB that can improve
> software performance (which would otherwise be flushed due to the
> FILL_RETURN_BUFFER sequences).  This feature also extends the size of
> the RSB from the older standard (of 32 entries) to a new default
> enumerated in CPUID leaf 0x80000021:EBX bits 23:16 -- which is 64
> entries in Zen5 CPUs.
> 
> In addition to flushing the RSB across VMEXIT boundaries, CPUs with
> this feature also flush the RSB when the CR3 is updated (i.e. whenever
> there's a context switch), to prevent one userspace process poisoning
> the RSB that may affect another process.  The relevance of this for KVM
> is explained below in caveat 2.
> 
> The hardware feature is always-on, and the host context uses the full
> default RSB size without any software changes necessary.  The presence
> of this feature allows software (both in host and guest contexts) to
> drop all RSB filling routines in favour of the hardware doing it.
> 
> For guests to observe and use this feature, the hypervisor needs to
> expose the CPUID bit, and also set a VMCB bit.  Without one or both of
> those, guests continue to use the older default RSB size and behaviour
> for backwards compatibility.  This means the hardware RSB size is
> limited to 32 entries for guests that do not have this feature exposed
> to them.
> 
> There are two guest/host configurations that need to be addressed before
> allowing a guest to use this feature: nested guests, and hosts using
> shadow paging (or when NPT is disabled):
> 
> 1. Nested guests: the ERAPS feature adds host/guest tagging to entries
>    in the RSB, but does not distinguish between the guest ASIDs.  To
>    prevent the case of an L2 guest poisoning the RSB to attack the L1
>    guest, the CPU exposes a new VMCB bit (FLUSH_RAP_ON_VMRUN).  The next
>    VMRUN with a VMCB that has this bit set causes the CPU to flush the
>    RSB before entering the guest context.  In this patch, we set the bit
>    in VMCB01 after a nested #VMEXIT to ensure the next time the L1 guest
>    runs, its RSB contents aren't polluted by the L2's contents.
>    Similarly, when an exit from L1 to the hypervisor happens, we set
>    that bit for VMCB02, so that the L1 guest's RSB contents are not
>    leaked/used in the L2 context.
> 
> 2. Hosts that disable NPT: the ERAPS feature also flushes the RSB
>    entries when the CR3 is updated.  When using shadow paging, CR3
>    updates within the guest do not update the CPU's CR3 register.  In
>    this case, do not expose the ERAPS feature to guests, and the guests
>    continue with existing mitigations to fill the RSB.
> 
> This patch to KVM ensures both those caveats are addressed, and sets the
> new ALLOW_LARGER_RAP VMCB bit that exposes this feature to the guest.
> That allows the new default RSB size to be used in guest contexts as
> well, and allows the guest to drop its RSB flushing routines.
> 
> Signed-off-by: Amit Shah <amit.shah@amd.com>
> ---
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/include/asm/svm.h         |  6 +++++-
>  arch/x86/kvm/cpuid.c               | 10 +++++++++-
>  arch/x86/kvm/svm/svm.c             | 14 ++++++++++++++
>  arch/x86/kvm/svm/svm.h             | 20 ++++++++++++++++++++
>  5 files changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
> index 39e61212ac9a..57264d5ab162 100644
> --- a/arch/x86/include/asm/cpufeatures.h
> +++ b/arch/x86/include/asm/cpufeatures.h
> @@ -457,6 +457,7 @@
>  #define X86_FEATURE_AUTOIBRS		(20*32+ 8) /* Automatic IBRS */
>  #define X86_FEATURE_NO_SMM_CTL_MSR	(20*32+ 9) /* SMM_CTL MSR is not present */
>  
> +#define X86_FEATURE_ERAPS		(20*32+24) /* Enhanced Return Address Predictor Security */
>  #define X86_FEATURE_SBPB		(20*32+27) /* Selective Branch Prediction Barrier */
>  #define X86_FEATURE_IBPB_BRTYPE		(20*32+28) /* MSR_PRED_CMD[IBPB] flushes all branch type predictions */
>  #define X86_FEATURE_SRSO_NO		(20*32+29) /* CPU is not affected by SRSO */
> diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> index 9b7fa99ae951..cf6a94e64e58 100644
> --- a/arch/x86/include/asm/svm.h
> +++ b/arch/x86/include/asm/svm.h
> @@ -130,7 +130,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  	u64 tsc_offset;
>  	u32 asid;
>  	u8 tlb_ctl;
> -	u8 reserved_2[3];
> +	u8 erap_ctl;
> +	u8 reserved_2[2];
>  	u32 int_ctl;
>  	u32 int_vector;
>  	u32 int_state;
> @@ -176,6 +177,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
>  #define TLB_CONTROL_FLUSH_ASID 3
>  #define TLB_CONTROL_FLUSH_ASID_LOCAL 7
>  
> +#define ERAP_CONTROL_ALLOW_LARGER_RAP BIT(0)
> +#define ERAP_CONTROL_FLUSH_RAP BIT(1)
> +
>  #define V_TPR_MASK 0x0f
>  
>  #define V_IRQ_SHIFT 8
> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> index 571c906ffcbf..0cca1865826e 100644
> --- a/arch/x86/kvm/cpuid.c
> +++ b/arch/x86/kvm/cpuid.c
> @@ -1187,6 +1187,9 @@ void kvm_set_cpu_caps(void)
>  		F(SRSO_USER_KERNEL_NO),
>  	);
>  
> +	if (tdp_enabled)
> +		kvm_cpu_cap_check_and_set(X86_FEATURE_ERAPS);

Should this be moved to svm_set_cpu_caps() ? And there it can be

	if (npt_enabled)
		kvm_cpu_cap...

> +
>  	kvm_cpu_cap_init(CPUID_8000_0022_EAX,
>  		F(PERFMON_V2),
>  	);
> @@ -1756,8 +1759,13 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
>  		entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
>  		break;
>  	case 0x80000021:
> -		entry->ebx = entry->ecx = entry->edx = 0;
> +		entry->ecx = entry->edx = 0;
>  		cpuid_entry_override(entry, CPUID_8000_0021_EAX);
> +		if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))
> +			entry->ebx &= GENMASK(23, 16);
> +		else
> +			entry->ebx = 0;
> +

Extra blank line.

>  		break;
>  	/* AMD Extended Performance Monitoring and Debug */
>  	case 0x80000022: {
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index a89c271a1951..a2b075ed4133 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1363,6 +1363,9 @@ static void init_vmcb(struct kvm_vcpu *vcpu)
>  	if (boot_cpu_has(X86_FEATURE_V_SPEC_CTRL))
>  		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_SPEC_CTRL, 1, 1);
>  
> +	if (boot_cpu_has(X86_FEATURE_ERAPS) && npt_enabled)

Should this be:

	if (kvm_cpu_cap_has(X86_FEATURE_ERAPS))

?

> +		vmcb_enable_extended_rap(svm->vmcb);
> +
>  	if (kvm_vcpu_apicv_active(vcpu))
>  		avic_init_vmcb(svm, vmcb);
>  
> @@ -3482,6 +3485,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
>  	pr_err("%-20s%016llx\n", "tsc_offset:", control->tsc_offset);
>  	pr_err("%-20s%d\n", "asid:", control->asid);
>  	pr_err("%-20s%d\n", "tlb_ctl:", control->tlb_ctl);
> +	pr_err("%-20s%d\n", "erap_ctl:", control->erap_ctl);
>  	pr_err("%-20s%08x\n", "int_ctl:", control->int_ctl);
>  	pr_err("%-20s%08x\n", "int_vector:", control->int_vector);
>  	pr_err("%-20s%08x\n", "int_state:", control->int_state);
> @@ -3663,6 +3667,11 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  
>  		trace_kvm_nested_vmexit(vcpu, KVM_ISA_SVM);
>  
> +		if (vmcb_is_extended_rap(svm->vmcb01.ptr)) {
> +			vmcb_set_flush_guest_rap(svm->vmcb01.ptr);
> +			vmcb_clr_flush_guest_rap(svm->nested.vmcb02.ptr);
> +		}
> +
>  		vmexit = nested_svm_exit_special(svm);
>  
>  		if (vmexit == NESTED_EXIT_CONTINUE)
> @@ -3670,6 +3679,11 @@ static int svm_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
>  
>  		if (vmexit == NESTED_EXIT_DONE)
>  			return 1;
> +	} else {
> +		if (vmcb_is_extended_rap(svm->vmcb01.ptr) && svm->nested.initialized) {
> +			vmcb_set_flush_guest_rap(svm->nested.vmcb02.ptr);
> +			vmcb_clr_flush_guest_rap(svm->vmcb01.ptr);
> +		}
>  	}
>  
>  	if (svm->vmcb->control.exit_code == SVM_EXIT_ERR) {
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index f16b068c4228..7f44f7c9b1d5 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -493,6 +493,26 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
>  	return vmcb_is_intercept(&svm->vmcb->control, bit);
>  }
>  
> +static inline void vmcb_set_flush_guest_rap(struct vmcb *vmcb)
> +{
> +	vmcb->control.erap_ctl |= ERAP_CONTROL_FLUSH_RAP;
> +}
> +
> +static inline void vmcb_clr_flush_guest_rap(struct vmcb *vmcb)
> +{
> +	vmcb->control.erap_ctl &= ~ERAP_CONTROL_FLUSH_RAP;
> +}
> +
> +static inline void vmcb_enable_extended_rap(struct vmcb *vmcb)

s/extended/larger/ to match the bit name ?

> +{
> +	vmcb->control.erap_ctl |= ERAP_CONTROL_ALLOW_LARGER_RAP;
> +}
> +
> +static inline bool vmcb_is_extended_rap(struct vmcb *vmcb)

s/is_extended/has_larger/

Thanks,
Tom

> +{
> +	return !!(vmcb->control.erap_ctl & ERAP_CONTROL_ALLOW_LARGER_RAP);
> +}
> +
>  static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
>  {
>  	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VGIF) &&

