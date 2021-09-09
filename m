Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FECC405CE1
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 20:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbhIISdV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 14:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236823AbhIISdU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Sep 2021 14:33:20 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F814C061574
        for <kvm@vger.kernel.org>; Thu,  9 Sep 2021 11:32:11 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id o7-20020a05622a138700b002a0e807258bso5756686qtk.13
        for <kvm@vger.kernel.org>; Thu, 09 Sep 2021 11:32:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=R+cgXXVmcS0XSIjUbXW9VTmf6q0MIVewRXmwTVC3Hxc=;
        b=M6OgT50m/mEsUbqBUZN9wK3zaDvn3LTDzftb1gp7w1WzDSSyzD2Sw2cHnGv7reFMCk
         UvxMCdIuMV/XpPXZ/HBRhiiY22HhqXOknJw6LQIEVRr0JKG9bNS/JStUQgLbeJn3mTH7
         V6Jo9y81B8PFZWocsTTFsjm0yNBuhuBNUaYSgHQChrnkfqAKkzpC3I5VXEYVzk9cmvAo
         prVK7J5tjyS/gGxb+hVx3fvaf1WwCleOQ8f4rxJZ7VGeJfAh2WZVimzZpAiKI+62ACfd
         5HnuvM0KGPHTK6X5uVJRxYhknaOzQzHFDzhLSYVZnd0QOk8GDis+TKHZWr6mvdUbmr6X
         6TXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=R+cgXXVmcS0XSIjUbXW9VTmf6q0MIVewRXmwTVC3Hxc=;
        b=ueN2vJH1Mvz7eWvjOwPRN+5shyWMTI5CExjozXRzMWOfKT+rGeNWWaq0hKpMbADisQ
         MWBb3N/E7tf8zgYxBE/F9M7aBw3PqvUeZ8F7o1BSx+Xf3EAxi5tYJVBstf4c6q2M8cky
         zL6NDq9IqE6BjnHHCFusPPnaSx5azVyWYyXCOPpTZRupPFnvhs82v31typm774BH4UJh
         IXEb0cJMrlAhaT16dCsUOO1C7kGEHbnVJcMP+u97b08KVGq56AM/xd/3B/fL26SLJVqp
         2lA4P0eEBbxiCTt3CQzliq/zQ6t4pfQpPdIXrhtnnGB/2rvWw1DbDPJqzP8JlkvRsMJv
         V6fA==
X-Gm-Message-State: AOAM532Vi4fWCXvdIDvrel3dh+ZV+PmMxDAIfMZZps2sHWwSzD+GjcxE
        Dd2ytXO/tm56/B5BekGv+sWRBCpFhLk=
X-Google-Smtp-Source: ABdhPJxyj3vRgQg6vmeFLF+uBkcmhTCNaAZ7mr/SZUCz0JFHFZHioGJ89Cbx5Y4VnQvndiJGxTi8RUwHvEI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:295c:3114:eec1:f9f5])
 (user=seanjc job=sendgmr) by 2002:a05:6214:c87:: with SMTP id
 r7mr4491277qvr.2.1631212330428; Thu, 09 Sep 2021 11:32:10 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  9 Sep 2021 11:32:00 -0700
Message-Id: <20210909183207.2228273-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [kvm-unit-tests PATCH v3 0/7] x86: Fix duplicate symbols w/ clang
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Bill Wendling <morbo@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a "noinline" macro to mirror the kernel's wrapping of the attribute         
and to save typing, and use it to fix a variety of duplicate symbol errors      
that pop up with some versions of clang due to clang aggressively inlining      
functions that define globally visible labels in inline asm blobs.

Bill Wendling (5):
  lib: define the "noinline" macro
  x86: realmode: mark exec_in_big_real_mode as noinline
  x86: svm: mark test_run as noinline
  x86: umip: mark do_ring3 as noinline
  x86: vmx: mark some test_* functions as noinline

Sean Christopherson (2):
  lib: Drop x86/processor.h's barrier() in favor of compiler.h version
  lib: Move __unused attribute macro to compiler.h

 lib/libcflat.h       | 3 +--
 lib/linux/compiler.h | 2 ++
 lib/x86/processor.h  | 5 -----
 x86/pmu_lbr.c        | 4 ++--
 x86/realmode.c       | 4 +++-
 x86/svm.c            | 2 +-
 x86/umip.c           | 2 +-
 x86/vmx.c            | 6 +++---
 8 files changed, 13 insertions(+), 15 deletions(-)

-- 
2.33.0.309.g3052b89438-goog

