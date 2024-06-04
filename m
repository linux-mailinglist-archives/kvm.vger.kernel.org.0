Return-Path: <kvm+bounces-18815-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 730658FBFDB
	for <lists+kvm@lfdr.de>; Wed,  5 Jun 2024 01:31:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2927E283755
	for <lists+kvm@lfdr.de>; Tue,  4 Jun 2024 23:31:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6451014E2F3;
	Tue,  4 Jun 2024 23:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Lk3kajkG"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512F7144D3F
	for <kvm@vger.kernel.org>; Tue,  4 Jun 2024 23:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717543824; cv=none; b=TM0sGKwppac8Jt8eefwoO4349XH6zUct6YhIRgElnRPUIItOmvEr6uF0wBINnvMsZzSUW8Xv8olY7MeS1vj8L3zJ1U4eNnEXrz11J/c6F8Lyu9/i1OPd7qKVtKm9Ovpk2KWVb73/oyGyuIH+TiHKTXkekbxQPhbrrQKHppQJaV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717543824; c=relaxed/simple;
	bh=VjJmX34+aTYJ+9HTQ5vgX8U5z0y5Ts+H20MVJUkGYKM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bRCpGgcekLmDPjblCcwR2haYmR+EMxVghFZ8lAHllB9sV0QZw6sHuAqiB6kW+umJtV544H7ciUESgSRs+38XipQf43L8amH4/YixmOC/5kjP+yYTYW9qaQFGBHZgtOq0ft3auEDQjAXHvC34oh1HAWWDWJ/GBkPlyWzgifWv/3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Lk3kajkG; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62ca03fc1ceso40575777b3.1
        for <kvm@vger.kernel.org>; Tue, 04 Jun 2024 16:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717543822; x=1718148622; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xfypw/c+5RO0tQuEOThBLk/AkkGlXduiTmVxQ/7nnIE=;
        b=Lk3kajkGkq1zw9xtCwUl23BM+hsOIduU1mq7Gx46PfXj7807AVrc7pn2mUAP6PVqS7
         HR9ke88QLMjLGm8KoE7v5CxDZnlZzNn5a+7BldiFBgIuSPb+VJRaAbeLrOsqmDS0UgOr
         y+J/U9NfIMXE4H20FlppvOPEUlBmAgF3FNyFhKWKy+twE9Z6SkovGq1D1VO9+m9c44ux
         9hWQJLdcv0FWAdVmes4cpe50hYrSkdSeMoQFCJqqa76asb/2K+rd5kBb8lEa1YrJvsfV
         rfT0bIJ7KN+A2AQpsOwqFB/SDVXEpvGgW8gL2s7vd3BllJCRFPyA1Ft7MKUmeoUgPQzi
         khGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717543822; x=1718148622;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xfypw/c+5RO0tQuEOThBLk/AkkGlXduiTmVxQ/7nnIE=;
        b=S/x55gGsRIiNNkoHo0JTl5ZyEAuRPrkbFgIDXvKcsz7T2kyH6bQlvBpTwV1Zc8TPwB
         vdVaFcCYAlB2/6Nd93pdB9RkxsLB2rmGBPyu/wwgr/g3W61rFvft05MFlcf/IGbaDfBS
         6CUFzkHbE4Y4/T+M7cunJtShDAUYgz9ZKcy1JOKYbsXag/Nyi89gSfMltHvea5uoCu7c
         lZyUaq0yFfI4sLrv4K8lXe6n6Taw6gxHPLHOmWiTMB5dz0YE09jDjrlb7BPHgH79KXV8
         dJXdIQqbshwURtbVF1fECqcz479TI4oPL6jGUnCooFEFwyVY9ySrlQqxH1TY+GQt7gpX
         GLvw==
X-Forwarded-Encrypted: i=1; AJvYcCVcu+Jqi7jRWQqeZz5dHVM8RwduQ6f59JEc6i/0XRfRKOQef+jw64xa5TvJDtmaB8lh8+nFBxtBxJnh01xOn5CctWPn
X-Gm-Message-State: AOJu0YzXNF8jZxm+hK+AbdgzvXAgPipMnz3nApcAVSNWfiIKtzpk/g55
	aYdu4U8Tl7qzp2xNqzZhQVjIiPfNryKQYNqcbVczy2k2v/Ym1lTxIwaScfrvYiXwA1pFij+N/7J
	q3A==
X-Google-Smtp-Source: AGHT+IGYHhwobD17I6BcNx47OLoZruHxw9mWITV1BFNUGFWtzbkWqhjasbu6vT69tB03IJERpEy9c90wwX4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:690c:6486:b0:622:c964:a590 with SMTP id
 00721157ae682-62cbb4ba98emr1679267b3.1.1717543822427; Tue, 04 Jun 2024
 16:30:22 -0700 (PDT)
Date: Tue,  4 Jun 2024 16:29:25 -0700
In-Reply-To: <20240424105616.29596-1-clopez@suse.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231116133628.5976-1-clopez@suse.de> <20240424105616.29596-1-clopez@suse.de>
X-Mailer: git-send-email 2.45.1.288.g0e0cd299f1-goog
Message-ID: <171754327022.2778929.14475719898493728460.b4-ty@google.com>
Subject: Re: [PATCH v3] KVM: X86: improve documentation for KVM_CAP_X86_BUS_LOCK_EXIT
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	linux-doc@vger.kernel.org, "=?UTF-8?q?Carlos=20L=C3=B3pez?=" <clopez@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Apr 2024 12:56:18 +0200, Carlos L=C3=B3pez wrote:
> Improve the description for the KVM_CAP_X86_BUS_LOCK_EXIT capability,
> fixing a few typos, grammarm and clarifying the purpose of the ioctl.
>=20
>=20

Applied to kvm-x86 generic, thanks!

[1/1] KVM: X86: improve documentation for KVM_CAP_X86_BUS_LOCK_EXIT
      https://github.com/kvm-x86/linux/commit/d3f673c86c5b

--
https://github.com/kvm-x86/linux/tree/next

