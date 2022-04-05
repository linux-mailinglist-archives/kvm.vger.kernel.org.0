Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9660E4F322A
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 14:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354028AbiDEKKz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 06:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348846AbiDEJsl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 05:48:41 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7785CB6E5F;
        Tue,  5 Apr 2022 02:36:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMVkjVzwiowCZNTQmvsooBYVOcU526kOdq27guQ5fhDHymAcptw9FX9BLwCHVZpUkWddFgKRbWlEwXWalhcbE3RclkK2KEeNS+Pfpcb8bGSgo3HquKWKPXSplL/myXmHrdv3BEpOx2ETue5oQMayd6o3s8u2WrF0qUFVvmg+1p3mB0QUkcAwO8EPZEWqSwqihgCz3rNvcKyczzakWtrvIJhqO14QMDxSXvHdA3qPf81TL+8u8WYoBaVdlxBmndq03CxCIARLAkynrfQfih+/WbEL3nwtOBi+VQmCduh6BuXB7xZlreTYyLQAmT37EDNG/XRHTcIY0PmUwvhzPkQSqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SCLJZ76bxE+bRnCXJEVP5weANmzTW0KhZu8lHgBa3KY=;
 b=mceGH4wNv2O9tWwPGMfahdnyW2eiEs6oqK6H2PhUzq/rHa3cNhl60aMo9p7984/u7CNCcrZ9hCIqWCpsG+yT801YZ9xytQ4EFuJuajHrCwWIss2fXh3bMieYenSe9UPgAn5Y4Vx84oLCUzIitihZ0/9033AOU9Er1eZJMHLok/6gs8is6/Fb09gL0RuI9PyE27QaEEyt4BnYWmh3VVeN5CbmKW+gULQagyTbEeJ1rYpYT5uT01whIFpiYiOl8l3gxjDhJRzvdkyJr3SqSDcLwrQEnLQoAFHHoGZP++ASjsrQKT7lHZNOTV+fVPJ5DRwFSfE88XxBm02uyyIinwWHUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SCLJZ76bxE+bRnCXJEVP5weANmzTW0KhZu8lHgBa3KY=;
 b=0ULr4Glbzk4ZPs3PZNtghA5aQBnJCNHl/oLVGW9To1UrKfc4ruW3NtJcTFkHeHUogsHc917O8Gz31fOzWmYnuGYS7Fn+RB/Shr/8TzHd0u17+Gwr5WtNJ2oA/Vnytljg+0P8rZg5mimRNyZ3cF7eyvbtgt+FaYQFNcEWzSxNcy8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7) by
 DM6PR12MB3161.namprd12.prod.outlook.com (2603:10b6:5:182::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5123.31; Tue, 5 Apr 2022 09:36:35 +0000
Received: from DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953]) by DM8PR12MB5445.namprd12.prod.outlook.com
 ([fe80::a80a:3a39:ac40:c953%5]) with mapi id 15.20.5123.031; Tue, 5 Apr 2022
 09:36:35 +0000
Message-ID: <635d08f4-08a4-9dc3-241b-1ac07a53b096@amd.com>
Date:   Tue, 5 Apr 2022 16:36:23 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [RFCv2 PATCH 07/12] KVM: SVM: Introduce helper function
 kvm_get_apic_id
Content-Language: en-US
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
References: <20220308163926.563994-1-suravee.suthikulpanit@amd.com>
 <20220308163926.563994-8-suravee.suthikulpanit@amd.com>
 <d990c42a3ab5e8b1cbfa7775eef37ad4957147f6.camel@redhat.com>
 <5876774a-c188-2026-1328-a4292022832b@amd.com>
