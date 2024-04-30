Return-Path: <kvm+bounces-16286-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0632D8B8351
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 01:54:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6F33D1F25AD7
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2024 23:54:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FACB20124B;
	Tue, 30 Apr 2024 23:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iDr9gM+g"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648F51CB33D
	for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 23:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714521106; cv=none; b=rAdS5aY8v04Ia7Ufzx17hri+wjdHRFbYHER8bpdAvDZIuFdXLsDIx5vPmEdMy0g409BUuAQcmIaZ3b7jWmKIj3lCadT8lqrdyTnpSmX3eVIgwZ43KoNhwQ/5d9qLZjR+GngcrtA650DeZfsqUcl5kY1K1rW4+tBjG2WcaXO1baI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714521106; c=relaxed/simple;
	bh=HRxoUPmZK+egBgNy4OhOK7glTZfY/4OX4NkiGTUAjTM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=X83W+yBEx6LUBUqg6IFs6Z9kdRI2qS6tX4fYMZ2y3cSJWjFJZOKGXUTW7xIBWAtDewQht8Hhzu8RbTlq5bTHCtpil+tP/nb1ReDhHK6QXpNP+3pBu452DQyOJZKh6Zdw+WOEbIOJyxKfCuUMBXchYifh7VYC3eRkrBc6BD2qNSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iDr9gM+g; arc=none smtp.client-ip=209.85.128.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--edliaw.bounces.google.com
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-61dfa4090c1so9222517b3.3
        for <kvm@vger.kernel.org>; Tue, 30 Apr 2024 16:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714521104; x=1715125904; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BDKXR6NuC+glA0BXehmJNQF6Ococeyr147OnKEva4Vw=;
        b=iDr9gM+gMIh5XxgAKIGS/ALzuqce0LleghVXkl9W8aFpkkZv/lMsAb2C0qLgtX+/10
         UoGdQ4qrGtO2FnsnuJ75aryEXd19Faoi3lvNUXSg/OPTrfydlwESZt5i/TcpFb9YY+sC
         zznV35AD0y9BXgiieUI++XG5lSRaIeGNL0Nsi4ApEp/spw7EBjH+EK1F2JL395F3mcYR
         RZWp+QJVfQbMUI38//lccIOsDQbAygcsKXjXGYWE3k7efpzbomZuyBByof9maNkedpyJ
         ix/03c0fCfPFpa1jsMcJxG91YPdhu0U9AwuHbwGHwU2njCGdstK9efUxotp6lUFjTnrE
         pfcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714521104; x=1715125904;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDKXR6NuC+glA0BXehmJNQF6Ococeyr147OnKEva4Vw=;
        b=cWsxzw5/SXFnHAyK72/u1fumACbVXLif76JIDzqDgWrZOrODqTSg/a41IK2pQJV8Kb
         txbbfmMYrWU38l2Ei1s5xxtg6U+O1Osu4oTeaLBbRZBBPTQ8KgIymtEKDts1gvc6jF6b
         dLeqHPZXCbJmjnDoTivBpYa6Dw6uiK/0j8c9+TFLTnruxAGEpJJi5h3yxtxu1NYamMDp
         C7tY3aaIfNvNCKHejIzAq9aVjo92ak57b3DJO/TA9eFMNzq9Pgs8NJbDmZpg8VlZNb1n
         8mRKqi0jU+GU8a9AENIpqwFgp4p3NK74nibTE1BT8P8OEobfvNRUr40Gx1oducE8jJfR
         HF7Q==
X-Forwarded-Encrypted: i=1; AJvYcCVq6Vmq6OGfC6MlA4IwnPwR4WJBsHxjaKk85+qwLm1WZvwZMbNacts89zH1rdFytjlpTsmYSK1j7pLZ9uI6QJ7LW3+m
X-Gm-Message-State: AOJu0YzMQHedeJaLcUWscFdOUHlFW0RDhnggnbQQHViFtmYmTTJVCK4d
	KNr/i253L+yf9OuQuuTu4HTJ7F+LA/FQTMKQJQGfhWOpN1N19z9JvwqIq744aDduOy/duY4sX+2
	gNg==
