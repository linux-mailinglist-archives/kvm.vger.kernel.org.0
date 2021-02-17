Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1980E31DD16
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 17:15:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhBQQOg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 11:14:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234135AbhBQQNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 11:13:52 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6797CC061756
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 08:13:12 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id ba1so7662071plb.1
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 08:13:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=30obSL6wNoXFckVZgqPZYM3QP6QIWGyiK7vFvnqdzsc=;
        b=uMcxqdXTNNbAbHrPi3G1vCKyjA5zEkRIsBX4o5BMlHNrbUndUYMFl3/Nn2C4stNK67
         47C3V5ZBfV4pPQpdrUjEtvQimOKxcpNoJqVmiaT1eg19JROswfZEOvUeVycCpVOTWueO
         E8C5xkypv0DAHJz0zWUprp2lflWttCQ8nV/dlqVPr12YIcv6QoI9x6pLkKqm4UcFvFks
         rRu9azNmLqRHl0mcfSUcuzS7JeqXkGIfaOZYwsGQ2hSjBVUROEJMU3FU+N49Hf95pAC5
         jv4GiyvYx2ef8pjKB+Z/5lz1frOibN1bwOvKaj31tt+fly7rxZaS4KvxQg2RDLhmtWA+
         mDbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=30obSL6wNoXFckVZgqPZYM3QP6QIWGyiK7vFvnqdzsc=;
        b=eCCzeZExsTiG1uWszu/StDPfXGZOVboTuD9+4ibnBc4nGbnjirvIHCveLp3Sk6O0xK
         f9TaeH9Qhao2HohNMhs7HlwtcuKSHNxF4xAQT9Km6xa8SlbcAbID2rm8OH0jG6tj+meI
         cNsbgGi2tHhyF6nzRiUY83gIZWnxXHvaLRo4Z4OH/tCqzGFjQ0qPqJ1hSDBLDreWACh2
         FS/4YBLHvOmIwTHTaQf5jVAYWYhouOkzlE6oGHvXYBIFlpix5q76DRA2xHTrWrFhVtC3
         HMBbC4rq3ORy0xr29mN13KIC5Udy+QBL2JOGq9BXDEI9kbkOu7Lno8WloDHHApxsJdnR
         zfxQ==
X-Gm-Message-State: AOAM533eUjaAtLAply/zZGCE7NLgM/ZOa16F9oX3y3JHoBo4oXOJGYH8
        EcpZnkz6KZUCGdVoKHdLitkNWw==
X-Google-Smtp-Source: ABdhPJyfKy2Cz1wXMvzNBd+cA8KhTW+umCAlEIA2Ctay8I7b4LKIUZ2LOEJzneCCMkuYOtND/wuWbA==
X-Received: by 2002:a17:90a:1503:: with SMTP id l3mr9758253pja.41.1613578391687;
        Wed, 17 Feb 2021 08:13:11 -0800 (PST)
Received: from google.com ([2620:15c:f:10:6948:259b:72c6:5517])
        by smtp.gmail.com with ESMTPSA id 8sm3129452pfp.171.2021.02.17.08.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 08:13:11 -0800 (PST)
Date:   Wed, 17 Feb 2021 08:13:04 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "Kalra, Ashish" <Ashish.Kalra@amd.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "joro@8bytes.org" <joro@8bytes.org>, "bp@suse.de" <bp@suse.de>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "srutherford@google.com" <srutherford@google.com>,
        "venu.busireddy@oracle.com" <venu.busireddy@oracle.com>,
        "Singh, Brijesh" <brijesh.singh@amd.com>
Subject: Re: [PATCH v10 10/16] KVM: x86: Introduce KVM_GET_SHARED_PAGES_LIST
 ioctl
Message-ID: <YC1AkNPNET+T928c@google.com>
References: <cover.1612398155.git.ashish.kalra@amd.com>
 <7266edd714add8ec9d7f63eddfc9bbd4d789c213.1612398155.git.ashish.kalra@amd.com>
 <YCxrV4u98ZQtInOE@google.com>
 <SN6PR12MB2767168CA61257A85B29C26D8E869@SN6PR12MB2767.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SN6PR12MB2767168CA61257A85B29C26D8E869@SN6PR12MB2767.namprd12.prod.outlook.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 17, 2021, Kalra, Ashish wrote:
> From: Sean Christopherson <seanjc@google.com> 
> On Thu, Feb 04, 2021, Ashish Kalra wrote:
> > From: Brijesh Singh <brijesh.singh@amd.com>
> > 
> > The ioctl is used to retrieve a guest's shared pages list.
> 
> >What's the performance hit to boot time if KVM_HC_PAGE_ENC_STATUS is passed
> >through to userspace?  That way, userspace could manage the set of pages >in
> >whatever data structure they want, and these get/set ioctls go away.
> 
> What is the advantage of passing KVM_HC_PAGE_ENC_STATUS through to user-space
> ?
> 
> As such it is just a simple interface to get the shared page list via the
> get/set ioctl's. simply an array is passed to these ioctl to get/set the
> shared pages list.

It eliminates any probability of the kernel choosing the wrong data structure,
and it's two fewer ioctls to maintain and test.

> >Also, aren't there plans for an in-guest migration helper?  If so, do we
> >have any idea what that interface will look like?  E.g. if we're going to
> >end up with a full >fledged driver in the guest, why not bite the bullet now
> >and bypass KVM entirely?
> 
> Even the in-guest migration helper will be using page encryption status
> hypercalls, so some interface is surely required.

If it's a driver with a more extensive interace, then the hypercalls can be
replaced by a driver operation.  That's obviously a big if, though.

> Also the in-guest migration will be mainly an OVMF component, won't  really
> be a full fledged kernel driver in the guest.

Is there code and/or a description of what the proposed helper would look like?
