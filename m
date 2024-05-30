Return-Path: <kvm+bounces-18433-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 16AB78D5276
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 21:43:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 637E0286A8B
	for <lists+kvm@lfdr.de>; Thu, 30 May 2024 19:43:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39EA0158A17;
	Thu, 30 May 2024 19:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yl+hN+o3"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC56915886D
	for <kvm@vger.kernel.org>; Thu, 30 May 2024 19:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717098175; cv=none; b=fGJbiw1Yrfos4JkHBnQ2jYsc73A5tE83nFnifD493vKkF+Zfrqa8nadF/HbqQ6xNdmHJsoKLVOOH9Sr8FD5Mg5JVoccc5LMTFt+2y+NiGB0ANwQ3Xwf8MXDBrSl6CNGpzFj4pWoTU70e6ho+2Ki376U6SpetyDODHWE3VkYCcb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717098175; c=relaxed/simple;
	bh=VkISwJLqth9HLrk9NR2gJcdXr2r2sl4bt0R/UyCnlZk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jwl1IdqF6tinJZrUWsgPoimF905TSh9aL9fpl6bXG3IBJZAwvw+xgzFXnukrjibq8F0zDhc4oqRXDF68tRrtJuXNurE7idZ+7wgiLNxUVr2LgJHWzzMHAfx1wFRnBViAlEnKXe2LURXPG6UwDaKx9uU73NjKAOdwgEEqYroRW7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yl+hN+o3; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a635a74e031so157621366b.0
        for <kvm@vger.kernel.org>; Thu, 30 May 2024 12:42:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717098172; x=1717702972; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=32yQbNKYA/0QpYwGyLEbfW3tqRcvc30vIF3lo+QmN14=;
        b=yl+hN+o3DVE5VXjkkD7gCbWHOmunz+nWVAw6neVBOwj8Je7V0MvqYoYmYP6Adf+HyD
         woQuDSy9ZerFkR4BrH9YSQMYsfQn8JZdN2OsJWpygavcmX4WL38ZaOyXNtGC+nGNkSN7
         pp5YyBQeXQ/z4eGT7TV7durV6bQ0y7ZmX9mhYqMBrS6j30KD+91pwNx8Kab/59qffLJf
         uktnecI9x39n7RG+TXPg29wMRtFDxUHcNdLT134d0PI8lqITrDpG+O97mprt8/yAMsBm
         e0+L1pfpAulFp00AjWlBt4gmoMnO++ffUUTL16oLbVdJSFLSHhLdD62YsPeUYrPBWydM
         5joA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717098172; x=1717702972;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32yQbNKYA/0QpYwGyLEbfW3tqRcvc30vIF3lo+QmN14=;
        b=exuKyHrjHI/phx0ImA/geRcfF0bIC7DWqK4ISwZFapYr6myuta0vEjMqkmcgno3JqG
         MhhT/ZRrJuDZxCYIqvPK2rgHctg7YsNZ0FNODmBZ3b6oxHmgSiEJmB99Fj+1KUBd/fO9
         y52IRJWH/5ij5yzqzBFXi1Er2pDo4HComLvJJu7luQSJfOkmzCw0tsZnkp7Q6A6R/DH7
         FK9kjLCzJdUlU30Hh7rd3zsl25s7vrHPUy6ZMubyf4yr0R3TDhr/tjyamVxQDrlj320p
         9I38aAaDWLJIzUaU7q76nmBu6wko2R0TnxUh8mncDxT3xCv0Z+ziCvw1aRnZxzAhprmg
         kfVA==
X-Forwarded-Encrypted: i=1; AJvYcCW8/f+WVpKNpBqNGWq6YhbfaPQ7OA+vxwytARx4rTcsd8SJbjxHPYfuizFxEHgNryuTE7EyX6EX4Y57G6xvLmlojfaR
X-Gm-Message-State: AOJu0YxpJ+OKJ7OvPr1EWK9nOqm+v8QjGp/3ozSJLbAI/y0K0TcpAfhu
	y4aHn4SM1I/q+HfaYczEc+Vrcc57q8xpCd5ahxnIhiHbq04ItRFVUVOCHBIZvjE=
X-Google-Smtp-Source: AGHT+IFTafnXNuDoHGvLjw9aFZh+7U9j0vtTJAyWKnYBLNX81Afkye3DJvtDOKRgz1AGcECBR87nFQ==
X-Received: by 2002:a17:906:f2d9:b0:a61:42ce:bbe4 with SMTP id a640c23a62f3a-a65e8e507f0mr301550166b.27.1717098171970;
        Thu, 30 May 2024 12:42:51 -0700 (PDT)
Received: from draig.lan ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a67eb34204dsm7560266b.191.2024.05.30.12.42.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 12:42:51 -0700 (PDT)
Received: from draig.lan (localhost [IPv6:::1])
	by draig.lan (Postfix) with ESMTP id DA9075F8E5;
	Thu, 30 May 2024 20:42:50 +0100 (BST)
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: qemu-devel@nongnu.org
Cc: Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Cameron Esfahani <dirty@apple.com>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Yanan Wang <wangyanan55@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Sunil Muthuswamy <sunilmut@microsoft.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Reinoud Zandijk <reinoud@netbsd.org>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	kvm@vger.kernel.org,
	Roman Bolshakov <rbolshakov@ddn.com>
Subject: [PATCH 3/5] cpu-target: don't set cpu->thread_id to bogus value
Date: Thu, 30 May 2024 20:42:48 +0100
Message-Id: <20240530194250.1801701-4-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240530194250.1801701-1-alex.bennee@linaro.org>
References: <20240530194250.1801701-1-alex.bennee@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The thread_id isn't valid until the threads are created. There is no
point setting it here. The only thing that cares about the thread_id
is qmp_query_cpus_fast.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
---
 cpu-target.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/cpu-target.c b/cpu-target.c
index 5af120e8aa..499facf774 100644
--- a/cpu-target.c
+++ b/cpu-target.c
@@ -241,7 +241,6 @@ void cpu_exec_initfn(CPUState *cpu)
     cpu->num_ases = 0;
 
 #ifndef CONFIG_USER_ONLY
-    cpu->thread_id = qemu_get_thread_id();
     cpu->memory = get_system_memory();
     object_ref(OBJECT(cpu->memory));
 #endif
-- 
2.39.2


