Return-Path: <kvm+bounces-68090-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BFAD2156B
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 22:29:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5276A3033B88
	for <lists+kvm@lfdr.de>; Wed, 14 Jan 2026 21:29:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD232361DC1;
	Wed, 14 Jan 2026 21:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l+52QTUS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A0C361DA0
	for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 21:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768426142; cv=none; b=ri6+qb0gIj7OolcgV/5xbG3M7Z9KQEkyYiaerXgz3sQwUSF9lCyIN3DH6pkKASfvUqxW/fm8hRjfsWq9/S8uoVqocCywrlyZA+I7SNLwepkZ6ZyW2vDI2PmN+L3OvCh3FyTCN+tZBng/efAaUDneHple53NKvO/vb6vJFkkiWQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768426142; c=relaxed/simple;
	bh=zwgGQpdvgwfAdheqFz34XmzwOY7DKSqCRyjjxdrBr90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=t7VkcGqkapbzB0mBDzYMYCCGgljk9QCeW6MPjQ8/u0+nwdJGm/ZEvxJQfekMkYFMSbedyQfEWle8UBnFtqIukUQjSy7s/EICq5kyW/VU1o3DoZENsuSK4VEckIXvNDfQBLKeQqJiITdMjba3Z7c4Z0v/bas/zgOVqVL/H6oBKz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l+52QTUS; arc=none smtp.client-ip=209.85.215.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c1290abb178so206129a12.2
        for <kvm@vger.kernel.org>; Wed, 14 Jan 2026 13:29:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768426141; x=1769030941; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xLOado+yWPClBRtMjOL7qAU9jcmNT34zEqVC1ZdjKqo=;
        b=l+52QTUS6DSGzib2rsnO3a5mblBlkf91p7+LBnP/f5Sw2iL67oWTXpoIkw24a/U77M
         krGhpxH9li+fqe+bqm2h2uam/ZgRz6h333VydDxoRq8Ll7MYCU82c0CuJb71n3hbn9Y3
         tTUzeEacMKocGfnauaEM3z3+hGLufmEBXZIJHV/+Qvz+SHMpxMrKrp8FqDbRxwPhwaqc
         UbRLUDc17z9ZdeIBdehB/aQl0ctOgZpWL8iGlph//HPPjkP48OS0vKVY8vjQAOZa+8UN
         0tIk571grvx2uesZTVyfs9o9ucUUUGc7QX+974a3Hngh2W1mB8fA11b7gn+877laJlWe
         IXNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768426141; x=1769030941;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xLOado+yWPClBRtMjOL7qAU9jcmNT34zEqVC1ZdjKqo=;
        b=te3uBMjuKCqU5ZIubIYAH/V3lOguVbTjYGhmMmL5/lI/n1RBkPK7BFL0z4Hhlvzyxt
         xW4KMlfaiykSGdn2aNhj0weUPa0xl5WjPJxSaqlLiqLYAJ/ApGGBKm0Fr24NH5j2VF8z
         NXmdGZ8riffq2ZNEmIGsZQu2WSE+RNkHXR2ULpGmbUsjIf74oXTbGGqp/FJ4YqZV5Fk+
         MATnfo9Oip24+lFyN1295D/xqc0wcwskF0IsjzS7X3xMJRYvrpbzvO82h7RRD9mQ+fFX
         Mz4ctOe4SuZZ47V/o3Cqip074ZLSg+yDd5qhp69nNjkNt2tTKkRa0geoWWnT4/8ZEcU0
         o4iQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwx3AZEXI2vhPVFk+Y2VsLzVlF3NeZGAsQt7Y3yD/d0V9tyiPe3cqyla6Zl/y/wNN5rzk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz833xA8LkCWD5yOQ1HswuB4LyZDFI1pRH3qYhdi57ozkeCy/KC
	LCcFzDyF3qxI8QjSUKB8m9kRz6tvZDVeWWqc9Xu3EyzpbhGuB96QeSVb4cvHmst3i79b5KjPKj9
	Wgw1UUA==
X-Received: from pgnc5.prod.google.com ([2002:a63:7245:0:b0:c1d:2ca0:3b22])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:3d1c:b0:34f:b660:770d
 with SMTP id adf61e73a8af0-38befc04253mr3346651637.55.1768426140635; Wed, 14
 Jan 2026 13:29:00 -0800 (PST)
Date: Wed, 14 Jan 2026 13:28:59 -0800
In-Reply-To: <20260113003016.3511895-1-jmattson@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260113003016.3511895-1-jmattson@google.com>
Message-ID: <aWgKm6TokGGVRfkC@google.com>
Subject: Re: [PATCH 00/10] KVM: x86: nSVM: Improve PAT virtualization
From: Sean Christopherson <seanjc@google.com>
To: Jim Mattson <jmattson@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, Joerg Roedel <joro@8bytes.org>, 
	David Hildenbrand <david@kernel.org>, Cathy Avery <cavery@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

Trimmed the Cc.

Please adjust whatever script (or script invocation) you're using to generate
the Cc list.  AFAIK, Alex hasn't for SUSE for years, Radim hasn't worked for
Red Hat for years, and Avi hasn't worked on KVM at all for even longer :-)

