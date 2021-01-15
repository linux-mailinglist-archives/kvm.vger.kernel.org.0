Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C11902F8820
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 23:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbhAOWEm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 17:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725918AbhAOWEl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 17:04:41 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55BEFC061794
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 14:04:01 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id e74so8335685ybh.19
        for <kvm@vger.kernel.org>; Fri, 15 Jan 2021 14:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=F4qSiyP6qNsDhBMqCUY6h5QJboOTRDoltedUrihSiWc=;
        b=Q93aXvTiT7/Nuaby+dCOgqxB4DbUiRhsGWJtdcyTmjoKE+RnZiQv4StLdlcVhg3c4+
         +C6RVz/EmcpRQwaNHk3miO89hu8VDzZQJvBDZV8c7GfRbUm0MvlXaI3g516WvDqcQqt5
         1sl+h4A/FyHrwyxN9KMZ9C2n8dhJ4vzFY8MImNedDbK0+8WZSmZGXKeNumERlFsFPqOR
         eQ8aGrA41ytuI/yjSNQCkUwN3KAQuG04WDY3S9zqhceUmqOuB5bZzESTKuvybupAleME
         BpJ1v24GtegZoRz1EtV1LoFC6fF5aanVOIxVS7xQtVKsfSI29PLZnIT6OgxJb35gvH8+
         N5jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=F4qSiyP6qNsDhBMqCUY6h5QJboOTRDoltedUrihSiWc=;
        b=BCRV5jC2OOk/oJA+QdYtRCw4WGPRpF/H95jICKL7UbSYRdTsWvqPv1UE0dUwb8B/J5
         3wVcCye+yBvSp8N5QmXnHQ6JFB7fI98Ziq7vuFlxgzarmDPOprA5q2p1fpM8ESzv8Xk6
         LT0aUT+BAXIdvKdZjPeMWZSZ5pfDrUHtPXVgCJbvQjjTnRaWBbBEV6nyBHRMBl7Qfw98
         OrWXXrn/c+kW/NczjwaDyCO0IrqmkfRJKR8RPF0ElGwEiqMixiL0eKqemDwKqlc/Fca1
         nJVblBRWGJYM/w/K8ij3fYYXuluBKLInjahCJuZTs2USAAdOPnsrf0OrK005z/suR4zL
         R04A==
X-Gm-Message-State: AOAM532RJAHTW+s73gOHOSE/0TsqHEQAk5hRjS0Njo4foM2CzkLBHK/4
        qBu/NCfD6i8q5YmIH7H2kt1YHN3NKWc=
X-Google-Smtp-Source: ABdhPJzp4A3W1q3Tqhar2/Evi1HCTQ5/uUoQIM/i7LHvbvw5BJaOYCPfssOfhCcdTCa/dJEeGjj4v/SjFps=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:1ea0:b8ff:fe73:50f5])
 (user=seanjc job=sendgmr) by 2002:a05:6902:20a:: with SMTP id
 j10mr21842753ybs.293.1610748240590; Fri, 15 Jan 2021 14:04:00 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 15 Jan 2021 14:03:52 -0800
Message-Id: <20210115220354.434807-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [PATCH 0/2] KVM: VMX: Avoid RDMSRs in PI x2APIC checks
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, luferry <luferry@163.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Resurrect a patch[*] from over a year ago to avoid RDMSR in a fairly hot
path in KVM's posted interrupt support.  Note, in my response to that
patch, I suggested checking x2apic_supported() as well as x2apic_mode.  I
have no idea why I suggested that; unless I'm missing something,
x2apic_mode can never be set if x2apic_supported() is false.

[*] https://lkml.kernel.org/r/20190723130608.26528-1-luferry@163.com/

Sean Christopherson (2):
  x86/apic: Export x2apic_mode for use by KVM in "warm" path
  KVM: VMX: Use x2apic_mode to avoid RDMSR when querying PI state

 arch/x86/kernel/apic/apic.c    | 1 +
 arch/x86/kvm/vmx/posted_intr.c | 6 +++---
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.30.0.284.gd98b1dd5eaa7-goog

