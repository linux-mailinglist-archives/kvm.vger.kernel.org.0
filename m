Return-Path: <kvm+bounces-37363-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 24621A295F3
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 17:13:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D9907A2009
	for <lists+kvm@lfdr.de>; Wed,  5 Feb 2025 16:12:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F48E19F489;
	Wed,  5 Feb 2025 16:13:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZgCyrpGr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBAD194094
	for <kvm@vger.kernel.org>; Wed,  5 Feb 2025 16:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738771983; cv=none; b=pT6cKi9ovMzMgAwBiWxd9ObB22HBKBqOlWv/94wq5SH5sE2o7GBoQrYhnsb7rekrwaV9WvsAAuHkFYzEMGaPhScNtxw6eJ7IB3QCtxZ/hxGkKADVxqo9OH75MiItVvhTQd6uPcm7/gjBk/e6NpjW681WjyqxY1H5hFHUv50wEOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738771983; c=relaxed/simple;
	bh=NvW0n/m0bGod2EuBRkN0yx2e0anmBtqXkeHXnsfUxZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aOJ++TixNi5MavuNoOWCMUKm6sY5PjOiX9/HJFKgJ/w9m7SBYDz85v5uA1RQQBauEePdCInnH4Zz5+m026GF503zd5BrbuNysqSWGsRc55RP8qK27Ca81UrZBKpyrVECZDL4T+9xX+S+8PJWTwxE61XeSli/Xy145FJL+6DAOm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZgCyrpGr; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-ab6fb1851d4so194736866b.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 08:13:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1738771980; x=1739376780; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mFRJZqny0JCLWGQlrfCbtC+cNwhgdx9Xm0sW46CJJJ8=;
        b=ZgCyrpGriYz309S/IKeZDSAaUoRg08FcGg8fdh0ltHI1huW2d44syXnmBv7nN7jQP5
         t5+eTqQdOeygnvP3le5DeJKG84HUe+1T8geDmvsIkZjEKoD9K2hIXE8gQ6m/OI4rUxOu
         RZmotbcF/E4pY8gdhrsyOEvBo5vFjp//vKYII=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738771980; x=1739376780;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mFRJZqny0JCLWGQlrfCbtC+cNwhgdx9Xm0sW46CJJJ8=;
        b=pJEfRbFyoz761AGxSpXJ42Hu942k0FvdcfUs4klTPY8vFjoestFr0Cz/7eK9vIZGY2
         jsJQqQ/UiX7qHKZw+ykBUCjs0E4vg+nIJ6Fs9a7RFyS+/+6F5foanbjL9uJgKAphFZTA
         ZRqIbDyV+gnhGfjlCIpa7pnhquoUoGQy/AZB7otlrWsXhU+SeQZgfMXdImgSqj0Apy3R
         6CK3C05iQr5DuvYMylWVPl0whQdalWgzs75+zL42MT7fCPuK0Dh0iFmrv7Z7C2moK4Ql
         KOZ7M+UKwgxFcJnkuY51abABz4C7mJWcVIT7xoi5BvTHfoHR0GP2Oem5iBxkQrHljBUc
         3ymg==
X-Forwarded-Encrypted: i=1; AJvYcCVZrPJGkEbhZPL90q8pjFOzDYvnCrHIg/+aETSs6qijjhwQSGnjfM+aJrIxNvlcnAfAots=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+e1h4oV14Cb2mkk76ARexJt95LLW8xii4JasrReII4URftlnE
	sg2FDpT4ufKvB3sk9YLhIz0Q70I4YckWLD31H0B32xWnBCB7SG+qyc8AKLbLW2IHw8XrRBdKmKG
	hLMw=
X-Gm-Gg: ASbGncsg36Nul7usYfUSgw5LcCTNpAt3lO5H8HVrkFJO+d6iZmOF0fX+wawcbeNR89+
	xYHBNqWfR4uRViqU5o29QzKbpmvlBdot8glL+Op+LQ26l87TJcTDVAZfqcPZtdqGzobUrhFWFCy
	zg5p1bW6yP7TLrzDTwVtFLuj5iJcoJcU1pF8WqWyJ9Hu1v4TuImJkNC4vXVQRngHXt0hUhy51Ll
	Ls9S1pZhqfBALDpQogbA1yPOL7Sx2YS05wJ1o6NpYpLMCbN9Vfc2kjBHCnyutf5HONAwZE6PBcR
	AAa7Mo96djTaLLKv8WurnGGxFPuZoQiRb4J6WRXg+hpOHmoW7wX1+0co27U1jzgJ2g==
