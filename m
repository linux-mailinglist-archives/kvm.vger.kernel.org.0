Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54D1B27944D
	for <lists+kvm@lfdr.de>; Sat, 26 Sep 2020 00:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgIYWoa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 18:44:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43947 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726636AbgIYWoa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 18:44:30 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601073869;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mOIyCgY/IoGKS+vL+syjQpfoJXSV5VORDkFB2B1OxTk=;
        b=H0VJOJkjbIEb3hrAqKOo3c3meB1nyKm0FV8ZTg8BsK73FvBwaTFybUpReHJydBVIRqwzPK
        WDp28jy8PlXSVzNDYQaiViUE1fBayIV7HdhAF1XzWMhOWEwUzwIoQodMRo5ymJitXn7i+f
        pryV5d3voADDkdcPHYyBklm3RSPCbWs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-cRG3j9lePA2oIC6tBNZvBQ-1; Fri, 25 Sep 2020 18:44:27 -0400
X-MC-Unique: cRG3j9lePA2oIC6tBNZvBQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 64E6A1DDFB
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 22:44:26 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 281707367E
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 22:44:26 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Subject: [PATCH kvm-unit-tests] x86: cover emulation of reduced MAXPHYADDR
Date:   Fri, 25 Sep 2020 18:44:25 -0400
Message-Id: <20200925224425.2178862-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add a variant of x86/access.flat that covers the emulation
of guest-MAXPHYADDR < host-MAXPHYADDR.  Use an old-ish
CPU model because to speed up the test, as Ivy Bridge did
not have SMEP and PKU.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/unittests.cfg | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/x86/unittests.cfg b/x86/unittests.cfg
index 4fa42fa..bab1cce 100644
--- a/x86/unittests.cfg
+++ b/x86/unittests.cfg
@@ -116,9 +116,16 @@ extra_params = -cpu qemu64,+x2apic,+tsc-deadline -append tscdeadline_immed
 [access]
 file = access.flat
 arch = x86_64
-extra_params = -cpu host,host-phys-bits
+extra_params = -cpu max
 timeout = 180
 
+[access-reduced-maxphyaddr]
+file = access.flat
+arch = x86_64
+extra_params = -cpu IvyBridge,phys-bits=36,host-phys-bits=off
+timeout = 180
+check = /sys/module/kvm_intel/parameters/allow_smaller_maxphyaddr=Y
+
 [smap]
 file = smap.flat
 extra_params = -cpu host
-- 
2.26.2

