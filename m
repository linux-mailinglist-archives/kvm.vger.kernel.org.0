Return-Path: <kvm+bounces-55822-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DFECB377C6
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 04:32:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 03F3F7C09AA
	for <lists+kvm@lfdr.de>; Wed, 27 Aug 2025 02:32:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 022F7274B27;
	Wed, 27 Aug 2025 02:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k3UcQ+RI"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 883E02741B6;
	Wed, 27 Aug 2025 02:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756261910; cv=none; b=VSV5e5AxZQmkHxJDeJudgJjUrS3uID1lCpwrIYcuHi8IfzGRpx1uTuYpwu+9nKnavA+BPe7F9WQ1sQEehPnG6JGaU+dDgGKCf3G3uirrUPXM3PwDQ8eMuNOIkRGyGHHDVpX5UL/V5/cmPsdGisPYZzXpj7iarNcZiHAY9rDAr+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756261910; c=relaxed/simple;
	bh=3Tox78mtmLbV4ZIp0EyBj34pqSOH2j8gIMnB7+StZxM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZaRAPPMNq8/ihoaD/9u8/b7x6ty2JdFEciG6KMJetBNcpU+NjpUMIjT8kZjL6wbveRKuAtPBq97wqXojdWYtuQYozHcxoe8FEEO3805N/2cmlosZimdNfgFD8YTf0Z1jVWD6mZMyIACueIyUMxmLG1QIJJxYGr9JbJxa9z9RueA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k3UcQ+RI; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-afcb7acfde3so931078066b.3;
        Tue, 26 Aug 2025 19:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756261907; x=1756866707; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3Tox78mtmLbV4ZIp0EyBj34pqSOH2j8gIMnB7+StZxM=;
        b=k3UcQ+RIj3uvaLYxeZUSffKdEM8JFjCsfi7cZwxkRK4Rb9lYa7h0etAPRkSjaRBk86
         ovoEP69nIyJrZx1ZugyJKTuxbfD5C+/i0VrLaAjFEoEo8y6Hh9sxeUnHvlXMCkcrIU/S
         ip8NCfIayahwm80IvHZjeUt4XqlSUjc4YcMr6ec8HjNF595zEEpK9Jf4eIv3TccV/9uG
         Wvc+iC5X00lfJwRKr6nbsJE5ThaJ9BYcBIwYcPf7DjhcAselj3OgfC6ZlbboMPrMdA9D
         2hbdD9en/m8y4C5w/af4/a4SOOMcCzjHufw1KJpmrRVLQyzxzuI6SrvEZxwRC0VwrshL
         c2Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756261907; x=1756866707;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3Tox78mtmLbV4ZIp0EyBj34pqSOH2j8gIMnB7+StZxM=;
        b=EE87sUX9mj4/rwS6bxoPT1rI9Q2HtKngP2jU1O3h0f5/gsBwa4rDaHemuDS+8IO2X+
         ac/XWa7tUbOTcCERnnKOdSSCRad9eCBgALYkzpPDYp6173s5+ynpl2axmCLlrS8jNR1x
         4PduMRioonVkwsacs6h6Yfeb9eHwd4mg63r8eTq10pT9sY5C4W72U3gfDBBQYDhjDOpX
         1DwZMm5PHI1+HyjUs+WGzAVkQu5h0OrT++j7uh+FWGjwYEAUBWarlF7jRoioFhxqM1pJ
         6zLJPbjkwk1fNtRYytGvm+OijwEocXsVwB0xo4naf040U4QcBh8cogxULy88WDQ1H2cb
         EtHw==
X-Forwarded-Encrypted: i=1; AJvYcCUYNHLqL9StO6QzN336FNLD6FIpirIjOBNaST8Bd/JCp983YM8nRc2Xwgr4Lt3UKE9gyxsV+LEP+c6TXD0=@vger.kernel.org
X-Gm-Message-State: AOJu0YzY/2gSedvmPxfZwXYOIYy55+z2o31zGRmmzwK9McNP/4BnKRDh
	6ssELnPCM4pXwyJJ80NfXax7nEkQUBTDfloO1GUy/JA1XHaNmtsMIG7Rlbid9QV2HVEDBXa5ZZw
	C6cC0par5L/sieCtkVrqGoK5LBoTbkko=
X-Gm-Gg: ASbGncs19xereLmIYoDSJO07KfYaqGAFLaiqsFXwWt/pQkkz9NkCAaD3WdF0wbV01Bs
	Yq3AaimHMwedvYjcx0UtctZIEsIByslM6Cmp7PK889tyOawIxB1N51xjONObWr7/cBhzakzQ1lB
	QLOJ5FidPb5wPYn/2v2kamZlED3JLnmTW6M6NNj+Qoc8/+QgYPQC4L+ClI5VQJaZkpGyHH3cEyQ
	BfiUKc9
X-Google-Smtp-Source: AGHT+IF/cBA2dPjn5YWfGm4NB8Dtpf09/BH19PA8AhsgdZqR9MmpCCy8AgCTCnIw+WE2sOhS7LboK3LUldgBf+Lfnb4=
X-Received: by 2002:a17:907:86ab:b0:afd:eb93:f809 with SMTP id
 a640c23a62f3a-afe28ff9036mr1744018666b.27.1756261905930; Tue, 26 Aug 2025
 19:31:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANypQFbEySjKOFLqtFFf2vrEe=NBr7XJfbkjQhqXuZGg7Rpoxw@mail.gmail.com>
 <aK3z92uBZNcVQGf7@google.com>
In-Reply-To: <aK3z92uBZNcVQGf7@google.com>
From: Jiaming Zhang <r772577952@gmail.com>
Date: Wed, 27 Aug 2025 10:31:05 +0800
X-Gm-Features: Ac12FXyj_UMmVg7isRdshSVjB90FO-vOrAzFKlr8-K_BZH_EANWkLmSCqzZYyDY
Message-ID: <CANypQFZKnwafAFm2v5S_kbgr=p0UBBsmcSVsE2r65cayObaoiA@mail.gmail.com>
Subject: Re: [Discussion] Undocumented behavior of KVM_SET_PIT2 with count=0
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, pbonzini@redhat.com, linux-kernel@vger.kernel.org, 
	syzkaller@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hi Sean,

Thank you for the reply!

I will prepare the documentation patch and plan to submit it in the
next few days.

And thank you for the additional context on KVM_SET_LAPIC and
KVM_GET_LAPIC; it's very helpful to understand that other GET/SET
pairs might have similar fixups. I'll keep that in mind.

Thanks again,

Jiaming Zhang

