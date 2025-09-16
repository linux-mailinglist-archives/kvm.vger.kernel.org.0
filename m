Return-Path: <kvm+bounces-57786-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D434DB5A1C5
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 22:03:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65AEB3B809F
	for <lists+kvm@lfdr.de>; Tue, 16 Sep 2025 20:02:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEF0F23BCFD;
	Tue, 16 Sep 2025 20:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UEMcJ3Gv"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9442B18C03F
	for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 20:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758052961; cv=none; b=JXOZW5djsnGQx00XhBNGlGvcOykh3W/OVT1RsN3tp8qV23Lh0f0KxXD9knmnilGhJjr3Hm79ttZiuzO14UJ/rYRNjdxojuT84/xfsNDh/7/NyE5QUMfKg91Yqt0VdXEljkX06Jo34TKCvUwY3MhksN3cWJ3hkDJooYuuKssqLLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758052961; c=relaxed/simple;
	bh=LLu1AACh5q522Nr37rB3izBpVJgz0C5vXI0RUs0TrRM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nkc6nFCkt14yw6PMZNWsi+zb12fp+LeS88kMTEZPAlZ906PSea7QvDbqHX2Xz2rHIsLEUb98Aj+u2QAQPOHVB5dtE9GhYUvKPs4P70KWEwnszP3rS68uiMZuT2Tr1DRku/7ny8RAvUEusVjo4TuOPZnOoBjZgMDmFPhuB6Uv9rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UEMcJ3Gv; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-77621c54731so4806028b3a.3
        for <kvm@vger.kernel.org>; Tue, 16 Sep 2025 13:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758052960; x=1758657760; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NDPBVUVtayrtvgwZw5aJFImyZz5WI+omxTmlAGFmthM=;
        b=UEMcJ3Gv8MCrq59TL9IGgRgfgdDGsPhA7PuLSJRWF9HzRLAn7rgZyryJadY13sEfZN
         STNUANu1N2y0q2N5FlEuc0/NWWVyhwz5uuJnMZm8QKGl06IoA3p5VW/zVusoN29y4Vr8
         mo4gHYBDM6Q89bbL90VqZJ367Aj+OaMxjApK2YP8y28Z1yymUam2z+1yy95XbtNrIejO
         ChzIxxFechftu/U5U/wBDT0gVEP2oKlxwxnZ60hDmIh8CoIilAkFWUO68io3OwG8HaIf
         h+fMmPkDJIMBKuv9K1eKiHLTJXQRsJtL1xOOhtZtUC26DKRPRI+Qg8o83Un9LebCwswz
         uqPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758052960; x=1758657760;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NDPBVUVtayrtvgwZw5aJFImyZz5WI+omxTmlAGFmthM=;
        b=F9D5SEMnOcOsDNirPWYXRnCI5tWwhv5KbK/zuEvOzNzH653kXAckBUhvhLJtqw/NlR
         s3yyeQHD6G7Mk7ah9t1p9Ysd9HHZ4yQCQ3JCzKOlOF/f6HIBlPicCEOQHDW7OPl8nI4V
         lzFP7+C1PhV8YozH+NU5symhZYWMVO7xYjNoMQmDXAFUSfLvr4njxZXZyJgugPwUy6ew
         8k5oYV6pC//p+piGh4Y2/OJMuJb3KPqQQntIqx7UByP9VNePxsVKQTsvGLbezkR6OF2Z
         j+GWdnOSTMuJpv553AQfhaC6n2p5P2hluaJ9ldoE1Kcss9EzyfEDSZlP0Dc8DI8UkT0Q
         +kRQ==
X-Forwarded-Encrypted: i=1; AJvYcCU6V9U+qhCyz6r6LQ0CHOD3Gn9Kc06OrPCULbQNzzIEwFeWCizfe16cozK/wiU/48geWwA=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy637ADnJRGwITVWUlDfY9sprSblYhsx3h2mvqbMCeb+Qrb9uf
	GsF/YtqVyg+iMiGpv9kwbe5QZX3/qCWnW9o+bD91Fc74jvbYlD98V07NyGDUG27bfXgvTlTjzvf
	gARtZuQ==
X-Google-Smtp-Source: AGHT+IHdkoO+jtZEzBO26MNHdXNyLDVSTI0DQhxv9z5DC0syuYZZVtivfQ02s4S5Te6oVnTkomW1LaOYVFU=
X-Received: from pjboh4.prod.google.com ([2002:a17:90b:3a44:b0:327:dc48:1406])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:72a0:b0:262:c083:bb38
 with SMTP id adf61e73a8af0-262c083bc6dmr15435648637.0.1758052959908; Tue, 16
 Sep 2025 13:02:39 -0700 (PDT)
Date: Tue, 16 Sep 2025 13:02:38 -0700
In-Reply-To: <175798208800.624836.165612810420047605.b4-ty@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <00378f4c-ac64-459d-a990-6246a29c0ced@infradead.org>
 <20250905174736.260694-1-r772577952@gmail.com> <175798208800.624836.165612810420047605.b4-ty@google.com>
Message-ID: <aMnCXgLWN4xX6hjM@google.com>
Subject: Re: [PATCH v2] Documentation: KVM: Add reference specs for PIT and
 LAPIC ioctls
From: Sean Christopherson <seanjc@google.com>
To: rdunlap@infradead.org, Jiaming Zhang <r772577952@gmail.com>
Cc: corbet@lwn.net, kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, pbonzini@redhat.com
Content-Type: text/plain; charset="us-ascii"

On Mon, Sep 15, 2025, Sean Christopherson wrote:
> On Sat, 06 Sep 2025 01:47:36 +0800, Jiaming Zhang wrote:
> > Thanks for your feedback! I have fixed the grammar and put the full URL on a single line.
> > 
> > Please let me know if any other changes are needed.
> > 
> > Thanks,
> > Jiaming Zhang
> > 
> > [...]
> 
> Applied to kvm-x86 misc, but only for the PIT documentation update.

...

> [1/1] Documentation: KVM: Add reference specs for PIT and LAPIC ioctls
>       https://github.com/kvm-x86/linux/commit/3f0bb03b9db7

I force pushed to fixup an unrelated commit, new hash:

      https://github.com/kvm-x86/linux/commit/5b5133e6a55b

