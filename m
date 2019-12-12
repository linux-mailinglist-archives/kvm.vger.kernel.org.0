Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50F9611D539
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 19:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730346AbfLLSWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Dec 2019 13:22:54 -0500
Received: from mail-qv1-f74.google.com ([209.85.219.74]:52070 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730110AbfLLSWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Dec 2019 13:22:54 -0500
Received: by mail-qv1-f74.google.com with SMTP id x22so2004656qvc.18
        for <kvm@vger.kernel.org>; Thu, 12 Dec 2019 10:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rEnziU9nLlHlYc/tf137lSRc7sdTqh5wg35Mf+C3wB0=;
        b=wOmXzfFazrugxZCYf410kz6njqqI2ZayPQ3Zp1rCCJAl61eXIHZJMLIXKd7ipcL41R
         Sm+Wcca2Q6JqgT++kdbvjzbjYq0FYVW/lmi7QB7yJwkVuo4MV424+x+d7yCwKx0ttep0
         Lptl32SFvhXt0TyRQZlvv9SqXlyRFpCG1TsG3O7/iQ2t4vkLUnHSfRpXrHshDh35/gFo
         c/KEVVI0neOaMUy1YUeklfjbepAMeO7ukOv7HLZ0ISIwDFMKd/GAqrrKh7r8JeBNqa+r
         SbafHPrcaqVH22AN6GG+pQawROsiZA4u3mp/RCCP/9BjFwd9lIMMNNZaOz5x++hHZB3m
         2fSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rEnziU9nLlHlYc/tf137lSRc7sdTqh5wg35Mf+C3wB0=;
        b=Vac+jCaLPo+iIsWxTr0grRNKfD8qF8MEUOg0zXsCNuBGJPvxYSytDZj3Jed4pwOc+r
         /t/nBMZrFwx2RYvX6dY7x0rcQFAnNIjMEqn5D3nEVeR/mn6vrbpnclPvygulObmHpqu0
         8llTCramnZb12W7CIygkoG4u5ptbnME38lI1s8aOGewQpTVYA3jQrrLA7eQUbb2Gov3E
         LaR7kjS0nirhUI0ecMFU9zGVmbVpsS75+cpXab6WZQ+H3mVCessWIKTd8a3LZf01d7OT
         KNRh5gEt2RuB0ljRF58lAKUUrl4XsoEWXyEAiapq+W2Fu4UCH8qd3kCE/Fe60BKYauqL
         ZAZg==
X-Gm-Message-State: APjAAAXljZ5pNG31Re8XrZ+vI07HSLi9wwh7sx3CP0+GW5ayc9l3Rt4S
        s/PDEWgaEA4fOPGaHZl3aLw5UmVr
X-Google-Smtp-Source: APXvYqzcW/ZghkfJqEYc4rFEK2YkEyqYYEYYl+bxHBfcPF4MTg+EIi+2m6XM7rKZ/g0d94tGM2bioMma
X-Received: by 2002:ac8:5308:: with SMTP id t8mr8677688qtn.51.1576174973189;
 Thu, 12 Dec 2019 10:22:53 -0800 (PST)
Date:   Thu, 12 Dec 2019 13:22:36 -0500
Message-Id: <20191212182238.46535-1-brho@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.1.735.g03f4e72817-goog
Subject: [PATCH v5 0/2] kvm: Use huge pages for DAX-backed files
From:   Barret Rhoden <brho@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        David Hildenbrand <david@redhat.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-nvdimm@lists.01.org, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jason.zeng@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patchset allows KVM to map huge pages for DAX-backed files.

v4 -> v5:
v4: https://lore.kernel.org/lkml/20191211213207.215936-1-brho@google.com/
- Rebased onto kvm/queue
- Removed the switch statement and fixed PUD_SIZE; just use
  dev_pagemap_mapping_shift() > PAGE_SHIFT
- Added explanation of parameter changes to patch 1's commit message

v3 -> v4:
v3: https://lore.kernel.org/lkml/20190404202345.133553-1-brho@google.com/
- Rebased onto linus/master

v2 -> v3:
v2: https://lore.kernel.org/lkml/20181114215155.259978-1-brho@google.com/
- Updated Acks/Reviewed-by
- Rebased onto linux-next

v1 -> v2:
https://lore.kernel.org/lkml/20181109203921.178363-1-brho@google.com/
- Updated Acks/Reviewed-by
- Minor touchups
- Added patch to remove redundant PageReserved() check
- Rebased onto linux-next

RFC/discussion thread:
https://lore.kernel.org/lkml/20181029210716.212159-1-brho@google.com/

Barret Rhoden (2):
  mm: make dev_pagemap_mapping_shift() externally visible
  kvm: Use huge pages for DAX-backed files

 arch/x86/kvm/mmu/mmu.c | 31 +++++++++++++++++++++++++++----
 include/linux/mm.h     |  3 +++
 mm/memory-failure.c    | 38 +++-----------------------------------
 mm/util.c              | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 67 insertions(+), 39 deletions(-)

-- 
2.24.0.525.g8f36a354ae-goog

