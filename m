Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402975FE40E
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 23:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230254AbiJMVPA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 17:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbiJMVOA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 17:14:00 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2AFC193746
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:48 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-3538689fc60so28139617b3.3
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 14:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:from:to:cc:subject:date
         :message-id:reply-to;
        bh=enHjfiPcp49jZxPsRc8NHubzz9PIYIRo2WUSut8GWYc=;
        b=m9qYNDRh5/bP062uaLuPUk974Odr39TMFHkfG791CgVfCCQFLpAymJhNra7RzSQbGe
         vVn/LZa5NpT4Lcsst7qHoK3YygOBe9X/SQ0YYufk1Oj88O7a6YE2Jn4t93mxf9+En6Hn
         Ooymzgxj3dr/q52Ui9GlfLJX01shMRE+sXSkaYIOl6KgZKtkkfwq1cr7KUoA+mCmmSOk
         a54h5+MYyfgkgGaKtfZJTEoqT2P/vF9DjqoNH5UgzwQxXIXNYqJgIbLeVrl7gancOnup
         RubJ/bZM3wPSwZYryJxWEcd3+c19/I4aO5Rae4FCZQpgXCNGXe/N22UwiezQKjSVNkT0
         ZmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:reply-to:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=enHjfiPcp49jZxPsRc8NHubzz9PIYIRo2WUSut8GWYc=;
        b=KOfnT82z3lp72TcowYDdpCh57EPCI0cwjMc4qtm0mVU808mvgQ75QQok9f+6bKs7HJ
         cD5ukvoNzB+eGiBRAS9lMorNaf8nUEZ/MDroYPQ0TYxz/KvGRGqG8W59Ywn2eMljeE6t
         x8Vz+F9+TvZi1OECWdi3FsI22M3zhsKywdLFbfi7QSgQx0qpKA40m0t1kxbXnUC/n1ua
         fZKl6vMA5mAJdRTT635vrK0yOSNAC/4+jzfkxMH3i0XLqnXNLCJobY/W+YTgfJWjBg4R
         rNknu86pNE7ywQOnxZuc8vzeJaUTKlwqSi2gYQHoqtJGVu2wIEzGkGyb+7evywiWcf+k
         e4lQ==
X-Gm-Message-State: ACrzQf3ZqTpzekUDLm9cmSxPKsgFxlVL46QRearXg+ANgWXQglEpNYG6
        xpli3S967wMIgIlIZBb5bWJFOstZUl8=
X-Google-Smtp-Source: AMsMyM5duWlg6Mdq5UFsNT6JDOvbEQtD9HFySACxNL61/Ra+5KFqbIMPVrZhy/aMHGZBAGJDxfZYt10CuIc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:be14:0:b0:6be:885f:20bb with SMTP id
 h20-20020a25be14000000b006be885f20bbmr1768093ybk.480.1665695582404; Thu, 13
 Oct 2022 14:13:02 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Thu, 13 Oct 2022 21:12:32 +0000
In-Reply-To: <20221013211234.1318131-1-seanjc@google.com>
Mime-Version: 1.0
References: <20221013211234.1318131-1-seanjc@google.com>
X-Mailer: git-send-email 2.38.0.413.g74048e4d9e-goog
Message-ID: <20221013211234.1318131-15-seanjc@google.com>
Subject: [PATCH v2 14/16] KVM: Skip unnecessary "unmap" if gpc is already
 valid during refresh
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Luczaj <mhal@rbox.co>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

When refreshing a gfn=3D>pfn cache, skip straight to unlocking if the cache
already valid instead of stuffing the "old" variables to turn the
unmapping outro into a nop.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 virt/kvm/pfncache.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/virt/kvm/pfncache.c b/virt/kvm/pfncache.c
index f211c878788b..57d47f06637d 100644
--- a/virt/kvm/pfncache.c
+++ b/virt/kvm/pfncache.c
@@ -293,9 +293,8 @@ static int __kvm_gpc_refresh(struct gfn_to_pfn_cache *g=
pc, gpa_t gpa)
 		ret =3D hva_to_pfn_retry(gpc);
 	} else {
 		/* If the HVA=E2=86=92PFN mapping was already valid, don't unmap it. */
-		old_pfn =3D KVM_PFN_ERR_FAULT;
-		old_khva =3D NULL;
 		ret =3D 0;
+		goto out_unlock;
 	}
=20
  out:
--=20
2.38.0.413.g74048e4d9e-goog

