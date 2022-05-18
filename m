Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F2B52C03C
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240319AbiERQdP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 12:33:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbiERQdN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 12:33:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2422C18DAE3
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652891589;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=6BW+tomAtB+5qk/t/SKeP6VB//NGldp/mpIoLmV3bKM=;
        b=WOepCd9pQK4U8McLcvFf/IQUeh4XaFVGD3w0LnLxjtChigIWuVYDhsCJ752XQn3aI+amEt
        pnIJ+QbAZsH/DE3405c274Xsl7Wz0Bgu7U/+Ck40jJGpaaSsDmBfIq1EJ16OnnGZMawM20
        FShGTCDisWHhuiYOMEBkflU/DRjUp+c=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-91-9qrMfAqINCuTyUnfWZeGFw-1; Wed, 18 May 2022 12:33:08 -0400
X-MC-Unique: 9qrMfAqINCuTyUnfWZeGFw-1
Received: by mail-wm1-f70.google.com with SMTP id c62-20020a1c3541000000b0038ec265155fso3117970wma.6
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 09:33:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=6BW+tomAtB+5qk/t/SKeP6VB//NGldp/mpIoLmV3bKM=;
        b=aaENkM8P9moIT04GS5ZERXrtVt8NQfnuiMIUyEnfjBWkb59ccTQHcUikYJfcLjJF32
         47NDC02qh7wtkaMffaqQTWRuWHHsl2/YIapGaItDZkW32LXI/+JC6Pip75NwAxTRDENg
         MWNKPIdLtVbD/ccd1KKNZc7k0VfqNdOdVAgRakJBogCYURQOOBbp7niTQ0Rok1jlFLGU
         SvcoOKpMZgSit2RCJXjOUpaTPSd/DqWH15pxQ5hBmAOAKQJ0ExgCVOD5tvRB2V204z03
         jAUNwoXQ8UgBagbOBUnF62Xb2dF0wQLMbxR65hSGKpqmZeuGed9BBIARz8YD3FHITZ5x
         tcaQ==
X-Gm-Message-State: AOAM530YkUeM+dxJWMt6yG1UDPsDaou/8aOZu9AirG3wx/aN7mbcL53+
        eAKhNWTBr8w/06fap2OmlKiDs4nGe1ZdTbji4NX7fVUivKTu6ovNQcseHMCyyNim4NCcXmjD6K4
        Ak7WzYsNbO64K
X-Received: by 2002:a05:6000:1688:b0:20d:a533:fc5 with SMTP id y8-20020a056000168800b0020da5330fc5mr459071wrd.338.1652891586808;
        Wed, 18 May 2022 09:33:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyfNEmIPPO7ty/Qr0Slw7Q7GYnij8heyI7qsewEV2V5kqhFnMGnfmQUh+NwrkEXhVzH3oNxug==
X-Received: by 2002:a05:6000:1688:b0:20d:a533:fc5 with SMTP id y8-20020a056000168800b0020da5330fc5mr459036wrd.338.1652891586395;
        Wed, 18 May 2022 09:33:06 -0700 (PDT)
Received: from redhat.com ([151.81.230.224])
        by smtp.gmail.com with ESMTPSA id x10-20020a7bc20a000000b003942a244ebesm2121054wmi.3.2022.05.18.09.33.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 09:33:06 -0700 (PDT)
Date:   Wed, 18 May 2022 12:33:04 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mst@redhat.com
Subject: [GIT PULL] mlx5: last minute fixup
Message-ID: <20220518123304-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 42226c989789d8da4af1de0c31070c96726d990c:

  Linux 5.18-rc7 (2022-05-15 18:08:58 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to acde3929492bcb9ceb0df1270230c422b1013798:

  vdpa/mlx5: Use consistent RQT size (2022-05-18 12:31:31 -0400)

----------------------------------------------------------------
mlx5: last minute fixup

The patch has been on list for a while but as it was posted as part of a
thread it was missed.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Eli Cohen (1):
      vdpa/mlx5: Use consistent RQT size

 drivers/vdpa/mlx5/net/mlx5_vnet.c | 61 ++++++++++++++-------------------------
 1 file changed, 21 insertions(+), 40 deletions(-)

