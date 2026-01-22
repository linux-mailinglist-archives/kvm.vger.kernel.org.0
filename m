Return-Path: <kvm+bounces-68921-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cLF0GVZpcmnckQAAu9opvQ
	(envelope-from <kvm+bounces-68921-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:15:50 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 28FE76C2BF
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 19:15:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id AAD2C300F279
	for <lists+kvm@lfdr.de>; Thu, 22 Jan 2026 17:36:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E801138B9A0;
	Thu, 22 Jan 2026 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d7y26Uz1"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56943559F5
	for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 17:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769102524; cv=none; b=WY0D0ky9AUrSkcaLao3aWUhZOwuDDJo4vyGyb636DwZTKqQ1j2cM0usCzYwmq/dn7vfAJeq8Y2IKTjddVy0OyL6PE8kb+R01snFhL4fUmrqn7IC2p+VO3+Bx4haMoUIFBTGkG14uDtjkepdy16sxJnkhply8EtZW4Uj6DXAtHNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769102524; c=relaxed/simple;
	bh=MsLyfRmAfe4C3jNniNY2lFNJQoio2YovxKjleJiyn/Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nvlJKMO8ZS5UdVdovxhUss0udaAgUU7HulhLENeRthMVi3houC2Rwk2C//Q8QavJpKYCYsfo/xQI2PsLaNS/GI+NcP6hi3yFhkNEQmLWmkvDAWrKIxZHkQrQ5xVmDKWTPcjmXOs0MfhKRklUg9YYh2T4rGFqQ5j3oQYssGTIdzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d7y26Uz1; arc=none smtp.client-ip=209.85.215.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c613929d317so683585a12.2
        for <kvm@vger.kernel.org>; Thu, 22 Jan 2026 09:21:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769102505; x=1769707305; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6uCae6YjFO2GUpcWjOMRLM2rB/k4Vf9uxQYdqxpZxK8=;
        b=d7y26Uz11v1OZvixhnXIRkusxTSZ2HOccmKfuXlwS+6qpKiPWybhbaORq0arU6IQjF
         zuOEd2/olEj0HbTQjeol0qpjRFZtMGmj3LimX4p+XqDaGXy7Np/XtAhEkMrED3vkbA5Y
         Cvsfo+gIRZEY+QszLtocfUnJcAyFYbJax811iP2eE43xm9f6+hcZpcAictYGfbqcVVcb
         6DdBHnAmnQHe47brIQ0ktKv8mSU38HvhWtZby+qXmyGr3XDZMFInxiU24hdmkwqFYlXX
         GA1vQ6uA7pbZh3KgVBk6kl7exIkXgmVSEFS5AJvYAsxdUUMbokYYBCon1LgvC4ypjPQ9
         P49g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769102505; x=1769707305;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6uCae6YjFO2GUpcWjOMRLM2rB/k4Vf9uxQYdqxpZxK8=;
        b=GH2s+la00RKH9oWZJVEEiep25mUAvvfVmrAqeWR/4SvRAwP/hgoeFqPcI67fU72vDO
         HnhkaGI5dJnixEoLut7Y62g0+dV5drvo+rVzCMgEZC25ev0xr62n51txJIXw1T2PodK8
         pKoYDret0t4yE4R5v2+/u0Mf/JzgeUkPShJlNuQv9mMh/63jkvE0kHI0BuKET73+KUYV
         cBgfAPDXi6FQSq9gDjYHpqNQCD1WLkyvTP2nkrKMnUgJUQilDQSXV8iKeFrSiFerAyBW
         f51Bjug/WhWK8FrLKZ0Cm9xxvwt11xDmY7FoCIqvxRufJoq9dRSeIstCk+YespkpCUxY
         v25g==
X-Forwarded-Encrypted: i=1; AJvYcCXPg1aWuU/DatNepoXW2YCYKTybcPfT+ezEWJBwgXP6zK8B6C+Z59ZluErREE6ea3vY7Jw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv8tO0ub2WaRh0sjljUaBTjrp8i9sKXRBqoo4hPHoyOqO8wj1h
	B+Xw2ymng+jgOx9GIz5s15/NcMO1P9svUQlL42+YwjLqgOoDHqDJrNDP8PkkADMgo84Y/TcuCCO
	5JHn6Ag==
X-Received: from pjbiz21.prod.google.com ([2002:a17:90a:e795:b0:34b:fe89:512c])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4d0b:b0:34c:3501:d118
 with SMTP id 98e67ed59e1d1-35367010b69mr222205a91.1.1769102505221; Thu, 22
 Jan 2026 09:21:45 -0800 (PST)
Date: Thu, 22 Jan 2026 09:21:43 -0800
In-Reply-To: <20260122053551.548229-1-zhiquan_li@163.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122053551.548229-1-zhiquan_li@163.com>
Message-ID: <aXJcpzcoHIRi3ojE@google.com>
Subject: Re: [PATCH] KVM: selftests: Add -U_FORTIFY_SOURCE to avoid some
 unpredictable test failures
From: Sean Christopherson <seanjc@google.com>
To: Zhiquan Li <zhiquan_li@163.com>
Cc: pbonzini@redhat.com, shuah@kernel.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-68921-lists,kvm=lfdr.de];
	FREEMAIL_TO(0.00)[163.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,plt:email]
