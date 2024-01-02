Return-Path: <kvm+bounces-5460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F40682221E
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 20:36:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2059D284289
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 19:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0725515EBF;
	Tue,  2 Jan 2024 19:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K/tKB0T8";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BXRDrhBn"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5B115EA1
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 19:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 402Isneb023393;
	Tue, 2 Jan 2024 19:36:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=15+4QG7fkIxErRj2bpdOj8wOjqbjk5lftnhytcTe0aA=;
 b=K/tKB0T8CiTUgwyFe7R9Py0rv+V9kCMQyZgH4PxkYTLQ2LUJZq7QfsMtdS3CEZ4IDVl2
 OglaFkRay2yfKetC++kwxsuZH+7d8DZPHuR+Tw+AzI+YFFW9YMwnzC2bk9e7+6iX/sVR
 O3048G06LVZeATx3CF0g3TVTd0daTV8d404BTDqBNBK+prAXHEoIDNqn24aE/Wx6Eba+
 yaPkA0UiBIxrZt/+QdUu8UfsFP2EMd4MUOBf6SRmYv0Tb/IWVKztEg9fvVn5AarhR9Tl
 jNHIuyczsDTZAwKDLhgXcezauZ7oE7VRVUyWvjmbrExlRQfrBS6U3bDwUb2ZOHIE7sNE Ag== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3va9t23rnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jan 2024 19:36:08 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 402IGlFe001730;
	Tue, 2 Jan 2024 19:36:08 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3va9n7q3jr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jan 2024 19:36:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekwVltPQZHdnby//2OQrsPxw4GELuD6iai6QQW13BHxwXBPM8kKCsYjXfP6ivXCoFbZI8MYFGiBAWwE+j/KZVdZn7mlgvj8SNIZ9HH38BxZ/GNSuzuOiarEhB8RmBDdwrMWpHhbTinBYqtEFudWDGodcwfudUcqFCZg1WqWVeijoai1lBgmpCW5CwlBQx/IGb3Hxkx28M7RaKb2qSvIjVmBIt12v5BFx6kTbR+j/u4HrqTf/FybwvA43Ufq6ekU9GTmoYP+uhdjeGWEkp6HyPYxZXN6O33MoCS2ygjdGJF9PS/R+KNq3DpcRtZ1SQV6y0YoOk9xPNbISSNzQQisbhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=15+4QG7fkIxErRj2bpdOj8wOjqbjk5lftnhytcTe0aA=;
 b=Q8q4Q/C5KMtuwMoXKYeXmGDqytvBiQqKAXfJj5CRNXp+t0a+5/iVyF8cEI3O+dRVKmp7U85VPTuxZ8o56oIQHA1CpfFDFbJhDVg0D6kHjhobzsgoVZQ7BcRAbZO5buQk4+o0jnnj4WteViDBnm2dVSEI64P7/snF2UmFFtqmjIOO6tBqh3viqplzMFVMuChIWuvOTcZY+ZlBTvWReQDhRL3D3MjbpQ5NSKzjaBYLsjVq9xGlQ9RL2rGncT++u1MaDQCc0NOs/0TK8rNUBDAqJRmZlOHzicpoZ3ZmLzzen+PDCdh3uJIF0vfDiXKrx2YJakqjM6kxpMpIu0eKKreIhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=15+4QG7fkIxErRj2bpdOj8wOjqbjk5lftnhytcTe0aA=;
 b=BXRDrhBnPLWZ10/mOQehBL2Zdfar3CSasFPYnWWco8F1Otx/Y90hhYqmVL/xnW/MzPZOw9kUIglNI6ZCuJCB5oARh4zoYTX44SIud8wigPemfzrEOUzErdh+SBktw8svsXBX8+ccyIcHixIRTj1+gdAgMRLRqiftwjw8YWWrPvE=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB4976.namprd10.prod.outlook.com (2603:10b6:5:3a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Tue, 2 Jan
 2024 19:36:05 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.7135.023; Tue, 2 Jan 2024
 19:36:05 +0000
Message-ID: <90e29550-a48f-dd84-eac7-7c4b79569fac@oracle.com>
Date: Tue, 2 Jan 2024 11:36:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: obtain the timestamp counter of physical/host machine inside the
 VMs.
To: Tao Lyu <tao.lyu@epfl.ch>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>
References: <CAJGDS+Ez+NpVtaO5_NTdiwrnTTGFbevz+aDUyLMZk6ufie701Q@mail.gmail.com>
 <20240101220601.2828996-1-tao.lyu@epfl.ch>
 <f1535a39-4f3b-bae8-950e-9a0e5df46681@oracle.com>
 <a31d33cb6eb14ddda272b9d291c5ae00@epfl.ch> <ZZRNly2jIIVyC5F6@google.com>
 <b54287c7f2a8414dbe8497c0c97e1b90@epfl.ch>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <b54287c7f2a8414dbe8497c0c97e1b90@epfl.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: BL1PR13CA0376.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::21) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB4976:EE_
