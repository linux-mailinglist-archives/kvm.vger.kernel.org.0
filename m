Return-Path: <kvm+bounces-40080-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 45EB5A4EF34
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 22:12:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 05A343A6014
	for <lists+kvm@lfdr.de>; Tue,  4 Mar 2025 21:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3028426B09A;
	Tue,  4 Mar 2025 21:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="a4WN37AC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B57B1F76A8
	for <kvm@vger.kernel.org>; Tue,  4 Mar 2025 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122747; cv=none; b=kyXAmuAuvtmWq81PhAQt3Qah8XXeXFe0yKJdwFzXsCr470Z0LZgjavxI8UfnNlCIQIve5atem5UBUW9Oly1tgQFtNsngi9M5//ZywxlA45C9SUn5w4px8KIAOqP1i0Y8nsOCse/oMLis9jbZ+5SawRbqSICoInIXfIleNWzIevU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122747; c=relaxed/simple;
	bh=qrMARb9IdgN75cJ8R3V8L0x2VJ1ciK2A5cUROWQYm1o=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Bde06IwmVaZQSFlUofqEECi0lwn+CoHm/in2/jX4a2ECd38sB8EA2BzEtY/FeP4kW/a2SgxcjQ8E3W0FqW7rmyIx/Kx9tFwVzVrEXDAdebXW2y3C5blBw+lrrB8OE1OfYm2ExWAbEcdMMLhGXuOBLjrjoPNZg/AumQDARN1SuiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=a4WN37AC; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-2fe8fdfdd94so11785530a91.0
        for <kvm@vger.kernel.org>; Tue, 04 Mar 2025 13:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741122745; x=1741727545; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P/wB6urAEZ/Nryr/YRiKJlC46foojjCWTtJfjIEXP6U=;
        b=a4WN37ACe5oqNlKq7T7iq++1pfph9R7tFyxNI7OdBlRzqJnscXRiO48nmIaOPyzlhp
         GHpiLl0whho3qURHzFB34UPOg8odUtF7c5/pbh1KHP4H77gW0QxJiDbQWNjpOo+oI2Se
         x9QHtq8MjbkS7qa1MISj/XrhwOhQlL/eLJi0JR6mY4DJ4yQq5hv50LgbaIC13WR/mRLO
         +Jpben81oMRMorxnYsXdYE5q8I8mNR4Y75f2mmV/CkdxZgoQMy0oVOG6Aaw/n6l7zPCD
         nwfIjHgFB7SNcQelG4TcHGrMF9rJNl9giSrDNynoJh3r5F6cmjJcm1fYl0nHAg/7KXzZ
         Pf7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741122745; x=1741727545;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P/wB6urAEZ/Nryr/YRiKJlC46foojjCWTtJfjIEXP6U=;
        b=O3Z0fo7GEfotq6707uJuhy4sr3OE4bQuNCqjNTKjzcjsO7yxjJg/mU9lHixIIVrVJ0
         RrANib3PCJcMswkPlidSX50qXhMb8eUy+D4IK/fqJxoJlSK1PoJtFgusOdBF7OCWZBvY
         MFSLFtue+UZ//ZNbyHTpRUV1WwzXXbIywSFlHrLtppEsjGWZTeJzoZFr+JdO1quajhXd
         hByU8qrUnLYgt8CQD8388wYqhETo0gKbF0EPf21QR11WD1MmoZzVIl5hJePNQucdzw9c
         /fCdlP70kgaPHknPGwYP6/5fj2BWJi/OrITLaHNQ0hOQ9jba0WZh0zFNeONWpZkLwhL8
         VQEA==
X-Gm-Message-State: AOJu0YxUDVSYa1I9xo+CzvHMIpRqMd19EdK90cySzS/rKDQI9ko5mmoq
	affThvGqOyq4/sriz2BMZYph2ugcFYs0plaRGBa4fpm7j7gcX1xiVqrqiVy6UYJQYMvSyZqK87R
	urg==
X-Google-Smtp-Source: AGHT+IH69vRcKwjXeADxLI2atZYIVFLKjodqujtIhu2Jjtdu/0j8hvlNXvIiviCnl++2UVqorDbzKYtwls0=
X-Received: from pjg4.prod.google.com ([2002:a17:90b:3f44:b0:2fc:af0c:4be])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:248f:b0:2fe:b937:2a51
 with SMTP id 98e67ed59e1d1-2ff497c57c1mr1360289a91.33.1741122745332; Tue, 04
 Mar 2025 13:12:25 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  4 Mar 2025 13:12:21 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.711.g2feabab25a-goog
Message-ID: <20250304211223.124321-1-seanjc@google.com>
Subject: [kvm-unit-tests PATCH 0/2] x86: nSVM: Fix a bug with nNPT+x2AVIC
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

Fix a bug in the nNPT passthrough APIC (MMIO) test where it runs with
x2APIC enabled.  The test currently passes because KVM provides consistent
behavior when the APIC is accessed via MMIO in x2APIC mode (see
KVM_X86_QUIRK_LAPIC_MMIO_HOLE), and because it runs with an in-kernel PIT,
which inhibits x2AVIC.

But with a split IRQCHIP, i.e. no preconfigured PIT, x2AVIC gets enabled
and the test fails because hardware doesn't provide the exact same behavior
as KVM (returns 0s instead of FFs).

Sean Christopherson (2):
  x86: apic: Move helpers for querying APIC state to library code
  x86: nSVM: Ensure APIC MMIO tests run with APIC in xAPIC mode

 lib/x86/apic.h | 21 +++++++++++++++++++++
 x86/apic.c     | 20 --------------------
 x86/svm_npt.c  | 27 +++++++++++++++++++++++++++
 3 files changed, 48 insertions(+), 20 deletions(-)


base-commit: 68fee697b589b7eb7b82e8dd60155c5ccf054275
-- 
2.48.1.711.g2feabab25a-goog


