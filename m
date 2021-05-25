Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F655390325
	for <lists+kvm@lfdr.de>; Tue, 25 May 2021 15:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233418AbhEYN4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 May 2021 09:56:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:21578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233435AbhEYNzs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 25 May 2021 09:55:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621950858;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=/IYEcYC52GXj+7gmYdt33V4lbsYB9gOYvtVhg/ECBBY=;
        b=JXOypfOVgUeppDpAwdtNUrjJXIjm1q+LyrTtfrHT0WyFMZJ0aAz8MvN8D1tkLtqVY8ki4q
        1+z3dltUDuUYlVFzjfVGpBuOK6gxv/QHZp1RPdkZT2l25TR8shs+xZZjCNNz3eN0fUta+E
        MfuYmDu4Cmj0qRGWXXFUUX/6IuYWpBc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-267-3EphxQC_PCGWT_mMvQw8hw-1; Tue, 25 May 2021 09:54:15 -0400
X-MC-Unique: 3EphxQC_PCGWT_mMvQw8hw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 567B7107ACF2;
        Tue, 25 May 2021 13:54:14 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B9E05D9C0;
        Tue, 25 May 2021 13:54:07 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id AE8FE4172ED4; Tue, 25 May 2021 10:44:35 -0300 (-03)
Message-ID: <20210525134115.135966361@redhat.com>
User-Agent: quilt/0.66
Date:   Tue, 25 May 2021 10:41:15 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: [patch 0/3] VMX: configure posted interrupt descriptor when assigning device (v5)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Configuration of the posted interrupt descriptor is incorrect when devices
are hotplugged to the guest (and vcpus are halted).

See patch 3 for details.

---

v5: use KVM_REQ_UNBLOCK instead of kvm_check_block callback (Paolo / Peter Xu)

v4: remove NULL assignments from kvm_x86_ops (Peter Xu)
    check for return value of ->start_assignment directly (Peter Xu)

v3: improved comments (Sean)
    use kvm_vcpu_wake_up (Sean)
    drop device_count from start_assignment function (Peter Xu)

v2: rather than using a potentially racy IPI (vs vcpu->cpu switches),
    kick the vcpus when assigning a device and let the blocked per-CPU
    list manipulation happen locally at ->pre_block and ->post_block
    (Sean Christopherson).



