Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8690D7C94E7
	for <lists+kvm@lfdr.de>; Sat, 14 Oct 2023 16:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233033AbjJNOuS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Oct 2023 10:50:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230016AbjJNOuR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Oct 2023 10:50:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B5AB;
        Sat, 14 Oct 2023 07:50:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+i4E/ezvPqqxn4HNbHnALayD0Xn8dKrXZy80URwAIgyJ3YPwUspNNNBcM9EGbBWR/VTv4mCjBfFpgTyVvY30K0+lyab1HpHMhBCaGl/N39JZ1m4JbCDkEHZ3pJ5SC72onvpJHpkNZauK2OVF/szHODYK5faqUL3LGoeuByY/Brs98yKjvqOtMvF49SOxIgtHkj4P/uM0uC6VL0h0vGqmq0wei/XnttHiHqrpfWjl7skSZPFCb1kQdxvw2xjL/sZ/9TFDBJd/S/NBHSTMRa14XG3Cz7wRI/zos5ZamnKqxR9OG+YEUydSjKXmYAY9jZSkpoZWw2pjvTWOF+fR9PC5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uy5fHRWc5E6EWlL96aXm9U/7YJwFScLBPv1GN65zMAE=;
 b=BxawQ7mAa7IxW6Q1gA0UgXdpVOjRaT4BGkqBXmtOdgrcCSJ7uHGhsXNm6BIJNyC25XOBNKlgrkdC1MuaDH8D5MCkN0nhbOEjTkUDDFjpDOt9C5JUeQ/s0h9SHbLM9tLNYzLmWCQWkb9qTzUfC9ktrUu92E1B5+qYqKYcX+0Hfu2hyFpCuyNJ0wc8ez+tL0vWO6WnlTQS0iA01XsGnIjyoz2YRgVvejHBIr6FExCGvpLA6cdsYQZXSyiVyyWMx7qe3sJ8VprpHRsY2xCQWbLHQNv5JpBLZpP88TnwsDAEuHA+bV240UpCdekf/42UkrpcNQOsgbw/jJx+7pzNT4qC+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uy5fHRWc5E6EWlL96aXm9U/7YJwFScLBPv1GN65zMAE=;
 b=Q5E5JGzB1EuHP5XfCOryzEC6HzpHYDEERCkDYw3wXa/kLS552DOznAQ0BS4ebWTujTG+X7eHGCntP0/+84TCrAL71Vqe2oEv24I4ve3jqpCfl4gpB2BL2NGwTh4ffVaNQ6ySDYtaIfl68J4sucU0oaRIICqq9UWKqaf+XzP6aqg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CY5PR12MB6323.namprd12.prod.outlook.com (2603:10b6:930:20::11)
 by CH0PR12MB5267.namprd12.prod.outlook.com (2603:10b6:610:d2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6863.47; Sat, 14 Oct
 2023 14:50:10 +0000
Received: from CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::8da7:5c21:c023:f0cc]) by CY5PR12MB6323.namprd12.prod.outlook.com
 ([fe80::8da7:5c21:c023:f0cc%7]) with mapi id 15.20.6863.043; Sat, 14 Oct 2023
 14:50:09 +0000
Message-ID: <8f6ab889-d177-1bd8-1aad-396d9ba5128c@amd.com>
Date:   Sat, 14 Oct 2023 20:19:52 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] KVM: SVM: Don't intercept IRET when injecting NMI and
 vNMI is enabled
Content-Language: en-US
From:   Santosh Shukla <santosh.shukla@amd.com>
To:     Sean Christopherson <seanjc@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20231009212919.221810-1-seanjc@google.com>
 <e348e75dac85efce9186b6b10a6da1c6532a3378.camel@redhat.com>
 <ZSVju-lerDbxwamL@google.com> <a18658e5-3788-b3f3-db0d-1ab29ea89f88@amd.com>
