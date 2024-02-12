Return-Path: <kvm+bounces-8538-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4582C850D29
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 05:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D725B1F25657
	for <lists+kvm@lfdr.de>; Mon, 12 Feb 2024 04:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 182DD7464;
	Mon, 12 Feb 2024 04:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h7YIvV9e"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3586FBF
	for <kvm@vger.kernel.org>; Mon, 12 Feb 2024 04:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707712135; cv=none; b=NENXTvF0Fja+OoQvbxpxl6biaXN4H5ins5+ssXZDIS0MilDE629VC72++CFq2WZRGpgf8+HM04UK0JOG6Er26XEkm+kdPkmBB+Qafep0weVx8guuheyxPheSfv7LFIE+YOBKltFe4yhg+iYwDKnRDHkVX0Bv5hvPPHByJhuUVOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707712135; c=relaxed/simple;
	bh=Ee1ugbYUbMJORTVX/Jz/L9KQXUw2dDk0NnmGMbtvwz8=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=az44NIGUhvZvEmYsBwN5BVq6tHL2BfoxH1eGHRyH4ZZXChctwFWgo9fEkF/2dFnlKlku4dgaF1ankxS4WY8wkP/uCY9yMF9o3HRBWDZZSM0NpO2a2TeojV1mCfUKSwBCiUsSYRH4C8KImSFn8nOXnOBWEkpYyHl8gLD4HTQI0gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h7YIvV9e; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6818a9fe380so17864986d6.2
        for <kvm@vger.kernel.org>; Sun, 11 Feb 2024 20:28:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707712132; x=1708316932; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Ee1ugbYUbMJORTVX/Jz/L9KQXUw2dDk0NnmGMbtvwz8=;
        b=h7YIvV9etbJB09THGF/PhRqepeOhRSJ6FageTtRFUrf9IcuB56G83cbWtA5mKCAE1E
         /T1Nu82bqpyACVa8/sQgdaon3WiC/+2Zgkh31V/m57qCuhZVoJm4+vVJmgTtCH2SOf9X
         v5Y4QbfETyrNHzpOfHuNjNFEH3XUVQHB6w64pukmUYEYifJEOE/F3F/ynyw6y+NxvZbP
         h+ZMxwywxI3Q3W/7c7vE7GZDcw2wGHL+rBQHhr40qwpYZ/Z2gUaqis89i242DJgC379w
         JQmxngf8R7RGuT5ZTy5y++IVhvxzNk8LnOl5Duam5URH0BMYx8YM1YpttdxZef8sjg3y
         /sxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707712132; x=1708316932;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ee1ugbYUbMJORTVX/Jz/L9KQXUw2dDk0NnmGMbtvwz8=;
        b=OPsrBbvTUrTrO38nQsIeJSboBlayZoJMv1iZ+xbwLjSnqEGp8lG9fLlZqch+GI1euj
         xm6xZw6IKSZOnpRx86yGQsN3eY2VFoTevJ3JR+V+kIO2rUMde6szNojzfNP1nc5uefmb
         /NHTNmoVs/c/wnA3Js0e/CJeXKlBN+Xe/0RsnqE6KshIBnywpFcYTZV8I4A23V+htmdO
         SfjOcIZI8Gx3DZjiG2tgcH8XN5Jr2GC35/zYiOZeCXSP0u6mdymAS2wBNNfD06mKa2F3
         HUwMybwTXrrF/26he/wZ6QEE1FL2TE2kQAJRtpfKNIENloV22uPuZ6T7mXDsgP7qEinF
         NVJQ==
X-Gm-Message-State: AOJu0YzlCxZU8vQsulOdchawYQ3y5oNOIdhbm05J+RxDM0RIeNIpE/gO
	C/7KLnb+jrxqSGNpAu2KPHg/6JEbXMhLqfNkPpDwSYymJj4nIhFlsWSWSkLqxfvmnRKTs7FRA34
	NGW2Fy70rlSMNxq8308DjKmFReTs8d61XMRBwZw==
X-Google-Smtp-Source: AGHT+IFzZIoGT7MG7ExH0C3bdNDbFg/R/5pe6a+nWY46F71sa98XiV8gbOTsILOByhGb9sZbocaFNPPHwGx6/8rtLy8=
X-Received: by 2002:a0c:ca91:0:b0:68c:668b:c610 with SMTP id
 a17-20020a0cca91000000b0068c668bc610mr6628239qvk.2.1707712132450; Sun, 11 Feb
 2024 20:28:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: lokesh jaliminche <lokesh.jaliminche@gmail.com>
Date: Sun, 11 Feb 2024 20:28:41 -0800
Message-ID: <CAKJOkCooV4MjSprReFA+C7MjqLzeA6uvpRKh3EqpS8Gk1vzgFw@mail.gmail.com>
Subject: Question About QEMU KVM interaction for memory access
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello KVM Community,

I hope you're all doing good. I'm trying to learn about QEMU kvm
interaction. Especially about how read and write are performed to
memory that's set up with memory_region_init_ram (QEMU API).

My initial guess was that kvm_mmu_load might be responsible for this.
However, after tracing I couldn't see these functions being called.

Could you please help me by pointing out where in the KVM code I can
find this information?

Thanks a lot for your help!

Best,
Lokesh

