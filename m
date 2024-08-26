Return-Path: <kvm+bounces-25104-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD4B95FC85
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2024 00:14:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5B40B28500D
	for <lists+kvm@lfdr.de>; Mon, 26 Aug 2024 22:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29CD019D07E;
	Mon, 26 Aug 2024 22:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FLB6RhDd"
X-Original-To: kvm@vger.kernel.org
Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4D19129E93;
	Mon, 26 Aug 2024 22:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724710437; cv=none; b=oqAmoCvD/PQAWwbEPuRcMKOxq86gugWDXT0ZwKlL6qpfTbjMQcXagk17ihTxIKthEdcYcV60WBHl7Tl75kHmhAUyGg1mQ8MnDgmk+VUeAtKnCBxEmP8zaYic9lN7QoPCrDJ27dWBu4+iOZnjCg4WeeEpYUsKvdAk/lmoJi+7xF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724710437; c=relaxed/simple;
	bh=Fg99RQDp5OyTdSS1IpA88kjy6GMQKo5zYiTthZ+QMSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGZ02TB3bc49g9FhRPLeJ0p5Vvd+6Jzt6xPOV595PJvS6c121WgRzqWOCjcw6bdnB3mqwAZEYuumcjGIAgHBE7ae4BXXG2bNdA5Wa5vIQjMteDdDBpis3MnaQUy6NmZseP9mHq7JaOhVgafs4WrVlkXLtcjwwUaMwYkky6TrjyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FLB6RhDd; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-4fd01340753so1363096e0c.1;
        Mon, 26 Aug 2024 15:13:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724710435; x=1725315235; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zdznXswWaLI4oUBUJ8gE1WYggKIl2eflQsRsLuaFGMs=;
        b=FLB6RhDdYhpdh2zsFa+px5BOhjWeKRbJAzQwGl2eRT13pA6HQEmdCgHaayV69VuoKR
         ZReP5k1OQ6umrqTvNNp3/bbRX3KmAZqb/iBrnVtdsAoo5fHEqg4UJ/ifjKlC6SQ+JAQk
         pjeIJW578jAJIP66b90LJgQih1bHrzCogeOzt2gLGFU4HgMkI2ibFfcxBO25TyW2tSbc
         RxvYYX0mAvM3tJ6d5RgosZPuM9VKUY7JqA7qkSGoAz7xHjvH2U2Ghq/FQfSQA2w4MGM1
         SfXIWM/HSYhdW/mZ1wLjXdqZ8mebVLm1TS3d/eubvLeCMU1b6fWFEl3QRDZRTFZbXBn4
         bNEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724710435; x=1725315235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdznXswWaLI4oUBUJ8gE1WYggKIl2eflQsRsLuaFGMs=;
        b=isX6nKAanEqTceNQc1S+AXaI2VUBfrQIqdQLS5KKnNzwq8F7/tlREF9osbK2ICx8e7
         H0H+Es2J91AMfOMEveChXGVrlZX8sKc+bktmZNAEisaCEszpUPSIKJWFyN5n8SbxPyxT
         MrIIEYScgdYvP+/9i96d14zyfgLEgNglrdAo0rfKHtrNj6CcFlN/Aq3LyvkqgqXbzvyh
         81B7j6rxJ9tLZ5pzmE7zcHFTxcZLCb2fEhgE0l3XfS7LS5d31OH9PxMkqfj0j/MEQ19e
         gbf6VBFCu8ziL8BsK92DuqmJT5ai2vu8x/G4GTs/gzdnfEFH0rUOSBhkWCS1hQ7Nt8LL
         BV7w==
X-Forwarded-Encrypted: i=1; AJvYcCUjbUrXOqhRgsn5RXdtdks6VkzxNn7/cc6kkPBE8oEaH5Gv0WzFlYeF5DTmnQM3TItfHj0=@vger.kernel.org, AJvYcCUsOAmoM1TheImROghlWXE2VFc5OwX5b9rSlzKqWRSwYR4ZBngXkox3ysVTNcU8PD1HoAwDKAy/HfDGSMVP@vger.kernel.org, AJvYcCVe3cwgSqLiitogEZyOGB61Rs8ZhoY2GqTptXat15RBdUld6ZKqdNb8jjF31khIvGLdGZXwnZvT@vger.kernel.org
X-Gm-Message-State: AOJu0YynU5hxlflo5G+Bs6spD3RagW9fO+qK0OdBKAHreOtsqg9CFHSp
	8Sa1rHbMIwAJ2+7N91yWhqK4RVxCwfKIEW5KkwuxfzZKluQPNgfz
X-Google-Smtp-Source: AGHT+IF6vjxeO+/qrvpoGvVW6o0I5kF6H1BQFQP8XdTB0rClL7V+v1zvjwyTZoZOFFmPWRh1EQjjzw==
X-Received: by 2002:a05:6122:1810:b0:4f5:2c0c:8528 with SMTP id 71dfb90a1353d-4fd1a82d51dmr9734268e0c.11.1724710434659;
        Mon, 26 Aug 2024 15:13:54 -0700 (PDT)
Received: from localhost (57-135-107-183.static4.bluestreamfiber.net. [57.135.107.183])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-4fd082711a7sm1026529e0c.28.2024.08.26.15.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 15:13:54 -0700 (PDT)
From: David Hunter <david.hunter.linux@gmail.com>
To: seanjc@google.com
Cc: dave.hansen@linux.intel.com,
	david.hunter.linux@gmail.com,
	hpa@zytor.com,
	javier.carrasco.cruz@gmail.com,
	jmattson@google.com,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lirongqing@baidu.com,
	pbonzini@redhat.com,
	pshier@google.com,
	shuah@kernel.org,
	stable@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 6.1.y 0/2 V2] KVM: x86: fire timer when it is migrated
Date: Mon, 26 Aug 2024 18:13:34 -0400
Message-ID: <20240826221336.14023-1-david.hunter.linux@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ZsSiQkQVSz0DarYC@google.com>
References: <ZsSiQkQVSz0DarYC@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit


Hello, 

I'm sending you two this first because this will be my first time
sending a series patch. Is this okay?

Backport for 6.1.y. These two commits should be backported together to
fix an issue that arrises from commit 967235d320329e4a7a2bd1a36b04293063e985ae 
	-Subject: 'VM: vmx: clear pending interrupts on KVM_SET_LAPIC'


[ Upstream Commit 8e6ed96cdd5001c55fccc80a17f651741c1ca7d2 ]
Haitao Shan (1):
  KVM: x86: Fix lapic timer interrupt lost after loading a snapshot.

[ Upstream Commit 9cfec6d097c607e36199cf0cfbb8cf5acbd8e9b2 ]
Li RongQing (1):
  KVM: x86: fire timer when it is migrated and expired, and in oneshot
    mode
---
V1 --> V2
	- changed to a series patch to fix an issue with the patch

 arch/x86/kvm/lapic.c   | 8 ++++++--
 arch/x86/kvm/vmx/vmx.c | 1 +
 2 files changed, 7 insertions(+), 2 deletions(-)

-- 
2.43.0


