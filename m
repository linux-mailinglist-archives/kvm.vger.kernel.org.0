Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E27E5BEDCC
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 21:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbiITTaw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 15:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbiITTat (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 15:30:49 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEBB660687
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 12:30:48 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 78so3655064pgb.13
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 12:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=WpQqspmgFGfmC+YAd/CrSCQSkyr81aAwd2bugZMTk7k=;
        b=LQ353DWmIk4mA0IYnycIFirDPNZUsCUt6FdNvoMEL+E01KbJ8eylfEpzjRjta8Qz15
         flP1tmPZOLqUO1fjoV42BWuQ7BJd09nfOUtzQueSgORJ2PhCldArxVWna0KVYLdGi/2A
         r4TnFYo3AUJ9KsSQi+ra2qEgAhwG7xCLsxsJUOuf7lhWDt8DqWINfGVCS/zLFz+Z8zP1
         Ss4NxcDijIutKrisC8TL3rtX2Tcy1q5JRyJd76qe1JCaD2Gpt2wm7ZGNrYZn0/qN2P2q
         D1eInRdqF1IAkYoqvz41Rx1m/0ZLZAjcMkEANqnpx7+2EFloi5HPHFceireV8qZR0FjL
         odTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=WpQqspmgFGfmC+YAd/CrSCQSkyr81aAwd2bugZMTk7k=;
        b=zBiDnWJNE3bVev8jaXt6a3M+1d1VnbewdazEzmp+Eg/C3vrBLpyYX5/o1AHKvYmBc7
         Cp5jaqPd3IbncUXPjSd+P8MlfHQxrKz8FQvdhGxi+lGxXKts8F/tqnuJv3Ij6w9ysJWs
         JVxbBw/3ciDbtnVfJ2qP5+jBEwvDIeolQJtR8ogQsVDbmIaDLqbJM/AWleikW7TETpDy
         qxuKBKXDpySQQGT+4UtRI6Qn3GxVK2Y7VsSXSPr388PuQAZ66NcJrSgGqDRSQbG8v2Sb
         zIcRHnj4YFA7zwA8js7SoRjMOf56F8hk9bO3fINyKR4VxZx1xAMftdNNFDpPkPd0kqxr
         y5RQ==
X-Gm-Message-State: ACrzQf1pQCixtmO5d5rtMRciKqCMJdSlV/UAUdED82mCvEZhQgNaenWz
        Nj7Wd6ee95hJWI3uAeiD1xjymg==
X-Google-Smtp-Source: AMsMyM63z0rbNdkRyoeb01YO4su8NB7CImnY+2I1yNAC3M2GA2LUTE7Bsgc05MbGkxjfdI4QliP/SA==
X-Received: by 2002:aa7:9605:0:b0:53e:8062:43fc with SMTP id q5-20020aa79605000000b0053e806243fcmr25334064pfg.39.1663702248225;
        Tue, 20 Sep 2022 12:30:48 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x14-20020a170902ec8e00b001780e4e1a0fsm278469plg.125.2022.09.20.12.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 12:30:47 -0700 (PDT)
Date:   Tue, 20 Sep 2022 19:30:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     cgel.zte@gmail.com, pbonzini@redhat.com, shuah@kernel.org,
        dmatlack@google.com, peterx@redhat.com, oupton@google.com,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] KVM: selftests: remove redundant variable
 tsc_val
Message-ID: <YyoU5E2eKD9dpjzH@google.com>
References: <20220831143150.304406-1-cui.jinpeng2@zte.com.cn>
 <CALMp9eT1yz0q1xn2nPtKBbnx_ixX4ivFk=qOayz70k_hxooaoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eT1yz0q1xn2nPtKBbnx_ixX4ivFk=qOayz70k_hxooaoQ@mail.gmail.com>
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

On Wed, Aug 31, 2022, Jim Mattson wrote:
> On Wed, Aug 31, 2022 at 7:31 AM <cgel.zte@gmail.com> wrote:
> > diff --git a/tools/testing/selftests/kvm/include/x86_64/processor.h b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > index 0cbc71b7af50..75920678f34d 100644
> > --- a/tools/testing/selftests/kvm/include/x86_64/processor.h
> > +++ b/tools/testing/selftests/kvm/include/x86_64/processor.h
> > @@ -237,7 +237,6 @@ static inline uint64_t get_desc64_base(const struct desc64 *desc)
> >  static inline uint64_t rdtsc(void)
> >  {
> >         uint32_t eax, edx;
> > -       uint64_t tsc_val;
> >         /*
> >          * The lfence is to wait (on Intel CPUs) until all previous
> >          * instructions have been executed. If software requires RDTSC to be
> > @@ -245,8 +244,8 @@ static inline uint64_t rdtsc(void)
> >          * execute LFENCE immediately after RDTSC
> >          */
> >         __asm__ __volatile__("lfence; rdtsc; lfence" : "=a"(eax), "=d"(edx));
> > -       tsc_val = ((uint64_t)edx) << 32 | eax;
> > -       return tsc_val;
> > +
> > +       return ((uint64_t)edx) << 32 | eax;
> >  }
> 
> This does beg the question: "Why?"

Yeah, for this one I think having a local variable adds value.
