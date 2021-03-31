Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A708834E047
	for <lists+kvm@lfdr.de>; Tue, 30 Mar 2021 06:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhC3Emm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Mar 2021 00:42:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbhC3EmN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Mar 2021 00:42:13 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CF8C0613D8
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 21:42:12 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id c7so13671388qka.6
        for <kvm@vger.kernel.org>; Mon, 29 Mar 2021 21:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sfHXJbbxb6p3TEWQ8tzYZSEzCbGd5MPRFw754wGnO9M=;
        b=TTKZd5jbX64Rbx+dgGmFRdeRnmF8AD7bOmTLS2z53CveoKd38s4zHorjlWhT7JWttc
         W/4AYxcvnetv6zEBZYnCLLwDw/n0+NMSmznlECeNN386pQMDpBp4tAkUmypuy690YhbX
         MUJZ5LuwMKBNRdfciczq43ArGC3OCKUJ3QO4oD3Y2cx4JDMR46cTE+wD46kDhx1s1eQi
         BCVe4G/w1rxiIqWKYuh9XRd2X4XFgxFOga84xCkanZwHE8wax3F1kzF+jGb1H1j6pCKN
         N/nXSaOUfTOeOvgZgsdJwf4qCgPRhbqT7Cz7dmTglQ23YrQf8/aRU/gRgyKet03i1zWN
         AnpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sfHXJbbxb6p3TEWQ8tzYZSEzCbGd5MPRFw754wGnO9M=;
        b=cBxtne4XmjhFpEbMc6vwWfq7WjFzMhNuozIn0NhiGJqNDNZb+NQV6tIaSFWh7HCPFu
         5WuenP3IJiJKmdkPOG5Rolr73/BldFGCD9LD5JyDJbzKsNHJT2uwnYDzO8AF6ctC2yvd
         nW1hk30J1l4vizXRs370+SwqmgAH7xwxXHnbhUvcbVdfSbTqYno9ojAskTyIebiRh460
         e5ZKr+UIlhfkYCaUSz1C/LypExwbono2a+4DTbRbtKITvZdVkbzWOoUA/W1qYEaMlU+/
         q8BRcxhsjkdEc0tBDnzw/XaGvAL2Cmo1/JORwpiYjIA0ambOhEyTgZzIo/ibZI4wj6Ll
         Mg1A==
X-Gm-Message-State: AOAM530Rc8cxLT0L76FVg0xUG38nwwCQgqsU4INVuhuEzOQv9vR6eost
        11UnM+YO6KzKstbXTj/hrZvbLlvHRFpK
X-Google-Smtp-Source: ABdhPJylRYJnJTOM7DmR750oi8GE7FSs9W4+AYIINo16KxJX6XT8zImZVHRhJpr5IS6NAXVIlTlHDO/mEE/V
X-Received: from vipinsh.kir.corp.google.com ([2620:0:1008:10:8048:6a12:bd4f:a453])
 (user=vipinsh job=sendgmr) by 2002:a05:6214:906:: with SMTP id
 dj6mr22407836qvb.38.1617079331667; Mon, 29 Mar 2021 21:42:11 -0700 (PDT)
Date:   Mon, 29 Mar 2021 21:42:03 -0700
Message-Id: <20210330044206.2864329-1-vipinsh@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH v4 0/3] cgroup: New misc cgroup controller
From:   Vipin Sharma <vipinsh@google.com>
To:     tj@kernel.org, mkoutny@suse.com, jacob.jun.pan@intel.com,
        rdunlap@infradead.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com,
        pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com,
        borntraeger@de.ibm.com
Cc:     corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com,
        wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
        gingell@google.com, rientjes@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vipin Sharma <vipinsh@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

This patch series is creating a new misc cgroup controller for limiting
and tracking of resources which are not abstract like other cgroup
controllers.

This controller was initially proposed as encryption_id but after the
feedbacks and use cases for other resources, it is now changed to misc
cgroup.
https://lore.kernel.org/lkml/20210108012846.4134815-2-vipinsh@google.com/

