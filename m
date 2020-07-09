Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D65121AA4F
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 00:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGIWMC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jul 2020 18:12:02 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:58238 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726213AbgGIWMC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jul 2020 18:12:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594332720;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=758EHlGaUry/NckEyeUvxCklE6cCvb630RQv0tLvdYA=;
        b=YeiB4IUa9BaFMn8WfH6/+gHqpwoKNFi5OfUnSvvry1A2xldDOY0t6uTQO+r+VPw6RQDNkr
        jO4c4RD1I+98x88lfiLqDfVMor8OJzcIVIQrvPwzppboKnTXbWMxnfQ0T9cn4hXPEvJaOy
        UKDvEcCzIE4rIRQ6UiVyIhlMhHpw9hw=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-iIk0BH8JNK-mE0BBHcq2XA-1; Thu, 09 Jul 2020 18:11:58 -0400
X-MC-Unique: iIk0BH8JNK-mE0BBHcq2XA-1
Received: by mail-wr1-f72.google.com with SMTP id w4so3331638wrm.5
        for <kvm@vger.kernel.org>; Thu, 09 Jul 2020 15:11:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=758EHlGaUry/NckEyeUvxCklE6cCvb630RQv0tLvdYA=;
        b=cmOlWeCRqbcwP4eAErCpq98MMzgJRJ2k9jtdnPjV1bBG4xFyM2a6nX+i6Xbid2IxjU
         6N0Tq07CJxIDddTDmmAGyRI8iUpNRnULanM/aUJSmIkOpLuBFTIedXPFTGdh/6rLGIqB
         XdO0ejOUJiiuQ79SKjpXqiJcogRnZM4IbtkXPgn7EYhwF2qNu3D56bOE+4FR9l0cdT0C
         SoAoAPw/oClWXgWb3H4dn5RiYkuEQJVlJxC2q8/hZWKs6ARUQ2H1LrBUOcrGOvGaodtE
         p36eAlJr1SWU+1+jxE8kBarJO6K2HAsAcZ+gRMM4DGjNML61EJIyH+Mkd8qnHAYgDHa7
         NvzQ==
X-Gm-Message-State: AOAM531qLWcex8RL+FgzP+UI+hhUZh1BCXIp7+ebjeg8peylEEgU+N1P
        R1RNW4mGs6tzqPEU8G5fmKo8xCy514TaWUwjVccUB+edyeZPx0IHNcVso/6FCJ4x2opQEAsisEH
        fTHLLuSRzmmTG
X-Received: by 2002:a1c:1dc7:: with SMTP id d190mr1971876wmd.36.1594332717246;
        Thu, 09 Jul 2020 15:11:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyyko/wjjykerR4DidiAgh7BXG5yDKDFtXAj+IWVbAOd/Vv2sJIVqB/tx9p5PEZZSQACpLVHw==
X-Received: by 2002:a1c:1dc7:: with SMTP id d190mr1971860wmd.36.1594332716979;
        Thu, 09 Jul 2020 15:11:56 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id t16sm7403677wru.9.2020.07.09.15.11.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 15:11:56 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: X86: Move ignore_msrs handling upper the stack
To:     Peter Xu <peterx@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <1cebc562-89e9-3806-bb3c-771946fc64f3@redhat.com>
 <20200625162540.GC3437@linux.intel.com> <20200626180732.GB175520@xz-x1>
 <20200626181820.GG6583@linux.intel.com>
 <47b90b77-cf03-6087-b25f-fcd2fd313165@redhat.com>
 <20200630154726.GD7733@linux.intel.com> <20200709182220.GG199122@xz-x1>
 <20200709192440.GD24919@linux.intel.com> <20200709210919.GI199122@xz-x1>
 <20200709212652.GX24919@linux.intel.com> <20200709215046.GJ199122@xz-x1>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <610241d9-b2ab-8643-1ede-3f957573dff3@redhat.com>
Date:   Fri, 10 Jul 2020 00:11:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200709215046.GJ199122@xz-x1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 09/07/20 23:50, Peter Xu wrote:
>> Sean: Objection your honor.
>> Paolo: Overruled, you're wrong.
>> Sean: Phooey.
>>
>> My point is that even though I still object to this series, Paolo has final
>> say.
>
> I could be wrong, but I feel like Paolo was really respecting your input, as
> always.

I do respect Sean's input, but I also believe that in this case there's
three questions:

a) should KVM be allowed to use the equivalent of rdmsr*_safe() on guest
MSRs?  I say a mild yes, Sean says a strong no.

b) is it good to separate the "1" and "-EINVAL" results so that
ignore_msrs handling can be moved out of the MSR access functions?  I
say yes because KVM should never rely on ignore_msrs; Sean didn't say
anything (it's not too relevant if you answer no to the first question).

c) is it possible to reimplement TSX_CTRL_MSR to avoid using the
equivalent of rdmsr*_safe()?  Sean says yes and it's not really possible
to argue against that, but then it doesn't really matter if you answer
yes to the first two questions.

Sean sees your patch mostly as answering "yes" to the question (a), and
therefore disagrees with it.  I see your patch mostly as answering "yes"
to question (b), and therefore like it.  I would also accept a patch
that reimplements TSX_CTRL_MSR (question c), but I consider your patch
to be an improvement anyway (question b).

> It's just as simple as a 2:1 vote, isn't it? (I can still count myself
> in for the vote, right? :)

I do have the final say but I try to use that as little as possible (or
never).  And then it happens that ever so rare disagreements cluster in
the same week!

The important thing is to analyze the source of the disagreement.
Usually when that happens, it's because a change has multiple purposes
and people see it in a different way.

In this case, I'm happy to accept this patch (and overrule Sean) not
because he's wrong on question (a), but because in my opinion the actual
motivation of the patch is question (b).

To be fair, I would prefer it if ignore_msrs didn't apply to
host-initiated MSR accesses at all (only guest accesses).  That would
make this series much much simpler.  It wouldn't solve the disagremement
on question (a), but perhaps it would be a patch that Sean would agree on.

Thanks,

Paolo

> Btw, you didn't reply to my other email:
> 
>   https://lore.kernel.org/kvm/20200626191118.GC175520@xz-x1/
> 
> Let me change the question a bit - Do you think e.g. we should never use
> rdmsr*_safe() in the Linux kernel as long as the MSR has a bit somewhere
> telling whether the MSR exists (so we should never trigger #GP on these MSRs)?
> I think it's a similar question that we're discussing here..

