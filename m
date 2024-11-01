Return-Path: <kvm+bounces-30312-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1CCC9B93AF
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 15:48:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 722F528341B
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 14:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33F0C1AA7AB;
	Fri,  1 Nov 2024 14:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cIX6fuKv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7340B1A265D
	for <kvm@vger.kernel.org>; Fri,  1 Nov 2024 14:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730472484; cv=none; b=t1DErzjcC2k+QVCKvdx+5Tn2DTQHEyIKjddb5qArl/zefzrPVGb/0pVDnVq8wEvQ9E42h439VBOx4ruqIrgL0LIGPED3XWU8nd2Efx49RLNx056kn5LnT5xuhq9wkMmBiw3uGPomSA/IeUBzzg+A7F9KjwkCLStDdBSXkUCMOH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730472484; c=relaxed/simple;
	bh=/Lo0SSKZxUY4iHjD0LeZv0mV6fASOYVUcG7mLz+tc54=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Z6N1WcCyJT/+ncXGB39ltPj6Rztas/tK91ymaW+oMWLh8Z7D9TKc6dumDfGVvnTs1qJga6zPjl/X7VWZleHT0Jy8/TtIE1QVoSP4pVbPG77ZfziQSaGROl/+og+EKBb8rm6zfFPzwHEcWajQqUIiKRzFvcL/aMB/er0PRIhscjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cIX6fuKv; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7eda7c4f014so2025000a12.3
        for <kvm@vger.kernel.org>; Fri, 01 Nov 2024 07:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730472482; x=1731077282; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/DE0DbUg8M7Q/DJxS90r+0tog95n4HSr4HfODo/BC0=;
        b=cIX6fuKv+3yuHboiGIHTTkhC7T3EUaXfQVDxPB+oAiRohNO+puS96HIJ14w+gM4QVJ
         Qe85l8fGO/H8SSUP0i3EDU6ZHX0GxK42FQ9R4hj23EmYigpyCJrE5Z2c6zeywsSK2YaL
         mq4nzc9fXVEKHJrcdElI07AhpD/KXsZ0QF1KqcCnunuLUmdfSrBnx1ovgf93KqRbA3IO
         K6rM9onYyCiXDl2XYaaJygmes06VX3wUS7o7IkOl8sZlISR/PE4XUU4ryLht+AVW5LCU
         z4K00RjybpXCz1hqUwoVDh/cfGGNGR+V+p+X3DwgSDvnhGwlCOy8CKIokuLSMOnixqEM
         5xlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730472482; x=1731077282;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=G/DE0DbUg8M7Q/DJxS90r+0tog95n4HSr4HfODo/BC0=;
        b=wYJLBT4DPk2V8KH4uoWmItPU6KSFjficpdd3tp9X/DEf1HwSobW7zbrlJQeziZ0lgA
         JMud6iXIAOYQA/zyFoJFQbdaTSLab/MqwInY+lMye7cttCQaydwnWzI+h2j/syqmqNdi
         i8FWw98nasxnc6sxxOQbKFxBrSkgDzXtwcru9mqX/i16fnkYwIhPHwwMXrPMqJc5LBrQ
         lsfQN3P4ZcvJUpLXrcYF1Z+MsCVbQtplTR2fDeOyrOTX6xImObFROEVorlmuFQxK+SEc
         ijhzX15zJXeJbKT4sWb0D5zIn7SYiaqwxiaLtfAicWtVk7INVCUBt3JSzt8n8G3+ACFB
         dWsw==
X-Forwarded-Encrypted: i=1; AJvYcCXxpkwv7UKjPqaiusnOyZqXrIyoPHEfdeAsM4VCXb7+eapMFmygseHgO6Is0zaDAWSp0rE=@vger.kernel.org
X-Gm-Message-State: AOJu0YykmHA5twQtOKSDToer3OtAUnOXTEcgCV0LNa3qhARMsuA48Vd0
	piQrGJv9Q90I3pxHrXcGVNgb7L3sH/mpLnI4zGCWVqbr5ZHieJw/fQ2qNArEOAtwO216am964yM
	Yog==
