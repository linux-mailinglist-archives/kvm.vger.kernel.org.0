Return-Path: <kvm+bounces-7014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDE983C4FE
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 15:40:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ED72A1C2256E
	for <lists+kvm@lfdr.de>; Thu, 25 Jan 2024 14:40:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D9D46E2D0;
	Thu, 25 Jan 2024 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lzDgOscR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="yl7TU3Wc"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0143A1B6;
	Thu, 25 Jan 2024 14:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706193636; cv=fail; b=CDcRfhTlwL0+2xcn+4O6SnVpRmOnpt9UHZbZXv9oaDcPmgPcrpoVytC/gdNoZDF51KVIhqv7zF2SVIKSMBHpoE/Gq8Xg5pzvL+Qu1hgp98EtXc5F12YgaUWfbDJmnr2UJ9UKWyyiGEdB5Gc7WGdV3ut4Txl2f2vPyx1lUCjo2nk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706193636; c=relaxed/simple;
	bh=n5n5UIaAAtKvCad9DcaCS2h+DfPmUhnVL2Z+gX2Tmvs=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=GyhAfh9V78RXEWjCLCELC6aYF4jTMlWQ7hxbrreQGpzDgY4+GxT1o+cfoHQZXXuPl4L4aHrLZQSK3tySwy92WiCD4wB31XC13j046uIp95//SphHXNCETcqd3es+N7BmwWCjCpwv87+2lJfX+TC0GkgDo7v0Eno4ufksH5euKQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=lzDgOscR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=yl7TU3Wc; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40P9xb6O011464;
	Thu, 25 Jan 2024 14:39:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=Yn48hwIbpxDehRbISBrE7EGXYZaOlL+DfKIsvMnv7Ho=;
 b=lzDgOscRufvE21xIF4+WsEHHy8UA2tshF/6p1464qhnpXURgO7sltbJ2bUFZK+xnrdtk
 CbcLptpsvFuQjFbtsws0HudJCNhloz/DdVye2YXFJXF7DIuUGz3t7wFRl7dBBpRs2GpX
 irwNOCS1wDnR6bqicsxE/UfYLkVlv5E1gsRTyyfLEiGpT1Zh7IwLxD8nUq9MWKFryi6I
 ke6bMr3FdYaAdrSo/AxL3dkVbQLZVkBJD22lwnprIW/oEtGgPPGRfsHeadg57zRUmJfG
 xCi2zUb5iyynxkZYVhTBHE+yVxdYNptYbjgwXDUDhZ+ZUKg6UdVuKWESIz3C+jvISG5L kw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7cuy9x6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 14:39:43 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40PDdp5M030812;
	Thu, 25 Jan 2024 14:39:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs374yq8s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 25 Jan 2024 14:39:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WgDiBs2RMis9cJP3roeoU9Hy5ek00T/2yls3D9qqDNvXUqzb0AndbwsHyDBTUrHQldtwd0iKUe1ZhBNhe1e0/vcjEgqIaxjZ9f+S1jHvRG1QWG5CCVVaVi7o+56O2mDgxiwuS/lXpHHx1bQ15Y4VGjKt1wiWagrFnlNoybQPwhOUDvi4PqysCys3dbOxppuhOzmlw/DmMRd+cqoyRm7HvilkZIzTbceQwach742/5w828/xiFPjIFVTPVF/meoTVE7HPcszHW4azjQuB361KBKX3XWQwOfj7LesrtFZiBaUdGnAJZiAArpTGZx4by1lFsifR+hL2ff5dHqxDNknNMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yn48hwIbpxDehRbISBrE7EGXYZaOlL+DfKIsvMnv7Ho=;
 b=jjmyl5xce6xUBYXCxrOEyqaX9Nph56C5PP6gEBv3VvmFzXDnl+/A8zmbqIx4b91C/NY3Z/dPO64P7S5MEi4UpDkKo4wlq+RgEXy9I7+hjf13tm+aZzHuu11ED8b4STeUAhyV+3ckSNHxIXiLLp0FgirGqkBYq8GPOiTfkH+ayMf/f/FgszOV5hEevwT9MaxL0+nQP1mpbZTZFwa99ivoTIWax1ui32Qo/vPlmQajRPfZKNCB1uvrIVA7eEYA2nxvbT98Cp2Us3tUm11R1U+c8krK8pOfuiVcIaxrykYYxgucpClPX+D9Idh7h0xdXdL6f3l+gMjr6lhxFfMam163Qw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yn48hwIbpxDehRbISBrE7EGXYZaOlL+DfKIsvMnv7Ho=;
 b=yl7TU3WcJ/Y8IoSS7XLV5hVU/ek7XC/yaSTLK4OW8mbiDHFx2pjKuLSeLjI7n9WgsfEjUAI7kZvxxCU2lku0MN1KPIavHsUzpMJkizHuR1JSPfFFF8rVnp8oEC7XT/K4W0ottIsxK00/+1f7haZ0JtYUMPtNs/24VY7JxgwmDa8=