X-MS-Office365-Filtering-Correlation-Id: 85786a7d-b5f5-464b-7da6-08dc0bca0f83
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	BL3WN1EqoZqfc54CFknhZcOqrVx21GBUJF+3dYCOT9e3jnmLUrvF7B1YZkuzaGJgJepPOTkWY2V9aCDU/2u8FGC7LKCiBDW61v1jJC15Fw2t8CMvaFQnQhKfXAVVPc3JC/E/ex6RYLFygtmAHZX8EBNtuyXOXuXpitrIfEZNTBNqgVwRFZr5Dv+ylOkaZjRBe17TL1nT5yCDcilD2H5fZC07YFhuAdcq6msHcdoSgAVDf5+SyBTYDY2P2ap87svC3mLxLcQw7fP/gOnK5lipacnJx55iSjUjpWuGwBm3fOXzyCoNXGBnURqcdxZ26vtSzuVzabeEivTWHbVyTR858L31LVcOjNmFHrYnNxiVGR5M3rLqrn2zpBEUsvopDSXoDEu4MV5SCGOoCSK3uV9O1rjrOK7vaDbw0z4V3kHaMI6VFJRpu5eBEmzsZSo9Vh099FMmWlDffzETbr3wRQq7+fbfZw0O/YiMPjwT0YkKZgV1Q+8yr0rjSHix5jLyuzeWLxVwm6uWpxd+ZcoufCe+63xQ/3k3Es8CwyaQuz3lelA3Yr+OsfoqtQE/BgIMW2JqA85SvjgbX7IazB+4j/jcnjxZpCLt/8XaJ2tfT6yJl7UCs3h1cye0kgZTVFAJ+Ua4tNG4tyCY0DzlQVkonBg/fgqSvEOhCn4svtXZw7aDTqRUUvWTWia4VOK1USo67SmVtPyYPdbF6lBP5tG25tRO2g==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(376002)(396003)(366004)(39860400002)(136003)(230922051799003)(230273577357003)(230173577357003)(64100799003)(1800799012)(186009)(451199024)(36756003)(30864003)(38100700002)(5660300002)(44832011)(41300700001)(86362001)(2906002)(31696002)(66476007)(8676002)(45080400002)(26005)(4326008)(83380400001)(6916009)(53546011)(6506007)(6486002)(6666004)(478600001)(2616005)(8936002)(6512007)(54906003)(66946007)(316002)(66556008)(31686004)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?cDN4VzdlTWRlbVRWb0VkcU83dXNpY3NqY3FCRVFVUENPOXFDdkhWbkpNUDhv?=
 =?utf-8?B?L1ZxbEY1YmoveERUNXVyN3g4V0pzcUVmOU9Dd0lOdjN1bEJmVEtDbEZQWEJx?=
 =?utf-8?B?eU90QWVUdWhqSEQwL0tyODVKdXBHcVJnN2lQZFAySC9aTFlCZjQwUzdRUE94?=
 =?utf-8?B?MkNQYkR3U25jNDVzVS9MZHJMRDdDMVRVdnVZWHMyV1E2YTl5RzJyS25mYkdz?=
 =?utf-8?B?M2dRR3Y5L0sxS3hJVnBFOEZvUjhlbGNWckptTzZCZHd2cS90bWdYM2J2NEtP?=
 =?utf-8?B?VC9abEtvSUE2Q1pWUWkxQ0tqVmtGdDNoQXRQTkMzUXpZbUtVVWZzYWpQdGxz?=
 =?utf-8?B?VVg3ekkxU0NtTm9TaVRWOTh2Y3h6dGNJd2NvcHg5RnJJRCtkZjlOZ2dBTVJi?=
 =?utf-8?B?b3c3UEVweDVFTkFxa3FXOUJzbHNRS3hDUVBmbUVieFNqRWZFMGdSaFR3UHRX?=
 =?utf-8?B?UmNqc2JTZUNqK3pRREhmZDFBYjg4akRUdEkrdmR6VHhkejFUenlQQjlsQ2lF?=
 =?utf-8?B?dWhNRzl4YkIxMVFmL21KZ3hzMEUwUDBmQmQwbnpodDBGeFNTZXE1bkRuSmRa?=
 =?utf-8?B?ZWt0L25xYjZhdm1EK1VVcEhuRlpNd29ITXdSV2VUM0VYVEVmNE5qK3p3TEVI?=
 =?utf-8?B?K1lzTnNzMUZBQU0yUytZdmZFd0lNaGZXS2Zyc2JscmFYeE1XeldFU1F3L1pa?=
 =?utf-8?B?TFJpV3hCSi84TnNIYVdGdWRJemwzOTdVWlBsWDd3NHV3d042NU53ZjRQMWtS?=
 =?utf-8?B?YjFMaW5xWmhIWWhKS0MvNnNVVThJUHBjaXF6VXd3MDlwd2Nhd3lNOWFyUkJw?=
 =?utf-8?B?bE5kNW1LMjlRQ3ZzS0FXTUpZL1huYlBtelpIcWRLMEIrZ2JRRkt3L3V4QVlM?=
 =?utf-8?B?anJhSkJiWVFlWWFBQnNUZjNuZFVnQ28vMmg4Y2V5RlNSZEN4TGl3TzRxV1h1?=
 =?utf-8?B?ZjNqazV4T0E4Q21ZbGl1VTFYZjhuNVBORUtQcXQ2b2JEbjNYZmF6L2pmTXFk?=
 =?utf-8?B?NzNKS2pnVHg3bDFLUlhydVViVHpkYVhpY2l4VFdVaUZjbjM0cGFoTk42MjR5?=
 =?utf-8?B?a3B4MHB0L1pzakZyeXNjcUlZVXZWQUxveDdFVG53YUZxeEFjaG81YmtydWZo?=
 =?utf-8?B?U2wwcWtRK3ExakFFVS8vcUk0TzNlQkFyMC85SFF2Tkwwajh5elNXSy9rVGZt?=
 =?utf-8?B?Qm1oQmdzQzBqM2RuTnhFYi96R1BHS2orZWRwZ0RURzQxdUlvanc0OVk4L0VM?=
 =?utf-8?B?SW9hb2JhV0dJTTB0d1RHZituelZhQXFSeTFzUzExYmFpRjVGSHYvNnJpZCtG?=
 =?utf-8?B?Y09YSmVuV3dWYmVvMlJSUHBzZTZzQVYwb3Nra2ZaOEQ2dm5BUFNyNUQ1WjUz?=
 =?utf-8?B?OStrSVpuOW5XcU9MYjFkZUhxV1V4ZHVkdGMxV0Z1MEtnb0tGNUVsczl1eTh2?=
 =?utf-8?B?Q0lXUzZvd2F6a1NvQTl2RlNVNGljMDJqQ1V5Z25YMG82M1NCa1hFVlBDelZS?=
 =?utf-8?B?ek5JT2FybUNGeHlzNUZYdnMyUzJxYUpXdzhxYW95bHdOcm5Pd3hZdlB2c2RR?=
 =?utf-8?B?UHV3N295S2xKRXJsRmlEQ2dOQnlqUmo1LzJPSEF3citmU2dXZjNYMHZUTldC?=
 =?utf-8?B?TTN6WXlVM2FHbjFrMWtKSkZRVzVlK2xjN2RHZkpBRXRzSWlTNWVDT1JsTkJw?=
 =?utf-8?B?MEJ0a09BeVg1M2k1RDYwdHljOThEOEFuYWpOQzJTTklNOUZaa1RubUprdjNY?=
 =?utf-8?B?RFZCL05nTzFtNG0wOElnaTBZVGJMNHVkUzRBM2k2b1ZsUVh1UkxpWXdyZ1Vp?=
 =?utf-8?B?M2t2dTNZYUpZOG1zakh5dEV5bkpnb1dSRldSeGdzdTlSTUZUeDhjc1VqUmpi?=
 =?utf-8?B?YjA0djhwck1Gc2MzOXJLeDJPdlNOcFZxQ3kzbGpYRW1wQldmWnk4cG5ZRUhO?=
 =?utf-8?B?aWwvZG5PNWZxL1dMNGJmYkw3ZTZjOXY4QXlNazd1TzJVRkFzRkF0NXNJUzBZ?=
 =?utf-8?B?WkhFT2sxNHJpQ2tJaDBZSnlnQk5CVkdqZUdvbVJmSmw1bnAwMHArMzNEV2p5?=
 =?utf-8?B?UDgrVDJRamJMVnF2MGpZQXNzWnNJUDE3TUZTZFJFSmdwRzZhc0I0TUFrYUJi?=
 =?utf-8?Q?fG+8fSW/5gEBHcSEFB3TxlZHt?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Qqb6JWgmf6gHxyb9DrGntfXzu6VvdSz1bis/oruSblmSctcxrLJO/j8Lmu0zp4kr9/IEgK/ACAULsR56ASqPAnN1s2G/iRGViVgaTwx7XqlojrokV35ne25dqu7AbDkcD8Q3Ded3DCCVz4+YonU28xIE0R+K4jqVdPbr2b1gFzYsDRdhF+1oApNLahBJxVvtX+KWcpSgpZ97qwXWZ0/4LtaoFhOu88v3PBOVUH6BYK+ths8SwH3zAbWkVC9R8a8FN4Hy6Frz8La0JxKC/OMKbWoW4CP7jjDfMQY//E+wf0fyW8a/rllJ6nn2jpaD/VZf/aYuVR50cf+26tQZmLhJ46zYWKu2ql+ld+alhGsFWda3ZJOW6KYFZrCjTdV+d8UwgDl10792rGdAXrTJfckzHegTd/BZZ0LwFBE29o+N6qj3JlJgP/7gkEExuIg/2MntFKjgAoao/bh6+wzacTo2SoJsFHZDR/AGkCrs3sbB1CA31jd+4yKo3qzQml70sTIUw5YXDe0nR5sOy3+yrU9Akxva194YEpjGUBCM1vtiRve6LaF1aZO2vb4qghRppt7h/NnFcng5lsXRgnFiVFIk+5X+ReMLe5+KzN2J7F1tiEo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85786a7d-b5f5-464b-7da6-08dc0bca0f83
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2024 19:36:05.2804
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ustpl2UoxNsmYvop/uKH7M+hULncsimenWVCbMHLGq4D6HaDSzJOYTSztVqHym3guXzJT8OQTtc+3v+I0tsA7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4976
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-02_07,2024-01-02_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401020147
X-Proofpoint-GUID: waj8DczdczsLDbE3YgF0JnT40D2gyWlU
X-Proofpoint-ORIG-GUID: waj8DczdczsLDbE3YgF0JnT40D2gyWlU

