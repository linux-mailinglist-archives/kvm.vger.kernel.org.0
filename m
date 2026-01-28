Return-Path: <kvm+bounces-69405-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qLWEO01eemm35QEAu9opvQ
	(envelope-from <kvm+bounces-69405-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:06:53 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D070A80B7
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 20:06:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DFE6E3037D49
	for <lists+kvm@lfdr.de>; Wed, 28 Jan 2026 19:06:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEF5C372B41;
	Wed, 28 Jan 2026 19:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NgCILPcN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25F0309EE7
	for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 19:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769627194; cv=pass; b=trLMW9ShF4lVvvXXsmqtkIXjg2jV4x1wPnDd8W1gvkU4Knk6GwUMyMsEr6SNYIYhMfIevAI9oCWb1xTa/yPH4Z6YGg7YQFebWCGiK4fMW+tL25qPrfjeREd6D+Q7w8CMN3QxjIGp/RseMiFQgIrsAw9MrxTcL+W4Rv/l5ibanl8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769627194; c=relaxed/simple;
	bh=9ERFjcMxrp1Lrat0Wg1Z6M81o4oaqai31qW//33Vyio=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qPX/jdCDGVPIbIkL74rmW1BFM1GaQzubB2ZjpgIeW7k/gURfdiufpFbO9If1GNy6yhJXjo9h0pAJYtcTZREjOSStSIiJWnjH72eMXCLb2eN+WydWQpnRWV2oNRlY98wQ+yoL4EyBCnsO+CqrOApxI4HiKJsg88Mimz0SwWOLdNQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NgCILPcN; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-59b6c89d302so124356e87.1
        for <kvm@vger.kernel.org>; Wed, 28 Jan 2026 11:06:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769627191; cv=none;
        d=google.com; s=arc-20240605;
        b=IImvfoLZIP875V9yPSQJAHA18iwP2PPOyn8gFM80mYIhswYCsPh/GLACkM0FMRjisj
         RBHcSesYBAWZ9W0/29z+0fThyxg+yalq7H7DxRpoRc+OD0tD/oNH0ypfhmplxwPNs8io
         ePxujJ39QrD7jSa1Vakr26xj7SYGcHArNUxfT2hOQsUsiO1l1IME7S8PSIQVlAP1QhbH
         GiYvqA3LvuHqbKsex5l76Lpzf2sYxL8KT6OaSPxEsyz9yVVAfbBIceXY/V7SSAk/fEtI
         XBJ/2PSI+nGMuIwt1pioTSAq+FSw9CmIS3RKoEauPvmKcshU2lz9kM/mBylV34W4LTgP
         GCPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9ERFjcMxrp1Lrat0Wg1Z6M81o4oaqai31qW//33Vyio=;
        fh=a8/qF+4n7HoR+D+mCxRxRr9A0RPXdnic5lRf22K1l6s=;
        b=TG8eazrNFmEso2RzCys+kNm7AmP1ie5gp5GZffYTas2M2hpRbF0gTcSikmVEUs0MD/
         +xwN/wwB41QDfKPAPNqRj4dvhcndFBVVkHnlNsaR4lW4fpluP4LFnmYBZ7dAhepIlnJC
         CKwRJc+FL/VDAIj3KpUWBYTYXPDtSBl16LMH+yr1W+XJaiR1i7zZMS8Euz8iRovObpCZ
         PIsrcotLaHEKZRG0NwZfURTm9C5bVEg/xd9VdZ4afVL1WGe4TP6b34FJce6hZXcw8fga
         bvAONfy3LEo9wXtatdl0PsZjZkmHNf15KCpQrkhNmg1AVxL8CKConlbZAhoDsSqFKFbu
         QNiA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769627191; x=1770231991; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ERFjcMxrp1Lrat0Wg1Z6M81o4oaqai31qW//33Vyio=;
        b=NgCILPcNSwS2HyBL1jvIf+akIMpYcyDfheerY2E/wsh0RrcfuqysqK/t1dD6VlnCjG
         YhUmcZLzjbyc4mY3JiNcQhVe9Zh0Bw9N+vFO1T6T6/1P7CsRDa+Qq7X+rbf7XwnYVFbu
         VJjRuVjW4yBMb4tQTEM53oK1IhXIp6I9BHvFp66JvZ9G2fMKzR2ob2A2L49YyO6mkGZi
         C5PGgT7U08ofPeVP7csO07kb2DlsRauJG2ThSsQtKTk4hW1M5x9g5MLwtAe3QgOjT3mc
         zqXXDNTcNV9KvN8i+pXlFdsFPuKlOIHBZJW5uXWyYiyT5cilcxsrfjFllqPs5PeRF2Tn
         BENA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769627191; x=1770231991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9ERFjcMxrp1Lrat0Wg1Z6M81o4oaqai31qW//33Vyio=;
        b=dA3n6Kj60tPLIIE1FFpurWgMlhUpM18GPE5eSOhALFO4j0PowKxe6WkO1zKAmf/9Zs
         u5phFKVXOoKJj0kAvRqQsQiu00unpkdScBvQDjogE7vEld1vVjXyQkz2M9YCQVnjiFzh
         nzJJz5kh9jD+eWuQnv6kLFZvnTJgznvNDf3N2dCu3AT5En69JIIjGsYsG51bLq+oW4kl
         JtCeJU3+EhTsxSDXwWHRpMjCYnK0IskjQ+PDQLciBb41yymmtgHV2nXWiNI9oPwwZLE6
         fDIEWZ7UlYYHN60+1mqCHjN6jXC3tscG5TqGr9aTgrLikCLsDlETJYS3C1PWwQWdczcU
         BJOw==
X-Forwarded-Encrypted: i=1; AJvYcCWboJrbWF77A3fBNK46tF6kPu7ynlU0HIyEeV9cX/uGl/ExbvjBjOTmBlAT55iyE/T0m5M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy577wh0IFcIEhGZ+qV7JoIU0r2zUlv/UDzFFgyh82ytENALkzA
	IPYK8PT+chbANEtk0s2P8g2VQJFm7w8+oWcUCU/XdfFFLE3AXJ5McxV5Efz69bv9HNPjLXTJhO0
	ioFHeN16h/WeoBYVInrlYE3FU18ucPIj34RGcnXHcI5+NvsxNMpdNyhBttww=
X-Gm-Gg: AZuq6aLdTk+sw6IFnAF3g3NkqAE1/F3dIeUpMcV5q5/g1BjFQ7AIXwKNWl3CG8rZ2D/
	WEfV2hNYmjABGOSGTKWLj0AJrAHjTYNPN/llY0Ig1YOPDdBGdCD3q7ej6br9NVsbTVwylJXtUOu
	6sgyjTBuwBjh+vnF6UHq68ARaavmowvXersGxJIUtL+l1IxBX6VZAzBjW3zPN4Vmru8sonko7Jp
	DfEMZ7mtOkdWLrx503ryvBiyPW5yWoZCIpfhRibOJkzQ2R/iV0yT9Pw2oRHh4VogKjpow==
X-Received: by 2002:a05:6512:800e:10b0:59e:476:a1e7 with SMTP id
 2adb3069b0e04-59e0476a285mr1721613e87.14.1769627190621; Wed, 28 Jan 2026
 11:06:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260128183750.1240176-1-tedlogan@fb.com>
In-Reply-To: <20260128183750.1240176-1-tedlogan@fb.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 28 Jan 2026 11:06:03 -0800
X-Gm-Features: AZwV_QiCfY-gKazxXujHuB-Px-mOodRPyZ3KnKJr-7oxiY8ldmqZpZW_6Z2R1Uo
Message-ID: <CALzav=dMhycS2iBxkhPCz3tMUKxkfgr1dCLFGYzGuXZCeYhijw@mail.gmail.com>
Subject: Re: [PATCH] vfio: selftests: fix format conversion compiler warning
To: Ted Logan <tedlogan@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Alex Mastro <amastro@fb.com>, kvm@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <lkp@intel.com>
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
	TAGGED_FROM(0.00)[bounces-69405-lists,kvm=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,fb.com:email,intel.com:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 9D070A80B7
X-Rspamd-Action: no action

On Wed, Jan 28, 2026 at 10:38=E2=80=AFAM Ted Logan <tedlogan@fb.com> wrote:
>
> Use the standard format conversion macro PRIx64 to generate the
> appropriate format conversion for 64-bit integers. Fixes a compiler
> warning with -Wformat on i386.
>
> Signed-off-by: Ted Logan <tedlogan@fb.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202601211830.aBEjmEFD-lkp@i=
ntel.com/

Thanks for the patch.

I've been seeing these i386 reports as well. I find the PRIx64, etc.
format specifiers make format strings very hard to read. And I think
there were some other issues when building VFIO selftests with i386
the last time I tried.

I was thinking instead we should just not support i386 builds of VFIO
selftests. But I hadn't gotten around to figuring out the right
Makefile magic to make that happen.