X-Google-Smtp-Source: AGHT+IGfcAKXP1N1dvNy0xrDOZ0qhW7xFF1Rsec+ivNUN7q+falIURigI2OTwiYzGqmueTM565xtpnxyQP8=
X-Received: from edliaw.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:305d])
 (user=edliaw job=sendgmr) by 2002:a05:6902:2b08:b0:de5:2325:72de with SMTP id
 fi8-20020a0569022b0800b00de5232572demr147825ybb.10.1714521104475; Tue, 30 Apr
 2024 16:51:44 -0700 (PDT)
Date: Tue, 30 Apr 2024 23:50:15 +0000
In-Reply-To: <20240430235057.1351993-1-edliaw@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240430235057.1351993-1-edliaw@google.com>
X-Mailer: git-send-email 2.45.0.rc0.197.gbae5840b3b-goog
Message-ID: <20240430235057.1351993-7-edliaw@google.com>
Subject: [PATCH v1 06/10] selftests/net: Define _GNU_SOURCE
From: Edward Liaw <edliaw@google.com>
To: shuah@kernel.org, Mark Brown <broonie@kernel.org>, Jaroslav Kysela <perex@perex.cz>, 
	Takashi Iwai <tiwai@suse.com>, Jiri Kosina <jikos@kernel.org>, 
	Benjamin Tissoires <bentiss@kernel.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Bongsu Jeon <bongsu.jeon@samsung.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Jarkko Sakkinen <jarkko@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Edward Liaw <edliaw@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kernel-team@android.com, linux-sound@vger.kernel.org, 
	linux-input@vger.kernel.org, kvm@vger.kernel.org, netdev@vger.kernel.org, 
	linux-rtc@vger.kernel.org, linux-sgx@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

809216233555 ("selftests/harness: remove use of LINE_MAX") introduced
asprintf into kselftest_harness.h, which is a GNU extension and needs
_GNU_SOURCE to either be defined prior to including headers or with the
-D_GNU_SOURCE flag passed to the compiler.

Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
Signed-off-by: Edward Liaw <edliaw@google.com>
---
 tools/testing/selftests/net/bind_wildcard.c             | 1 +
 tools/testing/selftests/net/ip_local_port_range.c       | 1 +
 tools/testing/selftests/net/reuseaddr_ports_exhausted.c | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/tools/testing/selftests/net/bind_wildcard.c b/tools/testing/selftests/net/bind_wildcard.c
index b7b54d646b93..be0773cbc15b 100644
--- a/tools/testing/selftests/net/bind_wildcard.c
+++ b/tools/testing/selftests/net/bind_wildcard.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright Amazon.com Inc. or its affiliates. */
+#define _GNU_SOURCE

 #include <sys/socket.h>
 #include <netinet/in.h>
diff --git a/tools/testing/selftests/net/ip_local_port_range.c b/tools/testing/selftests/net/ip_local_port_range.c
index 193b82745fd8..08fbd3449ffa 100644
--- a/tools/testing/selftests/net/ip_local_port_range.c
+++ b/tools/testing/selftests/net/ip_local_port_range.c
@@ -6,6 +6,7 @@
  * Tests assume that net.ipv4.ip_local_port_range is [40000, 49999].
  * Don't run these directly but with ip_local_port_range.sh script.
  */
+#define _GNU_SOURCE

 #include <fcntl.h>
 #include <netinet/ip.h>
diff --git a/tools/testing/selftests/net/reuseaddr_ports_exhausted.c b/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
index 066efd30e294..a5c40528837f 100644
--- a/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
+++ b/tools/testing/selftests/net/reuseaddr_ports_exhausted.c
@@ -17,6 +17,8 @@
  *
  * Author: Kuniyuki Iwashima <kuniyu@amazon.co.jp>
  */
+#define _GNU_SOURCE
+
 #include <arpa/inet.h>
 #include <netinet/in.h>
 #include <sys/socket.h>
--
2.45.0.rc0.197.gbae5840b3b-goog


