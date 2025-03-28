Return-Path: <kvm+bounces-42215-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B33AA752BD
	for <lists+kvm@lfdr.de>; Sat, 29 Mar 2025 00:02:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 742F13AD1F2
	for <lists+kvm@lfdr.de>; Fri, 28 Mar 2025 23:02:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E68FD1F2C52;
	Fri, 28 Mar 2025 23:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HpSE5UMH"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A243186294
	for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 23:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743202968; cv=none; b=GoUecaQwNEp34nJ4i50IgQA1SAbtGrgC1GumGHR851ROtqFBIHi5Lr2ASaJtqkJYJoKdIDk0Yz2XBXc4Q4rC+6p/xJM3H1f1HCh2toKxuWB3BtW7JMwveS4nCsli/P8immMEeBhpVyM76xP1gyyQ3dmfQQs41h4JLqxN4hK26Nk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743202968; c=relaxed/simple;
	bh=EHhOr/szOVRW4r6fPNmf+7CydBzGMFXyJXlY4nfEGNU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cNY+nHH4mbdECz943zFz+Duf3P4H2G7YF7VVTT28CBu2WZ+3suOLoSA/RjIEDeLX+nrE8+nJkghl4/LHlkAVM8q1N0mooQD+VacyImqwiey5FROBNpzslyFK5OGcus3tYgmtncjhqM8Hl5AAxNuuj6Krq9zBHVhm0ScBsHL4i7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HpSE5UMH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1743202964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3qmZ6+9GDXglJ7iaaB4TOwxorIWMhNH+6HaoOQvmrWo=;
	b=HpSE5UMHv5mm0jlB7nCyzFEpAEn99lHnD2HyWCZep1XhE91OVR22z9k87nhoAL7qMJ2qAd
	BJpP1JvDL2Tgz8b+6XocmwToStVqFy8nKa8BqjMOXJbg7gsozI9U1dTThO36mK3usocs0S
	FjkONoE2awE/7DcfH2NegalbplCyGT4=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-RL09f68AOl6P3G1vRSWEfg-1; Fri, 28 Mar 2025 19:02:43 -0400
X-MC-Unique: RL09f68AOl6P3G1vRSWEfg-1
X-Mimecast-MFC-AGG-ID: RL09f68AOl6P3G1vRSWEfg_1743202963
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6e90b13f5c3so53392086d6.0
        for <kvm@vger.kernel.org>; Fri, 28 Mar 2025 16:02:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743202963; x=1743807763;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3qmZ6+9GDXglJ7iaaB4TOwxorIWMhNH+6HaoOQvmrWo=;
        b=LseJv1Qc/2as81KGpoJPzQD4yZfFPg6KDYS1mEeNtiqctv7UtZAxsbEImj6Z1WoKRQ
         xNeVQAeZbESrhtxa0Mh2zJ+WANeFNXAJWjbRvPwYh5jC8bvwYpfk6Ad4kg/36LZPWM09
         YTlZxDNn0Uv3ezdBnbKcsAce7dCa3Br6F3WBqq+6/09Qj+s++z7gcDEim+g5+ttT9FBw
         VLrdfqGneaDPzc8Cbe8QaQrGvscT+ngEGFx06+pKG2z2Jq/PaewkC6EpCQol5O4UyTx0
         kk6q9cEQOAi6TmK1GM85IjipxgesEmZY9CyCg32x3p2abz2Z+KKDQEurP+iFTipSenV2
         zCqA==
X-Forwarded-Encrypted: i=1; AJvYcCWGd2gVw4dR8WgiTwuWae7lI5HvDBsAJuA8o63qmnuJxE+412ka9TNz0l9SVXW2G7nNWAA=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywca+IzoOiMKeifakatYvtS+7f2utnbxDOY3mWhtc0uZ9fIYGTB
	rAZ0d/pR1lC6PblHOr/rxjLHJzONAFD1o7vUG6V2ufYKPu/pgyGDdBKiSrb4LfMFLWOWunUHbgC
	CQ+ftBBea4Em6wV3oRiPEg6MYMkc8dzIebp6KZ9Xnemg7uEjb4VlNSlUr7Q==
X-Gm-Gg: ASbGncvhT0q2cLd683pfovqSMsVJ4+41q5UPhUgCcmHnK4Tz5YEH4bFV585E0Mmg0Vt
	iyntrT1v4R2LGHpvrLPiID5toMCjBDogmLSqogx0+PpOP22qpqFIk1oeCL8J92GMm2btb5adih5
	IwlFSepUC3ontHCQnml1LqZq5K5eSweylFrmMKHDFyz/2+fP5/6iHF9n8Gi3GTrIUx84AGtKJUk
	x0wBclM1jepMEZ4oZVHMJV6nZ5VMrMlxCadqFUvUte+JwjXtDg3W2qSSTS5D1dbZ448j93Ry7eu
	3lsxHTk3LJfH1Fc=