Received: from PH0PR10MB5894.namprd10.prod.outlook.com (2603:10b6:510:14b::22)
 by IA0PR10MB6795.namprd10.prod.outlook.com (2603:10b6:208:439::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Thu, 25 Jan
 2024 14:39:25 +0000
Received: from PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::6fec:c8c5:bd31:11db]) by PH0PR10MB5894.namprd10.prod.outlook.com
 ([fe80::6fec:c8c5:bd31:11db%5]) with mapi id 15.20.7228.026; Thu, 25 Jan 2024
 14:39:25 +0000
Message-ID: <88356fdc-91f4-4f43-97a5-3da0ce455515@oracle.com>
Date: Thu, 25 Jan 2024 16:39:17 +0200
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] Enable haltpoll for arm64
Content-Language: ro
To: linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, x86@kernel.org,
        hpa@zytor.com, pbonzini@redhat.com, wanpengli@tencent.com,
        vkuznets@redhat.com, rafael@kernel.org, daniel.lezcano@linaro.org,
        akpm@linux-foundation.org, pmladek@suse.com, peterz@infradead.org,
        dianders@chromium.org, npiggin@gmail.com, rick.p.edgecombe@intel.com,
        joao.m.martins@oracle.com, juerg.haefliger@canonical.com,
        mic@digikod.net, arnd@arndb.de, ankur.a.arora@oracle.com
References: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
From: Mihai Carabas <mihai.carabas@oracle.com>
In-Reply-To: <1700488898-12431-1-git-send-email-mihai.carabas@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0007.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1d::6) To PH0PR10MB5894.namprd10.prod.outlook.com
 (2603:10b6:510:14b::22)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5894:EE_|IA0PR10MB6795:EE_
