Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4097A632AF5
	for <lists+kvm@lfdr.de>; Mon, 21 Nov 2022 18:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiKUR2z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Nov 2022 12:28:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbiKUR2o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Nov 2022 12:28:44 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95978C6572
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 09:28:43 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id l22-20020a17090a3f1600b00212fbbcfb78so14884224pjc.3
        for <kvm@vger.kernel.org>; Mon, 21 Nov 2022 09:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=H/15K+95NBWbCjjmQ8Nvp96hEF0xLGBnksOcJAJ5xWQ=;
        b=oJG0huKuKEtjSji5UpmkNl3iToHas8gCbgJK1W8uHOPWtxNQYlVOapUG6/NnaEmiSB
         /yMrbTDnvYzoAFufqfX+LE7ZU5v+txrhgnuuVU9+FAm2KK0zsFIPT5QVpIFFkz6vp19E
         ON3zsBMmjVhxEjmb1rZtXdFNCJtG1FYbzdysBwkVfGAf011ASTFWSgel5760ZotW399f
         buvlosR5jQLriWRKACwfAcbd9y/CMTZmQxd9FvHy98nEPWbF+tWn34ADwiRcCwqqPm9H
         Kt+ScfCzuZzlwOm0GchoxQp6or6mNc/xuDA9d+9C+3Y+CaaK349ro+NaLNHNYIXr5I8i
         hTGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H/15K+95NBWbCjjmQ8Nvp96hEF0xLGBnksOcJAJ5xWQ=;
        b=GEpOLkTrNeenf1sRUeM1f7wmxicBRsvgBbgsCThCJFoDNvFtFtmLv0xw9t4Tnt7mYo
         XFCz+dFAag8bXYf9vc7H8CDNmu5aKH+UxU45+VJYh/Euch4uSVwFS09B/v6BUUE+ISoT
         9myaB52xrSoBT5cAexBcPATnET2bMJA8MaPoyy0GBDhzQWwev1QnDVsB7bO8CUV6ovgQ
         +dBeCmlmC6qzNfCFqAReSIM4hQGmg2a4OGlZfKb0G015DuwBNTHP/98s+ClB0DoZTa+Z
         MqStgYYQYhIxqnCjrlgFjwShsHTD6f6RWtjoj5YWHwTlNz1zJkDX7PMiLLrbjHb0xL4S
         l9ig==
X-Gm-Message-State: ANoB5pmaN5MqrjPwgK/SMHlOoupIoWhvzWx/oN2NW7DXOkJkeoDYzina
        GqroH61oCnYnuVv+cDO3F3Y2DA==
X-Google-Smtp-Source: AA0mqf6JCllJw8i7hRLnW42jQvepHElp3sOokcxj6BWpE9KATUkK8nSOYEY1JkNTA2w/GRPzUM1szQ==
X-Received: by 2002:a17:90a:8406:b0:205:d3f8:5241 with SMTP id j6-20020a17090a840600b00205d3f85241mr26615262pjn.188.1669051722898;
        Mon, 21 Nov 2022 09:28:42 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id h9-20020a170902f54900b00176a2d23d1asm10222350plf.56.2022.11.21.09.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 09:28:42 -0800 (PST)
Date:   Mon, 21 Nov 2022 17:28:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>, kvm@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, pbonzini@redhat.com,
        ndesaulniers@google.com, alexandre.belloni@bootlin.com,
        peterz@infradead.org, jpoimboe@kernel.org,
        chang.seok.bae@intel.com, pawan.kumar.gupta@linux.intel.com,
        babu.moger@amd.com, jmattson@google.com, sandipan.das@amd.com,
        tony.luck@intel.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        fenghua.yu@intel.com, keescook@chromium.org, nathan@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] x86: KVM: Advertise CMPccXADD CPUID to user space
Message-ID: <Y3u1Rx/kFjE5/FFR@google.com>
References: <20221118141509.489359-1-jiaxi.chen@linux.intel.com>
 <20221118141509.489359-2-jiaxi.chen@linux.intel.com>
 <efb55727-f8bd-815c-ddfc-a8432ae5af4e@intel.com>
 <f04c2e74-87e4-5d50-579a-0a60554b83d3@linux.intel.com>
 <6d7fae50-ef3c-dc1e-336c-691095007117@intel.com>
 <Y3udtm6oC7k41kaR@google.com>
 <Y3ue4PoJD7EGC5dV@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y3ue4PoJD7EGC5dV@zn.tnic>
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

On Mon, Nov 21, 2022, Borislav Petkov wrote:
> On Mon, Nov 21, 2022 at 03:48:06PM +0000, Sean Christopherson wrote:
> > Actually, for these features that don't require additional KVM enabling, KVM isn't
> > making the feature avaiable to the guest.  KVM is just advertising to userspace
> > that KVM "supports" these features.  Userspace ultimately controls guest CPUID;
> > outside of a few special cases, KVM neither rejects nor filters unsupported bits
> > in CPUID.
> 
> So is there any point to those "enable it in KVM" patches streaming constantly?

Yes.  Most userspace VMMs sanitize their CPUID models based on KVM_GET_SUPPORTED_CPUID,
e.g. by default, QEMU will refuse to enable features in guest CPUID that aren't
reported as supported by KVM.

Another use case is for userspace to blindly use the result of KVM_GET_SUPPORTED_CPUID
as the guest's CPUID model, e.g. for using KVM to isolate code as opposed to standing
up a traditional virtual machine.  For that use case, userspace again relies on KVM to
enumerate support.

What I was trying to call out in the above is that the KVM "enabling" technically
doesn't expose the feature to the guest.  E.g. a clever guest could ignore CPUID
and probe the relevant instructions manually by seeing whether or not they #UD.
