Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A33737C073
	for <lists+kvm@lfdr.de>; Wed, 12 May 2021 16:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231218AbhELOnK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 May 2021 10:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbhELOnJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 May 2021 10:43:09 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38BAC061574
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 07:42:01 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t4so12635753plc.6
        for <kvm@vger.kernel.org>; Wed, 12 May 2021 07:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wxKnnXHLSQ34iKMEdRBK5f1OVmjNy6I5PUfRGXqvHB8=;
        b=lgF1HeKxk78Sh5QaJh95BabfBOw9mQdN47Dv/DglN2CsiJ5IZah3CZe0NGHlcvvUwD
         T315M+jOeTswJWnbg7FKc2JtTuuLPA1WzNzw3INIE9oGhfwoIM2bc/9Iypvee2YmXFB6
         v3VBetJftdb2T4minGSdscKkZZHBYNSypYnxixXA1onKtY5vYo8WRF9YNGNetkEve+9D
         iuZ+k6w3fa3IMCzRfaCB5NYeYDkrsI9hLC+/dFRRoxz6RDWXUgAyXf4rODsmsOrHr1/I
         OSItkRJg3dRb/b9xfHOQfFL3NN8NPfCKMldNXi2kS/9WMk0VzKmOAJO1fjL4Ns9pkZkp
         +CWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wxKnnXHLSQ34iKMEdRBK5f1OVmjNy6I5PUfRGXqvHB8=;
        b=LD4KQW5LMDpS+NU3oCtMDsy19HUUiXyEt1F6rbmA8aC00vrAkQYwpYkNmvYqCrQ0hn
         cjDHFndpU4knowT3NdPUBhxiaqQ3cldrFwqddTCY4NdlbFu8/uT0+bA2e4XVkN+wUPFr
         C8n88CUwHXLEE8CjokjDLFGEgicpXzHzy8JapNNXL1m8PNg1nsiMlM2vWZb6m3xV+vOr
         iE/HgMzKKz6Q+/o5mXdjteg1F75WEC3kpsICZvodxwHo3VK5Olla/bVn3n5nntib23ql
         JpeAAuwZaXkJk0dYD1hYgyrVf5mRJ9ZrLVy09KAaUHg1f9psk7yu+PUgj0KSXSvx1YI4
         ngXA==
X-Gm-Message-State: AOAM532PitpsAMx/X2jdKklGc8jgUiujPlyxHKsp06+1zM67B+i/qqX5
        aC+MzS3j5RmKkRxKYPoVQ+xXOwGP6rzcGw==
X-Google-Smtp-Source: ABdhPJyX02G/Ehe0+iGqUwrV9fQJoo2Z31ZTHpkNU11jEKoGtvNI1dKljZg7sCMCQuoicrJc3uxChQ==
X-Received: by 2002:a17:902:e5cb:b029:ed:64d5:afee with SMTP id u11-20020a170902e5cbb02900ed64d5afeemr35282305plf.41.1620830521252;
        Wed, 12 May 2021 07:42:01 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id j4sm1111598pjm.10.2021.05.12.07.42.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 07:42:00 -0700 (PDT)
Date:   Wed, 12 May 2021 14:41:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Marcelo Tosatti <mtosatti@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Pei Zhang <pezhang@redhat.com>
Subject: Re: [patch 4/4] KVM: VMX: update vcpu posted-interrupt descriptor
 when assigning device
Message-ID: <YJvpNHAILLTghW1L@google.com>
References: <YJV3P4mFA7pITziM@google.com>
 <YJWVAcIsvCaD7U0C@t490s>
 <20210507220831.GA449495@fuller.cnet>
 <YJqXD5gQCfzO4rT5@t490s>
 <20210511145157.GC124427@fuller.cnet>
 <YJqurM+LiyAY+MPO@t490s>
 <20210511171810.GA162107@fuller.cnet>
 <YJr4ravpCjz2M4bp@t490s>
 <20210511235124.GA187296@fuller.cnet>
 <20210512000259.GA192145@fuller.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512000259.GA192145@fuller.cnet>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 11, 2021, Marcelo Tosatti wrote:
> > The KVM_REQ_UNBLOCK patch will resume execution even any such event
> 
> 						  even without any such event
> 
> > occuring. So the behaviour would be different from baremetal.

I agree with Marcelo, we don't want to spuriously unhalt the vCPU.  It's legal,
albeit risky, to do something like

	hlt
	/* #UD to triple fault if this CPU is awakened. */
	ud2

when offlining a CPU, in which case the spurious wake event will crash the guest.
