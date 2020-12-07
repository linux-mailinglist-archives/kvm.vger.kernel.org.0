Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F6B2D11A5
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 14:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725981AbgLGNQm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 08:16:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43893 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725550AbgLGNQm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 08:16:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607346915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DUD443fjC7TlYCq2Zs7qkYPHzlFo7vsq2RAf28zHG0Y=;
        b=b49Y+4DyR6uXgzYr3drfs9eM2NaovpAiJryrok+zE1zpgP+0GZJlY/9Apr+vIgcT8Xveo7
        jbAkDr/2jZGDMDIb95XFKAd+21AM+VaEWpYUvgc8DOa8nclMXIV3lg9Dzf2dkKPa5In1yf
        QnNEFAFVp14994KiswEMc6UsNe7OdU0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-491-86ymiXs0Mx-a8AJMAzopVA-1; Mon, 07 Dec 2020 08:15:13 -0500
X-MC-Unique: 86ymiXs0Mx-a8AJMAzopVA-1
Received: by mail-wm1-f70.google.com with SMTP id a205so4075006wme.9
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 05:15:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=DUD443fjC7TlYCq2Zs7qkYPHzlFo7vsq2RAf28zHG0Y=;
        b=XDxXNINrnSAESnrcpu0Qwp8hqX76v4V4Yq34PR37noFN9j8dUAtQAgsLPmGq5SnJgL
         UtN7kPa2JJpBqldAQpDRvcR8EFAwjGNPa/TM3BO4Rh2C4X9sq+WWi9eC+Vx9hojsYRWf
         sDVCbgb+cHK41AVm4v+K21YVDpLYJHWX9OwT8sW2V7gZ1vBTl8M40oeE603AgbGyG3pJ
         yFXo4+yx8cz2Xg0d7G3Px11RF/kjevteeNlKo/rPs+oHwfLJlBZntLHx5c26vQuEdCLW
         vA3QWj+yKQuGfsA6kHFRMfF2IOtJXKEAZy26cZBQh7owjxNSjLtSemkboWWergENDcTh
         HhPA==
X-Gm-Message-State: AOAM531LwtNKaf6J4q2QSPIrwXk1Ul6eiLxReRxaMv+Iez/H5ejF5Mjr
        2imjOfEP/ztbBgDYo3wP5GGq6fcY66FFQvAjmee7vpeBdPnKrufcW8dRxOhrXEdGZ+7lxQVLw4H
        gx5hAXzEZPIEX
X-Received: by 2002:a1c:c2d4:: with SMTP id s203mr18470507wmf.58.1607346912724;
        Mon, 07 Dec 2020 05:15:12 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx0KSXp7DP6CDis0L6tP1I2Gzz9cpg1u4ccuV+5/oiKxMdma/cepl4uO8AaAxQi4CtlwH61VQ==
X-Received: by 2002:a1c:c2d4:: with SMTP id s203mr18470485wmf.58.1607346912558;
        Mon, 07 Dec 2020 05:15:12 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id k18sm2265572wrd.45.2020.12.07.05.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 05:15:11 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        qemu-s390x@nongnu.org, Halil Pasic <pasic@linux.ibm.com>,
        Willian Rampazzo <wrampazz@redhat.com>,
        Paul Durrant <paul@xen.org>, Cornelia Huck <cohuck@redhat.com>,
        xen-devel@lists.xenproject.org,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Claudio Fontana <cfontana@suse.de>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>
Subject: [PATCH v3 1/5] gitlab-ci: Document 'build-tcg-disabled' is a KVM X86 job
Date:   Mon,  7 Dec 2020 14:14:59 +0100
Message-Id: <20201207131503.3858889-2-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207131503.3858889-1-philmd@redhat.com>
References: <20201207131503.3858889-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document what this job cover (build X86 targets with
KVM being the single accelerator available).

Reviewed-by: Thomas Huth <thuth@redhat.com>
Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 .gitlab-ci.yml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
index d0173e82b16..ee31b1020fe 100644
--- a/.gitlab-ci.yml
+++ b/.gitlab-ci.yml
@@ -220,6 +220,11 @@ build-disabled:
       s390x-softmmu i386-linux-user
     MAKE_CHECK_ARGS: check-qtest SPEED=slow
 
+# This jobs explicitly disable TCG (--disable-tcg), KVM is detected by
+# the configure script. The container doesn't contain Xen headers so
+# Xen accelerator is not detected / selected. As result it build the
+# i386-softmmu and x86_64-softmmu with KVM being the single accelerator
+# available.
 build-tcg-disabled:
   <<: *native_build_job_definition
   variables:
-- 
2.26.2

