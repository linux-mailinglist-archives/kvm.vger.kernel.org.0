Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136FF404067
	for <lists+kvm@lfdr.de>; Wed,  8 Sep 2021 23:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352417AbhIHVEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Sep 2021 17:04:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbhIHVEf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Sep 2021 17:04:35 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 648EFC061575
        for <kvm@vger.kernel.org>; Wed,  8 Sep 2021 14:03:24 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id f23-20020aa782d7000000b003eb2baced8bso2162384pfn.3
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 14:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=JC16aUwWh6VH1dHIMo/8cnVTyU7yQibp113aKDOygMY=;
        b=OXtBrVZQuDsj1Xd11yEKs6/hnslMSZ5qwPiSLFnQtXEJzAEZDxdwJ0oylLEAJYnpAY
         N/uIjCw9BAaW9hztD862iMgGgd2iUeKJm0Io91e8UK+7beow+rrfR7qBsanX5C4OYBkB
         oxyblXxt0sc1T5zq775Psfnb4LGYHas68I0MtlJwO/tXadr+oh0mmJV5uJVzqpVCC1wg
         6vtkOxb0K71cdgMcQ7CEjZzB7i77/VeUued+2jJ5yLu+5jwm1nOq4Xmy3QX8Kgaj3Kkk
         Ib6Jrsz/EkXMWQPxU0zFo3452qgS0gBFH1G8cG7+oNkg4JSxllrFBy1EHWljpHeD/2Bj
         dQRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=JC16aUwWh6VH1dHIMo/8cnVTyU7yQibp113aKDOygMY=;
        b=PZJNg8yT2/bEeWN0qUUQvzyHgDOFo+bBqNHPSDL+Lqqm0lcjk8NTi+KkZmHNS/SXXe
         VjlT7ch+Cf/L+r9Y1GXk2cGlOTJXs+T2DzarJPs3B4wKQPyh1+aiPeO/XhLBzroq0pg5
         ANuIt9tASXueBYVrq2/3v/pT7coaGsbJVMLjIwlWvUUtq5rmUJIwOlDrbLtDM7/HLMPP
         jYWRUkN5FJb9WP3OzTRNgFkbciNT7ZIIHz4IP5qICtGeQnb+QQWN8zRbhoACkSeOYYY/
         3VbiCAdPB1w/xsmU+q7Dhl07tLHJRQ+zlrvb5KstY0OfnDDUeR6o0AknlN1dTm6pAMy/
         rdMw==
X-Gm-Message-State: AOAM53247KTAP1h3PK7975uOj5a5NtP7rwKGvoHjPEfc3wndkBcehFw7
        efKYiihSJaGpFsuh+VhvzNIkHxNQw+56vrRyvckSgt4X7eoo2XRKjO3Awd3RGKElZdaQU94cBmI
        lIhXtNlVmjEGWsLxxKSGMv5NGze3C5C8MfbpvUialq2vPElTxLHpT8FSL4FP9v5E=
X-Google-Smtp-Source: ABdhPJzla16tMBCgG9E0q1xwBqSq8LzrlZo3pCb2r/5jjfDudDDoT/FtwgmHXvdHMdSKQAJYM1AtIxoy9XZR+w==
X-Received: from ricarkol2.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:1e02:: with SMTP id
 pg2mr6190361pjb.35.1631135002966; Wed, 08 Sep 2021 14:03:22 -0700 (PDT)
Date:   Wed,  8 Sep 2021 14:03:18 -0700
Message-Id: <20210908210320.1182303-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH 0/2] KVM: arm64: vgic-v3: Missing check for redist region
 above the VM IPA size
From:   Ricardo Koller <ricarkol@google.com>
To:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc:     Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM doesn't check for redist regions that extend partially above the
VM-specified IPA (phys_size).  This can happen when using the
KVM_VGIC_V3_ADDR_TYPE_REDIST attribute to set a new region that extends
partially above phys_size (with the base below phys_size).  The issue is that
vcpus can potentially run into a situation where some redistributors are
addressable and others are not.

Patch 1 adds the missing check, and patch 2 adds a test into aarch64/vgic_init.

Ricardo Koller (2):
  KVM: arm64: vgic: check redist region is not above the VM IPA size
  KVM: arm64: selftests: test for vgic redist above the VM IPA size

 arch/arm64/kvm/vgic/vgic-v3.c                 |  4 ++
 .../testing/selftests/kvm/aarch64/vgic_init.c | 44 +++++++++++++++++++
 2 files changed, 48 insertions(+)

-- 
2.33.0.153.gba50c8fa24-goog

