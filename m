Return-Path: <kvm+bounces-15342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 266048AB32E
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 18:18:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CBC872830C9
	for <lists+kvm@lfdr.de>; Fri, 19 Apr 2024 16:17:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEE89131E27;
	Fri, 19 Apr 2024 16:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CJ3gdI5w";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YEE1d7lk"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99655131BBD;
	Fri, 19 Apr 2024 16:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713543437; cv=fail; b=Lh+R5dLR83iy5vvUu06HYtqXYMs/gwWZfyThdufQDcJlU5++8iOdRJPwGrzusxFjq4FxUjip5rs7NCKNqmmxgsvwi3rSJVuDtgM+6Q5k0/YVI+6XvPLI1CzwlWc1B4l+oDheaxsMFhZ7lFHhC4ntIBoXftOda5G4JZ6SzohTEt8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713543437; c=relaxed/simple;
	bh=e+8HrNtaCxQTYPhAncZ7dR0cKN16+lZT4ZRqmwpwL+E=;
	h=Message-ID:Date:From:Subject:To:Cc:References:In-Reply-To:
	 Content-Type:MIME-Version; b=ctINZvI7JCz3LsI3viFt93kCNu0gRlsT6FUqLOgMHA4Nh/nx1SpsJfUiEad2i1Le//080n+EpIV7YfTLf/ysv0hXB0t9s8x32wCmBerQ/spo+UVNPrAXmedVxbHmvZfjui8I/zLPKOni1v4jQlF9bciYUwUd9h2nT2yDRtwykUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CJ3gdI5w; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YEE1d7lk; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43JFVLWI021775;
	Fri, 19 Apr 2024 16:17:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=t6C08vkVzTRxBgEW654fa2E6rX7cvQGAqBuSp/aQRds=;
 b=CJ3gdI5wWxb8ZpOagbFK4n4Omt29xQ5/FeONAKL6ccqopuaIYBVltrGusJ45PxQx4YMl
 PZ1v9j8J3WwLMzpbw/c0+Z6Q3rMh+hPdiOImkJvldEMdiFd01ZwHpOXgxOuCiPjHUbdF
 734m4z2RJ+2T7ASNotVPNQZ5qrSvtQ0FFbubsdzSzbjhvLPJYtmdLti9p5iXIQmS3u36
 21nsxpIfpF+njrPAqsxM63PKGq9zZftn/R3uxhxbjq2fZEmMRp0thN3wzxNNNpbWPUb0
 ICuKnpm/dr2k31aZGbGAlRWIdD0FvhnYd5X76mV3KVEUE9acDbCTOjcVUCaHUJLgoOve mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xfgn2w85k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Apr 2024 16:17:09 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43JGCkh6016834;
	Fri, 19 Apr 2024 16:17:08 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xkbjcb0jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 19 Apr 2024 16:17:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2+hDSLMmGBzpaRm4kp+NoHKPIQhEfZVUz6KF4x9gaAZiTr8pC29alo4j2673jG+Bz/Yt8cfxRaWzNEPqjlOS3BFZTJ+BgbLvGkLoFKtzUTgfWTdq9NyqM0fLZHhGh5zsVfhT8pAnwWWDvQG2sUCWW8TCVCX5tu09UE7k/Dcgl6pf/9yg13UNYOCn0fQeN6Mk4H7oU3jg/CDLcLr3iUic2uPaxk4saFFLaGral5bXhKvrHRXhZ1To1N5qauppkrbWZ4bAe0SNIIK0PeEv16WWyv/+cdPV/BL/FXAPmfKSKBHYKTbhWmo2aaiwOoBqtOXqlDYEf1zMkNnBIvyMxa0hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6C08vkVzTRxBgEW654fa2E6rX7cvQGAqBuSp/aQRds=;
 b=QhfWqaFBjXG+el0tb11i6VSCam+qT+1IUWXRryvk1c99gQ/e+/3Kan9l+cv1t3Ed2i9DWcfvnWnYdLLyY/GodJwsba8c+2VrLVkC0zP5HEByngH4Wh/yHo/gaC6MCUfJaFbWK44eWOqiT/XU/NqiyamCZus9keBDRp5lH4VZyrn30NYsq+iwpV9y5C2YMYfX30E1QpGx+yaJUXZcFrddfr5fAdCgN/+Jmwy6ESVsRnGGjrqyUBXez/9mJNutTRRbJ8CBLIvietTFqjtCUrHZYF/gVCXzA1mKUHHOM539U5BSlRRRlD7XZM8CpX0NmxGUfsqolhHBfrqEKuf6A7sDKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6C08vkVzTRxBgEW654fa2E6rX7cvQGAqBuSp/aQRds=;
 b=YEE1d7lkdf5hJ4N3u/mk6DLz3i9IEelhpC8efvswyLgsuZAKmRd5uf+s2xcet7/pHuJ+io0ZPzKwy9PBPd9Gw05V3F70u4uncT4H1SpYiEbxj+l8Eg4hIyh2GtId+SxWRoUSKQ0OJFFWJ98zf0xDd2dqC33E/G2oHPtOJ8MXfT4=
