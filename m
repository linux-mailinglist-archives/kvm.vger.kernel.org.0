Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E47321266
	for <lists+kvm@lfdr.de>; Mon, 22 Feb 2021 09:55:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhBVIxw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Feb 2021 03:53:52 -0500
Received: from mga05.intel.com ([192.55.52.43]:54164 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230049AbhBVIxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Feb 2021 03:53:51 -0500
IronPort-SDR: vRFphLsTiIUfaBw5Fr0wpqgoyDguLm/OqDmzaRifEAlD77eJQgiGxqHr3rDv2k9cfnWfFPDoQM
 YNseoAgTPp3w==
X-IronPort-AV: E=McAfee;i="6000,8403,9902"; a="269311062"
X-IronPort-AV: E=Sophos;i="5.81,196,1610438400"; 
   d="scan'208";a="269311062"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 00:52:05 -0800
IronPort-SDR: 8UwXaghU0b5vpcSaBbTTIu5PGJ7VyA1pWz7tLKjf5KfXRNlD4UcMB0x2VtoKtVDgRewTTTXWzR
 uR0LxZBMELPQ==
X-IronPort-AV: E=Sophos;i="5.81,196,1610438400"; 
   d="scan'208";a="441317395"
Received: from liujing-mobl.ccr.corp.intel.com (HELO [10.238.130.120]) ([10.238.130.120])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2021 00:51:53 -0800
Subject: Re: [PATCH RFC 3/7] kvm: x86: XSAVE state and XFD MSRs context switch
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <20210207154256.52850-1-jing2.liu@linux.intel.com>
 <20210207154256.52850-4-jing2.liu@linux.intel.com>
 <ae5b0195-b04f-8eef-9e0d-2a46c761d2d5@redhat.com>
 <YCF1d0F0AqPazYqC@google.com>
 <77b27707-721a-5c6a-c00d-e1768da55c64@redhat.com>
 <YCF9GztNd18t1zk/@google.com>
 <c293cdbd-502c-d598-3166-4e177ac21c7a@redhat.com>
 <YCGJHme0fBk+sno3@Konrads-MacBook-Pro.local>
From:   "Liu, Jing2" <jing2.liu@linux.intel.com>
Message-ID: <6b1e9cd9-b545-b027-2cda-aac76824c342@linux.intel.com>
Date:   Mon, 22 Feb 2021 16:51:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YCGJHme0fBk+sno3@Konrads-MacBook-Pro.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2/9/2021 2:55 AM, Konrad Rzeszutek Wilk wrote:
> On Mon, Feb 08, 2021 at 07:12:22PM +0100, Paolo Bonzini wrote:
[...]
>>
>> However, running the host with _more_ bits set than necessary in XFD should
>> not be a problem as long as the host doesn't use the AMX instructions.  So
>> perhaps Jing can look into keeping XFD=0 for as little time as possible, and
>> XFD=host_XFD|guest_XFD as much as possible.
> This sounds like the lazy-fpu (eagerfpu?) that used to be part of the
> kernel? I recall that we had a CVE for that - so it may also be worth
> double-checking that we don't reintroduce that one.
Not sure if this means lazy restore, but the spec mentions that
"System software should not use XFD to implement a 'lazy restore' approach
to management of the XTILEDATA state component." One reason is XSAVE(S)
will lose the xTILEDATA when XFD[i] is nonzero.

Thanks,
Jing
