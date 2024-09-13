Return-Path: <kvm+bounces-26834-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED499785C6
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 18:29:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C98891F21E90
	for <lists+kvm@lfdr.de>; Fri, 13 Sep 2024 16:29:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3D5770E4;
	Fri, 13 Sep 2024 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KHtxVXwx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A16F45644E
	for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 16:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726244965; cv=none; b=t+bsqW1nyihxwg7d/QDNTQfnIGmLoKd46ERcCyTzj6l54wZ0mjFnqnu8Z9lumBzvV0i2u/iV1huw3e5UvkbBSFFa2RkgQDG6GXmxFN0KESHdRk9fuvovGmSTozjeWyIGGVt3jUwbFQ1x5k28cjE6LWfk+WUEk/MHlqcKXjqh/fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726244965; c=relaxed/simple;
	bh=4EPJK/Lhf+lK2X+BNMq0xeSEFDQD8fQmb/ETYP2fqJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=enXw/40wtBBLtLDe2mP+pNRyaABBGar5gYFjFmdf4m3YsvL5YFXdpfG4R8f7EjitpU+Bk3h0gwDg7yiebaUaf6Y/fmX2PvPWYcvsDUiqzEtUQHAVMq/LH+RBuYUkANBy4MaCh5ZZlYpTGvIW5wq/baT1i0e1dd2jFhfa4TUJwNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KHtxVXwx; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-718f28f77f4so2230875b3a.1
        for <kvm@vger.kernel.org>; Fri, 13 Sep 2024 09:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726244962; x=1726849762; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f5iAxMyWZDEirJZG6v2ibDHazePH9W1joXyACAceV9o=;
        b=KHtxVXwxMyMLYkAt/7W3m1ht2baKlrLaMUi0NABzR4vlFskDIT4YnvZu+Sc9xSuKAR
         nbsfK/Gm6cr6tGIo2UrUe/rQe+NLwHZq1RzYcDK9YqaES1jl431Xt3a67890eCzj8Y6a
         oO0R7q68Zjc7IHmRfMTmvUNvTw6yFX8HQ5QCIbOLjnX7UywplKRkP0hdh7WC0fMPlg7x
         SuJFUvOr1jRqOW7kvx3NBru7Kmr58FAerBVoAjh+4jh83te6g7ZTMCLFn5Y1uoKbe1Sp
         1Het+0lkOJ2MBJGf/Q6KG+f9kEwwnbHARPZ+e4GjsQePoHgZ24jU5ACbd8F2NKPRfGYR
         LwIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726244962; x=1726849762;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f5iAxMyWZDEirJZG6v2ibDHazePH9W1joXyACAceV9o=;
        b=qYjbqSCIVi+Xt3d9s7zhB3H9U7ac/G+pDDfcjT44tFF3OjvhxJ7Ui+Mi79eT+6vg0G
         gZYUCHw7cgf8Vuchmc8xcywPmSBlmVKuGjrXu76tqwF5h/AqPS4L4J3tZP/brGPQ4+on
         CJuI+Jvv2YzIuoAAh47ATbh20LnNO4/BtuS8Qw8+ohsN6/LusmCgICX4Wv88/ThS0Q4u
         V+660qHsUkSx+EvEm4ktiVwk6BO3xzxKMagatp7qborIvKvMtYcbDGmmXND3rfsSRgXl
         fOIwDvyz3yPgmQwbbas0omoMwphYHRjPzBHsA9n4Mu7R53/i6nq8f7aeDyZ1zBjRMU6M
         /i8g==
X-Forwarded-Encrypted: i=1; AJvYcCWQxzEiB8M0ukBfDnSbuXaaGS17BcagTaZmFx8kB7xboXNM/NMoHGynUb8/AZInjfZ5ajY=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqishtOYCX2BxW5TrD8tNaYtSXpniTq4YCPx+5E3mcwOfzNcy4
	H5AiJU+otmxHrV3McF5SVHr9Cnb/oqBrllAA3eTHAb+6a8ckmzmxYjV44IvXmrUaJkfbwqQSCfL
	re4ET+iU+jCbcbxxzBdi2IkDZL4cH66aOqce+
