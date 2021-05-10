Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9559C379688
	for <lists+kvm@lfdr.de>; Mon, 10 May 2021 19:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233296AbhEJRzu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 May 2021 13:55:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233238AbhEJRzg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 10 May 2021 13:55:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620669271;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=zGAx3lT0Af5JXR+dtPqi2eB2KHwQq7HfmXkTkY8h0d0=;
        b=A5AdZePpjo5EivEbH9G64vWbtr1ym3yoskRL0+sutSJqFTaQzi3kGbtBKAL0SqN+ZoQizS
        rEGSMx+svURh04F9PJfNLo7fmn1lKe9SUEWF87KB5ZE8pOVTZT2zHWwfnACxjbW0+ZHu0k
        /I8Si02VICiF4ZYClX8gpmk4r8omgpA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-199-8Gj3r4FEMOONqDok0TUXKg-1; Mon, 10 May 2021 13:54:29 -0400
X-MC-Unique: 8Gj3r4FEMOONqDok0TUXKg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 82AEA8014D8;
        Mon, 10 May 2021 17:54:28 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-8.gru2.redhat.com [10.97.112.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C6305C1BB;
        Mon, 10 May 2021 17:54:20 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 73DAE406E9D9; Mon, 10 May 2021 14:54:15 -0300 (-03)
Message-ID: <20210510172646.930550753@redhat.com>
User-Agent: quilt/0.66
Date:   Mon, 10 May 2021 14:26:46 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: [patch 0/4] VMX: configure posted interrupt descriptor when assigning device (v3)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Configuration of the posted interrupt descriptor is incorrect when devices
are hotplugged to the guest (and vcpus are halted).

See patch 4 for details.

---

v3: improved comments (Sean)
    use kvm_vcpu_wake_up (Sean)
    drop device_count from start_assignment function (Peter Xu)

v2: rather than using a potentially racy IPI (vs vcpu->cpu switches),
    kick the vcpus when assigning a device and let the blocked per-CPU
    list manipulation happen locally at ->pre_block and ->post_block
    (Sean Christopherson).


