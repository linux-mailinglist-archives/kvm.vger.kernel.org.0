Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05214FFE4C
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 20:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234943AbiDMTBe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 15:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233144AbiDMTBc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 15:01:32 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AEEA6A030
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:59:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c23so2772807plo.0
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 11:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+s5G7jbpkbYVTz6qoZmmkkJhu/8nfINLnZZ9mTALV9o=;
        b=JVAgHgY7RI4gEMP3ghnhC2MxT7PjSeyhMy1ZN9BoZUlRmzaSofiS1v7gjZPFKG8mTv
         C0zd7vh7Tqadqs1Ysxlg25yWoBCrPp0G8MXJi7knEt5MQhwPuC5Ac3ssKw2Ku3azTT97
         bB/N703UMp/iGc4ew2OItDXCu54bXF809YcieEk38/6UzH6jveUrB220UJvJ9Xz2AB7P
         1OD3mSUaUA+NpFvgNJD5LHjGwQXoAlk9hySzwnNaBIJLuUqnoqHG4+4vZhBwf239DfU8
         G8mpKuug6HRURzFCbCIdUY9dfTwKvtCWlvPgOzJIJz3i2YbaVWexp6ThEDnURAcR4/Nc
         D3Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+s5G7jbpkbYVTz6qoZmmkkJhu/8nfINLnZZ9mTALV9o=;
        b=2Dw2VrZLIe0nQ1TMdr+cocLvEbPGfDQ1OSOgiVY4FJNiETOjNu2s2a+3DzH3jAK5fG
         QvP1KzuPW6tiKT3WPQV4KE0F5E8G3MkDkCifvIOwbv5LwezYB4VtIjQtMbnRhpU8NozW
         RK/w7kmmlQw4PrSmvzByYgG7Jkg7Yiv0ZLXwtfFyjb/F2YlAP687PrOLZ2qb/Dm+yhbI
         40HlAbQNVCY6xA8kiP74PtXIsiokGxDHL66smIOhtw55k6BoE0WrpFrH5rAbxTWHGIMY
         iGE5AojGRnwoYz5abo5W+yktYPaCAa9EZ0wfTUv1OgJpDBnVBY7H13Le8FBulc1u33xQ
         nFaw==
X-Gm-Message-State: AOAM5315vUq+wDltwuSLP57ZM8lWrT9y2SY3Fxvo8R729r4pOV3SGeRJ
        JvHF8+XUqsNy4Xiulb9V24DGmw==
X-Google-Smtp-Source: ABdhPJzPK7PIQ4obIdQBVCfuhSZWF8tnYixN+a+V04HEHZXGn5NQJdtzrLnHG/9yb8Xq7MrI/Y4oCw==
X-Received: by 2002:a17:902:b10e:b0:156:1bf8:bf26 with SMTP id q14-20020a170902b10e00b001561bf8bf26mr44244164plr.8.1649876349830;
        Wed, 13 Apr 2022 11:59:09 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id j13-20020a17090a840d00b001ca89db9e6esm3866106pjn.19.2022.04.13.11.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 11:59:09 -0700 (PDT)
Date:   Wed, 13 Apr 2022 18:59:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, drjones@redhat.com,
        marcorr@google.com, zxwang42@gmail.com, erdemaktas@google.com,
        rientjes@google.com, brijesh.singh@amd.com,
        Thomas.Lendacky@amd.com, jroedel@suse.de, bp@suse.de
Subject: Re: [kvm-unit-tests PATCH v2 01/10] x86: Move ap_init() to smp.c
Message-ID: <YlcdefdD4eqlL8U9@google.com>
References: <20220412173407.13637-1-varad.gautam@suse.com>
 <20220412173407.13637-2-varad.gautam@suse.com>
 <YlcZ83yz9eoBjmEt@google.com>
 <Ylcckbw3XXxcJiTL@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ylcckbw3XXxcJiTL@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 13, 2022, Sean Christopherson wrote:
> On Wed, Apr 13, 2022, Sean Christopherson wrote:
> > On Tue, Apr 12, 2022, Varad Gautam wrote:
> > > @@ -142,3 +143,26 @@ void smp_reset_apic(void)
> > >  
> > >  	atomic_inc(&active_cpus);
> > >  }
> > > +
> > > +void ap_init(void)

Sorry for chaining these, I keep understanding more things as I read through the
end of the series.  Hopefully this is the last one.

Can this be named setup_efi_rm_trampoline()?  Or whatever best matches the name
we decide on.  I keep thinking APs bounce through this to do their initialization,
but it's the BSP doing setup to prep waking the APs.
