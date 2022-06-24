Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C72559F49
	for <lists+kvm@lfdr.de>; Fri, 24 Jun 2022 19:26:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiFXRTG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Jun 2022 13:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbiFXRSz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Jun 2022 13:18:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B48E3AA44
        for <kvm@vger.kernel.org>; Fri, 24 Jun 2022 10:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656091133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=DPw7e4tEvF/rfLD9qEFron5ByavvAW72LnDfMRrQrXQ=;
        b=Bx0jnhSjbzQpLXlUB3vZrgZASB0G7lKCkpVKH0Kx82Xzd692zvvFwwodgEgVeEjHHdpmoF
        kNTQTK/2qhLZ/n/xSeWiBCPk86TSa1IrbXiZNRcxy6T2kKyY2hFmGIGAj48YtV1Onj3Ck7
        fiVxEKbeWSPXqQHw6R5Yj25XClPVGfc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-110-nTvsyNMgO5aulpHklEcfJQ-1; Fri, 24 Jun 2022 13:18:49 -0400
X-MC-Unique: nTvsyNMgO5aulpHklEcfJQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 15A13802D2C;
        Fri, 24 Jun 2022 17:18:49 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F26E1492CA6;
        Fri, 24 Jun 2022 17:18:48 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: [PATCH v2 0/8] KVM: x86: vcpu->arch.pio* cleanups
Date:   Fri, 24 Jun 2022 13:18:40 -0400
Message-Id: <20220624171848.2801602-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

These patches complete the job started by commit 3b27de271839 ("KVM:
x86: split the two parts of emulator_pio_in", 2021-10-22).  The commit
message eloquently said that emulator_pio_in_out "currently hardcodes
vcpu->arch.pio_data as the source/destination buffer, which sucks but
will be fixed after the more severe SEV-ES buffer overflow".  Some time
has passed and it's high time to do it.

After this series, in-kernel PIO does not use vcpu->arch.pio* anymore;
it is only used by complete_emulator_pio_in.

Paolo

v1->v2:
- split out "KVM: x86: complete fast IN directly with complete_emulator_pio_in()"
- remove WARN if emulated PIO performs successful in-kernel iterations before
  falling back to userspace, it is (unfortunately) valid if SRCU changes mid-loop.
- new patch 3 to handle unregistered devices mid-loop, dropping writes and reading
  as zero
- WARN if non-NULL data is passed to emulator_pio_in_out() before the code is
  ready to handle in-kernel PIO without vcpu->arch.pio*
- use "size" in SEV case instead of vcpu->arch.pio_size

Paolo Bonzini (8):
  KVM: x86: complete fast IN directly with complete_emulator_pio_in()
  KVM: x86: inline kernel_pio into its sole caller
  KVM: x86: drop PIO from unregistered devices
  KVM: x86: move all vcpu->arch.pio* setup in emulator_pio_in_out()
  KVM: x86: wean in-kernel PIO from vcpu->arch.pio*
  KVM: x86: wean fast IN from emulator_pio_in
  KVM: x86: de-underscorify __emulator_pio_in
  KVM: SEV-ES: reuse advance_sev_es_emulated_ins for OUT too

 arch/x86/kvm/trace.h |   2 +-
 arch/x86/kvm/x86.c   | 133 ++++++++++++++++++++-----------------------
 2 files changed, 62 insertions(+), 73 deletions(-)

-- 
2.31.1

