Return-Path: <kvm+bounces-27146-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id D2FB397C396
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:49:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5097D1F2313B
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 949B1745E4;
	Thu, 19 Sep 2024 04:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AZ4AFysn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA8D5C8FC
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721257; cv=none; b=SyLbUQqw0C3l9q0E3m3mfjEnQLtvBP6SuKshYzYg4CNPssn4oQQ4m5NrpGbxBcAtq3lO435Aob7/zqJ1dZPC0QlwNEekuc74Ga5HkQFkJ2z24LwFGrtb7fN0hA9kd8lTnKU9xY/lXkHMMfXQi8DJ2Wg08vgflmyajLKUF4Yhdw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721257; c=relaxed/simple;
	bh=+QP0X51SLIF6z5AoVSvs92lSsFVIGaFLT/YtRglR5qc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Iyn9nATUuGIATmN8qAaPNg3dkeP6Q8gznxMxA1bf971lwcE24eTm3Mbw/5JC3ffL62LDCxQOcTNh0upZsVzSN8woTiZHKmsYfH5kwjoPZp2Xa7Qs/3Z2ggbYWlPsP3MXvMO51QqMmIuff2MQfW+vAm3l2B3KnqIRdHZjiVGWHOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AZ4AFysn; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7179069d029so297733b3a.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721256; x=1727326056; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eNWqkzSNCBE+28dt8xOll3Id+6eEjKMEGJfuDzGU1co=;
        b=AZ4AFysnstq306qAddybnf94H+wevJW1E6KMMfAF1kqfZ7U6XlYEUhEgcYy69fzJzV
         surI8KzrGHZKBB8pyN6txkxPpO5YOZVl0hdjPqvnAoYDpMXBmLMM+bL44fK3fo9YdXz9
         +gU2y66OhcUZhra/HjqFUMAeTofxc77ugo3eXbkbY4trICAtluW301cQMxRHqRy8Jh1P
         mKX6pnGLrFzwytS5moeuu6IsnKpBlV4AYmLKtMt9XnVOQdScpxV7hgwddlgtmcvNHaln
         HE/Ofuz9vVgjg6F/onHwoI8hA5wSNzmnoq16bL8PbrRUslKPJr7Q+kHBmA/iEdKmQjWH
         7I6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721256; x=1727326056;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eNWqkzSNCBE+28dt8xOll3Id+6eEjKMEGJfuDzGU1co=;
        b=YmsNqb8I6O8gn+45tcbckdsilCl7jB8ADYdXrUqC4+aSrwCsdkBGTNXY9/TZv9JaH+
         k8L+lF8hvX8PvJ29w6JoRUCBu+tZfbGP2Hnd7uXQbpxrgAhWVa6fApOhQGhq9dPNfq9S
         1CmBwywxl2XKk1Tp4XIN6QgzXiNKS3IF+7FPbpo9eEjdFuSqnSmaRyJkkvg5NoOT8jZw
         ILrt95pODFuoPQn2pfOgDfvaC7hna0/+2IEyeXAusSvS+Qom0zJmSU802HoU7DPb605W
         LIxSFUg65mM7Xfz5dY4rZ6lkB75AW+GN+QBVAPPqUIawAYVJIhy5M4XNaHm3Vmiq+o3f
         MOyg==
X-Forwarded-Encrypted: i=1; AJvYcCUlAjjgvliAz9kEooOZvAXEpfpkH1GtI3Mvf3nHxWNyYU+Yl2yhw5qB8C80udJvGdTInbU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwMHNrBa+qlsO2Jyfq/5jXZ7s1kNmd58mht5IXzDwaOmGWC6JYx
	EAmSIdA0JGiE71IAeoGR9RUJJjAe1pAXqbBQwgRJ8r5nX3QRIILPqaR/fOOJXG4=
X-Google-Smtp-Source: AGHT+IG0RTXo4zmQGQBlENczTzliTQANG1tf/+V1ayQphhYWAEQO8ZekAqNGAnEsgrQycROh/RQPBw==
X-Received: by 2002:a05:6a21:1690:b0:1cf:4348:d5c8 with SMTP id adf61e73a8af0-1d112e8bfaemr31803053637.39.1726721255788;
        Wed, 18 Sep 2024 21:47:35 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:35 -0700 (PDT)
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
Subject: [PATCH v3 25/34] include/qemu: remove return after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:32 -0700
Message-Id: <20240919044641.386068-26-pierrick.bouvier@linaro.org>
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
 include/qemu/pmem.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/qemu/pmem.h b/include/qemu/pmem.h
index d2d7ad085cc..e12a67ba2c0 100644
--- a/include/qemu/pmem.h
+++ b/include/qemu/pmem.h
@@ -22,7 +22,6 @@ pmem_memcpy_persist(void *pmemdest, const void *src, size_t len)
     /* If 'pmem' option is 'on', we should always have libpmem support,
        or qemu will report a error and exit, never come here. */
     g_assert_not_reached();
-    return NULL;
 }
 
 static inline void
-- 
2.39.5


