Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 680B638F101
	for <lists+kvm@lfdr.de>; Mon, 24 May 2021 18:08:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237561AbhEXQIR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 May 2021 12:08:17 -0400
Received: from mail-co1nam11on2069.outbound.protection.outlook.com ([40.107.220.69]:59041
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236856AbhEXQHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 May 2021 12:07:31 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnWEXa8w1gKC/5y6noR3t/Roi18rSKdMlGhElv4dvMyY7s94kB85DcaCrVUl33mZlbpquBMNahb0VrkOwsLaKg8hsSOk2zTtm63EQm2WgE9rioq5tOnqLdNtFiCC+0YRV16fm2qneOCdbtbJ8SMYHVkye6e/l5OU8IWO5qw0Rb2z8F4mwVETWaYIKWtwI1aiIlf3a0JqlQiu29fmpFbv+wRjeuRnML3FOVy2r5/CtQH+YbxZkszXvSeyutU01SI+xcCyz1hYuzXkXTUoXSpAEQh7EUIuGl8boa7nrIbPFewUakxx/sIybJnn0mZarLWSuPPLhIKjoZBVuTcgXJ/zWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrLvtsGpIdSjLnLR50tqnfco293sxDutj2yl/sQtRyE=;
 b=Ar78Jz2WNG8RkAZaJ3EqUwUVZ3/JXgcy6A8Vtk+54WIfpXHhjncgN4v3Px7xabYRuF1n4q2y8+VzOmdi9Oo+iOfcSosq6wH8kU/3kPZoAsj/wSK5n3GCS7quvi2bL9d2hrRA4UHe86Zp72zW+vLFmiBuYcQx+dTVPJ6KVbF6JnjUWpsAaI0n+2bU2muv+imq9SstcEf8bLVBxAbIa+UxgOoDwm/pq2Nkmd+EVFLEZZfVDFNZwetuQ7IU40GFUiUm/yv4/08j9wxl63EGS6Sp6SMSCrcz6MDSIEwI5MPomg0iR77fFT5jMxIQdFaw2I17bfTuJsQEETvqW6G4UgaCUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lrLvtsGpIdSjLnLR50tqnfco293sxDutj2yl/sQtRyE=;
 b=Tp9SPRe6ky9rsJfZCbQavZEMYoI3tMEYwkultwGwD17JdLWdkAxy+sP2fE8SIS3FknniZgIpotkyUV3avkXWy1ricNY05vDpQNmtXiLtX11mOW2k2xMshZTdLUcOXgy2haKC6AYlDz8QaLVAD6UF5s9ljmVhveVYtW2ieg7sY00=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR1201MB0217.namprd12.prod.outlook.com (2603:10b6:4:54::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4150.26; Mon, 24 May 2021 16:06:01 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::b914:4704:ad6f:aba9%12]) with mapi id 15.20.4150.027; Mon, 24 May
 2021 16:06:01 +0000
Subject: Re: [PATCH] KVM: SVM: Assume a 64-bit hypercall for guests with
 protected state
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
References: <d0904f0d049300267665bd4abf96c3d7e7aa4825.1621701837.git.thomas.lendacky@amd.com>
 <87pmxg73h7.fsf@vitty.brq.redhat.com>
 <a947ee05-4205-fb3d-a1e6-f5df7275014e@amd.com>
 <87tums8cn0.fsf@vitty.brq.redhat.com>
 <211d5285-e209-b9ef-3099-8da646051661@amd.com>
 <c6864982-b30a-29b5-9a10-3cfdd331057e@redhat.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <b25ed6ca-ea45-ee98-4dfa-d24ee9bf524b@amd.com>
