Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FE2E348459
	for <lists+kvm@lfdr.de>; Wed, 24 Mar 2021 23:10:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235043AbhCXWKP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Mar 2021 18:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232261AbhCXWJ7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Mar 2021 18:09:59 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0925AC0613DE
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 15:09:58 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id bt4so189868pjb.5
        for <kvm@vger.kernel.org>; Wed, 24 Mar 2021 15:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=B8cQEyenOi6P1dFAPnRKGJMuEeOhjBSY7qxP2TEHV/o=;
        b=lj6TKx0RstOX0gCi1HsZbR1+i32sFs4YgJqVKDqJMqNl9P/JoBwbO2aTapvdiuP0d5
         DUBzUDV4+r6jkyN2lpepyEX/HLGAKoApLDB3/ZFZ7jrzOOBwRnGPJi32vqtxploDw8q1
         2xhcRg8iqo4Uoje6GvexvUjTkiOfFCXWqIfDCogdi6ZVYcl3Rv+mv39+uPPb1UJQ0bAq
         kPBthg+XX84Uy842vs62HsYZxS37Bz66dcdBGKhNLGpXt+qaGBIV9rPIPwlqOLM5a7s5
         d2YGvho3F6mV31G/8IGY/TAGgIePMext3VqLwc+P0J3CSrRxDdUt2MZENf3sS5fMS1iY
         xCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=B8cQEyenOi6P1dFAPnRKGJMuEeOhjBSY7qxP2TEHV/o=;
        b=AM4N4Mwdq+Yhgu6ecSSvYEeJyfFNCzPlG86ldZFtQMd0ovh7aIpB3+uTDw/FIzNhSv
         gB1A9UdEfKtkALmE+z9Ac9FZkZ++rnV4b3/W+RZAGslFWgrPsLaL+hl+YddHs1Rws7qf
         VyaQUqY1msvUkUUdljI3jDVmET6MSwOGCOxlO3bWqIW1QxNbmRKvyEzJQC3WO4TON68v
         CI3ldRTISiaoeriJI8RqC67ITJyt/vg9k34vqzzPzOaWDja5f46QkYrCR7Imee6WqbNx
         SlI+KXWeBHhu9s4OjntbZwae8U64gXzr4aUVvjmz9XqsVzFWpFS3HayEse9qsH6QRPvS
         oj7g==
X-Gm-Message-State: AOAM532bRb9wPkMn2NIU1LMn92tbGaYTjfQwWrbPw59fvSIqj955XNG9
        EjYc9/wfEO/sEYFhRS7pul2QlA==
X-Google-Smtp-Source: ABdhPJwDnC4jlfo2PQVfu3zVk/BwUUsPMSuyyqmtpRY1Zky6hwjMqnenksH0I1CQfv2uSoDEcNT57g==
X-Received: by 2002:a17:90a:ab91:: with SMTP id n17mr5749245pjq.4.1616623798097;
        Wed, 24 Mar 2021 15:09:58 -0700 (PDT)
Received: from google.com ([2620:0:1008:10:7c86:15f3:3afd:ba78])
        by smtp.gmail.com with ESMTPSA id d22sm3418535pjx.24.2021.03.24.15.09.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 15:09:57 -0700 (PDT)
Date:   Wed, 24 Mar 2021 15:09:53 -0700
From:   Vipin Sharma <vipinsh@google.com>
To:     Jacob Pan <jacob.jun.pan@intel.com>
Cc:     tj@kernel.org, mkoutny@suse.com, rdunlap@infradead.org,
        thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com,
        eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org,
        frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com,
        rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org,
        x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [Patch v3 1/2] cgroup: sev: Add misc cgroup controller
Message-ID: <YFu4sdhT7KexlyES@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <20210304231946.2766648-2-vipinsh@google.com>
 <20210319142801.7dcce403@jacob-builder>
 <YFjn7wv/iMO4Isgz@google.com>
 <20210324091701.63c9ce8e@jacob-builder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210324091701.63c9ce8e@jacob-builder>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 24, 2021 at 09:17:01AM -0700, Jacob Pan wrote:
> I didn't mean the users of misc_cgroup will use css directly. I meant if I
> want to use misc cgruop in ioasid.c, I have to do the following to avoid
> undefined css:
> #include <linux/cgroup.h>
> #include <linux/misc_cgroup.h>
> 
> So it might be simpler if you do #include <linux/cgroup.h> inside
> misc_cgroup.h. Then in ioasid.c, I only need to do
> #include <linux/misc_cgroup.h>.

Sorry, I misunderstood the comment first time. I agree with you, I will
add cgroup header file in the misc_cgroup.h after  #ifdef
CONFIG_CGROUP_MISC statement.

Thanks
Vipin
