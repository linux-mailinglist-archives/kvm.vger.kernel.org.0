Return-Path: <kvm+bounces-27412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4C387985742
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 12:43:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B41C2845F4
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2024 10:43:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F073B15E5CC;
	Wed, 25 Sep 2024 10:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JHNhgznO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4611304AB
	for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 10:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727261031; cv=none; b=uqo4Yu6RyQizIwInfZu8YkMTbCssRZ47Liw2ARTBbUhHyAv6dl8sTd+hj1gWtAIVLyP96/jO93ZwwkbPxVgmSoeAo6BvsZHQsR7uHHHCmyx3pE9rGclX5O/TaAbKWVn3Nnwap5WB6J/9MmaLwL3MKzXlZFJaRH0FtR7rFfUHPAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727261031; c=relaxed/simple;
	bh=KEyLcbbUmoimlSxWtCc/AqtMImzoDYNz7E3YoARLTFU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=uM+wNFNnjFs/xbBBbUMkyDsr6Ydo4Yq+0VXnvpcQGrktcAfOZQN0IfZ0URWkynQkKYb2xm060ELxhdqKbxLZSJ243WhIqmSEghO45lkJqgVYrB0lcl2AVNWUDsQf5wdO/8bCN/F5L4tDME5JiKa/ObfGJYVcEAgBXM1lvj3raIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JHNhgznO; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-a8d2daa2262so840248966b.1
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2024 03:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727261027; x=1727865827; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KEyLcbbUmoimlSxWtCc/AqtMImzoDYNz7E3YoARLTFU=;
        b=JHNhgznOimBNfpcSgSLFtdNCPZiG3jaUD1El9u6PSTa1jRTDdb4mwFkeJRSerQciF/
         OisO3uwGrq8pBV4HCNx/BR0izpZLcMhx1bEOoPp1LMH6oTYP577SKUW4aehGO6yqJ8Uo
         BmFgknaaICUZpp1gLf5u9OkKQXrECa104sfQQhCtNDW+iNFaTZCI6IUhLkUdYuGDa9PR
         n5dMxEBKw2Wy/u6mKlQ5/kCgcm7N6O7YDNOs9EjtL0CfBqHTIPunYlTPixsYjjQenQaA
         7xl3Bflj7lYhE8h03S7CxX7TMx+Ywv14PbGlGjmIx/UNa9ukEO+8kM5KD1zFdf4ZNPEL
         bC+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727261027; x=1727865827;
        h=content-transfer-encoding:mime-version:message-id:date:user-agent
         :references:in-reply-to:subject:cc:to:from:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KEyLcbbUmoimlSxWtCc/AqtMImzoDYNz7E3YoARLTFU=;
        b=eRErGk/+KDTlSQXcoZbrHMaLDDk56w9PaPLyMWK1KT9DUyKHwvDfYmC9NnnthK70pi
         rIEacZOtft3GDn1vI+tmgx9OV72g0MAeKrQvV2g8O7bayJU1+vE8PYYTl4FKqoQF1BxY
         Rydvxjb6g0eSJOT/FsZkdFvuFkSJ6RLuWnq7PPqVPE+vqOd+5gyxmnXcDD9fmoDwOCWF
         ajm0jV2VZfHXqzpaaHiiEsMgWUYCQMHFZyuJsyyj4EzFryfsG/wNXmbRpo819R4Y+NSU
         eQbtrha0FY9rjq4uASJqQouisbyay0wVoJaOhtKw6Z8LFd7Yw6hr8k6PVLB4ZvulNfxD
         UFxw==
X-Forwarded-Encrypted: i=1; AJvYcCXe4mErg6W/nGmAqe0FrVrf4p+p/i29B6i75OEu3+D+4J+H2slvaKROpNfLXCjZvIT98bM=@vger.kernel.org
X-Gm-Message-State: AOJu0YyCMquOd7dmr7SoywAbKfHMT0K4HXJB3MWPHi8hc+Z0dotAL6KW
	XbVGczKaisVKpTUPu4RK+3B/G+qVgVwQIUg+PDgDpjh6HAZOJ4iBQyIduPlto/0=
X-Google-Smtp-Source: AGHT+IHLwSMuBlfv82ofByDVJBnGyj1eTbb5/5Lk5t91jXVWPw3N612xva9I7YnIAmKK8vq2mQmT6g==
X-Received: by 2002:a17:906:cac9:b0:a8d:44a5:1c2f with SMTP id a640c23a62f3a-a93a03200e6mr198321266b.6.1727261027535;
        Wed, 25 Sep 2024 03:43:47 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a93930f470asm194654166b.151.2024.09.25.03.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 03:43:46 -0700 (PDT)
Received: from draig (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id E309F5F885;
	Wed, 25 Sep 2024 11:43:45 +0100 (BST)
From: =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>
Cc: qemu-devel@nongnu.org,  Wainer dos Santos Moschetta
 <wainersm@redhat.com>,  Richard Henderson <richard.henderson@linaro.org>,
  Paolo Bonzini <pbonzini@redhat.com>,  Ilya Leoshkevich
 <iii@linux.ibm.com>,  David Hildenbrand <david@redhat.com>,  =?utf-8?Q?Ma?=
 =?utf-8?Q?rc-Andr=C3=A9?=
 Lureau <marcandre.lureau@redhat.com>,  Philippe =?utf-8?Q?Mathieu-Daud?=
 =?utf-8?Q?=C3=A9?=
 <philmd@linaro.org>,  kvm@vger.kernel.org,  Thomas Huth
 <thuth@redhat.com>,  Marcelo Tosatti <mtosatti@redhat.com>,  Daniel P.
 =?utf-8?Q?Berrang=C3=A9?= <berrange@redhat.com>,  qemu-s390x@nongnu.org,
  Beraldo Leal
 <bleal@redhat.com>
Subject: Re: [PATCH v3 0/3] build qemu with gcc and tsan
In-Reply-To: <20240910174013.1433331-1-pierrick.bouvier@linaro.org> (Pierrick
	Bouvier's message of "Tue, 10 Sep 2024 10:40:10 -0700")
References: <20240910174013.1433331-1-pierrick.bouvier@linaro.org>
User-Agent: mu4e 1.12.6; emacs 29.4
Date: Wed, 25 Sep 2024 11:43:45 +0100
Message-ID: <87wmj0ypwe.fsf@draig.linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Pierrick Bouvier <pierrick.bouvier@linaro.org> writes:

> While working on a concurrency bug, I gave a try to tsan builds for QEMU.=
 I
> noticed it didn't build out of the box with recent gcc, so I fixed compil=
ation.
> In more, updated documentation to explain how to build a sanitized glib t=
o avoid
> false positives related to glib synchronisation primitives.

Queued to testing/next, thanks.

--=20
Alex Benn=C3=A9e
Virtualisation Tech Lead @ Linaro

