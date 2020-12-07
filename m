Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 712EC2D0EED
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgLGLZb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:25:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726653AbgLGLZb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:25:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607340245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U6QCRjxKvIwhYoV/41s2s2+6dI4wCbnqhxRPlqlth8U=;
        b=EfzQpQ/kqV49/D6sGFTAsOqsOLFZiRI2HKbkO+YuCnpL5UmPxJVmcpQyIpWrAOg2QMSpnF
        1/k90VajmPa2g2TPI5nIS809Km5vRJ5nnV5BwbaaBjyoWGJEq+73dWNZKyL9fWN6Z3RKGw
        dkU9z6fFhaV/DULnOwAUXui7lob1Ubg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-221-sxPFdyLgN3GGBmp2ZfU51w-1; Mon, 07 Dec 2020 06:24:03 -0500
X-MC-Unique: sxPFdyLgN3GGBmp2ZfU51w-1
Received: by mail-wm1-f71.google.com with SMTP id u123so4020579wmu.5
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 03:24:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U6QCRjxKvIwhYoV/41s2s2+6dI4wCbnqhxRPlqlth8U=;
        b=hsvWHAFURQRdZ7bSTOR1fJWplZWU7u1b98qlNBfW5jLpEQiFM1qNcfXbtZggGAGRYI
         yy2DXrscWB0emXR02wh1NKA2Ok2J/5Lf/MGncq96dweH0z1ojYxuTwABbVhhtxMgg68W
         5XDFgTf3WVGtJRakVm9+8M9eD7pizaTSokiTeTml/S4NvZCOuBF2ZBX/iayR82uU9d2E
         FR22nn69+H1rsFP93vWPH7RTQf3ORmf/d6up+9cMER0ZqW21o3m5cftG4g7NhguoUZ0v
         yUmq+oTbEkynlnLRnqVuP2EV0Q3c8/1oMiF3Eif2/sNIAI2VMHx0qt6TGkrQRuqoMVNj
         YX2w==
X-Gm-Message-State: AOAM530SqGZBPmvt2Qup7v2xT3/uZQziwWcVHlyuyWBuSiTsU1CdTGo7
        oXNfkJrbHmUFHq69p2pZluAMLswr8fblmQB/WaIJUN+AJGGuUYJRp7SxRGb0264/fTB+qHI23mo
        1j+bXtKzzSiK9
X-Received: by 2002:a1c:4907:: with SMTP id w7mr10183693wma.175.1607340242504;
        Mon, 07 Dec 2020 03:24:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyUOPOj91GL2D5bWSF19z1crpAKZX/6htMwNjDW7CLNGlfCM/ktiYiE4SKzGGKVP6p9Vp9lvg==
X-Received: by 2002:a1c:4907:: with SMTP id w7mr10183684wma.175.1607340242361;
        Mon, 07 Dec 2020 03:24:02 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id k11sm13362266wmj.42.2020.12.07.03.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 03:24:01 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>, qemu-s390x@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: [PATCH v2 1/5] gitlab-ci: Document 'build-tcg-disabled' is a KVM X86 job
Date:   Mon,  7 Dec 2020 12:23:49 +0100
Message-Id: <20201207112353.3814480-2-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201207112353.3814480-1-philmd@redhat.com>
References: <20201207112353.3814480-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Document what this job cover (build X86 targets with
KVM being the single accelerator available).

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

