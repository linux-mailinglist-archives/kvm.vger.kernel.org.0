Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0E4CE3FDB
	for <lists+kvm@lfdr.de>; Fri, 25 Oct 2019 01:03:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732359AbfJXXDm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Oct 2019 19:03:42 -0400
Received: from mail-yb1-f202.google.com ([209.85.219.202]:32879 "EHLO
        mail-yb1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfJXXDm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Oct 2019 19:03:42 -0400
Received: by mail-yb1-f202.google.com with SMTP id p66so493877yba.0
        for <kvm@vger.kernel.org>; Thu, 24 Oct 2019 16:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=H5UH2UlO9XnU36X6S3z2ls74WXsy5ReVfipmx8i1xro=;
        b=iJ4AdUvwZcNjsp9MNh2e7CXdFwOQ3xnzFfUbrgHTzM1AFJNXvPVamVtjbsgKZkMToV
         m2y5uIiCxxL+ZjGgH47GddWoGsx8XFqjNSLTLXX5fZ54c8+3aH9SfF6Vac8EwZ9LlWca
         ps1F1EVyZmLto8ZvObns7FeRPqssZ/LHwkAXa3tnKzNCsIS81ntY3VYOhkTvnddz44OJ
         cU1Mwn0N4MTm5J9U3x766uCEeOLfNE8BQ/FoeouIB2ueM3mcbDhNaoJ+dvXC7NvjS4qY
         iBF8XoP4XH1Xo/7CKD7XY1oXHOPlwmvqU/mqoLJYeB3Gq5+NT9NEtT/SIAsIbp6zuFNT
         +Vxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=H5UH2UlO9XnU36X6S3z2ls74WXsy5ReVfipmx8i1xro=;
        b=BiNPFIEZ0vU12jK+/RDXH2drNh0UztkclVb2WiBSwwoHP7I3q2vbLckjwIN4h3EHqk
         /FuaQZA2fs7TA4yUbOiB5CUDu7Lz2UB9lZ3AsLsLNCMPL54wb2pca8gbxwyuDGXwXy2+
         xEZHTtEEh0vYc0VH+0glfePkwVrDLGVcuXCA28wOtTDROIa0ea7Nw0LiTjmzJg0OOazB
         BkOFDbGpnjerMDBTbIhOcRZHPBlM+ExWMrZo5TZQ1h4KsoiPJLGopC55ONLkxUZmBq0X
         1AdI+ULiczP45XmVsLS2NtuKbUGvDbODnCLInDVenPabPbjyODgWKPEPRurKqUKv0S8R
         WIAw==
X-Gm-Message-State: APjAAAV1lWanAxeMZM7eEReQfNKlfnkj2oVCYaAo+u6RZaZad+g5zZAL
        qL958MRd9WiahuG4OshrNstqFBP8EXAhfFNRsaw6YjA+PNMgxy0QP86hdMGR8KCjjl52tTquiam
        JJHF9eHjekzOWTdNK9faL/+s7VCw0RygRJVEbYsr1LANAoTSwg8UQnAa2+QviNgI=
X-Google-Smtp-Source: APXvYqzkCyaGyRBtWf4UllraGDO7vSa/gmvBuHJarvPTSxVfu9/GCCzxD6q1D1UBeBeCzEEsUiMpvY8OzJPmew==
X-Received: by 2002:a81:af49:: with SMTP id x9mr7450557ywj.421.1571958221359;
 Thu, 24 Oct 2019 16:03:41 -0700 (PDT)
Date:   Thu, 24 Oct 2019 16:03:24 -0700
Message-Id: <20191024230327.140935-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 0/3] kvm: call kvm_arch_destroy_vm if vm creation fails
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        John Sperbeck <jsperbeck@google.com>,
        Junaid Shahid <junaids@google.com>
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Beginning with commit 44a95dae1d229a ("KVM: x86: Detect and Initialize
AVIC support"), AMD's version of kvm_arch_init_vm() will allocate
memory if the module parameter, avic, is enabled. (Note that this
module parameter is disabled by default.) However, there are many
possible failure exits from kvm_create_vm() *after* the call to
kvm_arch_init_vm(), and the memory allocated by kvm_arch_init_vm() was
leaked on these failure paths.

The obvious solution is to call kvm_arch_destroy_vm() on these failure
paths, since it will free the memory allocated by
kvm_arch_init_vm(). However, kvm_arch_destroy_vm() may reference
memslots and buses that were allocated later in kvm_create_vm(). So,
before we can call kvm_arch_destroy_vm() on the failure paths out of
kvm_create_vm(), we need to hoist the memslot and bus allocation up
before the call to kvm_arch_init_vm().

The call to clear the reference count on (some) failure paths out of
kvm_create_vm() just added to the potential confusion. By sinking the
call to set the reference count below any possible failure exits, we
can eliminate the call to clear the reference count on the failure
paths.

v1 -> v2: Call kvm_arch_destroy_vm before refcount_set
v2 -> v3: Added two preparatory changes

Jim Mattson (2):
  kvm: Don't clear reference count on kvm_create_vm() error path
  kvm: Allocate memslots and buses before calling kvm_arch_init_vm

John Sperbeck (1):
  kvm: call kvm_arch_destroy_vm if vm creation fails

 virt/kvm/kvm_main.c | 52 ++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 22 deletions(-)

-- 
2.24.0.rc0.303.g954a862665-goog

