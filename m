Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D918E7B24AB
	for <lists+kvm@lfdr.de>; Thu, 28 Sep 2023 20:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjI1SB6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Sep 2023 14:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbjI1SBx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Sep 2023 14:01:53 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD4B19D;
        Thu, 28 Sep 2023 11:01:51 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1695924109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qCBpASJoVOKX9VMMrGRtPeWsM1IggJ7ZK6sK+Vspaeo=;
        b=qXsrR3/GF7IJihiwraCz8qKW8U2b68LXMY6UjZ3+IEZeLlUpwu8yBGJPZy408Azlz7lycz
        Rj4kjTzZnybeQh46tlfV3i5eXQjbE+k3IssGRQ4iYbgsbCvt4dOIX9AKqFF9hqpsouLjx2
        5dQumKoM/U8QfaT52MkqPCzA/3NncDElzueKLwl6yW7w9WdPutYT2GZt+BO2WQXIQNr16o
        pb7RU8OwZ0GJUC6iDnIyj7Ozlo7Hw6pkxxHYXRzlQNA5gQN4cSz5tE0QLuBN4tFVR61d5h
        0BA7cVC1H0gu2vmgG66P30S3HeoFV0NmX/Pu5uwdjaEwyQI7KG6IBTpFaFOfMA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1695924109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qCBpASJoVOKX9VMMrGRtPeWsM1IggJ7ZK6sK+Vspaeo=;
        b=ZggqpdKB9KJL/89VvpA8wkdGK0oIINIwb21C02kaTkeWIRIgr4OEOE1ZY9ScEBJVZYX9F2
        /nS9HIbISQc7oGDA==
To:     "H. Peter Anvin" <hpa@zytor.com>, Xin Li <xin3.li@intel.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-edac@vger.kernel.org, linux-hyperv@vger.kernel.org,
        kvm@vger.kernel.org, xen-devel@lists.xenproject.org
Cc:     mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, luto@kernel.org, pbonzini@redhat.com,
        seanjc@google.com, peterz@infradead.org, jgross@suse.com,
        ravi.v.shankar@intel.com, mhiramat@kernel.org,
        andrew.cooper3@citrix.com, jiangshanlai@gmail.com,
        nik.borisov@suse.com
Subject: Re: [PATCH v11 35/37] x86/syscall: Split IDT syscall setup code
 into idt_syscall_init()
In-Reply-To: <D4167CD5-B619-448D-B660-24ABC0786E0A@zytor.com>
References: <20230923094212.26520-1-xin3.li@intel.com>
 <20230923094212.26520-36-xin3.li@intel.com>
 <D4167CD5-B619-448D-B660-24ABC0786E0A@zytor.com>
Date:   Thu, 28 Sep 2023 20:01:48 +0200
Message-ID: <87y1gqdvn7.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 25 2023 at 09:07, H. Peter Anvin wrote:
> On September 23, 2023 2:42:10 AM PDT, Xin Li <xin3.li@intel.com> wrote:
>>+/* May not be marked __init: used by software suspend */
>>+void syscall_init(void)
>>+{
>>+	/* The default user and kernel segments */
>>+	wrmsr(MSR_STAR, 0, (__USER32_CS << 16) | __KERNEL_CS);
>>+
>>+	idt_syscall_init();
>>+}
>>+
>> #else	/* CONFIG_X86_64 */
>> 
>> #ifdef CONFIG_STACKPROTECTOR
>
> Am I missing something, or is this patch a noop?

Yes. It's a noop at this point. Later on it gains a

     if (!fred)
        idt_syscall_init();

Sure we could do

     if (!fred) {
     	write_msr(foo...);
        ...
     }

too, but I prefer the separation. No strong opinion though.

Thanks,

        tglx
