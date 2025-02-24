Return-Path: <kvm+bounces-39034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A815FA42AC9
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 19:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A45683AE499
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 18:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1A9F265CA3;
	Mon, 24 Feb 2025 18:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lku229S6"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692611CF5CE
	for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 18:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420800; cv=none; b=VksllZnwMXxY342+KN1O8ZTEwZJPWI309fnikO41bswBQXGPBWwQ7xkAB8lyP/k1ge35/9eGa6dFVgAh1Ue6x1x8cnNeWENmW3RdC/VYktNMegc9K9yCjmuEc55UC+dvyqy3sCf2U7kumVZpqKVtb8XvDQwM/Kw0ShAxafRVos4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420800; c=relaxed/simple;
	bh=T0yxwknSVU5uENDcbW43caMJ4+U6uq2N81wvAf8hlco=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=hY5FOE6x9zHGJWUTkfakqRhtgcz9cLUF9Qs1khUE5LQbgnpa3sv1+1V7qgiLFe1NfSF6m3pLqSpaVB3noT9rf+OcR5GTndU9VulY+GxpRdMyOI9gV0/m+pbYHYVM2BAhlwVxiLYq2ufwsw5jchXXK7S4qikH4kgsR3A9SVfF0Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lku229S6; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2fc518f0564so10094449a91.2
        for <kvm@vger.kernel.org>; Mon, 24 Feb 2025 10:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740420798; x=1741025598; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q48RLw4bm9cUcGky6wV1VYogbhiSPeuXgdhYJSz1ucQ=;
        b=lku229S66puTZs3OV/N+24GDj4M3OxBJqTgoA8B3kwBTB9tzMEOEzoWeaubvZs7qvJ
         QJAKADe/QLth7+F0JzJUYeTtgTxcxz3htPJm0O4gIASQqzLyphNjaEEjuDURIGhVKb5L
         S2uaaYn9K/KyrPsGPFNoRKGwVkLMI28dRrZFvdVUG1w+fyDI0KRMtQ9lHjXpdl77TZdb
         95uHwxcbFgp+nzeIjOBi5b0JNitbtkXBTWZAU8lAUcjAV9ozwAcM26vzORsHNVb7RtKe
         6Odd2BjObhGy4c+ndnkjC6sWDWiW6ORHOQjQWs3KZ4yppCc5x38ryDYVUkhXHKRXPywk
         MAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740420798; x=1741025598;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q48RLw4bm9cUcGky6wV1VYogbhiSPeuXgdhYJSz1ucQ=;
        b=NcoFUyE7UOXS3XkDTN+XD5Qm3OQyW7dZGI6L37OKrYh90xhRllxp6zAHZPAZWZL1vc
         hethlY32q3Do84+FL6I0YitUWcUAOBX4DGfB/9PA1DFwumv5VnUMx+XNpR0zAx09FLVP
         BeWSau5MenDSvF79JxHhS/W0wtb6DgqSGV+ob94UOUzSwYHbkrjSC7OdL4mOkfMnKCXQ
         EB3SBEW5xw8+z3/4yMJETIrfakyPTHHwZjO7hPpyrQeGBk9yf2mppgTneVRfCwdi2amv
         asBWS9DyjRQrEkJ5B5XmZtEU9Wd3wIWg2Do+VuH0ESX0G7KWAsSvdSunMHsoTQrvbUSs
         736g==
X-Gm-Message-State: AOJu0YxEgqiA/EIWp9d7S4fFXVJ3TzY0NW/tVTuo8h1n9R1EBm3stzaN
	nA4wYgmRtRfk5EHsdyrVk2WjZDalr7XO6eDaJw6OLRszwPmQ+rEZttSMOCThJhh+CH54FPOswXH
	MFQ==
X-Google-Smtp-Source: AGHT+IHikyx+bh4eiwggQeIRVAhyeR3x37vajCmvBnv+kb8EigZJ2gO/NbJJ88+J+LtvKkJQDW/SAiauxcs=
X-Received: from pjbsv12.prod.google.com ([2002:a17:90b:538c:b0:2e9:38ea:ca0f])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5688:b0:2ee:ab29:1a57
 with SMTP id 98e67ed59e1d1-2fe68ac9600mr195068a91.2.1740420798718; Mon, 24
 Feb 2025 10:13:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Mon, 24 Feb 2025 10:13:12 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.658.g4767266eb4-goog
Message-ID: <20250224181315.2376869-1-seanjc@google.com>
Subject: [PATCH 0/3] KVM: SVM: Zero DEBUGCTL before VMRUN if necessary
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, rangemachine@gmail.com, 
	whanos@sergal.fun, Ravi Bangoria <ravi.bangoria@amd.com>, 
	Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"

PeterZ,

Can you confirm that the last patch (snapshot and restore DEBUGCTL with
IRQs disabled) is actually necessary?  I'm 99% certain it is, but I'm
holding out hope that it somehow isn't, because I don't love the idea of
adding a RDMSR to every VM-Entry.

Assuming DEBUGCTL can indeed get modified in IRQ context, it probably
makes sense to add a per-CPU cache to eliminate the RDMSR.  Unfortunately,
there are quite a few open-coded WRMSRs, so it's not a trivial change.

On to the main event...

Fix a long-lurking bug in SVM where KVM runs the guest with the host's
DEBUGCTL if LBR virtualization is disabled.  AMD CPUs rather stupidly
context switch DEBUGCTL if and only if LBR virtualization is enabled (not
just supported, but fully enabled).

The bug has gone unnoticed because until recently, the only bits that
KVM would leave set were things like BTF, which are guest visible but
won't cause functional problems unless guest software is being especially
particular about #DBs.

The bug was exposed by the addition of BusLockTrap ("Detect" in the kernel),
as the resulting #DBs due to split-lock accesses in guest userspace (lol
Steam) get reflected into the guest by KVM.

Sean Christopherson (3):
  KVM: x86: Snapshot the host's DEBUGCTL in common x86
  KVM: SVM: Manually zero/restore DEBUGCTL if LBR virtualization is
    disabled
  KVM: x86: Snapshot the host's DEBUGCTL after disabling IRQs

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/svm.c          | 14 ++++++++++++++
 arch/x86/kvm/vmx/vmx.c          |  8 ++------
 arch/x86/kvm/vmx/vmx.h          |  2 --
 arch/x86/kvm/x86.c              |  2 ++
 5 files changed, 19 insertions(+), 8 deletions(-)


base-commit: fed48e2967f402f561d80075a20c5c9e16866e53
-- 
2.48.1.658.g4767266eb4-goog


