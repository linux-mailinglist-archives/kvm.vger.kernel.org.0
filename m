Return-Path: <kvm+bounces-14711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B666A8A610D
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 04:29:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 63AF31F21DF9
	for <lists+kvm@lfdr.de>; Tue, 16 Apr 2024 02:29:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3A6D10A16;
	Tue, 16 Apr 2024 02:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="geFmS6oa"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D740233FE;
	Tue, 16 Apr 2024 02:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713234553; cv=none; b=U/nsdG7CsbybSrW55rfaD6y276NreaNtosQxNbZpoau5SvVYL6lcYCaKisH4Q8Au8HoK0twB0iOJKg84qiRIxuT7ItczmINVmSwf4Zd2XeUo4Rz58L+yNMOEXiDm6GLCx5EI+GSHRnp6O0XH4myf5DGzUvQWnnrBlDDKtoCRcN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713234553; c=relaxed/simple;
	bh=5iU+XhhTd+fybz7n3eyHlc3+k/nj+Dy3UMKk1gHpbZ4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=DOkPNxjGn75UhoomauYXyfGog5CzS/RVHx43TM1tiufgR4ZUBzFngl7gROA2Gd430MknliryAMAmo/DULt9+oI6uW9i8hNx78/s6N5nkv3Ssq82oJcJcIvXYSdaPIUrTGhB0KwXeufBvQyuVfzIoL7WRNy/IJa3haK0mMPU6et4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=geFmS6oa; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6ecf3943040so3058198b3a.0;
        Mon, 15 Apr 2024 19:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713234551; x=1713839351; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iU+XhhTd+fybz7n3eyHlc3+k/nj+Dy3UMKk1gHpbZ4=;
        b=geFmS6oa5k3wtddP7D9MkWHoRDD6Cse04IKhqBvLtQeLDAlw/sWD3/cYjKULPejKs0
         ITJGwU99TKtluUk2NUqVIm9/j3R5/T+UO5GLHBu31aO8tjnGwjLesyOvx3fyFcfbwtCD
         920HcgDZnTF3w5OuCngoCdWTSSd1SQLIBsmqrxr9uJbMXzjt3CafPP7ut5yMJWliYuz6
         qgz8hBpslcDiGHOPePkXB1R4aYew4modc3rMlaJ7GeGjlYpzsXnp344Pngz26DP3ed6A
         CGxGaVzH523iKS8mZ3GQNFR966j0kuj0/NgHoU6A2Rq2RmRro5nub2F30RcCYqlQ5K4W
         ixAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713234551; x=1713839351;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5iU+XhhTd+fybz7n3eyHlc3+k/nj+Dy3UMKk1gHpbZ4=;
        b=C6bZyks1E6om2AD2/s3lYULBKrJh5X+WcxWrOjaV5JShOIXLyGZwZknL+JzqEwQUYb
         rbzT0C/Z9hspswEwO/6qdYIQ4VJfSWvCm/EamG1vdJanfaKs0l9CBjidbCKBMx4aHkeM
         t1om8f2Pq7o04D0qxkTuUXzJYJJtvg/+fSu53VZKcTzIMIBGEg/wxmirKcGZizeHMGEe
         vi/3Ew6O9EYRG6AThIjHhxYs6zt0cQ40yKlSekyzb5i0e8sl9LBxg/sQ/Kc+agqInKZN
         /nEig9rduDvhSAUZBoQ9HU09KWSFNzgBI2OujYDq60KPgwIEK2HxppgmQEyrutYx4bh7
         8JEg==
X-Forwarded-Encrypted: i=1; AJvYcCWJdfO2OYC5XrwymuAQDuw23HgkF7crS3FDenMnBRFGefi8sfDW3kIE06Lo+12e1MDKRs8xKWLZ9y7vMXJpjZ/2UYUeYuErPAyV2Kkt24qQY1hbW1tURxiPVxKkuoSgvQ==
X-Gm-Message-State: AOJu0YzEYQ6GLVqRD5BgYE9eUQs30KJSUZ9R/3zZwC0f2AbtyoXKuW/U
	PAeuZADUdN8yU8Nzf9WAAO8aqBmUGlusb/dvBDAZ7q9G/bmt/GNs
X-Google-Smtp-Source: AGHT+IFEzywwHt2hRakEkq7838HX9fXPyyAWuTOZUJ3YO0ixYif2IEtFi2l27vzeTVH1gYgEGK8GdQ==
X-Received: by 2002:a05:6a00:4642:b0:6ee:1c9d:b471 with SMTP id kp2-20020a056a00464200b006ee1c9db471mr13087419pfb.25.1713234551124;
        Mon, 15 Apr 2024 19:29:11 -0700 (PDT)
Received: from localhost ([1.146.24.97])
        by smtp.gmail.com with ESMTPSA id gx15-20020a056a001e0f00b006e71aec34a8sm7906152pfb.167.2024.04.15.19.29.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Apr 2024 19:29:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 16 Apr 2024 12:29:05 +1000
Message-Id: <D0L6YKP6KN2Q.SLUJM0FJ3H85@gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] s390x: Fix misspelt variable name in
 func.bash
From: "Nicholas Piggin" <npiggin@gmail.com>
To: "Janosch Frank" <frankja@linux.ibm.com>, "Thomas Huth"
 <thuth@redhat.com>
Cc: "Claudio Imbrenda" <imbrenda@linux.ibm.com>, =?utf-8?q?Nico_B=C3=B6hr?=
 <nrb@linux.ibm.com>, "David Hildenbrand" <david@redhat.com>, "Andrew Jones"
 <andrew.jones@linux.dev>, <linux-s390@vger.kernel.org>,
 <kvm@vger.kernel.org>
X-Mailer: aerc 0.17.0
References: <20240406122456.405139-1-npiggin@gmail.com>
 <20240406122456.405139-2-npiggin@gmail.com>
 <e8ea1c30-2211-4060-9cb2-c57364c80ea8@linux.ibm.com>
 <D0G5W6ZJ5ZBC.33NKLB5X3DIK9@gmail.com>
 <f2fa30de-b34d-41cf-9bce-55d1e078b95e@linux.ibm.com>
In-Reply-To: <f2fa30de-b34d-41cf-9bce-55d1e078b95e@linux.ibm.com>

On Thu Apr 11, 2024 at 7:40 PM AEST, Janosch Frank wrote:
> On 4/10/24 06:35, Nicholas Piggin wrote:
> > On Mon Apr 8, 2024 at 9:59 PM AEST, Janosch Frank wrote:
> >> On 4/6/24 14:24, Nicholas Piggin wrote:
> >>> The if statement is intended to run non-migration tests with PV on KV=
M.
> >>> With the misspelling, they are run on KVM or TCG.
> >>>
> >>
> >> It's not misspelt, is it?
> >> It's in the wrong case.
> >=20
> > Yes, that's the right word.
> >=20
> >>
> >>
> >> I'm fine with the code though.
> >=20
> > Thanks, I'll take that as an Acked-by: you
>
> Could you send out a fixed version that I can pick or do you want me to=
=20
> fix that up?

I was going to at some point, but was juggling a bunch of other
things and have some travel and vacation. You are welcome to take
over them if you like it would be helpful.

Thanks,
Nick

