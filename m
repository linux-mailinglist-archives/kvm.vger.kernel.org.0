Return-Path: <kvm+bounces-34021-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D0F89F5B26
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 01:09:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D84361632DB
	for <lists+kvm@lfdr.de>; Wed, 18 Dec 2024 00:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5F741F5E6;
	Wed, 18 Dec 2024 00:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f2Zl5Frd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E7F849C
	for <kvm@vger.kernel.org>; Wed, 18 Dec 2024 00:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734480534; cv=none; b=KbW7OYjEffskbDA6h2LUiG7kfy8HMOWFh/+LSM6fKxBCNy1rOly8NuryiWvfirTXUIYdT8R1NOZJvYx7QALAZ8vI5WL9EJRFdxoLVFfAKY6CEEtVexZcyLr6Lam7K1Ac244e7fzgYboEP9vb4J92C+6liS66mnARkx0UfBvajDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734480534; c=relaxed/simple;
	bh=819FU1wiAUMOWiJQFB9FgeD5FIeU4rwuObZZxfUlWYA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=u5pBHQmZcvG2Nv3MKSQh6AsvCEbuimePUSMW/QKivvjnpnOgznrp+cdyuVjWTuaPPBB8AQBWkbzi+ELZOnrxlVcITqp4v4u4avQ83C4Bufqay13re7SFB/rIUMGb5vU789tokPyksmQ1tQeM1nvVHbiVOp9V1lY6zrg+37PWdX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f2Zl5Frd; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2f2a9743093so3337852a91.3
        for <kvm@vger.kernel.org>; Tue, 17 Dec 2024 16:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734480531; x=1735085331; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=st2IAj6IOBo51GPhAmFtzPu7zBrruXbW4TvInWYdQ6A=;
        b=f2Zl5FrdrSuUvme64HJARqJLh7FS5Bcj9XwgKuB4R8zYyBuO0CNTCWBGHUY9kTdfAB
         PLaMBdNJTN8rf8wlg2PiilYpwLnrmivsfRzTsBGCvtz1EKOjp/otyjwNznDPuVprekZM
         V9yKrCYmEdmHcj/JzzDAuEkYTcHGqFaP78HSQrmzpAGjs+HMmy9gY7z4tYKJRB2vyLh+
         Oe7qPJSKUED10KUUo3cNlAygSU2dXACQBwMxFVJemoendjaZ3+95twSXIS0ASs0ZNfdU
         YHIbETV/d9ZkVQLxGxGrBA5gZrq3kV5hOsqiGG7QwaS1NVaKooLQMN5r8I9RisHdU6eF
         KcMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734480531; x=1735085331;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=st2IAj6IOBo51GPhAmFtzPu7zBrruXbW4TvInWYdQ6A=;
        b=lRxepMp2kMmS1rCTOeLkn/AuxrSShYD+ahBg2z+9eW91NcMPTzKfvCbJF9eDJwy7sw
         mLIQ0TkALez7cWpV6iU2+AfH6FfviggnFMMHzmucPdBB+IPOPjMBo1IHcfO/yAuU2Ngx
         lvT4yW08Yu0CCd6Cu35JN6gp0eDsv+TuckbLndyvblsPAaLiwlNrnQ+g6l92XNtgfGco
         MKmDkbH9Ul84B0Fh8PYleXHrJSnNar5zNEpprWSRjO4l8EbicIGIXbTvOfOlmFPQ798o
         9WFAngTyvsIUQc0wi4YDkkhuiUn8nGu/OMd3XKO2THXzcVewH9DHlTCnykF+wmk9/pyC
         n8RA==
X-Forwarded-Encrypted: i=1; AJvYcCWticTxHJs7kMsDKECgvb1UXzKyB/j5GcgtigSR3liVzk8iZCS+LrRio+8VvC56qDCFouM=@vger.kernel.org
X-Gm-Message-State: AOJu0YzPBFdR3adetOHxHohR3i7+k/BvNPKf0/XneZbVjWY2vW0VN1KR
	T4FGbCf6TjjXiT0HHKBAHj5yMNUgyVLzSTo3qa4xBvvIFuMeyBnN/fEkdC4FZzqAQOMWZwRBwGX
	B3Q==
