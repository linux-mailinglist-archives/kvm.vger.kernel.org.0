Return-Path: <kvm+bounces-69035-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +CLXDaR5dGnU5wAAu9opvQ
	(envelope-from <kvm+bounces-69035-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 08:49:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DF287CE04
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 08:49:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D7E92300DE10
	for <lists+kvm@lfdr.de>; Sat, 24 Jan 2026 07:47:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DEF323D281;
	Sat, 24 Jan 2026 07:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PaWDtq1t";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="KCcOQUIU"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB30D1E487
	for <kvm@vger.kernel.org>; Sat, 24 Jan 2026 07:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769240831; cv=pass; b=BMeWO1QD4Pwvd9EpaCCJ/KrS4XTOtv39i8NNV7BWkaebrdXyA4+J5nfBX9CTlfR9Ov60PFUT9tKZ1RYTYdTfUGZQQ8d9jDqad5Esz11bA9YGU4nwc7EIUpPQkpKRdYJSFblCG6JFJ8qrocGQ+cu8ZOv73ReHUDGorLHKFGRw1vo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769240831; c=relaxed/simple;
	bh=VMonpPDORVBzWWGlFxv6VqjO55xg9Co8gEtHsEjtK3c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IJ1t43cJFHlt3nnwrmyRpaQ/L6WQfUPQqIgobIUWjJM/DFaPVUOWB2DdF1auYlMKwyNehnn+JMKHJGyLRGwc4tZo1rqwyYrVhxWGjwswOeDD85nZlVIijiZ+PgGLQ+9P7/BzTpftog+fY1kAtKfmvr4MoynFceMS0ceyK08mh4Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PaWDtq1t; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=KCcOQUIU; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769240828;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4v/ARzgQrLTE+mBIPvWEGmSWVJQf1rVB4tDf1RFfnKA=;
	b=PaWDtq1tiRcFPPzI1QkjCMHmmn1oHeky64Tc8SDMZyshRzlI2cSJRFrmToyRZmM+at/od1
	et7xSDp7KrKtgLqQmVNHV5VBtrfsuDVzdO7r3cdUvj5NfBwqZ4Uul/orFOR6T8u17Fxb7V
	C/6WuVOyI1scPDBlrONhyQXXgnYgAJM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-450-Dxy_YKqTOeKHB234dTBixA-1; Sat, 24 Jan 2026 02:47:06 -0500
X-MC-Unique: Dxy_YKqTOeKHB234dTBixA-1
X-Mimecast-MFC-AGG-ID: Dxy_YKqTOeKHB234dTBixA_1769240825
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-4358f1c082eso2480319f8f.1
        for <kvm@vger.kernel.org>; Fri, 23 Jan 2026 23:47:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769240825; cv=none;
        d=google.com; s=arc-20240605;
        b=LjwPymBBNcO6BHOg10X+MUR6wjyc7GH8o01733EZzszof740WcK22uhGv4bxLkLmnl
         rAlMdITO+HP3E33TXo+dQAGe0GffD9oBSFJpvJ4vGxGU2Njne5JaeKQG03SuR9E/1Vgf
         pJoi7PT2Fkih7I9t7SzfUQe68dSpldeEkbuWxhUNSBdAcwG6Ehztea3O2Rg2/yaX8MFs
         IRmST3TXrVaiP3d5DlPG7sYKn+8yyi0lkOhFwrdKwSGzNI9YEzGXXuEEj7fGPHJQM7Qy
         gTba9Lfq4pFgWpUOuBuIOrT4kP5KSuNYcDjg5Z4qUVg5aZEbRdafEFoBW/UxaO0h4jFv
         A/XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4v/ARzgQrLTE+mBIPvWEGmSWVJQf1rVB4tDf1RFfnKA=;
        fh=wb1qiC4PNaDXNMyN9dw/+8omNfopNVutGjAGXVmRXgI=;
        b=dgTwEN2CcYvFJeAZvFIm6wT4tMKnPpO2/6TydaLInhi9cN+IFWG7M4Cjc2vbgtLuEU
         Bu3ShTjIKBV/Se2r8aEXo8JDsMeUZUYuEcb9MJXEUDavZaIqTf8lSa14bCEJytpd7Zo6
         exNK+rAxX1Hb6eigiHyqKKkNBV3i+gP+pQM2Eooi1SRw+eXuY+Zk9bp+PC2Ih9Vk9zvw
         s3WdDRMXZQpUDeXlMCWhDtUKroWrTBKb2y/zssqgUYrduYacNwI15UXgSvGk7KYQGAvQ
         kGem2ohyrLubCfH04ZL69gIJZs41VkQUlnJbjeSAZ88JW5cN0yC5cF2sb2TL8Ft7tUuO
         ME8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1769240825; x=1769845625; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4v/ARzgQrLTE+mBIPvWEGmSWVJQf1rVB4tDf1RFfnKA=;
        b=KCcOQUIU+UYnqjplDxXOex4fT74zUpocROPTMbJW9QlVXvzqGK5ZftOA8e44g7CIV/
         ZOkhy/2BBLhcMe35w5yzkZKQXqeIKy32t82DarNp6FbcJNhM6SIUU7R3bqKt6KADheI8
         ZTnuICxPrnbW63zS3zjFjNuI2GxxBajQ3Q+l/vB3JSgdcyMqsARt09ZPdvkBw944jm2S
         Zh56W1aOrB8+XyqM6zg7rf0Jj3p02E+DQehMLf1per5XFNR5mKgWeRKF/m8rbRxTUaHN
         TQwGoXvB/n4NAgEZ2Yb2xGhj5tsIxfeT6Kd303libW73sr8Ggnw9Wx4Ez8tbWsoNfA78
         8kiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769240825; x=1769845625;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4v/ARzgQrLTE+mBIPvWEGmSWVJQf1rVB4tDf1RFfnKA=;
        b=gisoA2OQvpWI82YYCkFK3Ko+1/wdcolUcpV6WBZLvoktcUSq2g4eBDbPRZfzeMrOuD
         j1Edn37E9fyn5ksIQulsKhvG40INxZs8DivDVewrfqWad6ySy2ADs88CCZEUhok5MVxa
         TtawIr1+ALYlZbcDdWY8CrWlW6PFB1nMuRd02B2ytQj6PI/yQHQHoUmv3Vt5yfKuuRsY
         8nXfsBU8vdulJu8fiW7el2QZ/EX27Y8RcnmmZj3WfcQl17xItCvfdGp7fY0CITXfcFAO
         wzYSl7/1BV+8SiyrHLipoFUZUWOHpsTezsPnKuieTL4Nwm+Abv56+qWPK89t0XQNKkPa
         lFdw==
X-Forwarded-Encrypted: i=1; AJvYcCWnwZpp8KKlv2CkTr54WRSmBVino8pWLPAaRtu//BWX7HhSqE9rmDgU/J8yos1Z05ykg/U=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywq3AovC6UbdkvvrGZAfF1ZmxsVjWeGhuTR4TvhoS9botxjW98x
	oEVsrcOx99pFXdYV2uRVuvRjW3j1ttWXekMj1bx6IQVHj6RGjD+XS3uT/9GGtfk8UVubMjySl8d
	xeJffGJcgmVT+znv28Cw7KkSM22NcQhRyBknbU2rB/pjvPbTdWeNqQ7c6O54M7XRnailcVCe/f9
	40yILuUVnt5tvdDYssysWMOw1GBpqq
X-Gm-Gg: AZuq6aLLovreH5iCBABqKV9tqgCeUhB7qrBOWRkGgS4khdO7mR6xciZEO09QE+hceHV
	q1ovYwtmmZ2iq9nS5GfDV5gGp4QIP4oYX75u3Yq7AgS40Z5F4nwvS7BSIE9m/S0lBEd8HrCK9e5
	PoEoqmoff2Uocc9ROMA0tGUqymngLMClAQwljLS8Tqds8rfxoTDb/jzK1vC/DABga/yAlQiTCF7
	sMiq0d8t/eP/6uK8WHdBbQFJ2P8mwWDKJBLaenFtFr2tS9QidenrOYWWXoQf2j5NgLoLg==
X-Received: by 2002:a5d:64e7:0:b0:430:f736:7cc with SMTP id ffacd0b85a97d-435b1ab83f6mr8611687f8f.1.1769240825318;
        Fri, 23 Jan 2026 23:47:05 -0800 (PST)
X-Received: by 2002:a5d:64e7:0:b0:430:f736:7cc with SMTP id
 ffacd0b85a97d-435b1ab83f6mr8611661f8f.1.1769240824848; Fri, 23 Jan 2026
 23:47:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aWizsSzD3fRWMsAc@kernel.org>
In-Reply-To: <aWizsSzD3fRWMsAc@kernel.org>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Sat, 24 Jan 2026 08:46:53 +0100
X-Gm-Features: AZwV_Qin5BW9ER_Rro9iMC2v0VFsd8G87ICtOoRCsPXIgFxX4oq4YSVsDFm_Yo8
Message-ID: <CABgObfYb7yK7CCq5iEXjfa+=DnYBUG7YnKxR-wjK0mY=nB47Dg@mail.gmail.com>
Subject: Re: KVM/arm64 fixes for 6.19
To: Oliver Upton <oupton@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	TAGGED_FROM(0.00)[bounces-69035-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 8DF287CE04
X-Rspamd-Action: no action

On Thu, Jan 15, 2026 at 10:30=E2=80=AFAM Oliver Upton <oupton@kernel.org> w=
rote:
>
> Hi Paolo,
>
> Here is the first (and likely only) set of fixes for 6.19. Small batch
> of changes fixing issues in non-standard configurations like pKVM, hVHE,
> and nested.
>
> Details are in the tag, please pull.

Pulled, thanks - I waited to see if anything else came around from
other architectures, but it seems like things are calm.

Paolo

> Thanks,
> Oliver
>
> The following changes since commit f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1=
da:
>
>   Linux 6.19-rc3 (2025-12-28 13:24:26 -0800)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git/ tags=
/kvmarm-fixes-6.19-1
>
> for you to fetch changes up to 19cffd16ed6489770272ba383ff3aaec077e01ed:
>
>   KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walkers (2=
026-01-10 02:19:52 -0800)
>
> ----------------------------------------------------------------
> KVM/arm64 fixes for 6.19
>
>  - Ensure early return semantics are preserved for pKVM fault handlers
>
>  - Fix case where the kernel runs with the guest's PAN value when
>    CONFIG_ARM64_PAN is not set
>
>  - Make stage-1 walks to set the access flag respect the access
>    permission of the underlying stage-2, when enabled
>
>  - Propagate computed FGT values to the pKVM view of the vCPU at
>    vcpu_load()
>
>  - Correctly program PXN and UXN privilege bits for hVHE's stage-1 page
>    tables
>
>  - Check that the VM is actually using VGICv3 before accessing the GICv3
>    CPU interface
>
>  - Delete some unused code
>
> ----------------------------------------------------------------
> Alexandru Elisei (4):
>       KVM: arm64: Copy FGT traps to unprotected pKVM VCPU on VCPU load
>       KVM: arm64: Inject UNDEF for a register trap without accessor
>       KVM: arm64: Remove extra argument for __pvkm_host_{share,unshare}_h=
yp()
>       KVM: arm64: Remove unused parameter in synchronize_vcpu_pstate()
>
> Dongxu Sun (1):
>       KVM: arm64: Remove unused vcpu_{clear,set}_wfx_traps()
>
> Marc Zyngier (2):
>       KVM: arm64: Fix EL2 S1 XN handling for hVHE setups
>       KVM: arm64: Don't blindly set set PSTATE.PAN on guest exit
>
> Oliver Upton (1):
>       KVM: arm64: nv: Respect stage-2 write permssion when setting stage-=
1 AF
>
> Sascha Bischoff (1):
>       KVM: arm64: gic: Check for vGICv3 when clearing TWI
>
> Will Deacon (1):
>       KVM: arm64: Invert KVM_PGTABLE_WALK_HANDLE_FAULT to fix pKVM walker=
s
>
>  arch/arm64/include/asm/kvm_asm.h        |  2 ++
>  arch/arm64/include/asm/kvm_emulate.h    | 16 ----------------
>  arch/arm64/include/asm/kvm_pgtable.h    | 16 ++++++++++++----
>  arch/arm64/include/asm/sysreg.h         |  3 ++-
>  arch/arm64/kernel/image-vars.h          |  1 +
>  arch/arm64/kvm/arm.c                    |  1 +
>  arch/arm64/kvm/at.c                     |  8 ++++++--
>  arch/arm64/kvm/hyp/entry.S              |  4 +++-
>  arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
>  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  3 +++
>  arch/arm64/kvm/hyp/nvhe/pkvm.c          |  1 -
>  arch/arm64/kvm/hyp/nvhe/switch.c        |  2 +-
>  arch/arm64/kvm/hyp/pgtable.c            |  5 +++--
>  arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
>  arch/arm64/kvm/mmu.c                    | 12 +++++-------
>  arch/arm64/kvm/sys_regs.c               |  5 ++++-
>  arch/arm64/kvm/va_layout.c              | 28 +++++++++++++++++++++++++++=
+
>  17 files changed, 73 insertions(+), 38 deletions(-)
>


