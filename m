Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354193E4AFD
	for <lists+kvm@lfdr.de>; Mon,  9 Aug 2021 19:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234416AbhHIRk2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 13:40:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbhHIRk1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 13:40:27 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D47F5C061796
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 10:40:06 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id c3-20020a05620a0ce3b02903b8eff05707so6070904qkj.5
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 10:40:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=gVO6XyapJi5pX7+bij/mNcbdaPF5qfutW9ftVZjcinQ=;
        b=hxr1KUlt6JndExAgFseog0rdSnmMTQt0HlJRzm++AIsgXQ+IPtzHHk2qqmqBIJMxpE
         6t1oKBc5o9JxmCeW3Mi0ebeAsQVFVehwd3lhDajrtMAtYQWxws1scS3niVXthDfyd6F9
         7c50WOZBh2GfdoLM27xHKawIFOVMruOPcnWZ4beRqsKIUY1RA0IQqCZHwAu8YbanCcqD
         sfki9DSmFkKlkEgmf3Wdc3oBIsF1qExMAk5GwZnXt9h9T9N5nNLKKhbs0D8ZLnTfocfe
         vWbjK79GqdZSeT9SNFNAzDCVk68q9hiCv+MW2aD9TO/cUmnCVEKFqracZs3VYPkqKuHM
         KGSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=gVO6XyapJi5pX7+bij/mNcbdaPF5qfutW9ftVZjcinQ=;
        b=TaxDzA5GwWYnqIPPTXfq42Xj7CRJDlfUW2yeXS1LHzUIGCtgCbAsALNMc53cqid2qG
         YY2MbrqN9sFEB12Gp+8rDxw2XMjiyMXElRH6uAtsMUF7abmXhLSwqiR1hn/mFNmlF82+
         0w7LSpHXzqEicQ0LKNOiZWpgrj61t3/C0zwt20LQbEMsnmLAERkkQYdaNFzRRB08gO8+
         9XwPZTzz/JMuU3m6URqirD4JnuFAvPO0QpUnF8Zdh4JrI/0KJh5YaCZg2FAe7hBdZjWR
         IuRdYv5jKH6cwIquy5S9JXgtad4C7iLuqfNvaJptyGKLGQx7vJnCav3TC2tJE3NVT92x
         UlRw==
X-Gm-Message-State: AOAM533OkmP53kcBTK6ojRNsFakoodXIati8nzkPFprVnrFzYmXgaL93
        vK4oHOdGcTlrlN/q6M/cwDDfA/dQHKI=
X-Google-Smtp-Source: ABdhPJwzkDy6R3OkPg4FEjD90MQ4pkhiSgikL3UlI9potyHED+1GvoHhRCLT0mfhlrjMo0W+xFwGepeiq6A=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:b967:644e:62eb:1752])
 (user=seanjc job=sendgmr) by 2002:a05:6214:13af:: with SMTP id
 h15mr13548050qvz.7.1628530806014; Mon, 09 Aug 2021 10:40:06 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  9 Aug 2021 10:39:53 -0700
Message-Id: <20210809173955.1710866-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v2 0/2] KVM: x86: Purge __ex() and __kvm_spurious_fault()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Uros Bizjak <ubizjak@gmail.com>,
        Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two patches to remove __ex() and __kvm_spurious_fault(), and hide
kvm_spurious_fault() in x86.h.  These were part of a larger series that
received the magic "Queued, thanks", but got lost at some point.

v1: https://lore.kernel.org/kvm/20201231002702.2223707-1-seanjc@google.com/

Sean Christopherson (1):
  KVM: x86: Kill off __ex() and __kvm_handle_fault_on_reboot()

Uros Bizjak (1):
  KVM: x86: Move declaration of kvm_spurious_fault() to x86.h

 arch/x86/include/asm/kvm_host.h | 25 -------------------------
 arch/x86/kvm/svm/sev.c          |  2 --
 arch/x86/kvm/svm/svm.c          |  2 --
 arch/x86/kvm/svm/svm_ops.h      |  2 +-
 arch/x86/kvm/vmx/vmx_ops.h      |  4 +---
 arch/x86/kvm/x86.c              |  9 ++++++++-
 arch/x86/kvm/x86.h              |  2 ++
 7 files changed, 12 insertions(+), 34 deletions(-)

-- 
2.32.0.605.g8dce9f2422-goog

