Return-Path: <kvm+bounces-27155-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E6E3A97C3A4
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:50:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A7BFB220D7
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:50:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B433713BADF;
	Thu, 19 Sep 2024 04:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DZ2p1TTQ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837E013AD39
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721275; cv=none; b=uexngjOsrApSc2sweIsde78sGP5lCR9chIjbS4lPuFEGuRn+NzmVM3TFi/9Uwe6DwIwF030GQHV7Mot8IhQRqs/lt7oW77OttISvmnEnqkRQDD0S1MFFCiOvLKLbJuvVaV5OhUOr2OeWn6zdrOxFofF5MC40S4LqWHekX86y2b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721275; c=relaxed/simple;
	bh=P8irt90jCfPiVTa7W4ZKArTNgFUgTas7aATeexfAzhA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UgsFaYA1N0mX4xgb3cp11DpKEDDch4+bWy24QBZ6+W/KVwgOkrhs8sk+DfFc+v+QZCcz6gTv8UwMKwUla9W9KBHQ7PxuGL561s+9g9IMZQ64Kk5FRRtopb8xAzVSLdWQK89R8/qSNjVYjFUAO6NXxlNZ71ZkHlyjNJ8TYSB8Z7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DZ2p1TTQ; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-718e3c98b5aso280698b3a.0
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721274; x=1727326074; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tx1S3zr1/95ZbSlSEpzuV5Mw8JtyoYuXcwzt94aV9gc=;
        b=DZ2p1TTQTy8jt4dUeT+8+DPp8IRgkUzo/JeagE7jrOjOuk3FjjDMBZ1HBWxOoDik1F
         K2mtlrXvBmLnitevMooNZOdExy7W9HxfTdZFrsq0i6iazG6N3D2NH3EbIER42GtikIxc
         gMbRIm8bBQBJRScHTZfG569r7GktPpuJPSZrWk1nYxXnzl+LH94cljkWkqFC0ptMAXKN
         z0D5HgLu4jrMkBNPyaixJ1Z+X6jqYJynDFoAF+tpTPhrTQzHGX/dtTaBDqwgp5yCAVk7
         x4X/RI6Axz39D6psv0RWk2kO8EjzAa1NIuIODHXgr5Rc2PC015kyflN5FG+8KjF684yk
         PDfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721274; x=1727326074;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tx1S3zr1/95ZbSlSEpzuV5Mw8JtyoYuXcwzt94aV9gc=;
        b=UEoLau3QYYefVPV/U6p2VYvNu5sGmq4RqZvwbYZUb5JAUUak4aLSnx23S1R5j/Gm7I
         cns4VZb6/CA2S61ufnQjGleR0iI0TGcJYf6dK/lkioltx7zrmPtE9gNxyyLUS9WNfKfo
         v+UzInetnul/lE47VeuShEinUu5LBIzIsnWZT8nElvbR0XLHmoSCPuKMPSJygIw3Lwfg
         lcy2SqwxGX5A9awHriptPfzmnTHKtA6Oeyhoeu2AjVdsAJiyrFOxakVsfib+WL69JyN4
         lBUI7i3MK6PQmm4QVsCTsXPtCs+Vtqp9+MQZhB0NV/JSWWN3Aae70dCkibE9jwVmkiAO
         bMog==
X-Forwarded-Encrypted: i=1; AJvYcCWRk3YPvkjf9s1Vk/0JaZUpeFYXhZtU6fZnTlnZCtlFFMle+fE4UF9152BDIBKLk0yUW+g=@vger.kernel.org
X-Gm-Message-State: AOJu0YwXYKwrj9tmopmjWvDyifB4aprjW6Dg3W8HRbrZEL0nMHOsJhCb
	yxKhqXb5eJ8wqMdLFnm6NT3eiLR/V657MDb5ld1LOCoQyqZPjol18X76RRmh1tk=
X-Google-Smtp-Source: AGHT+IGxUDLX/EdmxHd8lBwEQSgvpOMo5EV+rxbHrbQJ6oH4Ek//dhdYk+b8MbHM5eBQ51CMojJGfw==
X-Received: by 2002:a05:6a00:190d:b0:714:1e36:3bcb with SMTP id d2e1a72fcca58-7192606bcb9mr34659991b3a.9.1726721273726;
        Wed, 18 Sep 2024 21:47:53 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:53 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Bin Meng <bmeng.cn@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Corey Minyard <minyard@acm.org>,
	Laurent Vivier <laurent@vivier.eu>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Huth <thuth@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Fam Zheng <fam@euphon.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Keith Busch <kbusch@kernel.org>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	qemu-riscv@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-arm@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-block@nongnu.org,
	Joel Stanley <joel@jms.id.au>,
	Weiwei Li <liwei1518@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Yanan Wang <wangyanan55@huawei.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Jesper Devantier <foss@defmacro.it>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 34/34] scripts/checkpatch.pl: emit error when using assert(false)
Date: Wed, 18 Sep 2024 21:46:41 -0700
Message-Id: <20240919044641.386068-35-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 scripts/checkpatch.pl | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 65b6f46f905..fa9c12230eb 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3102,6 +3102,9 @@ sub process {
 		if ($line =~ /\b(g_)?assert\(0\)/) {
 			ERROR("use g_assert_not_reached() instead of assert(0)\n" . $herecurr);
 		}
+		if ($line =~ /\b(g_)?assert\(false\)/) {
+			ERROR("use g_assert_not_reached() instead of assert(false)\n" . $herecurr);
+		}
 		if ($line =~ /\bstrerrorname_np\(/) {
 			ERROR("use strerror() instead of strerrorname_np()\n" . $herecurr);
 		}
-- 
2.39.5


