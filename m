Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF3F5E56D5
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 01:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiIUXqk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 21 Sep 2022 19:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbiIUXqj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 21 Sep 2022 19:46:39 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EBDA060B
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 16:46:38 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u132so7571707pfc.6
        for <kvm@vger.kernel.org>; Wed, 21 Sep 2022 16:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=oLmfKWuUTNL21IQ6HESQaaXbmI+ko3s/zbVnpQNTyfQ=;
        b=ZhPjG3hJi+MYcKRihGUdAC68xvTWiMoW7SPD8OTcOZ26+dN5JNCX/1w6nFfyBCMstE
         5HYD4Fse3n9roNiceTXE44Upoj73OH2Cq728vb6uC7wyB1ELBnRp3QOIas5WBcfDDtZW
         yGRjURMv19EhBh2rt5Wo+TBFMeOe50xrac1nFYO5ruNLvMCpxjlZjTnlUAwipjgnm1Qr
         guH3EBQ4F/A3bEWfskdvaLhydQ9rr+SiKQoTVq1/gvGGHky725DBu8BYhOgkv7ojic15
         LdbhRd81llw9FC383cjWQzz9qSVioH+77jgRKVTCjN52Cx0QDwCaR7JId0drMgzjd18G
         VQVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=oLmfKWuUTNL21IQ6HESQaaXbmI+ko3s/zbVnpQNTyfQ=;
        b=kq5bN3yZUxOjSzmw4aF+3EEhiSpMPZcKNx2/a+FO9fDV9nzSswlrFeTbcWquDN3wZg
         gxKwf1VzU0Z8Egw0stCwbVffz0CZjKMsuKVybz6JTe+E2Z9ZEYIbBDA6n+uSAMwND2OH
         6KTOSSxRdhlEDm3pEHdUuFHZAKuvd4ZX1PFuBAWv0N/Y3dQ24hQA1drCbCtHRzpa0k+T
         MpB9wnWGgx2EldXhwhhy0dt2SeTmEOGkdVZBQ26Y1N69H5pbRysZIbX4FO3aSLlQ16b0
         PtopJQ+OuvVfTdpmPLdGykh+b+/pZh+RmFZ0aOyIgJGkywN3EJxmeAvTiEiRO1Ey7I6Z
         hdcg==
X-Gm-Message-State: ACrzQf1cMk2HPLTOodSeDp6+XKwhAbyji+rXkyr6ei0X4vpCpX99hfml
        sbyOu4L1PAYx1VNErW47GZy2Hw==
X-Google-Smtp-Source: AMsMyM6XbKjJMUzlns8HLCwuDBcHPQZk6TBhuf7BAseDGdPOhjE8XWL38BgMGblaP5ZfSFJoRXpHQw==
X-Received: by 2002:a05:6a00:1249:b0:543:aa0a:9c0a with SMTP id u9-20020a056a00124900b00543aa0a9c0amr580002pfi.2.1663803998248;
        Wed, 21 Sep 2022 16:46:38 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id z4-20020a1709027e8400b00177e5d83d3dsm2579190pla.170.2022.09.21.16.46.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 16:46:37 -0700 (PDT)
Date:   Wed, 21 Sep 2022 23:46:34 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, pbonzini@redhat.com,
        vkuznets@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: Fix hyperv_features test failure when
 built on Clang
Message-ID: <YyuiWk/4TFYqf0qN@google.com>
References: <20220921231151.2321058-1-vipinsh@google.com>
 <CALMp9eQ8Rr-rSjXiZ_4O0mA=k3kk=hYrfB_NTszu=9DFOwNUaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eQ8Rr-rSjXiZ_4O0mA=k3kk=hYrfB_NTszu=9DFOwNUaQ@mail.gmail.com>
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

On Wed, Sep 21, 2022, Jim Mattson wrote:
> On Wed, Sep 21, 2022 at 4:11 PM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > hyperv_features test fails when built on Clang. It throws error:
> >
> >          Failed guest assert: !hcall->ud_expected || res == hcall->expect at
> >          x86_64/hyperv_features.c:90
> >
> > On GCC, EAX is set to 0 before the hypercall whereas in Clang it is not,
> > this causes EAX to have garbage value when hypercall is returned in Clang
> > binary.
> >
> > Fix by executing the guest assertion only when ud_expected is false.

TL;DR: please rewrite the changelog to explain the actual bug (checking the
result when the hypercall is expected to fault) and the fix, and only mention the
gcc vs. clang behavior as a footnote.

As Jim pointed out, the bug has nothing to do with clang.  Ha, figured out why
gcc passes; it uses RAX as the scratch reg that the asm blob loads into R8,
i.e. loads RAX with @output_address.  So ignore my earlier suggestion of:

	*hv_status = -EFAULT,

even better is to do:

diff --git a/tools/testing/selftests/kvm/x86_64/hyperv_features.c b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
index 79ab0152d281..673085f6edfd 100644
--- a/tools/testing/selftests/kvm/x86_64/hyperv_features.c
+++ b/tools/testing/selftests/kvm/x86_64/hyperv_features.c
@@ -26,7 +26,8 @@ static inline uint8_t hypercall(u64 control, vm_vaddr_t input_address,
                     : "=a" (*hv_status),
                       "+c" (control), "+d" (input_address),
                       KVM_ASM_SAFE_OUTPUTS(vector)
-                    : [output_address] "r"(output_address)
+                    : [output_address] "r"(output_address),
+                      "a"(-EFAULT)
                     : "cc", "memory", "r8", KVM_ASM_SAFE_CLOBBERS);
        return vector;
 }

so that there is zero chance of getting a false positive due to the compiler
(but not KVM) modifying RAX.

Anyways, this bug is not clang's fault, with above patch it fails as "expected".

==== Test Assertion Failure ====
  x86_64/hyperv_features.c:622: false
  pid=283847 tid=283847 errno=4 - Interrupted system call
     1	0x0000000000402842: guest_test_hcalls_access at hyperv_features.c:622
     2	 (inlined by) main at hyperv_features.c:642
     3	0x00007f23fc513082: ?? ??:0
     4	0x0000000000402ebd: _start at ??:?
  Failed guest assert: !hcall->ud_expected || res == hcall->expect at x86_64/hyperv_features.c:90
arg1 = 0, arg2 = fffffff2


> > Fixes: cc5851c6be86 ("KVM: selftests: Use exception fixup for #UD/#GP Hyper-V MSR/hcall tests")
> > Signed-off-by: Vipin Sharma <vipinsh@google.com>
> > Suggested-by: Sean Christopherson <seanjc@google.com>
> >
> > ---
> >  tools/testing/selftests/kvm/x86_64/hyperv_features.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> In case Sean doesn't point it out, be wary of starting a shortlog with
> "Fix." You may later regret it.

Heh, I think our record is "Really, really fix xyz" for a shortlog.

> Also, I think the "clang" part is a red herring. You are fixing a
> latent bug in the code.

Ya, it's definitely a good idea to call out why a bug was missed, but clang is
not to blame here, at all.  
