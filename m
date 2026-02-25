Return-Path: <kvm+bounces-71780-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uINEG9yFnmnRVwQAu9opvQ
	(envelope-from <kvm+bounces-71780-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:17:16 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7A9191E7A
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 06:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5D4C8307AA36
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 05:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AB442D5C83;
	Wed, 25 Feb 2026 05:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GMDwqbqS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7888026A1B9
	for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 05:13:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771996403; cv=none; b=NEzdhjzrMttCHGcIJJkSih6xYev7sWOBXltsa6SpVtf5nd7qXbsbC17AF8GTyWnOKTo0BqVeuZnmto8RDGwGQO/SPS34sYsSY6qHcRnlqz3AnnfmnVmaHYe9MQAtXAHytIdcyr7BizKj6CauXgkUsr5aV5XY7fjHHQvsqNSyayM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771996403; c=relaxed/simple;
	bh=eXhIQsoj7SIcqxPigVqDJewkuRx1mz7CVDmzfhzHT8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JXmAuHkDUGro1frJTkEucvhHC/v1HpGnseqWjqKEBgLcqGhyLL7cYEpPCE3IQY2fUtmJQTxdfDjWHVKh10C2SeYJ4lVeYMP9hW7WX2FkCK04LUsJ1ddGOSz/HULcmncM5p9UdFxIrqYx0PE4l0vLtKYO6RlA6ffSKV1hpjIhvsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GMDwqbqS; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-4376acce52eso3981699f8f.1
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 21:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1771996401; x=1772601201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMzYp4SdJTMxtv4pWgjfW8jgSoBedAjoxT34KYE2b/k=;
        b=GMDwqbqSUYwWvJgoFNCRpffM4gCg5SEYuE4Yy/IxJgK6CQB7/OMvwn4Jn4ufyVrdPE
         /j5FbL6Mwivk+yVOy2AYw/OtBxxA661pCbCZUeoB2XL2e4zfv0t2jyts9hbleqne3r8s
         5dpuK9Ppwkg1UC/Mfs+RjkEwP3JZtiylEfK/C3SUuqRDifDWeoB2m8zfQ3AIbvQ+nZ+v
         lkrcw0MyNuTbqkbfQTt6gX0hbzuXRctjMyYtK5VxTqNwYPH2WIexku+zkqeqSaDdEAg7
         Vk5MwWxt/UvdqaoIrahsmNq+ZNhZzIO9J4/v+H32Dm3VGI9kb4R/Yn1zk0+XnIbL52Ev
         /Duw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771996401; x=1772601201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jMzYp4SdJTMxtv4pWgjfW8jgSoBedAjoxT34KYE2b/k=;
        b=wclOpydoHxwdyQD+D5tk7BMzlfnRgjZk8KKKOk3Z8iW7YT583w3g5mqVzEpRrWISD4
         6w7cYpU9YJfz5eRFena+e8c3j+5aGENSDSsFqbgAiwypAve1UerQeKoDBKQkvDAJViGy
         EJ8hoZ1gdBirmqbIji2c/9i1Snbg491QJoZ3U6m4+gndnsLS38FKkNT3L7j1nGr+BzfT
         9RDFsN3K1izXb5nvp60hfw7LOSgy78i8Fl/6A0DTO64lrvSxxLIpGLOCJ6h8bSz9qbRw
         vr57gZ+QQq+nvlSw9hN3brq1NqydvUjC8mefo+MqSW9pw2QUhyWYdgiHaLB0NRKnbSVi
         +71w==
X-Gm-Message-State: AOJu0Yy45pXclS3yxgZjshCKmpmQMf2369emfwv6sLFw7geiwSvTvmml
	VwVd9L4KswgJndnHbONfaCXGOoQG2ZWfvVNVOCStaIUbRsbLW2vecvEMUJJCw5m5TmxDqU0bjqa
	pA3fFmc0=
X-Gm-Gg: ATEYQzxRqccHl/HSZ71Cowlu1hdwf+VCPDQqi2l7SkhgIShLlEWFSnmwJI1ne6rK0sO
	f4nDVlKBv43ne2LiCFrS1t2zZZ9MdjbJeY73NSwysVf9JLfIZt2hZ8v29Scf/R66tDNk58DPeav
	jxewH/hr6dlkNYOZXukLlsl+8A50lbAR9LvqVpyqocjkJ2fvM1lxRADOV3x2pPfw5i99zM8ktRO
	LmIVA9ZhCe+wlG6tSoxTUkDRuwf5ijG0vyjLUWcDMX27iW86QPXscpmA77+L62hengp3jG40qVz
	aEgd1ThnxyQwXFZ+wlIAVDD875y55sjNbnwLcbLFdB0dmbOJjF6sQvbjX7gCnrX6fNcLXr/+2EV
	7jVzmhxGbbgY1slT4xm31EoF9KvoMPURfIkZ7Fm9zUrCyQu+Xe/JU2TiOsA1THehFf+y6oCDfPo
	uOYSZaqB5FopHVIq2wsL6LKK02+OFz7N2yBWwOkAPJwYg31mDKtdgNuJN9nGuRYLNSIg8P9xwxx
	/FKe4HWyP4=
X-Received: by 2002:a05:6000:604:b0:435:8ad8:b7a with SMTP id ffacd0b85a97d-4396f181362mr27307810f8f.46.1771996400821;
        Tue, 24 Feb 2026 21:13:20 -0800 (PST)
Received: from localhost.localdomain (88-187-86-199.subs.proxad.net. [88.187.86.199])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4cc81sm30577525f8f.26.2026.02.24.21.13.19
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 24 Feb 2026 21:13:20 -0800 (PST)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	xen-devel@lists.xenproject.org,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Magnus Kulke <magnus.kulke@linux.microsoft.com>,
	Wei Liu <wei.liu@kernel.org>
Subject: [PATCH 2/5] accel/mshv: Forward-declare mshv_root_hvcall structure
Date: Wed, 25 Feb 2026 06:13:00 +0100
Message-ID: <20260225051303.91614-3-philmd@linaro.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260225051303.91614-1-philmd@linaro.org>
References: <20260225051303.91614-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[linaro.org,none];
	R_DKIM_ALLOW(-0.20)[linaro.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[linaro.org:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71780-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[philmd@linaro.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linaro.org:mid,linaro.org:dkim,linaro.org:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DD7A9191E7A
X-Rspamd-Action: no action

Forward-declare the target-specific mshv_root_hvcall structure
in order to keep 'system/mshv_int.h' target-agnostic.

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
---
 include/system/mshv_int.h | 5 ++---
 accel/mshv/mshv-all.c     | 2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/system/mshv_int.h b/include/system/mshv_int.h
index ad4d001c3cd..35386c422fa 100644
--- a/include/system/mshv_int.h
+++ b/include/system/mshv_int.h
@@ -96,9 +96,8 @@ void mshv_arch_amend_proc_features(
     union hv_partition_synthetic_processor_features *features);
 int mshv_arch_post_init_vm(int vm_fd);
 
-#if defined COMPILING_PER_TARGET && defined CONFIG_MSHV_IS_POSSIBLE
-int mshv_hvcall(int fd, const struct mshv_root_hvcall *args);
-#endif
+typedef struct mshv_root_hvcall mshv_root_hvcall;
+int mshv_hvcall(int fd, const mshv_root_hvcall *args);
 
 /* memory */
 typedef struct MshvMemoryRegion {
diff --git a/accel/mshv/mshv-all.c b/accel/mshv/mshv-all.c
index ddc4c18cba4..d4cc7f53715 100644
--- a/accel/mshv/mshv-all.c
+++ b/accel/mshv/mshv-all.c
@@ -381,7 +381,7 @@ static void register_mshv_memory_listener(MshvState *s, MshvMemoryListener *mml,
     }
 }
 
-int mshv_hvcall(int fd, const struct mshv_root_hvcall *args)
+int mshv_hvcall(int fd, const mshv_root_hvcall *args)
 {
     int ret = 0;
 
-- 
2.52.0


