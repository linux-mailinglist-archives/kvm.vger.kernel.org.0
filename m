Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D20F4AA792
	for <lists+kvm@lfdr.de>; Sat,  5 Feb 2022 09:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238701AbiBEIRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Feb 2022 03:17:35 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35717 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236742AbiBEIRe (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 5 Feb 2022 03:17:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644049054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=iAD851LcLXDVa0QUog2OipK4rBTjALzioBqLSupE+xM=;
        b=i/NaUCahrBlD9lMiWkzYYmV3wVQlXznDk7136Mnk97QfA0Vc9mGC0u/eP76FVkVHZhJWeR
        ghDv1CtBimhfMkFcJ6Oj72ygX2OmfDsIWvGW80gvtFNHgMEuOiFhb1ie4WY4VrBth28ffF
        UITStd9JwsFiHg1T2FcYi2g1HvgLYqI=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-240-CDTUuf8lNxqKfHXVItPliQ-1; Sat, 05 Feb 2022 03:17:30 -0500
X-MC-Unique: CDTUuf8lNxqKfHXVItPliQ-1
Received: by mail-oi1-f197.google.com with SMTP id k8-20020a0568080e8800b002ccac943a76so5267133oil.15
        for <kvm@vger.kernel.org>; Sat, 05 Feb 2022 00:17:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iAD851LcLXDVa0QUog2OipK4rBTjALzioBqLSupE+xM=;
        b=zOKrA6onrtLzHO+rJdyHolXCzI/fq217fMfYCq8XfuI8gJysAYdJM+ALMuWSTlJRcD
         94tLXnKpUnRLDpJZDAdSai6ECOAgMzMXVdovvITqeNZkEU/d38bRkyulPN08OqJWcrIS
         sCCkjeXVkw5RLZfDPCJa7JbgL8dkrv59pnENEoQWRxtiJpbDDYLwdcJJVlcBZLDZYU9b
         CgcM3uu6Df2rM/KrhEwY9hcuEryKfv3DNSGV+ErYRfGc5JuuBpDK6rmQqLtF/a0qbjNd
         g9fFn1TgOHoS1ebknJ8L+Em4DVorOC/a/Idcb08dDf4u+5Tb0lQZhKPNi9zJ/jjphW2y
         e94A==
X-Gm-Message-State: AOAM531Sr6jap9apfZXPqdDrn9GXraFHmZ3OcRNusTBLIrvHye8h4QKd
        pMb2EoI0hhO5IoTfnxwOCs+GfBE8pufdmGYl2LM21/UqP1vy4hZbfMfdTs7JIqzwr7MNgfzxG2V
        dKvKS/jUWs9u7
X-Received: by 2002:a05:6870:8642:: with SMTP id i2mr1308992oal.303.1644049049554;
        Sat, 05 Feb 2022 00:17:29 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwjT9AO0jjdF8yQKYY92+m4lAxKx1Yw7B9E1bCX8rTAcUrmgTgVw4DsL8DFW3YS12+vTxC0mA==
X-Received: by 2002:a05:6870:8642:: with SMTP id i2mr1308984oal.303.1644049049387;
        Sat, 05 Feb 2022 00:17:29 -0800 (PST)
Received: from localhost.localdomain ([2804:431:c7f0:b1af:f10e:1643:81f3:16df])
        by smtp.gmail.com with ESMTPSA id bg34sm1708795oob.14.2022.02.05.00.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 00:17:28 -0800 (PST)
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
        "H. Peter Anvin" <hpa@zytor.com>
Cc:     Leonardo Bras <leobras@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] x86/kvm/fpu: Fix guest migration bugs that can crash guest
Date:   Sat,  5 Feb 2022 05:16:57 -0300
Message-Id: <20220205081658.562208-1-leobras@redhat.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
not touch the PKRU flag.

Patch 2 comes from a concearn I have of the same bug as above hapenning
through different means, such as a future bug in qemu, and rendering
a lot of VMs unmigratable. Also, I think it makes sense to limit the
fatures to what the vcpu supports, as if it were baremetal it would crash.

Please let me know of anything to improve!

Best regards,
Leo


Leonardo Bras (2):
  x86/kvm/fpu: Mask guest fpstate->xfeatures with guest_supported_xcr0
  x86/kvm/fpu: Limit setting guest fpu features based on
    guest_supported_xcr0

 arch/x86/kvm/cpuid.c | 3 +++
 arch/x86/kvm/x86.c   | 3 ++-
 2 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.35.1

