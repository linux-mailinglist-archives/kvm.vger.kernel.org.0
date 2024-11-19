Return-Path: <kvm+bounces-32105-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2387A9D30B1
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 23:52:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 88F9EB228AB
	for <lists+kvm@lfdr.de>; Tue, 19 Nov 2024 22:52:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 750A71D47A0;
	Tue, 19 Nov 2024 22:52:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dZ+1ar3a"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E101D1F6F
	for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 22:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732056720; cv=none; b=HBO1bmx3TTvdbbMC0QOyVWLYPYkDwxfSHvz44BxFby0juf1a0tfn5i5CrrNlYjAMZkXm9euNeX7IAR5Juuzcc7i2PM9KWKvWUeZX3/pWjVcysKd7CrTX0dW/EJ5XKzUTeipNIyZ4OgpOZkaEWUMOJISnp6/t6Tvxphi4+Iqtmvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732056720; c=relaxed/simple;
	bh=n+FUegK41l52wy6PHil3h7VNOwWht9pyTJK05iUwYtY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tDfK788pE8PLKL0jTFqS+YQAR84XCW0GDTRxVktJCQIK0qoBd4jeBGxriEHoaCjHMj65Htf1Xo2gLTiFlOdFL/Hwk8ftqvDVtoG3/EStc5w2fS77fsedXBCwnd8FscphctbWA+Ogord2IN2ruUjRHoRThB/kD+GfYQFeKWo+4b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dZ+1ar3a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732056718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0acvZIc1v1FoWClAO41Ko95c122YYqzO2aYK11MWEDA=;
	b=dZ+1ar3ax/dPsT9eweBPilgvGIHedNdHi9VEHwQtjIWdeGW+iDCHRfBRuTvBs4uhhLzQM2
	f36l6dtJIpw+MzI7jBm1oyXVxRF4Gq2mI1RQLekXi7yvVtMhyKRESE9mErMpCATCUyCxOy
	wGtGvpHMUMV+LgX50M1jC7laV6ukH5Q=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-512-86t_5JghOjK71HVZmbsO0w-1; Tue, 19 Nov 2024 17:51:56 -0500
X-MC-Unique: 86t_5JghOjK71HVZmbsO0w-1
X-Mimecast-MFC-AGG-ID: 86t_5JghOjK71HVZmbsO0w
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4316e2dde9eso35214335e9.2
        for <kvm@vger.kernel.org>; Tue, 19 Nov 2024 14:51:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732056715; x=1732661515;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0acvZIc1v1FoWClAO41Ko95c122YYqzO2aYK11MWEDA=;
        b=dQROGl21T4peamufTmS8slfZHrO+3dNUQjEW9/mX7cHQDVMDl1yzKwjhRqeTk94tYy
         nJHzRZzAURERgwwN/JqusrwLqM6K86uSGCPN8IwOAqoWmWK6AgBhRTC4POxpwoqyD1WS
         IJzHsfmvwPCtNCl1F7+gAo1j4DyqLZoeJVaYcRCYSpqCSvjTLK31/v2BfT83Qtv77g43
         cpGGAIx6FR2//FbOGYLdg6NqqpiSebMZpgjA1a7BmaOZrXA+xGG/oaeRRI6ZNDevxZkk
         ovOcwNVuzsij/9cQHHOV3m221gSnf3HHEQxuh0IyAKgUslOooO563bfNQ3K62CxdZsfF
         iP9g==
X-Forwarded-Encrypted: i=1; AJvYcCVdoGapUxZ2kuX4RtIRkEMTJYZJlAu0X2Tkq10H8Ye+tan8aiFHavunjQRokiEnYbmfj4A=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJaQzvdOqL1TWB0KECPlGXZbdWq1GEhfJJkgQcHCDIocFhJKdW
	udu3RGhFAaf940ePehhIXy0ChGoBxhFYLvnFnbnjQysrexe23ximkXzPG4i8CHWfR9vWEslvZ3S
	+juyLEkB7Jae1pPx6/rsvgjhkR06G0zAWqO1aWTNC10fOLcHDgA==
X-Received: by 2002:a05:600c:34c3:b0:42c:ba83:3f00 with SMTP id 5b1f17b1804b1-433489816d0mr4969215e9.1.1732056715536;
        Tue, 19 Nov 2024 14:51:55 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHMYN+PGJWEPxaqNKkZYZ2TSeyMynnunVcMDwn9yZJBs1V5cl+I8e3VzKdyfOqsH7HbngJhGA==
