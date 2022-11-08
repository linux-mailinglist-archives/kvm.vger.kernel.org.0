Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21777621E19
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 21:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiKHUzd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 15:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiKHUzb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 15:55:31 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10518201AA
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 12:55:31 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id k5so14872411pjo.5
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 12:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z2mthpjvK4gnLPCZq1fjuVoG/GO6J8GGaVa0/UK/7WI=;
        b=rSPdVdM+wWBDfrvsyALHP/8vY+i7Mbc0Ftkoz2fvFpK5vVtsCQ2AWcpVmnP7dCSvZg
         a57nA4LRRPQdK87SL/8iCWF1ebr3uKEXNubg2GMdiP4JHNDiTsVwjC+dwGSbo7JZMsz6
         HCOiR9aWz3Enqjs/vxy7Px/fKibxF8t35ljpHWa7RvSv9yOSzuCM2HckFJXfYTGyD60C
         6DhQHhyEdZ3DqtXpQjJH8OZc0BinVQ2T6YI99xdMa1ixC/VLmFaPOG947GOudwvvNbJY
         6cSS2xxu7Z3gzwPfrnlE24q6i0xhw/CAdD6gCZZj+t5OYoV4NhZ7rYU5u4a+/eTw7tTF
         hmlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z2mthpjvK4gnLPCZq1fjuVoG/GO6J8GGaVa0/UK/7WI=;
        b=bi1PPalcItJn0ZZ7EgeYWznq65DqujaysTsMbrf04IlYdHKWkbcnH17vnWvVDGvsdv
         BkyE+Wkgwqbm4LFkmJs+lV21/wsWgehGg8t+mdo3urhOOZBnOMDmES5YWVgWh25JSZLD
         08X7239drnbTZpx+DGlxG5dOMGpcqp4d25ZWWr/2a19sN+dximvELj/otFpGZN21XlMc
         yv8N2VIXlLkSZlcW7IZH+cbHTLsJsjP+yGS6U6vTRGZ0liRCNezsvCEGEk+i3LXcqc+N
         l5o985daBk7PrL8wALEXxLyIyLIMQbFHek2ijnAFdLjvpm18S3sxX7tWwT6HiIFGwiPe
         KmoQ==
X-Gm-Message-State: ACrzQf1AJQx5cwTfecXytqDHOSpIJ1au5Dhd0OF+Y8NCyRqMEpM9z3J/
        MT/jqmnlpg2DwAjNa0jUpNN6fg==
X-Google-Smtp-Source: AMsMyM6c4vEFLv0196hVNd5ZzBqZtwGaapqgO01cDzVF+69R6dVWv1fbWsEuFgxaMqK10G5WpWQ5Og==
X-Received: by 2002:a17:902:aa46:b0:186:e220:11d4 with SMTP id c6-20020a170902aa4600b00186e22011d4mr58090281plr.163.1667940930470;
        Tue, 08 Nov 2022 12:55:30 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e19-20020a170902ed9300b00186acb14c4asm7384944plj.67.2022.11.08.12.55.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 12:55:30 -0800 (PST)
Date:   Tue, 8 Nov 2022 20:55:26 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        nathan@kernel.org, thomas.lendacky@amd.com,
        andrew.cooper3@citrix.com, peterz@infradead.org,
        jmattson@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/8] KVM: SVM: adjust register allocation for
 __svm_vcpu_run
Message-ID: <Y2rCPuBGdtXv2ILs@google.com>
References: <20221108151532.1377783-1-pbonzini@redhat.com>
 <20221108151532.1377783-4-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108151532.1377783-4-pbonzini@redhat.com>
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

On Tue, Nov 08, 2022, Paolo Bonzini wrote:
> In preparation for moving vmload/vmsave to __svm_vcpu_run,
> keep the pointer to the struct vcpu_svm in %rdi.  This way
> it is possible to load svm->vmcb01.pa in %rax without
> clobbering the pointer to svm itself.
> 
> No functional change intended.
> 
> Cc: stable@vger.kernel.org
> Fixes: f14eec0a3203 ("KVM: SVM: move more vmentry code to assembly")

Same nit, Fixes: shouldn't be provided.