Hi Tao,

On 1/2/24 10:20, Tao Lyu wrote:
>>>
>>> Hi=C2=A0Dongli,
>>>
>>>> On 1/1/24 14:06, Tao Lyu wrote:
>>>>> Hello Arnabjyoti, Sean, and everyone,
>>>>>
>>>>> I'm having a similiar but slightly differnt issue about the rdtsc in =
KVM.
>>>>>
>>>>> I want to obtain the timestamp counter of physical/host machine insid=
e the VMs.
>>>>>
>>>>> Acccording to the previous threads, I know I need to disable the offs=
etting, VM exit, and scaling.
>>>>> I specify the correspoding parameters in the qemu arguments.
>>>>> The booting command is listed below:
>>>>>
>>>>> qemu-system-x86_64 -m 10240 -smp 4 -chardev socket,id=3DSOCKSYZ,serve=
r=3Don,nowait,host=3Dlocalhost,port=3D3258 -mon chardev=3DSOCKSYZ,mode=3Dco=
ntrol -display none -serial stdio -device virtio-rng-pci -enable-kvm -cpu h=
ost,migratable=3Doff,tsc=3Don,rdtscp=3Don,vmx-tsc-offset=3Doff,vmx-rdtsc-ex=
it=3Doff,tsc-scale=3Doff,tsc-adjust=3Doff,vmx-rdtscp-exit=3Doff=C2=A0  -net=
dev bridge,id=3Dhn40 -device virtio-net,netdev=3Dhn40,mac=3De6:c8:ff:09:76:=
38 -hda XXX -kernel XXX -append "root=3D/dev/sda console=3DttyS0"
>>>>>
>>>>>
>>>>> But the rdtsc still returns the adjusted tsc.
>>>>> The vmxcap script shows the TSC settings as below:
>>>>> =C2=A0=C2=A0=20
>>>>> =C2=A0=C2=A0 Use TSC offsetting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0 no
>>>>> =C2=A0=C2=A0 RDTSC exiting=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 no
>>>>> =C2=A0=C2=A0 Enable RDTSCP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 no
>>>>> =C2=A0=C2=A0 TSC scaling=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 yes
>>>>>
>>>>>
>>>>> I would really appreciate it if anyone can tell me whether and how I =
can get the tsc of physical machine insdie the VM.
>>>
>>>> If the objective is to obtain the same tsc at both VM and host side (t=
hat is, to
>>>> avoid any offset or scaling), I can obtain quite close tsc at both VM =
and host
>>>> side with the below linux-6.6 change.
>>>
>>>> My env does not use tsc scaling.
>>>
>>>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>>>> index 41cce50..b102dcd 100644
>>>> --- a/arch/x86/kvm/x86.c
>>>> +++ b/arch/x86/kvm/x86.c
>>>> @@ -2723,7 +2723,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu =
*vcpu, u64
>>> data)
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool synchronizing =3D fals=
e;
>>>>
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_spin_lock_irqsave(&kvm->arch.=
tsc_write_lock, flags);
>>>> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset =3D kvm_compute_l1_tsc_of=
fset(vcpu, data);
>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 offset =3D 0;
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ns =3D get_kvmclock_base_ns=
();
>>>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 elapsed =3D ns - kvm->arch.=
last_tsc_nsec;
>>>>
>>>> Dongli Zhang
>>>
>>>
>>> Hi Dongli,
>>>
>>> Thank you so much for the explanation and for providing a patch.
>>> It works for me now.
>>
>> Yeah, during vCPU creation KVM sets a target guest TSC of '0', i.e. sets=
 the TSC
