Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C292A10DB15
	for <lists+kvm@lfdr.de>; Fri, 29 Nov 2019 22:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387499AbfK2VgH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Nov 2019 16:36:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:59140 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727450AbfK2Vf1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Nov 2019 16:35:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575063326;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+epP0ZJNrOuBWj/134Gm2Sk2TIexg1BXp/mPjOqGz4M=;
        b=BWLK2yT9krbcdIIjiUruP3AMscc/Lvzd0GZgOW4iEx+UVEo0GexnZvZwY3EzLOLFgsUlWC
        AvZ3cRwmK939s20wFo1OqTl7VuO6anADdRizpfVP5ZcePtFwhBMPAgv7wZbtu6Ijw0If5I
        2tdsyq5NCdOSqpfp385p3NJElSqs6Nw=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-JYydI4HEMfKFPfbC5T4qqg-1; Fri, 29 Nov 2019 16:35:22 -0500
Received: by mail-qk1-f197.google.com with SMTP id w85so18624501qka.13
        for <kvm@vger.kernel.org>; Fri, 29 Nov 2019 13:35:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dvCZjak4fUQXL1Tj0+D6gDZOBS7ZBlh7A3EqUR5B3UM=;
        b=SwomU2dmZojLq1XRwgfZzjJbwbWTMRU0L2T67oLGMUB7x4Ouc/5Mm/mRKRamlyUfp6
         O4KhVz8/4oV2xbAFA3ln7d9Bb3ToFfqOItf8houyCWVVLpxQOGwCr8uRdo8GqQybh1Xx
         bpsxxo80JjzF+J7Ry/u1YZooFCgSFELmjQD4FGLEVBBdBkfe13NvIVLnaJ9c1gF8I7CA
         7uN9scYjGLjw4u5i82z7Lg4+7eSzep+UxFq4ZYh4smiOlUi01mqlYdiFubO0VBfCdsgf
         e+tWPh3YkQ6gna63GteR7odFJLN3kUCjqfOkGqpZG1bSgtCVuu7r0B0e3Id0kdIS0kmM
         T70w==
X-Gm-Message-State: APjAAAX5OOOjiuYFk/uzL29XG7DOACP9Ui3kSvdZz9UoYaxVqkmoWFoB
        35h8wS53/zxS/MDtQzk4o0PQtlPB6piy+slb5IvgnAVSYWzw//YfaDQkBGLGPszdfP224X/VOqO
        4R1JWCoOcrcx+
X-Received: by 2002:aed:2041:: with SMTP id 59mr53330741qta.79.1575063322429;
        Fri, 29 Nov 2019 13:35:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqwlnBfGzVgTWxwT4m5yNzjwn1Ma5s2++ZIonxctUkmfr8RexiTx7Q64cvVDuUWaR5tujaL0Kg==
X-Received: by 2002:aed:2041:: with SMTP id 59mr53330724qta.79.1575063322256;
        Fri, 29 Nov 2019 13:35:22 -0800 (PST)
Received: from xz-x1.yyz.redhat.com ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h186sm10679046qkf.64.2019.11.29.13.35.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2019 13:35:20 -0800 (PST)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>, peterx@redhat.com,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: [PATCH RFC 08/15] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Fri, 29 Nov 2019 16:34:58 -0500
Message-Id: <20191129213505.18472-9-peterx@redhat.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191129213505.18472-1-peterx@redhat.com>
References: <20191129213505.18472-1-peterx@redhat.com>
MIME-Version: 1.0
X-MC-Unique: JYydI4HEMfKFPfbC5T4qqg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
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

diff --git a/tools/testing/selftests/kvm/dirty_log_test.c b/tools/testing/s=
elftests/kvm/dirty_log_test.c
index 5614222a6628..3c0ffd34b3b0 100644
--- a/tools/testing/selftests/kvm/dirty_log_test.c
+++ b/tools/testing/selftests/kvm/dirty_log_test.c
@@ -197,7 +197,7 @@ static void vm_dirty_log_verify(unsigned long *bmap)
 =09=09=09=09    page);
 =09=09}
=20
-=09=09if (test_bit_le(page, bmap)) {
+=09=09if (test_and_clear_bit_le(page, bmap)) {
 =09=09=09host_dirty_count++;
 =09=09=09/*
 =09=09=09 * If the bit is set, the value written onto
--=20
2.21.0

