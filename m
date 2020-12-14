Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E722DA001
	for <lists+kvm@lfdr.de>; Mon, 14 Dec 2020 20:13:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502337AbgLNTLJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Dec 2020 14:11:09 -0500
Received: from mail-eopbgr760077.outbound.protection.outlook.com ([40.107.76.77]:54528
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2502154AbgLNTKz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Dec 2020 14:10:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jf4Tl+L5MulshEvs6gORFIPdUSdoLMVxynwoQKQdKXfjgvyFv6WqBoWUz1aAf18NLzaKvdBL6f412nSYtxVSK0Jv2b5v00hN1k+pKFdUmTDw6yTwr/5OAvGi7v7yMcfGGaq/YLXKk/MkD2UvBUH9rNYFG8dnyp7JzI7MAWfYAMYieT0lrsbUsGJShDdZNBPimTyFpsUL2x/tzDVz85ybbJwxzc96MT2l+Wb1hWrjPowI1PNsRp2Yd/K7ixUtZurJWM39HeUP0XyhAdlhfmmjKAMAzWUAXPmwPzdmXBPbDbPJT2UsIDq8e26EUqT+za1feH5sJFfRyDyWxKKGzg7hQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YF1r8gCi1UNwCsm/q/cr0heh2jIdB/If9kwol+enOY=;
 b=evtapN53a5G3xDigCqcj/J26dkqwOdK5Py9vjI/uPnVWxU9+/XL6FDnOKFF3fLKa0mHdZSBVKyap9w7f5Q9F7zO74kUFXkWgag1I6IbNELhMVfUNKrCrrNT+L64ml2/dzmsXOQm7SJ1JRUxhMfwsl3VwcXtkKt8JXenhiabBkfiZ0Hr8UdvczI0rAndkwfEi/TkzZ1AzEguKLeXvmKOlVzxGbolt4ssXD5BjLNPtwMP/7+THaE4+xHnNnsT07hJRCWp7pVWaJGgcMNFcHSNPAw/xC9uPoYgMs9H40QS7h44xRttP3DGn6zIQpWM7FG9ZRs0+N6RcjZ+oZQ/G5j5ZMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9YF1r8gCi1UNwCsm/q/cr0heh2jIdB/If9kwol+enOY=;
 b=ZiCd9NbJtkMn6dn49FZI7AbDqNs3/IA2yvCk5+YBED2f65fYiSg3UcDjdKATPGanueqU2z2NWbQuRuBhkDrqqHpG5l3YTMDxU3J5+/BkxvmP3jzNAopjqixD+DjQ3vJJiAGG5iPl7PjaTfEjMlDDLdLWCZ0q08Bb8MklL89ICXw=
Authentication-Results: amd.com; dkim=none (message not signed)
 header.d=none;amd.com; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1260.namprd12.prod.outlook.com (2603:10b6:3:78::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3654.13; Mon, 14 Dec 2020 19:10:08 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::d95e:b9d:1d6a:e845%12]) with mapi id 15.20.3654.024; Mon, 14 Dec 2020
 19:10:08 +0000
Subject: Re: [PATCH v5 08/34] KVM: SVM: Prevent debugging under SEV-ES
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>
References: <cover.1607620209.git.thomas.lendacky@amd.com>
 <8db966fa2f9803d6454ce773863025d0e2e7f3cc.1607620209.git.thomas.lendacky@amd.com>
 <da080e02-7921-1b67-2b3b-a480d38cfcb5@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <e8ace428-af96-663e-7f78-dff898dfa722@amd.com>
