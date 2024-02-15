Return-Path: <kvm+bounces-8767-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7AB188565C2
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 15:20:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 410512845AB
	for <lists+kvm@lfdr.de>; Thu, 15 Feb 2024 14:20:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A110131E49;
	Thu, 15 Feb 2024 14:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Hy4+Sp2F"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72D2130ADA
	for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708006841; cv=none; b=j5lnDoTe4Efu+D8ngBEMrdos+P2dTuOn2dmS468H8SNfizI2m7IABpUQRZ/MO1gtkDgHy6aeAjcfpqwzUukbZjbdeIUl6SKzGmrH7W+DLFmI4PNQCEflB1ilmYegLSjSAALUE+/GxAbyUNFtzde+stGpVGpB6+WM0IB99/2UHWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708006841; c=relaxed/simple;
	bh=t/ZQi1tcuEEb9VQVaA6wSceWESiGSRFQrD6Vf6CfjFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rAE9uBCf4nxiID21LM5KitQ0TRH8y5xojMUIrTgh3fysVM6EJ0kLnI/nUWbLf0cNLEXpFzz2qpNZ5s4PPWHXKmZfYofncDyd7nsRnEeFnomYuYR8lghc19Xdzmys+jw1Ln/FWYq8r0kPCgpFguApuo83vdnP4x8AHo1ZyVor9a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Hy4+Sp2F; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4121954d4c0so3553915e9.0
        for <kvm@vger.kernel.org>; Thu, 15 Feb 2024 06:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708006838; x=1708611638; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pntBR0iPUBvaqhNDr3z74lUrr+ChN2lWu7THzxvYpq4=;
        b=Hy4+Sp2FZdQEsYf7UCmF7Oq4yH7wyGRbxlcjCh/vjmq+bxMuj2EKRykyphp5YpS9Fn
         nKk4ZArPBCGKtqYlhROr9ZkKHewqSbVSMGesKqemsQlH7EcfpiJ5+qtYId3/6qjBj7HT
         7uu0wqdKTH01oR8thMmrCbqEqK42OeFhBo/ILG5em1KcUaVdvMZQPbtzgyVIvVw1lhCU
         9i7zGG1DhtgFD+WZvMh+RfwFYrJCQvVbp6bpa256kQjVhwGaEroeTNLB1CSkSkMaKKoj
         +fwVTTgO5MFNIvRWLXkBIyLliw33DNDebn4CX0lsO5rLbOUwhZZw4PAWSvuA/ms7MeU0
         83NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708006838; x=1708611638;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pntBR0iPUBvaqhNDr3z74lUrr+ChN2lWu7THzxvYpq4=;
        b=GYi8O1CHjudwFkpN1Y8TUPORjZ8jrpVM5RZB7nF6v8Oyscajj8AQNL0qN+v1N26Dzx
         o8eFc2KurzYSut/pgA+sNueaIZMcvOG05hkeNEtH2Mm5FKZCILBzv94HWNjVrsDO/+RR
         tomRaLuNibrYJu+CW+3l3rBCPhHrvjjSuI66E3KxS+L0TNddoo5jW7biIL5jetnaZc7O
         Cx4C/4EPWr3oRGqb0cOA5lMyUxerAdzzyPlLokRNSQONXSxXA95ae0xPNCZlkOpMD4pu
         U+27jUCzyVrBAuYv66rl125WeZbdvukzGOxWy+kJK4aLC15PCHRumlp9lPKchc620Mul
         Hc/w==
X-Forwarded-Encrypted: i=1; AJvYcCVOJD1CdaDvr2ny5KceTLKCCY6J5I06QXDjoW9agsQ8KJ4shz2yewCI/5EB9l6DkP5+RaIaa7Gr3agwX1ySLpdjYsHZ
X-Gm-Message-State: AOJu0YzAfiWHGRBArzT/Zuh/0VfqxOAbup9GM+dbTzHt+zQO3E7wiu/q
	0a+p89hbqI/wijupWXDEA02vCLHIPf/8oZZtCMxAf/MXkOPQgvwTukGlypO5tD0=
X-Google-Smtp-Source: AGHT+IGltK8SlqR92mQrainaw1OJot7KW5TFHa2cucezR6qPEu7mNw341XisjYF9nFUPH+3qRI7IUA==
X-Received: by 2002:a05:600c:1c01:b0:412:265:ee81 with SMTP id j1-20020a05600c1c0100b004120265ee81mr3043560wms.12.1708006838083;
        Thu, 15 Feb 2024 06:20:38 -0800 (PST)
Received: from m1x-phil.lan ([176.187.193.50])
        by smtp.gmail.com with ESMTPSA id i7-20020a05600c290700b00410add3af79sm5130718wmd.23.2024.02.15.06.20.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 15 Feb 2024 06:20:37 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Richard Henderson <richard.henderson@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	kvm@vger.kernel.org,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH v2 0/3] hw/i386: Move SGX under KVM and use QDev API
Date: Thu, 15 Feb 2024 15:20:32 +0100
Message-ID: <20240215142035.73331-1-philmd@linaro.org>
X-Mailer: git-send-email 2.41.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

- Update MAINTAINERS
- Move SGX files with KVM ones
- Use QDev API

Supersedes: <20240213071613.72566-1-philmd@linaro.org>

Philippe Mathieu-Daudé (3):
  MAINTAINERS: Cover hw/i386/kvm/ in 'X86 KVM CPUs' section
  hw/i386: Move SGX files within the kvm/ directory
  hw/i386/sgx: Use QDev API

 MAINTAINERS                  |  1 +
 hw/i386/{ => kvm}/sgx-epc.c  |  0
 hw/i386/{ => kvm}/sgx-stub.c |  0
 hw/i386/{ => kvm}/sgx.c      | 14 ++++++--------
 hw/i386/kvm/meson.build      |  3 +++
 hw/i386/meson.build          |  2 --
 6 files changed, 10 insertions(+), 10 deletions(-)
 rename hw/i386/{ => kvm}/sgx-epc.c (100%)
 rename hw/i386/{ => kvm}/sgx-stub.c (100%)
 rename hw/i386/{ => kvm}/sgx.c (95%)

-- 
2.41.0


