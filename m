Return-Path: <kvm+bounces-19039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1DF498FF679
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 23:09:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC4822851C4
	for <lists+kvm@lfdr.de>; Thu,  6 Jun 2024 21:09:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D93E113B583;
	Thu,  6 Jun 2024 21:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ku4tgJoO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="SHosXewM"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DB51BDEF;
	Thu,  6 Jun 2024 21:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717708188; cv=fail; b=Q0O24gD70FRMBfcKd70ag38QGWNlp8Y28cjkIOrTkwXNRHXCR5s9LqmlBbZPULdG8JLIqQUL7uW24t5z7wQlLvWdxb/pQr8T/C1iKVSWkvcsGc4b5WRG2XD2hKnO/9VJ9tLS1yMgYfbucZIzVSxfaRpfyjsOPk4tP4/yJALmrFs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717708188; c=relaxed/simple;
	bh=bPDcZkNEwSZbH9P5Pava8NE3ob6CQvHZXzuheIJomwA=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=OokqA5sj7BO9lbaxI50DLu4Ong2dw2batK9xj1ZUycpXEycFxpfpoYyfBrdnKqItiutmuCiXIWeqI6OoxHddTkBh/peyxv+9xblLH4k2H+cv5fd7qlLGBoZ8OJyrq7Qs9aI/XaJgskJEyOO/pFaMbKt7Zuj7fxQ1uyIFJqMAlP4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ku4tgJoO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=SHosXewM; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 456HxBeF029657;
	Thu, 6 Jun 2024 21:09:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc :
 content-transfer-encoding : content-type : date : from : in-reply-to :
 message-id : mime-version : references : subject : to; s=corp-2023-11-20;
 bh=As5PO6k2M7mRNxjxlKEvDb0g+n/YMxT6DVRY7tB4/Zg=;
 b=Ku4tgJoOGPkkcWD4OSUiMNOvzE5yOpjtr8tI9fypXrI0fwZG6FuJDCJXnabo2IjNYhFu
 Yv/q1TBtm/MuKBSaid/gXm1G6/FaIU12i7na49+1QoT3Geq3QoU5AnK1o87o6/3vjlbA
 GG6ESLWZFssgugILSSaO9T1We96osbUPzS11DoadxrTgQ4dmZycf/sYuplLzS7MRAq0T
 8ePL5xOQG8EAXLLjL8uxev61gbblu272LepGfImg6ysWnj9tWNen/UH5RSXIOtju7Vbw
 L/0277ue/FZjNfTEMMp6zVxYxUReb//PVLPpOZPJBEgqeD/PJSyQqnG7zyLrmuhfPR30 ow== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3yjbtwce4x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Jun 2024 21:09:39 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 456Jmnmn016141;
	Thu, 6 Jun 2024 21:09:38 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2041.outbound.protection.outlook.com [104.47.57.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ygrsdnwk3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 06 Jun 2024 21:09:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dG9yYtGoPpunPnDbwcaYUhVECjntpmRqpchNrvmnZQ/QGmoc/mNZ28bqYOw6JIaRd3QuAzDw4IggorWSKk0T/XOvmt+OMj5mcr12x4eT4OSWuxvReetcMadoV30MYrhvyCcbr/S3RpfwLC6e3InfWiM3P8e64coRrimkXEDpEWz7iqIpWBqQAdmE2oPLHIPJvi+umget1iPShSQE1WaAQK5raz52ZTETvjmhZ3idK/puRMg4qvyv4UUZE3v0osRH/aqSvQSDLU5TJCUClBE3fXwbJtXBq0QBmjKoUzLLFBz6svc5TXViaXtrXbfX3VAMnGCefqPbkOw9g3wws7cq1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=As5PO6k2M7mRNxjxlKEvDb0g+n/YMxT6DVRY7tB4/Zg=;
 b=j1cSjhDTI3gR/QwmjhRvSPDbGqEvoifymykoo/s0VtufzY6PQgdQRmVJdEcwudHLDB/H33GDVzvcYdeKhXB3aeYiCedDoaP/TmHrASIZuMf/up+6lgZT8VhcnQursKi1GhImblaYQFdlqL8rdSV8y24grdyB/XdleLazzMfVP9L9XqEeuUdYnhydeptV/HIhoQL0eCKVQBnZC8B3gtJ9k8aAlx3xqew2LPEWrSDwBGkPZXo6zw56ZjUETVuiaisZUkMIjLlP6swsNZ4lNBzgm0A9MBRIiknd6mv6Zfzcha27V/cQl9pzkxSUlrsT+ZQsexY6PK+2nOrdyW0k5PoCDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=As5PO6k2M7mRNxjxlKEvDb0g+n/YMxT6DVRY7tB4/Zg=;
 b=SHosXewM/hVbZd9SJV4fgQc8/eGt/Gp1Y4sPm5Ky58G+Gh9pcX6A/wLVYLB3lP/1dH14SHQiBpc/JZCkODvd/cPyvPUPQgQoPEcr5bNt7ykqudwyIwQLOppMmfwa/6Q2BwnITW6ZbAvBeV6EREpmTr42qZ+pyUURZtI5S7DYHvs=
Received: from DS7PR10MB5280.namprd10.prod.outlook.com (2603:10b6:5:3a7::5) by
 CH3PR10MB6691.namprd10.prod.outlook.com (2603:10b6:610:142::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.34; Thu, 6 Jun
 2024 21:09:33 +0000
Received: from DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::da22:796e:d798:14da]) by DS7PR10MB5280.namprd10.prod.outlook.com
 ([fe80::da22:796e:d798:14da%7]) with mapi id 15.20.7633.033; Thu, 6 Jun 2024
 21:09:33 +0000
