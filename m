Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16D3A113574
	for <lists+kvm@lfdr.de>; Wed,  4 Dec 2019 20:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728845AbfLDTHz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 14:07:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:22921 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728465AbfLDTHb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 14:07:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575486450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kn/llSEPws9Kaihse6HkAcboPO6kvjhOBVqBu50kJWM=;
        b=Xa4l98rXBnGh+ETCe0JsN0hNfWFnevNFNopEHcMO5FXqk7R63sKowkrOsuC8BBkEKGbRFz
        sLk/y4Pc0NnvIGLhvVV0tNG0MoNm5xUwbdxCgyKqc+myTYujLjwP/yQlRvZy/S6sTP5Gr2
        oqJ9wh5O1E068gIUf+sHP/pxh+Rr3F8=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-GoAYR2thN3OqKKq4YoRjjQ-1; Wed, 04 Dec 2019 14:07:25 -0500
Received: by mail-qv1-f71.google.com with SMTP id m43so456585qvc.17
        for <kvm@vger.kernel.org>; Wed, 04 Dec 2019 11:07:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qDMFszQpTCz8aKUy2p2BRtrOo8b1SfrY7qPPp6I+jnk=;
        b=qkCqBXhWxRg4ZYk+lHtKleZ3fAY86tuHPIQ7imzKXYDM8I9TvuQzpi4XMUcJGjd14m
         7uQ71HNXtaKbgdH2KMLNJkug4VO+zWVY9xpNuVJNoiPr/EUWKMmS7vQtYJ3NSFfes1Xe
         +yFDxczvfPt8B4hDNa91u/lKAF9FQ5vmi2mgSeXWauDP49QvHfIUxpGdqeiQbQnW56C8
         5iXWlph8O3Q/xxNB7TAvYlIDOs2KBZiTsGEOxFxSWT1Jhrfd/mqfdFrZ6sSS0uYVSq5c
         0ejrwpZ6Jahwo5ien0gK3JN4M1QhY9ZFrCbbSTzuIZp2tutYGsBIpva8uytISVH7GlkL
         03Tw==
X-Gm-Message-State: APjAAAWUzQpJ3fIYcqJ4JXE0t6SKVCaDB8dh8dG0QHCRyU+Gk5yK9nmX
        GRXcwuz617FOdiPnzJ6HEmrIvV2KlduKY/fcU3Flakx+ZcIo9aZi8Xk3olFYbCukZ6GIUKmvUa9
        pWFMTdS1rQCep
X-Received: by 2002:a37:f605:: with SMTP id y5mr4645601qkj.59.1575486444772;
        Wed, 04 Dec 2019 11:07:24 -0800 (PST)
X-Google-Smtp-Source: APXvYqwXcJerAYwuG8Nz4ZOyamZB1Cf11CnFdKyqm2/DvrswGbmWblNXhZd72Q8pcAs4X10qlKVa5A==
X-Received: by 2002:a37:f605:: with SMTP id y5mr4645584qkj.59.1575486444531;
        Wed, 04 Dec 2019 11:07:24 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id y18sm4072126qtn.11.2019.12.04.11.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2019 11:07:23 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Nitesh Narayan Lal <nitesh@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH v5 1/6] KVM: X86: Fix kvm_bitmap_or_dest_vcpus() to use irq shorthand
Date:   Wed,  4 Dec 2019 14:07:16 -0500
Message-Id: <20191204190721.29480-2-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191204190721.29480-1-peterx@redhat.com>
References: <20191204190721.29480-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: GoAYR2thN3OqKKq4YoRjjQ-1
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

