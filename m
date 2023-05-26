Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65C0C712E14
	for <lists+kvm@lfdr.de>; Fri, 26 May 2023 22:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbjEZUTk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 May 2023 16:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbjEZUTi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 May 2023 16:19:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F05E7
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 13:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685132330;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=K+NKhhSWMXaeALHcoBFkaKbpOK9/rzoJSpWkQXlKvtE=;
        b=K+hYlCH7lpdP1E1A6Yjc1MEFHpn9btRyenon3EPNTNwxTuaIFncYgpglTOzj2DlRYCKQu4
        KdsY4C9QddhIqI7SNPFuyoMjVwLY1W4sIgwJ4vc4F/Gy9SMjyef1et+TLYAJL6A1SgdDUl
        LIWddXXcfgE30THYrG7zGN81zPk42hk=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-320-5HLbW6mqMRWLkEaSH_7Cdg-1; Fri, 26 May 2023 16:18:49 -0400
X-MC-Unique: 5HLbW6mqMRWLkEaSH_7Cdg-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7606e3c6c8aso84529939f.2
        for <kvm@vger.kernel.org>; Fri, 26 May 2023 13:18:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685132328; x=1687724328;
        h=content-transfer-encoding:mime-version:organization:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+NKhhSWMXaeALHcoBFkaKbpOK9/rzoJSpWkQXlKvtE=;
        b=WAtxDElp0OiyitxeUGHj4Z01v3yjWJrZJjSuuHqu4XBYnOzDIPe7p/5lDfMlt5fojC
         bKsU9qGoAdYwtoa30mSuluD5MzL4uIP3a16RfVgA8HhovPWAcbiivWg87I1fiuDngJKw
         OLE1SZ8/L0FkRUFa8ho7e2kPLo9CljdrMubrrEb7angHKebvHQku4vcEgRWWwiEIjuzy
         irkwcDuk2WupEF4ZjhIbyh4a3+F8GO3eWTqChSsCE7VR8AQNVScSpPnTuKsybcDnLNEk
         g/5q5Bu6N1Ngcadpo1CtcHSbz8TlTR5AHfmBB9EzykgImoD8VIt7gItUKSWkGBMdCanA
         7lMw==
X-Gm-Message-State: AC+VfDxBW3wSTffxABLybFheK2dSki30V5gOIQYUHdw3mG8djWWa7WQr
        c9/91p2On4xI/GC18IZDTFYznihrSnjohLREFMjTiUloLDsJdDdV/Eb/Y1yJzt6n/9tVvDEMgQp
        1EYLYi3oVTIKS
X-Received: by 2002:a5e:8b4c:0:b0:76c:56fb:3c59 with SMTP id z12-20020a5e8b4c000000b0076c56fb3c59mr1794586iom.10.1685132328492;
        Fri, 26 May 2023 13:18:48 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5NbeEx+NfDc/UMOu7Pl0K4c7vVOWs5JK9Whd5LODCKEHzWv2DLGvvkKN15/6kMTMira7yHMg==
X-Received: by 2002:a5e:8b4c:0:b0:76c:56fb:3c59 with SMTP id z12-20020a5e8b4c000000b0076c56fb3c59mr1794570iom.10.1685132328108;
        Fri, 26 May 2023 13:18:48 -0700 (PDT)
Received: from redhat.com ([38.15.36.239])
        by smtp.gmail.com with ESMTPSA id s16-20020a02b150000000b0040da7ae3ef9sm1340021jah.100.2023.05.26.13.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 13:18:47 -0700 (PDT)
Date:   Fri, 26 May 2023 14:18:46 -0600
From:   Alex Williamson <alex.williamson@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: [GIT PULL] VFIO fix for v6.4-rc4
Message-ID: <20230526141846.6f549439.alex.williamson@redhat.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Linus,

The following changes since commit 44c026a73be8038f03dbdeef028b642880cf1511:

  Linux 6.4-rc3 (2023-05-21 14:05:48 -0700)

are available in the Git repository at:

  https://github.com/awilliam/linux-vfio.git tags/vfio-v6.4-rc4

for you to fetch changes up to 4752354af71043e6fd72ef5490ed6da39e6cab4a:

  vfio/type1: check pfn valid before converting to struct page (2023-05-23 14:16:29 -0600)

----------------------------------------------------------------
VFIO fix for v6.4-rc4

 - Test for and return error for invalid pfns through the pin pages
   interface. (Yan Zhao)

----------------------------------------------------------------
Yan Zhao (1):
      vfio/type1: check pfn valid before converting to struct page

 drivers/vfio/vfio_iommu_type1.c | 5 +++++
 1 file changed, 5 insertions(+)

