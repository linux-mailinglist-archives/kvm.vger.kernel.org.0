Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0F63CB2B
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 14:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388724AbfFKMXz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 08:23:55 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46572 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387819AbfFKMXz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 08:23:55 -0400
Received: by mail-pl1-f193.google.com with SMTP id e5so5048500pls.13;
        Tue, 11 Jun 2019 05:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=S6E4fnfKg2PQMNcTqAJHM3s5iQjmeIMjLc7FOAXQvIk=;
        b=KQoriXED/cOULGKOU/MyBtAi3mtQLr+6ZtQiq6YotiiSKob1bkbBpuUI4IXs+bBplT
         IqiYA6qA0A4i5JscLQpO2VFwLyfubmsxg1axsKpI+sMBemLTWZrH5IfxI5DH3ePvOtlW
         DErua+hSwBSmtFq1h5yBAqSw/kuLqkVT+r0mwXp3go2I5hWHJ0rHs0IFKZwCjWhk9+Yi
         CFyOo39pRCzW8e4WnGPVyGr9R2Fl3nWIue+4If9KDtjoui+zFC00U13WTn5ObzUWwbnL
         HXuZEuq9gVzVo18fYfPXVUFDZ2Kq9eEvfUhk2FcfhGtovE1CSgWqapLrL6RdbmWGGadF
         DjXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=S6E4fnfKg2PQMNcTqAJHM3s5iQjmeIMjLc7FOAXQvIk=;
        b=F1D0k6+KI5lA/3Uqdfw/C0l6yXHhpRSSqFwyom6YX3aMTNvirUiIR6o7XafyAZZyx5
         7OUSt+9Sgwcm1SdMohysPr2BrAaYLwfycGk12JPd/+GyMDoftw8dgirhfCC/OX9PmjRW
         bM8bstjGfo7k1Ez+j9eOZ0xN6Y5Lf3BvbdSM6dm11nCTxGLMR6X+caAfdv0XyASyB3Y+
         gZXzkMRF9Y1HxvP69imRLhKx0SK6qejqS+PD0c4/r4YN+iPil9e8PfajaB16brDYSHFN
         an3JMjVw5YX42GdOXty6LiEftlRbC9A5xldRkIbyMaWb1g9rtE3UPKG+mkm0SoC7d1lJ
         n3Vw==
X-Gm-Message-State: APjAAAVl4MqLX/orwbrQmk/+5o2kmLrvsW8ivuluNqgP7CEG7YtNS3lc
        ucJ6emsW26g6wZiRUsO9GMswCurl
X-Google-Smtp-Source: APXvYqx2A8jKxj2VDwTcL3qog/BOd0BYQZDLbWb3RkFbnxtCf7vSRHkZvO7ti+niFvrccaGD4N8Ppg==
X-Received: by 2002:a17:902:7e0f:: with SMTP id b15mr67918140plm.237.1560255834729;
        Tue, 11 Jun 2019 05:23:54 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 127sm14832271pfc.159.2019.06.11.05.23.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 05:23:54 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v4 0/3] KVM: Yield to IPI target if necessary
Date:   Tue, 11 Jun 2019 20:23:47 +0800
Message-Id: <1560255830-8656-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The idea is from Xen, when sending a call-function IPI-many to vCPUs, 
yield if any of the IPI target vCPUs was preempted. 17% performance 
increasement of ebizzy benchmark can be observed in an over-subscribe 
environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function 
IPI-many since call-function is not easy to be trigged by userspace 
workload).

v3 -> v4: 
 * check map->phys_map[dest_id]
 * more cleaner kvm_sched_yield()

v2 -> v3:
 * add bounds-check on dest_id

v1 -> v2:
 * check map is not NULL
 * check map->phys_map[dest_id] is not NULL
 * make kvm_sched_yield static
 * change dest_id to unsinged long

Wanpeng Li (3):
  KVM: X86: Yield to IPI target if necessary
  KVM: X86: Implement PV sched yield hypercall
  KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest

 Documentation/virtual/kvm/cpuid.txt      |  4 ++++
 Documentation/virtual/kvm/hypercalls.txt | 11 +++++++++++
 arch/x86/include/uapi/asm/kvm_para.h     |  1 +
 arch/x86/kernel/kvm.c                    | 21 +++++++++++++++++++++
 arch/x86/kvm/cpuid.c                     |  3 ++-
 arch/x86/kvm/x86.c                       | 21 +++++++++++++++++++++
 include/uapi/linux/kvm_para.h            |  1 +
 7 files changed, 61 insertions(+), 1 deletion(-)

-- 
2.7.4

