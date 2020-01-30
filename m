Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E156C14E068
	for <lists+kvm@lfdr.de>; Thu, 30 Jan 2020 19:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727695AbgA3SCC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jan 2020 13:02:02 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54613 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727686AbgA3SCC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jan 2020 13:02:02 -0500
Received: by mail-wm1-f68.google.com with SMTP id g1so4791567wmh.4;
        Thu, 30 Jan 2020 10:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id;
        bh=SYieBB/2kuVcsp1riYZ+n5BLf07jGwls7F2V1rzJ3UY=;
        b=VHjvC2MDwl9sh5TlMQ3R5zp7aZFDa04ymIQepWEvPED2hYwGw7b3vcuccjQUp8lBqO
         x+cdljjnRAdkNRpmK+lCja97sGD21n4hd4ykycwRlQUMkOmLvro7sy90mGIRtsC5IFHG
         Sq7jBV/CVeY1HM3mvflTltaTMk6JroxMPeod8/ur1g3sZVL5vCBqzBP/lXHzjPiEv45u
         KT54Vp2rvIGOcnlaQpcwTLgJESDbjMr6EEyYyAsMLCeGl7gTmlS9D5h1a8JwzaIyTyVP
         iUbZu6Se09ZsuCJQCWzZfDtNLsC0Nns2u0DtoZzyryz+tJhSC6yXT9Q2A0Xka3SelWQX
         e1yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id;
        bh=SYieBB/2kuVcsp1riYZ+n5BLf07jGwls7F2V1rzJ3UY=;
        b=D3rnpkegRRqT5q7tBEtQU7K+dRGP3iQVCMLKdzSt7tOl7wEWemDg4NBvZfsoaz3BBM
         eyy4lxuzPKc/E88btZb82shkULu500QDoRE7lXvK63iZGUE0FqWNlLTZtuu8Tj5WXJor
         nF9UY07Pe26qTTKWO/T36eNzUR5NjroVUheqg2vlPAXu5ejnNmRu0uz2vhyZQ8XQjLtU
         rj2BGugzcb8hR0NTyOA1gl8dAXtoGTfLSkdV8U0etLW7Dc5pZvj5M3xXCrBMKYU3DiWf
         BIquK5Vm1N3g/nyQMcgNNVR6U/aDCBQi3lAN3+TNO+UZkDeUm6dsKWanuuoHOyimeOKm
         nXNQ==
X-Gm-Message-State: APjAAAW7IO5KPeA96bixCWLeDNDImOyUClDyULXygz+NKa/lWb/CPvx8
        +j3xlYpf7Uf2fVDovTjlTP/+E6vPsPE=
X-Google-Smtp-Source: APXvYqwk+4/JCgeGyjZ/mpDE7Vgne7VBWyta/l9CF3RrDc5EnDtWTmoFxk0VhAYlbmyR7r+tGxyimw==
X-Received: by 2002:a7b:cbd6:: with SMTP id n22mr7161001wmi.118.1580407320372;
        Thu, 30 Jan 2020 10:02:00 -0800 (PST)
Received: from 640k.localdomain.com ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w19sm6956878wmc.22.2020.01.30.10.01.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 Jan 2020 10:01:59 -0800 (PST)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [FYI PATCH 0/5] Missing TLB flushes
Date:   Thu, 30 Jan 2020 19:01:51 +0100
Message-Id: <1580407316-11391-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.3.1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

The KVM hypervisor may provide a guest with ability to defer remote TLB
flush when the remote VCPU is not running. When this feature is used,
the TLB flush will happen only when the remote VPCU is scheduled to run
again. This will avoid unnecessary (and expensive) IPIs.

Under certain circumstances, when a guest initiates such deferred action,
the hypervisor may miss the request. It is also possible that the guest
may mistakenly assume that it has already marked remote VCPU as needing
a flush when in fact that request had already been processed by the
hypervisor. In both cases this will result in an invalid translation
being present in a vCPU, potentially allowing accesses to memory locations
in that guest's address space that should not be accessible.

Note that only intra-guest memory is vulnerable.

The attached patches address both of these problems:
1. The first patch makes sure the hypervisor doesn't accidentally clear
guest's remote flush request
2. The rest of the patches prevent the race between hypervisor
acknowledging a remote flush request and guest issuing a new one.

Boris Ostrovsky (5):
  x86/kvm: Be careful not to clear KVM_VCPU_FLUSH_TLB bit
  x86/kvm: Introduce kvm_(un)map_gfn()
  x86/kvm: Cache gfn to pfn translation
  x86/KVM: Make sure KVM_VCPU_FLUSH_TLB flag is not missed
  x86/KVM: Clean up host's steal time structure

 arch/x86/include/asm/kvm_host.h |   4 +-
 arch/x86/kvm/x86.c              |  69 +++++++++++++++---------
 include/linux/kvm_host.h        |   5 ++
 include/linux/kvm_types.h       |   9 +++-
 virt/kvm/kvm_main.c             | 113 ++++++++++++++++++++++++++++++++++------
 5 files changed, 154 insertions(+), 46 deletions(-)

-- 
1.8.3.1

