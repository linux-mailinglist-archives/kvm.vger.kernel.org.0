Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47F401C7FCE
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 03:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgEGB3R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 21:29:17 -0400
Received: from mail-dm6nam10on2073.outbound.protection.outlook.com ([40.107.93.73]:22913
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727803AbgEGB3Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 May 2020 21:29:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dc/mApYSPV8RvO80nIF0AXTuRWjC5BYuWU3kp/47Fq/7EjLqbf69FJzfd8iHsm+Bn4lnSSdHqnMnqRHTV3MCQ1YwA2yABPpz+KB9DR3j5J518luBCAwreHf/5W4SZkLoVRvPDOWrXt0I49fe2zDmdD0bM/zb9yd7rAa32lmO/70IQxUkDDQf4sO29bebPtrTosfgd9f88If+g4X8SfJtWy37E+96MYMQJTCtm/PhD5Ia6AmkbJt/rZaCmoeCMMdLWwpsoiMjM5v6IpXM3qBoWf/IddS1WuPS6THiXwswzC3RR9HyMilZznVYAb5d1cHpkAX+xVBX6BLKrc4rTm1kzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo5Zw2i3cJpNH+LOw8zFlHxTdvCzfwVEcKpSEy6VAz4=;
 b=WLT/zLwed/W4NwHT3rfXUrYNnvcR3NR21DSOqm0TgW0zydENSg/ckyaV6xXGrtGEtJdXnEOyE+7OlpYs1HLgMVuTFIjUqPJxkfP+hLYbHKqdqvIqBmK8TZ9HNEBY99g7H63nd7LSbjo5bKqWhTrA7NE0uc8ZqvjQw3CGiLuSoHxm1jwcsQIqEv+KXTCmmIW9N0wOQyOCl23QlEX66cdH4D/a0/wUqaKPY9Su1gS7Hy31ga/p83uKpj7PY5PO0Ydig+xUlyDx949LEBaE+aORZDtCFix+VZ2Lex7o7cEt4tBRIv0pAVWr3PknVBJFrjTjZhHv9xk5fTos9CrHYVkUbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vo5Zw2i3cJpNH+LOw8zFlHxTdvCzfwVEcKpSEy6VAz4=;
 b=iD+R1kQQMVPpMcAMY/PTvCise5mv7ZvHwKaAp9V2dN8bpXPIzh2GJBGF+uf4G4SJVbTPQ64QXD0emlc1cODsvYTzBvHC/Ld3sAKFDmR5HwqmpRWPJJV8C0K3/5J27T/czTtY9qs/CHGKBcEwm9z5deFVL4vF8dUNWY0r/0BdBoA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1163.namprd12.prod.outlook.com (2603:10b6:3:7a::18) by
 DM5PR12MB2503.namprd12.prod.outlook.com (2603:10b6:4:b2::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.21; Thu, 7 May 2020 01:29:13 +0000
Received: from DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744]) by DM5PR12MB1163.namprd12.prod.outlook.com
 ([fe80::d061:4c5:954e:4744%4]) with mapi id 15.20.2958.030; Thu, 7 May 2020
 01:29:13 +0000
Subject: Re: [PATCH 2/4] KVM: SVM: Fixes setting V_IRQ while AVIC is still
 enabled
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     joro@8bytes.org, jon.grimm@amd.com, mlevitsk@redhat.com
References: <1588771076-73790-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1588771076-73790-3-git-send-email-suravee.suthikulpanit@amd.com>
 <a963a336-4096-b53a-276b-6509f5cb9402@redhat.com>
