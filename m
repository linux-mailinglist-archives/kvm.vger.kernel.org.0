Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F18627070C
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 22:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726406AbgIRU2K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 16:28:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25797 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgIRU2J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 16:28:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600460888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=a3mAXCDiBM7Mu4NasAcidPwOPQiozJhoXxw5OZiT0HY=;
        b=HlOpRgZmWYdsVWWNaj5uXlcg7tfzS/UgQ5L3z2iUZPLPs3/tC57wU+rUWQ0tfRUWQ1xDEK
        BJHl5sru1AVRR0ZIhjosjzYyTDa1FyMAuKICT3jvWpxL/ZOFqyiJ5YmBk6gByFpoWBpHXp
        TcwJLUr9zG+xU8CAymS7kDtbPgYc52E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-140-Wwz9emxlOK-IGjRrlGiM2g-1; Fri, 18 Sep 2020 16:28:06 -0400
X-MC-Unique: Wwz9emxlOK-IGjRrlGiM2g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 25B6B800C78;
        Fri, 18 Sep 2020 20:28:05 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E08D75C26C;
        Fri, 18 Sep 2020 20:28:01 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Babu Moger <babu.moger@amd.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Subject: [PULL 3/4] i386: Simplify CPUID_8000_001d for AMD
Date:   Fri, 18 Sep 2020 16:27:49 -0400
Message-Id: <20200918202750.10358-4-ehabkost@redhat.com>
In-Reply-To: <20200918202750.10358-1-ehabkost@redhat.com>
References: <20200918202750.10358-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Babu Moger <babu.moger@amd.com>

Remove all the hardcoded values and replace with generalized
fields.

Signed-off-by: Babu Moger <babu.moger@amd.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <159897584649.30750.3939159632943292252.stgit@naples-babu.amd.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 target/i386/cpu.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index 37725bd354..52694a4198 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -395,11 +395,12 @@ static int cores_in_core_complex(int nr_cores)
 }
 
 /* Encode cache info for CPUID[8000001D] */
-static void encode_cache_cpuid8000001d(CPUCacheInfo *cache, CPUState *cs,
-                                uint32_t *eax, uint32_t *ebx,
-                                uint32_t *ecx, uint32_t *edx)
+static void encode_cache_cpuid8000001d(CPUCacheInfo *cache,
+                                       X86CPUTopoInfo *topo_info,
+                                       uint32_t *eax, uint32_t *ebx,
+                                       uint32_t *ecx, uint32_t *edx)
 {
-    uint32_t l3_cores;
+    uint32_t l3_threads;
     assert(cache->size == cache->line_size * cache->associativity *
                           cache->partitions * cache->sets);
 
@@ -408,10 +409,10 @@ static void encode_cache_cpuid8000001d(CPUCacheInfo *cache, CPUState *cs,
 
     /* L3 is shared among multiple cores */
     if (cache->level == 3) {
-        l3_cores = cores_in_core_complex(cs->nr_cores);
-        *eax |= ((l3_cores * cs->nr_threads) - 1) << 14;
+        l3_threads = topo_info->cores_per_die * topo_info->threads_per_core;
+        *eax |= (l3_threads - 1) << 14;
     } else {
-        *eax |= ((cs->nr_threads - 1) << 14);
+        *eax |= ((topo_info->threads_per_core - 1) << 14);
     }
 
     assert(cache->line_size > 0);
@@ -5995,20 +5996,20 @@ void cpu_x86_cpuid(CPUX86State *env, uint32_t index, uint32_t count,
         }
         switch (count) {
         case 0: /* L1 dcache info */
-            encode_cache_cpuid8000001d(env->cache_info_amd.l1d_cache, cs,
-                                       eax, ebx, ecx, edx);
+            encode_cache_cpuid8000001d(env->cache_info_amd.l1d_cache,
+                                       &topo_info, eax, ebx, ecx, edx);
             break;
         case 1: /* L1 icache info */
-            encode_cache_cpuid8000001d(env->cache_info_amd.l1i_cache, cs,
-                                       eax, ebx, ecx, edx);
+            encode_cache_cpuid8000001d(env->cache_info_amd.l1i_cache,
+                                       &topo_info, eax, ebx, ecx, edx);
             break;
         case 2: /* L2 cache info */
-            encode_cache_cpuid8000001d(env->cache_info_amd.l2_cache, cs,
-                                       eax, ebx, ecx, edx);
+            encode_cache_cpuid8000001d(env->cache_info_amd.l2_cache,
+                                       &topo_info, eax, ebx, ecx, edx);
             break;
         case 3: /* L3 cache info */
-            encode_cache_cpuid8000001d(env->cache_info_amd.l3_cache, cs,
-                                       eax, ebx, ecx, edx);
+            encode_cache_cpuid8000001d(env->cache_info_amd.l3_cache,
+                                       &topo_info, eax, ebx, ecx, edx);
             break;
         default: /* end of info */
             *eax = *ebx = *ecx = *edx = 0;
-- 
2.26.2

