Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B8C6D85AB
	for <lists+kvm@lfdr.de>; Wed,  5 Apr 2023 20:07:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234034AbjDESHt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Apr 2023 14:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbjDESHo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Apr 2023 14:07:44 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B014A6A6B;
        Wed,  5 Apr 2023 11:07:24 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id q20so13090610pfs.2;
        Wed, 05 Apr 2023 11:07:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680718043; x=1683310043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5D8szEbb5qPo2M2FVF9DKWOsecGUDuIK571QyuULkJc=;
        b=FhEMKhwUSkfECAG2/KB76jTjttWFc0i1AztSeghLYA9e7rnkmM+5HcXa7IqTqgU2Q9
         5rYiWWiqoPov66v+YpC5dLA9zlVLZQYGlaVGwJwXSQ7wTnVoBsEgO3zBQWCVbIn5yyMW
         IQVsZshfyWgv3inpNSeoEVeHP1ChS8a2VDn7zrtSgAErvs4otTRRcy4dM2JJL7icQpAl
         02kSfgQUWAXsUmv64trAfA3ucMbpjU0vROvJ6Yu7UjNoRGkrfOzZG3+1eoJ6z3/txc8r
         FQJOvZ2ZyslnwzeLmsTUOXepPH0GCH4Y1SNEHXLp6/rZrx1Dfc8WM/Y5khILjhJSUPSe
         LuCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680718043; x=1683310043;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5D8szEbb5qPo2M2FVF9DKWOsecGUDuIK571QyuULkJc=;
        b=RKQtQPV0Xcq7Ky9q2OtnPHLY8d+rgD2/NF3/Z4rZ431IGntTGdYqZJRPPsubaNt3tb
         G0kUpYkcr9gxuGNEMAgRQ5dpKJSma3eLWP/ehL0ThrNnA6b8ChKZkFea9QK0h1EryITp
         NFHRzVMXYkneFM3v4Y/92Rf3DG4T0c98+5/DEVmW8uQMddYp4Nxv5kOBQhdVmJzfVHE7
         ll1Km8HLBi6qNBL9GPQILCNzZOEI8eSSKQN8xJ659A6ZNJQF1iDWUrKRFGgndaoMq/X0
         nUna0JANORAMJ+XQt/yFWyHYA0tSUmKmgk7mGocpg/RuQzatp9/c7NLAG3AxBYc3y/+x
         E+7g==
X-Gm-Message-State: AAQBX9c/XbK/CKOhSHhZI7EBjcfj6oq9J6kxifMnRW8g3M7EqTWhgOEy
        YgPBe6DT1ONf5Hv+b0sL5pc=
X-Google-Smtp-Source: AKy350aPPvcUS4Y6d7m2xl9sJdX7AgcXrFTdm9UP9js91UTRvGs4kwOwTQtDdQ5WbNs3+IoChdwu4A==
X-Received: by 2002:aa7:9a4b:0:b0:625:cc03:df34 with SMTP id x11-20020aa79a4b000000b00625cc03df34mr6541199pfj.1.1680718042922;
        Wed, 05 Apr 2023 11:07:22 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id n14-20020aa78a4e000000b0062d942f0ad3sm10956824pfa.51.2023.04.05.11.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 11:07:22 -0700 (PDT)
Date:   Wed, 5 Apr 2023 11:07:20 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH v13 016/113] KVM: TDX: x86: Add ioctl to get TDX
 systemwide parameters
Message-ID: <20230405180720.GF1112017@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <cb0ae8b4941aaa45e1e5856dde644f9b2f53d9a6.1678643052.git.isaku.yamahata@intel.com>
 <20230325104306.00004585@gmail.com>
 <20230329231722.GA1108448@ls.amr.corp.intel.com>
 <20230331001803.GE1112017@ls.amr.corp.intel.com>
 <20230331154432.00001373@gmail.com>
 <24ddf589-34a4-b312-72c1-8176ee3e8b35@intel.com>
 <20230403172835.000040eb.zhi.wang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230403172835.000040eb.zhi.wang.linux@gmail.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 03, 2023 at 05:28:35PM +0300,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Mon, 3 Apr 2023 11:46:15 +0800
