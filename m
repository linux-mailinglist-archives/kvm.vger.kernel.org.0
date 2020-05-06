Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBBE1C6D8D
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 11:50:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgEFJuh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 05:50:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44754 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729153AbgEFJuh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 05:50:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588758636;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZENkbpOQATs9T0Mx8ZvJbUDiOPi/mRt38fEpR3MkuxY=;
        b=i5L9wF88seGVdDzccMWT2oXGFVf3Ro49UN3LJZ7oHHsVaO2gLZ1ko/DGD5cOLtHxTwfKBw
        ofoUnDYgHhvUccvc4Cm8mX4eUK2mn7WdK2+SGaz8gF99mnsGQzy/IPxFSX6ifWCt28eVp3
        L2FWse4+HN76fWw5DwYk43Y6q1ZsGkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-193-YleYrMkWOMubZD7E1CkN7A-1; Wed, 06 May 2020 05:50:34 -0400
X-MC-Unique: YleYrMkWOMubZD7E1CkN7A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A54FB100CCC5;
        Wed,  6 May 2020 09:50:33 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-113-17.ams2.redhat.com [10.36.113.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 402C15C1BD;
        Wed,  6 May 2020 09:50:26 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH v1 06/17] target/i386: sev: Use ram_block_discard_set_broken()
Date:   Wed,  6 May 2020 11:49:37 +0200
Message-Id: <20200506094948.76388-7-david@redhat.com>
In-Reply-To: <20200506094948.76388-1-david@redhat.com>
References: <20200506094948.76388-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

AMD SEV will pin all guest memory, mark discarding of RAM broken. At the
time this is called, we cannot have anyone active that relies on discards
to work properly.

Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 target/i386/sev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/sev.c b/target/i386/sev.c
index 846018a12d..608225f9ba 100644
--- a/target/i386/sev.c
+++ b/target/i386/sev.c
@@ -722,6 +722,7 @@ sev_guest_init(const char *id)
     ram_block_notifier_add(&sev_ram_notifier);
     qemu_add_machine_init_done_notifier(&sev_machine_done_notify);
     qemu_add_vm_change_state_handler(sev_vm_state_change, s);
+    g_assert(!ram_block_discard_set_broken(true));
=20
     return s;
 err:
--=20
2.25.3

