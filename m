Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11146718B30
	for <lists+kvm@lfdr.de>; Wed, 31 May 2023 22:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbjEaUaS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 May 2023 16:30:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjEaUaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 May 2023 16:30:17 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4763D101;
        Wed, 31 May 2023 13:30:16 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 46e09a7af769-6af6db17a27so116022a34.2;
        Wed, 31 May 2023 13:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685565015; x=1688157015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TkKYKkqHcR+9f2etlgEJShv7Ao181m9IUBoJvwooid4=;
        b=q3UJCkngDungWbExd8FMG+IqZ3el7slhuQ5k459Pj7t1aQWnHBfrXnV/O2nlhHW4NA
         yVmr2WMTtFmRTpvV5Lg6y5Dssam9eGm4yLiPNjhP4QreDp8iy4EjF111Tt0UBB1+4wrh
         INzptlB6b80GLLZ42TVeQ38KGWHkgu3cyIUIjHHZiyu289/jaGgLfLnPSqhvMYXpViE7
         IjpHh4iTut9MBSTtyMsh3RWoTrtHX2lIWNlEcD/EURrceCLf9XihEsMLPhrGt81yi0As
         S6r0t1UWQEt4YMZM/oqWk0Ocks2p9RdTaXIcj5i8nMGVmdYLaiM+jhFjaGJcz+snLL7+
         4/Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685565015; x=1688157015;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TkKYKkqHcR+9f2etlgEJShv7Ao181m9IUBoJvwooid4=;
        b=W602xVON+ILY0s+Qf9xAT4fpNuwChW7WdhNP4XAy9wxn1aoazexR5iRrS/Dfe/VRv8
         LMMloYVUESMq7sDNtSwAb8zN7AYKXgRZN1P4nY34bo/SU5IWCCHtXgrw4OXJ4XQy5EX+
         OkDWSIfSyaqkyvROAcyeGjYqO5UDEGyu6QQO3C0ox7t/847EITtv+hdIvlh8ohthw2yD
         z/08JRZHHzPfiwoXsmlNEg8dBrqt09fVoLEilVd6+BmKXtMeLxLen+0SlOxrn13I682d
         Gbc1/vz5Sh/FDCT0eQlzWqG9hmXD34XbVko3etM6J71uPqvnvaXtCl5VThbERA5BgT+9
         1XFA==
X-Gm-Message-State: AC+VfDyUZbVQDEFDmWYTmUCaoE+3bavdBGWGTNH4B1BEYd1+hHfbmFqE
        Mvf3GNQj/Swb4bQdKLf+f3E=
X-Google-Smtp-Source: ACHHUZ7z/vRygPB0842T2OD1oupQlVa7qdWy1B3CYPo4fysVtlk5UiHXG9Chk43oIADEQNyUzGxDdA==
X-Received: by 2002:a05:6358:714:b0:123:36a2:7936 with SMTP id e20-20020a056358071400b0012336a27936mr865081rwj.27.1685565015312;
        Wed, 31 May 2023 13:30:15 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id i8-20020a654848000000b0050f85ef50d1sm1585890pgs.26.2023.05.31.13.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 13:30:14 -0700 (PDT)
Date:   Wed, 31 May 2023 13:30:12 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com
Subject: Re: [PATCH v14 003/113] KVM: x86/vmx: Refactor KVM VMX module
 init/exit functions
Message-ID: <20230531203012.GG1234772@ls.amr.corp.intel.com>
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <4ef61085333e97e0ae48c3d7603042b9801e3608.1685333727.git.isaku.yamahata@intel.com>
 <20230531093950.00007e7d.zhi.wang.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230531093950.00007e7d.zhi.wang.linux@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 31, 2023 at 09:57:18AM +0800,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> > +static int __init vt_init(void)
> > +{
> > +	unsigned int vcpu_size, vcpu_align;
> > +	int r;
> > +
> > +	if (!kvm_is_vmx_supported())
> > +		return -EOPNOTSUPP;
> > +
> > +	/*
> > +	 * Note, hv_init_evmcs() touches only VMX knobs, i.e. there's nothing
> > +	 * to unwind if a later step fails.
> > +	 */
> > +	hv_init_evmcs();
> > +
> > +	r = kvm_x86_vendor_init(&vt_init_ops);
> > +	if (r)
> > +		return r;
> > +
> > +	r = vmx_init();
> > +	if (r)
> > +		goto err_vmx_init;
> > +
> > +	/*
> > +	 * Common KVM initialization _must_ come last, after this, /dev/kvm is
> > +	 * exposed to userspace!
> > +	 */
> > +	vcpu_size = sizeof(struct vcpu_vmx);
> > +	vcpu_align = __alignof__(struct vcpu_vmx);
> > +	r = kvm_init(vcpu_size, vcpu_align, THIS_MODULE);
> > +	if (r)
> > +		goto err_kvm_init;
> > +
> > +	return 0;
> > +
> ---------------------------------
> > +err_kvm_init:
> > +	vmx_exit();
> > +err_vmx_init:
> > +	kvm_x86_vendor_exit();
> > +	return r;
> > +}
> > +module_init(vt_init);
> > +
> ----------------------------------
> > +static void vt_exit(void)
> > +{
> > +	kvm_exit();
> > +	kvm_x86_vendor_exit();
> > +	vmx_exit();
> ----------------------------------
> 
> It seems the exiting sequences above are a little bit different with
> each other (PS: It is not a prob introduced in this patch):
> 
> vmx_exit()
> kvm_x86_vendor_exit()
> ....
> 
> and
> 
> ...
> kvm_x86_vnedor_exit()
> vmx_exit()
> 
> I was wondering which one should be correct. Literally, the exiting
> sequence would be in reversing order of the initialization sequence.

In theory, I think kvm_x86_vendor_exit() => vmx_exit() and
vmx_init() => kvm_x86_vendor_exit() should be the right order.
But in practice, it doesn't matter and I didn't want to touch the order with
this patch series.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
