Return-Path: <kvm+bounces-51780-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 901CEAFCE4D
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 16:55:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF8CF564310
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 14:54:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B3452E091F;
	Tue,  8 Jul 2025 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iwVvK5v8"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298142E0912
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 14:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751986422; cv=none; b=WG5EatmAXZ3z7vVuLfFpXFZB1zpbDbwdvxtTYMyoDNJ3rkCDWmMQHzPEzD1sDaDDtVxG1GRdwBwuyZaaejTEfEeU3PAQPJKaF67KP63oP5PWVKQF8xxMIyFLcUkQTPheVtvurQoWvwj7A2pTfPISxb87K318nLLJzMoN9qB+vRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751986422; c=relaxed/simple;
	bh=d7gbSEXI43GBTfZOdsHtl52JHaIzxl8mG4ZoaZZRJe0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SBzQwroDJ+k/esraomslLEOScDF/7M8lu1BXkx3k8QG1vAQp9szL/uZqxWWbU4m/9sCI6pdJAYEsLiWxZvhsLA3IfL4ir2s3LJguQloN0FMlhJA01Hs0v3VtuP3NqNSBSznoHiwSs+joL4O4tUmIzxcI7M50ZzlBB2moGlCr1RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iwVvK5v8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751986420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F3gWcJzt2OgQaD/j6Pq/hyKgRUxk20XSr1dWAvhw+P4=;
	b=iwVvK5v8ofZ67sNSXxilE4nBDLGMcyA4oe8ZacH/zom9xKeLBG//4u/y25hTtZUFawK5Ry
	vrSl+pAQ0Rji8VQ25uddQHQXaqLyMnXGraMEH0ljsnqghKN8ZLUZqlUH54fy+5ugfP25RX
	6mtuR+jmIrz/vrD3EjhnHoqlTp+U2t8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-ZxdV0QyANFGsgTx3czDtgg-1; Tue, 08 Jul 2025 10:53:39 -0400
X-MC-Unique: ZxdV0QyANFGsgTx3czDtgg-1
X-Mimecast-MFC-AGG-ID: ZxdV0QyANFGsgTx3czDtgg_1751986418
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3a4fabcafecso1932306f8f.0
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 07:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751986417; x=1752591217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3gWcJzt2OgQaD/j6Pq/hyKgRUxk20XSr1dWAvhw+P4=;
        b=qK5tyyHd5UxGch5DMO367tjVoueTeSACTzEYMr0RcPAyhYZNesg/+sXrhlZEssZq1z
         kUdbiw0TxCuXiHNd6llKjLwk+GGYtp5I/mxb94oBPTFKnaitvAiVVuSbtvgnp7kH8Kwm
         c70WGLC//LCvRfsZcT+15vAlPEjdD9r114ahcF+U/h8hXuCRRXO71bGCU7YQmSedCon6
         GmIBHw1wKvnaI0FxhEo/HzStuzrSGNwka5ztH2Gk/juQ7KTXzYgF04pqrvb14/ZKqBhm
         Sd7UZ1CwQoL5d0rOhVceuTe5LIb0zUaSl3mzZqrH+vQrES+EZpLzQ+/IDEhnRL76wif+
         Gu0w==
X-Gm-Message-State: AOJu0Yz5P0Yysxk1biDe8jjz+KOdxfj4T7x6Yx4QHuTOAMDXej9ydnFk
	M708DiVb3bic1MGBq6zLrsFh2gZPIIbzIeeYvPHLTDwKu1AJZ+wPuTcRL7j7W7TpLSKqiVMg5FU
	N4dYkA60JF6Vd5tx25N4BfJxgGDxi265D57gL4zYKTCUwZnYruEFdRVFYJv4XTJ2HIaLZDBIBG6
	n7Z3JZYzGBYs0UHEt1YrLd/JuEzo9il2ufZ8d8
X-Gm-Gg: ASbGncuFsGWsOh/ahrF0Vv1Pwa3S8h+dXlJEcWXcv5BhUJC5SMAEXxXTgqM73UblXJH
	g8JFYHnM4yD+HgiFZ+wsn08BravYUvD7GsrNcGTuARV3hqdrjnoDUw2WVXc87oAd4M5MFbakweh
	qMZg==
X-Received: by 2002:a05:6000:25f8:b0:3a5:1410:71c0 with SMTP id ffacd0b85a97d-3b5dde8bc28mr2590921f8f.38.1751986416878;
        Tue, 08 Jul 2025 07:53:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGg3GmJ0S1o2rJ6zUsGGi+EaAx8edXiRPCdL8Si/WJUjuf8mbyhxY1fg84y1pk7fznC+2FEzhd0WZ1UFOXwtxY=
