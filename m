Return-Path: <kvm+bounces-22291-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C132A93CE6F
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 09:05:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4075CB2145B
	for <lists+kvm@lfdr.de>; Fri, 26 Jul 2024 07:05:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3655217625C;
	Fri, 26 Jul 2024 07:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pj98gb0Q"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 272C22C9A
	for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 07:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721977510; cv=none; b=Rr2D1LFG7L1SCBVi7mGxHNVbf7GW9rJLrH5wTmu71FGdQtGGWEjDW82E0sFTuFag6G9Sqh4IX17uAAxPy9Y97zoXln06+j/NcTE5FZ8W3DmXUQ4YgPwAXlTcVvpO9mG6OlM+T8Aas16oNXJSZSHVScWhkdhCYnK0OtI8DiXSCEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721977510; c=relaxed/simple;
	bh=ePoQDBOljie/PAIdA29IdlHLdXXno4q+lWAOxk5v0NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXEvAZNDb6+m8leOZSejp9otljE9r8BUbL3zbCBKlJmfcmnCWq2g70vV8IE4byGgEJheKWPWSHoi7clqaA6c0xn7govmhmzGci16r3L85gxn8urykAxhrljicmI2VXO1R6QMOhh4G28kaJzc1wi7CVGIubEFC7aC79uApaQjEZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pj98gb0Q; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1fc60c3ead4so2743985ad.0
        for <kvm@vger.kernel.org>; Fri, 26 Jul 2024 00:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721977508; x=1722582308; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AlL02NVw74MFSC/yhI5nsHLWx0RtX66JOTXIyHAITXU=;
        b=Pj98gb0Q7wUJaZCnA8/6Lbm+uocBDCKe1S39Nxq7mCKZ9evQ++qzJhTZPgCdhbv02P
         mu2zZZaIjU2N80tnMT2PXYOecVJruXmkbN2TBD+ihe76JlU8/Naq0kQCe9jxtEDr0eVP
         FeyHV6A+kmhHTLNvwqHwkwjcpL5GRj7u4kdDOufx2MxKKAIy6EO8eJWe28LeGWotSFQS
         oS3H5P70gojJcCzs8r2UrN5lhQyQPzI1pJlfWuoxdlB5ADnKK8zlgqermvVq7GIEYlMD
         FLs7SH5ftcxWkNjOlm1qJuHIXyGncu9y21j2CTzMSzwAj2VRzhPgsM8RonveozQ7AqxJ
         oxGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721977508; x=1722582308;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AlL02NVw74MFSC/yhI5nsHLWx0RtX66JOTXIyHAITXU=;
        b=hKpi9l7jlyWCbEs+C6naks11RONSMByEV849fdwQ0tfuHSnp1loA5GmhOqcyy1Xf5+
         RzepNFHBg74hhbnz9ytnMqJhi59tJCXoluGM06drzNPVIoq6XqK/hSzMyXCU3e821tbi
         pOwKCMxrulO108FKqgvV4AxbCcejdPOHVGs7Bm4dsuEfyCWAu2PzCssSlEa6o4OP1Pzl
         BLTqYJ0c2j5rpBGiGkQjuNVIRjvuGlY7x2QeA0oqhgw/2XiLgSFSlqwxeIfPIQrYvCS/
         kyrlMRURqyV4uCY5tndVhjlX4A2z3CSZYwBtotEUaFkE1mbypxWJJjG3bZ+lSC69u0Xr
         zYVA==
X-Forwarded-Encrypted: i=1; AJvYcCXfmZHnC5INLCjvn0RreLO8RCtFXXr8ng552lksjn0BrNmYW95vcuNne/P9vUVPthjAghjUyFQHDA+42VvlISfzFcBV
X-Gm-Message-State: AOJu0YzDPiomd1C9Oka1OlkUjNF1JmmnxdiYVQDelYX4KN6S4gtFJFAs
	xrnFv9+Vq32LOe3qMvRsvdsq2M98guzmdh1YSl+KtAKYEQawC0CUAn9xwQ==
X-Google-Smtp-Source: AGHT+IFVWd6wftyjlJrqcIWbOeb2e01emjkI9ZIX5mw5W3Q19XSGlHX8LdwSk/pssz+KAhMNy9GTZA==
X-Received: by 2002:a17:902:c40d:b0:1fd:7fac:a539 with SMTP id d9443c01a7336-1fed3860075mr60430125ad.16.1721977508436;
        Fri, 26 Jul 2024 00:05:08 -0700 (PDT)
Received: from wheely.local0.net ([1.146.16.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fed7ee4d26sm25034215ad.166.2024.07.26.00.05.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jul 2024 00:05:08 -0700 (PDT)
From: Nicholas Piggin <npiggin@gmail.com>
To: Thomas Huth <thuth@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>,
	Andrew Jones <andrew.jones@linux.dev>,
	kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH 1/6] gitlab-ci: fix CentOS mirror list
Date: Fri, 26 Jul 2024 17:04:42 +1000
Message-ID: <20240726070456.467533-2-npiggin@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240726070456.467533-1-npiggin@gmail.com>
References: <20240726070456.467533-1-npiggin@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The CentOS repository URLs have changed, so the centos7 job no
longer runs. Apply a recipe from the internet that gets it going
again.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
---
 .gitlab-ci.yml | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index e0eb85a94..823f03c3e 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -300,6 +300,10 @@ build-centos7:
  extends: .outoftree_template
  image: centos:7
  before_script:
+# CentOS mirrors have changed, these sed scripts fixes the repos.
+ - sed -i s/mirror.centos.org/vault.centos.org/g /etc/yum.repos.d/*.repo
+ - sed -i s/^#.*baseurl=http/baseurl=http/g /etc/yum.repos.d/*.repo
+ - sed -i s/^mirrorlist=http/#mirrorlist=http/g /etc/yum.repos.d/*.repo
  - yum update -y
  - yum install -y make python qemu-kvm gcc
  script:
-- 
2.45.2


