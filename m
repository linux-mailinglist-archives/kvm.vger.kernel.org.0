Return-Path: <kvm+bounces-24093-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BC20951396
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 06:50:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C87DA286164
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 04:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94BF455C3E;
	Wed, 14 Aug 2024 04:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2Ouf+ZZ+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD6755897
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 04:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723611015; cv=none; b=W4eaJfSCf3yeTjp5jCCsymFJfGjXRMPrNH3Vet8xgx/X3toQzd3rpauPjuuwkALe6hQMTC+lF7fWWSqUu2MQWu1VIA9OtnJG9fpTIR1v/o6rdfMDvOjQH4NkeZNnTRTxfszZgjJ1W5FTr5xA4ngrA3J43aceXDCMYCuE6iLWrXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723611015; c=relaxed/simple;
	bh=aZKJoxZpBCFNIdXW/1H6t9KE53GMLgszrYH1FXOYRBQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dzKOaTQCHeO7ZI6e+IefCbIIsnx4rQOTGEioEa58SNHNJiwA760vfY0BvtE7k9UhisxARmUyx8yVvnY7JH5i3ItG5JmqRtrkRxbMuHoO/TFSAY6iLhJ9TdUySmN2xM0gwAScT+fS+dPruNdDsUdijPaZz33YVMbWH+5MdbKOBg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2Ouf+ZZ+; arc=none smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-45006bcb482so32354901cf.3
        for <kvm@vger.kernel.org>; Tue, 13 Aug 2024 21:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1723611012; x=1724215812; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uSoGdag14GUjwE8MfrtIg9TLkG4ZdkRapYOpTEsirUw=;
        b=2Ouf+ZZ++4L5KhdHi1Nee+2IfabhqNVfVmUG1PtAergsMd+JEpIIth4C57bBPkYvIF
         Qsb54zXiWsM5/98EG60sg6ajqVSxm8+Jm1Z6kSr8X982oj+D6UvO0stbcMOVHZd6vlvy
         myJCOqPAJdGb55MK+B6mn3m7oxMKGk1B/qsF85kKK6SxC27k0Pi0r6bYECdTA7mLBw0O
         1yUnfaMjTniNRXQG/TBlsGEep1+FkZlH45L/U3wovApZfQXN678g6jNMxiDXy3RhM6Jo
         lQn79Rms50D4A+ua5BRZM80i7jvry4Atb1UCLsWE5JcdXzG8DfEdhPG237x0rxxbi64R
         aQ5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723611012; x=1724215812;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uSoGdag14GUjwE8MfrtIg9TLkG4ZdkRapYOpTEsirUw=;
        b=wXanmYHtDiB5QirU9neOI9UNIRiS5cDWFj3+e0WQoS5RlXX4vgGKPNnrNs0e3DLg8u
         XGHnf3iv7ZaHwf+ZbNHwv2regQpQZiA2Ji6BUU8GiZq7QvVGQEh03stjFD0eQ2CuXzpq
         NNv16lHDr1jecF/zFJ1+s05UCcyMv+cQ+O8/V7DgJJW0H+20xvSOVKJgT99QGSzM8ZbN
         JU8LZhvYtJsS+D373ephw41GyWd8mIfGTotY7tWU+xpF6T1h1U2Hv4IsOXP8H/rFezHm
         4ufXIlxo3MaLXzghhHwe+RYtbudZYFd3hAEBc0l6PlbwgOrbRn+l4+4MEgqBc3SVggJd
         o8lg==
X-Forwarded-Encrypted: i=1; AJvYcCV4J1V6CAab59g5l6NZJ8Lub7qzB2eIAHrjUyeWz+W1Dk98OgEdFhKQfHgl2oru3Ta6/GU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzogrq9Wr+Rg48QzFfWKB67DGpAfFAkucpvWiT1UjkLrC442rcH
	GRez1SqsEDw5CI+kaSPPnBfheGnCuIPmn+3UeC0JJXUkJE2jWOe3KUxoATz7MC2qyPPn+fa6yGH
	aVjG0ZQoFZl2oI40BG05Lq7YQNaIjKZGvKxpD
X-Google-Smtp-Source: AGHT+IHo2xd2uoESvpePqEtMaZ7TYJCLmgGxL+u5svF0CUp1dZ6z26Jl13T21kxG5A6Vbrgz5PgWuWz2Gcmj36SHm1A=
X-Received: by 2002:a05:622a:1b24:b0:453:5797:3658 with SMTP id
 d75a77b69052e-4535bb881b4mr17277981cf.46.1723611012292; Tue, 13 Aug 2024
 21:50:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240710074410.770409-1-suleiman@google.com> <ZqhPVnmD7XwFPHtW@chao-email>
 <Zqi2RJKp8JxSedOI@freefall.freebsd.org> <ZruSpDcysc2B-HQ-@google.com>
