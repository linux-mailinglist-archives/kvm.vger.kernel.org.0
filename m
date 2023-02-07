Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68CB68DE36
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 17:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbjBGQup (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 11:50:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbjBGQun (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 11:50:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FBF39BB1
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 08:50:42 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id bx22so12705684pjb.3
        for <kvm@vger.kernel.org>; Tue, 07 Feb 2023 08:50:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+pay9IH1iB2E7hJH5exnfAIMLvFSAkaDymDb1a/8yW0=;
        b=WRIIQDroPKn7SixIu/lLbIkFMP1FfmXQ3yWKUbJP4CeFAVZhv60k+iuaAoarMXO+B5
         7la2gdOHzNIV4pA5KDZAv8RH/6taSQT/yQytDUonUvberXfIvXRGh8tV0NkkTneyJYhi
         zMOsiW4/1zFB8cVTiGqjr/YrhLJ27g+af2XXD1eTBV8Rj212SkQrkiVB3NbfZbkh/n2V
         bozHHHJPVjRiD2Uc/30Qu56PQI6tM7UT4Uyiz+4tZzBN9siextagi+97fGkYa2BnA9wK
         n+DZ4gmDWtI+fwkWX5ASHlFsOAdfTU4UZrm1PJs1g3cK0ibZrfgZQ16AYa05fTxFftqJ
         KtJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+pay9IH1iB2E7hJH5exnfAIMLvFSAkaDymDb1a/8yW0=;
        b=yykZzVBzI6ylmcMCF/S5eAdJL7L4Dr/MPvOyiPEQvIY8sXKgHp7RfyreGbhpkJ9bDC
         ozwKGDP/HrvV+yiArZCntSxEwOFBcZhC7UnHTfhPLWZ1dwJYcxQCo88HWgmjgkE4KT18
         DiGw2RgPPDYQCrUZZRw9END5Ns3PeKsB/FiX5OJ3Jwxm5YpEp37QbFzvQ6O6osN6F2Lc
         n83iLmAQIt95g7Gk/Ip1qvEirbBLx3O6wcXaHpRduXzN0aCeXicWu8GIuDZ0C7yUdrVl
         mnkO51rFMdl9uQlC5yB/HWWzlVXuj3PBHoSdb+g5jV427i7ILKXkkFa1EqOsI0GoONYq
         i6DA==
X-Gm-Message-State: AO0yUKVrgjiYDys+AGMHL1VUQ28MW33pN6nlRlDQLl/LeRMqw1mfCmvH
        8T4tLNVYc0hULdXAFNFOHKOZDw==
X-Google-Smtp-Source: AK7set8FabyKIXpegGDVahMOOCZr4aBGwz6c/q6sIrS1g5yeRY6uxy6dJ/AXqM46UOJbeznrI/i1gw==
X-Received: by 2002:a17:903:2448:b0:194:d5ff:3ae3 with SMTP id l8-20020a170903244800b00194d5ff3ae3mr278538pls.2.1675788642124;
        Tue, 07 Feb 2023 08:50:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id m6-20020a170902bb8600b00177f25f8ab3sm9143988pls.89.2023.02.07.08.50.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 08:50:41 -0800 (PST)
Date:   Tue, 7 Feb 2023 16:50:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     "Woodhouse, David" <dwmw@amazon.co.uk>,
        "usama.arif@bytedance.com" <usama.arif@bytedance.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "thomas.lendacky@amd.com" <thomas.lendacky@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "fam.zheng@bytedance.com" <fam.zheng@bytedance.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "liangma@liangbit.com" <liangma@liangbit.com>,
        "pmenzel@molgen.mpg.de" <pmenzel@molgen.mpg.de>,
        "mimoja@mimoja.de" <mimoja@mimoja.de>,
        "hewenliang4@huawei.com" <hewenliang4@huawei.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "punit.agrawal@bytedance.com" <punit.agrawal@bytedance.com>,
        "simon.evans@bytedance.com" <simon.evans@bytedance.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "rcu@vger.kernel.org" <rcu@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v6 04/11] x86/smpboot: Reference count on
 smpboot_setup_warm_reset_vector()
Message-ID: <Y+KBXf+IT2pQdF5A@google.com>
References: <20230202215625.3248306-1-usama.arif@bytedance.com>
 <20230202215625.3248306-5-usama.arif@bytedance.com>
 <871qn2xsmf.ffs@tglx>
 <57195f701f6d1d70ec440c9a28cbee4cfb81dc41.camel@amazon.co.uk>
 <87sffhv8to.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sffhv8to.ffs@tglx>
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

On Tue, Feb 07, 2023, Thomas Gleixner wrote:
> On Tue, Feb 07 2023 at 09:49, David Woodhouse wrote:
> > On Tue, 2023-02-07 at 00:48 +0100, Thomas Gleixner wrote:
> >> Aside of the 'We' this does not explain anything at all.
> >
> > Er, doesn't it?
> >
> > We refcount the warm reset vector because when we do parallel bringup,
> > we'll want to set it up once and then put it back to normal (for cold
> > reset) once all the CPUs are up.
> >
> > I can rework the phrasing; I'm aware that the whole nonsense about
> > pronouns and the imperative mood has grown legs in the last couple of
> > years since I originally wrote it — but is there anything actually
> > missing? 
> 
> We can settle the imperative mood debate over a beer at the next
> conference, but stuff which goes through tip is required to follow those
> rules. No exception for you :)

While we're reforming David, same goes for KVM x86.  :-)
