Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3777624796
	for <lists+kvm@lfdr.de>; Thu, 10 Nov 2022 17:51:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbiKJQu7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Nov 2022 11:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232570AbiKJQuj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Nov 2022 11:50:39 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC129FEF
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:50:37 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id q9so2710074pfg.5
        for <kvm@vger.kernel.org>; Thu, 10 Nov 2022 08:50:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ngpTqFXA20Qov7vlYrPcJjUI8sUR/quxgJrGzBa7LTQ=;
        b=dFHHoN/Nh+VXrE9JsY3e3+fkRaRAvb1aGnzgeGfgDdwTgSMupLwM8ROA3+W4pYGjY0
         5rtK6lElI+DgF0DyaiLvpiaAorCWCegKieghDDMY6o0ECE7iPV/tCP64EmRRyb1QKnLg
         h1cjN79kb5l9jgix2MCBmxfqZYQuwhlkODvDz7ZvaH4sxe61Ml97iSmSMtvAoCeE4p6S
         zdFuv8u4MZbd4uwMLlGMYvkNsSjoXRG5kz2GxfEgOPys7+fCqRAsVr0dupEjPva4LkLJ
         QEyjxBRtbWEN1lQAedlvI4TNbWVV6gyxLgVr0x17HRSOYZcACGBuRj0/yzFNApiBrJr+
         O6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ngpTqFXA20Qov7vlYrPcJjUI8sUR/quxgJrGzBa7LTQ=;
        b=aJ5xt3A6FdE8Jajhd8zk7yYPMx7HOi9W6ZMmG9U3+0oChqwC7lIEIXnG+RQtCAQCuY
         w3WnMITZBsOyMnhhQ8iOK4DBxjXq8eLlNNaVjOuCqxyhG5cSPUpGnPr7cz01PxRX0deg
         iklHNM24K80J+XCwsN3uPWNwI3y/KIBVbNfcOUutZejO0ZBb7YKlZYR11mUsTBxgo7y2
         A0AtM5ewLTJsESiX+tU+8+rFpKnx5GFvRJYsmAEsnXKypwgXgp65pAc1yGjJVwEpSojz
         6XcQ8ae1JuGYxh23Xm5Uqf5j258nyC4wI3wxpDTLs9rf/TXzPPrfZtc+ys2LDpfGqMc5
         ZUiA==
X-Gm-Message-State: ACrzQf2rlvbI6pmctvBd9stva5sRjrGiHp7XlY7vB+UClbiDivk4Bk+s
        veX4s3p3dAlfCM/aLagn6J2Wxg==
X-Google-Smtp-Source: AMsMyM41GjMawKBCP5Kop4vnrwekEGW/LOSR6lYqiErYbTmquFxjglLK4Ryhg/mdPPwnXrGhT3xNoQ==
X-Received: by 2002:aa7:8d08:0:b0:56b:a4f6:e030 with SMTP id j8-20020aa78d08000000b0056ba4f6e030mr3031241pfe.85.1668099036440;
        Thu, 10 Nov 2022 08:50:36 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902db0200b00186f81bb3f0sm11518667plx.122.2022.11.10.08.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 08:50:35 -0800 (PST)
Date:   Thu, 10 Nov 2022 16:50:32 +0000
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
Message-ID: <Y20r2NR9MaBbOGLn@google.com>
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-33-seanjc@google.com>
 <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff0e8701d02ee161d064f92c8b742c2cc061bce0.camel@linux.intel.com>
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

On Thu, Nov 10, 2022, Robert Hoo wrote:
> After this patch set, still find some printk()s left in arch/x86/kvm/*,
> consider clean all of them up?

Hmm, yeah, I suppose at this point it makes sense to tack on a patch to clean
them up.
