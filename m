Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12BBE425797
	for <lists+kvm@lfdr.de>; Thu,  7 Oct 2021 18:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242576AbhJGQT3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Oct 2021 12:19:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50039 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242128AbhJGQT2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 7 Oct 2021 12:19:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1633623454;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y8MKkMv6eEYqC4N/epBYvYnHUWa4qpxEvyDLGqIxORI=;
        b=er1JmobkYbhvi0ZdmkmH+pqYM6ztGGJl1K/p4MneIr8op8CF6zyJwZj/P6kpNxOZoYH/PZ
        W/8BvVTifD4w8uvgUH5TKXqYAIfvFlsh6QziBAUZMeyEFCXu/+MLjUC/uqNkTZubf9gUwY
        9PdqMJ6OQ3tnQoEPfEPGxVyFfcjJ8Ig=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-xzPdecMVPDuwJJZB5cK71g-1; Thu, 07 Oct 2021 12:17:33 -0400
X-MC-Unique: xzPdecMVPDuwJJZB5cK71g-1
Received: by mail-wr1-f70.google.com with SMTP id r16-20020adfb1d0000000b00160bf8972ceso5115696wra.13
        for <kvm@vger.kernel.org>; Thu, 07 Oct 2021 09:17:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y8MKkMv6eEYqC4N/epBYvYnHUWa4qpxEvyDLGqIxORI=;
        b=fgkmAiQjd3yXL6bu/p6HLHRP6fAaSc+aQnx49IcIk5/pu0eCM8zlMBUAKR+2qDlTwE
         ZTA86qfgQAXjkFGNvTWfjPtH9cNfP5s5DLWO+/cAIn3U5+A5NBayMqhSgMHdnarg16M7
         NESIpVA9+V8fz9804RH4RMrga/PSjr7wl+mXafQCIXoBwS+5T3N0iqkJ7p3TYues6LiI
         1uzisXdTo9fIyu/2/F+IpZ5MOQBpwjo9nzP3ssVQBAKRXjNTfS/p1wEAO6y3K7eoQUcP
         NSKJs71N9nxqizydtgndjxB8MDbrtsHnYa3CQ6spP12Fh6I6oEtCLGGw3cfSFxAIiPjm
         fM6g==
X-Gm-Message-State: AOAM533AADtlNIAdPWQORKZ3ho5lHrrEGZ44FwBlLo2x6TfyNxyFVhaX
        8RlcDXpGBTj5UemAYQL28QPleLeRFuq16/bSMd/+lyJoci/DJZ8IvDLXEDEOBpVM4DPoIvPjTyI
        i+Ec+gEX77ajm
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr17824174wmc.86.1633623452323;
        Thu, 07 Oct 2021 09:17:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwF+d5yHeqVCso2c8JoGm6EX0nJrH1IGYECCnAhCYPfhEDrS5UZoqX1jwZPwYaiW6EnnPePGQ==
X-Received: by 2002:a1c:7d56:: with SMTP id y83mr17824160wmc.86.1633623452185;
        Thu, 07 Oct 2021 09:17:32 -0700 (PDT)
Received: from x1w.redhat.com (118.red-83-35-24.dynamicip.rima-tde.net. [83.35.24.118])
        by smtp.gmail.com with ESMTPSA id y23sm1024155wmj.42.2021.10.07.09.17.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 09:17:31 -0700 (PDT)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Sergio Lopez <slp@redhat.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH v4 03/23] target/i386/kvm: Introduce i386_softmmu_kvm Meson source set
Date:   Thu,  7 Oct 2021 18:16:56 +0200
Message-Id: <20211007161716.453984-4-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211007161716.453984-1-philmd@redhat.com>
References: <20211007161716.453984-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Introduce the i386_softmmu_kvm Meson source set to be able to
add features dependent on CONFIG_KVM.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 target/i386/kvm/meson.build | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/target/i386/kvm/meson.build b/target/i386/kvm/meson.build
index 0a533411cab..b1c76957c76 100644
--- a/target/i386/kvm/meson.build
+++ b/target/i386/kvm/meson.build
@@ -1,8 +1,12 @@
 i386_ss.add(when: 'CONFIG_KVM', if_false: files('kvm-stub.c'))
 
-i386_softmmu_ss.add(when: 'CONFIG_KVM', if_true: files(
+i386_softmmu_kvm_ss = ss.source_set()
+
+i386_softmmu_kvm_ss.add(files(
   'kvm.c',
   'kvm-cpu.c',
 ))
 
 i386_softmmu_ss.add(when: 'CONFIG_HYPERV', if_true: files('hyperv.c'), if_false: files('hyperv-stub.c'))
+
+i386_softmmu_ss.add_all(when: 'CONFIG_KVM', if_true: i386_softmmu_kvm_ss)
-- 
2.31.1

