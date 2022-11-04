Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D417A618D84
	for <lists+kvm@lfdr.de>; Fri,  4 Nov 2022 02:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbiKDBL3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 21:11:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbiKDBLU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 21:11:20 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258BC220C8
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 18:11:19 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-37342ba89dbso33722967b3.1
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 18:11:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DVyQMJ/hVRvvulqgoMW2WeWXC7WT0Qk0m1EuDV5v41A=;
        b=PQ01Z/eWCROdg6wptfL9xDEZzpuwG0L8Xm+zs8jhf8zCDIKQHzgHS2nYXtnxlIotzm
         QK0pJhfhkSTRdHdGFphaXaLW1wNck7vtuv15Cz3sELQBwWxIVmgfSSbPdHUXVm+F1NXE
         VACBoH2MK+PRd3kTd/87J0HS5jB+JpvZeWsto5Z+1PvCcYoxya2SDs7W63OS/SkKAqYk
         e4h+LHQ+zRqw6B5kSDX/xzaRtYzuRalDlXNp5zcoGD+hmpQUwJhImh32C5LnLg34BwTP
         LJ+wnwtZsSakJ7QaJglHzffQdgmQkl/8eLWdd7P/evkLEdw1ajSbxO19hQL9wfyUwZnS
         +e7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DVyQMJ/hVRvvulqgoMW2WeWXC7WT0Qk0m1EuDV5v41A=;
        b=ZBDAs8oWdZvQfnjp0SnvxsJUVmG1uuq0uie/Fyzp0XrXp1PYCHVOMB8lzA1kuL9huB
         8IlSHcn5DBRSaZBG1UYsblS6pWYPH+azmnuurZnHrokkUWi25xYD9c5uhjVpfbc9Y7pq
         pYH/KgscL75KJXBgNcu7750WdpVzvrWXMqd11tNBazvUPcPonMA1tmI4KPTPCALWA+UN
         CtkJy6urn3kwyO+0VIb4a7qT7HwgR1feiL2OwbKukw1m08xs87X/Ke64eE8xjJnrh3sL
         gbeqJGyivIbToatM75Jp7NWkNjszZVP8aque++GcvSgjWw1E48tA68hyIaevnO57vdNW
         dkwg==
X-Gm-Message-State: ACrzQf3ddZ6yHUacL7PqCyJTAbGSfkGPW/zwgpJZpFync/8PN+ZmzRjW
        a5EXCtPNnNc+9KfErKQW9Td9bKg=
X-Google-Smtp-Source: AMsMyM5iy+9LxEdaoz+PBI8tytwaj51kRKgjlikY6ojuKPepInTV3TsN3lEgpA/59HjnDyluctdWXjE=
X-Received: from pcc-desktop.svl.corp.google.com ([2620:15c:2ce:200:2844:b0ec:e556:30d8])
 (user=pcc job=sendgmr) by 2002:a81:7094:0:b0:370:4592:dffe with SMTP id
 l142-20020a817094000000b003704592dffemr219576ywc.345.1667524278368; Thu, 03
 Nov 2022 18:11:18 -0700 (PDT)
Date:   Thu,  3 Nov 2022 18:10:41 -0700
In-Reply-To: <20221104011041.290951-1-pcc@google.com>
Message-Id: <20221104011041.290951-9-pcc@google.com>
Mime-Version: 1.0
References: <20221104011041.290951-1-pcc@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Subject: [PATCH v5 8/8] Documentation: document the ABI changes for KVM_CAP_ARM_MTE
From:   Peter Collingbourne <pcc@google.com>
To:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc:     Peter Collingbourne <pcc@google.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Evgenii Stepanov <eugenis@google.com>, kvm@vger.kernel.org,
        Steven Price <steven.price@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document both the restriction on VM_MTE_ALLOWED mappings and
the relaxation for shared mappings.

Signed-off-by: Peter Collingbourne <pcc@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 Documentation/virt/kvm/api.rst | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index eee9f857a986..b55f80dadcfe 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -7385,8 +7385,9 @@ hibernation of the host; however the VMM needs to manually save/restore the
 tags as appropriate if the VM is migrated.
 
 When this capability is enabled all memory in memslots must be mapped as
-not-shareable (no MAP_SHARED), attempts to create a memslot with a
-MAP_SHARED mmap will result in an -EINVAL return.
+``MAP_ANONYMOUS`` or with a RAM-based file mapping (``tmpfs``, ``memfd``),
+attempts to create a memslot with an invalid mmap will result in an
+-EINVAL return.
 
 When enabled the VMM may make use of the ``KVM_ARM_MTE_COPY_TAGS`` ioctl to
 perform a bulk copy of tags to/from the guest.
-- 
2.38.1.431.g37b22c650d-goog

