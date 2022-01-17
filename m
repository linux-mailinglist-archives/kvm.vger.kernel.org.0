Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77D074911A5
	for <lists+kvm@lfdr.de>; Mon, 17 Jan 2022 23:12:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243592AbiAQWMh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Jan 2022 17:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243583AbiAQWMh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Jan 2022 17:12:37 -0500
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B717FC061574
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:36 -0800 (PST)
Received: by mail-lf1-x133.google.com with SMTP id o15so62900924lfo.11
        for <kvm@vger.kernel.org>; Mon, 17 Jan 2022 14:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dSUb8OLD/cfLhUOnic5etXXbi3atuLbrsr3QmYwD0xY=;
        b=gSOSeoOZKgGO+anzyzy0kscVnnH+6QmaaUURBWP+1Kdz2mZHADZ6ITarcVGanjo4Vk
         pnBhrLsTYPbuEsuqF4YkOchbSFhUxb4Mt5RdMD4NpBUG8on4rz8x3gVdHR4vfnpiPAjs
         zKV7LgtOlGigUZRuS5xpr9p1GRTVg7eIX2sAZmm+ANtGzKRBqT7B3REZzhkRf/hT0Jrq
         XaKrOrFgJ7qwW46evxoOTsqs4tAaZdnupwoOok/UBV5sBnuNJowRk+rw+AgSWrl/Wvyg
         fNjPJ3TG4SRURKdK9wK/qYP3CTz3wGBbqcznDmrmpCjL297X/ddpE+Old+R7VTz1bbG5
         zM5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dSUb8OLD/cfLhUOnic5etXXbi3atuLbrsr3QmYwD0xY=;
        b=7DHPbn9MdthT4/g7jXTNrSx75E796QT96kXuh/Rbc/ZJ2rQS+GPyc0fJKC8dFqhcNl
         MlIsD8wuGN+xSs5TFU0XawBCCR70u+qPQc8qW9VIw/e5hpmdd+tQDlZ1C0nYbP6enhrV
         IsXb59domYJ5ICBa/FAcPYWhiQC7CmjhPSl/NRHSnzk7M//dLIGr1OEuqmaHfVNrv5to
         7y4hstXZ4lWjRAfl4cGrmkWJpvWcm5Hzdu6+Uk1BUBEwnsdGTDs26G0VJl4a0YFsXEY/
         77bZy+4BoWHI/xytlV36zBRLZXPYz/5ftkJH6QwP5cVnZ8OyF3AS1f94wBNkC/x9pGdv
         GaPg==
X-Gm-Message-State: AOAM532w9r4PzSYz36x1ViGa+VyRQWVaJtEnvk82zZDR2SB9T7+YJMt3
        qgRiwKpKTQJ3+HKQka/ZjMbWZivFo95UdA==
X-Google-Smtp-Source: ABdhPJyNXB0h6GRDwe760pZeZ78R3p6C7fMQ0D6WScvAtTg+Lcq+XLelLPzKzxGLJptkP3tEyP9rmQ==
X-Received: by 2002:a2e:3c06:: with SMTP id j6mr4851328lja.484.1642457554946;
        Mon, 17 Jan 2022 14:12:34 -0800 (PST)
Received: from localhost.localdomain (88-115-234-133.elisa-laajakaista.fi. [88.115.234.133])
        by smtp.gmail.com with ESMTPSA id c32sm1458094ljr.107.2022.01.17.14.12.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 14:12:34 -0800 (PST)
From:   Martin Radev <martin.b.radev@gmail.com>
To:     kvm@vger.kernel.org
Cc:     will@kernel.org, julien.thierry.kdev@gmail.com,
        Martin Radev <martin.b.radev@gmail.com>
Subject: [PATCH kvmtool 3/5] virtio/net: Warn if virtio_net is implicitly enabled
Date:   Tue, 18 Jan 2022 00:12:01 +0200
Message-Id: <670fbbab84c770292118e9fb00bdfcdf1237678b.1642457047.git.martin.b.radev@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1642457047.git.martin.b.radev@gmail.com>
References: <cover.1642457047.git.martin.b.radev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The virtio_net device is implicitly enabled if user doesn't
explicitly specify that virtio_net is disabled. This is
counter-intuitive to how the rest of the virtio commandline
works.

For backwards-compatibility, the commandline parameters are
not changed. Instead, this patch prints out a warning if
virtio_net is implicitly enabled.

Signed-off-by: Martin Radev <martin.b.radev@gmail.com>
---
 virtio/net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/virtio/net.c b/virtio/net.c
index 9a25bfa..ab75d40 100644
--- a/virtio/net.c
+++ b/virtio/net.c
@@ -1002,6 +1002,9 @@ int virtio_net__init(struct kvm *kvm)
 
 	if (kvm->cfg.num_net_devices == 0 && kvm->cfg.no_net == 0) {
 		static struct virtio_net_params net_params;
+		pr_warning(
+			"No net devices configured, but no_net not specified. "
+			"Enabling virtio_net with default network settings...\n");
 
 		net_params = (struct virtio_net_params) {
 			.guest_ip	= kvm->cfg.guest_ip,
-- 
2.25.1

