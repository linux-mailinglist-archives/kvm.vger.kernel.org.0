Return-Path: <kvm+bounces-1452-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C141F7E7976
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 07:37:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 2816BB20F54
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 06:37:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4566AA5;
	Fri, 10 Nov 2023 06:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZHGKYIKR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jDLKBUs/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F7C663B7
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 06:37:20 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461DD76B8;
	Thu,  9 Nov 2023 22:37:17 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A9MZ1e9017324;
	Fri, 10 Nov 2023 06:37:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=0YH1EqL+qpUF+DPGaFKYlDN3Im9F966HxTXJJSnSkyo=;
 b=ZHGKYIKR1WfgnwIX3zShYVxuCRskqJOQhyvMeU/1rQHrDYCwJoaZKarbGfPi89PGowJC
 Yq3XSHZb1f2xWqLOTxweX26gFKG30hgJlkN/LorbWhnKTkaKUskRhaaUCwATaWatRh0H
 b2vbXptZDH4tInC+lV64d+10cbrnWpmsjPV3f7/vSseQLX5OBJmChDosZsuUC6lLILvL
 Kx+2CG0frN/EywsWIIUsrW0IMZn34d6tsYAHVHGABoD9V8l41ofCOSvvAFkjf+4Vt3zO
 XQaYuf147wy9CqEo42zSfsj/GnbDN1BnBOqaIVoz2mkeHWMKg+s7JcPOPsWJXlTt31xg /w== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3u7w235mf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 06:37:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 3AA66F8Y023772;
	Fri, 10 Nov 2023 06:37:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3u7w27rwhw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Nov 2023 06:37:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fl0Z5SJgxXF33N61MhJaCL2bgeqMaJPLy8crfwOZIC8ZG2m2x2OHqM0/xbz2E/YCR/QRyVjVDKeFpgq+/B6ayR/8ZVlCUuG2K5aPUlBT1A1s36sdFixVqqIer4lwuq5+w3ooKpHCdJ5c1Rk3pUQbQMWhlfNHeEGrxCT6TgUlA/lYB0YWHSAmAs6Rq1mz5Iqo+ffLC4zUhQoNncjP6XGzOeKr01X8+M2ozysaluRg5YfF3eQvqrv64RmOKsz4APcCnQbrVChbZwH7CAlGJGcSgri5Y3gGs1f92RA7G4EVuvyEwF4j2KYqACNoD0BW8k32QmFFPbiE4KAE1ApaRRUSXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YH1EqL+qpUF+DPGaFKYlDN3Im9F966HxTXJJSnSkyo=;
 b=JpTGYwEm/pLEj8ZYaEfQfmAvvlEq/avD/FCtQ4aqZzvn/xElCMWjB01aJXrMdnueT+RCmlyJZ2tqpyPAo9KYD1QkIfkgYeyCX3rri0y8BYiE+N+vgdz/A+n9aWknEDtR6Mhku93FTGf45Vl4nfEMxiUfsTshsBJnhTdK9PTTcG+BJZmJcUrIcTlDj2D04l4jq+qfnh2/7AcOcGiwkQROXTkxd1HdLAWUd1V7PMCfaKBQuBt8hFnz8Ei3nNTG3bi7b9J0vBc6/IXAzGMZLWkP1Z0sgpEO3olpREWyICAgj3yk9hHL4zBqRvC/vywcGBqQd7ukUvJwrbI5azLsBOqmDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YH1EqL+qpUF+DPGaFKYlDN3Im9F966HxTXJJSnSkyo=;
 b=jDLKBUs/lQY3lQZrt7SqzXEG5iSUU2D0Wnt3g7+z8g8vskpgvHoP9Qt2ukmVnQUQdctVJpNd4w8qFacL0WaFpTk6OFak5nnr9ArcZb7nZL3P96ld/HXGeCCPjSJgS4Cb/Tdx6lKo7vpxiAuZPgqlK+IIAeha0S9mwAIPN6/ypmQ=
Received: from BYAPR10MB2663.namprd10.prod.outlook.com (2603:10b6:a02:a9::20)
 by DS7PR10MB5119.namprd10.prod.outlook.com (2603:10b6:5:297::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6954.33; Fri, 10 Nov
 2023 06:37:10 +0000
Received: from BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777]) by BYAPR10MB2663.namprd10.prod.outlook.com
 ([fe80::dec8:8ef8:62b0:7777%4]) with mapi id 15.20.6954.029; Fri, 10 Nov 2023
 06:37:10 +0000
