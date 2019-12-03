Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D45611030E
	for <lists+kvm@lfdr.de>; Tue,  3 Dec 2019 17:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfLCQ7M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 3 Dec 2019 11:59:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49293 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727154AbfLCQ7K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 3 Dec 2019 11:59:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575392349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kn/llSEPws9Kaihse6HkAcboPO6kvjhOBVqBu50kJWM=;
        b=Zn08heVy4i5cwuaWKecR8YKjhfSjACBEP5Q7tINwU0llVC8rSIY/9fpsPguox7yFDB3lsc
        rNgHpbtgxDq1m5L84HJvilI/vyLi3cKCLmKxYLaZ43LH73JevyiECp9rPPcNwNkMf5iYEb
        d7tzT6H+qAsTrNCRuPIigqdgeBUy5qA=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-T-dleMvAO1eVjNjfE7xNJQ-1; Tue, 03 Dec 2019 11:59:08 -0500
Received: by mail-qv1-f69.google.com with SMTP id l1so2583748qvu.13
        for <kvm@vger.kernel.org>; Tue, 03 Dec 2019 08:59:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qDMFszQpTCz8aKUy2p2BRtrOo8b1SfrY7qPPp6I+jnk=;
        b=g+W/jA/3/Wg4aDK+YFGj0TnyNBssjR3is37PfTMbkoQbnyM1gFXTUYhuq8UyaL+mMI
         SXiVHb/v1PYORtscaxOSD2eCuNyG7fD4mW8C0hZgOsyBuLPOOw84fMCRdauhwW0mnASZ
         3RttCGOehUeVc34b/cWd0N2qQZJcCXBbNkJcMX2sZ/9PsmseFppeoSGQoe6zJH2wRHaE
         R1w1fZXCECRTd6wn7o/sKKcZvQFqN7ROOt3y7HVtL2H/jsyrmWylWRbt7p03ugEeShbT
         iGwH594YBNCEWcFZTyDnNy4MJjNmVr6kGolOKacRi7OxJRYJb9mNfoaFoqc907tv/2r3
         OiVA==
X-Gm-Message-State: APjAAAVNM1VQHttqzRXnOMGkoXACtceXSOa2EXrWVacYYYsa1jMLr6Sd
        baQfPWX+xhrfONo7Q3eHh9o09cOKlkiPGBfy2Jjm5WiAUXSnHJmxt60YrLwI6uY+2OdMWsSq3AZ
        16ZyIcbkyoI/u
X-Received: by 2002:ac8:1017:: with SMTP id z23mr5821776qti.94.1575392347081;
        Tue, 03 Dec 2019 08:59:07 -0800 (PST)
X-Google-Smtp-Source: APXvYqxg/JOE/OtM1jHS/faP8zXtfiNcD6HKzy7U3+/q3M6bfRuQ5NZYhl14b7ItPtyjdu5wi5+3bg==
X-Received: by 2002:ac8:1017:: with SMTP id z23mr5821756qti.94.1575392346887;
        Tue, 03 Dec 2019 08:59:06 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id a16sm482585qkn.48.2019.12.03.08.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 08:59:05 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v4 1/6] KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand
Date:   Tue,  3 Dec 2019 11:58:58 -0500
Message-Id: <20191203165903.22917-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191203165903.22917-1-peterx@redhat.com>
References: <20191203165903.22917-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: T-dleMvAO1eVjNjfE7xNJQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 3rd parameter of kvm_apic_match_dest() is the irq shorthand,
rather than the irq delivery mode.

Fixes: 7ee30bc132c6 ("KVM: x86: deliver KVM IOAPIC scan request to target v=
CPUs")
Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
---
 arch/x86/kvm/lapic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index cf9177b4a07f..1eabe58bb6d5 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1151,7 +1151,7 @@ void kvm_bitmap_or_dest_vcpus(struct kvm *kvm, struct=
 kvm_lapic_irq *irq,
 =09=09=09if (!kvm_apic_present(vcpu))
 =09=09=09=09continue;
 =09=09=09if (!kvm_apic_match_dest(vcpu, NULL,
-=09=09=09=09=09=09 irq->delivery_mode,
+=09=09=09=09=09=09 irq->shorthand,
 =09=09=09=09=09=09 irq->dest_id,
 =09=09=09=09=09=09 irq->dest_mode))
 =09=09=09=09continue;
--=20
2.21.0

