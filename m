Return-Path: <kvm+bounces-70888-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iGeAEs/CjGkmswAAu9opvQ
	(envelope-from <kvm+bounces-70888-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 18:56:31 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F04C126BE9
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 18:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id B2007300622E
	for <lists+kvm@lfdr.de>; Wed, 11 Feb 2026 17:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98D9A21ADA7;
	Wed, 11 Feb 2026 17:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WZESx+EJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="bm19n/Bc"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9079B33A005
	for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 17:56:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770832581; cv=pass; b=N6ikh5qMoqScqIHC20kn7obZTuv0OjEm8eqFNAxP9bTU2nB5de1opjUFAkLMKidQsrtrMF93P+9xfche+ObaLgMehcdiXfQs5jWZKswhxndw6G42ThO2IHvPkNGzjoAT2nnfNCRURSpbCt9gFDtryjwlv3vZd43IYD19apjGtp0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770832581; c=relaxed/simple;
	bh=tdnSHppX8fKny9j+IheuQlJfOXx1xSVuDy+wyCpiR0k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tQfGnpiH06AThH6N6taFnnVLhTIBg3vplw/WRXyI8R06y5+vb8d9Tj5LJapalZWZOhTPJZ93uJ5th9aup6YrY4aCN2B1RdY2TFVAfxoP9/lm26F1XBObtiuovUzalcTEchxPSjnsRC2409Wi1zEyXzLIyaH0bjpa6cDH6Eihxe4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WZESx+EJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=bm19n/Bc; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770832579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SBepvMDI86eMqlHW2ZOYJH4TD+aKg4qs5KHoUc8nhYA=;
	b=WZESx+EJqtYoz7oOsajNYWiNfB02fIcTZVyK27WVTeiIQd04v5/WnMm1bhAGIUUmeLAf7k
	Tb19UjvMdGoE7Mg9jLZktYLS1ISVZX4Gz6swQ41sMgYTUXnMdrvFATa/Aq1cr4DcNxPsym
	XUJMkSIrteks6+g7s+WKfuoZPxEl9kc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-H1nuj5UeMSawKn5qxRQUZw-1; Wed, 11 Feb 2026 12:56:18 -0500
X-MC-Unique: H1nuj5UeMSawKn5qxRQUZw-1
X-Mimecast-MFC-AGG-ID: H1nuj5UeMSawKn5qxRQUZw_1770832577
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-437681ecd32so2362587f8f.1
        for <kvm@vger.kernel.org>; Wed, 11 Feb 2026 09:56:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770832577; cv=none;
        d=google.com; s=arc-20240605;
        b=en185rbZpj4pXBqA/rFfhjWg3Fz4aIK+lAPM4rAYBY5B5E+8R5brO5avTY++wRBByP
         ynDYW0m+IAh74Ni1Vz34bvFmm4iDj6JIzu7HqjGt92jL9kZNmALsh8cKL0Y5JeX38nFW
         IzDNte0wqiNsM0S7Vd8GCq3yzr1x0UfGGOI5WMDYlReq+8vCwHc1wl7zGQSQwu9xtTVJ
         67GsVMzNIJy22DJa80K6Y4ns+4DNvd+GORzs1HCka7RopdenbM1XLKVDAFmlMQ7LEhon
         PBOfT+Pxg+kFgwWF9L7OpY+D3uZ+Tkxi1Y6WwHzL2I9047YCzd10dtnJy6N2CrAORvRr
         GfCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SBepvMDI86eMqlHW2ZOYJH4TD+aKg4qs5KHoUc8nhYA=;
        fh=RMWI6ZOV2DRs8DEeM3Hu70UjDLDbUElIhfkcQA0D+MA=;
        b=VIQ/MxtcWwnI854gUeb1T/XmRKrxht650W3CnBa9POVHPsu5XaWfaW2o12q/veLLg6
         ddH6CXE46B6oraBY0zf2cnxl/g9t8NupRIiHqVciRKDgR/B8ncA0qrCE9yaDJA/yJQj9
         AGfKYzfxIf70Es8OwuW0K9qjPr/44SKEs9stJDMkj0QavP1MYlUNnXDaHc5MTULXrlNb
         TpHdv9UVZZ7/sNCJsqjJFOM0NO/Btw9l4rxuDJCArQq/z4xsytFg8hHRccj32Wbx4j0V
         9N4Dktz96O6u9CB1AePiMgE/wMQhyPBWeRbY9NhMQDX6SQxP94T+wsBQAwKluj3hiswz
         L/6Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770832577; x=1771437377; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBepvMDI86eMqlHW2ZOYJH4TD+aKg4qs5KHoUc8nhYA=;
        b=bm19n/BcG4aPBE3KRKl08ZeFWjdU8jQuaMRHSuq6bB7nb0sUQiFo4m3/JH6tTcwQM0
         fcz8sjzMYm+8pbGkS2OFHRLMgnhg4AVFIB+LmdmILsod2A0UbiupR0g0h+Ayn1CB5mvn
         i8uz5Ga8kN22x2QT8S2ODGbuizLuhvy1im85pPxMmSuuzlsoF2PukmElY3cQKLH63V9t
         TLbuRVoZG74AMF5kXGzhIgOoav+pyVfgurc3FGJcXwKqEJRecHARfmERvkrRHhpxUrZf
         3MXUydBidHuJITamyaY2PkM6foMIvwmaeFDcOGxhY2mdx0Yg6GJlLRJaTEo8gLr9bEq7
         6idg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770832577; x=1771437377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SBepvMDI86eMqlHW2ZOYJH4TD+aKg4qs5KHoUc8nhYA=;
        b=PNRcBUu1WNz5EABF7bFiuB6vBJU/izxzL+mPqSR4mvG571VhGj0gBkI31c90RVAYb9
         5y7r+gHW9ZacH1CP9YeYgjaCxYoZlt2WkQCPUlY4Srs0AOGz6TlVW6XT/CcR/qnPbKIC
         j8TuXoCupJftn6AB3Em2ENy4o6Md5JKYsGBnkbWi2Zt2xxwtmAL0rTd+/QQpYQ5Qx6M+
         VTVAVtVAkbsnhihHeNH3Bu5hVkS7CcnuxjPN6WUAuyb050aGLrRiYhzYBF04qtxspxGh
         luoqoZW7kVLlT4ruYdzgxwpInZ4z2DWsHIjMvDvcVws5x0pbtIFLMHQfzXni3gPa9gUt
         pycw==
X-Gm-Message-State: AOJu0Yx66i/5HDppMbIXMU7wrIfqVzxwvNZ3QPvVtEG+V+SPGtCb9R8f
	//v67LAve5FmvPLtAn6G3ywbrelPc71UQYis6CAOlgpshRz6nyzDSp8IgO+V+HENsosk0wxnr3p
	gaIlXZBh5OYrgurZzXr0syrmTRdx2ak+npifAJu0eA6IGP3bicslNyqpfkxTWsg15oU8uB6sbwx
	cm+dm+YZ7l7TKUAHnGHON1A94EnvjK
X-Gm-Gg: AZuq6aLdbNvwpqb98uaJjQOFw2N9alU/FAHiM0xpPTaU0M/4xTcFGBZ9p01jAV9Ww3t
	YHoS+Y/Tm3addGv8jAPb0y1Lgo91TqEQxqAZyXQRFsAMpX58cZQTxWSj6QnEPnozvDcVfsZJSBr
	TIncJPCxl2n5WQdLS/fv6DaMy5SnZ8VACgaA+bYRX7d6fSzbPgD8i9EB8yJXO5z5VRKwvknqQGv
	8aK6+TTJRrPxJgWK31XsQsj8EDof63cU/TLhxQxf16HBtHPahxyPWUvPs3yJ9jrgyHMYoZT/SN3
	anqJbw==
X-Received: by 2002:a5d:5f84:0:b0:436:1707:2884 with SMTP id ffacd0b85a97d-4378acb1963mr495518f8f.56.1770832576937;
        Wed, 11 Feb 2026 09:56:16 -0800 (PST)
X-Received: by 2002:a5d:5f84:0:b0:436:1707:2884 with SMTP id
 ffacd0b85a97d-4378acb1963mr495478f8f.56.1770832576472; Wed, 11 Feb 2026
 09:56:16 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210153417.77403-1-imbrenda@linux.ibm.com>
In-Reply-To: <20260210153417.77403-1-imbrenda@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Wed, 11 Feb 2026 18:56:04 +0100
X-Gm-Features: AZwV_QjgpeaKV1waGQm6gTDtTrSf0wgO6f0d0IIYD1zOBnHUXjifKG5D1BMpCHs
Message-ID: <CABgObfZquLMMZ6vHc2JcrjrQuY03pbj5vNc8v+PNW8_t5Dpo5w@mail.gmail.com>
Subject: Re: [GIT PULL v1 00/36] KVM/s390: Three small patches, and a huge series
To: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, frankja@linux.ibm.com, 
	borntraeger@de.ibm.com, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70888-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 4F04C126BE9
X-Rspamd-Action: no action

On Tue, Feb 10, 2026 at 4:34=E2=80=AFPM Claudio Imbrenda <imbrenda@linux.ib=
m.com> wrote:
>
> Ciao Paolo,
>
> Today's pull request is rather large, as it (finally!) contains the gmap
> rewrite.

Yay! Next, KVM_GENERIC_DIRTYLOG_READ_PROTECT? :)

