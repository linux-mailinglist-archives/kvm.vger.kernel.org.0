Return-Path: <kvm+bounces-24172-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C371D9520BB
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 19:12:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7879E282F34
	for <lists+kvm@lfdr.de>; Wed, 14 Aug 2024 17:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE561BBBCA;
	Wed, 14 Aug 2024 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="l+X1ece9"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDAC28DC3
	for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 17:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723655526; cv=none; b=eD+OpxI+Rb0ThEWEwwAbgxtQwSC2IoAfsOUbv4mRkvKz//LHCLyUO8LkjTBE+Y6CGTvwHGEy8U1aBShzMCU7fwrGoBeBHVe/p6gLbrJqpO0gixuA+gcFY/Lzp/ahiVTPM2JjBzXhS0aqF9KbocDgDv59Agd30sWPgs1Ya9wcDS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723655526; c=relaxed/simple;
	bh=QTbxAnbHApPnpWUfMQnNAvWgRohjV9hFzt76/7wsyG4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=g0ewch77tE2yIZtiwppdg3/lnzqwMHW+HvNVXDAZ+z6IvBKjd30YO27HKwn45xhkp1qgCNJXs70qQy9ULErO1rn39BY4dRK8Cmee/mXS0DoV1VQFjAXfpeabLZUasEeSYPkCAd2If7DR1LNTH8+wOcPKWcf7XcPsHDefcwOu9zE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=l+X1ece9; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1fd90c2fc68so664015ad.1
        for <kvm@vger.kernel.org>; Wed, 14 Aug 2024 10:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723655524; x=1724260324; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Htp/8g1R2z3d38RDUYPogVSSaWK2pqHvMB0hVXVdWXw=;
        b=l+X1ece99W+ZSsCq7SXzLbo7kNgHBmqXU/6JtTI59230hSmGAcc+0mmEAIoLsBFj+F
         u/zuAg7F2lxvPoQcvJOqF4+Yn6rGiNYj87h5Yuq14Kf3oDNYh+eTz4OEBrxr+9/oz1RK
         D4GxxdeSRfcNqoY6b+e64/itLAkWo8yma+M6teNfXBoEJqoLYp82iWJ9Inae5cqjdbDj
         8IQ0/ccIq0O91wnYCO6uxPIyDKCclNLaU9X4t4NYjtY4adVUja9FWdIBz6Ooe36u3luX
         LKK4sjAC6JM2Db5S2Tix6FWPvCEHSuvZzQE9cBX7e4h6XnGwF7gzhPN3Jv/WR7OLEe4z
         gM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723655524; x=1724260324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Htp/8g1R2z3d38RDUYPogVSSaWK2pqHvMB0hVXVdWXw=;
        b=J/BFwZ6ZBLJCiTOMC32wO5Oi42pzJFv6UVPj8fDuIG24FAgGmSbDfNENxg9zDRaNAR
         IYqeekYH5KSOn84228h2CFg5dTEG3wUeeTddcUCrkH4qPIAvImy5P2MiyIsHXBd60NTu
         SmazVBPfSNkzQUzFBOPHQ6TW0w2bURnESw4zCGf2E3vOn8Wl4cFpHUT9WmsXXdQI8QlN
         IUPqH7dbzFxiDKe3deOWCrkDQWHcyofzSHy1gXO8DxkY9YnRVYUxF08IZ+yvHpL/pDHH
         paAg4FyJif2VMXoxJxzK0ZxljGJBB+wp9IOg0ur+dwKKLJs9KbDf7cGZiQ75xc3Q6TJn
         8J7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWYuSk8q4NOifrlGB0xjIhy88P8yEsvzoSY4ADpn9ktNfpOu2BAUYkqJKaIIEQTfjCf14AJJU9PEATvcoU741oqOLhz
X-Gm-Message-State: AOJu0YzbP8oobAgfb3pHKe3n5zRoRdrGMPErt2iG04QmKPWej87UgSSO
	ac0v4wj2hHBqZay7khvd0lVMGzpV3ybztFECMzXgQitKI7CTov0q8nunRugo4yA=
X-Google-Smtp-Source: AGHT+IETPkjiP32R23n1L+lgXiz7FUq2+2pRy2MPK5HVKPfPEe+6AsVieMnKEKbFzsWCaeqABPMWfw==
X-Received: by 2002:a17:903:2446:b0:200:9535:cf13 with SMTP id d9443c01a7336-201d6393a5cmr43674185ad.1.1723655523921;
        Wed, 14 Aug 2024 10:12:03 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::b861])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201cd1c8783sm31813895ad.245.2024.08.14.10.12.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 10:12:03 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
	kvm@vger.kernel.org,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Thomas Huth <thuth@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	qemu-s390x@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Beraldo Leal <bleal@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 0/4] build qemu with gcc and tsan
Date: Wed, 14 Aug 2024 10:11:48 -0700
Message-Id: <20240814171152.575634-1-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

While working on a concurrency bug, I gave a try to tsan builds for QEMU. I
noticed it didn't build out of the box with recent gcc, so I fixed compilation.
In more, updated documentation to explain how to build a sanitized glib to avoid
false positives related to glib synchronisation primitives.

Pierrick Bouvier (4):
  meson: hide tsan related warnings
  target/i386: fix build warning (gcc-12 -fsanitize=thread)
  target/s390x: fix build warning (gcc-12 -fsanitize=thread)
  docs/devel: update tsan build documentation

 docs/devel/testing.rst       | 26 ++++++++++++++++++++++----
 meson.build                  | 10 +++++++++-
 target/i386/kvm/kvm.c        |  4 ++--
 target/s390x/tcg/translate.c |  1 -
 4 files changed, 33 insertions(+), 8 deletions(-)

-- 
2.39.2


