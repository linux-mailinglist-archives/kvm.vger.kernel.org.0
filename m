Return-Path: <kvm+bounces-26618-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 68D789762E2
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:39:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D61B1C22848
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DBE518FDCD;
	Thu, 12 Sep 2024 07:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QIw/G5Yr"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C95A18E349
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126773; cv=none; b=KePd/FZTGxV3O6wydjMUGSJvXAcQA+bKJ3KunwJwofHEpvtdjKzlWaT+G038AaEJQYtkJiUdEaqudIf6SdrKu7NKpFZf+YihqMZt8gSmZmzzrulNYbim/mEIDnXlMMN48hLg9XgUwlEAdLzaaWdygMgompLD0/eHIiUPJi6DG1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126773; c=relaxed/simple;
	bh=rPFF0K4jLKDHQLACOaTVD86anmS8djMvLcG+jAZYsZM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QVWTk7UrS+Bd8vKAapNrcwSmx0VEIVs2rhlP5CoAHIxxDYjOjsNqUai0LfyW7oQeNNF/3irWCgMbWV4QLystwdMouRMISiju7gr/UOnj95v/6iTPq7nBnKjnDZuzfmWRIA7Wn32pAIB1nM6jdDLgmEeJLRpdu4ZJ96rScKwncl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QIw/G5Yr; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-71798661a52so478425b3a.0
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126771; x=1726731571; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WKzkwMvjulowmVZuCJWvk+8fDxucMHovajiMFoHCRQg=;
        b=QIw/G5Yr5+cPJFI8gRqJVZbriBA0pRnl2z7g8zWlqHh0+HZgwOwUuO9NDTpPZqp5kP
         AXe3seDKJZy3dH7x904KySVen73+ZT5gDH05Cv5oyOAJZR45jRN4BT27SEbBkDFaVOtE
         giU0Amy0Bti5YiN7OYCE536igjVWFiTuKutJkEj3FfvGUWTI+3xP+lAjWGLn2ofGojWP
         BnsW0KXNOkmeQncGSOLcRnZ29lyN78MlrJwdC5XjRt28OuTdr6vXyGkv4FevNVDn/F+y
         tCjf21L+y7TrXKxB3U5h0JRXPpDEI6TCQFw0jWhxqwaAQ1CAcZa5Uskjqo3zUciIxYyn
         3u2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126771; x=1726731571;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WKzkwMvjulowmVZuCJWvk+8fDxucMHovajiMFoHCRQg=;
        b=cuUiyAET+shsU3r9l0AyFjSWD22jjKPo8jjM5NySymmtjNkpQlrCKWCHJNlZFCDzvM
         6x24w+fidcojJ+g0aHfnINMJX8RtKNQmmjdV/yWiR66Otc7gGVWJR7b6i6eI8AzPjzEf
         X825wiFzqdvKWGOD18P1ZCGQVHM0c5ely8+mS0iPurzYlGF1URpfTaw/THxkt5ZhAhBn
         SxCpx0nWkwE9z9aMn2NO7ZCGGquO1969stScAFeU1fTOo3TtgFskJkH2wPKCB8w1cSFa
         pqAel3KH44ay4BcoQs7hTHk79ySQH1x7xRGlRHWosbBDoJxMEpDzrMXXN2SpOZI4E6q5
         lsSw==
X-Forwarded-Encrypted: i=1; AJvYcCWwINhidE9d1kU3GhpNdfa4qs+oT0dRuTR5MIBWgBl5KF8QVYR3AfbNTl9xW56v5y1HA3s=@vger.kernel.org
X-Gm-Message-State: AOJu0YzJCG25m43HCHyMsJuthsU76pnHlDdfM2EHlDnIBiONRY/Evikf
	dRCA0xO2W3oeOG9GkFCy/1LaU5vbADhZqQeQLQfrwhv7M4TnYpJyAMXNmOQ8GdQ=
X-Google-Smtp-Source: AGHT+IFV73zYW1Waxu/aZZ0kavyu0j3iUea6gq5xe8cf1PrugnTCL4VeCsbqhbUloiuceag0jwjTVg==
X-Received: by 2002:a05:6a00:1803:b0:717:9743:e4fb with SMTP id d2e1a72fcca58-71926456829mr2983283b3a.14.1726126771431;
        Thu, 12 Sep 2024 00:39:31 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.39.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:39:30 -0700 (PDT)
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
Subject: [PATCH v2 02/48] hw/acpi: replace assert(0) with g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:38:35 -0700
Message-Id: <20240912073921.453203-3-pierrick.bouvier@linaro.org>
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
 hw/acpi/aml-build.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/hw/acpi/aml-build.c b/hw/acpi/aml-build.c
index 6d4517cfbe3..006c506a375 100644
--- a/hw/acpi/aml-build.c
+++ b/hw/acpi/aml-build.c
@@ -534,7 +534,7 @@ void aml_append(Aml *parent_ctx, Aml *child)
     case AML_NO_OPCODE:
         break;
     default:
-        assert(0);
+        g_assert_not_reached();
         break;
     }
     build_append_array(parent_ctx->buf, buf);
-- 
2.39.2