>> offset to "0 - HOST_TSC".=C2=A0 As of commit 828ca89628bf ("KVM: x86: Ex=
pose TSC offset
>> controls to userspace"), userspace can explicitly set an offset of '0' v=
ia
>> KVM_VCPU_TSC_CTRL+KVM_VCPU_TSC_OFFSET, but AFAIK QEMU doesn't support th=
at API.
>>
>> All the other methods for setting the TSC offset are indirect, i.e. user=
space
>> provides the target TSC and KVM computes the offset.=C2=A0 So even if QE=
MU provides a
> way to specify an explicit TSC (or offset), there will be a healthy amoun=
t of slop.
>=20
>=20
> Hi Sean and Dongli,
>=20
> Thank you so much for the replies.
>=20
> Unfortunately, after I adding the following patch to reset the TSC OFFSET=
 forcefully,
> I can get the host TSC value from guest.
>=20
> However, when booting the host kernel, it has the following WARNINGS:

My test patch will not impact the host time, when booting the host kernel. =
It
will not take effect until the VM is created.

Therefore, I guess the below is due to other reasons in your host kernel.

>=20
>=20
> [  113.033750] ------------[ cut here ]------------
> [  113.033768] NETDEV WATCHDOG: enxb03af61ad78a (rndis_host): transmit qu=
eue 0 timed out
> [  113.033802] WARNING: CPU: 42 PID: 0 at net/sched/sch_generic.c:477 dev=
_watchdog+0x264/0x270
> [  113.033829] Modules linked in: nf_conntrack_netlink xfrm_user xfrm_alg=
o xt_addrtype br_netfilter dm_thin_pool dm_persistent_data dm_bio_prison dm=
_bufio socwatch2_15(OE) vtsspp(OE) vhost_net vhost vhost_iotlb tap sep5(OE)=
 socperf3(OE) xt_CHECKSUM xt_MASQUERADE xt_conntrack ipt_REJECT nf_reject_i=
pv4 xt_tcpudp ip6table_mangle ip6table_nat iptable_mangle iptable_nat nf_na=
t nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables libcrc32c nfnetlink =
ip6table_filter ip6_tables iptable_filter bpfilter bridge stp llc overlay c=
use pax(OE) ipmi_ssif zram intel_rapl_msr intel_rapl_common i10nm_edac x86_=
pkg_temp_thermal intel_powerclamp coretemp joydev input_leds nls_iso8859_1 =
kvm_intel ast hid_generic drm_vram_helper drm_ttm_helper kvm rndis_host ttm=
 usbhid cdc_ether usbnet hid drm_kms_helper mii crct10dif_pclmul crc32_pclm=
ul ghash_clmulni_intel aesni_intel crypto_simd cryptd cec i2c_algo_bit rapl=
 fb_sys_fops syscopyarea intel_cstate sysfillrect i40e sysimgblt isst_if_mb=
ox_pci mei_me ioatdma ahci
> [  113.034307]  isst_if_mmio i2c_i801 mei intel_pch_thermal isst_if_commo=
n acpi_ipmi libahci dca i2c_smbus wmi ipmi_si ipmi_devintf ipmi_msghandler =
nfit acpi_pad acpi_power_meter mac_hid sch_fq_codel binfmt_misc ramoops drm=
 reed_solomon efi_pstore sunrpc ip_tables x_tables autofs4
> [  113.034473] CPU: 42 PID: 0 Comm: swapper/42 Kdump: loaded Tainted: G  =
         OE     5.15.0+ #4
> [  113.034486] Hardware name: Intel Corporation M50CYP2SB1U/M50CYP2SB1U, =
BIOS SE5C620.86B.01.01.0004.2110190142 10/19/2021
> [  113.034495] RIP: 0010:dev_watchdog+0x264/0x270
> [  113.034511] Code: eb a6 48 8b 5d d0 c6 05 e6 47 0a 01 01 48 89 df e8 9=
1 c4 f9 ff 44 89 e1 48 89 de 48 c7 c7 68 c2 a8 a9 48 89 c2 e8 90 3e 16 00 <=
0f> 0b eb 83 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41
> [  113.034522] RSP: 0018:ffffa6e88d79ce78 EFLAGS: 00010286
> [  113.034541] RAX: 0000000000000000 RBX: ffff959763ddb000 RCX: 000000000=
000083f
> [  113.034551] RDX: 0000000000000000 RSI: 00000000000000f6 RDI: 000000000=
000083f
> [  113.034559] RBP: ffffa6e88d79ceb0 R08: 0000000000000000 R09: ffffa6e88=
d79cc60
> [  113.034565] R10: ffffa6e88d79cc58 R11: ffff96163ff26c28 R12: 000000000=
0000000
> [  113.034572] R13: ffff95976488ac80 R14: 0000000000000001 R15: ffff95976=
3ddb4c0
> [  113.034579] FS:  0000000000000000(0000) GS:ffff961541980000(0000) knlG=
S:0000000000000000
> [  113.034588] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  113.034595] CR2: 000055c5819e40f8 CR3: 0000004740c0a006 CR4: 000000000=
0772ee0
> [  113.034604] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  113.034614] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [  113.034620] PKRU: 55555554
> [  113.034629] Call Trace:
> [  113.034636]  <IRQ>
> [  113.034662]  call_timer_fn+0x29/0x100
> [  113.034680]  __run_timers.part.0+0x1cf/0x240
> [  113.034757]  run_timer_softirq+0x2a/0x50
> [  113.034768]  __do_softirq+0xcb/0x274
> [  113.034790]  irq_exit_rcu+0x8c/0xb0
> [  113.034807]  sysvec_apic_timer_interrupt+0x7c/0x90
> [  113.034823]  </IRQ>
> [  113.034828]  asm_sysvec_apic_timer_interrupt+0x12/0x20
> [  113.034841] RIP: 0010:cpuidle_enter_state+0xcc/0x360
> [  113.034861] Code: 3d c1 f7 26 57 e8 c4 09 74 ff 49 89 c6 0f 1f 44 00 0=
0 31 ff e8 35 15 74 ff 80 7d d7 00 0f 85 01 01 00 00 fb 66 0f 1f 44 00 00 <=
45> 85 ff 0f 88 0d 01 00 00 49 63 cf 4c 2b 75 c8 48 8d 04 49 48 89
> [  113.034870] RSP: 0018:ffffa6e8809b7e68 EFLAGS: 00000246
> [  113.034884] RAX: ffff9615419a8dc0 RBX: 0000000000000002 RCX: 000000000=
000001f
> [  113.034892] RDX: 0000000000000000 RSI: 000000003158cc4a RDI: 000000000=
0000000
> [  113.034900] RBP: ffffa6e8809b7ea0 R08: 0000001a5155ea28 R09: 000000000=
0000018
> [  113.034909] R10: 000000000006e15c R11: ffffffffa9e4b960 R12: ffffc6e87=
a991800
> [  113.034917] R13: ffffffffa9e4b960 R14: 0000001a5155ea28 R15: 000000000=
0000002
> [  113.034942]  cpuidle_enter+0x2e/0x40
> [  113.034953]  do_idle+0x1ff/0x2a0
> [  113.034966]  cpu_startup_entry+0x20/0x30
> [  113.034979]  start_secondary+0x11a/0x150
> [  113.034991]  secondary_startup_64_no_verify+0xb0/0xbb
> [  113.035008] ---[ end trace f39ffcbabd5dfe2e ]---
>=20
> [  533.511262] clocksource: timekeeping watchdog on CPU53: hpet read-back=
 delay of 89916ns, attempt 4, marking unstable