X-Google-Smtp-Source: AGHT+IFsXcu6VCSmtwFUqjtbUXR/Cjy5kuj4AkK2E8me9Xj5CqoOtoVDjPO8OHBVW8qZWzr4mRzu/Q==
X-Received: by 2002:a17:907:3f86:b0:ab7:b82:899 with SMTP id a640c23a62f3a-ab76e1e031emr920966b.22.1738771979626;
        Wed, 05 Feb 2025 08:12:59 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a3174esm1131697566b.132.2025.02.05.08.12.58
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 08:12:59 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5d9837f201aso2092823a12.0
        for <kvm@vger.kernel.org>; Wed, 05 Feb 2025 08:12:58 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWLOyq2bOT5o1qg5uDL31ox4pXS6vBcryOSnLoAjVIX4iXxn3O+efhP3dlDcC7AcBNL+Xc=@vger.kernel.org
X-Received: by 2002:a17:907:7244:b0:ab2:c0b0:3109 with SMTP id
 a640c23a62f3a-ab76e1dcd41mr953766b.21.1738771978576; Wed, 05 Feb 2025
 08:12:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250124163741.101568-1-pbonzini@redhat.com> <CAHk-=wg4Wm4x9GoUk6M8BhLsrhLj4+n8jA2Kg8XUQF=kxgNL9g@mail.gmail.com>
 <20250126142034.GA28135@redhat.com> <CAHk-=wiOSyfW3sgccrfVtanZGUSnjFidSbaP3tg9wapydb-u6g@mail.gmail.com>
 <20250126185354.GB28135@redhat.com> <CAHk-=wiA7wzJ9TLMbC6vfer+0F6S91XghxrdKGawO6uMQCfjtQ@mail.gmail.com>
 <20250127140947.GA22160@redhat.com> <CABgObfaar9uOx7t6vR0pqk6gU-yNOHX3=R1UHY4mbVwRX_wPkA@mail.gmail.com>
 <20250204-liehen-einmal-af13a3c66a61@brauner> <CABgObfaBizrwP6mh82U20Y0h9OwYa6OFn7QBspcGKak2r+5kUw@mail.gmail.com>
 <20250205-bauhof-fraktionslos-b1bedfe50db2@brauner>
In-Reply-To: <20250205-bauhof-fraktionslos-b1bedfe50db2@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 5 Feb 2025 08:12:42 -0800
X-Gmail-Original-Message-ID: <CAHk-=who0D=MKDijLTAtVZ=x8RMSQZg4reHiprgQKxDHsTGeUQ@mail.gmail.com>
X-Gm-Features: AWEUYZlP303UwXWRV-sLehCgNaqTR8x43_I3TsNboNYECfXum8T1k2bT3JbeqGM
Message-ID: <CAHk-=who0D=MKDijLTAtVZ=x8RMSQZg4reHiprgQKxDHsTGeUQ@mail.gmail.com>
Subject: Re: [GIT PULL] KVM changes for Linux 6.14
To: Christian Brauner <brauner@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Oleg Nesterov <oleg@redhat.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org, 
	kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 5 Feb 2025 at 03:49, Christian Brauner <brauner@kernel.org> wrote:
>
>
> Btw, checking whether single-threaded this can be simplified.
> It should be sufficient to do:
>
> stat("/proc/self/task", &st);
> if ((st->st_nlink - 2) == 1)
>         // single threaded
>
> since procfs adds the number of tasks to st_nlink

I'd be careful about depending on st_nlink on strange filesystems,
particularly for directories. And /proc is stranger than most.

So the above may happen to work, but I'm not convinced it always has
had that st_nlink thing. We do it because some tools do end up looking
at n_link to prune recursive directory traversal.

But *most* such tools also know that st_nlink < 2 is special and might
mean "don't know" (because not all filesystems actually count
directory links the way traditional Unix filesystems do).

So relying on /proc acting "normal" seems fragile.

              Linus

