Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598B86CD72
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2019 13:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbfGRLhZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Jul 2019 07:37:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727692AbfGRLhZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 Jul 2019 07:37:25 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0DE5059465;
        Thu, 18 Jul 2019 11:37:25 +0000 (UTC)
Received: from redhat.com (ovpn-120-147.rdu2.redhat.com [10.10.120.147])
        by smtp.corp.redhat.com (Postfix) with SMTP id A992460C98;
        Thu, 18 Jul 2019 11:37:10 +0000 (UTC)
Date:   Thu, 18 Jul 2019 07:37:06 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, xdeguillard@vmware.com, namit@vmware.com,
        akpm@linux-foundation.org, pagupta@redhat.com, riel@surriel.com,
        dave.hansen@intel.com, david@redhat.com, konrad.wilk@oracle.com,
        yang.zhang.wz@gmail.com, nitesh@redhat.com, lcapitulino@redhat.com,
        aarcange@redhat.com, pbonzini@redhat.com,
        alexander.h.duyck@linux.intel.com, dan.j.williams@intel.com
Subject: Re: [PATCH v2] mm/balloon_compaction: avoid duplicate page removal
Message-ID: <20190718073645-mutt-send-email-mst@kernel.org>
References: <1563442040-13510-1-git-send-email-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563442040-13510-1-git-send-email-wei.w.wang@intel.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Thu, 18 Jul 2019 11:37:25 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

OK almost. Bunch of typos but I fixed them. Thanks!

On Thu, Jul 18, 2019 at 05:27:20PM +0800, Wei Wang wrote:
> Fixes: 418a3ab1e778 (mm/balloon_compaction: List interfaces)
> 
> A #GP is reported in the guest when requesting balloon inflation via
> virtio-balloon. The reason is that the virtio-balloon driver has
> removed the page from its internal page list (via balloon_page_pop),
> but balloon_page_enqueue_one also calls "list_del"  to do the removal.
> This is necessary when it's used from balloon_page_enqueue_list, but
> not from balloon_page_enqueue_one.
> 
> So remove the list_del balloon_page_enqueue_one, and update some
> comments as a reminder.
> 
> Signed-off-by: Wei Wang <wei.w.wang@intel.com>
> ---
> ChangeLong:
> v1->v2: updated some comments
> 
>  mm/balloon_compaction.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
> index 83a7b61..8639bfc 100644
> --- a/mm/balloon_compaction.c
> +++ b/mm/balloon_compaction.c
> @@ -21,7 +21,6 @@ static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
>  	 * memory corruption is possible and we should stop execution.
>  	 */
>  	BUG_ON(!trylock_page(page));
> -	list_del(&page->lru);
>  	balloon_page_insert(b_dev_info, page);
>  	unlock_page(page);
>  	__count_vm_event(BALLOON_INFLATE);
> @@ -33,7 +32,7 @@ static void balloon_page_enqueue_one(struct balloon_dev_info *b_dev_info,
>   * @b_dev_info: balloon device descriptor where we will insert a new page to
>   * @pages: pages to enqueue - allocated using balloon_page_alloc.
>   *
> - * Driver must call it to properly enqueue a balloon pages before definitively
> + * Driver must call it to properly enqueue balloon pages before definitively
>   * removing it from the guest system.
>   *
>   * Return: number of pages that were enqueued.
> @@ -47,6 +46,7 @@ size_t balloon_page_list_enqueue(struct balloon_dev_info *b_dev_info,
>  
>  	spin_lock_irqsave(&b_dev_info->pages_lock, flags);
>  	list_for_each_entry_safe(page, tmp, pages, lru) {
> +		list_del(&page->lru);
>  		balloon_page_enqueue_one(b_dev_info, page);
>  		n_pages++;
>  	}
> @@ -128,13 +128,19 @@ struct page *balloon_page_alloc(void)
>  EXPORT_SYMBOL_GPL(balloon_page_alloc);
>  
>  /*
> - * balloon_page_enqueue - allocates a new page and inserts it into the balloon
> - *			  page list.
> + * balloon_page_enqueue - inserts a new page into the balloon page list.
> + *
>   * @b_dev_info: balloon device descriptor where we will insert a new page to
>   * @page: new page to enqueue - allocated using balloon_page_alloc.
>   *
>   * Driver must call it to properly enqueue a new allocated balloon page
>   * before definitively removing it from the guest system.
> + *
> + * Drivers must not call balloon_page_enqueue on pages that have been
> + * pushed to a list with balloon_page_push before removing them with
> + * balloon_page_pop. To all pages on a list, use balloon_page_list_enqueue
> + * instead.
> + *
>   * This function returns the page address for the recently enqueued page or
>   * NULL in the case we fail to allocate a new page this turn.
>   */
> -- 
> 2.7.4
