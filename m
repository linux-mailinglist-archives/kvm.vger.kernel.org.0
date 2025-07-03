Return-Path: <kvm+bounces-51425-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04B77AF7128
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 12:58:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F45E4E4E1F
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 10:57:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B3762E3390;
	Thu,  3 Jul 2025 10:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Iz526hT3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F042DE70E
	for <kvm@vger.kernel.org>; Thu,  3 Jul 2025 10:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751540262; cv=none; b=tOs8k/q+A0co1gff+9WBVxbsyr4oEcGzCmL+NZzSeqSxoNd54fNY4RYsA5TWcLlzOEFhGif0xhPyC9rP5iGeg0o3qwvBbCQLV+6DF8hamasxjaYojJ/y3kylI5GzMCp8pTktqg9SkYld95iRctn5xX2QxJvLdV/ZsqAsSsXZbXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751540262; c=relaxed/simple;
	bh=I4QXeNVuRdcQk2ow2muThLgGbqxbXW+LCiZfFBkqugc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RexNveujMDerd0vs10QzlHBdiNRab0UMv7aODdiGXAcPUDejo5MEjOaLnrkQXqZGknNQf79knOUB1tNNvGk8GI6W4UsmE/rE9sAgAsqRyYMtlzJtnYqRzKPVhiJzGdI4RUVjCD7i8KiN5njtGKo/7Y5PSBbxq4xTERu9p2UuD7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Iz526hT3; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-451dbe494d6so58577565e9.1
        for <kvm@vger.kernel.org>; Thu, 03 Jul 2025 03:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751540259; x=1752145059; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gyDIfVgkjNXaUsE4JArqlEQoqhWF6dxOZmRK2K42QUQ=;
        b=Iz526hT3kx4PLX5zUr5dG09+xHJbyCdmDmSoj3EthvAb8ww7DoVVJoIKjgQdbHnqRq
         DqCY0IWuDwWQPZ4pAsJpCstV4AhEPkmHZY5VAkvixcl6fyXkFnIny0YpQnd3yMajkTh5
         uGnd6f+/Z5CnfQjYBzt1u8rtW3QdCa5O+MSw+WHub6lo2PJgQxqE/kMApuF3ez1DaOlx
         bFFfCg4iHh8NFpqADxuMaX2B0K/egUjFCRRQB2UMLockgTMjE6y5OEYGreM3ubJirBUM
         TVtLqEoPVQ5H5dyi4c8/0lHvzKGC8/5RsDj2sc1Oq2BIQr3b02+00T52oX0Peo22Nq2Z
         hLKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751540259; x=1752145059;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gyDIfVgkjNXaUsE4JArqlEQoqhWF6dxOZmRK2K42QUQ=;
        b=OI1GgfLIkQVJM8hyWX/pkY1vW1P08TnK0WHnzj8sROCrHlolEirbUpc5BL7JvIXvQI
         dlpG2DezDmM0BbdzLlJ84ElzJKsUWyGoUKi73Z3nqvZtp7MMYeaLRroFCG7nGL+rYrD9
         Np/CHgibNSvRu3BTV/oeCvUK7bicdh3SbobrfxmnzyWMyPwl+BkDcweFSLxschXGaJez
         Mj4NfFpbIhVRGqhDvvAX/pQR9majA/H5Sv32mIWjD2a1gs5eX24qG004My/oD/ykVQqs
         q3lCcXVkP+Awfn4Q3C0R+pHI4IHSGzpPpxON/F7AEXDoikGxvR7z2zMjZBQ4X2SkN+CJ
         pLpA==
X-Forwarded-Encrypted: i=1; AJvYcCVbJ26DTVKIUCwuRI1cG9g25ozudqzPHqlaG72FX6+G9iYWXhH/P3lNlkoq3G+3gCJOU6k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4W9EpyDP4qoUVUhPQD8S4r06CvTKA6vk5qI9xgWz1or7zM2AD
	H9eCIPCSLYGFSHLOlq2TK1ig4d+VjniamQ3TS2UO7It38Y3uefAQbqtTDROFpGcAPGU=
X-Gm-Gg: ASbGncujl/CpmWbeszpYNXP/yR5HgC5RwvovA+p9Q6EOVem2eP/xEQsegiGcpvih6YC
	xHCJ37hWXJ86kvMp/S9YscqzzQ8Aqfl8rM7LoAeF7npL830T8xuXrQfF3ZOEWYjf4eBNuKS81sO
	ih42KN29pp8qI3xV6mUT5ICIxhFvllFRsdX1XesqobgRmSPyFsfy1JNabDrwsIJ85KGF5hdRKTx
	lrRcg31qNXQ5bu5epju47rn88zq75IHRH+sDsibu97x3HxsKuJdSlCOqsOvxeMF9A3aIxej6X2f
	obKSsHrywRFkkCK99P60cDezTYUL6auDYrsnVRsiGrWqMgfbUEhouiLpNQ6Spy84SoyfN4IW3fa
	jYK0qQYfOwbM=
