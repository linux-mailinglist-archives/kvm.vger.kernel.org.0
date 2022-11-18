Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE25962FB21
	for <lists+kvm@lfdr.de>; Fri, 18 Nov 2022 18:06:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242449AbiKRRFx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Nov 2022 12:05:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242463AbiKRRF0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Nov 2022 12:05:26 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C95C2790E
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:05:25 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id l14so10244857wrw.2
        for <kvm@vger.kernel.org>; Fri, 18 Nov 2022 09:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4g8TO6/gTLAxbkZZi5J7J9G1gfe/iTz5WXtpYLp8DIc=;
        b=V135qEwn7/XU9SCJzjZQ5L7Pa1ZxVDUE4HXxsI9/UZHJMEgcTlvc9bdgpocvtc01D3
         hKNKBfnCu02ombjhMBuraqyymxfDIIr+V2e+gOxJrh18g2uGpuXyBojQl/KJTfvFcFWc
         i7ZH1Maia90vj90bjUQmAAwdc/p7jPQzL3zKkz4oFQ/cENecZp/WgScrTyN5zNEDW4zT
         aktoY10AH+cMcEo3PIYM/j5DCHFWEzXSeVei9sxsrbBQ7fFsKOLUjr0vvKmpNclo0h9E
         4btLQeKMrdAcXXO2xJ6gA6pFtUx2/GecXuNA3yCaN/QamZSSXQDNFQLv+VNwgqiqFN4H
         yM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4g8TO6/gTLAxbkZZi5J7J9G1gfe/iTz5WXtpYLp8DIc=;
        b=yY/eiisKxjsNaUSglTUQONvnUQjJsxK2JlJmJgz99pNQ233tH2fXYBD8gDWCVg1tS3
         65CrJhyI2lPChQcbuhpQxaR/GhBULDJPutUkfZV247n6u+Qex08m6HwX3ps+KAz4mTeQ
         w6XM1TuXSTM0Ky3jSzrkV3924dBVxelJjx+0CJxvD4FP+ohc+1VM092MKMWE8oHI+F/2
         g4muJ3yudvSYaKcg3t0wtxFuwKif07Wo3st2OjsLJQa60ElHVrV5bpJjtgiiDfT2qkbm
         kaCLwtCF+EYJ84oYxm1fH+1lE7ciDTojN1zJz5lnKesms7sk+ukHz2Ya5re1/xQRaCDk
         HvrQ==
X-Gm-Message-State: ANoB5pku1GH50sfh9aYnGTkIEj2dIhmlAH+vKusFnScw5GJeDS4/y/V9
        7By2MQDgyMFjliolqfcSL/58zs+4zw==
X-Google-Smtp-Source: AA0mqf5Wu7bg4+yp3a65d588H5ONeuWYJSU2t8sOXwORHtuV4/Vfu1GSHwnyPAbtO7tzAGMInHGcHg==
X-Received: by 2002:adf:e4c3:0:b0:236:55fd:600a with SMTP id v3-20020adfe4c3000000b0023655fd600amr4642616wrm.109.1668791124019;
        Fri, 18 Nov 2022 09:05:24 -0800 (PST)
Received: from p183 ([46.53.249.242])
        by smtp.gmail.com with ESMTPSA id j20-20020a5d6e54000000b002416f0f1e96sm4096504wrz.43.2022.11.18.09.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 09:05:23 -0800 (PST)
Date:   Fri, 18 Nov 2022 20:05:21 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     pbonzini@redhat.com
Cc:     kvm@vger.kernel.org
Subject: [PATCH] kvm, vmx: don't use "unsigned long" in vmx_vcpu_enter_exit()
Message-ID: <Y3e7UW0WNV2AZmsZ@p183>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

__vmx_vcpu_run_flags() returns "unsigned int" and uses only 2 bits of it
so using "unsigned long" is very much pointless.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 arch/x86/kvm/vmx/vmx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7067,7 +7067,7 @@ static fastpath_t vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
 
 static noinstr void vmx_vcpu_enter_exit(struct kvm_vcpu *vcpu,
 					struct vcpu_vmx *vmx,
-					unsigned long flags)
+					unsigned int flags)
 {
 	guest_state_enter_irqoff();
 
