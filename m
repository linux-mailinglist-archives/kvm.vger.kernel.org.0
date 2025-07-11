Return-Path: <kvm+bounces-52076-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE817B0102E
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 02:30:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35B0E5A7D61
	for <lists+kvm@lfdr.de>; Fri, 11 Jul 2025 00:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C30D0C2E0;
	Fri, 11 Jul 2025 00:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EOowp1f8"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0ED38B
	for <kvm@vger.kernel.org>; Fri, 11 Jul 2025 00:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752193797; cv=none; b=rzELfp8h5+YG9UkZfaFEo7JG7e/JSzJupZ8wlHg4YWebhdOybHP+QpyJGTELLCFfbFv9cUrCC5nF1oAk2eeA2wPAVl2juR+JkAn2J595gZrKLGC1/qApOxkZoA+NNz/2P5tKBDCC7vuipDcZOTJU75V5zJ6F86O+DjZoceq6lSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752193797; c=relaxed/simple;
	bh=r0lPHxvs43uR+dHXcIrd5JAul1oKL023d8VVoNs5Xqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c+lBmTLWiVdb2affEXjwrg/vuTjgpQdRfJdDncL36X95rZRKJqYRACwdPVhNk1D1rf0kxeX2OJsdB17aADeJpPQUCwHYiumiahkaL69YZrJOGlUEvdxN6bq80aquIT5juExm+v7+t2hrpwFI+JC0I8bTEihif1/aWd2a5Gkhrx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EOowp1f8; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-710fd2d0372so20255067b3.0
        for <kvm@vger.kernel.org>; Thu, 10 Jul 2025 17:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752193794; x=1752798594; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r0lPHxvs43uR+dHXcIrd5JAul1oKL023d8VVoNs5Xqk=;
        b=EOowp1f8ECHDega+HXidInFVYyVXOPGTJmAqlOau+hIRS1qPbq+/u86DEnodphUkGE
         oU0eZAC7ADM9pG69HxOvrzdFLT30vAXYkrQFosAL7PtmkroZJHLFYLDzrCLQPYfJHbSf
         S6lPjVHx+wE1Xhu3p6MzCSerjPMimJbEygfjitIwuPfos0yph8JAny/kJLEjAIDc4/S0
         bDsLIVfaHh11bkHmuLvrKIZ/kBpbCJOlIYLRdO/u2oWi3KLqlrmIckZbJtcIUvAHA7Ug
         FO4QRF0FVViixtDUBmaemoAU14QPOZOaR/N8/vFG3Mw2yCO3tl+i/HBirh/qpLWScJU1
         M24A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752193794; x=1752798594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r0lPHxvs43uR+dHXcIrd5JAul1oKL023d8VVoNs5Xqk=;
        b=xFQZo4c5dA9zVofW4fYbRIAQItbXbHiTofXnysIDHbHD5jjBM7yEDzmrJGXGq5rBZs
         mSW8FuSwcm9OQ6u5nhw5bpVlg5dbHP4tZ9j/TKmW0nLgWkI5KPNGf/hKHcjjMelZT9qn
         0cCgd1jSHr8k4nUx/u534V85LdACsVDLEm8RDS7oC6QeO63M3VVs3mZ4Cawqz0ElU/q2
         UejCpIPqAKLTjf5zzNRLeG+8zwk9Ar/BzEDN2je2cz26dM4NMzIB5dy3o2Ve95Zr+TB4
         qH0lXPyF5uExBWiscPBn5v9vKRVsGAdWx6S9rCD0cYNlgWUVAlvBfz2T6Gg9WTLs77KY
         MV5Q==
X-Forwarded-Encrypted: i=1; AJvYcCUo4/r3gWnnZXKWjK6/nZLyzRgPzm4rR+b4rzgSCcwHBmMOxXptkQZKpvCnwDycjqmge58=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy6djtmNgPr9Ee2FuK/IbClvcxaHYGesZ8ZHCZw2JjtEtcmOKw
	erTaOEvJkkG8RnjINA1mZsXFjiICUAA8/iq/Fwx3ncWjdqsZigOZ4ZtYm9gmMBI7rk38VcmVaBL
	tZyszEL5bMj+XHSX/fqL4lchN/BkD2UogaJeD9q8s
X-Gm-Gg: ASbGncuoJ85lY5kJT5Ezex46g4GMYqax5+2V5k11E6SEVVQl4iBiHJRfhUq/hB5mYr2
	/XsbnT7Kei9JvuJrX2TftE4vuHjNF+1s2IqenMKleOCKL/IlfhEBT8ddzq0DiC5OxLe6fi8N/P0
	/5+GgnPzjj3RiD6LB7kbHZRVy8dSSUP+jas55dJMSvarMM/9ZSUltzJZqWMcgtPXqPb7DOLNQSr
	SoGjJrKwoe0Ui8a2uz8B8CrR7bClsMyoYzj
X-Google-Smtp-Source: AGHT+IHo5wOXiLQsn/5Sf9V/dYLksjYkGC6K5+8xIfEcLBdrtFqnS93Qdoy+B89S9yKZhvHKYo4pICjWraZMAWP5GVU=
X-Received: by 2002:a05:690c:23c2:b0:712:e082:4300 with SMTP id
 00721157ae682-717d69d151emr22793207b3.14.1752193794242; Thu, 10 Jul 2025
 17:29:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250711001742.1965347-1-jthoughton@google.com>
In-Reply-To: <20250711001742.1965347-1-jthoughton@google.com>
From: James Houghton <jthoughton@google.com>
Date: Thu, 10 Jul 2025 17:29:18 -0700
X-Gm-Features: Ac12FXwp99zxVbMC_VhJYh2XiCFZAUQ9b0PyTNfZpbH7kwWeLapvYsalM8A6msk
Message-ID: <CADrL8HXQBfT2MLUEW+0w4P0weCjCOWdDpp3kSu5uta4-vtXn2Q@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Fix signedness issue with vCPU mmap size check
To: Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson <seanjc@google.com>
Cc: Venkatesh Srinivas <venkateshs@google.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2025 at 5:17=E2=80=AFPM James Houghton <jthoughton@google.c=
om> wrote:
>
> Check that the return value of KVM_GET_VCPU_MMAP_SIZE is non-negative
> before comparing with sizeof(vcpu_run). If KVM_GET_VCPU_MMAP_SIZE fails,
> it will return -1, and `-1 > sizeof(vcpu_run)` is true, so the ASSERT
> passes.

:%s/vcpu_run/kvm_run/

