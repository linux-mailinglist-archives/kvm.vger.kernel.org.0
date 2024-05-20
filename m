Return-Path: <kvm+bounces-17789-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DC5F8CA1BD
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 20:03:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1EC5EB2190E
	for <lists+kvm@lfdr.de>; Mon, 20 May 2024 18:03:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 607CE13957B;
	Mon, 20 May 2024 18:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TCdP5co2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CD013848A
	for <kvm@vger.kernel.org>; Mon, 20 May 2024 18:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716228120; cv=none; b=TwcZ15W1L1ludVH/LUWHakndEYTJ3e4WQHeUcsJQh5dDDjPJEVswKTv18G5fbuuiNMhJbpMYaYx2R2dkB26trXwdtDU7SHb/3QsYV6jr7d7w7UjcXe7A607+lJVqJnt6cixNkPwwWvJW7gTqsDWYzv8NA2YXOEointiHzDhbaJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716228120; c=relaxed/simple;
	bh=ThAtV8/RaZOXL6OfIQr7NqoXcDo+g2hyeB95dXoGkWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AQCjrYuycSM1BqTjn4vu8omEfzIs/xI21+Ai/pqlimlFCAUC/TaPgHd692BZn18ZdCp68Tf5IRwbXxhQnj2KArPo0enx8j0qOnQ9rD7GZY7gcZ4Ag7l9XWkGTVdKce/A/uyfhx2mRXPJqBOwjC/y+6V7+/FEd1cCNpJj+3T3NDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TCdP5co2; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-572a1b3d6baso17364a12.1
        for <kvm@vger.kernel.org>; Mon, 20 May 2024 11:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716228117; x=1716832917; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C0EUk3VTdFf3wR/+ltNitT6ijh9TI5cz0EzrDG2fXs8=;
        b=TCdP5co2eQ2rdnIZY5X77YfUyGK1xCrAnnTArpWzcSmQrc9lLMZE+wrrnf2Hw71+wJ
         /Xkx1NzNYxwPtBPSlDzsT0NqUaq8DWF0+MGrvzqo2XWkEZBdXV85QEnTZItU2OWmLrNR
         24reGxLIvFdCFdCOjDXSCs0ElzlGtyp3MCRR1Re5MK0YFfHpsG2lG1AQVHekie40bQXW
         DAz72bsgGDqeNRqVnXxK1uuqs06EG+1ZDMJKg1J8PLsZqIzHOWCO+915sioc9oeS7KiM
         fhOTpUVebzyFdrb9f3OP8BUr+2jX+Pbl/5WWbg/oCquNDBHEFtxhzVPi1M9ObvnbYXe+
         u0Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716228117; x=1716832917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C0EUk3VTdFf3wR/+ltNitT6ijh9TI5cz0EzrDG2fXs8=;
        b=ED/m9+/zFrkQimvR3FQEYE5RzFGtUtUeElw/9s4PQIDF2ZReirGpknYzYSqFZDwBye
         KnmKbYahjaAjpsCq56u/Ez3SrN6LZib8JrN+1ifnzDTXpIDgeCSae6Q9haB2AYXCMowe
         Ik0zK+Sg2AlRcDG6VFAb65kqa+gWML95+YYkHPtX2fntb9DNyMOi3hoHkH7+JPosfMgO
         Aiy+iMDAJ9Q2yCKbLCRpL/EZvvvkvmz/rruZQueQDXxCpZjW9ZSnCYI07XsYQmHl8GcK
         Qe9IlY5RjLkHt2jnESRoWtkJNyCxp/Gubur9cTw3OMFKq/puXIYIsgY5BkpQfa4wPOVC
         JIdg==
X-Forwarded-Encrypted: i=1; AJvYcCUiLyvC2MnomsrciClzZFvz7eB8oBV+gG1KfPusWDyvDTE/P99wIIOCpka1qLqpdFI56Up2JV0gC7fwZmEAFkhvuy4T
X-Gm-Message-State: AOJu0Yw+dgB0k076b/JWsfZkbTYwSW+TcMm/I/hB0SMedEzAgGJmIiBd
	Y3bI7X3TaCbrxgHuliCKyNSbRi9eXotnrEbAxLrEd6cF4qg0D8YLC0jxcknaN6rBjTYnGsXixIL
	Ri9NV8pjSQFQS44HaX9Giqb7qLDscUPcJKwuO
X-Google-Smtp-Source: AGHT+IG8Z+2iw7xGf53mN3w/XeVsWFWYzjQGICvUQj/dAcfHn7ngEhHO670hpW3XjQ91xph7K4EZbEyy9S8QX1yXaPs=
X-Received: by 2002:aa7:d39a:0:b0:572:a33d:437f with SMTP id
 4fb4d7f45d1cf-5752a70fc1cmr324926a12.2.1716228117191; Mon, 20 May 2024
 11:01:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240520175925.1217334-1-seanjc@google.com> <20240520175925.1217334-4-seanjc@google.com>
In-Reply-To: <20240520175925.1217334-4-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 20 May 2024 11:01:41 -0700
Message-ID: <CALMp9eS9Nani-jzjQjfWyMS+gQTrH6XHn588EMpCPQoug-Gaww@mail.gmail.com>
Subject: Re: [PATCH v7 03/10] KVM: x86: Stuff vCPU's PAT with default value at
 RESET, not creation
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Xiaoyao Li <xiaoyao.li@intel.com>, Kai Huang <kai.huang@intel.com>, 
	Shan Kang <shan.kang@intel.com>, Xin Li <xin3.li@intel.com>, Zhao Liu <zhao1.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 20, 2024 at 11:00=E2=80=AFAM Sean Christopherson <seanjc@google=
.com> wrote:
>
> Move the stuffing of the vCPU's PAT to the architectural "default" value
> from kvm_arch_vcpu_create() to kvm_vcpu_reset(), guarded by !init_event,
> to better capture that the default value is the value "Following Power-up
> or Reset".  E.g. setting PAT only during creation would break if KVM were
> to expose a RESET ioctl() to userspace (which is unlikely, but that's not
> a good reason to have unintuitive code).
>
> No functional change.
>
> Reviewed-by: Xiaoyao Li <xiaoyao.li@intel.com>
> Reviewed-by: Kai Huang <kai.huang@intel.com>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>

