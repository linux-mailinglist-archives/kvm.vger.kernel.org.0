Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB955A7DF1
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 14:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbiHaMvL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 08:51:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiHaMvG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 08:51:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EE95205F3
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 05:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661950264;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=3SyWGJ1mzR9fPTQBfCSE21gwkrtS3xR2GumngAPW6F0=;
        b=PwYr49B4hyvsu5WT/aX/EttKz1u6XkAc8irFgg8lfueh08fX0JtaCSS56V2SkUSwtcQrVf
        TuQgLTGXwwbsuIXp+yYmB8uOZ7VhJuEaTxfj/fekOGcpPoc38e4ctTFVxx2Zk3D1hNcsrE
        r1abV/7fEBzxBLB5iZe8vuZpBp/RITk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-EavAyjzoO-KZPkIOpW_lig-1; Wed, 31 Aug 2022 08:51:01 -0400
X-MC-Unique: EavAyjzoO-KZPkIOpW_lig-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B7EB81C0BC69;
        Wed, 31 Aug 2022 12:51:00 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.195.70])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6B0402026D64;
        Wed, 31 Aug 2022 12:51:00 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id 2440018000A3; Wed, 31 Aug 2022 14:50:59 +0200 (CEST)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH 0/2] expose host-phys-bits to guest
Date:   Wed, 31 Aug 2022 14:50:57 +0200
Message-Id: <20220831125059.170032-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When the guest (firmware specifically) knows how big
the address space actually is it can be used better.

Some more background:
  https://bugzilla.redhat.com/show_bug.cgi?id=2084533

This is a RfC series exposes the information via cpuid.

take care,
  Gerd

Gerd Hoffmann (2):
  [hack] reserve bit KVM_HINTS_HOST_PHYS_BITS
  [RfC] expose host-phys-bits to guest

 include/standard-headers/asm-x86/kvm_para.h | 3 ++-
 target/i386/cpu.h                           | 3 ---
 hw/i386/microvm.c                           | 6 +++++-
 target/i386/cpu.c                           | 3 +--
 target/i386/host-cpu.c                      | 4 +++-
 target/i386/kvm/kvm.c                       | 1 +
 6 files changed, 12 insertions(+), 8 deletions(-)

-- 
2.37.2

