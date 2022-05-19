Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBF3852E0A6
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 01:41:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343680AbiESXl3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 19:41:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiESXl2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 19:41:28 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC1F66AD3
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 16:41:27 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id x12so6330308pgj.7
        for <kvm@vger.kernel.org>; Thu, 19 May 2022 16:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y9COzyvBIeNRvhVZARn4Tr5Mm1d3dQnhuaiOOZjtkqk=;
        b=cdNmdwWZwNLhDB9iFg27zK0z/Sw30NLINUvQdUJYod654q4zx/M+3VnWdLwUwLwI1T
         OD+Eyv+KaBElZHITAvZ/sD57wk23rsKjfxsIdgzqCQ0nlANCer3Gem8sIjNEzYvKPM0b
         UMb/VxEKb8KyRlguUCWyR1NGbHyCfePpG3fn5XlcAQLauA3vCXhy30tnP1X6LnYlB7lg
         tV2rcl/BIgp60KT3AsOVrdEdtNLZY6k/rLKl6E0S3MettlmqcX7IYCtHY1ojpra1Vl8B
         HXIEFEhaYeNljfi6YjWxIHPVL3gBd2aQ17OmYq0lBrVEwVGLc5pnf4wWwBd6hYpDzEY2
         ytvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Y9COzyvBIeNRvhVZARn4Tr5Mm1d3dQnhuaiOOZjtkqk=;
        b=IKXymFXnIP7TvdOf020Qph/NmQdYnZb5G0Q12P+AkKI2e8JfQFXZpHB3Ctv0BZy21g
         1NbsTJeQKDvkm6TCKCHy8qTUBSpNTWgnlR+1b9M9pFoMg1cbsML0kZiBrXNyGOijIcrj
         sUVOEfA34t53a8cg8SQqraUkJaOFKpHbzBWcrjMbPSnpDQ54pXUbCY5eIlvWee2uSejN
         ea2DykBJijZhVXk+8RXgP02iOpkNzDP1TqQESMK6eCd5f4PlhuJ7Mg78NsL1/t5jFOGM
         tsCAiv1PxITG1Dy1VF+Gv9Wk7cbh2Rt/V6K9I1uHJAsR7SgL42Tb/YrYZ/xcJMo6Kxjq
         FUIg==
X-Gm-Message-State: AOAM532taVJtxZQut7nivkyaLRV5GzA7n6IiLKs950eaFdIKdGYppv8I
        nSnej2d2fPj/T/hgkr2pQ9A2YQ==
X-Google-Smtp-Source: ABdhPJyUnP4DU2ULl/GilAmOWqdi+HmycYrx10QrXHqJuODoh6QTRIRVzZJ4+S5hFEXuQ5VoYosVZA==
X-Received: by 2002:a65:480a:0:b0:3c6:e629:3022 with SMTP id h10-20020a65480a000000b003c6e6293022mr5953237pgs.281.1653003686955;
        Thu, 19 May 2022 16:41:26 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t66-20020a628145000000b005183112db97sm246042pfd.74.2022.05.19.16.41.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 16:41:26 -0700 (PDT)
Date:   Thu, 19 May 2022 23:41:22 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zeng Guang <guang.zeng@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hu, Robert" <robert.hu@intel.com>
Subject: Re: [PATCH v9 0/9] IPI virtualization support for VM
Message-ID: <YobVotf9CJ6dk9zw@google.com>
References: <20220419153155.11504-1-guang.zeng@intel.com>
 <2d33b71a-13e5-d377-abc2-c20958526497@redhat.com>
 <cf178428-8c98-e7b3-4317-8282938976fd@intel.com>
 <f0e633b3-38ea-f288-c74d-487387cefddc@redhat.com>
 <YoK48P2UrrjxaRrJ@google.com>
 <20220517135321.GA31556@gao-cwp>
 <20220517140218.GA569@gao-cwp>
 <20220519092906.GA3234@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519092906.GA3234@gao-cwp>
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

On Thu, May 19, 2022, Chao Gao wrote:
> On Tue, May 17, 2022 at 10:02:23PM +0800, Chao Gao wrote:
> >+ Maxim
> >
> >On Tue, May 17, 2022 at 09:53:26PM +0800, Chao Gao wrote:
> >>On Mon, May 16, 2022 at 08:49:52PM +0000, Sean Christopherson wrote:
> >>>Shouldn't we have a solution for the read-only APIC_ID mess before this is merged?
> 
> Paolo & Sean,
> 
> If a solution for read-only APIC ID mess is needed before merging IPIv
> series, do you think the Maxim's patch [1] after some improvement will
> suffice? Let us know if there is any gap.

Yep, inhibiting APICv if APIC ID is changed should do the trick, and it's nice and
simple.  I can't think of any gaps.

> [1]: https://lore.kernel.org/all/20220427200314.276673-3-mlevitsk@redhat.com/