X-Received: by 2002:a05:6000:25f8:b0:3a5:1410:71c0 with SMTP id
 ffacd0b85a97d-3b5dde8bc28mr2590899f8f.38.1751986416369; Tue, 08 Jul 2025
 07:53:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250626223142.865249-1-seanjc@google.com>
In-Reply-To: <20250626223142.865249-1-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Tue, 8 Jul 2025 16:53:24 +0200
X-Gm-Features: Ac12FXx-DcAtBfbayKvwyU5qyZxOC1zIlmf0cVeiOP-SXoMxreAmZGSLm7CcTLg
Message-ID: <CABgObfaF7Usi=UfreXDwRdnjXZ-zq4PT4bumOXb_Up1cD_UD9A@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Fixes for 6.16-rcN
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 27, 2025 at 12:31=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Please pull a random smattering of fixes for 6.16.  Note, the SEV-ES intr=
a-host
> migration commits received your "Queued, thanks", but they never showed u=
p in
> kvm.git.

Ouch, sorry about htat.

> Oh, and there's one more fix that is probably a candidate for 6.16, but I=
'm
> waiting for a response from the submitter, as I think we can go with a mo=
re
> targeted fix: https://lore.kernel.org/all/aFwLpyDYOsHUtCn-@google.com

Yes, I agree with you there.  I see no reply from Yuntao, so let's
decide tomorrow what to do about it.

>   https://github.com/kvm-x86/linux.git tags/kvm-x86-fixes-6.16-rcN
>
> for you to fetch changes up to fa787ac07b3ceb56dd88a62d1866038498e96230:
>
>   KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush (202=
5-06-25 09:15:24 -0700)

Done.

Paolo

> ----------------------------------------------------------------
> KVM x86 fixes for 6.16-rcN
>
>  - Reject SEV{-ES} intra-host migration if one or more vCPUs are actively
>    being created so as not to create a non-SEV{-ES} vCPU in an SEV{-ES} V=
M.
>
>  - Use a pre-allocated, per-vCPU buffer for handling de-sparsified vCPU m=
asks
>    when emulating Hyper-V hypercalls to fix a "stack frame too large" iss=
ue.
>
>  - Allow out-of-range/invalid Xen event channel ports when configuring IR=
Q
>    routing to avoid dictating a specific ioctl() ordering to userspace.
>
>  - Conditionally reschedule when setting memory attributes to avoid soft
>    lockups when userspace converts huge swaths of memory to/from private.
>
>  - Add back MWAIT as a required feature for the MONITOR/MWAIT selftest.
>
>  - Add a missing field in struct sev_data_snp_launch_start that resulted =
in
>    the guest-visible workarounds field being filled at the wrong offset.
>
>  - Skip non-canonical address when processing Hyper-V PV TLB flushes to a=
void
>    VM-Fail on INVVPID.
>
> ----------------------------------------------------------------
> Binbin Wu (1):
>       Documentation: KVM: Fix unexpected unindent warnings
>
> Chenyi Qiang (1):
>       KVM: selftests: Add back the missing check of MONITOR/MWAIT availab=
ility
>
> David Woodhouse (1):
>       KVM: x86/xen: Allow 'out of range' event channel ports in IRQ routi=
ng table.
>
> Liam Merwick (1):
>       KVM: Allow CPU to reschedule while setting per-page memory attribut=
es
>
> Manuel Andreas (1):
>       KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush
>
> Nikunj A Dadhania (1):
>       KVM: SVM: Add missing member in SNP_LAUNCH_START command structure
>
> Sean Christopherson (3):
>       KVM: SVM: Reject SEV{-ES} intra host migration if vCPU creation is =
in-flight
>       KVM: SVM: Initialize vmsa_pa in VMCB to INVALID_PAGE if VMSA page i=
s NULL
>       KVM: x86/hyper-v: Use preallocated per-vCPU buffer for de-sparsifie=
d vCPU masks
>
>  Documentation/virt/kvm/api.rst                     | 28 +++++++++++-----=
------
>  arch/x86/include/asm/kvm_host.h                    |  7 +++++-
>  arch/x86/kvm/hyperv.c                              |  5 +++-
>  arch/x86/kvm/svm/sev.c                             | 12 ++++++++--
>  arch/x86/kvm/xen.c                                 | 15 ++++++++++--
>  include/linux/psp-sev.h                            |  2 ++
>  .../testing/selftests/kvm/x86/monitor_mwait_test.c |  1 +
>  virt/kvm/kvm_main.c                                |  3 +++
>  8 files changed, 53 insertions(+), 20 deletions(-)
>


