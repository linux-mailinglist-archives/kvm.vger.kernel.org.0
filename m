Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 161F634F758
	for <lists+kvm@lfdr.de>; Wed, 31 Mar 2021 05:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbhCaDTs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 23:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbhCaDTo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 23:19:44 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87A3AC061574
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 20:19:43 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id c20so393212qtw.9
        for <kvm@vger.kernel.org>; Tue, 30 Mar 2021 20:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=sOb7NEJl+AeolkpzxTyofNZTvUzELB1nvc8i4lV36jE=;
        b=Zqz0CV+RXQXP0rMDlz3xJUcyTKSY1zFb9tXpomz40KtHRTkLeBkZVgwftostW065T7
         pooHfG4ZqWULR3W+CVG+y3i+Dar99SHYWQ80D9CjKZDArcuVduSZe8nQxWUtzCSoid1l
         x4Bn0G8xXyYA7Dj6D1cIeA8CfDiBE2Le80GmG76I+RUSoHXupjZhP8RmtabpOY7K9BVh
         OnRAxvs5NivcMBNjNDCqWS/l6x3c1aV9OG4HCkbHFGlTqaiQedolTVpG8bdD+MCYcDfh
         XG7I/yLHfw36ZrJADjl2cOe5NZhehs2d/wx9XXCDgYicJ8mpBsK/Yvu7afXKorV/DPfv
         eDyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=sOb7NEJl+AeolkpzxTyofNZTvUzELB1nvc8i4lV36jE=;
        b=XZWXwBmZXdp2zuKLwBfDLklEiDGwoRTD/VG0iX/BHI7XDZDduJwFtD85wwL0PwJzip
         nTM/r6+RKavAC+M+RaqhvC1F+6o4cPWsbypa0wng6BL7yjrZXiwjpYrH7CfUOhXiluyx
         xiD9zkvn/TUh6whisEVi4Td0fTrUqOlO/AgpUksXc/z524A9nL4UieQHhnNPMf7wKNMA
         dQ9DvlQUhegOd9FXEtBHE6ylg5eoWcbxI6ZQ3sW/D6RtFguf6s0a/EyPDZIXoaoQCtwE
         Cf/TuJIWEP1l82l8/eLEzVXBudL7qGZIr/AsVa8NPxReQtc+LPK21eq4CwG1tTzhyOdf
         yayg==
X-Gm-Message-State: AOAM5336iAfvvG+UPVuyC+NRHeE5q0x/i/5c6OZ+pjJZPQpcFgfzewGE
        xhQrKSvuUZFFLl5JVIxnjPoagKJr2ps=
X-Google-Smtp-Source: ABdhPJzE5U8A8ThHZ+AOEEXZHsflheOnyjBhFkAVDOvh8sw/PKf8FDxFaU8+8WBEldeAhey6VoOuVnLoxnE=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:6c6b:5d63:9b3b:4a77])
 (user=seanjc job=sendgmr) by 2002:a0c:9e0f:: with SMTP id p15mr1222038qve.27.1617160782533;
 Tue, 30 Mar 2021 20:19:42 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 30 Mar 2021 20:19:33 -0700
Message-Id: <20210331031936.2495277-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 0/3] KVM: SVM: SEV{-ES} bug fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Misc bug fixes in SEV/SEV-ES to protect against a malicious userspace.
All found by inspection, I didn't actually crash the host to to prove that
userspace could hose the kernel in any of these cases.  Boot tested an SEV
guest, though the SEV-ES side of patch 2 is essentially untested as I
don't have an SEV-ES setup at this time.

Sean Christopherson (3):
  KVM: SVM: Use online_vcpus, not created_vcpus, to iterate over vCPUs
  KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT completes
  KVM: SVM: Do not allow SEV/SEV-ES initialization after vCPUs are
    created

 arch/x86/kvm/svm/sev.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

-- 
2.31.0.291.g576ba9dcdaf-goog

