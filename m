Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECC3833996C
	for <lists+kvm@lfdr.de>; Fri, 12 Mar 2021 23:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbhCLWEW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 17:04:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235375AbhCLWEJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 17:04:09 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23313C061762
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 14:04:09 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id l2so16737378pgb.1
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 14:04:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A4VBsrBTExFTzIIWcPXbIbC/3bW0Rh8AXlm1Zd+kSVM=;
        b=NjH4RVnGKMIxKJmjG8GJYkllQ1jn5WinSXrj5QQRa9jO0Xde2Ix/dTfn+DGEgHo/+J
         e0AnLosaiKgvaYM4ekP9CXZF3svmwXDuzQFYggDL+Ia0bzzGNI9XWw767L0PyW5SdzFY
         AbLfmN3IgXG0tx+lK1z5UYKGYDDCHfa1lYjKyGaED/g9lgURliXZVPqWqGduEPxPSNq0
         MMH7EPiYVB2atFo59ii+Oix5uuvXOfQfvWuPo2eG3hdcApTsYAZPCBbBay6zHq+4TV/d
         NeKYqm6cF1nshehYoz+OGOSBt+Gwtut0ADAcVX9WPyp/b9NTw7VkOcrYyGTqeP0BbV6T
         T8xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A4VBsrBTExFTzIIWcPXbIbC/3bW0Rh8AXlm1Zd+kSVM=;
        b=M2THLfjO1jBGxsj1xNjzU+bB1YLCLBifo5hR4Eob2/0qrlLo8KLkGUyTXtYD6NAa+o
         6UvbPyiRHDNMLMg+ZfcxmG1Juqxd257Ud+Zf3cdhnwOsam4EwFjtKBTMAwsC+jq+RSJC
         gv3ZAqbA3tSUi6xqKSrdcuctYH5xTBiq5owiXtLLEjtX4tv5H51v5pMBHJ8BroohKOM9
         kJDp3TYZdQcMyZkeh/8fWB85XtuleI89CZLqLBGZoacOtCwYQ1lfl5nh1yr/JoF6DSej
         GFvg/Z7TZTIYqhw/g1eJBXm6tjQJIJQjGak0KWWXg9lT9tAvY889yPSJAVo4x2PSuJ8g
         LGOA==
X-Gm-Message-State: AOAM5334Y7whOmZ6MXbVJlW91tE+O+ZPP4Qs3eBoPkS6uWXmZkhAOaNG
        mHgHGq5kmX2OZJBHJy7IaWB8bA==
X-Google-Smtp-Source: ABdhPJzlKX+1AMolFVpoKeUDirUHQ8igoQVFpdlwloDkDpmWVWtEkvEWq9iSY7yLrXxykyepl8xQIw==
X-Received: by 2002:a63:fd50:: with SMTP id m16mr13671152pgj.256.1615586648426;
        Fri, 12 Mar 2021 14:04:08 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id i22sm3032705pjz.56.2021.03.12.14.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 14:04:07 -0800 (PST)
Date:   Fri, 12 Mar 2021 14:04:00 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Borislav Petkov <bp@alien8.de>, Kai Huang <kai.huang@intel.com>,
        kvm@vger.kernel.org, x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org, jarkko@kernel.org, luto@kernel.org,
        dave.hansen@intel.com, rick.p.edgecombe@intel.com,
        haitao.huang@intel.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, jethro@fortanix.com, b.thiel@posteo.de,
        jmattson@google.com, joro@8bytes.org, vkuznets@redhat.com,
        wanpengli@tencent.com, corbet@lwn.net
Subject: Re: [PATCH v2 00/25] KVM SGX virtualization support
Message-ID: <YEvlUIOWGstrgh7H@google.com>
References: <cover.1615250634.git.kai.huang@intel.com>
 <20210309093037.GA699@zn.tnic>
 <51ebf191-e83a-657a-1030-4ccdc32f0f33@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51ebf191-e83a-657a-1030-4ccdc32f0f33@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 09, 2021, Paolo Bonzini wrote:
> On 09/03/21 10:30, Borislav Petkov wrote:
> > On Tue, Mar 09, 2021 at 02:38:49PM +1300, Kai Huang wrote:
> > > This series adds KVM SGX virtualization support. The first 14 patches starting
> > > with x86/sgx or x86/cpu.. are necessary changes to x86 and SGX core/driver to
> > > support KVM SGX virtualization, while the rest are patches to KVM subsystem.
> > 
> > Ok, I guess I'll queue 1-14 once Sean doesn't find anything
> > objectionable then give Paolo an immutable commit to base the KVM stuff
> > ontop.
> 
> Sounds great.

Patches 1-14 look good, just a few minor nits, nothing functional.  I'll look at
the KVM patches next week.

Thanks for picking this up Kai!
