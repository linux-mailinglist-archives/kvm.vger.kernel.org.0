Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30B1D199E90
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 21:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbgCaTBG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 15:01:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44640 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730081AbgCaTA5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Mar 2020 15:00:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585681256;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mBeZgqbPS2/FWwO6pnXFu0eVYzKmasr03QOYT6AICyE=;
        b=Lv8zH9fMpE9BoBZ43Z16Uf0OhiydA6QPwvoTBXqJT+9Noqy98wNuC4oAxkHBVl808HjQbq
        W2TynUKfHMiH98FBcin5xayD4dQuzWCoP3IjOENUpjNYu2cckN0gdolGc6bEtssbqVaU5V
        acbncmzhE3sriRBHkDu+ox87ItRE5rY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-OJY3F19vOYKwplk7x9cdig-1; Tue, 31 Mar 2020 15:00:54 -0400
X-MC-Unique: OJY3F19vOYKwplk7x9cdig-1
Received: by mail-wr1-f72.google.com with SMTP id u16so10398282wrp.14
        for <kvm@vger.kernel.org>; Tue, 31 Mar 2020 12:00:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mBeZgqbPS2/FWwO6pnXFu0eVYzKmasr03QOYT6AICyE=;
        b=heLWBekRFxkiTpTcInnwCYdfU4Q18ceEpnzCYyeU3+bHPT743oqRe8W7jKCOXft2zP
         +miwGKf3y27j1TYGC5kkMsIxpHp6/z0iRLe+x83yZVF5leJCcI37qeFcjr7aVW/aT3tr
         tlz4CUNYisrtmc1L7QgbfcdzL8hwt6jV+tcTtZCR0z/+1D85zPUUnw4XybwbdACMUqbt
         wTLL5bRsEGVCPQCUPHqWLvNVIZaK4Hx6/mho9LSfw24KaZ6NuYNh5qSjvB6VJtQkqO40
         c83WyCslRaEaG3iNMmED5Xm9hNmbgleWmfYhpeRa902RYQ8GEmfEheLddYwOLK3li0mh
         46Eg==
X-Gm-Message-State: ANhLgQ1+rctkZr3kI/J7u+ygPsfSvNKr3/iuDW9/76m6zPbOTlnz7zOn
        2xdNqhQXSJiF3YJcckq1J+KtRWWzenJFU+z5cl+UB3pZdxPm2IZ/nZqoxgzP3QyRFSN/afvf1sd
        a/DR5b9le3Yz+
X-Received: by 2002:adf:ed42:: with SMTP id u2mr23267918wro.175.1585681253674;
        Tue, 31 Mar 2020 12:00:53 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vvw7dspAUr3v867wOvqD+4fThISVCr4cOSo/0L9hQFvFTZpAQC3J7Z80h0Sz8FhZoplTN5kdQ==
X-Received: by 2002:adf:ed42:: with SMTP id u2mr23267898wro.175.1585681253504;
        Tue, 31 Mar 2020 12:00:53 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id o14sm4882863wmh.22.2020.03.31.12.00.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 12:00:52 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Kevin Tian <kevin.tian@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com
Subject: [PATCH v8 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Tue, 31 Mar 2020 14:59:54 -0400
Message-Id: <20200331190000.659614-9-peterx@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200331190000.659614-1-peterx@redhat.com>
References: <20200331190000.659614-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We don't clear the dirty bitmap before because KVM_GET_DIRTY_LOG will
clear it for us before copying the dirty log onto it.  However we'd
still better to clear it explicitly instead of assuming the kernel
will always do it for us.

More importantly, in the upcoming dirty ring tests we'll start to
fetch dirty pages from a ring buffer, so no one is going to clear the
dirty bitmap for us.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/dirty_log_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/selftests/kvm/dirty_log_test.c
index 752ec158ac59..6a8275a22861 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -195,7 +195,7 @@ static void vm_dirty_log_verify(enum vm_guest_mode mode, unsigned long *bmap)
 				    page);
 		}
 
-		if (test_bit_le(page, bmap)) {
+		if (test_and_clear_bit_le(page, bmap)) {
 			host_dirty_count++;
 			/*
 			 * If the bit is set, the value written onto
-- 
2.24.1

