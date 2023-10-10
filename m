Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBF67BFF26
	for <lists+kvm@lfdr.de>; Tue, 10 Oct 2023 16:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232977AbjJJOZy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Oct 2023 10:25:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232953AbjJJOZw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 Oct 2023 10:25:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F16A399
        for <kvm@vger.kernel.org>; Tue, 10 Oct 2023 07:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696947902;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=M1ohce11WkNNe0cgAMwi8ts3gYAezYJYisUUMXuKoVk=;
        b=CgkLaFa03+4DpM6yTv8k4Hs0d6VRDgGrYZk1ivKyf9tRzbOwWNUTV2DlJRwxQv9USL4Jhu
        f8ALNOh8UTrQcPTT/St6/InTSBMcNqCoI5HK0D5oIzVVi8zSQb3Ux8PasvzaLUFbr8eToe
        j9MqM8qhaRZOij4BiQOz3QuQnuf66Rk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-46-89qBaz_dOnaFnIUeUFJLoQ-1; Tue, 10 Oct 2023 10:24:58 -0400
X-MC-Unique: 89qBaz_dOnaFnIUeUFJLoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 56B9C1875056;
        Tue, 10 Oct 2023 14:24:57 +0000 (UTC)
Received: from gondolin.str.redhat.com (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6BD3921CAC6B;
        Tue, 10 Oct 2023 14:24:56 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Gavin Shan <gshan@redhat.com>, qemu-arm@nongnu.org,
        qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH v2 0/3] arm/kvm: use kvm_{get,set}_one_reg
Date:   Tue, 10 Oct 2023 16:24:50 +0200
Message-ID: <20231010142453.224369-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I sent this cleanup first... in mid-July (ugh). But better late than never, I guess.

From v1:
- fix buglets (thanks Gavin)
- add patch 3 on top

The kvm_{get,set}_one_reg functions have been around for a very long
time, and using them instead of open-coding the ioctl invocations
saves lines of code, and gives us a tracepoint as well. They cannot
be used by invocations of the ioctl not acting on a CPUState, but
that still leaves a lot of conversions in the target/arm code.

target/mips and target/ppc also have some potential for conversions,
but as I cannot test either (and they are both in 'Odd fixes' anyway),
I left them alone.

Survives some testing on a Mt. Snow.

Cornelia Huck (3):
  arm/kvm: convert to kvm_set_one_reg
  arm/kvm: convert to kvm_get_one_reg
  arm/kvm: convert to read_sys_reg64

 target/arm/kvm.c   |  28 +++-------
 target/arm/kvm64.c | 129 ++++++++++++---------------------------------
 2 files changed, 40 insertions(+), 117 deletions(-)

-- 
2.41.0

