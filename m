Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E3875F7D37
	for <lists+kvm@lfdr.de>; Fri,  7 Oct 2022 20:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbiJGSSK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Oct 2022 14:18:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbiJGSSI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Oct 2022 14:18:08 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227D126574
        for <kvm@vger.kernel.org>; Fri,  7 Oct 2022 11:18:08 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id r18so5300525pgr.12
        for <kvm@vger.kernel.org>; Fri, 07 Oct 2022 11:18:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rbzY++VZG96j0Hd8AXi9sVXtcLS0lWu2CqEOVd7OTdI=;
        b=cCEBACQfUwmnL+1g1Hw/Hc6dcqslD0evh7EG/OqpUooecgRO1Sl758lPtUQUn7SHm4
         wi4ZSgWkXz2ZSTvTY5fFR88tubJQ5x1/BWgYcrMQDTPAeZG4s5Sgo8zB0+h8yBLMfFh7
         SzlO5nUKt07KjVBli1sEQzCOuxWu43pNgH1SEIP7eFKyYuV9iqQWSCX6P3Gv36EHqB3e
         8++TM8gR0LhwS1lyBUN/YX8g1sBbpcAqrSulRRAlbAeKSh82Rd9pSKX/9s3BwOms+kYi
         77zBNaFapIvEICfj6uPGWlPgrxgqfys4LkeWul+obhvhe2HOHxCcWJkFhnAD5X31XLH4
         lHrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rbzY++VZG96j0Hd8AXi9sVXtcLS0lWu2CqEOVd7OTdI=;
        b=kGRtOvE8Ov6QRqRrkxYv9R7GkSLqicRRDMIKdP7mxMXcG07yqb6tMKIcdgaH+dezOy
         bOBg8NaaMlvx9NgTOiqsQrndYRPKrd78zV8ubFOpv4G2Wl+hGSNi9wfjrK+MyzfYPu6h
         uaYqSaCtftg/63Wk/3AJGDGjwmkss30BHUKHJw3qci2USCAlX7CmFPag/vTs9wKdeQ4x
         9XhFbdcx7uQQhUHoMGf+rG8ukMhYn5G1ZnuiplWXR2v0Lb+WSpCRiJ8Skxc/FmNNOcGJ
         0Az9aAR/0djM488GYhLyjTFk82x2R1jg6EN5rvb3IeRaEAgT4r/mAE29RdbLDFGrPope
         oYJQ==
X-Gm-Message-State: ACrzQf1P3Y67gdwNMw94eFKtKDcyrGTrdYEKJhgt5NtRXstnGKFMS2Wc
        3j9J2nJ3L+zXIxleLn2r43vVrQ==
X-Google-Smtp-Source: AMsMyM7IWARJQIWSfMqjtiin2WCtyol4l1wsnURpXb5aeF2XD/JNYRfBiFUvNe4j5Wp/CTtRcJPK2Q==
X-Received: by 2002:a63:8b44:0:b0:45f:952f:c426 with SMTP id j65-20020a638b44000000b0045f952fc426mr1708246pge.623.1665166687444;
        Fri, 07 Oct 2022 11:18:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e88-20020a17090a6fe100b00205d85cfb30sm4956147pjk.20.2022.10.07.11.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 11:18:06 -0700 (PDT)
Date:   Fri, 7 Oct 2022 18:18:02 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Christian Borntraeger <borntraeger@linux.ibm.com>
Cc:     Shivam Kumar <shivam.kumar1@nutanix.com>, pbonzini@redhat.com,
        maz@kernel.org, james.morse@arm.com, david@redhat.com,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org,
        Shaju Abraham <shaju.abraham@nutanix.com>,
        Manish Mishra <manish.mishra@nutanix.com>,
        Anurag Madnawat <anurag.madnawat@nutanix.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH v6 1/5] KVM: Implement dirty quota-based throttling of
 vcpus
Message-ID: <Y0BtWixstpm/fFlE@google.com>
References: <20220915101049.187325-1-shivam.kumar1@nutanix.com>
 <20220915101049.187325-2-shivam.kumar1@nutanix.com>
 <a63becdf-18d7-25f1-9070-209dbc008add@linux.ibm.com>
 <52ad1240-1201-259a-80d0-6e05da561a7f@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52ad1240-1201-259a-80d0-6e05da561a7f@linux.ibm.com>
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

On Thu, Sep 15, 2022, Christian Borntraeger wrote:
> Am 15.09.22 um 15:21 schrieb Christian Borntraeger:
> > I am wondering if this will work on s390. On s390  we only call
> > mark_page_dirty_in_slot for the kvm_read/write functions but not
> > for those done by the guest on fault. We do account those lazily in
> > kvm_arch_sync_dirty_log (like x96 in the past).
> > 
> 
> I think we need to rework the page fault handling on s390 to actually make
> use of this. This has to happen anyway somewhen (as indicated by the guest
> enter/exit rework from Mark). Right now we handle KVM page faults directly
> in the normal system fault handler. It seems we need to make a side turn
> into KVM for page faults on guests in the long run.

s390's page table management came up in conversation at KVM Forum in the context
of a common MMU (or MMUs)[*].  If/when we get an MMU that supports multiple
architectures, that would be a perfect opportunity for s390 to switch.  I don't
know that it'll be feasible to make a common MMU support s390 from the get-go,
but at the very least we can keep y'all in the loop and not make it unnecessarily
difficult to support s390.

[*] https://kvmforum2022.sched.com/event/15jJk
