Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA0EB749AA6
	for <lists+kvm@lfdr.de>; Thu,  6 Jul 2023 13:31:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232330AbjGFLbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Jul 2023 07:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232097AbjGFLbj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Jul 2023 07:31:39 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4934C170F
        for <kvm@vger.kernel.org>; Thu,  6 Jul 2023 04:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688643054;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RinQDlUt4K38HkHxLwhOYs8pH7N2WJkW7Jmb1TL6X3c=;
        b=daTvktUaUzkWhbkD74TdmxfhS7MLdiT1fLQebvHYuPuzjzWasKJY3Bgpv3lQ9vaW1xw99N
        gaaLdnmaEtr/f2W2kDch6azmuS0d+OMR4z+BKiC4sb2bDykScGImi2Z/FdFNGCuq/N9WiT
        pSriEbyW5C8dZ/lrqdlntiEPogvcgIk=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-QWIXZOF1Pom1DITtmSKluQ-1; Thu, 06 Jul 2023 07:30:53 -0400
X-MC-Unique: QWIXZOF1Pom1DITtmSKluQ-1
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-635d9e482f1so8380466d6.1
        for <kvm@vger.kernel.org>; Thu, 06 Jul 2023 04:30:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688643053; x=1691235053;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RinQDlUt4K38HkHxLwhOYs8pH7N2WJkW7Jmb1TL6X3c=;
        b=Q+HkEfpjeE+xfsP+DF6G/9rHJGui9SwT5ONFpgLqJeLTiamvA+y9uAKBXu7X8FrclW
         1RXuPPVkDYNzJUpH+5VIHxo40OBP2RQsRPnYHnH0cCMCyKoaT2h844Y95LcO/LGgp3+I
         7NHBzquQXnaePh94HiUlRWRgFiX2gYEhF9XbSYZIengbznO+cxVxr/cjgaPsvquWXHLQ
         tmSn3OFaCeNGkIaZ2hLqzp/tJTwC2DxZiGv20vwt96GHP15m2TxPZoXucUfXF0eI9Vsl
         NtciJRD/dd76HNt35Ym4aFGAnI9oTap+JaYlXm4FPy/GU9bYok19aRWKA6sF1RA2ar68
         Fy8A==
X-Gm-Message-State: ABy/qLbJmWAUKgBx7TpDJ+5OTjK1uUyGmzXLXFPEh5NLoC96Yp8hI5kq
        M3fpNQrZIOAB9mjofE68y2d70Z2WqS8dUkEQN4YvRsYo71aSfASDbA36Uga2z0+pVsX5uU4foJu
        ifUQ6JtcPm4d+
X-Received: by 2002:a0c:f549:0:b0:62f:effe:3dca with SMTP id p9-20020a0cf549000000b0062feffe3dcamr1420069qvm.2.1688643053018;
        Thu, 06 Jul 2023 04:30:53 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEbUYOJppwMgQvsEvMakiRmaJatTD8CbvHxxx1dIrR+0X5zWXHf8RNpRxDwVdgtv2CCKKsXFA==
X-Received: by 2002:a0c:f549:0:b0:62f:effe:3dca with SMTP id p9-20020a0cf549000000b0062feffe3dcamr1420051qvm.2.1688643052762;
        Thu, 06 Jul 2023 04:30:52 -0700 (PDT)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id a12-20020a0ce38c000000b0062de6537febsm769879qvl.58.2023.07.06.04.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jul 2023 04:30:52 -0700 (PDT)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Frederic Weisbecker <frederic@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
        bpf@vger.kernel.org, x86@kernel.org,
        Nicolas Saenz Julienne <nsaenzju@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Juerg Haefliger <juerg.haefliger@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Nadav Amit <namit@vmware.com>,
        Dan Carpenter <error27@gmail.com>,
        Chuang Wang <nashuiliang@gmail.com>,
        Yang Jihong <yangjihong1@huawei.com>,
        Petr Mladek <pmladek@suse.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>,
        Julian Pidancet <julian.pidancet@oracle.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dionna Glaze <dionnaglaze@google.com>,
        Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Juri Lelli <juri.lelli@redhat.com>,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Yair Podemsky <ypodemsk@redhat.com>
