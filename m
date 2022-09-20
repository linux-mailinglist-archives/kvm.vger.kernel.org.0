Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27DC05BEA1A
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 17:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiITPYr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 11:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230497AbiITPYo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 11:24:44 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF881CFE6
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 08:24:40 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id g3so4807270wrq.13
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 08:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=NX5TNH/zbqZcMtwAB5g2uPlO4Uj8FQMyvXQDcVu6udg=;
        b=W08MhDRBjpq/qx0vtGHJVq4OMDG0A4inaNTDk+JvyiqNnJesKbDGJPZKYRKMSZpbM8
         ejdBuKflrZeMFlE3rnrsH9BV0JPGNhzpugiMdKZxAEVRAaVy+yGlQuwzd/9+CHlyfzfZ
         glYq9BmlOU9P+mAx8tgcL86jDXR2Vc2kL/vkEbKAr1oaQXdlewZtJ1S1ecz1lOyexbsQ
         NZ4+fIW7JSuKoGyqmGGEnxuHlxEQDGRtlAS9Dc8jby4bNoTmKfc4SLail99ORcvWlYGB
         tmi9GKd5215fMUeyh6NQ3NPyXo3569ab7OkF12Mu8/opGGpUEvdAN/ClmkeRNftIEp1n
         kq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=NX5TNH/zbqZcMtwAB5g2uPlO4Uj8FQMyvXQDcVu6udg=;
        b=ku5EpMBOZ6kDoODPEOKeQIHS16ARAleD2LdOOxb2rU/hiECFLNBhzngJazlXZJTinm
         QeRLp/D478A8ai93qyzdu0h6AQxLPBdCcdKcpM1kLFiOk0eXzvXyICLB8XgtiwVCBvYM
         NTyaVf96WuD7lr+wFLDq3mMnbylz66ifKfW6ZuBimL5bGvq2T6fhm5bO0ds13rNR7toN
         jVgUyUOwr1saW/iZi5Qy7dk5ZuFQjYE9MvI0QnYjlItBP2H8anZFYWqj480r9EnORMY2
         Gea+3jm3y/riHJ8YjXtPu4dGCgwIZuAuNkNApYhlDVTgSzXwdZClBb8gSY/Agyv6x0h3
         bN3g==
X-Gm-Message-State: ACrzQf2pBFzQaDNA/F5EzWRKcIHuaPCnbaCsyh1BzXhUQIMto6R9tEz7
        rdwHH4RLSj9ztNEfibkOg8gTVZglmFCV6DZA+3woD1HPL84=
X-Google-Smtp-Source: AMsMyM5pmKj8zuMDwpjphoJZf+C0nxsEm/k3iBoWUXiDXGRhIODcPguWnQZIMjxy9QOy6pwSi0gBuuEUAz2K73B+V4A=
X-Received: by 2002:a05:6000:984:b0:228:60fb:e364 with SMTP id
 by4-20020a056000098400b0022860fbe364mr14238120wrb.66.1663687478878; Tue, 20
 Sep 2022 08:24:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220831162124.947028-1-aaronlewis@google.com>
 <20220831162124.947028-8-aaronlewis@google.com> <CALMp9eR0mC3VTFkUv1USHcG_9gANG3OzyzcXPo4EsXwtv4vN8Q@mail.gmail.com>
In-Reply-To: <CALMp9eR0mC3VTFkUv1USHcG_9gANG3OzyzcXPo4EsXwtv4vN8Q@mail.gmail.com>
From:   Aaron Lewis <aaronlewis@google.com>
Date:   Tue, 20 Sep 2022 15:24:27 +0000
Message-ID: <CAAAPnDGho40t6K5MTjZtQ4==bpdcsnDEVv=e3Y4fLuhQ6NMDKQ@mail.gmail.com>
Subject: Re: [PATCH v4 7/7] selftests: kvm/x86: Test masked events
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, seanjc@google.com
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

>
>
> > +static bool supports_event_mem_inst_retired(void)
> > +{
> > +       uint32_t eax, ebx, ecx, edx;
> > +
> > +       cpuid(1, &eax, &ebx, &ecx, &edx);
> > +       assert(x86_family(eax) == 0x6);
>
> This seems aggressive. Even if Linux no longer runs on Pentium 4, what
> about Xeon Phi?
>

I'll make it a branch.

> > @@ -505,6 +826,13 @@ int main(int argc, char *argv[])
> >         test_not_member_deny_list(vcpu);
> >         test_not_member_allow_list(vcpu);
> >
> > +       if (use_intel_pmu() && supports_event_mem_inst_retired())
>
> Do we need to verify that 3 or more general purpose counters are available?

I'll add a check for that.

>
> > +               vcpu2 = vm_vcpu_add(vm, 2, intel_masked_events_guest_code);
> > +       else if (use_amd_pmu())
>
> Do we need to verify that the CPU is Zen[123]?

use_amd_pmu() does that already.
