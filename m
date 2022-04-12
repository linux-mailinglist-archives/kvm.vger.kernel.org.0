Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2069B4FE945
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 22:06:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbiDLUID (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 16:08:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbiDLUHR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 16:07:17 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 525206E547
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:58:56 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-2db2add4516so151797b3.1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B3ga8T1BVksBW86oxX13MqeD+x6oU8FVXwvSUDvYDBQ=;
        b=YPr1RdLIP7bTY6XUKBQSySM4Rv/0t7HNFwJzpzY4zyX9xXfTGL1jXy7x93FGjNiwR5
         TLebuFdaNxpShRXOM7VNMp0APmCYnSF7SriAZnar0wOXEre6710qyN3hMQx4AbZ5Dspe
         Riq9kbC0YqhousbW8rfOGRaZdRnDdGE6gZ6Z445PF/mgUV2ATvxIIKpCeix/KfPSTC7Y
         ivbA1riSDyxg34JzZr80KfxYGh7cJ8rNSI0WBc37zB1ux6z4ZJoGdE4jlFn7AfjX+CMI
         MlCvZdci8RU84YIexrG2WYo6pEW5E2K2JcCnFjHczzWt+jqh8wV/5VuNdHyfFKM4OzTD
         iNSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B3ga8T1BVksBW86oxX13MqeD+x6oU8FVXwvSUDvYDBQ=;
        b=qopDi49lBKiOCFsmvBPWb9qyLiyPS73nk+1qvp/xrWzUQP3J2sxt4tHZgMAOwngdvK
         P49y5PH0S6DWGdPNSm+nv9cpwJWf76CZRHL5ANjq7WIH78/V/vIG5FH+r90mFXb20cM3
         88iJI+P1STURaHE1ziq1aY9ipaURdS7ySDpOptg2kY5E+iKhZZzEVkqPHo0Sdcr22pbG
         I01eyasZC4Bwep5UwrEIoGN0ta7iSb5PyWT3ezocaZ6lga4VV+1pmBodPC9SraDH+vnM
         UDZmWk1UiG8E6noGhXEDBnjZegDfMWfFmeLcaAtgyLwqxGevb0RoLhsvq1cFFpHJeuWx
         1/yA==
X-Gm-Message-State: AOAM531cRzj9eg/SN0OfZ7KzHsvr8HSNt6TpUlEkf+diCmRLbnbAUenz
        IOTaRwWjSWRUf5646IymWbplvxaXY1lPbkQdhgiNKQ==
X-Google-Smtp-Source: ABdhPJyuNwur1w0y6gzKizHttMJRIhppAR4eRe3SNp/Vg07m8lNuEdrDzm0kp0R+FbFslXdomdr7xSBaaNhRdE63E04=
X-Received: by 2002:a81:a1c1:0:b0:2eb:fb9c:c4e5 with SMTP id
 y184-20020a81a1c1000000b002ebfb9cc4e5mr13204144ywg.156.1649793535229; Tue, 12
 Apr 2022 12:58:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220411211015.3091615-1-bgardon@google.com> <20220411211015.3091615-5-bgardon@google.com>
 <CALzav=fCnRX=JZ-knxf9_Aq_A_JOVjTq34ACe5JOmVr5Ms=vVw@mail.gmail.com>
In-Reply-To: <CALzav=fCnRX=JZ-knxf9_Aq_A_JOVjTq34ACe5JOmVr5Ms=vVw@mail.gmail.com>
From:   Ben Gardon <bgardon@google.com>
Date:   Tue, 12 Apr 2022 12:58:44 -0700
Message-ID: <CANgfPd8EVe6wmKh02=chp3uO38CyUA0mG3hHU8MOQJZa1vXKiQ@mail.gmail.com>
Subject: Re: [PATCH v4 04/10] KVM: selftests: Read binary stat data in lib
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Shier <pshier@google.com>,
        David Dunn <daviddunn@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 11, 2022 at 3:15 PM David Matlack <dmatlack@google.com> wrote:
>
> On Mon, Apr 11, 2022 at 2:10 PM Ben Gardon <bgardon@google.com> wrote:
> >
> > Move the code to read the binary stats data to the KVM selftests
> > library. It will be re-used by other tests to check KVM behavior.
> >
> > No functional change intended.
> >
> > Signed-off-by: Ben Gardon <bgardon@google.com>
> > ---
> >  .../selftests/kvm/include/kvm_util_base.h     |  3 +++
> >  .../selftests/kvm/kvm_binary_stats_test.c     | 20 +++++-------------
> >  tools/testing/selftests/kvm/lib/kvm_util.c    | 21 +++++++++++++++++++
> >  3 files changed, 29 insertions(+), 15 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/include/kvm_util_base.h b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > index c5f34551ff76..b2684cfc2cb1 100644
> > --- a/tools/testing/selftests/kvm/include/kvm_util_base.h
> > +++ b/tools/testing/selftests/kvm/include/kvm_util_base.h
> > @@ -405,6 +405,9 @@ struct kvm_stats_desc *alloc_vm_stats_desc(int stats_fd,
> >                                           struct kvm_stats_header *header);
> >  void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
> >                         struct kvm_stats_desc *stats_desc);
> > +int read_stat_data(int stats_fd, struct kvm_stats_header *header,
> > +                  struct kvm_stats_desc *desc, uint64_t *data,
> > +                  ssize_t max_elements);
> >
> >  uint32_t guest_get_vcpuid(void);
> >
> > diff --git a/tools/testing/selftests/kvm/kvm_binary_stats_test.c b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > index e4795bad7db6..97b180249ba0 100644
> > --- a/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > +++ b/tools/testing/selftests/kvm/kvm_binary_stats_test.c
> > @@ -20,6 +20,8 @@
> >  #include "asm/kvm.h"
> >  #include "linux/kvm.h"
> >
> > +#define STAT_MAX_ELEMENTS 1000
> > +
> >  static void stats_test(int stats_fd)
> >  {
> >         ssize_t ret;
> > @@ -29,7 +31,7 @@ static void stats_test(int stats_fd)
> >         struct kvm_stats_header header;
> >         char *id;
> >         struct kvm_stats_desc *stats_desc;
> > -       u64 *stats_data;
> > +       u64 stats_data[STAT_MAX_ELEMENTS];
>
> What is the benefit of changing stats_data to a stack allocation with
> a fixed limit?

There isn't really a benefit. Will remove.

>
> >         struct kvm_stats_desc *pdesc;
> >
> >         /* Read kvm stats header */
> > @@ -130,25 +132,13 @@ static void stats_test(int stats_fd)
> >                         pdesc->offset, pdesc->name);
> >         }
> >
> > -       /* Allocate memory for stats data */
> > -       stats_data = malloc(size_data);
> > -       TEST_ASSERT(stats_data, "Allocate memory for stats data");
> > -       /* Read kvm stats data as a bulk */
> > -       ret = pread(stats_fd, stats_data, size_data, header.data_offset);
> > -       TEST_ASSERT(ret == size_data, "Read KVM stats data");
> >         /* Read kvm stats data one by one */
> > -       size_data = 0;
> >         for (i = 0; i < header.num_desc; ++i) {
> >                 pdesc = (void *)stats_desc + i * size_desc;
> > -               ret = pread(stats_fd, stats_data,
> > -                               pdesc->size * sizeof(*stats_data),
> > -                               header.data_offset + size_data);
> > -               TEST_ASSERT(ret == pdesc->size * sizeof(*stats_data),
> > -                               "Read data of KVM stats: %s", pdesc->name);
> > -               size_data += pdesc->size * sizeof(*stats_data);
> > +               read_stat_data(stats_fd, &header, pdesc, stats_data,
> > +                              ARRAY_SIZE(stats_data));
> >         }
> >
> > -       free(stats_data);
> >         free(stats_desc);
> >         free(id);
> >  }
> > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > index e3ae26fbef03..64e2085f1129 100644
> > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > @@ -2593,3 +2593,24 @@ void read_vm_stats_desc(int stats_fd, struct kvm_stats_header *header,
> >         TEST_ASSERT(ret == stats_descs_size(header),
> >                     "Read KVM stats descriptors");
> >  }
> > +
> > +int read_stat_data(int stats_fd, struct kvm_stats_header *header,
>
> I would like to keep up the practice of adding docstrings to functions
> in kvm_util. Can you add docstring comments for this function and the
> other kvm_util functions introduced by this series?

Will do.

>
> > +                  struct kvm_stats_desc *desc, uint64_t *data,
> > +                  ssize_t max_elements)
> > +{
> > +       ssize_t ret;
> > +
> > +       TEST_ASSERT(desc->size <= max_elements,
> > +                   "Max data elements should be at least as large as stat data");
>
> What is the reason for this assertion? Callers are required to read
> all the data elements of a given stat?

Yeah, that was the idea, but it doesn't seem very useful. I'll remove it.

>
> > +
> > +       ret = pread(stats_fd, data, desc->size * sizeof(*data),
> > +                   header->data_offset + desc->offset);
> > +
> > +       /* ret from pread is in bytes. */
> > +       ret = ret / sizeof(*data);
> > +
> > +       TEST_ASSERT(ret == desc->size,
> > +                   "Read data of KVM stats: %s", desc->name);
>
> Won't this assertion fail when called from kvm_binary_stats_test.c?
> kvm_binary_stats_test.c looks like it reads all the stat data at once,
> which means ret will be the total number of stat data points, and
> desc->size will be the number of stat data points in the first stat.

Hmmm it shouldn't. I think we're just reading one stat at at time.

>
> > +
> > +       return ret;
> > +}
> > --
> > 2.35.1.1178.g4f1659d476-goog
> >
