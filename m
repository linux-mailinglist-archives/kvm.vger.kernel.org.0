Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF4FE9135
	for <lists+kvm@lfdr.de>; Tue, 29 Oct 2019 22:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbfJ2VGF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 29 Oct 2019 17:06:05 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:46048 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725840AbfJ2VGF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 29 Oct 2019 17:06:05 -0400
Received: by mail-pg1-f202.google.com with SMTP id v10so12014900pge.12
        for <kvm@vger.kernel.org>; Tue, 29 Oct 2019 14:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=IOHjvz17CQBJcXRDm1CfUJG5TnoeR6CvrHThpcD2pHY=;
        b=JRcLNfKlLThQcDKj7JDVFoXkvmsLM+1ynya2CQz8HdtbzDj5Rm1qqOlualkmt6SvnC
         oKvHKoZqoxPExDrloXHW5NPwC1aMAVgKZD0GFsV+idgyrAjXpaAGdNw7u/xjCoOmL8ss
         e9uUVeBhBZFNbe3fGqdOZw7Ce0KDDo1dEycYsGAmoyHqMCc/FBjxLtGoPgN6YZhIRSIZ
         0kl3JvAZpcu0OiYKB5N0i62I6bQjDD/LlNOCNMNIcSIpNikPf7Qyd7ecGHwKnqm6f3Ey
         5xKUD1sC3PQ7ZI7pQHWak+EHsYf0VJP83IrRH1MzT0NBLFYpO4GPj4r3EBLHchDAhq5/
         ULIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=IOHjvz17CQBJcXRDm1CfUJG5TnoeR6CvrHThpcD2pHY=;
        b=Yom1FnAmzIWzJ9bjea/+VTn94xIrZ8hY2Dl9gdpCncyfJqfWFGWOlu2fENUuJVEn9D
         1+tm06s1j7aWtVHEB60uDtWKFhPZ8ya9UfmTQ3jIlflEoEPSxN3Y2P5RYe5Jz9Hk30E4
         4N4uO4n/XrDYU1TxgtYNhwdLNruF9Af5sO+ciinBI12moelTNgbhZJvIfvFyybDedF/z
         4pv553fX0WHohI6+SbZmbKxvXKQbK41ZxezV2SQwreMmKa55CrdlBcZsTRJxye/JpbZi
         MiYqbkhVmOSvjpGRCjTyK8fXvPMENpoYlxGPfQDixUGu45RUWSDP0v4DdjoZeWC5QYig
         Id8w==
X-Gm-Message-State: APjAAAXEmGskkZcXfKEdvrkGG3yGJYXcmlrwUScMFdPHpoEoI6Sdxg65
        4Ukmm3jjf6SnYcW+a9dQdskzgfS+3x6iiG4JyBVBWZ901/srwyPPTD1Qv6hUz7LPP9eUcgFZ0Ou
        CUMgoJWx+If74XXZmZ0dwpVuNVkPLCc5azTJuQQRoqpxU++GCq18cAlblBS9Y5csf2VSf
X-Google-Smtp-Source: APXvYqwcUGFDYsfoEvI2ABJLun3RY+8ptJ/53Df4lFdCtQg8J67Cw1TZo+Nsul7/D/ELVh8NGhVFGgY1ZWugoy8D
X-Received: by 2002:a63:1042:: with SMTP id 2mr16848851pgq.59.1572383164544;
 Tue, 29 Oct 2019 14:06:04 -0700 (PDT)
Date:   Tue, 29 Oct 2019 14:05:51 -0700
Message-Id: <20191029210555.138393-1-aaronlewis@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH 0/4] Add support for capturing the highest observable L2 TSC
From:   Aaron Lewis <aaronlewis@google.com>
To:     kvm@vger.kernel.org
Cc:     Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The L1 hypervisor may include the IA32_TIME_STAMP_COUNTER MSR in the
vmcs12 MSR VM-exit MSR-store area as a way of determining the highest
TSC value that might have been observed by L2 prior to VM-exit. The
current implementation does not capture a very tight bound on this
value.  To tighten the bound, add the IA32_TIME_STAMP_COUNTER MSR to the
vmcs02 VM-exit MSR-store area whenever it appears in the vmcs12 VM-exit
MSR-store area.  When L0 processes the vmcs12 VM-exit MSR-store area
during the emulation of an L2->L1 VM-exit, special-case the
IA32_TIME_STAMP_COUNTER MSR, using the value stored in the vmcs02
VM-exit MSR-store area to derive the value to be stored in the vmcs12
VM-exit MSR-store area.

Aaron Lewis (4):
  kvm: nested: Introduce read_and_check_msr_entry()
  kvm: vmx: Rename NR_AUTOLOAD_MSRS to NR_MSR_ENTRIES
  kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
  KVM: nVMX: Add support for capturing highest observable L2 TSC

 arch/x86/kvm/vmx/nested.c | 126 ++++++++++++++++++++++++++++++++------
 arch/x86/kvm/vmx/vmx.c    |  14 ++---
 arch/x86/kvm/vmx/vmx.h    |   9 ++-
 3 files changed, 121 insertions(+), 28 deletions(-)

-- 
2.24.0.rc0.303.g954a862665-goog

