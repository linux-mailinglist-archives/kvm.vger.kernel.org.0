Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BBF4E9A1E
	for <lists+kvm@lfdr.de>; Mon, 28 Mar 2022 16:51:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244070AbiC1OxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Mar 2022 10:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244111AbiC1OxH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Mar 2022 10:53:07 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7473F8A7
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 07:51:26 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id b13so10971423pfv.0
        for <kvm@vger.kernel.org>; Mon, 28 Mar 2022 07:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=obleDDk1Z4CONGxAkHZNS2tjDM/nuYlv6cPwOVJDufY=;
        b=h8Ok29DH4z6N0TfkIQj67vjU5KD03U8eMxwkX7kHs1WHIbA4lLyhTbcKvx33kZrWV5
         4tWfsq4cMxVflItMlDGuqv7OJV1eH4KdzObOzdOtizGAIkxs5mrn85cRduSTqrnG00PQ
         lL3IUJdXqE+IrbTYrjk1tVVXals52dlLJhfHN08n6eJ+rnGqFHEtsew3k8F56JnePW/4
         Zw7A6sVXJ+Aq9Tjx6/ONd0HiSUFF1MWVPcy4GVHXqAPwBhLU2ccTWenC/NJysEW/Rd95
         T3atXP4WAJ0g/Hnd6AHuxCGN4fX4Zp/B2DOVWsUW09lZPzOuSOBmfGQUZqJmRMe9+EP3
         BWiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=obleDDk1Z4CONGxAkHZNS2tjDM/nuYlv6cPwOVJDufY=;
        b=G3U0u4vxDszhjl5ygw4TrFzFBTL7GyjmOBiue9HCVuD+koB7b7AaTUVqh0qhOawnyC
         knQUMw938qglz4PhDCaVgRlsuZ2HuE+ipCXSZU93HP8PhlGF4PvQt5dW3hztZp7WXTMy
         4TS/oaSlYkT7lPZ2SxeHV1C7rJMqdb6lkFaiwUgL63Ef7qJ19uQ/YaoRTfbetIpf5Yhb
         Vgc/x1/NKXs5AVXYeAqokYw0ETcyvjAyZO74FRw1+OBrGHmb8O8h9MRJ2l6wYRakMLp0
         +ZAXBI0LBOI8Zwq8Bs5V5dkh39JrZs++cBipBD7oUVS2FBwB1sfcDMrrYg8WooP2DZ46
         GmLQ==
X-Gm-Message-State: AOAM530L31YTX87IR9aSc1d9if9wFGII3PxhIAY9DLa5pj9xMt4pE+hI
        uyoDOv6ETnIK2Lv9MoMacJsH6Q==
X-Google-Smtp-Source: ABdhPJx6O3QG54jbtM3+68GYNfgyadHMEYPzXTEypnpZ1C+mZMHehDR1WLLZmYv16OhknEgRZIk0wg==
X-Received: by 2002:a63:68c6:0:b0:380:3fbc:dfb6 with SMTP id d189-20020a6368c6000000b003803fbcdfb6mr10592508pgc.326.1648479085523;
        Mon, 28 Mar 2022 07:51:25 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id h12-20020a056a00230c00b004faf2563bcasm15408065pfh.114.2022.03.28.07.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 07:51:24 -0700 (PDT)
Date:   Mon, 28 Mar 2022 14:51:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jon Kohler <jon@nutanix.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: optimize PKU branching in
 kvm_load_{guest|host}_xsave_state
Message-ID: <YkHLaS2IPZDCToXk@google.com>
References: <20220324004439.6709-1-jon@nutanix.com>
 <Yj5bCw0q5n4ZgSuU@google.com>
 <387E8E8B-81B9-40FF-8D52-76821599B7E4@nutanix.com>
 <e8488e5c-7372-fc6e-daee-56633028854a@redhat.com>
 <1E31F2B6-96BF-42E0-AD41-3C512D98D74B@nutanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1E31F2B6-96BF-42E0-AD41-3C512D98D74B@nutanix.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022, Jon Kohler wrote:
> 
> 
> > On Mar 27, 2022, at 6:43 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > 
> > On 3/26/22 02:37, Jon Kohler wrote:
> >>>>    Flip the ordering of the || condition so that XFEATURE_MASK_PKRU is
> >>>>    checked first, which when instrumented in our environment appeared
> >>>>    to be always true and less overall work than kvm_read_cr4_bits.
> >>> 
> >>> If it's always true, then it should be checked last, not first.  And if
> >> Sean thanks for the review. This would be a left handed || short circuit, so
> >> wouldn’t we want always true to be first?
> > 
> > Yes.
> 
> Ack, thanks.

Yeah, I lost track of whether it was a || or &&.
