Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9F11935CB
	for <lists+kvm@lfdr.de>; Thu, 26 Mar 2020 03:20:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbgCZCUP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Mar 2020 22:20:15 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41192 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727575AbgCZCUO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Mar 2020 22:20:14 -0400
Received: by mail-pf1-f195.google.com with SMTP id z65so2017765pfz.8;
        Wed, 25 Mar 2020 19:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JT7flklXnR9y13ubSQU0XF0F5XqUE8uC8TpkRKKiqsw=;
        b=c6UAd3xFeyAjUUmmzvO4WGQgXQua4ldyW9QU+tclp4D7MCELOPbywWJuMoY9Y4tyJU
         Fw07JwnKJeMyetrfHMxnG+VEZG6m5BeMAmWuuiyNZ2A8UQLdcwBZnhIzsy3U9Dc4MBue
         h/KyE2EPUn+UCmVDqVNvBrKvZn7ndRSkkXopoqYmThPX5wwPmBxmHcI1rnvw5u0D9tZt
         T1OTQ9XZndCBp4BaF7xzpGayKaRAkwlaOpxdfKvjquxMjSxJLvP6wQ+xFLiOrL7xIBi7
         lJUV2+WAktRs0dorfqsprEArlRBao1sTI+kDnPtRxFxWvSMEsanRdrnUuUvmUpkxRZ/a
         Wqbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JT7flklXnR9y13ubSQU0XF0F5XqUE8uC8TpkRKKiqsw=;
        b=Hps3wjIYxBdGArotv6qwpERbKXiDQ7V6K8pKJviGeItsqvzyK/+lU6X8GV0wd/Es9x
         mDxjMnWiM3pYxT8qVuAXwAqLlYToNNe7WY3UuozKoIV5tO3Pm6zayHAb1uUkmimUBtlo
         R5RWe5MshPpmWAfx1O+ZP8BQFLzqPijCXdSzXTbZRkyNoTAXk6H4GTWjmol/yDBQoZPt
         5OppJ3h54oe++ggU19o9geW/jJd7nbGNRfv7cuT8EfIQwr9VvSOK5SGT6XB526oa/uX8
         SG5ydYZESKvdZAWdPB7STULwwyzy1Yuun91SIwGdfV/LDeJO1p+5zjYlMHeKaIkL9g/U
         fkEQ==
X-Gm-Message-State: ANhLgQ1HwDgNseKSc99oCF82aocGiflgVoEuIgqBOIa6bNVZfCo4Okes
        mfr09EzXPNKo5DtU0UpK1X8wC9yw
X-Google-Smtp-Source: ADFU+vvvdmFKfJ9kw1Zhagg2kWtFubF0zTbVzMrj9gWMRdEFRNeF+APUerHkEToqK6BiKZWaTdoqYQ==
X-Received: by 2002:a63:7515:: with SMTP id q21mr4951638pgc.46.1585189213598;
        Wed, 25 Mar 2020 19:20:13 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.6])
        by smtp.googlemail.com with ESMTPSA id mq18sm452975pjb.6.2020.03.25.19.20.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 25 Mar 2020 19:20:13 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 0/3] KVM: X86: Single target IPI fastpath enhancement 
Date:   Thu, 26 Mar 2020 10:19:59 +0800
Message-Id: <1585189202-1708-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The original single target IPI fastpath patch forgot to filter the 
ICR destination shorthand field. Multicast IPI is not suitable for 
this feature since wakeup the multiple sleeping vCPUs will extend 
the interrupt disabled time, it especially worse in the over-subscribe 
and VM has a little bit more vCPUs scenario. Let's narrow it down to 
single target IPI. In addition, this patchset micro-optimize virtual 
IPI emulation sequence for fastpath.

Wanpeng Li (3):
  KVM: X86: Delay read msr data iff writes ICR MSR
  KVM: X86: Narrow down the IPI fastpath to single target IPI
  KVM: X86: Micro-optimize IPI fastpath delay

 arch/x86/kvm/lapic.c |  4 ++--
 arch/x86/kvm/lapic.h |  1 +
 arch/x86/kvm/x86.c   | 14 +++++++++++---
 3 files changed, 14 insertions(+), 5 deletions(-)

-- 
2.7.4

