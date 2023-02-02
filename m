Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A167868839E
	for <lists+kvm@lfdr.de>; Thu,  2 Feb 2023 17:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjBBQD2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Feb 2023 11:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232165AbjBBQD0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Feb 2023 11:03:26 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C3143C2B0
        for <kvm@vger.kernel.org>; Thu,  2 Feb 2023 08:03:19 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id o13so2351020pjg.2
        for <kvm@vger.kernel.org>; Thu, 02 Feb 2023 08:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CnTJJs+O/feHF+dtKsJMe8sGkEuF3IoD/Hd0PvzGTMk=;
        b=ntILpNHieOlE1eQKlkEswLTzNxqODvW4UIylIlF6hRS4jdzdpSLvn5nG5RoRgG5Bgq
         7dtxWITAVyjEVlmVQEt+iwH5zHcmfrsV4Mbfgcv6+8WIcYe3lyUI/lCYgCEbPbobufSg
         tlsMycMU1nsX+x/tnC/hgF7+7XRGmF/xIPhf2SbzUu7YzpbCIJdC91xHSfrT+IGiyNSw
         WnWs3CV2L1WfkgW0hE2JjG2CjOibBcKNyyjTJCxc0PXFNA0WhsENL27S+uPlTUnuVy7d
         6uEmdPwBOPvmmKVh9UQK1XtRrbudvo6yxsVfABu1Etqug+ce3HqVqlaFHfGrMqudkjYk
         ARpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CnTJJs+O/feHF+dtKsJMe8sGkEuF3IoD/Hd0PvzGTMk=;
        b=dFqYMZwFt2WBCPHd6tXEvUPDaOTHE7iZS5JKFpOZLPhGI4G3hn81fkFQeURmxIaAFe
         EltfJs5vDOAF6NW4jzHqcCzNx7t1DjnfZeP85gzY6a9lmvuvNs2p5vrS+8TxiBslT3C7
         ghoD+GyyACNddCN2wvdzFVuroyz1kvSIayAEEpt2B9KOA3FI6HDNLWHQYWTJswe7QUpR
         f7+rpguhTjPgxWMwigsBPM4ULhVWQW9B8CMiAHmLeMsono0ImlqWpwj1jYJ1EG4SNTzK
         lUp36eyx5Bk89cEB2Npy1Cvphif10HRlS6ZlMBb9DikBpiU7jFhpyoYXhz3mw0zOogwQ
         xVrQ==
X-Gm-Message-State: AO0yUKVzATjxEuXN8kGESRGIT7GPfdsyn1xe95a7Bse3AcbXB2x5E0CO
        am4q8nTiIAf0G5qV5JzSHfaexA==
X-Google-Smtp-Source: AK7set/Di2re5uFl+ne06GLzugwEpNOWcHIFlsRKD8jsMY/VPWb1pFEIyTdJ5++rLnhtQtcIzFRFxQ==
X-Received: by 2002:a17:902:7795:b0:191:4367:7fde with SMTP id o21-20020a170902779500b0019143677fdemr323109pll.0.1675353799009;
        Thu, 02 Feb 2023 08:03:19 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id d2-20020a170903230200b00189c4b8ca21sm13923789plh.18.2023.02.02.08.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 08:03:18 -0800 (PST)
Date:   Thu, 2 Feb 2023 16:03:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, mlevitsk@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: SVM: fix calculate dest mask incorrectly in x2apic
 mode.
Message-ID: <Y9vewvcdjKkaFS87@google.com>
References: <1675328830-37483-1-git-send-email-yuanzhaoxiong@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1675328830-37483-1-git-send-email-yuanzhaoxiong@baidu.com>
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

On Thu, Feb 02, 2023, Yuan ZhaoXiong wrote:
> ICRH bits 31:16 is cluster id and bits 15:0 is dest mask when x2apic is
> enabled.
> 
> Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
> 
> Signed-off-by: Yuan ZhaoXiong <yuanzhaoxiong@baidu.com>
> ---
>  arch/x86/kvm/svm/avic.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6919dee..03b1e27 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -378,7 +378,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  
>  		if (apic_x2apic_mode(source)) {
>  			/* 16 bit dest mask, 16 bit cluster id */
> -			bitmap = dest & 0xFFFF0000;
> +			bitmap = dest & 0xFFFF;

Already fixed in the Paolo's tree, commit da3fb46d226a ("KVM: SVM: Fix x2APIC
Logical ID calculation for avic_kick_target_vcpus_fast").

In case you have more APIC/AVIC related fixes/bugs, a big pile of fixes are queued
for 6.3, see commit f15a87c00690 ("Merge branch 'kvm-lapic-fix-and-cleanup' into HEAD").

Thanks!
