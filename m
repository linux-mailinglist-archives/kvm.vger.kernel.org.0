Return-Path: <kvm+bounces-67087-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B79CCF61F3
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 01:55:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id C0ED43035073
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 00:54:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9169B20296E;
	Tue,  6 Jan 2026 00:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RAsUORX1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D84B1F419A
	for <kvm@vger.kernel.org>; Tue,  6 Jan 2026 00:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767660893; cv=pass; b=n6XJhI3wVMCkeCgRnzH9RpEAITehngkQSQIqb67kdcr9AS7fwv3RAOx39yqPb7974j7UDIWBaGr1EqlU66NNkdxB8zLbM296uTQz+XWvNX5RTyhXl5tWhyVd1zI5D1fLyjsjktwsKESa39zaXhHFEx6NH+Ase3xu804clXOhpTk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767660893; c=relaxed/simple;
	bh=U5ZdZIa4tcOeth8EAljZfL40JPYFUxc61pVVRnuLKFA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Tr0ZQNNxxhHbfytWJmY0nEJAepm3yG8+f08KMlADRpHsEVUuGaJz9epcpWt1vxUyQpSf3enOmhnd4KJWynf9IPUu9iSDRiflS2HTsSJYvtbL2Vy0VDnY5iwMdUzgXtIPpBb4MUjVGunl2o1c8TKZW+tiMnXBGA+M2JKGHe2wsTA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RAsUORX1; arc=pass smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6505d147ce4so4312a12.0
        for <kvm@vger.kernel.org>; Mon, 05 Jan 2026 16:54:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1767660889; cv=none;
        d=google.com; s=arc-20240605;
        b=QzxOMA89SG0n8GX8XasR6n3bKVvQoMtEWZtb6B06wCoJzBllth+wG8s4TWJ6Dv97eN
         z4OVan6F25+MCTZEigO70bE7twBiESJ9xF8zRW5xDWFg4izO/ffjHrA/nsw3uYsEINth
         nRcHljwz5Ta4Lv4f0H/wj+wYGX4Lagsylu3GZDjp2i1aIcuJ5iFieT2qCQrQM3qWQkPR
         +B6HUezpUIOT8Tj8u60ewKpz6EqxxNrO+Weu/ELdJozJtj9x85nbe2i/ht0tDxHvGVJW
         6sfIK0rIaBjNqBoIZG73f1mZC7/A4O+dnXWnBJnXIT0xkAo7Hq//z/Y/hCpV1oE6DxnB
         WXQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EWNiWePs4Ni8e6iYqPJa5/G2oW8FgnO0nCVcy739CK0=;
        fh=0KWE0p/KgYiMpStVyQKkt3mSgRW8aUaXfk3EhE7sXBA=;
        b=VSs7QHbhdPYt7vV6G6nJI/OguSZD2W5KCzjFyqK9tjW3OQVfeOaFOlr78L7CM46GkH
         qn79gQPjOws0zk9Tp1GCPnE4CfqqxhsjDSDgmjK8GXMrYmVjsIiRCd0OSKEElQNPgri1
         nB7VYTqd1U/8hbE3pdsCqf6mN+8FVhVKpUjPxsMIU1MZdV2kenVN1dDAMKcQj/Ogm9Ld
         T1j7P5/9UAry+eGV6AQocVWxFQiETYUWYmivPWhEB0tsxGoLJGa6CUImSp9/Tuwh4Jxs
         pmaupi6i+O6VWoKUpUCKr3ZzE2fVwvkLM2yoWF6V3DmXqtGin4uE6qZbDUIV8h0igYND
         k5JQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767660889; x=1768265689; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EWNiWePs4Ni8e6iYqPJa5/G2oW8FgnO0nCVcy739CK0=;
        b=RAsUORX1omNX0o86SZCqfLDpJt3CoHZ3fHII36wXTBtatjBSwEsm/EC8AWm/ZJePid
         e+sQQkzFqsRAC4ebx5fvwoFV6t9T7V1v6dM6ZEuSnLnHABAmyKYm1Ds9mi9X+z4maAJv
         A6pDnhhBS7DYh+uBNRf1p6hdDMBWTzKv46r+kZmhv7Gco2TnJf0Rg8eQBIyYA2D7DRbV
         dARfLEgH6YO9ZBY+HnYgBMeFiiXTktchYwYqv/3K+VdAs6Q1bI88tb1Tu64/qt0dJVmh
         qOSduqHTvfHh2MhlQAO1ZoJkfiat+zVPl3Tsc4UI8Nzmr2/F0iPIzKwclDz7IA5H5JFx
         KLgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767660889; x=1768265689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EWNiWePs4Ni8e6iYqPJa5/G2oW8FgnO0nCVcy739CK0=;
        b=t8V1zaN2chVXu2o0fs8Z7+G/ZizuBWCFNgg0DecRYweq1AYs9/E5fqhXrelCikW0iP
         S0qiLiStp/YsqSH3lw50NJIb+qLtQLJY3Js6Ai/tF8t5IDXChTNdC30hxU4iUOz3lHsE
         YG4uNknFPIeaVznIx9HIEb7YxGFAlTw/8ZwZgPzB/c8WU3+aNixd/oUhzT3EGcyGzMtW
         OCta6oiVwr47Uq8oA+2WwBF9QnOtJUFcYtuFXDlXJR3v0qptWpDbomtQQdnYhC9fk/eg
         /OKTB8BzozUqGfrEksli3MgIKdRj+Qs2pac+YpXTrkYgmW7/jyTUJtTfF1jumNfRhX3k
         IHbA==
