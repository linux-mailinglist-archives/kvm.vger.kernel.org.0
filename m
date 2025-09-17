Return-Path: <kvm+bounces-57858-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E39DFB7F1A4
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:16:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 95668323A1A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:06:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B812330D23;
	Wed, 17 Sep 2025 13:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="ASEKTZYu"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2252FBE17
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758114006; cv=none; b=duhyZFgarktmg4BECezYx2aXdFVQeby9ZMuII7fziVS+rAImsgs9iabyblNRmqxDK8fh9Qo5+MWRwpKHQDvAqJXFrs6R/PyNKIG6//VL4N7Kiy8PC0u4w1+zZbJxjNTucG/BA9RdrP2SRMHgTjPbXPVDkJFUKC8z/DZ+1/aBsWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758114006; c=relaxed/simple;
	bh=7dwxNqdEbiLLKUF/pYqacXkJ876VZQmS7e+ZrAucJ9E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=KOvQNyaxDiOQXPB2nbenI+yHPtBifhz2rm/tfdMzzTEzU3lF6o/pXd+2ctGdNgCzWmJH3BShaKP68i2JAOIrptWE3YcvbFP3varCpoCe5+BE5++t8+Z/OJpsuUASgdrQ2/L/inHfI57dn+qxOfUV7z0PQsOjTHMP8q8Eq4eytIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=ASEKTZYu reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58HCuN7F008967
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Wed, 17 Sep 2025 21:56:59 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=H8Viwr1cqgug0xlJipwqK4Ddh9h3sxTvY8hZvwlaj9U=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Date:Subject:Message-Id:To;
        s=rs20250326; t=1758113820; v=1;
        b=ASEKTZYuEtYCiyC+S1q0meRd7z5XkixpT3NBMntqIHUfz+u0zb7CO1TAibDaO8Si
         M1Kt6K1CX2uTX1JQsNDvxB6seFFV1Ef95h4G1o1GsG4bTdYcmlXJosgCognl/9t8
         s08EXpyc2oHGY/G6fADfhaJ6amvTtEcHhDqt3c2Jw6k4U3FsgSfjLHgXW78z97rK
         qF5Ki5NNU2Y/Lt5OxRcNTk7e80JEzE/FpMwoMoLgxMoFc9rsOr4PnGetetyhxzul
         cQqyKz1qLGmXvn/1B84xIEZg1wNyHrmBxVkojB+TbAsyx9c6n5QW1ViVc7PHdXkb
         JpUg87NjSDLtKgd/dqk9FQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Wed, 17 Sep 2025 21:56:47 +0900
Subject: [PATCH 35/35] memory: Drop non-QOM AddressSpace support
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250917-qom-v1-35-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
To: qemu-devel@nongnu.org
Cc: Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Steven Lee <steven_lee@aspeedtech.com>, Troy Lee <leetroy@gmail.com>,
        Jamin Lin <jamin_lin@aspeedtech.com>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Joel Stanley <joel@jms.id.au>, Eric Auger <eric.auger@redhat.com>,
        Helge Deller <deller@gmx.de>,
        =?utf-8?q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        =?utf-8?q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Aleksandar Rikalo <arikalo@gmail.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Alistair Francis <alistair@alistair23.me>,
        Ninad Palsule <ninad@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>, Yi Liu <yi.l.liu@intel.com>,
        =?utf-8?q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Aditya Gupta <adityag@linux.ibm.com>,
        Gautam Menghani <gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>,
        Bibo Mao <maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Fan Ni <fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>,
        Andrey Smirnov <andrew.smirnov@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Bernhard Beschow <shentey@gmail.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>,
        Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        Bin Meng <bmeng.cn@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Artyom Tarasenko <atar4qemu@gmail.com>, Peter Xu <peterx@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        qemu-ppc@nongnu.org, qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
        qemu-block@nongnu.org, kvm@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>,
        =?utf-8?q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Alistair Francis <alistair.francis@wdc.com>,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-179e8

