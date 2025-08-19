Return-Path: <kvm+bounces-55029-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id EC684B2CBF6
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 20:28:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EB9221BC3D8F
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 18:28:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C25830F54B;
	Tue, 19 Aug 2025 18:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SHrnLo88"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616F320B80B
	for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 18:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755628086; cv=none; b=AQUuXwHQqx+TnFQpYbEVpom4KGOGB+rtPBcv2ymx+u1g1RNfY0a2AqWHZ7DZGIBsOBZwMZNOlL+q1XLHJxxqli6+3BDWHXoKXE3n/JnCjXn+a9jemo/J9oJ8Z8Lq7HPbYJ/B+sTNrUZaj9ql6NYwee0wBVCs1C7serre+P+8nng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755628086; c=relaxed/simple;
	bh=PgbIaPz3chbrf2rMaMnMMpO/sOTuzu1KnFUJubvxgVo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fr0hFnFqlTAmtMR7mnfTgoRoTUDv4pHaQQoiIlyewR4gMwJhD1prKGptzpwuqXAdZw+5g4jd0XkIgUaxw8diG9yqPCf8SURClAW5051FMLSG7xY/Lz31BLuy+4G1YT1tqxBndCydA0pEY7kSNHkX0wTlTNyckPrtb6UIcLymW7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SHrnLo88; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-32326e72dfbso10641122a91.3
        for <kvm@vger.kernel.org>; Tue, 19 Aug 2025 11:28:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755628084; x=1756232884; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PfqdL5UrP89R0Ovxhe5JGCdcLW6B+H4qXxAxuLmRpQ8=;
        b=SHrnLo88mJzbNi7FbjD0AsI3Gonxo7Vfc17QIVGeNVrwnh8O9N6HtW524SNLJhJ8Xg
         z3aRo4lI6/4UvWnsLRvdcvOp0SmkiIUirzGhU+slEsZQbtwGfI6HJl7yX6ehoGRgUd/U
         /uTTwkibbP9QQZzDPvGuVhSbc/XyNKMOA3krREM0iC5Cl5UYMh+qD9AHqhfzYcq3EOGB
         0WSnJNx8iM591NmENsHzSJ0RA+TSiRN49ajanYacKzW3zxiNKSfJkFHg91qFiwGeIB1W
         4g1V9UEXPU3rOA5G24/gdp2yblybGAmDv8qbcCfleB4IenSKtEOhJMm3C04N9AlJwpWq
         5UKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755628084; x=1756232884;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PfqdL5UrP89R0Ovxhe5JGCdcLW6B+H4qXxAxuLmRpQ8=;
        b=J1skGjxDZNfce3hkR5gbYJ9N1f45fFIlXXUK4opCTyHmLOFHellsAdDHujJQPYeg3U
         1cA44uGKISrB0fcL1CGbSf2xfci0tPDQAMqC4ohRuyaTCkWpbDWST/NdOvG1PvIKA4Qo
         Aq4OoaO8nwONxqp5CKoeEcXF/I3nxRf0ETFMuZDo5ut6KCfudRSVkZd9raLsi2FX/2Cq
         3b79epFDe1BB2v+h274CjUFFRwdFmOIV4F2wxCXjmEAxIColnOUrwieInP2b/yYJZtNi
         ZuL91PRYDaHCOqucGtTykmu1wifrYYYFB0A4rQL0rjO3kItCMwa4vVW+wPZBNpYgATSp
         vyrQ==
X-Forwarded-Encrypted: i=1; AJvYcCWF/B66fP2Rsthe49jc/W4vKgEynlaOYJr9bwhbnDhlSLU2NJnQtLqX/ujZljVeV3Q1bPc=@vger.kernel.org
X-Gm-Message-State: AOJu0YwQH7cxzIPzOW+jjgixI27QLnRoJA5qwirMzMsbtjvMPNpfoOVR
	71Hd9xeeae06rqyyFzNSfdaAkBT7+pvf3rqbU5HZWalEh1SxKNUb/sxGQr5atlUA0UxKQmA6QFf
	IymBs8Q==
