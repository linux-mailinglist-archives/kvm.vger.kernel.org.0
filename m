Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7E941FBE5
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhJBMzf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:55:35 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47715 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233216AbhJBMzf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:55:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T1NIBoSE4LuxR67pjfbeheswmOYBoIBhIFI0FnH33UA=;
        b=hom5VAod04hjnOJJP+FoudbVaFc0wkak+VXQIRrTBLUQP8GfK/wu6Da8mS20UtAfAzbkVR
        sll4HZuqC1rVbE3vRSHUfGEM3eRet5x2KrZhHthQJ99ZQPUXQ6hnj6d49hulJCZaBF7ua+
        TNZ6vzs3koKHlGaGwQU/hth0yX4qIr4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-c6p7q1fFOYGIicM1kithSg-1; Sat, 02 Oct 2021 08:53:48 -0400
X-MC-Unique: c6p7q1fFOYGIicM1kithSg-1
Received: by mail-wm1-f71.google.com with SMTP id j21-20020a05600c1c1500b0030ccce95837so3788990wms.3
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T1NIBoSE4LuxR67pjfbeheswmOYBoIBhIFI0FnH33UA=;
        b=0c8mQ7Ho47mh+lXRnLhSR1MpIwSgLCztXByrc6PsOfgYxcW/JHWDTUC8rdUjFtwJlG
         MXv3lu2T4b1ISq2KyDfKYoXNlZvKD96wlikpgwamcCNby7znqgfx/7cGXnImo506HZ0e
         ppgm9w7hSD7GogSOyIelYCJiH2VOIUzLE59DiIicbM26ZdBsYWVUNYktC/R/IGFFfP0S
         OnCiiyaOXs/o2pd3qo3A75m4/QUa1Z1n8ndOeUHg7vq4QjcdnYsnMsxqPA0QUoKRNKa7
         GVDuHMJ9+9IZIElnO9+VymH9M3XqyAz/vqnxRN8F+qHxq+jQsHFPuppPYlwtpmjrb4bR
         T09A==
X-Gm-Message-State: AOAM530zNLKgnkdhvH3drTk4fZpEex0hXLmQ0lJNjjR/13J3syjJcFkq
        LhRIEf+gwjSCyUFZJcOf8S3cjyDFpKcw05b0508MZzyn7+HY9q/04TVcQG5JT1SYu03RW0LGhXz
        cIhfmopd2X2Xn
X-Received: by 2002:a05:6000:c3:: with SMTP id q3mr3272625wrx.361.1633179226451;
        Sat, 02 Oct 2021 05:53:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxSb9fTK6/UuOYq5MO4Gn39GE9tLudrOZsgwLInKNkYdtRvDdV88QT0skDGxAwXecnl0DrCeA==
X-Received: by 2002:a05:6000:c3:: with SMTP id q3mr3272609wrx.361.1633179226312;
        Sat, 02 Oct 2021 05:53:46 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id l26sm10571166wmi.25.2021.10.02.05.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:53:46 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        James Bottomley <jejb@linux.ibm.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        "Daniel P . Berrange" <berrange@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>
Subject: [PATCH v3 06/22] target/i386/cpu: Add missing 'qapi/error.h' header
Date:   Sat,  2 Oct 2021 14:53:01 +0200
Message-Id: <20211002125317.3418648-7-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Commit 00b81053244 ("target-i386: Remove assert_no_error usage")
forgot to add the "qapi/error.h" for &error_abort, add it now.

Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
Reviewed-by: Connor Kuehl <ckuehl@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/cpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/target/i386/cpu.c b/target/i386/cpu.c
index cacec605bf1..e169a01713d 100644
--- a/target/i386/cpu.c
+++ b/target/i386/cpu.c
@@ -27,6 +27,7 @@
 #include "sysemu/hvf.h"
 #include "kvm/kvm_i386.h"
 #include "sev_i386.h"
+#include "qapi/error.h"
 #include "qapi/qapi-visit-machine.h"
 #include "qapi/qmp/qerror.h"
 #include "qapi/qapi-commands-machine-target.h"
-- 
2.31.1

