Return-Path: <kvm+bounces-39477-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 41770A471A3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:50:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5FAE2162B61
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27EA1ADC7B;
	Thu, 27 Feb 2025 01:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZYDIKWt0"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0068C1ABEC5
	for <kvm@vger.kernel.org>; Thu, 27 Feb 2025 01:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740620486; cv=none; b=KN7KgoNrqWCiGeO9tHuKD5jd6E5/6GRvC8MZjAFuoVZSU9BMi2DhvlJQOmA4pMe6zME9CzOt+kxVSZ/nJiEjAmxrRFWlTDXOgHfBS604qOWMpxC3/RXLUGgC5IRoSMW+q54ZPHHspkfcXC27H3IS0ebCFozik9LFB3OUYGxn9yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740620486; c=relaxed/simple;
	bh=Uh8v7nQ+Ir93Sl+r18zQm8iu7CgR5AwBCEP9ygizBTY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=DZHyd7flRwcklTtExci7RJib6rkUvh/7VU7sTKw9M7kHekjhzrVETVUPVi0bLv5Nwi7hfVqouSF9wSOeAIK1oitJ1vAJT2gq/lSiJvUNR9fF9Ty4USIjIZUPMwxJHs4DdbfCDv8hutoLvFiQDSX4niKOc3EcLERt0U0ngaDnuoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZYDIKWt0; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2233b154004so8732645ad.0
        for <kvm@vger.kernel.org>; Wed, 26 Feb 2025 17:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740620483; x=1741225283; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w6l9m6fqMlLq1/610gDj8nnv1xOjQhHIjHJq9ELM5lQ=;
        b=ZYDIKWt0a3DJh789OwAxCYpKnXq8f8tF3Qdfl9/FAUHBUyMmjnGH4LskoC6NGDGrFA
         /KFxQ0zbg1QWZq5Om9QW1C2RL8wotsX/wyqd2Y8Uv7DaB5yDOjrCjJpbMiN7UGvh4CB6
         Sfp+w2B1zYjWTac8Rtq/0dia5XT2aiL9CUl802QljwRTBjUDqiu3wCyh7wVUZPJeJfg0
         xwcBFjZ2X6vv4A7CQdxOAkPuR/hQ0qLnypas1VstZU3tbca+sb9ts/jZKITYRfuxVywQ
         Nwspw1LPwDZmjEHU33fnjDh4cfC0YUuuKpgRkkC6l6bHaTvLYBqzLct8nGH+KmmqsqH9
         j1pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740620483; x=1741225283;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w6l9m6fqMlLq1/610gDj8nnv1xOjQhHIjHJq9ELM5lQ=;
        b=ivr7SWuCtsIlLFka/j2XkUyPWge3OByiazLn5TeCqOvjUpUMz/wKWxSxprQys4nuNl
         z29oW6xdw2lkC3jUrdWzumug82h4NXzAYscMXiqJYxGw9T6LtyfpQJsS50AaYvZFe0qu
         JDKS+QUhgcmpNhQzbdZIczwJX40dXCAYy7ThU0ODDJbrUhwruU/WAOF1MAxQNw9R21Me
         mtyzIbvwsPRJ2/xlHSL3ZmQdGrn5hh2WbdfN/hsHdCpjcqbkdMXeDKT0pzDIyQHD3L0o
         EKNKbTm5C91GA+PkylJqhXD5+Eat4DfNg5VGE2scHM7ASZlP8hknBLk/GIHDBKF7dzQ3
         3pvA==
X-Forwarded-Encrypted: i=1; AJvYcCX+5JF/dW52pTQK1MFgnC10sPU5025ZIix7JojzC6kqmZoDsI52dL/96dHZYTzIW2WgxiI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxFugbMi3FFy/qf1PxMI/ZvngdQN6yMHXVohF0pD9wOlso82KfM
	ZIqiqN4D8GkEW8lHPGjSfIxyW6ZR+PjVv7fW4sAfXosFIYNMTZZeILozKiwyVJ83fw9agWGk3T+
	90A==
X-Google-Smtp-Source: AGHT+IG7Q8fN8EDpqtDnTkX2BbBCR1zsNJUiVjHqyfD/MBJpG4F8JviC5cGF5Cwpg0N7gFMxU1nBPseGqls=
X-Received: from pfop3.prod.google.com ([2002:a05:6a00:b43:b0:730:92d9:52e3])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e887:b0:220:faa2:c917
 with SMTP id d9443c01a7336-22320208770mr95991285ad.34.1740620483177; Wed, 26
 Feb 2025 17:41:23 -0800 (PST)
Date: Wed, 26 Feb 2025 17:41:21 -0800
In-Reply-To: <20250227012712.3193063-2-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20250227012712.3193063-1-yosry.ahmed@linux.dev> <20250227012712.3193063-2-yosry.ahmed@linux.dev>
Message-ID: <Z7_CwVbA3yyk6iF2@google.com>
Subject: Re: [PATCH v2 1/6] x86/bugs: Move the X86_FEATURE_USE_IBPB check into callers
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Josh Poimboeuf <jpoimboe@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Feb 27, 2025, Yosry Ahmed wrote:
> indirect_branch_prediction_barrier() only performs the MSR write if
> X86_FEATURE_USE_IBPB is set, using alternative_msr_write(). In
> preparation for removing X86_FEATURE_USE_IBPB, move the feature check
> into the callers so that they can be addressed one-by-one, and use
> X86_FEATURE_IBPB instead to guard the MSR write.
> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
> ---

Acked-by: Sean Christopherson <seanjc@google.com>

