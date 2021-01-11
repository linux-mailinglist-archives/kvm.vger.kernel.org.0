Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3111B2F1989
	for <lists+kvm@lfdr.de>; Mon, 11 Jan 2021 16:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbhAKPWB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jan 2021 10:22:01 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37423 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730627AbhAKPWA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 11 Jan 2021 10:22:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610378434;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=97BNT6jh6NRO0TVk+TL23RreQDhzFRma0TINePq+NK8=;
        b=gkISrOGj+re/41lTjOkWdcVMMaJMWpIBT1Bln1bCFxYZdv3LHcMD14FsqGWJmJJrs0v6HY
        TQ+2qNUyLHpXS12AK3JxwGaya7Sv12ZMHIg/QECG0TxArJWnBO2P+/wXdazOkNNWD/o0Qf
        sbIbuUKFYGtt8PUb2knBezRBaXVXfKM=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-280-n7ta02GeOW-PDGuiDveqGw-1; Mon, 11 Jan 2021 10:20:32 -0500
X-MC-Unique: n7ta02GeOW-PDGuiDveqGw-1
Received: by mail-ed1-f70.google.com with SMTP id dh21so8361204edb.6
        for <kvm@vger.kernel.org>; Mon, 11 Jan 2021 07:20:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=97BNT6jh6NRO0TVk+TL23RreQDhzFRma0TINePq+NK8=;
        b=mdVCp523hSIxe6uzLpkDZU0/HTh7wjamcvq6iocZGOnK1ix2WgIqhzAFd1LqwRquOD
         LJcbHV+2+2XcdcO5QOja474US/ktRRucNaAnR9w9cCPfPGRoqlIkKKBQrhpus90b44Zc
         Dga8sfp/Nl4+rFD5xTFyOCyEkQc0cqivKpmsfs+GEL7b4mj/87FS6F8zi4umIenJrYpx
         fcnACB/0ZxLrVO2Eliobi7FoY+SgmKfGo3C4S2iX9WZ/BvJaphgtGFMZoAE7B3IjJKVv
         3TEuIOId6rg6BB9ai3tHezxLyfShwW1IE95sBK3mfKFuGq/y7ZHg84mbbJERt19wBmL7
         vOKA==
X-Gm-Message-State: AOAM5329r2mC9z/nC98BxJN5lK6ZeggL8QO7N7GjeWusCTR6nOfCDGiP
        lf7uwNNkc+DGj2Xh3PIvy9MWX6CWTYomjye/6lSpmrQWuecyopxj7hBjeTchAQSrPSvMZYOqfZI
        O3NIlME4pYpK5
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr14237006edw.52.1610378431356;
        Mon, 11 Jan 2021 07:20:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxfzQ4g/Xi77uXbjKsyJn2nZrlWGnmTOg2kIy8FkRbXj1BTf3rxwC5MxkZMkcW73D4xDrLEXw==
X-Received: by 2002:aa7:cdc3:: with SMTP id h3mr14236981edw.52.1610378431207;
        Mon, 11 Jan 2021 07:20:31 -0800 (PST)
Received: from x1w.redhat.com (129.red-88-21-205.staticip.rima-tde.net. [88.21.205.129])
        by smtp.gmail.com with ESMTPSA id c12sm76932edw.55.2021.01.11.07.20.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 07:20:30 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Huacai Chen <chenhuacai@kernel.org>, Greg Kurz <groug@kaod.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-trivial@nongnu.org,
        Amit Shah <amit@kernel.org>,
        Dmitry Fleytman <dmitry.fleytman@gmail.com>,
        qemu-arm@nongnu.org, John Snow <jsnow@redhat.com>,
        qemu-s390x@nongnu.org, Paul Durrant <paul@xen.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Max Reitz <mreitz@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Halil Pasic <pasic@linux.ibm.com>, Fam Zheng <fam@euphon.net>,
        qemu-ppc@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Stefano Stabellini <sstabellini@kernel.org>,
        xen-devel@lists.xenproject.org, Cornelia Huck <cohuck@redhat.com>,
        David Hildenbrand <david@redhat.com>, qemu-block@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Richard Henderson <richard.henderson@linaro.org>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Laurent Vivier <laurent@vivier.eu>,
        Thomas Huth <thuth@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH 1/2] sysemu/runstate: Let runstate_is_running() return bool
Date:   Mon, 11 Jan 2021 16:20:19 +0100
Message-Id: <20210111152020.1422021-2-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210111152020.1422021-1-philmd@redhat.com>
References: <20210111152020.1422021-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

runstate_check() returns a boolean. runstate_is_running()
returns what runstate_check() returns, also a boolean.

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 include/sysemu/runstate.h | 2 +-
 softmmu/runstate.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/sysemu/runstate.h b/include/sysemu/runstate.h
index e557f470d42..3ab35a039a0 100644
--- a/include/sysemu/runstate.h
+++ b/include/sysemu/runstate.h
@@ -6,7 +6,7 @@
 
 bool runstate_check(RunState state);
 void runstate_set(RunState new_state);
-int runstate_is_running(void);
+bool runstate_is_running(void);
 bool runstate_needs_reset(void);
 bool runstate_store(char *str, size_t size);
 
diff --git a/softmmu/runstate.c b/softmmu/runstate.c
index 636aab0addb..c7a67147d17 100644
--- a/softmmu/runstate.c
+++ b/softmmu/runstate.c
@@ -217,7 +217,7 @@ void runstate_set(RunState new_state)
     current_run_state = new_state;
 }
 
-int runstate_is_running(void)
+bool runstate_is_running(void)
 {
     return runstate_check(RUN_STATE_RUNNING);
 }
-- 
2.26.2

