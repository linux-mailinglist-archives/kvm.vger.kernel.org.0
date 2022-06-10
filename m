Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3176545933
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 02:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345642AbiFJAfD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 20:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239863AbiFJAfB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 20:35:01 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE2215AB18
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 17:34:57 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id hv24-20020a17090ae41800b001e33eebdb5dso2609431pjb.0
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 17:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6aq2IG/dHm8lryaEF9k98rbozj/J94OCKVxcaPUmS2M=;
        b=atQEVgMVPycKO9nPmo7OzmQC1spbcVKip2A2aCNYD0inDH7W93ukHHOXHvdPjkV6NM
         6R4sj7EWjBwM/Keym49eIbj2Rulhk8YM5QrcS9RqEDHwHB9YfeJIssNSXDAF0P8IGolV
         7mLtZOt8DPtuwyVcAMIBqBX/Hoo9M7ln6NMM6A4ok6sCxmZx/HskthMFLt1jESI47LCu
         R6b862i9566AlvkY91K6sHAOKs6ocY5wcIdZkN740X3cHpbZCkporH/NnimSU40ACUxB
         QGDB/ioMRCZoDQ/v+Kq5b8DpUjvDe+RibKWCJPZkjv+ZLts7VEF26nIGj29K4oqQJntn
         WzWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6aq2IG/dHm8lryaEF9k98rbozj/J94OCKVxcaPUmS2M=;
        b=bdwDiseIyyI00Gf9mvDaF52eKTpRD047Dbo6Mg2uWxQdrPSsiG8DXmEi1mQ6DCv3By
         Ro3XJb2l5WHGer9WjFS2tuqCg4pryad1ggcUqphBhvssNymeMKmEASdCYiMNaqHzAKPN
         WORONWnABU/0Jk/fc5VienzY5SiClT9I7wor7cKD8oCJgT4Mt8OoMZBRJwbfKYwyCZVB
         StWdcCneIXxRHl9AJ5CLQZQH0wGEn3+ZyUWCTLP/0EcSdQ3jzZZriZom6bDME6C0ygGU
         oobWrJl6slYqNeUa+HCXxvW4xXGaudMdHEddbdPEq7gkkaXo1gtmAp41PH+RTBb1upmW
         atJQ==
X-Gm-Message-State: AOAM533Ar0L9Nq3txQrFbHz8Jwn67NBFyghF2VNRDNoo1dd8dM7mGu20
        AHX8VUYoprs6LHxGyzsYQs4s2w==
X-Google-Smtp-Source: ABdhPJzSNFVk6lq6OH/RQy+VY4tKL4BeOGmjqJoy1Ob2zSOc/+4TL2/YkRqKl8Ak4CNnzNyFfKG34A==
X-Received: by 2002:a17:903:22ca:b0:163:e2b6:e10a with SMTP id y10-20020a17090322ca00b00163e2b6e10amr41964333plg.32.1654821297214;
        Thu, 09 Jun 2022 17:34:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id gd3-20020a17090b0fc300b001e2da6766ecsm297249pjb.31.2022.06.09.17.34.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 17:34:56 -0700 (PDT)
Date:   Fri, 10 Jun 2022 00:34:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Anup Patel <anup@brainfault.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        KVM General <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>,
        Oliver Upton <oupton@google.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 000/144] KVM: selftests: Overhaul APIs, purge VCPU_ID
Message-ID: <YqKRrK7SwO0lz/6e@google.com>
References: <20220603004331.1523888-1-seanjc@google.com>
 <21570ac1-e684-7983-be00-ba8b3f43a9ee@redhat.com>
 <CAAhSdy0_50KshS1rAcOjtFBUu=R7a0uXYa76vNibD_n7s=q6XA@mail.gmail.com>
 <CAAhSdy1N9vwX1aXkdVEvO=MLV7TEWKMB2jxpNNfzT2LUQ-Q01A@mail.gmail.com>
 <YqIKYOtQTvrGpmPV@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YqIKYOtQTvrGpmPV@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 09, 2022, Sean Christopherson wrote:
> On Thu, Jun 09, 2022, Anup Patel wrote:
> > On Wed, Jun 8, 2022 at 9:26 PM Anup Patel <anup@brainfault.org> wrote:
> > >
> > > On Tue, Jun 7, 2022 at 8:57 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
> > > >
> > > > Marc, Christian, Anup, can you please give this a go?
> > >
> > > Sure, I will try this series.
> > 
> > I tried to apply this series on top of kvm/next and kvm/queue but
> > I always get conflicts. It seems this series is dependent on other
> > in-flight patches.
> 
> Hrm, that's odd, it's based directly on kvm/queue, commit 55371f1d0c01 ("KVM: ...).

Duh, Paolo updated kvm/queue.  Where's Captain Obvious when you need him...

> > Is there a branch somewhere in a public repo ?
> 
> https://github.com/sean-jc/linux/tree/x86/selftests_overhaul

I pushed a new version that's based on the current kvm/queue, commit 5e9402ac128b.
arm and x86 look good (though I've yet to test on AMD).

Thomas,
If you get a chance, could you rerun the s390 tests?  The recent refactorings to
use TAP generated some fun conflicts.

Speaking of TAP, I added a patch to convert __TEST_REQUIRE to use ksft_exit_skip()
instead of KVM's custom print_skip().  The s390 tests are being converted to use
TAP output, I couldn't see any advantage of KVM's arbitrary "skipping test" over
TAP-friendly output, and converting everything is far easier than special casing s390.
