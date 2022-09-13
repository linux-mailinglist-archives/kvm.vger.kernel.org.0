Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B88EE5B675D
	for <lists+kvm@lfdr.de>; Tue, 13 Sep 2022 07:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbiIMF3n (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Sep 2022 01:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIMF3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 13 Sep 2022 01:29:38 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B35C2661
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 22:29:33 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id g4so10338310pgc.0
        for <kvm@vger.kernel.org>; Mon, 12 Sep 2022 22:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=FH1YMcKhKiON+TEJ7L2a6u9YR2UeNnrzJpRWyHDh1M0=;
        b=BXcPELQ9APtyZG2nT03rjKpnqegAkbVxGuGp8TmmygcXP8MrX4R3nCjZlyF0aWbhNn
         rZ7I+cLBquf6qDmah0BkZpXgqk7y54fkjetE4BFWW8fTJk+71CjKoic6qJT5/kndEl2q
         1DNs5RIUWJpoUvaRhlJB1/8B/s2Iv4fiR4sK6jPyRlKT5wR4VTR/j++nMkiUaHQYFHoe
         EBasV3n0Qvd59z4NrHgnsEUZP1oNjZavn+dvzvRAoncrUEQmrd48a/bTbK7xqZKTFe+s
         B1Gj9ZrogTk88b9e8s/xmWMqhKXl/9pZ/rhY/WZuWkFmgENo4o+RHi77BeUottPBytrx
         5sVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=FH1YMcKhKiON+TEJ7L2a6u9YR2UeNnrzJpRWyHDh1M0=;
        b=yepOjjV9/QF2Xoto+MoJXgRSP2IkVXT7y8jvJYxaLPIBzttSfzs4WLKh1Q2XQe9otS
         i5oPTm2MJo2zbM10rOQAf+DLXEHpaIB7crqWNsEhoXqg1e2n3Vhf9xl9f3AUK8ojeocj
         0KAPJZaMvhnrmMpIKK4W4HAoMcwMnV9g5BZjib8xuuxXbEmyhYPnliT6xGj54bZh+Knk
         6dI+MOAuBSRi/JI9H+in/yPwT+WvsiuvIk22MFP0hUpZY9GYKizpyXDqYaZz9Li639qi
         96Uej5WmB2NTEaDTNbFqz47MFz1Eaz2tDiZoFwipMmabcpcahGOQl3gWQ3G3OOjipS7Y
         JzbA==
X-Gm-Message-State: ACgBeo00kAOVSrK4YvKBu/DmOkb2NkPhu55TXp2eL8DGITqeuUJUWHsp
        5AaulYLhZN6N/dMU8M4r30fETA==
X-Google-Smtp-Source: AA6agR4WWC2jumTLCWnRmXDYaTJddL8lmdGwxWQxtqyrz2vMmMie3sFiDbaLdlyA0k2stNalF7TTbQ==
X-Received: by 2002:a63:f713:0:b0:438:c33d:5fad with SMTP id x19-20020a63f713000000b00438c33d5fadmr11425156pgh.84.1663046972342;
        Mon, 12 Sep 2022 22:29:32 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x9-20020aa79a49000000b0053812f35a41sm6678938pfj.194.2022.09.12.22.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Sep 2022 22:29:32 -0700 (PDT)
Date:   Tue, 13 Sep 2022 05:29:28 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        pbonzini@redhat.com, jon.grimm@amd.com,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: Re: [PATCH] KVM: SVM: Fix x2apic logical cluster mode decoding and
 sanity check
Message-ID: <YyAVOBXZ+O3hnU9y@google.com>
References: <20220912214632.14880-1-suravee.suthikulpanit@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220912214632.14880-1-suravee.suthikulpanit@amd.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 12, 2022, Suravee Suthikulpanit wrote:
> When sending IPI in the X2APIC logical cluster mode, the destination
> APIC ID is encoded as:
> 
>   * Cluster ID = ICRH[31:16]
>   * Logical ID = ICRH[15:0]
> 
> Current logic incorrectly decode the ICRH, which causes VM running
> with x2AVIC support to fail to boot. Therefore, fix the decoding logic.

There are already patches pending[1][2] for the x2AVIC bugs.  

[1] https://lore.kernel.org/all/20220903002254.2411750-9-seanjc@google.com
[2] https://lore.kernel.org/all/20220903002254.2411750-10-seanjc@google.com

> 
> The commit 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
> also added a check for multiple logical destinations before using
> the fast-path. However, the same logic is already existed prior to
> the commit. Therefore, remove redundant checking logic.
> 
> Fixes: 603ccef42ce9 ("KVM: x86: SVM: fix avic_kick_target_vcpus_fast")
> Cc: Maxim Levitsky <mlevitsk@redhat.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> ---
>  arch/x86/kvm/svm/avic.c | 19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 6919dee69f18..45ab49d1f0b8 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -378,8 +378,8 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  
>  		if (apic_x2apic_mode(source)) {
>  			/* 16 bit dest mask, 16 bit cluster id */
> -			bitmap = dest & 0xFFFF0000;
> -			cluster = (dest >> 16) << 4;
> +			bitmap = dest & 0xffff;
> +			cluster = (dest & 0xffff0000) >> 16;
>  		} else if (kvm_lapic_get_reg(source, APIC_DFR) == APIC_DFR_FLAT) {
>  			/* 8 bit dest mask*/
>  			bitmap = dest;
> @@ -387,7 +387,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  		} else {
>  			/* 4 bit desk mask, 4 bit cluster id */
>  			bitmap = dest & 0xF;
> -			cluster = (dest >> 4) << 2;
> +			cluster = (dest & 0xf0) >> 4;

This is wrong and unrelated.  The cluster needs to be shifted back by 2, i.e. multiplied
by 4, to leap over each cluster of 4 IDs.

>  		}
>  
>  		if (unlikely(!bitmap))
> @@ -420,18 +420,7 @@ static int avic_kick_target_vcpus_fast(struct kvm *kvm, struct kvm_lapic *source
>  			 * For x2APIC logical mode, cannot leverage the index.
>  			 * Instead, calculate physical ID from logical ID in ICRH.
>  			 */
> -			int cluster = (icrh & 0xffff0000) >> 16;
> -			int apic = ffs(icrh & 0xffff) - 1;
> -
> -			/*
> -			 * If the x2APIC logical ID sub-field (i.e. icrh[15:0])
> -			 * contains anything but a single bit, we cannot use the
> -			 * fast path, because it is limited to a single vCPU.
> -			 */
> -			if (apic < 0 || icrh != (1 << apic))
> -				return -EINVAL;
> -
> -			l1_physical_id = (cluster << 4) + apic;
> +			l1_physical_id = (cluster << 4) + (ffs(bitmap) - 1);
>  		}
>  	}
>  
> -- 
> 2.34.1
> 
