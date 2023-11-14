Return-Path: <kvm+bounces-1692-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3EE697EB59A
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 18:36:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D8AF5281275
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 17:36:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7BC272AF0A;
	Tue, 14 Nov 2023 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="dBfRdBpI";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nHwUoLaM"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8721A2C180
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 17:36:02 +0000 (UTC)
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20947BD;
	Tue, 14 Nov 2023 09:35:59 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEGi0dt007364;
	Tue, 14 Nov 2023 17:35:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0O5EYZcfLxtQB1MkaC/yS3MDIH/+qtBGJB8crYmKnf4=;
 b=dBfRdBpI0XE2631EHSXYjCPxrv2mYqGzfBG1sAXedlAU1QnrRHbfH7VzU3KSP4zyoraW
 oufF7VQeIWnad329xYa1Jxyf1RPERoOcTFj9H+i3scBXVnRBR1NcHWCqd0DSXA65vvE8
 fGZuUEhNhi4x89EUcqY+/qwCxwhaGZC1omexadDtXYxCeFIWy+Ub87OPY4hUufCu82rr
 6BRtdoPMwWbk1//4gZxRGl+90KDcor4zCY/DmaAaPHasVGLoTJtDLjH0Wg8FMbA3s9IP
 kTlj5vX8U9zhv0euQIh+xrmTseGBUM4npIVvdpgYmBuaTA5F2svAOZRVuKzuIRyM+dWy cA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ua2mdpbs6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Nov 2023 17:35:50 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AEH8eEh014858;
	Tue, 14 Nov 2023 17:35:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2101.outbound.protection.outlook.com [104.47.70.101])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3uaxqrwaj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 14 Nov 2023 17:35:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZEshxdZOjbqXslaxoF93ASfRpb0IYx+WAOCYY4ovaF+8HPfFmWk1VVdBdHlpKXUHzatCtqCAqENEA0ncxV3fpXqYeDgrZny0LDRHZ9cQGxzvOP0bBiVMc71DITyNyljR22YlgU++pBAs4ZR2aJCFeJW/n5GR0dZPNyiEmgNajgeGmRv3M2SIvGi6/9hrDG5lxcWN2En39qlgUfyrCRcf6FEOeHrITbRrBhcqFUVQXd+TgXvkRZryk3pMAgDsPxd+a/NmbQPA6b06xyAbAP5MatkwuajEQRjp7xv8X+V7V0xGmhvQzqQn6SQAMr6+A/IiKmMbAz01edaKJVcomjSUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0O5EYZcfLxtQB1MkaC/yS3MDIH/+qtBGJB8crYmKnf4=;
 b=PfZslqtDnhnkAOGW8W29Q3NvOHNwgiPUHzcuhGkqlbtXHzTTiKMgEz/5srjlUhMI6JMtODo/Bkxltvs8XXyBnTV6fuEcKnsyXNRGrdYSunZwvDXIy4YXHaPd4pywMdanOsIMUG5kzIZhxszDjBuK+zKy15Vt7/jV6rnwhLW1Xv+OYiQzp5sVpwC9MMsfeX8pNbQ1bdwjNlNh7G7ageGKo7nlnvYEJuMCCeWGJ9k1huetSlyJ+8z1cvctCDcb3QYaJmc2rP1VYwEF8CGcJWedNugtx+qNMiTNgd/b2ApevU432CplMXNzbNBHxI+9eKSfxf3Wh1qplUYXhb+wftG7Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0O5EYZcfLxtQB1MkaC/yS3MDIH/+qtBGJB8crYmKnf4=;
 b=nHwUoLaM9lpOrAA53Zk6LzDhsuecN+NQ4kKx1273K+5L4dx2HoW5FB+o5JbJUm5gRSCBVJymsXJMpFm5j8hut3xjl9bplbooSqNbps9jfbZTsh4hQezr58BXoCKeiwmTgFYF+KjxP2WnQRrmocE21KawfHUnScIYwe95s33iaRc=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by CH3PR10MB6787.namprd10.prod.outlook.com (2603:10b6:610:14c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6977.31; Tue, 14 Nov
 2023 17:35:47 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.6977.029; Tue, 14 Nov 2023
 17:35:45 +0000
Message-ID: <0e27a686-43f9-5120-5097-3fd99982df62@oracle.com>
Date: Tue, 14 Nov 2023 09:35:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH] KVM: x86: Don't unnecessarily force masterclock update on
 vCPU hotplug
