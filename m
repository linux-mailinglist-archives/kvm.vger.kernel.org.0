Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DF93AE22
	for <lists+kvm@lfdr.de>; Mon, 10 Jun 2019 06:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728212AbfFJEbs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Jun 2019 00:31:48 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:32826 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728092AbfFJEbs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Jun 2019 00:31:48 -0400
Received: by mail-ot1-f65.google.com with SMTP id p4so3882794oti.0;
        Sun, 09 Jun 2019 21:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zqVRtfIXSfL2glUOZ/rPqcfEx5EYpKNLA4Zoyt8Pnhg=;
        b=ue19iE+NTrIsYbDZPeAukExr8wKcPe3hVLkZ8so/3GUG6HTktivL9uGMTedOf1PCI0
         fvcY9kOdGV6WXSPD+IAqLBo2582Zue8weJb5nZLIbJOkfvTsQSQ2pNXOiTMhstQorQhJ
         uKdrZRKAUtHShrEd4QqNOfs0dZ6yYZFh4kRZeKmw2bd518fzFUBrSXwODkyMo0KDcSm0
         kqm5CuQA2zKTcKhqsPZd2oihR2U7gvIpVoLDfwZftgPym/QUKBZWxtsuQ7Y4zoMvScWD
         +acz2Crjwitx205NOxJEQajagGT0hpESOAamcm2YwSqJyiNBW5iZ2NWbHEeh+HDV7Eg7
         jMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zqVRtfIXSfL2glUOZ/rPqcfEx5EYpKNLA4Zoyt8Pnhg=;
        b=AZwDpDdiTkaqUDFBXEpIzoMtBbhQNJeAz3zYxQEpCnexnMhDOyhoirMQGpzMZQlQkd
         7vfncgvOZ9hLzcBDn3Dt202ZggB8LrlPQ6QjhjSBmyRbBPzo5Y2f8Sq3LSYEb37ycxYY
         RX8DlRmo7PJ0zLltYWt0MSBi5HJdTd9GJ1ovbmc94lL+2UcHry4OnOA+gj39Yl5GcQsC
         A2lbuOL0/bRnm6V3Vmc8tKkoNLsmdp0epXSXIIW7EvIz5gE/urcKeETsk2Tv0uKXL2tV
         +JjduViIyXaJnzqYEEepcaWGyG9TjuQeZVfmCqjC38G/MRi+xeaYYpVVi/AY0+lKdmzN
         bpDw==
X-Gm-Message-State: APjAAAX8wwdYfTchQEfAjBwazL0OnQ0vSF1Us+UTWE1Pr/EslvhMI18z
        4utZ/2zYbgGHqN/iVlZl2qlNgEkj9cgYGgrrEAFG66P0
X-Google-Smtp-Source: APXvYqz4AmIrXv9HXM51uFtgYFsZXZOkVbKmfDs32qPNJWsP58722hw+glnxhaRn/TS6A4hgm62/k2MbjKBbd/DYP8U=
X-Received: by 2002:a9d:6312:: with SMTP id q18mr27167731otk.45.1560141107273;
 Sun, 09 Jun 2019 21:31:47 -0700 (PDT)
MIME-Version: 1.0
References: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
In-Reply-To: <1559799086-13912-1-git-send-email-wanpengli@tencent.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Mon, 10 Jun 2019 12:32:33 +0800
Message-ID: <CANRm+CwUyX_7FafiWPCr4JgFetfOkttw2P0xS6yjOzKs-X3f9A@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] KVM: LAPIC: Implement Exitless Timer
To:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 6 Jun 2019 at 13:31, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> Dedicated instances are currently disturbed by unnecessary jitter due
> to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
> There is no hardware virtual timer on Intel for guest like ARM. Both
> programming timer in guest and the emulated timer fires incur vmexits.
> This patchset tries to avoid vmexit which is incurred by the emulated
> timer fires in dedicated instance scenario.
>
> When nohz_full is enabled in dedicated instances scenario, the unpinned
> timer will be moved to the nearest busy housekeepers after commit 444969223c8
> ("sched/nohz: Fix affine unpinned timers mess"). However, KVM always makes
> lapic timer pinned to the pCPU which vCPU residents, the reason is explained
> by commit 61abdbe0 (kvm: x86: make lapic hrtimer pinned). Actually, these
> emulated timers can be offload to the housekeeping cpus since APICv
> is really common in recent years. The guest timer interrupt is injected by
> posted-interrupt which is delivered by housekeeping cpu once the emulated
> timer fires.
>
> The host admin should fine tuned, e.g. dedicated instances scenario w/
> nohz_full cover the pCPUs which vCPUs resident, several pCPUs surplus
> for housekeeping, disable mwait/hlt/pause vmexits to occupy the pCPUs,
> fortunately preemption timer is disabled after mwait is exposed to
> guest which makes emulated timer offload can be possible.
> 3%~5% redis performance benefit can be observed on Skylake server.

w/o patchset:

                             VM-EXIT    Samples  Samples%     Time%
Min Time    Max Time         Avg time

  EXTERNAL_INTERRUPT      42916    49.43%    39.30%      0.47us
106.09us      0.71us ( +-   1.09% )

w/ patchset:

                             VM-EXIT    Samples  Samples%     Time%
Min Time    Max Time         Avg time

  EXTERNAL_INTERRUPT       6871     9.29%     2.96%      0.44us
57.88us      0.72us ( +-   4.02% )

Regards,
Wanpeng Li
