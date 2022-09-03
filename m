Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1539F5ABBBB
	for <lists+kvm@lfdr.de>; Sat,  3 Sep 2022 02:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbiICAXs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Sep 2022 20:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbiICAXV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Sep 2022 20:23:21 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E82F63DE
        for <kvm@vger.kernel.org>; Fri,  2 Sep 2022 17:23:20 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id v135-20020a63618d000000b00430ac821302so1879872pgb.4
        for <kvm@vger.kernel.org>; Fri, 02 Sep 2022 17:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date;
        bh=tz9XFzkzR4iwpvliIXrKjfw6rH6NLo3IRqdjhrYMVRc=;
        b=MqzieyIBuWuV6MtJvV/l2VvfU+bUyxxlAB2jXhMmb/8OEXHE/+kj8t6rUnbRsdk9ri
         opzJegfNiPb9BGkxITrQtthYkI4vRiNauhc3IG9/xIrOjzpOMvnMUh4eLdEdNuo/nPAo
         oWY9pbgskw8qGdSx09c1oYF41O8eM7zxMj/rlIkZ7w0Hp5hy/fmuqGUAVpmy/GYYIheP
         lFWIP7OXA4391vxIrc0fjwpgX9Q3EULXweFcWP5+okZRt1oyHAtVNmfpINqfxMn4+mO9
         dPEK44vkBrdGE9Q2CQ4AZ/58vBkzhq+za1dpNwuQ6W6QEwtQ2DpIIVJSITzjPssGZK52
         eW/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date;
        bh=tz9XFzkzR4iwpvliIXrKjfw6rH6NLo3IRqdjhrYMVRc=;
        b=lHyBfhY5clVQ5K2hyZiQsMEkzXA3HyhvB3lb89KEd72s1a5ApUIuQLuwS1JPtBQ6zZ
         DohsKRHTajti6N8O4OaiVaiUsgRUIamTBJ89w1HVxxHhxSF4Wtvcpd0DVPoubWk6TgYb
         7KkH/QTwcVLeYzSstTmnAeC2jvOezOCCM/6uznKR3C+a94N7lS/tl7ccQc+Px5zerINl
         iIeyx3PJ1ZsAqhPf47IdyhCIsEoxxW3cRW9OW/itFjYcyirOc+W+jqR2DxMx0WNeNBgG
         UDBvfsM0D3Fkk25ad//hD4vsoc+JDMIe5tjeZ+5huZLyZchpVRDg3oOAFiSXMtwNduup
         U+uw==
X-Gm-Message-State: ACgBeo2G/Idz59Rrxi797RbqO50NhZb2X8qmVYdxw/B3+FqN10T7JAGu
        QlzKXjVPyXgQWOVIX7n27yQHsIW9tBs=
X-Google-Smtp-Source: AA6agR5iW38ydQ1YIgO8Dmri/UpX81zZ5HWPP67gm4Qk2NDFTFy6LgrZ+EPLRZDmpFgE+tKIQxbz9tSCiHs=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d150:b0:1fd:9336:5db3 with SMTP id
 t16-20020a17090ad15000b001fd93365db3mr7469743pjw.242.1662164600066; Fri, 02
 Sep 2022 17:23:20 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Sat,  3 Sep 2022 00:22:43 +0000
In-Reply-To: <20220903002254.2411750-1-seanjc@google.com>
Mime-Version: 1.0
References: <20220903002254.2411750-1-seanjc@google.com>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
Message-ID: <20220903002254.2411750-13-seanjc@google.com>
Subject: [PATCH v2 12/23] KVM: x86: Disable APIC logical map if logical ID
 covers multiple MDAs
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Li RongQing <lirongqing@baidu.com>
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

Disable the optimized APIC logical map if a logical ID covers multiple
MDAs, i.e. if a vCPU has multiple bits set in its ID.  In logical mode,
events match if "ID & MDA != 0", i.e. creating an entry for only the
first bit can cause interrupts to be missed.

Note, creating an entry for every bit is also wrong as KVM would generate
IPIs for every matching bit.  It would be possible to teach KVM to play
nice with this edge case, but it is very much an edge case and probably
not used in any real world OS, i.e. it's not worth optimizing.

Use an impossible value for the "mode" to effectively designate that it's
disabled.  Don't bother adding a dedicated "invalid" value, the mode
handling will be cleaned up in the future and it would take just as much
effort to explain what value is "safe" at this time.

Fixes: 1e08ec4a130e ("KVM: optimize apic interrupt delivery")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 arch/x86/kvm/lapic.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d956cd37908e..6b2f538b8fd0 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -300,8 +300,15 @@ void kvm_recalculate_apic_map(struct kvm *kvm)
 		if (!kvm_apic_map_get_logical_dest(new, ldr, &cluster, &mask))
 			continue;
 
-		if (mask)
-			cluster[ffs(mask) - 1] = apic;
+		if (!mask)
+			continue;
+
+		if (!is_power_of_2(mask)) {
+			new->mode = KVM_APIC_MODE_XAPIC_FLAT |
+				    KVM_APIC_MODE_XAPIC_CLUSTER;
+			continue;
+		}
+		cluster[ffs(mask) - 1] = apic;
 	}
 out:
 	old = rcu_dereference_protected(kvm->arch.apic_map,
-- 
2.37.2.789.g6183377224-goog