From:   Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Message-ID: <169cb2fb-f792-2d79-688a-3696d9074594@amd.com>
Date:   Thu, 7 May 2020 08:29:03 +0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
In-Reply-To: <a963a336-4096-b53a-276b-6509f5cb9402@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: KU1PR03CA0031.apcprd03.prod.outlook.com
 (2603:1096:802:19::19) To DM5PR12MB1163.namprd12.prod.outlook.com
 (2603:10b6:3:7a::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from Suravees-MacBook-Pro.local (2403:6200:8862:d0e7:b8e0:e252:3d1e:5b4e) by KU1PR03CA0031.apcprd03.prod.outlook.com (2603:1096:802:19::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.11 via Frontend Transport; Thu, 7 May 2020 01:29:11 +0000
X-Originating-IP: [2403:6200:8862:d0e7:b8e0:e252:3d1e:5b4e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 91576003-49d6-4b36-bc39-08d7f2260cc5
X-MS-TrafficTypeDiagnostic: DM5PR12MB2503:|DM5PR12MB2503:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB25039614F37C6636B8ACBE76F3A50@DM5PR12MB2503.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 03965EFC76
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QQr2uk4MSGjm6wCn9MuFLdpTkEf6lxNFLewjs/PHb8RoekTVh3JVzGffQQ1CWK+hrUW7JOfJUCQMgG1HOVRgu0fp27GVKDUu4BlJVzNCgvJK2jCcqUyNmSL5KFUgcHopGvmmzjjS6GC/jNDNIzJ77ukl+dAw02qLKNLsnTX3PXVc2xjegjbM3qYBJ6WE+LgSWXdXqS5MBH7he09xW3pNUHmnPF2b3jeG8GrjQpdKQmjnOV8uUgtY//NCGAkluLJ8AVJtFVz3bHROIAfvOXdeuXxYtA9w0BKfvbNohb+uKesmR/TvdUa9/BkV1IaWBJnD7Cv8Zxu0acrizQZCADLWmRUg/OOimG4LQu3+gtxoYoEUUmJRL8sdwmVMNSSwMkQonC6SDqUoyzkRSOLWay/0yTffse7KUUP4kNqrUe0rAeTyIJx6OTkue88244Lh6YSWR1y+PI1KKmT/BgO8KWuOjsa5aqrKKug7pi0pw0tSiiv9/6b0lpa6YJ+y6JI8gT+HzE142NMprRvHOwtXNnInVTkOESn0CaYLZ80ea1K65lJlGDnvPJ1UiWgKs9ayUJIX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(366004)(39860400002)(136003)(376002)(33430700001)(4326008)(31686004)(478600001)(36756003)(6486002)(6512007)(8676002)(44832011)(8936002)(5660300002)(33440700001)(52116002)(2616005)(316002)(16526019)(186003)(66556008)(6506007)(53546011)(66946007)(2906002)(66476007)(86362001)(6666004)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: Q3twV10RYhoCRTuDxahUeVMSemw312wZ3drfk8k5dENB78TNJTt83TmaCGJglm4A4xKR2vahTo/lvVoCU11/jdnaYcdicXEUL07cDomN6k4z2Etw99sHAwWmmr8bh0VnfzJdgmTILPq+sfpiNAMZeA4gdcyurhXhhq/JOiqJ8GhioJTh8Bg3CDTH2Gg7AuEuL/IiKIYnDUA60C7VSmB+ojBDLYgi7z8qmuT7XLo38wNG1lVayWpRV0bqEydY8FcL9xwtmNN1EWtsTlpM/GLxQw8ax6gqTJ8ykwxAZx2hfOqKhiKb/d6kL1kzm6ds1Gsuli9F+G+77MFddzRdOWgrMkHk6NwacDVMwffjrR06EkA6JqHTB8OMDBccXzqC3hQ1igMr0QSwIayr92TbRDw/Z/joEKRLf0TYDxfZxQ+ifWcr2nTuVK0K+3Q2r1ysPSx/1YJ4OITqJJIUHrSBhkDmndFP0mzXa1a3QS95knJqMSzIZHMMlmHQeeu4c/xMNkf3rksLM4fIIYocqevGRh8o5y5w57D/7eA++wkPHBOmsvfxszXnm932AEaK+UHtdYp0nI1JFsZ4lMBhp4dZPtLWsNBc/XwJxsyoB+t5CVFCL4tNqNp7IBwz8YGcPDpceyo99VQOWLNBJusNeUE7N4Kp8faxxjCBtUeOZ8Ia1QScDspu/HqZclK1vfEU9fUxEY94qkuRlj4D3wni3cudtZcBhhg6NDE0nORq7uKnTd+CbtjSI4w7lgdDQKD1xrMQHsKFuecnDnUK1FDBIJ3SN+vkzrOz7G+hwwm1FWBtxdJYy9jw3binrCuLRMG/3sruGdt2Mv+JxaqvWLsKGaDPkIP5tnvPZA5y7Fkz1Z/7nckX34bl0ZeAkk+xyqxWofF+cQd0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91576003-49d6-4b36-bc39-08d7f2260cc5
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 May 2020 01:29:13.6497
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VFl/LPC/CNzj/emyEUGfpIs4cFSF6cdg+C/dhJJZkSzmgp933bEVH7oM03Tl5CPmJfQ4QaIP+yrno8FiA6RJIg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2503
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/6/20 11:29 PM, Paolo Bonzini wrote:
> On 06/05/20 15:17, Suravee Suthikulpanit wrote:
>>    */
>> -void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>> +void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit,
>> +			      struct kvm_vcpu *except)
>>   {
>>   	unsigned long old, new, expected;
>>   
>> @@ -8110,7 +8111,16 @@ void kvm_request_apicv_update(struct kvm *kvm, bool activate, ulong bit)
>>   	trace_kvm_apicv_update_request(activate, bit);
>>   	if (kvm_x86_ops.pre_update_apicv_exec_ctrl)
>>   		kvm_x86_ops.pre_update_apicv_exec_ctrl(kvm, activate);
>> -	kvm_make_all_cpus_request(kvm, KVM_REQ_APICV_UPDATE);
>> +
>> +	/*
>> +	 * Sending request to update APICV for all other vcpus,
>> +	 * while update the calling vcpu immediately instead of
>> +	 * waiting for another #VMEXIT to handle the request.
>> +	 */
>> +	kvm_make_all_cpus_request_except(kvm, KVM_REQ_APICV_UPDATE,
>> +					 except);
>> +	if (except)
>> +		kvm_vcpu_update_apicv(except);
> 
> Can you use kvm_get_running_vcpu() instead of touching all callers?
> Also a slightly better subject would be "KVM: SVM: Disable AVIC before
> setting V_IRQ".
> 
> Paolo
> 

Right, that's better idea. I'll send out V2 separately.

Thanks,
Suravee
