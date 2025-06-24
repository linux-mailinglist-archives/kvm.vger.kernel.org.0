Return-Path: <kvm+bounces-50490-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id B55CEAE66A5
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 15:36:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D4A2E7B3E37
	for <lists+kvm@lfdr.de>; Tue, 24 Jun 2025 13:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD6952C08C8;
	Tue, 24 Jun 2025 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=platform9.com header.i=@platform9.com header.b="t+3qgmfq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD877291C16
	for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 13:35:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750772156; cv=none; b=njrI4nOyeIR4XNOcgucdPZOyZRF5+H3V6KQKveBALUzmiXRc5eoIVwExMH5k126Z/0oswtxCLXmFAg14eEOCFVHIElmGJS4oLmEg4NVYMqM8aAdlvPOWZcQd5yLgJI1LtiT79xbZW9NiE514/kj1G9f/Y239rjSY/B/Bh3HAukQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750772156; c=relaxed/simple;
	bh=N5ecUHNrO17t76WEJfeax0nf8QNqZiypvNAhpsIB9pE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=rJotuuhGW9Ajjy3YQtr3fFLy4rEvbkKLg19uQEo9LBxIOOrvu7duiDTjjzBR27MHC5I8+WNSvB6WP8JFij6jR7WSddKt1jF/5ccp2key+qmu3YBhPI0HokrENQXWdr/IUPIy7q+8eR/kJahdhj+ruELKj1qwueX0znLzExKhH2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=platform9.com; spf=pass smtp.mailfrom=platform9.com; dkim=pass (2048-bit key) header.d=platform9.com header.i=@platform9.com header.b=t+3qgmfq; arc=none smtp.client-ip=209.85.216.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=platform9.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=platform9.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-31215090074so7413036a91.0
        for <kvm@vger.kernel.org>; Tue, 24 Jun 2025 06:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=platform9.com; s=google; t=1750772153; x=1751376953; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=N5ecUHNrO17t76WEJfeax0nf8QNqZiypvNAhpsIB9pE=;
        b=t+3qgmfqddrf0Fa6HVFlzMONgnU6D0GTLC3Xtpae3KgK+z97JQl5Zt9o61EH2cD5J+
         ssASrmI3mdaVv+ErY7LIh4malHugmyLRvMztfobOMSDFA8VO20UT4L/glLz9/EN9YUUN
         w4+odg7lQNPXalrxOwdA0ar1HTikHkD5hpJ4a5sFtWCYvHjnIYHAxWjiOQuNgbLjifWH
         o/Ws2DBiqbIyBlTXh2BFtV23DRiLgp9757t2ievkXSgavElRJ1oXhfkrOlNa2Q6ah7W8
         J0OgKpoRVNU5GPzxZl8y265x/Sx3t1WV6Zz4ytC5KEdPtjZmMPAx+ccqVJIaF3qofJSE
         N5LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750772153; x=1751376953;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N5ecUHNrO17t76WEJfeax0nf8QNqZiypvNAhpsIB9pE=;
        b=PteFL+uj70nq8+uSugeyYxXl9TzOYK4tFETab7uQ/JUZo2M8dpDEWcjwG9+F9c/PKX
         NmeeQMKOO/R/uD9K2GEXDMmj9YvsbcwCdkahe5utBpqgs3Y0vOFx6kQlP6zaOncC8Rz/
         ge/hAmVFeZLK8mpY1biHl5URINuuVRo1SF9rzI42vsC0pk/AHcidCwvyzHp8cV3gBG6D
         2NrXr+zSFCgDj5/Nxa7qBeQ6mHdF2xOlOI6PtyGKi8jeTZUTaly62RQTPDCgZDgbLG9q
         QFSS9QJ9Wji96solI16owi3humnSHT64dhHAOqx360U8Gzqr5t6Slwa+Hwz10Um113Sa
         PavA==
X-Gm-Message-State: AOJu0Yz+iXZQzLmxqRJb2IQEJvFWgmdiZsoS432Ze5GuI2ZZIVpmbw0j
	opXS4P1UadTatua9GqGYgYi6fjR+ytAkIZ7PbEIvVkX+mltDWJAwQ1Fh3Yo8nDRhGGsQfbeqV6O
	5APTkIN3zwsY8QCuFoyFYZwUgtQR1sghk6qn/KS/aXjD5e499ce+976GJXQ==
X-Gm-Gg: ASbGnct90mxBWWU+BHw99qBVY/VFno98PJ4zYkmWK5J8wannCfKag974kfrs52ZZQBc
	V7yeZgY4eHUIamiGpjLPQ1w/qCkv4ZcjDV1lRshNLLDmDfpRELf+HtpiPMBLC7dD5rovJwdQfS7
	/DDh/YpGU98UIOEdJ0wTnXIib074kIVFqXZ8cpNhbcJZLsqgEwRb+f5LguiKmlCtKmmuh8JZDUn
	Lrf
X-Google-Smtp-Source: AGHT+IFmkbv9IYNTcXJSLxCs+BVlIYodlc0CF59enDdrqdFxX0KRhaIARyn+jhS3RxG1BfB81YTfF6fbLnmWJnEX6jc=
X-Received: by 2002:a17:90b:582f:b0:313:23ed:6ff with SMTP id
 98e67ed59e1d1-3159d6206ffmr22165785a91.1.1750772153442; Tue, 24 Jun 2025
 06:35:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Damian Karlson <damian@platform9.com>
Date: Tue, 24 Jun 2025 08:35:37 -0500
X-Gm-Features: AX0GCFtZaRjz7SWFLkpXeSXw8jd_hihKoNAPQwat2efvVbotShrWI9MhcKWLYdU
Message-ID: <CAAnM5EXYUXD5qxNHr4KmXWrd9865oaTTNzUZC5W_WOSOgna7VQ@mail.gmail.com>
Subject: Admin contact for linux-kvm.org?
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi folks - I'm curious if there's an admin contact for linux-kvm.org
that can help with updating the listing for Platform9 on
https://linux-kvm.org/page/Management_Tools

Thanks!

Damian Karlson

