Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889B439D5DB
	for <lists+kvm@lfdr.de>; Mon,  7 Jun 2021 09:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhFGHXe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Jun 2021 03:23:34 -0400
Received: from mail-pj1-f41.google.com ([209.85.216.41]:46914 "EHLO
        mail-pj1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbhFGHXd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Jun 2021 03:23:33 -0400
Received: by mail-pj1-f41.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso9801264pjb.5;
        Mon, 07 Jun 2021 00:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OC8PsyFHXhJlNVBTSitgcnGkSPQg05VER4L54PiarWk=;
        b=BLP7nIx2+RA4xMdb1wch9+kPqtJFTu84QDLM0/dfVOMXRlqFrkRDib2cx5EjAi/g8f
         8wdzgri55tcmCApEUYacPNAq0TbIFZ6L6CiQX21McBJS5GhtMqu0/g6taKYdnmuXldNt
         Ik0TC3HUG0xSVO6Frr8EW54sX/6qy1+t9cNnTozV9pi1+Dfm9tE6Mf8fsqL1xaDNvjrO
         YVNQs+AyKodHIvYH0vXPxTY84Bw2fvpdR9u8Uy74fhWDo/nvwvif3jQbSccHzQRhULQC
         7T/NhA9f+mTXx1m2dTGATNhK3MjIHJCb4iSPa3xhVi2Eu2PcZTbDgc+vbXNvAaaKw6hk
         q6bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OC8PsyFHXhJlNVBTSitgcnGkSPQg05VER4L54PiarWk=;
        b=tgoaWUGetv/gaqDtIGqQ8pYe4iJjjCjJ/4sO5v3ofbbG6HTBF0Cq6mQIzGnJ7XWk4H
         1XPqSMBTupUhuj88e0hM2XEWmix2mJpNiuYB5mzmho6bXzvTLymbVLlqWLp3s/tM9Ngj
         L7xRnY/lNqEslVN5qw71L5YBb4W53z+3Oh/kyEA0qe86B+I6e/7wZVD2k0mnu60E4qdv
         4rwXsg4TqM8K0o4iGobGgG+Uz+ZMlGpYduuehW3s88Nw7+xiphEKvucWlTh2k0YPwNLv
         WjhnDLmhRm1wRGH4w1pwYLXZqBXHdXqBqfQRkCXufsk+OmlLrCwuHxoITbvGsGu1xigl
         zQ4Q==
X-Gm-Message-State: AOAM533BwGjNdG5KORUB+irDYpJBJl+6IzjmsumcpHiwUTUja+Rg5v7c
        cJat4oaVt4zvctDCfsYKnxd4gEx2yUo=
X-Google-Smtp-Source: ABdhPJyIlTGgSn22HgWeistANnthzANP1Oh7++Qhyctx5nVh0iy1oHkXz0LitYEqNHvxrdqjAlNypQ==
X-Received: by 2002:a17:902:c404:b029:10e:21e8:759c with SMTP id k4-20020a170902c404b029010e21e8759cmr16807097plk.44.1623050442846;
        Mon, 07 Jun 2021 00:20:42 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.61])
        by smtp.googlemail.com with ESMTPSA id f3sm10797137pjo.3.2021.06.07.00.20.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 07 Jun 2021 00:20:42 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH v2 3/3] KVM: X86: Let's harden the ipi fastpath condition edge-trigger mode
Date:   Mon,  7 Jun 2021 00:19:45 -0700
Message-Id: <1623050385-100988-3-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
References: <1623050385-100988-1-git-send-email-wanpengli@tencent.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wanpeng Li <wanpengli@tencent.com>

Let's harden the ipi fastpath condition edge-trigger mode.

Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
---
 arch/x86/kvm/x86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b594275..dbd3e9d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1922,6 +1922,7 @@ static int handle_fastpath_set_x2apic_icr_irqoff(struct kvm_vcpu *vcpu, u64 data
 		return 1;
 
 	if (((data & APIC_SHORT_MASK) == APIC_DEST_NOSHORT) &&
+		((data & APIC_INT_LEVELTRIG) == 0) &&
 		((data & APIC_DEST_MASK) == APIC_DEST_PHYSICAL) &&
 		((data & APIC_MODE_MASK) == APIC_DM_FIXED) &&
 		((u32)(data >> 32) != X2APIC_BROADCAST)) {
-- 
2.7.4

