Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 726CF5B3E16
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 19:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiIIRle (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 13:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiIIRlc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 13:41:32 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF7F9675D
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 10:41:31 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id a8so3884630lff.13
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 10:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=D0EMFpeUgJV5zuXfhsOTaETOUMpCdLCa/JBj0lGG42I=;
        b=YsDccW85W6OY/LjM2CVzLSAdmF0qFGLsvBYUs+ESOsyD6CkCwvb1yWiiU5y78qgmhn
         SCCLDQy2imtA4eZ/KjbtYeNiceqK5HctKprxdZg/6jQYBWnfPfULBkVspT6eN3ZZwHNf
         tY5vQ+3ON7Z1CumYNXUBgHmF8upHURuqDFdaO22B43hv9mdHZD5eYBMU//jFdLYaAyiO
         Q3fgRL/sOL0sTvosnhiASwgo19137D+g7EtdeqtsUNarLQVn70d+vVfYXF5p71LAxKQi
         GpZcGb5CN48KZ2xglGnpE6MEc4ksrSpooWN1khC91h4bDI/4G71Dtr2SWtbZtt6EoQxK
         uFbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=D0EMFpeUgJV5zuXfhsOTaETOUMpCdLCa/JBj0lGG42I=;
        b=5BbGWfqRGtfbNl57QArs2qm2QI0fVxdiTrANQLEKjjAv6B+XsyNVbiX2TORsjd2LOq
         nJTFnJz3SorX4YgJ90zyZvgS1TFEb7p7kv0LtTtBxUK0SBJykEsZY9oJlPmicW14qhlB
         c7VVpS9gvoAwzKj/LWjionLE9Wbt2hZERQjBrUtaBuTKQd/HpP5XNqV1f2T2EgRkd6Av
         vGbonaEUZdIk3fnHY8gxSeKBQxhK+CDdoBScde5YeeojwIjIQJhbqGiJ4namPfNa+vWk
         HARLBsoBMyxySGOF1c0YIJCJ1Wlp1AMVJBn02gRLxxz6XibPzAIVmdoFUljvhHsOBW+u
         DhPw==
X-Gm-Message-State: ACgBeo03c2s5ZBXik1lDGc1gT9wl+Br2iWCd6NSrPFgVOg/9yCBD/YwQ
        07psb0y8Jufw3Sk5VOr6ScSyBsi9x+dvM4Q29GC5gA==
X-Google-Smtp-Source: AA6agR5afZm0elazc5hbHrRiZaqhxHZMfYQhoLtmAyo0mogiJ/dxAtIL0EeEuhj8YYPj3o8dmML9E8D7N206qiU1oX0=
X-Received: by 2002:a05:6512:110d:b0:494:7626:57a0 with SMTP id
 l13-20020a056512110d00b00494762657a0mr4575170lfg.302.1662745289295; Fri, 09
 Sep 2022 10:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220909124300.3409187-1-coltonlewis@google.com>
 <20220909124300.3409187-4-coltonlewis@google.com> <Yxt3MtaqpM52wQvB@google.com>
 <Yxt4aY20nXPKIrHQ@google.com>
In-Reply-To: <Yxt4aY20nXPKIrHQ@google.com>
From:   David Matlack <dmatlack@google.com>
Date:   Fri, 9 Sep 2022 10:41:01 -0700
Message-ID: <CALzav=dsZAFpA7pDHaMJw6BnZMKw5B1T9nWDsTHU-vBLhf-GNA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] KVM: selftests: randomize page access order
To:     Ricardo Koller <ricarkol@google.com>
Cc:     Colton Lewis <coltonlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Andrew Jones <andrew.jones@linux.dev>
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

