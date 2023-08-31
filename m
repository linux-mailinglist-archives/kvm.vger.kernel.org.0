Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138A778F1D6
	for <lists+kvm@lfdr.de>; Thu, 31 Aug 2023 19:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346916AbjHaRYE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Aug 2023 13:24:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238658AbjHaRYE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Aug 2023 13:24:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1BB2E57
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693502584;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rEsmay9dgABHBR9HT3CdLYltgWp0I5dORZyQ5/U0Avo=;
        b=RKjCcdqldrVccyK3EaSFiCFXlfjC0QFEMDl/mmQIkjlbXouOnbCdLnph9BzeLVXe1c+MHi
        YWV/X9UgaFxIVaXWjlng22zJ+4Rc/ZdFuxSSXmI0uLStPM5k1oKW2UxDZTFoWbeY8iBoCg
        dpmJt8Mx3BDYiOqcvwUgEUudLolZM6w=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-bn2v7M7aMQWT3GFOo9dCTA-1; Thu, 31 Aug 2023 13:23:02 -0400
X-MC-Unique: bn2v7M7aMQWT3GFOo9dCTA-1
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-44d4eafd566so445924137.1
        for <kvm@vger.kernel.org>; Thu, 31 Aug 2023 10:23:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693502581; x=1694107381;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rEsmay9dgABHBR9HT3CdLYltgWp0I5dORZyQ5/U0Avo=;
        b=PUCYwMbkWMC4P9UScvZIrs3deH7JP4xrEtfDrymfjQURXJ3zixk0xOiVOPAf03F1/o
         2TsqDMNTiY+E2X8HX075Vaj6QsY3s6v1iAS6qOzWxvM0w9PEj2v05Y7N3XdicCYXauYd
         yeKXdYjdVpNonGcyIXpFWSR1O9weEKlfV8TLlYYgP/IMjSRITCJr8W82LxT50TWDyn7M
         FLZtSgrSGmWpL9VzuN5yQeZI0LT+G5h/cwOsZuE3HF0k7DH4wYiccc6MvGPU2UO7COw5
         w2lYHxSS+/JkArtp1ZxKdLdKv37+bCP3CplBZ60WcRmpgp2qvzCD+isqms1XfIYkOYhT
         5WcA==
X-Gm-Message-State: AOJu0YyhVpR5UYi6vBDGJcdBOinp66J0BwiETF/KXV8RlHlFPQ+Z9VV5
        bc/dKBpvRPJQ7jNKvVzFxdPYOA7JAtNoUzqZ8FxNCryUYVWXjLMdjdbZ4N2hVTPm8ejM7VLNAqd
        w2y1JQMcpitiRpNy1nrN/iB4kimyy
X-Received: by 2002:a05:6102:2859:b0:44e:9f69:fa52 with SMTP id az25-20020a056102285900b0044e9f69fa52mr193363vsb.22.1693502581424;
        Thu, 31 Aug 2023 10:23:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESPNx6zoSzzRswH3gh65uInXbLtYRyP+R9aYRpIgmSsEMGvazhzz0RNlop91a0LsBX6L+kSr90tGcEDFiZvdw=
X-Received: by 2002:a05:6102:2859:b0:44e:9f69:fa52 with SMTP id
 az25-20020a056102285900b0044e9f69fa52mr193336vsb.22.1693502581010; Thu, 31
 Aug 2023 10:23:01 -0700 (PDT)
MIME-Version: 1.0
References: <20230829120843.66637-1-frankja@linux.ibm.com>
In-Reply-To: <20230829120843.66637-1-frankja@linux.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Thu, 31 Aug 2023 19:22:49 +0200
Message-ID: <CABgObfZQjzJkYPiR8Gm80TnMq9=HojvyCkn7znY9-U6iLo5Baw@mail.gmail.com>
Subject: Re: [GIT PULL v2 00/10] KVM: s390: Changes for 6.6
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com,
        cohuck@redhat.com, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, mihajlov@linux.ibm.com,
        seiden@linux.ibm.com, akrowiak@linux.ibm.com, seanjc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 29, 2023 at 2:10=E2=80=AFPM Janosch Frank <frankja@linux.ibm.co=
m> wrote:
>
> Dear Paolo,
>
> let's try this again.
> Please pull the following changes for 6.6.
>
> Please note that Heiko and I both merged Heiko's vfio-ap feature
> branch. Linus has pulled Heiko's next branch already (e5b7ca09e9aa).
>
> I've also merged tags/kvm-x86-selftests-immutable-6.6 since we
> introduce a new selftest with the guest debug fixes. I had to fixup
> the selftest commit since a function name changed.

Pulled, thanks!

> In the long run we're considering putting vfio-ap patches into their
> own repository but for 6.6 we didn't find the time to speak with all
> affected maintainers.

If needed you can also use a separate branch that you branch both into
Heiko's s390/next branch and your kvm/next branch

Paolo

> Changes:
> - PV crypto passthrough enablement (Tony, Steffen, Viktor, Janosch)
>   Allows a PV guest to use crypto cards. Card access is governed by
>   the firmware and once a crypto queue is "bound" to a PV VM every
>   other entity (PV or not) looses access until it is not bound
>   anymore. Enablement is done via flags when creating the PV VM.
>
> - Guest debug fixes + test (Ilya)
>
> The following changes since commit ede6d0b2031e045f0a0e4515e4567828d87fd3=
ef:
>
>   Merge tag 'kvm-x86-selftests-immutable-6.6' into next (2023-08-28 09:23=
:36 +0000)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-6.6-1
>
> for you to fetch changes up to 899e2206f46aece42d8194c350bc1de71344dbc7:
>
>   KVM: s390: pv: Allow AP-instructions for pv-guests (2023-08-28 09:27:56=
 +0000)
>
> ----------------------------------------------------------------
> - PV crypto passthrough enablement (Tony, Steffen, Viktor, Janosch)
>   Allows a PV guest to use crypto cards. Card access is governed by
>   the firmware and once a crypto queue is "bound" to a PV VM every
>   other entity (PV or not) looses access until it is not bound
>   anymore. Enablement is done via flags when creating the PV VM.
>
> - Guest debug fixes (Ilya)
> ----------------------------------------------------------------
>
> Ilya Leoshkevich (6):
>   KVM: s390: interrupt: Fix single-stepping into interrupt handlers
>   KVM: s390: interrupt: Fix single-stepping into program interrupt
>     handlers
>   KVM: s390: interrupt: Fix single-stepping kernel-emulated instructions
>   KVM: s390: interrupt: Fix single-stepping userspace-emulated
>     instructions
>   KVM: s390: interrupt: Fix single-stepping keyless mode exits
>   KVM: s390: selftests: Add selftest for single-stepping
>
> Steffen Eiden (3):
>   s390/uv: UV feature check utility
>   KVM: s390: Add UV feature negotiation
>   KVM: s390: pv: Allow AP-instructions for pv-guests
>
> Viktor Mihajlovski (1):
>   KVM: s390: pv: relax WARN_ONCE condition for destroy fast
>
> --
> 2.41.0
>

