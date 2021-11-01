Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094A6442313
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 23:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232298AbhKAWML (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 18:12:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59198 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232286AbhKAWMF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 18:12:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635804571;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YGFGnLXWsheb/qmVvEQnfSbPAvk7Yei/m0I6VzGvNKw=;
        b=Jyf6//8Zu3kbIbVIS8M9m5YgJOIrlgTHuURpHs/7RsCjFFPzzz4qDjGzrjkYMDbNxibDZy
        f1NN6ak0eevgrOiwElXACQ2UPKhkvC+nHHrGdg147ASFa/Jzq3bdQyRFufT/LLa9wFDDOP
        c3mclGysmmuXYuSfjWX2RunGzpNRSpA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-OeNNtpahOoO6qEZH1RkQ5w-1; Mon, 01 Nov 2021 18:09:30 -0400
X-MC-Unique: OeNNtpahOoO6qEZH1RkQ5w-1
Received: by mail-wm1-f70.google.com with SMTP id k25-20020a05600c1c9900b00332f798ba1dso174829wms.4
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 15:09:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YGFGnLXWsheb/qmVvEQnfSbPAvk7Yei/m0I6VzGvNKw=;
        b=FTU6ArSm+Ff2I40CPs1Kzty2iztju9WUMMonx0/YQbrDY1Su5y/j7KqsH5YYthPVJu
         xAIV8LTJtp5DbB8w5uDpO1W2gNqIQ7/T7xPAeMTQzjkmsOsz+2jeE8R2MxTSyovzUXr6
         EMHJ9B/s5iBBIuhIIwReCZ/4gmXpkahBWiKTXWQc7wzF08rG9fx07MQ1Fr0x1wLU1igs
         Ikodkk+AN15pVw+HneXhOgqBJoH1l6/8rApnIuKjF+QLrXurabCz9SGwhjO3NFFof3wv
         MS/u2+NITjIw+eG7VOC82O/zlrfNEU2HV2MPadQZQ58gSmn7gBFqvSxJ+4+ep3cRyfAr
         xORw==
X-Gm-Message-State: AOAM531NjKKFz+41+VqQE4htIF+fY8WM6uB4+byjp2znXjoAONezn6KG
        cFQORYOfvfxBjnzKTv6fQsid51G+xmp+jpUw4n4bMjt4ptSMmG3fZUXJWOGS+t/4yd0ENjhbkEU
        fgIO2x9TDgOZ/
X-Received: by 2002:a7b:cb52:: with SMTP id v18mr2063960wmj.10.1635804569184;
        Mon, 01 Nov 2021 15:09:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJycZK3+VR9iW1fa+cGg38G9Qb59TRFSiW9klW7eikgdbxXetfRBE2KmtCFvsskBng80n8r0wQ==
X-Received: by 2002:a7b:cb52:: with SMTP id v18mr2063943wmj.10.1635804569026;
        Mon, 01 Nov 2021 15:09:29 -0700 (PDT)
Received: from localhost (static-233-86-86-188.ipcom.comunitel.net. [188.86.86.233])
        by smtp.gmail.com with ESMTPSA id q18sm658847wmc.7.2021.11.01.15.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 15:09:28 -0700 (PDT)
From:   Juan Quintela <quintela@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Markus Armbruster <armbru@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        xen-devel@lists.xenproject.org,
        Richard Henderson <richard.henderson@linaro.org>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        =?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
        Paul Durrant <paul@xen.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>
Subject: [PULL 11/20] memory: Introduce replay_discarded callback for RamDiscardManager
Date:   Mon,  1 Nov 2021 23:09:03 +0100
Message-Id: <20211101220912.10039-12-quintela@redhat.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101220912.10039-1-quintela@redhat.com>
References: <20211101220912.10039-1-quintela@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: David Hildenbrand <david@redhat.com>

Introduce replay_discarded callback similar to our existing
replay_populated callback, to be used my migration code to never migrate
discarded memory.

Acked-by: Peter Xu <peterx@redhat.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Juan Quintela <quintela@redhat.com>
Signed-off-by: Juan Quintela <quintela@redhat.com>
---
 include/exec/memory.h | 21 +++++++++++++++++++++
 softmmu/memory.c      | 11 +++++++++++
 2 files changed, 32 insertions(+)

diff --git a/include/exec/memory.h b/include/exec/memory.h
index 04280450c9..20f1b27377 100644
--- a/include/exec/memory.h
+++ b/include/exec/memory.h
@@ -550,6 +550,7 @@ static inline void ram_discard_listener_init(RamDiscardListener *rdl,
 }
 
 typedef int (*ReplayRamPopulate)(MemoryRegionSection *section, void *opaque);
+typedef void (*ReplayRamDiscard)(MemoryRegionSection *section, void *opaque);
 
 /*
  * RamDiscardManagerClass:
@@ -638,6 +639,21 @@ struct RamDiscardManagerClass {
                             MemoryRegionSection *section,
                             ReplayRamPopulate replay_fn, void *opaque);
 
+    /**
+     * @replay_discarded:
+     *
+     * Call the #ReplayRamDiscard callback for all discarded parts within the
+     * #MemoryRegionSection via the #RamDiscardManager.
+     *
+     * @rdm: the #RamDiscardManager
+     * @section: the #MemoryRegionSection
+     * @replay_fn: the #ReplayRamDiscard callback
+     * @opaque: pointer to forward to the callback
+     */
+    void (*replay_discarded)(const RamDiscardManager *rdm,
+                             MemoryRegionSection *section,
+                             ReplayRamDiscard replay_fn, void *opaque);
+
     /**
      * @register_listener:
      *
@@ -682,6 +698,11 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
                                          ReplayRamPopulate replay_fn,
                                          void *opaque);
 
+void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
+                                          MemoryRegionSection *section,
+                                          ReplayRamDiscard replay_fn,
+                                          void *opaque);
+
 void ram_discard_manager_register_listener(RamDiscardManager *rdm,
                                            RamDiscardListener *rdl,
                                            MemoryRegionSection *section);
diff --git a/softmmu/memory.c b/softmmu/memory.c
index f2ac0d2e89..7340e19ff5 100644
--- a/softmmu/memory.c
+++ b/softmmu/memory.c
@@ -2081,6 +2081,17 @@ int ram_discard_manager_replay_populated(const RamDiscardManager *rdm,
     return rdmc->replay_populated(rdm, section, replay_fn, opaque);
 }
 
+void ram_discard_manager_replay_discarded(const RamDiscardManager *rdm,
+                                          MemoryRegionSection *section,
+                                          ReplayRamDiscard replay_fn,
+                                          void *opaque)
+{
+    RamDiscardManagerClass *rdmc = RAM_DISCARD_MANAGER_GET_CLASS(rdm);
+
+    g_assert(rdmc->replay_discarded);
+    rdmc->replay_discarded(rdm, section, replay_fn, opaque);
+}
+
 void ram_discard_manager_register_listener(RamDiscardManager *rdm,
                                            RamDiscardListener *rdl,
                                            MemoryRegionSection *section)
-- 
2.33.1

