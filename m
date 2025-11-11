Return-Path: <kvm+bounces-62820-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 69D8EC4F9B9
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 20:28:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id EE77B4F2958
	for <lists+kvm@lfdr.de>; Tue, 11 Nov 2025 19:27:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 845F6327204;
	Tue, 11 Nov 2025 19:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nQu0sUR7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DC283271E1
	for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 19:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762889235; cv=none; b=eRMRNgGwUzwsrBNpfLtXxjqm31kC+hGOr6JuRcV/Vk0ahkoubp2YCHhWBPLi/B4VMeNI3fXUNF9AHwearav7gScVsWMcyG50VDK21rRKvDMJTn78wvd+/Y8zysY6CnkoYItGOZMpgI+zou05qwzxrE/adrrKDUBy9JdvUQ8u0XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762889235; c=relaxed/simple;
	bh=T4q4eI/PjUjqDPpGU0Tf2NYnENnLstWCYa50yyn4bPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t2v1SdbeCRPnIAPqODcCtg3SqGsedLfQ5ykggviesk5r1K+D8fbgAK4H0K3Q+HcitPiHxLpgHpCnSl1Vg6P+IENv8V7y9Jy8JlgqMcMvcxZ1rp09wUiC1zLnVMyR3sZzm56uuVCDRRRBo3cYrwl84G6zyrlqQGIj1TZZrsemgZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nQu0sUR7; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5942a631c2dso38875e87.2
        for <kvm@vger.kernel.org>; Tue, 11 Nov 2025 11:27:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762889231; x=1763494031; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T4q4eI/PjUjqDPpGU0Tf2NYnENnLstWCYa50yyn4bPo=;
        b=nQu0sUR7DB7tDzowR5qZobA4FUDiRlSpO6wWrJ6ejebQBijIGVgMizvWluGbRYGHrI
         MmpeIczgC/b9cTkdMIGSud/jVbR5GCP8rm/tsVg5eGBvOPLYD5kCr4F17bkv4PsHxc4E
         LIAotl/MOOd9P5dPuSxOpUGTIPl49BCyvxtwP4WnvB3wHKbxJrK2ObYjyNfkKn7pSGW7
         7VzU781J9WU/MYo6jEzuR+W6p88/KcfcXEO/y09pPmbHuh7Yg53jk05HcVW6YZdNocE6
         a2VKZkaCz/xB8LEI15xi9Kqmy1haib4TfKy4aYVXuhbN2VEWOuJI2mAEE8wVACSaSkWB
         RCGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762889231; x=1763494031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=T4q4eI/PjUjqDPpGU0Tf2NYnENnLstWCYa50yyn4bPo=;
        b=e1B02YqMIp+WbR4Jd9MaKcD9ZX0Kb+zhAfn/0eiHKUzj9Tx361iUAt/YrH3MeZIcEO
         KhN9701P2CT7Q/M5IXxkJ8IQHls+s/bzb5QN7MFjOe5qHSxW9vXJycIvC4ijbAn2/yQs
         RLHivzVizz1EM6fDIa+eK8YKmmgbNqVwmcURJj/dlmEODkMcoqkqmYMKw9AGNpdnbn/a
         L3TxeaG3ySa3WElLlaBHtf2wAwihw81HauRxkGFUCLJBqFS7V9DWhnQyn04aqacI62J2
         BToniNU2AyH0Jb++8b70DNT/aFU+WC554+CQjPHO0owrAxC4GhQElqCrM4rnP/d5Xne8
         ij7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWkzjK6pTWPSfZ4LiWYuj56YUbbysSO276AWlY9pvKjWp+hzVXNBhBP8bqF9WCGhxd+xyQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YyYsfhqopdlNmb/9spk3nJTC3EKO9jSwnxztLPnAZgwjCr00n76
	teZxXpdhrq1tDBG0EdzyiRVAfDMyWuvEfUQVltcuKbB45cnF/ZS/H/2HvskpeJqGcuWx/tw+ZK/
	MuMDxu9dvZMl8AwXkebRxBIVc5kQmKw3/4F7kpRCq
X-Gm-Gg: ASbGncvN5D23HDQPReJqq2OC5PdQ8F4tfNMs73f0xheczXmux0cN54UThvyIj8d2GHN
	M3JzuufDNLXXlbyfS86GV4ICH4hT9rnbBcqFiw4wvNuldkuZICajNxooSj/K6ld2PzB/OUj9OUY
	2a90e6oLEEto26QXp8bR9E2rJNskOXjqTiowzos0Oh870Wen9cFfHy61/s8EdqwnEuVyb63j6wt
	npaCcCffV3i+xqiaATtqsShP7akrRmlZDM7JDQ/suh3gNryIaKjhnRH3cBer8RYJrYo27E4EVVR
	kyRb5w==
X-Google-Smtp-Source: AGHT+IFsoUNsZKjerOV56G4XYKfZyWvAntKSJGGhk3vCYo0YWbEwNmd5TjSqbsr3l2nPJ1TiKUWXTC0bT2qotuyukbQ=
X-Received: by 2002:a05:6512:230a:b0:594:750e:1f53 with SMTP id
 2adb3069b0e04-59576e13618mr100574e87.25.1762889231088; Tue, 11 Nov 2025
 11:27:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251111-iova-ranges-v3-0-7960244642c5@fb.com>
In-Reply-To: <20251111-iova-ranges-v3-0-7960244642c5@fb.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 11 Nov 2025 11:26:43 -0800
X-Gm-Features: AWmQ_bn4dxVx1lBNbH8PWoRfGDh1pL7JrgTYZHIYTl7d2EJCVBbNB8Ju5ASDoi4
Message-ID: <CALzav=cmkiFUjENpYk3TT7czAeoh8jzp4WX_+diERu7JhyGCpA@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] vfio: selftests: update DMA mapping tests to use
 queried IOVA ranges
To: Alex Mastro <amastro@fb.com>
Cc: Alex Williamson <alex@shazbot.org>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	kvm@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 11, 2025 at 10:48=E2=80=AFAM Alex Mastro <amastro@fb.com> wrote=
:
>
> Changes in v3:
> - Update capability chain cycle detection
> - Clarify the iova=3Dvaddr commit message
> - Link to v2: https://lore.kernel.org/r/20251111-iova-ranges-v2-0-0fa267f=
f9b78@fb.com

All tests are still passing on v3 for me.

