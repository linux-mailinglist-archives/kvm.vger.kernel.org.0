Return-Path: <kvm+bounces-7387-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AF0E884133B
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 20:22:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 26B161F21DDA
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 19:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9293560EFF;
	Mon, 29 Jan 2024 19:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bxEqloTG";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Lvce+xWF"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F3047F50;
	Mon, 29 Jan 2024 19:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706556108; cv=fail; b=ZDIEUkHDXIf3FDM8Oq4hIzEUZkPPBAAKdBwcyetHU1cIRbKMqiCV7jIbv613ZP2S2gIxRAKjCiKZ3vFUk1H5I33+qdldwFVA+vSfU2YOHXn2/BM7Yz+zxGSdt205yqSCAYTjRKBRIwQGpA/5XuUYxpWatoXmmWzlBMdWiaPMLSQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706556108; c=relaxed/simple;
	bh=ziqUOAHpg539ZONEuvmzG2Gyzc/KGz4PATzUz+mh5dQ=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=i3BIVWFXud536M3JSxt02iiW2r8jk1AY+WZSQ7TPFfl2MwijYvt0vltnz/fooO3i1/zlzO+rIO06EPbcmzUubVjn7E4rAnZEqvM4bwUQGXzIGSOyqiQiB2a2UUiKjvEJcszmTfqIKAjEEYh+rb+rzxvboLeV25Bj9P3JilkKrPY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bxEqloTG; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Lvce+xWF; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TGnQPY017943;
	Mon, 29 Jan 2024 19:21:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=IOf57QYmgGDCUTg+VaVCbfhY9IGOWmecZUhh6xt7pW4=;
 b=bxEqloTGu1pKcxArvNIvK/wYjZXLZRzE7Niklwf4GghtjkgYBILIpiJKO5ibHNQDqga5
 acBHctngKURPJXu0Dz2zoErRG0t6Gaq8uoug5yCmkqxwlm7E0qNKjdn6RFYZXcWE1mQI
 jthrFx0tx5QUJJgqZZsm79f+YALBGe9HL4KLRvLqqlF+YIyxqwX8RserAW5AeOnjAu+b
 UQa0wSlWFeDsKJwFvyArp3c0YUh4VGboa/s4+DuVCpyMpCL3pmfj5PnS3W8Vj3Lqf+OH
 zHZS7di/RX5Cnk713/kz5fXniSVAt5OBkQGdsqjtqc3jREkZ6Yti7niUkZu6srf/BJsF /Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvrrccu4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 19:21:08 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TJFT85031526;
	Mon, 29 Jan 2024 19:21:08 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr96ay60-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 19:21:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hoc4Zb6XLn1WQQVarBzdOBxwzeOGo6QnmhT5t6h8mxlTkedOHGwcDNW6jfDGOtDCbL8knIj5ghlDwEEhLf7B4zDcBeTKcXX2xYJYkDDgK2niUam2dVN2gO+aXZdtzlyjroLqe1LkF33nLeQL6ZRPx1aLGAhHqJtkNwtkTYBkL0f5m5YLm+Ig8RRh0k37k0BkLfEE55ibC/dw2k0v4zimjsefggJx/8xdvTCCPKqBy4ukmIJUJjNDfblIPyi5UByoUNchvqNaAEAVswARSm9yH6skDFckR/unP1Klv7gQq7VpkijPqOyxPspT6Q/0JIuG7nSyHsldncqpDzKWk8jVeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IOf57QYmgGDCUTg+VaVCbfhY9IGOWmecZUhh6xt7pW4=;
 b=Wp2/UmdYP5dhUaQG1PEnXx8niBU465CwFBF634yrkzQNsAU64OJPP7LlLteH0bdMnn3zxHtqTPJf4Wew5OZcm/MAe0OhNoBFZe9fOGACnVG8tef4wYg/mCYxQVgibbfqpDhWJWL+kPdalVvPXW1v+JXd8r73WjIaCcnnuOmZi4d6UHGGKeAKoYr7HVOtgQjPdmJJLpvEtCxoZgPYIEgU7ClIAyDOWcTITXiztTT7qUQRgkY2omYLykIgk32SU0V9XWMZwbNSviruKZV10kRaR3u8InvkCQtLUudf8va8wJQV0C4sihrhaVmOOCYgljfa7CWe450sC7Y13KhjvLHTUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IOf57QYmgGDCUTg+VaVCbfhY9IGOWmecZUhh6xt7pW4=;
 b=Lvce+xWFyWtFN4yLtgCTUc55ZEkUwoeEEchQV9FdCukx8xUfm4k9lACrR0prjTe7qVOAKWWKGGbu+HHfz5Nic2T2JXG2LAOseDtX12fZEmvh7YUgtrdPyt98WCL4IN8xmJaKwGGNPdX+AE6Sa3xunHAsVUfVnfZham9jOHMybs4=
