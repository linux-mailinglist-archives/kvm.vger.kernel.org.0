Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA8002BC99
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 02:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfE1AxW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 May 2019 20:53:22 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:39224 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727090AbfE1AxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 May 2019 20:53:21 -0400
Received: by mail-pf1-f195.google.com with SMTP id z26so10363896pfg.6;
        Mon, 27 May 2019 17:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9R1WAZubBwPCR81iFE++dlM75mJQ0BWis768i1AheyQ=;
        b=aQ7QryN98mFHPQd87mss4e5b3vsnVABZEwQBVz80fGJxQYJe2RLCAzUVnHay3gzm7B
         ezZC6l/EkEBUX83OmRhFdKR6qBX1qJ9GxkIK8Ooea2exUt11TGoAwIpvK7zAv0M2tH5v
         QYBPEZhkdy+WerGDjwGqwhxsgkUGuP+WgGCalyi6gfRlkDmM+W2j+Qm9vrcCHMIj01Qh
         j5qHn6wBg0cEjJLaanbRWU6Z+moKdlJNNtWKNdeRcI2GM9p15zdXjfHdoMmqD5BsRYq3
         hSyJjySIreFJ9fqGHRsy6KORXdi5nHpG6HTl5mYxDgRO7ZL7H1hNZhP00QhiwQfuvDX1
         e1pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9R1WAZubBwPCR81iFE++dlM75mJQ0BWis768i1AheyQ=;
        b=ViuxJDHKvm+UzKfwCDDtqofyDPx5/CUhnq2Y32oo+saYizghi8g0FoYHrIDIBZgAe4
         vWAMSZ29y24LEYZLW9WWQa4773eB7wTtNZvV5vUYwrOX4E+JxrY/mdsc9Ai/j+FYSruW
         0CuolrEvFI/X/K510p/geUBTvtc++pEaOTCvtb4n+/GsijVJSpN3zW25liSJ8gxlMPnJ
         W71CMHKfUGwu1E7uUNcLZqfYHgMiW0AObIaHBh/JEbAvEVy0sZleXPeAvC5u2GFhIhDe
         rv/7j3awhLdgzOy5pLh1SnW6s2QU12051OPTb3j7asgTkF0Y+GdwXbZKv/RohwhBJ1w9
         4ZGA==
X-Gm-Message-State: APjAAAU3MjKNxD9m6Su6j0z8E5YWXqO4I6hnXBb5AXede/pU14B5GzhE
        IW4AeRSwBjwHXyycbDhAQwQ53Hdz
X-Google-Smtp-Source: APXvYqyb0nsoOviH5wvyfq9oN1H84zgp8otgAU7tkS+7IAShLo6aJ1WjP8ntxlYdPJc1JenYbnqn+g==
X-Received: by 2002:a65:41c6:: with SMTP id b6mr63469503pgq.399.1559004800890;
        Mon, 27 May 2019 17:53:20 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id f16sm622085pja.18.2019.05.27.17.53.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 27 May 2019 17:53:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 0/3] KVM: Yield to IPI target if necessary
Date:   Tue, 28 May 2019 08:53:12 +0800
Message-Id: <1559004795-19927-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The idea is from Xen, when sending a call-function IPI-many to vCPUs, 
yield if any of the IPI target vCPUs was preempted. 17% performace 
increase of ebizzy benchmark can be observed in an over-subscribe 
environment. (w/ kvm-pv-tlb disabled, testing TLB flush call-function 
IPI-many since call-function is not easy to be trigged by userspace 
workload).

v1 -> v2:
 * check map is not NULL
 * check map->phys_map[dest_id] is not NULL

Wanpeng Li (3):
  KVM: X86: Implement PV sched yield in linux guest
  KVM: X86: Implement PV sched yield hypercall
  KVM: X86: Expose PV_SCHED_YIELD CPUID feature bit to guest

 Documentation/virtual/kvm/cpuid.txt      |  4 ++++
 Documentation/virtual/kvm/hypercalls.txt | 11 +++++++++++
 arch/x86/include/uapi/asm/kvm_para.h     |  1 +
 arch/x86/kernel/kvm.c                    | 21 +++++++++++++++++++++
 arch/x86/kvm/cpuid.c                     |  3 ++-
 arch/x86/kvm/x86.c                       | 24 ++++++++++++++++++++++++
 include/uapi/linux/kvm_para.h            |  1 +
 7 files changed, 64 insertions(+), 1 deletion(-)

-- 
2.7.4

