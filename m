Return-Path: <kvm+bounces-70630-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YHXNKsweimmtHAAAu9opvQ
	(envelope-from <kvm+bounces-70630-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:52:12 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 24A551133B6
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:52:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9B133301AA91
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:52:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73EE43793D9;
	Mon,  9 Feb 2026 17:52:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BhYXpVc/";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lXGBi+eV"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C63125F984
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 17:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659527; cv=pass; b=SeSkK3szE0eEf2gok13JFUazpaMbipl9LkR2Or7Q71T/YNM/9Ah/imaSf7CEGXvBr4dwRRZ6S/derK1oNILNuX/pDdDFCIj7QONHs0rtj/lykXYKAuhLDbvEhRVENi/qPFlUHYt8GBEcikCfAL5xKqq2uNj066OARUhacXWlikI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659527; c=relaxed/simple;
	bh=mNHQkYsi8SUkfO8n+EEbZW2momR9UjxRk0Ux6iBoWec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q6B2fDWkLpufxotbLbKeUSXLH/FN8usjpk0OeOVVFtDzAOhf1mTom3lHddfUJ5qGV7VmWfVptHsV+BqQ2/dD2bghDi9avLCfUmGn4jte+VPwv1sM/gI2TezmvhSWx3XQD3e34oGIgBh6KvdZ0lRSWL0FeeRZg/XkLC9vq9kjqLE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BhYXpVc/; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lXGBi+eV; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770659526;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7lPLpOAKXSWjBFOzBTp8Y8kLULJ6Gb2vFyqE9cEDJGs=;
	b=BhYXpVc/HWGJ1GYty+k5YkTJ0q+ZT55c8JHd5h6YPmQNB/3GmoP8EvrvDeJXD74keOCbW1
	TEQd0g3eS8LZFF2vDC0fpnW+lV1fsvWn6S6BgauAxv3nxD0dtxgj/nV6IpIA5z2FX3uAG3
	eEOKgXy9imaYYtlyY346+JztsmhOIIM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-L5oJKYb2PJOKCh2gDNjI5Q-1; Mon, 09 Feb 2026 12:52:04 -0500
X-MC-Unique: L5oJKYb2PJOKCh2gDNjI5Q-1
X-Mimecast-MFC-AGG-ID: L5oJKYb2PJOKCh2gDNjI5Q_1770659524
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4376ec2b1cfso825278f8f.0
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 09:52:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770659523; cv=none;
        d=google.com; s=arc-20240605;
        b=B0Swrbvlu4nqR9Zn4XfS6rDodzJTg408pyH64IbdsJmetb2GkmAQt7rmJP5IxINyhr
         RnJVWS7q5KTTTNpY4KF/dEM8mEXHWcJulYBzFpfcdtjFDUJ/ce9dusWmVAU71eMCvmZ/
         0KTC1Sg1HTzGsqe7UIMjyy3sIW69ag1klw26ynx0KzsUHAjHjxi5M3IXUkM902PV3uko
         Y3/oIsCMlOxCW9FA+f8wDu1cqTyNTh5NR4xgYKABJ0iFK6xKvP68o9cMnJtL8z0ariKD
         92qS1ppznnKtzAg3LtLzWu6a4Wsu2UEudkobzVVrOvsXjyJTSFUHh1uxrYK+rUAFQhMT
         DCiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7lPLpOAKXSWjBFOzBTp8Y8kLULJ6Gb2vFyqE9cEDJGs=;
        fh=qaYm4b6GKYlZ0T3gtLZ7fjEfCEC8jMv5XzYe6fOhw1Y=;
        b=XNV7j5d/lVPpsrRDRgiZ8wkR8PHqd8B1cF1sIh4hSM9rb8d8jor33g6kUBUQ+iOJjj
         dN5b0Z0MPqRo92KRNtlMHumDogVsVIoo+nE1DFT0ajpIjDa2JsvTRW4fjUB9NRCg7Shb
         DThkRUJHlfAeVXBchhaplBppHRC2h8MlHD/hPkVdWdbtBYAoKhySl5+K0s1nMhG9XVtY
         UDMIW5bVh4TvMjiHXGvjaA4Pz+QYT6lPPHCztsLQ0Mn8mLmrzYYlSlJ6Ed4JZe7TFQ9L
         MKEbHiYQhNoAwYc+hsZ/YFEJXPAj96seOrgIhXIdZTPc36pKS0Q2Bn3EZMHWOK1QL7Sl
         TGOw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770659523; x=1771264323; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lPLpOAKXSWjBFOzBTp8Y8kLULJ6Gb2vFyqE9cEDJGs=;
        b=lXGBi+eVxw9HZ+sa5+M7S/boa5yfygJ614kxrF+6Iz/Ua/2AnSLY/NGAw/7igGF/Ik
         r+g09Px2hmYyCbxJu17SKCImKoGbhatPYPnDXlVtYd4pUZDQWCKjllzJooNaE1H0F5be
         15B6YgS4NDycXw14CbEkplPCYer40t4YZwMIetp2nWV/4GxfkCBedx8yAIjZow1oRwmK
         yOBr62z9QP4+fZEmDcjcIvaRa/H0YhIvdfVAwF+Az9m9Lb6KBo72JXxZVXY5fZ0rsvFO
         UN9mv80UHCO9tE0ScntKiQBmiVGhEvBPh4r/Js/KlEgSTNHdEcFZIFosGFep2Z8270LX
         QCjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770659523; x=1771264323;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7lPLpOAKXSWjBFOzBTp8Y8kLULJ6Gb2vFyqE9cEDJGs=;
        b=tvFzBru3nfhW+gocFUkZYbQFfv3HjkNYMhavGHqBzzj1y7vq6dgksmXmmKmRs0xDld
         uXz2WpK5tpc3L93GiRKfv+HoXppppoHla7kzYF4a3Y/on6aoY8W3tdVJqTiYI6lqXBA6
         lrpagD8TccbApX5nJEHcbkXr5hSTe9VRnfqUowE1eizAfMuariccTiFVXvGVter193SI
         6qmAxrubOGrzGwFeXF39+x0wW04coP25F9iNMUTxRpzBvKxlkHXGDw0XoosY7YhNabvQ
         VLE7S/45TPRynuF0+wcoaYeQGARSVY0uhE4cKUBbR4Y/I5NuVLw8ig76W9dc1pNfJNTh
         2n8A==
X-Gm-Message-State: AOJu0YwJsbzPRk5Vbyehbvbl+fKaooxvEGDVybQkYeGqW/9kb7PR5WrS
	TSLhKrdL8UGXpN9Fp6OqQGSoFlAeJ4yCCGo47RXe+9mY1+0Hz1ZcEy9kWtJ1sZEQQgYY6BjX9H6
	4YWzItG7Rf//wds3cT0UmCh8LCF1mKYT2Cy5jhGel+fK8sK0UzvfNydNz4ybWhB3J8rKRGTxZ1j
	FBo9809nwecl9w8p5+F7hbgGpW0cwU
X-Gm-Gg: AZuq6aLTpuUagcbalzH7SZFiMcHhIyKazdP6kO2KwXo94I+5bnqeLkSRAI9iNE9A9Le
	u0ce4yHvXapzDMf1PJ7NRvXuHAf/l1Xzgz8DjvYuvr4d/SG3JpSytGsxZ4oeJFanevxHXIVFJ00
	zqmLyagfE4z1k+okES8nJqPtPjkg9ktC+o7dhFMniAIrufJIyEm9ckAjrljYZ9rA0I5GJ5/MI4V
	vQCoqlIyJUIB30Wzkk05j+on05iYYgXwA6rcX8UaR/sGPp+Qid7AaIyCpPmsGdEgX5RPg==
X-Received: by 2002:a05:6000:430a:b0:435:9882:2342 with SMTP id ffacd0b85a97d-436293b381dmr19138216f8f.33.1770659523490;
        Mon, 09 Feb 2026 09:52:03 -0800 (PST)
X-Received: by 2002:a05:6000:430a:b0:435:9882:2342 with SMTP id
 ffacd0b85a97d-436293b381dmr19138183f8f.33.1770659523013; Mon, 09 Feb 2026
 09:52:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-8-seanjc@google.com>
In-Reply-To: <20260207041011.913471-8-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Feb 2026 18:51:51 +0100
X-Gm-Features: AZwV_QgV4nafRDF51A85y7O33QJ1jm1k5a2uv1s_HjZ2xd8EsmyYQ2JHb7-8ZmI
Message-ID: <CABgObfavktYG1ZmsSoVY3W2Rxm7Sh7ri6BkVkbZM3LHmg1m9nA@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: SVM changes for 6.20
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70630-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 24A551133B6
X-Rspamd-Action: no action

On Sat, Feb 7, 2026 at 5:10=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Complete the "u64 exit_code" cleanup, start fixing nSVM issues (a lot mor=
e of
> those will be coming in the near future), virtualize EPAPS, and support f=
or
> fetching SNP certificates.
>
> The following changes since commit 9ace4753a5202b02191d54e9fdf7f9e3d02b85=
eb:
>
>   Linux 6.19-rc4 (2026-01-04 14:41:55 -0800)
>
> are available in the Git repository at:
>
>   https://github.com/kvm-x86/linux.git tags/kvm-x86-svm-6.20
>
> for you to fetch changes up to 20c3c4108d58f87c711bf44cb0b498b3ac5af6bf:
>
>   KVM: SEV: Add KVM_SEV_SNP_ENABLE_REQ_CERTS command (2026-01-23 09:14:16=
 -0800)

Pulled, thanks.

Paolo

> ----------------------------------------------------------------
> KVM SVM changes for 6.20
>
>  - Drop a user-triggerable WARN on nested_svm_load_cr3() failure.
>
>  - Add support for virtualizing ERAPS.  Note, correct virtualization of E=
RAPS
>    relies on an upcoming, publicly announced change in the APM to reduce =
the
>    set of conditions where hardware (i.e. KVM) *must* flush the RAP.
>
>  - Ignore nSVM intercepts for instructions that are not supported accordi=
ng to
>    L1's virtual CPU model.
>
>  - Add support for expedited writes to the fast MMIO bus, a la VMX's fast=
path
>    for EPT Misconfig.
>
>  - Don't set GIF when clearing EFER.SVME, as GIF exists independently of =
SVM,
>    and allow userspace to restore nested state with GIF=3D0.
>
>  - Treat exit_code as an unsigned 64-bit value through all of KVM.
>
>  - Add support for fetching SNP certificates from userspace.
>
>  - Fix a bug where KVM would use vmcb02 instead of vmcb01 when emulating =
VMLOAD
>    or VMSAVE on behalf of L2.
>
>  - Misc fixes and cleanups.
>
> ----------------------------------------------------------------
> Amit Shah (1):
>       KVM: SVM: Virtualize and advertise support for ERAPS
>
> Jim Mattson (2):
>       KVM: SVM: Don't set GIF when clearing EFER.SVME
>       KVM: SVM: Allow KVM_SET_NESTED_STATE to clear GIF when SVME=3D=3D0
>
> Kevin Cheng (1):
>       KVM: SVM: Don't allow L1 intercepts for instructions not advertised
>
> Michael Roth (2):
>       KVM: Introduce KVM_EXIT_SNP_REQ_CERTS for SNP certificate-fetching
>       KVM: SEV: Add KVM_SEV_SNP_ENABLE_REQ_CERTS command
>
> Sean Christopherson (14):
>       KVM: nSVM: Remove a user-triggerable WARN on nested_svm_load_cr3() =
succeeding
>       KVM: SVM: Rename "fault_address" to "gpa" in npf_interception()
>       KVM: SVM: Add support for expedited writes to the fast MMIO bus
>       KVM: SVM: Drop the module param to control SEV-ES DebugSwap
>       KVM: SVM: Tag sev_supported_vmsa_features as read-only after init
>       KVM: SVM: Add a helper to detect VMRUN failures
>       KVM: SVM: Open code handling of unexpected exits in svm_invoke_exit=
_handler()
>       KVM: SVM: Check for an unexpected VM-Exit after RETPOLINE "fast" ha=
ndling
>       KVM: SVM: Filter out 64-bit exit codes when invoking exit handlers =
on bare metal
>       KVM: SVM: Treat exit_code as an unsigned 64-bit value through all o=
f KVM
>       KVM: SVM: Limit incorrect check on SVM_EXIT_ERR to running as a VM
>       KVM: SVM: Harden exit_code against being used in Spectre-like attac=
ks
>       KVM: SVM: Assert that Hyper-V's HV_SVM_EXITCODE_ENL =3D=3D SVM_EXIT=
_SW
>       KVM: SVM: Fix an off-by-one typo in the comment for enabling AVIC b=
y default
>
> Yosry Ahmed (5):
>       KVM: selftests: Use TEST_ASSERT_EQ() in test_vmx_nested_state()
>       KVM: selftests: Extend vmx_set_nested_state_test to cover SVM
>       KVM: nSVM: Drop redundant/wrong comment in nested_vmcb02_prepare_sa=
ve()
>       KVM: nSVM: Always use vmcb01 in VMLOAD/VMSAVE emulation
>       KVM: SVM: Stop toggling virtual VMSAVE/VMLOAD on intercept recalc
>
>  Documentation/virt/kvm/api.rst                     |  44 +++++++
>  .../virt/kvm/x86/amd-memory-encryption.rst         |  52 ++++++++-
>  arch/x86/include/asm/cpufeatures.h                 |   1 +
>  arch/x86/include/asm/kvm_host.h                    |   8 ++
>  arch/x86/include/asm/svm.h                         |   9 +-
>  arch/x86/include/uapi/asm/kvm.h                    |   2 +
>  arch/x86/include/uapi/asm/svm.h                    |  32 ++---
>  arch/x86/kvm/cpuid.c                               |   9 +-
>  arch/x86/kvm/svm/avic.c                            |   4 +-
>  arch/x86/kvm/svm/hyperv.c                          |   7 +-
>  arch/x86/kvm/svm/nested.c                          |  82 ++++++++-----
>  arch/x86/kvm/svm/sev.c                             | 129 ++++++++++++++-=
------
>  arch/x86/kvm/svm/svm.c                             | 121 ++++++++++++++-=
----
>  arch/x86/kvm/svm/svm.h                             |  49 ++++++--
>  arch/x86/kvm/trace.h                               |   6 +-
>  arch/x86/kvm/x86.c                                 |  12 ++
>  include/hyperv/hvgdk.h                             |   2 +-
>  include/uapi/linux/kvm.h                           |   9 ++
>  tools/testing/selftests/kvm/Makefile.kvm           |   2 +-
>  tools/testing/selftests/kvm/include/x86/svm.h      |   3 +-
>  ...nested_state_test.c =3D> nested_set_state_test.c} | 128 +++++++++++++=
++++---
>  .../kvm/x86/svm_nested_soft_inject_test.c          |   4 +-
>  22 files changed, 559 insertions(+), 156 deletions(-)
>  rename tools/testing/selftests/kvm/x86/{vmx_set_nested_state_test.c =3D>=
 nested_set_state_test.c} (70%)
>


