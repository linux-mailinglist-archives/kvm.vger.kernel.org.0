Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68281621C6B
	for <lists+kvm@lfdr.de>; Tue,  8 Nov 2022 19:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKHSuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Nov 2022 13:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiKHSts (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Nov 2022 13:49:48 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D629166CA5
        for <kvm@vger.kernel.org>; Tue,  8 Nov 2022 10:48:50 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y13so14582698pfp.7
        for <kvm@vger.kernel.org>; Tue, 08 Nov 2022 10:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1L5kOZNHYfCA3IRYVLUmKIQqOspk+Yz3BJ9Q+3CIhRs=;
        b=W78BfCdzW3rFNxBBa9CJ99fIOIknqSWEHZQpGE4CP0gnNR+4VJ+1rYb8sEs0NBsASe
         K4rEBjnnoCJk0a33aTy3cf9rfMp4VkUTZPwynhqWc6xUvWZh5c7hCT/NquaGP8tWiAmk
         hcNg7xenoISlUZ3pmp4wYxBJpQOoNNtgg3hIJ2CWRKxb7/HZIa1PVdjWFm4ksV+cIxq8
         YrF3aINsofbWuXc8co8smgqZQglTdPK9ATlmu723Lc7vcDYFsIrqGa+4SDMwuJYOSwOW
         VL0XN5QRJNpA74ovJB+2axjmbYlMF5U+hQWpwC53WgZLq2bVPa2W9STH+x/xfs2jlapp
         IPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1L5kOZNHYfCA3IRYVLUmKIQqOspk+Yz3BJ9Q+3CIhRs=;
        b=JW7/wx6DlGD/qK+a3BPBNfj1GugbRHY9vY3M/3BMUv1ke9tfJNN3V3snWy+5U9Lrb4
         mK+vaUI01TcTxuWcL8yibYqN/MLQF12Veo3lDy7HELwMVoxWU9SszqcRdosI/dYZ2YEd
         R+9y3qhLUpsfu50D61ziYqQcb/a168vxBqEw0XeLrBWZbQy1wV/2QN0Z2WqgL2SnK3Ub
         lbQa5w9gPSFn75qA8blSxmgkKNcBGtM1XxBKnCdmi/CrrV7btVUWfQWt4FmTe7fKx3MG
         pfvvq8gFJ5aFuEqveB8dXiLdWr+274mHvSQduYjZr9mKVJkOUlOJoNfuUp7XhM1b0URj
         bc+w==
X-Gm-Message-State: ACrzQf1t2Jc0g9jEs9uYxZs7K5COma3NQKw/qjpqYvPuLl7TdhPBML0M
        TqcDS5HA/UjZCjWAGDqhZzuL7w==
X-Google-Smtp-Source: AMsMyM5S9PjQE+J86OOSmzTz+w8ShiglmFoLAyopqlYc5Iemshl9f9rh9AOUnKWCV3mF3rIgtAIvgw==
X-Received: by 2002:a05:6a00:1a44:b0:528:6af7:ff4a with SMTP id h4-20020a056a001a4400b005286af7ff4amr57736839pfv.78.1667933330266;
        Tue, 08 Nov 2022 10:48:50 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id e13-20020a17090301cd00b0018855a22ccfsm7325722plh.91.2022.11.08.10.48.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 10:48:49 -0800 (PST)
Date:   Tue, 8 Nov 2022 18:48:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v10 005/108] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
Message-ID: <Y2qkjnpZsWEFBe6G@google.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <99e5fcf2a7127347816982355fd4141ee1038a54.1667110240.git.isaku.yamahata@intel.com>
 <0feaa13fa5bf45258f2ebb8407eaefadf5c48976.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0feaa13fa5bf45258f2ebb8407eaefadf5c48976.camel@intel.com>
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

On Tue, Nov 08, 2022, Huang, Kai wrote:
> > +int __init tdx_hardware_setup(struct kvm_x86_ops *x86_ops)
> > +{
> > +	int r;
> > +
> > +	if (!enable_ept) {
> > +		pr_warn("Cannot enable TDX with EPT disabled\n");
> > +		return -EINVAL;
> > +	}
> > +
> > +	/* MOVDIR64B instruction is needed. */
> > +	if (!static_cpu_has(X86_FEATURE_MOVDIR64B)) {

Nit unrelated to Kai's comments: use boot_cpu_has(), not static_cpu_has().  This
is run-once code that's not a hot path so there's zero reason to trigger patching.

> > +		pr_warn("Cannot enable TDX with MOVDIR64B supported ");
> 					   ^
> 					   without
> > +		return -ENODEV;
> > +	}
> 
> I think you should explain why MOVDIR64B is required, otherwise this just comes
> out of blue.
> 
> Btw, is this absolutely required?  TDX also supports Li-mode, which doesn't have
> integrity check.  So theoretically with Li-mode, normal zeroing is also OK but
> doesn't need to use MOVDIR64B.
> 
> That being said, do we have a way to tell whether TDX works in Ci or Li mode?
> 
> 
> 
