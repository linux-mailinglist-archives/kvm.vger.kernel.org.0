Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47B2718904
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 13:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbfEIL30 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 07:29:26 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34633 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbfEIL30 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 07:29:26 -0400
Received: by mail-pf1-f195.google.com with SMTP id n19so1187653pfa.1;
        Thu, 09 May 2019 04:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=AQRCsjoCj+KrwazrHzM9n93IVCjTIj3cFygvptfqjiM=;
        b=GiAanJqiIpWrs6LuqUKeJ/IgQylEYFq0xa7F/AvprcC0nQmevkQdUooOdbshL07mbi
         eiW6jkQej8ANOw8/AsgYBefUJaDXe5aEU5J32Ltn3qL3BaksrPAAtbvTA1d+LOmwRQH/
         zqOEgp6FukKJai5Hd5iGASpk9D2Yay8DIkkhXZlJAE7K48JBw7PeeKVtNXcqpH1T3EM9
         c3gFwb90SKOVxRQ4sndM6rXmNe2Vt8yud5PGigRWvlNKudq1wrAuzdb+IgjIOL5/pcef
         mcqCf2Bb+v0GDDEy67cRNO8YA2oQSdCeKznryQo4J5gqqWb19vqE6pdj3tYhBTagO4sR
         fwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=AQRCsjoCj+KrwazrHzM9n93IVCjTIj3cFygvptfqjiM=;
        b=AWm/DiN0m6Pq2DDE8GPvYdrVtnC147mk/S/quWegrDJSBupPolqubm1hqlDqQdCmwa
         cPgdwVam6cireCzig9XwTc7a0ExthkBKay12mLkv07DnH9jxzsA6GcVstwzateTGSXkb
         cYT/hymCp/3pcpFSvY5iX7xVacuytBm3EaOdouIjFS6QbIG6EWOwoJ/MQiDCnEl7EpXj
         T19faSc1xF5MotPX3i260BHrkCFsn5tAUvwc9A2x1eVI+cNzBEnmd716iZgN8z4IEx/8
         lPsBtNMK7TNtro4EwW9OZ4Y7wjwiHIE17LXaAyR1sQYJ99djTYZJCOuzObF3AqC4yh10
         pwrQ==
X-Gm-Message-State: APjAAAV1IjuSW1Ncp5fSIt2h7bMGmSrY4WnmQHHJOGibxMsRnlrfCmg+
        oFeo9KzeIHXi28a62WC8yXeqdsse
X-Google-Smtp-Source: APXvYqyM9c/bKuPq/jsNLoE14zoNM3/4FTquvtrHMMTZTIJmHaDtROGQ084L8WoWMtlXYWCSGl/k/w==
X-Received: by 2002:a65:554d:: with SMTP id t13mr4638517pgr.171.1557401365682;
        Thu, 09 May 2019 04:29:25 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.123])
        by smtp.googlemail.com with ESMTPSA id j10sm2762002pfa.37.2019.05.09.04.29.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 09 May 2019 04:29:25 -0700 (PDT)
From:   Wanpeng Li <kernellwp@gmail.com>
X-Google-Original-From: Wanpeng Li <wanpengli@tencent.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 0/3] KVM: LAPIC: Optimize timer latency further
Date:   Thu,  9 May 2019 19:29:18 +0800
Message-Id: <1557401361-3828-1-git-send-email-wanpengli@tencent.com>
X-Mailer: git-send-email 2.7.4
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Advance lapic timer tries to hidden the hypervisor overhead between host 
timer fires and the guest awares the timer is fired. However, it just hidden 
the time between apic_timer_fn/handle_preemption_timer -> wait_lapic_expire, 
instead of the real position of vmentry which is mentioned in the orignial 
commit d0659d946be0 ("KVM: x86: add option to advance tscdeadline hrtimer 
expiration"). There is 700+ cpu cycles between the end of wait_lapic_expire 
and before world switch on my haswell desktop, it will be 2400+ cycles if 
vmentry_l1d_flush is tuned to always. 

This patchset tries to narrow the last gap, it measures the time between 
the end of wait_lapic_expire and before world switch, we take this 
time into consideration when busy waiting, otherwise, the guest still 
awares the latency between wait_lapic_expire and world switch, we also 
consider this when adaptively tuning the timer advancement. The patch 
can reduce 50% latency (~1600+ cycles to ~800+ cycles on a haswell 
desktop) for kvm-unit-tests/tscdeadline_latency when testing busy waits.

Wanpeng Li (3):
  KVM: LAPIC: Extract adaptive tune timer advancement logic
  KVM: LAPIC: Fix lapic_timer_advance_ns parameter overflow
  KVM: LAPIC: Optimize timer latency further

 arch/x86/kvm/lapic.c   | 78 ++++++++++++++++++++++++++++++++++----------------
 arch/x86/kvm/lapic.h   |  8 ++++++
 arch/x86/kvm/vmx/vmx.c |  2 ++
 arch/x86/kvm/x86.c     |  2 +-
 4 files changed, 64 insertions(+), 26 deletions(-)

-- 
2.7.4

