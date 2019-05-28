Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94EBF2C097
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 09:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfE1HvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 03:51:11 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40362 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfE1HvK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 03:51:10 -0400
Received: by mail-pf1-f195.google.com with SMTP id u17so10960002pfn.7;
        Tue, 28 May 2019 00:51:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gYEx0O9ga7gmezM3UNZfMFOuMaxOrET+sxlSycHSkpM=;
        b=Spvfdfdf5+Hi2ME1dkkbMVU8kp4BoweT58Z1VEE9RMlUgy8GpnZD+AUdy5k3qvw8ym
         gIy4ALuQ5dY+KnR6zwSy5ch77NxR/ksaw/yLMJHWimaS2BZ6O96vVQQYDh8jBdHCUH/4
         as9FjWWRyM4L4aKAexJG4dburCrm34tOvrhAakfzJkLGs30ACmoHl1nSPnI3dq4FX/Ax
         6r+aGBs0ir/gjSAZJWw7MHkHK+hwDQekbYudbKDvCjlDXVk0L5Cq1G6jknYbE0GLSBfN
         6OCx6w0tVYPMjBl4YgVddiF4L5JHloBhpKjczFSNmbhzgupE2r2mHedu50fTIgK4cTdQ
         0tUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gYEx0O9ga7gmezM3UNZfMFOuMaxOrET+sxlSycHSkpM=;
        b=j6oFoSKwMlY1TmdIlxjE/vEamkF8xWu9GGNWTvOC78EMYJ5dIRd5G3CyJgGL6i2EDN
         Kv6VN7hcs8Xfkqx+TSLr5jZbXp95FfyNkDC6znMMS+RGDJUWjmieuCTf71oKlPxzltFR
         2ysevLUaB7ozYCCmML98k4Dm2sDvfTbGyaJQN1VJnJvHmt6ESPWF5jJSko2TnUkMbV7X
         RWUA5m9PEDYI6bwHePcrK0uVxoe2BlIbchAVQGBgRhb8hGkjPPRVEGDgPxGS/P9yMAFq
         HieWt7y1HRaZW1lOC6uOhRVUGzh9x7ftq6GOCrQetQIbHUizAr5wAJhDk/lKtjmD4p8i
         y+hw==
X-Gm-Message-State: APjAAAXUsE9pNNMbzBJG272CCtFJnWfYlC8CNpmRDSUVi8w3Z7eqy7XD
        smWlfeQ5BWpebywNPMwSDgJqgMJc
X-Google-Smtp-Source: APXvYqwj+NMpZ1s2uvQ6p3HZ/6VzNBEgzCObP3JqgJ8XjZRHDT3HlFY5f5ns5FEetoV9q50P8zcIdg==
X-Received: by 2002:aa7:951c:: with SMTP id b28mr120419717pfp.99.1559029869814;
        Tue, 28 May 2019 00:51:09 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id q20sm18201400pgq.66.2019.05.28.00.51.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 28 May 2019 00:51:09 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH RESEND v2 0/3] KVM: Yield to IPI target if necessary
Date:   Tue, 28 May 2019 15:50:54 +0800
Message-Id: <1559029857-2750-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559004795-19927-3-git-send-email-wanpengli@tencent.com>
References: <1559004795-19927-3-git-send-email-wanpengli@tencent.com>
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

