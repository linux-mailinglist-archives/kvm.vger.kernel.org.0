Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 236986D6000
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 14:19:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234866AbjDDMT0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 08:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbjDDMTL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 08:19:11 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C325E2D66
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 05:13:09 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id CFE893F128
        for <kvm@vger.kernel.org>; Tue,  4 Apr 2023 12:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1680610387;
        bh=9ENFOZdcJofTg+G3Q0sdPkBng9VIxMpyo7ko+MfAWgE=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=vluyNi5K59fqdZoHPjKsUrYlzUkg8R3V7H/TD6vKV8HHgyvbCCC8kGQCBW7zBzIfx
         dpS6UsZf7TjQJ+KAiaka7puE2ijNjSsDXgkvuwJCp+d8C4o6TAYtU/gVOfDcP8Hg23
         PBmJwmpUngAA+MpQ2sl3qygnt7tTOdMgTgrAkTTLRvRT3Rwr6ljNGGgHGho+IWhfRi
         7xFrCXhRzvRUNV71rW7KDJZN904F8TXPvYK6I4035+gE5aqqJA0EnxbSfm9uP4QDca
         2wvjcmPQhfKzKANClxq8kLg3wDRMQuAfg7uPiiEZz6KAbeQ/+tvGehTN5GpZRWvRyb
         3aWzfcQR5uTpQ==
Received: by mail-ed1-f71.google.com with SMTP id r19-20020a50aad3000000b005002e950cd3so46340234edc.11
        for <kvm@vger.kernel.org>; Tue, 04 Apr 2023 05:13:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680610387;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ENFOZdcJofTg+G3Q0sdPkBng9VIxMpyo7ko+MfAWgE=;
        b=PMeFMzqqjRCwh+pex38+9edWPizeX/b1z3sbjf/xeNPNiFhgEPMHN0XZxtXw2I3FUY
         NTx7Ar+6Rpv74w8o/NRGQd+y+s+VF0dpl2aDZun10Cstu+9pHK6H0xlAlmQNT1vmP1RA
         V1EOUSySZaNA75l1QWXv+KaGb+rlEPPrqcY3nhL/bIdC439kQ7K7P2h3oWeZZRfglIWp
         A4uo1pqD1aTLkdvvqFBbf4cW1oXF4oIDJiHk9b8puCMrIozM3bHGnNkwe82cDb86Z/Ta
         agFD6IEWC9hFlWl0H80dlFBs5ojFwUioCxS6TYZOJBc2VnO6ORqiEXII3LKmpqWS4PMC
         pJGA==
X-Gm-Message-State: AAQBX9d610M+NLVKLdil9tHUOKYwMneTPmjUbUMk0TODA5Fk6CBSIY0Z
        jDJqzYd0J1U+bF459464/0dc0+wdNAtcYkf3bN7jq7Q2Fd8KbLONb0l0ksJAszn5qPbnZLNlqsC
        a5KXPiBxq9C/mzOX8FKg7m4A1Totm+Q==
X-Received: by 2002:a17:906:5016:b0:92c:16cc:2dcd with SMTP id s22-20020a170906501600b0092c16cc2dcdmr2209521ejj.33.1680610387573;
        Tue, 04 Apr 2023 05:13:07 -0700 (PDT)
X-Google-Smtp-Source: AKy350YQE1Fbu7QlUlElGBUj4f+rMJCNZDyI9Ulsy59TET0uHpEzRHTDp3iq2zOXXaeSbliqtkLvZg==
X-Received: by 2002:a17:906:5016:b0:92c:16cc:2dcd with SMTP id s22-20020a170906501600b0092c16cc2dcdmr2209500ejj.33.1680610387292;
        Tue, 04 Apr 2023 05:13:07 -0700 (PDT)
Received: from amikhalitsyn.. ([95.91.208.118])
        by smtp.gmail.com with ESMTPSA id xh12-20020a170906da8c00b00947ccb6150bsm5182481ejb.102.2023.04.04.05.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 05:13:06 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     pbonzini@redhat.com
Cc:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Sean Christopherson <seanjc@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: SVM: small tweaks for sev_hardware_setup
Date:   Tue,  4 Apr 2023 14:12:34 +0200
Message-Id: <20230404121236.263332-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM: SVM: add some info prints to SEV init
    
Let's add a few pr_info's to sev_hardware_setup to make SEV/SEV-ES
enabling a little bit handier for users. Right now it's too hard
to guess why SEV/SEV-ES are failing to enable.

There are a few reasons.
SEV:
- npt is disabled (module parameter)
- CPU lacks some features (sev, decodeassists)
- Maximum SEV ASID is 0

SEV-ES:
- mmio_caching is disabled (module parameter)
- CPU lacks sev_es feature
- Minimum SEV ASID value is 1 (can be adjusted in BIOS/UEFI)

==
   
KVM: SVM: free sev_*asid_bitmap init if SEV init fails

If misc_cg_set_capacity() fails for some reason then we have
a memleak for sev_reclaim_asid_bitmap/sev_asid_bitmap. It's
not a case right now, because misc_cg_set_capacity() just can't
fail and check inside it is always successful.

But let's fix that for code consistency.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stéphane Graber <stgraber@ubuntu.com>
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>

Alexander Mikhalitsyn (2):
  KVM: SVM: free sev_*asid_bitmap init if SEV init fails
  KVM: SVM: add some info prints to SEV init

 arch/x86/kvm/svm/sev.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

-- 
2.34.1

