Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 641252C0BB
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 09:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfE1H4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 03:56:40 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46317 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1H4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 03:56:40 -0400
Received: by mail-pl1-f194.google.com with SMTP id bb3so378363plb.13;
        Tue, 28 May 2019 00:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=gYEx0O9ga7gmezM3UNZfMFOuMaxOrET+sxlSycHSkpM=;
        b=a7dq5luQaniRgSsf0ayiW5h+fJUP4Vmxrwo6U6SNNBBFHwBpqUASrwsP+754vmwsED
         pcC9bV90BsjkcHWVpiZmMYOXDzIXd7UMk6NaKt4y1AyvdGj2M9V6fV9M7qdP9Ebbg1wv
         kXZs31+QMzqil0gT8AwFtEXGclS2P5x0qgMXIF/VeyG3UObSOMpACD8WdnvlyzOPWuhk
         eze1GIBRIEICPw5YoQ9UBSQN1Wx3y380llfWB7LZCec29Q/+UyAMtjhb/bL8mW6fwOMF
         y9R9ApRr7TVpyoDan0nm5r/CB5Wf74I5KWNTTTEohVynll7c9upaGdBlAjNj+HWcfD8U
         NTbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=gYEx0O9ga7gmezM3UNZfMFOuMaxOrET+sxlSycHSkpM=;
        b=VKR0cHHMWaNxCy1dteY2FX8y3TQiWg3nTb49KCch/rFdY5UB0l6dEtPAng6DEVGBvR
         LTamAoEv8DTe+dBdLh7SdrourXiUk7HUh0XZ9AxyAukxWhX+RL+xRMHHeQRK9q3JmMyW
         JEhpnULjs1VZXUxJBgQVXan66Fz9unaSifXPwyDZnlBOy+sjqF5EBXsQegtm2TnEKe4y
         GMUV3fOB76w4Ph8l8UPJJ08lLTPW0osSteS7aAQw570sbeAaYhoxP0Jqt1hCpmjvX/hk
         Mi/P0WuipnW7Cn0sj9WTNnlxOENZrsVea8j2u3Wk722Y3HBr1nuQpBo2tUUDfrYwWHy3
         OkwQ==
X-Gm-Message-State: APjAAAWcbRax2HRi54fIdPu18IoY7a+DCs/5ioP6LUlqciL7kNVyNzB/
        SGZVDA9XJVH5Y6XBqWVzuVqSLAn2
X-Google-Smtp-Source: APXvYqwtJCydhoAd/g0sCuuMctnI6P+onxHmBK/HiXonWEV3tU9YsQwCts33jXs/ju9nbNwHFHEgFA==
X-Received: by 2002:a17:902:2c43:: with SMTP id m61mr24654147plb.315.1559030199892;
        Tue, 28 May 2019 00:56:39 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id t64sm2906920pjb.0.2019.05.28.00.56.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 00:56:39 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND v2 0/3] KVM: Yield to IPI target if necessary
Date:   Tue, 28 May 2019 15:56:32 +0800
Message-Id: <1559030195-2872-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The idea is from Xen, when sending a call-function IPI-many to vCPUs, 
yield if any of the IPI target vCPUs was preempted. 17% performance 
increase of ebizzy benchmark can be observed in an over-subscribe 
environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function 
IPI-many since call-function is not easy to be trigged by userspace 
workload).

v1 -> v2:
 * check map is not NULL
 * check map->phys_map[dest_id] is not NULL
 * make kvm_sched_yield static
 * change dest_id to unsinged long

Wanpeng Li (3):
  KVM: X86: Implement PV sched yield in linux guest
  KVM: X86: Implement PV sched yield hypercall
  KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest

 Documentation/virtual/kvm/cpuid.txt      |  4 ++++
 Documentation/virtual/kvm/hypercalls.txt | 11 +++++++++++
 arch/x86/include/uapi/asm/kvm_para.h     |  1 +
 arch/x86/kernel/kvm.c                    | 21 +++++++++++++++++++++
 arch/x86/kvm/cpuid.c                     |  3 ++-
 arch/x86/kvm/x86.c                       | 26 ++++++++++++++++++++++++++
 include/uapi/linux/kvm_para.h            |  1 +
 7 files changed, 66 insertions(+), 1 deletion(-)

-- 
2.7.4

