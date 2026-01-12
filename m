Return-Path: <kvm+bounces-67789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 13AEBD144F7
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 51CF630411A9
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:09:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0FF437417A;
	Mon, 12 Jan 2026 17:07:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="frS+7Vlx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="l+G30sfD"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC1930E822
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768237629; cv=none; b=E6dNLS1yCGNgmcfbakkCuC5d015mwwMtabe7RiQvmdGX8idnGikUBMsZXo172hdwiYF9aiNycIwoeE4JC658yFXIZyOQNfrABXuGjlgGzK2lLSwyDjZBV6Ee8Hl09WcuW8zqrIZLjYF9XXjXRSMZJsslRUpjNIizs7jEdvTYbh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768237629; c=relaxed/simple;
	bh=atcExqAD4lV4BNqaM4Rw6bnDCs4WNyCh/B0o/oZAYt4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mbnTGWwthBHxGPZH0hv0G/MhmFRcBE0sJ27SUH0bIiujdz7F/+8qE9KjQNgncS7IuV4DNqRycyQxpEyzjJdO10Xkesvd0Hr6ygOD9qqR5sY+N2w7SFfhE6Xo3hjX6Gx3xoLB9Us0OYjK9Bn4dEgo/3DfZi8rlwl/LVouP5vM11Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=frS+7Vlx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=l+G30sfD; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768237627;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qBoo6m7IMy23LR40vfG7pQLwbyN+6AetktVkWLeu73Y=;
	b=frS+7VlxE05LwgLe3QF19nN+DXZ8WRuegUOMHs5tYwQOWmTYgqBw1POFD/yIex5g2ZTfYL
	4j53vAt3irteoYbLEIlnMvrfr/FLtVqdrK+uOZfAa4fL+2WFTCh0E2Dvd5d1Qc6uGEUP2R
	MPZrYppjETk+DRXC32VQR8mQDspjr+U=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-r_-UHyHVNKSS73DyJR1nIQ-1; Mon, 12 Jan 2026 12:07:00 -0500
X-MC-Unique: r_-UHyHVNKSS73DyJR1nIQ-1
X-Mimecast-MFC-AGG-ID: r_-UHyHVNKSS73DyJR1nIQ_1768237619
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-42fd46385c0so3853716f8f.0
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:07:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768237618; x=1768842418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qBoo6m7IMy23LR40vfG7pQLwbyN+6AetktVkWLeu73Y=;
        b=l+G30sfDaXH/HIOleZRg4Fr5GjaI5FZDlX60z4UcVkXBMB4Le/EIUnMjA4unL1ln6Z
         nSsgaovhKzNoJ5RLFxKPh44nsN4xPtxQDMeRYkFpuccl+i1yVX7W9pB8BwDjvtFA+eGl
         MSxU4An21c+qOUEfdsmgBr5C1H1dmGAogYuWQRwQuuJG557LkWI5ttSW51VH3ZepWrxy
         m8Y54Ld8FnCwij/IwGvmELL6S1tVHXCtXGmgcciBcpnJtateXRHuR0FK7urv5g5Lsm4q
         3wUjGI05HL66hkgE0QOty9MhD6KE2LJJ4Wz+T54p6iLhdA8PVmcojURw4CyCjrw7CYU+
         kGfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768237618; x=1768842418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qBoo6m7IMy23LR40vfG7pQLwbyN+6AetktVkWLeu73Y=;
        b=iKc2Cr4a3QIpIFoAgh9npJiqxw4tQnLEwQxjfsihpYyfA1+MuLOePzHtrs6wUrDAtq
         zOIGC8DnYyfEtB9YUqHjH0GG45nprDfNdYAWOgdBWzvu1GOsA1kUeDhv3tkvZM4Td0bW
         HzjP8Jk+8QeT5sxSEP6YW/0GPkVvbd80sYnqxdStX54j3sehlyuqi46qiV2ReaOd7TQO
         uuXV7OUH5xuQ2YAZ1YwI5onzKC3zhtYtplxnvVrorxOYcagI+wm5H0RtQa6vmyfV1Uzg
         9NrHkfXRHGF6CZ+/9CUjW9iIP8CZMQF5Si4+WF3YB6OxzyWtvzko6SpHEfpWQHa0e3wJ
         CMRA==
