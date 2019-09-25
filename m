Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19192BD89A
	for <lists+kvm@lfdr.de>; Wed, 25 Sep 2019 08:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405321AbfIYG4y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 25 Sep 2019 02:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48166 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404826AbfIYG4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 25 Sep 2019 02:56:54 -0400
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 07EBB46288
        for <kvm@vger.kernel.org>; Wed, 25 Sep 2019 06:56:54 +0000 (UTC)
Received: by mail-pl1-f200.google.com with SMTP id m8so2753498plt.14
        for <kvm@vger.kernel.org>; Tue, 24 Sep 2019 23:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ijT0fpBaBgG6WmvEUpSA+esMu5WxoRviWQWfgADFoo4=;
        b=L+F5oFqhzzTZa1ZKOCT0loteQxajO8kfcTr4yzZ1XBgBzEz0C1xFlKPrnXFYSCjYYb
         b4aAhQoF1Kw19Mddx5/zjWODg/AiU7Ujfq6vAaRiNae81KfkK+u60NyV9sOyrUT4nOEO
         eab4Agk9SVHvcWGUqVCzsBq/WwMyCdEArJIayeHR5XPtA0d7bVwYGzFuBf6cimK/FpvM
         CE6rhgh106VPVvXCEEOJ/Moc9mK3L7o+rB8OTV/MMvn5TxF9OWmfUFwqJPydMQhf1lAF
         IZ3YoQ+07DtpZrTomWlATfD8qpQaOGEbPtKlp3Hs9rIbX/4oNDNbFnQGoh1/yVivFPcS
         /3gA==
X-Gm-Message-State: APjAAAWu4BlwyZjhklyjc9P/vNruKfnu+dpI8S3NmRZ5KEU3T0QWfaOt
        /Sgdy76j+dOaI3dSbDhlBEVA9BEgk7uZvTW+7QNTVk4q8LlKhK78CMVQK5TbzfyhGA1Mz2ITNTh
        V3YgstQuJDdSd
X-Received: by 2002:aa7:91d4:: with SMTP id z20mr8178153pfa.131.1569394613574;
        Tue, 24 Sep 2019 23:56:53 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyEQscMvlt2r5p9VzQw9b3ybPcThukuDsFI9KDVwsVjgxUw63WdPiTX25gqJqaKL+BCyIqXjg==
X-Received: by 2002:aa7:91d4:: with SMTP id z20mr8178134pfa.131.1569394613417;
        Tue, 24 Sep 2019 23:56:53 -0700 (PDT)
Received: from xz-x1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g24sm6184543pgn.90.2019.09.24.23.56.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Sep 2019 23:56:52 -0700 (PDT)
Date:   Wed, 25 Sep 2019 14:56:40 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Lu Baolu <baolu.lu@linux.intel.com>
Cc:     "Tian, Kevin" <kevin.tian@intel.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 0/4] Use 1st-level for DMA remapping in guest
Message-ID: <20190925065640.GO28074@xz-x1>
References: <20190923122454.9888-1-baolu.lu@linux.intel.com>
 <20190923122715.53de79d0@jacob-builder>
 <20190923202552.GA21816@araj-mobl1.jf.intel.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D58D1F1@SHSMSX104.ccr.corp.intel.com>
 <dfd9b7a2-5553-328a-08eb-16c8a3a2644e@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dfd9b7a2-5553-328a-08eb-16c8a3a2644e@linux.intel.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 25, 2019 at 10:48:32AM +0800, Lu Baolu wrote:
> Hi Kevin,
> 
> On 9/24/19 3:00 PM, Tian, Kevin wrote:
> > > > >       '-----------'
> > > > >       '-----------'
> > > > > 
> > > > > This patch series only aims to achieve the first goal, a.k.a using
> > first goal? then what are other goals? I didn't spot such information.
> > 
> 
> The overall goal is to use IOMMU nested mode to avoid shadow page table
> and VMEXIT when map an gIOVA. This includes below 4 steps (maybe not
> accurate, but you could get the point.)
> 
> 1) GIOVA mappings over 1st-level page table;
> 2) binding vIOMMU 1st level page table to the pIOMMU;
> 3) using pIOMMU second level for GPA->HPA translation;
> 4) enable nested (a.k.a. dual stage) translation in host.
> 
> This patch set aims to achieve 1).

Would it make sense to use 1st level even for bare-metal to replace
the 2nd level?

What I'm thinking is the DPDK apps - they have MMU page table already
there for the huge pages, then if they can use 1st level as the
default device page table then it even does not need to map, because
it can simply bind the process root page table pointer to the 1st
level page root pointer of the device contexts that it uses.

Regards,

-- 
Peter Xu
