Return-Path: <kvm+bounces-15174-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B395F8AA4CA
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 23:41:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 67EF928239D
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 21:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD1FE199E86;
	Thu, 18 Apr 2024 21:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0oVMfoki"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E62190699
	for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 21:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713476468; cv=none; b=RMRmB6q8QqnxnqmQb+IJ6vAHrzxIv9Dn8UUjEAdJ99Rnq+Jh929oRMntUvpsnkf75g0dGSCb7r5uw7Pqh9xVNilAs1MIRNGYlx+Tn/KVdYuHM/Ronbihvj2yaaQ4hYBrhNm1fPVCx9PqYNYnU7gC/jKKIO8NLabNS8pu/Qlf2LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713476468; c=relaxed/simple;
	bh=HajAdVVq173TFVrMe3HVBPF3mqp6wg33P/kB3Fz33PM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Mn55lDzWKeBP5eE1X5+ADd+oK5QkIwJIljdyitzIBuCSc7mR5cQFMa0ih41Mjszcz9jWihFVCkKiB4CvZOzUS3ZrMuRNPFryDkLOgF2usDHxAJWrtVB8Zl1jT2e09uS6XgvgEIOjbTlj0pci7vNvabdbkfOS5rnDGtKVEqtv++c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0oVMfoki; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1e857e571f3so11740125ad.0
        for <kvm@vger.kernel.org>; Thu, 18 Apr 2024 14:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713476466; x=1714081266; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=k3g18MjHaLfP7Co+1PbifhuspnhTs9ZwatZyvEtu50c=;
        b=0oVMfokiaKJkkAJykLe/9CCB/ilEoWkyaKcuRoHZQZWn5nwjFdhFkNLNQJSxVm0R9x
         PvZ9uVbsUhHp9rFPkLAfr4Nv5Aip9Vuk9mnye2ICtkb5Bbwmz4aym/03rM/I46VP0S9p
         yWMB+Uph2X2nRPjZogbrTu3drNf3xQYVz9/jGPZbXmK6os5255CARH/z6shPdtTGuuSg
         kBq9Kf6TI3CETLYmsOhnoL8Nf5Stv4APkMW07vb0Kquq41c34/g5u6io401Dl9Ands89
         NOnJ5Z4onS9fl+Sh6DLHl1VEQ5GxAM5xalYdPT6b09ESRFqkPbCXvIH5LoO/RHPWwtPu
         tTqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713476466; x=1714081266;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k3g18MjHaLfP7Co+1PbifhuspnhTs9ZwatZyvEtu50c=;
        b=SYrPyIppdBmTk//G8c82QRkUEWnVIC7baxR7V2h7CDirzNEqx139aFuRoZmzs662NF
         lB8hwo1npcj2KY3f2UR6E27F9fSV5+eFLqzFiOcptF5GOJ0ahxC8r+9DEiMWaq6hngie
         ovMH2gXAmU+VLUgKJx/Qx3fRQgOuClYeszVRsHnXLaWvGICSXUeZVBZKOXe3RY4+Jv0g
         JPhdJcVNDfOQOHyN8/gYri8KnOxXIM4qyx7cQKIjZ1NFdmO87+NyVbmhMU4ckel3dN5T
         lQv8yPg0NLYZtU1t8yCKOvzyvlyrKM1wo3bjF0ZkqdZVDw9zXp3MQLJIpDQ6qo9je2su
         8YYA==
X-Forwarded-Encrypted: i=1; AJvYcCVpTYFWipLsRKx0GZ6PZxzVoVJ4Z8HHnWwM6al01FRAUSEvKhU2x8Iir9xs/ZgajJ/uaVlUcnroqdZ/Berep2lGmgru
X-Gm-Message-State: AOJu0YyYGWhpT8bXtkqyIWr8IwPk5SUsZjwis/Wr7izfl0sytdIaGYBI
	GYEPBbIWOCZ8J/nTI+7ZdMUurVCFkOY1s16wOMUM2xQJLwYQr7OQhiGrQBh/Xw==
