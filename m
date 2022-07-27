Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CEB582837
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 16:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233186AbiG0OHX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 10:07:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbiG0OHV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 10:07:21 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0E20E039
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 07:07:19 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id p10so19763311lfd.9
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 07:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pbXRFwb+6mnOqb4qko6w4MUz1iH8dRLuiEYG/yozVuU=;
        b=poGVkIjHOsIvKU5OvFt21FuMAjEooxE4gTH04sm0jJ7bDQ6SCGqgdCc2jOwDEAaU9W
         08Mq7crS4yYQkJlGle+naSbCagOYjrJtZu7TtqnAxJgtkkV8eEoithy3pgZZ9rVLkJAf
         uAA3uk2OfGbt0OKGthKgFxuMl+om4hR0ZqeO9r+v64FAGVfQSRxZMWQz3EtOvM8nAT7u
         ZaRCLIzrTXbexhh9PTF1eGzlsLvx8ddl6TrySxOJbWcmW6KQ9aUwgs9uvesIx5KAxJKh
         9okHSFD+OyFvIaI6iAnbUaDDhXJ0pcGcSyP+CiWaUMRFAAe+vk2V/6i4NOUWF5/AetyH
         vqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pbXRFwb+6mnOqb4qko6w4MUz1iH8dRLuiEYG/yozVuU=;
        b=7ad79GMiN18ElhEnzrZYVo6XinIADT7dfwYcqT3rWl8S8b57UexBNW4zW+0/+85E2d
         w3zvl0+j0UwmEpoejJXbbGLJjRqhIenGuGDlsoCtzmloRui2k+EUDMM+LLQdLrS0b0lh
         +Das7mcbhWApmwGNRvhVhEqR4nYw02772nLMsQoDF8hZOdt5SAMzpdd/OMMJa8uM9pvb
         AMfTzL8M4iEPh0o5WXRmaoaPwHM3d4Mkh+vsIzBlx13Agx65j2MVQfLiLpKHpAlgai+l
         oekBg/MN0i/2LmvLq7UVvZYlrSjm8WsL2b0QXJHIvyZTCeetqja5b6vaZtIz4ryYflLN
         u7zw==
X-Gm-Message-State: AJIora/rxRBc5evjxwJeSfbtLYdTyAIjg0s/I98EdBv7GXvT+eOqBi+F
        wURSPtrrl9naswqdm/1b+WNHIBcu0UOrC5NGCsXghA==
X-Google-Smtp-Source: AGRyM1vX862+bxpk11BK++4y3iu+NiKqfuius4fds95B9RW+xG19y7YW29rzvG0sKDYPMzmjHJ9aFOE14Npknvr91c4=
X-Received: by 2002:a05:6512:21a7:b0:48a:a06e:1d21 with SMTP id
 c7-20020a05651221a700b0048aa06e1d21mr3099565lft.494.1658930837575; Wed, 27
 Jul 2022 07:07:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220715192956.1873315-1-pgonda@google.com> <20220715192956.1873315-10-pgonda@google.com>
 <20220719154330.wnwnu23gagcya3o7@kamzik> <CAMkAt6rFO6J5heuwocmvb_wstOOwsf9WooXu9iEUOvK0wEDAhw@mail.gmail.com>
 <20220727135603.ld5torjrn4gatjb4@kamzik>
In-Reply-To: <20220727135603.ld5torjrn4gatjb4@kamzik>
From:   Peter Gonda <pgonda@google.com>
Date:   Wed, 27 Jul 2022 08:07:05 -0600
Message-ID: <CAMkAt6r9wrDZTxzGJMKV7VQBgjwdM5YouDw-=Ntv1xo+RCoxNw@mail.gmail.com>
Subject: Re: [RFC V1 08/10] KVM: selftests: Make ucall work with encrypted guests
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marc Orr <marcorr@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Michael Roth <michael.roth@amd.com>,
        "Lendacky, Thomas" <thomas.lendacky@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Mingwei Zhang <mizhang@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
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

On Wed, Jul 27, 2022 at 7:56 AM Andrew Jones <andrew.jones@linux.dev> wrote:
>
> On Wed, Jul 27, 2022 at 07:38:29AM -0600, Peter Gonda wrote:
> > On Tue, Jul 19, 2022 at 9:43 AM Andrew Jones <andrew.jones@linux.dev> wrote:
> > > I'm not a big fan of mixing the concept of encrypted guests into ucalls. I
> > > think we should have two types of ucalls, those have a uc pool in memory
> > > shared with the host and those that don't. Encrypted guests pick the pool
> > > version.
> >
> > Sean suggested this version where encrypted guests and normal guests
> > used the same ucall macros/functions. I am fine with adding a second
> > interface for encrypted VM ucall, do you think macros like
> > ENCRYPTED_GUEST_SYNC, ENCRYPTED_GUEST_ASSERT, and
> > get_encrypted_ucall() ?
> >
>
> It's fine to add new functionality to ucall in order to keep the
> interfaces the same, except for initializing with some sort of indication
> that the "uc pool" version is needed. I just don't like all the references
> to encrypted guests inside ucall. ucall should implement uc pools without
> the current motivation for uc pools creeping into its implementation.

Ah that makes sense. So maybe instead of checking for 'if
(vm->memcrypt.enabled)' I should just add a new field in kvm_vm to
select for use of the uc pool? Something like kvm_vm.enable_uc_pool?

Thanks Drew!
