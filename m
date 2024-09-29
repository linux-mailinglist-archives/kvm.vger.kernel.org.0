Return-Path: <kvm+bounces-27656-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F4659896A1
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 19:36:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D359D1F224D6
	for <lists+kvm@lfdr.de>; Sun, 29 Sep 2024 17:36:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0177B3F8F7;
	Sun, 29 Sep 2024 17:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="A0rdhj0C"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71713D9E
	for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 17:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727631382; cv=none; b=TVvCBi2UXw9V9F9q4astG1fS5IyeUtj1q4RIdGf721DaimnajtJ43osxtZbgRgGl934trHY7d2OmqFtHmgmmoAIw4phU1PQ1Rsb3qQijmG++G5FT5eown6BWAP2Qpczgs1Fepg2vbRVTbxIfpXS6avlKd/hK0PatKEp6nlZBa/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727631382; c=relaxed/simple;
	bh=pJ2+5xf3JPLPFG7ajx6iu9zP2xRrrmOhbM89yxGePGE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gwYHiNx4jl22O5bAcnKCMfV0Dx/ziB+79EG7gEd6zfYGe+1J9j72dvGlYWKYcyn6XCNGfbewL6PcGmvtsuFx3BKLq/B8Ua3bZe++BkX885XheAUTCX4kw4ubnKI6F42bZxRkjOOA2cr7Dud1ZLegFT89lxSB/ryTpzkrxBCIh2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=A0rdhj0C; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a8a7596b7dfso431656166b.0
        for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 10:36:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727631378; x=1728236178; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vi4TCfM4jiQzxcMHDXObhlmlU/euEJoDfcgbZrM6Np0=;
        b=A0rdhj0C8G6pPe7ctTmtvRGLajRIkcIA5DYum+5yTE3V2u864UoRurrFy/y2/Q4mQC
         fcnEPtLa4ZzgSQRQmkqYmfY2Im3s5Tn5BpW1y2JKtNy16o3dh8c4CPeqrpmr5/IpWJ6a
         cGmIvmhSkZrJ39CYePwociZbJXFtGAOYlvkls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727631378; x=1728236178;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vi4TCfM4jiQzxcMHDXObhlmlU/euEJoDfcgbZrM6Np0=;
        b=gr2Op6NHu6DX18R184/uUbNjL4pzNXYtpwGTfWWINL8bLM0I073yL0gjVfBzYC/fGc
         WYy7qh0BghkvA99RXOL+NXEYxDLpW0X26dNhDQ9iNmLztRMr3HnVwkytPU3CB30xzCT7
         BjVWFVqr8NC1NsiK1MQ2/YmxP8HEhLjwpo4shap5VlQpyrkxEAojQRKAROxWzvam5gWp
         rpF/5AjBQTHnPEcbUu8FWfzOXHINNsYu1U5pWOdvqi8XKyLY+bgQyyhPKITQqQJGKD9Z
         tzu9cX4CJhqrtJmfUeRI9loAQDB3Qg/Tdk6GOJm73r1IZFkAj3Tzi0RoKqwKrTmQH7tl
         hHdQ==
X-Forwarded-Encrypted: i=1; AJvYcCV4OGEy5KoKA4MnC/nq8wS6qWrvxmDOlwzDpLQjVZgeCNJlni6sVGc9N2KrFdUzrLFmWuA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyB3seLOaejX7IuI/PBcKJuDJ915ObFKusJeqHuZCkOLV4Yn+wW
	gzzKQmGAPSO1anOU6UMjI5SxA/30kmWWcQfkrlBtjlC7lNGowRDoYZ6EtLD6qv7wXCtdkDjzn9e
	GZ1c=
X-Google-Smtp-Source: AGHT+IFZZROOMpj2sJueJJjoFJQgxCWrxOZF9nPQm5TKQATeu2uBcmCTYfqwr3ZQyG0bDGCKYetOpQ==
X-Received: by 2002:a17:907:31c2:b0:a90:a9bd:1c36 with SMTP id a640c23a62f3a-a93c30f492dmr1023764066b.18.1727631377752;
        Sun, 29 Sep 2024 10:36:17 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93cd7a3609sm342579366b.211.2024.09.29.10.36.16
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Sep 2024 10:36:16 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a8d6ac24a3bso668692066b.1
        for <kvm@vger.kernel.org>; Sun, 29 Sep 2024 10:36:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVwETcucrMFNPGhOq4+rLHFNpdxqZ6cLSPET476VysNz8c0fMbbgvdMFXWJ+yfvXpbKHTw=@vger.kernel.org
X-Received: by 2002:a17:907:7f26:b0:a75:7a8:d70c with SMTP id
 a640c23a62f3a-a93c3098a87mr1232049066b.4.1727631376200; Sun, 29 Sep 2024
 10:36:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240928153302.92406-1-pbonzini@redhat.com>
