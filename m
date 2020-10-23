Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30712976F9
	for <lists+kvm@lfdr.de>; Fri, 23 Oct 2020 20:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754903AbgJWSeV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Oct 2020 14:34:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43417 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754879AbgJWSeS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Oct 2020 14:34:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603478056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=cTvR8xPhBTnctesD+UwXV0vJvGddfU/U+PeIHcm+QMIRXObmB6jlSWbNPtLlI6D5NG8KHq
        7IMQNWGbAMvlqonWgtuMb3aBKs3a7oZz550lZjEWRGAazDbMaLgyCbj/euhWy9MLRa688X
        lRfENadsmSYQNhpzuzrTWmCI4MFxEfc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-520-Zz6nPlHKPW2id6W1Rf5U1A-1; Fri, 23 Oct 2020 14:34:15 -0400
X-MC-Unique: Zz6nPlHKPW2id6W1Rf5U1A-1
Received: by mail-qk1-f200.google.com with SMTP id j20so1624229qkl.7
        for <kvm@vger.kernel.org>; Fri, 23 Oct 2020 11:34:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=H5C3/NcFxkdQIh4bagZPNWdO0aqfuI+AYiUceFqudkL2dGdN6UMODiKpilFyRSHK32
         rFDy5+HEfJvngJmSZscAuWX4shPTQ8r/pOqy8Me87Jj0qfpLQNH8IkVJQkyquNrDPk1t
         zkC2K0b4KTnlGx3nZ98Gba1JVWNmlaPlWw9DEbPXK5IhhIl9t6AwcUAmYhPAw24kV/zd
         2pmxugWTYWwNi5AyESZSYiZNH68mvOvcjd2M0NfmOy95RPv2MZ4M/nFkxdhp9i/hqSsm
         RWQ6JRlI6LHq1pe/J2YQ4Ggf+YkxVhFMhCQbmj1EvFMXqpKUrA6e+EQZMz/uaCD97OJD
         Lo2A==
X-Gm-Message-State: AOAM532H8MRnS63JIPGvQ9TqhVa4VX6SB2zNPeYN7qEOS1h+612X3/Nm
        +q0SYLQJpLF3sbeDBP/SicA2+rUtHTQHunLUSOWETvxLx9SzT4Aju2r3PxwYO2MvEQPMNt8Mqti
        YNLEuR21uAxOD
X-Received: by 2002:a05:620a:1e7:: with SMTP id x7mr3511151qkn.465.1603478054152;
        Fri, 23 Oct 2020 11:34:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdbEKO+mgZn7fwYiD7deukv0UF5TGReMh4GNOJSVqM5OzUudOoLbS84dolU1UuPtlhENiuCw==
X-Received: by 2002:a05:620a:1e7:: with SMTP id x7mr3511035qkn.465.1603478052715;
        Fri, 23 Oct 2020 11:34:12 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id u11sm1490407qtk.61.2020.10.23.11.34.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 11:34:11 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        peterx@redhat.com, Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v15 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Fri, 23 Oct 2020 14:33:52 -0400
Message-Id: <20201023183358.50607-9-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201023183358.50607-1-peterx@redhat.com>
References: <20201023183358.50607-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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

