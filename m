Return-Path: <kvm+bounces-26353-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5642297457F
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:16:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 844021C21150
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:16:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11F111AC44D;
	Tue, 10 Sep 2024 22:16:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bjNqxyHZ"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2BE1AC430
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006580; cv=none; b=eatqY48zIx1dwmcundHYoaRTRpJDs0mnfYBMpeoxAF8kjRYHwxjPdnZaK8M2jB7cVC/de+k7Dy8aZGYpnW9/K7Q+Vbz8qWqfHEwK5TgnNGDOhjiDgkJeSGeI+1ZgyuxfT0nmBSPftst9+EfaeX2Him4PffuXHFduPYbkPV5qoc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006580; c=relaxed/simple;
	bh=vQXtdy01NMoA4JiKiRK6sCArFYeqcIuud9ukQpFEfcM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gzZtfwyibGMGh4B0F+nKBxa5qI846FiKsPQND+MLdrVfZqUDtJKJaUPOPVDAfuOCixHJEEUnL6Ys8RhTJlT3GSEet0LT3oQB98gD6HC4AhJamSlmXQcUT6A/Pg+hA/Qw2HW8Mx5DfPj9LW8PicHVUGeasYH2rEH2sc1k+hHsRVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bjNqxyHZ; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-7191901abd6so124454b3a.3
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:16:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006578; x=1726611378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rtg/fsM266byh2SMTyHSqLuDJEbiLWNPpLD5jMD37ko=;
        b=bjNqxyHZuV/IGPj+1i8nkiKzPNtqTymZq0DTqj9w0Ev4qFlGKtdY0IJraiGNO69OJV
         GwtPYATRuMFMJ1DSWWaCn+mQZIQRbMnY+fnOrZMODeBKMBJjnSWu9/jtZIljL2E6ZpY9
         nCukBDFdf4WzbHTV0yogLNMZ5eDELogdlbHfg7EpueriDYf5HxoqM0qPKfS9Ra83E88h
         f2ctl4Jjd168wQKufB5f2Jpm0b/QBAB4Nc+EQliBAc0pUQuwnD/dYdTysdLV5597cljh
         Zi3HOs2osIJ1yzgQlgK94kLLswPIpzYlDmV/+qofYntUVGuMEjsW1X1Z/B0dQd1VLY+q
         BHXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006578; x=1726611378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rtg/fsM266byh2SMTyHSqLuDJEbiLWNPpLD5jMD37ko=;
        b=aEEPXwx0gLqkno5XossOKc294AuNnXIGSzpkAWoVzxvEg5nKHZg+vOIAyIhmoFAuCQ
         6x+f5hEowQx1AKO3wn8aZYs4R88vZVbCTd32mBkK3Dpe+JQ6p/D76AIz4HNKRhl/Wx02
         UDKCY2IMnht36bfM7wQL4o7tqisRJmEQdHhC0O/EQBLEtp/x/4EUqBt8IOfU+oTHoSl+
         V6MECOT/HfB2geFAG0r60phGa+LIZvwZURQRHLZLeWNv/MHYQW6z0obywKtAaQLrUxfx
         AOwJwCY8DPlKOuDMxyez5OHiXwrWXW6n1QeyqA8WSCorjjhFW0JPIRjTGqSHPYIHt2JL
         AFKg==
X-Forwarded-Encrypted: i=1; AJvYcCVuSXAGRcclLllzH8FSaOnKG27rsw0VCwhazbJBRAjzgvJbjUO3ZmfcHYEfIP0PDlPhlSs=@vger.kernel.org
X-Gm-Message-State: AOJu0YyzDmQ8u9zx+e2gspsr6IxlkHWlxhYX3DvjdCDn/g9H8bBouV5V
	E8cJCcNcbMxK10SAp63rgjnuhsW5Z0DbfRIpNlIQA3qDA404GW1Zv5k99rdJHjM=
X-Google-Smtp-Source: AGHT+IHWOSynm87dcJ/e3spTuAWJklvasOkQ7Uz80yLy824x7t0cXJiqR3CMOljYmSMNtVZtD8XWTA==
X-Received: by 2002:a05:6a21:b8b:b0:1cf:51a1:8e89 with SMTP id adf61e73a8af0-1cf5e1c5ef2mr2725772637.47.1726006578083;
        Tue, 10 Sep 2024 15:16:18 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:16:17 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>,
	qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 03/39] hw/arm: replace assert(0) with g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:30 -0700
Message-Id: <20240910221606.1817478-4-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/arm/highbank.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/arm/highbank.c b/hw/arm/highbank.c
index c71b1a8db32..72c4cbff39d 100644
--- a/hw/arm/highbank.c
+++ b/hw/arm/highbank.c
@@ -199,7 +199,7 @@ static void calxeda_init(MachineState *machine, enum cxmachines machine_id)
         machine->cpu_type = ARM_CPU_TYPE_NAME("cortex-a15");
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
     }
 
     for (n = 0; n < smp_cpus; n++) {
-- 
2.39.2