X-Google-Smtp-Source: AGHT+IEvw+3WTZ19MkBtE5+J2V7DUw5s6WfLWarD7KcORBXUM2PQBWzwSUsIh3pqEldb+UbEIvQfqAeEFdI=
X-Received: from pjbst15.prod.google.com ([2002:a17:90b:1fcf:b0:2ef:94c6:5048])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:350f:b0:2ee:b666:d14a
 with SMTP id 98e67ed59e1d1-2f2e91f813amr1345849a91.17.1734480531629; Tue, 17
 Dec 2024 16:08:51 -0800 (PST)
Date: Tue, 17 Dec 2024 16:08:50 -0800
In-Reply-To: <3ef942fa615dae07822e8ffce75991947f62f933.camel@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <43b26df1-4c27-41ff-a482-e258f872cc31@intel.com>
 <d63e1f3f0ad8ead9d221cff5b1746dc7a7fa065c.camel@intel.com>
 <e7ca010e-fe97-46d0-aaae-316eef0cc2fd@intel.com> <269199260a42ff716f588fbac9c5c2c2038339c4.camel@intel.com>
 <Z2DZpJz5K9W92NAE@google.com> <3ef942fa615dae07822e8ffce75991947f62f933.camel@intel.com>
Message-ID: <Z2INi480K96q2m5S@google.com>
Subject: Re: (Proposal) New TDX Global Metadata To Report FIXED0 and FIXED1
 CPUID Bits
From: Sean Christopherson <seanjc@google.com>
To: Rick P Edgecombe <rick.p.edgecombe@intel.com>
Cc: Kai Huang <kai.huang@intel.com>, 
	"binbin.wu@linux.intel.com" <binbin.wu@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, Yan Y Zhao <yan.y.zhao@intel.com>, 
	"tony.lindgren@linux.intel.com" <tony.lindgren@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, 
	"pbonzini@redhat.com" <pbonzini@redhat.com>, Isaku Yamahata <isaku.yamahata@intel.com>, 
	"qemu-devel@nongnu.org" <qemu-devel@nongnu.org>, Adrian Hunter <adrian.hunter@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2024, Rick P Edgecombe wrote:
> On Mon, 2024-12-16 at 17:53 -0800, Sean Christopherson wrote:
> > Every new feature that lands in hardware needs to either be "benign" or=
 have the
> > appropriate virtualization controls.=C2=A0 KVM already has to deal with=
 cases where
> > features can effectively be used without KVM's knowledge.=C2=A0 E.g. th=
ere are plenty
> > of instruction-level virtualization holes, and SEV-ES doubled down by e=
ssentially
> > forcing KVM to let the guest write XCR0 and XSS directly.
>=20
> We discussed this in the PUCK call.

Argh, I had a response to Xiaoyao all typed up and didn't hit "send" earlie=
r today.

> It turns out there were two different ideas on how this fixed bit API wou=
ld be
> used. One is to help userspace understand which configurations are possib=
le. For
> this one, I'm not sure how helpful this proposal will be in the long run.=
 I'll
> respond on the other branch of the thread.
>=20
> The other usage people were thinking of, which I didn't realize before, w=
as to
> prevent the TDX module from setting fixed bits that might require VMMs su=
pport
> (i.e. save/restoring something that could affect the host). The rest of t=
he mail
> is about this issue.
>=20
> Due to the steps involved in resolving this confusion, and that we didn't=
 really