Most of the cloud infrastructure use cgroups for knowing the host state,
track the resources usage, enforce limits on them, etc. They use this
info to optimize work allocation in the fleet and make sure no rogue job
consumes more than it needs and starves others.

There are resources on a system which are not abstract enough like other
cgroup controllers and are available in a limited quantity on a host.

One of them is Secure Encrypted Virtualization (SEV) ASID on AMD CPU.
SEV ASIDs are used for creating encrypted VMs. SEV is mostly be used by
the cloud providers for providing confidential VMs. Since SEV ASIDs are
limited, there is a need to schedule encrypted VMs in a cloud
infrastructure based on SEV ASIDs availability and also to limit its
usage.

There are similar requirements for other resource types like TDX keys,
IOASIDs and SEID.

Adding these resources to a cgroup controller is a natural choice with
least amount of friction. Cgroup itself says it is a mechanism to
distribute system resources along the hierarchy in a controlled
mechanism and configurable manner. Most of the resources in cgroups are
abstracted enough but there are still some resources which are not
abstract but have limited availability or have specific use cases.

Misc controller is a generic controller which can be used by these
kinds of resources.

One suggestion was to use BPF for this purpose, however, there are
couple of things which might not be addressed with BPF:
1. Which controller to use in v1 case? These are not abstract resources
   so in v1 where each controller have their own hierarchy it might not
   be easy to identify the best controller to use for BPF.

2. Abstracting out a single BPF program which can help with all of the
   resources types might not be possible, because resources we are
   working with are not similar and abstract enough, for example network
   packets, and there will be different places in the source code to use
   these resources.

A new cgroup controller tends to give much easier and well integrated
solution when it comes to scheduling and limiting a resource with
existing tools in a cloud infrastructure.

Changes in RFC v4:
1. Misc controller patch is split into two patches. One for generic misc
   controller and second for adding SEV and SEV-ES resource.
2. Using READ_ONCE and WRITE_ONCE for variable accesses.
3. Updated documentation.
4. Changed EXPORT_SYMBOL to EXPORT_SYMBOL_GPL.
5. Included cgroup header in misc_cgroup.h.
6. misc_cg_reduce_charge changed to misc_cg_cancel_charge.
7. misc_cg set to NULL after uncharge.
8. Added WARN_ON if misc_cg not NULL before charging in SEV/SEV-ES.

Changes in RFC v3:
1. Changed implementation to support 64 bit counters.
2. Print kernel logs only once per resource per cgroup.
3. Capacity can be set less than the current usage.

Changes in RFC v2:
1. Documentation fixes.
2. Added kernel log messages.
3. Changed charge API to treat misc_cg as input parameter.
4. Added helper APIs to get and release references on the cgroup.

[1] https://lore.kernel.org/lkml/20210218195549.1696769-1-vipinsh@google.com
[2] https://lore.kernel.org/lkml/20210302081705.1990283-1-vipinsh@google.com/
[3] https://lore.kernel.org/lkml/20210304231946.2766648-1-vipinsh@google.com/

Vipin Sharma (3):
  cgroup: Add misc cgroup controller
  cgroup: Miscellaneous cgroup documentation.
  svm/sev: Register SEV and SEV-ES ASIDs to the misc controller

 Documentation/admin-guide/cgroup-v1/index.rst |   1 +
 Documentation/admin-guide/cgroup-v1/misc.rst  |   4 +
 Documentation/admin-guide/cgroup-v2.rst       |  73 +++-
 arch/x86/kvm/svm/sev.c                        |  70 ++-
 arch/x86/kvm/svm/svm.h                        |   1 +
 include/linux/cgroup_subsys.h                 |   4 +
 include/linux/misc_cgroup.h                   | 132 ++++++
 init/Kconfig                                  |  14 +
 kernel/cgroup/Makefile                        |   1 +
 kernel/cgroup/misc.c                          | 407 ++++++++++++++++++
 10 files changed, 695 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/admin-guide/cgroup-v1/misc.rst
 create mode 100644 include/linux/misc_cgroup.h
 create mode 100644 kernel/cgroup/misc.c

-- 
2.31.0.291.g576ba9dcdaf-goog

