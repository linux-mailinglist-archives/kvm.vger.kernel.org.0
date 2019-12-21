Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F321286AB
	for <lists+kvm@lfdr.de>; Sat, 21 Dec 2019 03:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbfLUCwi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 21:52:38 -0500
Received: from mga03.intel.com ([134.134.136.65]:48624 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726537AbfLUCwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 21:52:38 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2019 18:52:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,338,1571727600"; 
   d="scan'208";a="228782618"
Received: from allen-box.sh.intel.com (HELO [10.239.159.136]) ([10.239.159.136])
  by orsmga002.jf.intel.com with ESMTP; 20 Dec 2019 18:52:34 -0800
Cc:     baolu.lu@linux.intel.com, "Raj, Ashok" <ashok.raj@intel.com>,
        "Kumar, Sanjay K" <sanjay.k.kumar@intel.com>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        "Tian, Kevin" <kevin.tian@intel.com>,
        "Sun, Yi Y" <yi.y.sun@intel.com>, Peter Xu <peterx@redhat.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 0/7] Use 1st-level for IOVA translation
To:     "Liu, Yi L" <yi.l.liu@intel.com>, Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>
References: <20191219031634.15168-1-baolu.lu@linux.intel.com>
 <A2975661238FB949B60364EF0F2C25743A13A364@SHSMSX104.ccr.corp.intel.com>
From:   Lu Baolu <baolu.lu@linux.intel.com>
Message-ID: <ae36c46f-b16d-09a4-9edb-ded3a31332e6@linux.intel.com>
Date:   Sat, 21 Dec 2019 10:51:38 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <A2975661238FB949B60364EF0F2C25743A13A364@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Yi,

Thanks for the comments.

On 12/20/19 7:50 PM, Liu, Yi L wrote:
> Hi Baolu,
> 
> In a brief, this version is pretty good to me. However, I still want
> to have the following checks to see if anything missed. Wish it
> helps.
> 
> 1) would using IOVA over FLPT default on?
> My opinion is that before we have got gIOVA nested translation
> done for passthru devices, we should make this feature as off.

No worry.

IOVA over first level is a sub-feature of scalable mode. Currently,
scalable mode is default off and we won't switch it on until all
features are done.

> 
> 2) the domain->agaw is somehow calculated according to the
> capabilities related to second level page table. As we are moving
> IOVA to FLPT, I'd suggest to calculate domain->agaw with the
> translation modes FLPT supports (e.g. 4 level and 5 level)

We merged first level and second level, hence the domain->agaw should be
selected for both. The only shortcoming of this is that it doesn't
support a 3-only second level in scalable mode. But I don't think we
have any chances to see such hardware.

> 
> 3) Per VT-d spec, FLPT has canonical requirement to the input
> addresses. So I'd suggest to add some enhance regards to it.
> Please refer to chapter 3.6 :-).

Yes. Good catch! We should manipulate the page table entry according to
this requirement.

> 
> 3.6 First-Level Translation
> First-level translation restricts the input-address to a canonical address (i.e., address bits 63:N have
> the same value as address bit [N-1], where N is 48-bits with 4-level paging and 57-bits with 5-level
> paging). Requests subject to first-level translation by remapping hardware are subject to canonical
> address checking as a pre-condition for first-level translation, and a violation is treated as a
> translation-fault.
> 
> Regards,
> Yi Liu

Best regards,
baolu
