Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A35DC422DAA
	for <lists+kvm@lfdr.de>; Tue,  5 Oct 2021 18:16:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236500AbhJEQRu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Oct 2021 12:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236485AbhJEQRt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Oct 2021 12:17:49 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7770DC061749
        for <kvm@vger.kernel.org>; Tue,  5 Oct 2021 09:15:58 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h3so9603807pgb.7
        for <kvm@vger.kernel.org>; Tue, 05 Oct 2021 09:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=GwLEdxyokThy1BhwLkkIjlDQTYahii3/ftotf+jxWZU=;
        b=KBrY6bVL0guv/P8GI19rLT1tEJ+jNNatM/gRC4jCeaB2Czi1/MWPe6xbvE5a1whYUv
         +Ktjtufw8ZrCCkTXHAdBvJYs3wmOZEsjxZ9IxyuGfDERxMw4C+f4bYiRVZoTBGmzHvpB
         s/KiRfQXkCrZ3oSo/Ly3MP+wwZ5AyN3OH3TuAbyJuGqOsxOH/E3a1/pWJJjANkWl2Ehu
         KQeEHBeEOwhf16xP9dvUEyMOknZWvVeey51GqCEyCm1VmIxw4We54TGR+jUdd8pF8pZI
         uukqDC1mLzooTJxj3kP867h/Fipgz+NZ3TAAf00OYlmKqx6O2wFNFMeo0Lwyi4SERCLv
         eOCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=GwLEdxyokThy1BhwLkkIjlDQTYahii3/ftotf+jxWZU=;
        b=akgDXaGCcL+yGaZXsYeAT+GuOOzDs4nfMaa7rUrkvjkMI4c9uFdeHhoa1EujCEOcPl
         GRqVbd3H7I1oFo0xq/5Yc0u3lsx13TCPNAYHCVuVzIVCCG1cRAa/p2G6apS3z/Of36ij
         C1FxJnQAdwM0DDrQff1tajbi93gxhv+TiilYIjZXEhmx0um+kBNr4Dr3+EZ8tOTUou4r
         dbmAQU6LbEPggGODaGaApq6WrrSH+oWzAxIjy7tlWUc6T7zewqoc2APQJc2IkTHzr9H+
         T7qzhVEHjRI3epia5iqbpWi7cTk7pgbjdPEYNmuNgWopjyMXHFyqG2nuIWX/4gPwhMcP
         ILfQ==
X-Gm-Message-State: AOAM5328SEvRROvkXft37ZJT4+bObWIAznT3AX3WDlO7PUofofzKnRAD
        1HCG2eUWKTp5XYFKueslWSQxHg==
X-Google-Smtp-Source: ABdhPJxrL3QFfd0zSZT8qN3GX0ZxebCvyY+aoDa2qcWfpoUgsNrRs0qDIMrZ9CnoOe+5PpF5Kxn0sg==
X-Received: by 2002:a63:b20c:: with SMTP id x12mr16492377pge.10.1633450557771;
        Tue, 05 Oct 2021 09:15:57 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id g4sm17563339pgs.42.2021.10.05.09.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Oct 2021 09:15:57 -0700 (PDT)
Date:   Tue, 5 Oct 2021 16:15:53 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     pbonzini@redhat.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        yu.c.zhang@linux.intel.com
Subject: Re: [PATCH v1 3/5] KVM: x86: nVMX: VMCS12 field's read/write
 respects field existence bitmap
Message-ID: <YVx6Oesi7X3jfnaM@google.com>
References: <1629192673-9911-1-git-send-email-robert.hu@linux.intel.com>
 <1629192673-9911-4-git-send-email-robert.hu@linux.intel.com>
 <YRvbvqhz6sknDEWe@google.com>
 <b2bf00a6a8f3f88555bebf65b35579968ea45e2a.camel@linux.intel.com>
 <YR2Tf9WPNEzrE7Xg@google.com>
 <3ac79d874fb32c6472151cf879edfb2f1b646abf.camel@linux.intel.com>
 <YS/lxNEKXLazkhc4@google.com>
 <0b94844844521fc0446e3df0aa02d4df183f8107.camel@linux.intel.com>
 <YTI7K9RozNIWXTyg@google.com>
 <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64aad01b6bffd70fa3170cf262fe5d7c66f6b2d4.camel@linux.intel.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 28, 2021, Robert Hoo wrote:
> On Fri, 2021-09-03 at 15:11 +0000, Sean Christopherson wrote:
> 	You also said, "This is quite the complicated mess for
> something I'm guessing no one actually cares about.  At what point do
> we chalk this up as a virtualization hole and sweep it under the rug?"
> -- I couldn't agree more.

...
 
> So, Sean, can you help converge our discussion and settle next step?

Any objection to simply keeping KVM's current behavior, i.e. sweeping this under
the proverbial rug?
