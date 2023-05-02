Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7F7C6F49E4
	for <lists+kvm@lfdr.de>; Tue,  2 May 2023 20:47:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229497AbjEBSrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 May 2023 14:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjEBSrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 May 2023 14:47:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F296173C
        for <kvm@vger.kernel.org>; Tue,  2 May 2023 11:46:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683053190;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=m2VDNN7GX+FeD3QyzU7peSzD1fbVt8nTpAgV/GryMXg=;
        b=CDtZli7qNaUyvSitZJlNZjTBUBVOVxsyY3jI6/qBTL+0h4DY8Q9tnnrDPfrFWW/xSXxoq1
        Qx6W9uqiwWEAnVD8QHSxUUO26372NYyg+Igotoaud6Z/TyYx7TOoS4JpTIy7cgSUuhqob5
        rQcj1Wzi8J3imlvTTywekWIHRKv/2Hc=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-503-tmzo8nJYNLijOhyDSJo8lQ-1; Tue, 02 May 2023 14:46:29 -0400
X-MC-Unique: tmzo8nJYNLijOhyDSJo8lQ-1
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-76359b8d29dso621026839f.1
        for <kvm@vger.kernel.org>; Tue, 02 May 2023 11:46:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683053188; x=1685645188;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=m2VDNN7GX+FeD3QyzU7peSzD1fbVt8nTpAgV/GryMXg=;
        b=L+4e5MQcZSuOscwQdgPDsV24b7J/UGk9aW2VEvibFxj9BaIB3qtNHAHhcMvRoj2RKm
         S3wIXUUfvdMcemuBsrk/FeBXNh8L7dQJ0g48pM5uyQrQOXu/wbSxtS86l8AJbjzYW3Kh
         q/EBR9S0am1rynVFS78LBVY27NNjaNB7yXkLJ1Z5Z4DOCFW1xYJVNhiZU77ArMeWa3YW
         85FHwLvVe9UOPGZCHhhMZ9HDzZe7xQjQloXxVPPMzH7xLmg3MOy4K7jwPYnJC8MUELax
         MAsaN6Q5WNyhkmgN6w/5rtPrfLzESBUjoZlEdzGltaCbnpOJNoVxf64CKjr2S5kmGqwa
         HJJg==
X-Gm-Message-State: AC+VfDx/Fww4dRkyf9bu9JVs0Y+Om/p6VSJXP8AWrHgLJHflU9vn9Pfq
        ZFNosnxfDy1ZvLyRtWXS7t9Tz26hx6IkTZfOY8XHzTqAta4UmhMRY4KLBdKCGTNP4np9ISatFJP
        9yf6zfjfwLfVkHs5/DKC/
X-Received: by 2002:a5d:924e:0:b0:766:59fe:11f3 with SMTP id e14-20020a5d924e000000b0076659fe11f3mr11617137iol.14.1683053188190;
        Tue, 02 May 2023 11:46:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7dq4rSAg8BfqQuD4Y3U0R8u3tH8wzcOS0ObF5dTvXP+f6FdH9JDWt6Gm2UyiVtwUWCGfaU7Q==
X-Received: by 2002:a5d:924e:0:b0:766:59fe:11f3 with SMTP id e14-20020a5d924e000000b0076659fe11f3mr11617124iol.14.1683053187890;
        Tue, 02 May 2023 11:46:27 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id a25-20020a6b6c19000000b0075c37601b5csm8625436ioh.4.2023.05.02.11.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 11:46:27 -0700 (PDT)
Date:   Tue, 2 May 2023 12:46:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO updates for v6.4-rc1
Message-ID: <20230502124625.355ec05e.alex.williamson@redhat.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 09a9639e56c01c7a00d6c0ca63f4c7c41abe075d:

  Linux 6.3-rc6 (2023-04-09 11:15:57 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.4-rc1

for you to fetch changes up to 705b004ee377b789e39ae237519bab714297ac83:

  docs: kvm: vfio: Suggest KVM_DEV_VFIO_GROUP_ADD vs VFIO_GROUP_GET_DEVICE_FD ordering (2023-04-21 13:48:44 -0600)

----------------------------------------------------------------
VFIO updates for v6.4-rc1

 - Expose and allow R/W access to the PCIe DVSEC capability through
   vfio-pci, as we already do with the legacy vendor capability.
   (K V P Satyanarayana)

 - Fix kernel-doc issues with structure definitions. (Simon Horman)

 - Clarify ordering of operations relative to the kvm-vfio device for
   driver dependencies against the kvm pointer. (Yi Liu)

----------------------------------------------------------------
K V P, Satyanarayana (1):
      vfio/pci: Add DVSEC PCI Extended Config Capability to user visible list.

Simon Horman (1):
      vfio: correct kdoc for ops structures

Yi Liu (1):
      docs: kvm: vfio: Suggest KVM_DEV_VFIO_GROUP_ADD vs VFIO_GROUP_GET_DEVICE_FD ordering

 Documentation/virt/kvm/devices/vfio.rst | 5 +++++
 drivers/vfio/pci/vfio_pci_config.c      | 7 +++++++
 include/linux/vfio.h                    | 5 +++++
 3 files changed, 17 insertions(+)

