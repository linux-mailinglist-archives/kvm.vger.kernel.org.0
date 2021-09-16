Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEDD40D490
	for <lists+kvm@lfdr.de>; Thu, 16 Sep 2021 10:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235103AbhIPIeE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Sep 2021 04:34:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234998AbhIPIeC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Sep 2021 04:34:02 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72949C061764
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 01:32:42 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id u15so8124467wru.6
        for <kvm@vger.kernel.org>; Thu, 16 Sep 2021 01:32:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dme-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oFu13wmCnF/37EBkxbUdYYt/K4h+t6Hv1eCLqfXNqes=;
        b=Sn5bheHf0iSHwsOdWoqxxUlz/J99xRxIXA+PBePH1XJ3U13n8sqi2FGOLami1rEi3j
         Rz0KgDu+5/lHtypZZ5qMzpQymLUgYOX+QPyAqOM8p8EkTyLZCd9uNNC2bvENAFdc1+Wd
         kemSVx75uManSLwFszUd+5d14iA/ca5a5TAIAJ8cuLFg9h1S6cgDbvxBjezYb/0VNYD0
         aJL0O867xX+QlTNg2JCNhMawaARUHDVHCvNEGCN3u2RbaHMzd+TAVlvCu/en1oNGvtfB
         ckTJZrvkEqZhLmFWjLFH2i4fcOsDm6vEQBjTYt0jDKfEbXCkfg1bZDYTtIqvBXJGDYFo
         5v6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oFu13wmCnF/37EBkxbUdYYt/K4h+t6Hv1eCLqfXNqes=;
        b=ffeHbsyzxe4sIQ7voXEaalwSVeUe8hIvjVNIUlD3CJbR5Q8GSiAtbkwPJ3FSPIFung
         9JQsmEEpDeoyv43aa2LNfhOJRwUteNbeNXNBJhYc/eaG6az8oAMH0fzmkfmXWOf/I5mC
         7X5/NMA8b3ZG5hWOiXskS6iFrNypgc3X0uOqmVNiMRA1LBBhA8hg7/6Je0Jb5kvKVU9B
         K+XaI4UHwnDcG0hOp/oLV7eKVg2OdsKThiqR7rpqTSVk/KU24pIaQ3UkzR6hZZKT1azT
         OUZl/Au0g1z+QwxVA85X6pyYSjUOct8tdZdYB0m9nYznnI5Y7wwwW6McAPVfGvp6+L54
         yoKQ==
X-Gm-Message-State: AOAM533clYOxI41bxIYTX27qc2jWRMByqgKlv6iqJgVw4l8L+HW7Fwpd
        AB+5PE+qroe6Fj6RRVGncbOojQ==
X-Google-Smtp-Source: ABdhPJy0sexYyoTk6Wr66xcXBOrlvZXHvHNRLDXv/Tze2AbIXg3H8e+aw5d+XRFVSUTXeqmu7LlMbQ==
X-Received: by 2002:adf:eec3:: with SMTP id a3mr4674259wrp.276.1631781161031;
        Thu, 16 Sep 2021 01:32:41 -0700 (PDT)
Received: from disaster-area.hh.sledj.net ([2001:8b0:bb71:7140:64::1])
        by smtp.gmail.com with ESMTPSA id c135sm6760024wme.6.2021.09.16.01.32.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 01:32:40 -0700 (PDT)
From:   David Edmondson <dme@dme.org>
X-Google-Original-From: David Edmondson <david.edmondson@oracle.com>
Received: from localhost (disaster-area.hh.sledj.net [local])
        by disaster-area.hh.sledj.net (OpenSMTPD) with ESMTPA id 6e8fdd15;
        Thu, 16 Sep 2021 08:32:39 +0000 (UTC)
To:     linux-kernel@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>, Joerg Roedel <joro@8bytes.org>,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jim Mattson <jmattson@google.com>,
        David Edmondson <david.edmondson@oracle.com>
Subject: [PATCH v5 0/4] KVM: x86: Convey the exit reason, etc. to user-space on emulation failure
Date:   Thu, 16 Sep 2021 09:32:35 +0100
Message-Id: <20210916083239.2168281-1-david.edmondson@oracle.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

To help when debugging failures in the field, if instruction emulation
fails, report the VM exit reason, etc. to userspace in order that it
can be recorded.

The SGX changes here are compiled but untested.

v5:
- Add some Reviewed-by (Sean).
- Build-time complaint about sizing rather than run-time calculation (Sean).
- Clarify that the format of the auxiliary debug data is undefined (Sean).
- ndata_start -> info_start (Sean).
- sizeof(variable) rather than sizeof(type) (Sean).

v4:
- Update the API for preparing emulation failure report (Sean)
- sgx uses the provided API in all relevant cases (Sean)
- Clarify the intended layout of kvm_run.emulation_failure.

v3:
- Convey any debug data un-flagged after the ABI specified data in
  struct emulation_failure (Sean)
- Obey the ABI protocol in sgx_handle_emulation_failure() (Sean)

v2:
- Improve patch comments (dmatlock)
- Intel should provide the full exit reason (dmatlock)
- Pass a boolean rather than flags (dmatlock)
- Use the helper in kvm_task_switch() and kvm_handle_memory_failure()
  (dmatlock)
- Describe the exit_reason field of the emulation_failure structure
  (dmatlock)

David Edmondson (4):
  KVM: x86: Clarify the kvm_run.emulation_failure structure layout
  KVM: x86: Get exit_reason as part of kvm_x86_ops.get_exit_info
  KVM: x86: On emulation failure, convey the exit reason, etc. to
    userspace
  KVM: x86: SGX must obey the KVM_INTERNAL_ERROR_EMULATION protocol

 arch/x86/include/asm/kvm_host.h | 10 +++--
 arch/x86/kvm/svm/svm.c          |  8 ++--
 arch/x86/kvm/trace.h            |  9 ++--
 arch/x86/kvm/vmx/nested.c       |  2 +-
 arch/x86/kvm/vmx/sgx.c          | 16 +++-----
 arch/x86/kvm/vmx/vmx.c          | 11 +++--
 arch/x86/kvm/x86.c              | 73 ++++++++++++++++++++++++++-------
 include/uapi/linux/kvm.h        | 14 ++++++-
 8 files changed, 99 insertions(+), 44 deletions(-)

-- 
2.33.0