From: Dongli Zhang <dongli.zhang@oracle.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20231018195638.1898375-1-seanjc@google.com>
 <e8002e94-33c5-617c-e951-42cd76666fad@oracle.com>
Content-Language: en-US
In-Reply-To: <e8002e94-33c5-617c-e951-42cd76666fad@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PH8PR21CA0022.namprd21.prod.outlook.com
 (2603:10b6:510:2ce::7) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|CH3PR10MB6787:EE_
X-MS-Office365-Filtering-Correlation-Id: 6a062397-fd06-4c3a-6ba1-08dbe538218a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QaIQkguRlYO45/0eVWEuuKuipuNrIbS+bkGMjAKtuGW9EJhXmnCiqnHlPvybMmX2G6/egRdi6OWvlCtSpalTzEMYWhywbO4DYN6qOojeyxH/Xgp/2jsae1Nk+vt9iibY2ghq25o+z03h/SIzybsOQXri95q1VzGFA4TGGO4+aVmFDGnxk/lJBnF/q3maBruNGusI+meYvi+qf6XeObZ7dmFl85RUt5J83VrAk8R2967W8DkAe3wpzv8hqpQ6yZpIzsd5hzWRcEem2o4FTPuRzvLOCZ/SDYd5IPg+zdK0+bj5RzhUwGgm8IZX4JwGmCmdsLO4xQbtvJsLbxBOfMBwnvanWvFhMFKnh++YneaD6SkRCzKw3OQ+nZX0POxGM1YhJ7TwEIUp1nURYCY+DKk9j0fKU/cUgVmzrfxh2YFlLXGBBXJTHN6YDCrB9Kdd1y/h1mO48QDDdzCCXqBNhKIymVBErSjCJFb5Ry0U4SmDQEJkGpPJo8M5pJcfwIQOPLS9GpL6gDdDBNnffTaXfiemmE6OH/LvF6YlHtlwD41yfdZPWpp1lj9Jf2EoNBDegZKvCGcJvXxhTa68yf54ejZyIvjVb1aElUOH3AwA3PtQwEjqtnW81dPeo6q138mVmrcAfDwFVf64jHr/mY9wjTHJUMc8E/Rnc+Qjh248MQuwTuA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(346002)(136003)(366004)(230922051799003)(186009)(451199024)(1800799009)(64100799003)(83380400001)(4326008)(36756003)(8676002)(8936002)(316002)(6916009)(38100700002)(41300700001)(54906003)(5660300002)(2906002)(15650500001)(44832011)(30864003)(478600001)(6486002)(6512007)(966005)(86362001)(31696002)(66476007)(31686004)(6666004)(6506007)(53546011)(26005)(2616005)(66946007)(66556008)(21314003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?R3BGT3dnckd3aURRVjVZOVBGdzFqaUtBcTd1QUZIb0JoVDR4MXJhUTJjYTMy?=
 =?utf-8?B?Mk5BTk5DSzV5eUcxMS94VG8xbnIyUkZ2NklCWVEwQk5meDlZQ0wwZlRlbHRQ?=
 =?utf-8?B?dnFhV1lzRENNa2ZBdjNTWlhtblQ5dUJlVDl4dG04YXpFMm9xZUNuczZyZXZi?=
 =?utf-8?B?YnZCSXNjZElSelRxV2FaSzBUUncwT0VET0xwcTU0RzVWMXR6L2NTQnc4K2Qv?=
 =?utf-8?B?UGVEV3B0V1g5VUo2WkowcXlHK3orY2dQZG5mdDRHZWZmQ1RIOTV3Rnd2RG1z?=
 =?utf-8?B?YnJ0OWowSmxOTWpINzR0aldyOFllZFhwOFZRY1N0eEF1ekdvRlRnOHNVdmJt?=
 =?utf-8?B?VGJxL01GVHkzUmFHbmR5NktFS2pJMm5Wa28xVTJyemRYUEVBRTlqcVAzNjB5?=
 =?utf-8?B?VmdjWnQwWS9sRmRxUFFadmllMm1jbms4N0g4dzFqdUtXcnpVV1UxSlpzNUt5?=
 =?utf-8?B?TzNHdVU2bXdvOEdBRWFJRmloMUFHeUJlZU5raEpMUis3NUlHclUwdVpSS0V5?=
 =?utf-8?B?MlVLbUdtdTNUQWNRY3FTL25STlRwaDZVeStQS2pUWlkxQWpsVEs5L1pMZUVC?=
 =?utf-8?B?c2RBSW5ZaXpBYkRyc2l5bkgvVlpjcEhLdDExSFFBN2d4WWMxZXZZSGJJL01j?=
 =?utf-8?B?RjgrQlFibi96Z2FyZldhSVNYSjljVE4vVHdOSFZWSHZUMXM3b0NUV2xYMWxu?=
 =?utf-8?B?Nkhmbk10T2tON1Vabmk0TVNDc242ZUhPZDJ1TXZtbHI5bzBaMWQvZ1BXNitY?=
 =?utf-8?B?YVY0cXFsTHBtMDdlSmV1VUpmcThtMjlLVXpOdzEzWnhQRUpZV1lmL3JFQ083?=
 =?utf-8?B?UnMxdWs3T1ZscXhTalhNc0xyazhTaDRtU1Y5UHZUZUhndlA5WUJmVjl5U1Ur?=
 =?utf-8?B?WkRQYWU5azhtbHVUZ2JtbWRHV1RPMGdlQWtqWUJHRlJWU3BOT3ZITWh1UmQ5?=
 =?utf-8?B?TVNIRDlsMzRhUFdQc1FJT0dLQzV6YmJzSmhoN0xYTmpDcGxIN2VWV1hJbjgw?=
 =?utf-8?B?ZzNPK1BqblB1dXJYWjhxWG9scjd0Y3VyeEljZDJ0QW1rZlQ3TjZxMUtHWkRx?=
 =?utf-8?B?M2E1eS9KUE5jUWhPdCtTQ3lEcTlaUzQ4VEpKSHJRamVWajc5eXhCNGlXaER5?=
 =?utf-8?B?NXZtVlFDRkpWZFJsWXBTUmNsMUdCcFVpVmI2ZE5BVzlvanRwQkVKT09FUktu?=
 =?utf-8?B?a2d6NWFabktYZllaQjJ6b1hWbFE4QzJtaDJoUkxRMVlOdXFkeGc5aGpNRkN6?=
 =?utf-8?B?cS81NEJmMFMycUxSZUhzRnFBQ21Jc3haZ3Mwck9CQnZRNDJwZWN2NklvOGIz?=
 =?utf-8?B?aFJaZElLVlhqaFEweGM2STdWN25tRExvejFvUTlldVhUcXZXUm1CaTBTTFQv?=
 =?utf-8?B?UENuZjlEaWQ2RkJrZ3hrQ2tQLzR0SjlwVDBCUjI0LytuekZBMHZJeSs1NXVp?=
 =?utf-8?B?Q3ozVzNpdk1jdW1sVmdyZFdYVTB1YzJmMGxGcWUrMTZpUTJGNkF4MG1LOXZh?=
 =?utf-8?B?N3QwZHlyTUsybTRDQWNOaTd4eG1tVWJ5ZFRMS3VHdDV2VDQ1TzFoTWRNbVly?=
 =?utf-8?B?QXM5bHBPZGYyZEFQRjlMejFBTGM0SEFoMDA0R1hUTFdQeEdMeW5mbGJEYnRq?=
 =?utf-8?B?UXB1QUhKb011cVRhSE90QWxodmpaUVB0MDdMbXdONE9aTVZ4Z0VYNGZqRUo4?=
 =?utf-8?B?b3htYWFWRzdabnplTldoWnFpVUFJQzg1TVF4cThaK1lqQkNoUmJvb1F4VzlE?=
 =?utf-8?B?UnI2SHFmRVdsZDFrc0s2RGFib1JXdEswNGdzcTdQck4yN0NGeWc4aUpOTC9K?=
 =?utf-8?B?dHYyWFNrV3JHcGswRCtydnRpcmtSd0JVVytKbTNsQzRZR1JhSlBiL0UvSFFh?=
 =?utf-8?B?d0I0ckpPemcwZ0VJQTM5ZTNPdlI3QlBQd0VmMVJ5ajN0ZUljNEpRYkI5TGcx?=
 =?utf-8?B?V1ZxWmN0bGF5ZDlWWkQ0cHZOdWdQWXhKdHgwUmhhK2RXV0lBbkRZaitiVE9E?=
 =?utf-8?B?TlZtbDVvS0w1RXNJSGJVQXBqQ04wNURXNTdiaTBRYkVFK214RncvUlgrWnpq?=
 =?utf-8?B?RnN0V3kxMU1kYjZjSHlpWDhQZU9lTFVuNVloS3FiWnVJcnBBSGlGcmRXaFFP?=
 =?utf-8?Q?2izNOHBIY5LFFqWdvyWwrRIdv?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Y31xc0syWmupYRnj92miEk/m7UtluzSAoKYD+mYHIDDIdnndq1aR2f2BP2aQ1NYSFjPFV2G7tg5XHaRssaiAoZ4+AGV4zFyc8xSgwJDCseuJZqg9En6ONnyS3n9N7VZn13ju2fMLYw35Tr4WGgNB9vTUisL+aOBa/cDg3xEig3vKl7fyRKhHojd1VzpqN3/fqzOcfKm/OQjsWqi1Tf+Nl3Jv33+Xo16YEKkZMxCIXa2jTvT8hPNBAtJyxyA7iwuN0q3beEB5diIbakf62kGZWoDZWGMkf/JzVWFqbD6YWJKIZndXluWhSipWZUUAfMmNHPCvpu184I/nLXe5hPRVR3pEgqzCOD+ONRmtVn2/6uLL5tnxb7mxq/7E8sZEHvtsoezc38fU7arOBn27NWCrMY8cXQnojXuzjUU0lxY7GSy5alvWSA0mz2Cx/sPvzPLT1KoMjH0iz964PWp8MPjiQU1MeclZcycAdQZikwzS1E/YIuVy7NjbuVAuNlsrkHNRDDUo/eLL7otoQwKWJ9jHo8lUWw2xVXukCtqUIBgi3ApTHjIcQzgqaSsdS+ionbAih/el4/KQLw7uxTdHpeD9dXNc5CWOqdAVFswu+T2GQpk+BH0MoDLcFoV/qwvcf70amFkNJ7DckdvU2LVonBHQ1So6dEtUPm1igfIpSAXbPDGJfDcVb93tg8WDdwJZPu4KhrRsbgY0JfIUzI/wHLzNXpOBHEIEPwWxGS763SB3h14e8LIWunEpsFHKSScrxp5TaBA7dy3Jh/z9A4KsUlhJa1GoaW3UtOaQghpXlfurR2iVuMAbh0X6wKBTGvJH2+We/+K2Li59oizezv8glk6AauXjDqwrCbX4T8SG1UUqA7o=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a062397-fd06-4c3a-6ba1-08dbe538218a
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2023 17:35:45.2378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 12KQuh6x4AjBVdsZ7drISxzufiFaU0S3kpRpnlbWJMQSOFT+LZdO+xi9APKBiFjtCL9M/1bl5YRlNeRzX4TZdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6787
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-14_17,2023-11-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311060000
 definitions=main-2311140134
X-Proofpoint-GUID: Vb1Wo5QQvdDZxK1g_pSZiVz1x3qeqJrF
X-Proofpoint-ORIG-GUID: Vb1Wo5QQvdDZxK1g_pSZiVz1x3qeqJrF

Hi Sean,

Would mind sharing if the patch is waiting for Reviewed-by, and when it will be
merged into kvm-x86 tree?

While I not sure if the same developer can give both Tested-by and Reviewed-by ...

Reviewed-by: Dongli Zhang <dongli.zhang@oracle.com>


Thank you very much!

Dongli Zhang

On 10/20/23 00:45, Dongli Zhang wrote:
> Tested-by: Dongli Zhang <dongli.zhang@oracle.com>
> 
> 
> I did the test with below KVM patch, to calculate the kvmclock at the hypervisor
> side.
> 
> ---
>  arch/x86/kvm/x86.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index b0c47b4..9ddc437 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3068,6 +3068,11 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>  	u64 tsc_timestamp, host_tsc;
>  	u8 pvclock_flags;
>  	bool use_master_clock;
> +	struct pvclock_vcpu_time_info old_hv_clock;
> +	u64 tsc, old_ns, new_ns, diff;
> +	bool backward;
> +
> +	memcpy(&old_hv_clock, &vcpu->hv_clock, sizeof(old_hv_clock));
> 
>  	kernel_ns = 0;
>  	host_tsc = 0;
> @@ -3144,6 +3149,25 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
> 
>  	vcpu->hv_clock.flags = pvclock_flags;
> 
> +	tsc = rdtsc();
> +	tsc = kvm_read_l1_tsc(v, tsc);
> +	old_ns = __pvclock_read_cycles(&old_hv_clock, tsc);
> +	new_ns = __pvclock_read_cycles(&vcpu->hv_clock, tsc);
> +	if (old_ns > new_ns) {
> +		backward = true;
> +		diff = old_ns - new_ns;
> +	} else {
> +		backward = false;
> +		diff = new_ns - old_ns;
> +	}
> +	pr_alert("orabug: kvm_guest_time_update() vcpu=%d, tsc=%llu, backward=%d,
> diff=%llu, old_ns=%llu, new_ns=%llu\n"
> +		 "old (%u, %llu, %llu, %u, %d, %u), new (%u, %llu, %llu, %u, %d, %u)",
> +		 v->vcpu_id, tsc, backward, diff, old_ns, new_ns,
> +		 old_hv_clock.version, old_hv_clock.tsc_timestamp, old_hv_clock.system_time,
> +		 old_hv_clock.tsc_to_system_mul, old_hv_clock.tsc_shift, old_hv_clock.flags,
> +		 vcpu->hv_clock.version, vcpu->hv_clock.tsc_timestamp,
> vcpu->hv_clock.system_time,
> +		 vcpu->hv_clock.tsc_to_system_mul, vcpu->hv_clock.tsc_shift,
> vcpu->hv_clock.flags);
> +
>  	if (vcpu->pv_time.active)
>  		kvm_setup_guest_pvclock(v, &vcpu->pv_time, 0);
>  	if (vcpu->xen.vcpu_info_cache.active)
> --
> 
> Dongli Zhang
> 
> On 10/18/23 12:56, Sean Christopherson wrote:
>> Don't force a masterclock update when a vCPU synchronizes to the current
>> TSC generation, e.g. when userspace hotplugs a pre-created vCPU into the
>> VM.  Unnecessarily updating the masterclock is undesirable as it can cause
>> kvmclock's time to jump, which is particularly painful on systems with a
>> stable TSC as kvmclock _should_ be fully reliable on such systems.
>>
>> The unexpected time jumps are due to differences in the TSC=>nanoseconds
>> conversion algorithms between kvmclock and the host's CLOCK_MONOTONIC_RAW
>> (the pvclock algorithm is inherently lossy).  When updating the
>> masterclock, KVM refreshes the "base", i.e. moves the elapsed time since
>> the last update from the kvmclock/pvclock algorithm to the
>> CLOCK_MONOTONIC_RAW algorithm.  Synchronizing kvmclock with
>> CLOCK_MONOTONIC_RAW is the lesser of evils when the TSC is unstable, but
>> adds no real value when the TSC is stable.
>>
>> Prior to commit 7f187922ddf6 ("KVM: x86: update masterclock values on TSC
>> writes"), KVM did NOT force an update when synchronizing a vCPU to the
>> current generation.
>>
>>   commit 7f187922ddf6b67f2999a76dcb71663097b75497
>>   Author: Marcelo Tosatti <mtosatti@redhat.com>
>>   Date:   Tue Nov 4 21:30:44 2014 -0200
>>
>>     KVM: x86: update masterclock values on TSC writes
>>
>>     When the guest writes to the TSC, the masterclock TSC copy must be
>>     updated as well along with the TSC_OFFSET update, otherwise a negative
>>     tsc_timestamp is calculated at kvm_guest_time_update.
>>
>>     Once "if (!vcpus_matched && ka->use_master_clock)" is simplified to
>>     "if (ka->use_master_clock)", the corresponding "if (!ka->use_master_clock)"
>>     becomes redundant, so remove the do_request boolean and collapse
>>     everything into a single condition.
>>
>> Before that, KVM only re-synced the masterclock if the masterclock was
>> enabled or disabled  Note, at the time of the above commit, VMX
>> synchronized TSC on *guest* writes to MSR_IA32_TSC:
>>
>>         case MSR_IA32_TSC:
>>                 kvm_write_tsc(vcpu, msr_info);
>>                 break;
>>
>> which is why the changelog specifically says "guest writes", but the bug
>> that was being fixed wasn't unique to guest write, i.e. a TSC write from
>> the host would suffer the same problem.
>>
>> So even though KVM stopped synchronizing on guest writes as of commit
>> 0c899c25d754 ("KVM: x86: do not attempt TSC synchronization on guest
>> writes"), simply reverting commit 7f187922ddf6 is not an option.  Figuring
>> out how a negative tsc_timestamp could be computed requires a bit more
>> sleuthing.
>>
>> In kvm_write_tsc() (at the time), except for KVM's "less than 1 second"
>> hack, KVM snapshotted the vCPU's current TSC *and* the current time in
>> nanoseconds, where kvm->arch.cur_tsc_nsec is the current host kernel time
>> in nanoseconds:
>>
>>         ns = get_kernel_ns();
>>
>>         ...
>>
>>         if (usdiff < USEC_PER_SEC &&
>>             vcpu->arch.virtual_tsc_khz == kvm->arch.last_tsc_khz) {
>>                 ...
>>         } else {
>>                 /*
>>                  * We split periods of matched TSC writes into generations.
>>                  * For each generation, we track the original measured
>>                  * nanosecond time, offset, and write, so if TSCs are in
>>                  * sync, we can match exact offset, and if not, we can match
>>                  * exact software computation in compute_guest_tsc()
>>                  *
>>                  * These values are tracked in kvm->arch.cur_xxx variables.
>>                  */
>>                 kvm->arch.cur_tsc_generation++;
>>                 kvm->arch.cur_tsc_nsec = ns;
>>                 kvm->arch.cur_tsc_write = data;
>>                 kvm->arch.cur_tsc_offset = offset;
>>                 matched = false;
>>                 pr_debug("kvm: new tsc generation %llu, clock %llu\n",
>>                          kvm->arch.cur_tsc_generation, data);
>>         }
>>
>>         ...
>>
>>         /* Keep track of which generation this VCPU has synchronized to */
>>         vcpu->arch.this_tsc_generation = kvm->arch.cur_tsc_generation;
>>         vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
>>         vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
>>
>> Note that the above creates a new generation and sets "matched" to false!
>> But because kvm_track_tsc_matching() looks for matched+1, i.e. doesn't
>> require the vCPU that creates the new generation to match itself, KVM
>> would immediately compute vcpus_matched as true for VMs with a single vCPU.
>> As a result, KVM would skip the masterlock update, even though a new TSC
>> generation was created:
>>
>>         vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
>>                          atomic_read(&vcpu->kvm->online_vcpus));
>>
>>         if (vcpus_matched && gtod->clock.vclock_mode == VCLOCK_TSC)
>>                 if (!ka->use_master_clock)
>>                         do_request = 1;
>>
>>         if (!vcpus_matched && ka->use_master_clock)
>>                         do_request = 1;
>>
>>         if (do_request)
>>                 kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>>
>> On hardware without TSC scaling support, vcpu->tsc_catchup is set to true
>> if the guest TSC frequency is faster than the host TSC frequency, even if
>> the TSC is otherwise stable.  And for that mode, kvm_guest_time_update(),
>> by way of compute_guest_tsc(), uses vcpu->arch.this_tsc_nsec, a.k.a. the
>> kernel time at the last TSC write, to compute the guest TSC relative to
>> kernel time:
>>
>>   static u64 compute_guest_tsc(struct kvm_vcpu *vcpu, s64 kernel_ns)
>>   {
>>         u64 tsc = pvclock_scale_delta(kernel_ns-vcpu->arch.this_tsc_nsec,
>>                                       vcpu->arch.virtual_tsc_mult,
>>                                       vcpu->arch.virtual_tsc_shift);
>>         tsc += vcpu->arch.this_tsc_write;
>>         return tsc;
>>   }
>>
>> Except the "kernel_ns" passed to compute_guest_tsc() isn't the current
>> kernel time, it's the masterclock snapshot!
>>
>>         spin_lock(&ka->pvclock_gtod_sync_lock);
>>         use_master_clock = ka->use_master_clock;
>>         if (use_master_clock) {
>>                 host_tsc = ka->master_cycle_now;
>>                 kernel_ns = ka->master_kernel_ns;
>>         }
>>         spin_unlock(&ka->pvclock_gtod_sync_lock);
>>
>>         if (vcpu->tsc_catchup) {
>>                 u64 tsc = compute_guest_tsc(v, kernel_ns);
>>                 if (tsc > tsc_timestamp) {
>>                         adjust_tsc_offset_guest(v, tsc - tsc_timestamp);
>>                         tsc_timestamp = tsc;
>>                 }
>>         }
>>
>> And so when KVM skips the masterclock update after a TSC write, i.e. after
>> a new TSC generation is started, the "kernel_ns-vcpu->arch.this_tsc_nsec"
>> is *guaranteed* to generate a negative value, because this_tsc_nsec was
>> captured after ka->master_kernel_ns.
>>
>> Forcing a masterclock update essentially fudged around that problem, but
>> in a heavy handed way that introduced undesirable side effects, i.e.
>> unnecessarily forces a masterclock update when a new vCPU joins the party
>> via hotplug.
>>
>> Note, KVM forces masterclock updates in other weird ways that are also
>> likely unnecessary, e.g. when establishing a new Xen shared info page and
>> when userspace creates a brand new vCPU.  But the Xen thing is firmly a
>> separate mess, and there are no known userspace VMMs that utilize kvmclock
>> *and* create new vCPUs after the VM is up and running.  I.e. the other
>> issues are future problems.
>>
>> Reported-by: Dongli Zhang <dongli.zhang@oracle.com>
>> Closes: https://urldefense.com/v3/__https://lore.kernel.org/all/20230926230649.67852-1-dongli.zhang@oracle.com__;!!ACWV5N9M2RV99hQ!N3CdrL7gBde6tjlPxmd0cuqYCaVI4VGrvIqGX5I5pNx-cL_srMa6VuXUwrFXAA7nMgPXRvzndIOCkz-r1w$ 
>> Fixes: 7f187922ddf6 ("KVM: x86: update masterclock values on TSC writes")
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Signed-off-by: Sean Christopherson <seanjc@google.com>
>> ---
>>  arch/x86/kvm/x86.c | 29 ++++++++++++++++-------------
>>  1 file changed, 16 insertions(+), 13 deletions(-)
>>
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
>> index 530d4bc2259b..61bdb6c1d000 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -2510,26 +2510,29 @@ static inline int gtod_is_based_on_tsc(int mode)
>>  }
>>  #endif
>>  
>> -static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu)
>> +static void kvm_track_tsc_matching(struct kvm_vcpu *vcpu, bool new_generation)
>>  {
>>  #ifdef CONFIG_X86_64
>> -	bool vcpus_matched;
>>  	struct kvm_arch *ka = &vcpu->kvm->arch;
>>  	struct pvclock_gtod_data *gtod = &pvclock_gtod_data;
>>  
>> -	vcpus_matched = (ka->nr_vcpus_matched_tsc + 1 ==
>> -			 atomic_read(&vcpu->kvm->online_vcpus));
>> +	/*
>> +	 * To use the masterclock, the host clocksource must be based on TSC
>> +	 * and all vCPUs must have matching TSCs.  Note, the count for matching
>> +	 * vCPUs doesn't include the reference vCPU, hence "+1".
>> +	 */
>> +	bool use_master_clock = (ka->nr_vcpus_matched_tsc + 1 ==
>> +				 atomic_read(&vcpu->kvm->online_vcpus)) &&
>> +				gtod_is_based_on_tsc(gtod->clock.vclock_mode);
>>  
>>  	/*
>> -	 * Once the masterclock is enabled, always perform request in
>> -	 * order to update it.
>> -	 *
>> -	 * In order to enable masterclock, the host clocksource must be TSC
>> -	 * and the vcpus need to have matched TSCs.  When that happens,
>> -	 * perform request to enable masterclock.
>> +	 * Request a masterclock update if the masterclock needs to be toggled
>> +	 * on/off, or when starting a new generation and the masterclock is
>> +	 * enabled (compute_guest_tsc() requires the masterclock snapshot to be
>> +	 * taken _after_ the new generation is created).
>>  	 */
>> -	if (ka->use_master_clock ||
>> -	    (gtod_is_based_on_tsc(gtod->clock.vclock_mode) && vcpus_matched))
>> +	if ((ka->use_master_clock && new_generation) ||
>> +	    (ka->use_master_clock != use_master_clock))
>>  		kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
>>  
>>  	trace_kvm_track_tsc(vcpu->vcpu_id, ka->nr_vcpus_matched_tsc,
>> @@ -2706,7 +2709,7 @@ static void __kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 offset, u64 tsc,
>>  	vcpu->arch.this_tsc_nsec = kvm->arch.cur_tsc_nsec;
>>  	vcpu->arch.this_tsc_write = kvm->arch.cur_tsc_write;
>>  
>> -	kvm_track_tsc_matching(vcpu);
>> +	kvm_track_tsc_matching(vcpu, !matched);
>>  }
>>  
>>  static void kvm_synchronize_tsc(struct kvm_vcpu *vcpu, u64 *user_value)
>>
>> base-commit: 437bba5ad2bba00c2056c896753a32edf80860cc

