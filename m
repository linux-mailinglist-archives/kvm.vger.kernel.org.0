Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D3867165
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2019 16:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727364AbfGLOc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Jul 2019 10:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37814 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727354AbfGLOc1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Jul 2019 10:32:27 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id BCE2A3082E56;
        Fri, 12 Jul 2019 14:32:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.36.118.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AECFD60920;
        Fri, 12 Jul 2019 14:32:25 +0000 (UTC)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Wei Yang <richardw.yang@linux.intel.com>
Subject: [PULL 06/19] cutils: remove one unnecessary pointer operation
Date:   Fri, 12 Jul 2019 16:31:54 +0200
Message-Id: <20190712143207.4214-7-quintela@redhat.com>
In-Reply-To: <20190712143207.4214-1-quintela@redhat.com>
References: <20190712143207.4214-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Fri, 12 Jul 2019 14:32:27 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Wei Yang <richardw.yang@linux.intel.com>

Since we will not operate on the next address pointed by out, it is not
necessary to do addition on it.

After removing the operation, the function size reduced 16/18 bytes.

Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Message-Id: <20190610030852.16039-2-richardw.yang@linux.intel.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 util/cutils.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/util/cutils.c b/util/cutils.c
index dfc605f1ef..fd591cadf0 100644
--- a/util/cutils.c
+++ b/util/cutils.c
@@ -756,11 +756,11 @@ int uleb128_encode_small(uint8_t *out, uint32_t n)
 {
     g_assert(n <= 0x3fff);
     if (n < 0x80) {
-        *out++ = n;
+        *out = n;
         return 1;
     } else {
         *out++ = (n & 0x7f) | 0x80;
-        *out++ = n >> 7;
+        *out = n >> 7;
         return 2;
     }
 }
@@ -768,7 +768,7 @@ int uleb128_encode_small(uint8_t *out, uint32_t n)
 int uleb128_decode_small(const uint8_t *in, uint32_t *n)
 {
     if (!(*in & 0x80)) {
-        *n = *in++;
+        *n = *in;
         return 1;
     } else {
         *n = *in++ & 0x7f;
@@ -776,7 +776,7 @@ int uleb128_decode_small(const uint8_t *in, uint32_t *n)
         if (*in & 0x80) {
             return -1;
         }
-        *n |= *in++ << 7;
+        *n |= *in << 7;
         return 2;
     }
 }
-- 
2.21.0

