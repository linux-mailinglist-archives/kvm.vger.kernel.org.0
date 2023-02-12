Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFF0E693938
	for <lists+kvm@lfdr.de>; Sun, 12 Feb 2023 18:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbjBLR5Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 12 Feb 2023 12:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229514AbjBLR5X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 12 Feb 2023 12:57:23 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E2E7BDDE
        for <kvm@vger.kernel.org>; Sun, 12 Feb 2023 09:57:22 -0800 (PST)
Received: from pps.filterd (m0127840.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31CAQEtO021725;
        Sun, 12 Feb 2023 09:57:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=Ujp4pP2ilzCj0KT6ukXLEsN4eTEncK3WGZ/ifZyJbu4=;
 b=jx8WS7V3daMJfamtd08j+SwRqHVkFyJPb9zE/HzktZf5NxhfONMcqmF/YLspOknHwGPl
 dzGAnUPdkMN9XULORQFI6atRSiiFx+7+7x2Tj8Fq+RFNC8Bo5lQ/w1wiYrCoQ2PldsVD
 GpHlstKd5M9n68GfTyLsD+KGxKTv5nBOsbGGwJUpgxLElsAiVP+VX9/ttudiCFNu8a/7
 /dNrnCwDdp7+DVohYkiEdOPbnFGSUupZ17M+f7P4vXycbeFbHqo3mu5lDtdYDjZ5nV8D
 5rHIr13ZnXdBfLhnI93KuykLNdLJOJip1N70hg/uEuRdrLYEIq6+sk9ZeFvQY9wGKwAC Ng== 
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2044.outbound.protection.outlook.com [104.47.74.44])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3np8812y90-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 12 Feb 2023 09:57:05 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqsWedcAgLKKP3YJKU5BTEGPSx99KDQmsbeqrxMPhC+cpI28J/fKDP4n3vn7fKZj51L+hnNpU0/vysA4nPHE8Trh5HJqOnZUXbimcSUkdG2eKM0D7pJaRHMkWrN6VLGvgQfRETn20rKoedStGfkSAzK257xME/5NMmWUImS1b3boGFsIa3zaDoUV8s5CJUlmShu06/hU87sxG5m4qbE4iXYisVMWTEH0bJXfmt/3rO9OQ6jN2w205O1iLqxZSGmsPckP3/5NSOXJe4eU0c5ICsk6a5CfdXDu8ft6jSH25HiVGyYZjkTWO1znsRfSMD9WUrwlJd2VA3NLnwedWrc42g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ujp4pP2ilzCj0KT6ukXLEsN4eTEncK3WGZ/ifZyJbu4=;
 b=X+39Vxqf7Vu+bwc329CJf+9nZaycmiFSKo9P8fljKwbc9vGa0IHtSOETjs2PlhKPZ0q2I0nWQ2vXSTErzRXWCzgb6XKMD/FcDg4bDYkrTEFEm2366H7SxgQT/SGo1rmmn8xDweJ3LRW/xcF8fuuWSss6dxPwy1QnYZFzJbzSTOg0nDs0Fp5nbpB4o1nutfUgps31nzB9BohDQP6WvfgfSRT0AhqrKoSTwa6OqE/85n3jzr9vlkiQ2Tr4F56S59Aquim0bE54IuzLTru6EMOoJmZco/Id/ZXYfzKNEpO4MuSavg+ZZJnX/w2//DLPOqhJkrHeOT+m5CRazKETua+DOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ujp4pP2ilzCj0KT6ukXLEsN4eTEncK3WGZ/ifZyJbu4=;
 b=wNA7Zr/+u8zDgyMQEfv2OetTxUCJsljQKN2caxdWFCBsocbD3Hr5yc8Wgfk7g+GQv6sag+oH7rQfggdCOeyuaj+hKDWGKxkVxNTY3UWthajDxLXL0MN+grGMBY6I4cVRYyPUutaEn0AcxrP+NPaDU12lsYqNxRqyBw84n1u2hQAw7HSkDew5RG7FNvmAd6Hq2Krx5z/oV1eqkz7Gf9e5RISN+3zf60ZcqmpqeLXEey3DQH7fp4sBuPJu7nYld+Jrihl27z7wGyz6RRs2MGI7nsOtdH9pKxbCeKxQR6w44Zy3QdvitswJwMfmGtzXEshM9jM7Qb8OTYmky2OGgBXZYw==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by PH0PR02MB9383.namprd02.prod.outlook.com (2603:10b6:510:289::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.23; Sun, 12 Feb
 2023 17:57:02 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::aeca:cda9:6785:bce0%9]) with mapi id 15.20.6086.023; Sun, 12 Feb 2023
 17:57:02 +0000
