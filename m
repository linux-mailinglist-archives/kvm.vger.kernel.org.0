Return-Path: <kvm+bounces-44229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 15FFFA9BB39
	for <lists+kvm@lfdr.de>; Fri, 25 Apr 2025 01:28:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 873FB92684A
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 23:28:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A88A628BAB6;
	Thu, 24 Apr 2025 23:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ADXCB0HU"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E7771FAC42
	for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 23:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745537320; cv=none; b=eGOe2Q8rRAffgedHaoMd3/4V3MV6OKu54UJVKN5VMG9+5ZlN3c/JhYKMZjLAZlRp/cxb5wIsqrPkCz1vEKBXJzoW3zJXC/UD874GrYCkYeWUJmEQmc7VzDyrefaZHkhJBChnopVY5YfWj8Lh395aAY63jNL2DdgCWI5C/HFaI+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745537320; c=relaxed/simple;
	bh=6iTbXxrOC+FQUszi61efkpuNcH9AIbadjdWDmWYewY4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=Lt4ohQREIu4UrT6cKVogJIWEBWW82PHHn+u80duilDwDBUBDT29ImkkiXzji72UnGNvAJPxSgP0bX/YpZ3uhFBcJRAPMAnOwzLONOTyuBlizemhk+TxCAP9aeBYdKDODmKmoDJu6K3IHrD3GcfUiE+4iXyigJweYD5mPfxtwH3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ADXCB0HU; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736bfa487c3so1298525b3a.1
        for <kvm@vger.kernel.org>; Thu, 24 Apr 2025 16:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745537318; x=1746142118; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nqXAQYhS4Bh1OmBDa4EVDlQtZQFbRV2hzcZntGGtKyg=;
        b=ADXCB0HUCaPu3A0Csnt+ih0E3KMLzLX4AoARZvz9FCwSYcgxajelrvn2hz9x5r2ge8
         ikD+dUrd9MfcHSC2RE/INMa8x5wWPp6dxhUefBHJKR1wuuZdNUosAJJVwm559lHLQtE3
         3zpsPoT7TxR8XvPxwvV0CylbkQPtIMQmwIzrXFE/oX2hSOsNnHFAR1oUCSbmJyss9TQF
         JD8JUzxXzH76YGxOqrQGA04yAfHbfeVpmk/oBrtEbpHKJjfWlJ7HQLopIQtJ+ipmgXoF
         5y2VmpqHI7Mk7ZboGt97h3W8+aNCw4yj5O988S6qJ95HxE4xEuJoy95Fe20u5+1fp6rr
         yEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745537318; x=1746142118;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nqXAQYhS4Bh1OmBDa4EVDlQtZQFbRV2hzcZntGGtKyg=;
        b=arYtuAoev6dZRz6Yxc7NdRmm6I5QB5dbt7sclP9P4myxqQ6opLz8XRr4GcYt1Lnd/O
         B+i0WJSwtzwC5dw5hityNcOeQuNtxELunnexHDkCmoMp6kZXeEcDNwkQ0aiBsnJJiA0+
         RlnZmDW3ONucuSrkIur9KsCjFp89LIW7c6rehO5Pz2hWTkNMlNJNClIjEu8wUHMc+Wvj
         hcYgu/8TAEwes0RML/s9rKngaTXMWm5qMQMSKvizr+kzRuYTSwKw7y6+pkiVVH808Sn6
         NjKZPr/K07CJwKAnDP3WmecmdbfmoTtDsfw9n9aC93MRxtqKZYFF5BmKo8q8dCq6Z/Wr
         mLjg==
X-Forwarded-Encrypted: i=1; AJvYcCX/d4PBp1HVUD0a87CffDKf656ABDNUSP7+y+tJz8NrKMisfn8jfLioh85bgFb/WPBbppk=@vger.kernel.org
X-Gm-Message-State: AOJu0YyLfTtpzR+8TEoLuW5xZK8Ql0NclRZmp2y0/d/sdkZfW4uM91kv
	aKKvOwXm3dwjo2utImD3GmH9PLIhiMoRN5SAxhtIp5AkZglkrPbm6hYq2FoxhM4=
X-Gm-Gg: ASbGncsCI/6JSSY25LX7mCcDczmNYZ+/zkwJXA48ACytGWq1zssjOXjyHOn0g1uBWm2
	wvfCHxTq5CnvP+TgXhuibVGjcYnYuKQjEXRN+X2d4CCwLNp9NXHtoxB7B04E+dKIH5cRMJf/n0n
	PPqWSuOyqO9nZBQ3axWCIHhksNWxyxJFol2MV8oGAx6CPk/xIvLpUBYyU9ITrv/gkMalGiVoYBD
	gXrHIFiEhFgVIdWpGzAL5botOb4p/TKi6eY/nq+VFOvlo88JtESdVu2sf/qF5RZgZNRpIxRgRXJ
	JummNVzeKsbBe6qLwvgZUg+TQ6v8VsJQ68nNF5n1
X-Google-Smtp-Source: AGHT+IGynrVcsb8j8FQzQLDggyJv0ZmmjAksc6U5KRwr1rOsEqff65QrOsoQY0/q0tsIBrLI4H1Hnw==
X-Received: by 2002:a05:6a00:1902:b0:736:51ab:7aed with SMTP id d2e1a72fcca58-73fd876de49mr111744b3a.16.1745537318401;
        Thu, 24 Apr 2025 16:28:38 -0700 (PDT)
Received: from pc.. ([38.41.223.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25accfbesm2044318b3a.177.2025.04.24.16.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 16:28:37 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	alex.bennee@linaro.org,
	kvm@vger.kernel.org,
	philmd@linaro.org,
	manos.pitsidianakis@linaro.org,
	pierrick.bouvier@linaro.org,
	richard.henderson@linaro.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>
Subject: [PATCH v5 0/8] hw/hyperv: remove duplication compilation units
Date: Thu, 24 Apr 2025 16:28:21 -0700
Message-Id: <20250424232829.141163-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

Work towards having a single binary, by removing duplicated object files.

v2
- remove osdep from header
- use hardcoded buffer size for syndbg, assuming page size is always 4Kb.

v3
- fix assert for page size.

v4
- use KiB unit

v5
- rebase on top of system memory common series
- make hw/hyperv/hyperv common

v6
- rebase on top of master (now contains all changes needed for memory access)
- finish making hw/hyperv/hyperv common (hw/hyperv/hyperv.c)

Pierrick Bouvier (8):
  hw/hyperv/hv-balloon-stub: common compilation unit
  hw/hyperv/hyperv.h: header cleanup
  hw/hyperv/vmbus: common compilation unit
  hw/hyperv/syndbg: common compilation unit
  hw/hyperv/balloon: common balloon compilation units
  hw/hyperv/hyperv_testdev: common compilation unit
  include/system: make functions accessible from common code
  hw/hyperv/hyperv: common compilation unit

 include/hw/hyperv/hyperv.h |  3 ++-
 include/system/kvm.h       |  8 ++++----
 hw/hyperv/hyperv.c         |  3 ++-
 hw/hyperv/syndbg.c         |  9 ++++++---
 hw/hyperv/vmbus.c          |  2 +-
 hw/hyperv/meson.build      | 11 ++++++-----
 6 files changed, 21 insertions(+), 15 deletions(-)

-- 
2.39.5


