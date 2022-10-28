Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E84611E51
	for <lists+kvm@lfdr.de>; Sat, 29 Oct 2022 01:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiJ1XwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Oct 2022 19:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJ1XwM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Oct 2022 19:52:12 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30AA119ABF5
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 16:52:12 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-3701a0681daso26051407b3.4
        for <kvm@vger.kernel.org>; Fri, 28 Oct 2022 16:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5owRIc+7dZODShErEylLWDV1m+rY9HGm5aDLxKS8If0=;
        b=NrVwMH9t2RxRlZjpNx7SjVXKRf07n3ntGBUlWDvUgVJLTJfknYzIG3mquH/SCbBw6S
         R1SlZ2rypBZK/2h8O6nmx11qDKMYyMhCvCds8mnvS+vPVaiqx5HoxhBLApuV4pG1TGMn
         w//22Xns1FTt6uaK6+oP25RZ7u6Pg2t2xOHYu16jEYAcmNIJoZseQy+nqzjldrIddCFC
         elKpbkkEv0mVEPGfK2aY2cBojjsKDfqN3EHi1H1EOLIQrN6Btome9EDQJXDt8SvC4VX3
         xqKEjR9Rs6Ay0Ohh6ME2pAci8t4tJfWF1gxQ8vVj4OTVLDc8xSf4Wk9LncmsxE8S3/Uz
         wM0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5owRIc+7dZODShErEylLWDV1m+rY9HGm5aDLxKS8If0=;
        b=oDnUYKl01BbpM77UW6qnQ1SKIofD/PjKeKcOnGj+kfH6cTKLOApT3SmZ+E5DXV6d+u
         bvPpwLnd2Xf7vhwTlp7iiSj4D95mJISq+rTO+BWr96KvZa4u0u311jZBPBALaC2x1pBo
         vOQdYQL0uCd3SMxhPGp9MgHimTgLEdiBynHBrPM1KbH/qIX6zPD4R5ZOyE+FStIzvWy1
         nY1iWQbl8WYbOlV0q048OH83jNkZffURyIuMl29/eygpE+7k7eXdxNvireYGR8TypMMY
         vwP/jFEvT7HZEnpdMfCjzB6jSV1iKBDwR8K8kvc49jNpGxwQQL4c+oW1ewanrACgLnt1
         7LEA==
X-Gm-Message-State: ACrzQf3NMMTCQJtkF7RADogn/V7KgsjVOP83BPrNwmOl4OyM8rr6JSXr
        3aAgkiCSZsforrDFiL1zsdn4BbRx1GnqwWxHBHYzpg==
X-Google-Smtp-Source: AMsMyM72POnyaBphjzrBY2cKl0syARpNCdRz1mzbbVsXKAa6gOEqtLrOULdn0fyygA1hvh5T7LuCTrIeXceD95QUq4M=
X-Received: by 2002:a81:16c2:0:b0:36f:f574:4a49 with SMTP id
 185-20020a8116c2000000b0036ff5744a49mr1845790yww.111.1667001131370; Fri, 28
 Oct 2022 16:52:11 -0700 (PDT)
MIME-Version: 1.0
References: <20221018214612.3445074-1-dmatlack@google.com> <20221018214612.3445074-8-dmatlack@google.com>
 <Y1si3zrLnC0IIwG1@google.com>
In-Reply-To: <Y1si3zrLnC0IIwG1@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 28 Oct 2022 16:51:45 -0700
Message-ID: <CALzav=cuLhif=EMURyMuREKjENK-mxDvBry_x=fvGrnkgG8XqQ@mail.gmail.com>
Subject: Re: [PATCH v2 7/8] KVM: selftests: Expect #PF(RSVD) when TDP is disabled
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>,
        Colton Lewis <coltonlewis@google.com>,
        Aaron Lewis <aaronlewis@google.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022 at 5:31 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Oct 18, 2022, David Matlack wrote:
> > @@ -50,6 +73,9 @@ int main(int argc, char *argv[])
> >       TEST_REQUIRE(kvm_has_cap(KVM_CAP_SMALLER_MAXPHYADDR));
> >
> >       vm = vm_create_with_one_vcpu(&vcpu, guest_code);
> > +     vm_init_descriptor_tables(vm);
> > +     vcpu_init_descriptor_tables(vcpu);
> > +     vm_install_exception_handler(vm, PF_VECTOR, guest_page_fault_handler);
>
> Instead of installing an exception handler,
>
>         u8 vector = kvm_asm_safe(KVM_ASM_SAFE(FLDS_MEM_EAX),
>                                  "a"(MEM_REGION_GVA));
>
> then the guest/test can provide more precise information if a #PF doesn't occur.

I gave this a shot and realized this would prevent checking that it is
a reserved #PF, since kvm_asm_safe() only returns the vector.

It's probably more important to have more precise testing rather than
more precise failure reporting. But what did you have in mind
specifically? Maybe there's another way.
