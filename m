Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38981609D92
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 11:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbiJXJNN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 05:13:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiJXJNK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 05:13:10 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C32615F123
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m6-20020a17090a5a4600b00212f8dffec9so2969377pji.0
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 02:13:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJoEahVw7AP5Ed1td5Q825LtZBEhqfOy92LmDa7bRBQ=;
        b=Esh7m6HHVSpDva3OT7fIpyHdTO7MRqFE4ELY28gKAaujoPcP4H4VxtRjUjGyloZMyt
         qa/+3TuvcaAy6nlFC498sTvRwqNxv0xeV9l1nIXvG6+7QmPP9+rVYDq7pgnSbviSSNEH
         nZpe3TYh5mwaq4dDDrBhgRJCNADzBhbDDt80pe39G9bYq7xZPkgqmdEeu6g/gaiWR+Rp
         8GDyYQk5YQ+90fjKmSL3iMPZnV+/Jau5pyplejuKD3fI2cuh17UJXLmHagprrPmSaPIj
         r1piR/IUW3wj+yhganLve7bK2pYQviTtkvCkS9lqtaLsl/z0gTzOuI+2HGYJPURGP02L
         CEig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJoEahVw7AP5Ed1td5Q825LtZBEhqfOy92LmDa7bRBQ=;
        b=vpD08Vk641BKoJ+RthcThJDcTuXBrl7Y5XF6uiiPuCEJUl6im1u+fuBUVqlIN0PQdw
         qRHdWiCfW3bIohIWgeqjjErNTiXZISCIB7OvsfD5vayi4b8Xg+zxtZmUBRMiiAIfoizi
         nqgC93YbcQQJlP7tQUUnsROrJKZhjzx2Z3eEa20+EsZe9bXVPMwJk9rPDJY3vdfyoMn+
         Q/KmehuDJgEHrd5wC/Qij7M/w9lWl+XPjmak/fySy+tV5Rm2TqDWzX/DTW6Ezxp9zmYi
         TX9cM5J+CddxYfMWKY6ivCJiUyhgwrlEjmy4BpSbOBCDSY9LiMNpERjoSvF33NFC1NdL
         RUJg==
X-Gm-Message-State: ACrzQf0VhpE92CHlD7GiDjfoxTubQNvAkPhPJqDWAfajFvzB8Y9O72y+
        SxxjCWvsws1w/clHnB3mVDE=
X-Google-Smtp-Source: AMsMyM4yy9/qLIugPTmZnjFHKEEJKWUvCtht+hxUwNJMLPm/0AmVzgwsksHlzHNiFOFlwCG2zdrlCg==
X-Received: by 2002:a17:902:f691:b0:186:b250:9767 with SMTP id l17-20020a170902f69100b00186b2509767mr1583178plg.60.1666602788067;
        Mon, 24 Oct 2022 02:13:08 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id r15-20020aa79ecf000000b00535da15a252sm19642213pfq.165.2022.10.24.02.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 02:13:07 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v4 04/24] x86/pmu: Report SKIP when testing Intel LBR on AMD platforms
Date:   Mon, 24 Oct 2022 17:12:03 +0800
Message-Id: <20221024091223.42631-5-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024091223.42631-1-likexu@tencent.com>
References: <20221024091223.42631-1-likexu@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Like Xu <likexu@tencent.com>

The test conclusion of running Intel LBR on AMD platforms
should not be PASS, but SKIP, fix it.

Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
---
 x86/pmu_lbr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/x86/pmu_lbr.c b/x86/pmu_lbr.c
index c040b14..a641d79 100644
--- a/x86/pmu_lbr.c
+++ b/x86/pmu_lbr.c
@@ -59,7 +59,7 @@ int main(int ac, char **av)
 
 	if (!is_intel()) {
 		report_skip("PMU_LBR test is for intel CPU's only");
-		return 0;
+		return report_summary();
 	}
 
 	if (!this_cpu_has_pmu()) {
-- 
2.38.1

