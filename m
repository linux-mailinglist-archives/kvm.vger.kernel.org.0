Return-Path: <kvm+bounces-29364-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4DA5E9AA090
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 12:57:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AF9C8B238B7
	for <lists+kvm@lfdr.de>; Tue, 22 Oct 2024 10:57:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DCDD19CC17;
	Tue, 22 Oct 2024 10:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s+TNplj+"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0819319B3EE
	for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 10:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729594583; cv=none; b=XDTYUBn2GRwKc6y3WynBjTzW7cat3AqZun5noj/ADj3RgH5lxXeC+khgvnIbHajrNYmxK7SDDT+p7ckCVVabwqka290zbKtkPeiwWmueS3Hkq8xbyqG45cf/p8lJguA0/NNmBsIIAb9mB+3gR7pgoG9Mbdmbl9rJ+bboJW6JPhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729594583; c=relaxed/simple;
	bh=HJ7Z/tpHGMdXyiozbqSlWM/DfmvRMwN6gEUJ22MTOs8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=B+xQqyKbdFzxgfWW5JVqMPjGOYndTkcuX501N/8kh+MQyidWI1bS8olATSKC2cPf54BHnBvo0InowVCKAV+Ha55DrXLz90GK6h4eMZIFYABhP+JKUdkiKOSBeDLlNyCse44gQBZ7+2264XUSZionjYavDPYnnnY9ZVPtsgrT/g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s+TNplj+; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-37d473c4bb6so4950508f8f.3
        for <kvm@vger.kernel.org>; Tue, 22 Oct 2024 03:56:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729594580; x=1730199380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=COTB8IX9EL+KvqwMSRlZ5WoxH3jy7uQtMVM8wKCP4/g=;
        b=s+TNplj+nPZhX2f/hF1Vu2ZfiCUfiNwRyOaBatBrIvzKtwt8uieJ59Iy8ohHaMI956
         qBczgqg2MX04KtKpsYt5msKZw8ZRxxW6gJW9g33t9XkHc9sWLjVIQ/2tUXsuOW5/1ekr
         zjOPVdwDUyIrF90ZoCyyB/TZvlQsyq4mMXbXArUfVCAP2fNAa1jqZvxJAUfXfiTwu5YT
         /Bqixm8l2qJgNqO3IT1eGww0+Zj2bG2JSQj9LuvUj/AROAxRlc895RICtOhHgSQ7f1UK
         uHfoN5e1b+i8g0DqO/xgVPUhQX4ImMF9AKfFRqKZetKoqoAK8H5KdNIkb8pSLzWg38tV
         CVKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729594580; x=1730199380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=COTB8IX9EL+KvqwMSRlZ5WoxH3jy7uQtMVM8wKCP4/g=;
        b=PN/FxLMggK4p5eQLBCn6Njh9D7OnRa+Ruv7kkL3BMPyZBsYcRVwYeyVtZ1x6jVuW8u
         JB4l+HSH0nw0K4ffpbDIFeLDwZfk8vhJSksWiKPOjqZaxYezYj1kmHdUc9c2WsCJDDEl
         pTvt3V8ND5wcIWP3Ff3YZ2tFd+Ruewci6BH9MLQoKJIvwl8iNi1B5kDJyKXZHfxX46u1
         kRuoZjLd07o6fa+Kzqss4LmMkbllcpgDmkhaSyXpkrQC5kq0M/OZqQu40Lnta9IBWyUn
         P1fTefNPbzqE+TNVVQlvny3MOeBR7nbBC3Mu8vLa6pZL9m+slCxSRBsUuwmNvUaEYloR
         W8BA==
X-Forwarded-Encrypted: i=1; AJvYcCU+/HrOvisC2uudM7MDLZqlnbvsoz1DmvX9FWrsYUq+hII/DOmB2hYJQWP2L3CV9pQPYBM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwUHG4NGJL+BOEMtIbDJTkfl1qwDjwak8q0YeVA2Bs/6AJHVrSH
	UYMwgygFcjhX/fDBaV+Q5GUXyLYndf4tsFkku5+YLX6jdOBIA9WNcuaj+lJBNyQ=
X-Google-Smtp-Source: AGHT+IF8gTYNUNEInBLeGzU/PWN6iK1a20tMenTDraAJtih3b9OaMANLgGCpLzqKTnRdNaK+s8hEig==
X-Received: by 2002:a5d:424c:0:b0:37d:51b7:5e08 with SMTP id ffacd0b85a97d-37ea21d8fbdmr11273338f8f.18.1729594580178;
        Tue, 22 Oct 2024 03:56:20 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a91307874sm323980966b.94.2024.10.22.03.56.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Oct 2024 03:56:19 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id 2F1E35F92E;
	Tue, 22 Oct 2024 11:56:15 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Beraldo Leal <bleal@redhat.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Wainer dos Santos Moschetta <wainersm@redhat.com>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Thomas Huth <thuth@redhat.com>,
	John Snow <jsnow@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	qemu-arm@nongnu.org,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	devel@lists.libvirt.org,
	Cleber Rosa <crosa@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Riku Voipio <riku.voipio@iki.fi>,
	Zhao Liu <zhao1.liu@intel.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 06/20] scripts/ci: remove architecture checks for build-environment updates
Date: Tue, 22 Oct 2024 11:56:00 +0100
Message-Id: <20241022105614.839199-7-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20241022105614.839199-1-alex.bennee@linaro.org>
References: <20241022105614.839199-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We were missing s390x here. There isn't much point testing for the
architecture here as we will fail anyway if the appropriate package
list is missing.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 scripts/ci/setup/ubuntu/build-environment.yml | 2 --
 1 file changed, 2 deletions(-)

diff --git a/scripts/ci/setup/ubuntu/build-environment.yml b/scripts/ci/setup/ubuntu/build-environment.yml
index edf1900b3e..56b51609e3 100644
--- a/scripts/ci/setup/ubuntu/build-environment.yml
+++ b/scripts/ci/setup/ubuntu/build-environment.yml
@@ -39,7 +39,6 @@
       when:
         - ansible_facts['distribution'] == 'Ubuntu'
         - ansible_facts['distribution_version'] == '22.04'
-        - ansible_facts['architecture'] == 'aarch64' or ansible_facts['architecture'] == 'x86_64'
 
     - name: Install packages for QEMU on Ubuntu 22.04
       package:
@@ -47,7 +46,6 @@
       when:
         - ansible_facts['distribution'] == 'Ubuntu'
         - ansible_facts['distribution_version'] == '22.04'
-        - ansible_facts['architecture'] == 'aarch64' or ansible_facts['architecture'] == 'x86_64'
 
     - name: Install armhf cross-compile packages to build QEMU on AArch64 Ubuntu 22.04
       package:
-- 
2.39.5


