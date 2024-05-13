Return-Path: <kvm+bounces-17359-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9412F8C4A31
	for <lists+kvm@lfdr.de>; Tue, 14 May 2024 01:48:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B71F31C20DEC
	for <lists+kvm@lfdr.de>; Mon, 13 May 2024 23:48:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2436F8595F;
	Mon, 13 May 2024 23:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aIMnTdSw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153A684DE3
	for <kvm@vger.kernel.org>; Mon, 13 May 2024 23:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715644110; cv=none; b=NVVYXfVjg+TmehZ1q0nY/6nsHj8wpw4aOPPg/IGQ2Yvl4T7ABstx3Em6DGptEUfN9tQuwblcB4JIEdy6VQKMz8a2Os/0a3JKTpi2Dckr9GnoZGKttF2HRipAoIEv3sRgr8yaVWnh0vUsiqvfe9xOh5a0UcXDRkdkP1C44l92WBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715644110; c=relaxed/simple;
	bh=e/aMa8sxi1iu5IIVcE5Li3gPlKzldrwAvmelgjbrhsw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=E9ceVPKgboXTPFXHQndWRlkzZw9HNYrzNa+UOo+8XSeC2TnW+Wvs5f2O4gsfQ0eVM5GV7+bC73jmmu5XUtr+skDP/aN2nYeQZVlUr1ZqZPlcYqdQtukUtJriY3D9S5ZEkhCpeaaDUIq+IpkwrYSuCquPhZJKL630xd5ZfIlnl+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aIMnTdSw; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-de603db5d6aso9514717276.2
        for <kvm@vger.kernel.org>; Mon, 13 May 2024 16:48:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715644107; x=1716248907; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xcnRJoaZIx21DuluCfit9r/i9JvNQvqU+xe6GNS7SCQ=;
        b=aIMnTdSw8mmwKeqULqGIv2b7Irf/+TSH6IJ/0JFTZt7OoZ/7f3IQDnH41AQmV+X5sZ
         oeZuYwHPb1TsijkIOTuTF0dAOqkaeY+wTVCK/4A1UpXl16MoFjUL3kUQaC18snFVd1nJ
         EwLx5nX7OCT4DQfNCsvklk9a/4WjWcyTwJh+5Dh14HgYJUM+Yw3hHinJM7z6WGPvP23F
         hW9SlOXPxXQw6HL7dcC8S9hNefB2VL7URrWAys/BfjlZH43ieIEuaKm0+75lC2oQ1qZx
         gkYmnDWoC4AYRWl7sWnOTot0fMOn3DVEjL9pmb7R+8zIhf/JllcrG3aqPQgk0ITA9xxE
         Itjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715644107; x=1716248907;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xcnRJoaZIx21DuluCfit9r/i9JvNQvqU+xe6GNS7SCQ=;
        b=kxs6LghV4oWU1q9jtH3xxI5dGGu8mtrwSqYHcq+58HiE947H9jJ46oClzIUpu8tRGG
         zb8p/FmTIPKMTpbmKQwG+Nq17NxihRJm5hivXg3Gqkah49dQ+Tm58JtyjFv7+LC8VCz/
         zvATvqinBz2h6pnpRTtzsshXqMVogqJn/7e8G+DzOVkonXX7o3xsuPO0bIGmfhnqFrfy
         dX7/Vhx6gu7hLSAEZkg5v3pUp5j8exV1HqGEnPhO0u0fhqTSbFQ4qUtOKgLj1LySf9zj
         zVdo8xI2tVNc8rJldWv+7Qmzt5lK5jsZzT62lowiXW834jszdlLJtkBuo0h6XKaSlemC
         Wf/w==
X-Gm-Message-State: AOJu0Yxpfj6q7ydvWab2V4xLW/baYhppJAHqoWVsKzsCaFrTfNtre7zc
	qQvIiw6l2CACTshR6+Q0Nig4rPPAXlQgeQt/Qe0AzuZ1nGYZPvOSP3N1nNm7mSKHqUOvQ2AuI5A
	8vQ==
