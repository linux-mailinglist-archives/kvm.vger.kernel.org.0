Return-Path: <kvm+bounces-21579-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 25C13930287
	for <lists+kvm@lfdr.de>; Sat, 13 Jul 2024 01:57:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9F738B22043
	for <lists+kvm@lfdr.de>; Fri, 12 Jul 2024 23:57:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1456213328E;
	Fri, 12 Jul 2024 23:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Okj4PtaD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1408413048F
	for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 23:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720828626; cv=none; b=rydxxb2M66qvjYinXB328QNVQhfNXqfnvTOzAP347ChfhkXt0tAoWQ2uZ8aEuUZNVBCkGM9DHq0xDZaELp2a+bfEKdHKXjPGyT+a4NyOumZNfP+I9SDpa7V+I3oF25EUZkfIrRtKfFPnSB7r18JHluqwoU+leb+TKEyinOhYFY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720828626; c=relaxed/simple;
	bh=v5MFUcY2KTqANwH586uLxyoUInEK6dGefZwvJWBcGP8=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=eiDVwOJodG3mH7pjkBZomA6cG15Am8zwjtHzDwBIRav3Or0lsZNSr404PVhdmCZT3KarsBYxT+Stz+QEdvUmDm6ADYq61X8YoO+GtGCoiQAML3bsdLBLKCb9file2Xiz50X4wGi8uajhrt6C+kHfm/dGD0v7L8+KH8XA/HrEJP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Okj4PtaD; arc=none smtp.client-ip=209.85.216.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-2c974ec599cso1947506a91.1
        for <kvm@vger.kernel.org>; Fri, 12 Jul 2024 16:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720828624; x=1721433424; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ze3wACVXpWLgwdUW1sUj3dn7jbqIRwBSX0Q8OyWjcao=;
        b=Okj4PtaDidIX0lqRxSfffJ8TOvJOL0ZOp6pO2kXH+3UyXqxOjhHInqaSlIAqUlc6Ny
         ZH+3h9Q5hdceOYUEBB0sM4pt0Grhdbx4KeOGZOORu9vVdc3I49Th8ienoWtcQy+VxkZB
         Lv0WNcj/n9i8JUJCXs4pElXcI8YSB2bd53hqqYBFUkY6kQYM65mbXBFm4siuxwf3FRjw
         Y8b0ShaXZHV4ZsImSusUnAxvVPKZrdi037BajjxgOyYnnyk6sKEfcjD1VS7vhSoPEWo2
         VoRFLllQTF5GMwl3/VTWSFWYZKZuFbYq4Wk80eXOMVx97j67yAyZOXoLtCDtWW+xQBBx
         r7Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720828624; x=1721433424;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ze3wACVXpWLgwdUW1sUj3dn7jbqIRwBSX0Q8OyWjcao=;
        b=UtwgsklRJ43ru1l4Sqzwbu0Vo6X1Nx2qfXk4fVFlb4u0QAjw1fpP1YLOy458UUjEWS
         YUOS2c/q45/z/IMDvAmGqN8YX3z8x8NETSXmuQDqKTLiHaUbFbSVral+3/+zNFF/qsio
         np0J835RtNiBVV9L04hMfsjx7zR4MEGPLFrZ5DLMAVvc0dDgSrVv/TfDvK/Qn8btjg3E
         U3Zyz8w1VaaUm+3sqKDpW+w+Amgn12e7uU2dIG0wTtRJ8xwwSfzIwz7NmlbbecZBolBx
         t7/niBJjeGb8b/aw9tuKZZGrYtiyl9sIjSVt6wzdSV3k6nwjhYTqfZnK0cPWLREMCg5T
         lUWg==
X-Gm-Message-State: AOJu0YyvGLzpvMi/L6ucWwGb+1UgBX03DOTBW57ziRdIBvp1Mpr+Fhrt
	lFXnt6ykxh6nf5pGQKmq2UI3mz8669NIwBnk3velYY/gZbY48r//H0wsLlBDp2Pe065sPzUErDB
	MPg==
X-Google-Smtp-Source: AGHT+IGuOjZyfAICM5hPYltKwK8MUxEufx6QRd2bStK4KRbVp9LndHSZuW7wfQXLiJscub/n62KMNN+4NeU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:5215:b0:2c8:632:7efe with SMTP id
 98e67ed59e1d1-2cac53aceddmr45484a91.4.1720828624214; Fri, 12 Jul 2024
 16:57:04 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 12 Jul 2024 16:56:50 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.993.g49e7a77208-goog
Message-ID: <20240712235701.1458888-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 pull requests for 6.11
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

There's a trivial conflict between "misc" and "vmx" in kvm-x86-ops.h, they
both delete ops that happen to be _right_ next to each other.  Otherwise, should
apply cleanly.

