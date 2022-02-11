Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F08C4B23D1
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349288AbiBKLBX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:01:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbiBKLBV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:01:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0227BD57
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644577280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=hbSaPciou3jSEZDbn05WRk0NCLE3xSiIT9BU9P6WTsg=;
        b=OdTFVGX32/VGEiyhCauQi6GWf+GpVI+ZQ436i2SONVBnRHjJr92/NV48MjcvnTifkKwBDR
        S99PxzXUrPcxUt/6ORBdWQa/2q99TvTF5NeZzhsGYfDgKrNwyvL0lCf2IkiFPIhvZJfJsx
        1yyImH1v8nHbKTNFG03wN444FMQ20X8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-3c__71EoPsCVQclPSY2ong-1; Fri, 11 Feb 2022 06:01:19 -0500
X-MC-Unique: 3c__71EoPsCVQclPSY2ong-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B7001091DA6;
        Fri, 11 Feb 2022 11:01:18 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BF91D7C0D1;
        Fri, 11 Feb 2022 11:01:17 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     mlevitsk@redhat.com
Subject: [PATCH 0/3] KVM: SVM: fix race between interrupt delivery and AVIC inhibition
Date:   Fri, 11 Feb 2022 06:01:14 -0500
Message-Id: <20220211110117.2764381-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a split and cleaned-up version of Maxim's patch to fix the
SVM race between interrupt delivery and AVIC inhibition.  The final
difference is just code movement and formatting.

Maxim Levitsky (2):
  KVM: SVM: extract avic_ring_doorbell
  KVM: SVM: fix race between interrupt delivery and AVIC inhibition

Paolo Bonzini (1):
  KVM: SVM: set IRR in svm_deliver_interrupt

 arch/x86/kvm/svm/avic.c | 73 ++++++++++++++---------------------------
 arch/x86/kvm/svm/svm.c  | 48 +++++++++++++++++++++++----
 arch/x86/kvm/svm/svm.h  |  4 ++-
 arch/x86/kvm/x86.c      |  4 ++-
 4 files changed, 72 insertions(+), 57 deletions(-)

-- 
2.31.1

