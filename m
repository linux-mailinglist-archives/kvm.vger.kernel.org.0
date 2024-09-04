Return-Path: <kvm+bounces-25871-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DEDC596BB3F
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 13:50:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9B733281A72
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 11:50:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D38F71D2211;
	Wed,  4 Sep 2024 11:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cVSOLDeY"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652691D1F6A
	for <kvm@vger.kernel.org>; Wed,  4 Sep 2024 11:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725450636; cv=none; b=S3DqZzppc1zuZVY5oRurH2o4Ai74MpbU3dkHYnbUbDGDA5TAXcBqWNcmAZpwrWj+rCwdsNQJD7ubCuzVlfzwhSz5Anucy/XUBydYfQV9EdqvlePKl74rX1iBgDbN2b8KC+411cNe90D7psG3BiLv4qd7Xttw4ZA8LURnCT9cAmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725450636; c=relaxed/simple;
	bh=gBsEu2YcOVNRhTNwENuXhE7yjqa/hE6q35ATI8wj8kA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=trxoBwS2jdrqo37G3MejeHj4ArNjnXO6hhTwRO3/aLYMxqdTi8AyiBnu5rLUhcNVS9ik9OhV0wWlLi8vE4+z+ngot5DTeWE9QCUA0uu4urzUEeXvJ6oFP0sNFBLCjdIzZQnhXU9rDhO3cNxaIPiuGo+DHYMuzbm4s0Xsd4npGRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cVSOLDeY; arc=none smtp.client-ip=209.85.208.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-2f3e9fb6ee9so8003541fa.3
        for <kvm@vger.kernel.org>; Wed, 04 Sep 2024 04:50:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725450632; x=1726055432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TrHf0+o5650FD0cpLHxfSLBCyuPc5V+xljpiSZxARDw=;
        b=cVSOLDeY4JKdDvwTDO3KWfkKay0d9QVdKzMQm/v/Bcllkjn1wwLXPSxBKXYCup+LJq
         2yv4fkK58YjhHyEIpQuS5Y/AgDh9FTybZlUqObWJ2UOE6qBFYxPpAlG401ZlbXoM0yUi
         eNH3BSUknJPTRdzpoijGRI8prKm0reW0nRUpGpOHZPDwnCg1PWphtGsPlHKxGkeh6DXb
         ClesqDUgCyjwLAUHUnDQay8q2qc7kTOzOfGRmrilU9/4CIBPPMti7N8bgP9U3uTYaByD
         Lz8lIy6Pltt8db9qt/CIFSVVILo80/keRWlDOQ1FFHzs6ERa0dWVw+OSAXkJCp4TGFcG
         bcOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725450632; x=1726055432;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TrHf0+o5650FD0cpLHxfSLBCyuPc5V+xljpiSZxARDw=;
        b=YL6OdR93IkGQm/BpAiAYLmN/RN15W1LP7MaTfW3kxRyZXltD17TJKIpD/n9iDm6x3l
         t/kT2g+ZjCDBF8bzNTPJskgT3VzN5mKX7TvCrROM0IcelSajWk1CqeBvaYDAI2RnodbT
         mxKgJ03XY9AL5QwHb8YEab4GSHI+ucsEXBHRR1+6aSLHerpeSkzTguUEp1/oRhY+2268
         CpLsJXOY5ljqOI5YJH3eGJuqtGsJ44Ul1Ju7pGPxVUskhLHvHao9nBY7t2Tz/uKfjIsn
         sYdKcIdX3eCObgs59Zj6nqr/dQZ2hVbp4/dBox8USDaGGrSsUH8kOyh4T3xDwDWLb1V5
         CAKg==
X-Gm-Message-State: AOJu0YzBpj15Qqu4gZEOOkmT6fBH8/GdzXCN+DqMiquDQEl6nCCqXG+S
	Y1cC8veW+5KFbIqHqCKOWxv+M3jesXNhb2uGU/7mmRf1wZyhIRKF05joBQ==
X-Google-Smtp-Source: AGHT+IH8YwPVPed7JBRq7upwNYAgm7248bzp3uKjfoodoi0E7D0NPfHNs01lsZe13r85VhxrFNuIWg==
X-Received: by 2002:a05:6512:2208:b0:52f:89aa:c344 with SMTP id 2adb3069b0e04-53565f18fffmr1826880e87.16.1725450631505;
        Wed, 04 Sep 2024 04:50:31 -0700 (PDT)
Received: from osconsfortress (catv-80-99-116-16.catv.fixed.vodafone.hu. [80.99.116.16])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42bb9593c32sm189504045e9.48.2024.09.04.04.50.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 04:50:31 -0700 (PDT)
Received: from oscon by osconsfortress with local (Exim 4.96)
	(envelope-from <lagothzanta777@gmail.com>)
	id 1sloXq-0006CS-0O;
	Wed, 04 Sep 2024 13:51:30 +0200
From: Lagoth Zanta <lagothzanta777@gmail.com>
To: Debian Kernel Team <debian-kernel@lists.debian.org>
Cc: kvm@vger.kernel.org
Subject:
 missing backport patch (KVM/SVM) to support modern guests in nested
 environment with 6.1.x
Date: Wed, 04 Sep 2024 13:51:30 +0200
Message-ID: <12523817.O9o76ZdvQC@osconsfortress>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Package: linux-source-6.1
Version: 6.1.106-3

Hi! 

One patch is missing from the kernel source, causing modern guest OSes to be 
broken in a nested environment.

Affected Guest (for example): ESXI 8. with AMD CPUs

ESXI 8.0 can boot, but any VM doesn't boot/work inside the nested environment.

The guest VMs are work inside nested environment after applying the missing 
patch.

More info: https://lists.proxmox.com/pipermail/pve-devel/2023-October/
059540.html

Original patch in the mainline kernel: https://git.kernel.org/pub/scm/linux/
kernel/git/stable/linux.git/commit/arch/x86/kvm/svm/svm.c?
h=v6.10.7&id=176bfc5b17fee327585583a427e2857d9dfd8f68

A backported patch is available here: https://github.com/lagothzanta77/lagoth-infra/blob/master/issues/patches/amd_nested_flushbyasid.patch

Screenshots of the nested ESXi environment are available here: 

--without patch: https://github.com/lagothzanta77/lagoth-infra/blob/master/
issues/images/esxi8_without_patch.png

-- with patch: https://github.com/lagothzanta77/lagoth-infra/blob/master/
issues/images/esxi8_with_patch.png

Lagoth Zanta


