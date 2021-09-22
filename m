Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDE17413E74
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 02:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232241AbhIVAJ0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Sep 2021 20:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbhIVAJD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Sep 2021 20:09:03 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21EF8C0613A0
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:06:19 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id s18-20020a05620a255200b00433885d4fa7so6218496qko.4
        for <kvm@vger.kernel.org>; Tue, 21 Sep 2021 17:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=4BBDHyzTmFJD2PGtjmXQGbVqPzRCZc8ppu5cY3KZ5Y8=;
        b=i1hLF6bC7QippVnwD+QfcurzwPql0DTYdtvpNMOXEcTNGevY7UnIQHp4F8TFxhWOcC
         y5khcTlTsxcY03DM6I7OGwJdsNRusHePnZs48VJgz9iDl9BCd/WdBAHgBd08BkVlEctl
         qgkp34acvdJvQRinIA310i906+1pI4VRGGbTHUSEWOTyISF582eEBN0uohWrXglJ4Vha
         UiRiAJR9+rHm1hSoN64l3MLHm8i51hrtd5lKdh0LN16chuzJEtOj6NO2pvuQiZZnchZT
         2+/Nzn1kX3D5dvOeb3mhXnOtnZBTLnXfaqpsFhvkCaK7qjG4cSZxh2Y/t71DvQNuI5L1
         pIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=4BBDHyzTmFJD2PGtjmXQGbVqPzRCZc8ppu5cY3KZ5Y8=;
        b=qcJj8rXQ+XWHJh0QiV2DmJS6kVxavREZ6/9v9OcQK6p6alEcl0Os+FcDlZ34qwRQN7
         nLX4H4t+hWgLosl9xo+nSRkXrR6z7x4Z7G17t1q6Gg6qEOmd09/Q7iR/27OoH8Ugewwd
         XOjPi/+Pmc8wULFc0mBGjOIqxARgX3a4Zoe0XXO6LBevmfDBUYRf+NsCNUprYrljL5wR
         aGocevvX6azDY+jU+mR1LRJK5pxPIt/aGCKbS/LS1huyTpr0r4vNHYQon33RRoozMwgA
         nXphAxkNRIwaqI4SGmebFKEMts1hJYsvHchTfby2BwofLVuZRah5BT7/NXyBaRMbtOWn
         dEZQ==
X-Gm-Message-State: AOAM533hjlK+o9fSDnr8bs0Sw8rRNZyjryv9PONXPHRVCv6LGj48G8yI
        1OWO97PhxTOvrNbsbaNnOek6Lv1U8wo=
X-Google-Smtp-Source: ABdhPJzV8/bAA+bVdBd7d54Vy+1c6C23hub/FF/gkHwdARHRitfqPelJ1Pr98qSi4K4qg/f1+Xhzcbcxu/4=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:b022:92d6:d37b:686c])
 (user=seanjc job=sendgmr) by 2002:ad4:466a:: with SMTP id z10mr32596974qvv.47.1632269178759;
 Tue, 21 Sep 2021 17:06:18 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 21 Sep 2021 17:05:33 -0700
In-Reply-To: <20210922000533.713300-1-seanjc@google.com>
Message-Id: <20210922000533.713300-17-seanjc@google.com>
Mime-Version: 1.0
References: <20210922000533.713300-1-seanjc@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v3 16/16] perf: Drop guest callback (un)register stubs
From:   Sean Christopherson <seanjc@google.com>
To:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>, Guo Ren <guoren@kernel.org>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Juergen Gross <jgross@suse.com>
Cc:     Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, linux-csky@vger.kernel.org,
        linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        xen-devel@lists.xenproject.org,
        Artem Kashkanov <artem.kashkanov@intel.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Drop perf's stubs for (un)registering guest callbacks now that KVM
registration of callbacks is hidden behind GUEST_PERF_EVENTS=y.  The only
other user is x86 XEN_PV, and x86 unconditionally selects PERF_EVENTS.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 include/linux/perf_event.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index d582dfeb4e20..20327d1046bb 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1505,11 +1505,6 @@ perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)	{ }
 static inline void
 perf_bp_event(struct perf_event *event, void *data)			{ }
 
-static inline void perf_register_guest_info_callbacks
-(struct perf_guest_info_callbacks *cbs)					{ }
-static inline void perf_unregister_guest_info_callbacks
-(struct perf_guest_info_callbacks *cbs)					{ }
-
 static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 
 typedef int (perf_ksymbol_get_name_f)(char *name, int name_len, void *data);
-- 
2.33.0.464.g1972c5931b-goog

