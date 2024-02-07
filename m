Return-Path: <kvm+bounces-8284-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E15884D39D
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 22:21:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EB8D1C23E2B
	for <lists+kvm@lfdr.de>; Wed,  7 Feb 2024 21:21:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4292312838C;
	Wed,  7 Feb 2024 21:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4Kbig4+t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2321127B65
	for <kvm@vger.kernel.org>; Wed,  7 Feb 2024 21:21:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707340905; cv=none; b=eFekRINp54Tjyu+IIAXK0pt1Hm7+NdOaUyATqC2orXptBz9Qxjw03EuxY4CY5lNjy5N6nA0CYllWAErqxbmcDk0NqKVslKy8YpRcIUmzZJ/AdyNRCiC8xcbzSBpT2rdfvPw9bQCisnIJd72dHGED6hrTM+eiEo8RSskELMQLGvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707340905; c=relaxed/simple;
	bh=UQlLBfZgZXSkYlQ8HJZCC0qwcFlgHKC0bjB8npWrlD0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SnZ8gBAjYQH6Um2wIk6jd/cvBecrf6HIPPb5DvRarF/wvOGcIc5f0rBn0NpJNWsyjm1/Puf2UDWL5m59evnNoAm4ix50hksV38IFK0NVLInVn8hQQNhB9Cj6uyrgjEj74+VIYxBGfMUOZKMFPglMI5BB5bw2MyTe6YWvd7qKrhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4Kbig4+t; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-595aa5b1fe0so668672eaf.2
        for <kvm@vger.kernel.org>; Wed, 07 Feb 2024 13:21:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1707340903; x=1707945703; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9+9siunvM5UdG2ZEMEzLFuGyA9mTYuPGVcSBrejH4V0=;
        b=4Kbig4+tV7wo2razDOnJ33YJidQJoFZ8pnMvppXx0sso0EKbciroux2PyQfcA+q6Eh
         dSy837a5Yxe3pGEr14M3jXKQA+JI+/P37KAxg+Lgd+/AQqzt2IGkKskZ0xYimzReDVaN
         H2OQG24cX+niFSesQipJ/abUd0bD4sZCKUcltyEl5IgqC0Lzur44eu39sf/qDHw42dgq
         kxThR7fPnXh6D8Zj4dWL6tZWJGdCwWv9qKFSjPCYFpTpHrySpeQzoNPFZdEQZuOZjER1
         2GMfdn8Baheu/U7CC2Zi9VAcGLpqMaEZB5U4+gxCfBITF1EITmRQxcQIMn0XZ40t3JLI
         M3Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707340903; x=1707945703;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9+9siunvM5UdG2ZEMEzLFuGyA9mTYuPGVcSBrejH4V0=;
        b=G9OjmeaoouxPB450IKIeTaR2EKM8BcUjvAh2u04hw8obJxRyUa/v4ulVKex1Qw/zxu
         889QjlMXHvwuo/sd8KXdUAcstJzykdDWpiwtxUqaEKWbPfwfdT3tvfBtgWxf+k9C9wKw
         vHODReIKUcGkeuloTINxXzX9B6khtrN7w7UrMHsdLn3v88vNkZZD/sSE3MD6MkCG4wix
         ZFoGmC/A9nmdyONXXDx5dASxIbNGoNLuSr1JRIir6KFi6r00gsXTIq6VQee0FBmOjBAC
         Y3JvRaIyLSu6yekLnIBngoil5HrW+TIuRcI1Xl5KgRMRAx9hwYzKPJboVY2ptOjB+fmN
         Qx4w==
X-Gm-Message-State: AOJu0YzPWYwGaNVcuF8tBPjv5X8NyVQi8wBcrqhTLDDB0G6SW0qkKgXR
	YUL7zLnCgXB+6Ky6dSvVO63tAsRo08/2dBe5xB7Q5HWBSQ3e4TfUnPzJwwJzDYuISW7MU5cSPlX
	argoWZILLgOoFDTPo3sNBQxit0IU590jAeEPegBCoiJ953sbi7yX6
