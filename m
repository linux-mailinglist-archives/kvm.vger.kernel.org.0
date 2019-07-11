Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A49CA66142
	for <lists+kvm@lfdr.de>; Thu, 11 Jul 2019 23:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728434AbfGKVeS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Jul 2019 17:34:18 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42312 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfGKVeS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Jul 2019 17:34:18 -0400
Received: from pd9ef1cb8.dip0.t-ipconnect.de ([217.239.28.184] helo=nanos)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1hlghS-000289-8D; Thu, 11 Jul 2019 23:33:58 +0200
Date:   Thu, 11 Jul 2019 23:33:50 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
cc:     pbonzini@redhat.com, rkrcmar@redhat.com, mingo@redhat.com,
        bp@alien8.de, hpa@zytor.com, dave.hansen@linux.intel.com,
        luto@kernel.org, peterz@infradead.org, kvm@vger.kernel.org,
        x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jan.setjeeilers@oracle.com,
        liran.alon@oracle.com, jwadams@google.com, graf@amazon.de,
        rppt@linux.vnet.ibm.com
Subject: Re: [RFC v2 01/26] mm/x86: Introduce kernel address space
 isolation
In-Reply-To: <1562855138-19507-2-git-send-email-alexandre.chartre@oracle.com>
Message-ID: <alpine.DEB.2.21.1907112321570.1782@nanos.tec.linutronix.de>
References: <1562855138-19507-1-git-send-email-alexandre.chartre@oracle.com> <1562855138-19507-2-git-send-email-alexandre.chartre@oracle.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Jul 2019, Alexandre Chartre wrote:
> +/*
> + * When isolation is active, the address space doesn't necessarily map
> + * the percpu offset value (this_cpu_off) which is used to get pointers
> + * to percpu variables. So functions which can be invoked while isolation
> + * is active shouldn't be getting pointers to percpu variables (i.e. with
> + * get_cpu_var() or this_cpu_ptr()). Instead percpu variable should be
> + * directly read or written to (i.e. with this_cpu_read() or
> + * this_cpu_write()).
> + */
> +
> +int asi_enter(struct asi *asi)
> +{
> +	enum asi_session_state state;
> +	struct asi *current_asi;
> +	struct asi_session *asi_session;
> +
> +	state = this_cpu_read(cpu_asi_session.state);
> +	/*
> +	 * We can re-enter isolation, but only with the same ASI (we don't
> +	 * support nesting isolation). Also, if isolation is still active,
> +	 * then we should be re-entering with the same task.
> +	 */
> +	if (state == ASI_SESSION_STATE_ACTIVE) {
> +		current_asi = this_cpu_read(cpu_asi_session.asi);
> +		if (current_asi != asi) {
> +			WARN_ON(1);
> +			return -EBUSY;
> +		}
> +		WARN_ON(this_cpu_read(cpu_asi_session.task) != current);
> +		return 0;
> +	}
> +
> +	/* isolation is not active so we can safely access the percpu pointer */
> +	asi_session = &get_cpu_var(cpu_asi_session);

get_cpu_var()?? Where is the matching put_cpu_var() ? get_cpu_var()
contains a preempt_disable ...

What's wrong with a simple this_cpu_ptr() here?

> +void asi_exit(struct asi *asi)
> +{
> +	struct asi_session *asi_session;
> +	enum asi_session_state asi_state;
> +	unsigned long original_cr3;
> +
> +	asi_state = this_cpu_read(cpu_asi_session.state);
> +	if (asi_state == ASI_SESSION_STATE_INACTIVE)
> +		return;
> +
> +	/* TODO: Kick sibling hyperthread before switching to kernel cr3 */
> +	original_cr3 = this_cpu_read(cpu_asi_session.original_cr3);
> +	if (original_cr3)

Why would this be 0 if the session is active?

> +		write_cr3(original_cr3);
> +
> +	/* page-table was switched, we can now access the percpu pointer */
> +	asi_session = &get_cpu_var(cpu_asi_session);

See above.

> +	WARN_ON(asi_session->task != current);
> +	asi_session->state = ASI_SESSION_STATE_INACTIVE;
> +	asi_session->asi = NULL;
> +	asi_session->task = NULL;
> +	asi_session->original_cr3 = 0;
> +}

Thanks,

	tglx