X-Google-Smtp-Source: AGHT+IFnMUp9ULAlreAnLA58eLaPSmiRt8sgmToqT8PTkCSUBzjcdHDj/cVj5qFUEozQJ4tUqy3gXA==
X-Received: by 2002:a05:600c:3f0c:b0:441:b076:fce8 with SMTP id 5b1f17b1804b1-454a36e91eamr71382595e9.14.1751540259254;
        Thu, 03 Jul 2025 03:57:39 -0700 (PDT)
Received: from localhost.localdomain ([83.247.137.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-454a999d399sm23784825e9.25.2025.07.03.03.57.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 03 Jul 2025 03:57:38 -0700 (PDT)
From: =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To: qemu-devel@nongnu.org
Cc: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	kvm@vger.kernel.org,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Zhao Liu <zhao1.liu@intel.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>
Subject: [PATCH v5 22/69] hw/core/machine: Display CPU model name in 'info cpus' command
Date: Thu,  3 Jul 2025 12:54:48 +0200
Message-ID: <20250703105540.67664-23-philmd@linaro.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250703105540.67664-1-philmd@linaro.org>
References: <20250703105540.67664-1-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Display the CPU model in 'info cpus'. Example before:

 $ qemu-system-aarch64 -M xlnx-versal-virt -S -monitor stdio
 QEMU 10.0.0 monitor - type 'help' for more information
 (qemu) info cpus
 * CPU #0: thread_id=42924
   CPU #1: thread_id=42924
   CPU #2: thread_id=42924
   CPU #3: thread_id=42924
 (qemu) q

and after:

 $ qemu-system-aarch64 -M xlnx-versal-virt -S -monitor stdio
 QEMU 10.0.50 monitor - type 'help' for more information
 (qemu) info cpus
 * CPU #0: thread_id=42916 (cortex-a72)
   CPU #1: thread_id=42916 (cortex-a72)
   CPU #2: thread_id=42916 (cortex-r5f)
   CPU #3: thread_id=42916 (cortex-r5f)
 (qemu)

Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Zhao Liu <zhao1.liu@intel.com>
Tested-by: Zhao Liu <zhao1.liu@intel.com>
---
 qapi/machine.json          | 3 +++
 hw/core/machine-hmp-cmds.c | 3 ++-
 hw/core/machine-qmp-cmds.c | 1 +
 3 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/qapi/machine.json b/qapi/machine.json
index 0650b8de71a..d5bbb5e367e 100644
--- a/qapi/machine.json
+++ b/qapi/machine.json
@@ -80,6 +80,8 @@
 #
 # @thread-id: ID of the underlying host thread
 #
+# @model: CPU model name (since 10.1)
+#
 # @props: properties associated with a virtual CPU, e.g. the socket id
 #
 # @target: the QEMU system emulation target, which determines which
@@ -91,6 +93,7 @@
   'base'          : { 'cpu-index'    : 'int',
                       'qom-path'     : 'str',
                       'thread-id'    : 'int',
+                      'model'        : 'str',
                       '*props'       : 'CpuInstanceProperties',
                       'target'       : 'SysEmuTarget' },
   'discriminator' : 'target',
diff --git a/hw/core/machine-hmp-cmds.c b/hw/core/machine-hmp-cmds.c
index c6325cdcaaa..65eeb5e9cc2 100644
--- a/hw/core/machine-hmp-cmds.c
+++ b/hw/core/machine-hmp-cmds.c
@@ -40,7 +40,8 @@ void hmp_info_cpus(Monitor *mon, const QDict *qdict)
 
         monitor_printf(mon, "%c CPU #%" PRId64 ":", active,
                        cpu->value->cpu_index);
-        monitor_printf(mon, " thread_id=%" PRId64 "\n", cpu->value->thread_id);
+        monitor_printf(mon, " thread_id=%" PRId64 " (%s)\n",
+                       cpu->value->thread_id, cpu->value->model);
     }
 
     qapi_free_CpuInfoFastList(cpu_list);
diff --git a/hw/core/machine-qmp-cmds.c b/hw/core/machine-qmp-cmds.c
index d82043e1c68..ab4fd1ec08a 100644
--- a/hw/core/machine-qmp-cmds.c
+++ b/hw/core/machine-qmp-cmds.c
@@ -47,6 +47,7 @@ CpuInfoFastList *qmp_query_cpus_fast(Error **errp)
         value->cpu_index = cpu->cpu_index;
         value->qom_path = object_get_canonical_path(OBJECT(cpu));
         value->thread_id = cpu->thread_id;
+        value->model = cpu_model_from_type(object_get_typename(OBJECT(cpu)));
 
         if (mc->cpu_index_to_instance_props) {
             CpuInstanceProperties *props;
-- 
2.49.0


