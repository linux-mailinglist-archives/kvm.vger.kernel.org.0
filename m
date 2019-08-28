Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF29C9FC6A
	for <lists+kvm@lfdr.de>; Wed, 28 Aug 2019 09:59:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbfH1H7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Aug 2019 03:59:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46960 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726341AbfH1H7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Aug 2019 03:59:09 -0400
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E56CD882F2
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 07:59:08 +0000 (UTC)
Received: by mail-wr1-f71.google.com with SMTP id h8so915751wrb.11
        for <kvm@vger.kernel.org>; Wed, 28 Aug 2019 00:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fXBfbXP94FsOpi1v9mBeSf+ahhRJGbCczR40mL5l1g0=;
        b=U7Tx30lc6gBp0fT27IDbb4TVDcqyQgaphuRJJjLSXofyf3VydY7t9R02lKFSvrSwUj
         mKuE1OKpg5FcPmUULgqxZwUetY2pcG6hJkYNyULWDZChsqzTG1YmXrf7WmuDFazs8Wcq
         wZMCrK6QaXZKSrWSPEzz6jL40yun3Ef2cKDicQGTYKk2Gvwb4WABGhIugzYdFGRdCKfl
         UF5tpzVkOZIujFX7PETdCJ5vo93REp1YIBAmRa9YcIP7Qd4bGkYI5gltSatPTYAdFiBj
         lKYN4CAWoVtDdE0A05Ah+BcRkiMvjKD4xUUreL+p8o5zck79TgysVQtxvSTPaXUMIggD
         Bd5w==
X-Gm-Message-State: APjAAAWC5hoQ3ad9vPUmZwHWoO63B48AuIq0Kah5aMJSmYij8WwVTXVX
        8rrDiY56GLS9XHGy0vU8Bcb/EaZ27sx5pRQGADjZrJrApdCuRXvl9D4ZRzXDe8d3UlrljN5jlAi
        dlvALVuFrYRdu
X-Received: by 2002:adf:db49:: with SMTP id f9mr2912024wrj.112.1566979147477;
        Wed, 28 Aug 2019 00:59:07 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw6jeOXWHKp2OBmWJFh9i//W4b2alfBLT0xcTCuk+Wnz7ITWniIoIL5zWUQjKwG1rgsfWp0Gg==
X-Received: by 2002:adf:db49:: with SMTP id f9mr2912008wrj.112.1566979147295;
        Wed, 28 Aug 2019 00:59:07 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a190sm2448469wme.8.2019.08.28.00.59.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 00:59:06 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Subject: [PATCH v2 0/2] KVM: x86: don't announce KVM_CAP_HYPERV_ENLIGHTENED_VMCS when it is unavailable
Date:   Wed, 28 Aug 2019 09:59:03 +0200
Message-Id: <20190828075905.24744-1-vkuznets@redhat.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It was discovered that hyperv_cpuid test now fails on AMD as it tries to
enable KVM_CAP_HYPERV_ENLIGHTENED_VMCS which is (wrongfully) reported as
available.

Changes since v1:
- This is a v2 for '[PATCH 0/3] KVM: x86: fix a couple of issues with
 Enlightened VMCS enablement' renamed as the first patch of the series
 was already merged.
- Added Jim's Reviewed-by: to PATCH1
- Added missing break in PATCH2 [Jim Mattson, Sean Christopherson] 

Vitaly Kuznetsov (2):
  KVM: x86: svm: remove unneeded nested_enable_evmcs() hook
  KVM: x86: announce KVM_CAP_HYPERV_ENLIGHTENED_VMCS support only when
    it is available

 arch/x86/kvm/svm.c | 9 +--------
 arch/x86/kvm/x86.c | 4 +++-
 2 files changed, 4 insertions(+), 9 deletions(-)

-- 
2.20.1

