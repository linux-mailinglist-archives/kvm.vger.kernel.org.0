Return-Path: <kvm+bounces-51813-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id AF76EAFD907
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 22:58:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 343CB7AC31F
	for <lists+kvm@lfdr.de>; Tue,  8 Jul 2025 20:56:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20589242D79;
	Tue,  8 Jul 2025 20:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZMzWtj4u"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66BC24291A
	for <kvm@vger.kernel.org>; Tue,  8 Jul 2025 20:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752008267; cv=none; b=cvIrcCggtIOhNckfcbvNi8WDhueQPrg8+enpJQCoFziNm4HDM+y9ty7joYTrHCnDaEc9UZFmkTlkJYmAFNDwwBSqRjz24qWzakbhxrZmtKjmYNpBoPpepDwtuU+Hcape6eDHgQAU3NBHPo1pZqlWj9P/63+iCWzRCEZ4W/gy/6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752008267; c=relaxed/simple;
	bh=OJygdgSC/prRJ/2e265vfEgL4IMrls0u7oAx15a9nyU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=EVEa/XFmTahzgv63sxoTlY4cjl1c7IM0LVWzg1KEwDj141gk+Hca9qp6pUM95a8wcOviQk3xGIBCLhf2Y+QHo9QJeLaLY3aUsMRJzutEK7puA92zBBjax9nBO+BxlunTwXmeSaWEapaVk/R047NPaRDrt/SA/4sM9T14VjJsv8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZMzWtj4u; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74b537e8d05so3869807b3a.3
        for <kvm@vger.kernel.org>; Tue, 08 Jul 2025 13:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752008265; x=1752613065; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xj/rgIwow7I47txNalOr1f2xg0tOMdekLQmzegO3DyE=;
        b=ZMzWtj4uab9PPbMAmYwvZBKdsGsVvDr3mQ9DhNCBV1A+XOgK+B2DfwMUur8E3vRai5
         Nve/9p2kFuTA5fi53SehWkOE5Tr9zVlbZoSbPni1j9gO7HYhuad9wbMPElSxRb4kx7cj
         Es+PWp01OkKU0x6wD+s2+p/iLMy6IEIS3zx6m3C2/m7NDTi57eQfM9JK4LNxph1qS5jg
         zypomph5P+IyjD04/KQyLJWX/7C7RAcXCnQKYBw/kKx9w3RwpsOYGkRvtpeEPrkiD/IM
         bsfygbohbHn782mYsKH1H5uwAW94hYmv42hms2GVXAlBRiHWhv5ymGsEqOeMpsT/mzHw
         8Mhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752008265; x=1752613065;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xj/rgIwow7I47txNalOr1f2xg0tOMdekLQmzegO3DyE=;
        b=AMm6MkCq0CVn+n9bfZdilu97VXeAAvtUbpTBhM7uWAFJG1WkONOerdmjB9zJc2ENJ7
         eIKd5Eg/2JZ7DcxVEyIMQMnX1caGEYpsGMV31u+9vIgfPqIsaBzLTIp9+w+hmgSqHG4Z
         QkCA3U+d07/W1S8Dct719J0SI4Krt5tDHk3n8zUZGN3r6dG+BYaaUy2danAevCsBFTWE
         gHD+vsvzeCe0t4lLPnmjn63Ta+NTUWIBXmqT1M68N6n3XZaXkhLH/F2vpotndq4m18VQ
         179EoRrBPwnfWMIVD/XzXJkKmpAZl8iVtZJwX6nvq587jxdMQw3fy/WIwrVcJMaA8W/1
         DVIQ==
X-Gm-Message-State: AOJu0YwQaoISLCmSoEdxKhDXVXQIuFyKwXgIDg3CwbK5H5zINaGMBfZ8
	X/7URhjUAgoxw/2Hvl/SxgSp+nbqvRq0VL67xU4/K73ckqJj+bM43wbiuRg0DOJKlY3enEGnbac
	tLbVj4Q==
X-Google-Smtp-Source: AGHT+IHt3O6gpCRhitlrcX0MVCqOa+15++d+WNMG3zixOkR5O+/tVnP+/zUIylUP45iQshj9EIxXjfZXHzk=
X-Received: from pflc19.prod.google.com ([2002:a05:6a00:ad3:b0:748:fc2e:e489])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:ad3:b0:742:a77b:8c3
 with SMTP id d2e1a72fcca58-74ea6411205mr95826b3a.4.1752008265114; Tue, 08 Jul
 2025 13:57:45 -0700 (PDT)
Date: Tue, 8 Jul 2025 13:57:43 -0700
In-Reply-To: <f156887a-a747-455f-a06e-9029ba58b8cc@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <f156887a-a747-455f-a06e-9029ba58b8cc@amd.com>
Message-ID: <aG2GRzQPMM3tmMZc@google.com>
Subject: Re: KVM Unit Test Suite Regression on AMD EPYC Turin (Zen 5)
From: Sean Christopherson <seanjc@google.com>
To: Srikanth Aithal <sraithal@amd.com>
Cc: KVM <kvm@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 08, 2025, Srikanth Aithal wrote:
> Hello all,
> KVM unit test suite for SVM is regressing on the AMD EPYC Turin platform
> (Zen 5) for a while now, even on latest linux-next[https://git.kernel.org=
/pub/scm/linux/kernel/git/next/linux-next.git/tag/?h=3D
> next-20250704]. The same seem to work fine with linux-next tag
> next-20250505.
> The TSC delay test fails intermittently (approximately once in three runs=
)
> with an unexpected result (expected: 50, actual: 49). This test passed
> consistently on earlier tags (e.g., next-20250505) and on non-Turin
> platforms.

Stating the obvious to some extent, I suspect it's something to do with Tur=
in,
not a KVM issue.  This fails on our Turin hosts as far back as v6.12, i.e. =
long
before next-20250505 (I haven't bothered checking earlier builds), and AFAI=
CT
the KUT test isn't doing anything to actually stress KVM itself.  I.e. I wo=
uld
expect KVM bugs to manifest as blatant, 100% reproducible failures, not ran=
dom
TSC slop.

  FAIL: tsc delay (expected: 50, actual: 49)
  SUMMARY: 13 tests, 1 unexpected failures
  =E2=9C=98 ~/build/kut/x86 # uname -r
  6.12.0-smp--adc218676eef-tsc