X-MS-Office365-Filtering-Correlation-Id: 237f81cd-d509-4cd0-6b37-08dc1db36d7d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Zn1Bbyf3dEmhs+HZoz/QnFearIYuEi+WS/Yl1PxR4fnn5qihqYYuBZyOjGbq9IwVSZUEUMXKu+UDC8TuFHN+D9HDQCg/K1jnOOTqVa7A5TuT0fZSlTsQXAYQx22Myh9D4KlZJlPTInfnGHs7WcoDh6djpIXwBDGPwHm7n464FnTpLlzjl+K+cGakqq9RiCyN5CfN7W90LvI4ZrCVumSsF9FQu9Z2TEw+ZUcwVZjsySIN2sebo9TNhlOYgzKvOhpYUBcmyfqBLGv8LXV3e6+H/wV9f39Rwu9H05GDCPhaiANU2ywjsGTLV4+v2cwXNqZDaT1lEFo/+wTu+2EvicHWhk4aw77tFcZE8VeQyzIa+NpjCnvU13+IAgM0u8c04CQHhhEg3HqdJ8U0RdHu3Vju6hKtORfYa2VwZNLYRMRoQFsT3vZV/MQqXk1mtAYDg0T4qcdRPnfrK4DxZvp3C+g/KrQ2PsI4idy+fOuEefVrPH3erTHm1ew3bFrNFLf+IPtgu9iVsd9VELqnVDLjW5KSUfiWZUnmLaljQdPB3+QlCum2FUea4aPrFK2Thm/vvTAqbCaZ7pBd8BxW5u7CGWZ0jONYI4r5Icxa2Vd5iVFAPKDZg+hkZGjlYQ4H8hdKNbztszJQGtihSrlvY6TJBvPMRA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5894.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(366004)(39860400002)(346002)(230922051799003)(64100799003)(451199024)(186009)(1800799012)(8676002)(8936002)(83380400001)(4326008)(66476007)(66556008)(2616005)(66946007)(316002)(6916009)(107886003)(26005)(2906002)(5660300002)(44832011)(7416002)(6666004)(478600001)(6486002)(41300700001)(6512007)(31686004)(86362001)(36756003)(31696002)(6506007)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ck1MbUZqTit1c0VTWFFCekxNNGk1RXRKZUVwUGdNUDJNdmFneEZGRmVIUWx0?=
 =?utf-8?B?UmZHVEFwbFl1NWkrMEdqNE5CQ3d2RENPRmdNQ3VjUUhvamkybUYzOHBHWWxD?=
 =?utf-8?B?RnhNQjVMV1g1T04rZEIvTmpRSytzb0lxVElNOGQ0R045eThBV052SFZCa09s?=
 =?utf-8?B?ODJ3L2crTEZ5NnU5Q1NTcVFMV3M1MlhzS0RrRmE4Zm93UWdiL0tOLzZZbUxY?=
 =?utf-8?B?bysrS2pRZUhzMVp5VGlFTVcxaUxjbDFtaktuMncwaWNsbFJobnk3Ny8zN0Vw?=
 =?utf-8?B?dFdUbXMzaGRuYmNKQWJZSDg2RDNOazlndjFBencwYWZlOGxyMUYwSGovd0k2?=
 =?utf-8?B?ZytMcmxsWUlXb0xzekc3VlBpcG9EeXhRaldCSGxzKzU3QWRhNnpLZURCTDdF?=
 =?utf-8?B?TTIrNG9JeDQ1SHI2QzYrdmwwdE1lQjN0MlM2TFdXamgrNUZZZGNtLzlTanJO?=
 =?utf-8?B?UmF0cnUzUG1NSDZRL3FLZGw1R01oTUNVL1RtdGwvMmtpYWxvTUZZUXpjVmNC?=
 =?utf-8?B?dHcxbnJObUZZaStCOEUxOWJRZkpiSm1OWEYzZVJxVit2b1o5WVgvRmFmc2hP?=
 =?utf-8?B?VDBFTmdUM0J1K1V3ckRZQS9tTnZlS09rTlh2eVhNUmlqWExEVWU0cFp0K0xt?=
 =?utf-8?B?L2JOODZMeFFBdG91ZUN4cXhreWlxeHM3MCtHZ2RINGNVUjMvcksrclVmeDdP?=
 =?utf-8?B?ME9jWEJmYTlKZDc1VWxsbk5EcXdwNFZCYjZueG9ITG5WdWNSNml2N1RUdlVk?=
 =?utf-8?B?MGhEUmpLWFVkSnIrbG1za3BMWjF3Y3VZenNxZE4vbmVFOTNtTm15MjlRVEdw?=
 =?utf-8?B?a0N6c0RXNXNtMnhDSUFkMU90bnE2UVNpcG1aZDNPVUxIV2RuS21mZzAvL0Nj?=
 =?utf-8?B?VlQybkZvYXhqRlZaSXdNdkMyREFReHc4YzVOKzJKQm5uZmtjUC9LcGxQWXVM?=
 =?utf-8?B?SkxxMlllSmxEQ2IxU0hQaTg1Vlc5NVFqb1pNUS9lOERlREtYbjVVRWx3Sks4?=
 =?utf-8?B?V3d1dlFZVlBzNFh2Wnh4MEJYNGZXWHF1K1pzSU5nUEtrMWRLa3VxS1ZHbkJT?=
 =?utf-8?B?TElvSjEvZHJON05IQ2Z0Q0xjMkJuaDRkeWNRcDdVU1BqKy9Jc3E0YkdHTHkx?=
 =?utf-8?B?ajBDTmNCZFhYUWRoL2RjcFJ5QmVyTkd5a1JqYXJTV29hbjd4TnJnRUZvVC96?=
 =?utf-8?B?d3JkZlJSenZNc0Nic2hDWFRxU0hGb3p0dnZJUkZ4SU9ESkVaSDlxS29XRkNT?=
 =?utf-8?B?ZGtoYnBOTmxGUThHWmw1RUx1bXA1citEVmt3UXFETVV0UGZZVlljV0tLN1Nk?=
 =?utf-8?B?SEYrbFlQaUJlVlRZQk5XSkFjaWZ2ZW0wUzJ1bENDdDllV044RU1oSHVOaDA5?=
 =?utf-8?B?Y3JzVXBKYnNNRmN6MGg4ODJ4dVB3WTNjYVRSZFFmNjdodjM5c1NCYVRzb2Jw?=
 =?utf-8?B?SVhOazV6bmY3R2N1cHl1ZFp5WE1kZnFmSmovSENicDV6ZDVidElmZUNCN3NF?=
 =?utf-8?B?cDVJMjhySWY5bmplejRVbnhVcFV6bHZNYjA1cXhtMkVXd3M4aGppcjIxamVN?=
 =?utf-8?B?QklKbE1sTUNjNXVZY2NvWHpFNVVWVVU4NlVJdmp3a0ExOUtLYWVjQlR0K0RM?=
 =?utf-8?B?UEluRk00TnB2U2M0WHZPaEEvaW9HbkIrTkM5TTU1d080Z3ZFMGhYWktqYXkr?=
 =?utf-8?B?TG9QWlBKVGtIYmZ0R0NFbks1RkVsckZhcmUzUDNUVmtJc3dxRHpER2RRbXJa?=
 =?utf-8?B?Ri8wNkZwU1pDT0ZENm01TDU3L0RkZ1p3em4vbXNsbUVENnNaNVV6VW1OdmtD?=
 =?utf-8?B?N3BoMElNdzQxSFU2VTlhQngvbFJibmhqYWxCNzlRdE9rc2RtakluR2loRTE2?=
 =?utf-8?B?cE15c204WVZyM0RUUlhoNVAyd1grbEJ3NVlEYnVmblI3d2RXdjlPSnF1ak5l?=
 =?utf-8?B?ZjVXdUc4SHRZZzNOT1FWL0RMdE9nMGEraXVRc3gzWGRpUGNQOUo2UG11eHhv?=
 =?utf-8?B?TGZRM053VWZzTmUrb3pSQzhJaEdPSURBOHppeldSaUpVWTdiWXEwOTNsa1Rn?=
 =?utf-8?B?YTIzb0pVRXk4S05vSVhzTW9QSHMwam9mV1cvS2o0eEs3dEFaUlc2U1NSUXJx?=
 =?utf-8?B?TVZSUVduSjFMYm0vWG92Y3FTYmRlRnpSdXl5UHpLTEFZYWV0MVBqZU44MjhQ?=
 =?utf-8?B?Tmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3v+NLcTopEYMt5rtY7XP4IiqNjHPime/mL6n8PUYWRyDs4elftYLuMKRc+TUd0za6hsXnq0RuojDhAL7slE1gJ78VDsa9VDq0K02GEwH77ZXtP2KC2qfPak9OkYjL6hJ7n3m0MLFNAl7uf32Y/Ca2GobBe2k91AOhpNFTkqLzH8k4HJ5w3Mox3cLa3xvMFuUayRqS+nTjzJTWr2pE6ZPIoIa14MUMqf2PxUR2e3n4+sMYNziGewIiqpPQk7jETrpZoknvWrkVIV/RklOW15KQxBq4g/d4fzOtF4ROplv6oP8O/lH0a5f38bls9MhcKebUdp07n/fjdhmP0FbdFsNhcvm5X2JDdWXI4WJxB74UsQVsjM9egFF45RtXsXCkbszWyrojwHvHs3Telcm0C/Yc1G00PYM1fFmpP04WFELszKsS8eaFoiPcwgFGjA1vG62trbbwhUe5YPpQS5rQtfYAbptuizNnTFIBgZ+OkpFL6RZcPZTgQorwOC8NlMydLYMxLqa9O6NnoZXwd+0yqh7ur7CcUBG72PLbstgEQ5pm6gtwcmmjOMk4l1jXWQJll8Taoaf7zS/NdlUnyzNm6dLCYeQCM4g59j9sq9yp9r2oro=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 237f81cd-d509-4cd0-6b37-08dc1db36d7d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5894.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2024 14:39:25.6246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bq7BJu72wv5CgiIVPbswTQ+QUhTfWdu8NL/DkRqcXDTV04l6mU1Qbd/Cjwnogc8biXSfMg1eYT5mIbFkaoB/wGWBKJW0CkpHFyApXwCSGl0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6795
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-25_08,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=910
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401250103
X-Proofpoint-ORIG-GUID: DBALsFCEFd98AaqlC4EMveNeQYNviGyu
X-Proofpoint-GUID: DBALsFCEFd98AaqlC4EMveNeQYNviGyu

