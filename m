Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6AF5B1B70
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 13:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbiIHLbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 07:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231264AbiIHLbQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 07:31:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 246D5C7437
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 04:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662636674;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=pOU7hRIJcm8dRtYse1TxPAeV38bnQMDLW8zImgBi/RI=;
        b=X/BYp6gQTAmfarqbayjAE4JzW6V3CB+4pJobMbINudN8HG93dWZ1BP9Ezw5qYE4Yrz39ZA
        MSYsFVbNUzUzBD0gUHmHf4AdWFTj2+vKOxjxL9qAE2YdSeAuduTGzTzTpHXmPV8kupz+/T
        2YaaroPuYDOm1qZKc7iDNDa+/9D/2fo=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-558-8bdDrd0jM062jFt06iPO8Q-1; Thu, 08 Sep 2022 07:31:12 -0400
X-MC-Unique: 8bdDrd0jM062jFt06iPO8Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 887233C01E1A;
        Thu,  8 Sep 2022 11:31:11 +0000 (UTC)
Received: from sirius.home.kraxel.org (unknown [10.39.194.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2E336945DF;
        Thu,  8 Sep 2022 11:31:11 +0000 (UTC)
Received: by sirius.home.kraxel.org (Postfix, from userid 1000)
        id A92FF18009BE; Thu,  8 Sep 2022 13:31:09 +0200 (CEST)
From:   Gerd Hoffmann <kraxel@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: [PATCH v2 0/2] expose host-phys-bits to guest
Date:   Thu,  8 Sep 2022 13:31:07 +0200
Message-Id: <20220908113109.470792-1-kraxel@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
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

v2:
 - change fvm hint name.
 - better commit message.

take care,
  Gerd

Gerd Hoffmann (2):
  [temporary] reserve bit KVM_HINTS_PHYS_ADDRESS_SIZE_DATA_VALID
  [RfC] expose host-phys-bits to guest

 include/standard-headers/asm-x86/kvm_para.h | 3 ++-
 target/i386/cpu.h                           | 3 ---
 hw/i386/microvm.c                           | 7 ++++++-
 target/i386/cpu.c                           | 3 +--
 target/i386/host-cpu.c                      | 5 ++++-
 target/i386/kvm/kvm.c                       | 1 +
 6 files changed, 14 insertions(+), 8 deletions(-)

-- 
2.37.3

