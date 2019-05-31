Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 42A3C31597
	for <lists+kvm@lfdr.de>; Fri, 31 May 2019 21:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfEaTsj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 31 May 2019 15:48:39 -0400
Received: from gateway33.websitewelcome.com ([192.185.145.190]:20123 "EHLO
        gateway33.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726808AbfEaTsj (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 31 May 2019 15:48:39 -0400
X-Greylist: delayed 1415 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 May 2019 15:48:39 EDT
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway33.websitewelcome.com (Postfix) with ESMTP id 3A47917DD3
        for <kvm@vger.kernel.org>; Fri, 31 May 2019 14:25:04 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id Wn9EhpyQH2qH7Wn9Eh3Jnq; Fri, 31 May 2019 14:25:04 -0500
X-Authority-Reason: nr=8
Received: from [189.250.123.250] (port=52648 helo=embeddedor)
        by gator4166.hostgator.com with esmtpa (Exim 4.91)
        (envelope-from <gustavo@embeddedor.com>)
        id 1hWn93-003OqT-R2; Fri, 31 May 2019 14:25:02 -0500
Date:   Fri, 31 May 2019 14:24:53 -0500
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] KVM: irqchip: Use struct_size() in kzalloc()
Message-ID: <20190531192453.GA13536@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 189.250.123.250
X-Source-L: No
X-Exim-ID: 1hWn93-003OqT-R2
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: (embeddedor) [189.250.123.250]:52648
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 3
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
   int stuff;
   struct boo entry[];
};

instance = kzalloc(sizeof(struct foo) + count * sizeof(struct boo), GFP_KERNEL);

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

instance = kzalloc(struct_size(instance, entry, count), GFP_KERNEL);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 virt/kvm/irqchip.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 79e59e4fa3dc..f8be6a3d1aa6 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -196,9 +196,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
 
 	nr_rt_entries += 1;
 
-	new = kzalloc(sizeof(*new) + (nr_rt_entries * sizeof(struct hlist_head)),
-		      GFP_KERNEL_ACCOUNT);
-
+	new = kzalloc(struct_size(new, map, nr_rt_entries), GFP_KERNEL_ACCOUNT);
 	if (!new)
 		return -ENOMEM;
 
-- 
2.21.0

