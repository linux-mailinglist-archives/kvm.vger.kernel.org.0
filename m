Return-Path: <kvm+bounces-1394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 365FB7E757D
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 01:02:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE9CC281776
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 00:02:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9043EC5;
	Fri, 10 Nov 2023 00:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZWQfkbw4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="xKgbEB6Q"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D461A2A
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 00:02:01 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04746592;
	Thu,  9 Nov 2023 16:02:00 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9MZHIh016135;
	Fri, 10 Nov 2023 00:01:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=M9SyAU2EoK2LLk3HIzbjizcSaEwrDqwWOCGA9wggEys=;
 b=ZWQfkbw4EFqunxnvCslMN4Ppr6Hqrb7BGLikkoF1OFGrQ1YxOA9z1hDRaYpSgNAPkW7+
 YYrmBb09dmwk5Nu7/Dl2jVS2tqoC1WrBr54ARQYEybdJUL5IyUD7HI9SaKnBPWjqgCaG
 osrmZeSPdLPeXcIa0YhWfOsTN8WtY2CsCW+s5xe2iF2Qw0N6qY1VcMmOsTvhaYK8se7K
 QA/DDPq0/vCRIOtB161p2f3Lu5vvndQcSZ3TvGMlw3Lx9j2tR8uwn8s2jyqyc89Yf7RB
 U+cjF+nGv+lXVxJM/XZJQhgpyyTC4ao4GMcPiW55kIW/5ViyMtaR1NoJfaWlYS975ylZ 2w== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w26w6nx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 00:01:41 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9MOcw0000416;
	Fri, 10 Nov 2023 00:01:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w216tvr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 00:01:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PKa2xT9PBFhJcWP6whs/L9hpAYHu5/m0u7AzUsxgH4HngMcIvDUwrKNsoAe2+jtY9QVJlI2WZSrEmzGLZ4Uy6dneUn5PbQiT9Zs6lFex/fwTeRFXgVg7e2i+lMaMBIhlPsQ7IekdRE4n35KTz7+3J9O8NPhIA+1eg1ceo9GgdY+qpJqE0CSCVsahKNj74tlTalhtUPBEabi9njl1suDOZKeVxZSL5s5fmgTM+LgNt4jFchMtVJGssrxvCuXFeelf5dKusHknDRn7WrmIwsbYfnnUkejo5FQpmJ092FNc3yMsVW3iltvOPcbvAngWJ6a/ssZ0T0N4K+5TgFqSmpoNdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M9SyAU2EoK2LLk3HIzbjizcSaEwrDqwWOCGA9wggEys=;
 b=e9UAcDUwHVjSPPiHwsCeiuEcwhxg5VQGj6NfTF0Bc2akU8qNM0tmioBCnJXrmUAlHL7qBv9sQ/yPd51IZ88/YUjTJYRNrp4aOqL6BaK9Id+ja80raCngu1twhz6LwKed4qrNyeJtcUdwnOfBznDGaD4glt/R1odvrIFWxgHB4RlxbvZu1FqlAZz201vVI7l2ZsZtFuGnJfPS4ywy4ak4n1pPzsSeMmF6C2z9PpDCDXnDposASqrwwZs3iIp0s/o0wl4YBvMoqeFtA11L14l+EpaTpZkkuEnoxlu48FUY4fLrafkyDXqzwh/ON+mO+mNh9UJVhk+/7jmFgNw74p1sIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M9SyAU2EoK2LLk3HIzbjizcSaEwrDqwWOCGA9wggEys=;
 b=xKgbEB6QcsrcJKb5JT1QOPfLR9o/CPj2qk6zFCkxkb0Om5SMWYoApBbETY12kLxwYnssuZ/DjQY9x1Zl01ONQK0Z6z0I9DwRoIAJOIgsODCUhbqD2gLT+bZYDDFAIaqfFW+JSmRuzLyNghZFxwnZXLVDfxjR75uViyjlBwLn0js=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH7PR10MB6203.namprd10.prod.outlook.com (2603:10b6:510:1f1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.29; Fri, 10 Nov
 2023 00:01:38 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.6954.029; Fri, 10 Nov 2023
 00:01:35 +0000
Message-ID: <4a0296d4-e4c6-9b90-d805-04284ad1af9f@oracle.com>
Date: Thu, 9 Nov 2023 16:01:30 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.1
Subject: Re: KVM: x86/vPMU/AMD: Can we detect PMU is off for a VM?
To: "Denis V. Lunev" <den@virtuozzo.com>, Jim Mattson <jmattson@google.com>,
        Konstantin Khorenko <khorenko@virtuozzo.com>
Cc: Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H . Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20231109180646.2963718-1-khorenko@virtuozzo.com>
 <be70080d-fe76-4bd1-87b9-131eca8c7af1@virtuozzo.com>
 <CALMp9eSg=DZrFcq1ERGMeoEngFLRFtmnQN6t-noFT8T596NAYA@mail.gmail.com>
 <09116ed9-3409-4fbf-9c4f-7a94d8f620aa@virtuozzo.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <09116ed9-3409-4fbf-9c4f-7a94d8f620aa@virtuozzo.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR03CA0015.namprd03.prod.outlook.com
 (2603:10b6:208:32b::20) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH7PR10MB6203:EE_
X-MS-Office365-Filtering-Correlation-Id: 69dd80ff-a5fe-43fb-2fb6-08dbe1803465
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	wO2GPB9uj/1YRyzQA+HqNj8pHuHDn+GC7jpwVHsHPWRAIKTBYsgsYcTcRQgmJGgys0rZ35oRJ0U7sAntICOulhDFen8qjxIAbVJoAP3S2+EoF0Q32jeXMdNMlWZd5LOzIH+Qrc0HvuQTFL9hWUbwBthWk3BHis6xQuR0OW8FHUt/Dy9RS9s8a3072TgLffsG6cq3g/frVb50XYodOQCcr/KqXThFBcduq1qL4RkTP3OnD5vxbGLTYWySBmFmpDiSGGMINy4Dm5vtpgpjj9lTbXe98RBF7WRxv7nf3XQvo4n3wT2rQnFDtsAm4ThRK+V2neNge51Es+Li8BZAef0g5/z8SC+UD/MSp67UnWiklT8WZRENmKBcnvsrwkz/EWzGPEr4Rm8jAwgYkLgibAf3w+wBVLE7dvBR4361Sn8pMUoRM4ZCdE80lQ/Aul8r6QG12hC5ulozEaMtsdWHzSpRN/wO6F6whhD2ICU2jW109zbxQj2ONTKlh8kt1YcXnoYBPNv4s43mUBcEWYQZOA5ogiGfzcckrSdw0BPMwlBfDrZUhL1veNg06q8vLgWpqSsSWWDTdzWWoSYkJOigWfJyijQkx4/FNWxtd/RNHzRZlU25txiIGeYO5W1yawpxSwt8LOtzzzsze5GJ0o3BTi9fNQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(366004)(346002)(136003)(396003)(230922051799003)(64100799003)(186009)(1800799009)(451199024)(31696002)(38100700002)(44832011)(966005)(6486002)(6512007)(6506007)(478600001)(86362001)(53546011)(316002)(66946007)(36756003)(54906003)(8676002)(66476007)(4326008)(8936002)(66556008)(31686004)(5660300002)(41300700001)(2906002)(7416002)(83380400001)(110136005)(26005)(2616005)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?VXlVRk04MmYvUHlabXZGY3BhRm55Q0toUlJBVTI0MUFTVlVKcTRvV0RxTXFi?=
 =?utf-8?B?STY5ejZRS2tHdkdqRW8rem9ZSXY1RzRsZ3RTb0FVSk1FVHlueWY0WDdoQ1I4?=
 =?utf-8?B?RSt2eTlKbVpBMWNzSmprTGhFTHhoRE9sSmpyUEd2RDNQdXlEcm8ydXJyRHJI?=
 =?utf-8?B?VHV0OXR5ZW1NOFJXVTlNbUtBZUZOTFB2VmtHU0cwTXI4RkpJOXgzdEo0dTU0?=
 =?utf-8?B?Rjg0b1Y2L3lrWTdJeWtOejg2dXNXa21CV3BLWFd4Z3JsTnVLSE9hMmd6UjA1?=
 =?utf-8?B?N01pSTdOM08yWTZoaWhIQkNwbEc1MWQ5QTQyZlZtYVRibWhsaVhHaEdub2ds?=
 =?utf-8?B?MUNKMDh3NndKbjFIcnNrUFhzVzlTSHFWLzdXb3FVWXA5dGpxUG9ZTjJ0Ulow?=
 =?utf-8?B?QUgxN2hsSmxZOStoU2F0a0V3eEZQN1FSSU5EREIrM2pQdmkzZTVIdytPYnJ6?=
 =?utf-8?B?Uk9mNHNTaC9EWEFpL2lyRXF3YWJJNnNHc2dqQXB6RGpaSEIvc09LTHJOSEhG?=
 =?utf-8?B?UkIycmpNdGY5QUprei9jNE1IRHBUT21QN1JmOVRsOXpIQm5Rc1NaRlZVNnRp?=
 =?utf-8?B?M2dnNWQ0WTBvZkNTc0Q1dWJKc0NNT3dPT09LTCtwRXhYMGVqbGk5WDR0Q3BL?=
 =?utf-8?B?STd5RjRCNkdvTFdEczlKYnhXZWNWdGpWS1AyclUxeW5lT3YxK0dFYnY2TDY4?=
 =?utf-8?B?US83aWJkZzNOWWNBVUtCdXRhMGZZSWtzS2VTVHBOQi9OLzk1NXFnOGZ4c1Br?=
 =?utf-8?B?bzVqSnhPZ1VNK3JibjZLQlN4REk3QXl0d2FOc0U5SXdGUTAvVVRMS095dzFZ?=
 =?utf-8?B?QjU4SjRoamhmNEJ3eXF1M2lJUk1CUVJLbnZjS3Z6NnZLTGFOVnpRa3N0QjBT?=
 =?utf-8?B?bE1qK1g1bUxOdWtHK0x2NXJoQUJDMkMwM3VUL2ZaLzVQcXNXV2VRaUdEdzFM?=
 =?utf-8?B?VUJKTEJFL1BIWnpRUUUydFNVZkhQeVd0K1VPR0RraTBNZ2duUE1LNCtxS0J5?=
 =?utf-8?B?Wnl4T0dVWXQzUW1xc0VWTUY4b05uaVJoSXhpQXFPTElSRnlpTzhzNExVZTNn?=
 =?utf-8?B?NndyZEpwSGZzNkJ1QjRveElEUkJiS3VTZDhZdWtQME96NFQxdFlka1RucFQz?=
 =?utf-8?B?OGNiSDB3eC9ZaUtQcEhSOExrWGdDMTVadTQvbEp6TzU4UEZ1MUFTSXlqUHk5?=
 =?utf-8?B?UkRuLzUwRGhHSks2T1JHaFgwZFpvdEtZbTZnRENMdk9BRHZibGZhRmVLUVhZ?=
 =?utf-8?B?T0tIVVpWRXJoVW8wZkRaazl5c1k3UC9pZmszS0lsUjFxTzk5aXpKenVBMXY2?=
 =?utf-8?B?b3FoTGYrallLU21Kdlp2RGhiY1Izd2hvdGE4TDFBbmxDeHVVL2xkVWxCNkND?=
 =?utf-8?B?NEEwNklPOE5lS2lVN2F2VCtRZjdheEJPaXZ5UWdZUUFuKzNGTEJUOUdwdmFZ?=
 =?utf-8?B?RngvV3dVSElYQi9MblI3dVpvblc0ZXE2YlAwZjlKRytvbWgvM3l3TDlobm54?=
 =?utf-8?B?aGo0aWdVOGRLVHVQRCs4Z1F2MXhKOTZRT2FFVFFPWnNvWDRMUWRtUmx2anVj?=
 =?utf-8?B?Syt3alpTZ2pvRURITlF3bG1NZzQ1d01HeFZyUUxwSmUzY0R6b0tuejZYeWlL?=
 =?utf-8?B?VnFhdmg0Nmc2RmdKYk9BS3hQRUhRazFMYnZ2ZGhMNDg1RlVPRnQwMDRsY1VH?=
 =?utf-8?B?Z2R3S2g4U1BsVVBFcUw3ZTlUWGdmajM2azVJWEYxSW5lM0hjZldxelJzSTZa?=
 =?utf-8?B?TnV4TFdzbVJDd2dZRnJYb2ZLdHNoWTBHR08wUFFCbjhFb000Zkl3cWorNlNU?=
 =?utf-8?B?K0RRZ1laS3E3WTVNZHArMWQrTmlNaDFsalJtVTVyOEY3aFZYK2FoaGxabCt5?=
 =?utf-8?B?dHV1RUFBWHpQK2JSTmtld1gvZXE2eVh0ejFpTGZ1TnNNdlpMOVl1TTN4eS9G?=
 =?utf-8?B?Tk9IdzlnMVMwSWxFTDFYTExwQXZlN1drY2llL2tzQkdZQ3hoVUVuQXZ3ZUpz?=
 =?utf-8?B?dEwvdnpsOTcyQmhBR1lUdk5rZ1hEdFd6T3ppcUo0aXZzYUxCMDNCOTNHbmlL?=
 =?utf-8?B?OTRuUUdYMnk3L29LVE4wc1Q5Z3BGT09kU1M4RmR2Nm5TcWFrOHB3Qkh2K1FE?=
 =?utf-8?Q?Z7CYxaAbRVWByt+xa6iq9fsNx?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?MUFDNkVmeTZPTEc1T2o1OHRHbXpWWkk4akZVQzUydG4xMFh1Zkd5MmM1QUFI?=
 =?utf-8?B?SWpPMUZpRVpwUzc0MnRJeHB3WFJQd2dzelhnS0JWTVNwNE1xSHpWTEdkOGRB?=
 =?utf-8?B?eEN1Nlh0YjZ3OUZhcWVnaDFiRy9KbmlLYVZwOHNTUHBrajdpUHovTldlOEIw?=
 =?utf-8?B?L21ibm00MmpYWkdDZ0FRMWtVWk9kT2FSQlB6WnJyaUp2NTBpckZjQTFVWkZH?=
 =?utf-8?B?RnByeVg2QktVNkluMHpVaWw3VXJTaGJvWkU2amJjUVdTTURnQitSTitiaGw1?=
 =?utf-8?B?YmFPbVlKeGxkTURWODlFTS9BOVV2WGJVVDl2YnhKcWxpY1VRaUdBTW1tU3Fo?=
 =?utf-8?B?clg2SDF3dEtTYUVkWVBzOHhRNXpMUGhUSjgvWEVnUTNOL0ZSd0o1OFpYa1R0?=
 =?utf-8?B?NjRYa2Fkd2QzakhuSmNKb0twYjdoZ3loVDdVa1BrMjAwa3lJNU9aTUhGbWxq?=
 =?utf-8?B?OGdpUW1rRWV3QTYzeWxKcCswSGNTWjl5eTIvZ3VOMmF6eHdqTTFMYng3OUFC?=
 =?utf-8?B?TUxRVGIzblV2OFovbTR6Yk4yKy9aVkFhek9wOEhhaUxscW1xWkpDcUlCYTVy?=
 =?utf-8?B?aG1JSEJRMXhGd0FBc1dXYUNId2djK2tJaFNwWUlCdnlhZGt2WWNRVGRnVGY0?=
 =?utf-8?B?YjhEZm5UeDdEYVNOMm9aOWVJNzNoNTVlZlUwU2pNYVJKWlFyb2dXNGFQVnVN?=
 =?utf-8?B?MTlsNlIydXpDY0syS2lBdUV1bEZBRlFRQmhuM29xSE1KYkJBN2xFUDQxUis5?=
 =?utf-8?B?QllqSTRzRDVIZ0FiLzdBTisyeFZrSmtMaFA5QUtmU0VpblltU3NtYkwzSGVt?=
 =?utf-8?B?WU1iM1pjaUpsQktIUVgxb3U0MGFwTjAvOXk3bjU3cWUyQnpQTWpqMndJdUts?=
 =?utf-8?B?WUk4dWFNZFdPeXNIYjhwRS9nZXZ0Rzl3UVhiU3A0cFdYeXBxOWlPdGxSZWU0?=
 =?utf-8?B?K3Q4QlY5MU1iVDFwUjRqQXpudklFRVViZ3JJTTBJVjBNeitsdmo1Y0tYOE50?=
 =?utf-8?B?VVNjTC9zZ3preXpiaEs1R3FwaDM0NVRGTU1ZbjM5WU9FZndqRzAvcWswUnRs?=
 =?utf-8?B?TWtJV3h1VTAxUWNPbmUxaUdaSmRGcFJHdWkrV1pzanl0YjRqbDNhYzcrREx2?=
 =?utf-8?B?eWdnWWNna2RoTlNSUkJuN1RuN1Mvd0RkY2lIZTh6MVRRU1ZNeDM1aTYyKzBG?=
 =?utf-8?B?MjNaRXZ6QWxlSittenNZNGVkSHRKUnEraVNtbDRTZkUzQUdVSERFdFpreUJv?=
 =?utf-8?B?ZUdrclRoWTE5YXJmRWptbHgyZ2g2cTVWM1hadkNkaGhmWDdRVE5DbDJRSGdV?=
 =?utf-8?B?Yy9ubmN5R2x5cTFWajlqcFh4aURIN0trWDNnd01URUwySmtNandaSGRDenJx?=
 =?utf-8?B?UVBZeC9HQjJ3cVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69dd80ff-a5fe-43fb-2fb6-08dbe1803465
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2023 00:01:35.5945
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dccM/6YH2tFbwts/SLDbRcE2ECGKT1xNFPgNOJJSK3a9g0dkP7sq0WEZtq8ofcY4Ig7GROI06eLWlrJIhCNeOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6203
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-09_17,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311090177
X-Proofpoint-GUID: 686w3UjCO5QhA5DHqHNFUwp8Ul43E-xG
X-Proofpoint-ORIG-GUID: 686w3UjCO5QhA5DHqHNFUwp8Ul43E-xG



On 11/9/23 3:46 PM, Denis V. Lunev wrote:
> On 11/9/23 23:52, Jim Mattson wrote:
>> On Thu, Nov 9, 2023 at 10:18 AM Konstantin Khorenko
>> <khorenko@virtuozzo.com> wrote:
>>> Hi All,
>>>
>>> as a followup for my patch: i have noticed that
>>> currently Intel kernel code provides an ability to detect if PMU is totally
>>> disabled for a VM
>>> (pmu->version == 0 in this case), but for AMD code pmu->version is never 0,
>>> no matter if PMU is enabled or disabled for a VM (i mean <pmu state='off'/>
>>> in the VM config which
>>> results in "-cpu pmu=off" qemu option).
>>>
>>> So the question is - is it possible to enhance the code for AMD to also honor
>>> PMU VM setting or it is
>>> impossible by design?
>> The AMD architectural specification prior to AMD PMU v2 does not allow
>> one to describe a CPU (via CPUID or MSRs) that has fewer than 4
>> general purpose PMU counters. While AMD PMU v2 does allow one to
>> describe such a CPU, legacy software that knows nothing of AMD PMU v2
>> can expect four counters regardless.
>>
>> Having said that, KVM does provide a per-VM capability for disabling
>> the virtual PMU: KVM_CAP_PMU_CAPABILITY(KVM_PMU_CAP_DISABLE). See
>> section 8.35 in Documentation/virt/kvm/api.rst.
> But this means in particular that QEMU should immediately
> use this KVM_PMU_CAP_DISABLE if this capability is supported and PMU=off. I am
> not seeing this code thus I believe that we have missed this. I think that this
> change worth adding. We will measure the impact :-) Den
> 

I used to have a patch to use KVM_PMU_CAP_DISABLE in QEMU, but that did not draw
many developers' attention.

https://lore.kernel.org/qemu-devel/20230621013821.6874-2-dongli.zhang@oracle.com/

It is time to first re-send that again.

Dongli Zhang

