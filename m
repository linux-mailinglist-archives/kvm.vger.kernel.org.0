Return-Path: <kvm+bounces-37007-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 335B9A24397
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 21:00:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F1D81663FC
	for <lists+kvm@lfdr.de>; Fri, 31 Jan 2025 20:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA7261F3D3A;
	Fri, 31 Jan 2025 20:00:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dPlLFIfM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 384091E571A
	for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 20:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738353619; cv=none; b=JuSvE7Ra201rAMzVi9CkjbTu10JLA/JTtps+YP6ZlFEghVmq4GTua7Sh5OFXnXMD3isYopn8aNP8aOusGAIDUlXyYrFuPv6xJCJEqt3u9Gg+efnX9UylWM3wbnCNx3SOAUVFnVaGlnenBROhj/KVlCn6sE27ztmt/a03lpFMAMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738353619; c=relaxed/simple;
	bh=mESJj9WNZAGhoP88PwXyk6SgSBIq1RXBtiH16frMzTc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nsR8YXCFiFM7+az30j7lNWXP0rgFr+xN8BG8WA1YMO7hwSb/h/0L8tRu7J8XQ5FWaS4auHs5ucXfqgID4hQThWiLopfoEZT7nIeo6ymjZqFLyfbA/fGcKnxPxU7kUt/w6GCFHNl63ORFqnB/of/85AiyhBU/X+ltv5v0nTFdLR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dPlLFIfM; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-ab698eae2d9so469255066b.0
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 12:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1738353615; x=1738958415; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1VEMyzp2lsoEGf8wTQK/Tt97K6OMqjZreNFMoOiXZ5E=;
        b=dPlLFIfM+G/lEDPwPrinoJPSTGpf/quSRFWlHZwLTfO2iIdxA1VWUpZebWr1yuf6iz
         BdarU7DO0Hb/S0/QgTkLF6DNa6P/F7NxRb4FSHpoGRZw37Dc9Ya+o+M6mn6SCk0kcGCH
         7L39NJQjtPl8SwHIqLDrbq7guSpa8Iyio6i90=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738353615; x=1738958415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1VEMyzp2lsoEGf8wTQK/Tt97K6OMqjZreNFMoOiXZ5E=;
        b=UkBVXGW1dg4xSrWWlhXUFslCK5y/AVeW1+HWYVzHbfVirNpD0AovOYfMRjh2kBKFBY
         hdR/LYbxV8hVj/VgRU4lnoVHqGsh5eL0u+y8xqy/YdmNuNH2ckTp0tXBdxK/tb36n6MK
         1YNlYCwM9XR6VF/ZbBr//N9c98PRIRw48qj70SnI4Pn7pJFKXc0lkwME8ms2VotUWpSK
         mM3vnj8pUW48b7BJ2KAJOEqWxoSy5QwRHNqQzivTZAzfvaFiLlnYJxod0X7Wj+UPIZO7
         F8LR4pDErJzvhNP+c+PrgpGUYVJDTqVIWjD/Dl3JKzq5vEsRLYcvBg5fXWXKklq97nMk
         OrSw==
X-Forwarded-Encrypted: i=1; AJvYcCXyfVY92FsjefPABiAZR+Sgt+zpv98uGMb0H5FFkeZBfrDtcpiTe2POmWATuxw+Apkqh8U=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqkL5y+qhSodr4AXex0TwUGEA7MAxr3DlprDupclpq6t0JxyQZ
	/bMNHs4wvK5IwkDfFCtNyvhEP0kQAFlDGpwIZQ7dUWrPMjrq6T7qjTWRJBEZI01A2dqomQwmxTT
	rLkI=
