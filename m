Return-Path: <kvm+bounces-39776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F53A4A6AD
	for <lists+kvm@lfdr.de>; Sat,  1 Mar 2025 00:41:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 66491189C409
	for <lists+kvm@lfdr.de>; Fri, 28 Feb 2025 23:42:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F4BC1E0B80;
	Fri, 28 Feb 2025 23:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="P0+YgP7I"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB1F1DFD80
	for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 23:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740786070; cv=none; b=ku7/eUuY+Fz2Lff9QEAcKe5Ur1b3FQQbIqL8yS8JVs8FJN3rWxnxgEzIi2EdpvmH0MuR8g/5aapLKylWKvznWM51OsAkeFk/yGbfcVTigo7USjP5YBHDgi64U7ewqER8fOmlebE5QHsnylBMcsDSlhqD49uUo11t7llT+kwjJcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740786070; c=relaxed/simple;
	bh=x1xcGyWuvEinSureT9tUUGJ7cJeDt1cowH+pbvsdG30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TWk34FKEHkeiTQSn6rVYBxodN64gyWsgL1o4Hp87M9wLpLmjr9hUb4r3laTuQMq6nIZ+UgCl9lwkc/3841wrEw8lAAXWzy6XrNfPsSCyX6fMyGX3Ll4aMr4KilMix7504wYmdxh5FFzC4Ub6ZWRauT3FOCtrkPVoPRT5zrbltvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=P0+YgP7I; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fec3e38c2dso2948619a91.2
        for <kvm@vger.kernel.org>; Fri, 28 Feb 2025 15:41:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740786069; x=1741390869; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kl9LwKBgq1gzc8KoFXspBEkJ7JViwBj6dpxzcj72iWk=;
        b=P0+YgP7IPSQBzp3vnFb6Xt8Zs/GfX1QofPt08sBbLlZP6OQcYuWA1oG/Bmnu/T3o9X
         rKB4Bx1uUI/TCD7Xg9HAzJgy90fImuy988ySN/+Er8t66YOZVG9nGe+fr5E5JeW3nwOw
         z4BfzgXvNxMi4j1xjOzE4bPKpx0JJp7M7PIR+NIFOl5SwrhT4q+Un7eJ3o1lQCX156jE
         QkvSjhkim7ZgTR6w5H5anFlU59upuIZOrziyNDO51iv3PGGoVULLSk2OKmuEdCqui0U0
         i04mDBEV31EWa8O9CMScrqYKG9EMv+agkUBXOVmmEZQVoyScijzxuz3vdlavLN+xynBg
         6f/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740786069; x=1741390869;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kl9LwKBgq1gzc8KoFXspBEkJ7JViwBj6dpxzcj72iWk=;
        b=VnTPSbKroo9HujFFT8syri5hZyQCxS1c/jlhsxbttgcGG/UE391A7z6W4IRI6WF3pq
         RdeiIl589yq+YdTgMgJi2D8yTPiuY5h98osOfNnCbFwG6xp+HxEhxxwjPbo66fJgU5Zv
         em+XD8g2IcXFOJmT5r4k63f8w694pxqdFeWdy2FCsOkyi2cUaOjDLp0kVQA2dfIt5ZWS
         Det/rz5E5orh7qfxuIUhxnF5wIcc/a5mOm3EZPt8e9uydhTejpWKU5EWaIGSDMt6Moxj
         hyWpsMKc4hSHof/FnLXBVROhpFvRHcr9XSOAunLUCiXs8nOwEXKlV4qHSfde5pVojQf3
         lk8Q==
X-Gm-Message-State: AOJu0Yzwdfp2xBFATzCCbLPPPlRpV0souDimhn7saHbu1VxL1hu8535J
	sqynF7Mi69QecpUsxbF3fAj3pWLOzwtG3ee9NfxoeSKNyJqOowbgRcvF+0fbFxNgZkkYNb/en2H
	RNg==
X-Google-Smtp-Source: AGHT+IG5SWXICy/LZKFUdGVzA1+gVuxT4NkVrvlHCfE61FFSSnhJEXeHOluT/FmHM7w0dvc90DZ6xrgJRdQ=
X-Received: from pfbmb22.prod.google.com ([2002:a05:6a00:7616:b0:734:b0c8:f388])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:7a41:b0:1f0:e512:6041
 with SMTP id adf61e73a8af0-1f2f4ddf855mr8438486637.27.1740786068692; Fri, 28
 Feb 2025 15:41:08 -0800 (PST)
Date: Fri, 28 Feb 2025 15:40:32 -0800
In-Reply-To: <20250224174522.2363400-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250224174522.2363400-1-seanjc@google.com>
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <174076298281.3738096.14978008039669090737.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Inject #GP if memory operand for INVPCID is non-canonical
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Babu Moger <babu.moger@amd.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"

On Mon, 24 Feb 2025 09:45:22 -0800, Sean Christopherson wrote:
> Inject a #GP if the memory operand received by INVCPID is non-canonical.
> The APM clearly states that the intercept takes priority over all #GP
> checks except the CPL0 restriction.
> 
> Of course, that begs the question of how the CPU generates a linear
> address in the first place.  Tracing confirms that EXITINFO1 does hold a
> linear address, at least for 64-bit mode guests (hooray GS prefix).
> Unfortunately, the APM says absolutely nothing about the EXITINFO fields
> for INVPCID intercepts, so it's not at all clear what's supposed to
> happen.
> 
> [...]

Applied to kvm-x86 svm, thanks!

[1/1] KVM: SVM: Inject #GP if memory operand for INVPCID is non-canonical
      https://github.com/kvm-x86/linux/commit/d4b69c3d1471

--
https://github.com/kvm-x86/linux/tree/next