On Fri, Sep 9, 2022 at 10:31 AM Ricardo Koller <ricarkol@google.com> wrote:
>
> On Fri, Sep 09, 2022 at 10:26:10AM -0700, David Matlack wrote:
> > On Fri, Sep 09, 2022 at 12:43:00PM +0000, Colton Lewis wrote:
> > > Create the ability to randomize page access order with the -a
> > > argument, including the possibility that the same pages may be hit
> > > multiple times during an iteration or not at all.
> > >
> > > Population sets random access to false.
> >
> > Please make sure to also explain the why in addition to the what.
> >
> > >
> > > Signed-off-by: Colton Lewis <coltonlewis@google.com>
> > > ---
> > >  tools/testing/selftests/kvm/dirty_log_perf_test.c | 11 +++++++++--
> > >  .../selftests/kvm/include/perf_test_util.h        |  2 ++
> > >  tools/testing/selftests/kvm/lib/perf_test_util.c  | 15 ++++++++++++++-
> > >  3 files changed, 25 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/tools/testing/selftests/kvm/dirty_log_perf_test.c b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > > index c2ad299b3760..3639d5f95033 100644
> > > --- a/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > > +++ b/tools/testing/selftests/kvm/dirty_log_perf_test.c
> > > @@ -127,6 +127,7 @@ struct test_params {
> > >     int slots;
> > >     uint32_t write_percent;
> > >     uint32_t random_seed;
> > > +   bool random_access;
> > >  };
> > >
> > >  static void toggle_dirty_logging(struct kvm_vm *vm, int slots, bool enable)
> > > @@ -248,6 +249,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> > >             vcpu_last_completed_iteration[vcpu_id] = -1;
> > >
> > >     perf_test_set_write_percent(vm, 100);
> > > +   perf_test_set_random_access(vm, false);
> > >     perf_test_start_vcpu_threads(nr_vcpus, vcpu_worker);
> > >
> > >     /* Allow the vCPUs to populate memory */
> > > @@ -270,6 +272,7 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> > >             ts_diff.tv_sec, ts_diff.tv_nsec);
> > >
> > >     perf_test_set_write_percent(vm, p->write_percent);
> > > +   perf_test_set_random_access(vm, p->random_access);
> > >
> > >     while (iteration < p->iterations) {
> > >             /*
> > > @@ -341,10 +344,11 @@ static void run_test(enum vm_guest_mode mode, void *arg)
> > >  static void help(char *name)
> > >  {
> > >     puts("");
> > > -   printf("usage: %s [-h] [-i iterations] [-p offset] [-g] "
> > > +   printf("usage: %s [-h] [-a] [-i iterations] [-p offset] [-g] "
> > >            "[-m mode] [-n] [-b vcpu bytes] [-v vcpus] [-o] [-r random seed ] [-s mem type]"
> > >            "[-x memslots] [-w percentage]\n", name);
> > >     puts("");
> > > +   printf(" -a: access memory randomly rather than in order.\n");
> > >     printf(" -i: specify iteration counts (default: %"PRIu64")\n",
> > >            TEST_HOST_LOOP_N);
> > >     printf(" -g: Do not enable KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2. This\n"
> > > @@ -396,8 +400,11 @@ int main(int argc, char *argv[])
> > >
> > >     guest_modes_append_default();
> > >
> > > -   while ((opt = getopt(argc, argv, "ghi:p:m:nb:v:or:s:x:w:")) != -1) {
> > > +   while ((opt = getopt(argc, argv, "aghi:p:m:nb:v:or:s:x:w:")) != -1) {
> > >             switch (opt) {
> > > +           case 'a':
> > > +                   p.random_access = true;
> > > +                   break;
> > >             case 'g':
> > >                     dirty_log_manual_caps = 0;
> > >                     break;
> > > diff --git a/tools/testing/selftests/kvm/include/perf_test_util.h b/tools/testing/selftests/kvm/include/perf_test_util.h
> > > index f93f2ea7c6a3..d9664a31e01c 100644
> > > --- a/tools/testing/selftests/kvm/include/perf_test_util.h
> > > +++ b/tools/testing/selftests/kvm/include/perf_test_util.h
> > > @@ -39,6 +39,7 @@ struct perf_test_args {
> > >
> > >     /* Run vCPUs in L2 instead of L1, if the architecture supports it. */
> > >     bool nested;
> > > +   bool random_access;
> > >
> > >     struct perf_test_vcpu_args vcpu_args[KVM_MAX_VCPUS];
> > >  };
> > > @@ -53,6 +54,7 @@ void perf_test_destroy_vm(struct kvm_vm *vm);
> > >
> > >  void perf_test_set_write_percent(struct kvm_vm *vm, uint32_t write_percent);
> > >  void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed);
> > > +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access);
> > >
> > >  void perf_test_start_vcpu_threads(int vcpus, void (*vcpu_fn)(struct perf_test_vcpu_args *));
> > >  void perf_test_join_vcpu_threads(int vcpus);
> > > diff --git a/tools/testing/selftests/kvm/lib/perf_test_util.c b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > index 12a3597be1f9..ce657fa92f05 100644
> > > --- a/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/perf_test_util.c
> > > @@ -46,6 +46,7 @@ void perf_test_guest_code(uint32_t vcpu_id)
> > >     struct perf_test_vcpu_args *vcpu_args = &pta->vcpu_args[vcpu_id];
> > >     uint64_t gva;
> > >     uint64_t pages;
> > > +   uint64_t addr;
> > >     int i;
> > >     uint32_t rand = pta->random_seed + vcpu_id;
> > >
> > > @@ -57,7 +58,13 @@ void perf_test_guest_code(uint32_t vcpu_id)
> > >
> > >     while (true) {
> > >             for (i = 0; i < pages; i++) {
> > > -                   uint64_t addr = gva + (i * pta->guest_page_size);
> > > +                   guest_random(&rand);
> > > +
> > > +                   if (pta->random_access)
> > > +                           addr = gva + ((rand % pages) * pta->guest_page_size);
> > > +                   else
> > > +                           addr = gva + (i * pta->guest_page_size);
> > > +
> > >                     guest_random(&rand);
> >
> > Is it on purpose use a separate random number for access offset and
> > read/write?
> >
>
> It's because of the following, from https://lore.kernel.org/kvm/YxDvVyFpMC9U3O25@google.com/
>
>         I think addr and write_percent need two different random numbers.
>         Otherwise, you will end up with a situation where all addresses where
>         (rnd_arr[i] % 100 < pta->write_percent) will get a write (always).
>         Something like this:
>
>                 012345678    <= address
>                 wwwrrrwww
>                 837561249    <= access order
>
>         I think the best way to fix this is to abstract the random number
>         reading into something like get_next_rand(), and use it twice per
>         iteration.

Makes sense. Depending on how many bits of randomness we need (e.g.
read/write only needs 7) we could still use one random number. But the
bit manipulation would probably more complex than just generating
another random number (which looks like a fairly cheap calculation).

Colton can you add a comment here to explain the subtlety?

>
> > >
> > >                     if (rand % 100 < pta->write_percent)
> > > @@ -233,6 +240,12 @@ void perf_test_set_random_seed(struct kvm_vm *vm, uint32_t random_seed)
> > >     sync_global_to_guest(vm, perf_test_args.random_seed);
> > >  }
> > >
> > > +void perf_test_set_random_access(struct kvm_vm *vm, bool random_access)
> > > +{
> > > +   perf_test_args.random_access = random_access;
> > > +   sync_global_to_guest(vm, perf_test_args.random_access);
> > > +}
> > > +
> > >  uint64_t __weak perf_test_nested_pages(int nr_vcpus)
> > >  {
> > >     return 0;
> > > --
> > > 2.37.2.789.g6183377224-goog
> > >
