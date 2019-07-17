Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8A616BC09
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2019 13:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfGQL7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jul 2019 07:59:20 -0400
Received: from smtpbgeu1.qq.com ([52.59.177.22]:44123 "EHLO smtpbgeu1.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726273AbfGQL7U (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jul 2019 07:59:20 -0400
X-QQ-mid: bizesmtp18t1563364750t5mn80un
Received: from localhost.localdomain (unknown [218.76.23.26])
        by esmtp6.qq.com (ESMTP) with 
        id ; Wed, 17 Jul 2019 19:59:06 +0800 (CST)
X-QQ-SSF: 01400000002000E0JG32000A0000000
X-QQ-FEAT: A0aGqOzntPfW16zXB8MbibpT0O1Ilp7BQ70n2aSXZeIs63SsV6oekGxpSjW5P
        lrTwC4gbDd5nIJ81nzkZiWDqJSOlfhgpFm2yGdyJV0BPcbW/Hl0MCcWX+Mxr0eNDfPp7q1A
        +OjIPV9os5oVYaxjux2oyI3wn8gY8LLzghP5OpHZsHliBH9Uzzg5cXszxSg5yDSwT42J3yt
        n6Z+p8nwsk+xL2ozQ12tcAjwErZlXyKIpc79N6AzJnqY1wXof2NLSnv7/VWkhc3yNnmJOIG
        mKOmUv1V4EXfvCF8i7Ahbf1cNcdm2V4DYmXbvFDlgIqzPEhel42GP8gZwfNFcWqBeyOg==
X-QQ-GoodBg: 2
From:   huhai <huhai@kylinos.cn>
To:     mst@redhat.com, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, huhai <huhai@kylinos.cn>
Subject: [PATCH] vhost_net: fix missing descriptor recovery
Date:   Wed, 17 Jul 2019 19:58:34 +0800
Message-Id: <20190717115834.25988-1-huhai@kylinos.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:kylinos.cn:qybgforeign:qybgforeign2
X-QQ-Bgrelay: 1
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When get_tx_bufs get descriptor successful, but this descriptor have
some problem, we should inform the guest to recycle this descriptor,
instead of doing nothing.

Signed-off-by: huhai <huhai@kylinos.cn>
---
 drivers/vhost/net.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 247e5585af5d..939a2ef9c223 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -620,6 +620,7 @@ static int get_tx_bufs(struct vhost_net *net,
 	if (*in) {
 		vq_err(vq, "Unexpected descriptor format for TX: out %d, int %d\n",
 			*out, *in);
+		vhost_add_used_and_signal(&net->dev, vq, ret, 0);
 		return -EFAULT;
 	}
 
@@ -628,6 +629,7 @@ static int get_tx_bufs(struct vhost_net *net,
 	if (*len == 0) {
 		vq_err(vq, "Unexpected header len for TX: %zd expected %zd\n",
 			*len, nvq->vhost_hlen);
+		vhost_add_used_and_signal(&net->dev, vq, ret, 0);
 		return -EFAULT;
 	}
 
-- 
2.20.1



