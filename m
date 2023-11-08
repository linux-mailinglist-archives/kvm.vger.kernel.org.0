Return-Path: <kvm+bounces-1239-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2614B7E5D22
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 19:24:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 60040B20F53
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B44DC36AFB;
	Wed,  8 Nov 2023 18:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Hf2WbI+u";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="h+h1rU7b"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95857358B2
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 18:23:55 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 410D81FF5;
	Wed,  8 Nov 2023 10:23:55 -0800 (PST)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8GEn6B003416;
	Wed, 8 Nov 2023 18:23:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=zUfcsfjEd0+8+7vIt/8nwvwI/KA8q5RlU+yPP+o57ls=;
 b=Hf2WbI+uCrH/VhlRDwdszZCdPMe9JXuTdUpeznzmMuJDNpXm+U3M24XwbL/vBZB5IAgC
 zszT0pkyCx3kKA6F8eJBpbFoWfpgDNusrAPKLQbB6/p1GRvCbT7e/FIsDhMwPpqAkNcC
 Fs6QhmNJv16X9BkZnWlPEHZpUwlQmecDrPE7l2lCd3xSdG677j+GqRf+1tCjzhjW8moS
 bL1Lffil8NdvCF8y08wwjtAZ8bRPS1XciR/+0F5WcNirdDVn2yyj6WD7SXg9nOafBeBU
 KUUdCfmk4IJcYpRa/pamLCC/etEXM2dGe0ysWj3hQL6NZ2ipJC9L4O3ccoCgIeNos78v 1A== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w23j7cy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Nov 2023 18:23:25 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3A8HXWTq004090;
	Wed, 8 Nov 2023 18:23:24 GMT
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2040.outbound.protection.outlook.com [104.47.73.40])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w1x5xse-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 08 Nov 2023 18:23:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDdrSGDfiTxc744z44Alk9nzquSoi5c2B7LI8tnt/8gMrOLD4wytyCfyL/B0pCunfAlTPSBHMyNfyqcb9n7PauLvQbvZTypAhlkMnCBulTFapFRruIi+p+pNEnI/TSVZsnI3YfLehFDXARehc5MhBqLjxhAkDjvHAvHBHd65oIK9QMZIekCSMPUyU2XO0SQd1gZx8zCNTc6Q98vIT3wZKIlV0Rjg+VMH1P/ua5ArjaTQELO6TcsvZkJ/+1FVQVB1Oty+BSRwKFcwPULEHJsN8vWt2iNd1jjdV7d22JZ6KC9IgCetOsAHEFCcOzusEKgQaw5oKYzbJqyiDDz6I3x4Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zUfcsfjEd0+8+7vIt/8nwvwI/KA8q5RlU+yPP+o57ls=;
 b=LSjr7xllqumwOWfvkrBvFeG7JWCWKERn5xV45GhusgANck78y+F3dl8irCgvPYGDlmuJ2gq1zp85dmtlnXfix1/ZTrpqNNd2ncqeLf0NJ75eNFQOw/1VyltUTHKzlZmdi0CJXUSEfpC9waIXVUUU8O6AqBL4jRy6MzwOgSrQNVV9srDA/LJgYWUEP/WjxJifXydDyfraFw6EXLPyUYgIgRCEh63DfnMwLGmA2juDv4yPyuZFFgbuSbAzmz8pGyUJBuBrnbEd8chX7tgXB5YxSyJeKDbIehD+ZY4HeGEGaU623/BlJiypW0Oa4U17FhO51i6Cu+QRkAgCixa2vPDAXQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zUfcsfjEd0+8+7vIt/8nwvwI/KA8q5RlU+yPP+o57ls=;
 b=h+h1rU7bmbKeov2gaKQRVhrDH5QAneUoqvSg8ww44T4i3yIgGcV7dPrO0vFQ2lLxm09vJSjWcTMedMhsFeUh+iSOH0PN+DbHX5i4ci6o0IQczmvQ4dVbQDlFbNfCTgVf+tHYHsoLsxhYmo++vCw/LEHfDBQohjXUH3bfNaQWxiM=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DM4PR10MB5968.namprd10.prod.outlook.com (2603:10b6:8:aa::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.18; Wed, 8 Nov
 2023 18:22:55 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.6954.029; Wed, 8 Nov 2023
 18:22:55 +0000
Message-ID: <c6cfae1a-e687-ae7d-12ae-38fb97923082@oracle.com>
Date: Wed, 8 Nov 2023 10:22:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v2] KVM: x86/xen: improve accuracy of Xen timers
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Paul Durrant <paul@xen.org>, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
References: <96da7273adfff2a346de9a4a27ce064f6fe0d0a1.camel@infradead.org>
 <74f32bfae7243a78d0e74b1ba3a2d1ea4a4a7518.camel@infradead.org>
 <2bd5d543-08a0-a0f6-0f59-b8724a2d8d75@oracle.com>
 <12e8ade22fe6c1e6bec74e60e8213302a7da635e.camel@infradead.org>
 <19f8de0a-17f7-1a25-f2e9-adbf00ecb035@oracle.com>
 <37225cb2ab45c842275c2b5b5d84d1bb514a8640.camel@infradead.org>
 <33907a83-4e1a-f121-74f3-bde1e68b047c@oracle.com>
 <5e0598c86361570674401f43191c3f819a6b32d2.camel@infradead.org>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <5e0598c86361570674401f43191c3f819a6b32d2.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MN2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:208:120::22) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DM4PR10MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d527827-fcda-4780-0e5d-08dbe087ba40
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Xzya4cCK2ZbNccFgZ9e70e4GSPZeD5Ho8MYhQiciP9zWThyd7S0EkWFXif3g/Xd15CCuHzyH0Ijytm6b6H7HCz/HGsK5pFKRm3Ua/Co4tsH7uRyn9+6sCWyjz2ljXnlGktx+6I8S79QbX1tksxwMVeZ+mcVOhZK7tgzWRft/AY6hgR/zB5GqIQ3SysZhbjMcN0SuKQYmqsTD3skCU9JDwJd9ojOKrMqYEKlpdFQWi/36q7lUwOKA7Zq9E4qeGTPyMtdeblz8inAcYyCCwEFmr6qkGYXisH2NW0LH8LBxv5sQfjluSLR8YDh52AGFKZz6C6n1qXN5+VGiToPpNzOc0jA2RuDqSjbvw/EKgfsjZIztM5j42/2x00GgYdU5XFsOgEJz/TIXGRvnyxB8bbwErQlpXnf3ra0RwdJLye1+QzgA9ev7f5PHzfnLGurK4D9W8pjZdJGBhuWpqrn9EgkDYJJGLx21GbJD56iCSf/ZdTFHD4YpDBeEb8CP7zOZCEkY+fMUpq2nxlYaWK01fJpMmowZeVN65UDoChNpf5q0oqXxv3oQKQ7eX5dCtIPCNPGN2sXjAE0ZRAPrMRfEnyMXdeFn2wAg/j4Rq8Fe4lSzSqG/8Nlcfr0BYSD2eG18BHEpcLa1NF1twESb7ZiEYDLMYQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(136003)(396003)(366004)(39860400002)(346002)(230922051799003)(451199024)(1800799009)(64100799003)(186009)(7416002)(26005)(2616005)(83380400001)(86362001)(31696002)(6506007)(6666004)(36756003)(6512007)(478600001)(53546011)(2906002)(6486002)(966005)(38100700002)(31686004)(316002)(66946007)(54906003)(66556008)(66476007)(44832011)(5660300002)(8936002)(41300700001)(4326008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZENWY2k5NXFiNm9oVE1tU3l0dHpKM1VWdGVGb0tuYTN5bnZMcEFJZThSeXdE?=
 =?utf-8?B?UTlQNHluS2ZSR3FtS25Ra081Ni9hc2dxK1NpajRkZ092eGhEWmgwREpqVGor?=
 =?utf-8?B?UU1IelVxYkhJNlNmYXRLSVQwb0NzenR1QktCdE1yNnViQVQ1SEd4aXdjZCtq?=
 =?utf-8?B?R1FpRHdXN2RpaHljVDhNRlg3eHZPU2hKOGRSSGdidkRqVjhHdjEwUzNMSm1H?=
 =?utf-8?B?ODVoS3loVDRpeDF6bkFSeWhSbWlldWpHT1Vtc2hoeVQrTzdGOU9ObXlEMDlx?=
 =?utf-8?B?bkE5ZDZ5K1hta2NlUWd0YlhoMzlycEdha0pnc0ZMN3dtUU4xKytQN2xMQlpm?=
 =?utf-8?B?SFlUZlRwQmswdUpDYUVCekRZOGEvejBZZktuWjQ4WVV2emlrN2tzMWI5Qlk0?=
 =?utf-8?B?ZnFJQ0pmZzg1WnVhZy94OEJ5UmJGYTZDQ0MwMWNQMXVsV2hyRk5qN0VrMmky?=
 =?utf-8?B?MHdoei9VenAvb1IyRnU5Wi9Zb1VKelVqeEZUb01rQ0x1L0lyVG92QlFVZTBp?=
 =?utf-8?B?azNaSHcyQ1JKdGViSmJzYUt4aTdPZFVEdG83aFdVY2p1RENhZEZZVGpBRzJC?=
 =?utf-8?B?QnBnbWdaUFdtR3dqQ3RVZGMwd0Fwd242aUw2N1dRWkt0RmJkaktEL3JPQ0la?=
 =?utf-8?B?QkhHTlExVHhwbElOV1NQNUVxZENoamc0KytMWmgva0wwUmhhSitKNWU2ZldO?=
 =?utf-8?B?V3BRVnM2TzJHWEEzTlNFN3RlUzkyaE9kMzM2bjZ3bDVqVXNRdWZ5NE1ablhJ?=
 =?utf-8?B?d2oxeFY0bFNsUE1NMkhYZm8xb2xZV3ZHQktOY28vVXhteHBWd2FEVU9WZ3Rn?=
 =?utf-8?B?d2ZGSmNkRktWZEFpRXloRWJVK0M5UWxPeDRURUNKM2c4T0ZLV0RSdTZiU0d5?=
 =?utf-8?B?VW8yZktuaEF5VmsvYUpHRHIwWW42amp2M0N3R01YM2RQbnFtdGtaeklqSDlU?=
 =?utf-8?B?dTdTUHRzaGwvN1V4SXZxZkt5cy9CeTd4WTJZNUNzZDlUb3p0dSs2ZHBCQWFx?=
 =?utf-8?B?aTBQV2NBRXFzdVZYVSs4d0FOb3FhU0RoUktMQmdSUGNsMmNWZFB2cUFLQ1VS?=
 =?utf-8?B?bGpWZGk4K3BiL1VjeklOdmFEZWdvLytBSEpmNmt4TTNPUlhneTZqYTViQVdD?=
 =?utf-8?B?bEdGaWNxWURmWGlWQVJMQU1ZQmNlVHZOR3hPRlREMHhvNDNxTFhTRlVPNFo3?=
 =?utf-8?B?ajUvcm5QdlpheXhOYXdwdHkwSmFla0dscUJURHdWMjRZY1hGdlZxUm1GSDdo?=
 =?utf-8?B?RjkzbktReWFIMS9SUllZaWhkWkJ5Q2JSMkFKbXZLZ1ZrT2pIL1VIZHZlT0pF?=
 =?utf-8?B?UGlyTHJ2RjRNQnFiWGQ1U005Tm5qWTJQNHFORlYxS29uWHpvaEYzeVdrL1p2?=
 =?utf-8?B?MFF4c2RPQ3h6eEJmTS9FaTB3cDJ0RmpLRkhrTVBvektMVjF0a0FIcWc0VEM5?=
 =?utf-8?B?RjlGd0hrMHphaDJ6MkNienJSRzFrMVlsVGFuNGRkaGp1aFQ1TEFKVGM1WUR1?=
 =?utf-8?B?emFrN2dWY29mTVBOb0VWenhoZ09YMUFlb1YrK2FhMmEyZEZaM1NDWjNIMmFn?=
 =?utf-8?B?T09TMmVBOVdDeU1HWVBMK3BzQjhVOFZrM09Tc1NuVk9UMHZSQ1BlZ1I2Si9B?=
 =?utf-8?B?cG9sQytEOGlVZ1BmUDNlWmhEVmJMUW50MEs4cmh1M2pJNSszbDBtTXMrZ1Uy?=
 =?utf-8?B?bzJSMGE1UTRuY0NtZURiRk1EWlZud2hraDN2T2NhTW9pWkgyOUZGTXlBdm9i?=
 =?utf-8?B?ZnFsZlhMcG53enNFVUx2SEdFNWQ3QllyRW5nR3BSRHA5eG9XWHBXMlhsb251?=
 =?utf-8?B?OFI2eld4TEFmb2FBaXZnbktmVTV2bmdQWHpibTBhbUJhT3VudWNXWTU0S3cx?=
 =?utf-8?B?dTBqaVVXOG80Z3FkeHJLaysyQ1Qvdks1U0s4VURCZTJ3NFJLRGdITk9XT3dT?=
 =?utf-8?B?OFRxZnFmNm95MENTSzhUQTh0STFrdEVHU0IwZnVRN296ejc3bm9PWDBOWTdP?=
 =?utf-8?B?ejB6VEhRallJbnFkU0RNWHNNNGswMkNpa3NqVDJGSnQ5REl5LzZWdTRmbnJX?=
 =?utf-8?B?S0JwUWJkaTFNWHpGd3dzeHdlZzhYdm1RWTNrSU5qYkpsN1BZcnZPV0xYdCtk?=
 =?utf-8?Q?6foF0ehOH11Bpo108ed/v/NJl?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?eE13MWk4UTFVL2M1a0ZGM2NncDFoWU1kSDF0MGg3a053QVhsZiszT0Y2NGJ2?=
 =?utf-8?B?SVJkeG84RDJlWU92K2xJUlk0dXNhVHdpdjFiRDF0eTFkU0I0aUhxUDlSTFNX?=
 =?utf-8?B?d0cyNjBjMUlxQlBlQ3NBWDdDV084WGd2bVJVSlhKVjNjblp0L3RoaUlJVlJV?=
 =?utf-8?B?UTVQK29XNTYzNGlUWUxuWUduV3o3VGhqaWtqUXJBRGt5dkMzWU1KbXM0cGMw?=
 =?utf-8?B?UE1ib0FQd1VFNjhvdHg0SGRnNTd0M2hpK0hqanpJRGo4dmlSNG1Oa3V3K1JY?=
 =?utf-8?B?Y2xGT1loQzh3ZU52VGQvc0NEN3JRMnM2OVVpTXF4Nnk1TmlXWENiOHRpTUFr?=
 =?utf-8?B?c2NKWndwTkVkUCtpME5oM1pIK3ZydkYxRFpjYnBpdUVXeFc3c0lKdEowU2VP?=
 =?utf-8?B?am5FYWV1Mnc5bDVEcDZqaHg0V3FZZ3J4Y1JiT2p5OFlwUnMvalpFT3BWdlND?=
 =?utf-8?B?TzdQcWRxNlRDVVBPb0gzT3UwYnZGQlRsazVjQTRUb2VYcmpUOXdYMU4vVFcw?=
 =?utf-8?B?Sm9zZmsySjcwU2VzZ2hHS2UyazQzVHhGQ3FlTm5DMkJjV3RWdnN6d0YwOXBz?=
 =?utf-8?B?Y04wWXBIYnk3VGFteVVwWFRoTHFOVU1hbXYzMnNiUW1WQ2JQTFdzV3VkRjNk?=
 =?utf-8?B?ZkxxejYvTGZWSXdacHduVHBuSC9hZ2VsTkdGdnYvSGY3ZHhDR3dZdEdLdkhl?=
 =?utf-8?B?SEdVWDBTZ0xOenU2aEFKK1pWOGFYMkthTmljdGVpK2crUVFmcEZCQ3lHTTZ6?=
 =?utf-8?B?Y3FxcFhtdHRzeWtKSVIvbEx6Q3BFVlVJS1VPcnFNbmhXckdNdlJuUlNsazd2?=
 =?utf-8?B?TFZ3a3lQMzM1Zkg4UmNSdkx2aWozbDBFL2l0NGo3bXBuY1NHYjBTVjVFdUkr?=
 =?utf-8?B?SXBuRXRvMHpoOHNGVC8vVHJvUS9QSWNZMldSQ1VEemJuZTRPSXc0Sm9KVFFW?=
 =?utf-8?B?K3FPR044SzNQMzBRSmhOMjY0K0JodWRTYWJVRmpQNDRpRmVQVk0xOFNsM1Ry?=
 =?utf-8?B?OWRVZWtQc0FYekh3Y2FjWHhWeHROcldTZzI2akkzcXNlb2VEK0xXemRYNFp5?=
 =?utf-8?B?ZVRyT3RRNC9rVTdaOWZwVWQyaGpnZkxXaDM3WTM4VWw1YkJMZW9LT005WStJ?=
 =?utf-8?B?aXZ3QjBSUUNsWUsxZVRFQm4zREhESGZrZjJRTUsxR2g4SWVQRDExVTg2STMz?=
 =?utf-8?B?aGY0ZEduZldUYTNSMkVmUkxwQlpMSzMxd3c2U08wNGNNOTc3RW91UVdGVG8r?=
 =?utf-8?B?MHlhWTcyK1QycTA2M3ZObHdkdWllSVFWT21GTmtiUE5WUThTbW83SGRESERG?=
 =?utf-8?B?T0xnRUp2dmxtTVFUeG81YlBrZ1VJaVVWdmJTR3JYSVY5Rks1WnF4VTBnL2ZX?=
 =?utf-8?Q?oTbr0PhNMV6p5VgUn0P6Kor+WBLWJfU4=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d527827-fcda-4780-0e5d-08dbe087ba40
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2023 18:22:55.5261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0uRGTop5rQwugnP5LH0bWQdKZvM+3LOdzo+9xw8kf64fczX8b/4KoreyjBdii0rcnXz6S6LwVjYWH+LDeuQSg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB5968
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-08_07,2023-11-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311080152
X-Proofpoint-GUID: Flzcu0szY6DE4UvdL8tbjGo76yoYZGL_
X-Proofpoint-ORIG-GUID: Flzcu0szY6DE4UvdL8tbjGo76yoYZGL_

Hi David,

On 11/8/23 07:25, David Woodhouse wrote:
> On Tue, 2023-11-07 at 17:43 -0800, Dongli Zhang wrote:
>> Hi David,
>>
>> On 11/7/23 15:24, David Woodhouse wrote:
>>> On Tue, 2023-11-07 at 15:07 -0800, Dongli Zhang wrote:
>>>> Thank you very much for the detailed explanation.
>>>>
>>>> I agree it is important to resolve the "now" problem. I guess the KVM lapic
>>>> deadline timer has the "now" problem as well.
>>>
>>> I think so. And quite gratuitously so, since it just does:
>>>
>>>         now = ktime_get();
>>>         guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>>>
>>>
>>> Couldn't that trivially be changed to kvm_get_monotonic_and_clockread()?
>>
>> The core idea is to always capture the pair of (tsc, ns) at exactly the same
>> time point.
>>
>> I have no idea how much accuracy it can improve, considering the extra costs to
>> inject the timer interrupt into the vCPU.
> 
> Right. It's probably in the noise most of the time, unless you're
> unlucky enough to get preempted between the two TSC reads which are
> supposed to be happening "at the same time".
>>
> 
>>> I conveniently ducked this question in my patch by only supporting the
>>> CONSTANT_TSC case, and not the case where we happen to know the
>>> (potentially different) TSC frequencies on all the different pCPUs and
>>> vCPUs.
>>
>> This is also my question that why to support only the CONSTANT_TSC case.
>>
>> For the lapic timer case:
>>
>> The timer is always calculated based on the *current* vCPU's tsc virtualization,
>> regardless CONSTANT_TSC or not.
>>
>> For the xen timer case:
>>
>> Why not always calculate the expire based on the *current* vCPU's time
>> virtualization? That is, why not always use the current vCPU's hv_clock,
>> regardless CONSTANT_TSC/masteclock?
> 
> The simple answer is because I wasn't sure it would work correctly in
> all cases, and didn't *care* enough about the non-CONSTANT_TSC case to
> prove it to myself.
> 
> Let's think about it...
> 
> In the non-CONSTANT_TSC case, each physical CPU can have a different
> TSC frequency, yes? And KVM has a cpufreq notifier which triggers when
> the TSC changes, and make a KVM_REQ_CLOCK_UPDATE request to any vCPU
> running on the affected pCPU. With an associated IPI to ensure the vCPU
> exits guest mode and will processes the update before executing any
> further guest code.
> 
> If a vCPU had *previously* been running on the affected pCPU but wasn't
> running when the notifier happened, then kvm_arch_vcpu_load() will make
> a KVM_REQ_GLOBAL_CLOCK_UPDATE request, which will immediately update
> the vCPU in question, and then trigger a deferred KVM_REQ_CLOCK_UPDATE
> for the others.
> 
> So the vCPU itself, in guest mode, is always going to see *correct*
> pvclock information corresponding to the pCPU it is running on at the
> time.
> 
> (I *believe* the way this works is that when a vCPU runs on a pCPU
> which has a TSC frequency lower than the vCPU should have, it runs in
> 'always catchup' mode. Where the TSC offset is bumped *every* time the
> vCPU enters guest mode, so the TSC is about right on every entry, might
> seem to run a little slow if the vCPU does a tight loop of rdtsc, but
> will catch up again on next vmexit/entry?)
> 
> But we aren't talking about the vCPU running in guest mode. The code in
> kvm_xen_start_timer() and in start_sw_tscdeadline() is running in the
> host kernel. How can we be sure that it's running on the *same*
> physical CPU that the vCPU was previously running on, and thus how can
> we be sure that the vcpu->arch.hv_clock is valid with respect to a
> rdtsc on the current pCPU? I don't know that we can know that.
> 
> As far as I can tell, the code in start_sw_tscdeadline() makes no
> attempt to do the 'catchup' thing, and just converts the pCPU's TSC to
> guest TSC using kvm_read_l1_tsc() — which uses a multiplier that's set
> once and *never* recalculated when the host TSC frequency changes.
> 
> On the whole, now I *have* thought about it, I'm even more convinced I
> was right in the first place that I didn't want to know :)
> 
> I think I stand by my original decision that the Xen timer code in the
> non-CONSTANT_TSC case can just use get_kvmclock_ns(). The "now" problem
> is going to be in the noise if the TSC isn't constant anyway, and we
> need to fix the drift and jumps of get_kvmclock_ns() *anyway* rather
> than adding a temporary special case for the Xen timers.
> 
>> That is: kvm lapic method with kvm_get_monotonic_and_clockread().
>>
>>>
>>>
>>>>
>>>> E.g., according to the KVM lapic deadline timer, all values are based on (1) the
>>>> tsc value, (2)on the current vCPU.
>>>>
>>>>
>>>> 1949 static void start_sw_tscdeadline(struct kvm_lapic *apic)
>>>> 1950 {
>>>> 1951         struct kvm_timer *ktimer = &apic->lapic_timer;
>>>> 1952         u64 guest_tsc, tscdeadline = ktimer->tscdeadline;
>>>> 1953         u64 ns = 0;
>>>> 1954         ktime_t expire;
>>>> 1955         struct kvm_vcpu *vcpu = apic->vcpu;
>>>> 1956         unsigned long this_tsc_khz = vcpu->arch.virtual_tsc_khz;
>>>> 1957         unsigned long flags;
>>>> 1958         ktime_t now;
>>>> 1959
>>>> 1960         if (unlikely(!tscdeadline || !this_tsc_khz))
>>>> 1961                 return;
>>>> 1962
>>>> 1963         local_irq_save(flags);
>>>> 1964
>>>> 1965         now = ktime_get();
>>>> 1966         guest_tsc = kvm_read_l1_tsc(vcpu, rdtsc());
>>>> 1967
>>>> 1968         ns = (tscdeadline - guest_tsc) * 1000000ULL;
>>>> 1969         do_div(ns, this_tsc_khz);
>>>>
>>>>
>>>> Sorry if I make the question very confusing. The core question is: where and
>>>> from which clocksource the abs nanosecond value is from? What will happen if the
>>>> Xen VM uses HPET as clocksource, while xen timer as clock event?
>>>
>>> If the guest uses HPET as clocksource and Xen timer as clockevents,
>>> then keeping itself in sync is the *guest's* problem. The Xen timer is
>>> defined in terms of nanoseconds since guest start, as provided in the
>>> pvclock information described above. Hope that helps!
>>>
>>
>> The "in terms of nanoseconds since guest start" refers to *one* global value.
>> Should we use wallclock when we are referring to a global value shared by all vCPUs?
>>
>>
>> Based on the following piece of code, I do not think we may assume all vCPUs
>> have the same pvclock at the same time point: line 104-108, when
>> PVCLOCK_TSC_STABLE_BIT is not set.
>>
> 
> The *result* of calculating the pvclock should be the same on all vCPUs
> at any given moment in time.
> 
> The precise *calculation* may differ, depending on the frequency of the
> TSC for that particular vCPU and the last time the pvclock information
> was created for that vCPU.
> 
> 
>>
>>  67 static __always_inline
>>  68 u64 __pvclock_clocksource_read(struct pvclock_vcpu_time_info *src, bool dowd)
>>  69 {
>>  70         unsigned version;
>>  71         u64 ret;
>>  72         u64 last;
>>  73         u8 flags;
>>  74
>>  75         do {
>>  76                 version = pvclock_read_begin(src);
>>  77                 ret = __pvclock_read_cycles(src, rdtsc_ordered());
>>  78                 flags = src->flags;
>>  79         } while (pvclock_read_retry(src, version));
>> ... ...
>> 104         last = raw_atomic64_read(&last_value);
>> 105         do {
>> 106                 if (ret <= last)
>> 107                         return last;
>> 108         } while (!raw_atomic64_try_cmpxchg(&last_value, &last, ret));
>> 109
>> 110         return ret;
>> 111 }
>>
>>
>> That's why I appreciate a definition of the abs nanoseconds used by the xen
>> timer (e.g., derived from pvclock). If it is per-vCPU, we may not use it for a
>> global "in terms of nanoseconds since guest start", when PVCLOCK_TSC_STABLE_BIT
>> is not set.
> 
> It is only per-vCPU if the vCPUs have *different* TSC frequencies.
> That's because of the scaling; the guest calculates the nanoseconds
> from the *guest* TSC of course, scaled according to the pvclock
> information given to the guest by KVM.
> 
> As discussed and demonstrated by http://david.woodhou.se/tsdrift.c , if
> KVM scales directly to nanoseconds from the *host* TSC at its known
> frequency, that introduces a systemic drift between what the guest
> calculates, and what KVM calculates — even in the CONSTANT_TSC case.
> 
> How do we reconcile the two? Well, it makes no sense for the definition
> of the pvclock to be something that the guest *cannot* calculate, so
> obviously KVM must do the same calculations the guest does; scale to
> the guest TSC (kvm_read_l1_tsc()) and then apply the same pvclock
> information from vcpu->arch.hvclock to get the nanoseconds.
> 
> In the sane world where the guest vCPUs all have the *same* TSC
> frequency, that's fine. The kvmclock isn't *really* per-vCPU because
> they're all the same. 
> 
> If the VMM sets up different vCPUs to have different TSC frequencies
> then yes, their kvmclock will drift slightly apart over time. That
> might be the *one* case where I will accept that the guest pvclock
> might ever change, even in the CONSTANT_TSC environment (without host
> suspend or any other nonsense).
> 
> In that patch I started typing on Monday and *still* haven't got round
> to finishing because other things keep catching fire, I'm using the
> *KVM-wide* guest TSC frequency as the definition for the kvmclock.
> 
> 

Thank you very much for the explanation.

I understand you may use different methods to obtain the 'expire' under
different cases.

Maybe add some comments in the KVM code of xen timer emulation? E.g.:

- When the TSC is reliable, follow the standard/protocol that xen timer is
per-vCPU pvclock based: that is, to always scale host_tsc with kvm_read_l1_tsc().

- However, sometimes TSC is not reliable. Use the legacy method get_kvmclock_ns().

This may help developers understand the standard/protocol used by xen timer. The
core idea will be: the implementation is trying to following the xen timer
nanoseconds definition (per-vCPU pvclock), and it may use other legacy solution
under special case, in order to improve the accuracy.

TBH, I never think about what the definition of nanosecond is in xen timer (even
I used to and I am still working on some xen issue).

Thank you very much!

Dongli Zhang

