Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC25646665
	for <lists+kvm@lfdr.de>; Thu,  8 Dec 2022 02:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLHBTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Dec 2022 20:19:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiLHBTV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Dec 2022 20:19:21 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C6648DBEF;
        Wed,  7 Dec 2022 17:19:21 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id n9-20020a05600c3b8900b003d0944dba41so2376474wms.4;
        Wed, 07 Dec 2022 17:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=F7aBLr/WPCbhlzqY1hJmfvUDhrJb2eGJyyyPzfEuW20=;
        b=LO2BdsfLlTDkFnX9Xj5fkiZ3SWRLoLJZ0h95C8AfwUJ8qp1CuZbt9eE2I6UNsJx7kc
         +5ZGauRadHGOg2oxisS5UTc+xIO8QKzbRraYgBXReR6wTbFK0WYbTYhCga7c4Ngq6uXi
         sQxIZXMLCLFcigZhRa2g2bfmP4T+Z5drCbCexzMzcyRUjZVX403OYSO3LTJWPBfgAZcU
         6klk5o/gTA8WUi5oDIHeiLWtWPWQqtLNfUB5H+fKXgwPbSYDAOYaHOo1ymbBjMUvN/JX
         n5hp2e59EPtTXimJFpZYfGsNxzOdQZVp6ebX4tlL3sG09xoul79SxjUE0Ho4XRh2/WCi
         faQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=F7aBLr/WPCbhlzqY1hJmfvUDhrJb2eGJyyyPzfEuW20=;
        b=QKsNhRr5fijPhQIboM+4cHcwZHCOg6EtlXuWO8vM/dc2aLDGDd0zcYrg6xoyg40Atw
         Bddlhhw2pR/nzzS9zv1A//D52Mxf6PF/M67WnapIvuHdp1n2+KI8GAFbdE5nszTkh2Yn
         gPfhuuo0Hj5dtRhqJecKzERTju1VlYDtsjx/SOs5B8YM1oNkou4QnYdulyaSJ/AykSjq
         K5yz+IEAaq3uZzcF5MwLzRheBsDKUlgYuLkeDrEPElhrTVd7LTyaSeSz67z1oNWhoJAf
         aRobjwv/NAh9QJAfLNiiGbi/zbbDA68KHfjkPH50F72SuCa737k/+pNnBOccyEcID/o8
         zl4A==
X-Gm-Message-State: ANoB5pmH3wDVoW0mXXetXnOMAsuqXJcgxK/YusvWN+9h7PHUKuzFbwIH
        qtw+6CwOypWbcqXMuEs4CWq3RsM3RNO5ws0iOjzpm58UIAE=
X-Google-Smtp-Source: AA0mqf4DbsF4RH0Ewkt69H/TCQxV9+I0zxyi1ZlWvGczAE+bgBwxUCAFX828O0r8xYXt3zKDgSwntxGlBbSIAJ2jpyQ=
X-Received: by 2002:a05:600c:524c:b0:3d0:8698:4bcc with SMTP id
 fc12-20020a05600c524c00b003d086984bccmr17137435wmb.144.1670462359569; Wed, 07
 Dec 2022 17:19:19 -0800 (PST)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Thu, 8 Dec 2022 09:19:08 +0800
Message-ID: <CAPm50aJTh7optC=gBXfj+1HKVu+9U0165mYH0sjj3Jqgf8Aivg@mail.gmail.com>
Subject: [PATCH] KVM: use unified srcu interface function
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

kvm->irq_routing is protected by kvm->irq_srcu.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 virt/kvm/irqchip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 1e567d1f6d3d..90f54f04e37c 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -216,7 +216,8 @@ int kvm_set_irq_routing(struct kvm *kvm,
        }

        mutex_lock(&kvm->irq_lock);
-       old = rcu_dereference_protected(kvm->irq_routing, 1);
+       old = srcu_dereference_check(kvm->irq_routing, &kvm->irq_srcu,
+                                       lockdep_is_held(&kvm->irq_lock));
        rcu_assign_pointer(kvm->irq_routing, new);
        kvm_irq_routing_update(kvm);
        kvm_arch_irq_routing_update(kvm);
--
2.27.0
