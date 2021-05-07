Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0363765CA
	for <lists+kvm@lfdr.de>; Fri,  7 May 2021 15:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236752AbhEGNLX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 May 2021 09:11:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39209 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236467AbhEGNLV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 May 2021 09:11:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620393021;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=TiiXf73jHYHnfY5U8cMctn8gIsgl068QB1DFfjUXLNk=;
        b=fIOLBCI1ZqMG/ty+eVC6gZpwbPM9dX0TalRunHb0yEqR1i8Sfjys/DB7DjV83ptNeI9zAp
        8XFjB6ELee6OGLWA+8l/k/4TfF1mu8oxpVmZ6ZhOT7/32xuGm07ZL6zHjU1R0+KV3zOv3r
        E/9N64sjcw6+cHdVoH78+pX1gMqPRm0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-GhpPj_GOM6q8t_xXBO6NaA-1; Fri, 07 May 2021 09:10:18 -0400
X-MC-Unique: GhpPj_GOM6q8t_xXBO6NaA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA2021898297;
        Fri,  7 May 2021 13:10:17 +0000 (UTC)
Received: from fuller.cnet (ovpn-112-4.gru2.redhat.com [10.97.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CA83A60918;
        Fri,  7 May 2021 13:10:12 +0000 (UTC)
Received: by fuller.cnet (Postfix, from userid 1000)
        id 9CE6F41887F4; Fri,  7 May 2021 10:10:07 -0300 (-03)
Message-ID: <20210507130609.269153197@redhat.com>
User-Agent: quilt/0.66
Date:   Fri, 07 May 2021 10:06:09 -0300
From:   Marcelo Tosatti <mtosatti@redhat.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: [patch 0/4] VMX: configure posted interrupt descriptor when assigning device
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Configuration of the posted interrupt descriptor is incorrect when devices
are hotplugged to the guest (and vcpus are halted).

See patch 4 for details.

---

v2: rather than using a potentially racy IPI (vs vcpu->cpu switches),
    kick the vcpus when assigning a device and let the blocked per-CPU
    list manipulation happen locally at ->pre_block and ->post_block
    (Sean Christopherson).



