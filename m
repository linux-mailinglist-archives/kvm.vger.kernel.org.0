Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A045754C912
	for <lists+kvm@lfdr.de>; Wed, 15 Jun 2022 14:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349285AbiFOMuB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jun 2022 08:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349084AbiFOMt2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jun 2022 08:49:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E279424F39
        for <kvm@vger.kernel.org>; Wed, 15 Jun 2022 05:49:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655297365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=+iUd3YUEYWkZialMwSNyX/aF1yNVMaYK6rVcTaZaJ7s=;
        b=LcZHbLmvAuMndDNblPySVxylXEHceDtEYO6dHLYXkKXiiehw60iWWK4wQH3GCdXm6DNqD1
        HAI/0lw+UBAr1bgJ1GBEAsEa9NDyn/n9xFUx2Ih3UdqtZByQhXVIQNno3X2pJ5ZT2ot4Ks
        472BPMmFdVnL8J+NNXqDNOFcSSeD6dg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-Q5etuf9nOTeGEImj_GC8yQ-1; Wed, 15 Jun 2022 08:49:19 -0400
X-MC-Unique: Q5etuf9nOTeGEImj_GC8yQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CD62C85A58C;
        Wed, 15 Jun 2022 12:49:18 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.40.194.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E06D240334D;
        Wed, 15 Jun 2022 12:49:16 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v1 0/5] KVM: VMX: Support TscScaling and EnclsExitingBitmap whith eVMCS
Date:   Wed, 15 Jun 2022 14:49:10 +0200
Message-Id: <20220615124915.3068295-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Enlightened VMCS v1 definition was updates to include fields for the
following features:
    - PerfGlobalCtrl
    - EnclsExitingBitmap
    - TSC scaling
    - GuestLbrCtl
    - CET
    - SSP

Add support for EnclsExitingBitmap and TSC scaling to KVM. PerfGlobalCtrl 
doesn't work correctly with Win11, don't enable it yet. SSP, CET and 
GuestLbrCtl are not currently supported by KVM.

RFC part: the change dropping SECONDARY_EXEC_TSC_SCALING from 
EVMCS1_UNSUPPORTED_2NDEXEC likely breaks migration for Hyper-V on KVM: in
case guest which started on a 'fixed' KVM and uses TSC multiplier feature
gets migrated to an older 'unfixed' KVM the feature will become unusable.
Unfortunately, eVMCS's version is still '1' so we probably need a new
CAP in KVM to make TSC scaling an explicit opt-in.

Vitaly Kuznetsov (5):
  x86/hyperv: Fix 'struct hv_enlightened_vmcs' definition
  x86/hyperv: Update 'struct hv_enlightened_vmcs' definition
  KVM: VMX: Define VMCS-to-EVMCS conversion for the new fields
  KVM: nVMX: Support several new fields in eVMCSv1
  KVM: VMX: Support TSC scaling with enlightened VMCS

 arch/x86/include/asm/hyperv-tlfs.h | 19 ++++++++++++++----
 arch/x86/kvm/vmx/evmcs.c           | 26 +++++++++++++++++++++++++
 arch/x86/kvm/vmx/evmcs.h           | 11 ++++-------
 arch/x86/kvm/vmx/nested.c          | 31 ++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+), 11 deletions(-)

-- 
2.35.3

