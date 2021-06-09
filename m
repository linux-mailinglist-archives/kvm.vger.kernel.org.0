Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0888B3A1D50
	for <lists+kvm@lfdr.de>; Wed,  9 Jun 2021 20:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhFIS7k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Jun 2021 14:59:40 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:51104 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbhFIS7j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Jun 2021 14:59:39 -0400
Received: by mail-qk1-f201.google.com with SMTP id n3-20020a378b030000b02903a624ca95adso17703508qkd.17
        for <kvm@vger.kernel.org>; Wed, 09 Jun 2021 11:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=9Ta4e4/TJDLA01JqUO5pruLWLZ3Bol4XK6b4bxWUzqQ=;
        b=YJnXxzDl4pi23RrNFK2eDoU54ZqtkFj1nQHZ+3Yt/ozWjyChgxPpctDzKNLgx5xkYT
         O5NxBdDcdED+4Z8RhFH1OhdDg3h9Zl0mjFYjuxLjtj8oB0KZ6dKNDxU6OvjeXEHcM102
         Yn3uwvIBnBQafroppL4HvSjeey+zHt5uXcJmWsRBLDQ8dnPM6Bw6VCMOHhsox3h6OJVc
         ejQsaUtkx8xmPu1O/4Tx2Gl8olM+Qo57JlgWnEt6wFQuhYwbGP+2Cxa483L5b6AjSr1E
         cvD0OBOF9cKVXwIPL+HkrLclje0/lzMCi/QZH+GyLdHALjy0ZC2DPwvwVynX/Sjkq+3H
         TmIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=9Ta4e4/TJDLA01JqUO5pruLWLZ3Bol4XK6b4bxWUzqQ=;
        b=VGhfSU4elBu6gmGBJmyym0pd4pQaLoDGsoJCdBG+9us+Eo0KufVbuBS6dNfCp9hlzt
         u024xbXdSU5TR4yQ/GksM6IkxqbpzOF09haJsYync47S6ATlFHm+MxHt8Hy8ZB/t4Jf5
         PjBdJDomxsqW233cHOx7bVcbjk9aE4nKLfmyqrH6E4Gv8eDRGIV5+ZSpuf8ttF93fu0Z
         edu1XpLiIdJWvZ5JzUlKpJ5L6THy2Zme+em4kwlu46y2OEY4gNghLS1L7H2SDBX+2BLT
         MqOqo0k9Sn2peg9CSHenit8R56Gu+1gqkh8lbH+ykAnqmHzUvLVqfcpQn+kk3m3vqrIY
         fcNg==
X-Gm-Message-State: AOAM533lQbz0KxCnzB7p/Tz+vBJnRrDTbpBUPZnlHbrcQjm8Jy0Jm3xf
        55GLDt0Y2iZEyMdzkmRP6SBQyY+mFi0=
X-Google-Smtp-Source: ABdhPJxfKT6Yk/tHfkxjnayQeolfV3XXuHVJHH+RSplVVdHCEYHLC7BLx4Ro/AX/GHGvkaTy3pFm5GxD2KI=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:bfdc:c2e5:77b1:8ef3])
 (user=seanjc job=sendgmr) by 2002:ad4:4e47:: with SMTP id eb7mr1527372qvb.40.1623264991162;
 Wed, 09 Jun 2021 11:56:31 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed,  9 Jun 2021 11:56:10 -0700
Message-Id: <20210609185619.992058-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH 0/9] KVM: x86: Fix NULL pointer #GP due to RSM bug
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Fix a NULL pointer dereference in gfn_to_rmap() that occurs if RSM fails,
reported by syzbot.

The immediate problem is that the MMU context's role gets out of sync
because KVM clears the SMM flag in the vCPU at the start of RSM emulation,
but only resets the MMU context if RSM succeeds.  The divergence in vCPU
vs. MMU role with respect to the SMM flag causes explosions if the non-SMM
memslots have gfn ranges that are not present in the SMM memslots, because
the MMU expects that the memslot for a shadow page cannot magically
disappear.

The other obvious problem is that KVM doesn't emulate triple fault on RSM
failure, e.g. it keeps running the vCPU in a frankenstate instead of
exiting to userspace.  Fixing that would squash the syzbot repro, but
would not fix the underlying issue because nothing prevents userspace from
calling KVM_RUN on a vCPU that hit shutdown (yay lack of a shutdown state).
But, it's easy to fix and definitely worth doing.

Everything after the two bug fixes is cleanup.

Ben Gardon has an internal patch or two that guards against the NULL
pointer dereference in gfn_to_rmap().  I'm planning on getting that
functionality posted (needs a little massaging) so that these types of
snafus don't crash the host (this isn't the first time I've introduced a
bug that broke gfn_to_rmap(), though thankfully it's the first time such
a bug has made it upstream, knock on wood).

Amusingly, adding gfn_to_rmap() NULL memslot checks might even be a
performance improvement.  Because gfn_to_rmap() doesn't check the memslot
before using it, and because the compiler can see the search_memslots()
returns NULL/0, gcc often/always generates dedicated (and hilarious) code
for NULL, e.g. this #GP was caused by an explicit load from 0:

  48 8b 14 25 00 00 00 00	mov    0x0,%rdx


Sean Christopherson (9):
  KVM: x86: Immediately reset the MMU context when the SMM flag is
    cleared
  KVM: x86: Emulate triple fault shutdown if RSM emulation fails
  KVM: x86: Replace .set_hflags() with dedicated .exiting_smm() helper
  KVM: x86: Invoke kvm_smm_changed() immediately after clearing SMM flag
  KVM: x86: Move (most) SMM hflags modifications into kvm_smm_changed()
  KVM: x86: Move "entering SMM" tracepoint into kvm_smm_changed()
  KVM: x86: Rename SMM tracepoint to make it reflect reality
  KVM: x86: Drop .post_leave_smm(), i.e. the manual post-RSM MMU reset
  KVM: x86: Drop "pre_" from enter/leave_smm() helpers

 arch/x86/include/asm/kvm-x86-ops.h |  4 +--
 arch/x86/include/asm/kvm_host.h    |  4 +--
 arch/x86/kvm/emulate.c             | 31 ++++++++++-------
 arch/x86/kvm/kvm_emulate.h         |  7 ++--
 arch/x86/kvm/svm/svm.c             |  8 ++---
 arch/x86/kvm/trace.h               |  2 +-
 arch/x86/kvm/vmx/vmx.c             |  8 ++---
 arch/x86/kvm/x86.c                 | 53 +++++++++++++++---------------
 8 files changed, 61 insertions(+), 56 deletions(-)

-- 
2.32.0.rc1.229.g3e70b5a671-goog