Thanks,

Paolo

> It also contains 3 small items:
> * vSIE performance improvement
> * maintainership update for s390 vfio-pci
> * small (but important) quality of life improvement for protected guests
>
>
> The following changes since commit 9448598b22c50c8a5bb77a9103e2d49f134c95=
78:
>
>   Linux 6.19-rc2 (2025-12-21 15:52:04 -0800)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-7.0-1
>
> for you to fetch changes up to e3372ffb5f9e2dda3da259b768aab6271672b90d:
>
>   KVM: s390: Increase permitted SE header size to 1 MiB (2026-02-10 12:21=
:30 +0100)
>
> ----------------------------------------------------------------
> - gmap rewrite: completely new memory management for kvm/s390
> - vSIE improvement
> - maintainership change for s390 vfio-pci
> - small quality of life improvement for protected guests
>
> ----------------------------------------------------------------
> Arnd Bergmann (1):
>       KVM: s390: Add explicit padding to struct kvm_s390_keyop
>
> Claudio Imbrenda (32):
>       KVM: s390: Refactor pgste lock and unlock functions
>       KVM: s390: Add P bit in table entry bitfields, move union vaddress
>       s390: Make UV folio operations work on whole folio
>       s390: Move sske_frame() to a header
>       KVM: s390: Add gmap_helper_set_unused()
>       KVM: s390: Introduce import_lock
>       KVM: s390: Export two functions
>       s390/mm: Warn if uv_convert_from_secure_pte() fails
>       KVM: s390: vsie: Pass gmap explicitly as parameter
>       KVM: s390: Enable KVM_GENERIC_MMU_NOTIFIER
>       KVM: s390: Rename some functions in gaccess.c
>       KVM: s390: KVM-specific bitfields and helper functions
>       KVM: s390: KVM page table management functions: allocation
>       KVM: s390: KVM page table management functions: clear and replace
>       KVM: s390: KVM page table management functions: walks
>       KVM: s390: KVM page table management functions: storage keys
>       KVM: s390: KVM page table management functions: lifecycle managemen=
t
>       KVM: s390: KVM page table management functions: CMMA
>       KVM: s390: New gmap code
>       KVM: s390: Add helper functions for fault handling
>       KVM: s390: Add some helper functions needed for vSIE
>       KVM: s390: Stop using CONFIG_PGSTE
>       KVM: s390: Storage key functions refactoring
>       KVM: s390: Switch to new gmap
>       KVM: s390: Remove gmap from s390/mm
>       KVM: S390: Remove PGSTE code from linux/s390 mm
>       KVM: s390: Enable 1M pages for gmap
>       KVM: s390: Storage key manipulation IOCTL
>       KVM: s390: selftests: Add selftest for the KVM_S390_KEYOP ioctl
>       KVM: s390: Use guest address to mark guest page dirty
>       KVM: s390: vsie: Fix race in walk_guest_tables()
>       KVM: s390: vsie: Fix race in acquire_gmap_shadow()
>
> Eric Farman (2):
>       KVM: s390: vsie: retry SIE when unable to get vsie_page
>       MAINTAINERS: Replace backup for s390 vfio-pci
>
> Steffen Eiden (1):
>       KVM: s390: Increase permitted SE header size to 1 MiB
>
>  Documentation/virt/kvm/api.rst           |   42 +
>  MAINTAINERS                              |    5 +-
>  arch/s390/Kconfig                        |    3 -
>  arch/s390/include/asm/dat-bits.h         |   32 +-
>  arch/s390/include/asm/gmap.h             |  174 ---
>  arch/s390/include/asm/gmap_helpers.h     |    1 +
>  arch/s390/include/asm/hugetlb.h          |    6 -
>  arch/s390/include/asm/kvm_host.h         |    7 +
>  arch/s390/include/asm/mmu.h              |   13 -
>  arch/s390/include/asm/mmu_context.h      |    6 +-
>  arch/s390/include/asm/page.h             |    4 -
>  arch/s390/include/asm/pgalloc.h          |    4 -
>  arch/s390/include/asm/pgtable.h          |  171 +--
>  arch/s390/include/asm/tlb.h              |    3 -
>  arch/s390/include/asm/uaccess.h          |   70 +-
>  arch/s390/include/asm/uv.h               |    3 +-
>  arch/s390/kernel/uv.c                    |  142 +-
>  arch/s390/kvm/Kconfig                    |    2 +
>  arch/s390/kvm/Makefile                   |    3 +-
>  arch/s390/kvm/dat.c                      | 1391 +++++++++++++++++
>  arch/s390/kvm/dat.h                      |  970 ++++++++++++
>  arch/s390/kvm/diag.c                     |    2 +-
>  arch/s390/kvm/faultin.c                  |  148 ++
>  arch/s390/kvm/faultin.h                  |   92 ++
>  arch/s390/kvm/gaccess.c                  |  961 +++++++-----
>  arch/s390/kvm/gaccess.h                  |   20 +-
>  arch/s390/kvm/gmap-vsie.c                |  141 --
>  arch/s390/kvm/gmap.c                     | 1244 +++++++++++++++
>  arch/s390/kvm/gmap.h                     |  244 +++
>  arch/s390/kvm/intercept.c                |   15 +-
>  arch/s390/kvm/interrupt.c                |   12 +-
>  arch/s390/kvm/kvm-s390.c                 |  958 +++++-------
>  arch/s390/kvm/kvm-s390.h                 |   27 +-
>  arch/s390/kvm/priv.c                     |  213 +--
>  arch/s390/kvm/pv.c                       |  177 ++-
>  arch/s390/kvm/vsie.c                     |  202 +--
>  arch/s390/lib/uaccess.c                  |  184 +--
>  arch/s390/mm/Makefile                    |    1 -
>  arch/s390/mm/fault.c                     |    4 +-
>  arch/s390/mm/gmap.c                      | 2436 ------------------------=
------
>  arch/s390/mm/gmap_helpers.c              |   96 +-
>  arch/s390/mm/hugetlbpage.c               |   24 -
>  arch/s390/mm/page-states.c               |    1 +
>  arch/s390/mm/pageattr.c                  |    7 -
>  arch/s390/mm/pgalloc.c                   |   24 -
>  arch/s390/mm/pgtable.c                   |  814 +---------
>  include/linux/kvm_host.h                 |    2 +
>  include/uapi/linux/kvm.h                 |   12 +
>  mm/khugepaged.c                          |    9 -
>  tools/testing/selftests/kvm/Makefile.kvm |    1 +
>  tools/testing/selftests/kvm/s390/keyop.c |  299 ++++
>  51 files changed, 5920 insertions(+), 5502 deletions(-)
>  delete mode 100644 arch/s390/include/asm/gmap.h
>  create mode 100644 arch/s390/kvm/dat.c
>  create mode 100644 arch/s390/kvm/dat.h
>  create mode 100644 arch/s390/kvm/faultin.c
>  create mode 100644 arch/s390/kvm/faultin.h
>  delete mode 100644 arch/s390/kvm/gmap-vsie.c
>  create mode 100644 arch/s390/kvm/gmap.c
>  create mode 100644 arch/s390/kvm/gmap.h
>  delete mode 100644 arch/s390/mm/gmap.c
>  create mode 100644 tools/testing/selftests/kvm/s390/keyop.c
>


