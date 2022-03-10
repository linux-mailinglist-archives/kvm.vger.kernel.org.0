Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 777844D475C
	for <lists+kvm@lfdr.de>; Thu, 10 Mar 2022 13:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242153AbiCJMzj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Mar 2022 07:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235875AbiCJMzi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Mar 2022 07:55:38 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F811149966
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:54:38 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id b11-20020a5b008b000000b00624ea481d55so4288991ybp.19
        for <kvm@vger.kernel.org>; Thu, 10 Mar 2022 04:54:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=QFfgLXJhqBm93FW4BOZINlHMaPvbnDecnqY4uI8RKSg=;
        b=RZ3QQZ/186R8U9G5itLDtEHiU7d4t81K0ItKzVDX0y+84Afe/lvYEavh4JMkpsq0Pj
         MGrmJia9d5Hn8+15wimH8HNOj+vo/btfZeBvxnQd+7ZlMbQaIEdI49Zm38rnIQxV7Amm
         upK3N5WcW2YclB7QhqvfLQOBXsHdZW8rliVVHRq272AAqSgFRrYMXqu464GupIXFoaud
         ZrVBUhCFLrUmGUOqq5RGG7kBLbK7FiO8rhHOE5qnABiCmJjZPXzbcvjG2O8Lt5Y7ZYJo
         t+oa9eSSjo32d2InN5b1nZDKgAn8UEzANizvciQfmzT7n9S3UxT2bgCM15GDCylB7gy8
         nq7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=QFfgLXJhqBm93FW4BOZINlHMaPvbnDecnqY4uI8RKSg=;
        b=Rs+6ASxS2W0G1dDdqD1SeGlwA0MdBS+E+AHoX4ETPsE5E4H7LlFyASeFB7pdZp9L6D
         mu6OX0tgzbiDh4eLg/p37Noq5Vex/65+S1xksvZPvaEtJi1mV3WtGelSaHrFH9YSpEhj
         Q+xGBJei9xCoLLGm5MBsUV4iHk7Gef2Mw1rgyWelyiQi66MpaD3fMZx/rgMlXuYuVOSC
         9Li2lCP4tQoO+OZPQwCpjpjSufBiYb4VBRIElOW22OXwNCaXn6m7X9bt+UcMCFi8HP9g
         syJ/h+9A/WC97EoneQ5G+gp2/p2Wmqx2+e+UMNnpSTtvvMkS1CTb9Bx5wZbwNZDJQAXn
         dFMw==
X-Gm-Message-State: AOAM533ODLtNU8cnnPtN8qiMpfaEtJpeKuzRbwB24hW1+7scIZAzgvDa
        hyJVj6UGOScpKkK64jFocpcubruzi8Y=
X-Google-Smtp-Source: ABdhPJx/rSQ+zjWC4nLCH2ehjxhO7WcwHLm+7eF8P5OaTA6K8T1BPWGGc4emsV1ZVN5gPLriDFwzjAfPwX4=
X-Received: from jiyong.seo.corp.google.com ([2401:fa00:d:11:f59e:134:eb7:e1d2])
 (user=jiyong job=sendgmr) by 2002:a25:73ca:0:b0:628:a41f:bd40 with SMTP id
 o193-20020a2573ca000000b00628a41fbd40mr3605762ybc.316.1646916877411; Thu, 10
 Mar 2022 04:54:37 -0800 (PST)
Date:   Thu, 10 Mar 2022 21:54:23 +0900
Message-Id: <20220310125425.4193879-1-jiyong@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH 0/2] vsock: cycle only on its own socket
From:   Jiyong Park <jiyong@google.com>
To:     sgarzare@redhat.com, stefanha@redhat.com, mst@redhat.com,
        jasowang@redhat.com, davem@davemloft.net, kuba@kernel.org
Cc:     adelva@google.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiyong Park <jiyong@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Stefano,

As suggested [1], I've made two patches for easier backporting without
breaking KMI.

PATCH 1 fixes the very issue of cycling all vsocks regardless of the
transport and shall be backported.

PATCH 2 is a refactor of PATCH 1 that forces the filtering to all
(including future) uses of vsock_for_each_connected_socket.

Thanks,

[1] https://lore.kernel.org/lkml/20220310110036.fgy323c4hvk3mziq@sgarzare-redhat/

Jiyong Park (2):
  vsock: each transport cycles only on its own sockets
  vsock: refactor vsock_for_each_connected_socket

 drivers/vhost/vsock.c            | 3 ++-
 include/net/af_vsock.h           | 3 ++-
 net/vmw_vsock/af_vsock.c         | 9 +++++++--
 net/vmw_vsock/virtio_transport.c | 7 +++++--
 net/vmw_vsock/vmci_transport.c   | 3 ++-
 5 files changed, 18 insertions(+), 7 deletions(-)


base-commit: 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
-- 
2.35.1.723.g4982287a31-goog

