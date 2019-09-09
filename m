Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2485AE102
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2019 00:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbfIIW2S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Sep 2019 18:28:18 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:48678 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbfIIW2R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Sep 2019 18:28:17 -0400
Received: by mail-pg1-f202.google.com with SMTP id k20so9404892pgg.15
        for <kvm@vger.kernel.org>; Mon, 09 Sep 2019 15:28:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Iz9jz/iVq+CJnK4VQZV34GfLHmhhBlr0EH0H9C9Yi84=;
        b=HqyG6F/Dmzw6n/NTAEF9grljGv7cgKsXekFbrv0qEwztgtL99y5EM9JazRUDSjfISS
         24jJsgUX98rpZm9R8w3X/eZIfFUFXmgFWdGIfDGdbASJXzyoS4DvmuQSqcg1je9awAHj
         1Q2kgXzOsS7COraZxPAptKHMehLAFY7RB3heLw5codhW2W6pNV6sssmcdToLZxWaFxbU
         r6kMQbEQ/fY3b+9/bl+0WIRGafxQl+uszy9/D5Q7cxYPbbkGjEq9oNY+GuO63isiii7c
         NwG7n1PB7C6gEkvNA1ar0/eL1mlGwOJKYvPgpXU4QKOlsrZWxf9m0EjGh7UTIDzhsPCf
         auiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Iz9jz/iVq+CJnK4VQZV34GfLHmhhBlr0EH0H9C9Yi84=;
        b=Y17BuDFHHOZJ6OJjirTD5ssSrIpumJ0cNRvBg37sU/hG6gUpWLwfakBkXsnrRUorfc
         Re27gnLq9kLB5kuA014B07fMw2UoZa30C01uCelPzhSgIiZrZ10k13Pxaq5Qot5bkbVE
         sOCAgm/2HYIYuIGh5kT0ZvI8gLquyRc1h3VUBoTMjXcuplBAd/gGWo9VG7Hh77ld6/zr
         xHAA8P55DSjkf8HqMtwEtcrST1yPsNgFqclsbVIFn7A7WPWv3/GQTUC70tVmJ4Aa3kZr
         Uhhy9No5x4DmLxf79MOdkMEZJmsrhN+m/urBFNXhp76eiRp4nw/UiEBLzA3jrAXXsfgd
         j52g==
X-Gm-Message-State: APjAAAVhPzshbpjO8YfwGeZcw8V7s9PGx1R06bre8vJYA4R/fJOkJT4K
        Khy9ZfkbsYw4kyL6TJYEsbBBJXdF0J8F97JzbFsFHLRJO2LvJzKieJzxjUWKpl+o+j9lDaPOknw
        F0fLp83TZcwBWvQ8tPfWIXEGLgNGKJZgjJn6XwYdD5Ms5NyMp6HKVCJI5F7lbDSY=
X-Google-Smtp-Source: APXvYqwVb79LTLsPstFw/1Fd6uc2v+r4OS1ajk/opBoxG8VykkcvKPcz6iE2UfNW8bFbQb21JiMZPdxvKF/iCQ==
X-Received: by 2002:a63:89c2:: with SMTP id v185mr24124918pgd.241.1568068096048;
 Mon, 09 Sep 2019 15:28:16 -0700 (PDT)
Date:   Mon,  9 Sep 2019 15:28:11 -0700
Message-Id: <20190909222812.232690-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.162.g0b9fbb3734-goog
Subject: [RFC][PATCH v2 0/1] KVM: nVMX: Don't leak L1 MMIO regions to L2
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v1->v2:
* Added static branch prediction hint to nested_get_vmcs12_pages.
* Added vmcs12->apic_access_addr to pr_warn and vcpu->run->internal.data.
* Sunk call to nested_vmx_failValid from nested_vmx_run to
  nested_vmx_enter_non_root_mode.
* Simplified return codes from nested_vmx_enter_non_root_mode.

Jim Mattson (1):
  KVM: nVMX: Don't leak L1 MMIO regions to L2

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/vmx/nested.c       | 65 +++++++++++++++++++++------------
 arch/x86/kvm/x86.c              |  9 ++++-
 3 files changed, 49 insertions(+), 27 deletions(-)

-- 
2.23.0.162.g0b9fbb3734-goog

