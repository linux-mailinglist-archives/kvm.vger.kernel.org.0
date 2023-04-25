Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA486EDE88
	for <lists+kvm@lfdr.de>; Tue, 25 Apr 2023 10:51:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbjDYIvr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Apr 2023 04:51:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233355AbjDYIvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Apr 2023 04:51:45 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0761700
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 01:51:43 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f1763ee8f8so36809935e9.1
        for <kvm@vger.kernel.org>; Tue, 25 Apr 2023 01:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682412702; x=1685004702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y0uWY7brqmRcXtVhZrcEFbqRw/mI47vo48/ZwQf8LM0=;
        b=CVPdtHcb6/onOq1WIDibJiKW2+L8E5SE0fW3D5KFSkyvX17mEzrLHIIexwecFFX2HW
         z64w2n2+/SDqzwua8AggwNS0fR933cVzmRApXoofVnU3whAPgdliqjXXKKt1+xrkD1v+
         kZHJUCOuNGuUXAsos4N12QDYZfs+1rKo5l7b5r57U7plsOOkf784rUyh/tWUx/ABh6zy
         l8YvQuI4PK4Gydz+GY7ap5t6UUoO0LKuD9SizmskuuWPblecgDY9e5pG2iBRcuPW/rye
         FrIOLS79bCG+pU+d53Gecq98625XmbOt8qEpGryu1l1p9J19RzpdujRomvhrsvks2gNe
         ok4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682412702; x=1685004702;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y0uWY7brqmRcXtVhZrcEFbqRw/mI47vo48/ZwQf8LM0=;
        b=Br8v4MMzV4pDmQCoM0oYMZYl6QkG05RsMovpmjXIidClQaZCO2K7hu1DMmjAKzE70i
         88tby4CJ1ivr8RbnWfZBN4R7afbPkGOs0IxXWI5Ua0kQklKtLZ6/1s7NrBCy9akn3cLa
         P6ahogqiYOBQw7OFMTCv/hByuFgEJsf0nnkj+NQItPENuAFr+F42DAtk76cUuZ0pQdhE
         +RWMReawaBDo/oKbAD0CQVjFLRYBQ72+fGB3FVlQDRvltkWvbvyMTyAUASXNgMXTzfso
         ZRwUsaWgenmRC8O9pEToUzdM0MnoK+kup4Y4YvDBf+CZ2IBlMWl1EsIV/QHTJzHkOM8Z
         VqwA==
X-Gm-Message-State: AAQBX9fysKIpK1SKAnvPqbLXmoszQP9wa79DiJURQeYUz1VJ33TD1FEe
        KRonXt7XlwfJ/uVGKwjnsaUbzA==
X-Google-Smtp-Source: AKy350ZUDANoRxBtQ9SFoMrQs3nNPESbgqKXUBOzf9AWOosDfWWewz5EhFWtDHxGnGlu3xM/k7MiWQ==
X-Received: by 2002:a1c:7912:0:b0:3f1:94e2:e5cf with SMTP id l18-20020a1c7912000000b003f194e2e5cfmr9189741wme.34.1682412702184;
        Tue, 25 Apr 2023 01:51:42 -0700 (PDT)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id i40-20020a05600c4b2800b003ee6aa4e6a9sm17589228wmp.5.2023.04.25.01.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Apr 2023 01:51:41 -0700 (PDT)
Date:   Tue, 25 Apr 2023 09:51:42 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     kvm@vger.kernel.org, qemu-devel@nongnu.org, qemu-ppc@nongnu.org,
        qemu-arm@nongnu.org, qemu-s390x@nongnu.org, pbonzini@redhat.com,
        mtosatti@redhat.com, danielhb413@gmail.com, clg@kaod.org,
        david@gibson.dropbear.id.au, groug@kaod.org,
        peter.maydell@linaro.org, chenhuacai@kernel.org,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com
Subject: Re: [PATCH] kvm: Merge kvm_check_extension() and
 kvm_vm_check_extension()
Message-ID: <20230425085142.GA976713@myrica>
References: <20230421163822.839167-1-jean-philippe@linaro.org>
 <87jzy1v3gd.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87jzy1v3gd.fsf@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023 at 03:01:54PM +0200, Cornelia Huck wrote:
> > @@ -2480,6 +2471,7 @@ static int kvm_init(MachineState *ms)
> >      }
> >  
> >      s->vmfd = ret;
> > +    s->check_extension_vm = kvm_check_extension(s, KVM_CAP_CHECK_EXTENSION_VM);
> 
> Hm, it's a bit strange to set s->check_extension_vm by calling a
> function that already checks for the value of
> s->check_extension_vm... would it be better to call kvm_ioctl() directly
> on this line?

Yes that's probably best. I'll use kvm_vm_ioctl() since the doc suggests
to check KVM_CAP_CHECK_EXTENSION_VM on the vm fd.

Thanks,
Jean

> 
> I think it would be good if some ppc folks could give this a look, but
> in general, it looks fine to me.
> 
