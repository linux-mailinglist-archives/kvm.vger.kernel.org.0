Return-Path: <kvm+bounces-33256-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A2EF9E8463
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2024 10:14:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F28D163DE4
	for <lists+kvm@lfdr.de>; Sun,  8 Dec 2024 09:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EF6413B7A3;
	Sun,  8 Dec 2024 09:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lpaD61KE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415321BC4E
	for <kvm@vger.kernel.org>; Sun,  8 Dec 2024 09:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733649264; cv=none; b=OcPsR1hpAnIa9f8QcE2pQ2o7bcIErBU/tRh4CUnWVrEBOZ7Uc//2eB3h/Vj8HlRQ5qzCKzLCStrN6dk/IAXrWs3oWSlVyowe1DKJJEPfY1B8Jf03wCKAe2mpFwVhHmIy+vZLJD+FxE6KpI7jtpdaQrru0fgtXrr0BGGxS2wNvbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733649264; c=relaxed/simple;
	bh=fb4PGjth+/NuIenBGcNzc5T9PQ6WQHpJtalPZHDaX/g=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=A1xMcV20HpNU1bxBG03s5AWsWyKX2rASMdldTnllL4iYTPUKZA1gKQBowQiBkx9snE3ANyt6t/IWntKd0x8EXHzTCMNoOof4RK4ACGRdi8lsMfYvVmzWtK1lSuhIpf0Oe3vAIDk5wqFGgOTr83irH6N/Jd7Kn9Ezww/8TSlgCOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lpaD61KE; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-21583cf5748so31564695ad.1
        for <kvm@vger.kernel.org>; Sun, 08 Dec 2024 01:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733649262; x=1734254062; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fb4PGjth+/NuIenBGcNzc5T9PQ6WQHpJtalPZHDaX/g=;
        b=lpaD61KEfwhnmeRHPR0Q6aMlyN20rRlVzF6ri3x9qx2F/FmKfC6yX5i0uZEF6NOcS4
         HIBjWpTSgDyh5PEwGtmXCnfl5BJwMljxA18Ej7yrVn52AnWhnekWbcM4CAfWiJOTw4VA
         6ZXU53ydQoklfmilLKTMGGWD5L7vvFhzdemqjeXFqeQaqrY9I4gJ0BxRGiJ+WDjt6FQt
         heBFMn3gJlSMKnbglOmUGffueDlSzJUpEpfCLYvxye5qWqaSfD1ElRH9AvtRDz7lkuSb
         T2iPAfj65ENjYD0LVQFcama4RTF04a81IjuGZa8peunnY7aC4mVeJIj+As1JBkcQzav1
         AU5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733649262; x=1734254062;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fb4PGjth+/NuIenBGcNzc5T9PQ6WQHpJtalPZHDaX/g=;
        b=vOotl9XosHct2ocp+uQPTn1buuds7D/b37oJnI2+fOeapBs+5vMLACx0C/KZ+t0Zd4
         2F+APzb4UXI/nRBWA/z8JAaTgDS8w2XFqEjE8LBsju4nTA3Uv/jOysZfBw3bxnF8l5H9
         SQY1e158DAPhAmdcY1drustuvtM7OORiEgDt1B/IPW+DuuD+2FJSmsGBVfzY3MImmY0/
         Oc2QMDY8H5XA34c+ub1lEbvWorq2Lud+zhYavVkWbEcl4nj5qUDj2dJrkGg/Kmixkgae
         z95rqo6btxCOmA8NURQFT9cxEwfna9zmr0gNqhoazWjuSkdC9IWj9QsSmFoMdj33xSwh
         OZLQ==
X-Gm-Message-State: AOJu0Yx1rMH68NZd6ZaBFon0w9ZJi9tGjLe15CIKCMxRCSjk7OJM+vEb
	tXPD0bVkD9CUeEVlxQjiyUgzat/f8ztbt+7L7Gu75mRNQoZ9zSoQUJsg8rulWFRWlIEgnDFFnGr
	BIuElKzf4/AkXw00jl7/qkrCr2+KU8Tvo+FY=
X-Gm-Gg: ASbGncsA756gpUgctRdbhc8PsaYtk39w2rzxFEdnEN1pqWJzdZHHa0KLVT2MI/phHom
	+2qrGV48TFWAub/MFAMsW8nN89RZ9l3a4OA6w
X-Google-Smtp-Source: AGHT+IESA0oWswF50Qxr24RvfQRF5TkMmhEwEZ6r6pb+QfOtt+j7k8tp5HKmrf5mUhE1C3eIyZP00MRsLsjZW66wfrc=
X-Received: by 2002:a17:902:e548:b0:215:4665:f7e5 with SMTP id
 d9443c01a7336-21614dd226cmr130910845ad.43.1733649262257; Sun, 08 Dec 2024
 01:14:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?5p2O56GV?= <shilishuoya@gmail.com>
Date: Sun, 8 Dec 2024 17:14:11 +0800
Message-ID: <CADTb_0Pr0Rh63eB1O6jvjH8cngMyDS0D7Khr5THtMBp0GVdciw@mail.gmail.com>
Subject: i want to learn some recent development process about kvm, not robot
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

subscribe kvm shilishuoya@gmail.com