X-Google-Smtp-Source: AGHT+IG6L5dDNO9+/sCxiNmE097gJdEsztc6FBnBgE5WjFWi5Wx9KBLoeYQU9PDdH0j8iwNpAeYEsGo1envUapk2Hqs=
X-Received: by 2002:a05:6a21:58b:b0:1cf:6953:2872 with SMTP id
 adf61e73a8af0-1cf764c27f2mr9396898637.48.1726244961181; Fri, 13 Sep 2024
 09:29:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240621134041.3170480-1-michael.roth@amd.com>
 <20240621134041.3170480-5-michael.roth@amd.com> <ZnwkMyy1kgu0dFdv@google.com>
 <r3tffokfww4yaytdfunj5kfy2aqqcsxp7sm3ga7wdytgyb3vnz@pfmstnvtuyg2>
 <Zn8YM-s0TRUk-6T-@google.com> <r7wqzejwpcvmys6jx7qcio2r6wvxfiideniqmwv5tohbohnvzu@6stwuvmnrkpo>
 <f8dfeab2-e5f2-4df6-9406-0aff36afc08a@linux.intel.com>
In-Reply-To: <f8dfeab2-e5f2-4df6-9406-0aff36afc08a@linux.intel.com>
From: Dionna Amalie Glaze <dionnaglaze@google.com>
Date: Fri, 13 Sep 2024 09:29:08 -0700
Message-ID: <CAAH4kHZ-9ajaLH8C1N2MKzFuBKjx+BVk9-t24xhyEL3AKEeMQQ@mail.gmail.com>
Subject: Re: [PATCH v1 4/5] KVM: Introduce KVM_EXIT_COCO exit type
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Michael Roth <michael.roth@amd.com>, Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, 
	linux-coco@lists.linux.dev, linux-kernel@vger.kernel.org, x86@kernel.org, 
	pbonzini@redhat.com, jroedel@suse.de, thomas.lendacky@amd.com, 
	pgonda@google.com, ashish.kalra@amd.com, bp@alien8.de, pankaj.gupta@amd.com, 
	liam.merwick@oracle.com, Rick Edgecombe <rick.p.edgecombe@intel.com>, 
	Reinette Chatre <reinette.chatre@intel.com>, "Yamahata, Isaku" <isaku.yamahata@intel.com>, 
	"Peng, Chao P" <chao.p.peng@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2024 at 12:15=E2=80=AFAM Binbin Wu <binbin.wu@linux.intel.c=
om> wrote:
>
>
>
> On 6/29/2024 8:36 AM, Michael Roth wrote:
> > On Fri, Jun 28, 2024 at 01:08:19PM -0700, Sean Christopherson wrote:
> >> On Wed, Jun 26, 2024, Michael Roth wrote:
> >>> On Wed, Jun 26, 2024 at 07:22:43AM -0700, Sean Christopherson wrote:
> >>>> On Fri, Jun 21, 2024, Michael Roth wrote:
> >>>>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kv=
m/api.rst
> >>>>> index ecfa25b505e7..2eea9828d9aa 100644
> >>>>> --- a/Documentation/virt/kvm/api.rst
> >>>>> +++ b/Documentation/virt/kvm/api.rst
> >>>>> @@ -7122,6 +7122,97 @@ Please note that the kernel is allowed to us=
e the kvm_run structure as the
> >>>>>   primary storage for certain register types. Therefore, the kernel=
 may use the
> >>>>>   values in kvm_run even if the corresponding bit in kvm_dirty_regs=
 is not set.
