Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 943C5310233
	for <lists+kvm@lfdr.de>; Fri,  5 Feb 2021 02:26:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232678AbhBEBZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 20:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbhBEBZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Feb 2021 20:25:42 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD0AC061786
        for <kvm@vger.kernel.org>; Thu,  4 Feb 2021 17:25:02 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id c12so5204649ybf.1
        for <kvm@vger.kernel.org>; Thu, 04 Feb 2021 17:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=sSBhb9eqWQBc8SXvyIWWKnWQ20mOkYO+ojRfnZ4S+p4=;
        b=RHNAftjmsyLsfPrpEGOp4VPdo6nk+wvX87kg/GaJOpUrjabdFRj0u8SCDDhDMMu9uw
         U48lkSHh2rwt5tOBbExHFkIO2wdIOsBJ2A7wLHE5iVap3wha9xqJPDb3Lk6ty2vtTcSD
         urRTwwUTAOTqTAt2j8PC1w3cQP6S6gPNjl86D5v333vaLJ74Gck8cg3TypjN1UmXHRGt
         uUXeo+xS8b+X9cpRqxGIShlz4+oike2q/ul98xHPujCK/HUNv2wXL72cnZbtcxCd+Mck
         CkYgN1HxUmuumr9Ursdo2vYzgMBwkaYcPU+++oYNPE/kvhh40QZ78mvAWHogbag2ajm9
         iuvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc;
        bh=sSBhb9eqWQBc8SXvyIWWKnWQ20mOkYO+ojRfnZ4S+p4=;
        b=uEaEIm+hQIU3gH3oIe+hZ1nIuTPiGM4EHcCLNG1zkA8zbglbmvfRHf2QPf5j8o75lf
         Lp2bqatQIT4aEnzE5/8+lELmXjOJTC7o5IEkTnI796eyh/WLv3hWSnindYyB/ER9KaoW
         i1JqiYQTm7LZAGhdZaCXge+/0emTR4jwI9RV6HBlnRxAcLHInfRpxgHupvyn6qEePEc6
         pdE+QMsLn8CPf2HyDXRddpshbZ5Gog+yLv3MpQPsUuKlIt4jDRNua3SnleMtZFfLGpjY
         LNu+EeoMx02AUKFNLWTID6R4OUJr9HKz8vGuavm+KdytEMgyU/HGn+VUUwrfikWHt5UQ
         f7MA==
X-Gm-Message-State: AOAM531m/TuzLgv69ttniZ/vGmEIDvo8WXI0ol+WZO+ArHX3rIJN9heW
        MGIFkzIGToLky0oxns+FrkyWsj0pYFs=
X-Google-Smtp-Source: ABdhPJziN3SsXUqwEPFyO64AIHF3EG4tUw5R7K+dqK292O4+gMoPnijOCVp/7rRUjdIY48PF3yD6Ee65TKk=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:f16f:a28e:552e:abea])
 (user=seanjc job=sendgmr) by 2002:a25:24d7:: with SMTP id k206mr3003839ybk.68.1612488301389;
 Thu, 04 Feb 2021 17:25:01 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu,  4 Feb 2021 17:24:56 -0800
Message-Id: <20210205012458.3872687-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.365.g02bc693789-goog
Subject: [PATCH 0/2] KVM: x86: RSM emulation DR6/DR7 cleanups
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

A cleanup and a bug fix (technically) in the RSM loading of DR6 and DR7 I
stumbled on when looking at the bus lock detect DR6 changes.

Sean Christopherson (2):
  KVM: x86: Remove misleading DR6/DR7 adjustments from RSM emulation
  KVM: x86: Restore all 64 bits of DR6 and DR7 during RSM on x86-64

 arch/x86/kvm/emulate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.30.0.365.g02bc693789-goog