Received: from BLAPR10MB5009.namprd10.prod.outlook.com (2603:10b6:208:321::10)
 by PH7PR10MB6036.namprd10.prod.outlook.com (2603:10b6:510:1fc::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7472.43; Fri, 19 Apr
 2024 16:17:05 +0000
Received: from BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0]) by BLAPR10MB5009.namprd10.prod.outlook.com
 ([fe80::a088:b5e0:2c1:78a0%5]) with mapi id 15.20.7472.044; Fri, 19 Apr 2024
 16:17:05 +0000
Message-ID: <534247e4-76d6-41d2-86c7-0155406ccd80@oracle.com>
Date: Fri, 19 Apr 2024 12:17:01 -0400
User-Agent: Mozilla Thunderbird
From: boris.ostrovsky@oracle.com
Subject: Re: [PATCH] KVM/x86: Do not clear SIPI while in SMM
To: Igor Mammedov <imammedo@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20240416204729.2541743-1-boris.ostrovsky@oracle.com>
 <c7091688-8af5-4e70-b2d7-6d0a7134dbbe@redhat.com>
 <66cc2113-3417-42d0-bf47-d707816cbb53@oracle.com>
 <CABgObfZ-dFnWK46pyvuaO8TKEKC5pntqa1nXm-7Cwr0rpg5a3w@mail.gmail.com>
 <77fe7722-cbe9-4880-8096-e2c197c5b757@oracle.com>
 <Zh8G-AKzu0lvW2xb@google.com>
 <77f30c15-9cae-46c2-ba2c-121712479b1c@oracle.com>
 <20240417144041.1a493235@imammedo.users.ipa.redhat.com>
 <cdbd1e4e-a5a3-4c3f-92e5-deee8d26280b@oracle.com>
Content-Language: en-US
In-Reply-To: <cdbd1e4e-a5a3-4c3f-92e5-deee8d26280b@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0001.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::6) To BLAPR10MB5009.namprd10.prod.outlook.com
 (2603:10b6:208:321::10)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BLAPR10MB5009:EE_|PH7PR10MB6036:EE_
