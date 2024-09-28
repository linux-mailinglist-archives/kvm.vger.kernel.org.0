Return-Path: <kvm+bounces-27644-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 51E24989072
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 18:30:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 115B3282014
	for <lists+kvm@lfdr.de>; Sat, 28 Sep 2024 16:30:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C615F143879;
	Sat, 28 Sep 2024 16:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YwH2hECF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07ED21758F
	for <kvm@vger.kernel.org>; Sat, 28 Sep 2024 16:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727541039; cv=none; b=tdkReDfICZwxIanVzjhnvojDSb+erynWuwGyuvgXbKo7tujOIN2Ly5hDxSdyXV70MiPgHSBgg7U2HtnTrtbCpqft3RNUZCjy25gMOGWR7s+JOARNcHZgAxNH/WOSx86Ez7vdwu5DTDKkpsWkl6cdXRKfhSClwsQihfWVNYovP58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727541039; c=relaxed/simple;
	bh=9v5LeD/VBpgdLkqY4q80UQk5vs5hnLeoXnybcXxouKI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AtCviU6lYy4+c0qocwtXeGhAK/4oHhpzIPSZIl0MrdXYkxjpbvIIlLsCU6/fXHERP9YWcOnoYX8qrRQZvPhBUUw94yksSfgneQSwA+p6mfeDpqTM4qx3V4y21K83C1IxCjPQUmQP7R52bdTQ5SC66YE5PqjoQ35uc0NQa3wqHgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YwH2hECF; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a90349aa7e5so445210966b.0
        for <kvm@vger.kernel.org>; Sat, 28 Sep 2024 09:30:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1727541035; x=1728145835; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yRdR8JrFJlqZaxiC8ock0OkPKQarzgTETJ8XRVUeN7E=;
        b=YwH2hECFpdfS1PC5LYAKW4LaBzXuRoCWQ0xOV/xYyKA0ljs0RWlHC4Ezsv4/u4C76W
         KhSLVqCbhU4zbGdoXP7uC7zIHpRVXYvHRrBfgDcLFvqH07kzyzsiyrL1vD8XPxY/ASw3
         jpc2SfCLYbFhhEwwQ91xrVNtoOOHBW9nKxrdQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727541035; x=1728145835;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yRdR8JrFJlqZaxiC8ock0OkPKQarzgTETJ8XRVUeN7E=;
        b=Rw2sdx2IgkozchX1lOhKZoMMkSG5Jo9NuwhDypvcv+Eg2TecaXn6NoV6n8ygUFsgtR
         mS5AjJwsMdGx7mPZLILBMpboT/DzZNe3AaKXHC8ARCUVYtzSPaVjM8F+XZCrNfTGcZ0j
         /pMJWW4TX9bAoMqtrsRe4aAIja+vItSUJnUX4Uonc1sTT4VsaeURItNP3wO/ilcY1ijN
         VeK9osRt2roKfM8R8erHXibb2hac05pl8smOBHSXEB1SGVKCQ2yL0cXgXpcFN/Vi9r8Q
         Ky+Z6lTpQYKR+ZURi7uk1WONIrQVvtN/z197iV0MtMyUCSLCZfy3NzCRyQc3pf6dQXS5
         teYw==
X-Forwarded-Encrypted: i=1; AJvYcCWpESyP5YX2TIvazqBbFpa7gWpg7zgmq/+EoHIdvaJ5B+GDZguudIXYUjcRFae3GJUboAE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0j+C1cD0jrBf0fwANSpRjrxSBhH71qFz8zXr3TbNO0rqXUyan
	hQGsu1nuGi9DKyniGo0ediZPj4xXHZkAZe/9iOtTFx/CikFAlteCzgsCpKAD11DYSNU1+vyFBGJ
	d0nID8g==
X-Google-Smtp-Source: AGHT+IHQzv23Rd7R8YKYETx/ltuZ6NUqD2BVqSmrXst41it97P0sNvbL2UihL1gK4d7X4OUnKp9FVw==
X-Received: by 2002:a17:907:26c9:b0:a90:b73f:61ce with SMTP id a640c23a62f3a-a93c47d97b7mr756740266b.0.1727541035047;
        Sat, 28 Sep 2024 09:30:35 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93c297a2absm266598566b.150.2024.09.28.09.30.33
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 09:30:33 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a93b2070e0cso357245866b.3
        for <kvm@vger.kernel.org>; Sat, 28 Sep 2024 09:30:33 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWH8FIf64BruJJO9Rl1W/EtnQQ3WRN/ssvRLqBjR/hsljquSTq6/isyMQqaYhLB7wJKGs4=@vger.kernel.org
X-Received: by 2002:a17:906:da89:b0:a8d:3705:4115 with SMTP id
 a640c23a62f3a-a93c4948a64mr702847366b.32.1727541033332; Sat, 28 Sep 2024
 09:30:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240928153302.92406-1-pbonzini@redhat.com>
In-Reply-To: <20240928153302.92406-1-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 28 Sep 2024 09:30:15 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiT0xehDuhtcut3PFeYnQW2H6Hx9O+1vkkFJHLKWT57Fw@mail.gmail.com>
Message-ID: <CAHk-=wiT0xehDuhtcut3PFeYnQW2H6Hx9O+1vkkFJHLKWT57Fw@mail.gmail.com>
Subject: Re: [GIT PULL] KVM/x86 changes for Linux 6.12
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 28 Sept 2024 at 08:33, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> Apologize for the late pull request; all the traveling made things a
> bit messy.  Also, we have a known regression here on ancient processors
> and will fix it next week.

Gaah. Don't leave it hanging like that. When somebody reports a
problem, I need to know if it's this known one.

I've pulled it, but you really need to add a pointer to "look, this is
the known one, we have a fix in the works"

             Linus

