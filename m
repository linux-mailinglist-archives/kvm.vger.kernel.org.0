Return-Path: <kvm+bounces-18077-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ECD0C8CDA2D
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 20:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1F6F281035
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 18:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983437EF1F;
	Thu, 23 May 2024 18:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AX/Pjn1S";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="bsZhfN4U"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C855621362;
	Thu, 23 May 2024 18:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716490164; cv=fail; b=ehbDV7mCh7xcHb1+zYv3IT+yIwvVYxADQhMr1AZZ+3u7ZNx6nv814c6yojUCreRi52UJ2rz8S9IEHjnisp76mLoRqQt2AuHL3BT5qyHvJYk1HmdYrvAXWcQ59LO2dtzebx9b/5uec5kW8IM0/EasbpjzESNUjCzd+lofxF2PPe0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716490164; c=relaxed/simple;
	bh=AbtNu+DXKrYHA2I3/BRQUIFH/jEp5YOPzPbZv0oK3Jo=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=Nw97ygM0pq1d+2sz7yi9auAt/QEzTffRe3udQigZNibJbmP0aMyf2dfIvtD836I+G0pCs0OuFeyFOWJXE+CxpLcLIDJu7y/hGjKq1W70/nFyl1ToRxaB56G0zCD8WkcAh0BYRyhjmQ4Bghp0h3D4P5PU3vOPPK49DakLWKaoias=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AX/Pjn1S; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=bsZhfN4U; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44NIlELT030632;
	Thu, 23 May 2024 18:49:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=0qMnMqin7j//wzuW23Rj87VzRAUOAd+7na5WbqYXUfE=;
 b=AX/Pjn1ST48zFmW8oS7cXQDoQPanY7PY4vI8UV8fJSiR9jknHBnNNWioNc+T+ioj/7CQ
 oQEvO85V+lehmi4kGIwH3r447LuLuNfdxnO+w7JInFyc7obr/vbYnFdY34Ni/TRJMSrG
 7lXxdZLzRFh30vuSFJc0ZPuLdwlUIfugPF4u57rV5Xcx1aTA/6L5QNnWGNVr+QiSx/kN
 7aQDcYtbPmO1H+Cj7R9/GPCKE4S/sS3DsyBraTNJXtiEXQHno0KwzY/O8mr/r8aRy7zj
 iav56l/RNeRExye6mmJ4ZWKLWjBVq+4dLjddmdX7w3iZjSkH8cocSitsMrQUCkmzfjlO dQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2juyw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 18:49:16 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44NHSWxp036011;
	Thu, 23 May 2024 18:49:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y6jsaxtwm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 23 May 2024 18:49:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jRPk3aq8oAVwXz/n5LBCnO/Rna7CktqzkatmD1D4igYLU1aV09nqDNjGMWhzaru0TOr9dh4nrGkP0RPueSC9BZv9KZ4/I5e6fT0wULzDLkmZ85sPiTRRLD2EG3hj7Upi55ODyK2LBR9jDsghrxvOY1N8srtwlzN238jqiWhir4T8qgj4h2rzArkjWANeubNLNCYroaJVWpZrWQbVourl65mVo1BSOVkVNulMi3o8MYnnHbWVLwwc/XjBa0VQcMBXizb8M8gNs0uT/NYtgcKZuDILPEcqn/IANuurNV1qY4WUaw2F8ORNfvmeVmFgJkQjuSjdOpi3xJDw4rC2w4Ly7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0qMnMqin7j//wzuW23Rj87VzRAUOAd+7na5WbqYXUfE=;
 b=OiKIMpx0IlSmGvekl9UOng1aAtgFequ04r7UTxfcjM3GYVyeXS0Rykqn2o3ZD/m/el0S777qbS4ekY1q+W7DBepmw7PCUrYov/q2ZjZcwsB9uc7FudeSrW86wXLW4ShJwHeO4F4M56Gou7VT/mJpyy+/u7ZLlqF1+ppwHD/DgfvvA7REdCilytaKloPptWYVoqIXI14iALjizw3JzZsEWUfDkKPsCQ9VdNr2N5bT90ijNt3OSgQi+6mg4WWSIgij1Vjzcw/bZ7fzWvrYKOrlVeuXFv7hsDsOxBkaLdkKWo/g7/WonWrL53Hsrb548S6Opr01Y24t+2RLhO9Ri6+l6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0qMnMqin7j//wzuW23Rj87VzRAUOAd+7na5WbqYXUfE=;
 b=bsZhfN4UYGVUIGDgcukRvKvVOG5Kq3CH/hxYy89o+ZFtRhoF67rM6QON3Qfp6rNt4JvTjcOwNJybhQRD0P6TrhD2Ed2vCazbFBiMaqel1bCEyPgzoCgFjzHa/ahU5eA/RWddGUlFFMGGgEKuiGq5zVTLqxNIOMky8IgGqrsVs3I=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 SJ2PR10MB7655.namprd10.prod.outlook.com (2603:10b6:a03:547::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Thu, 23 May
 2024 18:49:13 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c90e:457c:4301:a8e7]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c90e:457c:4301:a8e7%4]) with mapi id 15.20.7587.035; Thu, 23 May 2024
 18:49:13 +0000
