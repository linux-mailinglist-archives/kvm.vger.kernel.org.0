Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864A44D826C
	for <lists+kvm@lfdr.de>; Mon, 14 Mar 2022 13:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240235AbiCNMDv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Mar 2022 08:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbiCNMDX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Mar 2022 08:03:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E3484B1F3
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 05:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647259197;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=DTumIzkUVMCDvmMhaJUDyMiG+aNJUlziXvFqILOQYsI=;
        b=Fx8sD/JbdyLzP94A+V1xfdOotmYcIHm5ISvnQ1T6ndEogXzV7TyfCtDPGRf0p6VsegfNy3
        bsIYugzTUMz0IuHNj+aJqTOdh7hc3YIRq0GfcMbMz2X9Lov5XQZX8WQYcB7+3myGY8KD6t
        oMsYqiKDn0QvQOa0h6KBhlk3n/P0HXs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-223-_qAe7gtLPVK0JUqjyLiLDQ-1; Mon, 14 Mar 2022 07:59:55 -0400
X-MC-Unique: _qAe7gtLPVK0JUqjyLiLDQ-1
Received: by mail-wm1-f70.google.com with SMTP id l13-20020a7bcf0d000000b0038982c6bf8fso6925349wmg.7
        for <kvm@vger.kernel.org>; Mon, 14 Mar 2022 04:59:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=DTumIzkUVMCDvmMhaJUDyMiG+aNJUlziXvFqILOQYsI=;
        b=tyIB2xSAaXuzKszdwf+MmPQ4R9ertSDROjyVTViAMUZXuIKhis75l8hQNcWBLBMs6l
         bTnrzWp52Y6k4Kn1PL1k/OAyjo+LUdcEH3EblR0xGgMcbs4cSN8WGiUhKZMSkLFo4vSa
         GMEZ+c+Rx2LNX2bZFbtcgcASaA/vz8b5vGfjzDfRWoeqJZ/ze8e3N8COZp+oGrwSOvWo
         YZmeel/3tA8ttgx+XjqQVtufxfX7jVQU4ACagnWwsDMZyeBwlp9/OVhfgUwQj6fRoPr2
         wuSlSwk4RZ+i+xs2znZzfKeKlbA0DTuXj/m7pPWPcXM7wLrFvgAuqMWB24wlaSWZlrGp
         d1eQ==
X-Gm-Message-State: AOAM5308l7zBMowTVipvW9wBWsVRBDf6r97p41D1akYau7EJxtlEwoqk
        2RsFGlT5Y6360rqEp+mm2oJ+43ihqKh61xPXFr4Rv6TWjOYBuwGlX/hgAbTuw1ZRwmneoUM+5Kg
        91OvOMRKM42oC
X-Received: by 2002:a05:600c:4f09:b0:389:cf43:eaf8 with SMTP id l9-20020a05600c4f0900b00389cf43eaf8mr17160222wmq.201.1647259194497;
        Mon, 14 Mar 2022 04:59:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzp7ZJAVv6i97GoEYXJTrh4j1WEgqWNchpszO38kLqkQtDsjqJCu3h0XIEDXpnWhcBdQ3hpYw==
X-Received: by 2002:a05:600c:4f09:b0:389:cf43:eaf8 with SMTP id l9-20020a05600c4f0900b00389cf43eaf8mr17160208wmq.201.1647259194258;
        Mon, 14 Mar 2022 04:59:54 -0700 (PDT)
Received: from redhat.com ([2.55.183.53])
        by smtp.gmail.com with ESMTPSA id w6-20020a5d6806000000b002036515dda7sm13416882wru.33.2022.03.14.04.59.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 04:59:53 -0700 (PDT)
Date:   Mon, 14 Mar 2022 07:59:51 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        elic@nvidia.com, jasowang@redhat.com, mail@anirudhrb.com,
        mst@redhat.com
Subject: [GIT PULL] virtio: a last minute regression fix
Message-ID: <20220314075951-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 3dd7d135e75cb37c8501ba02977332a2a487dd39:

  tools/virtio: handle fallout from folio work (2022-03-06 06:06:50 -0500)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

for you to fetch changes up to 95932ab2ea07b79cdb33121e2f40ccda9e6a73b5:

  vhost: allow batching hint without size (2022-03-10 08:12:04 -0500)

----------------------------------------------------------------
virtio: a last minute regression fix

I thought we did a lot of testing, but a regression still
managed to sneak in. The fix seems trivial.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

----------------------------------------------------------------
Jason Wang (1):
      vhost: allow batching hint without size

 drivers/vhost/vhost.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

