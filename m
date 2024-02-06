Return-Path: <kvm+bounces-8076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDCEE84AE48
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 07:02:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94A2C284EA3
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 06:02:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFCDC83A0A;
	Tue,  6 Feb 2024 06:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="C1Tzy74o";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sKCDqHVh"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2A482D9D;
	Tue,  6 Feb 2024 06:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707199346; cv=fail; b=UXYiXUt3L/5rO0/pnFPvx854myjz7VxMCJkF9yFToQz85jqElMkioX3QtTQ1CYF4pNJzwqgwjqA3U58f0ajRXW4UnJGiCBa2qfvEnpRxITON5cnsMOUPwDln9mYr2l1rlq8lsHR0sBwyrOq5JDsULCUxj3/21tZ5qaPHxzOOvCA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707199346; c=relaxed/simple;
	bh=Gwe66q219vL7F86KaQ4R8bboLT34X9mR4eYnCaSPidM=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=d+A2MZgs4GHCK30s8bkm17ox8ieQSr6T404LBHe+lbmg23KtmO+0kc0+a7/moq5lEhy7KgHhatAL35BAPzlZS1RA9geEH2NIfqbWTyAxoIOmUp0YRa4eSk0c89iC3bRkIrKx/gC2neiQNC4J11rZ/O1pV4J+oyDt/3UufIKIQro=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=C1Tzy74o; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sKCDqHVh; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4161F0Xm032223;
	Tue, 6 Feb 2024 06:02:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=2kbQt8ovyBn4K3hO6UcKOU3qc2Bi8KVWJL33V2Q0JsE=;
 b=C1Tzy74oJ3+cY2A47eFenShhcKIoHuHEg5Q7NxAoEaUmWYZrqz8WFHLvltcrAd9BP1sL
 uBr+te9jTVq+VWVSB30Iuge2OS8vcjvid+cWJlWNMF0GXqRM1GqW2cz8Yt19D3wVu4cJ
 HjKpPofAy9vYuDYi2zHlANFKnj3rprqmIC0iaa3m06+jM22lP+bf1y0OtZAWiXJMhOKE
 Ie3xlUcfJvZGcgvZVm7on4/nMUQkMbfGtCh2s0j7CFchkQOtEJ16ePxD6uDwXyx6PzFM
 6LkACZKFGwCciWJIbai86ekuHTt5HFpQSIt1evHXkzKfXdR2F2VHbS9TqUA783t1RvzX IA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1dcbdrjp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 06:02:17 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4164ngHg039515;
	Tue, 6 Feb 2024 06:02:16 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2040.outbound.protection.outlook.com [104.47.51.40])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6jkdh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 06:02:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AATbcNOLaWxQTZHSblLTOth6iuLjQ+wrcbyz4vl0PmMAo61Sf1f34nJCCRrPU2zfJLuT9m+DgmAzCSJAsc0aorsMS9JSpxpCXa1qFJD0PYyY7853RQW/6523g/88kr1ieqdwgIKAxj4VW0wmGInq37Oj4qZNOle0QY3NltYSzi3kpzhD6h1UMvvazAwIjNTSfsBdv/+uANtvGpMHDX5iaBLAM3dX23Y2lkJqsiyuSJqaj9kJtPSYDPXgImdgg6YB5VAQzqn71fQ6QL15B8xa4ArzzGswh8pphD1bMavQwQtfpa9V5p8FeWjJ2fBDbhrbwwbPOnwxCygyoNeCaIf+WA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2kbQt8ovyBn4K3hO6UcKOU3qc2Bi8KVWJL33V2Q0JsE=;
 b=Tu0y/ORl5UYm1EwbMR5x5AMD1DZqF269m+dxxnQFLw/1L/JaRjuJ+vBiddARR0ouqGSIG0Fb4p2HJLuI0TKO35NIJ2s+rwumQQ37kaVTlEYNkQvsYiBGfCs6tzCUApZWJFpP3x23JfKZO5E2xmIcl4GSZg3qalWabjksZzwTM+P90M7Ut1dhFz0IJHoJ2z9agucHFBRJ8ufhV+uijsul8rCwUFSd1V3Wm96o7HPy+zGglRE7Dbrq/Yu4yUyYggWSxpJktS1NUjxykl3F7QiSZ6mVDUGeeNDhyoUmTALDiNuPpLEN2+loJT+LG3c0PpYqyJOCIGr4a6vo9NKXB7lGOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2kbQt8ovyBn4K3hO6UcKOU3qc2Bi8KVWJL33V2Q0JsE=;
 b=sKCDqHVhN1b7RFfqZtmygb/IJzjyKJgVXz7EbXNuH+QDBWt4bA8E9hZsyfm9atPOoA7pM2KPUnCJES+C+Qc7PLfYNh+vUduMVHAPSr8rm//UhpyZD+mqMwuHAUuEfE7t9AbzHzzUqK6ojis76Mg4AvXmL/mz4ttyuPHXpg9g6/w=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by PH8PR10MB6550.namprd10.prod.outlook.com (2603:10b6:510:226::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7249.36; Tue, 6 Feb
 2024 06:02:14 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::a1c5:b1ad:2955:e7a6%5]) with mapi id 15.20.7249.035; Tue, 6 Feb 2024
 06:02:13 +0000
