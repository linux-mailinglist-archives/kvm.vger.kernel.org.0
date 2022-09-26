Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2361C5EAEA3
	for <lists+kvm@lfdr.de>; Mon, 26 Sep 2022 19:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiIZRvf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 26 Sep 2022 13:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbiIZRvO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 26 Sep 2022 13:51:14 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD2FD8559A
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 10:24:16 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-1274ec87ad5so10192544fac.0
        for <kvm@vger.kernel.org>; Mon, 26 Sep 2022 10:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=gUHzJrpgIX7MrAmevww+QKfw4oN3wJovrSvxBA4zTB8=;
        b=awzqwHGLXPv/1Hs3HJoBYiHnRA4FCKRY7v9kQNJINjnIMGTR8DgMHNaYAJJr4qCWM8
         yOkrLZTYwGp6gN1ZbdJV784UFV0kqHXnF2afnQLoB3E/vaLaZDo4ps4ev1ZYdn88iT6y
         D+8JlZai+E/MJwCErRTjR4aWsTLwQ+xvdrBqRYpC+gEStwDD61sFPqp71jnOEjbe6hIY
         +TKmrxN3B6RtaoTeJa5FU6/1Ib1mV2gAw44RlkJnpgQsy3V2+lA+V33NCaZ5CYTJooYZ
         mhF7InVOzqsQ6NLas8hMU3VncMq9+rdXP7XHz9r/HKkfNXlHblTao3rVw7T783+XHv04
         Dmrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=gUHzJrpgIX7MrAmevww+QKfw4oN3wJovrSvxBA4zTB8=;
        b=SHeDDBl0xnoHe8C3B0byrohF9ecmAsFm0ZL38T5dFn3L+8NmC/G53dal7QH9lhrcck
         GJeoCWfrLy/eEce8sqcM4Vasc4Vmm3ejD7ZA4vMtL9TfvNTWAE3Z9ZCkf07KqQwId3tp
         wPiK1JxIC84LetOTRP6PuXXsYeAmCJRhjcy6dt/Kg4P7RgZMThwh2qIGDRFfgl7v6FvP
         BPaDWaxxiEaPZSGGwypEuj8NqwCk2qIybi/79/ai729xN1JYAIDEbdPky12yjDMEH2p+
         Eh/RdpGn21T8kd0W6RbA1/z/YGhOqjW78deg0ONSWyCZ5Dv0OkwcD3Fpk83BA6Ro0HFw
         PgDg==
X-Gm-Message-State: ACrzQf0v4hOJtG6XLoKfi9C1L0GfLxmuzczW99jJaZF7UMIumDTdiuRg
        +DeqwI1WRUyZOElvQb1uqL6yrZDqsd9KLLGTHGyURw==
X-Google-Smtp-Source: AMsMyM7jgpNZsPksAb/fx5EgKsCdFrfD0cCQTEp2cbcSx+42Oj0N/AqurTAG01ed7OQKsIzHiP132QTyZionY9hi7UE=
X-Received: by 2002:a05:6870:580c:b0:12a:f136:a8f5 with SMTP id
 r12-20020a056870580c00b0012af136a8f5mr18512469oap.269.1664213055267; Mon, 26
 Sep 2022 10:24:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220921164521.2858932-1-xiaoyao.li@intel.com>
 <20220921164521.2858932-3-xiaoyao.li@intel.com> <175b518c-d202-644e-a3a7-67e877852548@linux.intel.com>
 <DS0PR11MB6373C84139621DC447D3F466DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <Yyxke/IO+AP4EWwT@hirez.programming.kicks-ass.net> <DS0PR11MB637346E9F224C5330CDEF3BFDC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <YyxsnAFYMLn2U9BT@hirez.programming.kicks-ass.net> <DS0PR11MB63730A85E00683AB7F6F3E26DC4E9@DS0PR11MB6373.namprd11.prod.outlook.com>
 <62d4bec1-a0c3-3b01-61bb-f284eede6378@linux.intel.com>
In-Reply-To: <62d4bec1-a0c3-3b01-61bb-f284eede6378@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 26 Sep 2022 10:24:03 -0700
Message-ID: <CALMp9eTG7EbRv_fnQpDMQ3YUjYANgu=6QwVj_ACgHnK-Mhk39Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/3] perf/x86/intel/pt: Introduce and export pt_get_curr_event()
To:     "Liang, Kan" <kan.liang@linux.intel.com>
Cc:     "Wang, Wei W" <wei.w.wang@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Li, Xiaoyao" <xiaoyao.li@intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 26, 2022 at 9:55 AM Liang, Kan <kan.liang@linux.intel.com> wrote:
>
>
>
> On 2022-09-22 10:42 a.m., Wang, Wei W wrote:
> > On Thursday, September 22, 2022 10:10 PM, Peter Zijlstra wrote:
> >> On Thu, Sep 22, 2022 at 01:59:53PM +0000, Wang, Wei W wrote:
> >>> On Thursday, September 22, 2022 9:35 PM, Peter Zijlstra
> >>>> On Thu, Sep 22, 2022 at 12:58:49PM +0000, Wang, Wei W wrote:
> >>>>
> >>>>> Add a function to expose the current running PT event to users.
> >>>>> One usage is in KVM, it needs to get and disable the running host
> >>>>> PT event before VMEnter to the guest and resumes the event after
> >> VMexit to host.
> >>>>
> >>>> You cannot just kill a host event like that. If there is a host
> >>>> event, the guest looses out.
> >>>
> >>> OK. The intention was to pause the event (that only profiles host
> >>> info) when switching to guest, and resume when switching back to host.
> >>
> >> If the even doesn't profile guest context, then yes. If it does profile guest
> >> context, you can't.
> >
> > Seems better to add this one:
>
> If the guest host mode is enabled, I think the PT driver should not
> allow the perf tool to create a host event with !exclude_guest.

While I agree that guest events should generally have priority over
host events, this is not consistent with the way "normal" PMU events
are handled.
