Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9161A32B59D
	for <lists+kvm@lfdr.de>; Wed,  3 Mar 2021 08:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381637AbhCCHSv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 02:18:51 -0500
Received: from mail-mw2nam12on2055.outbound.protection.outlook.com ([40.107.244.55]:31424
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1444808AbhCBTa7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Mar 2021 14:30:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oR/6HpjFdYmvVtkAl0ohwqsc2kCFBZQdoRoLfzupe0EJTVvd6QCBFFr1s/42mWwJQJjP2W72osajrzRdOUbnWqIjQaIJOr5s4mrWctsCfaK4iPS1HKQn9ABYOBpNWXCug46uQ5QyhObzpkkgDya6AUGNB++IJwOxT8jfXugHgzG/MrwxzDNTP8CtsVHjrjIsro86/sNKjSbKrGwxnyHTSwY+xr57PougJ7Abs2l11T3r+Knho9YFUFLunyEiefQsPDHDfh+duQEJ+WPDdhz1magFTBjW3Ia7gSHw609zzcOS9KgELszKVMhaDrOJ/X7zKEjnAUphkCOAAqJsPRJU5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwHzjuizwLb0twuL3oVC2V25+PyPFUpwoQEmqMbTPn8=;
 b=XnL0c9dDGuXlg/o/6Mc6Q6vqy6yDNVM+b9u2B57QmN1VUfed/zbD5VH+Guf+Ew6wvF+IBq7WBIhIrBWwhvalsFvF9QKQEix2Ti56um2yTmfMsu9bUhxtNl+XpglLBZAOXXvlzHv1JZu6Tk88YQdfxOtvPVA6DR2eIUYVhYsTQ8Pvl329xWQ2mmoHZT3fqoPNgKYkVS08LtV0Igl2f5CTliDhBjwx8C9eYMwXL751T13Y1d9sRPXKdOTYW+G6nwkefY+VgVhgwGoZ8oMnK1tkkPZRwHWyh0NCm3Qmeb2LdiYnUCwluUHIWOrR1y/PNyNWf+8qlu29GFzB8HAoYNUHrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwHzjuizwLb0twuL3oVC2V25+PyPFUpwoQEmqMbTPn8=;
 b=Ycr6kLp3In5EtpbeeJJmyu9FSeDVl5QUur8IHzT7nUtY91DKJAJlbUThCTHh6I+mUnkP8AiqDOsb6qIjLkTg+QvN2bbd3cZ90640wSyLZK9bUhnqcvMsfs2jrpr/cvx3wQ45b49JTar7CJwzVUO7Sgvvx/bayM7udQzgQQTzwI8=
Authentication-Results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2560.namprd12.prod.outlook.com (2603:10b6:802:26::19)
 by SN1PR12MB2462.namprd12.prod.outlook.com (2603:10b6:802:28::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Tue, 2 Mar
 2021 19:29:25 +0000
Received: from SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff]) by SN1PR12MB2560.namprd12.prod.outlook.com
 ([fe80::8c0e:9a64:673b:4fff%5]) with mapi id 15.20.3825.040; Tue, 2 Mar 2021
 19:29:24 +0000
Subject: Re: [PATCH] KVM: SVM: Clear the CR4 register on reset
To:     Sean Christopherson <seanjc@google.com>
Cc:     pbonzini@redhat.com, wanpengli@tencent.com, kvm@vger.kernel.org,
        joro@8bytes.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, vkuznets@redhat.com,
        tglx@linutronix.de, jmattson@google.com
References: <161471109108.30811.6392805173629704166.stgit@bmoger-ubuntu>
 <YD6P8TbrZKD4zbxV@google.com>
