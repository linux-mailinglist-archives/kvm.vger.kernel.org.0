Return-Path: <kvm+bounces-65164-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E243C9C6FA
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 18:39:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73C743A62BA
	for <lists+kvm@lfdr.de>; Tue,  2 Dec 2025 17:39:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EFC29AAE3;
	Tue,  2 Dec 2025 17:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IStVDJEl";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="myG1ZaFt"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A52C2C11D9
	for <kvm@vger.kernel.org>; Tue,  2 Dec 2025 17:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764697178; cv=none; b=MeiOMTiKbSSbGgltVOBsSIuVP5puGVGslYkiEnfm9NpIXu1RWDUqaXbEXhcI1Ed5cdybPVYIQOu+1/+tb84w7q9eui1i6vIzptA3nEDcsdasuLFqy2JaITi6QQO2RzVhxWjL+KgiIiYKTUcOWfnuO/EIxYmxFmsMApGWWjr6E28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764697178; c=relaxed/simple;
	bh=oInRkGJiJ2P6Yt6xSBvvIBIikMUAG2Q4J8//1n5jS60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eINIZt0TVed14GuwjsgVK61mXz/tcK3pTVOsLL7BIWOvQABv7aluvRNomU7tzMTU3j63qkRobQQnhQRS3nmbG+vX/3wpdYAeuS8wIepnqaiJTMVANL1LwPjOvBHzat6CFIM5G8ill3frNF6YA62hg5T8EKLBfIzxI5hMWe/UENA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IStVDJEl; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=myG1ZaFt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764697175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uo2vKek2jWqEfIF/rtdHvm9y4Cw5ZkqAU8NTL1Lxbs8=;
	b=IStVDJElOG/LTA4t6SY49Fmk/VhVRRYvym70++jxV8rYMX70E65KQ6XOUalb37gCI6yGjH
	jJ/Ql3LSId4Kxz79CwBhwaT91tpuDlA7yTD2n4Kq6x2qji6QIR6z2ZrHRseRvgWZI1kr4K
	1fMNPn50OAQjJFby1pYlCR3FXiJRdIU=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-658-zrWWunchM_yRgOaOTcOmCQ-1; Tue, 02 Dec 2025 12:39:34 -0500
X-MC-Unique: zrWWunchM_yRgOaOTcOmCQ-1
X-Mimecast-MFC-AGG-ID: zrWWunchM_yRgOaOTcOmCQ_1764697174
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-42e2d5e833fso1646652f8f.1
        for <kvm@vger.kernel.org>; Tue, 02 Dec 2025 09:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764697173; x=1765301973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uo2vKek2jWqEfIF/rtdHvm9y4Cw5ZkqAU8NTL1Lxbs8=;
        b=myG1ZaFtBb2tZPP5S3GxWOaCfu2Fp+i44+wZ6UK5aueXr5i/q3mUrsFAndGSTFdTqB
         SWadKdTdgCR3mMA9qqcklUzLEMyh7Eso9But7UFSGB5cYY5vmSrWMwE4KwghPGb7lcNW
         jpxxQzVCqXu1XbzHFuFbMgkntlmyPeVh8h/ix/ZFpDK9DS8Sn2UkhMFiYQ+yL6rrnk/g
         Uv7ymvX+mWnZGw021yCiQUjU4WufY58/G2cPAmSE4Z1pzIJdL3Xz46U7tbkScfp3rLao
         aSGODySIZTQOOjRM8lbKp+LpHumL+lxr+naStWi562/5BP/oRZT8Pqz71KFE35nQcxWa
         cMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764697173; x=1765301973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uo2vKek2jWqEfIF/rtdHvm9y4Cw5ZkqAU8NTL1Lxbs8=;
        b=Xx2AKT9uQvUJ2BhrnhlCMO5xL4eLT6XgKQHPmqA8ZTRE3RgyXvxTJyN65J7NHpJDDE
         YxyHMMj9aYy7gdt9aTzbfAgU8UdtlcRQ7NhW76s5/UMKgSJuqldYibi+hy9r68W21VEC
         UnZ36Tx6cMl+gQccrbPl2Xsdfj7k73p6CN4dCebOpNfQcECopshsYJzM6qckiTOXcQ39
         WmhaP4Ni7srWwsNGneojhhx1SOgM8ypggI2fCFCEXdXFZtobhSYDoBRDn/J8BsHF/8ZG
         Ryna1WQmdCMKFxROOJr3tWu28gq1yOXkR+cWfd86KXamYRWTsB2WA6+UFrq6tITtcvRC
         CQRw==
X-Gm-Message-State: AOJu0Yzw7aizVI6xu8QXl4oTi2bfKo3HYyKChSYRedg/wHjfYWlFe0uP
	gkIvS2jtUcQjd9genGbhrq88ELj4h7iD5pRH2DR6zSnMtUY9BWaSMN8HUcWxh94tW4nOjsHMy2z
	Baa8rjx3Sq3rD41ho1PNvT620fOxSv7JBzfWxZfxSr8SpElVibG9Fl4DJGal/90mSE63GKuwqFB
	9HvyLVPpBPS0TFE0BDGUy2nKfHI+HopOn4lbhJ
