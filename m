Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7B4306FEC
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 08:47:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232132AbhA1HmO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 02:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232070AbhA1HmC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 02:42:02 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2CFEC061573;
        Wed, 27 Jan 2021 23:41:21 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id x71so5084247oia.9;
        Wed, 27 Jan 2021 23:41:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=s4OuxxgWe2Ahx+yCxHgtlR+K9khejRjBXvMJQGWTjFA=;
        b=ZW69HnstykrV7cO0QdoErRAX0lOqZLQKPJ8VTZjabYJgySEH72vmx1TPUPIE4Df05B
         sfXrPqum1pVjfHtFOA5IkQhSIOJbzxKdAmL/5zezZealW/crspNjMafo07/sOdX+taF9
         de/5hI9yWD8/+kTxgNaMC7mHMLQmujXzE4JZzCHVSBx/IA/1HbgkScVJCkpc2QbcGc8c
         xPoL8r/C29jzxxmHVvY7qsmDBDMf0aHabAeXqkkcnmg1cXKwgRn068pX3ykBddawAo+9
         Kg0RzP9rCpW+r/g6Yu+0idSRIpYEJUNq8CD/OA8dkuYkeatVgGiPfgeIaVtiIxNn965L
         rIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=s4OuxxgWe2Ahx+yCxHgtlR+K9khejRjBXvMJQGWTjFA=;
        b=V4srMVr0s+eoTTw0tEuQUSH7OB7rsqumdGAR+E9vYlT/Nqb0rJS/gqX8VGTTREXjxH
         6v5gzV1sdiibf+m1gTJsADHQGYuZMzobq7IW13VK4LslHw2be4QDepy0jxzSqoQ5Kud0
         EIHegI9sgY7HeFSlGA0IyRkMF8Bc/UJkUIyXvvDq7nKHO8zdaCbZykAbckvohcyVjvh7
         68I90nS77RxrriFFve528l4o8JlAwuJAG2gA1INEJTtGfyseWb/Ox41DjR4pD86epxBd
         j0hdAvxe9KlKMgMxFAA7VgV7309YizflROY7rcmR6L2Zdnz+t+nx2ApTYk0R8MHnTQUl
         pNeg==
X-Gm-Message-State: AOAM531JAaWFlwP5noXqFbSM1TgvnJ7B+JkdpkXC9CmD/shZwYm8Y5xU
        3f80IOcvQhtOP9+QLJAJCyf3aweUrsIOQLPvpCQ=
X-Google-Smtp-Source: ABdhPJw/eiXe4gLSfUUZ31T65hzmkeEcYKgxYTY70SJ4q1VB9Y3ZQ7dcRSvDe2HIclNoi4wiSxkA+Iony1yi4CVxcx0=
X-Received: by 2002:aca:f510:: with SMTP id t16mr5936180oih.141.1611819681371;
 Wed, 27 Jan 2021 23:41:21 -0800 (PST)
MIME-Version: 1.0
References: <1610960877-3110-1-git-send-email-wanpengli@tencent.com>
 <CANRm+Cx65UHSJA+S4qRR1wdZ=dhyM=U=KwZnbNUSN4XdM1nyQA@mail.gmail.com>
 <146d2a3f-88db-ff80-29d6-de2b22efdf61@redhat.com> <CANRm+CwcrrTC8w5h3GrszOcu0H2vtcXNi0GD1iXc6O4-x_Ms0A@mail.gmail.com>
In-Reply-To: <CANRm+CwcrrTC8w5h3GrszOcu0H2vtcXNi0GD1iXc6O4-x_Ms0A@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 28 Jan 2021 15:41:09 +0800
Message-ID: <CANRm+Cw-DkVHU-q5cq1q6Md587Qu2n3utwNPx8gMJPCUw51zrA@mail.gmail.com>
Subject: Re: [PATCH v2] KVM: kvmclock: Fix vCPUs > 64 can't be online/hotpluged
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Jan 2021 at 08:28, Wanpeng Li <kernellwp@gmail.com> wrote:
>
> On Wed, 27 Jan 2021 at 01:26, Paolo Bonzini <pbonzini@redhat.com> wrote:
> >
> > On 26/01/21 02:28, Wanpeng Li wrote:
> > > ping=EF=BC=8C
> > > On Mon, 18 Jan 2021 at 17:08, Wanpeng Li <kernellwp@gmail.com> wrote:
> > >>
> > >> From: Wanpeng Li <wanpengli@tencent.com>
> > >>
> > >> The per-cpu vsyscall pvclock data pointer assigns either an element =
of the
> > >> static array hv_clock_boot (#vCPU <=3D 64) or dynamically allocated =
memory
> > >> hvclock_mem (vCPU > 64), the dynamically memory will not be allocate=
d if
> > >> kvmclock vsyscall is disabled, this can result in cpu hotpluged fail=
s in
> > >> kvmclock_setup_percpu() which returns -ENOMEM. This patch fixes it b=
y not
> > >> assigning vsyscall pvclock data pointer if kvmclock vdso_clock_mode =
is not
> > >> VDSO_CLOCKMODE_PVCLOCK.
> >
> > I am sorry, I still cannot figure out this patch.
> >
> > Is hotplug still broken if kvm vsyscall is enabled?
>
> Just when kvm vsyscall is disabled. :)
>
> # lscpu
> Architecture:           x86_64
> CPU op-mode(s):    32-bit, 64-bit
> Byte Order:             Little Endian
> CPU(s):                   88
> On-line CPU(s) list:   0-63
> Off-line CPU(s) list:  64-87
>
> # cat /proc/cmdline
> BOOT_IMAGE=3D/vmlinuz-5.10.0-rc3-tlinux2-0050+ root=3D/dev/mapper/cl-root
> ro rd.lvm.lv=3Dcl/root rhgb quiet console=3DttyS0 LANG=3Den_US
> .UTF-8 no-kvmclock-vsyscall
>
> # echo 1 > /sys/devices/system/cpu/cpu76/online
> -bash: echo: write error: Cannot allocate memory

The original bug report is here.
https://bugzilla.kernel.org/show_bug.cgi?id=3D210213

    Wanpeng