Message-ID: <a931f44e-0c10-426d-9b65-6541f2068eb2@oracle.com>
Date: Thu, 23 May 2024 14:49:10 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] Export APICv-related state via binary stats interface
To: kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0061.namprd13.prod.outlook.com
 (2603:10b6:208:2b8::6) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|SJ2PR10MB7655:EE_
X-MS-Office365-Filtering-Correlation-Id: 61c0b80e-dd5f-45b9-8b5e-08dc7b590a09
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|1800799015|366007;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?RUU2ZlAwQ3JLYjJzVmRETkI3UkNod2ZFUjdRWEwzUTA1YWJXNVZUVi9WSFBM?=
 =?utf-8?B?UEhhamdEN1lKZXVtWU5mWHpjQ0txUW80WHBleE5aNFZScmNBOUZGOVVxeFRu?=
 =?utf-8?B?dzhyWFQ0ajR4c0dUOHU4b2lNOXh5ZWg1d1piOW1yNXJzL2c0THZPaDJXQ3R2?=
 =?utf-8?B?ZU9kZmczS1lEd3dJNmlaVit3dko1LzJZaHkwZ0lnL2duOU1OMUhHTHRTWlBh?=
 =?utf-8?B?N0pMMUNKZjk1S0xPblBTZFF1cndsQ2R1Z3BEWWlTN0g0akMxNkNUb1dyZVpR?=
 =?utf-8?B?QzNnc1VOTWZYcGNwMnVFc0owbHgxVnh0NTd5ZS94YkxyeXlKVlVNbWxnaExa?=
 =?utf-8?B?VklFMnUxRS9vVnVBa3J1emZnU2VITWd0ZlJuTlQ3TDhBQ1kzcEFDNU1wVTF2?=
 =?utf-8?B?eEl0WnRXY0VTa1NKZS9FYUd0OG92RlRrR01OOHdpRFdFZTlsWVFYRHVyVGNs?=
 =?utf-8?B?dk8yT1VWZWJMZDhDQUlJQUxKVWFzbmx4U3NGWWs3T3d6RExwK2ZrNU40aWJL?=
 =?utf-8?B?S0dpdjJKdW15bkRBWHV1VGFadWhJelE1NzJMT2t4U1B4K0oza3FRc2RtK0NV?=
 =?utf-8?B?MGVCQ1VyWjhSeDBEc3IzQ2U5bHIvVHdOVmxLa0Z5RnlhSlhLQWdOVG5BSnkz?=
 =?utf-8?B?OWRWOXVFaDdoSHdSTWt3KzQyVkc3bHdseGdGTE5EdVVVWm5yTzdaNXc2L01o?=
 =?utf-8?B?aHRYNVhUcmRhMUg0QUdkdnlMK0hBK0Q5TmJsMmFuS3NLQldoY1dxc3B4RU1r?=
 =?utf-8?B?aGdYelNFdnJXem44UWFpd2pWYmdsdlZQL3g2YkhTeWx0N0VtL3BqQjVlMU9O?=
 =?utf-8?B?K0lYR1l3WnRtNDNuR2xTV1ZiUFJWdmpkblpsdnhlT3BZOGp2S2ZITTUzMm02?=
 =?utf-8?B?TmtPQ1BuUXNxdm5wdWQxUHovRkxpamFWY0J3YmM5dldQRkZSN3hDcjBhVUJu?=
 =?utf-8?B?dlc2QWNYZll0TzVPRWxCQ0VvM0lSK0NGa0gwWFV0SVBvcVEzb3lNcENCT3dI?=
 =?utf-8?B?VHVqMmlxR0tBS3lqMDc1blhxc0lwUXBiOGxlck9ERVhnSklZQ2VtRVJMWnEr?=
 =?utf-8?B?S0FybCt0K2pPSThXcVdtQ1R3bFg0RVA1bnc2b0xkN25BZTdocFFWbDY1T2Ns?=
 =?utf-8?B?WGhsNWtCZG14dWhuRHh3WTY3Nm5iNWlZWTZRMTFYek1IV2dqNFRIYlVjVDl5?=
 =?utf-8?B?b3hhMTA2RUsvS01rZjU1Ri9IOThMejF4dmJrUFUzYzNKdlhPQmxjWWwrZmVr?=
 =?utf-8?B?SktJRUkzVnl6YS94NEM3bTc5cnFvUVV0dS8zZFNrZjVpL25nODBUUmhURFBr?=
 =?utf-8?B?T0U2NmVkYy9raWZlZzNpZVMrR2JBOThQQWlqUHJidi9ESFpPaWRmLy9DQmFs?=
 =?utf-8?B?eXpYOTEwamRqU3NYcVU5M0NhakJxUHF2Vk43UXVtYkZpWC9qQ2VraCt0OGNQ?=
 =?utf-8?B?VW1RYWl2VHo3NExWcmxYZDhWWTRuV1lrRGRjNUlBbVJiUUdIQ1JiL3dOY3RP?=
 =?utf-8?B?WjZlK1Q2cElFaDVOSENmUytIenhKYjliSHdYNkM2YW9LbWpMeWU5Sm5NcVFr?=
 =?utf-8?B?b3ZpTDYvVVNDYmxaREhpM0phckdpUEZid0JtblNCcEhvTFdwL2l0alZaSDY2?=
 =?utf-8?Q?CIzhJHmESBAOJb1GSLkb3Vweyjf7nH8+OmxAlMJrX9Xo=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(1800799015)(366007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RUd1L08wVllUMlNaRkErMmlMakhtY3N6T1RtWGFlNVRKQmJETnlVVDJnZGUz?=
 =?utf-8?B?Z0JuSXNOMFlPbzY1cENhbVp0ZnBIRXVNWFJtNkZQZzE3R0FzMC8yVnhrR3N1?=
 =?utf-8?B?bG9MNGhqQjZiTVhHRjkrYmUvbTBDUDA0aGhpMWY1anAwVExWWkltdXVEa21o?=
 =?utf-8?B?TzRsWTJ0dzRVUUtUTGtONklqVWR5SUdtM1ZGS3JsSm02eUVhSEZjRU9naGZF?=
 =?utf-8?B?SEI2bUxwNXFtVi9mVFRRWDl4RDZQNlFsRFpZWUZHd2NlVTVzbDRxY2s3WVl3?=
 =?utf-8?B?Tms0TzdVdHg3Zmlqa0FSRnkzMytMczNPa1h4cko5dEdCdUVaSG5qcTBnK05V?=
 =?utf-8?B?aWRhYzNmczlpSkxzWDNlSkJmcEZ2QUxrdG5sbHVqUDBYcSsvM0VsNWg0Q1Az?=
 =?utf-8?B?cHhCQmVtdE5rNncrMFl6YzJvMlF3Zk9aWnViNHRaTzZKdy8xMVBQVlp3dUIy?=
 =?utf-8?B?VDVVUE1mVVAwcmxmbjlnVFhyRGJ2aUdiSTNhdHdwL2V3SGFJcnE2TlRZd2Iw?=
 =?utf-8?B?VlhaTGZ0alI1eVpyR2V6dldYZTVzVnBOK1FVZnlHcFI4RFI2cER2eWE5RDBY?=
 =?utf-8?B?aDFDQ1F3L1Y1QzNSV2ZySVp1bXk0UHlBeEVUUk5RYTF0bWZBbzlSaDM3eUkr?=
 =?utf-8?B?SzUyRXdwRjVRNUV3SjVQYzAzT1h6U0Vsb0ZXN24ySXhIcHpoTElxc1E3cEJM?=
 =?utf-8?B?cHpaQnZuUXdkNFc4c3VqU2hjVm4xblhLRk52YktpZ2NPTHNpVFM3eTVYOElK?=
 =?utf-8?B?andTUjRmek1uQ1FSN054TW52SlVpQUVDb1dlYVo5Vi9uakVKMkhJbjA4ZFNt?=
 =?utf-8?B?UTZhRWhPVDdodFZBUGlLbGt2eGQwdXlkd05ZZmdxdGhqb2p5VHg3VE1RaHBn?=
 =?utf-8?B?ZUpOUXZ6N2lsZG0yTkczcjhqMnB0NUx0cUszNTh6RHU2L3RzemQrSkFRVWh4?=
 =?utf-8?B?d0JEYUhpSCsvUWFValdNSXBpbzk5bDBGcmV2OHBkN2pLSjhBSHZkM3d4YlVG?=
 =?utf-8?B?eGcxL3l4MWZMNGhPRW02dW5lVlJNaDdyRkRFeDJuaEcrVkJYa2NsSXRhdjky?=
 =?utf-8?B?cUZqTU1KbGxnTFBpYkl0Tm5XNkw1V2k0eTBoY2tJN3VQai9KVStBU0ZneUlQ?=
 =?utf-8?B?WXBrU0lqU3kvdUFZLzVNNTB5REZ2dG8zMjV6blBZaEdrSm5LdnltSTlONFJz?=
 =?utf-8?B?Y2Q2bDNVYUdaekwrYVlpT0xrSmRCMWlQSmpDSkZYS0F3WXAxWVZpWENzR0hW?=
 =?utf-8?B?NDFDQmIwZ0ExVmVzRzgvMXBFT040SmdHZUYrNldnRU5SYzlYeE03bWpTSEph?=
 =?utf-8?B?dHZIazNoQVFaTEdReWFYZ1liZS9RcEl4ZnhMQWpJYmpsc1JXODhrZSszTWVX?=
 =?utf-8?B?Z1dOSGhNS05USnJ5WHN5QW5sdWxzbnY2bVFuZElyZnVjR3h4dG5LKysxWDA1?=
 =?utf-8?B?TEVObFNjSG5LdHJENllzU1Z2WWZkajdFYzc3QVpaOXZyZTlCYnV5UWp2UEF0?=
 =?utf-8?B?enVTMzNqb1hwSkE2aG5FNndFVGs2dFZCdzZwN0tQMTU1RWpTdnNHczZsRHQv?=
 =?utf-8?B?bUlSMlFDdjNzaXJUekpreGdma3p3YURmSmt3NHBEZlMrVlVONG9KSlcvTnJR?=
 =?utf-8?B?R2dTZHlrY3FkTTBjUmlJSjgweEF0T2RzTEg4ZVhXN2hycGpWQm84emVKQmtV?=
 =?utf-8?B?NzJ1dmZaMFpkQ1E0cXpuc3ZJMHR0b0RHaHd1Y1NseUpyRGhncTBUZmJ2YmlX?=
 =?utf-8?B?UVVMS1ZmcTJwaXN1dGZBNDI3N25MNlV0VkwybHBmSlJqdVJOQUJSV3ZBNXl6?=
 =?utf-8?B?QS9pL1p0bDhlTzAwZFRSemE2Tkp2WVVLTE81bkxoQnEyWHpZeVlUc0N3UEhB?=
 =?utf-8?B?U0Ryb1RtaW1DTCtmNDVXQUE5bFBvUjhSMGhGUmFaY29SYm1RYXJDS1FLK2I2?=
 =?utf-8?B?anJPazlNL1l4dkxSZHdubDdkOXczalExWFM3OFlpeFpmeGMwY2FLWUZoNlBF?=
 =?utf-8?B?RklTL2NyVWVDcW5ucmVxeFFUZkx6YTljNllWODM3NGZtcDBDU01aOXRvUy81?=
 =?utf-8?B?U05PNTRJSlFaZlR5OThraEhwSHVTdmRNOHFnZnA0MVRNbmUwV3dVaVhpT1Rt?=
 =?utf-8?B?b01tMlFwOUhYaHplRk5MM25SZlJFSmNTYkVNOHBTejFvVnA5VU9ObFd0QktN?=
 =?utf-8?B?Znc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	aL0LfdDoFE7nOfrEl+8v/zm4VMt+mMF4hxDAkxB0cX/+u/T/2CJU53jQT8N5WyoIgFG9lw9UIJDM72CKqBGzQcXKuO632tkZ20lgmtPa4ZLiOFXLSRMZZr8mfln5rwyBhDy0oDKImBXINb/r3D/Rgoqs9MlFGQ7eRk4R6C1h7EUHup3mtYNmi/BkQ36v+9IbM/A+dxpvCklkOrfAI/aDKHfx5VzkzG5jy3j4q11P6llY0DPJjY34zt22aXmz/GOKHzb3ksLB3dY8lh9GdPiRo4HIzX4fr4Ehgo6N01dkgUXDNwxntnIID/vsg6yWg6Nq3QaSwLcqJgByvekA+aTkaJKHIFIF+3qRFR+/71sBR7uDZiEf4TFLHvQ1Bxeq7w+FZjKA+QOo1YbAI2UFePD3Cb72mzWZ3itXXkTlV7ST0/ZpkD1/ftq19PlTor8qC88Si34/rbpFx9aq8eSysz5hbr2ZwP+zTe0A8rjpNQE1PTxP/FxMAaYfCYbMkxg840KwCYoomBmYmArZv65KXV4d/sdSEwwwAaRtA4inHuszaIK72A6unJadswC1gY5W8hEqdlHe8guBHxOEQM4/DtUn8jNIefhavx3sCT/OUetUY1g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c0b80e-dd5f-45b9-8b5e-08dc7b590a09
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2024 18:49:13.3689
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fncoSFDfsdjgDOxA7vOtXf62BQHitcvgwi8E4qREI66quGu44NljyhafoMnUCQGWHQnaOtwMZAgNy425ibn7t/bI5TTafT4m30aYXwBYN1E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7655
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-23_11,2024-05-23_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405230130
X-Proofpoint-GUID: 9ESO7RCqlUS0CoAKM5t4S6_sYq3sdpvv
X-Proofpoint-ORIG-GUID: 9ESO7RCqlUS0CoAKM5t4S6_sYq3sdpvv



On 4/29/24 11:57, Alejandro Jimenez wrote:
> After discussion in the RFC thread[0], the following items were identified as
> desirable to expose via the stats interface:
> 
> - APICv status: (apicv_enabled, boolean, per-vCPU)
> 
> - Guest using SynIC's AutoEOI: (synic_auto_eoi_used, boolean, per-VM)
> 
> - KVM PIT in reinject mode inhibits AVIC: (pit_reinject_mode, boolean, per-VM)
> 
> - APICv unaccelerated injections causing a vmexit (i.e. AVIC_INCOMPLETE_IPI,
>    AVIC_UNACCELERATED_ACCESS, APIC_WRITE): (apicv_unaccelerated_inj, counter,
>    per-vCPU)
> 
> Example retrieving the newly introduced stats for guest running on AMD Genoa
> host, with AVIC enabled:
> 
> (QEMU) query-stats target=vcpu vcpus=['/machine/unattached/device[0]'] providers=[{'provider':'kvm','names':['apicv_unaccelerated_inj','apicv_active']}]
> {
>      "return": [
>          {
>              "provider": "kvm",
>              "qom-path": "/machine/unattached/device[0]",
>              "stats": [
>                  {
>                      "name": "apicv_unaccelerated_inj",
>                      "value": 2561
>                  },
>                  {
>                      "name": "apicv_active",
>                      "value": true
>                  }
>              ]
>          }
>      ]
> }
> (QEMU) query-stats target=vm providers=[{'provider':'kvm','names':['pit_reinject_mode','synic_auto_eoi_used']}]
> {
>      "return": [
>          {
>              "provider": "kvm",
>              "stats": [
>                  {
>                      "name": "pit_reinject_mode",
>                      "value": false
>                  },
>                  {
>                      "name": "synic_auto_eoi_used",
>                      "value": false
>                  }
>              ]
>          }
>      ]
> }
> 
> Changes were also sanity tested on Intel Sapphire Rapids platform, with/without
> IPI virtualization.

ping...

This series implements the suggestions from earlier RFC discussion [0]. Additional comments/reviews are appreciated.

Thank you,
Alejandro

> 
> [0] https://lore.kernel.org/all/20240215160136.1256084-1-alejandro.j.jimenez@oracle.com/
> 
> Alejandro Jimenez (4):
>    KVM: x86: Expose per-vCPU APICv status
>    KVM: x86: Add a VM stat exposing when SynIC AutoEOI is in use
>    KVM: x86: Add a VM stat exposing when KVM PIT is set to reinject mode
>    KVM: x86: Add vCPU stat for APICv interrupt injections causing #VMEXIT
> 
>   arch/x86/include/asm/kvm_host.h | 4 ++++
>   arch/x86/kvm/hyperv.c           | 2 ++
>   arch/x86/kvm/i8254.c            | 2 ++
>   arch/x86/kvm/lapic.c            | 1 +
>   arch/x86/kvm/svm/avic.c         | 7 +++++++
>   arch/x86/kvm/vmx/vmx.c          | 2 ++
>   arch/x86/kvm/x86.c              | 7 ++++++-
>   7 files changed, 24 insertions(+), 1 deletion(-)
> 
> 
> base-commit: 7b076c6a308ec5bce9fc96e2935443ed228b9148

