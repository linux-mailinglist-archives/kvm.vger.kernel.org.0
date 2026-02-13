Return-Path: <kvm+bounces-71062-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id AFzFKXJHj2kiPAEAu9opvQ
	(envelope-from <kvm+bounces-71062-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:46:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D6AE137AD7
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 16:46:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 49D613034577
	for <lists+kvm@lfdr.de>; Fri, 13 Feb 2026 15:46:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963D52BE644;
	Fri, 13 Feb 2026 15:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fMtlrD7t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B5779CD
	for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 15:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770997598; cv=pass; b=rICtjIe/YZzkw2cLYYyZKqYFA8Vi7VTilljUJNgn1To2cqHmsuOtBiz1O8MVkyEozR99wdpf/cpbOAWVrx/X/cJePs1FDZsiIdl3PJq8tlvBaTtIg7jR20NQ4vOA6IrJ4+UAIbTJXoiBEKeJgguqTxyGjf2IpRCX86HFkprCL/4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770997598; c=relaxed/simple;
	bh=hLk/0I2GVEJZ/LTM0BOWivxJ+N6F6LucVNpkVZmx2DI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m/hxqqVRYb44wkdqafQoVYq/pXi7JM81sRjKR0FzHBcu+26xsOVDl8rma20jpgmFgP5QBuNBiScYFPW8246kD20pGw8T2VHPqRM+XaaJ4LO9qRLjUmYEIVaLLtD5ZQUPfCrbTW1h8C/CZBNOiQR01Ero79bMVYw4GTOLWnUephk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fMtlrD7t; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-652fe3bf65aso9141a12.1
        for <kvm@vger.kernel.org>; Fri, 13 Feb 2026 07:46:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770997596; cv=none;
        d=google.com; s=arc-20240605;
        b=A5sPN6SY4LBe+QIQ66KXCYw2u8HiqpJNgp3by4M+rTphNMuh+OXIiYnTNMMG6z1hLW
         ahYJgd530nHTCQ0PwhPxV2aIvMoxzLdVq0E9MWm/Znk2D/yMfjJuxeNQORnJsnG9GIKC
         klHjSO7SzKnZvnkgMBIJ5LrJ7zTqq9IJ02+uKp+ale0BkOIKO0heqBrIjGgNhB1KdPNp
         PANwWYrTziTMDNiDh+7U3xzQpDCjABpLB932xYRcMQXNYe6SMKjULpqd4JE2n3dh3d+l
         LXOvhlU5xiKEgNw1QrnXroEPRhvZkr0wTs9Gab5c4hKQUAOyY91ihlAJx39UfBzotdPY
         SWew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hLk/0I2GVEJZ/LTM0BOWivxJ+N6F6LucVNpkVZmx2DI=;
        fh=FeV/S8GoPiOmB2x+yGX8z/ln6/hijesF8sTY+K632Y0=;
        b=gXGaKETgzIqyAx3WvGNgOZnz1GeqA3U/gugYjrBLkP/MFXJBAjxgtLBOffU5wvazpB
         A9TjxFPUbBaNyUv94bdcGLNNpfrqJ7PVt+CGcxraKgegUg4263ivPSNsXaEf4J8PW8wO
         aJ4TVcWOvVLrcttPaD67j3Ex9lTnX7GIRx9VDrhasrhYVN9MoIV2n4kUCSlvubwZtiXr
         RRWamVj+oQGaMWmu6UsW1CvMPWBaSqz/kijh9WZifvXGGt0em3JaZlnBP/bFZ4+KrgwZ
         CcFrt4uDHrx2EJc8fyJ4fYW2nVpdTIoUOLjk4NoMsmBifU1Yyv3KS2aInsLnmPuQqMhc
         hPbg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770997596; x=1771602396; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLk/0I2GVEJZ/LTM0BOWivxJ+N6F6LucVNpkVZmx2DI=;
        b=fMtlrD7tZLTiuVXEZv6S2zf+Vs7x8gTZNwVEDcy1aOsjuFENztLz94sRLQFrCKCu1c
         EunQdzpPhyHv3mec++LDVyPnUopyxdmW7S8DvxbXGlAJxZf1VBbdULbpBc3YatAMWAEf
         WIF5VSHZvN+V9D+UlRGJgT9/jIkNOV+jpRQAGzrLpz0fs12wzo/oDwrkh/PnTS4ba2SL
         HErzhxco4IcgAt0JnCvmGHdgDTdRWJYQjfyeLi89JKEKT6DydlXjS5U8AzhB5jpJnca+
         E8fQPrt5kN7nVp0YkA9SNF8zZeXWDFgilpDmPd3R9cBPgFxqZmwfvBx3J0wAEMUkGrJK
         yYbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770997596; x=1771602396;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hLk/0I2GVEJZ/LTM0BOWivxJ+N6F6LucVNpkVZmx2DI=;
        b=GIYC6Cs+izUh4qw2sSQ659H3nN3og98BWxbd66ekl9JlclVnU77DukbGB0RHtfbdI8
         w3suGBB2OE52ez2/eWyDa1yLj5+GG2fo1vrgimznsJX4nMMHB4yI8cH86/0eMIw6AWHL
         6aVIdVOJnbiQgRrpk4ZEtajieewiqo9c7nqKLWVxAD4GxVYmWnwLOuF9rO9AHGpmW6n2
         +SvhxOlvEJSFhucWrrTvRSM5/zV38tCclWswMAPNAxqOlU4DxWNrIrW6KKpzGP04YDyo
         UC7wUQqmDR8iZWJT/glFzLUEHL/EeK3aTBIzkatH6yA7ZqLYDVrrjkxlFJhEbQIZ8vJ1
         UtIw==
X-Forwarded-Encrypted: i=1; AJvYcCWAmy70xgwhwsquUVb43rP4yRptrq6FKTy11NU/MHuV3qydB5I4vDZdfRdbLAUmHlNemb8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwiqxMwHqTJc1NJhLY68bzCnxIufK86Ctu9EFbVr5+kc0pQKW4h
	YmjoNf8pHxvVFYRcBjMJzcdgp7XhzdqJ0Hcrh0QWW81Kl677Fs+7Lm7byG645NsYE1+gDOcNfW9
	efsefHp0K6HuSaUfz8ojtG40L2IgGwxZoGbsg0z5v
X-Gm-Gg: AZuq6aLwi9nDprxROvblmhLqQJVECyOTjvMcbS9QrHv6alQenmFdeFBGCxhL3C/N0PW
	lgQVlDfOmf6oqyXjcRHdftPw6pS7KEEUO17IURNqfkLsnmhztfmS2Xw1ADRjSDRVRjLm7E5xsyT
	2EzK4NXSBEGV3xJM09YnWIBSq0XHn0BErSKAGgCVssGtiNWvTC5HpprGOFJQv1JmFHCYB5vG06y
	0zTBa8Gy60thQKSrmwqdu3HJjnUpozEumtL7MGwXQ8tLjPlcaA7ytbY91RJFC9RsCyF62Quc+7l
	2EtbeCQ=
X-Received: by 2002:a05:6402:332:b0:65a:14a1:b1be with SMTP id
 4fb4d7f45d1cf-65bb072a035mr23356a12.7.1770997595564; Fri, 13 Feb 2026
 07:46:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260212155905.3448571-1-jmattson@google.com> <20260212155905.3448571-2-jmattson@google.com>
 <f72gve6ia3aqcpkqxzuwnleaxzxmesapzmoaus6bwaibsq5f2g@hgq4z5mqxykh>
 <aY9CqmlpZb2Unh0y@google.com> <phcxxcpm2uum4pa4ny3icvy7u2d5kp4ctey6mff36xnz4u3hzz@oyjzgp2eobry>
In-Reply-To: <phcxxcpm2uum4pa4ny3icvy7u2d5kp4ctey6mff36xnz4u3hzz@oyjzgp2eobry>
From: Jim Mattson <jmattson@google.com>
Date: Fri, 13 Feb 2026 07:46:23 -0800
X-Gm-Features: AZwV_Qgmauvz2wqqAPGDahWgOEuXYp-qk86-LEGu_8x9HXEZulNLXMzBZa6DLWM
Message-ID: <CALMp9eSrV+G+8kDMehhMk5r2ZNugbkbxxnNUwqH5XiTJNL=nXA@mail.gmail.com>
Subject: Re: [PATCH v4 1/8] KVM: x86: nSVM: Clear VMCB_NPT clean bit when
 updating hPAT from guest mode
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_TWELVE(0.00)[13];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[jmattson@google.com,kvm@vger.kernel.org];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid,linux.dev:email];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71062-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	DKIM_TRACE(0.00)[google.com:+]
X-Rspamd-Queue-Id: 0D6AE137AD7
X-Rspamd-Action: no action

On Fri, Feb 13, 2026 at 7:33=E2=80=AFAM Yosry Ahmed <yosry.ahmed@linux.dev>=
 wrote:
> Funny enough, I removed all usages of vmcb_is_dirty() in my series, I
> just didn't drop it:
>
> https://lore.kernel.org/kvm/20260206190851.860662-24-yosry.ahmed@linux.de=
v/
>
> So Jim was cleaning up after me :)

Sorry; I removed it when handling the merge conflicts, thought about
moving it to a separate patch, and then forgot about it.

