Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 675FA69F408
	for <lists+kvm@lfdr.de>; Wed, 22 Feb 2023 13:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbjBVMIr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Feb 2023 07:08:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbjBVMIq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Feb 2023 07:08:46 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E33138032;
        Wed, 22 Feb 2023 04:08:19 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id m4so9193722qvq.3;
        Wed, 22 Feb 2023 04:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0kbr9Sef9mc0aYct+IUivTV4CFaWy16hlZwHABrvkcs=;
        b=OHZ0uQalu5zyESmAfbGLo/zaHucfZrUWPRA4+77Aw/rqg6wKkMUZYCHNupav7gJzsW
         hIXF3DgWulF/2E7d53xCE3kiKV08rp428LIma48EaShGT5hNje+jXy1fDuspTSJp23rC
         smguA1C5mJgofyDwswPRqJxb/lpSIsQXEc1PXGzmbCtgwFvjqzzQgs6mqLu5A6PUR940
         UMsTcP6g51X3m85CZrM9FfMuXIN+1Fn/rbJ9zbeI8VvH3nLXq6GommSuNNBPOALV07p+
         TNSrJ/Dnj6L9iKCF6g3MgOAHfypoxXJZm7mJCLF26QmRS7TyidLtpUsmaxDI3ZwDjezF
         fvXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0kbr9Sef9mc0aYct+IUivTV4CFaWy16hlZwHABrvkcs=;
        b=KcLnFhe2cJOzKV0YsXnccUg9zhsbCg2CWtdND4nso/n1a5BPWt3Za+HtXi0CKVU2yW
         r6YWzfdl5mxXCFEtVHUft4N4tTMAmzIA9YC2tI9utYKDO2fHfXdtquU8GqA5T58XoqMB
         h6x+s5JUOBOg+gwN5YpLJulRJKzDESnxsCw060e1eBONisBSrRZaLAVerOonGNAhJBad
         OmX4TSZ1Yj4SkiZElOHBr4Eautj2i1Q4ssOwuXRhfG6ZYfuhm9HoSlvMkQOG3j3952YO
         LgKhH6z2tLXx7TC4u7Vr/hfGU6dxXrDG9AjGoFOPTa8lwqkpioq8QgD4+EzL6XKR/k8d
         lpDg==
X-Gm-Message-State: AO0yUKU0xd6+GvKOcKAXVR72+bZQyQcDNT6DW7gECvvWsSgsTp1D9tUv
        OrXcF9Tm48atI1x+TioC++GHkpaHxqZ4pFDCLw==
X-Google-Smtp-Source: AK7set+6wpWhrBpE7GWtb/JoVUPno1H8zFd1yYPc8EIm0FXKBn0lKEWRTstP3wdckrpvgn+ZbuERsSOuV0q//TNeWb4=
X-Received: by 2002:ad4:5a0e:0:b0:56e:fbce:6159 with SMTP id
 ei14-20020ad45a0e000000b0056efbce6159mr1094519qvb.0.1677067696490; Wed, 22
 Feb 2023 04:08:16 -0800 (PST)
MIME-Version: 1.0
References: <20230215145425.420125-1-usama.arif@bytedance.com> <62ee53770b4010f065346b7f2a1200013836be97.camel@infradead.org>
In-Reply-To: <62ee53770b4010f065346b7f2a1200013836be97.camel@infradead.org>
From:   Brian Gerst <brgerst@gmail.com>
Date:   Wed, 22 Feb 2023 07:08:04 -0500
Message-ID: <CAMzpN2gEeNY87+ywgizusPVG2fLiRx3v__3Bmqjo_eJLv+5k7Q@mail.gmail.com>
Subject: Re: [PATCH v9 0/8] Parallel CPU bringup for x86_64
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Usama Arif <usama.arif@bytedance.com>, tglx@linutronix.de,
        kim.phillips@amd.com, arjan@linux.intel.com, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com,
        x86@kernel.org, pbonzini@redhat.com, paulmck@kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        rcu@vger.kernel.org, mimoja@mimoja.de, hewenliang4@huawei.com,
        thomas.lendacky@amd.com, seanjc@google.com, pmenzel@molgen.mpg.de,
        fam.zheng@bytedance.com, punit.agrawal@bytedance.com,
        simon.evans@bytedance.com, liangma@liangbit.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 22, 2023 at 5:44 AM David Woodhouse <dwmw2@infradead.org> wrote=
:
>
> On Wed, 2023-02-15 at 14:54 +0000, Usama Arif wrote:
> > The main change over v8 is dropping the patch to avoid repeated saves o=
f MTRR
> > at boot time. It didn't make a difference to smpboot time and is indepe=
ndent
> > of parallel CPU bringup, so if needed can be explored in a separate pat=
chset.
> >
> > The patches have also been rebased to v6.2-rc8 and retested and the
> > improvement in boot time is the same as v8.
>
> Thanks for picking this up, Usama.
>
> So the next thing that might be worth looking at is allowing the APs
> all to be running their hotplug thread simultaneously, bringing
> themselves from CPUHP_BRINGUP_CPU to CPUHP_AP_ONLINE. This series eats
> the initial INIT/SIPI/SIPI latency, but if there's any significant time
> in the AP hotplug thread, that could be worth parallelising.
>
> There may be further wins in the INIT/SIPI/SIPI too. Currently we
> process each CPU at a time, sending INIT, SIPI, waiting 10=C2=B5s and
> sending another SIPI.
>
> What if we sent the first INIT+SIPI to all CPUs, then did another pass
> sending another SIPI only to those which hadn't already started running
> and set their bit in cpu_initialized_mask ?
>
> Might not be worth it, and there's an added complexity that they all
> have to wait for each other (on the real mode trampoline lock) before
> they can take their turn and get as far as setting their bit in
> cpu_initialized_mask. So we'd probably end up sending the second SIPI
> to most of them *anyway*.

Speaking of next steps, I have a followup patchset ready to go that
removes the global variables initial_stack, initial_gs, and
early_gdt_descr.  Should I send that now or wait until this patchset
lands in -tip?

--
Brian Gerst
