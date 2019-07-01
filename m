Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9FB93C52C
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 09:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404028AbfFKHeW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 03:34:22 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38471 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403920AbfFKHeW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Jun 2019 03:34:22 -0400
Received: by mail-pg1-f196.google.com with SMTP id v11so6455268pgl.5;
        Tue, 11 Jun 2019 00:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8fNYdcY99hechvTD8ARpttj/QvqTzgjVeORsIZWh0xs=;
        b=vRgavvQpYLzwzD6d+h7wpnmye62IpW4iDT3LEq2Ecqz3KDn2NUpn3Sl6ITX/3j0Qqj
         URdhE1sxJPBN0TnaNnOInjcu2+8U97kE1BvXWnE0KgGMFYsDeCX8rc8lTLeSXY/Niet2
         wf3DqZeY1V25X4S2q0DQSNGSvXM0K+PmhO2HUc40i7owNDyTgqidcXBjTbSrarBku2Am
         ysMXzcIb2n9dkD7Tq5ppCoUtDdDh5AFeSRrdrmOBMYxWdsby5U7TgmJ0D0IIKZAXvVEo
         1YLCt++2fP7xuj+rCT8g8wKe+9l9pXoVhRnjhohsa067ziMP5DQ6pNZxIOCvTlZPOqpP
         4uOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8fNYdcY99hechvTD8ARpttj/QvqTzgjVeORsIZWh0xs=;
        b=jfZd+PeSnZqk8FgvmJqMIo3y1MUTQA/HETjnrwXdiW5vt0gOFBSuBwliq10nu98Bq1
         IV8e/dYtPgEEIZileW943q8MD6ze6pLpDCEC00638M5jPYej5nbDS43neDtallB0pdww
         SZo71lcIJ4ZzRHRM4KkvRhv2OXJW6kTCv6NxtR699CD+NKbQt0YNPvAZenwht8Sin3tT
         Qxkjq9cIOipdPyu6QXp4p615VI7k88yNl01qPcoOBeZnGIBuq7dt85EjPe4hoJ6B1g+R
         6bgfpLi7cZeT6YzAqJFPJgAOQPfpiYG995/s9hMhn5EtUDJVSe1KymYU7pSgKhypRsFc
         qYOg==
X-Gm-Message-State: APjAAAUUcAmjvJ9i8m9UjkZWkKFZbXMJkytAQKvpPaWeO0ckbpL6Wm0o
        hSCPc2+/iDR7XlxD3glnraSowdqD
X-Google-Smtp-Source: APXvYqyMVooA2mZ+u1WFP1NhPY/ZacqkzaKzAvWBK3iJ5lyO0pdgyP0A/0qpmFjwEfZP1u8pZ3ud1w==
X-Received: by 2002:a63:dc56:: with SMTP id f22mr3381114pgj.305.1560238461658;
        Tue, 11 Jun 2019 00:34:21 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id 14sm6860800pfj.36.2019.06.11.00.34.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 11 Jun 2019 00:34:20 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 0/5] KVM: X86: Add virtual C-states residency msrs support
Date:   Tue, 11 Jun 2019 15:34:06 +0800
Message-Id: <1560238451-19495-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

After exposing some host CPU power management capabilities to dedicated 
instances, there is a requirement to consult current idle power-state 
residency statistics by turbostat.

This patchset adds virtual C-states residency msrs emulation. Allowing 
guest reads CORE cstate when exposing host CPU power management capabilities 
to the guest. PKG cstate is restricted currently to avoid a guest to get 
the whole package information in multi-tenant scenario.

v1 -> v2:
 * add residency msrs emulation (base on Paolo's design)

Wanpeng Li (5):
  KVM: X86: Dynamic allocate core residency msr state
  KVM: X86: Introduce residency msrs read/write operations
  KVM: X86: setup residency msrs during vCPU creation
  KVM: VMX: Add get/set residency msrs logic
  KVM: X86: Save/restore residency values when sched_out/sched_in

 arch/arm/include/asm/kvm_host.h     |   1 +
 arch/arm64/include/asm/kvm_host.h   |   1 +
 arch/mips/include/asm/kvm_host.h    |   1 +
 arch/powerpc/include/asm/kvm_host.h |   1 +
 arch/s390/include/asm/kvm_host.h    |   1 +
 arch/x86/include/asm/kvm_host.h     |  11 ++++
 arch/x86/kvm/vmx/vmx.c              |  15 ++++++
 arch/x86/kvm/x86.c                  | 104 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.h                  |   5 ++
 include/linux/kvm_host.h            |   1 +
 virt/kvm/kvm_main.c                 |   1 +
 11 files changed, 142 insertions(+)

-- 
2.7.4

