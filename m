Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC3D3C7456
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231793AbhGMQWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:23577 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230402AbhGMQWN (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jvjPtzgSCNEaPmg+JuQjS0ZcjYXLwadqB4W92gvCUts=;
        b=NkD/yagT3FFpDH9kgQuoNKRkhDYCpMVvB8myC8Q0JwkhTE/T2QS0u4wMDDi5AI8nB8cjUC
        3kDlctey8DnD+OvfHTsDdAPFbCW59vhMEQVCnGZ+6jQGFgGZEV2CBvNXlyjVFFES7DQZMU
        jwN2qG2zAxTync2zvIt08DOrlrulbTE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-148-SkkdjDW0ORiU3Y1YfV-4DA-1; Tue, 13 Jul 2021 12:19:21 -0400
X-MC-Unique: SkkdjDW0ORiU3Y1YfV-4DA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67F8C80006E;
        Tue, 13 Jul 2021 16:19:20 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 225C119C44;
        Tue, 13 Jul 2021 16:19:20 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Michal Privoznik <mprivozn@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Pankaj Gupta <pankaj.gupta@ionos.com>
Subject: [PULL 10/11] numa: Report expected initiator
Date:   Tue, 13 Jul 2021 12:09:56 -0400
Message-Id: <20210713160957.3269017-11-ehabkost@redhat.com>
In-Reply-To: <20210713160957.3269017-1-ehabkost@redhat.com>
References: <20210713160957.3269017-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Michal Privoznik <mprivozn@redhat.com>

When setting up NUMA with HMAT enabled there's a check performed
in machine_set_cpu_numa_node() that reports an error when a NUMA
node has a CPU but the node's initiator is not itself. The error
message reported contains only the expected value and not the
actual value (which is different because an error is being
reported). Report both values in the error message.

Signed-off-by: Michal Privoznik <mprivozn@redhat.com>
Reviewed-by: Igor Mammedov <imammedo@redhat.com>
Reviewed-by: Pankaj Gupta <pankaj.gupta@ionos.com>
Message-Id: <ebdf871551ea995bafa7a858899a26aa9bc153d3.1625662776.git.mprivozn@redhat.com>
Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
---
 hw/core/machine.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/hw/core/machine.c b/hw/core/machine.c
index 57c18f909ab..6f59fb0b7f2 100644
--- a/hw/core/machine.c
+++ b/hw/core/machine.c
@@ -728,7 +728,8 @@ void machine_set_cpu_numa_node(MachineState *machine,
             if ((numa_info[props->node_id].initiator < MAX_NODES) &&
                 (props->node_id != numa_info[props->node_id].initiator)) {
                 error_setg(errp, "The initiator of CPU NUMA node %" PRId64
-                        " should be itself", props->node_id);
+                           " should be itself (got %" PRIu16 ")",
+                           props->node_id, numa_info[props->node_id].initiator);
                 return;
             }
             numa_info[props->node_id].has_cpu = true;
-- 
2.31.1

