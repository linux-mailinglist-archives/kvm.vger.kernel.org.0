Return-Path: <kvm+bounces-25851-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8AD1D96BA42
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:23:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4192D285602
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:23:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E2F1D54DC;
	Wed,  4 Sep 2024 11:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="az4tY5ay"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639911D0966
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725448735; cv=none; b=Z5C7Fw81mYNgs/Y2bgpRd93PlVx2vXxgkaKctyWTlbASQh7A9dV0dHBmfW74TAUATJSlH6KUtOB/Vab08aisaadumptopHWsZDRVXvkYwkr8Kg777CLBWBGHg3jEmFMa82NV/h6/CMKRt8FS0FJYhA360MuMC7QSfSrsGqZI7EY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725448735; c=relaxed/simple;
	bh=5DADHnOdVY8Q6Qbi2QPije39VC68w82G4KmJNbc5aRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdDIoszeMRpOigfo89YiRrwCyrryLUnLCHg1sJXFqB959va65XFXTbQ3XGqCKDMViSRW6sFObFYEnrSbbI69To6ISEH1YeCub3YWleP+/hptOMi3tM+PQzuA7IVBGUO8dCyeujTPsGiiBPb5XvFc1TMqwmPNcD1FOY2f01ZKO6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=az4tY5ay; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725448732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XgpYkJsaI9m1H5zaH4zbGBX7PFklNC5stqAFMp25Csk=;
	b=az4tY5ayDrYTcgd21UGOH4pAHSjRNd400MXKgSdFhOWnzoI7ajyme+j5Tf0o/4w0eh87QR
	z8blj4i/h8ylVy4eMestUnQZBXMioNTwEJzoO0GxXxh4wSTPsLULvqkJNGx/+UQncoHrHH
	HE4ZeouFCmkFALM1qQAWPytAec9HFNM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-526-63Bd3otfNrOJFq-UnnzLfw-1; Wed,
 04 Sep 2024 07:18:49 -0400
X-MC-Unique: 63Bd3otfNrOJFq-UnnzLfw-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42F9D1955D57;
	Wed,  4 Sep 2024 11:18:45 +0000 (UTC)
Received: from blackfin.pond.sub.org (unknown [10.39.192.112])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 27DC419560AE;
	Wed,  4 Sep 2024 11:18:44 +0000 (UTC)
Received: by blackfin.pond.sub.org (Postfix, from userid 1000)
	id B4BE621E681F; Wed,  4 Sep 2024 13:18:36 +0200 (CEST)
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
	kvm@vger.kernel.org,
	avihaih@nvidia.com
Subject: [PATCH v2 09/19] qapi/machine: Rename CpuS390* to S390Cpu*, and drop 'prefix'
Date: Wed,  4 Sep 2024 13:18:26 +0200
Message-ID: <20240904111836.3273842-10-armbru@redhat.com>
In-Reply-To: <20240904111836.3273842-1-armbru@redhat.com>
References: <20240904111836.3273842-1-armbru@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

QAPI's 'prefix' feature can make the connection between enumeration
type and its constants less than obvious.  It's best used with
restraint.

CpuS390Entitlement has a 'prefix' to change the generated enumeration
constants' prefix from CPU_S390_ENTITLEMENT to S390_CPU_ENTITLEMENT.
Rename the type to S390CpuEntitlement, so that 'prefix' is not needed.

Likewise change CpuS390Polarization to S390CpuPolarization, and
CpuS390State to S390CpuState.

Signed-off-by: Markus Armbruster <armbru@redhat.com>
Reviewed-by: Daniel P. Berrangé <berrange@redhat.com>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Acked-by: Thomas Huth <thuth@redhat.com>
---
 qapi/machine-common.json            |  5 ++---
 qapi/machine-target.json            | 11 +++++------
 qapi/machine.json                   |  9 ++++-----
 qapi/pragma.json                    |  6 +++---
 include/hw/qdev-properties-system.h |  2 +-
 include/hw/s390x/cpu-topology.h     |  2 +-
 target/s390x/cpu.h                  |  2 +-
 hw/core/qdev-properties-system.c    |  6 +++---
 hw/s390x/cpu-topology.c             |  6 +++---
 9 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/qapi/machine-common.json b/qapi/machine-common.json
index fa6bd71d12..b64e4895cf 100644
--- a/qapi/machine-common.json
+++ b/qapi/machine-common.json
@@ -9,13 +9,12 @@
 ##
 
 ##
