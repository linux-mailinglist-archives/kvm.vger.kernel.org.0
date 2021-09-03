Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33333FFD30
	for <lists+kvm@lfdr.de>; Fri,  3 Sep 2021 11:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348822AbhICJea (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Sep 2021 05:34:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244272AbhICJe3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 3 Sep 2021 05:34:29 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDB8C061575
        for <kvm@vger.kernel.org>; Fri,  3 Sep 2021 02:33:30 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id t12so10431509lfg.9
        for <kvm@vger.kernel.org>; Fri, 03 Sep 2021 02:33:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=KjJsqN08kHUU9hALt64x49WnpC13zTqRn/N/C5PoLnI=;
        b=He+DQLj1WT4ORQvv8S8uq3EujtuxuAoiAyYvQc2ErhJjuczXlaIpOjYjhIVCMJATEz
         80xdA8ILn36S+tN8GvvvJPkhIOdmeFZRSsvpDwoWyLVQ1nnx6A7yzxrk8wu9pJ2l5Mvy
         rvzqVbcxFDJlCzlm4/re12fXzraSap97kpHA9QFoBK3JFctamfb6SXFSWybcO9HWnqIB
         mwNyO5WFnyIk+bAkYn19W24fOzfNEjs84BZR0ZO1yg8EjhYW2FiCWXMVXzyc2CdMXGqn
         CrhY+rDqCpKsDiac/AF1EHBVxLLsDmOfynzOYta5aRjiab/Obf1dDdcEsesypl//6QQA
         TIVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=KjJsqN08kHUU9hALt64x49WnpC13zTqRn/N/C5PoLnI=;
        b=N5oeTpx7yK8ytpzl3PzmcYOVC+GYqKslFoTkkyhOyUzVOBsEkRS/aaFNISwBFWMVoB
         RmV05I6Oh4p+uV78XWFEy8/eEwG+wti1jReOmxbXvmlpfR/2JuInelkiZTy0Zfcad/Ot
         wkpQGGODFspSIydqFg5GmZljipx5ldqMNT8EDQOyGCm5HFdhmAatugMXUBy4KgrXY1Tz
         7JG5r/WU+zgu8zJeBsccOe27BMuLHcKFpMxWeyo0cAPDDRXiBjh8i+yW0D4WOoggr2Cz
         8lkrTAMC2Qyw2N39rNNxdW+x6whbo1uQYK8BgNqZBUE8c6L4gHFBHAmiwYDCz09Mep/E
         o+Nw==
X-Gm-Message-State: AOAM532I6i03frviSa4HefHolvuW4e6vonwR5b84aGaw8k+Jc6Mn8i9k
        p2ItuuLoZ4Li/i5Fb/PmrHqxvr8UsgWEZHk/lm4=
X-Google-Smtp-Source: ABdhPJxifj1S2SHPbc+Df6lhpY7062s4mIlcoloXqCBFD+lRLnj9An5kt3UKL3ju1PFjr0wwJknX0A==
X-Received: by 2002:a19:c350:: with SMTP id t77mr2032018lff.33.1630661608232;
        Fri, 03 Sep 2021 02:33:28 -0700 (PDT)
Received: from zombie ([176.106.247.78])
        by smtp.gmail.com with ESMTPSA id z11sm524805ljn.114.2021.09.03.02.33.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 03 Sep 2021 02:33:27 -0700 (PDT)
Date:   Fri, 3 Sep 2021 12:33:25 +0300
From:   Valeriy Vdovin <valery.vdovin.s@gmail.com>
To:     Markus Armbruster <armbru@redhat.com>
Cc:     "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        Thomas Huth <thuth@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Valeriy Vdovin <valery.vdovin.s@gmail.com>
Subject: Re: [PATCH v12] qapi: introduce 'query-x86-cpuid' QMP command.
Message-ID: <20210903093325.GA26525@zombie>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8735qzpccg.fsf@dusky.pond.sub.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 24 Aug 2021 08:48:31 +0200 Marcus Armbruster <armbru@redhat.com> wrote:

>Eduardo Habkost <ehabkost@redhat.com> writes:
>
>> On Mon, Aug 23, 2021 at 9:35 AM Markus Armbruster <armbru@redhat.com> wrote:
>>>
>>> Eduardo Habkost <ehabkost@redhat.com> writes:
>>>
>>> > On Wed, Aug 11, 2021 at 9:44 AM Thomas Huth <thuth@redhat.com> wrote:
>>> >>
>>> >> On 11/08/2021 15.40, Eduardo Habkost wrote:
>>> >> > On Wed, Aug 11, 2021 at 2:10 AM Thomas Huth <thuth@redhat.com> wrote:
>>> >> >>
>>> >> >> On 10/08/2021 20.56, Eduardo Habkost wrote:
>>> >> >>> On Sat, Aug 07, 2021 at 04:22:42PM +0200, Markus Armbruster wrote:
>>> >> >>>> Is this intended to be a stable interface?  Interfaces intended just
>>> >> >>>> for
>>> >> >>>> debugging usually aren't.
>>> >> >>>
>>> >> >>> I don't think we need to make it a stable interface, but I won't
>>> >> >>> mind if we declare it stable.
>>> >> >>
>>> >> >> If we don't feel 100% certain yet, it's maybe better to introduce this
>>> >> >> with
>>> >> >> a "x-" prefix first, isn't it? I.e. "x-query-x86-cpuid" ... then it's
>>> >> >> clear
>>> >> >> that this is only experimental/debugging/not-stable yet. Just my 0.02
>>> >> >> €.
>>> >> >
>>> >> > That would be my expectation. Is this a documented policy?
>>> >> >
>>> >>
>>> >> According to docs/interop/qmp-spec.txt :
>>> >>
>>> >>   Any command or member name beginning with "x-" is deemed
>>> >>   experimental, and may be withdrawn or changed in an incompatible
>>> >>   manner in a future release.
>>> >
>>> > Thanks! I had looked at other QMP docs, but not qmp-spec.txt.
>>> >
>>> > In my reply above, please read "make it a stable interface" as
>>> > "declare it as supported by not using the 'x-' prefix".
>>> >
>>> > I don't think we have to make it stable, but I won't argue against it
>>> > if the current proposal is deemed acceptable by other maintainers.
>>> >
>>> > Personally, I'm still frustrated by the complexity of the current
>>> > proposal, but I don't want to block it just because of my frustration.
>>>
>>> Is this a case of "there must be a simpler way", or did you actually
>>> propose a simpler way?  I don't remember...
>>>
>>
>> I did propose a simpler way at
>> 20210810195053.6vsjadglrexf6jwy@habkost.net/">https://lore.kernel.org/qemu-devel/20210810195053.6vsjadglrexf6jwy@habkost.net/
>

Hi. Sorry for the late response to that.

Also sorry for possible technical email header errors in my reply mail, as I was switching the e-mail accounts that I use to
communicate with this maillist, so hope technically all went well.

>Valeriy, would the simpler way still work for you?
>
>If no, please explain why.  If you already did, just provide a pointer.
>
Yes, I remember your proposal of using just 5 lines of code. To be exact here are
those proposed lines:

>>    for start in (0, 0x40000000, 0x80000000, 0xC0000000):
>>        leaf = query_cpuid(qom_path, start)
>>        for eax in range(start, leaf.max_eax + 1):
>>            for ecx in range(0, leaf.get('max_ecx', 0) + 1):
>>                all_leaves.append(query_cpuid(qom_path, eax, ecx))


It looks cool and short, but this is only a pseudocode with not only variable declarations omitted, but
with some logic omitted as well. It does not become obvious until you start typing the code and then review it.
In fact the patch, to which you have done this suggestion back then already had the same concept at it's basis, but
it has grown quickly to somewhat more complex code than it's conceptual pseudo-brother above.

I'm sure that this current patch (which is the most recent in v15 email) is the most simple and shortest of possible.
This is iteration 3 patch, with first iteration being the one to which you've made that suggestion, but then we also tried one
more version by trying to do this via KVM ioctls, but it did not work quite smooth. So this last iteration at which we are currently
looking at is really the product of thought and is the simplest.

I suggest that we stick to it and start converging towards it's submission instead of going to another round of coding and discussion.
v15 - is the result of fine-tunes and rebases, that has already covered a lot of comments. Please let's review it to the end and give it a go.


>If yes, we need to choose between the complex solution we have and the
>simpler solution we still need to code up.  The latter is extra work,
>but having to carry more complex code is going to be extra work, too.

I agree to the idea that we MUST minimize support effort in priority to the commiting effort, but here I do not see direct dependency
between the two. This is already the simplest solution. All the code we have here is mostly
to service the QMP machinery, which has to be in any version of the patch. The payload code is minimal.

Thanks.
