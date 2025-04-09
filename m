Return-Path: <kvm+bounces-43032-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15668A832BC
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 22:46:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84A5846597F
	for <lists+kvm@lfdr.de>; Wed,  9 Apr 2025 20:45:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6867B21ADA4;
	Wed,  9 Apr 2025 20:41:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sTAO08+/"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A693621ABD7
	for <kvm@vger.kernel.org>; Wed,  9 Apr 2025 20:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744231304; cv=none; b=BNvpRUXZMmHa8MxSYw2xiLrHq+CMgJ5hwLsg8sfYsa4+vXt4ry28Do2ObM+bAoSfEF5Awdf4P/7WlaKqX897c7392hTC9BkROnFXO34bmqA2v9wqX4ji3GttxMkeyiJmKLiNLCrMLzmlA6UZGDV5gu/Hckby1Bl882peGix2QCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744231304; c=relaxed/simple;
	bh=3wiKPK3bBwkcZ2R2S9JuygT1liPdoEqLtKvDn4cR2SQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ceRAPuVMagsz8t2S4Ib5vhDbP0XXxU/d+LJqRxqlgKsHaR34IIPd+tf+m21UD3ej7YLSicrwHqBWwXhFJyalfcdMGGOuosMp+bS5ab9ps7sgJ9u1II4h/CLzmRAIQ1QTKjipW02z8kUXAUPE6r9oUDwP9Y9dthkEVgsYu9LeDoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sTAO08+/; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-736b2a25d9fso36915b3a.0
        for <kvm@vger.kernel.org>; Wed, 09 Apr 2025 13:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1744231302; x=1744836102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ieoIvphqiGbAKMBpBQheDMztn7Ma+D+YzJ22q+cnEVc=;
        b=sTAO08+/3WY6epr3PWK3Pzda8vG9F7oi97LW7o3rAeIIajIeLqfgbBhrJpYAPDfTea
         JUyTn6Rem73zK2eNc/uNAO32CCRGnWhfqfRv9c+WrAzkH392r6vYJom/bWn5Ue1Viles
         t3D/XCbpe9Wdyh1Mo7FYyXvpjnpHwckXP+YeDsfMiQBgvrCEaJcEeDAtvZoVnR7ddRQ1
         tf2uMfpa28qweyLc92rorTc234aZZek5GDV97G7ng9ap+D4hi+2pFUbrJpdZkbNlHDAo
         gbJmwd1IRZLoBrAmJrDlbtjISYcp0KBmPtmCnLjRYEbcadl8/UjJiA+DdPedD4GDYaGY
         DVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744231302; x=1744836102;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ieoIvphqiGbAKMBpBQheDMztn7Ma+D+YzJ22q+cnEVc=;
        b=NCQgNMRAImaHR465AzUEqFLuSkkFS1DtEZyLCvBHrLinTVsNC0TyvK6/qoIrp8YC/v
         15sZA8NXYhdfp1ArBcUi3GlaEXj3LOhaFw81zNvhGkG7Bx0cLXsIUjQ1j9xGD5SUdxAu
         bZPcQSyyhIL0KMRYiRzBrmBIr9cKLR7/v3ounVhaE6nx9FC/DNJ4Oipy+1fb4SzvzlnQ
         jbINBHDEwoR6lT0DvV4GaTcnIyExGCp7IagLVjzgQs4UZriuQbwyIvop3Zu9K0BCGWz7
         2q6u5SBVkuO88f92tjyRFNqGT1lwyttHOvaIsP4u9AvktGhY4vwnYHGW3rF3gY886hog
         NisA==
X-Forwarded-Encrypted: i=1; AJvYcCXhN6fihxPGR15jq1DHkJaU7VbQ3VZMHII1peg9phDYwGWgjCsD5iPKWD2wbdrQcVpJIQA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyUa6bdfwRFSklfyyvmDG7tLLDgHZc5jmw//qTCSaqRRVYKeem5
	qJ6eu2YS1bav8l0ULf1WoQVI+t3X2QlBv9wrDT9qI55499FUyZGnCzzjsmq2951wVSMvv54XpP6
	h5A==