Message-ID: <f70c8ddc-6670-cfc6-041f-bdde9e99b82c@nutanix.com>
Date:   Sun, 12 Feb 2023 23:26:51 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        james.morse@arm.com, borntraeger@linux.ibm.com, david@redhat.com,
        kvm@vger.kernel.org, Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>
References: <20221113170507.208810-1-shivam.kumar1@nutanix.com>
 <20221113170507.208810-2-shivam.kumar1@nutanix.com>
 <86zgcpo00m.wl-maz@kernel.org>
 <18b66b42-0bb4-4b32-e92c-3dce61d8e6a4@nutanix.com>
 <86mt8iopb7.wl-maz@kernel.org>
 <dfa49851-da9d-55f8-7dec-73a9cf985713@nutanix.com>
 <86ilinqi3l.wl-maz@kernel.org> <Y5DvJQWGwYRvlhZz@google.com>
 <b55b79b1-9c47-960a-860b-b669ed78abc0@nutanix.com>
 <eafbcd77-aab1-4e82-d53e-1bcc87225549@nutanix.com>
 <874jtifpg0.wl-maz@kernel.org>
 <77408d91-655a-6f51-5a3e-258e8ff7c358@nutanix.com>
 <87r0w6dnor.wl-maz@kernel.org>
 <4df8b276-595f-1ad7-4ce5-62435ea93032@nutanix.com>
 <87h6wsdstn.wl-maz@kernel.org>
 <8b67df9f-7d9e-23f7-f437-5aedbcfa985d@nutanix.com>
