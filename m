Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 253E0AB08D
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 04:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387741AbfIFCRe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Sep 2019 22:17:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55786 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728628AbfIFCRd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Sep 2019 22:17:33 -0400
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 98B6B7FDFF
        for <kvm@vger.kernel.org>; Fri,  6 Sep 2019 02:17:33 +0000 (UTC)
Received: by mail-pf1-f199.google.com with SMTP id i187so3361357pfc.10
        for <kvm@vger.kernel.org>; Thu, 05 Sep 2019 19:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aBUS+fgsamAUOZtSEp++jlkJB5YgKT1csWUc+zQUKS4=;
        b=SAK4GanL7UBxn5aJIEWoEdSWWjzycKKhl5Ts40P+9Ld5JDqxIujeBnn/DrVwRLwp5C
         odmeiM77Z/88n8sJBWN4fAoOvrRMGobpp9NP1IcWdJrn3AYs3MTOT+kKxo4HvUp54mz4
         UlGx5wWMljWpcO918Dsx72pZTHPuGzww8o8ALsaYIT53jpPwavW3a5vkrbAeM88USOjq
         juLRMLe7tn3vDzkxn/NfnkA3kl1KeIXl232Uas1BOruxi3pwBUkCxn5XQNAQrCKsO6iG
         t76LLqg8FZdcNCTAJLsfkOrhZnmg30xST3wYugvwlNPeKluUa06Chdy2ratUhhvk6HNX
         VpmA==
X-Gm-Message-State: APjAAAU0VzotCI0xi3M3oI2fbq4qcvIu+m9qrKxJcHgvqNOJYmYaUV8Y
        FzwFGpl+BdJ5lqOhHSs8tcBl3p/6tV0pckjCWbv4d77NDgX3BB3NQWqsB/kH1UoFZmmWeZiiIMS
        QmKfrdt9bzdNF
X-Received: by 2002:a62:e717:: with SMTP id s23mr7759987pfh.71.1567736253137;
        Thu, 05 Sep 2019 19:17:33 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzCQJM/WuwJ79nbWX4bQwimjvaO+Ug+0hsWoiE4Vf9iu3itMcfU3iYer2r464k1bCxIb1dlRA==
X-Received: by 2002:a62:e717:: with SMTP id s23mr7759963pfh.71.1567736252846;
        Thu, 05 Sep 2019 19:17:32 -0700 (PDT)
Received: from xz-x1.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a11sm8212359pfg.94.2019.09.05.19.17.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 19:17:32 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>, peterx@redhat.com
Subject: [PATCH v4 0/4] KVM: X86: Some tracepoint enhancements
Date:   Fri,  6 Sep 2019 10:17:18 +0800
Message-Id: <20190906021722.2095-1-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v4:
- pick r-b
- swap the last two patches [Sean]

v3:
- use unsigned int for vcpu id [Sean]
- a new patch to fix ple_window type [Sean]

v2:
- fix commit messages, change format of ple window tracepoint [Sean]
- rebase [Wanpeng]

Each small patch explains itself.  I noticed them when I'm tracing
some IRQ paths and I found them helpful at least to me.

Please have a look.  Thanks,

Peter Xu (4):
  KVM: X86: Trace vcpu_id for vmexit
  KVM: X86: Remove tailing newline for tracepoints
  KVM: VMX: Change ple_window type to unsigned int
  KVM: X86: Tune PLE Window tracepoint

 arch/x86/kvm/svm.c     | 16 ++++++++--------
 arch/x86/kvm/trace.h   | 34 ++++++++++++++--------------------
 arch/x86/kvm/vmx/vmx.c | 18 ++++++++++--------
 arch/x86/kvm/vmx/vmx.h |  2 +-
 arch/x86/kvm/x86.c     |  2 +-
 5 files changed, 34 insertions(+), 38 deletions(-)

-- 
2.21.0

