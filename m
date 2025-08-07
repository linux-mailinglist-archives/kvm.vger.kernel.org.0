Return-Path: <kvm+bounces-54256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F4089B1D919
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 15:31:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BEEB51782EA
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 13:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E47F125C82D;
	Thu,  7 Aug 2025 13:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="U+acAYC0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC86A2550AD
	for <kvm@vger.kernel.org>; Thu,  7 Aug 2025 13:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754573465; cv=none; b=Pe3RAdiD9nPCA6Oya1bwa/mHTbKzyaFw2FzguZBGSWv/t3Eg+Dcq25OIsPlgtotmp5xBQFmJX7fX6iQuIxDDCtzBzWiIaes4FQVJts+3I55X2F2/z7E/th2U3cRfV/aRKcIUnJFI2CmgdgxYNe9E9omePzvHRf020a0XgRxcCqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754573465; c=relaxed/simple;
	bh=d/kKAEtIIyJ0bQh3buKpp4Wr2OJkvH7JeyS+N3tuwHA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t+O5qU+f6cKWEVhxd9inus0+Wv0oxeGijLmrIHX/CRxynmowWw4QR6oibg9VeXnrDujmlK7P7ADh5s9WuJrSZKNZXEXK7UOGCwUKCxakSapf9VwxT2s03F1PzTXOG6hanEOlynijNQpi0rciDo2urUhewy4Ff6aL0NnCRJzWoyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=U+acAYC0; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f4d0f60caso1126444a91.1
        for <kvm@vger.kernel.org>; Thu, 07 Aug 2025 06:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754573463; x=1755178263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m9K3KPRGz9FryMMa95mgTHuiYVPTsY16w0q5qkSOZls=;
        b=U+acAYC0VaVRvkWl+Tr/aexSzMYSVEz4HGuIiSsNB+np3rGNdpzaMcRjnCrZQ2VigH
         3LQbvio3Xo1KP4UzIwYMt6MRX2k+d7qANQfl78fVqB+5EdlL1C+QfXjFVETvIAJ+Yhob
         W/aZe/jxoH4fm1EF0LHrepFbzUcaiaZ5hWHqFchOKrR60GA4KxXwul5IZEU1eDT6YV2Y
         TkepQWRDaNh5G6inC/FuEcBpjKWHjtK0N0GFf/i6jsk0SooLZ0uviM6CvRIgX/wgAtKo
         DgtXmWCP893VlAKqoREyjM9wM+vQ6BPWNX9J1MvYe/16m7cApcXDJw7e1h4dWzAR0eOe
         Szog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754573463; x=1755178263;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m9K3KPRGz9FryMMa95mgTHuiYVPTsY16w0q5qkSOZls=;
        b=Ber5Lpg5s8H9NeDnhNqG4KdklHvZ0PIYtvTAusANaCfoyP7rSm5iGR6pSPB9StRsNX
         YVEcGZHbA4HheKeI/Svxh/QTR/5Czwrmf5eCv5QQ+xQAi2LklN8rA0h+E000hkF1x2L3
         2ozk85eaKIl27lywKHRCdQgUpY8I2C1s4goDT6N+GO44okKW0CJJDS/vK586QdDmwdfs
         dxXD0gpy7WyclU2V0CLLZB0h1oxN4CIH5DW/Keoxas2F1wURaBjX4eyKj4j+a1fgv9yR
         bube1UKzPnUTaicNZrusycOFErsDECuLhp+JyeOYxIq/jjT+iI5FKxTUH72KtdjAvwRi
         9/DQ==
X-Forwarded-Encrypted: i=1; AJvYcCURjN8Deo9f8jjYY2u9PYb5gmzs3QqdU9MSxH1IbhbeSe7pIGiykPslIWvq3gCnuN8eVhU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4T/3LkW+egSQd51WAbBhyEr1w9J5G+0QjHBzfvlF0CrAuI/xA
	QA8IUIebzJwjGsyt2umMDNcOgrP2RU2f5KKb4Iw6515JSZ4if/bJjPf0T+uHo50Repj90ewNsyZ
	7vhYtJQ==
X-Google-Smtp-Source: AGHT+IGVx/b9/DE76huBvcgdMopzzQiNlanWWyUNo4hp0Ku1LZFsRYEWrghOh2bi1IKsFzfcbKTDAkY9OZ4=
X-Received: from pjbnw14.prod.google.com ([2002:a17:90b:254e:b0:31e:3c57:ffc8])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:55cc:b0:312:39c1:c9cf
 with SMTP id 98e67ed59e1d1-32166c164d8mr8817588a91.7.1754573462916; Thu, 07
 Aug 2025 06:31:02 -0700 (PDT)
