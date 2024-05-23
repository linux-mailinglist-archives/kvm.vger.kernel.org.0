Return-Path: <kvm+bounces-18050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5C308CD619
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 16:48:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 18C271C21469
	for <lists+kvm@lfdr.de>; Thu, 23 May 2024 14:48:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FEA77482;
	Thu, 23 May 2024 14:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nslwjTgi"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF47E6FB9
	for <kvm@vger.kernel.org>; Thu, 23 May 2024 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716475692; cv=none; b=rO0MeE3eKNcHncK0RcRzAlxm3JYdw8R64dcOEjLJcdV1oVelzXsBoaFhinhbSxE62pA3zC9eyM3ZZK4KCzR5AA8628H31PqYqF9TKaCWgE45KjYS3nipPXrIJPEff1vPAY0ya7CucioUbmKqu+j7MoEfmecbMd8UI08JUMvOU/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716475692; c=relaxed/simple;
	bh=qS7pITcL1jqH3SSLLQ8jEcdFPPRerIqWns9weFqn65o=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=CDOPt+DqR9WsVKUlLSWEIdjEdnlXI8QpmEfhIn5rD2CGj5yuLybH/Sq9rKAGB/ZFgKMiEKJNoGpJdWM0JWbeJFhybBXMQja2ad8Msx0Nwwmxdwcdrxgeh37WikB7rl180NyV56W0qpdVhsD4QPPHkVGPjQgNadpQdgTrjhABigY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nslwjTgi; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-51f99f9e0faso9435746e87.2
        for <kvm@vger.kernel.org>; Thu, 23 May 2024 07:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716475688; x=1717080488; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qS7pITcL1jqH3SSLLQ8jEcdFPPRerIqWns9weFqn65o=;
        b=nslwjTgizI1pgA0zm7UBQoR8vw1yj3FubtTO0EY5M36sDu45hZxQowuPo7zxHc/ILI
         e60RLEX3oy0+w0VTmHeO6+EkZej9vWJ2u9ViQE1dLvSTOBYarjgV28C96U4YN4GlKHyx
         7RkQAtZ+346NK3woi9wlLtTjPhS1LEaooQ/CvvbRjsdqaIssod1+05OR+xeVY6tiiG2a
         N2vO6rKLWiABC5LR+X0Kn2xd511P7eCPxwF7dJvHEld7NndnE6LJeOaShWNvwK70Beqa
         tnabz/r1q/5XQQPcQrE27SZ7EXy1L5T++VHh/Y7Vpi5Hc+zvdbusq73FQ4CoMGP0GnOY
         niKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716475688; x=1717080488;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qS7pITcL1jqH3SSLLQ8jEcdFPPRerIqWns9weFqn65o=;
        b=dblFaqy4dP8oE4+etMObjctcd40+gvyN3/sXvmkuo689GM7RYEBHtjFpC8ouRl3hjX
         JZOZs19g9P0aeNVB4ImMV8NiERiLutfd5YkaDmPtV/jgOCmzFKmD1ED/pyI9gvgSBZh2
         KwLqhQ0cy/+LLzQKtGqgPd1jcieIr80MvTHzMuE6m58RRCLJFaj7/VIkcRGbcfm7wO9T
         Rz9L3mFkDSpn7TfIOzfkuQ3+clMQx/qGYeMYhQ/A1i5FUotDnLap+nunJnWmo0aXaPn2
         0uTbtqC5KtFBNzPpN4iyiDoCMaBgn6X57lthweN92TInbc5FQKSzqbqG0nZ0YLZZz/bk
         udkA==
X-Gm-Message-State: AOJu0YyAGJtSw1zKGxDH8YUo8S7GbabEQY/VJpyoN8GAKs15alY13pET
	y69QvAPMfgq/6g/+/iPDWrwnNQ9nyDNuEAN20DyrNt1R1SmwKGFYtJ7+XWrQQY4RzQ/3dMcmbiW
	DuLRnKxItEza/0MKUo1LRLFFp3fokkg==
X-Google-Smtp-Source: AGHT+IFVouHD4EyAzIw2E9SeslcmOol+Vm6WrVtkuz2J/m93aKkXqCn17FSv5z1S+w+vesyjxsZW/SVGJTwMtE6d554=
X-Received: by 2002:a05:6512:3ca0:b0:528:d2da:d71d with SMTP id
 2adb3069b0e04-528d2dada3bmr842017e87.0.1716475688348; Thu, 23 May 2024
 07:48:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "Y.G Kumar" <ygkumar17@gmail.com>
Date: Thu, 23 May 2024 20:17:54 +0530
Message-ID: <CAD4ZjH0oAfUDfbipQk2YHXwV3zKdNyGwpCyybA=y8_6g3LON0g@mail.gmail.com>
Subject: Cpu steal
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

Is there a way of measuring cpu steal time of a guest from the
hypervisor ? Does it give accurate information ? What are some of the
effective ways to find out the steal time from outside the vm

Thanks
Kumar

