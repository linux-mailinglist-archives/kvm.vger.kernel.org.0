Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0227C501CE1
	for <lists+kvm@lfdr.de>; Thu, 14 Apr 2022 22:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243082AbiDNUpY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Apr 2022 16:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233212AbiDNUpX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Apr 2022 16:45:23 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E185EA346
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 13:42:58 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-2ebd70a4cf5so67755947b3.3
        for <kvm@vger.kernel.org>; Thu, 14 Apr 2022 13:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dREBqtBx8O5QR+Pd7hDSqACoDdTFl9gK2foQuTXNKPo=;
        b=aJ8VKjSLpVxtUvvFplEY1E1h4pQm0J/X9OFxEr3a5fUMNvl2xFRjVKd2bgUe1Yqwhi
         9ZDZAfpuvwtD7gTM3bqx6hFqRKRrshNan07yT/uGf6h2zawC8TEDdj+YNXtfTFVRnSrO
         fF1hCREwk/RfhF3gSoUvkPprTLItNSNdKNWE+5MRifnQbvnfWN2JJePECqkOoIQK5r5P
         SaeD139fBOlqqSVzbNC6w9M5/QSCPuKKa76Pj561h+jEVv4OrfWZ6n4Y4cV7kcy82ZtW
         S0EqnJ7UexKveT0gKmIs8qk2v3sQ1URbVPAcHh3tsuiVyGXRxJZGdgb0B07UP/6cWjza
         jjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dREBqtBx8O5QR+Pd7hDSqACoDdTFl9gK2foQuTXNKPo=;
        b=pUO7bY92UrRu5Wql19zNC/oIKIdliim0Q5O1RL98dnOroTbPGopDH6YlQTGvGfqYdT
         JCvSHVBCiCFDpHgifIYyMIZDNkb5TRLzQ+dX27EqNO09gmMQkabN5p1Nm7Qy3SIU2Dh2
         NmsEu7J4+v5TlYJTYgzkdAucygesz2k0Bnxe4iCEYPCHLxnN9SqS3rNF/1H84bJxk7E9
         IS3H+L2DZSXp66wDw5UJkF5LN1RJ0EazeLlaolEf9jo8o0XwEAuph+5pqUf2sRBVhbxx
         tVoiNuOuFzz+k5m8z0fE2QuEFKZdHdtLTsXiLqqtyCbjaO4o6XiPanvSy0Xd02wV8ySE
         G3iQ==
X-Gm-Message-State: AOAM532EpPL3RHIFvnHfz8+BOr7N27eMGNizH6+tPX8WS/wQrREpFkkN
        wVdn8yiix4LJN0NALsLTFsdIrvD0kxgyhG/QmMVkhw==
X-Google-Smtp-Source: ABdhPJwrmU4mhkFfzKo6+wQaGLKnpzzi+vz9NN1S2XBWIxVLWnM7wOe5gjraarshHAe0t2kBeldQSUsepdmY8SXpRS4=
X-Received: by 2002:a0d:f746:0:b0:2eb:4227:5191 with SMTP id
 h67-20020a0df746000000b002eb42275191mr3563285ywf.370.1649968977488; Thu, 14
 Apr 2022 13:42:57 -0700 (PDT)
MIME-Version: 1.0
References: <20220414183127.4080873-1-romanton@google.com> <Ylh3HNlcJd8+P+em@google.com>
In-Reply-To: <Ylh3HNlcJd8+P+em@google.com>
From:   Anton Romanov <romanton@google.com>
Date:   Thu, 14 Apr 2022 13:42:46 -0700
Message-ID: <CAHFSQMhwsMEOFeMuMrvvveeN=skqA-DLM_r3EqU+dei-jXUkUA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Use current rather than snapshotted TSC
 frequency if it is constant
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
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

On Thu, Apr 14, 2022 at 12:33 PM Sean Christopherson <seanjc@google.com> wrote:
> On Thu, Apr 14, 2022, Anton Romanov wrote:
> >  /* Called within read_seqcount_begin/retry for kvm->pvclock_sc.  */
> >  static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
> >  {
> > @@ -2917,7 +2930,7 @@ static void __get_kvmclock(struct kvm *kvm, struct kvm_clock_data *data)
> >       get_cpu();
> >
> >       data->flags = 0;
> > -     if (ka->use_master_clock && __this_cpu_read(cpu_tsc_khz)) {
> > +     if (ka->use_master_clock && get_cpu_tsc_khz()) {
>
> It might make sense to open code this to make it more obvious why the "else" path
> exists.  That'd also eliminate a condition branch on CPUs with a constant TSC,
> though I don't know if we care that much about the performance here.
>
>         if (ka->use_master_clock &&
>             (static_cpu_has(X86_FEATURE_CONSTANT_TSC) || __this_cpu_read(cpu_tsc_khz)))
>
> And/or add a comment about cpu_tsc_khz being zero when the CPU is being offlined?

It looks like cpu_tsc_khz being zero is used as an indicator of CPU
being unplugged here.
I don't think your proposed change is right in this case either.
How about we still keep tsc_khz_changed untouched as well as this line?
Potentially adding here a comment that on this line we only read it to
see if CPU is not being unplugged yet