X-Google-Smtp-Source: AGHT+IE/hgDa4xOkN7HCA6nlxcIOl/FKzUMNvVpn8bpW98GVpvavb4qfN2iMLTGTUofAQ3KGAN5Ff/nOklU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:c01:b0:de5:2694:45ba with SMTP id
 3f1490d57ef6-dee4f104643mr2918790276.0.1715644107135; Mon, 13 May 2024
 16:48:27 -0700 (PDT)
Date: Mon, 13 May 2024 16:48:25 -0700
In-Reply-To: <20240501085210.2213060-20-michael.roth@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240501085210.2213060-1-michael.roth@amd.com> <20240501085210.2213060-20-michael.roth@amd.com>
Message-ID: <ZkKmySIx_vn0W-k_@google.com>
Subject: Re: [PATCH v15 19/20] KVM: SEV: Provide support for
 SNP_EXTENDED_GUEST_REQUEST NAE event
From: Sean Christopherson <seanjc@google.com>
To: Michael Roth <michael.roth@amd.com>
Cc: kvm@vger.kernel.org, linux-coco@lists.linux.dev, linux-mm@kvack.org, 
	linux-crypto@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, 
	tglx@linutronix.de, mingo@redhat.com, jroedel@suse.de, 
	thomas.lendacky@amd.com, hpa@zytor.com, ardb@kernel.org, pbonzini@redhat.com, 
	vkuznets@redhat.com, jmattson@google.com, luto@kernel.org, 
	dave.hansen@linux.intel.com, slp@redhat.com, pgonda@google.com, 
	peterz@infradead.org, srinivas.pandruvada@linux.intel.com, 
	rientjes@google.com, dovmurik@linux.ibm.com, tobin@ibm.com, bp@alien8.de, 
	vbabka@suse.cz, kirill@shutemov.name, ak@linux.intel.com, tony.luck@intel.com, 
	sathyanarayanan.kuppuswamy@linux.intel.com, alpergun@google.com, 
	jarkko@kernel.org, ashish.kalra@amd.com, nikunj.dadhania@amd.com, 
	pankaj.gupta@amd.com, liam.merwick@oracle.com
Content-Type: text/plain; charset="us-ascii"

