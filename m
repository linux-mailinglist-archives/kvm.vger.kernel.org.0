Return-Path: <kvm+bounces-30211-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 19F9D9B80DF
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 18:08:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D31AB281F3D
	for <lists+kvm@lfdr.de>; Thu, 31 Oct 2024 17:08:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C12921C2DB8;
	Thu, 31 Oct 2024 17:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b9XT95dw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 358141BD519
	for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 17:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730394473; cv=none; b=sjSZy52CVKl+iKHkNIJBpoh6L/FEaiwN/pT0Afc2NZC7PC3FtRSzFNXCvwFeuozPLMbXMDi7Qtxomks924Mi8GfMhEbJ/Cg1Ihug/yebrQJ9IoY33w4hg/JWj26cQhAfYf5HliIHABmErtE92ztuWfWgL20PNKIyeqWMeM118ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730394473; c=relaxed/simple;
	bh=3YHVhcyccrK1611fi5TdoKdw0rTHBd2Lfi23/mCQZ6I=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ImW0MTaBP+FZU5g4+zeLljuEGQoY9bXSOd4l4nSvxeswW3OL0Mts2+yUpNFfqh3stBs1B6M+Ntxf8QcPgpc9kVQ7ee3iBU0RbOsLKCUoCLJ8Ai7BQZCKNx5/U2Fe2I8zkMJECruB1SJisH/0CNl2VmtiLHRtTH50XAUdUwPAufY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b9XT95dw; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-7eaa7b24162so1234700a12.1
        for <kvm@vger.kernel.org>; Thu, 31 Oct 2024 10:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730394471; x=1730999271; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l4ZRnnKWx+ZOJuQ9QExSWVrJVn248r7C6UTENDtu3lw=;
        b=b9XT95dwKvzuxZOuMYABHINhYVWUXv9R3ApxQIWdde9MZKYKwEN635z9/BLfbEe8pY
         dq8mGxYQDuonuenfo4tDZTYZxwsGNGAd1OcDzWtePrZst5VFMWTgSMRW36AZaRJuYYS7
         Gm7lb8vSWp2rjsse11VyXl8eaugG8zTBtlt6U77Tzw4bE1VUZ8SWXahOFX4ULoScfOtY
         /I+RR2SVh3z/JFecPnSSy9i9v4rUd/z0btA0v+aMsFO78j8gsYhPrSRk0APwxbFarfBY
         8/XPHowb5UK1ug6fWJutHpQmUsWF/coIV/EEYUkZLxwUeQ4wIWr75ONkBWFXQqwCongB
         quVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730394471; x=1730999271;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l4ZRnnKWx+ZOJuQ9QExSWVrJVn248r7C6UTENDtu3lw=;
        b=UkzE6jbB8HsbiczzlNtlFy45YUED+V1O/6C51mxdb6r13UHPiPodAjJtOzRnMwvDOD
         dEWfKVh6lTuASKP7XNC/6irTqNS+tUH8pmdApa0hORGy7RntrNDCjiL6qkJZ3Z5E4Irv
         YWQqSp8km493gXPtHx4IHBnBOniDbng7Y2ZPmziKrgDP9A6OAyTn/roGbJSWbdFkpA4e
         GvSACI7FFam8LyjeRG48Y4ksopC77dNTHE7+uRHVSaX48PDN9TBc5EF1nQF/tOqXBQ7G
         H3jk4TWx+JBTsvp3Fo6lJlC8U8wLWbk5qO0+/v12eKQgTh9O1KV2tRiWulPplapeY2vj
         xKCA==
X-Forwarded-Encrypted: i=1; AJvYcCUIWzP23ViIXdRzN42QeA6we1mk1Ro0FFE55wgAhkZM2Rt3EEAfQWkwuCPqIgHR6u1d6ro=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBN2MadmNglc/BFET4GU736aTLtrpOIXjtxT/Ob/KyLnCaoyQM
	G+VOcJJz1DhByF6IrNbMPQVzgMyAkMwzIXpy6JZuo1FtUsc53ep0Qu/inXVlIt94MTbSEGgbdO+
	VOA==
X-Google-Smtp-Source: AGHT+IG7FHm/6+onktZBvp6D9sqBNM8oY9pPJEfI1BQ3nh7ec4MEnwnQ9cqe9LFdKNXFrKzPUsitbp7hyzQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a63:dd4b:0:b0:7ea:3fa9:9fce with SMTP id
 41be03b00d2f7-7ee4130b465mr10588a12.7.1730394471415; Thu, 31 Oct 2024
 10:07:51 -0700 (PDT)
Date: Thu, 31 Oct 2024 10:07:49 -0700
In-Reply-To: <87froctrgv.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20241031045333.1209195-1-seanjc@google.com> <87froctrgv.fsf@redhat.com>
Message-ID: <ZyO5ZUb8Acp80Ygq@google.com>
Subject: Re: [PATCH] KVM: selftests: Don't force -march=x86-64-v2 if it's unsupported
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Oct 31, 2024, Vitaly Kuznetsov wrote:
> > diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
> > index 156fbfae940f..5fa282643cff 100644
> > --- a/tools/testing/selftests/kvm/Makefile
> > +++ b/tools/testing/selftests/kvm/Makefile
> > @@ -249,8 +249,10 @@ ifeq ($(ARCH),s390)
> >  	CFLAGS += -march=z10
> >  endif
> >  ifeq ($(ARCH),x86)
> > +ifeq ($(shell echo "void foo(void) { }" | $(CC) -march=x86-64-v2 -x c - -c -o /dev/null 2>/dev/null; echo "$$?"),0)
> 
> With this test, the outer "ifeq ($(ARCH),x86)" check is not really
> needed anymore I guess?

Yeah, but at this point in the v6.12 cycle, I want to do the absolute bare minimum.
In 6.13, after the AVX support lands, I think we can/should revert this restriction,
i.e. it's a short-term wart.