In-Reply-To: <8b67df9f-7d9e-23f7-f437-5aedbcfa985d@nutanix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MA1PR01CA0172.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::16) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|PH0PR02MB9383:EE_
X-MS-Office365-Filtering-Correlation-Id: 16078ee1-32be-45f3-842c-08db0d228b30
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M6/GrmUP4YxID2c+AtAAVv+ONKPPWsG/N9cF3Syb+MSAAUvEaFk72q4W/xi32dK9lmUoJiBTKLgXoP6FDyqa54qIvSTDv9y+FHNIEcXelhhjjWC/dt0fjtLo3+sCg45UKODqdRaoCZxj6wP4wb9fUbqHA05DFoEbSEoPyHRU8k2mYoi+hHQv0UwGDU6fUgNMXercrLa5azesNHaBNSfN9WdpIdGn9wgqL32f+vdfFyKLgjdelM3skIAkKQOUsTdytSWncK+C/8OD8Yb+1FeBTFlD2+Y15JP8j5wWst63oKrG+ff8/g/F/JAvzix05OYhP+ozNcfsK0oHGlKCw3+ly7Pd9pgwMS6UsC2wl3ihkUYeuVgvSjLCAerPGFUyGYheA2oI0khJrzbiKNBJqAvXSRgL1TyQPER2czNbmP/uNPEpljyRmRkw4kMjUAmSQQ8KG8XBhuzKbbE7AiPw3D3R6bpjDIszGAKjLl3irJJNj8Wrisb8azsXGrOk8g/ivh7UC/OdMQAtgf1cJgKgNkd2Dp6CUtYSzYjqSjYAImPXaXqwAiODev5FwrTuARbCKUYtbD4VjOIh9kQsr2l9fPpeKaPxdCs7LLlEk7CH4L5+En+SSoOE76KPwbm7zI3BHAQ6EmJosRdfjFpQjyawzRadsW/9tNzyQAI0e1jWgqalf6bn4tDNaYFid4fsmB7YcAv/nUW64YCQtEBcyf1bOuvSv8/Nzvg20K/XkgSZx++wEbDGmJDUdI8PfV0DXdYePcTb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39850400004)(366004)(376002)(346002)(396003)(451199018)(6486002)(478600001)(26005)(83380400001)(36756003)(38100700002)(86362001)(31696002)(6666004)(107886003)(6512007)(6506007)(53546011)(186003)(2616005)(54906003)(66556008)(66946007)(316002)(6916009)(66476007)(8676002)(5660300002)(41300700001)(8936002)(31686004)(4326008)(15650500001)(2906002)(14143004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RzJTT0pldGJCTXJTTmNKd0JiRngzcjFGU3BoWTY5MmJSaGRVNTkwQWlzb3A4?=
 =?utf-8?B?Z3pFeEo3WEMxakMxenRqaGVIdE1hRWlVS0ZzWlRhMVNEM1VNMTBXL2lMU01j?=
 =?utf-8?B?VGcwOUNrT1dIbFJqTk1jdWxqSXFNUjd6Y25lbDJHcGlCZ21GOGVjMDZZdHlV?=
 =?utf-8?B?MnE1YitCVkNxQUxIRmU2S2hWd2toZEo1YkQ0Q3lQa1JFMEFkVlR6OGdGK3Ar?=
 =?utf-8?B?b01yd3JwNFhwcGpvR3FLaUx0TWNxdXRYZ0lqczBUdExZZVdQdXZIKzR2Tit3?=
 =?utf-8?B?TGRIcnJxUmZjL0lzQkMyQlg3OU9wTWo3Y0lGNFF0a0UvRHJmOU9XTlRyaHd0?=
 =?utf-8?B?SzlCN3pUNmNhemlkaTNJWmJkZUFFV1NPb1FyTWZiRGtabXZmOVhHZHM3Vmpy?=
 =?utf-8?B?NDBrK1NNdzl1ekJpNSsxeFdwOEZRZ01RK0JrRUpJV1dRSUxsN0s1cU9xdFVD?=
 =?utf-8?B?eFlqR1dLWXJxTzBRSFEwdzRCRkVPTlI3VTg1VnN0d0tKQUszR3ZPMVVjdnJD?=
 =?utf-8?B?RHFJcW4rMVFEU3hLR2g2NkFObkpsRFg0NktWR1VPekdweG4xaUVaWnl3d28z?=
 =?utf-8?B?ZHBaalVuaURlTlpVbmh6cWhXMWRUM0lHQnA5aVZJT1F1Y2IxdEVpZ1BDazJJ?=
 =?utf-8?B?TUg1Vk41aW4xRFk5VmNIcTVMc1JpUUt1RCtiVisvVVNIcmRHTldQMkRtQUcy?=
 =?utf-8?B?cmlENU94Q2hhRnZudGtBL3pWcUZ0MGYyaHVueTZGdnV6YzAxS1pXNjcwb003?=
 =?utf-8?B?Q0JPSUx1S2p1M0c1TkFYTFFBays3NDVXRUE5cTUyeGxBZnhiOHJ0RkR6dlUy?=
 =?utf-8?B?cktTZjBGTW52WXlGT1hsR05JczZXMWdpSHVLaGJmN2N0c01GdEpJbW9OcnNC?=
 =?utf-8?B?NzNWRHRRNnlmM3liei9HUC9vcGJwVTJGbXVzeUVwUFMyNEkvbytmYitjVENQ?=
 =?utf-8?B?Y2FnYWQ1TGt1dlF4SWs2eXN1NmoxTklGaGs2NGpPOVhlcndSQkJSWVQyOUtl?=
 =?utf-8?B?bDdndFltaWI2SHQwTDdPaUlIU0xMR1RpMmlPNHNWU1FBUEJKTjFuU3B0cEdp?=
 =?utf-8?B?R0lqV0U2bGtoeDFwM2xyQXlxTnNDZ29TbkVPa0F4RHQra1MwVlFNclg0WkVY?=
 =?utf-8?B?Uk1HQmZpZ3lxa2hLcXRUancwZVZrQlU3Y0dnMUpDQlNmOHQzOTM4VDVwUFJ0?=
 =?utf-8?B?L3F0OEZUTXZjTkdmSzI1WkcxcUJ2SkJTTE1CaStEUXU3dDY3Nkw5R24rb044?=
 =?utf-8?B?NWljYnFnZWU0dGVoUkpMWFg3Q0xSUkpld0c0aW5qblQ3NDExY1F0SWVCcGRa?=
 =?utf-8?B?N2hLWTFVbTV4ZFNBLzFaWEJ4dnlLcm54aFJoZzhRTXdaV00zMEh6SEZPaHM1?=
 =?utf-8?B?Zm0zcmdwRXIyNDk0MEcxWWJqMWdGZW9PaFd2aW8zV0FDUmg5elV2bkE0SkIz?=
 =?utf-8?B?SnlWWW1DelowTTJmTkhqTzVhY0V5OWlyMnVzYTFKR2hCR3dnRDdsdkhVdFFO?=
 =?utf-8?B?djg0ZFBxM2hlSW4xbnIxWDlyNmlWSjUrZnJXSmdueVNmaFpnRHJhcGMxZGdI?=
 =?utf-8?B?bnBteUJPbHhKT2N4UXJmRnE2ZzZ4NkdybFhZT0ZYc2ZBNk1DRUpZTXYxZEE3?=
 =?utf-8?B?TWRxS1JuVUdCRFh1WXhiWXJiSTFXc3h2dGFvbU5nR0w5N1ZEd3U0SDh3Zjl2?=
 =?utf-8?B?Q1hhdWFDMXFzRlNpK0FKeTNSVU5LaVV0cGFlaUFrMEV5R0tIQVFVNVZ1eERC?=
 =?utf-8?B?YjRHanpZRnVhNjFNUzRvdFVUWDhsemhhL2FMNDBrTHY2YUNlck5pWFhocWVF?=
 =?utf-8?B?WE5uNXJEbTY0KzVIWU1uT1psaWVUTWxmWVY3Q0ZHYkU0MzFQaEx0R210ZEg4?=
 =?utf-8?B?dUxQNzdKeEZUUlNhbVVLTXpXS0ZOUHlmaFdQMUVTbGRuTGQrTEhUVE1yQUox?=
 =?utf-8?B?SXZRQlZ4eW45UG5DRWg5UzRhOTBOY210dFlqYkdaTFdRY2VjVkdpK2N0bGFo?=
 =?utf-8?B?V1JXc3ZFSmFHZU9CZVhhVFhNVWllYWcySVVBRVhKV3pWT0dXbTlQcUhEdjBZ?=
 =?utf-8?B?cFBhRkUwbGszVUk0S3NNOHdRVXVvS2JCZUlpMmdkeXZPME15cy9yWDRNclI2?=
 =?utf-8?B?ZkhRSUdIRDkvRkI4MDl1UDdmbHBpN2l2Z2ZUOUpwZHVKUkw4TGRhR00yRm1L?=
 =?utf-8?B?cHc9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 16078ee1-32be-45f3-842c-08db0d228b30
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2023 17:57:02.2224
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zVWFckod05yVq+zn8GhuWwszYkoJNTvaK4jWm4OinW2ErqchNNa/byq4jMes+2z6OWF15oiRozmwRNJKH/yxeaiAjzQqKmGE3F1iP/sWORY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR02MB9383
X-Proofpoint-ORIG-GUID: NJBbiZWf4M4yocy65bf6L-gEElrVpZ2O
X-Proofpoint-GUID: NJBbiZWf4M4yocy65bf6L-gEElrVpZ2O
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-12_07,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 30/01/23 3:30 am, Shivam Kumar wrote:
> 
> 
> On 15/01/23 3:26 pm, Marc Zyngier wrote:
>> On Sat, 14 Jan 2023 13:07:44 +0000,
>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>
>>>
>>>
>>> On 08/01/23 3:14 am, Marc Zyngier wrote:
>>>> On Sat, 07 Jan 2023 17:24:24 +0000,
>>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>>> On 26/12/22 3:37 pm, Marc Zyngier wrote:
>>>>>> On Sun, 25 Dec 2022 16:50:04 +0000,
>>>>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>>>>>
>>>>>>> Hi Marc,
>>>>>>> Hi Sean,
>>>>>>>
>>>>>>> Please let me know if there's any further question or feedback.
>>>>>>
>>>>>> My earlier comments still stand: the proposed API is not usable as a
>>>>>> general purpose memory-tracking API because it counts faults instead
>>>>>> of memory, making it inadequate except for the most trivial cases.
>>>>>> And I cannot believe you were serious when you mentioned that you 
>>>>>> were
>>>>>> happy to make that the API.
>>>>>>
>>>>>> This requires some serious work, and this series is not yet near a
>>>>>> state where it could be merged.
>>>>>>
>>>>>> Thanks,
>>>>>>
>>>>>>     M.
>>>>>>
>>>>>
>>>>> Hi Marc,
>>>>>
>>>>> IIUC, in the dirty ring interface too, the dirty_index variable is
>>>>> incremented in the mark_page_dirty_in_slot function and it is also
>>>>> count-based. At least on x86, I am aware that for dirty tracking we
>>>>> have uniform granularity as huge pages (2MB pages) too are broken into
>>>>> 4K pages and bitmap is at 4K-granularity. Please let me know if it is
>>>>> possible to have multiple page sizes even during dirty logging on
>>>>> ARM. And if that is the case, I am wondering how we handle the bitmap
>>>>> with different page sizes on ARM.
>>>>
>>>> Easy. It *is* page-size, by the very definition of the API which
>>>> explicitly says that a single bit represent one basic page. If you
>>>> were to only break 1GB mappings into 2MB blocks, you'd have to mask
>>>> 512 pages dirty at once, no question asked.
>>>>
>>>> Your API is different because at no point it implies any relationship
>>>> with any page size. As it stands, it is a useless API. I understand
>>>> that you are only concerned with your particular use case, but that's
>>>> nowhere good enough. And it has nothing to do with ARM. This is
>>>> equally broken on *any* architecture.
>>>>
>>>>> I agree that the notion of pages dirtied according to our
>>>>> pages_dirtied variable depends on how we are handling the bitmap but
>>>>> we expect the userspace to use the same granularity at which the dirty
>>>>> bitmap is handled. I can capture this in documentation
>>>>
>>>> But what does the bitmap have to do with any of this? This is not what
>>>> your API is about. You are supposed to count dirtied memory, and you
>>>> are counting page faults instead. No sane userspace can make any sense
>>>> of that. You keep coupling the two, but that's wrong. This thing has
>>>> to be useful on its own, not just for your particular, super narrow
>>>> use case. And that's a shame because the general idea of a dirty quota
>>>> is an interesting one.
>>>>
>>>> If your sole intention is to capture in the documentation that the API
>>>> is broken, then all I can do is to NAK the whole thing. Until you turn
>>>> this page-fault quota into the dirty memory quota that you advertise,
>>>> I'll continue to say no to it.
>>>>
>>>> Thanks,
>>>>
>>>>     M.
>>>>
>>>
>>> Thank you Marc for the suggestion. We can make dirty quota count
>>> dirtied memory rather than faults.
>>>
>>> run->dirty_quota -= page_size;
>>>
>>> We can raise a kvm request for exiting to userspace as soon as the
>>> dirty quota of the vcpu becomes zero or negative. Please let me know
>>> if this looks good to you.
>>
>> It really depends what "page_size" represents here. If you mean
>> "mapping size", then yes. If you really mean "page size", then no.
>>
>> Assuming this is indeed "mapping size", then it all depends on how
>> this is integrated and how this is managed in a generic, cross
>> architecture way.
>>
>> Thanks,
>>
>>     M.
>>
> 
> Hi Marc,
> 
> I'm proposing this new implementation to address the concern you raised 
> regarding dirty quota being a non-generic feature with the previous 
> implementation. This implementation decouples dirty quota from dirty 
> logging for the ARM64 arch. We shall post a similar implementation for 
> x86 if this looks good. With this new implementation, dirty quota can be 
> enforced independent of dirty logging. Dirty quota is now in bytes and 
> is decreased at write-protect page fault by page fault granularity. For 
> userspace, the interface is unchanged, i.e. the dirty quota can be set 
> from userspace via an ioctl or by forcing the vcpu to exit to userspace; 
> userspace can expect a KVM exit with exit reason 
> KVM_EXIT_DIRTY_QUOTA_EXHAUSTED when the dirty quota is exhausted.
> 
> Please let me know if it looks good to you. Happy to hear any further
> feedback and work on it. Also, I am curious about use case scenarios 
> other than dirty tracking for dirty quota. Besides, I am not aware of 
> any interface exposed to the userspace, other than the dirty 
> tracking-related ioctls, to write-protect guest pages transiently 
> (unlike mprotect, which will generate a SIGSEGV signal on write).
> 
> Thanks,
> Shivam
> 
> 
> ---
>   arch/arm64/kvm/mmu.c     |  1 +
>   include/linux/kvm_host.h |  1 +
>   virt/kvm/kvm_main.c      | 12 ++++++++++++
>   3 files changed, 14 insertions(+)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 60ee3d9f01f8..edd88529d622 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1336,6 +1336,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, 
> phys_addr_t fault_ipa,
>           /* Mark the page dirty only if the fault is handled 
> successfully */
>           if (writable && !ret) {
>                   kvm_set_pfn_dirty(pfn);
> +               update_dirty_quota(kvm, fault_granule);
>                   mark_page_dirty_in_slot(kvm, memslot, gfn);
>           }
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 0b9b5c251a04..10fda457ac3d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1219,6 +1219,7 @@ struct kvm_memory_slot *gfn_to_memslot(struct kvm 
> *kvm, gfn_t gfn);
>   bool kvm_is_visible_gfn(struct kvm *kvm, gfn_t gfn);
>   bool kvm_vcpu_is_visible_gfn(struct kvm_vcpu *vcpu, gfn_t gfn);
>   unsigned long kvm_host_page_size(struct kvm_vcpu *vcpu, gfn_t gfn);
> +void update_dirty_quota(struct kvm *kvm, unsigned long 
> dirty_granule_bytes);
>   void mark_page_dirty_in_slot(struct kvm *kvm, const struct 
> kvm_memory_slot *memslot, gfn_t gfn);
>   void mark_page_dirty(struct kvm *kvm, gfn_t gfn);
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 7a54438b4d49..377cc9d07e80 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3309,6 +3309,18 @@ static bool 
> kvm_vcpu_is_dirty_quota_exhausted(struct kvm_vcpu *vcpu)
>   #endif
>   }
> 
> +void update_dirty_quota(struct kvm *kvm, unsigned long 
> dirty_granule_bytes)
> +{
> +    if (kvm->dirty_quota_enabled) {
> +        struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
> +
> +           if (!vcpu)
> +                   return;
> +
> +           vcpu->run->dirty_quota_bytes -= dirty_granule_bytes;
> +           if (vcpu->run->dirty_quota_bytes <= 0)
> +                           kvm_make_request(KVM_REQ_DIRTY_QUOTA_EXIT, 
> vcpu);
> +    }
> +}
> +
>   void mark_page_dirty_in_slot(struct kvm *kvm,
>                                const struct kvm_memory_slot *memslot,
>                          gfn_t gfn)


Hi Marc,

Please review the above code.

Thanks,
Shivam
