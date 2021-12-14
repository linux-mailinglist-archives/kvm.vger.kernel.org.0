Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 307F8474B55
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 19:59:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237242AbhLNS7K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 13:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbhLNS7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 13:59:09 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93AEEC06173F
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 10:59:09 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id k4so18059936pgb.8
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 10:59:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2pJn0DfJU16peOh34ZMJkbpyM+0B2Bhu8Trn1zH9ebk=;
        b=hZcka+a/z2kVd/raHjcI+yKiD/3iSxfU57CSOjuWwU2LFFUcq0OVkXzlC0Up+bQ55R
         dKnen7/tVPYa7aW3v0JnkDNtDIRMMx98vvTgj8RparkZEyTz+nrcuC6zpJe3NSYKG5Ns
         qwMo5WY57kYdk4gJl6zALUUy14Ugt4YwhB6xBFqsUYyFI8P9zPe1hYJw2Lckq0wjU53L
         FiO2BFd3ix3wgGoyii9f4NjMEGrGgr0r2p4/ivf36Sbsv+hCM6Qct9CsNUbi/mGWfA1H
         /muhZCDDW1JuDLWfvQ7/RQTVHuZ8RaBP9vus3wot908EBdqi0iWJXd776r/HpPptjKTG
         WWXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2pJn0DfJU16peOh34ZMJkbpyM+0B2Bhu8Trn1zH9ebk=;
        b=nfm3PkHee4tDVJBcirQsKCWLVjzi858cgtObOnIPloBV3pldQZi28Hg2VIwrc0MWqI
         ggmJlLrfKby3nl+bzvGLzHg1xAtiLzO32zDl0NblRTSBIGzSxBCi21bzLbjA1iNmiKPz
         W/PtKnzKipw9ULjmvBzJPIafy/0m23tNow8Z8h47xlTbPeL0uXmKfQXpVJtnZDoNiPBP
         VgkW3YNbeH047ZuLrWFL4QBR9ZY/TsuePEFAguz/iYb7KfPP4C8lUML3sOlQBtLX2wL/
         AdfMMCRTF9mFGcy4dufTfgdqhroGjXlrpsVZ3b42hUmuHxjwUif//1bj9RGB+snyWQVJ
         L71w==
X-Gm-Message-State: AOAM532Nfo8kj5TCwPI9Mvdu6tkH+Qi4aMDGX2774vi2dR99+wH/9MdC
        r8HsVZZuBA1rT9SsosQ2Eyk2tQ==
X-Google-Smtp-Source: ABdhPJzzFcBWligXoCLNbgLyidgfA/ogRQjMhj8JkwTwzFp9582W9LNiU2LYbDKs7gVsy4buG1jzKw==
X-Received: by 2002:aa7:91c3:0:b0:4b0:eebe:49c0 with SMTP id z3-20020aa791c3000000b004b0eebe49c0mr5711259pfa.6.1639508348966;
        Tue, 14 Dec 2021 10:59:08 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o124sm541688pfb.177.2021.12.14.10.59.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 10:59:08 -0800 (PST)
Date:   Tue, 14 Dec 2021 18:59:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, vkuznets@redhat.com, mlevitsk@redhat.com,
        joao.m.martins@oracle.com, stable@vger.kernel.org,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v3] selftests: KVM: avoid failures due to reserved
 HyperTransport region
Message-ID: <YbjpecoDf93xd7GC@google.com>
References: <20211209223040.304355-1-pbonzini@redhat.com>
 <20211214150747.c5xcdjghenunyw5e@gator.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211214150747.c5xcdjghenunyw5e@gator.home>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021, Andrew Jones wrote:
> (Maybe we should stop keeping the vm struct private...)

I'm all in favor of that.  Ditto for the vcpu struct so that we can get rid of
the stupid VCPU_ID code.

I have spent more time than I care to admit trying to do relatively simple things
in the selftests that become unnecessarily complex just because core state like
the vm_fd is hidden from individual tests.
