Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E70C50A93E
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 21:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392001AbiDUTev (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 15:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391992AbiDUTet (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 15:34:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 27D364D9C6
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650569518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oirHxJeseSpQ4iOStNI8q8HxIkoCquebwBwbPngeeuA=;
        b=c1vpDv6Pg+EHa9n5mWyXOOTCO8HbLBl7VGHPOFi96/Xs9dBIzdbSDb883jQfSf7vvwUM0E
        Rg6DwhZMyVwwENV79aZejIZNoL4RqPueA3YEufDrlBdeFYt6QDf2Ft0Fe+OiGOrNGuCqo/
        e/ew0yYhmln4mQhbefSOu7Wb8OJJ8s8=
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com
 [209.85.166.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-218-bfXjqfuAMLyHG59xDQqcqQ-1; Thu, 21 Apr 2022 15:31:57 -0400
X-MC-Unique: bfXjqfuAMLyHG59xDQqcqQ-1
Received: by mail-io1-f70.google.com with SMTP id i19-20020a5d9353000000b006495ab76af6so3993565ioo.0
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 12:31:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oirHxJeseSpQ4iOStNI8q8HxIkoCquebwBwbPngeeuA=;
        b=GjeAdMLYfII+TVtzrTG6J22e/j2fyQC07IG6An3ueKo6VKpgKQoMB+7T1iz85+ukLT
         ie5SdCs/fltgmNOS+qUENMbLeV0A6ADFdtQMuFN+/99J0l58kgyWZWUiHg+Xt/m/Nr+x
         j6lT+UzDXZRBSwv7Vc7ii7Fz/0sxfJqSQcTWqGRPhChtsdGfb2QLtaGphQEymsuQjvlk
         rAvddoVk1ebljTWGb5LaiU+LSBi6dIpPARQpsWMN8XWSKD+b7T0u8ockM6KyiRhbMF4q
         B6ql3kwHGuFCVldINuOZyYiQ9Vx+Jl+bOpT5SIS9BGG76GqAVDDr78ZiMVOJfAam3DbY
         bYPA==
X-Gm-Message-State: AOAM532WX0NJ47xX1wxNXVHm01F1I2Sb+uCLoufDpMby0FbJ4UmrAVbY
        gGcr8d4nB4+qkQpoearZ1vE4hYdb5uMA7sXP4wrTllEMTC7WOwRl8H27+bI9kEaQJfRxeg7HLMw
        KDPJByKngRMdq
X-Received: by 2002:a05:6638:1611:b0:326:3406:f985 with SMTP id x17-20020a056638161100b003263406f985mr551453jas.59.1650569514946;
        Thu, 21 Apr 2022 12:31:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwaoiG6Kxj7ErKitZqg/3JBzs4TupIDZ0lr19pOgKu/zn0W4U2N6Sl8x/7zKiVkv9tnJt6ggw==
X-Received: by 2002:a05:6638:1611:b0:326:3406:f985 with SMTP id x17-20020a056638161100b003263406f985mr551449jas.59.1650569514745;
        Thu, 21 Apr 2022 12:31:54 -0700 (PDT)
Received: from xz-m1.local (cpec09435e3e0ee-cmc09435e3e0ec.cpe.net.cable.rogers.com. [99.241.198.116])
        by smtp.gmail.com with ESMTPSA id z5-20020a92cec5000000b002cbe5a870dfsm12676992ilq.36.2022.04.21.12.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 12:31:54 -0700 (PDT)
Date:   Thu, 21 Apr 2022 15:31:53 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Dunn <daviddunn@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Junaid Shahid <junaids@google.com>
Subject: Re: [PATCH v6 09/10] KVM: selftests: Factor out calculation of pages
 needed for a VM
Message-ID: <YmGxKSM/r2V0tr3d@xz-m1.local>
References: <20220420173513.1217360-1-bgardon@google.com>
 <20220420173513.1217360-10-bgardon@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220420173513.1217360-10-bgardon@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 20, 2022 at 10:35:12AM -0700, Ben Gardon wrote:
> Factor out the calculation of the number of pages needed for a VM to
> make it easier to separate creating the VM and adding vCPUs.
> 
> Reviewed-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Ben Gardon <bgardon@google.com>

Reviewed-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