Date: Thu, 7 Aug 2025 06:31:00 -0700
In-Reply-To: <515a5221-dbcd-45cc-bc55-887ae70b63db@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250805190526.1453366-1-seanjc@google.com> <20250805190526.1453366-18-seanjc@google.com>
 <e64951b0-4707-42ed-abf4-947def74ea34@linux.intel.com> <aJOR4Bk3DwKSVdQV@google.com>
 <515a5221-dbcd-45cc-bc55-887ae70b63db@linux.intel.com>
Message-ID: <aJSqlMViOHAHHyCq@google.com>
Subject: Re: [PATCH 17/18] KVM: x86: Push acquisition of SRCU in fastpath into kvm_pmu_trigger_event()
From: Sean Christopherson <seanjc@google.com>
To: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xin Li <xin@zytor.com>, Sandipan Das <sandipan.das@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Thu, Aug 07, 2025, Dapeng Mi wrote:
> 
> On 8/7/2025 1:33 AM, Sean Christopherson wrote:
> > On Wed, Aug 06, 2025, Dapeng Mi wrote:
> >> On 8/6/2025 3:05 AM, Sean Christopherson wrote:
> >>> Acquire SRCU in the VM-Exit fastpath if and only if KVM needs to check the
> >>> PMU event filter, to further trim the amount of code that is executed with
> >>> SRCU protection in the fastpath.  Counter-intuitively, holding SRCU can do
> >>> more harm than good due to masking potential bugs, and introducing a new
> >>> SRCU-protected asset to code reachable via kvm_skip_emulated_instruction()
> >>> would be quite notable, i.e. definitely worth auditing.
> >>>
> >>> E.g. the primary user of kvm->srcu is KVM's memslots, accessing memslots
> >>> all but guarantees guest memory may be accessed, accessing guest memory
> >>> can fault, and page faults might sleep, which isn't allowed while IRQs are
> >>> disabled.  Not acquiring SRCU means the (hypothetical) illegal sleep would
> >>> be flagged when running with PROVE_RCU=y, even if DEBUG_ATOMIC_SLEEP=n.
> >>>
> >>> Note, performance is NOT a motivating factor, as SRCU lock/unlock only
> >>> adds ~15 cycles of latency to fastpath VM-Exits.  I.e. overhead isn't a
> >>> concern _if_ SRCU protection needs to be extended beyond PMU events, e.g.
> >>> to honor userspace MSR filters.
> >>>
> >>> Signed-off-by: Sean Christopherson <seanjc@google.com>
> >>> ---
> > ...
> >
> >>> @@ -968,12 +968,14 @@ static void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu,
> >>>  			     (unsigned long *)&pmu->global_ctrl, X86_PMC_IDX_MAX))
> >>>  		return;
> >>>  
> >>> +	idx = srcu_read_lock(&vcpu->kvm->srcu);
> >> It looks the asset what "kvm->srcu" protects here is
> >> kvm->arch.pmu_event_filter which is only read by pmc_is_event_allowed().
> >> Besides here, pmc_is_event_allowed() is called by reprogram_counter() but
> >> without srcu_read_lock()/srcu_read_unlock() protection.
> > No, reprogram_counter() is only called called in the context of KVM_RUN, i.e. with
> > the vCPU loaded and thus with kvm->srcu already head for read (acquired by
> > kvm_arch_vcpu_ioctl_run()).
> 
> Not sure if I understand correctly, but KVM_SET_PMU_EVENT_FILTER ioctl is a
> VM-level ioctl and it can be set when vCPUs are running. So assume
> KVM_SET_PMU_EVENT_FILTER ioctl is called at vCPU0 and vCPU1 is running
> reprogram_counter(). Is it safe without srcu_read_lock()/srcu_read_unlock()
> protection?

No, but reprogram_counter() can be reached if and only if the CPU holds SRCU.

  kvm_arch_vcpu_ioctl_run() => 	kvm_vcpu_srcu_read_lock(vcpu);
  |
  -> vcpu_run()
     |
     -> vcpu_enter_guest()
        |
        -> kvm_pmu_handle_event()
           |
           -> reprogram_counter()

