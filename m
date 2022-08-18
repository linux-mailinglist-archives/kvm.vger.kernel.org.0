Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96179598AC3
	for <lists+kvm@lfdr.de>; Thu, 18 Aug 2022 19:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345141AbiHRR5P (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Aug 2022 13:57:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiHRR5O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Aug 2022 13:57:14 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B73C3BC128
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:57:13 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d16so2115720pll.11
        for <kvm@vger.kernel.org>; Thu, 18 Aug 2022 10:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=e05CvhD1ZUMfUEn0ZBtVumUZSqrCVNyPhu4vjgJboZk=;
        b=GwhnujooADK3rszphRziElGJZtVU6I4Xqb2RegMVbHwxkDtnNjHHcO7HvUgubyZ6YE
         3DI0cPXr7G9dxjPwO0boNSu9Hl/sHI6xRb+ZH65pXNSdoAAy+XEI0u31PqqqeflFF7Iy
         Ygy0xx0k4tO1fkUMYX4P9KwhdRwlMwa6mdxXh5V82ap/rr6VZYDcSz5m8Ix0k/2YbUHj
         83W7GnqbHg2EPAQVYo+tCZ1LIs19d6V6vqf1mbLQ7LHUAXIbjO+YlTQ34gjLzu8rWx+I
         ZXfsxvZYUy9tJ2BWM9BH+fJvkk6JYvJtBvaT5qqDmLZCG7QrTBXt4FD+pZJJzpOWMn4x
         uUkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=e05CvhD1ZUMfUEn0ZBtVumUZSqrCVNyPhu4vjgJboZk=;
        b=nIENeN76VPxRjRgtrU4Y/A78rCfm+C675ggjWV2o10MxBecTJYTjPa+Lsv2WbAyq+E
         0Cmi1uQcgAVa3VKmSgEDVnLD9qLl3U0trBzlN3tMiHOFNezpD54an6YlbaFdqVO7S97W
         8moKcVxzDfUN/ctJ41n3buwJWS+cLJTB6hs1rIX+MnNOKptV5d2O6y6KwxMOzlhNPFFw
         jmEjNtVlDenWMEit62XmH1OT7w++/EAuLafNGMMVrM36qqVSsauGhU9CPn2tLVuUeKT1
         Jw1TaLY9tqdomtsjE8Wpjri2/RY0UWIFvkgilPmjPZHk/ahJ3NO3z7DVXkRS3FRfyAVn
         NYxQ==
X-Gm-Message-State: ACgBeo3orp3oiiSk6QF9MzgZcqQEbZkoJ5i2BesPsVOi8dkLp49UjQ8n
        oJVCNMgl9zWmoZR0M+CAksPGIA==
X-Google-Smtp-Source: AA6agR75A+8wg2SArLXRaSx/ZSkJUYWTpOGjlEP7zhjOVSUgNBN48pNQJguDQLLN9jD5AyqVgoA7RQ==
X-Received: by 2002:a17:902:8b87:b0:16f:1bb7:984a with SMTP id ay7-20020a1709028b8700b0016f1bb7984amr3494576plb.113.1660845433071;
        Thu, 18 Aug 2022 10:57:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a7-20020a170902ecc700b0016dbdf7b97bsm1675133plh.266.2022.08.18.10.57.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:57:12 -0700 (PDT)
Date:   Thu, 18 Aug 2022 17:57:09 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Anirudh Rayabharam <anrayabh@linux.microsoft.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Kelley <mikelley@microsoft.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 03/26] x86/hyperv: Update 'struct hv_enlightened_vmcs'
 definition
Message-ID: <Yv59dZwP6rNUtsrn@google.com>
References: <20220802160756.339464-1-vkuznets@redhat.com>
 <20220802160756.339464-4-vkuznets@redhat.com>
 <Yv5ZFgztDHzzIQJ+@google.com>
 <875yiptvsc.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875yiptvsc.fsf@redhat.com>
X-Spam-Status: No, score=-14.4 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 18, 2022, Vitaly Kuznetsov wrote:
> Sean Christopherson <seanjc@google.com> writes:
> 
> > On Tue, Aug 02, 2022, Vitaly Kuznetsov wrote:
> >> + * Note: HV_X64_NESTED_EVMCS1_2022_UPDATE is not currently documented in any
> >> + * published TLFS version. When the bit is set, nested hypervisor can use
> >> + * 'updated' eVMCSv1 specification (perf_global_ctrl, s_cet, ssp, lbr_ctl,
> >> + * encls_exiting_bitmap, tsc_multiplier fields which were missing in 2016
> >> + * specification).
> >> + */
> >> +#define HV_X64_NESTED_EVMCS1_2022_UPDATE		BIT(0)
> >
> > This bit is now defined[*], but the docs says it's only for perf_global_ctrl.  Are
> > we expecting an update to the TLFS?
> >
> > 	Indicates support for the GuestPerfGlobalCtrl and HostPerfGlobalCtrl fields
> > 	in the enlightened VMCS.
> >
> > [*] https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/tlfs/feature-discovery#hypervisor-nested-virtualization-features---0x4000000a
> >
> 
> Oh well, better this than nothing. I'll ping the people who told me
> about this bit that their description is incomplete.

Not that it changes anything, but I'd rather have no documentation.  I'd much rather
KVM say "this is the undocumented behavior" than "the document behavior is wrong".
