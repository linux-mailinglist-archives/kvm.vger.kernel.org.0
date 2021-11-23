Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE81545995A
	for <lists+kvm@lfdr.de>; Tue, 23 Nov 2021 01:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhKWAyH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Nov 2021 19:54:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:55266 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232213AbhKWAxu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 22 Nov 2021 19:53:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637628642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LwY8go0ZnlnK4UVqjr/H1j0gihuIWdk1oPfwycpo2rE=;
        b=jMWXZdXwRR3feXK+h0Pkac6L9CMlTGklVln6Ezl0XUuyDTUjIWMgNCWTrKrme0xcTpsC3d
        igLgYbTAtaraw8z5eyHF/Jl+KAoKZFzl/BZFRRBG6DTVDLlQ6iWQ/1nAOChWsDwMJQx95J
        HoRURNeqg4WIQPCXTlqLWyhLcRotphg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-317-7oVvJbzrPAC0tIk9l4DWuA-1; Mon, 22 Nov 2021 19:50:39 -0500
X-MC-Unique: 7oVvJbzrPAC0tIk9l4DWuA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6A4BB87950C;
        Tue, 23 Nov 2021 00:50:38 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1BA0D5C1C5;
        Tue, 23 Nov 2021 00:50:38 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com
Subject: [PATCH 04/12] KVM: SEV: do not use list_replace_init on an empty list
Date:   Mon, 22 Nov 2021 19:50:28 -0500
Message-Id: <20211123005036.2954379-5-pbonzini@redhat.com>
In-Reply-To: <20211123005036.2954379-1-pbonzini@redhat.com>
References: <20211123005036.2954379-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

list_replace_init cannot be used if the source is an empty list,
because "new->next->prev = new" will overwrite "old->next":

				new				old
				prev = new, next = new		prev = old, next = old
new->next = old->next		prev = new, next = old		prev = old, next = old
new->next->prev = new		prev = new, next = old		prev = old, next = new
new->prev = old->prev		prev = old, next = old		prev = old, next = old
new->next->prev = new		prev = old, next = old		prev = new, next = new

The desired outcome instead would be to leave both old and new the same
as they were (two empty circular lists).  Use list_cut_before, which
already has the necessary check and is documented to discard the
previous contents of the list that will hold the result.

Fixes: b56639318bb2 ("KVM: SEV: Add support for SEV intra host migration")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/svm/sev.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 21ac0a5de4e0..75955beb3770 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1613,8 +1613,7 @@ static void sev_migrate_from(struct kvm_sev_info *dst,
 	src->handle = 0;
 	src->pages_locked = 0;
 
-	INIT_LIST_HEAD(&dst->regions_list);
-	list_replace_init(&src->regions_list, &dst->regions_list);
+	list_cut_before(&dst->regions_list, &src->regions_list, &src->regions_list);
 }
 
 static int sev_es_migrate_from(struct kvm *dst, struct kvm *src)
-- 
2.27.0


