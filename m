Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D37513A09DF
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 04:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbhFICSV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Jun 2021 22:18:21 -0400
Received: from mail-oi1-f174.google.com ([209.85.167.174]:46007 "EHLO
        mail-oi1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232224AbhFICSU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Jun 2021 22:18:20 -0400
Received: by mail-oi1-f174.google.com with SMTP id w127so23599070oig.12;
        Tue, 08 Jun 2021 19:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Df8t1QJutzCUZPX7EISyP+4HxHgoT0YA70uuZIR5B6o=;
        b=Zi9J/0ym37D+zXhLM7/YAWLx6IOFr76XVw0l3r/xPNWxTc7NeLpT82qb2L7c7Ge/BC
         xtyVYSsAEY3MNmpX/EOZq/FQUA/uff6fLssVN78w+/5ltjrmXoFp/1SQB5sWWxdfxtVl
         gTAuRCf08LgCybgyqjLxNdasxgbL2WdAvubwZdv8mBZV/UWZQb+5sjw+d04oUYb8x/EF
         0mtkQ4WcqT7N/gva9senlpQOAfG1hdNk6aFsQ/wijbYzvcLD1MgBulUDXYHAb8WTKuWP
         UaGzZ6gh/XkgVFGZoQl3QdTJlWCIU/CE+wWxScartoY3ND09CXpxHbKz4GLpd+teHyN9
         T7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Df8t1QJutzCUZPX7EISyP+4HxHgoT0YA70uuZIR5B6o=;
        b=uZDZ4pwvog6nyMquaJcFF4DKDyzMkYVGGpAftSNJyAksOQeWrfI4oScfaW0zh6Qq8y
         c7xKuHA5x1nzvZy1/QimncZaTqw3HUs7Wt1cAT4d6sxDjWquKKmJDaz4hStjJRDnC002
         Q5WbQO2YC5s774JdGkOOjADon1evcijZD3R1ERVh0rggOeNIK4HuDiD3AMsqB/5bXkT0
         LgHNwVZyImBqQDjTGiWEcwWMQxiko5xB/qbEGUNaICFmBv20qO55IzU9NBf4rd5x6BJa
         WHU3jYMHBCNc76cYGDH68fZtq+34iznJZU5ymS6mm5pAa+TAgntDkLhHgJ5jPfdKb4vl
         /08A==
X-Gm-Message-State: AOAM532aU53Utge+CG+RE/Hh6BlpQDmQmkN6Af8O3XVTtkr+du1t4n5q
        hrFU50M1zjG6ceIUrHzJecz4COcQvJ8t/v6ef+h3/Ygtogk=
X-Google-Smtp-Source: ABdhPJw+RVlVDUG2zRXgiVMWgTXdzzWRLwkU3MLbSSijsAVchAyBr4VRJaUNqQse3cIPEuKaoWXg0BWP6DjEH3JJhyU=
X-Received: by 2002:a05:6808:c3:: with SMTP id t3mr4582410oic.5.1623204911286;
 Tue, 08 Jun 2021 19:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
 <1623050385-100988-2-git-send-email-wanpengli@tencent.com> <0584d79d-9f2c-52dd-5dcc-beffd18f265b@redhat.com>
In-Reply-To: <0584d79d-9f2c-52dd-5dcc-beffd18f265b@redhat.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Wed, 9 Jun 2021 10:15:00 +0800
Message-ID: <CANRm+Cx3LpnMwWHAvJoTErAdWoceO9DBPqY0UkbQHW-ZUHw5=g@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] KVM: LAPIC: Reset TMCCT during vCPU reset
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 9 Jun 2021 at 00:27, Paolo Bonzini <pbonzini@redhat.com> wrote:
[...]
> Perhaps instead set TMCCT to 0 in kvm_apic_set_state, instead of keeping
> the value that was filled in by KVM_GET_LAPIC?

Keeping the value that was filled in by KVM_GET_LAPIC is introduced by
commit 24647e0a39b6 (KVM: x86: Return updated timer current count
register from KVM_GET_LAPIC), could you elaborate more? :)

    Wanpeng