X-Google-Smtp-Source: AGHT+IHElp9ZPny7h8jfiC7GNRGG1UZioZ9JVc8UP8z30enIBWjKc+VXuS1u69leeZYfXtJ8/RrfQvLACexjKmcwDPM=
X-Received: by 2002:a4a:3402:0:b0:59a:893a:22fa with SMTP id
 b2-20020a4a3402000000b0059a893a22famr7853333ooa.6.1707340902937; Wed, 07 Feb
 2024 13:21:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231109210325.3806151-1-amoorthy@google.com> <20231109210325.3806151-9-amoorthy@google.com>
 <CAF7b7mqDN97OM7kgS--KsDygokUHd=wiZjYPVz3yk7UB0jF_6w@mail.gmail.com>
 <ZcOkRoQn7Q-GcQ_s@google.com> <ZcOysZC2TI7hZBPA@linux.dev>
In-Reply-To: <ZcOysZC2TI7hZBPA@linux.dev>
From: Anish Moorthy <amoorthy@google.com>
Date: Wed, 7 Feb 2024 13:21:05 -0800
Message-ID: <CAF7b7mqOCP2NiMsvzfpYaEaKWm4AzrRAHSGgQT9BWhRD1mcBcg@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] KVM: arm64: Enable KVM_CAP_MEMORY_FAULT_INFO
To: Oliver Upton <oliver.upton@linux.dev>, Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, pbonzini@redhat.com, 
	maz@kernel.org, robert.hoo.linux@gmail.com, jthoughton@google.com, 
	dmatlack@google.com, axelrasmussen@google.com, peterx@redhat.com, 
	nadav.amit@gmail.com, isaku.yamahata@gmail.com, kconsul@linux.vnet.ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 7, 2024 at 8:41=E2=80=AFAM Oliver Upton <oliver.upton@linux.dev=
> wrote:
>
> On Wed, Feb 07, 2024 at 07:39:50AM -0800, Sean Christopherson wrote:
>
> Having said that...
>
> > be part of this patch.  Because otherwise, advertising KVM_CAP_MEMORY_F=
AULT_INFO
> > is a lie.  Userspace can't catch KVM in the lie, but that doesn't make =
it right.
> >
> > That should in turn make it easier to write a useful changelog.
>
> The feedback still stands. The capability needs to be squashed into the
> patch that actually introduces the functionality.
>
> --
> Thanks,
> Oliver

Hold on, I think there may be confusion here.
KVM_CAP_MEMORY_FAULT_INFO is the mechanism for reporting annotated
EFAULTs. These are generic in that other things (such as the guest
memfd stuff) may also report information to userspace using annotated
EFAULTs.

KVM_CAP_EXIT_ON_MISSING is the thing that says "do an annotated EFAULT
when a stage-2 violation would require faulting in host mapping" On
both x86 and arm64, the relevant functionality is added and the cap is
advertised in a single patch.

I think it makes sense to enable/advertise the two caps separately (as
I've done here). The former, after all, just says that userspace "may
get annotated EFAULTs for whatever reason" (as opposed to the latter
cap, which says that userspace *will* get annotated EFAULTs when the
stage-2 handler is failed). So even if arm64 userspaces never get
annotated EFAULTs as of this patch, I don't think we're "lying" to
them.

Consider a related problem: suppose that code is added in core KVM
which also generates annotated EFAULTs, and that later the arm64
"Enable KVM_CAP_EXIT_ON_MISSING"  patch [1] ends up needing to be
reverted for some reason. If the two patches were merged, that revert
would silence *all* annotated EFAULTs for arm64, which seems
incorrect.

James and I had this discussion in [2] (I propose an updated
description there too).

[1] https://lore.kernel.org/kvm/20231109210325.3806151-10-amoorthy@google.c=
om/
[2] https://lore.kernel.org/kvm/CAF7b7mrALBBWCg+ctU867BjQhtLQNuX=3DYo8u9TZE=
uDTEtCV6qw@mail.gmail.com/