X-Forwarded-Encrypted: i=1; AJvYcCUjBALpUu77vQbTax0nm+bZPB7GrjmshmgtWjybLmOaoggqctjmAGHMtPiZdf7c4DqySdM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1E73lGt+uMj1B6mHYyivisBBggwsNdzxrOw5TyxkZYLBfVetG
	2grr1w+KGv3mueXGEp0Wx5rrwtzIpgmoQyXy4osWJ24cjUucOk5qfcU1wrU+Btrx3jfYlQ3hBa8
	A46hQV487r7Sjy+Jz7I/g4uOTBPLXf4jzqh78fsQN
X-Gm-Gg: AY/fxX7eiBVUvMFHHlPPIrQvW69eegySSxkjPjkHkyiuFCokFF9P9+Rbh2Ohl46Tp/d
	MLhGOKlr0zfJdNLW7v8YcyKhKfIdk83xKvQvt2OXfnVIlUsdd34qWUS0WVgKwBOSsRFvqGHX2sJ
	UMantC0xVShHWTuHNWMbhrd45rR2YVrzD+Yr8b2SiR3ZWS3+NCaHSOc/g8wj3RWjEG2Jn3jANJ+
	uWjnsZQmcGcuse5cBcI8TAb8SZVamQpd/FUvCD8yUJpRMLiidmIlLRGs1N7uHItMVZ00H2Qza7c
	RXLXyQ==
X-Google-Smtp-Source: AGHT+IGWKSRnkkKYnK7JG/CvYiGarDCI+ajo3F5kb+1PzJYaiyiFcGanq8SprbF89rYnLJhh9RH/tsrB2I04BC58k8U=
X-Received: by 2002:aa7:d9c8:0:b0:650:5d5c:711c with SMTP id
 4fb4d7f45d1cf-65080907ee8mr9405a12.17.1767660889313; Mon, 05 Jan 2026
 16:54:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260101090516.316883-1-pbonzini@redhat.com> <20260101090516.316883-2-pbonzini@redhat.com>
In-Reply-To: <20260101090516.316883-2-pbonzini@redhat.com>
From: Jim Mattson <jmattson@google.com>
Date: Mon, 5 Jan 2026 16:54:37 -0800
X-Gm-Features: AQt7F2pqIe33A5HTxusplRp5TOpr0YDWt8-n-oDeaTTLO1max17quIB6VH1aut8
Message-ID: <CALMp9eSWwjZ83VQXRSD3ciwHmtaK5_i-941KdiAv9V9eU20B8g@mail.gmail.com>
Subject: Re: [PATCH 1/4] x86/fpu: Clear XSTATE_BV[i] in save state whenever XFD[i]=1
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, seanjc@google.com, 
	x86@kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 1, 2026 at 1:13=E2=80=AFAM Paolo Bonzini <pbonzini@redhat.com> =
wrote:
>
> From: Sean Christopherson <seanjc@google.com>
> ...
> +       /*
> +        * KVM's guest ABI is that setting XFD[i]=3D1 *can* immediately r=
evert
> +        * the save state to initialized.

This comment suggests that an entry should be added to
Documentation/virt/kvm/x86/errata.rst.