X-Received: by 2002:a05:600c:34c3:b0:42c:ba83:3f00 with SMTP id 5b1f17b1804b1-433489816d0mr4969005e9.1.1732056715138;
        Tue, 19 Nov 2024 14:51:55 -0800 (PST)
Received: from vschneid-thinkpadt14sgen2i.remote.csb (213-44-141-166.abo.bbox.fr. [213.44.141.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432da27f4f8sm209297365e9.18.2024.11.19.14.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2024 14:51:54 -0800 (PST)
From: Valentin Schneider <vschneid@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 kvm@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org,
 x86@kernel.org, rcu@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Masami Hiramatsu <mhiramat@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Wanpeng Li <wanpengli@tencent.com>, Vitaly Kuznetsov
 <vkuznets@redhat.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra
 <peterz@infradead.org>, Frederic Weisbecker <frederic@kernel.org>, "Paul
 E. McKenney" <paulmck@kernel.org>, Neeraj Upadhyay
 <quic_neeraju@quicinc.com>, Joel
 Fernandes <joel@joelfernandes.org>, Josh Triplett <josh@joshtriplett.org>,
 Boqun Feng <boqun.feng@gmail.com>, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Zqiang <qiang.zhang1211@gmail.com>, Andrew Morton
 <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>,
 Christoph
 Hellwig <hch@infradead.org>, Lorenzo Stoakes <lstoakes@gmail.com>, Josh
 Poimboeuf <jpoimboe@kernel.org>, Jason Baron <jbaron@akamai.com>, Kees Cook
 <keescook@chromium.org>, Sami Tolvanen <samitolvanen@google.com>, Ard
 Biesheuvel <ardb@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, Juerg
 Haefliger <juerg.haefliger@canonical.com>, Nicolas Saenz Julienne
 <nsaenz@kernel.org>, "Kirill A. Shutemov"
 <kirill.shutemov@linux.intel.com>, Nadav Amit <namit@vmware.com>, Dan
 Carpenter <error27@gmail.com>, Chuang Wang <nashuiliang@gmail.com>, Yang
 Jihong <yangjihong1@huawei.com>, Petr Mladek <pmladek@suse.com>, "Jason A.
 Donenfeld" <Jason@zx2c4.com>, Song Liu <song@kernel.org>, Julian Pidancet
 <julian.pidancet@oracle.com>, Tom Lendacky <thomas.lendacky@amd.com>,
 Dionna Glaze <dionnaglaze@google.com>, Thomas =?utf-8?Q?Wei=C3=9Fschuh?=
 <linux@weissschuh.net>, Juri Lelli <juri.lelli@redhat.com>, Marcelo
 Tosatti <mtosatti@redhat.com>, Yair Podemsky <ypodemsk@redhat.com>, Daniel
 Wagner <dwagner@suse.de>, Petr Tesarik <ptesarik@suse.com>
Subject: Re: [RFC PATCH v3 00/15] context_tracking,x86: Defer some IPIs
 until a user->kernel transition
In-Reply-To: <20241119114556.0949b562@gandalf.local.home>
References: <20241119153502.41361-1-vschneid@redhat.com>
 <20241119114556.0949b562@gandalf.local.home>
Date: Tue, 19 Nov 2024 23:51:52 +0100
Message-ID: <xhsmh8qtej0qf.mognet@vschneid-thinkpadt14sgen2i.remote.csb>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On 19/11/24 11:45, Steven Rostedt wrote:
> On Tue, 19 Nov 2024 16:34:47 +0100
> Valentin Schneider <vschneid@redhat.com> wrote:
>
>> Context
>> =======
>> 
>> We've observed within Red Hat that isolated, NOHZ_FULL CPUs running a
>> pure-userspace application get regularly interrupted by IPIs sent from
>> housekeeping CPUs. Those IPIs are caused by activity on the housekeeping CPUs
>> leading to various on_each_cpu() calls, e.g.:
>
> FYI,
>
> Sending a patch series at the start of the merge window is likely going to
> get ignored.
>
> Care to resend after rc1 is released? Or at least ping about it.
>

Heh, I was so far down "stop rewriting changelogs for the Nth time, get it
in a decent shape and send it out" that I forgot about this "small little
detail". Thanks for the reminder.


