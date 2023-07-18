Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91D61757A38
	for <lists+kvm@lfdr.de>; Tue, 18 Jul 2023 13:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjGRLPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Jul 2023 07:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229619AbjGRLPI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Jul 2023 07:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ECF910DF
        for <kvm@vger.kernel.org>; Tue, 18 Jul 2023 04:14:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689678860;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=NE5TSk+9F1w0/aZJpgmkiBjq7oSucjlnsOr09RhYOt0=;
        b=D3BOkQPJFGPvg8ZBtXDhGL5ir2ksWn/7nTVJ4Lc2jPfB9kFZLvVWUAzdKpzGvOyUaRPp+o
        5nN9r8TY4C/XGOk5eeBzbs+F3b544D45UJ/yq1kePLvkJx+DWKuraDIfaakYgYH0XUUnSg
        qDsuNNX22abidIpyauVCrn4y2py9LgQ=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-173-9v6ZNktVNeuV6XxC2lvxcg-1; Tue, 18 Jul 2023 07:14:18 -0400
X-MC-Unique: 9v6ZNktVNeuV6XxC2lvxcg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2121C3806108;
        Tue, 18 Jul 2023 11:14:17 +0000 (UTC)
Received: from gondolin.redhat.com (unknown [10.39.193.57])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1DE8740C6F4C;
        Tue, 18 Jul 2023 11:14:15 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Cornelia Huck <cohuck@redhat.com>
Subject: [PATCH for-8.2 0/2] arm/kvm: use kvm_{get,set}_one_reg
Date:   Tue, 18 Jul 2023 13:14:02 +0200
Message-ID: <20230718111404.23479-1-cohuck@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The kvm_{get,set}_one_reg functions have been around for a very long
time, and using them instead of open-coding the ioctl invocations
saves lines of code, and gives us a tracepoint as well. They cannot
be used by invocations of the ioctl not acting on a CPUState, but
that still leaves a lot of conversions in the target/arm code.

target/mips and target/ppc also have some potential for conversions,
but as I cannot test either (and they are both in 'Odd fixes' anyway),
I left them alone.

Survives some testing on a Mt. Snow.

Cornelia Huck (2):
  arm/kvm: convert to kvm_set_one_reg
  arm/kvm: convert to kvm_get_one_reg

 target/arm/kvm.c   |  28 +++--------
 target/arm/kvm64.c | 123 ++++++++++++---------------------------------
 2 files changed, 39 insertions(+), 112 deletions(-)

-- 
2.41.0

