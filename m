Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC0F6F7CE4
	for <lists+kvm@lfdr.de>; Fri,  5 May 2023 08:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbjEEGYP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 5 May 2023 02:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjEEGYO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 5 May 2023 02:24:14 -0400
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [63.216.63.35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B8E611DB8;
        Thu,  4 May 2023 23:24:13 -0700 (PDT)
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mxhk.zte.com.cn (FangMail) with ESMTPS id 4QCLHc25Zrz5B151;
        Fri,  5 May 2023 14:24:12 +0800 (CST)
Received: from xaxapp03.zte.com.cn ([10.88.97.17])
        by mse-fl1.zte.com.cn with SMTP id 3456O2KS076877;
        Fri, 5 May 2023 14:24:02 +0800 (+08)
        (envelope-from ye.xingchen@zte.com.cn)
Received: from mapi (xaxapp02[null])
        by mapi (Zmail) with MAPI id mid31;
        Fri, 5 May 2023 14:24:04 +0800 (CST)
Date:   Fri, 5 May 2023 14:24:04 +0800 (CST)
X-Zmail-TransId: 2afa6454a104693-a3eab
X-Mailer: Zmail v1.0
Message-ID: <202305051424047152799@zte.com.cn>
Mime-Version: 1.0
From:   <ye.xingchen@zte.com.cn>
To:     <mst@redhat.com>
Cc:     <jasowang@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1BBVENIXSB2aG9zdF9uZXQ6IFVzZSBmZGdldCgpIGFuZCBmZHB1dCgp?=
Content-Type: text/plain;
        charset="UTF-8"
X-MAIL: mse-fl1.zte.com.cn 3456O2KS076877
X-Fangmail-Gw-Spam-Type: 0
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6454A10C.000/4QCLHc25Zrz5B151
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Ye Xingchen <ye.xingchen@zte.com.cn>

convert the fget()/fput() uses to fdget()/fdput().

Signed-off-by: Ye Xingchen <ye.xingchen@zte.com.cn>
---
 drivers/vhost/net.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index ae2273196b0c..5b3fe4805182 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -1466,17 +1466,17 @@ static struct ptr_ring *get_tap_ptr_ring(struct file *file)

 static struct socket *get_tap_socket(int fd)
 {
-	struct file *file = fget(fd);
+	struct fd f = fdget(fd);
 	struct socket *sock;

-	if (!file)
+	if (!f.file)
 		return ERR_PTR(-EBADF);
-	sock = tun_get_socket(file);
+	sock = tun_get_socket(f.file);
 	if (!IS_ERR(sock))
 		return sock;
-	sock = tap_get_socket(file);
+	sock = tap_get_socket(f.file);
 	if (IS_ERR(sock))
-		fput(file);
+		fdput(f);
 	return sock;
 }

-- 
2.25.1