Subject: Re: [RFC PATCH 11/14] context-tracking: Introduce work deferral
 infrastructure
In-Reply-To: <ZKXtfWZiM66dK5xC@localhost.localdomain>
References: <20230705181256.3539027-1-vschneid@redhat.com>
 <20230705181256.3539027-12-vschneid@redhat.com>
 <ZKXtfWZiM66dK5xC@localhost.localdomain>
Date:   Thu, 06 Jul 2023 12:30:46 +0100
Message-ID: <xhsmhttuhuvix.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/07/23 00:23, Frederic Weisbecker wrote:
> Le Wed, Jul 05, 2023 at 07:12:53PM +0100, Valentin Schneider a =C3=A9crit=
 :
>> +bool ct_set_cpu_work(unsigned int cpu, unsigned int work)
>> +{
>> +	struct context_tracking *ct =3D per_cpu_ptr(&context_tracking, cpu);
>> +	unsigned int old_work;
>> +	bool ret =3D false;
>> +
>> +	preempt_disable();
>> +
>> +	old_work =3D atomic_read(&ct->work);
>> +	/*
>> +	 * Try setting the work until either
>> +	 * - the target CPU no longer accepts any more deferred work
>> +	 * - the work has been set
>> +	 */
>> +	while (!(old_work & CONTEXT_WORK_DISABLED) && !ret)
>
> Isn't there a race here where you may have missed a CPU that just entered=
 in
> user and you eventually disturb it?
>

Yes, unfortunately.

>> +		ret =3D atomic_try_cmpxchg(&ct->work, &old_work, old_work | work);
>> +
>> +	preempt_enable();
>> +	return ret;
>> +}
> [...]
>> @@ -100,14 +158,19 @@ static noinstr void ct_kernel_exit_state(int offse=
t)
>>   */
>>  static noinstr void ct_kernel_enter_state(int offset)
>>  {
>> +	struct context_tracking *ct =3D this_cpu_ptr(&context_tracking);
>>      int seq;
>> +	unsigned int work;
>>
>> +	work =3D ct_work_fetch(ct);
>
> So this adds another fully ordered operation on user <-> kernel transitio=
n.
> How many such IPIs can we expect?
>

Despite having spent quite a lot of time on that question, I think I still
only have a hunch.

Poking around RHEL systems, I'd say 99% of the problematic IPIs are
instruction patching and TLB flushes.

Staring at the code, there's quite a lot of smp_calls for which it's hard
to say whether the target CPUs can actually be isolated or not (e.g. the
CPU comes from a cpumask shoved in a struct that was built using data from
another struct of uncertain origins), but then again some of them don't
need to hook into context_tracking.

Long story short: I /think/ we can consider that number to be fairly small,
but there could be more lurking in the shadows.

> If this is just about a dozen, can we stuff them in the state like in the
> following? We can potentially add more of them especially on 64 bits we c=
ould
> afford 30 different works, this is just shrinking the RCU extended quiesc=
ent
> state counter space. Worst case that can happen is that RCU misses 65535
> idle/user <-> kernel transitions and delays a grace period...
>

I'm trying to grok how this impacts RCU, IIUC most of RCU mostly cares abou=
t the
even/odd-ness of the thing, and rcu_gp_fqs() cares about the actual value
but only to check if it has changed over time (rcu_dynticks_in_eqs_since()
only does a !=3D).

I'm rephrasing here to make sure I get it - is it then that the worst case
here is 2^(dynticks_counter_size) transitions happen between saving the
dynticks snapshot and checking it again, so RCU waits some more?