Now all AddressSpace instances are converted to QOM so drop
non-QOM AddressSpace support.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 include/system/memory.h | 13 -------------
 system/memory.c         | 26 +++++---------------------
 2 files changed, 5 insertions(+), 34 deletions(-)

diff --git a/include/system/memory.h b/include/system/memory.h
index 5108e0fba339..9b249b4b3ae2 100644
--- a/include/system/memory.h
+++ b/include/system/memory.h
@@ -1163,8 +1163,6 @@ struct AddressSpace {
     /* private: */
     Object parent_obj;
     struct rcu_head rcu;
-    bool qom;
-    char *name;
     MemoryRegion *root;
 
     /* Accessed via RCU.  */
@@ -2719,17 +2717,6 @@ MemTxResult memory_region_dispatch_write(MemoryRegion *mr,
 void address_space_init(AddressSpace *as, Object *parent, MemoryRegion *root,
                         const char *name);
 
-/**
- * address_space_destroy: destroy an address space
- *
- * Releases all resources associated with an address space.  After an address space
- * is destroyed, its root memory region (given by address_space_init()) may be destroyed
- * as well.
- *
- * @as: address space to be destroyed
- */
-void address_space_destroy(AddressSpace *as);
-
 /**
  * address_space_get_path: get the path to an address space
  *
diff --git a/system/memory.c b/system/memory.c
index 7a77ba0f1797..363f50e7a4f0 100644
--- a/system/memory.c
+++ b/system/memory.c
@@ -3206,11 +3206,7 @@ void address_space_remove_listeners(AddressSpace *as)
 void address_space_init(AddressSpace *as, Object *parent, MemoryRegion *root,
                         const char *name)
 {
-    if (parent) {
-        object_initialize_child(parent, name, as, TYPE_ADDRESS_SPACE);
-    }
-
-    as->qom = parent;
+    object_initialize_child(parent, name, as, TYPE_ADDRESS_SPACE);
     memory_region_ref(root);
     as->root = root;
     as->current_map = NULL;
@@ -3222,12 +3218,11 @@ void address_space_init(AddressSpace *as, Object *parent, MemoryRegion *root,
     as->bounce_buffer_size = 0;
     qemu_mutex_init(&as->map_client_list_lock);
     QLIST_INIT(&as->map_client_list);
-    as->name = g_strdup(name ? name : "anonymous");
     address_space_update_topology(as);
     address_space_update_ioeventfds(as);
 }
 
-static void do_address_space_destroy(struct rcu_head *head)
+static void do_address_space_finalize(struct rcu_head *head)
 {
     AddressSpace *as = container_of(head, AddressSpace, rcu);
 
@@ -3238,18 +3233,13 @@ static void do_address_space_destroy(struct rcu_head *head)
     assert(QTAILQ_EMPTY(&as->listeners));
 
     flatview_unref(as->current_map);
-    g_free(as->name);
     g_free(as->ioeventfds);
     memory_region_unref(as->root);
 }
 
 static void address_space_finalize(Object *obj)
 {
-    address_space_destroy(ADDRESS_SPACE(obj));
-}
-
-void address_space_destroy(AddressSpace *as)
-{
+    AddressSpace *as = ADDRESS_SPACE(obj);
     MemoryRegion *root = as->root;
 
     /* Flush out anything from MemoryListeners listening in on this */
@@ -3263,18 +3253,12 @@ void address_space_destroy(AddressSpace *as)
      * values to expire before freeing the data.
      */
     as->root = root;
-    call_rcu1(&as->rcu, do_address_space_destroy);
+    call_rcu1(&as->rcu, do_address_space_finalize);
 }
 
 char *address_space_get_path(AddressSpace *as)
 {
-    char *path;
-
-    if (!as->qom) {
-        return as->name;
-    }
-
-    path = object_get_canonical_path(OBJECT(as));
+    char *path = object_get_canonical_path(OBJECT(as));
 
     return path ? path : g_strdup("orphan");
 }

-- 
2.51.0