-# @CpuS390Entitlement:
+# @S390CpuEntitlement:
 #
 # An enumeration of CPU entitlements that can be assumed by a virtual
 # S390 CPU
 #
 # Since: 8.2
 ##
-{ 'enum': 'CpuS390Entitlement',
-  'prefix': 'S390_CPU_ENTITLEMENT',
+{ 'enum': 'S390CpuEntitlement',
   'data': [ 'auto', 'low', 'medium', 'high' ] }
diff --git a/qapi/machine-target.json b/qapi/machine-target.json
index 1a394c08f5..541f93eeb7 100644
--- a/qapi/machine-target.json
+++ b/qapi/machine-target.json
@@ -405,15 +405,14 @@
                    'TARGET_RISCV' ] } }
 
 ##
-# @CpuS390Polarization:
+# @S390CpuPolarization:
 #
 # An enumeration of CPU polarization that can be assumed by a virtual
 # S390 CPU
 #
 # Since: 8.2
 ##
-{ 'enum': 'CpuS390Polarization',
-  'prefix': 'S390_CPU_POLARIZATION',
+{ 'enum': 'S390CpuPolarization',
   'data': [ 'horizontal', 'vertical' ],
   'if': 'TARGET_S390X'
 }
@@ -450,7 +449,7 @@
       '*socket-id': 'uint16',
       '*book-id': 'uint16',
       '*drawer-id': 'uint16',
-      '*entitlement': 'CpuS390Entitlement',
+      '*entitlement': 'S390CpuEntitlement',
       '*dedicated': 'bool'
   },
   'features': [ 'unstable' ],
@@ -488,7 +487,7 @@
 #          "timestamp": { "seconds": 1401385907, "microseconds": 422329 } }
 ##
 { 'event': 'CPU_POLARIZATION_CHANGE',
-  'data': { 'polarization': 'CpuS390Polarization' },
+  'data': { 'polarization': 'S390CpuPolarization' },
   'features': [ 'unstable' ],
   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
 }
@@ -503,7 +502,7 @@
 # Since: 8.2
 ##
 { 'struct': 'CpuPolarizationInfo',
-  'data': { 'polarization': 'CpuS390Polarization' },
+  'data': { 'polarization': 'S390CpuPolarization' },
   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
 }
 
diff --git a/qapi/machine.json b/qapi/machine.json
index d4317435e7..63a5eb0070 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -41,15 +41,14 @@
              'x86_64', 'xtensa', 'xtensaeb' ] }
 
 ##
-# @CpuS390State:
+# @S390CpuState:
 #
 # An enumeration of cpu states that can be assumed by a virtual S390
 # CPU
 #
 # Since: 2.12
 ##
-{ 'enum': 'CpuS390State',
-  'prefix': 'S390_CPU_STATE',
+{ 'enum': 'S390CpuState',
   'data': [ 'uninitialized', 'stopped', 'check-stop', 'operating', 'load' ] }
 
 ##
@@ -66,9 +65,9 @@
 # Since: 2.12
 ##
 { 'struct': 'CpuInfoS390',
-  'data': { 'cpu-state': 'CpuS390State',
+  'data': { 'cpu-state': 'S390CpuState',
             '*dedicated': 'bool',
-            '*entitlement': 'CpuS390Entitlement' } }
+            '*entitlement': 'S390CpuEntitlement' } }
 
 ##
 # @CpuInfoFast:
diff --git a/qapi/pragma.json b/qapi/pragma.json
index 59fbe74b8c..fad3a31628 100644
--- a/qapi/pragma.json
+++ b/qapi/pragma.json
@@ -47,9 +47,6 @@
         'BlockdevSnapshotWrapper',
         'BlockdevVmdkAdapterType',
         'ChardevBackendKind',
-        'CpuS390Entitlement',
-        'CpuS390Polarization',
-        'CpuS390State',
         'CxlCorErrorType',
         'DisplayProtocol',
         'DriveBackupWrapper',
@@ -74,6 +71,9 @@
         'QKeyCode',
         'RbdAuthMode',
         'RbdImageEncryptionFormat',
+        'S390CpuEntitlement',
+        'S390CpuPolarization',
+        'S390CpuState',
         'String',
         'StringWrapper',
         'SysEmuTarget',
