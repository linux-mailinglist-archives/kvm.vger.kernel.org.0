Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76B3075A4F7
	for <lists+kvm@lfdr.de>; Thu, 20 Jul 2023 06:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbjGTEFO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jul 2023 00:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbjGTEFM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jul 2023 00:05:12 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F272115
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 21:05:10 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-345bc4a438fso56795ab.1
        for <kvm@vger.kernel.org>; Wed, 19 Jul 2023 21:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689825909; x=1690430709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6ELdAbY5cUD7SOr7PDuHWOqaGhr3pv/j2FOIIFK4Z0=;
        b=YN7JBtbZdMcRkmfWUuZvlOOcb7BKhBUKsTCY/e/v9Ty7yImCK652whIeKO5cC4JOdS
         gpvVq+iK6SGQhOZFdYmOpWjGnl1edXctTzbtFKznw7ws1JrOwt3RTDO3+lwmNTJKDo/G
         8lh9a/FvMhwzZ/Q/qyx+Imdsff29AerQonvGD3Grf4Z7H0IUvcO/CKBUhhiqnCUtCbdI
         MMsL2KM5TXV8Sd23lcEYBh4RuhdyYBD3aPEOTH9hUoCIP03WMBZLzk1pns3cg5NUUwuf
         ToxVeMH9wJLmLvk9Ww/o7JRbTt0RIgXJgoNOtq+wT//wPHn+hYi4lh6qnvoFHwmoyG9t
         W9RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689825909; x=1690430709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I6ELdAbY5cUD7SOr7PDuHWOqaGhr3pv/j2FOIIFK4Z0=;
        b=BF1tmXal09OcTNBV6gFEU7/qnX6UfTFxFIWxArDlylvTCTFIAIWq23j5PCPuMBbQ43
         m0eFrAIoG36jGbzCPsA8kqQ8o0dqhJJZyUcr11qQjJRwvqwshAMMRcUkSt3Pyvtx2Toq
         lugb+Z6G8EdUavMk3g/k1q++bGNVtWoQWP0IbGnWxDCg7P4m4MAWPpE8JBCyYEcMyKEY
         JZQ3+wrcQjcnRlEGK4F4xOMt66Ys+yWmw48AhsT4+WBXejm6bQYZwjW68Cy3Rwj0Ge9A
         DPC8pTR67NxNwpUDIyLxUsiLPOTljezYJnDJkUN8Gg08AJ8ec+FCCvaU22wnyqvhDIUr
         aJZg==
X-Gm-Message-State: ABy/qLYVrV6igBFUzQmJC+HXzBJYpbVMTEtxbKWCAXJZxgj14+vY3jmH
        w6j67bjlHsuaBo7Wg0/LtQGWdAv2Zdbtbx4nGu/iQA==
X-Google-Smtp-Source: APBJJlF20daTKuN87CalQl8R7wzjY2F4oEEI43/8SOcnWRnPIVdNNIN/iGTqHdTRZuomDodz000j7+PYrvGszmv2fR8=
X-Received: by 2002:a92:c54c:0:b0:33d:b6ed:8bf3 with SMTP id
 a12-20020a92c54c000000b0033db6ed8bf3mr98554ilj.27.1689825909559; Wed, 19 Jul
 2023 21:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <CALMp9eRQeZESeCmsiLyxF80Bsgp2r54eSwXC+TvWLQAWghCdZg@mail.gmail.com>
 <529cd705-f5c3-a5d1-9999-a3d2ccd09dd6@intel.com> <ZLiUrP9ZFMr/Wf4/@chao-email>
In-Reply-To: <ZLiUrP9ZFMr/Wf4/@chao-email>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 19 Jul 2023 21:04:58 -0700
Message-ID: <CALMp9eTQ5zDpjK+=e+Rhu=zvLv_f0scqkUCif2tveq+ahTAYCg@mail.gmail.com>
Subject: Re: KVM's sloppiness wrt IA32_SPEC_CTRL and IA32_PRED_CMD
To:     Chao Gao <chao.gao@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 19, 2023 at 6:58=E2=80=AFPM Chao Gao <chao.gao@intel.com> wrote=
:
>
> On Thu, Jul 20, 2023 at 09:25:14AM +0800, Xiaoyao Li wrote:
> >On 7/20/2023 2:08 AM, Jim Mattson wrote:
> >> Normally, we would restrict guest MSR writes based on guest CPU
> >> features. However, with IA32_SPEC_CTRL and IA32_PRED_CMD, this is not
> >> the case.
>
> This issue isn't specific to the two MSRs. Any MSRs that are not
> intercepted and with some reserved bits for future extenstions may run
> into this issue. Right? IMO, it is a conflict of interests between
> disabling MSR write intercept for less VM-exits and host's control over
> the value written to the MSR by guest.