Message-ID: <8532df8e-23ef-0b89-334c-d5697a78ba84@oracle.com>
Date: Mon, 5 Feb 2024 22:02:16 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: selftests: Fix a semaphore imbalance in the dirty
 ring logging test
To: Shaoqin Huang <shahuang@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20240202231831.354848-1-seanjc@google.com>
 <17eefa60-cf30-4830-943e-793a63d4e6f1@redhat.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <17eefa60-cf30-4830-943e-793a63d4e6f1@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BY5PR20CA0026.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::39) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|PH8PR10MB6550:EE_
X-MS-Office365-Filtering-Correlation-Id: ce547167-9363-4c81-6c60-08dc26d92a13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	PkrIis+KAg7DtRj/LKP/8WUAh+hSmYIWZlqfPQBSuvRX0PEkpPU1LlyF+m8qRipQ0IRCAqVFoilPJy+B4s0gC6MRGlQemJKz3N/cWW8GOwdMdA52ekE3Savx9/ZyJwjShMgPhm0N1AueeYh67HOKHVWapuJodOGHfTFkasII+RGHKikyzKEReLFtjLxt5cD7lGlP6clFpWMwWSxz+WQ2osif9aiVeyx0n0cD9dcQT8d+Doic9poJ1HjPJdGG4d9LxTioLX6rYjJKqGM+tpKAZ8gN9HaGwsSJI9Nk9jYji8Tck8d+vZPUKpIQ9rOy2r4bF3FC9anma7ZGbwGnwEXAVkykfXn9OfKFlogzAqltH5v0FIcZnInkwHjrXPueLAy0oP+Hb2J6xp3+Xm+iR4+E8xdQe1DzsyU8yT7u3jstHSGbBwOfIa4ElW/H64PyukZ5gphJIbiXOYDG683al/1URLGh89Oz1SFPJtgMcWY117WHxRpGSoDLtMsqt1fXCg+DkWjIoyk2Tf2bDAOeV1J6pIJsCB41bwzvZy92fGbxrIy68HB6eHczjxQ0Y5zQ5W7AYbbvBcipfHT/FoYYacewsFxudbbD9MYGsPGAcFC9EkG+I7gRGyKPjJDjD/LoORtu6LT1wyv9C7MkHrOIPb/BJQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366004)(39860400002)(346002)(396003)(136003)(376002)(230922051799003)(186009)(451199024)(64100799003)(1800799012)(31686004)(38100700002)(44832011)(83380400001)(26005)(2616005)(6486002)(31696002)(86362001)(6506007)(478600001)(6512007)(53546011)(54906003)(36756003)(316002)(6916009)(8676002)(66476007)(41300700001)(66946007)(66556008)(4326008)(2906002)(8936002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?K2VscWZJSDh2RFJGZW11WEZ0NHl2dys5b0lKRXc2elhCcHBySHJQN1BOUEt3?=
 =?utf-8?B?bkdCb2I3azdVREFwbWI5SGhYZUp0dFB4SjRCQm9vQlRudkJXa0p2OGNMd2Jp?=
 =?utf-8?B?MUpkYUF4WFE1UUZVQWhBNU85UmNWZjRzRVo2UXY4SGlyR1BpQlloOUdBUWY5?=
 =?utf-8?B?Sk9vT2lKeGlPUFNaQS9ET3MyRWxnZHlEcGtNdlBITTJqSW00UHZ1NS9SQVRP?=
 =?utf-8?B?OXl0bmZzNGNyZ3BVWnl4WWt2eEtualdZdkMxakpmWjlHalVGL0RZUWJaNStl?=
 =?utf-8?B?aTgvR1NpUkIzL3h2YUw1NWNFb0o2Tk1HOHNDVzdSSmdOdW5QSW4xNEsybzY5?=
 =?utf-8?B?WHBLRUJkQUtrTXFtNGs2amMyTFpoazNqY0NoU2xYZS9KM1pkWmZ6RENoTk8r?=
 =?utf-8?B?eWZabGJvT2x5QjJRR2JKWXNkWEZveHdwK01NYW5pdE9WMUJ5Mk9COVlKLzJr?=
 =?utf-8?B?MG1mcVZOakRpYlA1R3BpT2tvUk5kVCtoSEtSRHFBZ0p6WHMyZU9HcHBOWUdl?=
 =?utf-8?B?V0JNRllHMjRTZEh3dE1VaWs0N1c1T2FVR0RRT2tKY2dXQUg2a3F3ZlhOaEQy?=
 =?utf-8?B?K1hFK0NnOUpOY2t1a3g3MkpuRU9ZaGlRRUV6TGx1VW12YTQrYnVtdW5PNnVW?=
 =?utf-8?B?U0ZpREh0T2hySnZycGlNcjFNQ1dFekE0c1cwUDAxc29sTmFQazRyVE9GeFNo?=
 =?utf-8?B?WUl0RnFIYWpsS05zaEVHYThkNENqaVh1bzd6OExZN2RTaUZVSWFFUjlJUmp4?=
 =?utf-8?B?L0xVYmFWWlNjUTVWMk5EZWtYdnYxUzFKd1dQeFAwdXkyVUpXeXcraUhFMFBh?=
 =?utf-8?B?UlljU2s5UFdCZnZOa3Q2ZkppL0N1SDBlTzJnYXVHSVFCbGRjc29rbkE3SkdW?=
 =?utf-8?B?Sm5XcHN2S2RKODcrZ1hqQXFLQUUxYWZPNGhnN1NwS0VHYUJ4TTQ0Y3c5Qnlx?=
 =?utf-8?B?TFVlY1Y4ZFdGa0VFUzFyeTRqU2Nac3dnTmliTnI2VUdpUjFNcjl0VGFVdlcy?=
 =?utf-8?B?dHdFY0lPQzhMM1lzaFNZU01ObEJYcGs5aDl2Y05NZHN2d3F2TGxvVkNGZTUw?=
 =?utf-8?B?UWlFdlBJUGxKRnVDUmhXM1I2NWl0cTdvOUdpQ0g1cE44eGxDK1Ezb2lsODNH?=
 =?utf-8?B?cTVoZk9iaEt2eVc3ZkpJc3ZEb002VVd6YWlTaDJ5VDF3TDZaOTFqcko4UVds?=
 =?utf-8?B?Q1FuY0pSSitwQnJVUjFvcERnZVBDaHdia2daZlA5WmJGbGtRYURGZ1psaC9z?=
 =?utf-8?B?N1Nhby9xWGZDM3czRUhnTU1FdkloNTdwUjJ0bytHRGEyRzFPTUFJR3BDcnBu?=
 =?utf-8?B?RjhZMVg1bkVzSkh3M2U1UllnVENsZTU2Um0xWjRyWnE2d1Bvbll5bWdTUEJC?=
 =?utf-8?B?a08wWnpzK3lnZ1U2ZEZWMks4eVFiUHpMTGJoM3o4SFhocVZJaEVGZExaaStG?=
 =?utf-8?B?QzFyUm9NazZBdWFWTG1BNTNUK0VFbUthc3JpOE01VnNJTU1nUWhrTkRDbm9s?=
 =?utf-8?B?V0x4VHRYWTVieTdadE9YOFRNaDJGc0I0TVVydkc4Uk9SS1lYa0dOamhraWxk?=
 =?utf-8?B?QTFRUTEwcjlOanVVekhVYW5oMDhRNEhKTEZJSzMwSkJlOU1BWW1JZVVTc2Zo?=
 =?utf-8?B?cmdIekVkdWcxWWtCcnZMMUQrcVEvZ1FNb0hIM1lLTjZxZ2xseFdLenV4YXJP?=
 =?utf-8?B?Zlo5YXExS0Z0QURveVRYOWZyZUVMY1lRYjZUMEhVOWxRdTN2T2NHRTBFQXVH?=
 =?utf-8?B?WUdMUE5VTi8veFZHQWl2c0wzRUg3cTg1VHN2TDg0THpsQzlSM24ySU5QR1Fu?=
 =?utf-8?B?alQ5MnJDOE5ybDJhdzF3M1hzdERwV0ZOSlhMNC9VZG1jZjdnRk4zLzhNV3hI?=
 =?utf-8?B?R0NHcnkvcDZkampiNGFLb0MwcC8xemFxalVKQW9uREV5VXhQc1B0RXVZVy9h?=
 =?utf-8?B?dE9iV3hsTEIvZy9zTy9nbGRYVFZzSjJhYjI1ek5Zb0s0ZWphOWxrdFdrakdM?=
 =?utf-8?B?Y2RZTmdVQ2hweTE2MWN5K1A1U3hkMTN5dnJWZ1BjV1pmNlJtRXNBRVlNcjlT?=
 =?utf-8?B?Ykp6cGt3TjlITm1zMUU4ZGRrb05XT2FaV01VdHgvT1ptNjlPM1VhRkNxOFIr?=
 =?utf-8?B?UkxhYUg3Y01wTFFzSTU5MlcvMDBQdVhuNGxpS1pJemZ0Q2NUbU9GSFJYNXFC?=
 =?utf-8?B?V3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	OsAQP0ZoNBVYO5/QaHSQdl9a097Tb3fFPHxYJXD7O/MRILVEusWnx+kubKgtCblTEPYlkNRFhHEM/yu/8P71zAhi/7Nw/fpudckxQ+hwwWd6opm2syDK+72ErbTy/BmrgIzyzboo4PaG738v3gJloThRFWadMSqirJZG/6LXWmbEXdmO5eKRInnx7AHjmFI6VU92FhsZZ9pXy3P/DvQCISSwNcL4LByleRcLBbXCUgA9r6+qsCI24CKaKIE984mKjl0gPqKWqxsc/3OFiZqovkwXv4DskkvQzfzMQqJmQvmUXcAMdbJ6qNcbVg9Mqt1D3xNAhTfZeWeqSTkMTV33rOD7AQ+9LigreTYmReCUjcS46vlkInVIR8dgzHOZQmRQG+1GjrWkTlLnTxVcOfgNTQhVTK3rHlsETcUke1Hs4TyshXJ8zkP1/dc8Y9LWuYoabHwSz1crkYjyP7Q5gFBbmhmRrlq04xyiuUqWI9YWm0Op5P441vBNSLIb5tS9Kr1wxCRX5mylC6zniX13EnEz3/yQrAuTB3pSCFfxCm8M6qgvTCWQQWuJiw7aiFr+S6ukpNdQmOH5muQwnSYF8TT/B1vyxJ8SQbOPvqx5670YP7A=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce547167-9363-4c81-6c60-08dc26d92a13
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Feb 2024 06:02:13.6991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n9Pmf2vDOe81Gpho0Fnm7kLW5sreSwtmkIG9stqeNjYe6iCzMmxdsqNVGRPV70FcLRNdZ0rufoT53KnwNkMlHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6550
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-05_18,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=964 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402060040
X-Proofpoint-GUID: r7pf3eDO0Auc1UaIL35OabTKI3usHaDO
X-Proofpoint-ORIG-GUID: r7pf3eDO0Auc1UaIL35OabTKI3usHaDO

Perhaps this issue is more difficult to reproduce on x86 than on arm.

I cannot reproduce on x86.

I tried to emulate the extra guest mode on x86 by running the same code again.
Unfortunately, I cannot reproduce after several runs.

@@ -940,6 +946,11 @@ int main(int argc, char *argv[])
                        host_log_mode = i;
                        for_each_guest_mode(run_test, &p);
                }
