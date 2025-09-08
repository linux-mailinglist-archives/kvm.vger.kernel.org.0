Return-Path: <kvm+bounces-57031-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AB86FB49DA8
	for <lists+kvm@lfdr.de>; Tue,  9 Sep 2025 01:54:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BEFAD1B27480
	for <lists+kvm@lfdr.de>; Mon,  8 Sep 2025 23:54:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D14D3112C7;
	Mon,  8 Sep 2025 23:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D4UtkBDx"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5766630E84D
	for <kvm@vger.kernel.org>; Mon,  8 Sep 2025 23:54:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757375665; cv=none; b=ERwr5b7csuepODEAl1bsoMjSaAkPyoNiBrGfo2g9yQx/hHASFkx4jgDKRXY+4waCfNRtFCs6UWoC1Gq1UTYox7RL+nLDbZaVVaoVwQ/CPHZm1++VUuG9NYDwxESzpyfe63nHM70IJtONdIaNOsXUgMsOGK/AYUxdWE/sXpEJzxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757375665; c=relaxed/simple;
	bh=nqQiLGDt4E8Jq4QZSeVe7zoFw3b3ODJL8vpKGUrpq1Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=P4vk3EQ5fLdFZRzsYZbS1kEZPtiPB1Sa1t2v20DbbCVVEZwKYOY7CHUl1v817MJxio+h9mmK7CQ42mGEEzJvam1GSK+604HCbJW7ggm80tPv51HqaMnggQn62ltf4TdPVEpDud6SBUPxHq80K1SRbXY0/PLZoFxYae1YuUUXE9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D4UtkBDx; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77278d3789cso10837546b3a.1
        for <kvm@vger.kernel.org>; Mon, 08 Sep 2025 16:54:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757375663; x=1757980463; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K/rfS9/CYErQEW8MvIwXJiXzKk2lG6NUVw07jdOfv2E=;
        b=D4UtkBDx6kewgzUqBGgAizUJQL+gilwW6/qUW7e1sW9aLGQQJrdZI/uSXgJCkfEsok
         BxXjOZVcva7pGHmBk6fyDs8VvDQm0KHaWgZWAfrT+BZahGLSBNk2fibvaOeHXJLmQkH1
         /gJhA+PUgHl+TV93h2958FIIvV6+PqLKUtlXZPPYQUR+0lXvnb6aw03Lm6G9TDS+ua0f
         yBG3oVWlZHr/eyz43zxB6Fwj4xXSaEwbh8FYRpAW9zsRIMmWjLloCnX5yomvCKf/2HYf
         kTJTbvZcVH7t4a+PbxM9FC3gAaB99cU7SmecDa4l5X2IrsJXJ1jQk9UivSx2CaL3htFY
         IgdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757375663; x=1757980463;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K/rfS9/CYErQEW8MvIwXJiXzKk2lG6NUVw07jdOfv2E=;
        b=kZwhie3rapDGzXgayFttKfmCc88YTZ0A8IH/8yl63raW1e28C7JNAsWIHl1XYbzOS5
         EQbBigc2lcHb2m8VkdUJAcqslMt4ytfOOCU+VjHpmedS3ElxaIpbDOX4ZCyJEeWzHzd1
         o0G6vefqiRN9F8VuNVRbbharqysTur/9xxXHp4oVTeFNeN4EXcQs+wIxxBeliqsjbvGo
         6fMVdSHHbbfDoTuxLNFIIpquh5yC7bly0Kwx0wUu3Zxul6baZO+3z1HbBpU91GCqAmLC
         gHOe2tIf4Ra126EIWnf5lAmWs23cPAolMUiP7x9ObqZWm5AolXb6+iBL2Pqvu0hUXoOd
         u17w==
X-Forwarded-Encrypted: i=1; AJvYcCXEXVxji3FlP7F4aNC83z5796S1Obgdl0seM0mNRC8OY8hUTnmIiwu3PtGT6YofOpt27xY=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHk/2tq86dU+XAllkSI9Zu5jVAJCStvaH6uXaOAl2yhOQI7jSR
	LNQn64e+A3JISpQZ3n1ATbSKnFLEvHiQYbrPz9IIPpHkYb4UDuzR03wxJDqiZHyn5IBQnHmfaMC
	/xjsbug==
X-Google-Smtp-Source: AGHT+IHFuX9HZZ+3Ap9KfIP9YqmTsis1lj1RdPwzOjpZRGAUvoQwOVBBtSltO2l5sj1D1kqm/ucDlsqS4As=
X-Received: from pfet12.prod.google.com ([2002:aa7:938c:0:b0:772:32b1:58f9])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:1394:b0:771:ef79:9338
 with SMTP id d2e1a72fcca58-7742def5d1emr11472262b3a.21.1757375663426; Mon, 08
 Sep 2025 16:54:23 -0700 (PDT)
Date: Mon, 8 Sep 2025 16:54:21 -0700
In-Reply-To: <b55f2ab4-da7c-5fed-adab-ceca54282ddb@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250826233734.4011090-1-seanjc@google.com> <b55f2ab4-da7c-5fed-adab-ceca54282ddb@amd.com>
Message-ID: <aL9srWU7gnKJzeig@google.com>
Subject: Re: [PATCH] KVM: SEV: Reject non-positive effective lengths during LAUNCH_UPDATE
From: Sean Christopherson <seanjc@google.com>
To: Tom Lendacky <thomas.lendacky@amd.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michael Roth <michael.roth@amd.com>
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 08, 2025, Tom Lendacky wrote:
> On 8/26/25 18:37, Sean Christopherson wrote:
> > diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
> > index f4381878a9e5..746a57bf1f71 100644
> > --- a/arch/x86/kvm/svm/sev.c
> > +++ b/arch/x86/kvm/svm/sev.c
> > @@ -2360,6 +2360,8 @@ static int snp_launch_update(struct kvm *kvm, struct kvm_sev_cmd *argp)
> >  		return -EINVAL;
> >  
> >  	npages = params.len / PAGE_SIZE;
> > +	if (npages <= 0)
> > +		return -EINVAL;
> 
> Would it make sense to include a !params.len in the giant if check just
> above this, e.g.:
> 
> 	if (!params.len || !PAGE_ALIGNED(params.len) || ...
> 
> ?
> 
> That way everything related to checking "params" remains in the one
> statement.

Oh, yeah, duh.  I overlooked that the only way for npages to be '0' is if
params.len is '0', because the PAGE_ALIGNED() check will handed len == 1-4095.

Will send a v2.  Thanks Tom!

