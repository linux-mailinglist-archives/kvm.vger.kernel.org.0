Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50A156279B5
	for <lists+kvm@lfdr.de>; Mon, 14 Nov 2022 10:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236896AbiKNJ5t (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Nov 2022 04:57:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236966AbiKNJ5L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 14 Nov 2022 04:57:11 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A91C31F2F7;
        Mon, 14 Nov 2022 01:56:44 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id l6so9897596pjj.0;
        Mon, 14 Nov 2022 01:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pBtZZOL+325kqQMxoFTyaL/a2aOjAFcbc7WVXFwsces=;
        b=Siw+4L71eXfC/fT+8IWelVZQPojdafaVztZTv+RK3oQb2PqaQAV+M99p13z1zD7uS7
         vpoy+ZWQez65aP1x+ua+hpXCFfyRZQoUPuMCzzjLL2By8nSbNkOlEJmxCZdhYe5iBNlN
         C2BlpLOCzi8RoaAfG89p2GkubSklI9GXcSDeECR9BmXlS6GSOik8/MTPP4WlzMU+Jxst
         VED7583xm8K0HYU6krwZEDcRHGUkbGgjg1Ej7XWeytMX/pqNUIXEoiLMwYIwcFBlqSwv
         RF6BDxiyvgF3aC5Hs93KY5vrLNLmliG+tfZjoLwuIT+BrI9C9vzz0Uc9fC7X60KcXjud
         eC+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pBtZZOL+325kqQMxoFTyaL/a2aOjAFcbc7WVXFwsces=;
        b=r1G+QJFCLSE39z0/+sEOmdEW7OgKCeX397fwzEXjbQEYYKisEitQcgclKo9f8MJjdN
         a/Cl5WeZDYxgoMK0qCcWJ+2QU0lQTAg7ffutX/lmud9ltySpfouXocDHmA/TiUDBKK2Z
         u9EpH9cJbtNj8uHQj0YIcXDf1/7NZlUVeUB5Om3O8WAkgojqP8O+TfHIJnQlXdBZ/SQ4
         lFTB+YXzIiMd4fwMvdHQ2JtisE7bCfMoWBGEJHfkhbQCbEgvJmZ3d2Ub9FSmfepEuMY4
         PYMkDk+bhpF1zg/jP1VYIfqWNV2o0wLjJtg4zCeVqzAarbN3O2D9Y7Nb0g3UHOKO/AgV
         ZuJQ==
X-Gm-Message-State: ANoB5pk/xEpKz9oz7+iA9Xha+BJMJRozqhCNEpJ777AeSKTg5kmhQmii
        P8jgAhc22V1G9OkIAUi3QDM=
X-Google-Smtp-Source: AA0mqf7u4Xe3gQ/Qk3wsjc0KoZ2K7vSje7ttQiub4iRj0UK6DBJ0V7Nzr2VtisPHklSbtOYp7s6cuQ==
X-Received: by 2002:a17:90b:2290:b0:212:dadc:23e3 with SMTP id kx16-20020a17090b229000b00212dadc23e3mr13059031pjb.129.1668419804238;
        Mon, 14 Nov 2022 01:56:44 -0800 (PST)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d29-20020aa797bd000000b0056c6e59fb69sm6266472pfq.83.2022.11.14.01.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 01:56:43 -0800 (PST)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 07/14] KVM: x86: Remove unnecessary export of kvm_require_cpl()
Date:   Mon, 14 Nov 2022 17:55:59 +0800
Message-Id: <20221114095606.39785-8-likexu@tencent.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114095606.39785-1-likexu@tencent.com>
References: <20221114095606.39785-1-likexu@tencent.com>
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

Don't export x86's kvm_require_cpl(), the helper isn't used by
KVM x86's vendor modules.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 arch/x86/kvm/x86.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index c03e599166b8..ee63b5ab507d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -826,7 +826,6 @@ bool kvm_require_cpl(struct kvm_vcpu *vcpu, int required_cpl)
 	kvm_queue_exception_e(vcpu, GP_VECTOR, 0);
 	return false;
 }
-EXPORT_SYMBOL_GPL(kvm_require_cpl);
 
 bool kvm_require_dr(struct kvm_vcpu *vcpu, int dr)
 {
-- 
2.38.1

