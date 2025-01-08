Return-Path: <kvm+bounces-34839-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B8C5A06586
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 20:43:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AC5E1646CC
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:43:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9F94202C42;
	Wed,  8 Jan 2025 19:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gFxaf0yF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF16126BF1
	for <kvm@vger.kernel.org>; Wed,  8 Jan 2025 19:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736365408; cv=none; b=CQa+ksPqwA0naBVzRXeUsUfGJcuvKVhAto1W7CyGQm/cYroNUgFUt+Qvry4XorLaE5go5e+AU12Tii1ShcD5gxL3hUFbw/9sBs+XdbO/W/Vbt3hZlp3T50HBRhmrAUp9i1yUPfjlpODctRkaelcu09OOa+mPnsHYr4yns4FitdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736365408; c=relaxed/simple;
	bh=2/4F7YnXXA+3lmgMdRPxIkoKD1QQbQzmhOuPzABrFjI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IKswDc6Gw3SQxpe6M5KLdOh6CQNTe5bUjI9q5AQPmEV6psD5CuGOvMJJiyKM8KWZ2PukUHZxnq1ja5FccR5Mmi2HwQayICOXlAH0p1/qlCyXkoxJJaVp23297PTDsah8kebjsu+Gx21lunR+VKvXgyT9n1zlXoduiWlZsyu3wZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gFxaf0yF; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3a7dfcd40fcso13745ab.1
        for <kvm@vger.kernel.org>; Wed, 08 Jan 2025 11:43:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736365406; x=1736970206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1BpZK2JMIpXkd+Vo4DCKxUs5wQJjq1ZCBPzNq3g3kvE=;
        b=gFxaf0yFLIqj9fwej5m4ludeX0FS0hGpI6j62IXs6t2A58Jimm5yjiD+7Z6J6P76Pt
         jJRDmbICDbZT6pslgK4gPqWxGDfUgwVDNCgfUI046kO9/u37D7KVvVxCCwp42VINez7Z
         /c8UQbcM6Lik0K1Ut3gWWsOpEeM0b7L2uvtjZCHEZLFJSg8Zw0v5SsniD2qjvhhM1TcW
         AUUtn4jmhNwOZsqFtjwHJ8kgB3CJm8xXWSdfmn2KKfHw/9BaFHEXd0zMDL9fvVRWcpq3
         P7FsBt4FgHxBhwtNkIh/Rae5lih8DIK0mcSdJwUWEsgxXGjxpa1gqCOg/2LicRppmTuH
         o1Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736365406; x=1736970206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1BpZK2JMIpXkd+Vo4DCKxUs5wQJjq1ZCBPzNq3g3kvE=;
        b=tVP2M+9F/O7xTU5Fd07Wog4NbSSXrgBriS/CGT4CDHFj/CVdnLI1fnb03ulnGspSFN
         InCg16gCdwqENo3grDNTtP59iYULdmQHat79llXWaNIcVrjbFf9dA0FgpUt5xEkQo9wE
         FJj4Op4vxTJmcd011wiPHf479yzsrV0mZSqE2pWQZ6h85/AzTd/J1Vbxvuefm2ECfz3v
         b4E2Obl6CrCnJoVQ64nisN9wvo3f/IiwfnAaGbJhD2FSzaVr9O3ImbgoRBCTtEmv+Gy2
         xG6pTrVpLXS0agz/fjR4ySLO6ZWvalXiQM7CJkXzeC2kGOAvSfttzD3quncn/W14UYkl
         DUeg==
X-Forwarded-Encrypted: i=1; AJvYcCVu2blQc6WtfQcQnYABgYss4h9o3cMmWlNwOV4alkWxRkQm0WJUKdpLTsoMi3cdjCX7G68=@vger.kernel.org
X-Gm-Message-State: AOJu0YyDoE9gGQmfsS0+Hv3ODW1VDolWedxyrWjopZrABxoZTcBPfuLh
	f/OWYCfWtm5FdL805lg+FMKUxoev5xxZMgbRB9nBNc6RgzgP7QHR4T8B8RyEI30e5UyujzJ+7Jb
	E6Uyf9fV49wRkk/+W/HZcch1kRs+d37nn/Cfl
X-Gm-Gg: ASbGncvzf9s/iabrEjtIsfgh208XP/C2wYHeeBORW8C2Qnbbouy54PrR3myWQbBzsk4
	VxRbFDKJHyRnCJ2/xeJArRwrecpyu/XlX6o9s
X-Google-Smtp-Source: AGHT+IHBRaEzGHEWeHTN+llPr7T2E9VrmAJSeXxQgbSuYiqPhft+pCyK18iCLPxrp1NE3S1KAplTrJI+HBLlXNOdOZ8=
X-Received: by 2002:a05:6e02:1988:b0:3a7:a468:69df with SMTP id
 e9e14a558f8ab-3ce48ac3821mr234855ab.3.1736365405597; Wed, 08 Jan 2025
 11:43:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241202120416.6054-4-bp@kernel.org> <Z1oR3qxjr8hHbTpN@google.com>
 <20241216173142.GDZ2Bj_uPBG3TTPYd_@fat_crate.local> <Z2B2oZ0VEtguyeDX@google.com>
 <20241230111456.GBZ3KAsLTrVs77UmxL@fat_crate.local> <Z35_34GTLUHJTfVQ@google.com>
 <20250108154901.GFZ36ebXAZMFZJ7D8t@fat_crate.local> <Z36zWVBOiBF4g-mW@google.com>
 <20250108181434.GGZ37AiioQkcYbqugO@fat_crate.local> <CALMp9eTwao7qWsmVTDgqW_KdjMKeRBYp1JpfN2Xyj+qVyLwHbA@mail.gmail.com>
 <20250108191447.GHZ37Op2mdA5Zu6aKM@fat_crate.local>
In-Reply-To: <20250108191447.GHZ37Op2mdA5Zu6aKM@fat_crate.local>
From: Jim Mattson <jmattson@google.com>
Date: Wed, 8 Jan 2025 11:43:14 -0800
X-Gm-Features: AbW1kvZdDUyyAFDiX8knId6g0dGtXe3QIX1nRBJgffiDIC8NmOkY5R8O5X5mCwQ
Message-ID: <CALMp9eS1H3pYOmQSE9qPFF2Pk2uvN_hUde=+5sZikBGjAjb+aw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] x86/bugs: KVM: Add support for SRSO_MSR_FIX
To: Borislav Petkov <bp@alien8.de>
Cc: Sean Christopherson <seanjc@google.com>, Borislav Petkov <bp@kernel.org>, X86 ML <x86@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, KVM <kvm@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 11:15=E2=80=AFAM Borislav Petkov <bp@alien8.de> wrot=
e:
>
> On Wed, Jan 08, 2025 at 10:37:57AM -0800, Jim Mattson wrote:
> > Surely, IBPB-on-VMexit is worse for performance than safe-RET?!?
>
> We don't need safe-RET with SRSO_USER_KERNEL_NO=3D1. And there's no safe-=
RET for
> virt only. So IBPB-on-VMEXIT is the next best thing. The good thing is, t=
hose
> machines have BpSpecReduce too so you won't be doing IBPB-on-VMEXIT eithe=
r but
> what we're talking about here - BpSpecReduce.

I'm suggesting that IBPB-on-VMexit is probably the *worst* thing. If
it weren't for BpSpecReduce, I would want safe-RET for virt only.
(Well, if it weren't for ASI, I would want that, anyway.)

> --
> Regards/Gruss,
>     Boris.
>
> https://people.kernel.org/tglx/notes-about-netiquette

