Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADF76A049F
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 10:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbjBWJTD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 04:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBWJTC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 04:19:02 -0500
Received: from mail-vs1-xe33.google.com (mail-vs1-xe33.google.com [IPv6:2607:f8b0:4864:20::e33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5937810266
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 01:19:01 -0800 (PST)
Received: by mail-vs1-xe33.google.com with SMTP id d20so6547633vsf.11
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 01:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1677143940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jJG07+p6MKBGS+KUMirk1JxFZsTo6RYQStGyBrR/Eec=;
        b=VTUwGjwxIdIk+8DQo1F08zqK342XkE0IyISiKy445xlO4gn5BcvtIN8ObhUibjnPdh
         +8QCDzAGRnNMibyH/sRteQ9ut7OJkOEsJ8kPkEGYc9OBnih7SfNQpowLXMcwoFUvs1K0
         6ELBLUgwh0HmEnFhlM7FrYYPj3mzKwUNEEOe1h31zEj9FFkZtgtvcDAl/ADLU4zCLTaC
         CZOb1xxY9uT50WPXBxvhwk3EuLggirXkkdcMLU8rlZo6fi998cB25h17CFWSnwQ6kgUi
         scHNy8oFEGRxc67FjqT0UL/HkF89zud1sd74gtEScsUHorUBPQzjefZ88i8TDYmSUg2T
         qgLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677143940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jJG07+p6MKBGS+KUMirk1JxFZsTo6RYQStGyBrR/Eec=;
        b=DdW9Z1ASmFRbWWRJSSiPUL+vnwfzn83bC6cJ5KFT96DYG8su1/WrInujw1yDInER7K
         AmSkeosRsu2AXSkvy/VQqv9d6dwTK7fRJQRXyGWMLYoJf3MAFNDJOFQHMTiAxLhoIC82
         KGoUS2kDehhpwQEZMKTZ+2PF8Y8npg+K+J/BpmOX/dP7o1JVwi2W+tLH075JQvc3nAnh
         otGiBeTpgmTycAL91pxtCeU4VmrSvjeBOD9gzT3pe1GjEfRor4fzL6La75vVVsFiBB7y
         rfU5qnBcGspVUa+GfzpVnTzDInJo6tc99xb1kacEmDx89AjsNhp6drRBklJtjA3YVeOj
         QOjg==
X-Gm-Message-State: AO0yUKWwPo/yfF0saoOXTAsgkB912XGpuqAEMZqjxvQi3WIjtYLMbIOO
        4yfDv51QdvFrkkk1znb6G9aTtnDZzG/8x/uEXr1lIg==
X-Google-Smtp-Source: AK7set+fL9K7BQue1MVWJ997o1Uw4HQUESRxfTJt3q61lF9gsBJ2K4+iBi+Hrae4wfMfj+Ek0HWi8Lg5PF2Mvbw7Sx4=
X-Received: by 2002:a1f:aa41:0:b0:412:948:73ff with SMTP id
 t62-20020a1faa41000000b00412094873ffmr251161vke.13.1677143940266; Thu, 23 Feb
 2023 01:19:00 -0800 (PST)
MIME-Version: 1.0
References: <20230217041230.2417228-1-yuzhao@google.com> <20230217041230.2417228-4-yuzhao@google.com>
 <CAOUHufYSx-edDVCZSauOzwOJG6Av0++0TFT4ko8qWq7vLi_mjw@mail.gmail.com>
 <86lekwy8d7.wl-maz@kernel.org> <CAOUHufbbs2gG+DPvSOw_N_Kx7FWdZvpdJUvLzko-BDQ8vfd6Xg@mail.gmail.com>
 <86a614ycs3.wl-maz@kernel.org>
In-Reply-To: <86a614ycs3.wl-maz@kernel.org>
From:   Yu Zhao <yuzhao@google.com>
Date:   Thu, 23 Feb 2023 02:18:24 -0700
Message-ID: <CAOUHufYLmu7oowXZ5YmVJqgx5dHWdz-1eaqPiVzUq3RAY4e_6A@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 3/5] kvm/arm64: add kvm_arch_test_clear_young()
To:     Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Michael Larabel <michael@michaellarabel.com>,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        linux-mm@google.com, Andrew Morton <akpm@linux-foundation.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Thu, Feb 23, 2023 at 2:03=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 23 Feb 2023 03:58:47 +0000,
> Yu Zhao <yuzhao@google.com> wrote:
> >
> > On Fri, Feb 17, 2023 at 2:00=E2=80=AFAM Marc Zyngier <maz@kernel.org> w=
rote:
> > >
> > > On Fri, 17 Feb 2023 04:21:28 +0000,
> > > Yu Zhao <yuzhao@google.com> wrote:
> > > >
> > > > On Thu, Feb 16, 2023 at 9:12 PM Yu Zhao <yuzhao@google.com> wrote:
> > > > >
> > > > > This patch adds kvm_arch_test_clear_young() for the vast majority=
 of
> > > > > VMs that are not pKVM and run on hardware that sets the accessed =
bit
> > > > > in KVM page tables.
> > >
> > > I'm really interested in how you can back this statement. 90% of the
> > > HW I have access to is not FEAT_HWAFDB capable, either because it
> > > predates the feature or because the feature is too buggy to be useful=
.
> >
> > This is my expericen too -- most devices are pre v8.2.
>
> And yet you have no issue writing the above. Puzzling.

That's best to my knowledge. Mind enlightening me?

> > > Do you have numbers?
> >
> > Let's do a quick market survey by segment. The following only applies
> > to ARM CPUs:
> >
> > 1. Phones: none of the major Android phone vendors sell phones running
> > VMs; no other major Linux phone vendors.
>
> Maybe you should have a reality check and look at what your own
> employer is shipping.

Which model? I'll look it up and see how/how I missed it.

> > 2. Laptops: only a very limited number of Chromebooks run VMs, namely
> > ACRVM. No other major Linux laptop vendors.
>
> Again, your employer disagree.

What do you mean? Sorry, I'm a little surprised here... I do know *a
lot* about Chromebooks.

> > 3. Desktops: no major Linux desktop vendors.
>
> My desktop disagree (I send this from my arm64 desktop VM ).

A model number please?

> > 4. Embedded/IoT/Router: no major Linux vendors run VMs (Android Auto
> > can be a VM guest on QNX host).
>
> This email is brought to you via a router VM on an arm64 box.

More details?

> > 5. Cloud: this is where the vast majority VMs come from. Among the
> > vendors available to the general public, Ampere is the biggest player.
> > Here [1] is a list of its customers. The A-bit works well even on its
> > EVT products (Neoverse cores).
>
> Just the phone stuff dwarfs the number of cloud hosts.

Please point me to something that I can work on so that I wouldn't
sound so ignorant next time.
