Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17C4346FDA1
	for <lists+kvm@lfdr.de>; Fri, 10 Dec 2021 10:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239260AbhLJJ2a (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 04:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239221AbhLJJ23 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 04:28:29 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FB1EC061746;
        Fri, 10 Dec 2021 01:24:55 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id b13so5897436plg.2;
        Fri, 10 Dec 2021 01:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9sjQ0LVi+c/FnmWkRnAoaxUOuPMFYk0TuS1ZtFOiZ8=;
        b=ht0GfF0IrzJFefoTUceb6eCZEXLW/G/DdjrUcQ43HNHoHG1HzuohONK4Cw1uEqGBMO
         P8ra/EovUaz+lLkK/ZLtgaI28JIRU0qsxzXWLckFFIhsKe/qlgxEAoEm8eygHS9j09j1
         vApKaarixaOLVCa2jAXdhJuVn45Jf5+GNRk70b0GJxlNveH0WYnSVVzaPlJFBqYWNLBv
         NNwUnznXMV9md7fbqoEGLcnrWmn7jMEkEz/TXsjPi/mgcW28wsPFoDhxU+cy3AGw6bfb
         2D6PAikYAAnuX/Samx4ojhVt0vVQmE5aDQEdLQczIqHgkQMjnCnJjlXKYXTt2EsdvH9H
         B93Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9sjQ0LVi+c/FnmWkRnAoaxUOuPMFYk0TuS1ZtFOiZ8=;
        b=sZF305p8+0UjiVdvE9GF7IFn5qgkLlIrIv3ThMI2zyZlpNKvGs2F8kpv2X9bTRxjpv
         OzLrr2Uj3xB4K7R8YkcC8dXLRNCK7DiMmv51N04S4mEDXS7t5u5nkbDp6KxC6jG5gh4K
         Vc3tuGvIL73Uaouxq466qavFLpQ88icNuoMX7jZcx/1sjF0eBD8WGmbZocRzAfzzr9DY
         +ubdWqV2cWpxhfjw0wtWPcJacSUz69xXmmY3Buxd8RNMK0jHVNM3BxiZsMV0eKp092yP
         WRrU2/rt/FH4dSsmUNtbWzuPAR13FBNP25K5mzPfSN7vMB1/ps2sl2wpYhUFc9hn0CuJ
         Fauw==
X-Gm-Message-State: AOAM530/8tPtWbSrnZw4jUGVpKFyn8sjstwkL+TlokbTQrKzAYBt71S2
        XUMi9kHuoYY0m4uNjQrUbEXB8jIogME=
X-Google-Smtp-Source: ABdhPJwcOuUoaLJy+1VEpZWC7AuWOGwsBhzjkd4idFvaQFFBAnRv3ViI+NgPpGpbA6/MMlMe+Z9+BQ==
X-Received: by 2002:a17:902:d28a:b0:142:61ce:ae4c with SMTP id t10-20020a170902d28a00b0014261ceae4cmr73913028plc.35.1639128294553;
        Fri, 10 Dec 2021 01:24:54 -0800 (PST)
Received: from localhost ([47.251.3.230])
        by smtp.gmail.com with ESMTPSA id j36sm2120829pgi.8.2021.12.10.01.24.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 Dec 2021 01:24:54 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [RFC PATCH 0/6] KVM: X86: Add and use shadow page with level promoted or acting as pae_root
Date:   Fri, 10 Dec 2021 17:25:02 +0800
Message-Id: <20211210092508.7185-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

(Request For Help for testing on AMD machine with 32 bit L1 hypervisor,
see information below)

KVM handles root pages specially for these cases:

direct mmu (nonpaping for 32 bit guest):
	gCR0_PG=0
shadow mmu (shadow paping for 32 bit guest):
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1
direct mmu (NPT for 32bit host):
	hEFER_LMA=0
shadow nested NPT (for 32bit L1 hypervisor):
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=0,hEFER_LMA=0
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE=1,hEFER_LMA=0
	gCR0_PG=1,gEFER_LMA=0,gCR4_PSE={0|1},hEFER_LMA=1,hCR4_LA57={0|1}
Shadow nested NPT for 64bit L1 hypervisor:
	gEFER_LMA=1,gCR4_LA57=0,hEFER_LMA=1,hCR4_LA57=1

They are either using special roots or matched the condition 
((mmu->shadow_root_level > mmu->root_level) && !mm->direct_map)
(refered as level promotion) or both.

All the cases are using special roots except the last one.
Many cases are doing level promotion including the last one.

When special roots are used, the root page will not be backed by
kvm_mmu_page.  So they must be treated specially, but not all places
is considering this problem, and Sean is adding some code to check
this special roots.

When level promotion, the kvm treats them silently always.

These treaments incur problems or complication, see the changelog
of every patch.

These patches were made when I reviewed all the usage of shadow_root_level
and root_level.  Some of them are sent and accepted.  Patch3-6 are too
complicated so they had been held back.  Patch1 and patch2 were sent.
Patch1 was rejected, but I think it is good.  Patch2 is said to be
accepted, but it is not shown in the kvm/queue.  Patch3-6 conflicts
with patch1,2 so patch1,2 are included here too.

Other reason that patch 3-6 were held back is that the patch 3-6 are
not tested with shadow NPT cases listed above.  Because I don't have
guest images can act as 32 bit L1 hypervisor, nor I can access to
AMD machine with 5 level paging.  I'm a bit reluctant to ask for the
resource, so I send the patches and wish someone test them and modify
them.  At least, it provides some thinking and reveals problems of the
existing code and of the AMD cases.
( *Request For Help* here.)

These patches have been tested with the all cases except the shadow-NPT
cases, the code coverage is believed to be more than 95% (hundreds of
code related to shadow-NPT are shoved, and be replaced with common
role.pae_root and role.level_promoted code with only 8 line of code is
added for shadow-NPT, only 2 line of code is not covered in my tests).

And Sean also found the problem of the last case listed above and asked
questions in a reply[1] to one of my emails, I hope this patchset can
be my reply to his questions about such complicated case.

If special roots are removed and PAE page is write-protected, there
can be some more cleanups.

[1]: https://lore.kernel.org/lkml/YbFY533IT3XSIqAK@google.com/

Lai Jiangshan (6):
  KVM: X86: Check root_level only in fast_pgd_switch()
  KVM: X86: Walk shadow page starting with shadow_root_level
  KVM: X86: Add arguement gfn and role to kvm_mmu_alloc_page()
  KVM: X86: Introduce role.level_promoted
  KVM: X86: Alloc pae_root shadow page
  KVM: X86: Use level_promoted and pae_root shadow page for 32bit guests

 arch/x86/include/asm/kvm_host.h |   9 +-
 arch/x86/kvm/mmu/mmu.c          | 440 ++++++++++----------------------
 arch/x86/kvm/mmu/mmu_audit.c    |  26 +-
 arch/x86/kvm/mmu/paging_tmpl.h  |  15 +-
 arch/x86/kvm/mmu/tdp_mmu.h      |   7 +-
 5 files changed, 164 insertions(+), 333 deletions(-)

-- 
2.19.1.6.gb485710b

