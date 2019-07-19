Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B99F06E8EB
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 18:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731292AbfGSQmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 12:42:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54082 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727577AbfGSQmV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jul 2019 12:42:21 -0400
Received: by mail-wm1-f65.google.com with SMTP id x15so29412192wmj.3;
        Fri, 19 Jul 2019 09:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:subject:date:message-id;
        bh=SyuzXM1UA0r411S68OsfdkYKutqC9A46TddWlatyHsQ=;
        b=vTEXtvEHhSuArsy9QXt3XHQbJbvp781op8ZBwDYw39LvNyfC/ICdcmHqY+/BCErSIs
         5TgpjeHzeQrXXPycz2Sff3/1oFsCV0fy3a3W6GCrHdqLHR4bYHMCiNUiWYavNGUfxLqM
         h14Fw/nWo4HtVHTGRy1ElIsU9/AFJBuYcvY69DRa/V0cJP74WDmugxyCOIy9tNfTB6Z0
         vr+OPw3OtSdjGN4kpxe532H8GyztrYsC2VOlTosqF05Y8MDMtt9L5ZIozYxhIjjUIUu4
         jBe6usBUSBWiQjdCQ4a5WemFS6eJzY6kGs0MDXvoDA7n095RUkuTmNYzDJxjMUsNczxU
         kBdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:subject:date:message-id;
        bh=SyuzXM1UA0r411S68OsfdkYKutqC9A46TddWlatyHsQ=;
        b=nAEEkchpHxOEhNg6HsFdPngjlKQYqxHrWe8WV8b1tRsD/FDuoKTi2l3nTvvw4lX3Vu
         XyqT5ohyzOy+P9xfE7M3kzyBSM7V/zi10Ot3+zEyhtP/7uU53r1qaD+aglDNfmHg1GBQ
         tidKXaAgK1HqfzaJsdxruwv6Nb78/f8LuPBSFudVNgZT/wlx8dLdd34AOHH/RoZ0YuS0
         JD0mj11uGUEdlw8woHClRTPhlR4BiM+jxobNDqQhJU+Rvp8pAdwRtZbFTrc4Gq/gG3eW
         B89xgwzFhugUgaQLYARQkuum/v/Wcp667XqNIjFSlBGQ8B3k+EUcR6o2TVrUk3OWHC/y
         v6fA==
X-Gm-Message-State: APjAAAU7OZlwNBodPnSyaBIMR8vBTgHcY7U2iNOAFSGJoAo6HFndyCSP
        Gb2lDGZi6pwdFNlsIfhbsbpoMK171SY=
X-Google-Smtp-Source: APXvYqzWYqZbqCkuugTsLZdVV4wmZfFs6xj6yP8zSZeAXjYDXg/BpLT2hCqiQZgocDM/xwIAKfjpDA==
X-Received: by 2002:a7b:c310:: with SMTP id k16mr11083048wmj.133.1563554539165;
        Fri, 19 Jul 2019 09:42:19 -0700 (PDT)
Received: from 640k.localdomain ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id g19sm32764233wmg.10.2019.07.19.09.42.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 09:42:18 -0700 (PDT)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] KVM: nVMX: do not use dangling shadow VMCS after guest reset
Date:   Fri, 19 Jul 2019 18:42:14 +0200
Message-Id: <1563554534-46556-3-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If a KVM guest is reset while running a nested guest, free_nested will
disable the shadow VMCS execution control in the vmcs01.  However,
on the next KVM_RUN vmx_vcpu_run would nevertheless try to sync
the VMCS12 to the shadow VMCS which has since been freed.

This causes a vmptrld of a NULL pointer on my machime, but Jan reports
the host to hang altogether.  Let's see how much this trivial patch fixes.

Reported-by: Jan Kiszka <jan.kiszka@siemens.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/nested.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 6e88f459b323..6119b30347c6 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx *vmx)
 {
 	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
 	vmcs_write64(VMCS_LINK_POINTER, -1ull);
+	vmx->nested.need_vmcs12_to_shadow_sync = false;
 }
 
 static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
-- 
1.8.3.1

