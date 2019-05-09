Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C38461970C
	for <lists+kvm@lfdr.de>; Fri, 10 May 2019 05:26:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfEJD0H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 23:26:07 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33693 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726907AbfEJD0H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 23:26:07 -0400
Received: by mail-pf1-f195.google.com with SMTP id z28so2426996pfk.0
        for <kvm@vger.kernel.org>; Thu, 09 May 2019 20:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=C3FvmwzzD4/RyHuhfd01eslvukg1+y/7M2rWOjTomPs=;
        b=mvZRrtgRp4Zg7Yz1OuQNPDg/+e4QPADBlutf/8fIszQXoM7DIfJxqfSlpTGd09QaWH
         h0AVKtius4rRrylZ1JBzO34cEWjJ8twNraMTcsbNgs2X/i4iPbR3SvOGw3yVVn+xKU1/
         AfejvK0zBMfjcRlCM9gBm0LWUrwey2KbnMWBLoWW37xXu6KyZwTd2FnZ8x6HzdAvgXMp
         xPPPhaXouVsC+mqw2bDRhsfv+WYAoUeZNp8TlK3n+vJYwyyw90kyDgVcZGGBxV+jGiSo
         JoOz+Tw/QTAbYVBUmtG60+3bDsj4zhrLheFRxyR4qiK0wWC/nR5lBjXZGbDMIivX1uA/
         7Npw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C3FvmwzzD4/RyHuhfd01eslvukg1+y/7M2rWOjTomPs=;
        b=aeB4aUz9B9SUW+PXbP6h0tPddc249WTgyUzgkB1Bn68cyxaUZO7WBAfPCHejxfpdri
         U6RHWfse3A8c6Sn2OLBZDQWOQGCxpPLuuQakOEQcFq3mA+GLwxmRY8/3YAMAuq7Vmc0S
         GR0H+GR1HvizkcmQMVY8DEOxolNdTVekZrejKz6XgU31iIgXqsRIqBWY/g5fdJuE+/nR
         QA6ePukOz1xUN7wjUT+hnzYnBVJ6PQ/5OvtoIwoJWJaTgSj4276IqHWjzDNgKrFJVZCM
         LGRUz8ZpxOF+4PyCDDbot5sed0LHCfmXu6jiLJEdQxy2GYrRgXCO9I0rxcpj+kZmVoeg
         fGOQ==
X-Gm-Message-State: APjAAAVfYbYCsoH/TbJ1Xdw0izKwshnGbXPSPVUfugju6hgb6hD06HV/
        hxVLUccE7lniOd/nAiLh2b8=
X-Google-Smtp-Source: APXvYqxdZ8bhtAkQQSQHIv2zPNXEYvdCQnNDkHUtmTHVCEaLUfwuHDU4Ur4KRzRDdLA+1RnO126f4w==
X-Received: by 2002:a63:494f:: with SMTP id y15mr10740580pgk.56.1557458766195;
        Thu, 09 May 2019 20:26:06 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id z66sm5225592pfz.83.2019.05.09.20.26.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 May 2019 20:26:05 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Andrew Jones <drjones@redhat.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Nadav Amit <nadav.amit@gmail.com>
Subject: [kvm-unit-tests PATCH v3 0/4] Zero allocated pages
Date:   Thu,  9 May 2019 13:05:54 -0700
Message-Id: <20190509200558.12347-1-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

For reproducibility, it is best to zero pages before they are used.
There are hidden assumptions on memory being zeroed (by BIOS/KVM), which
might be broken at any given moment. The full argument appears in the
first patch commit log.

Following the first patch that zeros the memory, the rest of the
patch-set removes redundant zeroing do to the additional zeroing.

This patch-set is only tested on x86.

v2->v3:
* Typos [Alexandru]

v1->v2:
* Change alloc_pages() as well
* Remove redundant page zeroing [Andrew]

Nadav Amit (4):
  lib/alloc_page: Zero allocated pages
  x86: Remove redundant page zeroing
  lib: Remove redundant page zeroing
  arm: Remove redundant page zeroing

 lib/alloc_page.c         |  4 ++++
 lib/arm/asm/pgtable.h    |  2 --
 lib/arm/mmu.c            |  1 -
 lib/arm64/asm/pgtable.h  |  1 -
 lib/virtio-mmio.c        |  1 -
 lib/x86/intel-iommu.c    |  5 -----
 x86/eventinj.c           |  1 -
 x86/hyperv_connections.c |  4 ----
 x86/vmx.c                | 10 ----------
 x86/vmx_tests.c          | 11 -----------
 10 files changed, 4 insertions(+), 36 deletions(-)

-- 
2.17.1

