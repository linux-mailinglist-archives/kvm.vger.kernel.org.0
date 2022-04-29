Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F9C514C5D
	for <lists+kvm@lfdr.de>; Fri, 29 Apr 2022 16:07:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376571AbiD2OKW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 Apr 2022 10:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377078AbiD2OKB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 Apr 2022 10:10:01 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1555FD17E0
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:03:28 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id x12so6602116pgj.7
        for <kvm@vger.kernel.org>; Fri, 29 Apr 2022 07:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i1D89wm0y1+2ttrMK4C0YhPCHvNZx6BJRyJ0Ab+onwc=;
        b=D3fiCVWDjVYH74rFcWDw6TSzScyaNn/YLsOnwQycGvlmYWofvSA2dsoLXEW1ZDUKy3
         orSzO6DhlU1lDaoDsOUcjge2e1Xjvlm0soP4F/2EEnMeIG+41OqgpsnysM6kvWmqgMxA
         jcd6gM6W8GrQszvjKzjfkrgA0qhDIdNfP99Xv3Cfv/Pfy4amXgo6E1YYY8mvMkTTLNkf
         c0HdIi7N5do2+JqD7R/fI3JB5lhEvyoeOuTj6e21BdecHaZTWgh0Nc+SkiAR/heUysqE
         CNafI8FTuXztT7EqWFDUW3gPUnNX4hpGXsXeI8UVQQI6uftadfP5oOwPSvnxwIzUImrv
         x6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i1D89wm0y1+2ttrMK4C0YhPCHvNZx6BJRyJ0Ab+onwc=;
        b=XqCbDpNU6mYk2cwM806JsSIKc/liVUsi7poRBPBA90HzW53C2DoYV43hJsxWDe0kUo
         yIyjKH0KroXyg9/IigDcEBSy9TMZRaI0MISzNo5QmBXcRTyfIpjHqSWpWbAP2JdDTEwe
         JfAnpNbD8/tMTlhjz41zNqJpFN6E+CsUHCcUvVxsEX3a5twcVgBTpymLgNntwOzODdG3
         5QSTA4Vpd8P/vwbfKuvFXpiowXFJRz6B5k4dKdN0rSlbZl0drcpWwy3ifCgymniMKlAE
         xWgstz88Jq/EuE0J70t/HNOlYKW1GWKfrwXfKL7UhaF4Iq7P43AxOJPB7b2m6fbABltq
         Frog==
X-Gm-Message-State: AOAM532/YkAQWMuhjMqg+qAHL+cmwTVXAi+pU34I3CGTT4D5jyii88ii
        crUpwIXN5iRp7v5MZLDP5y96yQ==
X-Google-Smtp-Source: ABdhPJwgyDUF45ewN3iHEmvtIwn2Ru736PHK8amVA2azQ5KwegekVLqd9QJh16tj1X3JePKGpJTVvQ==
X-Received: by 2002:a65:6b92:0:b0:39c:c97b:1b57 with SMTP id d18-20020a656b92000000b0039cc97b1b57mr33367430pgw.517.1651241007311;
        Fri, 29 Apr 2022 07:03:27 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j6-20020a632306000000b003c14af50615sm6514095pgj.45.2022.04.29.07.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 07:03:26 -0700 (PDT)
Date:   Fri, 29 Apr 2022 14:03:23 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Peter Gonda <pgonda@google.com>
Subject: Re: [PATCH for-5.18] KVM: fix bad user ABI for KVM_EXIT_SYSTEM_EVENT
Message-ID: <YmvwK0MeKpsQkZN4@google.com>
References: <20220422103013.34832-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220422103013.34832-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Apr 22, 2022, Paolo Bonzini wrote:
> For compatibility with userspace that was using the flags field,
> a union overlaps flags with data[0].

I think "compatibility" is slightly misleading, e.g. the offset of the field is
changing for 32-bit userspace. 

  To avoid breaking compilation of userspace that was using the flags
  field, provide a userspace-only union to overlap flags with data[0].

> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index 91a6fe4e02c0..f903ab0c8d7a 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -445,7 +445,11 @@ struct kvm_run {
>  #define KVM_SYSTEM_EVENT_RESET          2
>  #define KVM_SYSTEM_EVENT_CRASH          3
>  			__u32 type;
> -			__u64 flags;
> +			__u32 ndata;
> +			union {
> +				__u64 flags;

As alluded to above, what about wrapping flags in 

#ifndef __KERNEL__
				__u64 flags;
#endif

so that KVM doesn't try to use flags?

> +				__u64 data[16];
> +			};
>  		} system_event;
>  		/* KVM_EXIT_S390_STSI */
>  		struct {