X-Forwarded-Encrypted: i=1; AJvYcCXUZsDAzt+tR4+kVPWKPtF5uEcLYk9mMXwYcH42jTP5KCAssUD6vhQ+e8zJM1L20maQv1g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxTuHh6G9tbwjz6nyXlUZFSb/SILiPFYR92lElPEnzomPyDP2RN
	iJgDO72c5nKafJeSkwwTwEESYrFAr+bALAPATeUF1BnFUa3JA95ZLC0VGrR3Cpqufnnc1sYzSyF
	bYMEe50FSh9MC7hEby+CHKmZPZ+EE9NCb9HXYGpZm2IJLbbl6LYq/dH4jKF8EomVZ5YiDfBI8Mt
	0H/cUh1K4K0ed1ty5NidnZqnVKsYTA1rLTDuyzWJg=
X-Gm-Gg: AY/fxX68dVYR4FL4U6nGMsWvq27XYnyZtXJiCxjGy90GuyUwTDX8n0pehRhPGvaSwT9
	4OHoTmEWlhFK5PMVkvVl0HzVHS/bVewi/YZNVy4Nz0LNPJg6qXoO6ByvgNqI2bTwxBOiP865Wlz
	NrDl/IWOXGE5hPbEdaPreKVwF97n5TXgC57E8Tta8oAzk+j5TTEZDor08wGnh/sdFO+I2cEACg7
	AGjCOAlkSslfZuE75zOCRcoprWeXrmbVoWCrk+qePRdYPjx6bz+IFVfoKp+LrY//xrYUg==
X-Received: by 2002:a05:6000:22c1:b0:431:74:cca with SMTP id ffacd0b85a97d-432c3760fa1mr22065000f8f.44.1768237618302;
        Mon, 12 Jan 2026 09:06:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFm9OyhUvJ/5tUgFBnEaYolWB7ojG8NUI0rgwv93Koj3Oy8wKMKoCPOddM8tV8UWQEAtNcjHKPPtW9NB6jl3xM=
X-Received: by 2002:a05:6000:22c1:b0:431:74:cca with SMTP id
 ffacd0b85a97d-432c3760fa1mr22064963f8f.44.1768237617853; Mon, 12 Jan 2026
 09:06:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-10-anisinha@redhat.com>
In-Reply-To: <20260112132259.76855-10-anisinha@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Jan 2026 18:06:46 +0100
X-Gm-Features: AZwV_QhRbtEXIYgzH3mUULZBtcxNLpl5sTrXkpatJBwfOPGAYrsyvIbiYt31Gpw
Message-ID: <CABgObfbptgbn7qD4ZzQAmznupU9Z_dwgnPgXadDU0akt1d4Qpw@mail.gmail.com>
Subject: Re: [PATCH v2 09/32] kvm/i386: implement architecture support for kvm
 file descriptor change
To: Ani Sinha <anisinha@redhat.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 2:23=E2=80=AFPM Ani Sinha <anisinha@redhat.com> wro=
te:
>  int kvm_arch_vmfd_change_ops(MachineState *ms, KVMState *s)
>  {
> -    abort();
> +    Error *local_err =3D NULL;
> +    int ret;
> +
> +    /*
> +     * Initialize confidential context, if required
> +     *
> +     * If no memory encryption is requested (ms->cgs =3D=3D NULL) this i=
s
> +     * a no-op.
> +     *
> +     */
> +    if (ms->cgs) {
> +        ret =3D confidential_guest_kvm_init(ms->cgs, &local_err);
> +        if (ret < 0) {
> +            error_report_err(local_err);
> +            return ret;
> +        }
> +    }

Most of the code here is in common with guest startup; please extract
it out of kvm_arch_init() and into a separate function.

There shouldn't be many ordering dependencies, if any. For functions
like kvm_get_supported_msrs() you can add a "static bool first" to
ensure they aren't rerun.

Paolo


