Return-Path: <kvm+bounces-31126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 47F0B9C09B3
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 16:10:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F35971F24B90
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2024 15:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A88B2141BE;
	Thu,  7 Nov 2024 15:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iym5bu1D"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E569213141
	for <kvm@vger.kernel.org>; Thu,  7 Nov 2024 15:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730992230; cv=none; b=XJEqLYpQysnUgDTfgVfFFRGb3DLJmqoJBAyXNnjAk8YVk97MfnkZ9PfNIQGG1gl1PeIEjRnqrH+LJ5IcsWWIcg0rLxloGCVklFNmHjN/WF0kLauRXoDTOfqHs2PXTWM8BydMn4AmG9DUjl9b5Bu+7WSY8bKsZihs3MykYG3Cmd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730992230; c=relaxed/simple;
	bh=KsTG/igdk//wwpXY7Y3QxoZ0hz+j87r2VAhmwTK71Xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JVC1Zq+gWT5guw5PilhCNoH9AxNwhggasxOmwELNTIIdBQYc9ZQOzSMocBX8CG+4seUJCR6shnigBRtsZBEnuVnCSaF569RC4ZKSdLPKFPSd75uiI9ltUTJfAZJFxN2skLJGZomjNpAAug9ZlJZKK2xi62pChLN49Y+v5Kcf9zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iym5bu1D; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730992228;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YpvhEKsdq9nlGeRZSZmlJvSbxDPJsov2mUU+VC+WFq0=;
	b=iym5bu1D/niQNTbJJI2CP7r7cQ3AZg5jB5t0Cs6jADIDX6ySAL+bMRcY+gtyIRQ9VNB6I0
	8gLu7puxgqx1RRp6CazwEnD5OZsuSaXNWj31RXqx6hCgPR7XD3BjP7hqag+zIansVfkQXW
	h5BmX39kKjfq+6jDDF4nn75HSIiu+MA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-160-P8tu-UDdMIWlbNjgGFWr-Q-1; Thu, 07 Nov 2024 10:10:26 -0500
X-MC-Unique: P8tu-UDdMIWlbNjgGFWr-Q-1
X-Mimecast-MFC-AGG-ID: P8tu-UDdMIWlbNjgGFWr-Q
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4314c6ca114so7786805e9.1
        for <kvm@vger.kernel.org>; Thu, 07 Nov 2024 07:10:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730992225; x=1731597025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YpvhEKsdq9nlGeRZSZmlJvSbxDPJsov2mUU+VC+WFq0=;
        b=urh7fhUVgn6xU287z6BjmOVsiYQTOkXpPNtTadlOuXdOIt/03YVX3NAqOxwcT4m+SH
         NJtAveTfOuaiD9adggZ69Rkk5K/cG+LPNR7OTJJSbyeI8hp3k1cZQVzdqq8EoO70Jpcr
         5v4bGY7roUhd6lT3Xyibg45kJ6+cL/kFHiUyHhUNr3faz1BkL/fJX+mUmHx4GikXqVGq
         ZCxkLQcohCvwM1uyHAANW1EVuNoRkR4zXGwZiwZ031WZmIUCiQwDglnYGXUQBRgaX7R4
         nG/SAY0DaNbCivTbXa39badhZlItx/bIsnHT5YpgwwpYphbtv6aXZIc3t+r9OqWJf5Io
         lQVA==
X-Forwarded-Encrypted: i=1; AJvYcCWL2QOIgL5FGbDxg57LSZRFI7pqz/jf2zNyuPdQLpyOq7c1LsODqvxkPTb3gDujg3zrfa8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzgCwfr/ULHjJ94ZI/U+f5ulSLC27tmbAouWX8t7/zWhNmZtLoS
	xDFs16MBXE/nB/RbrYsecMcXq+BMDDSsjdZjVEbXlJWN9yFurz/MwFmuSvjmTm0S61B5DtyIPaX
	Ynewbe9LYeqVxo4YTUHCzg5GkeqtuLIOSqvUu12A8cghwLAmulD9pC0LkbGi9sy/enDlhGN/aLH
	AhvAu37GwX31WF5ao1zO7K50R/
X-Received: by 2002:a05:600c:4f4d:b0:426:61e8:fb3b with SMTP id 5b1f17b1804b1-432b5fadf06mr2942655e9.27.1730992225639;
        Thu, 07 Nov 2024 07:10:25 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHnmBJCvwyfFGRxFF0wUd/g4DeAkHO+zUL3FZsLbSIdoqw0lMuNoVrgIsThXhHyDPsgg3eAPlYTuEQKalxH/nI=
X-Received: by 2002:a05:600c:4f4d:b0:426:61e8:fb3b with SMTP id
 5b1f17b1804b1-432b5fadf06mr2942435e9.27.1730992225298; Thu, 07 Nov 2024
 07:10:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241023083237.184359-1-bk@alpico.io> <ZyUMlFSjNTJdQpU6@google.com>
In-Reply-To: <ZyUMlFSjNTJdQpU6@google.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Thu, 7 Nov 2024 16:10:13 +0100
Message-ID: <CABgObfZ+ZiQWJ_x2AJ2bgModK7ziv+qUvWaS-HySq4SRwvFMCw@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: Make the debugfs per VM optional
To: Sean Christopherson <seanjc@google.com>
Cc: Bernhard Kauer <bk@alpico.io>, kvm@vger.kernel.org, 
	Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 1, 2024 at 6:15=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
> I'm not opposed to letting userspace say "no debugfs for me", but I don't=
 know
> that a module param is the right way to go.  It's obviously quite easy to
> implement and maintain (in code), but I'm mildly concerned that it'll hav=
e limited
> usefulness and/or lead to bad user experiences, e.g. because people turn =
off debugfs
> for startup latency without entirely realizing what they're sacrificing.

What are they sacrificing? :) The per-VM statistics information is
also accessible without debugfs, even though kvm_stat does not support
it.

However I'd make the module parameter read-only, so you don't have
half-and-half setups. And maybe even in this mode we should create the
directory anyway to hold the vcpu%d/pid files, which are not
accessible in other ways.

> One potentially terrible idea would be to setup debugfs asynchronously, s=
o that
> the VM is runnable asap, but userspace still gets full debugfs informatio=
n.  The
> two big wrinkles would be the vCPU debugfs creation and kvm_uevent_notify=
_change()
> (or at least the STATS_PATH event) would both need to be asynchronous as =
well.

STATS_PATH is easy because you can create the toplevel directory
synchronously; same for vCPUs. I'd be willing to at least see what a
patch looks like.

Paolo