> [  533.511295] tsc: Marking TSC unstable due to clocksource watchdog
> [  533.511336] TSC found unstable after boot, most likely due to broken B=
IOS. Use 'tsc=3Dunstable'.
> [  533.511339] sched_clock: Marking unstable (533409196195, 102131418)<-(=
533549406780, -38078705)
> [  533.512368] clocksource: Checking clocksource tsc synchronization from=
 CPU 35 to CPUs 0,3,21-22,36,50,54.
> [  533.513146] clocksource: Switched to clocksource hpet
>=20
>=20
> And after a while, the guest kernel will have the following  error, and t=
hen the network doesn't work anymore.
> If I reboot the guest VM, then it will stuck and cannot be rebooted succe=
ssfully.
>=20
> rcu: INFO: rcu_sched self-detected stall on CPU
> [  336.374152] rcu: 	3-...!: (1 GPs behind) idle=3Dbb3/0/0x1 softirq=3D30=
87/3087 fqs=3D0=20
> [  336.379018] rcu: rcu_sched kthread timer wakeup didn't happen for 3908=
6 jiffies! g3941 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
> [  336.386045] rcu: 	Possible timer handling issue on cpu=3D1 timer-softi=
rq=3D871
> [  336.390353] rcu: rcu_sched kthread starved for 39089 jiffies! g3941 f0=
x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D1
> [  336.395881] rcu: 	Unless rcu_sched kthread gets sufficient CPU time, O=
OM is now expected behavior.
> [  336.400375] rcu: RCU grace-period kthread stack dump:
> [  336.404091] rcu: Stack dump where RCU GP kthread last ran:
> [  566.795685] rcu: INFO: rcu_sched self-detected stall on CPU
> [  566.799315] rcu: 	3-...!: (1 ticks this GP) idle=3Dc65/0/0x1 softirq=
=3D3088/3088 fqs=3D1=20
> [  566.804170] rcu: rcu_sched kthread timer wakeup didn't happen for 2296=
87 jiffies! g3941 f0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402
> [  566.811259] rcu: 	Possible timer handling issue on cpu=3D1 timer-softi=
rq=3D872
> [  566.815579] rcu: rcu_sched kthread starved for 229690 jiffies! g3941 f=
0x0 RCU_GP_WAIT_FQS(5) ->state=3D0x402 ->cpu=3D1
> [  566.821190] rcu: 	Unless rcu_sched kthread gets sufficient CPU time, O=
OM is now expected behavior.
> [  566.825813] rcu: RCU grace-period kthread stack dump:
> [  566.829513] rcu: Stack dump where RCU GP kthread last ran:
>=20
>=20
> Looks like it leads to kernel misbehavior if we don't adjust the guest TS=
C value.
>=20
> Our goal is to get the almost synchronized TSC value among KVM VMs one th=
e same host.
>=20
> Now I fix the host CPU frequency. Then the TSC OFFFSET, which can be read=
 under "/sys/kernel/debug/kvm/qemu-PID/vcpu0/tsc-offset", will always keep =
constant.
>=20
> Every time when I execute the rdtsc inside the guest, I will subtract the=
 offset to it get the TSC value, which can be close to the host TSC value.
>=20
> Do you think this makes sense?

I assume you do not use TSC scaling or any nested virtualization.

Therefore, the value in the debugfs should be the same as the one computed =
by
"kvm_compute_l1_tsc_offset(vcpu, data)". You may use printk to double confi=
rm.

I think it makes sense.

However, I do not think the patch may cause the issue. It works in my envir=
onment.

Thank you very much!

Dongli Zhang

>=20
> Thank you in advance
>=20
> Best,
> Tao

