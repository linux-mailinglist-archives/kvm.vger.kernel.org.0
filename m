Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1D5134AC17
	for <lists+kvm@lfdr.de>; Fri, 26 Mar 2021 16:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230114AbhCZP46 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Mar 2021 11:56:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53945 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230236AbhCZP4Z (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Mar 2021 11:56:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616774184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=jbG3A7L/3cWDWl80JmYOD1dysLKY5LW4YSuKOo3eZi0=;
        b=gRi1Z+obTu/lH8z65/PJBI+mftvjJYnPmzBblebAvyAXH32m2uyaWAIb7ivNqNx2vhKEIU
        eqqUa7q3SWoRbt0mS36KzWMSeF+DtMRIjQsoveIfCiwEjfaOwmxmAWpUQ0NmEYEQfi4Y6t
        egWF9R5EQ8glxFeZHfYhL6Cj0TmxIj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-129-mpzjHbavOoyYlUtopG2l6A-1; Fri, 26 Mar 2021 11:56:10 -0400
X-MC-Unique: mpzjHbavOoyYlUtopG2l6A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B265B100E43D;
        Fri, 26 Mar 2021 15:56:01 +0000 (UTC)
Received: from vitty.brq.redhat.com (unknown [10.40.195.148])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 490F45DEAD;
        Fri, 26 Mar 2021 15:55:53 +0000 (UTC)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 0/2] KVM: x86: hyper-v: Fix TSC page update after KVM_SET_CLOCK(0) call
Date:   Fri, 26 Mar 2021 16:55:49 +0100
Message-Id: <20210326155551.17446-1-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I discovered that after KVM_SET_CLOCK(0) TSC page value in the guest can
go through the roof and apparently we have a signedness issue when the
update is performed. Fix the issue and add a selftest.

Vitaly Kuznetsov (2):
  KVM: x86: hyper-v: Forbid unsigned hv_clock->system_time to go
    negative after KVM_REQ_CLOCK_UPDATE
  selftests: kvm: Check that TSC page value is small after
    KVM_SET_CLOCK(0)

 arch/x86/kvm/x86.c                                | 10 +++++++++-
 tools/testing/selftests/kvm/x86_64/hyperv_clock.c | 13 +++++++++++--
 2 files changed, 20 insertions(+), 3 deletions(-)

-- 
2.30.2