Received: from PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22)
 by CH3PR10MB6764.namprd10.prod.outlook.com (2603:10b6:610:144::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Mon, 29 Jan
 2024 19:21:05 +0000
Received: from PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::6fec:c8c5:bd31:11db]) by PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::6fec:c8c5:bd31:11db%5]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 19:21:05 +0000
Message-ID: <ceab7277-b95e-477c-9729-d46dc5be54c8@oracle.com>
Date: Mon, 29 Jan 2024 21:20:57 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] cpuidle/poll_state: replace cpu_relax with
 smp_cond_load_relaxed
Content-Language: ro
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        catalin.marinas@arm.com, will@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        pbonzini@redhat.com, wanpengli@tencent.com, vkuznets@redhat.com,
        daniel.lezcano@linaro.org, akpm@linux-foundation.org, pmladek@suse.com,
        peterz@infradead.org, dianders@chromium.org, npiggin@gmail.com,
        rick.p.edgecombe@intel.com, joao.m.martins@oracle.com,
        juerg.haefliger@canonical.com, mic@digikod.net, arnd@arndb.de,
        ankur.a.arora@oracle.com
References: <1706524834-11275-1-git-send-email-mihai.carabas@oracle.com>
 <1706524834-11275-8-git-send-email-mihai.carabas@oracle.com>
 <CAJZ5v0gPoLan0M2A-x5V=ZNCxbYdv5e5DvNZTyo6Bd3e9HThYQ@mail.gmail.com>