On Wed, May 01, 2024, Michael Roth wrote:
> Version 2 of GHCB specification added support for the SNP Extended Guest
> Request Message NAE event. This event serves a nearly identical purpose
> to the previously-added SNP_GUEST_REQUEST event, but allows for
> additional certificate data to be supplied via an additional
> guest-supplied buffer to be used mainly for verifying the signature of
> an attestation report as returned by firmware.
> 
> This certificate data is supplied by userspace, so unlike with
> SNP_GUEST_REQUEST events, SNP_EXTENDED_GUEST_REQUEST events are first
> forwarded to userspace via a KVM_EXIT_VMGEXIT exit structure, and then
> the firmware request is made after the certificate data has been fetched
> from userspace.
> 
> Since there is a potential for race conditions where the
> userspace-supplied certificate data may be out-of-sync relative to the
> reported TCB or VLEK that firmware will use when signing attestation
> reports, a hook is also provided so that userspace can be informed once
> the attestation request is actually completed. See the updates to
> Documentation/ for more details on these aspects.
> 
> Signed-off-by: Michael Roth <michael.roth@amd.com>
> ---
>  Documentation/virt/kvm/api.rst | 87 ++++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/sev.c         | 86 +++++++++++++++++++++++++++++++++
>  arch/x86/kvm/svm/svm.h         |  3 ++
>  include/uapi/linux/kvm.h       | 23 +++++++++
>  4 files changed, 199 insertions(+)
> 
> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
> index f0b76ff5030d..f3780ac98d56 100644
> --- a/Documentation/virt/kvm/api.rst
> +++ b/Documentation/virt/kvm/api.rst
> @@ -7060,6 +7060,93 @@ Please note that the kernel is allowed to use the kvm_run structure as the
>  primary storage for certain register types. Therefore, the kernel may use the
>  values in kvm_run even if the corresponding bit in kvm_dirty_regs is not set.
>  
> +::
> +
> +		/* KVM_EXIT_VMGEXIT */
> +		struct kvm_user_vmgexit {

LOL, it looks dumb, but maybe kvm_vmgexit_exit to avoid confusing about whether
the struct refers to host userspace vs. guest userspace?

Actually, I vote to punt on naming until more exits need to be kicked to userspace,
and just do (see below for details on how I got here):

		/* KVM_EXIT_VMGEXIT */
		struct {
			__u64 exit_code;
			union {
				struct {
					__u64 data_gpa;
					__u64 data_npages;
					__u64 ret;
				} req_certs;
			};
		} vmgexit;

> +  #define KVM_USER_VMGEXIT_REQ_CERTS		1
> +			__u32 type; /* KVM_USER_VMGEXIT_* type */

Regardless of whether or not requesting a certificate is vendor specific enough
to justify its own exit reason, I don't think KVM should have a #VMGEXIT that
adds its own layer.  Structuring the user exit this way will make it weird and/or
difficult to handle #VMGEXITs that _do_ fit a generic pattern, e.g. a user might
wonder why PSC #VMGEXITs don't show up here.

And defining an exit reason that is, for all intents and purposes, a regurgitation
of the raw #VMGEXIT reason, but with a different value, is also confusing.  E.g.
it wouldn't be unreasonable for a reader to expect that "type" matches the value
defined in the GHCB (or whever the values are defined).

Ah, you copied what KVM does for Hyper-V and Xen emulation.  Hrm.  But only
partially.

Assuming it's impractical to have a generic user exit for this, and we think
there is a high likelihood of needing to punt more #VMGEXITs to userspace, then
we should more closely (perhaps even exactly) follow the Hyper-V and Xen models.
I.e. for all values and whanot that are controlled/defined by a third party
(Hyper-V, Xen, the GHCB, etc.) #define those values in a header that is clearly
"owned" by the third party.

E.g. IIRC, include/xen/interface/xen.h is copied verbatim from Xen documentation
(source?).  And include/asm-generic/hyperv-tlfs.h is the kernel's copy of the
TLFS, which dictates all of the Hyper-V hypercalls.

If we do that, then my concerns/objections largely go away, e.g. KVM isn't
defining magic values, there's less chance for confusion about what "type" holds,
etc.

Oh, and if we go that route, the sizes for all fields should follow the GHCB,
e.g. I believe the "type" should be a __u64.

> +			union {
> +				struct {
> +					__u64 data_gpa;
> +					__u64 data_npages;
> +  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_INVALID_LEN   1
> +  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_BUSY          2
> +  #define KVM_USER_VMGEXIT_REQ_CERTS_ERROR_GENERIC       (1 << 31)

Hopefully it won't matter, but are BUSY and GENERIC actually defined somewhere?
I don't see them in GHCB 2.0.

In a perfect world, it would be nice for KVM to not have to care about the error
codes.  But KVM disallows KVM_{G,S}ET_REGS for guest with protected state, which
means it's not feasible for userspace to set registers, at least not in any sane
way.

Heh, we could abuse KVM_SYNC_X86_REGS to let userspace specify RBX, but (a) that's
gross, and (b) KVM_SYNC_X86_REGS and KVM_SYNC_X86_SREGS really ought to be rejected
if guest state is protected.

> +					__u32 ret;
> +  #define KVM_USER_VMGEXIT_REQ_CERTS_FLAGS_NOTIFY_DONE	BIT(0)

This has no business being buried in a VMGEXIT_REQ_CERTS flags.  Notifying
userspace that KVM completed its portion of a userspace exit is completely generic.

And aside from where the notification flag lives, _if_ we add a notification
mechanism, it belongs in a separate patch, because it's purely a performance
optimization.  Userspace can use immediate_exit to force KVM to re-exit after
completing an exit.

Actually, I take that back, this isn't even an optimization, it's literally a
non-generic implementation of kvm_run.immediate_exit.

If this were an optimization, i.e. KVM truly notified userspace without exiting,
then it would need to be a lot more robust, e.g. to ensure userspace actually
received the notification before KVM moved on.

> +					__u8 flags;
> +  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_PENDING	0
> +  #define KVM_USER_VMGEXIT_REQ_CERTS_STATUS_DONE		1

This is also a weird reimplementation of generic functionality.  KVM nullifies
vcpu->arch.complete_userspace_io _before_ invoking the callback.  So if a callback
needs to run again on the next KVM_RUN, it can simply set complete_userspace_io
again.  In other words, literally doing nothing will get you what you want :-)

> +					__u8 status;
> +				} req_certs;
> +			};
> +		};

