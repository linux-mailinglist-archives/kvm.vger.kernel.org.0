Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6143B44CF32
	for <lists+kvm@lfdr.de>; Thu, 11 Nov 2021 02:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbhKKBru (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Nov 2021 20:47:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbhKKBrt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Nov 2021 20:47:49 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CD1C061767
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 17:45:01 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id x7so2953842pjn.0
        for <kvm@vger.kernel.org>; Wed, 10 Nov 2021 17:45:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vIpqkuXH/BEP47oEfxhMZ9/fTD6xVKLD28FU3QaYHLg=;
        b=mM69LO5YQ6sqQc8Le0frsg9F3hqNgWpT2kCUVE55Ec6XVmIu9DQfmszelkI97gfwre
         014Qezf+KDo6iflV5bNvhE7KfBAhkKVXODMe6VNdoJINHgisiEgTQMquKsqFV1fm185d
         MwUEn8MkPQjzJdo2iB1Bd93EX6f+U4I79VFK6n7okZD9nkY6Mq3xdiK05S14/iKUzlnk
         VWCy0+U54EA1ov52EvgFXy3IzMYePujUrjR7lUA/p944Zx2YMyq7wxpoUei96DYgq8y8
         vtVwALtuZUMMRDqXM47ZoctqCW52q7b6ty/7uCZ/gEaK4AqntWFTy58VUdVPUldxW6S0
         jFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vIpqkuXH/BEP47oEfxhMZ9/fTD6xVKLD28FU3QaYHLg=;
        b=7pUnCjIvMJRBEBiT5mpv8G7kYuJ+HAXCL6PFwU86mp5TjhtSPDNm8cyJ8wDS01EBH5
         OkM4LSZv3h0fGmLY1vAjTKkBoXVWxVMbu9dA58a6Zk5a5qJqQ+Yx9HMPSDW0VM4ukN9f
         3L4hjUsu1GT7xiW5ZzhdHe16bfpesfQe/y3TFG2LW6iKTuQQiFxpeY3K4ByL0g/V8++Y
         TI1IR9vCUr8bfdyEicw2NM6UEIo2A+xBUGkCL9HHmJBAabecny6FXZGmbZfrqzmHKJH8
         TRCRrYjdTWzMLdT5XVQLRt7TYXzei2zEXBZMEVSrZzZA0faLn2Qgm9SXo0nf1bZSwPWu
         iJJA==
X-Gm-Message-State: AOAM531wbhchzHSRDXRmCwtZtQ20uMno/D/1jSkPrdutNPjVRChhqDPY
        LEgBM9YEs588ojUoiN5/Zo3GVauqfmSs9A==
X-Google-Smtp-Source: ABdhPJw65Cs7XdtqOeDTy0swpntsrIFQd+3JADjeMBvvt4fWbOcVc3oGGNi04LpHcIEZAJqhVlKzlg==
X-Received: by 2002:a17:90b:350c:: with SMTP id ls12mr4066067pjb.197.1636595100452;
        Wed, 10 Nov 2021 17:45:00 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id a8sm860341pfv.176.2021.11.10.17.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 17:44:59 -0800 (PST)
Date:   Thu, 11 Nov 2021 01:44:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Peter Xu <peterx@redhat.com>,
        Peter Shier <pshier@google.com>,
        David Matlack <dmatlack@google.com>,
        Mingwei Zhang <mizhang@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        Kai Huang <kai.huang@intel.com>,
        Keqian Zhu <zhukeqian1@huawei.com>,
        David Hildenbrand <david@redhat.com>
Subject: Re: [RFC 11/19] KVM: x86/mmu: Factor shadow_zero_check out of
 make_spte
Message-ID: <YYx1mDJo/L79cKOH@google.com>
References: <20211110223010.1392399-1-bgardon@google.com>
 <20211110223010.1392399-12-bgardon@google.com>
 <80407e4a-36e1-e606-ed9f-74429f850e77@redhat.com>
 <CANgfPd8hzDU+v52t9Kr=b48utC1p_j3yJ8gHzo-uifAxHbh-eQ@mail.gmail.com>
 <YYxvSfUPTXbclpSa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYxvSfUPTXbclpSa@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 11, 2021, Sean Christopherson wrote:
> These are all related to guest context:
> 	int (*page_fault)(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
> 	void (*inject_page_fault)(struct kvm_vcpu *vcpu,
> 				  struct x86_exception *fault);

That's incorrect, page_fault() and inject_page_fault() could be per-VM.  Neither
is particularly interesting though.