+               for (i = 0; i < LOG_MODE_NUM; i++) {
+                       pr_info("Testing Log Mode '%s'\n", log_modes[i].name);
+                       host_log_mode = i;
+                       for_each_guest_mode(run_test, &p);
+               }
        } else {
                host_log_mode = host_log_mode_option;
                for_each_guest_mode(run_test, &p);



The good thing is, the below is able to detect non-zero sem.

@@ -719,6 +719,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
        struct kvm_vm *vm;
        unsigned long *bmap;
        uint32_t ring_buf_idx = 0;
+       int sem_val;

        if (!log_mode_supported()) {
                print_skip("Log mode '%s' not supported",
@@ -794,6 +795,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
        host_track_next_count = 0;
        WRITE_ONCE(dirty_ring_vcpu_ring_full, false);

+       sem_getvalue(&sem_vcpu_stop, &sem_val);
+       TEST_ASSERT_EQ(sem_val, 0);
+       sem_getvalue(&sem_vcpu_cont, &sem_val);
+       TEST_ASSERT_EQ(sem_val, 0);
+
        pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);

        while (iteration < p->iterations) {


Thank you very much!

Dongli Zhang

On 2/3/24 20:22, Shaoqin Huang wrote:
> Hi Sean,
> 
> Thanks for your better solution to fix this issue, I've tested your patch, it
> actually fix the problem I encounter. Thanks.
> 
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> 
> On 2/3/24 07:18, Sean Christopherson wrote:
>> When finishing the final iteration of dirty_log_test testcase, set
>> host_quit _before_ the final "continue" so that the vCPU worker doesn't
>> run an extra iteration, and delete the hack-a-fix of an extra "continue"
>> from the dirty ring testcase.  This fixes a bug where the extra post to
>> sem_vcpu_cont may not be consumed, which results in failures in subsequent
>> runs of the testcases.  The bug likely was missed during development as
>> x86 supports only a single "guest mode", i.e. there aren't any subsequent
>> testcases after the dirty ring test, because for_each_guest_mode() only
>> runs a single iteration.
>>
>> For the regular dirty log testcases, letting the vCPU run one extra
>> iteration is a non-issue as the vCPU worker waits on sem_vcpu_cont if and
>> only if the worker is explicitly told to stop (vcpu_sync_stop_requested).
>> But for the dirty ring test, which needs to periodically stop the vCPU to
>> reap the dirty ring, letting the vCPU resume the guest _after_ the last
>> iteration means the vCPU will get stuck without an extra "continue".
>>
>> However, blindly firing off an post to sem_vcpu_cont isn't guaranteed to
>> be consumed, e.g. if the vCPU worker sees host_quit==true before resuming
>> the guest.  This results in a dangling sem_vcpu_cont, which leads to
>> subsequent iterations getting out of sync, as the vCPU worker will
>> continue on before the main task is ready for it to resume the guest,
>> leading to a variety of asserts, e.g.
>>
>>    ==== Test Assertion Failure ====
>>    dirty_log_test.c:384: dirty_ring_vcpu_ring_full
>>    pid=14854 tid=14854 errno=22 - Invalid argument
>>       1  0x00000000004033eb: dirty_ring_collect_dirty_pages at
>> dirty_log_test.c:384
>>       2  0x0000000000402d27: log_mode_collect_dirty_pages at dirty_log_test.c:505
>>       3   (inlined by) run_test at dirty_log_test.c:802
>>       4  0x0000000000403dc7: for_each_guest_mode at guest_modes.c:100
>>       5  0x0000000000401dff: main at dirty_log_test.c:941 (discriminator 3)
>>       6  0x0000ffff9be173c7: ?? ??:0
>>       7  0x0000ffff9be1749f: ?? ??:0
>>       8  0x000000000040206f: _start at ??:?
>>    Didn't continue vcpu even without ring full
>>
>> Alternatively, the test could simply reset the semaphores before each
>> testcase, but papering over hacks with more hacks usually ends in tears.
>>
>> Reported-by: Shaoqin Huang <shahuang@redhat.com>
>> Fixes: 84292e565951 ("KVM: selftests: Add dirty ring buffer test")
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>   tools/testing/selftests/kvm/dirty_log_test.c | 50 +++++++++++---------
>>   1 file changed, 27 insertions(+), 23 deletions(-)
>>
>> diff --git a/tools/testing/selftests/kvm/dirty_log_test.c
>> b/tools/testing/selftests/kvm/dirty_log_test.c
>> index babea97b31a4..eaad5b20854c 100644
>> --- a/tools/testing/selftests/kvm/dirty_log_test.c
>> +++ b/tools/testing/selftests/kvm/dirty_log_test.c
>> @@ -376,7 +376,10 @@ static void dirty_ring_collect_dirty_pages(struct
>> kvm_vcpu *vcpu, int slot,
>>         cleared = kvm_vm_reset_dirty_ring(vcpu->vm);
>>   -    /* Cleared pages should be the same as collected */
>> +    /*
>> +     * Cleared pages should be the same as collected, as KVM is supposed to
>> +     * clear only the entries that have been harvested.
>> +     */
>>       TEST_ASSERT(cleared == count, "Reset dirty pages (%u) mismatch "
>>               "with collected (%u)", cleared, count);
>>   @@ -415,12 +418,6 @@ static void dirty_ring_after_vcpu_run(struct kvm_vcpu
>> *vcpu, int ret, int err)
>>       }
>>   }
>>   -static void dirty_ring_before_vcpu_join(void)
>> -{
>> -    /* Kick another round of vcpu just to make sure it will quit */
>> -    sem_post(&sem_vcpu_cont);
>> -}
>> -
>>   struct log_mode {
>>       const char *name;
>>       /* Return true if this mode is supported, otherwise false */
>> @@ -433,7 +430,6 @@ struct log_mode {
>>                        uint32_t *ring_buf_idx);
>>       /* Hook to call when after each vcpu run */
>>       void (*after_vcpu_run)(struct kvm_vcpu *vcpu, int ret, int err);
>> -    void (*before_vcpu_join) (void);
>>   } log_modes[LOG_MODE_NUM] = {
>>       {
>>           .name = "dirty-log",
>> @@ -452,7 +448,6 @@ struct log_mode {
>>           .supported = dirty_ring_supported,
>>           .create_vm_done = dirty_ring_create_vm_done,
>>           .collect_dirty_pages = dirty_ring_collect_dirty_pages,
>> -        .before_vcpu_join = dirty_ring_before_vcpu_join,
>>           .after_vcpu_run = dirty_ring_after_vcpu_run,
>>       },
>>   };
>> @@ -513,14 +508,6 @@ static void log_mode_after_vcpu_run(struct kvm_vcpu
>> *vcpu, int ret, int err)
>>           mode->after_vcpu_run(vcpu, ret, err);
>>   }
>>   -static void log_mode_before_vcpu_join(void)
>> -{
>> -    struct log_mode *mode = &log_modes[host_log_mode];
>> -
>> -    if (mode->before_vcpu_join)
>> -        mode->before_vcpu_join();
>> -}
>> -
>>   static void generate_random_array(uint64_t *guest_array, uint64_t size)
>>   {
>>       uint64_t i;
>> @@ -719,6 +706,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>>       struct kvm_vm *vm;
>>       unsigned long *bmap;
>>       uint32_t ring_buf_idx = 0;
>> +    int sem_val;
>>         if (!log_mode_supported()) {
>>           print_skip("Log mode '%s' not supported",
>> @@ -788,12 +776,22 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>>       /* Start the iterations */
>>       iteration = 1;
>>       sync_global_to_guest(vm, iteration);
>> -    host_quit = false;
>> +    WRITE_ONCE(host_quit, false);
>>       host_dirty_count = 0;
>>       host_clear_count = 0;
>>       host_track_next_count = 0;
>>       WRITE_ONCE(dirty_ring_vcpu_ring_full, false);
>>   +    /*
>> +     * Ensure the previous iteration didn't leave a dangling semaphore, i.e.
>> +     * that the main task and vCPU worker were synchronized and completed
>> +     * verification of all iterations.
>> +     */
>> +    sem_getvalue(&sem_vcpu_stop, &sem_val);
>> +    TEST_ASSERT_EQ(sem_val, 0);
>> +    sem_getvalue(&sem_vcpu_cont, &sem_val);
>> +    TEST_ASSERT_EQ(sem_val, 0);
>> +
>>       pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);
>>         while (iteration < p->iterations) {
>> @@ -819,15 +817,21 @@ static void run_test(enum vm_guest_mode mode, void *arg)
>>           assert(host_log_mode == LOG_MODE_DIRTY_RING ||
>>                  atomic_read(&vcpu_sync_stop_requested) == false);
>>           vm_dirty_log_verify(mode, bmap);
>> +
>> +        /*
>> +         * Set host_quit before sem_vcpu_cont in the final iteration to
>> +         * ensure that the vCPU worker doesn't resume the guest.  As
>> +         * above, the dirty ring test may stop and wait even when not
>> +         * explicitly request to do so, i.e. would hang waiting for a
>> +         * "continue" if it's allowed to resume the guest.
>> +         */
>> +        if (++iteration == p->iterations)
>> +            WRITE_ONCE(host_quit, true);
>> +
>>           sem_post(&sem_vcpu_cont);
>> -
>> -        iteration++;
>>           sync_global_to_guest(vm, iteration);
>>       }
>>   -    /* Tell the vcpu thread to quit */
>> -    host_quit = true;
>> -    log_mode_before_vcpu_join();
>>       pthread_join(vcpu_thread, NULL);
>>         pr_info("Total bits checked: dirty (%"PRIu64"), clear (%"PRIu64"), "
>>
>> base-commit: d79e70e8cc9ee9b0901a93aef391929236ed0f39
> 

