Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB6C6C942
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 08:26:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbfGRGZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 02:25:43 -0400
Received: from mga09.intel.com ([134.134.136.24]:1706 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727496AbfGRGZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 02:25:43 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Jul 2019 23:25:42 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,276,1559545200"; 
   d="scan'208";a="191506532"
Received: from unknown (HELO [10.239.13.7]) ([10.239.13.7])
  by fmsmga004.fm.intel.com with ESMTP; 17 Jul 2019 23:25:39 -0700
Message-ID: <5D301232.7080808@intel.com>
Date:   Thu, 18 Jul 2019 14:31:14 +0800
From:   Wei Wang <wei.w.wang@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.7.0
MIME-Version: 1.0
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, xdeguillard@vmware.com, namit@vmware.com,
        akpm@linux-foundation.org, pagupta@redhat.com, riel@surriel.com,
        dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, lcapitulino@redhat.com,
        aarcange@redhat.com, pbonzini@redhat.com,
        alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com
Subject: Re: [PATCH v1] mm/balloon_compaction: avoid duplicate page removal
References: <1563416610-11045-1-git-send-email-wei.w.wang@intel.com> <20190718001605-mutt-send-email-mst@kernel.org>
In-Reply-To: <20190718001605-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/18/2019 12:31 PM, Michael S. Tsirkin wrote:
> On Thu, Jul 18, 2019 at 10:23:30AM +0800, Wei Wang wrote:
>> Fixes: 418a3ab1e778 (mm/balloon_compaction: List interfaces)
>>
>> A #GP is reported in the guest when requesting balloon inflation via
>> virtio-balloon. The reason is that the virtio-balloon driver has
>> removed the page from its internal page list (via balloon_page_pop),
>> but balloon_page_enqueue_one also calls "list_del"  to do the removal.
> I would add here "this is necessary when it's used from
> balloon_page_enqueue_list but not when it's called
> from balloon_page_enqueue".
>
>> So remove the list_del in balloon_page_enqueue_one, and have the callers
>> do the page removal from their own page lists.
>>
>> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> Patch is good but comments need some work.
>
>> ---
>>   mm/balloon_compaction.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
>> index 83a7b61..1a5ddc4 100644
>> --- a/mm/balloon_compaction.c
>> +++ b/mm/balloon_compaction.c
>> @@ -11,6 +11,7 @@
>>   #include <linux/export.h>
>>   #include <linux/balloon_compaction.h>
>>   
>> +/* Callers ensure that @page has been removed from its original list. */
> This comment does not make sense. E.g. balloon_page_enqueue
> does nothing to ensure this. And drivers are not supposed
> to care how the page lists are managed. Pls drop.
>
> Instead please add the following to balloon_page_enqueue:
>
>
> 	Note: drivers must not call balloon_page_list_enqueue on

Probably, you meant balloon_page_enqueue here.

The description for balloon_page_enqueue also seems incorrect:
"allocates a new page and inserts it into the balloon page list."
This function doesn't do any allocation itself.
Plan to reword it: inserts a new page into the balloon page list."

Best,
Wei