X-Google-Smtp-Source: AGHT+IGNtHw+WefGddn2wQb1RWDsXpNzYBrREaEpw5HJ34CZAsgVCLPYo0LOKilpR6wr2h9x6lqY8w==
X-Received: by 2002:a17:902:daca:b0:1e2:3720:e9b4 with SMTP id q10-20020a170902daca00b001e23720e9b4mr416817plx.54.1713476465533;
        Thu, 18 Apr 2024 14:41:05 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id r3-20020a170902be0300b001e27462b988sm2003626pls.61.2024.04.18.14.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Apr 2024 14:41:04 -0700 (PDT)
Date: Thu, 18 Apr 2024 21:41:01 +0000
From: Mingwei Zhang <mizhang@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Xiong Zhang <xiong.y.zhang@linux.intel.com>, pbonzini@redhat.com,
	peterz@infradead.org, kan.liang@intel.com, zhenyuw@linux.intel.com,
	jmattson@google.com, kvm@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	zhiyuan.lv@intel.com, eranian@google.com, irogers@google.com,
	samantha.alt@intel.com, like.xu.linux@gmail.com, chao.gao@intel.com
Subject: Re: [RFC PATCH 23/41] KVM: x86/pmu: Implement the save/restore of
 PMU state for Intel CPU
Message-ID: <ZiGTbZaDo9wrx5Mt@google.com>
References: <20240126085444.324918-24-xiong.y.zhang@linux.intel.com>
 <ZhhZush_VOEnimuw@google.com>
 <18b19dd4-6d76-4ed8-b784-32436ab93d06@linux.intel.com>
 <Zhn9TGOiXxcV5Epx@google.com>
 <4c47b975-ad30-4be9-a0a9-f0989d1fa395@linux.intel.com>
 <CAL715WJXWQgfzgh8KqL+pAzeqL+dkF6imfRM37nQ6PkZd09mhQ@mail.gmail.com>
 <737f0c66-2237-4ed3-8999-19fe9cca9ecc@linux.intel.com>
 <CAL715W+RKCLsByfM3-0uKBWdbYgyk_hou9oC+mC9H61yR_9tyw@mail.gmail.com>
 <Zh1mKoHJcj22rKy8@google.com>
 <ZiGOzkLhQm57EPlx@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZiGOzkLhQm57EPlx@google.com>

