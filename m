Return-Path: <kvm+bounces-24306-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EF369537FB
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 18:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3233D1C25734
	for <lists+kvm@lfdr.de>; Thu, 15 Aug 2024 16:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C50D1B3F33;
	Thu, 15 Aug 2024 16:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J3WLmRvk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66751B012B
	for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 16:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723738243; cv=none; b=q+7EuubKracHh5D8bmWsRZ/hrjKBW958rWg1rQyc0WJklaMGFNVB+HetPVKKWeQAc+TFKydeZmKp5YqnsRw9AjHhJWoti12qNc4lrkwjadqbkElA53UeERNgxXo42B/C30Wb1p8bZkdz5fHEBexu35vvGwkVygVFGF7WP5HnqoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723738243; c=relaxed/simple;
	bh=nhUoeQTxPlzxHkRrHDGgpJTsk5svcnXwNkNbkHZdq+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Brt2P+wzWR1c4WlTeR7yMd7A4FVA2Y0nN9A2bPI+ttVzt29rJX7lbiF6qz75dxJDVXCmjVtdqpi9c+melu0eudO1t9QuJne40n4p1k1fDpHRe3zEk4dVLCc1RZ4Dmqq0p/zytpcrXApDUP6G7VLc39rcb6SLSmA599oDtKOYXl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J3WLmRvk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1723738240;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0C29WUxU/0x21D0S2vEXYwTrRtZFHVrz4TucO9zGe6Q=;
	b=J3WLmRvk46vC/fHbRsdBP9YKrGORs/js//rlRD1w2jywsyhmtc5cyhpKlN0QEQ/hRHG1Wj
	m27uDlAodXyufVx4P2ngGES11p33X+ptE9l3Nnlb+5HZLrfuU2rTpnfD44lNmb0WMEIKAM
	YNbkcYh/q6Q3fD0D7w9iW0eD48/hcyw=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-642-jYptmzOzMFSLBgjjkq1LEg-1; Thu, 15 Aug 2024 12:10:39 -0400
X-MC-Unique: jYptmzOzMFSLBgjjkq1LEg-1
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2cb5847ff53so1086506a91.2
        for <kvm@vger.kernel.org>; Thu, 15 Aug 2024 09:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723738235; x=1724343035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0C29WUxU/0x21D0S2vEXYwTrRtZFHVrz4TucO9zGe6Q=;
        b=EomPkBpHtauzj/V6GI8aKfv3zdAfoNj761d/yPDQvulCQ9+clLziJfd3ZF8thaqAh5
         JWrN8jst5vPPzKbcrxhcm44puRmRVQeglmzwb4HLNnF2CdnkrmlWLE86TqWNOhiSM1pl
         X8IFaoN+PercP3NbQvG47jvAAveBtmxBS4pR35HkrXMMAtiHGmHxhQL3o8xDZDZVUt/q
         VX2E769V95NYtcOWQSYtCeZOoA6z5TPmOLSeYAkfYhV3hihgx0bic5jbghURcOepdEN9
         D1dug7p+jaPw1YsK3sethRK7wnuGPqknnO+LUcshWys2fHnWb56Azj4VPxoUUXeWj+k4
         kRXw==
X-Gm-Message-State: AOJu0YwMOFf/2s8lGJmELlUngGKA55DKjv3ZrREw6KpuO339fgvgStmU
	LpfvproAM+mxszDddO0l8ExesRdFbgAZpKHzTcjBdT1fJLVt9CLC3Nw8P3WB1/aeWPcmuQRvqwO
	Nass0PBUxFFwvVpmLrJWq1nBPpM7ur9v7Q8CtNhBx2tueka6iwz2uXIEXxVKD95y5pJMvek9ec2
	6mmK+VpNwgdnxl9W/jjXr21mmM
X-Received: by 2002:a17:90a:d783:b0:2d3:d8b0:967b with SMTP id 98e67ed59e1d1-2d3dffdb9fcmr122252a91.27.1723738235489;
        Thu, 15 Aug 2024 09:10:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHXuGOKn3nZprVHVB8nhKQZZwCrztWxBA90Dez4sQ0Fhc7M3UCle8kaUQQiO4lzZNCSrEAKKrx6iXw5ZY7dSyg=
X-Received: by 2002:a17:90a:d783:b0:2d3:d8b0:967b with SMTP id
 98e67ed59e1d1-2d3dffdb9fcmr122224a91.27.1723738235138; Thu, 15 Aug 2024
 09:10:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240608000639.3295768-1-seanjc@google.com> <20240608000639.3295768-2-seanjc@google.com>
 <efb9af41-21ed-4b97-8c67-40d6cda10484@redhat.com> <Zr4TPVQ_SNEKyfUz@google.com>
In-Reply-To: <Zr4TPVQ_SNEKyfUz@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 15 Aug 2024 18:10:21 +0200
Message-ID: <CABgObfZSCZ-dgK3zWao573+RmZSPhnaoMsrify9-48UVhbKVdw@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] KVM: Use dedicated mutex to protect
 kvm_usage_count to avoid deadlock
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chao Gao <chao.gao@intel.com>, Kai Huang <kai.huang@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 15, 2024 at 4:40=E2=80=AFPM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Wed, Aug 14, 2024, Paolo Bonzini wrote:
> > On 6/8/24 02:06, Sean Christopherson wrote:
> > > Use a dedicated mutex to guard kvm_usage_count to fix a potential dea=
dlock
> > > on x86 due to a chain of locks and SRCU synchronizations.  Translatin=
g the
> > > below lockdep splat, CPU1 #6 will wait on CPU0 #1, CPU0 #8 will wait =
on
> > > CPU2 #3, and CPU2 #7 will wait on CPU1 #4 (if there's a writer, due t=
o the
> > > fairness of r/w semaphores).
> > >
> > >      CPU0                     CPU1                     CPU2
> > > 1   lock(&kvm->slots_lock);
> > > 2                                                     lock(&vcpu->mut=
ex);
> > > 3                                                     lock(&kvm->srcu=
);
> > > 4                            lock(cpu_hotplug_lock);
> > > 5                            lock(kvm_lock);
> > > 6                            lock(&kvm->slots_lock);
> > > 7                                                     lock(cpu_hotplu=
g_lock);
> > > 8   sync(&kvm->srcu);
> > >
> > > Note, there are likely more potential deadlocks in KVM x86, e.g. the =
same
> > > pattern of taking cpu_hotplug_lock outside of kvm_lock likely exists =
with
> > > __kvmclock_cpufreq_notifier()
> >
> > Offhand I couldn't see any places where {,__}cpufreq_driver_target() is
> > called within cpus_read_lock().  I didn't look too closely though.
>
> Anyways...
>
>   cpuhp_cpufreq_online()
>   |
>   -> cpufreq_online()
>      |
>      -> cpufreq_gov_performance_limits()
>         |
>         -> __cpufreq_driver_target()
>            |
>            -> __target_index()

Ah, I only looked in generic code.

Can you add a comment to the comment message suggesting switching the
vm_list to RCU? All the occurrences of list_for_each_entry(...,
&vm_list, ...) seem amenable to that, and it should be as easy to
stick all or part of kvm_destroy_vm() behind call_rcu().

Thanks,

Paolo


