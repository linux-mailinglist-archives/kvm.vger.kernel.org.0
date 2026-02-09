Return-Path: <kvm+bounces-70631-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oIktAxIgimnLHQAAu9opvQ
	(envelope-from <kvm+bounces-70631-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:57:38 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 19D9E1134CE
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:57:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9745F3006932
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:57:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15ED038A71A;
	Mon,  9 Feb 2026 17:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C3rTuoS9";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="tsioLPbG"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C59438A718
	for <kvm@vger.kernel.org>; Mon,  9 Feb 2026 17:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.133.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770659831; cv=pass; b=pp5uEeGQ6mcEWONHrQ5bNzykWYYmM2wfWo3860DioX0gbHZVhU5HEywqzw0PE2uVZWQGFxV8xrX4s4iOYru/I88cQIsTIrOES3u8QAqzm065LaWJQoKrgCAOCphRUg87hX/o90ncRwgdeenPr73kh9zb+jCInt8Xg5df6+iKcrE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770659831; c=relaxed/simple;
	bh=iyf5LW7Q2q2SZrfrG6VzUnV6etNUwfmVVCw1SJ24uns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dqD/w+rqPTOcYDDeS4ZoVlkJRacuGzYTdbmSCM/R8OID5aK4DYHpXnz2eSKdy0AJMdhcb8ep1tDX0r8V02xRQ+c/jEo9IuyTFLGCCvSgrDHh+KWMNqthCTd04fwAMWICvo7SFdv8Q729UphUErZbHKLwqWT0YrY90mFCoZPbn0I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C3rTuoS9; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=tsioLPbG; arc=pass smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770659830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j3Tnz2ob5sHCn1DUQ27zBsLiCopUHY52MduCqB5z46M=;
	b=C3rTuoS9kz/GOoIFBtBCx36V0Pn2dJWoDtiuMfb1DmOI2OslFfPAx4y4wdKmHIZH6Kpo1U
	9pmp9QGxVD3WZt7B9HddUkaxM5izjeFRC0p5CR2UIFX0vKuaO44fvdaGXRAaDJxrmBMTYd
	Pujp9qdNhu+6PRmoCbFj8O+grkek20g=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-510-mSUe759QNNGFUjeSHa_dWA-1; Mon, 09 Feb 2026 12:57:08 -0500
X-MC-Unique: mSUe759QNNGFUjeSHa_dWA-1
X-Mimecast-MFC-AGG-ID: mSUe759QNNGFUjeSHa_dWA_1770659828
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-435991d4a3aso2928199f8f.1
        for <kvm@vger.kernel.org>; Mon, 09 Feb 2026 09:57:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770659827; cv=none;
        d=google.com; s=arc-20240605;
        b=F9jfYuEEiYuJkD3h5XKFhWuR0urzt6XfG7q79ws9OUL0A58wW9rTldefHCyHxS5uNA
         pk9VfW7Zs8hNvb90LdKrvff7zGMerMQu8psNT7ghrfb7Qg/MibnoR+zRrsMg2EHB8/i3
         epVEkBTU4FWddPivrULGWqZnaIw0rxxrvRbKi/6LE+a8NQ9eiu067FEvCf9KrLGu1s7q
         xsRcjtKrQma7eTdnzYryhLPTju43qsrnqon/CSsLrNuvLUxnFhECa3SC/8pj/mWQcVcm
         qSFTGMgzuzIvL/eUaIc2rUiorwAnw4SWRmffS21xoLq4INL6ASI18N/ncuiXxVtPh7fE
         eW8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j3Tnz2ob5sHCn1DUQ27zBsLiCopUHY52MduCqB5z46M=;
        fh=qaYm4b6GKYlZ0T3gtLZ7fjEfCEC8jMv5XzYe6fOhw1Y=;
        b=QZiSVr4VyYhOYDcEiIMZerXy7zZjCkPRXlSkCUnfuUcdcVEnor8eglmFH5cNjRtNIV
         P5C12WOmlX31QvRgB7HPCkzG9KmSrSKPyrUZqTdTSRVH0YozfVqA5ZGS5Ism4e+UXSrC
         2P4kEkOUL26ZXvdLz4c2qF7qUnHkOOHHO7WMhbGbPsV48u+kFU+YzbZIlFoGgZJfAyOX
         VmADbWSt9P2xXcww4MG8900/P0iicz0RX3LouIIZszfa2xsNfNuO36ZkNgx2ZMFYjFDQ
         rrIQ7FDmmK2PckrSnozOuXT8o2flgVIHSNDRhUsLtNeFl63NrHAmXzxC6iHUSFOqYM99
         cq8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1770659827; x=1771264627; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j3Tnz2ob5sHCn1DUQ27zBsLiCopUHY52MduCqB5z46M=;
        b=tsioLPbGYcNtvAiycioM1FY7HA1RYkdeA17p40+LxiMJolkpG+/bdSpKvfphv7K04i
         V2owFzin2CHwh1YGVxf3YYrtHUPeS9dEF/zy9vM6L882NA2Opi+x8OYLjrLlADdMkBXo
         xI/+2c+7Ed1JDXv+Zh56+1+pk93fZensvFjpU8x6KOlzk13Juh1bQM1UX6f/SnUtF2aY
         RiDe36beQ8Sc1bLKP2ziWZ7DfsRgTmOA4DozkZVzAsogC70zmBsIgae5nJ+a1tukg8tu
         6ss+9VqkA7ofMCQ1527myagX9JHmg3vIo1vTOEv8oyFYVR//QNMn6sH/89YJRJSsIMeB
         jC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770659827; x=1771264627;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j3Tnz2ob5sHCn1DUQ27zBsLiCopUHY52MduCqB5z46M=;
        b=gWNlqNGXtXA+3dXzHxqgFKFaLuWRmpzgJU33SBld5lr9Jxt0kcD1orqh1dud0j/IQz
         76OUXL0Ngl9Kq/7oS6ZcLTq1bcV+UuhRrMXGoPJfhEdkyMS8BiFSo7ZcpWawbEdQPOdj
         UNep499Vl/0FkBtnPcPovxpT2AfgzzFqVQYdzVJ2ah3cCdodwzmtAQ3z/DEoX+n8aqvn
         PSfTqzrQDgRKDt/EJYm/A7GU8QOhOt9bRmqraYIV7FHvm/HKDB54mZ+0fbuIFU2OrN/u
         XZery2STuQHgauunCb8BVqt2M4rOBhiqwK7JlxAbfCd5dLs+ezDwnERemvC7SfGv28oM
         Vvvg==
X-Gm-Message-State: AOJu0YwDnQAMN9mISgWimp5j4e8vCrjX1n+LUAbVrnYWc4So0uZ+pq0I
	NaeoPQ58eyjn4yK0AvfSQiouhbS3qTLBorXYU5yZqvyLiJfmqnfyEyRLyVfeeLhvxg5KziGjAS9
	DQYSrL6EgwuL3rNSJMUL01RjIc1x5G5A1beva55I0QQgQLo9AiJbkmyb72GFWvMcyHVqGOIUMjJ
	j2kGjxpase2Mphojxdwhr5W+w29J9C
X-Gm-Gg: AZuq6aLmZ3wrMsAV7BfODhos7wMJV0fLE64ENjL59pal4cCW7dE8oBDopmklChm7cJc
	clplwHBi02bNtGJDb6yG6FBC4un3pCagmfBHHo4WxW0kd+gOxJu+z3XGc6xB9PeiBL0cXiH2wZt
	v2/4pfDAhqcSb8IQrEfsUQDMqOPEpBpRK5dQh51YhJftOqvqLhcY6eYyADzSSyE5zgxop0lvVhy
	BN8xMGLcR8ti2Q2C83kSV02Rg1wBXR2NXSjDtc7ZBVgZCSRkUwJs4eNFTrgqUKZuAsw3w==
X-Received: by 2002:a5d:5f54:0:b0:435:9ce0:f93c with SMTP id ffacd0b85a97d-4362969509amr18892133f8f.62.1770659827512;
        Mon, 09 Feb 2026 09:57:07 -0800 (PST)
X-Received: by 2002:a5d:5f54:0:b0:435:9ce0:f93c with SMTP id
 ffacd0b85a97d-4362969509amr18892099f8f.62.1770659827040; Mon, 09 Feb 2026
 09:57:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260207041011.913471-1-seanjc@google.com> <20260207041011.913471-5-seanjc@google.com>
In-Reply-To: <20260207041011.913471-5-seanjc@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 9 Feb 2026 18:56:55 +0100
X-Gm-Features: AZwV_Qjz0Pqw1xueGCX-m7gFxI4JunDDvBMSnNdsK0oHlKuKr529ZXVqkSUL8WM
Message-ID: <CABgObfatae4rtioViKGueFG9=Qm=qEmvXQp=8LWhZnUMML7_9w@mail.gmail.com>
Subject: Re: [GIT PULL] KVM: x86: Misc changes for 6.20
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719,redhat.com:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	FROM_HAS_DN(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[pbonzini@redhat.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-70631-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	PRECEDENCE_BULK(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+]
X-Rspamd-Queue-Id: 19D9E1134CE
X-Rspamd-Action: no action

On Sat, Feb 7, 2026 at 5:10=E2=80=AFAM Sean Christopherson <seanjc@google.c=
om> wrote:
>  - Add WARNs to guard against modifying KVM's CPU caps outside of the int=
ended
>    setup flow, as nested VMX in particular is sensitive to unexpected cha=
nges
>    in KVM's golden configuration.

Possible follow-up: does it make sense to sync kvm_caps.supported_xss
by calling kvm_setup_xss_caps() from kvm_finalize_cpu_caps()?

In the meanwhile I've pulled this of course---thanks!

Paolo

>  - Add a quirk to allow userspace to opt-in to actually suppress EOI broa=
dcasts
>    when the suppression feature is enabled by the guest (currently limite=
d to
>    split IRQCHIP, i.e. userspace I/O APIC).  Sadly, simply fixing KVM to =
honor
>    Suppress EOI Broadcasts isn't an option as some userspaces have come t=
o rely
>    on KVM's buggy behavior (KVM advertises Supress EOI Broadcast irrespec=
tive
>    of whether or not userspace I/O APIC supports Directed EOIs).
>
>  - Minor cleanups.
>
> ----------------------------------------------------------------
> Jun Miao (1):
>       KVM: x86: align the code with kvm_x86_call()
>
> Khushit Shah (1):
>       KVM: x86: Add x2APIC "features" to control EOI broadcast suppressio=
n
>
> Sean Christopherson (6):
>       KVM: x86: Disallow setting CPUID and/or feature MSRs if L2 is activ=
e
>       KVM: x86: Return "unsupported" instead of "invalid" on access to un=
supported PV MSR
>       KVM: x86: Enforce use of EXPORT_SYMBOL_FOR_KVM_INTERNAL
>       KVM: x86: Ignore -EBUSY when checking nested events from vcpu_block=
()
>       KVM: x86: Drop WARN on INIT/SIPI being blocked when vCPU is in Wait=
-For-SIPI
>       KVM: x86: Harden against unexpected adjustments to kvm_cpu_caps
>
> Vasiliy Kovalev (1):
>       KVM: x86: Add SRCU protection for reading PDPTRs in __get_sregs2()
>
> Xiaoyao Li (1):
>       KVM: x86: Don't read guest CR3 when doing async pf while the MMU is=
 direct
>
> Zhao Liu (4):
>       KVM: x86: Advertise MOVRS CPUID to userspace
>       KVM: x86: Advertise AMX CPUIDs in subleaf 0x1E.0x1 to userspace
>       KVM: x86: Advertise AVX10.2 CPUID to userspace
>       KVM: x86: Advertise AVX10_VNNI_INT CPUID to userspace
>
>  Documentation/virt/kvm/api.rst     | 28 ++++++++++++-
>  arch/x86/include/asm/cpufeatures.h |  1 +
>  arch/x86/include/asm/kvm_host.h    |  9 +++++
>  arch/x86/include/uapi/asm/kvm.h    |  6 ++-
>  arch/x86/kvm/Makefile              | 49 +++++++++++++++++++++++
>  arch/x86/kvm/cpuid.c               | 75 +++++++++++++++++++++++++++++---=
---
>  arch/x86/kvm/cpuid.h               | 12 +++++-
>  arch/x86/kvm/ioapic.c              |  2 +-
>  arch/x86/kvm/lapic.c               | 77 +++++++++++++++++++++++++++++++-=
----
>  arch/x86/kvm/lapic.h               |  2 +
>  arch/x86/kvm/mmu/mmu.c             | 11 +++---
>  arch/x86/kvm/pmu.c                 |  2 +-
>  arch/x86/kvm/reverse_cpuid.h       | 19 +++++++++
>  arch/x86/kvm/svm/svm.c             |  4 +-
>  arch/x86/kvm/vmx/vmx.c             |  4 +-
>  arch/x86/kvm/x86.c                 | 81 +++++++++++++++++++++++---------=
------
>  arch/x86/kvm/x86.h                 | 15 ++++++-
>  17 files changed, 328 insertions(+), 69 deletions(-)
>


