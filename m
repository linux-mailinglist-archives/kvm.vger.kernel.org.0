Return-Path: <kvm+bounces-70019-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UGF1C1wYgmmZPAMAu9opvQ
	(envelope-from <kvm+bounces-70019-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:46:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 7562CDB780
	for <lists+kvm@lfdr.de>; Tue, 03 Feb 2026 16:46:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6B61B314890A
	for <lists+kvm@lfdr.de>; Tue,  3 Feb 2026 15:41:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BB63BFE20;
	Tue,  3 Feb 2026 15:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tqrZCbXB"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840413B95FF
	for <kvm@vger.kernel.org>; Tue,  3 Feb 2026 15:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770133274; cv=none; b=jjpBmeS+22u0RIS380gGCE6HBWnPvESUta8azld57Z9dpgpOf108Wu3DBgFP0/QKaNxli2JxKkhIUpx8ZaK60o+9uQvhAibD/BkCoDu74eqQTpkklz5WMIta1hdMtFnSzGBcFOyxB8y5/xZoTnxb1Tax1BNYEEzXIT7fx4ndCa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770133274; c=relaxed/simple;
	bh=XQ27+R+QYeCRopvq+/032ZUkzbH3fabnjh5Y36ub2sY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VMvB62sPb4FmiR+ZmeEDIIx4+PFruWeO6RwbRrZbYX+3G1nwuSXw2b8xa/QOef85Z4q0ZvWGNVWiYVvrF3FMSnOZa7s5pw+JSwcr15SIUSuIrmgpG+pE6+9MJsNIo/tIMtyk+1s7VFudTfGMcXkhlZdk96Oac4RQ2d520BXNmTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tqrZCbXB; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c63597a63a6so3564067a12.3
        for <kvm@vger.kernel.org>; Tue, 03 Feb 2026 07:41:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770133272; x=1770738072; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWJ660ihJM0hSjFDBVQ0+kuafEpX+U2YAW70nt2lVVE=;
        b=tqrZCbXBaDGkR0VW2VdPuIyWs3V544Boh3N1BNjpowdFLVxMGthEdUl/e3wRCiFPrU
         /YsfJSAndm7HwHK6lrNQl+kZECIvkNijTIvDTPsA5e5+bPvBkHfB5piXAOGZV23F+hAD
         hWcSniyidiNmepw+Z6rnYsd0SIBkOmvQRXOXCRgZwzl27y7Uqjl+YWWHCIMApGyWlZ6b
         Wdb7h4NBunYcoCbcCKv0EZBF2mGHL/olD+tqZAUXoIKz1iz05pQnV56MV7ip53Nfa/JC
         ktpZt5/4hh0mRxwwON+Mp1dODmJplQ3FZCc7Is0pgoq4TlcvuQ2dinuz/3xc6sO6SO30
         MiKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770133272; x=1770738072;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XWJ660ihJM0hSjFDBVQ0+kuafEpX+U2YAW70nt2lVVE=;
        b=UTqPndl69+Pp3QcOLUT5S98DTL7oSHWjQ2J4X9hZ0Amp3oGRNVpoh+3RbGHDbqttgP
         JgRszSa3aodDXb/znP+5AraL46MN0qBdRfCISOWnt1zU4PZpDryGLYbF4lfOQzm9FSV3
         atZuLlIFXoCSCMV42o9ZJZxnXU82yIjWNNgTr1WH6bDaeeic1qww1jveA1TGH70DvCjl
         iFJp+RdLHl3jyGE/FkN6rSAyvVfRqjPW94JFT09NY+XeKCPxuwyFzzX4atVOn2x+UOrs
         BkS4NTo+eI/uqN4mGZn3ICYbbKZmohwc64OFSMdSjuq3y+H89a/iyz39Dz5ZEab/vpOY
         nKKQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+AwdGwIlw7A/ORNh2yRkqbWNXxFrq4zpnWJ1E641zNpKo+PUpQHYZ9r9EzcyhcZH2Tmo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyX4RVamaPq1hk1dNADkLhXaVVN3rkTQlncJOB9sj+XSfuP6rmH
	8iNTSOpHD0Ly4DiTWv3WdTMpv9Tfjx+QUEX5FrNFIAbNsdvVuI65WGXlKwVp+cSPHp/7GPOk0tD
	zdB5g5w==
X-Received: from pglf30.prod.google.com ([2002:a63:101e:0:b0:c66:9115:3b4d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e390:b0:38e:9220:ebbe
 with SMTP id adf61e73a8af0-392e003d35emr15312558637.23.1770133271757; Tue, 03
 Feb 2026 07:41:11 -0800 (PST)
Date: Tue, 3 Feb 2026 07:41:10 -0800
In-Reply-To: <aYHmUCLRYL+JX1ga@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260123145645.90444-1-chao.gao@intel.com> <20260123145645.90444-8-chao.gao@intel.com>
 <301f8156-bafe-440a-8628-3bf8fae74464@intel.com> <aXywVcqbXodADg4a@intel.com>
 <fedb3192-e68c-423c-93b2-a4dc2f964148@intel.com> <aYHmUCLRYL+JX1ga@intel.com>
Message-ID: <aYIXFmT-676oN6j0@google.com>
Subject: Re: [PATCH v3 07/26] x86/virt/seamldr: Introduce a wrapper for
 P-SEAMLDR SEAMCALLs
From: Sean Christopherson <seanjc@google.com>
To: Chao Gao <chao.gao@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-coco@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org, x86@kernel.org, 
	reinette.chatre@intel.com, ira.weiny@intel.com, kai.huang@intel.com, 
	dan.j.williams@intel.com, yilun.xu@linux.intel.com, sagis@google.com, 
	vannapurve@google.com, paulmck@kernel.org, nik.borisov@suse.com, 
	zhenzhong.duan@intel.com, rick.p.edgecombe@intel.com, kas@kernel.org, 
	dave.hansen@linux.intel.com, vishal.l.verma@intel.com, 
	Farrah Chen <farrah.chen@intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>
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
	TAGGED_FROM(0.00)[bounces-70019-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[25];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 7562CDB780
X-Rspamd-Action: no action

On Tue, Feb 03, 2026, Chao Gao wrote:
> >>> I'd be shocked if this is the one and only place in the whole kernel
> >>> that can unceremoniously zap VMX state.
> >>>
> >>> I'd *bet* that you don't really need to do the vmptrld and that KVM c=
an
> >>> figure it out because it can vmptrld on demand anyway. Something alon=
g
> >>> the lines of:
> >>>
> >>> 	local_irq_disable();
> >>> 	list_for_each(handwaving...)
> >>> 		vmcs_clear();
> >>> 	ret =3D seamldr_prerr(fn, args);
> >>> 	local_irq_enable();=09
> >>>
> >>> Basically, zap this CPU's vmcs state and then make KVM reload it at s=
ome
> >>> later time.
> >>=20
> >> The idea is feasible. But just calling vmcs_clear() won't work. We nee=
d to
> >> reset all the tracking state associated with each VMCS. We should call
> >> vmclear_local_loaded_vmcss() instead, similar to what's done before VM=
XOFF.
> >>=20
> >>>
> >>> I'm sure Sean and Paolo will tell me if I'm crazy.
> >>=20
> >> To me, this approach needs more work since we need to either move=20
> >> vmclear_local_loaded_vmcss() to the kernel or allow KVM to register a =
callback.
> >>=20
> >> I don't think it's as straightforward as just doing the save/restore.
> >
> >Could you please just do me a favor and spend 20 minutes to see what
> >this looks like in practice and if the KVM folks hate it?

I hate it :-)

> Sure. KVM tracks the current VMCS and only executes vmptrld for a new VMC=
S if
> it differs from the current one. See arch/x86/kvm/vmx/vmx.c::vmx_vcpu_loa=
d_vmcs()
>=20
> 	prev =3D per_cpu(current_vmcs, cpu);
> 	if (prev !=3D vmx->loaded_vmcs->vmcs) {
> 		per_cpu(current_vmcs, cpu) =3D vmx->loaded_vmcs->vmcs;
> 		vmcs_load(vmx->loaded_vmcs->vmcs);
> 	}
>=20
> By resetting current_vmcs to NULL during P-SEAMLDR calls, KVM is forced t=
o do a
> vmptrld on the next VMCS load. So, we can implement seamldr_call() as:
>=20
> static int seamldr_call(u64 fn, struct tdx_module_args *args)
> {
> 	int ret;
>=20
> 	WARN_ON_ONCE(!is_seamldr_call(fn));
>=20
> 	/*
> 	 * Serialize P-SEAMLDR calls since only a single CPU is allowed to
> 	 * interact with P-SEAMLDR at a time.
> 	 *
> 	 * P-SEAMLDR calls invalidate the current VMCS. Exclude KVM access to
> 	 * the VMCS by disabling interrupts. This is not safe against VMCS use
> 	 * in NMIs, but there are none of those today.
> 	 *
> 	 * Set the per-CPU current_vmcs cache to NULL to force KVM to reload
> 	 * the VMCS.
> 	 */
> 	guard(raw_spinlock_irqsave)(&seamldr_lock);
> 	ret =3D seamcall_prerr(fn, args);
> 	this_cpu_write(current_vmcs, NULL);
>=20
> 	return ret;
> }
>=20
> This requires moving the per-CPU current_vmcs from KVM to the kernel, whi=
ch
> should be trivial with Sean's VMXON series.

Trivial in code, but I am very strongly opposed to moving current_vmcs out =
of KVM.
As stated in the cover letter of the initial VMXON RFC[*]:

 : Emphasis on "only", because leaving VMCS tracking and clearing in KVM is
 : another key difference from Xin's series.  The "light bulb" moment on th=
at
 : front is that TDX isn't a hypervisor, and isn't trying to be a hyperviso=
r.
 : Specifically, TDX should _never_ have it's own VMCSes (that are visible =
to the
 : host; the TDX-Module has it's own VMCSes to do SEAMCALL/SEAMRET), and so=
 there
 : is simply no reason to move that functionality out of KVM.

TDX's "use" of a VMCS should be completely transparent to KVM, because othe=
rwise
we are stepping over that line that says the TDX subsystem isn't a hypervis=
or.
I also really, really don't want to add a super special case rule to KVM's =
VMCS
tracking logic.

After reading through the rest of this discussion, I'm doubling down on tha=
t
stance, because I agree that this is decidely odd behavior.

Pulling in two other threads from this discussion:

On Wed, Jan 28, 2026 at 3:05=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
>
> On 1/23/26 06:55, Chao Gao wrote:
> > SEAMRET from the P-SEAMLDR clears the current VMCS structure pointed
> > to by the current-VMCS pointer. A VMM that invokes the P-SEAMLDR
> > using SEAMCALL must reload the current-VMCS, if required, using the
> > VMPTRLD instruction.
>
> That seems pretty mean.
>
> This is going to need a lot more justification for why this is an
> absolutely necessary requirement.
>
> KVM folks, are you OK with this?

As above, I'm definitely not ok with the current VMCS being zapped out from
underneath KVM.  As to whether or not I'm ok with the P-SEAMLDR behavior, I=
 would
say that's more of a question for you, as it will fall on the TDX subsytem =
to
workaround the bug/quirk.

On Fri, Jan 30, 2026 at 8:23=E2=80=AFAM Dave Hansen <dave.hansen@intel.com>=
 wrote:
> On 1/30/26 00:08, Chao Gao wrote:
> > AFAIK, this is a CPU implementation issue. The actual requirement is to
> > evict (flush and invalidate) all VMCSs __cached in SEAM mode__, but big
> > cores implement this by evicting the __entire__ VMCS cache. So, the
> > current VMCS is invalidated and cleared.
>
> But why is this a P-SEAMLDR thing and not a TDX module thing?

My guess is that it's because the P-SEAMLDR code loads and prepares the new=
 TDX-
Module by constructing the VMCS used for SEAMCALL using direct writes to me=
mory
(unless that TDX behavior has changed in the last few years).  And so it ne=
eds
to ensure that in-memory representation is synchronized with the VMCS cache=
.

Hmm, but that doesn't make sense _if_ it really truly is SEAMRET that does =
the VMCS
cache invalidation, because flushing the VMCS cache would ovewrite the in-m=
emory
state.

> It seems like a bug, or at least a P-SEAMLDR implementation issue the
> needs to get fixed.

Yeah, 'tis odd behavior.  IMO, that's all the more reason the TDX subsystem=
 should
hide the quirk from the rest of the kernel.

[*] https://lore.kernel.org/all/20251010220403.987927-1-seanjc@google.com

