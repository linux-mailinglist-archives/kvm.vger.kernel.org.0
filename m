Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D77B940B9A2
	for <lists+kvm@lfdr.de>; Tue, 14 Sep 2021 23:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234140AbhINVLM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Sep 2021 17:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233952AbhINVLM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Sep 2021 17:11:12 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C3CC061574
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 14:09:54 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id u19-20020a05620a121300b0042665527c3bso933279qkj.14
        for <kvm@vger.kernel.org>; Tue, 14 Sep 2021 14:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:message-id:mime-version:subject:from:to:cc;
        bh=HhHNmLA8REYhOuJC0vm+kLsXG9Lm4OVd0gPHkFDirGM=;
        b=ASzMBsbFpGlJZqzWOdC5SUxoMXAlyvJRp8FbaLIMuV502E/Q7YekTlQ+f7iwGWtn+z
         SPF2fxGJezxjqet+dT6wetnZ7hivPXGnp2gRobk23SKS1eQ6VGlwTVzqcOKOWHi3tm0y
         gP8klhn+OU3WGkxJyZ1cKb5bLRLUxciSbfeQ1Nh9C8YdRdrGC8UYP45oFQ4yArnXAsTY
         LJY0zINSyJMMEIRTiGdy0JEt6F//FCfrKP5YRXRSy+Efh28Sr0MFqhjU/RQNTUa8yTmc
         TfcbbTrjGf94fblvPm/igZ/Mn7bhMq9Rev4oCxS2eIES1yJDzrEIE1d84QJ+5AtC5ryr
         8+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:message-id:mime-version:subject
         :from:to:cc;
        bh=HhHNmLA8REYhOuJC0vm+kLsXG9Lm4OVd0gPHkFDirGM=;
        b=wDjaCkUYQneMWNmLjtT6zabw+l8AfI/uh61wnI/7MSjZo6doHV6FFktnT4hM8sNiY3
         dgpxrMbfans4Thsfxc2yXeet0DmkjcChAgkmCKgsWG2SLp8rjIxnrb7xUD9GRLxixvhk
         jXGlodke3AzwV5szLo9i1bEpQN3QHYSgIixJlghtbvlTD7+oSXHY90vg3aArxjYpuNwy
         RoPOtJKSfVmqgNQc0kGv6tkkGcDF+hW+hYsmpw6jmZOfjyImnyog5Moh394P13mJro52
         KnHJOdHzEkoGl14wXO1Qu+F0yx57NqZrdfI+7QsCNTcAemF+fzndC3l6cemQkQLVBAZZ
         OSmA==
X-Gm-Message-State: AOAM530p53N11Roz23GXnrr1qBVapygopW3rb9ug4YbRBv//8H59ZW0B
        BXXXH67bHGtmZi1eyE17LN1na0TNWCg=
X-Google-Smtp-Source: ABdhPJxQb7i85ReJWIRX0FdV+KhiHX4rLNlCDJmuoKaPcmEH8RszN2ZHmNP1ue42Iz/KsKbpy7jGR+6MuJ0=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:90:200:d59f:9874:e5e5:256b])
 (user=seanjc job=sendgmr) by 2002:a05:6214:11f0:: with SMTP id
 e16mr7611919qvu.30.1631653793581; Tue, 14 Sep 2021 14:09:53 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Tue, 14 Sep 2021 14:09:49 -0700
Message-Id: <20210914210951.2994260-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.309.g3052b89438-goog
Subject: [PATCH 0/2] KVM: SEV: RECEIVE_UPDATE_DATA bug fixes
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Gonda <pgonda@google.com>,
        Marc Orr <marcorr@google.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Masahiro Kozuka <masa.koz@kozuka.jp>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Patch 1 pins the target of RECEIVE_UPDATE_DATA for write instead of read.
The SEV API clearly states that the PSP writes guest memory, which makes
sense given that the guest is receiving data.

Patch 2 adds a CLFLUSH of the guest memory as there is no requirement
that the page already be in an encrypted state before RECEIVE_UPDATE_DATA,
i.e. the cache may have dirty, unencrypted data.

On my end, these patches are compile-tested only as I don't have a
userspace VMM that supports SEV live migration, nor are there tests for
any of this stuff.

Masahiro Kozuka (1):
  KVM: SEV: Flush cache on non-coherent systems before
    RECEIVE_UPDATE_DATA

Sean Christopherson (1):
  KVM: SEV: Pin guest memory for write for RECEIVE_UPDATE_DATA

 arch/x86/kvm/svm/sev.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

-- 
2.33.0.309.g3052b89438-goog

