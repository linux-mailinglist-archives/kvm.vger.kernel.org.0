Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68EF737B2DC
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 02:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhELACl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 20:02:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33640 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhELACj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 20:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620777691;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=d+EGQkKt1rrT/HrhGCCYpwxz8yUbSC0lVGSF53kSZ5I=;
        b=H/lx1utMR85Pf7LMkpOi0AVXIWucw9XXLhelM44D6bz6t2LEMS0HTmrjZKrTVTALcfxryV
        SRHfY4DRW+ymN4aUVZpORRLZdtYXG+b/TwsJ0xQPn3nfvkMRscZejxGuOpvuF11uRAVfPg
        07TcT40yarDNg+m5Z+kkfNX4rVXTPEg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-301-Y0JAqxehOIKFVKjpAi2Opw-1; Tue, 11 May 2021 20:01:30 -0400
X-MC-Unique: Y0JAqxehOIKFVKjpAi2Opw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2F094801B16;
        Wed, 12 May 2021 00:01:29 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-2.gru2.redhat.com [10.97.112.2])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3135D39A71;
        Wed, 12 May 2021 00:01:25 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 852B1406ED74; Tue, 11 May 2021 21:01:20 -0300 (-03)
Message-ID: <20210511235738.333950860@redhat.com>
User-Agent: quilt/0.66
Date:   Tue, 11 May 2021 20:57:38 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Peter Xu <peterx@redhat.com>
Subject: [patch 0/4] VMX: configure posted interrupt descriptor when assigning device (v4)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Configuration of the posted interrupt descriptor is incorrect when devices
are hotplugged to the guest (and vcpus are halted).

See patch 4 for details.

---

v4: remove NULL assignments from kvm_x86_ops (Peter Xu)
    check for return value of ->start_assignment directly (Peter Xu)

v3: improved comments (Sean)
    use kvm_vcpu_wake_up (Sean)
    drop device_count from start_assignment function (Peter Xu)

v2: rather than using a potentially racy IPI (vs vcpu->cpu switches),
    kick the vcpus when assigning a device and let the blocked per-CPU
    list manipulation happen locally at ->pre_block and ->post_block
    (Sean Christopherson).


