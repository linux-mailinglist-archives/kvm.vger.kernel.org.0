Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0603054AA
	for <lists+kvm@lfdr.de>; Wed, 27 Jan 2021 08:30:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233970AbhA0HaO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jan 2021 02:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S317639AbhA0A3S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jan 2021 19:29:18 -0500
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B551C061574;
        Tue, 26 Jan 2021 16:28:38 -0800 (PST)
Received: by mail-oi1-x230.google.com with SMTP id w124so352254oia.6;
        Tue, 26 Jan 2021 16:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zscmxdxUmZNhCcEeeUyyEVgY+dftdWRoYunOxjTwBkk=;
        b=URa/yh8rZsrxoHpbT+6ZvVjD8ZO+IgOQrFKGi1J2CEVQhaevRF4FKOStCtTzjwEdxU
         iQE8PUoU2OiJRYYwb0/MqbA3/D8f71WWNz9VZGl19lqStn3YAeeeZcmVQJhlWnTnVanu
         gjdbNR4ykYvx9wFQfOddJRC/mszQA5xRJjq46u/PlNR6wbtCd08QJs3di58nP69eK/B/
         2vD/vSJ9ieBqmQXjQJaDDLy4NE603+ir132b83X87idf7plZuEydC5hHXQps786W45EV
         Ldx6dnerhHr/FXZJmrYR0fyfQYr4pCArXCnSlcUkfW+ES1jgIHVpsS1gQ4VFhEIpHkbb
         /SJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zscmxdxUmZNhCcEeeUyyEVgY+dftdWRoYunOxjTwBkk=;
        b=PXUHua+UGzUYeJXF+8ELJiYchhWWpv/SLxpHv6eXJrKpukrMxmWzq1+lNRBx32gXoa
         a1TEe1OuHShXlS8z17qTlO2N3syIOjog3rA+iEd9h3TQOLvLfsy9xm8ErSwYwGyUooFV
         23BOnwcC/NZH975fu85I7yzH++LJa0B3Hop/uR+zBFA30yV2qiq0YtryPbD7hDlzo6p9
         RtziFg+gnz/4+sa6+63JN6F9XnB5GCcz+GmG5v3FBmxhh3Y7PMHrgk7xow9Qlhy045oT
         A8trW+ch2rkoFsEVD5vQjO4ihi8Pe0hylk9/JRUPkT7Z1gQ6awgP3O+7R/nw+Vy1ity2
         guxQ==
X-Gm-Message-State: AOAM531X4T8n+b7SoIG5KpbxcqMh+KzGOSDoVDhtd77v1NbeJTbTXqZv
        //n6yOacABqIL6SiFHuRm8dEaGSv7/A+GTAJ/zs=
X-Google-Smtp-Source: ABdhPJzj0DTywQODpuzMNp2wzQnZjtLEjYhw7rt5+RyuF5Rc1I9K67W6kL3ALfgQY42oPNAceRY6R6ZD4c3TP1IZJoc=
X-Received: by 2002:aca:d98a:: with SMTP id q132mr1466849oig.33.1611707317595;
 Tue, 26 Jan 2021 16:28:37 -0800 (PST)
MIME-Version: 1.0
References: <1610960877-3110-1-git-send-email-wanpengli@tencent.com>
 <CANRm+Cx65UHSJA+S4qRR1wdZ=dhyM=U=KwZnbNUSN4XdM1nyQA@mail.gmail.com> <146d2a3f-88db-ff80-29d6-de2b22efdf61@redhat.com>
In-Reply-To: <146d2a3f-88db-ff80-29d6-de2b22efdf61@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 27 Jan 2021 08:28:26 +0800
Message-ID: <CANRm+CwcrrTC8w5h3GrszOcu0H2vtcXNi0GD1iXc6O4-x_Ms0A@mail.gmail.com>
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

On Wed, 27 Jan 2021 at 01:26, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 26/01/21 02:28, Wanpeng Li wrote:
> > ping=EF=BC=8C
> > On Mon, 18 Jan 2021 at 17:08, Wanpeng Li <kernellwp@gmail.com> wrote:
> >>
> >> From: Wanpeng Li <wanpengli@tencent.com>
> >>
> >> The per-cpu vsyscall pvclock data pointer assigns either an element of=
 the
> >> static array hv_clock_boot (#vCPU <=3D 64) or dynamically allocated me=
mory
> >> hvclock_mem (vCPU > 64), the dynamically memory will not be allocated =
if
> >> kvmclock vsyscall is disabled, this can result in cpu hotpluged fails =
in
> >> kvmclock_setup_percpu() which returns -ENOMEM. This patch fixes it by =
not
> >> assigning vsyscall pvclock data pointer if kvmclock vdso_clock_mode is=
 not
> >> VDSO_CLOCKMODE_PVCLOCK.
>
> I am sorry, I still cannot figure out this patch.
>
> Is hotplug still broken if kvm vsyscall is enabled?

Just when kvm vsyscall is disabled. :)

# lscpu
Architecture:           x86_64
CPU op-mode(s):    32-bit, 64-bit
Byte Order:             Little Endian
CPU(s):                   88
On-line CPU(s) list:   0-63
Off-line CPU(s) list:  64-87

# cat /proc/cmdline
BOOT_IMAGE=3D/vmlinuz-5.10.0-rc3-tlinux2-0050+ root=3D/dev/mapper/cl-root
ro rd.lvm.lv=3Dcl/root rhgb quiet console=3DttyS0 LANG=3Den_US
.UTF-8 no-kvmclock-vsyscall

# echo 1 > /sys/devices/system/cpu/cpu76/online
-bash: echo: write error: Cannot allocate memory

    Wanpeng
