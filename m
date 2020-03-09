Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCAD17E405
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2020 16:52:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbgCIPwe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Mar 2020 11:52:34 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:43262 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727180AbgCIPwd (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 9 Mar 2020 11:52:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583769152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x4pW19833p+fXxfsFrvmy67Ky5HT38eac4OMiKrYje0=;
        b=GNGEwCDkqyMJTEsy4OasSV6g2ugCYJHbvCBxmesyXBRhruQIjuGx6Q0gOGchq5LXmYZ84u
        WIHfQJmRXNdzUaXifmd78w8eMyS4e3WSG32xdLufkzbjMAiVZyXOkobGXTwNX/d3m4sU5P
        d1fW0xeNQRGgApkxQmwTYdXGUcNIKuw=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-407-uEk_NJICNKS7Ws5vEPiizA-1; Mon, 09 Mar 2020 11:52:31 -0400
X-MC-Unique: uEk_NJICNKS7Ws5vEPiizA-1
Received: by mail-wr1-f70.google.com with SMTP id c6so5365069wrm.18
        for <kvm@vger.kernel.org>; Mon, 09 Mar 2020 08:52:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x4pW19833p+fXxfsFrvmy67Ky5HT38eac4OMiKrYje0=;
        b=rQ9+qEim33FXrf3SEiOKaU6ttX4m+hlZ1XoEDaXZ0BDNlf+CcqOPclcStEj8FQ/ANw
         65fuJdNmk/82avVJO9K5LryiJb7IVxLbYqhz0Wd7lajdLyvNr2s29M/t2d34kuAmhpQp
         paGf9Vr2FppP/zyxr4Qnw18seuLz5xN1UB3fwKW6ock60vnWFxsi4+E4VQqWHx2Brzok
         FwxtzZ+jSBBOxfxUUY/CJ4q0vFNzXryX17t4a7J+qdy3qpv/b72HWqCaDzjITLSTMGL1
         nWpKFFpiC/qkmpRzDELinJnd68d5C+u49y0Q8yokGqUH75UZTLRZ1+QveafCryEL2e7f
         jw5g==
X-Gm-Message-State: ANhLgQ23Cg6O61S2BQRdzA+w/UGUA/LqWj8OWvA+9BO2ZF5M1sq+5MG+
        XJPDBzUk4tr9+rtVmMXfGwG2AiwywbWXF4yvuqaSNbqnxv+qozXBy2NqR/xL7iFiZ9pwyfhUWyj
        6IzsutHye2V9R
X-Received: by 2002:adf:ed86:: with SMTP id c6mr18930570wro.53.1583769149844;
        Mon, 09 Mar 2020 08:52:29 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtNpfvkJjRTfTeKbLF72oykUGIlVbTuKMnR5vx+0KBXL7IxXEBsEWk1uSdTmYa4hf4LFzVGKg==
X-Received: by 2002:adf:ed86:: with SMTP id c6mr18930552wro.53.1583769149663;
        Mon, 09 Mar 2020 08:52:29 -0700 (PDT)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id q4sm17294521wro.56.2020.03.09.08.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2020 08:52:28 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Liran Alon <liran.alon@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH 4/6] KVM: selftests: define and use EVMCS_VERSION
Date:   Mon,  9 Mar 2020 16:52:14 +0100
Message-Id: <20200309155216.204752-5-vkuznets@redhat.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200309155216.204752-1-vkuznets@redhat.com>
References: <20200309155216.204752-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

KVM allows to use revision_id from MSR_IA32_VMX_BASIC as eVMCS revision_id
to workaround a bug in genuine Hyper-V (see the comment in
nested_vmx_handle_enlightened_vmptrld()), this shouldn't be used by
default. Switch to using KVM_EVMCS_VERSION(1).

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 tools/testing/selftests/kvm/include/evmcs.h  | 2 ++
 tools/testing/selftests/kvm/lib/x86_64/vmx.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/include/evmcs.h b/tools/testing/selftests/kvm/include/evmcs.h
index 4912d23844bc..d8f4d6bfe05d 100644
--- a/tools/testing/selftests/kvm/include/evmcs.h
+++ b/tools/testing/selftests/kvm/include/evmcs.h
@@ -16,6 +16,8 @@
 #define u32 uint32_t
 #define u64 uint64_t
 
+#define EVMCS_VERSION 1
+
 extern bool enable_evmcs;
 
 struct hv_vp_assist_page {
diff --git a/tools/testing/selftests/kvm/lib/x86_64/vmx.c b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
index 7aaa99ca4dbc..1efbfa18f184 100644
--- a/tools/testing/selftests/kvm/lib/x86_64/vmx.c
+++ b/tools/testing/selftests/kvm/lib/x86_64/vmx.c
@@ -191,7 +191,7 @@ bool load_vmcs(struct vmx_pages *vmx)
 		if (evmcs_vmptrld(vmx->enlightened_vmcs_gpa,
 				  vmx->enlightened_vmcs))
 			return false;
-		current_evmcs->revision_id = vmcs_revision();
+		current_evmcs->revision_id = EVMCS_VERSION;
 	}
 
 	return true;
-- 
2.24.1