X-Google-Smtp-Source: AGHT+IHIf47dwb0nbkXT8QGaJrWq+fHjP6RSYp5sBCxZxmiVg/IHgboRnjvSBKMyLIM+q34Z1vnYxW9f4KA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:fa55:0:b0:7ea:83fc:1f0c with SMTP id
 41be03b00d2f7-7edd7c3149dmr31512a12.5.1730472481723; Fri, 01 Nov 2024
 07:48:01 -0700 (PDT)
Date: Fri, 1 Nov 2024 07:48:00 -0700
In-Reply-To: <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241009154953.1073471-1-seanjc@google.com> <20241009154953.1073471-4-seanjc@google.com>
 <39ea24d8-9dae-447a-ae37-e65878c3806f@sirena.org.uk>
Message-ID: <ZyTpwwm0s89iU9Pk@google.com>
Subject: Re: [PATCH v3 03/14] KVM: selftests: Return a value from
 vcpu_get_reg() instead of using an out-param
From: Sean Christopherson <seanjc@google.com>
To: Mark Brown <broonie@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Anup Patel <anup@brainfault.org>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Paolo Bonzini <pbonzini@redhat.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Janosch Frank <frankja@linux.ibm.com>, Claudio Imbrenda <imbrenda@linux.ibm.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Andrew Jones <ajones@ventanamicro.com>, James Houghton <jthoughton@google.com>, 
	David Woodhouse <dwmw@amazon.co.uk>, linux-next@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 01, 2024, Mark Brown wrote:
> On Wed, Oct 09, 2024 at 08:49:42AM -0700, Sean Christopherson wrote:
> > Return a uint64_t from vcpu_get_reg() instead of having the caller prov=
ide
> > a pointer to storage, as none of the vcpu_get_reg() usage in KVM selfte=
sts
> > accesses a register larger than 64 bits, and vcpu_set_reg() only accept=
s a
> > 64-bit value.  If a use case comes along that needs to get a register t=
hat
> > is larger than 64 bits, then a utility can be added to assert success a=
nd
> > take a void pointer, but until then, forcing an out param yields ugly c=
ode
> > and prevents feeding the output of vcpu_get_reg() into vcpu_set_reg().
>=20
> This commit, which is in today's -next as 5c6c7b71a45c9c, breaks the
> build on arm64:
>=20
> aarch64/psci_test.c: In function =E2=80=98host_test_system_off2=E2=80=99:
> aarch64/psci_test.c:247:9: error: too many arguments to function =E2=80=
=98vcpu_get_reg=E2=80=99
>   247 |         vcpu_get_reg(target, KVM_REG_ARM_PSCI_VERSION, &psci_vers=
ion);
>       |         ^~~~~~~~~~~~
> In file included from aarch64/psci_test.c:18:
> include/kvm_util.h:705:24: note: declared here
>   705 | static inline uint64_t vcpu_get_reg(struct kvm_vcpu *vcpu, uint64=
_t id)
>       |                        ^~~~~~~~~~~~
> At top level:
> cc1: note: unrecognized command-line option =E2=80=98-Wno-gnu-variable-si=
zed-type-not-at
> -end=E2=80=99 may have been intended to silence earlier diagnostics
>=20
> since the updates done to that file did not take account of 72be5aa6be4
> ("KVM: selftests: Add test for PSCI SYSTEM_OFF2") which has been merged
> in the kvm-arm64 tree.

Bugger.  In hindsight, it's obvious that of course arch selftests would add=
 usage
of vcpu_get_reg().

Unless someone has a better idea, I'll drop the series from kvm-x86, post a=
 new
version that applies on linux-next, and then re-apply the series just befor=
e the
v6.13 merge window (rinse and repeat as needed if more vcpu_get_reg() users=
 come
along).

That would be a good oppurtunity to do the $(ARCH) directory switch[*] too,=
 e.g.
have a "selftests_late" or whatever topic branch.

Sorry for the pain Mark, you've been playing janitor for us too much lately=
.

[*] https://lore.kernel.org/all/20240826190116.145945-1-seanjc@google.com

