Return-Path: <kvm+bounces-27141-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 94C4E97C38E
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C3166B229AA
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:49:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C046C5589C;
	Thu, 19 Sep 2024 04:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CFtzh0sD"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A067552F6F
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721248; cv=none; b=hgtt7abu35fnzQeL5r6ismHuwHvCwTYkABRMQoLPTjE3i9RFRphvo+xPie2YFw1RIJbqWxDJy46/tZGOi52dO4Jo6x/UrhR/ESZ/vHFZlt94UG8AmZ1kXF0dpEpb8v56FpqsBnfAR85etPhmjHc3r/w7sy8Bmc2/N8TXfxSd9ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721248; c=relaxed/simple;
	bh=GmFJeUgV5bFGkizDdfVVWI5ddUSFN3ijhX6KnkR3hS4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZB2qKyIUXriFyRJQOF66EgJ2rfsicT5fJl9zPv7bdmZz3zM1rW6krB0vY/MoCZ8xXbiNJjbPY0GnIg23XN56wXs5W26MGGPrI+sWOXGYDxgNpD3ER8oaVi2bZ9uL+AlX7qH03kt5/OErSGRlnc5B4fs07FFShVNRu4DRTDYvQrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CFtzh0sD; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-7db12af2f31so333534a12.1
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721246; x=1727326046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRUr7Rigd7KXsxIxUKl75LNzfJl8HLKhUx0dIIEBKEI=;
        b=CFtzh0sDXYNXzqPtKEKM3lKbDjkKiMYrTpe6yUDeTBGjKxrDLg3fXS3ylMAd64R4UB
         Xc1q3sK5H0U/TDlRzxejS/meKvHzmtNRMO865/cDWqQTxeYSxoXhhoxsbeX1Jmy0UwGs
         x0N7Cn74nqfs+JH9SvkpTAIaGEPWznPFdp1mj3pQnUAaUKqCQ5ONIeeoJskpY3L7W2Z1
         wWBwslGYcpySU5NRqYmuTw2gmLfoR1tl+RwsP3Rn8hokc3lY3E072iwQNgF4B2iqdBlu
         OC2QABKLVJLWHTElH0CfrWVIJN8mwOC0P4hiw1K4AelqGExmqVOa+Hh0QiBbZKRhIBgz
         pEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721246; x=1727326046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRUr7Rigd7KXsxIxUKl75LNzfJl8HLKhUx0dIIEBKEI=;
        b=v7z+XWQ9yyJ8MXRMjyaLRWpppILaDs2vN1TSsDY7yTEbekIi+DSjJNj2wmYkgfFdWF
         iclkNEtkIM9ZKes3WCUYBN7h2YAOndPDtl5jisx1H58vL0NfT0diJe2Vtjniig6G7fkV
         b23vxpfqf+MlFxPUj2gI+EgdwRgPS4/6ohg0GnKl6fx7jm1k6skvUAq2h5k0EnX0O7r6
         Vif//ZnNj9yaqmLrgKvtfiFH4Tla4KEIVLj+oKZCGhmwY35Z9coESmP1luYFBlRDmUzo
         PY/TG+/NeYk0Ycs5n2lOUoRLTXRtEsvqeKMBOOas13RIb8rq44iE6wcehyls268cI8SZ
         SBiw==
X-Forwarded-Encrypted: i=1; AJvYcCXOkrrXnYBbCH+b4WbRalnLyM+KYsVeNHqV4RFQhLGreOAalwPUvGnfILwmApmVZJm8Z6o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd9k9RBpJvgSUvRS8mHRoXEVe3/BGTGpmCgCWrbO2N7jDSv/e7
	aAyVnHn9ux54LatDdWcAcSDnYhqBwJkGLoQqthkp3bicv3WW+Kxks0Y0L4uxyTY7GaMsrQGoyfD
	VExKvjA==
X-Google-Smtp-Source: AGHT+IH/FIQf5IQhPyXOoAeAod0TK8mpE9ZpDATxxMEhePCSvOyFGL8wr8yUWnyqTIM9Ik9UbYX11A==
X-Received: by 2002:a05:6a21:2d8a:b0:1cf:1217:ce87 with SMTP id adf61e73a8af0-1cf75ea2251mr39237052637.2.1726721245964;
        Wed, 18 Sep 2024 21:47:25 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:25 -0700 (PDT)
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
Subject: [PATCH v3 20/34] hw/tpm: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:27 -0700
Message-Id: <20240919044641.386068-21-pierrick.bouvier@linaro.org>
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
 hw/tpm/tpm_spapr.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/tpm/tpm_spapr.c b/hw/tpm/tpm_spapr.c
index e084e987e6e..5f7a0dfc617 100644
--- a/hw/tpm/tpm_spapr.c
+++ b/hw/tpm/tpm_spapr.c
@@ -206,7 +206,6 @@ static int tpm_spapr_do_crq(struct SpaprVioDevice *dev, uint8_t *crq_data)
                 break;
             default:
                 g_assert_not_reached();
-                break;
             }
             trace_tpm_spapr_do_crq_get_version(be32_to_cpu(local_crq.data));
             spapr_tpm_send_crq(dev, &local_crq);
-- 
2.39.5


