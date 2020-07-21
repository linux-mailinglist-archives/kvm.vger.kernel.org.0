Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C5BE228B89
	for <lists+kvm@lfdr.de>; Tue, 21 Jul 2020 23:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729225AbgGUVmg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jul 2020 17:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726555AbgGUVmg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Jul 2020 17:42:36 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4231420709;
        Tue, 21 Jul 2020 21:42:35 +0000 (UTC)
Date:   Tue, 21 Jul 2020 17:42:33 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 6/7] KVM: x86: Use common definition for
 kvm_nested_vmexit tracepoint
Message-ID: <20200721174233.411fba7b@oasis.local.home>
In-Reply-To: <20200721193130.GH22083@linux.intel.com>
References: <20200718063854.16017-1-sean.j.christopherson@intel.com>
        <20200718063854.16017-7-sean.j.christopherson@intel.com>
        <87365mqgcg.fsf@vitty.brq.redhat.com>
        <20200721002717.GC20375@linux.intel.com>
        <87imehotp1.fsf@vitty.brq.redhat.com>
        <20200721193130.GH22083@linux.intel.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 21 Jul 2020 12:31:30 -0700
Sean Christopherson <sean.j.christopherson@intel.com> wrote:

> +Steve
> 
> Background: KVM has two tracepoints that effectively trace the same thing
> (VM-Exit vs. nested VM-Exit), but use completely different formatting and
> nomenclature for each of the existing tracepoints.  I want to add a common
> macro to create the tracepoints so that they capture the exact same info
> and report it with the exact same format.  But that means breaking the
> "ABI" for one of the tracepoints, e.g. trace-cmd barfs on the rename of
> exit_code to exit_reason.

Feel free to update it.

> 
> Was there ever a verdict on whether or not tracepoints are considered ABI
> and thus must retain backwards compatibility?
> 
> If not, what's the proper way to upstream changes to trace-cmd?
> 

There's a kvm plugin in the libtraceevent code.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/lib/traceevent/plugins/plugin_kvm.c

This overrides how the events are read. In the callback handler
(e.g. kvm_nested_vmexit_handle()), you can test if "rip" is there or
not. If it is not, you can do something different. For example:

	struct tep_format_field *field;

	field = tep_find_any_field(event, "rip");
	if (field) {
		tep_print_num_field(s, "rip %llx ", event, "rip", record, 1)
		[..]
	} else {
		/* do something new */
	}

You can test if fields exist and have the plugins do different things
depending on the format of an event. This is what I do in case an event
changes in the future.

-- Steve
