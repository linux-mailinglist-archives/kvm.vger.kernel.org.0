Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE2629B262
	for <lists+kvm@lfdr.de>; Tue, 27 Oct 2020 15:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2899168AbgJ0Oko (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Oct 2020 10:40:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52100 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S368410AbgJ0Ojs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Oct 2020 10:39:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Sender:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:
        To:From:Reply-To:Content-ID:Content-Description;
        bh=riMlzuoiOwtXb9I5iFqaHvZGEHPZQcMx6cCtaeKRBNE=; b=u19M+t1bEapEPy3W0cEebkIA2d
        kaHsPHlZs82IGon33mgFlwwE1ezk+LhT8ZdnHS3N6MsQZVCJl0rSpGPNnjIREn3KqUGCiptVubZxF
        lR5It3MxUkUyFqKhccGg6MSfwrbI0zoi0msSVkQyP1gfeboYOvC2/IbEcO1H068s5ufXIngVkkT0p
        07MnqTR5pDT5qG6shE0eTkT1KB26GVonAYPf8+bYVqb/qsoYvixM+ztl+g9w2r0ver1alwK8yfxOE
        oQhHqZ83FaWRUSuyYVcKoGo/eegaGlwz0cRKhiszMiz3osAQqYfYQ235uSacZPkE4OEu/nsomfeNv
        EyTYWGzw==;
Received: from i7.infradead.org ([2001:8b0:10b:1:21e:67ff:fecb:7a92])
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kXQ8Z-0000bX-Fy; Tue, 27 Oct 2020 14:39:47 +0000
Received: from dwoodhou by i7.infradead.org with local (Exim 4.93 #3 (Red Hat Linux))
        id 1kXQ8Y-002iqc-Dq; Tue, 27 Oct 2020 14:39:46 +0000
From:   David Woodhouse <dwmw2@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: [PATCH v2 0/2] Allow KVM IRQFD to consistently intercept events
Date:   Tue, 27 Oct 2020 14:39:42 +0000
Message-Id: <20201027143944.648769-1-dwmw2@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201026175325.585623-1-dwmw2@infradead.org>
References: <20201026175325.585623-1-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: David Woodhouse <dwmw2@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by merlin.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When posted interrupts are in use, KVM fully bypasses the eventfd and
delivers events directly to the appropriate vCPU. Without posted
interrupts, it still uses the eventfd but it doesn't actually stop
userspace from receiving the events too. This leaves userspace having
to carefully avoid seeing the same events and injecting duplicate
interrupts to the guest.

Fix it by adding a 'priority' mode for exclusive waiters which puts them 
at the head of the list, where they can consume events before the 
non-exclusive waiters are woken.

v2: 
 • Drop [RFC]. This seems to be working nicely, and userspace is a lot
   cleaner without having to mess around with adding/removing the eventfd
   to its poll set. And nobody yelled at me. Yet.
 • Reword commit comments, update comment above __wake_up_common()
 • Rebase to be applied after the (only vaguely related) fix to make
   irqfd actually consume the eventfd counter too.

David Woodhouse (2):
      sched/wait: Add add_wait_queue_priority()
      kvm/eventfd: Use priority waitqueue to catch events before userspace

 include/linux/wait.h | 12 +++++++++++-
 kernel/sched/wait.c  | 17 ++++++++++++++++-
 virt/kvm/eventfd.c   |  6 ++++--