In-Reply-To: <ZruSpDcysc2B-HQ-@google.com>
From: Suleiman Souhlal <suleiman@google.com>
Date: Wed, 14 Aug 2024 13:50:00 +0900
Message-ID: <CABCjUKD2BAXzBZixrXKJwybEPoZvkmSPfy-vPKMbxcAt0qk0uQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Include host suspended time in steal time.
To: Sean Christopherson <seanjc@google.com>
Cc: Suleiman Souhlal <ssouhlal@freebsd.org>, Chao Gao <chao.gao@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2024 at 2:06=E2=80=AFAM Sean Christopherson <seanjc@google.=
com> wrote:
>
> On Tue, Jul 30, 2024, Suleiman Souhlal wrote:
> > On Tue, Jul 30, 2024 at 10:26:30AM +0800, Chao Gao wrote:
> > > Hi,
> > >
> > > On Wed, Jul 10, 2024 at 04:44:10PM +0900, Suleiman Souhlal wrote:
> > > >When the host resumes from a suspend, the guest thinks any task
> > > >that was running during the suspend ran for a long time, even though
> > > >the effective run time was much shorter, which can end up having
> > > >negative effects with scheduling. This can be particularly noticeabl=
e
> > > >if the guest task was RT, as it can end up getting throttled for a
> > > >long time.
> > > >
> > > >To mitigate this issue, we include the time that the host was
> > > >suspended in steal time, which lets the guest can subtract the
> > > >duration from the tasks' runtime.
> > > >
> > > >Signed-off-by: Suleiman Souhlal <suleiman@google.com>
> > > >---
> > > > arch/x86/kvm/x86.c       | 23 ++++++++++++++++++++++-
> > > > include/linux/kvm_host.h |  4 ++++
> > > > 2 files changed, 26 insertions(+), 1 deletion(-)
> > > >
> > > >diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> > > >index 0763a0f72a067f..94bbdeef843863 100644
> > > >--- a/arch/x86/kvm/x86.c
> > > >+++ b/arch/x86/kvm/x86.c
> > > >@@ -3669,7 +3669,7 @@ static void record_steal_time(struct kvm_vcpu =
*vcpu)
> > > >   struct kvm_steal_time __user *st;
> > > >   struct kvm_memslots *slots;
> > > >   gpa_t gpa =3D vcpu->arch.st.msr_val & KVM_STEAL_VALID_BITS;
> > > >-  u64 steal;
> > > >+  u64 steal, suspend_duration;
> > > >   u32 version;
> > > >
> > > >   if (kvm_xen_msr_enabled(vcpu->kvm)) {
> > > >@@ -3696,6 +3696,12 @@ static void record_steal_time(struct kvm_vcpu=
 *vcpu)
> > > >                   return;
> > > >   }
> > > >
> > > >+  suspend_duration =3D 0;
> > > >+  if (READ_ONCE(vcpu->suspended)) {
> > > >+          suspend_duration =3D vcpu->kvm->last_suspend_duration;
> > > >+          vcpu->suspended =3D 0;
> > >
> > > Can you explain why READ_ONCE() is necessary here, but WRITE_ONCE() i=
sn't used
> > > for clearing vcpu->suspended?
> >
> > Because this part of the code is essentially single-threaded, it didn't=
 seem
> > like WRITE_ONCE() was needed. I can add it in an eventual future versio=
n of
> > the patch if it makes things less confusing (if this code still exists)=
.
>
> {READ,WRITE}_ONCE() don't provide ordering, they only ensure that the com=
piler
> emits a load/store.  But (a) forcing the compiler to emit a load/store is=
 only
> necessary when it's possible for the compiler to know/prove that the load=
/store
> won't affect functionalty, and (b) this code doesn't have have the correc=
t
> ordering even if there were the appropriate smp_wmb() and smp_rmb() annot=
ations.
>
> The writer needs to ensure the write to last_suspend_duration is visible =
before
> vcpu->suspended is set, and the reader needs to ensure it reads last_susp=
end_duration
> after vcpu->suspended.
>
> That said, it's likely a moot point, because I assume the PM notifier run=
s while
> tasks are frozen, i.e. its writes are guaranteed to be ordered before
> record_steal_time().
>
> And _that_ said, I don't see any reason for two fields, nor do I see any =
reason
> to track the suspended duration in the VM instead of the vCPU.  Similar t=
o what
> Chao pointed out, per-VM tracking falls apart if only some vCPUs consume =
the
> suspend duration.  I.e. just accumulate the suspend duration directly in =
the
> vCPU.

v2 will do this.

>
> > > >+  }
> > > >+
> > > >   st =3D (struct kvm_steal_time __user *)ghc->hva;
> > > >   /*
> > > >    * Doing a TLB flush here, on the guest's behalf, can avoid
> > > >@@ -3749,6 +3755,7 @@ static void record_steal_time(struct kvm_vcpu =
*vcpu)
> > > >   unsafe_get_user(steal, &st->steal, out);
> > > >   steal +=3D current->sched_info.run_delay -
> > > >           vcpu->arch.st.last_steal;
> > > >+  steal +=3D suspend_duration;
> > > >   vcpu->arch.st.last_steal =3D current->sched_info.run_delay;
> > > >   unsafe_put_user(steal, &st->steal, out);
> > > >
> > > >@@ -6920,6 +6927,7 @@ static int kvm_arch_suspend_notifier(struct kv=
m *kvm)
> > > >
> > > >   mutex_lock(&kvm->lock);
> > > >   kvm_for_each_vcpu(i, vcpu, kvm) {
> > > >+          WRITE_ONCE(vcpu->suspended, 1);
> > > >           if (!vcpu->arch.pv_time.active)
> > > >                   continue;
> > > >
> > > >@@ -6932,15 +6940,28 @@ static int kvm_arch_suspend_notifier(struct =
kvm *kvm)
> > > >   }
> > > >   mutex_unlock(&kvm->lock);
> > > >
> > > >+  kvm->suspended_time =3D ktime_get_boottime_ns();
> > > >+
> > > >   return ret ? NOTIFY_BAD : NOTIFY_DONE;
> > > > }
> > > >
> > > >+static int
> > > >+kvm_arch_resume_notifier(struct kvm *kvm)
>
> Do not wrap before the function name.  Linus has a nice explanation/rant =
on this[*].
>
> [*] https://lore.kernel.org/all/CAHk-=3DwjoLAYG446ZNHfg=3DGhjSY6nFmuB_wA8=
fYd5iLBNXjo9Bw@mail.gmail.com
>
> > > >+{
> > > >+  kvm->last_suspend_duration =3D ktime_get_boottime_ns() -
> > > >+      kvm->suspended_time;
> > >
> > > Is it possible that a vCPU doesn't get any chance to run (i.e., updat=
e steal
> > > time) between two suspends? In this case, only the second suspend wou=
ld be
> > > recorded.
> >
> > Good point. I'll address this.
> >
> > >
> > > Maybe we need an infrastructure in the PM subsystem to record accumul=
ated
> > > suspended time. When updating steal time, KVM can add the additional =
suspended
> > > time since the last update into steal_time (as how KVM deals with
> > > current->sched_info.run_deley). This way, the scenario I mentioned ab=
ove won't
> > > be a problem and KVM needn't calculate the suspend duration for each =
guest. And
> > > this approach can potentially benefit RISC-V and ARM as well, since t=
hey have
> > > the same logic as x86 regarding steal_time.
> >
> > Thanks for the suggestion.
> > I'm a bit wary of making a whole PM subsystem addition for such a count=
er, but
> > maybe I can make a architecture-independent KVM change for it, with a P=
M
> > notifier in kvm_main.c.
>
> Yes.  Either that, or the fields need to be in kvm_vcpu_arch, not kvm_vcp=
u.
>
> > > Additionally, it seems that if a guest migrates to another system aft=
er a
> > > suspend and before updating steal time, the suspended time is lost du=
ring
> > > migration. I'm not sure if this is a practical issue.
> >
> > The systems where the host suspends don't usually do VM migrations. Or =
at
> > least the ones where we're encountering the problem this patch is tryin=
g to
> > address don't (laptops).
> >
> > But even if they did, it doesn't seem that likely that the migration wo=
uld
> > happen over a host suspend.
>
> I think we want to account for this straightaway, or at least have define=
d and
> documented behavior, else we risk rehashing the issues with marking a vCP=
U as
> preempted when it's loaded, but not running.  Which causes problems for l=
ive
> migration as it results in KVM marking the steal-time page as dirty after=
 vCPUs
> have been paused.
>
> [*] https://lkml.kernel.org/r/20240503181734.1467938-4-dmatlack%40google.=
com

Can you explain how the steal-time page could get marked as dirty after VCP=
Us
have been paused?
From what I can tell, record_steal_time() gets called from vcpu_enter_guest=
(),
which shouldn't happen when the VCPU has been paused, but I have to admit I
don't really know anything about how live migration works.
The series you linked is addressing an issue when the steal-time page
gets written
to outside of record_steal_time(), but we aren't doing this for this
proposed patch.

With the proposed approach, the steal time page would get copied to the new=
 host
and everything would keep working correctly, with the exception of a
possible host
suspend happening between when the migration started and when it finishes, =
not
being reflected post-migration.
That seems like a reasonable compromise.

Please let me know if you want more.
I am planning on sending v2 within the next few days.

Thanks,
-- Suleiman

