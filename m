Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3194E9248E
	for <lists+kvm@lfdr.de>; Mon, 19 Aug 2019 15:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727732AbfHSNR6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Aug 2019 09:17:58 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40905 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727332AbfHSNR6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Aug 2019 09:17:58 -0400
Received: by mail-pl1-f195.google.com with SMTP id h3so964615pls.7;
        Mon, 19 Aug 2019 06:17:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aZ+5nrs0LMjDpHKkki7nAhcxgYSF9NknvkkgLtDTGPg=;
        b=DEpiA+AQKlaUh3RF+A0tZaaCuPvzPryNNQGETkC05fPPFgLCBJEVRfWOmKQ1ziEoFj
         0PubyaCZZn8frFwQksrf7erQSUkvwLZimSyuB+vonblyBB5nok7c0gNHiIWcvv3r9M1U
         fKeX+BcrCw+VCzfoHHgdZ+4h7rP+p9Olgg5kKt5LrMu0XjnoJAEIAXMzx3/d/9wCe7Oc
         G9BfFkm9svfl2GFqBSa3xBvAAa+jRnSSNGS7JUYdo/Dan45GObCNhtA+C6FcaeAxwGXW
         ASlz1auo0fqa0wQKb0hbbpEOyfyFH5IUoK+iVAcV1fVy7J8KCdieL8ezBoq3F9r2lgrD
         1T2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aZ+5nrs0LMjDpHKkki7nAhcxgYSF9NknvkkgLtDTGPg=;
        b=WD1TjZgcHnjWjbSDq5sUm/QBxOMKmcHap02SkzD7B1M14UZon9gQ/eWuH0X5jEWwKO
         z4iWH61MA+5PUbIrkXbTB0CyxIDWsX8mWs41MrUX4j/7qbDYX2spbyWv+CC51Ho+y5sm
         tgqFceX6GROWWx5i12BHcnYXcXnBxLKK0Bok8HRf494OxPr4yheopWrdtLisSVLTT18p
         t+hc2CSpJHvQVuK8TH9s8OOrkzq8qTg4M4GGQRb2rSiBs96nFbKmDlwpAcqq5iYmv/52
         LIgDY0SpcKt7LXipM2ZWVhaFSX939Z38nmZTpe8U4kBPsg6EpbGdv3JI7CZqrodsIvCp
         ++1A==
X-Gm-Message-State: APjAAAVEGrOkIaZstyfyx3y3rHjWDziDKFoKQRTbAsVoBetIR1XSlJ1P
        W6Znomk1ZgS1WVo7m2Z2zC4=
X-Google-Smtp-Source: APXvYqwecO8PDw3ZtuO6GQH+gpgy16iXAFvZIPaahS3WlVOAzV7gXtbyN0+gxYyd2JNffYM6wmGAkA==
X-Received: by 2002:a17:902:b094:: with SMTP id p20mr2016081plr.320.1566220677481;
        Mon, 19 Aug 2019 06:17:57 -0700 (PDT)
Received: from localhost.corp.microsoft.com ([167.220.255.114])
        by smtp.googlemail.com with ESMTPSA id h20sm16184329pfq.156.2019.08.19.06.17.52
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 19 Aug 2019 06:17:56 -0700 (PDT)
From:   lantianyu1986@gmail.com
X-Google-Original-From: Tianyu.Lan@microsoft.com
To:     pbonzini@redhat.com, rkrcmar@redhat.com, corbet@lwn.net,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, x86@kernel.org,
        michael.h.kelley@microsoft.com
Cc:     Tianyu Lan <Tianyu.Lan@microsoft.com>, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, vkuznets@redhat.com
Subject: [PATCH V3 0/3] KVM/Hyper-V: Add Hyper-V direct tlb flush support
Date:   Mon, 19 Aug 2019 21:17:34 +0800
Message-Id: <20190819131737.26942-1-Tianyu.Lan@microsoft.com>
X-Mailer: git-send-email 2.14.5
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Tianyu Lan <Tianyu.Lan@microsoft.com>

This patchset is to add Hyper-V direct tlb support in KVM. Hyper-V
in L0 can delegate L1 hypervisor to handle tlb flush request from
L2 guest when direct tlb flush is enabled in L1.

Patch 2 introduces new cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH to enable
feature from user space. User space should enable this feature only
when Hyper-V hypervisor capability is exposed to guest and KVM profile
is hided. There is a parameter conflict between KVM and Hyper-V hypercall.
We hope L2 guest doesn't use KVM hypercall when the feature is
enabled. Detail please see comment of new API "KVM_CAP_HYPERV_DIRECT_TLBFLUSH"

Change since v2:
       - Move hv assist page(hv_pa_pg) from struct kvm  to struct kvm_hv.

Change since v1:
       - Fix offset issue in the patch 1.
       - Update description of KVM KVM_CAP_HYPERV_DIRECT_TLBFLUSH.


Tianyu Lan (2):
  x86/Hyper-V: Fix definition of struct hv_vp_assist_page
  KVM/Hyper-V: Add new KVM cap KVM_CAP_HYPERV_DIRECT_TLBFLUSH

Vitaly Kuznetsov (1):
  KVM/Hyper-V/VMX: Add direct tlb flush support

 Documentation/virtual/kvm/api.txt  | 13 +++++++++++++
 arch/x86/include/asm/hyperv-tlfs.h | 24 ++++++++++++++++++-----
 arch/x86/include/asm/kvm_host.h    |  4 ++++
 arch/x86/kvm/vmx/evmcs.h           |  2 ++
 arch/x86/kvm/vmx/vmx.c             | 39 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/x86.c                 |  8 ++++++++
 include/uapi/linux/kvm.h           |  1 +
 7 files changed, 86 insertions(+), 5 deletions(-)

-- 
2.14.5