X-Gm-Gg: ASbGncv05jPxUgWd+kGG1ReW9mZmGuxh3w0pgopF3J2fu/xx7QSPMmsIQr2CYIrzHJB
	XNOje/Ktoqq7/71FgzwIui0YsAhyytvtjhc7zDyltsJBOLimP6W+l4UZWh+RJeFTk60rWzRd/5D
	wXOZeyMQePJJWy/cGJZ5qTlzR4xycUFUWv7R5RRQixrK8LH3B1h/X4erEwZpKd/spK+F1hf7YxR
	jK3keHG94+XfU0LyoH5Mq0kzoPwlll0aq627ECOIw0EhfCmjsF1VYB389C3iGz4bsC1pEY=
X-Received: by 2002:a5d:5848:0:b0:427:8c85:a4ac with SMTP id ffacd0b85a97d-42cc1d0c9d6mr47265256f8f.47.1764697172682;
        Tue, 02 Dec 2025 09:39:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFnNIloFvxiRUn+fYrIxvCBSBE79k+FBv1YJFndwydrDPdofVuZxX6cMXMrJsUx2ak1P6rmZDLHt9YSXMBuB50=
X-Received: by 2002:a5d:5848:0:b0:427:8c85:a4ac with SMTP id
 ffacd0b85a97d-42cc1d0c9d6mr47265227f8f.47.1764697172220; Tue, 02 Dec 2025
 09:39:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251201124334.110483-1-frankja@linux.ibm.com>
In-Reply-To: <20251201124334.110483-1-frankja@linux.ibm.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 2 Dec 2025 18:39:19 +0100
X-Gm-Features: AWmQ_bnfBNG38_ENciLUbvBKRtiiVX_KXI-I92nNeDJP9V2a5Q0LIpEicEzHXKM
Message-ID: <CABgObfZ2Am9dDJdNUDz2yLif6Z_wqLVdv41HYbWRmb4Jo+EBeg@mail.gmail.com>
Subject: Re: [GIT PULL 00/10] KVM: s390: Changes for v6.19
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, david@redhat.com, borntraeger@linux.ibm.com, 
	cohuck@redhat.com, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, 
	hca@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 1, 2025 at 1:45=E2=80=AFPM Janosch Frank <frankja@linux.ibm.com=
> wrote:
>
> Hi Paolo,
>
> here are the s390 changes for 6.19:
> - SCA rework
> - VIRT_XFER_TO_GUEST_WORK support
> - Operation exception forwarding support
> - Cleanups
>
>
> The operation exception forward patch had a conflict because of
> capability numbering. The VIRT_XFER_TO_GUEST_WORK may or may not have
> a conflict with the s390 repo because the kvm-s390.c imports are
> changed in close proximity. Both conflicts are trivial and the
> resolution for the capability numbering is already in next.

All good, I gave you 246 as in linux-next.

Paolo

>
> Please pull.
>
> Cheers,
> Janosch
>
> The following changes since commit 211ddde0823f1442e4ad052a2f30f050145cca=
da:
>
>   Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)
>
> are available in the Git repository at:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git tags/=
kvm-s390-next-6.19-1
>
> for you to fetch changes up to 2bd1337a1295e012e60008ee21a64375e5234e12:
>
>   KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK functions (2025-11-28 10=
:11:14 +0100)
>
> ----------------------------------------------------------------
> - SCA rework
> - VIRT_XFER_TO_GUEST_WORK support
> - Operation exception forwarding support
> - Cleanups
> ----------------------------------------------------------------
> Andrew Donnellan (2):
>       KVM: s390: Add signal_exits counter
>       KVM: s390: Use generic VIRT_XFER_TO_GUEST_WORK functions
>
> Christoph Schlameuss (2):
>       KVM: s390: Use ESCA instead of BSCA at VM init
>       KVM: S390: Remove sca_lock
>
> Eric Farman (1):
>       KVM: s390: vsie: Check alignment of BSCA header
>
> Heiko Carstens (1):
>       KVM: s390: Enable and disable interrupts in entry code
>
> Janosch Frank (2):
>       Documentation: kvm: Fix ordering
>       KVM: s390: Add capability that forwards operation exceptions
>
> Josephine Pfeiffer (1):
>       KVM: s390: Replace sprintf with snprintf for buffer safety
>
> Thorsten Blum (1):
>       KVM: s390: Remove unused return variable in kvm_arch_vcpu_ioctl_set=
_fpu
>
>  Documentation/virt/kvm/api.rst                   |  19 ++++++++-
>  arch/s390/include/asm/kvm_host.h                 |   8 ++--
>  arch/s390/include/asm/stacktrace.h               |   1 +
>  arch/s390/kernel/asm-offsets.c                   |   1 +
>  arch/s390/kernel/entry.S                         |   2 +
>  arch/s390/kvm/Kconfig                            |   1 +
>  arch/s390/kvm/gaccess.c                          |  27 +++---------
>  arch/s390/kvm/intercept.c                        |   3 ++
>  arch/s390/kvm/interrupt.c                        |  80 ++++++++---------=
------------------
>  arch/s390/kvm/kvm-s390.c                         | 229 +++++++++++++++++=
++++++++++-----------------------------------------------------------------=
-------
>  arch/s390/kvm/kvm-s390.h                         |   9 +---
>  arch/s390/kvm/vsie.c                             |  20 ++++++---
>  include/uapi/linux/kvm.h                         |   1 +
>  tools/testing/selftests/kvm/Makefile.kvm         |   1 +
>  tools/testing/selftests/kvm/s390/user_operexec.c | 140 +++++++++++++++++=
+++++++++++++++++++++++++++++++++++++++++++
>  15 files changed, 271 insertions(+), 271 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/s390/user_operexec.c
>
> --
> 2.52.0
>


