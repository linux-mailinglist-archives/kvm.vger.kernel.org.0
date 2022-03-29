Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 896144EB6E9
	for <lists+kvm@lfdr.de>; Wed, 30 Mar 2022 01:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240806AbiC2Xnf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Mar 2022 19:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234637AbiC2Xne (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Mar 2022 19:43:34 -0400
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA96199510;
        Tue, 29 Mar 2022 16:41:51 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-2d07ae0b1c4so200213677b3.11;
        Tue, 29 Mar 2022 16:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9mUNJ7n65nz704WphwMWeIj2CegCvez8/+xvi3QOa3k=;
        b=BB4Nen7haFRBVOuM/aqc67KY0vhx0MIiXVWiPikq9xJ807mqTGmKb5EPnSYP05oFhK
         G/Fuw8dRmgo5owXEAk6Xt8+W3NhlwVy6i7ly0qdUYLYjcbiiJx++U1YqsAdRD11urcF9
         1TYE0vdjyVAYNmUNNe1UE1u/7KTBIaSIYKhnXhX1ay82/eYtGtZIg/1BGFVb1P6f0V3c
         vroj5n215LLR9JK/JyrAHc/KUHVb6ctc/qpnU62tJapLSMvkcY2rASHtE9MuhP7gHadb
         CYEwd2sLEgummuK5QBxCX4BeWZWnYBrWaWw+3KlKiuRfGcraExpQ7R0IEne7+9cQT2hD
         LxQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9mUNJ7n65nz704WphwMWeIj2CegCvez8/+xvi3QOa3k=;
        b=uMmhiWmRHTCqn2WEPSEUzNGV95TOWEwzrgZXraHoaEOhMV50zeJfstmmcgXfzJoE0H
         1vj1wA1KAotlmzHyVie/C6fVmlgAGHhjLZLckURsMsffgkyBLXiCIV03aOml4y9KMxg6
         oYQmOL8NvtvyY45odOf9DcohvxkwxlAJub7/xueObJdhaWM/kmEulebUhhNzmfjL8Y3+
         TpQgdHMW5seVmfCKAsfvt109873FrjqmxZJWV5Lgq9ES0lZOqpKo8qD6pO92Fjeini0z
         zogrh7Bc8rNOQbuuGOkEh9771kysVQFE6CvD9wpO6hg3DwsLyAll8RPP75UQj5/UroLy
         4kPA==
X-Gm-Message-State: AOAM530J07YC3cNLhXkMXCQQW5v1dTHZkm9gknlmZIuH5M5Im9SvRndJ
        PTNlCAVUq2b6IXnSs3TQlASw3zghSv4empE1fsY=
X-Google-Smtp-Source: ABdhPJx7GvXiwPFPHDcBgmaJ7B0Jckcd1zMAEMIktiASSKv9VprfTodGChKK60fOANPjxjUXORmptkmKpwwnihUhy5c=
X-Received: by 2002:a81:9842:0:b0:2e5:9e00:288 with SMTP id
 p63-20020a819842000000b002e59e000288mr34551786ywg.369.1648597310252; Tue, 29
 Mar 2022 16:41:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220329153604.507475-1-jiangshanlai@gmail.com> <d8f5f25d-e544-dea7-2474-6d98fea39cbc@redhat.com>
In-Reply-To: <d8f5f25d-e544-dea7-2474-6d98fea39cbc@redhat.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Wed, 30 Mar 2022 07:41:39 +0800
Message-ID: <CAJhGHyDpo7RQGvnrpGtRPAp3ribXk515tGZ9D-rfaBkq=gKMuA@mail.gmail.com>
Subject: Re: [RFC PATCH V2 0/4] KVM: X86: Add and use shadow page with level
 expanded or acting as pae_root
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 4:31 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 3/29/22 17:36, Lai Jiangshan wrote:
> > From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
> >
> > (Request For Help for testing on AMD machine with 32 bit L1 hypervisor,
> > see information below)
> >
> > KVM handles root pages specially for these cases:
> >
> > direct mmu (nonpaping for 32 bit guest):
> >       gCR0_PG=0
> > shadow mmu (shadow paping for 32 bit guest):
> >       gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0
> >       gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1
> > direct mmu (NPT for 32bit host):
> >       hEFER_LMA=0
> > shadow nested NPT (for 32bit L1 hypervisor):
> >       gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0,hEFER_LMA=0
> >       gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1,hEFER_LMA=0
> >       gCR0_PG=1,gEFER_LMA=0,gCR4_PSE={0|1},hEFER_LMA=1,hCR4_LA57={0|1}
> > Shadow nested NPT for 64bit L1 hypervisor:
> >       gEFER_LMA=1,gCR4_LA57=0,hEFER_LMA=1,hCR4_LA57=1
> >
> > They are either using special roots or matched the condition
> > ((mmu->shadow_root_level > mmu->root_level) && !mm->direct_map)
> > (refered as level expansion) or both.
> >
> > All the cases are using special roots except the last one.
> > Many cases are doing level expansion including the last one.
>
> Hi Jiangshan,
>
> so the main difference between direct and passthrough shadow pages is
> that passthrough pages can have indirect children.  A direct page maps
> the page at sp->gfn, while a passthrough page maps the page _table_ at
> sp->gfn.  Is this correct?
>
> If so, I think there is a difference between a passthrough page that
> maps a level-2 page from level-4, and a passthrough page that maps a
> level-3 page from level-4.  If that is true, a single bit in the role
> is not enough.

Ahhhh, you are correct.

>
> One way to handle this could be to have a single field "mapping_level"
> that subsumes both "direct" and "passthrough".  direct==1
> would correspond to "mapping_level == 0"; direct==0 && passthrough==0
> would be "mapping_level == level"; anything in the middle would be a
> passthrough page in your series.
>
> What do you think?
>
> Thanks,
>
> Paolo
>