X-Google-Smtp-Source: AGHT+IHFhe0mFvV0NtHklDcweRV2yghd2x8kC+KF7UCj7IccRFPVI84TD4SYsReNhpHYN21O9GpATzxvW84=
X-Received: from pjd4.prod.google.com ([2002:a17:90b:54c4:b0:311:485b:d057])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2c87:b0:321:29c4:e7c5
 with SMTP id 98e67ed59e1d1-324e12e283dmr244619a91.7.1755628084633; Tue, 19
 Aug 2025 11:28:04 -0700 (PDT)
Date: Tue, 19 Aug 2025 11:28:03 -0700
In-Reply-To: <20250804090945.267199-3-nikunj@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250804090945.267199-1-nikunj@amd.com> <20250804090945.267199-3-nikunj@amd.com>
Message-ID: <aKTCMzVNwhlFNE0e@google.com>
Subject: Re: [PATCH v3 2/2] KVM: SEV: Enforce minimum GHCB version requirement
 for SEV-SNP guests
From: Sean Christopherson <seanjc@google.com>
To: Nikunj A Dadhania <nikunj@amd.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, thomas.lendacky@amd.com, 
	santosh.shukla@amd.com, Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Aug 04, 2025, Nikunj A Dadhania wrote:
> Require a minimum GHCB version of 2 when starting SEV-SNP guests through
> KVM_SEV_INIT2. When a VMM attempts to start an SEV-SNP guest with an
> incompatible GHCB version (less than 2), reject the request early rather
> than allowing the guest kernel to start with an incorrect protocol version
> and fail later with GHCB_SNP_UNSUPPORTED guest termination.
> 
> Hypervisor logs the guest termination with GHCB_SNP_UNSUPPORTED error code:

s/Hypervisor/KVM, though I don't see any point in saying that KVM is doing
the logging, that's self-evident from the kvm_amd prefix.  Instead, I think
what's important to is to say the guest _typically_ requests termination,
because AFAICT nothing guarantees the guest will fail in this exact way.

  Not enforcing the minimum version typically causes the guest to request
  termination with GHCB_SNP_UNSUPPORTED error code:

    kvm_amd: SEV-ES guest requested termination: 0x0:0x2

> kvm_amd: SEV-ES guest requested termination: 0x0:0x2
> 
> SNP guest fails with the below error message:

This is QEMU output, not guest output.  I don't see any reason to capture this.
The fact that QEMU apparently doesn't handle KVM_EXIT_SYSTEM_EVENT isn't interesting.

> KVM: unknown exit reason 24
> EAX=00000000 EBX=00000000 ECX=00000000 EDX=00a00f11
> ESI=00000000 EDI=00000000 EBP=00000000 ESP=00000000
> EIP=0000fff0 EFL=00000002 [-------] CPL=0 II=0 A20=1 SMM=0 HLT=0
> ES =0000 00000000 0000ffff 00009300
> CS =f000 ffff0000 0000ffff 00009b00
> SS =0000 00000000 0000ffff 00009300
> DS =0000 00000000 0000ffff 00009300
> FS =0000 00000000 0000ffff 00009300
> GS =0000 00000000 0000ffff 00009300
> LDT=0000 00000000 0000ffff 00008200
> TR =0000 00000000 0000ffff 00008b00
> GDT=     00000000 0000ffff
> IDT=     00000000 0000ffff
> CR0=60000010 CR2=00000000 CR3=00000000 CR4=00000000
> DR0=0000000000000000 DR1=0000000000000000 DR2=0000000000000000 DR3=0000000000000000
> DR6=00000000ffff0ff0 DR7=0000000000000400
> EFER=0000000000000000


No need for you to send a new version, I'm going to post a combined series for
this and Secure TSC.