> reach a conclusion, the discussion is hard to summarize. So instead I'll =
try to
> re-kick it off with an idea which has bits and pieces of what people said=
...
>=20
> I think we can't have the TDX module setting new fixed bits that require =
any VMM
> enabling. When we finally have settled upstream TDX support, the TDX modu=
le
> needs to understand what things KVM relies on so it doesn't break them wi=
th
> updates. But new fixed CPUID bits that require VMM enabling to prevent ho=
st
> issues seems like the kind of thing in general that just shouldn't happen=
.
>=20
> As for new configurable bits that require VMM enabling. Adrian was sugges=
ting
> that the TDX module currently only has two guest CPUID bits that are prob=
lematic
> for KVM today (and the next vcpu enter/exit series has a patch to forbid =
them).
> But a re-check of this assertion is warranted.
>=20
> It seems like an anti-pattern to have KVM maintaining any code to defend =
against
> TDX module changes that could instead be handled with a promise.=20

I disagree, sanity checking hardware and firmware is a good thing.  E.g. se=
e KVM's
VMCS checks, the sanity checks for features SEV depends on, etc.

That said, I'm not terribly concerned about more features that are uncondit=
ionally
exposed to the guest, because that will cause problems for other reasons, i=
.e.
Intel should already be heavily incentivized to not do silly things.

> However, KVM having code to defend against userspace prodding the TDX mod=
ule
> to do something bad to the host seems valid. So fixed bit issues should b=
e
> handled with a promise, but issues related to new configurable bits seems
> open.
>=20
> Some options discussed on the call:
>=20
> 1. If we got a promise to require any new CPUID bits that clobber host st=
ate to
> require an opt-in (attributes bit, etc) then we could get by with a promi=
se for
> that too. The current situation was basically to assume TDX module wouldn=
't open
> up the issue with new CPUID bits (only attributes/xfam).
> 2. If we required any new configurable CPUID bits to save/restore host st=
ate
> automatically then we could also get by, but then KVM's code that does ho=
st
> save/restore would either be redundant or need a TDX branch.
> 3. If we prevent setting any CPUID bits not supported by KVM, we would ne=
ed to
> track these bits in KVM. The data backing GET_SUPPORTED_CPUID is not suff=
icient
> for this purpose since it is actually more like "default values" then a m=
ask of
> supported bits. A patch to try to do this filtering was dropped after ups=
tream
> discussion.[0]

The only CPUID bits that truly matter are those that are associated with ha=
rdware
features the TDX module allows the guest to use directly.  And for those, K=
VM
*must* know if they are fixed0 (inverted polarity only?), fixed1, or config=
urable.
As Adrian asserted, there probably aren't many of them.

For all other CPUID bits, what the TDX Module thinks and/or presents to the=
 guest
is completely irrelevant, at least as far as KVM cares, and to some extent =
as far
as QEMU cares.  This includes the TDX Module's FEATURE_PARAVIRT_CTRL, which=
 frankly
is asinine and should be ignored.  IMO, the TDX Module spec is entirely off=
 the
mark in its assessment of paravirtualization.  Injecting a #VE instead of a=
 #GP
isn't "paravirtualization".
=20
Take TSC_DEADLINE as an example.  "Disabling" the feature from the guest's =
side
simply means that WRMSR #GPs instead of #VEs.  *Nothing* has changed from K=
VM's
perspective.  If the guest makes a TDVMCALL to write IA32_TSC_DEADLINE, KVM=
 has
no idea if the guest has opted in/out of #VE vs #GP.  And IMO, a sane guest=
 will
never take a #VE or #GP if it wants to use TSC_DEADLINE; the kernel should =
instead
make a direct TDVMCALL and save itself a pointless exception.

  Enabling Guest TDs are not allowed to access the IA32_TSC_DEADLINE MSR di=
rectly.
  Virtualization of IA32_TSC_DEADLINE depends on the virtual value of
  CPUID(1).ECX[24] bit (TSC Deadline). The host VMM may configure (as an in=
put to
  TDH.MNG.INIT) virtual CPUID(1).ECX[24] to be a constant 0 or allow it to =
