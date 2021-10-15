Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3E242FC9B
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 21:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242867AbhJOT5r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 15:57:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242885AbhJOT5k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 15:57:40 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501FFC061762
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 12:55:34 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id 3-20020a620603000000b0042aea40c2ddso5835371pfg.9
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 12:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=AQtwMkAN6RIacLrfP95J4zhWg+cIFXMthO24YBuPpP4=;
        b=R1dDK79U22h3COidmWFINo/AGS4RSc0MNL5vJYdJLRut7EcPI3boDw7Heo37MimYC+
         uRreF9B2HlRP1jvAJH6edBTh+qM8379gYN88Bqgbk7WPkArtTnxJLUh+0LgELACj/Ly9
         KiTXQ/gyaib+PLipb1+SaU/jVlbu3sDWI1aGAVglIpIVsf4Nobo1x0/czRCv++ONxN3h
         lX8Jr+33zg+/60mJWbZeBEA5v36YL2NTsIJQKAyRo9Eevanb3T4EfJZ/8xclFOvIewQL
         fpA33/kCu8Qw2h5TNPGq5RMvkgjJrNXZzfasogD+rwutVuUzOl16ykkHlftKk3XjQrv7
         R9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=AQtwMkAN6RIacLrfP95J4zhWg+cIFXMthO24YBuPpP4=;
        b=qQgAWY+VPeSNje8n1+0LnRXzRuQmgj6lV+gDXrgn3LJAPfBR6tMNilsKc4sXNETMll
         JFb18kggdfi0LZ7KNa4uY7pH83c1DLhWq2ikhSwKDaOFcR9U7IIQGvhjRYEKkI+YkmaK
         jAXAKRLEIYiDbTuK1PjBXKcnaWxQYaxYb4qRonytBu3uFt5/0b38Dbdwg+dqrpDSzgJP
         qA+daupQSnnCoTwpYwIJfXebaI2Y6twu09rUsohzWP6EfuVr6bUXWGudRidO8KJeOfyL
         YvdeTADyE0ewkZU7VCSakHQ9l1T9iFxB6fkPE9eDOKt2CX1vA6AgFqO9ciG1WdGqEpP2
         MHjA==
X-Gm-Message-State: AOAM533CpE194VLeNaaMHDbfaewG7tf3XaGE9iA7QB/m054LjL9h/FqR
        ObVlOOIFns2W9NAtY/xa0t4oqd2T7GHetXVrEOEpMPcfBYLYPRTVgaL1s2S1KIkkNh2gvxq8tYB
        SuR4dsRlk08aWDvAxIy2fua01OL2cBRID1KTVA00aIni3fkezjhCShTcw0zJaW9c=
X-Google-Smtp-Source: ABdhPJwEy8e6z8uK8FwBGqNaW59YpUk/vmLAJaEUutl1ltk3kPUvyol9lHd/KppMBVdZqe3Yk0NbuRXxO+SInQ==
X-Received: from tortoise.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1a0d])
 (user=jmattson job=sendgmr) by 2002:a17:90a:ec14:: with SMTP id
 l20mr69269pjy.0.1634327733364; Fri, 15 Oct 2021 12:55:33 -0700 (PDT)
Date:   Fri, 15 Oct 2021 12:55:27 -0700
Message-Id: <20211015195530.301237-1-jmattson@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [kvm-unit-tests PATCH v2 0/3] Regression test for L1 LDTR persistence bug
From:   Jim Mattson <jmattson@google.com>
To:     kvm@vger.kernel.org, pbonzini@redhat.com
Cc:     Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In Linux commit afc8de0118be ("KVM: nVMX: Set LDTR to its
architecturally defined value on nested VM-Exit"), Sean suggested that
this bug was likely benign, but it turns out that--for us, at
least--it can result in live migration failures. On restore, we call
KVM_SET_SREGS before KVM_SET_NESTED_STATE, so when L2 is active at the
time of save/restore, the target vmcs01 is temporarily populated with
L2 values. Hence, the LDTR visible to L1 after the next emulated
VM-exit is L2's, rather than its own.

This issue is significant enough that it warrants a regression
test. Unfortunately, at the moment, the best we can do is check for
the LDTR persistence bug. I'd like to be able to trigger a
save/restore from within the L2 guest, but AFAICT, there's no way to
do that under qemu. Does anyone want to implement a qemu ISA test
device that triggers a save/restore when its configured I/O port is
written to?

Jim Mattson (3):
  x86: Fix operand size for lldt
  x86: Make set_gdt_entry usable in 64-bit mode
  x86: Add a regression test for L1 LDTR persistence bug

v1 -> v2:
  Reworded report messages at Sean's suggestion.
  
 lib/x86/desc.c      | 41 +++++++++++++++++++++++++++++++----------
 lib/x86/desc.h      |  3 ++-
 lib/x86/processor.h |  2 +-
 x86/cstart64.S      |  1 +
 x86/vmx_tests.c     | 39 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 74 insertions(+), 12 deletions(-)

-- 
2.33.0.1079.g6e70778dc9-goog