Hello,

How can we move this patchset forward?

Thank you,
Mihai

La 20.11.2023 16:01, Mihai Carabas a scris:
> This patchset enables the usage of haltpoll governer on arm64. This is
> specifically interesting for KVM guests by reducing the IPC latencies.
>
> Here are some benchmarks without/with haltpoll for a KVM guest:
>
> a) without haltpoll:
> perf bench sched pipe
> # Running 'sched/pipe' benchmark:
> # Executed 1000000 pipe operations between two processes
>
>       Total time: 8.138 [sec]
>
>              8.138094 usecs/op
>               122878 ops/sec
>
> b) with haltpoll:
> perf bench sched pipe
> # Running 'sched/pipe' benchmark:
> # Executed 1000000 pipe operations between two processes
>
>       Total time: 5.003 [sec]
>
>              5.003085 usecs/op
>               199876 ops/sec
>
> v2 changes from v1:
> - added patch 7 where we change cpu_relax with smp_cond_load_relaxed per PeterZ
>    (this improves by 50% at least the CPU cycles consumed in the tests above:
>    10,716,881,137 now vs 14,503,014,257 before)
> - removed the ifdef from patch 1 per RafaelW
>
>
> Joao Martins (6):
>    x86: Move ARCH_HAS_CPU_RELAX to arch
>    x86/kvm: Move haltpoll_want() to be arch defined
>    governors/haltpoll: Drop kvm_para_available() check
>    arm64: Select ARCH_HAS_CPU_RELAX
>    arm64: Define TIF_POLLING_NRFLAG
>    cpuidle-haltpoll: ARM64 support
>
> Mihai Carabas (1):
>    cpuidle/poll_state: replace cpu_relax with smp_cond_load_relaxed
>
>   arch/Kconfig                            |  3 +++
>   arch/arm64/Kconfig                      |  1 +
>   arch/arm64/include/asm/thread_info.h    |  6 ++++++
>   arch/x86/Kconfig                        |  1 +
>   arch/x86/include/asm/cpuidle_haltpoll.h |  1 +
>   arch/x86/kernel/kvm.c                   | 10 ++++++++++
>   drivers/cpuidle/Kconfig                 |  4 ++--
>   drivers/cpuidle/cpuidle-haltpoll.c      |  8 ++------
>   drivers/cpuidle/governors/haltpoll.c    |  5 +----
>   drivers/cpuidle/poll_state.c            | 14 +++++++++-----
>   include/linux/cpuidle_haltpoll.h        |  5 +++++
>   11 files changed, 41 insertions(+), 17 deletions(-)
>


