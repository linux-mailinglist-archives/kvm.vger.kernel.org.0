Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6458B46B7F5
	for <lists+kvm@lfdr.de>; Tue,  7 Dec 2021 10:50:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234338AbhLGJx4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Dec 2021 04:53:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhLGJxz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Dec 2021 04:53:55 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0462BC061574;
        Tue,  7 Dec 2021 01:50:26 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id u80so12951024pfc.9;
        Tue, 07 Dec 2021 01:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g9v1gEiTaCcmm9Ipr1ZhTI3gfkBKIxC9zvlLuNxve5w=;
        b=nUqguKBP6eJ+p9sbAz5TrcJPZwzURDTfvyPkZkFcqJLapZyiHUMzWVBD9lM0ebskMS
         g9cA+y8ZpU2Rfs9RxBkRBbsmdUI22ABcBgsHzuBCgXfWY7i6JfyX+3cfODrhipPEQa7H
         GAogE1IVyn5S97r2v2kwMVd/6ZIkyDJSgcYVpfgUx11UlmW98tmYkRPwniF5nvi+UqUE
         t1AcKHJ/c4oQyHMeNFdWjbYHJ9FF29j3yn/tPeP0cV6tCKC390QZI7cmUrYXhj4Ai0Nz
         aoRHyZVZktIHlLmuDNKqmAoDX2UWYNN51rxDL5QVaD19kow9O2lKnGyjJrYk1hn4F1Y6
         5WqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g9v1gEiTaCcmm9Ipr1ZhTI3gfkBKIxC9zvlLuNxve5w=;
        b=ieWFVfNaFS4X3wYsDpOFPA5e4qp0PIIIF6fNCkA9trmTK8I05QIGi8iCCfEoZcsxkS
         pgurc8+Uu5TUUoh6wq+rtwVoIqCIovF40tsglSAB9PT/veQzdpJHVIGAyP9yriLgmuxn
         eUtVdP0FElfUs8r5XcHKi4GeKazQjpG2ahrBnRhylkFsTytYNJBCsUrT69M07TddWKA1
         PXCjNmIBwQaOHRKjE+iYgSyJuRCPPgkhxnA2ZQwi2O1NOQlB7+Wi0vchZEueEyxGAUft
         46mbfNt1Pq+KvTNDTUG9wMhxFZr7LjMvFwgPcFZG7fyCBF7CSBvZBzSL32vOYdHI7+jz
         pRgA==
X-Gm-Message-State: AOAM530OALiKLV7odFsIlemtPA1++O5j+4cExax31rpkF3yBJ5qdMjQl
        QIiYG/+n6jWEt3k+gbFEe3Lxljw09o8=
X-Google-Smtp-Source: ABdhPJwxBuESsfuL6Lk10423rx+9fimCI4T2qa3tA0b4fqWoe91Xnw1TvAeMXkiD0ZDGu4/wFJtsiA==
X-Received: by 2002:a05:6a00:b49:b0:49f:bad2:bd7c with SMTP id p9-20020a056a000b4900b0049fbad2bd7cmr42447835pfo.64.1638870625404;
        Tue, 07 Dec 2021 01:50:25 -0800 (PST)
Received: from localhost ([47.88.60.64])
        by smtp.gmail.com with ESMTPSA id m6sm12423138pgs.18.2021.12.07.01.50.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 Dec 2021 01:50:25 -0800 (PST)
From:   Lai Jiangshan <jiangshanlai@gmail.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Lai Jiangshan <laijs@linux.alibaba.com>
Subject: [PATCH 0/4] KVM: X86: Improve permission_fault() for SMAP
Date:   Tue,  7 Dec 2021 17:50:35 +0800
Message-Id: <20211207095039.53166-1-jiangshanlai@gmail.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Lai Jiangshan <laijs@linux.alibaba.com>

permission_fault() calls two callbacks to get CPL and RFLAGS for SMAP,
but it is unneeded for some cases, this patchset improves it.

Lai Jiangshan (4):
  KVM: X86: Fix comments in update_permission_bitmask
  KVM: X86: Rename variable smap to not_smap in permission_fault()
  KVM: X86: Handle implicit supervisor access with SMAP
  KVM: X86: Only get rflags when needed in permission_fault()

 arch/x86/include/asm/kvm_host.h |  9 +++++++
 arch/x86/kvm/mmu.h              | 45 +++++++++++++++++++++------------
 arch/x86/kvm/mmu/mmu.c          |  8 +++---
 arch/x86/kvm/x86.c              | 20 ++++++++++++---
 4 files changed, 59 insertions(+), 23 deletions(-)

-- 
2.19.1.6.gb485710b