I've clearly been falling behind in tracking upstream development. I
didn't realize that we passed through any other MSRs that had bits
reserved for future extensions (virtual addresses don't count). It
looks like we've decided to virtualize IA32_FLUSH_CMD as well, even
though Konrad had the good sense to talk me out of it when I first
proposed it. Are there others I'm missing?

Philosophically, there are three principles potentially in conflict
here: security, correctness, and performance. Userspace should perhaps
be given the option of prioritizing one over the others, but the
default precedence should be security first, correctness second, and
performance last.

> We may need something like CR0/CR4 masks and read shadows for all MSRs
> to address this fundamental issue.

Not *all* MSRs, but some, certainly. That is one possible solution,
but I get the impression that you're not really serious about this
proposal.

> >>
> >> For the first non-zero write to IA32_SPEC_CTRL, we check to see that
> >> the host supports the value written. We don't care whether or not the
> >> guest supports the value written (as long as it supports the MSR).
> >> After the first non-zero write, we stop intercepting writes to
> >> IA32_SPEC_CTRL, so the guest can write any value supported by the
> >> hardware. This could be problematic in heterogeneous migration pools.
> >> For instance, a VM that starts on a Cascade Lake host may set
> >> IA32_SPEC_CTRL.PSFD[bit 7], even if the guest
> >> CPUID.(EAX=3D07H,ECX=3D02H):EDX.PSFD[bit 0] is clear. Then, if that VM=
 is
> >> migrated to a Skylake host, KVM_SET_MSRS will refuse to set
> >> IA32_SPEC_CTRL to its current value, because Skylake doesn't support
> >> PSFD.
>
> It is a guest fault. Can we modify guest kernel in this case?

The guest should not have set the bit. The hypervisor should not have
allowed it. Both are at fault.

I'm willing to bet that Intel has a CPU validation suite that includes
such tests as setting reserved bits in MSRs and ensuring that #GP is
raised. Those tests should also work in a VM. If they don't, the
hypervisor is broken.

> >>
> >> We disable write intercepts IA32_PRED_CMD as long as the guest
> >> supports the MSR. That's fine for now, since only one bit of PRED_CMD
> >> has been defined. Hence, guest support and host support are
> >> equivalent...today. But, are we really comfortable with letting the
> >> guest set any IA32_PRED_CMD bit that may be defined in the future?
> >>
> >> The same question applies to IA32_SPEC_CTRL. Are we comfortable with
> >> letting the guest write to any bit that may be defined in the future?
> >
> >My point is we need to fix it, though Chao has different point that some=
times
> >performance may be more important[*]
> >
> >[*] https://lore.kernel.org/all/ZGdE3jNS11wV+V2w@chao-email/
>
> Maybe KVM can provide options to QEMU. e.g., we can define a KVM quirk.
> Disabling the quirk means always intercept IA32_SPEC_CTRL MSR writes.

Alternatively, we can check the host value of IA32_SPEC_CTRL on
VM-entry, since we have to read it anyway. If any bits are set that
cannot be cleared in VMX non-root operation without compromising
security, then writes to IA32_SPEC_CTRL should be intercepted.

> >
> >> At least the AMD approach with V_SPEC_CTRL prevents the guest from
> >> clearing any bits set by the host, but on Intel, it's a total
> >> free-for-all. What happens when a new bit is defined that absolutely
> >> must be set to 1 all of the time?
>
> I suppose there is no such bit now. For SPR and future CPUs, "virtualize
> IA32_SPEC_CTRL" VMX feature can lock some bits to 0 or 1 regardless of
> the value written by guests.

As your colleague pointed out earlier, IA32_SPEC_CTRL.STIBP[bit 1] is
such a bit. If the host has this bit set and you allow the guest to
clear it, then you have compromised host security.