Date:   Mon, 14 Dec 2020 13:10:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <da080e02-7921-1b67-2b3b-a480d38cfcb5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [165.204.77.1]
X-ClientProxiedBy: CH2PR12CA0002.namprd12.prod.outlook.com
 (2603:10b6:610:57::12) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.236.30.118] (165.204.77.1) by CH2PR12CA0002.namprd12.prod.outlook.com (2603:10b6:610:57::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Mon, 14 Dec 2020 19:10:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: cc473a1f-d64a-49b9-5319-08d8a063df6a
X-MS-TrafficTypeDiagnostic: DM5PR12MB1260:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB12607D82A26FB4ACFA69D5FBECC70@DM5PR12MB1260.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3383;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qTX/F06YXcAqezIzD1YyhbtxjGRfGQtWS0T5cimZst8/jSGxVqLsy3lvZt2zy4r6BrmseItb/isi2ZXCgcYPokkcmHPdm8nlPok9hJ37eRwYxKckOe8iHTJQcOe1XVmuoPJojv5cnnhv2z1KGiqxq0v3FKwq54qk+srpZuC8tljarlSxwm9tJ3kvyjoM49KBM8yMTq3jEBXN3i/g4K1XV9kwjC9PUCp1p6FSkXjixd+4Nq0Ne5P2NLrHfriVvPEbaiemhH73jpKfAg7Jx99atQewNwg3VL9R8KKXn53a4aJlkc7pk8Eny8MkfUTsTjwhNPHTwV9HjRUcQG1gPIZSyl6uapitmBK+Hm4MrW3VjT6Ngi5lFvLIDVoRsPVz5Nft3V1JzgF9TuScKXxsSuJprPJcCVD8ZiFmLz8sb4GRwgxCiW8ykboqyMf4EZRTz8yhw+TqyKg3zbdLz12Xrk7QMnFu0AEZg37VokpTg6W2W4CTD1b1jxDw6PJUoryXY1VIXLFpXfGqk9kw72OnGdYmtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(136003)(346002)(34490700003)(7416002)(16576012)(86362001)(54906003)(2616005)(956004)(83380400001)(53546011)(4744005)(186003)(16526019)(52116002)(36756003)(31696002)(26005)(66946007)(66476007)(4326008)(66556008)(966005)(6486002)(2906002)(8936002)(508600001)(8676002)(5660300002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TU9POWdWUGFPd2ZsREUyajFVc0h0RVN6bTBFNmExVzBVbW02dHoyRlRTSXk4?=
 =?utf-8?B?ZGEyT0tXcy83dzYxWXFMZE9wTUdFV0dESVZveGIyUjFzSy84RjdiRDVweWJO?=
 =?utf-8?B?V3AzYVlYM1JLbG0ra3lUUmwvNXAzbjNIM1phbllsSWhHOVk5OUJlZUNVQ3lJ?=
 =?utf-8?B?K1JwaThUMENUbTlOam1qVXVKR1BLU2lVVCtUcVRldEhhVmk0REFhQk9xMnVx?=
 =?utf-8?B?Sm1hcWdDMUFTa1YwajA0T1FSa0pNbjFCSjZvQnhTUEtmWXFxQnNlcGUwdXNt?=
 =?utf-8?B?U3phRzdDRjU2QmN4K1cvL1VPQk1aRTJRbnAzd0NFbGVQcVFRMXRlZXdaS3cz?=
 =?utf-8?B?Y3BURHZmS3RsQ1hYcFZ1V0NTR3dFWjVqdEd1OEMrSjd4aDBObjdyTmRPN1Ra?=
 =?utf-8?B?ak5DRjNjV3pEdnptMXNPUVB5ZHB5L0MvTUVoMlZPcnhMbHVrYXh4L0pFdTVB?=
 =?utf-8?B?NUEzT3NwQ1RocHJ0cmdWaGYyYUlNN0lCZVcyKytrY1BMdW5Nd3VMQ3dpWnEz?=
 =?utf-8?B?Q3cxcHd3TUlFSnZHZ0doaDNOV0Vmc0ZrTGRKZ0hMcDF3RUFuWDd6NFZIeG55?=
 =?utf-8?B?NVJ4OTZGbjN0WEI5Y3pkSDA2RmE1cHJicElONldieEQraWNNeHdHVGZ3UHhV?=
 =?utf-8?B?MkRGalJxYVMvd2pwbUhkSm5FL3RROGF6TDlpSnl2MFFIaHhUeHQrVjZQZDZl?=
 =?utf-8?B?NTdnWExMNWlqODZWY3hwN2wrRDQ5eXJDT0lZTTY4WmZTNWdIMCt0ZDJpendZ?=
 =?utf-8?B?T0x5SFFaMVUzWnMxaVJ0OHVaV0ZxTm5QWlhkeFR0TW1mSUFRR3FpakZYTTlW?=
 =?utf-8?B?aENzM0NzdFUvajZUSTFxOGVyUitYUnQzTkpDQy9xOWtTNUlGUlpmQTAxckJF?=
 =?utf-8?B?RWtXTlhPaTdCdFJ0MjBtRzFqR2pFbWhnWTZMWnpqcnFndlZ6aUZsL0V6QU43?=
 =?utf-8?B?Z21KNmZSVjZvaDNtbjlZd3VPQm1BVzIvUWVnWlpua2t5amlkVGt2VkpyZ0cr?=
 =?utf-8?B?cTY1N1BSaytxYXBjSEU4S0VWUUt6TmVsOWt0dEhlWkg1RnVHbzlqQWxZZkky?=
 =?utf-8?B?QTR5SEpWdmQ0K2lYOUo4TUp5NDFJdm5LQ0dTcjdoZTlIWHU4akk2aFluSUdU?=
 =?utf-8?B?ZU5DRHVlZk03Zzl4TmJhNnJVZ2pBTHh4NDFRSmNoZGowbDdyL3NqeWpVb3BX?=
 =?utf-8?B?bHFpQ2lrM1hUU01PMHJXVnRkN0xldXlRK0ZQWEJQMVkrcWJxZk5xUEVkblZt?=
 =?utf-8?B?Vk9KcG1zMjg3dVRsZlRlb0NxSjJBM3FuVFhZenQvbndESVErR2ZENTZRb05v?=
 =?utf-8?Q?ynvv1FHq/3TTsqQ8zZh8penNwQUr8s2Fpx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2020 19:10:08.2459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-Network-Message-Id: cc473a1f-d64a-49b9-5319-08d8a063df6a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5VsHzL4HYUcmkpSdQgflvHEB0z9geRIrso6sYzXm4xSaZPayXiZz3pWlP+5zwVL9njBLUPZT5F6hRz9YSl60Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1260
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/20 9:41 AM, Paolo Bonzini wrote:
> On 10/12/20 18:09, Tom Lendacky wrote:
>> Additionally, an SEV-ES guest must only and always intercept DR7 reads and
>> writes. Update set_dr_intercepts() and clr_dr_intercepts() to account for
>> this.
> 
> I cannot see it, where is this documented?

That is documented in the GHCB specification, section 4.5 Debug Register
Support:

https://developer.amd.com/wp-content/resources/56421.pdf

Thanks,
Tom

> 
> Paolo
> 