In-Reply-To: <5876774a-c188-2026-1328-a4292022832b@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2P153CA0028.APCP153.PROD.OUTLOOK.COM (2603:1096:4:c7::15)
 To DM8PR12MB5445.namprd12.prod.outlook.com (2603:10b6:8:24::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1e4efd5-52c3-47a1-c4ae-08da16e7c698
X-MS-TrafficTypeDiagnostic: DM6PR12MB3161:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB31615E5A34CC20FDE0893088F3E49@DM6PR12MB3161.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iUJ2aM0ss/x67OOEO9jW9JJO+Qhd1icNMtaE6gJChUdcKlThlCYEDSzU9j1WG6bOBIDUwGH6P1F4R9kxRn3UKw3qjJ+oAtmBtEnxICdaWFGAjrcMtNqU9uUcNHYmLy0iKTOOAW9DK+s+p8IinHx+JyOPS7dnvM+yjRWhg++zhUN6QykJCX5jU7ZWw2vXSnLvMlznMaWYqfKRgbHYvj1wbrejl/QCGoU+If4dzeTj3CJAOUfB3cYMyqBFHf4eawHz7I0yXTbdOBdbYZSet/8ZWB/ACrs80nwpYQxKlCxBwxn6Cl/k8h2TkqERMh759tshLYrKQmZeYsnICvzgHrIsPBRVHtyByFnNq19nEF6LoSXmLl2fbaWoNkze+An9VDl/Y86g8eSfCObjVIX6NhOZmg5mx19U6jf45qEPTLWfzH7P0AVM8rrR5vrE8yezQ09F9hy4nRfJIi+JxYd08Q85lSStCubolsnl+SsNf1UxtNmz4tMTw3MErSxPJJ6MdtRREF2TpEn+HRVRpBtZ5nRd5ydZovgMx2W5Bp5Ly2z6VrciLPFLnfBZRSFwpKDWKEjgrOANWWV9ulUEnzSm/PDiu6+DN8Gd/5om3GMgeCcMdS67kpFV2DjxgCZsklKb4ieoftbvkN0pCxD8bU6uUKD2P8/sJVPsyc8esFDSdEpeRbbblpft6UHM1aT5swdoMHNtGnSF2ijhOFPjO5x2hcVL5iM2ZfxuZ0pzytbzCKOE1Ww=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5445.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(86362001)(31696002)(6666004)(6486002)(316002)(83380400001)(508600001)(4744005)(5660300002)(44832011)(66556008)(66476007)(8676002)(38100700002)(36756003)(66946007)(4326008)(6506007)(31686004)(8936002)(53546011)(2906002)(2616005)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WnRKUFFOQkk0MG9MSUNLZUhVeG1ONVhNK1JqaXN4d1hGZmNqYTEzRy8wc3pC?=
 =?utf-8?B?akY2YWV1c3VxV0pBMG9jSjl5MU1kSnBnSlhEamJJZWY5dnlzR0hLcDF5aTZz?=
 =?utf-8?B?THA2cldTNmpHbkQrakJ6bXlCZ05qWTd6VTl1WE93VGViRnBBcnRFNDd3K2gw?=
 =?utf-8?B?YjMxNUlJaHBVVkhrcXlnOXQ5ZXFyUytvWWNmTUZ3dllCRzFzbk5KbjlBWVdu?=
 =?utf-8?B?V3N6S3hhQUxZZGpDdnFrL3R5aUlXeGQraDJOaXFOcS9oZzN3aCs2UUxCVW80?=
 =?utf-8?B?TVFrUmFEaEF5akNrSXdkd1BpOXZXWUducU93RVJWOGZKV2pNeTdGRlFQaUs5?=
 =?utf-8?B?SnhZY05rWG03Y1ZXSWdCUzFQZkpseXRLN2tYVkdYS2VIMFBJV2tFV2FyNnV6?=
 =?utf-8?B?aEQ3Vnd5OGNnY0JFcnJiRkhWTDB2dXJ0cGNDbXBOWCtmUXdsS2t6UmR0cHNS?=
 =?utf-8?B?a1RsMVBtaUtMRVc1WDZLV1E3THYrN1gxaVVtMDlyRlZMUXoyRWovMlRyZzBD?=
 =?utf-8?B?S3haUkZvc3JndHdsUUdyYmNSVVhBSURlNVZXM3Q3SmFtZWJsd3BRNUFlV2Zo?=
 =?utf-8?B?bFRLT3RTT3VNcjJCR3lJa0l4cTl6TjRWNEovVE8zUnUvcGwrMmdUV2dRNWpp?=
 =?utf-8?B?UDdTVlBEcnJONlcrL2xtRDdrQkZOZldORXdyeXJvdzJWUHhKdjdpYmRWSEhE?=
 =?utf-8?B?enlhSytucTg3c1YyYzJ2VUV1Ukh4NnUwV2I0U2w2MFEyRURGY2ZtbG40eFpr?=
 =?utf-8?B?RFBtMmhkWElBLzdOa1oxZW1wVWlSWGYzMTYvV01KbHJvWGRVNzJZN2U3TEt3?=
 =?utf-8?B?T2U3WGM1MGJaejdGb0M2dElXU1BwdnEzVW5aMnpzcGdOODdvTjZobHNla3Er?=
 =?utf-8?B?dkcvUSs5d25aNkFhQWdrMCtQZUoyYVVzWEdFcmFPMGtGU01PQlRpN2czOVMw?=
 =?utf-8?B?WWcycU9lR2xlSnlnb2duV1YySGs2VVg3QWp5eldMM1F3OWswNmJUcWtkUk1w?=
 =?utf-8?B?S0NkaWwxYjQwbm1FNDltdERERm5KTFZDZ0cwOE5WSnlrSWp0b1N6OElXREVX?=
 =?utf-8?B?RTZsYzh3TU9pVkhTVjY5VG9TQVFucStKMWlvcnFJMUd2WmZrTFUzY0NqN0tD?=
 =?utf-8?B?TWEvRUNVMDdjY2RERHViU1I4STNjby9FL1Q2aktZVkhPYlBHWjBSS09ZalNr?=
 =?utf-8?B?YkFmUnQzZzBDM2M3dnRrbUlZeG5OeFVlYmYxeXVNekZnNi9FQ3U1TXlWVkFw?=
 =?utf-8?B?YklRRStHd1BjOWRWVWRIRGpzYjN0V3BIVENTU1JNYU5CbkZxUldESmd2ZVpq?=
 =?utf-8?B?dFJqZzI4bVRtd2pPNWlDMFAwR3RCOHhrQ1hyYkZoY21neUU5U2NzTHQyZEFF?=
 =?utf-8?B?Mzdva29PQzBib29mbVRNeGhJSXFOVDRsdjRzTUdEZDdVWGVraU1mYzRKeVRX?=
 =?utf-8?B?dlRMU2YvZlR2SmY0aE1zU1pISnlBT0JSOVJ1a1VmbWliSEJNcDlQcXBreHJU?=
 =?utf-8?B?dW9RM0lnZXNZVVI1OE9JVkdHR3NzZWxGV2xhV2pUMGZaZ2dsQ0ZaSmYza2t4?=
 =?utf-8?B?T05CQVBJYlhoeDVRSGtHR3NIQlJSK3h3dHNIaytTUHpVUEVQUVRmUWU3Z1NM?=
 =?utf-8?B?bjFLYXZSdGhJajIvRXdYY1Exc3FFNGpRbUZKU1hva1JPWUp0NjJLVWN5UGJP?=
 =?utf-8?B?UzBwY3BwUFpkRGJDcDBGZi9rMFhTeHY4RituVzl4eWkvYVQ0N1F6Umh0aW8r?=
 =?utf-8?B?RTNnU0ZKVmI1NS8wYnQ0TGJvNTRaOTZrb1lvOEMxTDhyU1M5RHZ2UEZKVk53?=
 =?utf-8?B?VDNIbWVRWDl2NjFPRWJOTUYxYk5IL2JMSFQvTGlWVER6R1lpMktwaFdZcnps?=
 =?utf-8?B?c1VJT3drU1NJalprMk41dWM5bmFESlNiMnJOcVB2MDNLQUlRaHQ5NmgyREt3?=
 =?utf-8?B?NFg3RE81TEZ4a2lDQzFGRTZEaGNJckI1bkVabWFnWmxuSzM1L2Z3TjlnYkNi?=
 =?utf-8?B?K1FUZFRRRGV2UGQ0Qk1qQmFQK1E4SlRqZXRlalplN0tuak43dDhmNzQ1aUMv?=
 =?utf-8?B?T2hLazd1Tk52TDRyWDU4L0tScjNtTW5OQUV3eC9WbTA4aWF3dG1KRDR2dDd4?=
 =?utf-8?B?WmRZOEJucFBadGhodWsycWdNQ3pHS0NTRUF5cG5MbXA1emg2MEdrMG5xeFMy?=
 =?utf-8?B?dXJBUFpnbXpxUlVvOWNvMzRuSERjQnFVbVVHUTQ4Z3VkQTZ0dlJWWVZmeGNn?=
 =?utf-8?B?aUNydzBkd2tLTzNFREZJQmVNMmZnSm1XeTNGd2krSmgzdFY0bEpVcTFYanRD?=
 =?utf-8?B?OVduZWpwSThRQk5RUzdJS0R2VSt1VFhvMGM0YkJHN0tvMmJzTnNVM1dIYUNh?=
 =?utf-8?Q?hBlaZCiN50XqwpP6JJlIC9TDXLDjSVT5flQne+IIMGeT9?=
X-MS-Exchange-AntiSpam-MessageData-1: wXWyplQBGmNIyA==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e4efd5-52c3-47a1-c4ae-08da16e7c698
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5445.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2022 09:36:35.6034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1y3hdbMjt3MAfT//l6ldpD5m9OoJHL04rqzBAffWNz8BSzTFB1NFsVV4n/m8jKcU0xV+mCzI2HrWBvIc6knBGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3161
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Maxim

On 4/5/22 10:58 AM, Suravee Suthikulpanit wrote:
>>
>>
>>
>>>       avic_invalidate_logical_id_entry(vcpu);
>>>       if (ldr)
>>> @@ -464,7 +471,12 @@ static int avic_handle_apic_id_update(struct kvm_vcpu *vcpu)
>>>   {
>>>       u64 *old, *new;
>>>       struct vcpu_svm *svm = to_svm(vcpu);
>>> -    u32 id = kvm_xapic_id(vcpu->arch.apic);
>>> +    u32 id;
>>> +    int ret;
>>> +
>>> +    ret = kvm_get_apic_id(vcpu, &id);
>>> +    if (ret)
>>> +        return 1;
>>
>> Well this function is totally broken anyway and I woudn't even bother touching it,
>> maximum, just stick 'return 0' in the very start of this function if the apic is
>> in x2apic mode now.
>>
>> Oh well...
>>
> 
> Sorry, I'm not sure if I understand what you mean by "broken".
> 
> This function setup/update the AVIC physical APIC ID table, whenever the APIC ID is
> initialize or updated. It is needed in both xAPIC and x2APIC cases.

Actually, I will rework this part and send out change in the next revision.

Thanks,
Suravee