X-Gm-Gg: ASbGncv/wLCee/w5bKnvKWDo1XBaY4TNRAha8D0Sqjl2shqKN7M7d24dM+Gmjz3VGlQ
	WxMteXhAagg0KebkPBn0zMwv1DlZyeLxrrCiNHtstfdVXuh7LpNYRmVv5jTLR1H6dnf3po170Wl
	lS1AEkIESi7CdK0/jkr/o8ZOLRWHibX0Kkzy7O+2UPsgxz756HuDP8ntRCRnYzIfv8F4vMzAp6c
	0OEck4Q8ffDtUVCxPrUgMFeoeYEtt3LORagidq1YTxwnyQ+qAMzraJXNRZ7YwjH0HlaTXHcACv3
	ylGqzFUESwYMmuOGmZ14T7G3TAN9EwQR9X0pk686FCxtRYubHViVh+KZfelppeiqqQ==
X-Google-Smtp-Source: AGHT+IFYYcqcut7EQ0yJ8JSjKkm44L3MTzm3ZbO6HysdU0q2m82fSAKQ6eUvHukfn0DrloPeyfqnow==
X-Received: by 2002:a17:907:3f20:b0:ab6:ddbc:1488 with SMTP id a640c23a62f3a-ab6ddbc1afamr926274566b.23.1738353613803;
        Fri, 31 Jan 2025 12:00:13 -0800 (PST)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e47cf48esm344751966b.50.2025.01.31.12.00.12
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jan 2025 12:00:12 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d3bdccba49so3940660a12.1
        for <kvm@vger.kernel.org>; Fri, 31 Jan 2025 12:00:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVU5W644sAOGOFFBQqF0ya2prUXFQJfkqWFJQXpQ3gDoMh5EEm/cPBAhob8YRC15ANGnAQ=@vger.kernel.org
X-Received: by 2002:a05:6402:2709:b0:5da:1448:43f5 with SMTP id
 4fb4d7f45d1cf-5dc5effcc33mr12325224a12.31.1738353612239; Fri, 31 Jan 2025
 12:00:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1731684329.git.josef@toxicpanda.com> <9035b82cff08a3801cef3d06bbf2778b2e5a4dba.1731684329.git.josef@toxicpanda.com>
 <20250131121703.1e4d00a7.alex.williamson@redhat.com>
In-Reply-To: <20250131121703.1e4d00a7.alex.williamson@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 31 Jan 2025 11:59:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=wjMPZ7htPTzxtF52-ZPShfFOQ4R-pHVxLO+pfOW5avC4Q@mail.gmail.com>
X-Gm-Features: AWEUYZmJHVy_un_wj0EXjvnXlSLyiKtpaVCBTRVD7w7Khb3Vui_AFXvwFXKGqO4
Message-ID: <CAHk-=wjMPZ7htPTzxtF52-ZPShfFOQ4R-pHVxLO+pfOW5avC4Q@mail.gmail.com>
Subject: Re: [REGRESSION] Re: [PATCH v8 15/19] mm: don't allow huge faults for
 files with pre content watches
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-fsdevel@vger.kernel.org, 
	jack@suse.cz, amir73il@gmail.com, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	linux-xfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-mm@kvack.org, 
	linux-ext4@vger.kernel.org, Peter Xu <peterx@redhat.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Jan 2025 at 11:17, Alex Williamson
<alex.williamson@redhat.com> wrote:
>
> 20bf82a898b6 ("mm: don't allow huge faults for files with pre content watches")
>
> This breaks huge_fault support for PFNMAPs that was recently added in
> v6.12 and is used by vfio-pci to fault device memory using PMD and PUD
> order mappings.

Surely only for content watches?

Which shouldn't be a valid situation *anyway*.

IOW, there must be some unrelated bug somewhere: either somebody is
allowed to set a pre-content match on a special device.

That should be disabled by the whole

        /*
         * If there are permission event watchers but no pre-content event
         * watchers, set FMODE_NONOTIFY | FMODE_NONOTIFY_PERM to indicate that.
         */

thing in file_set_fsnotify_mode() which only allows regular files and
directories to be notified on.

Or, alternatively, that check for huge-fault disabling is just
checking the wrong bits.

Or - quite possibly - I am missing something obvious?

             Linus