From: Mihai Carabas <mihai.carabas@oracle.com>
In-Reply-To: <CAJZ5v0gPoLan0M2A-x5V=ZNCxbYdv5e5DvNZTyo6Bd3e9HThYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0021.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5e::33) To PH0PR10MB5894.namprd10.prod.outlook.com
 (2603:10b6:510:14b::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5894:EE_|CH3PR10MB6764:EE_
X-MS-Office365-Filtering-Correlation-Id: 6448c2fb-0ae3-478b-027e-08dc20ff7051
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Wkdwp34bxQvNgnkqMSDAnGtEO7m3o5YM7QUu9kdmwjRWYPg4YluXaGArnM6rdEUBN7F8p/WlhJb+6DtEHKkvmNWx5vdQFrbHEFAymQ0BAURQDLmxqJTTvSkOEnDfsoBUqtKqCbqzfSlgRSyKIYSE6TiRZ8mTS4sGeb8GgJLZd4BNXPLoUk5t55Ym6NqXj4bLbOOKcP+CuSjX4BD1+CHHeMz3j59T6tfiKK5sLUT1PWA0X0UGnh68cxiPaNLXLn2qZnSt676WlZcpE+53IRmAKno34IQzHgv5oiAbGKoL58f6rWicL9QAx7AvbFsx1IW1k+MMmGGGBbRhvd6y43Jk4y/cztKtw926lIozV0MOvR/MPCeghlfi7hNrwYBqBAnbB/MpYq6R2GmjY6vKC2O8tb+ZY4HupxH5swwmE3YjoNSg6G6E9RKhygY62zybAhO9GYfnrdSrk4gKpb9I+QjNkkf9V84Sd+f9RsA3xI8Hu9z2GLMAwSljaz1k9PUGa5I4PdRcimUcGf/W9qd6vTNvLJTljh4zeGynqJF1u5x2fPyjW7VOn6LL/W0rydlphhxlmdByJBwn2NgUQT/1sMcMBzT+bokUf63cGhBdn4rr9/aboxng3l/y3flk5AJWCdkViUbex/S9mJZsNjDeciMcPw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5894.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(366004)(396003)(136003)(39860400002)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(6916009)(316002)(31696002)(83380400001)(66476007)(66946007)(86362001)(66556008)(6486002)(478600001)(53546011)(6666004)(38100700002)(31686004)(107886003)(2616005)(26005)(8676002)(8936002)(6512007)(6506007)(4326008)(44832011)(7416002)(5660300002)(2906002)(41300700001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?V1laVmxMY0NFTzBpOHhGV3RiTjJNVGQrd3pKTVUrWExKM1BlUW9Wa2RjUU55?=
 =?utf-8?B?Q1J3by80c2YzclFMTm5iUkExNVJVcEpIZEthSjlmOWFlSy9SdFZsOS9KeXRU?=
 =?utf-8?B?N1NyRGo1aVVIQ1lxMnF1VTkvN1JzTTRvUUFoMWhDTisxWmpUbGFScHR5NVh3?=
 =?utf-8?B?Rm5oS3J5bldNWTAxSVg0ZHFnYVBYZzZ1b2pzSlhTcWZVV2MwbjB5ZFRUeXZ3?=
 =?utf-8?B?UDAxdXNlTk5rT3RCOEU1Rm55SEIrRHhuaVFkNHVtSDVMU0l5VzN1aXVURU5l?=
 =?utf-8?B?Q2dwNEN6cXl5Y3I1NXdCMUxRZjNlc0Q1aEh3Uk9OUEVFZy9pQmwyaU0xWmtt?=
 =?utf-8?B?Q3UzU3NGdEkreUZyQ3gyNVMyK0Y0Qjl6enNRc2N4czZsWmY5RHRVK0dIS1VN?=
 =?utf-8?B?a3NBSzhUTDFjb3BPZnlBZW1JOXFxWThWRHFMb3lTM0xrQ2JrQnQ1TnE4WHVz?=
 =?utf-8?B?L1JUQklueWtWZUtKdkZsQXVhS1I5ZGZoNXhrbTN4WlFXcUVNSEUyYWw2VE9D?=
 =?utf-8?B?blNzYlk4anpSM2VmK1RiWVRCbHpZd05iUzlWUmhIRGZxMmlRTmlyKzRvSlVL?=
 =?utf-8?B?cVY1NHp3Ry80T0Vubmo5c3U2a1lnUk1HcWxXT2h1NFpjdzJTcHk2Umh5UEMv?=
 =?utf-8?B?Y0d1c3JGUFNkc0piN285RmYyWjZMQWFGY1pJeW95bnM3S3cwdW92ZURLNTY2?=
 =?utf-8?B?dEU2Q0J1a1JCRE5McXBodExOd2VxOXE0dFlEeUJkdi9KTkZHMHEyak83dVhD?=
 =?utf-8?B?Q0taeDNrN0NRYnR3Q29TMEs3TGYrWGVVRjh3T0xEY01YQlJKS0F1MEtxY3Y2?=
 =?utf-8?B?aFdtMEhjR1AycXZZd0dTL2lSNUorSEZjcmFNOHJKcWZjblQxUG5rNmRaQkx3?=
 =?utf-8?B?cGdrTm1HTXB2Z2h1cWMxQ0dtTkJZeTdETXhNOWhWTFNFTkF0WlRnYldHbFYx?=
 =?utf-8?B?UHBQa1lTa2E2YlJIajd2SjlUNDNCRWR5L3hON3VjQ3BGMGszT0xpdm4xY0JT?=
 =?utf-8?B?RmlFbXZmWkVXT3VjaldZSVFMcXdYWDdMbWFodUtkSXV0NzRjSzlJU21Jczll?=
 =?utf-8?B?OFVzRzhoTitwZ0tlTzhPUkFkbU9rM29lVC9TRVYwQ2lpOUFkYWFXNDcxSFVz?=
 =?utf-8?B?b0tzakNBTWJENy9ESmEweTlVcExieDR2aTZEV1J4bFA1eWVPZ3A2Sy92NFlX?=
 =?utf-8?B?NGJGVS8wdmF6MktNMU4xbWU4MHhOeDhQbUs2NzJkN21QMFR6VUZmaElKaVAw?=
 =?utf-8?B?RHRLNDBvL2RPdlVKZG42RWlpakFXb1BnOHRORGRaZUN3MmlJMEZPemppNDZG?=
 =?utf-8?B?dUF4UUpYZk5pKzkyOVE4VDBuQUtOYWxiRDlhaUREZWJxQzJnaU92MWVBT3ky?=
 =?utf-8?B?bUxmUVBIMnFZR1FPZUdzQ3NmS0RhclZSVUt4S0VBUWRQMDM0OTNlMk1reWxT?=
 =?utf-8?B?dUxUMkkzcTR1WTJMY2dJRjFyWXFOYW8ydi9jWFozUTVwMHBXQmFOK2lxTDYr?=
 =?utf-8?B?SzNwT0ZQM3c4RGNkWHZ1bkhaSUZsSnd0L0hPa1NuTW5aNEdiQnkzYXBKNHFi?=
 =?utf-8?B?eG01aWlxMTRYK3ZOMUt0OFpoWE92MTJSNUFIWlVQcUhrelp1UWZkUWdoVlpK?=
 =?utf-8?B?YTh5c24zRkdmd2FKRmV1Z3JNY3d5UDJKenIrZEk0UVoxNXR5SVVyckJJVTdI?=
 =?utf-8?B?MjlvSlNWd1NnYmZLdVBOQ2ZxQk1KMlhzREVpbkZjQWJwTWM2bUVNVWhWTXJz?=
 =?utf-8?B?bExieFlKVkRBbnU5cGpQcDEwcXdmRm95UlBNNit6RDZDaG04eElzelJSSWwr?=
 =?utf-8?B?aGlSczJNdzVvT2QxazliNGthd0JBblBTLzZ0NWwzZmRPOEgyWGk3ZnJYWWV0?=
 =?utf-8?B?UHlLT1NKWERXYlpnZm41RExBODRhbDRaU3EzcHhxZXIwVUFqcUxlMkFSRnNF?=
 =?utf-8?B?K0s1Qi9uamFyUHR2UHNOa2NUTEJXQVN5UEg4ZTBsNnUwV2JjZ1RFL3Jib2pI?=
 =?utf-8?B?a3ZpV3NsUFRKOUVyNU10MThZTjVzcHRkSlNVVnBKVlhuM09EMzNSakJsZkNk?=
 =?utf-8?B?OTY2U0pJKzZGTzY0dG80TlpUN2p0djhoUXhUb005TGx6UHJtRDM4c3Zhc3h3?=
 =?utf-8?B?bWVjWisxZGQwUWlUbDdGeFdRQjFZTWVGRFk4cGRMZzJ0MXRRWGhyNURMZjFp?=
 =?utf-8?B?eWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	I0GZ31oJ2C9mZAU6ZsnukyKeeHJWHJvlgDC+BLmEAAOwkcnQoOvu4jT0q+ucVI9VFaeSO5dNl7rdSRMeO0CY2EdStufZ+CvBkv5So1kJtImHGgDOcefj2+WBF9kibP9+3jMtnIgHSvNc14a00PLk0it7aOnGxgbI6wBLRru89GsUOJjU0Hw74xQpxgEFc8LXcQr4k9GfedGr0d6MqxZBfu2lx7nFLrOaF4kol96eULs2hnIscbHyHX27gub2VH0mqsZyYNWtMGojqJyC3tkUJXx5zQ+ph59GJoUtsqK5mhWJFYImKUe1BmMcmZlr11brwFVMUN/P3A6cOlfKTVccQMPCZx4i2MKUTPT+r+b3eW3kSnhWE145FcRiTONZj1dSb3wQxrxr/EX+TeMKe8jEzx4KcE7saxBcwcCiUwtDEZC/nXwS+dZ/KwbSt58qtnDU252Tc7h6vG4kF5ePbHDTid9BhX6uEoVJ2Y2aMbn2hFkC3Z74OpEy7M1E9x+Oof++6D7Tr03q6a74e7Ul9cTqGj1syPus1apoo9rn42a/ZnuGV0F5weIgjibBloNQ8+b+LNnPoVA+wreF+3ZhekbC5GpWdQKySG230wnPmZjZ4GU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6448c2fb-0ae3-478b-027e-08dc20ff7051
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5894.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2024 19:21:05.5451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5dY32evWWmWY58o6edOoL75LVOQVzfico0sD4ZrEJETpEKE3ULdSFvvs7Kdpj/66BjlrXgdOvKYA1zpLin0SyDekXH+TZ5BRvbCcvgeqfJc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6764
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_12,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290143
X-Proofpoint-ORIG-GUID: DQuZU-oyJiilDI50gs3QwdAEUQGUKwye
X-Proofpoint-GUID: DQuZU-oyJiilDI50gs3QwdAEUQGUKwye

La 29.01.2024 16:52, Rafael J. Wysocki a scris:
> On Mon, Jan 29, 2024 at 12:56 PM Mihai Carabas <mihai.carabas@oracle.com> wrote:
>> cpu_relax on ARM64 does a simple "yield". Thus we replace it with
>> smp_cond_load_relaxed which basically does a "wfe".
>>
>> Suggested-by: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Mihai Carabas <mihai.carabas@oracle.com>
>> ---
>>   drivers/cpuidle/poll_state.c | 14 +++++++++-----
>>   1 file changed, 9 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/cpuidle/poll_state.c b/drivers/cpuidle/poll_state.c
>> index 9b6d90a72601..440cd713e39a 100644
>> --- a/drivers/cpuidle/poll_state.c
>> +++ b/drivers/cpuidle/poll_state.c
>> @@ -26,12 +26,16 @@ static int __cpuidle poll_idle(struct cpuidle_device *dev,
>>
>>                  limit = cpuidle_poll_time(drv, dev);
>>
>> -               while (!need_resched()) {
>> -                       cpu_relax();
>> -                       if (loop_count++ < POLL_IDLE_RELAX_COUNT)
>> -                               continue;
>> -
>> +               for (;;) {
>>                          loop_count = 0;
>> +
>> +                       smp_cond_load_relaxed(&current_thread_info()->flags,
>> +                                             (VAL & _TIF_NEED_RESCHED) ||
>> +                                             (loop_count++ >= POLL_IDLE_RELAX_COUNT));
> The inner parens are not necessary AFAICS.

Provides better reading. Do you want to remove these?

> Also, doesn't this return a value which can be used for checking if
> _TIF_NEED_RESCHED is set instead of the condition below?

Yes, indeed - should I modify this check? (somehow I wanted to preserve 
the original check)

Thank you,
Mihai

>> +
>> +                       if (loop_count < POLL_IDLE_RELAX_COUNT)
>> +                               break;
>> +
>>                          if (local_clock_noinstr() - time_start > limit) {
>>                                  dev->poll_time_limit = true;
>>                                  break;
>> --



