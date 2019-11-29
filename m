Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDB3F10DB1A
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:36:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727391AbfK2VfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:35:19 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48060 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727379AbfK2VfS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 Nov 2019 16:35:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063316;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UeO3g+8EGPox+V7IC6l3NZw9JSTY7gBZHk7XmDQfPZM=;
        b=P9lYJ2tPvrJZACsKinI3PEhqg5XRBaZRtn9kBEW6zGdnSWnZUI/KGaRC9Raf1ZOptjJ/Sp
        qBcdGSBxmn/iRvTzaa38Z5cysAtQPPWWWEVnoUMGpUFgEfpp/Phrz9qXSAENHLi52SZym/
        3Hd0G44mCMvMoEVivbF+tmKIVfEOZyY=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-lPEEOwF1POKBL9bCXOMsjA-1; Fri, 29 Nov 2019 16:35:12 -0500
Received: by mail-qv1-f72.google.com with SMTP id d38so7498584qvc.5
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FRodLl/V9ZOtTlsVO+ztnjUNpRnKukvb2eZH8xGgAiY=;
        b=BXoxpW8nFBEvrREUcZKK1jBNgpECUtWT7rhh0tkMjhhcKmq9o74GBH8vXEqQ+llKQx
         RyC6hZML1KXoBj9UhPOnwtnrfRlKZmB/pu//BHJIsm+kc/HQKhkqEi80xLJEhbICHmKX
         7ok+MlKSme25JWupVkMQwEqxixy7eqQSNWZzp7MxHTTYCEEdd5UejAF7cM8DLsUdYNKW
         oufSwYx9I9p9Twu36PYjUykLVRqHjyLzQN4RWBno+UDo/8bQNw+wsDxKcwm+TXsIFSQ2
         s1OJbuOn1drzqkU/JgBUw3TpSotyXiZSd+BMde6s83yLXocKfd3aSvG8Pj5KTXEXsfpX
         JQZg==
X-Gm-Message-State: APjAAAWldTptnqNtB2OmJeeKjESrosXmYNjKew0kI8QVrJvqrAW7FbDh
        ldTeBgyygK6/BZn4eBYSPyPtKy//dgH3RxVACq+2mp4ZU+TQL5t/5fGuvaxQPuADtaW8kpIXjcy
        DMabeoTOOBc2l
X-Received: by 2002:a05:620a:791:: with SMTP id 17mr14299260qka.31.1575063312368;
        Fri, 29 Nov 2019 13:35:12 -0800 (PST)
X-Google-Smtp-Source: APXvYqyGqiYFQUWgvgas2yyRUTgB8tPpZ6d427pLUydcx4nN9XKk1dNq0eHIFESm5vWkr4DFME/SSg==
X-Received: by 2002:a05:620a:791:: with SMTP id 17mr14299242qka.31.1575063312153;
        Fri, 29 Nov 2019 13:35:12 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:11 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 03/15] KVM: Add build-time error check on kvm_run size
Date:   Fri, 29 Nov 2019 16:34:53 -0500
Message-Id: <20191129213505.18472-4-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: lPEEOwF1POKBL9bCXOMsjA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

It's already going to reach 2400 Bytes (which is over half of page
size on 4K page archs), so maybe it's good to have this build-time
check in case it overflows when adding new fields.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 virt/kvm/kvm_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 8f8940cc4b84..681452d288cd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -352,6 +352,8 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kv=
m, unsigned id)
 =09}
 =09vcpu->run =3D page_address(page);
=20
+=09BUILD_BUG_ON(sizeof(struct kvm_run) > PAGE_SIZE);
+
 =09kvm_vcpu_set_in_spin_loop(vcpu, false);
 =09kvm_vcpu_set_dy_eligible(vcpu, false);
 =09vcpu->preempted =3D false;
--=20
2.21.0

