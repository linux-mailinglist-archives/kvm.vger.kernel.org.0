Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A9F3513CDF
	for <lists+kvm@lfdr.de>; Thu, 28 Apr 2022 22:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351927AbiD1Uyh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Apr 2022 16:54:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236992AbiD1Uyg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Apr 2022 16:54:36 -0400
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FF06E8E3;
        Thu, 28 Apr 2022 13:51:20 -0700 (PDT)
Received: by mail-qv1-xf33.google.com with SMTP id q13so4082157qvk.3;
        Thu, 28 Apr 2022 13:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ahmsxGBp2MwMA3sj4/KBiWzEQEE2E96hzz7zFwhvNm4=;
        b=pKRCBLEvIV/YU4iWHNl2rS1Hi8u1KdoWTBvrAVRycQcK/vh3cQWPCu6UTrv5B/GYR+
         NcSMcHqO11hilkbx/1hvBoKD8/PUPIugLLb94v6yD5G+cUwUwqSssquIqmBwJKo7s+WT
         ddeEPt0322Mk3W6Iw2e+MnCiMSMrhRlfSqjo+UTsz55/D30cc8D63RYUGmX/6khmC21s
         VNdT4mStw2x2OEtWWPsM/ER+K2ceLXOg0XHukjHYNda1d64FXp4kzx9I06S1chJRaKHJ
         6Otr4z4+5iBlx7Um0Jfwkg66jFUfJE4ly4J3bMpVeJ5W1Q4LOnbSdOcZ788D6OPtsCXs
         A7Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ahmsxGBp2MwMA3sj4/KBiWzEQEE2E96hzz7zFwhvNm4=;
        b=zQjkS79aiU94MrUkpdAVmFSz4FiMsAPto3oJgBwI2ZtATIg0gtmVmI+gKo7YIJfMQs
         1u15v1KgibsTCjGuOTp4KGToKB6vQBKiUPbDjBClVF7QiisVYa1p7wuc3V53if7plvEc
         SJoHwdWXF9mDohwlUYOCsACk7sDrenOUVsJMT27XW8kHQRSgyNF0fzqYNUUU5/F1LOQz
         s823b5BkCDAK0tyhGOfDoAZ616A7iAVJH+zwSqwzojk3hWSGxEScAMmqUZhfJujNcS9x
         m/x+qctBLQy82psZmWPIsvlV2nbSPdd7b0PJoWBSxfsYob+D0l0/K98GlrJ8MLPZP4ze
         Rm6A==
X-Gm-Message-State: AOAM533Eqp8jQel9M1qBt08Z9G/iVdPyXiNgYa4AfyVgMzryXaa6SLZ+
        slxCV+D+5cW1kyAP4L1SBYZwf1G9A/o=
X-Google-Smtp-Source: ABdhPJx9SvBAXEB+cBZ2RPR5ZBXM6yOkHdc/mxMtpdswhqNKwbO9JuqAEVH5BJmXbVkuksiqly/dmw==
X-Received: by 2002:a05:6214:b6f:b0:450:a4ab:b409 with SMTP id ey15-20020a0562140b6f00b00450a4abb409mr25023773qvb.123.1651179079722;
        Thu, 28 Apr 2022 13:51:19 -0700 (PDT)
Received: from localhost ([2601:c4:c432:4da:fa85:340e:2244:1d8c])
        by smtp.gmail.com with ESMTPSA id q17-20020a05622a031100b002f1d478c218sm628994qtw.62.2022.04.28.13.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 13:51:19 -0700 (PDT)
From:   Yury Norov <yury.norov@gmail.com>
To:     linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Yury Norov <yury.norov@gmail.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 0/5] bitmap: fix conversion from/to fix-sized arrays
Date:   Thu, 28 Apr 2022 13:51:11 -0700
Message-Id: <20220428205116.861003-1-yury.norov@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
X-Mailer: git-send-email 2.32.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

In the kernel codebase we have functions that call bitmap_copy()
to convert bitmaps to and from fix-sized 32 or 64-bit arrays. It
works well for LE architectures when size of long is equal to the
size of fixed type.

If the system is BE and/or size of long is not equal to the size of
fixed type of the array, bitmap_copy() may produce wrong result either
because of endianness issue, or because of out-of-bound access.

To address this problem we have bitmap_{from,to}_arr32(). In recent
discussion it was spotted that we also need 64-bit analogue:

https://lore.kernel.org/all/YiCWNdWd+AsLbDkp@smile.fi.intel.com/T/#m754da92acb0003e12b99293d07ddcd46dbe04ada

This series takes care of it.

v1: https://lore.kernel.org/lkml/20220420222530.910125-3-yury.norov@gmail.com/T/
v2: - fix build warnings (patch 2)
    - add test for bitmap_{from,to}_arr64

Yury Norov (5):
  lib/bitmap: extend comment for bitmap_(from,to)_arr32()
  lib: add bitmap_{from,to}_arr64
  lib/bitmap: add test for bitmap_{from,to}_arr64
  KVM: s390: replace bitmap_copy with bitmap_{from,to}_arr64 where
    appropriate
  drm/amd/pm: use bitmap_{from,to}_arr32 where appropriate

 arch/s390/kvm/kvm-s390.c                      | 10 ++--
 .../gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c    |  2 +-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c    |  2 +-
 include/linux/bitmap.h                        | 31 +++++++++---
 lib/bitmap.c                                  | 48 +++++++++++++++++++
 lib/test_bitmap.c                             | 25 ++++++++++
 6 files changed, 103 insertions(+), 15 deletions(-)

-- 
2.32.0

