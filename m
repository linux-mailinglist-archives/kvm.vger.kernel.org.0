Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B41B63197D7
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 02:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhBLBHq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 20:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230013AbhBLBHJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 20:07:09 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EF4C061797
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:10 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id h192so7914363ybg.23
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=XSE9ZrAc8g6z+kr2mmzp2erRamwsfZu1yo7TcWAeNjo=;
        b=PgAH98OVFY+muhTisqBwkN9mWpeeU4YRWdNAOhVL7M6j9ocfLNArMyMUAlJ+Mb1zpH
         0lJ/lzWXvyocsilDVzTsxmQuRGMQRQlRapBPUC/EtdHrc3UsB/B203t/DNCT+NVYyO9b
         PMMW3ADJF51w6Wr8Mzw9hBqdIgxpN4H5YcXE6bxjug7N3cYJqVdwIls2cYIVd+vGFZcy
         QArm6XFEjpfXOmzJQJzOIzZjGigBEiBHpqD1baBiDafqQN+DnVGIwSQt6ivOhmPG4aRZ
         poej0net+cT78GCzPcJQkuATHptsZLwdgIkjw0cDe4TrjEDWtwQgJa3jh7zO+lzlh4wD
         HkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=XSE9ZrAc8g6z+kr2mmzp2erRamwsfZu1yo7TcWAeNjo=;
        b=CYCYcRaDc+Q/jpKJ57NIxF1kEQ65u8B3ArjKKNi632vbA5Qg5aCK2zrJPTRXjeu6xc
         dYmTFW9cIj7aYSRTqJVIpR2EYWx2fHWxsPMdD8UNyeFS6Ok8rwsbfUldQuSOOhlPuCew
         5kP0j/dk1pNIZZCZIy9DwOgFK6BxXXX+1yjhOtkQ8OdSV+t0CGkEEaH7IUMz5iNM3QoT
         138gMKZRBOei0XW1lQXQX3Yqxk8elCi74cEAVW0s1b76R1NdlffEj4ue9hfWzPy8AaBK
         uQRBabUkN9S59s3mB2SneGSoR+n6I6qSJtzrAfCNfzwVbGkWTHe5BoQhNhZfTA9eQWEX
         BMEA==
X-Gm-Message-State: AOAM533ABPbzZph20WL51jEb8xuYMKoeA+RVH1wgPYXwGZRcRlM/ZFmW
        iAXjpUNsY8/C6eyVYbedTHx67iAVWiw=
X-Google-Smtp-Source: ABdhPJwnp9WGWat8xRMUdoap4+ViiSwDKbuBcydP/Bk/jZStDqZmcXtxOP14L2BiPWGnEYjtXJRWhfAbGbk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f588:a708:f347:3ebb])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1d2:: with SMTP id
 u18mr801490ybh.103.1613091970057; Thu, 11 Feb 2021 17:06:10 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 11 Feb 2021 17:06:02 -0800
Message-Id: <20210212010606.1118184-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [kvm-unit-tests PATCH 0/4] x86: PCID test adjustments
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Adjust the PCID test to remove the enforment that INVPCID is enabled iff
PCID is enabled, and add explicit coverage of the newly allowed scneario.

Sean Christopherson (4):
  x86: Remove PCID test that INVPCID isn't enabled without PCID
  x86: Iterate over all INVPCID types in the enabled test
  x86: Add a testcase for !PCID && INVPCID
  x86: Add a 'pcid' group for the various PCID+INVPCID permutations

 x86/pcid.c        | 35 ++++++++++++++++++-----------------
 x86/unittests.cfg | 10 +++++++++-
 2 files changed, 27 insertions(+), 18 deletions(-)

-- 
2.30.0.478.g8a0d178c01-goog

