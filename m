Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 532373ABF49
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 01:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbhFQXWF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Jun 2021 19:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFQXWE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Jun 2021 19:22:04 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272A1C061574
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:19:56 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g22-20020aa796b60000b02902ec984951ffso4562458pfk.11
        for <kvm@vger.kernel.org>; Thu, 17 Jun 2021 16:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=qNQ9p3/spgJpp541oTXXsOm8SYVBB1UwK9I0aknVtQ4=;
        b=m+WobVzoYnRN8h7UttnqK5UEHK8w5cHEDfA0N7qfj3wc+XTvKXzh6efupTWBiRXERb
         cBwKm30hENZFzvxVjYpOgUtmdkuUQ5g66gttMgyN8Oh1S6rQiSX/s7F4xlI9tNux5JuY
         ZtPlEpnSc/yL+VUVm41rNMmotjLCWdFBuQpfZKuaxCGDwZBFzSty//FOTSMinRGsgdkn
         fcyENlMvVhujBsagt+9yGd1B+cgzyW/nXqfC9cxzy0x60A4V9PoYzl1HlI6xtpHKDkqJ
         EyxGq0bStgDBXDpkf6OyrLbRsz1heMV4t12FJyx7cBg3DcUA0A7G7OFewicXYPbirjwE
         9bgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=qNQ9p3/spgJpp541oTXXsOm8SYVBB1UwK9I0aknVtQ4=;
        b=PVfjVoEKZ2wi/Nef0sZrgO95lUkbWlNwCqnbhdKzmqSoJ9MCEIP3ol1bQ+HdzQK44m
         eGDWPDp0XUBuMPiExDRjipsbONwP9MuXV9QndTdGlig/amslmywCJLu8euRHbR7jIqwo
         WwWiRHhUBD4luKpPONdTOl+S0i78y7yLds8VnkuK7ImZeG62EG08SikyBXUvU4qL8EHU
         +YworOXgbchq1ipgjpt8w5wUsiUdbpVWp+OarHHVSyFshk6LT6ZoK2nXvgF4/qOG1NbW
         hD8d/VGtRJqvZI25agLBTWGPI/MiFXYDIQI0UICb0yq9/o5yV2PEw0IfGfoVqYQEeLbn
         JRMA==
X-Gm-Message-State: AOAM530OIlwzXSRkA6oUl+vbjmqP3PySb4AAohTM4yfe6h5Uz5+iNRvb
        qf16IocnAeffxfzvDT9IBFrjBflri4WFlccBHLUkdg+/n7Bq0YiqAuNu3Q0w2zW6mRzn6NRmKXD
        DBI4oYivJaPOxuLJ+wcRzDh9N6wxm5ArnK71dnPdpmI+v3q7eovFz0dwAVwfc+Do=
X-Google-Smtp-Source: ABdhPJyuSBCGD67yy5ELvlKkCdoZWdO0GJvDUtrnbDRTa5JeEhJnCMmKxzOvPC2axnN1oYD8COop25aucmM5YQ==
X-Received: from dmatlack-heavy.c.googlers.com ([fda3:e722:ac3:10:7f:e700:c0a8:19cd])
 (user=dmatlack job=sendgmr) by 2002:a63:ec43:: with SMTP id
 r3mr7047823pgj.344.1623971995545; Thu, 17 Jun 2021 16:19:55 -0700 (PDT)
Date:   Thu, 17 Jun 2021 23:19:44 +0000
Message-Id: <20210617231948.2591431-1-dmatlack@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.288.g62a8d224e6-goog
Subject: [PATCH 0/5] KVM: x86/mmu: Clean up is_tdp_mmu_root and root_hpa checks
From:   David Matlack <dmatlack@google.com>
To:     kvm@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>, Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Junaid Shahid <junaids@google.com>,
        David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This series is spun off from Sean's suggestions on [PATCH 1/8] of my TDP
MMU Fast Page Fault series [1].

Patches 1-2 and 4 cleans up some redundant code in the page fault handling path:
 - Redundant checks for TDP MMU enablement.
 - Redundant checks for root_hpa validity.

Patch 3 refactors is_tdp_mmu_root into a simpler function prototype.

Note to reviewers: I purposely opted not to remove the root_hpa check
from is_tdp_mmu even though it is theoretically redundant in the current
code. My rational is that it could be called from outside the page fault
handling code in the future where root_hpa can be invalid. This seems
more likely to happen than with the other functions since is_tdp_mmu()
is not inherently tied to page fault handling.

The cost of getting this wrong is high since the result would be we end
up calling executing pfn_to_page(-1 >> PAGE_SHIFT)->private in
to_shadow_page. A better solution might be to move the VALID_PAGE check
into to_shadow_page but I did not want to expand the scope of this
series.

To test this series I ran all kvm-unit-tests and KVM selftests on an
Intel Cascade Lake machine.

[1] https://lore.kernel.org/kvm/YMepDK40DLkD4DSy@google.com/

David Matlack (4):
  KVM: x86/mmu: Remove redundant is_tdp_mmu_root check
  KVM: x86/mmu: Remove redundant is_tdp_mmu_enabled check
  KVM: x86/mmu: Refactor is_tdp_mmu_root into is_tdp_mmu
  KVM: x86/mmu: Remove redundant root_hpa checks

 arch/x86/kvm/mmu/mmu.c     | 19 ++++++-------------
 arch/x86/kvm/mmu/tdp_mmu.c |  5 -----
 arch/x86/kvm/mmu/tdp_mmu.h |  5 ++---
 3 files changed, 8 insertions(+), 21 deletions(-)

-- 
2.32.0.288.g62a8d224e6-goog