From:   Babu Moger <babu.moger@amd.com>
Message-ID: <40c066f0-7992-a574-c263-b6448dcfdcc9@amd.com>
Date:   Tue, 2 Mar 2021 13:29:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <YD6P8TbrZKD4zbxV@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: SN4PR0501CA0113.namprd05.prod.outlook.com
 (2603:10b6:803:42::30) To SN1PR12MB2560.namprd12.prod.outlook.com
 (2603:10b6:802:26::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.31.136] (165.204.77.1) by SN4PR0501CA0113.namprd05.prod.outlook.com (2603:10b6:803:42::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.9 via Frontend Transport; Tue, 2 Mar 2021 19:29:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 88f76b67-0e1e-444c-5faa-08d8ddb17cda
X-MS-TrafficTypeDiagnostic: SN1PR12MB2462:
X-Microsoft-Antispam-PRVS: <SN1PR12MB24627185AD7E29C33B2C56A295999@SN1PR12MB2462.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5hX1iTqm0Cu/VjAwTZm3DfbiQMI7HqX+WL2Sjxhg8ONteeyvsZ1no/6F10X3r7RI2EC3LJdaPUPXZiD3kuA+jQdSfouIV5qkWtkf7iK+YbG6jjHz4pB+/w5xJP5rpcBaVufDuuBgXFfRRIYjvjqBBUE0/KRBiZDoPYMIsgMjPLPszCPWDXs/HDRBYT7C/K/d2ZTgjI27WRvsLLaqkBUimzPR56wrCavi6b0XGsz9gawyVC9xrzTatDoMMClHDr1xIqjrDm3cLlUXU8omAgIIf7cwS3QGsAPtaOizlH7uMh0ynfE4DUB+pHqRtcHZEvWBKnLB4jfLhqqgMmT48KapcGX7e6dwWi13lQWXEDKiS0d2N2ArnPfTffJ94mqw4k2vfTLtHrUxLqHHK+nlSo4pcX1zSamCz87JX/A9Ro/zdiDF1K/60c3qmmLv0SvXzge9PafPolTzHyS+H7sQMqIwIhSCPhC8wZJ55iU9kUmo5wVE6oRQYC0L7tzBQsYED2OnORNDZCy6g68cZvjDfFyuqEYwiukAulsyiTRGTx+T4ZQpyg3mVQXZL9oVmtoenlY5qPitS67eQIHk1h9bxiAGFJYC+vl/8EXYQyRyfbuPr0Q=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2560.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(366004)(396003)(346002)(376002)(136003)(44832011)(4326008)(31696002)(478600001)(26005)(186003)(16526019)(6916009)(8936002)(53546011)(8676002)(52116002)(5660300002)(66556008)(66476007)(31686004)(66946007)(83380400001)(2616005)(316002)(7416002)(956004)(16576012)(6486002)(36756003)(86362001)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VkpOaGhjNG41M0w2dUF3ZC9sK0lQV095NjU2aS9renVVL2ZCVzdTWE53ZWha?=
 =?utf-8?B?Q3c5Mlk1OGZET2xoTG8vWmUxdHB5WVlEU21mSWhmS1FxbFV1ZXMxVzBUWWpP?=
 =?utf-8?B?bW5jYjNqbFczOVhiazg5dTcvcExpTTJLdlNLR3JKcDFYMFBhcU83bFJ0VFJp?=
 =?utf-8?B?OTJFK1JoQUlYOUpkU0lSbmNTN2ZMWk5QYlVBRExWdGtXbnFTVU4xVGVZdnMw?=
 =?utf-8?B?SHR1cnpQQTlTZXowL0dJSHlXcWVKaDVrVkN3WUNTR2gzQU14cHVBSnJmd2dW?=
 =?utf-8?B?RU9xaUxoSXhxbzhNVXIxd2U4MFdOL2MvbUd1cnpiTjhlUVNhR2JTL1IvdDZl?=
 =?utf-8?B?c1J0ZW9RTzlnY3hMai81YTZnNEZuZDd1blJIVTU0MjZOK3dWWVVoNzdQeGly?=
 =?utf-8?B?VVVZdTdybHVDVDRwUVdWTEJpUW1VbnJKUzJ0Q1dFRzJJNFozbjFsdXN3b0FL?=
 =?utf-8?B?ejZjTjdXVlpTWHFhcWdwNW40eXFYRktnNWU2dGZGQ1kyOGRwTTdnak41cXJM?=
 =?utf-8?B?VHNUcElLUi8xdDVsNzJ6cHNob20zZitEMWU2QjNPY1NWSVdCT0Q4WmNTTGxG?=
 =?utf-8?B?SVp2T1VOVG9HdU5LUjR4TmlKQ05aRnFmMFV4UmFCTjIyL3FiMmw4WENtRERn?=
 =?utf-8?B?WGp2NDM3WVk3d01rYTc3aE5jc2JQSlBlbWM0Y3AzaXJ2bkVNbW5tUzZka3Av?=
 =?utf-8?B?c01XVFpZSGROSUhtUWk4bzFlZ096VnJ0SmNUQlhmSG42cElrdjhrblJoVkw4?=
 =?utf-8?B?aFlyS1o4SzFCNVVVTWdEMG91U3lESHVDZmsySzNoQzY4UldsZXZpY0JIMW9v?=
 =?utf-8?B?dGEwK21pUHlQZ3NLaGI4UHo4VFBxUTQzcVdpR0doR0F5U0NlbDhqSy9pRHUx?=
 =?utf-8?B?eWRPL1JGRFZUaWZUdWNmM09KOHlaTnNVYjVESVNRc3QvWVE1dUp5VmlkRGgy?=
 =?utf-8?B?YkJWREM5UDgyS0ZQYlFMNFNONzJlTEZ2UHlYZzhDTUJ4TmhHZ1Fwd25DY2Zo?=
 =?utf-8?B?SXo1YjJJcDVJUGowUk9VeHNBYWpHaGlraEJQVFA3UWc5SGVXYlFSZXJxeUVB?=
 =?utf-8?B?bFVlaDhmVFRKeXVPdkpuVGx1bU9vcmUwQXVhVm11QThROU5HUjJsV3dyK2o1?=
 =?utf-8?B?cnQ1VVIwbmZneENIalpEZmxLN0hSTHIzcVcwQzkrb3g2QlFSZ0RUODRBUkdD?=
 =?utf-8?B?RzhBK3R3bS84ZTZ4dUMvN1hlTC83SWlpOXM1MThwb0IxK2kvd2Q0SmVkNVRh?=
 =?utf-8?B?TzlmZFc4cXR3czkyOElWRmlHbEd0b0RtY2RFNFd4OXFseXc2amZrS3VNZ1lv?=
 =?utf-8?B?MmdtNjJEb0ExdTNiOW1VeFAvejBrNWlZSURsZThzZ1hHV3Y0L080ZVYxVEpX?=
 =?utf-8?B?RjhjTDVramEwYnVHTmduZ2N0QXQzRTB3RTJnK041R3FIemtJdVVLQXQ5c1oz?=
 =?utf-8?B?cWlTU0ZkYlpXSjhQUm9iL2VvaFd1Uk5kUVVBRzIxZWpCbWV1YXpJRmJlSjgw?=
 =?utf-8?B?WFNtVXppK25rTmd0WVBLRWkwTkxHUjI3V0ZHYXVaK2F6YmlCTHpSd05PUGhw?=
 =?utf-8?B?c0JpTkZZVVBMYk9qdHdzOGNNY0swK1FDY1V5U0s4c2J2bVJCS2xjRTNiKzN4?=
 =?utf-8?B?MFFMNmpEZHhXV00xY0o2VmFZVDdpd0lEM3pnZTlxaDBBdWZUcnoyTEJYSW9o?=
 =?utf-8?B?WTJ4TmY4U0xFdytmMWtTRUdDNnc2MmQ5ZXF4dURnbkhHTmdEbjZ2a0dhbTgv?=
 =?utf-8?Q?YzWYhlAzyS3CJng/KnjmufJvf8IWgCUX5UDK+OW?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f76b67-0e1e-444c-5faa-08d8ddb17cda
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2560.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2021 19:29:24.8310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PnI55bnoxcfgQCobNnLfUBIex1qZULc5koErUi1wRoeVjn4vu+PB1tQJv6smUxaE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR12MB2462
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 3/2/21 1:20 PM, Sean Christopherson wrote:
> On Tue, Mar 02, 2021, Babu Moger wrote:
>> This problem was reported on a SVM guest while executing kexec.
>> Kexec fails to load the new kernel when the PCID feature is enabled.
>>
>> When kexec starts loading the new kernel, it starts the process by
>> resetting the vCPU's and then bringing each vCPU online one by one.
>> The vCPU reset is supposed to reset all the register states before the
>> vCPUs are brought online. However, the CR4 register is not reset during
>> this process. If this register is already setup during the last boot,
>> all the flags can remain intact. The X86_CR4_PCIDE bit can only be
>> enabled in long mode. So, it must be enabled much later in SMP
>> initialization.  Having the X86_CR4_PCIDE bit set during SMP boot can
>> cause a boot failures.
>>
>> Fix the issue by resetting the CR4 register in init_vmcb().
>>
>> Signed-off-by: Babu Moger <babu.moger@amd.com>
> 
> Cc: stable@vger.kernel.org
> 
> The bug goes back too far to have a meaningful Fixes.
> 
> Reviewed-by: Sean Christopherson <seanjc@google.com>

Sean, Thanks
> 
> 
> On a related topic, I think we can clean up the RESET/INIT flows by hoisting the
> common code into kvm_vcpu_reset().  That would also provide good motivation for
> removing the init_vmcb() call in svm_create_vcpu(), which is fully redundant
> with the call in svm_vcpu_reset().  I'll put that on the todo list.

Yes.Please.Thought about cleaning init_vmcb and svm_vcpu_reset little bit.
That will require some more tests and review. We didn't want to delay the
fix for that now.
Thanks
Babu
