Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5352170C315
	for <lists+kvm@lfdr.de>; Mon, 22 May 2023 18:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbjEVQN1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 May 2023 12:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbjEVQNX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 May 2023 12:13:23 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0468AF1
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:13:22 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9DC0C41B56
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 16:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684771995;
        bh=125o6Ozycv6hr1/Xmw5xSDqLfuhzE74ZgK6ojkSnDGM=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=XBzQLaI7BkOgc15BVW/5Xhu+DoiFN9pD0+RKQuW+ZLb+r761Nut3u5zat4pxqG2bE
         dhsgbN7C7U5g1qecvf7Vdg2Cl1XVtpgtCOMRBxLgBw9UZnAKBFRDAfMZoLv4cPwrM3
         eKQvneUrjAGuMAyTtKGoP8agXuwMELls8k5mbiP71lwXwolnqcp5gmxakdSy+FcGw3
         j6Z+K94ZPDTERHgvgoZ3uv0W3SEMfLTfUT+pKY09Bt4E6dZ266trwvfy+upl2mJYLs
         SXS7aSdSH2BV8AHp7aRs+CqF+TnvzsbaWSPUyvLtg2uFK69yGeC1i1uOpvOB8F/k2Q
         M3D7VLAQfcGow==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-96f5157aca5so484748466b.0
        for <kvm@vger.kernel.org>; Mon, 22 May 2023 09:13:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684771993; x=1687363993;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=125o6Ozycv6hr1/Xmw5xSDqLfuhzE74ZgK6ojkSnDGM=;
        b=LiuXt6nwbhHX2rTPFaTJo7frIQdtdRi5/yA65BHONmNgWO0EqQqRkX3mwsy69OvBqw
         cAHVvkRZDhocN6BpaBaBT92NSPTg0QOBun1pDVlChzbdXg6nVlDeDOAFDFjeNhy2D8AB
         VyupDmiYV5vt0SkDC57ZtC+oLh3awEmg219K4N6lI2OvTCx/s6rdZc6bK4kJl4D6AMCv
         IuXW/8Vf4h8Jwmj7HcqA1gEOCOuhvFRhNFS4ERWRltFK2jcfrRpNOAMIILGAkUv1aNj6
         NqReT9l8zvzaSCO/JuqRQT1/zJx+S/Lz7W/X+rvJj9Mwngv9XX8ZFuOlXSqQOlt5hPFh
         N1+A==
X-Gm-Message-State: AC+VfDwBN4wwq01iebjMetOtPds7PZL+JTIAi2ievb8TPkjB0gNQlk5S
        HwbuRbatRls2lv/YMz4EyNvgo+9KRhmZRrnqayfkhe7DNhuDqGjX/NbJs4O7K4mXLDX//skj+gd
        qkZidFcKIqJP9XEVDrsWVPea3u0Sztw==
X-Received: by 2002:a17:907:1b24:b0:96a:7196:6e2b with SMTP id mp36-20020a1709071b2400b0096a71966e2bmr10253684ejc.14.1684771993798;
        Mon, 22 May 2023 09:13:13 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6JhXod18v9tx/IMD9T4ikV8Z2+zzpkEtqWBU2p4/F0aROYYH+dRjw49JIvOk5T3iEmefxvpg==
X-Received: by 2002:a17:907:1b24:b0:96a:7196:6e2b with SMTP id mp36-20020a1709071b2400b0096a71966e2bmr10253660ejc.14.1684771993509;
        Mon, 22 May 2023 09:13:13 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id a7-20020a17090682c700b009658475919csm3225039ejy.188.2023.05.22.09.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 09:13:12 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     pbonzini@redhat.com
Cc:     Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        Sean Christopherson <seanjc@google.com>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 0/2] KVM: SVM: small tweaks for sev_hardware_setup
Date:   Mon, 22 May 2023 18:12:46 +0200
Message-Id: <20230522161249.800829-1-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM: SVM: enhance info printk's in SEV init

Let's print available ASID ranges for SEV/SEV-ES guests.
This information can be useful for system administrator
to debug if SEV/SEV-ES fails to enable.

There are a few reasons.
SEV:
- NPT is disabled (module parameter)
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
  KVM: SVM: enhance info printk's in SEV init

 arch/x86/kvm/svm/sev.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

-- 
2.34.1