X-MS-Office365-Filtering-Correlation-Id: ef32b692-e5be-4de7-2efc-08dc608c2739
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	V5lpy08/nsAGmsPGN//X20pd3pYMdchOC8wHmsVSbjaZnoQ2DueQ/0eCytYwU5L9gSUEGnRIGr2SsSzXln+IIAcBvs0jE4fL213mjzb50koHwJ9N80KNL4p5IdTveHGx+Ck8d1pEwVklb8bFdQFFukXvhdSgkyhOVKgJEUHc+rFLL44ozJahoGQy41y6vR4MgT75dlEMQAE0EaoxPKF15adX47iVxqZeMP8DW8dRIT4rsG5YyWfdts4TvQZqMNzxmVcQDGRbUxbN3mr9qh2eGtLt8zQwDgv+Qt5mjr86Km2IR01vzUhXX/KjoiSnof5YEEwNngzm/TuTW/QC1EtePGuJrmqRNvGFIZmpGtO8YobV4+0P11ejh5J+Kbg/lG2vfINa3MV9SQqaQTe4iPiLRxKblU6PO9CeAc4pSSdE2mBxfKy6N63nKfbwFKujkysEph4YQGbbOaOGM9aHXvyOi/zTds+8knh3uXhgNe6kpg8PJ6PVyW2atDhAiTCQF9hsMolOn0XmQX4HMDf5Xm4lyOaxU//ja0Zpvdj/D/RWfkhuZVxU3Yud1lrxDFupYcJQEIm2e/v7tH3b0nAWozO8igZCj50qKLKhYfGmwyXYMJ88GsBZuKVCloq2RSCdofqi4KeRVOJERckJdvgmmESZvnhyARE7ozsEfGWHj6INPF4=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB5009.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cmlSRzZXZW5tZjIrQUpLdW91bFpNVXFpNzFMVWtZVXNUcUlXRldtUWdtcm9q?=
 =?utf-8?B?dDk2MnJ2VWowTWZMdGFheXZqK2prVlhjaDFzYktXbVEvQldTNlFsd0JRTmh2?=
 =?utf-8?B?d1NDakZsV3QvSi9CWXE3M3JWdjZzazFUYmZIbFVxUkYvWWJPWWVWZVZkQXJX?=
 =?utf-8?B?RVRCbjR4V1lQdVNCL2N3alJJNk00ZFJFekNscDF0TUlZWFlDRjg0bG5PQUxz?=
 =?utf-8?B?bEJOOG04Q2htZWhQV3BtdTlHbGxJbWg1eDcwSHBJbThuYmV5RTRhRkt2Y3lw?=
 =?utf-8?B?dlV2cXdSVXE2dVVWRllheDhMUEdkdVBMOHl3SWhuekxWb0pzcm5GaGIwZDJz?=
 =?utf-8?B?aEQ5c0I0VC9ka0ZmZmtMQnB5UW1VU2VvcXZDZjR0ZUpQdG03Sm8wZGpFRzE5?=
 =?utf-8?B?YkdOZ3cwa2JURWl2YXV0VWVjR2F5RXFMUk85VmhqUjJrS25ZRTM5dmgzSWN1?=
 =?utf-8?B?Y1NveC82QlFlcXUraWFoaTFQNWFFRTR4Q05mUjBwaFVLa05kUEIyODJtMEJs?=
 =?utf-8?B?YXlZUmJ3Y1JQTVJOakJ6MkpPbTBhbnVwVmlvWm4wUGl0N01lcGhZMGNTUnRi?=
 =?utf-8?B?ck9lYk5yNm16bDluWE9RRFlFSEpzM0JwMnRyY0s1MjlVN0ZWSVFrbDZTQVlV?=
 =?utf-8?B?dmJFeHN3cVRORFJiL0hDbFdHcTZRMFlUdWlPQUpCamJ4MDMxNWpIVmxRd0hL?=
 =?utf-8?B?WGRmNjl2d2I3VEV5SWtIUTM4K3Z4ZlE0cTRkVWNlcXp6cUkyNVU0S0ZsdmFm?=
 =?utf-8?B?NjhmUm9lcCttNGNFQXVVOHIxdkVDLzRNaE1OVVNHZmx5TlpJUjB3d2hLVkIw?=
 =?utf-8?B?UVlPNWhXUEdDWVp1VURVa21nVjhJQllheU16ZHgrbHNpVno3aUcrV0Qwb3oz?=
 =?utf-8?B?cnlSbmNPejk1UmJ2MTU0L0docTV0Z09iQmNtVEtsdHllVTdlTnc1RTVndWdP?=
 =?utf-8?B?MTdBK2hsT1lkM3hrNDNrempKMXhmNllEbXl0UVdxSld3M1haVDM1MGVIbGJI?=
 =?utf-8?B?YlFxcDFHWEF1TEF0VURwYzVJazdGYWtjeHlPQUpDN1Q1UHNUb2wvM251NHBz?=
 =?utf-8?B?clhzb1U2b045bXQ4S3VnVG5aaG9zNFVxN2kwWDRBODdQenFRTGNZMWZ4MUc0?=
 =?utf-8?B?VytaWFpWV1EwRWEzSGordXowbGlQV3plZGFsWnVjakdYK1U3Uy9QdVhNSVkz?=
 =?utf-8?B?OVk0Nlc5ckd6YnVka3AvRmxDdmdlSFJEYTZjZmFXd0hpWEJUTmFERDVRWWNv?=
 =?utf-8?B?M0pBUVBaQjFXeU1vWGRwQ1dRcGRrNG9kbUxOZzZYTnRSNHRyeUxSR3JKaHlO?=
 =?utf-8?B?dDl6azI0R2VDazVsQ0syczl2cVZURE04TmxPM2RQNmRVVDFaVEVSR0xvbXZv?=
 =?utf-8?B?R0FaNjdaWi83Zi9Da0xqaWo1bmlSVkhuVXFHMFdUQTFkWEtRYXAxcmVZVGk4?=
 =?utf-8?B?UThqZ1VFd0NmZDUxclpmdzQ3M0RKMmtqdmFieGxiRURROSs5bStidTlqcFNQ?=
 =?utf-8?B?bTVwY2Nod0NxOXdMT3lkZ2VXQ3FyNFlTTTJybFhqZU1OSFZ0TTRVZExoS1Ux?=
 =?utf-8?B?Uk5FZEJLczdJRXIrU01JU0s2SSs4akNjV0hDbmdYTG04SEh1QUlaNTZSVC95?=
 =?utf-8?B?UDgvS1BhckJQdUFKc2FPNFFpOU1yRnlhSGNtN3lFdFlwVVl0NjV5YlgxemEz?=
 =?utf-8?B?SHNlMytyYkVSbVc1czc1QVFaUUYxbXN3b25oRkx3YnpKcFNRamQvWkFMeFhI?=
 =?utf-8?B?alFwdEJqcU9PR2gvWk9tVXhwZ3NFeVdRWTJIUHN3V0tIRXZuYXFyZC9RMjBz?=
 =?utf-8?B?cmYzU2NteGFBVmozYjNpdmhqUW9JL2NBQ1BlWnlndDNKV0xKZkZhM0dpeDY1?=
 =?utf-8?B?aWt5QmdFM2wxc1YrcFhSUGVUbGp5MWF4Z3loS3NOQmdhb2VGR1RQb1M4V09E?=
 =?utf-8?B?K2MrZnR5Y0ZFSFhtSHQ3NTJ3V3g1NUtrM0ZtL1hIai9aSE1FNXkwNU1VU2Z6?=
 =?utf-8?B?N0ZTaCtUbmZvMkpQdkU5M0ZYVVVIekViWWMrbjhDN1MwQ2xOb2oyR1BKS0Nx?=
 =?utf-8?B?c09MNktrRllOQzhPTjNqZFkzOXNmTW9Id0JYY0trc3BkRnR6NFBsdHRGZWs3?=
 =?utf-8?B?cEovc1ZvcFdwL0dZdm1lNmNqSHJJQ3pjUm5hbmFEdmJSdzFEeXpwbGMwNEJk?=
 =?utf-8?B?TUE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	TmUWNX6m0q1wBQ5AbRHmRjxF8nMB5MVl9iR1PNr69irmj1KZzqAzHAX+PjDeSKH7t/iESLKkxaDz4viDliZaUBjcBhXhzOTPgH0lQdQ7de87l3SuzG+YQ7sy6ynM7DT6oab8/cunVI268kOcGjLiFiIN1D49OeiDkgCuWZ9FfIMYEhlriWV+mBlr5dinJdDyjOOAzB4LUgef9gyDYzWY/9aiEiVIP7GvDQJ2mPJ0BpMNoFLzqkvH8IhQdU3mTbXPG6pPQIpuz1U24Hmi9+uObfzyzim2eZiCAgFcPVupQOo02gPYI8Ao3G75pzON+T/ZDGJ9J041geYyujlrfNESZNGOxCWoFa4nITRgp3w0nxnP3YVWvOgIllHHKJdpi/GLEjMkE1HUGmDunuDxE7cQYtKLcLT3crwJc0COrnRE9cMzdPGc61qJP2y4/Wwvw5NEyr+l/0gGLqk2pCMnyOrpBCbz5BFhYtFi4zp73mpnrtxa7GFiJbIov2put9ly6QPNuN7MI1mgUGS9/5K0SOnU9frQ0jPLe/emH56O+zgBuNbFeBgKWXm5IW0Dj1H/d+GXkG7/+H1UlwyGcZ2WXM9M9b5RO9EJ1i7wvKh8zIOGnrU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef32b692-e5be-4de7-2efc-08dc608c2739
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB5009.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2024 16:17:05.1005
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gZiwL6VSCM51FnYhR1H2zdly37VZfEN4e21HUXx+jOROzAN85ncBZfTuyiWqc9GkyrkwQmtEn8VohxMSEJ1K4HexMEDDTf+Ym6HgbdtRlm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6036
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-04-19_11,2024-04-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 suspectscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404190123
X-Proofpoint-ORIG-GUID: jwP5OC7ZylrvahylrtUy2EAM8r84PnCZ
X-Proofpoint-GUID: jwP5OC7ZylrvahylrtUy2EAM8r84PnCZ



On 4/17/24 9:58 AM, boris.ostrovsky@oracle.com wrote:
> 
> I noticed that I was using a few months old qemu bits and now I am 
> having trouble reproducing this on latest bits. Let me see if I can get 
> this to fail with latest first and then try to trace why the processor 
> is in this unexpected state.

Looks like 012b170173bc "system/qdev-monitor: move drain_call_rcu call 
under if (!dev) in qmp_device_add()" is what makes the test to stop failing.

I need to understand whether lack of failures is a side effect of timing 
changes that simply make hotplug fail less likely or if this is an 
actual (but seemingly unintentional) fix.

-boris