On Thu, Apr 18, 2024, Mingwei Zhang wrote:
> On Mon, Apr 15, 2024, Sean Christopherson wrote:
> > On Mon, Apr 15, 2024, Mingwei Zhang wrote:
> > > On Mon, Apr 15, 2024 at 3:04 AM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
> > > > On 4/15/2024 2:06 PM, Mingwei Zhang wrote:
> > > > > On Fri, Apr 12, 2024 at 9:25 PM Mi, Dapeng <dapeng1.mi@linux.intel.com> wrote:
> > > > >>>> It's necessary to clear the EVENTSELx MSRs for both GP and fixed counters.
> > > > >>>> Considering this case, Guest uses GP counter 2, but Host doesn't use it. So
> > > > >>>> if the EVENTSEL2 MSR is not cleared here, the GP counter 2 would be enabled
> > > > >>>> unexpectedly on host later since Host perf always enable all validate bits
> > > > >>>> in PERF_GLOBAL_CTRL MSR. That would cause issues.
> > > > >>>>
> > > > >>>> Yeah,  the clearing for PMCx MSR should be unnecessary .
> > > > >>>>
> > > > >>> Why is clearing for PMCx MSR unnecessary? Do we want to leaking counter
> > > > >>> values to the host? NO. Not in cloud usage.
> > > > >> No, this place is clearing the guest counter value instead of host
> > > > >> counter value. Host always has method to see guest value in a normal VM
> > > > >> if he want. I don't see its necessity, it's just a overkill and
> > > > >> introduce extra overhead to write MSRs.
> > > > >>
> > > > > I am curious how the perf subsystem solves the problem? Does perf
> > > > > subsystem in the host only scrubbing the selector but not the counter
> > > > > value when doing the context switch?
> > > >
> > > > When context switch happens, perf code would schedule out the old events
> > > > and schedule in the new events. When scheduling out, the ENABLE bit of
> > > > EVENTSELx MSR would be cleared, and when scheduling in, the EVENTSELx
> > > > and PMCx MSRs would be overwritten with new event's attr.config and
> > > > sample_period separately.  Of course, these is only for the case when
> > > > there are new events to be programmed on the PMC. If no new events, the
> > > > PMCx MSR would keep stall value and won't be cleared.
> > > >
> > > > Anyway, I don't see any reason that PMCx MSR must be cleared.
> > > >
> > > 
> > > I don't have a strong opinion on the upstream version. But since both
> > > the mediated vPMU and perf are clients of PMU HW, leaving PMC values
> > > uncleared when transition out of the vPMU boundary is leaking info
> > > technically.
> > 
> > I'm not objecting to ensuring guest PMCs can't be read by any entity that's not
> > in the guest's TCB, which is what I would consider a true leak.  I'm objecting
> > to blindly clearing all PMCs, and more specifically objecting to *KVM* clearing
> > PMCs when saving guest state without coordinating with perf in any way.
> 
> Agree. blindly clearing PMCs is the basic implementation. I am thinking
> about what coordination between perf and KVM as well.
> 
> > 
> > I am ok if we start with (or default to) a "safe" implementation that zeroes all
> > PMCs when switching to host context, but I want KVM and perf to work together to
> > do the context switches, e.g. so that we don't end up with code where KVM writes
> > to all PMC MSRs and that perf also immediately writes to all PMC MSRs.
> 
> Sure. Point taken.
> > 
> > One my biggest complaints with the current vPMU code is that the roles and
> > responsibilities between KVM and perf are poorly defined, which leads to suboptimal
> > and hard to maintain code.
> 
> Right.
> > 
> > Case in point, I'm pretty sure leaving guest values in PMCs _would_ leak guest
> > state to userspace processes that have RDPMC permissions, as the PMCs might not
> > be dirty from perf's perspective (see perf_clear_dirty_counters()).
> > 
> 
> ah. This is a good point.
> 
> 		switch_mm_irqs_off() =>
> 		cr4_update_pce_mm() =>
> 		/*
> 		 * Clear the existing dirty counters to
> 		 * prevent the leak for an RDPMC task.
> 		 */

FYI, for the elaboration of "an RDPMC task".

when echo 2> /sys/devices/cpu/rdpmc, kernel set CR4.PCE to 1.

Once that is done, rdpmc instruction is no longer a priviledged
instruction. It is allowed for all tasks to execute in userspace.

Thanks.
-Mingwei
> 		perf_clear_dirty_counters()
> 
> So perf does clear dirty counter values on process context switch. This
> is nice to know.
> 
> perf_clear_dirty_counters() clear the counter values according to
> cpuc->dirty except for those assigned counters.
> 
> > Blindly clearing PMCs in KVM "solves" that problem, but in doing so makes the
> > overall code brittle because it's not clear whether KVM _needs_ to clear PMCs,
> > or if KVM is just being paranoid.
> 
> There is a difference between KVM and perf subsystem on PMU context
> switch. The latter has the notion of "perf_events", while the former
> currently does not. It is quite hard for KVM to know which counters are
> really "in use".
> 
> Another point I want to raise up to you is that, KVM PMU context switch
> and Perf PMU context switch happens at different timing:
> 
>  - The former is a context switch between guest/host state of the same
>    process, happening at VM-enter/exit boundary.
>  - The latter is a context switch beteen two host-level processes.
>  - The former happens before the latter.
>  - Current design has no PMC partitioning between host/guest due to
>    arch limitation.
> 
> From the above, I feel that it might be impossible to combine them or to
> add coordination? Unless we do the KVM PMU context switch at vcpu loop
> boundary...
> 
> Thanks.
> -Mingwei

