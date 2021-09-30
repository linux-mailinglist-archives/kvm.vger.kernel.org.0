Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C29B341E0A8
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 20:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353132AbhI3SKU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 14:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353043AbhI3SKT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 14:10:19 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15055C06176A
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 11:08:37 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id v19so4779360pjh.2
        for <kvm@vger.kernel.org>; Thu, 30 Sep 2021 11:08:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EoZfu8bpen5KFMUVG6jLqzqied/lYe6mK0ma9Cef8Os=;
        b=bXQfSxmBXOfT4WF1wCJ2uHhAn2c04X0SQKHS2xapCL9/Uhsl4XxrYsrnsseZhnbA60
         b3qEkUcxB21kqfR4mXgiff7CBu78x9TTEzl0jDrljzdTFi35bN/2k1dmNFkQpcTLFTtN
         C2Ky2PMllbuODghV5eIb0Yxe1DYKlq4jSZtLsriuQVzE7BwnOUkmePZH1dGOpGKmhIye
         UxrQ77bpWdbAQDK/csIhkwjanA6B3nYpkd89EVa9Gwi3gvs1YvJFs+XoYLjw/9MMVkmm
         kCxoN1yVCaXXDLrTwAI4w+eoV5ZCrwXGMd+XNb100w15ojbpdx+k+/6m6X+PqPdIz+jO
         DG4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EoZfu8bpen5KFMUVG6jLqzqied/lYe6mK0ma9Cef8Os=;
        b=BdVNK5cW3UdYaikGCpfYVHjXd5iWK2ci0dfqfVSaVu0R7jokxng+xwwVaH0zHXCJNE
         vlqYycUuh3lDVW57kHc/5mj7WQCi6TXgwOmMnw1SXMZIHdZ56g4x1suoLaPIlw8yNyE5
         Z3xv3kV5cKzSKGIq5UVrIir/hc5fhvMVkb/uTj/WXMFr+KKv87Cw1wHbXL13xNr+SGEC
         1GD/2gPr8oxlnzPOP+PL3etcwUVt9alK4ySugD8t6wGXDeXapqpqouCYwEr0x4Zssmsl
         lS86rxr9Qlp25WCndEn/yVdU0gt670k75PmVPBs+Phn9ySh0Zugb/OIaD0xjzfvZ5SjB
         qJoA==
X-Gm-Message-State: AOAM532ULDjy1pk9zICU8BfF1o2Mt9oNikwNK39GqHI11370INXafd+U
        cDw8hEs2wJaCE7KO5l1/Ew0ZrQ==
X-Google-Smtp-Source: ABdhPJyofT3EyCRTUH4uH/kvj1uCfmupdajOzWbRL4wny0VfkHxLMQqDTXmIdg75I/pNah8kDYB0sQ==
X-Received: by 2002:a17:90b:38d0:: with SMTP id nn16mr3499466pjb.112.1633025316319;
        Thu, 30 Sep 2021 11:08:36 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id d22sm3668968pgi.73.2021.09.30.11.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Sep 2021 11:08:35 -0700 (PDT)
Date:   Thu, 30 Sep 2021 18:08:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu
Subject: Re: [PATCH v2 05/11] KVM: arm64: Defer WFI emulation as a requested
 event
Message-ID: <YVX9IOb1vyoJowQl@google.com>
References: <20210923191610.3814698-1-oupton@google.com>
 <20210923191610.3814698-6-oupton@google.com>
 <878rzetk0o.wl-maz@kernel.org>
 <YVXvM2kw8PDou4qO@google.com>
 <CAOQ_QsjXs8sF+QY0NrSVBvO4xump7CttBU3et6V3O_hNYmCSig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ_QsjXs8sF+QY0NrSVBvO4xump7CttBU3et6V3O_hNYmCSig@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 30, 2021, Oliver Upton wrote:
> On Thu, Sep 30, 2021 at 10:09 AM Sean Christopherson <seanjc@google.com> wrote:
> > Unlike PSCI power-off, WFI isn't cross-vCPU, thus there's no hard requirement
> > for using a request.  And KVM_REQ_SLEEP also has an additional guard in that it
> > doesn't enter rcuwait if power_off (or pause) was cleared after the request was
> > made, e.g. if userspace stuffed vCPU state and set the vCPU RUNNABLE.
> 
> Yeah, I don't think the punt is necessary for anything but the case
> where userspace sets the MP state to request WFI behavior. A helper
> method amongst all WFI cases is sufficient, and using the deferral for
> everything is a change in behavior.

Is there an actual use case for letting userspace request WFI behavior?
