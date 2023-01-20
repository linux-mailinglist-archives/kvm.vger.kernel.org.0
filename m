Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6C9674B9F
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 06:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjATFDa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Jan 2023 00:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjATFDK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Jan 2023 00:03:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA40CB4E19
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 20:49:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674190132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Ja5jRaAjvA6A1qFpRyfbC8gO+Uf0HTRd1uhGwFrvQrA=;
        b=bYff4QttRxjBiylC5etPDJ9A0EnDp0W92vfQcOz2+lDzR0aozRnrE2FUZcti9sNQtjOSo5
        9+1Ufu1oDlS+6KNpTwW1WmxnWesOuQxEaEM6705V/lcbgIYxzdPAFDZYAZePoCzagqlyt+
        eIw2yEHutBM26CJRlusQD+E4hUR2eD8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-297-IlHSVlbQP0ecRt23RKQ8VQ-1; Thu, 19 Jan 2023 23:48:50 -0500
X-MC-Unique: IlHSVlbQP0ecRt23RKQ8VQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 131BE85CBE0;
        Fri, 20 Jan 2023 04:48:50 +0000 (UTC)
Received: from tpad.localdomain (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DC7EE40C2064;
        Fri, 20 Jan 2023 04:48:49 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
        id ED2F340517E51; Thu, 19 Jan 2023 22:15:17 -0300 (-03)
Message-ID: <20230120011116.134437211@redhat.com>
User-Agent: quilt/0.67
Date:   Thu, 19 Jan 2023 22:11:16 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH 0/2] read kvmclock from guest memory if !correct_tsc_shift
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Before kernel commit 78db6a5037965429c04d708281f35a6e5562d31b,
kvm_guest_time_update() would use vcpu->virtual_tsc_khz to calculate
tsc_shift value in the vcpus pvclock structure written to guest memory.

For those kernels, if vcpu->virtual_tsc_khz != tsc_khz (which can be the
case when guest state is restored via migration, or if tsc-khz option is
passed to QEMU), and TSC scaling is not enabled (which happens if the
difference between the frequency requested via KVM_SET_TSC_KHZ and the
host TSC KHZ is smaller than 250ppm), then there can be a difference
between what KVM_GET_CLOCK would return and what the guest reads as
kvmclock value.

The effect is that the guest sees a jump in kvmclock value
(either forwards or backwards) in such case.

To fix incoming migration from pre-78db6a5037965 hosts,
read kvmclock value from guest memory.

Unless the KVM_CLOCK_CORRECT_TSC_SHIFT bit indicates
that the value retrieved by KVM_GET_CLOCK on the source
is safe to be used.


