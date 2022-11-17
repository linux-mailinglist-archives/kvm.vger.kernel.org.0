Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58BC62E36E
	for <lists+kvm@lfdr.de>; Thu, 17 Nov 2022 18:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239005AbiKQRva (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 17 Nov 2022 12:51:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234005AbiKQRv2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 17 Nov 2022 12:51:28 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41D77C031;
        Thu, 17 Nov 2022 09:51:27 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id y203so2488166pfb.4;
        Thu, 17 Nov 2022 09:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C1uNPWN9nebG+rk7o8ckVu9MurS/3CN2wIQ6qnCi4S8=;
        b=I9iiKaaIkHrqNpq1tu6TUZ6I5q/eDQVuMRB++ypxVHQJGAsFNyucK23qj/Uxq8Aaf0
         PX6d6kpU8TbtSkalKFG5WleLQubXBaq5cNc559zITy0ATYXj2u0k2M+goK7PmN5L0OCV
         eigr1NxYEAen7ef8zDV0Jbc4LMZAwL+UV/QqGtrpvPQPzmuLxAMe4q1xVcIDAeZhnTWB
         L5MFbcJeuUJ1hVGfL1tev+I0oowcGanqjcela0Q7yLCZHDiSofzDKIgziwU4fl0HOF8R
         KibkX+3u8eLN4E4fG4CqAlEvZQi6fRURrDgUQxi/ebNnRuRHWyCsDiI/H85JTTiHGqlc
         e6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C1uNPWN9nebG+rk7o8ckVu9MurS/3CN2wIQ6qnCi4S8=;
        b=KG4H9sGF4Q/EQb0I2gTqIKuEEbn3CYD6JbfZDWDmldMrEjLyzFe/aG9GgNkMaqDKcx
         6WJbkmbf4sAyzfLEjjupKJWCvv4uzxSMxg+R77jfRSavUy8rs+3SRWzqOpxVsCnzI1em
         j1YtTb0XwypM8GUMrnq7mziaRNM+LjLkGZY/fjZw25SPuupeZSl5Yo7QiSn0uMm/MJqd
         wscecz7OaIBFipTACVZW9bkOEWpmLRjMGbzB/zeEK2tdGew2Au2Nj8MIhr8RtGjSXlBX
         h/PB/QY/ajlMgBy01+2O/J4NagclVty1/rXo1nEvielbCCgyP6vI7nWWlrJtEB9hYThc
         /QqQ==
X-Gm-Message-State: ANoB5pl1qHNbA23MeFhX6jKDVHxxiL3GC7W+09vrcOkUSo5ZXwqHPxQ4
        KUmtDQojVOBASZ6qpoPvCJY=
X-Google-Smtp-Source: AA0mqf4fdkgjMxLFT6ZYTm3erhhaBq9vIp28V/lpTJUCibqzr1iPlGgc+ydKxM7JYiyvNhLTXy+ZkA==
X-Received: by 2002:a05:6a00:330e:b0:56c:d93a:ac5f with SMTP id cq14-20020a056a00330e00b0056cd93aac5fmr3987408pfb.48.1668707487267;
        Thu, 17 Nov 2022 09:51:27 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id c8-20020aa79528000000b005622f99579esm1411455pfp.160.2022.11.17.09.51.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 09:51:26 -0800 (PST)
Date:   Thu, 17 Nov 2022 09:51:25 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Wang, Lei" <lei4.wang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Subject: Re: [PATCH v10 021/108] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20221117175125.GF2350331@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <ebb4beadff8e117d0fb643af4ee310b6608679bf.1667110240.git.isaku.yamahata@intel.com>
 <af953c96-d40e-eccd-5a3e-f00521848f0c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <af953c96-d40e-eccd-5a3e-f00521848f0c@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 16, 2022 at 01:34:46PM +0800,
"Wang, Lei" <lei4.wang@intel.com> wrote:

> > @@ -431,50 +633,65 @@ int tdx_vm_init(struct kvm *kvm)
> >  	return ret;
> >  }
> >  
> > -int tdx_dev_ioctl(void __user *argp)
> > +static int tdx_td_init(struct kvm *kvm, struct kvm_tdx_cmd *cmd)
> >  {
> > -	struct kvm_tdx_capabilities __user *user_caps;
> > -	struct kvm_tdx_capabilities caps;
> > -	struct kvm_tdx_cmd cmd;
> > +	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
> > +	struct kvm_tdx_init_vm *init_vm = NULL;
> > +	struct td_params *td_params = NULL;
> > +	void *entries_end;
> > +	int ret;
> >  
> > -	BUILD_BUG_ON(sizeof(struct kvm_tdx_cpuid_config) !=
> > -		     sizeof(struct tdx_cpuid_config));
> > +	BUILD_BUG_ON(sizeof(*init_vm) != 16 * 1024);
> > +	BUILD_BUG_ON((sizeof(*init_vm) - offsetof(typeof(*init_vm), entries)) /
> > +		     sizeof(init_vm->entries[0]) < KVM_MAX_CPUID_ENTRIES);
> > +	BUILD_BUG_ON(sizeof(struct td_params) != 1024);
> >  
> > -	if (copy_from_user(&cmd, argp, sizeof(cmd)))
> > -		return -EFAULT;
> > -	if (cmd.flags || cmd.error || cmd.unused)
> > +	if (is_td_initialized(kvm))
> >  		return -EINVAL;
> > -	/*
> > -	 * Currently only KVM_TDX_CAPABILITIES is defined for system-scoped
> > -	 * mem_enc_ioctl().
> > -	 */
> > -	if (cmd.id != KVM_TDX_CAPABILITIES)
> > +
> > +	if (cmd->flags)
> >  		return -EINVAL;
> >  
> > -	user_caps = (void __user *)cmd.data;
> > -	if (copy_from_user(&caps, user_caps, sizeof(caps)))
> > -		return -EFAULT;
> > +	init_vm = kzalloc(sizeof(*init_vm), GFP_KERNEL);
> > +	if (copy_from_user(init_vm, (void __user *)cmd->data, sizeof(*init_vm))) {
> 
> Pointer 'init_vm' returned from call to function 'kzalloc' may be NULL and will
> be dereferenced at this line.
> 
> Maybe a NULL-check here is needed?

Yes, thank you for catching it.

Thanks,
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