Message-ID: <6e101707-f652-73f8-5052-b4c6c351e308@oracle.com>
Date: Thu, 9 Nov 2023 22:37:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 00/10] KVM: x86/pmu: Optimize triggering of emulated
 events
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khorenko <khorenko@virtuozzo.com>,
        Jim Mattson <jmattson@google.com>, Paolo Bonzini <pbonzini@redhat.com>
References: <20231110022857.1273836-1-seanjc@google.com>
Content-Language: en-US
From: Dongli Zhang <dongli.zhang@oracle.com>
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0112.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::15) To BYAPR10MB2663.namprd10.prod.outlook.com
 (2603:10b6:a02:a9::20)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR10MB2663:EE_|DS7PR10MB5119:EE_
X-MS-Office365-Filtering-Correlation-Id: e55e9650-8eea-4b93-a4a5-08dbe1b7771d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	3iMSDWmY5IwKAhDb4moEOpwgGss5tVz9++x+ZmKxpaEkyh081XtPEV4xY7UmmI6QKVWlt6Qm4Ff5iCW5gQsVMvD4KrR/aP16Nl+/iuzjpREBIgcxEHKIcruZgSY/KuqJOe8BCTjrUZqoHYOrgzYXlX1la9utQgYjK6aQ21NePEUppBUtFaGmSEJ1s8a2LKQpK7jF9W7hgR/FoIZrf7AGidC0R/WUQ3yR6KK9Fe/HDsw2cFT+EUmsTTqrc6kS4Xb5wdFCiVDxFX3EMzGJ/oaaUsz/m5oI1Ts1MCs6NL7+mLd/HcgDwrAlh7dpnRE6S2eGJqqYkixUCeYE7gBqSpuJimUfkqZtV4jfc/oKdbPHokU8nxjOmTMMYdpuEQplo2o+R0kRqLF1kqWaQYjUmr57KhnAB2dNAAGATMgZiRXmS2+5zIDQl7giUSXhnvau21nGPb5lOm4hIlU91fWmKHj5ynp4P2d8lO5RFtRiHC+iGq9aO6a2i6k8L+cuUVa+PxykjFOoQP7ETSC+rCC1CSnzati1mayyPdaWQDyF/Kn6iZ3gIQ81DRTG/SUy0aRY7yCM9Ng+lG6MCTGY1NCUDTuiv02sVm3EJBaTlcD9STY5DKG129BV8z38sJF9jNiPOIX/2oz3AOx2QBNA38/KUWXQGA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB2663.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(346002)(366004)(376002)(39860400002)(396003)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(31686004)(38100700002)(8676002)(4326008)(478600001)(6916009)(6486002)(316002)(4744005)(54906003)(86362001)(8936002)(66476007)(966005)(6506007)(41300700001)(2906002)(44832011)(5660300002)(6666004)(53546011)(66946007)(66556008)(6512007)(2616005)(31696002)(36756003)(26005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UGZESnliam9Ca2RPVHFibG9abHNxQVZyV2NXaHhYRENINTBGTDdrSmZsS3RX?=
 =?utf-8?B?dWtuU3g4N0xjRXZyak9YOWtDWk4zUUtZeDVnTXlTdEoxUW5aS1NXK1lGWWVH?=
 =?utf-8?B?bWx2WWRNRE85L3gzbnBKVVhTVGx6S0o2dnJPaC9FQzNYWGJnNVZCTDdhWnlZ?=
 =?utf-8?B?QVBMWlZ6cXowRFcrMGYzSmN0d1d0amtpekQ5RmkwR0phcDUyOWNTNnFnejFK?=
 =?utf-8?B?SVI1dHhWc3Q0UGFiT0NBb3IxN2xlOFR3TnBGNzZlQjFmODg4RVdqdG15TFda?=
 =?utf-8?B?YlZwMUp0M0JHeTVETHZ2NmVyQ1QrRytXcThkL3lLY0RWcnR2Z3l5bWZMUzQ0?=
 =?utf-8?B?ODM1dnhMVm9TcmZ6Z1BUL3l3Mk9mbDFGZmd3S1JpZUhyQnZXYkNZNG1WWElX?=
 =?utf-8?B?blBXV0JDeFlHVUxmVnZrL3N6MzgrRUdLRzZ2aHJmRXRTcHBTVTMyY2pXMjNw?=
 =?utf-8?B?TTAwa3Z1QzBIZEI3YjNGc3FDZ0VOQzBZazZXYlp5ZUMzeXQ5RytpMTdKN2FV?=
 =?utf-8?B?OWZEeUttbnI1dGpiRU5SNmRRNWl1RlRzeFJlYVVtaDZjYUQ4S2o2ZlB1YUJp?=
 =?utf-8?B?QkVzVE9PTzAxbnY2dWd6ZXlHdzJ6VE9WcWx4TVpsTk5qYWluYlBkeTRJL2FQ?=
 =?utf-8?B?MjFDQ1REdUtoMmRWR0Q3TmNWZ243eU1pc1JUbFpZKzNGZEQ3dWQyaElKN2dZ?=
 =?utf-8?B?VkV3My9nVDJLcDFvK2FnZ1lLZVF1VW1DU2xzMnc1dEFHRTUxWVRmREhLdVo2?=
 =?utf-8?B?WHBYZzBNeE9Pdm03cWMwR0ZWRGFsSDZoeVQxMEFQU0J6SVRocktxbzluUVZp?=
 =?utf-8?B?OVEzZmVDRVZFZTJJa3B0S0czaEZHdGk3YjlOZUd3UUppZFJSdmVHTHFwVTk4?=
 =?utf-8?B?VU02VWVwOGQxVnpudkIyS2tpZmpqRW9FRjVldW5xSEdnckdIUlk1RFNhM2hE?=
 =?utf-8?B?V0VjbEF6eUFMTmw0R1B1RTVVVFlmNEo4L0tJbXoram5pTCtEWXQwaHExTDlm?=
 =?utf-8?B?VUt0Tm1ONmpQTlhjRng2NjZJclJYa1FycWpiaGphQWVLUUJCVWRxbXF3Q0xi?=
 =?utf-8?B?QjBlT29EQVZ1NWVobVpXcTl3S2F3cmR1Wkp5eDVZYWVVWFJBekhOZGN2blpj?=
 =?utf-8?B?ejdlSzNIaU1ualhDQmNsRS9vcEpZb0NnUENwWCs0cG56UnRVbGpHYkJMeGRv?=
 =?utf-8?B?bzFQZFljNWRxZlZqM1RJL2J5VlR2Njk2Z0oydXlzemhvcUN6ajh0RFdESnpy?=
 =?utf-8?B?cGFYYW5aQk5QYXRsc29makNFby96Y2lhMFFIQ3BzVkhzb1hCUm9GZEFWaWZE?=
 =?utf-8?B?OFlIcUZQejdoQXBqaVRVZkttVWh2cDVObkNDOFVPZFFSdXNnZC9YM2NCTDVi?=
 =?utf-8?B?RnFRS3B3cXNQSnNuMXg3cW1ZUlBvbk5rMWVOMDMxTFhObzQvVXF4UXM4VU42?=
 =?utf-8?B?aTVJWXBIdXJKRldxWjdrb2Jkcnl2TEpQYk14cW56ZVA3WnF6bU9lZE1RM01u?=
 =?utf-8?B?NTIyN0JkS0hhNWwvZUNVTDhRZDEzWXQzT2hzSjBLUFNFczNPQjlEaHVKQ2Ey?=
 =?utf-8?B?TXdQbVJjUU1ySHhQTkRKOVNPQ1ZjUUFGeGQxSUxVS0laSWluTmc5RDBSNUFn?=
 =?utf-8?B?SmdoMjY1SmpXTHZqRHB6dWJ0ODRiNnpqczFSWEkrM3AwOGRTMFROWlY3OE9z?=
 =?utf-8?B?OHZxYU1MVDBsUmk0SGNCWmFjM0tVU2NWaWlWSUR0b3NEUDJmL3hPRXliTVpG?=
 =?utf-8?B?S3dWWHN6REcvMzkrRFIyRHU5VVlPakFkblpLZDc4bldKRzJZMWI2bzUvUHhk?=
 =?utf-8?B?OXV6d2dzNXcvZEludDUwS0lrNnlORlJvRU1aTVZ6V0tRZEprZ01oYU82NWMz?=
 =?utf-8?B?TjkwZGQwOUE5RVNwVEVsZnpmSXdEMWNVcFZOWUdxalZrWlY5akI3aERIOEVK?=
 =?utf-8?B?NzM2R2drNVc0dFJUdkppVkJBSVlvY3dyM3RFZXBhUEpXYlF4SkpPa0I1OTZR?=
 =?utf-8?B?VWxGbk5EU2F3UWZuUEJqdTdLanMyV1VucXFQWElZdjMrbU1uM05HUFBNc1ox?=
 =?utf-8?B?UUxBVlNQOXRzcXlLQ2xwYmZJZXdZemxJTnhwVTIva2pWWVN4SkUzYklueTBJ?=
 =?utf-8?Q?MXaMLpZ7kVMsV4NNoohwOkQXH?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	aNNctROhMKZuJBwpw9VYiuSsM08innvZ8m3+eEt4WiAz2y0nxw+KhIAM8I3+a833xxjzttEhLdqvagvspoXlmBVWLK4mqT2fpm5qcZGkHoznv8jkHcvjAzWRq0GIHKb/TyjeMjNtFNttW6fbqN7xS0ZutT1bJAucNmdRy6nNFcrFBkfmgXt5284NSDVshm0FOCvJSRSQkIRKYQRcwgWL1ViI7Q0uGv3Z9LmOgr9tOaFWGHKZdaQbBxqH3cVRsOMK5F55WM1tIcicMqbnzGk5R57+uqB6kBAhD+KBaWGJCpp6+iW4IUU+HIc3bM/n9Q0qGvedEI+C6zQE1FOvN4G4IEEv8S9KGW4IGW0eSVaiREaosxd4Q9pcqTZzORwP/jcU0bwDUTtyYrU4X1yWtS9Ic1o817YRI0fTrxsYIUwBOTWCe2NRw4TTSN0znePd3mteo4/+PzoE4JdZBIOpAY0y9TpoTDtnnbCApuCo6pWGgjkO0mB8K1FgTv5ymgk2MVkVsvkI3n3Qj0eEjphgMi7NVOW2go3yaOmUOVwuVn5AwPBtKB1xqDOSkKK7UCfImOMQdzsuc6Rde+7QZa10OR+bTGugkgHbY0o5rSXFvIvu4KnTbr/uvRPKc2g/U9+Y6IL4ZNAWSOuNxq03dJbv0KN5uBUCdhX3iMwq/SmrEYc0LheDHJ0DPGe+WwYb6Y69LO665E9EeBMNizapTMLbp4DdDKM8AgulyfWiruWxJpdsnWneN7EUp6a0/vmzzdLVnO19vw3itcoVNoTk8prAEQBJFgQwS8Q7Qvg3j+JPDbESR4aKlgojUbDMMJDsh7CEDbKLTaj2P+15d5HpKCEn7EJznicsKsFC92GJbVxw+1+BGaM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e55e9650-8eea-4b93-a4a5-08dbe1b7771d
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB2663.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2023 06:37:10.0114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jD3o0b7P8SGWglVodAAxHRy2vpldF1LGx5C58pKYlinW9bs4SYics5C+QodtXTgFZlGIHAqjG8Wx1nsYjsC2NA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB5119
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-10_03,2023-11-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=675 phishscore=0
 spamscore=0 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2311100054
X-Proofpoint-GUID: PVg2GsVJvK3m4xw0Rghh8yWiFuGBSIpg
X-Proofpoint-ORIG-GUID: PVg2GsVJvK3m4xw0Rghh8yWiFuGBSIpg

Hi Sean,

On 11/9/23 18:28, Sean Christopherson wrote:
> 
> base-commit: ef1883475d4a24d8eaebb84175ed46206a688103

May I have a silly question?

May I have the tree that the commit is the base? I do not find it in kvm-x86.

https://github.com/kvm-x86/linux/commit/ef1883475d4a24d8eaebb84175ed46206a688103

Thank you very much!

Dongli Zhang

