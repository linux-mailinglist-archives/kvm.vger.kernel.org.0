Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB65542FFD
	for <lists+kvm@lfdr.de>; Wed,  8 Jun 2022 14:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238755AbiFHMM7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Jun 2022 08:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiFHMM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 Jun 2022 08:12:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CC6ED25BC07
        for <kvm@vger.kernel.org>; Wed,  8 Jun 2022 05:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654690375;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yZI3jY70HIdxw3S33YmbSm1vbKbWcOVQmH/RkNv3TeI=;
        b=AF8oJorUCbrYmBDnSymxKlwe3oTxBFIEeqhO+spq7zEOGpj+OuZ2lkl5PYv9lDUd2paLt3
        7PYSWwjYjYMAwiQ+9eeQQwqdndQo/pg4WSwsstq6lm8dwDwBmVOWIhBsQ4eRy/iPuok5Ai
        cyCxHlg8BiW59kex93WGtPTJkE/9sfQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-113-TBO7NspWNI6_-KV1nsdIgA-1; Wed, 08 Jun 2022 08:12:54 -0400
X-MC-Unique: TBO7NspWNI6_-KV1nsdIgA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0733F3C02B73;
        Wed,  8 Jun 2022 12:12:54 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF6521415100;
        Wed,  8 Jun 2022 12:12:53 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH 0/6] KVM: x86: vcpu->arch.pio* cleanups
Date:   Wed,  8 Jun 2022 08:12:47 -0400
Message-Id: <20220608121253.867333-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
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


Paolo Bonzini (6):
  KVM: x86: inline kernel_pio into its sole caller
  KVM: x86: move all vcpu->arch.pio* setup in emulator_pio_in_out
  KVM: x86: wean in-kernel PIO from vcpu->arch.pio*
  KVM: x86: wean fast IN from emulator_pio_in
  KVM: x86: de-underscorify __emulator_pio_in
  KVM: SEV-ES: reuse advance_sev_es_emulated_ins for OUT too

 arch/x86/kvm/trace.h |   2 +-
 arch/x86/kvm/x86.c   | 119 ++++++++++++++++++-------------------------
 2 files changed, 50 insertions(+), 71 deletions(-)

-- 
2.31.1

