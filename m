Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98E2716AFCD
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2020 19:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgBXS4l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Feb 2020 13:56:41 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36873 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgBXS4l (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Feb 2020 13:56:41 -0500
Received: by mail-wr1-f66.google.com with SMTP id l5so7428311wrx.4;
        Mon, 24 Feb 2020 10:56:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=NnFSJ4wxz3IPiMj1BwmfM2ZfdupPqpOk/+KIyr1YuNI=;
        b=LTL1hmvY+p9SeOwCwhvc0/8d1+N5Xvl5LEmWQb6BhL4wTAq7d/jNaj1hKzHjMU5T3a
         3WId6E6jvuLSK+nx59o56vOQiXAYmJYa5hDWweuuoFQhEea+2rnx9MEsZlgy9FQxNqmE
         DKLufNfq7H9drttHAqY9Ilup3GQ3tGB8y6KrUPhp/a7VuZiM9u1PW93bD8OjMBWe4f77
         Vz1VQcEIFBSFqo8jfpOVTXSUNtMQu5suGQE2Nu1CB/vnDuispeYlKbUNjpJWT73KMnrx
         vmR99rxf/JvPHhI7VywcOFisdc85QpSoPukMe3x6V9G4kGX1sDNGXMjPuNxUARZ/D59s
         lSjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=NnFSJ4wxz3IPiMj1BwmfM2ZfdupPqpOk/+KIyr1YuNI=;
        b=AJEu3Kgem3Bo3W8gKERnO8QufKJEYY6aGRLrE/JAaq/2UcSRMUDN78dp1kels8RoGE
         K1kYCQnXA6S1vZ98JMEqfFBP+MJ2UOTH0/GpihujAmgYl1gcQoh96ufhs4JdbNyedYWQ
         pNqTHoooPxvyJdQ3AAC5Z0WjJq0rNHl00mt89iMMGIJtfl1NfBjyewTer1ZekOnIgdo6
         ja2CbW3UUwGnsDJo2l3xX67brwojlRdiyVfJlrv1wlaPF3BmX0Gb3F8+Q8B/3+4HvEd3
         5XZUKr0sv90KZaZpYCCm2rYJ4FMQb2LM/5/ZrNScKT1jh56YPQ3V3gS0oLBCYJ8R0sCi
         mLDA==
X-Gm-Message-State: APjAAAW9rgN/FYMvY2+U6kRIXTN5C0/4OnyHVDgmcJNCix9Y8NGcnVnV
        771nKaNz3OBvvcR0kd40vEUAqYxt
X-Google-Smtp-Source: APXvYqxFl7vEubY2+cyUaHD+DMOaNVtDmIUluQaMZIZnEibNMHQ66vXDhsuImjpo1M7sNxz4iDngdw==
X-Received: by 2002:adf:bbcf:: with SMTP id z15mr69057763wrg.266.1582570598470;
        Mon, 24 Feb 2020 10:56:38 -0800 (PST)
Received: from 640k.lan ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id z8sm19900838wrv.74.2020.02.24.10.56.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Feb 2020 10:56:37 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     oupton@google.com
Subject: [FYI PATCH 0/3] CVE-2020-2732
Date:   Mon, 24 Feb 2020 19:56:33 +0100
Message-Id: <1582570596-45387-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

vmx_check_intercept is not yet fully implemented by KVM on Intel processors,
causing e.g. the I/O or MSR interception bitmaps not to be checked.
In general we can just disallow instruction emulation on behalf of L1,
but this series also implements I/O port checks.

Paolo

Oliver Upton (2):
  KVM: nVMX: Refactor IO bitmap checks into helper function
  KVM: nVMX: Check IO instruction VM-exit conditions

Paolo Bonzini (1):
  KVM: nVMX: Don't emulate instructions in guest mode

 arch/x86/kvm/vmx/nested.c | 39 ++++++++++++++++++++-----------
 arch/x86/kvm/vmx/nested.h |  2 ++
 arch/x86/kvm/vmx/vmx.c    | 59 +++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 79 insertions(+), 21 deletions(-)

-- 
1.8.3.1

