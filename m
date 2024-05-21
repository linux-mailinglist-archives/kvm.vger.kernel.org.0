Return-Path: <kvm+bounces-17854-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75E3F8CB28D
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 18:58:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 98F971C212F6
	for <lists+kvm@lfdr.de>; Tue, 21 May 2024 16:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3BF4142910;
	Tue, 21 May 2024 16:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="efT3MSDk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="mSM15CSt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C6662E645;
	Tue, 21 May 2024 16:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716310693; cv=fail; b=aiUlVGrJdSZuqM8vuCP5lH1aI37NivpvNng4eyDAqUZTC7wITwXQVM/OjWU/SoRc/Iy/NOpfeGzm+zDRjMTOZ9GsHz3efR0rxocQ8qyX5ZC5emSTCY+C7Emr2lxFuF7niBzA4Gu3AsrurLG7aR7wYUeeQO2JqcgsZ+mjfOdmqJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716310693; c=relaxed/simple;
	bh=Y0e3fqDx0WXBNjY6zObVhV+k16ffPa9PdXfbAOtpKQY=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=KSibzfxBvWNpcJQFh/xMlMIdHlUBYPB7/l131ZSABD2H8Wp2L4n2L/ZO3ZTd9v1FljZHKx2tNHyUi0WW5fSykbC4Ux9YZjpcQO/eAM8uKRom6+E6NBxSxUhJS14wBjvW/96+aoHbNK0ZIoOm0Qcz+GuoqfItgWCBcmzYIbZCiyQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=efT3MSDk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=mSM15CSt; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44LD01h7001747;
	Tue, 21 May 2024 16:57:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=EJFZFYzEKAGBS+9bOiZRXFyxsfzOD9hg81kGqUTU4DI=;
 b=efT3MSDkOQFkdlDOa9aWWrb2gZUYnvw3jqvZH83Rn/OKUASezB35f9oGsVxhwtFfSXgz
 kzkj/Bqw/IZUo+Y7VOXP7w6zfBmchVgwgqC1HHiBqQKPn3Aey5/oNDZr3woM1lO/N1ZZ
 lpp12j0qNGvYqV3gVkTN+vXfiIWfwgWtixr01gs6Ptr0C1H0y5NDEJL8UpPFSeba6HjY
 4nX0CydGlrDkDauAUGRJXmNnMWn0x+T6XC5sP1EkRLHw8Ic0PJvkacES8RoMS80NJfMq
 yfE++fwulTsbb8FkgAVpXE0hCUwPGFF7e3IIAIMVtqsfFwcNRJM1Od8oVnevrkshDzTd /w== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6mvv5ups-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 16:57:40 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44LGgZAH002731;
	Tue, 21 May 2024 16:57:38 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js80a4b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 16:57:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IaAxAbSozkAV84stnwF38k0dPHb0sIvZoKlPnEdfvNkPl24MkUs3chdwoxMJ2lwD5+kjF6GBrwREHOLelHmEKheWGCc0fkfuOY9l++hf5gEYlLvUSxQg8g734s8c70fR4NoPVB8DiKMa32+AV5kntawr975/Pz4WO5wDpWI8R0q1KMaHikWkk6+wMPJQKnJ+3+nVDJpjpCk2EBOaf70VSIV3KiazcMKo8Dt87+kv8maHospGZdcK07/imsQt1HvqZWv+eipUgtwvQZNqHn5+eXdZDwRsa2bo05vui1P3bMO3oE7G/Yq743uxlgQZBe3ftvtmqoF7M0S4aTGEibw1lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EJFZFYzEKAGBS+9bOiZRXFyxsfzOD9hg81kGqUTU4DI=;
 b=ijeRecaNDNySGf+KJwPtG7U7r2rNGAspqpqTmWpgcaktOuIiOL8A0wM8ptxrdjGRndFAxw3EBEIcnQEhlxXb52BfjYO36QMYqZ0InRYbaE40+NhrvtWFUpE15ePjknAPQo/SWiS4c1eb2Nzkj34EiJR/7M76oQBSw21XiQ4y3+hTJwUVEE9af0XQJ9+WaCqw3i25GvjTqbGgLPqEZjW616IfQFxOz7LczP5xgEumBgMwXqzx1IlzBkExhpnRkk8XkpOnvw2bXQowxgC8N7BKU101/R/KIbb/K8TnkK1h5Bt5FDsHf0ZcO9baGTjpOCuvrnZA6lOovyvS6vAC+l9g/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EJFZFYzEKAGBS+9bOiZRXFyxsfzOD9hg81kGqUTU4DI=;
 b=mSM15CStNKK5oiLLlcj12taR1LrjtPCp0J3CH++T0Ok1iijZLlV/I9EhLfJHVGJJE0p/mkLAxHxVfmgmHCldy2N6rXjNBp5kLt8SbEy4uFIfbDF9BftX3WQ/KGp/CP4/v6stzSnJ28syHHMougHvBgxNm0gI5SXTvp8t/i9GwGw=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 SJ2PR10MB7705.namprd10.prod.outlook.com (2603:10b6:a03:57b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7587.35; Tue, 21 May
 2024 16:57:37 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c90e:457c:4301:a8e7]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::c90e:457c:4301:a8e7%4]) with mapi id 15.20.7587.035; Tue, 21 May 2024
 16:57:37 +0000
