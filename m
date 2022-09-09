Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBFE5B35AD
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 12:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbiIIKwk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 06:52:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiIIKwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 06:52:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E08CA138822
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 03:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662720755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bBeJNEcuYYhVR/b07R8rp8a2HzeiOk4AQkZ+y0hkJsU=;
        b=LuMVp3WqyWboryfp2/fNhfAxNUuxNni7VY0Z7zs7JtYO6d6iqFibmZmn4jk8l63fLgY0jm
        i5qPPxpq/A5DUOatbFAnRrxSTNZjp9xJrndSoQiavhlC8n21xxREv+zHSwBMCTPFXB133h
        n0KsSRri4EKCun0rkcXX5weG8woFhaQ=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-461-qagsANDmN4SM31u6dv5ZAQ-1; Fri, 09 Sep 2022 06:52:29 -0400
X-MC-Unique: qagsANDmN4SM31u6dv5ZAQ-1
Received: by mail-il1-f197.google.com with SMTP id h5-20020a056e021d8500b002eb09a4f7e6so944172ila.14
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 03:52:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:organization:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=bBeJNEcuYYhVR/b07R8rp8a2HzeiOk4AQkZ+y0hkJsU=;
        b=Qceo2EYQiQvFbnPBpwAnYRTzio35OeoZ0dvrFJM8K8kjgbOR9aLnQloH3iVbRezG5H
         jT31/lWHmdzd6p+AeLwmIP9DaqIAsIZvYGG93vfCabpglX9JB5IdTdJWwM5ANSf1Va0/
         f4E4ByOmC+1GrymHVPxL30rcFKeX7w2hQUOvz+KLviPycIcyvJaoZXrJF6O0rrvOPG+Z
         AfExGq+EerhXQTLTa/ye8iMyWPo/TizJ9MKQaVewwoZJ1mlWcOMRdITcg0CJn5Gcudqi
         xh4gh6wY41dl18U55K8bZidb4hf+vg2CzXkxEC2GC2VZNvqXQMCuST7hnh9v43evOfxC
         uE2A==
X-Gm-Message-State: ACgBeo1lgNu0Q6m5zhsSLB34hlRRUzggLUcRxeET/71Wec5+TjtyCb3+
        B9ikmlNuxRs8JaCYSc/J/LEvOHs436jPs2K+dlsixpHTu3GanyA1vjdmAfj7vzlT6Hfj8g9GRQh
        jMi+OHb02SIVg
X-Received: by 2002:a02:cccd:0:b0:346:e38b:1c5e with SMTP id k13-20020a02cccd000000b00346e38b1c5emr6868278jaq.47.1662720748418;
        Fri, 09 Sep 2022 03:52:28 -0700 (PDT)
X-Google-Smtp-Source: AA6agR5Lg7DnuAhs7L17ED1EB+S3tJ6SrMy4bUyNEMRtD8p5j3U6L7hn9ScEGS8pxZqNLkDcEF7aKw==
X-Received: by 2002:a02:cccd:0:b0:346:e38b:1c5e with SMTP id k13-20020a02cccd000000b00346e38b1c5emr6868266jaq.47.1662720748090;
        Fri, 09 Sep 2022 03:52:28 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id ay27-20020a056638411b00b00356636349c5sm66176jab.157.2022.09.09.03.52.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 03:52:27 -0700 (PDT)
Date:   Fri, 9 Sep 2022 04:52:25 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] VFIO fix for v6.0-rc5
Message-ID: <20220909045225.3a572a57.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit b90cb1053190353cc30f0fef0ef1f378ccc063c5:

  Linux 6.0-rc3 (2022-08-28 15:05:29 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.0-rc5

for you to fetch changes up to 873aefb376bbc0ed1dd2381ea1d6ec88106fdbd4:

  vfio/type1: Unpin zero pages (2022-08-31 08:57:30 -0600)

----------------------------------------------------------------
VFIO fix for v6.0-rc5

 - Fix zero page refcount leak (Alex Williamson)

----------------------------------------------------------------
Alex Williamson (1):
      vfio/type1: Unpin zero pages

 drivers/vfio/vfio_iommu_type1.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

