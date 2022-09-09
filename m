Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27BCD5B3CB5
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 18:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbiIIQLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Sep 2022 12:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbiIIQLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Sep 2022 12:11:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85556FF51C
        for <kvm@vger.kernel.org>; Fri,  9 Sep 2022 09:11:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662739874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZUab6LxhmYfy7dSgFwC4pEIogIAzeXkfkimelyJVvDY=;
        b=IHw4JQp+ffdZpb0uADAbTuWKGLD0SNWKXVZEkvTLikZIrJvcFFC4/nS6c8rGc4hOd9M3if
        bRS+jpmCI5DZT1nU5/SeXR06sBX9+GK1G6Ex5WJvZSSIB3e/wpGr/VatZdOp+opXPAELSt
        IBv+fDBHzCxztDqik1RS7+J11ETHmu4=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-125-vlq2Li4nNj6z7NnOMFQgeg-1; Fri, 09 Sep 2022 12:11:13 -0400
X-MC-Unique: vlq2Li4nNj6z7NnOMFQgeg-1
Received: by mail-qk1-f197.google.com with SMTP id bj2-20020a05620a190200b006bba055ab6eso1826782qkb.12
        for <kvm@vger.kernel.org>; Fri, 09 Sep 2022 09:11:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ZUab6LxhmYfy7dSgFwC4pEIogIAzeXkfkimelyJVvDY=;
        b=xcQ0p/AnWSm6NLEDzMMVLLoQNrqtP7+Udc3iqq8XV0ajBC3HMt4ysCxEX4rKYBAL87
         vEYf7wZjt19J/E3A8Z+Pei9NI3O04u/xmKxWkTF2IovAtFr6tMVLnwPT9GWyibBG5XZ8
         mXY9aHx1qPDDfEUXRC4Hrvy9w0nrbohYz8gJ5kcsnIUt3i3uF7B/4mG1lcPVe5l+CqUz
         eW/5UqIGopNiu7SZVFylknPNPtPp7FOfzckEi6OfCYTc0qTLoXrZt6g6/pRU2OBUilDO
         j9m84pFEdtGRzsYLhDg4vL/pHYfns0rRYZPUke7HQ4E+9XNDiKhHTjD0SUXYPLrsME6w
         4ioQ==
X-Gm-Message-State: ACgBeo2hv7U17bXn5NcFnfiXwviU9WuststoL9N3npSZxsP571ZhZYFG
        3r0Kz/Ihcs3hMKaimm1Ro6Cye3R5QMAoQ9Zk8UhVZdOxguE7ksE9x5zOpYiYyRsFSOTgbD36Try
        k9WwFLICZcke+
X-Received: by 2002:ac8:5f09:0:b0:35b:a5a3:19e2 with SMTP id x9-20020ac85f09000000b0035ba5a319e2mr739583qta.238.1662739872930;
        Fri, 09 Sep 2022 09:11:12 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6+rGrEM2mr2C+r9yxmXZea3Z28Q5EncVP8bQ5b7XIQZTQ4eRfAEFR/xuypacjNNb6HFK15CA==
X-Received: by 2002:ac8:5f09:0:b0:35b:a5a3:19e2 with SMTP id x9-20020ac85f09000000b0035ba5a319e2mr739555qta.238.1662739872703;
        Fri, 09 Sep 2022 09:11:12 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id fd9-20020a05622a4d0900b00342f8d4d0basm695105qtb.43.2022.09.09.09.11.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Sep 2022 09:11:12 -0700 (PDT)
Date:   Fri, 9 Sep 2022 12:11:10 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Zeng Guang <guang.zeng@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, Gao Chao <chao.gao@intel.com>
Subject: Re: [PATCH v3] target/i386: Set maximum APIC ID to KVM prior to vCPU
 creation
Message-ID: <Yxtlnv+jfN0FR6v8@xz-m1.local>
References: <20220825025246.26618-1-guang.zeng@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220825025246.26618-1-guang.zeng@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 25, 2022 at 10:52:46AM +0800, Zeng Guang wrote:
> Specify maximum possible APIC ID assigned for current VM session to KVM
> prior to the creation of vCPUs. By this setting, KVM can set up VM-scoped
> data structure indexed by the APIC ID, e.g. Posted-Interrupt Descriptor
> pointer table to support Intel IPI virtualization, with the most optimal
> memory footprint.
> 
> It can be achieved by calling KVM_ENABLE_CAP for KVM_CAP_MAX_VCPU_ID
> capability once KVM has enabled it. Ignoring the return error if KVM
> doesn't support this capability yet.
> 
> Signed-off-by: Zeng Guang <guang.zeng@intel.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

