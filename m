Return-Path: <kvm+bounces-8148-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C09D184BF01
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 21:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3148B1F22860
	for <lists+kvm@lfdr.de>; Tue,  6 Feb 2024 20:58:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D6A61B940;
	Tue,  6 Feb 2024 20:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bc+M27W/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D391E1B944
	for <kvm@vger.kernel.org>; Tue,  6 Feb 2024 20:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707253130; cv=none; b=rXjv4cVZEwAUCp7z0OVnUK+8Q3CMe30W3m06OmrmpQyh/HG56KIp6cLhWA0pORjBM0W0aFvbqFh93Gpkq/Xfg40F/HtBYep1NQ5tWLDLIi5zfZx5LtiDP1YM+rVGNFcTJxJjydnghhY9MoEbfQTb4ybkHmeCkIEU58TJNXC0Rt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707253130; c=relaxed/simple;
	bh=9qRObfvA8ZAb+FX9SBRhdcDcbidM1/tWMt7Ry91tecE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sg60WjBAb7e5t9x7pL2NqRAvvXIwYC3d/fCZC07q1QpCCYbvsuhSuENYhXsYHcoLdlXAQ3dy9adtUTXIs9Eiq/qEC8aN+ef/tFri1G59v/OyCU1L8B0gbBZFsurJ76/qCDtWg/CNU9gjsJkmEKXqe1k/0ydOzAYjZ0y7a9mD+Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bc+M27W/; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc7165d7ca3so3133356276.2
        for <kvm@vger.kernel.org>; Tue, 06 Feb 2024 12:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707253128; x=1707857928; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0enT21I+2oflGQFv4IttPgAIR7OGwbDWfwrCGcb3/A4=;
        b=Bc+M27W/7pD3mYKxQLPYJB8JbpVgsWB8bGq5QrRg3L/1H/L578u7XnmWcyY0N6IDVG
         bWLziFYsy/Dkn+oItqWwJo8f80R7snRVublbS3Ph2Nzp+qIpi2WmdwoL8VBtvUW/ChA5
         lDS5VV0j3BQokPNjlTiK7OVNWiyJd76WpYDycwclw2cMmkNtGUicNAJLAJaBx9hXYHvo
         3kuKTpRwXzj2XOu7WQNTItJd9WYRyB0siQKDrGuSKHfSCKWkvOlkMUeaJAkUuvosQi4v
         h7+NZ0IjOaZ04RDjQIvhj4rdYv5eGs5rJYrU0/yDsZPP3qdlYkSmCSV6KLZs5dGJO6IU
         mYpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707253128; x=1707857928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0enT21I+2oflGQFv4IttPgAIR7OGwbDWfwrCGcb3/A4=;
        b=sE1md2Ua4JXuRtbeytU0m/VMeJhgeTdGeK2oh7tRU2egF2ya4oOk7DwXfzF55PYFcO
         9L1utXzOtWyVzkoWG0ZSgOk/tgHjAibT2zzWyqvuJ6ZkwZ5JjtdtCZGBmezAJN5jkR+o
         N9qHTgUvnu5J5XPZVJq8Ja5h8+sZrYuY7BjW1TrCoW5w/IMMRds/bDAi7aUXQN8WaKJN
         yshhyJqYCowzIZHQWRB4piXJ/0L3PJ09thCJarBhPiNihcxHcVKmLiYCzgPlF5yD7Ca1
         yRxSCFMfBSDHIHdzCPIjXEKqPYkRTR+Mw+qWmncdwSgBDvyZhjzIsVblHWd87/4469oU
         x5mw==
X-Gm-Message-State: AOJu0YxtCbpOH+ET6zZVbF3saW2xySNTnBLnZinrFpU2itu+uuGKxmpB
	1ZPAtZ6dxOwe0RrXqkrHibu/h0e75zvZvcD6GdAPM4YEDy1qGREuXzmxKXznnqrAuEg1WqWWNSY
	ypg==
X-Google-Smtp-Source: AGHT+IFdIYHeFglOTEuwumdKlrr344iGbjKbzt7UsjDz5eT8lpnwnpjJUNFGytH7ONmGxE8/aWnk64dMfhI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:2604:b0:dc2:57c9:b44d with SMTP id
 dw4-20020a056902260400b00dc257c9b44dmr127604ybb.8.1707253127933; Tue, 06 Feb
 2024 12:58:47 -0800 (PST)
Date: Tue, 6 Feb 2024 12:58:46 -0800
In-Reply-To: <8fe554e5-e76e-9a0a-548d-bdac3b6b2b60@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240103075343.549293-1-ppandit@redhat.com> <8fe554e5-e76e-9a0a-548d-bdac3b6b2b60@oracle.com>
Message-ID: <ZcKdhuE2yNednYPD@google.com>
Subject: Re: [PATCH] KVM: x86: make KVM_REQ_NMI request iff NMI pending for vcpu
From: Sean Christopherson <seanjc@google.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: Prasad Pandit <ppandit@redhat.com>, Prasad Pandit <pjp@fedoraproject.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Tue, Feb 06, 2024, Dongli Zhang wrote:
> Hi Prasad,
> 
> On 1/2/24 23:53, Prasad Pandit wrote:
> > From: Prasad Pandit <pjp@fedoraproject.org>
> > 
> > kvm_vcpu_ioctl_x86_set_vcpu_events() routine makes 'KVM_REQ_NMI'
> > request for a vcpu even when its 'events->nmi.pending' is zero.
> > Ex:
> >     qemu_thread_start
> >      kvm_vcpu_thread_fn
> >       qemu_wait_io_event
> >        qemu_wait_io_event_common
> >         process_queued_cpu_work
> >          do_kvm_cpu_synchronize_post_init/_reset
> >           kvm_arch_put_registers
> >            kvm_put_vcpu_events (cpu, level=[2|3])
> > 
> > This leads vCPU threads in QEMU to constantly acquire & release the
> > global mutex lock, delaying the guest boot due to lock contention.
> 
> Would you mind sharing where and how the lock contention is at QEMU space? That
> is, how the QEMU mutex lock is impacted by KVM KVM_REQ_NMI?
> 
> Or you meant line 3031 at QEMU side?

Yeah, something like that.  Details in this thread.

https://lore.kernel.org/all/CAE8KmOyffXD4k69vRAFwesaqrBGzFY3i+kefbkHcQf4=jNYzOA@mail.gmail.com

> 2858 int kvm_cpu_exec(CPUState *cpu)
> 2859 {
> 2860     struct kvm_run *run = cpu->kvm_run;
> 2861     int ret, run_ret;
> ... ...
> 3023         default:
> 3024             DPRINTF("kvm_arch_handle_exit\n");
> 3025             ret = kvm_arch_handle_exit(cpu, run);
> 3026             break;
> 3027         }
> 3028     } while (ret == 0);
> 3029
> 3030     cpu_exec_end(cpu);
> 3031     qemu_mutex_lock_iothread();
> 3032
> 3033     if (ret < 0) {
> 3034         cpu_dump_state(cpu, stderr, CPU_DUMP_CODE);
> 3035         vm_stop(RUN_STATE_INTERNAL_ERROR);
> 3036     }
> 3037
> 3038     qatomic_set(&cpu->exit_request, 0);
> 3039     return ret;
> 3040 }

