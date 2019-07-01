Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670E735A3E
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2019 12:09:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727272AbfFEKJ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Jun 2019 06:09:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40292 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfFEKJ3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Jun 2019 06:09:29 -0400
Received: by mail-pl1-f195.google.com with SMTP id g69so9521965plb.7;
        Wed, 05 Jun 2019 03:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=SwRGVXh44lKdmYRKWlurBpR81QsAEQH5O7el/CbJ7G8=;
        b=njWElEr4BHGD2lnCKdHnj757ZmfN12mILR99wsFjP0ZKMSfTT4WCiGXjCnSrw7K8NJ
         0jnOJZRHYaY4uop9++qKAp+kri+uxrInEKYXW08aJibOYJdIQYIIaPNhdbCGY3VyzEtB
         mZqU3V2TEi33uDBOBazlSANNknDhIRO2+YdFiqSmEyTZrYFCVycEZmyPv6LlYK799PaI
         ljG+tP9mjUvDzpIrdBn3Bb8/GLwLXO3lgi6GZpPiGEBsFFrJ6s0RBGPJ+2v97lDoHPVP
         jW8+hIMGQDvMiQTvT7xiYNNucXwvL0y1IMicM8vv8COjA1wgwhd8Vfnw2KJBkel8Ft6T
         776A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SwRGVXh44lKdmYRKWlurBpR81QsAEQH5O7el/CbJ7G8=;
        b=bdsD7+hQReBhX3bqeGmwzHKdPicTUo/iMMGx1nNLbCYMDbPrOHj+hgHWy8+oPQ47/W
         DlPk8mzxYysphdL8sOF0eWVh8N/v5vfqETxoYX1Hvnl8UGE7tscXpBVMyIcW/w3UXG5R
         LI1+4yu6sxfqU60mm3HYKZHK8gQQQW0SK9clodeXMnuwp0D7VQ1MG8U3xeF/TTjSsO7k
         CmXPiEey2W24s03qjHCXWg7HN2vwEOyPbSJAAU+a35DZ5kAnMe+E9kUhVwqDmA/V9wG6
         ZCoRnV4U5EcOXKpBvPXqY8jszl7eFIe5hibw7ymXaBM6NsqCGxX+HjQ7SsXQIcG66CqB
         v+Ew==
X-Gm-Message-State: APjAAAX/HQb5onqnzeZP6gDeivPn8OXxQxie1EGzInanOLJIG8sV0zhh
        bwpts41zndbAWVlOhGSJoG4euRxf
X-Google-Smtp-Source: APXvYqztn5ikTIqqw7ZL0V712MGDIykZCR8ucmjQJ3+pShyCAYhjQjR7GzdiGqh3w5c9WZOWck0xgg==
X-Received: by 2002:a17:902:30a3:: with SMTP id v32mr42954648plb.6.1559729368552;
        Wed, 05 Jun 2019 03:09:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id v9sm19030010pfm.34.2019.06.05.03.09.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 05 Jun 2019 03:09:27 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 0/3] KVM: LAPIC: Implement Exitless Timer
Date:   Wed,  5 Jun 2019 18:09:08 +0800
Message-Id: <1559729351-20244-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dedicated instances are currently disturbed by unnecessary jitter due 
to the emulated lapic timers fire on the same pCPUs which vCPUs resident.
There is no hardware virtual timer on Intel for guest like ARM. Both 
programming timer in guest and the emulated timer fires incur vmexits.
This patchset tries to avoid vmexit which is incurred by the emulated 
timer fires in dedicated instance scenario. 

When nohz_full is enabled in dedicated instances scenario, the unpinned 
timer will be moved to the nearest busy housekeepers after commit 444969223c8
("sched/nohz: Fix affine unpinned timers mess"). However, KVM always makes 
lapic timer pinned to the pCPU which vCPU residents, the reason is explained 
by commit 61abdbe0 (kvm: x86: make lapic hrtimer pinned). Actually, these 
emulated timers can be offload to the housekeeping cpus since APICv 
is really common in recent years. The guest timer interrupt is injected by 
posted-interrupt which is delivered by housekeeping cpu once the emulated 
timer fires. 

This patchset introduces a new kvm module parameter, it is false by default.
The host admin can enable it after fine tuned, e.g. dedicated instances 
scenario w/ nohz_full cover the pCPUs which vCPUs resident, several pCPUs 
surplus for housekeeping, disable mwait/hlt/pause vmexits to occupy the 
pCPUs, fortunately preemption timer is disabled after mwait is exposed 
to guest which makes emulated timer offload can be possible. 
3%~5% redis performance benefit can be observed on Skylake server.

Wanpeng Li (3):
  KVM: LAPIC: Make lapic timer unpinned when timer is injected by posted-interrupt
  KVM: LAPIC: lapic timer is injected by posted interrupt
  KVM: LAPIC: Ignore timer migration when lapic timer is injected by
    posted-interrupt

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            | 45 +++++++++++++++++++++++++++++++++++------
 arch/x86/kvm/svm.c              |  5 +++++
 arch/x86/kvm/vmx/vmx.c          |  9 +++++++++
 4 files changed, 54 insertions(+), 6 deletions(-)

-- 
2.7.4

