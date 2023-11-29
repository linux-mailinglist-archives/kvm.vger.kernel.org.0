Return-Path: <kvm+bounces-2712-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFCDC7FCCDB
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 03:25:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62D2F28335C
	for <lists+kvm@lfdr.de>; Wed, 29 Nov 2023 02:25:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F3D1442E;
	Wed, 29 Nov 2023 02:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ouiemf5L"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8361707
	for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 18:25:09 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5ccaa0da231so82920467b3.2
        for <kvm@vger.kernel.org>; Tue, 28 Nov 2023 18:25:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701224708; x=1701829508; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nMJrQUQ0Uq0kC+iIHIog8EZebw/k0pHNIny759MkldI=;
        b=ouiemf5LfSjn5b+7MGweD+NYPLzGk77eJv26YjdrD7l96Sy9gxbLM/+B+jEuos+gzf
         +iqUblwQX/vsC8VfheibhUxUuoaGZHNMBlgoGVFdL5f39puW67uoVIYkIzEI+y/xIBgY
         f3X9EY0w85Oh7NN4fA9FtlRfKyQbXkT1AKCfgtfF2m5UOH0Bhl57akyU+zIAf+OsNnHg
         SDmEFDEeYDf+dc8hDq/m1Kz8gqg0fNcwdyWgaN2DhEMzRJHc/yU+nptN5wvVxE8W6b1M
         hpUtWkG+QSEW92GWtvYUdxIJh/8YPc12WaYjBedkEK8+CFLxHu7pFoyS6/5OPSkwFm8S
         eefA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701224708; x=1701829508;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nMJrQUQ0Uq0kC+iIHIog8EZebw/k0pHNIny759MkldI=;
        b=GJsVb84Rn8nGqPructBH3ZVe5RxQH6lPwBLuTM9bYN5+icnEhvPljPwqo5fpJDezX3
         EGJ8YdvcepstPqT1KJn8lps6WIhypvC4zKVdB8je6EjHvE8K5cV0/OVGCDDpSdBPWVLM
         jSuqx6KJlc0w2Sv7krVnH80o62Frl9ruounRMHIa8tZa4i4emXlFfeOfqK3CPqiYhhq7
         bcLo6bl1qNIrIorr3XBDjc4kt+XQ4R20P+psY/hx8Ydw4zvEL9kleM8Ys0sGXGM0mcE+
         5JdQTGEeHyDu/BSg56t3ifF/fQnbnALpjaL+eT71zPKkNTlV4L7pM4DC0MZe0e+r7kTr
         SmTg==
X-Gm-Message-State: AOJu0Yw02rdtoWjMJn7ZCqjMMgBOiP1Lr9SPjgktc+xXQXpkpZGv1vo/
	/KFp5IkHPYX2D1VrOLUFdhev5W5BMb8=
X-Google-Smtp-Source: AGHT+IFq2yJmp1IjHZxPZRJ8E+m6EOd4Uy3iUxIAu7KbjZb8Zp19x9A8Ll6WPlZO47M0kq7WaqcQmhTphFE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:304:0:b0:db4:8e59:c867 with SMTP id
 4-20020a250304000000b00db48e59c867mr369639ybd.3.1701224708554; Tue, 28 Nov
 2023 18:25:08 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 28 Nov 2023 18:25:05 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.43.0.rc1.413.gea7ed67945-goog
Message-ID: <20231129022505.430107-1-seanjc@google.com>
Subject: [ANNOUNCE] PUCK Agenda - 2023.11.29 - CANCELED
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Sorry for the late cancel, there's no topic for tomorrow and I'm still playing
catch-up after effectively being OOO for two weeks.

