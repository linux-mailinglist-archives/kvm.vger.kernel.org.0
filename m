Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F31E95A6867
	for <lists+kvm@lfdr.de>; Tue, 30 Aug 2022 18:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiH3Q1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Aug 2022 12:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiH3Q1S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Aug 2022 12:27:18 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5523EA32F
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 09:27:14 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id c24so11114971pgg.11
        for <kvm@vger.kernel.org>; Tue, 30 Aug 2022 09:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=MHoR6yIrGCrlxd9mVdCiPC/GPzHGRJ7W5b2peJNI/oY=;
        b=hOviUGYdQ5DATRxPhlLL4hCmPmmixmpEsR/zwwy+kUTMzVSpSWurCTDUGDcjcsUw3S
         EK1//woJjRLS5UUDJfOM6W1bdxqfXRFuKbLjwinNaqFI8g+uWjpik6dla0S6AV/o5fzO
         fcU/P2GmMiPiMSxit102hDbwvATUXkc4S2G00R3p2MSXDfshAHCKkb642nZmz5IkabMU
         Kp/m4IFI+1nsxvuhSf2fqsD9UkHsaSaReoAWEJh58VoaZMYPRX4t0xRB6HaFhX/fwLx9
         CvMJ7nSgJAdPa2MIYlIUE0dGerbfGgkKHJBjEbsGSCSs1q5k171nQa8qLzEKZlalhLmc
         uQxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=MHoR6yIrGCrlxd9mVdCiPC/GPzHGRJ7W5b2peJNI/oY=;
        b=FYoaoFWItMfKIkchN1/gMk/7HQlFbvif3s+kVYR9ru4Z9EoB4J5xekK3X0mtdpAAbS
         btixXtsvLOJkwLZGf94x8cFMLHa2onnZJEIeJzaRZ61e1zZCMB/iS6LuehTGrZPg5MIz
         wNAY16tjn+ZMIvSO6+El3RVEM3FkcZyKB4roUVVS9KFNoaeo/I2RDiCkLg8OYnPACOlz
         k8lV1b0uoFvwnsw+ke+8pvPrIEtZuLKjUwyrhCn6fNjtvsl4Z1+uShZwXJNp53uCOnsD
         FOJWl+PJ0sOHMOEFJsVsdYqzHjPYvjFlFFrFq7j9yiPTUZhNWizCsp91W52VFDEjKXzm
         98bA==
X-Gm-Message-State: ACgBeo1o09V8zUXPKrAA4w8rz6P8x5Zw8qrbApVYw1v6fYveZI2g0Drp
        D3qWEVajvvLMsS0Zgh/w4GRJVg==
X-Google-Smtp-Source: AA6agR55aWGRWytPY81SSLflhZPqZlfHmk2iF5IHJO67qNPRP1M7RVU8TqYgGuFMMaAe4iCDuwo3uA==
X-Received: by 2002:a63:8641:0:b0:42c:42ac:b6b1 with SMTP id x62-20020a638641000000b0042c42acb6b1mr6860753pgd.508.1661876833230;
        Tue, 30 Aug 2022 09:27:13 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x17-20020a170902ec9100b00174a69f69b8sm5985886plg.51.2022.08.30.09.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 09:27:12 -0700 (PDT)
Date:   Tue, 30 Aug 2022 16:27:08 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v9 00/40] KVM: x86: hyper-v: Fine-grained TLB flush + L2
 TLB flush features
Message-ID: <Yw46XAP3aafdH/xZ@google.com>
References: <20220803134110.397885-1-vkuznets@redhat.com>
 <8735ddvoc2.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735ddvoc2.fsf@redhat.com>
X-Spam-Status: No, score=-14.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 30, 2022, Vitaly Kuznetsov wrote:
> Vitaly Kuznetsov <vkuznets@redhat.com> writes:
> 
> > Changes since v8:
> > - Rebase to the current kvm/queue (93472b797153)
> > - selftests: move Hyper-V test pages to a dedicated struct untangling from 
> >  vendor-specific (VMX/SVM) pages allocation [Sean].
> 
> Sean, Paolo,
> 
> I've jsut checked and this series applies cleanly on top of the latest
> kvm/queue [372d07084593]. I also don't seem to have any feedback to
> address.
> 
> Any chance this can be queued?

It's the top "big" series on my todo list.  I fully plan on getting queued for 6.1,
but I don't expect to get to it this week.
