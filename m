Return-Path: <kvm+bounces-20342-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id DA6A9913CD8
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 18:46:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D08E2B20621
	for <lists+kvm@lfdr.de>; Sun, 23 Jun 2024 16:46:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C36183075;
	Sun, 23 Jun 2024 16:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wWG9xImM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E1E8BFA
	for <kvm@vger.kernel.org>; Sun, 23 Jun 2024 16:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719161192; cv=none; b=a7qt7EPxrjSE8k1vG+l4insaU/zt+P6TbMrm3tuLw3z/b2jojp1mx/tteyJNSqmi2r7NI4knf1t19eNG9OBgPbXsD8dnt5PuTeO0IVWUHQwU/o82qDfryDDcykdw52xgLQZeaGQRWmtmXUfSebry7wlGT9c/5ylRGjaGNdjenbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719161192; c=relaxed/simple;
	bh=ktLTDh3yONNNk5qCL8pEySQq66gnDnzOPy9c3BlgTaQ=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=e7Nhc7LWhM2QqBHBLsLjb+8buI68ZgNuftifZPqsEnKsWBrgr7V0bNBgGWjVGFSbMwqxqQmlI2d6qjG1WTK2c7Me5FR8929Vbp9gOcv++BR821YinLLl75xsQdrD/zyRUY+ykGg7pLheG3d40mdpUVCaoVcrwgMbHaZAbZPD5tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wWG9xImM; arc=none smtp.client-ip=209.85.128.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--changyuanl.bounces.google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-62f8a1b2969so73703487b3.3
        for <kvm@vger.kernel.org>; Sun, 23 Jun 2024 09:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1719161188; x=1719765988; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=R9lWbmtvD/FtBKC/4BvB1Rt0D178vL9nREKAOaVsONg=;
        b=wWG9xImMvPD34nLxREd6pYlyXCnsSaUoFzOZGnZ8LwccXkeUdI6AJYoqbo/S57Cd/l
         CQzy4Lr1n4toSExC5mlO6sYY7rjOxwCwu+4moN/cAX+KEafR0jaIUblGDJDwyETq/wt2
         vz9KSUn6qHQlGl7gE4g3UvH3vj50xwt51XVOelUB7wA+tV5YRO9EizRi48x/3MiRvNSp
         +VroGl8YdIwJROeI+eHtgdP/fJFw65VTpaueI27xdp3nu347+NqDxc2H3Ui9HY5Lwq0C
         nLcLtWgtzXhnUElRF4FaIPLpp+08IdJBbPVGC3B31z6bw+wmQzNORd5KYDZKH3rToFAX
         DUGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719161188; x=1719765988;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R9lWbmtvD/FtBKC/4BvB1Rt0D178vL9nREKAOaVsONg=;
        b=UoqbDLnspsyVPNTBEJMg3ik31Ov6Kb6+IxH4eVyY9dBy8xw88UXiqbh7hJnJ3FfgG9
         4NH2h3YTKZRkCYOZXQF6ApfE57OgJtLiGO7dwTYaMSzaFveJeiPl1aaUOHBpipfroRYk
         AS4z6MdUgF9iApLvDla2jBAwpTpfFSNU+K41H6eRrbWPS4CWoiq04mKa+2SRaOUHYR6H
         8IJG97+UXSdSi0TbWjpc9Snh+JTqm16+W2LOEyVQLKyPmU3f0wVziFsw67S4FSR7uK+4
         YNkoWMPhH61Gd3Ro2n+kXS7x7lTuFVMHl3PmlUkRcmy3rk32H/g/C0FZO2sAafqpyPyn
         Sr/g==
X-Gm-Message-State: AOJu0YyqUk48sVmqzQktJWjLgFI6zAKiIiDXgvYhqIlr77MLRAismBz/
	rzwaSCcgkASrgHYFVVAe+uerCZJvxy4SW3dd+cBc6unPXRNF8m6B4f/iSvnIepi0Ky96biNQ3Rw
	EyP62H3iMfaTJjlPNSw==
X-Google-Smtp-Source: AGHT+IGjc/K0I2YSI5AvzB60q+qfp5+lcXp+Wztq+8cPlJ8fEUgX5e62SCaUOpwgRwZE9H7J1KWleU45Q1kaYkQH
X-Received: from changyuanl-desktop.svl.corp.google.com ([2620:15c:2a3:200:c9fa:2a0a:34fc:4e66])
 (user=changyuanl job=sendgmr) by 2002:a05:690c:7201:b0:62e:81e2:99bc with
 SMTP id 00721157ae682-643ad5c66f2mr146137b3.9.1719161188243; Sun, 23 Jun 2024
 09:46:28 -0700 (PDT)
Date: Sun, 23 Jun 2024 09:45:39 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.2.741.gdbec12cfda-goog
Message-ID: <20240623164542.2999626-1-changyuanl@google.com>
Subject: [PATCH 1/3] Documentation: Fix typo `BFD`
From: Changyuan Lyu <changyuanl@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Jonathan Corbet <corbet@lwn.net>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
	Changyuan Lyu <changyuanl@google.com>
Content-Type: text/plain; charset="UTF-8"

BDF is the acronym for Bus, Device, Function.

Signed-off-by: Changyuan Lyu <changyuanl@google.com>
---
 Documentation/virt/kvm/api.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a71d91978d9ef..e623f072e9aca 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -1921,7 +1921,7 @@ flags:
 
 If KVM_MSI_VALID_DEVID is set, devid contains a unique device identifier
 for the device that wrote the MSI message.  For PCI, this is usually a
-BFD identifier in the lower 16 bits.
+BDF identifier in the lower 16 bits.
 
 On x86, address_hi is ignored unless the KVM_X2APIC_API_USE_32BIT_IDS
 feature of KVM_CAP_X2APIC_API capability is enabled.  If it is enabled,
@@ -2986,7 +2986,7 @@ flags:
 
 If KVM_MSI_VALID_DEVID is set, devid contains a unique device identifier
 for the device that wrote the MSI message.  For PCI, this is usually a
-BFD identifier in the lower 16 bits.
+BDF identifier in the lower 16 bits.
 
 On x86, address_hi is ignored unless the KVM_X2APIC_API_USE_32BIT_IDS
 feature of KVM_CAP_X2APIC_API capability is enabled.  If it is enabled,
-- 
2.45.2.741.gdbec12cfda-goog


