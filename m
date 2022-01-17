Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192174911A7
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 23:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243593AbiAQWMm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 17:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243599AbiAQWMm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 17:12:42 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925C0C061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:41 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id s30so62999926lfo.7
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rV1+59GXD+eg2TMJehZR6fw9R0RV4bHsHcjuzn77Cgw=;
        b=qZmSpCtSfONL6ygr9kUY32xBU5nXrqcsAZr4j1jjHmL2eqNd7wAcSfxxg4Udml+vhf
         WCU9JvgDuB08JEwpsxVv4xRvn1eU7x+sgC1ft7an8iiXzBcaNXRA1zqPa/6qLWxzWStW
         LHlzUzrU9UFc2enJBmtR3Q8+pYAcaV8DORUNDId1uY4Kb0DC2kvl4l2IIQffJSDGaQ2H
         eG6cOdQ4TWlPtKdgHdx4nlOqXeo/a57KasuJvoLarCoPzcTs32A/SH/46kBAQuUfh0r/
         BgbzMVWqCYm3w1PLcCmldoKyjlRah6Lv8d03DSYuWSjmysUpItspPO6bYWoS5t2vJBr6
         iDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rV1+59GXD+eg2TMJehZR6fw9R0RV4bHsHcjuzn77Cgw=;
        b=IhGni/hDQmElNl9LgK80J8GgMcPtvAOWpvYb44kiDxJQ4Tcs0fpM0ElupJJPyT1Uwc
         etFvwjd1gm9hW7Agmk8LEPBaOSow1QLyAjS20bxpV8bd6asNvOv+95YHmEboJQmttzNb
         ek5fepJyUGgXPYfrgiu75c5lmhRTn1szFfYkiBA78/dEEPxSBOcOE+uiVo7aauGTvL1T
         ZYxBqpNMpTm5LFn6IFTvNFQ5C6Qy/s8l+TEuMbFg/eYle1GQYsXXwryQCOwHDDWET1fm
         2MT2qsv+kcstaGdys5P1oo8ud8M9ZQLSb/PSIXKXcLJDAa1/0iKUOLzlH0yVOhDnoDDO
         gBLA==
X-Gm-Message-State: AOAM531kWN5fK1kM0MpY2Q4hZHG8FkldFobDZevwMuYuT5CJAnL3lcGt
        xGSHzlAxxODn1oqE8HZCFNRChJM3xjH3iw==
X-Google-Smtp-Source: ABdhPJwmdBXtFqVmEvuJVlTpOTbs3EukPZ9mV77hzTt3yW4sndtHf/IgYmPv1py7UR7kXkd5p57Tjw==
X-Received: by 2002:a19:f00f:: with SMTP id p15mr16381829lfc.196.1642457559853;
        Mon, 17 Jan 2022 14:12:39 -0800 (PST)
Received: from localhost.localdomain (88-115-234-133.elisa-laajakaista.fi. [88.115.234.133])
        by smtp.gmail.com with ESMTPSA id c32sm1458094ljr.107.2022.01.17.14.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 14:12:39 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 5/5] mmio: Sanitize addr and len
Date:   Tue, 18 Jan 2022 00:12:03 +0200
Message-Id: <429afc3bf48379e3e981c3e63325cb83f8991e20.1642457047.git.martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1642457047.git.martin.b.radev@gmail.com>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch verifies that adding the addr and length arguments
from an MMIO op do not overflow. This is necessary because the
arguments are controlled by the VM. The length may be set to
an arbitrary value by using the rep prefix.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 mmio.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mmio.c b/mmio.c
index a6dd3aa..04d2af6 100644
--- a/mmio.c
+++ b/mmio.c
@@ -32,6 +32,10 @@ static struct mmio_mapping *mmio_search(struct rb_root *root, u64 addr, u64 len)
 {
 	struct rb_int_node *node;
 
+	/* If len is zero or if there's an overflow, the MMIO op is invalid. */
+	if (len + addr <= addr)
+		return NULL;
+
 	node = rb_int_search_range(root, addr, addr + len);
 	if (node == NULL)
 		return NULL;
-- 
2.25.1

