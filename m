Return-Path: <kvm+bounces-63718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D76F4C6F131
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 14:56:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id DE10F349BE1
	for <lists+kvm@lfdr.de>; Wed, 19 Nov 2025 13:48:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 940AB35F8CE;
	Wed, 19 Nov 2025 13:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nWBoq1Bi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4C335E544
	for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763560110; cv=none; b=jj/Y8M1hmPLGEJBH8Gk6dHs4hY1Q6uH5Wvgt4aVj9aRegKWR0GaFDUOWymx6Gw5d30vubDHuxXnIpWBh0cI6/NAatJadXMUVqMPhcXGO4vadngAb13PCdmaaRYPW3MKKOF6MAyMOe8lEQk/EYj6/2il3K7sCxBNfweA+nUqIOhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763560110; c=relaxed/simple;
	bh=dUZz/EGTXNyXTJb3zRKoJd5YmLpYLOqdOWG1Mal/clY=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=lR+DBv6N2Y2U9/It8+FjUjoZacnT9+avh+qFJ51p+G9uWAtfe6UL6hxTV3d8X5hSWC+haXAPCaQ9hRikUbsMqImdmE4wnYLLkUyUZhU+KwcVbsfD5Sk717e9VeqsI3plKPpAO89FnQ+ab7K/p4xgaGhOTEgvw1GA/n/7lIveWZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nWBoq1Bi; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47798ded6fcso17322805e9.1
        for <kvm@vger.kernel.org>; Wed, 19 Nov 2025 05:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763560107; x=1764164907; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUZz/EGTXNyXTJb3zRKoJd5YmLpYLOqdOWG1Mal/clY=;
        b=nWBoq1Bip1HXMWEwnLwcO2PNyZXrlnvUmsjW0xpZoKP/trXQq0gNV2SLFqop0iF4rC
         WDfOdvMch3j9UL6yHA9vqWjJCHx8ga5m5OP2cOpl/4sY/UNw72EVHhAdKjgzOk4sWd0W
         wEgPiDHraLmMbNCZ7iJ4z5N80d6K+sz8EqgRpdNuSE1raV/ivi6gNVGWks3i8mDfhqCk
         QQbM+N8pKVmGfjPIsZy+xMrqRXbZT+UbIg7YIghjJw+QcS0PxG8qfhDAHPHOAZshX+h3
         kmtT/h06gq3ORt3mzcaDb/cgDWddNZlJ7IOTS0iam4j0TBHgrsjj0zmcg3sR7Z5yY8zl
         hEpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763560107; x=1764164907;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dUZz/EGTXNyXTJb3zRKoJd5YmLpYLOqdOWG1Mal/clY=;
        b=flg5yckQFU1bP3B+Y1MsGnwy2l+8Seeryh/PH73Z1MWsjnO2hbpd5bspM3y7vyJ+/7
         KS0lrr/Ft+qHbe+E6nuwtdMcxrtNP+UMPQ49JyVEKmR4loKf2P4YEFywSbaEZKY+6+XX
         cKXh49am4VGYXyt1NbZFoWO1KYlIGHa77mprd5Z3efcxKFYIcm738/D+RtejopNDlfnv
         NJJus1QY91WZmMnxP3WvLYZuWMqVnzOIfg/IyyVBUSs4BpknOSYLa0joC4AwYLmi/5qz
         WtKTymw8CPKdE0lGHWcLZYZekJTTwFClA7gCXKy9iPMI3sDdx/ug36c+1oLVF3WvbXsK
         iyXA==
X-Gm-Message-State: AOJu0YyVLsAwh6nbvwWVUeQAiNXQt4tOKcl8NqUC/2VEdUVprIchqd+7
	9bEGiEK98RM1c/iObWikJQkZbLhk4QzT83y6iDaiFApackZ/0UBQjIJV
X-Gm-Gg: ASbGnctqxO9WTzpMjw9r4lFWVm0E0RVURcPwxIp2BltO6F9YdEskw5/L0nnt6BO+TC3
	dvvGO8qKhjPpODdXRknU2i+fSzpOnsQjci9pWgSkxgOfGKzkQskP6ROholjlxh0vP3IKuXWPoVO
	JeDORAt4DfB+P/xGolhtwMT+FIcWwMo25KSMPeG26/7pZ0dqk8C2n0MkTN7FOiyLnw6+UsjetVD
	fOpo/VndFesQkkhSBpn2rAZhy1xgwcHA7w5LMOw1/rl/ycJ5h7++/Qedk67F/rkSQuaXrsQKcBQ
	Nzna2sH85rhYgo0pRgRNfEK1GzB9/pNNsbuK9zO+Fui7D3jV99jAFlVHt/RqD5/ewYHCsM4aopt
	TJ14DTC8ERfalFJ6NylrMjJwuwJqaWBLAAC3mtWgPeYCON1TfhjKczMJwR4JVIAx6EgLq03JVf3
	SBwb/EZXf3MheXGOkjsKFNF3EdYP5AjSQ=
X-Google-Smtp-Source: AGHT+IEO/r2yjXRo1vsrIYmRAWR3LX5xjMNvgtEI6xtFpDqm0QsABV6tIyV/TEUGoCBLoYPW7a2THw==
X-Received: by 2002:a05:600c:3b19:b0:475:daba:d03c with SMTP id 5b1f17b1804b1-4778fe62088mr166989585e9.13.1763560107125;
        Wed, 19 Nov 2025 05:48:27 -0800 (PST)
Received: from smtpclient.apple ([132.68.46.63])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477b106b03bsm50714925e9.9.2025.11.19.05.48.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 19 Nov 2025 05:48:25 -0800 (PST)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20251119131827.GA2206028@e124191.cambridge.arm.com>
Date: Wed, 19 Nov 2025 15:48:13 +0200
Cc: kvm@vger.kernel.org,
 alexandru.elisei@arm.com,
 andrew.jones@linux.dev,
 kvmarm@lists.linux.dev,
 Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D63D4CE9-431B-4F76-B769-C4FFB37B76AF@gmail.com>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <20251119131827.GA2206028@e124191.cambridge.arm.com>
To: Joey Gouly <joey.gouly@arm.com>
X-Mailer: Apple Mail (2.3864.200.81.1.6)



> On 19 Nov 2025, at 15:18, Joey Gouly <joey.gouly@arm.com> wrote:
>=20
> On Thu, Sep 25, 2025 at 03:19:48PM +0100, Joey Gouly wrote:
>> Hi all,
>>=20
>> This series is for adding support to running the kvm-unit-tests at =
EL2. These
>> have been tested with Linux 6.17-rc6 KVM nested virt.
>>=20
>> This latest round I also tested using the run_tests.sh script with =
QEMU TCG,
>> running at EL2.
>>=20
>> The goal is to later extend and add new tests for Nested =
Virtualisation,
>> however they should also work with bare metal as well.
>=20
> Any comments on this series, would be nice to get it merged.

I wonder, does kvm-unit-tests run on bare-metal arm64 these days?

I ran it in-house some time ago (fixing several issues on the way),
but IIRC this issue was never fixed upstream:

=
https://lore.kernel.org/all/C812A718-DCD6-4485-BB5A-B24DE73A0FD3@gmail.com=
/


