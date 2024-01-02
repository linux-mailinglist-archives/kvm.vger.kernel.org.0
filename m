Return-Path: <kvm+bounces-5413-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3A38821710
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 06:12:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38E6A1F21A24
	for <lists+kvm@lfdr.de>; Tue,  2 Jan 2024 05:12:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780CA23AD;
	Tue,  2 Jan 2024 05:11:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ODFnhj/b";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="l3Kg1SGH"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D1720F9
	for <kvm@vger.kernel.org>; Tue,  2 Jan 2024 05:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 401NhiRa009920;
	Tue, 2 Jan 2024 05:11:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-11-20;
 bh=0BTlP6ELkXbDMlPIiB2XalXJetfiMIQkVn5cP7Ceh/I=;
 b=ODFnhj/bsOd0hf9JqP60sFuM23Rh+3iK/FzHJHwnwDozXe+xebifavvG2t6Mqwy4ux/I
 6fTYcE9NmWmH4QZSThqcxWvp1dz4BP0U4ly4Z1dQQ6hbrlhda+RAMIN1hVTMuzRsp8df
 ZZ6G56oHx061mPq+TErkaqkP89m5JbsvR1dehYd4tBfEaf1ygVrOWNhosRJi7HYsnqJ5
 qIc62+6SDCqNCpMMHMyxf3HcDrcS+N5/I8U2/1+9PA56zL9BH/S/QFSBwIyvaKWFh0qY
 MRuTkCcavD6GykL7vxE624Z64/T5QBkth0AYf+8nnXuQP4uOkMrzcvJPKmyaerW5US0Y AQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vaa03tbc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jan 2024 05:11:36 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4022ifc9013637;
	Tue, 2 Jan 2024 05:11:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3va9ncpmf2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jan 2024 05:11:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9YRxVkL+WJFi+UTbr+EpZ53416/vDB6MUrP9HgAbjXYvKAGxnykL6QSDuu6DAxtETR7dhns7AitTu8pUb6XTJWsiGoHc0+ZEctHg+7Zwhd36pwA7gDE34zOfj/rKRfdFS//nqPlHkKvK/Vf1unJWH5umJFy0O9iCNHF7/1YlEqURlMFvGcDIfdfzCfI2fucrDB2nTsI1mWoXIF4tg1Ml1PuM6OLikodTcUJlz/CpzuMll6J61gUCcj+52y9NJ4Uu/WriIHKK9n/jRo4512XVnHlggATOys4ONBJziHgmM/Mo6AYqIOKmoMT+0is/VnKeJK6QBVN3J90/xB7bGFOIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0BTlP6ELkXbDMlPIiB2XalXJetfiMIQkVn5cP7Ceh/I=;
 b=kp1CXwkeBhYXUTCy9fwyn6TwhmMS4ofLJi87UAJajnZYqz4IvpO8MdMccdT094u3ivRAOrFX/EhU5r2J9OhDUYDXTfIrvVeHSg28unVOfen1gdp1XjYRCypsuzEwzCmX3uFsE43UkGk9aII3PrkGlT35xdoHWBN47HLVeoPY54cut/zF8htsQl6HuA/mCNQzk/dMgVs1bZylrEzupjj8JVxnDh7d9pxOJJV1xf+cPHaZpO3eiXzBwDFOKxY8TZHwGd3DUzZGQTchKdT480OjG+x5paNmDvck7BiqSuSYIZX48aNRZdndv4DhoDlnSQnvux/WS5lm/35K3Pxdua1jZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0BTlP6ELkXbDMlPIiB2XalXJetfiMIQkVn5cP7Ceh/I=;
 b=l3Kg1SGHwGcsWJBCpycCwVQqG4+3xv1MK5MIONh8Kq/5mD7ygp71ygDrOOSQFhn7qzey0zDsuH0ZxiIJGWpJwWr8tyBBKF3rNlgbTPYeDXKT5Uqn5YLO1aofWzAv5kQhvTbX2Tki+BfWSWE9hEgNYAFDIcFq35pZG1pA6itMH3o=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB7155.namprd10.prod.outlook.com (2603:10b6:8:e0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7135.25; Tue, 2 Jan
 2024 05:11:32 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.7135.023; Tue, 2 Jan 2024
 05:11:31 +0000
Message-ID: <f1535a39-4f3b-bae8-950e-9a0e5df46681@oracle.com>
Date: Mon, 1 Jan 2024 21:11:27 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: obtain the timestamp counter of physical/host machine inside the
 VMs.
To: Tao Lyu <tao.lyu@epfl.ch>
Cc: kvm@vger.kernel.org, seanjc@google.com, akalita@cs.stonybrook.edu
References: <CAJGDS+Ez+NpVtaO5_NTdiwrnTTGFbevz+aDUyLMZk6ufie701Q@mail.gmail.com>
 <20240101220601.2828996-1-tao.lyu@epfl.ch>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20240101220601.2828996-1-tao.lyu@epfl.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR0102CA0031.prod.exchangelabs.com
 (2603:10b6:207:18::44) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB7155:EE_
X-MS-Office365-Filtering-Correlation-Id: f652b335-bc2a-4523-d36f-08dc0b514811
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	99RgN5x06YrsVxQqrIyAkyloOIBgFnD9oToN7cLZ0vrxrvy14yYxyAISDzfmeAZS58dFVNtOB5QygrazQhT1NNWM6HDTEqmDH9IKAv+0zbFzGBN8oU1W3LEZCteuztcpxFAj9hlRr4+DC4HUDgxUL6Rw2Qu4/OVSUhZ6xQgstTDiUmsEwW7eA6HkyaqKH29AYDBWQevsM2utwJPk5mTQ37Z8KEtU2fFmCwdEzDK3YGuZBlxOdLJ9AUlZgtvKJ+o1wQGNI9dBuqBlcbkLurleYtNui+TXoVG09/Vr22EqodZCUSZGHMhbRtPkqTeDbiFXl4sPzayY96FkybJiR/zIB0I/w2Aw1MciEHChhOmZTtxlj7m4ks44v6pXs3Slijp7XIl0UuchNgvyQyBB/EnNbXblnmyX8ByfpLqxNyMksPl0s5ytf8sx9MC4DXjQbmozzVjczFYkrkOWSB2fgqet9mqCfbUtPbk7eQp4urZ1ML1PPUlkO4xx8NZslP/pS9xaMeH9pSqZ/VlkrRJueZcO629fxN+GEs1yvxoTK7qY8uo7/gqoxzz0XoyOmo81qgmULdPPq80LIOjbUj/KGZTCJjZWVMH8u06spj3LcR3RdAKxA57gwe75bsC0Yw5CazylTJSBf1LWawosJBGaQjH8taBrjjwwRaaX1EY7B55VkQc=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(376002)(136003)(366004)(396003)(346002)(230922051799003)(1800799012)(186009)(64100799003)(451199024)(31686004)(36756003)(478600001)(66476007)(6512007)(6506007)(66556008)(53546011)(66946007)(6486002)(86362001)(31696002)(83380400001)(2616005)(26005)(38100700002)(2906002)(4326008)(6666004)(6916009)(44832011)(5660300002)(41300700001)(316002)(8936002)(8676002)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?QWlNNmF1c2N5TkEwVHJVMWVvVkpsaUJCUEhmUlFnQmJUT0ZkVjdlNVdreGRw?=
 =?utf-8?B?bzN1TUhzLzQwK3k0eWxyMkxYVlo1Y2JFemNzMHNrajNBZ09xSWVCK0c5WUVp?=
 =?utf-8?B?bDdaLzdCTCtDc2dZOXJ3Q1dJVjRmemhQOXladnhwZ0VQZG04bTVmMXdDcUhk?=
 =?utf-8?B?RVprbFlseGQwWmQxRVBia0YxMzhzemlldGNvT1h1Q2YyRmNSdXZGamZkeUNs?=
 =?utf-8?B?ZGVwRGJrdms2QnVkQk9UY1VzTjloL3prbjFVMFArRS95QTUyY2xUc0NFelFz?=
 =?utf-8?B?a2NPL3Q1QnIwQTVQV3lSaittYkRpMEpncWhkTzVvQjF4cngwVFNiblVjalN2?=
 =?utf-8?B?TGRrY2kzRTZkWmtHMWxCcncxdFdQa3JXa1lGdUZ3QlMvbTd1dTJZT1FXYkZE?=
 =?utf-8?B?LytieElid0IvVGhuSnFhbUQ3RHFsZnYzN01rc21aRXZBZWNEL3I4elJJRnZh?=
 =?utf-8?B?VWZzSGlrQi9sTGNNWVJHR0YxWkhKL2lCL3JVbXpVbTZIOEFMUjAxblgwc2lN?=
 =?utf-8?B?L1loVnRkcEg1bmphT0FlMGV4aENIOVFKUmErbCtFZ2FMRkUwWTNuWEdOc3d4?=
 =?utf-8?B?TWpTSVNUMTFubHVvTW96QUdydTNYZHF2M1dzTTVtN1BNbyt1ZEs2NWRKOWVs?=
 =?utf-8?B?cUFzaWVSL3pLeUd6bmJnQk9PVU5KYmpFNEdBTE02ZTZKVVZOVlFQdnArUE5H?=
 =?utf-8?B?S0xvM0Nic3pPdzhYSHQ5V3N6VlpIOUxJYVM0cTF4L0Z1SG1UNTdQcjlUc3Zm?=
 =?utf-8?B?RjByR0J5SG5DWjI2QzJ2cEJ1QmsvaDM2Wnk0Y1NFMC9SUmxMcCt2cXlnaDJq?=
 =?utf-8?B?TzNUWER3TytYdEsrS0IwRmJFc3oyakRlalRwWlJWWC9RdjBGMnN1SVhtaUlp?=
 =?utf-8?B?TWgrU2FyR0JPTVh2T1hlZDl6K0VudVEzb3dWdUVPbjJZU0ZkM3JIQlFVUlZB?=
 =?utf-8?B?a1dxOEhNVDRvUzUzOXdQeEdqb2JsS3U2TjFaelNkdDkxa01pYjhGdm5QNWI5?=
 =?utf-8?B?cTgxSHhPMmJqWnNIM1IwMUxYeFdYbEJCSzFWNjlmb0tXd3VNUjJPSHBLQmZ4?=
 =?utf-8?B?alg4UkkrYlA2dUVuMit4S2x6TGRWK0tqdHBvVEFlTTF6NjFqaEpGeWZ1MHIw?=
 =?utf-8?B?TVhBVDJhQ2VlajRTVUZ6ZmplM0Iyb0pFM0U0bGczVkRMaDBEVTZDTWprWmE4?=
 =?utf-8?B?YStnWi9sVHFkc0NmNDBodUhZam4vZGVaVVNiUTZRdDRtYXluZnFxOSswOW9n?=
 =?utf-8?B?Y09YeWI4RzQ3N254WUFqZVJneFBzelpwRmFEUXhJTUFMRzZvaHR0SnlCY3BO?=
 =?utf-8?B?QUZqakxiTGgxZGVkKzhVZnIwcU45YXJraXI3bWU2Q0JNNnQ2M3RXVVFFUnQv?=
 =?utf-8?B?MW9nMFV4d0pIekV5WnVLK0ZWaFljNi9kTXdwbno4T2dQbkYwWGtrZXdyLzd3?=
 =?utf-8?B?ci9KSEpKSm85anBJMWRnQWxONjQwQkxzYjZoajBhVGdxbURZU1h4UWFQVWtG?=
 =?utf-8?B?SUFjdlZTS1hnZXg4YmNMUDBDZWZ0MGRRVkJWUzkwZTNQazBjYlVGL3VBSTZ3?=
 =?utf-8?B?UjNBcDNNb2c3RGtyaEx5RWNrTlYveHhPYjBhWm5jdkdDRFIycXo3T29YZm1n?=
 =?utf-8?B?VXVkN1ZXNkpabVpOdFFvK0R0OFhndDZyZFZNRzZLODhFVS9WMjBYWGg1YlJm?=
 =?utf-8?B?OUIwa0ZDcUtRRnhLT1ZIZU1NYy9kWTliK1BjcGNxWlVjQWdybUxoUTdLZUc1?=
 =?utf-8?B?NWJITGVGL2E1b3NBdURpZUtKQkVmY2FMQXZ4anoxRTNlazBvTTVvRXd2TEwx?=
 =?utf-8?B?OVRKZmgzS1MyaVBROVlwOHJXOWVVemRtUVh3dGU5cDcvNE45L0J4Z0hHU1pJ?=
 =?utf-8?B?bXZRaFJNWUE1djlOMTBTWExrcFBqdVI3OHBlWitlMWhPeWJucWNVZzl0WVo0?=
 =?utf-8?B?eU9LaDYyY2NuZmZHM0FDVkd5dDFXSU5qWlByYzZSZG5ySlU3ZUMwVSsxbXBt?=
 =?utf-8?B?ZHNFZk03M1RrUWM0bC9SSiszYnFLUFdPV0YxbFU0Q1JtQ2dIc1VnNkNDQXFD?=
 =?utf-8?B?Q0ZOQldJR25xcWMvc0ZRNWtxRitlMjEwcENRUnNDZ0FwZUhHTUdRZTZBckFV?=
 =?utf-8?Q?J+w0/yC5o2nAxTDeZm2gArKqj?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	jH+48w5/u1bxfbS6hmVFVQO3hylkUEYXToQjluShz5xVMUFxkjGTjdxq4zOvjjk5iDaQx/Kw3H42TA1u6orwSU/K1fJG296a4piyHjqJerdDLjMKDyk2G/fQn9TpbFy01uYwan1KHhjmVFw+uP3vDQ04EHyxJWCWnVnr7QHC5Fipof2qHFiLkGmi5pmKvgLYwyJ/wvmwvNcpVwmUiTHhfb0Go2BRwcOH1YHPaiH75RiDqdaaENQbl2MJ0BtzUzOjdjxS6rC8PvsHLUzoLDvzHLzc/Ov3BrHHwQiA6Sj6QtKHPf/acphCf1FlkEd9Q6w+nU5xJ3cr+G4++x6mkC7pxlpP+llOlxvzC3noDaHh/XdKepaTDRYn8RaVlXrEOtB+a4mbFq7HG8hXGuqOqvqpmRBeXTy6Du7Q7scG0TBrrE90tU864bJaMhTU3m9mOcZoQI3UYPd5kgt7ClJbz0jnWkiqRsLe6JJp6PwaIHNrHGY8hacv+dim7D0cSLUZeyejSEtzrwUJYFTvxtXv4OCZbSIqPIlxm/AA0fby4BVmueNz4mXsTn8kcpXqsvS36P+jEFzWqOa//ejsGRL8+Ge3V2pfxPYLaqLUAtIuE/oR7Oc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f652b335-bc2a-4523-d36f-08dc0b514811
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jan 2024 05:11:31.1706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wdWnuJDS5ARiS109H33PWarlf8CMCBrFEkOK2NSkjC7rqNKFVpIrndFDTumv9qliVWBatv3macJ8DXVrWl3Tbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7155
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-01_14,2024-01-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401020036
X-Proofpoint-ORIG-GUID: 4OuaVTtCeir7PXB6MlyMjzKBmoRijfhF
X-Proofpoint-GUID: 4OuaVTtCeir7PXB6MlyMjzKBmoRijfhF

Hi Tao,

On 1/1/24 14:06, Tao Lyu wrote:
> Hello Arnabjyoti, Sean, and everyone,
> 
> I'm having a similiar but slightly differnt issue about the rdtsc in KVM.
> 
> I want to obtain the timestamp counter of physical/host machine inside the VMs.
> 
> Acccording to the previous threads, I know I need to disable the offsetting, VM exit, and scaling.
> I specify the correspoding parameters in the qemu arguments.
> The booting command is listed below:
> 
> qemu-system-x86_64 -m 10240 -smp 4 -chardev socket,id=SOCKSYZ,server=on,nowait,host=localhost,port=3258 -mon chardev=SOCKSYZ,mode=control -display none -serial stdio -device virtio-rng-pci -enable-kvm -cpu host,migratable=off,tsc=on,rdtscp=on,vmx-tsc-offset=off,vmx-rdtsc-exit=off,tsc-scale=off,tsc-adjust=off,vmx-rdtscp-exit=off -netdev bridge,id=hn40 -device virtio-net,netdev=hn40,mac=e6:c8:ff:09:76:38 -hda XXX -kernel XXX -append "root=/dev/sda console=ttyS0"
> 
> 
> But the rdtsc still returns the adjusted tsc.
> The vmxcap script shows the TSC settings as below:
>   
>   Use TSC offsetting                       no
>   RDTSC exiting                            no
>   Enable RDTSCP                            no
>   TSC scaling                              yes
> 
> 
> I would really appreciate it if anyone can tell me whether and how I can get the tsc of physical machine insdie the VM.

If the objective is to obtain the same tsc at both VM and host side (that is, to
avoid any offset or scaling), I can obtain quite close tsc at both VM and host
side with the below linux-6.6 change.

My env does not use tsc scaling.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 41cce50..b102dcd 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2723,7 +2723,7 @@ static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64
data)
        bool synchronizing = false;

        raw_spin_lock_irqsave(&kvm->arch.tsc_write_lock, flags);
-       offset = kvm_compute_l1_tsc_offset(vcpu, data);
+       offset = 0;
        ns = get_kvmclock_base_ns();
        elapsed = ns - kvm->arch.last_tsc_nsec;

Dongli Zhang

> 
> Thanks a lot.
> 

