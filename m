Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 693502DBF1D
	for <lists+kvm@lfdr.de>; Wed, 16 Dec 2020 12:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgLPLAX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Dec 2020 06:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgLPLAS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Dec 2020 06:00:18 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82810C06179C;
        Wed, 16 Dec 2020 02:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MlEsyRKN7UIGIMoR4X8FZQCL6Z0fZRj8y0TPOgyM8fE=; b=MuYTmE3PRiNU3kJIDxUcUWSI7j
        wiVEQNcyZOVn5ovAyM8fJ4LaO60RpOx3QMjolGuhr5KvP9G7jdVoxFTOtsY92XrJWV+MKg7k8Ibir
        Qc7Y7DxmpHFudzmOo/FCeAROPA3jeR1uHHKJH5LeAqOdz4m0XoDZPU5MrSmTUHD2wHRv3cf54g57c
        Mpt7Gi/d2rN70k4lvPJkJyc5Nlq3lavP096XSRf+UVjufte+js7p0mXlZvsi7fVh7yg8pACUONkqy
        /f2HjE3Eg1qPpEzwO/c6TzVXsFrkSJWZVdMFH+tZYONxx1pHSfeQFNSlaMiBfUSiqyhs6tYOnJUn9
        w0rqZg1g==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kpUWp-0003s1-0P; Wed, 16 Dec 2020 10:59:31 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 9886E300DAE;
        Wed, 16 Dec 2020 11:59:26 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 81E4423669EF4; Wed, 16 Dec 2020 11:59:26 +0100 (CET)
Date:   Wed, 16 Dec 2020 11:59:26 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        jeyu@kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>,
        ardb@kernel.org
Subject: Re: static_branch_enable() does not work from a __init function?
Message-ID: <20201216105926.GS3092@hirez.programming.kicks-ass.net>
References: <MW4PR21MB1857CC85A6844C89183C93E9BFC59@MW4PR21MB1857.namprd21.prod.outlook.com>
 <20201216092649.GM3040@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201216092649.GM3040@hirez.programming.kicks-ass.net>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Dec 16, 2020 at 10:26:49AM +0100, Peter Zijlstra wrote:
> On Wed, Dec 16, 2020 at 03:54:29AM +0000, Dexuan Cui wrote:
> > Hi,
> > The below init_module() prints "foo: false". This is strange since
> > static_branch_enable() is called before the static_branch_unlikely().
> > This strange behavior happens to v5.10 and an old v5.4 kernel.
> > 
> > If I remove the "__init" marker from the init_module() function, then
> > I get the expected output of "foo: true"! I guess here I'm missing
> > something with Static Keys?
> 
> *groan*... I think this is because __init is ran with
> MODULE_STATE_COMING, we only switch to MODULE_STATE_LIVE later.
> 
> Let me see if there's a sane way to untangle that.
> 
> > #include <linux/module.h>
> > #include <linux/kernel.h>
> > #include <linux/jump_label.h>
> > 
> > static DEFINE_STATIC_KEY_FALSE(enable_foo);
> > 
> > int __init init_module(void)
> > {
> >         static_branch_enable(&enable_foo);
> > 
> >         if (static_branch_unlikely(&enable_foo))
> >                 printk("foo: true\n");
> >         else
> >                 printk("foo: false\n");
> > 
> >         return 0;
> > }
> > 
> > void cleanup_module(void)
> > {
> >         static_branch_disable(&enable_foo);
> > }
> > 
> > MODULE_LICENSE("GPL");
> > 
> > 
> > PS, I originally found: in arch/x86/kvm/vmx/vmx.c: vmx_init(), it looks
> > like the line "static_branch_enable(&enable_evmcs);" does not take effect
> > in a v5.4-based kernel, but does take effect in the v5.10 kernel in the
> > same x86-64 virtual machine on Hyper-V, so I made the above test module
> > to test static_branch_enable(), and found that static_branch_enable() in
> > the test module does not work with both v5.10 and my v5.4 kernel, if the
> > __init marker is used.

So I think the reason your above module doesn't work, while the one in
vmx_init() does work (for 5.10) should be fixed by the completely
untested below.

I've no clue about 5.4 and no desire to investigate. That's what distro
people are for.

Can you verify?

---
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 015ef903ce8c..c6a39d662935 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -793,6 +793,7 @@ int jump_label_text_reserved(void *start, void *end)
 static void jump_label_update(struct static_key *key)
 {
 	struct jump_entry *stop = __stop___jump_table;
+	bool init = system_state < SYSTEM_RUNNING;
 	struct jump_entry *entry;
 #ifdef CONFIG_MODULES
 	struct module *mod;
@@ -804,15 +805,16 @@ static void jump_label_update(struct static_key *key)
 
 	preempt_disable();
 	mod = __module_address((unsigned long)key);
-	if (mod)
+	if (mod) {
 		stop = mod->jump_entries + mod->num_jump_entries;
+		init = mod->state == MODULE_STATE_COMING;
+	}
 	preempt_enable();
 #endif
 	entry = static_key_entries(key);
 	/* if there are no users, entry can be NULL */
 	if (entry)
-		__jump_label_update(key, entry, stop,
-				    system_state < SYSTEM_RUNNING);
+		__jump_label_update(key, entry, stop, init);
 }
 
 #ifdef CONFIG_STATIC_KEYS_SELFTEST
