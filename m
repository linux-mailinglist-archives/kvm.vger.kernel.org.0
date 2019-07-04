Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8405A5F5A0
	for <lists+kvm@lfdr.de>; Thu,  4 Jul 2019 11:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbfGDJdA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Jul 2019 05:33:00 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42922 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfGDJdA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 4 Jul 2019 05:33:00 -0400
Received: by mail-wr1-f67.google.com with SMTP id a10so4750064wrp.9;
        Thu, 04 Jul 2019 02:32:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fwSG0Tdenqqcf2GnwbbXuGqd+GSp1FlomYOebSQoaWo=;
        b=hMqeDDXKOtepU69AjhovKXrbb8eWvNgR3Xxj2aa9OBj5gqUfZNxEmPeLjZV2j5UDN1
         qXzNnoKJkc2mctxjJzGxVtwU0m5e84hSBkAkLUiNfKVPdt/w6bQ+drNn8kIIyXhoV81a
         Ac+U57PeZqfH2cqS/DgH++xb4obieTaxLGrW2Z00hM9L8tdQILN7UpTgUFGjgZmlhAXh
         SEgES1oJ2FcHXULY0vC6ph0txv5xci3L17OvSb9mPUBuX1K/pb8HVuuEzQ8NPl079c+H
         ztrgWgVEKEmSZNWrWoTn6DUGwy62LcMP4nwN+GCN+6AoWplXkYJ6+RVBY876CGH/M7i8
         F+wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=fwSG0Tdenqqcf2GnwbbXuGqd+GSp1FlomYOebSQoaWo=;
        b=CkSkGPe8HGKYcNk3pjG5irI8J96ClHkFp7uw8emw9VWcTFvtkEyUSdWvHcUec+cA2H
         QfylaxdpMXdPfryucMUXbgBsJv+V+xEDuhs2GKwf0u8d+MLZDUG6XmiGpn5UEBqcLuSQ
         muxCfcGTB3SMrYJTbH57Ms4rCqJuMbKKm8JyzuUYig6eIleHYxk252G2e17O8srPP3Lw
         NglC02UksLDFxt4fBBoBoUXnocTiOYrkICb2e1Id5LEUbeL2zFys2bptkjO9WkO8irzW
         gy0UvED+bxqOxG4wZIktHNLwvRX3brb1qyXTz9Q6wa2cUn6FroNbVmrkHTbYRYdI6Nhe
         /CcA==
X-Gm-Message-State: APjAAAU1imIrXQxx8iK2w99Lhn31nF5/opZ5mTuyaQqxJ+W/6kJposiC
        eGRKdCUbVnHY65pO/YaNw0cg4mROZaI=
X-Google-Smtp-Source: APXvYqwRsydiMstJTWpcZPMJJzmtLoo8S1JX9L3gzAvcG22MowbX0eScBbLniXxihbea+b2+Bpw+lQ==
X-Received: by 2002:a5d:6583:: with SMTP id q3mr36043355wru.184.1562232778159;
        Thu, 04 Jul 2019 02:32:58 -0700 (PDT)
Received: from donizetti.redhat.com (nat-pool-mxp-u.redhat.com. [149.6.153.187])
        by smtp.gmail.com with ESMTPSA id m9sm4868320wrn.92.2019.07.04.02.32.57
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 04 Jul 2019 02:32:57 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     sean.j.christopherson@intel.com, vkuznets@redhat.com
Subject: [PATCH 0/5] KVM: some x86 MMU cleanup and new tracepoints
Date:   Thu,  4 Jul 2019 11:32:51 +0200
Message-Id: <20190704093256.12989-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Given the attention to pgprintk, here are the patches I had locally
to add new tracepoints to __direct_map, FNAME(fetch) and mmu_set_spte().
These tracepoints actually come from a recent debugging session, so they
have proved their usefulness. :)  And because I'm feeling both lazy *and*
generous, I'm including a couple free cleanups from the series that I was
debugging!

Paolo

Junaid Shahid (1):
  kvm: x86: Do not release the page inside mmu_set_spte()

Paolo Bonzini (4):
  KVM: x86: make FNAME(fetch) and __direct_map more similar
  KVM: x86: remove now unneeded hugepage gfn adjustment
  KVM: x86: change kvm_mmu_page_get_gfn BUG_ON to WARN_ON
  KVM: x86: add tracepoints around __direct_map and FNAME(fetch)

 arch/x86/kvm/mmu.c         | 105 ++++++++++++++++++-------------------
 arch/x86/kvm/mmutrace.h    |  59 +++++++++++++++++++++
 arch/x86/kvm/paging_tmpl.h |  42 +++++++--------
 3 files changed, 129 insertions(+), 77 deletions(-)

-- 
2.21.0

