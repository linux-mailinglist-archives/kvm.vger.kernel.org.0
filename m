Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8E36365BA
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238344AbiKWQ03 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:26:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236495AbiKWQ0Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:26:25 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24EDD8FB0D
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:26:24 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id w4so8314192plp.1
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:26:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=weyg/EsKhyy4CBiAAMLILYT5ImKwyjrbSu91tLtYZGk=;
        b=ZIJDN0/RCy4xGDYXdthL66Dy9XyzdXzsHB7zbQaiwzyDrljgv/uaiI4EiwDZSc5uX0
         ql8XHIPm3enKzNlvf/UGDt3XCIaZFTmm36Vh5AlOsxKfr+viFVDUbZc3LU9jhdvcdv2S
         RkWstd2BmsYe4pTy12Vw3VyGKlkLaS5ywCG4FvQ6JyeJv2GkwuSUS9l2rhZa+rw6xVaM
         o8mqDb/tcg0T0YfoROaTDJaGo/sDUXx5pBUEskv4+ANvOLtGseoj/vC9+52UVXaKuPXH
         NeI0ys96xZz+obSgd5zDnhmt1RqgRx5Fjnd3mQpcACFRoBDzgpeJ9JOAgCwY+sUIDkbb
         RmAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=weyg/EsKhyy4CBiAAMLILYT5ImKwyjrbSu91tLtYZGk=;
        b=RTqdbEuZ7EYvrorenIqp+hj56/X1O7z3tFEXxVjak6uyTdE9lzfcAk0tIBW3SgdLyV
         B7Q3p8bnVnSLFHjZz1AsbodEjmZeT5zNpdnk3xI6fDRd6Kaw8OIbf/VWYmSipK4rHGU9
         v8S+ck8tyTn6UHaXmsT1x5OHXAT6nFNzH6GugCG47eC8q23bhWLUQ/QXCF+uczMCXh69
         VodEtJqPDlfg/MaHJNUEagB/tTZLjE1zZoJi6bG98sJQEcsbk9PY7krbXSyUbunWC0OZ
         x+WqBklqqWEGFoA/zCL9jAaiQyLbr0tVqGmIHjmjVE8yh2Ta3b5hF9Nl8pjIv5rD2xyx
         bdOQ==
X-Gm-Message-State: ANoB5pmzMLcy3D8HX1TPc2SmONcib1Ke4MEo2lTwzYkzFjk3w5TLaE0n
        7QaOt5iTF3zBYCL+aQHyekRjKZlQB4tq6Q==
X-Google-Smtp-Source: AA0mqf5rWYnouBMjh9anhTPkkA+4m52PkLk68/3APCKrN+ZA8E3mcjEk1jmCHwh4unPLj92M6OnlpA==
X-Received: by 2002:a17:903:1106:b0:189:528b:7a14 with SMTP id n6-20020a170903110600b00189528b7a14mr1444621plh.62.1669220783542;
        Wed, 23 Nov 2022 08:26:23 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x7-20020a170902820700b00186b3c3e2dasm14432484pln.155.2022.11.23.08.26.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 08:26:22 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:26:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Michal Luczaj <mhal@rbox.co>,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] KVM: x86/xen: Only do in-kernel acceleration of
 hypercalls for guest CPL0
Message-ID: <Y35Jq5lYROhGM8MZ@google.com>
References: <20221123002030.92716-1-dwmw2@infradead.org>
 <20221123002030.92716-2-dwmw2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123002030.92716-2-dwmw2@infradead.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 23, 2022, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> There are almost no hypercalls which are valid from CPL > 0, and definitely
> none which are handled by the kernel.
> 
> Fixes: 2fd6df2f2b47 ("KVM: x86/xen: intercept EVTCHNOP_send from guests")
> Reported-by: Michal Luczaj <mhal@rbox.co>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> Cc: stable@kernel.org
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
