Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1FDA6F0CE3
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 22:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344154AbjD0UMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 16:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244338AbjD0UMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 16:12:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EDC359B
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 13:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682626284;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MVxEyT6YPQv9FpKzpmnFDZ3linRqP6xqGLLw8EoheGs=;
        b=GDMoeeJleANbP9moaA0mW/zH2rDHdWqH4yJJkkKNIqmeQEVlFaTM8tgyLSj8VnqSccZgxd
        2zdGgBDNVyAWUcDMf6ZF6ZOIQXJ4e6QU8ykngpT4ikkm0stQOsZW84iYmdEK99gcbwEUJn
        C/5/6oFP7XOD4iyjq41skUcou0+dcTk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-4i5mTtWxPQ2NfuBJvdHYfw-1; Thu, 27 Apr 2023 16:11:23 -0400
X-MC-Unique: 4i5mTtWxPQ2NfuBJvdHYfw-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3ef32210cabso19397451cf.0
        for <kvm@vger.kernel.org>; Thu, 27 Apr 2023 13:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682626279; x=1685218279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MVxEyT6YPQv9FpKzpmnFDZ3linRqP6xqGLLw8EoheGs=;
        b=lz7rPjVd3W4k8ubdnNfgI7jY067NcIMuG5/o6tx0Ot7Dl4WUPMusIw95ycNoLgd8nK
         0fIxwawxsgCsxjx18ROaLUI9BGs886iwEbnYuenwYJ90nPLwAEdTIbdJ9PlCRU5CFLnz
         3dbxaNVjjPTYxWUb4qu1HS7PHI29sAaVY6FfJCxlyXR3TWsayn93bD3HljrKlkERtr99
         j0BaPGC3vPIiranuI7XN/LoQ5OaDVK+Wi7L0/Tpt6ue2apmoEzd53G6Noi/e4Vqa2qKp
         4ghDQyCBx930LRffL6DLuN6n4JAwj+FsmOeH9l9EvPlW2Y+qM8sooiAVEo9KPwYEfGfB
         iI7w==
X-Gm-Message-State: AC+VfDzlWk5Qo6Bx7yxScs/z++g+ms/ThR//Qvvkr+5SyRSgwOt2sohF
        5W8vF01t3oI1US11rMw8k5zeAYydGg2cvanNjNcKYchu+LwDurPcv0msYXqlXrqWNwqKxqbL1kj
        WiKWewKiOFYCM
X-Received: by 2002:a05:622a:1a96:b0:3e6:8da4:427 with SMTP id s22-20020a05622a1a9600b003e68da40427mr4968040qtc.6.1682626279432;
        Thu, 27 Apr 2023 13:11:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5KE3lCDUjGNayup5e1EtQDHBZuAYaJD+lDZp2gHW+Y3izIr/NFp0H2THH7zdu1g2qOvrSQgA==
X-Received: by 2002:a05:622a:1a96:b0:3e6:8da4:427 with SMTP id s22-20020a05622a1a9600b003e68da40427mr4968005qtc.6.1682626279102;
        Thu, 27 Apr 2023 13:11:19 -0700 (PDT)
Received: from x1n.redhat.com (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id d19-20020a05620a241300b0074fb065bde4sm3444283qkn.18.2023.04.27.13.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 13:11:18 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        James Houghton <jthoughton@google.com>, peterx@redhat.com,
        Anish Moorthy <amoorthy@google.com>
Subject: [PATCH 2/2] selftests/kvm: Allow dump per-vcpu info for uffd threads
Date:   Thu, 27 Apr 2023 16:11:12 -0400
Message-Id: <20230427201112.2164776-3-peterx@redhat.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230427201112.2164776-1-peterx@redhat.com>
References: <20230427201112.2164776-1-peterx@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

There's one PER_VCPU_DEBUG in per-vcpu uffd threads but it's never hit.

Trigger that when quit in normal ways (kick pollfd[1]), meanwhile fix the
number of nanosec calculation.

Signed-off-by: Peter Xu <peterx@redhat.com>
---
 tools/testing/selftests/kvm/lib/userfaultfd_util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/lib/userfaultfd_util.c b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
index 92cef20902f1..271f63891581 100644
--- a/tools/testing/selftests/kvm/lib/userfaultfd_util.c
+++ b/tools/testing/selftests/kvm/lib/userfaultfd_util.c
@@ -70,7 +70,7 @@ static void *uffd_handler_thread_fn(void *arg)
 			r = read(pollfd[1].fd, &tmp_chr, 1);
 			TEST_ASSERT(r == 1,
 				    "Error reading pipefd in UFFD thread\n");
-			return NULL;
+			break;
 		}
 
 		if (!(pollfd[0].revents & POLLIN))
@@ -103,7 +103,7 @@ static void *uffd_handler_thread_fn(void *arg)
 	ts_diff = timespec_elapsed(start);
 	PER_VCPU_DEBUG("userfaulted %ld pages over %ld.%.9lds. (%f/sec)\n",
 		       pages, ts_diff.tv_sec, ts_diff.tv_nsec,
-		       pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / 100000000.0));
+		       pages / ((double)ts_diff.tv_sec + (double)ts_diff.tv_nsec / NSEC_PER_SEC));
 
 	return NULL;
 }
-- 
2.39.1

