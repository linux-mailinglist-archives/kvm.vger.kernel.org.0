Return-Path: <kvm+bounces-72073-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sD/vDFOhoGlVlAQAu9opvQ
	(envelope-from <kvm+bounces-72073-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:38:59 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 897F81AE7E0
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 20:38:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 36D8831AD5A0
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 19:32:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C201A44CF51;
	Thu, 26 Feb 2026 19:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NpjF6RHt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8B144E02F
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 19:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772134269; cv=none; b=el2bNCAQIQUR+PA1IUYVcZotH9382iuX8h4mrL/DUrvaPgYs18yMCZTqzTfY3BeUDxKPqL/t69IVK9Rt6todULNql5nGbP/6Ji8P+5V3ve3QdIKqCw5e5UdMT2YKT3NcxMqME1bbbBM8Glo+/+vp260pP5/ylqaxT6doP7CkCUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772134269; c=relaxed/simple;
	bh=7npd9tyd1xyz0W3kxuTvPbP2Ku0X4fbvz4wieBxiuu4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pXWb97LGfDRZGX5FXRrVWFUBJNQjM51lX81NRbHUQuuJ+ltNn7XJmDAeUxj+HT/2SjbpgGA85OVOkbp3N9kp1ITf54aoxDxE/EZ8bevV69GhR0xYNRjMx5oILOToDUpa1VxVTMM8uuB4U8VDQ6mBIXtPZDJyBB7BPa1QpxYsoIM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NpjF6RHt; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c70f137aa4aso640935a12.2
        for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 11:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772134262; x=1772739062; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ce8oFKsmBFWAiBnyfUlbpaUHm9SVUDVrI9bHqHsCJH0=;
        b=NpjF6RHtEUjZCXqyS5hxuRG7zDaNiGksgMPhLq5ZduB/L9WtkMFTS5yfXoHHmaevXf
         EEp10lg7+/OYQXOkA/cNsIeUO5cORmkO+viDevH03vMDrfG9wJ9v5ml8RyGAJ+KOcj7b
         b/cze09W7ZEFjAU0ffGl9vJic4Ib6TES4bDQJNlGyF/DlKeCie/Nxis5PwPjTOarD62U
         pqvsFoDLlIV9ZQYgM0prPWZOwqvQJoo/Sqg0y+V2fhLJkdmzNoFib5CzgBY+eCXIp8yy
         LH8+rrxJP8QturFqnDksutqAtcKHDj3ZfMFfPixXNcS7KAySN93yrNoWcUivUhUU3I6b
         TDZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772134262; x=1772739062;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ce8oFKsmBFWAiBnyfUlbpaUHm9SVUDVrI9bHqHsCJH0=;
        b=fKMGp8n/Cm1/P+lYpFlnq6+eMqTyjebqahYI6XE5Gnzd04Mg9LDm4sU/78AUtPAfxW
         nBKUJQjPq3AozJLLIuQm4m7aVuSbM3noBc5URrlulacyQRAcNum5Gk5bfuanXwQRH73I
         W8GiC45HR0nDxa3AI7gDL8XuUVV7XJVojnYRzju+4lwF0vdxhUd0SGFu4tF+pVDi/Wnm
         nEPfGzcQjZ/Ihl2Poks6bJyhHswynUMfQmIGitDHqdmrwRJ0eI2eOb5vjVIb+wiKHtrZ
         yc2k9GhhLneUNI7IGH/I5p1ohFKR0sPrl/tGjTGn9DPJ2ByfHcEDe869NioJSvGjRT+I
         N7IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXQPjCU+/rNd7pLQ7dXxSVqL+y+9WB/3JaofbMkCEOgjCxElc+ILbsWEgSn3Dhxy9B5Cl8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxLXOQ/oFvfNQXUiWO79e8GozvYA37399UUCp4o5zAQZse4gwgo
	CTd+N3ff1/ntCrZaP+Ss8jRsifcl8346ICbpjUpAAP8DBzFHYle8CJc+Co4sd2up10kghSSvGbn
	r3tyCkA==
X-Received: from pgbdk13.prod.google.com ([2002:a05:6a02:c8d:b0:c6e:7278:d9e1])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e40a:b0:32d:a91a:7713
 with SMTP id adf61e73a8af0-395c3af1f03mr327981637.40.1772134261378; Thu, 26
 Feb 2026 11:31:01 -0800 (PST)
Date: Thu, 26 Feb 2026 11:30:59 -0800
In-Reply-To: <64a01647-2f99-44a8-a183-702d6eb6fd81@fortanix.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <d98692e2-d96b-4c36-8089-4bc1e5cc3d57@fortanix.com>
 <aZ9V_O5SGGKa-Vdn@google.com> <928a31e1-bb6f-44d4-b1de-654d6968fd55@fortanix.com>
 <aZ9Zs0laC2p5W-OL@google.com> <64a01647-2f99-44a8-a183-702d6eb6fd81@fortanix.com>
Message-ID: <aaCfcwdA1E4V5qgE@google.com>
Subject: Re: [PATCH] KVM: SEV: Track SNP launch state and disallow invalid
 userspace interactions
From: Sean Christopherson <seanjc@google.com>
To: Jethro Beekman <jethro@fortanix.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-72073-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 897F81AE7E0
X-Rspamd-Action: no action

On Wed, Feb 25, 2026, Jethro Beekman wrote:
> On 2026-02-25 12:21, Sean Christopherson wrote:
> > On Wed, Feb 25, 2026, Jethro Beekman wrote:
> >> On 2026-02-25 12:05, Sean Christopherson wrote:
> >>> On Mon, Jan 19, 2026, Jethro Beekman wrote:
> >>>> Calling any of the SNP_LAUNCH_ ioctls after SNP_LAUNCH_FINISH result=
s in a
> >>>> kernel page fault due to RMP violation. Track SNP launch state and e=
xit early.
> >>>
> >>> What exactly trips the RMP #PF?  A backtrace would be especially help=
ful for
> >>> posterity.
> >>
> >> Here's a backtrace for calling ioctl(KVM_SEV_SNP_LAUNCH_FINISH) twice.=
 Note this is with a modified version of QEMU.
> >=20
> >> RIP: 0010:sev_es_sync_vmsa+0x54/0x4c0 [kvm_amd]
> >>  snp_launch_update_vmsa+0x19d/0x290 [kvm_amd]
> >>  snp_launch_finish+0xb6/0x380 [kvm_amd]
> >>  sev_mem_enc_ioctl+0x14e/0x720 [kvm_amd]
> >>  kvm_arch_vm_ioctl+0x837/0xcf0 [kvm]
> >=20
> > Ah, it's the VMSA that's being accessed.  Can't we just do?
> >=20
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index 723f4452302a..1e40ae592c93 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -882,6 +882,9 @@ static int sev_es_sync_vmsa(struct vcpu_svm *svm)
> >         u8 *d;
> >         int i;
> > =20
> > +       if (vcpu->arch.guest_state_protected)
> > +               return -EINVAL;
> > +
> >         /* Check some debug related fields before encrypting the VMSA *=
/
> >         if (svm->vcpu.guest_debug || (svm->vmcb->save.dr7 & ~DR7_FIXED_=
1))
> >                 return -EINVAL;
>=20
> I tried relying on guest_state_protected instead of creating new state bu=
t I
> don't think it's sufficient. In particular, your proposal may fix
> snp_launch_finish()=20

But it does fix that case, correct?  I don't want to complicate one fix jus=
t
because there are other bugs that are similar but yet distinct.

> but I don't believe this addresses the issues in snp_launch_update() and

Do you mean snp_launch_update_vmsa() here?  Or am I missing an interaction =
with
vCPUs in snp_launch_update()?

> sev_vcpu_create().

There are a pile of SEV lifecycle and locking issues, i.e. this is just one=
 of
several flaws.  Fixing the locking has been on my todo list for a few month=
s (we
found some "fun" bugs with an internal run of syzkaller), and I'm finally g=
etting
to it.  Hopefully I'll post a series early next week.

Somewhat off the cuff, but I think the easiest way to close the race betwee=
n
KVM_CREATE_VCPU and KVM_SEV_SNP_LAUNCH_FINISH is to reject KVM_SEV_SNP_LAUN=
CH_FINISH
if a vCPU is being created.  Or did I misunderstand the race you're pointin=
g out?

Though unless there's a strong reason not to, I'd prefer to get greedy and =
block
all of sev_mem_enc_ioctl(), e.g.

11:23:23 =E2=9C=94 ~/go/src/kernel.org/linux $ gdd
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index ea515cf41168..2b1033c0ec54 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2047,8 +2047,8 @@ static int sev_check_source_vcpus(struct kvm *dst, st=
ruct kvm *src)
        struct kvm_vcpu *src_vcpu;
        unsigned long i;
=20
-       if (src->created_vcpus !=3D atomic_read(&src->online_vcpus) ||
-           dst->created_vcpus !=3D atomic_read(&dst->online_vcpus))
+       if (kvm_is_vcpu_creation_in_progress(src) ||
+           kvm_is_vcpu_creation_in_progress(dst))
                return -EBUSY;
=20
        if (!sev_es_guest(src))
@@ -2596,6 +2596,11 @@ int sev_mem_enc_ioctl(struct kvm *kvm, void __user *=
argp)
                goto out;
        }
=20
+       if (kvm_is_vcpu_creation_in_progress(kvm)) {
+               r =3D -EBUSY;
+               goto out;
+       }
+
        /*
         * Once KVM_SEV_INIT2 initializes a KVM instance as an SNP guest, o=
nly
         * allow the use of SNP-specific commands.
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 2c7d76262898..60ca5222e1e5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1032,6 +1032,13 @@ static inline struct kvm_vcpu *kvm_get_vcpu_by_id(st=
ruct kvm *kvm, int id)
        return NULL;
 }
=20
+static inline bool kvm_is_vcpu_creation_in_progress(struct kvm *kvm)
+{
+       lockdep_assert_held(&kvm->lock);
+
+       return kvm->created_vcpus !=3D atomic_read(&kvm->online_vcpus);
+}
+
 void kvm_destroy_vcpus(struct kvm *kvm);
=20
 int kvm_trylock_all_vcpus(struct kvm *kvm);

