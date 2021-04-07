Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C17B3572BB
	for <lists+kvm@lfdr.de>; Wed,  7 Apr 2021 19:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348197AbhDGRHH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Apr 2021 13:07:07 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:44331 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234050AbhDGRHF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Apr 2021 13:07:05 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 4FFrR00jRRzB09ZQ;
        Wed,  7 Apr 2021 19:06:52 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id 5RNxtr6d0LwG; Wed,  7 Apr 2021 19:06:52 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 4FFrQz6rN1zB09ZJ;
        Wed,  7 Apr 2021 19:06:51 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 8E54D8B7B6;
        Wed,  7 Apr 2021 19:06:53 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id Xg2uihRRaosX; Wed,  7 Apr 2021 19:06:53 +0200 (CEST)
Received: from [192.168.4.90] (unknown [192.168.4.90])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id C34438B75F;
        Wed,  7 Apr 2021 19:06:52 +0200 (CEST)
Subject: Re: [PATCH v2 8/8] KVM: SVM: Allocate SEV command structures on local
 stack
To:     Sean Christopherson <seanjc@google.com>,
        Borislav Petkov <bp@suse.de>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-9-seanjc@google.com>
 <9df3b755-d71a-bfdf-8bee-f2cd2883ea2f@csgroup.eu>
 <20210407102440.GA25732@zn.tnic> <YG3mQ+U6ZnoWIZ9a@google.com>
From:   Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <24cd7d2b-3b74-6b51-aa9a-554003fe5cec@csgroup.eu>
Date:   Wed, 7 Apr 2021 19:06:35 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <YG3mQ+U6ZnoWIZ9a@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Le 07/04/2021 à 19:05, Sean Christopherson a écrit :
> On Wed, Apr 07, 2021, Borislav Petkov wrote:
>> First of all, I'd strongly suggest you trim your emails when you reply -
>> that would be much appreciated.
>>
>> On Wed, Apr 07, 2021 at 07:24:54AM +0200, Christophe Leroy wrote:
>>>> @@ -258,7 +240,7 @@ static int sev_issue_cmd(struct kvm *kvm, int id, void *data, int *error)
>>>>    static int sev_launch_start(struct kvm *kvm, struct kvm_sev_cmd *argp)
>>>>    {
>>>>    	struct kvm_sev_info *sev = &to_kvm_svm(kvm)->sev_info;
>>>> -	struct sev_data_launch_start *start;
>>>> +	struct sev_data_launch_start start;
>>>
>>> struct sev_data_launch_start start = {0, 0, 0, 0, 0, 0, 0};
>>
>> I don't know how this is any better than using memset...
>>
>> Also, you can do
>>
>> 	... start = { };
>>
>> which is certainly the only other alternative to memset, AFAIK.
>>
>> But whatever you do, you need to look at the resulting asm the compiler
>> generates. So let's do that:
> 
> I'm ok with Boris' version, I'm not a fan of having to count zeros.  I used
> memset() to defer initialization until after the various sanity checks, and
> out of habit.
> 

Yes I also like Boris' version 	... start = { };  better than mine.

