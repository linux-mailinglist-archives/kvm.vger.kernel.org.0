Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE624369B9
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:48:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232444AbhJURuy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbhJURux (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Oct 2021 13:50:53 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC61C061764
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:48:37 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id kk10so1064326pjb.1
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e5DNxKa5Otm0oE4YbLlrqqZdm2VkUP8ol33qDpsismA=;
        b=ilk5I5mVFzGYKzY8bYr74XYVdNDOQPHh7Zjt6ExEXOYNu+WYEzayAMhZpe9J6D8w3Y
         PasRKF7Ud/M87HGuzNLDrjt3XCeT5BOyL9PZrjs1JOXOYqoLgGSLrkqC52vO09OBf5US
         CQN2+PksRwZ+celgR6bEj7k39onjxoc7kZfmalpBncDeHw2EzOlPItDXchfVDsKKqJoy
         ZiS0+8tPnplNoee3JNUJyNsinQTd+Vf1+2+V1J35DrxvqPXVV2gG1+8jaUa66TMkKkNW
         v1LYi2OZyMo9uOJEcln1nxxN6vbu6AASg+HatmQOJTET9F3zeBcifoUrhlzFQmi32AWV
         hsKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e5DNxKa5Otm0oE4YbLlrqqZdm2VkUP8ol33qDpsismA=;
        b=LmoklVuPphMbZxxBZQXkC5UdliaEjo5OW1vTBk1IOc5oBArrA/1IMRbDC1rWw1248i
         mac0MeG0MpJhDPLFr8gJvv+k/+U7628jqsGNryzfuycWX8MgU696MDLxmsLITHi3onjc
         XpD7W8ceV/pusf/G6OHJ1bF0Z9pV/9I1s4CSol4YI/2+YkVhxptG8UBnrnDr35kxzBzY
         8s7dvfjdJuCsbxYyvXWJd4/kSG4I7fBM371L6leNNjuN1CRcaeEkpRny5xYreEnqdCbO
         CxHJ0ERK3yQzhSVT3kAdMtPN/50WIk/LQxmhTyDL9JmVIreDgwrsXkknBF4LvaUDB9mF
         y5yA==
X-Gm-Message-State: AOAM530jkzSHs57i/DrsAE8aIPRmewdk8V+5ELP/cL7FcEGOkMYzj41H
        hxdpbCm1Vfzxcn2a5m6o5rIFtg==
X-Google-Smtp-Source: ABdhPJyk4diEqPRpH+H81wUYHUOclkQ23jVz7J7Wvf/0v2bllQ8+vGeXHXGmkX04ugQR2F6pUzNqvw==
X-Received: by 2002:a17:90b:4c8d:: with SMTP id my13mr8180693pjb.101.1634838516413;
        Thu, 21 Oct 2021 10:48:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d138sm6682546pfd.74.2021.10.21.10.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 10:48:35 -0700 (PDT)
Date:   Thu, 21 Oct 2021 17:48:31 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 1/2] KVM: x86: Add vendor name to kvm_x86_ops, use it for
 error messages
Message-ID: <YXGn70lhcjulaO3r@google.com>
References: <20211018183929.897461-1-seanjc@google.com>
 <20211018183929.897461-2-seanjc@google.com>
 <87k0i6x0jk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0i6x0jk.fsf@vitty.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 21, 2021, Vitaly Kuznetsov wrote:
> >  	if (ops->disabled_by_bios()) {
> > -		pr_err_ratelimited("kvm: disabled by bios\n");
> > +		pr_err_ratelimited("kvm: support for '%s' disabled by bios\n",
> > +				   ops->runtime_ops->name);
> 
> 
> I'd suggest we change this to 
> 
> 		pr_err_ratelimited("kvm: %s: virtualization disabled in BIOS\n",
> 				   ops->runtime_ops->name);
> 
> or something like that as generally, it makes little sense to search for
> 'KVM' in BIOS settings. You need too look for either 'Virtualization' or
> VT-x/AMD-v.

I'd prefer to avoid VT-x/AMD-v so as not to speculate on the module being loaded
or the underlying hardware, e.g. I've no idea what Hygon, Zhaoxin, etc... use for
"code" names.

What about

		pr_err_ratelimited("kvm: virtualization support for '%s' disabled by BIOS\n",
				   ops->runtime_ops->name);

to add the virtualization flavor but still make it clear that error is coming
from the base kvm module.
