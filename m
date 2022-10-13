Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F185FDB1B
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 15:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJMNkd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 09:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJMNka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 09:40:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05767BC60D
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665668429;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DcJvD5vzFcxsS07jGH2XZzGBqICBqV6Tq7siAWkTRL0=;
        b=Jq4sMnW621b8uqa/ec+FjntrtBflVaMjYrFbwcIu3/jm0/I19ckdfBE/ZFxhNb5o0IJFd/
        ENt1yAM1PFyIzg0W4DBfxNN++428L4BgPMKObG/HcxgDpMm0yoK9C7JVfEvldo+QJ5pKLU
        t4SBwCNIAPkciuFJ1O/XyNBp7EtcOKw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-384-4rgb9fQ1PGyCJ0gWkf7AXQ-1; Thu, 13 Oct 2022 09:40:27 -0400
X-MC-Unique: 4rgb9fQ1PGyCJ0gWkf7AXQ-1
Received: by mail-wm1-f70.google.com with SMTP id 3-20020a05600c020300b003c5eefe54adso842662wmi.9
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DcJvD5vzFcxsS07jGH2XZzGBqICBqV6Tq7siAWkTRL0=;
        b=IlB1aEIOdW0Tc0xTjfhwiBPVw8ZZEBtXEnpkdgaQ7/yLGHzYcYAd3XK2V7C2B0ccNK
         o9BkxltWOE/pniV2j6WNXc3Z4KW2k0hmLnK4qIIk3QG21FqmfoSY86LIIPG0EqMhYCnw
         8F65UW+TozXpzm+9CMhxQ3uSSVr3DlR07nOWx/eV9+jGaYIrHe8VepTOBO9Vi+CWj6Ri
         h0lbEYBPkJtV87bbSanQUW3gZ6pUEElBrgHiIhrmil6GH84eou6ZH/sNgLCBCjm2XfO7
         lDltQuJHcZVs6hTdRI8+D+7idMylfOpcf9mOXXtoTKpkAARzkyQk7USu/gby6imx0ujl
         Z81w==
X-Gm-Message-State: ACrzQf3j7BuVrP7doNypUhB0qsiOyHhILn4Z4DnbJo4T9/00W2Pr1lr1
        9cMQtGt/rknd9C4r909Y24bkO96oSrCqyQ5/vPMhWKmoDcKhdBtpsOt72RjPeW0bYvc+Ls5NRQu
        90xbjoIJSBXLj
X-Received: by 2002:a05:600c:88a:b0:3c5:c9e3:15cc with SMTP id l10-20020a05600c088a00b003c5c9e315ccmr6622898wmp.67.1665668425603;
        Thu, 13 Oct 2022 06:40:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6TnPZr5gSOifctojxkDFUAx5X0RgYRQuKniGc+MNA0UHK/ABnoPNo2kwVXsSINExlzellCjg==
X-Received: by 2002:a05:600c:88a:b0:3c5:c9e3:15cc with SMTP id l10-20020a05600c088a00b003c5c9e315ccmr6622877wmp.67.1665668425410;
        Thu, 13 Oct 2022 06:40:25 -0700 (PDT)
Received: from redhat.com ([2.54.162.123])
        by smtp.gmail.com with ESMTPSA id bl13-20020adfe24d000000b00230b3a0f461sm2065542wrb.33.2022.10.13.06.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 06:40:24 -0700 (PDT)
Date:   Thu, 13 Oct 2022 09:40:21 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        angus.chen@jaguarmicro.com, jasowang@redhat.com,
        lingshan.zhu@intel.com, mpe@ellerman.id.au, mst@redhat.com
Subject: [GIT PULL] virtio: bugfix, reviewer
Message-ID: <20221013094021-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 041bc24d867a2a577a06534d6d25e500b24a01ef:

  Merge tag 'pci-v6.1-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci (2022-10-11 11:08:18 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to be8ddea9e75e65b05837f6d51dc5774b866d0bcf:

  vdpa/ifcvf: add reviewer (2022-10-13 09:37:30 -0400)

----------------------------------------------------------------
virtio: bugfix, reviewer

Fix a regression in virtio pci on power.
Add a reviewer for ifcvf.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Michael S. Tsirkin (2):
      virtio_pci: use irq to detect interrupt support
      vdpa/ifcvf: add reviewer

 MAINTAINERS                        | 4 ++++
 drivers/virtio/virtio_pci_common.c | 4 ++--
 2 files changed, 6 insertions(+), 2 deletions(-)

