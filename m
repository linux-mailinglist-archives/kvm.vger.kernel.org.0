Return-Path: <kvm+bounces-5918-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 02A40828FFF
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 97BDDB2386B
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 22:34:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F6D3E486;
	Tue,  9 Jan 2024 22:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="msiBcSjH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2F33E46A
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5534180f0e9so1551a12.1
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 14:33:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704839631; x=1705444431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvFkU4oKqZ1l9i2yu4stSdIuhBcnRcmyvuiaJ8Oo4Dc=;
        b=msiBcSjHXBij+YioAitXdfNOcOQwiGOPiyFlYZo2fqzx8rdKAvoaq7ML2rvCV0Gozb
         elkZA3OG8uAl09hcBM8WW5rONUMzL5zktg8JPcdANfnBkWlCo1dlxG9FnjVxylBVW6dj
         fgDQEH4+g+BE7REC5sA4LB7RC9sS/bEcEc8qgoSeKMs8vS02JsgF2jUKd5zI1FSQtWiD
         +yy5gxsrhXefLPjZJutOAGgMOZ8ah3ZEAsvMp4+qdMW0bSAtysbTEPVyt9dbbox97f3i
         hiXk5mKnXHURiDZeUdKIAL8QmG86GNqkzmLgtZEjdncddeMUx/JRkTR0zGzMd5E6e+BD
         uJ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704839631; x=1705444431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dvFkU4oKqZ1l9i2yu4stSdIuhBcnRcmyvuiaJ8Oo4Dc=;
        b=TccBOTfKCRFUzbREKGIzK9TODawJw8Vc92vy0t7pVQ607bin67dWtoVOHGnaZeBeLX
         wxVLug//2oOjB6RmdLEzYURfVV7T8ti/lkgQbdtNaljgw9/1uYO4htzMTzO21UYUu3yJ
         8sT03lCsLZ4nZPOS6PWe6qCmuj30BkhitLJbb3C2NOnNk0d81F6vV7tGG8clLksCFEyV
         wUf/a0ZzyrOMD3/ufw8FzwA7C4Fo85sKYXp1Q/WrXZo4KFqBB6fZaROsgspmdre6H7rs
         7L1MvgoumX9qPR2WASsUAWy0vN5pIbugzorFjaOgkhXOVWEk4+u0i87RJkFTZ7iH0r2P
         tkzg==
X-Gm-Message-State: AOJu0Ywv6h5izHkfC6ujvw89hVRc0zolJ+j7vCV6ItPEyJ8+83VZG2m3
	U9wp4velj//FrhUTMtP8gRZeWyXdRVDns0H+LWehsXH86xsu
X-Google-Smtp-Source: AGHT+IGFxflM48pZzfzkW6nRGjsuAemEOAzgI4FfGvhUxRbXVUoNADL5g4qT6TagGC/hyFGQQAb8WRF2Yf7waUyDfZ8=
X-Received: by 2002:a50:cd89:0:b0:557:1142:d5bb with SMTP id
 p9-20020a50cd89000000b005571142d5bbmr79955edi.4.1704839631001; Tue, 09 Jan
 2024 14:33:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240109220302.399296-1-seanjc@google.com>
In-Reply-To: <20240109220302.399296-1-seanjc@google.com>
From: Jim Mattson <jmattson@google.com>
Date: Tue, 9 Jan 2024 14:33:32 -0800
Message-ID: <CALMp9eQTtb9r+Jn5KnrTs1HDkFm0MWSJ5LxW2_3jrRE14TZtUA@mail.gmail.com>
Subject: Re: [PATCH] KVM: selftests: Delete superfluous, unused "stage"
 variable in AMX test
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 9, 2024 at 2:03=E2=80=AFPM Sean Christopherson <seanjc@google.c=
om> wrote:
>
> Delete the AMX's tests "stage" counter, as the counter is no longer used,
> which makes clang unhappy:
>
>   x86_64/amx_test.c:224:6: error: variable 'stage' set but not used
>           int stage, ret;
>               ^
>   1 error generated.
>
> Note, "stage" was never really used, it just happened to be dumped out by
> a (failed) assertion on run->exit_reason, i.e. the AMX test has no concep=
t
> of stages, the code was likely copy+pasted from a different test.
>
> Fixes: c96f57b08012 ("KVM: selftests: Make vCPU exit reason test assertio=
n common")
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Reviewed-by: Jim Mattson <jmattson@google.com>

