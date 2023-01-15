Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 261CF66B1A9
	for <lists+kvm@lfdr.de>; Sun, 15 Jan 2023 15:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbjAOOve (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 15 Jan 2023 09:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbjAOOvc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 15 Jan 2023 09:51:32 -0500
Received: from mx0a-002c1b01.pphosted.com (mx0a-002c1b01.pphosted.com [148.163.151.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 470BCCDF9
        for <kvm@vger.kernel.org>; Sun, 15 Jan 2023 06:51:30 -0800 (PST)
Received: from pps.filterd (m0127838.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30F3Hs2r008147;
        Sun, 15 Jan 2023 06:51:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint20171006;
 bh=jDog0z1/zJtpvEn2FQhTB2w6IYE1nPck22quUWu9s14=;
 b=atsNYeLC8/NqJfjvxnoubu+yoVpC2bOXgIYAAn6uS4YpgS8+/UVIYVad+jfjGbO6stSI
 oyoh/OiCddK7GsuGQVTTmWWHf4Mm7B0K8iIi5exOZZ9aC14CMl2fBW/6j8Tb1+IM4g83
 rPnGT1wy61AUq69Jbe6XT2kYvUT8iKcWHI9LAe8ir2O9I9G74qcSZ9c7V5p0izpV9A/U
 kKQI9WFfHWwKLANl7/HYKa7kKHRshVMUvSMZTPeIXNkmHyYFgdDHZsP4XTb3/kVIXtP1
 DNCW5eDkGVs533eMdJ6bWyC+fK/cN5njW5IxazsygzSUfZb6qSw4Spe++bjczspR24hN xA== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3n3vu5238b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 15 Jan 2023 06:51:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CMXOswrSfomj4ZyFCX+PQIXaonTNSLahb10vFdDfWoSyzEUcgDIuotfe1qWFpNe0djrtIqcKD9gZHQAkuqI0DkRYkwdOT6oOT3c2HwhIokPdjnHSwSVGlpvvKaaMk5bsyC1oyR1D/swgcSWPDy5elaCvwK0QA2PoOIBfmEFdeU8GB1MMBKUzG2qZ6gbuUaww6H5924Ho2U2U0wBKWTvgLuRAermDzQOWcoPoRqT25aRo52BdVV6W25qMRyltmdTi427XJXUK3F4y6ygs9HsCJLJ7VqEW5fiAdoMNNZ2dz6dLHHhD93+vLMwux3v4EUXg+jeRbsx71pHgSVFiBCXxIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDog0z1/zJtpvEn2FQhTB2w6IYE1nPck22quUWu9s14=;
 b=Eao65cgwbVrZxk9nys6pzeTWBrbi24H3+Jr3PMIct9Av3bd1Ui1DmG6LkB613pYA9i37PGT1AKJomXzfpbIWe93GKoO2ScC8exMFX/R9p/JTCka8Z+IYLD5jsnh9txXA8ZvB7niZ/hjVlbaRhTsGRYacGGL2YnPlNPHPZqnO6bP4ZRBFrbv29UXsM3WiVU9QRbW1b5pMtHZA9rJ8l5pCcY7U9/iI3MAn56wZrrBo10DBz/2TxQsZ7KuQ4tpzEAwJc8kagMdRIvXIXM5xYSZwX5AlkDMuDc5P3aXNuPtEfhSi6LCVugH6JtonsmIPqwMVaqKgFWIWtZYUeb6VWDXK+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jDog0z1/zJtpvEn2FQhTB2w6IYE1nPck22quUWu9s14=;
 b=Oz60ev4eaisf5OYCLmRfmGOLaTkUXrxiQtsstxyVdk/zqQ5tjgK838TfCt2UmLX8XpSa5GFJO+5UCAZ/Z2RTHtt2UfvQ2op+X4GjbEhodRmMGUSP9Ncfbn6VnZU49kk7+wB+87u8B9DImxpq5TCuypd47G92ag5LeAi5YXqNRWGXAZGZjfoFPsu5ZfXzpAIs+6kc1PUCckCtyhp3agDaqzrvPeycfuH4CEGiYaBR46ae8+39/sJBOWxJYimTUahFPAdO+7Xbtou2rHmdJpGyPyfb5gV6Dr//tz2hqac4zk6qnRfWNLkgcPTOMSP9+Xxx7R1m+EXvGJAPxJckt081bg==
Received: from CO6PR02MB7555.namprd02.prod.outlook.com (2603:10b6:303:b3::20)
 by SA0PR02MB7210.namprd02.prod.outlook.com (2603:10b6:806:ea::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Sun, 15 Jan
 2023 14:51:07 +0000
Received: from CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::dc45:3b8a:bd53:133a]) by CO6PR02MB7555.namprd02.prod.outlook.com
 ([fe80::dc45:3b8a:bd53:133a%9]) with mapi id 15.20.6002.013; Sun, 15 Jan 2023
 14:51:07 +0000
Message-ID: <6cb4eb85-bfaa-10cd-5625-94605a5565f5@nutanix.com>
Date:   Sun, 15 Jan 2023 20:20:55 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH v7 1/4] KVM: Implement dirty quota-based throttling of
 vcpus
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
From:   Shivam Kumar <shivam.kumar1@nutanix.com>
In-Reply-To: <87h6wsdstn.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MA0PR01CA0053.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:ac::8) To CO6PR02MB7555.namprd02.prod.outlook.com
 (2603:10b6:303:b3::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR02MB7555:EE_|SA0PR02MB7210:EE_
X-MS-Office365-Filtering-Correlation-Id: 19513d8a-fc97-4d22-5ef2-08daf707ee82
x-proofpoint-crosstenant: true
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /UTzQVqFPoj7vrLDsZglAFKMbHgdcm6R3akWKyfVSg2DL2ae6wnBXHfPe5BhGHW9OwZoEeA9v7OV7sFeyF+pvss6ilAroT2trk8cGniBYxWdX3gEGZSdlThTXMSbj52pcz9X/WVxcTunw93P/BjtoGU81BNESWcNx9WywZMT3gfcdQxZHVyqYsZRqhMaLBcxI1XotCe2VUtM0aWBNYiPW10/FZ5VN47jdEpQ/gs73TevmAQPicOxaAnZandmMEWhBzAiTYXfzVRk5RhzPbdmqdTm9G2QGxpCAut98Gn5CWG1gHTt9aghtaeU2IZ5+AsSCVUg02HtduawzArrxjCFyWyYRsOOOPiles+hxxXH1TOX7ZA5ibGeQ/+oyc+6R8jjcrnvCpVDED0LtOmQ1TqZNqMRjlu5ilhr3kV4cOXt7DpSGuNW4wk6qHAfGbLZL1URTAlZqcl1kLIMx3+zpWfcJTnbqFTt4+BcD9SP3oJhVEpdyEeETNuNtGIuVpz/0sux6N7itoUdfkHkEZlma3dg2e3kwCqc/b6xTQ39F5/AlClcePhqSVF+P0E0E0cWtEYhxezIlM8XwFhKvKHWhuvuejAhi4h3zAc+9lyOGw0W/F0AuRZLLcKliqRvmRth0Kj40iqp2ImJJ95RhvFCWjzFA9+MgTLJ79ryo+RFVm2xJbikkC2IjVKSRKZTxeupMavh296wJwUMfwMTWqHPvXUgbfS9KDyEiz7DzU66Apmqm8rRCi71E9fwlCT3aRaKyRgL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR02MB7555.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(346002)(39850400004)(396003)(366004)(451199015)(31696002)(316002)(86362001)(31686004)(54906003)(2616005)(8676002)(66556008)(66476007)(66946007)(6512007)(6486002)(6506007)(186003)(26005)(478600001)(83380400001)(53546011)(107886003)(6666004)(6916009)(38100700002)(36756003)(41300700001)(8936002)(15650500001)(4326008)(2906002)(5660300002)(14143004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SFVZVkZzeXAvKzZNTkF3T0xpZGFpeldvN252NmJVdTJVeDZnTVlhb0s3Uitx?=
 =?utf-8?B?WU1WekQ4TDNBaWo1TVhGckJPREF2SVRBbFdBeHpYRGozS3g3NHd5NmsvUCtJ?=
 =?utf-8?B?Z1dLdlJ5SVdzaERncjV6bUpwU1FBN3UyRkNFMUJUREkyT0lPM3ljTHJDeEZN?=
 =?utf-8?B?bElYUE5vT3NucjJxUmlydmFQblJqcUJzOW1LVE1iLzBYdHNPL3pLc09aYXIw?=
 =?utf-8?B?cTQ1S2s2d0RUMU1WMGN0QnM4ZG85K3E2WXYwbk9kcVA4V2krcy9xbVFRaGtU?=
 =?utf-8?B?TTlLd2dqendrenh3SHJPN2pLc1QzQzNZVStJU2FwVWZvbHdKNVNWTkdTZjFI?=
 =?utf-8?B?TzF1ZHcwSVFWeXkxSDFwcU5rdDhkb3ZJcktYTzA4Z2R1YTlwMjRoMThLZlZK?=
 =?utf-8?B?SlN6TUhoTjgzVURjdUViVE9CVTgwUm1DSWJJRHF2T0wyZTNuMUlaeUpiMnQr?=
 =?utf-8?B?UEJtbExnV2RneGtOVCtZeWVqVDdQbTUyUHlYNnNWbTMvTHp1bWpvcGlqcnlZ?=
 =?utf-8?B?eTJlSFIwWjI1NHpldXh0bGhmUjRpSE56WDJ4endFcVkvSVlGeGtlMW8xMEJ5?=
 =?utf-8?B?amsyTkIwekNTVStLMDFyVGtPZDUzbktXL0ZTZ1RTdWd1NmZEb3o0L0psMjE1?=
 =?utf-8?B?RWhCS3BCZTRYQU4vY0ZKd1lOZVpodjJ1VmpxNVdXTVpWcitJd0tqR2JHdS9a?=
 =?utf-8?B?Zk0xb2FnQVpxUUFMYWx5Nm1DdU9ZazJ6ZUhwZ1Qvako1VDVxT1VmRURWeEFn?=
 =?utf-8?B?eTBsUDJXWjlrYytxYUFGRDE2R1BvL3oreUJRWnM4a0dwMHc2QmVBaC81NHBC?=
 =?utf-8?B?T2RwQllwQmxzVmNPL2pqd3F2K1pBZ1hVVHJsSURxdnZTRWszYnBSYURFaGp0?=
 =?utf-8?B?d2FzZ2hhREdQdmtpMWM2NHg0QnZ4QTI5akcvdTl0eEg2MHl4QlVTamQ2aFly?=
 =?utf-8?B?bThwT1hsTFppaSszRG4wMmJReDJVUk40K2hKcWVLZ0VnNC9EWU1KYUZZWXpv?=
 =?utf-8?B?azdHQzJEdmVqK3hPZ3BseGRXR1FhTUlvR0crSGxLS3kyRmpRZlRhUWRkOHlZ?=
 =?utf-8?B?cU13RGNNMGNTQ3QzVDZtVnk3SlF5RFFaSFFINHozUDVsMHBjZjV4Y2p1eERD?=
 =?utf-8?B?dFh6NmVHMS9xaERVdldQaTZJUlYwYmRsQldheVd4dEo4NTRsQzVNVHVRQlZo?=
 =?utf-8?B?bmowdWR0RDFqUlBtZ2tib1BkNmFlTklnYlZtUnVtd2JtOU9maVM0ME5oc3JH?=
 =?utf-8?B?L2c3dmQ4YUJSd3BqRXhDR1FFVW05WTQxdmFLdythWGhSVG1GaEJFeDEwWmQ2?=
 =?utf-8?B?d2RlN3RXSlNaWjEwRWozTzliK0svcHVGajAwWHZhL3Z4YWpKeS80RTBienVG?=
 =?utf-8?B?dEVVSGFKa1lxL2E5ZTMyWXNTYVcvakk2OFEwbHhuT3dabnMyUTJIaVVSVCti?=
 =?utf-8?B?TmhDeGtFdEJWaTJPRWhsc214L1JWYnFBVHV4SlpHRTFVaVJHdG1DRVNYTUJy?=
 =?utf-8?B?MjJvellXbVRoQXdibjJpY2lBNlFZbXJEN0ZwbXFHcTFkV1pIUTI1Vmg0aGxI?=
 =?utf-8?B?eHQwN0tCczZLeTh4d2RsdFRVRi9yeTl0aUhta0JaSzNYeXhDUDdwUlgrWmI0?=
 =?utf-8?B?eEJDNERxOTFpWVhLR0NFN3k1aW1BbUdHd1UwUy9IbXlsQXdCNGowV1kwWVhS?=
 =?utf-8?B?dXQwL1F2M3VIeHYySGJSQldMaG1IanpPcEoxdU9LUm1aeG05cUY5WVNwSXhj?=
 =?utf-8?B?VlFNcVR3bXZ1SGJVTlhZZFVGNVIvYW52U1NMZS9nWkdLanZhREhCY21ybXow?=
 =?utf-8?B?dEdWMDhxSnNiZFJ1KzNkM0NmcFVIV2gybkpqZ0kyWlUzZ2pubm1FMlZwR3E0?=
 =?utf-8?B?eEt3V2wwRzFCWktJMWlzc3lqVXkrd2JncTJqdlF2UVk5YzNxQWVGLzVFbXZw?=
 =?utf-8?B?a2VpZUR1K01RQlJIY3JFeFRUVGZHWjRuWHRiSzVQbEJ2Ym5rSGMyekpFbldG?=
 =?utf-8?B?czNCWDFlQnZKckVpMTJrSk5KME0yVFB0ci9lV3I3eE9oTUlrc0FiajBnMEk4?=
 =?utf-8?B?S1hOQkowQWxWQzdER2RPSkNjT0g4THBaUGJrbGw3ejRqM1EyR1EwbDFtb3Jp?=
 =?utf-8?B?S1pHbXlXOGZYV2cwSjQ1Z1UwaTI5VXJOVkpGSEE3cDgwbitlQ3pRVVVNd2F2?=
 =?utf-8?B?c0E9PQ==?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19513d8a-fc97-4d22-5ef2-08daf707ee82
X-MS-Exchange-CrossTenant-AuthSource: CO6PR02MB7555.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2023 14:51:06.8303
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q8qYE+ffjpd2dkhoF85lSpnIVkUGpAzNpWsP8eplsf5OeKKiC68VtDXRBIcjVYFa/NnUfEAtGDieE3FWgz8UCzPxDv3j3QOaONqqhgpawKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR02MB7210
X-Proofpoint-ORIG-GUID: FaZGGxiJxA1AQ9pqN2DxETuX0LZGdVkA
X-Proofpoint-GUID: FaZGGxiJxA1AQ9pqN2DxETuX0LZGdVkA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-15_11,2023-01-13_02,2022-06-22_01
X-Proofpoint-Spam-Reason: safe
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 15/01/23 3:26 pm, Marc Zyngier wrote:
> On Sat, 14 Jan 2023 13:07:44 +0000,
> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>
>>
>>
>> On 08/01/23 3:14 am, Marc Zyngier wrote:
>>> On Sat, 07 Jan 2023 17:24:24 +0000,
>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>> On 26/12/22 3:37 pm, Marc Zyngier wrote:
>>>>> On Sun, 25 Dec 2022 16:50:04 +0000,
>>>>> Shivam Kumar <shivam.kumar1@nutanix.com> wrote:
>>>>>>
>>>>>> Hi Marc,
>>>>>> Hi Sean,
>>>>>>
>>>>>> Please let me know if there's any further question or feedback.
>>>>>
>>>>> My earlier comments still stand: the proposed API is not usable as a
>>>>> general purpose memory-tracking API because it counts faults instead
>>>>> of memory, making it inadequate except for the most trivial cases.
>>>>> And I cannot believe you were serious when you mentioned that you were
>>>>> happy to make that the API.
>>>>>
>>>>> This requires some serious work, and this series is not yet near a
>>>>> state where it could be merged.
>>>>>
>>>>> Thanks,
>>>>>
>>>>> 	M.
>>>>>
>>>>
>>>> Hi Marc,
>>>>
>>>> IIUC, in the dirty ring interface too, the dirty_index variable is
>>>> incremented in the mark_page_dirty_in_slot function and it is also
>>>> count-based. At least on x86, I am aware that for dirty tracking we
>>>> have uniform granularity as huge pages (2MB pages) too are broken into
>>>> 4K pages and bitmap is at 4K-granularity. Please let me know if it is
>>>> possible to have multiple page sizes even during dirty logging on
>>>> ARM. And if that is the case, I am wondering how we handle the bitmap
>>>> with different page sizes on ARM.
>>>
>>> Easy. It *is* page-size, by the very definition of the API which
>>> explicitly says that a single bit represent one basic page. If you
>>> were to only break 1GB mappings into 2MB blocks, you'd have to mask
>>> 512 pages dirty at once, no question asked.
>>>
>>> Your API is different because at no point it implies any relationship
>>> with any page size. As it stands, it is a useless API. I understand
>>> that you are only concerned with your particular use case, but that's
>>> nowhere good enough. And it has nothing to do with ARM. This is
>>> equally broken on *any* architecture.
>>>
>>>> I agree that the notion of pages dirtied according to our
>>>> pages_dirtied variable depends on how we are handling the bitmap but
>>>> we expect the userspace to use the same granularity at which the dirty
>>>> bitmap is handled. I can capture this in documentation
>>>
>>> But what does the bitmap have to do with any of this? This is not what
>>> your API is about. You are supposed to count dirtied memory, and you
>>> are counting page faults instead. No sane userspace can make any sense
>>> of that. You keep coupling the two, but that's wrong. This thing has
>>> to be useful on its own, not just for your particular, super narrow
>>> use case. And that's a shame because the general idea of a dirty quota
>>> is an interesting one.
>>>
>>> If your sole intention is to capture in the documentation that the API
>>> is broken, then all I can do is to NAK the whole thing. Until you turn
>>> this page-fault quota into the dirty memory quota that you advertise,
>>> I'll continue to say no to it.
>>>
>>> Thanks,
>>>
>>> 	M.
>>>
>>
>> Thank you Marc for the suggestion. We can make dirty quota count
>> dirtied memory rather than faults.
>>
>> run->dirty_quota -= page_size;
>>
>> We can raise a kvm request for exiting to userspace as soon as the
>> dirty quota of the vcpu becomes zero or negative. Please let me know
>> if this looks good to you.
> 
> It really depends what "page_size" represents here. If you mean
> "mapping size", then yes. If you really mean "page size", then no.
> 
> Assuming this is indeed "mapping size", then it all depends on how
> this is integrated and how this is managed in a generic, cross
> architecture way.
> 
> Thanks,
> 
> 	M.
> 

Yes, it is "mapping size". I can see that there's a "npages" variable in 
"kvm_memory_slot" which determines the number of bits we need to track 
dirtying for a given memory slot. And this variable is computed by right 
shifting the memory size by PAGE_SHIFT. Each arch defines the macro 
PAGE_SHIFT, and another macro PAGE_SIZE as the left shift of 1 by 
PAGE_SHIFT. Does it make sense to use this macro?

Thanks, again, Marc.
