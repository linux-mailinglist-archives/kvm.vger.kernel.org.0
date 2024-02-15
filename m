Return-Path: <kvm+bounces-8803-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C497085695C
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 17:18:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FB331F23D62
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 16:18:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31AD9134739;
	Thu, 15 Feb 2024 16:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SWiMmDzn";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="WRnR+/Ub"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DCC133402;
	Thu, 15 Feb 2024 16:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708013835; cv=fail; b=pgFyox114/5g+jsQtwSYgD0fwZ1/oWHUKgPhsgQUjnYEilODGYDIjUIbtjjW6/NOpfutWDoN7S6CWapudejVmUScNRwrR7MmVaB2DHdzPRxDeGcr+0eOifRayD/o71XspRJKCMsgUbP/Sc4piuqtj3AcmVZb9hVZOvr7VtS9BPA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708013835; c=relaxed/simple;
	bh=NKPGy9L5/T1vUN6mYP9J7iGsJ+8cJvWY74D80yVPlNg=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=He+9J3ZSIPyOm6A6+njh2G1xMBPoFOThL53ob9sgtDUd36chTkenkIMQg1J4xzVQWVxF2xNfSGtG6BRIFAiavixoDs5xDbICsxXypULJ1Qt48G5n/Kb+xnyRRQkLQJRuUv2WcYgNV6PngXgbypI9qHaaURuyhK4hAEARe7fHA10=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SWiMmDzn; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=WRnR+/Ub; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFTPai002874;
	Thu, 15 Feb 2024 16:17:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=UH/A1SLjDdEHxMnklB5e8QU0YGV9TFmE+ZWWlZ+bHsE=;
 b=SWiMmDznUalm+liA+NXkWVFhdU3j06toXi5cIYap8wOjsE6zkM9FRTQT/j1I2Eqx6NsR
 2wToeiE6zv1DhuEFQ9I2TaV4awWlBbVta0HrlHGXHw3w2jOK4qhtCKsN74DwCcbl/Pb9
 1Gm0J9y8u8Dv1xfwWNuC6lE44arTGqxcZyLmg1Oh9dgMir45wZHPDRJ4JalRCpZ9WLQb
 mzXx9/QlpLUWRsycOkJLLAKiOsyUHeyKOl9sI69grVa7iq13Qb4zrU68I6oysmoBUAeW
 QKV878aJ1bzpyIIH68YtfdSaAn/U9C0v5o2qRCy1aL5mnEcOL4/v9nt/xkI7K/VqepjG HQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w91w6trvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:17:06 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFI7nj014988;
	Thu, 15 Feb 2024 16:17:06 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykaf5p8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 16:17:05 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cle24rtgT/Ui0ytKOWTwy9dSGSLLrcpYOdqXagHGSLp20RJznf6sOUqixo1kkkX8RWs5jvW5QTgxWyjMWGx26dTjYtMEqnW+6spxL+Iz+UAO0GPWkP1/en0WPpHa+aykFJF7apIsQWuZ4XTRR4LmSw7npKxDbmfCNFmZr4I3Q+kMIFln2wpzBauJ7phSSO25wV+pxsvqVQUu9uv5NXFClwBIzQ69B1Rh815LwfgcGwKAmCd+DiC+PRm2ai9mEIC1UgFLJWUBgp0cPNo2YoB95qKJNXg82WIzoOoUelhYO/Mc+fecnbPwITIHEIJ138czuYlZcAc9nd0jxokfsh5GbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UH/A1SLjDdEHxMnklB5e8QU0YGV9TFmE+ZWWlZ+bHsE=;
 b=EaPQOTt82MGC3oSkzZUYZcYvYZZzjOcP4PDzxDNnGm3x39mgZWBZ6lsL2SJVW58Xw/8i3W2LD77WBAY1gR8U03qm3k5ReSXmEaDOdNVPbYfSC+641qMSzGZnxNXk8D8Z6amjEJ2cZmg2tI/vFsnjPEDJxTXIZ2x1+CHuBi9/kybpYRkAKBCmcH9G2UW54KwmK2tAeriw2JUS3cbEfU1OSVBRVQ8gD7mNWQ5CWSJijPOF3BBtZHVl0s4jplxpecX32Elps8mTm8rvblSd5I4y4Td43HwRm7ArXlAUWrvonyP6LIB4iBho73X2wfn0aS3vWfnumGIdN8EBegZn0tNJGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UH/A1SLjDdEHxMnklB5e8QU0YGV9TFmE+ZWWlZ+bHsE=;
 b=WRnR+/UbaMk0UiGZxMTZ8QphDbUkeKnil+ggvUzbVgB+x7ctMXpROg5rZUriF7IKOoNxUSfuhMsQt8eMvrAS4qGGMheS9PhWCbAPdjrSweJ1dD05ysEYwb+EES5IAaYMRY/GmsHcb20pFgNclpXuBQ/7zgq0StFvgzsdWHRsYzQ=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by SA3PR10MB7022.namprd10.prod.outlook.com (2603:10b6:806:317::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7270.39; Thu, 15 Feb
 2024 16:17:02 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7292.026; Thu, 15 Feb 2024
 16:16:59 +0000
Message-ID: <56130d48-706f-d1d0-bd23-69544298f353@oracle.com>
Date: Thu, 15 Feb 2024 08:16:55 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [RFC 2/3] x86: KVM: stats: Add stat counter for IRQs injected via
 APICv
To: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, kvm@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        joao.m.martins@oracle.com, boris.ostrovsky@oracle.com,
        mark.kanda@oracle.com, suravee.suthikulpanit@amd.com,
        mlevitsk@redhat.com
References: <20240215160136.1256084-1-alejandro.j.jimenez@oracle.com>
 <20240215160136.1256084-3-alejandro.j.jimenez@oracle.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240215160136.1256084-3-alejandro.j.jimenez@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BLAPR05CA0009.namprd05.prod.outlook.com
 (2603:10b6:208:36e::16) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|SA3PR10MB7022:EE_
X-MS-Office365-Filtering-Correlation-Id: 50c85d7b-9288-4138-1c4d-08dc2e41898d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	YHbhejkuaRJgzFCrp1e8BofvxNHxPQet+RMa4K5WDayEX4DXSiGhw8jizxbrgadSbPwt+/OTRuBOzHG2hqVos5kj44OTXECXFJL1pW5haSvaad4WKlnNQ8dPRWSg6XfEOY9aiMboABmCUeNLY9mVizKYgU3my/mwUk0bSHIvyfMXE3a4WIH1umbFUuRAi/JFdEE+DJ0CVRUPflYuREaiCGDZ9BdLjPgYmz/Rs8xSXWCheFWzxF8f4jr2uTOiNrTrM2A6X+jERxcr4myGjOlM1Ep2Ie3Kh2Ln4CUT8d6Vm1YYjgy4E+6DCUlixXvGa249F3N2kZ3GYaT7LZDy9pE/iPHXjytGOi3cvo0ha78CElkoDPK8o+WMYt9E2+LMPJmVPZqoWtr9i6X0aqTJDn9zJ+iJOHlSRxTdhQpGcos9GVDsJegjyFnX66cNZWuEkop3cFD3HgkcWMgi+kNSWVUnhP+sj+YO7kJ7jMrH0cTTTK1nV8hlg/qjzfbyzjNnF5yvRA/ZSQMtTbaLUFqcG4PJYxUdPcm+GJwQgMzL1HWK8a7oTlEtGimIpy/NzG0PoyXp
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(376002)(39860400002)(366004)(396003)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(36756003)(6512007)(83380400001)(66946007)(4326008)(41300700001)(53546011)(66556008)(26005)(5660300002)(2616005)(8936002)(8676002)(66476007)(6486002)(6666004)(316002)(6506007)(38100700002)(31696002)(478600001)(86362001)(2906002)(31686004)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cXZCYVNKNHZHSlFhM05HUjdmQU54OWxSWHZKTUFlUlRMMVN2WGprT216Vy9v?=
 =?utf-8?B?RE9GTkV1NDNqR0FjUEVURXNhRFczVWViNjBGQmYycDh0dGY3LzRPYmxSQUF3?=
 =?utf-8?B?eS9OWXd6ZjFqbmE2TXdaQ0pSVE9YaVhBZlpZRkdaLzNLeTZkalI0USt2WTJC?=
 =?utf-8?B?NHFjckt6VHNGREZKU2l5ZXVoTVF1RDkzbEhBT1VSRllMT3d5bnFzejZKYnBr?=
 =?utf-8?B?K2NhUVJmRUM0UFI0MEF1cVdJajlJbVJuZkEzMURHZXVlSElvclM3clFaMy80?=
 =?utf-8?B?U2I1RWZQaEY0OUlGN0ZPRVpvV1l0TExhbkQ0cXQvVU40dzJWWnZzbjlISHQ0?=
 =?utf-8?B?Znc1M1JaV2hNZnlaUkFvRW1ZNUNMNFcweTZ2Mk5tOEpSVzZrOVYycUFNYUhm?=
 =?utf-8?B?NjdxbHdWN3VsTXhrN21ZNEpQNG9yYyswSHNia1JjQ2lXVGxOSUc0amxFSDNl?=
 =?utf-8?B?Z3d6TmpmQm9xdGUyclVMeUMwdHgvT0NqZURkVVBOdGU1V3pnWE52QlM5S29Y?=
 =?utf-8?B?ZWFYa3dHeFpsZlkzZW1zeVlxbDJwMWJhWVJpdnVOb3dGbXdscUVybjRFaG5J?=
 =?utf-8?B?TmdPeTNBc3ExUVdxVElSdUM4ZlMxVEcxZnNJVlMycG9PcTJQbmVtN3g0U3Fi?=
 =?utf-8?B?NXhxKzF6NjRyeW1XSGsxM01ERnArejFzQXQ0MHF5aXdhSFJOSERwdE9JdWxq?=
 =?utf-8?B?NjB6V1ZYbE92SlFDNW5QQVJJVjJ3dHFZS214c0d4V3RERDUvc0xlcy9ac2ZN?=
 =?utf-8?B?ejdtQnB6REhIczdoNkZ4MDV0R2ZtSVRzdlg3Y2UzSFZtUjZSalFVVVVCbXFV?=
 =?utf-8?B?b1o3T3NXZ3kwamsrTWFmL0U0UHVJWTRZR1d0eGdlZkNJVTFTcG5HNWZCVDA5?=
 =?utf-8?B?SEdBMTZCaDcvY3Bmb3NLL1A5UytHbXNDbGI3QWRCOGdnMUI4Y1h1a2dkd2Nm?=
 =?utf-8?B?ZjdQUzhZQ0FOR0hleU1GWks1WmN4RWdBeEZENkJFb25kRHlTd0g1aTBaYlpY?=
 =?utf-8?B?akRFalpvejUvSDhma3R1aVJwMnNYalV1ekZ0WVVWbjJmdURLSmZxODRmWnQ4?=
 =?utf-8?B?SHFoc28xTzgwcGF6YjAxVDFhOXVhQk40STZob3hpdnZOT1NZVVpOaUpHZUhr?=
 =?utf-8?B?Q1RBbk9NRmExYXR2Z3gwNmtDSEN3QVo2Q2Z1TDY5cnNtdlc0QU5pWVU5VERU?=
 =?utf-8?B?ek43R0lSUEduMVBya1FGR052aFM3Z0xFTFRMYXQzdzN6cURuYTh3SUtvZitX?=
 =?utf-8?B?VTd6UWhjWFpJS0k5MUhORUwvcUxZdy9lT0FXbU9nMUtDamlhNi9lWFEwRXkv?=
 =?utf-8?B?ODNBaVhnZmVGRm4xdm5rMW5RZ3dwN09McnZ5UzVsaTFPenl0UTBFOTF2Sm9K?=
 =?utf-8?B?N2taRTE0OFQrbUJ4b2FWQXBoRDhuTWpFcXJrcElNRXJEVitjRGZLS2lldFZ0?=
 =?utf-8?B?TGZYQlhTTGlhSjNvSk5ZVTRLVk1lNUlCNGMrektwVHZMYmxaanozUWdINVpl?=
 =?utf-8?B?WTZ0Y2VmUkQrcGhKSlZvdkx3QWs3Q2VBMzI1eWYwWGE4aWYwcUJrWER2a3Yz?=
 =?utf-8?B?cWl3alZ5ZXdoNFB5MWNqM090bmJqL2JYQXl3R1JOYUVNUGV2ODFxNVZLVldN?=
 =?utf-8?B?S0RIR3p2bWMyMldQaGlaa2lTVndHenMwSUZZODVUeE9nL2VTNWRvWVR5ZVdC?=
 =?utf-8?B?ekFiZ1N0SzZjWE1JWmpCdldLbkVETmVZeEJOelVQRW1pbFZpUkNiNGFrUW1i?=
 =?utf-8?B?TlBLc0xiY2FiZmNnUTg5dWJHaWlscnJXMEo3b2liMGlhbEdpY1M3bzZxREtJ?=
 =?utf-8?B?Mi9EZTYySXRyOXdHMlNxUk84L3p3MmNwMzdBQWxZOFVsc2UwV2dKZithcXJB?=
 =?utf-8?B?N3JhZjFackZtNWpQSFFOWG5zK1ZvUXpEMDVRa0FVRE9FQXdlUGowSm41OTJk?=
 =?utf-8?B?L1A3SzgraTJJUm9kWXRPbnlYWkNFaStTUTkwYisvM3RNYUM1TGd4N1I4aTBj?=
 =?utf-8?B?UUMxVm45ZGJaeis3dS9JNEVRdWxsYldXKy9wUXhNdDlLUHE1d0lzQjJsdklD?=
 =?utf-8?B?VGs3RTR1VTBLakt0Ymp1eGxLQXJoSU9TeXRRNVJrRC9xY2FzOGdUckZJV2RV?=
 =?utf-8?Q?JKZpw1uAYmIjrkHj0oQgjXRsC?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Kciniikj2mE7XRUsXe7+9nFNhRLXtUtwmv5DumBbVNO9BhRhKBINNDCiW69U5n3oGIa6MBlXDIm/gD2Ct7jqRmh1etDFwaKbz8qDQviuOYnA8AOvQhmHJrgbLZFw+m4DFhjDGD4OjepsF/EQSRy8GRChs0SO9tcnkTpL+Z+QFZbKFgmDCBvq34rK+0LyIgDnoIvfmHASeRNM/tvnHfRwKVRQU14M2lcVBpnr1OY61CfBVhmCQsMhKjNehSC8mTQRB1s2LvNojxl5JBWR2cf0XUx6jdh7UmrSO/3W0ip7ekL7jO7qi1eefGZL/6LaIBrwayWPW4CilNkrd+ofERe1l4A8MSEfXoT2rIy+/ljfhzmCdpqjXNSok/CiY3KPQ2JWPD7EDWSaQ9EyrXLicUJzrnnfKM/6D6tn5LQ0ff1T0RRXroCMGC2CAPsG0FF83G8FefMT1QzRte9licRKxqRNmqzk9myAKR+jTwCTRsyOTlrna+Lr+p7+6cHytVpNkH7Hf/Hj+89aZENtFdvNXB8/M7tRmgd8HwXIuadTVMXcMPFE73Ebc0suz83xxVMkQuwIUAXzb9nX6u97nFjMwVV/k7HUwKCLrRKvzCDdD8cbsGM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c85d7b-9288-4138-1c4d-08dc2e41898d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2024 16:16:59.7418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 17WYRMaMnMHhWE57i1+PnIsZ0Z+ra9sOOU2pMpqysGRiZ7oBK5xpbhuG0bGZx3RwCUVwNQLyKupVwSFJHRNG5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR10MB7022
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-15_15,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402150131
X-Proofpoint-ORIG-GUID: 5gHxVJX4Aqn_gsFe0dPF7IBtVbTM8jsE
X-Proofpoint-GUID: 5gHxVJX4Aqn_gsFe0dPF7IBtVbTM8jsE

Hi Alejandro,

Is there any use case of this counter in the bug?

E.g., there are already trace_kvm_apicv_accept_irq() there. The ftrace or ebpf
would be able to tell if the hardware accelerated interrupt delivery is active?.

Any extra benefits? E.g., if this counter may need to match with any other
counter in the KVM/guest so that a bug can be detected? That will be very helpful.

Thank you very much!

Dongli Zhang

On 2/15/24 08:01, Alejandro Jimenez wrote:
> Export binary stat counting how many interrupts have been delivered via
> APICv/AVIC acceleration from the host. This is one of the most reliable
> methods to detect when hardware accelerated interrupt delivery is active,
> since APIC timer interrupts are regularly injected and exercise these
> code paths.
> 
> Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
> ---
>  arch/x86/include/asm/kvm_host.h | 1 +
>  arch/x86/kvm/svm/svm.c          | 3 +++
>  arch/x86/kvm/vmx/vmx.c          | 2 ++
>  arch/x86/kvm/x86.c              | 1 +
>  4 files changed, 7 insertions(+)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 9b960a523715..b6f18084d504 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1564,6 +1564,7 @@ struct kvm_vcpu_stat {
>  	u64 preemption_other;
>  	u64 guest_mode;
>  	u64 notify_window_exits;
> +	u64 apicv_accept_irq;
>  };
>  
>  struct x86_instruction_info;
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index e90b429c84f1..2243af08ed39 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3648,6 +3648,9 @@ void svm_complete_interrupt_delivery(struct kvm_vcpu *vcpu, int delivery_mode,
>  	}
>  
>  	trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode, trig_mode, vector);
> +
> +	++vcpu->stat.apicv_accept_irq;
> +
>  	if (in_guest_mode) {
>  		/*
>  		 * Signal the doorbell to tell hardware to inject the IRQ.  If
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index d4e6625e0a9a..f7db75ae2c55 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -4275,6 +4275,8 @@ static void vmx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
>  	} else {
>  		trace_kvm_apicv_accept_irq(vcpu->vcpu_id, delivery_mode,
>  					   trig_mode, vector);
> +
> +		++vcpu->stat.apicv_accept_irq;
>  	}
>  }
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index f7f598f066e7..2ad70cf6e52c 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -304,6 +304,7 @@ const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
>  	STATS_DESC_COUNTER(VCPU, preemption_other),
>  	STATS_DESC_IBOOLEAN(VCPU, guest_mode),
>  	STATS_DESC_COUNTER(VCPU, notify_window_exits),
> +	STATS_DESC_COUNTER(VCPU, apicv_accept_irq),
>  };
>  
>  const struct kvm_stats_header kvm_vcpu_stats_header = {