Message-ID: <4bbb71a1-bd5e-4549-8a54-e3781290591c@oracle.com>
Date: Tue, 21 May 2024 12:57:33 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: x86: Drop unused check_apicv_inhibit_reasons()
 callback definition
To: Hou Wenlong <houwenlong.hwl@antgroup.com>, kvm@vger.kernel.org
Cc: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
References: <54abd1d0ccaba4d532f81df61259b9c0e021fbde.1714977229.git.houwenlong.hwl@antgroup.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <54abd1d0ccaba4d532f81df61259b9c0e021fbde.1714977229.git.houwenlong.hwl@antgroup.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL1PR13CA0171.namprd13.prod.outlook.com
 (2603:10b6:208:2bd::26) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|SJ2PR10MB7705:EE_
X-MS-Office365-Filtering-Correlation-Id: 37206a31-e67f-4864-cbd8-08dc79b71de7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|376005|1800799015|7416005;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?OHU4YjdvTVBCWC95UFk5OEdlNjdEczJvUmhSb1JZUllHSDk1ZVViWCtZaDcx?=
 =?utf-8?B?OUlMMVd4WWdEK2VwNFgzcmhJQTJFYTVCKytaeXBGanVLRVByanhnNFZJeG5x?=
 =?utf-8?B?N09YcW5lNlFuMmFoVktiWE9yVnBveExqSlpTbFNXSytKYUdNbjV5RW1SMm1n?=
 =?utf-8?B?Y1lHSUJFcEZGK29wUjh3ZXpYVVBvaVhweitnaTNvNkdoK0lLaktBQnRlVVJW?=
 =?utf-8?B?VVdQZXVLYzJCZktDeEdOUGwwTDFTV3U5WGFsMHphRzhwYUM4RFFqcHN5RldO?=
 =?utf-8?B?VUlESDFwTHk2SGFpNmJCVzJVQWh2UThjSk9JUWMrbzBVM3huUlBRVUtGMTJ1?=
 =?utf-8?B?ZmRLTWZpR25VT25QVlQyTzBKeW40d055L3ZHb2g5aVRiT09mL253emVOSStW?=
 =?utf-8?B?MkpTdXdvY1pLVHJWMWtXUjh2c1ZRR25VYzJBdXRkOFBPZ1RkbEc3Sm1lZGUy?=
 =?utf-8?B?RWw5azFOL1pHSVJUb2dsa1E4MFBzeFpSd2Z6VXhFdnllaXB0K0NkUWI1R2Na?=
 =?utf-8?B?VnBKZ2t1RkVubEhWTGRFMWVFQUJySGM4d1NTVEowbVI4MWdVQis1MHpYNW9P?=
 =?utf-8?B?RXA4SFd3NUNYUkVQUmUxRENIQWRTWDNMa1R1UWVHRW5RUjBWMG0vcjA2aGF6?=
 =?utf-8?B?aFhEOVFTaHhGZ2w3UTdmUU8xVlp4QXpKNktESGpOWlM3S29kUVZzUVZ2NS93?=
 =?utf-8?B?MWErMFhyS0IwTXNvVUE5OWh6V01HNFl3SVhycTZWOHE4L0t0Y1ZLWlA2RkJl?=
 =?utf-8?B?ZUkvdXZGWnV1WDI4ZlhFRXhQc0hnemhKNE1xcGZiZVpQZUpjcnZFZWRRMGxk?=
 =?utf-8?B?RWhCZTNPRm90czhMYmFackF5OFlaM2tDaVRKK3hpbDJSd1A1clg4S2l1d25Q?=
 =?utf-8?B?bUVkZHZWQWdCeDZuSTRmMlFuYWpnQlo0T0ZOWHNmZEtwWi95UUg4S0FWZ2lq?=
 =?utf-8?B?Tng2aTViaUMvRUN6ajEzT2NSa25IbXJZOURFeEFkMlRXcTdlU2NRcmZEMnVj?=
 =?utf-8?B?ZDdZL2pDdHlvWERMQlRyUEtiQXZsS3FwV2JsY1NvdnNZaW9ORmRlVHV2TCti?=
 =?utf-8?B?M2JCd1VoOGxZam9tUGhBOGpoeWt5M2VNRUc1NW9yMDNsM2JPbmtiN0xkWWlK?=
 =?utf-8?B?YVBRSnY5UXNjVEVNaDVnOG5QYUp4YnRGN1Z0MVFrYUg5b1lqM1Nnd2NkS2tZ?=
 =?utf-8?B?ZDhYemprbC9uVWNrVXJvL0JKQVJQTytpN3U3d2ZsRFZidE96cFViNmUxdURq?=
 =?utf-8?B?dVdWbmJDdnFhSm5MbkNvYzlGOEU2d0ZsQ003MlBtT2wvTlBjZEpPWHZEclZw?=
 =?utf-8?B?M0ZTNGNOclJVdXhiOVROci9hcWcxUWdKWEdPVUFxRFZUUzdOdnNzMkNjTjN1?=
 =?utf-8?B?MUpkY3pqZW44N212YW9zMHhFdmZyWmtmVXdLNWhqbTIvNFgxTjhsMVZ6bW9t?=
 =?utf-8?B?Z1ByR0l3U096Ny9NT0JjdUtmdmZKZXlPbEphYUtRM0o1V20yeGhZMGtpbGFr?=
 =?utf-8?B?dkM2a0R6cGR6NS9FZWRsbS9EUEQyZXpRM3JNeWk2RzNUSHl6Q1JQckxwVFA1?=
 =?utf-8?B?d3ZXRG1zbzBReDM2TXVOTnRRbEw5Y1hodzU0djhVd1MySjBFWnRoTEkzS21v?=
 =?utf-8?B?RmpIZFI1MTlBUnZ2aUlZRWJDMDdsdWNvOW9OMFJITktibmVweG9DUFdIcHhy?=
 =?utf-8?B?WmIxWitMQnBKRElTd2ZVOGFSNFlkTTFVOVF5a0N0UnVOQkdpaGpQekFBPT0=?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(376005)(1800799015)(7416005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?SnVVSnNzMEpUK20vbGFldDM1L0NzNlNuRUUzTGg5L2s0cmI1OUlITHBXUEdx?=
 =?utf-8?B?Sy9HTndyd1JEQVl0ajEwVGprS001ZEpCeFp2OU5LOHhhTTZ2SDhCa3pBL1hU?=
 =?utf-8?B?RnZoSHVzTjZNNVJ5cUd1ZnpZdjVqOFZwMmVaRm5VaDNqandZeXB1Tk9ranZC?=
 =?utf-8?B?YVovbEh0dllWR2k2Rmh4UlVQMUFRdHdmMDZqdWlBU0xCWTlRYUduWTJvMUJP?=
 =?utf-8?B?VWZPb1JSdWpqcXJINUQ2dGJsWjRBaFVoYVJnTVVkTCtGSTV6dkFnSzlnaFhh?=
 =?utf-8?B?OVgxMWx6TXA1UFROemVnVUJWbm10V0N4ZHdzb0hqalE0U0pwM1NaVXE5S0dI?=
 =?utf-8?B?aytDci81blIrV2lSdXNSS2VFWXJpSmRYSG5LVmtBV1E2bTNTclgvRkNnTlNj?=
 =?utf-8?B?dktRa1NOTDlRMlp1YklaUEpGd2ROTWN1M2hLSk4wWVhNQ0VWZTVLaS85WXdF?=
 =?utf-8?B?ejBHSXlGYk1XQWJIeVZSclloNEtucHRkckJxNERUa0NmSm50R2ZLOVRzMlhG?=
 =?utf-8?B?MGNsM24rVEdIWkxOaVNzRGZiL05DZTRSRlFaN05QcmJoR2Uyc0VsRTEwRFJz?=
 =?utf-8?B?YUdvcHdPUFFhcXlla2NEMDAvSzdDTlNLenJvYzlsRUpjRm5SbU5ZTnE1a2NH?=
 =?utf-8?B?dmNkQkhXVTNsM3hOSDZpcHR3SWZFdjRVN253a2I4VkNKMWdhWGkweG1YYm8w?=
 =?utf-8?B?ZDRDandLSEg5clZVd0ttMGdPa3F5ZnJLS2IrbDhLek8rQ2JWU1lPV2E2QWh3?=
 =?utf-8?B?TzZqL3lkdjdxTFhCMTBlblZQSzIzV2pGNE9KcGJHUkxZY3luWkVzQURiWnM4?=
 =?utf-8?B?bzhYR3R4VVBUQVFuekZvaDhSUGRuT1ZabVd5aXE1VVA2enVEUHlZRHJNMDE5?=
 =?utf-8?B?NFRaWWFHSTBwUDhMbCtJWHM1UGJLVVFrU0dnTFU2RW9hR2NSTy9LeS9BYXp1?=
 =?utf-8?B?QmtUdkdFbUlvNmhpb3RXLzdHalZmeDZrWWNLNWZIYTVKeVRDdHZ6OWROV2ht?=
 =?utf-8?B?SG54Mm9nZjg1RkJBSGViRGdEcXQwaDFJR3hzWXQ4TFFzMlZEOGxDTkZJaG9p?=
 =?utf-8?B?czdhelBKQk9uZnZIb25ac0VjNEgzYU5OM0JNRHU1NmJFZmpjSFk5T20ySkRI?=
 =?utf-8?B?Z2pDdTNGMFI1bkx2RzU3c3JzWlR5KzgrSGUyNzE2R3Q4Y3dlNytoc0FpYjkw?=
 =?utf-8?B?SzY0QThQSXJyNHl5SDVKY2lMV1ZEeVlXWUJwK01NVndmY3k5Zm9VbzNjOWdr?=
 =?utf-8?B?KzE0b0FIdmhpNENuSDQ5b0x0VlJuM1VDZUZxY1R3bGFuKzVROTRPSlRvSUxr?=
 =?utf-8?B?eG9qcXU4WUJKOHE5aXJObWpaWjJzZ2YrZDNmWkpreGZTRkpKVVo3ZVlDOXhQ?=
 =?utf-8?B?c0VzckNCdW5tSThlU2Z1dHVlSmdzZmRHNWtYWkNNTFJKelpHYWFXeXU0ZGF4?=
 =?utf-8?B?QlBLdjhnYlRNQ2YrZi81SlM2TTZXU0htWmRmOWh5UGxKR3kwWjdkdTNJcUR4?=
 =?utf-8?B?NEo2ZC9PK1BZWUpXU1RYa2p4KzczWlVRY3RabjM1QitjZCtiNkNDTG5qcnU5?=
 =?utf-8?B?TkYyd2hGMHJBZUt5RjJvQ2hXelB0WWp1aFhOK3B4ZHVJUWZxZG55dHBkelFh?=
 =?utf-8?B?MTR2b1Y3UFVkUkpEQy8vWEZPTU1Sb0RqcmpBZjh5dENoQXp0ekdMcFZWSUVR?=
 =?utf-8?B?Q1RvV1lFVHErcnNubTBaNy9EeTZWS2ZKcXdRSHpnM2dTYWI5S3pubnpwLzBw?=
 =?utf-8?B?TlpYL2tkRFByUm0vVEJZRjRDZmxDUk9GTSthZHU2UjRXK1hiRnFvSUIxQmox?=
 =?utf-8?B?UDdJYnZIVU83RjBaSThMdWtlOGhneDc2S2ZBbUttWFZ2anhoSHgyTmoxc3lF?=
 =?utf-8?B?S2JMaE1SVmt1N29xN05sbjFBWC91QmUxSGFWMGx6RGpyU2tudlpydWVtY0VG?=
 =?utf-8?B?WkJUWE84N1k2WmZ2S2VFNXVWWU1SZmJnM2Y1c3BvRDY5RFFjcFJDSzU4R0s1?=
 =?utf-8?B?aGN6SjBtWk9DRXRCdmk1Vm04TnJXcHU0bWZxQ3JRRWRKWE9hcVZxV2xqZWNR?=
 =?utf-8?B?UTB6c3B4My9mWDNNN0RoTFVFNDhlQVhmUXRKcDBMRmloZjNhdmR4RmpLL2lJ?=
 =?utf-8?B?b1M5cmhwN3RIRWdTTCtKM0pqWG5Jc3Ura1RBVzYzeFYvTitjQmsxdklNZ1k0?=
 =?utf-8?B?K2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	y0wj5I1ZeyZfGzmD/AWuiY4SmCuSaAiPH6wtx4k7wb8wr2ky/5CMPvs8DlyZ1bdh8+/axRvidnzpzhouXn2mVff2XvqXek+EQ2XimzIjOZk6P88Ml8Z5bz90r2VvD9qkszDmrL8q+VrXgzDFMJagIM4kLQ1/mOWoa+FhtK8UH0iORcu/mVlyR1luZQk+lBsWeiZEGyjn8y8Hl4TqOmpPEE7EhKLMWdf3jvBvW/szM8RHwVi7VtHyp07IyEcgMaO64tcx/D8ssUwjdiAfZFIBhUKNrBpS1jmKu/H8Ucg8tnAGDlXWBY6QYxJViQfcKvivmiXdNy+8NqhLKbhDRuuj9ssSM2/7ivJSyE+aZS29gYKGtN4x9CDOWroGeqsSABppKBAO7jD8VoR7Ng/0rSwMyN0AXLS2CDl+tXJRElYcS0uneXPbCG0hhExbSGuBT+0kr7svyKsK+QBj8V8yt84s1XJVgh4MYuhaufzB1I+UvPTWJqTLCY+k5HHvLr2GY+/BlmCYkczW03zev8OBWVGJCUzyYIPjKGrquJ6Bp/fYvgEHs/pyKFhzDx3lA1/Hqd8nTueLlYUgsfpHj6oDj74oBnfu0oPSz3F7HGCVUdR0G6M=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37206a31-e67f-4864-cbd8-08dc79b71de7
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2024 16:57:37.0379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +rOtZ6uOg3267Y4QUXyX4Fvbxtn5wZZgbRGrz5evRVjmKK1c+h8NjApKJecEAplosLWCTRoSzJVeXlaQvI/zpkO1fLMW7o7J3OC7NXosi8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7705
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_10,2024-05-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210128
X-Proofpoint-ORIG-GUID: YX1tUg-tIbfm-82pVXtJspMipbFNriut
X-Proofpoint-GUID: YX1tUg-tIbfm-82pVXtJspMipbFNriut



On 5/6/24 02:35, Hou Wenlong wrote:
> The check_apicv_inhibit_reasons() callback implementation was dropped in
> the commit b3f257a84696 ("KVM: x86: Track required APICv inhibits with
> variable, not callback"), but the definition removal was missed in the
> final version patch (it was removed in the v4). Therefore, it should be
> dropped, and the vmx_check_apicv_inhibit_reasons() function declaration
> should also be removed.
> 
> Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>

Reviewed-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>

> ---
>   arch/x86/include/asm/kvm_host.h | 1 -
>   arch/x86/kvm/vmx/x86_ops.h      | 1 -
>   2 files changed, 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 1d13e3cd1dc5..a10d7f75c126 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1702,7 +1702,6 @@ struct kvm_x86_ops {
>   	void (*enable_nmi_window)(struct kvm_vcpu *vcpu);
>   	void (*enable_irq_window)(struct kvm_vcpu *vcpu);
>   	void (*update_cr8_intercept)(struct kvm_vcpu *vcpu, int tpr, int irr);
> -	bool (*check_apicv_inhibit_reasons)(enum kvm_apicv_inhibit reason);
>   	const unsigned long required_apicv_inhibits;
>   	bool allow_apicv_in_x2apic_without_x2apic_virtualization;
>   	void (*refresh_apicv_exec_ctrl)(struct kvm_vcpu *vcpu);
> diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
> index 502704596c83..4cea42bcb11f 100644
> --- a/arch/x86/kvm/vmx/x86_ops.h
> +++ b/arch/x86/kvm/vmx/x86_ops.h
> @@ -46,7 +46,6 @@ bool vmx_apic_init_signal_blocked(struct kvm_vcpu *vcpu);
>   void vmx_migrate_timers(struct kvm_vcpu *vcpu);
>   void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
>   void vmx_apicv_pre_state_restore(struct kvm_vcpu *vcpu);
> -bool vmx_check_apicv_inhibit_reasons(enum kvm_apicv_inhibit reason);
>   void vmx_hwapic_irr_update(struct kvm_vcpu *vcpu, int max_irr);
>   void vmx_hwapic_isr_update(int max_isr);
>   bool vmx_guest_apic_has_interrupt(struct kvm_vcpu *vcpu);

