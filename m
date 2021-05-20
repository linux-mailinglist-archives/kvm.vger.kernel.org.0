Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1512E38B244
	for <lists+kvm@lfdr.de>; Thu, 20 May 2021 16:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhETOyl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 May 2021 10:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231421AbhETOyk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 May 2021 10:54:40 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57C31C061760
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 07:53:16 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id q6so9263898pjj.2
        for <kvm@vger.kernel.org>; Thu, 20 May 2021 07:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vQcY0Xb/bnRM442yoig0bz7ByCX/0XeNT9Llz2TuLng=;
        b=ol7Mw1eMZa4TGFZ+jbXHQap9IUTd5BzCGhKwOXemS759Tur1PbzE/42lkvS1Ur2Hnq
         X9Vvs6SbteBSfRkPdmPT0c8Me78e5OVbPkf3MrzLfRGfUeTtNVZSavM4QiaEvp+IZCNQ
         bQsAJ6XuDUo+4Ocl9wQTejj/0RML2Ih+tj+//RcYtejmReDmkpEn/EGSLBs9S7/+OqKo
         0LqcY+c55Gx9elcoDQEGJVMo+1XiNA4f2cl7RVYArlfh4GDhq0QYbHGZOv7MMWwZQ3HB
         nsMDCHyfaygNcVpcGye/qeiq97HKyte+Er8mDfnKspo3EZYN9tbw9lESyQRhs3Gq+Wx+
         69ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vQcY0Xb/bnRM442yoig0bz7ByCX/0XeNT9Llz2TuLng=;
        b=QfTudFeJbucw2ZKSWWqMyJwysv0YbiNWCuBW+0HtpwlXnuhHXq8ezq0lCBTUHK4I7a
         EvjciN+Nl0s8ECoYAqpAmqncXRW6P1kTrkim+vqaBDdwdiYoMMKhba8fR7/ZeT3QGc4J
         3cOLvFL/9jsihYnVLaVyD8uSS0N8Z8ZUvl0TZl5ZsOZf/cBPn9yT1PTPh1KtOZwReVZF
         nQH2eDuXJN6AA6Lf4vzGhkvLhKTdITQ+pWAXgL2GBJI87uwsIS2x66W5S6GAiDLZeAhX
         CnBAWvQpFek2sF7Hzo8qplKg5zNUP/GeWhkRLdhghQhHj1eY9zuMALektOPXFEkU3cnT
         iL9A==
X-Gm-Message-State: AOAM533fyP6WZURjWy3DGkrum+HbDAmoSf21IdxpxhfzP8Tad2srAdki
        30PhCpHzF/WgvfxnwE/f3I18/JFW7nJImA==
X-Google-Smtp-Source: ABdhPJw14+wdOWAtxB7UTkHMqN6FJbKEYH8+bWpPR/G/o4UaU/6dr+L0385KFBNpy+d0FrR/gfOj2g==
X-Received: by 2002:a17:90a:e7c6:: with SMTP id kb6mr5182893pjb.81.1621522395981;
        Thu, 20 May 2021 07:53:15 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id p36sm2416930pgm.74.2021.05.20.07.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 07:53:15 -0700 (PDT)
Date:   Thu, 20 May 2021 14:53:11 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Subject: Re: [PATCH 2/4 v2] KVM: nVMX: nSVM: 'nested_run' should count
 guest-entry attempts that make it to guest code
Message-ID: <YKZ3115oZOB7eH5d@google.com>
References: <20210520005012.68377-1-krish.sadhukhan@oracle.com>
 <20210520005012.68377-3-krish.sadhukhan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210520005012.68377-3-krish.sadhukhan@oracle.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 19, 2021, Krish Sadhukhan wrote:
> Currently, the 'nested_run' statistic counts all guest-entry attempts,
> including those that fail during vmentry checks on Intel and during
> consistency checks on AMD. Convert this statistic to count only those
> guest-entries that make it past these state checks and make it to guest
> code. This will tell us the number of guest-entries that actually executed
> or tried to execute guest code.
> 
> Also, rename this statistic to 'nested_runs' since it is a count.
> 
> Signed-off-by: Krish Sadhukhan <Krish.Sadhukhan@oracle.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>

I didn't suggest this, or at least I didn't intend to.  My point was that _if_
we want stat.nested_run to count successful VM-Enter then the counter should be
bumped only after VM-Enter succeeds.  I did not mean to say that we should
actually do this.  As Dongli pointed out[*], there is value in tracking attempts,
and I still don't understand _why_ we care about only counting successful
VM-Enters.

FWIW, this misses the case where L1 enters L2 in an inactive state.

[*] ed4a8dae-be99-0d88-a8dd-510afe7cb956@oracle.com
