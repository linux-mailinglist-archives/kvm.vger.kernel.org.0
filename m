Return-Path: <kvm+bounces-11084-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29144872BC8
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 01:30:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D91CB287990
	for <lists+kvm@lfdr.de>; Wed,  6 Mar 2024 00:29:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24CC8DDBE;
	Wed,  6 Mar 2024 00:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZR6TeWyz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2CAC79C1
	for <kvm@vger.kernel.org>; Wed,  6 Mar 2024 00:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709684987; cv=none; b=khDmq9nE0h0z4toy0xZTeROaYI/s0Ufv6L8T29KSv6OF8IGNgvu5geydwOFWlo5ZgHNWkOIif+vDk/Q18mOuUKV7rudh7VGNDdOSS06m3HMHE2aPuo/bQ6B3rsuZYY8OtLpkHAiG4P6CyEUfbX1F1XvAe3JzIBorKJKnPeYGR5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709684987; c=relaxed/simple;
	bh=3TGXNtbSnGqUmrRKGS4Vxyjh7otthNXIvoCLbmKVZJo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QX287vTwFbb7r6JaDD36vC9EFC1R5tBPFYCTiYcQ1OYgmWLLp3x5QOKUGTWwC8WeZaKkdWrAYYAYksbZ3jeko/bFDZqPA0lmDdsH2IywJXjrcbyH9PH/5a5eqv22lGVpUVGghw3/lDW6baNIzBjUtRSqf+fVUIVRzTwIF0WHA9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZR6TeWyz; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b269686aso9351235276.1
        for <kvm@vger.kernel.org>; Tue, 05 Mar 2024 16:29:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709684984; x=1710289784; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xSB6RmxldMWGsQwbWc2w1sJWlx2GAlKRYfswIj2uSas=;
        b=ZR6TeWyzKG5mLn3oMZfBsFNK5HN82QByxp6RoHYJqxfk6KgS3YdwGsr4GSnd3fU7Ii
         e8Lf9y+l+OcelcjWqAPE5+YCzk19fj0sCK/YGYz5ttIIo9x3FTtQ4o2OYxXXEQzu9rBx
         kgB+RIKw5KgYuKGKKwMO5/pP/zgDgPxHfwCm6tZfQlbVuAqSL5DdnWIEmATCIE6hoitC
         irEmkUO5pdi0Q8c5vxEal8nV6BXu6XyV1K4mLp7V1ociUnUGHn34TvsSxip/2B3ZxIec
         3UX8Etjayt0ljbPswzBiw/cVdeLY5IphgRFFsFu+7VR5ty884zmDY0Yy6GcrdFvRPL3g
         QqDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709684984; x=1710289784;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xSB6RmxldMWGsQwbWc2w1sJWlx2GAlKRYfswIj2uSas=;
        b=pQqSgSeNTk9zM1Xv1nBk+hK3QmVfLbmJI28NNPFoxD5jrqC+T1qynuLzm5nbhDZS+b
         sXDokWUBqNyOetKS5Fa5g23V8rEHmdlv5Y+lwOCLag2ZsPM6ZHrRmV7KXKOyR9NSH7Y+
         q6YuFSxML+IKmvDEYb3Gx+XsZ2ALNUKJ63iNaIfwDd/6E09lQ7nAKoIpLF5zPKtIVtrQ
         P6BObO7fmTJIV1BX5IkXetPeE50mybk/lo9gMmn6BySpgWLDjO4Oko2wr0I9FaKOhQ3Y
         sY6EoN7KnZ8pXx2ucyzeSCp6JBSyfLXvT8vvagP2gIRhcmNjlqLrCDFbsbYmIS3pzDJO
         Ys1A==
X-Forwarded-Encrypted: i=1; AJvYcCX8PeRS+be6ShrqeHzZfOw8HqTigMeBiZkZg3UfKJKq2BgtymUAx0fgMYgA1lfD7pljXwBSz2xWBMyeeY+t+SyuKx3j
X-Gm-Message-State: AOJu0YwxKjRI3wfUTNk//kBr7x3QQTfkP0lzaLMY96dMHyJ8xpPoBe2G
	CPdVpdgninKfWEarYsW+e32puTJdhGkvY/wMsmtq3rIXRJPvXSMm5imzxKCYa+OvpYXZTP6Tfek
	egw==
X-Google-Smtp-Source: AGHT+IHq9WdopNkqHirkj1ZNnJCotQ7fHu7uj+p8bztDqe+dPoiGmxwesLZ6INERbKQTG2EJNzDhuuJ1Pgk=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:dc4c:0:b0:dc6:d1d7:d03e with SMTP id
 y73-20020a25dc4c000000b00dc6d1d7d03emr589896ybe.8.1709684983800; Tue, 05 Mar
 2024 16:29:43 -0800 (PST)
Date: Tue,  5 Mar 2024 16:29:35 -0800
In-Reply-To: <20240227015716.27284-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227015716.27284-1-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <170967423579.413845.13663361620906682493.b4-ty@google.com>
Subject: Re: [PATCH 1/1] KVM: selftests: close the memfd in some gmem tests
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Dongli Zhang <dongli.zhang@oracle.com>
Cc: linux-kernel@vger.kernel.org, pbonzini@redhat.com, shuah@kernel.org
Content-Type: text/plain; charset="utf-8"

On Mon, 26 Feb 2024 17:57:16 -0800, Dongli Zhang wrote:
> Add the missing close(fd) in guest_memfd_test.c and
> private_mem_conversions_test.c.

Applied to kvm-x86 selftests, with a massaged changelog.  Thanks!

[1/1] KVM: selftests: Explicitly close guest_memfd files in some gmem tests
      https://github.com/kvm-x86/linux/commit/e9da6f08edb0

--
https://github.com/kvm-x86/linux/tree/next

