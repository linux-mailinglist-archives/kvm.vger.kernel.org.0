Return-Path: <kvm+bounces-13584-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E30E898C56
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 18:39:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7A1DE1C2527E
	for <lists+kvm@lfdr.de>; Thu,  4 Apr 2024 16:39:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA3DA129A7E;
	Thu,  4 Apr 2024 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DYho//ae"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FB351C6A0
	for <kvm@vger.kernel.org>; Thu,  4 Apr 2024 16:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712248685; cv=none; b=C+Mr3hXICetKO9KoiBBKKHReCQbJvISkeM5AKv4q3pmcsHTJhU4cc9AcsGg+4qt8GVSF5dHog+C+Zxpe8nRBYfOrGyVv4+QrKOMXSpwDNrH0yKoYVKgERgnQ5F61uWE6ozdQg7Yn/2obtpDggNLAWctPtruMrKoYvRPX0tM3nLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712248685; c=relaxed/simple;
	bh=ARHRqF2vMFHz0poKI5R/NwxZEEnfxngPCY70Gl8BRQM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uULUVhGOTzeBRxp9j0DJuIOun09VIz75AML3VXv+b65Vh8z5yH8hM7q6rZDCkPQe7Qm2YAlkUYnsrn9N3W03gpqvFtsce82t5E0UumjjCyfx2sqR9ufrnFcWQyLnUsRTMKM3aX22+N1pf29pvxbdjGmHMICX78yUXhe3TYP7IFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DYho//ae; arc=none smtp.client-ip=209.85.219.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f202.google.com with SMTP id 3f1490d57ef6-dce775fa8adso2116533276.1
        for <kvm@vger.kernel.org>; Thu, 04 Apr 2024 09:38:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712248682; x=1712853482; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VWZS7flKLl0sICuGu0YXGwS4yht3MSv7qVnyogrx7+E=;
        b=DYho//aeEs0NvsO0yasBDeGtjLoe2Nx5dA0Yis1T0Tl5FfGZib9dJTAfh4CEt8U5kq
         +GkJmzGdQTSncbu62sZqtX+xeHfPfJNDS+rlh3ZrOJ/j3M33hPBp0Jyqy2dSfqeQ9trU
         2X6cUyrBBjED+e0+Ed/z0yur2IjWRXZKK4eUXdDcIuilkMFgJKEv8hfCs+jaWMZTDmAq
         qqbCgcmMpRUMzHwKRTtdTuwlJfG9+VrS31yhgt5izbkEzG7DqQkdSzhiv+khUo0TQQnK
         3ev1cXBjd80p3PTxS2wd5kQ0G2HQNeDeFGlwdXwbSNamR2KG6sytmCpypSG6fd9Q1WC0
         rg9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712248682; x=1712853482;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=VWZS7flKLl0sICuGu0YXGwS4yht3MSv7qVnyogrx7+E=;
        b=TxfW+m7iS72SKKsUtBQmD/rG2ayPWYuI9MVpP/XLmh7+4KqI//uZFbCKipgCM2zO7u
         0ksF74RBjQcJVxrhz/r79QfMzcHlpNwPcwAtIXvWoIH4pF2MtcGRZTPOsahoqD650yB7
         lFfMi0yRvaIq5a4603Hc5gj9lYY/cy1++hCZHyWgV0SoqwRptLH12H5tjYHmzUsOCLD1
         H6EvesRx//V2U6EWoEr0rM7z6rtl5apXdsGUwAGoa0sjy2XNGyUBduNbnCuXMP02yhk6
         6g4b5LRB8ElfEigYtyT17VtoI0b5IJKaWwoR95OhNgyfjPIQD5qmFFf3G8MM0tNUGf0A
         TlzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXBKuBSZIEGk8bSQN4awx4o9GS0iVs8plYPYNC4q2UY+tGB8EUYwfL4bm3omJByc0wLT1IWDk1753bXJHmhziInvGdn
X-Gm-Message-State: AOJu0YzMz3GytzD4Xj1ejk/mLptt1ZqFPUg2frzYrivOxBy8jDB8Vj8W
	ou/jDcs74ejACXWNUsNpb/xn9M/PYufOrpANPY8UROBvijSr6KnlTS8aU5u1ncEcEdtpYMgKVde
	vjg==
X-Google-Smtp-Source: AGHT+IG5CJi0WgWPz9hS4ye66MIeTg71IJ/rjxj7nrkFR7AsZK+ppsIjPTs4qWcpDFmnbajciozpjbHu8xA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2d22:0:b0:dcb:bc80:8333 with SMTP id
 t34-20020a252d22000000b00dcbbc808333mr1870ybt.13.1712248682770; Thu, 04 Apr
 2024 09:38:02 -0700 (PDT)
Date: Thu, 4 Apr 2024 09:38:01 -0700
In-Reply-To: <6d24f7b1-a271-43de-ba94-847a3c9e0d8c@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240228024147.41573-1-seanjc@google.com> <20240228024147.41573-2-seanjc@google.com>
 <2441bd2a-a0b1-5184-bac8-28c94b151c93@amd.com> <6d24f7b1-a271-43de-ba94-847a3c9e0d8c@linux.intel.com>
Message-ID: <Zg7XaYwmFbZUljfi@google.com>
Subject: Re: [PATCH 01/16] KVM: x86/mmu: Exit to userspace with -EFAULT if
 private fault hits emulation
From: Sean Christopherson <seanjc@google.com>
To: Binbin Wu <binbin.wu@linux.intel.com>
Cc: Pankaj Gupta <pankaj.gupta@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>, 
	Isaku Yamahata <isaku.yamahata@intel.com>, Michael Roth <michael.roth@amd.com>, 
	Yu Zhang <yu.c.zhang@linux.intel.com>, Chao Peng <chao.p.peng@linux.intel.com>, 
	Fuad Tabba <tabba@google.com>, David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 12, 2024, Binbin Wu wrote:
>=20
> On 3/7/2024 8:52 PM, Gupta, Pankaj wrote:
> > > Exit to userspace with -EFAULT / KVM_EXIT_MEMORY_FAULT if a private f=
ault
> > > triggers emulation of any kind, as KVM doesn't currently support
> > > emulating access to guest private memory.=C2=A0 Practically speaking,=
 private
> > > faults and emulation are already mutually exclusive, but there are ed=
ge
> > > cases upon edge cases where KVM can return RET_PF_EMULATE, and adding=
 one
> > > last check
> >=20
> > edge cases upon edge cases?
> >=20
> > Just curious about the details of the edge cases scenarios?
>=20
> Same question out of curiosity.

Accesses that hit the APIC-access page and gfns that are write-tracked, are=
 the
two most likely candidates.  Even plain old emulated MMIO falls into this b=
ucket,
e.g. if KVM botched things and generated a RSVD fault on a private mapping.=
  I'll
reword that line to

  faults and emulation are already mutually exclusive, but there are many
  flows that can result in KVM returning RET_PF_EMULATE, and adding one las=
t
  check to harden against weird, unexpected combinations and/or KVM bugs is
  inexpensive.

to make it sound less dramatic/hand-wavy.

