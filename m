Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 085B068CA97
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 00:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjBFXes (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 18:34:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBFXe2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 18:34:28 -0500
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D67FB1204B
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 15:34:27 -0800 (PST)
Received: by mail-vs1-xe31.google.com with SMTP id a24so14518571vsl.2
        for <kvm@vger.kernel.org>; Mon, 06 Feb 2023 15:34:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FbhxqYSnM0QVkv6Sp3VM+vd772qQ+TcTU6CDsEGA4Og=;
        b=Cx79guYuAJpsYHml9Wx/12xWxQPyF8soU/xhIAgPEnvNvCUSxYU7iY51ACUPWGPdbb
         kUUXWUl6PRVxqL5+0yWtIk+UJjU6n4T8JrtX3KYBVQT2bSKs/rpe2oWBVmdtbKknMXXA
         umJXccBR70k9eQZGdx7v02ys14adp2l7UQHjvxKpd1Da75gJdFWVc0QfS/UNBPcE3xUy
         kLepkR4YZQFz9NwmDa788RmmwL7cJhHHAkmKv+DtTdc5qlQNpSFv2T2waf1x0SxE/24T
         l82PbUP2UNQ/mDXExubTPt4OlRlSsP3GYWAx+0TJGg7MR6n8FIrT6ncCs8CvQwhIbhnT
         cagg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FbhxqYSnM0QVkv6Sp3VM+vd772qQ+TcTU6CDsEGA4Og=;
        b=U61Zmy3hqXteQyskuWOPwff2W1fNxxLdBsD7ezgJN+8/0JIIywZJaU8QwLIdQs/OE+
         q5nvY/Lq6osGWJIoA4O5h6vF5+/cVvTtPaZCskC1ItB6A3ekdamd40Jy7pDJq9CcmpB6
         Ch76XISwYst/PZ1ihR7OEcxUOBiVepAmhpvUN6tFoSncWTcyjY8KRQIXhKo8juDiL45Y
         fKFoTjPC4z9PrwJwBtgrfxQAUx3TWXmnMfTLIRzUdUH2WA3bzj09ryBoW1U/b0Y0Bax0
         apge58mP9jgLWbaNynJXJmiiwTdLCZlMgsb1hFL/Nbn51LpLTQPkrZRObjGSpy0sRDKS
         7YmA==
X-Gm-Message-State: AO0yUKWT+Q74dRbA0XJ6uUh+DQN/Fjsd+newSb942bXAeESU7HOpmyPh
        z3LLz89mTAnaCLDh9lrBMzCsIZJjmwr1qpbmKjDd6g==
X-Google-Smtp-Source: AK7set+2l/p1gINBZT5HgFQ4KeQHjnsJsxO3Yvjfza4XfHZe7AyEdBtN8oKN4GJIoY06nGFM5pwLnK3I5aoaTauxv74=
X-Received: by 2002:a05:6102:5c0a:b0:401:57f8:7c18 with SMTP id
 ds10-20020a0561025c0a00b0040157f87c18mr323247vsb.51.1675726466974; Mon, 06
 Feb 2023 15:34:26 -0800 (PST)
MIME-Version: 1.0
References: <20230203192822.106773-1-vipinsh@google.com> <20230203192822.106773-3-vipinsh@google.com>
 <CANgfPd8en316O=iTijS5jseM8_eCYm822iwT2d-7Q+jhJBy+HQ@mail.gmail.com>
In-Reply-To: <CANgfPd8en316O=iTijS5jseM8_eCYm822iwT2d-7Q+jhJBy+HQ@mail.gmail.com>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 6 Feb 2023 15:34:00 -0800
Message-ID: <CALzav=eEs_cy6v1r6UD0k_2MOp9RSZ33LgPy2bRrFcZ-g_MBYQ@mail.gmail.com>
Subject: Re: [Patch v2 2/5] KVM: x86/mmu: Optimize SPTE change flow for clear-dirty-log
To:     Ben Gardon <bgardon@google.com>
Cc:     Vipin Sharma <vipinsh@google.com>, seanjc@google.com,
        pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
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

On Mon, Feb 6, 2023 at 2:06 PM Ben Gardon <bgardon@google.com> wrote:
>
> On Fri, Feb 3, 2023 at 11:28 AM Vipin Sharma <vipinsh@google.com> wrote:
> >
> > +static inline u64 kvm_tdp_mmu_clear_spte_bit(struct tdp_iter *iter, u64 mask)
> > +{
> > +       atomic64_t *sptep;
> > +
> > +       if (kvm_tdp_mmu_spte_has_volatile_bits(iter->old_spte, iter->level)) {
> > +               sptep = (atomic64_t *)rcu_dereference(iter->sptep);
> > +               return (u64)atomic64_fetch_and(~mask, sptep);
> > +       }
> > +
> > +       __kvm_tdp_mmu_write_spte(iter->sptep, iter->old_spte & ~mask);
> > +       return iter->old_spte;
> > +}
> > +
>
> If you do end up sending another version of the series and feel like
> breaking up this patch, you could probably split this part out since
> the change to how we set the SPTE and how we handle that change are
> somewhat independent. I like the switch to atomic64_fetch_and though.
> No idea if it's faster, but I would believe it could be.

The changes are actually dependent. Using the atomic-AND makes it
impossible for KVM to clear a volatile bit that it wasn't intending to
clear, and that is what enables simplifying the SPTE change
propagation.

Instead I would split out the opportunistic cleanup of
@record_dirty_log to a separate patch, since that's dead-code cleanup
and refactoring.