be 1
  if the CPU=E2=80=99s native value is 1.

  If the TDX module supports #VE reduction, as enumerated by TDX_FEATURES0.=
VE_REDUCTION
  (bit 30), and the guest TD has set TD_CTLS.REDUCE_VE to 1, it may control=
 the
  value of virtual CPUID(1).ECX[24] by writing TDCS.FEATURE_PARAVIRT_CTRL.T=
SC_DEADLINE.=20

  =E2=80=A2 If the virtual value of CPUID(1).ECX[24] is 0, IA32_TSC_DEADLIN=
E is virtualized
    as non-existent. WRMSR or RDMSR attempts result in a #GP(0).

  =E2=80=A2 If the virtual value of CPUID(1).ECX[24] is 1, WRMSR or RDMSR a=
ttempts result
    in a #VE(CONFIG_PARAVIRT). This enables the TD=E2=80=99s #VE handler.

Ditto for TME, MKTME.

FEATURE_PARAVIRT_CTRL.MCA is even weirder, but I still don't see any reason=
 for
KVM or QEMU to care if it's fixed or configurable.  There's some crazy logi=
c for
whether or not CR4.MCE can be cleared, but the host can't see guest CR4, an=
d so
once again, the TDX Module's view of MCA is irrelevant when it comes to han=
dling
TDVMCALL for the machine check MSRs.

So I think this again purely comes to back to KVM correctness and safety.  =
More
specifically, the TDX Module needs to report features that are unconditiona=
lly
enabled or disabled and can't be emulated by KVM.  For everything else, I d=
on't
see any reason to care what the TDX module does.

I'm pretty sure that gives us a way forward.  If there only a handful of fe=
atures
that are unconditionally exposed to the guest, then KVM forces those featur=
es in
cpu_caps[*].  I.e. treat them kinda like XSAVES on AMD, where KVM assumes t=
he
guest can use XSAVES if it's supported in hardware and XSAVE is exposed to =
the
guest, because AMD didn't provide an interception knob for XSAVES.

If the list is "too" long (sujbective) for KVM to hardcode, then we revisit=
 and
get the TDX module to provide a list.

This probably doesn't solve Xiaoyao's UX problem in QEMU, but I think it gi=
ves
us a sane approach for KVM.

[*] https://lore.kernel.org/all/20241128013424.4096668-1-seanjc@google.com

> Other idea
> ----------
> Previously we tried to maintain an allow list of KVM supported configurab=
le bits
> [0]. It was do-able, but not ideal. It would be smaller for KVM to protec=
t
> itself with a deny list of bits, or rather a list of bits that needs to b=
e in
> KVM_GET_SUPPORTED_CPUID, or they should not be allowed to be configured. =
But KVM
> can't keep a list of bits that it doesn't know about.
>=20
> But the TDX module does know which bits that it supports result in host s=
tate
> getting clobbered. So we could ask TDX module to expose a list of bits th=
at have
> an effect on host state. We could check those against KVM_GET_SUPPORTED_C=
PUID.
> That check could be expected to fit better than when we tried to massage
> KVM_GET_SUPPORTED_CPUID to be a mask that includes all possible configura=
ble
> bits (multi-bit fields, etc).
>=20
> In the meantime we could keep a list of all of today's host affecting bit=
s. TDX
> module would need to gate any new bits that effect host state behind a ne=
w sys-
> wide opt-in that comes with the "clobber bits" metadata. Before entering =
a TD,
> KVM would check the clobber bits in KVM's copy of CPUID against the TD's =
copy to
> make sure everyone knows what they have to do.
>=20
> (and also this opt-in stuff would need to be run by the TDX module team o=
f
> course)
>=20
> It leaves open the possibility that there is some other bits KVM cares ab=
out
> that don't have to do with clobbering host state. Not sure about it.
>=20
> [0]
> https://lore.kernel.org/kvm/20240812224820.34826-26-rick.p.edgecombe@inte=
l.com/

