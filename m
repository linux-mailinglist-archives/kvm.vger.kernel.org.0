Return-Path: <kvm+bounces-22619-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25BC5940AE9
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 10:11:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 46AB01C22E35
	for <lists+kvm@lfdr.de>; Tue, 30 Jul 2024 08:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9472E194094;
	Tue, 30 Jul 2024 08:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JWPawbBc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AE3190467
	for <kvm@vger.kernel.org>; Tue, 30 Jul 2024 08:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722327054; cv=none; b=tb5Ca8uL6ez2utjIop3DDq08/35pwaBLX0O2EPyIzvKItTtHEpDPvMX1bd60RrL0dPI334JUULnWxW3cdlrsdpHfMyUnBiu6tK9jhc9sxCJXCTVmXgRFbOYsREQ0/i1p2frgo+tlhFAZrbRVAj1RKGYrlHnnr7MGG46eYQCac6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722327054; c=relaxed/simple;
	bh=9OWsdJVtryKCVBjvyRWy0hCrd9SfrGTXHNwPePzetJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-type; b=qsvYAScK3gNFD9dsMQH7oNuy8Nd/3YK8xHnOzP6T15Y79u4UMLtaRklN0asUurM8Eti+epFTDE41BcPW8/x8qxJGmIf4NRGn50nPOYLBk62bPJe4P5Cy5ARaRhqSJFrzDyZe1rkn5zESoD6KyioyD//suKBmr0Fu4cL+efrQO4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JWPawbBc; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1722327051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GEwsuofZJeT4kfZWCKBhwsE5dAZCLtZDseQ9yWUtp3Y=;
	b=JWPawbBcVZJUqxgTKpahHkRHz9PBiEHybGB+f2w6BnXqiEp27m+3LmSCpVQUL2HeJ3uVx8
	S7RoFkr3U1m2Y5TCGJq59ss+eAWhx8oiUU6nta3HJh7QCG79wCrOSBq7ZALr9YEjBh5B+1
	p/DdNEX/2nv+MbQZ13TMsQVAOzl+F38=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-91-Fg3UXDOzMNSw8UvqBuk3yw-1; Tue,
 30 Jul 2024 04:10:46 -0400
X-MC-Unique: Fg3UXDOzMNSw8UvqBuk3yw-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BDFB01955D59;
	Tue, 30 Jul 2024 08:10:39 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.65])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E686B3000193;
	Tue, 30 Jul 2024 08:10:34 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id CCF8221F4B8C; Tue, 30 Jul 2024 10:10:32 +0200 (CEST)
From: Markus Armbruster <armbru@redhat.com>
To: qemu-devel@nongnu.org
Cc: alex.williamson@redhat.com,
	andrew@codeconstruct.com.au,
	andrew@daynix.com,
	arei.gonglei@huawei.com,
	berrange@redhat.com,
	berto@igalia.com,
	borntraeger@linux.ibm.com,
	clg@kaod.org,
	david@redhat.com,
	den@openvz.org,
	eblake@redhat.com,
	eduardo@habkost.net,
	farman@linux.ibm.com,
	farosas@suse.de,
	hreitz@redhat.com,
	idryomov@gmail.com,
	iii@linux.ibm.com,
	jamin_lin@aspeedtech.com,
	jasowang@redhat.com,
	joel@jms.id.au,
	jsnow@redhat.com,
	kwolf@redhat.com,
	leetroy@gmail.com,
	marcandre.lureau@redhat.com,
	marcel.apfelbaum@gmail.com,
	michael.roth@amd.com,
	mst@redhat.com,
	mtosatti@redhat.com,
	nsg@linux.ibm.com,
	pasic@linux.ibm.com,
	pbonzini@redhat.com,
	peter.maydell@linaro.org,
	peterx@redhat.com,
	philmd@linaro.org,
	pizhenwei@bytedance.com,
	pl@dlhnet.de,
	richard.henderson@linaro.org,
	stefanha@redhat.com,
	steven_lee@aspeedtech.com,
	thuth@redhat.com,
	vsementsov@yandex-team.ru,
	wangyanan55@huawei.com,
	yuri.benditovich@daynix.com,
	zhao1.liu@intel.com,
	qemu-block@nongnu.org,
	qemu-arm@nongnu.org,
	qemu-s390x@nongnu.org,
	kvm@vger.kernel.org
Subject: [PATCH 02/18] tests/qapi-schema: Drop temporary 'prefix'
Date: Tue, 30 Jul 2024 10:10:16 +0200
Message-ID: <20240730081032.1246748-3-armbru@redhat.com>
In-Reply-To: <20240730081032.1246748-1-armbru@redhat.com>
References: <20240730081032.1246748-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Recent commit "qapi: Smarter camel_to_upper() to reduce need for
'prefix'" added a temporary 'prefix' to delay changing the generated
code.

