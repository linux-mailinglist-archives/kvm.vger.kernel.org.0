Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 172381CBA1
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 17:17:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbfENPQ5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 11:16:57 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:4725 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfENPQ4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 May 2019 11:16:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1557847016; x=1589383016;
  h=from:to:subject:date:message-id:in-reply-to:references;
  bh=52wCeBOwauHSQlDrGetPA9MN4QQCshjnt1eWacd/EZk=;
  b=r1W6ukYYLs0xIUS53B2N35NqaGhy9z+doxVSEYL13cuPRIvjTHfLm/KK
   96+FBt6iuk7LGIieFSnLgWYmBYTUOot1zcTRAR8UI07qDxl7aVihNME9C
   8e3acta5Y4VxptSSk/5bHqAHNHERVyZhW6NtkvLnesHQ172xZ1SVzDDwD
   o=;
X-IronPort-AV: E=Sophos;i="5.60,469,1549929600"; 
   d="scan'208";a="674278996"
Received: from sea3-co-svc-lb6-vlan3.sea.amazon.com (HELO email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com) ([10.47.22.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 14 May 2019 15:16:50 +0000
Received: from uf8b156e456a5587c9af4.ant.amazon.com (pdx2-ws-svc-lb17-vlan2.amazon.com [10.247.140.66])
        by email-inbound-relay-2b-4ff6265a.us-west-2.amazon.com (8.14.7/8.14.7) with ESMTP id x4EFGmBv009206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO);
        Tue, 14 May 2019 15:16:49 GMT
Received: from uf8b156e456a5587c9af4.ant.amazon.com (localhost [127.0.0.1])
        by uf8b156e456a5587c9af4.ant.amazon.com (8.15.2/8.15.2/Debian-3) with ESMTP id x4EFGl86027925;
        Tue, 14 May 2019 17:16:47 +0200
Received: (from sironi@localhost)
        by uf8b156e456a5587c9af4.ant.amazon.com (8.15.2/8.15.2/Submit) id x4EFGkaB027921;
        Tue, 14 May 2019 17:16:46 +0200
From:   Filippo Sironi <sironi@amazon.de>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, boris.ostrovsky@oracle.com,
        cohuck@redhat.com, konrad.wilk@oracle.com,
        xen-devel@lists.xenproject.org, vasu.srinivasan@oracle.com
Subject: KVM: Start populating /sys/hypervisor with KVM entries
Date:   Tue, 14 May 2019 17:16:40 +0200
Message-Id: <1557847002-23519-1-git-send-email-sironi@amazon.de>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1539078879-4372-1-git-send-email-sironi@amazon.de>
References: <1539078879-4372-1-git-send-email-sironi@amazon.de>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Long-time Xen HVM and Xen PV users are missing /sys/hypervisor entries when
moving to KVM.  One report is about getting the VM UUID.  The VM UUID can
already be retrieved using /sys/devices/virtual/dmi/id/product_uuid.  This has
two downsides: (1) it requires root privileges and (2) it is only available on
KVM and Xen HVM.

By exposing /sys/hypervisor/uuid when running on KVM as well, we provide an
interface that's functional for KVM, Xen HVM, and Xen PV.  Let's do so by
providing arch-specific hooks so that different architectures can implement the
hooks in different ways.

Further work can be done by consolidating the creation of the basic
/sys/hypervisor across hypervisors.

Filippo Sironi (2):
      KVM: Start populating /sys/hypervisor with KVM entries
      KVM: x86: Implement the arch-specific hook to report the VM UUID

