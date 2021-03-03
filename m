Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A92132C6DC
	for <lists+kvm@lfdr.de>; Thu,  4 Mar 2021 02:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346723AbhCDAaM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Mar 2021 19:30:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:33488 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349975AbhCCS2d (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Mar 2021 13:28:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614795967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PDMMcK3oLvQF9Y3zPO+zi1w8ujiioTi9C21H6L1uDR8=;
        b=Hjl06wBrk8bCvWovr8O0lE0WC3CGYp5TvvZqdexI74Dvcv7Aet0cWlSDUwn2g0hWyJTrnm
        cE2bPsZ7jAms4URwrbr7diPZQbPfIXQJjwqxBRtexxDZNmZctkv3NwubxVlD5jXhIYeSQb
        /5uBPzZFUNfXtQgsnJpWNGVivBYFFG0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-weIHqmfIP32nV9HKzNYqBQ-1; Wed, 03 Mar 2021 13:22:36 -0500
X-MC-Unique: weIHqmfIP32nV9HKzNYqBQ-1
Received: by mail-wm1-f71.google.com with SMTP id a3so2179863wmm.0
        for <kvm@vger.kernel.org>; Wed, 03 Mar 2021 10:22:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PDMMcK3oLvQF9Y3zPO+zi1w8ujiioTi9C21H6L1uDR8=;
        b=RliVc3B9FFYt6X9PLZx5sLIDRL2qE1WimL8ByEnWTvipQdosAMQi/fj+k/pgMAtqmz
         hW/5Kq7eR2jZfsfXiHQYRif6PZM9iSfoYAzUHZgpuKKXb41jB+wkw5FilhgxmpQ0zr7l
         zNGrLduZ5VqAr+mRuxMyMZdRIsNGhFi6XSM5eqmWC8ZwROc9kf+io6vKLIKNZLSdtNHl
         Wu/PpbjN45nr41PjTEUlNQKGh4Qg466syyoCsoIJze8xKFTjhS1tpsHIup2DEJ6qW7RQ
         /oTTm6VdJj9DgZLRurEL+AO2J73ntdmMpg0ZoDzv1AEmTnYYTLNvgb8K+iWsXtpYNbYd
         pNxA==
X-Gm-Message-State: AOAM530qescwcQxVWo9ValCFoaJlztrVAjvH5J8XzkCfXDoy10ojq6zv
        8MnSrrIrVd+Pc3MwWAKGdcliHGovTuvojFOZk6AJWDc2v/S2+1DSRDjVX+8yx3Eu1FgRSKB7Vhy
        EDxXHV1JkeNJq
X-Received: by 2002:a05:6000:1104:: with SMTP id z4mr33834wrw.10.1614795753958;
        Wed, 03 Mar 2021 10:22:33 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyVg9s4r7l2oq5gGa5GiZIt6JV8Y3K8GM+LsYLl9lX9UTNK+XtLNOIsOPAgN1hKIK0orGUEvQ==
X-Received: by 2002:a05:6000:1104:: with SMTP id z4mr33805wrw.10.1614795753484;
        Wed, 03 Mar 2021 10:22:33 -0800 (PST)
Received: from x1w.redhat.com (68.red-83-57-175.dynamicip.rima-tde.net. [83.57.175.68])
        by smtp.gmail.com with ESMTPSA id f22sm6664306wmc.33.2021.03.03.10.22.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 10:22:33 -0800 (PST)
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
Subject: [PATCH 02/19] target/s390x/kvm: Simplify debug code
Date:   Wed,  3 Mar 2021 19:22:02 +0100
Message-Id: <20210303182219.1631042-3-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210303182219.1631042-1-philmd@redhat.com>
References: <20210303182219.1631042-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We already have the 'run' variable holding 'cs->kvm_run' value.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/s390x/kvm.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
index 7a892d663df..73f816a7222 100644
--- a/target/s390x/kvm.c
+++ b/target/s390x/kvm.c
@@ -1785,8 +1785,7 @@ static int handle_intercept(S390CPU *cpu)
     int icpt_code = run->s390_sieic.icptcode;
     int r = 0;
 
-    DPRINTF("intercept: 0x%x (at 0x%lx)\n", icpt_code,
-            (long)cs->kvm_run->psw_addr);
+    DPRINTF("intercept: 0x%x (at 0x%lx)\n", icpt_code, (long)run->psw_addr);
     switch (icpt_code) {
         case ICPT_INSTRUCTION:
         case ICPT_PV_INSTR:
-- 
2.26.2