Revert it.  This changes TestUnionEnumA's generated enumeration
constant prefix from TEST_UNION_ENUMA to TEST_UNION_ENUM_A.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
---
 tests/unit/test-qobject-input-visitor.c  | 4 ++--
 tests/unit/test-qobject-output-visitor.c | 4 ++--
 tests/qapi-schema/qapi-schema-test.json  | 1 -
 tests/qapi-schema/qapi-schema-test.out   | 1 -
 4 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tests/unit/test-qobject-input-visitor.c b/tests/unit/test-qobject-input-visitor.c
index 024e26c49e..5479e68237 100644
--- a/tests/unit/test-qobject-input-visitor.c
+++ b/tests/unit/test-qobject-input-visitor.c
@@ -720,7 +720,7 @@ static void test_visitor_in_union_in_union(TestInputVisitorData *data,
 
     visit_type_TestUnionInUnion(v, NULL, &tmp, &error_abort);
     g_assert_cmpint(tmp->type, ==, TEST_UNION_ENUM_VALUE_A);
-    g_assert_cmpint(tmp->u.value_a.type_a, ==, TEST_UNION_ENUMA_VALUE_A1);
+    g_assert_cmpint(tmp->u.value_a.type_a, ==, TEST_UNION_ENUM_A_VALUE_A1);
     g_assert_cmpint(tmp->u.value_a.u.value_a1.integer, ==, 2);
     g_assert_cmpint(strcmp(tmp->u.value_a.u.value_a1.name, "fish"), ==, 0);
 
@@ -734,7 +734,7 @@ static void test_visitor_in_union_in_union(TestInputVisitorData *data,
 
     visit_type_TestUnionInUnion(v, NULL, &tmp, &error_abort);
     g_assert_cmpint(tmp->type, ==, TEST_UNION_ENUM_VALUE_A);
-    g_assert_cmpint(tmp->u.value_a.type_a, ==, TEST_UNION_ENUMA_VALUE_A2);
+    g_assert_cmpint(tmp->u.value_a.type_a, ==, TEST_UNION_ENUM_A_VALUE_A2);
     g_assert_cmpint(tmp->u.value_a.u.value_a2.integer, ==, 1729);
     g_assert_cmpint(tmp->u.value_a.u.value_a2.size, ==, 87539319);
 
diff --git a/tests/unit/test-qobject-output-visitor.c b/tests/unit/test-qobject-output-visitor.c
index 1535b3ad17..3455f3b107 100644
--- a/tests/unit/test-qobject-output-visitor.c
+++ b/tests/unit/test-qobject-output-visitor.c
@@ -359,7 +359,7 @@ static void test_visitor_out_union_in_union(TestOutputVisitorData *data,
 
     TestUnionInUnion *tmp = g_new0(TestUnionInUnion, 1);
     tmp->type = TEST_UNION_ENUM_VALUE_A;
-    tmp->u.value_a.type_a = TEST_UNION_ENUMA_VALUE_A1;
+    tmp->u.value_a.type_a = TEST_UNION_ENUM_A_VALUE_A1;
     tmp->u.value_a.u.value_a1.integer = 42;
     tmp->u.value_a.u.value_a1.name = g_strdup("fish");
 
@@ -377,7 +377,7 @@ static void test_visitor_out_union_in_union(TestOutputVisitorData *data,
     visitor_reset(data);
     tmp = g_new0(TestUnionInUnion, 1);
     tmp->type = TEST_UNION_ENUM_VALUE_A;
-    tmp->u.value_a.type_a = TEST_UNION_ENUMA_VALUE_A2;
+    tmp->u.value_a.type_a = TEST_UNION_ENUM_A_VALUE_A2;
     tmp->u.value_a.u.value_a2.integer = 1729;
     tmp->u.value_a.u.value_a2.size = 87539319;
 
diff --git a/tests/qapi-schema/qapi-schema-test.json b/tests/qapi-schema/qapi-schema-test.json
index 0f5f54e621..8ca977c49d 100644
--- a/tests/qapi-schema/qapi-schema-test.json
+++ b/tests/qapi-schema/qapi-schema-test.json
@@ -119,7 +119,6 @@
   'data': [ 'value-a', 'value-b' ] }
 
 { 'enum': 'TestUnionEnumA',
-  'prefix': 'TEST_UNION_ENUMA', # TODO drop
   'data': [ 'value-a1', 'value-a2' ] }
 
 { 'struct': 'TestUnionTypeA1',
diff --git a/tests/qapi-schema/qapi-schema-test.out b/tests/qapi-schema/qapi-schema-test.out
index add7346f49..4617eb4e98 100644
--- a/tests/qapi-schema/qapi-schema-test.out
+++ b/tests/qapi-schema/qapi-schema-test.out
@@ -108,7 +108,6 @@ enum TestUnionEnum
     member value-a
     member value-b
 enum TestUnionEnumA
-    prefix TEST_UNION_ENUMA
     member value-a1
     member value-a2
 object TestUnionTypeA1
-- 
2.45.0


