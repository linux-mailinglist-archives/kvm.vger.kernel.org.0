Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76FF358E15E
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 22:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiHIUyK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 16:54:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiHIUxm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 16:53:42 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E3D15A2B
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 13:53:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id o5-20020a17090a3d4500b001ef76490983so123016pjf.2
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 13:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=pJblVN/EwDKnGoYTvY52rorYjnKswwmvjLRNuq3g3VE=;
        b=GbUPKddyRcffK7GnxZeqqcUioCOBYjZYcND1JWvpTTanaun1D9fGTvEAbdn125PW6m
         JLjs5YyKKh7edLtHVT0tHekB/pNop76ht7souklms4QnoaKiHs8glUoRTRM+Mfo8T9Wd
         Q8JXLAja5U0d1nkYehhAvAfuKo06DjcO+uoxCK8jXyV1FA9g3aXQEBfaTLKZJ6FVL/Mt
         NMgBfRYESMHWHpBAQGqe86ARj9HVA94d7TsUE/YkyfA1kBd8DX8QSHykjK5j4xexTJPv
         k3mNOu14Dx9T3iSZbwK0WM2QonrbFR+wdYL0qCqooRcYs3zUHOlu/GhNspIACNbPZ6x3
         ZDBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=pJblVN/EwDKnGoYTvY52rorYjnKswwmvjLRNuq3g3VE=;
        b=pjn0WO+pRZ9TIZzSxE8dfxfdCd1kovXSTB7L9Q1+/2GumVrtl9MWBNLILQpXngbMSg
         ceVQSY8lkb+U9S2kqeqO1WXXB9+px3NAL2DtZZSH69fDBZhw0u/3A6pKXjOk/Nxq7l6y
         Y1kugRexenMuh2OOFMlqLXDRDmOyhdcTNeXbiPZrRSvpl6K/hdgxHciVXEqESRZs1Inf
         sEnI+E/yL2EECIilTL0CYnsO3Ng9JpcJ//sTXhhgosHTGABhOUbAJWdU5pKiEnY/LEQ5
         2fLAsbsobglSAwdWD50V65DqA4kbfksmMMASBYjK0QlnF1p/UCk2AdEdF/DsyDnQal4a
         /edg==
X-Gm-Message-State: ACgBeo160YqC2gr2wdpTDtjyCJbdL3uNRuivF+l/dSLX061giZPrMk8X
        n3pXkbrHu9tTEe91zG78boKgKg==
X-Google-Smtp-Source: AA6agR5zPiBVnYt1kAUuxrAkMt0LXjWgm1wd+WLRJjf0RsoJ/oyZpNSqLwA3FNlryMJpO0oPIuNAIg==
X-Received: by 2002:a17:902:eb8a:b0:16d:c75a:c40b with SMTP id q10-20020a170902eb8a00b0016dc75ac40bmr25435222plg.102.1660078420716;
        Tue, 09 Aug 2022 13:53:40 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902e5c800b00170a359eb0esm5711482plf.63.2022.08.09.13.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 13:53:40 -0700 (PDT)
Date:   Tue, 9 Aug 2022 20:53:36 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Florian Weimer <fweimer@redhat.com>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        oliver.upton@linux.dev, andrew.jones@linux.dev,
        mathieu.desnoyers@efficios.com, yihyu@redhat.com,
        shan.gavin@gmail.com
Subject: Re: [PATCH 2/2] KVM: selftests: Use getcpu() instead of
 sched_getcpu() in rseq_test
Message-ID: <YvLJUEOcxaZKW0y1@google.com>
References: <20220809060627.115847-1-gshan@redhat.com>
 <20220809060627.115847-3-gshan@redhat.com>
 <87y1vxncv1.fsf@oldenburg.str.redhat.com>
 <87mtcdnaxe.fsf@oldenburg.str.redhat.com>
 <ea2ef1a2-0fd8-448b-d7ca-254603518823@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ea2ef1a2-0fd8-448b-d7ca-254603518823@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 09, 2022, Gavin Shan wrote:
> On 8/9/22 5:17 PM, Florian Weimer wrote:
> > * Florian Weimer:
> > 
> > > * Gavin Shan:
> > > 
> > > > sched_getcpu() is glibc dependent and it can simply return the CPU
> > > > ID from the registered rseq information, as Florian Weimer pointed.
> > > > In this case, it's pointless to compare the return value from
> > > > sched_getcpu() and that fetched from the registered rseq information.
> > > > 
> > > > Fix the issue by replacing sched_getcpu() with getcpu(), as Florian
> > > > suggested. The comments are modified accordingly.
> > > 
> > > Note that getcpu was added in glibc 2.29, so perhaps you need to perform
> > > a direct system call?
> > 
> > One more thing: syscall(__NR_getcpu) also has the advantage that it
> > wouldn't have to be changed again if node IDs become available via rseq
> > and getcpu is implemented using that.
> > 
> > Thanks,
> > Florian
> > 
> 
> Thanks, Florian. It makes sense to me to use syscall(__NR_getcpu) in
> next revision. Thanks for your quick review :)

+1, and definitely add a comment to prevent future "cleanup".
