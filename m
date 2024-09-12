Return-Path: <kvm+bounces-26622-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 543EB9762E7
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:40:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 78F801C20C1B
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:40:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A011917F1;
	Thu, 12 Sep 2024 07:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rN8I4EP7"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D427D191494
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126784; cv=none; b=uxqzz2mZWn1nMWI++w8W4OZgmqMcMZZP05LaYJbWF2nCLNtsVb4OzBphSHmoUaaZ/9lx/QImo79lUX07tn0qmQ0TqSDGSe8cWXHuTDyzZs59BOv7WvBWGx+5Z2w+b7cDPSAzT1x0bAzJpQmlKqVftXsV2BuKbHVqnQN/OLrI0iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126784; c=relaxed/simple;
	bh=qec+CJuKMDjkR31fKiK89xRG0JoS+ilGKT7Dl+R8qpw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nGpvyZGnk1yLY8EIepfEIUPZKiWO3rD1xt5+Y1dBKChGccKO5+lLm+tj99D5/FB0Y58EmuSe3mevU6pbpi8SueJUCNtAfxxgr0nHvUp+7KQenBkgmutaiYPbcCewIcWNiOer70setNtipgRvJ32D74agsoSje/97mCdOaHrZiUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rN8I4EP7; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7db238d07b3so384493a12.2
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126782; x=1726731582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L7GDoQxngJ1TTnmtNF1SclRiQsQ/Y8kkCXT3xVb7e1A=;
        b=rN8I4EP70UxcNVSOLMkDKY+UKKnGIBuZbBKEzS4zaeUCUHqJ8VEU5t8GbdAtHb+iun
         pX/LkQeXWxYTgqyDIXB0y04dip1dbJTOfOHD5lniBOLI3o1lNhRJtd+5SgyVwTpCg4Rm
         yhavv4vCiecUtTocB2esOkxuPlFXTm42o9YRyrL5D2x/0P/DNHVfa2iCUVO/kY6ph4yK
         rhpa5PmqHCjffJMpmfJHvZboPilocqUrEcuxiK1IDLbDK0EKM9EzPRmT1MJ0mhj71ZiQ
         lACuYsMgs7FHlC5H6MTyzWRcPIchzSakBjuTAa5a8cYhkpBQDlcV0KL5x0UcYDERbKVG
         oHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126782; x=1726731582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L7GDoQxngJ1TTnmtNF1SclRiQsQ/Y8kkCXT3xVb7e1A=;
        b=eUZ3yn0QuXTt9MVSQtsR2vPKiaErGeQ/v0kcxRUe2nVUVQ+1fuUKQj/FeLVJrzReSu
         eujTRdtDs/RVumgDdMmHMaqcTb6r3G1TNfivDngroUGYXPML0oDRZOA5cqI4gSrpWjJT
         XtSLsYUsfFzcIy7hB32VQ/sYNIeqQuu4iAM9PxIc64oqY/ZGp25RkyDMSLq3N1Q/+0OD
         8INpEh1c/nsYak40JSBHTIvFgAaarAloUPa5TLyPbFdRTh8yctP92tRs/tDGCVKNYKTe
         CUuZN5++PKtiFH4f+Ki9gOuQUc6/AWUOvaoQ/DwlY9NNB1DeuMrrhmRZd13QL8nQ4vRw
         U3Pg==
X-Forwarded-Encrypted: i=1; AJvYcCXj+mcJCq/TTLktnCGm+Tr1r2s0fnNblpFB4ghFN5FSaQb/8rVTKbmE/Z+swb56g3MgaBs=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf/wgprrbo0bQi+Hy186Jhhnyg4/MdNOESv5fmHMgLTmYQNIJY
	bvJS96kWrvRjcKtVqSlaiyehhOKBwX4CDyPfEgaF+K+ZQOmOgl5ryEQBQyOgZWk=
X-Google-Smtp-Source: AGHT+IH3UrYHsROVRFhqbmUT73S4ww9ZnrBNKPSzdT/xlKGzi9rQl1GCamlShW6aVRW6SwwZUuf8fw==
X-Received: by 2002:a05:6a20:7b07:b0:1cf:d746:22d0 with SMTP id adf61e73a8af0-1cfd7463553mr949162637.1.1726126782141;
        Thu, 12 Sep 2024 00:39:42 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:41 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	WANG Xuerui <git@xen0n.name>,
	Halil Pasic <pasic@linux.ibm.com>,
	Rob Herring <robh@kernel.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Corey Minyard <minyard@acm.org>,
	Keith Busch <kbusch@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jesper Devantier <foss@defmacro.it>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	Laurent Vivier <laurent@vivier.eu>,
	qemu-riscv@nongnu.org,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Peter Xu <peterx@redhat.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Eric Farman <farman@linux.ibm.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-block@nongnu.org,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Eduardo Habkost <eduardo@habkost.net>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fam Zheng <fam@euphon.net>,
	Weiwei Li <liwei1518@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 06/48] hw/net: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:39 -0700
Message-Id: <20240912073921.453203-7-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
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
 hw/net/i82596.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/net/i82596.c b/hw/net/i82596.c
index 6cc8292a65a..cd416a00ffa 100644
--- a/hw/net/i82596.c
+++ b/hw/net/i82596.c
@@ -282,7 +282,7 @@ static void command_loop(I82596State *s)
         case CmdDump:
         case CmdDiagnose:
             printf("FIXME Command %d !!\n", cmd & 7);
-            assert(0);
+            g_assert_not_reached();
         }
 
         /* update status */
-- 
2.39.2


