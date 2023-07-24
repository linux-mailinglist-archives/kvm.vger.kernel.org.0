Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE0C760356
	for <lists+kvm@lfdr.de>; Tue, 25 Jul 2023 01:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjGXXxN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Jul 2023 19:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjGXXxM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Jul 2023 19:53:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9FD125
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 16:53:11 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d06d36b49f9so2511123276.1
        for <kvm@vger.kernel.org>; Mon, 24 Jul 2023 16:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690242790; x=1690847590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dxDEr6TxuqCZG2S3i+GYPr3CIoauu1/JkVLvrcdX1k8=;
        b=riBFHF5ZqCdqw8sWs7VJGGiZDkSpy5F/57JKkwCoSWSfQiXArbwh0BuEirnWxJHXnT
         5J0hZOUNmaNu+42JoCoX0ng1d9osiJcNKhDGjqsdutYTtIuNRHM2UUKgwpcuYB9eswGb
         vkjTunEMnX/1px4cpb3qziXT8k5d67k9mDVuHGGw8B5qU9pZFhHTBooh2JgafB0S8Ad7
         YGTiWmizeLTkttcKD+t1Ce9T8BetKUZC+gX7CcCVUqr8Ok54EWi+eMBU/i/yA6eTQHaY
         zlpcbRsJXyrgJrBjrtoIDwmt0yNAgTjdtbdoOxbcg2BPm7/OPSN85BvogATQArLgn9Q4
         fPIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690242790; x=1690847590;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dxDEr6TxuqCZG2S3i+GYPr3CIoauu1/JkVLvrcdX1k8=;
        b=axeKM/+cQBZs1R6hJ9pOkDtrkD8TBzPoCJ6WOCpqR3TuHgl8OY8Ij611WwQnmtqOJm
         y9RKyGdO75hieAFnIbQTBIzy/L1XgBdN4eopMrFJNUyuk07RfKpdSaSJtXQ12Wd7Gu6q
         b2UmYfd7tz74SJQRTNYLF3asol2FSDonxALmGxtA0U32c5KJWeTK5juwB/jnAmlKeCPs
         kwaqnTU53BUOFMz3LZf3p5ghIZQsPj27mNSmiyrWUbPFxeDnwUFCzxoVAmiVN4M7HUfw
         gbJu7I7Im/xqjF2fkN3xVo34mmmv+ywdINRnGHSt1BrRcoinWk0nVJk+jADOQm86mfZh
         KzQQ==
X-Gm-Message-State: ABy/qLYfQiJyLPfqtEqAfRDghRWT+n26v6La5iZneLv2IUxF5ETkLfKI
        z2purhMvI8tGh4gsDtSocwVsKtVR5dc=
X-Google-Smtp-Source: APBJJlGEB5CXUmQbk77O7vEDEGm9EzOQ1897eGyKu+HhiqUYzwAgKD2Xlye9SzDfM/1stynw6qj6WXBVssI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:188b:0:b0:cab:e42c:876b with SMTP id
 133-20020a25188b000000b00cabe42c876bmr65608yby.3.1690242790428; Mon, 24 Jul
 2023 16:53:10 -0700 (PDT)
Date:   Mon, 24 Jul 2023 16:53:08 -0700
In-Reply-To: <ZL77Tt42+ZI2BAv5@google.com>
Mime-Version: 1.0
References: <20230721201859.2307736-1-seanjc@google.com> <20230721201859.2307736-15-seanjc@google.com>
 <ZL77Tt42+ZI2BAv5@google.com>
Message-ID: <ZL8O5BiKLbbfmYlU@google.com>
Subject: Re: [PATCH v4 14/19] KVM: SVM: Check that the current CPU supports
 SVM in kvm_is_svm_supported()
From:   Sean Christopherson <seanjc@google.com>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 24, 2023, Dmitry Torokhov wrote:
> Hi Sean,
> 
> On Fri, Jul 21, 2023 at 01:18:54PM -0700, Sean Christopherson wrote:
> > +static bool kvm_is_svm_supported(void)
> > +{
> > +	bool supported;
> > +
> > +	migrate_disable();
> > +	supported = __kvm_is_svm_supported();
> > +	migrate_enable();
> 
> I am typically very wary of the constructs like this, as the value
> returned is obsolete the moment migrate_enable() happens.

Yeah, I don't like this code, but there's no great solution in this case.  Or at
least, none that I've found.  At some point KVM has to enable migration/preemption
before "is KVM supported?" is ultimately consumed, as the real consumer is
userspace.

> Is value of "svm was supported at some time in the past but may or may not be
> supported right now" useful and if it is then could you add comment why?

No, because barring fatal silicon/ucode/kernel bugs, SVM support isn't expected
to disappear or (re)appear).

KVM defends against the "disappear" case as much as can be reasonably expected.
It's ugly, but functionally ok (not perfect, but ok).  KVM doesn't actually care
which CPU does the initial support check, because KVM will do fully protected support
checks on all CPUs before actually letting userspace create VMs.  This is why the
changelog states that ensuring a stable CPU is a non-goal, and also why the inner
helpers don't use the raw accessors.

The "(re)appear" case doesn't need to be handled, because userspace could simply
retry if it really wanted to (but that would be quite insane/nonsensical, and
just asking for problems).

I didn't add a comment because VMX uses the exact same pattern, and I didn't
want to copy+paste a non-trivial comment.  And this is a single use local helper,
so I'm not terribly concerned about it being misused.

That said, I'll see if I can find a common, intuitive location to document this.
