Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93FC8606999
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 22:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiJTUhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 16:37:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiJTUhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 16:37:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F59F20752B
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:37:52 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ez6so530784pjb.1
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 13:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ylV5F7V3m2H20veacCgK2r73fOkEvFdQwzWTIQ9kaNg=;
        b=QYrrUMJL76a14z/2CgN4kpGBf33rzUe9EyGLzgzY/CrAnOFWYEtzf3GTxYEKNzqUJb
         fnt1vY7fNpeRI/uJerXCoOTm+i/DU94id0b5YxXmN17UeC81oS5iuW9/YOJtfO23POFn
         +X0Xp0jHSI9Ol9jL5Ih589L//OG3IZ1G4ZDB5/CSVh82jKaTmWDmCSgu98w7WjpFWKzW
         4ABkZKAwsoR3LfWq8ljtymUbbzIid7xRW8UanLGo/WP0J7iFalcH1X36CbwjYYgjPH4/
         FD0T/Sn9jpdxxZceEByrWEkWUVQ8MfIvRziVK5IPE1Mj+8uPNBISeWhos4rMVviTIy5Z
         Rlbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ylV5F7V3m2H20veacCgK2r73fOkEvFdQwzWTIQ9kaNg=;
        b=RM2A/ZZv13LToB8hhPdOaEHtl6Am4Rq2eCYZ2MMyz04Csd8GE69kHKRSNJ/K5yW6Qe
         M04j4Hvk2OQpuOq7nEKbIWGbW1WQCq5nkrl97MMQx79iLZG93D/iZkrN5X1Kj3hopIci
         DP5KdJjqWjSaycMamWmCEo+udRsn7DXcWFK+/AgqwDHsLK0Miu6b37GagS85Qt6gjZ1r
         u0jOlSaqb1baHBnfXjjTMOXvy6p9UwtQ0+j741q1HTAHZWm8bgYmDuupj8aaQ4nGkaZg
         qoRUB+2DKDFItw1o0zJTf4Ck0RotWnPqB1+qeet+7h7uyH9ZCc4qfWz6BFg+AXcwAUJ8
         m7mA==
X-Gm-Message-State: ACrzQf2DHQwybzGgNtvFx5UtLY9+O5d9TZ2ezyHsfiB9ZoSQ9mC/+iYx
        U/1m84y+RgF0B+WkhSQoZ6uqQg==
X-Google-Smtp-Source: AMsMyM4GijDzVoHYcTfCpJQ9Nam7gdDEXqzFdVzosjZfytXFrFQAhPSD0Dj/tTw6SQEQzaoYu1KGRw==
X-Received: by 2002:a17:90a:5914:b0:20a:ea11:2620 with SMTP id k20-20020a17090a591400b0020aea112620mr18286921pji.34.1666298271943;
        Thu, 20 Oct 2022 13:37:51 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id t15-20020aa7946f000000b00562f9ea47a5sm13723523pfq.190.2022.10.20.13.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 13:37:51 -0700 (PDT)
Date:   Thu, 20 Oct 2022 20:37:48 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Alexander Graf <graf@amazon.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Xiao Guangrong <guangrong.xiao@gmail.com>,
        "Chandrasekaran, Siddharth" <sidcha@amazon.de>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 11/27] KVM: x86/mmu: Zap only the relevant pages when
 removing a memslot
Message-ID: <Y1GxnGo3A8UF3iTt@google.com>
References: <20190813100458.70b7d82d@x1.home>
 <20190813170440.GC13991@linux.intel.com>
 <20190813115737.5db7d815@x1.home>
 <20190813133316.6fc6f257@x1.home>
 <20190813201914.GI13991@linux.intel.com>
 <20190815092324.46bb3ac1@x1.home>
 <a05b07d8-343b-3f3d-4262-f6562ce648f2@redhat.com>
 <20190820200318.GA15808@linux.intel.com>
 <20200626173250.GD6583@linux.intel.com>
 <590c9312-a21f-8569-9da3-34508300afcc@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <590c9312-a21f-8569-9da3-34508300afcc@amazon.com>
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

On Thu, Oct 20, 2022, Alexander Graf wrote:
> On 26.06.20 19:32, Sean Christopherson wrote:
> > /cast <thread necromancy>
> > 
> > On Tue, Aug 20, 2019 at 01:03:19PM -0700, Sean Christopherson wrote:
> 
> [...]
> 
> > I don't think any of this explains the pass-through GPU issue.  But, we
> > have a few use cases where zapping the entire MMU is undesirable, so I'm
> > going to retry upstreaming this patch as with per-VM opt-in.  I wanted to
> > set the record straight for posterity before doing so.
> 
> Hey Sean,
> 
> Did you ever get around to upstream or rework the zap optimization? The way
> I read current upstream, a memslot change still always wipes all SPTEs, not
> only the ones that were changed.

Nope, I've more or less given up hope on zapping only the deleted/moved memslot.
TDX (and SNP?) will preserve SPTEs for guest private memory, but they're very
much a special case.  

Do you have use case and/or issue that doesn't play nice with the "zap all" behavior?
