Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66593369DE8
	for <lists+kvm@lfdr.de>; Sat, 24 Apr 2021 02:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243974AbhDXAro (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Apr 2021 20:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237240AbhDXArl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Apr 2021 20:47:41 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA75DC06174A
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:02 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id u73-20020a25ab4f0000b0290410f38a2f81so26212013ybi.22
        for <kvm@vger.kernel.org>; Fri, 23 Apr 2021 17:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=RHGsqWwH1zxHj0xIe8K4VtoI6F8/53X2i4hvFea/Jtc=;
        b=OPjwaJ3YTXeq24If+8hQOW0VyJ+bADxa0ZRW5sPafB80mG4gzK4fam3t9CjRIQWl7T
         wGw7HJd4vszwt8ioG7VoGFwsLhoabf0qd/kaDt6vxb6365MyOLPhCdgvplw3BaMQ2qs8
         No6dsSgvzPfQcYF09OgMhnG4ahp0tp7RHLuXXmJ8jKSi2UmICvWZbzP2d/nJLz71SmY9
         lWxco2nnDLF9nUs8asjapZgxqWC9N3Z/d9gP+9Gmrj6EzMj0uHmP/G6vRkJPYNyoVxgz
         5l+Kvb6xbV4lSKxLTbI/+68iCD6p8msMn5HQemfW0SzONRC/SXhKoPbgtQYkTQWLFvJy
         O2cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=RHGsqWwH1zxHj0xIe8K4VtoI6F8/53X2i4hvFea/Jtc=;
        b=e981HZOg+yUbP0igHDM0VB5yqwq09laBsbPb9w5yUmFc5M4P/yOW4hfMpe+/t8Gb9s
         eF8R8/K6yDmI41jqTZUA4vbBywBIR9Vx+tcil5joRag42cZLFjl1JcUot51wz957veEY
         01BxgasFmoSny4Wn3autnO+mb/AgiVm1LAhcNPp5n72f46gUQlRXBm0qKT8YMbzQkHTG
         M58sGb4hvZp0evcpIQmHc0jIYoDJgs+WRjQ3/I/JAQvawgOq8e2PFxZQwZJnMYsBkRo+
         TQx0iRrn0vGem/FBGcdZKXWMjVV1D8Mi8NmDEOkGfJAfa+oNe1j/8RaDVT4zUQFewEDx
         4xZg==
X-Gm-Message-State: AOAM532YKPYyCdCq5pOH9GXbfF72XpaaoJLgF+FWpj0YOj3QnPC0H77x
        /LyfyvMn0C6JBdQ8hHpnYra3+o01xaU=
X-Google-Smtp-Source: ABdhPJzX+waosmfrUN513JsYHxpFuDWHWvyn4N/ji2D0vC9EQhyeKOU7/v4bDJ04Jc3LfwehTPEuiQqvW2Q=
X-Received: from seanjc798194.pdx.corp.google.com ([2620:15c:f:10:ad52:3246:e190:f070])
 (user=seanjc job=sendgmr) by 2002:a25:ac9b:: with SMTP id x27mr8963271ybi.120.1619225222104;
 Fri, 23 Apr 2021 17:47:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 23 Apr 2021 17:46:03 -0700
In-Reply-To: <20210424004645.3950558-1-seanjc@google.com>
Message-Id: <20210424004645.3950558-2-seanjc@google.com>
Mime-Version: 1.0
References: <20210424004645.3950558-1-seanjc@google.com>
X-Mailer: git-send-email 2.31.1.498.g6c1eba8ee3d-goog
Subject: [PATCH 01/43] KVM: nVMX: Set LDTR to its architecturally defined
 value on nested VM-Exit
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Set L1's LDTR on VM-Exit per the Intel SDM:

  The host-state area does not contain a selector field for LDTR. LDTR is
  established as follows on all VM exits: the selector is cleared to
  0000H, the segment is marked unusable and is otherwise undefined
  (although the base address is always canonical).

This is likely a benign bug since the LDTR is unusable, as it means the
L1 VMM is conditioned to reload its LDTR in order to function properly on
bare metal.

Fixes: 4704d0befb07 ("KVM: nVMX: Exiting from L2 to L1")
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/nested.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 00339d624c92..32126fa0c4d8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4276,6 +4276,10 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 	};
 	vmx_set_segment(vcpu, &seg, VCPU_SREG_TR);
 
+	memset(&seg, 0, sizeof(seg));
+	seg.unusable = 1;
+	vmx_set_segment(vcpu, &seg, VCPU_SREG_LDTR);
+
 	kvm_set_dr(vcpu, 7, 0x400);
 	vmcs_write64(GUEST_IA32_DEBUGCTL, 0);
 
-- 
2.31.1.498.g6c1eba8ee3d-goog

