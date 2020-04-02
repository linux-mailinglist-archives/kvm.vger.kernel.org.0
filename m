Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCF6D19CC8F
	for <lists+kvm@lfdr.de>; Thu,  2 Apr 2020 23:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389171AbgDBVts (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Apr 2020 17:49:48 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:39090 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729549AbgDBVts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Apr 2020 17:49:48 -0400
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jK7i0-0003n8-Nm; Thu, 02 Apr 2020 23:49:08 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id 0CDB5100D52; Thu,  2 Apr 2020 23:49:08 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Paul McKenney <paulmck@kernel.org>,
        "Joel Fernandes \(Google\)" <joel@joelfernandes.org>,
        "Steven Rostedt \(VMware\)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Brian Gerst <brgerst@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Alexandre Chartre <alexandre.chartre@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [RESEND][patch V3 06/23] bug: Annotate WARN/BUG/stackfail as noinstr safe
In-Reply-To: <20200402210115.zpk52dyc6ofg2bve@treble>
References: <20200320175956.033706968@linutronix.de> <20200320180032.994128577@linutronix.de> <20200402210115.zpk52dyc6ofg2bve@treble>
Date:   Thu, 02 Apr 2020 23:49:08 +0200
Message-ID: <87369lmucr.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Josh Poimboeuf <jpoimboe@redhat.com> writes:
> On Fri, Mar 20, 2020 at 07:00:02PM +0100, Thomas Gleixner wrote:
>> --- a/arch/x86/include/asm/bug.h
>> +++ b/arch/x86/include/asm/bug.h
>> @@ -70,13 +70,16 @@ do {									\
>>  #define HAVE_ARCH_BUG
>>  #define BUG()							\
>>  do {								\
>> +	instr_begin();						\
>>  	_BUG_FLAGS(ASM_UD2, 0);					\
>>  	unreachable();						\
>>  } while (0)
>
> For visual symmetry at least, it seems like this wants an instr_end()
> before the unreachable().  Does objtool not like that?

There was some hickup, but can't remember. Will try to reproduce with
the latest version of Peter's objtool changes.

>> --- a/include/asm-generic/bug.h
>> +++ b/include/asm-generic/bug.h
>> @@ -83,14 +83,19 @@ extern __printf(4, 5)
>>  void warn_slowpath_fmt(const char *file, const int line, unsigned taint,
>>  		       const char *fmt, ...);
>>  #define __WARN()		__WARN_printf(TAINT_WARN, NULL)
>> -#define __WARN_printf(taint, arg...)					\
>> -	warn_slowpath_fmt(__FILE__, __LINE__, taint, arg)
>> +#define __WARN_printf(taint, arg...) do {				\
>> +	instr_begin();							\
>> +	warn_slowpath_fmt(__FILE__, __LINE__, taint, arg);		\
>> +	instr_end();							\
>> +	while (0)
>
> Missing a '}' before the 'while'?

Yep, fixed that locally already.

Thanks,

        tglx
