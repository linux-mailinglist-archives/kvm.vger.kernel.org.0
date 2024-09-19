Return-Path: <kvm+bounces-27131-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B4F8C97C377
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3986D1F23287
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:48:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4385C1CD0C;
	Thu, 19 Sep 2024 04:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mRiMs6MP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37EA25779
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721228; cv=none; b=jrn6Em3vWgPG0QFJJfrMsH7uDFU9QNK4dFb4BqfskI8WDbWHMPNMmOfB4Ro1QA3RHHUuPZxLjcNr8LyoBvKu3/B7U+4JKvMzEzYzOTqIqTVQx0tIc/Y6hSO1taLbTKHGSoS0RGePgmoEcGygBz+K/g1VVhTNKjn5tFj4HNP9zKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721228; c=relaxed/simple;
	bh=RNTk/qmECFkTEx44xc+gELcnq0ftFvyRfHIqoob3R6c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M+sVued0TkZgSrgrNccuOuAc25y/COeUD9ckKKmUBZFXxNQ9APT1EoGtEMOR77WW0eOD59fITHF1uraKS9W0dAdGIA0LbbIuFbmn6oXk7V2QVg/O4D6xWmNCRkMWZ7vjHbBFaFsSa1V1Sz1/BcT912Ud122FBIF5PgHp7pP1NPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mRiMs6MP; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7198de684a7so265083b3a.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721226; x=1727326026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J91xisxxghHlg97TfgBUUF7cBAztIX0LnTXW2HtCgj8=;
        b=mRiMs6MPAejFODSnFf12DHDUfIccdOn8ZTs3QcDwet5bTQVCEe4nDvyLfAOKXHYAt4
         YmXeQY/pzuhhdJEmyUTuDFUvzibiK/vklAF4dUF6m4uAbO+hIQSECqEAjDFP69FFGh3R
         Gpj02WtuoHf6se1E2fzR/itzJURFLiILBFCrf4mVWg65ta54ZHhiP1hp3y7V8ELMd3gm
         v2r7/cIcSto/URxFLvWLlNxVDyhC/pszSOvGVDexlTlzmerBOfX84dyIBYlFF12r6C7k
         LWTJbdD8vwvUzedB/YhIE4hCmRnio1OiAVaBT9USIVaaPL+YHlDRs7+diyrqRVqQ54Wp
         QW0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721226; x=1727326026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J91xisxxghHlg97TfgBUUF7cBAztIX0LnTXW2HtCgj8=;
        b=S2RXPCM4dkL0wUrtM+jE5SYzthMm9V1iazCMRywvuizACIoPVRViAZFOYhkyCxOGO+
         WbOBT4vmIrw1fivK0FEBKQFTfTgrUFVrddz1McJFr95bJJOHIKNWwqDy2OL/ig1W2bSu
         +ot9i+KeeCnigvvKSNG2rcrNX1DA2RtCBxWEuo3UmonJMC047aKC56eXA6UWPryAqWSw
         TM+EZBJCf5oNW0gkkAKS8F1RIjGlSioQAkdJ/DX/QqKGiBCl+LDwGIsMZfMLLoHr4mv3
         nmxWKIOwK5iG3cOHjlwDjg/Qffkt1IcucPpO8zH1oGtsaLSFiWfUKX0YzSgVlYW/KrSP
         40hg==
X-Forwarded-Encrypted: i=1; AJvYcCVTQGIeKrUOittwtghWt+HuEY+gSkmQExnXGzlojKMOA1LNkOJ57rDy0RFz3DrPkZtUljA=@vger.kernel.org
X-Gm-Message-State: AOJu0YydHAqKmwPD8/2P4vWHNJLNikBlaqxtjVKPoJmO0+fHSSR0mJYH
	4wfSqUhKXv6nnkc60DWWuISw3NYZjyVxzZaPAIwmh9HVOqTtLqSFhVfX3raOKuA=
X-Google-Smtp-Source: AGHT+IGCW5jSj35sH5O5IBgPKf4Npc1WOdLbOOxXHUFlvIY40aSfwB5Uf2VB8797RC2mgCqAOWZcNQ==
X-Received: by 2002:a05:6a21:3947:b0:1cf:27bf:8e03 with SMTP id adf61e73a8af0-1cf75efd46amr36339625637.26.1726721226274;
        Wed, 18 Sep 2024 21:47:06 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:05 -0700 (PDT)
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
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Klaus Jensen <k.jensen@samsung.com>
Subject: [PATCH v3 10/34] hw/nvme: replace assert(false) with g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:17 -0700
Message-Id: <20240919044641.386068-11-pierrick.bouvier@linaro.org>
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

Reviewed-by: Klaus Jensen <k.jensen@samsung.com>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/nvme/ctrl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/hw/nvme/ctrl.c b/hw/nvme/ctrl.c
index 9e94a240540..2589e1968ea 100644
--- a/hw/nvme/ctrl.c
+++ b/hw/nvme/ctrl.c
@@ -1816,7 +1816,7 @@ static uint16_t nvme_check_zone_state_for_write(NvmeZone *zone)
         trace_pci_nvme_err_zone_is_read_only(zslba);
         return NVME_ZONE_READ_ONLY;
     default:
-        assert(false);
+        g_assert_not_reached();
     }
 
     return NVME_INTERNAL_DEV_ERROR;
@@ -1870,7 +1870,7 @@ static uint16_t nvme_check_zone_state_for_read(NvmeZone *zone)
         trace_pci_nvme_err_zone_is_offline(zone->d.zslba);
         return NVME_ZONE_OFFLINE;
     default:
-        assert(false);
+        g_assert_not_reached();
     }
 
     return NVME_INTERNAL_DEV_ERROR;
@@ -4654,7 +4654,7 @@ static uint16_t nvme_io_cmd(NvmeCtrl *n, NvmeRequest *req)
     case NVME_CMD_IO_MGMT_SEND:
         return nvme_io_mgmt_send(n, req);
     default:
-        assert(false);
+        g_assert_not_reached();
     }
 
     return NVME_INVALID_OPCODE | NVME_DNR;
@@ -7205,7 +7205,7 @@ static uint16_t nvme_admin_cmd(NvmeCtrl *n, NvmeRequest *req)
     case NVME_ADM_CMD_DIRECTIVE_RECV:
         return nvme_directive_receive(n, req);
     default:
-        assert(false);
+        g_assert_not_reached();
     }
 
     return NVME_INVALID_OPCODE | NVME_DNR;
-- 
2.39.5


