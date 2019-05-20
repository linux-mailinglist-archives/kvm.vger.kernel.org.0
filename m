Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9EEB23C6C
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 17:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389104AbfETPmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 11:42:36 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40466 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732399AbfETPmf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 11:42:35 -0400
Received: by mail-wm1-f67.google.com with SMTP id 15so9491681wmg.5;
        Mon, 20 May 2019 08:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=SPTjC0L2QaZxdzwVeAQZoNORTNv5Tk9d+oofxkweQMU=;
        b=g6syb2ZMWgKjJoD8Bsctzk39adCnBGCs1p68MGhrbjAGAowEHKuio2Zryq5NUspIwq
         4hQNRyPI7AUYg5XkPNVaa+EdF/9gbMg5mrtPCzFrL9y2hdQAfdnwfOnZbtFDHwLwiLCc
         Gkgb3JBXoToqgzmkCrRHZtGydPfyYNlqXxNYZHotjWaWwHDGBoLbn/vy6aqvl8F6yW9o
         zs7fEF6fdmEPVEsvQ5DQyD6XCyX98XV8I80cGGyucEmUbI5jjYsmMevqx5HL14AY1bfd
         GILjvSqm4/35XNZnzuimRSNhewB2GdUjwghKrXBH0lZSE+91LgKVZvMZo+m1yH7Qj4Er
         fo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=SPTjC0L2QaZxdzwVeAQZoNORTNv5Tk9d+oofxkweQMU=;
        b=sEj57nUX8Q63voXSuENo1Dy5Jvzzk2r8owFaJb55Wq3+LBLG1GmskQGeyJKwO5GQzM
         Dl+nDkIy0AVGxrjM06fzijziN5SNlyFYVMSnkJoC8DV0+dkw6AaUnIm7kBMKEVZ9zTt3
         QFPdsmatAG9DaHV81FY6pYxw68ZSYZena3qh8Hs1l+Rvt2oxwJ09981NIjmmxhyaGoav
         xMu+3fUXWwONFPj/Ry11U/wNTJBe3fJrQ5XMbTGrPax1kJMbSLfLlP6V9HrQh/Cg9IyZ
         x/XykJd0vRDaymKwbdUQRClrMC3IYpf/ZeWIzef1NrvHV9RBsn17Ho6ccTdT68dNXhMv
         6nXA==
X-Gm-Message-State: APjAAAX1Gw22gxl75XTuLjBb885Z64wrMJsBHHeH59jZioFk1OidZxY3
        vQIT0+DANLcuWmk20xTxEix9kjaK
X-Google-Smtp-Source: APXvYqyMHw674x6QcYVvgnwVb6AbgaFSxwvzfftHCX05ehE0IITNP7NwS9kQQCdXuCY8AXcD/nSgmA==
X-Received: by 2002:a7b:c5cd:: with SMTP id n13mr7726497wmk.67.1558366953225;
        Mon, 20 May 2019 08:42:33 -0700 (PDT)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id v11sm15851995wrq.80.2019.05.20.08.42.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 20 May 2019 08:42:32 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH 0/2] KVM: x86/pmu: do not mask the value that is written to fixed PMUs
Date:   Mon, 20 May 2019 17:42:29 +0200
Message-Id: <1558366951-19259-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch is a small refactoring to enforce masking of values
returned by RDPMC and RDMSR.  The second patch fix pmu_intel.c to
behave the same as real hardware; this fixes the failing tests
introduced in kvm-unit-tests by "x86: PMU: Fix PMU counters masking".

(Nadav, this is just FYI.  I am not CCing you on individual patches
to avoid problems with your corporate overlords, and I am not expecting
a review from you).

Paolo

Paolo Bonzini (2):
  KVM: x86/pmu: mask the result of rdpmc according to the width of the
    counters
  KVM: x86/pmu: do not mask the value that is written to fixed PMUs

 arch/x86/kvm/pmu.c           | 10 +++-------
 arch/x86/kvm/pmu.h           |  3 ++-
 arch/x86/kvm/pmu_amd.c       |  2 +-
 arch/x86/kvm/vmx/pmu_intel.c | 26 +++++++++++++++++---------
 4 files changed, 23 insertions(+), 18 deletions(-)

-- 
1.8.3.1

