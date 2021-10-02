Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8786341FBF5
	for <lists+kvm@lfdr.de>; Sat,  2 Oct 2021 14:55:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhJBM4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 2 Oct 2021 08:56:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233331AbhJBM4q (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 2 Oct 2021 08:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633179300;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9cOF84rCmS7WTO0HbW0oz9DUXo06vj+3GXepVVOD4Pg=;
        b=M/6JDvqkoQdDVXW2OzxyCwaqNJbJ0jTIoq7OBp0iwRMeeAzAfQCpqCJnDt74Oau12LVahh
        IFk3IO/bBSx3lpBdyNTqwVFq0/vZCLGk2IYLm8Fn38AnLrFZvUer1n3INtXNSI+kisoiQC
        +0gUKP0UtcZpU8Rau1h7rzNOpsSG+VY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-453-tg0nZv1iNj6ie2oN8WQ_DQ-1; Sat, 02 Oct 2021 08:54:59 -0400
X-MC-Unique: tg0nZv1iNj6ie2oN8WQ_DQ-1
Received: by mail-wr1-f70.google.com with SMTP id j16-20020adfa550000000b0016012acc443so3511448wrb.14
        for <kvm@vger.kernel.org>; Sat, 02 Oct 2021 05:54:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9cOF84rCmS7WTO0HbW0oz9DUXo06vj+3GXepVVOD4Pg=;
        b=U+b2k1acxTRj5Scd2mmz/g5SL8gsgPKycdRtX8OCmLDbLSycjOH+b2rMgsQZjHP3Xk
         vqe05Lu/0N1AWpwJfBRO6lq/0GbolPY/wG7jonVxI/RNoRsc3MglSu7RoER7ru+IHt89
         QhHCXUkjCayOlmNXk7jBI2Rg5ZPtMzRRzaCylnYRoOyUJVu3Nx2KuBqkuyu4vN0u9zmZ
         Ii8VSCnDF3daBAMUTC+B2FcxHPqhkmFjSaywmZAeUwDRhQWO6C/RbDTt9X5dCLPW/bu2
         leqmQNav6YLPZ2+vNxop5K//8fspe/85NnvwuLmdQyv9DNIB8rxozpExvaCwVOoiI/wU
         eqDw==
X-Gm-Message-State: AOAM533NP+Cj4uIcwckQ+AyiNTPtJfKCwnsIPXvmF9t5HpohDjzlfkkQ
        O98AGptRpt7EpKTBYlWzwlbt0yZwyFXtI5BmKt6xmJfjmZfHkCayz17JPunL4WkUT6UohQZq8rs
        UwyHl5+HCS2W/
X-Received: by 2002:a05:600c:a4b:: with SMTP id c11mr9217335wmq.97.1633179298644;
        Sat, 02 Oct 2021 05:54:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEYfPco7QeJt1MbnGV0YAVEkNIsPSX2xggQ+cxCOIhC5Ja//3oCylj2OTXEwQB2mCra2x0Dg==
X-Received: by 2002:a05:600c:a4b:: with SMTP id c11mr9217325wmq.97.1633179298521;
        Sat, 02 Oct 2021 05:54:58 -0700 (PDT)
Received: from x1w.. (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id o3sm8574713wra.52.2021.10.02.05.54.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Oct 2021 05:54:58 -0700 (PDT)
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
        "Daniel P . Berrange" <berrange@redhat.com>
Subject: [PATCH v3 22/22] MAINTAINERS: Cover AMD SEV files
Date:   Sat,  2 Oct 2021 14:53:17 +0200
Message-Id: <20211002125317.3418648-23-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211002125317.3418648-1-philmd@redhat.com>
References: <20211002125317.3418648-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Add an entry to list SEV-related files.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 50435b8d2f5..733a5201e76 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3038,6 +3038,13 @@ F: hw/core/clock-vmstate.c
 F: hw/core/qdev-clock.c
 F: docs/devel/clocks.rst
 
+AMD Secure Encrypted Virtualization (SEV)
+S: Orphan
+F: docs/amd-memory-encryption.txt
+F: target/i386/sev*
+F: target/i386/kvm/sev-stub.c
+F: include/sysemu/sev.h
+
 Usermode Emulation
 ------------------
 Overall usermode emulation
-- 
2.31.1

