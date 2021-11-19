Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0C48456C36
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 10:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234094AbhKSJUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 04:20:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:53813 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234009AbhKSJUY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Nov 2021 04:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637313442;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gRoflLF2rC1zBazllCjukemH1mBXXWiz/W1zufMnXs0=;
        b=Sym+kHQozEile39ucYD1ItqEAIsGWmCmrJiP3RDo6DC8RA9aWyIGdFK11cMsi5/xC5kh4N
        1k8RAzB25zaESssBA5rCn/IC+PS6NEeFQ61Q9ZuM49djw5hdFgklg/8yWAgtZFudXb0yZA
        cl61r6ilUII6qGNSV+VVVntuMFULeec=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-U3SIorzcPgG43oNeKq-8kQ-1; Fri, 19 Nov 2021 04:17:18 -0500
X-MC-Unique: U3SIorzcPgG43oNeKq-8kQ-1
Received: by mail-wm1-f70.google.com with SMTP id g11-20020a1c200b000000b003320d092d08so3770553wmg.9
        for <kvm@vger.kernel.org>; Fri, 19 Nov 2021 01:17:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gRoflLF2rC1zBazllCjukemH1mBXXWiz/W1zufMnXs0=;
        b=qIAvK9w4c4piVWhLfSphpbzNAAUFOBIQ7LGWCLUCIrWsCxsI4yfZOhkPVeInuta3UD
         +wnTnnBrHpdR6r9JdSDBdwUvjpakyHrNIeSD7j+7G3VWJmt/JUjt2DaxI1WgsxeaMv/8
         oDvtTULzb761FOpBPPURFp9ArTp4UHwE/iXtZmdDKOx3CGCglpvYYgDmBDo4bVHE7t66
         NhVr7gWonqL7iGw1WmftHdrX+7CRUCrNTEaVGf2+LiEY2p+dyUBo5DIx+R7/29y6bo1Z
         7dAs/s5+UqoG3z+D7nRKdZURkk2qgjOWVLllMSmtyfaQCy0ttMHRuwjJH2EnB0FVCnxX
         zT7A==
X-Gm-Message-State: AOAM533LuAK8XuIe88J3G3jNWp4pGqHJpzWcy4wFHlttRcCWOk63YxCf
        Jz0+VJLdYzcsr2qeyNtiBXHBhs2pW8Kp08oX/f5hdO92J7qkkjYE2vWAyrtvc7kbP7zQr1R4eiJ
        MXvMBt+/iamX6
X-Received: by 2002:adf:f40b:: with SMTP id g11mr5714960wro.296.1637313437446;
        Fri, 19 Nov 2021 01:17:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzjtIV1auJ1KnpG4qWnuDniPJZ9WC7iv91EjYI8edvo1a8UkKpFC/6mc24Mh9Gkk00xmpLlIA==
X-Received: by 2002:adf:f40b:: with SMTP id g11mr5714945wro.296.1637313437328;
        Fri, 19 Nov 2021 01:17:17 -0800 (PST)
Received: from x1w.. (62.red-83-57-168.dynamicip.rima-tde.net. [83.57.168.62])
        by smtp.gmail.com with ESMTPSA id j8sm2305880wrh.16.2021.11.19.01.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 01:17:17 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Cleber Rosa <crosa@redhat.com>, John Snow <jsnow@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Markus Armbruster <armbru@redhat.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Michael Roth <michael.roth@amd.com>, qemu-block@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Taylor Simpson <tsimpson@quicinc.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
Subject: [PATCH-for-6.2? v2 3/3] qga: Spell QEMU all caps
Date:   Fri, 19 Nov 2021 10:17:01 +0100
Message-Id: <20211119091701.277973-4-philmd@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211119091701.277973-1-philmd@redhat.com>
References: <20211119091701.277973-1-philmd@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU should be written all caps.

Normally checkpatch.pl warns when it is not (see commit
9964d8f9422: "checkpatch: Add QEMU specific rule").

Replace Qemu -> QEMU, update the error message to use the
more descriptive "Guest Agent" name instead of "GA".

Signed-off-by: Philippe Mathieu-Daudé <philmd@redhat.com>
---
 qga/installer/qemu-ga.wxs | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/qga/installer/qemu-ga.wxs b/qga/installer/qemu-ga.wxs
index 0950e8c6bec..c02e47fc036 100644
--- a/qga/installer/qemu-ga.wxs
+++ b/qga/installer/qemu-ga.wxs
@@ -40,14 +40,14 @@
   <?endif?>
 
   <Product
-    Name="QEMU guest agent"
+    Name="QEMU Guest Agent"
     Id="*"
     UpgradeCode="{EB6B8302-C06E-4BEC-ADAC-932C68A3A98D}"
     Manufacturer="$(env.QEMU_GA_MANUFACTURER)"
     Version="$(env.QEMU_GA_VERSION)"
     Language="1033">
     <?if $(var.Arch) = 32 ?>
-    <Condition Message="Error: 32-bit version of Qemu GA can not be installed on 64-bit Windows.">NOT VersionNT64</Condition>
+    <Condition Message="Error: 32-bit version of QEMU Guest Agent can not be installed on 64-bit Windows.">NOT VersionNT64</Condition>
     <?endif?>
     <Package
       Manufacturer="$(env.QEMU_GA_MANUFACTURER)"
@@ -64,7 +64,7 @@
 
     <Directory Id="TARGETDIR" Name="SourceDir">
       <Directory Id="$(var.GaProgramFilesFolder)" Name="QEMU Guest Agent">
-        <Directory Id="qemu_ga_directory" Name="Qemu-ga">
+        <Directory Id="qemu_ga_directory" Name="QEMU-GA">
           <Component Id="qemu_ga" Guid="{908B7199-DE2A-4DC6-A8D0-27A5AE444FEA}">
             <File Id="qemu_ga.exe" Name="qemu-ga.exe" Source="$(env.BUILD_DIR)/qga/qemu-ga.exe" KeyPath="yes" DiskId="1"/>
             <ServiceInstall
-- 
2.31.1

