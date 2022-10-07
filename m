Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 426D55F7C83
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 19:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbiJGRzA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 13:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJGRy6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 13:54:58 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B5E1A807
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 10:54:54 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id p3-20020a17090a284300b0020a85fa3ffcso7872630pjf.2
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 10:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VnPKWiaIaNbR7dhDVcU6qlmiAS7Igg2kXw9XPoCpyTc=;
        b=cvom3e9GZLpahXO6IOBOlD1Xj69jfTwVMwOwauXM/donwcMQXH/Mu2bxyIG8AjkqrQ
         MmyoPh1ABUWCljc8yj8CP6EpRJWVSaNgPqCY32O4OmXqUozU/lxKY2d9664ylk4DnuKT
         rW2DdTcxcA4VfTEtg03x8jNJE0UJTVvRaYvRJ6ItFoxg2EBeCyM2EyJi3uDsAzofGV0+
         uqCxTPUx1lwMxROWhI0HbgCwI3t7i5c1oPz0HoYhk5QGK5+WD23GKqN55OVV0Yo8h8Vx
         J/hMZmnuBqVLP6qSWS6yA3hLSEo+rG4egi038OqICAzrvlgECG3zBvSHQFsp7dhCEizP
         lOag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VnPKWiaIaNbR7dhDVcU6qlmiAS7Igg2kXw9XPoCpyTc=;
        b=nzl/FbDjfUipXh7XP5ZQcrVf2qzmpJ0oU2Fd9PfLP0Muo1HaSbpAASk+VaU3W5Z5Vj
         zzDPnHVEN5m2WyThIb9INaSiCPQOMxdq3pFXf9pcnWVICPIabfLb+b08dj6semUHMt21
         1pNR8OF4xb2h8pGA2TPtc3Iu9M9aShocsNBWh7/2bejIalKA+IikU8rdvaJrVK591KRa
         klVEdMCAIMwSh+ZTNTWTa2JmVTnIpYq3wVDZ8clpyfJB17xlDx08IBnrSD1rkqK1A0YN
         7NoQKFxBrWn36gQD0OfHfCysK3pd5m+vuKxRdSVmWDXkNdMcMl3ey/2hn0yImHzebVoc
         3/rQ==
X-Gm-Message-State: ACrzQf2pZqo0RrLZgumY2k5cjawJEycA99HswvY0LChS0RSvAy2oA6Y2
        eMcJaV6fY6c+peZ6elmKH1/evw==
X-Google-Smtp-Source: AMsMyM5yIb2e18dWqUSylHHcKF6T0JBTABqqgv+gtU8+1C06UnST0w/x4/FpLU2P0CfQuK9iYpS6zQ==
X-Received: by 2002:a17:902:db12:b0:176:d6a4:53ab with SMTP id m18-20020a170902db1200b00176d6a453abmr6374936plx.113.1665165293587;
        Fri, 07 Oct 2022 10:54:53 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h11-20020a17090a130b00b00208c58d5a0esm4923902pja.40.2022.10.07.10.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 10:54:53 -0700 (PDT)
Date:   Fri, 7 Oct 2022 17:54:49 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     =?utf-8?B?Zmx5aW5ncGVuZyjlva3mtakp?= <flyingpeng@tencent.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH]  kvm: vmx: keep constant definition format consistent
Message-ID: <Y0Bn6SSFcwGt2II0@google.com>
References: <E2C645A3-8160-41A7-A8D3-F605946DFEF2@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <E2C645A3-8160-41A7-A8D3-F605946DFEF2@tencent.com>
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

On Tue, Sep 20, 2022, flyingpeng(彭浩) wrote:
> Keep all constants using lowercase "x".
> 
> Signed-off-by: Peng Hao <flyingpeng@tencent.com>
> ---
>  arch/x86/include/asm/vmx.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/vmx.h b/arch/x86/include/asm/vmx.h
> index 0ffaa3156a4e..d1791b612170 100644
> --- a/arch/x86/include/asm/vmx.h
> +++ b/arch/x86/include/asm/vmx.h
> @@ -296,7 +296,7 @@ enum vmcs_field {
>         GUEST_LDTR_AR_BYTES             = 0x00004820,
>         GUEST_TR_AR_BYTES               = 0x00004822,
>         GUEST_INTERRUPTIBILITY_INFO     = 0x00004824,
> -       GUEST_ACTIVITY_STATE            = 0X00004826,
> +       GUEST_ACTIVITY_STATE            = 0x00004826,

Heh, I'm somewhat surprised clang didn't throw an error on this.

Reviewed-by: Sean Christopherson <seanjc@google.com>
