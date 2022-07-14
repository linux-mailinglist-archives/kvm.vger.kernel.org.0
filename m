Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5D4575033
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 16:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239909AbiGNOAL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 10:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240408AbiGNN6q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 09:58:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 477451141
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657807085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KsB/k7XGvHWoQ6egQzGPsZym+TsC+6TwIfhUT/WwqdM=;
        b=NjYo1Jhlh92tp5zTWPP/TOoTwWAwx4Q6NGwx0oKMbyDvoAob9CxIz59LBE7XfasRKQxodS
        pRBAEPhtpxdweESHvIYZ8EBTAFYETAaz88CVFZIhd1ewymOHJGyPHRGkyyRffEHVUPp+n8
        qqh9N+YjX//PhGE7ZeDsxbGnOxrDsXk=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-651-C24r--gAPQS0RBnigTyRog-1; Thu, 14 Jul 2022 09:58:03 -0400
X-MC-Unique: C24r--gAPQS0RBnigTyRog-1
Received: by mail-qt1-f200.google.com with SMTP id fx12-20020a05622a4acc00b0031e98cb703cso1513685qtb.18
        for <kvm@vger.kernel.org>; Thu, 14 Jul 2022 06:58:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KsB/k7XGvHWoQ6egQzGPsZym+TsC+6TwIfhUT/WwqdM=;
        b=bb+wRRSBcxu+1kFjr83RXI6KQ3j0mbWW5Qwg6LuTv6Hv/Zg8z9Mqpc1BhRvLoQyRSX
         3RFJEiF/ACEcynId4pwci15ul37FZz9QkrqrnTA3l84zmCqQbkDjsAPOU9pf+F9RRK//
         ZDwV954IkVf0I64/H6M0p0y+6ZOyuxkWQblBQrgYADrR5z1xndcyRlqeV4jqtn41NWiU
         7o7lX3t25yxLaaJilcYeYQEQyZEm7LyJfgEl1Y7vtk8k1Xnut/yomd85tULDLBNrcHbk
         bnvnNDg83VDBpQGFHLHVH0GKEABScKZRkESVveNNLd4+r8viTrW6OHe+rMf2Wd/7nlOp
         XAsA==
X-Gm-Message-State: AJIora8fniQvRtdeXqE2X52wVUzrP7jGtMfVMS95H/WvLPZ6ZRRMBL7e
        sW6NssjSFD1fYk4Wgmnc9KRDRt9es2kCW53EMWrBiCaOVzRrQBK48OLAWBjdW0VLwX7imQ947c3
        t349B7rqm0YA+
X-Received: by 2002:a05:6214:27cb:b0:473:5954:5951 with SMTP id ge11-20020a05621427cb00b0047359545951mr7919664qvb.2.1657807083230;
        Thu, 14 Jul 2022 06:58:03 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1srA1bYyjq1CYysZjazFyJYNL6ms774yQxtBEhGn0TW9yx4Z/jHqjZ9e2hADHZfbOpuOOXj5w==
X-Received: by 2002:a05:6214:27cb:b0:473:5954:5951 with SMTP id ge11-20020a05621427cb00b0047359545951mr7919646qvb.2.1657807083040;
        Thu, 14 Jul 2022 06:58:03 -0700 (PDT)
Received: from [10.35.4.238] (bzq-82-81-161-50.red.bezeqint.net. [82.81.161.50])
        by smtp.gmail.com with ESMTPSA id cf12-20020a05622a400c00b0031ece0bc9f5sm290591qtb.45.2022.07.14.06.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 06:58:02 -0700 (PDT)
Message-ID: <034401953bc935d997c143153938edb1034b52cd.camel@redhat.com>
Subject: Re: [PATCH] KVM: SVM: fix task switch emulation on INTn instruction.
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <seanjc@google.com>,
        Joerg Roedel <joro@8bytes.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        kvm@vger.kernel.org
Date:   Thu, 14 Jul 2022 16:57:56 +0300
In-Reply-To: <52d44630-21ad-1291-4185-40d5728eaea6@maciej.szmigiero.name>
References: <20220714124453.188655-1-mlevitsk@redhat.com>
         <52d44630-21ad-1291-4185-40d5728eaea6@maciej.szmigiero.name>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-5.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-07-14 at 15:50 +0200, Maciej S. Szmigiero wrote:
> On 14.07.2022 14:44, Maxim Levitsky wrote:
> > Recently KVM's SVM code switched to re-injecting software interrupt events,
> > if something prevented their delivery.
> > 
> > Task switch due to task gate in the IDT, however is an exception
> > to this rule, because in this case, INTn instruction causes
> > a task switch intercept and its emulation completes the INTn
> > emulation as well.
> > 
> > Add a missing case to task_switch_interception for that.
> > 
> > This fixes 32 bit kvm unit test taskswitch2.
> > 
> > Fixes: 7e5b5ef8dca322 ("KVM: SVM: Re-inject INTn instead of retrying the insn on "failure"")
> > 
> > Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> > ---
> 
> That's a good catch, your patch looks totally sensible to me.
> People running Win 3.x or OS/2 on top of KVM will surely be grateful for it :)

Yes and also people who run 32 bit kvm unit tests :)

BTW, I do have a win98 VM which I run once in a while under KVM.
On Intel it works very well, on AMD, only works without NPT and without MMU
pre-fetching, due to fact that the OS doesn't correctly invalidate TLB entries.

I do need to test KVM with OS/2 on one of the weekends.... ;-)

Thanks for the review,
	Best regards,
		Maxim Levitsky

> 
> Reviewed-by: Maciej S. Szmigiero <maciej.szmigiero@oracle.com>
> 
> Thanks,
> Maciej
> 