Message-ID: <06e6b7c6-ba5d-4fb0-9a77-30ac44f6935a@oracle.com>
Date: Thu, 6 Jun 2024 17:09:11 -0400
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] KVM: x86: Add vCPU stat for APICv interrupt
 injections causing #VMEXIT
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        suravee.suthikulpanit@amd.com, vashegde@amd.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com
References: <20240429155738.990025-1-alejandro.j.jimenez@oracle.com>
 <20240429155738.990025-5-alejandro.j.jimenez@oracle.com>
 <Zl5cUwGiMrng2zcc@google.com>
Content-Language: en-US
From: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
In-Reply-To: <Zl5cUwGiMrng2zcc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To DS7PR10MB5280.namprd10.prod.outlook.com
 (2603:10b6:5:3a7::5)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5280:EE_|CH3PR10MB6691:EE_
X-MS-Office365-Filtering-Correlation-Id: 4e131ce2-e4cf-4e40-ff61-08dc866cf67b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|376005|366007|1800799015;
X-Microsoft-Antispam-Message-Info: 
	=?utf-8?B?Qi9XYjE5c0xkSkc5TE5uNU9hYlV4TXdZSVZMNmw2QjBnbEk0NFhLSHBUcmp1?=
 =?utf-8?B?MzI5a3NmZGttZjBzYmFqT24wdXAwOXVtdzZOei81NmJnNFN4MXZscW5RdzBw?=
 =?utf-8?B?UjJ3a2dJcHBxbU5iRzI1eWNmV09CWVZzVjZVeTRyaEJLT2lxUVNLbEJYWk5u?=
 =?utf-8?B?QitnM1NkT21wL2htcDJrL0prZW1QaTNKUFp5NE1yUmZrS1V4THdXLzF0T0hI?=
 =?utf-8?B?ZHFQaWNkUkwwOExPdnk2QWVDR1JNaFhrTllMblh4U2pqUHRvSG5sL2V4SGtu?=
 =?utf-8?B?SURacit6VFBERDZnWFp3QzhnTE8vT2RVeCtyYWVrMEJuMUpYV2hHY01hOU5Q?=
 =?utf-8?B?Wk42ODBtUGZvUjdLQmxMS3dKbjhZVDVIUXB1ZDBCM0VTMGszQWtJOFBGYWth?=
 =?utf-8?B?Z2RTQWtPTDlmOHl3dG1jZmJDa2g5SnBzd1ZQNVErMk5UYnRhaG42bWEyVjBC?=
 =?utf-8?B?QmxST1JGSGFPZ1BPSjF3STc2Z0ZRYjlUMFhKK1NYbVpnNm1kc2lsL2paMWk1?=
 =?utf-8?B?YVgwVGUvYnhzRWxlSjBIdDBua2VmV1lSUDk0L0dNWXhMbURVNk51V3UvZDFH?=
 =?utf-8?B?WVM0YmlXMG1zdjFOd1RveE85NkpuOE8wNjd3Y1l0UWdueStJR013MVNDTmR4?=
 =?utf-8?B?ZlpKN1pKYXpuRkpWUEJFUU9WL2F2L2t4MWI1T1lDNUxLUkZmdG9zU0J5djkv?=
 =?utf-8?B?eWFSdWFwT1YzcEZDRXk2K2lKYktaT3NFWVc4YVRBUkVQTkN5MHA0MmdQeWY1?=
 =?utf-8?B?WTB6b01xNGFRY3BKbXRvZWMyVVd4ZnVoV0Jyck5ybEtWSDRZN2tJUkZncVRv?=
 =?utf-8?B?R3Q2N2hWVUdZOGY3WlNBeFNUcnVPT1VRcnBtUWlwN1BsUS94NkFuN0tpWVBK?=
 =?utf-8?B?UDdkclEwR20yanpiVGFJR2pPdVpLOVdRSUNha3FXa2RrWTlaRXRLOGhkS1M0?=
 =?utf-8?B?eU5JZ0RqR1R6V013YTBIQThQSWxBQUpmdG85bEM1NVVXUG56YjVES0xseXdJ?=
 =?utf-8?B?NmNua29Yb043R1JJY1ZqVENTMDhYelljeVJ3YU03QWZRNlBnYnlZQmJaN0V3?=
 =?utf-8?B?Y1lJUGdzOFlsUFdlMHNoV3RuK1pucEJ1dWkvaFVUYUxKU2ZWN3pjU3duU21l?=
 =?utf-8?B?M240QUpDaE8zNUN4ZDBOZ3k0eVRXMnhxeTdqb1pXNGNoczBLbFUrNC9xdlZp?=
 =?utf-8?B?SWdJVzFkWTZ1eW9aMW4vbDdNdWNxNlVzRWNiUzJ3SmVsc2tjNWxvUGF1TCtY?=
 =?utf-8?B?K3RnYkdsZWhuek5raHg4R1c2bTlTT0N5c2FhNmQxVkhyeElGTFdnaVJFR3dJ?=
 =?utf-8?B?bld2ZVMvTTdDbXVLYWduWHIvandoN09UMVRGdDdTZXY2dnlSK1d1Yi8vWG5q?=
 =?utf-8?B?REdGZ0V0T2M2d2VCZEdwSzdrVUJmU3R5dmJDbmNxQzR5eVVablNWem91Y0lZ?=
 =?utf-8?B?ZUxDTlFzVEgvUGN5QlZkVzRFbTBvTG9FRmdEQkdNajRyTmNUNTBEalVsdGFo?=
 =?utf-8?B?NTQ5TTFJNEVsMmVXb2RvVSt4Y3hwYlNMNEtCMVFXWExXYkp1eXl4b1BCaGhZ?=
 =?utf-8?B?amFXelMrSlVWcmJsYU4ycEtSK2EvNk16RmtWa0RWZElqMTU1NlE1UGh5aURo?=
 =?utf-8?B?bDdGQ0VZc2R5S2JSaXhtN0tDYlJ5MkIzVlM3eVZZZmlWeEUyY1I0QjBKcDhh?=
 =?utf-8?B?Yk1uaWozZXdJTmNCa2NGd2RLNldyUnpIZWQzMUMwOTNYTVJiV3lGVkdpSlgz?=
 =?utf-8?Q?yhx/JcTU0ZC/z0bqWMHlyJI1bawwNhYtem6ma36?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5280.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376005)(366007)(1800799015);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bmV0VThuK05LcnNyNTlRSVI1Y0tzMmxhM0RnM2FlUk50djZDdUU5b3hSNHBZ?=
 =?utf-8?B?Vy94YXFtbmlFWk9CblloWFhEb1FjSnZNKzJlL2h2ak9UR21JSTVZVmdhajRW?=
 =?utf-8?B?UjNaY3NTMzJweDRORDZ2KzBGTDdYekZzeGk4MzQ5OTlUSlVDd2dKbVAxMi91?=
 =?utf-8?B?NW80S25IeFVPa2NOdU9DR01ETGI1VzNrU3F1M0tVRzNQS2ZKS1RIcHhuNmRB?=
 =?utf-8?B?RDlneUsxdXNlUHlXMkowQVR0ck0xeVVjamQ1dnpHcUdidUk1aWJTanRmZmwz?=
 =?utf-8?B?eENtOXRpTE5BTERQRkZ4QzBUVG5JMWhyU3hKaVZkOW9jdVhxbE9tcjhaL3pD?=
 =?utf-8?B?UzFFTVRSV0ladlF4ODhYcEdOSlNmM3RiMHozRzhNU24rWExyUXVsL1J4NlVS?=
 =?utf-8?B?eVhxLzdGdGx0YkFXd090RFJpK0VhNms1eHI4NUxYYUVjcFRFaGc5WWcwNDlG?=
 =?utf-8?B?ekxqVk81TTc5alZWaWFJcW52WlJWNXF2Y04va2dHMTNOY0hkNVdlOUFZOEow?=
 =?utf-8?B?azRKOVRXYXRkUFltT1BtS0N2TUl1LzkvODVsVk51am5uQVlZTkNDWkNWTURj?=
 =?utf-8?B?M2RMTHlDbDFDRHNZK090K3AwOEo5elU5STgxZWpRRHpRcHozVmRFTjh3Uzhw?=
 =?utf-8?B?WG1pLzduZ3JJdkovZWJJSzlrNmxZY3UvRkJaUTBkemNCRUloQ0MwbTVvVEp1?=
 =?utf-8?B?N0s2OG5OZUFjUm5lQmFUNjVXdjUxN3FJMzl3SHQwWVU0b1BtbGFSUnZnclNO?=
 =?utf-8?B?Kzg4ek0vZDEwVy9RRTEyL0FFdmYzYUNjRkVOWGVVYlpMSDNGblhzcE9RcnJn?=
 =?utf-8?B?QlIwV2thR21jZ09HeHdIcDRGd0JvTWF3ZHhoaTNtUmx5b3duVHZRQno1T2Nt?=
 =?utf-8?B?NEFiUGlCKzJoZXYyQVh0eFV1NmpmQkgxZ3VRZy9qRnl0aFh1ejhMUEwxZm9D?=
 =?utf-8?B?UndRRXV0VU5KR1IvVDhWeXVVb01maFBkZElCUjdCYlJ2VjVna0VmUFBZc3d0?=
 =?utf-8?B?RHdQcC9RalJYZFNlZFArd3VDTnZ4aEpJdmYwbzJVNUMwU2k1STNrOUp3M3NQ?=
 =?utf-8?B?S1JIUUVTZ1pVZ0R5bDQ5SEpUaUwrcjB5RHBRQjhMTmpiZ1hlU09JWCt0T0lH?=
 =?utf-8?B?RGRjSTBVRVlaSVFBUjJDOUNRdjZTall6Y3dCV1pDUzdpQVNDUGpsaGtORHQw?=
 =?utf-8?B?U2Jva1RrRmhPRmVvZktma0NHSXFXdVZ6bnByUXh4WFN0bUlxZUU0RmRxWk85?=
 =?utf-8?B?eDhRdDRxMEdjc3g2N1oyVUFXd1JaQndTR0k3TFQzYzdZdldFS053VEp0OU1P?=
 =?utf-8?B?SElXczFoTVd5eDY4c0dIV3V6eGV2YmVDaUVQNnEzNTlCMG1CUnZDM0JnRmhN?=
 =?utf-8?B?aGVMZlhHNUNSMzNRaUYvV1NtdklYUUdLUGhQb3VIcXdnWFc0eDF6bjlRdmc0?=
 =?utf-8?B?eU9KUDh6eE1ZbEdKOWJZRENHaG1YZzJrYklZQ0NsTnhoNThDZWZjaFFwR3JX?=
 =?utf-8?B?Q2J1b1RWd3ozV2lHVmdHYnlOUlNPaklhSWgrN3lxMXVCUFZRM3FUbThrQ2N3?=
 =?utf-8?B?WllPTllvMWhsa0Q1YUcwemd3WERTQXl0K0liT3A1czNXakhPVWlxcm53WXl3?=
 =?utf-8?B?WVpQS015KzVFQlFIVjVMTEo5alB6bGdRVTNNeVFKYmFyRk55a2lIRkVBNEtU?=
 =?utf-8?B?MWJTVHRZdnljWkI4Qlc5WEFLekF1Z1NqcVZBMG1uNnNJUHNSNFpBSmM1OThS?=
 =?utf-8?B?NFNaaHJTUHhJbVJnTytJTEhUVjVEaHFmWEg0RVlaUEhwcWlpdXQyaDdHMng3?=
 =?utf-8?B?TkxkbVRwczFMRnNPVHhQaFcxNzhSRUJpVWIyRGJSaHhOWDYvUU83VVB2bjg5?=
 =?utf-8?B?MXJpT0tSSk8xSnRsWW5RclhncWFNM3RjRzNUVnM4MDk1VElLbmpILzMyVkha?=
 =?utf-8?B?NEl5TU4wTTRRZi9odE5uRDNWZEVWMUNhRk11VVVBdjc2b1dHYUUvUXVEWCto?=
 =?utf-8?B?TGZLTDdyZEYzb1RYVEh2TnBMNWJsdTV1U0x2SGZGcHlRRkNCbkRLckkwT3lE?=
 =?utf-8?B?UTcrVFZNeUltRWNXb1FKbzRzbG9DcUc1V0pibkJpakorRUFKZzZIUjJOZHJC?=
 =?utf-8?B?ZUpUU2lBcnlKZXlzM1Y1Tmo4aURyMU9KQ2N1VUFNN0hpWlRMejJ3MDlUMlFO?=
 =?utf-8?Q?Asd3sI748jvNux1aT7vADzk=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	c5TMBsxQalAweHpzj9b4i6HdP2pUe5JUhxETXjIBKfELX0aLxOZNoJAtpePImXNrJr+GYp0kzeoPOSGFd+myw3U+iWkX7ajdHY//M2AxCq52sVg9rA5U/b1F+KneVZI7JZm7bcXnrVzENea/BK7MKSm2kzJozYJy5dlolXnvPNedchbJ3GTYHIcH91n93w6tVqfOq7kyGmafU+LQIFD1WSD1umalSBYrfXuwUXtvnEmZORS1JVtB5I3OWIPayUv4vVX4JXQFSPk1LWWoDQLjnH6Pp7zZ9RgiN4fNG0JldCREWQnkpXPoI/b/rrN3g/PheoyP0v9Q/JdQqBaBohcjC0ISRHZZON65Wiaps3zsvH+VW4y/PDucyKZ+jarbrcGcM+SPnnDnyziparpWZrjezbesCYkMAwDl8vN8LrRydHdqJ75u5w6EV2TBCLJV2QaWOv9yU8K4c9DntvTxmPAr3Jn/gBpQFMxKnHtaDpBcqaVVVhx4sAQ8n3iDZsv1RAQg4aOq4jx6Qmx4gUuvwuAKi5TJqUKAScgkxPMOsMRMkFeLWftu//7TbsyvdyZjdMAScUi+kLxFE2a42m1xNByWXdmpnHCXFd9vU41bVLSruaY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e131ce2-e4cf-4e40-ff61-08dc866cf67b
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5280.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2024 21:09:33.1546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xblTMNfSOJURl3FlKUuh8dsDxRoOX4stOSx0t8rzBZM9RZPoCqZ0yeYn2PhDZeXjBhv46mZhpOzrvROHD9T/4amAIOGqJljQ3wl6beJUfkY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6691
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-06_17,2024-06-06_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 suspectscore=0 phishscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406060147
X-Proofpoint-GUID: p9lU9gF99TugI0vNVEjYlbeGXbYHEzou
X-Proofpoint-ORIG-GUID: p9lU9gF99TugI0vNVEjYlbeGXbYHEzou



