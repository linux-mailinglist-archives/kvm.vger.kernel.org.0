Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7647660290A
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 12:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbiJRKKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 06:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbiJRKKI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 06:10:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E2C6DFB0
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 03:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666087804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=T1fNmJPBVIEsz+JLKi8Sx69F/41LoIY1mODMhEBFtEs=;
        b=IXM2pFS+viicmGEPuBgerLXQhovm0W2cLEVgteabOqOYBV29k7bjpiI38O52Lrz+MeWpng
        A6E7EH+kD+myBSIn0hE0sd1pG+OGqtgpnqjQKX5hJ8mfyR/E1MCuHrBRM80b6jCV66bv83
        gUtGO3j6JlbTAJB8hs2XIq1wOii+GWo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-447-Z1zQxKcNMca16ckOdHUlEA-1; Tue, 18 Oct 2022 06:10:03 -0400
X-MC-Unique: Z1zQxKcNMca16ckOdHUlEA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C3C87101A52A;
        Tue, 18 Oct 2022 10:10:02 +0000 (UTC)
Received: from ovpn-193-156.brq.redhat.com (ovpn-193-156.brq.redhat.com [10.40.193.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 015DE40C94AA;
        Tue, 18 Oct 2022 10:10:00 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] KVM: VMX: nVMX: Make eVMCS enablement more robust
Date:   Tue, 18 Oct 2022 12:09:56 +0200
Message-Id: <20221018101000.934413-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is a continuation of "KVM: VMX: Support updated eVMCSv1 revision + use
vmcs_config for L1 VMX MSRs" work:
https://lore.kernel.org/kvm/20220830133737.1539624-1-vkuznets@redhat.com/

and a preparation to enabling new eVMCS features for Hyper-V on KVM, namely
nested TSC scaling.

Future proof KVM against two scenarios:
- nVMX: A new feature which doesn't have a corresponding eVMCSv1 field gets
 implemented in KVM but EVMCS1_UNSUPPORTED_* defines are left unchanged.
- VMX: A new feature supported by KVM but currently missing in eVMCSv1 gets
 implemented in a future Hyper-V version breaking KVM.

Note: 'vmx/evmcs.{c,h}' are renamed to 'vmx/hyperv.{c,h}' in
https://lore.kernel.org/kvm/20221004123956.188909-7-vkuznets@redhat.com/

Vitaly Kuznetsov (4):
  KVM: nVMX: Sanitize primary processor-based VM-execution controls with
    eVMCS too
  KVM: nVMX: Invert 'unsupported by eVMCSv1' check
  KVM: nVMX: Prepare to sanitize tertiary execution controls with eVMCS
  KVM: VMX: Resurrect vmcs_conf sanitization for KVM-on-Hyper-V

 arch/x86/kvm/vmx/evmcs.c | 118 ++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/evmcs.h |  93 +++++++++++++++++++++++++-----
 arch/x86/kvm/vmx/vmx.c   |   5 ++
 3 files changed, 180 insertions(+), 36 deletions(-)

-- 
2.37.3

