Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8CB04B984C
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 06:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiBQFbU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Feb 2022 00:31:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234241AbiBQFbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Feb 2022 00:31:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A861C246354
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 21:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645075860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uFBBw2tgMmvMILcFyIEW04OTQxTvIVNcdkX2nRs0QPQ=;
        b=NLAUAuRUkAX6tmf3yhmU+Eh/+jHCzu8uog9+zNDsAHTWxv4SuWT9GBi6Fqp1lnltTbPh8u
        mnoaV4356yWy1YTEsuID7W+pTOgNzxTmiPP9RB7vuzc5vE1SSfOLubIRpNuZdw+EMfV3LU
        r+G4bTxL4ZnIzo/bb0SW4+6d79NGIAA=
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com
 [209.85.167.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-623-K4R3ywnDPgqRuUnmnxeI5Q-1; Thu, 17 Feb 2022 00:30:59 -0500
X-MC-Unique: K4R3ywnDPgqRuUnmnxeI5Q-1
Received: by mail-oi1-f198.google.com with SMTP id ay31-20020a056808301f00b002d06e828c00so1905333oib.2
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 21:30:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uFBBw2tgMmvMILcFyIEW04OTQxTvIVNcdkX2nRs0QPQ=;
        b=HKm5nVsNqe87jZn3I13xGYgMKVNoYDMVgGT/VfQyds53J9b1rdqoRwQMNsCdrrxuHb
         9bfoiewC2ZN4ATU2vfWKXjVICcKsBUMrQiFqyEgK9YEmfK26gtHNseDa3/jOcoumc7Y6
         LA2dotblj0+W9cN7c5ifTXvX4uGLJBQOL3jYCO8mFV91rJEyTyQIRDISS2P51LWR+eSf
         okJO6isEfsXi7CpB3S40Sg0MzSgk4HVpoHhbqxYfJJh+QGcFZ7C+ipsZ0yw+3pXpZZdq
         Io/xxmb6dg2Qj9vURLv0X00Tgsds+9vvwbQ20APdzo+uA5nEHOVgcW0W433CAHoYeO5+
         52gQ==
X-Gm-Message-State: AOAM531DwEakMqpJXZFgnV3V5GuCR7gapPzRPqA+HFnQ0l/Y4XFgF0vR
        LiiGqaJ3RN88VSces02xXAxhpNiMQHtoC4QnPG+Id9g+ID6hC9ehHV15AJG5GZwRMxUwmTw29T6
        9H//GbdaNV9DR
X-Received: by 2002:a05:6870:1387:b0:d2:d214:ff08 with SMTP id 7-20020a056870138700b000d2d214ff08mr1775426oas.263.1645075858516;
        Wed, 16 Feb 2022 21:30:58 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+BmcOIFLw6KCSl33oU3m/GTZdl5F2TLOC9bRSjVOBLuT31iY9LrOEKtUXsraZhQnmxpagPg==
X-Received: by 2002:a05:6870:1387:b0:d2:d214:ff08 with SMTP id 7-20020a056870138700b000d2d214ff08mr1775409oas.263.1645075858298;
        Wed, 16 Feb 2022 21:30:58 -0800 (PST)
Received: from LeoBras.redhat.com ([2804:431:c7f1:c12c:38a3:24a6:f679:3afd])
        by smtp.gmail.com with ESMTPSA id cm18sm8571688oab.7.2022.02.16.21.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 21:30:57 -0800 (PST)
From:   Leonardo Bras <leobras@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        David Gilbert <dgilbert@redhat.com>,
        Peter Xu <peterx@redhat.com>
Cc:     Leonardo Bras <leobras@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/2] x86/kvm/fpu: Fix guest migration bugs that can crash guest
Date:   Thu, 17 Feb 2022 02:30:27 -0300
Message-Id: <20220217053028.96432-1-leobras@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset comes from a bug I found during qemu guest migration from a
host with newer CPU to a host with an older version of this CPU, and thus 
having less FPU features.

When the guests were created, the one with less features is used as 
config, so migration is possible.

Patch 1 fix a bug that always happens during this migration, and is
related to the fact that xsave saves all feature flags, but xrstor does
not touch the PKRU flag. It also changes how fpstate->user_xfeatures
is set, going from kvm_check_cpuid() to the later called
kvm_vcpu_after_set_cpuid().

Patch 2 removes kvm_vcpu_arch.guest_supported_xcr0 since it now 
duplicates guest_fpu.fpstate->user_xfeatures. Some wrappers were
introduced in order to make it easier to read the replaced version.

Patches were compile-tested, and could fix the bug found.

Please let me know of anything to improve!

Best regards,
Leo

--
Changes since v3:
- Add new patch to remove the use of kvm_vcpu_arch.guest_supported_xcr0,
  since it is now duplicating guest_fpu.fpstate->user_xfeatures.
- On patch 1, also avoid setting user_xfeatures on kvm_check_cpuid(),
  since it is already set in kvm_vcpu_after_set_cpuid() now.
Changes since v2:
- Fix building error because I forgot to EXPORT_SYMBOL(fpu_user_cfg)
Changes since v1:
- Instead of masking xfeatures, mask user_xfeatures instead. This will
  only change the value sent to user, instead of the one saved in buf.
- Above change removed the need of the patch 2/2
- Instead of masking the current value of user_xfeatures, save on it
  fpu_user_cfg.default_features & vcpu->arch.guest_supported_xcr0 

Leonardo Bras (2):
  x86/kvm/fpu: Mask guest fpstate->xfeatures with guest_supported_xcr0
  x86/kvm/fpu: Remove kvm_vcpu_arch.guest_supported_xcr0

 arch/x86/include/asm/kvm_host.h |  1 -
 arch/x86/kernel/fpu/xstate.c    |  5 ++++-
 arch/x86/kvm/cpuid.c            |  5 ++++-
 arch/x86/kvm/x86.c              | 20 +++++++++++++++-----
 4 files changed, 23 insertions(+), 8 deletions(-)

-- 
2.35.1