On 6/3/24 20:14, Sean Christopherson wrote:
> On Mon, Apr 29, 2024, Alejandro Jimenez wrote:
>> Even when APICv/AVIC is active, certain guest accesses to its local APIC(s)
>> cannot be fully accelerated, and cause a #VMEXIT to allow the VMM to
>> emulate the behavior and side effects. Expose a counter stat for these
>> specific #VMEXIT types.
>>
>> Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
>> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
>> ---
>>   arch/x86/include/asm/kvm_host.h | 1 +
>>   arch/x86/kvm/svm/avic.c         | 7 +++++++
>>   arch/x86/kvm/vmx/vmx.c          | 2 ++
>>   arch/x86/kvm/x86.c              | 1 +
>>   4 files changed, 11 insertions(+)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index e7e3213cefae..388979dfe9f3 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -1576,6 +1576,7 @@ struct kvm_vcpu_stat {
>>   	u64 guest_mode;
>>   	u64 notify_window_exits;
>>   	u64 apicv_active;
>> +	u64 apicv_unaccelerated_inj;
> 
> The stat name doesn't match the changelog or the code.  The AVIC updates in
> avic_incomplete_ipi_interception() are unaccelerated _injection_, they're
> unaccelarated _delivery_.  And in those cases, the fact that delivery wasn't
> accelerated is relatively uninteresting in most cases.
> 

Yeah, this was my flawed attempt to interpret/implement Paolo's comment in the RFC thread:

"... for example I'd add an interrupt_injections stat for unaccelerated injections causing a vmexit or otherwise hitting lapic.c"

so I incorrectly bundled together APIC accesses that result in #VMEXIT and end up requiring additional emulation (while managing to miss the handle_apic_access() case).


> And avic_unaccelerated_access_interception() and handle_apic_write() don't
> necessarily have anything to do with injection.

apicv_unaccelerated_acccess is perhaps a better name (assuming stat is updated in handle_apic_access() as well)?

> 
> On the flip side, the slow paths for {svm,vmx}_deliver_interrupt() are very
> explicitly unnaccelerated injection.

Now that you highlight this, I think it might be closer to Paolo's idea. i.e. a stat for the slow path on these can be contrasted/compared with the kvm_apicv_accept_irq tracepoint that is hit on the fast path.
My initial reaction would be to update a stat for the fast path, as a confirmation that apicv is active which is how/why I typically use the kvm_apicv_accept_irq tracepoint, but that becomes redundant by having the apicv_active stat on PATCH 1.

So, if you don't think it is useful to have a general apicv_unaccelerated_acccess counter, I can drop this patch.

Thank you,

Alejandro

> 
> It's not entirely clear from the changelog what the end goal of this stat is.
> A singular stat for all APICv/AVIC access VM-Exits seems uninteresting, as such
> a stat essentially just captures that the guest is active.  Maaaybe someone could
> glean info from comparing two VMs, but even that is dubious.  E.g. if a guest is
> doing something function and generating a lot of avic_incomplete_ipi_interception()
> exits, those will likely be in the noise due to the total volume of other AVIC
> exits.
> 
>>   };
>>   
>>   struct x86_instruction_info;
>> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
>> index 4b74ea91f4e6..274041d3cf66 100644
>> --- a/arch/x86/kvm/svm/avic.c
>> +++ b/arch/x86/kvm/svm/avic.c
>> @@ -517,6 +517,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>>   			kvm_apic_write_nodecode(vcpu, APIC_ICR);
>>   		else
>>   			kvm_apic_send_ipi(apic, icrl, icrh);
>> +
>> +		++vcpu->stat.apicv_unaccelerated_inj;
>>   		break;
>>   	case AVIC_IPI_FAILURE_TARGET_NOT_RUNNING:
>>   		/*
>> @@ -525,6 +527,8 @@ int avic_incomplete_ipi_interception(struct kvm_vcpu *vcpu)
>>   		 * vcpus. So, we just need to kick the appropriate vcpu.
>>   		 */
>>   		avic_kick_target_vcpus(vcpu->kvm, apic, icrl, icrh, index);
>> +
>> +		++vcpu->stat.apicv_unaccelerated_inj;
>>   		break;
>>   	case AVIC_IPI_FAILURE_INVALID_BACKING_PAGE:
>>   		WARN_ONCE(1, "Invalid backing page\n");
>> @@ -704,6 +708,9 @@ int avic_unaccelerated_access_interception(struct kvm_vcpu *vcpu)
>>   
>>   	trace_kvm_avic_unaccelerated_access(vcpu->vcpu_id, offset,
>>   					    trap, write, vector);
>> +
>> +	++vcpu->stat.apicv_unaccelerated_inj;
>> +
>>   	if (trap) {
>>   		/* Handling Trap */
>>   		WARN_ONCE(!write, "svm: Handling trap read.\n");
>> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
>> index f10b5f8f364b..a7487f12ded1 100644
>> --- a/arch/x86/kvm/vmx/vmx.c
>> +++ b/arch/x86/kvm/vmx/vmx.c
>> @@ -5657,6 +5657,8 @@ static int handle_apic_write(struct kvm_vcpu *vcpu)
>>   {
>>   	unsigned long exit_qualification = vmx_get_exit_qual(vcpu);
>>   
>> +	++vcpu->stat.apicv_unaccelerated_inj;
>> +
>>   	/*
>>   	 * APIC-write VM-Exit is trap-like, KVM doesn't need to advance RIP and
>>   	 * hardware has done any necessary aliasing, offset adjustments, etc...
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 03cb933920cb..c8730b0fac87 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -307,6 +307,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>>   	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
>>   	STATS_DESC_COUNTER(VCPU, notify_window_exits),
>>   	STATS_DESC_IBOOLEAN(VCPU, apicv_active),
>> +	STATS_DESC_COUNTER(VCPU, apicv_unaccelerated_inj),
>>   };
>>   
>>   const struct kvm_stats_header kvm_vcpu_stats_header = {
>> -- 
>> 2.39.3
>>

