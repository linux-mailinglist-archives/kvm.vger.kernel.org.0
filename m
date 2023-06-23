Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ADE573B844
	for <lists+kvm@lfdr.de>; Fri, 23 Jun 2023 14:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231830AbjFWMzP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jun 2023 08:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjFWMzN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Jun 2023 08:55:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219A31FF5
        for <kvm@vger.kernel.org>; Fri, 23 Jun 2023 05:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687524867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=9fCMPOeXvmZRh+e8bRoilHrrW+K9gcC171wg8gjwxXk=;
        b=gXuh7p4PmCXNsfm+6nMOH/OEe/18S3nxy1oDNSJ1PqxwYdGSm0c9DXgNNavRqyRnZ2QYBH
        tZXanZM5EWKSxGpEbU60qLzwekIiyNg8s7IGAt0+mp9bnSidpd0GYhoNxNmcN829H7Vyup
        +NwvnCnagfhLH25O1+ks72oIORkA0v8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-401-5TjDrdBlOmy0RWPp0ZCtNQ-1; Fri, 23 Jun 2023 08:54:22 -0400
X-MC-Unique: 5TjDrdBlOmy0RWPp0ZCtNQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6C3F3185A7A4;
        Fri, 23 Jun 2023 12:54:21 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.208])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EBF14F41C8;
        Fri, 23 Jun 2023 12:54:18 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Nico=20B=C3=B6hr?= <nrb@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andrew Jones <andrew.jones@linux.dev>
Cc:     kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, David Hildenbrand <david@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: [kvm-unit-tests PATCH 0/2] Rework LDFLAGS and link with noexecstack
Date:   Fri, 23 Jun 2023 14:54:14 +0200
Message-Id: <20230623125416.481755-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I noticed that the latest version of ld (in Fedora rawhide) emits
a warning on x86 and s390x, complaining about missing .note.GNU-stack
section that implies an executable stack. It can be silenced by
linking with "-z noexecstack".

While trying to add this switch globally to the kvm-unit-tests, I
had to discover that the common LDFLAGS are hardly used anywhere,
so the first patch cleans up that problem first before adding the
new flag in the second patch.

Thomas Huth (2):
  Rework the common LDFLAGS to become more useful again
  Link with "-z noexecstack" to avoid warning from newer versions of ld

 Makefile                | 2 +-
 arm/Makefile.common     | 2 +-
 powerpc/Makefile.common | 2 +-
 s390x/Makefile          | 2 +-
 x86/Makefile.common     | 4 ++--
 5 files changed, 6 insertions(+), 6 deletions(-)

-- 
2.39.3

