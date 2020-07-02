Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF5C212027
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 11:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgGBJjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 05:39:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57609 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727791AbgGBJji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 05:39:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593682777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=OU1abHmcvqlPXE7j6qY5NTPbjnWuDoW6srqdHAGVMo0=;
        b=KuLrQtICw7WxwjLWuFc0r8nMZRtg6o+v9u4dGs6PUqVBECKXj+LNpErY6apyBQPJqNQWmj
        vTALcbE2O/7GFe8vRHaRQ68b0vXS4OZRm/Z1kME44NjuHFGpDdqkx8uNixoMecGEricWy4
        zCqNf2jzGM8Fho4ziAhGnvSrGiLmoqc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-JnfcbkGbNaqoEPaIYrmDpA-1; Thu, 02 Jul 2020 05:39:36 -0400
X-MC-Unique: JnfcbkGbNaqoEPaIYrmDpA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B2DA8BFC3;
        Thu,  2 Jul 2020 09:39:34 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6344F5C541;
        Thu,  2 Jul 2020 09:39:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH] kvm: use more precise cast and do not drop __user
Date:   Thu,  2 Jul 2020 05:39:33 -0400
Message-Id: <20200702093933.20845-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sparse complains on a call to get_compat_sigset, fix it.  The "if"
right above explains that sigmask_arg->sigset is basically a
compat_sigset_t.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 virt/kvm/kvm_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a852af5c3214..0a68c9d3d3ab 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -3350,7 +3350,8 @@ static long kvm_vcpu_compat_ioctl(struct file *filp,
 			if (kvm_sigmask.len != sizeof(compat_sigset_t))
 				goto out;
 			r = -EFAULT;
-			if (get_compat_sigset(&sigset, (void *)sigmask_arg->sigset))
+			if (get_compat_sigset(&sigset,
+					      (compat_sigset_t __user *)sigmask_arg->sigset))
 				goto out;
 			r = kvm_vcpu_ioctl_set_sigmask(vcpu, &sigset);
 		} else
-- 
2.26.2

