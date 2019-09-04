Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB74A8D71
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732103AbfIDQ6E (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:58:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:22382 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbfIDQ6E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:58:04 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Sep 2019 09:58:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,467,1559545200"; 
   d="scan'208";a="185172468"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.41])
  by orsmga003.jf.intel.com with ESMTP; 04 Sep 2019 09:58:03 -0700
Date:   Wed, 4 Sep 2019 09:58:03 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        kvm list <kvm@vger.kernel.org>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 2/4] KVM: nVMX: Check GUEST_DR7 on vmentry of nested
 guests
Message-ID: <20190904165803.GE24079@linux.intel.com>
References: <20190829205635.20189-1-krish.sadhukhan@oracle.com>
 <20190829205635.20189-3-krish.sadhukhan@oracle.com>
 <CALMp9eSekWEvvgwhMXWOtRZG1saQDOaKr+_4AacuM9JtH5guww@mail.gmail.com>
 <a4882749-a5cc-f8cd-4641-dd61314e6312@oracle.com>
 <CALMp9eTBPRT+Re9rZzmutAiy62qSMQRfMrnyiYkNHkCKDy-KPQ@mail.gmail.com>
 <CALMp9eRWSvg22JPUKOssOHwOq=uXn6GumXP1-LB2ZiYbd0N6bQ@mail.gmail.com>
 <e229bea2-acb2-e268-6281-d8e467c3282e@oracle.com>
 <CALMp9eTObQkBrKpN-e=ejD8E5w3WpbcNkXt2gJ46xboYwR+b7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eTObQkBrKpN-e=ejD8E5w3WpbcNkXt2gJ46xboYwR+b7Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 04, 2019 at 09:44:58AM -0700, Jim Mattson wrote:
> On Tue, Sep 3, 2019 at 5:59 PM Krish Sadhukhan
> <krish.sadhukhan@oracle.com> wrote:
> > Is it OK to keep this Guest check in software for now and then remove it
> > once we have a solution in place ?
> 
> Why do you feel that getting the priority correct is so important for
> this one check in particular? I'd be surprised if any hypervisor ever
> assembled a VMCS that failed this check.

Agreed.  I don't see much value in adding a subset of guest state checks,
and adding every check will be painfully slow.  IMO we're better off
finding a solution that allows deferring guest state checks to hardware.
