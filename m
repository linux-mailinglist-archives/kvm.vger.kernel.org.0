Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3609D286981
	for <lists+kvm@lfdr.de>; Wed,  7 Oct 2020 22:54:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728691AbgJGUym (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Oct 2020 16:54:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728183AbgJGUx7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 7 Oct 2020 16:53:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602104038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=Nszc3tYYh12NB98pfEwckCvyoP6/qdMi5yjsQ1PwptIne+igyXM7nnglXSFPrTrWasShh9
        N/yUHbKpQSMDeBCj2YnO1PnOXdFiMjxajmIkBl+2JajmpTqM4rLQv1dh3T1WsFzdg75bGy
        FqA5sdEUIkTF5bvT0OYCHpDL+AypjN0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-3-79GUATT2NgmM5SGM4Y-MfA-1; Wed, 07 Oct 2020 16:53:55 -0400
X-MC-Unique: 79GUATT2NgmM5SGM4Y-MfA-1
Received: by mail-qv1-f71.google.com with SMTP id h12so2168147qvk.22
        for <kvm@vger.kernel.org>; Wed, 07 Oct 2020 13:53:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R2ALy67CtgBF8fDQMZT8Ir08uhC8QFjLGT5DkxROP8I=;
        b=F5Nbxwc1ZygCpQ3b8QgADVZM2vifx6cnD3QZthCMKsM82e5Jlzgq62BtjB/CERt+si
         QnVZIErN4FSjEO+7z1WiSpFqdvk0uLrsfd1JK9FDeEyV3M5sgtz9V+xQNCMj3PwjiRnY
         adiXPIn2uNF1VwfamxwgZ9cOh1BCE+rfO9zeSkzdZmhuzBxM9CSrlJ6Mg1BCS+VWX+zn
         uPUOkpY6u3oXRmbyb7pFWs8uGC45/C5c2WRGjxj+AbmyojgDtWtacXrVSTdpDrd2dI2N
         TabI7NOlzyaLP5frEsoeXYya9X+m5YbjGokfNtBRQXelnEuNEQsBl2dJh0ZDHRibzDbJ
         //aA==
X-Gm-Message-State: AOAM531x9zuLZbWaqGT1kfi8jAztqaqsEmWqnJ2mqFQFl3It5eAWJ9AZ
        12gLnmqvuPltG02vtcoPFE9L5Ru10F8ZHPnylGKgrfmDhVU7nDFG840g62GaF0ZJfF9WYZgfFw/
        ZR23tCKfZqEJA
X-Received: by 2002:a37:b85:: with SMTP id 127mr4733455qkl.230.1602104035035;
        Wed, 07 Oct 2020 13:53:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzNUecZBcDoami0FgrEK8uMvljBkI+3Br5QGNDj7PWgW8PdPE9toF3hper1BbPd65eaXmNpRw==
X-Received: by 2002:a37:b85:: with SMTP id 127mr4733440qkl.230.1602104034781;
        Wed, 07 Oct 2020 13:53:54 -0700 (PDT)
Received: from xz-x1.redhat.com (toroon474qw-lp140-04-174-95-215-133.dsl.bell.ca. [174.95.215.133])
        by smtp.gmail.com with ESMTPSA id j24sm2390695qkg.107.2020.10.07.13.53.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 13:53:54 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     peterx@redhat.com, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Andrew Jones <drjones@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: [PATCH v14 08/14] KVM: selftests: Always clear dirty bitmap after iteration
Date:   Wed,  7 Oct 2020 16:53:36 -0400
Message-Id: <20201007205342.295402-9-peterx@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201007205342.295402-1-peterx@redhat.com>
References: <20201007205342.295402-1-peterx@redhat.com>
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

