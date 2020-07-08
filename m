Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBD32190C9
	for <lists+kvm@lfdr.de>; Wed,  8 Jul 2020 21:35:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgGHTfO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jul 2020 15:35:14 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28673 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726793AbgGHTe1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Jul 2020 15:34:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594236866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=EZZutiumfZvzjn8RNVzxfEF1kJWBMpFtWLqRLUsS3202EJ6HmvJ+Ec6dxwlMkXM8p8HCIf
        0LQ3YHiqaC8nlkW/9sIlrQ937GoSkQc2I0xDpkmKCU14iRuekzUM2SSnTLyrHZewmGqnhw
        GjF35iN4klQ4fSuOMYNf7rByrJitPOg=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-276-_ZzTXcxXOGiZLaVSgOdfQw-1; Wed, 08 Jul 2020 15:34:25 -0400
X-MC-Unique: _ZzTXcxXOGiZLaVSgOdfQw-1
Received: by mail-qt1-f197.google.com with SMTP id z26so15448243qto.15
        for <kvm@vger.kernel.org>; Wed, 08 Jul 2020 12:34:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=gX6cnRyABNBttKsFRKfAIQUVvO8xABW6+KeZWF9UQbbLmKNgQ2uZkxu5inW1BoHR+G
         A59ydX9V1Hm5RtRtqRFfsasLMnyivNMwR5uunyaxAb4bpv4OAZVNhPEmdJ4rnAjAOooD
         7qdy8kj9S5NmzZ5Y6REw71dQ//vVm/Ba2Wll3Rb5flxFrb4eC3BI4JNK2QleBQIW2Wcz
         oQa7pgbYFIUGqgtGTqqEkbOHEouDlY5qJGgLvMCENv9iFo56mFE/gyGPoLrWLgKPIey4
         tjC8n0wvr/+/MYB5kZ54xw85Xq/A/k552TTtyYY0vQ7qHD9W2E/hM3PiEv8FFI0HLnP6
         klkQ==
X-Gm-Message-State: AOAM533shVN/tN0XSGH8Elv+va64L4bH9tP3nsyh29S2Xzt6nDrokJBn
        t3TH9tFddsKcOWvoGlA8v/nqp5B7F+XDn+xaqzb4/rhuytUfSxdsscev1Hbdqkoc/f0iA1Ou1zG
        66R0BWjEctFBA
X-Received: by 2002:a0c:f007:: with SMTP id z7mr12358709qvk.7.1594236864410;
        Wed, 08 Jul 2020 12:34:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNudtqF/CkjxEg9VqtYEqf+ZZpg4k8TSXkm0fMX6iXRSwsXGO5WKceDC9wqDsQaRDfMvt/OA==
X-Received: by 2002:a0c:f007:: with SMTP id z7mr12358695qvk.7.1594236864170;
        Wed, 08 Jul 2020 12:34:24 -0700 (PDT)
Received: from xz-x1.redhat.com ([2607:9880:19c8:6f::1f4f])
        by smtp.gmail.com with ESMTPSA id f18sm664884qtc.28.2020.07.08.12.34.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 12:34:23 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v11 07/13] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Wed,  8 Jul 2020 15:34:02 -0400
Message-Id: <20200708193408.242909-8-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200708193408.242909-1-peterx@redhat.com>
References: <20200708193408.242909-1-peterx@redhat.com>
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

Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.26.2

