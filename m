Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD2B31404A
	for <lists+kvm@lfdr.de>; Mon,  8 Feb 2021 21:21:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236766AbhBHUVU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Feb 2021 15:21:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236716AbhBHUU0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Feb 2021 15:20:26 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65DCCC06178A
        for <kvm@vger.kernel.org>; Mon,  8 Feb 2021 12:19:44 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id dr7so120217qvb.22
        for <kvm@vger.kernel.org>; Mon, 08 Feb 2021 12:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:reply-to:date:message-id:mime-version:subject:from:to:cc
         :content-transfer-encoding;
        bh=c92WD9tBjIN6OOgkPtPsSt2AYdNEujBjskOjMLRrrjI=;
        b=wAql08sQVg8gABzEOZq6pnXO7zG/92jQFGKp6eugdemTbEjm4IL0/Lb+dByjT9sfhN
         bjrPlvAKbj0oKas5ZqV4PV56jUcAei5nYjw5vJr6mG5xdB4wZk/JcHuHUioTCwKRaSdH
         CJzxvvBlsaMq8ms4VQHX21CJcx+1rWOKfToT9ALVbjNAX97uhylRuuwIbn7USVcM6H/V
         u6YsQqV0rBFRXWoILzy3Q/BkgFUMRBdVjg9XmKfKKp7sJYhoeMXuLxY9l5LbdxwGv1I7
         EBzHC9tN987u4Q6Ixgn0WNBiw2/2BDxQI5v/Axz/egNhPcQU3LK2dUoaVTjSdEiOBElE
         9JzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:reply-to:date:message-id:mime-version
         :subject:from:to:cc:content-transfer-encoding;
        bh=c92WD9tBjIN6OOgkPtPsSt2AYdNEujBjskOjMLRrrjI=;
        b=RzvWSWajrSEmb81J0oW5iuuIgVHo7OMSj2ksAvv79IGh60dPtm2CMRbRzTVGEOuJlG
         Zn2IqJKVmB3QmJLG+Njz8J+1gLMohJy/MniUmF4N9JOb+x6/I4Pir0dcPZpTh7Ljj+mP
         w+K3yM9pM9IWTyMtmqCew4A4U1+ezTQt2gzEGxREe5U1wtlvbKTvXLV0bZuvj1+Ra3IS
         iC1rSFW/f0Rv0kiLa5aY9mFmgI7W7r8I7G1kZQsHqMOzX5NNN7aHSsec8LKhQDztoP6r
         8Aa36Pq211pasbcN+eexOPo5pbVP2tIwC02jBaL3LLX6biCIXRIydaCtEUSzaC7d0j8u
         +3UA==
X-Gm-Message-State: AOAM531QznqapCvfzaSBPb1+JqmLWsrqJwmNrf3bTwyX3uQ/4+rDy6K6
        nEca+1TQRyPpFwHYR11O8IT7AsAfQ60=
X-Google-Smtp-Source: ABdhPJwD9shv2X/SfBHMf5rkLqrlBt/yFuFy7BTxCqki+QSLka36BUA4rdWxltPGE4NO9eUMY8h7zFBUa+M=
Sender: "seanjc via sendgmr" <seanjc@seanjc798194.pdx.corp.google.com>
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:e4db:abc1:a5c0:9dbc])
 (user=seanjc job=sendgmr) by 2002:a05:6214:125:: with SMTP id
 w5mr17608903qvs.20.1612815583538; Mon, 08 Feb 2021 12:19:43 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Mon,  8 Feb 2021 12:19:40 -0800
Message-Id: <20210208201940.1258328-1-seanjc@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.30.0.478.g8a0d178c01-goog
Subject: [PATCH] KVM: Use kvm_pfn_t for local PFN variable in hva_to_pfn_remapped()
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Use kvm_pfn_t, a.k.a. u64, for the local 'pfn' variable when retrieving
a so called "remapped" hva/pfn pair.  In theory, the hva could resolve to
a pfn in high memory on a 32-bit kernel.

This bug was inadvertantly exposed by commit bd2fae8da794 ("KVM: do not
assume PTE is writable after follow_pfn"), which added an error PFN value
to the mix, causing gcc to comlain about overflowing the unsigned long.

  arch/x86/kvm/../../../virt/kvm/kvm_main.c: In function =E2=80=98hva_to_pf=
n_remapped=E2=80=99:
  include/linux/kvm_host.h:89:30: error: conversion from =E2=80=98long long=
 unsigned int=E2=80=99
                                  to =E2=80=98long unsigned int=E2=80=99 ch=
anges value from
                                  =E2=80=989218868437227405314=E2=80=99 to =
=E2=80=982=E2=80=99 [-Werror=3Doverflow]
   89 | #define KVM_PFN_ERR_RO_FAULT (KVM_PFN_ERR_MASK + 2)
      |                              ^
virt/kvm/kvm_main.c:1935:9: note: in expansion of macro =E2=80=98KVM_PFN_ER=
R_RO_FAULT=E2=80=99

Cc: stable@vger.kernel.org
Fixes: add6a0cd1c5b ("KVM: MMU: try to fix up page faults before giving up"=
)
Signed-off-by: Sean Christopherson <seanjc@google.com>
---

I don't actually know that it's possible for a remapped pfn to be a 64-bit
value on a stock kernel.  But, backporting a one-liner is far easier and
safer than trying to audit all possible flows.  :-)

 virt/kvm/kvm_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index ee4ac2618ec5..001b9de4e727 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -1906,7 +1906,7 @@ static int hva_to_pfn_remapped(struct vm_area_struct =
*vma,
 			       bool write_fault, bool *writable,
 			       kvm_pfn_t *p_pfn)
 {
-	unsigned long pfn;
+	kvm_pfn_t pfn;
 	pte_t *ptep;
 	spinlock_t *ptl;
 	int r;
--=20
2.30.0.478.g8a0d178c01-goog

