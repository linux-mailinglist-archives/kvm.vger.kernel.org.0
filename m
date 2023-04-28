Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280616F14EC
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 12:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345781AbjD1KDE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 06:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230198AbjD1KCw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 06:02:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92BFA5BB9
        for <kvm@vger.kernel.org>; Fri, 28 Apr 2023 03:02:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682676120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=beGSlsM1YO7VmD2gFWs75nRL02r/305Ahmeskyo8oHQ=;
        b=UzkviSKRYDF5k8yvIGm53PpBYD28wTzXwsmxEkQJ1XcKlVIJMdj26pStsc/r6R2Vuqpe0a
        BYDzpjHjzRlArF02qVRGG/dFymzpm1MUrk1C+aKvzpHGTz78tMINMSNUf8dPsBD4XH2iuM
        9CL38Lv4ThHfR7rAdEwTNSgKQps8SGA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-654-ZZNYkKpRNiuMLttegxqNmw-1; Fri, 28 Apr 2023 05:55:39 -0400
X-MC-Unique: ZZNYkKpRNiuMLttegxqNmw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 054CA1C0754D;
        Fri, 28 Apr 2023 09:55:39 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.193.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 178FB1121314;
        Fri, 28 Apr 2023 09:55:36 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Andrea Bolognani <abologna@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v7 0/1] arm: enable MTE for QEMU + kvm
Date:   Fri, 28 Apr 2023 11:55:32 +0200
Message-Id: <20230428095533.21747-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

v7 takes a different approach to wiring up MTE, so I still include a cover
letter where I can explain things better, even though it is now only a
single patch :)

Previous versions used a cpu property to control MTE enablement, while
keeping the same semantics for the virt machine "mte" property as used with
tcg. This version now uses the machine property for kvm as well; while it
continues to control allocation of tag memory for tcg, it now also controls
enablement of the kvm capability. Since the cpu prop is now gone, so is the
testing via the arm cpu props test; I don't have a good idea for testing
mte on kvm automatically, since it has a hard dependency on host support.
(Should I tack some futher documentation somewhere? I'm not seeing an
obvious place.)

A kvm guest with mte enabled still cannot be migrated (we need some uffd
interface enhancements before we can support postcopy), so it is still off
per default.

Another open problem is mte vs mte3: tcg emulates mte3, kvm gives the guest
whatever the host supports. Without migration support, this is not too much
of a problem yet, but for compatibility handling, we'll need a way to keep
QEMU from handing out mte3 for guests that might be migrated to a mte3-less
host. We could tack this unto the mte property (specifying the version or
max supported), or we could handle this via cpu properties if we go with
handling compatibility via cpu models (sorting this out for kvm is probably
going to be interesting in general.) In any case, I think we'll need a way
to inform kvm of it.

Tested with kvm selftests on FVP (as I still don't have any hardware with
MTE...) and some make check(-tcg) incantations. Hopefully, I haven't (re)-
introduced too many issues.

Cornelia Huck (1):
  arm/kvm: add support for MTE

 hw/arm/virt.c        | 69 +++++++++++++++++++++++++-------------------
 target/arm/cpu.c     |  9 +++---
 target/arm/cpu.h     |  4 +++
 target/arm/kvm.c     | 35 ++++++++++++++++++++++
 target/arm/kvm64.c   |  5 ++++
 target/arm/kvm_arm.h | 19 ++++++++++++
 6 files changed, 107 insertions(+), 34 deletions(-)

-- 
2.40.0