In-Reply-To: <20240928153302.92406-1-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 29 Sep 2024 10:35:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiQ2m+zkBUhb1m=m6S-H1syAgWmCHzit9=5y7XsriKFvw@mail.gmail.com>
Message-ID: <CAHk-=wiQ2m+zkBUhb1m=m6S-H1syAgWmCHzit9=5y7XsriKFvw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/x86 changes for Linux 6.12
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>, 
	Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>, 
	Farrah Chen <farrah.chen@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: multipart/mixed; boundary="0000000000007b816506234586fa"

--0000000000007b816506234586fa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 28 Sept 2024 at 08:33, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Apologize for the late pull request; all the traveling made things a
> bit messy.  Also, we have a known regression here on ancient processors
> and will fix it next week.

.. actually, much worse than that, you have a build error.

  arch/x86/kvm/x86.c: In function =E2=80=98kvm_arch_enable_virtualization=
=E2=80=99:
  arch/x86/kvm/x86.c:12517:9: error: implicit declaration of function
=E2=80=98cpu_emergency_register_virt_callback=E2=80=99
[-Wimplicit-function-declaration]
  12517 |
cpu_emergency_register_virt_callback(kvm_x86_ops.emergency_disable_virtuali=
zation_cpu);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  arch/x86/kvm/x86.c: In function =E2=80=98kvm_arch_disable_virtualization=
=E2=80=99:
  arch/x86/kvm/x86.c:12522:9: error: implicit declaration of function
=E2=80=98cpu_emergency_unregister_virt_callback=E2=80=99
[-Wimplicit-function-declaration]
  12522 |
cpu_emergency_unregister_virt_callback(kvm_x86_ops.emergency_disable_virtua=
lization_cpu);
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

which I hadn't noticed before, because I did just allmodconfig builds.

But with a smaller config, the above error happens.

The culprit is commit 590b09b1d88e ("KVM: x86: Register "emergency
disable" callbacks when virt is enabled"), and the reason seems to be
this:

  #if IS_ENABLED(CONFIG_KVM_INTEL) || IS_ENABLED(CONFIG_KVM_AMD)
  void cpu_emergency_register_virt_callback(cpu_emergency_virt_cb *callback=
);
  ...

ie if you have a config with KVM enabled, but neither KVM_INTEL nor
KVM_AMD set, you don't get that callback thing.

The fix may be something like the attached.

                   Linus

--0000000000007b816506234586fa
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_m1nv3bmn0>
X-Attachment-Id: f_m1nv3bmn0

IGFyY2gveDg2L2luY2x1ZGUvYXNtL3JlYm9vdC5oIHwgMiArKwogMSBmaWxlIGNoYW5nZWQsIDIg
aW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3JlYm9vdC5o
IGIvYXJjaC94ODYvaW5jbHVkZS9hc20vcmVib290LmgKaW5kZXggZDBlZjJhNjc4ZDY2Li5jMDIx
ODNkM2NkZDcgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL3JlYm9vdC5oCisrKyBi
L2FyY2gveDg2L2luY2x1ZGUvYXNtL3JlYm9vdC5oCkBAIC0zMSw2ICszMSw4IEBAIHZvaWQgY3B1
X2VtZXJnZW5jeV9yZWdpc3Rlcl92aXJ0X2NhbGxiYWNrKGNwdV9lbWVyZ2VuY3lfdmlydF9jYiAq
Y2FsbGJhY2spOwogdm9pZCBjcHVfZW1lcmdlbmN5X3VucmVnaXN0ZXJfdmlydF9jYWxsYmFjayhj
cHVfZW1lcmdlbmN5X3ZpcnRfY2IgKmNhbGxiYWNrKTsKIHZvaWQgY3B1X2VtZXJnZW5jeV9kaXNh
YmxlX3ZpcnR1YWxpemF0aW9uKHZvaWQpOwogI2Vsc2UKK3N0YXRpYyBpbmxpbmUgdm9pZCBjcHVf
ZW1lcmdlbmN5X3JlZ2lzdGVyX3ZpcnRfY2FsbGJhY2soY3B1X2VtZXJnZW5jeV92aXJ0X2NiICpj
YWxsYmFjaykge30KK3N0YXRpYyBpbmxpbmUgdm9pZCBjcHVfZW1lcmdlbmN5X3VucmVnaXN0ZXJf
dmlydF9jYWxsYmFjayhjcHVfZW1lcmdlbmN5X3ZpcnRfY2IgKmNhbGxiYWNrKSB7fQogc3RhdGlj
IGlubGluZSB2b2lkIGNwdV9lbWVyZ2VuY3lfZGlzYWJsZV92aXJ0dWFsaXphdGlvbih2b2lkKSB7
fQogI2VuZGlmIC8qIENPTkZJR19LVk1fSU5URUwgfHwgQ09ORklHX0tWTV9BTUQgKi8KIAo=
--0000000000007b816506234586fa--