Date:   Mon, 24 May 2021 11:05:58 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <c6864982-b30a-29b5-9a10-3cfdd331057e@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [67.79.209.213]
X-ClientProxiedBy: SA9PR13CA0138.namprd13.prod.outlook.com
 (2603:10b6:806:27::23) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SA9PR13CA0138.namprd13.prod.outlook.com (2603:10b6:806:27::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Mon, 24 May 2021 16:06:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4879400-955b-47ef-8966-08d91ecdd322
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0217:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB02174C51B1CC3190D419BE49EC269@DM5PR1201MB0217.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +lnTTVX2rAJfEiDpWVM3fMY2qmImmL9tMW/BCabbzIb5zf5bICc+yDeUaeATBokZ570ikOf/yz+rcmRPgThxn4LpTSkeZH4wNSKd6yWhePCZLVszb3m0PSD8wvdfFU6MZOoKu82Ls6EOYeBYZ9WgVepIi9I6nXSopLHSdtTs9p5ZJDYgEa+cI4UdMxOPrZ+YKtOu+oY1LQXd9o5p/idLpJRrLECKdsFir1rRawB1ykSwMHvhy/lpr7MZp7t0/JmUBrFcwc4PCqjFDiUs1fH96A78d/86KVW/Hyh6t8aj72litM3avjyrYkE4N0E4chhDvClXLcBJ9WBG/mdnXmUK0Xn7jI2HVl9Tl0RMbPRnQjVfKzW8EYPntR+95QwkBHmNfhqmDwLX9r1i8NaXP5Tw1GJ6upiSBKAGLA6zfpjkifix5cvq4WBuqgRPVF9N2thS3C0GMSmIUcEdSayUbew1aNYEl7Sy3/8rrIYR3QF523iFh2R1ss/2N8LzmV76fJ/Wg5UiAFEh3037WTjZ2e8BBDWoRDJk9PhgFJzKuElKk5lZ2tnlC6sfrGAtul1MHoDiNYKlsmZzc+kyk0M3KOUY/H7Je6Hj+CsM8XmF3taBk9THUHVjCauhGre+uQPRMjd75XNXc/kvqS7kfUSxoDQDE0MYCbAYuDjTs8vjlg0R+/6Hw65a2Y/DCIw0KTcrpEGo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39860400002)(346002)(396003)(316002)(31696002)(6486002)(110136005)(54906003)(26005)(8936002)(4744005)(7416002)(5660300002)(4326008)(36756003)(6506007)(53546011)(8676002)(38100700002)(66476007)(956004)(6512007)(478600001)(86362001)(2906002)(66946007)(186003)(2616005)(66556008)(31686004)(16526019)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZUZxV3RyZkpIQ3JSTVEwTDdjcHAzL3NMc1lOTTdWUWVrazZ5K2JlTVQ2SGMy?=
 =?utf-8?B?NEZNSFlZdVZKbXZ3cERKTEREc0VIVVdEckwxM1h4TG9WUExRNkJnTzN1OWVI?=
 =?utf-8?B?R0pSdFZIbG5MUlNRWW1DWE5iM1I1d3BYQ0l1bjVSK2VYZDNmM0ZOZjJMYmg0?=
 =?utf-8?B?c0JwSmJrSDRtWGI1OHFQSW5pYmlOU20wcEFveW53Nk9IdjRnZktOOHJNWmRB?=
 =?utf-8?B?czU0bFZ1MGtUa1pKNkFqYU90cFhFRDA2M1NJV2RMeEJTMFZ0MFdRNWpseWkx?=
 =?utf-8?B?bHFQNzVJYm5CTmxWNGR2UkpuaHhEQUtZT3Y4d3FkUXBVTm5JRXZmdGhCdWYz?=
 =?utf-8?B?dEFMZERaaDhDRFlBTGZFMzh4WjBaNmJsNElJdDFLTTRmVXBaamRPN01nQ3Jt?=
 =?utf-8?B?bHY5bzRXeEcxeUZQcWtXYm1ZbFlvZTNMMTdGRG9GT2NGOGZPUkswMmhQWmtJ?=
 =?utf-8?B?em1oTnFYS0pLVkxUcXFrTzdjVzc5TWI1L29XTnBSdkd4aFc0QU41SUlrOU9v?=
 =?utf-8?B?ZGNuSENBbS8vTnlXTU1OM1lySmtQRmNZVWN3WkF3bHhWbWZkd3U0WUxPZ1JD?=
 =?utf-8?B?ZVdSaW1ETVpray9lZGRYUnpKb3kxczJhZTg3ejRsR29RWllCUFJPdi92emJu?=
 =?utf-8?B?TmFGYU12M2NTQ2JyVXhJN0ZhZEVZTjJUemQ4bmRtNkd6YkZyM1R6NjRPNmRU?=
 =?utf-8?B?dXprcVdESnNyQWk4TmdtYlRwOWR5TVc4VUd1eHFDa2VpY0lNbGhHNFJac3JW?=
 =?utf-8?B?N0VZZDhWSm1JMXJ0QVVoenVVaTBWQ2RhR291Z2ROTE1kSlZVekkzOG5QN0hE?=
 =?utf-8?B?VDVua1l5WnZIRUtaYTc4RXdQUmphUE1LbTFFd1pXaW11cSt1MW5IS1pML0N5?=
 =?utf-8?B?a1FyN3VqdCtFaVFJczd1VUc2RStzNDVscXFkUFJLcDFvZUhzamRCeTdML1pD?=
 =?utf-8?B?R2lYcEZkeWNWT3ZqbFp3ZnFTUlh1Ym1DZndRb0EvVFF0bndSY0RTOFpPd0dS?=
 =?utf-8?B?OXd5V0lrcGpDUDRxMGZ2RzkxVkxaYjdZcEpPUnRhR0cxc1VjdmJ1MzNENmhB?=
 =?utf-8?B?OEN1M1ZzMVl5eHNtOWxLekM0TXFjQ2pmU2FVSTFQQ25KcWcyYzBZQ1lYRmVD?=
 =?utf-8?B?SWluWXMyLzBxN3RwYjM3Vi9yMk5KR0FlZUc2aTBkaDdMMkJ6dHVjQ2ZwUDE5?=
 =?utf-8?B?c2l5SDUwSFpiNkxoaS8zRFBsVjliUlFldmE0cjAyNGt1OGNTSkM2VXVYWU4w?=
 =?utf-8?B?MU4wdTdjWnVEbjY1eFV4U0p5Z3B6Y2gxTURDNXA0MXhnRW50aVJrWmJHT3Bi?=
 =?utf-8?B?N2o1azVNUDUrNmQ0c0hPS0ljVy9wdXJSdjdmRDdaM3UwclRHMk9ZbG5ZZWlo?=
 =?utf-8?B?eCtXQVphc2RwOFR0K3pTYk10WUgwUFJFK1FyMUZ5cVgxb2U3YjJLc2pSUkpP?=
 =?utf-8?B?c08xMXJtQlZ2TktHc0h0MFJMa08vbWxnS0tIQlExa1V3QTcyVWFwUGNVSFhv?=
 =?utf-8?B?eHZBb1ZuTW9iM0FYcEhZWW5YQ0tLcWoyQStwOSs3RjloMTlqejV3NlRYaWd2?=
 =?utf-8?B?UkViY2k2Y1RxTmFoMHJFZWM1QUtIUG9iZ1Y1MncvL0FPT2xEbU01a01kUVR1?=
 =?utf-8?B?ZlhwK21qNGo4eUdZTFVvejUzOFFKSmFReFNMMk1YVUgxVnVvd1lINlRhdjU0?=
 =?utf-8?B?Y1pPSGprSVNKbDRyNXFMVlhZOHpFVGR5VkNVUGRNeXJzWlNVMk5HLyttc1B3?=
 =?utf-8?Q?W2QMfXhsPKTcn5IEf5aViXgRYD3Ekh6UYEM20XL?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4879400-955b-47ef-8966-08d91ecdd322
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1355.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2021 16:06:01.0690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jfTnqIox2xFzHqlO/ng/Z5OxuyYp/Q7QG/RTyx8RjxJGVI8JbP/QU9PLxKOkD3+Uh3r9TeK19oTKZYrto5ZR5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0217
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/24/21 9:20 AM, Paolo Bonzini wrote:
> On 24/05/21 15:58, Tom Lendacky wrote:
>>> Would it hurt if we just move 'vcpu->arch.guest_state_protected' check
>>> to is_64_bit_mode() itself? It seems to be too easy to miss this
>>> peculiar detail about SEV in review if new is_64_bit_mode() users are to
>>> be added.
>> I thought about that, but wondered if is_64_bit_mode() was to be used in
>> other places in the future, if it would be a concern. I think it would be
>> safe since anyone adding it to a new section of code is likely to look at
>> what that function is doing first.
>>
>> I'm ok with this. Paolo, I know you already queued this, but would you
>> prefer moving the check into is_64_bit_mode()?
> 
> Let's introduce a new wrapper is_64_bit_hypercall, and add a
> WARN_ON_ONCE(vcpu->arch.guest_state_protected) to is_64_bit_mode.

Will do.

Thanks,
Tom

> 
> Paolo
> 
