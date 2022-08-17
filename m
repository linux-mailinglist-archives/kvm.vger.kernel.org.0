Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 990D15978E7
	for <lists+kvm@lfdr.de>; Wed, 17 Aug 2022 23:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241920AbiHQV3c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Aug 2022 17:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbiHQV3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Aug 2022 17:29:30 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1558573933
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:29:29 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id d71so12992396pgc.13
        for <kvm@vger.kernel.org>; Wed, 17 Aug 2022 14:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=cPU4dRqFcGLGHlWaSnt+2sRfRDdQ3EovXHQZSZPWVsk=;
        b=lmJuIYeaK5Jx8571q/wUIC5hX+p+4As4fmvOWOVmsq4MfgL1swQtC7EbMMp8btYH24
         hd8FgWsq0cIMnn+V7GdJ9cAlX7f6pF/j/vXZlwHENel3eAfdGRpp3kJHIOwLPittUMr1
         kanMMxPenC+jn/AHh9x+p7Tt3LTX3BmNVpIGgvi/Ys5NxV08CstJQ0CXWxj/cDdL2vRh
         hr9Wsc39eDv/9kKoKPIBh14CfCGNvTM90vslJHkKL/pPLOtmLfQ550DceM5KdEWMipJw
         sogyau/0k/e9jOu20IagaUltk58FUqGWd1Ba1Y/YWealYqqkCK3q1vGxR6Yh3sE5eV5o
         FLow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=cPU4dRqFcGLGHlWaSnt+2sRfRDdQ3EovXHQZSZPWVsk=;
        b=KTY4QF8ulYJV7upucN8wbHyEtEm//sjSbe5RLcNePlyernHUi33/P9MnOpjusWEX5/
         8Zco83JFGdUlUDA6OXk+ITwL0jJtPBzGX8gggZX7sDnujC+EOvtGVqXPmEinXIohTdDe
         ufwSdgNQxiFpW0QS41CV/jDdD6gv/f8W78UH/3YM21fHFPEy2NqbT/xcAqF85Ya1iqVs
         uT6xCHVmjHGWAGtQN93UYicNPUylo4y9bONd+t1Vi4dR2ua3eaFKn3MUqfxwNh3lWZkL
         Kv9os/lLKB/K/MY4GXyPpa07lOIB4DDt9nDiTMRIn1oYSlL+36iIUvvM3d9GGPwzzHs2
         2Xuw==
X-Gm-Message-State: ACgBeo0YRI9vOPte4Nfn5cyjd40TNcMNkT6l4AD3UHRahWEHIZcSYHRQ
        es3g1uBjcHS6XCPYCCGQ790EYQ==
X-Google-Smtp-Source: AA6agR7RQ30onTB55I37VwkITQAO/eEJNoS8djMIj8di7s7qwfh/vkq9GnOmlBJM6+d+MTpj1RjyPA==
X-Received: by 2002:a63:6b02:0:b0:422:7cf8:4bf with SMTP id g2-20020a636b02000000b004227cf804bfmr141648pgc.92.1660771768366;
        Wed, 17 Aug 2022 14:29:28 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id f196-20020a6238cd000000b00535c4dfc810sm39577pfa.82.2022.08.17.14.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 14:29:27 -0700 (PDT)
Date:   Wed, 17 Aug 2022 21:29:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     dmatlack@google.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Run dirty_log_perf_test on specific cpus
Message-ID: <Yv1ds4zVCt6hbxC4@google.com>
References: <20220817152956.4056410-1-vipinsh@google.com>
 <Yv0kRhSjSqz0i0lG@google.com>
 <CAHVum0fT7zJ0qj39xG7OnAObBqeBiz_kAp+chsh9nFytosf9Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHVum0fT7zJ0qj39xG7OnAObBqeBiz_kAp+chsh9nFytosf9Yg@mail.gmail.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 17, 2022, Vipin Sharma wrote:
