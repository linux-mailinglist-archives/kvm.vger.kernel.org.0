Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D37531E374
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 01:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhBRAW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 19:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbhBRAW5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 19:22:57 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69B37C061756
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:17 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id j4so569520ybt.23
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 16:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=IZw0ECVBlM9vyeDxDPM3cu3JxE36bgau1ZklK6oBKCM=;
        b=o//q+l0doxtqMPGEFqL/aFoXZ+/AZTyaoBBzkVBU48AKiEljEvZdMOQPZflMHfhxs6
         mVYP90gDcAUKdcknXIysP5uBenkZyzcDznZ6fN56LEWVgOW8gfpQlkyHP/co5Fc/+t8b
         T17ohirUpvdodKqqQOkTZ7Kk6Nd9jDN211M7zKy94fPRNombhl1QlwIiwG7y3v5Mz4qx
         EIRg/bCW+hDaQMU9vktK3PFCnZaTL1R8g2aY+6ka2KFRLt78xJH4jnFjtOA0HCJwyIFV
         1DJsvmO0rj9YutDoyoKfquzC5tF1mhXa8uNHBlS6qlpsFxvNGMEvLoy2K1dsxgWS+0IW
         qzOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=IZw0ECVBlM9vyeDxDPM3cu3JxE36bgau1ZklK6oBKCM=;
        b=SrBjvSOIbhe76YtWU9Jy0ssttPpEuXuuXtsRXMUUxGf6gOmeVRyRhhmJ2+iR2IlOeU
         SD9GE72Za+vxxidTL9o4MSMKiRAb6gmFhwmK2OSE0gH5BOwSWY70X8Qcmer2k3uBHPEs
         QThV56U+inw0Zz/1AJFZLLFVPNfNZ6atE18beqP6uFOftNDqqs2FUHjnkcUJijhDNQND
         OIAIM3l652fXa0JVmGpLUmkoVrtwWhI4QWPNX47k/OOG7QKZwrHoVYXLx6ASE8pMJH7S
         DtADakoAqd1UUktBhRYIx3rgZoYKK6uInmQvdQbpYamZjJyDDBedDomvuO1yXWHxhar0
         UTow==
X-Gm-Message-State: AOAM532Lk4OAVmTJlRyGb8TIOd5jli7S3UU+N5HDHsAU7AWfN7vkIJxb
        yzq6s+doqgpM22ttmH/AZbdR6z5/Bzs=
X-Google-Smtp-Source: ABdhPJyuXxO6IJnmRblKWvsaOLykVraSs3serv70iFI92zddcWDm6sHWUmPMNzmuf/8vDSc6NXkpeNIq2KE=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
 (user=seanjc job=sendgmr) by 2002:a25:4a84:: with SMTP id x126mr2878599yba.408.1613607736656;
 Wed, 17 Feb 2021 16:22:16 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Wed, 17 Feb 2021 16:22:06 -0800
Message-Id: <20210218002212.2904647-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 0/6] x86: nVMX: Unrestricted guest fix and cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Two fixes to skip (sub)tests that rely on unrestricted guest if URG isn't
supported, clean ups for related code to make triaging test failures a bit
easier. Ideally, even more info would be provided on failure, e.g. line
number, but that'd best be done as a (much) larger overhaul.

Sean Christopherson (6):
  x86: nVMX: Verify unrestricted guest is supported in segment tests
  x86: nVMX: Skip unrestricted guest (URG) test if URG isn't supported
  x86: nVMX: Improve report messages for segment selector tests
  x86: nVMX: Improve report messages for segment base tests
  x86: nVMX: Use more descriptive name for GDT/IDT limit tests
  x86: nVMX: Add an equals sign to show value assoc. in
    test_guest_state()

 x86/vmx_tests.c | 157 ++++++++++++++++++++++++------------------------
 1 file changed, 77 insertions(+), 80 deletions(-)

-- 
2.30.0.478.g8a0d178c01-goog

