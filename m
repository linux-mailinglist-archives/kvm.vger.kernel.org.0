Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BF227E020
	for <lists+kvm@lfdr.de>; Thu,  1 Aug 2019 18:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732102AbfHAQY4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Aug 2019 12:24:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39404 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732082AbfHAQYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Aug 2019 12:24:55 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AAF20A9DA1;
        Thu,  1 Aug 2019 16:24:55 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.136])
        by smtp.corp.redhat.com (Postfix) with SMTP id 62483608C2;
        Thu,  1 Aug 2019 16:24:52 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu,  1 Aug 2019 18:24:55 +0200 (CEST)
Date:   Thu, 1 Aug 2019 18:24:51 +0200
From:   Oleg Nesterov <oleg@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Siewior <bigeasy@linutronix.de>,
        Anna-Maria Gleixner <anna-maria@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Julia Cartwright <julia@ni.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, kvm@vger.kernel.org,
        Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>
Subject: Re: [patch 2/5] x86/kvm: Handle task_work on VMENTER/EXIT
Message-ID: <20190801162451.GE31538@redhat.com>
References: <20190801143250.370326052@linutronix.de>
 <20190801143657.887648487@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190801143657.887648487@linutronix.de>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.30]); Thu, 01 Aug 2019 16:24:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 08/01, Thomas Gleixner wrote:
>
> @@ -8172,6 +8174,10 @@ static int vcpu_run(struct kvm_vcpu *vcp
>  			++vcpu->stat.signal_exits;
>  			break;
>  		}
> +
> +		if (notify_resume_pending())
> +			tracehook_handle_notify_resume();

shouldn't you drop kvm->srcu before tracehook_handle_notify_resume() ?

I don't understand this code at all, but vcpu_run() does this even before
cond_resched().

Oleg.

