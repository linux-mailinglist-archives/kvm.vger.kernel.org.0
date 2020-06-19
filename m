Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8412012A3
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 17:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392943AbgFSPyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 11:54:08 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:22131 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392442AbgFSPyD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jun 2020 11:54:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592582042;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pVIj3XToIh5tz8Pv5AGHQXu5eJDH366pzw6sKsocPMQ=;
        b=a8QI5Ha9oluBnjmeXJ07FedUzwZH4LNJiKZKeDzCBKmVxisBL27Oxd9teEThfK4r6ro5CR
        di/p88uEmkPJFlDscG20mkRl0FHU1S8Hp2j9u/Qu6UU+ZG3a0JBU+a1MCi5cWNfg2i3SN2
        jsIrLNzA4cPT3bqgf8jgLLypuxIeFBk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-490-r3sINLJfNJWXNnUfvXQW3g-1; Fri, 19 Jun 2020 11:54:00 -0400
X-MC-Unique: r3sINLJfNJWXNnUfvXQW3g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BDB828730B3;
        Fri, 19 Jun 2020 15:53:57 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-112-254.ams2.redhat.com [10.36.112.254])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D8CF15BAD3;
        Fri, 19 Jun 2020 15:53:54 +0000 (UTC)
From:   Mohammed Gamal <mgamal@redhat.com>
To:     qemu-devel@nongnu.org, pbonzini@redhat.com
Cc:     ehabkost@redhat.com, mtosatti@redhat.com, rth@twiddle.net,
        kvm@vger.kernel.org, Mohammed Gamal <mgamal@redhat.com>
Subject: [PATCH 2/2] x86/cpu: Handle GUEST_MAXPHYADDR < HOST_MAXPHYADDR for hosts that don't support it
Date:   Fri, 19 Jun 2020 17:53:44 +0200
Message-Id: <20200619155344.79579-3-mgamal@redhat.com>
In-Reply-To: <20200619155344.79579-1-mgamal@redhat.com>
References: <20200619155344.79579-1-mgamal@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If the CPU doesn't support GUEST_MAXPHYADDR < HOST_MAXPHYADDR we
let QEMU choose to use the host MAXPHYADDR and print a warning to the
user.

Signed-off-by: Mohammed Gamal <mgamal@redhat.com>
---
 target/i386/cpu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index b1b311baa2..91c57117ce 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -6589,6 +6589,17 @@ static void x86_cpu_realizefn(DeviceState *dev, Error **errp)
             uint32_t host_phys_bits = x86_host_phys_bits();
             static bool warned;
 
+	    /*
+	     * If host doesn't support setting physical bits on the guest,
+	     * report it and return
+	     */
+	    if (cpu->phys_bits < host_phys_bits &&
+		!kvm_has_smaller_maxphyaddr()) {
+		warn_report("Host doesn't support setting smaller phys-bits."
+			    " Using host phys-bits\n");
+		cpu->phys_bits = host_phys_bits;
+	    }
+
             /* Print a warning if the user set it to a value that's not the
              * host value.
              */
-- 
2.26.2

