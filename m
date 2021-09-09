Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 260B04045D2
	for <lists+kvm@lfdr.de>; Thu,  9 Sep 2021 08:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhIIGyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Sep 2021 02:54:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42113 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230424AbhIIGyw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Sep 2021 02:54:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631170423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=lVJoPeTJ14ks4lQWKf8FQkfVIx9pT4lGJxslkRQboLs=;
        b=HvsfbpsSV3PFD8ErzwcbMuqLQHHAc5I5xzLc9pIXp1BKDOSVFN+8fFIJVEAxNNIntZxrIA
        K9LMKfYPl7R03Xm3JFzGeyAHlA7PcB3APADd3QyfZxD2rGtt0Bs53fuIwrVwxDlCdyCrSD
        NGx6gGw4QwKOQnum/pNv76h1FISl8Us=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-498-ahMYGK0FPH60RmPCjqQTsw-1; Thu, 09 Sep 2021 02:53:42 -0400
X-MC-Unique: ahMYGK0FPH60RmPCjqQTsw-1
Received: by mail-ej1-f69.google.com with SMTP id o7-20020a170906288700b005bb05cb6e25so293144ejd.23
        for <kvm@vger.kernel.org>; Wed, 08 Sep 2021 23:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lVJoPeTJ14ks4lQWKf8FQkfVIx9pT4lGJxslkRQboLs=;
        b=lhbDi5W3I+q3xRNU5VxZMb3DWrdZDVAycyNvUKf3DDIQ4KvUQaBB6nlxUBmlBMPek1
         QrgpbiGryaTCdzBPojMA/pA/TdFfbEN01qXwzyoZnLvu5qfzQheK6VXdaN6bZ1+wJ2pR
         KutmtqSI43IQqnVP1dyz00h9wbA0wuC6vbDTab9B1o665wJtzV8qWCx25IGvEYTCRx9a
         1poVWq42Fzx9isIKSxww/MNSin5YOaLHXaEQnKc4kIzCId/yjhPMj698OHgnAz/JpzoG
         ioQrjNEgRCrn8BqVErxjqJx28HwuhDzMK8hZnbOAAq6epyomvv/l7IMrldSVi2Y/VoHH
         0Kmg==
X-Gm-Message-State: AOAM5302FY2EM3JxmuFS93eUvw/J74Oc5lUsmJvWDwUqCMrplDw27oSo
        eAVoH1MPTv4KR33C1JBoRkl5Fr7wAM167aouhtj5PJqme1CyhAC4RiATxoku4KUSJf2HbOUvqPa
        v9oku6f8AkFnN
X-Received: by 2002:aa7:d1d3:: with SMTP id g19mr1558608edp.373.1631170421273;
        Wed, 08 Sep 2021 23:53:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwzT2kVMpMwhqwvnc4mwNm5O0NWY9+knRg4l5/t0Fuho97if+WNms/fZtVChK5kAL+kRk5zWw==
X-Received: by 2002:aa7:d1d3:: with SMTP id g19mr1558597edp.373.1631170421138;
        Wed, 08 Sep 2021 23:53:41 -0700 (PDT)
Received: from gator (cst2-174-132.cust.vodafone.cz. [31.30.174.132])
        by smtp.gmail.com with ESMTPSA id bs13sm378308ejb.98.2021.09.08.23.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Sep 2021 23:53:40 -0700 (PDT)
Date:   Thu, 9 Sep 2021 08:53:38 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Raghavendra Rao Ananta <rananta@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <Alexandru.Elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Peter Shier <pshier@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v4 02/18] KVM: arm64: selftests: Add sysreg.h
Message-ID: <20210909065338.ulh32fqi4e6gnh2o@gator>
References: <20210909013818.1191270-1-rananta@google.com>
 <20210909013818.1191270-3-rananta@google.com>
 <CAOQ_Qsh=F-tTre_ojiLXUfAriH-coTF_gXCcLyRb3kKM+LLhQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_Qsh=F-tTre_ojiLXUfAriH-coTF_gXCcLyRb3kKM+LLhQA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 08, 2021 at 10:47:31PM -0400, Oliver Upton wrote:
> Hi Raghu,
> 
> On Wed, Sep 8, 2021 at 9:38 PM Raghavendra Rao Ananta
> <rananta@google.com> wrote:
> >
> > Bring-in the kernel's arch/arm64/include/asm/sysreg.h
> > into selftests to make use of all the standard
> > register definitions in consistence with the kernel.
> >
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >  .../selftests/kvm/include/aarch64/sysreg.h    | 1278 +++++++++++++++++
> >  1 file changed, 1278 insertions(+)
> >  create mode 100644 tools/testing/selftests/kvm/include/aarch64/sysreg.h
> 
> This belongs in tools/arch/arm64/include/asm/sysreg.h, I believe.
>

Yes, that's also where I expected it to land.

Thanks,
drew 

