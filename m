Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D2D04E6C20
	for <lists+kvm@lfdr.de>; Fri, 25 Mar 2022 02:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357557AbiCYBke (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Mar 2022 21:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357623AbiCYBiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 24 Mar 2022 21:38:00 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961EBA0BC8
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 18:35:37 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id k6so6557247plg.12
        for <kvm@vger.kernel.org>; Thu, 24 Mar 2022 18:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rCO5xCPhDILvckAs1DWy7jjaavYTT5p+k0wQ03BON1s=;
        b=jJxzoyGo/jbSrD3YG2JjZXPep7kMLHmxwW6vSfAXfHLVteVWPtNXhIGQNkEG/V4PGX
         T9gTyNQFtZxoNXDu7zp+myJxPpyaCxekqpU67HPonBLL2h7XS4sNRnziOFMvtRVofxmo
         5boBhKOfowBY8xZ/ItCWRu4l6uii4ZfC/+jYwYFTp3tNeW2mpWfC5/evH9pf6H9EwMLl
         gkjPvPzZKpn+Skj9TKMS+yj3yN3mj2kRTT5qymlrEJfi8Smy2GMvLce0i/JLDir5B2dT
         yiHAmPbXb4K3ljPe7va5an5TTsrqe1SrRTqiDtbxi0u5h8P0RLHNEutM4ZReEd5wQ48W
         rKjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rCO5xCPhDILvckAs1DWy7jjaavYTT5p+k0wQ03BON1s=;
        b=sq3VPz3Defyge3hihOa1M77lQU6OXAR8HOZ5vqSRz2aKpCGvxilsyMzxhXI//Bx04i
         rEUBUW1gN254XFqH/jBJHxzcFxRyjF4hCaY5wuhNFef42nFGscaEYw0A3xvh8gE5ly0x
         zOjTQ9R9BQwhJEiL85w3fqEQzLoeNCD3dV+4OADTxXCOUjE+UKT6XVv4UqKFjVNTkWnE
         KhLGvd5h4NIMN8ncOj0ICusWnXgMwHYmElh2qRVPjVHVZugGvG8KNxOt1nyhqKXQRXEz
         Eev0sewoA700wjnr7et8QXE0CM1ioi85vj3FPlKPd7WQNu1tPqcmUmjK4QJPjw3/RseV
         VEwA==
X-Gm-Message-State: AOAM531LSGTJPei3B7Req4SwBZ3bmSEqDCZHzbsabEyPHTcULUXk4246
        9hnUmHr5gmvhb8CKM7ylJxw=
X-Google-Smtp-Source: ABdhPJzV8t3K39iGcanesqu8Uhy9Iu/kxOvIrFqahEV1vqUxabyoGzYMlPJ/9ugwu1+oeLpXn2bniA==
X-Received: by 2002:a17:90a:1a:b0:1c6:c1ee:c3fb with SMTP id 26-20020a17090a001a00b001c6c1eec3fbmr22086302pja.50.1648172136859;
        Thu, 24 Mar 2022 18:35:36 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id u9-20020a056a00158900b004faad3ae570sm5036781pfk.189.2022.03.24.18.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 18:35:36 -0700 (PDT)
Date:   Thu, 24 Mar 2022 18:35:34 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Gerd Hoffmann <kraxel@redhat.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>, isaku.yamahata@intel.com,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Daniel P. Berrang???" <berrange@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Connor Kuehl <ckuehl@redhat.com>,
        Eric Blake <eblake@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Philippe Mathieu-Daud??? <f4bug@amsat.org>,
        qemu-devel@nongnu.org, seanjc@google.com, erdemaktas@google.com,
        Paolo Bonzini <pbonzini@redhat.com>,
        Laszlo Ersek <lersek@redhat.com>, isaku.yamahata@gmail.com
Subject: Re: [RFC PATCH v3 12/36] i386/tdx: Add property sept-ve-disable for
 tdx-guest object
Message-ID: <20220325013534.GA1229975@ls.amr.corp.intel.com>
References: <20220317135913.2166202-1-xiaoyao.li@intel.com>
 <20220317135913.2166202-13-xiaoyao.li@intel.com>
 <20220322090238.6job2whybu6ntor7@sirius.home.kraxel.org>
 <b452d357-8fc2-c49c-8c19-a57b1ff287e8@intel.com>
 <20220324075703.7ha44rd463uwnl55@sirius.home.kraxel.org>
 <4fc788e8-1805-c7cd-243d-ccd2a6314a68@intel.com>
 <20220324093725.hs3kpcehsbklacnj@sirius.home.kraxel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324093725.hs3kpcehsbklacnj@sirius.home.kraxel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Mar 24, 2022 at 10:37:25AM +0100,
Gerd Hoffmann <kraxel@redhat.com> wrote:

> > #VE can be triggered in various situations. e.g., CPUID on some leaves, and
> > RD/WRMSR on some MSRs. #VE on pending page is just one of the sources, Linux
> > just wants to disable this kind of #VE since it wants to prevent unexpected
> > #VE during SYSCALL gap.
> 
> Linux guests can't disable those on their own?  Requiring this being
> configured on the host looks rather fragile to me ...

Guest can get the attributes. (But can't change it).  If the attributes isn't
what the guest expects, the guest can stop working itself.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