> On Wed, Aug 17, 2022 at 10:25 AM Sean Christopherson <seanjc@google.com> wrote:
> >
> > > +static int parse_num(const char *num_str)
> > > +{
> > > +     int num;
> > > +     char *end_ptr;
> > > +
> > > +     errno = 0;
> > > +     num = (int)strtol(num_str, &end_ptr, 10);
> > > +     TEST_ASSERT(num_str != end_ptr && *end_ptr == '\0',
> > > +                 "Invalid number string.\n");
> > > +     TEST_ASSERT(errno == 0, "Conversion error: %d\n", errno);
> >
> > Is the paranoia truly necessary?  What happens if parse_cpu_list() simply uses
> > atoi() and is passed garbage?
> 
> On error atoi() returns 0, which is also a valid logical cpu number.

Lame.

> We need error checking here to make sure that the user really wants
> cpu 0 and it was not a mistake in typing.
> I was thinking of using parse_num API for other places as well instead
> of atoi() in dirty_log_perf_test.

Yes, definitely.  And maybe give it a name like atoi_paranoid()?

> Yeah, it was either my almost duplicate functions or have the one
> function do two things via if-else.  I am not happy with both
> approaches.
> 
> I think I will pass an integer array which this parsing function will
> fill up and return an int denoting how many elements were filled. The
> caller then can use the array as they wish, to copy it in
> vcpu_to_lcpu_map or cpuset.

Eh, I doubt that'll be a net improvement, e.g. the CPUSET case will then need to
re-loop, which seems silly.  If the exclusive cpuset vs. array is undesirable, we
could have the API require at least one instead of exactly one, i.e.

	TEST_ASSERT(cpuset || vcpu_map);

	...

                cpu = atoi(cpustr);
                TEST_ASSERT(cpu >= 0, "Invalid cpu number: %d\n", cpu);
                if (vcpu_map)
                        vcpu_map[i++] = cpu;
                if (cpuset)
                        CPU_SET(cpu, cpuset);
 
If we somehow end up with a third type of destination, then we can revisit this,
but that seems unlikely at this point.

> > > @@ -383,6 +450,26 @@ static void help(char *name)
> > >       backing_src_help("-s");
> > >       printf(" -x: Split the memory region into this number of memslots.\n"
> > >              "     (default: 1)\n");
> > > +     printf(" -c: Comma separated values of the logical CPUs which will run\n"
> > > +            "     the vCPUs. Number of values should be equal to the number\n"
> > > +            "     of vCPUs.\n\n"
> > > +            "     Example: ./dirty_log_perf_test -v 3 -c 22,43,1\n"
> > > +            "     This means that the vcpu 0 will run on the logical cpu 22,\n"
> > > +            "     vcpu 1 on the logical cpu 43 and vcpu 2 on the logical cpu 1.\n"
> > > +            "     (default: No cpu mapping)\n\n");
> > > +     printf(" -d: Comma separated values of the logical CPUs on which\n"
> > > +            "     dirty_log_perf_test will run. Without -c option, all of\n"
> > > +            "     the vcpus and main process will run on the cpus provided here.\n"
> > > +            "     This option also accepts a single cpu. (default: No cpu mapping)\n\n"
> > > +            "     Example 1: ./dirty_log_perf_test -v 3 -c 22,43,1 -d 101\n"
> > > +            "     Main application thread will run on logical cpu 101 and\n"
> > > +            "     vcpus will run on the logical cpus 22, 43 and 1\n\n"
> > > +            "     Example 2: ./dirty_log_perf_test -v 3 -d 101\n"
> > > +            "     Main application thread and vcpus will run on the logical\n"
> > > +            "     cpu 101\n\n"
> > > +            "     Example 3: ./dirty_log_perf_test -v 3 -d 101,23,53\n"
> > > +            "     Main application thread and vcpus will run on logical cpus\n"
> > > +            "     101, 23 and 53.\n");
> > >       puts("");
> > >       exit(0);
> > >  }
> >
> > > @@ -455,6 +550,13 @@ int main(int argc, char *argv[])
> > >               }
> > >       }
> > >
> >
> > I wonder if we should make -c and -d mutually exclusive.  Tweak -c to include the
> > application thread, i.e. TEST_ASSERT(nr_lcpus == nr_vcpus+1) and require 1:1 pinning
> > for all tasks.  E.g. allowing "-c ..., -d 0,1,22" seems unnecessary.
> >
> 
> One downside I can think of will be if we add some worker threads
> which are not vcpus then all of those threads will end up running on a
> single cpu unless we edit this parsing logic again.

But adding worker threads also requires a code change, i.e. it won't require a
separate commit/churn.  And if we get to the point where we want multiple workers,
it should be relatively straightforward to support pinning an arbitrary number of
workers, e.g.

	enum memtest_worker_type {
		MAIN_WORKER,
		MINION_1,
		MINION_2,
		NR_MEMTEST_WORKERS,
	}


	TEST_ASSERT(nr_lcpus == nr_vcpus + NR_MEMTEST_WORKERS);

void spawn_worker(enum memtest_worker_type type, <function pointer>)
{
	cpu_set_t cpuset;

	CPU_ZERO(&cpuset);
	CPU_SET(task_map[nr_vcpus + type], &cpuset);

	<set affinity and spawn>
}

> Current implementation gives vcpus special treatment via -c and for
> the whole application via -d. This gives good separation of concerns
> via flags.

But they aren't separated, e.g. using -d without -c means vCPUs are thrown into
the same pool as worker threads.  And if we ever do add more workers, -d doesn't
allow the user to pin workers 1:1 with logical CPUs.

Actually, if -c is extended to pin workers, then adding -d is unnecessary.  If the
user wants to affine tasks to CPUs but not pin 1:1, it can do that with e.g. taskset.
What the user can't do is pin 1:1.

If we don't want to _require_ the caller to pin the main worker, then we could do

	TEST_ASSERT(nr_lcpus >= nr_vcpus &&
		    nr_lcpus <= nr_vcpus + NR_MEMTEST_WORKERS);

to _require_ pinning all vCPUs, and allow but not require pinning non-vCPU tasks.
