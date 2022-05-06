Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7A351E113
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 23:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352550AbiEFVdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 17:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444464AbiEFVdQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 17:33:16 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F7D6F4AB;
        Fri,  6 May 2022 14:29:32 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id c9so7930569plh.2;
        Fri, 06 May 2022 14:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6qT9B79QXkLWw17UF4jXkgLnzsIOvLk4zlsmk1fzfpA=;
        b=GvND7ulvJ0NlO8EOj5vYXO3AtWWcVqs0iZMXTw0tKe5MktIsJXcjT9wDj+TMCSW9Li
         RBPsDcKG4kR1+fAkhLTmfqFxdFFxxI/GywIqM3uqDHktjpW3N4l55OExoVNeu0vYDmy1
         XUzIVOq+ghsC7rX3iE3RJTcmDbce9Lhb4vHntWS7Ty8WXzUtymUNgjdXBycqV2t7Qa1W
         jk4wz36U1WMeXLLKjcJoz3kblEc1opFCk0ZtMxiX3KbvxDooJXRhb86ZCw4ovGBx5Y/a
         iRKW2QJLnCLCUIN6CHzM3CUTtzgeQ1igX0UoYIMXbSXDUyY3QvqecA7WDNbLHS69r8Df
         DuGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6qT9B79QXkLWw17UF4jXkgLnzsIOvLk4zlsmk1fzfpA=;
        b=2v5h8H02tB9Xmc4yMgMvFSsWLR4Yaf+khTw99HhVLMSjKtnHuXiFvUZvY0oaM3crjn
         2OiXsDFbGa9O1nANZ92sKGoOJiDOM0dJWBOndsCjDAFmkMWwcdp2fpMC0iee1uxQliYl
         ofJqhdHBjshgiX1U/sQGynqg2WxVOBT2DXMDBxTC1vF3LFDU4XXgJzussPDnZsup4PQq
         oF3tBYKUuKoNSIhobYaUaZE8e1y4rF3TacPuSIGk6iaAsec6NqPTpCGUNPEnj3T0bxMQ
         ZvQ/s3Jjcy72xKmoe5OH1OAB95w7tC8eW+fY5tcL8LyhvKHvDK3flqrTquAhoyVEubk2
         M92g==
X-Gm-Message-State: AOAM5312T5XyssIht7o4E54+3sXGHg3ktR68dxDOGM3SYBeILy9LijHG
        9VWfhBLV331sAs+p+Yb8BDW9KfJb0n0=
X-Google-Smtp-Source: ABdhPJycAKGNm73Ipl+cKSsvVHi+P4RQBndDHDv8gxThLv0xO+9931Wl1u2TGJ//LxrHRhAhoeR4PA==
X-Received: by 2002:a17:902:7104:b0:15e:ddb8:199 with SMTP id a4-20020a170902710400b0015eddb80199mr5728782pll.80.1651872571978;
        Fri, 06 May 2022 14:29:31 -0700 (PDT)
Received: from localhost (c-107-3-154-88.hsd1.ca.comcast.net. [107.3.154.88])
        by smtp.gmail.com with ESMTPSA id s66-20020a637745000000b003c25a7581d9sm3739161pgc.52.2022.05.06.14.29.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 14:29:31 -0700 (PDT)
Date:   Fri, 6 May 2022 14:29:30 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH v6 011/104] KVM: TDX: Initialize TDX module when
 loading kvm_intel.ko
Message-ID: <20220506212930.GA2145958@private.email.ne.jp>
References: <cover.1651774250.git.isaku.yamahata@intel.com>
 <752bc449e13cb3e6874ba2d82f790f6f6018813c.1651774250.git.isaku.yamahata@intel.com>
 <c7c1f8d1-081a-d543-bdb4-6895292c7077@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c7c1f8d1-081a-d543-bdb4-6895292c7077@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, May 06, 2022 at 09:57:09PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 5/6/2022 2:14 AM, isaku.yamahata@intel.com wrote:
> > +int __init tdx_module_setup(void)
> > +{
> > +	const struct tdsysinfo_struct *tdsysinfo;
> > +	int ret = 0;
> > +
> > +	BUILD_BUG_ON(sizeof(*tdsysinfo) != 1024);
> > +	BUILD_BUG_ON(TDX_MAX_NR_CPUID_CONFIGS != 37);
> > +
> > +	ret = tdx_detect();
> > +	if (ret) {
> > +		pr_info("Failed to detect TDX module.\n");
> > +		return ret;
> > +	}
> > +
> > +	ret = tdx_init();
> > +	if (ret) {
> > +		pr_info("Failed to initialize TDX module.\n");
> > +		return ret;
> > +	}
> > +
> > +	tdsysinfo = tdx_get_sysinfo();
> > +	if (tdx_caps.nr_cpuid_configs > TDX_MAX_NR_CPUID_CONFIGS)
> > +		return -EIO;
> 
> It needs to check tdsysinfo->num_cpuid_config against
> TDX_MAX_NR_CPUID_CONFIG
> 
> or move the check down after tdx_caps is initialized.

Thanks for catching it. I'll replace it with tdsysinfo->num_cpuid_config.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