X-Received: by 2002:a05:6214:496:b0:6ea:d604:9e56 with SMTP id 6a1803df08f44-6eed6073e0cmr15880216d6.9.1743202961723;
        Fri, 28 Mar 2025 16:02:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEN0tTN8QW6nPTRxSvGA7inrClB0RuAXWmh6BN3YjcBSXLhQqrpygt40ZjrbWyKTN4TYOsJYw==
X-Received: by 2002:a05:6214:496:b0:6ea:d604:9e56 with SMTP id 6a1803df08f44-6eed6073e0cmr15879866d6.9.1743202961322;
        Fri, 28 Mar 2025 16:02:41 -0700 (PDT)
Received: from starship ([2607:fea8:fc01:8d8d:6adb:55ff:feaa:b156])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eec9771947sm16217076d6.81.2025.03.28.16.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 16:02:41 -0700 (PDT)
Message-ID: <111cc5aa1b431d2939f6d7420b24cd8d1e15e9b0.camel@redhat.com>
Subject: Re: Lockdep failure due to 'wierd' per-cpu wakeup_vcpus_on_cpu_lock
 lock
From: Maxim Levitsky <mlevitsk@redhat.com>
To: Yan Zhao <yan.y.zhao@intel.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, James
	Houghton <jthoughton@google.com>
Date: Fri, 28 Mar 2025 19:02:39 -0400
In-Reply-To: <Z+U/W202ngjZxBOV@yzhao56-desk.sh.intel.com>
References: <e61d23ddc87cb45063637e0e5375cc4e09db18cd.camel@redhat.com>
	 <Z9ruIETbibTgPvue@google.com>
	 <CABgObfa1ApR6Pgk8UaxvU0giNeEfZ_u9o56Gx2Y2vSJPL-KwAQ@mail.gmail.com>
	 <Z+U/W202ngjZxBOV@yzhao56-desk.sh.intel.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 2025-03-27 at 20:06 +0800, Yan Zhao wrote:
> On Fri, Mar 21, 2025 at 12:49:42PM +0100, Paolo Bonzini wrote:
> > On Wed, Mar 19, 2025 at 5:17 PM Sean Christopherson <seanjc@google.com> wrote:
> > > Yan posted a patch to fudge around the issue[*], I strongly objected (and still
> > > object) to making a functional and confusing code change to fudge around a lockdep
> > > false positive.
> > 
> > In that thread I had made another suggestion, which Yan also tried,
> > which was to use subclasses:
> > 
> > - in the sched_out path, which cannot race with the others:
> >   raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1);
> > 
> > - in the irq and sched_in paths, which can race with each other:
> >   raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> Hi Paolo, Sean, Maxim,
> 
> The sched_out path still may race with sched_in path. e.g.
>     CPU 0                 CPU 1
> -----------------     ---------------
> vCPU 0 sched_out
> vCPU 1 sched_in
> vCPU 1 sched_out      vCPU 0 sched_in
> 
> vCPU 0 sched_in may race with vCPU 1 sched_out on CPU 0's wakeup list.
> 
> 
> So, the situation is
> sched_in, sched_out: race
> sched_in, irq:       race
> sched_out, irq: mutual exclusive, do not race
> 
> 
> Hence, do you think below subclasses assignments reasonable?
> irq: subclass 0
> sched_out: subclass 1
> sched_in: subclasses 0 and 1
> 
> As inspired by Sean's solution, I made below patch to inform lockdep that the
> sched_in path involves both subclasses 0 and 1 by adding a line
> "spin_acquire(&spinlock->dep_map, 1, 0, _RET_IP_)".
> 
> I like it because it accurately conveys the situation to lockdep :)
> What are your thoughts?
> 
> Thanks
> Yan
> 
> diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
> index ec08fa3caf43..c5684225255a 100644
> --- a/arch/x86/kvm/vmx/posted_intr.c
> +++ b/arch/x86/kvm/vmx/posted_intr.c
> @@ -89,9 +89,12 @@ void vmx_vcpu_pi_load(struct kvm_vcpu *vcpu, int cpu)
>          * current pCPU if the task was migrated.
>          */
>         if (pi_desc->nv == POSTED_INTR_WAKEUP_VECTOR) {
> -               raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +               raw_spinlock_t *spinlock = &per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu);
> +               raw_spin_lock(spinlock);
> +               spin_acquire(&spinlock->dep_map, 1, 0, _RET_IP_);
>                 list_del(&vmx->pi_wakeup_list);
> -               raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +               spin_release(&spinlock->dep_map, _RET_IP_);
> +               raw_spin_unlock(spinlock);
>         }
> 
>         dest = cpu_physical_id(cpu);
> @@ -152,7 +155,7 @@ static void pi_enable_wakeup_handler(struct kvm_vcpu *vcpu)
> 
>         local_irq_save(flags);
> 
> -       raw_spin_lock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> +       raw_spin_lock_nested(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu), 1);
>         list_add_tail(&vmx->pi_wakeup_list,
>                       &per_cpu(wakeup_vcpus_on_cpu, vcpu->cpu));
>         raw_spin_unlock(&per_cpu(wakeup_vcpus_on_cpu_lock, vcpu->cpu));
> 
> 
I also agree that this is a good idea!
Best regards,
	Maxim Levitsky


