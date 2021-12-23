Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4004B47E74B
	for <lists+kvm@lfdr.de>; Thu, 23 Dec 2021 18:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244683AbhLWR5D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Dec 2021 12:57:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:23976 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233620AbhLWR5C (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Dec 2021 12:57:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640282221;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=tx1DaNTFUj+FTpRIoIC+27W+vuXIFSDacyLezNQVIis=;
        b=h1gbwSOHMxjeeJ1scBxl5gErJmEbtfD9TU9QZKEAYhg9mIu4AmGPI3XFzVRmtfGUj9Wb3E
        UBqZMIi8WdLjEGHi3ij9NGrwJH9SMSgW203HIZRBFz5wavtBkyIjh+CGg2bdpCbF664ft5
        9dRdm2UoQfe8C/rrgmwzUQShh09TYVk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-LMhfcmh6P3OWZFyxviO3tA-1; Thu, 23 Dec 2021 12:57:00 -0500
X-MC-Unique: LMhfcmh6P3OWZFyxviO3tA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA59A6973A
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 17:56:58 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9953A78C2B
        for <kvm@vger.kernel.org>; Thu, 23 Dec 2021 17:56:58 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] vmx: separate VPID tests
Date:   Thu, 23 Dec 2021 12:56:58 -0500
Message-Id: <20211223175658.708793-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The VPID tests take quite a long time (about 12 minutes overall), so
separate them from vmx_pf_exception_test and do not run vmx_pf_invvpid_test
twice.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/unittests.cfg | 25 +++++++++++++++++++++++--
 1 file changed, 23 insertions(+), 2 deletions(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index f0727f1..5367013 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -293,7 +293,7 @@ arch = i386
 
 [vmx]
 file = vmx.flat
-extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vmx_pf_vpid_test"
+extra_params = -cpu max,+vmx -append "-exit_monitor_from_l2_test -ept_access* -vmx_smp* -vmx_vmcs_shadow_test -atomic_switch_overflow_msrs_test -vmx_init_signal_test -vmx_apic_passthrough_tpr_threshold_test -apic_reg_virt_test -virt_x2apic_mode_test -vmx_pf_exception_test -vmx_pf_no_vpid_test -vmx_pf_invvpid_test -vmx_pf_vpid_test"
 arch = x86_64
 groups = vmx
 
@@ -362,10 +362,31 @@ groups = vmx
 
 [vmx_pf_exception_test]
 file = vmx.flat
-extra_params = -cpu max,+vmx -append "vmx_pf_exception_test vmx_pf_no_vpid_test vmx_pf_vpid_test vmx_pf_invvpid_test"
+extra_params = -cpu max,+vmx -append "vmx_pf_exception_test"
 arch = x86_64
 groups = vmx nested_exception
 
+[vmx_pf_vpid_test]
+file = vmx.flat
+extra_params = -cpu max,+vmx -append "vmx_pf_vpid_test"
+arch = x86_64
+groups = vmx nested_exception
+timeout = 240
+
+[vmx_pf_invvpid_test]
+file = vmx.flat
+extra_params = -cpu max,+vmx -append "vmx_pf_invvpid_test"
+arch = x86_64
+groups = vmx nested_exception
+timeout = 240
+
+[vmx_pf_no_vpid_test]
+file = vmx.flat
+extra_params = -cpu max,+vmx -append "vmx_pf_no_vpid_test"
+arch = x86_64
+groups = vmx nested_exception
+timeout = 240
+
 [vmx_pf_exception_test_reduced_maxphyaddr]
 file = vmx.flat
 extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off,+vmx -append "vmx_pf_exception_test vmx_pf_no_vpid_test vmx_pf_vpid_test vmx_pf_invvpid_test"
-- 
2.31.1

