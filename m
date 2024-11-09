Return-Path: <kvm+bounces-31333-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3A69C28C8
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 01:24:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A28332833E1
	for <lists+kvm@lfdr.de>; Sat,  9 Nov 2024 00:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3CFD2FB;
	Sat,  9 Nov 2024 00:24:12 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E9C4C80;
	Sat,  9 Nov 2024 00:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731111851; cv=none; b=VphfaLtywBwfzYNYcMU/mVbV4ga5lR9a1ODsYdbwcPm3dvZPXw+00cs83Kb9RjJMondtOYyKshmseLwQVJAzu2PnCLr7QyKfwtS8KCi9OpBqrazw6ekh96ujeAb7CpqTPcDN9sC7MivvMF1GLRpHcfp8LN76hqIKUEo5BYEwVGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731111851; c=relaxed/simple;
	bh=YPFrtXH+9NieqIbNZwyhsWrxoB3+ak259oIV7C/dsrk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZVi8JAKyVo88Pt+5XoHfol/DH3SVHQ4eSmvU3PvvO6aF3HMypwA2PnigzIf29va/NUG0RZ1I1zkp/Qk7HMJWQSWyHzl0u0Yn20c94mrYLRxRPzFDmpBTLdf5GL+qQyFMj6+Uj9vFKoI9uuznHM8So2AZtVJtAvI5SN+FNLZDuuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e290e857d56so2770604276.1;
        Fri, 08 Nov 2024 16:24:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731111849; x=1731716649;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ijlMfgwKMgrnOmGLp1OVZB5zzXuB40nosRd/AylziMQ=;
        b=laFDBhV1djvUtAZdzIb/B1QG9kEmmXFd7nIsjelP7g4rHCVm6Ltf/Bq2bTdFWROY1w
         7lfkN4nSjfLKZJ7nSBHkl9obwdFCxeBgox4nVLpQscorAEnDupKtMPq3NU8VysFcZPS0
         zJ4PM3kwEuJ79rhJkc6fAUuFqt91S0Mrva+V1LN96q6wWGCKtrHVa1QNw+OpGC2x+IbL
         C9f9twY0/AO7DIOaEmuGTjI08iSdPIBv0+L2OUuz/F95pTWV4o80HfKsFoy3j7FPLIu6
         GxI0FFv0zKDeswapNS4YD4vKcTB989ggMq0IQzvKj/jy1IMAOIAycX5+Rhqf4uVnESo+
         RL6A==
X-Forwarded-Encrypted: i=1; AJvYcCUUQFtb0qM9yt4dchhLkiH0l723opEY2KnxGWyOhuJLWs+uordqIqGqt0TNce4iP9/f0hcs72Rswkw4T4rT@vger.kernel.org, AJvYcCViW7K0P+Uvn1E1dClOl2xatPTOwU7XfZcnkzjwv8LI4stjRKFPX2mjnR0ZNqaBOEECXxQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YxvIY7Sg3lllVIiQKMBc/pdx3bXwPYoZypjhu8llc2ESjFnEkAB
	H6tIGjz0wW2wnEaBPu1AxEOdlJJZwkjGzKUPBLLOGc/s1vcyjLqyp0g32n16
X-Google-Smtp-Source: AGHT+IHb4KRXcvo+XgWnBAdoYiT3BqiirnytI5YjQfEbJbCdDB0XlQXc64zMKg/eoFusyO+mzF2DDQ==
X-Received: by 2002:a05:6902:2b8c:b0:e30:bf62:c3da with SMTP id 3f1490d57ef6-e337f82c7bfmr5707020276.4.1731111849032;
        Fri, 08 Nov 2024 16:24:09 -0800 (PST)
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com. [209.85.219.170])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e336f1ba68dsm950021276.48.2024.11.08.16.24.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2024 16:24:08 -0800 (PST)
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e30eca40c44so2822000276.2;
        Fri, 08 Nov 2024 16:24:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUymQ7Nb3RYBaFmWTytEzaM9kDMXPawImwzdmrrvm8Qsm+MJKkbbk76Y2gIfJVWG1XfI6nV8YbatdWA1WH4@vger.kernel.org, AJvYcCXwkcwB0NVqVWqDb9qPfWwh8x6Kc+lbAAZbPme9lA2au3AgdvpgeB0JY6oM9escTUZ2AaE=@vger.kernel.org
X-Received: by 2002:a05:690c:6710:b0:6e3:1e5d:fe2 with SMTP id
 00721157ae682-6eadde3b221mr57714937b3.31.1731111848470; Fri, 08 Nov 2024
 16:24:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241108130737.126567-1-pbonzini@redhat.com> <Zy5CGpgRu8q7nrsx@slm.duckdns.org>
In-Reply-To: <Zy5CGpgRu8q7nrsx@slm.duckdns.org>
From: Luca Boccassi <bluca@debian.org>
Date: Sat, 9 Nov 2024 00:23:57 +0000
X-Gmail-Original-Message-ID: <CAMw=ZnSVAFMOs3dh5GpyQXJ9KVVmtd7zAT9B8RkZCCtF+M6J8g@mail.gmail.com>
Message-ID: <CAMw=ZnSVAFMOs3dh5GpyQXJ9KVVmtd7zAT9B8RkZCCtF+M6J8g@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: switch hugepage recovery thread to vhost_task
To: Tejun Heo <tj@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
	michael.christie@oracle.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 8 Nov 2024 at 16:53, Tejun Heo <tj@kernel.org> wrote:
>
> On Fri, Nov 08, 2024 at 08:07:37AM -0500, Paolo Bonzini wrote:
> ...
> > Since the worker kthread is tied to a user process, it's better if
> > it behaves similarly to user tasks as much as possible, including
> > being able to send SIGSTOP and SIGCONT.  In fact, vhost_task is all
> > that kvm_vm_create_worker_thread() wanted to be and more: not only it
> > inherits the userspace process's cgroups, it has other niceties like
> > being parented properly in the process tree.  Use it instead of the
> > homegrown alternative.
>
> Didn't about vhost_task. That looks perfect. From cgroup POV:
>
>   Acked-by: Tejun Heo <tj@kernel.org>
>
> Thanks.

Thanks, tested on my machine by applying it to kernel 6.11.5 and can
confirm the issues are gone, freezing the cgroup works and everything
else too.

Could you please CC stable so that it can get backported?

Tested-by: Luca Boccassi <bluca@debian.org>

