Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5703754E5
	for <lists+kvm@lfdr.de>; Thu,  6 May 2021 15:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbhEFNj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 May 2021 09:39:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:28872 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234348AbhEFNjZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 6 May 2021 09:39:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620308307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dXiqUMGNseF8aEoCidrrmNydk4TNmOpI8OAZgIN0M9M=;
        b=ZjK+yq2FgDa3M9koIy9tQP+h0mcn3lSxVNWVW+IfS4QcOux4DH/QOhXl/K3TQThln0d1ba
        42snp0tIgz+3w6qgeOnLDFB97e86loPbhY5VOcbpjwDW8FdsUrW/37M5s84aPIZSUpxc0i
        XrJpQsy5un10T9hDoXX38nzhDe+htnI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-4KCL0lJFM6Cwcf2iTjaPpA-1; Thu, 06 May 2021 09:38:21 -0400
X-MC-Unique: 4KCL0lJFM6Cwcf2iTjaPpA-1
Received: by mail-wr1-f69.google.com with SMTP id r12-20020adfc10c0000b029010d83323601so2191695wre.22
        for <kvm@vger.kernel.org>; Thu, 06 May 2021 06:38:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dXiqUMGNseF8aEoCidrrmNydk4TNmOpI8OAZgIN0M9M=;
        b=tfihd//Ze6GVF4RtchgB/C9CDX+25f+hZLb7fhvZ9LAVQg4M5nyDyPYqB2HhKGfhUR
         wSrc0ycYiFApyVYJw4vBFBMA/gj5kTXrUJwNrsBqSo4U2wCgTSRyoYti/jST+xrrQ4QU
         dMdQgb5Js47qYJqHhtanOnSWt1uupPyc8Lr/KuWzRjsBlQhg+LR7bryPnTNnHoXN8RC6
         YEnsdszzyFAJ8bWsp7Z7/LPGyEBeuhPGxMvVSH2Qw03OU8fo/YoITfhRWyc5Yy6NROY1
         OnQ8nNGI6rqK8BM922l2VU140ZXU9qPQdcCReQ38Z2ZL+cmu0MlMZInIQkrwZU09/jWk
         Fn7Q==
X-Gm-Message-State: AOAM532mIt09+Ms/pq1HC34Q9+A+fod2j/rS6f2BuJIsKiAC0h/0Mx1n
        Mp6i9NUBegM6DdVuapaGMdmN6hvW0KQlEI0Y7TV4RDpPNBTOilslEHX5+P0YlsYEZvGyJX+cp2F
        1r+CWInxymkRM
X-Received: by 2002:a5d:51ce:: with SMTP id n14mr5147672wrv.239.1620308299896;
        Thu, 06 May 2021 06:38:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyAZIfvg++T6fTYKrEquhu6tnCC62wCEQ30o8S5aLEgqSCKFWctM9XzEDZQWk7c63Etg+U8g==
X-Received: by 2002:a5d:51ce:: with SMTP id n14mr5147655wrv.239.1620308299780;
        Thu, 06 May 2021 06:38:19 -0700 (PDT)
Received: from localhost.localdomain (astrasbourg-652-1-219-60.w90-40.abo.wanadoo.fr. [90.40.114.60])
        by smtp.gmail.com with ESMTPSA id m13sm4432533wrw.86.2021.05.06.06.38.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:38:19 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     kvm@vger.kernel.org, qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
        Gerd Hoffmann <kraxel@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Warner Losh <imp@bsdimp.com>, Kyle Evans <kevans@freebsd.org>
Subject: [PATCH v2 4/9] bsd-user/syscall: Replace alloca() by g_new()
Date:   Thu,  6 May 2021 15:37:53 +0200
Message-Id: <20210506133758.1749233-5-philmd@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210506133758.1749233-1-philmd@redhat.com>
References: <20210506133758.1749233-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The ALLOCA(3) man-page mentions its "use is discouraged".

Replace it by a g_new() call.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 bsd-user/syscall.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/bsd-user/syscall.c b/bsd-user/syscall.c
index 4abff796c76..dbee0385ceb 100644
--- a/bsd-user/syscall.c
+++ b/bsd-user/syscall.c
@@ -355,9 +355,8 @@ abi_long do_freebsd_syscall(void *cpu_env, int num, abi_long arg1,
     case TARGET_FREEBSD_NR_writev:
         {
             int count = arg3;
-            struct iovec *vec;
+            g_autofree struct iovec *vec = g_new(struct iovec, count);
 
-            vec = alloca(count * sizeof(struct iovec));
             if (lock_iovec(VERIFY_READ, vec, arg2, count, 1) < 0)
                 goto efault;
             ret = get_errno(writev(arg1, vec, count));
-- 
2.26.3

