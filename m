Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7520139AF17
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 02:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbhFDAgI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Jun 2021 20:36:08 -0400
Received: from mail-ot1-f53.google.com ([209.85.210.53]:43540 "EHLO
        mail-ot1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhFDAgH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Jun 2021 20:36:07 -0400
Received: by mail-ot1-f53.google.com with SMTP id i12-20020a05683033ecb02903346fa0f74dso7512167otu.10;
        Thu, 03 Jun 2021 17:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dM61mylJ53YidPBEu1MqfzVtHPvSltpQP4lAmiQnPxc=;
        b=Tlltf3pkZ2IWrWaATPbV6DEJsQBCoEP7CfKwGY8DnRl7EyaKdnzUUCArywEnpW6ZKk
         SeDhT6w1BGJQM3VLqWXInbqM9GIDCeturhx06Z8Zl70YF4aEUJYZp/GM7OzVPcbzb40i
         1TYeU4bNsVo5LeG77wcvJItrTPvYtyYTxqMw4V7fUdpTgVjFhnwbY4AlP6t7QUTaA7WO
         ++lWDevRC1UQIGd2azKxnkG6aopQDCPDflbUIt5YTaCyyjzUffIJtu2s2TTTIqYHtX32
         9d/YLBxfaOnvKenpXlo8kIlAhsZQtLrU5fvj60VptVjlTaifxSCecwcQbSfqaK9/Sh3W
         3lQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dM61mylJ53YidPBEu1MqfzVtHPvSltpQP4lAmiQnPxc=;
        b=HztWZqxw6Pktk0jq68i22uV8Qqu+zKF/pVu3UKIDEEaEsa1YLmorQjiv+4/94HNE6a
         72yNnLe+FOyRaLzwjg5R2kAeYtFjRxrZSjlohkiRG5iVVfAP7sjTmfTHsK15Q//ovxY7
         Thl8T7KEchfaRXUtx3zY8WiPhJeuVDlVpRR1aLfkRc9VgTuJ8j7nE88LCSFJWUMDAvWT
         9WwHZ+smQyic9Lv3bJzdC88ScUPFwVbQNqcv8q+9QXxubkxFVaCHdOfo/S6bxAqA8TE3
         1IEjUQZTiJaSM379EfG5JTd2K3kcxr6F1fsdxzmFdeSICW7rPZM69V3Oc5iZGulbosTx
         6yUg==
X-Gm-Message-State: AOAM531zkKp7hRB/eU+LropOZyM2GVjRGOnZYDX8TB7byqtcB909J1Jm
        N8fBJWcwXjBmdgMDAzDlvru2LZ1M0QnNIqS+Oew=
X-Google-Smtp-Source: ABdhPJzU2K1KK/iATaI/U+jAbe57W3R238nnzo1oIJRV+qlSVzUWqfRJ+XvgotjZUta3gF1uUmqZg5gk4lFVR2W+gFA=
X-Received: by 2002:a9d:4b0e:: with SMTP id q14mr1577750otf.254.1622766789119;
 Thu, 03 Jun 2021 17:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <1622710841-76604-1-git-send-email-wanpengli@tencent.com> <CALzav=e9pbkk0=Yz9s1b+53MEy7yuo_otoFM75fNeoJGCQjqCg@mail.gmail.com>
In-Reply-To: <CALzav=e9pbkk0=Yz9s1b+53MEy7yuo_otoFM75fNeoJGCQjqCg@mail.gmail.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Fri, 4 Jun 2021 08:32:57 +0800
Message-ID: <CANRm+CzNeGzJyisK659h1kdgcQQ+Y7OwW+tiXPnZ9gmiGB1qUA@mail.gmail.com>
Subject: Re: [PATCH 1/2] KVM: LAPIC: write 0 to TMICT should also cancel
 vmx-preemption timer
To:     David Matlack <dmatlack@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Jun 2021 at 07:02, David Matlack <dmatlack@google.com> wrote:
>
> On Thu, Jun 3, 2021 at 2:04 AM Wanpeng Li <kernellwp@gmail.com> wrote:
> >
> > From: Wanpeng Li <wanpengli@tencent.com>
> >
> > According to the SDM 10.5.4.1:
> >
> >   A write of 0 to the initial-count register effectively stops the local
> >   APIC timer, in both one-shot and periodic mode.
>
> If KVM is not correctly emulating this behavior then could you also
> add a kvm-unit-test to test for the correct behavior?

A simple test here, the test will hang after the patch since it will
not receive the spurious interrupt any more.

diff --git a/x86/apic.c b/x86/apic.c
index a7681fe..947d018 100644
--- a/x86/apic.c
+++ b/x86/apic.c
@@ -488,6 +488,14 @@ static void test_apic_timer_one_shot(void)
      */
     report((lvtt_counter == 1) && (tsc2 - tsc1 >= interval),
            "APIC LVT timer one shot");
+
+    lvtt_counter = 0;
+    apic_write(APIC_TMICT, interval);
+    apic_write(APIC_TMICT, 0);
+    while (!lvtt_counter);
+
+    report((lvtt_counter == 1),
+          "APIC LVT timer one shot spurious interrupt");
 }