> >>>>>
> >>>>> +::
> >>>>> +
> >>>>> +         /* KVM_EXIT_COCO */
> >>>>> +         struct kvm_exit_coco {
> >>>>> +         #define KVM_EXIT_COCO_REQ_CERTS                 0
> >>>>> +         #define KVM_EXIT_COCO_MAX                       1
> >>>>> +                 __u8 nr;
> >>>>> +                 __u8 pad0[7];
> >>>>> +                 union {
> >>>>> +                         struct {
> >>>>> +                                 __u64 gfn;
> >>>>> +                                 __u32 npages;
> >>>>> +         #define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN         1
> >>>>> +         #define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC             (=
1 << 31)
> >>>> Unless I'm mistaken, these error codes are defined by the GHCB, whic=
h means the
> >>>> values matter, i.e. aren't arbitrary KVM-defined values.
> >>> They do happen to coincide with the GHCB-defined values:
> >>>
> >>>    /*
> >>>     * The GHCB spec only formally defines INVALID_LEN/BUSY VMM errors=
, but define
> >>>     * a GENERIC error code such that it won't ever conflict with GHCB=
-defined
> >>>     * errors if any get added in the future.
> >>>     */
> >>>    #define SNP_GUEST_VMM_ERR_INVALID_LEN   1
> >>>    #define SNP_GUEST_VMM_ERR_BUSY          2
> >>>    #define SNP_GUEST_VMM_ERR_GENERIC       BIT(31)
> >>>

VMM_ERR_BUSY means something very specific to the GHCB protocol, which
is that a request that would normally have increased a message
sequence number was not able to be sent, and the exact same message
would need to be sent again, otherwise the cryptographic protocol
breaks down.
In the event of firmware hotloading, SNP_COMMIT, and needing to get
the right version of VCEK certificate to the VM guest, we could detect
a conflict and need to say VMM_ERR_BUSY2 (or something) that says try
again, but the sequence number did go up, we just couldn't coordinate
a non-atomic data transfer afterward to be correct.

There's a different way to solve the data race without a retry, but
I'm not 100% confident that we can really generalize the error space
across TEEs.

To support the coordination of SNP_DOWNLOAD_FIRMWARE_EX, SNP_COMMIT,
and extended guest requests, user space needs to be told which
TCB_VERSION certificate it needs to provide. It can be wrong if it
relies on its own call to SNP_PLATFORM_STATUS.
Given that userspace can't interpret the report (encrypted by VMPCK),
it won't know exactly which VCEK certificate to provide given that
SNP_COMMIT can happen before or after an attestation report is taken
and before KVM exits to userspace for the certificates.

We can extend the ccp driver to, on extended guest request, lock the
command buffer, get the REPORTED_TCB, complete the request, unlock the
command buffer, and return both the response and the REPORTED_TCB at
the time of the request. That will give userspace enough info to give
the right certificate. That would mean a more specific
KVM_EXIT_COCO_REQ_EXIT message than just where to put the certs. A
SEV-SNP TCB_VERSION is also platform-specific, so not particularly
generalizable to "COCO".

We could also say that extended_guest_request is inherently racy and
have AMD extend the GHCB spec with a new request type that doesn't
communicate with the ASP at all and instead just requests certificates
for a given REPORTED_TCB. The guest VM can read an attestation
report's reported_tcb field and craft this request. I don't know if we
want to have an arbitrary message passing interface between guest VM
and user space VMM without very specific restrictions. We ought to
just have paravirtualized I/O devices then.

> >>> and not totally by accident. But the KVM_EXIT_COCO_REQ_CERTS_ERR_* ar=
e
> >>> defined/documented without any reliance on the GHCB spec and are pure=
ly
> >>> KVM-defined. I just didn't really see any reason to pick different
> >>> numerical values since it seems like purposely obfuscating things for
> >> For SNP.  For other vendors, the numbers look bizarre, e.g. why bit 31=
?  And the
> >> fact that it appears to be a mask is even more odd.
> > That's fair. Values 1 and 2 made sense so just re-use, but that results
> > in a awkward value for _GENERIC that's not really necessary for the KVM
> > side.
> >
> >>> no real reason. But the code itself doesn't rely on them being the sa=
me
> >>> as the spec defines, so we are free to define these however we'd like=
 as
> >>> far as the KVM API goes.
> >>>> I forget exactly what we discussed in PUCK, but for the error codes,=
 I think KVM
> >>>> should either define it's own values that are completely disconnecte=
d from any
> >>>> "harware" spec, or KVM should very explicitly #define all hardware v=
alues and have
> >>> I'd gotten the impression that option 1) is what we were sort of lean=
ing
> >>> toward, and that's the approach taken here.
> >>> And if we expose things selectively to keep the ABI small, it's a bit
> >>> awkward too. For instance, KVM_EXIT_COCO_REQ_CERTS_ERR_* basically ne=
eds
> >>> a way to indicate success/fail/ENOMEM. Which we have with
> >>> (assuming 0=3D=3Dsuccess):
> >>>
> >>>    #define KVM_EXIT_COCO_REQ_CERTS_ERR_INVALID_LEN         1
> >>>    #define KVM_EXIT_COCO_REQ_CERTS_ERR_GENERIC             (1 << 31)
> >>>
> >>> But the GHCB also defines other values like:
> >>>
> >>>    #define SNP_GUEST_VMM_ERR_BUSY          2
> >>>
> >>> which don't make much sense to handle on the userspace side and doesn=
't
> >> Why not?  If userspace is waiting on a cert update for whatever reason=
, why can't
> >> it signal "busy" to the guest?
> > My thinking was that userspace is free to take it's time and doesn't ne=
ed
> > to report delays back to KVM. But it would reduce the potential for
> > soft-lockups in the guest, so it might make sense to work that into the
> > API.
> >
> > But more to original point, there could be something added in the futur=
e
> > that really has nothing to do with anything involving KVM<->userspace
> > interaction and so would make no sense to expose to userspace.
> > Unfortunately I picked a bad example. :)
> >
> >>> really have anything to do with the KVM_EXIT_COCO_REQ_CERTS KVM event=
,
> >>> which is a separate/self-contained thing from the general guest reque=
st
> >>> protocol. So would we expose that as ABI or not? If not then we end u=
p
> >>> with this weird splitting of code. And if yes, then we have to sort o=
f
> >>> give userspace a way to discover whenever new error codes are added t=
o
> >>> the GHCB spec, because KVM needs to understand these value too and
> >> Not necessarily.  So long as KVM doesn't need to manipulate guest stat=
e, e.g. to
> >> set RBX (or whatever reg it is) for ERR_INVALID_LEN, then KVM doesn't =
need to
> >> care/know about the error codes.  E.g. userspace could signal VMM_BUSY=
 and KVM
> >> would happily pass that to the guest.
> > But given we already have an exception to that where KVM does need to
> > intervene for certain errors codes like ERR_INVALID_LEN that require
> > modifying guest state, it doesn't seem like a good starting position
> > to have to hope that it doesn't happen again.
> >
> > It just doesn't seem necessary to put ourselves in a situation where
> > we'd need to be concerned by that at all. If the KVM API is a separate
> > and fairly self-contained thing then these decisions are set in stone
> > until we want to change it and not dictated/modified by changes to
> > anything external without our explicit consideration.
> >
> > I know the certs things is GHCB-specific atm, but when the certs used
> > to live inside the kernel the KVM_EXIT_* wasn't needed at all, so
> > that's why I see this as more of a KVM interface thing rather than
> > a GHCB one. And maybe eventually some other CoCo implementation also
> > needs some interface for fetching certificates/blobs from userspace
> > and is able to re-use it still because it's not too SNP-specific
> > and the behavior isn't dictated by the GHCB spec (e.g.
> > ERR_INVALID_LEN might result in some other state needing to be
> > modified in their case rather than what the GHCB dictates.)
>
> TDX GHCI does have a similar PV interface for TDX guest to get quota, i.e=
.,
> TDG.VP.VMCALL<GetQuote>.  This GetQuote PV interface is designed to invok=
e
> a request to generate a TD-Quote signing by a service hosting TD-Quoting
> Enclave operating in the host environment for a TD Report passed as a
> parameter by the TD.
> And the request will be forwarded to userspace for handling.
>
> So like GHCB, TDX needs to pass a shared buffer to userspace, which is
> specified by GPA and size (4K aligned) and get the error code from
> userspace and forward the error code to guest.
>
> But there are some differences from GHCB interface.
> 1. TDG.VP.VMCALL<GetQuote> is a a doorbell-like interface used to queue a
>     request. I.e., it is an asynchronous request.  The error code represe=
nts
>     the status of request queuing, *not* the status of TD Quote generatio=
n..
> 2. Besides the error code returned by userspace for GetQuote interface, t=
he
>     GHCI spec defines a "Status Code" field in the header of the shared
> buffer.
>     The "Status Code" field is also updated by VMM during the real
> handling of
>     getting quote (after TDG.VP.VMCALL<GetQuote> returned to guest).
>     After the TDG.VP.VMCALL<GetQuote> returned and back to TD guest, the =
TD
>     guest can poll the "Status Code" field to check if the processing is
>     in-flight, succeeded or failed.
>     Since the real handling of getting quota is happening in userspace, a=
nd
>     it will interact directly with guest, for TDX, it has to expose TDX
>     specific error code to userspace to update the result of quote
> generation.
>
> Currently, TDX is about to add a new TDX specific KVM exit reason, i.e.,
> KVM_EXIT_TDX_GET_QUOTE and its related data structure based on a previous
> discussion. https://lore.kernel.org/kvm/Zg18ul8Q4PGQMWam@google.com/
> For the error code returned by userspace, KVM simply forward the error co=
de
> to guest without further translation or handling.
>
> I am neutral to have a common KVM exit reason to handle both GHCB for
> REQ_CERTS and GHCI for GET_QUOTE.  But for the error code, can we uses
> vendor
> specific error codes if KVM cares about the error code returned by usersp=
ace
> in vendor specific complete_userspace_io callback?
>
> BTW, here is the plan of 4 hypercalls needing to exit to userspace for
> TDX basic support series:
> TDG.VP.VMCALL<SetupEventNotifyInterrupt>
> - Add a new KVM exit reason KVM_EXIT_TDX_SETUP_EVENT_NOTIFY
> TDG.VP.VMCALL<GetQuote>
> - Add a new KVM exit reason KVM_EXIT_TDX_GET_QUOTE
> TDG.VP.VMCALL<MapGPA>
> - Reuse KVM_EXIT_HYPERCALL with KVM_HC_MAP_GPA_RANGE
> TDG.VP.VMCALL<ReportFatalError>
> - Reuse KVM_EXIT_SYSTEM_EVENT but add a new type
>    KVM_SYSTEM_EVENT_TDX_FATAL_ERROR
>
>
>


--
-Dionna Glaze, PhD, CISSP, CCSP (she/her)