In-Reply-To: <a18658e5-3788-b3f3-db0d-1ab29ea89f88@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BMXPR01CA0074.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::14) To CY5PR12MB6323.namprd12.prod.outlook.com
 (2603:10b6:930:20::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6323:EE_|CH0PR12MB5267:EE_
X-MS-Office365-Filtering-Correlation-Id: 0c785343-8e9e-4cc9-1c09-08dbccc4dcc2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z/x1GvkgefKWPpLkW3Wbv85ZATBxSI0sIvQaE90HobSUbPUTCZQ4+4sIaZGLeZC72yYCdL/cHVQm89FqCyNChYP4sJnXl5TsfcvNRfH5wkXH72FFnmYBGAqNMGDtXfsomKdrG2QmaHiDkANZSpKN/JOGdsrt+0T88oJ7mEteQOAqUiwsmTOYOBpmBvxXr7xHaiP1/AbBjz3iJ0mOWoEHncraZHT5PuYb37qgecHC/E3X/Cye06Jfg35XKwK2l1kesDi+lvI5lqGgwUI1vlc/5s/FbANrnOGGooJPhHl07AZCvCAlBtP9zfaygEeQsIhmoIj8zgV8u8+jbufTB3jvGbe2aaBLsCe4jKDb6WVv4w8johIZ9eG/B4XFTYnTfC4wTEsfpZ5uD+1RGV8GzS9nnJBuxv5pz2nObP3MdnEeu8u4/bVSYcgxVt9Lm4ymSNNwKBRFLmksXm1EwsjMB7R5GA/TYy8uy47chn+7svLydQwythTD7Um1SD9lrazswnks6WK0FLgYZmmkITjnfkONlqI5Q4ZyVDm7i6YWKx6loBtOBzKBiTI49hoM6LY0WxudfbILLl10aqpeAp610qWlxky6MTTmNtkiN2xr1lLq/d8xO00jo9LKHltEy9omybByhEaUxihVtopremZanl9PiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6323.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(39860400002)(396003)(366004)(346002)(136003)(230922051799003)(1800799009)(186009)(64100799003)(451199024)(31686004)(36756003)(66946007)(110136005)(66556008)(66476007)(316002)(86362001)(31696002)(38100700002)(53546011)(83380400001)(26005)(2616005)(6512007)(6666004)(6506007)(8936002)(6486002)(2906002)(966005)(41300700001)(478600001)(44832011)(4326008)(5660300002)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VTE4ZWtNcWpZb3dXMmQ3Smx4WVh2bnpPdXphcmtjZ1h1M0NrdU9VVGVqbDRC?=
 =?utf-8?B?SXpNYjFnMWgwYjZmamFGNnlzVXNXM25BcW1CSXJrMURFc2svUzhXTHk2Y3du?=
 =?utf-8?B?ME91NWovZDM0Ui9tODhLOGY5U3c2RXU2UWJzYVlsZUFvQVViUjBnb1lrQmw2?=
 =?utf-8?B?elpLcCtINVVrbGRSSG1rYW5EZzE0bnRGWk1MU3liTExCVGZlYkF3VEw1NUNZ?=
 =?utf-8?B?ZHZoRmp2QUlHL29DUmEvK0ZBS1FQTTNVUmJ3cjFBbmZkUnh4Tkg0MGpxbCtV?=
 =?utf-8?B?aVVmVGNtTlhOdGg3RDN2Yk5TcDNCMFBLUjcwNWJpSkFjNEVHYlFPN1NGN2Rz?=
 =?utf-8?B?RDNQeVhvbDEyTWk4YXVPYjB5WDZTTGhkOHJndFdoNnI0T0NOR1lMRGhITmt4?=
 =?utf-8?B?bTdJdzZVOHRVVnRmYk02NVVza3dCZzhTSENRWjlZcDQzQy9kVTVHYmdWWHll?=
 =?utf-8?B?WGsrMWJRVXhWQm9qdFV4WjI5UkM2WFU4aXlSMkJWdW5OZHBObDZvWHJLRjIx?=
 =?utf-8?B?dmtucENnYXN2UU5jay8veGgraEpLVlhXRktEMUowSDV2OHhFREJ6dlZ3V210?=
 =?utf-8?B?SFd2OUdKVnVzWDVmRWJ1VXZrTW1zRStwY1ZLbTJDbWd4N05xY2JDNHhpWmMv?=
 =?utf-8?B?NzZ6QlJmV2Q4RWRQdVRjU2Z3L3M0M0kyQ3lMN0lHdVA3TU50Mi9sQ0dWVXlu?=
 =?utf-8?B?azNBL2FXQWNpaENQY3REaDhxdGY0ZGFCYlpzbkJrVVU3Nk83L0UvNDdrb3Y1?=
 =?utf-8?B?TTN3alNZOUZrNEUrcHEyekQrMU96MjdEaElIMDl5VzI1VUhnRlQyNzdwaUQ5?=
 =?utf-8?B?YmhBNUphK1crWGtEU09aTTA1Z2lEZTNEMXZHRW5lTjU1V01MTmNuTlV4aXVm?=
 =?utf-8?B?OFdUci9UajVFK05GQytDUUdXYUdlNFlDR09ISmcxT0NFNGxDYVBFd2cwMDhD?=
 =?utf-8?B?SmxTeUFaODhrS3FpQmxKRTRoRXU3eWxpRndZVWRUckFudEg3c0hvRzdEUEpN?=
 =?utf-8?B?amZXWHg0Q3NTeG1VcWdhNWZDUytZdlJicnEwSGNqK1VicWRsclVYc2xDTlNl?=
 =?utf-8?B?Q01tZVQwc3dUVTV1RHFnMTdzQjVuTWdQWWYwZEhvejFwRE50TXY1azR3My9L?=
 =?utf-8?B?YStGZE9pVDJWYWwzQUNLODVzSGhrenRmeU9lVnl3WHNhWnl5UEY0Q3VIR1pE?=
 =?utf-8?B?Tm13dWpKZ1pIcVNIakZud0FtS2MrNFU4cndZK3d2Vk91cHcxT1RILzB5b3pw?=
 =?utf-8?B?RnBGWlV2VnNDbFQvcGpjZk5mZ2Rwek4zanZUR1cwd1NodWNJU2FUc21GTDI4?=
 =?utf-8?B?eVRwTVRQaVNDc0RTeXJWOEhHRjhRQ1Y3cndJSXVYWThIWHJiUTM3RzU4RmdG?=
 =?utf-8?B?ZkdvcEZoRjdab2ZDTjQ1THdQS1RZUW5Td2d1RUtOdlY1Y2pQYTBPQldBajhF?=
 =?utf-8?B?MWdsWENCbUhIcFdOMmMxb29WWW5TaWVxSlJmbUJRcGJxOU9nMnMreEcyTzZN?=
 =?utf-8?B?SW5rc3F3VjZnYkJFMGo1Rm9GQkw1WHZ0dUNyTE5BTWNkVFZQTXhpQ1lRNjND?=
 =?utf-8?B?ZFFyMDF4LzRFTGFGZXlxZVVBRmFyL1hGak5TVEUxNXpDT01YOHF3Vm1UOFNh?=
 =?utf-8?B?bytxaUxBTzhGRm5telIrN2d5RzJ4eVM1RWZHQUlBTmszT3hEaTZNVTFXOHFB?=
 =?utf-8?B?SnlaSmljRFgxbVUwOUhvUC9xZGFBaXFEaWhqTU1QNVVWZXp3dFRzNmU1Zmpy?=
 =?utf-8?B?SGNnSkMyOWNkcEkrNnJ2cEtjeUVqSWFaSlo1ZkljaTd2OXltbkY2SUx2d1JK?=
 =?utf-8?B?K2t2MjhDTXI2Um9RSkJPUzYzT2hEQ1RlK0ZLK2hCdlNVNWtoNmJrTGovOVN0?=
 =?utf-8?B?dDFYYWZDeEp6MFFSWi9yTFJiQUZvNk95UU9GUk9zYTBKWFpvcnV1YjNzVWox?=
 =?utf-8?B?NXk3blVlRzk5cmo3YTZNcVY4ZVc5RDNoOG41WDZwSzdPZGIwOHVEYiszbld2?=
 =?utf-8?B?ZnJWL2ZDblhlTFdoWmZuRC8xK21MTy9qc2F3RHEyZ3hvNU5CQ0h1WTRzYWNs?=
 =?utf-8?B?ZWxrTmVZTDFScmYxd1o4Slg1UklVN0JSSlRkdmZNM3VOTUIxNGVIdWJnSE03?=
 =?utf-8?Q?DzRAUoKZJCHba1XJguiqfI2DQ?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c785343-8e9e-4cc9-1c09-08dbccc4dcc2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6323.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2023 14:50:09.8309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w+ma8Umgrr1AiOrl0vpN+YvAkJEPFwCmBpyA5Z5JCvHYOJE1Tc6k/T5CnvoMwS6GEAsNxIsVaQaE8hrZvBJodQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5267
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/14/2023 3:46 PM, Santosh Shukla wrote:
> 
> 
> On 10/10/2023 8:16 PM, Sean Christopherson wrote:
>> On Tue, Oct 10, 2023, Maxim Levitsky wrote:
>>> У пн, 2023-10-09 у 14:29 -0700, Sean Christopherson пише:
>>>> Note, per the APM, hardware sets the BLOCKING flag when software directly
>>>> directly injects an NMI:
>>>>
>>>>   If Event Injection is used to inject an NMI when NMI Virtualization is
>>>>   enabled, VMRUN sets V_NMI_MASK in the guest state.
>>>
>>> I think that this comment is not needed in the commit message. It describes
>>> a different unrelated concern and can be put somewhere in the code but
>>> not in the commit message.
>>
>> I strongly disagree, this blurb in the APM directly affects the patch.  If hardware
>> didn't set V_NMI_MASK, then the patch would need to be at least this:
>>
HW sets the V_NMI_MASK.

>> --
>> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
>> index b7472ad183b9..d34ee3b8293e 100644
>> --- a/arch/x86/kvm/svm/svm.c
>> +++ b/arch/x86/kvm/svm/svm.c
>> @@ -3569,8 +3569,12 @@ static void svm_inject_nmi(struct kvm_vcpu *vcpu)
>>  	if (svm->nmi_l1_to_l2)
>>  		return;
>>  
>> -	svm->nmi_masked = true;
>> -	svm_set_iret_intercept(svm);
>> +	if (is_vnmi_enabled(svm)) {
>> +		svm->vmcb->control.int_ctl |= V_NMI_BLOCKING_MASK;
>> +	} else {
>> +		svm->nmi_masked = true;
>> +		svm_set_iret_intercept(svm);
>> +	}
>>  	++vcpu->stat.nmi_injections;
>>  }
>>  
>>
> 
> quick testing worked fine, KUT test ran fine and tested for non-nested mode so far.
> Will do more nested testing and share the feedback.
> 

Sean - I have tested original patch[1] for nested and KUT, worked fine.

Thanks,
Santosh 

[1] https://lore.kernel.org/r/20231009212919.221810-1-seanjc@google.com 

> Thanks,
> Santosh
> 
>> base-commit: 86701e115030e020a052216baa942e8547e0b487
> 