X-Rspamd-Queue-Id: 28FE76C2BF
X-Rspamd-Action: no action

On Thu, Jan 22, 2026, Zhiquan Li wrote:
> Some distributions (such as Ubuntu) configure GCC so that
> _FORTIFY_SOURCE is automatically enabled at -O1 or above.  This results
> in some fortified version of definitions of standard library functions
> are included.  While linker resolves the symbols, the fortified versions
> might override the definitions in lib/string_override.c and reference to
> those PLT entries in GLIBC.  This is not a problem for the code in host,
> but it is a disaster for the guest code.  E.g., if build and run
> x86/nested_emulation_test on Ubuntu 24.04 will encounter a L1 #PF due to
> memset() reference to __memset_chk@plt.

Ugh.  I'm pretty sure I saw this recently as well (I forget what OS), and I was
completely clueless as to why it was failing.  Thanks a ton for tracking this
down!

> The option -fno-builtin-memset is not helpful here, because those
> fortified versions are not built-in but some definitions which are
> included by header, they are for different intentions.
> 
> In order to eliminate the unpredictable behaviors may vary depending on
> the linker and platform, add the "-U_FORTIFY_SOURCE" into CFLAGS to
> prevent from introducing the fortified definitions.
> 
> Signed-off-by: Zhiquan Li <zhiquan_li@163.com>
> ---
>  tools/testing/selftests/kvm/Makefile.kvm | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
> index ba5c2b643efa..d45bf4ccb3bf 100644
> --- a/tools/testing/selftests/kvm/Makefile.kvm
> +++ b/tools/testing/selftests/kvm/Makefile.kvm
> @@ -251,6 +251,7 @@ LINUX_TOOL_INCLUDE = $(top_srcdir)/tools/include
>  LINUX_TOOL_ARCH_INCLUDE = $(top_srcdir)/tools/arch/$(ARCH)/include
>  CFLAGS += -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu99 \
>  	-Wno-gnu-variable-sized-type-not-at-end -MD -MP -DCONFIG_64BIT \
> +	-U_FORTIFY_SOURCE \

Is this needed for _all_ code, or would it suffice to only disable fortification
when building LIBKVM_STRING_OBJ?  From the changelog description, it sounds like
we need to disable fortification in the callers to prevent a redirect, but just
in case I'm reading that wrong...

>  	-fno-builtin-memcmp -fno-builtin-memcpy \
>  	-fno-builtin-memset -fno-builtin-strnlen \
>  	-fno-stack-protector -fno-PIE -fno-strict-aliasing \
> -- 
> 2.43.0
> 

