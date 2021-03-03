Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35F132C736
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245258AbhCDAbS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:31:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27354 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1580785AbhCCSfD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:35:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614796414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bQjkhbMoK/p110+ezCXx6XyhC9yOCxnNoBGV8HeX/9Y=;
        b=ORgLPtM4d8DBR49nyXgU2H7w9t8ufZ5ZKz9C3PF6GKedQtQUrg+Q9DWGCAX8DnIa5Od7C1
        hZ319MvBsgRCr7MeJA3rzSfJdVJ6FcC/JboteaoRc8DaMky32Zpb/X4Gm2Hkn69ZSe/6sw
        +iUHBgO89A4zm11nwSbKVnr3RfXAILM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-0sFOY8I9NP6RYxV4ym3Bmg-1; Wed, 03 Mar 2021 13:22:29 -0500
X-MC-Unique: 0sFOY8I9NP6RYxV4ym3Bmg-1
Received: by mail-wr1-f71.google.com with SMTP id x9so9271873wro.9
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:22:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bQjkhbMoK/p110+ezCXx6XyhC9yOCxnNoBGV8HeX/9Y=;
        b=WNw4HCQaXCd2Ev4X9MFwHzxD8L7jDezCANcNU1bYGRppbnqD39+LYpbd1AAJtmgV/L
         vo6jCMykiyjsc47Nx5CbqJ7eNWlLzFxbASqm097PMdRz+p+PjRdqhj3+5FlOsJMxLTy3
         zg3IDwq30bnG5pQ8QGX+WNnQrCB7dNr+Vj2AE+q6Jx110XM6fKXnPg82IR9CsenrAdmB
         NvfzTQWuWaexpDGqBGCoyDzPbj9Z2SmXumNsrmAVDq+SqSN0IV+X9GrtYK8bpmOXc7Mn
         XahqyrQL9e518J5WVcQRv2GEpYRPCuAcnfC045jPwA4dLs85sujH4NBq0XLAlRJq8DWS
         g84Q==
X-Gm-Message-State: AOAM530i4jOgbC0qlwndEZvtDrWsRbS3P6AvBgDvXkR8a32mH5RcIqhg
        g+kbBklTATteu/33UAGWGD8sklXIjSWi775qxpq/pgpS6zqR91cgA7oRbpf7hDDexxIr2rkvXab
        fV2EoHA3Lf55D
X-Received: by 2002:adf:a219:: with SMTP id p25mr28636304wra.400.1614795747924;
        Wed, 03 Mar 2021 10:22:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyfbZpBv9k7hXSgga18Q2U7X80Yx3nYLyWQWxwQRzBihlp/Au8nBqtr9CXYtuKzZpEM6c4XtA==
X-Received: by 2002:adf:a219:: with SMTP id p25mr28636276wra.400.1614795747724;
        Wed, 03 Mar 2021 10:22:27 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id q15sm33044035wrr.58.2021.03.03.10.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:22:27 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Eduardo Habkost <ehabkost@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        kvm@vger.kernel.org, Wenchao Wang <wenchao.wang@intel.com>,
        Thomas Huth <thuth@redhat.com>,
        Cameron Esfahani <dirty@apple.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Greg Kurz <groug@kaod.org>, qemu-arm@nongnu.org,
        Halil Pasic <pasic@linux.ibm.com>,
        Colin Xu <colin.xu@intel.com>,
        Claudio Fontana <cfontana@suse.de>, qemu-ppc@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        qemu-s390x@nongnu.org, haxm-team@intel.com,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH 01/19] target/i386/hvf: Use boolean value for vcpu_dirty
Date:   Wed,  3 Mar 2021 19:22:01 +0100
Message-Id: <20210303182219.1631042-2-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

CPUState::vcpu_dirty is of type 'bool', not 'integer'.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/hvf/hvf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/target/i386/hvf/hvf.c b/target/i386/hvf/hvf.c
index 15f14ac69e7..3c5c9c8197e 100644
--- a/target/i386/hvf/hvf.c
+++ b/target/i386/hvf/hvf.c
@@ -533,7 +533,7 @@ int hvf_init_vcpu(CPUState *cpu)
     }
 
     r = hv_vcpu_create((hv_vcpuid_t *)&cpu->hvf_fd, HV_VCPU_DEFAULT);
-    cpu->vcpu_dirty = 1;
+    cpu->vcpu_dirty = true;
     assert_hvf_ok(r);
 
     if (hv_vmx_read_capability(HV_VMX_CAP_PINBASED,
-- 
2.26.2

