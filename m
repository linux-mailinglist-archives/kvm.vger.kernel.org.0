Return-Path: <kvm+bounces-1603-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 287677EA11E
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 17:18:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D16E0280E4D
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 16:18:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68FB722326;
	Mon, 13 Nov 2023 16:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="3MfN5sfx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="FtlShnLJ"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDAF22318
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 16:17:50 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33ACA10EC;
	Mon, 13 Nov 2023 08:17:46 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADFrpb9017978;
	Mon, 13 Nov 2023 16:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=r/SV8WePoIRRY+QfEZ2pLA8xwex86suC2QbOya86buw=;
 b=3MfN5sfxlFTpSc7zKpHtQHMl6d9QSVYmE1hPieZrlgfJKHkjmjZ0LSV8XOLkd1rz/XO9
 IWGDhz8rapevsYp9D6RbrkIYLW9Nua+JzQcgz2hEqap9gx93Q/wbGGeK2jX7/symWbj6
 wo3yyD4n9a8+nWf1Klv4StjFtKQvhxGT+kyUsvsKsRaskMVXhIiTmZ6C76NdUSFYETTd
 7VdF8064P/H//UkV0qizaA1COwWmW6RR5HzEN3vbY3357dDy/14AZKI6Vnkm90CaMzWL
 29ppX4B6+NCXhsTuG5ggPKdAtNTzaPmOdbgAtRF92DzRcIjv1txgRa1PUmEn88yqBB9I Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2qjk6jk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Nov 2023 16:17:27 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3ADFTtBY004552;
	Mon, 13 Nov 2023 16:17:26 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2041.outbound.protection.outlook.com [104.47.73.41])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ub5k1wq4d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Nov 2023 16:17:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KZmxeigCcVmnfCa9yft+kSvR1dgy+bQlXclFtB2mHyjCU1UREGijYTQ7bBSXh6Et/t+vas1glvfAPSo1BqCWJlltr9Wa1iql/fws36y5em3YIoayBoFwko+a3v+equO/h9AgI+TIPfs6B75jimkTxIj0at4IxhPYD8ig9QBLTmxGfHP2iMMPug5Ixz0ULlYjm2stHGUmN4e2O5QvkOItASJJE5LtIErF0LVsPgKouZBNL5NdLlQotm9g7oJ1pSYm0nPe9fBs9JmWfA4/f82tHWeaXE93j3b5P6yL2t41bvSXunmqFPKXEnR04FBGEJObzcWh4kpcxfcvyLbxBCgIJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=r/SV8WePoIRRY+QfEZ2pLA8xwex86suC2QbOya86buw=;
 b=KKBedkfMMYr01RMFBLJtvkiYJqC3TRXs8F+cg2LV7/aZg3rfPyv9UAS6dGll1AfE6LpH9rVm+EwgNFIAPBqwG3blx/oKKKthP0N49L3X7uZaSPD/vWrTwpWbUvZLoHvU2j2D4Y5S12/R6ayspEF4q5f4/8znrjBzpdtGQeWrSVTo8BZoppksH9N9bJxGcRZ6FIOMZm0dReMGzPiUe+stD+sP7y4DwIeaMKzQauKmHnADUFsvmGe8r9gyZ8wKMYGpVnwaKTOZjEknkWufsQudddvDHrHA1s+ZMuO1n4qr2mckZl3Iq0FW9DHKr5/Qfw/sJdbi7Lq8BdzjARGUCKMWvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r/SV8WePoIRRY+QfEZ2pLA8xwex86suC2QbOya86buw=;
 b=FtlShnLJXMWTHz30t28rYTNTBXAShKv768wZCaPVB0lojCBUyADn6JOMKOSBsuKkUHQcqUuqIWZCB+8ZqCy5Cb0SYH576/E9eL8c5SUQv69nchUvx3uzM7ZqSrnMAnjCcKkOJOHsN9Qro2oSaIhcrDrr3Oe8jfsIxPYu/5Uhxc4=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by IA1PR10MB7335.namprd10.prod.outlook.com (2603:10b6:208:3d8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.29; Mon, 13 Nov
 2023 16:17:24 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.6977.029; Mon, 13 Nov 2023
 16:17:24 +0000
Message-ID: <5ac76cf6-04e6-875f-3075-facffb01053b@oracle.com>
Date: Mon, 13 Nov 2023 08:17:20 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: KVM: x86/vPMU/AMD: Can we detect PMU is off for a VM?
To: "Denis V. Lunev" <den@virtuozzo.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Alexander Ivanov <alexander.ivanov@virtuozzo.com>,
        Jim Mattson <jmattson@google.com>
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com>
 <CALMp9eSg=DZrFcq1ERGMeoEngFLRFtmnQN6t-noFT8T596NAYA@mail.gmail.com>
 <09116ed9-3409-4fbf-9c4f-7a94d8f620aa@virtuozzo.com>
 <4a0296d4-e4c6-9b90-d805-04284ad1af9f@oracle.com>
 <12aa9054-73cd-44d3-ba76-f3b59a2bdda3@virtuozzo.com>
 <12d19ae8-9140-e569-4911-0d8ff8666260@oracle.com>
 <600ec8cd-bd94-4f82-996f-28225442d5b2@virtuozzo.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <600ec8cd-bd94-4f82-996f-28225442d5b2@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR05CA0090.namprd05.prod.outlook.com
 (2603:10b6:8:56::13) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|IA1PR10MB7335:EE_
X-MS-Office365-Filtering-Correlation-Id: eb7b9799-2b4c-4a09-5434-08dbe4640534
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	bcMBCpff3KR9FaVYrQjrV/ZlpbZZt6OaHNhtVEUyHa/Wj39sWxqqnGGZdEYGlDJG6PDuVLi3h4r4zVjO+9tGwhdd99BlwEp1+o1LhNjki7L84U+6Fn+sZ/avfN63zS5tani5IryLzwOtYDlP92zqsschmOkfDu6azty22mPL9vvcIBFkH7FnkLD6PCkBivi2rAZ0+K4lVwZt2l1S/H9JHroQVy7iGAEl9bIsYpHgG5MGb/me9Lqe8FuRYde1MLlsZfQWzneW6TV00y8NMw81VG7fEifH0Ui3gAYAsAaZHUYDzSDR1+29FBOB4cs6YIegLKYba3HqcYXXaE+ThusvmhHaw0qrzr2nmZd0lN2nQuUR8OB7o4FkmWTPAQ1ug+6XKQRpZ8W4nmmcnrC31jyqNgbmoAToWi7ThivZMWVdAZTR3X61MvFVruLsZarPmsPjd/WGj2k4FXUwqU6JSc24HlSHaDichr4wa2Yz9d8zuo/g3sA1eN3KpsGfH93lXpUo6v735x1ZuT4YbddiyE4pBq+zjkKw4ZZvH15xKbgolMeZpDiL0dmdeiGAklj/ioNPYHQmSmyte5UIv1A5+iDQog5uj2gX/oKRm8tAqp11m/5vA+34O6GgnFYMuas2pOmR+pZ3S4JiJ5yjY8jqC9VdtCjzJ7qt0FiFLdvfEmLkV3TkGzusgdCzaUUPT949MwrR
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(136003)(396003)(346002)(376002)(39860400002)(230922051799003)(64100799003)(451199024)(186009)(1800799009)(4326008)(8676002)(8936002)(316002)(66946007)(66556008)(66476007)(54906003)(110136005)(2906002)(41300700001)(44832011)(31696002)(86362001)(5660300002)(7416002)(83380400001)(2616005)(26005)(38100700002)(31686004)(478600001)(36756003)(966005)(6486002)(6666004)(6512007)(53546011)(6506007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QTNQU1BvdnN6T01hNldUZ3F1emhLNmhEcFRIU1hzRGZkRFFpNVAxRS9DdlM4?=
 =?utf-8?B?Zm0wKzhzdG5nSWNObDAzS1JLVkhhajFheHF6WElIZWVnaUxhWDNMdEFSSm8v?=
 =?utf-8?B?VVpCSWFZQmFHakEvZlQ3Q2E0VWxBaFJOakphcEtrK0JBTERMc2Z2MWtZUVN3?=
 =?utf-8?B?SVdPY0puQjhNRjIxVlJRcStxR0F5bHk0QldlQzBveGZKUm5tOThaNWxHWHZ0?=
 =?utf-8?B?eU8vSC9hNmliYnRtTDdBK0Z6QjV4dlljR29BRDVJTDZHeGNodVBTaHZBVjhE?=
 =?utf-8?B?NmFXSkcwMUR2bm1GRk9HRmZpTE9LWXZ6RHNoUGJ1eW5DREhVeTlaVXRpWGNV?=
 =?utf-8?B?R0Y2N3VSUk9QZ1lWSElsL3V0MWpBMklQa1REa0RXRjkxSWppQW9MdXpFRU5G?=
 =?utf-8?B?Z0hOK1gwdmhKWDdIaE9OVHc3dm4vYWgxKzNYVG9VU2g1SFJuQUhjbU1xMktJ?=
 =?utf-8?B?blptbFRYcUR4bkhKcHlsSUlXQmJmUEJaVzNyVGRpQSt4RUg2YnpYWS9IZFhS?=
 =?utf-8?B?ODJvZFdUenltVUFkZFlsMjE2eEtJVTFPWjR5MUtMYTlqeWJidFZDRFhVbEcr?=
 =?utf-8?B?VGdyWXZmL1pCOEczMTVXU3lob3RrTkdKS2pFRXFzVk0yR3VRdy9GNnNmWmQr?=
 =?utf-8?B?Z3pQd1ZRSVdZWFhvOXJibENrV0tDTGFxTTl6ZVNlNFlEaWhaajhFYktJakkx?=
 =?utf-8?B?NXJFR2R6b3VjaG9OY2pFVHRDa0hQa0JyY3ZuZjVwdThwdkFidkhGRkREZkhp?=
 =?utf-8?B?NDdmcjZvOGxxWkl6SVUzd2w0K3A4ZXNjdUlYcmJTSEpnVEF0SWV5VzlnYklV?=
 =?utf-8?B?MnBzWUJVNmVTazdTNEl2NmtvNEVyQ1N1SlFvdGxzT0VIV1FCemQvdTNFNTNQ?=
 =?utf-8?B?WmIrL284dGYvazNEVFNybHNkNThjcFV1WWFZTEVVL1hURDhjR1JRMk8yaWlO?=
 =?utf-8?B?ZGVwRGtwOG1DN0J6VjhqajBwckxTSVEwTk5tdkNQM2lQb1dEWkMxU0lPaEJr?=
 =?utf-8?B?YWxqQ2orUTlVMi94VTdlTmlwSWo5cDFRc2hZbE9OUzkwdm5EVmJRUTU4cjY3?=
 =?utf-8?B?QjZybndBQ0lyMTRCUHlCTHZnbGZSdER3d3JaTG1PcllHWWtYdzAwSjZzQmVm?=
 =?utf-8?B?YmxXZmdNVWMxeUxZaWZ2ZTFxMkRuczA1YmpoOXdrNHg3UWFQeFcwSGthUE9W?=
 =?utf-8?B?Tjd1a1BZenNFM3JlOG9UVm9qNDB5VzFNOEoxODlXVjF5eC9aVkdWYkZCcTlQ?=
 =?utf-8?B?SkJkR0s1bUJxOHZPN2RLLzNnMkRtRHpjdEZmRkViajF4cFl2d3RoWW02dmlq?=
 =?utf-8?B?N2hOZWZJTmpReEg2YU9KbkZ1dlA5M2lLTkY0WngveG80Qno4azZ0SitkZ3hi?=
 =?utf-8?B?cHJxbVNNcjRMZTExeFFWeE5Iek1qa3RIc0FhcVlZYmowWndyNWxKQk1BVWdE?=
 =?utf-8?B?dGxqaVdmQWhyVEFlU2MvY1NMdElyaDFDQjhWbjh6YjBmN2x0djFtdCtLNVlU?=
 =?utf-8?B?VHlFM2dqcURGZ05TYjdETnl4c3ZtOTlmeE9WU0hnOVZWaEZ0WW41cDNWR1ND?=
 =?utf-8?B?MjVVMzlaTG5Hd0JmZ1RjRFY5Z1JiTDJjK1hIM2F2Wkk3MVh1RTlmWUo5VUZi?=
 =?utf-8?B?ekswMWEzQm1hWldNQTJRYU5tSTVXRFVwVm9qWWhkakp6eUFlNk80THNibUMw?=
 =?utf-8?B?U2RWV0lzSEtXYkRxTW4vYWs1dUtwbU82aFVEa0hGclFtSmNSZ1NmSURxQi9H?=
 =?utf-8?B?RXgzYnVOd3JDeTQ4QlVNTjVzMDE0WHJGSk9vYWNEemQ0Um5UMW5BL1VKdGJ5?=
 =?utf-8?B?cDRlR05jQ1cwWFJKdHhtK2FYdncxb0c5WFlmbkZlTXhxbWlzT1hzam0ycFFH?=
 =?utf-8?B?QlNHRjFpb0JhTnlJVHRhendON0FBTmQxVSsxV3o5NUwwR0ZHS2U5TFVKZElD?=
 =?utf-8?B?WnM3WkRIUVRuclVMb1JqWjE4MjhUYVBrMVdxcnNPUjJONlRPRGdYRWVra0Zl?=
 =?utf-8?B?VzRPNDRBRzR1c25aalFqbEZsZ0lEaE1uOXZkV3NNdDBPcURlU1BSY1dHT0Fn?=
 =?utf-8?B?S2FTNk5CL3hiSTgxV3NYanJJemdaUkxFZ0hORjRtSnhYRXFGOC84UHgvRGFI?=
 =?utf-8?Q?Xodtg0lKCcr3yt280mj/G9814?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?d01hUEJWUkJpb2VGMnM5RWJOY2ZsOHFYK0VBdlU4dkN0U1IzUkRFNVdmT1dI?=
 =?utf-8?B?aEw2WnBpVFRWU0dsU2pxWGF3bVQwaUFHd3RpbWg1QUhYdmtUNXF6Y05Nc1dR?=
 =?utf-8?B?UTBHb1REWFZWb0dNbG55cU9HWDNCdE9EUzFyTGZCc1RpYkt5OWtMVTB2aTVB?=
 =?utf-8?B?dFJsL2hVbmF0TDR3SnE2YlRWRkxVcjJPa0tKWk1xQUg0Y0Z3bmpQbmw1V2ZO?=
 =?utf-8?B?ckRKQ25PZ3lCaXNlOVVGZVhuWjU1ODBTeU9TdWF4VVZUVTV3QXY0Ym1IajA5?=
 =?utf-8?B?U0NpZDRndXlSNzVySXpJQXZ4WjNMTy9VWmFyc3NJV1psa0dUL1gyUklaeTBR?=
 =?utf-8?B?c0FCMnE3NTRJU2t4Rkk0dWZPVUx0WWVKbTFxUTNXZjV3SDhmak0rNitoazkv?=
 =?utf-8?B?R2FwME9vK1NDWGZQVHIwRDEyWHAyYUlhQjNLMk1EcmVFcm9kZ0V1MzN6d20y?=
 =?utf-8?B?ckJLRDRONW5IYWlDcWpaalpQdllUT1B1OVZVMDhrZk5WbU9ycUJpN3R0bjNG?=
 =?utf-8?B?UzFoam9leTJzVFl5YnNGNTVIczNRZWZEOHM1aFVhY1gvNDlOT1pkRmdINllz?=
 =?utf-8?B?elJ0T3h4WG9vNTBOMmlveWtGbzlPVTQ1RWx5S2J4WndKUCtrOUF4NmZYR3Q1?=
 =?utf-8?B?UERuaWkyOXNWbm95enZOdGxiUFN0NmcvNW13RE1GUUpvaDNja0lWK0Vaalgz?=
 =?utf-8?B?T2hZcldBMWtQTW4zN2ZBL0NFRjRRa3B6TXhhN2RvRFRCSDR2VSsrVjJybzVm?=
 =?utf-8?B?VE1KdVl6N1dPZWd2K1Q4aUpuc2xFb3VlQjlUdkJ6ZFZKZTlWQXFGVUpnYk4y?=
 =?utf-8?B?b3VSRkJkbGVraWVBdlM1YW5razV3UlNwTlU4ZkRWbWVERjYxMG9BWDg2SmhC?=
 =?utf-8?B?dHFoalNITTFEcThLVWRpUGtWVDF5alR5aEJWYVpoOU5Ca0JpWXlScjVhRUxO?=
 =?utf-8?B?ejI4WE9ac24yMTJ6bmNJSXRxaHIrN1FqeXNsTGJjTTNqbzhZUVpaVDRRKy9k?=
 =?utf-8?B?aG1RY0tFdlFXMnkzUFdra25tQkJPVEFFWSs1eDdUWnpBMHAraWhjVkZSL3N6?=
 =?utf-8?B?MFFVcUhleWlkSm5xWmJ6ZkN5Y2dBa2pDMTdHVnEySWVTeGcvM3RrMVdqMmVh?=
 =?utf-8?B?RnBtQXBwaEtWUGs0cmNPRmM5T25KS1U2eXhOVFZySHRyY3Z1MkJkQThiUENE?=
 =?utf-8?B?OE9CR0lzN2NlWU5tNnhaWFVRSndtQmFnbGRGbGdUckFHb0kralEra3NMbkl2?=
 =?utf-8?B?MW5aM0swM3FCUVFhODg0ZmJXNXVZbStsRVBMU3psOVgvbTJSQ0tlakp6Y1Q3?=
 =?utf-8?B?dFN6aTIvVGdLM2xyOU1ocUhJYm1wTStQTzdLNUMvT0d5VTdCTkNxZnlKczQ4?=
 =?utf-8?B?OTlBL0tXdmdjdkE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb7b9799-2b4c-4a09-5434-08dbe4640534
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2023 16:17:23.9745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ujmNPv9yEl3RhicmvnJnk7HhToE6R+H7vQdeI+d/bJLN9B3fDXW7JRQSOZQTooxbRBLmIPX0UBqVy4e/uMd6jw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7335
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-13_06,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311130133
X-Proofpoint-GUID: etOVP7lCHzv1ENA5-sR6yB-SQ1azh0RI
X-Proofpoint-ORIG-GUID: etOVP7lCHzv1ENA5-sR6yB-SQ1azh0RI



On 11/13/23 06:42, Denis V. Lunev wrote:
> On 11/13/23 15:14, Dongli Zhang wrote:
>> Hi Denis,
>>
>> On 11/13/23 01:31, Denis V. Lunev wrote:
>>> On 11/10/23 01:01, Dongli Zhang wrote:
>>>> On 11/9/23 3:46 PM, Denis V. Lunev wrote:
>>>>> On 11/9/23 23:52, Jim Mattson wrote:
>>>>>> On Thu, Nov 9, 2023 at 10:18 AM Konstantin Khorenko
>>>>>> <khorenko@virtuozzo.com> wrote:
>>>>>>> Hi All,
>>>>>>>
>>>>>>> as a followup for my patch: i have noticed that
>>>>>>> currently Intel kernel code provides an ability to detect if PMU is totally
>>>>>>> disabled for a VM
>>>>>>> (pmu->version == 0 in this case), but for AMD code pmu->version is never 0,
>>>>>>> no matter if PMU is enabled or disabled for a VM (i mean <pmu state='off'/>
>>>>>>> in the VM config which
>>>>>>> results in "-cpu pmu=off" qemu option).
>>>>>>>
>>>>>>> So the question is - is it possible to enhance the code for AMD to also
>>>>>>> honor
>>>>>>> PMU VM setting or it is
>>>>>>> impossible by design?
>>>>>> The AMD architectural specification prior to AMD PMU v2 does not allow
>>>>>> one to describe a CPU (via CPUID or MSRs) that has fewer than 4
>>>>>> general purpose PMU counters. While AMD PMU v2 does allow one to
>>>>>> describe such a CPU, legacy software that knows nothing of AMD PMU v2
>>>>>> can expect four counters regardless.
>>>>>>
>>>>>> Having said that, KVM does provide a per-VM capability for disabling
>>>>>> the virtual PMU: KVM_CAP_PMU_CAPABILITY(KVM_PMU_CAP_DISABLE). See
>>>>>> section 8.35 in Documentation/virt/kvm/api.rst.
>>>>> But this means in particular that QEMU should immediately
>>>>> use this KVM_PMU_CAP_DISABLE if this capability is supported and PMU=off. I am
>>>>> not seeing this code thus I believe that we have missed this. I think that
>>>>> this
>>>>> change worth adding. We will measure the impact :-) Den
>>>>>
>>>> I used to have a patch to use KVM_PMU_CAP_DISABLE in QEMU, but that did not
>>>> draw
>>>> many developers' attention.
>>>>
>>>> https://urldefense.com/v3/__https://lore.kernel.org/qemu-devel/20230621013821.6874-2-dongli.zhang@oracle.com/__;!!ACWV5N9M2RV99hQ!McSH2M-kuHmzAwTuXKxrjLkrdJoPqML6cY_Ndc-8k9LRQ7D1V9bSBRQPwHqtx9XCVLK3uzdsMaxyfwve$
>>>> It is time to first re-send that again.
>>>>
>>>> Dongli Zhang
>>> We have checked that setting KVM_PMU_CAP_DISABLE really helps. Konstantin has
>>> done this and this is good. On the other hand, looking into these patches I
>>> disagree with them. We should not introduce new option for QEMU. If PMU is
>>> disabled, i.e. we assume that pmu=off passed in the command line, we should set
>>> KVM_PMU_CAP_DISABLE for that virtual machine. Den
>> Can I assume you meant pmu=off, that is, cpu->enable_pmu in QEMU?
>>
>> In my opinion, cpu->enable_pmu indicates the option to control the cpu features.
>> It may be used by any accelerators, and it is orthogonal to the KVM cap.
>>
>>
>> The KVM_PMU_CAP_DISABLE is only specific to the KVM accelerator.
>>
>>
>> That's why I had introduced a new option, to allow to configure the VM in my
>> dimensions.
>>
>> It means one dimension to AMD, but two for Intel: to disable PMU via cpuid, or
>> KVM cap.
>>
>> Anyway, this is KVM mailing list, and I may initiate the discussion in QEMU list.
>>
>> Thank you very much!
>>
>> Dongli Zhang
> with the option pmu='off' it is expected that PMU should be
> off for the guest. At the moment (without this KVM capability)
> we can disable PMU for Intel only and thus have performance
> degradation on AMD.
> 
> This option disables PMU and thus normally when we are
> running KVM guest and wanting PMU to be off it would
> be required to
> * disable CPUID leaf for Intel
> * set KVM_PMU_CAP_DISABLE for both processors This would be quite natural and
> transparent for the libvirt. Alexander will prepare the patch today or tomorrow
> for the discussion. Den

That is what I had implemented in the v1 of patch.

https://lore.kernel.org/all/20221119122901.2469-3-dongli.zhang@oracle.com/

However, I changed that after people suggested introduce a new property.

Dongli Zhang