X-Google-Smtp-Source: AGHT+IFydrkQXn90pkKPYhdpK0P18a0JZkMT6KtxrVusmlyKG0vy9rQQutHGFxIj8bezVw2sQfCI6eVl1us=
X-Received: from pfbkq7.prod.google.com ([2002:a05:6a00:4b07:b0:736:ab5f:21f4])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:728b:b0:1f5:6f61:a0ac
 with SMTP id adf61e73a8af0-2016946066amr716605637.5.1744231301902; Wed, 09
 Apr 2025 13:41:41 -0700 (PDT)
Date: Wed, 9 Apr 2025 13:41:40 -0700
In-Reply-To: <CALf2hKtf529apzVGL=F-k_G_Ou8ucCdo6CNhJwp=dM-oV1Lgsg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <CALf2hKtf529apzVGL=F-k_G_Ou8ucCdo6CNhJwp=dM-oV1Lgsg@mail.gmail.com>
Message-ID: <Z_bbhFD2FOblKjhF@google.com>
Subject: Re: [Confusing Bug] A Long-running Syzkaller Docker Crashes Host System
From: Sean Christopherson <seanjc@google.com>
To: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Cc: pbonzini@redhat.com, syzkaller <syzkaller@googlegroups.com>, kvm@vger.kernel.org, 
	tglx@linutronix.de
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 09, 2025, Zhiyu Zhang wrote:
> Dear Syzkaller Group and Linux Kernel Upstream,
>=20
> I am writing to report an intermittent issue that appears when running
> Syzkaller inside a Docker container with privileged KVM access. The
> host system becomes unresponsive after prolonged fuzzing, and I hope
> your insights can help identify the root cause.
>=20
> Environment Details:
> - Host Machine:
>     - OS: Ubuntu 20.04.6 LTS
>     - Kernel: x86_64 Linux 5.15.0-136-generic
>     - CPU: Intel Xeon Platinum 8268 @ 192=C3=973.9GHz
> - Docker Container:
>     - Base Image: Ubuntu 22.04 (qgrain/kernel-fuzz:v1)
>     - Syzkaller Version: commit 4121cf9 (20250217)
>     - Startup Command: docker run -itd -p 29400:22 -v
> /PATH/KERNELS:/root/kernels --name NAME --privileged=3Dtrue
> qgrain/kernel-fuzz:v1
>=20
> After the fuzzing instances had been running for an extended period,
> the host system became completely inaccessible (e.g., SSH connections
> failed). Through IPMI, I observed the following repeated log messages
> on the virtual terminal:

You'll likely need some way to get more information about the state of the =
host
kernel when things go sideways.  E.g. force a crash and get a kdump.  Eithe=
r that,
or hope you get lucky and capture an oops/panic.

> [244053.888249] kvm [3867]: vcpu2, guest pF: 0xffffffff813008ac
> vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop
> [244053.938264] kvm [3867]: vcpu3, guest pF: 0xffffffff813008ac
> vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop
> [244053.960191] kvm [3867]: vcpu0, guest pF: 0xffffffff813008ac
> vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop
> [244053.992411] kvm [3867]: vcpu1, guest pF: 0xffffffff813008ac
> vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop
> [244075.149293] kvm [3882]: vcpu3, guest pF: 0xffffffff81300744
> vmx_set_jsr: BTF ln_inA2_DEBUGTRLSR 0x2, nop

What is producing these messages?  It's not the upstream kernel.  If your s=
ystem
is generating gobs of logging, it's entirely possible the logging itself is
causing problems.

> ...
>=20
> Speculation on Possible Causes:
> - One possibility is that the long-term Syzkaller fuzzing workload has
> generated test cases that trigger an edge-case bug in the host KVM
> module. The repeated =E2=80=9Cguest pF=E2=80=9D errors could indicate tha=
t a specific
> sequence of guest instructions is not being handled correctly.
> - Alternatively, prolonged high-load conditions from continuous
> fuzzing might have exposed an unhandled kernel or hardware bug related
> to virtualization=E2=80=94potentially in the CPU=E2=80=99s VMX or within =
the KVM
> module itself.
>=20
> I apologize for the limited diagnostic information available at this
> time (find nothing relevant to KVM in system logs). The above
> speculation is preliminary, and I am unsure whether the root cause
> lies within the Syzkaller side or Kernel KVM side.
>=20
> Thank you for your attention to this matter. I look forward to any
> suggestions or questions you may have.
>=20
> Best regards,
> Zhiyu Zhang