diff --git a/include/hw/qdev-properties-system.h b/include/hw/qdev-properties-system.h
index 438f65389f..cdcc63056e 100644
--- a/include/hw/qdev-properties-system.h
+++ b/include/hw/qdev-properties-system.h
@@ -88,7 +88,7 @@ extern const PropertyInfo qdev_prop_iothread_vq_mapping_list;
 
 #define DEFINE_PROP_CPUS390ENTITLEMENT(_n, _s, _f, _d) \
     DEFINE_PROP_SIGNED(_n, _s, _f, _d, qdev_prop_cpus390entitlement, \
-                       CpuS390Entitlement)
+                       S390CpuEntitlement)
 
 #define DEFINE_PROP_IOTHREAD_VQ_MAPPING_LIST(_name, _state, _field) \
     DEFINE_PROP(_name, _state, _field, qdev_prop_iothread_vq_mapping_list, \
diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
index c064f427e9..a11b1baa77 100644
--- a/include/hw/s390x/cpu-topology.h
+++ b/include/hw/s390x/cpu-topology.h
@@ -37,7 +37,7 @@ typedef struct S390TopologyEntry {
 
 typedef struct S390Topology {
     uint8_t *cores_per_socket;
-    CpuS390Polarization polarization;
+    S390CpuPolarization polarization;
 } S390Topology;
 
 typedef QTAILQ_HEAD(, S390TopologyEntry) S390TopologyList;
diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
index d6b75ad0e0..6cbd77dfdf 100644
--- a/target/s390x/cpu.h
+++ b/target/s390x/cpu.h
@@ -133,7 +133,7 @@ typedef struct CPUArchState {
     int32_t book_id;
     int32_t drawer_id;
     bool dedicated;
-    CpuS390Entitlement entitlement; /* Used only for vertical polarization */
+    S390CpuEntitlement entitlement; /* Used only for vertical polarization */
     uint64_t cpuid;
 #endif
 
diff --git a/hw/core/qdev-properties-system.c b/hw/core/qdev-properties-system.c
index f13350b4fb..f2db20417a 100644
--- a/hw/core/qdev-properties-system.c
+++ b/hw/core/qdev-properties-system.c
@@ -1188,12 +1188,12 @@ const PropertyInfo qdev_prop_uuid = {
 
 /* --- s390 cpu entitlement policy --- */
 
-QEMU_BUILD_BUG_ON(sizeof(CpuS390Entitlement) != sizeof(int));
+QEMU_BUILD_BUG_ON(sizeof(S390CpuEntitlement) != sizeof(int));
 
 const PropertyInfo qdev_prop_cpus390entitlement = {
-    .name  = "CpuS390Entitlement",
+    .name  = "S390CpuEntitlement",
     .description = "low/medium (default)/high",
-    .enum_table  = &CpuS390Entitlement_lookup,
+    .enum_table  = &S390CpuEntitlement_lookup,
     .get   = qdev_propinfo_get_enum,
     .set   = qdev_propinfo_set_enum,
     .set_default_value = qdev_propinfo_set_default_value_enum,
diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
index f16bdf65fa..7d4e1f5472 100644
--- a/hw/s390x/cpu-topology.c
+++ b/hw/s390x/cpu-topology.c
@@ -105,7 +105,7 @@ static void s390_topology_init(MachineState *ms)
  */
 void s390_handle_ptf(S390CPU *cpu, uint8_t r1, uintptr_t ra)
 {
-    CpuS390Polarization polarization;
+    S390CpuPolarization polarization;
     CPUS390XState *env = &cpu->env;
     uint64_t reg = env->regs[r1];
     int fc = reg & S390_TOPO_FC_MASK;
@@ -357,7 +357,7 @@ static void s390_change_topology(uint16_t core_id,
                                  bool has_book_id, uint16_t book_id,
                                  bool has_drawer_id, uint16_t drawer_id,
                                  bool has_entitlement,
-                                 CpuS390Entitlement entitlement,
+                                 S390CpuEntitlement entitlement,
                                  bool has_dedicated, bool dedicated,
                                  Error **errp)
 {
@@ -446,7 +446,7 @@ void qmp_set_cpu_topology(uint16_t core,
                           bool has_socket, uint16_t socket,
                           bool has_book, uint16_t book,
                           bool has_drawer, uint16_t drawer,
-                          bool has_entitlement, CpuS390Entitlement entitlement,
+                          bool has_entitlement, S390CpuEntitlement entitlement,
                           bool has_dedicated, bool dedicated,
                           Error **errp)
 {
-- 
2.46.0


