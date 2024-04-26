Return-Path: <kvm+bounces-16043-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D2E78B350C
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 12:14:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FA661C21B86
	for <lists+kvm@lfdr.de>; Fri, 26 Apr 2024 10:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA5E3143C7A;
	Fri, 26 Apr 2024 10:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nc9Zjp7K"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96269142E68
	for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 10:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714126434; cv=none; b=sCRlS0YhVAqKNp1BPt0bM4yuL0P+cH/F1AB2X7uflo5hVhf0qFaFKN7oZhhenP+kwURg/cfq29YbdqvY91k05vPDeS710NGlNEx5fS+Nk2EjbK3DvL3NnZ8Y+R8BilqKELYjOxfsPUkOOpxenQ9y9W0q1kRk9EW+o6w5u8+xkoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714126434; c=relaxed/simple;
	bh=24kJE+8eVc4ogyRndMk8jZL6OfEUwakFZ92WxqX0NX4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s59bvOHzJeJy4qBXNiF+DXgFCpIoTd0BpIM4T0XL8kfFmNxDVSRJZ3bESOvLSy3KNLX8k3q7oZguLrQ1vuYbbpTnvbH5iY0mGXNZiFR+sPgGmr3cNwE9TMjPRjEdJ6aw+9k8dWVCdgEgN1h8ti3y97AKdvL3fudEH/72cmpxhy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nc9Zjp7K; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-434ffc2b520so145571cf.0
        for <kvm@vger.kernel.org>; Fri, 26 Apr 2024 03:13:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714126432; x=1714731232; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J/LwG0GvPr9JWPbmW+g/6YHRZg+/MP5hxVTSkmO9J3A=;
        b=nc9Zjp7KEi7GifK5+kHhBitePNyV57j3EF376yI7+L1kSzLORc7SqsJtWfLJm0/9p4
         710HrGm+SsjrBqmr9KBiDL+pSJyerwp4v5rTSW5meWDdgv6kABoFFOfYWccQahrz67Tb
         ZN5xb4M2knfSGnFyX/QY7C++mS6F2PCXctYzK0q7Ffx9LJ9tEHicbZ9cT4zHfBAzLl8/
         LxG0ualS0gqM6n1GtPZQN7IVtw/yIzNMzmeHTvRx6MhYE0j6W3txybUOYDO5amzMEeA3
         Q3+hbR9De/eZ2utXaPGDTINvSNmPFLyecOOPS1KL2Ctub76ckHXHD0HNi0qILF5INxKV
         nb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714126432; x=1714731232;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J/LwG0GvPr9JWPbmW+g/6YHRZg+/MP5hxVTSkmO9J3A=;
        b=TDEFp5YaGQe+Sih/2YJB6j7nkm1zcJUhl4wOnjVowFu6LN2tRNRz+Xa5kK5vRLoQzb
         NFysGwdcpRrtDKwFLgIDuT5kDinLw3sSLQyiVzmZthHXBfurKBacQIVUu75VOmNze2EX
         ouYDWfysRLzpvzqYQGq8dsUaxaELKaG18i/eGlpcgKWFHvVVXp6+0wGXyNCq6qZNse9w
         +rjFRlhDbMtti7uuZtEVPHDpL8XDDbs5FZwwHlZyuk27TQ1zFVyx2QHV0ejxYYotybpD
         h6ymKV5k0uhRfFBU6zWH7wPYd7OCYWAyoWlENGarDZsMhb2ObnBc6OPQHbK0GYCsaV5f
         Ob8g==
X-Forwarded-Encrypted: i=1; AJvYcCXWB95LWl+eWxKRs3+OmoA0D7DXyXEx4zpihQqN/De9JGFOLJVdZdWYfXCz2eF89sPN7Q+fzPMOrICIbVrP39RK7AVA
X-Gm-Message-State: AOJu0Yz2+FujrYR6dS9cT5mTo55tS+4p7+jUxwbLbcH4GuTSdHrrw8vA
	AdGWeYSD8gneXK7cc7XTPibX2xxjedMam+dNVxbXZ+WQ4M+XWJeVrVrVdRtxMdNR89lFEerEKWo
	xzcVIMhbCHczSKEff287HITn5mwZ1TtQfbjCH
X-Google-Smtp-Source: AGHT+IHi71L9eDaKtkraqMxL4gEt3ivysSLcXt8Ec3WGJM26HKGhUUS6XNYPVxaBjwiR90EFu0IelSE7k4TA7wxOP9M=
X-Received: by 2002:ac8:5809:0:b0:437:8ba1:ee1 with SMTP id
 g9-20020ac85809000000b004378ba10ee1mr225334qtg.5.1714126432301; Fri, 26 Apr
 2024 03:13:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240415-kvm-selftests-no-sudo-v1-1-95153ad5f470@google.com> <Ziri424B_R9GXA9Q@google.com>
In-Reply-To: <Ziri424B_R9GXA9Q@google.com>
From: Brendan Jackman <jackmanb@google.com>
Date: Fri, 26 Apr 2024 12:13:38 +0200
Message-ID: <CA+i-1C1SoXugro50OO3BJx17Ea4VtmGNZ29YcatHVAQ3YO+sKA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Avoid assuming "sudo" exists
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 26 Apr 2024 at 01:10, Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Apr 15, 2024, Brendan Jackman wrote:
[...]
> > +     function maybe_sudo () {
>
> Any objection to do_sudo instead of maybe_sudo?  I can fixup when applying if
> that works for you.

Sounds good to me :)

