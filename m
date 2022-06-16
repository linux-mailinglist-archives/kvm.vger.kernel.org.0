Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED04454DF37
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 12:37:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359319AbiFPKh0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 06:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiFPKhY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 06:37:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 457355DBF7
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 03:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655375842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3qiH3O3kz9G2/mcshIbbtQDuhVY5iI/CJh4BS6LwMAk=;
        b=C5xGubDVcoA+UYvYdwpD4UuUGC+9ipyvYY7HCKBzG2BVPM+uFoaDsU4idm0qSgdOrJU2gh
        o9LQP95pW1xibW36XKzKbqU2Yzn7pVuSPRmNVkXG1NP7U9QdK5q5cSJzg9yvqLht4PvAgg
        OThcZ5IDIRtUZNOxWEhk8Fsh2QeKee8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-209-bUrhtooCNC-N4R4er1PUfw-1; Thu, 16 Jun 2022 06:37:20 -0400
X-MC-Unique: bUrhtooCNC-N4R4er1PUfw-1
Received: by mail-ed1-f70.google.com with SMTP id y4-20020aa7ccc4000000b0042df06d83bcso957093edt.22
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 03:37:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=3qiH3O3kz9G2/mcshIbbtQDuhVY5iI/CJh4BS6LwMAk=;
        b=q6kfx3PvwJGFzPZnMV3+PS7vS+J69Qz0GCG/NwzHfI5fzcz++9MHr8mlQBH/Yi4D6G
         3QdzWZl25P6qd05QBxX7Sc6//dXMpHTsSc2EPNdLhG3ARn9yGWC2BrUJKdA26vT1FG/b
         Hc6FzYi4J97x6Ec1LUT951GkgksWdz4m23VEVuHDOy1XqdoE1fgkKhMKtprYDOCHz5Ch
         NuqJIkS3hIehy9C9aSAejJrc6dVtVtln1QgjB+xQotQp/SnYGnfEn+tY9TB+D6ZA/fyZ
         tsmOGkyEQk/k7mR8PskHgkFzhafQiVHbuQUq8msN8Q2Z3vxsuHgkhTB7xiuCYt83rSFW
         tG4w==
X-Gm-Message-State: AJIora/5JgWj2ZCwzNBxqWQRZceclutlbxojvLAvjgTwfKE6ErhhLUMs
        t/N59bOEGKedC73zZN7WYDaPQm19tfaAviJGlv+x6s+ZUyAS3Qd8IszVsaAaArAtnLFLyyrOU/L
        7wKUWPUpyGfp9
X-Received: by 2002:a17:906:656:b0:6f4:ebc2:da81 with SMTP id t22-20020a170906065600b006f4ebc2da81mr3779634ejb.757.1655375839630;
        Thu, 16 Jun 2022 03:37:19 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tpI5iDF0Jq2lWg1MpnqxJiZyIFIu+vXgIZxIANhxAEWjLZGVU62uuALdDhDr4itQLGZ3jyDA==
X-Received: by 2002:a17:906:656:b0:6f4:ebc2:da81 with SMTP id t22-20020a170906065600b006f4ebc2da81mr3779619ejb.757.1655375839398;
        Thu, 16 Jun 2022 03:37:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id i25-20020a50fc19000000b0042bc54296a1sm1448107edr.91.2022.06.16.03.37.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 03:37:17 -0700 (PDT)
Message-ID: <69fac460-ff29-ca76-d9a8-d2529cf02fa2@redhat.com>
Date:   Thu, 16 Jun 2022 12:37:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu.linux@gmail.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20220531175450.295552-1-pbonzini@redhat.com>
 <20220531175450.295552-2-pbonzini@redhat.com> <YpZgU+vfjkRuHZZR@google.com>
 <ce2b4fed-3d9e-a179-a907-5b8e09511b7d@gmail.com>
 <YpeWPAHNhQQ/lRKF@google.com>
 <cbb9a8b5-f31f-dd3b-3278-01f12d935ebe@gmail.com>
 <YqoqZjH+yjYJTxmT@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] KVM: vmx, pmu: accept 0 for absent MSRs when
 host-initiated
In-Reply-To: <YqoqZjH+yjYJTxmT@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/15/22 20:52, Sean Christopherson wrote:
> On Thu, Jun 02, 2022, Like Xu wrote:
>> I actually agree and understand the situation of maintainers/reviewers.
>> No one wants to maintain flawed code, especially in this community
>> where the majority of previous contributors disappeared after the code
>> was merged in. The existing heavy maintenance burden is already visible.

I don't think this is true.  I think it's relatively rare for 
contributors to disappear.

>> Thus we may have a maintainer/reviewers scalability issue. Due to missing
>> trust, competence or mastery of rules, most of the patches sent to the list
>> have no one to point out their flaws.
> 
> Then write tests and run the ones that already exist.  Relying purely on reviewers
> to detect flaws does not and cannot scale.  I agree that we currently have a
> scalability issue, but I have different views on how to improve things.
> 
>> I have privately received many complaints about the indifference of our
>> community, which is distressing.

You're welcome to expand on these complaints.  But I suspect that a lot 
of these would come from people that have been told "review other 
people's work", "write tests" and/or "you submitted a broken patch" before.

"Let's try to accept" is basically what I did for PEBS and LBR, both of 
which I merged basically out of guilt after a little-more-than-cursory 
review.  It turns out that both of them were broken in ways that weren't 
subtle at all; and as a result, other work already queued to 5.19 had to 
be bumped to 5.20.

Honestly I should have complained and un-merged them right after seeing 
the msr.flat failure.  Or perhaps I should have just said "write tests 
and then I'll consider the series", but I "tried to accept" and we can 
already see it was a failure.

>> Obviously, "try to accept" is not a 100% commitment and it will fail with high
>> probability, but such a stance (along with standard clarifications and requirements)
>> from reviewers and maintainers will make the contributors more concerned,
>> attract potential volunteers, and focus the efforts of our nominated reviewers.

If it "fails with high probability", all that happened was a waste of 
time for everyone involved.  Including the submitter who has waited for 
weeks for a reviews only to be told "test X fails".

> I completely agree on needing better transparency for the lifecycle of patches
> going through the KVM tree.  First and foremost, there need to be formal, documented
> rules for the "official" kvm/* branches, e.g. everything in kvm/queue passes ABC
> tests, everything in kvm/next also passes XYZ tests.  That would also be a good
> place to document expectations, how things works, etc...

Agreed.  I think this is a more general problem with Linux development 
and I will propose this for maintainer summit.

But again, the relationship between contributors and maintainers should 
be of mutual benefit.  Rules help contributors, but contributors should 
themselves behave and not throw broken patches at maintainers.  And 
again, guess what the best way is to tell maintainers your patch is not 
broken?  Include a test.  It shows that you are paying attention.

> I fully realize that writing tests is not glamorous, and that some of KVM's tooling
> and infrastructure is lacking,

I wouldn't say lacking.  Sure it's complicated, but between selftests 
and kvm-unit-tests the tools *are* there.  selftests that allow you to 
test migration at an instruction boundary, for example, are not that 
hard to write and were very important for features such as nested state 
and AMX.  They're not perfect, but they go a long way towards giving 
confidence in the code; and it's easier to catch weird ioctl policies 
from reviewing comprehensive tests than from reviewing the actual KVM code.

We're not talking of something like SEV or TDX here, we're talking about 
very boring MSR emulation and only slightly less boring PMU passthrough.

Paolo

