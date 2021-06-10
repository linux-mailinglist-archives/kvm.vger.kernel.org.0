Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7903A2F4F
	for <lists+kvm@lfdr.de>; Thu, 10 Jun 2021 17:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbhFJPbT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Jun 2021 11:31:19 -0400
Received: from mail-pl1-f171.google.com ([209.85.214.171]:33726 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbhFJPbS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Jun 2021 11:31:18 -0400
Received: by mail-pl1-f171.google.com with SMTP id u18so586987plc.0
        for <kvm@vger.kernel.org>; Thu, 10 Jun 2021 08:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+T4qTFDRvTC2LvJQo3vP3ERmcE/xIzNm1o6qGMbHAxw=;
        b=F9ypNfcxJqUDGZ7u0sw/fKZtTa7NzjZhLVcsxZr1Bw/cFytog6Agkcr7lWicM0udzF
         vsG+Pkr3EKKiweC3daELKcjS6sY+FDqKpMReoxwSctEHMYf89K/sgv9TzETASxAd7bZj
         DBLM3AQmDp6IlqHDX/BjNNfxC927fJte6Fk2lxPQjyIUvB0Frf/M5euTt46UOW2Ez3Vf
         zjTB2fVp9XiZ5ByK+FaPDbgoL0vKV/gJjoA4NnSLjxOOi4QRM9rm4KIgZ9Cdqxv8Tlz4
         gjs6mklaxV9p0/SnWUj8sYLggijju0QmZiBrwmiaq1FmvEJQllH92eUu167P7EfURAIX
         RiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+T4qTFDRvTC2LvJQo3vP3ERmcE/xIzNm1o6qGMbHAxw=;
        b=TUFv9kDN7kUQn9AdBW5zysJiku77hszfc8UQe9KUCxsNj0jitiqfY/7yRdHEBRUNlb
         RUi/RXgt4SVm2k/H2tCuisA5RioQL4QpI5stoehvRBCThgsMgGSBkxNsa0pEQ4Tcb+7p
         28Cgwy+rHhSy4zbm3iKgIcBTdhZuKX63zpLlDKBrMDGQ3Q9PioZ3qp9eKR+NVWdkVr3x
         vHUQKnif7vOmebA1d9aZkF4LFiR1gG35u8RiZD0KaRma5LyczhSnsQCKz+6+7X8Uu+UI
         Q73UI9LQUVwendTn96ldRSiSHbxi/gFPV8CvCVUA6WfauIOywxSJ8f4gO8FLYgjv4MOp
         YyNQ==
X-Gm-Message-State: AOAM533Uh91R5PiZ9kxtWNvShH/vdJo5QmVHdCxK/9btyaza1VFFCe4w
        kZ68JtQEe5SZ9owR9hqzWIBSLA==
X-Google-Smtp-Source: ABdhPJxIoFDs3S/6HuQlHPNC7XNv1vbSG9WFj6XH/ecNZE4WneBi6ZRZxcrUOhH+IhYFJ+Ornw2/MA==
X-Received: by 2002:a17:90a:6285:: with SMTP id d5mr3990442pjj.3.1623338888870;
        Thu, 10 Jun 2021 08:28:08 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t1sm2778175pjo.33.2021.06.10.08.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 08:28:08 -0700 (PDT)
Date:   Thu, 10 Jun 2021 15:28:04 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+fb0b6a7e8713aeb0319c@syzkaller.appspotmail.com
Subject: Re: [PATCH 2/9] KVM: x86: Emulate triple fault shutdown if RSM
 emulation fails
Message-ID: <YMIvhAzbbQuWT685@google.com>
References: <20210609185619.992058-1-seanjc@google.com>
 <20210609185619.992058-3-seanjc@google.com>
 <87eedayvkn.fsf@vitty.brq.redhat.com>
 <61e9ec9e-d4f5-bea5-942a-21c259278094@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61e9ec9e-d4f5-bea5-942a-21c259278094@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 10, 2021, Paolo Bonzini wrote:
> On 10/06/21 10:26, Vitaly Kuznetsov wrote:
> > So should we actually have X86EMUL_CONTINUE when we queue
> > KVM_REQ_TRIPLE_FAULT here?
> 
> Yes...
> 
> > (Initially, my comment was supposed to be 'why don't you add
> > TRIPLE_FAULT to smm selftest?' but the above overshadows it)
> 
> ... and a tenth patch to add a selftest would be nice to have indeed.

Yes, I've been remiss in writing/modifying tests, I'll prioritize that once I've
dug myself out of the rabbit holes I wandered into via the vCPU RESET/INIT series.
