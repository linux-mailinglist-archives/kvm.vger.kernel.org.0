Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E00C209D5A
	for <lists+kvm@lfdr.de>; Thu, 25 Jun 2020 13:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404206AbgFYLPb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Jun 2020 07:15:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:33819 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2404205AbgFYLPb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 25 Jun 2020 07:15:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593083730;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=Vdl4f8xTmP7RgRJTyPC0kZXaQsu6szqBFCZdWfmzvis=;
        b=AHf2BFLqREwo+zzLAGPG4MLZlJGWtCUdmeSW8BTEwHaSOWjpZEw7WtjK2MpYPcLhPJYMJ5
        bqcXwt36+kIv/+sowmkhsQEEaCXKaNMeVgL3/YvYGMwJ3zhdzfIXcuwoq0qU84CDzSWvlv
        Ohivr69FiYItE+Mx9X+veR1JdgtYykc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-LvUANXN8PqGkKfS86QrfYQ-1; Thu, 25 Jun 2020 07:15:28 -0400
X-MC-Unique: LvUANXN8PqGkKfS86QrfYQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 870C8107ACF3;
        Thu, 25 Jun 2020 11:15:27 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 22FCD61981;
        Thu, 25 Jun 2020 11:15:27 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     kvm@vger.kernel.org
Cc:     namit@vmware.com
Subject: [PATCH kvm-unit-tests] x86: fix stack pointer after call
Date:   Thu, 25 Jun 2020 07:15:26 -0400
Message-Id: <20200625111526.1620-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since setup_multiboot has a C calling convention, the stack pointer must
be adjusted after the call.  Without this change, the bottom of the
percpu area would be 4 bytes below the bottom of the stack.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 x86/cstart.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/x86/cstart.S b/x86/cstart.S
index deb08b7..409cb00 100644
--- a/x86/cstart.S
+++ b/x86/cstart.S
@@ -116,6 +116,7 @@ start:
 
         push %ebx
         call setup_multiboot
+        addl $4, %esp
         call setup_libcflat
         mov mb_cmdline(%ebx), %eax
         mov %eax, __args
-- 
2.26.2