> Xiaoyao Li <xiaoyao.li@intel.com> wrote:
> 
> > On 3/31/2023 8:44 PM, Zhi Wang wrote:
> > > On Thu, 30 Mar 2023 17:18:03 -0700
> > > Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> > > 
> > >> On Wed, Mar 29, 2023 at 04:17:22PM -0700,
> > >> Isaku Yamahata <isaku.yamahata@gmail.com> wrote:
> > >>
> > >>> On Sat, Mar 25, 2023 at 10:43:06AM +0200,
> > >>> Zhi Wang <zhi.wang.linux@gmail.com> wrote:
> > >>>
> > >>>> On Sun, 12 Mar 2023 10:55:40 -0700
> > >>>> isaku.yamahata@intel.com wrote:
> > >>>>
> > >>>> Does this have to be a new generic ioctl with a dedicated new x86_ops? SNP
> > >>>> does not use it at all and all the system-scoped ioctl of SNP going through
> > >>>> the CCP driver. So getting system-scope information of TDX/SNP will end up
> > >>>> differently.
> > >>>>
> > >>>> Any thought, Sean? Moving getting SNP system-wide information to
> > >>>> KVM dev ioctl seems not ideal and TDX does not have a dedicated driver like
> > >>>> CCP. Maybe make this ioctl TDX-specific? KVM_TDX_DEV_OP?
> > >>>
> > >>> We only need global parameters of the TDX module, and we don't interact with TDX
> > >>> module at this point.  One alternative is to export those parameters via sysfs.
> > >>> Also the existence of the sysfs node indicates that the TDX module is
> > >>> loaded(initialized?) or not in addition to boot log.  Thus we can drop system
> > >>> scope one.
> > >>> What do you think?
> > >>>
> > > 
> > > I like this idea and the patch below, it feels right for me now. It would be nice
> > > if more folks can chime in and comment.
> > 
> > SYSFS option requires CONFIG_SYSFS, which reqiures CONFIG_KVM_TDX to 
> > select CONFIG_SYSFS.
> > 
> > >>> Regarding to other TDX KVM specific ioctls (KVM_TDX_INIT_VM, KVM_TDX_INIT_VCPU,
> > >>> KVM_TDX_INIT_MEM_REGION, and KVM_TDX_FINALIZE_VM), they are specific to KVM.  So
> > >>> I don't think it can be split out to independent driver.
> > >>
> > > 
> > > They can stay in KVM as they are KVM-specific. SNP also has KVM-specific ioctls
> > > which wraps the SEV driver calls. At this level, both TDX and SNP go their specific
> > > implementation without more abstraction other than KVM_ENCRYPT_MEMORY_OP. Their
> > > strategies are aligned.
> > > 
> > > The problem of the previous approach was the abstraction that no other implementation
> > > is using it. It is like, TDX wants a higher abstraction to cover both TDX and SNP,
> > > but SNP is not using it, which makes the abstraction looks strange.
> > 
> > Note, before this TDX enabling series, KVM_MEMORY_ENCRYPT_OP is a VM 
> > scope ioctl, that only serves for SEV and no other implementation uses 
> > it. I see no reason why cannot introduce a new IOCTL in x86 KVM that 
> > serves only one vendor.
> > 
> 
> My point is: time is different. When KVM_MEMORY_ENCRYPT_OP is there,
> there was *only* one vendor and SEV/SNP didn't know how the future vendor
> is going to use the ioctl. That is a reasonable case an generic ioctl can
> have one vendor to back up.
> 
> The background here is: now another vendor is coming and there are going to
> be two vendors. The two vendors' flows are much clearer than early stage.
> Like, they know which flow is going to be used by each other.
> 
> With these kept in mind, IMHO, it is not appropriate to introduce
> an generic ioctl that only one vendor is going to use, meanwhile
> we have already known another vendor is not going to use it.
> 
> Defining a new userspace ABI is a serious thing and it is not an early
> stage anymore. Actually I think it is the best time to see how the
> code infrastructure should be re-purposed at this time. 
> 
> > We choose KVM_MEMORY_ENCRYPT_OP for TDX platform scope, just because we 
> > reuse KVM_MEMORY_ENCRYPT_OP for TDX VM-scope and extend it to TDX vcpu 
> > scope. It's just to avoid defining a new IOCTL number.
> > 
> > We can rename it to KVM_GET_CC_CAPABILITIES, and even return different 
> > capabilities based on VM type. And even, if SNP wants to use it, I think 
> > it can wrap SNP driver calls inside this IOCTL?
> > 
> 
> I am not opposed to this option as it shows effort to improve it and it
> is constructive. But this needs to be figured out with AMD folks and
> maintainers. E.g. what should be the best CC ioctl scheme for KVM?
> vendor-specific or generic, which brings better benefit for the userspace,
> and less maintenance burden.
> 
> Back to the reason why I think a vendor-specific sysinfo interface for TDX
> is necessary:
> 
> 1) SEV driver has been there for quite some time. Unless people thinks an
> generic CC ioctl scheme is a way to go, then there will be motivation and
> efforts putting on it. The efforts is not only about wrapping SEV ioctls,
> it needs a systematic spec of generic CC ioctl scheme. 
> 
> 2) TDX doesn't have a driver like SEV and possibly not going to have one in
> the future. For those non-KVM related control flow of TDX in future, they
> can re-use this and stay away from KVM interface. (If vendor-specific
> scheme is the future direction.)
> 
> > kvm.ko is special that it needs to serve two vendors. Sometime it's 
> > unaviodable that an interface is only used by one vendor.
> 
> I am afraid that in this case it is avoidable right?

We can make KVM_TDX_CAPABILITIES vm-scoped one so that devoce-scoped
KVM_EMORY_ENCRYPT_OP isn't needed.  At least qemu is fine.

Do you think vm-scoped KVM_TDX_CAPABILITIES is fine?
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
