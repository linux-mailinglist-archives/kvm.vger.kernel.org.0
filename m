Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7835639326A
	for <lists+kvm@lfdr.de>; Thu, 27 May 2021 17:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235959AbhE0P2X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 May 2021 11:28:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235932AbhE0P2T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 May 2021 11:28:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71391C061574
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 08:26:46 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mp9-20020a17090b1909b029015fd1e3ad5aso2571690pjb.3
        for <kvm@vger.kernel.org>; Thu, 27 May 2021 08:26:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g41hxtedvAPuwE0Bgwohmu9YFT1X+9KIiXKB5j94JK0=;
        b=v6RbfHZN4fmzVBDAHhBq4fGupOliqm3C4RorLbjgX1eKh46/G8OnlOsZVCQAsAGFgd
         3k5flTuyj1wm9jsPGyU61yIP1foROUZhGL1HkGzfQysPRSKMki8Al+5oHDu5b99LDBbQ
         ZT2h59wn2k8oi327W04t+82OHLAikBMOJtgXOobpeRmPzvPUMTDhaVJwkP/h0UsCNBs/
         3y2ZC/VYTjieHv8W9VRGvrC/SdzdP2RL3IfzsINHiy2BZ0TNAnXZylw6Vl7Wv8XnHXnY
         4C6GbpiO6EP3ixHcqOPDMOcGOOu3kSp4/K1DS5EaelkwPa+b9npI9e6Jzxvf7Vhq18vh
         0vSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g41hxtedvAPuwE0Bgwohmu9YFT1X+9KIiXKB5j94JK0=;
        b=Tjg1FkrFB2VUPqXoBOlraqEOoK1nvDPBfRwSMGXWc0r8w+ibHlQoMK+tUcK7L8U21J
         eyQEkfXYkeBf6Q0cDxkFGSmgR21Uxkv9WIZ1uQ6K9HTa0yXSp52NH6qgenZM9lx9nhuj
         lH91vKrsOhZqz1vKs+zTtBGfbFNSVu2DPGYYwDUcap3XlfUADXhdnDQF7EehTcZlObtJ
         aniT9DowlMTe36GOGAq+cm+OlWde5Rz5vMCPAQ6zdS+PeTgy+moqKBbpaJvB+BRfgpcp
         7LbVTI0V6+xlxUIC2oFBSioDlh1e9fcUhAiPw2VI0Q6cnG0o/Zmi8K4Qc4JWnqlLdQyA
         VeCQ==
X-Gm-Message-State: AOAM531GdzyMxf2R33I0uX3FgZHbx8yr+UvKlTad1xL/F7fKes/BvBsb
        +KXV57VFe8POsK3f6yHoh6Q+Hg==
X-Google-Smtp-Source: ABdhPJzqQ75fPMFPAqqOHuJR82LI+ByIXCaHpYZ5DmitW6UIrwx+jhfulftdroLX41iYe6tVyNj4Pw==
X-Received: by 2002:a17:902:9304:b029:fb:9edd:e628 with SMTP id bc4-20020a1709029304b02900fb9edde628mr3737519plb.73.1622129205811;
        Thu, 27 May 2021 08:26:45 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id s2sm2233709pjz.41.2021.05.27.08.26.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 08:26:45 -0700 (PDT)
Date:   Thu, 27 May 2021 15:26:41 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ben Gardon <bgardon@google.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Subject: Re: [PATCH v2 00/13] More parallel operations for the TDP MMU
Message-ID: <YK+6MdxA61gkxmzP@google.com>
References: <20210401233736.638171-1-bgardon@google.com>
 <c630df18-c1af-8ece-37d2-3db5dc18ecc8@redhat.com>
 <YK6+9lmToiFTpvmq@google.com>
 <822c0a82-2609-bd76-2bb6-43134271bccf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <822c0a82-2609-bd76-2bb6-43134271bccf@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 27, 2021, Paolo Bonzini wrote:
> On 26/05/21 23:34, Sean Christopherson wrote:
> > > Applied to kvm/mmu-notifier-queue, thanks.
> > What's the plan for kvm/mmu-notifier-queue?  More specifically, are the hashes
> > stable, i.e. will non-critical review feedback get squashed?  I was finally
> > getting around to reviewing this, but what's sitting in that branch doesn't
> > appear to be exactly what's posted here.  If the hashes are stable, I'll probably
> > test and review functionality, but not do a thorough review.
> 
> It's all in 5.13 except for the lock elision patch, for which I was waiting
> for a review.  I'll post that patch separately.

Ha, stable indeed.  Thanks!
