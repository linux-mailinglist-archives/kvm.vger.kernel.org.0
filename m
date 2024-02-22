Return-Path: <kvm+bounces-9428-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 071F4860075
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 19:09:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BC661F272F3
	for <lists+kvm@lfdr.de>; Thu, 22 Feb 2024 18:09:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30440157E7B;
	Thu, 22 Feb 2024 18:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hO5NC54s"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A00157E96
	for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 18:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708625323; cv=none; b=qvVWhf/GIJDBQI3E2xzSN2JKMz2JQUCBlKKux//mCk4cZ6IvWec2HJvOWrVk/q1siwiWUAGI4OIs7kt39fgy2w9eEus9VyBQHIDbPzZIPE8wSrrnubwUH1kfJJRU91Rl/cJ0lwzmp+yk6CnPqTt+PYs3Da0s114ChjZm2+65XTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708625323; c=relaxed/simple;
	bh=fy4liYg48gPvnH1kE6+qcZ1q7Bfu0MU2FGcOfrrT0bk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bNyhWmGZPsYiSVvWgHOnvp+6aXgwhtaghoB6j13E6jVSi/zpI6uhNqtGVYCuzGFMOeYcUwj4CRIY39dji208f0UnDONadiCvpsipLy7A2SVnMR+HjNmjFekzro1a4MHoOpwtTcMOQI6Gi7l69tYIY0gpMws2nEiMtKiZaov8A38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hO5NC54s; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708625320;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1CJoex4NkBFusthzZP64VSRgiIqDu+jmbcl9OVx+65A=;
	b=hO5NC54sIG8QvrNc5VY2jTYhxil+xWE3ysM/3ccy/aZGdz628LSrnYPJo15etDJBaUgw4g
	h9QjX9JfYezel8SnvVHdUXVtOwS6fjmfaxLumRgk7muJo451C9yr4bMyp+un62IkifF0rF
	+k+rkNiUQ0OMLLostP/Jm+wNTO7uF4Y=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-182-diTS3jccPIqacjJ4tnUZRA-1; Thu, 22 Feb 2024 13:08:39 -0500
X-MC-Unique: diTS3jccPIqacjJ4tnUZRA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-337a9795c5cso755f8f.2
        for <kvm@vger.kernel.org>; Thu, 22 Feb 2024 10:08:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708625318; x=1709230118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1CJoex4NkBFusthzZP64VSRgiIqDu+jmbcl9OVx+65A=;
        b=roUbWWfeDbl06WnKHJTufUXVI1voxkp3iF4FihG/wynIYQf5u4+wM+yK8ac+knmq15
         w9DMD2g7SBUyVl0OR2WYkIDDyk8yqZ8luq1H0rxoEi6bHb1gTYmmAM0yFPPuKHpLFo3p
         8tvmd1R5cpPjoqb7cx5JzYqVYqpbaSDDe8o7JQwUcYDibNAZt/YKLh8psFackZ3ijNJE
         Ahhw0gDIUzNNxiY5RO7IYCmZDa9DvPwDnMHiZzDq0X08UN5dheEFH6S5IF5v/z5NIOtP
         DoyxN8bLlZEOGOYaYXvP6mA8k2E3bgoyijRM7f36zJO7zt90T8du53v4l7hN6gDcqBIU
         nxVQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUwT5vtgJjKWsI/PKwxEahiueCsh5woW3mb3PiF5XJwImQf6mylsSMaxu83DZtppCNtLaQbZitFk6LjZMbvJgs4EQE
X-Gm-Message-State: AOJu0YyjuehHuTrL3b32JkBP5yotz64wM1Q7B4GQ+ilhGWVSeP/gwYMy
	aAg62rc3YF6MvAem7yPn+RtbgTRbxMZl3wFfMtBiqh0uLEhfsmzJ2k5H3kyTQFT4RRN+qiKR67k
	4eoGE6EXtMvOa+DjP8tsMhpskgHsp3uNhNLNUMbPZECUDdH4VaVNpOqolCTtXFR/i4slb7srgGX
	7vazlf4uAdftxjiUVUERarqu5e
X-Received: by 2002:a5d:55cb:0:b0:33d:8783:1e0e with SMTP id i11-20020a5d55cb000000b0033d87831e0emr2256751wrw.70.1708625318228;
        Thu, 22 Feb 2024 10:08:38 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGIUQS8ouwPxlaKQVxX9DLq/Mvc03qLzRTc8yg50FNvecbYAl2IuBempcl7FEGw8G6iGj5LeAgPO9VoiSe7Mgg=
X-Received: by 2002:a5d:55cb:0:b0:33d:8783:1e0e with SMTP id
 i11-20020a5d55cb000000b0033d87831e0emr2256741wrw.70.1708625317940; Thu, 22
 Feb 2024 10:08:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240131230902.1867092-1-pbonzini@redhat.com> <2b5e6d68-007e-48bd-be61-9a354be2ccbf@intel.com>
 <CABgObfa_7ZAq1Kb9G=ehkzHfc5if3wnFi-kj3MZLE3oYLrArdQ@mail.gmail.com>
 <CABgObfbetwO=4whrCE+cFfCPJa0nsK=h6sQAaoamJH=UqaJqTg@mail.gmail.com>
 <CABgObfbUcG5NyKhLOnihWKNVM0OZ7zb9R=ADzq7mjbyOCg3tUw@mail.gmail.com>
 <eefbce80-18c5-42e7-8cde-3a352d5811de@intel.com> <CABgObfY=3msvJ2M-gHMqawcoaW5CDVDVxCO0jWi+6wrcrsEtAw@mail.gmail.com>
 <9c4ee2ca-007d-42f3-b23d-c8e67a103ad8@intel.com>
In-Reply-To: <9c4ee2ca-007d-42f3-b23d-c8e67a103ad8@intel.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 22 Feb 2024 19:08:25 +0100
Message-ID: <CABgObfYttER8yZBTReO+Cd5VqQCpEY9UdHH5E8BKuA1+2CsimA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] x86/cpu: fix invalid MTRR mask values for SEV or TME
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	Zixi Chen <zixchen@redhat.com>, Adam Dunlap <acdunlap@google.com>, 
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Xiaoyao Li <xiaoyao.li@intel.com>, 
	Kai Huang <kai.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>, x86@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 22, 2024 at 7:07=E2=80=AFPM Dave Hansen <dave.hansen@intel.com>=
 wrote:
> > Ping, in the end are we applying these patches for either 6.8 or 6.9?
>
> Let me poke at them and see if we can stick them in x86/urgent early
> next week.  They do fix an actual bug that's biting people, right?

Yes, I have gotten reports of {Sapphire,Emerald} Rapids machines that
don't boot at all without either these patches or
"disable_mtrr_cleanup".

Paolo


