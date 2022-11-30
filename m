Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBEC163E42F
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 00:03:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbiK3XDI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 18:03:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbiK3XCn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 18:02:43 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4572C8E598
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:02:22 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id c15so168056pfb.13
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 15:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nHOMyfsfvQkL/nShVDUzK82mKXXqJYsG0axSizIXaLY=;
        b=NnMo7/46lbMBrXBXQZRYVq3GggYMT+7jEJcq9CL/cSVNfI9/zGr929gpN24qaTzNDj
         EuAX3kX5hoFkykznYnPSEMhpqrvV96Ls6XOPXnZJFhl++LMNCZ1xBLhLYGuEyeIeBOlg
         1Pda6St2Grg/DjBtBU5P+snxis04vfL2wZmjtsQkvZDNryITBkJPcp25ppL/joru6uaX
         pdFAr7CPrxA89GBOBBQLxyhlYq8vGrdtF3rzEmU5z3DvHeLGy15BW/hWdiMul0LnS4v8
         aUBoc+y5QRGugr1owVbIQyI2ZzhFRbthIb2QpbXN2iQwGAYLSCnMYOTrkzCCC2hVImkh
         7vwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nHOMyfsfvQkL/nShVDUzK82mKXXqJYsG0axSizIXaLY=;
        b=GAT85Dh7sT8b+c5sljBBwMt87L7cNIjjiQu8hFPBlUFurFN9Kv9HhONPBDikrPwUgt
         7tpb2wo1r2grFnYXaKGcE7+b8C/EmsYZgTR53g/BVWBTcQ+P4ecH04u+IVO1kWQY4FnI
         wQhAKmSfnWNEi9o0NgDmCLlXsrW5PcxKu2kB4h8xF0GO9F0WP2RekR2UH3S4Ax1bxz4U
         kOdDsVr2P13Bjis8tdFxGJxoDkGP0ayB5BTqnQ7SrH5ze5eHcOghQLJZi29vGWpXh32c
         9Zt70wfm8tjmXRSqOFIO7a8haAmq3MW2JKGBOygf0w8RdeOPKL4EcO7Q+KQRkdJ67uxq
         ffGQ==
X-Gm-Message-State: ANoB5plVT7JFh2Jk78hpUoLcAgx2fGurtp6a63G3c43YiQXrt23KwXku
        XGSHSCRIxjIb4QoiMyphNlJwfQ==
X-Google-Smtp-Source: AA0mqf5Nj1181KAxR2A/WI368LXBMRYoBlCi8ORJRhPIy6nAs8C080UTF7/1gaOFg5Avl9sdvRAfNA==
X-Received: by 2002:a63:2361:0:b0:45f:f8df:108e with SMTP id u33-20020a632361000000b0045ff8df108emr37236360pgm.127.1669849341423;
        Wed, 30 Nov 2022 15:02:21 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a6-20020a624d06000000b005633a06ad67sm509519pfb.64.2022.11.30.15.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Nov 2022 15:02:20 -0800 (PST)
Date:   Wed, 30 Nov 2022 23:02:16 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 32/44] KVM: x86: Unify pr_fmt to use module name for all
 KVM modules
Message-ID: <Y4fg+MO2DusqMSZO@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-33-seanjc@google.com>
 <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
 <Y20r2NR9MaBbOGLn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y20r2NR9MaBbOGLn@google.com>
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

On Thu, Nov 10, 2022, Sean Christopherson wrote:
> On Thu, Nov 10, 2022, Robert Hoo wrote:
> > After this patch set, still find some printk()s left in arch/x86/kvm/*,
> > consider clean all of them up?
> 
> Hmm, yeah, I suppose at this point it makes sense to tack on a patch to clean
> them up.

Actually, I'm going to pass on this for now.  The series is already too big.  I'll
add this to my todo list for the future.
